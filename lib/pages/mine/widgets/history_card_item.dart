import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models_new/history/list.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:PiliPlus/http/search.dart';

/// 观看记录快捷卡片（我的页面横向列表）
class HistoryCardItem extends StatelessWidget {
  const HistoryCardItem({super.key, required this.item});

  final HistoryItemModel item;

  // 宽高比与 HistoryItem 大图区一致（16:10）
  static const double _cardWidth = 180.0;
  static const double _cardHeight = 110.0;

  bool get _isArticle =>
      item.history.business?.contains('article') == true;

  bool get _isLive => item.history.business == 'live';

  bool get _isPgc => item.history.business == 'pgc';

  bool get _isCheese => item.history.business == 'cheese';

  bool get _isVideo => !_isArticle && !_isLive && !_isPgc && !_isCheese;

  void _onTap() async {
    final business = item.history.business;
    if (_isArticle) {
      PageUtils.toDupNamed(
        '/articlePage',
        parameters: {
          'id': business == 'article-list'
              ? '${item.history.cid}'
              : '${item.history.oid}',
          'type': 'read',
        },
      );
    } else if (_isLive) {
      if (item.liveStatus == 1) {
        PageUtils.toLiveRoom(item.history.oid);
      } else {
        SmartDialog.showToast('直播未开播');
      }
    } else if (_isPgc) {
      PageUtils.viewPgc(epId: item.history.epid);
    } else if (_isCheese) {
      if (item.uri?.isNotEmpty == true) {
        PageUtils.viewPgcFromUri(
          item.uri!,
          isPgc: false,
          aid: item.history.oid,
        );
      }
    } else {
      final int aid = item.history.oid!;
      final String bvid = item.history.bvid ?? IdUtils.av2bv(aid);
      int? cid =
          item.history.cid ??
          await SearchHttp.ab2c(
            aid: aid,
            bvid: bvid,
            part: item.history.page,
          );
      if (cid != null) {
        PageUtils.toVideoPage(
          aid: aid,
          bvid: bvid,
          cid: cid,
          cover: item.cover,
          title: item.title,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDuration = item.duration != null && item.duration != 0;
    final coverSrc = item.cover?.isNotEmpty == true
        ? item.cover
        : item.covers?.firstOrNull ?? '';

    return GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 封面区域
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
                      src: coverSrc,
                      width: _cardWidth,
                      height: _cardHeight,
                    ),
                    // 右上角：直播状态 / 专栏标记 / pgc badge
                    if (_isLive)
                      PBadge(
                        text: item.liveStatus == 1 ? '直播中' : '未开播',
                        top: 6.0,
                        right: 6.0,
                        type: item.liveStatus == 1
                            ? PBadgeType.primary
                            : PBadgeType.gray,
                      )
                    else if (_isArticle)
                      const PBadge(
                        text: '专栏',
                        top: 6.0,
                        right: 6.0,
                        type: PBadgeType.secondary,
                      )
                    else if (item.badge?.isNotEmpty == true)
                      PBadge(
                        text: item.badge,
                        top: 6.0,
                        right: 6.0,
                        type: PBadgeType.primary,
                      ),
                    // 右下角：视频进度（只显示角标文字，无进度条）
                    if (_isVideo && hasDuration)
                      PBadge(
                        text: item.progress == -1
                            ? '已看完'
                            : '${DurationUtils.formatDuration(item.progress)}/${DurationUtils.formatDuration(item.duration)}',
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
          // 标题
          SizedBox(
            width: _cardWidth,
            child: Text(
              ' ${item.title ?? ''}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: theme.textTheme.bodySmall,
            ),
          ),
          // 副标题（作者名 / showTitle）
          SizedBox(
            width: _cardWidth,
            child: Text(
              ' ${item.authorName ?? item.showTitle ?? ''}',
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
