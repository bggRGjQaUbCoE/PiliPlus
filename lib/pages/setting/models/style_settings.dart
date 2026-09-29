import 'dart:io';
import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/color_palette.dart';
import 'package:PiliPlus/common/widgets/custom_toast.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/scale_app.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart'
    show kSpringDescription;
import 'package:PiliPlus/common/widgets/stateful_builder.dart';
import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/l10n/option_labels.dart';
import 'package:PiliPlus/models/common/bar_hide_type.dart';
import 'package:PiliPlus/models/common/dynamic/dynamic_badge_mode.dart';
import 'package:PiliPlus/models/common/dynamic/up_panel_position.dart';
import 'package:PiliPlus/models/common/home_tab_type.dart';
import 'package:PiliPlus/models/common/msg/msg_unread_type.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/models/common/theme/theme_color_type.dart';
import 'package:PiliPlus/models/common/theme/theme_type.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/pages/setting/models/language_setting.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/slide_color_picker.dart';
import 'package:PiliPlus/pages/setting/widgets/dual_slider_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/multi_select_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/slider_dialog.dart';
import 'package:PiliPlus/plugin/pl_player/utils/fullscreen.dart';
import 'package:PiliPlus/utils/extension/file_ext.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_ui/material_ui.dart' hide StatefulBuilder;
import 'package:path/path.dart' as path;

