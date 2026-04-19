import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';

class DisplayArea extends StatelessWidget {
  const DisplayArea({super.key});

  @override
  Widget build(BuildContext context) {
    final calc = context.watch<CalculatorProvider>();
    final historyProvider = context.watch<HistoryProvider>();
    final isDark = context.watch<ThemeProvider>().isDark;

    final bgColor = isDark
        ? DarkThemeColors.displayBg
        : LightThemeColors.displayBg;
    final textColor = isDark ? Colors.white : LightThemeColors.primary;
    final dimmedColor = isDark ? Colors.white38 : Colors.black38;
    final accentColor = isDark
        ? DarkThemeColors.accent
        : LightThemeColors.accent;
    final recentHistory = historyProvider.recentHistory;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.screenPadding),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppConstants.displayRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mode and memory indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      calc.angleMode.name.toUpperCase().substring(0, 3),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  if (calc.hasMemory) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'M',
                        style: TextStyle(
                          fontSize: 11,
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
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: dimmedColor,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),

          // History preview: last 3 calculations (swipeable)
          if (recentHistory.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: recentHistory.length * 28.0,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: recentHistory.length,
                itemBuilder: (context, index) {
                  final entry = recentHistory[recentHistory.length - 1 - index];
                  return GestureDetector(
                    onTap: () {
                      // Tap to reuse previous calculation result
                      calc.appendToExpression(entry.result);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              '${entry.expression} = ${entry.result}',
                              style: TextStyle(
                                fontSize: 13,
                                color: dimmedColor,
                                fontWeight: FontWeight.w300,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(color: isDark ? Colors.white12 : Colors.black12, height: 8),
          ],

          const SizedBox(height: 6),
          // Current expression (scrollable)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Text(
              calc.expression.isEmpty ? ' ' : calc.expression,
              style: TextStyle(
                fontSize: 22,
                color: textColor.withValues(alpha: 0.7),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Result with fade animation
          AnimatedSwitcher(
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
                  fontSize: calc.hasError ? 28 : AppConstants.displayFontSize,
                  color: calc.hasError ? Colors.redAccent : textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
