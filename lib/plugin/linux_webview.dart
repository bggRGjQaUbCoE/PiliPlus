import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_all_linux/webview_all_linux.dart';
import 'package:webview_platform_interface/webview_platform_interface.dart';

/// App callbacks and initialization for the Linux WebView plugin.
class LinuxWebview extends StatefulWidget {
  final String? initialUrl;
  final String? initialHtml;
  final String? userAgent;
  final bool incognito;
  final List<WebViewUserScript> userScripts;
  final ValueChanged<LinuxWebViewController>? onWebViewCreated;
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
  LinuxWebViewController? _controller;
  bool _ready = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    try {
      final controller = LinuxWebViewController(
        LinuxWebViewControllerCreationParams(incognito: widget.incognito),
      );
      _controller = controller;
      await controller.prepareSession();
      if (!mounted) return;
      final delegate = LinuxNavigationDelegate(
        const LinuxNavigationDelegateCreationParams(),
      );
      await delegate.setOnNavigationRequest((request) {
        if (!mounted) return NavigationDecision.prevent;
        return widget.onNavigationRequest?.call(request) ??
            NavigationDecision.navigate;
      });
      await delegate.setOnUrlChange((change) {
        if (mounted && change.url != null) {
          widget.onUrlChanged?.call(change.url!);
        }
      });
      await delegate.setOnTitleChange((title) {
        if (mounted) widget.onTitleChanged?.call(title);
      });
      await delegate.setOnProgress((progress) {
        if (mounted) widget.onProgress?.call(progress / 100);
      });
      await delegate.setOnPageFinished((url) {
        if (mounted) widget.onProgress?.call(1);
      });
      await delegate.setOnWebResourceError((error) {
        if (mounted && error.isForMainFrame != false) {
          widget.onProgress?.call(1);
          widget.onLoadFailed?.call(
            error.url ?? widget.initialUrl ?? '',
            error.description,
          );
        }
      });
      await controller.setPlatformNavigationDelegate(delegate);
      await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      await controller.setUserAgent(widget.userAgent);
      await controller.addJavaScriptChannel(
        JavaScriptChannelParams(
          name: 'PiliPlus',
          onMessageReceived: (message) {
            if (mounted) {
              widget.onWebMessageReceived?.call(message.message);
            }
          },
        ),
      );
      for (final script in widget.userScripts) {
        await controller.addUserScript(script);
      }
      if (!mounted) return;
      widget.onWebViewCreated?.call(controller);
      if (!mounted) return;
      setState(() => _ready = true);
      if (widget.initialHtml case final html?) {
        await controller.loadHtmlString(html);
      } else if (widget.initialUrl case final url?) {
        await controller.loadRequest(LoadRequestParams(uri: Uri.parse(url)));
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
    if (_controller case final controller?) {
      unawaited(
        controller.dispose().catchError((Object error) {
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
    return LinuxWebViewWidget(
      LinuxWebViewWidgetCreationParams(controller: _controller!),
    ).build(context);
  }
}
