import 'dart:convert' show utf8;

import 'package:PiliPlus/common/constants.dart';
import 'package:crypto/crypto.dart';

abstract final class AppSign {
  static void appSign(
    Map<String, dynamic> params, {
    String appkey = Constants.appKey,
    String appsec = Constants.appSec,
  }) {
    // retry error
    // assert(
    //   params['appkey'] == null,
    //   'appkey-appsec should be provided in appSign',
    // );
    params['appkey'] = appkey;
    params['ts'] = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final sorted = params.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    params['sign'] = md5
        .convert(utf8.encode(_makeQueryFromParametersDefault(sorted) + appsec))
        .toString(); // 获取MD5哈希值
  }

  /// 生成签名后的完整查询字符串，排序与签名计算完全一致。
  /// 空格编码为 %20（而非 +），其余特殊字符按 encodeQueryComponent 规范处理。
  static String makeQuery(Map<String, dynamic> params) {
    final sorted = params.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return _makeQueryFromParametersDefault(sorted);
  }

  /// from [Uri]
  static String _makeQueryFromParametersDefault(
    List<MapEntry<String, dynamic /*String?|Iterable<String>*/>>
    queryParameters,
  ) {
    final result = StringBuffer();
    var separator = '';

    void writeParameter(String key, String? value) {
      assert(value != null, 'remove null value');
      result.write(separator);
      separator = '&';
      result.write(Uri.encodeQueryComponent(key).replaceAll('+', '%20'));
      if (value != null && value.isNotEmpty) {
        result
          ..write('=')
          ..write(Uri.encodeQueryComponent(value).replaceAll('+', '%20'));
      }
    }

    for (final i in queryParameters) {
      if (i.value case final Iterable<String> values) {
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
