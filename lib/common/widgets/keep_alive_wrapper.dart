import 'package:flutter/material.dart';

class KeepAliveWrapper extends StatefulWidget {
  const KeepAliveWrapper({
    super.key,
    required this.builder,
    this.wantKeepAlive = true,
  });

  final WidgetBuilder builder;
  final bool wantKeepAlive;

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.builder(context);
  }

  @override
  void didUpdateWidget(KeepAliveWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.wantKeepAlive != widget.wantKeepAlive) {
      updateKeepAlive();
    }
  }

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;
}
