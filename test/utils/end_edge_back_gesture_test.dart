// Requires the patched cupertino_ui (lib/scripts/cupertino/end_edge_back_gesture.patch).
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';

const _size = Size(400, 800); // arm distance: 400 * 0.2 = 80

Future<void> _pumpTwoPages(WidgetTester tester) async {
  tester.view
    ..physicalSize = _size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    CupertinoApp(
      home: const Center(child: Text('first')),
      routes: {
        '/second': (_) => const ColoredBox(
          color: Color(0xFFFFFFFF),
          child: Center(child: Text('second')),
        ),
      },
    ),
  );
  tester.state<NavigatorState>(find.byType(Navigator)).pushNamed('/second');
  await tester.pumpAndSettle();
}

/// Left edge of the second page, in global coordinates.
double _secondPageLeft(WidgetTester tester) =>
    tester.getTopLeft(find.byType(ColoredBox).last).dx;

final _indicator = find.byKey(CupertinoEndEdgeBackGesture.indicatorKey);

Future<TestGesture> _dragFromRightEdge(WidgetTester tester, double dx) async {
  final gesture = await tester.startGesture(const Offset(395, 300));
  // small steps, like a finger
  final steps = (dx / 10).ceil();
  for (var i = 0; i < steps; i++) {
    await gesture.moveBy(
      Offset(-dx / steps, 0),
      timeStamp: Duration(milliseconds: 16 * (i + 1)),
    );
    await tester.pump(const Duration(milliseconds: 16));
  }
  return gesture;
}

void main() {
  final armedEvents = <bool>[];

  setUp(() {
    armedEvents.clear();
    CupertinoEndEdgeBackGesture.enabled = true;
    CupertinoEndEdgeBackGesture.onArmedChanged = armedEvents.add;
  });

  tearDown(() {
    CupertinoEndEdgeBackGesture.enabled = false;
    CupertinoEndEdgeBackGesture.onArmedChanged = null;
  });

  testWidgets('像返回一样右移并露出上一页，侧边显示指示器', (tester) async {
    await _pumpTwoPages(tester);
    expect(find.text('first'), findsNothing);

    final gesture = await _dragFromRightEdge(tester, 50);
    expect(find.text('first'), findsOneWidget, reason: 'preview');
    final left = _secondPageLeft(tester);
    expect(left, greaterThan(40), reason: 'same direction as a back swipe');
    expect(left, lessThanOrEqualTo(50));
    expect(_indicator, findsOneWidget);
    expect(armedEvents, isEmpty, reason: 'not armed yet');

    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.text('second'), findsOneWidget, reason: 'not armed: cancel');
    expect(_secondPageLeft(tester), 0);
    expect(_indicator, findsNothing, reason: 'indicator retracts');
  });

  testWidgets('拖过一小段即触发（不用到屏幕中间），松手才返回', (tester) async {
    await _pumpTwoPages(tester);

    final gesture = await _dragFromRightEdge(tester, 90);
    expect(armedEvents, [true]);
    expect(
      find.text('second'),
      findsOneWidget,
      reason: 'no pop before release',
    );
    expect(_secondPageLeft(tester), lessThan(200));

    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.text('second'), findsNothing);
    expect(find.text('first'), findsOneWidget);
    expect(_indicator, findsNothing);
  });

  testWidgets('触发后拖回再松手：取消，并有第二次触感', (tester) async {
    await _pumpTwoPages(tester);

    final gesture = await _dragFromRightEdge(tester, 100);
    for (var i = 0; i < 6; i++) {
      await gesture.moveBy(const Offset(10, 0));
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(armedEvents, [true, false]);
    await tester.pump(const Duration(milliseconds: 200));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.text('second'), findsOneWidget);
    expect(_secondPageLeft(tester), 0);
  });

  testWidgets('触发后快速甩回边缘：取消', (tester) async {
    await _pumpTwoPages(tester);
    // ends at t=192ms, then holds still so the flick is measured on its own
    final gesture = await _dragFromRightEdge(tester, 120);
    for (var i = 1; i <= 4; i++) {
      // 8px every 4ms towards the edge: 2000px/s, still armed (88 > 80)
      await gesture.moveBy(
        const Offset(8, 0),
        timeStamp: Duration(milliseconds: 400 + 4 * i),
      );
    }
    await tester.pump();
    expect(armedEvents, [true], reason: 'still armed when released');
    await gesture.up(timeStamp: const Duration(milliseconds: 418));
    await tester.pumpAndSettle();
    expect(find.text('second'), findsOneWidget);
  });

  testWidgets('关闭开关后右边缘无效，屏幕中间也不触发', (tester) async {
    await _pumpTwoPages(tester);

    CupertinoEndEdgeBackGesture.enabled = false;
    await tester.dragFrom(const Offset(395, 400), const Offset(-200, 0));
    await tester.pumpAndSettle();
    expect(find.text('second'), findsOneWidget);
    expect(_indicator, findsNothing);

    CupertinoEndEdgeBackGesture.enabled = true;
    await tester.dragFrom(const Offset(200, 400), const Offset(-190, 0));
    await tester.pumpAndSettle();
    expect(find.text('second'), findsOneWidget);
    expect(armedEvents, isEmpty);
  });

  testWidgets('原有的左边缘返回不受影响', (tester) async {
    await _pumpTwoPages(tester);
    final gesture = await tester.startGesture(const Offset(5, 400));
    await gesture.moveBy(const Offset(20, 0));
    await gesture.moveBy(const Offset(100, 0));
    await tester.pump();
    expect(_secondPageLeft(tester), greaterThan(0));
    expect(_indicator, findsNothing);
    await gesture.moveBy(const Offset(200, 0));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.text('second'), findsNothing);
    expect(armedEvents, isEmpty);
  });

  testWidgets('打开回复区（底部面板）时：右滑关闭面板，不退出页面', (tester) async {
    await _pumpTwoPages(tester);
    var sheetClosed = false;
    ModalRoute.of(tester.element(find.text('second')))!.addLocalHistoryEntry(
      LocalHistoryEntry(onRemove: () => sheetClosed = true),
    );
    await tester.pump();

    // short swipe: not armed, nothing happens
    var gesture = await _dragFromRightEdge(tester, 40);
    expect(_secondPageLeft(tester), 0, reason: 'the page does not move');
    expect(_indicator, findsOneWidget);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(sheetClosed, isFalse);

    gesture = await _dragFromRightEdge(tester, 100);
    expect(armedEvents, [true]);
    expect(_secondPageLeft(tester), 0);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(sheetClosed, isTrue, reason: 'closes the sheet');
    expect(find.text('second'), findsOneWidget, reason: 'stays on the page');
    expect(_indicator, findsNothing);

    // with the sheet closed, the swipe goes back again
    gesture = await _dragFromRightEdge(tester, 100);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.text('second'), findsNothing);
  });

  testWidgets('首页不能右滑返回', (tester) async {
    tester.view
      ..physicalSize = _size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const CupertinoApp(home: Center(child: Text('first'))),
    );
    await tester.dragFrom(const Offset(395, 400), const Offset(-200, 0));
    await tester.pumpAndSettle();
    expect(find.text('first'), findsOneWidget);
    expect(_indicator, findsNothing);
  });
}
