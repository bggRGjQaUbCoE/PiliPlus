import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class LinuxWebviewPlugin {
  static const MethodChannel channel = MethodChannel(
    'com.example.piliplus/linux_webview',
  );

  static final Map<int, LinuxWebviewController> _controllers = {};
  static bool _initialized = false;

  static void ensureInitialized() {
    if (_initialized) return;
    _initialized = true;

    channel.setMethodCallHandler((call) async {
      final args = call.arguments;
      if (args is! Map) return;

      final viewId = (args['viewId'] as num?)?.toInt();
      if (viewId == null) return;

      final controller = _controllers[viewId];
      if (controller == null) return;

      switch (call.method) {
        case 'onUrlChanged':
          final url = args['url'] as String? ?? '';
          controller._onUrlChanged(url);
          break;
        case 'onProgressChanged':
          final progress = (args['progress'] as num?)?.toDouble() ?? 0.0;
          controller._onProgressChanged(progress);
          break;
        case 'onTitleChanged':
          final title = args['title'] as String? ?? '';
          controller._onTitleChanged(title);
          break;
        case 'onWebMessageReceived':
          final message = args['message'] as String? ?? '';
          controller._onWebMessageReceived(message);
          break;
        case 'onNavigationRequest':
          final url = args['url'] as String? ?? '';
          controller._onNavigationRequest(url);
          break;
        case 'onLoadFailed':
          final url = args['url'] as String? ?? '';
          final error = args['error'] as String? ?? '';
          controller._onLoadFailed(url, error);
          break;
      }
    });
  }

  static void registerController(
    int viewId,
    LinuxWebviewController controller,
  ) {
    ensureInitialized();
    _controllers[viewId] = controller;
  }

  static void unregisterController(int viewId) {
    _controllers.remove(viewId);
  }

  static Future<void> clearAllCookies() async {
    try {
      await channel.invokeMethod('clearAllCookies');
    } catch (e) {
      debugPrint('LinuxWebviewPlugin.clearAllCookies error: $e');
    }
  }

  static Future<void> clearCache() async {
    try {
      await channel.invokeMethod('clearCache');
    } catch (e) {
      debugPrint('LinuxWebviewPlugin.clearCache error: $e');
    }
  }

  static Future<int> showContextMenu({
    required List<String> items,
    Rect? position,
  }) async {
    try {
      final res = await channel.invokeMethod<int>('showContextMenu', {
        'items': items,
        if (position != null) ...{
          'x': position.left,
          'y': position.top,
          'width': position.width,
          'height': position.height,
        },
      });
      return res ?? -1;
    } catch (e) {
      debugPrint('LinuxWebviewPlugin.showContextMenu error: $e');
      return -1;
    }
  }
}

class LinuxWebviewController {
  final int viewId;
  final ValueChanged<String>? onUrlChanged;
  final ValueChanged<double>? onProgressChanged;
  final ValueChanged<String>? onTitleChanged;
  final ValueChanged<String>? onWebMessageReceived;
  final ValueChanged<String>? onNavigationRequest;
  final void Function(String url, String error)? onLoadFailed;

  String? currentUrl;
  bool _isDisposed = false;

  LinuxWebviewController({
    required this.viewId,
    String? initialUrl,
    this.onUrlChanged,
    this.onProgressChanged,
    this.onTitleChanged,
    this.onWebMessageReceived,
    this.onNavigationRequest,
    this.onLoadFailed,
  }) : currentUrl = initialUrl {
    LinuxWebviewPlugin.registerController(viewId, this);
  }

  void _onUrlChanged(String url) {
    currentUrl = url;
    onUrlChanged?.call(url);
  }

  void _onProgressChanged(double progress) => onProgressChanged?.call(progress);
  void _onTitleChanged(String title) => onTitleChanged?.call(title);
  void _onWebMessageReceived(String message) =>
      onWebMessageReceived?.call(message);
  void _onNavigationRequest(String url) => onNavigationRequest?.call(url);
  void _onLoadFailed(String url, String error) =>
      onLoadFailed?.call(url, error);

