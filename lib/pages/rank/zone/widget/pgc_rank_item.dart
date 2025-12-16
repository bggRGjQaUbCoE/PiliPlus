import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/models/common/stat_type.dart';
import 'package:PiliPlus/models_new/pgc/pgc_rank/pgc_rank_item_model.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/material.dart';

class PgcRankItem extends StatelessWidget {
  const PgcRankItem({super.key, required this.item});

  final PgcRankItemModel item;

  @override
  Widget build(BuildContext context) {
    void onLongPress() => imageSaveDialog(
      title: item.title,
      cover: item.cover,
    );
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          if (item.url != null) {
            PiliScheme.routePushFromUrl(item.url!);
          }
        },
        onLongPress: onLongPress,
        onSecondaryTap: PlatformUtils.isMobile ? null : onLongPress,
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
                  builder: (context, constraints) {
                    return NetworkImgLayer(
                      radius: 6,
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      src: item.cover,
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(item.title!),
                    ),
                    if (item.newEp?.indexShow?.isNotEmpty == true) ...[
                      Text(
                        item.newEp!.indexShow!,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1,
                          color: Theme.of(context).colorScheme.outline,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Row(
                      children: [
                        StatWidget(
                          type: StatType.play,
                          value: item.stat!.view,
                        ),
                        const SizedBox(width: 8),
                        StatWidget(
                          type: StatType.follow,
                          value: item.stat!.follow,
                        ),
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
