import 'package:PiliPlus/common/widgets/progress_bar/audio_video_progress_bar.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/bottom_control.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class _HoverController extends Fake implements PlPlayerController {
  @override
  bool showHoverPreview = true;
  final positions = <int>[];
  int exits = 0;
  @override
  void updateHoverPreview(int seconds) => positions.add(seconds);
  @override
  void endHoverPreview() => exits++;
}

void main() {
  testWidgets(
    'hover previews without seeking',
    (tester) async {
      final controller = _HoverController();
      var seeks = 0;
      for (final (enabled, total) in [(true, 100), (false, 100), (true, 0)]) {
        controller.showHoverPreview = enabled;
        controller.positions.clear();
        await tester.pumpWidget(
          Center(
            child: SizedBox(
              width: 400,
              child: ProgressBar(
                progress: 12,
                total: total,
                barHeight: 3.5,
                baseBarColor: const Color(0x33000000),
                progressBarColor: const Color(0xFFFFFFFF),
                bufferedBarColor: const Color(0xFFFFFFFF),
                thumbColor: const Color(0xFFFFFFFF),
                thumbGlowColor: const Color(0xFFFFFFFF),
                onSeek: (_) => seeks++,
              ).withPreview(controller, kAlwaysCompleteAnimation),
            ),
          ),
        );
        final track = tester.getRect(find.byType(ProgressBar));
        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        for (final fraction in [0.0, 0.5, 1.0]) {
          await mouse.moveTo(
            Offset(track.left + 1 + 398 * fraction, track.center.dy),
          );
        }
        expect(
          controller.positions.toSet(),
          enabled && total > 0 ? {0, 50, 100} : <int>{},
        );
        expect(
          tester
              .renderObject<RenderProgressBar>(find.byType(ProgressBar))
              .progress,
          12,
        );
        expect(seeks, 0);
        await mouse.moveTo(Offset.zero);
        await mouse.removePointer();
      }
      expect(controller.exits, 2);
    },
  );

  testWidgets('hover previews wait for controls to finish opening', (
    tester,
  ) async {
    final controller = _HoverController();
    final animation = AnimationController(
      vsync: tester,
      duration: const Duration(milliseconds: 100),
    );
    addTearDown(animation.dispose);
    await tester.pumpWidget(
      Center(
        child: SizedBox(
          width: 400,
          height: 200,
          child: Center(
            child: SlideTransition(
              position: animation.drive(
                Tween<Offset>(begin: const Offset(0, 1.2), end: Offset.zero),
              ),
              child: const ProgressBar(
                progress: 12,
                total: 100,
                barHeight: 3.5,
                baseBarColor: Color(0x33000000),
                progressBarColor: Color(0xFFFFFFFF),
                bufferedBarColor: Color(0xFFFFFFFF),
                thumbColor: Color(0xFFFFFFFF),
                thumbGlowColor: Color(0xFFFFFFFF),
              ).withPreview(controller, animation),
            ),
          ),
        ),
      ),
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byType(ProgressBar)));
    expect(controller.positions, isEmpty);

    animation.forward();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(animation.status, AnimationStatus.forward);
    await mouse.moveTo(tester.getCenter(find.byType(ProgressBar)));
    expect(controller.positions, isEmpty);

    await tester.pumpAndSettle();
    expect(animation.status, AnimationStatus.completed);
    await mouse.moveTo(Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byType(ProgressBar)));
    expect(controller.positions, contains(50));

    controller.positions.clear();
    animation.reverse();
    await mouse.moveTo(
      tester.getCenter(find.byType(ProgressBar)) + const Offset(5, 0),
    );
    expect(controller.positions, isEmpty);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(animation.status, AnimationStatus.reverse);
    await mouse.moveTo(tester.getCenter(find.byType(ProgressBar)));
    expect(controller.positions, isEmpty);
    await tester.pumpAndSettle();
    expect(animation.status, AnimationStatus.dismissed);
    await mouse.moveTo(tester.getCenter(find.byType(ProgressBar)));
    expect(controller.positions, isEmpty);
    await mouse.removePointer();
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
