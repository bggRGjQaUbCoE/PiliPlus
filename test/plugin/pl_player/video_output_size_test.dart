import 'dart:async';

import 'package:PiliPlus/plugin/pl_player/utils/video_output_size.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const source = Size(3840, 2160);

  Size? output({
    Size input = source,
    Size viewport = const Size(640, 360),
    double pixelRatio = 3,
    BoxFit fit = BoxFit.contain,
    double? aspectRatio,
    double scale = 1,
  }) => videoOutputSize(
    source: input,
    viewport: viewport,
    devicePixelRatio: pixelRatio,
    fit: fit,
    aspectRatio: aspectRatio,
    scale: scale,
  );

  group('physical output size', () {
    test('uses physical pixels for small-window output', () {
      expect(output(), const Size(1920, 1080));
      expect(output(pixelRatio: 2), const Size(1280, 720));
    });

    test('letterboxing uses the video area, not the entire viewport', () {
      expect(output(viewport: const Size(640, 640)), const Size(1920, 1080));
    });

    test('cover preserves resolution in the visible cropped region', () {
      expect(
        output(viewport: const Size(640, 640), fit: BoxFit.cover),
        const Size(3414, 1920),
      );
      expect(
        output(viewport: const Size(640, 640), fit: BoxFit.fitWidth),
        const Size(1920, 1080),
      );
      expect(
        output(viewport: const Size(640, 640), fit: BoxFit.fitHeight),
        const Size(3414, 1920),
      );
    });

    test('stretching and forced aspect ratio keep enough pixels on both axes', () {
      expect(
        output(viewport: const Size(640, 640), fit: BoxFit.fill),
        const Size(3414, 1920),
      );
      expect(
        output(viewport: const Size(640, 480), aspectRatio: 4 / 3),
        const Size(2560, 1440),
      );
    });

    test('zoom increases resolution and caps at source size', () {
      expect(output(scale: 1.5), const Size(2880, 1620));
      expect(output(scale: 2), source);
      expect(output(scale: 4), source);
      expect(output(viewport: const Size(1920, 1080)), source);
    });

    test('none and scaleDown preserve their original fitting semantics', () {
      expect(output(fit: BoxFit.none), source);
      expect(output(fit: BoxFit.scaleDown), const Size(1920, 1080));
      expect(
        output(input: const Size(640, 360), fit: BoxFit.scaleDown),
        const Size(640, 360),
      );
    });

    test('portrait source and rotated viewport keep aspect ratio', () {
      expect(
        output(input: const Size(2160, 3840), viewport: const Size(360, 640)),
        const Size(1080, 1920),
      );
      expect(
        output(input: const Size(2160, 3840)),
        const Size(608, 1080),
      );
    });

    test('invalid or temporarily unbounded layout does not resize', () {
      expect(output(viewport: Size.zero), isNull);
      expect(output(viewport: const Size(double.infinity, 360)), isNull);
      expect(output(input: Size.zero), isNull);
      expect(output(pixelRatio: 0), isNull);
      expect(output(scale: double.nan), isNull);
    });
  });

  group('native resize scheduling', () {
    const small = Size(1920, 1080);
    const large = Size(2880, 1620);

    testWidgets('coalesces layout changes and does not resize on every rebuild',
        (tester) async {
      final sent = <Size>[];
      final controller = VideoOutputResize(
        resize: (size) async {
          sent.add(size);
        },
        onError: (error, stack) => fail('$error'),
      );
      addTearDown(controller.dispose);

      controller.request(small);
      await tester.pump(const Duration(milliseconds: 60));
      controller.request(large);
      await tester.pump(const Duration(milliseconds: 60));
      expect(sent, isEmpty);
      await tester.pump(VideoOutputResize.delay);
      expect(sent, [large]);

      controller.outputChanged(large);
      controller.request(large);
      await tester.pump(VideoOutputResize.delay);
      expect(sent, [large]);

      // The media-kit videoParams listener overwrites the native dimensions,
      // even though the last requested viewport size hasn't changed.
      controller.outputChanged(source);
      await tester.pump(VideoOutputResize.delay);
      expect(sent, [large, large]);
    });

    testWidgets('serializes requests while an earlier native call is pending',
        (tester) async {
      final sent = <Size>[];
      final first = Completer<void>();
      final controller = VideoOutputResize(
        resize: (size) {
          sent.add(size);
          return sent.length == 1 ? first.future : Future<void>.value();
        },
        onError: (error, stack) => fail('$error'),
      );
      addTearDown(controller.dispose);

      controller.request(small);
      await tester.pump(VideoOutputResize.delay);
      controller.request(large);
      await tester.pump(VideoOutputResize.delay);
      expect(sent, [small]);
      first.complete();
      await tester.pump();
      expect(sent, [small, large]);
    });

    testWidgets('disposal cancels delayed work', (tester) async {
      final sent = <Size>[];
      final controller = VideoOutputResize(
        resize: (size) async {
          sent.add(size);
        },
        onError: (error, stack) => fail('$error'),
      );
      controller.request(small);
      controller.dispose();
      await tester.pump(VideoOutputResize.delay);
      controller.outputChanged(source);
      controller.request(large);
      await tester.pump(VideoOutputResize.delay);
      expect(sent, isEmpty);
    });

    testWidgets('hidden surfaces stop resizing and resume with the latest layout',
        (tester) async {
      final sent = <Size>[];
      final controller = VideoOutputResize(
        resize: (size) async {
          sent.add(size);
        },
        onError: (error, stack) => fail('$error'),
      );
      addTearDown(controller.dispose);
      controller.request(small);
      controller.suspend();
      controller.outputChanged(source);
      await tester.pump(VideoOutputResize.delay);
      expect(sent, isEmpty);
      controller.request(large);
      await tester.pump(VideoOutputResize.delay);
      expect(sent, [large]);
    });

    testWidgets('disposal drops a queued resize during a native call',
        (tester) async {
      final sent = <Size>[];
      final first = Completer<void>();
      final controller = VideoOutputResize(
        resize: (size) {
          sent.add(size);
          return first.future;
        },
        onError: (error, stack) => fail('$error'),
      );
      controller.request(small);
      await tester.pump(VideoOutputResize.delay);
      controller.request(large);
      await tester.pump(VideoOutputResize.delay);
      controller.dispose();
      first.complete();
      await tester.pump();
      expect(sent, [small]);
    });
    testWidgets('reports native errors without an unbounded retry loop',
        (tester) async {
      var attempts = 0;
      final errors = <Object>[];
      final controller = VideoOutputResize(
        resize: (size) async {
          attempts++;
          throw StateError('native output unavailable');
        },
        onError: (error, stack) => errors.add(error),
      );
      addTearDown(controller.dispose);
      controller.request(small);
      await tester.pump(VideoOutputResize.delay);
      await tester.pump(const Duration(seconds: 1));
      expect(attempts, 1);
      expect(errors, hasLength(1));
    });
  });
}
