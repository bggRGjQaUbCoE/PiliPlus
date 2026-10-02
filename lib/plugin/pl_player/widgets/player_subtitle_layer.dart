import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/exo_player/exo_subtitle_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlPlayerSubtitleLayer extends StatelessWidget {
  const PlPlayerSubtitleLayer({required this.controller, super.key});

  final PlPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final configuration = controller.subtitleConfig.value;
      if (controller.useExoPlayer) {
        final player = controller.exoPlayerController;
        if (player == null) return const SizedBox.shrink();
        return ExoSubtitleView(
          controller: player,
          configuration: configuration,
          enableDragSubtitle: controller.enableDragSubtitle,
          onUpdatePadding: controller.onUpdatePadding,
        );
      }

      final playerView = controller.mpvPlayerView;
      if (playerView == null) return const SizedBox.shrink();
      return playerView.buildSubtitle(
        configuration: configuration,
        enableDragSubtitle: controller.enableDragSubtitle,
        onUpdatePadding: controller.onUpdatePadding,
      );
    });
  }
}
