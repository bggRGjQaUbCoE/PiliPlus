import 'dart:convert';

import 'package:PiliPlus/common/constants.dart';
import 'package:crypto/crypto.dart';

abstract class AppSign {
  static void appSign(
    Map<String, dynamic> params, [
    String appkey = Constants.appKey,
    String appsec = Constants.appSec,
  ]) {
    params['appkey'] = appkey;
    var searchParams = Uri(
      queryParameters: params.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    ).query;
    var sortedQueryString = (searchParams.split('&')..sort()).join('&');

    params['sign'] = md5
        .convert(utf8.encode(sortedQueryString + appsec))
        .toString(); // 获取MD5哈希值
  }
}
