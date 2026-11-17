import 'package:PiliPlus/common/widgets/scroll_intent.dart';
import 'package:PiliPlus/common/widgets/main_layout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  for (final animate in [false, true]) {
    testWidgets(
      'partial navigation accepts visible taps, fully hidden releases body $animate',
      (tester) async {
        final offset = ValueNotifier(0.0);
        var navTaps = 0, bodyTaps = 0;
        double? visibleFraction;
        await tester.pumpWidget(
          MaterialApp(
            home: SizedBox.expand(
              child: MainLayout(
                sideBar: null,
                body: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => bodyTaps++,
                  child: const SizedBox.expand(),
                ),
                bottomNav: ValueListenableBuilder<double>(
                  valueListenable: offset,
                  builder: (_, value, _) => ScrollLinkedNavigation(
                    offset: value,
                    animate: animate,
                    onVisibilityChanged: (value) => visibleFraction = value,
                    child: SizedBox(
                      key: const ValueKey('bar'),
                      width: 320,
                      height: 80,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => navTaps++,
                        child: const Text('navigation'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        final screen = tester.getSize(find.byType(MainLayout));
        offset.value = animate ? 1 : .5;
        await tester.pump();
        if (animate) await tester.pump(const Duration(milliseconds: 90));
        final rect = tester.getRect(find.byKey(const ValueKey('bar')));
        expect(rect.top, greaterThan(screen.height - 80));
        expect(rect.top, lessThan(screen.height));
        expect(visibleFraction, closeTo((screen.height - rect.top) / 80, .001));
        await tester.tapAt(
          Offset(rect.center.dx, (rect.top + screen.height) / 2),
        );
        expect(navTaps, 1);
        offset.value = 1;
        await tester.pumpAndSettle();
        await tester.tapAt(Offset(rect.center.dx, screen.height - 10));
        expect(navTaps, 1);
        expect(bodyTaps, 1);
        expect(visibleFraction, 0);
        offset.value = 0;
        await tester.pump();
        if (animate) await tester.pump(const Duration(milliseconds: 90));
        final showing = tester.getRect(find.byKey(const ValueKey('bar')));
        await tester.tapAt(
          Offset(showing.center.dx, (showing.top + screen.height) / 2),
        );
        expect(navTaps, 2);
        offset.dispose();
      },
    );
  }
}
