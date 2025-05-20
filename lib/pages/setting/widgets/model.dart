import 'dart:io';
import 'dart:math';

import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart'
    show kDragContainerExtentPercentage, displacement;
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/reply.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/main.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/models/common/audio_normalization.dart';
import 'package:PiliPlus/models/common/dynamic/dynamic_badge_mode.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/common/dynamic/up_panel_position.dart';
import 'package:PiliPlus/models/common/home_tab_type.dart';
import 'package:PiliPlus/models/common/member/tab_type.dart';
import 'package:PiliPlus/models/common/msg/msg_unread_type.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/models/common/reply/reply_sort_type.dart';
import 'package:PiliPlus/models/common/settings_type.dart';
import 'package:PiliPlus/models/common/super_resolution_type.dart';
import 'package:PiliPlus/models/common/theme/theme_type.dart';
import 'package:PiliPlus/models/common/video/audio_quality.dart';
import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/common/video/live_quality.dart';
import 'package:PiliPlus/models/common/video/subtitle_pref_type.dart';
import 'package:PiliPlus/models/common/video/video_decode_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/pages/home/controller.dart';
import 'package:PiliPlus/pages/hot/controller.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/pages/rcmd/controller.dart';
import 'package:PiliPlus/pages/setting/pages/color_select.dart';
import 'package:PiliPlus/pages/setting/widgets/multi_select_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/normal_item.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/slide_dialog.dart';
import 'package:PiliPlus/pages/setting/widgets/switch_item.dart';
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/plugin/pl_player/models/bottom_progress_behavior.dart';
import 'package:PiliPlus/plugin/pl_player/models/fullscreen_mode.dart';
import 'package:PiliPlus/plugin/pl_player/utils/fullscreen.dart';
import 'package:PiliPlus/utils/accounts/account_manager/account_mgr.dart';
import 'package:PiliPlus/utils/cache_manage.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/recommend_filter.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

extension SettingsModelExt on SettingsModel {
  Widget get widget => switch (settingsType) {
        SettingsType.divider => const Divider(height: 1),
        SettingsType.normal => NormalItem(
            title: title,
            getTitle: getTitle,
            subtitle: subtitle,
            getSubtitle: getSubtitle,
            setKey: setKey,
            defaultVal: defaultVal,
            onChanged: onChanged,
            needReboot: needReboot,
            leading: leading,
            getTrailing: getTrailing,
            onTap: onTap,
            contentPadding: contentPadding,
            titleStyle: titleStyle,
          ),
        SettingsType.sw1tch => SetSwitchItem(
            title: title,
            subtitle: subtitle,
            setKey: setKey,
            defaultVal: defaultVal,
            onChanged: onChanged,
            needReboot: needReboot,
            leading: leading,
            onTap: onTap,
            contentPadding: contentPadding,
            titleStyle: titleStyle,
          ),
      };
}

class SettingsModel {
  final SettingsType settingsType;
  final String? title;
  final Function? getTitle;
  final String? subtitle;
  final Function? getSubtitle;
  final String? setKey;
  final bool? defaultVal;
  final ValueChanged<bool>? onChanged;
  final bool? needReboot;
  final Widget? leading;
  final Function? getTrailing;
  final Function? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? titleStyle;
  final bool? enableFeedback;

  SettingsModel({
    required this.settingsType,
    this.title,
    this.getTitle,
    this.subtitle,
    this.getSubtitle,
    this.setKey,
    this.defaultVal,
    this.onChanged,
    this.needReboot,
    this.leading,
    this.getTrailing,
    this.onTap,
    this.contentPadding,
    this.titleStyle,
    this.enableFeedback,
  });
}

