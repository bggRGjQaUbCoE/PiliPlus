import 'dart:convert';

import 'package:PiliPlus/common/constants.dart';
import 'package:crypto/crypto.dart';

abstract class AppSign {
  static void appSign(
    Map<String, dynamic> params, {
    String appkey = Constants.appKey,
    String appsec = Constants.appSec,
  }) {
    params['appkey'] = appkey;
    final sorted = Map.fromEntries(
      params.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    params['sign'] = md5
        .convert(utf8.encode(_makeQueryFromParametersDefault(sorted) + appsec))
        .toString(); // 获取MD5哈希值
  }

  /// from [Uri]
  static String _makeQueryFromParametersDefault(
    Map<String, dynamic /*String?|Iterable<String>*/> queryParameters,
  ) {
    var result = StringBuffer();
    var separator = '';

    void writeParameter(String key, String? value) {
      result.write(separator);
      separator = '&';
      result.write(Uri.encodeQueryComponent(key));
      if (value != null && value.isNotEmpty) {
        result
          ..write('=')
          ..write(Uri.encodeQueryComponent(value));
      }
    }

    queryParameters.forEach((key, value) {
      if (value case Iterable<String> values) {
        for (final String value in values) {
          writeParameter(key, value);
        }
      } else {
        writeParameter(key, value?.toString());
      }
    });
    return result.toString();
  }
}
