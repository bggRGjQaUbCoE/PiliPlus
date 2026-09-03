import 'package:flutter/widgets.dart';

class SliverSingleChildDelegate extends SliverChildDelegate {
  const SliverSingleChildDelegate({required int count, required this.child})
    : estimatedChildCount = count,
      assert(count >= 0);

  @override
  final int estimatedChildCount;
  final Widget child;

  @override
  Widget? build(BuildContext context, int index) {
    if (index < 0 || index >= estimatedChildCount) return null;
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverSingleChildDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
