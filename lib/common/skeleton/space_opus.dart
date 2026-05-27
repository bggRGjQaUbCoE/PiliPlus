import 'package:PiliPlus/common/skeleton/skeleton.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';

class SpaceOpusSkeleton extends StatelessWidget {
  const SpaceOpusSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.onInverseSurface;
    return Skeleton(
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height:
                      (0.68 + 0.82 * Utils.random.nextDouble()) *
                      constraints.maxWidth,
                  color: surface,
                ),
                Container(
                  height: 10,
                  color: surface,
                  margin: const EdgeInsets.all(10),
                  width: constraints.maxWidth * 0.7,
                ),
                Container(
                  height: 10,
                  color: surface,
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  width: constraints.maxWidth,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
