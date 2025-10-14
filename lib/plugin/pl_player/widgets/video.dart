import 'dart:async';

import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class PlVideo extends StatefulWidget {
  const PlVideo({
    super.key,
    required this.controller,
    this.alignment,
    this.fill,
  });

  final PlPlayerController controller;
  final AlignmentGeometry? alignment;
  final Color? fill;

  @override
  State<PlVideo> createState() => _PlVideoState();
}

class _PlVideoState extends State<PlVideo> with WidgetsBindingObserver {
  PlPlayerController get ctr => widget.controller;

  bool _pauseDueToPauseUponEnteringBackgroundMode = false;
  late final StreamSubscription<bool>? wakeLock;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!ctr.continuePlayInBackground.value) {
      late final player = ctr.videoController?.player;
      if (const [
        AppLifecycleState.paused,
        AppLifecycleState.detached,
      ].contains(state)) {
        if (player != null && player.state.playing) {
          _pauseDueToPauseUponEnteringBackgroundMode = true;
          player.pause();
        }
      } else {
        if (_pauseDueToPauseUponEnteringBackgroundMode) {
          _pauseDueToPauseUponEnteringBackgroundMode = false;
          player?.play();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    late final player = ctr.videoController?.player;
    if (player != null && player.state.playing) {
      WakelockPlus.enable();
    }
    wakeLock = player?.stream.playing.listen(
      (value) {
        if (value) {
          WakelockPlus.enable();
        } else {
          WakelockPlus.disable();
        }
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    wakeLock?.cancel();
    WakelockPlus.enabled.then((i) {
      if (i) WakelockPlus.disable();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Obx(
        () {
          final videoFit = ctr.videoFit.value;
          return Transform.flip(
            flipX: ctr.flipX.value,
            flipY: ctr.flipY.value,
            filterQuality: FilterQuality.low,
            child: FittedBox(
              fit: videoFit.boxFit,
              alignment: widget.alignment ?? Alignment.center,
              child: SimpleVideo(
                controller: ctr.videoController!,
                fill: widget.fill ?? Colors.black,
                aspectRatio: videoFit.aspectRatio,
              ),
            ),
          );
        },
      ),
    );
  }
}
