import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models_new/later/list.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class ToViewCardItem extends StatelessWidget {
  const ToViewCardItem({super.key, required this.item});

  final LaterItemModel item;

  static const double _cardWidth = 180.0;
  static const double _cardHeight = 110.0;

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
      final cid = item.cid ?? await SearchHttp.ab2c(aid: item.aid, bvid: item.bvid);
      if (cid != null) {
        PageUtils.toVideoPage(
          aid: item.aid,
          bvid: item.bvid,
          cid: cid,
          cover: item.pic,
          title: item.title,
        );
      }
    } catch (err) {
      SmartDialog.showToast(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDuration = item.duration != null && item.duration != 0;

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
                  color: theme.colorScheme.onInverseSurface.withValues(alpha: 0.4),
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
                    ),
                    if (item.pgcLabel?.isNotEmpty == true)
                      PBadge(
                        text: item.pgcLabel,
                        top: 6.0,
                        right: 6.0,
                        type: PBadgeType.primary,
                      ),
                    if (hasDuration)
                      PBadge(
                        text: item.progress == -1
                            ? '已看完'
                            : item.progress == null || item.progress == 0
                            ? DurationUtils.formatDuration(item.duration)
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
              ' ${item.owner?.name ?? ''}',
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
