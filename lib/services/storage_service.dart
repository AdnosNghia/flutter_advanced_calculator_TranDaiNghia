import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculation_history.dart';
import '../models/calculator_settings.dart';

class StorageService {
  static const String _historyKey = 'calculation_history';
  static const String _settingsKey = 'calculator_settings';
  static const String _memoryKey = 'memory_value';
  static const String _modeKey = 'calculator_mode';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<CalculationHistory>> loadHistory() async {
    final data = _prefs.getString(_historyKey);
    if (data == null || data.isEmpty) return [];
    try {
      return CalculationHistory.decodeList(data);
    } catch (_) {
      return [];
    }
  }

  Future<void> saveHistory(List<CalculationHistory> history) async {
    await _prefs.setString(_historyKey, CalculationHistory.encodeList(history));
  }

  Future<void> clearHistory() async {
    await _prefs.remove(_historyKey);
  }

  Future<CalculatorSettings> loadSettings() async {
    final data = _prefs.getString(_settingsKey);
    if (data == null || data.isEmpty) return CalculatorSettings();
    try {
      return CalculatorSettings.fromJson(
        jsonDecode(data) as Map<String, dynamic>,
      );
    } catch (_) {
      return CalculatorSettings();
    }
  }

  Future<void> saveSettings(CalculatorSettings settings) async {
    await _prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  Future<double> loadMemory() async {
    return _prefs.getDouble(_memoryKey) ?? 0.0;
  }

  Future<void> saveMemory(double value) async {
    await _prefs.setDouble(_memoryKey, value);
  }

  Future<int> loadMode() async {
    return _prefs.getInt(_modeKey) ?? 0;
  }

  Future<void> saveMode(int modeIndex) async {
    await _prefs.setInt(_modeKey, modeIndex);
  }
}