List<SettingsModel> get styleSettings => [
      SettingsModel(
          settingsType: SettingsType.sw1tch,
          title: '横屏适配',
          subtitle: '启用横屏布局与逻辑，平板、折叠屏等可开启；建议全屏方向设为【不改变当前方向】',
          leading: const Icon(Icons.phonelink_outlined),
          setKey: SettingBoxKey.horizontalScreen,
          defaultVal: GStorage.horizontalScreen,
          onChanged: (value) {
            if (value) {
              autoScreen();
            } else {
              AutoOrientation.portraitUpMode();
            }
          }),
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
                value: GStorage.appFontWeight.toDouble() + 1,
                min: 1,
                max: FontWeight.values.length.toDouble(),
                divisions: FontWeight.values.length - 1,
              );
            },
          ).then((res) async {
            if (res != null) {
              await GStorage.setting
                  .put(SettingBoxKey.appFontWeight, res.toInt() - 1);
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
        getSubtitle: () => '当前：${GStorage.pageTransition.name}',
        onTap: (setState) async {
          Transition? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<Transition>(
                title: '页面过渡动画',
                value: GStorage.pageTransition,
                values: Transition.values.map((e) {
                  return (e, e.name);
                }).toList(),
              );
            },
          );
          if (result != null) {
            GStorage.pageTransition = result;
            await GStorage.setting
                .put(SettingBoxKey.pageTransition, result.index);
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
                  value: GStorage.smallCardWidth,
                  min: 150.0,
                  max: 500.0,
                  divisions: 35,
                  suffix: 'dp',
                );
              });
          if (result != null) {
            await GStorage.setting.put(SettingBoxKey.smallCardWidth, result);
            SmartDialog.showToast('重启生效');
            setState();
          }
        },
        leading: const Icon(Icons.calendar_view_week_outlined),
        title: '列表宽度（dp）限制',
        getSubtitle: () =>
            '当前:${GStorage.smallCardWidth.toInt()}dp，屏幕宽度:${MediaQuery.of(Get.context!).size.width.toPrecision(2)}dp。宽度越小列数越多。',
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
        getSubtitle: () => '当前：${GStorage.upPanelPosition.label}',
        onTap: (setState) async {
          UpPanelPosition? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<UpPanelPosition>(
                title: '动态页UP主显示位置',
                value: GStorage.upPanelPosition,
                values: UpPanelPosition.values.map((e) {
                  return (e, e.label);
                }).toList(),
              );
            },
          );
          if (result != null) {
            await GStorage.setting
                .put(SettingBoxKey.upPanelPosition, result.index);
            SmartDialog.showToast('重启生效');
            setState();
          }
        },
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '动态页显示所有已关注UP主',
        subtitle: '并以最常访问排序UP',
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
                value: GStorage.dynamicBadgeType,
                values: DynamicBadgeMode.values.map((e) {
                  return (e, e.description);
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
            await GStorage.setting
                .put(SettingBoxKey.dynamicBadgeMode, result.index);
            SmartDialog.showToast('设置成功');
            setState();
          }
        },
        title: '动态未读标记',
        leading: const Icon(Icons.motion_photos_on_outlined),
        getSubtitle: () => '当前标记样式：${GStorage.dynamicBadgeType.description}',
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        onTap: (setState) async {
          DynamicBadgeMode? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<DynamicBadgeMode>(
                title: '消息未读标记',
                value: GStorage.msgBadgeMode,
                values: DynamicBadgeMode.values.map((e) {
                  return (e, e.description);
                }).toList(),
              );
            },
          );
          if (result != null) {
            MainController mainController = Get.put(MainController())
              ..msgBadgeMode = DynamicBadgeMode.values[result.index];
            if (mainController.msgBadgeMode != DynamicBadgeMode.hidden) {
              mainController.queryUnreadMsg();
            } else {
              mainController.msgUnReadCount.value = '';
            }
            await GStorage.setting
                .put(SettingBoxKey.msgBadgeMode, result.index);
            SmartDialog.showToast('设置成功');
            setState();
          }
        },
        title: '消息未读标记',
        leading: const Icon(MdiIcons.bellBadgeOutline),
        getSubtitle: () => '当前标记样式：${GStorage.msgBadgeMode.description}',
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        onTap: (setState) async {
          final result = await showDialog<Set<MsgUnReadType>>(
            context: Get.context!,
            builder: (context) {
              return MultiSelectDialog<MsgUnReadType>(
                title: '消息未读类型',
                initValues: GStorage.msgUnReadTypeV2,
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
            await GStorage.setting.put(SettingBoxKey.msgUnReadTypeV2,
                result.map((item) => item.index).toList()..sort());
            SmartDialog.showToast('设置成功');
            setState();
          }
        },
        title: '消息未读类型',
        leading: const Icon(MdiIcons.bellCogOutline),
        getSubtitle: () =>
            '当前消息类型：${GStorage.msgUnReadTypeV2.map((item) => item.title).join('、')}',
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
        title: '降低收起/展开顶/底栏频率',
        leading: const Icon(Icons.vertical_distribute),
        setKey: SettingBoxKey.navSearchStreamDebounce,
        defaultVal: false,
        onChanged: (value) {
          try {
            Get.find<MainController>().navSearchStreamDebounce = value;
            Get.forceAppUpdate();
          } catch (_) {}
        },
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        onTap: (setState) {
          _showQualityDialog(
            context: Get.context!,
            title: '图片质量',
            initValue: GStorage.picQuality,
            callback: (picQuality) async {
              GlobalData().imgQuality = picQuality;
              await GStorage.setting
                  .put(SettingBoxKey.defaultPicQa, picQuality);
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
            '${GStorage.picQuality}%',
            style: Theme.of(Get.context!).textTheme.titleSmall,
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
            initValue: GStorage.previewQ,
            callback: (picQuality) async {
              await GStorage.setting
                  .put(SettingBoxKey.previewQuality, picQuality);
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
            '${GStorage.previewQ}%',
            style: Theme.of(Get.context!).textTheme.titleSmall,
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
                value: GStorage.toastOpacity,
                min: 0.0,
                max: 1.0,
                divisions: 10,
              );
            },
          );
          if (result != null) {
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
            GStorage.toastOpacity.toStringAsFixed(1),
            style: Theme.of(Get.context!).textTheme.titleSmall,
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
                  value: GStorage.themeType,
                  values: ThemeType.values.map(
                    (e) {
                      return (e, e.description);
                    },
                  ).toList());
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
        getSubtitle: () => '当前模式：${GStorage.themeType.description}',
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        leading: const Icon(Icons.invert_colors),
        title: '纯黑主题',
        setKey: SettingBoxKey.isPureBlackTheme,
        defaultVal: false,
        onChanged: (value) {
          if (Theme.of(Get.context!).brightness == Brightness.dark ||
              GStorage.darkVideoPage) {
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
                value: GStorage.defaultHomePage,
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
            '当前启动页：${NavigationBarType.values.firstWhere((e) => e.index == GStorage.defaultHomePage).label}',
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '滑动动画弹簧参数',
        leading: const Icon(Icons.chrome_reader_mode_outlined),
        onTap: (setState) {
          final numberRegExp = RegExp(r'[\d\.]+');
          List<String> springDescription =
              GStorage.springDescription.map((i) => i.toString()).toList();
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
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        springDescription[index] = value;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(numberRegExp)
                      ],
                      decoration: InputDecoration(
                        labelText: const [
                          'mass',
                          'stiffness',
                          'damping'
                        ][index],
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
                              GStorage.springDescription[i],
                        ),
                      );
                      SmartDialog.showToast('设置成功，重启生效');
                      setState();
                    },
                    child: const Text('确定'),
                  )
                ],
              );
            },
          );
        },
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        onTap: (setState) async {
          dynamic result = await Get.toNamed('/fontSizeSetting');
          if (result != null) {
            Get.put(ColorSelectController()).currentTextScale.value = result;
          }
        },
        title: '字体大小',
        leading: const Icon(Icons.format_size_outlined),
        getSubtitle: () =>
            Get.put(ColorSelectController()).currentTextScale.value == 1.0
                ? '默认'
                : Get.put(ColorSelectController())
                    .currentTextScale
                    .value
                    .toString(),
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        onTap: (setState) => Get.toNamed('/barSetting', arguments: {
          'key': SettingBoxKey.tabBarSort,
          'defaultBars': HomeTabType.values,
          'title': '首页标签页'
        }),
        title: '首页标签页',
        subtitle: '删除或调换首页标签页',
        leading: const Icon(Icons.toc_outlined),
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        onTap: (setState) => Get.toNamed('/barSetting', arguments: {
          'key': SettingBoxKey.navBarSort,
          'defaultBars': NavigationBarType.values,
          'title': 'Navbar'
        }),
        title: 'Navbar编辑',
        subtitle: '删除或调换Navbar',
        leading: const Icon(Icons.toc_outlined),
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
        precise: 0),
  ).then((result) {
    if (result != null) {
      SmartDialog.showToast('设置成功');
      callback(result.toInt());
    }
  });
}

