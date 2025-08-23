import 'package:PiliPlus/common/widgets/dyn/ink_well.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/dynamics/widgets/action_panel.dart';
import 'package:PiliPlus/pages/dynamics/widgets/additional_panel.dart';
import 'package:PiliPlus/pages/dynamics/widgets/author_panel.dart';
import 'package:PiliPlus/pages/dynamics/widgets/blocked_item.dart';
import 'package:PiliPlus/pages/dynamics/widgets/content_panel.dart';
import 'package:PiliPlus/pages/dynamics/widgets/module_panel.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart' hide InkWell;

class DynamicPanel extends StatelessWidget {
  final DynamicItemModel item;
  final double maxWidth;
  final bool isDetail;
  final ValueChanged? onRemove;
  final Function(List<String>, int)? callback;
  final bool isSave;
  final Function(bool isTop, Object dynId)? onSetTop;
  final VoidCallback? onBlock;

  const DynamicPanel({
    super.key,
    required this.item,
    required this.maxWidth,
    this.isDetail = false,
    this.onRemove,
    this.callback,
    this.isSave = false,
    this.onSetTop,
    this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authorWidget = AuthorPanel(
      item: item,
      isDetail: isDetail,
      onRemove: onRemove,
      isSave: isSave,
      onSetTop: onSetTop,
      onBlock: onBlock,
    );
    final child = Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap:
            isDetail &&
                !const {
                  'DYNAMIC_TYPE_AV',
                  'DYNAMIC_TYPE_UGC_SEASON',
                  'DYNAMIC_TYPE_PGC_UNION',
                  'DYNAMIC_TYPE_PGC',
                  'DYNAMIC_TYPE_LIVE',
                  'DYNAMIC_TYPE_LIVE_RCMD',
                  'DYNAMIC_TYPE_MEDIALIST',
                  'DYNAMIC_TYPE_COURSES_SEASON',
                }.contains(item.type)
            ? null
            : () => PageUtils.pushDynDetail(item),
        onLongPress: () => _imageSaveDialog(context, authorWidget.morePanel),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              child: authorWidget,
            ),
            if (item.type != 'DYNAMIC_TYPE_NONE')
              content(
                theme,
                isSave,
                context,
                item,
                isDetail,
                callback,
                maxWidth: maxWidth,
              ),
            module(
              theme,
              isSave,
              item,
              context,
              isDetail,
              callback,
              maxWidth: maxWidth,
            ),
            if (item.modules.moduleDynamic?.additional != null)
              addWidget(theme, item, context),
            if (item.modules.moduleDynamic?.major?.blocked != null)
              blockedItem(
                theme,
                item.modules.moduleDynamic!.major!.blocked!,
                maxWidth: maxWidth,
              ),
            const SizedBox(height: 2),
            if (!isDetail) ActionPanel(item: item),
            if (isDetail && !isSave) const SizedBox(height: 12),
          ],
        ),
      ),
    );
    if (isSave || (isDetail && context.isLandscape)) {
      return child;
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 8,
            color: theme.dividerColor.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: child,
      ),
    );
  }

  void _imageSaveDialog(
    BuildContext context,
    Function(BuildContext) morePanel,
  ) {
    String? title;
    String? cover;
    String? bvid;
    late final major = item.modules.moduleDynamic?.major;
    switch (item.type) {
      case 'DYNAMIC_TYPE_AV':
        title = major?.archive?.title;
        cover = major?.archive?.cover;
        bvid = major?.archive?.bvid;
        break;
      case 'DYNAMIC_TYPE_UGC_SEASON':
        title = major?.ugcSeason?.title;
        cover = major?.ugcSeason?.cover;
        bvid = major?.ugcSeason?.bvid;
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
      case 'DYNAMIC_TYPE_COURSES_SEASON':
        title = major?.courses?.title;
        cover = major?.courses?.cover;
        break;
      default:
        morePanel(context);
        return;
    }
    imageSaveDialog(
      title: title,
      cover: cover,
      bvid: bvid,
    );
  }
}
