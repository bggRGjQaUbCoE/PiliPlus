import 'package:material_ui/material_ui.dart';

class KeepAliveWrapper extends StatefulWidget {
  const KeepAliveWrapper({
    super.key,
    this.onBuild,
    required this.child,
    this.wantKeepAlive = true,
  });

  final VoidCallback? onBuild;
  final Widget child;
  final bool wantKeepAlive;

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    widget.onBuild?.call();
    return widget.child;
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
