import 'dart:io';

import 'package:PiliPlus/models/common/video/audio_quality.dart';
import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/common/video/live_quality.dart';
import 'package:PiliPlus/models/common/video/video_decode_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/common/widgets/flutter/list_tile.dart' as setting_tile;
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/widgets/ordered_multi_select_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/plugin/pl_player/models/audio_output_type.dart';
import 'package:PiliPlus/plugin/pl_player/models/hwdec_type.dart';
import 'package:PiliPlus/utils/filtering_text.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_ui/material_ui.dart';

List<SettingsModel> get videoSettings => [
  const SwitchModel(
    title: '开启硬解',
    subtitle: '以较低功耗播放视频，若异常卡死请关闭',
    leading: Icon(Icons.flash_on_outlined),
    setKey: SettingBoxKey.enableHA,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '免登录1080P',
    subtitle: '免登录查看1080P视频',
    leading: Icon(Icons.hd_outlined),
    setKey: SettingBoxKey.p1080,
    defaultVal: true,
  ),
  NormalModel(
    title: 'B站定向流量支持',
    subtitle: '若套餐含B站定向流量，则会自动使用。可查阅运营商的流量记录确认。',
    leading: const Icon(Icons.perm_data_setting_outlined),
    getTrailing: (theme) => IgnorePointer(
      child: Transform.scale(
        scale: 0.8,
        alignment: Alignment.centerRight,
        child: Switch(
          value: true,
          onChanged: (_) {},
          thumbIcon: WidgetStateProperty.all(
            const Icon(Icons.lock_outline_rounded),
          ),
        ),
      ),
    ),
  ),
  _ManualCdnModel(
    title: 'CDN 设置',
    leading: const Icon(MdiIcons.cloudPlusOutline),
    getSubtitle: () =>
        '当前使用：${VideoUtils.cdnService.desc}，部分 CDN 可能失效，如无法播放请尝试切换',
    onTap: _showCDNDialog,
  ),
  const SwitchModel(
    title: '自动选择 CDN（实验性）',
    leading: Icon(Icons.route_outlined),
    subtitle: '按当前视频有效数据选择来源；独立于并发，开启后暂停手选 CDN。下次播放生效',
    setKey: SettingBoxKey.cdnAutoSelect,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '自适应并发',
    leading: Icon(Icons.auto_graph_outlined),
    subtitle: '并发开启时从少量连接开始；仅有收益时增加，供给不再改善时回退；关闭后使用手动路数与分块',
    setKey: SettingBoxKey.cdnAdaptive,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '并发 CDN 加载（实验性）',
    leading: Icon(Icons.cloud_download_outlined),
    subtitle: '下次播放生效；仅限 DASH 点播。可配合自动选源，也可在手选 CDN 上并发；启用系统代理时不生效',
    setKey: SettingBoxKey.cdnParallelLoading,
    defaultVal: false,
  ),
  NormalModel(
    title: '并发路数',
    leading: const Icon(Icons.call_split_outlined),
    getSubtitle: () =>
        '手动模式：${Pref.cdnParallelConnections} 路（1–32）；自适应开启时自动调整，最多 8 路',
    onTap: (context, setState) => _showParallelValueDialog(
      context,
      setState,
      title: '并发路数',
      key: SettingBoxKey.cdnParallelConnections,
      current: Pref.cdnParallelConnections,
      choices: const [1, 2, 4, 8, 12, 16, 24, 32],
      min: 1,
      max: 32,
      suffix: '路',
    ),
  ),
  NormalModel(
    title: '分块大小',
    leading: const Icon(Icons.view_module_outlined),
    getSubtitle: () =>
        '手动模式：${Pref.cdnParallelChunkSizeKiB} KiB（64–4096）；自适应先连续接收，必要时分块上限 512 KiB',
    onTap: (context, setState) => _showParallelValueDialog(
      context,
      setState,
      title: '分块大小',
      key: SettingBoxKey.cdnParallelChunkSizeKiB,
      current: Pref.cdnParallelChunkSizeKiB,
      choices: const [64, 128, 256, 512, 1024, 2048, 4096],
      min: 64,
      max: 4096,
      suffix: 'KiB',
    ),
  ),
  const NormalModel(
    title: '多 CDN 选择策略',
    leading: Icon(Icons.public_outlined),
    subtitle: '自动选源以当前视频有效数据为准；华为云先尝试，响应慢时启动备用候选；跨源分块仍验证内容一致。不以域名地区或历史测速决定优先级',
  ),
  NormalModel(
    title: '直播 CDN 设置',
    leading: const Icon(MdiIcons.cloudPlusOutline),
    getSubtitle: () => '当前使用：${Pref.liveCdnUrl ?? "默认"}',
    onTap: _showLiveCDNDialog,
  ),
  const _LiveEnhancementSwitchModel(
    title: '直播界面增强（实验性）',
    subtitle: '默认关闭；显示礼物快捷条、聊天互动与粉丝团／大航海面板。独立于 CDN 与画质；付费操作需逐次确认',
    leading: Icon(Icons.live_tv_outlined),
    setKey: SettingBoxKey.liveRoomEnhancement,
  ),
  const _ManualCdnSwitchModel(
    title: 'CDN 测速',
    leading: Icon(Icons.speed),
    subtitle: '测速通过模拟加载视频实现，注意流量消耗，结果仅供参考',
    setKey: SettingBoxKey.cdnSpeedTest,
    defaultVal: true,
  ),
  _ManualCdnSwitchModel(
    title: '音频不跟随 CDN 设置',
    subtitle: '直接采用备用 URL，可解决部分视频无声',
    leading: const Icon(MdiIcons.musicNotePlus),
    setKey: SettingBoxKey.disableAudioCDN,
    defaultVal: false,
    onChanged: (value) => VideoUtils.disableAudioCDN = value,
  ),
  NormalModel(
    title: '默认画质',
    leading: const Icon(Icons.video_settings_outlined),
    getSubtitle: () =>
        '当前画质：${VideoQuality.fromCode(Pref.defaultVideoQa).desc}',
    onTap: _showVideoQaDialog,
  ),
  NormalModel(
    title: '蜂窝网络画质',
    leading: const Icon(Icons.video_settings_outlined),
    getSubtitle: () =>
        '当前画质：${VideoQuality.fromCode(Pref.defaultVideoQaCellular).desc}',
    onTap: _showVideoCellularQaDialog,
  ),
  NormalModel(
    title: '默认音质',
    leading: const Icon(Icons.music_video_outlined),
    getSubtitle: () =>
        '当前音质：${AudioQuality.fromCode(Pref.defaultAudioQa).desc}',
    onTap: _showAudioQaDialog,
  ),
  NormalModel(
    title: '蜂窝网络音质',
    leading: const Icon(Icons.music_video_outlined),
    getSubtitle: () =>
        '当前音质：${AudioQuality.fromCode(Pref.defaultAudioQaCellular).desc}',
    onTap: _showAudioCellularQaDialog,
  ),
  NormalModel(
    title: '直播默认画质',
    leading: const Icon(Icons.video_settings_outlined),
    getSubtitle: () => '当前画质：${LiveQuality.fromCode(Pref.liveQuality)?.desc}',
    onTap: _showLiveQaDialog,
  ),
  NormalModel(
    title: '蜂窝网络直播默认画质',
    leading: const Icon(Icons.video_settings_outlined),
    getSubtitle: () =>
        '当前画质：${LiveQuality.fromCode(Pref.liveQualityCellular)?.desc}',
    onTap: _showLiveCellularQaDialog,
  ),
  NormalModel(
    title: '首选解码格式',
    leading: const Icon(Icons.movie_creation_outlined),
    getSubtitle: () =>
        '首选解码格式：${(Pref.preferCodecs.map((i) => i.name).join(","))}，请根据设备支持情况与需求调整',
    onTap: _showCodecsDialog,
  ),
  NormalModel(
    title: '蜂窝网络首选解码格式',
    leading: const Icon(Icons.movie_creation_outlined),
    getSubtitle: () =>
        '首选解码格式：${(Pref.preferCodecsCellular.map((i) => i.name).join(","))}，请根据设备支持情况与需求调整',
    onTap: _showCellularCodecsDialog,
  ),
  if (kDebugMode || Platform.isAndroid)
    NormalModel(
      title: '音频输出设备',
      leading: const Icon(Icons.speaker_outlined),
      getSubtitle: () => '当前：${Pref.audioOutput}',
      onTap: _showAudioOutputDialog,
    ),
  NormalModel(
    title: '缓冲大小',
    leading: const Icon(Icons.storage_outlined),
    getSubtitle: () =>
        '当前：${Pref.bufferSize}MB。同时为前向和后向缓冲区大小。对于直播流，无后向缓冲大小，全部转给前向（此选项即mpv的--demuxer-max-bytes，--demuxer-max-back-bytes）',
    onTap: _showBufferSizeDialog,
  ),
  NormalModel(
    title: '缓冲时长',
    leading: const Icon(Icons.av_timer),
    getSubtitle: () =>
        '当前：${Pref.bufferSec}s。实际缓冲为二者最小值。对于直播流，该选项无效（此选项即mpv的--cache-secs）',
    onTap: _showBufferSecDialog,
  ),
  NormalModel(
    title: '自动同步',
    leading: const Icon(Icons.sync_rounded),
    getSubtitle: () => '当前：${Pref.autosync}（此项即mpv的--autosync）',
    onTap: _showAutoSyncDialog,
  ),
  NormalModel(
    title: '视频同步',
    leading: const Icon(Icons.view_timeline_outlined),
    getSubtitle: () => '当前：${Pref.videoSync}（此项即mpv的--video-sync）',
    onTap: _showVideoSyncDialog,
  ),
  NormalModel(
    title: '硬解模式',
    leading: const Icon(Icons.memory_outlined),
    getSubtitle: () => '当前：${Pref.hardwareDecoding}（此项即mpv的--hwdec）',
    onTap: _showHwDecDialog,
  ),
];

