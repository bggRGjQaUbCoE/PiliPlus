import 'dart:math';

import 'package:material_ui/material_ui.dart';

/// 双层箭头流光动画（长按倍速锁定引导）：
/// 两个 chevron 紧凑叠放，明暗以半周期相位差循环，
/// 向上时高亮由下往上流动，向下时反之。
class SpeedLockArrows extends StatefulWidget {
  const SpeedLockArrows({
    super.key,
    this.down = false,
    this.size = 18,
    this.color = Colors.white,
  });

  /// true 时箭头朝下（退出锁定引导）
  final bool down;
  final double size;
  final Color color;

  @override
  State<SpeedLockArrows> createState() => _SpeedLockArrowsState();
}

class _SpeedLockArrowsState extends State<SpeedLockArrows>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _glow(double t, double phase) =>
      0.3 + 0.7 * (0.5 + 0.5 * cos(2 * pi * (t - phase)));

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final down = widget.down;
    final icon = Icon(
      down
          ? Icons.keyboard_arrow_down_rounded
          : Icons.keyboard_arrow_up_rounded,
      size: size,
      color: widget.color,
    );
    // 高亮流动方向与箭头指向一致
    final double topPhase = down ? 0.0 : 0.5;
    final double bottomPhase = down ? 0.5 : 0.0;
    // 布局盒固定为 size×size（与普通图标同档，保证 toast 各状态等高），
    // 两个 chevron 上下向外溢出绘制
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -size * 0.2,
                child: Opacity(opacity: _glow(t, topPhase), child: icon),
              ),
              Positioned(
                top: size * 0.2,
                child: Opacity(opacity: _glow(t, bottomPhase), child: icon),
              ),
            ],
          );
        },
      ),
    );
  }
}
