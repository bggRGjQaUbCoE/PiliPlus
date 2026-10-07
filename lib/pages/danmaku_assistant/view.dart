import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/models/user/danmaku_assistant.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class DanmakuAssistantPage extends StatefulWidget {
  const DanmakuAssistantPage({super.key});

  @override
  State<DanmakuAssistantPage> createState() =>
      _DanmakuAssistantPageState();
}

class _DanmakuAssistantPageState extends State<DanmakuAssistantPage> {
  late final PlPlayerController _playerController;
  late DanmakuAssistantConfig _config;

  @override
  void initState() {
    super.initState();
    _playerController = Get.arguments as PlPlayerController;
    _config = _playerController.danmakuAssistantConfig;
  }

  void _save(DanmakuAssistantConfig config) {
    setState(() => _config = config);
    _playerController.updateDanmakuAssistantConfig(config);
  }

  Future<void> _addRule({required bool absolute}) async {
    final textController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(absolute ? '添加绝对屏蔽规则' : '添加温和屏蔽规则'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(absolute ? '只要弹幕包含该文字就会被屏蔽。' : '仅当整条弹幕与该文字相等时屏蔽。'),
            const SizedBox(height: 12),
            TextField(
              controller: textController,
              autofocus: true,
              decoration: const InputDecoration(hintText: '输入规则'),
              onSubmitted: (value) => Navigator.pop(context, value),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder(
              valueListenable: textController,
              builder: (context, value, _) {
                final rule = value.text.trim();
                final hitCount = rule.isEmpty
                    ? 0
                    : _playerController.danmakuAssistantSamples.where((item) {
                        final content = item.content.trim();
                        return absolute
                            ? content.contains(rule)
                            : content == rule;
                      }).length;
                return Text('当前已加载弹幕预计命中 $hitCount 条');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, textController.text),
            child: const Text('添加'),
          ),
        ],
      ),
    );
    textController.dispose();
    if (!mounted || result == null) return;

