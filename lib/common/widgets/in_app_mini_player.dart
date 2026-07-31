import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:PiliPlus/pages/danmaku/view.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/player_surface.dart';
import 'package:PiliPlus/services/in_app_mini_player_service.dart';
import 'package:PiliPlus/utils/android/bindings.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InAppMiniPlayerHost extends StatefulWidget {
  const InAppMiniPlayerHost({required this.child, super.key});

  final Widget child;

  @override
  State<InAppMiniPlayerHost> createState() => _InAppMiniPlayerHostState();
}

class _InAppMiniPlayerHostState extends State<InAppMiniPlayerHost>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  static const _animationDuration = Duration(milliseconds: 360);
  static const _controlsVisibleDuration = Duration(seconds: 3);

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: _animationDuration,
  )..addStatusListener(_onAnimationStatus);
  InAppMiniPlayerSession? _animatedSession;
  Offset? _position;
  Timer? _controlsHideTimer;
  bool _controlsVisible = false;
  bool _wasSystemPip = false;
  bool _restoreAfterSystemPip = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    InAppMiniPlayerService.instance.addListener(_onSessionChanged);
    if (Platform.isAndroid) {
      AndroidHelper$ToDart.onPictureInPictureModeChanged = Runnable.implement(
        $Runnable(run: _onSystemPipModeChanged),
      );
      _onSystemPipModeChanged();
    }
  }

  @override
  void dispose() {
    _controlsHideTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    InAppMiniPlayerService.instance.removeListener(_onSessionChanged);
    if (Platform.isAndroid) {
      AndroidHelper$ToDart.onPictureInPictureModeChanged?.release();
      AndroidHelper$ToDart.onPictureInPictureModeChanged = null;
    }
    _animationController
      ..removeStatusListener(_onAnimationStatus)
      ..dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == .resumed) {
      _restoreVideoPageAfterSystemPip();
    }
  }

  void _onSystemPipModeChanged() {
    if (!mounted) return;
    final isSystemPip = AndroidHelper.isPipMode;
    if (isSystemPip) {
      _wasSystemPip = true;
      _restoreAfterSystemPip = false;
    } else if (_wasSystemPip) {
      _wasSystemPip = false;
      _restoreAfterSystemPip = true;
      _restoreVideoPageAfterSystemPip();
    }
    setState(() {});
  }

  void _restoreVideoPageAfterSystemPip() {
    if (!_restoreAfterSystemPip ||
        AndroidHelper.isPipMode ||
        WidgetsBinding.instance.lifecycleState != .resumed) {
      return;
    }
    final session = InAppMiniPlayerService.instance.value;
    if (session == null) {
      _restoreAfterSystemPip = false;
      return;
    }
    if (session.phase != .active) return;
    _restoreAfterSystemPip = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && InAppMiniPlayerService.instance.value?.phase == .active) {
        InAppMiniPlayerService.instance.restore();
      }
    });
  }

  void _onSessionChanged() {
    final session = InAppMiniPlayerService.instance.value;
    if (session == null) {
      _animatedSession = null;
      _animationController.stop();
      _hideMiniPlayerControls();
    } else if (session.phase == .entering || session.phase == .restoring) {
      _hideMiniPlayerControls();
      if (!identical(_animatedSession, session)) {
        _animatedSession = session;
        _animationController.forward(from: 0);
      }
    }
    if (session?.phase == .active) {
      _restoreVideoPageAfterSystemPip();
    }
    if (mounted) setState(() {});
  }

  void _hideMiniPlayerControls() {
    _controlsHideTimer?.cancel();
    _controlsHideTimer = null;
    if (_controlsVisible) {
      _controlsVisible = false;
    }
  }

  void _showMiniPlayerControls() {
    final session = InAppMiniPlayerService.instance.value;
    if (session?.phase != .active) return;
    _controlsHideTimer?.cancel();
    if (mounted && !_controlsVisible) {
      setState(() => _controlsVisible = true);
    }
    _controlsHideTimer = Timer(_controlsVisibleDuration, () {
      if (mounted) {
        setState(() => _controlsVisible = false);
      }
      _controlsHideTimer = null;
    });
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status != .completed) return;
    final session = _animatedSession;
    if (session == null) return;
    switch (session.phase) {
      case .entering:
        InAppMiniPlayerService.instance.markActive(session);
      case .restoring:
        InAppMiniPlayerService.instance.completeRestoreAnimation(session);
      case .active:
    }
  }

  Offset _clampPosition(Offset position, Size area, Size playerSize) {
    return Offset(
      position.dx.clamp(8, math.max(8, area.width - playerSize.width - 8)),
      position.dy.clamp(8, math.max(8, area.height - playerSize.height - 8)),
    );
  }

  Size _miniPlayerSize(Size area, Size videoSize) {
    final aspectRatio = videoSize.width > 0 && videoSize.height > 0
        ? videoSize.width / videoSize.height
        : 16 / 9;
    final maxWidth = math.min(220.0, area.width * 0.48);
    final maxHeight = math.min(280.0, area.height * 0.42);
    if (maxWidth / maxHeight > aspectRatio) {
      return Size(maxHeight * aspectRatio, maxHeight);
    }
    return Size(maxWidth, maxWidth / aspectRatio);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            final session = InAppMiniPlayerService.instance.value;
            if (session == null) return const SizedBox.shrink();
            return Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final area = constraints.biggest;
                  final playerSize = _miniPlayerSize(
                    area,
                    session.player.naturalVideoSize,
                  );
                  final viewPadding = MediaQuery.viewPaddingOf(context);
                  final fallback = Offset(
                    area.width - playerSize.width - 12,
                    area.height - playerSize.height - viewPadding.bottom - 76,
                  );
                  final position = _clampPosition(
                    _position ?? fallback,
                    area,
                    playerSize,
                  );
                  final miniRect = position & playerSize;
                  final isSystemPip =
                      Platform.isAndroid && AndroidHelper.isPipMode;
                  final progress = Curves.easeOutCubic.transform(
                    _animatedSession == session
                        ? _animationController.value
                        : 1,
                  );
                  final Rect rect;
                  final double radius;
                  if (isSystemPip) {
                    rect = Offset.zero & area;
                    radius = 0;
                  } else if (session.phase == .entering) {
                    rect = Rect.lerp(
                      session.sourceRect ?? miniRect,
                      miniRect,
                      progress,
                    )!;
                    radius = 10 * progress;
                  } else if (session.phase == .restoring) {
                    rect = Rect.lerp(
                      miniRect,
                      InAppMiniPlayerService.instance.restoreDestinationRect ??
                          session.destinationRect ??
                          miniRect,
                      progress,
                    )!;
                    radius = 10 * (1 - progress);
                  } else {
                    rect = miniRect;
                    radius = 10;
                  }
                  final interactive = session.phase == .active && !isSystemPip;
                  return Stack(
                    children: [
                      Positioned.fromRect(
                        rect: rect,
                        child: IgnorePointer(
                          ignoring: !interactive,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onPanUpdate: (details) {
                              setState(() {
                                _position = _clampPosition(
                                  position + details.delta,
                                  area,
                                  playerSize,
                                );
                              });
                            },
                            onTap: _showMiniPlayerControls,
                            child: _MiniPlayerCard(
                              session: session,
                              borderRadius: radius,
                              showControls: interactive && _controlsVisible,
                              onControlsInteraction: _showMiniPlayerControls,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _MiniPlayerCard extends StatelessWidget {
  const _MiniPlayerCard({
    required this.session,
    required this.borderRadius,
    required this.showControls,
    required this.onControlsInteraction,
  });

  final InAppMiniPlayerSession session;
  final double borderRadius;
  final bool showControls;
  final VoidCallback onControlsInteraction;

  @override
  Widget build(BuildContext context) {
    final player = session.player;
    final cid = player.cid;
    final radius = BorderRadius.circular(borderRadius);
    return Material(
      elevation: 10,
      color: Colors.transparent,
      borderRadius: radius,
      child: ClipRRect(
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: ColoredBox(
          color: Colors.black,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _MiniPlayerVideo(player: player),
              if (!player.pipNoDanmaku && cid != null)
                LayoutBuilder(
                  builder: (context, constraints) => IgnorePointer(
                    child: PlDanmaku(
                      cid: cid,
                      playerController: player,
                      isPipMode: true,
                      isFullScreen: false,
                      isFileSource: player.isFileSource,
                      size: constraints.biggest,
                    ),
                  ),
                ),
              AnimatedOpacity(
                opacity: showControls ? 1 : 0,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: IgnorePointer(
                  ignoring: !showControls,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x66000000),
                              Colors.transparent,
                              Color(0x88000000),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 2,
                        top: 2,
                        child: _MiniButton(
                          tooltip: '返回视频',
                          icon: Icons.open_in_full_rounded,
                          onPressed: InAppMiniPlayerService.instance.restore,
                          onInteraction: onControlsInteraction,
                        ),
                      ),
                      Positioned(
                        right: 2,
                        top: 2,
                        child: _MiniButton(
                          tooltip: '关闭小窗',
                          icon: Icons.close_rounded,
                          onPressed: InAppMiniPlayerService.instance.dismiss,
                          onInteraction: onControlsInteraction,
                        ),
                      ),
                      Center(
                        child: Obx(() {
                          final isPlaying = player.playerStatus.value.isPlaying;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!player.isLive)
                                _MiniButton(
                                  tooltip: '后退 10 秒',
                                  icon: Icons.replay_10_rounded,
                                  onPressed: () {
                                    player.seekTo(
                                      player.currentPosition -
                                          const Duration(seconds: 10),
                                      isSeek: false,
                                    );
                                  },
                                  onInteraction: onControlsInteraction,
                                ),
                              _MiniButton(
                                tooltip: isPlaying ? '暂停' : '播放',
                                icon: isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                iconSize: 30,
                                onPressed: isPlaying
                                    ? player.pause
                                    : player.play,
                                onInteraction: onControlsInteraction,
                              ),
                              if (!player.isLive)
                                _MiniButton(
                                  tooltip: '前进 10 秒',
                                  icon: Icons.forward_10_rounded,
                                  onPressed: () {
                                    final target =
                                        player.currentPosition +
                                        const Duration(seconds: 10);
                                    player.seekTo(
                                      target > player.currentDuration
                                          ? player.currentDuration
                                          : target,
                                      isSeek: false,
                                    );
                                  },
                                  onInteraction: onControlsInteraction,
                                ),
                            ],
                          );
                        }),
                      ),
                      if (session.title case final title? when title.isNotEmpty)
                        Positioned(
                          left: 8,
                          right: 8,
                          bottom: 5,
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniPlayerVideo extends StatelessWidget {
  const _MiniPlayerVideo({required this.player});

  final PlPlayerController player;

  @override
  Widget build(BuildContext context) {
    return PlPlayerSurface(controller: player);
  }
}

class _MiniButton extends StatelessWidget {
  const _MiniButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.onInteraction,
    this.iconSize = 20,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final VoidCallback? onInteraction;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Color(0x55000000)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () {
        onInteraction?.call();
        onPressed();
      },
      icon: Icon(icon, color: Colors.white, size: iconSize),
    );
  }
}
