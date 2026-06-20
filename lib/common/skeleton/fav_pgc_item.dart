import 'package:PiliPlus/common/style.dart';
import 'package:flutter/material.dart';

const _ = _FavPgcItemSkeleton();
const favPgcDelegate = SliverChildListDelegate.fixed(
  [_, _, _, _, _, _, _, _, _, _],
);

class _FavPgcItemSkeleton extends StatelessWidget {
  const _FavPgcItemSkeleton();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onInverseSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Style.safeSpace,
        vertical: 5,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: LayoutBuilder(
              builder: (context, boxConstraints) {
                return Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                  width: boxConstraints.maxWidth,
                  height: boxConstraints.maxHeight,
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 175,
                  height: 12,
                  color: color,
                ),
                const SizedBox(height: 10),
                Container(
                  width: 55,
                  height: 11,
                  color: color,
                ),
                const SizedBox(height: 5),
                Container(
                  width: 35,
                  height: 11,
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
