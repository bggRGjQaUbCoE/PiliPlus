import 'dart:io';

import 'package:PiliPlus/common/widgets/flutter/popup_menu.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/models/common/danmaku/danmaku_font_sync_mode.dart';
import 'package:PiliPlus/utils/extension/box_ext.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/font_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

/// 弹幕字体来源（下拉内置项）；选择已导入字体时下拉值为该字体的池 key
enum DanmakuFontSource { global, system }

class FontSettingPage extends StatefulWidget {
  const FontSettingPage({super.key});

  @override
  State<FontSettingPage> createState() => _FontSettingPageState();
}

class _FontSettingPageState extends State<FontSettingPage> {
  /// 字体选择："系统默认" 用空串表示
  static const String _systemFontSentinel = '';

  /// 预览区在未选字体时使用的平台默认字体族
  ///
  /// ref [Typography._withPlatform]
  static final String? _kDefaultFontFamily = (switch (defaultTargetPlatform) {
    .iOS => Typography.whiteCupertino,
    .android || .fuchsia => Typography.whiteMountainView,
    .windows => Typography.whiteRedmond,
    .macOS => Typography.whiteRedwoodCity,
    .linux => Typography.whiteHelsinki,
  }).bodyMedium?.fontFamily;

  // ignore: deprecated_member_use
  static final _normalFontWeight = FontWeight.normal.index;

  String? _selectedFont = Pref.appFont;
  // ignore: deprecated_member_use
  int _selectedWeight = Pref.appFontWeight.index;
  double _selectedScale = Pref.defaultTextScale;

  /// 弹幕字体选择：DanmakuFontSource 或已导入字体的池 key
  Object? _selectedDanmaku = _initialDanmakuSelection();

  late final List<String> _fonts;
  late ColorScheme colorScheme;

  static Object? _initialDanmakuSelection() {
    if (!Pref.enableCustomDanmakuFont) {
      return DanmakuFontSource.system;
    }
    return switch (Pref.danmakuFontSyncMode) {
      DanmakuFontSyncMode.system => DanmakuFontSource.system,
      DanmakuFontSyncMode.custom =>
        Pref.customDanmakuFontFamily ?? DanmakuFontSource.global,
      _ => DanmakuFontSource.global,
    };
  }

  @override
  void initState() {
    super.initState();
    _fonts = FontUtils.getFont().toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorScheme = ColorScheme.of(context);
  }

  /// 应用字体菜单显示名：已导入字体显示族名，系统字体显示字体名
  String get _fontLabel {
    final font = _selectedFont;
    if (font == null) return '系统默认';
    return FontUtils.isCustomFont(font)
        ? FontUtils.displayName(font)
        : font;
  }

  /// 弹幕字体菜单显示名（跟随应用字体 / 系统默认弹幕字体 / 导入字体族名）
  String get _danmakuLabel => switch (_selectedDanmaku) {
    DanmakuFontSource.global => '跟随应用字体',
    DanmakuFontSource.system => '系统默认弹幕字体',
    String family => FontUtils.displayName(family),
    _ => '系统默认弹幕字体',
  };

  /// 弹幕字体实际生效的 fontFamily（跟随应用字体时取应用字体；系统默认为 null）
  String? get _danmakuFontFamily => switch (_selectedDanmaku) {
    DanmakuFontSource.global => _selectedFont,
    DanmakuFontSource.system => null,
    String family => family,
    _ => null,
  };

  void _saveFontSetting() {
    final (enable, mode, danmakuFamily) = switch (_selectedDanmaku) {
      DanmakuFontSource.global => (true, DanmakuFontSyncMode.global, null),
      String family => (true, DanmakuFontSyncMode.custom, family),
      _ => (false, DanmakuFontSyncMode.system, null),
    };

    GStorage.setting.putAllNE({
      SettingBoxKey.appFont: _selectedFont,
      SettingBoxKey.appFontWeightV2: _selectedWeight,
      SettingBoxKey.defaultTextScale: _selectedScale,
      SettingBoxKey.enableCustomDanmakuFont: enable,
      SettingBoxKey.danmakuFontSyncMode: mode.index,
      SettingBoxKey.customDanmakuFontFamily: danmakuFamily,
    });

    Get
      ..back()
      ..updateMyAppTheme();
  }

  /// 选中后再按需装载。必须先反馈选中态再装载：
  /// 直接 await 装载会让点击在装载完成前毫无反应，看起来像没点到。
  Future<void> _loadInBackground(String fontFamily) async {
    if (!FontUtils.isCustomFont(fontFamily)) return;
    await FontUtils.loadFontIfNecessary(fontFamily);
    if (mounted) setState(() {});
  }

