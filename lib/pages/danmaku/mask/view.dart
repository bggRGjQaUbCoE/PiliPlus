import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:PiliPlus/pages/danmaku/mask/controller.dart';
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:material_ui/material_ui.dart';

class DanmakuMaskView extends StatelessWidget {
  const DanmakuMaskView({
    required this.controller,
    required this.videoRect,
    required this.transformationController,
    required this.devicePixelRatio,
    required this.viewportSize,
    required this.overlayOffset,
    required this.fit,
    required this.alignment,
    required this.flipX,
    required this.flipY,
    required this.child,
    this.forcedAspectRatio,
    super.key,
  });

  final DanmakuMaskController controller;
  final ValueListenable<ui.Rect?> videoRect;
  final TransformationController transformationController;
  final double devicePixelRatio;
  final ui.Size viewportSize;
  final ui.Offset overlayOffset;
  final BoxFit fit;
  final Alignment alignment;
  final bool flipX;
  final bool flipY;
  final double? forcedAspectRatio;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        controller.frame,
        videoRect,
        transformationController,
      ]),
      child: child,
      builder: (context, child) {
        final frame = controller.frame.value;
        final rect = videoRect.value;
        final DanmakuMaskClipper? clipper;
        if (frame == null || rect == null || rect.isEmpty) {
          clipper = null;
        } else {
          final logicalVideoSize = ui.Size(
            rect.width / devicePixelRatio,
            rect.height / devicePixelRatio,
          );
          clipper = DanmakuMaskClipper(
            frame: frame,
            videoSize: logicalVideoSize,
            viewportSize: viewportSize,
            overlayOffset: overlayOffset,
            fit: fit,
            alignment: alignment,
            flipX: flipX,
            flipY: flipY,
            forcedAspectRatio: forcedAspectRatio,
            interactiveTransform: Float64List.fromList(
              transformationController.value.storage,
            ),
          );
        }
        return ClipPath(
          clipBehavior: clipper == null ? Clip.none : Clip.antiAlias,
          clipper: clipper,
          child: child,
        );
      },
    );
  }
}

final class DanmakuMaskClipper extends CustomClipper<ui.Path> {
  const DanmakuMaskClipper({
    required this.frame,
    required this.videoSize,
    required this.viewportSize,
    required this.overlayOffset,
    required this.fit,
    required this.alignment,
    required this.flipX,
    required this.flipY,
    required this.interactiveTransform,
    this.forcedAspectRatio,
  });

  final DanmakuMaskFrame frame;
  final ui.Size videoSize;
  final ui.Size viewportSize;
  final ui.Offset overlayOffset;
  final BoxFit fit;
  final Alignment alignment;
  final bool flipX;
  final bool flipY;
  final double? forcedAspectRatio;
  final Float64List interactiveTransform;

  @override
  ui.Path getClip(ui.Size size) {
    return DanmakuMaskGeometry.allowedPath(
      frame: frame,
      videoSize: videoSize,
      viewportSize: viewportSize,
      overlaySize: size,
      overlayOffset: overlayOffset,
      fit: fit,
      alignment: alignment,
      flipX: flipX,
      flipY: flipY,
      forcedAspectRatio: forcedAspectRatio,
      interactiveTransform: interactiveTransform,
    );
  }

  @override
  bool shouldReclip(DanmakuMaskClipper oldClipper) =>
      oldClipper.frame != frame ||
      oldClipper.videoSize != videoSize ||
      oldClipper.viewportSize != viewportSize ||
      oldClipper.overlayOffset != overlayOffset ||
      oldClipper.fit != fit ||
      oldClipper.alignment != alignment ||
      oldClipper.flipX != flipX ||
      oldClipper.flipY != flipY ||
      oldClipper.forcedAspectRatio != forcedAspectRatio ||
      oldClipper.interactiveTransform != interactiveTransform;
}

