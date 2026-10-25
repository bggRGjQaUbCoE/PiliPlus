// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:PiliPlus/plugin/pl_player/widgets/playback_diag_sampler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlaybackMetricSnapshot', () {
    test('keeps missing, malformed, and negative metrics unknown', () {
      final sample = PlaybackMetricSnapshot.fromProperties(
        {
          'estimated-vf-fps': 'NaN',
          'frame-drop-count': '-1',
          'decoder-frame-drop-count': 'bad',
        },
        paused: false,
      );

      expect(sample.estimatedFps, '?');
      expect(sample.voDrops, '?');
      expect(sample.decoderDrops, '?');
      expect(sample.displayText, contains('FPS=?'));
    });

    test('shows fps estimate and cumulative drop counters', () {
      final sample = PlaybackMetricSnapshot.fromProperties(
        {
          'estimated-vf-fps': '59.94',
          'frame-drop-count': '12',
          'decoder-frame-drop-count': '3',
        },
        paused: true,
      );

      expect(sample.displayText, 'FPS=暂停 累计丢帧 VO=12 解码=3');
    });
  });

  test(
    'stop cancels polling and prevents stale async results publishing',
    () async {
      final gate = Completer<String>();
      var readCount = 0;
      var publishCount = 0;
      final sampler = PlaybackMetricSampler(
        interval: const Duration(milliseconds: 5),
        readProperty: (_) {
          readCount++;
          return gate.future;
        },
        onSample: (_) => publishCount++,
      );

      sampler.start(paused: false);
      await Future<void>.delayed(const Duration(milliseconds: 1));
      sampler.stop();
      gate.complete('1');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(sampler.isRunning, isFalse);
      expect(readCount, 1);
      expect(publishCount, 0);
      sampler.dispose();
    },
  );

  test(
    'timeout publishes unknown and does not overlap a stuck getter',
    () async {
      final gate = Completer<String>();
      var readCount = 0;
      final samples = <PlaybackMetricSnapshot>[];
      final sampler = PlaybackMetricSampler(
        interval: const Duration(milliseconds: 5),
        propertyTimeout: const Duration(milliseconds: 5),
        readProperty: (_) {
          readCount++;
          return gate.future;
        },
        onSample: samples.add,
      );

      sampler.start(paused: false);
      await Future<void>.delayed(const Duration(milliseconds: 25));

      expect(readCount, 1);
      expect(samples, hasLength(1));
      expect(samples.single.displayText, contains('FPS=?'));
      expect(samples.single.voDrops, '?');
      sampler.stop();
      gate.complete('9');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(samples, hasLength(1));
      sampler.dispose();
    },
  );

  test('dispose prevents a late property result from publishing', () async {
    final gate = Completer<String>();
    var publishCount = 0;
    final sampler = PlaybackMetricSampler(
      interval: const Duration(hours: 1),
      readProperty: (_) => gate.future,
      onSample: (_) => publishCount++,
    );

    sampler.start(paused: false);
    await Future<void>.delayed(const Duration(milliseconds: 1));
    sampler.dispose();
    gate.complete('1');
    await Future<void>.delayed(const Duration(milliseconds: 5));

    expect(publishCount, 0);
    expect(sampler.isRunning, isFalse);
  });

  test('stop then start cannot overlap or publish the stale sample', () async {
    final first = Completer<String>();
    var readCount = 0;
    var publishCount = 0;
    final sampler = PlaybackMetricSampler(
      interval: const Duration(hours: 1),
      readProperty: (_) {
        readCount++;
        return readCount == 1 ? first.future : Future.value('2');
      },
      onSample: (_) => publishCount++,
    );

    sampler.start(paused: false);
    await Future<void>.delayed(const Duration(milliseconds: 1));
    sampler.stop();
    sampler.start(paused: false);
    await Future<void>.delayed(const Duration(milliseconds: 1));
    expect(readCount, 1);
    first.complete('1');
    await Future<void>.delayed(const Duration(milliseconds: 5));
    expect(publishCount, 0);
    sampler.dispose();
  });
}
