import 'dart:io' show Platform;

import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/models/common/super_chat_time_type.dart';
import 'package:PiliPlus/models/common/super_chat_type.dart';
import 'package:PiliPlus/models/common/video/subtitle_pref_type.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/pages/fullscreen_sc_size.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/slider_dialog.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/bottom_progress_behavior.dart';
import 'package:PiliPlus/plugin/pl_player/models/double_tap_seek_layout.dart';
import 'package:PiliPlus/plugin/pl_player/models/fullscreen_mode.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_ui/material_ui.dart';

List<SettingsModel> get playSettings => [
  const SwitchModel(
    title: '弹幕开关',
    subtitle: '是否展示弹幕',
    leading: Icon(CustomIcons.dm_settings),
    setKey: SettingBoxKey.enableShowDanmaku,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '智能防挡',
    subtitle: '让弹幕避开画面中的人物（部分视频支持）',
    leading: Icon(Icons.person_off_outlined),
    setKey: SettingBoxKey.enableDanmakuMask,
    defaultVal: false,
  ),
  if (PlatformUtils.isMobile)
    const SwitchModel(
      title: '启用点击弹幕',
      subtitle: '点击弹幕悬停，支持点赞、复制、举报操作',
      leading: Icon(Icons.touch_app_outlined),
      setKey: SettingBoxKey.enableTapDm,
      defaultVal: true,
    ),
  NormalModel(
    onTap: (context, setState) => Get.toNamed('/playSpeedSet'),
    leading: const Icon(Icons.speed_outlined),
    title: '倍速设置',
    subtitle: '设置视频播放速度',
  ),
  if (Platform.isAndroid)
    NormalModel(
      onTap: _showAngleDegreesDialog,
      leading: const Icon(MdiIcons.angleAcute),
      title: '倾斜角度阈值',
      getSubtitle: () => '当前:「${Pref.angleDegrees}°」',
    ),
  const SwitchModel(
    title: '自动播放',
    subtitle: '进入详情页自动播放',
    leading: Icon(Icons.motion_photos_auto_outlined),
    setKey: SettingBoxKey.autoPlayEnable,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '全屏显示锁定按钮',
    leading: Icon(Icons.lock_outline),
    setKey: SettingBoxKey.showFsLockBtn,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '锁定按钮显示在右侧',
    subtitle: '开启后锁定按钮移至右侧，与截图按钮一同垂直居中排列',
    leading: Icon(Icons.keyboard_double_arrow_right),
    setKey: SettingBoxKey.showFsLockBtnRight,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '全屏显示截图按钮',
    leading: Icon(Icons.photo_camera_outlined),
    setKey: SettingBoxKey.showFsScreenshotBtn,
    defaultVal: true,
  ),
  SwitchModel(
    title: '全屏显示电池电量',
    leading: const Icon(Icons.battery_3_bar),
    setKey: SettingBoxKey.showBatteryLevel,
    defaultVal: PlatformUtils.isMobile,
  ),
  const SwitchModel(
    title: '双击快退/快进',
    subtitle: '左侧双击快退/右侧双击快进，关闭则双击均为暂停/播放',
    leading: Icon(Icons.touch_app_outlined),
    setKey: SettingBoxKey.enableQuickDouble,
    defaultVal: true,
  ),
  NormalModel(
    title: '双击区域调整',
    leading: const Icon(Icons.crop_16_9_outlined),
    getSubtitle: () {
      final layout = DoubleTapSeekLayout.normalize(
        backwardPercent: Pref.doubleTapBackwardZone,
        forwardPercent: Pref.doubleTapForwardZone,
      );
      return '左 ${layout.backwardPercent}% / 中 ${layout.centerPercent}% / 右 ${layout.forwardPercent}%';
    },
    onTap: (_, setState) =>
        Get.toNamed('/doubleTapSeekZoneSetting')?.then((_) => setState()),
  ),
  getVideoFilterSelectModel(
    title: '左侧双击快退时长',
    suffix: 's',
    key: SettingBoxKey.doubleTapBackwardDuration,
    values: [5, 10, 15, 20, 30],
    defaultValue: Pref.fastForBackwardDuration,
    isFilter: false,
  ),
  getVideoFilterSelectModel(
    title: '右侧双击快进时长',
    suffix: 's',
    key: SettingBoxKey.doubleTapForwardDuration,
    values: [5, 10, 15, 20, 30],
    defaultValue: Pref.fastForBackwardDuration,
    isFilter: false,
  ),
  const SwitchModel(
    title: '双指轻点暂停/播放',
    subtitle: '启用后，两指短按屏幕可切换播放状态',
    leading: Icon(Icons.touch_app),
    setKey: SettingBoxKey.enableTwoFingerTapPause,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '左右侧滑动调节亮度/音量',
    leading: Icon(MdiIcons.tuneVerticalVariant),
    setKey: SettingBoxKey.enableSlideVolumeBrightness,
    defaultVal: true,
  ),
  if (Platform.isAndroid)
    const SwitchModel(
      title: '调节系统亮度',
      leading: Icon(Icons.brightness_6_outlined),
      setKey: SettingBoxKey.setSystemBrightness,
      defaultVal: false,
    ),
  if (PlatformUtils.isMobile)
    SwitchModel(
      title: '应用内音量',
      subtitle: '开启后在应用内调节音量不会改变系统音量',
      leading: const Icon(Icons.volume_up_outlined),
      setKey: SettingBoxKey.enableAppVolume,
      defaultVal: false,
      onChanged: (value) async {
        await PlPlayerController.instance?.onAppVolumeSettingChanged();
      },
    ),
  if (PlatformUtils.isMobile && Pref.enableAppVolume)
    const SwitchModel(
      title: '音量增强',
      subtitle: '在应用内音量模式下允许放大至 200%',
      leading: Icon(Icons.volume_up_outlined),
      setKey: SettingBoxKey.enableVolumeBoost,
      defaultVal: false,
    ),
  if (PlatformUtils.isMobile)
    NormalModel(
      title: '播放器音量',
      leading: const Icon(Icons.volume_up),
      getSubtitle: () =>
          '当前:「${Pref.playerVolume.toStringAsFixed(0)}%」\n'
          '在系统音量基础上增益；开启应用内音量后不生效',
      onTap: showPlayerVolumeDialog,
    )
  else
    NormalModel(
      title: '最高音量',
      leading: const Icon(Icons.volume_up),
      getSubtitle: () => '当前:「${(Pref.maxVolume * 100).toStringAsFixed(0)}%」',
      onTap: _showMaxVolumeDialog,
    ),
  const SwitchModel(
    title: '中间滑动进入/退出全屏',
    leading: Icon(MdiIcons.panVertical),
    setKey: SettingBoxKey.enableSlideFS,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '滑动快进/快退使用相对时长',
    leading: Icon(Icons.swap_horiz_outlined),
    setKey: SettingBoxKey.useRelativeSlide,
    defaultVal: false,
  ),
  getVideoFilterSelectModel(
    title: '滑动快进/快退时长',
    subtitle: '从播放器一端滑到另一端的快进/快退时长',
    suffix: Pref.useRelativeSlide ? '%' : 's',
    key: SettingBoxKey.sliderDuration,
    values: [25, 50, 90, 100],
    defaultValue: 90,
    isFilter: false,
  ),
  NormalModel(
    title: '自动启用字幕',
    leading: const Icon(Icons.closed_caption_outlined),
    getSubtitle: () => '当前选择偏好：${Pref.subtitlePreferenceV2.desc}',
    onTap: _showSubtitleDialog,
  ),
  if (PlatformUtils.isDesktop)
    SwitchModel(
      title: '最小化时暂停/还原时播放',
      leading: const Icon(Icons.pause_circle_outline),
      setKey: SettingBoxKey.pauseOnMinimize,
      defaultVal: false,
      onChanged: (value) {
        try {
          Get.find<MainController>().pauseOnMinimize = value;
        } catch (_) {}
      },
    ),
  const SwitchModel(
    title: '启用键盘控制',
    leading: Icon(Icons.keyboard_alt_outlined),
    setKey: SettingBoxKey.keyboardControl,
    defaultVal: true,
  ),
  PopupModel(
    title: 'SuperChat (醒目留言) 显示类型',
    leading: const Icon(Icons.live_tv),
    value: () => Pref.superChatType,
    items: SuperChatType.values,
    onSelected: (value, setState) => GStorage.setting
        .put(SettingBoxKey.superChatType, value.index)
        .whenComplete(setState),
  ),
  NormalModel(
    title: 'SuperChat 发送时间显示',
    leading: const Icon(Icons.access_time_outlined),
    getSubtitle: () => '当前:「${Pref.superChatTimeType.title}」',
    onTap: _showSuperChatTimeDialog,
  ),
  NormalModel(
    title: '全屏 SC 大小',
    subtitle: 'SuperChat (醒目留言) 大小设置',
    leading: const Icon(Icons.open_in_full),
    onTap: (_, _) => Get.to(const FullScreenScSize()),
  ),
  const SwitchModel(
    title: '竖屏扩大展示',
    subtitle: '小屏竖屏视频宽高比由16:9扩大至1:1（不支持收起）；横屏适配时，扩大至9:16',
    leading: Icon(Icons.expand_outlined),
    setKey: SettingBoxKey.enableVerticalExpand,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '自动全屏',
    subtitle: '视频开始播放时进入全屏',
    leading: Icon(Icons.fullscreen_outlined),
    setKey: SettingBoxKey.enableAutoEnter,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '自动退出全屏',
    subtitle: '视频结束播放时退出全屏',
    leading: Icon(Icons.fullscreen_exit_outlined),
    setKey: SettingBoxKey.enableAutoExit,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '延长播放控件显示时间',
    subtitle: '开启后延长至30秒，便于屏幕阅读器滑动切换控件焦点',
    leading: Icon(Icons.timer_outlined),
    setKey: SettingBoxKey.enableLongShowControl,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '手动切集后显示播放控件',
    subtitle: '点击上一集、下一集或分集列表切换后保持控件显示',
    leading: Icon(Icons.touch_app_outlined),
    setKey: SettingBoxKey.showControlsOnManualEpisodeChange,
    defaultVal: false,
  ),
  if (PlatformUtils.isMobile)
    SwitchModel(
      title: '后台播放',
      subtitle: '进入后台时继续播放',
      leading: const Icon(Icons.motion_photos_pause_outlined),
      setKey: SettingBoxKey.continuePlayInBackground,
      defaultVal: false,
      onChanged: (value) {
        if (!value) {
          PlPlayerController.instance?.onAutoAudioOnlySettingChanged();
        }
      },
    ),
  if (PlatformUtils.isMobile)
    SwitchModel(
      title: '后台只听音频（实验性）',
      subtitle: '需开启「后台播放」后才生效\n进入后台或息屏一段时间后停止视频流，只保留声音；回到前台恢复画面',
      leading: const Icon(Icons.headphones_outlined),
      setKey: SettingBoxKey.autoAudioOnlyInBackground,
      defaultVal: false,
      onChanged: (value) {
        PlPlayerController.instance?.onAutoAudioOnlySettingChanged();
      },
    ),
  const SwitchModel(
    title: '应用内画中画',
    subtitle: '支持在应用内以小窗形式播放视频',
    leading: Icon(Icons.picture_in_picture_alt_outlined),
    setKey: SettingBoxKey.enableInAppPip,
    defaultVal: true,
  ),
  if (Platform.isAndroid) ...[
    SwitchModel(
      title: '后台画中画',
      subtitle: '进入后台时以小窗形式（PiP）播放',
      leading: const Icon(Icons.picture_in_picture_outlined),
      setKey: SettingBoxKey.autoPiP,
      defaultVal: false,
      onChanged: (val) {
        if (val && !videoPlayerServiceHandler!.enableBackgroundPlay) {
          SmartDialog.showToast('建议开启后台音频服务');
        }
      },
    ),
    const SwitchModel(
      title: '应用内小窗转后台画中画（实验性）',
      subtitle: '实验性功能：应用内小窗存在时，退到后台自动切换为系统 PiP；可能因系统差异出现异常',
      leading: Icon(Icons.science_outlined),
      setKey: SettingBoxKey.enableInAppPipToSystemPip,
      defaultVal: true,
    ),
    const SwitchModel(
      title: '画中画不加载弹幕',
      subtitle: '当弹幕开关开启时，小窗屏蔽弹幕以获得较好的体验',
      leading: Icon(CustomIcons.dm_off),
      setKey: SettingBoxKey.pipNoDanmaku,
      defaultVal: false,
    ),
  ],
  const SwitchModel(
    title: '全屏手势反向',
    subtitle: '默认播放器中部向上滑动进入全屏，向下退出\n开启后向下全屏，向上退出',
    leading: Icon(Icons.swap_vert),
    setKey: SettingBoxKey.fullScreenGestureReverse,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '全屏展示点赞/投币/收藏等操作按钮',
    leading: Icon(MdiIcons.dotsHorizontalCircleOutline),
    setKey: SettingBoxKey.showFSActionItem,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '观看人数',
    subtitle: '展示同时在看人数',
    leading: Icon(Icons.people_outlined),
    setKey: SettingBoxKey.enableOnlineTotal,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '弹幕数',
    subtitle: '展示当前播放视频的具体弹幕数',
    leading: Icon(CustomIcons.dm_on),
    setKey: SettingBoxKey.enableDmCount,
    defaultVal: false,
  ),
  NormalModel(
    title: '默认全屏方向',
    leading: const Icon(Icons.open_with_outlined),
    getSubtitle: () => '当前全屏方向：${Pref.fullScreenMode.desc}',
    onTap: _showFullScreenModeDialog,
  ),
  PopupModel(
    title: '底部进度条展示',
    leading: const Icon(Icons.border_bottom_outlined),
    value: () => Pref.btmProgressBehavior,
    items: BtmProgressBehavior.values,
    onSelected: (value, setState) => GStorage.setting
        .put(SettingBoxKey.btmProgressBehavior, value.index)
        .whenComplete(setState),
  ),
  if (PlatformUtils.isMobile)
    SwitchModel(
      title: '后台音频服务',
      subtitle: '避免画中画没有播放暂停功能',
      leading: const Icon(Icons.volume_up_outlined),
      setKey: SettingBoxKey.enableBackgroundPlay,
      defaultVal: true,
      onChanged: (value) =>
          videoPlayerServiceHandler!.enableBackgroundPlay = value,
    ),
  PopupModel(
    title: '播放顺序',
    leading: const Icon(Icons.repeat),
    value: () => Pref.playRepeat,
    items: PlayRepeat.values,
    onSelected: (value, setState) => GStorage.video
        .put(VideoBoxKey.playRepeat, value.index)
        .whenComplete(setState),
  ),
  const SwitchModel(
    title: '播放器设置仅对当前生效',
    subtitle: '弹幕、字幕及部分设置中没有的设置除外',
    leading: Icon(Icons.video_settings_outlined),
    setKey: SettingBoxKey.tempPlayerConf,
    defaultVal: false,
  ),
];

