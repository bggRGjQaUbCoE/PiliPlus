import 'package:PiliPlus/models_new/pgc/pgc_info_model/result.dart';
import 'package:PiliPlus/features/watchroom/model.dart';
import 'package:PiliPlus/features/watchroom/session.dart';
import 'package:PiliPlus/features/watchroom/panel.dart';
import 'package:PiliPlus/features/watchroom/piliplus_adapter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

class PanelTransport implements RoomTransport {
  final writes = <String>[];
  @override
  Future<Map<String, dynamic>> call(
    String path, {
    bool post = false,
    Map<String, dynamic> parameters = const {},
  }) async {
    if (post) writes.add(path);
    if (path.endsWith('/join') || path.endsWith('/info'))
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
    if (path.endsWith('/msg/send')) return {'id': 'message-1'};
    return {};
  }
}

Widget app(Widget child) => MaterialApp(
  locale: const Locale('zh', 'CN'),
  supportedLocales: const [Locale('zh', 'CN')],
  localizationsDelegates: GlobalMaterialLocalizations.delegates,
  home: Scaffold(body: child),
);

void main() {
  testWidgets('copy invitation succeeds without a Scaffold', (tester) async {
    final room = RoomSession(
      transport: PanelTransport(),
      mid: 8,
      buvid: 'test',
      realtime: false,
    );
    await room.join(const RoomInvite(12345));
    var copies = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: WatchroomPanel(
          session: room,
          copyInvitation: () async {
            copies++;
          },
        ),
      ),
    );
    await tester.tap(find.byTooltip('邀请好友'));
    await tester.pump();
    expect(copies, 1);
    expect(find.text('邀请链接已复制'), findsOneWidget);
    expect(tester.takeException(), isNull);
    expect(room.active, isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
    await room.leave();
  });

  testWidgets('typing into room chat bypasses video keyboard shortcuts', (
    tester,
  ) async {
    final room = RoomSession(
      transport: PanelTransport(),
      mid: 8,
      buvid: 'test',
      realtime: false,
    );
    await room.join(const RoomInvite(12345));
    var shortcuts = 0;
    await tester.pumpWidget(
      app(
        Focus(
          onKeyEvent: (_, event) {
            if (WatchroomAdapter.textInputHasFocus())
              return KeyEventResult.ignored;
            if (event is KeyDownEvent) shortcuts++;
            return KeyEventResult.ignored;
          },
          child: WatchroomPanel(session: room),
        ),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('watchroom-message')));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(shortcuts, 0);
    expect(WatchroomAdapter.textInputHasFocus(), isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
    await room.leave();
  });

  test(
    'official room visibility is separate from ordinary playback rights',
    () {
      expect(
        PgcInfoModel.fromJson({
          'freya': {'icon_show': 1},
          'rights': {'freya_white': 0},
        }).supportsWatchroom,
        isTrue,
      );
      expect(
        PgcInfoModel.fromJson({
          'freya': {'icon_show': 0},
        }).supportsWatchroom,
        isFalse,
      );
      expect(
        PgcInfoModel.fromJson({
          'rights': {'can_watch': 1},
        }).supportsWatchroom,
        isNull,
      );
    },
  );

  for (final size in [
    const Size(390, 700),
    const Size(400, 320),
    const Size(420, 220),
    const Size(320, 720),
    const Size(600, 500),
    const Size(1280, 720),
  ]) {
    testWidgets('room content fits $size without player navigation controls', (
      tester,
    ) async {
      tester.view.resetPhysicalSize();
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final room = RoomSession(
        transport: PanelTransport(),
        mid: 8,
        buvid: 'test',
        realtime: false,
      );
      await room.join(const RoomInvite(12345));
      await tester.pumpWidget(app(WatchroomPanel(session: room)));
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.text('打开原生播放器'), findsNothing);
      expect(find.text('邀请链接或房间号'), findsNothing);
      expect(find.byTooltip('邀请好友'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await room.leave();
    });
  }

  testWidgets('sending a chat message preserves membership and follow state', (
    tester,
  ) async {
    final transport = PanelTransport();
    final room = RoomSession(
      transport: transport,
      mid: 8,
      buvid: 'test',
      realtime: false,
    );
    await room.join(const RoomInvite(12345));
    await tester.pumpWidget(app(WatchroomPanel(session: room)));
    await tester.enterText(
      find.byKey(const ValueKey('watchroom-message')),
      '测试消息',
    );
    await tester.tap(find.byTooltip('发送'));
    await tester.pump();
    expect(transport.writes, contains('pgc/freya/web/im/msg/send'));
    expect(room.active, isTrue);
    expect(room.followHost, isTrue);
    expect(room.room!.playing, isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
    await room.leave();
  });

  testWidgets('closing fullscreen room drawer keeps membership and its draft', (
    tester,
  ) async {
    final adapter = WatchroomAdapter.instance;
    final room = RoomSession(
      transport: PanelTransport(),
      mid: 8,
      buvid: 'test',
      realtime: false,
    );
    await room.join(const RoomInvite(12345));
    adapter.session = room;
    await tester.pumpWidget(
      app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => adapter.showSidePanel(context),
            child: const Text('放映厅'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('放映厅'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('watchroom-message')),
      '未发送的消息',
    );
    await tester.tap(find.byTooltip('收起放映厅'));
    await tester.pumpAndSettle();
    expect(room.active, isTrue);
    expect(room.room!.playing, isTrue);
    await tester.tap(find.text('放映厅'));
    await tester.pumpAndSettle();
    expect(find.text('未发送的消息'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('收起放映厅'));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox.shrink());
    await room.leave();
    adapter.session = null;
    adapter.chatDraft = '';
  });

  testWidgets(
    'Escape dismisses the desktop room drawer and preserves its draft',
    (tester) async {
      final adapter = WatchroomAdapter.instance;
      final room = RoomSession(
        transport: PanelTransport(),
        mid: 8,
        buvid: 'test',
        realtime: false,
      );
      await room.join(const RoomInvite(12345));
      adapter.session = room;
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => adapter.showSidePanel(context),
              child: const Text('放映厅'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('放映厅'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('watchroom-message')),
        '桌面未发送草稿',
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('watchroom-message')), findsNothing);
      expect(room.active, isTrue);
      expect(room.room!.playing, isTrue);
      expect(adapter.chatDraft, '桌面未发送草稿');
      await tester.pumpWidget(const SizedBox.shrink());
      await room.leave();
      adapter.session = null;
      adapter.chatDraft = '';
    },
  );
}
