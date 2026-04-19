import 'dart:math' as math;
import 'calculator_logic.dart';
import '../models/calculator_mode.dart';

class ExpressionParser {
  final AngleMode angleMode;

  ExpressionParser({this.angleMode = AngleMode.degrees});

  /// Main entry: evaluate a mathematical expression string
  String evaluate(String expression, {int precision = 6}) {
    try {
      // Pre-process the expression
      String processed = _preprocess(expression);
      // Parse and evaluate using recursive descent
      final result = _parseExpression(processed, 0);
      if (result.pos < processed.length) {
        throw FormatException('Unexpected character at position ${result.pos}');
      }
      return CalculatorLogic.formatResult(result.value, precision);
    } catch (e) {
      if (e is ArgumentError || e is FormatException) {
        return 'Error';
      }
      return 'Error';
    }
  }

  /// Pre-process: handle implicit multiplication, replace symbols
  String _preprocess(String expr) {
    expr = expr.replaceAll(' ', '');
    expr = expr.replaceAll('×', '*');
    expr = expr.replaceAll('÷', '/');
    expr = expr.replaceAll('−', '-');
    expr = expr.replaceAll('π', '(${math.pi})');
    expr = expr.replaceAll('e', '(${math.e})');
    // But preserve "exp" and function names containing 'e'
    expr = expr.replaceAll('sin', 'SIN');
    expr = expr.replaceAll('cos', 'COS');
    expr = expr.replaceAll('tan', 'TAN');
    expr = expr.replaceAll('asin', 'ASIN');
    expr = expr.replaceAll('acos', 'ACOS');
    expr = expr.replaceAll('atan', 'ATAN');
    expr = expr.replaceAll('ln', 'LN');
    expr = expr.replaceAll('log', 'LOG');
    expr = expr.replaceAll('sqrt', 'SQRT');
    expr = expr.replaceAll('cbrt', 'CBRT');

    // Handle implicit multiplication: 2(3) -> 2*(3), )(  -> )*(
    StringBuffer result = StringBuffer();
    for (int i = 0; i < expr.length; i++) {
      result.write(expr[i]);
      if (i + 1 < expr.length) {
        final current = expr[i];
        final next = expr[i + 1];
        // number followed by '(' or letter
        if ((_isDigit(current) || current == ')') &&
            (next == '(' || _isLetter(next))) {
          result.write('*');
        }
        // ')' followed by number
        if (current == ')' && (_isDigit(next))) {
          result.write('*');
        }
      }
    }

    return result.toString();
  }

  bool _isDigit(String c) => c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;
  bool _isLetter(String c) =>
      (c.codeUnitAt(0) >= 65 && c.codeUnitAt(0) <= 90) ||
      (c.codeUnitAt(0) >= 97 && c.codeUnitAt(0) <= 122);

  // Recursive descent parser
  // Expression = Term (('+' | '-') Term)*
  _Result _parseExpression(String expr, int pos) {
    var result = _parseTerm(expr, pos);
    while (result.pos < expr.length) {
      final op = expr[result.pos];
      if (op != '+' && op != '-') break;
      final right = _parseTerm(expr, result.pos + 1);
      if (op == '+') {
        result = _Result(result.value + right.value, right.pos);
      } else {
        result = _Result(result.value - right.value, right.pos);
      }
    }
    return result;
  }

  // Term = Power (('*' | '/') Power)*
  _Result _parseTerm(String expr, int pos) {
    var result = _parsePower(expr, pos);
    while (result.pos < expr.length) {
      final op = expr[result.pos];
      if (op != '*' && op != '/' && op != '%') break;
      final right = _parsePower(expr, result.pos + 1);
      if (op == '*') {
        result = _Result(result.value * right.value, right.pos);
      } else if (op == '/') {
        if (right.value == 0) throw ArgumentError('Division by zero');
        result = _Result(result.value / right.value, right.pos);
      } else {
        result = _Result(result.value % right.value, right.pos);
      }
    }
    return result;
  }