List<SettingsModel> get playSettings => [
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '弹幕开关',
        subtitle: '是否展示弹幕',
        leading: const Icon(CustomIcon.dm_settings),
        setKey: SettingBoxKey.enableShowDanmaku,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        onTap: (setState) => Get.toNamed('/playSpeedSet'),
        leading: const Icon(Icons.speed_outlined),
        title: '倍速设置',
        subtitle: '设置视频播放速度',
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '自动播放',
        subtitle: '进入详情页自动播放',
        leading: const Icon(Icons.motion_photos_auto_outlined),
        setKey: SettingBoxKey.autoPlayEnable,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '双击快退/快进',
        subtitle: '左侧双击快退/右侧双击快进，关闭则双击均为暂停/播放',
        leading: const Icon(Icons.touch_app_outlined),
        setKey: SettingBoxKey.enableQuickDouble,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '左右侧滑动调节亮度/音量',
        leading: const Icon(MdiIcons.tuneVerticalVariant),
        setKey: SettingBoxKey.enableSlideVolumeBrightness,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '中间滑动进入/退出全屏',
        leading: const Icon(MdiIcons.panVertical),
        setKey: SettingBoxKey.enableSlideFS,
        defaultVal: true,
      ),
      _getVideoFilterSelectModel(
        context: Get.context!,
        title: '双击快进/快退时长',
        suffix: 's',
        key: SettingBoxKey.fastForBackwardDuration,
        values: [5, 10, 15],
        defaultValue: 10,
        isFilter: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '滑动快进/快退使用相对时长',
        leading: const Icon(Icons.swap_horiz_outlined),
        setKey: SettingBoxKey.useRelativeSlide,
        defaultVal: false,
      ),
      _getVideoFilterSelectModel(
        context: Get.context!,
        title: '滑动快进/快退时长',
        subtitle: '从播放器一端滑到另一端的快进/快退时长',
        suffix: GStorage.useRelativeSlide ? '%' : 's',
        key: SettingBoxKey.sliderDuration,
        values: [25, 50, 90, 100],
        defaultValue: 90,
        isFilter: false,
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '自动启用字幕',
        leading: const Icon(Icons.closed_caption_outlined),
        getSubtitle: () =>
            '当前选择偏好：${SubtitlePrefTypeExt.fromCode(GStorage.defaultSubtitlePreference)!.description}',
        onTap: (setState) async {
          String? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<String>(
                title: '字幕选择偏好',
                value: GStorage.setting.get(SettingBoxKey.subtitlePreference,
                    defaultValue: SubtitlePrefType.values.first.code),
                values: SubtitlePrefType.values
                    .map((e) => (e.code, e.description))
                    .toList(),
              );
            },
          );
          if (result != null) {
            await GStorage.setting
                .put(SettingBoxKey.subtitlePreference, result);
            setState();
          }
        },
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '竖屏扩大展示',
        subtitle: '小屏竖屏视频宽高比由16:9扩大至1:1（不支持收起）；横屏适配时，扩大至9:16',
        leading: const Icon(Icons.expand_outlined),
        setKey: SettingBoxKey.enableVerticalExpand,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '自动全屏',
        subtitle: '视频开始播放时进入全屏',
        leading: const Icon(Icons.fullscreen_outlined),
        setKey: SettingBoxKey.enableAutoEnter,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '自动退出全屏',
        subtitle: '视频结束播放时退出全屏',
        leading: const Icon(Icons.fullscreen_exit_outlined),
        setKey: SettingBoxKey.enableAutoExit,
        defaultVal: true,
      ),
      SettingsModel(
          settingsType: SettingsType.sw1tch,
          title: '延长播放控件显示时间',
          subtitle: '开启后延长至30秒，便于屏幕阅读器滑动切换控件焦点',
          leading: const Icon(Icons.timer_outlined),
          setKey: SettingBoxKey.enableLongShowControl,
          defaultVal: false),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '全向旋转',
        subtitle: '小屏可受重力转为临时全屏，若系统锁定旋转仍触发请关闭，关闭会影响横屏适配',
        leading: const Icon(Icons.screen_rotation_alt_outlined),
        setKey: SettingBoxKey.allowRotateScreen,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '后台播放',
        subtitle: '进入后台时继续播放',
        leading: const Icon(Icons.motion_photos_pause_outlined),
        setKey: SettingBoxKey.continuePlayInBackground,
        defaultVal: false,
      ),
      if (Platform.isAndroid)
        SettingsModel(
            settingsType: SettingsType.sw1tch,
            title: '后台画中画',
            subtitle: '进入后台时以小窗形式（PiP）播放',
            leading: const Icon(Icons.picture_in_picture_outlined),
            setKey: SettingBoxKey.autoPiP,
            defaultVal: false,
            onChanged: (val) {
              if (val &&
                  !GStorage.setting.get(SettingBoxKey.enableBackgroundPlay,
                      defaultValue: true)) {
                SmartDialog.showToast('建议开启后台音频服务');
              }
            }),
      if (Platform.isAndroid)
        SettingsModel(
          settingsType: SettingsType.sw1tch,
          title: '画中画不加载弹幕',
          subtitle: '当弹幕开关开启时，小窗屏蔽弹幕以获得较好的体验',
          leading: const Icon(Icons.subtitles_off_outlined),
          setKey: SettingBoxKey.pipNoDanmaku,
          defaultVal: false,
        ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '全屏手势反向',
        subtitle: '默认播放器中部向上滑动进入全屏，向下退出\n开启后向下全屏，向上退出',
        leading: const Icon(Icons.swap_vert_outlined),
        setKey: SettingBoxKey.fullScreenGestureReverse,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '观看人数',
        subtitle: '展示同时在看人数',
        leading: const Icon(Icons.people_outlined),
        setKey: SettingBoxKey.enableOnlineTotal,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '默认全屏方向',
        leading: const Icon(Icons.open_with_outlined),
        getSubtitle: () =>
            '当前全屏方向：${FullScreenModeCode.fromCode(GStorage.defaultFullScreenMode).description}',
        onTap: (setState) async {
          int? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<int>(
                  title: '默认全屏方向',
                  value: GStorage.defaultFullScreenMode,
                  values: FullScreenMode.values.map((e) {
                    return (e.code, e.description);
                  }).toList());
            },
          );
          if (result != null) {
            await GStorage.setting.put(SettingBoxKey.fullScreenMode, result);
            setState();
          }
        },
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '底部进度条展示',
        leading: const Icon(Icons.border_bottom_outlined),
        getSubtitle: () =>
            '当前展示方式：${BtmProgresBehaviorCode.fromCode(GStorage.defaultBtmProgressBehavior).description}',
        onTap: (setState) async {
          int? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<int>(
                  title: '底部进度条展示',
                  value: GStorage.defaultBtmProgressBehavior,
                  values: BtmProgressBehavior.values.map((e) {
                    return (e.code, e.description);
                  }).toList());
            },
          );
          if (result != null) {
            await GStorage.setting
                .put(SettingBoxKey.btmProgressBehavior, result);
            setState();
          }
        },
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '后台音频服务',
        subtitle: '避免画中画没有播放暂停功能',
        leading: const Icon(Icons.volume_up_outlined),
        setKey: SettingBoxKey.enableBackgroundPlay,
        defaultVal: true,
      ),
    ];

