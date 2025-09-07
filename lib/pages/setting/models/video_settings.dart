import 'dart:io';

import 'package:PiliPlus/models/common/settings_type.dart';
import 'package:PiliPlus/models/common/video/audio_quality.dart';
import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/common/video/live_quality.dart';
import 'package:PiliPlus/models/common/video/video_decode_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

List<SettingsModel> get videoSettings => [
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '开启硬解',
    subtitle: '以较低功耗播放视频，若异常卡死请关闭',
    leading: Icon(Icons.flash_on_outlined),
    setKey: SettingBoxKey.enableHA,
    defaultVal: true,
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '免登录1080P',
    subtitle: '免登录查看1080P视频',
    leading: Icon(Icons.hd_outlined),
    setKey: SettingBoxKey.p1080,
    defaultVal: true,
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: 'B站定向流量支持',
    subtitle: '若套餐含B站定向流量，则会自动使用。可查阅运营商的流量记录确认。',
    leading: const Icon(Icons.perm_data_setting_outlined),
    getTrailing: () => Transform.scale(
      alignment: Alignment.centerRight,
      scale: 0.8,
      child: Switch(
        thumbIcon: WidgetStateProperty.resolveWith<Icon?>((
          Set<WidgetState> states,
        ) {
          if (states.isNotEmpty && states.first == WidgetState.selected) {
            return const Icon(Icons.lock_outline_rounded);
          }
          return null;
        }),
        value: true,
        onChanged: (_) {},
      ),
    ),
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: 'CDN 设置',
    leading: const Icon(MdiIcons.cloudPlusOutline),
    getSubtitle: () =>
        '当前使用：${CDNService.fromCode(VideoUtils.cdnService).desc}，部分 CDN 可能失效，如无法播放请尝试切换',
    onTap: (setState) async {
      String? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return const CdnSelectDialog();
        },
      );
      if (result != null) {
        VideoUtils.cdnService = result;
        await GStorage.setting.put(SettingBoxKey.CDNService, result);
        setState();
      }
    },
  ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: 'CDN 测速',
    leading: Icon(Icons.speed),
    subtitle: '测速通过模拟加载视频实现，注意流量消耗，结果仅供参考',
    setKey: SettingBoxKey.cdnSpeedTest,
    defaultVal: true,
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '音频不跟随 CDN 设置',
    subtitle: '直接采用备用 URL，可解决部分视频无声',
    leading: const Icon(MdiIcons.musicNotePlus),
    setKey: SettingBoxKey.disableAudioCDN,
    defaultVal: true,
    onChanged: (value) {
      VideoUtils.disableAudioCDN = value;
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '默认画质',
    leading: const Icon(Icons.video_settings_outlined),
    getSubtitle: () =>
        '当前画质：${VideoQuality.fromCode(Pref.defaultVideoQa).desc}',
    onTap: (setState) async {
      int? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<int>(
            title: '默认画质',
            value: Pref.defaultVideoQa,
            values: VideoQuality.values.map((e) => (e.code, e.desc)).toList(),
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(SettingBoxKey.defaultVideoQa, result);
        setState();
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '蜂窝网络画质',
    leading: const Icon(Icons.video_settings_outlined),
    getSubtitle: () =>
        '当前画质：${VideoQuality.fromCode(Pref.defaultVideoQaCellular).desc}',
    onTap: (setState) async {
      int? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<int>(
            title: '蜂窝网络画质',
            value: Pref.defaultVideoQaCellular,
            values: VideoQuality.values.map((e) => (e.code, e.desc)).toList(),
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(
          SettingBoxKey.defaultVideoQaCellular,
          result,
        );
        setState();
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '默认音质',
    leading: const Icon(Icons.music_video_outlined),
    getSubtitle: () =>
        '当前音质：${AudioQuality.fromCode(Pref.defaultAudioQa).desc}',
    onTap: (setState) async {
      int? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<int>(
            title: '默认音质',
            value: Pref.defaultAudioQa,
            values: AudioQuality.values.map((e) => (e.code, e.desc)).toList(),
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(SettingBoxKey.defaultAudioQa, result);
        setState();
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '蜂窝网络音质',
    leading: const Icon(Icons.music_video_outlined),
    getSubtitle: () =>
        '当前音质：${AudioQuality.fromCode(Pref.defaultAudioQaCellular).desc}',
    onTap: (setState) async {
      int? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<int>(
            title: '蜂窝网络音质',
            value: Pref.defaultAudioQaCellular,
            values: AudioQuality.values.map((e) => (e.code, e.desc)).toList(),
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(
          SettingBoxKey.defaultAudioQaCellular,
          result,
        );
        setState();
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '直播默认画质',
    leading: const Icon(Icons.video_settings_outlined),
    getSubtitle: () => '当前画质：${LiveQuality.fromCode(Pref.liveQuality)?.desc}',
    onTap: (setState) async {
      int? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<int>(
            title: '直播默认画质',
            value: Pref.liveQuality,
            values: LiveQuality.values.map((e) => (e.code, e.desc)).toList(),
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(SettingBoxKey.liveQuality, result);
        setState();
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '蜂窝网络直播默认画质',
    leading: const Icon(Icons.video_settings_outlined),
    getSubtitle: () =>
        '当前画质：${LiveQuality.fromCode(Pref.liveQualityCellular)?.desc}',
    onTap: (setState) async {
      int? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<int>(
            title: '蜂窝网络直播默认画质',
            value: Pref.liveQualityCellular,
            values: LiveQuality.values.map((e) => (e.code, e.desc)).toList(),
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(SettingBoxKey.liveQualityCellular, result);
        setState();
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '首选解码格式',
    leading: const Icon(Icons.movie_creation_outlined),
    getSubtitle: () =>
        '首选解码格式：${VideoDecodeFormatType.fromCode(Pref.defaultDecode).description}，请根据设备支持情况与需求调整',
    onTap: (setState) async {
      String? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<String>(
            title: '默认解码格式',
            value: Pref.defaultDecode,
            values: VideoDecodeFormatType.values
                .map((e) => (e.codes.first, e.description))
                .toList(),
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(SettingBoxKey.defaultDecode, result);
        setState();
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '次选解码格式',
    getSubtitle: () =>
        '非杜比视频次选：${VideoDecodeFormatType.fromCode(Pref.secondDecode).description}，仍无则选择首个提供的解码格式',
    leading: const Icon(Icons.swap_horizontal_circle_outlined),
    onTap: (setState) async {
      String? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<String>(
            title: '次选解码格式',
            value: Pref.secondDecode,
            values: VideoDecodeFormatType.values
                .map((e) => (e.codes.first, e.description))
                .toList(),
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(SettingBoxKey.secondDecode, result);
        setState();
      }
    },
  ),
  if (Platform.isAndroid)
    const SettingsModel(
      settingsType: SettingsType.sw1tch,
      title: '优先使用 OpenSL ES 输出音频',
      leading: Icon(Icons.speaker_outlined),
      subtitle: '关闭则优先使用AudioTrack输出音频（此项即mpv的--ao），若遇系统音效丢失、无声、音画不同步等问题请尝试关闭。',
      setKey: SettingBoxKey.useOpenSLES,
      defaultVal: true,
    ),
  const SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '扩大缓冲区',
    leading: Icon(Icons.storage_outlined),
    subtitle: '默认缓冲区为视频4MB/直播16MB，开启后为32MB/64MB，加载时间变长',
    setKey: SettingBoxKey.expandBuffer,
    defaultVal: false,
  ),
  //video-sync
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '视频同步',
    leading: const Icon(Icons.view_timeline_outlined),
    getSubtitle: () => '当前：${Pref.videoSync}（此项即mpv的--video-sync）',
    onTap: (setState) async {
      String? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<String>(
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
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(SettingBoxKey.videoSync, result);
        setState();
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '硬解模式',
    leading: const Icon(Icons.memory_outlined),
    getSubtitle: () => '当前：${Pref.hardwareDecoding}（此项即mpv的--hwdec）',
    onTap: (setState) async {
      String? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<String>(
            title: '硬解模式',
            value: Pref.hardwareDecoding,
            values: const [
              'auto',
              'auto-copy',
              'auto-safe',
              'no',
              'yes',
            ].map((e) => (e, e)).toList(),
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(SettingBoxKey.hardwareDecoding, result);
        setState();
      }
    },
  ),
];
