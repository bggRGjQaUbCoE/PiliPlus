import 'package:PiliPlus/common/widgets/flutter/dyn/ink_well.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/dynamics/widgets/action_panel.dart';
import 'package:PiliPlus/pages/dynamics/widgets/author_panel.dart';
import 'package:PiliPlus/pages/dynamics/widgets/dyn_content.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart' hide InkWell;

class DynamicPanel extends StatelessWidget {
  final DynamicItemModel item;
  final double maxWidth;
  final bool isDetail;
  final ValueChanged? onRemove;
  final bool isSave;
  final Function(bool isTop, dynamic dynId)? onSetTop;
  final VoidCallback? onBlock;
  final VoidCallback? onUnfold;
  final bool isDetailPortraitW;

  const DynamicPanel({
    super.key,
    required this.item,
    required this.maxWidth,
    this.isDetail = false,
    this.onRemove,
    this.isSave = false,
    this.onSetTop,
    this.onBlock,
    this.onUnfold,
    this.isDetailPortraitW = true,
  });

  @override
  Widget build(BuildContext context) {
    if (item.visible == false) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    final authorWidget = AuthorPanel(
      item: item,
      isDetail: isDetail,
      onRemove: onRemove,
      isSave: isSave,
      onSetTop: onSetTop,
      onBlock: onBlock,
    );

    void showMore() => _imageSaveDialog(context, authorWidget.morePanel);

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
        onLongPress: showMore,
        onSecondaryTap: Utils.isMobile ? null : showMore,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              child: authorWidget,
            ),
            ...dynContent(
              context,
              theme: theme,
              isSave: isSave,
              isDetail: isDetail,
              item: item,
              floor: 1,
              maxWidth: maxWidth,
            ),
            const SizedBox(height: 2),
            if (!isDetail) ...[
              ActionPanel(item: item),
              if (item.modules.moduleFold case final moduleFold?) ...[
                Divider(
                  height: 1,
                  color: theme.dividerColor.withValues(alpha: 0.1),
                ),
                InkWell(
                  onTap: onUnfold,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text.rich(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1,
                        fontSize: 13,
                        color: theme.colorScheme.outline,
                      ),
                      strutStyle: const StrutStyle(
                        height: 1,
                        leading: 0,
                        fontSize: 13,
                      ),
                      TextSpan(
                        children: [
                          TextSpan(text: moduleFold.statement ?? '展开'),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              size: 19,
                              Icons.keyboard_arrow_down,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ] else if (!isSave)
              const SizedBox(height: 12),
          ],
        ),
      ),
    );
    if (isSave || (isDetail && !isDetailPortraitW)) {
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
        if (major?.archive case final archive?) {
          title = archive.title;
          cover = archive.cover;
          bvid = archive.bvid;
        }
        break;
      case 'DYNAMIC_TYPE_UGC_SEASON':
        if (major?.ugcSeason case final ugcSeason?) {
          title = ugcSeason.title;
          cover = ugcSeason.cover;
          bvid = ugcSeason.bvid;
        }
        break;
      case 'DYNAMIC_TYPE_PGC' || 'DYNAMIC_TYPE_PGC_UNION':
        if (major?.pgc case final pgc?) {
          title = pgc.title;
          cover = pgc.cover;
        }
        break;
      case 'DYNAMIC_TYPE_LIVE_RCMD':
        if (major?.liveRcmd case final liveRcmd?) {
          title = liveRcmd.title;
          cover = liveRcmd.cover;
        }
        break;
      case 'DYNAMIC_TYPE_LIVE':
        if (major?.live case final live?) {
          title = live.title;
          cover = live.cover;
        }
        break;
      case 'DYNAMIC_TYPE_COURSES_SEASON':
        if (major?.courses case final courses?) {
          title = courses.title;
          cover = courses.cover;
        }
        break;
      case 'DYNAMIC_TYPE_SUBSCRIPTION_NEW':
        if (major?.subscriptionNew?.liveRcmd?.content?.livePlayInfo
            case final livePlayInfo?) {
          title = livePlayInfo.title;
          cover = livePlayInfo.cover;
        }
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
