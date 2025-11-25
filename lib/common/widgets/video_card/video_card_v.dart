import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/common/widgets/video_popup_menu.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/stat_type.dart';
import 'package:PiliPlus/models/model_rec_video_item.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';

// 视频卡片 - 垂直布局
class VideoCardV extends StatefulWidget {
  final BaseRecVideoItemModel videoItem;
  final VoidCallback? onRemove;

  const VideoCardV({
    super.key,
    required this.videoItem,
    this.onRemove,
  });

  static final shortFormat = DateFormat('M-d');
  static final longFormat = DateFormat('yy-M-d');

  @override
  State<VideoCardV> createState() => _VideoCardVState();
}

class _VideoCardVState extends State<VideoCardV> {
  bool _isHovering = false;
  bool _isInWatchLater = false;

  BaseRecVideoItemModel get videoItem => widget.videoItem;
  VoidCallback? get onRemove => widget.onRemove;

  Future<void> onPushDetail(String heroTag) async {
    String? goto = videoItem.goto;
    switch (goto) {
      case 'bangumi':
        PageUtils.viewPgc(epId: videoItem.param!);
        break;
      case 'av':
        String bvid = videoItem.bvid ?? IdUtils.av2bv(videoItem.aid!);
        int? cid =
            videoItem.cid ??
            await SearchHttp.ab2c(aid: videoItem.aid, bvid: bvid);
        if (cid != null) {
          PageUtils.toVideoPage(
            aid: videoItem.aid,
            bvid: bvid,
            cid: cid,
            cover: videoItem.cover,
            title: videoItem.title,
          );
        }
        break;
      // 动态
      case 'picture':
        try {
          PiliScheme.routePushFromUrl(videoItem.uri!);
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
    void onLongPress() => imageSaveDialog(
      title: videoItem.title,
      cover: videoItem.cover,
      bvid: videoItem.bvid,
    );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          clipBehavior: Clip.hardEdge,
          child: MouseRegion(
            onEnter: Utils.isMobile ? null : (_) => setState(() => _isHovering = true),
            onExit: Utils.isMobile ? null : (_) => setState(() => _isHovering = false),
            child: InkWell(
              onTap: () => onPushDetail(Utils.makeHeroTag(videoItem.aid)),
              onLongPress: onLongPress,
              onSecondaryTap: Utils.isMobile ? null : onLongPress,
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
                              src: videoItem.cover,
                              width: maxWidth,
                              height: maxHeight,
                              radius: 0,
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
                            // 桌面端悬停显示稍后再看按钮
                            if (!Utils.isMobile && _isHovering && videoItem.goto == 'av' && videoItem.bvid != null)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: _buildWatchLaterButton(context),
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

  Widget _buildWatchLaterButton(BuildContext context) {
    return Material(
      color: _isInWatchLater ? Colors.green.withValues(alpha: 0.8) : Colors.black54,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () async {
          if (_isInWatchLater) {
            // 取消稍后再看
            var res = await UserHttp.toViewDel(aids: videoItem.aid.toString());
            SmartDialog.showToast(res['msg']);
            if (res['status'] == true) {
              setState(() => _isInWatchLater = false);
            }
          } else {
            // 添加稍后再看
            var res = await UserHttp.toViewLater(bvid: videoItem.bvid);
            SmartDialog.showToast(res['msg']);
            if (res['status'] == true) {
              setState(() => _isInWatchLater = true);
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            _isInWatchLater ? Icons.check : Icons.watch_later_outlined,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
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
                    text: videoItem.pgcBadge,
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
                    semanticsLabel: 'UP：${videoItem.owner.name}',
                    style: TextStyle(
                      height: 1.5,
                      fontSize: theme.textTheme.labelMedium!.fontSize,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
                if (videoItem.goto == 'av') const SizedBox(width: 10),
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
        StatWidget(
          type: StatType.play,
          value: videoItem.stat.view,
        ),
        if (videoItem.goto != 'picture') ...[
          const SizedBox(width: 4),
          StatWidget(
            type: StatType.danmaku,
            value: videoItem.stat.danmu,
          ),
        ],
        if (videoItem is RecVideoItemModel) ...[
          const Spacer(),
          Text.rich(
            maxLines: 1,
            TextSpan(
              style: TextStyle(
                fontSize: theme.textTheme.labelSmall!.fontSize,
                color: theme.colorScheme.outline.withValues(alpha: 0.8),
              ),
              text: DateFormatUtils.dateFormat(
                videoItem.pubdate,
                short: VideoCardV.shortFormat,
                long: VideoCardV.longFormat,
              ),
            ),
          ),
          const SizedBox(width: 2),
        ],
        // deprecated
        //  else if (videoItem is RecVideoItemAppModel &&
        //     videoItem.desc != null &&
        //     videoItem.desc!.contains(' · ')) ...[
        //   const Spacer(),
        //   Text.rich(
        //     maxLines: 1,
        //     TextSpan(
        //         style: TextStyle(
        //           fontSize: theme.textTheme.labelSmall!.fontSize,
        //           color: theme.colorScheme.outline.withValues(alpha: 0.8),
        //         ),
        //         text: Utils.shortenChineseDateString(
        //             videoItem.desc!.split(' · ').last)),
        //   ),
        //   const SizedBox(width: 2),
        // ]
      ],
    );
  }
}
