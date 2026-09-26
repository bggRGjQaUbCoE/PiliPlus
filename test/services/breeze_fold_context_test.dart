import 'package:PiliPlus/pages/breeze/breeze_fold.dart';
import 'package:PiliPlus/services/breeze/breeze_rules.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'breeze_fold_setup.dart';

void main() {
  setUpBreezeFold();

  testWidgets('judges once missing context arrives for the same item', (
    tester,
  ) async {
    // Like a pinned comment shown before the video's details load: the item
    // stays the same, only its context arrives later.
    BreezeRaw? raw;
    late StateSetter update;
    const source = Object();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return BreezeFold(
                kind: BreezeKind.dynamic,
                source: source,
                raw: () => raw,
                child: const Text('CONTENT'),
              );
            },
          ),
        ),
      ),
    );
    await settleBreeze(tester);
    expect(
      find.text('CONTENT'),
      findsOneWidget,
      reason: 'nothing to judge yet',
    );

    update(() => raw = breezeTestRaw);
    await tester.pump();
    expect(find.text('测试UP · 广告 · 90%'), findsOneWidget);
    expect(find.text('CONTENT'), findsNothing);
    await settleBreeze(tester);
  });
}
