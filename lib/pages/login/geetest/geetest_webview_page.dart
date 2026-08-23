import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show Platform;

import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/webview/view.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GeetestWebviewPage extends StatefulWidget {
  const GeetestWebviewPage(this.gt, this.challenge, {super.key});

  final String gt;
  final String challenge;

  @override
  State<GeetestWebviewPage> createState() => _GeetestWebviewPageState();

  static Future<Map<String, dynamic>?> geetest(String gt, String challenge) {
    return Get.to<Map<String, dynamic>>(
      () => GeetestWebviewPage(gt, challenge),
    )!;
  }
}

class _GeetestWebviewPageState extends State<GeetestWebviewPage> {
  static const String _geetestJsUri =
      'https://static.geetest.com/static/js/fullpage.0.0.0.js';

  late final WebViewController _controller;

  static String _showJs(String response) =>
      't=Geetest($response).onSuccess(()=>R(0,t.getValidate())).onError(o=>R(1,o)).onClose(o=>R(2,o));t.onReady(()=>t.verify())';

  @override
  void initState() {
    super.initState();
    _controller = WebviewPage.buildController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(BrowserUa.mob)
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (message) {
          final msg = message.message;
          switch (int.parse(msg.substring(0, 1))) {
            case 0:
              try {
                final data =
                    jsonDecode(msg.substring(1)) as Map<String, dynamic>;
                Get.back(result: data);
              } catch (e) {
                debugPrint('geetest invalid result: $e');
              }
            case 1:
              debugPrint('geetest error: $msg');
            case 2:
              Get.back();
            default:
              assert(false);
          }
        },
      );

    if (Platform.isAndroid || Platform.isMacOS || Platform.isIOS) {
      _controller
        ..setVerticalScrollBarEnabled(false)
        ..setHorizontalScrollBarEnabled(false)
        ..setOverScrollMode(WebViewOverScrollMode.never);
    }

    _loadInitialHtml();
  }

  Color? _color;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final surface = ColorScheme.of(context).surface;
    if (_color != surface) {
      _color = surface;
      _controller.setBackgroundColor(surface);
    }
  }

  Future<void> _loadInitialHtml() async {
    final config = await _getConfig(widget.gt, widget.challenge);

    if (!mounted) return;
    if (config case Success(:final response)) {
      final html =
          '''<!DOCTYPE html><html><head><meta name="viewport" content="width=device-width"></head><body><script src="$_geetestJsUri"></script><script>R=(a,b)=>FlutterChannel.postMessage(a+JSON.stringify(b));${_showJs(response)}</script></body></html>''';
      await _controller.loadHtmlString(html);
    } else {
      config.toast();
      Get.back();
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

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
      appBar: AppBar(title: const Text('验证码')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
