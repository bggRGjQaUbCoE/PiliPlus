import 'package:flutter/widgets.dart';

class StatefulBuilder extends StatefulWidget {
  const StatefulBuilder({
    super.key,
    this.onDispose,
    required this.builder,
  });

  final VoidCallback? onDispose;

  final StatefulWidgetBuilder builder;

  @override
  State<StatefulBuilder> createState() => _StatefulBuilderState();
}

class _StatefulBuilderState extends State<StatefulBuilder> {
  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, setState);
}
