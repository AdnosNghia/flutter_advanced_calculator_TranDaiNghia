import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import '../widgets/display_area.dart';
import '../widgets/button_grid.dart';
import '../widgets/mode_selector.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          // Swipe right to delete last character
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity != null &&
                details.primaryVelocity! > 200) {
              context.read<CalculatorProvider>().deleteLastCharacter();
            }
          },
          // Swipe up to open history
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null &&
                details.primaryVelocity! < -200) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const HistoryScreen(),
                  transitionsBuilder: (_, animation, __, child) {
                    return SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: child,
                    );
                  },
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.screenPadding,
              vertical: 12,
            ),
            child: Column(
              children: [
                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Calculator',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : LightThemeColors.primary,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.history_rounded,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HistoryScreen(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.settings_rounded,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SettingsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Display area
                const DisplayArea(),
                const SizedBox(height: 16),
                // Mode selector
                const ModeSelector(),
                const SizedBox(height: 12),
                // Button grid
                const Expanded(child: ButtonGrid()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
