import 'package:PiliPlus/common/widgets/image_save.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/search_type.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import '../../../common/widgets/badge.dart';
import '../../../models/user/sub_detail.dart';

// 收藏视频卡片 - 水平布局
class SubVideoCardH extends StatelessWidget {
  final SubDetailMediaItem videoItem;
  final int? searchType;

  const SubVideoCardH({
    super.key,
    required this.videoItem,
    this.searchType,
  });

  @override
  Widget build(BuildContext context) {
    int id = videoItem.id!;
    String bvid = videoItem.bvid!;
    return InkWell(
      onTap: () async {
        int cid = await SearchHttp.ab2c(bvid: bvid);
        PageUtils.toVideoPage(
          'bvid=$bvid&cid=$cid',
          arguments: {
            'videoItem': videoItem,
            'heroTag': Utils.makeHeroTag(id),
            'videoType': SearchType.video,
          },
        );
      },
      onLongPress: () => imageSaveDialog(
        title: videoItem.title,
        cover: videoItem.cover,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StyleString.safeSpace,
          vertical: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
                        text: Utils.timeFormat(videoItem.duration!),
                        right: 6.0,
                        bottom: 6.0,
                        type: 'gray',
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            videoContent(context),
          ],
        ),
      ),
    );
  }

  Widget videoContent(context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '${videoItem.title}',
              textAlign: TextAlign.start,
              style: const TextStyle(
                letterSpacing: 0.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            Utils.dateFormat(videoItem.pubtime),
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              StatView(
                context: context,
                theme: 'gray',
                value: Utils.numFormat(videoItem.cntInfo?['play']),
              ),
              const SizedBox(width: 8),
              StatDanMu(
                context: context,
                theme: 'gray',
                value: Utils.numFormat(videoItem.cntInfo?['danmaku']),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
