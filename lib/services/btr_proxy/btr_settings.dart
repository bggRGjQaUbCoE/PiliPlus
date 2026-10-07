import 'package:PiliPlus/services/btr_proxy/btr_proxy.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:material_ui/material_ui.dart';

/// Persists BtrConfig in the app's settings box.
abstract final class BtrSettings {
  static const _enabled = 'btrEnabled',
      _mode = 'btrCdnMode',
      _custom = 'btrCustomHosts',
      _takeover = 'btrTakeover',
      _auto = 'btrAutoThreads',
      _threads = 'btrThreads',
      _live = 'btrLiveBoost';

  static void load() {
    final s = GStorage.setting;
    BtrConfig.enabled = s.get(_enabled, defaultValue: true);
    BtrConfig.mode =
        BtrCdnMode.values.asNameMap()[s.get(_mode)] ?? BtrCdnMode.mainland;
    BtrConfig.customHosts = List<String>.from(
      s.get(_custom, defaultValue: const <String>[]),
    );
    BtrConfig.takeover =
        BtrTakeover.values.asNameMap()[s.get(_takeover)] ?? BtrTakeover.full;
    BtrConfig.autoThreads = s.get(_auto, defaultValue: true);
    BtrConfig.threads = s.get(_threads, defaultValue: 8);
    BtrConfig.liveBoost = s.get(_live, defaultValue: true);
  }

  static void save() {
    GStorage.setting.putAll({
      _enabled: BtrConfig.enabled,
      _mode: BtrConfig.mode.name,
      _custom: BtrConfig.customHosts,
      _takeover: BtrConfig.takeover.name,
      _auto: BtrConfig.autoThreads,
      _threads: BtrConfig.threads,
      _live: BtrConfig.liveBoost,
    });
  }

  static String get summary {
    if (!BtrConfig.enabled) return '已关闭';
    final t = BtrConfig.autoThreads ? '自动线程' : '${BtrConfig.threads} 线程';
    return '${BtrConfig.mode.label} · ${BtrConfig.takeover.label} · $t'
        '${BtrConfig.liveBoost ? ' · 直播加速' : ''}';
  }
}

class BtrSettingsPage extends StatefulWidget {
  const BtrSettingsPage({super.key});

  @override
  State<BtrSettingsPage> createState() => _BtrSettingsPageState();
}

class _BtrSettingsPageState extends State<BtrSettingsPage> {
  void _set(VoidCallback f) {
    setState(f);
    BtrSettings.save();
  }

  Future<void> _addHost() async {
    var v = '';
    final res = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加服务器'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '例如 upos-sz-mirrorali.bilivideo.com',
          ),
          onChanged: (s) => v = s,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, v),
            child: const Text('添加'),
          ),
        ],
      ),
    );
    final host = res
        ?.trim()
        .replaceFirst(RegExp(r'^https?://'), '')
        .split('/')
        .first;
    if (host == null || host.isEmpty) return;
    _set(
      () => BtrConfig.customHosts = {...BtrConfig.customHosts, host}.toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.outline,
    );
    final on = BtrConfig.enabled;
    final knownHosts = [
      ...BtrConfig.mainlandHosts,
      ...BtrConfig.overseasHosts,
    ];
    Widget header(String t) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        t,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('线程撕裂者 (多线程加速)')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          SwitchListTile(
            title: const Text('启用多线程加速'),
            subtitle: const Text('把视频分段拆成小块，多条连接、多个节点并发下载'),
            value: on,
            onChanged: (v) => _set(() => BtrConfig.enabled = v),
          ),
          IgnorePointer(
            ignoring: !on,
            child: Opacity(
              opacity: on ? 1 : 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  header('CDN 模式'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SegmentedButton<BtrCdnMode>(
                      segments: [
                        for (final m in BtrCdnMode.values)
                          ButtonSegment(value: m, label: Text(m.label)),
                      ],
                      selected: {BtrConfig.mode},
                      onSelectionChanged: (s) =>
                          _set(() => BtrConfig.mode = s.first),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(
                      '大陆：直接去大陆节点拿冷门视频，推荐。\n'
                      '海外：本地连大陆网络太差时使用。\n'
                      '自定义：只用下面勾选的服务器，一个都没选时按大陆处理。',
                      style: muted,
                    ),
                  ),
                  if (BtrConfig.mode == BtrCdnMode.custom) ...[
                    for (final h in {...knownHosts, ...BtrConfig.customHosts})
                      CheckboxListTile(
                        dense: true,
                        title: Text(h),
                        value: BtrConfig.customHosts.contains(h),
                        onChanged: (v) => _set(() {
                          final l = [...BtrConfig.customHosts]..remove(h);
                          if (v == true) l.add(h);
                          BtrConfig.customHosts = l;
                        }),
                      ),
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.add),
                      title: const Text('添加服务器'),
                      onTap: _addHost,
                    ),
                  ],
                  header('接管方式'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SegmentedButton<BtrTakeover>(
                      segments: [
                        for (final t in BtrTakeover.values)
                          ButtonSegment(value: t, label: Text(t.label)),
                      ],
                      selected: {BtrConfig.takeover},
                      onSelectionChanged: (s) =>
                          _set(() => BtrConfig.takeover = s.first),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(
                      '全接管：本地代理多线程下载再交给播放器，速度最快。\n'
                      '兼容模式：只测速挑最快的节点，由播放器自己单线程下载。遇到播放问题时试试。',
                      style: muted,
                    ),
                  ),
                  header('线程数'),
                  SwitchListTile(
                    title: const Text('自动线程数（推荐）'),
                    subtitle: const Text('按可用节点数量自动决定，4 到 16 条'),
                    value: BtrConfig.autoThreads,
                    onChanged: BtrConfig.takeover == BtrTakeover.full
                        ? (v) => _set(() => BtrConfig.autoThreads = v)
                        : null,
                  ),
                  ListTile(
                    enabled:
                        !BtrConfig.autoThreads &&
                        BtrConfig.takeover == BtrTakeover.full,
                    title: Text(
                      '手动线程数：${BtrConfig.autoThreads ? '自动' : BtrConfig.threads}',
                    ),
                    subtitle: Slider(
                      value: BtrConfig.threadOptions
                          .indexOf(BtrConfig.threads)
                          .clamp(0, BtrConfig.threadOptions.length - 1)
                          .toDouble(),
                      max: BtrConfig.threadOptions.length - 1.0,
                      divisions: BtrConfig.threadOptions.length - 1,
                      label: '${BtrConfig.threads}',
                      onChanged:
                          BtrConfig.autoThreads ||
                              BtrConfig.takeover != BtrTakeover.full
                          ? null
                          : (v) => _set(
                              () => BtrConfig.threads =
                                  BtrConfig.threadOptions[v.round()],
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('手机性能弱时建议 4 到 8 条', style: muted),
                  ),
                  header('直播'),
                  SwitchListTile(
                    title: const Text('直播加速（实验性）'),
                    subtitle: const Text('打开直播时让官方节点竞速选最快的，跳过 P2P 节点'),
                    value: BtrConfig.liveBoost,
                    onChanged: (v) => _set(() => BtrConfig.liveBoost = v),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Text('设置在下一个视频或重新打开播放时生效', style: muted),
          ),
        ],
      ),
    );
  }
}
