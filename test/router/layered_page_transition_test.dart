import 'dart:io';
import 'dart:ui' as ui;

import 'package:PiliPlus/common/widgets/image_viewer/hero_dialog_route.dart';
import 'package:PiliPlus/router/layered_page_transition.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  late BuildContext rootContext;
  late int taps;

  Future<void> start(
    WidgetTester tester, {
    bool enabled = true,
    bool blur = true,
    bool reduceMotion = false,
  }) async {
    await tester.runAsync(
      () => GStorage.setting.putAll({
        SettingBoxKey.layeredPageTransition: enabled,
        SettingBoxKey.advancedMaterials: blur,
      }),
    );
    LayeredPageTransitions.install();
    taps = 0;
    await tester.pumpWidget(
      GetMaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(disableAnimations: reduceMotion),
          child: child!,
        ),
        defaultTransition: Transition.native,
        initialRoute: '/',
        getPages: [
          GetPage(
            name: '/',
            page: () => Builder(
              builder: (context) {
                rootContext = context;
                return Scaffold(
                  body: TextButton(
                    onPressed: () => taps++,
                    child: const Text('root button'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
  }

  GetPageRoute<void> push(String? name, {Widget? child}) {
    final route = GetPageRoute<void>(
      settings: RouteSettings(name: name),
      page: () => child ?? const Scaffold(body: Text('new page')),
    );
    Navigator.of(rootContext).push(route);
    return route;
  }

  Future<void> clean(WidgetTester tester) async {
    await tester.pumpAndSettle();
    expect(find.byType(ImageFiltered), findsNothing);
    await tester.tap(find.text('root button'));
    await tester.pump();
    expect(taps, 1);
    expect(tester.takeException(), isNull);
  }

  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('pili-layered-');
    Hive.init(directory.path);
    GStorage.setting = await Hive.openBox('setting');
  });
  setUp(() async {
    Get.testMode = true;
    await GStorage.setting.clear();
  });
  tearDown(Get.reset);
  tearDownAll(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  testWidgets(
    'reduced motion presents an ordinary page without layered effects',
    (tester) async {
      await start(tester, reduceMotion: true);
      push('/setting');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      expect(find.text('new page'), findsOneWidget);
      expect(find.byType(LayeredPageTransition), findsNothing);
      expect(find.byType(ImageFiltered), findsNothing);
      Navigator.of(rootContext).pop();
      await clean(tester);
    },
  );

  test(
    'default is off; choice saves without changing legacy enum indices',
    () async {
      expect(Pref.layeredPageTransition, isFalse);
      expect(Pref.pageTransition, Transition.native);
      await GStorage.setting.putAll({
        SettingBoxKey.layeredPageTransition: true,
        SettingBoxKey.pageTransition: Transition.cupertino.index,
      });
      await GStorage.setting.flush();
      expect(Pref.layeredPageTransition, isTrue);
      expect(Pref.pageTransition, Transition.cupertino);
      expect(LayeredPageTransitions.supports('/setting/styleSetting'), isTrue);
      expect(LayeredPageTransitions.supports('/favDetail?id=1'), isTrue);
      for (final name in [
        null,
        '/UnknownPage',
        '/ContactPage',
        '/DownloadDetailPage',
        '/Widget',
        '/videoV',
        '/audio',
        '/musicDetail',
        '/liveRoom',
        '/webview',
        '/videoWeb',
        '/ssWeb',
        '/dlna',
      ]) {
        expect(LayeredPageTransitions.supports(name), isTrue, reason: '$name');
      }
      for (final name in [
        '/',
        '/FullScreenSc',
      ]) {
        expect(LayeredPageTransitions.supports(name), isFalse, reason: name);
      }
    },
  );

  testWidgets(
    '320ms entry/exit, quadratic deceleration, opaque new page and old-only blur',
    (tester) async {
      await start(tester);
      final route = push('/setting', child: const Text('transparent content'));
      expect(route.transitionDuration, const Duration(milliseconds: 320));
      expect(
        route.reverseTransitionDuration,
        const Duration(milliseconds: 320),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 160));
      final translations = tester
          .widgetList<FractionalTranslation>(find.byType(FractionalTranslation))
          .toList();
      expect(
        translations.map((e) => e.translation.dx),
        containsAll([closeTo(-.15, 1e-6), closeTo(.25, 1e-6)]),
      );
      final filter = tester.widget<ImageFiltered>(find.byType(ImageFiltered));
      expect(
        filter.imageFilter,
        ui.ImageFilter.blur(
          sigmaX: 4.5,
          sigmaY: 4.5,
          tileMode: ui.TileMode.clamp,
        ),
      );
      expect(
        find.ancestor(
          of: find.text('transparent content'),
          matching: find.byType(ImageFiltered),
        ),
        findsNothing,
      );
      final colors = tester
          .widgetList<ColoredBox>(find.byType(ColoredBox))
          .map((w) => w.color)
          .toList();
      expect(colors, contains(Colors.black.withValues(alpha: .135)));
      expect(
        tester
            .widget<ColoredBox>(
              find
                  .ancestor(
                    of: find.text('transparent content'),
                    matching: find.byType(ColoredBox),
                  )
                  .first,
            )
            .color
            .a,
        1,
      );
      await tester.pumpAndSettle();
      Navigator.of(rootContext).pop();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 160));
      expect(
        tester
            .widgetList<FractionalTranslation>(
              find.byType(FractionalTranslation),
            )
            .map((e) => e.translation.dx),
        containsAll([closeTo(-.05, 1e-6), closeTo(.75, 1e-6)]),
      );
      await clean(tester);
    },
  );

  testWidgets(
    'Get.to widgets and factories outside settings use layered routes',
    (tester) async {
      await start(tester);
      for (final page in <dynamic>[
        const Scaffold(body: Text('ordinary destination')),
        () => const Scaffold(body: Text('ordinary destination')),
      ]) {
        final result = Get.to(page);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 80));
        final route = ModalRoute.of(
          tester.element(find.text('ordinary destination')),
        )!;
        expect(route, isA<GetPageRoute<dynamic>>());
        expect(route.settings.name, isNot(startsWith('/setting')));
        expect(route.transitionDuration, const Duration(milliseconds: 320));
        expect(find.byType(LayeredPageTransition), findsNWidgets(2));
        expect(find.byType(ImageFiltered), findsOneWidget);
        Get.back(result: 'selected');
        await tester.pumpAndSettle();
        expect(await result, 'selected');
      }
      await clean(tester);
    },
  );

  testWidgets(
    'anonymous Navigator.push preserves arguments, results and layered underlay',
    (tester) async {
      await start(tester);
      final route = GetPageRoute<String>(
        settings: const RouteSettings(arguments: 'selection input'),
        page: () => const Scaffold(body: Text('anonymous selection')),
      );
      final result = Navigator.of(rootContext).push(route);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      expect(route.settings.name, isNull);
      expect(route.settings.arguments, 'selection input');
      expect(route.transitionDuration, const Duration(milliseconds: 320));
      expect(find.byType(LayeredPageTransition), findsNWidgets(2));
      expect(find.byType(ImageFiltered), findsOneWidget);
      await tester.pumpAndSettle();
      push(null);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      expect(route.secondaryAnimation!.value, greaterThan(0));
      expect(find.byType(ImageFiltered), findsOneWidget);
      Navigator.of(rootContext).pop();
      await tester.pumpAndSettle();
      Navigator.of(rootContext).pop('selection result');
      await tester.pumpAndSettle();
      expect(await result, 'selection result');
      await clean(tester);
    },
  );

  testWidgets(
    'materials off keeps motion and dim without blur; option off keeps original routes',
    (tester) async {
      await start(tester, blur: false);
      push('/history');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      expect(find.byType(ImageFiltered), findsNothing);
      expect(find.byType(LayeredPageTransition), findsNWidgets(2));
      Navigator.of(rootContext).pop();
      await clean(tester);
      await tester.runAsync(
        () => GStorage.setting.put(SettingBoxKey.layeredPageTransition, false),
      );
      final route = push('/setting');
      expect(route.transitionDuration, const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      expect(find.byType(LayeredPageTransition), findsNothing);
      Navigator.of(rootContext).pop();
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'rapid stacked pushes and mid-entry pop leave no filters or hit blockers',
    (tester) async {
      await start(tester);
      push('/setting');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      push('/history');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      Navigator.of(rootContext).pop();
      await tester.pump(const Duration(milliseconds: 20));
      Navigator.of(rootContext).pop();
      await clean(tester);
    },
  );

  testWidgets('changing materials while a page is open applies on return', (
    tester,
  ) async {
    await start(tester);
    for (final enabled in [false, true]) {
      await tester.runAsync(
        () => GStorage.setting.put(SettingBoxKey.advancedMaterials, !enabled),
      );
      push('/setting');
      await tester.pumpAndSettle();
      await tester.runAsync(
        () => GStorage.setting.put(SettingBoxKey.advancedMaterials, enabled),
      );
      Navigator.of(rootContext).pop();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      expect(
        find.byType(ImageFiltered),
        enabled ? findsOneWidget : findsNothing,
      );
      await tester.pumpAndSettle();
    }
    await clean(tester);
  });

  testWidgets(
    'canceled framework back, lifecycle pause/resume and a later back clean up',
    (tester) async {
      await start(tester);
      final route = push('/setting');
      await tester.pumpAndSettle();
      route
        ..handleStartBackGesture(progress: 1)
        ..handleUpdateBackGestureProgress(progress: .6);
      await tester.pump();
      route.handleCancelBackGesture();
      await tester.pumpAndSettle();
      expect(route.isCurrent, isTrue);
      expect(route.popGestureInProgress, isFalse);
      expect(find.byType(ImageFiltered), findsNothing);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      Navigator.of(rootContext).pop();
      await clean(tester);
    },
  );

  testWidgets(
    'orientation preview and popup routes keep their transitions',
    (tester) async {
      await start(tester);
      for (final name in ['/FullScreenSc']) {
        final special = push(name);
        expect(special.transitionDuration, const Duration(milliseconds: 300));
        await tester.pumpAndSettle();
        expect(find.byType(LayeredPageTransition), findsNothing);
        push('/setting');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 80));
        // A special source remains sharp and stationary, even under an ordinary page.
        expect(find.byType(ImageFiltered), findsNothing);
        expect(special.secondaryAnimation!.value, 0);
        Navigator.of(rootContext).pop();
        await tester.pumpAndSettle();
        Navigator.of(rootContext).pop();
        await tester.pumpAndSettle();
      }
      showDialog<void>(
        context: rootContext,
        builder: (_) => const AlertDialog(title: Text('popup')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LayeredPageTransition), findsNothing);
      Navigator.of(rootContext).pop();
      await clean(tester);
    },
  );

  testWidgets(
    'media and WebView outer routes animate without bypassing internal back',
    (tester) async {
      await start(tester);
      for (final name in [
        '/videoV',
        '/liveRoom',
        '/audio',
        '/musicDetail',
        '/webview',
        '/videoWeb',
        '/ssWeb',
        '/dlna',
      ]) {
        var internalBack = true;
        final route = push(
          name,
          child: StatefulBuilder(
            builder: (context, setState) => PopScope(
              canPop: !internalBack,
              onPopInvokedWithResult: (didPop, _) {
                if (!didPop) {
                  setState(() => internalBack = false);
                }
              },
              child: const Scaffold(body: Text('media or web page')),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 80));
        expect(route.transitionDuration, const Duration(milliseconds: 320));
        expect(find.byType(LayeredPageTransition), findsNWidgets(2));
        expect(find.byType(ImageFiltered), findsOneWidget);
        await tester.pumpAndSettle();
        await Navigator.of(rootContext).maybePop();
        await tester.pumpAndSettle();
        expect(route.isCurrent, isTrue);
        expect(internalBack, isFalse);
        expect(route.animation!.value, 1);
        await Navigator.of(rootContext).maybePop();
        await tester.pumpAndSettle();
        expect(find.byType(ImageFiltered), findsNothing);
      }
      await clean(tester);
    },
  );

  testWidgets('image Hero keeps its own fade route over a layered page', (
    tester,
  ) async {
    await start(tester);
    push('/setting');
    await tester.pumpAndSettle();
    final image = HeroDialogRoute<void>(
      pageBuilder: (_, _, _) => const Center(child: Text('image preview')),
    );
    Navigator.of(rootContext).push(image);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(image.opaque, isFalse);
    expect(image.transitionDuration, const Duration(milliseconds: 300));
    expect(find.byType(ImageFiltered), findsNothing);
    expect(
      find.ancestor(
        of: find.text('image preview'),
        matching: find.byType(LayeredPageTransition),
      ),
      findsNothing,
    );
    Navigator.of(rootContext).pop();
    await tester.pumpAndSettle();
    Navigator.of(rootContext).pop();
    await clean(tester);
  });
  testWidgets(
    'cover mode falls back to layered ordinary pages and respects opt-out',
    (tester) async {
      await start(tester, enabled: false);
      await tester.runAsync(
        () => GStorage.setting.put(SettingBoxKey.coverPageTransition, true),
      );
      final route = push('/searchResult');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(route.transitionDuration, const Duration(milliseconds: 320));
      expect(find.byType(LayeredPageTransition), findsWidgets);
      Navigator.of(rootContext).pop();
      await clean(tester);
      await tester.runAsync(
        () => GStorage.setting.put(SettingBoxKey.coverPageTransition, false),
      );
      taps = 0;
      push('/another');
      await tester.pump();
      expect(find.byType(LayeredPageTransition), findsNothing);
      Navigator.of(rootContext).pop();
      await clean(tester);
    },
  );
}
