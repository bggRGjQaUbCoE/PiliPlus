import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/live/live_search/user_item.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';

class LiveSearchUserItem extends StatelessWidget {
  const LiveSearchUserItem({
    super.key,
    required this.item,
  });

  final LiveSearchUserItemModel item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = TextStyle(
      fontSize: 13,
      color: theme.colorScheme.outline,
    );
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => PageUtils.toLiveRoom(item.roomid),
        child: Row(
          children: [
            const SizedBox(width: 15),
            NetworkImgLayer(
              src: item.face,
              width: 42,
              height: 42,
              type: ImageType.avatar,
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      item.name!,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    if (item.liveStatus == 1) ...[
                      const SizedBox(width: 10),
                      Image.asset(height: 14, 'assets/images/live/live.gif'),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '分区: ${item.areaName ?? ''}    关注数: ${NumUtils.numFormat(item.fansNum ?? 0)}',
                  style: style,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
