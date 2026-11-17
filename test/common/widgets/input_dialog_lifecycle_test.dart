import 'dart:async';

import 'package:PiliPlus/common/widgets/dialog/export_import.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets(
    'input confirmation is single flight and completion cannot pop a newer route',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(400, 800);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      final navigator = GlobalKey<NavigatorState>();
      final pending = Completer<void>();
      var submissions = 0;
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigator,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => importFromInput<Map<String, dynamic>>(
                  context,
                  title: '测试',
                  onImport: (_) {
                    submissions++;
                    return pending.future;
                  },
                ),
                child: const Text('输入'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('输入'));
      await tester.pumpAndSettle();
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();
      expect(
        tester.getBottomRight(find.widgetWithText(TextButton, '确定')).dy,
        lessThanOrEqualTo(500),
      );
      await tester.enterText(find.byType(TextFormField), '{}');
      final confirm = tester
          .widget<TextButton>(find.widgetWithText(TextButton, '确定'))
          .onPressed!;
      confirm();
      confirm();
      await tester.pump();
      expect(submissions, 1);
      navigator.currentState!.pop();
      await tester.pumpAndSettle();
      navigator.currentState!.push(
        MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: Text('新页面')),
        ),
      );
      await tester.pumpAndSettle();
      pending.complete();
      await tester.pumpAndSettle();
      expect(find.text('新页面'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
