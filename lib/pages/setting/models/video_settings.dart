import 'dart:io';

import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/video/audio_quality.dart';
import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/common/video/live_quality.dart';
import 'package:PiliPlus/models/common/video/video_decode_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
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
  SwitchModel(
    title: L10n.current.enableHAVideoSettingsTitle,
    subtitle: L10n.current.enableHAVideoSettingsSubtitle,
    leading: const Icon(Icons.flash_on_outlined),
    setKey: SettingBoxKey.enableHA,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.p1080VideoSettingsTitle,
    subtitle: L10n.current.p1080VideoSettingsSubtitle,
    leading: const Icon(Icons.hd_outlined),
    setKey: SettingBoxKey.p1080,
    defaultVal: true,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle14,
    subtitle: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsSubtitle,
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
  NormalModel(
    title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle8,
    leading: const Icon(MdiIcons.cloudPlusOutline),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsVideoSettingsVideoSettingsGetSubtitle8(
          VideoUtils.cdnService.desc,
        ),
    onTap: _showCDNDialog,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle15,
    leading: const Icon(MdiIcons.cloudPlusOutline),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsVideoSettingsVideoSettingsGetSubtitle2(
          Pref.liveCdnUrl ?? L10n.current.defaultOption,
        ),
    onTap: _showLiveCDNDialog,
  ),
  SwitchModel(
    title: L10n.current.cdnSpeedTestVideoSettingsTitle,
    leading: const Icon(Icons.speed),
    subtitle: L10n.current.cdnSpeedTestVideoSettingsSubtitle,
    setKey: SettingBoxKey.cdnSpeedTest,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.disableAudioCDNVideoSettingsTitle,
    subtitle: L10n.current.disableAudioCDNVideoSettingsSubtitle,
    leading: const Icon(MdiIcons.musicNotePlus),
    setKey: SettingBoxKey.disableAudioCDN,
    defaultVal: false,
    onChanged: (value) => VideoUtils.disableAudioCDN = value,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle,
    leading: const Icon(Icons.video_settings_outlined),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsVideoSettingsVideoSettingsGetSubtitle6(
          VideoQuality.fromCode(Pref.defaultVideoQa).desc,
        ),
    onTap: _showVideoQaDialog,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle9,
    leading: const Icon(Icons.video_settings_outlined),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsVideoSettingsVideoSettingsGetSubtitle6(
          VideoQuality.fromCode(Pref.defaultVideoQaCellular).desc,
        ),
    onTap: _showVideoCellularQaDialog,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle2,
    leading: const Icon(Icons.music_video_outlined),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsVideoSettingsVideoSettingsGetSubtitle7(
          AudioQuality.fromCode(Pref.defaultAudioQa).desc,
        ),
    onTap: _showAudioQaDialog,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle10,
    leading: const Icon(Icons.music_video_outlined),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsVideoSettingsVideoSettingsGetSubtitle7(
          AudioQuality.fromCode(Pref.defaultAudioQaCellular).desc,
        ),
    onTap: _showAudioCellularQaDialog,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle11,
    leading: const Icon(Icons.video_settings_outlined),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsVideoSettingsVideoSettingsGetSubtitle6(
          (LiveQuality.fromCode(Pref.liveQuality)?.desc).toString(),
        ),
    onTap: _showLiveQaDialog,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle16,
    leading: const Icon(Icons.video_settings_outlined),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsVideoSettingsVideoSettingsGetSubtitle6(
          (LiveQuality.fromCode(Pref.liveQualityCellular)?.desc).toString(),
        ),
    onTap: _showLiveCellularQaDialog,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle12,
    leading: const Icon(Icons.movie_creation_outlined),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsVideoSettingsVideoSettingsGetSubtitle10(
          (Pref.preferCodecs.map((i) => i.name).join(",")),
        ),
    onTap: _showCodecsDialog,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle17,
    leading: const Icon(Icons.movie_creation_outlined),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsVideoSettingsVideoSettingsGetSubtitle10(
          (Pref.preferCodecsCellular.map((i) => i.name).join(",")),
        ),
    onTap: _showCellularCodecsDialog,
  ),
  if (kDebugMode || Platform.isAndroid)
    NormalModel(
      title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle13,
      leading: const Icon(Icons.speaker_outlined),
      getSubtitle: () =>
          L10n.current.pagesSettingModelsVideoSettingsVideoSettingsGetSubtitle(
            Pref.audioOutput,
          ),
      onTap: _showAudioOutputDialog,
    ),
  NormalModel(
    title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle3,
    leading: const Icon(Icons.storage_outlined),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsVideoSettingsVideoSettingsGetSubtitle11(
          Pref.bufferSize,
        ),
    onTap: _showBufferSizeDialog,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle4,
    leading: const Icon(Icons.av_timer),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsVideoSettingsVideoSettingsGetSubtitle9(
          Pref.bufferSec,
        ),
    onTap: _showBufferSecDialog,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle5,
    leading: const Icon(Icons.sync_rounded),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsVideoSettingsVideoSettingsGetSubtitle3(
          Pref.autosync,
        ),
    onTap: _showAutoSyncDialog,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle6,
    leading: const Icon(Icons.view_timeline_outlined),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsVideoSettingsVideoSettingsGetSubtitle4(
          Pref.videoSync,
        ),
    onTap: _showVideoSyncDialog,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle7,
    leading: const Icon(Icons.memory_outlined),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsVideoSettingsVideoSettingsGetSubtitle5(
          Pref.hardwareDecoding,
        ),
    onTap: _showHwDecDialog,
  ),
];

Future<void> _showCDNDialog(BuildContext context, VoidCallback setState) async {
  final res = await showDialog<CDNService>(
    context: context,
    builder: (context) => const CdnSelectDialog(),
  );
  if (res != null) {
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
      title: Text(L10n.current.resShowLiveCDNDialogTitle),
      content: TextFormField(
        initialValue: host,
        autofocus: true,
        onChanged: (value) => host = value,
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(
            L10n.current.cancel,
            style: TextStyle(color: ColorScheme.of(context).outline),
          ),
        ),
        TextButton(
          onPressed: () => Get.back(result: host),
          child: Text(L10n.current.ok),
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
      title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle,
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
      title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle9,
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
      title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle2,
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
      title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle10,
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
      title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle11,
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
      title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle16,
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
      title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle12,
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
      title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle17,
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
      title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle13,
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
      title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle6,
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
      title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle7,
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
      title: Text(
        L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle5,
      ),
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
            L10n.current.cancel,
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
          child: Text(L10n.current.ok),
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
            L10n.current.cancel,
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
          child: Text(L10n.current.ok),
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
      title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle3,
      suffix: 'MB',
    );

void _showBufferSecDialog(BuildContext context, VoidCallback setState) =>
    _showDecimalDialog(
      context,
      setState,
      key: SettingBoxKey.bufferSec,
      defVal: Pref.bufferSec,
      title: L10n.current.pagesSettingModelsVideoSettingsVideoSettingsTitle4,
      suffix: 's',
    );
