import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    show ExtendedNestedScrollViewState;
import 'package:flutter/widgets.dart' show Element, Curves;

extension ExtendedNestedScrollViewStateExt on ExtendedNestedScrollViewState {
  void refresh() {
    if (mounted) {
      (context as Element).markNeedsBuild();
    }
  }

  void animToTop() {
    if (mounted) {
      final position = innerNestedPositions.first;
      if (position.pixels >= position.viewportDimension * 7) {
        position.localJumpTo(0);
      } else {
        outerController.animateTo(
          outerController.offset,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 500),
        );
      }
    }
  }
}
