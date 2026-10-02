import 'dart:io' show Platform;

import 'package:PiliPlus/common/widgets/route_aware_mixin.dart'
    show routeObserver;
import 'package:PiliPlus/common/widgets/selection_text.dart';
import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/main.dart' show webViewEnvironment;
import 'package:PiliPlus/models/common/webview_menu_type.dart';
import 'package:PiliPlus/plugin/linux_webview.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/cache_manager.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/linux_cookie_manager.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

final _prefixRegex = RegExp(r'^(?!(https?://))\S+://', caseSensitive: false);

class WebviewPage extends StatefulWidget {
  const WebviewPage({
    super.key,
    this.url,
    this.oid,
    this.title,
  });

  // note
  final int? oid;
  final String? title;
  final String? url;

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> with RouteAware {
  late String _currentUrl;
  late final String userAgent;
  late final RxString _title;
  final RxDouble _progress = 1.0.obs;
  bool _inApp = false;
  bool _off = false;

  InAppWebViewController? _webViewController;
  LinuxWebviewController? _linuxController;

  @override
  void initState() {
    super.initState();
    final parameters = Get.parameters;
    _currentUrl = (widget.url ?? parameters['url']!).http2https;
    _title = _currentUrl.obs;
    userAgent = switch (parameters['uaType']) {
      'pc' => BrowserUa.pc,
      'mob' => BrowserUa.mob,
      _ => BrowserUa.platform,
    };
    if (Get.arguments case final Map map) {
      _inApp = map['inApp'] ?? false;
      _off = map['off'] ?? false;
    }

    if (Platform.isAndroid) {
      routeObserver.subscribe(this, Get.routing.route as GetPageRoute);
    }
  }

  @override
  void dispose() {
    if (Platform.isAndroid) routeObserver.unsubscribe(this);
    _linuxController?.dispose();
    _linuxController = null;
    _webViewController = null;
    super.dispose();
  }

  bool _isPop = false;
  @override
  void didPop() {
    setState(() {
      _webViewController = null;
      _isPop = true;
    });
    super.didPop();
  }

  List<Widget> get _actions {
    return [
      PopupMenuButton<WebviewMenuItem>(
        onSelected: _handleMenuItem,
        itemBuilder: (context) => <PopupMenuEntry<WebviewMenuItem>>[
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
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    ];
  }

  /// GtkMenu 创建下拉栏，防止被 WebKitWebView 遮住
  List<Widget> get _linuxActions {
    return [
      Builder(
        builder: (btnContext) {
          return IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () async {
              final renderBox = btnContext.findRenderObject() as RenderBox?;
              Rect? rect;
              if (renderBox != null && renderBox.hasSize) {
                final offset = renderBox.localToGlobal(Offset.zero);
                rect = offset & renderBox.size;
              }

              final menuList = <WebviewMenuItem?>[
                ...WebviewMenuItem.values.take(
                  WebviewMenuItem.values.length - 1,
                ),
                null, // separator
                WebviewMenuItem.goBack,
              ];
              final itemStrings = menuList
                  .map((m) => m?.title ?? '---')
                  .toList();

              final selectedIndex = await LinuxWebviewPlugin.showContextMenu(
                items: itemStrings,
                position: rect,
              );

              if (selectedIndex >= 0 && selectedIndex < menuList.length) {
                final selectedItem = menuList[selectedIndex];
                if (selectedItem != null) {
                  _handleMenuItem(selectedItem);
                }
              }
            },
          );
        },
      ),
    ];
  }

  Future<void> _handleMenuItem(WebviewMenuItem item) async {
    switch (item) {
      case WebviewMenuItem.refresh:
        if (Platform.isLinux) {
          _linuxController?.reload();
        } else {
          _webViewController?.reload();
        }
        break;
      case WebviewMenuItem.copy:
        if (Platform.isLinux) {
          final url = _linuxController?.currentUrl ?? _currentUrl;
          Utils.copyText(url);
        } else {
          WebUri? uri = await _webViewController?.getUrl();
          if (uri != null) {
            Utils.copyText(uri.toString());
          }
        }
        break;
      case WebviewMenuItem.openInBrowser:
        if (Platform.isLinux) {
          final url = _linuxController?.currentUrl ?? _currentUrl;
          PageUtils.launchURL(url);
        } else {
          WebUri? uri = await _webViewController?.getUrl();
          if (uri != null) {
            PageUtils.launchURL(uri.toString());
          }
        }
        break;
      case WebviewMenuItem.clearCache:
        try {
          if (Platform.isLinux) {
            await LinuxCookieManager.deleteAllCookies();
            await LinuxWebviewPlugin.clearCache();
            _linuxController?.reload();
            SmartDialog.showToast('已清理缓存并刷新', alignment: Alignment.topCenter);
          } else {
            await InAppWebViewController.clearAllCache();
            await _webViewController?.clearHistory();
            SmartDialog.showToast('已清理');
          }
        } catch (e) {
          SmartDialog.showToast(e.toString());
        }
        break;
      case WebviewMenuItem.goBack:
        if (Platform.isLinux) {
          _linuxController?.goBack();
        } else {
          if (await _webViewController?.canGoBack() == true) {
            _webViewController?.goBack();
          } else {
            Get.back();
          }
        }
        break;
      case WebviewMenuItem.resetCookie:
        if (Platform.isLinux) {
          final currentUrl = _linuxController?.currentUrl ?? _currentUrl;
          if (LinuxCookieManager.isBiliDomain(currentUrl)) {
            final js = LinuxCookieManager.generateCookieInjectionJs();
            if (js.isNotEmpty) {
              await _linuxController?.evaluateJavaScript(js);
            }
          }
          _linuxController?.reload();
          SmartDialog.showToast('设置成功，正在刷新网页', alignment: Alignment.topCenter);
        } else {
          await LoginUtils.setWebCookie();
          SmartDialog.showToast('设置成功，刷新或重新打开网页');
        }
        break;
    }
  }

  List<Map<String, dynamic>> _getLinuxUserScripts() {
    final shouldInjectCookie = LinuxCookieManager.isBiliDomain(_currentUrl);
    final cookieJs = shouldInjectCookie
        ? LinuxCookieManager.generateCookieInjectionJs()
        : '';

    return [
      if (cookieJs.isNotEmpty)
        {
          'source': cookieJs,
          'injectionTime': 0, // start
          'forAllFrames': true,
        },
      if (_currentUrl.startsWith('https://www.bilibili.com/h5/note-app'))
        const {
          'source': """
document.addEventListener('click', function(e) {
  var finishBtn = e.target && e.target.closest ? e.target.closest('.finish-btn') : null;
  if (finishBtn) {
    window.webkit.messageHandlers.msgToNative.postMessage('finishButtonClicked');
    return;
  }
  var infoBar = e.target && e.target.closest ? e.target.closest('.info-bar') : null;
  if (infoBar) {
    window.webkit.messageHandlers.msgToNative.postMessage('infoBarClicked');
    return;
  }
}, true);
""",
          'injectionTime': 1, // end
          'forAllFrames': true,
        },
      if (_currentUrl.startsWith('https://live.bilibili.com'))
        const {
          'source': """
(function() {
  function injectStyle() {
    if (document.getElementById('pili-live-style')) return;
    var s = document.createElement('style');
    s.id = 'pili-live-style';
    s.textContent = 'div.open-app-btn.bili-btn-warp {display:none !important;} #app__display-area > div.control-panel {display:none !important;}';
    (document.head || document.documentElement).appendChild(s);
  }
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', injectStyle);
  } else {
    injectStyle();
  }
})();
""",
          'injectionTime': 0, // start
          'forAllFrames': true,
        },
    ];
  }

  Widget _buildLinuxView(BuildContext context) {
    final initUrl = _currentUrl;
    return Scaffold(
      appBar: widget.url != null
          ? null
          : AppBar(
              title: Obx(
                () => Text(
                  _title.value.isNotEmpty ? _title.value : _currentUrl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.zero,
                child: Obx(
                  () => _progress.value < 1
                      ? LinearProgressIndicator(value: _progress.value)
                      : const SizedBox.shrink(),
                ),
              ),
              actions: _linuxActions,
            ),
      body: LinuxWebview(
        initialUrl: _currentUrl,
        userAgent: userAgent,
        userScripts: _getLinuxUserScripts(),
        onWebViewCreated: (ctr) {
          _linuxController = ctr;
        },
        onUrlChanged: (u) {
          _currentUrl = u;
          if (_title.value.isEmpty || _title.value == _currentUrl) {
            _title.value = u;
          }
        },
        onTitleChanged: (t) {
          if (t.isNotEmpty) _title.value = t;
        },
        onProgress: (p) {
          _progress.value = p;
        },
        onWebMessageReceived: (msg) {
          final msgStr = msg.toString();
          if (msgStr == 'finishButtonClicked') {
            if (mounted) Get.back();
          } else if (msgStr == 'infoBarClicked') {
            final uri = Uri.tryParse(_currentUrl);
            final targetOid =
                uri?.queryParameters['oid'] ?? widget.oid?.toString();
            if (targetOid != null) {
              PiliScheme.videoPush(int.parse(targetOid), null);
            }
          }
        },
        onNavigationRequest: (u) {
          if (u == initUrl) return;
          final uri = Uri.tryParse(u);
          final isCustomScheme = _prefixRegex.hasMatch(u);

          if (!_inApp && uri != null) {
            PiliScheme.routePush(uri, selfHandle: true, off: _off).then((
              hasMatch,
            ) {
              if (!hasMatch && isCustomScheme) {
                PageUtils.launchURL(u);
              }
            });
          } else if (isCustomScheme) {
            PageUtils.launchURL(u);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isLinux) {
      return _buildLinuxView(context);
    }
    return Scaffold(
      appBar: widget.url != null
          ? null
          : AppBar(
              title: Obx(
                () => Text(
                  _title.value.isNotEmpty ? _title.value : _currentUrl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.zero,
                child: Obx(
                  () => _progress.value < 1
                      ? LinearProgressIndicator(value: _progress.value)
                      : const SizedBox.shrink(),
                ),
              ),
              actions: _isPop ? null : _actions,
            ),
      body: _isPop
          ? null
          : SafeArea(
              child: InAppWebView(
                webViewEnvironment: webViewEnvironment,
                initialSettings: InAppWebViewSettings(
                  clearCache: true,
                  javaScriptEnabled: true,
                  forceDark: ForceDark.AUTO,
                  useHybridComposition: true,
                  algorithmicDarkeningAllowed: true,
                  useShouldOverrideUrlLoading: true,
                  userAgent: userAgent,
                  mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                ),
                initialUrlRequest: URLRequest(
                  url: WebUri.uri(Uri.tryParse(_currentUrl) ?? Uri()),
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  _webViewController = controller
                    ..addJavaScriptHandler(
                      handlerName: 'finishButtonClicked',
                      callback: (args) {
                        Get.back();
                      },
                    )
                    ..addJavaScriptHandler(
                      handlerName: 'infoBarClicked',
                      callback: (args) async {
                        WebUri? uri = await controller.getUrl();
                        if (uri != null) {
                          String? oid = uri.queryParameters['oid'];
                          if (oid != null) {
                            PiliScheme.videoPush(int.parse(oid), null);
                          }
                        }
                      },
                    );
                },
                onProgressChanged: (controller, progress) {
                  _progress.value = progress / 100;
                },
                onTitleChanged: (controller, title) {
                  _title.value = title ?? '';
                },
                onCloseWindow: (controller) => Get.back(),
                onLoadStop: (controller, uri) {
                  final url = uri.toString();
                  if (url.startsWith('https://www.bilibili.com/h5/note-app')) {
                    controller
                      ..evaluateJavascript(
                        source: """
document.querySelector('.finish-btn').addEventListener('click', function() {
    window.flutter_inappwebview.callHandler('finishButtonClicked');
});
""",
                      )
                      ..evaluateJavascript(
                        source: """
document.querySelector('.info-bar').addEventListener('click', function() {
    window.flutter_inappwebview.callHandler('infoBarClicked');
});
""",
                      );
                  } else if (url.startsWith('https://live.bilibili.com')) {
                    controller.evaluateJavascript(
                      source: '''
document.styleSheets[0].insertRule('div.open-app-btn.bili-btn-warp {display:none;}', 0);
document.styleSheets[0].insertRule('#app__display-area > div.control-panel {display:none;}', 0);
                  ''',
                    );
                  }
                  // _webViewController?.evaluateJavascript(
                  //   source: '''
                  //     document.querySelector('#internationalHeader').remove();
                  //     document.querySelector('#message-navbar').remove();
                  //   ''',
                  // );
                },
                onDownloadStartRequest: Platform.isAndroid
                    ? (controller, request) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            String suggestedFilename = request.suggestedFilename
                                .toString();
                            final fileSize = CacheManager.formatSize(
                              request.contentLength,
                            );
                            try {
                              suggestedFilename = Uri.decodeComponent(
                                suggestedFilename,
                              );
                            } catch (e) {
                              if (kDebugMode) debugPrint(e.toString());
                            }
                            final url = request.url.toString();
                            return AlertDialog(
                              title: Text(
                                '下载文件: $suggestedFilename ?',
                                style: const TextStyle(fontSize: 18),
                              ),
                              content: SelectionText(url),
                              actions: [
                                TextButton(
                                  onPressed: Get.back,
                                  child: Text(
                                    '取消',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                    PageUtils.launchURL(url);
                                  },
                                  child: Text('确定 ($fileSize)'),
                                ),
                              ],
                            );
                          },
                        );
                        _progress.value = 1;
                      }
                    : null,
                shouldInterceptAjaxRequest: (controller, ajaxRequest) async {
                  String url = ajaxRequest.url.toString();
                  if (url.startsWith('//api.bilibili.com/x/note/add') &&
                      widget.title != null) {
                    return ajaxRequest
                      ..data = ajaxRequest.data.toString().replaceFirst(
                        '&title=--&',
                        '&title=${widget.title}&',
                      );
                  }
                  return null;
                },
                shouldInterceptRequest: (controller, request) async {
                  String url = request.url.toString();
                  if (url.startsWith(
                    'https://passport.bilibili.com/x/passport-login/web',
                  )) {
                    _progress.value = 1;
                    return WebResourceResponse();
                  }
                  return null;
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  if (!_inApp) {
                    final hasMatch = await PiliScheme.routePush(
                      navigationAction.request.url?.uriValue ?? Uri(),
                      selfHandle: true,
                      off: _off,
                    );
                    // if (kDebugMode) debugPrint('webview: [$url], [$hasMatch]');
                    if (hasMatch) {
                      _progress.value = 1;
                      return .CANCEL;
                    }
                  }
                  final url = navigationAction.request.url.toString();
                  if (_prefixRegex.hasMatch(url)) {
                    if (context.mounted) {
                      final snackBar = SnackBar(
                        persist: false,
                        showCloseIcon: true,
                        content: const Text('当前网页将要打开外部链接，是否打开'),
                        action: SnackBarAction(
                          label: '打开',
                          onPressed: () => PageUtils.launchURL(url),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    _progress.value = 1;
                    return .CANCEL;
                  }

                  return .ALLOW;
                },
              ),
            ),
    );
  }
}
