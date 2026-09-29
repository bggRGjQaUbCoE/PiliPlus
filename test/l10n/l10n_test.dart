import 'package:PiliPlus/l10n/app_language.dart';
import 'package:PiliPlus/l10n/generated/app_localizations.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  tearDown(() => L10n.initialise(AppLanguage.simplifiedChinese, const []));

  test(
    'startup without a saved preference resolves the system language',
    () {
      for (final entry in {
        const Locale('zh', 'HK'): 'zh_Hant',
        const Locale('zh', 'CN'): 'zh',
        const Locale('en', 'US'): 'en',
      }.entries) {
        L10n.initialise(AppLanguage.fromCode(null), [entry.key]);
        expect(L10n.current.localeName, entry.value);
      }
    },
  );

  test('all supported locales load with the generated delegate', () async {
    for (final locale in AppLanguage.supportedLocales) {
      expect(AppLocalizations.delegate.isSupported(locale), isTrue);
      final messages = await AppLocalizations.delegate.load(locale);
      expect(messages.home, isNotEmpty);
      expect(messages.languageTitle, isNotEmpty);
    }
  });

  test('translated catalogues preserve interpolated values', () async {
    for (final language in [
      AppLanguage.english,
      AppLanguage.traditionalChinese,
    ]) {
      final messages = await AppLocalizations.delegate.load(language.locale!);
      expect(messages.exitApp('PiliPlus'), contains('PiliPlus'));
      expect(messages.logoutConfirmation('123\n456'), contains('123\n456'));
      expect(
        messages.replyUtilsCheckReplyText("User's {original} comment"),
        contains("User's {original} comment"),
      );
    }
  });

  for (final language in AppLanguage.values.where((e) => e.locale != null)) {
    testWidgets('app and framework delegates load for ${language.code}', (
      tester,
    ) async {
      L10n.initialise(language, const []);
      await tester.pumpWidget(
        MaterialApp(
          locale: L10n.locale,
          supportedLocales: AppLanguage.supportedLocales,
          localizationsDelegates: L10n.delegates,
          home: Builder(
            builder: (context) {
              expect(Localizations.localeOf(context), language.locale);
              expect(
                AppLocalizations.of(context).localeName,
                L10n.current.localeName,
              );
              expect(
                MaterialLocalizations.of(context).cancelButtonLabel,
                isNotEmpty,
              );
              if (language == AppLanguage.traditionalChinese) {
                expect(
                  MaterialLocalizations.of(context).selectAllButtonLabel,
                  '全部選取',
                );
              }
              expect(Directionality.of(context), TextDirection.ltr);
              return Scaffold(
                body: Text(AppLocalizations.of(context).languageTitle),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(L10n.current.languageTitle), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
