import 'dart:math' as math;
import '../models/calculator_mode.dart';

class CalculatorLogic {
  /// Calculates factorial of n
  static double factorial(double n) {
    if (n < 0) throw ArgumentError('Factorial of negative number');
    if (n == 0 || n == 1) return 1;
    if (n != n.truncateToDouble()) {
      throw ArgumentError('Factorial of non-integer');
    }
    double result = 1;
    for (int i = 2; i <= n.toInt(); i++) {
      result *= i;
    }
    return result;
  }

  /// Convert degrees to radians
  static double degToRad(double deg) => deg * math.pi / 180;

  /// Convert radians to degrees
  static double radToDeg(double rad) => rad * 180 / math.pi;

  /// Trigonometric functions with angle mode support
  static double sin(double value, AngleMode mode) {
    final rad = mode == AngleMode.degrees ? degToRad(value) : value;
    return math.sin(rad);
  }

  static double cos(double value, AngleMode mode) {
    final rad = mode == AngleMode.degrees ? degToRad(value) : value;
    return math.cos(rad);
  }

  static double tan(double value, AngleMode mode) {
    final rad = mode == AngleMode.degrees ? degToRad(value) : value;
    return math.tan(rad);
  }

  static double asin(double value, AngleMode mode) {
    final result = math.asin(value);
    return mode == AngleMode.degrees ? radToDeg(result) : result;
  }

  static double acos(double value, AngleMode mode) {
    final result = math.acos(value);
    return mode == AngleMode.degrees ? radToDeg(result) : result;
  }

  static double atan(double value, AngleMode mode) {
    final result = math.atan(value);
    return mode == AngleMode.degrees ? radToDeg(result) : result;
  }

  /// Logarithmic functions
  static double ln(double value) {
    if (value <= 0) throw ArgumentError('Logarithm of non-positive number');
    return math.log(value);
  }

  static double log10(double value) {
    if (value <= 0) throw ArgumentError('Logarithm of non-positive number');
    return math.log(value) / math.ln10;
  }

  static double log2(double value) {
    if (value <= 0) throw ArgumentError('Logarithm of non-positive number');
    return math.log(value) / math.ln2;
  }

  /// Power functions
  static double squareRoot(double value) {
    if (value < 0) throw ArgumentError('Square root of negative number');
    return math.sqrt(value);
  }

  static double cubeRoot(double value) {
    if (value < 0) return -math.pow(-value, 1.0 / 3.0).toDouble();
    return math.pow(value, 1.0 / 3.0).toDouble();
  }

  static double power(double base, double exponent) {
    return math.pow(base, exponent).toDouble();
  }

  /// Programmer mode: number base conversions
  static String toBase(int value, int base) {
    if (base == 2) return '0b${value.toRadixString(2).toUpperCase()}';
    if (base == 8) return '0o${value.toRadixString(8).toUpperCase()}';
    if (base == 16) return '0x${value.toRadixString(16).toUpperCase()}';
    return value.toString();
  }

  static int parseBase(String value) {
    value = value.trim().toUpperCase();
    if (value.startsWith('0B')) return int.parse(value.substring(2), radix: 2);
    if (value.startsWith('0O')) return int.parse(value.substring(2), radix: 8);
    if (value.startsWith('0X')) return int.parse(value.substring(2), radix: 16);
    return int.parse(value);
  }

  /// Bitwise operations
  static int bitwiseAnd(int a, int b) => a & b;
  static int bitwiseOr(int a, int b) => a | b;
  static int bitwiseXor(int a, int b) => a ^ b;
  static int bitwiseNot(int a) => ~a;
  static int leftShift(int a, int b) => a << b;
  static int rightShift(int a, int b) => a >> b;

  /// Format result based on precision
  static String formatResult(double value, int precision) {
    if (value.isNaN) return 'Error';
    if (value.isInfinite) return value.isNegative ? '-∞' : '∞';

    // If the value is effectively an integer, show without decimals
    if (value == value.truncateToDouble() && value.abs() < 1e15) {
      return value.toInt().toString();
    }

    String formatted = value.toStringAsFixed(precision);
    // Remove trailing zeros
    if (formatted.contains('.')) {
      formatted = formatted.replaceAll(RegExp(r'0+$'), '');
      formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    }
    return formatted;
  }
}
