import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show SelectedContent;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('rich text preserves raw widget text and placeholder offsets', () {
    const span = TextSpan(
      text: 'before',
      children: <InlineSpan>[
        WidgetSpan(rawText: '[emoji]', child: SizedBox(width: 16, height: 16)),
        TextSpan(text: 'after'),
      ],
    );
    final withPlaceholder = span.toPlainTextV2();
    expect(withPlaceholder.$1, 'before\uFFFCafter');
    expect(withPlaceholder.$2, <int, String>{6: '[emoji]'});
    final withoutPlaceholder = span.toPlainTextV2(includePlaceholders: false);
    expect(withoutPlaceholder.$1, 'beforeafter');
    expect(withoutPlaceholder.$2, isEmpty);
  });

  testWidgets(
    'PageView forwards its custom horizontal gesture factory on OHOS',
    (tester) async {
      var created = 0;
      var page = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: PageView(
            horizontalDragGestureRecognizer: () {
              created++;
              return HorizontalDragGestureRecognizer();
            },
            onPageChanged: (value) => page = value,
            children: const <Widget>[
              Center(child: Text('first')),
              Center(child: Text('second')),
            ],
          ),
        ),
      );
      expect(created, greaterThan(0));
      await tester.drag(find.byType(PageView), const Offset(-650, 0));
      await tester.pumpAndSettle();
      expect(page, 1);
      expect(tester.takeException(), isNull);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.ohos),
  );

  testWidgets(
    'TabBarView forwards its custom horizontal gesture factory',
    (tester) async {
      var created = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                bottom: const TabBar(
                  tabs: <Tab>[
                    Tab(text: 'one'),
                    Tab(text: 'two'),
                  ],
                ),
              ),
              body: TabBarView(
                horizontalDragGestureRecognizer: () {
                  created++;
                  return HorizontalDragGestureRecognizer();
                },
                children: const <Widget>[Text('first'), Text('second')],
              ),
            ),
          ),
        ),
      );
      expect(created, greaterThan(0));
      await tester.drag(find.byType(TabBarView), const Offset(-650, 0));
      await tester.pumpAndSettle();
      final controller = DefaultTabController.of(
        tester.element(find.byType(TabBarView)),
      );
      expect(controller.index, 1);
      expect(tester.takeException(), isNull);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.ohos),
  );

  testWidgets(
    'OHOS selection includes the original raw text of WidgetSpan',
    (tester) async {
      final key = GlobalKey<SelectableRegionState>();
      SelectedContent? content;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectableRegion(
              key: key,
              selectionControls: materialTextSelectionControls,
              onSelectionChanged: (value) => content = value,
              child: const Text.rich(
                TextSpan(
                  text: 'before',
                  children: <InlineSpan>[
                    WidgetSpan(
                      rawText: '[emoji]',
                      child: SizedBox(width: 16, height: 16),
                    ),
                    TextSpan(text: 'after'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      key.currentState!.selectAll(SelectionChangedCause.keyboard);
      await tester.pump();
      expect(content?.plainText, 'before[emoji]after');
      expect(tester.takeException(), isNull);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.ohos),
  );
}
