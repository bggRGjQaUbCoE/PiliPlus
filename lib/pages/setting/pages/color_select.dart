import 'dart:io' show Platform;

import 'package:PiliPlus/common/skeleton/video_card_h.dart';
import 'package:PiliPlus/common/skeleton/video_card_v.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/animated_height.dart';
import 'package:PiliPlus/common/widgets/color_palette.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/main.dart' show MyApp;
import 'package:PiliPlus/models/common/home_tab_type.dart';
import 'package:PiliPlus/models/common/nav_bar_config.dart';
import 'package:PiliPlus/models/common/theme/palette_registry.dart';
import 'package:PiliPlus/models/common/theme/palette_theme.dart';
import 'package:PiliPlus/models/common/theme/theme_type.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/pages/setting/slide_color_picker.dart';
import 'package:PiliPlus/pages/setting/widgets/popup_item.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:collection/collection.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

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

typedef _PaletteMenuValue = ({FlexSchemeVariant? variant, int paletteId});

class _ColorSelectPageState extends State<ColorSelectPage> {
  final ctr = Get.put(_ColorSelectController());

  Future<void> _onChanged([bool? val]) async {
    val ??= !ctr.dynamicColor.value;
    if (val && !await MyApp.initPlatformState()) {
      SmartDialog.showToast('设备可能不支持动态取色');
      if (kReleaseMode) {
        return;
      }
    }
    ctr.dynamicColor.value = val;
    await GStorage.setting.put(SettingBoxKey.dynamicColor, val);
    Get.updateMyAppTheme();
  }

