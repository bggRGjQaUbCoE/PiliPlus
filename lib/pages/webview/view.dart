import 'dart:io' show Platform;

import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/models/common/webview_menu_type.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/path_utils.dart' show appSupportDirPath;
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as path;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_win_floating/webview_plugin.dart';

class WebviewPage extends StatefulWidget {
  const WebviewPage({
    super.key,
    this.url,
    this.oid,
    this.title,
    this.userAgent,
  });

  final String? url;

  // note
  final int? oid;
  final String? title;
  final String? userAgent;

  @override
  State<WebviewPage> createState() => _WebviewPageState();

  static WebViewController buildController() => Platform.isWindows
      ? WebViewController.fromPlatformCreationParams(
          WindowsWebViewControllerCreationParams(
            userDataFolder: path.join(
              appSupportDirPath,
              'flutter_inappwebview',
            ),
          ),
        )
      : WebViewController();
}

class _WebviewPageState extends State<WebviewPage> {
  late final String _url;
  late final RxString _title;
  late final RxDouble _progress = 1.0.obs;
  bool _inApp = false;
  bool _off = false;
  late bool _init = false;
  late final WebViewController _controller;

  static const blankPage = 'about:blank';
  static final _prefixRegex = RegExp(
    r'^(?!(https?://))\S+://',
    caseSensitive: false,
  );