List<SettingsModel> get styleSettings => [
  languageSetting,
  if (PlatformUtils.isDesktop) ...[
    SwitchModel(
      title: L10n.current.showWindowTitleBarStyleSettingsTitle,
      leading: const Icon(Icons.window),
      setKey: SettingBoxKey.showWindowTitleBar,
      defaultVal: true,
      needReboot: true,
    ),
    SwitchModel(
      title: L10n.current.showTrayIconStyleSettingsTitle,
      leading: const Icon(Icons.donut_large_rounded),
      setKey: SettingBoxKey.showTrayIcon,
      defaultVal: true,
      needReboot: true,
    ),
  ],
  if (Platform.isLinux) _useSSDModel(),
  SwitchModel(
    title: L10n.current.horizontalScreenStyleSettingsTitle,
    subtitle: L10n.current.horizontalScreenStyleSettingsSubtitle,
    leading: const Icon(Icons.phonelink_outlined),
    setKey: SettingBoxKey.horizontalScreen,
    defaultVal: Pref.horizontalScreen,
    onChanged: (value) {
      if (value) {
        fullMode();
      } else {
        portraitUpMode();
      }
    },
  ),
  SwitchModel(
    title: L10n.current.useSideBarStyleSettingsTitle,
    subtitle: L10n.current.useSideBarStyleSettingsSubtitle,
    leading: const Icon(Icons.chrome_reader_mode_outlined),
    setKey: SettingBoxKey.useSideBar,
    defaultVal: false,
    needReboot: true,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle12,
    subtitle: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsSubtitle,
    leading: const Icon(Icons.text_fields),
    onTap: (context, setState) => Get.toNamed('/fontSetting'),
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle,
    getSubtitle: () =>
        L10n.current.pagesSettingModelsStyleSettingsStyleSettingsGetSubtitle4(
          Pref.uiScale.toStringAsFixed(2),
        ),
    leading: const Icon(Icons.zoom_in_outlined),
    onTap: _showUiScaleDialog,
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle7,
    leading: const Icon(Icons.animation),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsStyleSettingsStyleSettingsGetSubtitle3(
          Pref.pageTransition.label,
        ),
    onTap: _showTransitionDialog,
  ),
  SwitchModel(
    title: L10n.current.optTabletNavStyleSettingsTitle,
    leading: const Icon(Icons.auto_fix_high),
    setKey: SettingBoxKey.optTabletNav,
    defaultVal: true,
    needReboot: true,
  ),
  SwitchModel(
    title: L10n.current.enableMYBarStyleSettingsTitle,
    subtitle: L10n.current.enableMYBarStyleSettingsSubtitle,
    leading: const Icon(Icons.design_services_outlined),
    setKey: SettingBoxKey.enableMYBar,
    defaultVal: true,
    needReboot: true,
  ),
  SwitchModel(
    title: L10n.current.floatingNavBarStyleSettingsTitle,
    leading: const Icon(MdiIcons.soundbar),
    setKey: SettingBoxKey.floatingNavBar,
    defaultVal: false,
    needReboot: true,
  ),
  NormalModel(
    leading: const Icon(Icons.calendar_view_week_outlined),
    title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle18,
    getSubtitle: () =>
        L10n.current.pagesSettingModelsStyleSettingsStyleSettingsGetSubtitle7(
          Pref.recommendCardWidth.toInt(),
          Pref.smallCardWidth.toInt(),
          MediaQuery.widthOf(Get.context!).toPrecision(2),
        ),
    onTap: _showCardWidthDialog,
  ),
  SwitchModel(
    title: L10n.current.removeSafeAreaStyleSettingsTitle,
    leading: const Icon(Icons.fit_screen_outlined),
    setKey: SettingBoxKey.removeSafeArea,
    defaultVal: false,
  ),
  SwitchModel(
    title: L10n.current.darkVideoPageStyleSettingsTitle,
    leading: const Icon(Icons.dark_mode_outlined),
    setKey: SettingBoxKey.darkVideoPage,
    defaultVal: false,
  ),
  SwitchModel(
    title: L10n.current.dynamicsWaterfallFlowStyleSettingsTitle,
    subtitle: L10n.current.dynamicsWaterfallFlowStyleSettingsSubtitle,
    leading: const Icon(Icons.view_array_outlined),
    setKey: SettingBoxKey.dynamicsWaterfallFlow,
    defaultVal: Pref.horizontalScreen,
    needReboot: true,
  ),
  PopupModel(
    title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle19,
    leading: const Icon(Icons.person_outlined),
    value: () => Pref.upPanelPosition,
    items: UpPanelPosition.values,
    onSelected: (value, setState) {
      GStorage.setting
          .put(SettingBoxKey.upPanelPosition, value.index)
          .whenComplete(setState);
      SmartDialog.showToast(L10n.current.restartRequired);
    },
  ),
  SwitchModel(
    title: L10n.current.dynamicsShowAllFollowedUpStyleSettingsTitle,
    leading: const Icon(Icons.people_alt_outlined),
    setKey: SettingBoxKey.dynamicsShowAllFollowedUp,
    defaultVal: false,
    needReboot: true,
  ),
  SwitchModel(
    title: L10n.current.expandDynLivePanelStyleSettingsTitle,
    leading: const Icon(Icons.live_tv),
    setKey: SettingBoxKey.expandDynLivePanel,
    defaultVal: false,
    needReboot: true,
  ),
  PopupModel(
    title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle8,
    leading: const Icon(Icons.motion_photos_on_outlined),
    value: () => Pref.dynamicBadgeType,
    items: DynamicBadgeMode.values,
    onSelected: _setDynBadge,
  ),
  PopupModel(
    title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle9,
    leading: const Icon(MdiIcons.bellBadgeOutline),
    value: () => Pref.msgBadgeMode,
    items: DynamicBadgeMode.values,
    onSelected: _setMsgBadge,
  ),
  NormalModel(
    onTap: _showMsgUnReadDialog,
    title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle10,
    leading: const Icon(MdiIcons.bellCogOutline),
    getSubtitle: () =>
        L10n.current.pagesSettingModelsStyleSettingsStyleSettingsGetSubtitle6(
          Pref.msgUnReadTypeV2.map((item) => item.title).join('、'),
        ),
  ),
  PopupModel(
    title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle13,
    leading: const Icon(MdiIcons.arrowExpandVertical),
    value: () => Pref.barHideType,
    items: BarHideType.values,
    onSelected: (value, setState) {
      GStorage.setting
          .put(SettingBoxKey.barHideType, value.index)
          .whenComplete(setState);
      SmartDialog.showToast(L10n.current.restartRequired);
    },
  ),
  SwitchModel(
    title: L10n.current.hideTopBarStyleSettingsTitle,
    subtitle: L10n.current.hideTopBarStyleSettingsSubtitle,
    leading: const Icon(Icons.vertical_align_top_outlined),
    setKey: SettingBoxKey.hideTopBar,
    defaultVal: PlatformUtils.isMobile,
    needReboot: true,
  ),
  SwitchModel(
    title: L10n.current.hideBottomBarStyleSettingsTitle,
    subtitle: L10n.current.hideBottomBarStyleSettingsSubtitle,
    leading: const Icon(Icons.vertical_align_bottom_outlined),
    setKey: SettingBoxKey.hideBottomBar,
    defaultVal: PlatformUtils.isMobile,
    needReboot: true,
  ),
  NormalModel(
    onTap: (context, setState) => _showQualityDialog(
      context: context,
      title: Text(
        L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle2,
      ),
      initValue: Pref.picQuality,
      onChanged: (picQuality) async {
        GlobalData().imgQuality = picQuality;
        await GStorage.setting.put(SettingBoxKey.defaultPicQa, picQuality);
        setState();
      },
    ),
    title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle2,
    subtitle:
        L10n.current.pagesSettingModelsStyleSettingsStyleSettingsSubtitle4,
    leading: const Icon(Icons.image_outlined),
    getTrailing: (theme) => Text(
      '${Pref.picQuality}%',
      style: theme.textTheme.titleSmall,
    ),
  ),
  NormalModel(
    onTap: (context, setState) => _showQualityDialog(
      context: context,
      title: Text(
        L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle11,
      ),
      initValue: Pref.previewQ,
      onChanged: (picQuality) async {
        await GStorage.setting.put(SettingBoxKey.previewQuality, picQuality);
        setState();
      },
    ),
    title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle11,
    subtitle:
        L10n.current.pagesSettingModelsStyleSettingsStyleSettingsSubtitle4,
    leading: const Icon(Icons.image_outlined),
    getTrailing: (theme) => Text(
      '${Pref.previewQ}%',
      style: theme.textTheme.titleSmall,
    ),
  ),
  NormalModel(
    onTap: _showReduceColorDialog,
    title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle17,
    subtitle:
        L10n.current.pagesSettingModelsStyleSettingsStyleSettingsSubtitle6,
    leading: const Icon(Icons.format_color_fill_outlined),
    getTrailing: (theme) => Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Pref.reduceLuxColor ?? Colors.white,
        shape: BoxShape.circle,
      ),
    ),
  ),
  NormalModel(
    leading: const Icon(Icons.opacity_outlined),
    title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle14,
    subtitle:
        L10n.current.pagesSettingModelsStyleSettingsStyleSettingsSubtitle5,
    getTrailing: (theme) => Text(
      CustomToast.toastOpacity.toStringAsFixed(1),
      style: theme.textTheme.titleSmall,
    ),
    onTap: _showToastDialog,
  ),
  PopupModel(
    leading: const Icon(Icons.flashlight_on_outlined),
    title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle3,
    value: () => Pref.themeType,
    items: ThemeType.values,
    onSelected: _setThemeType,
  ),
  SwitchModel(
    leading: const Icon(Icons.invert_colors),
    title: L10n.current.isPureBlackThemeStyleSettingsTitle,
    setKey: SettingBoxKey.isPureBlackTheme,
    defaultVal: false,
    onChanged: (value) {
      if (ThemeUtils.isDarkMode || Pref.darkVideoPage) {
        Get.updateMyAppTheme();
      }
    },
  ),
  NormalModel(
    onTap: (context, setState) => Get.toNamed('/colorSetting'),
    leading: const Icon(Icons.color_lens_outlined),
    title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle4,
    getSubtitle: () =>
        L10n.current.pagesSettingModelsStyleSettingsStyleSettingsGetSubtitle5(
          Pref.dynamicColor
              ? L10n
                    .current
                    .pagesSettingModelsStyleSettingsStyleSettingsGetSubtitle
              : L10n
                    .current
                    .pagesSettingModelsStyleSettingsStyleSettingsGetSubtitle2,
        ),
    getTrailing: (theme) {
      if (Pref.dynamicColor) {
        return Icon(Icons.color_lens_rounded, color: theme.colorScheme.primary);
      }
      final customColor = Pref.customColor;
      final color =
          colorThemeTypes.elementAtOrNull(customColor)?.color ??
          Color(customColor);
      return SizedBox.square(
        dimension: 20,
        child: ColorPalette(
          colorScheme: color.asColorSchemeSeed(
            Pref.schemeVariant,
            theme.brightness,
          ),
          selected: false,
          showBgColor: false,
        ),
      );
    },
  ),
  PopupModel(
    leading: const Icon(Icons.home_outlined),
    title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle6,
    value: () => Pref.defaultHomePage,
    items: NavigationBarType.values,
    onSelected: (value, setState) {
      GStorage.setting
          .put(SettingBoxKey.defaultHomePage, value.index)
          .whenComplete(setState);
      SmartDialog.showToast(L10n.current.restartRequired);
    },
  ),
  NormalModel(
    title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle15,
    leading: const Icon(Icons.chrome_reader_mode_outlined),
    onTap: _showSpringDialog,
  ),
  NormalModel(
    onTap: (context, setState) => Get.toNamed(
      '/barSetting',
      arguments: {
        'key': SettingBoxKey.tabBarSort,
        'defaultBars': HomeTabType.values,
        'title':
            L10n.current.pagesSettingModelsStyleSettingsStyleSettingsArguments,
      },
    ),
    title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsArguments,
    subtitle:
        L10n.current.pagesSettingModelsStyleSettingsStyleSettingsSubtitle2,
    leading: const Icon(Icons.toc_outlined),
  ),
  NormalModel(
    onTap: (context, setState) => Get.toNamed(
      '/barSetting',
      arguments: {
        'key': SettingBoxKey.navBarSort,
        'defaultBars': NavigationBarType.values,
        'title': 'Navbar',
      },
    ),
    title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle16,
    subtitle:
        L10n.current.pagesSettingModelsStyleSettingsStyleSettingsSubtitle3,
    leading: const Icon(Icons.toc_outlined),
  ),
  SwitchModel(
    title: L10n.current.directExitOnBackStyleSettingsTitle,
    subtitle: L10n.current.directExitOnBackStyleSettingsSubtitle,
    leading: const Icon(Icons.exit_to_app_outlined),
    setKey: SettingBoxKey.directExitOnBack,
    defaultVal: false,
    onChanged: (value) => Get.find<MainController>().directExitOnBack = value,
  ),
  if (Platform.isAndroid)
    NormalModel(
      onTap: (context, setState) => Get.toNamed('/displayModeSetting'),
      title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle5,
      leading: const Icon(Icons.autofps_select_outlined),
    ),
];

