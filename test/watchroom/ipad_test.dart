import 'package:PiliPlus/features/watchroom/model.dart';
import 'package:PiliPlus/features/watchroom/piliplus_adapter.dart';
import 'package:PiliPlus/features/watchroom/session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

class IpadTransport implements RoomTransport {
  final writes = <String>[];

  @override
  Future<Map<String, dynamic>> call(
    String path, {
    bool post = false,
    Map<String, dynamic> parameters = const {},
  }) async {
    if (post) writes.add(path);
    if (path.endsWith('/join') || path.endsWith('/info')) {
      return {
        'room_id': 12345,
        'mid': 7,
        'season_id': 90,
        'episode_id': 91,
        'status': {'status': 1, 'progress': 40},
        'members': [
          {'mid': 7, 'nickname': '放映员'},
          {'mid': 8, 'nickname': '成员'},
        ],
      };
    }
    return {};
  }
}

void main() {
  testWidgets('iPad drawer survives keyboard and narrow window resizing', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1194, 834);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetViewInsets);
    final adapter = WatchroomAdapter.instance;
    final transport = IpadTransport();
    final session = RoomSession(
      transport: transport,
      mid: 8,
      buvid: 'test',
      realtime: false,
    );
    await session.join(const RoomInvite(12345));
    adapter.session = session;
    try {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('zh', 'CN'),
          supportedLocales: const [Locale('zh', 'CN')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => adapter.showSidePanel(context),
                child: const Text('打开面板'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('打开面板'));
      await tester.pumpAndSettle();
      final field = find.byKey(const ValueKey('watchroom-message'));
      await tester.enterText(field, 'iPad 未发送草稿');
      for (final layout in [
        (size: const Size(1194, 834), keyboard: 350.0),
        (size: const Size(375, 700), keyboard: 300.0),
        (size: const Size(744, 1133), keyboard: 360.0),
        (size: const Size(1024, 768), keyboard: 0.0),
      ]) {
        tester.view.physicalSize = layout.size;
        tester.view.viewInsets = FakeViewPadding(bottom: layout.keyboard);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(
          tester.getRect(field).bottom,
          lessThanOrEqualTo(layout.size.height - layout.keyboard),
        );
        expect(find.text('iPad 未发送草稿'), findsOneWidget);
        expect(session.active, isTrue);
        expect(session.room!.playing, isTrue);
      }
      await tester.tap(find.byTooltip('收起放映厅'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('打开面板'));
      await tester.pumpAndSettle();
      expect(find.text('iPad 未发送草稿'), findsOneWidget);
      expect(
        transport.writes.where(
          (path) =>
              path.contains('/modify/') ||
              path.endsWith('/leave') ||
              path.endsWith('/msg/send'),
        ),
        isEmpty,
      );
      await tester.tap(find.byTooltip('收起放映厅'));
      await tester.pumpAndSettle();
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      await session.leave();
      adapter
        ..session = null
        ..chatDraft = '';
    }
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));
}
