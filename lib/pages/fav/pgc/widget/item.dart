import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/list.dart';
import 'package:PiliPlus/pages/common/multi_select_controller.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';

class FavPgcItem extends StatelessWidget {
  const FavPgcItem({
    super.key,
    required this.item,
    required this.ctr,
    required this.onSelect,
    required this.onUpdateStatus,
  });

  final FavPgcItemModel item;
  final MultiSelectMixin ctr;
  final VoidCallback onSelect;
  final VoidCallback onUpdateStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: () {
              if (ctr.enableMultiSelect.value) {
                onSelect();
                return;
              }
              PageUtils.viewPgc(seasonId: item.seasonId);
            },
            onLongPress: () {
              if (!ctr.enableMultiSelect.value) {
                ctr.enableMultiSelect.value = true;
                onSelect();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StyleString.safeSpace,
                vertical: 5,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 3 / 4,
                    child: LayoutBuilder(
                      builder:
                          (
                            BuildContext context,
                            BoxConstraints boxConstraints,
                          ) {
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                NetworkImgLayer(
                                  radius: 4,
                                  src: item.cover,
                                  width: boxConstraints.maxWidth,
                                  height: boxConstraints.maxHeight,
                                ),
                                PBadge(
                                  right: 4,
                                  top: 4,
                                  text: item.badge,
                                  size: PBadgeSize.small,
                                  fontSize: 10,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                    vertical: 1,
                                  ),
                                ),
                                Positioned.fill(
                                  child: IgnorePointer(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) =>
                                          AnimatedOpacity(
                                            opacity: item.checked == true
                                                ? 1
                                                : 0,
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: constraints.maxHeight,
                                              width:
                                                  constraints.maxHeight *
                                                  StyleString.aspectRatio,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                      Radius.circular(4),
                                                    ),
                                                color: Colors.black.withValues(
                                                  alpha: 0.6,
                                                ),
                                              ),
                                              child: SizedBox(
                                                width: 34,
                                                height: 34,
                                                child: AnimatedScale(
                                                  scale: item.checked == true
                                                      ? 1
                                                      : 0,
                                                  duration: const Duration(
                                                    milliseconds: 250,
                                                  ),
                                                  curve: Curves.easeInOut,
                                                  child: IconButton(
                                                    tooltip: '取消选择',
                                                    style: ButtonStyle(
                                                      padding:
                                                          WidgetStateProperty.all(
                                                            EdgeInsets.zero,
                                                          ),
                                                      backgroundColor:
                                                          WidgetStatePropertyAll(
                                                            theme
                                                                .colorScheme
                                                                .surface
                                                                .withValues(
                                                                  alpha: 0.8,
                                                                ),
                                                          ),
                                                    ),
                                                    onPressed: null,
                                                    icon: Icon(
                                                      Icons.done_all_outlined,
                                                      color: theme
                                                          .colorScheme
                                                          .primary,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                              ],
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
                        Text(item.title!),
                        if (item.newEp?.indexShow != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            '${item.newEp!.indexShow}${item.isFinish == 0 && item.renewalTime?.isNotEmpty == true ? '，${item.renewalTime}' : ''}',
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        if (item.progress != null) ...[
                          SizedBox(
                            height: item.newEp?.indexShow != null ? 2 : 6,
                          ),
                          Text(
                            item.progress!,
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 0,
            child: iconButton(
              iconSize: 18,
              context: context,
              onPressed: onUpdateStatus,
              icon: Icons.more_vert,
              iconColor: theme.colorScheme.outline,
              bgColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
