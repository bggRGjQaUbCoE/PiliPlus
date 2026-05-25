import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models_new/sub/sub/list.dart';
import 'package:PiliPlus/pages/subscription_detail/view.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
    final type = switch (item.type) {
      11 => '收藏夹',
      21 => '合集',
      _ => '其它(${item.type})',
    };
    void onLongPress() => imageSaveDialog(
      title: item.title,
      cover: item.cover,
    );
    return Material(
      type: .transparency,
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
              },
            );
          } else {
            SubDetailPage.toSubDetailPage(
              item.id!,
              subInfo: item,
            );
          }
        },
        onLongPress: onLongPress,
        onSecondaryTap: PlatformUtils.isMobile ? null : onLongPress,
        child: Padding(
          padding: const .symmetric(horizontal: 12, vertical: 5),
          child: Row(
            crossAxisAlignment: .start,
            children: [
              AspectRatio(
                aspectRatio: Style.aspectRatio,
                child: LayoutBuilder(
                  builder: (context, boxConstraints) {
                    double maxWidth = boxConstraints.maxWidth;
                    double maxHeight = boxConstraints.maxHeight;
                    return Stack(
                      clipBehavior: .none,
                      children: [
                        NetworkImgLayer(
                          src: item.cover,
                          width: maxWidth,
                          height: maxHeight,
                        ),
                        PBadge(right: 6, top: 6, text: type),
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
        clipBehavior: .none,
        children: [
          Column(
            crossAxisAlignment: .start,
            children: [
              Expanded(
                child: Text(
                  item.title!,
                  maxLines: 2,
                  overflow: .ellipsis,
                  textAlign: .start,
                  style: const TextStyle(
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Text(
                'UP主: ${item.upper!.name!}',
                textAlign: .start,
                style: style,
                maxLines: 1,
                overflow: .ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${item.mediaCount}个视频',
                textAlign: .start,
                style: style,
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: -8,
            width: 29,
            height: 29,
            child: PopupMenuButton(
              padding: .zero,
              tooltip: '功能菜单',
              icon: Icon(
                Icons.more_vert_outlined,
                color: theme.colorScheme.outline,
                size: 18,
              ),
              position: .under,
              itemBuilder: (_) => [
                PopupMenuItem(
                  onTap: () => Get.toNamed('/member?mid=${item.upper?.mid}'),
                  height: 38,
                  child: Row(
                    children: [
                      const Icon(MdiIcons.accountCircleOutline, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '访问：${item.upper?.name}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  onTap: cancelSub,
                  height: 38,
                  child: const Row(
                    children: [
                      Icon(Icons.close_outlined, size: 16),
                      SizedBox(width: 6),
                      Text('取消订阅', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
