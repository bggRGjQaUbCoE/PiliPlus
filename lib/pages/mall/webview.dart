import 'dart:async' show Timer;
import 'dart:collection';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/advanced_materials.dart';
import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/main.dart' show webViewEnvironment;
import 'package:PiliPlus/pages/mall/navigation.dart';
import 'package:PiliPlus/pages/mall/view.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class MallWebView extends StatefulWidget {
  const MallWebView({
    super.key,
    required this.onRootBack,
    required this.adapterSource,
    required this.homeStyleSource,
    required this.bottomOverlayInset,
    this.initialUrl,
    this.bottomVisibility,
    this.onPageScroll,
  });
  final VoidCallback onRootBack;
  final String adapterSource;
  final String homeStyleSource;
  final double bottomOverlayInset;
  final Uri? initialUrl;
  final ValueListenable<double?>? bottomVisibility;
  final void Function(double delta, bool ended, bool atTop)? onPageScroll;

  @override
  State<MallWebView> createState() => MallWebViewState();
}

class _MallFrame {
  _MallFrame({required this.current, this.windowId});
  final key = UniqueKey();
  final int? windowId;
  Uri current;
  InAppWebViewController? controller;
  double progress = 0;
  String? failure;
  bool rendererGone = false;
  int? firstDocumentIndex;
}

class MallWebViewState extends State<MallWebView> with WidgetsBindingObserver {
  late final _frames = [
    _MallFrame(
      current: widget.initialUrl ?? Uri.parse(MallDestination.home.url),
    ),
  ];
  static DateTime? _lastStaticCacheTrim;
  bool _openingPage = false;
  _MallFrame? _backFrame;
  bool _opensSecondary(_MallFrame frame, Uri target) {
    if (identical(_backFrame, frame)) return false;
    final current = frame.windowId != null
        ? _frames.first.current
        : widget.initialUrl ?? frame.current;
    return MallNavigation.opensSecondary(current, target);
  }

  _MallFrame get _active => _frames.last;
  double _viewportWidth = 0;
  bool _externalPrompt = false;
  bool _loginPrompt = false;
  Map<String, Object> _webTheme = const {};
  String _themeKey = '';
  Timer? _themeUpdate;
  Timer? _geometryUpdate;
  bool _keyboardVisible = false;

  bool get _isAftersaleRoute =>
      widget.initialUrl != null &&
      MallNavigation.pageKind(widget.initialUrl!) == MallPageKind.aftersale;

  double get _bottomInset => MediaQuery.viewInsetsOf(context).bottom > 0
      ? 0
      : widget.bottomOverlayInset * (widget.bottomVisibility?.value ?? 1);

  String get _adapter =>
      '${_isAftersaleRoute ? 'window.__piliMallAftersaleRoute = true;\n' : ''}'
      '${widget.adapterSource}\nwindow.__piliMallAdapter?.update(${jsonEncode({'width': _viewportWidth, 'bottom': _bottomInset, 'scrollEnabled': widget.onPageScroll != null, 'theme': _webTheme, 'homeStyle': widget.homeStyleSource})});';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    if (keyboardVisible != _keyboardVisible) {
      _keyboardVisible = keyboardVisible;
      _updateGeometry();
    }
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final glass = AdvancedMaterials.tint(scheme);
    final advanced = theme.extension<SurfaceMaterialTheme>()?.enabled == true;
    final body = theme.textTheme.bodyMedium!;
    final label = theme.textTheme.labelMedium!;
    final scaler = MediaQuery.textScalerOf(context);
    String cssColor(Color color) {
      final argb = color.toARGB32();
      return '#${(argb & 0xffffff).toRadixString(16).padLeft(6, '0')}${(argb >> 24).toRadixString(16).padLeft(2, '0')}';
    }

