import 'package:flutter/material.dart';

const _ = _MsgFeedSysMsgSkeleton();
const sysMsgSkeleton = SliverList(
  delegate: SliverChildListDelegate.fixed(
    [_, _, _, _, _, _, _, _, _, _],
  ),
);

class _MsgFeedSysMsgSkeleton extends StatelessWidget {
  const _MsgFeedSysMsgSkeleton();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onInverseSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 125,
            height: 16,
            color: color,
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            height: 12,
            color: color,
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            height: 12,
            color: color,
          ),
          const SizedBox(height: 4),
          Container(
            width: 100,
            height: 12,
            color: color,
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 100,
              height: 10,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
