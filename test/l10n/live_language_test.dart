import 'package:PiliPlus/common/dial_prefix.dart';
import 'package:PiliPlus/l10n/app_language.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/theme/theme_color_type.dart';
import 'package:PiliPlus/models_new/space_setting/privacy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    L10n.initialise(AppLanguage.simplifiedChinese, const []);
  });

  tearDown(() {
    Get.reset();
    L10n.initialise(AppLanguage.simplifiedChinese, const []);
  });

  Widget app(Widget home) => AppLanguageObserver(
    child: GetMaterialApp(
      locale: L10n.locale,
      supportedLocales: AppLanguage.supportedLocales,
      localizationsDelegates: L10n.delegates,
      home: home,
    ),
  );

  testWidgets('live switching preserves routes, drafts and scroll positions', (
    tester,
  ) async {
    await tester.pumpWidget(app(const _Home()));
    final key = GlobalKey<_DetailsState>();
    Get.key.currentState!.push(
      MaterialPageRoute<void>(builder: (_) => _Details(key: key)),
    );
    await tester.pumpAndSettle();
    final state = key.currentState!;
    state.draft.text = 'Unsent draft';
    state.scroll.jumpTo(300);

    for (final language in [
      AppLanguage.traditionalChinese,
      AppLanguage.english,
      AppLanguage.simplifiedChinese,
      AppLanguage.traditionalChinese,
    ]) {
      final change = L10n.changeLanguage(language, const []);
      await tester.pumpAndSettle();
      await change;
      expect(key.currentState, same(state));
      expect(state.draft.text, 'Unsent draft');
      expect(state.scroll.offset, 300);
      expect(Get.key.currentState!.canPop(), isTrue);
      expect(find.text(L10n.current.settings), findsOneWidget);
      expect(Localizations.localeOf(key.currentContext!), language.locale);
      expect(tester.takeException(), isNull);
    }

    Get.key.currentState!.pop();
    await tester.pumpAndSettle();
    expect(find.text('首頁'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('system language changes apply only when following the system', (
    tester,
  ) async {
    final dispatcher = tester.binding.platformDispatcher;
    addTearDown(dispatcher.clearLocalesTestValue);
    L10n.initialise(AppLanguage.system, const [Locale('zh', 'CN')]);
    await tester.pumpWidget(app(const _Home()));
    dispatcher.localesTestValue = const [Locale('zh', 'TW')];
    await tester.pumpAndSettle();
    expect(find.text('首頁'), findsOneWidget);

    final change = L10n.changeLanguage(AppLanguage.simplifiedChinese, const []);
    await tester.pumpAndSettle();
    await change;
    dispatcher.localesTestValue = const [Locale('en', 'GB')];
    await tester.pumpAndSettle();
    expect(L10n.locale, AppLanguage.simplifiedChinese.locale);
    expect(find.text('首页'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  test('country and colour labels refresh without changing identifiers', () {
    final countries = Login.dialPrefix;
    final colours = colorThemeTypes;
    L10n.initialise(AppLanguage.traditionalChinese, const []);
    expect(Login.dialPrefix.first.cname, '中國大陸');
    expect(
      Login.dialPrefix.map((e) => (e.id, e.countryId)),
      countries.map((e) => (e.id, e.countryId)),
    );
    expect(colorThemeTypes.map((e) => e.color), colours.map((e) => e.color));
    expect(
      colorThemeTypes.map((e) => e.label),
      isNot(colours.map((e) => e.label)),
    );
  });

  test('privacy labels refresh without resetting unsaved choices', () {
    final privacy = Privacy.fromJson({'fav_video': 0});
    final favourites = privacy.list1.first;
    expect(favourites.name, '公开我的收藏');
    favourites.value = 1;
    L10n.initialise(AppLanguage.traditionalChinese, const []);
    expect(favourites.name, '公開我的收藏');
    expect(favourites.key, 'fav_video');
    expect(favourites.boolVal, isTrue);
  });
}

class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) => Scaffold(body: Text(L10n.current.home));
}

class _Details extends StatefulWidget {
  const _Details({super.key});

  @override
  State<_Details> createState() => _DetailsState();
}

class _DetailsState extends State<_Details> {
  final draft = TextEditingController();
  final scroll = ScrollController();

  @override
  void dispose() {
    draft.dispose();
    scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(L10n.current.settings)),
    body: Column(
      children: [
        TextField(controller: draft),
        Expanded(
          child: ListView.builder(
            controller: scroll,
            itemExtent: 50,
            itemCount: 100,
            itemBuilder: (_, index) => Text('$index'),
          ),
        ),
      ],
    ),
  );
}
