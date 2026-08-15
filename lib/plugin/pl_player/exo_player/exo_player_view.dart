import 'dart:async';

import 'package:PiliPlus/plugin/pl_player/exo_player/exo_player_controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/video_fit_type.dart';
import 'package:flutter/material.dart';

class ExoPlayerView extends StatefulWidget {
  const ExoPlayerView({
    required this.controller,
    required this.fit,
    required this.flipX,
    required this.flipY,
    super.key,
  });

  final ExoPlayerController controller;
  final VideoFitType fit;
  final bool flipX;
  final bool flipY;

  @override
  State<ExoPlayerView> createState() => _ExoPlayerViewState();
}

class _ExoPlayerViewState extends State<ExoPlayerView> {
  StreamSubscription<ExoPlayerEvent>? _subscription;
  int _generation = 0;
  int _width = 16;
  int _height = 9;

  @override
  void initState() {
    super.initState();
    _listenToPlayer();
  }

  void _listenToPlayer() {
    final state = widget.controller.state;
    _generation = state.generation;
    if (state.width > 0 && state.height > 0) {
      _width = state.width;
      _height = state.height;
    }
    _subscription = widget.controller.events.listen((event) {
      if (!mounted) {
        return;
      }
      final mediaChanged = event.generation != _generation;
      final width = event.width > 0 ? event.width : 16;
      final height = event.height > 0 ? event.height : 9;
      if (!mediaChanged && width == _width && height == _height) return;
      setState(() {
        _generation = event.generation;
        _width = width;
        _height = height;
      });
    });
  }

  @override
  void didUpdateWidget(covariant ExoPlayerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller.id != widget.controller.id) {
      _subscription?.cancel();
      _listenToPlayer();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = _height.toDouble();
    final width = widget.fit.aspectRatio == null
        ? _width.toDouble()
        : height * widget.fit.aspectRatio!;
    return Transform.flip(
      flipX: widget.flipX,
      flipY: widget.flipY,
      child: FittedBox(
        fit: widget.fit.boxFit,
        child: SizedBox(
          width: width,
          height: height,
          child: Texture(textureId: widget.controller.textureId),
        ),
      ),
    );
  }
}
