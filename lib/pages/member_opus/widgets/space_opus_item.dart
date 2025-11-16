import 'package:PiliPlus/common/widgets/flutter/dyn/ink_well.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models/common/stat_type.dart';
import 'package:PiliPlus/models_new/space/space_opus/item.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart' hide InkWell;

class SpaceOpusItem extends StatelessWidget {
  const SpaceOpusItem({
    super.key,
    required this.item,
    required this.maxWidth,
  });

  final SpaceOpusItemModel item;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final hasPic = item.cover?.url?.isNotEmpty == true;
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: InkWell(
        onTap: () => PageUtils.pushDynFromId(id: item.opusId!),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasPic)
              Stack(
                children: [
                  NetworkImgLayer(
                    width: maxWidth,
                    height: maxWidth * item.cover!.ratio,
                    src: item.cover!.url,
                    type: ImageType.emote,
                    quality: 60,
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 45,
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.only(left: 8, bottom: 4),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black54],
                        ),
                      ),
                      child: StatWidget(
                        type: StatType.like,
                        value: item.stat?.like,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            if (item.content?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                child: Text(
                  item.content!,
                  maxLines: hasPic ? 4 : 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (!hasPic)
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
                child: StatWidget(
                  type: StatType.like,
                  value: item.stat?.like,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
