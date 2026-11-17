import 'dart:io';
import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/dynamic_sliver_app_bar/dynamic_sliver_app_bar.dart';

import 'package:PiliPlus/common/widgets/floating_navigation_bar.dart';
import 'package:PiliPlus/common/widgets/button/toolbar_icon_button.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:PiliPlus/pages/video/reply_new/view.dart';
import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart' hide NavigationIndicator;

double ratio(Color first, Color second) =>
    (math.max(first.computeLuminance(), second.computeLuminance()) + .05) /
    (math.min(first.computeLuminance(), second.computeLuminance()) + .05);
ThemeData palette(Brightness mode, [Color seed = Colors.green]) =>
    ThemeUtils.getThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: mode),
      isDynamic: false,
      isDark: mode == Brightness.dark,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory temp;
  setUpAll(() async {
    temp = await Directory.systemTemp.createTemp('piliplus-glass-');
    Hive.init(temp.path);
    GStorage.setting = await Hive.openBox('setting');
  });
  setUp(() async {
    await GStorage.setting.clear();
    await GStorage.setting.putAll({
      SettingBoxKey.advancedMaterials: true,
      SettingBoxKey.softDynamicColors: true,
    });
  });
  tearDownAll(() async {
    await Hive.close();
    await temp.delete(recursive: true);
  });
  testWidgets(
    'shared app bars have one clipped background and preserve explicit transparency',
    (tester) async {
      for (final enabled in [true, false]) {
        await tester.runAsync(
          () => GStorage.setting.put(SettingBoxKey.advancedMaterials, enabled),
        );
        for (final transparent in [false, true]) {
          await tester.pumpWidget(
            MaterialApp(
              theme: palette(Brightness.light),
              home: Scaffold(
                appBar: AppBar(
                  forceMaterialTransparency: transparent,
                  title: const Text('顶栏'),
                ),
                body: const Text('正文'),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(
            find.byType(BackdropFilter),
            enabled && !transparent ? findsOneWidget : findsNothing,
          );
          expect(tester.getSize(find.byType(AppBar)).height, kToolbarHeight);
          expect(find.text('正文'), findsOneWidget);
        }
      }
    },
  );
  testWidgets(
    'flexible toolbar blur grows with collapse, stays toolbar sized and reuses filters',
    (tester) async {
      Object? previousFilter;
      for (final extent in [200.0, 128.0, 56.0, 56.0, 200.0]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: palette(Brightness.light),
            home: FlexibleSpaceBarSettings(
              toolbarOpacity: 1,
              minExtent: 56,
              maxExtent: 200,
              currentExtent: extent,
              child: SizedBox(
                height: extent,
                child: AppBar(
                  primary: false,
                  title: const Text('UP 主'),
                  flexibleSpace: const ColoredBox(color: Colors.blue),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        if (extent == 200) {
          expect(find.byType(BackdropFilter), findsNothing);
        } else {
          expect(find.byType(BackdropFilter), findsOneWidget);
          final filter = tester.widget<BackdropFilter>(
            find.byType(BackdropFilter),
          );
          expect(tester.getSize(find.byType(BackdropFilter)).height, 56);
          final material = tester.widget<Material>(
            find
                .descendant(
                  of: find.byType(BackdropFilter),
                  matching: find.byType(Material),
                )
                .first,
          );
          expect(material.color!.a, closeTo(extent == 56 ? .81 : .405, .004));
          if (extent == 56) {
            if (previousFilter != null) {
              expect(identical(filter.filter, previousFilter), isTrue);
            }
            previousFilter = filter.filter;
          }
        }
      }
    },
  );
  testWidgets(
    'the actual UP dynamic sliver supports progressive blur and clean expansion',
    (tester) async {
      final scroll = ScrollController();
      await tester.pumpWidget(
        MaterialApp(
          theme: palette(Brightness.dark),
          home: Scaffold(
            body: CustomScrollView(
              controller: scroll,
              slivers: [
                const DynamicSliverAppBar.medium(
                  title: Text('UP 主'),
                  flexibleSpace: SizedBox(
                    height: 240,
                    child: ColoredBox(color: Colors.blue),
                  ),
                ),
                SliverList.builder(
                  itemCount: 50,
                  itemBuilder: (_, i) =>
                      SizedBox(height: 80, child: Text('视频 $i')),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(BackdropFilter), findsNothing);
      scroll.jumpTo(120);
      await tester.pumpAndSettle();
      expect(find.byType(BackdropFilter), findsOneWidget);
      scroll.jumpTo(500);
      await tester.pumpAndSettle();
      expect(find.byType(BackdropFilter), findsOneWidget);
      scroll.jumpTo(0);
      await tester.pumpAndSettle();
      expect(find.byType(BackdropFilter), findsNothing);
      await tester.pumpWidget(const SizedBox());
      scroll.dispose();
    },
  );
  testWidgets(
    'the real reply editor uses one shared sheet without changing its empty input',
    (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: palette(Brightness.light),
          home: const ReplyPage(oid: 1, root: 0, parent: 0, replyType: 1),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.text('输入回复内容'), findsOneWidget);
      expect(find.byType(SurfaceMaterial), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      await tester.pumpWidget(const SizedBox());
      Get.reset();
    },
  );
  testWidgets(
    'shared FABs receive one clipped glass each; ordinary buttons retain their own material',
    (tester) async {
      for (final enabled in [true, false]) {
        await tester.runAsync(
          () => GStorage.setting.put(SettingBoxKey.advancedMaterials, enabled),
        );
        var calls = 0;
        await tester.pumpWidget(
          MaterialApp(
            theme: palette(Brightness.light),
            home: Scaffold(
              body: Column(
                children: [
                  FloatingActionButton(
                    onPressed: () => calls++,
                    child: const Icon(Icons.reply),
                  ),
                  FloatingActionButton.extended(
                    onPressed: () => calls++,
                    icon: const Icon(Icons.my_location),
                    label: const Text('定位至上次观看'),
                  ),
                  RawMaterialButton(
                    onPressed: () => calls++,
                    child: const Text('普通按钮'),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(SurfaceMaterial), findsNWidgets(2));
        expect(
          find.byType(BackdropFilter),
          enabled ? findsNWidgets(2) : findsNothing,
        );
        expect(
          tester.getSize(find.byType(FloatingActionButton).first),
          const Size(56, 56),
        );
        await tester.tap(find.text('定位至上次观看'));
        await tester.tap(find.text('普通按钮'));
        expect(calls, 2);
        for (final surface in find.byType(SurfaceMaterial).evaluate()) {
          final material = tester.widget<Material>(
            find
                .descendant(
                  of: find.byWidget(surface.widget),
                  matching: find.byType(Material),
                )
                .first,
          );
          expect(material.color!.a, closeTo(enabled ? .79 : 1, .001));
        }
      }
    },
  );
  testWidgets(
    'floating labels and softly colored icons remain readable over extreme backgrounds',
    (tester) async {
      for (final mode in Brightness.values) {
        for (final seed in [
          Colors.blue,
          Colors.green,
          Colors.red,
          Colors.purple,
          Colors.orange,
        ]) {
          final theme = palette(mode, seed);
          await tester.pumpWidget(
            MaterialApp(
              theme: theme,
              home: Scaffold(
                body: FloatingActionButton.extended(
                  onPressed: () {},
                  icon: const Icon(Icons.my_location),
                  label: const Text('定位'),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final material = tester.widget<Material>(
            find
                .descendant(
                  of: find.byType(BackdropFilter),
                  matching: find.byType(Material),
                )
                .first,
          );
          final label = DefaultTextStyle.of(tester.element(find.text('定位')))
              .style
              .color!;
          final icon = IconTheme.of(
            tester.element(find.byIcon(Icons.my_location)),
          ).color!;
          expect(icon, theme.colorScheme.primary);
          expect(
            material.color!.a,
            closeTo(mode == Brightness.light ? .79 : .71, .001),
          );
          for (final behind in [Colors.black, Colors.white]) {
            final surface = Color.alphaBlend(material.color!, behind);
            expect(
              ratio(label, surface),
              greaterThanOrEqualTo(4.5),
              reason: '$mode $seed label',
            );
            expect(
              ratio(icon, surface),
              greaterThanOrEqualTo(3),
              reason: '$mode $seed icon',
            );
          }
        }
      }
    },
  );
  testWidgets(
    'navigation and toolbar icons follow the softened scheme and retain disabled state',
    (tester) async {
      for (final mode in Brightness.values) {
        final theme = palette(mode);
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Scaffold(
              body: Column(
                children: [
                  FloatingNavigationBar(
                    selectedIndex: 1,
                    destinations: const [
                      FloatingNavigationDestination(
                        icon: Icon(Icons.home),
                        label: '首页',
                      ),
                      FloatingNavigationDestination(
                        icon: Icon(Icons.person),
                        label: '我的',
                      ),
                    ],
                  ),
                  ToolbarIconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.image),
                    selected: true,
                  ),
                  const ToolbarIconButton(
                    icon: Icon(Icons.send),
                    selected: false,
                  ),
                  const Icon(Icons.error, color: Colors.red),
                  IconButton(
                    color: Colors.white,
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          IconTheme.of(tester.element(find.byIcon(Icons.person))).color,
          theme.colorScheme.primary,
        );
        expect(
          IconTheme.of(tester.element(find.byIcon(Icons.image))).color,
          theme.colorScheme.primary,
        );
        expect(
          IconTheme.of(tester.element(find.byIcon(Icons.send))).color,
          theme.colorScheme.onSurface.withValues(alpha: .38),
        );
        expect(tester.widget<Icon>(find.byIcon(Icons.error)).color, Colors.red);
        expect(find.byType(NavigationIndicator), findsOneWidget);
        expect(
          IconTheme.of(tester.element(find.byIcon(Icons.play_arrow))).color,
          Colors.white,
        );
        final backing = tester
            .widget<Material>(
              find
                  .descendant(
                    of: find.byType(SurfaceMaterial),
                    matching: find.byType(Material),
                  )
                  .first,
            )
            .color!;
        final indicator =
            tester
                    .widget<DecoratedBox>(
                      find
                          .descendant(
                            of: find.byType(NavigationIndicator),
                            matching: find.byType(DecoratedBox),
                          )
                          .first,
                    )
                    .decoration
                as ShapeDecoration;
        for (final behind in [Colors.black, Colors.white]) {
          final composed = Color.alphaBlend(
            indicator.color!,
            Color.alphaBlend(backing, behind),
          );
          expect(
            ratio(theme.colorScheme.primary, composed),
            greaterThanOrEqualTo(3),
            reason: '$mode over $behind',
          );
        }
      }
    },
  );
}
