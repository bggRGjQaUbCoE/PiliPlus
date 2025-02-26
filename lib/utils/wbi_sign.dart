// Wbi签名 用于生成 REST API 请求中的 w_rid 和 wts 字段
// https://github.com/SocialSisterYi/bilibili-API-collect/blob/master/docs/misc/sign/wbi.md
// import md5 from 'md5'
// import axios from 'axios'
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'package:synchronized/synchronized.dart';
import '../http/index.dart';
import 'storage.dart';

class WbiSign {
  static Box get localCache => GStorage.localCache;
  static final Lock lock = Lock();
  static final RegExp chrFilter = RegExp(r"[!\'\(\)\*]");
  static const mixinKeyEncTab = <int>[
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
    13
  ];

  // 对 imgKey 和 subKey 进行字符顺序打乱编码
  static String getMixinKey(String orig) {
    return mixinKeyEncTab.map((i) => orig[i]).join();
  }

  // 为请求参数进行 wbi 签名
  static void encWbi(Map<String, dynamic> params, String mixinKey) {
    params['wts'] = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    // 按照 key 重排参数
    final List<String> keys = params.keys.toList()..sort();
    final queryStr = keys
        .map((i) =>
            '${Uri.encodeComponent(i)}=${Uri.encodeComponent(params[i].toString().replaceAll(chrFilter, ''))}')
        .join('&');
    params['w_rid'] =
        md5.convert(utf8.encode(queryStr + mixinKey)).toString(); // 计算 w_rid
  }

  static String getFileName(String uri) {
    return uri.substring(uri.lastIndexOf('/') + 1, uri.lastIndexOf('.'));
  }

  // 获取最新的 img_key 和 sub_key 可以从缓存中获取
  static Future<String> getWbiKeys() async {
    final DateTime nowDate = DateTime.now();
    String? mixinKey = localCache.get(LocalCacheKey.mixinKey);
    if (mixinKey != null &&
        DateTime.fromMillisecondsSinceEpoch(
                    localCache.get(LocalCacheKey.timeStamp) as int)
                .day ==
            nowDate.day) {
      return mixinKey;
    }
    final resp = await Request().get(Api.userInfo);
    final wbiUrls = resp.data['data']['wbi_img'];

    mixinKey = getMixinKey(
        getFileName(wbiUrls['img_url']) + getFileName(wbiUrls['sub_url']));

    localCache.put(LocalCacheKey.mixinKey, mixinKey);
    localCache.put(LocalCacheKey.timeStamp, nowDate.millisecondsSinceEpoch);
    return mixinKey;
  }

  static Future<Map<String, dynamic>> makSign(
      Map<String, dynamic> params) async {
    // params 为需要加密的请求参数
    final String mixinKey = await lock.synchronized(getWbiKeys);
    encWbi(params, mixinKey);
    return params;
  }
}
