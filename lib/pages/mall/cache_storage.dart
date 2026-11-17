import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future<Object?> withLegacyMallCache(String script) async {
  final ready = Completer<InAppWebViewController>();
  final view = HeadlessInAppWebView(
    initialData: InAppWebViewInitialData(
      data: '<!doctype html><meta charset="utf-8"><title>Cache maintenance</title>',
      baseUrl: WebUri('https://www.biligo.com/__pili_cache_maintenance'),
    ),
    initialSettings: InAppWebViewSettings(
      javaScriptEnabled: true,
      blockNetworkLoads: true,
    ),
    onLoadStop: (controller, _) {
      if (!ready.isCompleted) ready.complete(controller);
    },
  );
  try {
    await view.run();
    final controller = await ready.future.timeout(const Duration(seconds: 10));
    final result = await controller
        .callAsyncJavaScript(functionBody: script)
        .timeout(const Duration(seconds: 20));
    if (result == null || result.error != null) {
      throw StateError(result?.error ?? '商城缓存清理未返回结果');
    }
    return result.value;
  } finally {
    await view.dispose();
  }
}

Future<int> clearLegacyMallStaticCache() async {
  final source = await rootBundle.loadString(
    'assets/mall/legacy_cache_cleanup.js',
  );
  final result = await withLegacyMallCache(source) as Map;
  return result['removed'] as int;
}
