import 'dart:io' show Platform;

import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/super_chat_type.dart';
import 'package:PiliPlus/models/common/video/subtitle_pref_type.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/pages/fullscreen_sc_size.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/slider_dialog.dart';
import 'package:PiliPlus/plugin/pl_player/models/bottom_progress_behavior.dart';
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
  SwitchModel(
    title: L10n.current.enableShowDanmakuPlaySettingsTitle,
    subtitle: L10n.current.enableShowDanmakuPlaySettingsSubtitle,
    leading: const Icon(CustomIcons.dm_settings),
    setKey: SettingBoxKey.enableShowDanmaku,
    defaultVal: true,
  ),
  if (PlatformUtils.isMobile)
    SwitchModel(
      title: L10n.current.enableTapDmPlaySettingsTitle,
      subtitle: L10n.current.enableTapDmPlaySettingsSubtitle,
      leading: const Icon(Icons.touch_app_outlined),
      setKey: SettingBoxKey.enableTapDm,
      defaultVal: true,
    ),
  NormalModel(
    onTap: (context, setState) => Get.toNamed('/playSpeedSet'),
    leading: const Icon(Icons.speed_outlined),
    title: L10n.current.pagesSettingModelsPlaySettingsPlaySettingsTitle,
    subtitle: L10n.current.pagesSettingModelsPlaySettingsPlaySettingsSubtitle,
  ),
  if (Platform.isAndroid)
    NormalModel(
      onTap: _showAngleDegreesDialog,
      leading: const Icon(MdiIcons.angleAcute),
      title: L10n.current.pagesSettingModelsPlaySettingsPlaySettingsTitle5,
      getSubtitle: () =>
          L10n.current.pagesSettingModelsPlaySettingsPlaySettingsGetSubtitle(
            Pref.angleDegrees,
          ),
    ),
  SwitchModel(
    title: L10n.current.autoPlayEnablePlaySettingsTitle,
    subtitle: L10n.current.autoPlayEnablePlaySettingsSubtitle,
    leading: const Icon(Icons.motion_photos_auto_outlined),
    setKey: SettingBoxKey.autoPlayEnable,
    defaultVal: false,
  ),
  SwitchModel(
    title: L10n.current.showFsLockBtnPlaySettingsTitle,
    leading: const Icon(Icons.lock_outline),
    setKey: SettingBoxKey.showFsLockBtn,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.showFsScreenshotBtnPlaySettingsTitle,
    leading: const Icon(Icons.photo_camera_outlined),
    setKey: SettingBoxKey.showFsScreenshotBtn,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.showBatteryLevelPlaySettingsTitle,
    leading: const Icon(Icons.battery_3_bar),
    setKey: SettingBoxKey.showBatteryLevel,
    defaultVal: PlatformUtils.isMobile,
  ),
  SwitchModel(
    title: L10n.current.enableQuickDoublePlaySettingsTitle,
    subtitle: L10n.current.enableQuickDoublePlaySettingsSubtitle,
    leading: const Icon(Icons.touch_app_outlined),
    setKey: SettingBoxKey.enableQuickDouble,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.enableSlideVolumeBrightnessPlaySettingsTitle,
    leading: const Icon(MdiIcons.tuneVerticalVariant),
    setKey: SettingBoxKey.enableSlideVolumeBrightness,
    defaultVal: true,
  ),
  if (Platform.isAndroid)
    SwitchModel(
      title: L10n.current.setSystemBrightnessPlaySettingsTitle,
      leading: const Icon(Icons.brightness_6_outlined),
      setKey: SettingBoxKey.setSystemBrightness,
      defaultVal: false,
    ),
  SwitchModel(
    title: L10n.current.enableSlideFSPlaySettingsTitle,
    leading: const Icon(MdiIcons.panVertical),
    setKey: SettingBoxKey.enableSlideFS,
    defaultVal: true,
  ),
  if (PlatformUtils.isMobile)
    NormalModel(
      title: L10n.current.pagesSettingModelsPlaySettingsPlaySettingsTitle4,
      leading: const Icon(Icons.volume_up),
      getSubtitle: () =>
          L10n.current.pagesSettingModelsPlaySettingsPlaySettingsGetSubtitle4(
            Pref.playerVolume.toStringAsFixed(0),
          ),
      onTap: showPlayerVolumeDialog,
    )
  else
    NormalModel(
      title: L10n.current.pagesSettingModelsPlaySettingsPlaySettingsTitle2,
      leading: const Icon(Icons.volume_up),
      getSubtitle: () =>
          L10n.current.pagesSettingModelsPlaySettingsPlaySettingsGetSubtitle4(
            (Pref.maxVolume * 100).toStringAsFixed(0),
          ),
      onTap: _showMaxVolumeDialog,
    ),
  getVideoFilterSelectModel(
    title: L10n.current.pagesSettingModelsPlaySettingsPlaySettingsTitle10,
    suffix: 's',
    key: SettingBoxKey.fastForBackwardDuration,
    values: [5, 10, 15],
    defaultValue: 10,
    isFilter: false,
  ),
  SwitchModel(
    title: L10n.current.useRelativeSlidePlaySettingsTitle,
    leading: const Icon(Icons.swap_horiz_outlined),
    setKey: SettingBoxKey.useRelativeSlide,
    defaultVal: false,
  ),
  getVideoFilterSelectModel(
    title: L10n.current.pagesSettingModelsPlaySettingsPlaySettingsTitle11,
    subtitle: L10n.current.pagesSettingModelsPlaySettingsPlaySettingsSubtitle2,
    suffix: Pref.useRelativeSlide ? '%' : 's',
    key: SettingBoxKey.sliderDuration,
    values: [25, 50, 90, 100],
    defaultValue: 90,
    isFilter: false,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsPlaySettingsPlaySettingsTitle6,
    leading: const Icon(Icons.closed_caption_outlined),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsPlaySettingsPlaySettingsGetSubtitle3(
          Pref.subtitlePreferenceV2.desc,
        ),
    onTap: _showSubtitleDialog,
  ),
  if (PlatformUtils.isDesktop)
    SwitchModel(
      title: L10n.current.pauseOnMinimizePlaySettingsTitle,
      leading: const Icon(Icons.pause_circle_outline),
      setKey: SettingBoxKey.pauseOnMinimize,
      defaultVal: false,
      onChanged: (value) {
        try {
          Get.find<MainController>().pauseOnMinimize = value;
        } catch (_) {}
      },
    ),
  SwitchModel(
    title: L10n.current.keyboardControlPlaySettingsTitle,
    leading: const Icon(Icons.keyboard_alt_outlined),
    setKey: SettingBoxKey.keyboardControl,
    defaultVal: true,
  ),
  PopupModel(
    title: L10n.current.pagesSettingModelsPlaySettingsPlaySettingsTitle12,
    leading: const Icon(Icons.live_tv),
    value: () => Pref.superChatType,
    items: SuperChatType.values,
    onSelected: (value, setState) => GStorage.setting
        .put(SettingBoxKey.superChatType, value.index)
        .whenComplete(setState),
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsPlaySettingsPlaySettingsTitle9,
    subtitle: L10n.current.pagesSettingModelsPlaySettingsPlaySettingsSubtitle3,
    leading: const Icon(Icons.open_in_full),
    onTap: (_, _) => Get.to(const FullScreenScSize()),
  ),
  SwitchModel(
    title: L10n.current.enableVerticalExpandPlaySettingsTitle,
    subtitle: L10n.current.enableVerticalExpandPlaySettingsSubtitle,
    leading: const Icon(Icons.expand_outlined),
    setKey: SettingBoxKey.enableVerticalExpand,
    defaultVal: false,
  ),
  SwitchModel(
    title: L10n.current.enableAutoEnterPlaySettingsTitle,
    subtitle: L10n.current.enableAutoEnterPlaySettingsSubtitle,
    leading: const Icon(Icons.fullscreen_outlined),
    setKey: SettingBoxKey.enableAutoEnter,
    defaultVal: false,
  ),
  SwitchModel(
    title: L10n.current.enableAutoExitPlaySettingsTitle,
    subtitle: L10n.current.enableAutoExitPlaySettingsSubtitle,
    leading: const Icon(Icons.fullscreen_exit_outlined),
    setKey: SettingBoxKey.enableAutoExit,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.enableLongShowControlPlaySettingsTitle,
    subtitle: L10n.current.enableLongShowControlPlaySettingsSubtitle,
    leading: const Icon(Icons.timer_outlined),
    setKey: SettingBoxKey.enableLongShowControl,
    defaultVal: false,
  ),
  if (PlatformUtils.isMobile)
    SwitchModel(
      title: L10n.current.backgroundPlayback,
      subtitle: L10n.current.continuePlayInBackgroundPlaySettingsSubtitle,
      leading: const Icon(Icons.motion_photos_pause_outlined),
      setKey: SettingBoxKey.continuePlayInBackground,
      defaultVal: false,
    ),
  if (Platform.isAndroid) ...[
    SwitchModel(
      title: L10n.current.autoPiPPlaySettingsTitle,
      subtitle: L10n.current.autoPiPPlaySettingsSubtitle,
      leading: const Icon(Icons.picture_in_picture_outlined),
      setKey: SettingBoxKey.autoPiP,
      defaultVal: false,
      onChanged: (val) {
        if (val && !videoPlayerServiceHandler!.enableBackgroundPlay) {
          SmartDialog.showToast(L10n.current.autoPiPPlaySettingsOnChanged);
        }
      },
    ),
    SwitchModel(
      title: L10n.current.pipNoDanmakuPlaySettingsTitle,
      subtitle: L10n.current.pipNoDanmakuPlaySettingsSubtitle,
      leading: const Icon(CustomIcons.dm_off),
      setKey: SettingBoxKey.pipNoDanmaku,
      defaultVal: false,
    ),
  ],
  SwitchModel(
    title: L10n.current.fullScreenGestureReversePlaySettingsTitle,
    subtitle: L10n.current.fullScreenGestureReversePlaySettingsSubtitle,
    leading: const Icon(Icons.swap_vert),
    setKey: SettingBoxKey.fullScreenGestureReverse,
    defaultVal: false,
  ),
  SwitchModel(
    title: L10n.current.showFSActionItemPlaySettingsTitle,
    leading: const Icon(MdiIcons.dotsHorizontalCircleOutline),
    setKey: SettingBoxKey.showFSActionItem,
    defaultVal: true,
  ),
  SwitchModel(
    title: L10n.current.enableOnlineTotalPlaySettingsTitle,
    subtitle: L10n.current.enableOnlineTotalPlaySettingsSubtitle,
    leading: const Icon(Icons.people_outlined),
    setKey: SettingBoxKey.enableOnlineTotal,
    defaultVal: false,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsPlaySettingsPlaySettingsTitle7,
    leading: const Icon(Icons.open_with_outlined),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsPlaySettingsPlaySettingsGetSubtitle2(
          Pref.fullScreenMode.desc,
        ),
    onTap: _showFullScreenModeDialog,
  ),
  PopupModel(
    title: L10n.current.pagesSettingModelsPlaySettingsPlaySettingsTitle8,
    leading: const Icon(Icons.border_bottom_outlined),
    value: () => Pref.btmProgressBehavior,
    items: BtmProgressBehavior.values,
    onSelected: (value, setState) => GStorage.setting
        .put(SettingBoxKey.btmProgressBehavior, value.index)
        .whenComplete(setState),
  ),
  if (PlatformUtils.isMobile)
    SwitchModel(
      title: L10n.current.enableBackgroundPlayPlaySettingsTitle,
      subtitle: L10n.current.enableBackgroundPlayPlaySettingsSubtitle,
      leading: const Icon(Icons.volume_up_outlined),
      setKey: SettingBoxKey.enableBackgroundPlay,
      defaultVal: true,
      onChanged: (value) =>
          videoPlayerServiceHandler!.enableBackgroundPlay = value,
    ),
  PopupModel(
    title: L10n.current.playOrder,
    leading: const Icon(Icons.repeat),
    value: () => Pref.playRepeat,
    items: PlayRepeat.values,
    onSelected: (value, setState) => GStorage.video
        .put(VideoBoxKey.playRepeat, value.index)
        .whenComplete(setState),
  ),
  SwitchModel(
    title: L10n.current.tempPlayerConfPlaySettingsTitle,
    subtitle: L10n.current.tempPlayerConfPlaySettingsSubtitle,
    leading: const Icon(Icons.video_settings_outlined),
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
      title: L10n.current.resShowSubtitleDialogTitle,
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
      title: L10n.current.pagesSettingModelsPlaySettingsPlaySettingsTitle7,
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
      title: Text(
        L10n.current.pagesSettingModelsPlaySettingsPlaySettingsTitle5,
      ),
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
    title: Text(L10n.current.pagesSettingModelsPlaySettingsPlaySettingsTitle4),
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
    title: Text(L10n.current.pagesSettingModelsPlaySettingsPlaySettingsTitle2),
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
