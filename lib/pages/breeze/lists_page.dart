import 'dart:async';

import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/services/breeze/breeze_rules.dart';
import 'package:PiliPlus/services/breeze/breeze_service.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class BreezeListsPage extends StatelessWidget {
  const BreezeListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SimpleScaffold(
        appBar: AppBar(
          title: const Text('UP 主名单'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '谨慎过滤'),
              Tab(text: '始终显示'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _AuthorList(
              listKey: BreezeKey.enhancedList,
              description:
                  '只折叠达到谨慎阈值的广告；抽奖、活动宣传和招聘仍按分类开关处理。移除自动添加的 UP 主后，不会再自动加回。',
            ),
            _AuthorList(
              listKey: BreezeKey.whitelist,
              description: '不折叠这些 UP 主的内容，也不调用 API。两个名单同时启用时，白名单优先。',
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthorList extends StatefulWidget {
  const _AuthorList({required this.listKey, required this.description});

  final String listKey;
  final String description;

  @override
  State<_AuthorList> createState() => _AuthorListState();
}

class _AuthorListState extends State<_AuthorList>
    with AutomaticKeepAliveClientMixin {
  final _input = TextEditingController();
  StreamSubscription<BreezeEvent>? _sub;
  final _resolving = <String>{};
  String _status = '';
  bool _adding = false;

  List<BreezeAuthor> get _entries => widget.listKey == BreezeKey.whitelist
      ? BreezeService.config.whitelist
      : BreezeService.config.enhancedList;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _sub = BreezeService.events.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _input.dispose();
    super.dispose();
  }

  Future<void> _resolve(String uid) async {
    setState(() => _resolving.add(uid));
    try {
      final name = await BreezeService.lookupName(uid);
      await BreezeService.renameListed(widget.listKey, uid, name);
      _status = '已添加：$name';
    } catch (_) {
      _status = '已添加 UID，名字获取失败，可重试。';
    }
    if (mounted) setState(() => _resolving.remove(uid));
  }

  Future<void> _add() async {
    final uid = _input.text.trim();
    if (!RegExp(r'^[1-9][0-9]{0,19}$').hasMatch(uid)) {
      setState(() => _status = '请输入纯数字 UID，不支持名字。');
      return;
    }
    setState(() => _adding = true);
    try {
      await BreezeService.setListed(widget.listKey, uid, add: true);
      _input.clear();
      _status = '已添加，正在获取名字…';
      await _resolve(uid);
    } catch (e) {
      _status = '保存失败：$e';
    }
    if (mounted) setState(() => _adding = false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline;
    final entries = _entries.reversed.toList();
    return ListView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Text(
            widget.description,
            style: theme.textTheme.bodySmall!.copyWith(color: outline),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _input,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: 'UP 主 UID'),
                  onSubmitted: (_) => _adding ? null : _add(),
                ),
              ),
              TextButton(
                onPressed: _adding ? null : _add,
                child: const Text('添加'),
              ),
            ],
          ),
        ),
        if (_status.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(_status, style: TextStyle(color: outline)),
          ),
        const SizedBox(height: 8),
        if (entries.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text('暂无 UP 主', style: TextStyle(color: outline)),
            ),
          ),
        for (final e in entries)
          ListTile(
            onTap: () => Get.toNamed('/member?mid=${e.uid}'),
            title: Text(e.name.isEmpty ? '暂未获取名字' : e.name),
            subtitle: Text(
              'UID ${e.uid}${e.isAuto ? ' · 自动添加' : ''}',
              style: TextStyle(color: outline),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: e.name.isEmpty ? '获取名字' : '刷新名字',
                  onPressed: _resolving.contains(e.uid)
                      ? null
                      : () => _resolve(e.uid),
                  icon: const Icon(Icons.refresh),
                ),
                IconButton(
                  tooltip: '移除',
                  onPressed: () => BreezeService.setListed(
                    widget.listKey,
                    e.uid,
                    add: false,
                  ),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
