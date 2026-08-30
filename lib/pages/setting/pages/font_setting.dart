import 'dart:io';
import 'dart:typed_data';

import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/utils/extension/box_ext.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/extension/size_ext.dart';
import 'package:PiliPlus/utils/font_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class FontSettingPage extends StatefulWidget {
  const FontSettingPage({super.key});

  @override
  State<FontSettingPage> createState() => _FontSettingPageState();
}

class _FontSettingPageState extends State<FontSettingPage> {
  AppFont _appFont = FontUtils.appFont;
  String? get _selectedFont => _appFont.fontFamily;

  // ignore: deprecated_member_use
  static final _normalFontWeight = FontWeight.normal.index;

  // ignore: deprecated_member_use
  int _selectedWeight = Pref.appFontWeight.index;
  double _selectedScale = Pref.defaultTextScale;

  final Map<String, Uint8List> _customFonts = {};

  late final List<String> _fonts;
  late ColorScheme colorScheme;
  late bool isPortrait;
  late ScrollController scrollController;

  static const double _tileHeight = 45.0;

  @override
  void initState() {
    super.initState();
    _fonts = FontUtils.getFont().toList();

    if (_selectedFont != null && !_appFont.isCustom) {
      final index = _fonts.indexWhere((e) => e == _selectedFont);
      if (index != -1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.jumpTo(index * _tileHeight);
          }
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorScheme = ColorScheme.of(context);
    isPortrait = MediaQuery.sizeOf(context).isPortrait;
    scrollController = PrimaryScrollController.of(context);
  }

  Future<void> _saveFontSetting() async {
    if (_appFont != FontUtils.appFont) {
      if (_appFont.isCustom) {
        final bytes = _customFonts[_selectedFont];
        assert(bytes != null);
        FontUtils.fontFile.writeAsBytes(bytes!);
      } else {
        FontUtils.removeFontIfExists();
      }
      FontUtils.appFont = _appFont;
    }

    await GStorage.setting.putAllNE({
      SettingBoxKey.appFont: _selectedFont,
      SettingBoxKey.appFontWeightV2: _selectedWeight,
      SettingBoxKey.defaultTextScale: _selectedScale,
    });

    Get
      ..back()
      ..updateMyAppTheme();
  }

  @override
  void dispose() {
    super.dispose();
    if (_customFonts.isNotEmpty) {
      _customFonts.clear();
    }
  }

  void _onFontChanged(String? value, {bool isCustom = false}) {
    if (_selectedFont == value) return;
    _appFont = (fontFamily: value, isCustom: isCustom);
    setState(() {});
  }

  Color? _tileColor(String? value) {
    if (value == _selectedFont) {
      return colorScheme.onInverseSurface;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Widget? customFonts;
    if (_customFonts.isNotEmpty) {
      final fonts = _customFonts.keys.toList();
      customFonts = SliverList.builder(
        itemCount: fonts.length,
        itemBuilder: (context, index) {
          final font = fonts[index];
          return ListTile(
            minTileHeight: _tileHeight,
            tileColor: _tileColor(font),
            onTap: () => _onFontChanged(font, isCustom: true),
            title: Text(
              font.split('/').last,
              style: TextStyle(fontFamily: font),
            ),
            trailing: iconButton(
              size: 38,
              iconSize: 22,
              tooltip: '移除',
              onPressed: () {
                if (_selectedFont == font) {
                  _appFont = (fontFamily: null, isCustom: false);
                }
                _customFonts.remove(font);
                setState(() {});
              },
              icon: const Icon(Icons.clear),
            ),
          );
        },
      );
    } else {
      customFonts = null;
    }
    return SimpleScaffold(
      appBar: AppBar(
        title: const Text('App字体设置'),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              _appFont = (fontFamily: null, isCustom: false);
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
        child: Flex(
          direction: isPortrait ? .vertical : .horizontal,
          children: [
            Expanded(
              flex: isPortrait ? 1 : 2,
              child: Center(
                child: Text(
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
                    fontFamily: _selectedFont ?? '',
                    fontWeight: .values[_selectedWeight],
                    fontSize: 14 * _selectedScale,
                  ),
                ),
              ),
            ),
            isPortrait
                ? Divider(
                    height: 1,
                    color: colorScheme.primary.withValues(alpha: 0.3),
                  )
                : VerticalDivider(
                    width: 1,
                    color: colorScheme.primary.withValues(alpha: 0.3),
                  ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const .symmetric(horizontal: 16, vertical: 5),
                    child: GestureDetector(
                      behavior: .translucent,
                      onTap: scrollController.jumpToTop,
                      child: Row(
                        children: [
                          const Text(
                            '字体：',
                            style: TextStyle(fontWeight: .bold, fontSize: 15),
                          ),
                          Expanded(
                            child: Text(
                              _appFont.isCustom
                                  ? _selectedFont!.split('/').last
                                  : _selectedFont ?? '默认',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: _selectedFont ?? '',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const .only(left: 8),
                            child: iconButton(
                              size: 32,
                              iconSize: 20,
                              tooltip: '导入',
                              context: context,
                              onPressed: () async {
                                SmartDialog.showLoading();
                                final font = await FontUtils.pickFonts();
                                SmartDialog.dismiss();
                                if (!mounted) return;
                                if (font != null) {
                                  _customFonts.addAll(font);
                                  _appFont = (
                                    fontFamily: font.keys.first,
                                    isCustom: true,
                                  );
                                  setState(() {});
                                }
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      type: .transparency,
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          SliverToBoxAdapter(
                            child: ListTile(
                              minTileHeight: _tileHeight,
                              tileColor: _tileColor(null),
                              onTap: () => _onFontChanged(null),
                              title: const Text('默认'),
                            ),
                          ),
                          if (FontUtils.isCustom)
                            SliverToBoxAdapter(
                              child: ListTile(
                                minTileHeight: _tileHeight,
                                tileColor: _tileColor(FontUtils.fontFamily),
                                onTap: () => _onFontChanged(
                                  FontUtils.fontFamily,
                                  isCustom: true,
                                ),
                                title: Text(
                                  FontUtils.fontFamily!.split('/').last,
                                ),
                              ),
                            ),
                          ?customFonts,
                          if (_fonts.isNotEmpty)
                            SliverList.builder(
                              itemCount: _fonts.length,
                              itemBuilder: (context, index) {
                                final font = _fonts[index];
                                return ListTile(
                                  minTileHeight: _tileHeight,
                                  tileColor: _tileColor(font),
                                  onTap: () => _onFontChanged(font),
                                  title: Text(
                                    font,
                                    style: TextStyle(fontFamily: font),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
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
                            child: Text(
                              'w900',
                              style: TextStyle(fontWeight: .w900),
                            ),
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
                            onChanged: (value) => setState(
                              () => _selectedScale = value.toPrecision(2),
                            ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(Widget child) {
    return Container(
      padding: const .symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.primary.withValues(alpha: 0.3)),
        ),
      ),
      child: child,
    );
  }
}
