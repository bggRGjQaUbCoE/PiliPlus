import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter/services.dart';

abstract final class DisplayCutoutHelper {
  static const MethodChannel _channel = MethodChannel(
    'com.example.piliplus/display_cutout',
  );

  static Future<List<Rect>> bounds() async {
    if (!Platform.isAndroid) return const [];

    try {
      final raw = await _channel.invokeMethod<List<dynamic>>('bounds');
      if (raw == null || raw.isEmpty) return const [];

      return raw
          .whereType<Map>()
          .map(
            (item) => Rect.fromLTRB(
              (item['left'] as num).toDouble(),
              (item['top'] as num).toDouble(),
              (item['right'] as num).toDouble(),
              (item['bottom'] as num).toDouble(),
            ),
          )
          .toList(growable: false);
    } on PlatformException {
      return const [];
    }
  }
}