    final variables = <String, Object>{
      'color-scheme': scheme.brightness.name,
      'surface': cssColor(theme.scaffoldBackgroundColor),
      'card': cssColor(theme.cardTheme.color ?? scheme.surfaceContainerLow),
      'search': cssColor(scheme.surfaceContainerHigh),
      'on-surface': cssColor(scheme.onSurface),
      'on-surface-variant': cssColor(scheme.onSurfaceVariant),
      'outline': cssColor(scheme.outlineVariant.withValues(alpha: .45)),
      'primary': cssColor(scheme.primary),
      'on-primary': cssColor(scheme.onPrimary),
      'primary-container': cssColor(scheme.primaryContainer),
      'on-primary-container': cssColor(scheme.onPrimaryContainer),
      'font-family':
          '${jsonEncode(body.fontFamily ?? 'Roboto')}, system-ui, sans-serif',
      'font-size': scaler.scale(body.fontSize!),
      'label-size': scaler.scale(label.fontSize!),
      'font-weight': body.fontWeight!.value,
      'line-height': body.height!,
      'radius': Style.imgRadius.x,
      'space': Style.cardSpace,
      'gutter': Style.safeSpace,
      'glass': advanced
          ? cssColor(
              glass.withValues(
                alpha: AdvancedMaterials.toolbarOpacity(scheme.brightness),
              ),
            )
          : 'var(--pp-card)',
      'glass-filter': advanced ? 'blur(calc(var(--pp-unit) * 5))' : 'none',
      'business-glass': advanced
          ? cssColor(glass.withValues(alpha: .87))
          : 'var(--pp-card)',
    };
    final key = jsonEncode(variables);
    if (_themeKey == key) return;
    _themeKey = key;
    _webTheme = variables;
    // AnimatedTheme publishes intermediate colors every frame. Send the settled
    // values once; this is an event debounce, not a polling timer.
    _themeUpdate?.cancel();
    _themeUpdate = Timer(const Duration(milliseconds: 100), () {
      for (final frame in _frames) {
        _adapt(frame);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.bottomVisibility?.addListener(_updateGeometry);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    widget.bottomVisibility?.removeListener(_updateGeometry);
    _geometryUpdate?.cancel();
    _themeUpdate?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    for (final frame in _frames) {
      frame.controller = null;
    }
    super.dispose();
  }

  void _updateGeometry() {
    // Coalesce animation notifications without rebuilding the platform view.
    _geometryUpdate ??= Timer(const Duration(milliseconds: 32), () {
      _geometryUpdate = null;
      if (mounted) {
        _active.controller?.evaluateJavascript(
          source:
              'window.__piliMallAdapter?.updateGeometry($_viewportWidth, $_bottomInset);',
        );
      }
    });
  }

  Future<void> _adapt(_MallFrame frame) async {
    if (const {
          'mall.bilibili.com',
          'show.bilibili.com',
        }.contains(frame.current.host) &&
        frame.controller != null) {
      await frame.controller!.evaluateJavascript(source: _adapter);
    }
  }

  @override
  void didUpdateWidget(covariant MallWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bottomVisibility != widget.bottomVisibility) {
      oldWidget.bottomVisibility?.removeListener(_updateGeometry);
      widget.bottomVisibility?.addListener(_updateGeometry);
    }
    if (oldWidget.bottomOverlayInset != widget.bottomOverlayInset) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _adapt(_active);
      });
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (!Platform.isAndroid) return;
    for (final frame in _frames.toList()) {
      if (state == AppLifecycleState.paused) await frame.controller?.pause();
      if (state == AppLifecycleState.resumed) await frame.controller?.resume();
    }
    if (state == AppLifecycleState.resumed && mounted) await _adapt(_active);
  }

  Future<bool> goBack() async {
    final frame = _active;
    if (MediaQuery.viewInsetsOf(context).bottom > 0) {
      await frame.controller?.evaluateJavascript(
        source: 'document.activeElement?.blur();',
      );
      await frame.controller?.clearFocus();
      FocusManager.instance.primaryFocus?.unfocus();
      await SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
      return true;
    }
    if (await frame.controller?.evaluateJavascript(
          source: 'window.__piliMallAdapter?.dismissOverlay() ?? false;',
        ) ==
        true) {
      return true;
    }
    if (!mounted || frame != _active) return true;
    if (await frame.controller?.canGoBack() == true) {
      final controller = frame.controller!;
      final history = await controller.getCopyBackForwardList();
      if (!mounted || frame != _active) return true;
      var steps = -1;
      final entries = history?.list;
      final index = history?.currentIndex;
      if (entries != null &&
          index != null &&
          index >= 0 &&
          index < entries.length) {
        final current = entries[index].url?.uriValue ?? frame.current;
        final aftersaleLanding =
            _isAftersaleRoute &&
            current.host == 'mall.bilibili.com' &&
            current.path == '/neul-next/index.html' &&
            await controller.evaluateJavascript(
                  source:
                      "document.documentElement.dataset.ppPage === 'aftersale'",
                ) ==
                true;
        final webTicketLanding =
            MallNavigation.pageKind(current) == MallPageKind.webTicket &&
            current.host == 'mall.bilibili.com' &&
            widget.initialUrl?.host == 'show.bilibili.com';
        if (!mounted || frame != _active) return true;
        final floor = frame.firstDocumentIndex ?? 0;
        // Official pages can add the same URL or their no-referrer marker
        // during startup. They do not represent a page the user can return to.
        var previous = index - 1;
        for (; previous >= floor; previous--) {
          final uri = entries[previous].url?.uriValue;
          if (uri == null || uri.toString() == 'about:blank') continue;
          if (uri == current ||
              (aftersaleLanding &&
                  uri.host == 'mall.bilibili.com' &&
                  uri.path == '/neul/index.html' &&
                  MallNavigation.pageKind(uri) == MallPageKind.aftersale) ||
              (webTicketLanding && uri == widget.initialUrl) ||
              ((uri.fragment == 'noReffer=true' ||
                      current.fragment == 'noReffer=true') &&
                  uri.removeFragment() == current.removeFragment())) {
            continue;
          }
          break;
        }
        steps = previous < floor ? 0 : previous - index;
      }
      if (steps != 0) {
        _backFrame = frame;
        if (steps == -1) {
          await controller.goBack();
        } else {
          await controller.goBackOrForward(steps: steps);
        }
        return true;
      }
    }
    if (_frames.length > 1) {
      _close(frame);
      return true;
    }
    return false;
  }

  void _close(_MallFrame frame) {
    if (!_frames.contains(frame)) return;
    if (_frames.length == 1) {
      widget.onRootBack();
      return;
    }
    if (identical(_backFrame, frame)) _backFrame = null;
    setState(() => _frames.remove(frame));
    _adapt(_active);
  }

  void _fail(_MallFrame frame, String message, {bool rendererGone = false}) {
    if (!mounted || !_frames.contains(frame) || frame.rendererGone) return;
    setState(() {
      frame
        ..failure = message
        ..progress = 1
        ..rendererGone = rendererGone;
      if (rendererGone) frame.controller = null;
    });
  }

  Future<void> _retry() async {
    final frame = _active;
    if (frame.failure == null) return;
    if (frame.rendererGone) {
      setState(
        () => _frames[_frames.length - 1] = _MallFrame(current: frame.current),
      );
    } else {
      setState(() {
        frame
          ..failure = null
          ..progress = 0;
      });
      await frame.controller!.reload();
    }
  }

  bool _isLogin(Uri uri) =>
      (MallNavigation.isOfficial(uri) &&
          uri.host == 'passport.bilibili.com' &&
          const {'/login', '/h5-app/passport/login'}.contains(uri.path)) ||
      (uri.scheme == 'bilibili' && uri.host == 'login');

  Future<bool> _allow(_MallFrame frame, Uri uri) async {
    if (_isLogin(uri)) {
      if (_loginPrompt) return false;
      _loginPrompt = true;
      try {
        await Get.toNamed('/loginPage');
      } finally {
        _loginPrompt = false;
      }
      return false;
    }
    if (MallNavigation.isOfficial(uri)) return true;
    final sourceFrame = frame.windowId == null ? frame : _frames.first;
    if (uri.scheme == 'bilibili' &&
        MallNavigation.pageKind(sourceFrame.current) == MallPageKind.account) {
      final shortcut = await sourceFrame.controller?.evaluateJavascript(
        source:
            'window.__piliMallAdapter?.accountAppShortcut(${jsonEncode(uri.toString())}) ?? null;',
      );
      if (!mounted || frame != _active) return false;
      if (shortcut == 'ticket') {
        if (frame != sourceFrame) _close(frame);
        await _ticketHelp();
        return false;
      }
      if (shortcut == 'receiving') {
        if (frame != sourceFrame) _close(frame);
        _openPage(
          Uri.parse(MallTicketDestination.order.url).replace(
            queryParameters: {'noTitleBar': '1', 'hashstatus': '3'},
          ),
        );
        return false;
      }
    }
    await _external(uri);
    return false;
  }

  Future<void> _external(Uri uri) async {
    if (_externalPrompt) return;
    _externalPrompt = true;
    try {
      final open = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('打开外部链接'),
          content: Text(
            '此环节将使用外部应用打开 ${uri.host.isEmpty ? uri.scheme : uri.host}。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('打开'),
            ),
          ],
        ),
      );
      if (open == true && mounted) {
        bool opened;
        try {
          opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
        } on PlatformException {
          opened = false;
        }
        if (!opened && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('无法打开外部链接，请检查对应应用是否已安装')),
          );
        }
      }
    } finally {
      _externalPrompt = false;
    }
  }

  Future<void> _ticketHelp() async {
    if (_externalPrompt) return;
    _externalPrompt = true;
    try {
      await showDialog<void>(
        context: context,
        builder: (context) {
          bool launchFailed = false;
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: const Text('在哔哩哔哩打开电子票'),
              content: Text(
                '${launchFailed ? '无法打开哔哩哔哩，请确认已安装官方 App。\n\n' : ''}'
                '在哔哩哔哩 App 打开会员购 → 会员购中心 → 我的订单，'
                '找到对应票务订单并打开电子票。入场方式以活动须知为准。',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('知道了'),
                ),
                if (Platform.isAndroid)
                  TextButton(
                    onPressed: () async {
                      final opened = await const MethodChannel(
                        'com.example.piliplus/mall',
                      ).invokeMethod<bool>('openBilibili');
                      if (opened == false && context.mounted) {
                        setState(() => launchFailed = true);
                      }
                    },
                    child: const Text('打开哔哩哔哩'),
                  ),
              ],
            ),
          );
        },
      );
    } finally {
      _externalPrompt = false;
    }
  }

  Future<void> _open(MallDestination destination) async {
    if (MallDestination.fromUri(_active.current) == destination) return;
    final target = Uri.parse(destination.url);
    if (MallNavigation.opensSecondary(_active.current, target)) {
      await _openPage(target);
    } else {
      await _active.controller!.loadUrl(
        urlRequest: URLRequest(url: WebUri.uri(target)),
      );
    }
  }

  Future<void> _openPage(Uri uri, {bool restoreParent = false}) async {
    if (_openingPage || !mounted) return;
    _openingPage = true;
    try {
      if (restoreParent) {
        final frame = _active;
        if (await frame.controller!.canGoBack()) {
          if (!mounted || frame != _active) return;
          _backFrame = frame;
          await frame.controller!.goBack();
        } else {
          if (mounted && frame == _active) {
            setState(() => frame.current = uri);
            await _adapt(frame);
          }
          return;
        }
      }
      if (!mounted) return;
      await Get.to<void>(
        () => MallPage(initialUrl: uri),
        routeName: MallNavigation.pageKind(uri) == MallPageKind.product
            ? '/mallDetail'
            : '/mall/${MallNavigation.pageKind(uri)!.name}',
      );
    } finally {
      _openingPage = false;
    }
  }

  Widget _webView(_MallFrame frame) => InAppWebView(
    key: frame.key,
    windowId: frame.windowId,
    webViewEnvironment: webViewEnvironment,
    initialUserScripts: UnmodifiableListView([
      UserScript(
        source: _adapter,
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
        forMainFrameOnly: true,
        allowedOriginRules: {
          'https://mall.bilibili.com',
          'https://show.bilibili.com',
        },
      ),
    ]),
    initialSettings: InAppWebViewSettings(
      clearCache: false,
      userAgent: BrowserUa.mob,
      useHybridComposition: false,
      useShouldOverrideUrlLoading: true,
      javaScriptEnabled: true,
      supportMultipleWindows: true,
      javaScriptCanOpenWindowsAutomatically: true,
      useOnRenderProcessGone: true,
      forceDark: ForceDark.OFF,
      algorithmicDarkeningAllowed: false,
      mixedContentMode: MixedContentMode.MIXED_CONTENT_NEVER_ALLOW,
    ),
    initialUrlRequest: frame.windowId == null
        ? URLRequest(url: WebUri.uri(frame.current))
        : null,
    onWebViewCreated: (controller) {
      controller.addJavaScriptHandler(
        handlerName: 'piliMallScroll',
        callback: (args) {
          if (!mounted ||
              frame != _active ||
              widget.onPageScroll == null ||
              !const {
                'mall.bilibili.com',
                'show.bilibili.com',
              }.contains(frame.current.host) ||
              args.length != 1 ||
              args.first is! Map) {
            return;
          }
          final data = args.first as Map;
          final delta = data['delta'];
          if (delta is! num ||
              !delta.isFinite ||
              data['ended'] is! bool ||
              data['top'] is! bool) {
            return;
          }
          widget.onPageScroll!(
            delta.toDouble(),
            data['ended'] as bool,
            data['top'] as bool,
          );
        },
      );
      if (mounted) setState(() => frame.controller = controller);
    },
    onProgressChanged: (_, progress) {
      if (mounted) setState(() => frame.progress = progress / 100);
    },
    onLoadStart: (controller, url) async {
      if (url == null || frame.rendererGone) return;
      final uri = url.uriValue;
      final normalized = MallNavigation.normalize(uri);
      if (frame.windowId != null && _opensSecondary(frame, normalized)) {
        await controller.stopLoading();
        if (mounted && _frames.contains(frame)) {
          _close(frame);
          _openPage(normalized);
        }
        return;
      }
      if (normalized != uri) {
        await controller.stopLoading();
        if (mounted && await _allow(frame, normalized) && mounted) {
          await controller.loadUrl(
            urlRequest: URLRequest(url: WebUri.uri(normalized)),
          );
        }
        return;
      }
      if ((_isLogin(uri) || !MallNavigation.isOfficial(uri)) &&
          !(frame.windowId != null && uri.toString() == 'about:blank')) {
        await controller.stopLoading();
        if (mounted) await _allow(frame, uri);
        return;
      }
      if (mounted) {
        setState(() {
          frame
            ..current = uri
            ..failure = null
            ..progress = 0;
        });
      }
    },
    onUpdateVisitedHistory: (controller, url, _) {
      final returning = identical(_backFrame, frame);
      if (returning && url != null) _backFrame = null;
      if (url != null &&
          frame == _active &&
          !returning &&
          url.uriValue != frame.current &&
          _opensSecondary(frame, url.uriValue)) {
        // A same-document router has already committed its history entry.
        // Restore its parent before opening the one native product route.
        _openPage(url.uriValue, restoreParent: true);
        return;
      }
      if (url != null &&
          MallNavigation.isOfficial(url.uriValue) &&
          mounted &&
          !frame.rendererGone) {
        setState(() => frame.current = url.uriValue);
        _adapt(frame);
      }
    },
    onLoadStop: (controller, url) async {
      if (mounted) setState(() => frame.progress = 1);
      if (frame.firstDocumentIndex == null &&
          url != null &&
          url.uriValue == frame.current &&
          MallNavigation.isOfficial(url.uriValue)) {
        final history = await controller.getCopyBackForwardList();
        frame.firstDocumentIndex ??= history?.currentIndex;
      }
      await _adapt(frame);
      if (Platform.isAndroid &&
          mounted &&
          identical(frame, _active) &&
          url?.uriValue.host == 'mall.bilibili.com') {
        final now = DateTime.now();
        final lastTrim = _lastStaticCacheTrim;
        if (lastTrim == null || now.difference(lastTrim).inMinutes >= 15) {
          _lastStaticCacheTrim = now;
          final result = await controller.callAsyncJavaScript(
            functionBody: '''
              await new Promise(resolve => setTimeout(resolve, 1500));
              return await window.__piliMallAdapter?.trimStaticCache(64 * 1024 * 1024);
            ''',
          );
          if (result?.error case final String error) {
            debugPrint('Mall static cache trim failed: $error');
          }
        }
      }
    },
    onReceivedError: (_, request, error) {
      if (request.isForMainFrame == true &&
          request.url.uriValue == frame.current) {
        _fail(frame, '网页加载失败（${error.type}），请检查网络后重试');
      }
    },
    onReceivedHttpError: (_, request, response) {
      if (request.isForMainFrame == true &&
          request.url.uriValue == frame.current) {
        _fail(frame, '网页服务返回 ${response.statusCode}，请稍后重试');
      }
    },
    onRenderProcessGone: (_, _) =>
        _fail(frame, '网页渲染进程已退出，请重新加载', rendererGone: true),
    shouldOverrideUrlLoading: (controller, action) async {
      if (!action.isForMainFrame) return NavigationActionPolicy.ALLOW;
      final target = action.request.url?.uriValue;
      if (target == null) {
        _fail(frame, '无法识别该网页地址');
        return NavigationActionPolicy.CANCEL;
      }
      if (frame.windowId != null && target.toString() == 'about:blank') {
        return NavigationActionPolicy.ALLOW;
      }
      final normalized = MallNavigation.normalize(target);
      if (!await _allow(frame, normalized) ||
          !mounted ||
          !_frames.contains(frame)) {
        return NavigationActionPolicy.CANCEL;
      }
      if (_opensSecondary(frame, normalized)) {
        if (frame.windowId != null) _close(frame);
        _openPage(normalized);
        return NavigationActionPolicy.CANCEL;
      }
      if (normalized != target) {
        await controller.loadUrl(
          urlRequest: URLRequest(url: WebUri.uri(normalized)),
        );
        return NavigationActionPolicy.CANCEL;
      }
      return NavigationActionPolicy.ALLOW;
    },
    onCreateWindow: (_, action) async {
      final target = action.request.url?.uriValue;
      final normalized = target == null
          ? null
          : MallNavigation.normalize(target);
      if (normalized != null &&
          normalized.toString() != 'about:blank' &&
          !await _allow(frame, normalized)) {
        return false;
      }
      if (!mounted || frame.rendererGone || frame != _active) {
        return false;
      }
      if (normalized != null &&
          (action.request.method == null || action.request.method == 'GET') &&
          _opensSecondary(frame, normalized)) {
        _openPage(normalized);
        return false;
      }
      setState(
        () => _frames.add(
          _MallFrame(
            current: target ?? Uri.parse('about:blank'),
            windowId: action.windowId,
          ),
        ),
      );
      return true;
    },
    onCloseWindow: (_) {
      if (mounted) _close(frame);
    },
  );

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.of(context);
    final frame = _active;
    final selected = MallDestination.fromUri(frame.current);
    final routeKind = MallNavigation.pageKind(
      widget.initialUrl ?? frame.current,
    );
    final currentKind = MallNavigation.pageKind(frame.current);
    final showTicketTools =
        widget.initialUrl == null ||
        const {
          MallPageKind.ticketActivity,
          MallPageKind.ticketDetail,
          MallPageKind.ticketMovie,
          MallPageKind.ticketCollection,
          MallPageKind.ticketOrder,
        }.contains(routeKind);
    return Scaffold(
      primary: false,
      appBar: AppBar(
        primary: false,
        leading: BackButton(onPressed: widget.onRootBack),
        title: Text(
          currentKind?.label ?? routeKind?.label ?? '会员购',
        ),
        actions: [
          if (const {
                MallPageKind.account,
                MallPageKind.ticketOrder,
                MallPageKind.orderDetail,
                MallPageKind.ticketDetail,
                MallPageKind.webTicket,
              }.contains(currentKind) ||
              routeKind == MallPageKind.ticketOrder)
            IconButton(
              tooltip: '在哔哩哔哩打开电子票',
              onPressed: _ticketHelp,
              icon: const Icon(Icons.confirmation_number_outlined),
            ),
          if (showTicketTools)
            PopupMenuButton<MallTicketDestination>(
              tooltip: '票务工具',
              enabled: frame.controller != null,
              onSelected: (destination) {
                final target = Uri.parse(destination.url);
                if (_opensSecondary(frame, target)) {
                  _openPage(target);
                } else if (MallNavigation.pageKind(target) == null ||
                    MallNavigation.pageKind(frame.current) !=
                        MallNavigation.pageKind(target)) {
                  frame.controller!.loadUrl(
                    urlRequest: URLRequest(url: WebUri.uri(target)),
                  );
                }
              },
              itemBuilder: (_) => [
                for (final destination in MallTicketDestination.values)
                  PopupMenuItem(
                    value: destination,
                    child: Text(destination.label),
                  ),
              ],
            ),
          IconButton(
            tooltip: '刷新商城',
            onPressed: frame.controller == null
                ? null
                : () => frame.controller!.reload(),
            icon: const Icon(Icons.refresh),
          ),
        ],
        bottom: widget.initialUrl != null
            ? PreferredSize(
                preferredSize: const Size.fromHeight(2),
                child: SizedBox(
                  height: 2,
                  child: frame.progress < 1
                      ? LinearProgressIndicator(
                          value: frame.progress,
                          minHeight: 2,
                        )
                      : null,
                ),
              )
            : PreferredSize(
                preferredSize: const Size.fromHeight(
                  kMinInteractiveDimension + 2,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        for (final destination in MallDestination.values)
                          Expanded(
                            child: Semantics(
                              selected: selected == destination,
                              child: TextButton(
                                onPressed: frame.controller == null
                                    ? null
                                    : () => _open(destination),
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(
                                    0,
                                    kMinInteractiveDimension,
                                  ),
                                  foregroundColor: selected == destination
                                      ? scheme.onSecondaryContainer
                                      : scheme.onSurfaceVariant,
                                  backgroundColor: selected == destination
                                      ? scheme.secondaryContainer
                                      : Colors.transparent,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: Style.mdRadius,
                                  ),
                                ),
                                child: Text(destination.label),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                      child: frame.progress < 1
                          ? LinearProgressIndicator(
                              value: frame.progress,
                              minHeight: 2,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (_viewportWidth != constraints.maxWidth) {
            _viewportWidth = constraints.maxWidth;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _adapt(_active);
            });
          }
          return Stack(
            children: [
              IndexedStack(
                index: _frames.length - 1,
                children: [
                  for (final frame in _frames)
                    frame.rendererGone
                        ? const SizedBox.expand()
                        : _webView(frame),
                ],
              ),
              if (frame.failure != null)
                Positioned.fill(
                  child: ColoredBox(
                    color: scheme.surface,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.cloud_off_outlined),
                            const SizedBox(height: 12),
                            Text(frame.failure!, textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            FilledButton(
                              onPressed: _retry,
                              child: const Text('重新加载'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
