import 'package:flutter/material.dart';

mixin FabMixin<T extends StatefulWidget> on State<T>, TickerProvider {
  bool _isFabVisible = true;
  late final AnimationController _fabAnimationCtr;
  late final Animation<Offset> fabAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationCtr = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    fabAnimation = _fabAnimationCtr.drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0.0, 1.0),
      ).chain(CurveTween(curve: Curves.easeInOut)),
    );
  }

  void showFab() {
    if (!_isFabVisible) {
      _isFabVisible = true;
      _fabAnimationCtr.reverse();
    }
  }

  void hideFab() {
    if (_isFabVisible) {
      _isFabVisible = false;
      _fabAnimationCtr.forward();
    }
  }

  @override
  void dispose() {
    _fabAnimationCtr.dispose();
    super.dispose();
  }
}

mixin _NoRightMarginMixin on StandardFabLocation {
  @override
  double getOffsetX(scaffoldGeometry, _) {
    return scaffoldGeometry.scaffoldSize.width -
        scaffoldGeometry.minInsets.right -
        scaffoldGeometry.floatingActionButtonSize.width;
  }
}

mixin _NoBottomPaddingMixin on StandardFabLocation {
  @override
  double getOffsetY(scaffoldGeometry, _) {
    return scaffoldGeometry.contentBottom -
        scaffoldGeometry.floatingActionButtonSize.height;
  }
}

class NoRightMarginFabLocation extends StandardFabLocation
    with FabFloatOffsetY, _NoRightMarginMixin {
  const NoRightMarginFabLocation();
}

class NoBottomPaddingFabLocation extends StandardFabLocation
    with FabEndOffsetX, _NoBottomPaddingMixin {
  const NoBottomPaddingFabLocation();
}

class ActionBarLocation extends StandardFabLocation with _NoBottomPaddingMixin {
  const ActionBarLocation();

  @override
  double getOffsetX(scaffoldGeometry, _) {
    return 0.0;
  }
}
