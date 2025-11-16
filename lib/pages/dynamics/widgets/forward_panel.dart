import 'package:PiliPlus/common/widgets/flutter/dyn/ink_well.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/dynamics/widgets/dyn_content.dart';
import 'package:PiliPlus/pages/dynamics/widgets/module_panel.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart' hide InkWell;
import 'package:get/get.dart';

Widget forwardPanel(
  BuildContext context, {
  required int floor,
  required ThemeData theme,
  required DynamicItemModel orig,
  required bool isSave,
  required bool isDetail,
  required double maxWidth,
}) {
  final moduleDynamic = orig.modules.moduleDynamic;
  final major = moduleDynamic?.major;
  final isNoneMajor = major?.type == 'MAJOR_TYPE_NONE';

  Widget child;

  if (isNoneMajor) {
    child = noneWidget(theme, major?.none?.tips);
  } else {
    child = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _forwardAuthor(
          theme: theme,
          moduleAuthor: orig.modules.moduleAuthor!,
          isSave: isSave,
        ),
        const SizedBox(height: 5),
        ...dynContent(
          context,
          theme: theme,
          isSave: isSave,
          isDetail: isDetail,
          item: orig,
          floor: floor + 1,
          maxWidth: maxWidth - 30,
        ),
      ],
    );
  }

  child = Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
    color: theme.dividerColor.withValues(alpha: 0.08),
    child: child,
  );

  if (isNoneMajor) {
    return child;
  }

  void showMore() {
    String? title, cover, bvid;
    switch (orig.type) {
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
      default:
        return;
    }
    if (cover != null) {
      imageSaveDialog(
        title: title,
        cover: cover,
        bvid: bvid,
      );
    }
  }

  return InkWell(
    onTap: () => PageUtils.pushDynDetail(orig),
    onLongPress: showMore,
    onSecondaryTap: Utils.isMobile ? null : showMore,
    child: child,
  );
}

Widget _forwardAuthor({
  required ThemeData theme,
  required ModuleAuthorModel moduleAuthor,
  required bool isSave,
}) {
  final isNormalAuth = moduleAuthor.type == 'AUTHOR_TYPE_NORMAL';
  return Row(
    children: [
      GestureDetector(
        onTap: isNormalAuth
            ? () => Get.toNamed('/member?mid=${moduleAuthor.mid}')
            : null,
        child: Text(
          '${isNormalAuth ? '@' : ''}${moduleAuthor.name}',
          style: TextStyle(color: theme.colorScheme.primary),
        ),
      ),
      const SizedBox(width: 6),
      Text(
        isSave
            ? DateFormatUtils.format(
                moduleAuthor.pubTs,
                format: DateFormatUtils.longFormatDs,
              )
            : DateFormatUtils.dateFormat(moduleAuthor.pubTs),
        style: TextStyle(
          color: theme.colorScheme.outline,
          fontSize: theme.textTheme.labelSmall!.fontSize,
        ),
      ),
    ],
  );
}
