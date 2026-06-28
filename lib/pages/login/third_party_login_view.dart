import 'dart:collection';
import 'dart:io';

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/main.dart' show webViewEnvironment;
import 'package:PiliPlus/pages/login/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ThirdPartyLoginView extends StatefulWidget {
  const ThirdPartyLoginView({
    super.key,
    required this.controller,
    required this.padding,
  });

  final LoginPageController controller;
  final EdgeInsets padding;

  @override
  State<ThirdPartyLoginView> createState() => _ThirdPartyLoginViewState();
}

class _ThirdPartyLoginViewState extends State<ThirdPartyLoginView>
    with WidgetsBindingObserver {
  static const _desktopUserAgent = BrowserUa.pcChrome;

  static final WebUri _loginUri = WebUri(
    'https://passport.bilibili.com/h5-app/passport/login',
  );

  static final UnmodifiableListView<UserScript> _desktopUserScripts =
      UnmodifiableListView([
        UserScript(
          source: _desktopFingerprintScript,
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
          contentWorld: ContentWorld.PAGE,
        ),
      ]);

  static const _desktopFingerprintScript =
      '''
(() => {
  const define = (target, property, value) => {
    try {
      Object.defineProperty(target, property, {
        get: () => value,
        configurable: true,
      });
    } catch (_) {}
  };

  define(Navigator.prototype, 'userAgent', '$_desktopUserAgent');
  define(Navigator.prototype, 'appVersion', '5.0 (Windows NT 10.0; Win64; x64)');
  define(Navigator.prototype, 'platform', 'Win32');
  define(Navigator.prototype, 'vendor', 'Google Inc.');
  define(Navigator.prototype, 'maxTouchPoints', 0);
  define(Navigator.prototype, 'webdriver', false);
  define(Navigator.prototype, 'language', 'zh-CN');
  define(Navigator.prototype, 'languages', ['zh-CN', 'zh']);
  define(Navigator.prototype, 'userAgentData', {
    brands: [
      {brand: 'Chromium', version: '120'},
      {brand: 'Google Chrome', version: '120'},
      {brand: 'Not?A_Brand', version: '99'},
    ],
    mobile: false,
    platform: 'Windows',
    getHighEntropyValues: async (hints) => {
      architecture: 'x86',
      bitness: '64',
      brands: [
        {brand: 'Chromium', version: '120'},
        {brand: 'Google Chrome', version: '120'},
        {brand: 'Not?A_Brand', version: '99'},
      ],
      fullVersionList: [
        {brand: 'Chromium', version: '120.0.0.0'},
        {brand: 'Google Chrome', version: '120.0.0.0'},
        {brand: 'Not?A_Brand', version: '99.0.0.0'},
      ],
      mobile: false,
      model: '',
      platform: 'Windows',
      platformVersion: '10.0.0',
      uaFullVersion: '120.0.0.0',
    },
    toJSON() {
      return {
        brands: this.brands,
        mobile: false,
        platform: 'Windows',
      };
    },
  });

  define(window, 'ontouchstart', undefined);
})();
''';

  static const Set<String> _externalSchemes = {
    'mqqapi',
    'wtloginmqq',
    'weixin',
    'wechat',
    'sinaweibo',
  };

  final RxDouble _progress = 0.0.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _detectLoginStatus();
    }
  }

  Future<void> _detectLoginStatus({bool showResultToast = false}) {
    return widget.controller.importWebLoginCookies(
      showResultToast: showResultToast,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isAndroid) {
      return const Center(child: Text('第三方网页登录仅支持 Android APK'));
    }

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              InAppWebView(
                webViewEnvironment: webViewEnvironment,
                initialUserScripts: _desktopUserScripts,
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  domStorageEnabled: true,
                  databaseEnabled: true,
                  thirdPartyCookiesEnabled: true,
                  supportMultipleWindows: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                  useShouldOverrideUrlLoading: true,
                  forceDark: ForceDark.AUTO,
                  algorithmicDarkeningAllowed: true,
                  mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                  userAgent: _desktopUserAgent,
                  useWideViewPort: true,
                  loadWithOverviewMode: true,
                  supportZoom: true,
                  builtInZoomControls: true,
                  displayZoomControls: false,
                  textZoom: 100,
                ),
                initialUrlRequest: URLRequest(url: _loginUri),
                onProgressChanged: (_, progress) {
                  _progress.value = progress / 100;
                },
                onLoadStop: (_, _) {
                  _progress.value = 1;
                  _detectLoginStatus();
                },
                onUpdateVisitedHistory: (_, _, _) {
                  _detectLoginStatus();
                },
                onReceivedHttpAuthRequest: (_, _) async {
                  await _detectLoginStatus();
                  return null;
                },
                onCreateWindow: (controller, createWindowAction) async {
                  final url = createWindowAction.request.url;
                  if (url != null) {
                    await controller.loadUrl(urlRequest: URLRequest(url: url));
                  }
                  return true;
                },
                shouldOverrideUrlLoading: (_, navigationAction) async {
                  final uri = navigationAction.request.url;
                  if (uri == null) {
                    return NavigationActionPolicy.ALLOW;
                  }
                  if (_externalSchemes.contains(uri.scheme.toLowerCase())) {
                    await _openExternalUri(context, uri);
                    return NavigationActionPolicy.CANCEL;
                  }
                  return NavigationActionPolicy.ALLOW;
                },
              ),
              Obx(
                () => _progress.value < 1
                    ? LinearProgressIndicator(value: _progress.value)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        SizedBox(height: widget.padding.bottom),
      ],
    );
  }

  Future<void> _openExternalUri(BuildContext context, WebUri uri) async {
    final target = uri.uriValue;
    final open = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('打开外部应用'),
        content: Text(uri.toString()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              '取消',
              style: TextStyle(color: ColorScheme.of(context).outline),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('打开'),
          ),
        ],
      ),
    );
    if (open != true) {
      return;
    }
    if (!await launchUrl(
      target,
      mode: LaunchMode.externalNonBrowserApplication,
    )) {
      await launchUrl(target, mode: LaunchMode.externalApplication);
    }
  }
}