void _showQualityDialog({
  required BuildContext context,
  required Widget title,
  required int initValue,
  required ValueChanged<int> onChanged,
}) {
  showDialog<double>(
    context: context,
    builder: (context) => SliderDialog(
      value: initValue.toDouble(),
      title: title,
      min: 10,
      max: 100,
      divisions: 9,
      suffix: '%',
      precise: 0,
    ),
  ).then((result) {
    if (result != null) {
      SmartDialog.showToast(L10n.current.settingsSaved);
      onChanged(result.toInt());
    }
  });
}

void _showUiScaleDialog(
  BuildContext context,
  VoidCallback setState,
) {
  const minUiScale = 0.5;
  const maxUiScale = 2.0;

  double uiScale = Pref.uiScale;
  final textController = TextEditingController(
    text: uiScale.toStringAsFixed(2),
  );

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle,
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      content: StatefulBuilder(
        onDispose: textController.dispose,
        builder: (context, setDialogState) => Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              padding: .zero,
              value: uiScale,
              min: minUiScale,
              max: maxUiScale,
              secondaryTrackValue: 1.0,
              divisions: ((maxUiScale - minUiScale) * 20).toInt(),
              label: textController.text,
              onChanged: (value) => setDialogState(() {
                uiScale = value.toPrecision(2);
                textController.text = uiScale.toStringAsFixed(2);
              }),
            ),
            TextFormField(
              controller: textController,
              keyboardType: const .numberWithOptions(decimal: true),
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
                FilteringTextInputFormatter.allow(RegExp(r'[\d.]+')),
              ],
              decoration: InputDecoration(
                labelText: L10n
                    .current
                    .pagesSettingModelsStyleSettingsShowUiScaleDialogLabelText,
                hintText: '0.50 - 2.00',
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                final parsed = double.tryParse(value);
                if (parsed != null &&
                    parsed >= minUiScale &&
                    parsed <= maxUiScale) {
                  setDialogState(() {
                    uiScale = parsed;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            GStorage.setting.delete(SettingBoxKey.uiScale).whenComplete(() {
              setState();
              Get.appUpdate();
              ScaledWidgetsFlutterBinding.instance.scaleFactor = 1.0;
            });
          },
          child: Text(
            L10n
                .current
                .pagesSettingModelsExtraSettingsShowDownPathDialogChild2,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            L10n.current.cancel,
            style: TextStyle(color: ColorScheme.of(context).outline),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            GStorage.setting.put(SettingBoxKey.uiScale, uiScale).whenComplete(
              () {
                setState();
                Get.appUpdate();
                ScaledWidgetsFlutterBinding.instance.scaleFactor = uiScale;
              },
            );
          },
          child: Text(L10n.current.ok),
        ),
      ],
    ),
  );
}

