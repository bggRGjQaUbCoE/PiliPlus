import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

part '../widgets/normal_item.dart';
part '../widgets/switch_item.dart';

@immutable
sealed class SettingsItem extends StatefulWidget {
  final String? subtitle;
  final Widget? leading;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? titleStyle;

  String? get title;
  String get effectiveTitle;
  String? get effectiveSubtitle;

  const SettingsItem({
    super.key,
    this.subtitle,
    this.leading,
    this.contentPadding,
    this.titleStyle,
  });
}

SettingsItem getBanWordModel({
  required String title,
  required String key,
  required ValueChanged<RegExp> onChanged,
}) {
  String banWord = GStorage.setting.get(key, defaultValue: '');
  return NormalItem(
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

SettingsItem getVideoFilterSelectModel({
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
  return NormalItem(
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
