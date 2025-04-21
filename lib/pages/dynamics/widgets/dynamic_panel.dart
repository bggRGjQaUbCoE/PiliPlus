import 'package:PiliPlus/common/widgets/image_save.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'action_panel.dart';
import 'author_panel.dart';
import 'content_panel.dart';
import 'forward_panel.dart';

class DynamicPanel extends StatelessWidget {
  final dynamic item;
  final String? source;
  final Function? onRemove;
  final Function(List<String>, int)? callback;
  final bool isSave;
  final Function(bool isTop, dynamic dynId)? onSetTop;

  const DynamicPanel({
    super.key,
    required this.item,
    this.source,
    this.onRemove,
    this.callback,
    this.isSave = false,
    this.onSetTop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isSave ||
              (source == 'detail' &&
                  Get.context!.orientation == Orientation.landscape)
          ? null
          : BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 8,
                  color: Theme.of(context).dividerColor.withOpacity(0.05),
                ),
              ),
            ),
      child: Material(
        elevation: 0,
        color: Colors.transparent,
        child: InkWell(
          onTap: source == 'detail' &&
                  [
                    'DYNAMIC_TYPE_AV',
                    'DYNAMIC_TYPE_UGC_SEASON',
                    'DYNAMIC_TYPE_PGC_UNION',
                    'DYNAMIC_TYPE_PGC',
                    'DYNAMIC_TYPE_LIVE',
                    'DYNAMIC_TYPE_LIVE_RCMD',
                    'DYNAMIC_TYPE_MEDIALIST',
                  ].contains(item.type).not
              ? null
              : () => PageUtils.pushDynDetail(item, 1),
          onLongPress: () {
            if (item.type == 'DYNAMIC_TYPE_AV') {
              imageSaveDialog(
                context: context,
                title: item.modules.moduleDynamic.major.archive.title,
                cover: item.modules.moduleDynamic.major.archive.cover,
              );
            } else if (item.type == 'DYNAMIC_TYPE_UGC_SEASON') {
              imageSaveDialog(
                context: context,
                title: item.modules.moduleDynamic.major.ugcSeason.title,
                cover: item.modules.moduleDynamic.major.ugcSeason.cover,
              );
            } else if (item.type == 'DYNAMIC_TYPE_PGC' ||
                item.type == 'DYNAMIC_TYPE_PGC_UNION') {
              imageSaveDialog(
                context: context,
                title: item.modules.moduleDynamic.major.pgc.title,
                cover: item.modules.moduleDynamic.major.pgc.cover,
              );
            } else if (item.type == 'DYNAMIC_TYPE_LIVE_RCMD') {
              imageSaveDialog(
                context: context,
                title: item.modules.moduleDynamic.major.liveRcmd.title,
                cover: item.modules.moduleDynamic.major.liveRcmd.cover,
              );
            } else if (item.type == 'DYNAMIC_TYPE_LIVE') {
              imageSaveDialog(
                context: context,
                title: item.modules.moduleDynamic.major.live.title,
                cover: item.modules.moduleDynamic.major.live.cover,
              );
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                child: AuthorPanel(
                  item: item,
                  source: source,
                  onRemove: onRemove,
                  isSave: isSave,
                  onSetTop: onSetTop,
                ),
              ),
              if (item!.modules!.moduleDynamic!.desc != null ||
                  item!.modules!.moduleDynamic!.major != null)
                content(isSave, context, item, source, callback),
              forWard(isSave, item, context, source, callback),
              const SizedBox(height: 2),
              if (source == null) ActionPanel(item: item),
              if (source == 'detail' && !isSave) const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
