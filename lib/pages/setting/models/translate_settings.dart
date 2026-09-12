import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/dialog/simple_dialog_option.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/translate_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

List<SettingsModel> get translateSettings => [
  const SwitchModel(
    title: '启用翻译',
    subtitle: '总开关，关闭后所有翻译都不生效',
    leading: Icon(Icons.translate),
    setKey: SettingBoxKey.translateEnable,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '推荐流标题翻译',
    subtitle: '推荐流/热门/排行榜/相关推荐的标题自动翻译',
    leading: Icon(Icons.explore_outlined),
    setKey: SettingBoxKey.translateFeed,
    defaultVal: true,
  ),
  getDetailTitleModeModel(),
  const SwitchModel(
    title: '标签翻译',
    subtitle: '详情页视频标签自动翻译',
    leading: Icon(Icons.sell_outlined),
    setKey: SettingBoxKey.translateTag,
    defaultVal: true,
  ),
  getTranslateSkipLangsModel(),
  getTranslateProviderModel(),
  getTranslateTextInputModel(
    title: 'API 地址',
    key: SettingBoxKey.translateApiBase,
    hint: 'OpenAI 兼容示例：https://api.deepseek.com/v1',
  ),
  getTranslateTextInputModel(
    title: 'API Key',
    key: SettingBoxKey.translateApiKey,
    hint: '粘贴你的 API Key',
    obscureText: true,
  ),
  getTranslateTextInputModel(
    title: '模型名',
    key: SettingBoxKey.translateModel,
    hint: '仅 OpenAI 兼容接口，如 deepseek-chat',
  ),
  getTranslateTextInputModel(
    title: '目标语言',
    key: SettingBoxKey.translateTargetLang,
    hint: '仅 DeepL，如 zh、zh-Hans、ja 等',
  ),
  getTranslateTextInputModel(
    title: '自定义提示词',
    key: SettingBoxKey.translateSystemPrompt,
    hint: '仅 AI 翻译（OpenAI 兼容）可自定义，留空则使用默认提示词',
    multiline: true,
  ),
  getTranslateTestModel(),
];

/// 详情页标题翻译方式：不翻译 / 自动 / 手动
SettingsModel getDetailTitleModeModel() {
  final mode = GStorage.setting
      .get(SettingBoxKey.translateDetailTitleMode, defaultValue: 'auto');
  const labels = {'none': '不翻译', 'auto': '自动翻译', 'manual': '手动翻译'};
  return NormalModel(
    leading: const Icon(Icons.title_outlined),
    title: '详情页标题翻译方式',
    getSubtitle: () => labels[mode] ?? '自动翻译',
    onTap: (context, setState) {
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('详情页标题翻译方式'),
            children: [
              for (final e in labels.entries)
                DialogOption(
                  onPressed: () {
                    GStorage.setting.put(
                      SettingBoxKey.translateDetailTitleMode,
                      e.key,
                    );
                    SmartDialog.showToast('已设为：${e.value}');
                    Get.back();
                    setState();
                  },
                  child: Text(
                    e.value,
                    style: TextStyle(
                      color:
                          mode == e.key ? ColorScheme.of(context).primary : null,
                    ),
                  ),
                ),
            ],
          );
        },
      );
    },
  );
}

/// 不用翻译的语言（跳过集，多选）
SettingsModel getTranslateSkipLangsModel() {
  final values = GStorage.setting.get(
    SettingBoxKey.translateSkipLangs,
    defaultValue: ['zh'],
  ) as List;
  final selected = values.cast<String>().toSet();
  const options = {
    'zh': '简体 / 繁体中文',
    'ja': '日本語',
    'ko': '한국어',
  };
  return NormalModel(
    leading: const Icon(Icons.language_outlined),
    title: '不用翻译的语言',
    getSubtitle: () {
      if (selected.isEmpty) return '全部翻译';
      return selected.map((k) => options[k] ?? k).join('、');
    },
    onTap: (context, setState) {
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
              title: const Text('这些语言不翻译'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final e in options.entries)
                    CheckboxListTile(
                      dense: true,
                      title: Text(e.value),
                      value: selected.contains(e.key),
                      onChanged: (checked) {
                        setDialogState(() {
                          if (checked == true) {
                            selected.add(e.key);
                          } else {
                            selected.remove(e.key);
                          }
                        });
                      },
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
                    GStorage.setting.put(
                      SettingBoxKey.translateSkipLangs,
                      selected.toList(),
                    );
                    SmartDialog.showToast('已保存');
                    setState();
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

/// 翻译服务选择
SettingsModel getTranslateProviderModel() {
  var current = GStorage.setting
      .get(SettingBoxKey.translateProvider, defaultValue: 'openai');
  return NormalModel(
    leading: const Icon(Icons.cloud_outlined),
    title: '翻译服务',
    getSubtitle: () =>
        current == 'deepl' ? 'DeepL' : 'OpenAI 兼容（DeepSeek 等）',
    onTap: (context, setState) {
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('选择翻译服务'),
            children: [
              DialogOption(
                onPressed: () {
                  current = 'openai';
                  GStorage.setting.put(SettingBoxKey.translateProvider, current);
                  SmartDialog.showToast('已选择 OpenAI 兼容接口');
                  Get.back();
                  setState();
                },
                child: const Text('OpenAI 兼容（DeepSeek / OpenAI / Moonshot 等）'),
              ),
              DialogOption(
                onPressed: () {
                  current = 'deepl';
                  GStorage.setting.put(SettingBoxKey.translateProvider, current);
                  SmartDialog.showToast('已选择 DeepL');
                  Get.back();
                  setState();
                },
                child: const Text('DeepL'),
              ),
            ],
          );
        },
      );
    },
  );
}

/// 文本输入设置项（弹窗输入，保存到 key）
SettingsModel getTranslateTextInputModel({
  required String title,
  required String key,
  String? hint,
  bool obscureText = false,
  bool multiline = false,
}) {
  String value = GStorage.setting.get(key, defaultValue: '');
  return NormalModel(
    leading: const Icon(Icons.edit_outlined),
    title: title,
    getSubtitle: () => value.isEmpty ? '点击设置' : value,
    onTap: (context, setState) {
      String editValue = value;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          constraints: Style.dialogFixedConstraints,
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hint case final h?) Text(h, style: const TextStyle(fontSize: 12)),
              TextFormField(
                autofocus: !obscureText,
                obscureText: obscureText,
                initialValue: editValue,
                minLines: 1,
                maxLines: multiline ? 4 : 2,
                onChanged: (v) => editValue = v,
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
                value = editValue.trim();
                setState();
                GStorage.setting.put(key, value);
                SmartDialog.showToast('已保存');
              },
            ),
          ],
        ),
      );
    },
  );
}

/// 测试翻译
SettingsModel getTranslateTestModel() {
  return NormalModel(
    leading: const Icon(Icons.science_outlined),
    title: '测试翻译',
    subtitle: '用一段示例文本测试当前配置是否可用',
    onTap: (context, setState) async {
      if (!TranslateService.configured()) {
        SmartDialog.showToast('请先填写并保存 API 地址与 Key');
        return;
      }
      SmartDialog.showLoading(msg: '翻译中...');
      try {
        final result = await TranslateService.testConfigured();
        SmartDialog.dismiss();
        if (result.isEmpty) {
          SmartDialog.showToast('翻译失败，请检查配置');
        } else {
          SmartDialog.showToast('测试成功：$result');
        }
      } catch (e) {
        SmartDialog.dismiss();
        SmartDialog.showToast('翻译失败：$e');
      }
    },
  );
}