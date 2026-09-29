import 'package:PiliPlus/l10n/app_language.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('missing preferences follow the system language', () {
    expect(AppLanguage.fromCode(null), AppLanguage.system);
  });

  test('unknown preferences fall back to Simplified Chinese', () {
    expect(AppLanguage.fromCode('unknown'), AppLanguage.simplifiedChinese);
  });

  test('saved language codes round-trip independently of enum ordering', () {
    for (final language in AppLanguage.values) {
      expect(AppLanguage.fromCode(language.code), language);
    }
  });

  test('an explicit choice takes precedence over system languages', () {
    for (final language in AppLanguage.values.where((e) => e.locale != null)) {
      expect(
        language.resolve(const [Locale('fr'), Locale('zh', 'TW')]),
        language.locale,
      );
    }
  });

  test('system selection uses the first supported language', () {
    expect(
      AppLanguage.system.resolve(const [
        Locale('fr'),
        Locale('en', 'GB'),
        Locale('zh', 'TW'),
      ]),
      AppLanguage.english.locale,
    );
    expect(
      AppLanguage.system.resolve(const [
        Locale('zh', 'TW'),
        Locale('en', 'US'),
      ]),
      AppLanguage.traditionalChinese.locale,
    );
  });

  test('Chinese regions resolve to the appropriate script', () {
    for (final region in ['TW', 'HK', 'MO']) {
      expect(
        AppLanguage.system.resolve([Locale('zh', region)]),
        AppLanguage.traditionalChinese.locale,
      );
    }
    for (final locale in [
      const Locale('zh'),
      const Locale('zh', 'CN'),
      const Locale('zh', 'SG'),
    ]) {
      expect(
        AppLanguage.system.resolve([locale]),
        AppLanguage.simplifiedChinese.locale,
      );
    }
  });

  test('an explicit Chinese script takes precedence over the region', () {
    expect(
      AppLanguage.system.resolve(const [
        Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hans',
          countryCode: 'TW',
        ),
      ]),
      AppLanguage.simplifiedChinese.locale,
    );
    expect(
      AppLanguage.system.resolve(const [
        Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hant',
          countryCode: 'CN',
        ),
      ]),
      AppLanguage.traditionalChinese.locale,
    );
  });

  test(
    'unsupported or absent system languages fall back to Simplified Chinese',
    () {
      expect(
        AppLanguage.system.resolve(const []),
        AppLanguage.simplifiedChinese.locale,
      );
      expect(
        AppLanguage.system.resolve(const [Locale('fr'), Locale('ja')]),
        AppLanguage.simplifiedChinese.locale,
      );
    },
  );
}
