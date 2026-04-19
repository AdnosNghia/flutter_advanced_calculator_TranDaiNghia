import 'package:flutter/material.dart';
import 'calculator_mode.dart';

class CalculatorSettings {
  ThemeMode themeMode;
  int decimalPrecision;
  AngleMode angleMode;
  bool hapticFeedback;
  bool soundEffects;
  int historySize;

  CalculatorSettings({
    this.themeMode = ThemeMode.dark,
    this.decimalPrecision = 6,
    this.angleMode = AngleMode.degrees,
    this.hapticFeedback = true,
    this.soundEffects = false,
    this.historySize = 50,
  });

  Map<String, dynamic> toJson() => {
    'themeMode': themeMode.index,
    'decimalPrecision': decimalPrecision,
    'angleMode': angleMode.index,
    'hapticFeedback': hapticFeedback,
    'soundEffects': soundEffects,
    'historySize': historySize,
  };

  factory CalculatorSettings.fromJson(Map<String, dynamic> json) {
    return CalculatorSettings(
      themeMode: ThemeMode.values[json['themeMode'] as int? ?? 2],
      decimalPrecision: json['decimalPrecision'] as int? ?? 6,
      angleMode: AngleMode.values[json['angleMode'] as int? ?? 0],
      hapticFeedback: json['hapticFeedback'] as bool? ?? true,
      soundEffects: json['soundEffects'] as bool? ?? false,
      historySize: json['historySize'] as int? ?? 50,
    );
  }
}
