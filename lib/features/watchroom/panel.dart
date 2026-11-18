import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'session.dart';

/// The same room content is used in the video tabs and the fullscreen drawer.
class WatchroomPanel extends StatefulWidget {
  final RoomSession session;
  final Future<void> Function()? copyInvitation;
  final VoidCallback? onClose;
  final String draft;
  final ValueChanged<String>? onDraftChanged;
  final ValueChanged<String>? onNotice;
  const WatchroomPanel({
    super.key,
    required this.session,
    this.copyInvitation,
    this.onClose,
    this.draft = '',
    this.onDraftChanged,
    this.onNotice,
  });

  @override
  State<WatchroomPanel> createState() => _WatchroomPanelState();
}

class _WatchroomPanelState extends State<WatchroomPanel> {
  late final message = TextEditingController(text: widget.draft);
  final scroll = ScrollController();
  bool sending = false, inviting = false;
  String problem = '';
  String notice = '';

  @override
  void dispose() {
    message.dispose();
    scroll.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
      if (mounted) setState(() => problem = '');
    } catch (e) {
      if (mounted) setState(() => problem = '$e');
    }
  }

  Future<void> _invite() async {
    if (inviting) return;
    setState(() => inviting = true);
    await _run(() async {
      if (widget.copyInvitation case final copy?) {
        await copy();
      } else {
        final invite = await widget.session.invitationForShare();
        await Clipboard.setData(ClipboardData(text: '${invite.mobileUri}'));
      }
      if (mounted) {
        if (widget.onNotice case final show?) {
          show('邀请链接已复制');
        } else {
          setState(() => notice = '邀请链接已复制');
        }
      }
    });
    if (mounted) setState(() => inviting = false);
  }

  Future<void> _send() async {
    final text = message.text.trim();
    if (sending || widget.session.exiting || text.isEmpty) return;
    setState(() => sending = true);
    await _run(() async {
      await widget.session.sendText(text);
      if (mounted && message.text.trim() == text) {
        message.clear();
        widget.onDraftChanged?.call('');
      }
    });
    if (mounted) setState(() => sending = false);
  }

  Future<void> _menu(String action) => _run(() async {
    final session = widget.session;
    switch (action) {
      case 'members':
        final room = session.room;
        if (room == null) return;
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('房间成员'),
            content: SizedBox(
              width: 300,
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final member in room.members)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(member.name),
                      trailing: member.mid == room.ownerId
                          ? const Text('放映员')
                          : null,
                    ),
                  if (room.members.isEmpty) const Text('暂无成员信息'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('关闭'),
              ),
            ],
          ),
        );
      case 'sync':
        await session.refresh();
        if (!session.canControl) await session.setFollow(true);
      case 'control':
        await session.setControl(!session.controlRoom);
      case 'leave':
        final leave = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('退出放映厅？'),
            content: const Text('退出后将停止参与当前房间。收起面板不需要退出。'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('退出放映厅'),
              ),
            ],
          ),
        );
        if (leave == true) {
          await session.exit();
          widget.onDraftChanged?.call('');
          if (mounted) widget.onClose?.call();
        }
    }
  });

  @override
  Widget build(BuildContext context) => StreamBuilder<void>(
    stream: widget.session.changes,
    builder: (context, _) {
      final session = widget.session, room = session.room;
      if (room == null) return const Center(child: Text('已退出放映厅'));
      final issue = problem.isNotEmpty
          ? problem
          : session.playbackError.isNotEmpty
          ? session.playbackError
          : session.error;
      return Material(
        color: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 260;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '放映厅 · ${room.members.length} 人',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        IconButton(
                          tooltip: '邀请好友',
                          onPressed: inviting || session.exiting
                              ? null
                              : _invite,
                          icon: const Icon(Icons.person_add_alt_1_outlined),
                        ),
                        PopupMenuButton<String>(
                          tooltip: '房间操作',
                          enabled: !session.exiting,
                          onSelected: _menu,
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                              value: 'members',
                              child: Text('房间成员'),
                            ),
                            const PopupMenuItem(
                              value: 'sync',
                              child: Text('重新同步'),
                            ),
                            if (session.isOwner)
                              PopupMenuItem(
                                value: 'control',
                                child: Text(
                                  session.controlRoom ? '暂停同步我的操作' : '同步我的播放操作',
                                ),
                              ),
                            const PopupMenuItem(
                              value: 'leave',
                              child: Text('退出放映厅'),
                            ),
                          ],
                        ),
                        if (widget.onClose != null)
                          IconButton(
                            tooltip: '收起放映厅',
                            onPressed: widget.onClose,
                            icon: const Icon(Icons.close),
                          ),
                      ],
                    ),
                    if (!compact)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              session.exiting
                                  ? '正在退出放映厅…'
                                  : session.isOwner
                                  ? (session.canControl ? '你是放映员' : '我的操作同步已关闭')
                                  : (session.followHost ? '正在跟随放映员' : '正在自由观看'),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          if (!session.isOwner)
                            TextButton(
                              onPressed: () => _run(
                                () => session.setFollow(!session.followHost),
                              ),
                              child: Text(session.followHost ? '自由观看' : '恢复跟随'),
                            ),
                        ],
                      ),
                    if (!compact)
                      Text(
                        '房间 ${room.roomId} · ${session.connection}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    if (issue.isNotEmpty)
                      InkWell(
                        onTap: () => showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('放映厅提示'),
                            content: SingleChildScrollView(
                              child: SelectableText(issue),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('关闭'),
                              ),
                            ],
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                issue,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.info_outline, size: 18),
                            ),
                          ],
                        ),
                      ),
                    if (notice.isNotEmpty)
                      Text(
                        notice,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    const Divider(height: 12),
                    Expanded(
                      child: session.messages.isEmpty
                          ? const Center(child: Text('和朋友聊聊吧'))
                          : ListView.builder(
                              key: const PageStorageKey('watchroom-chat'),
                              controller: scroll,
                              reverse: true,
                              itemCount: session.messages.length,
                              itemBuilder: (context, index) {
                                final item =
                                    session.messages[session.messages.length -
                                        index -
                                        1];
                                return Padding(
                                  key: ObjectKey(item),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${item.author}：',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(text: item.text),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextField(
                              key: const ValueKey('watchroom-message'),
                              controller: message,
                              onChanged: widget.onDraftChanged,
                              onSubmitted: (_) => _send(),
                              textInputAction: TextInputAction.send,
                              maxLength: 233,
                              minLines: 1,
                              maxLines: compact ? 1 : 3,
                              decoration: const InputDecoration(
                                hintText: '发送房间消息',
                                counterText: '',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: '发送',
                            onPressed: sending || session.exiting
                                ? null
                                : _send,
                            icon: const Icon(Icons.send),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
