import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calculator_mode.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';

class ModeSelector extends StatelessWidget {
  const ModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final calc = context.watch<CalculatorProvider>();
    final isDark = context.watch<ThemeProvider>().isDark;
    final accentColor = isDark
        ? DarkThemeColors.accent
        : LightThemeColors.accent;
    final surfaceColor = isDark
        ? DarkThemeColors.secondary
        : LightThemeColors.functionButton;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildTab(
            context,
            'Basic',
            calc.mode == CalculatorMode.basic,
            accentColor,
            () => calc.setMode(CalculatorMode.basic),
          ),
          _buildTab(
            context,
            'Scientific',
            calc.mode == CalculatorMode.scientific,
            accentColor,
            () => calc.setMode(CalculatorMode.scientific),
          ),
          _buildTab(
            context,
            'Programmer',
            calc.mode == CalculatorMode.programmer,
            accentColor,
            () => calc.setMode(CalculatorMode.programmer),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    String label,
    bool isActive,
    Color accentColor,
    VoidCallback onTap,
  ) {
    final isDark = context.watch<ThemeProvider>().isDark;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppConstants.modeSwitchDuration,
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? accentColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
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
