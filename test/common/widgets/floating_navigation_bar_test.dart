import 'package:PiliPlus/common/widgets/floating_navigation_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' hide NavigationIndicator;

void main() {
  const labels = ['首页', '动态', '会员购', '我的'];
  late ValueNotifier<int> selected;
  late List<int> taps;
  var builds = 0;

  setUp(() {
    selected = ValueNotifier(0);
    taps = [];
    builds = 0;
  });
  tearDown(() => selected.dispose());

  Future<void> showBar(
    WidgetTester tester, {
    double width = 500,
    bool stretch = false,
    List<String> order = labels,
    TextDirection direction = TextDirection.ltr,
    bool reduceMotion = false,
    Brightness brightness = Brightness.light,
  }) => tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: brightness,
        ),
      ),
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reduceMotion),
        child: Directionality(
          textDirection: direction,
          child: ValueListenableBuilder<int>(
            valueListenable: selected,
            builder: (context, index, _) {
              builds++;
              return Scaffold(
                body: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: stretch ? width : 0,
                      maxWidth: width,
                    ),
                    child: FloatingNavigationBar(
                      selectedIndex: index,
                      onDestinationSelected: (value) {
                        taps.add(value);
                        selected.value = value;
                      },
                      destinations: [
                        for (final label in order)
                          FloatingNavigationDestination(
                            icon: const Icon(Icons.circle_outlined),
                            selectedIcon: const Icon(Icons.circle),
                            label: label,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );

  Rect indicator(WidgetTester tester) =>
      tester.getRect(find.byType(NavigationIndicator));
  double target(WidgetTester tester, String label) => tester
      .getCenter(
        find.ancestor(
          of: find.text(label),
          matching: find.byType(FloatingNavigationDestination),
        ),
      )
      .dx;

  testWidgets(
    'first display has one correctly placed unchanged-size indicator',
    (tester) async {
      selected.value = 2;
      await showBar(tester);
      expect(find.byType(NavigationIndicator), findsOneWidget);
      expect(indicator(tester).center.dx, closeTo(target(tester, '会员购'), .001));
      expect(indicator(tester).size, const Size(84, 56));
      expect(tester.getSize(find.byType(SurfaceMaterial)), const Size(344, 64));
      expect(tester.binding.transientCallbackCount, 0);
    },
  );

  testWidgets(
    'adjacent and cross-item moves translate without selecting intermediate pages',
    (tester) async {
      await showBar(tester);
      final initial = indicator(tester);
      await tester.tap(find.text('动态'));
      await tester.pump();
      expect(selected.value, 1);
      expect(find.byIcon(Icons.circle), findsOneWidget);
      expect(indicator(tester), initial);
      await tester.pump(const Duration(milliseconds: 140));
      expect(
        indicator(tester).center.dx,
        closeTo(initial.center.dx + 84 * Curves.decelerate.transform(.5), .01),
      );
      expect(indicator(tester).size, initial.size);
      await tester.pumpAndSettle();
      expect(indicator(tester).center.dx, closeTo(target(tester, '动态'), .001));
      await tester.tap(find.text('我的'));
      await tester.pumpAndSettle();
      expect(taps, [1, 3]);
      expect(indicator(tester).center.dx, closeTo(target(tester, '我的'), .001));
      expect(find.byType(NavigationIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'interrupted moves start at visible position and follow latest tap immediately',
    (tester) async {
      await showBar(tester);
      await tester.tap(find.text('我的'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 70));
      final visible = indicator(tester);
      await tester.tap(find.text('首页'));
      await tester.pump();
      expect(selected.value, 0);
      expect(indicator(tester), visible);
      await tester.pump(const Duration(milliseconds: 35));
      expect(indicator(tester).left, lessThan(visible.left));
      final reversed = indicator(tester);
      await tester.tap(find.text('会员购'));
      await tester.pump();
      expect(indicator(tester), reversed);
      expect(selected.value, 2);
      await tester.pumpAndSettle();
      expect(taps, [3, 0, 2]);
      expect(indicator(tester).center.dx, closeTo(target(tester, '会员购'), .001));
    },
  );

  testWidgets(
    'repeat taps are delivered without restarting motion or rebuilding pages every frame',
    (tester) async {
      await showBar(tester);
      await tester.tap(find.text('我的'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final visible = indicator(tester);
      final selectedBuilds = builds;
      await tester.tap(find.text('我的'));
      await tester.pump();
      expect(indicator(tester), visible);
      await tester.pump(const Duration(milliseconds: 180));
      expect(indicator(tester).center.dx, closeTo(target(tester, '我的'), .001));
      expect(taps, [3, 3]);
      expect(builds, selectedBuilds);
    },
  );

  testWidgets(
    'width count order and RTL changes reposition without an obsolete trajectory',
    (tester) async {
      await showBar(tester);
      await tester.tap(find.text('我的'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      await showBar(tester, width: 280);
      expect(indicator(tester).center.dx, closeTo(target(tester, '我的'), .001));
      expect(indicator(tester).width, 68);
      await showBar(tester, width: 280, direction: TextDirection.rtl);
      expect(indicator(tester).center.dx, closeTo(target(tester, '我的'), .001));
      expect(indicator(tester).center.dx, lessThan(target(tester, '首页')));
      selected.value = 1;
      await showBar(tester, width: 280, order: const ['我的', '会员购', '首页']);
      expect(indicator(tester).center.dx, closeTo(target(tester, '会员购'), .001));
      await showBar(tester, width: 280, order: const ['首页', '会员购', '我的']);
      expect(indicator(tester).center.dx, closeTo(target(tester, '会员购'), .001));
      expect(taps, [3]);
    },
  );

  testWidgets('theme changes preserve visible motion and one indicator', (
    tester,
  ) async {
    await showBar(tester);
    await tester.tap(find.text('会员购'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 90));
    final visible = indicator(tester);
    await showBar(tester, brightness: Brightness.dark);
    expect(indicator(tester), visible);
    await tester.pumpAndSettle();
    expect(indicator(tester).center.dx, closeTo(target(tester, '会员购'), .001));
    expect(find.byType(NavigationIndicator), findsOneWidget);
  });

  testWidgets(
    'reduced motion starts and interrupts at the selected destination',
    (tester) async {
      await showBar(tester);
      await tester.tap(find.text('我的'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 70));
      await showBar(tester, reduceMotion: true);
      expect(indicator(tester).center.dx, closeTo(target(tester, '我的'), .001));
      await tester.tap(find.text('动态'));
      await tester.pump();
      expect(indicator(tester).center.dx, closeTo(target(tester, '动态'), .001));
      expect(tester.binding.transientCallbackCount, 0);
    },
  );
  testWidgets(
    'a stretched layout uses actual button centers instead of a fixed travel distance',
    (tester) async {
      await showBar(tester, width: 500, stretch: true);
      final initial = indicator(tester);
      expect(initial.width, 86);
      expect(initial.center.dx, closeTo(target(tester, '首页'), .001));
      await tester.tap(find.text('我的'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 140));
      final distance = target(tester, '我的') - target(tester, '首页');
      expect(
        indicator(tester).center.dx,
        closeTo(
          initial.center.dx + distance * Curves.decelerate.transform(.5),
          .01,
        ),
      );
      await tester.pumpAndSettle();
      expect(indicator(tester).center.dx, closeTo(target(tester, '我的'), .001));
    },
  );
}
