import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/main.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:webview_all/webview_all.dart';

class GeetestWebviewDialog extends StatefulWidget {
  const GeetestWebviewDialog(this.gt, this.challenge, {super.key});

  final String gt;
  final String challenge;

  static const _geetestJsUri =
      'https://static.geetest.com/static/js/fullpage.0.0.0.js';

  static Future<LoadingState<String>> _getConfig(
    String gt,
    String challenge,
  ) async {
    final res = await Request().get<String>(
      'https://api.geetest.com/gettype.php',
      queryParameters: {'gt': gt},
      options: Options(
        responseType: ResponseType.plain,
        extra: {'account': const NoAccount()},
      ),
    );
    if (res.data case final String data) {
      if (data.startsWith('(') && data.endsWith(')')) {
        final Map<String, dynamic> config;
        try {
          config = jsonDecode(data.substring(1, data.length - 1));
        } catch (e) {
          return Error(e.toString());
        }
        if (config['status'] == 'success') {
          return Success(
            jsonEncode(
              config['data'] as Map<String, dynamic>..addAll({
                "gt": gt,
                "challenge": challenge,
                "offline": false,
                "new_captcha": true,
                "product": "bind",
                "width": "100%",
                "https": true,
                "protocol": "https://",
              }),
            ),
          );
        } else {
          return Error(data);
        }
      }
    }
    return Error(res.data['message']);
  }

  @override
  State<GeetestWebviewDialog> createState() => _GeetestWebviewDialogState();
}

class _GeetestWebviewDialogState extends State<GeetestWebviewDialog> {
  late final bool _isLinux = Platform.isLinux;
  late final Future<LoadingState<String>> _future;
  late WebViewController? _linuxController;

  @override
  void initState() {
    super.initState();
    _future = GeetestWebviewDialog._getConfig(widget.gt, widget.challenge);

    if (_isLinux) {
      _linuxController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setUserAgent(BrowserUa.mob)
        ..addJavaScriptChannel(
          'geetestResult',
          onMessageReceived: (JavaScriptMessage message) {
            try {
              final Map<String, dynamic> data = jsonDecode(message.message);
              if (data['type'] == 'success' &&
                  data['payload'] is Map<String, dynamic>) {
                Get.back(result: data['payload']);
              } else if (data['type'] == 'error') {
                debugPrint('geetest error: ${data['payload']}');
              }
            } catch (_) {
              debugPrint('geetest invalid: ${message.message}');
            }
          },
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (_) async {
              final config = await _future;
              if (!mounted) return;
              if (config case Success(:final response)) {
                await _linuxController!.runJavaScript('''
                  let t=Geetest($response)
                    .onSuccess(()=>R("success",t.getValidate()))
                    .onError((o)=>R("error",o));
                  t.onReady(()=> {
                    t.verify();
                  });
                ''');
              } else {
                config.toast();
                Get.back();
              }
            },
          ),
        );

      const initialHtml =
          '''
          <!DOCTYPE html><html><head></head><body>
          <script src="${GeetestWebviewDialog._geetestJsUri}"></script>
          <script>
          function R(n,o){
            window.geetestResult.postMessage(JSON.stringify({type: n, payload: o}));
          }
          </script>
          </body></html>
          ''';
      _linuxController!.loadHtmlString(initialHtml);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('验证码'),
      content: SizedBox(
        width: 300,
        height: 400,
        child: _isLinux
            ? WebViewWidget(controller: _linuxController!)
            : InAppWebView(
                webViewEnvironment: webViewEnvironment,
                initialSettings: InAppWebViewSettings(
                  clearCache: true,
                  javaScriptEnabled: true,
                  forceDark: ForceDark.AUTO,
                  useHybridComposition: false,
                  algorithmicDarkeningAllowed: true,
                  useShouldOverrideUrlLoading: true,
                  userAgent: BrowserUa.mob,
                  mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                ),
                initialData: InAppWebViewInitialData(
                  data:
                      '<!DOCTYPE html><html><head></head><body><script src="${GeetestWebviewDialog._geetestJsUri}"></script><script>function R(n,o){flutter_inappwebview.callHandler(n,o)}</script></body></html>',
                ),
                onWebViewCreated: (ctr) {
                  ctr
                    ..addJavaScriptHandler(
                      handlerName: 'success',
                      callback: (args) {
                        if (args.isNotEmpty &&
                            args[0] is Map<String, dynamic>) {
                          Get.back(result: args[0]);
                        } else {
                          debugPrint('geetest invalid result: $args');
                        }
                      },
                    )
                    ..addJavaScriptHandler(
                      handlerName: 'error',
                      callback: (args) => debugPrint('geetest error: $args'),
                    );
                },
                onLoadStop: (ctr, _) async {
                  final config = await _future;
                  if (config case Success(:final response)) {
                    ctr.evaluateJavascript(
                      source:
                          'let t=Geetest($response).onSuccess(()=>R("success",t.getValidate())).onError((o)=>R("error",o));t.onReady(()=>t.verify());',
                    );
                  } else {
                    config.toast();
                    Get.back();
                  }
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(
            '取消',
            style: TextStyle(color: ColorScheme.of(context).outline),
          ),
        ),
      ],
    );
  }
}
