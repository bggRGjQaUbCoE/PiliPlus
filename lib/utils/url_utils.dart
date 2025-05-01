import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../http/init.dart';
import '../http/search.dart';
import 'id_utils.dart';
import 'utils.dart';

class UrlUtils {
  // 302重定向路由截取
  static Future<String?> parseRedirectUrl(
    String url, [
    bool returnOri = false,
  ]) async {
    String? redirectUrl;
    try {
      final response = await Request.dio.head(
        url,
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return 200 <= status! && status < 400;
            },
            extra: {'account': AnonymousAccount()}),
      );
      if (response.isRedirect) {
        redirectUrl = response.headers['location']?.firstOrNull;
        debugPrint('redirectUrl: $redirectUrl');
        if (redirectUrl != null && !redirectUrl.startsWith('http')) {
          redirectUrl = Uri.parse(url).resolve(redirectUrl).toString();
        }
      }
    } catch (_) {}
    if (returnOri && redirectUrl == null) redirectUrl = url;
    if (redirectUrl?.endsWith('/') == true) {
      redirectUrl = redirectUrl!.substring(0, redirectUrl.length - 1);
    }
    return redirectUrl;
  }

  // 匹配url路由跳转
  static matchUrlPush(
    String pathSegment,
    String redirectUrl,
  ) async {
    final Map matchRes = IdUtils.matchAvorBv(input: pathSegment);
    if (matchRes.isNotEmpty) {
      int? aid = matchRes['AV'];
      String? bvid = matchRes['BV'];
      bvid ??= IdUtils.av2bv(aid!);
      final int cid = await SearchHttp.ab2c(aid: aid, bvid: bvid);
      PageUtils.toVideoPage(
        'bvid=$bvid&cid=$cid',
        arguments: <String, String?>{
          'pic': '',
          'heroTag': Utils.makeHeroTag(bvid),
        },
        preventDuplicates: false,
      );
    } else {
      if (redirectUrl.isNotEmpty) {
        PageUtils.handleWebview(redirectUrl);
      } else {
        SmartDialog.showToast('matchUrlPush: $pathSegment');
      }
    }
  }
}