  Future<void> _onFontSelected(String value) async {
    final fontFamily = value.isEmpty ? null : value;
    setState(() => _selectedFont = fontFamily);
    if (fontFamily != null) await _loadInBackground(fontFamily);
  }

  Future<void> _onDanmakuSelected(Object value) async {
    setState(() => _selectedDanmaku = value);
    if (value is String) await _loadInBackground(value);
  }

  /// 导入字体文件。应用字体与弹幕字体共用同一个导入池，
  /// 区别只是导入完成后把哪一项指向新字体。
  Future<void> _importFont({required bool forDanmaku}) async {
    // loading 由 pickFonts 在文件选择器返回后自行管理
    final font = await FontUtils.pickFonts();
    if (!mounted || font == null) return;
    setState(() {
      if (forDanmaku) {
        _selectedDanmaku = font;
      } else {
        _selectedFont = font;
      }
    });
    await _loadInBackground(font);
  }

  Future<void> _removeFont(String fontFamily) async {
    await FontUtils.removeFont(fontFamily);
    if (!mounted) return;
    setState(() {
      if (_selectedFont == fontFamily) {
        _selectedFont = null;
      }
      if (_selectedDanmaku == fontFamily) {
        _selectedDanmaku = DanmakuFontSource.global;
      }
    });
  }

