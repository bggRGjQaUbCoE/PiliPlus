import 'package:PiliPlus/pages/video/widgets/page_pull_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('video expansion resizes content while parent stays stable', (
    tester,
  ) async {
    final controller = AnimationController(vsync: const TestVSync());
    addTearDown(controller.dispose);
    const childKey = ValueKey('video');

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 200,
            height: 100,
            child: PagePullVideoExpansion(
              animation: controller,
              normalHeight: 100,
              expandedHeight: 300,
              builder: (context, height) => SizedBox(
                key: childKey,
                width: 200,
                height: height,
              ),
            ),
          ),
        ),
      ),
    );

    final transition = find.byType(PagePullVideoExpansion);
    final initialTop = tester.getTopLeft(find.byKey(childKey));
    expect(tester.getSize(transition), const Size(200, 100));

    controller.value = 0.5;
    await tester.pump();

    expect(tester.getSize(transition), const Size(200, 100));
    expect(tester.getSize(find.byType(ColoredBox)), const Size(200, 200));
    expect(tester.getTopLeft(find.byKey(childKey)).dy, initialTop.dy);
    expect(tester.getSize(find.byKey(childKey)), const Size(200, 200));

    controller.value = 1;
    await tester.pump();

    expect(tester.getSize(transition), const Size(200, 100));
    expect(tester.getSize(find.byKey(childKey)), const Size(200, 300));
  });

  testWidgets('detail panel translation follows the same progress', (
    tester,
  ) async {
    final controller = AnimationController(vsync: const TestVSync());
    addTearDown(controller.dispose);
    const childKey = ValueKey('detail');

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: PagePullBodyTranslation(
            animation: controller,
            travelDistance: 240,
            child: const SizedBox(key: childKey, width: 40, height: 40),
          ),
        ),
      ),
    );

    final initialTop = tester.getTopLeft(find.byKey(childKey));
    controller.value = 0.25;
    await tester.pump();

    expect(tester.getTopLeft(find.byKey(childKey)).dy, initialTop.dy + 60);
  });
}