void _showSpringDialog(BuildContext context, _) {
  final List<String> springDescription = Pref.springDescription
      .map((i) => i.toString())
      .toList(growable: false);
  bool physicalMode = true;

  void physical2Duration() {
    final mass = double.parse(springDescription[0]);
    final stiffness = double.parse(springDescription[1]);
    final damping = double.parse(springDescription[2]);

    final duration = math.sqrt(4 * math.pi * math.pi * mass / stiffness);
    final dampingRatio = damping / (2.0 * math.sqrt(mass * stiffness));
    final bounce = dampingRatio < 1.0
        ? 1.0 - dampingRatio
        : 1.0 / dampingRatio - 1;

    springDescription[0] = duration.toString();
    springDescription[1] = bounce.toString();
  }

  /// from [SpringDescription.withDurationAndBounce] but with higher precision
  void duration2Physical() {
    final duration = double.parse(springDescription[0]);
    final bounce = double.parse(springDescription[1]).clamp(-1.0, 1.0);

    final stiffness = 4 * math.pi * math.pi / math.pow(duration, 2);
    final dampingRatio = bounce > 0 ? 1.0 - bounce : 1.0 / (bounce + 1);
    final damping = 2 * math.sqrt(stiffness) * dampingRatio;

    springDescription[0] = '1';
    springDescription[1] = stiffness.toString();
    springDescription[2] = damping.toString();
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            L10n
                .current
                .pagesSettingModelsStyleSettingsShowSpringDialogChildren,
          ),
          TextButton(
            style: TextButton.styleFrom(
              visualDensity: .compact,
              tapTargetSize: .shrinkWrap,
            ),
            onPressed: () {
              try {
                if (physicalMode) {
                  physical2Duration();
                } else {
                  duration2Physical();
                }
                physicalMode = !physicalMode;
                (context as Element).markNeedsBuild();
              } catch (e) {
                SmartDialog.showToast(e.toString());
              }
            },
            child: Text(
              physicalMode
                  ? L10n
                        .current
                        .pagesSettingModelsStyleSettingsShowSpringDialogChild
                  : L10n
                        .current
                        .pagesSettingModelsStyleSettingsShowSpringDialogChild2,
            ),
          ),
        ],
      ),
      content: Column(
        key: ValueKey(physicalMode),
        mainAxisSize: .min,
        children: List.generate(
          physicalMode ? 3 : 2,
          (index) => TextFormField(
            autofocus: index == 0,
            initialValue: springDescription[index],
            keyboardType: .numberWithOptions(
              signed: !physicalMode && index == 1,
              decimal: true,
            ),
            onChanged: (value) => springDescription[index] = value,
            inputFormatters: [
              !physicalMode && index == 1
                  ? FilteringTextInputFormatter.allow(RegExp(r'[-\d\.]+'))
                  : FilteringTextInputFormatter.allow(RegExp(r'[\d\.]+')),
            ],
            decoration: InputDecoration(
              labelText: (physicalMode
                  ? [
                      L10n.current.springMass,
                      L10n.current.springStiffness,
                      L10n.current.springDamping,
                    ]
                  : [
                      L10n.current.springDuration,
                      L10n.current.springBounce,
                    ])[index],
              suffixText: !physicalMode && index == 0 ? 's' : null,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            GStorage.setting.delete(SettingBoxKey.springDescription);
            SmartDialog.showToast(
              L10n
                  .current
                  .pagesSettingModelsStyleSettingsShowSpringDialogOnPressed,
            );
          },
          child: Text(
            L10n
                .current
                .pagesSettingModelsExtraSettingsShowDownPathDialogChild2,
          ),
        ),
        TextButton(
          onPressed: Get.back,
          child: Text(
            L10n.current.cancel,
            style: TextStyle(color: ColorScheme.of(context).outline),
          ),
        ),
        TextButton(
          onPressed: () {
            try {
              if (!physicalMode) {
                duration2Physical();
              }
              final res = springDescription.map(double.parse).toList();
              Get.back();
              GStorage.setting.put(SettingBoxKey.springDescription, res);
              kSpringDescription = SpringDescription(
                mass: res[0],
                stiffness: res[1],
                damping: res[2],
              );
              SmartDialog.showToast(L10n.current.settingsSaved);
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

Future<void> _showTransitionDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<Transition>(
    context: context,
    builder: (context) => SelectDialog<Transition>(
      title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle7,
      value: Pref.pageTransition,
      values: Transition.values.map((e) => (e, e.label)).toList(),
    ),
  );
  if (res != null) {
    Get.rootController.defaultTransition = res;
    await GStorage.setting.put(SettingBoxKey.pageTransition, res.index);
    setState();
  }
}

Future<void> _showCardWidthDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<(double, double)>(
    context: context,
    builder: (context) => DualSliderDialog(
      title: Text(L10n.current.resShowCardWidthDialogTitle),
      value1: Pref.recommendCardWidth,
      value2: Pref.smallCardWidth,
      description1: Text(L10n.current.resShowCardWidthDialogDescription1),
      description2: Text(L10n.current.reportOptionsCommentReportText6),
      min: 150.0,
      max: 500.0,
      divisions: 35,
      suffix: 'dp',
    ),
  );
  if (res != null) {
    await GStorage.setting.putAll({
      SettingBoxKey.recommendCardWidth: res.$1,
      SettingBoxKey.smallCardWidth: res.$2,
    });
    SmartDialog.showToast(L10n.current.restartRequired);
    setState();
  }
}

void _setDynBadge(DynamicBadgeMode value, VoidCallback setState) {
  final mainController = Get.find<MainController>()..dynamicBadgeMode = value;
  if (value != DynamicBadgeMode.hidden) mainController.getUnreadDynamic();
  GStorage.setting
      .put(SettingBoxKey.dynamicBadgeMode, value.index)
      .whenComplete(setState);
}

Future<void> _setMsgBadge(DynamicBadgeMode value, VoidCallback setState) async {
  final mainController = Get.find<MainController>()..msgBadgeMode = value;
  if (value != DynamicBadgeMode.hidden) {
    mainController.queryUnreadMsg(true);
  } else {
    mainController.clearUnreadMsg();
  }
  GStorage.setting
      .put(SettingBoxKey.msgBadgeMode, value.index)
      .whenComplete(setState);
}

Future<void> _showMsgUnReadDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<Set<MsgUnReadType>>(
    context: context,
    builder: (context) => MultiSelectDialog<MsgUnReadType>(
      title: L10n.current.pagesSettingModelsStyleSettingsStyleSettingsTitle10,
      initValues: Pref.msgUnReadTypeV2,
      values: {for (final i in MsgUnReadType.values) i: i.title},
    ),
  );
  if (res != null) {
    final mainController = Get.find<MainController>()..msgUnReadTypes = res;
    if (mainController.msgBadgeMode != DynamicBadgeMode.hidden) {
      mainController.queryUnreadMsg();
    }
    await GStorage.setting.put(
      SettingBoxKey.msgUnReadTypeV2,
      res.map((item) => item.index).toList()..sort(),
    );
    SmartDialog.showToast(L10n.current.settingsSaved);
    setState();
  }
}

void _showReduceColorDialog(
  BuildContext context,
  VoidCallback setState,
) {
  final reduceLuxColor = Pref.reduceLuxColor;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      clipBehavior: Clip.hardEdge,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      title: Text(L10n.current.colourPicker),
      content: SlideColorPicker(
        color: reduceLuxColor ?? Colors.white,
        onChanged: (Color? color) {
          if (color != null && color != reduceLuxColor) {
            if (color == Colors.white) {
              NetworkImgLayer.reduceLuxColor = null;
              GStorage.setting.delete(SettingBoxKey.reduceLuxColor);
              SmartDialog.showToast(L10n.current.settingsSaved);
              setState();
            } else {
              void onConfirm() {
                NetworkImgLayer.reduceLuxColor = color;
                GStorage.setting.put(
                  SettingBoxKey.reduceLuxColor,
                  color.toARGB32(),
                );
                SmartDialog.showToast(L10n.current.settingsSaved);
                setState();
              }

              if (color.computeLuminance() < 0.2) {
                showConfirmDialog(
                  context: context,
                  title: Text(
                    L10n.current
                        .pagesSettingModelsStyleSettingsShowReduceColorDialogTitle(
                          (color.toARGB32() & 0xFFFFFF)
                              .toRadixString(16)
                              .toUpperCase()
                              .padLeft(6),
                        ),
                  ),
                  content: Text(
                    L10n
                        .current
                        .pagesSettingModelsStyleSettingsShowReduceColorDialogContent,
                  ),
                  onConfirm: onConfirm,
                );
              } else {
                onConfirm();
              }
            }
          }
        },
      ),
    ),
  );
}

