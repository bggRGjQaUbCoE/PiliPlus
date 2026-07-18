import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('macOS Release permits DLNA client and server networking', () {
    final entitlements = File(
      'macos/Runner/Release.entitlements',
    ).readAsStringSync();

    for (final key in const [
      'com.apple.security.network.client',
      'com.apple.security.network.server',
    ]) {
      expect(
        RegExp('<key>$key</key>\\s*<true\\s*/>').hasMatch(entitlements),
        isTrue,
        reason: '$key must be enabled in the signed Release app',
      );
    }
  });
}
