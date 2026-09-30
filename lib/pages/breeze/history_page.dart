import 'dart:async';

import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/services/breeze/breeze_rules.dart';
import 'package:PiliPlus/services/breeze/breeze_service.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:material_ui/material_ui.dart';

enum _Scope {
  ads('只看广告'),
  all('全部记录'),
  filtered('已折叠'),
  giveaway('抽奖'),
  event('活动宣传'),
  recruitment('招聘'),
  dynamic('动态广告'),
  pinned('置顶评论广告');

  final String label;
  const _Scope(this.label);
}

class BreezeHistoryPage extends StatefulWidget {
  const BreezeHistoryPage({super.key});

  @override
  State<BreezeHistoryPage> createState() => _BreezeHistoryPageState();
}

class _BreezeHistoryPageState extends State<BreezeHistoryPage> {
  List<Map> _records = BreezeService.history;
  StreamSubscription? _sub;
  Timer? _debounce;
  _Scope _scope = _Scope.ads;
  String _query = '';
  int _limit = 100;

  @override
  void initState() {
    super.initState();
    _sub = BreezeService.watchHistory().listen((_) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _records = BreezeService.history);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _sub?.cancel();
    super.dispose();
  }

  static List<String> _categories(Map r) =>
      (r['categories'] as List?)?.whereType<String>().toList() ??
      [r['kind'] as String? ?? ''];

  static bool _isAd(Map r) => _categories(r).contains('ad');

  bool _matches(Map r) {
    final categories = _categories(r);
    final scope = switch (_scope) {
      _Scope.all => true,
      _Scope.filtered => r['action'] == '折叠',
      _Scope.giveaway ||
      _Scope.event ||
      _Scope.recruitment => categories.contains(_scope.name),
      _Scope.ads => _isAd(r),
      _Scope.dynamic || _Scope.pinned => _isAd(r) && r['type'] == _scope.name,
    };
    if (!scope) return false;
    if (_query.isEmpty) return true;
    return '${r['author']} ${r['preview']}'.toLowerCase().contains(_query);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline;
    final records = _records;
    final filtered = records.where(_matches).toList();

    final authors = <String, ({String name, int total, int ads})>{};
    for (final r in records) {
      final key = (r['authorId'] as String?)?.isNotEmpty == true
          ? r['authorId'] as String
          : r['author'] as String;
      final a = authors[key];
      authors[key] = (
        name: r['author'] as String,
        total: (a?.total ?? 0) + 1,
        ads: (a?.ads ?? 0) + (_isAd(r) ? 1 : 0),
      );
    }
    final ranking = authors.values.where((a) => a.ads > 0).toList()
      ..sort((a, b) {
        final c = b.ads.compareTo(a.ads);
        return c != 0 ? c : b.total.compareTo(a.total);
      });

    Widget stat(String label, int value) => Expanded(
      child: Column(
        children: [
          Text('$value', style: theme.textTheme.titleLarge),
          Text(label, style: TextStyle(color: outline, fontSize: 12)),
        ],
      ),
    );

    return SimpleScaffold(
      appBar: AppBar(title: const Text('记录与统计')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                '统计来自本机检测记录，同一条内容只计一次。置顶评论归入视频 UP 主名下。最多保存 5,000 条记录，仅存本机。',
                style: TextStyle(color: outline, fontSize: 12),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  stat('已检测', records.length),
                  stat('识别为广告', records.where(_isAd).length),
                  stat('折叠', records.where((r) => r['action'] == '折叠').length),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ExpansionTile(
              title: const Text('UP 主广告统计'),
              subtitle: Text(
                '按识别为广告的条数排序。占比仅代表已检测内容，模型判断可能有误。',
                style: TextStyle(color: outline, fontSize: 12),
              ),
              children: [
                if (ranking.isEmpty)
                  const ListTile(title: Text('暂无广告记录'))
                else
                  for (final a in ranking.take(50))
                    ListTile(
                      dense: true,
                      title: Text(a.name),
                      trailing: Text(
                        '${a.ads} / ${a.total} · ${(a.ads / a.total * 100).round()}%',
                        style: TextStyle(color: outline),
                      ),
                    ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        isDense: true,
                        prefixIcon: Icon(Icons.search),
                        hintText: '搜索 UP 主或内容',
                      ),
                      onChanged: (v) => setState(() {
                        _query = v.trim().toLowerCase();
                        _limit = 100;
                      }),
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<_Scope>(
                    value: _scope,
                    items: [
                      for (final s in _Scope.values)
                        DropdownMenuItem(value: s, child: Text(s.label)),
                    ],
                    onChanged: (v) => setState(() {
                      _scope = v ?? _scope;
                      _limit = 100;
                    }),
                  ),
                ],
              ),
            ),
          ),
          if (filtered.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text('暂无匹配记录', style: TextStyle(color: outline)),
                ),
              ),
            ),
          SliverList.builder(
            itemCount: filtered.length.clamp(0, _limit),
            itemBuilder: (context, index) => _Entry(filtered[index]),
          ),
          if (filtered.length > _limit)
            SliverToBoxAdapter(
              child: Center(
                child: TextButton(
                  onPressed: () => setState(() => _limit += 100),
                  child: const Text('显示更多'),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.viewPaddingOf(context).bottom + 100,
            ),
          ),
        ],
      ),
    );
  }
}

class _Entry extends StatelessWidget {
  const _Entry(this.r);

  final Map r;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final meta = TextStyle(color: theme.colorScheme.outline, fontSize: 12);
    final sample = r['cautionSample'] as Map?;
    final auto = r['autoCautious'] as Map?;
    final prob = (r['prob'] as num?)?.toDouble() ?? 0;
    final lastSeen = r['lastSeen'] as int? ?? 0;
    final url = r['url'] as String? ?? '';
    final lines = <String>[
      if (r['giveawayType'] == 'incidental') '附带抽奖',
      if (r['giveawayType'] == 'uncertain') '抽奖类型不确定，保留显示',
      if (sample != null)
        ...switch (r['cautionStatus']) {
          'missing_uid' => ['未获取 UP 主 UID，暂不能计算自动谨慎模式。'],
          'collecting' => [
            '正在积累动态：${sample['total']} / ${sample['required']} 条',
          ],
          'inactive' => [
            '最近 ${sample['total']} 条中 ${sample['ads']} 条广告，未达到 ${sample['trigger']}%',
          ],
          _ => const <String>[],
        },
      if (auto != null) '自动加入名单时：${auto['total']} 条中 ${auto['ads']} 条广告',
      if (r['enhanced'] == true)
        '谨慎模式 · 广告置信度 ${(prob * 100).round()}% · 折叠门槛 ${r['adThreshold'] ?? 90}%',
    ];
    return InkWell(
      onTap: url.isEmpty ? null : () => PiliScheme.routePushFromUrl(url),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Text(
              '${r['author']} · ${breezeCategoryLabels[r['kind']] ?? '其他'} · ${r['action']}',
              style: theme.textTheme.titleSmall,
            ),
            for (final line in lines) Text(line, style: meta),
            Text(r['preview'] as String? ?? ''),
            Text(
              '${r['type'] == 'pinned' ? '视频置顶评论' : '动态'} · 最近检测 ${DateFormatUtils.format(lastSeen ~/ 1000, format: DateFormatUtils.longFormatD)}',
              style: meta,
            ),
          ],
        ),
      ),
    );
  }
}
