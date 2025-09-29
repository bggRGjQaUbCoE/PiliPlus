import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/skeleton/skeleton.dart';
import 'package:flutter/material.dart';

class VideoCardVSkeleton extends StatelessWidget {
  const VideoCardVSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onInverseSurface;
    return Skeleton(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: StyleString.aspectRatio,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                borderRadius: StyleString.mdRadius,
              ),
            ),
          ),
          Padding(
            // 多列
            padding: const EdgeInsets.fromLTRB(4, 5, 6, 6),
            // 单列
            // padding: const EdgeInsets.fromLTRB(14, 10, 4, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const SizedBox(height: 6),
                Container(
                  width: 200,
                  height: 13,
                  margin: const EdgeInsets.only(bottom: 5),
                  color: color,
                ),
                Container(
                  width: 150,
                  height: 13,
                  margin: const EdgeInsets.only(bottom: 12),
                  color: color,
                ),
                Container(
                  width: 110,
                  height: 13,
                  margin: const EdgeInsets.only(bottom: 5),
                  color: color,
                ),
                Container(
                  width: 75,
                  height: 13,
                  color: color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