  // Power = Unary ('^' Unary)*
  _Result _parsePower(String expr, int pos) {
    var result = _parseUnary(expr, pos);
    while (result.pos < expr.length && expr[result.pos] == '^') {
      final right = _parseUnary(expr, result.pos + 1);
      result = _Result(
        math.pow(result.value, right.value).toDouble(),
        right.pos,
      );
    }
    return result;
  }

  // Unary = '-' Unary | '+' Unary | Atom
  _Result _parseUnary(String expr, int pos) {
    if (pos < expr.length && expr[pos] == '-') {
      final result = _parseUnary(expr, pos + 1);
      return _Result(-result.value, result.pos);
    }
    if (pos < expr.length && expr[pos] == '+') {
      return _parseUnary(expr, pos + 1);
    }
    return _parseAtom(expr, pos);
  }

  // Atom = Number | '(' Expression ')' | Function '(' Expression ')' | Factorial
  _Result _parseAtom(String expr, int pos) {
    // Function call
    for (final func in [
      'ASIN',
      'ACOS',
      'ATAN',
      'SIN',
      'COS',
      'TAN',
      'LN',
      'LOG',
      'SQRT',
      'CBRT',
    ]) {
      if (expr.substring(pos).startsWith(func)) {
        int funcEnd = pos + func.length;
        if (funcEnd < expr.length && expr[funcEnd] == '(') {
          final inner = _parseExpression(expr, funcEnd + 1);
          if (inner.pos >= expr.length || expr[inner.pos] != ')') {
            throw FormatException('Missing closing parenthesis');
          }
          double value = inner.value;
          double result;
          switch (func) {
            case 'SIN':
              result = CalculatorLogic.sin(value, angleMode);
              break;
            case 'COS':
              result = CalculatorLogic.cos(value, angleMode);
              break;
            case 'TAN':
              result = CalculatorLogic.tan(value, angleMode);
              break;
            case 'ASIN':
              result = CalculatorLogic.asin(value, angleMode);
              break;
            case 'ACOS':
              result = CalculatorLogic.acos(value, angleMode);
              break;
            case 'ATAN':
              result = CalculatorLogic.atan(value, angleMode);
              break;
            case 'LN':
              result = CalculatorLogic.ln(value);
              break;
            case 'LOG':
              result = CalculatorLogic.log10(value);
              break;
            case 'SQRT':
              result = CalculatorLogic.squareRoot(value);
              break;
            case 'CBRT':
              result = CalculatorLogic.cubeRoot(value);
              break;
            default:
              throw FormatException('Unknown function: $func');
          }
          return _Result(result, inner.pos + 1);
        }
      }
    }

    // Parentheses
    if (pos < expr.length && expr[pos] == '(') {
      final result = _parseExpression(expr, pos + 1);
      if (result.pos >= expr.length || expr[result.pos] != ')') {
        throw FormatException('Missing closing parenthesis');
      }
      var atomResult = _Result(result.value, result.pos + 1);
      // Check for factorial after parentheses
      if (atomResult.pos < expr.length && expr[atomResult.pos] == '!') {
        atomResult = _Result(
          CalculatorLogic.factorial(atomResult.value),
          atomResult.pos + 1,
        );
      }
      return atomResult;
    }

    // Number
    int start = pos;
    while (pos < expr.length && (_isDigit(expr[pos]) || expr[pos] == '.')) {
      pos++;
    }
    if (pos == start) {
      throw FormatException('Expected number at position $start');
    }
    double value = double.parse(expr.substring(start, pos));

    // Check for factorial
    if (pos < expr.length && expr[pos] == '!') {
      value = CalculatorLogic.factorial(value);
      pos++;
    }

    return _Result(value, pos);
  }
}

class _Result {
  final double value;
  final int pos;
  _Result(this.value, this.pos);
}
