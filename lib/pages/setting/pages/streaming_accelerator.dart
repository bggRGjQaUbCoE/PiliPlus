import 'dart:convert';

import 'package:PiliPlus/services/video_accelerator/accelerator_config.dart';
import 'package:PiliPlus/services/video_accelerator/accelerator_diagnostics.dart';
import 'package:material_ui/material_ui.dart';

class StreamingAcceleratorPage extends StatefulWidget {
  const StreamingAcceleratorPage({
    super.key,
    required this.mode,
    required this.onChanged,
  });
  final AcceleratorMode mode;
  final Future<void> Function(AcceleratorMode) onChanged;
  @override
  State<StreamingAcceleratorPage> createState() =>
      _StreamingAcceleratorPageState();
}

class _StreamingAcceleratorPageState extends State<StreamingAcceleratorPage> {
  late AcceleratorMode mode = widget.mode;
  bool saving = false;
  Future<void> select(AcceleratorMode next) async {
    if (saving) return;
    setState(() => saving = true);
    try {
      await widget.onChanged(next);
      if (mounted) setState(() => mode = next);
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('播放加速 / Streaming Accelerator')),
    body: ListView(
      children: [
        const ListTile(
          title: Text('PiliBoost Accelerator · V1c'),
          subtitle: Text('默认关闭。设置在下次加载视频/切换画质时生效；原 CDN 设置仍保留。'),
        ),
        for (final entry in const {
          AcceleratorMode.off: '关闭 / OFF',
          AcceleratorMode.auto: '自动 / Auto（V1：CDN 优选）',
          AcceleratorMode.smartCdn: 'CDN 优选 / Smart CDN',
          AcceleratorMode.rangeProxy: '本地 Range 代理 / Proxy（实验，单连接）',
        }.entries)
          ListTile(
            title: Text(entry.value),
            trailing: mode == entry.key ? const Icon(Icons.check) : null,
            enabled: !saving,
            onTap: () => select(entry.key),
          ),
        const ListTile(
          enabled: false,
          title: Text('多线程 / Multi-Range'),
          subtitle: Text('V2 尚未开放；并发 Auto / 4 / 8 / 12 / 16 届时可用'),
        ),
        const ListTile(
          enabled: false,
          title: Text('多 CDN 多线程 / Multi-CDN'),
          subtitle: Text('V3 尚未开放'),
        ),
        const ListTile(
          title: Text('缓存与带宽'),
          subtitle: Text(
            '不增加缓存或预读。Proxy 固定单条视频源，音频仍直连；支持 Range/seek 和实际转发计量，不测速切线，不启用多线程。Auto/CDN 优选仍每轮至多 2 次 256 KiB 探测，间隔至少 30 秒。',
          ),
        ),
        ListTile(
          title: const Text('加速状态 / Diagnostics'),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const AcceleratorDiagnosticsPage(),
            ),
          ),
        ),
      ],
    ),
  );
}

class AcceleratorDiagnosticsPage extends StatelessWidget {
  const AcceleratorDiagnosticsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('PiliBoost Diagnostics')),
    body: StreamBuilder<Map<String, Object?>>(
      initialData: AcceleratorDiagnostics.latest,
      stream: AcceleratorDiagnostics.updates,
      builder: (context, snapshot) {
        final data = snapshot.data ?? const {'state': 'off'};
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('状态：${data['state']}'),
            Text(switch (data['switchOutcome']) {
              'awaitingBufferRecovery' => '已切线，正在观察缓冲；尚未确认改善。',
              'stillLowBuffer' => '切线后仍低缓冲：本次加速尚未达到播放需求。',
              'bufferRecovered' => '缓冲已恢复；不代表长期播放验收通过。',
              _ => '尚未切线。',
            }),
            const Text(
              '吞吐单位 bits/s；TTFB、cooldown 单位 ms；buffer 单位秒。\n'
              'V1 的 aggregateBps 为 mpv cache-speed 辅助值，不是逐轨精确吞吐。\n'
              'Proxy 模式 aggregateBps 为最近约 3 秒视频转发速率，不含音频，也不是去重 goodput。\n'
              'DNS/connect/RTT 未测量时显示 null；不输出签名 URL。',
            ),
            const SizedBox(height: 12),
            SelectableText(const JsonEncoder.withIndent('  ').convert(data)),
          ],
        );
      },
    ),
  );
}
