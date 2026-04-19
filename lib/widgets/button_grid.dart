import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calculator_mode.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import 'calculator_button.dart';

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final calc = context.watch<CalculatorProvider>();
    final mode = calc.mode;

    return AnimatedSwitcher(
      duration: AppConstants.modeSwitchDuration,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: mode == CalculatorMode.scientific
          ? _ScientificGrid(key: const ValueKey('scientific'))
          : mode == CalculatorMode.programmer
          ? _ProgrammerGrid(key: const ValueKey('programmer'))
          : _BasicGrid(key: const ValueKey('basic')),
    );
  }
}

/// Basic Mode: 4×5 grid
class _BasicGrid extends StatelessWidget {
  const _BasicGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final calc = context.read<CalculatorProvider>();
    final historyProvider = context.read<HistoryProvider>();
    final isDark = context.watch<ThemeProvider>().isDark;

    final numBg = isDark
        ? DarkThemeColors.numberButton
        : LightThemeColors.numberButton;
    final opBg = isDark
        ? DarkThemeColors.operatorButton
        : LightThemeColors.operatorButton;
    final funcBg = isDark
        ? DarkThemeColors.functionButton
        : LightThemeColors.functionButton;
    final numText = isDark ? Colors.white : LightThemeColors.buttonText;
    final opText = isDark ? DarkThemeColors.primary : Colors.white;
    final funcText = isDark ? Colors.white : LightThemeColors.buttonText;
    final eqBg = isDark
        ? DarkThemeColors.equalButton
        : LightThemeColors.equalButton;

    Widget row(List<Widget> children) => Row(children: children);

