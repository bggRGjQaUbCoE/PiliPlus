import 'package:PiliPlus/common/widgets/image_save.dart';
import 'package:PiliPlus/common/widgets/video_progress_indicator.dart';
import 'package:PiliPlus/models/user/history.dart';
import 'package:PiliPlus/pages/common/multi_select_controller.dart';
import 'package:PiliPlus/pages/fav_search/controller.dart';
import 'package:PiliPlus/pages/history/base_controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/business_type.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HistoryItem extends StatelessWidget {
  final HisListItem videoItem;
  final dynamic ctr;
  final Function? onChoose;
  final Function? onDelete;

  const HistoryItem({
    super.key,
    required this.videoItem,
    this.ctr,
    this.onChoose,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    int aid = videoItem.history.oid!;
    String bvid = videoItem.history.bvid ?? IdUtils.av2bv(aid);
    return InkWell(
      onTap: () async {
        if ((ctr is MultiSelectController || ctr is HistoryBaseController) &&
            ctr!.enableMultiSelect.value) {
          feedBack();
          onChoose?.call();
          return;
        }
        if (videoItem.history.business?.contains('article') == true) {
          // int cid = videoItem.history.cid ??
          //     // videoItem.history.oid ??
          //     await SearchHttp.ab2c(aid: aid, bvid: bvid);
          // Get.toNamed(
          //   '/webview',
          //   parameters: {
          //     'url': 'https://www.bilibili.com/read/cv$cid',
          //     'type': 'note',
          //     'pageTitle': videoItem.title
          //   },
          // );
          Utils.toDupNamed(
            '/htmlRender',
            parameters: {
              'url': 'https://www.bilibili.com/read/cv${videoItem.history.oid}',
              'title': '',
              'id': 'cv${videoItem.history.oid}',
              'dynamicType': 'read'
            },
          );
        } else if (videoItem.history.business == 'live') {
          if (videoItem.liveStatus == 1) {
            // LiveItemModel liveItem = LiveItemModel.fromJson({
            //   'face': videoItem.authorFace,
            //   'roomid': videoItem.history.oid,
            //   'pic': videoItem.cover,
            //   'title': videoItem.title,
            //   'uname': videoItem.authorName,
            //   'cover': videoItem.cover,
            // });
            Get.toNamed('/liveRoom?roomid=${videoItem.history.oid}');
          } else {
            SmartDialog.showToast('直播未开播');
          }
        } else if (videoItem.history.business == 'pgc' ||
            videoItem.tagName?.contains('动画') == true) {
          /// hack
          var bvid = videoItem.history.bvid;
          if (bvid != null && bvid != '') {
            var result = await VideoHttp.videoIntro(bvid: bvid);
            if (result['status']) {
              String bvid = result['data'].bvid!;
              var epid = result['data'].epId;
              if (epid != null) {
                Utils.viewBangumi(epId: epid);
              } else {
                int cid = videoItem.history.cid ??
                    await SearchHttp.ab2c(aid: aid, bvid: bvid);
                Utils.toViewPage(
                  'bvid=$bvid&cid=$cid',
                  arguments: {
                    'heroTag': Utils.makeHeroTag(cid),
                    'pic': videoItem.cover,
                  },
                );
              }
            } else {
              SmartDialog.showToast(result['msg']);
            }
          } else {
            if (videoItem.history.epid != null && videoItem.history.epid != 0) {
              Utils.viewBangumi(epId: videoItem.history.epid);
            }
          }
        } else {
          int cid = videoItem.history.cid ??
              // videoItem.history.oid ??
              await SearchHttp.ab2c(aid: aid, bvid: bvid);
          Utils.toViewPage(
            'bvid=$bvid&cid=$cid',
            arguments: {
              'heroTag': Utils.makeHeroTag(aid),
              'pic': videoItem.cover,
            },
          );
        }
      },
      onLongPress: () {
        if (ctr is FavSearchController) {
          imageSaveDialog(
            context: context,
            title: videoItem.title,
            cover: videoItem.cover,
          );
          return;
        }
        if (!ctr!.enableMultiSelect.value) {
          feedBack();
          ctr!.enableMultiSelect.value = true;
          onChoose?.call();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StyleString.safeSpace,
          vertical: 5,
        ),
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            double width =
                (boxConstraints.maxWidth - StyleString.cardSpace * 6) / 2;
            return SizedBox(
              height: width / StyleString.aspectRatio,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: StyleString.aspectRatio,
                        child: LayoutBuilder(
                          builder: (context, boxConstraints) {
                            double maxWidth = boxConstraints.maxWidth;
                            double maxHeight = boxConstraints.maxHeight;
                            return Stack(
                              children: [
                                NetworkImgLayer(
                                  src: (videoItem.cover.isNullOrEmpty
                                      ? videoItem.covers?.first ?? ''
                                      : videoItem.cover),
                                  width: maxWidth,
                                  height: maxHeight,
                                ),
                                if (!BusinessType
                                    .hiddenDurationType.hiddenDurationType
                                    .contains(videoItem.history.business))
                                  PBadge(
                                    text: videoItem.progress == -1
                                        ? '已看完'
                                        : '${Utils.timeFormat(videoItem.progress)}/${Utils.timeFormat(videoItem.duration!)}',
                                    right: 6.0,
                                    bottom: 8.0,
                                    type: 'gray',
                                  ),
                                // 右上角
                                if (BusinessType.showBadge.showBadge
                                        .contains(videoItem.history.business) ||
                                    videoItem.history.business ==
                                        BusinessType.live.type)
                                  PBadge(
                                    text: videoItem.badge,
                                    top: 6.0,
                                    right: 6.0,
                                    bottom: null,
                                    left: null,
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                      Positioned.fill(
                        child: AnimatedOpacity(
                          opacity: videoItem.checked == true ? 1 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black.withOpacity(0.6),
                            ),
                            child: SizedBox(
                              width: 34,
                              height: 34,
                              child: AnimatedScale(
                                scale: videoItem.checked == true ? 1 : 0,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                child: IconButton(
                                  tooltip: '取消选择',
                                  style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                        EdgeInsets.zero),
                                    backgroundColor:
                                        WidgetStateProperty.resolveWith(
                                      (states) {
                                        return Theme.of(context)
                                            .colorScheme
                                            .surface
                                            .withOpacity(0.8);
                                      },
                                    ),
                                  ),
                                  onPressed: () {
                                    feedBack();
                                    onChoose?.call();
                                  },
                                  icon: Icon(Icons.done_all_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (videoItem.duration != null &&
                          videoItem.duration != 0 &&
                          videoItem.progress != 0)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: videoProgressIndicator(
                            videoItem.progress == -1
                                ? 1
                                : videoItem.progress / videoItem.duration!,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  videoContent(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget videoContent(context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            videoItem.title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              letterSpacing: 0.3,
            ),
            maxLines: videoItem.videos! > 1 ? 1 : 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (videoItem.isFullScreen != null) ...[
            const SizedBox(height: 2),
            Text(
              videoItem.isFullScreen,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                  color: Theme.of(context).colorScheme.outline),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const Spacer(),
          if (videoItem.authorName != '')
            Row(
              children: [
                Text(
                  videoItem.authorName!,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Utils.dateFormat(videoItem.viewAt!),
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                    color: Theme.of(context).colorScheme.outline),
              ),
              // if (videoItem is HisListItem)
              SizedBox(
                width: 29,
                height: 29,
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  tooltip: '功能菜单',
                  icon: Icon(
                    Icons.more_vert_outlined,
                    color: Theme.of(context).colorScheme.outline,
                    size: 18,
                  ),
                  position: PopupMenuPosition.under,
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    if (videoItem.authorMid != null &&
                        videoItem.authorName?.isNotEmpty == true)
                      PopupMenuItem<String>(
                        onTap: () {
                          Get.toNamed(
                            '/member?mid=${videoItem.authorMid}',
                            arguments: {
                              'heroTag': '${videoItem.authorMid}',
                            },
                          );
                        },
                        height: 35,
                        child: Row(
                          children: [
                            Icon(MdiIcons.accountCircleOutline, size: 16),
                            SizedBox(width: 6),
                            Text(
                              '访问：${videoItem.authorName}',
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                      ),
                    if (videoItem.history.business != 'pgc' &&
                        videoItem.badge != '番剧' &&
                        videoItem.tagName?.contains('动画') != true &&
                        videoItem.history.business != 'live' &&
                        videoItem.history.business?.contains('article') != true)
                      PopupMenuItem<String>(
                        onTap: () async {
                          var res = await UserHttp.toViewLater(
                              bvid: videoItem.history.bvid);
                          SmartDialog.showToast(res['msg']);
                        },
                        height: 35,
                        child: const Row(
                          children: [
                            Icon(Icons.watch_later_outlined, size: 16),
                            SizedBox(width: 6),
                            Text('稍后再看', style: TextStyle(fontSize: 13))
                          ],
                        ),
                      ),
                    PopupMenuItem<String>(
                      onTap: () => ctr!.delHistory(
                          videoItem.kid, videoItem.history.business),
                      height: 35,
                      child: const Row(
                        children: [
                          Icon(Icons.close_outlined, size: 16),
                          SizedBox(width: 6),
                          Text('删除记录', style: TextStyle(fontSize: 13))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
