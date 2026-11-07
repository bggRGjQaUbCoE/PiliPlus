import 'dart:async';

import 'package:PiliPlus/common/widgets/video_card/video_cover_preview_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class _Player extends Fake implements Player {
  final events = <String>[];
  Completer<void>? opening;
  bool failOpen = false;

  @override
  Future<void> setVolume(double volume, {bool synchronized = true}) async {
    expect(volume, 0);
  }

  @override
  Future<void> open(
    Playable playable, {
    bool play = true,
    bool synchronized = true,
  }) async {
    events.add('open:${(playable as Media).uri}');
    if (failOpen) throw StateError('open failed');
    await opening?.future;
  }

  @override
  Future<void> stop({bool open = true, bool synchronized = true}) async =>
      events.add('stop');

  @override
  Future<void> dispose() async => events.add('dispose');
}

class _VideoController extends Fake implements VideoController {}

void main() {
  late _Player player;
  late VideoCoverPreviewController controller;

  setUp(() {
    player = _Player();
    controller = VideoCoverPreviewController.forTesting(
      () async => (player, _VideoController()),
    );
  });

  tearDown(() async {
    await controller.disposeGlobal();
    controller.dispose();
  });

  test('leaving during initialization never opens the video', () async {
    final initializing = Completer<(Player, VideoController)>();
    controller.dispose();
    controller = VideoCoverPreviewController.forTesting(
      () => initializing.future,
    );
    final owner = Object();
    final playing = controller.play(
      owner,
      'https://example.com/a',
      isCurrent: () => true,
    );
    await Future<void>.delayed(Duration.zero);
    final stopping = controller.stop(owner);
    initializing.complete((player, _VideoController()));
    await Future.wait([playing, stopping]);
    expect(player.events, ['stop']);
    expect(controller.owner, isNull);
  });

  test('old open finishes before the next card starts', () async {
    player.opening = Completer<void>();
    final firstOwner = Object();
    final secondOwner = Object();
    final first = controller.play(
      firstOwner,
      'https://example.com/a',
      isCurrent: () => true,
    );
    await Future<void>.delayed(Duration.zero);
    final second = controller.play(
      secondOwner,
      'https://example.com/b',
      isCurrent: () => true,
    );
    // A late exit from the first card cannot cancel the second card.
    await controller.stop(firstOwner);
    player.opening!.complete();
    await Future.wait([first, second]);
    expect(player.events, [
      'open:https://example.com/a',
      'stop',
      'open:https://example.com/b',
    ]);
    expect(controller.owner, same(secondOwner));
  });

  test('disabling while opening disposes before a later play', () async {
    player.opening = Completer<void>();
    final first = controller.play(
      Object(),
      'https://example.com/a',
      isCurrent: () => true,
    );
    await Future<void>.delayed(Duration.zero);
    final disposing = controller.disposeGlobal();
    final next = controller.play(
      Object(),
      'https://example.com/b',
      isCurrent: () => true,
    );
    player.opening!.complete();
    await Future.wait([first, disposing, next]);
    expect(player.events, [
      'open:https://example.com/a',
      'stop',
      'dispose',
      'open:https://example.com/b',
    ]);
  });

  test('a failed open does not block later previews', () async {
    player.failOpen = true;
    await controller.play(
      Object(),
      'https://example.com/a',
      isCurrent: () => true,
    );
    expect(controller.owner, isNull);
    player.failOpen = false;
    final owner = Object();
    await controller.play(
      owner,
      'https://example.com/b',
      isCurrent: () => true,
    );
    expect(controller.owner, same(owner));
    expect(player.events.last, 'open:https://example.com/b');
  });

  test('an invalidated request does not open a video', () async {
    await controller.play(
      Object(),
      'https://example.com/a',
      isCurrent: () => false,
    );
    expect(player.events, isEmpty);
  });
}
