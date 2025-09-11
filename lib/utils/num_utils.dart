import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:get/get_utils/get_utils.dart';

class NumUtils {
  static final _numRegExp = RegExp(r'([\d\.]+)([千万亿])?');

  static int _getUnit(String? unit) {
    switch (unit) {
      case '千':
        return 1000;
      case '万':
        return 10000;
      case '亿':
        return 100000000;
      default:
        return 1;
    }
  }

  static int parseNum(String numberStr) {
    if (numberStr == '-') return 0;
    try {
      final match = _numRegExp.firstMatch(numberStr)!;
      var number = double.parse(match.group(1)!);
      number *= _getUnit(match.group(2));
      return number.toInt();
    } catch (e) {
      if (kDebugMode) debugPrint('parse failed: "$numberStr" : $e');
      return 0;
    }
  }

  static String numFormat(dynamic number) {
    if (number == null) {
      return '0';
    }
    if (number is String) {
      number = int.tryParse(number) ?? number;
      if (number is String) {
        return number;
      }
    }

    String format(first, second) {
      double result = ((number / first) as double).toPrecision(1);
      int intRes = result.toInt();
      if (result == intRes) {
        return '$intRes$second';
      } else {
        return '$result$second';
      }
    }

    if (number >= 100000000) {
      return format(100000000, '亿');
    } else if (number >= 10000) {
      return format(10000, '万');
    } else {
      return number.toString();
    }
  }
}