    final rule = result.trim();
    if (rule.isEmpty) return;
    final rules = List<String>.of(
      absolute ? _config.absoluteRules : _config.gentleRules,
    );
    if (rules.any((item) => item.trim() == rule)) return;
    rules.add(rule);
    _save(
      absolute
          ? _config.copyWith(absoluteRules: rules)
          : _config.copyWith(gentleRules: rules),
    );
  }

  void _addGentleRule(String content) {
    final rule = content.trim();
    if (rule.isEmpty) return;
    final rules = List<String>.of(_config.gentleRules);
    if (rules.any((item) => item.trim() == rule)) return;
    rules.add(rule);
    _save(_config.copyWith(gentleRules: rules));
  }

  void _removeRule(DanmakuAssistantKind kind, String rule) {
    switch (kind) {
      case DanmakuAssistantKind.absolute:
        _save(
          _config.copyWith(
            absoluteRules: List<String>.of(_config.absoluteRules)..remove(rule),
          ),
        );
        return;
      case DanmakuAssistantKind.gentle:
        _save(
          _config.copyWith(
            gentleRules: List<String>.of(_config.gentleRules)..remove(rule),
          ),
        );
        return;
      default:
        return;
    }
  }

  String _formatProgress(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _sectionTitle(String title, {Widget? trailing}) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 8, 8),
    child: Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        ?trailing,
      ],
    ),
  );

  Widget _ruleSection({required bool absolute}) {
    final rules = absolute ? _config.absoluteRules : _config.gentleRules;
    final kind = absolute
        ? DanmakuAssistantKind.absolute
        : DanmakuAssistantKind.gentle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(
          absolute ? '绝对屏蔽（包含即拦截）' : '温和屏蔽（整条相等才拦截）',
          trailing: IconButton(
            tooltip: '添加规则',
            onPressed: () => _addRule(absolute: absolute),
            icon: const Icon(Icons.add),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: rules.isEmpty
              ? const Text('暂无规则')
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: rules
                      .map(
                        (rule) => InputChip(
                          label: Text(rule),
                          onDeleted: () => _removeRule(kind, rule),
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }

  Widget _stats() {
    final theme = Theme.of(context);
    final total = _playerController.danmakuAssistantBlockedTotal;
    final counts = _playerController.danmakuAssistantReasonCounts;
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '当前视频已拦截 $total 条',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: _playerController.clearDanmakuAssistantRecords,
                  child: const Text('清空统计'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: DanmakuAssistantKind.values
                  .where((kind) => (counts[kind] ?? 0) > 0)
                  .map(
                    (kind) => Chip(
                      label: Text('${kind.label} ${counts[kind]}'),
                    ),
                  )
                  .toList(),
            ),
            if (total == 0)
              Text(
                '播放或拖动视频后，这里会显示本地命中统计。',
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }

  Widget _switches() => Column(
    children: [
      const ListTile(
        leading: Icon(Icons.info_outline),
        title: Text('格式识别默认关闭'),
        subtitle: Text('建议先查看当前视频的命中预览，再按需启用。'),
      ),
      SwitchListTile(
        title: const Text('日期与日期打卡'),
        subtitle: const Text('例如：2025.8探访古迹、10月1日 1000人'),
        value: _config.blockDateStamps,
        onChanged: (value) =>
            _save(_config.copyWith(blockDateStamps: value)),
      ),
      SwitchListTile(
        title: const Text('时间打卡'),
        subtitle: const Text('例如：12:00 1000人'),
        value: _config.blockTimeStamps,
        onChanged: (value) =>
            _save(_config.copyWith(blockTimeStamps: value)),
      ),
      SwitchListTile(
        title: const Text('纯人数刷屏'),
        subtitle: const Text('例如：1000人；不会误伤完整语句中的人数'),
        value: _config.blockPeopleCounts,
        onChanged: (value) =>
            _save(_config.copyWith(blockPeopleCounts: value)),
      ),
      SwitchListTile(
        title: const Text('短打卡/考古'),
        subtitle: const Text('例如：2026年前来考古'),
        value: _config.blockShortCheckIns,
        onChanged: (value) =>
            _save(_config.copyWith(blockShortCheckIns: value)),
      ),
    ],
  );

  Widget _records({required bool blocked}) {
    final source = blocked
        ? _playerController.danmakuAssistantHits
        : _playerController.danmakuAssistantSamples;
    final records = source.reversed.take(blocked ? 80 : 50).toList();
    if (records.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text('暂无数据'),
      );
    }

    return Column(
      children: records.map((record) {
        final match = record.match;
        final removableMatch = blocked &&
                match != null &&
                match.rule != null &&
                (match.kind == DanmakuAssistantKind.absolute ||
                    match.kind == DanmakuAssistantKind.gentle)
            ? match
            : null;
        final alreadyGentle = _config.gentleRules.any(
          (rule) => rule.trim() == record.content.trim(),
        );
        return ListTile(
          dense: true,
          leading: Text(_formatProgress(record.progress)),
          title: Text(
            record.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: blocked && match != null ? Text(match.reason) : null,
          trailing: blocked
              ? removableMatch != null
                    ? IconButton(
                        tooltip: '移除此规则',
                        onPressed: () => _removeRule(
                          removableMatch.kind,
                          removableMatch.rule!,
                        ),
                        icon: const Icon(Icons.remove_circle_outline),
                      )
                    : null
              : IconButton(
                  tooltip: alreadyGentle ? '已在温和屏蔽中' : '按整条内容屏蔽',
                  onPressed: alreadyGentle
                      ? null
                      : () => _addGentleRule(record.content),
                  icon: const Icon(Icons.add_circle_outline),
                ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
      appBar: AppBar(
        title: const Text('弹幕屏蔽助手'),
        actions: [
          IconButton(
            tooltip: '恢复默认规则',
            onPressed: () => _save(DanmakuAssistantConfig.defaults()),
            icon: const Icon(Icons.restart_alt),
          ),
        ],
      ),
      body: Obx(() {
        final _ = _playerController.danmakuAssistantRevision.value;
        return ListView(
          children: [
            _stats(),
            _sectionTitle('格式识别'),
            _switches(),
            _ruleSection(absolute: true),
            _ruleSection(absolute: false),
            _sectionTitle('最近已拦截（最多 80 条）'),
            _records(blocked: true),
            _sectionTitle('最近读取的弹幕（点击 + 快速温和屏蔽）'),
            _records(blocked: false),
            const SizedBox(height: 32),
          ],
        );
      }),
    );
  }
}
