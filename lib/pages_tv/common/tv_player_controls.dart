import 'dart:async';

import 'package:PiliPlus/pages_tv/common/tv_focus_wrapper.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/plugin/pl_player/utils/danmaku_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TVPlayerControls extends StatefulWidget {
  const TVPlayerControls({
    super.key,
    required this.controller,
    this.title,
    this.isLive = false,
    this.onNextEpisode,
    this.onShowEpisodeList,
    this.onQualityTap,
  });

  final PlPlayerController controller;
  final String? title;
  final bool isLive;
  final VoidCallback? onNextEpisode;
  final VoidCallback? onShowEpisodeList;
  final VoidCallback? onQualityTap;

  @override
  State<TVPlayerControls> createState() => _TVPlayerControlsState();
}

class _TVPlayerControlsState extends State<TVPlayerControls> {
  bool _showTopBar = false;
  bool _showBottomBar = false;
  Timer? _hideTimer;
  double? _savedSpeed;

  PlPlayerController get _ctr => widget.controller;

  void _resetHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showTopBar = false;
          _showBottomBar = false;
        });
      }
    });
  }

  void _togglePlayPause() {
    if (_ctr.playerStatus.isPlaying) {
      _ctr.pause();
    } else {
      _ctr.play();
    }
  }

  void _seekRelative(int seconds) {
    final current = _ctr.position;
    final target = current + Duration(seconds: seconds);
    _ctr.seekTo(target);
  }

  void _startLongPressSpeed() {
    _savedSpeed = _ctr.playbackSpeed;
    _ctr.setPlaybackSpeed(_savedSpeed! + 1.0);
  }

  void _stopLongPressSpeed() {
    if (_savedSpeed != null) {
      _ctr.setPlaybackSpeed(_savedSpeed!);
      _savedSpeed = null;
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (_showBottomBar) return KeyEventResult.ignored;

    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.select:
          _togglePlayPause();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.arrowLeft:
          if (!widget.isLive) _seekRelative(-10);
          return KeyEventResult.handled;
        case LogicalKeyboardKey.arrowRight:
          if (!widget.isLive) _seekRelative(10);
          return KeyEventResult.handled;
        case LogicalKeyboardKey.arrowUp:
          setState(() {
            _showTopBar = true;
            _showBottomBar = false;
          });
          _resetHideTimer();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.arrowDown:
          setState(() {
            _showBottomBar = true;
            _showTopBar = false;
          });
          _resetHideTimer();
          return KeyEventResult.handled;
        default:
          break;
      }
    }

    if (event is KeyRepeatEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.select:
          if (_savedSpeed == null) _startLongPressSpeed();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.arrowLeft:
          if (!widget.isLive) _seekRelative(-3);
          return KeyEventResult.handled;
        case LogicalKeyboardKey.arrowRight:
          if (!widget.isLive) _seekRelative(3);
          return KeyEventResult.handled;
        default:
          break;
      }
    }

    if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.select) {
        _stopLongPressSpeed();
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _stopLongPressSpeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Focus(
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Stack(
        children: [
          // Top info bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: _showTopBar ? 0 : -80,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black54, Colors.transparent],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Obx(() => Icon(
                        _ctr.enableShowDanmaku.value
                            ? Icons.subtitles
                            : Icons.subtitles_off,
                        color: Colors.white70,
                        size: 20,
                      )),
                ],
              ),
            ),
          ),

          // Bottom control bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: _showBottomBar ? 0 : -120,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black54, Colors.transparent],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!widget.isLive) _buildProgressBar(theme),
                  const SizedBox(height: 8),
                  _buildControlButtons(theme),
                ],
              ),
            ),
          ),

          // Center play state indicator
          Obx(() {
            final status = _ctr.playerStatus.value;
            if (status == PlayerStatus.paused) {
              return const Center(
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 72,
                  color: Colors.white70,
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ThemeData theme) {
    return Obx(() {
      final pos = _ctr.sliderPositionSeconds.value.toDouble();
      final dur = _ctr.duration.value.inSeconds.toDouble();
      final buf = _ctr.bufferedSeconds.value.toDouble();
      final max = dur > 0 ? dur : 1.0;
      return Row(
        children: [
          Text(
            _formatDuration(Duration(seconds: pos.toInt())),
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                LinearProgressIndicator(
                  value: buf / max,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Colors.white38),
                  minHeight: 4,
                ),
                LinearProgressIndicator(
                  value: pos / max,
                  backgroundColor: Colors.transparent,
                  valueColor:
                      AlwaysStoppedAnimation(theme.colorScheme.primary),
                  minHeight: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _formatDuration(Duration(seconds: dur.toInt())),
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      );
    });
  }

  Widget _buildControlButtons(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() => _ControlButton(
              icon: Icons.play_arrow,
              activeIcon: Icons.pause,
              isActive: _ctr.playerStatus.isPlaying,
              label: '播放',
              onSelect: _togglePlayPause,
            )),
        const SizedBox(width: 24),
        _ControlButton(
          icon: Icons.high_quality_outlined,
          label: '画质',
          onSelect: widget.onQualityTap,
        ),
        const SizedBox(width: 24),
        Obx(() => _ControlButton(
              icon: _ctr.enableShowDanmaku.value
                  ? Icons.subtitles
                  : Icons.subtitles_off_outlined,
              label: '弹幕',
              onSelect: () {
                _ctr.enableShowDanmaku.value = !_ctr.enableShowDanmaku.value;
              },
            )),
        const SizedBox(width: 24),
        _ControlButton(
          icon: Icons.tune,
          label: '弹幕设置',
          onSelect: () => _showDanmakuSettings(context),
        ),
        const SizedBox(width: 24),
        Obx(() => _ControlButton(
              icon: Icons.speed,
              label: '${_ctr.playbackSpeed}x',
              onSelect: () => _showSpeedSelector(context),
            )),
        if (widget.onNextEpisode != null) ...[
          const SizedBox(width: 24),
          _ControlButton(
            icon: Icons.skip_next,
            label: '下一集',
            onSelect: widget.onNextEpisode,
          ),
        ],
        if (widget.onShowEpisodeList != null) ...[
          const SizedBox(width: 24),
          _ControlButton(
            icon: Icons.list,
            label: '选集',
            onSelect: widget.onShowEpisodeList,
          ),
        ],
      ],
    );
  }

  void _showDanmakuSettings(BuildContext context) {
    final fontScales = [0.8, 1.0, 1.2, 1.5];
    final fontScaleLabels = ['小', '中', '大', '特大'];
    final opacities = [0.3, 0.5, 0.7, 1.0];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: const Text('弹幕设置'),
            content: SizedBox(
              width: 360,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('字体大小'),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(fontScales.length, (i) {
                      final selected =
                          DanmakuOptions.danmakuFontScale == fontScales[i];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: TVFocusWrapper(
                          autoFocus: i == 0 && selected,
                          scaleFactor: 1.05,
                          borderRadius: 8,
                          onSelect: () {
                            DanmakuOptions.danmakuFontScale = fontScales[i];
                            DanmakuOptions.danmakuFontScaleFS = fontScales[i];
                            DanmakuOptions.save(_ctr.danmakuOpacity.value);
                            setDialogState(() {});
                          },
                          child: Chip(
                            label: Text(fontScaleLabels[i]),
                            backgroundColor: selected
                                ? Theme.of(ctx).colorScheme.primaryContainer
                                : null,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  const Text('不透明度'),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(opacities.length, (i) {
                      final selected =
                          _ctr.danmakuOpacity.value == opacities[i];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: TVFocusWrapper(
                          scaleFactor: 1.05,
                          borderRadius: 8,
                          onSelect: () {
                            _ctr.danmakuOpacity.value = opacities[i];
                            DanmakuOptions.save(opacities[i]);
                            setDialogState(() {});
                          },
                          child: Chip(
                            label: Text('${(opacities[i] * 100).toInt()}%'),
                            backgroundColor: selected
                                ? Theme.of(ctx).colorScheme.primaryContainer
                                : null,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TVFocusWrapper(
                    scaleFactor: 1.02,
                    borderRadius: 8,
                    onSelect: () {
                      if (DanmakuOptions.danmakuWeight > 0) {
                        DanmakuOptions.danmakuWeight = 0;
                      } else {
                        DanmakuOptions.danmakuWeight = 4;
                      }
                      DanmakuOptions.save(_ctr.danmakuOpacity.value);
                      setDialogState(() {});
                    },
                    child: ListTile(
                      leading: Icon(
                        DanmakuOptions.danmakuWeight > 0
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                      ),
                      title: const Text('智能云屏蔽'),
                      subtitle: Text(
                        DanmakuOptions.danmakuWeight > 0
                            ? '已开启 ${DanmakuOptions.danmakuWeight} 级'
                            : '关闭',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('确定'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSpeedSelector(BuildContext context) {
    final speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 3.0];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('播放速度'),
        content: SizedBox(
          width: 300,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: speeds.length,
            itemBuilder: (ctx, i) {
              return TVFocusWrapper(
                autoFocus: speeds[i] == _ctr.playbackSpeed,
                onSelect: () {
                  _ctr.setPlaybackSpeed(speeds[i]);
                  Navigator.of(ctx).pop();
                },
                borderRadius: 8,
                scaleFactor: 1.05,
                child: ListTile(
                  title: Text('${speeds[i]}x'),
                  selected: speeds[i] == _ctr.playbackSpeed,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.label,
    this.onSelect,
    this.activeIcon,
    this.isActive = false,
  });

  final IconData icon;
  final IconData? activeIcon;
  final bool isActive;
  final String label;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    return TVFocusWrapper(
      onSelect: onSelect,
      scaleFactor: 1.2,
      borderRadius: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? (activeIcon ?? icon) : icon,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
