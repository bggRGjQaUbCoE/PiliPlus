import 'dart:async' show FutureOr;
import 'dart:convert' show utf8, jsonDecode;
import 'dart:io' show File;

import 'package:PiliPlus/common/constants.dart' show StyleString;
import 'package:PiliPlus/utils/extension/context_ext.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:re_highlight/languages/json.dart';
import 'package:re_highlight/re_highlight.dart';
import 'package:re_highlight/styles/base16/github.dart';
import 'package:re_highlight/styles/github-dark.dart';

void exportToClipBoard({
  required ValueGetter<String> onExport,
}) {
  Utils.copyText(onExport());
}

void exportToLocalFile({
  required ValueGetter<String> onExport,
  required ValueGetter<String> localFileName,
}) {
  final res = utf8.encode(onExport());
  Utils.saveBytes2File(
    name:
        'piliplus_${localFileName()}_'
        '${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.json',
    bytes: res,
    allowedExtensions: const ['json'],
  );
}

Future<void> importFromClipBoard<T>(
  BuildContext context, {
  required String title,
  required ValueGetter<String> onExport,
  required FutureOr<void> Function(T json) onImport,
  bool showConfirmDialog = true,
}) async {
  final data = await Clipboard.getData('text/plain');
  if (data?.text?.isNotEmpty != true) {
    SmartDialog.showToast('剪贴板无数据');
    return;
  }
  if (!context.mounted) return;
  final text = data!.text!;
  late final T json;
  late final String formatText;
  try {
    json = jsonDecode(text);
    formatText = Utils.jsonEncoder.convert(json);
  } catch (e) {
    SmartDialog.showToast('解析json失败：$e');
    return;
  }
  bool? executeImport;
  if (showConfirmDialog) {
    final highlight = Highlight()..registerLanguage('json', langJson);
    final result = highlight.highlight(
      code: formatText,
      language: 'json',
    );
    late TextSpanRenderer renderer;
    bool? isDarkMode;
    executeImport = await showDialog(
      context: context,
      builder: (context) {
        final isDark = context.isDarkMode;
        if (isDark != isDarkMode) {
          isDarkMode = isDark;
          renderer = TextSpanRenderer(
            const TextStyle(),
            isDark ? githubDarkTheme : githubTheme,
          );
          result.render(renderer);
        }
        return AlertDialog(
          title: Text('是否导入如下$title？'),
          content: SingleChildScrollView(
            child: Text.rich(renderer.span!),
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
              onPressed: () => Get.back(result: true),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  } else {
    executeImport = true;
  }
  if (executeImport ?? false) {
    try {
      await onImport(json);
      SmartDialog.showToast('导入成功');
    } catch (e) {
      SmartDialog.showToast('导入失败：$e');
    }
  }
}

Future<void> importFromLocalFile<T>({
  required FutureOr<void> Function(T json) onImport,
}) async {
  final result = await FilePicker.pickFiles();
  if (result != null) {
    final path = result.files.first.path;
    if (path != null) {
      final data = await File(path).readAsString();
      late final T json;
      try {
        json = jsonDecode(data);
      } catch (e) {
        SmartDialog.showToast('解析json失败：$e');
        return;
      }
      try {
        await onImport(json);
        SmartDialog.showToast('导入成功');
      } catch (e) {
        SmartDialog.showToast('导入失败：$e');
      }
    }
  }
}

void importFromInput<T>(
  BuildContext context, {
  required String title,
  required FutureOr<void> Function(T json) onImport,
}) {
  final key = GlobalKey<FormFieldState<String>>();
  late T json;
  String? forceErrorText;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('输入$title'),
      constraints: StyleString.dialogFixedConstraints,
      content: TextFormField(
        key: key,
        minLines: 4,
        maxLines: 12,
        autofocus: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          errorMaxLines: 3,
        ),
        validator: (value) {
          if (forceErrorText != null) return forceErrorText;
          try {
            json = jsonDecode(value!) as T;
            return null;
          } catch (e) {
            if (e is FormatException) {}
            return '解析json失败：$e';
          }
        },
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
          onPressed: () async {
            if (key.currentState?.validate() == true) {
              try {
                await onImport(json);
                Get.back();
                SmartDialog.showToast('导入成功');
                return;
              } catch (e) {
                forceErrorText = '导入失败：$e';
              }
              key.currentState?.validate();
              forceErrorText = null;
            }
          },
          child: const Text('确定'),
        ),
      ],
    ),
  );
}

Future<void> showImportExportDialog<T>(
  BuildContext context, {
  required String title,
  required ValueGetter<String> onExport,
  required FutureOr<void> Function(T json) onImport,
  required ValueGetter<String> localFileName,
}) => showDialog(
  context: context,
  builder: (context) {
    const style = TextStyle(fontSize: 15);
    return SimpleDialog(
      clipBehavior: Clip.hardEdge,
      title: Text('导入/导出$title'),
      children: [
        ListTile(
          dense: true,
          title: const Text('导出至剪贴板', style: style),
          onTap: () {
            Get.back();
            exportToClipBoard(onExport: onExport);
          },
        ),
        ListTile(
          dense: true,
          title: const Text('导出文件至本地', style: style),
          onTap: () {
            Get.back();
            exportToLocalFile(onExport: onExport, localFileName: localFileName);
          },
        ),
        Divider(
          height: 1,
          color: ColorScheme.of(context).outline.withValues(alpha: 0.1),
        ),
        ListTile(
          dense: true,
          title: const Text('输入', style: style),
          onTap: () {
            Get.back();
            importFromInput<T>(context, title: title, onImport: onImport);
          },
        ),
        ListTile(
          dense: true,
          title: const Text('从剪贴板导入', style: style),
          onTap: () {
            Get.back();
            importFromClipBoard<T>(
              context,
              title: title,
              onExport: onExport,
              onImport: onImport,
            );
          },
        ),
        ListTile(
          dense: true,
          title: const Text('从本地文件导入', style: style),
          onTap: () {
            Get.back();
            importFromLocalFile<T>(onImport: onImport);
          },
        ),
      ],
    );
  },
);