Future<void> _showSubtitleDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<SubtitlePrefType>(
    context: context,
    builder: (context) => SelectDialog<SubtitlePrefType>(
      title: '字幕选择偏好',
      value: Pref.subtitlePreferenceV2,
      values: SubtitlePrefType.values.map((e) => (e, e.desc)).toList(),
    ),
  );
  if (res != null) {
    await GStorage.setting.put(SettingBoxKey.subtitlePreferenceV2, res.index);
    setState();
  }
}

Future<void> _showSuperChatTimeDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<SuperChatTimeType>(
    context: context,
    builder: (context) => SelectDialog<SuperChatTimeType>(
      title: 'SuperChat 发送时间显示',
      value: Pref.superChatTimeType,
      values: SuperChatTimeType.values.map((e) => (e, e.title)).toList(),
    ),
  );
  if (res != null) {
    await GStorage.setting.put(SettingBoxKey.superChatTimeType, res.index);
    setState();
  }
}

Future<void> _showFullScreenModeDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<FullScreenMode>(
    context: context,
    builder: (context) => SelectDialog<FullScreenMode>(
      title: '默认全屏方向',
      value: Pref.fullScreenMode,
      values: FullScreenMode.values.map((e) => (e, e.desc)).toList(),
    ),
  );
  if (res != null) {
    await GStorage.setting.put(SettingBoxKey.fullScreenMode, res.index);
    setState();
  }
}

