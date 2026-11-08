import 'dart:async';

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
          child: switch (player.textureId) {
            final id? => Texture(textureId: id),
            null => _NativeHdrSurface(player: player),
          },
        );
      },
    );
  }
}

class _NativeHdrSurface extends StatefulWidget {
  const _NativeHdrSurface({required this.player});

  final NativeHdrPlayer player;

  @override
  State<_NativeHdrSurface> createState() => _NativeHdrSurfaceState();
}

class _NativeHdrSurfaceState extends State<_NativeHdrSurface> {
  static int _activeViews = 0;
  static Future<bool>? _prepareComposition;
  late final Future<bool> _ready;

  static Future<bool> _setSynchronization(bool enabled) async {
    try {
      // Keep the main Flutter scene on its render surface while Android
      // composites the video and Flutter's controls as separate layers.
      await SystemChannels.platform_views.invokeMethod<void>(
        'synchronizeToNativeViewHierarchy',
        enabled,
      );
      return true;
    } on PlatformException catch (error) {
      debugPrint('Dolby Vision composition: ${error.code}');
    } on MissingPluginException catch (error) {
      debugPrint('Dolby Vision composition: ${error.message}');
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _activeViews++;
    _ready = _prepareComposition ??= _setSynchronization(false);
    unawaited(
      _ready.then((ready) {
        if (mounted) return widget.player.setSurfaceAvailable(ready);
      }),
    );
  }

  @override
  void dispose() {
    if (--_activeViews == 0) {
      _prepareComposition = null;
      unawaited(_setSynchronization(true));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
    future: _ready,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const SizedBox.expand();
      }
      if (snapshot.data != true) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '杜比视界画面初始化失败。请在播放器设置切回 mpv 后重新打开视频。',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
      return PlatformViewLink(
        viewType: NativeHdrPlayer.viewType,
        surfaceFactory: (context, controller) => AndroidViewSurface(
          controller: controller as AndroidViewController,
          hitTestBehavior: PlatformViewHitTestBehavior.transparent,
          gestureRecognizers: const {},
        ),
        onCreatePlatformView: (params) {
          final controller = PlatformViewsService.initExpensiveAndroidView(
            id: params.id,
            viewType: params.viewType,
            layoutDirection: Directionality.of(context),
            creationParams: widget.player.id,
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () => params.onFocusChanged(true),
          );
          return controller
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..create();
        },
      );
    },
  );
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
