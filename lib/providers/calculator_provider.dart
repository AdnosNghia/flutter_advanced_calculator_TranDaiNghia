import 'package:flutter/foundation.dart';
import '../models/calculator_mode.dart';
import '../models/calculation_history.dart';
import '../utils/expression_parser.dart';
import '../utils/calculator_logic.dart';
import '../services/storage_service.dart';

class CalculatorProvider extends ChangeNotifier {
  final StorageService _storage;

  String _expression = '';
  String _result = '0';
  String _previousExpression = '';
  CalculatorMode _mode = CalculatorMode.basic;
  AngleMode _angleMode = AngleMode.degrees;
  double _memoryValue = 0.0;
  bool _hasMemory = false;
  int _decimalPrecision = 6;
  bool _isSecondFunction = false;
  bool _hasError = false;

  // Programmer mode
  int _currentBase = 10;

  CalculatorProvider(this._storage);

  // Getters
  String get expression => _expression;
  String get result => _result;
  String get previousExpression => _previousExpression;
  CalculatorMode get mode => _mode;
  AngleMode get angleMode => _angleMode;
  double get memoryValue => _memoryValue;
  bool get hasMemory => _hasMemory;
  int get decimalPrecision => _decimalPrecision;
  bool get isSecondFunction => _isSecondFunction;
  bool get hasError => _hasError;
  int get currentBase => _currentBase;

  Future<void> init() async {
    _memoryValue = await _storage.loadMemory();
    _hasMemory = _memoryValue != 0.0;
    final modeIndex = await _storage.loadMode();
    _mode = CalculatorMode.values[modeIndex.clamp(0, 2)];
    notifyListeners();
  }

  void setDecimalPrecision(int precision) {
    _decimalPrecision = precision;
    notifyListeners();
  }

  void setAngleMode(AngleMode mode) {
    _angleMode = mode;
    notifyListeners();
  }

  void toggleSecondFunction() {
    _isSecondFunction = !_isSecondFunction;
    notifyListeners();
  }

  void setMode(CalculatorMode newMode) {
    _mode = newMode;
    _storage.saveMode(newMode.index);
    clear();
    notifyListeners();
  }

  void setBase(int base) {
    _currentBase = base;
    // Re-display current value in new base
    if (_result != '0' && _result != 'Error') {
      try {
        int intVal = int.parse(_result);
        _result = CalculatorLogic.toBase(intVal, base);
      } catch (_) {}
    }
    notifyListeners();
  }

  void appendToExpression(String value) {
    if (_hasError) {
      _expression = '';
      _hasError = false;
    }
    _expression += value;
    notifyListeners();
  }

  void appendNumber(String number) {
    if (_hasError) {
      _expression = '';
      _result = '0';
      _hasError = false;
    }
    _expression += number;
    notifyListeners();
  }

  void appendOperator(String op) {
    if (_hasError) {
      // Allow continuing from previous result
      _expression = _result != 'Error' ? _result : '';
      _hasError = false;
    }
    if (_expression.isEmpty && _result != '0' && _result != 'Error') {
      _expression = _result;
    }
    // Avoid double operators
    if (_expression.isNotEmpty) {
      final last = _expression[_expression.length - 1];
      if (['+', '-', '×', '÷', '%'].contains(last)) {
        _expression = _expression.substring(0, _expression.length - 1);
      }
    }
    _expression += op;
    notifyListeners();
  }

  void appendDecimal() {
    if (_hasError) {
      _expression = '0';
      _hasError = false;
    }
    // Find the last number segment
    final parts = _expression.split(RegExp(r'[+\-×÷%\(\)]'));
    final lastPart = parts.isNotEmpty ? parts.last : '';
    if (!lastPart.contains('.')) {
      if (_expression.isEmpty ||
          !RegExp(r'[0-9]').hasMatch(_expression[_expression.length - 1])) {
        _expression += '0';
      }
      _expression += '.';
    }
    notifyListeners();
  }

  void appendParenthesis() {
    if (_hasError) {
      _expression = '';
      _hasError = false;
    }
    // Count open and close parentheses
    int openCount = '('.allMatches(_expression).length;
    int closeCount = ')'.allMatches(_expression).length;

    if (_expression.isEmpty ||
        _expression.endsWith('(') ||
        [
          '+',
          '-',
          '×',
          '÷',
          '%',
        ].contains(_expression[_expression.length - 1])) {
      _expression += '(';
    } else if (openCount > closeCount) {
      _expression += ')';
    } else {
      _expression += '(';
    }
    notifyListeners();
  }

  void toggleSign() {
    if (_expression.isNotEmpty) {
      if (_expression.startsWith('-')) {
        _expression = _expression.substring(1);
      } else {
        _expression = '-$_expression';
      }
    } else if (_result != '0' && _result != 'Error') {
      if (_result.startsWith('-')) {
        _result = _result.substring(1);
      } else {
        _result = '-$_result';
      }
    }
    notifyListeners();
  }

