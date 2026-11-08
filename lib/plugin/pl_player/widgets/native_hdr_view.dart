import 'package:PiliPlus/utils/android/native_hdr_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show PlatformViewHitTestBehavior;
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class NativeHdrView extends StatelessWidget {
  const NativeHdrView({
    required this.player,
    required this.width,
    required this.height,
    this.aspectRatio,
    super.key,
  });

  final NativeHdrPlayer player;
  final int? width;
  final int? height;
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    return StreamBuilder(
      stream: player.stream.size,
      initialData: (player.state.width, player.state.height),
      builder: (context, snapshot) {
        final (videoWidth, videoHeight) = snapshot.requireData;
        final size = videoWidth > 0 && videoHeight > 0
            ? (videoWidth, videoHeight)
            : (
                (width ?? 0) > 0 ? width! : 1920,
                (height ?? 0) > 0 ? height! : 1080,
              );
        final logicalHeight = size.$2 / pixelRatio;
        return SizedBox(
          width: aspectRatio == null
              ? size.$1 / pixelRatio
              : logicalHeight * aspectRatio!,
          height: logicalHeight,
          child: PlatformViewLink(
            viewType: NativeHdrPlayer.viewType,
            surfaceFactory: (context, controller) => AndroidViewSurface(
              controller: controller as AndroidViewController,
              hitTestBehavior: PlatformViewHitTestBehavior.transparent,
              gestureRecognizers: const {},
            ),
            onCreatePlatformView: (params) {
              // Hybrid composition keeps decoding on the native SurfaceView.
              final controller = PlatformViewsService.initExpensiveAndroidView(
                id: params.id,
                viewType: params.viewType,
                layoutDirection: Directionality.of(context),
                creationParams: player.id,
                creationParamsCodec: const StandardMessageCodec(),
                onFocus: () => params.onFocusChanged(true),
              );
              return controller
                ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
                ..create();
            },
          ),
        );
      },
    );
  }
}

class NativeHdrSubtitleView extends StatefulWidget {
  const NativeHdrSubtitleView({
    required this.player,
    required this.configuration,
    required this.enableDrag,
    required this.onUpdatePadding,
    super.key,
  });

  final NativeHdrPlayer player;
  final SubtitleViewConfiguration configuration;
  final bool enableDrag;
  final ValueChanged<EdgeInsets> onUpdatePadding;

  @override
  State<NativeHdrSubtitleView> createState() => _NativeHdrSubtitleViewState();
}

class _NativeHdrSubtitleViewState extends State<NativeHdrSubtitleView> {
  EdgeInsets? _dragPadding;

  @override
  Widget build(BuildContext context) {
    final config = widget.configuration;
    final padding = _dragPadding ?? config.padding;
    return StreamBuilder<Subtitle>(
      stream: widget.player.stream.subtitle,
      initialData: widget.player.state.subtitle,
      builder: (context, snapshot) {
        final subtitle = snapshot.requireData.toString();
        if (subtitle.isEmpty) return const SizedBox.shrink();
        Widget text(TextStyle style) => Text(
          subtitle,
          style: style,
          textAlign: config.textAlign,
          textScaler: TextScaler.noScaling,
        );
        final child = switch (config.strokeStyle) {
          final stroke? => Stack(
            clipBehavior: Clip.none,
            children: [text(stroke), text(config.style)],
          ),
          null => text(config.style),
        };
        return Padding(
          padding: padding,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: widget.enableDrag
                ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onVerticalDragUpdate: (details) => setState(() {
                      _dragPadding = (_dragPadding ?? config.padding).copyWith(
                        bottom:
                            ((_dragPadding ?? config.padding).bottom -
                                    details.delta.dy)
                                .clamp(0.0, 200.0),
                      );
                    }),
                    onVerticalDragEnd: (_) {
                      if (_dragPadding case final result?) {
                        widget.onUpdatePadding(result);
                      }
                      setState(() => _dragPadding = null);
                    },
                    onVerticalDragCancel: () =>
                        setState(() => _dragPadding = null),
                    child: child,
                  )
                : child,
          ),
        );
      },
    );
  }
}
