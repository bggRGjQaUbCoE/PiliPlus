import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show Platform, Directory, File;

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/main.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class GeetestWebviewDialog extends StatefulWidget {
  const GeetestWebviewDialog(this.gt, this.challenge, {super.key});

  final String gt;
  final String challenge;

  @override
  State<GeetestWebviewDialog> createState() => _GeetestWebviewDialogState();
}

class _GeetestWebviewDialogState extends State<GeetestWebviewDialog> {
  static const _geetestJsUri =
      'https://static.geetest.com/static/js/fullpage.0.0.0.js';

  late final Future<LoadingState<String>> _future;
  Webview? _linuxWebview;
  late bool _linuxWebviewLoading = true;

  @override
  void initState() {
    super.initState();
    _future = _getConfig(widget.gt, widget.challenge);
    if (Platform.isLinux) {
      _initLinuxWebview();
    }
  }

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

  Future<void> _initLinuxWebview() async {
    final config = await _future;

    if (!mounted) {
      return;
    }

    if (config is Error) {
      config.toast();
      Get.back();
      return;
    }

    final response = (config as Success<String>).response;

    _linuxWebview = await WebviewWindow.create(
      configuration: const CreateConfiguration(
        windowWidth: 300,
        windowHeight: 400,
        title: "验证码",
      ),
    );

    if (!mounted) {
      _closeLinuxWebview();
      return;
    }

    _linuxWebview!.addOnWebMessageReceivedCallback((msg) {
      final msgStr = msg.toString();
      if (msgStr.startsWith("success:")) {
        final dataStr = msgStr.substring("success:".length);
        try {
          final data = jsonDecode(dataStr);
          Get.back(result: data);
        } catch (e) {
          debugPrint('geetest decode error: $e');
        }
      } else if (msgStr.startsWith("error:")) {
        debugPrint('geetest error: $msgStr');
      }
    });

    _linuxWebview!.onClose.whenComplete(() {
      if (mounted) {
        Get.back();
      }
    });

    final html =
        '''
<!DOCTYPE html><html><head></head><body>
<script src="$_geetestJsUri"></script>
<script>
  function R(n,o){
     window.webkit.messageHandlers.msgToNative.postMessage(n + ':' + JSON.stringify(o));
  }
  let t=Geetest($response).onSuccess(()=>R("success",t.getValidate())).onError((o)=>R("error",o));
  t.onReady(()=>t.verify());
</script>
</body></html>
''';

    final tempDir = Directory.systemTemp;
    final file = File(
      '${tempDir.path}/geetest_${DateTime.now().millisecondsSinceEpoch}.html',
    );
    await file.writeAsString(html);

    if (!mounted) {
      _closeLinuxWebview();
      return;
    }

    _linuxWebview!.launch('file://${file.path}');

    if (mounted) {
      setState(() {
        _linuxWebviewLoading = false;
      });
    }
  }

  void _closeLinuxWebview() {
    _linuxWebview?.close();
    _linuxWebview = null;
  }

  @override
  void dispose() {
    _closeLinuxWebview();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isLinux) {
      return AlertDialog(
        title: const Text('验证码'),
        content: SizedBox(
          width: 300,
          height: 400,
          child: Center(
            child: _linuxWebviewLoading
                ? const CircularProgressIndicator()
                : const Text('请在弹出的新窗口中完成验证'),
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

    return AlertDialog(
      title: const Text('验证码'),
      content: SizedBox(
        width: 300,
        height: 400,
        child: InAppWebView(
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
                '<!DOCTYPE html><html><head></head><body><script src="$_geetestJsUri"></script><script>function R(n,o){flutter_inappwebview.callHandler(n,o)}</script></body></html>',
          ),
          onWebViewCreated: (ctr) {
            ctr
              ..addJavaScriptHandler(
                handlerName: 'success',
                callback: (args) {
                  if (args.isNotEmpty) {
                    if (args[0] case Map<String, dynamic> data) {
                      Get.back(result: data);
                      return;
                    }
                  }
                  debugPrint('geetest invalid result: $args');
                },
              )
              ..addJavaScriptHandler(
                handlerName: 'error',
                callback: (args) {
                  debugPrint('geetest error: $args');
                },
              );
          },
          onLoadStop: (ctr, _) async {
            final config = await _future;
            if (!mounted) return;
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