  @override
  void initState() {
    super.initState();
    final parameters = Get.parameters;
    _url = (widget.url ?? parameters['url']!).http2https;
    _title = _url.obs;
    final userAgent =
        widget.userAgent ??
        switch (parameters['uaType']) {
          'pc' => BrowserUa.pc,
          'mob' => BrowserUa.mob,
          _ => BrowserUa.platform,
        };
    if (Get.arguments case final Map map) {
      _inApp = map['inApp'] ?? false;
      _off = map['off'] ?? false;
    }

    final delegate = NavigationDelegate(
      onNavigationRequest: (request) async {
        final url = request.url;
        if (!_inApp &&
            await PiliScheme.routePushFromUrl(
              url,
              selfHandle: true,
              off: _off,
            )) {
          if (!Platform.isWindows) _progress.value = 1;
          return NavigationDecision.prevent;
        }

        if (_prefixRegex.hasMatch(url)) {
          if (Platform.isWindows || Platform.isLinux) {
            PageUtils.launchURL(url);
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('当前网页将要打开外部链接，是否打开'),
                  action: SnackBarAction(
                    label: '打开',
                    onPressed: () => PageUtils.launchURL(url),
                  ),
                ),
              );
            }
          }
          if (!Platform.isWindows) _progress.value = 1;
          return .prevent;
        }
        return .navigate;
      },
    );

    final platformDelegate = delegate.platform;

    if (platformDelegate is WindowsPlatformNavigationDelegate) {
      platformDelegate
        ..onPageTitleChanged = _title.call
        ..setOnPageFinished((url) {
          if (url == blankPage) {
            if (_init) {
              Get.back();
            } else {
              _init = true;
              _controller.loadRequest(Uri.parse(_url));
            }
          } else {
            _injectJavaScriptForBilibili(url);
          }
        });
    } else {
      platformDelegate
        ..setOnPageStarted((url) {
          _progress.value = 0;
        })
        ..setOnProgress((p) {
          _progress.value = p / 100;
        })
        ..setOnPageFinished((url) {
          _controller.getTitle().then((t) {
            if (t != null && t.isNotEmpty) _title.value = t;
          });
          _injectJavaScriptForBilibili(url);
        });
    }

    _controller = WebviewPage.buildController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(userAgent)
      ..setNavigationDelegate(delegate)
      ..addJavaScriptChannel(
        'finishButtonClicked',
        onMessageReceived: (message) => Get.back(),
      )
      ..addJavaScriptChannel(
        'infoBarClicked',
        onMessageReceived: (message) async {
          final uri = await _controller.currentUrl();
          if (uri != null) {
            final oid = Uri.parse(uri).queryParameters['oid'];
            if (oid != null) {
              PiliScheme.videoPush(int.parse(oid), null);
            }
          }
        },
      );

    (_controller.platform as WindowsPlatformWebViewController).openDevTools();

    _initPage();
  }

  @pragma('vm:prefer-inline')
  Future<void> _initPage() {
    return _controller.loadRequest(
      Uri.parse(Platform.isWindows || Platform.isLinux ? blankPage : _url),
    );
  }

  void _injectJavaScriptForBilibili(String url) {
    if (url.startsWith('https://www.bilibili.com/h5/note-app')) {
      _controller.runJavaScript("""
        document.querySelector('.finish-btn')?.addEventListener('click', function() {
          finishButtonClicked.postMessage('click');
        });
        document.querySelector('.info-bar')?.addEventListener('click', function() {
          infoBarClicked.postMessage('click');
        });
      """);
    } else if (url.startsWith('https://live.bilibili.com')) {
      _controller.runJavaScript("""
        document.styleSheets[0].insertRule('div.open-app-btn.bili-btn-warp {display:none;}', 0);
        document.styleSheets[0].insertRule('#app__display-area > div.control-panel {display:none;}', 0);
      """);
    }
  }

  late ColorScheme colorScheme;
  Color? _color;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorScheme = ColorScheme.of(context);
    final surface = colorScheme.surface;
    if (_color != surface) {
      _color = surface;
      _controller.setBackgroundColor(surface);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isLinux) {
      return SimpleScaffold(
        appBar: AppBar(),
        body: Center(
          child: TextButton(
            onPressed: () => PageUtils.launchURL(_url),
            child: const Text('unsupported'),
          ),
        ),
      );
    }
    // shouldInterceptRequest: passport url, shouldInterceptAjaxRequest: edit note title
    return Scaffold(
      appBar: widget.url != null
          ? null
          : AppBar(
              title: Obx(
                () => Text(
                  _title.value.isNotEmpty ? _title.value : _url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              bottom: Platform.isWindows
                  ? null
                  : PreferredSize(
                      preferredSize: Size.zero,
                      child: Obx(
                        () => _progress.value < 1
                            ? LinearProgressIndicator(value: _progress.value)
                            : const SizedBox.shrink(),
                      ),
                    ),
              actions: [
                // TODO: desktop
                PopupMenuButton<WebviewMenuItem>(
                  onSelected: (item) async {
                    switch (item) {
                      case WebviewMenuItem.refresh:
                        await _controller.reload();
                        break;
                      case WebviewMenuItem.copy:
                        final uri = await _controller.currentUrl();
                        if (uri != null) Utils.copyText(uri);
                        break;
                      case WebviewMenuItem.openInBrowser:
                        final uri = await _controller.currentUrl();
                        if (uri != null) PageUtils.launchURL(uri);
                        break;
                      case WebviewMenuItem.clearCache:
                        try {
                          await _controller.clearCache();
                          await _controller.clearLocalStorage();
                          SmartDialog.showToast('已清理缓存');
                        } catch (e) {
                          SmartDialog.showToast(e.toString());
                        }
                        break;
                      case WebviewMenuItem.goBack:
                        if (await _controller.canGoBack()) {
                          _controller.goBack();
                        } else {
                          Get.back();
                        }
                        break;
                      case WebviewMenuItem.resetCookie:
                        await LoginUtils.setWebCookie();
                        SmartDialog.showToast('设置成功，刷新或重新打开网页');
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    ...WebviewMenuItem.values
                        .take(WebviewMenuItem.values.length - 1)
                        .map(
                          (item) => PopupMenuItem(
                            value: item,
                            child: Text(item.title),
                          ),
                        ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: WebviewMenuItem.goBack,
                      child: Text(
                        WebviewMenuItem.goBack.title,
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ),
                  ],
                ),
              ],
            ),
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }

  @override
  void dispose() {
    if (_controller.platform case WindowsPlatformWebViewController ctr) {
      ctr.dispose();
    }
    super.dispose();
  }
}
