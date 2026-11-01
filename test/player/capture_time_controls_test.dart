import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/models/common/sponsor_block/action_type.dart';
import 'package:PiliPlus/models/common/sponsor_block/post_segment_model.dart';
import 'package:PiliPlus/models/common/sponsor_block/segment_type.dart';
import 'package:PiliPlus/pages/video/post_panel/view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  for (final width in [320.0, 720.0]) {
    testWidgets(
      'capture endpoints remain visible and editable at width $width',
      (
        tester,
      ) async {
        tester.view.physicalSize = Size(width, 800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final item = PostSegmentModel(
          segment: Pair(first: 30.7, second: 40.7),
          category: SegmentType.sponsor,
          actionType: ActionType.skip,
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return AlertDialog(
                  title: const Text('动态截图'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 12,
                      children: [
                        PostPanel.segmentWidget(
                          Theme.of(context),
                          item: item,
                          currentPos: () => 35,
                          videoDuration: 100,
                          stepSeconds: 3,
                        ),
                        const Text('选择画质: 360P'),
                        const Text('格式: GIF'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('开始: 00:30.700').hitTestable(), findsOneWidget);
        expect(find.text('结束: 00:40.700').hitTestable(), findsOneWidget);
        expect(find.text('+3').hitTestable(), findsNWidgets(2));
        expect(find.text('−3').hitTestable(), findsNWidgets(2));
        await tester.tap(find.text('+3').first);
        await tester.pump();
        expect(item.segment.first, closeTo(33.7, .000001));
        expect(item.segment.second, closeTo(40.7, .000001));
        expect(find.text('开始: 00:33.700').hitTestable(), findsOneWidget);
      },
    );
  }
  testWidgets(
    'landscape dialog keeps endpoints reachable when content scrolls',
    (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 360);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final item = PostSegmentModel(
        segment: Pair(first: 30.7, second: 40.7),
        category: SegmentType.sponsor,
        actionType: ActionType.skip,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return AlertDialog(
                title: const Text('动态截图'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12,
                    children: [
                      PostPanel.segmentWidget(
                        Theme.of(context),
                        item: item,
                        currentPos: () => 35,
                        videoDuration: 100,
                        stepSeconds: 3,
                      ),
                      const SizedBox(height: 40, child: Text('选择画质: 360P')),
                      const SizedBox(height: 40, child: Text('格式: GIF')),
                      TextButton(onPressed: () {}, child: const Text('框选区域')),
                      const SizedBox(height: 40, child: Text('转码使用 CPU')),
                    ],
                  ),
                ),
                actions: [
                  TextButton(onPressed: () {}, child: const Text('确定')),
                ],
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('开始: 00:30.700').hitTestable(), findsOneWidget);
      await tester.ensureVisible(find.text('框选区域'));
      await tester.pumpAndSettle();
      expect(find.text('框选区域').hitTestable(), findsOneWidget);
      await tester.ensureVisible(find.text('开始: 00:30.700'));
      await tester.pumpAndSettle();
      expect(find.text('开始: 00:30.700').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
