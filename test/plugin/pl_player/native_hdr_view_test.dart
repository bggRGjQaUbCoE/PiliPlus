import 'package:PiliPlus/plugin/pl_player/widgets/native_hdr_view.dart';
import 'package:PiliPlus/utils/android/native_hdr_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final failure in [
    PlatformException(code: 'sync_failed'),
    MissingPluginException('synchronization unavailable'),
  ]) {
    testWidgets('SurfaceView creation is blocked on ${failure.runtimeType}', (
      tester,
    ) async {
      final messenger = tester.binding.defaultBinaryMessenger;
      const host = MethodChannel(NativeHdrPlayer.viewType);
      messenger.setMockMethodCallHandler(host, (_) async => null);
      final player = await NativeHdrPlayer.create(useTexture: false);
      final session = MethodChannel('${NativeHdrPlayer.viewType}/${player.id}');
      final commands = <String>[];
      final synchronization = <bool>[];
      messenger
        ..setMockMethodCallHandler(session, (call) async {
          commands.add(call.method);
          return null;
        })
        ..setMockMethodCallHandler(SystemChannels.platform_views, (call) async {
          expect(call.method, 'synchronizeToNativeViewHierarchy');
          final enabled = call.arguments as bool;
          synchronization.add(enabled);
          if (!enabled) throw failure;
          return null;
        });
      addTearDown(() async {
        await player.dispose();
        messenger
          ..setMockMethodCallHandler(host, null)
          ..setMockMethodCallHandler(session, null)
          ..setMockMethodCallHandler(SystemChannels.platform_views, null);
      });

      await tester.pumpWidget(
        MaterialApp(
          home: NativeHdrView(player: player, width: 320, height: 180),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('切回 mpv'), findsOneWidget);
      expect(find.byType(PlatformViewLink), findsNothing);
      expect(player.surfaceUnavailable, isTrue);
      await player.play();
      await player.retry();
      expect(commands, ['pause']);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      expect(synchronization, [false, true]);
    });
  }
}
