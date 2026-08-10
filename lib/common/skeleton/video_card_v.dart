import 'package:PiliPlus/common/skeleton/skeleton.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:flutter/material.dart';

class VideoCardVSkeleton extends StatelessWidget {
  const VideoCardVSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = ColorScheme.of(context).onInverseSurface;
    return Skeleton(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          AspectRatio(
            aspectRatio: Style.aspectRatio,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                borderRadius: const .vertical(top: Style.imgRadius),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const .fromLTRB(4, 5, 6, 6),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .spaceBetween,
                children: [
                  Container(width: 200, height: 13, color: color),
                  Container(
                    height: 13,
                    width: 140,
                    color: color,
                    margin: const .only(top: 5),
                  ),
                  const Spacer(),
                  Row(
                    spacing: 8,
                    children: [
                      Container(
                        height: 11,
                        color: color,
                        width: 40,
                      ),
                      Container(
                        height: 11,
                        color: color,
                        width: 40,
                      ),
                    ],
                  ),
                  Container(
                    height: 11,
                    width: 75,
                    color: color,
                    margin: const .only(top: 5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
