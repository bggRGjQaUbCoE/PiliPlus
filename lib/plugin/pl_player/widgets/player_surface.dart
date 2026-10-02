import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/exo_player/exo_player_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlPlayerSurface extends StatelessWidget {
  const PlPlayerSurface({
    required this.controller,
    this.width,
    this.height,
    this.fill = Colors.black,
    this.alignment = Alignment.center,
    super.key,
  });

  final PlPlayerController controller;
  final double? width;
  final double? height;
  final Color fill;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final fit = controller.videoFit.value;
      final flipX = controller.flipX.value;
      final flipY = controller.flipY.value;
      if (controller.useExoPlayer) {
        final player = controller.exoPlayerController;
        if (player == null) return const SizedBox.shrink();
        final child = ExoPlayerView(
          controller: player,
          fit: fit,
          flipX: flipX,
          flipY: flipY,
        );
        if (width == null && height == null) return child;
        return SizedBox(width: width, height: height, child: child);
      }

      final playerView = controller.mpvPlayerView;
      if (playerView == null) return const SizedBox.shrink();
      return playerView.buildSurface(
        fit: fit,
        flipX: flipX,
        flipY: flipY,
        fill: fill,
        alignment: alignment,
      );
    });
  }
}
