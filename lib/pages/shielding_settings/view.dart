import 'package:PiliPlus/common/widgets/flutter/list_tile.dart' as custom;
import 'package:PiliPlus/features/shielding/shielding.dart';
import 'package:PiliPlus/pages/setting/models/shielding_settings.dart';
import 'package:flutter/material.dart' hide ListTile;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class ShieldingSettingsPage extends StatefulWidget {
  const ShieldingSettingsPage({
    super.key,
    this.showAppBar = true,
    ShieldSettingsStore? store,
  }) : store = store;

  final bool showAppBar;
  final ShieldSettingsStore? store;

  @override
  State<ShieldingSettingsPage> createState() => _ShieldingSettingsPageState();
}

class _ShieldingSettingsPageState extends State<ShieldingSettingsPage> {
  late final _store = widget.store ?? ShieldSettingsStore();
  late ShieldRuleSet _ruleSet = _store.snapshot();
  String _selectedCategory = shieldingRuleCategoryLabels.first;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loaded = await _store.load();
    if (!mounted) return;
    setState(() => _ruleSet = loaded);
  }

  Future<void> _save(ShieldRuleSet ruleSet) async {
    try {
      await _store.save(ruleSet);
      if (!mounted) return;
      setState(() => _ruleSet = ruleSet);
      SmartDialog.showToast('已保存');
    } catch (e) {
      SmartDialog.showToast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.viewPaddingOf(context);
    final showAppBar = widget.showAppBar;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: showAppBar
          ? AppBar(
              title: const Text('屏蔽规则'),
              actions: [
                IconButton(
                  tooltip: '新增',
                  onPressed: () => _openEditor(),
                  icon: const Icon(Icons.add),
                ),
              ],
            )
          : null,
      body: ListView(
        padding: EdgeInsets.only(
          left: showAppBar ? padding.left : 0,
          right: showAppBar ? padding.right : 0,
          bottom: padding.bottom + 100,
        ),
        children: [
          _buildSwitchTile(
            icon: Icons.shield_outlined,
            title: '启用全局屏蔽',
            subtitle: '关闭后，推荐和评论场景都不会应用 Phase 1 屏蔽规则',
            value: _ruleSet.globalEnabled,
            onChanged: (value) =>
                _save(_ruleSet.copyWith(globalEnabled: value)),
          ),
          _buildSwitchTile(
            icon: Icons.explore_outlined,
            title: '推荐流屏蔽',
            subtitle: '在首页推荐和相关推荐场景应用规则',
            value: _ruleSet.recommendationEnabled,
            onChanged: (value) =>
                _save(_ruleSet.copyWith(recommendationEnabled: value)),
          ),
          _buildSwitchTile(
            icon: Icons.forum_outlined,
            title: '评论屏蔽',
            subtitle: '在评论场景应用规则',
            value: _ruleSet.commentEnabled,
            onChanged: (value) =>
                _save(_ruleSet.copyWith(commentEnabled: value)),
          ),
          const Divider(height: 1),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemBuilder: (context, index) {
                final label = shieldingRuleCategoryLabels[index];
                return ChoiceChip(
                  label: Text(label),
                  selected: _selectedCategory == label,
                  onSelected: (_) => setState(
                    () => _selectedCategory = label,
                  ),
                );
              },
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemCount: shieldingRuleCategoryLabels.length,
            ),
          ),
          custom.ListTile(
            leading: const Icon(Icons.rule_outlined),
            title: Text('$_selectedCategory规则'),
            subtitle: Text(shieldRuleSummary(_visibleRules)),
            trailing: const Icon(Icons.add),
            onTap: () => _openEditor(),
          ),
          if (_ruleSet.loadErrors.isNotEmpty)
            custom.ListTile(
              dense: true,
              leading: Icon(
                Icons.warning_amber_outlined,
                color: ColorScheme.of(context).error,
              ),
              title: Text(
                '规则加载失败，当前已临时关闭屏蔽',
                style: TextStyle(color: ColorScheme.of(context).error),
              ),
              subtitle: Text(_ruleSet.loadErrors.join('\n')),
            ),
          if (_ruleSet.rules.isEmpty)
            custom.ListTile(
              leading: const Icon(Icons.rule_folder_outlined),
              title: const Text('暂无规则'),
              subtitle: const Text('点击右上角或规则入口添加'),
              onTap: () => _openEditor(),
            )
          else
            ..._visibleRules.map(_buildRuleItem),
        ],
      ),
      floatingActionButton: showAppBar
          ? FloatingActionButton(
              tooltip: '新增规则',
              onPressed: () => _openEditor(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  List<ShieldRule> get _sortedRules =>
      [..._ruleSet.rules]..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

  List<ShieldRule> get _visibleRules => _sortedRules
      .where((rule) => shieldingRuleCategoryFor(rule) == _selectedCategory)
      .toList();

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildRuleItem(ShieldRule rule) {
    return custom.ListTile(
      leading: Icon(
        rule.action == ShieldAction.allow
            ? Icons.verified_user_outlined
            : Icons.block_outlined,
      ),
      title: Text(shieldRuleTitle(rule)),
      subtitle: Text(shieldRuleSubtitle(rule)),
      trailing: Switch(
        value: rule.enabled,
        onChanged: (value) {
          final rules = _ruleSet.rules
              .map(
                (item) => item.id == rule.id
                    ? item.copyWith(enabled: value, updatedAt: DateTime.now())
                    : item,
              )
              .toList();
          _save(_ruleSet.copyWith(rules: rules));
        },
      ),
      onTap: () => _openEditor(rule: rule),
      onLongPress: () => _deleteRule(rule),
    );
  }

  Future<void> _deleteRule(ShieldRule rule) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除规则'),
        content: Text(rule.pattern),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('取消')),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await _save(
      _ruleSet.copyWith(
        rules: _ruleSet.rules.where((item) => item.id != rule.id).toList(),
      ),
    );
  }

  Future<void> _openEditor({ShieldRule? rule}) async {
    ShieldRuleType type = rule?.type ?? ShieldRuleType.keyword;
    ShieldMatchMode mode = rule?.matchMode ?? ShieldMatchMode.exact;
    ShieldScope scope = rule?.scope ?? ShieldScope.both;
    ShieldAction action = rule?.action ?? ShieldAction.block;
    bool enabled = rule?.enabled ?? true;
    String pattern = rule?.pattern ?? '';

    final saved = await showDialog<ShieldRule>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(rule == null ? '新增规则' : '编辑规则'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  autofocus: true,
                  initialValue: pattern,
                  decoration: const InputDecoration(labelText: '匹配内容'),
                  onChanged: (value) => pattern = value,
                ),
                const SizedBox(height: 12),
                _dropdown(
                  label: '类型',
                  value: type,
                  values: ShieldRuleType.values,
                  text: shieldRuleTypeLabel,
                  onChanged: (value) => setDialogState(() => type = value),
                ),
                _dropdown(
                  label: '匹配方式',
                  value: mode,
                  values: ShieldMatchMode.values,
                  text: (value) => shieldMatchModeLabel(value, type: type),
                  onChanged: (value) => setDialogState(() => mode = value),
                ),
                _dropdown(
                  label: '作用范围',
                  value: scope,
                  values: ShieldScope.values,
                  text: shieldScopeLabel,
                  onChanged: (value) => setDialogState(() => scope = value),
                ),
                _dropdown(
                  label: '动作',
                  value: action,
                  values: ShieldAction.values,
                  text: shieldActionLabel,
                  onChanged: (value) => setDialogState(() => action = value),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('启用'),
                  value: enabled,
                  onChanged: (value) => setDialogState(() => enabled = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: Get.back, child: const Text('取消')),
            TextButton(
              onPressed: () {
                final trimmed = pattern.trim();
                if (trimmed.isEmpty) {
                  SmartDialog.showToast('匹配内容不能为空');
                  return;
                }
                if (mode == ShieldMatchMode.regex) {
                  try {
                    RegExp(trimmed);
                  } catch (_) {
                    SmartDialog.showToast('正则表达式无效');
                    return;
                  }
                }
                Get.back(
                  result: ShieldRule(
                    id:
                        rule?.id ??
                        'manual-${DateTime.now().microsecondsSinceEpoch}',
                    type: type,
                    matchMode: mode,
                    scope: scope,
                    action: action,
                    pattern: trimmed,
                    enabled: enabled,
                    updatedAt: DateTime.now(),
                  ),
                );
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );

    if (saved == null) return;
    final rules = [
      for (final item in _ruleSet.rules)
        if (item.id != saved.id) item,
      saved,
    ];
    await _save(_ruleSet.copyWith(rules: rules));
  }

  Widget _dropdown<T>({
    required String label,
    required T value,
    required List<T> values,
    required String Function(T value) text,
    required ValueChanged<T> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(labelText: label),
      items: values
          .map(
            (value) => DropdownMenuItem<T>(
              value: value,
              child: Text(text(value)),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
