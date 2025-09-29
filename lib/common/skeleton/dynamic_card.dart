import 'package:PiliPlus/common/skeleton/skeleton.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:flutter/material.dart';

class DynamicCardSkeleton extends StatelessWidget {
  const DynamicCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final color = theme.colorScheme.onInverseSurface;
    return Skeleton(
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 8,
              color: theme.dividerColor.withValues(alpha: 0.05),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: color,
                      width: 100,
                      height: 13,
                      margin: const EdgeInsets.only(bottom: 5),
                    ),
                    Container(
                      color: color,
                      width: 50,
                      height: 11,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              color: color,
              width: double.infinity,
              height: 13,
              margin: const EdgeInsets.only(bottom: 7),
            ),
            Container(
              color: color,
              width: double.infinity,
              height: 13,
              margin: const EdgeInsets.only(bottom: 7),
            ),
            Container(
              color: color,
              width: 300,
              height: 13,
              margin: const EdgeInsets.only(bottom: 7),
            ),
            Container(
              color: color,
              width: 250,
              height: 13,
              margin: const EdgeInsets.only(bottom: 7),
            ),
            Container(
              color: color,
              width: 100,
              height: 13,
              margin: const EdgeInsets.only(bottom: 7),
            ),
            if (GlobalData().dynamicsWaterfallFlow) const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 0; i < 3; i++)
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.radio_button_unchecked_outlined,
                      size: 20,
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      foregroundColor: theme.colorScheme.outline.withValues(
                        alpha: 0.2,
                      ),
                    ),
                    label: Text(
                      i == 0
                          ? '转发'
                          : i == 1
                          ? '评论'
                          : '点赞',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
