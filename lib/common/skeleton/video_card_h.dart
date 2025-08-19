import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/skeleton/skeleton.dart';
import 'package:flutter/material.dart';

class VideoCardHSkeleton extends StatelessWidget {
  const VideoCardHSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onInverseSurface;
    return Skeleton(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StyleString.safeSpace,
          vertical: 5,
        ),
        child: Row(
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 4, 6, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: color,
                      width: 200,
                      height: 11,
                      margin: const EdgeInsets.only(bottom: 5),
                    ),
                    Container(
                      color: color,
                      width: 150,
                      height: 13,
                    ),
                    const Spacer(),
                    Container(
                      color: color,
                      width: 100,
                      height: 13,
                      margin: const EdgeInsets.only(bottom: 5),
                    ),
                    Row(
                      children: [
                        Container(
                          color: color,
                          width: 40,
                          height: 13,
                          margin: const EdgeInsets.only(right: 8),
                        ),
                        Container(
                          color: color,
                          width: 40,
                          height: 13,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
