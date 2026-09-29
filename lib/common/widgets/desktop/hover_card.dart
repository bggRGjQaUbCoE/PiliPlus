// =============================================================
// PiliPlus Windows 桌面化 · 卡片悬停反馈（纯 UI）
// 桌面 hover：轻微放大 + 圆角阴影抬升 + 手型光标，仅作视觉反馈，
// 不含点击/菜单逻辑；由信息流各页按需包装卡片使用。
// =============================================================
import 'dart:async';

import 'package:material_ui/material_ui.dart';

class HoverCard extends StatefulWidget {
  const HoverCard({
    super.key,
    required this.child,
    this.scale = 1.015,
    this.duration = const Duration(milliseconds: 140),
    this.onHoverDelay,
    this.hoverDelay = const Duration(milliseconds: 400),
  });

  final Widget child;
  final double scale;
  final Duration duration;

  /// 悬停停留 [hoverDelay] 后触发一次（用于预取等低优先级动作）；
  /// 未停留满即离开不会触发。
  final VoidCallback? onHoverDelay;
  final Duration hoverDelay;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hover = false;
  Timer? _hoverTimer;

  void _onEnter() {
    setState(() => _hover = true);
    final onHoverDelay = widget.onHoverDelay;
    if (onHoverDelay != null) {
      _hoverTimer?.cancel();
      _hoverTimer = Timer(widget.hoverDelay, onHoverDelay);
    }
  }

  void _onExit() {
    _hoverTimer?.cancel();
    _hoverTimer = null;
    setState(() => _hover = false);
  }

  @override
  void dispose() {
    _hoverTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      child: AnimatedScale(
        scale: _hover ? widget.scale : 1.0,
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: widget.duration,
          curve: Curves.easeOutCubic,
          decoration: _hover
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.16),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                )
              : null,
          child: widget.child,
        ),
      ),
    );
  }
}
