import 'package:PiliPlus/common/style.dart';
import 'package:flutter/material.dart';

const _ = _VideoCardVSkeleton();
const videoVDelegate = SliverChildListDelegate.fixed(
  [_, _, _, _, _, _, _, _, _, _],
);

class _VideoCardVSkeleton extends StatelessWidget {
  const _VideoCardVSkeleton();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onInverseSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: Style.aspectRatio,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: Style.mdRadius,
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
    );
  }
}
