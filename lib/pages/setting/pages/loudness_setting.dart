import 'package:PiliPlus/models/common/audio_normalization.dart';
import 'package:PiliPlus/pages/audio/controller.dart' show AudioController;
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class LoudnessSettingPage extends StatefulWidget {
  const LoudnessSettingPage({super.key});

  @override
  State<LoudnessSettingPage> createState() => _LoudnessSettingPageState();
}

class _LoudnessSettingPageState extends State<LoudnessSettingPage> {
  late String _mode;
  late String _lastEnabledMode;
  late String _fallbackMode;
  late double _targetLufs;
  late double _strength;
  late bool _showPlayerBtn;

  @override
  void initState() {
    super.initState();
    _reloadFromPref();
  }

  void _reloadFromPref() {
    _mode = Pref.audioNormalization;
    _lastEnabledMode = Pref.lastEnabledAudioNormalization;
    _fallbackMode = Pref.fallbackNormalization;
    _targetLufs = Pref.loudnessTarget.toDouble();
    _strength = Pref.loudnessStrength.toDouble();
    _showPlayerBtn = Pref.showPlayerLoudnessBtn;
  }

  bool get _isEnabled => AudioNormalization.isEnabledConfig(_mode);

  String get _activeOrLastMode => _isEnabled ? _mode : _lastEnabledMode;

  bool get _usesLoudnorm =>
      _activeOrLastMode == AudioNormalization.loudnormCode ||
      AudioNormalization.loudnormRegExp.hasMatch(_activeOrLastMode);

  void _syncPlayers() {
    PlPlayerController.instance?.syncAudioNormalizationFromPref();
    AudioController.syncAllAudioNormalization();
  }

  void _toggleEnabled(bool enabled) {
    setState(() {
      if (enabled) {
        _mode = AudioNormalization.isEnabledConfig(_lastEnabledMode)
            ? _lastEnabledMode
            : AudioNormalization.bewlyCode;
        _lastEnabledMode = _mode;
      } else {
        if (_isEnabled) {
          _lastEnabledMode = _mode;
        }
        _mode = AudioNormalization.disableCode;
      }
    });
    GStorage.setting.put(SettingBoxKey.audioNormalization, _mode);
    GStorage.setting.put(
      SettingBoxKey.lastEnabledAudioNormalization,
      _lastEnabledMode,
    );
    _syncPlayers();
  }

  Future<void> _selectMode({bool isFallback = false}) async {
    final current = isFallback ? _fallbackMode : _activeOrLastMode;
    final options = <(String, String)>[
      if (isFallback)
        (AudioNormalization.disableCode, AudioNormalization.disable.title),
      (
        AudioNormalization.bewlyCode,
        '${AudioNormalization.bewly.title}（推荐）',
      ),
      (
        AudioNormalization.dynaudnormCode,
        AudioNormalization.dynaudnorm.title,
      ),
      if (!isFallback)
        (
          AudioNormalization.loudnormCode,
          AudioNormalization.loudnorm.title,
        ),
      if (current != AudioNormalization.disableCode &&
          current != AudioNormalization.bewlyCode &&
          current != AudioNormalization.dynaudnormCode &&
          current != AudioNormalization.loudnormCode &&
          current != AudioNormalization.customCode)
        (current, '自定义: $current'),
      (AudioNormalization.customCode, AudioNormalization.custom.title),
    ];

    final res = await showDialog<String>(
      context: context,
      builder: (context) => SelectDialog<String>(
        title: isFallback ? '无服务端响度数据时回退模式' : '均衡模式',
        toggleable: false,
        value: current,
        values: options,
      ),
    );

    if (res == null || !mounted) return;

    if (res == AudioNormalization.customCode) {
      final initialCustom = (current != AudioNormalization.disableCode &&
              current != AudioNormalization.bewlyCode &&
              current != AudioNormalization.dynaudnormCode &&
              current != AudioNormalization.loudnormCode &&
              current != AudioNormalization.customCode)
          ? current
          : '';
      final customParam = await _promptCustomParam(initialValue: initialCustom);
      if (customParam == null || !mounted) return;
      final trimmed = customParam.trim();
      if (trimmed.isEmpty) return;
      _applySelectedMode(trimmed, isFallback: isFallback);
    } else {
      _applySelectedMode(res, isFallback: isFallback);
    }
  }

