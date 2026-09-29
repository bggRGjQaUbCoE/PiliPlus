import 'package:PiliPlus/l10n/app_language.dart';
import 'package:PiliPlus/l10n/generated/app_localizations.dart';
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/widgets.dart';
import 'package:get/get.dart' show Get, GetNavigation;
import 'package:material_ui/material_ui.dart' show GlobalMaterialLocalizations;

abstract final class L10n {
  static const delegates = [
    AppLocalizations.delegate,
    ...GlobalMaterialLocalizations.delegates,
  ];

  static final _locale = ValueNotifier(AppLanguage.simplifiedChinese.locale!);
  static AppLanguage _language = AppLanguage.simplifiedChinese;
  static AppLocalizations _current = lookupAppLocalizations(_locale.value);

  static Locale get locale => _locale.value;
  static ValueListenable<Locale> get changes => _locale;
  static AppLocalizations get current => _current;

  static void initialise(AppLanguage language, Iterable<Locale> systemLocales) {
    _language = language;
    final resolved = language.resolve(systemLocales);
    _current = lookupAppLocalizations(resolved);
    _locale.value = resolved;
  }

  static Future<void> changeLanguage(
    AppLanguage language,
    Iterable<Locale> systemLocales,
  ) async {
    final previous = locale;
    initialise(language, systemLocales);
    if (previous != locale) {
      await Get.updateLocale(locale);
    }
  }

  static String languageLabel(AppLanguage language) => switch (language) {
    AppLanguage.system => current.languageSystem,
    AppLanguage.simplifiedChinese => current.languageSimplifiedChinese,
    AppLanguage.traditionalChinese => current.languageTraditionalChinese,
    AppLanguage.english => current.languageEnglish,
  };
}

class AppLanguageObserver extends StatefulWidget {
  const AppLanguageObserver({required this.child, super.key});

  final Widget child;

  @override
  State<AppLanguageObserver> createState() => _AppLanguageObserverState();
}

class _AppLanguageObserverState extends State<AppLanguageObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (L10n._language == AppLanguage.system) {
      L10n.changeLanguage(AppLanguage.system, locales ?? const []);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
