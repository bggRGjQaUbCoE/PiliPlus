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
  String? banScope,
  String? regexKey,
}) {
  String banWord = GStorage.setting.get(key, defaultValue: '');
  String rawRegex = GStorage.setting.get(regexKey, defaultValue: '');
  bool isRegex = regexKey != null && rawRegex.isNotEmpty;

  return NormalModel(
    leading: const Icon(Icons.filter_alt_outlined),
    title: title,
    getSubtitle: () {
      final display = isRegex ? rawRegex : banWord;
      final subtitle = display.isEmpty ? '点击添加' : display;
      if (banScope != null) {
        return '作用域: $banScope\n$subtitle';
      }
      return subtitle;
    },
    onTap: (context, setState) {
      final keywords = banWord
          .split(RegExp(r'[\n|]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      final regexController = TextEditingController(text: rawRegex);
      final keywordController = TextEditingController();
      final listController = ScrollController();

      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) {
            void addKeyword() {
              final text = keywordController.text.trim();
              if (text.isEmpty || keywords.contains(text)) {
                return;
              }
              if (text.contains('|') || text.contains('\n')) {
                SmartDialog.showToast('关键词不能包含「|」或换行符');
                return;
              }
              setDialogState(() {
                keywords.add(text);
                keywordController.clear();
              });
            }

            final Widget body = isRegex
                ? TextField(
                    controller: regexController,
                    autofocus: true,
                    minLines: 1,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: '输入正则表达式',
                      border: OutlineInputBorder(),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (keywords.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: Text('暂无关键词')),
                        )
                      else
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 240),
                          child: Scrollbar(
                            controller: listController,
                            thumbVisibility: true,
                            child: ListView.builder(
                              controller: listController,
                              shrinkWrap: true,
                              itemCount: keywords.length,
                              itemBuilder: (context, index) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.label_outline),
                                title: Text(keywords[index]),
                                trailing: IconButton(
                                  icon: const Icon(Icons.close),
                                  tooltip: '删除',
                                  onPressed: () => setDialogState(
                                    () => keywords.removeAt(index),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: keywordController,
                              autofocus: true,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => addKeyword(),
                              decoration: const InputDecoration(
                                isDense: true,
                                hintText: '输入关键词后点击添加',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            onPressed: addKeyword,
                            icon: const Icon(Icons.add),
                            tooltip: '添加',
                          ),
                        ],
                      ),
                    ],
                  );

            return AlertDialog(
              constraints: Style.dialogFixedConstraints,
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (regexKey != null)
                    Row(
                      children: [
                        const Expanded(child: Text('正则模式（高级）')),
                        Switch(
                          value: isRegex,
                          onChanged: (v) => setDialogState(() {
                            isRegex = v;
                          }),
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  body,
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
                    if (isRegex) {
                      final newRegex = regexController.text.trim();
                      final RegExp regExp;
                      try {
                        regExp = RegExp(newRegex, caseSensitive: false);
                      } catch (e) {
                        SmartDialog.showToast('正则表达式错误：$e');
                        return;
                      }
                      onChanged(regExp);
                      rawRegex = newRegex;
                      banWord = '';
                      if (regexKey != null) {
                        GStorage.setting.put(regexKey, rawRegex);
                      }
                      GStorage.setting.put(key, '');
                    } else {
                      banWord = keywords.join('|');
                      onChanged(
                        RegExp(
                          keywords.map(RegExp.escape).join('|'),
                          caseSensitive: false,
                        ),
                      );
                      GStorage.setting.put(key, banWord);
                      if (regexKey != null) {
                        GStorage.setting.put(regexKey, '');
                      }
                    }
                    setState();
                    SmartDialog.showToast('已保存');
                  },
                ),
              ],
            );
          },
        ),
      ).whenComplete(() {
        regexController.dispose();
        keywordController.dispose();
        listController.dispose();
      });
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
  String? filterScope,
  ValueChanged<int>? onChanged,
}) {
  assert(!isFilter || onChanged != null);
  int value = GStorage.setting.get(key, defaultValue: defaultValue);
  return NormalModel(
    title: '$title${isFilter ? '过滤' : ''}',
    leading: const Icon(Icons.timelapse_outlined),
    subtitle: subtitle,
    getSubtitle: subtitle == null
        ? () {
            if (isFilter) {
              final subtitle = '过滤掉$title小于「$value${suffix ?? ""}」的视频';
              if (filterScope != null) {
                return '作用域: $filterScope\n$subtitle';
              }
              return subtitle;
            }
            return '当前$title:「$value${suffix ?? ""}」';
          }
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
