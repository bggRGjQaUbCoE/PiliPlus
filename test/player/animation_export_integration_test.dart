import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:PiliPlus/plugin/pl_player/models/animated_capture.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/mpv_animation_exporter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';

void main() {
  final library = Platform.environment['CAPTURE_TEST_LIBMPV'];
  final source = Platform.environment['CAPTURE_TEST_VIDEO'];
  test(
    'actual media bundle exports nonzero interval in both formats',
    () async {
      MediaKit.ensureInitialized(libmpv: library);
      expect(
        NativePlayer.test,
        isFalse,
        reason: 'Test mode bypasses the production vid=no default',
      );
      final directory = await Directory.systemTemp.createTemp('capture-test-');
      try {
        for (final format in AnimatedImageFormat.values) {
          final exporter = MpvAnimationExporter(
            AnimatedCaptureRequest(
              url: source!,
              start: 1,
              end: 2,
              format: format,
              region: const CaptureRegion(ui.Rect.fromLTRB(.25, .25, .75, .75)),
            ),
            directory,
          );
          final preview = await exporter.preview().timeout(
            const Duration(seconds: 5),
          );
          final codec = await ui.instantiateImageCodec(
            await preview.readAsBytes(),
          );
          final frame = await codec.getNextFrame();
          expect(frame.image.width, 160);
          expect(frame.image.height, 90);
          frame.image.dispose();
          codec.dispose();
          final file = await exporter.export().timeout(
            const Duration(seconds: 60),
          );
          expect(await file.length(), greaterThan(100));
          final decoded = await ui.instantiateImageCodec(
            await file.readAsBytes(),
          );
          expect(decoded.frameCount, greaterThan(1));
          final first = await decoded.getNextFrame();
          expect(first.image.width, 160);
          expect(first.image.height, 90);
          first.image.dispose();
          decoded.dispose();
        }
      } finally {
        await directory.delete(recursive: true);
      }
    },
    skip: library == null || source == null
        ? 'Set CAPTURE_TEST_LIBMPV and CAPTURE_TEST_VIDEO to test the built bundle'
        : false,
  );
  final skipNative = library == null || source == null;
  test(
    'missing video fails promptly instead of waiting for a timeout',
    () async {
      MediaKit.ensureInitialized(libmpv: library);
      final directory = await Directory.systemTemp.createTemp(
        'capture-missing-',
      );
      final exporter = MpvAnimationExporter(
        AnimatedCaptureRequest(
          url: '${directory.path}/missing.mp4',
          start: 0,
          end: 1,
        ),
        directory,
      );
      try {
        await expectLater(
          exporter.preview(),
          throwsA(isA<CaptureException>()),
        ).timeout(const Duration(seconds: 5));
      } finally {
        exporter.cancel();
        await directory.delete(recursive: true);
      }
    },
    skip: skipNative,
  );

  test('cancellation interrupts waiting for a stalled video request', () async {
    MediaKit.ensureInitialized(libmpv: library);
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final arrived = Completer<void>();
    final subscription = server.listen((_) {
      if (!arrived.isCompleted) arrived.complete();
    });
    final directory = await Directory.systemTemp.createTemp('capture-cancel-');
    final exporter = MpvAnimationExporter(
      AnimatedCaptureRequest(
        url: 'http://127.0.0.1:${server.port}/slow.mp4',
        start: 0,
        end: 1,
      ),
      directory,
    );
    try {
      final result = expectLater(
        exporter.preview(),
        throwsA(isA<CaptureCancelled>()),
      );
      await arrived.future.timeout(const Duration(seconds: 5));
      exporter.cancel();
      await result.timeout(const Duration(seconds: 5));
    } finally {
      exporter.cancel();
      await subscription.cancel();
      await server.close(force: true);
      await directory.delete(recursive: true);
    }
  }, skip: skipNative);

  final ffmpeg = Platform.environment['CAPTURE_TEST_FFMPEG'];
  for (final rotated in [true, false]) {
    test(
      rotated
          ? 'preview uses decoder rotation'
          : 'preview normalizes pixel aspect ratio',
      () async {
        MediaKit.ensureInitialized(libmpv: library);
        final directory = await Directory.systemTemp.createTemp(
          'capture-geometry-',
        );
        try {
          final fixture = '${directory.path}/source.mp4';
          final result = await Process.run(ffmpeg!, [
            '-hide_banner',
            '-loglevel',
            'error',
            '-y',
            if (rotated) ...['-display_rotation', '90'],
            '-i',
            source!,
            if (rotated) ...[
              '-c',
              'copy',
            ] else ...[
              '-vf',
              'setsar=2',
              '-c:v',
              'mpeg4',
            ],
            fixture,
          ]);
          expect(result.exitCode, 0, reason: result.stderr.toString());
          final exporter = MpvAnimationExporter(
            AnimatedCaptureRequest(
              url: fixture,
              start: 1,
              end: 2,
              region: const CaptureRegion(ui.Rect.fromLTRB(.25, .25, .75, .75)),
            ),
            directory,
          );
          final preview = await exporter.preview().timeout(
            const Duration(seconds: 5),
          );
          final codec = await ui.instantiateImageCodec(
            await preview.readAsBytes(),
          );
          final frame = await codec.getNextFrame();
          expect(frame.image.width, rotated ? 90 : 320);
          expect(frame.image.height, rotated ? 160 : 90);
          frame.image.dispose();
          codec.dispose();
        } finally {
          await directory.delete(recursive: true);
        }
      },
      skip: skipNative || ffmpeg == null,
    );
  }

  Future<void> verifyFixedCrop({
    required String video,
    required Directory directory,
    required String label,
    required int frameWidth,
    required int frameHeight,
    ui.Rect rect = const ui.Rect.fromLTRB(.13, .17, .88, .91),
  }) async {
    final ratio = CaptureAspectRatio.values.singleWhere(
      (value) => value.label == label,
    );
    final region = CaptureRegion(rect, aspectRatio: ratio);
    for (final format in AnimatedImageFormat.values) {
      final exporter = MpvAnimationExporter(
        AnimatedCaptureRequest(
          url: video,
          start: 1,
          end: 2,
          format: format,
          region: region,
        ),
        directory,
      );
      try {
        final preview = await exporter.preview().timeout(
          const Duration(seconds: 5),
        );
        final codec = await ui.instantiateImageCodec(
          await preview.readAsBytes(),
        );
        final image = (await codec.getNextFrame()).image;
        final width = image.width;
        final height = image.height;
        image.dispose();
        codec.dispose();
        expect(width, greaterThanOrEqualTo(ratio.numerator));
        expect(height, greaterThanOrEqualTo(ratio.denominator));
        expect(width, lessThanOrEqualTo(frameWidth));
        expect(height, lessThanOrEqualTo(frameHeight));
        expect(
          width * ratio.denominator,
          height * ratio.numerator,
          reason: '$label preview must preserve the exact integer ratio',
        );
        // Check that the UI's advertised dimensions match native filter output.
        final advertised = region.pixels(frameWidth, frameHeight);
        expect(width, advertised.width.toInt());
        expect(height, advertised.height.toInt());
        final output = await exporter.export().timeout(
          const Duration(seconds: 30),
        );
        final decoded = await ui.instantiateImageCodec(
          await output.readAsBytes(),
        );
        final frame = (await decoded.getNextFrame()).image;
        expect(
          frame.width,
          width,
          reason: '${format.label} differs from preview',
        );
        expect(
          frame.height,
          height,
          reason: '${format.label} differs from preview',
        );
        expect(frame.width * ratio.denominator, frame.height * ratio.numerator);
        frame.dispose();
        decoded.dispose();
      } finally {
        exporter.cancel();
      }
    }
  }

  for (final ratio in ['1:1', '4:3', '9:16', '21:9', '16:10']) {
    test(
      'fixed $ratio preserves preview and GIF/WebP output dimensions',
      () async {
        MediaKit.ensureInitialized(libmpv: library);
        expect(NativePlayer.test, isFalse);
        final directory = await Directory.systemTemp.createTemp(
          'capture-fixed-',
        );
        try {
          await verifyFixedCrop(
            video: source!,
            directory: directory,
            label: ratio,
            frameWidth: 320,
            frameHeight: 180,
          );
        } finally {
          await directory.delete(recursive: true);
        }
      },
      skip: skipNative,
    );
  }

  test('a small fixed crop exports a nonempty exact-ratio image', () async {
    MediaKit.ensureInitialized(libmpv: library);
    final directory = await Directory.systemTemp.createTemp('capture-small-');
    try {
      await verifyFixedCrop(
        video: source!,
        directory: directory,
        label: '16:10',
        frameWidth: 320,
        frameHeight: 180,
        rect: const ui.Rect.fromLTRB(.45, .45, .49, .49),
      );
    } finally {
      await directory.delete(recursive: true);
    }
  }, skip: skipNative);

  for (final geometry in [
    'low-resolution',
    'high-resolution',
    'rotation',
    'pixel-aspect',
    'fractional-pixel-aspect',
  ]) {
    test('fixed ratio survives $geometry in GIF and WebP', () async {
      MediaKit.ensureInitialized(libmpv: library);
      final directory = await Directory.systemTemp.createTemp(
        'capture-fixed-source-',
      );
      try {
        final video = '${directory.path}/source.mp4';
        final result = await Process.run(ffmpeg!, [
          '-hide_banner',
          '-loglevel',
          'error',
          '-y',
          if (geometry == 'rotation') ...['-display_rotation', '90'],
          '-i',
          source!,
          if (geometry == 'rotation') ...[
            '-c',
            'copy',
          ] else ...[
            '-vf',
            switch (geometry) {
              'low-resolution' => 'scale=160:90,setsar=1',
              'high-resolution' => 'scale=640:360,setsar=1',
              'fractional-pixel-aspect' => 'scale=321:180,setsar=1/3',
              _ => 'setsar=2',
            },
            '-c:v',
            'mpeg4',
          ],
          video,
        ]);
        expect(result.exitCode, 0, reason: result.stderr.toString());
        final size = switch (geometry) {
          'low-resolution' => (160, 90),
          'high-resolution' => (640, 360),
          'rotation' => (180, 320),
          'fractional-pixel-aspect' => (107, 180),
          _ => (640, 180),
        };
        await verifyFixedCrop(
          video: video,
          directory: directory,
          label: geometry == 'rotation' ? '9:16' : '16:10',
          frameWidth: size.$1,
          frameHeight: size.$2,
        );
      } finally {
        await directory.delete(recursive: true);
      }
    }, skip: skipNative || ffmpeg == null);
  }
}
