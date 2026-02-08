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

  static final _topPos = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: Offset.zero,
  );

  static const _topDecoration = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: <Color>[
      Colors.transparent,
      Color(0xBF000000),
    ],
    tileMode: TileMode.mirror,
  );

  static final _bottomPos = Tween<Offset>(
    begin: const Offset(0, 1.2),
    end: Offset.zero,
  );

  static const _bottomDecoration = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Colors.transparent,
      Color(0xBF000000),
    ],
    tileMode: TileMode.mirror,
  );

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: controller.drive(isTop ? _topPos : _bottomPos),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isTop ? _topDecoration : _bottomDecoration,
        ),
        child: ViewSafeArea(
          left: isFullScreen,
          right: isFullScreen,
          child: child,
        ),
      ),
    );
  }
}
