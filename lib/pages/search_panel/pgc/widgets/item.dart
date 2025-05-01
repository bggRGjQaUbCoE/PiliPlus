import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image_save.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';

class SearchPgcItem extends StatelessWidget {
  const SearchPgcItem({
    super.key,
    required this.item,
  });

  final SearchMBangumiItemModel item;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle style = TextStyle(fontSize: 13);
    return InkWell(
      onTap: () {
        PageUtils.viewBangumi(seasonId: item.seasonId);
      },
      onLongPress: () => imageSaveDialog(
        title: item.title?.map((item) => item['text']).join() ?? '',
        cover: item.cover,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StyleString.safeSpace,
          vertical: StyleString.cardSpace,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                NetworkImgLayer(
                  width: 111,
                  height: 148,
                  src: item.cover,
                ),
                PBadge(
                  text: item.seasonTypeName,
                  top: 6.0,
                  right: 4.0,
                  bottom: null,
                  left: null,
                )
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      children: [
                        for (var i in item.title!) ...[
                          TextSpan(
                            text: i['text'],
                            style: TextStyle(
                              fontSize: theme.textTheme.titleSmall!.fontSize!,
                              fontWeight: FontWeight.bold,
                              color: i['type'] == 'em'
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('评分:${item.mediaScore?['score']}', style: style),
                  Row(
                    children: [
                      if (item.areas?.isNotEmpty == true)
                        Text(item.areas!, style: style),
                      const SizedBox(width: 3),
                      const Text('·'),
                      const SizedBox(width: 3),
                      Text(
                        Utils.dateFormat(item.pubtime).toString(),
                        style: style,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (item.styles?.isNotEmpty == true)
                        Text(item.styles!, style: style),
                      const SizedBox(width: 3),
                      const Text('·'),
                      const SizedBox(width: 3),
                      if (item.indexShow?.isNotEmpty == true)
                        Text(item.indexShow!, style: style),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
