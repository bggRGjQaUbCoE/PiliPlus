import 'package:PiliPlus/common/widgets/image_save.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/common/widgets/video_popup_menu.dart';
import 'package:PiliPlus/common/widgets/video_progress_indicator.dart';
import 'package:PiliPlus/models/space_archive/item.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../../utils/utils.dart';
import '../constants.dart';
import 'badge.dart';
import 'network_img_layer.dart';

// 视频卡片 - 水平布局
class VideoCardHMemberVideo extends StatelessWidget {
  const VideoCardHMemberVideo({
    super.key,
    required this.videoItem,
    this.onTap,
    this.bvid,
    this.fromViewAid,
  });
  final Item videoItem;
  final VoidCallback? onTap;
  final dynamic bvid;
  final String? fromViewAid;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onLongPress: () => imageSaveDialog(
            context: context,
            title: videoItem.title,
            cover: videoItem.cover,
          ),
          onTap: () async {
            if (onTap != null) {
              onTap!();
              return;
            }
            if (videoItem.isPgc == true && videoItem.uri?.isNotEmpty == true) {
              if (PageUtils.viewPgcFromUri(videoItem.uri!)) {
                return;
              }
            }
            if (videoItem.bvid == null || videoItem.cid == null) {
              return;
            }
            try {
              PageUtils.toVideoPage(
                'bvid=${videoItem.bvid}&cid=${videoItem.cid}',
                arguments: {
                  'heroTag': Utils.makeHeroTag(videoItem.bvid),
                },
              );
            } catch (err) {
              SmartDialog.showToast(err.toString());
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: StyleString.safeSpace,
              vertical: 5,
            ),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints boxConstraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: StyleString.aspectRatio,
                      child: LayoutBuilder(
                        builder: (BuildContext context,
                            BoxConstraints boxConstraints) {
                          final double maxWidth = boxConstraints.maxWidth;
                          final double maxHeight = boxConstraints.maxHeight;
                          return Stack(
                            children: [
                              NetworkImgLayer(
                                src: videoItem.cover,
                                width: maxWidth,
                                height: maxHeight,
                              ),
                              if (fromViewAid == videoItem.param)
                                Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: StyleString.mdRadius,
                                      color: Colors.black54,
                                    ),
                                    child: Center(
                                      child: const Text(
                                        '上次观看',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (videoItem.badges?.isNotEmpty == true)
                                PBadge(
                                  text: videoItem.badges!
                                      .map((item) => item.text)
                                      .join('|'),
                                  right: 6.0,
                                  top: 6.0,
                                  type: videoItem.badges!.first.text == '充电专属'
                                      ? 'error'
                                      : 'primary',
                                ),
                              if (videoItem.history != null) ...[
                                Builder(builder: (context) {
                                  try {
                                    return Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: videoProgressIndicator(
                                        videoItem.history!['progress'] /
                                            videoItem.history!['duration'],
                                      ),
                                    );
                                  } catch (_) {
                                    return const SizedBox.shrink();
                                  }
                                }),
                                Builder(builder: (context) {
                                  try {
                                    return PBadge(
                                      text: videoItem.history!['progress'] ==
                                              videoItem.history!['duration']
                                          ? '已看完'
                                          : '${Utils.timeFormat(videoItem.history!['progress'])}/${Utils.timeFormat(videoItem.history!['duration'])}',
                                      right: 6.0,
                                      bottom: 6.0,
                                      type: 'gray',
                                    );
                                  } catch (_) {
                                    return PBadge(
                                      text:
                                          Utils.timeFormat(videoItem.duration),
                                      right: 6.0,
                                      bottom: 6.0,
                                      type: 'gray',
                                    );
                                  }
                                }),
                              ] else if (videoItem.duration > 0)
                                PBadge(
                                  text: Utils.timeFormat(videoItem.duration),
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
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 12,
          child: VideoPopupMenu(
            size: 29,
            iconSize: 17,
            videoItem: videoItem,
          ),
        ),
      ],
    );
  }

  Widget videoContent(context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              videoItem.title,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: videoItem.bvid != null && videoItem.bvid == bvid
                    ? FontWeight.bold
                    : null,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                height: 1.42,
                letterSpacing: 0.3,
                color: videoItem.bvid != null && videoItem.bvid == bvid
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            videoItem.season != null
                ? Utils.dateFormat(videoItem.season?['mtime'])
                : videoItem.publishTimeText ?? '',
            maxLines: 1,
            style: TextStyle(
              fontSize: 12,
              height: 1,
              color: Theme.of(context).colorScheme.outline,
              overflow: TextOverflow.clip,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              StatView(
                context: context,
                theme: 'gray',
                value: videoItem.stat.viewStr,
              ),
              const SizedBox(width: 8),
              StatDanMu(
                context: context,
                theme: 'gray',
                value: videoItem.stat.danmuStr,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
