import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:flutter/material.dart';

Widget livePanel(
  BuildContext context, {
  required int floor,
  required ThemeData theme,
  required DynamicItemModel item,
  required bool isDetail,
  required double maxWidth,
  Function(List<String>, int)? callback,
}) {
  DynamicLive2Model? live = item.modules.moduleDynamic!.major!.live;
  if (live == null) {
    return const SizedBox.shrink();
  }
  return Padding(
    padding: floor == 1
        ? const EdgeInsets.symmetric(horizontal: 12)
        : EdgeInsets.zero,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NetworkImgLayer(
          width: 120,
          height: 75,
          src: live.cover,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                live.title!,
                maxLines: isDetail ? null : 2,
                overflow: isDetail ? null : TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              if (live.descFirst case final descFirst?)
                Text(
                  descFirst,
                  style: TextStyle(
                    color: theme.colorScheme.outline,
                    fontSize: theme.textTheme.labelMedium!.fontSize,
                  ),
                ),
            ],
          ),
        ),
        if (live.badge?.text case final badge?)
          Text(
            badge,
            style: TextStyle(
              fontSize: theme.textTheme.labelMedium!.fontSize,
              color: live.liveState == 1
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
            ),
          ),
      ],
    ),
  );
}
