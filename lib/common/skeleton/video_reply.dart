import 'package:PiliPlus/common/skeleton/skeleton.dart';
import 'package:flutter/material.dart';

class VideoReplySkeleton extends StatelessWidget {
  const VideoReplySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    Color bgColor = Theme.of(context).colorScheme.onInverseSurface;
    return Skeleton(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 8, 2),
            child: Row(
              children: [
                ClipOval(
                  child: Container(
                    width: 34,
                    height: 34,
                    color: bgColor,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 80,
                  height: 13,
                  color: bgColor,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 4,
              left: 57,
              right: 6,
              bottom: 6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 300,
                  height: 14,
                  margin: const EdgeInsets.only(bottom: 4),
                  color: bgColor,
                ),
                Container(
                  width: 180,
                  height: 14,
                  margin: const EdgeInsets.only(bottom: 10),
                  color: bgColor,
                ),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 14,
                      margin: const EdgeInsets.only(bottom: 4),
                      color: bgColor,
                    ),
                    const Spacer(),
                    Container(
                      width: 30,
                      height: 14,
                      margin: const EdgeInsets.only(bottom: 4),
                      color: bgColor,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 30,
                      height: 14,
                      margin: const EdgeInsets.only(bottom: 4),
                      color: bgColor,
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
