import 'package:PiliPlus/common/widgets/image_save.dart';
import 'package:PiliPlus/models/model_hot_video_item.dart';
import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../../http/search.dart';
import '../../utils/utils.dart';
import '../constants.dart';
import 'badge.dart';
import 'network_img_layer.dart';
import 'stat/stat.dart';
import 'video_popup_menu.dart';

// 视频卡片 - 水平布局
class VideoCardH extends StatelessWidget {
  const VideoCardH({
    super.key,
    required this.videoItem,
    this.source = 'normal',
    this.showOwner = true,
    this.showView = true,
    this.showDanmaku = true,
    this.showPubdate = false,
    this.onTap,
    this.onLongPress,
    this.onViewLater,
  });
  final BaseVideoItemModel videoItem;
  final String source;
  final bool showOwner;
  final bool showView;
  final bool showDanmaku;
  final bool showPubdate;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final ValueChanged<int>? onViewLater;

  @override
  Widget build(BuildContext context) {
    final int aid = videoItem.aid!;
    final String bvid = videoItem.bvid!;
    String type = 'video';
    // try {
    //   type = videoItem.type;
    // } catch (_) {}
    if (videoItem is SearchVideoItemModel) {
      var typeOrNull = (videoItem as SearchVideoItemModel).type;
      if (typeOrNull?.isNotEmpty == true) {
        type = typeOrNull!;
      }
    }
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Semantics(
            label: Utils.videoItemSemantics(videoItem),
            excludeSemantics: true,
            // customSemanticsActions: <CustomSemanticsAction, void Function()>{
            //   for (var item in actions)
            //     CustomSemanticsAction(
            //         label: item.title.isEmpty ? 'label' : item.title): item.onTap!,
            // },
            child: InkWell(
              onLongPress: () {
                if (onLongPress != null) {
                  onLongPress!();
                } else {
                  imageSaveDialog(
                    context: context,
                    title: videoItem.title,
                    cover: videoItem.pic,
                  );
                }
              },
              onTap: () async {
                if (onTap != null) {
                  onTap!();
                  return;
                }
                if (type == 'ketang') {
                  SmartDialog.showToast('课堂视频暂不支持播放');
                  return;
                }
                if ((videoItem is HotVideoItemModel) &&
                    (videoItem as HotVideoItemModel).redirectUrl?.isNotEmpty ==
                        true) {
                  if (Utils.viewPgcFromUri(
                      (videoItem as HotVideoItemModel).redirectUrl!)) {
                    return;
                  }
                }
                try {
                  final int cid = videoItem.cid ??
                      await SearchHttp.ab2c(aid: aid, bvid: bvid);
                  if (source == 'later') {
                    onViewLater!(cid);
                  } else {
                    Utils.toViewPage(
                      'bvid=$bvid&cid=$cid',
                      arguments: {
                        'videoItem': videoItem,
                        'heroTag': Utils.makeHeroTag(aid)
                      },
                    );
                  }
                } catch (err) {
                  SmartDialog.showToast(err.toString());
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: StyleString.safeSpace,
                  vertical: 5,
                ),
                child: Row(
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
                                src: videoItem.pic,
                                width: maxWidth,
                                height: maxHeight,
                              ),
                              if (videoItem is HotVideoItemModel &&
                                  (videoItem as HotVideoItemModel)
                                          .pgcLabel
                                          ?.isNotEmpty ==
                                      true)
                                PBadge(
                                  text:
                                      (videoItem as HotVideoItemModel).pgcLabel,
                                  top: 6.0,
                                  right: 6.0,
                                ),
                              if (videoItem.duration > 0)
                                PBadge(
                                  text: Utils.timeFormat(videoItem.duration),
                                  right: 6.0,
                                  bottom: 6.0,
                                  type: 'gray',
                                ),
                              if (type != 'video')
                                PBadge(
                                  text: type,
                                  left: 6.0,
                                  bottom: 6.0,
                                  type: 'primary',
                                ),
                              // if (videoItem.rcmdReason != null &&
                              //     videoItem.rcmdReason.content != '')
                              //   pBadge(videoItem.rcmdReason.content, context,
                              //       6.0, 6.0, null, null),
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
            ),
          ),
          if (source == 'normal')
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
      ),
    );
  }

  Widget videoContent(BuildContext context) {
    String pubdate = showPubdate
        ? Utils.dateFormat(videoItem.pubdate!, formatType: 'day')
        : '';
    if (pubdate != '') pubdate += ' ';
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((videoItem is SearchVideoItemModel) &&
              (videoItem as SearchVideoItemModel).titleList?.isNotEmpty == true)
            Expanded(
              child: Text.rich(
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                TextSpan(
                  children: [
                    for (var i
                        in (videoItem as SearchVideoItemModel).titleList!)
                      TextSpan(
                        text: i['text'],
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                          height: 1.42,
                          letterSpacing: 0.3,
                          color: i['type'] == 'em'
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Text(
                videoItem.title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  height: 1.42,
                  letterSpacing: 0.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          // const Spacer(),
          // if (videoItem.rcmdReason != null &&
          //     videoItem.rcmdReason.content != '')
          //   Container(
          //     padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(4),
          //       border: Border.all(
          //           color: Theme.of(context).colorScheme.surfaceTint),
          //     ),
          //     child: Text(
          //       videoItem.rcmdReason.content,
          //       style: TextStyle(
          //           fontSize: 9,
          //           color: Theme.of(context).colorScheme.surfaceTint),
          //     ),
          //   ),
          // const SizedBox(height: 4),
          if (showOwner || showPubdate)
            Expanded(
              flex: 0,
              child: Text(
                "$pubdate ${showOwner ? videoItem.owner.name : ''}",
                maxLines: 1,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
                  height: 1,
                  color: Theme.of(context).colorScheme.outline,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
          const SizedBox(height: 3),
          Row(
            children: [
              if (showView) ...[
                StatView(
                  context: context,
                  theme: 'gray',
                  value: videoItem.stat.viewStr,
                ),
                const SizedBox(width: 8),
              ],
              if (showDanmaku)
                StatDanMu(
                  context: context,
                  theme: 'gray',
                  value: videoItem.stat.danmuStr,
                ),
              const Spacer(),
              if (source == 'normal') const SizedBox(width: 24),
            ],
          ),
        ],
      ),
    );
  }
}
