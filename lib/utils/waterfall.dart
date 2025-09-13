import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/skeleton/dynamic_card.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show SliverConstraints;
import 'package:waterfall_flow/waterfall_flow.dart'
    show SliverWaterfallFlowDelegate;

mixin DynMixin {
  late double maxWidth;

  late final dynGridDelegate =
      SliverWaterfallFlowDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: Grid.smallCardWidth * 2,
        crossAxisSpacing: 4,
        callback: (value) => maxWidth = value,
      );

  Widget buildPage(Widget child) {
    if (GlobalData().dynamicsWaterfallFlow) {
      return child;
    }
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.crossAxisExtent;
        final cardWidth = Grid.smallCardWidth * 2;
        final flag = cardWidth < maxWidth;
        this.maxWidth = flag ? cardWidth : maxWidth;
        if (!flag) {
          return child;
        }
        return SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: (maxWidth - cardWidth) / 2,
          ),
          sliver: child,
        );
      },
    );
  }

  late final skeDelegate = SliverGridDelegateWithExtentAndRatio(
    crossAxisSpacing: 4,
    mainAxisSpacing: 4,
    maxCrossAxisExtent: Grid.smallCardWidth * 2,
    childAspectRatio: StyleString.aspectRatio,
    mainAxisExtent: 50,
  );

  Widget get dynSkeleton {
    if (GlobalData().dynamicsWaterfallFlow) {
      return SliverGrid.builder(
        gridDelegate: skeDelegate,
        itemBuilder: (_, _) => const DynamicCardSkeleton(),
        itemCount: 10,
      );
    }
    return SliverPrototypeExtentList.builder(
      prototypeItem: const DynamicCardSkeleton(),
      itemBuilder: (_, _) => const DynamicCardSkeleton(),
      itemCount: 10,
    );
  }
}

class SliverWaterfallFlowDelegateWithMaxCrossAxisExtent
    extends SliverWaterfallFlowDelegate {
  /// Creates a delegate that makes masonry layouts with tiles that have a maximum
  /// cross-axis extent.
  ///
  /// All of the arguments must not be null. The [maxCrossAxisExtent],
  /// [mainAxisSpacing], and [crossAxisSpacing] arguments must not be negative.
  SliverWaterfallFlowDelegateWithMaxCrossAxisExtent({
    required this.maxCrossAxisExtent,
    super.mainAxisSpacing,
    super.crossAxisSpacing,
    super.lastChildLayoutTypeBuilder,
    super.collectGarbage,
    super.viewportBuilder,
    super.closeToTrailing,
    this.callback,
  }) : assert(maxCrossAxisExtent >= 0);

  /// The maximum extent of tiles in the cross axis.
  ///
  /// This delegate will select a cross-axis extent for the tiles that is as
  /// large as possible subject to the following conditions:
  ///
  ///  - The extent evenly divides the cross-axis extent of the grid.
  ///  - The extent is at most [maxCrossAxisExtent].
  ///
  /// For example, if the grid is vertical, the grid is 500.0 pixels wide, and
  /// [maxCrossAxisExtent] is 150.0, this delegate will create a grid with 4
  /// columns that are 125.0 pixels wide.
  final double maxCrossAxisExtent;

  int? crossAxisCount;
  double? crossAxisExtent;

  final ValueChanged<double>? callback;

  @override
  int getCrossAxisCount(SliverConstraints constraints) {
    final crossAxisExtent = constraints.crossAxisExtent;
    if (crossAxisCount != null && this.crossAxisExtent == crossAxisExtent) {
      return crossAxisCount!;
    }
    this.crossAxisExtent = crossAxisExtent;
    crossAxisCount = (crossAxisExtent / (maxCrossAxisExtent + crossAxisSpacing))
        .ceil();
    callback?.call(
      (crossAxisExtent - ((crossAxisCount! - 1) * crossAxisSpacing)) /
          crossAxisCount!,
    );
    return crossAxisCount!;
  }

  @override
  bool shouldRelayout(SliverWaterfallFlowDelegate oldDelegate) {
    final flag =
        (oldDelegate.runtimeType != runtimeType) ||
        (oldDelegate is SliverWaterfallFlowDelegateWithMaxCrossAxisExtent &&
            (oldDelegate.maxCrossAxisExtent != maxCrossAxisExtent ||
                super.shouldRelayout(oldDelegate)));
    if (flag) {
      crossAxisCount = null;
    }
    return flag;
  }
}
