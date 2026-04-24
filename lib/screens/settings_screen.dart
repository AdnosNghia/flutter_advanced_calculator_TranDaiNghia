import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calculator_mode.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import '../services/storage_service.dart';
import '../models/calculator_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late CalculatorSettings _settings;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final storage = StorageService();
    await storage.init();
    final settings = await storage.loadSettings();
    setState(() {
      _settings = settings;
      _loaded = true;
    });
  }

  Future<void> _saveSettings() async {
    final storage = StorageService();
    await storage.init();
    await storage.saveSettings(_settings);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final accentColor = isDark
        ? DarkThemeColors.accent
        : LightThemeColors.accent;

    if (!_loaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionHeader('Appearance', isDark),
          _settingCard(
            isDark: isDark,
            child: Column(
              children: [
                _settingRow(
                  title: 'Theme',
                  isDark: isDark,
                  trailing: DropdownButton<ThemeMode>(
                    value: _settings.themeMode,
                    dropdownColor: isDark
                        ? DarkThemeColors.secondary
                        : LightThemeColors.surface,
                    underline: const SizedBox(),
                    style: TextStyle(
                      color: isDark ? Colors.white : LightThemeColors.primary,
                      fontSize: 14,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Light'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Dark'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('System'),
                      ),
                    ],
                    onChanged: (mode) {
                      if (mode != null) {
                        setState(() => _settings.themeMode = mode);
                        context.read<ThemeProvider>().setThemeMode(mode);
                        _saveSettings();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _sectionHeader('Calculator', isDark),
          _settingCard(
            isDark: isDark,
            child: Column(
              children: [
                _settingRow(
                  title: 'Decimal Precision',
                  isDark: isDark,
                  trailing: DropdownButton<int>(
                    value: _settings.decimalPrecision,
                    dropdownColor: isDark
                        ? DarkThemeColors.secondary
                        : LightThemeColors.surface,
                    underline: const SizedBox(),
                    style: TextStyle(
                      color: isDark ? Colors.white : LightThemeColors.primary,
                      fontSize: 14,
                    ),
                    items: List.generate(9, (i) => i + 2)
                        .map(
                          (v) => DropdownMenuItem(
                            value: v,
                            child: Text('$v places'),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _settings.decimalPrecision = val);
                        context.read<CalculatorProvider>().setDecimalPrecision(
                          val,
                        );
                        _saveSettings();
                      }
                    },
                  ),
                ),
                Divider(
                  color: isDark ? Colors.white12 : Colors.black12,
                  height: 1,
                ),
                _settingRow(
                  title: 'Angle Mode',
                  isDark: isDark,
                  trailing: SegmentedButton<AngleMode>(
                    segments: const [
                      ButtonSegment(
                        value: AngleMode.degrees,
                        label: Text('DEG', style: TextStyle(fontSize: 12)),
                      ),
                      ButtonSegment(
                        value: AngleMode.radians,
                        label: Text('RAD', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                    selected: {_settings.angleMode},
                    onSelectionChanged: (set) {
                      setState(() => _settings.angleMode = set.first);
                      context.read<CalculatorProvider>().setAngleMode(
                        set.first,
                      );
                      _saveSettings();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected))
                          return accentColor;
                        return Colors.transparent;
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _sectionHeader('Feedback', isDark),
          _settingCard(
            isDark: isDark,
            child: Column(
              children: [
                _switchRow(
                  title: 'Haptic Feedback',
                  isDark: isDark,
                  value: _settings.hapticFeedback,
                  accentColor: accentColor,
                  onChanged: (val) {
                    setState(() => _settings.hapticFeedback = val);
                    context.read<CalculatorProvider>().setHapticEnabled(val);
                    _saveSettings();
                  },
                ),
                Divider(
                  color: isDark ? Colors.white12 : Colors.black12,
                  height: 1,
                ),
                _switchRow(
                  title: 'Sound Effects',
                  isDark: isDark,
                  value: _settings.soundEffects,
                  accentColor: accentColor,
                  onChanged: (val) {
                    setState(() => _settings.soundEffects = val);
                    context.read<CalculatorProvider>().setSoundEnabled(val);
                    _saveSettings();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _sectionHeader('History', isDark),
          _settingCard(
            isDark: isDark,
            child: Column(
              children: [
                _settingRow(
                  title: 'History Size',
                  isDark: isDark,
                  trailing: DropdownButton<int>(
                    value: _settings.historySize,
                    dropdownColor: isDark
                        ? DarkThemeColors.secondary
                        : LightThemeColors.surface,
                    underline: const SizedBox(),
                    style: TextStyle(
                      color: isDark ? Colors.white : LightThemeColors.primary,
                      fontSize: 14,
                    ),
                    items: const [
                      DropdownMenuItem(value: 25, child: Text('25')),
                      DropdownMenuItem(value: 50, child: Text('50')),
                      DropdownMenuItem(value: 100, child: Text('100')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _settings.historySize = val);
                        context.read<HistoryProvider>().setMaxSize(val);
                        _saveSettings();
                      }
                    },
                  ),
                ),
                Divider(
                  color: isDark ? Colors.white12 : Colors.black12,
                  height: 1,
                ),
                _actionRow(
                  title: 'Clear All History',
                  isDark: isDark,
                  color: Colors.redAccent,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: isDark
                            ? DarkThemeColors.surface
                            : LightThemeColors.surface,
                        title: const Text('Clear All History'),
                        content: const Text(
                          'This action cannot be undone. Are you sure?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<HistoryProvider>().clearHistory();
                              Navigator.pop(ctx);
                            },
                            child: const Text(
                              'Clear',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, bool isDark) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white54 : Colors.black45,
        letterSpacing: 0.5,
      ),
    ),
  );

  Widget _settingCard({required bool isDark, required Widget child}) =>
      Container(
        decoration: BoxDecoration(
          color: isDark ? DarkThemeColors.secondary : LightThemeColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      );

  Widget _settingRow({
    required String title,
    required bool isDark,
    required Widget trailing,
  }) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: isDark ? Colors.white : LightThemeColors.primary,
          ),
        ),
        trailing,
      ],
    ),
  );

  Widget _switchRow({
    required String title,
    required bool isDark,
    required bool value,
    required Color accentColor,
    required ValueChanged<bool> onChanged,
  }) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: isDark ? Colors.white : LightThemeColors.primary,
          ),
        ),
        Switch(value: value, activeColor: accentColor, onChanged: onChanged),
      ],
    ),
  );

  Widget _actionRow({
    required String title,
    required bool isDark,
    required Color color,
    required VoidCallback onTap,
  }) => InkWell(
    onTap: onTap,
    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(Icons.delete_outline_rounded, color: color, size: 20),
          const SizedBox(width: 12),
          Text(title, style: TextStyle(fontSize: 15, color: color)),
        ],
      ),
    ),
  );
}
