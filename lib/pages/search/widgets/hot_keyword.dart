import 'package:PiliPlus/models/search/search_trending/trending_list.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HotKeyword extends StatelessWidget {
  final double width;
  final List<SearchKeywordList> hotSearchList;
  final Function? onClick;
  final bool showMore;
  const HotKeyword({
    super.key,
    required double width,
    required this.hotSearchList,
    this.onClick,
    this.showMore = true,
  }) : this.width = width / 2 - 4;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 0.4,
      spacing: 5.0,
      children: [
        for (var i in hotSearchList)
          SizedBox(
            width: width,
            child: Material(
              color: Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
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
                              imageUrl: i.icon!.http2https,
                              height: 15,
                            ),
                          )
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
