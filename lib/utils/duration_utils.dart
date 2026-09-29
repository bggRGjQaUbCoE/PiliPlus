import 'dart:math' show pow;

import 'package:PiliPlus/l10n/l10n.dart';

abstract final class DurationUtils {
  static String formatDuration(num? seconds) {
    if (seconds == null || seconds == 0) {
      return '00:00';
    }
    int h = seconds ~/ 3600;
    seconds %= 3600;
    int m = seconds ~/ 60;
    seconds %= 60;
    String sms = seconds is double
        ? seconds.toStringAsFixed(3).padLeft(6, '0')
        : seconds.toString().padLeft(2, '0');
    return h == 0
        ? "${m.toString().padLeft(2, '0')}:$sms"
        : "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:$sms";
  }

  static final _splitRegex = RegExp(r'[:：]');
  static int parseDuration(String? data) {
    if (data == null || data.isEmpty) {
      return 0;
    }
    List<int> split = data.split(_splitRegex).reversed.map(int.parse).toList();
    int duration = 0;
    for (int i = 0; i < split.length; i++) {
      duration += split[i] * pow(60, i).toInt();
    }
    return duration;
  }

  static String formatDurationBetween(int startMillis, int endMillis) =>
      formatTimeDuration(Duration(milliseconds: endMillis - startMillis));

  static String formatTimeDuration(Duration duration) {
    final inDays = duration.inDays;
    final daysLeft = inDays % 365;
    final years = inDays ~/ 365;
    final months = daysLeft ~/ 30;
    final days = daysLeft % 30;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    return [
      if (years > 0) L10n.current.durationYears(years),
      if (months > 0) L10n.current.durationMonths(months),
      if (days > 0) L10n.current.durationDays(days),
      if (hours > 0) L10n.current.durationHours(hours),
      if (minutes > 0) L10n.current.durationMinutes(minutes),
    ].join(L10n.current.durationSeparator);
  }
}
