import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:PiliPlus/pages/setting/widgets/normal_item.dart';
import 'package:PiliPlus/pages/setting/widgets/popup_item.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/switch_item.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart' hide PopupMenuItemSelected;

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

class SplitModel extends SettingsModel {
  const SplitModel({
    super.contentPadding,
    super.titleStyle,
    required this.normalModel,
    required this.switchModel,
  });

  @override
  String? get effectiveSubtitle => normalModel.effectiveSubtitle;

  @override
  String get effectiveTitle => normalModel.effectiveTitle;

  @override
  String? get title => normalModel.title;

  final NormalModel normalModel;

  final SwitchModel switchModel;

  @override
  Widget get widget => SetSwitchItem(
    title: effectiveTitle,
    subtitle: effectiveSubtitle,
    setKey: switchModel.setKey,
    defaultVal: switchModel.defaultVal,
    onChanged: switchModel.onChanged,
    needReboot: switchModel.needReboot,
    leading: normalModel.leading,
    onTap: switchModel.onTap,
    contentPadding: contentPadding,
    titleStyle: titleStyle,
    isSplit: true,
  );
}

class PopupModel<T extends EnumWithLabel> extends SettingsModel {
  const PopupModel({
    required this.title,
    super.leading,
    super.contentPadding,
    super.titleStyle,
    required this.value,
    required this.items,
    required this.onSelected,
  });

  @override
  String? get effectiveSubtitle => null;

  @override
  String get effectiveTitle => title;

  @override
  final String title;

  final ValueGetter<T> value;
  final Iterable<T> items;
  final PopupMenuItemSelected<T> onSelected;

  @override
  Widget get widget => PopupListTile<T>(
    safeArea: false,
    leading: leading,
    title: Text(title),
    value: () {
      final v = value();
      return (v, v.label);
    },
    itemBuilder: (_) => enumItemBuilder(items),
    onSelected: onSelected,
  );
}

class NormalModel extends SettingsModel {
  @override
  final String? title;
  final ValueGetter<String>? getTitle;
  final ValueGetter<String>? getSubtitle;
  final Widget Function(ThemeData theme)? getTrailing;
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

  const NormalModel.split({
    super.subtitle,
    super.leading,
    super.contentPadding,
    super.titleStyle,
    this.title,
    this.getTitle,
    this.getSubtitle,
    this.getTrailing,
  }) : onTap = null,
       assert(title != null || getTitle != null);

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
  final String? title;
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
    required String this.title,
    required this.setKey,
    this.defaultVal = false,
    this.onChanged,
    this.needReboot = false,
    this.onTap,
  });

  const SwitchModel.split({
    required this.setKey,
    this.defaultVal = false,
    this.needReboot = false,
    this.onChanged,
    this.onTap,
  }) : title = null;

  @override
  String get effectiveTitle => title!;
  @override
  String? get effectiveSubtitle => subtitle;

  @override
  Widget get widget => SetSwitchItem(
    title: title!,
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
  String? subtitle,
}) {
  String banWord = GStorage.setting.get(key, defaultValue: '');
  return NormalModel(
    leading: const Icon(Icons.filter_alt_outlined),
    title: title,
    subtitle: subtitle,
    getSubtitle: () => banWord.isEmpty ? "点击添加" : banWord,
    onTap: (context, setState) {
      String editValue = banWord;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          constraints: Style.dialogFixedConstraints,
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
                style: TextStyle(color: ColorScheme.of(context).outline),
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
        ),
      );
    },
  );
}

SettingsModel getBanWordListModel({
  required String title,
  required String key,
  required ValueChanged<List<String>> onChanged,
  String? subtitle,
}) {
  List<String> banWords = _readBanWordList(key);
  return NormalModel(
    leading: const Icon(Icons.filter_alt_outlined),
    title: title,
    subtitle: subtitle,
    getSubtitle: () => banWords.isEmpty
        ? '点击添加'
        : '已屏蔽 ${banWords.length} 个：${banWords.join('、')}',
    onTap: (context, setState) {
      final TextEditingController controller = TextEditingController();
      void save() {
        GStorage.setting.put(key, banWords);
        onChanged(List<String>.from(banWords));
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          constraints: Style.dialogFixedConstraints,
          title: Text(title),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              void add() {
                final word = controller.text.trim();
                if (word.isEmpty) return;
                if (!banWords.contains(word)) {
                  banWords.add(word);
                  save();
                }
                controller.clear();
                setDialogState(() {});
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          autofocus: true,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => add(),
                          decoration: const InputDecoration(
                            hintText: '输入单个关键词，点击添加',
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: add,
                        child: const Text('添加'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (banWords.isNotEmpty)
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final word in banWords)
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                title: Text(word),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close),
                                  tooltip: '移除',
                                  onPressed: () {
                                    banWords.remove(word);
                                    save();
                                    setDialogState(() {});
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  else
                    const Text('暂无屏蔽词', style: TextStyle(fontSize: 13)),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: Text(
                '取消',
                style: TextStyle(color: ColorScheme.of(context).outline),
              ),
            ),
            TextButton(
              child: const Text('完成'),
              onPressed: () {
                Get.back();
                setState();
                SmartDialog.showToast('已保存');
              },
            ),
          ],
        ),
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
        builder: (context) => SelectDialog<int>(
          title: '选择$title${isFilter ? '（0即不过滤）' : ''}',
          value: value,
          values:
              (values
                    ..addIf(!values.contains(value), value)
                    ..sort())
                  .map((e) => (e, suffix == null ? e.toString() : '$e $suffix'))
                  .toList()
                ..add((-1, '自定义')),
        ),
      );
      if (result != null) {
        if (result == -1 && context.mounted) {
          String valueStr = '';
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
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
                    style: TextStyle(color: ColorScheme.of(context).outline),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    try {
                      result = int.parse(valueStr);
                      Get.back();
                    } catch (e) {
                      SmartDialog.showToast(e.toString());
                    }
                  },
                  child: const Text('确定'),
                ),
              ],
            ),
          );
        }
        if (result != -1) {
          value = result!;
          setState();
          onChanged?.call(value);
          GStorage.setting.put(key, value);
        }
      }
    },
  );
}

/// 读取屏蔽词列表，兼容旧版使用`|`分隔的字符串存储
List<String> _readBanWordList(String key) {
  final value = GStorage.setting.get(key, defaultValue: <String>[]);
  if (value is String) {
    return value.isEmpty ? <String>[] : value.split('|');
  }
  return List<String>.from(value);
}
