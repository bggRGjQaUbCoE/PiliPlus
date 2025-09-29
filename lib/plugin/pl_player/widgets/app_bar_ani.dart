import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:flutter/material.dart';

class AppBarAni extends StatelessWidget {
  const AppBarAni({
    super.key,
    required this.child,
    required this.controller,
    required this.isTop,
    required this.isFullScreen,
  });

  final Widget child;
  final AnimationController controller;
  final bool isTop;
  final bool isFullScreen;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position:
          Tween<Offset>(
            begin: isTop ? const Offset(0, -1) : const Offset(0, 1.2),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: controller,
              curve: Curves.linear,
            ),
          ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isTop
              ? const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: <Color>[
                    Colors.transparent,
                    Color(0xBF000000),
                  ],
                  tileMode: TileMode.mirror,
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.transparent,
                    Color(0xBF000000),
                  ],
                  tileMode: TileMode.mirror,
                ),
        ),
        child: ViewSafeArea(
          top: isTop && isFullScreen,
          left: isFullScreen,
          right: isFullScreen,
          child: child,
        ),
      ),
    );
  }
}