  Future<void> _clearFonts() async {
    SmartDialog.showLoading();
    await FontUtils.clearFonts();
    SmartDialog.dismiss(status: SmartStatus.loading);
    if (!mounted) return;
    setState(() {
      // 选中的是系统字体时不受影响，只回收指向导入池的选择
      if (_selectedFont != null && !_fonts.contains(_selectedFont)) {
        _selectedFont = null;
      }
      if (_selectedDanmaku is String) {
        _selectedDanmaku = DanmakuFontSource.global;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final customFonts = FontUtils.customFonts.keys.toList();
    return SimpleScaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => setState(() {
              _selectedFont = null;
              _selectedWeight = _normalFontWeight;
              _selectedScale = 1;
            }),
            child: const Text('重置'),
          ),
          TextButton(
            onPressed: _saveFontSetting,
            child: const Text('确定'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'abcdefghijklmnopqrstuvwxyz\n'
                      'ABCDEFGHIJKLMNOPQRSTUVWXYZ\n'
                      '1234567890.:,;\'"(!?)+-*/=\n'
                      '${Platform.isWindows
                          ? "中国智造，惠及全球"
                          : Platform.isMacOS || Platform.isIOS
                          ? "汉体书写信息技术标准相容"
                          : "我能吞下玻璃而不伤身体"}\n\n'
                      '注：部分字体可能无法应用',
                      style: TextStyle(
                        fontFamily: _selectedFont ?? _kDefaultFontFamily,
                        fontWeight: FontWeight.values[_selectedWeight],
                        fontSize: 14 * _selectedScale,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '弹幕预览：前方高能反应 666',
                      style: TextStyle(
                        fontFamily: _danmakuFontFamily ?? _kDefaultFontFamily,
                        fontSize: 14 * _selectedScale,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildItem(
              Row(
                children: [
                  const Text('字体：', style: TextStyle(fontWeight: .bold)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: StaticPopupMenuButton<String>(
                      initialValue: _selectedFont ?? _systemFontSentinel,
                      borderRadius: BorderRadius.circular(8),
                      itemBuilder: (context) => [
                        if (customFonts.isNotEmpty) ...[
                          for (final font in customFonts)
                            _importedFontItem(font),
                          const CustomPopupMenuDivider(height: 8),
                        ],
                        const CustomPopupMenuItem<String>(
                          value: _systemFontSentinel,
                          height: 40,
                          child: Text('系统默认'),
                        ),
                        for (final font in _fonts)
                          CustomPopupMenuItem<String>(
                            value: font,
                            height: 40,
                            child: Text(
                              font,
                              style: TextStyle(fontFamily: font),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onSelected: _onFontSelected,
                      child: _selectorLabel(
                        text: _fontLabel,
                        fontFamily: _selectedFont,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  _actionIcon(
                    tooltip: '导入字体文件（TTF/OTF）',
                    icon: Icons.file_open_outlined,
                    onPressed: () => _importFont(forDanmaku: false),
                  ),
                  if (customFonts.isNotEmpty)
                    _actionIcon(
                      tooltip: '清空已导入字体',
                      icon: Icons.delete_sweep_outlined,
                      onPressed: _clearFonts,
                    ),
                ],
              ),
            ),
            _buildItem(
              Row(
                children: [
                  const Text('字重：', style: TextStyle(fontWeight: .bold)),
                  const SizedBox(
                    width: 40,
                    child: Text(
                      'w100',
                      style: TextStyle(fontWeight: .w100),
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      padding: .zero,
                      value: _selectedWeight.toDouble(),
                      min: 0,
                      max: 8,
                      divisions: 8,
                      secondaryTrackValue: _normalFontWeight.toDouble(),
                      label: 'w${(_selectedWeight + 1) * 100}',
                      onChanged: (value) {
                        setState(() => _selectedWeight = value.toInt());
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                    child: Align(
                      alignment: .centerRight,
                      child: Text('w900', style: TextStyle(fontWeight: .w900)),
                    ),
                  ),
                ],
              ),
            ),
            _buildItem(
              Row(
                children: [
                  const Text('字号：', style: TextStyle(fontWeight: .bold)),
                  const SizedBox(
                    width: 40,
                    child: Text('小', style: TextStyle(fontSize: 11.9)),
                  ),
                  Expanded(
                    child: Slider(
                      padding: .zero,
                      value: _selectedScale,
                      min: 0.85,
                      max: 1.6,
                      divisions: 15,
                      secondaryTrackValue: 1,
                      label: _selectedScale == 1.0
                          ? '默认'
                          : _selectedScale.toStringAsFixed(2),
                      onChanged: (value) =>
                          setState(() => _selectedScale = value.toPrecision(2)),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                    child: Align(
                      alignment: .centerRight,
                      child: Text('大', style: TextStyle(fontSize: 22.4)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                height: 1,
                thickness: 1,
                color: colorScheme.outlineVariant.withValues(alpha: 0.6),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.subtitles_outlined, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '弹幕字体',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: .bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            _buildItem(
              Row(
                children: [
                  const Text('弹幕：', style: TextStyle(fontWeight: .bold)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: StaticPopupMenuButton<Object>(
                      initialValue: _selectedDanmaku,
                      borderRadius: BorderRadius.circular(8),
                      itemBuilder: (context) => [
                        if (customFonts.isNotEmpty) ...[
                          for (final font in customFonts)
                            CustomPopupMenuItem<Object>(
                              value: font,
                              height: 40,
                              child: Text(
                                FontUtils.displayName(font),
                                style: TextStyle(fontFamily: font),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          const CustomPopupMenuDivider(height: 8),
                        ],
                        const CustomPopupMenuItem<Object>(
                          value: DanmakuFontSource.global,
                          height: 40,
                          child: Text('跟随应用字体'),
                        ),
                        const CustomPopupMenuItem<Object>(
                          value: DanmakuFontSource.system,
                          height: 40,
                          child: Text('系统默认弹幕字体'),
                        ),
                      ],
                      onSelected: _onDanmakuSelected,
                      child: _selectorLabel(text: _danmakuLabel),
                    ),
                  ),
                  const SizedBox(width: 4),
                  _actionIcon(
                    tooltip: '导入字体文件（TTF/OTF）',
                    icon: Icons.file_open_outlined,
                    onPressed: () => _importFont(forDanmaku: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 已导入字体条目，行尾带移除按钮
  PopupMenuEntry<String> _importedFontItem(String fontFamily) {
    return CustomPopupMenuItem<String>(
      value: fontFamily,
      height: 44,
      padding: const EdgeInsets.only(left: 12, right: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              FontUtils.displayName(fontFamily),
              style: TextStyle(fontFamily: fontFamily),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            tooltip: '移除',
            icon: const Icon(Icons.close, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
            onPressed: () {
              // 先关掉菜单本身，再改动列表
              if (Get.routing.route is! GetPageRoute) Get.back();
              _removeFont(fontFamily);
            },
          ),
        ],
      ),
    );
  }

  /// 当前选中字体的显示名（字体/弹幕共用）
  Widget _selectorLabel({required String text, String? fontFamily}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontFamily: fontFamily, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            Icons.arrow_drop_down,
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  /// 紧凑型操作按钮（导入/清空），40x40 命中区与列表行高匹配
  Widget _actionIcon({
    required String tooltip,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon, size: 20),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
      onPressed: onPressed,
    );
  }

  Widget _buildItem(Widget child) {
    return Container(
      padding: const .symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.primary.withValues(alpha: 0.3)),
        ),
      ),
      child: child,
    );
  }
}
