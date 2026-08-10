import 'package:PiliPlus/common/widgets/refresh_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('hidden refresh indicator remains valid for semantics', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final scale = AnimationController(vsync: tester);
    final position = AnimationController(vsync: tester);
    addTearDown(() {
      scale.dispose();
      position.dispose();
    });

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 320,
          height: 640,
          child: RefreshLayout(
            scale: scale,
            position: position,
            displacement: 40,
            indicator: Semantics(
              label: 'refresh indicator',
              child: const SizedBox.expand(),
            ),
            body: const SizedBox.expand(),
          ),
        ),
      ),
    );

    final renderObject = tester.renderObject<RenderRefreshLayout>(
      find.byType(RefreshLayout),
    );
    expect(renderObject.indicator.hasSize, isTrue);
    expect(renderObject.indicator.size, Size.zero);
    expect(tester.takeException(), isNull);

    scale.value = 1;
    position.value = 1;
    await tester.pump();

    expect(renderObject.indicator.size, const Size.square(49));
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });
}
