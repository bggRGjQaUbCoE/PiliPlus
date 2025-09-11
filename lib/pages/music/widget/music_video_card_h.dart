import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/marquee.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/stat_type.dart';
import 'package:PiliPlus/models_new/music/bgm_recommend_list.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';

class MusicVideoCardH extends StatelessWidget {
  final BgmRecommend videoItem;

  const MusicVideoCardH({
    super.key,
    required this.videoItem,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () async {
          int? cid =
              videoItem.cid ?? await SearchHttp.ab2c(bvid: videoItem.bvid);
          if (cid != null) {
            PageUtils.toVideoPage(
              bvid: videoItem.bvid,
              cid: cid,
              cover: videoItem.cover,
              title: videoItem.title,
            );
          }
        },
        onLongPress: () => imageSaveDialog(
          title: videoItem.title,
          cover: videoItem.cover,
          bvid: videoItem.bvid,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: StyleString.safeSpace,
            vertical: 5,
          ),
          child: Row(
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
                          src: videoItem.cover,
                          width: maxWidth,
                          height: maxHeight,
                        ),
                        PBadge(
                          text: DurationUtils.formatDuration(
                            videoItem.duration,
                          ),
                          right: 6.0,
                          bottom: 6.0,
                          type: PBadgeType.gray,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              content(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              videoItem.title!,
              textAlign: TextAlign.start,
              style: const TextStyle(
                letterSpacing: 0.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            spacing: 8,
            children: [
              StatWidget(
                type: StatType.play,
                value: videoItem.play,
              ),
              StatWidget(
                type: StatType.danmaku,
                value: videoItem.danmu,
              ),
            ],
          ),
          const SizedBox(height: 3),
          NormalMarquee(
            velocity: 25,
            spacing: 30,
            child: Row(
              spacing: 8,
              children: [
                if (videoItem.labelList case final labelList?)
                  for (final label in labelList)
                    PBadge(
                      text: label.name,
                      isStack: false,
                      size: PBadgeSize.small,
                      type: PBadgeType.secondary,
                    ),
                Text(
                  videoItem.upNickName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
