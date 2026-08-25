import 'package:material_ui/material_ui.dart';

mixin ReorderMixin<T extends StatefulWidget> on State<T> {
  late ColorScheme scheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scheme = ColorScheme.of(context);
  }

  Widget proxyDecorator(Widget child, _, _) {
    return ColoredBox(
      color: scheme.onInverseSurface,
      child: child,
    );
  }
}
