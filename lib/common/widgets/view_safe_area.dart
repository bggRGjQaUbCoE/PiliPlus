import 'package:material_ui/material_ui.dart';

class ViewSafeArea extends StatelessWidget {
  const ViewSafeArea({
    super.key,
    this.top = false,
    this.left = true,
    this.right = true,
    required this.child,
  });

  final bool top;
  final bool left;
  final bool right;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.viewPaddingOf(context);
    return Padding(
      padding: .only(
        top: top ? padding.top : 0.0,
        left: left ? padding.left : 0.0,
        right: right ? padding.right : 0.0,
      ),
      child: child,
    );
  }
}
