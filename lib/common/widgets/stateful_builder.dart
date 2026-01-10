import 'package:flutter/material.dart';

class StatefulBuilder extends StatefulWidget {
  const StatefulBuilder({
    super.key,
    this.onInit,
    this.onDispose,
    required this.builder,
  });

  final VoidCallback? onInit;

  final VoidCallback? onDispose;

  final StatefulWidgetBuilder builder;

  @override
  State<StatefulBuilder> createState() => _StatefulBuilderState();
}

class _StatefulBuilderState extends State<StatefulBuilder> {
  @override
  void initState() {
    super.initState();
    widget.onInit?.call();
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, setState);
}
