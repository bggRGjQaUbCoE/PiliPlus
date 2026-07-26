import 'dart:async';
import 'dart:ui';

import 'package:PiliPlus/plugin/pl_player/exo_player/exo_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// Flutter subtitle overlay for the Media3 backend.
///
/// Media3 parses and schedules the subtitle track, then sends only the active
/// cue text through [ExoPlayerController]. Keeping the overlay in Flutter makes
/// the existing subtitle style, padding and drag behaviour backend-neutral.
class ExoSubtitleView extends StatefulWidget {
  const ExoSubtitleView({
    required this.controller,
    required this.configuration,
    this.enableDragSubtitle = false,
    this.onUpdatePadding,
    super.key,
  });

  final ExoPlayerController controller;
  final SubtitleViewConfiguration configuration;
  final bool enableDragSubtitle;
  final ValueChanged<EdgeInsets>? onUpdatePadding;

  @override
  State<ExoSubtitleView> createState() => _ExoSubtitleViewState();
}

class _ExoSubtitleViewState extends State<ExoSubtitleView> {
  StreamSubscription<ExoPlayerEvent>? _subscription;
  late String _subtitle = widget.controller.state.subtitle;
  late EdgeInsets _padding = widget.configuration.padding;
  static const _duration = Duration(milliseconds: 100);

  @override
  void initState() {
    super.initState();
    _listenToPlayer();
  }

  void _listenToPlayer() {
    _subtitle = widget.controller.state.subtitle;
    _subscription = widget.controller.events.listen((event) {
      if (!mounted || event.subtitle == _subtitle) {
        return;
      }
      setState(() => _subtitle = event.subtitle);
    });
  }

  @override
  void didUpdateWidget(covariant ExoSubtitleView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _padding = widget.configuration.padding;
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

  Widget _text(TextStyle style) => Text(
    _subtitle,
    style: style,
    textAlign: widget.configuration.textAlign,
    textScaler: TextScaler.noScaling,
  );

  Widget _subtitleView() {
    final strokeStyle = widget.configuration.strokeStyle;
    if (strokeStyle != null) {
      return Stack(
        clipBehavior: Clip.none,
        children: [_text(strokeStyle), _text(widget.configuration.style)],
      );
    }
    return _text(widget.configuration.style);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: _padding,
      duration: _duration,
      alignment: Alignment.bottomCenter,
      child: widget.enableDragSubtitle
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: (details) {
                setState(() {
                  _padding = _padding.copyWith(
                    bottom: clampDouble(
                      _padding.bottom - details.delta.dy,
                      0,
                      200,
                    ),
                  );
                });
              },
              onVerticalDragEnd: (_) {
                widget.onUpdatePadding?.call(_padding);
              },
              child: _subtitleView(),
            )
          : _subtitleView(),
    );
  }
}
