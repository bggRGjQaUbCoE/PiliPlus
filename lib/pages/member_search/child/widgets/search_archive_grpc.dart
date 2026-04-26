import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/flutter/layout_builder.dart';
import 'package:PiliPlus/common/widgets/image/image_save.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/stat/stat.dart';
import 'package:PiliPlus/grpc/bilibili/app/interfaces/v1.pb.dart' show Arc;
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/stat_type.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/em.dart';
import 'package:PiliPlus/utils/extension/dimension_ext.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:fixnum/fixnum.dart' show Int64;
import 'package:flutter/material.dart' hide LayoutBuilder;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SearchArchiveGrpc extends StatelessWidget {
  const SearchArchiveGrpc({
    super.key,
    required this.item,
  });

  final Arc item;

  @override
  Widget build(BuildContext context) {
    final arc = item.archive;
    final bvid = IdUtils.av2bv(arc.aid.toInt());
    final regTitle = Em.regTitle(arc.title);
    final titleStr = regTitle.map((e) => e.text).join();
    void onLongPress() => imageSaveDialog(
      bvid: bvid,
      title: titleStr,
      cover: arc.pic,
    );
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onLongPress: onLongPress,
            onSecondaryTap: PlatformUtils.isMobile ? null : onLongPress,
            onTap: () {
              if (item.isPugv) {
                PageUtils.viewPgcFromUri(item.uri, isPgc: false);
                return;
              }
              if (arc.hasRedirectUrl()) {
                PageUtils.viewPgcFromUri(arc.redirectUrl);
                return;
              }
              PageUtils.toVideoPage(
                bvid: bvid,
                cid: arc.firstCid.toInt(),
                cover: arc.pic,
                title: titleStr,
                isVertical: arc.dimension.isVertical,
              );
            },
            child: Padding(
              padding: const .symmetric(
                horizontal: Style.safeSpace,
                vertical: 5,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: Style.aspectRatio,
                    child: LayoutBuilder(
                      builder: (context, boxConstraints) {
                        final double maxWidth = boxConstraints.maxWidth;
                        final double maxHeight = boxConstraints.maxHeight;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            NetworkImgLayer(
                              src: arc.pic,
                              width: maxWidth,
                              height: maxHeight,
                            ),
                            if (item.isPugv)
                              const PBadge(
                                text: '课堂',
                                top: 6.0,
                                right: 6.0,
                              ),
                            if (arc.duration > Int64.ZERO)
                              PBadge(
                                text: DurationUtils.formatDuration(
                                  arc.duration.toInt(),
                                ),
                                right: 6.0,
                                bottom: 6.0,
                                type: PBadgeType.gray,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  content(context, regTitle),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 12,
            width: 29,
            height: 29,
            child: PopupMenuButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.more_vert_outlined,
                color: Theme.of(context).colorScheme.outline,
                size: 17,
              ),
              position: PopupMenuPosition.under,
              itemBuilder: (context) => [
                PopupMenuItem(
                  height: 45,
                  onTap: () => Utils.copyText(bvid),
                  child: Row(
                    spacing: 6,
                    children: [
                      const Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(MdiIcons.identifier, size: 16),
                          Icon(MdiIcons.circleOutline, size: 16),
                        ],
                      ),
                      Text(bvid, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  height: 45,
                  onTap: () => UserHttp.toViewLater(bvid: bvid),
                  child: const Row(
                    spacing: 6,
                    children: [
                      Icon(MdiIcons.clockTimeEightOutline, size: 16),
                      Text('稍后再看', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget content(
    BuildContext context,
    List<({bool isEm, String text})> regTitle,
  ) {
    final arc = item.archive;
    final theme = Theme.of(context);
    String pubdate = DateFormatUtils.dateFormat(arc.pubdate.toInt());
    if (pubdate != '') pubdate += '  ';
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text.rich(
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              TextSpan(
                children: regTitle
                    .map(
                      (e) => TextSpan(
                        text: e.text,
                        style: TextStyle(
                          fontSize: theme.textTheme.bodyMedium!.fontSize,
                          height: 1.42,
                          letterSpacing: 0.3,
                          color: e.isEm
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Text(
            "$pubdate${arc.author.name}",
            maxLines: 1,
            style: TextStyle(
              fontSize: 12,
              height: 1,
              color: theme.colorScheme.outline,
              overflow: TextOverflow.clip,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            spacing: 8,
            children: [
              StatWidget(
                type: StatType.play,
                value: arc.stat.view,
              ),
              StatWidget(
                type: StatType.danmaku,
                value: arc.stat.danmaku,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
