import 'dart:async';

import 'package:PiliPlus/plugin/pl_player/utils/video_output_size.dart';
import 'package:PiliPlus/services/logger.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// iOS-only surface. Keep layout based on source pixels, not resized textures.
class IosVideoSurface extends StatefulWidget {
  const IosVideoSurface({
    super.key,
    required this.controller,
    required this.transformationController,
    required this.fit,
    required this.alignment,
    required this.fill,
    required this.resizeOutput,
    this.aspectRatio,
  });

  final VideoController controller;
  final TransformationController transformationController;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final Color fill;
  final bool resizeOutput;
  final double? aspectRatio;

  @override
  State<IosVideoSurface> createState() => _IosVideoSurfaceState();
}

class _IosVideoSurfaceState extends State<IosVideoSurface> {
  // The pinned media-kit fork overwrites native dimensions on videoParams
  // changes without updating its setSize cache. Reapplying setSize with the
  // same dimensions is then a no-op. Use its native size command directly,
  // and reconcile output notifications, without modifying the dependency.
  static const _channel = MethodChannel('com.alexmercerind/media_kit_video');

  late VideoOutputResize _resize;
  StreamSubscription<VideoParams>? _paramsSubscription;
  Size? _source;

  static Size? _sourceSize(VideoParams params) {
    final width = params.dw;
    final height = params.dh;
    if (width == null || height == null || width <= 0 || height <= 0) {
      return null;
    }
    final rotated = params.rotate == 90 || params.rotate == 270;
    return Size(
      (rotated ? height : width).toDouble(),
      (rotated ? width : height).toDouble(),
    );
  }

  @override
  void initState() {
    super.initState();
    _attach();
  }

  void _attach() {
    final controller = widget.controller;
    _source = _sourceSize(controller.player.state.videoParams);
    _resize = VideoOutputResize(
      resize: (size) => _channel.invokeMethod<void>(
        'VideoOutputManager.SetSize',
        {
          'handle': controller.player.handle.toString(),
          'width': size.width.toInt().toString(),
          'height': size.height.toInt().toString(),
        },
      ),
      onError: (error, stackTrace) => logger.w(
        'Unable to resize iOS video output',
        error: error,
        stackTrace: stackTrace,
      ),
    );
    controller.rect.addListener(_onOutputChanged);
    _paramsSubscription = controller.player.stream.videoParams.listen((params) {
      final source = _sourceSize(params);
      if (mounted && source != _source) {
        setState(() => _source = source);
      }
    });
    _onOutputChanged();
  }

  void _onOutputChanged() {
    final rect = widget.controller.rect.value;
    if (rect != null && !rect.isEmpty) _resize.outputChanged(rect.size);
  }

  void _detach(VideoController controller) {
    _resize.dispose();
    _paramsSubscription?.cancel();
    controller.rect.removeListener(_onOutputChanged);
  }

  @override
  void didUpdateWidget(IosVideoSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _detach(oldWidget.controller);
      _attach();
    }
  }

  @override
  void dispose() {
    _detach(widget.controller);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final source = _source;
    final active = TickerMode.of(context);
    if (source == null) {
      _resize.suspend();
      return ColoredBox(color: widget.fill);
    }
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    return LayoutBuilder(
      builder: (context, constraints) => ListenableBuilder(
        listenable: widget.transformationController,
        builder: (context, child) {
          final target = widget.resizeOutput
              ? videoOutputSize(
                  source: source,
                  viewport: constraints.biggest,
                  devicePixelRatio: pixelRatio,
                  fit: widget.fit,
                  aspectRatio: widget.aspectRatio,
                  scale: widget.transformationController.value
                      .getMaxScaleOnAxis(),
                )
              : source;
          if (active && target != null) {
            _resize.request(target);
          } else {
            _resize.suspend();
          }
          return child!;
        },
        child: FittedBox(
          fit: widget.fit,
          alignment: widget.alignment,
          // SimpleVideo's intrinsic size follows the OUTPUT texture. Fix its
          // layout to SOURCE dimensions so none/scaleDown/cropping don't change
          // when the native output is resized (or rounded to integer pixels).
          child: SizedBox(
            width: (widget.aspectRatio == null
                    ? source.width
                    : source.height * widget.aspectRatio!) /
                pixelRatio,
            height: source.height / pixelRatio,
            child: SimpleVideo(
              controller: widget.controller,
              fill: widget.fill,
              aspectRatio: widget.aspectRatio,
            ),
          ),
        ),
      ),
    );
  }
}
