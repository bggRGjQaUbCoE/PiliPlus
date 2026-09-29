import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;

abstract final class NumUtils {
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

    if (L10n.locale.languageCode == 'zh') {
      if (number < 10000) return number.toString();

      final hundredMillion = number >= 100000000;
      final result = ((number / (hundredMillion ? 100000000 : 10000)) as double)
          .toPrecision(1);
      final text = result == result.toInt()
          ? result.toInt().toString()
          : result.toString();
      final traditional = L10n.locale.scriptCode == 'Hant';
      final unit = hundredMillion
          ? (traditional ? '億' : '亿')
          : (traditional ? '萬' : '万');
      return '$text$unit';
    }

    if (number < 1000) return number.toString();

    const units = ['K', 'M', 'B'];
    double result = number / 1000;
    var unit = 0;
    while (result.toPrecision(1) >= 1000 && unit < units.length - 1) {
      result /= 1000;
      unit++;
    }
    result = result.toPrecision(1);
    final text = result == result.toInt()
        ? result.toInt().toString()
        : result.toString();
    return '$text${units[unit]}';
  }

  static String formatPositiveDecimal(int number) {
    if (number < 1000) return number.toString();

    final numStr = number.toString();
    final length = numStr.length;
    final sb = StringBuffer();

    int firstLength = length % 3;
    if (firstLength == 0) firstLength = 3;

    sb.write(numStr.substring(0, firstLength));
    for (int i = firstLength; i < length; i += 3) {
      sb
        ..write(',')
        ..write(numStr.substring(i, i + 3));
    }

    return sb.toString();
  }
}
