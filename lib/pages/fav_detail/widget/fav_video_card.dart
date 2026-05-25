import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/select_mask.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/grpc/bilibili/app/listener/v1.pbenum.dart'
    show PlaylistSource;
import 'package:PiliPlus/models_new/fav/fav_detail/media.dart';
import 'package:PiliPlus/pages/audio/view.dart';
import 'package:PiliPlus/pages/fav_detail/controller.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// 收藏视频卡片 - 水平布局
class FavVideoCardH extends StatelessWidget {
  final FavDetailItemModel item;
  final int? index;
  final BaseFavController? ctr;

  const FavVideoCardH({
    super.key,
    required this.item,
    this.index,
    this.ctr,
  }) : assert(ctr == null || index != null);

  bool get isSort => ctr == null;

  @override
  Widget build(BuildContext context) {
    final isOwner = !isSort && ctr!.isOwner;
    late final enableMultiSelect = ctr?.enableMultiSelect.value ?? false;
    final colorScheme = ColorScheme.of(context);

    final onLongPress = isSort || enableMultiSelect
        ? null
        : isOwner && !enableMultiSelect
        ? () {
            ctr!
              ..enableMultiSelect.value = true
              ..onSelect(item);
          }
        : () => imageSaveDialog(
            title: item.title,
            cover: item.cover,
            bvid: item.bvid,
          );

    return Material(
      type: .transparency,
      child: InkWell(
        onTap: isSort
            ? null
            : enableMultiSelect
            ? () => ctr!.onSelect(item)
            : () {
                if (!const [0, 16].contains(item.attr)) {
                  Get.toNamed('/member?mid=${item.upper?.mid}');
                  return;
                }

                switch (item.type) {
                  case 12:
                    AudioPage.toAudioPage(
                      oid: item.id!,
                      itemType: 3,
                      from: PlaylistSource.AUDIO_CARD,
                    );
                    break;
                  case 24:
                    PageUtils.viewPgc(
                      seasonId: item.ogv!.seasonId,
                      epId: item.id,
                    );
                    break;
                  default:
                    ctr!.onViewFav(item, index);
                    break;
                }
              },
        onLongPress: onLongPress,
        onSecondaryTap: PlatformUtils.isMobile ? null : onLongPress,
        child: Padding(
          padding: const .symmetric(horizontal: Style.safeSpace, vertical: 5),
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
                        PBadge(
                          text: DurationUtils.formatDuration(item.duration),
                          right: 6.0,
                          bottom: 6.0,
                          type: .gray,
                        ),
                        if (item.type == 12)
                          const PBadge(
                            text: '音频',
                            top: 6.0,
                            right: 6.0,
                            type: .gray,
                          )
                        else
                          PBadge(
                            text: item.ogv?.typeName,
                            top: 6.0,
                            right: 6.0,
                            bottom: null,
                            left: null,
                          ),
                        if (!isSort)
                          Positioned.fill(
                            child: selectMask(colorScheme, item.checked),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              content(context, colorScheme, isOwner),
            ],
          ),
        ),
      ),
    );
  }

  Widget content(BuildContext context, ColorScheme colorScheme, bool isOwner) {
    return Expanded(
      child: Stack(
        clipBehavior: .none,
        children: [
          Column(
            spacing: 3,
            crossAxisAlignment: .start,
            children: [
              Text(
                item.title!,
                textAlign: .start,
                style: const TextStyle(
                  letterSpacing: 0.3,
                ),
                maxLines: 2,
                overflow: .ellipsis,
              ),
              if (item.type == 24 && item.intro?.isNotEmpty == true)
                Text(
                  item.intro!,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.outline,
                  ),
                ),
              const Spacer(),
              Text(
                '${DateFormatUtils.dateFormat(item.favTime)} ${item.upper?.name}',
                maxLines: 1,
                overflow: .ellipsis,
                style: TextStyle(
                  height: 1,
                  fontSize: 12,
                  color: colorScheme.outline,
                ),
              ),
              if (item.type != 24)
                Row(
                  spacing: 8,
                  children: [
                    StatWidget(
                      type: .play,
                      value: item.cntInfo?.play,
                    ),
                    StatWidget(
                      type: .danmaku,
                      value: item.cntInfo?.danmaku,
                    ),
                  ],
                ),
            ],
          ),
          if (isOwner)
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
                  color: colorScheme.outline,
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
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('提示'),
                        content: const Text('要取消收藏吗?'),
                        actions: [
                          TextButton(
                            onPressed: Get.back,
                            child: Text(
                              '取消',
                              style: TextStyle(color: colorScheme.outline),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                              ctr!.onCancelFav(index!, item.id!, item.type!);
                            },
                            child: const Text('确定取消'),
                          ),
                        ],
                      ),
                    ),
                    height: 38,
                    child: const Row(
                      children: [
                        Icon(Icons.close_outlined, size: 16),
                        SizedBox(width: 6),
                        Text('取消收藏', style: TextStyle(fontSize: 13)),
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
