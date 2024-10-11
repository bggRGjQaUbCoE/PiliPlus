import 'package:PiliPalaX/grpc/app/card/v1/card.pb.dart' as card;
import 'package:PiliPalaX/utils/app_scheme.dart';
import 'package:PiliPalaX/utils/id_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import '../../http/search.dart';
import '../../utils/utils.dart';
import '../constants.dart';
import 'badge.dart';
import 'network_img_layer.dart';
import 'stat/danmu.dart';
import 'stat/view.dart';
import 'video_popup_menu.dart';

// 视频卡片 - 水平布局
class VideoCardHGrpc extends StatelessWidget {
  const VideoCardHGrpc({
    super.key,
    required this.videoItem,
    this.longPress,
    this.longPressEnd,
    this.source = 'normal',
    this.showOwner = true,
    this.showView = true,
    this.showDanmaku = true,
    this.showPubdate = false,
  });
  // ignore: prefer_typing_uninitialized_variables
  final card.Card videoItem;
  final Function()? longPress;
  final Function()? longPressEnd;
  final String source;
  final bool showOwner;
  final bool showView;
  final bool showDanmaku;
  final bool showPubdate;

  @override
  Widget build(BuildContext context) {
    final int aid = videoItem.smallCoverV5.base.args.aid.toInt();
    final String bvid = IdUtils.av2bv(aid);
    String type = 'video';
    // try {
    //   type = videoItem.type;
    // } catch (_) {}
    // List<VideoCustomAction> actions =
    //     VideoCustomActions(videoItem, context).actions;
    final String heroTag = Utils.makeHeroTag(aid);
    return Stack(children: [
      Semantics(
        // label: Utils.videoItemSemantics(videoItem),
        excludeSemantics: true,
        // customSemanticsActions: <CustomSemanticsAction, void Function()>{
        //   for (var item in actions)
        //     CustomSemanticsAction(label: item.title): item.onTap!,
        // },
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onLongPress: () {
            if (longPress != null) {
              longPress!();
            }
          },
          onTap: () async {
            if (type == 'ketang') {
              SmartDialog.showToast('课堂视频暂不支持播放');
              return;
            }
            try {
              PiliScheme.routePush(Uri.parse(videoItem.smallCoverV5.base.uri));
              // final int cid =
              //     videoItem.smallCoverV5.base.playerArgs.cid.toInt() ??
              //         await SearchHttp.ab2c(aid: aid, bvid: bvid);
              // Get.toNamed('/video?bvid=$bvid&cid=$cid',
              //     arguments: {'heroTag': heroTag});
              // Get.toNamed('/video?bvid=$bvid&cid=$cid',
              //     arguments: {'videoItem': videoItem, 'heroTag': heroTag});
            } catch (err) {
              SmartDialog.showToast(err.toString());
            }
          },
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
                            Hero(
                              tag: heroTag,
                              child: NetworkImgLayer(
                                src: videoItem.smallCoverV5.base.cover,
                                width: maxWidth,
                                height: maxHeight,
                              ),
                            ),
                            if (videoItem
                                .smallCoverV5.coverRightText1.isNotEmpty)
                              PBadge(
                                text: Utils.timeFormat(
                                    videoItem.smallCoverV5.coverRightText1),
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
                  VideoContent(
                    videoItem: videoItem,
                    source: source,
                    showOwner: showOwner,
                    showView: showView,
                    showDanmaku: showDanmaku,
                    showPubdate: showPubdate,
                  )
                ],
              );
            },
          ),
        ),
      ),
      // if (source == 'normal')
      //   Positioned(
      //     bottom: 0,
      //     right: 0,
      //     child: VideoPopupMenu(
      //       size: 29,
      //       iconSize: 17,
      //       actions: actions,
      //     ),
      //   ),
    ]);
  }
}

class VideoContent extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final card.Card videoItem;
  final String source;
  final bool showOwner;
  final bool showView;
  final bool showDanmaku;
  final bool showPubdate;

  const VideoContent({
    super.key,
    required this.videoItem,
    this.source = 'normal',
    this.showOwner = true,
    this.showView = true,
    this.showDanmaku = true,
    this.showPubdate = false,
  });

  @override
  Widget build(BuildContext context) {
    // String pubdate = showPubdate
    //     ? Utils.dateFormat(videoItem.pubdate!, formatType: 'day')
    //     : '';
    // if (pubdate != '') pubdate += ' ';
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 6, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...[
              Expanded(
                child: Text(
                  videoItem.smallCoverV5.base.title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    height: 1.42,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
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
              Text(
                videoItem.smallCoverV5.rightDesc1,
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                  height: 1,
                  color: Theme.of(context).colorScheme.outline,
                  overflow: TextOverflow.clip,
                ),
              ),
            const SizedBox(height: 3),
            Text(
              videoItem.smallCoverV5.rightDesc2,
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                height: 1,
                color: Theme.of(context).colorScheme.outline,
                overflow: TextOverflow.clip,
              ),
            ),
            // Row(
            //   children: [
            //     if (showView) ...[
            //       StatView(
            //         theme: 'gray',
            //         view: videoItem.stat.view as int,
            //       ),
            //       const SizedBox(width: 8),
            //     ],
            //     if (showDanmaku)
            //       StatDanMu(
            //         theme: 'gray',
            //         danmu: videoItem.stat.danmu as int,
            //       ),
            //     const Spacer(),
            //     if (source == 'normal') const SizedBox(width: 24),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}