import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/services/playback_stats_service.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart' hide ListTile;

class PlaybackStatsPage extends StatefulWidget {
  const PlaybackStatsPage({super.key});

  @override
  State<PlaybackStatsPage> createState() => _PlaybackStatsPageState();
}

class _PlaybackStatsPageState extends State<PlaybackStatsPage> {
  late Map<String, dynamic> stats = PlaybackStatsService.snapshot();

  num _value(String key) => stats[key] as num? ?? 0;
  Map<String, dynamic> get _derived => stats['derived'] as Map<String, dynamic>;

  String _duration(num microseconds) {
    final negative = microseconds < 0;
    var seconds = (microseconds.abs() / 1000000).round();
    final days = seconds ~/ 86400;
    seconds %= 86400;
    final hours = seconds ~/ 3600;
    seconds %= 3600;
    final minutes = seconds ~/ 60;
    seconds %= 60;
    final parts = [
      if (days > 0) '$days天',
      if (hours > 0) '$hours小时',
      if (minutes > 0) '$minutes分钟',
      if (seconds > 0 || days == 0 && hours == 0 && minutes == 0) '$seconds秒',
    ];
    return '${negative ? '-' : ''}${parts.join()}';
  }

  String _speed(num? value) {
    if (value == null || !value.isFinite || value == 0) return '暂无数据';
    final text = value
        .toStringAsFixed(2)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(
          RegExp(r'\.$'),
          '',
        );
    return '$text 倍';
  }

  Widget _section(String title) => Padding(
    padding: const .fromLTRB(16, 20, 16, 4),
    child: Text(title, style: Theme.of(context).textTheme.titleMedium),
  );

  Widget _item(String title, String value, [String? subtitle]) => ListTile(
    title: Text(title),
    subtitle: subtitle == null ? null : Text(subtitle),
    trailing: Text(value, style: Theme.of(context).textTheme.titleMedium),
  );

  Future<void> _reset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空倍速统计？'),
        content: const Text('这会删除已经累计的播放、倒带与直播统计，无法撤销。'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('取消')),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('清空'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await PlaybackStatsService.reset();
      if (mounted) setState(() => stats = PlaybackStatsService.snapshot());
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorite = _derived['favoriteSpeed'] as num?;
    final favoriteDefault = _derived['favoriteSpeedWasDefault'] == true;
    final eligibleRewinds = _value('eligibleRewindCount');
    final completionRate = _derived['rewindCompletionRate'] as num? ?? 0;
    final speedSelections =
        (_derived['speedSelectionCounts'] as Map?)?.entries.toList()
          ?..sort((a, b) => (b.value as num).compareTo(a.value as num));

    return SimpleScaffold(
      appBar: AppBar(
        title: const Text('倍速统计详情'),
        actions: [
          TextButton(onPressed: _reset, child: const Text('清空')),
          const SizedBox(width: 8),
        ],
      ),
      body: ViewSafeArea(
        child: ListView(
          padding: .only(bottom: MediaQuery.viewPaddingOf(context).bottom + 48),
          children: [
            Padding(
              padding: const .fromLTRB(16, 12, 16, 4),
              child: Text(
                '这里的“节约时间”只比较连续播放推进的原视频时间与实际播放时间。快进跳过的内容不算节约，暂停和缓冲也单独列出。这样统计的是倍速本身带来的时间变化，而不是把没有观看的内容算成成果。',
                style: TextStyle(color: ColorScheme.of(context).outline),
              ),
            ),
            _section('倍速与时间'),
            _item(
              '您最爱的倍速',
              favorite == null
                  ? '暂无数据'
                  : '${_speed(favorite)}${favoriteDefault ? '（默认）' : ''}',
              '每次手动选择计一次；进入新的 CID 时，当前倍速也计一次',
            ),
            _item('实际平均倍速', _speed(_derived['actualAverageSpeed'] as num?)),
            _item(
              '名义平均倍速',
              _speed(_derived['nominalAverageSpeed'] as num?),
              '按播放器设置的倍速与播放时长加权',
            ),
            _item('实际播放视频时长', _duration(_value('activePlaybackUs'))),
            _item('倍速为您节约', _duration(_derived['savedTimeUs'] as num? ?? 0)),
            _item(
              '播放器累计消耗时间',
              _duration(_derived['playerObservedUs'] as num? ?? 0),
              '实际播放、暂停与缓冲等待之和',
            ),
            _item(
              '在该应用上累计消耗的时间',
              _duration(_value('appForegroundUs')),
              '只统计应用处于前台的时间',
            ),
            _item('暂停累计时间', _duration(_value('pausedUs'))),
            _item('缓冲等待时间', _duration(_value('bufferingUs'))),
            _section('倒带回看'),
            _item('累计倒带时长', _duration(_value('rewindUs'))),
            _item(
              '快倍速倒带时长',
              _duration(_value('fastRewindUs')),
              '倒带发生时倍速大于 1 倍',
            ),
            _item(
              '倒带完播率',
              eligibleRewinds == 0
                  ? '暂无数据'
                  : '${(completionRate * 100).toStringAsFixed(1)}%',
              '重新播放到倒带前检查点视为完成；未完成且停留不足 5 秒不进入分母',
            ),
            _item(
              '倒带后平均等效倍速',
              _speed(_derived['rewindEquivalentSpeed'] as num?),
              '已完成倒带的原视频时长 ÷ 实际重新播放时长',
            ),
            _section('直播'),
            _item('直播累计打开次数', '${_value('liveOpenCount').toInt()} 次'),
            _item('直播累计观看时间', _duration(_value('liveWatchUs'))),
            ExpansionTile(
              title: const Text('高级参数回看'),
              subtitle: const Text('查看可供重新计算或交给 AI 分析的原始统计量'),
              childrenPadding: const .fromLTRB(16, 0, 16, 20),
              children: [
                if (speedSelections?.isNotEmpty == true)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const .only(bottom: 12),
                      child: Text(
                        '倍速选择次数：${speedSelections!.map((entry) => '${entry.key}× ${entry.value}次').join('，')}',
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '数据按正交原语保存：正常观看与倒带重看各自的播放、暂停和缓冲墙钟，以及媒体推进、倍速分桶、名义倍速积分、前进跳转、倒带检查点和按主播 UID 汇总的直播时间。展示公式以后即使调整，也可以用这些原语重新计算。',
                    style: TextStyle(color: ColorScheme.of(context).outline),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonalIcon(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: PlaybackStatsService.advancedJson(),
                        ),
                      );
                      SmartDialog.showToast('高级参数已复制');
                    },
                    icon: const Icon(Icons.copy_outlined),
                    label: const Text('复制高级参数'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: SelectableText(
                    PlaybackStatsService.advancedJson(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
