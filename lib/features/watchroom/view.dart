import 'package:PiliPlus/utils/accounts.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

import 'model.dart';
import 'piliplus_adapter.dart';

/// This route is only an entry form. An established room lives in the player.
class WatchroomPage extends StatefulWidget {
  final String? link;
  final int? episodeId, seasonId;
  final bool embedded;
  const WatchroomPage({
    super.key,
    this.link,
    this.episodeId,
    this.seasonId,
    this.embedded = false,
  });
  @override
  State<WatchroomPage> createState() => _WatchroomPageState();
}

class _WatchroomPageState extends State<WatchroomPage> {
  final adapter = WatchroomAdapter.instance;
  late final invite = TextEditingController(text: widget.link);
  late final episode = TextEditingController(
    text: widget.episodeId?.toString(),
  );
  bool working = false;
  String problem = '';

  @override
  void dispose() {
    invite.dispose();
    episode.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    if (working) return;
    setState(() {
      working = true;
      problem = '';
    });
    try {
      await action();
      if (mounted) await adapter.openPlayer(replaceEntry: !widget.embedded);
    } catch (e) {
      if (mounted) setState(() => problem = '$e');
    } finally {
      if (mounted) setState(() => working = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('B站放映厅')),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('通过好友邀请加入，或使用剧集 EP 号创建放映厅。'),
          const SizedBox(height: 16),
          if (!Accounts.main.isLogin) ...[
            FilledButton.tonal(
              onPressed: () async {
                await Get.toNamed<void>('/loginPage');
                if (mounted) setState(() {});
              },
              child: const Text('登录 PiliPlus 主账号'),
            ),
            const SizedBox(height: 16),
          ],
          TextField(
            key: const ValueKey('watchroom-invite'),
            controller: invite,
            minLines: 1,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: '邀请链接或房间号',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: working
                ? null
                : () => _run(() => adapter.join(invite.text)),
            icon: const Icon(Icons.group_add_outlined),
            label: const Text('加入官方放映厅'),
          ),
          const SizedBox(height: 16),
          ExpansionTile(
            title: const Text('创建放映厅'),
            initiallyExpanded: widget.episodeId != null,
            children: [
              TextField(
                controller: episode,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '剧集 EP 号',
                  hintText: '例如 373924',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: working
                    ? null
                    : () => _run(
                        () => adapter.create(
                          episode: roomInt(episode.text),
                          season: widget.seasonId,
                        ),
                      ),
                child: const Text('创建放映厅'),
              ),
            ],
          ),
          if (working) const LinearProgressIndicator(),
          if (problem.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SelectableText(
                problem,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    ),
  );
}
