import 'package:PiliPlus/utils/ios/hwdec_recovery.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState;
import 'package:flutter_test/flutter_test.dart';

void main() {
  late String current;
  late bool playing;
  late int reinits;
  late IOSHwdecRecovery recovery;

  setUp(() {
    current = 'videotoolbox';
    playing = true;
    reinits = 0;
    recovery = IOSHwdecRecovery(
      getCurrent: () => current,
      isPlaying: () => playing,
      reinit: () => reinits++,
    );
  });

  tearDown(() => recovery.dispose());

  void background() {
    recovery
      ..onLifecycleChanged(AppLifecycleState.inactive)
      ..onLifecycleChanged(AppLifecycleState.hidden)
      ..onLifecycleChanged(AppLifecycleState.paused);
  }

  void foreground() {
    recovery
      ..onLifecycleChanged(AppLifecycleState.hidden)
      ..onLifecycleChanged(AppLifecycleState.inactive)
      ..onLifecycleChanged(AppLifecycleState.resumed);
  }

  const longEnough = Duration(seconds: 5);

  testWidgets('restores hardware decoding lost in the background', (
    tester,
  ) async {
    background();
    current = 'no';
    foreground();
    await tester.pump(longEnough);
    expect(reinits, 1);
  });

  testWidgets('catches a fallback that happens after returning', (
    tester,
  ) async {
    background();
    foreground();
    await tester.pump(const Duration(seconds: 2));
    expect(reinits, 0);
    current = 'no';
    await tester.pump(longEnough);
    expect(reinits, 1);
  });

  testWidgets('waits for playback when the player was paused', (tester) async {
    background();
    playing = false;
    current = 'no';
    foreground();
    await tester.pump(longEnough);
    expect(reinits, 0);

    playing = true;
    recovery.onPlaying();
    await tester.pump(longEnough);
    expect(reinits, 1);
  });

  testWidgets('leaves software-only playback alone', (tester) async {
    current = 'no';
    background();
    foreground();
    await tester.pump(longEnough);
    expect(reinits, 0);
  });

  testWidgets('treats nothing loaded as not hardware decoding', (tester) async {
    current = '';
    background();
    current = 'no';
    foreground();
    await tester.pump(longEnough);
    expect(reinits, 0);
  });

  testWidgets('does nothing when hardware decoding survives', (tester) async {
    background();
    foreground();
    await tester.pump(longEnough);
    expect(reinits, 0);

    // A later software fallback is not caused by the background.
    current = 'no';
    recovery.onPlaying();
    await tester.pump(longEnough);
    expect(reinits, 0);
  });

  testWidgets('reinitializes only once per return', (tester) async {
    background();
    current = 'no';
    foreground();
    await tester.pump(longEnough);
    recovery.onPlaying();
    await tester.pump(longEnough);
    expect(reinits, 1);
  });

  testWidgets('recovers again on the next return', (tester) async {
    background();
    current = 'no';
    foreground();
    await tester.pump(longEnough);
    expect(reinits, 1);

    current = 'videotoolbox';
    background();
    current = 'no';
    foreground();
    await tester.pump(longEnough);
    expect(reinits, 2);
  });

  testWidgets('leaving again cancels pending checks', (tester) async {
    background();
    current = 'no';
    foreground();
    current = 'videotoolbox';
    background();
    current = 'no';
    await tester.pump(longEnough);
    expect(reinits, 0);
  });

  testWidgets('dispose cancels pending checks', (tester) async {
    background();
    current = 'no';
    foreground();
    recovery.dispose();
    await tester.pump(longEnough);
    expect(reinits, 0);
  });
}
