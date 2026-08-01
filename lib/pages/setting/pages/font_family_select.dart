import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/windows_font_utils.dart';
import 'package:flutter/material.dart' hide ListTile;
import 'package:get/get.dart';

class FontFamilySelectPage extends StatefulWidget {
  const FontFamilySelectPage({super.key});

  @override
  State<FontFamilySelectPage> createState() => _FontFamilySelectPageState();
}

class _FontFamilySelectPageState extends State<FontFamilySelectPage> {
  static const _previewText = 'Aa Bb 123 中文预览';
  static const _systemDefaultFont = 'Segoe UI';
  static const _twoColumnBreakpoint = 840.0;
  static const _threeColumnBreakpoint = 1260.0;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  late String _selectedFontFamily = Pref.appFontFamily;
  List<String> _fontFamilies = const [];
  Object? _loadError;
  String _query = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFontFamilies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadFontFamilies() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    }
    try {
      final fontFamilies = await WindowsFontUtils.getInstalledFontFamilies();
      if (!mounted) return;
      setState(() {
        _fontFamilies = fontFamilies;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = error;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveFontFamily() async {
    if (_selectedFontFamily.isEmpty) {
      await GStorage.setting.delete(SettingBoxKey.appFontFamily);
    } else {
      await GStorage.setting.put(
        SettingBoxKey.appFontFamily,
        _selectedFontFamily,
      );
    }
    Get
      ..back(result: _selectedFontFamily)
      ..updateMyAppTheme();
  }

  void _resetFontFamily() {
    _selectedFontFamily = '';
    _saveFontFamily();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
    _scrollToTop();
  }

  void _onSearchChanged(String value) {
    setState(() => _query = value);
    _scrollToTop();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SimpleScaffold(
      appBar: AppBar(
        title: const Text('应用字体'),
        actions: [
          IconButton(
            tooltip: '刷新字体',
            onPressed: _isLoading ? null : _loadFontFamilies,
            icon: const Icon(Icons.refresh),
          ),
          TextButton(onPressed: _resetFontFamily, child: const Text('重置')),
          TextButton(onPressed: _saveFontFamily, child: const Text('确定')),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchField(theme),
            Expanded(child: _buildFontList(theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          visualDensity: .standard,
          border: const OutlineInputBorder(
            gapPadding: 0,
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          isDense: true,
          filled: true,
          fillColor: theme.colorScheme.onInverseSurface,
          hintText: '搜索字体',
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  tooltip: '清除',
                  onPressed: _clearSearch,
                  icon: const Icon(Icons.clear, size: 18),
                ),
        ),
      ),
    );
  }

  Widget _buildFontList(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_loadError != null) {
      return Center(
        child: Column(
          mainAxisSize: .min,
          spacing: 12,
          children: [
            Icon(
              Icons.error_outline,
              size: 36,
              color: theme.colorScheme.outline,
            ),
            const Text('读取本机字体失败'),
            TextButton.icon(
              onPressed: _loadFontFamilies,
              icon: const Icon(Icons.refresh),
              label: const Text('重试'),
            ),
          ],
        ),
      );
    }

    final options = _visibleOptions;
    if (options.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: .min,
          spacing: 12,
          children: [
            Icon(
              Icons.search_off,
              size: 36,
              color: theme.colorScheme.outline,
            ),
            const Text('未找到匹配字体'),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = switch (constraints.maxWidth) {
          >= _threeColumnBreakpoint => 3,
          >= _twoColumnBreakpoint => 2,
          _ => 1,
        };
        final scaledFontSize = MediaQuery.textScalerOf(context).scale(16);
        final itemHeight = (80 + (scaledFontSize - 16).clamp(0, 16) * 2)
            .toDouble();
        return Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          interactive: true,
          thickness: 10,
          radius: const Radius.circular(5),
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(8, 0, 18, 24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisExtent: itemHeight,
              crossAxisSpacing: 4,
              mainAxisSpacing: 2,
            ),
            itemCount: options.length,
            itemBuilder: (context, index) => _buildFontItem(
              theme,
              options[index],
            ),
          ),
        );
      },
    );
  }

  List<_FontOption> get _visibleOptions {
    final query = _query.trim().toLowerCase();
    bool matches(String value) =>
        query.isEmpty || value.toLowerCase().contains(query);

    final options = <_FontOption>[];
    final hasSelectedFont =
        _selectedFontFamily.isEmpty ||
        _fontFamilies.any(
          (fontFamily) =>
              fontFamily.toLowerCase() == _selectedFontFamily.toLowerCase(),
        );
    if (!hasSelectedFont && matches(_selectedFontFamily)) {
      options.add(_FontOption(_selectedFontFamily, isUnavailable: true));
    }
    if (matches('系统默认')) {
      options.add(const _FontOption(''));
    }
    options.addAll(
      _fontFamilies.where(matches).map(_FontOption.new),
    );
    return options;
  }

  Widget _buildFontItem(ThemeData theme, _FontOption option) {
    final fontFamily = option.fontFamily;
    final isSelected =
        fontFamily.toLowerCase() == _selectedFontFamily.toLowerCase();
    final previewStyle = theme.textTheme.bodyLarge!.copyWith(
      color: option.isUnavailable ? theme.colorScheme.error : null,
      fontFamily: fontFamily.isEmpty ? _systemDefaultFont : fontFamily,
    );
    return ListTile(
      selected: isSelected,
      selectedTileColor: theme.colorScheme.primaryContainer.withValues(
        alpha: 0.35,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      onTap: () => setState(() => _selectedFontFamily = fontFamily),
      title: Text(
        fontFamily.isEmpty ? '系统默认' : fontFamily,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        option.isUnavailable ? '当前字体不可用' : _previewText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: previewStyle,
      ),
      trailing: SizedBox.square(
        dimension: 24,
        child: isSelected
            ? Icon(Icons.check_rounded, color: theme.colorScheme.primary)
            : null,
      ),
    );
  }
}

class _FontOption {
  const _FontOption(this.fontFamily, {this.isUnavailable = false});

  final String fontFamily;
  final bool isUnavailable;
}
