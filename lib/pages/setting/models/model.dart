import 'package:PiliPlus/models/common/settings_type.dart';
import 'package:PiliPlus/pages/setting/widgets/normal_item.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/switch_item.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

@immutable
class SettingsModel {
  final SettingsType settingsType;
  final String? title;
  final StringGetter? getTitle;
  final String? subtitle;
  final StringGetter? getSubtitle;
  final String? setKey;
  final bool defaultVal;
  final ValueChanged<bool>? onChanged;
  final bool needReboot;
  final Widget? leading;
  final Widget Function()? getTrailing;
  final Function? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? titleStyle;

  const SettingsModel({
    required this.settingsType,
    this.title,
    this.getTitle,
    this.subtitle,
    this.getSubtitle,
    this.setKey,
    this.defaultVal = false,
    this.onChanged,
    this.needReboot = false,
    this.leading,
    this.getTrailing,
    this.onTap,
    this.contentPadding,
    this.titleStyle,
  }) : assert(title != null || getTitle != null);

  Widget get widget => switch (settingsType) {
    SettingsType.normal => NormalItem(
      title: title,
      getTitle: getTitle,
      subtitle: subtitle,
      getSubtitle: getSubtitle,
      setKey: setKey,
      leading: leading,
      getTrailing: getTrailing,
      onTap: onTap,
      contentPadding: contentPadding,
      titleStyle: titleStyle,
    ),
    SettingsType.sw1tch => SetSwitchItem(
      title: title,
      subtitle: subtitle,
      setKey: setKey!,
      defaultVal: defaultVal,
      onChanged: onChanged,
      needReboot: needReboot,
      leading: leading,
      onTap: onTap,
      contentPadding: contentPadding,
      titleStyle: titleStyle,
    ),
  };
}

SettingsModel getBanwordModel({
  required BuildContext context,
  required String title,
  required String key,
  required ValueChanged<RegExp> onChanged,
}) {
  String banWord = GStorage.setting.get(key, defaultValue: '');
  return SettingsModel(
    settingsType: SettingsType.normal,
    leading: const Icon(Icons.filter_alt_outlined),
    title: title,
    getSubtitle: () => banWord.isEmpty ? "点击添加" : banWord,
    onTap: (setState) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('使用|隔开，如：尝试|测试'),
                TextFormField(
                  autofocus: true,
                  initialValue: banWord,
                  textInputAction: TextInputAction.newline,
                  minLines: 1,
                  maxLines: 4,
                  onChanged: (value) => banWord = value,
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
                onPressed: () async {
                  Get.back();
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
  required BuildContext context,
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
  return SettingsModel(
    settingsType: SettingsType.normal,
    title: '$title${isFilter ? '过滤' : ''}',
    leading: const Icon(Icons.timelapse_outlined),
    subtitle: subtitle,
    getSubtitle: subtitle == null
        ? () => isFilter
              ? '过滤掉$title小于「$value${suffix ?? ""}」的视频'
              : '当前$title:「$value${suffix ?? ""}」'
        : null,
    onTap: (setState) async {
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
