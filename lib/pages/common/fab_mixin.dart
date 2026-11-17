import 'package:PiliPlus/common/widgets/scroll_intent.dart';
import 'package:material_ui/material_ui.dart';

mixin BaseFabMixin<T extends StatefulWidget> on State<T>, TickerProvider {
  late bool _isFabVisible = true;
  final _scrollIntent = ScrollVisibility();
  late final AppLifecycleListener _lifecycle;
  bool _tickerEnabled = true;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _restoreFab);
  }

  void _restoreFab() {
    _scrollIntent.reset();
    showFab();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final enabled = TickerMode.valuesOf(context).enabled;
    if (enabled && !_tickerEnabled) _restoreFab();
    _tickerEnabled = enabled;
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  AnimationController get fabAnimationCtr;
  Animation<Offset> get fabAnimation;

  AnimationController _initController() {
    return AnimationController(
      vsync: this,
      duration: ScrollVisibility.duration,
    );
  }

  Animation<Offset> _initAnimation() {
    return fabAnimationCtr.drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0.0, 1.0),
      ).chain(CurveTween(curve: ScrollVisibility.curve)),
    );
  }

  void showFab() {
    if (!_isFabVisible) {
      _isFabVisible = true;
      if (MediaQuery.disableAnimationsOf(context)) {
        fabAnimationCtr.value = 0;
      } else {
        fabAnimationCtr.reverse();
      }
    }
  }

  void hideFab() {
    if (_isFabVisible) {
      _isFabVisible = false;
      if (MediaQuery.disableAnimationsOf(context)) {
        fabAnimationCtr.value = 1;
      } else {
        fabAnimationCtr.forward();
      }
    }
  }

  Widget fabAnimWrapper({required Widget child}) {
    return NotificationListener<ScrollNotification>(
      onNotification: onNotification,
      child: child,
    );
  }

  bool onNotification(ScrollNotification notification) {
    switch (_scrollIntent.update(notification)) {
      case .forward:
        showFab();
      case .reverse:
        hideFab();
      case .idle || null:
        break;
    }
    return false;
  }

  Widget fabTransition({required Widget child}) => AnimatedBuilder(
    animation: fabAnimationCtr,
    child: child,
    builder: (context, child) {
      final hidden = fabAnimationCtr.isForwardOrCompleted;
      return IgnorePointer(
        ignoring: hidden,
        child: ExcludeSemantics(
          excluding: hidden,
          child: FractionalTranslation(
            translation: fabAnimation.value,
            child: child,
          ),
        ),
      );
    },
  );
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
