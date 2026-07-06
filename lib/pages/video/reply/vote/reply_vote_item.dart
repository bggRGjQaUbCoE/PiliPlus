import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show VoteCard;
import 'package:PiliPlus/pages/dynamics/widgets/vote.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:flutter/material.dart';

Widget buildVoteCard(
  BuildContext context,
  ColorScheme colorScheme,
  VoteCard voteCard,
) {
  return InkWell(
    onTap: () => showVoteDialog(context, voteCard.voteId.toInt()),
    child: Padding(
      padding: const .symmetric(horizontal: 12, vertical: 6),
      child: Row(
        spacing: 10,
        children: [
          Container(
            decoration: BoxDecoration(
              color: colorScheme.onInverseSurface,
              borderRadius: const .all(.circular(8)),
            ),
            width: 60,
            height: 42,
            child: Icon(
              Icons.bar_chart_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(voteCard.title, maxLines: 1, overflow: .ellipsis),
                Text(
                  '${NumUtils.numFormat(voteCard.count.toInt())}人参与',
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: TextStyle(fontSize: 13, color: colorScheme.outline),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
