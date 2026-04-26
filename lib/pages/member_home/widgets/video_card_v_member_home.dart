import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/flutter/layout_builder.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:PiliPlus/models_new/video/video_detail/dimension.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/material.dart' hide LayoutBuilder;

// 视频卡片 - 垂直布局
class VideoCardVMemberHome extends StatelessWidget {
  final SpaceArchiveItem videoItem;

  const VideoCardVMemberHome({
    super.key,
    required this.videoItem,
  });

  Future<void> onPushDetail() async {
    String? goto = videoItem.goto;
    switch (goto) {
      case 'bangumi':
        PageUtils.viewPgc(epId: videoItem.param);
        break;

      case 'av':
        if (videoItem.isPgc == true) {
          if (videoItem.uri?.isNotEmpty == true) {
            PageUtils.viewPgcFromUri(videoItem.uri!);
          }
          return;
        }

        String? aid = videoItem.param;
        String? bvid = videoItem.bvid;
        if (aid == null && bvid == null) {
          return;
        }

        bvid ??= IdUtils.av2bv(int.parse(aid!));
        int? cid = videoItem.cid;
        Dimension? dimension;
        if (cid == null) {
          if (await SearchHttp.ab2cWithDimension(aid: aid, bvid: bvid)
              case final res?) {
            cid = res.cid;
            dimension = res.dimension;
          }
        }
        if (cid != null) {
          PageUtils.toVideoPage(
            bvid: bvid,
            cid: cid,
            cover: videoItem.cover,
            title: videoItem.title,
            dimension: dimension,
          );
        }
        break;

      default:
        if (videoItem.uri?.isNotEmpty == true) {
          PiliScheme.routePushFromUrl(videoItem.uri!);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    void onLongPress() => imageSaveDialog(
      title: videoItem.title,
      cover: videoItem.cover,
      aid: videoItem.param,
      bvid: videoItem.bvid,
    );
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPushDetail,
        onLongPress: onLongPress,
        onSecondaryTap: PlatformUtils.isMobile ? null : onLongPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: Style.aspectRatio,
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
                        type: .emote,
                      ),
                      if (videoItem.duration > 0)
                        PBadge(
                          bottom: 6,
                          right: 7,
                          size: PBadgeSize.small,
                          type: PBadgeType.gray,
                          text: DurationUtils.formatDuration(
                            videoItem.duration,
                          ),
                        ),
                      if (videoItem.badges?.isNotEmpty == true)
                        PBadge(
                          text: videoItem.badges!
                              .map((e) => e.text ?? '')
                              .join('|'),
                          top: 6,
                          right: 6,
                          type: videoItem.badges!.first.text == '充电专属'
                              ? PBadgeType.error
                              : PBadgeType.primary,
                        )
                      else if (videoItem.isCooperation == true)
                        const PBadge(
                          text: '合作',
                          top: 6,
                          right: 6,
                        )
                      else if (videoItem.isSteins == true)
                        const PBadge(
                          text: '互动',
                          top: 6,
                          right: 6,
                        ),
                    ],
                  );
                },
              ),
            ),
            content(context),
          ],
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 5, 6, 5),
        child: Text(
          '${videoItem.title}\n',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            height: 1.38,
          ),
        ),
      ),
    );
  }
}
