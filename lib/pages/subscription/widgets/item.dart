import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models_new/sub/sub/list.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class SubItem extends StatelessWidget {
  final SubItemModel item;
  final VoidCallback cancelSub;
  const SubItem({
    super.key,
    required this.item,
    required this.cancelSub,
  });

  @override
  Widget build(BuildContext context) {
    String heroTag = Utils.makeHeroTag(item.id);
    final type = switch (item.type) {
      11 => '收藏夹',
      21 => '合集',
      _ => '其它(${item.type})',
    };
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          if (item.state == 1) {
            SmartDialog.showToast('该$type已失效');
            return;
          }
          if (item.type == 11) {
            Get.toNamed(
              '/favDetail',
              parameters: {
                'mediaId': item.id!.toString(),
                'heroTag': heroTag,
              },
            );
          } else {
            Get.toNamed(
              '/subDetail',
              arguments: item,
              parameters: {
                'heroTag': heroTag,
                'id': item.id.toString(),
              },
            );
          }
        },
        onLongPress: () => imageSaveDialog(
          title: item.title,
          cover: item.cover,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: StyleString.aspectRatio,
                child: LayoutBuilder(
                  builder: (context, boxConstraints) {
                    double maxWidth = boxConstraints.maxWidth;
                    double maxHeight = boxConstraints.maxHeight;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Hero(
                          tag: heroTag,
                          child: NetworkImgLayer(
                            src: item.cover,
                            width: maxWidth,
                            height: maxHeight,
                          ),
                        ),
                        PBadge(
                          right: 6,
                          top: 6,
                          text: type,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              content(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    final theme = Theme.of(context);
    final style = TextStyle(
      fontSize: 13,
      color: theme.colorScheme.outline,
    );
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title!,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  letterSpacing: 0.3,
                ),
              ),
              Text(
                'UP主: ${item.upper!.name!}',
                textAlign: TextAlign.start,
                style: style,
              ),
              Text(
                '${item.mediaCount}个视频',
                textAlign: TextAlign.start,
                style: style,
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              height: 35,
              width: 35,
              child: IconButton(
                onPressed: cancelSub,
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.outline,
                  padding: EdgeInsets.zero,
                ),
                icon: const Icon(Icons.delete_outline, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
