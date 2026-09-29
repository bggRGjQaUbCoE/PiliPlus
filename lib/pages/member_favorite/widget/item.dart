import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models_new/space/space_fav/list.dart';
import 'package:PiliPlus/pages/subscription_detail/view.dart';
import 'package:PiliPlus/utils/bili_utils.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class MemberFavItem extends StatelessWidget {
  const MemberFavItem({super.key, required this.item, this.onDelete});

  final SpaceFavItemModel item;
  final ValueChanged<bool?>? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    void onLongPress() => imageSaveDialog(
      title: item.title,
      cover: item.cover,
    );
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () async {
          if (item.state == 1) {
            // invalid
            return;
          }

          if (item.type == 0 || item.type == 11) {
            final isDeleted = await Get.toNamed(
              '/favDetail',
              parameters: {
                'mediaId': item.id.toString(),
                'heroTag': Utils.makeHeroTag(item.id),
              },
            );
            onDelete?.call(isDeleted);
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
          padding: const EdgeInsets.symmetric(
            horizontal: Style.safeSpace,
            vertical: 5,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AspectRatio(
                    aspectRatio: Style.aspectRatio,
                    child: LayoutBuilder(
                      builder: (context, constraints) => NetworkImgLayer(
                        src: item.cover,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                      ),
                    ),
                  ),
                  if (item.type == 21)
                    PBadge(
                      right: 6,
                      top: 6,
                      text: L10n.current.collection,
                    )
                  else if (item.type == 11)
                    PBadge(
                      right: 6,
                      top: 6,
                      text: L10n.current.favouriteFolder,
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      item.type == 0
                          ? L10n.current.memberFavItemChildren2(
                              item.mediaCount.toString(),
                              BiliUtils.isPublicFavText(item.attr),
                            )
                          : item.type == 11
                          ? L10n.current.memberFavItemChildren(
                              item.mediaCount.toString(),
                              (item.upper?.name).toString(),
                            )
                          : item.type == 21
                          ? L10n.current.memberFavItemChildren3(
                              (item.upper?.name).toString(),
                              item.mediaCount.toString(),
                              NumUtils.numFormat(item.viewCount),
                            )
                          : L10n.current.favVideoItemContentChildren(
                              item.mediaCount.toString(),
                            ),
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.outline,
                      ),
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
