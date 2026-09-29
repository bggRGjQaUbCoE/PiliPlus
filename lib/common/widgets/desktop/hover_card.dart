// =============================================================
// PiliPlus Windows 桌面化 · 卡片悬停反馈（纯 UI）
// 桌面 hover：轻微放大 + 圆角阴影抬升 + 手型光标，仅作视觉反馈，
// 不含点击/菜单逻辑；由信息流各页按需包装卡片使用。
// =============================================================
import 'package:material_ui/material_ui.dart';

class HoverCard extends StatefulWidget {
  const HoverCard({
    super.key,
    required this.child,
    this.scale = 1.015,
    this.duration = const Duration(milliseconds: 140),
  });

  final Widget child;
  final double scale;
  final Duration duration;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
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
