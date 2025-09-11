import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/common/widgets/video_card/video_card_v.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/stat_type.dart';
import 'package:PiliPlus/models_new/member/coin_like_arc/item.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';

class MemberCoinLikeItem extends StatelessWidget {
  final CoinLikeArcItem item;

  const MemberCoinLikeItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () async {
          if (item.isPgc == true) {
            if (item.uri?.isNotEmpty == true) {
              PageUtils.viewPgcFromUri(item.uri!);
            }
            return;
          }

          if (item.param != null) {
            int? cid = await SearchHttp.ab2c(aid: item.param);
            if (cid != null) {
              PageUtils.toVideoPage(
                aid: int.parse(item.param!),
                cid: cid,
                cover: item.cover,
                title: item.title,
              );
            }
          }
        },
        onLongPress: () => imageSaveDialog(
          title: item.title,
          cover: item.cover,
          aid: item.param,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: StyleString.aspectRatio,
              child: LayoutBuilder(
                builder: (context, boxConstraints) {
                  double maxWidth = boxConstraints.maxWidth;
                  double maxHeight = boxConstraints.maxHeight;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      NetworkImgLayer(
                        src: item.cover,
                        width: maxWidth,
                        height: maxHeight,
                        radius: 0,
                      ),
                      if (item.isCooperation == true)
                        const PBadge(
                          text: '合作',
                          top: 6,
                          right: 6,
                        )
                      else if (item.isSteins == true)
                        const PBadge(
                          text: '互动',
                          top: 6,
                          right: 6,
                        ),
                      if (item.duration != null && item.duration! > 0)
                        PBadge(
                          bottom: 6,
                          right: 6,
                          type: PBadgeType.gray,
                          text: DurationUtils.formatDuration(item.duration),
                        ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 6, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item.title}\n',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      StatWidget(
                        type: StatType.play,
                        value: item.play,
                      ),
                      const SizedBox(width: 8),
                      StatWidget(
                        type: StatType.danmaku,
                        value: item.danmaku,
                      ),
                      const Spacer(),
                      Text(
                        DateFormatUtils.dateFormat(
                          item.ctime,
                          short: VideoCardV.shortFormat,
                          long: VideoCardV.longFormat,
                        ),
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
