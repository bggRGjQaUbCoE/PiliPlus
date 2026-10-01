import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:PiliPlus/pages/setting/pages/streaming_accelerator.dart';
import 'package:PiliPlus/services/video_accelerator/accelerator_config.dart';

void main() {
  testWidgets('settings default OFF; selection is persisted through callback', (
    tester,
  ) async {
    var selected = AcceleratorMode.off;
    await tester.pumpWidget(
      MaterialApp(
        home: StreamingAcceleratorPage(
          mode: selected,
          onChanged: (mode) async {
            selected = mode;
          },
        ),
      ),
    );
    expect(find.text('关闭 / OFF'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
    await tester.tap(find.text('CDN 优选 / Smart CDN'));
    await tester.pumpAndSettle();
    expect(selected, AcceleratorMode.smartCdn);
    await tester.tap(find.text('本地 Range 代理 / Proxy（实验，单连接）'));
    await tester.pumpAndSettle();
    expect(selected, AcceleratorMode.rangeProxy);
    final futureModes = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .where(
          (tile) =>
              tile.title is Text &&
              (tile.title as Text).data!.contains('Multi-'),
        );
    expect(
      futureModes.every((tile) => !tile.enabled && tile.onTap == null),
      isTrue,
    );
  });
}