  void _applySelectedMode(String selected, {required bool isFallback}) {
    if (isFallback) {
      setState(() => _fallbackMode = selected);
      GStorage.setting.put(SettingBoxKey.fallbackNormalization, selected);
      _syncPlayers();
      return;
    }

    setState(() {
      _mode = selected;
      if (AudioNormalization.isEnabledConfig(selected)) {
        _lastEnabledMode = selected;
      }
    });
    GStorage.setting.put(SettingBoxKey.audioNormalization, _mode);
    if (AudioNormalization.isEnabledConfig(selected)) {
      GStorage.setting.put(
        SettingBoxKey.lastEnabledAudioNormalization,
        _lastEnabledMode,
      );
    }
    _syncPlayers();
  }

  Future<String?> _promptCustomParam({String initialValue = ''}) {
    final textController = TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('自定义滤镜参数'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            const Text('等同于 mpv --af="lavfi=[参数]"'),
            TextField(
              controller: textController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: '例如 dynaudnorm=f=200:g=7:p=0.89',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              '取消',
              style: TextStyle(color: ColorScheme.of(context).outline),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: textController.text),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _onTargetChanged(double value) {
    final rounded = value.round();
    setState(() {
      _targetLufs = value;
      if (!_isEnabled || _mode != AudioNormalization.bewlyCode) {
        _mode = AudioNormalization.bewlyCode;
        _lastEnabledMode = AudioNormalization.bewlyCode;
      }
    });
    PlPlayerController.instance?.setLoudnessTarget(rounded, persist: false);
  }

  void _onTargetChangeEnd(double value) {
    final rounded = value.round();
    GStorage.setting.put(SettingBoxKey.audioNormalization, _mode);
    GStorage.setting.put(
      SettingBoxKey.lastEnabledAudioNormalization,
      _lastEnabledMode,
    );
    GStorage.setting.put(SettingBoxKey.loudnessTarget, rounded);
    _syncPlayers();
  }

  void _onStrengthChanged(double value) {
    final rounded = value.round();
    setState(() {
      _strength = value;
      if (!_isEnabled || _mode != AudioNormalization.bewlyCode) {
        _mode = AudioNormalization.bewlyCode;
        _lastEnabledMode = AudioNormalization.bewlyCode;
      }
    });
    PlPlayerController.instance?.setLoudnessStrength(rounded, persist: false);
  }

  void _onStrengthChangeEnd(double value) {
    final rounded = value.round();
    GStorage.setting.put(SettingBoxKey.audioNormalization, _mode);
    GStorage.setting.put(
      SettingBoxKey.lastEnabledAudioNormalization,
      _lastEnabledMode,
    );
    GStorage.setting.put(SettingBoxKey.loudnessStrength, rounded);
    _syncPlayers();
  }

  void _onShowBtnChanged(bool value) {
    setState(() => _showPlayerBtn = value);
    GStorage.setting.put(SettingBoxKey.showPlayerLoudnessBtn, value);
    PlPlayerController.instance?.setShowPlayerLoudnessBtn(value);
  }

  void _reset() {
    final keys = <String>[
      SettingBoxKey.audioNormalization,
      SettingBoxKey.lastEnabledAudioNormalization,
      SettingBoxKey.fallbackNormalization,
      SettingBoxKey.loudnessTarget,
      SettingBoxKey.loudnessStrength,
      SettingBoxKey.showPlayerLoudnessBtn,
    ];
    for (final key in keys) {
      GStorage.setting.delete(key);
    }
    setState(_reloadFromPref);
    _syncPlayers();
  }

  String _modeSubtitle(String mode) => switch (mode) {
    AudioNormalization.bewlyCode =>
      '跨视频对齐目标响度 + LRA 自适应动态平滑 + -1.0 dBFS 自适应峰值防爆音（推荐）',
    AudioNormalization.dynaudnormCode => '使用传统 dynaudnorm 动态增益平滑',
    AudioNormalization.loudnormCode =>
      '使用服务端响度测量值进行 EBU R128 线性校准',
    _ => '自定义滤镜参数: $mode',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBewly = _activeOrLastMode == AudioNormalization.bewlyCode;
    final activePlayer = PlPlayerController.instance;
    final hasActiveVideo = activePlayer?.videoPlayerController != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('音量均衡'),
        actions: [
          TextButton(
            onPressed: _reset,
            child: const Text('重置'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          SwitchListTile(
            title: const Text('启用音量均衡'),
            subtitle: const Text('自动拉齐不同视频音量，平滑单视频内轻声与高音起伏'),
            value: _isEnabled,
            onChanged: _toggleEnabled,
          ),
          _SectionTitle('基础设置', theme),
          ListTile(
            title: const Text('均衡模式'),
            subtitle: Text(_modeSubtitle(_activeOrLastMode)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 140),
                  child: Text(
                    AudioNormalization.getTitleFromConfig(_activeOrLastMode),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: theme.colorScheme.outline,
                ),
              ],
            ),
            onTap: _selectMode,
          ),
          if (_usesLoudnorm)
            ListTile(
              title: const Text('无响度数据时回退模式'),
              subtitle: const Text('离线缓存、直播或未返回响度元数据的视频使用该回退方案'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AudioNormalization.getTitleFromConfig(_fallbackMode),
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: theme.colorScheme.outline,
                  ),
                ],
              ),
              onTap: () => _selectMode(isFallback: true),
            ),
          if (isBewly) ...[
            ListTile(
              title: const Text('目标响度'),
              subtitle: Text('将不同视频整体音量对齐至 ${_targetLufs.round()} LUFS 左右'),
              trailing: Text(
                '${_targetLufs.round()} LUFS',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Slider(
                value: _targetLufs,
                min: AudioNormalization.minTargetLufs.toDouble(),
                max: AudioNormalization.maxTargetLufs.toDouble(),
                divisions: AudioNormalization.maxTargetLufs -
                    AudioNormalization.minTargetLufs,
                label: '${_targetLufs.round()} LUFS',
                onChanged: _onTargetChanged,
                onChangeEnd: _onTargetChangeEnd,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                '数值越大整体声音越响；默认 -18 LUFS 兼顾人声清晰度与峰值防破音余量。',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
            ListTile(
              title: const Text('均衡强度'),
              subtitle: Text('视频内轻声提亮与突发高音压制力度 ${_strength.round()}%'),
              trailing: Text(
                '${_strength.round()}%',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Slider(
                value: _strength,
                min: AudioNormalization.minStrength.toDouble(),
                max: AudioNormalization.maxStrength.toDouble(),
                divisions: 20,
                label: '${_strength.round()}%',
                onChanged: _onStrengthChanged,
                onChangeEnd: _onStrengthChangeEnd,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                '0% 仅拉齐跨视频整体响度；调高可提升低声对白并抑制突发高音，LRA 自适应避免音乐场景产生抽吸感，低于门限的静音底噪自动冻结不放大。',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
          ],
          _SectionTitle('播放器与生效范围', theme),
          SwitchListTile(
            title: const Text('横屏/全屏顶栏显示快捷按钮'),
            subtitle: const Text('在横屏或全屏顶栏展示音量均衡入口；竖屏小窗可在右上角更多菜单调节'),
            value: _showPlayerBtn,
            onChanged: _onShowBtnChanged,
          ),
          if (hasActiveVideo)
            Obx(() {
              final summary = activePlayer!.loudnessActiveSummary;
              return ListTile(
                title: const Text('当前播放状态'),
                subtitle: Text(summary.shortStatusText),
                leading: Icon(
                  Icons.graphic_eq,
                  color: summary.enabled
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                ),
              );
            }),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              '支持普通视频、后台播放、后台只听音频、听视频、独立听音频、画中画、离线缓存与直播场景，调节参数无需重开视频即可实时生效。',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text, this.theme);

  final String text;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
      child: Text(
        text,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
