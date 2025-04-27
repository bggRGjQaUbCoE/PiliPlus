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
    try {
      final response = await Request().get(
        url,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status == 200 || status == 301 || status == 302;
          },
        ),
      );
      if (response.statusCode == 302 || response.statusCode == 301) {
        String? redirectUrl = response.headers['location']?.firstOrNull;
        debugPrint('redirectUrl: $redirectUrl');
        if (redirectUrl != null) {
          if (redirectUrl.startsWith('/')) {
            return returnOri ? url : null;
          }
          if (redirectUrl.endsWith('/')) {
            redirectUrl = redirectUrl.substring(0, redirectUrl.length - 1);
          }
          if (url.contains(redirectUrl)) {
            if (url.endsWith('/')) {
              url = url.substring(0, url.length - 1);
            }
            return url;
          }
          return redirectUrl;
        } else {
          if (returnOri && url.endsWith('/')) {
            url = url.substring(0, url.length - 1);
          }
          return returnOri ? url : null;
        }
      } else {
        return returnOri ? url : null;
      }
    } catch (err) {
      return returnOri ? url : null;
    }
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
