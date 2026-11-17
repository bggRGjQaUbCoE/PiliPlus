import 'dart:io';

import 'package:PiliPlus/pages/common/common_page.dart';
import 'package:PiliPlus/common/widgets/sliver/sliver_floating_header.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

class _Shell extends MainController {
  _Shell({this.sync = false});
  final bool sync;
  @override
  // No network/polling in the shell fixture.
  // ignore: must_call_super
  void onInit() {
    useBottomNav = true;
    showBottomBar = true.obs;
    if (sync) barOffset = 0.0.obs;
  }

  @override
  // ignore: must_call_super
  void onClose() {}
}

class _Account extends AccountService {
  @override
  // ignore: must_call_super
  void onInit() {}
}

class _Page extends StatefulWidget {
  const _Page({super.key});
  @override
  State<_Page> createState() => _PageState();
}

class _PageState extends CommonPageState<_Page> {
  final scroll = ScrollController();
  void drag(List<double> deltas, {VoidCallback? afterUpdate}) {
    final drag = scroll.position.drag(
      DragStartDetails(globalPosition: const Offset(100, 300)),
      () {},
    );
    for (final delta in deltas) {
      drag.update(
        DragUpdateDetails(
          globalPosition: const Offset(100, 300),
          delta: Offset(0, -delta),
          primaryDelta: -delta,
        ),
      );
      afterUpdate?.call();
    }
    drag.end(DragEndDetails(primaryVelocity: 0));
  }

  @override
  Widget build(BuildContext context) => onBuild(
    ListView.builder(
      controller: scroll,
      itemExtent: 80,
      itemCount: 100,
      itemBuilder: (_, i) => Text('内容 $i'),
    ),
  );
  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }
}

void main() {
  late Directory temp;
  setUpAll(() async {
    temp = await Directory.systemTemp.createTemp('piliplus-scroll-');
    Hive.init(temp.path);
    GStorage.setting = await Hive.openBox('setting');
  });
  tearDownAll(() async {
    await Hive.close();
    await temp.delete(recursive: true);
  });
  tearDown(Get.reset);

  testWidgets(
    'floating list headers do not reappear for a small reverse drag',
    (tester) async {
      final scroll = ScrollController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              controller: scroll,
              slivers: [
                const SliverFloatingHeaderWidget(
                  backgroundColor: Colors.white,
                  child: SizedBox(height: 80, child: Text('筛选')),
                ),
                SliverList.builder(
                  itemCount: 100,
                  itemBuilder: (_, i) =>
                      SizedBox(height: 80, child: Text('结果 $i')),
                ),
              ],
            ),
          ),
        ),
      );
      scroll.jumpTo(400);
      await tester.pumpAndSettle();
      final drag =
          scroll.position.drag(
            DragStartDetails(globalPosition: const Offset(100, 300)),
            () {},
          )..update(
            DragUpdateDetails(
              globalPosition: const Offset(100, 300),
              delta: const Offset(0, 12),
              primaryDelta: 12,
            ),
          );
      await tester.pump();
      final render = tester.renderObject<RenderSliverFloatingHeader>(
        find.byType(SliverFloatingHeaderWidget, skipOffstage: false),
      );
      expect(render.geometry!.paintExtent, 0);
      drag.update(
        DragUpdateDetails(
          globalPosition: const Offset(100, 300),
          delta: const Offset(0, 48),
          primaryDelta: 48,
        ),
      );
      await tester.pump();
      expect(render.geometry!.paintExtent, greaterThan(0));
      drag.end(DragEndDetails(primaryVelocity: 0));
      await tester.pumpAndSettle();
      scroll.jumpTo(0);
      await tester.pumpAndSettle();
      expect(render.geometry!.paintExtent, 80);
      await tester.pumpWidget(const SizedBox());
      scroll.dispose();
    },
  );

  testWidgets(
    'synchronous bars ignore jitter, keep their position on short reversal, and restore on resume',
    (tester) async {
      Get.put<AccountService>(_Account());
      final shell = Get.put<MainController>(_Shell(sync: true));
      final key = GlobalKey<_PageState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: _Page(key: key)),
        ),
      );
      key.currentState!.drag([
        8,
        -6,
        7,
        -10,
      ], afterUpdate: () => expect(shell.barOffset!.value, 0));
      key.currentState!.drag([100]);
      await tester.pumpAndSettle();
      final hidden = shell.barOffset!.value;
      expect(hidden, greaterThan(0));
      key.currentState!.drag([-12]);
      await tester.pumpAndSettle();
      expect(shell.barOffset!.value, hidden);
      final offset = key.currentState!.scroll.offset;
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(shell.barOffset!.value, 0);
      expect(key.currentState!.scroll.offset, offset);
    },
  );

  testWidgets(
    'tiny reverse gestures do not reveal shell bars; deliberate reverse and top do',
    (tester) async {
      Get.put<AccountService>(_Account());
      final shell = Get.put<MainController>(_Shell());
      final key = GlobalKey<_PageState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: _Page(key: key)),
        ),
      );
      key.currentState!.drag([80]);
      await tester.pumpAndSettle();
      expect(shell.showBottomBar!.value, isFalse);
      key.currentState!.drag([-12]);
      await tester.pumpAndSettle();
      expect(shell.showBottomBar!.value, isFalse);
      key.currentState!.drag([-24, -24]);
      await tester.pumpAndSettle();
      expect(shell.showBottomBar!.value, isTrue);
      key.currentState!.drag([80]);
      await tester.pumpAndSettle();
      key.currentState!.scroll.jumpTo(0);
      await tester.pumpAndSettle();
      expect(shell.showBottomBar!.value, isTrue);
      shell.showBottomBar!.value = false;
      final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
      OverscrollNotification(
        metrics: scrollable.position,
        context: scrollable.context,
        overscroll: -8,
        dragDetails: DragUpdateDetails(globalPosition: const Offset(100, 300)),
      ).dispatch(scrollable.context);
      expect(shell.showBottomBar!.value, isTrue);
    },
  );
}