Future<void> _showAngleDegreesDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<double>(
    context: context,
    builder: (context) => SliderDialog(
      title: const Text('倾斜角度阈值'),
      min: 10.0,
      max: 90.0,
      divisions: 90,
      precise: 0,
      value: Pref.angleDegrees.toDouble(),
      suffix: '°',
    ),
  );
  if (res != null) {
    await GStorage.setting.put(SettingBoxKey.angleDegrees, res.toInt());
    setState();
  }
}

Future<void> showPlayerVolumeDialog(
  BuildContext context,
  VoidCallback setState, {
  ValueChanged<double>? onChanged,
}) {
  if (Pref.enableAppVolume) {
    SmartDialog.showToast('应用内音量开启时，播放器音量设置不生效');
    return Future.value();
  }
  return showVolumeDialog(
    context,
    title: const Text('播放器音量'),
    value: Pref.playerVolume,
    onChanged: (value) => GStorage.setting
        .put(SettingBoxKey.playerVolume, value)
        .whenComplete(() {
          setState();
          onChanged?.call(value);
        }),
  );
}

Future<void> _showMaxVolumeDialog(
  BuildContext context,
  VoidCallback setState,
) {
  return showVolumeDialog(
    context,
    title: const Text('最高音量'),
    value: Pref.maxVolume * 100,
    onChanged: (rawValue) {
      final maxVolume = (rawValue / 100).toPrecision(2);
      if (Pref.desktopVolume > maxVolume) {
        GStorage.setting.put(SettingBoxKey.desktopVolume, maxVolume);
      }
      GStorage.setting
          .put(SettingBoxKey.maxVolume, maxVolume)
          .whenComplete(setState);
    },
  );
}

const kMinVolume = 100.0;
const kMaxVolume = 300.0;

Future<void> showVolumeDialog(
  BuildContext context, {
  required Widget title,
  required double value,
  required ValueChanged<double> onChanged,
}) async {
  final res = await showDialog<double>(
    context: context,
    builder: (context) => SliderDialog(
      title: title,
      min: kMinVolume,
      max: kMaxVolume,
      divisions: 40,
      precise: 0,
      value: value,
      suffix: '%',
    ),
  );
  if (res != null) {
    onChanged(res);
  }
}
