import 'package:PiliPlus/pages/webview/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('authenticated WebViews preserve the shared cookie store', () {
    final settings = buildAuthenticatedWebViewSettings('test-agent');

    // ignore: deprecated_member_use
    expect(settings.clearCache, isFalse);
  });

  test('incognito Geetest does not clear the global cookie store', () {
    final settings = buildGeetestWebViewSettings();

    // ignore: deprecated_member_use
    expect(settings.clearCache, isFalse);
    expect(settings.incognito, isTrue);
    expect(settings.cacheEnabled, isFalse);
  });
}
