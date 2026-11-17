import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:PiliPlus/common/widgets/view_insets_safe_area.dart';

void main() {
  testWidgets(
    'a shared modal sheet avoids the keyboard once even with the existing inset wrapper',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(400, 800);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => ViewInsetsSafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const TextField(autofocus: true),
                        TextButton(onPressed: () {}, child: const Text('确认')),
                      ],
                    ),
                  ),
                ),
                child: const Text('打开输入面板'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开输入面板'));
      await tester.pumpAndSettle();
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();
      final bottom = tester
          .getBottomRight(find.widgetWithText(TextButton, '确认'))
          .dy;
      expect(bottom, lessThanOrEqualTo(500));
      expect(bottom, greaterThan(450));
      tester.view.viewInsets = FakeViewPadding.zero;
      await tester.pumpAndSettle();
      expect(
        tester.getBottomRight(find.widgetWithText(TextButton, '确认')).dy,
        greaterThan(750),
      );
      await tester.pumpWidget(const SizedBox());
    },
  );
  testWidgets('a plain modal sheet keeps its input action above the keyboard', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TextField(autofocus: true),
                    TextButton(onPressed: () {}, child: const Text('确认')),
                  ],
                ),
              ),
              child: const Text('打开面板'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('打开面板'));
    await tester.pumpAndSettle();
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    expect(
      tester.getBottomRight(find.widgetWithText(TextButton, '确认')).dy,
      lessThanOrEqualTo(500),
    );
    await tester.pumpWidget(const SizedBox());
  });
}
