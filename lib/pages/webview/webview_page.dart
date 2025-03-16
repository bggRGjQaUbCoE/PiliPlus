import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/cache_manage.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

enum _WebviewMenuItem {
  refresh,
  copy,
  openInBrowser,
  clearCache,
  resetCookie,
  goBack,
}

extension _WebviewMenuItemExt on _WebviewMenuItem {
  String get title => [
        '刷新',
        '复制链接',
        '浏览器中打开',
        '清除缓存',
        '重新设置Cookie',
        '返回',
      ][index];
}

class WebviewPageNew extends StatefulWidget {
  const WebviewPageNew({super.key});

  @override
  State<WebviewPageNew> createState() => _WebviewPageNewState();
}

class _WebviewPageNewState extends State<WebviewPageNew> {
  final String _url = Get.parameters['url'] ?? '';
  final uaType = Get.parameters['uaType'] ?? 'mob';
  final _titleStream = StreamController<String?>();
  final _progressStream = StreamController<double>();
  bool? _inApp;
  bool? _off;

  InAppWebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    if (Get.arguments is Map) {
      _inApp = Get.arguments['inApp'];
      _off = Get.arguments['off'];
    }
  }

  @override
  void dispose() {
    _titleStream.close();
    _progressStream.close();
    _webViewController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
          initialData: null,
          stream: _titleStream.stream,
          builder: (context, snapshot) => Text(
            maxLines: 1,
            snapshot.hasData ? snapshot.data! : _url,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: StreamBuilder(
            initialData: 0.0,
            stream: _progressStream.stream,
            builder: (context, snapshot) => snapshot.data as double < 1
                ? LinearProgressIndicator(
                    value: snapshot.data as double,
                  )
                : const SizedBox.shrink(),
          ),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (item) async {
              switch (item) {
                case _WebviewMenuItem.refresh:
                  _webViewController?.reload();
                  break;
                case _WebviewMenuItem.copy:
                  WebUri? uri = await _webViewController?.getUrl();
                  if (uri != null) {
                    Utils.copyText(uri.toString());
                  }
                  break;
                case _WebviewMenuItem.openInBrowser:
                  WebUri? uri = await _webViewController?.getUrl();
                  if (uri != null) {
                    Utils.launchURL(uri.toString());
                  }
                  break;
                case _WebviewMenuItem.clearCache:
                  try {
                    await InAppWebViewController.clearAllCache();
                    await _webViewController?.clearHistory();
                    SmartDialog.showToast('已清理');
                  } catch (e) {
                    SmartDialog.showToast(e.toString());
                  }
                  break;
                case _WebviewMenuItem.goBack:
                  if (await _webViewController?.canGoBack() == true) {
                    _webViewController?.goBack();
                  } else {
                    Get.back();
                  }
                  break;
                case _WebviewMenuItem.resetCookie:
                  final cookies = Accounts.main.cookieJar.toList();
                  for (var item in cookies) {
                    await CookieManager().setCookie(
                      url: WebUri(item.domain ?? ''),
                      name: item.name,
                      value: item.value,
                      path: item.path ?? '',
                      domain: item.domain,
                      isSecure: item.secure,
                      isHttpOnly: item.httpOnly,
                    );
                  }
                  SmartDialog.showToast('设置成功，刷新或重新打开网页');
                  break;
              }
            },
            itemBuilder: (context) => <PopupMenuEntry<_WebviewMenuItem>>[
              ..._WebviewMenuItem.values
                  .sublist(0, _WebviewMenuItem.values.length - 1)
                  .map((item) =>
                      PopupMenuItem(value: item, child: Text(item.title))),
              const PopupMenuDivider(),
              PopupMenuItem(
                  value: _WebviewMenuItem.goBack,
                  child: Text(
                    _WebviewMenuItem.goBack.title,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  )),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: InAppWebView(
          initialSettings: InAppWebViewSettings(
            clearCache: true,
            javaScriptEnabled: true,
            forceDark: ForceDark.AUTO,
            useHybridComposition: false,
            algorithmicDarkeningAllowed: true,
            useShouldOverrideUrlLoading: true,
            userAgent: Request.headerUa(type: uaType),
            mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
          ),
          initialUrlRequest:
              URLRequest(url: WebUri.uri(Uri.tryParse(_url) ?? Uri())),
          onWebViewCreated: (InAppWebViewController controller) {
            _webViewController = controller;
          },
          onProgressChanged: (controller, progress) {
            _progressStream.add(progress / 100);
          },
          onTitleChanged: (controller, title) {
            _titleStream.add(title);
          },
          onCloseWindow: (controller) => Get.back(),
          onLoadStop: (controller, url) {
            if (url.toString().startsWith('https://live.bilibili.com')) {
              _webViewController?.evaluateJavascript(
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
                        String suggestedFilename =
                            request.suggestedFilename.toString();
                        String fileSize = CacheManage.formatSize(
                            request.contentLength.toDouble());
                        try {
                          suggestedFilename =
                              Uri.decodeComponent(suggestedFilename);
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                        return AlertDialog(
                          title: Text(
                            '下载文件: $suggestedFilename ?',
                            style: const TextStyle(fontSize: 18),
                          ),
                          content: SelectableText(request.url.toString()),
                          actions: [
                            TextButton(
                              onPressed: Get.back,
                              child: const Text('取消'),
                            ),
                            TextButton(
                                onPressed: () async {
                                  Get.back();
                                  Utils.launchURL(request.url.toString());
                                },
                                child: Text('确定 ($fileSize)')),
                          ],
                        );
                      });
                  _progressStream.add(1);
                }
              : null,
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            if (_inApp == true) {
              return NavigationActionPolicy.ALLOW;
            }
            late String url = navigationAction.request.url.toString();
            bool hasMatch = await PiliScheme.routePush(
              navigationAction.request.url?.uriValue ?? Uri(),
              selfHandle: true,
              off: _off ?? true,
            );
            // debugPrint('webview: [$url], [$hasMatch]');
            if (hasMatch) {
              _progressStream.add(1.0);
              return NavigationActionPolicy.CANCEL;
            } else if (RegExp(r'^(?!(https?://))\S+://', caseSensitive: false)
                .hasMatch(url)) {
              if (context.mounted) {
                SnackBar snackBar = SnackBar(
                  content: const Text('当前网页将要打开外部链接，是否打开'),
                  showCloseIcon: true,
                  action: SnackBarAction(
                    label: '打开',
                    onPressed: () => Utils.launchURL(url),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              _progressStream.add(1.0);
              return NavigationActionPolicy.CANCEL;
            }

            return NavigationActionPolicy.ALLOW;
          },
        ),
      ),
    );
  }
}
