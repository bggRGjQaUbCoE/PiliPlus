import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/common/widgets/video_popup_menu.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/home/rcmd/result.dart';
import 'package:PiliPlus/models/model_rec_video_item.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

// 视频卡片 - 垂直布局
class VideoCardV extends StatelessWidget {
  final BaseRecVideoItemModel videoItem;
  final VoidCallback? onRemove;

  const VideoCardV({
    super.key,
    required this.videoItem,
    this.onRemove,
  });

  bool isStringNumeric(String str) {
    RegExp numericRegex = RegExp(r'^\d+$');
    return numericRegex.hasMatch(str);
  }

  Future<void> onPushDetail(heroTag) async {
    String? goto = videoItem.goto;
    switch (goto) {
      case 'bangumi':
        PageUtils.viewBangumi(epId: videoItem.param!);
        break;
      case 'av':
        String bvid = videoItem.bvid ?? IdUtils.av2bv(videoItem.aid!);
        int? cid = videoItem.cid;
        if (cid == null || cid == 0 || cid == -1) {
          cid = await SearchHttp.ab2c(aid: videoItem.aid, bvid: bvid);
        }
        PageUtils.toVideoPage(
          'bvid=$bvid&cid=$cid',
          arguments: {
            'pic': videoItem.pic,
            'heroTag': heroTag,
          },
        );
        break;
      // 动态
      case 'picture':
        try {
          String type = 'picture';
          String uri = videoItem.uri!;
          String id = '';
          if (uri.startsWith('bilibili://article/')) {
            type = 'read';
            RegExp regex = RegExp(r'\d+');
            Match match = regex.firstMatch(uri)!;
            String matchedNumber = match.group(0)!;
            videoItem.param = int.parse(matchedNumber);
            id = '${videoItem.param}';
          }
          if (uri.startsWith('http')) {
            String id = Uri.parse(uri).path.split('/')[1];
            if (isStringNumeric(id)) {
              PageUtils.pushDynFromId(id: id);
              return;
            }
          }
          Get.toNamed(
            '/articlePage',
            parameters: {
              'id': id,
              'type': type,
            },
          );
        } catch (err) {
          SmartDialog.showToast(err.toString());
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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Semantics(
          label: Utils.videoItemSemantics(videoItem),
          excludeSemantics: true,
          child: Card(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.zero,
            child: InkWell(
              onTap: () => onPushDetail(Utils.makeHeroTag(videoItem.aid)),
              onLongPress: () => imageSaveDialog(
                title: videoItem.title,
                cover: videoItem.pic,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: StyleString.aspectRatio,
                    child: LayoutBuilder(builder: (context, boxConstraints) {
                      double maxWidth = boxConstraints.maxWidth;
                      double maxHeight = boxConstraints.maxHeight;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          NetworkImgLayer(
                            src: videoItem.pic,
                            width: maxWidth,
                            height: maxHeight,
                          ),
                          if (videoItem.duration > 0)
                            PBadge(
                              bottom: 6,
                              right: 7,
                              size: PBadgeSize.small,
                              type: PBadgeType.gray,
                              text: Utils.timeFormat(videoItem.duration),
                            )
                        ],
                      );
                    }),
                  ),
                  videoContent(context)
                ],
              ),
            ),
          ),
        ),
        if (videoItem.goto == 'av')
          Positioned(
            right: -5,
            bottom: -2,
            child: VideoPopupMenu(
              size: 29,
              iconSize: 17,
              videoItem: videoItem,
              onRemove: onRemove,
            ),
          ),
      ],
    );
  }

  Widget videoContent(context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 5, 6, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                "${videoItem.title}\n",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  height: 1.38,
                ),
              ),
            ),
            videoStat(context, theme),
            Row(
              spacing: 2,
              children: [
                if (videoItem.goto == 'bangumi')
                  PBadge(
                    text: videoItem.bangumiBadge,
                    isStack: false,
                    size: PBadgeSize.small,
                    type: PBadgeType.line_primary,
                    fontSize: 9,
                  ),
                if (videoItem.rcmdReason != null)
                  PBadge(
                    text: videoItem.rcmdReason,
                    isStack: false,
                    size: PBadgeSize.small,
                    type: PBadgeType.secondary,
                  ),
                if (videoItem.goto == 'picture')
                  const PBadge(
                    text: '动态',
                    isStack: false,
                    size: PBadgeSize.small,
                    type: PBadgeType.line_primary,
                    fontSize: 9,
                  ),
                if (videoItem.isFollowed)
                  const PBadge(
                    text: '已关注',
                    isStack: false,
                    size: PBadgeSize.small,
                    type: PBadgeType.secondary,
                  ),
                Expanded(
                  flex: 1,
                  child: Text(
                    videoItem.owner.name.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      height: 1.5,
                      fontSize: theme.textTheme.labelMedium!.fontSize,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
                if (videoItem.goto == 'av') const SizedBox(width: 10)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget videoStat(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        StatView(
          context: context,
          theme: 'gray',
          value: videoItem.stat.viewStr,
          goto: videoItem.goto,
        ),
        const SizedBox(width: 4),
        if (videoItem.goto != 'picture')
          StatDanMu(
            context: context,
            theme: 'gray',
            value: videoItem.stat.danmuStr,
          ),
        if (videoItem is RecVideoItemModel) ...[
          const Spacer(),
          Text.rich(
            maxLines: 1,
            TextSpan(
                style: TextStyle(
                  fontSize: theme.textTheme.labelSmall!.fontSize,
                  color: theme.colorScheme.outline.withValues(alpha: 0.8),
                ),
                text: Utils.formatTimestampToRelativeTime(videoItem.pubdate)),
          ),
          const SizedBox(width: 2),
        ] else if (videoItem is RecVideoItemAppModel &&
            videoItem.desc != null &&
            videoItem.desc!.contains(' · ')) ...[
          const Spacer(),
          Text.rich(
            maxLines: 1,
            TextSpan(
                style: TextStyle(
                  fontSize: theme.textTheme.labelSmall!.fontSize,
                  color: theme.colorScheme.outline.withValues(alpha: 0.8),
                ),
                text: Utils.shortenChineseDateString(
                    videoItem.desc!.split(' · ').last)),
          ),
          const SizedBox(width: 2),
        ]
      ],
    );
  }
}
