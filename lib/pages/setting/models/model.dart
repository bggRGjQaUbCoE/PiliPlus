import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:PiliPlus/pages/setting/widgets/normal_item.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/switch_item.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

@immutable
sealed class SettingsModel {
  final String? subtitle;
  final Widget? leading;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? titleStyle;

  String? get title;
  Widget get widget;
  String get effectiveTitle;
  String? get effectiveSubtitle;

  const SettingsModel({
    this.subtitle,
    this.leading,
    this.contentPadding,
    this.titleStyle,
  });
}

class NormalModel extends SettingsModel {
  @override
  final String? title;
  final ValueGetter<String>? getTitle;
  final ValueGetter<String>? getSubtitle;
  final Widget Function()? getTrailing;
  final void Function(BuildContext context, VoidCallback setState)? onTap;

  const NormalModel({
    super.subtitle,
    super.leading,
    super.contentPadding,
    super.titleStyle,
    this.title,
    this.getTitle,
    this.getSubtitle,
    this.getTrailing,
    this.onTap,
  }) : assert(title != null || getTitle != null);

  @override
  String get effectiveTitle => title ?? getTitle!();
  @override
  String? get effectiveSubtitle => subtitle ?? getSubtitle?.call();

  @override
  Widget get widget => NormalItem(
    title: title,
    getTitle: getTitle,
    subtitle: subtitle,
    getSubtitle: getSubtitle,
    leading: leading,
    getTrailing: getTrailing,
    onTap: onTap,
    contentPadding: contentPadding,
    titleStyle: titleStyle,
  );
}

class SwitchModel extends SettingsModel {
  @override
  final String title;
  final String setKey;
  final bool defaultVal;
  final ValueChanged<bool>? onChanged;
  final bool needReboot;
  final void Function(BuildContext context)? onTap;

  const SwitchModel({
    super.subtitle,
    super.leading,
    super.contentPadding,
    super.titleStyle,
    required this.title,
    required this.setKey,
    this.defaultVal = false,
    this.onChanged,
    this.needReboot = false,
    this.onTap,
  });

  @override
  String get effectiveTitle => title;
  @override
  String? get effectiveSubtitle => subtitle;

  @override
  Widget get widget => SetSwitchItem(
    title: title,
    subtitle: subtitle,
    setKey: setKey,
    defaultVal: defaultVal,
    onChanged: onChanged,
    needReboot: needReboot,
    leading: leading,
    onTap: onTap,
    contentPadding: contentPadding,
    titleStyle: titleStyle,
  );
}

SettingsModel getBanWordModel({
  required String title,
  required String key,
  required ValueChanged<RegExp> onChanged,
}) {
  String banWord = GStorage.setting.get(key, defaultValue: '');
  return NormalModel(
    leading: const Icon(Icons.filter_alt_outlined),
    title: title,
    getSubtitle: () => banWord.isEmpty ? "点击添加" : banWord,
    onTap: (context, setState) {
      String editValue = banWord;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            constraints: StyleString.dialogFixedConstraints,
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('使用|隔开，如：尝试|测试'),
                TextFormField(
                  autofocus: true,
                  initialValue: editValue,
                  textInputAction: TextInputAction.newline,
                  minLines: 1,
                  maxLines: 4,
                  onChanged: (value) => editValue = value,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: Get.back,
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              TextButton(
                child: const Text('保存'),
                onPressed: () {
                  Get.back();
                  banWord = editValue;
                  setState();
                  onChanged(RegExp(banWord, caseSensitive: false));
                  SmartDialog.showToast('已保存');
                  GStorage.setting.put(key, banWord);
                },
              ),
            ],
          );
        },
      );
    },
  );
}

SettingsModel getVideoFilterSelectModel({
  required String title,
  String? subtitle,
  String? suffix,
  required String key,
  required List<int> values,
  int defaultValue = 0,
  bool isFilter = true,
  ValueChanged<int>? onChanged,
}) {
  assert(!isFilter || onChanged != null);
  int value = GStorage.setting.get(key, defaultValue: defaultValue);
  return NormalModel(
    title: '$title${isFilter ? '过滤' : ''}',
    leading: const Icon(Icons.timelapse_outlined),
    subtitle: subtitle,
    getSubtitle: subtitle == null
        ? () => isFilter
              ? '过滤掉$title小于「$value${suffix ?? ""}」的视频'
              : '当前$title:「$value${suffix ?? ""}」'
        : null,
    onTap: (context, setState) async {
      var result = await showDialog<int>(
        context: context,
        builder: (context) {
          return SelectDialog<int>(
            title: '选择$title${isFilter ? '（0即不过滤）' : ''}',
            value: value,
            values:
                (values
                      ..addIf(!values.contains(value), value)
                      ..sort())
                    .map(
                      (e) => (e, suffix == null ? e.toString() : '$e $suffix'),
                    )
                    .toList()
                  ..add((-1, '自定义')),
          );
        },
      );
      if (result != null) {
        if (result == -1 && context.mounted) {
          await showDialog(
            context: context,
            builder: (context) {
              String valueStr = '';
              return AlertDialog(
                title: Text('自定义$title'),
                content: TextField(
                  autofocus: true,
                  onChanged: (value) => valueStr = value,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(suffixText: suffix),
                ),
                actions: [
                  TextButton(
                    onPressed: Get.back,
                    child: Text(
                      '取消',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                      result = int.tryParse(valueStr) ?? 0;
                    },
                    child: const Text('确定'),
                  ),
                ],
              );
            },
          );
        }
        if (result != -1) {
          value = result!;
          setState();
          onChanged?.call(result!);
          GStorage.setting.put(key, result);
        }
      }
    },
  );
}

SettingsModel getPopupMenuModel({
  required String title,
  Widget? leading,
  String? subtitle,
  required String key,
  required List<EnumWithLabel> values,
  int defaultIndex = 0,
}) {
  // final globalKey = GlobalKey<PopupMenuButtonState<EnumWithLabel>>();
  return NormalModel(
    title: title,
    subtitle: subtitle,
    leading: leading,
    // onTap: (context, setState) => globalKey.currentState?.showButtonMenu(),
    getTrailing: () => Builder(
      builder: (context) {
        final color = ColorScheme.of(context).secondary;
        final v = values[GStorage.setting.get(key, defaultValue: defaultIndex)];
        return PopupMenuButton(
          // key: globalKey,
          padding: .zero,
          initialValue: v,
          onSelected: (value) async {
            await GStorage.setting.put(key, value.index);
            if (context.mounted) {
              (context as Element).markNeedsBuild();
            }
          },
          itemBuilder: (context) => values
              .map((i) => PopupMenuItem(value: i, child: Text(i.label)))
              .toList(),
          child: Padding(
            padding: const .symmetric(vertical: 8),
            child: Text.rich(
              style: TextStyle(fontSize: 14, height: 1, color: color),
              strutStyle: const StrutStyle(leading: 0, height: 1, fontSize: 14),
              TextSpan(
                children: [
                  TextSpan(text: v.label),
                  WidgetSpan(
                    alignment: .middle,
                    child: Icon(
                      size: 14,
                      MdiIcons.unfoldMoreHorizontal,
                      color: color,
                    ),
                  ),
                ],
                style: TextStyle(color: color),
              ),
            ),
          ),
        );
      },
    ),
  );
}