const _manualCdnDisabledSubtitle = '自动选源已接管视频与音频；此项已停用，关闭自动选择 CDN 后恢复原设置';

/// Avoid the generic switch's unchecked dynamic-to-bool conversion on restore.
class _LiveEnhancementSwitchModel extends SwitchModel {
  const _LiveEnhancementSwitchModel({
    required super.title,
    required super.setKey,
    super.subtitle,
    super.leading,
  });

  @override
  Widget get widget => StreamBuilder(
    stream: GStorage.setting.watch(key: SettingBoxKey.liveRoomEnhancement),
    builder: (context, _) {
      final theme = Theme.of(context);
      final enabled = Pref.liveRoomEnhancement;
      return setting_tile.ListTile(
        title: Text(title!, style: theme.textTheme.titleMedium),
        subtitle: Text(
          subtitle!,
          style: theme.textTheme.labelMedium!.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
        leading: leading,
        trailing: Transform.scale(
          scale: 0.8,
          alignment: Alignment.centerRight,
          child: Switch(
            value: enabled,
            onChanged: (value) => GStorage.setting.put(setKey, value),
          ),
        ),
        onTap: () => GStorage.setting.put(setKey, !enabled),
      );
    },
  );
}

/// Rebuild only the affected rows when the parallel switch changes, including
/// in settings search, where the rows do not share a page-level state.
class _ManualCdnModel extends NormalModel {
  const _ManualCdnModel({
    required super.title,
    super.leading,
    super.getSubtitle,
    super.onTap,
  });

