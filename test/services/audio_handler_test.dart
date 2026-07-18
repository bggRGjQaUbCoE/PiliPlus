import 'package:PiliPlus/models_new/video/video_detail/page.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/services/audio_handler.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'dedicated audio publishes media, playback, and position without PlPlayer',
    () {
      final handler = VideoPlayerServiceHandler(enableBackgroundPlay: true)
        ..clear()
        ..onVideoDetailChange(
          Part(cid: 2, part: 'audio title', duration: 90),
          2,
          'audio-owner',
          artist: 'artist',
          cover: '',
        )
        ..onStatusChange(
          PlayerStatus.playing,
          false,
          false,
          mediaOwnerTag: 'audio-owner',
        )
        ..onPositionChange(
          const Duration(seconds: 12),
          mediaOwnerTag: 'audio-owner',
        );

      expect(handler.mediaItem.value?.title, 'audio title');
      expect(
        handler.playbackState.value.processingState,
        AudioProcessingState.ready,
      );
      expect(handler.playbackState.value.playing, isTrue);
      expect(
        handler.playbackState.value.updatePosition,
        const Duration(seconds: 12),
      );
    },
  );

  test(
    'disposing the final owner clears stale media and notification state',
    () {
      final handler = VideoPlayerServiceHandler(enableBackgroundPlay: true)
        ..clear()
        ..onVideoDetailChange(
          Part(cid: 3, part: 'audio title', duration: 90),
          3,
          'audio-owner',
        )
        ..onVideoDetailDispose('audio-owner');

      expect(handler.mediaItem.value, isNull);
      expect(
        handler.playbackState.value.processingState,
        AudioProcessingState.idle,
      );
      expect(handler.playbackState.value.playing, isFalse);
    },
  );

  test(
    'callback ownership survives nested audio pages and stale cleanup',
    () async {
      final events = <String>[];
      final firstOwner = Object();
      final secondOwner = Object();
      final handler = VideoPlayerServiceHandler(enableBackgroundPlay: true)
        ..clear()
        ..setPlayerCallbacks(
          owner: firstOwner,
          mediaOwnerTag: 'first-owner',
          onPlay: () async => events.add('first'),
          onPause: () async {},
          onSeek: (_) async {},
        )
        ..setPlayerCallbacks(
          owner: secondOwner,
          mediaOwnerTag: 'second-owner',
          onPlay: () async => events.add('second'),
          onPause: () async {},
          onSeek: (_) async {},
        )
        ..onVideoDetailChange(
          Part(cid: 1, part: 'first', duration: 1),
          1,
          'first-owner',
        );
      await handler.play();
      handler.onVideoDetailChange(
        Part(cid: 2, part: 'second', duration: 1),
        2,
        'second-owner',
      );
      await handler.play();
      handler
        ..clearPlayerCallbacks(secondOwner)
        ..onVideoDetailDispose('second-owner');
      await handler.play();
      handler.clearPlayerCallbacks(firstOwner);

      expect(events, ['first', 'second', 'first']);
    },
  );

  test(
    'stale audio cannot control or update a newer media owner',
    () async {
      final events = <String>[];
      final handler = VideoPlayerServiceHandler(enableBackgroundPlay: true)
        ..clear()
        ..setPlayerCallbacks(
          owner: Object(),
          mediaOwnerTag: 'audio-owner',
          onPlay: () async => events.add('audio-play'),
          onPause: () async => events.add('audio-pause'),
          onSeek: (_) async => events.add('audio-seek'),
        )
        ..onVideoDetailChange(
          Part(cid: 1, part: 'audio', duration: 90),
          1,
          'audio-owner',
        );

      await handler.play();
      handler
        ..onVideoDetailChange(
          Part(cid: 2, part: 'video', duration: 90),
          2,
          'video-owner',
        )
        ..onStatusChange(PlayerStatus.paused, false, false)
        ..onPositionChange(const Duration(seconds: 5))
        ..onStatusChange(
          PlayerStatus.playing,
          false,
          false,
          mediaOwnerTag: 'audio-owner',
        )
        ..onPositionChange(
          const Duration(seconds: 12),
          mediaOwnerTag: 'audio-owner',
        );
      await handler.play();
      await handler.pause();
      await handler.seek(const Duration(seconds: 30));

      expect(events, ['audio-play']);
      expect(handler.mediaItem.value?.title, 'video');
      expect(
        handler.playbackState.value.processingState,
        AudioProcessingState.ready,
      );
      expect(handler.playbackState.value.playing, isFalse);
      expect(
        handler.playbackState.value.updatePosition,
        const Duration(seconds: 30),
      );

      handler.onVideoDetailDispose('audio-owner');

      expect(handler.mediaItem.value?.title, 'video');
      expect(
        handler.playbackState.value.processingState,
        AudioProcessingState.ready,
      );
      expect(handler.playbackState.value.playing, isFalse);
      expect(
        handler.playbackState.value.updatePosition,
        const Duration(seconds: 30),
      );
    },
  );

  test(
    'stale Pl events cannot overwrite the current direct audio owner',
    () {
      final handler = VideoPlayerServiceHandler(enableBackgroundPlay: true)
        ..clear()
        ..setPlayerCallbacks(
          owner: Object(),
          mediaOwnerTag: 'audio-owner',
          onPlay: () async {},
          onPause: () async {},
          onSeek: (_) async {},
        )
        ..onVideoDetailChange(
          Part(cid: 1, part: 'audio', duration: 90),
          1,
          'audio-owner',
        )
        ..onStatusChange(
          PlayerStatus.paused,
          false,
          false,
          mediaOwnerTag: 'audio-owner',
        )
        ..onPositionChange(
          const Duration(seconds: 5),
          mediaOwnerTag: 'audio-owner',
        )
        ..onStatusChange(PlayerStatus.playing, false, false)
        ..onPositionChange(const Duration(seconds: 12));

      expect(handler.playbackState.value.playing, isFalse);
      expect(
        handler.playbackState.value.updatePosition,
        const Duration(seconds: 5),
      );
    },
  );

  test('media owners use exact tags and clean up while disabled', () {
    final handler = VideoPlayerServiceHandler(enableBackgroundPlay: true)
      ..clear()
      ..onVideoDetailChange(
        Part(cid: 1, part: 'owner 123', duration: 90),
        1,
        '123',
      )
      ..onVideoDetailDispose('23');

    expect(handler.mediaItem.value?.title, 'owner 123');

    handler
      ..enableBackgroundPlay = false
      ..onVideoDetailDispose('123');

    expect(handler.mediaItem.value, isNull);
    expect(
      handler.playbackState.value.processingState,
      AudioProcessingState.idle,
    );
  });
}
