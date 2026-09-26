import 'package:PiliPlus/pages/breeze/breeze_fold.dart';
import 'package:PiliPlus/services/breeze/breeze_rules.dart';
import 'package:PiliPlus/services/breeze/breeze_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'breeze_fold_setup.dart';

void main() {
  setUpBreezeFold();

  testWidgets('folds, expands and follows the whitelist', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BreezeFold(
            kind: BreezeKind.dynamic,
            source: breezeTestRaw,
            raw: () => breezeTestRaw,
            child: const Text('CONTENT'),
          ),
        ),
      ),
    );
    // Prefetched results render folded in the first frame, no collapse.
    expect(find.text('测试UP · 广告 · 90%'), findsOneWidget);
    expect(find.text('CONTENT'), findsNothing);

    await settleBreeze(tester);
    expect(find.text('测试UP · 广告 · 90%'), findsOneWidget);
    expect(find.text('CONTENT'), findsNothing);

    await tester.tap(find.text('展开'));
    await tester.pumpAndSettle();
    expect(find.text('CONTENT'), findsOneWidget);
    expect(find.text('收起'), findsOneWidget);

    final history = BreezeService.history;
    expect(history, hasLength(1));
    expect(history.single['action'], '折叠');
    expect(history.single['authorId'], '123');

    await tester.runAsync(
      () => BreezeService.setListed(BreezeKey.whitelist, '123', add: true),
    );
    await settleBreeze(tester);
    expect(find.text('CONTENT'), findsOneWidget);
    expect(find.textContaining('广告'), findsNothing);
    expect(BreezeService.history.single['rule'], 'whitelist');
  });
}
