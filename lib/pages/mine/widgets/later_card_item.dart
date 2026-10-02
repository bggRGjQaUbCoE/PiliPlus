import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/later/list.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// 稍后再看快捷卡片（我的页面横向列表）
class LaterCardItem extends StatelessWidget {
  const LaterCardItem({
    super.key,
    required this.item,
    required this.index,
    required this.count,
  });

  final LaterItemModel item;
  final int index;
  final int? count;

  static const double _cardWidth = 180.0;
  static const double _cardHeight = 110.0;

  void _toVideoPage(int cid) {
    PageUtils.toVideoPage(
      aid: item.aid,
      bvid: item.bvid,
      cid: cid,
      cover: item.pic,
      title: item.title,
      extraArguments: {
        'oid': item.aid,
        'sourceType': SourceType.watchLater,
        'count': count,
        'favTitle': '稍后再看',
        'mediaId': Accounts.main.mid,
        'desc': false,
        if (index != 0) 'isContinuePlaying': true,
      },
    );
  }

  Future<void> _onTap() async {
    if (item.isPugv ?? false) {
      PageUtils.viewPugv(seasonId: item.aid);
      return;
    }
    if (item.isPgc ?? false) {
      if (item.bangumi?.epId != null) {
        PageUtils.viewPgc(epId: item.bangumi!.epId);
      } else if (item.redirectUrl?.isNotEmpty == true) {
        PageUtils.viewPgcFromUri(item.redirectUrl!);
      }
      return;
    }
    try {
      final int? cid =
          item.cid ??
          await SearchHttp.ab2c(
            aid: item.aid,
            bvid: item.bvid,
          );
      if (cid != null) {
        _toVideoPage(cid);
      }
    } catch (err) {
      SmartDialog.showToast(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDuration = item.duration != null && item.duration != 0;
    final subtitle = item.owner?.name ?? item.subtitle ?? '';

    return GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.onInverseSurface.withValues(
                    alpha: 0.4,
                  ),
                  offset: const Offset(6, -8),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: SizedBox(
                width: _cardWidth,
                height: _cardHeight,
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    NetworkImgLayer(
                      src: item.pic,
                      width: _cardWidth,
                      height: _cardHeight,
                      cacheWidth: item.dimension?.cacheWidth,
                    ),
                    if (item.isCharging == true)
                      const PBadge(
                        text: '充电专属',
                        top: 6.0,
                        right: 6.0,
                        type: PBadgeType.error,
                      )
                    else if (item.rights?.isCooperation == 1)
                      const PBadge(
                        text: '合作',
                        top: 6.0,
                        right: 6.0,
                      )
                    else if (item.pgcLabel?.isNotEmpty == true)
                      PBadge(
                        text: item.pgcLabel,
                        top: 6.0,
                        right: 6.0,
                      )
                    else if (item.isPugv ?? false)
                      const PBadge(
                        text: '课堂',
                        top: 6.0,
                        right: 6.0,
                      ),
                    if (hasDuration)
                      PBadge(
                        text: item.progress == -1
                            ? '已看完'
                            : item.progress != null && item.progress != 0
                            ? '${DurationUtils.formatDuration(item.progress)}/${DurationUtils.formatDuration(item.duration)}'
                            : DurationUtils.formatDuration(item.duration),
                        right: 6.0,
                        bottom: 6.0,
                        type: PBadgeType.gray,
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: _cardWidth,
            child: Text(
              ' ${item.title ?? ''}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: theme.textTheme.bodySmall,
            ),
          ),
          SizedBox(
            width: _cardWidth,
            child: Text(
              ' $subtitle',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: theme.textTheme.labelSmall!.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
