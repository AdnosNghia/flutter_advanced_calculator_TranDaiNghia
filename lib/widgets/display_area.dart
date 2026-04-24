import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';

class DisplayArea extends StatefulWidget {
  const DisplayArea({super.key});

  @override
  State<DisplayArea> createState() => _DisplayAreaState();
}

class _DisplayAreaState extends State<DisplayArea>
    with SingleTickerProviderStateMixin {
  double _fontScale = 1.0;
  double _baseFontScale = 1.0;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  bool _lastHasError = false;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0, end: 10), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -10, end: 8), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 8, end: -5), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -5, end: 0), weight: 1),
        ]).animate(
          CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calc = context.watch<CalculatorProvider>();
    final historyProvider = context.watch<HistoryProvider>();
    final isDark = context.watch<ThemeProvider>().isDark;

    if (calc.hasError && !_lastHasError) {
      _shakeController.forward(from: 0);
    }
    _lastHasError = calc.hasError;

    final bgColor = isDark
        ? DarkThemeColors.displayBg
        : LightThemeColors.displayBg;
    final textColor = isDark ? Colors.white : LightThemeColors.primary;
    final dimmedColor = isDark ? Colors.white38 : Colors.black38;
    final accentColor = isDark
        ? DarkThemeColors.accent
        : LightThemeColors.accent;
    final recentHistory = historyProvider.recentHistory;

    return GestureDetector(
      onScaleStart: (details) {
        _baseFontScale = _fontScale;
      },
      onScaleUpdate: (details) {
        setState(() {
          _fontScale = (_baseFontScale * details.scale).clamp(0.7, 1.6);
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppConstants.displayRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        calc.angleMode.name.toUpperCase().substring(0, 3),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: accentColor,
                        ),
                      ),
                    ),
                    if (calc.hasMemory) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'M',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  calc.mode.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: dimmedColor,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            if (recentHistory.isNotEmpty)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: recentHistory.reversed
                      .map(
                        (entry) => GestureDetector(
                          onTap: () => calc.appendToExpression(entry.result),
                          child: Text(
                            '${entry.expression} = ${entry.result}',
                            style: TextStyle(
                              fontSize: 12 * _fontScale,
                              color: dimmedColor,
                              fontWeight: FontWeight.w300,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
            else
              const Expanded(child: SizedBox()),
            const SizedBox(height: 2),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                calc.displayExpression.isEmpty ? ' ' : calc.displayExpression,
                style: TextStyle(
                  fontSize: 18 * _fontScale,
                  color: textColor.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 2),
            AnimatedBuilder(
              animation: _shakeController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: child,
                );
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: SingleChildScrollView(
                  key: ValueKey(calc.result),
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    calc.result,
                    style: TextStyle(
                      fontSize: (calc.hasError ? 22 : 32) * _fontScale,
                      color: calc.hasError ? Colors.redAccent : textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
