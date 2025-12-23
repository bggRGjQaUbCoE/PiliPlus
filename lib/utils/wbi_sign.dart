// Wbi签名 用于生成 REST API 请求中的 w_rid 和 wts 字段
// https://github.com/SocialSisterYi/bilibili-API-collect/blob/master/docs/misc/sign/wbi.md
// import md5 from 'md5'
// import axios from 'axios'
import 'dart:convert';

import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';

abstract final class WbiSign {
  static Box get _localCache => GStorage.localCache;
  static final RegExp _chrFilter = RegExp(r"[!\'\(\)\*]");
  static const _mixinKeyEncTab = <int>[
    46,
    47,
    18,
    2,
    53,
    8,
    23,
    32,
    15,
    50,
    10,
    31,
    58,
    3,
    45,
    35,
    27,
    43,
    5,
    49,
    33,
    9,
    42,
    19,
    29,
    28,
    14,
    39,
    12,
    38,
    41,
    13,
  ];

  static Future<String>? _future;

  // 对 imgKey 和 subKey 进行字符顺序打乱编码
  static String getMixinKey(String orig) {
    final codeUnits = orig.codeUnits;
    return String.fromCharCodes(_mixinKeyEncTab.map((i) => codeUnits[i]));
  }

  // 为请求参数进行 wbi 签名
  static void encWbi(Map<String, Object> params, String mixinKey) {
    params['wts'] = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    // 按照 key 重排参数
    final List<String> keys = params.keys.toList()..sort();
    final queryStr = keys
        .map(
          (i) =>
              '${Uri.encodeComponent(i)}=${Uri.encodeComponent(params[i].toString().replaceAll(_chrFilter, ''))}',
        )
        .join('&');
    params['w_rid'] = md5
        .convert(utf8.encode(queryStr + mixinKey))
        .toString(); // 计算 w_rid
  }

  static Future<String> _getWbiKeys(DateTime nowDate) async {
    final resp = await Request().get(Api.userInfo);
    try {
      final wbiUrls = resp.data['data']['wbi_img'];

      final mixinKey = getMixinKey(
        Utils.getFileName(wbiUrls['img_url'], fileExt: false) +
            Utils.getFileName(wbiUrls['sub_url'], fileExt: false),
      );

      _localCache
        ..put(LocalCacheKey.mixinKey, mixinKey)
        ..put(LocalCacheKey.timeStamp, DateTime.now().millisecondsSinceEpoch);

      return mixinKey;
    } catch (_) {
      return '';
    }
  }

  static Future<String> getWbiKeys() async {
    final DateTime nowDate = DateTime.now();
    if (DateTime.fromMillisecondsSinceEpoch(
          _localCache.get(LocalCacheKey.timeStamp, defaultValue: 0) as int,
        ).day ==
        nowDate.day) {
      final String? mixinKey = _localCache.get(LocalCacheKey.mixinKey);
      if (mixinKey != null) return mixinKey;
      return _future ??= _getWbiKeys(nowDate);
    } else {
      return _future = _getWbiKeys(nowDate);
    }
  }

  static Future<Map<String, Object>> makSign(
    Map<String, Object> params,
  ) async {
    // params 为需要加密的请求参数
    final String mixinKey = await getWbiKeys();
    encWbi(params, mixinKey);
    return params;
  }
}
