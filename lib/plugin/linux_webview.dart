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
          controller._onUrlChanged?.call(url);
          break;
        case 'onProgressChanged':
          final progress = (args['progress'] as num?)?.toDouble() ?? 0.0;
          controller._onProgressChanged?.call(progress);
          break;
        case 'onTitleChanged':
          final title = args['title'] as String? ?? '';
          controller._onTitleChanged?.call(title);
          break;
        case 'onWebMessageReceived':
          final message = args['message'] as String? ?? '';
          controller._onWebMessageReceived?.call(message);
          break;
        case 'onNavigationRequest':
          final url = args['url'] as String? ?? '';
          controller._onNavigationRequest?.call(url);
          break;
        case 'onLoadFailed':
          final url = args['url'] as String? ?? '';
          final error = args['error'] as String? ?? '';
          controller._onLoadFailed?.call(url, error);
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
  static int _nextViewId = 0;

  final int viewId;
  ValueChanged<String>? _onUrlChanged;
  ValueChanged<double>? _onProgressChanged;
  ValueChanged<String>? _onTitleChanged;
  ValueChanged<String>? _onWebMessageReceived;
  ValueChanged<String>? _onNavigationRequest;
  void Function(String url, String error)? _onLoadFailed;

  String? currentUrl;
  bool _isDisposed = false;

  LinuxWebviewController({
    String? initialUrl,
    this._onUrlChanged,
    this._onProgressChanged,
    this._onTitleChanged,
    this._onWebMessageReceived,
    this._onNavigationRequest,
    this._onLoadFailed,
  }) : currentUrl = initialUrl,
       viewId = ++_nextViewId {
    LinuxWebviewPlugin.registerController(viewId, this);
  }

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

class LinuxWebview extends LeafRenderObjectWidget {
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
  RenderObject createRenderObject(BuildContext context) {
    return _LinuxWebviewRenderObject(
      LinuxWebviewController(
        initialUrl: initialUrl,
        onUrlChanged: onUrlChanged,
        onProgressChanged: onProgress,
        onTitleChanged: onTitleChanged,
        onWebMessageReceived: onWebMessageReceived,
        onNavigationRequest: onNavigationRequest,
        onLoadFailed: onLoadFailed,
      ),
      initialHtml,
      userAgent,
      incognito,
      userScripts,
      onWebViewCreated,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    // ignore: library_private_types_in_public_api
    covariant _LinuxWebviewRenderObject renderObject,
  ) {
    renderObject._controller
      .._onUrlChanged = onUrlChanged
      .._onProgressChanged = onProgress
      .._onTitleChanged = onTitleChanged
      .._onWebMessageReceived = onWebMessageReceived
      .._onNavigationRequest = onNavigationRequest
      .._onLoadFailed = onLoadFailed;
    renderObject
      ..initialHtml = initialHtml
      ..userAgent = userAgent
      ..incognito = incognito
      ..userScripts = userScripts
      ..onWebViewCreated = onWebViewCreated;
  }
}

class _LinuxWebviewRenderObject extends RenderBox {
  final LinuxWebviewController _controller;
  bool _initializedNative = false;
  Rect? _lastRect;
  bool _callbackScheduled = false;

  String? initialHtml;
  String? userAgent;
  bool incognito;
  List<Map<String, dynamic>>? userScripts;
  ValueChanged<LinuxWebviewController>? onWebViewCreated;

  _LinuxWebviewRenderObject(
    this._controller,
    this.initialHtml,
    this.userAgent,
    this.incognito,
    this.userScripts,
    this.onWebViewCreated,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void performLayout() {
    size = constraints.biggest;
    _scheduleBoundsCheck();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    _scheduleBoundsCheck();
  }

  void _scheduleBoundsCheck() {
    if (_callbackScheduled) return;
    _callbackScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback(_checkBounds);
  }

  void _checkBounds(_) {
    _callbackScheduled = false;
    if (!attached) return;

    for (RenderObject? node = this; node != null; node = node.parent) {
      if (node is RenderOffstage && node.offstage) {
        if (_lastRect != Rect.zero) {
          _lastRect = Rect.zero;
          _controller.updateBounds(Rect.zero, visible: false);
        }
        return;
      }
    }

    final rect = localToGlobal(Offset.zero) & size;
    if (_lastRect == rect) return;
    _lastRect = rect;

    final isVisible = rect.width > 0 && rect.height > 0;

    if (!_initializedNative) {
      if (isVisible) {
        _initializedNative = true;
        _createNativeWebview(rect);
      }
    } else {
      _controller.updateBounds(rect, visible: isVisible);
    }
  }

  Future<void> _createNativeWebview(Rect bounds) async {
    try {
      await LinuxWebviewPlugin.channel.invokeMethod('create', {
        'viewId': _controller.viewId,
        'url': _controller.currentUrl ?? '',
        'x': bounds.left,
        'y': bounds.top,
        'width': bounds.width,
        'height': bounds.height,
        'userAgent': userAgent,
        'incognito': incognito,
        'userScripts': userScripts,
      });

      if (initialHtml case final html? when html.isNotEmpty) {
        await _controller.loadHtml(html);
      }

      if (attached) {
        onWebViewCreated?.call(_controller);
      }
    } catch (e) {
      debugPrint('LinuxWebview create error: $e');
    }
  }
}
