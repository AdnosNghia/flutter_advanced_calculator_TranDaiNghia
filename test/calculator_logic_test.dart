import 'package:flutter_test/flutter_test.dart';
import 'package:lab3_advanced_calculator/utils/calculator_logic.dart';
import 'package:lab3_advanced_calculator/utils/expression_parser.dart';
import 'package:lab3_advanced_calculator/models/calculator_mode.dart';
import 'dart:math' as math;

void main() {
  group('CalculatorLogic', () {
    group('Factorial', () {
      test('factorial of 0 is 1', () {
        expect(CalculatorLogic.factorial(0), 1);
      });

      test('factorial of 1 is 1', () {
        expect(CalculatorLogic.factorial(1), 1);
      });

      test('factorial of 5 is 120', () {
        expect(CalculatorLogic.factorial(5), 120);
      });

      test('factorial of 10 is 3628800', () {
        expect(CalculatorLogic.factorial(10), 3628800);
      });

      test('factorial of negative throws', () {
        expect(() => CalculatorLogic.factorial(-1), throwsArgumentError);
      });
    });

    group('Trigonometric Functions', () {
      test('sin(0°) = 0', () {
        expect(CalculatorLogic.sin(0, AngleMode.degrees), closeTo(0, 1e-10));
      });

      test('sin(90°) = 1', () {
        expect(CalculatorLogic.sin(90, AngleMode.degrees), closeTo(1, 1e-10));
      });

      test('cos(0°) = 1', () {
        expect(CalculatorLogic.cos(0, AngleMode.degrees), closeTo(1, 1e-10));
      });

      test('cos(90°) = 0', () {
        expect(CalculatorLogic.cos(90, AngleMode.degrees), closeTo(0, 1e-10));
      });

      test('tan(45°) = 1', () {
        expect(CalculatorLogic.tan(45, AngleMode.degrees), closeTo(1, 1e-10));
      });

      test('sin(π/2 rad) = 1', () {
        expect(
          CalculatorLogic.sin(math.pi / 2, AngleMode.radians),
          closeTo(1, 1e-10),
        );
      });

      test('asin(1) = 90° in degree mode', () {
        expect(CalculatorLogic.asin(1, AngleMode.degrees), closeTo(90, 1e-10));
      });

      test('acos(0) = 90° in degree mode', () {
        expect(CalculatorLogic.acos(0, AngleMode.degrees), closeTo(90, 1e-10));
      });

      test('atan(1) = 45° in degree mode', () {
        expect(CalculatorLogic.atan(1, AngleMode.degrees), closeTo(45, 1e-10));
      });
    });

    group('Logarithmic Functions', () {
      test('ln(1) = 0', () {
        expect(CalculatorLogic.ln(1), closeTo(0, 1e-10));
      });

      test('ln(e) = 1', () {
        expect(CalculatorLogic.ln(math.e), closeTo(1, 1e-10));
      });

      test('log10(100) = 2', () {
        expect(CalculatorLogic.log10(100), closeTo(2, 1e-10));
      });

      test('log10(1000) = 3', () {
        expect(CalculatorLogic.log10(1000), closeTo(3, 1e-10));
      });

      test('log2(8) = 3', () {
        expect(CalculatorLogic.log2(8), closeTo(3, 1e-10));
      });

      test('ln of negative throws', () {
        expect(() => CalculatorLogic.ln(-1), throwsArgumentError);
      });
    });

    group('Power Functions', () {
      test('squareRoot(9) = 3', () {
        expect(CalculatorLogic.squareRoot(9), closeTo(3, 1e-10));
      });

      test('squareRoot(2) ≈ 1.414', () {
        expect(CalculatorLogic.squareRoot(2), closeTo(1.41421356, 1e-6));
      });

      test('squareRoot of negative throws', () {
        expect(() => CalculatorLogic.squareRoot(-1), throwsArgumentError);
      });

      test('cubeRoot(27) = 3', () {
        expect(CalculatorLogic.cubeRoot(27), closeTo(3, 1e-10));
      });

      test('cubeRoot(-8) = -2', () {
        expect(CalculatorLogic.cubeRoot(-8), closeTo(-2, 1e-10));
      });

      test('power(2, 10) = 1024', () {
        expect(CalculatorLogic.power(2, 10), 1024);
      });
    });

    group('Programmer Mode', () {
      test('toBase binary', () {
        expect(CalculatorLogic.toBase(255, 2), '0b11111111');
      });

      test('toBase octal', () {
        expect(CalculatorLogic.toBase(255, 8), '0o377');
      });

      test('toBase hex', () {
        expect(CalculatorLogic.toBase(255, 16), '0xFF');
      });

      test('parseBase binary', () {
        expect(CalculatorLogic.parseBase('0b1010'), 10);
      });

      test('parseBase hex', () {
        expect(CalculatorLogic.parseBase('0xFF'), 255);
      });

      test('bitwiseAnd', () {
        expect(CalculatorLogic.bitwiseAnd(0xFF, 0x0F), 0x0F);
      });

      test('bitwiseOr', () {
        expect(CalculatorLogic.bitwiseOr(0xF0, 0x0F), 0xFF);
      });

      test('bitwiseXor', () {
        expect(CalculatorLogic.bitwiseXor(0xFF, 0x0F), 0xF0);
      });

      test('leftShift', () {
        expect(CalculatorLogic.leftShift(1, 4), 16);
      });

      test('rightShift', () {
        expect(CalculatorLogic.rightShift(16, 4), 1);
      });
    });

    group('Format Result', () {
      test('integer result shows no decimals', () {
        expect(CalculatorLogic.formatResult(5.0, 6), '5');
      });

      test('decimal result with precision', () {
        expect(CalculatorLogic.formatResult(1.414213562, 6), '1.414214');
      });

      test('remove trailing zeros', () {
        expect(CalculatorLogic.formatResult(1.5, 6), '1.5');
      });

      test('NaN shows Error', () {
        expect(CalculatorLogic.formatResult(double.nan, 6), 'Error');
      });

      test('Infinity shows ∞', () {
        expect(CalculatorLogic.formatResult(double.infinity, 6), '∞');
      });
    });
  });

  group('ExpressionParser', () {
    final parser = ExpressionParser(angleMode: AngleMode.degrees);

    group('Basic Arithmetic', () {
      test('simple addition: 2+3 = 5', () {
        expect(parser.evaluate('2+3'), '5');
      });

      test('simple subtraction: 10-4 = 6', () {
        expect(parser.evaluate('10-4'), '6');
      });

      test('simple multiplication: 3×4 = 12', () {
        expect(parser.evaluate('3×4'), '12');
      });

      test('simple division: 15÷3 = 5', () {
        expect(parser.evaluate('15÷3'), '5');
      });

      test('division by zero returns Error', () {
        expect(parser.evaluate('5÷0'), 'Error');
      });
    });

    group('Operator Precedence (PEMDAS)', () {
      test('(5+3)×2-4÷2 = 14', () {
        expect(parser.evaluate('(5+3)×2-4÷2'), '14');
      });

      test('2+3×4 = 14', () {
        expect(parser.evaluate('2+3×4'), '14');
      });

      test('10-2×3 = 4', () {
        expect(parser.evaluate('10-2×3'), '4');
      });
    });

    group('Parentheses', () {
      test('(2+3)×4 = 20', () {
        expect(parser.evaluate('(2+3)×4'), '20');
      });

      test('((2+3)×(4-1))÷5 = 3', () {
        expect(parser.evaluate('((2+3)×(4-1))÷5'), '3');
      });

      test('nested: ((1+2)×(3+4)) = 21', () {
        expect(parser.evaluate('((1+2)×(3+4))'), '21');
      });
    });

    group('Scientific Functions', () {
      test('sin(45°)+cos(45°) ≈ 1.414', () {
        final result = double.parse(parser.evaluate('sin(45)+cos(45)'));
        expect(result, closeTo(1.41421356, 0.001));
      });

      test('sin(90°) = 1', () {
        expect(parser.evaluate('sin(90)'), '1');
      });

      test('cos(0°) = 1', () {
        expect(parser.evaluate('cos(0)'), '1');
      });

      test('sqrt(9) = 3', () {
        expect(parser.evaluate('sqrt(9)'), '3');
      });

      test('sqrt(2) ≈ 1.414214', () {
        final result = double.parse(parser.evaluate('sqrt(2)'));
        expect(result, closeTo(1.41421356, 0.001));
      });

      test('log(100) = 2', () {
        expect(parser.evaluate('log(100)'), '2');
      });
    });

    group('Power and Factorial', () {
      test('2^10 = 1024', () {
        expect(parser.evaluate('2^10'), '1024');
      });

      test('3^3 = 27', () {
        expect(parser.evaluate('3^3'), '27');
      });

      test('5! = 120', () {
        expect(parser.evaluate('5!'), '120');
      });

      test('(3+2)! = 120', () {
        expect(parser.evaluate('(3+2)!'), '120');
      });
    });

    group('Complex Expressions', () {
      test('2×sqrt(9) = 6 (part of 2×π×√9)', () {
        expect(parser.evaluate('2×sqrt(9)'), '6');
      });

      test('negative numbers: -5+3 = -2', () {
        expect(parser.evaluate('-5+3'), '-2');
      });

      test('decimal numbers: 1.5+2.5 = 4', () {
        expect(parser.evaluate('1.5+2.5'), '4');
      });

      test('modulo: 10%3 = 1', () {
        expect(parser.evaluate('10%3'), '1');
      });
    });

    group('Error Handling', () {
      test('empty expression', () {
        expect(parser.evaluate(''), 'Error');
      });

      test('invalid expression', () {
        expect(parser.evaluate('abc'), 'Error');
      });

      test('sqrt of negative', () {
        expect(parser.evaluate('sqrt(-1)'), 'Error');
      });
    });

    group('Bitwise Operations', () {
      test('hex AND: 0xFF&0x0F = 15', () {
        expect(parser.evaluate('0xFF&0x0F'), '15');
      });

      test('decimal AND: 255&15 = 15', () {
        expect(parser.evaluate('255&15'), '15');
      });

      test('hex OR: 0xF0|0x0F = 255', () {
        expect(parser.evaluate('0xF0|0x0F'), '255');
      });

      test('hex literal: 0xFF = 255', () {
        expect(parser.evaluate('0xFF'), '255');
      });

      test('hex literal: 0x0F = 15', () {
        expect(parser.evaluate('0x0F'), '15');
      });

      test('NOT: ~0 = -1', () {
        expect(parser.evaluate('~0'), '-1');
      });
    });
  });
}
