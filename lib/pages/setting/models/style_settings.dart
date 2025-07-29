import 'dart:io';
import 'dart:math';

import 'package:PiliPlus/common/widgets/custom_toast.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/main.dart';
import 'package:PiliPlus/models/common/dynamic/dynamic_badge_mode.dart';
import 'package:PiliPlus/models/common/dynamic/up_panel_position.dart';
import 'package:PiliPlus/models/common/home_tab_type.dart';
import 'package:PiliPlus/models/common/msg/msg_unread_type.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/models/common/settings_type.dart';
import 'package:PiliPlus/models/common/theme/theme_type.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:PiliPlus/pages/setting/pages/color_select.dart';
import 'package:PiliPlus/pages/setting/widgets/multi_select_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/slide_dialog.dart';
import 'package:PiliPlus/plugin/pl_player/utils/fullscreen.dart';
import 'package:PiliPlus/router/app_pages.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

List<SettingsModel> get styleSettings => [
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '横屏适配',
    subtitle: '启用横屏布局与逻辑，平板、折叠屏等可开启；建议全屏方向设为【不改变当前方向】',
    leading: const Icon(Icons.phonelink_outlined),
    setKey: SettingBoxKey.horizontalScreen,
    defaultVal: Pref.horizontalScreen,
    onChanged: (value) {
      if (value) {
        autoScreen();
      } else {
        AutoOrientation.portraitUpMode();
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '改用侧边栏',
    subtitle: '开启后底栏与顶栏被替换，且相关设置失效',
    leading: const Icon(Icons.chrome_reader_mode_outlined),
    setKey: SettingBoxKey.useSideBar,
    defaultVal: false,
    needReboot: true,
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: 'App字体字重',
    subtitle: '点击设置',
    setKey: SettingBoxKey.appFontWeight,
    defaultVal: false,
    onTap: () {
      showDialog<double>(
        context: Get.context!,
        builder: (context) {
          return SlideDialog(
            title: 'App字体字重',
            value: Pref.appFontWeight.toDouble() + 1,
            min: 1,
            max: FontWeight.values.length.toDouble(),
            divisions: FontWeight.values.length - 1,
          );
        },
      ).then((res) async {
        if (res != null) {
          await GStorage.setting.put(
            SettingBoxKey.appFontWeight,
            res.toInt() - 1,
          );
          Get.forceAppUpdate();
        }
      });
    },
    leading: const Icon(Icons.text_fields),
    onChanged: (value) {
      Get.forceAppUpdate();
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '页面过渡动画',
    leading: const Icon(Icons.animation),
    getSubtitle: () => '当前：${CustomGetPage.pageTransition.name}',
    onTap: (setState) async {
      Transition? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<Transition>(
            title: '页面过渡动画',
            value: CustomGetPage.pageTransition,
            values: Transition.values.map((e) {
              return (e, e.name);
            }).toList(),
          );
        },
      );
      if (result != null) {
        CustomGetPage.pageTransition = result;
        await GStorage.setting.put(SettingBoxKey.pageTransition, result.index);
        SmartDialog.showToast('重启生效');
        setState();
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '优化平板导航栏',
    leading: const Icon(MdiIcons.soundbar),
    setKey: SettingBoxKey.optTabletNav,
    defaultVal: true,
    needReboot: true,
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: 'MD3样式底栏',
    subtitle: 'Material You设计规范底栏，关闭可变窄',
    leading: const Icon(Icons.design_services_outlined),
    setKey: SettingBoxKey.enableMYBar,
    defaultVal: true,
    needReboot: true,
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    onTap: (setState) async {
      double? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SlideDialog(
            title: '列表最大列宽度（默认240dp）',
            value: Pref.smallCardWidth,
            min: 150.0,
            max: 500.0,
            divisions: 35,
            suffix: 'dp',
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(SettingBoxKey.smallCardWidth, result);
        SmartDialog.showToast('重启生效');
        setState();
      }
    },
    leading: const Icon(Icons.calendar_view_week_outlined),
    title: '列表宽度（dp）限制',
    getSubtitle: () =>
        '当前:${Pref.smallCardWidth.toInt()}dp，屏幕宽度:${Get.mediaQuery.size.width.toPrecision(2)}dp。宽度越小列数越多。',
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '视频播放页使用深色主题',
    leading: const Icon(Icons.dark_mode_outlined),
    setKey: SettingBoxKey.darkVideoPage,
    defaultVal: false,
    onChanged: (value) {
      if (value && MyApp.darkThemeData == null) {
        Get.forceAppUpdate();
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '播放页移除安全边距',
    subtitle: '隐藏状态栏、撑满屏幕，但播放控件仍处于安全域内',
    leading: const Icon(Icons.fit_screen_outlined),
    setKey: SettingBoxKey.videoPlayerRemoveSafeArea,
    defaultVal: false,
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '动态页启用瀑布流',
    subtitle: '关闭会显示为单列',
    leading: const Icon(Icons.view_array_outlined),
    setKey: SettingBoxKey.dynamicsWaterfallFlow,
    defaultVal: true,
    needReboot: true,
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '动态页UP主显示位置',
    leading: const Icon(Icons.person_outlined),
    getSubtitle: () => '当前：${Pref.upPanelPosition.label}',
    onTap: (setState) async {
      UpPanelPosition? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<UpPanelPosition>(
            title: '动态页UP主显示位置',
            value: Pref.upPanelPosition,
            values: UpPanelPosition.values.map((e) {
              return (e, e.label);
            }).toList(),
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(SettingBoxKey.upPanelPosition, result.index);
        SmartDialog.showToast('重启生效');
        setState();
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '动态页显示所有已关注UP主',
    leading: const Icon(Icons.people_alt_outlined),
    setKey: SettingBoxKey.dynamicsShowAllFollowedUp,
    defaultVal: false,
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '动态页展开正在直播UP列表',
    leading: const Icon(Icons.live_tv),
    setKey: SettingBoxKey.expandDynLivePanel,
    defaultVal: false,
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    onTap: (setState) async {
      DynamicBadgeMode? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<DynamicBadgeMode>(
            title: '动态未读标记',
            value: Pref.dynamicBadgeType,
            values: DynamicBadgeMode.values.map((e) {
              return (e, e.desc);
            }).toList(),
          );
        },
      );
      if (result != null) {
        MainController mainController = Get.put(MainController())
          ..dynamicBadgeMode = DynamicBadgeMode.values[result.index];
        if (mainController.dynamicBadgeMode != DynamicBadgeMode.hidden) {
          mainController.getUnreadDynamic();
        }
        await GStorage.setting.put(
          SettingBoxKey.dynamicBadgeMode,
          result.index,
        );
        SmartDialog.showToast('设置成功');
        setState();
      }
    },
    title: '动态未读标记',
    leading: const Icon(Icons.motion_photos_on_outlined),
    getSubtitle: () => '当前标记样式：${Pref.dynamicBadgeType.desc}',
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    onTap: (setState) async {
      DynamicBadgeMode? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<DynamicBadgeMode>(
            title: '消息未读标记',
            value: Pref.msgBadgeMode,
            values: DynamicBadgeMode.values.map((e) {
              return (e, e.desc);
            }).toList(),
          );
        },
      );
      if (result != null) {
        MainController mainController = Get.put(MainController())
          ..msgBadgeMode = DynamicBadgeMode.values[result.index];
        if (mainController.msgBadgeMode != DynamicBadgeMode.hidden) {
          mainController.queryUnreadMsg(true);
        } else {
          mainController.msgUnReadCount.value = '';
        }
        await GStorage.setting.put(SettingBoxKey.msgBadgeMode, result.index);
        SmartDialog.showToast('设置成功');
        setState();
      }
    },
    title: '消息未读标记',
    leading: const Icon(MdiIcons.bellBadgeOutline),
    getSubtitle: () => '当前标记样式：${Pref.msgBadgeMode.desc}',
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    onTap: (setState) async {
      final result = await showDialog<Set<MsgUnReadType>>(
        context: Get.context!,
        builder: (context) {
          return MultiSelectDialog<MsgUnReadType>(
            title: '消息未读类型',
            initValues: Pref.msgUnReadTypeV2,
            values: {for (var i in MsgUnReadType.values) i: i.title},
          );
        },
      );
      if (result != null) {
        MainController mainController = Get.put(MainController())
          ..msgUnReadTypes = result;
        if (mainController.msgBadgeMode != DynamicBadgeMode.hidden) {
          mainController.queryUnreadMsg();
        }
        await GStorage.setting.put(
          SettingBoxKey.msgUnReadTypeV2,
          result.map((item) => item.index).toList()..sort(),
        );
        SmartDialog.showToast('设置成功');
        setState();
      }
    },
    title: '消息未读类型',
    leading: const Icon(MdiIcons.bellCogOutline),
    getSubtitle: () =>
        '当前消息类型：${Pref.msgUnReadTypeV2.map((item) => item.title).join('、')}',
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '首页顶栏收起',
    subtitle: '首页列表滑动时，收起顶栏',
    leading: const Icon(Icons.vertical_align_top_outlined),
    setKey: SettingBoxKey.hideSearchBar,
    defaultVal: true,
    needReboot: true,
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '首页底栏收起',
    subtitle: '首页列表滑动时，收起底栏',
    leading: const Icon(Icons.vertical_align_bottom_outlined),
    setKey: SettingBoxKey.hideTabBar,
    defaultVal: true,
    needReboot: true,
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '顶/底栏滚动阈值',
    subtitle: '滚动多少像素后收起/展开顶底栏，默认50像素',
    leading: const Icon(Icons.swipe_vertical),
    defaultVal: true,
    setKey: SettingBoxKey.enableScrollThreshold,
    needReboot: true,
    onTap: () {
      String scrollThreshold = Pref.scrollThreshold.toString();
      showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text('滚动阈值'),
            content: TextFormField(
              autofocus: true,
              initialValue: scrollThreshold,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (value) {
                scrollThreshold = value;
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d\.]+')),
              ],
              decoration: const InputDecoration(suffixText: 'px'),
            ),
            actions: [
              TextButton(
                onPressed: Get.back,
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  GStorage.setting.put(
                    SettingBoxKey.scrollThreshold,
                    max(
                      10.0,
                      double.tryParse(scrollThreshold) ?? 50.0,
                    ),
                  );
                  SmartDialog.showToast('重启生效');
                },
                child: const Text('确定'),
              ),
            ],
          );
        },
      );
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    onTap: (setState) {
      _showQualityDialog(
        context: Get.context!,
        title: '图片质量',
        initValue: Pref.picQuality,
        callback: (picQuality) async {
          GlobalData().imgQuality = picQuality;
          await GStorage.setting.put(SettingBoxKey.defaultPicQa, picQuality);
          setState();
        },
      );
    },
    title: '图片质量',
    subtitle: '选择合适的图片清晰度，上限100%',
    leading: const Icon(Icons.image_outlined),
    getTrailing: () => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        '${Pref.picQuality}%',
        style: Get.theme.textTheme.titleSmall,
      ),
    ),
  ),
  // preview quality
  SettingsModel(
    settingsType: SettingsType.normal,
    onTap: (setState) {
      _showQualityDialog(
        context: Get.context!,
        title: '查看大图质量',
        initValue: Pref.previewQ,
        callback: (picQuality) async {
          await GStorage.setting.put(SettingBoxKey.previewQuality, picQuality);
          setState();
        },
      );
    },
    title: '查看大图质量',
    subtitle: '选择合适的图片清晰度，上限100%',
    leading: const Icon(Icons.image_outlined),
    getTrailing: () => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        '${Pref.previewQ}%',
        style: Get.theme.textTheme.titleSmall,
      ),
    ),
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    onTap: (setState) async {
      double? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SlideDialog(
            title: 'Toast不透明度',
            value: CustomToast.toastOpacity,
            min: 0.0,
            max: 1.0,
            divisions: 10,
          );
        },
      );
      if (result != null) {
        CustomToast.toastOpacity = result;
        await GStorage.setting.put(SettingBoxKey.defaultToastOp, result);
        SmartDialog.showToast('设置成功');
        setState();
      }
    },
    leading: const Icon(Icons.opacity_outlined),
    title: '气泡提示不透明度',
    subtitle: '自定义气泡提示(Toast)不透明度',
    getTrailing: () => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        CustomToast.toastOpacity.toStringAsFixed(1),
        style: Get.theme.textTheme.titleSmall,
      ),
    ),
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    onTap: (setState) async {
      ThemeType? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<ThemeType>(
            title: '主题模式',
            value: Pref.themeType,
            values: ThemeType.values.map(
              (e) {
                return (e, e.desc);
              },
            ).toList(),
          );
        },
      );
      if (result != null) {
        try {
          Get.find<MineController>().themeType.value = result;
        } catch (_) {}
        GStorage.setting.put(SettingBoxKey.themeMode, result.index);
        Get.put(ColorSelectController()).themeType.value = result;
        Get.changeThemeMode(result.toThemeMode);
        setState();
      }
    },
    leading: const Icon(Icons.flashlight_on_outlined),
    title: '主题模式',
    getSubtitle: () => '当前模式：${Pref.themeType.desc}',
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    leading: const Icon(Icons.invert_colors),
    title: '纯黑主题',
    setKey: SettingBoxKey.isPureBlackTheme,
    defaultVal: false,
    onChanged: (value) {
      if (Get.theme.brightness == Brightness.dark || Pref.darkVideoPage) {
        Get.forceAppUpdate();
      }
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    onTap: (setState) => Get.toNamed('/colorSetting'),
    leading: const Icon(Icons.color_lens_outlined),
    title: '应用主题',
    getSubtitle: () =>
        '当前主题：${Get.put(ColorSelectController()).type.value == 0 ? '动态取色' : '指定颜色'}',
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    onTap: (setState) async {
      int? result = await showDialog(
        context: Get.context!,
        builder: (context) {
          return SelectDialog<int>(
            title: '首页启动页',
            value: Pref.defaultHomePage,
            values: NavigationBarType.values.map((e) {
              return (e.index, e.label);
            }).toList(),
          );
        },
      );
      if (result != null) {
        await GStorage.setting.put(SettingBoxKey.defaultHomePage, result);
        SmartDialog.showToast('设置成功，重启生效');
        setState();
      }
    },
    leading: const Icon(Icons.home_outlined),
    title: '默认启动页',
    getSubtitle: () =>
        '当前启动页：${NavigationBarType.values.firstWhere((e) => e.index == Pref.defaultHomePage).label}',
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    title: '滑动动画弹簧参数',
    leading: const Icon(Icons.chrome_reader_mode_outlined),
    onTap: (setState) {
      List<String> springDescription = CustomSpringDescription.springDescription
          .map((i) => i.toString())
          .toList();
      showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text('弹簧参数'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (index) => TextFormField(
                  autofocus: index == 0,
                  initialValue: springDescription[index],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (value) {
                    springDescription[index] = value;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d\.]+')),
                  ],
                  decoration: InputDecoration(
                    labelText: const ['mass', 'stiffness', 'damping'][index],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: Get.back,
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Get.back();
                  await GStorage.setting.put(
                    SettingBoxKey.springDescription,
                    List<double>.generate(
                      3,
                      (i) =>
                          double.tryParse(springDescription[i]) ??
                          CustomSpringDescription.springDescription[i],
                    ),
                  );
                  SmartDialog.showToast('设置成功，重启生效');
                  setState();
                },
                child: const Text('确定'),
              ),
            ],
          );
        },
      );
    },
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    onTap: (setState) async {
      var result = await Get.toNamed('/fontSizeSetting');
      if (result != null) {
        Get.put(ColorSelectController()).currentTextScale.value = result;
      }
    },
    title: '字体大小',
    leading: const Icon(Icons.format_size_outlined),
    getSubtitle: () =>
        Get.put(ColorSelectController()).currentTextScale.value == 1.0
        ? '默认'
        : Get.put(ColorSelectController()).currentTextScale.value.toString(),
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    onTap: (setState) => Get.toNamed(
      '/barSetting',
      arguments: {
        'key': SettingBoxKey.tabBarSort,
        'defaultBars': HomeTabType.values,
        'title': '首页标签页',
      },
    ),
    title: '首页标签页',
    subtitle: '删除或调换首页标签页',
    leading: const Icon(Icons.toc_outlined),
  ),
  SettingsModel(
    settingsType: SettingsType.normal,
    onTap: (setState) => Get.toNamed(
      '/barSetting',
      arguments: {
        'key': SettingBoxKey.navBarSort,
        'defaultBars': NavigationBarType.values,
        'title': 'Navbar',
      },
    ),
    title: 'Navbar编辑',
    subtitle: '删除或调换Navbar',
    leading: const Icon(Icons.toc_outlined),
  ),
  SettingsModel(
    settingsType: SettingsType.sw1tch,
    title: '返回时直接退出',
    subtitle: '开启后在主页任意tab按返回键都直接退出，关闭则先回到Navbar的第一个tab',
    leading: const Icon(Icons.exit_to_app_outlined),
    setKey: SettingBoxKey.directExitOnBack,
    defaultVal: false,
    onChanged: (value) {
      Get.find<MainController>().directExitOnBack = value;
    },
  ),
  if (Platform.isAndroid)
    SettingsModel(
      settingsType: SettingsType.normal,
      onTap: (setState) => Get.toNamed('/displayModeSetting'),
      title: '屏幕帧率',
      leading: const Icon(Icons.autofps_select_outlined),
    ),
];

void _showQualityDialog({
  required BuildContext context,
  required String title,
  required int initValue,
  required ValueChanged<int> callback,
}) {
  showDialog<double>(
    context: context,
    builder: (context) => SlideDialog(
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
      SmartDialog.showToast('设置成功');
      callback(result.toInt());
    }
  });
}
