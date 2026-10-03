import 'dart:io';

import 'package:PiliPlus/build_config.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/back_detector.dart';
import 'package:PiliPlus/common/widgets/custom_toast.dart';
import 'package:PiliPlus/common/widgets/route_aware_mixin.dart';
import 'package:PiliPlus/common/widgets/scale_app.dart';
import 'package:PiliPlus/common/widgets/scroll_behavior.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/common/theme/theme_color_type.dart';
import 'package:PiliPlus/plugin/pl_player/utils/fullscreen.dart';
import 'package:PiliPlus/router/app_pages.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/services/logger.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/utils/cache_manager.dart';
import 'package:PiliPlus/utils/calc_window_position.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/extension/core_palettes_ext.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/font_utils.dart';
import 'package:PiliPlus/utils/json_file_handler.dart';
import 'package:PiliPlus/utils/max_screen_size.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:catcher_2/catcher_2.dart';
import 'package:collection/collection.dart';
import 'package:dynamic_color/dynamic_color.dart' show DynamicColorPlugin;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:screen_brightness_platform_interface/screen_brightness_platform_interface.dart';
import 'package:window_manager/window_manager.dart' hide calcWindowPosition;

WebViewEnvironment? webViewEnvironment;

EdgeInsets? tmpPadding;

Future<void> _initDownPath() async {
  if (PlatformUtils.isDesktop) {
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
}

Future<void> _initTmpPath() async {
  try {
    tmpDirPath = (await getTemporaryDirectory()).path;
  } catch (e) {
    if (kDebugMode) {
      debugPrint('getTemporaryDirectory error: $e');
    }
    final fallback = path.join(appSupportDirPath, 'tmp');
    await Directory(fallback).create(recursive: true);
    tmpDirPath = fallback;
  }
}

/// Prepares [appSupportDirPath].
///
/// Returns `null` when an application data directory is ready, otherwise a
/// description of every failure. On Windows, when the platform application
/// support directory cannot be used (restricted environments, portable usage,
/// security software blocking writes to `%APPDATA%`), a `portable_data` folder
/// next to the executable is used instead so that the app can still start.
Future<String?> _initAppPath() async {
  final candidates = <String>[];
  String? platformError;
  try {
    candidates.add((await getApplicationSupportDirectory()).path);
  } catch (e) {
    platformError = e.toString();
    if (kDebugMode) {
      debugPrint('getApplicationSupportDirectory error: $e');
    }
  }
  if (Platform.isWindows) {
    candidates.add(
      path.join(path.dirname(Platform.resolvedExecutable), 'portable_data'),
    );
  }
  final errors = <String>[
    ?platformError,
  ];
  for (final candidate in candidates) {
    try {
      final dir = Directory(candidate);
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      // The directory may exist but still reject writes.
      final probe = File(path.join(candidate, '.write_test'));
      await probe.writeAsString('ok', flush: true);
      await probe.delete();
      appSupportDirPath = candidate;
      if (kDebugMode) {
        debugPrint('appSupportDirPath: $appSupportDirPath');
      }
      return null;
    } catch (e) {
      errors.add('$candidate: $e');
    }
  }
  return errors.join('\n\n');
}

void main() async {
  ScaledWidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  final String? appPathError = await _initAppPath();
  if (appPathError != null) {
    runApp(_StartupErrorApp(appPathError));
    return;
  }
  try {
    await GStorage.init();
  } catch (e, st) {
    if (kDebugMode) {
      debugPrint('GStorage init error: $e');
      debugPrint('$st');
    }
    try {
      await Utils.copyText(e.toString(), needToast: false);
    } catch (_) {}
    runApp(_StartupErrorApp(e.toString()));
    return;
  }
  ScaledWidgetsFlutterBinding.instance.scaleFactor = Pref.uiScale;
  try {
    await CacheManager.ensureInitialized();
  } catch (e, st) {
    if (kDebugMode) {
      debugPrint('image cache init error: $e');
      debugPrint('$st');
    }
    runApp(_StartupErrorApp(e.toString()));
    return;
  }
  try {
    await Future.wait([
      _initDownPath(),
      _initTmpPath(),
      ?FontUtils.init(),
    ]);
  } catch (e, st) {
    // Non-essential startup work must not keep the app from starting.
    if (kDebugMode) {
      debugPrint('startup init error: $e');
      debugPrint('$st');
    }
  }
  Get
    ..lazyPut(AccountService.new)
    ..lazyPut(DownloadService.new);
  HttpOverrides.global = _CustomHttpOverrides();

  if (PlatformUtils.isMobile) {
    if (Platform.isAndroid) MaxScreenSize.init();
    await Future.wait([
      if (Pref.horizontalScreen) ?fullMode() else ?portraitUpMode(),
      setupServiceLocator(),
    ]);
  } else if (Platform.isWindows) {
    if (await WebViewEnvironment.getAvailableVersion() != null) {
      webViewEnvironment = await WebViewEnvironment.create(
        settings: WebViewEnvironmentSettings(
          userDataFolder: path.join(appSupportDirPath, 'flutter_inappwebview'),
        ),
      );
    }
  } else if (Platform.isMacOS) {
    await setupServiceLocator();
  }

  Request();
  Request.setCookie();
  RequestUtils.syncHistoryStatus();

  SmartDialog.config.toast = SmartConfigToast(displayType: .onlyRefresh);

  if (PlatformUtils.isMobile) {
    SystemChrome.setEnabledSystemUIMode(.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
      ),
    );
    if (Platform.isAndroid) {
      FlutterDisplayMode.supported.then((mode) {
        final String? storageDisplay = GStorage.setting.get(
          SettingBoxKey.displayMode,
        );
        DisplayMode? displayMode;
        if (storageDisplay != null) {
          displayMode = mode.firstWhereOrNull(
            (e) => e.toString() == storageDisplay,
          );
        }
        FlutterDisplayMode.setPreferredMode(displayMode ?? DisplayMode.auto);
      });
    } else {
      ScreenBrightnessPlatform.instance.setAutoReset(false);
    }
  } else if (PlatformUtils.isDesktop) {
    FocusManager.instance.addEarlyKeyEventHandler(_onKeyEvent);

    await windowManager.ensureInitialized();

    final windowOptions = WindowOptions(
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

  if (Pref.dynamicColor) {
    await MyApp.initPlatformState();
  }

  if (Pref.enableLog) {
    // 异常捕获 logo记录
    final customParameters = {
      'Build Time': DateFormatUtils.format(
        BuildConfig.buildTime,
        format: DateFormatUtils.longFormatDs,
      ),
      'Commit Hash': BuildConfig.commitHash,
      'MPV Api Version':
          '${NativePlayer.apiVersion >> 16}.${NativePlayer.apiVersion & 0xFFFF}',
    };
    final fileHandler = await JsonFileHandler.init();

    Catcher2(
      [?fileHandler, const ConsoleHandler()],
      const MyApp(),
      logger: logger,
      customParameters: customParameters,
    );
  } else {
    runApp(const MyApp());
  }
}

/// Shown instead of the app when local storage could not be initialized.
///
/// Exiting here would tear down the WinRT compositor created by
/// `flutter_inappwebview_windows` while it is still referenced, which makes
/// Windows fail fast (`0xC0000602`) instead of closing cleanly — so the error
/// is reported in a window instead.
class _StartupErrorApp extends StatelessWidget {
  const _StartupErrorApp(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 16),
                const Text(
                  '应用数据目录不可用，无法启动\nFailed to initialize app storage',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  '请确认程序所在目录与用户数据目录可写，并检查安全软件是否拦截了本程序。\n'
                  'Make sure the application directory is writable and that no '
                  'security software is blocking this app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

KeyEventResult _onKeyEvent(KeyEvent event) {
  if (event.logicalKey == .escape && event is KeyDownEvent) {
    _onBack();
    return .handled;
  }
  return .ignored;
}

void _onBack() {
  if (SmartDialog.checkExist()) {
    SmartDialog.dismiss();
    return;
  }

  final route = Get.routing.route;
  if (route is GetPageRoute) {
    if (route.popDisposition == .doNotPop) {
      route.onPopInvokedWithResult(false, null);
      return;
    }
  }

  final navigator = Get.key.currentState!;
  if (navigator.canPop()) {
    navigator.pop();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static ColorScheme? _light, _dark;

  static (ThemeData, ThemeData) getAllTheme() {
    final dynamicColor = _light != null && _dark != null && Pref.dynamicColor;

    final ColorScheme lightScheme, darkScheme;
    if (dynamicColor) {
      lightScheme = _light!;
      darkScheme = _dark!;
    } else {
      final customColor = Pref.customColor;
      final brandColor =
          colorThemeTypes.elementAtOrNull(customColor)?.color ??
          Color(customColor);
      final variant = Pref.schemeVariant;

      lightScheme = brandColor.asColorSchemeSeed(variant, .light);
      darkScheme = brandColor.asColorSchemeSeed(variant, .dark);
    }

    return (
      ThemeUtils.lightTheme = ThemeUtils.getThemeData(
        colorScheme: lightScheme,
        isDynamic: dynamicColor,
      ),
      ThemeUtils.darkTheme = ThemeUtils.getThemeData(
        isDark: true,
        colorScheme: darkScheme,
        isDynamic: dynamicColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final (light, dark) = getAllTheme();
    return GetMaterialApp(
      title: Constants.appName,
      theme: light,
      darkTheme: dark,
      themeMode: ThemeUtils.themeMode = Pref.themeMode,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      locale: const Locale("zh", "CN"),
      fallbackLocale: const Locale("zh", "CN"),
      supportedLocales: const [Locale("zh", "CN"), Locale("en", "US")],
      initialRoute: '/',
      getPages: Routes.getPages,
      defaultTransition: Pref.pageTransition,
      builder: FlutterSmartDialog.init(
        toastBuilder: CustomToast.new,
        loadingBuilder: LoadingWidget.new,
        notifyStyle: const FlutterSmartNotifyStyle(
          warningBuilder: NotifyWarning.new,
        ),
        builder: _builder,
      ),
      navigatorObservers: [
        routeObserver,
        FlutterSmartDialog.observer,
      ],
      scrollBehavior: PlatformUtils.isDesktop
          ? const CustomScrollBehavior()
          : null,
    );
  }

  static Widget _builder(BuildContext context, Widget? child) {
    final uiScale = Pref.uiScale;
    final mediaQuery = MediaQuery.of(context);
    final textScaler = TextScaler.linear(Pref.defaultTextScale);
    if (uiScale != 1.0) {
      child = MediaQuery(
        data: mediaQuery.copyWith(
          textScaler: textScaler,
          size: mediaQuery.size / uiScale,
          padding: tmpPadding ?? mediaQuery.padding / uiScale,
          viewInsets: mediaQuery.viewInsets / uiScale,
          viewPadding: tmpPadding ?? mediaQuery.viewPadding / uiScale,
          devicePixelRatio: mediaQuery.devicePixelRatio * uiScale,
        ),
        child: child!,
      );
    } else {
      child = MediaQuery(
        data: mediaQuery.copyWith(
          textScaler: textScaler,
          padding: tmpPadding,
          viewPadding: tmpPadding,
        ),
        child: child!,
      );
    }
    if (PlatformUtils.isDesktop) {
      return BackDetector(
        onBack: _onBack,
        child: child,
      );
    }
    return child;
  }

  /// from [DynamicColorBuilderState.initPlatformState]
  static Future<bool> initPlatformState() async {
    if (_light != null || _dark != null) return true;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final colors = await DynamicColorPlugin.channel.invokeMethod(
        DynamicColorPlugin.methodName,
      );

      if (colors != null) {
        final corePalettes = CorePalettesExt.fromList(colors.toList());
        if (kDebugMode) {
          debugPrint('dynamic_color: Core palette detected.');
        }
        _light = corePalettes.toColorScheme();
        _dark = corePalettes.toColorScheme(brightness: Brightness.dark);
        return true;
      }
    } on PlatformException {
      if (kDebugMode) {
        debugPrint('dynamic_color: Failed to obtain core palette.');
      }
    }

    try {
      final Color? accentColor = await DynamicColorPlugin.getAccentColor();

      if (accentColor != null) {
        if (kDebugMode) {
          debugPrint('dynamic_color: Accent color detected.');
        }
        final variant = Pref.schemeVariant;
        _light = accentColor.asColorSchemeSeed(variant, .light);
        _dark = accentColor.asColorSchemeSeed(variant, .dark);
        return true;
      }
    } on PlatformException {
      if (kDebugMode) {
        debugPrint('dynamic_color: Failed to obtain accent color.');
      }
    }
    if (kDebugMode) {
      debugPrint('dynamic_color: Dynamic color not detected on this device.');
    }
    GStorage.setting.put(SettingBoxKey.dynamicColor, false);
    return false;
  }
}

class _CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    // ..maxConnectionsPerHost = 32
    /// The default value is 15 seconds.
    //   ..idleTimeout = const Duration(seconds: 15);
    if (kDebugMode || Pref.badCertificateCallback) {
      client.badCertificateCallback = (cert, host, port) => true;
    }
    return client;
  }
}
