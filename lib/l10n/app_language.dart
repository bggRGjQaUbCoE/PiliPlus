import 'package:flutter/widgets.dart';

enum AppLanguage {
  system('system', null),
  simplifiedChinese(
    'zh-Hans',
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
  ),
  traditionalChinese(
    'zh-Hant',
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ),
  english('en', Locale('en')),
  ;

  const AppLanguage(this.code, this.locale);

  final String code;
  final Locale? locale;

  static AppLanguage fromCode(String? code) {
    if (code == null) return system;
    return values.firstWhere(
      (language) => language.code == code,
      orElse: () => simplifiedChinese,
    );
  }

  static const supportedLocales = [
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    Locale('en'),
  ];

  Locale resolve(Iterable<Locale> systemLocales) {
    if (locale case final selected?) return selected;
    for (final locale in systemLocales) {
      if (locale.languageCode == 'en') return english.locale!;
      if (locale.languageCode == 'zh') {
        if (locale.scriptCode == 'Hant') return traditionalChinese.locale!;
        if (locale.scriptCode == 'Hans') return simplifiedChinese.locale!;
        return switch (locale.countryCode) {
          'TW' || 'HK' || 'MO' => traditionalChinese.locale!,
          _ => simplifiedChinese.locale!,
        };
      }
    }
    return simplifiedChinese.locale!;
  }
}
