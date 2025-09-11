import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/stat_type.dart';
import 'package:PiliPlus/models_new/space/space_audio/item.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class MemberAudioItem extends StatelessWidget {
  const MemberAudioItem({super.key, required this.item});

  final SpaceAudioItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasStat = item.statistic != null;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () async {
          // TODO music play
          final aid = item.aid;
          if (aid != null) {
            final cid = await SearchHttp.ab2c(aid: aid);
            if (cid != null) {
              PageUtils.toVideoPage(cid: cid, aid: aid);
              return;
            }
          }
          SmartDialog.showToast('没有MV');
          return;
        },
        onLongPress: () =>
            imageSaveDialog(title: item.title, cover: item.cover),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: StyleString.safeSpace,
            vertical: 5,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: LayoutBuilder(
                  builder:
                      (BuildContext context, BoxConstraints boxConstraints) {
                        return NetworkImgLayer(
                          radius: 4,
                          src: item.cover,
                          width: boxConstraints.maxWidth,
                          height: boxConstraints.maxHeight,
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
                    Text(
                      item.title!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DateFormatUtils.dateFormat(
                        hasStat ? item.ctime! ~/ 1000 : item.ctime!,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (hasStat)
                      Row(
                        spacing: 16,
                        children: [
                          StatWidget(
                            type: StatType.listen,
                            value: item.statistic!.play,
                          ),
                          StatWidget(
                            type: StatType.reply,
                            value: item.statistic!.comment,
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
