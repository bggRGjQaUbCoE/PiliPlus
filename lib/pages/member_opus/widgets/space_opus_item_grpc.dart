import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/grpc/bilibili/app/dynamic/v2.pb.dart'
    show OpusFlowItem;
import 'package:PiliPlus/models/common/stat_type.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/foundation.dart' show clampDouble;
import 'package:material_ui/material_ui.dart';

class SpaceOpusItemGrpc extends StatelessWidget {
  const SpaceOpusItemGrpc({
    super.key,
    required this.item,
  });

  final OpusFlowItem item;

  @override
  Widget build(BuildContext context) {
    final flowItemOpus = item.flowItemOpus;
    final hasPic = flowItemOpus.hasCoverPic();
    final coverPic = hasPic ? flowItemOpus.coverPic : null;
    final hasExtend = item.hasExtend();
    final extend = hasExtend ? item.extend : null;
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: Style.borderRadius6),
      child: InkWell(
        onTap: () => PageUtils.pushDynFromId(id: item.oid.toString()),
        borderRadius: Style.borderRadius6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasPic)
              Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double height;
                      if (coverPic!.hasWidth() && coverPic.hasHeight()) {
                        height =
                            constraints.maxWidth *
                            clampDouble(
                              coverPic.height.toInt() / coverPic.width.toInt(),
                              0.68,
                              2.7,
                            );
                      } else {
                        height = constraints.maxWidth;
                      }
                      return NetworkImgLayer(
                        width: constraints.maxWidth,
                        height: height,
                        src: coverPic.src,
                        borderRadius: const .vertical(top: .circular(6)),
                        quality: 60,
                      );
                    },
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const .only(left: 8, top: 8, bottom: 4),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: .bottomCenter,
                          end: .topCenter,
                          colors: [Colors.black54, Colors.transparent],
                        ),
                      ),
                      child: StatWidget(
                        type: StatType.like,
                        value: flowItemOpus.bottomLeftText2.text,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            if (hasExtend)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                child: Text(
                  extend!.origDesc.map((e) => e.text).join(),
                  maxLines: hasPic ? 4 : 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (!hasPic)
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
                child: StatWidget(
                  type: StatType.like,
                  value: flowItemOpus.bottomLeftText2.text,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
