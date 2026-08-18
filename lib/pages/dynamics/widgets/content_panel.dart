// 内容
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/image_grid/image_grid_view.dart';
import 'package:PiliPlus/common/widgets/selection_text.dart';
import 'package:PiliPlus/common/widgets/text_more/text_more.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/dynamics/widgets/rich_node_panel.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/extension/selectable_region_ext.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:material_ui/material_ui.dart';
import 'package:get/get.dart';

part 'package:PiliPlus/common/widgets/context_menu/dyn_menu_helper.dart';

Widget content(
  BuildContext context, {
  required int floor,
  required ThemeData theme,
  required DynamicItemModel item,
  required bool isSave,
  required bool isDetail,
  bool isLongImageMode = false,
}) {
  TextSpan? richNodes = richNode(
    context,
    theme: theme,
    item: item,
  );
  final moduleDynamic = item.modules.moduleDynamic;
  final pics = moduleDynamic?.major?.opus?.pics;
  final text =
      moduleDynamic?.desc?.text ?? moduleDynamic?.major?.opus?.summary?.text;
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
              ? SelectionText.rich(
                  richNodes,
                  style: isSave
                      ? const TextStyle(fontSize: 15)
                      : const TextStyle(fontSize: 16),
                  contextMenuBuilder: text == null || text.isEmpty
                      ? null
                      : (_, state) => dynTextMenuBuilder(
                          state,
                          text,
                          item.modules.moduleDynamic,
                        ),
                )
              : TextMore.rich(
                  style: floor == 1
                      ? const TextStyle(fontSize: 15)
                      : const TextStyle(fontSize: 14),
                  richNodes,
                  maxLines: isSave ? null : 6,
                  onShowMore: () => PageUtils.pushDynDetail(item, isPush: true),
                  primary: theme.colorScheme.primary,
                ),
        if (pics != null && pics.isNotEmpty)
          isLongImageMode
              ? Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxWidth = constraints.maxWidth;
                      return Column(
                        spacing: 5,
                        children: pics.map((pic) {
                          final w = (pic.width ?? 1).toDouble();
                          final h = (pic.height ?? 1).toDouble();
                          final ratio = h / w;
                          final height = (maxWidth * ratio).clamp(
                            0.0,
                            maxWidth * 4,
                          );
                          final isTruncated = ratio > 4;
                          return ClipRRect(
                            borderRadius: BorderRadius.all(Style.imgRadius),
                            child: SizedBox(
                              width: maxWidth,
                              height: height,
                              child: Stack(
                                children: [
                                  NetworkImgLayer(
                                    src: pic.url ?? '',
                                    width: maxWidth,
                                    height: height,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                  ),
                                  if (isTruncated) ...[
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      height: 60,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              theme.colorScheme.surface,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const PBadge(
                                      text: '长图',
                                      right: 8,
                                      bottom: 8,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                )
              : ImageGridView(
                  fullScreen: true,
                  picArr: pics
                      .map(
                        (item) => ImageModel(
                          width: item.width,
                          height: item.height,
                          url: item.url ?? '',
                          liveUrl: item.liveUrl,
                        ),
                      )
                      .toList(),
                ),
      ],
    ),
  );
}