abstract final class DanmakuMaskGeometry {
  static ui.Path allowedPath({
    required DanmakuMaskFrame frame,
    required ui.Size videoSize,
    required ui.Size viewportSize,
    required ui.Size overlaySize,
    required ui.Offset overlayOffset,
    required BoxFit fit,
    required Alignment alignment,
    required bool flipX,
    required bool flipY,
    required Float64List interactiveTransform,
    double? forcedAspectRatio,
  }) {
    final overlayRect = ui.Offset.zero & overlaySize;
    if (videoSize.isEmpty || viewportSize.isEmpty || frame.viewBox.isEmpty) {
      return ui.Path()..addRect(overlayRect);
    }

    try {
      final effectiveVideoSize = forcedAspectRatio == null
          ? videoSize
          : ui.Size(videoSize.height * forcedAspectRatio, videoSize.height);
      final fitted = applyBoxFit(fit, effectiveVideoSize, viewportSize);
      final sourceRect = alignment.inscribe(
        fitted.source,
        ui.Offset.zero & effectiveVideoSize,
      );
      final destinationRect = alignment.inscribe(
        fitted.destination,
        ui.Offset.zero & viewportSize,
      );
      if (sourceRect.isEmpty || destinationRect.isEmpty) {
        return ui.Path()..addRect(overlayRect);
      }

      final scaleX =
          effectiveVideoSize.width /
          frame.viewBox.width *
          destinationRect.width /
          sourceRect.width;
      final scaleY =
          effectiveVideoSize.height /
          frame.viewBox.height *
          destinationRect.height /
          sourceRect.height;
      final translateX =
          destinationRect.left -
          sourceRect.left * destinationRect.width / sourceRect.width -
          frame.viewBox.left * scaleX;
      final translateY =
          destinationRect.top -
          sourceRect.top * destinationRect.height / sourceRect.height -
          frame.viewBox.top * scaleY;

      var allowed = frame.allowedPath.transform(
        _affine(scaleX, 0, 0, scaleY, translateX, translateY),
      );
      var video = ui.Path()..addRect(destinationRect);

      if (flipX || flipY) {
        final flip = _affine(
          flipX ? -1 : 1,
          0,
          0,
          flipY ? -1 : 1,
          flipX ? viewportSize.width : 0,
          flipY ? viewportSize.height : 0,
        );
        allowed = allowed.transform(flip);
        video = video.transform(flip);
      }
      allowed = allowed.transform(interactiveTransform);
      video = video.transform(interactiveTransform);

      final viewport = ui.Path()..addRect(ui.Offset.zero & viewportSize);
      final allowedInVideo = ui.Path.combine(
        ui.PathOperation.intersect,
        allowed,
        video,
      );
      final outsideVideo = ui.Path.combine(
        ui.PathOperation.difference,
        viewport,
        video,
      );
      var result = ui.Path.combine(
        ui.PathOperation.union,
        outsideVideo,
        allowedInVideo,
      );
      if (overlayOffset != ui.Offset.zero) {
        result = result.transform(
          _affine(1, 0, 0, 1, -overlayOffset.dx, -overlayOffset.dy),
        );
      }
      return ui.Path.combine(
        ui.PathOperation.intersect,
        result,
        ui.Path()..addRect(overlayRect),
      );
    } catch (_) {
      return ui.Path()..addRect(overlayRect);
    }
  }

  static bool contains({
    required ui.Offset position,
    required DanmakuMaskFrame? frame,
    required ui.Size videoSize,
    required ui.Size viewportSize,
    required BoxFit fit,
    required Alignment alignment,
    required bool flipX,
    required bool flipY,
    required Float64List interactiveTransform,
    double? forcedAspectRatio,
  }) {
    if (frame == null) return true;
    return allowedPath(
      frame: frame,
      videoSize: videoSize,
      viewportSize: viewportSize,
      overlaySize: viewportSize,
      overlayOffset: ui.Offset.zero,
      fit: fit,
      alignment: alignment,
      flipX: flipX,
      flipY: flipY,
      forcedAspectRatio: forcedAspectRatio,
      interactiveTransform: interactiveTransform,
    ).contains(position);
  }
}

Float64List _affine(
  double a,
  double b,
  double c,
  double d,
  double e,
  double f,
) {
  return Float64List.fromList([
    a,
    b,
    0,
    0,
    c,
    d,
    0,
    0,
    0,
    0,
    1,
    0,
    e,
    f,
    0,
    1,
  ]);
}
