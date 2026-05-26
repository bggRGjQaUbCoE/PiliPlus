import 'dart:async';

import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

class PlayOrPauseButton extends StatefulWidget {
  final PlPlayerController plPlayerController;

  const PlayOrPauseButton({
    super.key,
    required this.plPlayerController,
  });

  @override
  PlayOrPauseButtonState createState() => PlayOrPauseButtonState();
}

class PlayOrPauseButtonState extends State<PlayOrPauseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  StreamSubscription<bool>? _playingSub;
  StreamSubscription<PlayerStatus>? _statusSub;

  Player? get _player => widget.plPlayerController.videoPlayerController;

  @override
  void initState() {
    super.initState();
    final ctr = widget.plPlayerController;
    final isPlaying = ctr.isCasting
        ? ctr.playerStatus.isPlaying
        : (_player?.state.playing ?? false);
    controller = AnimationController(
      vsync: this,
      value: isPlaying ? 1 : 0,
      duration: const Duration(milliseconds: 200),
    );

    final player = _player;
    if (player != null) {
      _playingSub = player.stream.playing.listen((playing) {
        if (!ctr.isCasting) {
          if (playing) {
            controller.forward();
          } else {
            controller.reverse();
          }
        }
      });
    }

    _statusSub = ctr.playerStatus.listen((status) {
      if (ctr.isCasting) {
        if (status.isPlaying) {
          controller.forward();
        } else {
          controller.reverse();
        }
      }
    });
  }

  @override
  void dispose() {
    _playingSub?.cancel();
    _statusSub?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctr = widget.plPlayerController;
    return SizedBox(
      width: 42,
      height: 34,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: ctr.onDoubleTapCenter,
        child: Center(
          child: AnimatedIcon(
            semanticLabel: ctr.playerStatus.isPlaying ? '暂停' : '播放',
            progress: controller,
            icon: AnimatedIcons.play_pause,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
