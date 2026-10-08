import 'package:PiliPlus/common/skeleton/dynamic_card.dart';
import 'package:PiliPlus/common/sliver_single_child_delegate.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/sliver/sliver_constrained_cross_axis.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/rendering.dart' show SliverConstraints;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'
    show SliverSimpleGridDelegate;
import 'package:material_ui/material_ui.dart';

mixin DynMixin {
  late final dynGridDelegate = SliverSimpleGridDelegateWithMaxCrossAxisExtent_(
    maxCrossAxisExtent: Grid.smallCardWidth * 2,
  );

  Widget buildPage(Widget child) {
    if (GlobalData().dynamicsWaterfallFlow) {
      return child;
    }
    return CenteredSliverConstrainedCrossAxis(
      maxExtent: Grid.smallCardWidth * 2,
      sliver: child,
    );
  }

  late final skeDelegate = SliverGridDelegateWithExtentAndRatio(
    crossAxisSpacing: 4,
    mainAxisSpacing: 4,
    maxCrossAxisExtent: Grid.smallCardWidth * 2,
    childAspectRatio: Style.aspectRatio,
    mainAxisExtent: 50,
  );

  Widget get dynSkeleton {
    if (GlobalData().dynamicsWaterfallFlow) {
      return SliverGrid(
        gridDelegate: skeDelegate,
        delegate: const SliverSingleChildDelegate(
          count: 10,
          child: DynamicCardSkeleton(),
        ),
      );
    }
    return const SliverPrototypeExtentList(
      prototypeItem: DynamicCardSkeleton(),
      delegate: SliverSingleChildDelegate(
        count: 10,
        child: DynamicCardSkeleton(),
      ),
    );
  }
}

// ignore: camel_case_types
class SliverSimpleGridDelegateWithMaxCrossAxisExtent_
    extends SliverSimpleGridDelegate {
  /// Creates a delegate that makes grid layouts with tiles that have a maximum
  /// cross-axis extent.
  ///
  /// The [maxCrossAxisExtent] argument must be greater than zero.
  SliverSimpleGridDelegateWithMaxCrossAxisExtent_({
    required this.maxCrossAxisExtent,
  }) : assert(maxCrossAxisExtent > 0);

  /// {@template fsgv.global.maxCrossAxisExtent}
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
  /// {@endtemplate}
  final double maxCrossAxisExtent;

  int? crossAxisCount;
  double? crossAxisExtent;

  @override
  int getCrossAxisCount(
    SliverConstraints constraints,
    double crossAxisSpacing,
  ) {
    final crossAxisExtent = constraints.crossAxisExtent;
    if (crossAxisCount != null && this.crossAxisExtent == crossAxisExtent) {
      return crossAxisCount!;
    }
    this.crossAxisExtent = crossAxisExtent;
    crossAxisCount = (crossAxisExtent / (maxCrossAxisExtent + crossAxisSpacing))
        .ceil();
    return crossAxisCount!;
  }

  @override
  bool shouldRelayout(
    SliverSimpleGridDelegateWithMaxCrossAxisExtent_ oldDelegate,
  ) {
    final flag = oldDelegate.maxCrossAxisExtent != maxCrossAxisExtent;
    if (flag) {
      crossAxisCount = null;
    }
    return flag;
  }
}
