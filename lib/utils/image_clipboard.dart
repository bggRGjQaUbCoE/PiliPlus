import 'dart:io' show Platform;

import 'package:PiliPlus/utils/cache_manager.dart';
import 'package:flutter/services.dart';

abstract final class ImageClipboard {
  static const MethodChannel _channel = MethodChannel('com.example.piliplus/image_clipboard');

  static Future<bool> copyImage(String url) async {
    final file = await CacheManager.manager.getSingleFile(url);
    final result = await _channel.invokeMethod<bool>(
      'copyImage',
      {'path': file.path},
    );
    return result ?? false;
  }
}