  Future<String?> getUrl() async => currentUrl;

  Future<void> loadUrl(String url) async {
    if (_isDisposed) return;
    try {
      currentUrl = url;
      await LinuxWebviewPlugin.channel.invokeMethod('loadUrl', {
        'viewId': viewId,
        'url': url,
      });
    } catch (e) {
      debugPrint('LinuxWebviewController.loadUrl error: $e');
    }
  }

  Future<void> loadHtml(String html, {String? baseUri}) async {
    if (_isDisposed) return;
    try {
      await LinuxWebviewPlugin.channel.invokeMethod('loadHtml', {
        'viewId': viewId,
        'html': html,
        'baseUri': ?baseUri,
      });
    } catch (e) {
      debugPrint('LinuxWebviewController.loadHtml error: $e');
    }
  }

  Future<String?> evaluateJavaScript(String script) async {
    if (_isDisposed) return null;
    try {
      final result = await LinuxWebviewPlugin.channel.invokeMethod<String>(
        'evaluateJavaScript',
        {
          'viewId': viewId,
          'script': script,
        },
      );
      return result;
    } catch (e) {
      debugPrint('LinuxWebviewController.evaluateJavaScript error: $e');
      return null;
    }
  }

  Future<void> goBack() async {
    if (_isDisposed) return;
    try {
      await LinuxWebviewPlugin.channel.invokeMethod('goBack', {
        'viewId': viewId,
      });
    } catch (e) {
      debugPrint('LinuxWebviewController.goBack error: $e');
    }
  }

  Future<void> goForward() async {
    if (_isDisposed) return;
    try {
      await LinuxWebviewPlugin.channel.invokeMethod('goForward', {
        'viewId': viewId,
      });
    } catch (e) {
      debugPrint('LinuxWebviewController.goForward error: $e');
    }
  }

  Future<void> reload() async {
    if (_isDisposed) return;
    try {
      await LinuxWebviewPlugin.channel.invokeMethod('reload', {
        'viewId': viewId,
      });
    } catch (e) {
      debugPrint('LinuxWebviewController.reload error: $e');
    }
  }

  Future<void> stopLoading() async {
    if (_isDisposed) return;
    try {
      await LinuxWebviewPlugin.channel.invokeMethod('stopLoading', {
        'viewId': viewId,
      });
    } catch (e) {
      debugPrint('LinuxWebviewController.stopLoading error: $e');
    }
  }

  Future<void> updateBounds(Rect bounds, {bool visible = true}) async {
    if (_isDisposed) return;
    try {
      await LinuxWebviewPlugin.channel.invokeMethod('updateBounds', {
        'viewId': viewId,
        'x': bounds.left,
        'y': bounds.top,
        'width': bounds.width,
        'height': bounds.height,
        'visible': visible,
      });
    } catch (e) {
      debugPrint('LinuxWebviewController.updateBounds error: $e');
    }
  }

  Future<void> setVisible(bool visible) async {
    if (_isDisposed) return;
    try {
      await LinuxWebviewPlugin.channel.invokeMethod('updateBounds', {
        'viewId': viewId,
        'visible': visible,
      });
    } catch (e) {
      debugPrint('LinuxWebviewController.setVisible error: $e');
    }
  }

  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    LinuxWebviewPlugin.unregisterController(viewId);
    LinuxWebviewPlugin.channel
        .invokeMethod('close', {
          'viewId': viewId,
        })
        .catchError((e) {
          debugPrint('LinuxWebviewController.close error: $e');
        });
  }
}

class LinuxWebview extends StatefulWidget {
  final String? initialUrl;
  final String? initialHtml;
  final String? userAgent;
  final bool incognito;
  final List<Map<String, dynamic>>? userScripts;
  final ValueChanged<LinuxWebviewController>? onWebViewCreated;
  final ValueChanged<String>? onUrlChanged;
  final ValueChanged<double>? onProgress;
  final ValueChanged<String>? onTitleChanged;
  final ValueChanged<String>? onWebMessageReceived;
  final ValueChanged<String>? onNavigationRequest;
  final void Function(String url, String error)? onLoadFailed;

