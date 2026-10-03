import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/pages/video_together/navigation_presenter.dart';
import 'package:PiliPlus/pages/video_together/settings_view.dart';
import 'package:PiliPlus/services/video_together/models.dart';
import 'package:PiliPlus/services/video_together/preferences.dart';
import 'package:PiliPlus/services/video_together/session.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class VideoTogetherPage extends StatefulWidget {
  const VideoTogetherPage({super.key});

  @override
  State<VideoTogetherPage> createState() => _VideoTogetherPageState();
}

class _VideoTogetherPageState extends State<VideoTogetherPage> {
  final _session = VideoTogetherSession.instance;
  late final TextEditingController _roomController;
  late final TextEditingController _passwordController;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _roomController = TextEditingController(
      text: _session.roomName.isNotEmpty
          ? _session.roomName
          : VideoTogetherPreferences.lastRoomName,
    );
    _passwordController = TextEditingController(text: _session.currentPassword);
    _messageController = TextEditingController();
    _session.configureNavigation(
      VideoTogetherNavigationPresenter.open,
      onCancel: VideoTogetherNavigationPresenter.cancel,
    );
  }

  @override
  void dispose() {
    _roomController.dispose();
    _passwordController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
      appBar: AppBar(
        title: const Text('一起看'),
        actions: [
          IconButton(
            tooltip: 'VideoTogether 设置',
            onPressed: () => Get.to(() => const VideoTogetherSettingsPage()),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            if (_session.inRoom) _buildRoom(context) else _buildJoinForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '兼容 VideoTogether 房间',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text('服务器：${VideoTogetherPreferences.server}'),
        const SizedBox(height: 20),
        TextField(
          controller: _roomController,
          autofocus: true,
          maxLength: 128,
          decoration: const InputDecoration(
            labelText: '房间名',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(
            labelText: '房间密码（可留空）',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        if (_session.errorMessage.value case final error?) ...[
          _ErrorCard(message: error),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: _session.isBusy.value
                    ? null
                    : () => _start(create: true),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('创建房间'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _session.isBusy.value
                    ? null
                    : () => _start(create: false),
                icon: const Icon(Icons.login),
                label: const Text('加入房间'),
              ),
            ),
          ],
        ),
        if (_session.isBusy.value) ...[
          const SizedBox(height: 20),
          const Center(child: CircularProgressIndicator()),
        ],
        const SizedBox(height: 24),
        const Text(
          '创建房间后可再打开任意 B 站视频；加入者会按设置处理房间当前的投稿或番剧。'
          '默认弹出确认框，并在 5 秒倒计时结束后进入视频。'
          '加入房间后可在房间页面选择是否允许双向同步控制。'
          '与官方浏览器插件或不支持控制权交接的客户端同房时应关闭该功能。'
          '当前不支持 VideoTogether 的语音和 EasyShare 媒体中继。',
        ),
      ],
    );
  }

  Widget _buildRoom(BuildContext context) {
    _session.preferenceRevision.value;
    final room = _session.room.value;
    final roleText = _session.role.value == VideoTogetherRole.host
        ? '房主'
        : '成员';
    final controlText = _session.isControlling.value ? '控制中' : '跟随中';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _session.roomName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Chip(label: Text('$roleText · $controlText')),
                  ],
                ),
                const SizedBox(height: 8),
                Text('连接：${_connectionLabel(_session.connectionState.value)}'),
                Text('在线成员：${room?.memberCount ?? '-'}'),
                if (room?.videoTitle.isNotEmpty == true)
                  Text('当前视频：${room!.videoTitle}'),
                if (room?.url.isNotEmpty == true)
                  Text(room!.url, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: SwitchListTile(
            title: const Text('允许双向同步控制'),
            subtitle: const Text(
              '仅当房间内所有客户端都支持“最后操作者接管”时开启。\n'
              '与官方 VideoTogether 浏览器插件、旧版或其他客户端同房，'
              '或出现“其他房主正在同步”及反复抢控时请关闭。\n'
              '关闭后普通加入者只能跟随；创建者或曾经持有控制权的客户端仍可重新接管。',
            ),
            value: VideoTogetherPreferences.bidirectionalSync,
            onChanged: (value) async {
              try {
                await _session.setBidirectionalSync(value);
              } catch (error) {
                SmartDialog.showToast('保存双向同步设置失败：$error');
              }
            },
          ),
        ),
        if (_session.errorMessage.value case final error?) ...[
          const SizedBox(height: 8),
          _ErrorCard(message: error),
        ],
        const SizedBox(height: 12),
        if (room?.url.isNotEmpty == true)
          OutlinedButton.icon(
            onPressed: _session.openCurrentRoomVideo,
            icon: const Icon(Icons.open_in_new),
            label: const Text('打开房间视频'),
          ),
        FilledButton.tonalIcon(
          onPressed: _session.leave,
          icon: const Icon(Icons.logout),
          label: const Text('离开房间'),
        ),
        const SizedBox(height: 24),
        Text('房间消息', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(minHeight: 120, maxHeight: 260),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _session.messages.isEmpty
              ? const Center(child: Text('暂无消息'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _session.messages.length,
                  itemBuilder: (_, index) {
                    final message = _session.messages[index];
                    return ListTile(
                      dense: true,
                      title: Text(message.sender),
                      subtitle: Text(message.text),
                      trailing: message.isMine
                          ? const Icon(Icons.person_outline, size: 18)
                          : null,
                    );
                  },
                ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                maxLength: 200,
                minLines: 1,
                maxLines: 3,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: const InputDecoration(
                  labelText: '发送文字消息',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
              ),
            ),
            IconButton(
              tooltip: '发送',
              onPressed: _sendMessage,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _start({required bool create}) async {
    final roomName = _roomController.text.trim();
    if (roomName.isNotEmpty) {
      await GStorage.setting.put(
        VideoTogetherPreferences.lastRoomNameKey,
        roomName,
      );
    }
    try {
      if (create) {
        await _session.createRoom(
          roomName: roomName,
          password: _passwordController.text,
        );
      } else {
        await _session.joinRoom(
          roomName: roomName,
          password: _passwordController.text,
        );
      }
    } catch (error) {
      SmartDialog.showToast(error.toString());
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text;
    if (text.trim().isEmpty) return;
    try {
      await _session.sendTextMessage(text);
      _messageController.clear();
    } catch (error) {
      SmartDialog.showToast(error.toString());
    }
  }

  static String _connectionLabel(VideoTogetherConnectionState state) =>
      switch (state) {
        VideoTogetherConnectionState.disconnected => '已断开',
        VideoTogetherConnectionState.connecting => '连接中',
        VideoTogetherConnectionState.connected => '已连接',
        VideoTogetherConnectionState.reconnecting => '重连中',
        VideoTogetherConnectionState.error => '连接错误',
      };
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(message, style: TextStyle(color: colors.onErrorContainer)),
      ),
    );
  }
}
