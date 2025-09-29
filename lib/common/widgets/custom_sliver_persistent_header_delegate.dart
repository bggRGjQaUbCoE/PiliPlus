import 'dart:io' show Platform;

import 'package:flutter/material.dart';

class CustomSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  CustomSliverPersistentHeaderDelegate({
    required this.child,
    required this.bgColor,
    double extent = 45,
    this.needRebuild = false,
  }) : _minExtent = extent,
       _maxExtent = extent;
  final double _minExtent;
  final double _maxExtent;
  final Widget child;
  final Color? bgColor;
  final bool needRebuild;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    //创建child子组件
    //shrinkOffset：child偏移值minExtent~maxExtent
    //overlapsContent：SliverPersistentHeader覆盖其他子组件返回true，否则返回false
    return bgColor != null
        ? DecoratedBox(
            decoration: BoxDecoration(
              color: bgColor,
              boxShadow: Platform.isIOS
                  ? null
                  : [
                      BoxShadow(
                        color: bgColor!,
                        offset: const Offset(0, -1),
                      ),
                    ],
            ),
            child: child,
          )
        : child;
  }

  //SliverPersistentHeader最大高度
  @override
  double get maxExtent => _maxExtent;

  //SliverPersistentHeader最小高度
  @override
  double get minExtent => _minExtent;

  @override
  bool shouldRebuild(CustomSliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.bgColor != bgColor ||
        (needRebuild && oldDelegate.child != child);
  }
}