  @override
  Widget get widget => StreamBuilder(
    stream: GStorage.setting.watch(key: SettingBoxKey.cdnAutoSelect),
    builder: (context, snapshot) => Pref.cdnAutoSelect
        ? NormalModel(
            title: title,
            leading: leading,
            subtitle: _manualCdnDisabledSubtitle,
            getTrailing: (_) => const Icon(Icons.lock_outline_rounded),
          ).widget
        : super.widget,
  );
}

class _ManualCdnSwitchModel extends SwitchModel {
  const _ManualCdnSwitchModel({
    required super.title,
    required super.setKey,
    super.defaultVal,
    super.subtitle,
    super.leading,
    super.onChanged,
  });

  @override
  Widget get widget => StreamBuilder(
    stream: GStorage.setting.watch(key: SettingBoxKey.cdnAutoSelect),
    builder: (context, snapshot) => Pref.cdnAutoSelect
        ? NormalModel(
            title: title,
            leading: leading,
            subtitle: _manualCdnDisabledSubtitle,
            getTrailing: (_) => Transform.scale(
              scale: 0.8,
              alignment: Alignment.centerRight,
              child: const Switch(value: false, onChanged: null),
            ),
          ).widget
        : super.widget,
  );
}

Future<void> _showParallelValueDialog(
  BuildContext context,
  VoidCallback setState, {
  required String title,
  required String key,
  required int current,
  required List<int> choices,
  required int min,
  required int max,
  required String suffix,
}) async {
  final values = {...choices, current}.toList()..sort();
  var result = await showDialog<int>(
    context: context,
    builder: (context) => SelectDialog<int>(
      title: title,
      value: current,
      values: [
        for (final value in values) (value, '$value $suffix'),
        (-1, '自定义（$min–$max $suffix）'),
      ],
    ),
  );
  if (result == -1 && context.mounted) {
    var input = current.toString();
    final formKey = GlobalKey<FormState>();
    result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('自定义$title'),
        content: Form(
          key: formKey,
          child: TextFormField(
            initialValue: input,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffixText: suffix,
              helperText: '请输入 $min–$max 之间的整数（包含边界）',
            ),
            onChanged: (value) => input = value,
            validator: (value) {
              final parsed = int.tryParse(value?.trim() ?? '');
              return parsed == null || parsed < min || parsed > max
                  ? '请输入 $min–$max 之间的整数'
                  : null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop(int.parse(input.trim()));
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
  if (result != null && result >= min && result <= max) {
    await GStorage.setting.put(key, result);
    setState();
  }
}

Future<void> _showCDNDialog(BuildContext context, VoidCallback setState) async {
  if (Pref.cdnAutoSelect) return;
  final res = await showDialog<CDNService>(
    context: context,
    builder: (context) => const CdnSelectDialog(),
  );
  if (res != null && !Pref.cdnAutoSelect) {
    VideoUtils.cdnService = res;
    await GStorage.setting.put(SettingBoxKey.CDNService, res.name);
    setState();
  }
}

Future<void> _showLiveCDNDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  String host = Pref.liveCdnUrl ?? '';
  String? res = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('输入CDN host'),
      content: TextFormField(
        initialValue: host,
        autofocus: true,
        onChanged: (value) => host = value,
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
          onPressed: () => Get.back(result: host),
          child: const Text('确定'),
        ),
      ],
    ),
  );
  if (res != null) {
    if (res.isEmpty) {
      res = null;
      await GStorage.setting.delete(SettingBoxKey.liveCdnUrl);
    } else {
      if (!res.startsWith('http')) {
        res = 'https://$res';
      }
      await GStorage.setting.put(SettingBoxKey.liveCdnUrl, res);
    }
    VideoUtils.liveCdnUrl = res;
    setState();
  }
}

