import 'package:PiliPlus/common/widgets/image_save.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'action_panel.dart';
import 'author_panel.dart';
import 'content_panel.dart';
import 'forward_panel.dart';

class DynamicPanel extends StatelessWidget {
  final DynamicItemModel item;
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
    final authorWidget = AuthorPanel(
      item: item,
      source: source,
      onRemove: onRemove,
      isSave: isSave,
      onSetTop: onSetTop,
    );
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
                  const {
                    'DYNAMIC_TYPE_AV',
                    'DYNAMIC_TYPE_UGC_SEASON',
                    'DYNAMIC_TYPE_PGC_UNION',
                    'DYNAMIC_TYPE_PGC',
                    'DYNAMIC_TYPE_LIVE',
                    'DYNAMIC_TYPE_LIVE_RCMD',
                    'DYNAMIC_TYPE_MEDIALIST',
                  }.contains(item.type).not
              ? null
              : () => PageUtils.pushDynDetail(item, 1),
          onLongPress: () => _imageSaveDialog(context, authorWidget.morePanel),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                child: authorWidget,
              ),
              if (item.modules!.moduleDynamic!.desc != null ||
                  item.modules!.moduleDynamic!.major != null)
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

  void _imageSaveDialog(
    BuildContext context,
    Function(BuildContext) morePanel,
  ) {
    late String? title;
    late String? cover;
    late final major = item.modules?.moduleDynamic?.major;
    switch (item.type) {
      case 'DYNAMIC_TYPE_AV':
        title = major?.archive?.title;
        cover = major?.archive?.cover;
        break;
      case 'DYNAMIC_TYPE_UGC_SEASON':
        title = major?.ugcSeason?.title;
        cover = major?.ugcSeason?.cover;
        break;
      case 'DYNAMIC_TYPE_PGC' || 'DYNAMIC_TYPE_PGC_UNION':
        title = major?.pgc?.title;
        cover = major?.pgc?.cover;
        break;
      case 'DYNAMIC_TYPE_LIVE_RCMD':
        title = major?.liveRcmd?.title;
        cover = major?.liveRcmd?.cover;
        break;
      case 'DYNAMIC_TYPE_LIVE':
        title = major?.live?.title;
        cover = major?.live?.cover;
        break;
      default:
        morePanel(context);
        return;
    }
    imageSaveDialog(
      context: context,
      title: title,
      cover: cover,
    );
  }
}