  void deleteLastCharacter() {
    if (_expression.isNotEmpty) {
      // Check if the last part is a function name
      final funcPatterns = [
        'sin(',
        'cos(',
        'tan(',
        'asin(',
        'acos(',
        'atan(',
        'ln(',
        'log(',
        'sqrt(',
        'cbrt(',
      ];
      bool found = false;
      for (final func in funcPatterns) {
        if (_expression.toLowerCase().endsWith(func)) {
          _expression = _expression.substring(
            0,
            _expression.length - func.length,
          );
          found = true;
          break;
        }
      }
      if (!found) {
        _expression = _expression.substring(0, _expression.length - 1);
      }
      notifyListeners();
    }
  }

  void clear() {
    _expression = '';
    _result = '0';
    _previousExpression = '';
    _hasError = false;
    notifyListeners();
  }

  void clearEntry() {
    _expression = '';
    _hasError = false;
    notifyListeners();
  }

  CalculationHistory? calculateResult() {
    if (_expression.isEmpty) return null;

    final parser = ExpressionParser(angleMode: _angleMode);
    final evalResult = parser.evaluate(
      _expression,
      precision: _decimalPrecision,
    );

    _previousExpression = _expression;

    if (evalResult == 'Error') {
      _result = 'Error';
      _hasError = true;
      notifyListeners();
      return null;
    }

    _result = evalResult;
    final history = CalculationHistory(
      expression: _expression,
      result: _result,
      timestamp: DateTime.now(),
      mode: _mode.name,
    );
    _expression = '';
    notifyListeners();
    return history;
  }

  // Scientific functions
  void applyFunction(String funcName) {
    if (_hasError) {
      _expression = '';
      _hasError = false;
    }
    _expression += '$funcName(';
    notifyListeners();
  }

  void applySquare() {
    if (_expression.isNotEmpty) {
      _expression = '($_expression)^2';
    } else if (_result != '0' && _result != 'Error') {
      _expression = '($_result)^2';
    }
    notifyListeners();
  }

  void applySqrt() {
    if (_hasError) {
      _expression = '';
      _hasError = false;
    }
    if (_expression.isEmpty && _result != '0' && _result != 'Error') {
      _expression = 'sqrt($_result)';
    } else {
      _expression += 'sqrt(';
    }
    notifyListeners();
  }

  void applyPower() {
    if (_expression.isEmpty && _result != '0' && _result != 'Error') {
      _expression = '$_result^';
    } else if (_expression.isNotEmpty) {
      _expression += '^';
    }
    notifyListeners();
  }

  void insertConstant(String constant) {
    if (_hasError) {
      _expression = '';
      _hasError = false;
    }
    _expression += constant;
    notifyListeners();
  }

  void applyFactorial() {
    if (_expression.isNotEmpty) {
      _expression = '($_expression)!';
    } else if (_result != '0' && _result != 'Error') {
      _expression = '($_result)!';
    }
    notifyListeners();
  }

  // Memory functions
  void memoryAdd() {
    double val = double.tryParse(_result) ?? 0;
    _memoryValue += val;
    _hasMemory = true;
    _storage.saveMemory(_memoryValue);
    notifyListeners();
  }

  void memorySubtract() {
    double val = double.tryParse(_result) ?? 0;
    _memoryValue -= val;
    _hasMemory = _memoryValue != 0;
    _storage.saveMemory(_memoryValue);
    notifyListeners();
  }

  void memoryRecall() {
    _expression += CalculatorLogic.formatResult(
      _memoryValue,
      _decimalPrecision,
    );
    notifyListeners();
  }

  void memoryClear() {
    _memoryValue = 0.0;
    _hasMemory = false;
    _storage.saveMemory(0.0);
    notifyListeners();
  }

  // Programmer mode operations
  void applyBitwiseOp(String op, String secondOperand) {
    try {
      int a = CalculatorLogic.parseBase(_result);
      int b = CalculatorLogic.parseBase(secondOperand);
      int res;
      switch (op) {
        case 'AND':
          res = CalculatorLogic.bitwiseAnd(a, b);
          break;
        case 'OR':
          res = CalculatorLogic.bitwiseOr(a, b);
          break;
        case 'XOR':
          res = CalculatorLogic.bitwiseXor(a, b);
          break;
        case 'NOT':
          res = CalculatorLogic.bitwiseNot(a);
          break;
        case '<<':
          res = CalculatorLogic.leftShift(a, b);
          break;
        case '>>':
          res = CalculatorLogic.rightShift(a, b);
          break;
        default:
          return;
      }
      _result = CalculatorLogic.toBase(res, _currentBase);
      notifyListeners();
    } catch (_) {
      _result = 'Error';
      _hasError = true;
      notifyListeners();
    }
  }
}
