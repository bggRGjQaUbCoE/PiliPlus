import 'dart:io';
import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/floating_navigation_bar.dart';
import 'package:PiliPlus/common/widgets/g2_shape_border.dart';
import 'package:PiliPlus/common/widgets/scroll_under_toolbar.dart';
import 'package:PiliPlus/common/widgets/sliver/sliver_floating_header.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/rendering.dart' show BackdropFilterLayer;
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

double contrast(Color a, Color b) =>
    (math.max(a.computeLuminance(), b.computeLuminance()) + .05) /
    (math.min(a.computeLuminance(), b.computeLuminance()) + .05);

ThemeData testTheme(Brightness brightness) => ThemeUtils.getThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: brightness,
  ),
  isDynamic: false,
  isDark: brightness == Brightness.dark,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('piliplus-materials-');
    Hive.init(directory.path);
    GStorage.setting = await Hive.openBox('setting');
  });
  setUp(() => GStorage.setting.clear());
  tearDownAll(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  test('G2 corners stay inside their bounds and Sheet only rounds the top', () {
    const rect = Rect.fromLTWH(0, 0, 200, 100);
    final dialog = const G2ShapeBorder(radius: 24).getOuterPath(rect);
    final sheet = const G2ShapeBorder(
      radius: 32,
      topOnly: true,
    ).getOuterPath(rect);
    expect(dialog.getBounds(), rect);
    expect(dialog.contains(const Offset(1, 1)), isFalse);
    expect(dialog.contains(const Offset(1, 99)), isFalse);
    expect(sheet.contains(const Offset(1, 99)), isTrue);
    expect(sheet.contains(const Offset(1, 1)), isFalse);
  });

  testWidgets('floating filter only blurs when it actually overlaps the list', (
    tester,
  ) async {
    await tester.runAsync(
      () => GStorage.setting.put(SettingBoxKey.advancedMaterials, true),
    );
    final scroll = ScrollController();
    addTearDown(scroll.dispose);
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: testTheme(Brightness.light),
        home: Scaffold(
          body: CustomScrollView(
            controller: scroll,
            slivers: [
              SliverFloatingHeaderWidget(
                glassOnOverlap: true,
                backgroundColor: Colors.white,
                child: SizedBox(
                  height: 44,
                  child: TextButton(
                    onPressed: () => taps++,
                    child: const Text('筛选'),
                  ),
                ),
              ),
              SliverList.builder(
                itemCount: 40,
                itemBuilder: (_, i) =>
                    SizedBox(height: 70, child: Text('结果 $i')),
              ),
            ],
          ),
        ),
      ),
    );
    expect(tester.layers.whereType<BackdropFilterLayer>(), isEmpty);
    scroll.jumpTo(300);
    await tester.pumpAndSettle();
    expect(tester.layers.whereType<BackdropFilterLayer>(), isEmpty);
    final drag =
        scroll.position.drag(
          DragStartDetails(globalPosition: const Offset(200, 300)),
          () {},
        )..update(
          DragUpdateDetails(
            globalPosition: const Offset(200, 420),
            delta: const Offset(0, 120),
            primaryDelta: 120,
          ),
        );
    await tester.pump();
    expect(tester.layers.whereType<BackdropFilterLayer>(), hasLength(1));
    drag.end(DragEndDetails(primaryVelocity: 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('筛选'));
    expect(taps, 1);
    scroll.jumpTo(0);
    await tester.pumpAndSettle();
    expect(tester.layers.whereType<BackdropFilterLayer>(), isEmpty);
  });

  testWidgets(
    'list passes under the toolbar without moving its filter target',
    (
      tester,
    ) async {
      await tester.runAsync(
        () => GStorage.setting.put(SettingBoxKey.advancedMaterials, true),
      );
      final scroll = ScrollController();
      addTearDown(scroll.dispose);
      var filterTaps = 0;
      var toolbarTaps = 0;
      Widget app() => MaterialApp(
        theme: testTheme(Brightness.dark),
        home: Scaffold(
          body: DefaultTabController(
            length: 1,
            child: Builder(
              builder: (context) => ScrollUnderToolbar(
                extent: 96,
                controller: DefaultTabController.of(context),
                underlaps: const {0},
                leadingSpaces: const {},
                toolbar: Align(
                  alignment: Alignment.topCenter,
                  child: TextButton(
                    onPressed: () => toolbarTaps++,
                    child: const Text('顶栏'),
                  ),
                ),
                pages: [
                  CustomScrollView(
                    controller: scroll,
                    slivers: [
                      SliverFloatingHeaderWidget(
                        glassOnOverlap: true,
                        backgroundColor: Colors.black,
                        child: SizedBox(
                          height: 44,
                          child: TextButton(
                            onPressed: () => filterTaps++,
                            child: const Text('筛选'),
                          ),
                        ),
                      ),
                      SliverFixedExtentList.builder(
                        itemExtent: 70,
                        itemCount: 40,
                        itemBuilder: (_, i) => Text('结果 $i'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(app());
      final maxExtent = scroll.position.maxScrollExtent;
      expect(tester.getTopLeft(find.text('结果 0')).dy, 140);
      expect(find.byType(BackdropFilter), findsNothing);

      scroll.jumpTo(20);
      await tester.pumpAndSettle();
      expect(find.byType(BackdropFilter), findsNothing);
      scroll.jumpTo(300);
      await tester.pumpAndSettle();
      expect(find.byType(BackdropFilter), findsOneWidget);
      final drag =
          scroll.position.drag(
            DragStartDetails(globalPosition: const Offset(200, 300)),
            () {},
          )..update(
            DragUpdateDetails(
              globalPosition: const Offset(200, 420),
              delta: const Offset(0, 120),
              primaryDelta: 120,
            ),
          );
      await tester.pump();
      expect(find.byType(BackdropFilter), findsOneWidget);
      drag.end(DragEndDetails(primaryVelocity: 0));
      await tester.pumpAndSettle();
      expect(find.byType(BackdropFilter), findsOneWidget);
      expect(tester.getTopLeft(find.text('筛选')).dy, greaterThan(96));
      await tester.tap(find.text('筛选'));
      await tester.tap(find.text('顶栏'));
      expect((filterTaps, toolbarTaps), (1, 1));

      scroll.jumpTo(0);
      await tester.pumpAndSettle();
      expect(find.byType(BackdropFilter), findsNothing);
      await tester.runAsync(
        () => GStorage.setting.put(SettingBoxKey.advancedMaterials, false),
      );
      await tester.pumpWidget(app());
      expect(tester.getTopLeft(find.text('结果 0')).dy, 140);
      expect(scroll.position.maxScrollExtent, maxExtent);
    },
  );

  testWidgets(
    'shared dialogs, input, menus and sheets use one clipped backdrop',
    (tester) async {
      await tester.runAsync(
        () => GStorage.setting.put(SettingBoxKey.advancedMaterials, true),
      );
      late BuildContext host;
      await tester.pumpWidget(
        MaterialApp(
          theme: testTheme(Brightness.light),
          home: Builder(
            builder: (context) {
              host = context;
              return const Scaffold(body: Text('背景内容'));
            },
          ),
        ),
      );
      final dialogResult = showDialog<bool>(
        context: host,
        builder: (context) => AlertDialog(
          title: const Text('确认操作'),
          content: const TextField(),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('确认'),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(BackdropFilter), findsOneWidget);
      expect(find.byType(ClipPath), findsWidgets);
      await tester.enterText(find.byType(TextField), '输入内容');
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(tester.getBottomRight(find.text('确认')).dy, lessThan(600));
      await tester.tap(find.text('确认'));
      await tester.pumpAndSettle();
      expect(await dialogResult, isTrue);
      tester.view.resetViewInsets();
      final menuResult = showMenu<int>(
        context: host,
        position: const RelativeRect.fromLTRB(200, 50, 0, 0),
        items: const [PopupMenuItem(value: 1, child: Text('菜单项'))],
      );
      await tester.pumpAndSettle();
      expect(find.byType(BackdropFilter), findsOneWidget);
      await tester.tap(find.text('菜单项'));
      await tester.pumpAndSettle();
      expect(await menuResult, 1);
      final sheetResult = showModalBottomSheet<int>(
        context: host,
        builder: (context) => TextButton(
          onPressed: () => Navigator.pop(context, 2),
          child: const Text('关闭面板'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(BackdropFilter), findsOneWidget);
      await tester.tap(find.text('关闭面板'));
      await tester.pumpAndSettle();
      expect(await sheetResult, 2);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('floating bar retains size, outline, labels and selection', (
    tester,
  ) async {
    Size? baseline;
    for (final enabled in [false, true]) {
      await tester.runAsync(
        () => GStorage.setting.put(SettingBoxKey.advancedMaterials, enabled),
      );
      var selected = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: testTheme(Brightness.light),
          home: Scaffold(
            body: Center(
              child: FloatingNavigationBar(
                destinations: const [
                  FloatingNavigationDestination(
                    icon: Icon(Icons.home),
                    label: '首页',
                  ),
                  FloatingNavigationDestination(
                    icon: Icon(Icons.dynamic_feed),
                    label: '动态',
                  ),
                  FloatingNavigationDestination(
                    icon: Icon(Icons.shopping_bag),
                    label: '会员购',
                  ),
                  FloatingNavigationDestination(
                    icon: Icon(Icons.person),
                    label: '我的',
                  ),
                ],
                onDestinationSelected: (value) => selected = value,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final surface = find.byType(SurfaceMaterial);
      final size = tester.getSize(surface);
      baseline ??= size;
      expect(size, baseline);
      expect(size, const Size(344, 64));
      expect(
        tester.widget<SurfaceMaterial>(surface).material.shape,
        isA<RoundedSuperellipseBorder>(),
      );
      expect(
        find.byType(BackdropFilter),
        enabled ? findsOneWidget : findsNothing,
      );
      await tester.tap(find.text('会员购'));
      expect(selected, 2);
    }
  });

  testWidgets(
    'foreground text and actions retain contrast over extreme backdrops',
    (tester) async {
      await tester.runAsync(
        () => GStorage.setting.put(SettingBoxKey.advancedMaterials, true),
      );
      for (final brightness in Brightness.values) {
        final theme = testTheme(brightness);
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Scaffold(
              body: SurfaceMaterial(
                kind: SurfaceMaterialKind.dialog,
                material: Material(
                  shape: theme.dialogTheme.shape,
                  color: theme.colorScheme.surface,
                  child: const SizedBox(
                    width: 200,
                    height: 100,
                    child: Text('清晰文字'),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final foregroundMaterial = tester.widget<Material>(
          find
              .descendant(
                of: find.byType(BackdropFilter),
                matching: find.byType(Material),
              )
              .first,
        );
        final tint = foregroundMaterial.color!;
        for (final background in [Colors.black, Colors.white]) {
          final composite = Color.alphaBlend(tint, background);
          for (final text in [
            theme.colorScheme.onSurface,
            theme.colorScheme.primary,
            theme.colorScheme.error,
          ]) {
            final ratio = contrast(text, composite);
            debugPrint('${brightness.name} alpha ${tint.a} contrast: $ratio');
            expect(ratio, greaterThanOrEqualTo(4.5));
          }
        }
      }
    },
  );

  testWidgets(
    'explicit black player menus retain white-label contrast in light pages',
    (tester) async {
      for (final enabled in [false, true]) {
        await tester.runAsync(
          () => GStorage.setting.put(SettingBoxKey.advancedMaterials, enabled),
        );
        ThemeUtils.darkTheme = testTheme(Brightness.dark);
        final light = testTheme(Brightness.light);
        late BuildContext host;
        await tester.pumpWidget(
          MaterialApp(
            theme: light,
            home: Builder(
              builder: (context) {
                host = context;
                return const Scaffold(body: SizedBox());
              },
            ),
          ),
        );
        final result = showMenu<void>(
          context: host,
          color: Colors.black.withValues(alpha: .8),
          position: const RelativeRect.fromLTRB(100, 100, 0, 0),
          items: const [
            PopupMenuItem(
              child: Text('1.0X', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
        await tester.pumpAndSettle();
        final material = tester.widget<Material>(
          find
              .descendant(
                of: find.byType(SurfaceMaterial),
                matching: find.byType(Material),
              )
              .last,
        );
        expect(
          contrast(
            Colors.white,
            Color.alphaBlend(material.color!, Colors.white),
          ),
          greaterThanOrEqualTo(4.5),
        );
        if (!enabled) expect(material.color!.a, 1);
        Navigator.of(host).pop();
        await tester.pumpAndSettle();
        await result;
      }
    },
  );

  testWidgets('disabled setting uses opaque theme material and no filter', (
    tester,
  ) async {
    late BuildContext host;
    await tester.pumpWidget(
      MaterialApp(
        theme: testTheme(Brightness.light),
        home: Builder(
          builder: (context) {
            host = context;
            return const Scaffold(body: SizedBox());
          },
        ),
      ),
    );
    showDialog<void>(
      context: host,
      builder: (_) => const AlertDialog(title: Text('不透明对话框')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(BackdropFilter), findsNothing);
    final surface = tester.widget<SurfaceMaterial>(
      find.byType(SurfaceMaterial),
    );
    expect(surface.material.color!.a, 1);
  });
}
