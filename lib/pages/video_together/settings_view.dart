import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/services/video_together/navigation.dart';
import 'package:PiliPlus/services/video_together/preferences.dart';
import 'package:PiliPlus/services/video_together/protocol.dart';
import 'package:PiliPlus/services/video_together/session.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class VideoTogetherSettingsPage extends StatefulWidget {
  const VideoTogetherSettingsPage({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<VideoTogetherSettingsPage> createState() =>
      _VideoTogetherSettingsPageState();
}

class _VideoTogetherSettingsPageState extends State<VideoTogetherSettingsPage> {
  late final TextEditingController _serverController;
  late final TextEditingController _nicknameController;
  late VideoTogetherNavigationMode _navigationMode;
  late bool _syncPlaybackRate;
  late bool _waitForLoading;
  late bool _passwordProtected;
  late bool _hidePlayerEntryWhenNotInRoom;
  late double _syncThreshold;

  @override
  void initState() {
    super.initState();
    _serverController = TextEditingController(
      text: VideoTogetherPreferences.server,
    );
    _nicknameController = TextEditingController(
      text: VideoTogetherPreferences.nickname,
    );
    _navigationMode = VideoTogetherPreferences.navigationMode;
    _syncPlaybackRate = VideoTogetherPreferences.syncPlaybackRate;
    _waitForLoading = VideoTogetherPreferences.waitForLoading;
    _passwordProtected = VideoTogetherPreferences.passwordProtected;
    _hidePlayerEntryWhenNotInRoom =
        VideoTogetherPreferences.hidePlayerEntryWhenNotInRoom;
    _syncThreshold = VideoTogetherPreferences.syncThreshold;
  }

  @override
  void dispose() {
    _serverController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        TextField(
          controller: _serverController,
          keyboardType: TextInputType.url,
          autocorrect: false,
          decoration: const InputDecoration(
            labelText: '服务器地址',
            helperText: '默认复用 VideoTogether 官方公开服务器',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _resetServer,
                icon: const Icon(Icons.restore),
                label: const Text('恢复默认'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _testServer,
                icon: const Icon(Icons.network_check),
                label: const Text('测试连接'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _nicknameController,
          maxLength: 32,
          decoration: const InputDecoration(
            labelText: '文字消息显示名称',
            border: OutlineInputBorder(),
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('未加入房间时隐藏'),
          subtitle: const Text('加入房间后，视频操作栏中的“一起看”入口始终显示'),
          value: _hidePlayerEntryWhenNotInRoom,
          onChanged: (value) =>
              setState(() => _hidePlayerEntryWhenNotInRoom = value),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('房间视频打开方式'),
          subtitle: Text(
            '${_navigationModeLabel(_navigationMode)}：'
            '${_navigationModeDescription(_navigationMode)}',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: _selectNavigationMode,
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('同步播放倍速'),
          subtitle: const Text('跟随当前控制端的播放倍速'),
          value: _syncPlaybackRate,
          onChanged: (value) => setState(() => _syncPlaybackRate = value),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('等待成员缓冲'),
          subtitle: const Text('服务端报告其他成员正在缓冲时，控制端暂时暂停'),
          value: _waitForLoading,
          onChanged: (value) => setState(() => _waitForLoading = value),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('密码保护房间'),
          subtitle: const Text('无密码房间仍可创建；关闭后加入者无需密码读取状态'),
          value: _passwordProtected,
          onChanged: (value) => setState(() => _passwordProtected = value),
        ),
        const SizedBox(height: 8),
        Text('播放中进度校正阈值：${_syncThreshold.toStringAsFixed(1)} 秒'),
        Slider(
          value: _syncThreshold,
          min: 0.1,
          max: 5,
          divisions: 49,
          label: '${_syncThreshold.toStringAsFixed(1)} 秒',
          onChanged: (value) => setState(() => _syncThreshold = value),
        ),
        const Text('服务器地址的修改只影响下一次创建或加入房间。房间密码不会写入设置或日志。'),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.save_outlined),
          label: const Text('保存设置'),
        ),
      ],
    );

    if (!widget.showAppBar) return body;
    return SimpleScaffold(
      appBar: AppBar(title: const Text('VideoTogether 设置')),
      body: body,
    );
  }

  void _resetServer() {
    _serverController.text = VideoTogetherProtocol.defaultServer;
  }

  Future<void> _testServer() async {
    try {
      final uri = VideoTogetherProtocol.timestampUri(_serverController.text);
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
        ),
      );
      try {
        final response = await dio.getUri<Map<String, dynamic>>(uri);
        if (response.data?['timestamp'] is num) {
          SmartDialog.showToast('服务器连接成功');
        } else {
          throw const FormatException('服务器响应中缺少 timestamp');
        }
      } finally {
        dio.close();
      }
    } catch (error) {
      SmartDialog.showToast('连接失败：$error');
    }
  }

  Future<void> _save() async {
    try {
      final server = VideoTogetherProtocol.serverUri(_serverController.text)
          .toString();
      final nickname = _nicknameController.text.trim();
      await GStorage.setting.putAll({
        VideoTogetherPreferences.serverKey: server,
        VideoTogetherPreferences.nicknameKey: nickname.isEmpty
            ? 'PiliPlus 用户'
            : nickname,
        VideoTogetherPreferences.navigationModeKey: _navigationMode.name,
        // Preserve a conservative value for older builds that only know this key.
        VideoTogetherPreferences.autoOpenVideoKey:
            _navigationMode == VideoTogetherNavigationMode.always,
        VideoTogetherPreferences.syncPlaybackRateKey: _syncPlaybackRate,
        VideoTogetherPreferences.waitForLoadingKey: _waitForLoading,
        VideoTogetherPreferences.passwordProtectedKey: _passwordProtected,
        VideoTogetherPreferences.syncThresholdKey: _syncThreshold,
        VideoTogetherPreferences.hidePlayerEntryWhenNotInRoomKey:
            _hidePlayerEntryWhenNotInRoom,
      });
      VideoTogetherSession.instance.refreshPreferences();
      SmartDialog.showToast('设置已保存');
      if (widget.showAppBar) Get.back();
    } catch (error) {
      SmartDialog.showToast(error.toString());
    }
  }

  Future<void> _selectNavigationMode() async {
    final result = await showDialog<VideoTogetherNavigationMode>(
      context: context,
      builder: (context) => SelectDialog<VideoTogetherNavigationMode>(
        title: '房间视频打开方式',
        value: _navigationMode,
        values: _navigationModeOptions,
        subtitleBuilder: (_, index) => Text(
          _navigationModeDescription(_navigationModeOptions[index].$1),
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() => _navigationMode = result);
    }
  }

  static const List<(VideoTogetherNavigationMode, String)>
  _navigationModeOptions = [
    (VideoTogetherNavigationMode.always, '始终自动进入'),
    (VideoTogetherNavigationMode.videoPageOnly, '仅在视频页自动切换'),
    (VideoTogetherNavigationMode.never, '从不自动进入'),
    (VideoTogetherNavigationMode.countdown, '倒计时弹窗确认（默认）'),
  ];

  static String _navigationModeLabel(VideoTogetherNavigationMode mode) =>
      switch (mode) {
        VideoTogetherNavigationMode.always => '始终自动进入',
        VideoTogetherNavigationMode.videoPageOnly => '仅在视频页自动切换',
        VideoTogetherNavigationMode.never => '从不自动进入',
        VideoTogetherNavigationMode.countdown => '倒计时弹窗确认',
      };

  static String _navigationModeDescription(
    VideoTogetherNavigationMode mode,
  ) => switch (mode) {
    VideoTogetherNavigationMode.always => '房间切换视频后立即进入',
    VideoTogetherNavigationMode.videoPageOnly => '只在当前已打开视频页时自动切换',
    VideoTogetherNavigationMode.never => '仅从房间页手动打开',
    VideoTogetherNavigationMode.countdown => '弹窗确认，5 秒后自动进入',
  };
}
