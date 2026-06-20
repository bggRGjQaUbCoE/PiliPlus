import 'package:flutter/material.dart';

const _ = _MsgFeedTopSkeleton();
const sysFeedSkeleton = SliverList(delegate: sysFeedDelegate);
const sysFeedDelegate = SliverChildListDelegate.fixed(
  [_, _, _, _, _, _, _, _, _, _],
);

class _MsgFeedTopSkeleton extends StatelessWidget {
  const _MsgFeedTopSkeleton();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onInverseSurface;
    return ListTile(
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
      title: UnconstrainedBox(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 100,
          height: 11,
          color: color,
        ),
      ),
      subtitle: Container(
        color: color,
        width: 125,
        height: 11,
      ),
    );
  }
}
