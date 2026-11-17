import 'package:PiliPlus/pages/common/fab_mixin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

class _Host extends StatefulWidget {
  const _Host({super.key, this.reduce = false, this.nested = false});
  final bool reduce;
  final bool nested;
  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host>
    with SingleTickerProviderStateMixin, BaseFabMixin, FabMixin {
  late BuildContext sender;
  int taps = 0;
  int childBuilds = 0;
  @override
  Widget build(BuildContext context) => MediaQuery(
    data: MediaQuery.of(context).copyWith(disableAnimations: widget.reduce),
    child: Builder(
      builder: (context) => Scaffold(
        body: fabAnimWrapper(
          child: widget.nested
              ? NestedScrollView(
                  headerSliverBuilder: (_, _) => const [
                    SliverAppBar(expandedHeight: 120, title: Text('页面标题')),
                  ],
                  body: ListView.builder(
                    itemExtent: 80,
                    itemCount: 100,
                    itemBuilder: (_, i) => Text('内容 $i'),
                  ),
                )
              : Builder(
                  builder: (context) {
                    sender = context;
                    return const SizedBox.expand();
                  },
                ),
        ),
        floatingActionButton: fabTransition(
          child: Builder(
            builder: (context) {
              childBuilds++;
              return FloatingActionButton(
                onPressed: () => taps++,
                child: const Text('回复'),
              );
            },
          ),
        ),
      ),
    ),
  );
  // The mixin reads this State's MediaQuery, so the test also configures the root.
  void update(
    double delta, {
    AxisDirection axis = AxisDirection.down,
    bool user = true,
    double pixels = 100,
  }) {
    ScrollUpdateNotification(
      metrics: FixedScrollMetrics(
        minScrollExtent: 0,
        maxScrollExtent: 2000,
        pixels: pixels,
        viewportDimension: 500,
        axisDirection: axis,
        devicePixelRatio: 1,
      ),
      context: sender,
      scrollDelta: delta,
      dragDetails: user
          ? DragUpdateDetails(
              globalPosition: Offset.zero,
              delta: Offset(0, -delta),
              primaryDelta: -delta,
            )
          : null,
    ).dispatch(sender);
  }

  void end({double pixels = 100}) => ScrollEndNotification(
    metrics: FixedScrollMetrics(
      minScrollExtent: 0,
      maxScrollExtent: 2000,
      pixels: pixels,
      viewportDimension: 500,
      axisDirection: AxisDirection.down,
      devicePixelRatio: 1,
    ),
    context: sender,
  ).dispatch(sender);
}

void main() {
  late GlobalKey<_HostState> key;
  setUp(() => key = GlobalKey<_HostState>());
  Future<void> start(
    WidgetTester tester, {
    bool reduce = false,
    bool nested = false,
  }) => tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reduce),
        child: _Host(key: key, reduce: reduce, nested: nested),
      ),
    ),
  );
  testWidgets(
    'nested page scrolling hides actions without flashing on small reverse gestures',
    (tester) async {
      await start(tester, nested: true);
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();
      expect(key.currentState!.fabAnimationCtr.value, 1);
      await tester.drag(find.byType(ListView), const Offset(0, 20));
      await tester.pumpAndSettle();
      expect(key.currentState!.fabAnimationCtr.value, 1);
      await tester.drag(find.byType(ListView), const Offset(0, 140));
      await tester.pumpAndSettle();
      expect(key.currentState!.fabAnimationCtr.value, 0);
    },
  );
  testWidgets(
    'horizontal lists and minor direction changes do not toggle the floating action',
    (tester) async {
      await start(tester);
      key.currentState!.update(200, axis: AxisDirection.right);
      key.currentState!.update(-200, axis: AxisDirection.right);
      for (final delta in [8.0, -6.0, 7.0, -10.0]) {
        key.currentState!.update(delta);
      }
      await tester.pumpAndSettle();
      expect(key.currentState!.fabAnimationCtr.value, 0);
      await tester.tap(find.text('回复'));
      expect(key.currentState!.taps, 1);
    },
  );
  testWidgets(
    'downward intent hides; small upward motion and stopping do not make it pop back',
    (tester) async {
      await start(tester);
      key.currentState!
        ..update(12)
        ..update(12);
      await tester.pumpAndSettle();
      expect(key.currentState!.fabAnimationCtr.value, 1);
      key.currentState!
        ..update(-20)
        ..end();
      await tester.pumpAndSettle();
      expect(key.currentState!.fabAnimationCtr.value, 1);
      key.currentState!
        ..update(-24)
        ..update(-24);
      await tester.pumpAndSettle();
      expect(key.currentState!.fabAnimationCtr.value, 0);
    },
  );
  testWidgets(
    'programmatic updates do not hide actions and reaching the top restores them',
    (tester) async {
      await start(tester);
      key.currentState!.update(100, user: false);
      await tester.pumpAndSettle();
      expect(key.currentState!.fabAnimationCtr.value, 0);
      key.currentState!.update(60);
      await tester.pumpAndSettle();
      expect(key.currentState!.fabAnimationCtr.value, 1);
      key.currentState!.end(pixels: 0);
      await tester.pumpAndSettle();
      expect(key.currentState!.fabAnimationCtr.value, 0);
    },
  );
  testWidgets(
    'hiding actions cannot intercept taps and animation does not rebuild their material',
    (tester) async {
      await start(tester);
      final builds = key.currentState!.childBuilds;
      key.currentState!.update(30);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 90));
      final ignore = find
          .ancestor(of: find.text('回复'), matching: find.byType(IgnorePointer))
          .first;
      expect(tester.widget<IgnorePointer>(ignore).ignoring, isTrue);
      await tester.tap(find.text('回复'), warnIfMissed: false);
      expect(key.currentState!.taps, 0);
      await tester.pumpAndSettle();
      expect(key.currentState!.childBuilds, builds);
    },
  );
  testWidgets(
    'rapid reversal continues from visible position; reduced motion reaches the target directly',
    (tester) async {
      await start(tester);
      key.currentState!.hideFab();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 70));
      final visible = key.currentState!.fabAnimation.value;
      key.currentState!.showFab();
      expect(key.currentState!.fabAnimation.value, visible);
      await tester.pumpAndSettle();
      expect(key.currentState!.fabAnimationCtr.value, 0);
      await start(tester, reduce: true);
      key.currentState!.hideFab();
      expect(key.currentState!.fabAnimationCtr.value, 1);
      key.currentState!.showFab();
      expect(key.currentState!.fabAnimationCtr.value, 0);
    },
  );
}
