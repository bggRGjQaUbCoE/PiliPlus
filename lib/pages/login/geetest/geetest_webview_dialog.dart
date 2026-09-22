import 'dart:convert' show jsonDecode;
import 'dart:io' show Platform;

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/main.dart';
import 'package:PiliPlus/plugin/linux_webview.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class GeetestWebviewDialog extends StatefulWidget {
  const GeetestWebviewDialog(this.gt, this.challenge, {super.key});

  final String gt;
  final String challenge;

  @override
  State<GeetestWebviewDialog> createState() => _GeetestWebviewDialogState();

  static Future<Map<String, dynamic>?> geetest(String gt, String challenge) {
    return showDialog<Map<String, dynamic>>(
      context: Get.context!,
      builder: (context) => GeetestWebviewDialog(gt, challenge),
    );
  }
}

class _GeetestWebviewDialogState extends State<GeetestWebviewDialog> {
  static const _geetestJsUri =
      'https://static.geetest.com/static/js/fullpage.0.0.0.js';
  static const _geetestConfigUri = 'https://api.geetest.com/gettype.php';

  static String _buildHtml(String gt, String challenge) {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final js =
        'var C,S,T,t;'
        'T=()=>{if(C&&S&&!t){t=Geetest(C).onSuccess(()=>R("success",t.getValidate())).onError(o=>R("error",o)).onClose(o=>R("close",o));t.onReady(()=>t.verify())}};'
        'geetest_$ts=(d)=>{'
        'if(!d||d.status!="success"){R("error",JSON.stringify(d));return};'
        'C=Object.assign({gt:"$gt",challenge:"$challenge",offline:false,new_captcha:true,product:"bind",width:"100%",https:true,protocol:"https://"},d.data);T()'
        '};'
        'G=()=>{S=1;T()};'
        'E=()=>{document.getElementById("E").textContent="验证码加载失败";R("error","geetest script load failed")}';

    return '<!DOCTYPE html><html><head><meta name="viewport" content="width=device-width"></head>'
        '<style>#E{position:fixed;inset:0;display:flex;align-items:center;justify-content:center;color:red}</style>'
        '<body><div id="E"></div>'
        '<script>'
        '${Platform.isLinux ? "R=(n,o)=>window.webkit.messageHandlers.msgToNative.postMessage(n+':'+JSON.stringify(o))" : "R=flutter_inappwebview.callHandler"};$js'
        '</script>'
        '<script src="$_geetestJsUri" onload="G()" onerror="E()"></script>'
        '<script src="$_geetestConfigUri?gt=$gt&callback=geetest_$ts" onerror="E()"></script>'
        '</body></html>';
  }

  @override
  Widget build(BuildContext context) {
    final html = _buildHtml(widget.gt, widget.challenge);

    if (Platform.isLinux) {
      return AlertDialog(
        title: const Text('验证码'),
        content: SizedBox(
          width: 300,
          height: 400,
          child: LinuxWebview(
            initialHtml: html,
            userAgent: BrowserUa.mob,
            incognito: true,
            onWebMessageReceived: (msg) {
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
              } else if (msgStr.startsWith('close:')) {
                Get.back();
              }
            },
          ),
        ),
      );
    }

    return Stack(
      children: [
        InAppWebView(
          webViewEnvironment: webViewEnvironment,
          initialSettings: InAppWebViewSettings(
            clearCache: true,
            javaScriptEnabled: true,
            forceDark: ForceDark.AUTO,
            useHybridComposition: true,
            algorithmicDarkeningAllowed: true,
            useShouldOverrideUrlLoading: true,
            userAgent: BrowserUa.mob,
            mixedContentMode: .MIXED_CONTENT_ALWAYS_ALLOW,

            incognito: true,
            allowFileAccess: false,
            allowsLinkPreview: false,
            allowContentAccess: false,
            useOnDownloadStart: false,
            geolocationEnabled: false,
            thirdPartyCookiesEnabled: false,
            enterpriseAuthenticationAppLinkPolicyEnabled: false,
            saveFormData: false,
            safeBrowsingEnabled: false,
            isFraudulentWebsiteWarningEnabled: false,
            domStorageEnabled: false,
            databaseEnabled: false,
            cacheEnabled: false,
            cacheMode: .LOAD_NO_CACHE,

            horizontalScrollBarEnabled: false,
            verticalScrollBarEnabled: false,
            overScrollMode: .NEVER,

            pageZoom: Platform.isIOS ? 3 : 1,
          ),
          initialData: InAppWebViewInitialData(data: html),
          onWebViewCreated: (ctr) {
            ctr
              ..openDevTools()
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
              )
              ..addJavaScriptHandler(
                handlerName: 'close',
                callback: (args) => Get.back(),
              );
          },
        ),
        Positioned(
          left: 8,
          top: 8,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: Get.back,
            tooltip: '关闭',
          ),
        ),
      ],
    );
  }
}