    return Column(
      children: [
        row([
          CalculatorButton(
            label: 'C',
            onPressed: () => calc.clear(),
            onLongPress: () => historyProvider.clearHistory(),
            backgroundColor: funcBg,
            textColor: funcText,
          ),
          CalculatorButton(
            label: 'CE',
            onPressed: () => calc.clearEntry(),
            backgroundColor: funcBg,
            textColor: funcText,
          ),
          CalculatorButton(
            label: '%',
            onPressed: () => calc.appendOperator('%'),
            backgroundColor: funcBg,
            textColor: funcText,
          ),
          CalculatorButton(
            label: '÷',
            onPressed: () => calc.appendOperator('÷'),
            backgroundColor: opBg,
            textColor: opText,
          ),
        ]),
        row([
          CalculatorButton(
            label: '7',
            onPressed: () => calc.appendNumber('7'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '8',
            onPressed: () => calc.appendNumber('8'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '9',
            onPressed: () => calc.appendNumber('9'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '×',
            onPressed: () => calc.appendOperator('×'),
            backgroundColor: opBg,
            textColor: opText,
          ),
        ]),
        row([
          CalculatorButton(
            label: '4',
            onPressed: () => calc.appendNumber('4'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '5',
            onPressed: () => calc.appendNumber('5'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '6',
            onPressed: () => calc.appendNumber('6'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '-',
            onPressed: () => calc.appendOperator('-'),
            backgroundColor: opBg,
            textColor: opText,
          ),
        ]),
        row([
          CalculatorButton(
            label: '1',
            onPressed: () => calc.appendNumber('1'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '2',
            onPressed: () => calc.appendNumber('2'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '3',
            onPressed: () => calc.appendNumber('3'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '+',
            onPressed: () => calc.appendOperator('+'),
            backgroundColor: opBg,
            textColor: opText,
          ),
        ]),
        row([
          CalculatorButton(
            label: '±',
            onPressed: () => calc.toggleSign(),
            backgroundColor: funcBg,
            textColor: funcText,
          ),
          CalculatorButton(
            label: '0',
            onPressed: () => calc.appendNumber('0'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '.',
            onPressed: () => calc.appendDecimal(),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '=',
            onPressed: () {
              final entry = calc.calculateResult();
              if (entry != null) historyProvider.addEntry(entry);
            },
            backgroundColor: eqBg,
            textColor: opText,
          ),
        ]),
      ],
    );
  }
}

/// Scientific Mode: 6×6 grid
class _ScientificGrid extends StatelessWidget {
  const _ScientificGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final calc = context.read<CalculatorProvider>();
    final historyProvider = context.read<HistoryProvider>();
    final isSecond = context.watch<CalculatorProvider>().isSecondFunction;
    final isDark = context.watch<ThemeProvider>().isDark;

    final numBg = isDark
        ? DarkThemeColors.numberButton
        : LightThemeColors.numberButton;
    final opBg = isDark
        ? DarkThemeColors.operatorButton
        : LightThemeColors.operatorButton;
    final funcBg = isDark
        ? DarkThemeColors.functionButton
        : LightThemeColors.functionButton;
    final numText = isDark ? Colors.white : LightThemeColors.buttonText;
    final opText = isDark ? DarkThemeColors.primary : Colors.white;
    final funcText = isDark ? Colors.white : LightThemeColors.buttonText;
    final eqBg = isDark
        ? DarkThemeColors.equalButton
        : LightThemeColors.equalButton;
    final secondBg = isSecond ? opBg : funcBg;
    final secondText = isSecond ? opText : funcText;

    Widget row(List<Widget> children) => Row(children: children);

    return Column(
      children: [
        // Row 1: 2nd, sin/asin, cos/acos, tan/atan, ln, log
        row([
          CalculatorButton(
            label: '2nd',
            onPressed: () => calc.toggleSecondFunction(),
            backgroundColor: secondBg,
            textColor: secondText,
            fontSize: 14,
          ),
          CalculatorButton(
            label: isSecond ? 'asin' : 'sin',
            onPressed: () => calc.applyFunction(isSecond ? 'asin' : 'sin'),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 14,
          ),
          CalculatorButton(
            label: isSecond ? 'acos' : 'cos',
            onPressed: () => calc.applyFunction(isSecond ? 'acos' : 'cos'),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 14,
          ),
          CalculatorButton(
            label: isSecond ? 'atan' : 'tan',
            onPressed: () => calc.applyFunction(isSecond ? 'atan' : 'tan'),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 14,
          ),
          CalculatorButton(
            label: 'Ln',
            onPressed: () => calc.applyFunction('ln'),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 14,
          ),
          CalculatorButton(
            label: 'log',
            onPressed: () => calc.applyFunction('log'),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 14,
          ),
        ]),
        // Row 2: x², √, x^y, (, ), ÷
        row([
          CalculatorButton(
            label: 'x²',
            onPressed: () => calc.applySquare(),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 14,
          ),
          CalculatorButton(
            label: '√',
            onPressed: () => calc.applySqrt(),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 14,
          ),
          CalculatorButton(
            label: 'xʸ',
            onPressed: () => calc.applyPower(),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 14,
          ),
          CalculatorButton(
            label: '(',
            onPressed: () => calc.appendToExpression('('),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 14,
          ),
          CalculatorButton(
            label: ')',
            onPressed: () => calc.appendToExpression(')'),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 14,
          ),
          CalculatorButton(
            label: '÷',
            onPressed: () => calc.appendOperator('÷'),
            backgroundColor: opBg,
            textColor: opText,
            fontSize: 14,
          ),
        ]),
        // Row 3: MC, 7, 8, 9, C, ×
        row([
          CalculatorButton(
            label: 'MC',
            onPressed: () => calc.memoryClear(),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 14,
          ),
          CalculatorButton(
            label: '7',
            onPressed: () => calc.appendNumber('7'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '8',
            onPressed: () => calc.appendNumber('8'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '9',
            onPressed: () => calc.appendNumber('9'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: 'C',
            onPressed: () => calc.clear(),
            onLongPress: () => historyProvider.clearHistory(),
            backgroundColor: funcBg,
            textColor: funcText,
          ),
          CalculatorButton(
            label: '×',
            onPressed: () => calc.appendOperator('×'),
            backgroundColor: opBg,
            textColor: opText,
          ),
        ]),
        // Row 4: MR, 4, 5, 6, CE, -
        row([
          CalculatorButton(
            label: 'MR',
            onPressed: () => calc.memoryRecall(),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 14,
          ),
          CalculatorButton(
            label: '4',
            onPressed: () => calc.appendNumber('4'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '5',
            onPressed: () => calc.appendNumber('5'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '6',
            onPressed: () => calc.appendNumber('6'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: 'CE',
            onPressed: () => calc.clearEntry(),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 14,
          ),
          CalculatorButton(
            label: '-',
            onPressed: () => calc.appendOperator('-'),
            backgroundColor: opBg,
            textColor: opText,
          ),
        ]),
        // Row 5: M+, 1, 2, 3, %, +
        row([
          CalculatorButton(
            label: 'M+',
            onPressed: () => calc.memoryAdd(),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 14,
          ),
          CalculatorButton(
            label: '1',
            onPressed: () => calc.appendNumber('1'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '2',
            onPressed: () => calc.appendNumber('2'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '3',
            onPressed: () => calc.appendNumber('3'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '%',
            onPressed: () => calc.appendOperator('%'),
            backgroundColor: funcBg,
            textColor: funcText,
          ),
          CalculatorButton(
            label: '+',
            onPressed: () => calc.appendOperator('+'),
            backgroundColor: opBg,
            textColor: opText,
          ),
        ]),
        // Row 6: M-, ±, 0, ., π, =
        row([
          CalculatorButton(
            label: 'M-',
            onPressed: () => calc.memorySubtract(),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 14,
          ),
          CalculatorButton(
            label: '±',
            onPressed: () => calc.toggleSign(),
            backgroundColor: funcBg,
            textColor: funcText,
          ),
          CalculatorButton(
            label: '0',
            onPressed: () => calc.appendNumber('0'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '.',
            onPressed: () => calc.appendDecimal(),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: 'π',
            onPressed: () => calc.insertConstant('π'),
            backgroundColor: funcBg,
            textColor: funcText,
          ),
          CalculatorButton(
            label: '=',
            onPressed: () {
              final entry = calc.calculateResult();
              if (entry != null) historyProvider.addEntry(entry);
            },
            backgroundColor: eqBg,
            textColor: opText,
          ),
        ]),
      ],
    );
  }
}

/// Programmer Mode
class _ProgrammerGrid extends StatelessWidget {
  const _ProgrammerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final calc = context.read<CalculatorProvider>();
    final historyProvider = context.read<HistoryProvider>();
    final isDark = context.watch<ThemeProvider>().isDark;

    final numBg = isDark
        ? DarkThemeColors.numberButton
        : LightThemeColors.numberButton;
    final opBg = isDark
        ? DarkThemeColors.operatorButton
        : LightThemeColors.operatorButton;
    final funcBg = isDark
        ? DarkThemeColors.functionButton
        : LightThemeColors.functionButton;
    final numText = isDark ? Colors.white : LightThemeColors.buttonText;
    final opText = isDark ? DarkThemeColors.primary : Colors.white;
    final funcText = isDark ? Colors.white : LightThemeColors.buttonText;
    final eqBg = isDark
        ? DarkThemeColors.equalButton
        : LightThemeColors.equalButton;

    Widget row(List<Widget> children) => Row(children: children);

    return Column(
      children: [
        // Base selector row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              _baseTab(context, 'HEX', 16, calc),
              _baseTab(context, 'DEC', 10, calc),
              _baseTab(context, 'OCT', 8, calc),
              _baseTab(context, 'BIN', 2, calc),
            ],
          ),
        ),
        // Row 1: AND, OR, XOR, NOT
        row([
          CalculatorButton(
            label: 'AND',
            onPressed: () => calc.appendOperator('&'),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 13,
          ),
          CalculatorButton(
            label: 'OR',
            onPressed: () => calc.appendOperator('|'),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 13,
          ),
          CalculatorButton(
            label: 'XOR',
            onPressed: () => calc.appendOperator('^'),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 13,
          ),
          CalculatorButton(
            label: 'NOT',
            onPressed: () => calc.appendToExpression('~'),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 13,
          ),
        ]),
        // Row 2: <<, >>, C, ÷
        row([
          CalculatorButton(
            label: '<<',
            onPressed: () => calc.appendOperator('<<'),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 13,
          ),
          CalculatorButton(
            label: '>>',
            onPressed: () => calc.appendOperator('>>'),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 13,
          ),
          CalculatorButton(
            label: 'C',
            onPressed: () => calc.clear(),
            backgroundColor: funcBg,
            textColor: funcText,
          ),
          CalculatorButton(
            label: '÷',
            onPressed: () => calc.appendOperator('÷'),
            backgroundColor: opBg,
            textColor: opText,
          ),
        ]),
        // Number rows
        row([
          CalculatorButton(
            label: '7',
            onPressed: () => calc.appendNumber('7'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '8',
            onPressed: () => calc.appendNumber('8'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '9',
            onPressed: () => calc.appendNumber('9'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '×',
            onPressed: () => calc.appendOperator('×'),
            backgroundColor: opBg,
            textColor: opText,
          ),
        ]),
        row([
          CalculatorButton(
            label: '4',
            onPressed: () => calc.appendNumber('4'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '5',
            onPressed: () => calc.appendNumber('5'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '6',
            onPressed: () => calc.appendNumber('6'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '-',
            onPressed: () => calc.appendOperator('-'),
            backgroundColor: opBg,
            textColor: opText,
          ),
        ]),
        row([
          CalculatorButton(
            label: '1',
            onPressed: () => calc.appendNumber('1'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '2',
            onPressed: () => calc.appendNumber('2'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '3',
            onPressed: () => calc.appendNumber('3'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '+',
            onPressed: () => calc.appendOperator('+'),
            backgroundColor: opBg,
            textColor: opText,
          ),
        ]),
        row([
          CalculatorButton(
            label: 'CE',
            onPressed: () => calc.clearEntry(),
            backgroundColor: funcBg,
            textColor: funcText,
            fontSize: 14,
          ),
          CalculatorButton(
            label: '0',
            onPressed: () => calc.appendNumber('0'),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '.',
            onPressed: () => calc.appendDecimal(),
            backgroundColor: numBg,
            textColor: numText,
          ),
          CalculatorButton(
            label: '=',
            onPressed: () {
              final entry = calc.calculateResult();
              if (entry != null) historyProvider.addEntry(entry);
            },
            backgroundColor: eqBg,
            textColor: opText,
          ),
        ]),
      ],
    );
  }

  Widget _baseTab(
    BuildContext context,
    String label,
    int base,
    CalculatorProvider calc,
  ) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final isActive = calc.currentBase == base;
    final accentColor = isDark
        ? DarkThemeColors.accent
        : LightThemeColors.accent;

    return Expanded(
      child: GestureDetector(
        onTap: () => calc.setBase(base),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? accentColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive
                  ? accentColor
                  : (isDark ? Colors.white24 : Colors.black12),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive
                  ? (isDark ? DarkThemeColors.primary : Colors.white)
                  : (isDark ? Colors.white60 : Colors.black54),
            ),
          ),
        ),
      ),
    );
  }
}