List<SettingsModel> get videoSettings => [
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '开启硬解',
        subtitle: '以较低功耗播放视频，若异常卡死请关闭',
        leading: const Icon(Icons.flash_on_outlined),
        setKey: SettingBoxKey.enableHA,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '免登录1080P',
        subtitle: '免登录查看1080P视频',
        leading: const Icon(Icons.hd_outlined),
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
            thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                (Set<WidgetState> states) {
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
            '当前使用：${CDNService.fromCode(GStorage.defaultCDNService).description}，部分 CDN 可能失效，如无法播放请尝试切换',
        onTap: (setState) async {
          String? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return const CdnSelectDialog();
            },
          );
          if (result != null) {
            await GStorage.setting.put(SettingBoxKey.CDNService, result);
            setState();
          }
        },
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: 'CDN 测速',
        leading: const Icon(Icons.speed),
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
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '默认画质',
        leading: const Icon(Icons.video_settings_outlined),
        getSubtitle: () =>
            '当前画质：${VideoQuality.fromCode(GStorage.defaultVideoQa).description}',
        onTap: (setState) async {
          int? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<int>(
                title: '默认画质',
                value: GStorage.defaultVideoQa,
                values: VideoQuality.values.reversed
                    .map((e) => (e.code, e.description))
                    .toList(),
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
            '当前画质：${VideoQuality.fromCode(GStorage.defaultVideoQaCellular).description}',
        onTap: (setState) async {
          int? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<int>(
                title: '蜂窝网络画质',
                value: GStorage.defaultVideoQaCellular,
                values: VideoQuality.values.reversed.map((e) {
                  return (e.code, e.description);
                }).toList(),
              );
            },
          );
          if (result != null) {
            await GStorage.setting
                .put(SettingBoxKey.defaultVideoQaCellular, result);
            setState();
          }
        },
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '默认音质',
        leading: const Icon(Icons.music_video_outlined),
        getSubtitle: () =>
            '当前音质：${AudioQuality.fromCode(GStorage.defaultAudioQa).description}',
        onTap: (setState) async {
          int? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<int>(
                title: '默认音质',
                value: GStorage.defaultAudioQa,
                values: AudioQuality.values.reversed
                    .map((e) => (e.code, e.description))
                    .toList(),
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
            '当前音质：${AudioQuality.fromCode(GStorage.defaultAudioQaCellular).description}',
        onTap: (setState) async {
          int? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<int>(
                title: '蜂窝网络音质',
                value: GStorage.defaultAudioQaCellular,
                values: AudioQuality.values.reversed.map((e) {
                  return (e.code, e.description);
                }).toList(),
              );
            },
          );
          if (result != null) {
            await GStorage.setting
                .put(SettingBoxKey.defaultAudioQaCellular, result);
            setState();
          }
        },
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '直播默认画质',
        leading: const Icon(Icons.video_settings_outlined),
        getSubtitle: () =>
            '当前画质：${LiveQualityExt.fromCode(GStorage.liveQuality)!.description}',
        onTap: (setState) async {
          int? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<int>(
                title: '直播默认画质',
                value: GStorage.liveQuality,
                values: LiveQuality.values
                    .map((e) => (e.code, e.description))
                    .toList(),
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
            '当前画质：${LiveQualityExt.fromCode(GStorage.liveQualityCellular)!.description}',
        onTap: (setState) async {
          int? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<int>(
                title: '直播默认画质',
                value: GStorage.liveQualityCellular,
                values: LiveQuality.values.map((e) {
                  return (e.code, e.description);
                }).toList(),
              );
            },
          );
          if (result != null) {
            await GStorage.setting
                .put(SettingBoxKey.liveQualityCellular, result);
            setState();
          }
        },
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '首选解码格式',
        leading: const Icon(Icons.movie_creation_outlined),
        getSubtitle: () =>
            '首选解码格式：${VideoDecodeFormatTypeExt.fromCode(GStorage.defaultDecode)!.description}，请根据设备支持情况与需求调整',
        onTap: (setState) async {
          String? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<String>(
                  title: '默认解码格式',
                  value: GStorage.defaultDecode,
                  values: VideoDecodeFormatType.values
                      .map((e) => (e.code, e.description))
                      .toList());
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
            '非杜比视频次选：${VideoDecodeFormatTypeExt.fromCode(GStorage.secondDecode)!.description}，仍无则选择首个提供的解码格式',
        leading: const Icon(Icons.swap_horizontal_circle_outlined),
        onTap: (setState) async {
          String? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<String>(
                  title: '次选解码格式',
                  value: GStorage.secondDecode,
                  values: VideoDecodeFormatType.values.map((e) {
                    return (e.code, e.description);
                  }).toList());
            },
          );
          if (result != null) {
            await GStorage.setting.put(SettingBoxKey.secondDecode, result);
            setState();
          }
        },
      ),
      if (Platform.isAndroid)
        SettingsModel(
          settingsType: SettingsType.sw1tch,
          title: '优先使用 OpenSL ES 输出音频',
          leading: const Icon(Icons.speaker_outlined),
          subtitle:
              '关闭则优先使用AudioTrack输出音频（此项即mpv的--ao），若遇系统音效丢失、无声、音画不同步等问题请尝试关闭。',
          setKey: SettingBoxKey.useOpenSLES,
          defaultVal: true,
        ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '扩大缓冲区',
        leading: const Icon(Icons.storage_outlined),
        subtitle: '默认缓冲区为视频4MB/直播16MB，开启后为32MB/64MB，加载时间变长',
        setKey: SettingBoxKey.expandBuffer,
        defaultVal: false,
      ),
      //video-sync
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '视频同步',
        leading: const Icon(Icons.view_timeline_outlined),
        getSubtitle: () => '当前：${GStorage.videoSync}（此项即mpv的--video-sync）',
        onTap: (setState) async {
          String? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<String>(
                  title: '视频同步',
                  value: GStorage.videoSync,
                  values: [
                    'audio',
                    'display-resample',
                    'display-resample-vdrop',
                    'display-resample-desync',
                    'display-tempo',
                    'display-vdrop',
                    'display-adrop',
                    'display-desync',
                    'desync'
                  ].map((e) {
                    return (e, e);
                  }).toList());
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
        getSubtitle: () => '当前：${GStorage.hardwareDecoding}（此项即mpv的--hwdec）',
        onTap: (setState) async {
          String? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<String>(
                  title: '硬解模式',
                  value: GStorage.hardwareDecoding,
                  values:
                      ['auto', 'auto-copy', 'auto-safe', 'no', 'yes'].map((e) {
                    return (e, e);
                  }).toList());
            },
          );
          if (result != null) {
            await GStorage.setting.put(SettingBoxKey.hardwareDecoding, result);
            setState();
          }
        },
      ),
    ];

List<SettingsModel> get recommendSettings => [
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '首页使用app端推荐',
        subtitle: '若web端推荐不太符合预期，可尝试切换至app端推荐',
        leading: const Icon(Icons.model_training_outlined),
        setKey: SettingBoxKey.appRcmd,
        defaultVal: true,
        needReboot: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '推荐动态',
        subtitle: '是否在推荐内容中展示动态(仅app端)',
        leading: const Icon(Icons.motion_photos_on_outlined),
        setKey: SettingBoxKey.enableRcmdDynamic,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '保留首页推荐刷新',
        subtitle: '下拉刷新时保留上次内容',
        leading: const Icon(Icons.refresh),
        setKey: SettingBoxKey.enableSaveLastData,
        defaultVal: false,
        onChanged: (value) {
          try {
            Get.find<RcmdController>().enableSaveLastData = value;
          } catch (e) {
            debugPrint('$e');
          }
        },
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '显示上次看到位置提示',
        subtitle: '保留上次推荐时，在上次刷新位置显示提示',
        leading: const Icon(Icons.tips_and_updates_outlined),
        setKey: SettingBoxKey.savedRcmdTip,
        defaultVal: true,
        onChanged: (value) {
          try {
            RcmdController ctr = Get.find<RcmdController>()
              ..savedRcmdTip = value;
            if (value.not) {
              ctr.lastRefreshAt = null;
            }
          } catch (e) {
            debugPrint('$e');
          }
        },
      ),
      SettingsModel(settingsType: SettingsType.divider),
      _getVideoFilterSelectModel(
        context: Get.context!,
        title: '点赞率',
        suffix: '%',
        key: SettingBoxKey.minLikeRatioForRecommend,
        values: [0, 1, 2, 3, 4],
      ),
      _getBanwordModel(
        context: Get.context!,
        title: '标题关键词过滤',
        key: SettingBoxKey.banWordForRecommend,
        callback: (value) {
          RecommendFilter.rcmdRegExp = value;
        },
      ),
      _getBanwordModel(
        context: Get.context!,
        title: 'App推荐/热门/排行榜: 视频分区关键词过滤',
        key: SettingBoxKey.banWordForZone,
        callback: (value) {
          VideoHttp.zoneRegExp = value;
        },
      ),
      _getVideoFilterSelectModel(
        context: Get.context!,
        title: '视频时长',
        suffix: 's',
        key: SettingBoxKey.minDurationForRcmd,
        values: [0, 30, 60, 90, 120],
      ),
      _getVideoFilterSelectModel(
        context: Get.context!,
        title: '播放量',
        key: SettingBoxKey.minPlayForRcmd,
        values: [0, 50, 100, 500, 1000],
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '已关注UP豁免推荐过滤',
        subtitle: '推荐中已关注用户发布的内容不会被过滤',
        leading: const Icon(Icons.favorite_border_outlined),
        setKey: SettingBoxKey.exemptFilterForFollowed,
        defaultVal: true,
        onChanged: (value) {
          RecommendFilter.exemptFilterForFollowed = value;
        },
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '过滤器也应用于相关视频',
        subtitle: '视频详情页的相关视频也进行过滤¹',
        leading: const Icon(Icons.explore_outlined),
        setKey: SettingBoxKey.applyFilterToRelatedVideos,
        defaultVal: true,
        onChanged: (value) {
          RecommendFilter.applyFilterToRelatedVideos = value;
        },
      ),
    ];

