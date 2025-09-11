import 'dart:math' show pow;

class DurationUtils {
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

  static int parseDuration(String? data) {
    if (data == null || data.isEmpty) {
      return 0;
    }
    List<int> split = data.split(':').reversed.map(int.parse).toList();
    int duration = 0;
    for (int i = 0; i < split.length; i++) {
      duration += split[i] * pow(60, i).toInt();
    }
    return duration;
  }

  static String formatDurationBetween(int startMillis, int endMillis) {
    int diffMillis = endMillis - startMillis;
    final duration = Duration(milliseconds: diffMillis);

    final inDays = duration.inDays;
    final daysLeft = inDays % 365;
    final years = inDays ~/ 365;
    final months = daysLeft ~/ 30;
    final days = daysLeft % 30;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    var format = '';

    if (years > 0) format += '$years年';
    if (months > 0) format += '$months月';
    if (days > 0) format += '$days天';
    if (hours > 0) format += '$hours小时';
    if (minutes > 0) format += '$minutes分钟';

    return format;
  }
}
