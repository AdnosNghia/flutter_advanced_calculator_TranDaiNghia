import 'dart:convert';

class CalculationHistory {
  final String expression;
  final String result;
  final DateTime timestamp;
  final String mode;

  CalculationHistory({
    required this.expression,
    required this.result,
    required this.timestamp,
    required this.mode,
  });

  Map<String, dynamic> toJson() => {
    'expression': expression,
    'result': result,
    'timestamp': timestamp.toIso8601String(),
    'mode': mode,
  };

  factory CalculationHistory.fromJson(Map<String, dynamic> json) {
    return CalculationHistory(
      expression: json['expression'] as String,
      result: json['result'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      mode: json['mode'] as String,
    );
  }

  static String encodeList(List<CalculationHistory> list) {
    return jsonEncode(list.map((e) => e.toJson()).toList());
  }

  static List<CalculationHistory> decodeList(String jsonStr) {
    final List<dynamic> decoded = jsonDecode(jsonStr) as List<dynamic>;
    return decoded
        .map((e) => CalculationHistory.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
