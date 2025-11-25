// 视频or合集
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

Widget videoSeasonWidget(
  BuildContext context, {
  required int floor,
  required ThemeData theme,
  required DynamicItemModel item,
  required bool isSave,
  required bool isDetail,
  required double maxWidth,
}) {
  return _VideoSeasonWidget(
    floor: floor,
    theme: theme,
    item: item,
    isSave: isSave,
    isDetail: isDetail,
    maxWidth: maxWidth,
  );
}

class _VideoSeasonWidget extends StatefulWidget {
  const _VideoSeasonWidget({
    required this.floor,
    required this.theme,
    required this.item,
    required this.isSave,
    required this.isDetail,
    required this.maxWidth,
  });

  final int floor;
  final ThemeData theme;
  final DynamicItemModel item;
  final bool isSave;
  final bool isDetail;
  final double maxWidth;

  @override
  State<_VideoSeasonWidget> createState() => _VideoSeasonWidgetState();
}

class _VideoSeasonWidgetState extends State<_VideoSeasonWidget> {
  bool _isHovering = false;
  bool _isInWatchLater = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final item = widget.item;
    final floor = widget.floor;
    final isDetail = widget.isDetail;
    double maxWidth = widget.maxWidth;
    // type archive  ugcSeason
    // archive 视频/显示发布人
    // ugcSeason 合集/不显示发布人

    DynamicArchiveModel? video = switch (item.type) {
      'DYNAMIC_TYPE_AV' => item.modules.moduleDynamic?.major?.archive,
      'DYNAMIC_TYPE_UGC_SEASON' => item.modules.moduleDynamic?.major?.ugcSeason,
      'DYNAMIC_TYPE_PGC' ||
      'DYNAMIC_TYPE_PGC_UNION' => item.modules.moduleDynamic?.major?.pgc,
      'DYNAMIC_TYPE_COURSES_SEASON' =>
        item.modules.moduleDynamic?.major?.courses,
      _ => null,
    };

    if (video == null) {
      return const SizedBox.shrink();
    }

    EdgeInsets padding;
    if (floor == 1) {
      maxWidth -= 24;
      padding = const EdgeInsets.symmetric(horizontal: 12);
    } else {
      padding = EdgeInsets.zero;
    }

    // 获取 bvid 用于稍后再看
    String? bvid = video.bvid;

    return MouseRegion(
      onEnter: Utils.isMobile
          ? null
          : (_) => setState(() => _isHovering = true),
      onExit: Utils.isMobile
          ? null
          : (_) => setState(() => _isHovering = false),
      child: Padding(
        padding: padding,
        child: Column(
          spacing: 6,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (video.cover case final cover?)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  NetworkImgLayer(
                    width: maxWidth,
                    height: maxWidth / StyleString.aspectRatio,
                    src: cover,
                    quality: 40,
                  ),
                  if (video.badge?.text case final badge?)
                    PBadge(
                      text: badge,
                      top: 8.0,
                      right: 10.0,
                      bottom: null,
                      left: null,
                      type: switch (badge) {
                        '充电专属' => PBadgeType.error,
                        _ => PBadgeType.primary,
                      },
                    ),
                  // 桌面端悬停显示稍后再看按钮（排除番剧类型）
                  if (!Utils.isMobile &&
                      _isHovering &&
                      bvid != null &&
                      item.type != 'DYNAMIC_TYPE_PGC' &&
                      item.type != 'DYNAMIC_TYPE_PGC_UNION')
                    Positioned(
                      top: 8,
                      right: 10,
                      child: _buildWatchLaterButton(bvid, video.aid),
                    ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 70,
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.fromLTRB(10, 0, 8, 8),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black54,
                          ],
                        ),
                        borderRadius: BorderRadius.vertical(
                          bottom: StyleString.imgRadius,
                        ),
                      ),
                      child: DefaultTextStyle.merge(
                        style: TextStyle(
                          fontSize: theme.textTheme.labelMedium!.fontSize,
                          color: Colors.white,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (video.durationText
                                case final durationText?) ...[
                              DecoratedBox(
                                decoration: const BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                child: Text(' $durationText '),
                              ),
                              const SizedBox(width: 6),
                            ],
                            if (video.stat case final stat?) ...[
                              Text(
                                '${NumUtils.numFormat(stat.play)}次围观',
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${NumUtils.numFormat(stat.danmu)}条弹幕',
                              ),
                            ],
                            const Spacer(),
                            Image.asset(
                              'assets/images/play.png',
                              width: 50,
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (video.title case final title?)
              Text(
                title,
                maxLines: isDetail ? null : 1,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: isDetail ? null : TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWatchLaterButton(String bvid, int? aid) {
    return Material(
      color: _isInWatchLater
          ? Colors.green.withValues(alpha: 0.8)
          : Colors.black54,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () async {
          if (_isInWatchLater) {
            // 取消稍后再看
            if (aid != null) {
              var res = await UserHttp.toViewDel(aids: aid.toString());
              SmartDialog.showToast(res['msg']);
              if (res['status'] == true) {
                setState(() => _isInWatchLater = false);
              }
            }
          } else {
            // 添加稍后再看
            var res = await UserHttp.toViewLater(bvid: bvid);
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
}
