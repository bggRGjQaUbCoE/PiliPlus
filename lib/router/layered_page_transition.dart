import 'dart:ui' as ui;

import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:get/get_navigation/src/routes/get_transition_mixin.dart';
import 'package:material_ui/material_ui.dart';

/// The shared GetX hook snapshots the choice for each new route. Changing the
/// setting cannot change the exit animation of a page already on the stack.
abstract final class LayeredPageTransitions {
  static void install() {
    GetPageRouteTransitionMixin.underlayTransitionAllowed = (route) =>
        route.settings.name == '/' || supports(route.settings.name);
    final previous = GetPageRouteTransitionMixin.pageTransitionsBuilder;
    GetPageRouteTransitionMixin.pageTransitionsBuilder = (route) {
      final specific = previous?.call(route);
      if (specific != null) return specific;
      if (!Pref.layeredPageTransition || !supports(route.settings.name)) {
        return null;
      }
      return const LayeredPageTransitionsBuilder();
    };
  }

  // All ordinary GetPageRoutes participate, including Get.to's generated names
  // and anonymous selection routes. Media/WebView page entry participates;
  // their internal fullscreen/history handling stays with the existing page.
  static bool supports(String? name) {
    final path = name == null ? null : Uri.parse(name).path;
    return !const {
      '/',
      '/home',
      '/hot',
      '/FullScreenSc',
    }.contains(path);
  }
}

class LayeredPageTransitionsBuilder extends PageTransitionsBuilder {
  const LayeredPageTransitionsBuilder();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 320);

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => MediaQuery.disableAnimationsOf(context)
      ? ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 1),
          child: child,
        )
      : LayeredPageTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          blur: false,
          linear: route.popGestureInProgress,
          child: child,
        );
}

class LayeredPageTransition extends StatefulWidget {
  const LayeredPageTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required this.blur,
    required this.linear,
    required this.child,
  });

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final bool blur;
  final bool linear;
  final Widget child;

  @override
  State<LayeredPageTransition> createState() => _LayeredPageTransitionState();
}

class _LayeredPageTransitionState extends State<LayeredPageTransition> {
  late CurvedAnimation _incoming;
  late CurvedAnimation _outgoing;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    // Flutter's decelerate is Android's default factor-1 interpolator:
    // 1 - (1 - t)^2. Reverse uses the same easing in the direction of travel.
    // CurvedAnimation keeps its direction across an interrupted animation,
    // avoiding a position jump when a push is immediately reversed.
    _incoming = CurvedAnimation(
      parent: widget.animation,
      curve: Curves.decelerate,
      reverseCurve: Curves.decelerate.flipped,
    );
    _outgoing = CurvedAnimation(
      parent: widget.secondaryAnimation,
      curve: Curves.decelerate,
      reverseCurve: Curves.decelerate.flipped,
    );
  }

  @override
  void didUpdateWidget(LayeredPageTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation != widget.animation ||
        oldWidget.secondaryAnimation != widget.secondaryAnimation) {
      _incoming.dispose();
      _outgoing.dispose();
      _initAnimations();
    }
  }

  @override
  void dispose() {
    _incoming.dispose();
    _outgoing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ClipRect(
    child: AnimatedBuilder(
      animation: Listenable.merge([_incoming, _outgoing]),
      child: ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 1),
        child: widget.child,
      ),
      builder: (context, child) {
        final entering = widget.linear
            ? widget.animation.value
            : _incoming.value;
        final leaving = widget.linear
            ? widget.secondaryAnimation.value
            : _outgoing.value;
        Widget page = child!;
        if (leaving > 0) {
          if (widget.blur) {
            page = ImageFiltered(
              enabled: leaving < 1,
              imageFilter: ui.ImageFilter.blur(
                sigmaX: 6 * leaving,
                sigmaY: 6 * leaving,
                tileMode: ui.TileMode.clamp,
              ),
              child: page,
            );
          }
          page = Stack(
            fit: StackFit.expand,
            children: [
              page,
              IgnorePointer(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: .18 * leaving),
                ),
              ),
            ],
          );
        }
        return FractionalTranslation(
          translation: Offset(1 - entering - .2 * leaving, 0),
          child: page,
        );
      },
    ),
  );
}