Future<void> _showToastDialog(
  BuildContext context,
  VoidCallback setState,
) async {
  final res = await showDialog<double>(
    context: context,
    builder: (context) => SliderDialog(
      title: Text(L10n.current.resShowToastDialogTitle),
      value: CustomToast.toastOpacity,
      min: 0.0,
      max: 1.0,
      divisions: 10,
    ),
  );
  if (res != null) {
    CustomToast.toastOpacity = res;
    await GStorage.setting.put(SettingBoxKey.defaultToastOp, res);
    SmartDialog.showToast(L10n.current.settingsSaved);
    setState();
  }
}

void _setThemeType(ThemeType value, VoidCallback setState) {
  try {
    Get.find<MineController>().themeType.value = value;
  } catch (_) {}
  GStorage.setting.put(SettingBoxKey.themeMode, value.index);
  Get.changeThemeMode(ThemeUtils.themeMode = value.toThemeMode);
  setState();
}

NormalModel _useSSDModel() {
  final file = File(path.join(appSupportDirPath, 'use_ssd'));
  void onChanged(BuildContext context, VoidCallback setState) {
    (file.existsSync() ? file.tryDel() : file.create()).whenComplete(setState);
  }

  return NormalModel(
    title: L10n.current.pagesSettingModelsStyleSettingsUseSSDModelTitle,
    leading: const Icon(Icons.web_asset),
    onTap: onChanged,
    getTrailing: (theme) => Builder(
      builder: (context) => Transform.scale(
        scale: 0.8,
        alignment: .centerRight,
        child: Switch(
          value: file.existsSync(),
          onChanged: (_) =>
              onChanged(context, (context as Element).markNeedsBuild),
        ),
      ),
    ),
  );
}