Future<void> _showVideoQaDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<int>(
    context: context,
    builder: (context) => SelectDialog<int>(
      title: '默认画质',
      value: Pref.defaultVideoQa,
      values: VideoQuality.values.map((e) => (e.code, e.desc)).toList(),
    ),
  );
  if (res != null) {
    await GStorage.setting.put(SettingBoxKey.defaultVideoQa, res);
    setState();
  }
}

Future<void> _showVideoCellularQaDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<int>(
    context: context,
    builder: (context) => SelectDialog<int>(
      title: '蜂窝网络画质',
      value: Pref.defaultVideoQaCellular,
      values: VideoQuality.values.map((e) => (e.code, e.desc)).toList(),
    ),
  );
  if (res != null) {
    await GStorage.setting.put(
      SettingBoxKey.defaultVideoQaCellular,
      res,
    );
    setState();
  }
}

Future<void> _showAudioQaDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<int>(
    context: context,
    builder: (context) => SelectDialog<int>(
      title: '默认音质',
      value: Pref.defaultAudioQa,
      values: AudioQuality.values.map((e) => (e.code, e.desc)).toList(),
    ),
  );
  if (res != null) {
    await GStorage.setting.put(SettingBoxKey.defaultAudioQa, res);
    setState();
  }
}

Future<void> _showAudioCellularQaDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<int>(
    context: context,
    builder: (context) => SelectDialog<int>(
      title: '蜂窝网络音质',
      value: Pref.defaultAudioQaCellular,
      values: AudioQuality.values.map((e) => (e.code, e.desc)).toList(),
    ),
  );
  if (res != null) {
    await GStorage.setting.put(
      SettingBoxKey.defaultAudioQaCellular,
      res,
    );
    setState();
  }
}

Future<void> _showLiveQaDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<int>(
    context: context,
    builder: (context) => SelectDialog<int>(
      title: '直播默认画质',
      value: Pref.liveQuality,
      values: LiveQuality.values.map((e) => (e.code, e.desc)).toList(),
    ),
  );
  if (res != null) {
    await GStorage.setting.put(SettingBoxKey.liveQuality, res);
    setState();
  }
}

Future<void> _showLiveCellularQaDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<int>(
    context: context,
    builder: (context) => SelectDialog<int>(
      title: '蜂窝网络直播默认画质',
      value: Pref.liveQualityCellular,
      values: LiveQuality.values.map((e) => (e.code, e.desc)).toList(),
    ),
  );
  if (res != null) {
    await GStorage.setting.put(SettingBoxKey.liveQualityCellular, res);
    setState();
  }
}

