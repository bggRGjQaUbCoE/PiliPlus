// 内容
import 'package:PiliPlus/common/widgets/image/image_view.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/dynamics/widgets/rich_node_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget content(
  ThemeData theme,
  bool isSave,
  BuildContext context,
  DynamicItemModel item,
  String? source,
  Function(List<String>, int)? callback, {
  floor = 1,
}) {
  InlineSpan picsNodes() {
    return WidgetSpan(
      child: LayoutBuilder(
        builder: (context, constraints) => imageView(
          constraints.maxWidth,
          (item.modules.moduleDynamic!.major!.opus!.pics as List)
              .map(
                (item) => ImageModel(
                  width: item.width,
                  height: item.height,
                  url: item.url ?? '',
                  liveUrl: item.liveUrl,
                ),
              )
              .toList(),
          callback: callback,
        ),
      ),
    );
  }

  TextSpan? richNodes = richNode(theme, item, context);

  return Padding(
    padding: floor == 1
        ? const EdgeInsets.fromLTRB(12, 0, 12, 6)
        : const EdgeInsets.only(bottom: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.modules.moduleDynamic?.topic != null) ...[
          GestureDetector(
            onTap: () {
              Get.toNamed(
                '/dynTopic',
                parameters: {
                  'id': item.modules.moduleDynamic!.topic!.id!.toString(),
                  'name': item.modules.moduleDynamic!.topic!.name!,
                },
              );
            },
            child: Text(
              '#${item.modules.moduleDynamic!.topic!.name}',
              style: TextStyle(
                fontSize: source == 'detail' && !isSave ? 16 : 15,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
        if (richNodes != null)
          source == 'detail'
              ? SelectableText.rich(
                  richNodes,
                  style: isSave
                      ? const TextStyle(fontSize: 15)
                      : const TextStyle(fontSize: 16),
                )
              : Text.rich(
                  style: const TextStyle(fontSize: 15),
                  richNodes,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
        if (item.modules.moduleDynamic?.major?.opus?.pics?.isNotEmpty == true)
          Text.rich(picsNodes()),
      ],
    ),
  );
}
