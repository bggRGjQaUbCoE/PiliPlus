import 'package:PiliPlus/common/widgets/flutter/popup_menu.dart';
import 'package:PiliPlus/pages/setting/ai_setting/controller.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:material_ui/material_ui.dart';
import 'package:get/get.dart';

/// M3 Filled 文本域：容器用 surfaceContainerHighest 填充、无描边，
/// 只有底部 active indicator（聚焦时为主题色），标签浮动在填充内，
/// 不在边框上开洞
InputDecoration _filledDecoration(
  ColorScheme colorScheme, {
  String? labelText,
  String? hintText,
  String? helperText,
  int? helperMaxLines,
  bool? alignLabelWithHint,
  Widget? prefixIcon,
  Widget? suffixIcon,
}) => InputDecoration(
  labelText: labelText,
  hintText: hintText,
  helperText: helperText,
  helperMaxLines: helperMaxLines,
  alignLabelWithHint: alignLabelWithHint,
  filled: true,
  fillColor: colorScheme.surfaceContainerHighest,
  border: const UnderlineInputBorder(),
  prefixIcon: prefixIcon,
  suffixIcon: suffixIcon,
);

class AiSettingPage extends StatelessWidget {
  const AiSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AiSettingController());
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('AI 视频总结设置')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 总开关
          Obx(() => SwitchListTile(
                title: const Text('启用 AI 视频助手'),
                subtitle: const Text('关闭后视频详情页不再显示 AI 按钮'),
                value: controller.enableAiChat.value,
                onChanged: (value) {
                  controller.enableAiChat.value = value;
                  Pref.enableAiChat = value;
                },
              )),
          const SizedBox(height: 16),

          // API 配置
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('API 配置', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller.apiUrlCtl,
                    decoration: _filledDecoration(
                      colorScheme,
                      labelText: '接口地址',
                      hintText: 'https://api.example.com/v1',
                      helperText:
                          '填到版本路径为止，将自动补全 /models、/chat/completions；'
                          '如 OpenAI …/v1、Gemini …/v1beta、火山方舟 …/api/v3',
                      helperMaxLines: 3,
                      prefixIcon: const Icon(Icons.link),
                    ),
                    onChanged: controller.saveApiUrl,
                  ),
                  const SizedBox(height: 12),
                  _ApiKeyField(controller: controller),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 模型配置
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('模型配置', style: theme.textTheme.titleMedium),
                      const Spacer(),
                      Obx(
                        () => controller.isLoadingModels.value
                            // 与 IconButton 等高的占位，避免标题行跳动
                            ? const Padding(
                                padding: EdgeInsets.all(10),
                                child: SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            // 低频辅助操作，用最低强调的 Standard 样式，
                            // 不抢卡片视觉重心
                            : IconButton(
                                icon: const Icon(Icons.refresh),
                                tooltip: '拉取模型列表',
                                onPressed: controller.fetchModels,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    if (controller.modelList.isEmpty) {
                      return TextField(
                        controller: controller.modelCtl,
                        decoration: _filledDecoration(
                          colorScheme,
                          labelText: '模型名称',
                          hintText: 'gpt-5.4',
                          prefixIcon: const Icon(Icons.smart_toy),
                        ),
                        onChanged: controller.saveModel,
                      );
                    }
                    return _buildModelSelector(context, controller, theme);
                  }),
                  const SizedBox(height: 12),
                  Obx(
                    () => _buildReasoningEffortItem(
                      context,
                      controller,
                      colorScheme,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 模板管理
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('提示词模板', style: theme.textTheme.titleMedium),
                      const Spacer(),
                      TextButton.icon(
                        icon: const Icon(Icons.restore, size: 18),
                        label: const Text('恢复默认'),
                        onPressed: () => _confirmRestoreDefaults(
                          context,
                          controller,
                        ),
                      ),
                      const SizedBox(width: 4),
                      FilledButton.tonalIcon(
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('添加'),
                        onPressed: () =>
                            _showTemplateDialog(context, controller),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    if (controller.templates.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            '暂无模板，点击上方添加',
                            style: TextStyle(color: colorScheme.outline),
                          ),
                        ),
                      );
                    }
                    return ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      // 自备拖拽把柄，避免桌面端再叠一个默认把柄
                      buildDefaultDragHandles: false,
                      itemCount: controller.templates.length,
                      onReorder: controller.reorderTemplate,
                      itemBuilder: (context, index) {
                        final t = controller.templates[index];
                        return Padding(
                          key: ValueKey('${t.name}_$index'),
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Dismissible(
                            key: ValueKey('dismiss_${t.name}_$index'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                color: colorScheme.onErrorContainer,
                              ),
                            ),
                            confirmDismiss: (_) =>
                                _confirmDeleteTemplate(context, t.name),
                            onDismissed: (_) =>
                                controller.deleteTemplate(index),
                            child: Material(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                // 点击整行进编辑；删除收进左滑与编辑弹窗
                                onTap: () => _showTemplateDialog(
                                  context,
                                  controller,
                                  index: index,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    10,
                                    4,
                                    10,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              t.name,
                                              style:
                                                  theme.textTheme.titleSmall,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              t.prompt,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                color: colorScheme.outline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // 48dp 防误触热区，只有把柄能拖动排序
                                      ReorderableDragStartListener(
                                        index: index,
                                        child: SizedBox(
                                          width: 48,
                                          height: 48,
                                          child: Icon(
                                            Icons.drag_handle,
                                            size: 20,
                                            color: colorScheme.outline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 交互与显示
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('交互与显示', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Obx(() => SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('禁用 AI 回复自动滚动'),
                        subtitle: const Text('AI 回复时不主动滚动到最新内容'),
                        value: !controller.aiAutoScroll.value,
                        onChanged: (value) =>
                            controller.saveAiAutoScroll(!value),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Info card
          Card(
            color: colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '使用说明',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• 支持 OpenAI 兼容的 API 接口\n'
                    '• 在视频详情页点击 AI 按钮使用\n'
                    '• 点击「分析」自动载入视频上下文，也可手动载入后自由提问\n'
                    '• 无字幕时仍可使用通用问答\n'
                    '• 支持 Markdown 和 LaTeX，时间戳可点击跳转\n'
                    '• 内置模板名称（概貌总结、详细分析）的内容会被版本更新覆盖\n'
                    '• 自定义模板请使用不同名称，避免与内置模板重名',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // 模型选择
  /// M3 exposed dropdown：filled 容器 + 下拉箭头做触发器，
  /// 弹出列表复用外观-字体设置同款 MD3E 菜单（16dp 容器圆角、40dp 行高、
  /// 选中项 secondaryContainer 高亮、长模型名省略、长列表可滚动）
  Widget _buildModelSelector(
    BuildContext context,
    AiSettingController controller,
    ThemeData theme,
  ) {
    final colorScheme = theme.colorScheme;
    final model = controller.model.value;
    const radius = BorderRadius.vertical(top: Radius.circular(4));
    return StaticPopupMenuButton<String>(
      initialValue: model.isEmpty ? null : model,
      borderRadius: radius,
      itemBuilder: (context) => [
        for (final item in controller.modelList)
          CustomPopupMenuItem<String>(
            value: item,
            height: 40,
            child: Text(
              item,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onSelected: controller.saveModel,
      // 用 Ink 而非 Container：Container 的填充色会盖住水波纹
      child: Ink(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: radius,
        ),
        child: Row(
          children: [
            Icon(Icons.smart_toy, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                model.isEmpty ? '请选择模型' : model,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: model.isEmpty
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurface,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  // 思考强度
  Widget _buildReasoningEffortItem(
    BuildContext context,
    AiSettingController controller,
    ColorScheme colorScheme,
  ) {
    return Material(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: () => _showReasoningEffortSheet(context, controller),
        leading: Icon(
          Icons.lightbulb_outline_rounded,
          color: colorScheme.primary,
        ),
        title: const Text('思考强度'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                AiSettingController.reasoningEffortLabel(
                  controller.reasoningEffort.value,
                ),
                style: TextStyle(fontSize: 12, color: colorScheme.outline),
              ),
            ),
            const SizedBox(width: 2),
            Icon(Icons.chevron_right, size: 18, color: colorScheme.outline),
          ],
        ),
      ),
    );
  }

  void _showReasoningEffortSheet(
    BuildContext context,
    AiSettingController controller,
  ) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      clipBehavior: Clip.hardEdge,
      constraints: const BoxConstraints(maxWidth: 640),
      builder: (context) => _ReasoningEffortSheet(controller: controller),
    );
  }

  Future<bool?> _confirmDeleteTemplate(BuildContext context, String name) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除模板'),
        content: Text('确定删除模板「$name」？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: TextStyle(color: ColorScheme.of(context).outline),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              '删除',
              style: TextStyle(color: ColorScheme.of(context).error),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmRestoreDefaults(
    BuildContext context,
    AiSettingController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('恢复默认模板'),
        content: const Text('将清除所有自定义模板，恢复为内置默认模板。确定继续？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: TextStyle(color: ColorScheme.of(context).outline),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.restoreDefaults();
              Navigator.pop(context);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showTemplateDialog(
    BuildContext context,
    AiSettingController controller, {
    int? index,
  }) {
    final isEdit = index != null;
    final existing = isEdit ? controller.templates[index] : null;
    final nameCtl = TextEditingController(text: existing?.name ?? '');
    final promptCtl = TextEditingController(text: existing?.prompt ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? '编辑模板' : '添加模板'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtl,
              decoration: _filledDecoration(
                ColorScheme.of(context),
                labelText: '模板名称',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: promptCtl,
              maxLines: 5,
              decoration: _filledDecoration(
                ColorScheme.of(context),
                labelText: '提示词内容',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
        actions: [
          // 破坏性操作靠左，与确认操作拉开距离
          if (isEdit)
            TextButton(
              onPressed: () {
                controller.deleteTemplate(index);
                Navigator.pop(context);
              },
              child: Text(
                '删除',
                style: TextStyle(color: ColorScheme.of(context).error),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: TextStyle(color: ColorScheme.of(context).outline),
            ),
          ),
          TextButton(
            onPressed: () {
              final name = nameCtl.text.trim();
              final prompt = promptCtl.text.trim();
              if (name.isEmpty || prompt.isEmpty) return;
              if (isEdit) {
                controller.updateTemplate(index, name, prompt);
              } else {
                controller.addTemplate(name, prompt);
              }
              Navigator.pop(context);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

class _ApiKeyField extends StatefulWidget {
  const _ApiKeyField({required this.controller});
  final AiSettingController controller;

  @override
  State<_ApiKeyField> createState() => _ApiKeyFieldState();
}

class _ApiKeyFieldState extends State<_ApiKeyField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller.apiKeyCtl,
      decoration: _filledDecoration(
        Theme.of(context).colorScheme,
        labelText: 'API Key',
        hintText: 'sk-...',
        prefixIcon: const Icon(Icons.key),
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
          tooltip: _obscure ? '显示' : '隐藏',
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
      obscureText: _obscure,
      autocorrect: false,
      enableSuggestions: false,
      onChanged: widget.controller.saveApiKey,
    );
  }
}

/// 思考强度滑块
class _ReasoningEffortSheet extends StatefulWidget {
  const _ReasoningEffortSheet({required this.controller});

  final AiSettingController controller;

  @override
  State<_ReasoningEffortSheet> createState() => _ReasoningEffortSheetState();
}

class _ReasoningEffortSheetState extends State<_ReasoningEffortSheet> {
  static const _options = AiSettingController.reasoningEffortOptions;

  late double _value = AiSettingController.reasoningEffortIndexOf(
    widget.controller.reasoningEffort.value,
  ).toDouble();

  int get _index => _value.round();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        4,
        24,
        24 + MediaQuery.viewPaddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('调整模型思考深度', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            '并非所有模型都支持深度调整，请参考模型和提供商文档',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.outline,
            ),
          ),
          const SizedBox(height: 20),
          Icon(
            Icons.lightbulb_outline_rounded,
            size: 32,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            AiSettingController.reasoningEffortLabel(_options[_index]),
            style: theme.textTheme.titleMedium,
          ),
          Slider(
            value: _value,
            max: (_options.length - 1).toDouble(),
            divisions: _options.length - 1,
            label: AiSettingController.reasoningEffortLabel(_options[_index]),
            onChanged: (value) => setState(() => _value = value),
            onChangeEnd: (value) => widget.controller.saveReasoningEffort(
              _options[value.round()],
            ),
          ),
          Row(
            children: [
              for (final option in _options)
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      AiSettingController.reasoningEffortLabel(option),
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.outline,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
