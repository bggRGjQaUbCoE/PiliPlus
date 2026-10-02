import 'package:flutter/widgets.dart';

class HomePreviewScope extends InheritedWidget {
  const HomePreviewScope({
    super.key,
    required this.enabled,
    required super.child,
  });

  final bool enabled;

  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HomePreviewScope>()?.enabled ??
      false;

  @override
  bool updateShouldNotify(HomePreviewScope oldWidget) =>
      enabled != oldWidget.enabled;
}
