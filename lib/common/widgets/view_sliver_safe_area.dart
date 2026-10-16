import 'package:material_ui/material_ui.dart';

class ViewSliverSafeArea extends StatelessWidget {
  const ViewSliverSafeArea({
    super.key,
    required this.sliver,
    this.bottom = 100,
  });

  final Widget sliver;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.viewPaddingOf(context);
    return SliverPadding(
      padding: .only(
        left: padding.left,
        right: padding.right,
        bottom: padding.bottom + bottom,
      ),
      sliver: sliver,
    );
  }
}
