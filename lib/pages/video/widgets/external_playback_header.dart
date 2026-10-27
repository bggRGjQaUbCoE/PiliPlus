import 'package:material_ui/material_ui.dart';

/// Keeps the source player mounted while the phone shows compact TV controls.
class ExternalPlaybackHeader extends StatelessWidget {
  const ExternalPlaybackHeader({
    super.key,
    required this.connected,
    required this.playing,
    required this.videoSize,
    required this.player,
    required this.overlay,
    required this.onBack,
    required this.onTogglePlayback,
    required this.onShowControls,
  });

  static const compactHeight = 64.0;

  final bool connected;
  final bool playing;
  final Size videoSize;
  final Widget player;
  final Widget overlay;
  final VoidCallback onBack;
  final VoidCallback onTogglePlayback;
  final VoidCallback onShowControls;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Offstage preserves the decoder and danmaku subscriptions. Keep its
        // layout size too: shrinking the source player can resize its texture.
        Offstage(
          offstage: connected,
          child: OverflowBox(
            alignment: Alignment.topCenter,
            minHeight: connected ? videoSize.height : null,
            maxHeight: connected ? videoSize.height : null,
            child: SizedBox(
              width: videoSize.width,
              height: videoSize.height,
              child: player,
            ),
          ),
        ),
        if (connected)
          Material(
            color: colors.surface,
            child: SizedBox(
              height: compactHeight,
              child: Row(
                children: [
                  IconButton(
                    tooltip: '返回',
                    onPressed: onBack,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: onShowControls,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Icon(Icons.airplay_rounded, color: colors.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'AirPlay',
                                    style: theme.textTheme.titleSmall,
                                  ),
                                  Text(
                                    playing ? '正在电视上播放' : '已暂停',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    tooltip: playing ? '暂停' : '播放',
                    onPressed: onTogglePlayback,
                    icon: Icon(
                      playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    ),
                  ),
                  IconButton(
                    tooltip: '投屏选项',
                    onPressed: onShowControls,
                    icon: const Icon(Icons.more_horiz_rounded),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          )
        else
          overlay,
      ],
    );
  }
}

/// Tablet and landscape layouts keep their existing player slot and comments.
/// The source stays mounted offstage while its slot becomes a TV remote.
class ExternalPlaybackPanel extends StatelessWidget {
  const ExternalPlaybackPanel({
    super.key,
    required this.connected,
    required this.playing,
    required this.player,
    required this.position,
    required this.duration,
    required this.danmaku,
    required this.danmakuScale,
    required this.subtitles,
    required this.subtitleIndex,
    required this.onBack,
    required this.onShowControls,
    required this.onTogglePlayback,
    required this.onSeek,
    required this.onToggleDanmaku,
    required this.onSubtitle,
    required this.onDanmakuScale,
    required this.onSaveDanmakuScale,
  });

  final bool connected;
  final bool playing;
  final Widget player;
  final Duration position;
  final Duration duration;
  final bool danmaku;
  final double danmakuScale;
  final List<String> subtitles;
  final int subtitleIndex;
  final VoidCallback onBack;
  final VoidCallback onShowControls;
  final VoidCallback onTogglePlayback;
  final ValueChanged<Duration> onSeek;
  final VoidCallback onToggleDanmaku;
  final ValueChanged<int> onSubtitle;
  final ValueChanged<double> onDanmakuScale;
  final ValueChanged<double> onSaveDanmakuScale;

  String _timestamp(Duration value) {
    final seconds = value.inSeconds;
    final minutes = (seconds ~/ 60 % 60).toString().padLeft(2, '0');
    final rest = (seconds % 60).toString().padLeft(2, '0');
    return seconds >= 3600
        ? '${seconds ~/ 3600}:$minutes:$rest'
        : '$minutes:$rest';
  }

  void _seekBy(int seconds) => onSeek(
    Duration(
      milliseconds: (position.inMilliseconds + seconds * 1000).clamp(
        0,
        duration.inMilliseconds,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        Offstage(offstage: connected, child: player),
        if (connected)
          Material(
            color: colors.surface,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        tooltip: '返回',
                        onPressed: onBack,
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                        ),
                      ),
                      Icon(Icons.airplay_rounded, color: colors.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          playing ? '正在电视上播放' : '电视播放已暂停',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        tooltip: '投屏选项',
                        onPressed: onShowControls,
                        icon: const Icon(Icons.more_horiz_rounded),
                      ),
                    ],
                  ),
                  Slider(
                    key: const ValueKey('external-seek'),
                    value: duration.inMilliseconds > 0
                        ? (position.inMilliseconds / duration.inMilliseconds)
                              .clamp(0.0, 1.0)
                        : 0,
                    onChanged: duration > Duration.zero
                        ? (value) => onSeek(
                            Duration(
                              milliseconds: (value * duration.inMilliseconds)
                                  .round(),
                            ),
                          )
                        : null,
                    semanticFormatterCallback: (value) => _timestamp(
                      Duration(
                        milliseconds: (value * duration.inMilliseconds).round(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _timestamp(position),
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          _timestamp(duration),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        tooltip: '后退 15 秒',
                        onPressed: () => _seekBy(-15),
                        icon: const Icon(Icons.replay_rounded),
                      ),
                      const SizedBox(width: 24),
                      IconButton.filledTonal(
                        tooltip: playing ? '暂停' : '播放',
                        onPressed: onTogglePlayback,
                        iconSize: 30,
                        icon: Icon(
                          playing
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        tooltip: '前进 15 秒',
                        onPressed: () => _seekBy(15),
                        icon: const Icon(Icons.forward_rounded),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: onToggleDanmaku,
                          icon: Icon(
                            danmaku
                                ? Icons.subtitles_rounded
                                : Icons.subtitles_off_rounded,
                          ),
                          label: Text(danmaku ? '弹幕已开启' : '弹幕已关闭'),
                        ),
                      ),
                      Expanded(
                        child: PopupMenuButton<int>(
                          tooltip: '字幕',
                          initialValue: subtitleIndex,
                          onSelected: onSubtitle,
                          itemBuilder: (_) => [
                            for (var i = 0; i < subtitles.length; i++)
                              CheckedPopupMenuItem(
                                value: i,
                                checked: i == subtitleIndex,
                                child: Text(subtitles[i]),
                              ),
                          ],
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              '字幕：${subtitles[subtitleIndex]}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('弹幕字号'),
                      Expanded(
                        child: Slider(
                          key: const ValueKey('external-danmaku-scale'),
                          min: 0.5,
                          max: 2.5,
                          divisions: 40,
                          value: danmakuScale.clamp(0.5, 2.5),
                          label: '${(danmakuScale * 100).round()}%',
                          onChanged: onDanmakuScale,
                          onChangeEnd: onSaveDanmakuScale,
                        ),
                      ),
                      SizedBox(
                        width: 44,
                        child: Text(
                          '${(danmakuScale * 100).round()}%',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
