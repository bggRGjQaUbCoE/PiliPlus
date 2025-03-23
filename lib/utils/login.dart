import 'dart:math';

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/dynamics_type.dart';
import 'package:PiliPlus/models/common/tab_type.dart' hide tabsConfig;
import 'package:PiliPlus/models/user/info.dart';
import 'package:PiliPlus/models/user/stat.dart';
import 'package:PiliPlus/pages/bangumi/controller.dart';
import 'package:PiliPlus/pages/dynamics/tab/controller.dart';
import 'package:PiliPlus/pages/live/controller.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/pages/dynamics/index.dart';
import 'package:PiliPlus/pages/home/index.dart';
import 'package:PiliPlus/pages/media/index.dart';
import 'package:PiliPlus/pages/mine/index.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as web;
import 'package:PiliPlus/pages/dynamics/controller.dart';
import 'package:PiliPlus/pages/home/controller.dart';
import 'package:PiliPlus/pages/media/controller.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/http/user.dart';

class LoginUtils {
  static final random = Random();

  static Future onLoginMain() async {
    final account = Accounts.main;
    try {
      final cookies = account.cookieJar.toList();
      final webManager = web.CookieManager();
      Future.wait([
        WebviewCookieManager().setCookies(cookies),
        ...cookies.map((item) => webManager.setCookie(
              url: web.WebUri(item.domain ?? ''),
              name: item.name,
              value: item.value,
              path: item.path ?? '',
              domain: item.domain,
              isSecure: item.secure,
              isHttpOnly: item.httpOnly,
            ))
      ]);
    } catch (e) {
      SmartDialog.showToast('设置登录态失败，$e');
    }
    final result = await UserHttp.userInfo();
    final UserInfoData data = result['data'];
    if (result['status'] && data.isLogin!) {
      SmartDialog.showToast('main登录成功');
      await GStorage.userInfo.put('userInfoCache', data);
      try {
        Get.find<MineController>()
          ..isLogin.value = true
          ..queryUserInfo();
      } catch (_) {}

      try {
        Get.find<HomeController>()
          ..isLogin.value = true
          ..userFace.value = data.face!;
      } catch (_) {}

      try {
        Get.find<DynamicsController>()
          ..isLogin.value = true
          ..ownerMid = data.mid
          ..face = data.face
          ..onRefresh();
      } catch (_) {}

      for (int i = 0; i < tabsConfig.length; i++) {
        try {
          Get.find<DynamicsTabController>(tag: tabsConfig[i]['tag'])
              .onRefresh();
        } catch (_) {}
      }

      try {
        Get.find<MediaController>()
          ..mid = data.mid
          ..onRefresh();
      } catch (_) {}

      try {
        Get.find<LiveController>()
          ..isLogin.value = true
          ..fetchLiveFollowing();
      } catch (_) {}

      try {
        Get.find<BangumiController>(tag: TabType.bangumi.name)
          ..isLogin.value = true
          ..queryBangumiFollow();
      } catch (_) {}

      try {
        Get.find<BangumiController>(tag: TabType.cinema.name)
          ..isLogin.value = true
          ..queryBangumiFollow();
      } catch (_) {}
    } else {
      // 获取用户信息失败
      await Accounts.deleteAll({account});
      SmartDialog.showNotify(
          msg: '登录失败，请检查cookie是否正确，${result['message']}',
          notifyType: NotifyType.warning);
    }
  }

  static Future onLogoutMain() async {
    await Future.wait([
      web.CookieManager().deleteAllCookies(),
      GStorage.userInfo.delete('userInfoCache'),
    ]);

    try {
      Get.find<MainController>().isLogin.value = false;
    } catch (_) {}

    try {
      Get.find<MineController>()
        ..userInfo.value = UserInfoData()
        ..userStat.value = UserStat()
        ..isLogin.value = false;
      // MineController.anonymity.value = false;
    } catch (_) {}

    try {
      Get.find<HomeController>()
        ..isLogin.value = false
        ..userFace.value = '';
    } catch (_) {}

    try {
      Get.find<DynamicsController>()
        ..isLogin.value = false
        ..onRefresh();
    } catch (_) {}

    try {
      Get.find<MediaController>()
        ..mid = null
        ..loadingState.value = LoadingState.loading();
    } catch (_) {}

    try {
      Get.find<LiveController>()
        ..isLogin.value = false
        ..followListState.value = LoadingState.loading();
    } catch (_) {}

    for (int i = 0; i < tabsConfig.length; i++) {
      try {
        Get.find<DynamicsTabController>(tag: tabsConfig[i]['tag']).onRefresh();
      } catch (_) {}
    }

    try {
      Get.find<BangumiController>(tag: TabType.bangumi.name)
        ..isLogin.value = false
        ..followState.value = LoadingState.loading();
    } catch (_) {}

    try {
      Get.find<BangumiController>(tag: TabType.cinema.name)
        ..isLogin.value = false
        ..followState.value = LoadingState.loading();
    } catch (_) {}
  }

  static String generateBuvid() {
    var md5Str =
        Iterable.generate(32, (_) => random.nextInt(16).toRadixString(16))
            .join()
            .toUpperCase();
    return 'XY${md5Str[2]}${md5Str[12]}${md5Str[22]}$md5Str';
  }

  static final buvid = generateBuvid();

  // static String getUUID() {
  //   return const Uuid().v4().replaceAll('-', '');
  // }

  // static String generateBuvid() {
  //   String uuid = getUUID() + getUUID();
  //   return 'XY${uuid.substring(0, 35).toUpperCase()}';
  // }

  static String genDeviceId() {
    // https://github.com/bilive/bilive_client/blob/2873de0532c54832f5464a4c57325ad9af8b8698/bilive/lib/app_client.ts#L62
    final String yyyyMMddHHmmss = DateTime.now()
        .toIso8601String()
        .replaceAll(RegExp(r'[-:TZ]'), '')
        .substring(0, 14);

    final String randomHex32 =
        List.generate(32, (index) => random.nextInt(16).toRadixString(16))
            .join();
    final String randomHex16 =
        List.generate(16, (index) => random.nextInt(16).toRadixString(16))
            .join();

    final String deviceID = randomHex32 + yyyyMMddHHmmss + randomHex16;

    final List<int> bytes = RegExp(r'\w{2}')
        .allMatches(deviceID)
        .map((match) => int.parse(match.group(0)!, radix: 16))
        .toList();
    final int checksumValue = bytes.reduce((a, b) => a + b);
    final String check = checksumValue
        .toRadixString(16)
        .substring(checksumValue.toRadixString(16).length - 2);

    return deviceID + check;
  }
}
