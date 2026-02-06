import 'dart:io' show Platform;

import 'package:PiliPlus/common/widgets/color_palette.dart';
import 'package:PiliPlus/main.dart' show MyApp;
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/models/common/theme/theme_color_type.dart';
import 'package:PiliPlus/models/common/theme/theme_type.dart';
import 'package:PiliPlus/pages/home/view.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/pages/setting/widgets/popup_item.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ColorSelectPage extends StatefulWidget {
  const ColorSelectPage({super.key});

  @override
  State<ColorSelectPage> createState() => _ColorSelectPageState();
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

class _ColorSelectPageState extends State<ColorSelectPage> {
  final ctr = Get.put(_ColorSelectController());
  FlexSchemeVariant _dynamicSchemeVariant = Pref.schemeVariant;

  Future<void> _onChanged([bool? val]) async {
    val ??= !ctr.dynamicColor.value;
    if (val) {
      if (await MyApp.initPlatformState()) {
        Get.forceAppUpdate();
      } else {
        SmartDialog.showToast('该设备可能不支持动态取色');
        return;
      }
    } else {
      Get.forceAppUpdate();
    }
    ctr
      ..dynamicColor.value = val
      ..setting.put(SettingBoxKey.dynamicColor, val);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TextStyle titleStyle = theme.textTheme.titleMedium!;
    TextStyle subTitleStyle = theme.textTheme.labelMedium!.copyWith(
      color: theme.colorScheme.outline,
    );
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.viewPaddingOf(
      context,
    ).copyWith(top: 0, bottom: 0);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('选择应用主题')),
      body: ListView(
        children: [
          ListTile(
            onTap: () async {
              final result = await showDialog<ThemeType>(
                context: context,
                builder: (context) => SelectDialog<ThemeType>(
                  title: '主题模式',
                  value: ctr.themeType.value,
                  values: ThemeType.values.map((e) => (e, e.desc)).toList(),
                ),
              );
              if (result != null) {
                try {
                  Get.find<MineController>().themeType.value = result;
                } catch (_) {}
                ctr.themeType.value = result;
                GStorage.setting.put(SettingBoxKey.themeMode, result.index);
                Get.changeThemeMode(result.toThemeMode);
              }
            },
            leading: const Icon(Icons.flashlight_on_outlined),
            title: Text('主题模式', style: titleStyle),
            subtitle: Obx(
              () => Text(
                '当前模式：${ctr.themeType.value.desc}',
                style: subTitleStyle,
              ),
            ),
          ),
          Obx(
            () => PopupListTile<FlexSchemeVariant>(
              enabled: !ctr.dynamicColor.value,
              leading: const Icon(Icons.palette_outlined),
              title: const Text('调色板风格'),
              value: () =>
                  (_dynamicSchemeVariant, _dynamicSchemeVariant.variantName),
              itemBuilder: (_) => FlexSchemeVariant.values
                  .map(
                    (e) => PopupMenuItem(value: e, child: Text(e.variantName)),
                  )
                  .toList(),
              onSelected: (value, setState) {
                _dynamicSchemeVariant = value;
                GStorage.setting.put(SettingBoxKey.schemeVariant, value.index);
                Get.forceAppUpdate();
              },
            ),
          ),
          if (!Platform.isIOS)
            Obx(
              () => ListTile(
                title: const Text('动态取色'),
                leading: ExcludeFocus(
                  child: Checkbox(
                    value: ctr.dynamicColor.value,
                    onChanged: _onChanged,
                    materialTapTargetSize: .shrinkWrap,
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                  ),
                ),
                onTap: _onChanged,
              ),
            ),
          Padding(
            padding: padding,
            child: AnimatedSize(
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              duration: const Duration(milliseconds: 200),
              child: Obx(
                () => ctr.dynamicColor.value
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.all(12),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 22,
                          runSpacing: 18,
                          children: colorThemeTypes.indexed.map(
                            (e) {
                              final index = e.$1;
                              final item = e.$2;
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  ctr
                                    ..currentColor.value = index
                                    ..setting.put(
                                      SettingBoxKey.customColor,
                                      index,
                                    );
                                  Get.forceAppUpdate();
                                },
                                child: Column(
                                  spacing: 3,
                                  children: [
                                    ColorPalette(
                                      colorScheme: item.color.asColorSchemeSeed(
                                        _dynamicSchemeVariant,
                                        theme.brightness,
                                      ),
                                      selected: ctr.currentColor.value == index,
                                    ),
                                    Text(
                                      item.label,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: ctr.currentColor.value != index
                                            ? theme.colorScheme.outline
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
              ),
            ),
          ),
          Padding(
            padding: padding,
            child: ExcludeFocus(
              child: IgnorePointer(
                child: Container(
                  height: size.height / 2,
                  width: size.width,
                  color: theme.colorScheme.surface,
                  child: const HomePage(),
                ),
              ),
            ),
          ),
          ExcludeFocus(
            child: IgnorePointer(
              child: NavigationBar(
                destinations: NavigationBarType.values
                    .map(
                      (item) => NavigationDestination(
                        icon: item.icon,
                        label: item.label,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorSelectController extends GetxController {
  final RxBool dynamicColor = Pref.dynamicColor.obs;
  final RxInt currentColor = Pref.customColor.obs;
  final Rx<ThemeType> themeType = Pref.themeType.obs;

  Box get setting => GStorage.setting;
}
