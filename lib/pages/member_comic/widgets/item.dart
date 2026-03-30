import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/flutter/layout_builder.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/material.dart' hide LayoutBuilder;
import 'package:get/get.dart';

class MemberComicItem extends StatelessWidget {
  const MemberComicItem({super.key, required this.item});

  final SpaceArchiveItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    late final style = TextStyle(
      fontSize: 13,
      color: theme.colorScheme.onSurfaceVariant,
    );
    void onLongPress() => imageSaveDialog(title: item.title, cover: item.cover);
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          Get.toNamed(
            '/webview',
            parameters: {
              'url': 'https://manga.bilibili.com/detail/mc${item.param}',
            },
          );
        },
        onLongPress: onLongPress,
        onSecondaryTap: PlatformUtils.isMobile ? null : onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Style.safeSpace,
            vertical: 5,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 3 / 4,
                child: LayoutBuilder(
                  builder:
                      (BuildContext context, BoxConstraints boxConstraints) {
                        return NetworkImgLayer(
                          src: item.cover,
                          width: boxConstraints.maxWidth,
                          height: boxConstraints.maxHeight,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
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
                    Text(item.title),
                    if (item.styles != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        item.styles!,
                        style: style,
                      ),
                    ],
                    if (item.label != null) ...[
                      Text(
                        item.label!,
                        style: style,
                      ),
                    ],
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
