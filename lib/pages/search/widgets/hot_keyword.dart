import 'package:PiliPlus/models_new/search/search_trending/list.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SliverHotKeyword extends StatelessWidget {
  final List<SearchTrendingItemModel> hotSearchList;
  final Function? onClick;
  const SliverHotKeyword({
    super.key,
    required this.hotSearchList,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    late final style = TextStyle(
      fontSize: 14,
      color: ColorScheme.of(context).outline,
    );

    late final cacheHeight = (MediaQuery.devicePixelRatioOf(context) * 15.0)
        .round();

    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 5,
        crossAxisSpacing: 0.4,
        crossAxisCount: 2,
        mainAxisExtent: 15 + 12,
      ),
      itemCount: hotSearchList.length,
      itemBuilder: (context, index) {
        final i = hotSearchList[index];
        return Material(
          type: MaterialType.transparency,
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(3)),
            onTap: () => onClick?.call(i.keyword),
            child: Padding(
              padding: const EdgeInsets.only(left: 2, right: 10),
              child: Tooltip(
                message: i.keyword,
                child: Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(6, 5, 0, 5),
                        child: Text(
                          i.keyword!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    if (!i.icon.isNullOrEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: CachedNetworkImage(
                          height: 15,
                          memCacheHeight: cacheHeight,
                          imageUrl: ImageUtils.thumbnailUrl(i.icon!),
                          placeholder: (_, _) => const SizedBox.shrink(),
                        ),
                      )
                    else if (i.showLiveIcon == true)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Image.asset(
                          'assets/images/live/live.gif',
                          width: 48,
                          height: 15,
                          cacheHeight: cacheHeight,
                        ),
                      )
                    else if (i.recommendReason?.isNotEmpty == true)
                      Text(i.recommendReason!, style: style),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
