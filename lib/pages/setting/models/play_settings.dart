import 'dart:io' show Platform;

import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/image_grid/image_grid_view.dart';
import 'package:PiliPlus/models/common/audio_normalization.dart';
import 'package:PiliPlus/models/common/super_chat_type.dart';
import 'package:PiliPlus/models/common/super_resolution_type.dart';
import 'package:PiliPlus/models/common/video/subtitle_pref_type.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/pages/fullscreen_sc.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/slider_dialog.dart';
import 'package:PiliPlus/plugin/pl_player/models/bottom_progress_behavior.dart';
import 'package:PiliPlus/plugin/pl_player/models/fullscreen_mode.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/utils/android/android_helper.dart';
import 'package:PiliPlus/utils/desktop/window_controller.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/ios/pip_helper.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_ui/material_ui.dart';

List<SettingsModel> get playSettings => [
  NormalModel(
    onTap: (context, setState) => Get.toNamed('/playSpeedSet'),
    leading: const Icon(Icons.speed_outlined),
    title: '倍速设置',
    subtitle: '设置视频播放速度',
  ),
  if (kDebugMode || Platform.isAndroid)
    NormalModel(
      onTap: _showAngleDegreesDialog,
      leading: const Icon(MdiIcons.angleAcute),
      title: '倾斜角度阈值',
      getSubtitle: () => '当前:「${Pref.angleDegrees}°」',
    ),
  if (kDebugMode || Platform.isAndroid)
    NormalModel(
      title: '音量均衡',
      leading: const Icon(Icons.multitrack_audio),
      getSubtitle: () {
        final audioNormalization = AudioNormalization.getTitleFromConfig(
          Pref.audioNormalization,
        );
        String fallback = Pref.fallbackNormalization;
        if (fallback == '0') {
          fallback = '';
        } else {
          fallback =
              '，无参数时:「${AudioNormalization.getTitleFromConfig(fallback)}」';
        }
        return '当前:「$audioNormalization」$fallback';
      },
      onTap: audioNormalization,
    ),
  NormalModel(
    title: '超分辨率',
    leading: const Icon(Icons.stay_current_landscape_outlined),
    getSubtitle: () =>
        '当前:「${Pref.superResolutionType.label}」\n默认设置对番剧生效, 其他视频默认关闭\n超分辨率需要启用硬件解码, 若启用硬件解码后仍然不生效, 尝试切换硬件解码器为 auto-copy',
    onTap: _showSuperResolutionDialog,
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
  const SwitchModel(
    title: '左右侧滑动调节亮度/音量',
    leading: Icon(MdiIcons.tuneVerticalVariant),
    setKey: SettingBoxKey.enableSlideVolumeBrightness,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '滚轮调节音量',
    leading: Icon(Icons.mouse_outlined),
    setKey: SettingBoxKey.enableScrollVolume,
    defaultVal: true,
  ),
  if (Platform.isAndroid)
    const SwitchModel(
      title: '调节系统亮度',
      leading: Icon(Icons.brightness_6_outlined),
      setKey: SettingBoxKey.setSystemBrightness,
      defaultVal: false,
    ),
  const SwitchModel(
    title: '中间滑动进入/退出全屏',
    leading: Icon(MdiIcons.panVertical),
    setKey: SettingBoxKey.enableSlideFS,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '提前初始化播放器',
    subtitle: '相对减少手动播放加载时间',
    leading: Icon(Icons.play_circle_outlined),
    setKey: SettingBoxKey.preInitPlayer,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '滑动跳转预览视频缩略图',
    leading: Icon(Icons.preview_outlined),
    setKey: SettingBoxKey.showSeekPreview,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '显示高能进度条',
    subtitle: '高能进度条反应了在时域上，单位时间内弹幕发送量的变化趋势',
    leading: Icon(Icons.show_chart),
    setKey: SettingBoxKey.showDmChart,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '启用双指缩小视频',
    leading: Icon(Icons.pinch),
    setKey: SettingBoxKey.enableShrinkVideoSize,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '启用拖拽字幕调整底部边距',
    leading: Icon(MdiIcons.dragVariant),
    setKey: SettingBoxKey.enableDragSubtitle,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '视频页显示相关视频',
    leading: Icon(MdiIcons.motionPlayOutline),
    setKey: SettingBoxKey.showRelatedVideo,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '默认展开视频简介',
    leading: Icon(Icons.expand_more),
    setKey: SettingBoxKey.alwaysExpandIntroPanel,
    defaultVal: false,
  ),
  const SwitchModel(
    title: '横屏自动展开视频简介',
    leading: Icon(Icons.expand_more),
    setKey: SettingBoxKey.expandIntroPanelH,
    defaultVal: false,
  ),
  SwitchModel(
    title: '横屏分P/合集列表显示在Tab栏',
    leading: const Icon(Icons.format_list_numbered_rtl_sharp),
    setKey: SettingBoxKey.horizontalSeasonPanel,
    defaultVal: Pref.horizontalScreen,
  ),
  SwitchModel(
    title: '横屏播放页在侧栏打开UP主页',
    leading: const Icon(Icons.account_circle_outlined),
    setKey: SettingBoxKey.horizontalMemberPage,
    defaultVal: Pref.horizontalScreen,
  ),
  SwitchModel(
    title: '横屏在侧栏打开图片预览',
    leading: const Icon(Icons.photo_outlined),
    setKey: SettingBoxKey.horizontalPreview,
    defaultVal: false,
    onChanged: (value) => ImageGridView.horizontalPreview = value,
  ),
  const SwitchModel(
    title: '显示视频警告/争议信息',
    leading: Icon(Icons.warning_amber_rounded),
    setKey: SettingBoxKey.showArgueMsg,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '显示视频分段信息',
    leading: Icon(CustomIcons.view_headline_rotate_90),
    setKey: SettingBoxKey.showViewPoints,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '显示继续播放分P提示',
    leading: Icon(Icons.local_parking),
    setKey: SettingBoxKey.continuePlayingPart,
    defaultVal: true,
  ),
  const SwitchModel(
    title: '分P/合集：倒序播放从首集开始播放',
    subtitle: '开启则自动切换为倒序首集，否则保持当前集',
    leading: Icon(MdiIcons.sort),
    setKey: SettingBoxKey.reverseFromFirst,
    defaultVal: true,
  ),
  if (kDebugMode || PlatformUtils.isMobile)
    NormalModel(
      title: '播放器音量',
      leading: const Icon(Icons.volume_up),
      getSubtitle: () => '当前:「${Pref.playerVolume.toStringAsFixed(0)}%」',
      onTap: showPlayerVolumeDialog,
    )
  else
    NormalModel(
      title: '最高音量',
      leading: const Icon(Icons.volume_up),
      getSubtitle: () => '当前:「${(Pref.maxVolume * 100).toStringAsFixed(0)}%」',
      onTap: _showMaxVolumeDialog,
    ),
  getVideoFilterSelectModel(
    title: '双击快进/快退时长',
    suffix: 's',
    key: SettingBoxKey.fastForBackwardDuration,
    values: [5, 10, 15],
    defaultValue: 10,
    isFilter: false,
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
      onChanged: (value) => WindowController.instance.pauseOnMinimize = value,
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
    title: '全屏 SuperChat 设置',
    subtitle: '全屏 SuperChat (醒目留言) 大小、不透明度、缩放设置',
    leading: const Icon(Icons.open_in_full),
    onTap: (_, _) => Get.to(const FullScreenSc()),
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
  if (PlatformUtils.isMobile)
    const SwitchModel(
      title: '后台播放',
      subtitle: '进入后台时继续播放',
      leading: Icon(Icons.motion_photos_pause_outlined),
      setKey: SettingBoxKey.continuePlayInBackground,
      defaultVal: false,
    ),
  if ((Platform.isAndroid && PiliAndroidHelper.isPipAvailable) ||
      (Platform.isIOS && IOSPipHelper.isAvailable))
    SwitchModel(
      title: '后台画中画',
      subtitle: '进入后台时以小窗形式（PiP）播放',
      leading: const Icon(Icons.picture_in_picture_outlined),
      setKey: SettingBoxKey.autoPiP,
      defaultVal: false,
      onChanged: Platform.isAndroid
          ? (val) {
              if (val && !videoPlayerServiceHandler!.enableBackgroundPlay) {
                SmartDialog.showToast('建议开启后台音频服务');
              }
            }
          : null,
    ),
  // PiP on iOS only shows the video frames, without danmaku.
  if (Platform.isAndroid)
    const SwitchModel(
      title: '画中画不加载弹幕',
      subtitle: '当弹幕开关开启时，小窗屏蔽弹幕以获得较好的体验',
      leading: Icon(CustomIcons.dm_off),
      setKey: SettingBoxKey.pipNoDanmaku,
      defaultVal: false,
    ),
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
    await GStorage.setting.put(
      SettingBoxKey.subtitlePreferenceV2,
      res.index,
    );
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

Future<void> _showSuperResolutionDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<SuperResolutionType>(
    context: context,
    builder: (context) => SelectDialog<SuperResolutionType>(
      title: '超分辨率',
      value: Pref.superResolutionType,
      values: SuperResolutionType.values.map((e) => (e, e.label)).toList(),
    ),
  );
  if (res != null) {
    await GStorage.setting.put(
      SettingBoxKey.superResolutionType,
      res.index,
    );
    setState();
  }
}

Future<void> audioNormalization(
  BuildContext context,
  VoidCallback setState, {
  bool fallback = false,
}) async {
  final key = fallback
      ? SettingBoxKey.fallbackNormalization
      : SettingBoxKey.audioNormalization;
  final res = await showDialog<String>(
    context: context,
    builder: (context) {
      String audioNormalization = fallback
          ? Pref.fallbackNormalization
          : Pref.audioNormalization;
      Set<String> values = {
        '0',
        '1',
        if (!fallback) '2',
        audioNormalization,
        '3',
      };
      return SelectDialog<String>(
        title: fallback ? '服务器无loudnorm配置时使用' : '音量均衡',
        toggleable: true,
        value: audioNormalization,
        values: values
            .map(
              (e) => (
                e,
                switch (e) {
                  '0' => AudioNormalization.disable.title,
                  '1' => AudioNormalization.dynaudnorm.title,
                  '2' => AudioNormalization.loudnorm.title,
                  '3' => AudioNormalization.custom.title,
                  _ => e,
                },
              ),
            )
            .toList(),
      );
    },
  );
  if (res != null && context.mounted) {
    if (res == '3') {
      String param = '';
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('自定义参数'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              const Text('等同于 --lavfi-complex="[aid1] 参数 [ao]"'),
              TextField(
                autofocus: true,
                onChanged: (value) => param = value,
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
              onPressed: () {
                Get.back();
                GStorage.setting.put(key, param);
                if (!fallback &&
                    AudioNormalization.loudnormRegExp.hasMatch(param)) {
                  audioNormalization(context, setState, fallback: true);
                }
                setState();
              },
              child: const Text('确定'),
            ),
          ],
        ),
      );
    } else {
      GStorage.setting.put(key, res);
      if (res == '2') {
        audioNormalization(context, setState, fallback: true);
      }
      setState();
    }
  }
}
