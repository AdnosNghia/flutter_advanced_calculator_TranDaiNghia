import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class ThemeProvider extends ChangeNotifier {
  final StorageService _storage;
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeProvider(this._storage);

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  Future<void> init() async {
    final settings = await _storage.loadSettings();
    _themeMode = settings.themeMode;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final settings = await _storage.loadSettings();
    settings.themeMode = mode;
    await _storage.saveSettings(settings);
    notifyListeners();
  }

  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    fontFamily: AppConstants.fontFamily,
    scaffoldBackgroundColor: LightThemeColors.background,
    colorScheme: const ColorScheme.light(
      primary: LightThemeColors.primary,
      secondary: LightThemeColors.accent,
      surface: LightThemeColors.surface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: LightThemeColors.surface,
      foregroundColor: LightThemeColors.primary,
      elevation: 0,
    ),
  );

  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    fontFamily: AppConstants.fontFamily,
    scaffoldBackgroundColor: DarkThemeColors.background,
    colorScheme: const ColorScheme.dark(
      primary: DarkThemeColors.primary,
      secondary: DarkThemeColors.accent,
      surface: DarkThemeColors.surface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: DarkThemeColors.surface,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}