List<SettingsModel> get privacySettings => [
      SettingsModel(
        settingsType: SettingsType.normal,
        onTap: (setState) {
          if (Accounts.main.isLogin.not) {
            SmartDialog.showToast('登录后查看');
            return;
          }
          Get.toNamed('/blackListPage');
        },
        title: '黑名单管理',
        subtitle: '已拉黑用户',
        leading: const Icon(Icons.block),
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        onTap: (setState) {
          MineController.onChangeAnonymity(Get.context!);
          setState();
        },
        leading: const Icon(Icons.privacy_tip_outlined),
        getTitle: () => MineController.anonymity.value ? '退出无痕模式' : '进入无痕模式',
        getSubtitle: () => MineController.anonymity.value
            ? '已进入无痕模式，搜索、观看视频/直播不携带Cookie与CSRF，其余操作不受影响'
            : '未开启无痕模式，将使用账户信息提供完整服务',
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        onTap: (setState) {
          showDialog(
            context: Get.context!,
            builder: (context) {
              return AlertDialog(
                title: const Text('查看详情'),
                content: SingleChildScrollView(
                  child: Text(
                    AccountManager.apiTypeSet[AccountType.heartbeat]!
                        .join('\n'),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: Get.back,
                    child: const Text('确认'),
                  )
                ],
              );
            },
          );
        },
        leading: const Icon(Icons.flag_outlined),
        title: '了解无痕模式',
        subtitle: '查看无痕模式作用的API列表',
      ),
    ];

