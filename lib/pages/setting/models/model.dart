import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:PiliPlus/pages/setting/widgets/normal_item.dart';
import 'package:PiliPlus/pages/setting/widgets/popup_item.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/switch_item.dart';
import 'package:PiliPlus/pages/setting/widgets/list_editor_dialog.dart';
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

class WidgetModel extends SettingsModel {
  const WidgetModel({
    required this.child,
    this.searchTitle = '',
    this.searchSubtitle,
  });

  final Widget child;
  final String searchTitle;
  final String? searchSubtitle;

  @override
  String? get title => null;

  @override
  String get effectiveTitle => searchTitle;

  @override
  String? get effectiveSubtitle => searchSubtitle;

  @override
  Widget get widget => child;
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

/// Creates a list-based keyword filter model using ListEditorDialog
/// Items are stored as newline-separated strings (instead of pipe-separated)
/// to support regex patterns containing '|' character
///
/// 使用 getListBanWordModel 替代了上游的 getBanWordModel
SettingsModel getListBanWordModel({
  required String title,
  required String key,
  required ValueChanged<RegExp> onChanged,
}) {
  String banWord = GStorage.setting.get(key, defaultValue: '');

  // Helper function to parse stored data with backward compatibility
  List<String> parseItems(String data) {
    if (data.isEmpty) return [];

    // Check if it's the old pipe-separated format (no newlines)
    // If it contains no newlines but has pipes, it's likely old format
    if (!data.contains('\n') && data.contains('|')) {
      // Old format: pipe-separated
      final parts = data
          .split('|')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // Heuristic: check for complex regex
      if (parts.length > 1) {
        final hasComplexRegex = parts.any(
          (p) =>
              p.contains('(') ||
              p.contains('[') ||
              p.contains('{') ||
              p.contains('\\') ||
              p.contains('^') ||
              p.contains('\$'),
        );

        if (!hasComplexRegex) {
          // Old format with simple keywords - migrate
          return parts;
        }
      }

      // Might be a single complex regex pattern - keep as single item
      return [data];
    }

    // New format: newline-separated
    return data
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  // Helper function to join items using newline
  String joinItems(List<String> items) {
    return items.join('\n');
  }

  return NormalModel(
    leading: const Icon(Icons.filter_alt_outlined),
    title: title,
    getSubtitle: () {
      if (banWord.isEmpty) return "点击添加";
      final items = parseItems(banWord);
      return items.isEmpty ? "点击添加" : '${items.length} 个关键词';
    },
    onTap: (context, setState) async {
      final items = parseItems(banWord);

      final result = await showDialog<List<String>>(
        context: context,
        builder: (context) {
          return ListEditorDialog(
            title: title,
            initialItems: items,
            hintText: '输入关键词或正则表达式',
            itemLabel: '关键词',
          );
        },
      );

      if (result != null) {
        banWord = joinItems(result);
        setState();
        // Build regex by joining all patterns with alternation
        final regexPattern = result.isEmpty
            ? ''
            : result
                  .map((item) {
                    // If the item is already a complex pattern, wrap in non-capturing group
                    if (item.contains('|') && !item.startsWith('(')) {
                      return '($item)';
                    }
                    return item;
                  })
                  .join('|');
        onChanged(RegExp(regexPattern, caseSensitive: false));
        SmartDialog.showToast('已保存');
        GStorage.setting.put(key, banWord);
      }
    },
  );
}

/// Creates a list-based UID filter model with user names using ListEditorDialog
///
/// 支持显示用户名的 UID 过滤模型
SettingsModel getListUidWithNameModel({
  required String title,
  required Map<int, String> Function() getUidsMap,
  required void Function(Map<int, String>) setUidsMap,
  required void Function() onUpdate,
  Widget? leading,
  String emptySubtitle = '点击添加',
  String Function(int count)? countSubtitleBuilder,
}) {
  return NormalModel(
    leading: leading ?? const Icon(Icons.person_off_outlined),
    title: title,
    getSubtitle: () {
      final uidsMap = getUidsMap();
      if (uidsMap.isEmpty) return emptySubtitle;
      return countSubtitleBuilder?.call(uidsMap.length) ??
          '已屏蔽 ${uidsMap.length} 个用户';
    },
    onTap: (context, setState) async {
      final uidsMap = getUidsMap();
      // 将 Map 转换为显示格式："用户名 (UID)"
      final items = uidsMap.entries.map((e) {
        return '${e.value} (${e.key})';
      }).toList();

      final result = await showDialog<List<String>>(
        context: context,
        builder: (context) {
          return ListEditorDialog(
            title: title,
            initialItems: items,
            hintText: '输入用户UID',
            itemLabel: 'UID',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            allowEdit: false,
            validator: (value) {
              if (value.isEmpty) return '请输入UID';
              final uid = int.tryParse(value);
              if (uid == null) return 'UID必须是数字';
              if (uid <= 0) return 'UID必须大于0';
              return null;
            },
          );
        },
      );

      if (result != null) {
        final newMap = <int, String>{};

        for (final item in result) {
          // 解析格式 "用户名 (UID)" 或纯数字 "UID"
          final match = RegExp(r'(.+?)\s*\((\d+)\)$').firstMatch(item);
          if (match != null) {
            // 格式: "用户名 (UID)"
            final name = match.group(1)?.trim() ?? '';
            final uid = int.tryParse(match.group(2) ?? '');
            if (uid != null && uid > 0) {
              newMap[uid] = name;
            }
          } else {
            // 纯数字格式：新添加的UID
            final uid = int.tryParse(item);
            if (uid != null && uid > 0) {
              newMap[uid] = 'UID:$uid'; // 默认名称
            }
          }
        }

        setUidsMap(newMap);
        onUpdate();
        setState();
        SmartDialog.showToast('已保存');
      }
    },
  );
}

/// Creates a list-based UID filter model using ListEditorDialog
///
/// 使用 getListUidModel 替代了上游的 getUidModel
SettingsModel getListUidModel({
  required String title,
  required Set<int> Function() getUids,
  required void Function(Set<int>) setUids,
  required void Function() onUpdate,
}) {
  return NormalModel(
    leading: const Icon(Icons.person_off_outlined),
    title: title,
    getSubtitle: () {
      final uids = getUids();
      if (uids.isEmpty) return '点击添加';
      return '已屏蔽 ${uids.length} 个用户';
    },
    onTap: (context, setState) async {
      final uids = getUids();
      final items = uids.map((e) => e.toString()).toList();

      final result = await showDialog<List<String>>(
        context: context,
        builder: (context) {
          return ListEditorDialog(
            title: title,
            initialItems: items,
            hintText: '输入用户UID',
            itemLabel: 'UID',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            allowEdit: false,
            validator: (value) {
              if (value.isEmpty) return '请输入UID';
              final uid = int.tryParse(value);
              if (uid == null) return 'UID必须是数字';
              if (uid <= 0) return 'UID必须大于0';
              return null;
            },
          );
        },
      );

      if (result != null) {
        final newUids = result
            .map((e) => int.tryParse(e))
            .where((e) => e != null)
            .cast<int>()
            .toSet();
        setUids(newUids);
        onUpdate();
        setState();
        SmartDialog.showToast('已保存');
      }
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
                    // 上游修复：增加了 try-catch 防止解析错误
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
