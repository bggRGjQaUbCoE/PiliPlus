import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/dynamics/widgets/additional_panel.dart';
import 'package:PiliPlus/pages/dynamics/widgets/blocked_item.dart';
import 'package:PiliPlus/pages/dynamics/widgets/content_panel.dart';
import 'package:PiliPlus/pages/dynamics/widgets/module_panel.dart';
import 'package:flutter/material.dart';

List<Widget> dynContent(
  BuildContext context, {
  required int floor,
  required ThemeData theme,
  required DynamicItemModel item,
  required bool isSave,
  required bool isDetail,
  required double maxWidth,
}) {
  final moduleDynamic = item.modules.moduleDynamic;
  return [
    if (item.type != 'DYNAMIC_TYPE_NONE')
      content(
        context,
        theme: theme,
        isSave: isSave,
        isDetail: isDetail,
        item: item,
        floor: floor,
        maxWidth: maxWidth,
      ),
    module(
      context,
      theme: theme,
      isSave: isSave,
      isDetail: isDetail,
      item: item,
      floor: floor,
      maxWidth: maxWidth,
    ),
    if (moduleDynamic?.additional case final additional?)
      addWidget(
        theme: theme,
        context,
        idStr: item.idStr,
        additional: additional,
        floor: floor,
      ),
    if (moduleDynamic?.major?.blocked case final blocked?)
      blockedItem(theme: theme, blocked: blocked, maxWidth: maxWidth),
  ];
}