List<SettingsModel> get extraSettings => [
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '空降助手',
        subtitle: '点击配置',
        setKey: SettingBoxKey.enableSponsorBlock,
        defaultVal: false,
        onTap: () => Get.toNamed('/sponsorBlock'),
        leading: const Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Icon(Icons.shield_outlined),
            Icon(Icons.play_arrow_rounded, size: 15),
          ],
        ),
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '检查未读动态',
        subtitle: '点击设置检查周期(min)',
        leading: const Icon(Icons.notifications_none),
        setKey: SettingBoxKey.checkDynamic,
        defaultVal: true,
        onChanged: (value) {
          Get.find<MainController>().checkDynamic = value;
        },
        onTap: () {
          int dynamicPeriod = GStorage.dynamicPeriod;
          showDialog(
            context: Get.context!,
            builder: (context) {
              return AlertDialog(
                title: const Text('检查周期'),
                content: TextFormField(
                  autofocus: true,
                  initialValue: dynamicPeriod.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    dynamicPeriod = int.tryParse(value) ?? 5;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                  ],
                  decoration: const InputDecoration(suffixText: 'min'),
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
                      GStorage.setting
                          .put(SettingBoxKey.dynamicPeriod, dynamicPeriod);
                      Get.find<MainController>().dynamicPeriod = dynamicPeriod;
                    },
                    child: const Text('确定'),
                  )
                ],
              );
            },
          );
        },
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '显示视频分段信息',
        leading: Transform.rotate(
          angle: pi / 2,
          child: const Icon(MdiIcons.viewHeadline),
        ),
        setKey: SettingBoxKey.showViewPoints,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '视频页显示相关视频',
        leading: const Icon(MdiIcons.motionPlayOutline),
        setKey: SettingBoxKey.showRelatedVideo,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '显示视频评论',
        leading: const Icon(MdiIcons.commentTextOutline),
        setKey: SettingBoxKey.showVideoReply,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '显示番剧评论',
        leading: const Icon(MdiIcons.commentTextOutline),
        setKey: SettingBoxKey.showBangumiReply,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '默认展开视频简介',
        leading: const Icon(Icons.expand_more),
        setKey: SettingBoxKey.alwaysExapndIntroPanel,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '横屏自动展开视频简介',
        leading: const Icon(Icons.expand_more),
        setKey: SettingBoxKey.exapndIntroPanelH,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '横屏分P/合集列表显示在Tab栏',
        leading: const Icon(Icons.format_list_numbered_rtl_sharp),
        setKey: SettingBoxKey.horizontalSeasonPanel,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '横屏播放页在侧栏打开UP主页',
        leading: const Icon(Icons.account_circle_outlined),
        setKey: SettingBoxKey.horizontalMemberPage,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '评论折叠行数',
        subtitle: '0行为不折叠',
        leading: const Icon(Icons.compress),
        setKey: SettingBoxKey.replyLengthLimit,
        getTrailing: () => Text(
          '${GlobalData().replyLengthLimit}行',
          style: Theme.of(Get.context!).textTheme.titleSmall,
        ),
        onTap: (setState) {
          String replyLengthLimit = GlobalData().replyLengthLimit.toString();
          showDialog(
            context: Get.context!,
            builder: (context) {
              return AlertDialog(
                title: const Text('评论折叠行数'),
                content: TextFormField(
                  autofocus: true,
                  initialValue: replyLengthLimit,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    replyLengthLimit = value;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                  ],
                  decoration: const InputDecoration(suffixText: '行'),
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
                      GlobalData().replyLengthLimit =
                          int.tryParse(replyLengthLimit) ?? 6;
                      await GStorage.setting.put(
                        SettingBoxKey.replyLengthLimit,
                        GlobalData().replyLengthLimit,
                      );
                      setState();
                    },
                    child: const Text('确定'),
                  )
                ],
              );
            },
          );
        },
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '弹幕行高',
        subtitle: '默认1.6',
        setKey: SettingBoxKey.danmakuLineHeight,
        leading: const Icon(Icons.subtitles_outlined),
        getTrailing: () => Text(
          GStorage.danmakuLineHeight.toString(),
          style: Theme.of(Get.context!).textTheme.titleSmall,
        ),
        onTap: (setState) {
          String danmakuLineHeight = GStorage.danmakuLineHeight.toString();
          showDialog(
            context: Get.context!,
            builder: (context) {
              return AlertDialog(
                title: const Text('弹幕行高'),
                content: TextFormField(
                  autofocus: true,
                  initialValue: danmakuLineHeight,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    danmakuLineHeight = value;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d\.]+')),
                  ],
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
                        SettingBoxKey.danmakuLineHeight,
                        max(
                          1.0,
                          double.tryParse(danmakuLineHeight)?.toPrecision(1) ??
                              1.6,
                        ),
                      );
                      setState();
                    },
                    child: const Text('确定'),
                  )
                ],
              );
            },
          );
        },
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '显示视频警告/争议信息',
        leading: const Icon(Icons.warning_amber_rounded),
        setKey: SettingBoxKey.showArgueMsg,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '分P/合集：倒序播放从首集开始播放',
        subtitle: '开启则自动切换为倒序首集，否则保持当前集',
        leading: const Icon(MdiIcons.sort),
        setKey: SettingBoxKey.reverseFromFirst,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '禁用 SSL 证书验证',
        subtitle: '谨慎开启，禁用容易受到中间人攻击',
        leading: const Icon(Icons.security),
        needReboot: true,
        setKey: SettingBoxKey.badCertificateCallback,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '显示继续播放分P提示',
        leading: const Icon(Icons.local_parking),
        setKey: SettingBoxKey.continuePlayingPart,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '横屏在侧栏打开图片预览',
        leading: const Icon(Icons.photo_outlined),
        setKey: SettingBoxKey.horizontalPreview,
        defaultVal: false,
      ),
      _getBanwordModel(
        context: Get.context!,
        title: '评论关键词过滤',
        key: SettingBoxKey.banWordForReply,
        callback: (value) {
          ReplyHttp.replyRegExp = value;
        },
      ),
      _getBanwordModel(
        context: Get.context!,
        title: '动态关键词过滤',
        key: SettingBoxKey.banWordForDyn,
        callback: (value) {
          DynamicsHttp.banWordForDyn = value;
        },
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '使用外部浏览器打开链接',
        leading: const Icon(Icons.open_in_browser),
        setKey: SettingBoxKey.openInBrowser,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '刷新滑动距离',
        leading: const Icon(Icons.refresh),
        setKey: SettingBoxKey.refreshDragPercentage,
        getSubtitle: () => '当前滑动距离: ${GStorage.refreshDragPercentage}x',
        onTap: (setState) async {
          double? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SlideDialog(
                title: '刷新滑动距离',
                min: 0.1,
                max: 0.5,
                divisions: 8,
                precise: 2,
                value: GStorage.refreshDragPercentage,
                suffix: 'x',
              );
            },
          );
          if (result != null) {
            kDragContainerExtentPercentage = result;
            await GStorage.setting
                .put(SettingBoxKey.refreshDragPercentage, result);
            Get.forceAppUpdate();
            setState();
          }
        },
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '刷新指示器高度',
        leading: const Icon(Icons.height),
        setKey: SettingBoxKey.refreshDisplacement,
        getSubtitle: () => '当前指示器高度: ${GStorage.refreshDisplacement}',
        onTap: (setState) async {
          double? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SlideDialog(
                title: '刷新指示器高度',
                min: 10.0,
                max: 100.0,
                divisions: 9,
                value: GStorage.refreshDisplacement,
              );
            },
          );
          if (result != null) {
            displacement = result;
            await GStorage.setting
                .put(SettingBoxKey.refreshDisplacement, result);
            Get.forceAppUpdate();
            setState();
          }
        },
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '显示会员彩色弹幕',
        leading: const Icon(MdiIcons.gradientHorizontal),
        setKey: SettingBoxKey.showVipDanmaku,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '显示高级弹幕',
        leading: const Icon(MdiIcons.paletteAdvanced),
        setKey: SettingBoxKey.showSpecialDanmaku,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '合并弹幕',
        subtitle: '合并一段时间内获取到的相同弹幕',
        leading: const Icon(Icons.merge),
        setKey: SettingBoxKey.mergeDanmaku,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '显示热门推荐',
        subtitle: '热门页面显示每周必看等推荐内容入口',
        leading: const Icon(Icons.local_fire_department_outlined),
        setKey: SettingBoxKey.showHotRcmd,
        defaultVal: false,
        onChanged: (value) {
          try {
            Get.find<HotController>().showHotRcmd.value = value;
          } catch (_) {}
        },
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '音量均衡',
        setKey: SettingBoxKey.audioNormalization,
        leading: const Icon(Icons.multitrack_audio),
        getSubtitle: () {
          String audioNormalization = GStorage.audioNormalization;
          audioNormalization = switch (audioNormalization) {
            '0' => AudioNormalization.disable.title,
            '1' => AudioNormalization.dynaudnorm.title,
            '2' => AudioNormalization.loudnorm.title,
            _ => audioNormalization,
          };
          return '当前:「$audioNormalization」';
        },
        onTap: (setState) async {
          String? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              String audioNormalization = GStorage.audioNormalization;
              Set<String> values = {'0', '1', '2', audioNormalization, '3'};
              return SelectDialog<String>(
                  title: '音量均衡',
                  value: audioNormalization,
                  values: values
                      .map((e) => (
                            e,
                            switch (e) {
                              '0' => AudioNormalization.disable.title,
                              '1' => AudioNormalization.dynaudnorm.title,
                              '2' => AudioNormalization.loudnorm.title,
                              '3' => AudioNormalization.custom.title,
                              _ => e,
                            }
                          ))
                      .toList());
            },
          );
          if (result != null) {
            if (result == '3') {
              String param = '';
              showDialog(
                  context: Get.context!,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('自定义参数'),
                      content: TextField(
                        autofocus: true,
                        onChanged: (value) => param = value,
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
                            await GStorage.setting
                                .put(SettingBoxKey.audioNormalization, param);
                            setState();
                          },
                          child: const Text('确定'),
                        ),
                      ],
                    );
                  });
            } else {
              await GStorage.setting
                  .put(SettingBoxKey.audioNormalization, result);
              setState();
            }
          }
        },
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '超分辨率',
        leading: const Icon(Icons.stay_current_landscape_outlined),
        getSubtitle: () =>
            '当前:「${SuperResolutionType.values[GStorage.superResolutionType].title}」\n默认设置对番剧生效, 其他视频默认关闭\n超分辨率需要启用硬件解码, 若启用硬件解码后仍然不生效, 尝试切换硬件解码器为 auto-copy',
        onTap: (setState) async {
          SuperResolutionType? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<SuperResolutionType>(
                  title: '超分辨率',
                  value:
                      SuperResolutionType.values[GStorage.superResolutionType],
                  values: SuperResolutionType.values.map((e) {
                    return (e, e.title);
                  }).toList());
            },
          );
          if (result != null) {
            await GStorage.setting
                .put(SettingBoxKey.superResolutionType, result.index);
            setState();
          }
        },
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '提前初始化播放器',
        subtitle: '相对减少手动播放加载时间',
        leading: const Icon(Icons.play_circle_outlined),
        setKey: SettingBoxKey.preInitPlayer,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '首页切换页面动画',
        leading: const Icon(Icons.home_outlined),
        setKey: SettingBoxKey.mainTabBarView,
        defaultVal: false,
        needReboot: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '搜索建议',
        leading: const Icon(Icons.search),
        setKey: SettingBoxKey.searchSuggestion,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '记录搜索历史',
        leading: const Icon(Icons.history),
        setKey: SettingBoxKey.recordSearchHistory,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '展示头像/评论/动态装饰',
        leading: const Icon(MdiIcons.stickerCircleOutline),
        setKey: SettingBoxKey.showDynDecorate,
        defaultVal: true,
        onChanged: (value) => PendantAvatar.showDynDecorate = value,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '预览 Live Photo',
        subtitle: '开启则以视频形式预览 Live Photo，否则预览静态图片',
        leading: const Icon(Icons.image_outlined),
        setKey: SettingBoxKey.enableLivePhoto,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '滑动跳转预览视频缩略图',
        leading: const Icon(Icons.preview_outlined),
        setKey: SettingBoxKey.showSeekPreview,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '显示高能进度条',
        subtitle: '高能进度条反应了在时域上，单位时间内弹幕发送量的变化趋势',
        leading: const Icon(Icons.show_chart),
        setKey: SettingBoxKey.showDmChart,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '发评反诈',
        subtitle: '发送评论后检查评论是否可见',
        leading: const Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Icon(Icons.shield_outlined),
            Icon(Icons.reply, size: 14),
          ],
        ),
        setKey: SettingBoxKey.enableCommAntifraud,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '使用「哔哩发评反诈」检查评论',
        subtitle: '仅对Android生效',
        leading: const Icon(
          FontAwesomeIcons.b,
          size: 22,
        ),
        setKey: SettingBoxKey.biliSendCommAntifraud,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '发布/转发动态反诈',
        subtitle: '发布/转发动态后检查动态是否可见',
        leading: const Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Icon(Icons.shield_outlined),
            Icon(Icons.motion_photos_on, size: 12),
          ],
        ),
        setKey: SettingBoxKey.enableCreateDynAntifraud,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '屏蔽带货动态',
        leading: const Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 14),
            Icon(Icons.not_interested),
          ],
        ),
        setKey: SettingBoxKey.antiGoodsDyn,
        defaultVal: false,
        onChanged: (value) {
          GStorage.antiGoodsDyn = value;
        },
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '屏蔽带货评论',
        leading: const Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 14),
            Icon(Icons.not_interested),
          ],
        ),
        setKey: SettingBoxKey.antiGoodsReply,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '侧滑关闭二级评论页面',
        leading: Transform.rotate(
          angle: pi * 1.5,
          child: const Icon(Icons.touch_app),
        ),
        setKey: SettingBoxKey.slideDismissReplyPage,
        defaultVal: Platform.isIOS,
        onChanged: (value) {
          GStorage.slideDismissReplyPage = value;
        },
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '全屏展示点赞/投币/收藏等操作按钮',
        leading: const Icon(MdiIcons.dotsHorizontalCircleOutline),
        setKey: SettingBoxKey.showFSActionItem,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '启用双指缩小视频',
        leading: const Icon(Icons.pinch),
        setKey: SettingBoxKey.enableShrinkVideoSize,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '动态/专栏详情页展示底部操作栏',
        leading: const Icon(Icons.more_horiz),
        setKey: SettingBoxKey.showDynActionBar,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '启用拖拽字幕调整底部边距',
        leading: const Icon(MdiIcons.dragVariant),
        setKey: SettingBoxKey.enableDragSubtitle,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '展示追番时间表',
        leading: const Icon(MdiIcons.chartTimelineVariantShimmer),
        setKey: SettingBoxKey.showPgcTimeline,
        defaultVal: true,
        needReboot: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        enableFeedback: true,
        setKey: SettingBoxKey.feedBackEnable,
        onChanged: (value) {
          enableFeedback = value;
          feedBack();
        },
        leading: const Icon(Icons.vibration_outlined),
        title: '震动反馈',
        subtitle: '请确定手机设置中已开启震动反馈',
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '大家都在搜',
        subtitle: '是否展示「大家都在搜」',
        leading: const Icon(Icons.data_thresholding_outlined),
        setKey: SettingBoxKey.enableHotKey,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '搜索发现',
        subtitle: '是否展示「搜索发现」',
        leading: const Icon(Icons.search_outlined),
        setKey: SettingBoxKey.enableSearchRcmd,
        defaultVal: true,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '搜索默认词',
        subtitle: '是否展示搜索框默认词',
        leading: const Icon(Icons.whatshot_outlined),
        setKey: SettingBoxKey.enableSearchWord,
        defaultVal: true,
        onChanged: (val) {
          Get.find<HomeController>().defaultSearch.value = '';
        },
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '快速收藏',
        subtitle: '点按收藏至默认，长按选择文件夹',
        leading: const Icon(Icons.bookmark_add_outlined),
        setKey: SettingBoxKey.enableQuickFav,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '评论区搜索关键词',
        subtitle: '展示评论区搜索关键词',
        leading: const Icon(Icons.search_outlined),
        setKey: SettingBoxKey.enableWordRe,
        defaultVal: false,
        onChanged: (value) {
          ReplyItemGrpc.enableWordRe = value;
        },
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '启用AI总结',
        subtitle: '视频详情页开启AI总结',
        leading: const Icon(Icons.engineering_outlined),
        setKey: SettingBoxKey.enableAi,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '消息页禁用"收到的赞"功能',
        subtitle: '禁止打开入口，降低网络社交依赖',
        leading: const Icon(Icons.beach_access_outlined),
        setKey: SettingBoxKey.disableLikeMsg,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '默认展示评论区',
        subtitle: '在视频详情页默认切换至评论区页（仅Tab型布局）',
        leading: const Icon(Icons.mode_comment_outlined),
        setKey: SettingBoxKey.defaultShowComment,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '启用HTTP/2',
        leading: const Icon(Icons.swap_horizontal_circle_outlined),
        setKey: SettingBoxKey.enableHttp2,
        defaultVal: false,
        needReboot: true,
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '连接重试次数',
        subtitle: '为0时禁用',
        leading: const Icon(Icons.repeat),
        onTap: (setState) async {
          final result = await showDialog<double>(
            context: Get.context!,
            builder: (context) {
              return SlideDialog(
                title: '连接重试次数',
                min: 0,
                max: 8,
                divisions: 8,
                precise: 0,
                value: GStorage.retryCount.toDouble(),
              );
            },
          );
          if (result != null) {
            await GStorage.setting
                .put(SettingBoxKey.retryCount, result.toInt());
            setState();
            SmartDialog.showToast('重启生效');
          }
        },
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '连接重试间隔',
        subtitle: '实际间隔 = 间隔 * 第x次重试',
        leading: const Icon(Icons.more_time_outlined),
        onTap: (setState) async {
          final result = await showDialog<double>(
            context: Get.context!,
            builder: (context) {
              return SlideDialog(
                title: '连接重试间隔',
                min: 0,
                max: 1000,
                divisions: 10,
                precise: 0,
                value: GStorage.retryDelay.toDouble(),
                suffix: 'ms',
              );
            },
          );
          if (result != null) {
            await GStorage.setting
                .put(SettingBoxKey.retryDelay, result.toInt());
            setState();
            SmartDialog.showToast('重启生效');
          }
        },
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '评论展示',
        setKey: SettingBoxKey.replySortType,
        leading: const Icon(Icons.whatshot_outlined),
        getSubtitle: () =>
            '当前优先展示「${ReplySortType.values[GStorage.defaultReplySort].title}」',
        onTap: (setState) async {
          int? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<int>(
                title: '评论展示',
                value: GStorage.defaultReplySort,
                values: ReplySortType.values.map((e) {
                  return (e.index, e.title);
                }).toList(),
              );
            },
          );
          if (result != null) {
            await GStorage.setting.put(SettingBoxKey.replySortType, result);
            setState();
          }
        },
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '动态展示',
        setKey: SettingBoxKey.defaultDynamicType,
        leading: const Icon(Icons.dynamic_feed_outlined),
        getSubtitle: () =>
            '当前优先展示「${DynamicsTabType.values[GStorage.defaultDynamicType].labels}」',
        onTap: (setState) async {
          int? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<int>(
                  title: '动态展示',
                  value: GStorage.defaultDynamicType,
                  values: DynamicsTabType.values.sublist(0, 4).map((e) {
                    return (e.index, e.labels);
                  }).toList());
            },
          );
          if (result != null) {
            await GStorage.setting
                .put(SettingBoxKey.defaultDynamicType, result);
            setState();
          }
        },
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '用户页默认展示TAB',
        setKey: SettingBoxKey.memberTab,
        leading: const Icon(Icons.tab),
        getSubtitle: () => '当前优先展示「${GStorage.memberTab.title}」',
        onTap: (setState) async {
          MemberTabType? result = await showDialog(
            context: Get.context!,
            builder: (context) {
              return SelectDialog<MemberTabType>(
                  title: '用户页默认展示TAB',
                  value: GStorage.memberTab,
                  values: MemberTabType.values.map((e) {
                    return (e, e.title);
                  }).toList());
            },
          );
          if (result != null) {
            await GStorage.setting.put(SettingBoxKey.memberTab, result.index);
            setState();
          }
        },
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        onTap: () {
          String systemProxyHost = GStorage.defaultSystemProxyHost;
          String systemProxyPort = GStorage.defaultSystemProxyPort;

          showDialog(
            context: Get.context!,
            builder: (context) {
              return AlertDialog(
                title: const Text('设置代理'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 6),
                    TextField(
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: systemProxyHost != ''
                            ? systemProxyHost
                            : '请输入Host，使用 . 分割',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        hintText: systemProxyHost,
                      ),
                      onChanged: (e) {
                        systemProxyHost = e;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText:
                            systemProxyPort != '' ? systemProxyPort : '请输入Port',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        hintText: systemProxyPort,
                      ),
                      onChanged: (e) {
                        systemProxyPort = e;
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: Get.back,
                    child: Text(
                      '取消',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                      GStorage.setting
                          .put(SettingBoxKey.systemProxyHost, systemProxyHost);
                      GStorage.setting
                          .put(SettingBoxKey.systemProxyPort, systemProxyPort);
                    },
                    child: const Text('确认'),
                  )
                ],
              );
            },
          );
        },
        leading: const Icon(Icons.airplane_ticket_outlined),
        title: '设置代理',
        subtitle: '设置代理 host:port',
        setKey: SettingBoxKey.enableSystemProxy,
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '自动清除缓存',
        subtitle: '每次启动时清除缓存',
        leading: const Icon(Icons.auto_delete_outlined),
        setKey: SettingBoxKey.autoClearCache,
        defaultVal: false,
      ),
      SettingsModel(
        settingsType: SettingsType.normal,
        title: '最大缓存大小',
        getSubtitle: () {
          final num = GStorage.maxCacheSize;
          return '当前最大缓存大小: 「${num == 0 ? '无限' : CacheManage.formatSize(GStorage.maxCacheSize)}」';
        },
        onTap: (setState) {
          showDialog(
            context: Get.context!,
            builder: (context) {
              String valueStr = '';
              return AlertDialog(
                title: const Text('最大缓存大小'),
                content: TextField(
                  autofocus: true,
                  onChanged: (value) => valueStr = value,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d\.]+')),
                  ],
                  decoration: const InputDecoration(suffixText: 'MB'),
                ),
                actions: [
                  TextButton(
                    onPressed: Get.back,
                    child: Text(
                      '取消',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Get.back();
                      num value = num.tryParse(valueStr) ?? 0;
                      await GStorage.setting
                          .put(SettingBoxKey.maxCacheSize, value * 1024 * 1024);
                      setState();
                    },
                    child: const Text('确定'),
                  ),
                ],
              );
            },
          );
        },
        leading: const Icon(Icons.delete_outlined),
      ),
      SettingsModel(
        settingsType: SettingsType.sw1tch,
        title: '检查更新',
        subtitle: '每次启动时检查是否需要更新',
        leading: const Icon(Icons.system_update_alt_outlined),
        setKey: SettingBoxKey.autoUpdate,
        defaultVal: true,
        onChanged: (val) {
          if (val) {
            Utils.checkUpdate(false);
          }
        },
      ),
    ];

