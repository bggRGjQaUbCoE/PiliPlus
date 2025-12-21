import 'package:flutter/material.dart';

class ViewSliverSafeArea extends StatelessWidget {
  const ViewSliverSafeArea({super.key, required this.sliver});

  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = MediaQuery.viewPaddingOf(context);
    return SliverPadding(
      padding: EdgeInsets.only(
        left: padding.left,
        right: padding.right,
        bottom: padding.bottom + 100,
      ),
      sliver: sliver,
    );
  }
}