  late ThemeData theme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = theme.textTheme.titleMedium!;
    final subTitleStyle = theme.textTheme.labelMedium!.copyWith(
      color: theme.colorScheme.outline,
    );
    final padding = MediaQuery.viewPaddingOf(
      context,
    ).copyWith(top: 0, bottom: 0);
    return SimpleScaffold(
      appBar: AppBar(title: const Text('选择应用主题')),
      body: ListView(
        padding: .only(
          bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
        ),
        children: [
          ListTile(
            onTap: () async {
              final result = await showDialog<ThemeType>(
                context: context,
                builder: (context) => SelectDialog<ThemeType>(
                  title: '主题模式',
                  value: ctr.themeType.value,
                  values: ThemeType.values.map((e) => (e, e.label)).toList(),
                ),
              );
              if (result != null) {
                try {
                  Get.find<MineController>().themeType.value = result;
                } catch (_) {}
                ctr.themeType.value = result;
                GStorage.setting.put(SettingBoxKey.themeMode, result.index);
                Get.changeThemeMode(ThemeUtils.themeMode = result.toThemeMode);
              }
            },
            leading: const Icon(Icons.flashlight_on_outlined),
            title: Text('主题模式', style: titleStyle),
            subtitle: Obx(
              () => Text(
                '当前模式：${ctr.themeType.value.label}',
                style: subTitleStyle,
              ),
            ),
          ),
          Obx(
            () => PopupListTile<_PaletteMenuValue>(
              enabled: !ctr.dynamicColor.value,
              leading: const Icon(Icons.palette_outlined),
              title: const Text('调色板风格'),
              value: () {
                final id = ctr.paletteId.value;
                if (id == PaletteRegistry.seedId) {
                  final variant = ctr.variant.value;
                  return (
                    (variant: variant, paletteId: id),
                    variant.variantName,
                  );
                }
                return (
                  (variant: null, paletteId: id),
                  PaletteRegistry.byId(id).label,
                );
              },
              itemBuilder: (_) => <PopupMenuEntry<_PaletteMenuValue>>[
                ...FlexSchemeVariant.values.map(
                  (e) => PopupMenuItem(
                    value: (variant: e, paletteId: PaletteRegistry.seedId),
                    child: Text(e.variantName),
                  ),
                ),
                ...PaletteRegistry.overlays.map(
                  (e) => PopupMenuItem(
                    value: (variant: null, paletteId: e.id),
                    child: Text(e.label),
                  ),
                ),
              ],
              onSelected: (value, setState) async {
                ctr.paletteId.value = value.paletteId;
                if (value.variant != null) {
                  ctr.variant.value = value.variant!;
                  await GStorage.setting.put(
                    SettingBoxKey.schemeVariant,
                    value.variant!.index,
                  );
                }
                ctr.paletteAccent.value = Pref.paletteAccent(value.paletteId);
                await GStorage.setting.put(
                  SettingBoxKey.paletteId,
                  value.paletteId,
                );
                Get.updateMyAppTheme();
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
                    visualDensity: const .new(horizontal: -4, vertical: -4),
                  ),
                ),
                onTap: _onChanged,
              ),
            ),
          Padding(
            padding: padding + const .all(12),
            child: Obx(_buildColorPanel),
          ),
          Padding(
            padding: padding,
            child: const _Preview(),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPanel() {
    final palette = PaletteRegistry.byId(ctr.paletteId.value);
    final accents = palette.accents;
    final brightness = theme.brightness;
    final variant = palette.id == PaletteRegistry.seedId
        ? ctr.variant.value
        : palette.variant;
    final current = palette.id == PaletteRegistry.seedId
        ? ctr.currentColor.value
        : ctr.paletteAccent.value;
    final isCustom = current < 0 || current >= accents.length;

    ColorPalette paletteOf(Color color, bool selected) => ColorPalette(
      colorScheme: buildPaletteScheme(palette, brightness, color, variant),
      selected: selected,
    );

    Future<void> save(int value) async {
      if (palette.id == PaletteRegistry.seedId) {
        ctr.currentColor.value = value;
        await GStorage.setting.put(SettingBoxKey.customColor, value);
      } else {
        ctr.paletteAccent.value = value;
        await GStorage.setting.put(
          '${SettingBoxKey.paletteAccent}.${palette.id}',
          value,
        );
      }
      Get.updateMyAppTheme();
    }

    return AnimatedHeightWidgetExt(
      expand: !ctr.dynamicColor.value,
      duration: const Duration(milliseconds: 200),
      child: Wrap(
        spacing: 22,
        runSpacing: 18,
        alignment: .center,
        children: [
          Builder(
            builder: (context) {
              final color = isCustom
                  ? Color(current)
                  : accents[current].colorOf(brightness);
              return GestureDetector(
                behavior: .opaque,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      clipBehavior: .hardEdge,
                      contentPadding: const .symmetric(vertical: 16),
                      title: const Text('Color Picker'),
                      content: SlideColorPicker(
                        color: color,
                        onChanged: (Color? color) {
                          if (color != null) {
                            save(color.toARGB32());
                          }
                        },
                      ),
                    ),
                  );
                },
                child: Column(
                  spacing: 3,
                  children: [
                    paletteOf(color, isCustom),
                    Text(
                      '自定义',
                      style: TextStyle(
                        fontSize: 12,
                        color: isCustom
                            ? null
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          ...accents.mapIndexed(
            (i, e) {
              final color = e.colorOf(brightness);
              final isCurr = !isCustom && current == i;
              return GestureDetector(
                behavior: .opaque,
                onTap: () => save(i),
                child: Column(
                  spacing: 3,
                  children: [
                    paletteOf(color, isCurr),
                    Text(
                      e.label,
                      style: TextStyle(
                        fontSize: 12,
                        color: isCurr ? null : theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              );
            },
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
  final RxInt paletteId = Pref.paletteId.obs;
  final RxInt paletteAccent = Pref.paletteAccent(Pref.paletteId).obs;
  final Rx<FlexSchemeVariant> variant = Pref.schemeVariant.obs;
}

class _Preview extends StatelessWidget {
  const _Preview();

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    const cardH = SizedBox(
      height: 110,
      child: VideoCardHSkeleton(skeleton: false),
    );
    const cardV = Expanded(
      child: SizedBox(
        height: 200,
        child: Card(child: VideoCardVSkeleton(skeleton: false)),
      ),
    );
    final child = Column(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const .fromLTRB(14, 8, 14, 0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const .all(.circular(25)),
                      color: colorScheme.onSecondaryContainer.withValues(
                        alpha: 0.05,
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        Icon(
                          Icons.search_outlined,
                          color: colorScheme.onSecondaryContainer,
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(
                  padding: .zero,
                  backgroundColor: colorScheme.onInverseSurface,
                ),
                onPressed: () {},
                icon: Icon(
                  Icons.person_rounded,
                  size: 22,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        DefaultTabController(
          initialIndex: 1,
          length: HomeTabType.values.length,
          child: SizedBox(
            height: 42,
            child: TabBar(
              dividerHeight: 0,
              tabs: HomeTabType.values.map((e) => Tab(text: e.label)).toList(),
            ),
          ),
        ),
        const Padding(
          padding: .symmetric(horizontal: Style.safeSpace, vertical: 5),
          child: Row(
            spacing: 8,
            children: [cardV, cardV],
          ),
        ),
        cardH,
        cardH,
        const SizedBox(height: 5),
        NavigationBar(
          destinations: NavigationBarType.values
              .map(
                (item) => NavigationDestination(
                  icon: item.icon,
                  label: item.label,
                ),
              )
              .toList(),
        ),
      ],
    );

    return ExcludeFocus(
      child: IgnorePointer(
        child: Center(
          child: ConstrainedBox(
            constraints: const .new(maxWidth: 380),
            child: child,
          ),
        ),
      ),
    );
  }
}
