import 'dart:io';

import 'package:PiliPlus/build_config.dart';
import 'package:PiliPlus/common/widgets/custom_toast.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/common/theme/theme_color_type.dart';
import 'package:PiliPlus/router/app_pages.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/services/logger.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/cache_manage.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:catcher_2/catcher_2.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await GStorage.init();
  Get.lazyPut(AccountService.new);
  HttpOverrides.global = _CustomHttpOverrides();

  await Future.wait([
    CacheManage.autoClearCache(),
    if (Utils.isMobile) ...[
      SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          if (Pref.horizontalScreen) ...[
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ],
        ],
      ),
      setupServiceLocator(),
    ],
  ]);

  Request();
  Request.setCookie();
  RequestUtils.syncHistoryStatus();
  PiliScheme.init();

  SmartDialog.config.toast = SmartConfigToast(
    displayType: SmartToastType.onlyRefresh,
  );

  if (Utils.isMobile) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
      ),
    );
  } else if (Utils.isDesktop) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      minimumSize: const Size(400, 720),
      size: const Size(1180, 720),
      center: true,
      skipTaskbar: false,
      titleBarStyle: Platform.isMacOS
          ? TitleBarStyle.hidden
          : TitleBarStyle.normal,
      title: 'PiliPlus',
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  if (Pref.enableLog) {
    // 异常捕获 logo记录
    String buildConfig =
        '''\n
Build Time: ${DateFormatUtils.format(BuildConfig.buildTime, format: DateFormatUtils.longFormatDs)}
Commit Hash: ${BuildConfig.commitHash}''';
    final Catcher2Options debugConfig = Catcher2Options(
      SilentReportMode(),
      [
        FileHandler(await LoggerUtils.getLogsPath()),
        ConsoleHandler(
          enableDeviceParameters: false,
          enableApplicationParameters: false,
          enableCustomParameters: true,
        ),
      ],
      customParameters: {
        'BuildConfig': buildConfig,
      },
    );

    final Catcher2Options releaseConfig = Catcher2Options(
      SilentReportMode(),
      [
        FileHandler(await LoggerUtils.getLogsPath()),
        ConsoleHandler(
          enableCustomParameters: true,
        ),
      ],
      customParameters: {
        'BuildConfig': buildConfig,
      },
    );

    Catcher2(
      debugConfig: debugConfig,
      releaseConfig: releaseConfig,
      runAppFunction: () {
        runApp(const MyApp());
      },
    );
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static ThemeData? darkThemeData;

  @override
  Widget build(BuildContext context) {
    Color brandColor = colorThemeTypes[Pref.customColor].color;
    bool isDynamicColor = Pref.dynamicColor;
    FlexSchemeVariant variant = FlexSchemeVariant.values[Pref.schemeVariant];

    // 强制设置高帧率
    if (Platform.isAndroid) {
      late List<DisplayMode> modes;
      FlutterDisplayMode.supported.then((value) {
        modes = value;
        var storageDisplay = GStorage.setting.get(SettingBoxKey.displayMode);
        DisplayMode? displayMode;
        if (storageDisplay != null) {
          displayMode = modes.firstWhereOrNull(
            (e) => e.toString() == storageDisplay,
          );
        }
        displayMode ??= DisplayMode.auto;
        FlutterDisplayMode.setPreferredMode(displayMode);
      });
    }

    return DynamicColorBuilder(
      builder: ((ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme? lightColorScheme;
        ColorScheme? darkColorScheme;
        if (lightDynamic != null && darkDynamic != null && isDynamicColor) {
          // dynamic取色成功
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          // dynamic取色失败，采用品牌色
          lightColorScheme = SeedColorScheme.fromSeeds(
            primaryKey: brandColor,
            brightness: Brightness.light,
            variant: variant,
            // dynamicSchemeVariant: dynamicSchemeVariant,
            // tones: FlexTones.soft(Brightness.light),
          );
          darkColorScheme = SeedColorScheme.fromSeeds(
            primaryKey: brandColor,
            brightness: Brightness.dark,
            variant: variant,
            // dynamicSchemeVariant: dynamicSchemeVariant,
            // tones: FlexTones.soft(Brightness.dark),
          );
        }

        // 图片缓存
        // PaintingBinding.instance.imageCache.maximumSizeBytes = 1000 << 20;
        return GetMaterialApp(
          // showSemanticsDebugger: true,
          title: 'PiliPlus',
          theme: ThemeUtils.getThemeData(
            colorScheme: lightColorScheme,
            isDynamic: lightDynamic != null && isDynamicColor,
            variant: variant,
          ),
          darkTheme: ThemeUtils.getThemeData(
            colorScheme: darkColorScheme,
            isDynamic: darkDynamic != null && isDynamicColor,
            isDark: true,
            variant: variant,
          ),
          themeMode: Pref.themeMode,
          localizationsDelegates: const [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          locale: const Locale("zh", "CN"),
          supportedLocales: const [Locale("zh", "CN"), Locale("en", "US")],
          fallbackLocale: const Locale("zh", "CN"),
          getPages: Routes.getPages,
          initialRoute: '/',
          builder: FlutterSmartDialog.init(
            toastBuilder: (String msg) => CustomToast(msg: msg),
            loadingBuilder: (msg) => LoadingWidget(msg: msg),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(Pref.defaultTextScale),
                ),
                child: child!,
              );
            },
          ),
          navigatorObservers: [
            FlutterSmartDialog.observer,
            PageUtils.routeObserver,
          ],
          scrollBehavior: const ScrollBehavior().copyWith(scrollbars: false),
        );
      }),
    );
  }
}

class _CustomHttpOverrides extends HttpOverrides {
  final badCertificateCallback = kDebugMode || Pref.badCertificateCallback;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context)
      // ..maxConnectionsPerHost = 32
      ..idleTimeout = const Duration(seconds: 15);
    if (badCertificateCallback) {
      client.badCertificateCallback = (cert, host, port) => true;
    }
    return client;
  }
}
