import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_all/webview_all.dart';

/// App callbacks and initialization for the Linux WebView plugin.
class LinuxWebview extends StatefulWidget {
  final String? initialUrl;
  final String? initialHtml;
  final String? userAgent;
  final bool incognito;
  final List<WebViewUserScript> userScripts;
  final ValueChanged<WebViewController>? onWebViewCreated;
  final ValueChanged<String>? onUrlChanged;
  final ValueChanged<double>? onProgress;
  final ValueChanged<String>? onTitleChanged;
  final ValueChanged<String>? onWebMessageReceived;
  final FutureOr<NavigationDecision> Function(NavigationRequest request)?
  onNavigationRequest;
  final void Function(String url, String error)? onLoadFailed;

  const LinuxWebview({
    super.key,
    this.initialUrl,
    this.initialHtml,
    this.userAgent,
    this.incognito = false,
    this.userScripts = const [],
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
  late final WebViewController _controller;
  WebViewSession? _session;
  bool _ready = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    try {
      final session = await WebViewSession.create(
        mode: widget.incognito
            ? WebViewSessionMode.isolatedIncognito
            : WebViewSessionMode.shared,
      );
      if (session == null) {
        throw UnsupportedError('无法创建所需的网页会话');
      }
      if (!mounted) {
        await session.close();
        return;
      }
      _session = session;
      _controller = session.controller;
      await _controller.setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (!mounted) return NavigationDecision.prevent;
            return widget.onNavigationRequest?.call(request) ??
                NavigationDecision.navigate;
          },
          onUrlChange: (change) {
            if (mounted && change.url != null) {
              widget.onUrlChanged?.call(change.url!);
            }
          },
          onTitleChange: (title) {
            if (mounted) widget.onTitleChanged?.call(title);
          },
          onProgress: (progress) {
            if (mounted) widget.onProgress?.call(progress / 100);
          },
          onPageFinished: (url) {
            if (mounted) widget.onProgress?.call(1);
          },
          onWebResourceError: (error) {
            if (mounted && error.isForMainFrame != false) {
              widget.onProgress?.call(1);
              widget.onLoadFailed?.call(
                error.url ?? widget.initialUrl ?? '',
                error.description,
              );
            }
          },
        ),
      );
      await _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      await _controller.setUserAgent(widget.userAgent);
      await _controller.addJavaScriptChannel(
        'PiliPlus',
        onMessageReceived: (message) {
          if (mounted) {
            widget.onWebMessageReceived?.call(message.message);
          }
        },
      );
      for (final script in widget.userScripts) {
        await _controller.addUserScript(script);
      }
      if (!mounted) return;
      widget.onWebViewCreated?.call(_controller);
      if (!mounted) return;
      setState(() => _ready = true);
      if (widget.initialHtml case final html?) {
        await _controller.loadHtmlString(html);
      } else if (widget.initialUrl case final url?) {
        await _controller.loadRequest(Uri.parse(url));
      }
    } catch (error) {
      if (!mounted) return;
      debugPrint('LinuxWebview initialization failed: $error');
      setState(() => _error = error);
      widget.onLoadFailed?.call(widget.initialUrl ?? '', error.toString());
    }
  }

  @override
  void dispose() {
    if (_session case final session?) {
      unawaited(
        session.close().catchError((Object error) {
          debugPrint('LinuxWebview.close failed: $error');
        }),
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return const Center(child: Text('网页加载失败'));
    }
    if (!_ready) {
      return const Center(child: CircularProgressIndicator());
    }
    return WebViewWidget(controller: _controller);
  }
}
