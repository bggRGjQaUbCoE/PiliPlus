import 'dart:io';

import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/pages_tv/tv_app.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/utils/cache_manager.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

Future<void> _initAppPath() async {
  appSupportDirPath = (await getApplicationSupportDirectory()).path;
}

Future<void> _initTmpPath() async {
  tmpDirPath = (await getTemporaryDirectory()).path;
}

Future<void> _initDownPath() async {
  final externalStorageDirPath = (await getExternalStorageDirectory())?.path;
  if (externalStorageDirPath != null) {
    downloadPath = path.join(externalStorageDirPath, PathUtils.downloadDir);
  } else {
    downloadPath = defDownloadPath;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  PlatformUtils.isTV = true;

  await _initAppPath();
  try {
    await GStorage.init();
  } catch (e) {
    await Utils.copyText(e.toString());
    if (kDebugMode) debugPrint('GStorage init error: $e');
    exit(0);
  }

  await Future.wait([_initDownPath(), _initTmpPath()]);

  Get.lazyPut(AccountService.new);

  HttpOverrides.global = _TVHttpOverrides();
  CacheManager.autoClearCache();

  await setupServiceLocator();

  Request();
  Request.setCookie();
  RequestUtils.syncHistoryStatus();

  SmartDialog.config.toast = SmartConfigToast(displayType: .onlyRefresh);

  // TV immersive mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  if (Pref.dynamicColor) {
    await TVApp.initPlatformState();
  }

  runApp(const TVApp());
}

class _TVHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    if (kDebugMode || Pref.badCertificateCallback) {
      client.badCertificateCallback = (cert, host, port) => true;
    }
    return client;
  }
}