  const LinuxWebview({
    super.key,
    this.initialUrl,
    this.initialHtml,
    this.userAgent,
    this.incognito = false,
    this.userScripts,
    this.onWebViewCreated,
    this.onUrlChanged,
    this.onProgress,
    this.onTitleChanged,
    this.onWebMessageReceived,
    this.onNavigationRequest,
    this.onLoadFailed,
  });

  @override
  State<LinuxWebview> createState() => _LinuxWebviewState();
}

class _LinuxWebviewState extends State<LinuxWebview> {
  static int _nextViewId = 1;
  late final int _viewId;
  LinuxWebviewController? _controller;
  bool _initializedNative = false;

  @override
  void initState() {
    super.initState();
    _viewId = _nextViewId++;
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  void _onBoundsChanged(Rect rect) {
    final isVisible = rect.width > 0 && rect.height > 0;
    if (!_initializedNative) {
      if (isVisible) {
        _initializedNative = true;
        _createNativeWebview(rect);
      }
    } else {
      _controller?.updateBounds(rect, visible: isVisible);
    }
  }

  Future<void> _createNativeWebview(Rect bounds) async {
    final controller = LinuxWebviewController(
      viewId: _viewId,
      initialUrl: widget.initialUrl,
      onUrlChanged: widget.onUrlChanged,
      onProgressChanged: widget.onProgress,
      onTitleChanged: widget.onTitleChanged,
      onWebMessageReceived: widget.onWebMessageReceived,
      onNavigationRequest: widget.onNavigationRequest,
      onLoadFailed: widget.onLoadFailed,
    );
    _controller = controller;

    try {
      await LinuxWebviewPlugin.channel.invokeMethod('create', {
        'viewId': _viewId,
        'url': widget.initialUrl ?? '',
        'x': bounds.left,
        'y': bounds.top,
        'width': bounds.width,
        'height': bounds.height,
        'userAgent': widget.userAgent,
        'incognito': widget.incognito,
        'userScripts': widget.userScripts,
      });

      if (widget.initialHtml != null && widget.initialHtml!.isNotEmpty) {
        await controller.loadHtml(widget.initialHtml!);
      }

      if (mounted) {
        widget.onWebViewCreated?.call(controller);
      }
    } catch (e) {
      debugPrint('LinuxWebview create error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _BoundsReportingWidget(
      onBoundsChanged: _onBoundsChanged,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}

class _BoundsReportingWidget extends SingleChildRenderObjectWidget {
  final ValueChanged<Rect> onBoundsChanged;

  const _BoundsReportingWidget({
    required this.onBoundsChanged,
    super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderBoundsReporter(onBoundsChanged);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderBoundsReporter renderObject,
  ) {
    renderObject.onBoundsChanged = onBoundsChanged;
  }
}

class _RenderBoundsReporter extends RenderProxyBox {
  ValueChanged<Rect> onBoundsChanged;
  Rect? _lastRect;
  bool _callbackScheduled = false;

  _RenderBoundsReporter(this.onBoundsChanged);

  void _checkBounds() {
    if (!attached) return;

    RenderObject? node = this;
    while (node != null) {
      if (node is RenderOffstage && node.offstage) {
        if (_lastRect != Rect.zero) {
          _lastRect = Rect.zero;
          onBoundsChanged(Rect.zero);
        }
        return;
      }
      node = node.parent;
    }

    final offset = localToGlobal(Offset.zero);
    final rect = Rect.fromLTWH(
      offset.dx.roundToDouble(),
      offset.dy.roundToDouble(),
      size.width.roundToDouble(),
      size.height.roundToDouble(),
    );
    if (_lastRect != rect) {
      _lastRect = rect;
      onBoundsChanged(rect);
    }
  }

  void _scheduleBoundsCheck() {
    if (_callbackScheduled) return;
    _callbackScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callbackScheduled = false;
      _checkBounds();
    });
  }

  @override
  void performLayout() {
    super.performLayout();
    _scheduleBoundsCheck();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    _scheduleBoundsCheck();
  }
}