Future<void> _showCodecsDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<List<VideoDecodeFormatType>>(
    context: context,
    builder: (context) => OrderedMultiSelectDialog<VideoDecodeFormatType>(
      title: '首选解码格式',
      initValues: Pref.preferCodecs,
      values: {for (final e in VideoDecodeFormatType.values) e: e.name},
    ),
  );
  if (res != null && res.isNotEmpty) {
    await GStorage.setting.put(
      SettingBoxKey.preferCodecs,
      res.map((i) => i.name).toList(),
    );
    setState();
  }
}

Future<void> _showCellularCodecsDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<List<VideoDecodeFormatType>>(
    context: context,
    builder: (context) => OrderedMultiSelectDialog<VideoDecodeFormatType>(
      title: '蜂窝网络首选解码格式',
      initValues: Pref.preferCodecsCellular,
      values: {for (final e in VideoDecodeFormatType.values) e: e.name},
    ),
  );
  if (res != null && res.isNotEmpty) {
    await GStorage.setting.put(
      SettingBoxKey.preferCodecsCellular,
      res.map((i) => i.name).toList(),
    );
    setState();
  }
}

Future<void> _showAudioOutputDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<List<String>>(
    context: context,
    builder: (context) => OrderedMultiSelectDialog<String>(
      title: '音频输出设备',
      initValues: Pref.audioOutput.split(','),
      values: {
        for (final e in AudioOutput.values) e.name: e.label,
      },
    ),
  );
  if (res != null && res.isNotEmpty) {
    await GStorage.setting.put(
      SettingBoxKey.audioOutput,
      res.join(','),
    );
    setState();
  }
}

Future<void> _showVideoSyncDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<String>(
    context: context,
    builder: (context) => SelectDialog<String>(
      title: '视频同步',
      value: Pref.videoSync,
      values: const [
        'audio',
        'display-resample',
        'display-resample-vdrop',
        'display-resample-desync',
        'display-tempo',
        'display-vdrop',
        'display-adrop',
        'display-desync',
        'desync',
      ].map((e) => (e, e)).toList(),
    ),
  );
  if (res != null) {
    await GStorage.setting.put(SettingBoxKey.videoSync, res);
    setState();
  }
}

Future<void> _showHwDecDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<List<String>>(
    context: context,
    builder: (context) => OrderedMultiSelectDialog<String>(
      title: '硬解模式',
      initValues: Pref.hardwareDecoding.split(','),
      values: {
        for (final e in HwDecType.values) e.hwdec: '${e.hwdec}\n${e.desc}',
      },
    ),
  );
  if (res != null && res.isNotEmpty) {
    await GStorage.setting.put(
      SettingBoxKey.hardwareDecoding,
      res.join(','),
    );
    setState();
  }
}

void _showAutoSyncDialog(BuildContext context, VoidCallback setState) {
  String autosync = Pref.autosync.toString();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('自动同步'),
      content: TextFormField(
        autofocus: true,
        initialValue: autosync,
        keyboardType: TextInputType.number,
        onChanged: (value) => autosync = value,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
          onPressed: () async {
            try {
              // validate
              int.parse(autosync);
              Get.back();
              await GStorage.setting.put(SettingBoxKey.autosync, autosync);
              setState();
            } catch (e) {
              SmartDialog.showToast(e.toString());
            }
          },
          child: const Text('确定'),
        ),
      ],
    ),
  );
}

void _showDecimalDialog(
  BuildContext context,
  VoidCallback setState, {
  required String key,
  required double defVal,
  required String title,
  required String? suffix,
}) {
  String value = (GStorage.setting.get(key) ?? defVal).toString();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextFormField(
        autofocus: true,
        initialValue: value,
        keyboardType: const .numberWithOptions(decimal: true),
        onChanged: (val) => value = val,
        inputFormatters: FilteringText.decimal,
        decoration: suffix == null ? null : InputDecoration(suffixText: suffix),
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
          onPressed: () async {
            try {
              final val = double.parse(value);
              Get.back();
              await GStorage.setting.put(key, val);
              setState();
            } catch (e) {
              SmartDialog.showToast(e.toString());
            }
          },
          child: const Text('确定'),
        ),
      ],
    ),
  );
}

void _showBufferSizeDialog(BuildContext context, VoidCallback setState) =>
    _showDecimalDialog(
      context,
      setState,
      key: SettingBoxKey.bufferSize,
      defVal: Pref.bufferSize,
      title: '缓冲大小',
      suffix: 'MB',
    );

void _showBufferSecDialog(BuildContext context, VoidCallback setState) =>
    _showDecimalDialog(
      context,
      setState,
      key: SettingBoxKey.bufferSec,
      defVal: Pref.bufferSec,
      title: '缓冲时长',
      suffix: 's',
    );
