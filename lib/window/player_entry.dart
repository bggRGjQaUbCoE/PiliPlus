import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/custom_toast.dart';
import 'package:PiliPlus/common/widgets/mouse_back.dart';
import 'package:PiliPlus/models/common/theme/theme_color_type.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/pages/video/view.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/player_window_manager.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';

/// Minimal routes for player window (no Pref dependency)
final List<GetPage> _playerWindowRoutes = [
  GetPage(
    name: '/',
    page: () => const _PlayerWindowPlaceholder(),
    transition: Transition.noTransition,
  ),
  GetPage(
    name: '/videoV',
    page: () => const VideoDetailPageV(),
    transition: Transition.noTransition,
  ),
];

/// Placeholder widget for player window root
class _PlayerWindowPlaceholder extends StatelessWidget {
  const _PlayerWindowPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// 播放器窗口入口
class PlayerEntry extends StatefulWidget {
  const PlayerEntry({super.key, this.args});

  /// Window arguments passed from main
  final Map<String, dynamic>? args;

  @override
  State<PlayerEntry> createState() => _PlayerEntryState();
}

class _PlayerEntryState extends State<PlayerEntry> with WindowListener {
  // Settings from args
  late final Map<String, dynamic>? _settings;
  late final Size _windowSize;
  late final List<double>? _windowPosition;
  late final bool _showTitleBar;
  late final int _customColor;
  late final bool _dynamicColor;
  late final int _schemeVariant;
  late final ThemeMode _themeMode;
  late final double _textScale;

  @override
  void initState() {
    super.initState();
    _parseSettings();
    _initWindow();
    _setupPlayerChannel();
    // Navigate to initial video if args provided
    _navigateToInitialVideo();
  }

  void _parseSettings() {
    _settings = widget.args?['settings'] as Map<String, dynamic>?;

    // Parse window size
    final sizeList = _settings?['playerWindowSize'] as List?;
    if (sizeList != null && sizeList.length >= 2) {
      _windowSize = Size(
        (sizeList[0] as num).toDouble(),
        (sizeList[1] as num).toDouble(),
      );
    } else {
      _windowSize = const Size(1280, 720);
    }

    // Parse window position
    final posList = _settings?['playerWindowPosition'] as List?;
    if (posList != null && posList.length >= 2) {
      _windowPosition = [
        (posList[0] as num).toDouble(),
        (posList[1] as num).toDouble(),
      ];
    } else {
      _windowPosition = null;
    }

    _showTitleBar = _settings?['showWindowTitleBar'] as bool? ?? true;
    _customColor = _settings?['customColor'] as int? ?? 0;
    _dynamicColor = _settings?['dynamicColor'] as bool? ?? false;
    _schemeVariant = _settings?['schemeVariant'] as int? ?? 0;
    _themeMode = ThemeMode.values[_settings?['themeMode'] as int? ?? 0];
    _textScale = (_settings?['defaultTextScale'] as num?)?.toDouble() ?? 1.0;
  }

  Future<void> _initWindow() async {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      size: _windowSize,
      minimumSize: const Size(640, 480),
      skipTaskbar: false,
      titleBarStyle:
          _showTitleBar ? TitleBarStyle.normal : TitleBarStyle.hidden,
      title: '${Constants.appName} - 播放器',
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      final pos = _windowPosition;
      if (pos != null) {
        await windowManager.setPosition(
          Offset(pos[0], pos[1]),
        );
      } else {
        // Calculate center position without using Pref
        final position = await _calcCenterPosition(_windowSize);
        await windowManager.setBounds(position & _windowSize);
      }
      await windowManager.show();
      await windowManager.focus();
    });

