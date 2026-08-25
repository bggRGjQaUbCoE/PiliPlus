import 'package:material_ui/material_ui.dart';

class ViewSliverSafeArea extends StatelessWidget {
  const ViewSliverSafeArea({
    super.key,
    required this.sliver,
  });

  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.viewPaddingOf(context);
    return SliverPadding(
      padding: .only(
        left: padding.left,
        right: padding.right,
        bottom: padding.bottom + 100,
      ),
      sliver: sliver,
    );
  }
}
