import 'package:flutter/material.dart';

mixin BaseFabMixin<T extends StatefulWidget> on State<T>, TickerProvider {
  late bool _isFabVisible = true;
  AnimationController get fabAnimationCtr;
  Animation<Offset> get fabAnimation;

  AnimationController _initController() {
    return AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  Animation<Offset> _initAnimation() {
    return fabAnimationCtr.drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0.0, 1.0),
      ).chain(CurveTween(curve: Curves.easeInOut)),
    );
  }

  void showFab() {
    if (!_isFabVisible) {
      _isFabVisible = true;
      fabAnimationCtr.reverse();
    }
  }

  void hideFab() {
    if (_isFabVisible) {
      _isFabVisible = false;
      fabAnimationCtr.forward();
    }
  }
}

mixin FabMixin<T extends StatefulWidget> on BaseFabMixin<T> {
  @override
  late final AnimationController fabAnimationCtr;
  @override
  late final Animation<Offset> fabAnimation;

  @override
  void initState() {
    super.initState();
    fabAnimationCtr = _initController();
    fabAnimation = _initAnimation();
  }

  @override
  void dispose() {
    fabAnimationCtr.dispose();
    super.dispose();
  }
}

mixin LazyFabMixin<T extends StatefulWidget> on BaseFabMixin<T> {
  AnimationController? _fabAnimationCtr;
  Animation<Offset>? _fabAnimation;

  @override
  AnimationController get fabAnimationCtr =>
      _fabAnimationCtr ??= _initController();
  @override
  Animation<Offset> get fabAnimation => _fabAnimation ??= _initAnimation();

  @override
  void dispose() {
    _fabAnimationCtr?.dispose();
    super.dispose();
  }
}
