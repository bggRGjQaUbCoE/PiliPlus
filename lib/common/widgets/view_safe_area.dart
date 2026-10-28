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

/// Keeps a whole page clear of the left and right insets, such as iPhone Duo's
/// vertical status bar, and removes them from [MediaQuery] so widgets inside
/// do not add them again.
class SideSafeArea extends StatelessWidget {
  const SideSafeArea({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    if (padding.left == 0 && padding.right == 0) return child;
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(top: false, bottom: false, child: child),
    );
  }
}
