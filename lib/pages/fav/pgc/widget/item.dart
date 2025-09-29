import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/select_mask.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models_new/fav/fav_pgc/list.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
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
  final MultiSelectBase ctr;
  final VoidCallback onSelect;
  final VoidCallback onUpdateStatus;

  void onLongPress() {
    if (!ctr.enableMultiSelect.value) {
      ctr.enableMultiSelect.value = true;
      onSelect();
    }
  }

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
            onLongPress: Utils.isMobile ? onLongPress : null,
            onSecondaryTap: Utils.isMobile ? null : onLongPress,
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
                                  child: selectMask(
                                    theme,
                                    item.checked == true,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(4),
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