SettingsModel _getBanwordModel(
    {required BuildContext context,
    required String title,
    required String key,
    required ValueChanged<RegExp> callback}) {
  String banWord = GStorage.setting.get(key, defaultValue: '');
  return SettingsModel(
    settingsType: SettingsType.normal,
    leading: const Icon(Icons.filter_alt_outlined),
    title: title,
    getSubtitle: () => banWord.isEmpty ? "点击添加" : banWord,
    onTap: (setState) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('使用|隔开，如：尝试|测试'),
                TextFormField(
                  autofocus: true,
                  initialValue: banWord,
                  textInputAction: TextInputAction.newline,
                  minLines: 1,
                  maxLines: 4,
                  onChanged: (value) => banWord = value,
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: Get.back,
                child: Text(
                  '取消',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.outline),
                ),
              ),
              TextButton(
                child: const Text('保存'),
                onPressed: () async {
                  Get.back();
                  await GStorage.setting.put(key, banWord);
                  setState();
                  callback(RegExp(banWord, caseSensitive: false));
                  SmartDialog.showToast('已保存');
                },
              ),
            ],
          );
        },
      );
    },
  );
}

SettingsModel _getVideoFilterSelectModel({
  required BuildContext context,
  required String title,
  String? subtitle,
  String? suffix,
  required String key,
  required List<int> values,
  int defaultValue = 0,
  bool isFilter = true,
}) {
  int value = GStorage.setting.get(key, defaultValue: defaultValue);
  return SettingsModel(
    settingsType: SettingsType.normal,
    title: '$title${isFilter ? '过滤' : ''}',
    leading: const Icon(Icons.timelapse_outlined),
    subtitle: subtitle,
    getSubtitle: subtitle == null
        ? () => isFilter
            ? '过滤掉$title小于「$value${suffix ?? ""}」的视频'
            : '当前$title:「$value${suffix ?? ""}」'
        : null,
    onTap: (setState) async {
      var result = await showDialog<int>(
        context: context,
        builder: (context) {
          return SelectDialog<int>(
              title: '选择$title${isFilter ? '（0即不过滤）' : ''}',
              value: value,
              values: (values
                    ..addIf(!values.contains(value), value)
                    ..sort())
                  .map((e) => (e, suffix == null ? e.toString() : '$e $suffix'))
                  .toList()
                ..add((-1, '自定义')));
        },
      );
      if (result != null) {
        if (result == -1 && context.mounted) {
          await showDialog(
            context: context,
            builder: (context) {
              String valueStr = '';
              return AlertDialog(
                title: Text('自定义$title'),
                content: TextField(
                  autofocus: true,
                  onChanged: (value) => valueStr = value,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                  ],
                  decoration: InputDecoration(suffixText: suffix),
                ),
                actions: [
                  TextButton(
                    onPressed: Get.back,
                    child: Text(
                      '取消',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                      result = int.tryParse(valueStr) ?? 0;
                    },
                    child: const Text('确定'),
                  ),
                ],
              );
            },
          );
        }
        if (result != -1) {
          value = result!;
          await GStorage.setting.put(key, result);
          setState();
          if (isFilter) RecommendFilter.update();
        }
      }
    },
  );
}
