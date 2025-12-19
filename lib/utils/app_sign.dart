import 'dart:convert';

import 'package:PiliPlus/common/constants.dart';
import 'package:crypto/crypto.dart';

abstract final class AppSign {
  static void appSign(
    Map<String, dynamic> params, {
    String appkey = Constants.appKey,
    String appsec = Constants.appSec,
  }) {
    assert(
      params['appkey'] == null,
      'appkey-appsec should be provided in appSign',
    );
    params['appkey'] = appkey;
    params['ts'] ??= (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final sorted = params.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    params['sign'] = md5
        .convert(utf8.encode(_makeQueryFromParametersDefault(sorted) + appsec))
        .toString(); // 获取MD5哈希值
  }

  /// from [Uri]
  static String _makeQueryFromParametersDefault(
    List<MapEntry<String, dynamic /*String?|Iterable<String>*/>>
    queryParameters,
  ) {
    var result = StringBuffer();
    var separator = '';

    void writeParameter(String key, String? value) {
      assert(value != null, 'remove null value');
      result.write(separator);
      separator = '&';
      result.write(Uri.encodeQueryComponent(key));
      if (value != null && value.isNotEmpty) {
        result
          ..write('=')
          ..write(Uri.encodeQueryComponent(value));
      }
    }

    for (var i in queryParameters) {
      if (i.value case Iterable<String> values) {
        for (final String value in values) {
          writeParameter(i.key, value);
        }
      } else {
        writeParameter(i.key, i.value?.toString());
      }
    }
    return result.toString();
  }
}
