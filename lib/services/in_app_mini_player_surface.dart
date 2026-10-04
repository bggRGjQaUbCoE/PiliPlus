import 'package:flutter/material.dart';

/// Only the visible mini-player rectangle handles input. The video texture is
/// clipped separately so it cannot paint or receive events over the controls.
class InAppMiniPlayerSurface extends StatelessWidget {
  const InAppMiniPlayerSurface({
    required this.frame,
    required this.width,
    required this.playing,
    required this.onPlayPause,
    required this.onRestore,
    required this.onClose,
    required this.onMove,
    required this.onResize,
    this.title,
    super.key,
  });

  final Widget frame;
  final double width;
  final bool playing;
  final String? title;
  final VoidCallback onPlayPause;
  final VoidCallback onRestore;
  final VoidCallback onClose;
  final GestureDragUpdateCallback onMove;
  final GestureDragUpdateCallback onResize;

  @override
  Widget build(BuildContext context) => Material(
    elevation: 12,
    clipBehavior: Clip.antiAlias,
    borderRadius: BorderRadius.circular(12),
    color: Colors.black,
    child: Column(
      children: [
        Expanded(
          child: ClipRect(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onRestore,
              child: ColoredBox(
                color: Colors.black,
                child: Center(
                  child: IgnorePointer(
                    child: FittedBox(fit: BoxFit.contain, child: frame),
                  ),
                ),
              ),
            ),
          ),
        ),
        ColoredBox(
          color: Colors.black,
          child: SizedBox(
            height: 44,
            child: Row(
              children: [
                _MiniActionButton(
                  key: const ValueKey('mini-close'),
                  tooltip: '关闭小窗并停止播放',
                  onPressed: onClose,
                  icon: Icons.close,
                ),
                _MiniActionButton(
                  key: const ValueKey('mini-restore'),
                  tooltip: '返回播放页',
                  onPressed: onRestore,
                  icon: Icons.open_in_full,
                ),
                _MiniActionButton(
                  key: const ValueKey('mini-play-pause'),
                  tooltip: playing ? '暂停' : '播放',
                  onPressed: onPlayPause,
                  icon: playing ? Icons.pause : Icons.play_arrow,
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanUpdate: onMove,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: width < 220
                          ? const Icon(
                              Icons.drag_indicator,
                              color: Colors.white70,
                              size: 18,
                            )
                          : Text(
                              title?.isNotEmpty == true ? title! : '拖动小窗',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanUpdate: onResize,
                  child: const SizedBox(
                    width: 30,
                    height: 44,
                    child: Icon(
                      Icons.drag_handle,
                      color: Colors.white70,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _MiniActionButton extends StatelessWidget {
  const _MiniActionButton({
    required this.tooltip,
    required this.onPressed,
    required this.icon,
    super.key,
  });

  final String tooltip;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Semantics(
    label: tooltip,
    button: true,
    child: InkWell(
      onTap: onPressed,
      mouseCursor: SystemMouseCursors.click,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      child: SizedBox(
        width: 36,
        height: 44,
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    ),
  );
}
