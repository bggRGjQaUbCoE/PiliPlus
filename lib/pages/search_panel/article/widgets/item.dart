import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchArticleItem extends StatelessWidget {
  const SearchArticleItem({super.key, required this.item});

  final SearchArticleItemModel item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = TextStyle(
      fontSize: theme.textTheme.labelSmall!.fontSize,
      color: theme.colorScheme.outline,
    );
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => Get.toNamed(
          '/articlePage',
          parameters: {
            'id': '${item.id}',
            'type': 'read',
          },
        ),
        onLongPress: () => imageSaveDialog(
          title: item.title.map((item) => item.text).join(),
          cover: item.imageUrls?.firstOrNull,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: StyleString.safeSpace,
            vertical: 5,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (item.imageUrls?.isNotEmpty == true)
                AspectRatio(
                  aspectRatio: StyleString.aspectRatio,
                  child: LayoutBuilder(
                    builder: (context, boxConstraints) {
                      double maxWidth = boxConstraints.maxWidth;
                      double maxHeight = boxConstraints.maxHeight;
                      return NetworkImgLayer(
                        width: maxWidth,
                        height: maxHeight,
                        src: item.imageUrls?.firstOrNull,
                      );
                    },
                  ),
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      maxLines: 2,
                      TextSpan(
                        children: item.title
                            .map(
                              (e) => TextSpan(
                                text: e.text,
                                style: TextStyle(
                                  color: e.isEm
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormatUtils.dateFormat(item.pubTime),
                      style: textStyle,
                    ),
                    Row(
                      children: [
                        Text('${item.view}浏览', style: textStyle),
                        Text(' • ', style: textStyle),
                        Text('${item.reply}评论', style: textStyle),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
