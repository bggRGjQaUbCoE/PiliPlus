import 'package:PiliPlus/common/skeleton/skeleton.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';

class SpaceOpusSkeleton extends StatelessWidget {
  const SpaceOpusSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final surface = ColorScheme.of(context).onInverseSurface;
    return Skeleton(
      child: Card(
        shape: const RoundedRectangleBorder(borderRadius: .all(.circular(6))),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            AspectRatio(
              aspectRatio: 1 / (0.68 + 0.82 * Utils.random.nextDouble()),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: const .vertical(top: .circular(6)),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.7,
              alignment: .topLeft,
              child: Container(
                height: 10,
                color: surface,
                margin: const .all(10),
              ),
            ),
            Container(
              height: 10,
              color: surface,
              margin: const .only(left: 10, right: 10, bottom: 10),
            ),
          ],
        ),
      ),
    );
  }
}
