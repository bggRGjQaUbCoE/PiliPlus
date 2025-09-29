import 'package:PiliPlus/models_new/search/search_trending/list.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HotKeyword extends StatelessWidget {
  final double width;
  final List<SearchTrendingItemModel> hotSearchList;
  final Function? onClick;
  const HotKeyword({
    super.key,
    required double width,
    required this.hotSearchList,
    this.onClick,
  }) : width = width / 2 - 4;

  @override
  Widget build(BuildContext context) {
    late final style = TextStyle(
      fontSize: 14,
      color: Theme.of(context).colorScheme.outline,
    );
    return Wrap(
      runSpacing: 0.4,
      spacing: 5.0,
      children: [
        for (var i in hotSearchList)
          SizedBox(
            width: width,
            child: Material(
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
                              imageUrl: ImageUtils.thumbnailUrl(i.icon!),
                              height: 15,
                            ),
                          )
                        else if (i.showLiveIcon == true)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Image.asset(
                              'assets/images/live/live.gif',
                              width: 48,
                              height: 15,
                            ),
                          )
                        else if (i.recommendReason?.isNotEmpty == true)
                          Text(i.recommendReason!, style: style),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
