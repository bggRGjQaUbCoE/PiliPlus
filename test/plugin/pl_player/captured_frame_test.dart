import 'dart:convert';
import 'dart:ui' as ui;

import 'package:PiliPlus/plugin/pl_player/utils/captured_frame.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('decoded captured frame remains valid after codec disposal', () async {
    final image = await decodeCapturedFrame(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
      ),
    );
    try {
      expect(image.width, 1);
      expect(image.height, 1);
      expect(await image.toByteData(format: ui.ImageByteFormat.png), isNotNull);
    } finally {
      image.dispose();
    }
  });
}
