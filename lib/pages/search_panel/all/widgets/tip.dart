import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

/// 搜索页顶部的提示卡片，用于心理危机干预场景。
///
/// 卡片内容全部来自服务端 `tips` 模块（标题、副标题、背景图、跳转地址），
/// 客户端只做通用渲染，因此运营侧调整文案无需发版。
class SearchTipItem extends StatelessWidget {
  const SearchTipItem({
    super.key,
    required this.item,
  });

  final SearchTip item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final hasBgImg = item.hasBgImg == 1 && (item.cover?.isNotEmpty ?? false);
    final jumpUrl = item.jumpUrl;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          child: InkWell(
            onTap: jumpUrl == null || jumpUrl.isEmpty
                ? null
                : () => PiliScheme.routePushFromUrl(jumpUrl),
            child: Stack(
              children: [
                if (hasBgImg)
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: ImageUtils.thumbnailUrl(item.cover!, 1),
                      fit: BoxFit.cover,
                      placeholder: (_, _) => const SizedBox.shrink(),
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 84),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.title?.isNotEmpty ?? false)
                          Text(
                            item.title!,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                        if (item.subTitle?.isNotEmpty ?? false) ...[
                          const SizedBox(height: 6),
                          Text(
                            item.subTitle!,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