    windowManager.addListener(this);
    windowManager.setPreventClose(true);
  }

  /// Calculate center position for window (simplified, no Pref dependency)
  Future<Offset> _calcCenterPosition(Size windowSize) async {
    try {
      final primaryDisplay = await screenRetriever.getPrimaryDisplay();
      final screenSize = primaryDisplay.size;
      return Offset(
        (screenSize.width - windowSize.width) / 2,
        (screenSize.height - windowSize.height) / 2,
      );
    } catch (_) {
      return Offset.zero;
    }
  }

  /// Build theme data without depending on Pref/GStorage
  ThemeData _buildThemeData({
    required ColorScheme colorScheme,
    required bool isDynamic,
    bool isDark = false,
  }) {
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        titleTextStyle: TextStyle(
          fontSize: 16,
          color: colorScheme.onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        surfaceTintColor: isDynamic ? colorScheme.onSurfaceVariant : null,
      ),
      snackBarTheme: SnackBarThemeData(
        actionTextColor: colorScheme.primary,
        backgroundColor: colorScheme.secondaryContainer,
        closeIconColor: colorScheme.secondary,
        contentTextStyle: TextStyle(color: colorScheme.onSecondaryContainer),
        elevation: 20,
      ),
      popupMenuTheme: PopupMenuThemeData(
        surfaceTintColor: isDynamic ? colorScheme.onSurfaceVariant : null,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        margin: EdgeInsets.zero,
        surfaceTintColor: isDynamic
            ? colorScheme.onSurfaceVariant
            : isDark
                ? colorScheme.onSurfaceVariant
                : null,
        shadowColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        titleTextStyle: TextStyle(
          fontSize: 18,
          color: colorScheme.onSurface,
        ),
        backgroundColor: colorScheme.surface,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[700]!.withValues(alpha: 0.9),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        selectionHandleColor: colorScheme.primary,
      ),
      switchTheme: const SwitchThemeData(
        thumbIcon: WidgetStateProperty<Icon?>.fromMap(
          <WidgetStatesConstraint, Icon?>{
            WidgetState.selected: Icon(Icons.done),
            WidgetState.any: null,
          },
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        },
      ),
    );
  }

  void _setupPlayerChannel() {
    const channel = WindowMethodChannel(PlayerWindowManager.channelName);
    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'playVideo':
          final args = call.arguments as Map?;
          if (args != null) {
            _navigateToVideo(args);
          }
          return 'ok';
        default:
          throw MissingPluginException('Not implemented: ${call.method}');
      }
    });
  }

  void _navigateToInitialVideo() {
    final args = widget.args;
    if (args != null &&
        args['aid'] != null &&
        args['bvid'] != null &&
        args['cid'] != null) {
      // Wait for first frame to ensure GetMaterialApp is fully built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToVideo(args);
      });
    }
  }

  void _navigateToVideo(Map args) {
    final videoTypeArg = args['videoType'];
    // Convert videoType to VideoType enum
    VideoType videoType = VideoType.ugc;
    if (videoTypeArg is VideoType) {
      videoType = videoTypeArg;
    } else if (videoTypeArg is int) {
      videoType = VideoType.values[videoTypeArg.clamp(0, VideoType.values.length - 1)];
    } else if (videoTypeArg is String) {
      switch (videoTypeArg) {
        case 'ugc':
          videoType = VideoType.ugc;
          break;
        case 'pgc':
          videoType = VideoType.pgc;
          break;
        case 'pugv':
          videoType = VideoType.pugv;
          break;
      }
    }

    // Get extraArguments and convert sourceType if needed
    final extraArgs = args['extraArguments'] as Map<String, dynamic>? ?? {};
    SourceType? sourceType;
    final sourceTypeArg = extraArgs['sourceType'];
    if (sourceTypeArg is SourceType) {
      sourceType = sourceTypeArg;
    } else if (sourceTypeArg is int) {
      sourceType = SourceType.values[sourceTypeArg.clamp(0, SourceType.values.length - 1)];
    } else if (sourceTypeArg is String) {
      sourceType = SourceType.values.firstWhereOrNull((e) => e.name == sourceTypeArg);
    }

    Get.offAllNamed(
      '/videoV',
      arguments: {
        'videoType': videoType,
        'aid': args['aid'],
        'bvid': args['bvid'],
        'cid': args['cid'],
        if (args['seasonId'] != null) 'seasonId': args['seasonId'],
        if (args['epId'] != null) 'epId': args['epId'],
        if (args['pgcType'] != null) 'pgcType': args['pgcType'],
        if (args['cover'] != null) 'pic': args['cover'],
        'heroTag': 'playerWindow_${args['bvid'] ?? args['aid']}',
        if (args['progress'] != null) 'progress': args['progress'],
        // Include converted sourceType and other extraArguments
        if (sourceType != null) 'sourceType': sourceType,
        ...extraArgs..remove('sourceType'),
      },
    );
  }

  @override
  Future<void> onWindowClose() async {
    // Note: Cannot save to storage since Hive is not initialized in sub-window
    // Bounds will be saved by main window via IPC if needed

    // 销毁播放器，确保视频停止播放
    try {
      final plCtr = PlPlayerController.instance;
      if (plCtr != null) {
        plCtr.isCloseAll = true; // 确保完全销毁
        await plCtr.dispose();
      }
    } catch (e) {
      // 忽略销毁错误
    }

    await windowManager.setPreventClose(false);
    await windowManager.close();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color brandColor = colorThemeTypes[_customColor].color;
    FlexSchemeVariant variant = FlexSchemeVariant.values[_schemeVariant];

    return DynamicColorBuilder(
      builder: ((ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme? lightColorScheme;
        ColorScheme? darkColorScheme;
        if (lightDynamic != null && darkDynamic != null && _dynamicColor) {
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          lightColorScheme = SeedColorScheme.fromSeeds(
            primaryKey: brandColor,
            brightness: Brightness.light,
            variant: variant,
          );
          darkColorScheme = SeedColorScheme.fromSeeds(
            primaryKey: brandColor,
            brightness: Brightness.dark,
            variant: variant,
          );
        }

        return GetMaterialApp(
          title: '${Constants.appName} - 播放器',
          theme: _buildThemeData(
            colorScheme: lightColorScheme,
            isDynamic: lightDynamic != null && _dynamicColor,
          ),
          darkTheme: _buildThemeData(
            colorScheme: darkColorScheme,
            isDynamic: darkDynamic != null && _dynamicColor,
            isDark: true,
          ),
          themeMode: _themeMode,
          localizationsDelegates: const [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          locale: const Locale("zh", "CN"),
          supportedLocales: const [Locale("zh", "CN"), Locale("en", "US")],
          fallbackLocale: const Locale("zh", "CN"),
          getPages: _playerWindowRoutes,
          initialRoute: '/',
          builder: FlutterSmartDialog.init(
            toastBuilder: (String msg) => CustomToast(msg: msg),
            loadingBuilder: (msg) => LoadingWidget(msg: msg),
            builder: (context, child) {
              child = MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(_textScale),
                ),
                child: child!,
              );

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
                      ..controlsLock.value = false
                      ..showControls.value = false;
                    return;
                  }

                  if (plCtr.isDesktopPip) {
                    plCtr
                      ..exitDesktopPip().whenComplete(
                        () => plCtr.initialFocalPoint = Offset.zero,
                      )
                      ..controlsLock.value = false
                      ..showControls.value = false;
                    return;
                  }
                }

                // 关闭播放器窗口
                windowManager.close();
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
            },
          ),
          navigatorObservers: [
            FlutterSmartDialog.observer,
            PageUtils.routeObserver,
            _PlayerWindowRouteObserver(),
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

/// 播放器窗口路由观察者
/// 拦截非播放页面的路由，在主窗口中打开
class _PlayerWindowRouteObserver extends NavigatorObserver {
  static const _playerRoutes = ['/videoV', '/live', '/bangumi', '/audioPlayer'];

  bool _isPlayerRoute(String? routeName) {
    if (routeName == null) return false;
    return _playerRoutes.any((r) => routeName.startsWith(r));
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    final routeName = route.settings.name;
    // 如果不是播放页面且不是根路由，在主窗口打开
    if (routeName != null && routeName != '/' && !_isPlayerRoute(routeName)) {
      // 在主窗口打开此路由
      PlayerWindowManager.instance.openInMainWindow(
        routeName,
        route.settings.arguments,
      );
      // 阻止在播放器窗口中导航
      Future.microtask(() {
        if (navigator?.canPop() ?? false) {
          navigator?.pop();
        }
      });
    }
    super.didPush(route, previousRoute);
  }
}
