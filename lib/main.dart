import 'dart:io';
import 'dart:convert';

import 'package:PiliPlus/build_config.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/custom_toast.dart';
import 'package:PiliPlus/common/widgets/mouse_back.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/common/theme/theme_color_type.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/router/app_pages.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/services/logger.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/cache_manager.dart';
import 'package:PiliPlus/utils/calc_window_position.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/path_utils.dart';
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
import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart' hide calcWindowPosition;
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:PiliPlus/window/player_entry.dart';
import 'package:PiliPlus/plugin/player_window_manager.dart';

WebViewEnvironment? webViewEnvironment;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Determine if this engine was launched for a sub-window (player)
  String? startupWindowType;
  Map<String, dynamic>? windowArgs;
  try {
    final windowController = await WindowController.fromCurrentEngine();
    final raw = windowController.arguments;
    if (raw.isNotEmpty) {
      try {
        final parsed = jsonDecode(raw) as Map<String, dynamic>?;
        // Check for 'businessId' (our format) or 'type' (legacy)
        startupWindowType =
            parsed?['businessId'] as String? ??
                           parsed?['type'] as String?;
        windowArgs = parsed;
      } catch (_) {}
    }
  } catch (_) {}

  // If this is a player sub-window, skip most initialization and run directly
  if (startupWindowType == 'player') {
    MediaKit.ensureInitialized();

    // Initialize paths for sub-window
    tmpDirPath = (await getTemporaryDirectory()).path;
    appSupportDirPath = (await getApplicationSupportDirectory()).path;

    // Initialize storage for sub-window (uses separate Hive path)
    try {
      // Get settings from window args
      final settings = windowArgs?['settings'] as Map<String, dynamic>?;
      final allSettings = settings?['allSettings'] as Map<String, dynamic>?;
      // This also initializes Accounts.initForSubWindow() internally
      await GStorage.initForSubWindow(appSupportDirPath, allSettings);
      // Initialize HTTP client after storage is ready
      Request();
    } catch (e) {
      if (kDebugMode) debugPrint('Sub-window init error: $e');
    }

    runApp(PlayerEntry(args: windowArgs));
    return;
  }

  MediaKit.ensureInitialized();
  tmpDirPath = (await getTemporaryDirectory()).path;
  appSupportDirPath = (await getApplicationSupportDirectory()).path;
  try {
    await GStorage.init();
  } catch (e) {
    await Utils.copyText(e.toString());
    if (kDebugMode) debugPrint('GStorage init error: $e');
    exit(0);
  }
  if (Utils.isDesktop) {
    final customDownPath = Pref.downloadPath;
    if (customDownPath != null && customDownPath.isNotEmpty) {
      try {
        final dir = Directory(customDownPath);
        if (!dir.existsSync()) {
          await dir.create(recursive: true);
        }
        downloadPath = customDownPath;
      } catch (e) {
        downloadPath = defDownloadPath;
        await GStorage.setting.delete(SettingBoxKey.downloadPath);
        if (kDebugMode) {
          debugPrint('download path error: $e');
        }
      }
    } else {
      downloadPath = defDownloadPath;
    }
  } else if (Platform.isAndroid) {
    final externalStorageDirPath = (await getExternalStorageDirectory())?.path;
    downloadPath = externalStorageDirPath != null
        ? path.join(externalStorageDirPath, PathUtils.downloadDir)
        : defDownloadPath;
  } else {
    downloadPath = defDownloadPath;
  }
  Get
    ..lazyPut(AccountService.new)
    ..lazyPut(DownloadService.new);
  HttpOverrides.global = _CustomHttpOverrides();

  CacheManager.autoClearCache();

  if (Utils.isMobile) {
    await Future.wait([
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
    ]);
  }

  if (Platform.isWindows) {
    if (await WebViewEnvironment.getAvailableVersion() != null) {
      webViewEnvironment = await WebViewEnvironment.create(
        settings: WebViewEnvironmentSettings(
          userDataFolder: path.join(appSupportDirPath, 'flutter_inappwebview'),
        ),
      );
    }
  }

  Request();
  Request.setCookie();
  RequestUtils.syncHistoryStatus();
  if (Utils.isMobile) {
    PiliScheme.init();
  }

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
      skipTaskbar: false,
      titleBarStyle: Pref.showWindowTitleBar
          ? TitleBarStyle.normal
          : TitleBarStyle.hidden,
      title: Constants.appName,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      final windowSize = Pref.windowSize;
      await windowManager.setBounds(
        await calcWindowPosition(windowSize) & windowSize,
      );
      if (Pref.isWindowMaximized) await windowManager.maximize();
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
      runAppFunction: () => runApp(const MyApp()),
    );
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static ThemeData? darkThemeData;

  static bool _playerChannelInited = false;

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
        final String? storageDisplay = GStorage.setting.get(
          SettingBoxKey.displayMode,
        );
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
          title: Constants.appName,
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
                // Register channel handler once to accept openInMain requests from player window
                if (!_playerChannelInited) {
                  try {
                    const channel = WindowMethodChannel(PlayerWindowManager.channelName);
                    channel.setMethodCallHandler((call) async {
                      switch (call.method) {
                        case 'openInMain':
                          final data = call.arguments as Map?;
                          if (data != null) {
                            final route = data['route'] as String?;
                            final args = data['arguments'];
                            if (route != null && route.isNotEmpty) {
                              // Navigate in main window
                              Future.microtask(() => Get.toNamed(route, arguments: args));
                              return 'ok';
                            }

                            // fallback: if data contains video params, open video page
                            if (data.containsKey('cid')) {
                              Future.microtask(() => PageUtils.toVideoPage(
                                    videoType: data['videoType'] ?? 0,
                                    aid: data['aid'] as int?,
                                    bvid: data['bvid'] as String?,
                                    cid: data['cid'] as int? ?? 0,
                                    seasonId: data['seasonId'] as int?,
                                    epId: data['epId'] as int?,
                                    pgcType: data['pgcType'] as int?,
                                    cover: data['cover'] as String?,
                                    title: data['title'] as String?,
                                    progress: data['progress'] as int?,
                                    extraArguments: data['extraArguments'] as Map?,
                                  ));
                              return 'ok';
                            }
                          }
                          break;
                        default:
                          break;
                      }
                      return null;
                    });
                    _playerChannelInited = true;
                  } catch (_) {}
                }
              child = MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(Pref.defaultTextScale),
                ),
                child: child!,
              );
              if (Utils.isDesktop) {
                void onBack() {
                  if (SmartDialog.checkExist()) {
                    SmartDialog.dismiss();
                    return;
                  }

                  if (Get.isDialogOpen ?? Get.isBottomSheetOpen ?? false) {
                    Get.back();
                    return;
                  }

                  final plCtr = PlPlayerController.instance;
                  if (plCtr != null) {
                    if (plCtr.isFullScreen.value) {
                      plCtr
                        ..triggerFullScreen(status: false)
                        ..controlsLock.value = false;
                      return;
                    }

                    if (plCtr.isDesktopPip) {
                      plCtr.exitDesktopPip().whenComplete(
                        () => plCtr.initialFocalPoint = Offset.zero,
                      );
                      return;
                    }
                  }

                  Get.back();
                }

                return Focus(
                  canRequestFocus: false,
                  onKeyEvent: (_, event) {
                    if (event.logicalKey == LogicalKeyboardKey.escape &&
                        event is KeyDownEvent) {
                      onBack();
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: MouseBackDetector(
                    onTapDown: onBack,
                    child: child,
                  ),
                );
              }
              return child;
            },
          ),
          navigatorObservers: [
            FlutterSmartDialog.observer,
            PageUtils.routeObserver,
          ],
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            scrollbars: false,
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.stylus,
              PointerDeviceKind.invertedStylus,
              PointerDeviceKind.trackpad,
              PointerDeviceKind.unknown,
              if (Utils.isDesktop) PointerDeviceKind.mouse,
            },
          ),
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
