import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/progress_bar/video_progress_indicator.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/history_business_type.dart';
import 'package:PiliPlus/models_new/history/list.dart';
import 'package:PiliPlus/pages/common/multi_select_controller.dart';
import 'package:PiliPlus/utils/date_util.dart';
import 'package:PiliPlus/utils/duration_util.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HistoryItem extends StatelessWidget {
  final HistoryItemModel item;
  final MultiSelectMixin ctr;
  final void Function(int kid, String business) onDelete;

  const HistoryItem({
    super.key,
    required this.item,
    required this.ctr,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDuration = item.duration != null && item.duration != 0;
    int aid = item.history.oid!;
    String bvid = item.history.bvid ?? IdUtils.av2bv(aid);
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () async {
          if (ctr.enableMultiSelect.value) {
            ctr.onSelect(item);
            return;
          }
          if (item.history.business?.contains('article') == true) {
            PageUtils.toDupNamed(
              '/articlePage',
              parameters: {
                'id': item.history.business == 'article-list'
                    ? '${item.history.cid}'
                    : '${item.history.oid}',
                'type': 'read',
              },
            );
          } else if (item.history.business == 'live') {
            if (item.liveStatus == 1) {
              Get.toNamed('/liveRoom?roomid=${item.history.oid}');
            } else {
              SmartDialog.showToast('直播未开播');
            }
          } else if (item.history.business == 'pgc') {
            PageUtils.viewPgc(epId: item.history.epid);
          } else if (item.history.business == 'cheese') {
            if (item.uri?.isNotEmpty == true) {
              PageUtils.viewPgcFromUri(
                item.uri!,
                isPgc: false,
                aid: item.history.oid,
              );
            }
          } else {
            int? cid =
                item.history.cid ??
                await SearchHttp.ab2c(
                  aid: aid,
                  bvid: bvid,
                  part: item.history.page,
                );
            if (cid != null) {
              PageUtils.toVideoPage(
                'bvid=$bvid&cid=$cid',
                arguments: {
                  'heroTag': Utils.makeHeroTag(aid),
                  'pic': item.cover,
                },
              );
            }
          }
        },
        onLongPress: () {
          if (!ctr.enableMultiSelect.value) {
            ctr.enableMultiSelect.value = true;
            ctr.onSelect(item);
          }
          return;
          // imageSaveDialog(
          //   title: item.title,
          //   cover: item.cover,
          //   bvid: bvid,
          // );
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
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
                              src: item.cover?.isNotEmpty == true
                                  ? item.cover
                                  : item.covers?.firstOrNull ?? '',
                              width: maxWidth,
                              height: maxHeight,
                            ),
                            if (hasDuration)
                              PBadge(
                                text: item.progress == -1
                                    ? '已看完'
                                    : '${DurationUtil.formatDuration(item.progress)}/${DurationUtil.formatDuration(item.duration)}',
                                right: 6.0,
                                bottom: 8.0,
                                type: PBadgeType.gray,
                              ),
                            // 右上角
                            if (item.badge?.isNotEmpty == true)
                              PBadge(
                                text: item.badge,
                                top: 6.0,
                                right: 6.0,
                                type:
                                    item.history.business ==
                                            HistoryBusinessType.live.type &&
                                        item.liveStatus != 1
                                    ? PBadgeType.gray
                                    : PBadgeType.primary,
                              ),
                            if (hasDuration &&
                                item.progress != null &&
                                item.progress != 0)
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: videoProgressIndicator(
                                  item.progress == -1
                                      ? 1
                                      : item.progress! / item.duration!,
                                ),
                              ),
                            Positioned.fill(
                              child: AnimatedOpacity(
                                opacity: item.checked == true ? 1 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: StyleString.mdRadius,
                                    color: Colors.black.withValues(alpha: 0.6),
                                  ),
                                  child: SizedBox(
                                    width: 34,
                                    height: 34,
                                    child: AnimatedScale(
                                      scale: item.checked == true ? 1 : 0,
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      curve: Curves.easeInOut,
                                      child: IconButton(
                                        tooltip: '取消选择',
                                        style: ButtonStyle(
                                          padding: WidgetStateProperty.all(
                                            EdgeInsets.zero,
                                          ),
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                theme.colorScheme.surface
                                                    .withValues(alpha: 0.8),
                                              ),
                                        ),
                                        onPressed: () {
                                          feedBack();
                                          ctr.onSelect(item);
                                        },
                                        icon: Icon(
                                          Icons.done_all_outlined,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  content(theme),
                ],
              ),
            ),
            Positioned(
              right: 12,
              bottom: 0,
              child: SizedBox(
                width: 29,
                height: 29,
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  tooltip: '功能菜单',
                  icon: Icon(
                    Icons.more_vert_outlined,
                    color: theme.colorScheme.outline,
                    size: 18,
                  ),
                  position: PopupMenuPosition.under,
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        if (item.authorMid != null &&
                            item.authorName?.isNotEmpty == true)
                          PopupMenuItem<String>(
                            onTap: () =>
                                Get.toNamed('/member?mid=${item.authorMid}'),
                            height: 35,
                            child: Row(
                              children: [
                                const Icon(
                                  MdiIcons.accountCircleOutline,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '访问：${item.authorName}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        if (item.history.business != 'pgc' &&
                            item.badge != '番剧' &&
                            item.tagName?.contains('动画') != true &&
                            item.history.business != 'live' &&
                            item.history.business?.contains('article') != true)
                          PopupMenuItem<String>(
                            onTap: () async {
                              var res = await UserHttp.toViewLater(
                                bvid: item.history.bvid,
                              );
                              SmartDialog.showToast(res['msg']);
                            },
                            height: 35,
                            child: const Row(
                              children: [
                                Icon(Icons.watch_later_outlined, size: 16),
                                SizedBox(width: 6),
                                Text('稍后再看', style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        PopupMenuItem<String>(
                          onTap: () =>
                              onDelete(item.kid!, item.history.business!),
                          height: 35,
                          child: const Row(
                            children: [
                              Icon(Icons.close_outlined, size: 16),
                              SizedBox(width: 6),
                              Text('删除记录', style: TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget content(ThemeData theme) {
    return Expanded(
      child: Column(
        spacing: 2,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title!,
            style: TextStyle(
              fontSize: theme.textTheme.bodyMedium!.fontSize,
              height: 1.42,
              letterSpacing: 0.3,
            ),
            maxLines: item.videos! > 1 ? 1 : 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (item.history.business == 'pgc' &&
              item.showTitle?.isNotEmpty == true)
            Text(
              item.showTitle!,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.outline,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          const Spacer(),
          if (item.authorName?.isNotEmpty == true)
            Text(
              item.authorName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: theme.textTheme.labelMedium!.fontSize,
                color: theme.colorScheme.outline,
              ),
            ),
          Text(
            DateUtil.chatFormat(item.viewAt!, isHistory: true),
            style: TextStyle(
              fontSize: theme.textTheme.labelMedium!.fontSize,
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}
