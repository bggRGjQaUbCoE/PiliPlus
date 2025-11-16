// 内容
import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/flutter/text/text.dart' as custom_text;
import 'package:PiliPlus/common/widgets/image/custom_grid_view.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/dynamics/widgets/rich_node_panel.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget content(
  BuildContext context, {
  required int floor,
  required ThemeData theme,
  required DynamicItemModel item,
  required bool isSave,
  required bool isDetail,
  required double maxWidth,
}) {
  if (floor == 1) {
    maxWidth -= 24;
  }
  TextSpan? richNodes = richNode(
    context,
    theme: theme,
    item: item,
    maxWidth: maxWidth,
  );
  final moduleDynamic = item.modules.moduleDynamic;
  final pics = moduleDynamic?.major?.opus?.pics;
  return Padding(
    padding: floor == 1
        ? const EdgeInsets.fromLTRB(12, 0, 12, 6)
        : const EdgeInsets.only(bottom: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (moduleDynamic?.topic case final topic?)
          GestureDetector(
            onTap: () => Get.toNamed(
              '/dynTopic',
              parameters: {
                'id': topic.id!.toString(),
                'name': topic.name!,
              },
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        size: 18,
                        CustomIcons.topic_tag,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  TextSpan(text: topic.name),
                ],
              ),
              style: TextStyle(
                fontSize: floor != 1
                    ? 14
                    : isDetail && !isSave
                    ? 16
                    : 15,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        if (richNodes != null)
          isDetail && floor == 1
              ? SelectableText.rich(
                  richNodes,
                  style: isSave
                      ? const TextStyle(fontSize: 15)
                      : const TextStyle(fontSize: 16),
                )
              : custom_text.Text.rich(
                  style: floor == 1
                      ? const TextStyle(fontSize: 15)
                      : const TextStyle(fontSize: 14),
                  richNodes,
                  maxLines: isSave ? null : 6,
                  onShowMore: () => PageUtils.pushDynDetail(item, isPush: true),
                  primary: theme.colorScheme.primary,
                ),
        if (pics?.isNotEmpty == true)
          CustomGridView(
            maxWidth: maxWidth,
            picArr: pics!
                .map(
                  (item) => ImageModel(
                    width: item.width,
                    height: item.height,
                    url: item.url ?? '',
                    liveUrl: item.liveUrl,
                  ),
                )
                .toList(),
            fullScreen: true,
          ),
      ],
    ),
  );
}
