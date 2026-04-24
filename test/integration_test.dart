import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab3_advanced_calculator/providers/calculator_provider.dart';
import 'package:lab3_advanced_calculator/providers/theme_provider.dart';
import 'package:lab3_advanced_calculator/providers/history_provider.dart';
import 'package:lab3_advanced_calculator/services/storage_service.dart';
import 'package:lab3_advanced_calculator/models/calculator_mode.dart';
import 'package:lab3_advanced_calculator/models/calculation_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('CalculatorProvider Integration Tests', () {
    late StorageService storage;
    late CalculatorProvider calcProvider;
    late HistoryProvider historyProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = StorageService();
      await storage.init();
      calcProvider = CalculatorProvider(storage);
      historyProvider = HistoryProvider(storage);
      await calcProvider.init();
      await historyProvider.init();
    });

    test('Button press sequence: 5 + 3 = 8', () {
      calcProvider.appendNumber('5');
      calcProvider.appendOperator('+');
      calcProvider.appendNumber('3');
      final entry = calcProvider.calculateResult();
      expect(calcProvider.result, '8');
      expect(entry, isNotNull);
      expect(entry!.expression, '5+3');
      expect(entry.result, '8');
    });

    test('Button press sequence: (5+3)×2-4÷2 = 14', () {
      calcProvider.appendToExpression('(');
      calcProvider.appendNumber('5');
      calcProvider.appendOperator('+');
      calcProvider.appendNumber('3');
      calcProvider.appendToExpression(')');
      calcProvider.appendOperator('×');
      calcProvider.appendNumber('2');
      calcProvider.appendOperator('-');
      calcProvider.appendNumber('4');
      calcProvider.appendOperator('÷');
      calcProvider.appendNumber('2');
      final entry = calcProvider.calculateResult();
      expect(calcProvider.result, '14');
      expect(entry, isNotNull);
    });

    test('Chain calculation: 5 + 3 = then + 2 = then + 1', () {
      calcProvider.appendNumber('5');
      calcProvider.appendOperator('+');
      calcProvider.appendNumber('3');
      calcProvider.calculateResult();
      expect(calcProvider.result, '8');

      calcProvider.appendOperator('+');
      calcProvider.appendNumber('2');
      calcProvider.calculateResult();
      expect(calcProvider.result, '10');

      calcProvider.appendOperator('+');
      calcProvider.appendNumber('1');
      calcProvider.calculateResult();
      expect(calcProvider.result, '11');
    });

    test('Mode switching preserves state correctly', () {
      calcProvider.appendNumber('5');
      calcProvider.setMode(CalculatorMode.scientific);
      expect(calcProvider.expression, '');
      expect(calcProvider.mode, CalculatorMode.scientific);

      calcProvider.setMode(CalculatorMode.programmer);
      expect(calcProvider.mode, CalculatorMode.programmer);

      calcProvider.setMode(CalculatorMode.basic);
      expect(calcProvider.mode, CalculatorMode.basic);
    });

    test('Memory operations: 5 M+ 3 M+ MR = 8', () {
      calcProvider.appendNumber('5');
      calcProvider.calculateResult();
      calcProvider.memoryAdd();

      calcProvider.clear();
      calcProvider.appendNumber('3');
      calcProvider.calculateResult();
      calcProvider.memoryAdd();

      calcProvider.clear();
      calcProvider.memoryRecall();
      calcProvider.calculateResult();
      expect(calcProvider.result, '8');
    });

    test('Memory clear resets memory', () {
      calcProvider.appendNumber('5');
      calcProvider.calculateResult();
      calcProvider.memoryAdd();
      expect(calcProvider.hasMemory, true);

      calcProvider.memoryClear();
      expect(calcProvider.hasMemory, false);
      expect(calcProvider.memoryValue, 0.0);
    });

    test('Delete last character', () {
      calcProvider.appendNumber('1');
      calcProvider.appendNumber('2');
      calcProvider.appendNumber('3');
      expect(calcProvider.expression, '123');

      calcProvider.deleteLastCharacter();
      expect(calcProvider.expression, '12');

      calcProvider.deleteLastCharacter();
      expect(calcProvider.expression, '1');
    });

    test('Toggle sign', () {
      calcProvider.appendNumber('5');
      calcProvider.toggleSign();
      expect(calcProvider.expression, '-5');

      calcProvider.toggleSign();
      expect(calcProvider.expression, '5');
    });

    test('Clear vs ClearEntry', () {
      calcProvider.appendNumber('5');
      calcProvider.appendOperator('+');
      calcProvider.appendNumber('3');
      calcProvider.calculateResult();
      expect(calcProvider.result, '8');

      calcProvider.appendNumber('2');
      calcProvider.clearEntry();
      expect(calcProvider.expression, '');
      expect(calcProvider.result, '8');

      calcProvider.clear();
      expect(calcProvider.expression, '');
      expect(calcProvider.result, '0');
    });

    test('Angle mode switching', () {
      calcProvider.setAngleMode(AngleMode.radians);
      expect(calcProvider.angleMode, AngleMode.radians);

      calcProvider.setAngleMode(AngleMode.degrees);
      expect(calcProvider.angleMode, AngleMode.degrees);
    });

    test('Error state on division by zero', () {
      calcProvider.appendNumber('5');
      calcProvider.appendOperator('÷');
      calcProvider.appendNumber('0');
      calcProvider.calculateResult();
      expect(calcProvider.hasError, true);
      expect(calcProvider.result, 'Error');
    });

    test('Scientific function: sin(90)', () {
      calcProvider.setMode(CalculatorMode.scientific);
      calcProvider.applyFunction('sin');
      calcProvider.appendNumber('9');
      calcProvider.appendNumber('0');
      calcProvider.appendToExpression(')');
      final entry = calcProvider.calculateResult();
      expect(calcProvider.result, '1');
      expect(entry, isNotNull);
    });
  });

  group('HistoryProvider Integration Tests', () {
    late StorageService storage;
    late HistoryProvider historyProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = StorageService();
      await storage.init();
      historyProvider = HistoryProvider(storage);
      await historyProvider.init();
    });

    test('History save and load', () async {
      final entry = CalculationHistory(
        expression: '5+3',
        result: '8',
        timestamp: DateTime.now(),
        mode: 'basic',
      );

      historyProvider.addEntry(entry);
      expect(historyProvider.history.length, 1);
      expect(historyProvider.history.first.result, '8');

      final newHistory = HistoryProvider(storage);
      await newHistory.init();
      expect(newHistory.history.length, 1);
      expect(newHistory.history.first.expression, '5+3');
    });

    test('History respects max size', () {
      historyProvider.setMaxSize(3);

      for (int i = 0; i < 5; i++) {
        historyProvider.addEntry(
          CalculationHistory(
            expression: '$i+1',
            result: '${i + 1}',
            timestamp: DateTime.now(),
            mode: 'basic',
          ),
        );
      }

      expect(historyProvider.history.length, 3);
    });

    test('Clear history', () {
      historyProvider.addEntry(
        CalculationHistory(
          expression: '1+1',
          result: '2',
          timestamp: DateTime.now(),
          mode: 'basic',
        ),
      );

      expect(historyProvider.history.length, 1);
      historyProvider.clearHistory();
      expect(historyProvider.history.length, 0);
    });

    test('Recent history returns max 3 items', () {
      for (int i = 0; i < 10; i++) {
        historyProvider.addEntry(
          CalculationHistory(
            expression: '$i+1',
            result: '${i + 1}',
            timestamp: DateTime.now(),
            mode: 'basic',
          ),
        );
      }
      expect(historyProvider.recentHistory.length, 3);
    });
  });

  group('ThemeProvider Integration Tests', () {
    late StorageService storage;
    late ThemeProvider themeProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = StorageService();
      await storage.init();
      themeProvider = ThemeProvider(storage);
      await themeProvider.init();
    });

    test('Default theme is dark', () {
      expect(themeProvider.themeMode, ThemeMode.dark);
      expect(themeProvider.isDark, true);
    });

    test('Theme persistence', () async {
      themeProvider.setThemeMode(ThemeMode.light);
      expect(themeProvider.themeMode, ThemeMode.light);
      expect(themeProvider.isDark, false);

      await Future.delayed(const Duration(milliseconds: 100));
      final newTheme = ThemeProvider(storage);
      await newTheme.init();
      expect(newTheme.themeMode, ThemeMode.light);
    });

    test('Theme switching to system', () {
      themeProvider.setThemeMode(ThemeMode.system);
      expect(themeProvider.themeMode, ThemeMode.system);
    });

    test('Light theme data is valid', () {
      final lightTheme = themeProvider.lightTheme;
      expect(lightTheme.brightness, Brightness.light);
    });

    test('Dark theme data is valid', () {
      final darkTheme = themeProvider.darkTheme;
      expect(darkTheme.brightness, Brightness.dark);
    });
  });
}
