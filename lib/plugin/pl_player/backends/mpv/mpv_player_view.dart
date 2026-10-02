import 'package:PiliPlus/plugin/pl_player/models/subtitle_style.dart';
import 'package:PiliPlus/plugin/pl_player/models/video_fit_type.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// Non-Android mpv video output adapter.
///
/// Shared controllers and widgets only retain this project-owned handle. The
/// media_kit video controller, surface and subtitle configuration stay inside
/// the mpv boundary.
class MpvPlayerView {
  const MpvPlayerView._(this._controller);

  final VideoController _controller;

  static Future<MpvPlayerView> create(
    Player player, {
    required bool enableHardwareAcceleration,
    required String? hwdec,
  }) async {
    final controller = await VideoController.create(
      player,
      configuration: VideoControllerConfiguration(
        enableHardwareAcceleration: enableHardwareAcceleration,
        androidAttachSurfaceAfterVideoParameters: false,
        hwdec: hwdec,
      ),
    );
    return MpvPlayerView._(controller);
  }

  Widget buildSurface({
    required VideoFitType fit,
    required bool flipX,
    required bool flipY,
    required Color fill,
    required Alignment alignment,
  }) {
    return Transform.flip(
      flipX: flipX,
      flipY: flipY,
      child: FittedBox(
        fit: fit.boxFit,
        alignment: alignment,
        child: SimpleVideo(
          controller: _controller,
          fill: fill,
          aspectRatio: fit.aspectRatio,
        ),
      ),
    );
  }

  Widget buildSubtitle({
    required PlayerSubtitleStyle configuration,
    required bool enableDragSubtitle,
    ValueChanged<EdgeInsets>? onUpdatePadding,
  }) {
    return SubtitleView(
      controller: _controller,
      configuration: SubtitleViewConfiguration(
        visible: configuration.visible,
        style: configuration.style,
        strokeStyle: configuration.strokeStyle,
        textAlign: configuration.textAlign,
        textScaleFactor: configuration.textScaleFactor,
        padding: configuration.padding,
      ),
      enableDragSubtitle: enableDragSubtitle,
      onUpdatePadding: onUpdatePadding,
    );
  }
}
