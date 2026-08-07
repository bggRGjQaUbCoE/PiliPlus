import 'dart:math' as math;

import 'package:PiliPlus/utils/ios_window_utils.dart';
import 'package:flutter/material.dart';

class WindowControlsInsetProvider extends StatefulWidget {
  const WindowControlsInsetProvider({
    super.key,
    required this.uiScale,
    required this.child,
  });

  final double uiScale;
  final Widget child;

  static double leadingOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_WindowControlsInsetScope>()
          ?.leadingInset ??
      0;

  @override
  State<WindowControlsInsetProvider> createState() =>
      _WindowControlsInsetProviderState();
}

class _WindowControlsInsetProviderState
    extends State<WindowControlsInsetProvider>
    with WidgetsBindingObserver {
  double _nativeLeadingInset = 0;
  bool _updateScheduled = false;
  bool _updatePending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scheduleUpdate();
  }

  @override
  void didChangeMetrics() {
    _scheduleUpdate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _scheduleUpdate();
    }
  }

  void _scheduleUpdate() {
    if (_updateScheduled) {
      _updatePending = true;
      return;
    }

    _updateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _update());
  }

  Future<void> _update() async {
    final inset = await IosWindowUtils.windowControlsLeadingInset;
    if (!mounted) return;

    _updateScheduled = false;
    final effectiveInset = inset.isFinite ? math.max(0.0, inset) : 0.0;
    if (effectiveInset != _nativeLeadingInset) {
      setState(() => _nativeLeadingInset = effectiveInset);
    }

    if (_updatePending) {
      _updatePending = false;
      _scheduleUpdate();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // UIKit points need the same scaling as the app's custom Flutter viewport.
    final scale = widget.uiScale.isFinite && widget.uiScale > 0
        ? widget.uiScale
        : 1.0;
    return _WindowControlsInsetScope(
      leadingInset: _nativeLeadingInset / scale,
      child: widget.child,
    );
  }
}

class _WindowControlsInsetScope extends InheritedWidget {
  const _WindowControlsInsetScope({
    required this.leadingInset,
    required super.child,
  });

  final double leadingInset;

  @override
  bool updateShouldNotify(_WindowControlsInsetScope oldWidget) =>
      leadingInset != oldWidget.leadingInset;
}

class WindowControlsSafeArea extends StatelessWidget {
  const WindowControlsSafeArea({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final leadingInset = WindowControlsInsetProvider.leadingOf(context);
    if (leadingInset == 0) return child;

    return Padding(
      padding: EdgeInsetsDirectional.only(start: leadingInset),
      child: child,
    );
  }
}

class WindowControlsLeadingInset extends StatelessWidget {
  const WindowControlsLeadingInset({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: WindowControlsInsetProvider.leadingOf(context),
  );
}

class WindowControlsAppBarSafeArea extends StatelessWidget {
  const WindowControlsAppBarSafeArea({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final leadingInset = WindowControlsInsetProvider.leadingOf(context);
    if (leadingInset == 0) return child;

    final mediaQuery = MediaQuery.of(context);
    final padding = mediaQuery.padding;
    if (padding.left >= leadingInset) return child;

    // AppBar keeps its background outside this scoped SafeArea, while its
    // toolbar consumes the leading padding without moving trailing actions.
    return MediaQuery(
      data: mediaQuery.copyWith(
        padding: padding.copyWith(left: leadingInset),
      ),
      child: child,
    );
  }
}

class WindowControlsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const WindowControlsAppBar({
    super.key,
    required this.child,
  });

  final PreferredSizeWidget child;

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) =>
      WindowControlsAppBarSafeArea(child: child);
}

extension WindowControlsSafeAreaWidget on Widget {
  Widget withWindowControlsSafeArea() => WindowControlsSafeArea(child: this);

  Widget withWindowControlsAppBarSafeArea() =>
      WindowControlsAppBarSafeArea(child: this);
}

extension WindowControlsPreferredSizeSafeArea on PreferredSizeWidget {
  PreferredSizeWidget withWindowControlsAppBarSafeArea() =>
      WindowControlsAppBar(child: this);
}
