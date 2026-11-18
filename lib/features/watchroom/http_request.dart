import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/utils/app_sign.dart';

import 'model.dart';

/// Web room APIs use cookie/CSRF. The native leave API also requires the
/// client credential and the common signed app parameters normally supplied
/// by the official client's network interceptor.
({Map<String, dynamic> parameters, Map<String, String> headers})
roomHttpRequest({
  required String path,
  required bool post,
  required Map<String, dynamic> parameters,
  required String csrf,
  required String? accessKey,
}) {
  final nativeExit = path == 'pgc/freya/room/leave';
  final data = <String, dynamic>{
    ...parameters,
    if (post || path == 'pgc/view/web/freya/season') 'csrf': csrf,
  };
  if (nativeExit) {
    if (accessKey == null || accessKey.isEmpty) {
      throw const RoomApiException(-101, '当前账号缺少客户端登录凭证，请重新登录主账号后再退出放映厅');
    }
    data.addAll({
      'access_key': accessKey,
      'build': 8430300,
      'channel': 'master',
      'c_locale': 'zh_CN',
      's_locale': 'zh_CN',
      'mobi_app': 'android',
      'platform': 'android',
    });
    data.remove('sign');
    AppSign.appSign(data);
  }
  return (
    parameters: data,
    headers: {
      'referer': 'https://www.bilibili.com/',
      'origin': 'https://www.bilibili.com',
      'user-agent': nativeExit ? Constants.userAgentApp : 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',
    },
  );
}
