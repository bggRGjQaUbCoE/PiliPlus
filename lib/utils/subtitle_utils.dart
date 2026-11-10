import 'dart:typed_data' show Uint8List;

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:dio/dio.dart' show Options;

enum SubtitleFormat implements EnumWithLabel {
  json('JSON'),
  vtt('WEBVTT'),
  srt('SRT');

  @override
  final String label;
  const SubtitleFormat(this.label);
}

abstract final class SubtitleUtils {
  static const String _json = '.json';
  static const String _bcc = '.bcc';
  static bool isJson(String fileName) =>
      fileName.endsWith(_json) ||
      fileName.endsWith(_bcc) ||
      fileName.endsWith(PathUtils.subtitleExt);

  static const exts = [_json, 'vtt', 'srt', 'ass', _bcc, PathUtils.subtitleExt];

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

  static Future<Uint8List?> getSubtitle(String url) async {
    final res = await Request.dio.get<Uint8List>(
      url.http2https,
      options: Options(
        responseType: .bytes,
        headers: Constants.baseHeaders,
        extra: {'account': const NoAccount()},
      ),
    );
    if (res.statusCode != 200) return null;
    return Uint8List.fromList(
      Request.responseBytesDecoder(res.data!, res.headers.map),
    );
  }
}
