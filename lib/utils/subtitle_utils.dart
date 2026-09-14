import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:collection/collection.dart' show IterableExtension;

enum SubtitleFormat implements EnumWithLabel {
  json('JSON'),
  vtt('WEBVTT'),
  srt('SRT'),
  txt('TXT');

  @override
  final String label;
  const SubtitleFormat(this.label);
}

abstract final class SubtitleUtils {
  static String _vttTimecode(num seconds) {
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    seconds %= 3600;
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    seconds %= 60;
    final sms = seconds.toStringAsFixed(3).padLeft(6, '0');
    return "$h:$m:$sms";
  }

  static String json2Vtt(List list) {
    final sb = StringBuffer('WEBVTT\n\n')
      ..writeAll(
        list.map(
          (item) =>
              '${_vttTimecode(item['from'])} --> ${_vttTimecode(item['to'])}\n${item['content'].trim()}',
        ),
        '\n\n',
      );
    return sb.toString();
  }

  static String _srtTimecode(num seconds) {
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    seconds %= 3600;
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    seconds %= 60;
    final s = seconds.toInt();
    final ms = ((seconds - s) * 1000).round().toString().padLeft(3, '0');
    return '$h:$m:${s.toString().padLeft(2, '0')},$ms';
  }

  static String json2Srt(List list) {
    final sb = StringBuffer()
      ..writeAll(
        list.mapIndexed(
          (i, e) =>
              '${i + 1}\n${_srtTimecode(e['from'])} --> ${_srtTimecode(e['to'])}\n${e['content'].trim()}',
        ),
        '\n\n',
      );
    return sb.toString();
  }

  static String _txtTimecode(num seconds) {
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    seconds %= 3600;
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    seconds %= 60;
    return '$h:$m:${seconds.toInt().toString().padLeft(2, '0')}';
  }

  /// 纯文本字幕：一条字幕一行，行首 `[hh:mm:ss]`，行内换行折叠为空格
  static String json2Txt(List list) {
    final sb = StringBuffer();
    for (final e in list) {
      final content = (e['content'] as String? ?? '')
          .trim()
          .replaceAll(RegExp(r'\s*\n\s*'), ' ');
      if (content.isEmpty) continue;
      sb.writeln('[${_txtTimecode(e['from'])}] $content');
    }
    return sb.toString();
  }
}
