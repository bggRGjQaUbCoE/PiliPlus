import 'dart:async' show FutureOr;
import 'dart:io' show Platform;
import 'dart:math';

import 'package:PiliPlus/grpc/grpc_req.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/common/home_tab_type.dart';
import 'package:PiliPlus/models/user/info.dart';
import 'package:PiliPlus/models/user/stat.dart';
import 'package:PiliPlus/pages/dynamics/controller.dart';
import 'package:PiliPlus/pages/dynamics_tab/controller.dart';
import 'package:PiliPlus/pages/live/controller.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/pages/pgc/controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as web;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class LoginUtils {
  static final random = Random();

  static FutureOr setWebCookie([Account? account]) {
    if (Platform.isWindows) {
      return null;
    }
    final cookies = (account ?? Accounts.main).cookieJar.toList();
    final webManager = web.CookieManager();
    return Future.wait(
      cookies.map(
        (cookie) => webManager.setCookie(
          url: web.WebUri(cookie.domain ?? ''),
          name: cookie.name,
          value: cookie.value,
          path: cookie.path ?? '/',
          domain: cookie.domain,
          isSecure: cookie.secure,
          isHttpOnly: cookie.httpOnly,
        ),
      ),
    );
  }

  static Future<void> onLoginMain() async {
    final account = Accounts.main;
    GrpcReq.updateHeaders(account.accessKey);
    setWebCookie(account);
    RequestUtils.syncHistoryStatus();
    final result = await UserHttp.userInfo();
    if (result.isSuccess) {
      final UserInfoData data = result.data;
      if (data.isLogin == true) {
        Get.find<AccountService>()
          ..mid = data.mid!
          ..name.value = data.uname!
          ..face.value = data.face!
          ..isLogin.value = true;

        SmartDialog.showToast('main登录成功');
        if (data != Pref.userInfoCache) {
          await GStorage.userInfo.put('userInfoCache', data);
        }

        try {
          Get.find<MineController>().onRefresh();
        } catch (_) {}

        try {
          Get.find<DynamicsController>().onRefresh();
        } catch (_) {}

        for (var item in DynamicsTabType.values) {
          try {
            Get.find<DynamicsTabController>(tag: item.name).onRefresh();
          } catch (_) {}
        }

        try {
          Get.find<LiveController>().onRefresh();
        } catch (_) {}

        try {
          Get.find<PgcController>(
            tag: HomeTabType.bangumi.name,
          ).queryPgcFollow();
        } catch (_) {}

        try {
          Get.find<PgcController>(
            tag: HomeTabType.cinema.name,
          ).queryPgcFollow();
        } catch (_) {}
      }
    } else {
      // 获取用户信息失败
      await Accounts.deleteAll({account});
      SmartDialog.showNotify(
        msg: '登录失败，请检查cookie是否正确，${result.toString()}',
        notifyType: NotifyType.warning,
      );
    }
  }

  static Future<void> onLogoutMain() async {
    Get.find<AccountService>()
      ..mid = 0
      ..name.value = ''
      ..face.value = ''
      ..isLogin.value = false;

    GrpcReq.updateHeaders(null);

    await Future.wait([
      web.CookieManager().deleteAllCookies(),
      GStorage.userInfo.delete('userInfoCache'),
    ]);

    try {
      Get.find<MainController>().setDynCount();
    } catch (_) {}

    try {
      Get.find<MineController>()
        ..userInfo.value = UserInfoData()
        ..userStat.value = UserStat()
        ..loadingState.value = LoadingState.loading();
      // MineController.anonymity.value = false;
    } catch (_) {}

    try {
      Get.find<DynamicsController>().onRefresh();
    } catch (_) {}

    try {
      Get.find<LiveController>().onRefresh();
    } catch (_) {}

    for (var item in DynamicsTabType.values) {
      try {
        Get.find<DynamicsTabController>(tag: item.name).onRefresh();
      } catch (_) {}
    }

    try {
      Get.find<PgcController>(tag: HomeTabType.bangumi.name).followState.value =
          LoadingState.loading();
    } catch (_) {}

    try {
      Get.find<PgcController>(tag: HomeTabType.cinema.name).followState.value =
          LoadingState.loading();
    } catch (_) {}
  }

  static String generateBuvid() {
    var md5Str = Iterable.generate(
      32,
      (_) => random.nextInt(16).toRadixString(16),
    ).join().toUpperCase();
    return 'XY${md5Str[2]}${md5Str[12]}${md5Str[22]}$md5Str';
  }

  static final buvid = Pref.buvid;

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

    final String randomHex32 = List.generate(
      32,
      (index) => random.nextInt(16).toRadixString(16),
    ).join();
    final String randomHex16 = List.generate(
      16,
      (index) => random.nextInt(16).toRadixString(16),
    ).join();

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
