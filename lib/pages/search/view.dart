import 'dart:convert';

import 'package:PiliPlus/common/widgets/dialog/export_import.dart';
import 'package:PiliPlus/common/widgets/disabled_icon.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/sliver_wrap.dart';
import 'package:PiliPlus/common/widgets/view_insets_safe_area.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/search/search_rcmd/data.dart';
import 'package:PiliPlus/pages/search/controller.dart';
import 'package:PiliPlus/pages/search/widgets/hot_keyword.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/router/search_expansion.dart';
import 'package:PiliPlus/utils/em.dart' show Em;
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _tag = Utils.generateRandomString(6);
  late final SSearchController _searchController;
  late ThemeData theme;
  late bool isPortrait;
  late EdgeInsets padding;
  late final _route = ModalRoute.of(context)!;
  late final _expansion = switch (_route.settings.arguments) {
    final SearchExpansion expansion => expansion,
    _ => null,
  };
  bool get _expandsFromHome => _expansion != null;
  Animation<double>? _entrance;

  @override
  void initState() {
    super.initState();
    _searchController = Get.put(SSearchController(_tag), tag: _tag);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context);
    padding = MediaQuery.viewPaddingOf(context);
    isPortrait = MediaQuery.isPortraitOf(context);
    if (_expandsFromHome && _entrance == null) {
      final animation = _entrance = _route.animation!
        ..addStatusListener(_focusWhenExpanded);
      if (animation.isCompleted) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _focusWhenExpanded(animation.status),
        );
      }
    }
  }

  void _focusWhenExpanded(AnimationStatus status) {
    if (!mounted || status != AnimationStatus.completed) return;
    _entrance!.removeStatusListener(_focusWhenExpanded);
    if (_route.isCurrent) _searchController.searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _entrance?.removeStatusListener(_focusWhenExpanded);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trending = _searchController.enableTrending
        ? _buildHotSearch()
        : null;
    final rcmd = _searchController.enableSearchRcmd
        ? _buildHotSearch(isTrending: false)
        : null;
    final motion = _expansion?.viewport == MediaQuery.sizeOf(context)
        ? _route.animation
        : null;

    return PopScope(
      canPop: MediaQuery.viewInsetsOf(context).bottom == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _searchController.searchFocusNode.unfocus();
      },
      child: SimpleScaffold(
        backgroundColor: motion == null ? null : Colors.transparent,
        appBar: _reveal(_buildAppBar(motion), motion, const Interval(.16, .58)),
        body: _reveal(
          Padding(
            padding: .only(left: padding.left, right: padding.right),
            child: ViewInsetsSafeArea(
              child: CustomScrollView(
                slivers: [
                  if (_searchController.searchSuggestion) _buildSearchSuggest(),
                  if (isPortrait) ...[
                    _buildHistory,
                    ?trending,
                    ?rcmd,
                  ] else if (trending != null || rcmd != null)
                    SliverCrossAxisGroup(
                      slivers: [
                        _buildHistory,
                        SliverMainAxisGroup(slivers: [?trending, ?rcmd]),
                      ],
                    )
                  else
                    _buildHistory,
                  SliverPadding(padding: .only(bottom: padding.bottom)),
                ],
              ),
            ),
          ),
          motion,
          const Interval(.14, .4),
        ),
      ),
    );
  }

  Widget _reveal(Widget child, Animation<double>? motion, Interval interval) =>
      motion == null
      ? child
      : FadeTransition(
          opacity: motion.drive(CurveTween(curve: interval)),
          child: child,
        );

  // The route paints the traveling hint and magnifier. Keep their real widgets
  // laid out so the painter can use the exact landing positions.
  Widget _afterExpansion(Widget child, Animation<double>? motion) =>
      motion == null
      ? child
      : AnimatedBuilder(
          animation: motion,
          child: child,
          builder: (context, child) => Opacity(
            opacity: motion.isCompleted ? 1 : 0,
            child: child,
          ),
        );

  Widget _buildAppBar(Animation<double>? motion) => AppBar(
    shape: Border(
      bottom: BorderSide(
        color: theme.dividerColor.withValues(alpha: 0.08),
        width: 1,
      ),
    ),
    actions: [
      Obx(
        () => _searchController.showUidBtn.value
            ? IconButton(
                tooltip: 'UID搜索用户',
                icon: const Icon(Icons.person_outline, size: 22),
                onPressed: () => Get.toNamed(
                  '/member?mid=${_searchController.controller.text}',
                ),
              )
            : const SizedBox.shrink(),
      ),
      IconButton(
        tooltip: '清空',
        icon: const Icon(Icons.clear, size: 22),
        onPressed: _searchController.onClear,
      ),
      IconButton(
        tooltip: '搜索',
        onPressed: _searchController.submit,
        icon: _afterExpansion(
          Icon(Icons.search, key: _expansion?.submitIconKey, size: 22),
          motion,
        ),
      ),
      const SizedBox(width: 10),
    ],
    title: _afterExpansion(
      TextField(
        key: _expansion?.fieldKey,
        autofocus: !_expandsFromHome,
        focusNode: _searchController.searchFocusNode,
        controller: _searchController.controller,
        textInputAction: TextInputAction.search,
        onChanged: _searchController.onChange,
        decoration: InputDecoration(
          visualDensity: .standard,
          hintText: _expandsFromHome
              ? null
              : _searchController.hintText ?? '搜索',
          hint: _expandsFromHome
              ? Text(
                  _searchController.hintText ?? '搜索',
                  key: _expansion!.hintKey,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          border: InputBorder.none,
        ),
        onSubmitted: (value) => _searchController.submit(),
      ),
      motion,
    ),
  );

  Widget _buildSearchSuggest() {
    return Obx(() {
      final list = _searchController.searchSuggestList;
      return list.isNotEmpty &&
              list.first.term != null &&
              _searchController.controller.text != ''
          ? SliverList.list(
              children: list
                  .map(
                    (item) => InkWell(
                      borderRadius: const .all(.circular(4)),
                      onTap: () => _searchController.onClickKeyword(
                        item.term!,
                        clearSuggest: false,
                      ),
                      child: Padding(
                        padding: const .only(left: 20, top: 9, bottom: 9),
                        child: Text.rich(
                          TextSpan(
                            children: Em.regTitle(item.textRich)
                                .map(
                                  (e) => TextSpan(
                                    text: e.text,
                                    style: e.isEm
                                        ? TextStyle(
                                            fontWeight: .bold,
                                            color: theme.colorScheme.primary,
                                          )
                                        : null,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            )
          : const SliverToBoxAdapter();
    });
  }

  Widget _buildHotSearch({
    bool isTrending = true,
  }) {
    final text = Text(
      isTrending ? '大家都在搜' : '搜索发现',
      strutStyle: const StrutStyle(leading: 0, height: 1),
      style: theme.textTheme.titleMedium!.copyWith(
        height: 1,
        fontWeight: .bold,
      ),
    );
    final outline = theme.colorScheme.outline;
    final secondary = theme.colorScheme.secondary;
    final style = TextStyle(
      height: 1,
      fontSize: 13,
      color: outline,
    );
    return SliverPadding(
      padding: .fromLTRB(
        10,
        !isTrending && (isPortrait || _searchController.enableTrending)
            ? 4
            : 25,
        4,
        25,
      ),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverPadding(
            padding: const .fromLTRB(6, 0, 6, 6),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  isTrending
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            text,
                            const SizedBox(width: 14),
                            TextButton(
                              style: const ButtonStyle(
                                visualDensity: .compact,
                                tapTargetSize: .shrinkWrap,
                                padding: WidgetStatePropertyAll(
                                  .symmetric(horizontal: 10),
                                ),
                              ),
                              onPressed: () => Get.toNamed('/searchTrending'),
                              child: Row(
                                children: [
                                  Text(
                                    '完整榜单',
                                    strutStyle: const StrutStyle(
                                      leading: 0,
                                      height: 1,
                                    ),
                                    style: style,
                                  ),
                                  Icon(
                                    size: 18,
                                    Icons.keyboard_arrow_right,
                                    color: outline,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : text,
                  TextButton.icon(
                    style: const ButtonStyle(
                      visualDensity: .compact,
                      tapTargetSize: .shrinkWrap,
                      padding: WidgetStatePropertyAll(
                        .symmetric(horizontal: 10),
                      ),
                    ),
                    onPressed: isTrending
                        ? _searchController.queryTrendingList
                        : _searchController.queryRecommendList,
                    icon: Icon(
                      Icons.refresh_outlined,
                      size: 18,
                      color: secondary,
                    ),
                    label: Text(
                      '刷新',
                      strutStyle: const StrutStyle(leading: 0, height: 1),
                      style: TextStyle(height: 1, color: secondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => _buildHotKey(
              isTrending
                  ? _searchController.trendingState.value
                  : _searchController.recommendData.value,
              isTrending,
            ),
          ),
        ],
      ),
    );
  }

  late final mainAxisExtent = 16 + MediaQuery.textScalerOf(context).scale(14);
  Widget get _buildHistory {
    return Obx(
      () {
        final list = _searchController.historyList;
        if (list.isEmpty) {
          return const SliverToBoxAdapter();
        }
        final secondary = theme.colorScheme.secondary;
        return SliverPadding(
          padding: .fromLTRB(10, isPortrait ? 12 : 25, 6, 25),
          sliver: SliverMainAxisGroup(
            slivers: [
              SliverPadding(
                padding: const .fromLTRB(6, 0, 6, 6),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Text(
                        '搜索历史',
                        strutStyle: const StrutStyle(leading: 0, height: 1),
                        style: theme.textTheme.titleMedium!.copyWith(
                          height: 1,
                          fontWeight: .bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _recordBtn,
                      _exportBtn,
                      const Spacer(),
                      TextButton.icon(
                        style: const ButtonStyle(
                          visualDensity: .compact,
                          tapTargetSize: .shrinkWrap,
                          padding: WidgetStatePropertyAll(
                            .symmetric(horizontal: 10),
                          ),
                        ),
                        onPressed: _searchController.onClearHistory,
                        icon: Icon(
                          Icons.clear_all_outlined,
                          size: 18,
                          color: secondary,
                        ),
                        label: Text(
                          '清空',
                          style: TextStyle(height: 1, color: secondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverFixedWrap(
                mainAxisExtent: mainAxisExtent,
                spacing: 8,
                runSpacing: 8,
                delegate: SliverChildBuilderDelegate(
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  childCount: list.length,
                  (context, index) => SearchText(
                    text: list[index],
                    onTap: _searchController.onClickKeyword,
                    onLongPress: _searchController.onLongSelect,
                    height: 1,
                    maxLines: 1,
                    fontSize: 14,
                    overflow: .ellipsis,
                    padding: const .fromLTRB(11, 8, 11, 0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget get _recordBtn => Obx(
    () {
      bool enable = _searchController.recordSearchHistory.value;
      return IconButton(
        iconSize: 22,
        tooltip: enable ? '记录搜索' : '无痕搜索',
        icon: DisabledIcon(
          disable: !enable,
          child: Icon(
            Icons.history,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
          ),
        ),
        style: const ButtonStyle(
          visualDensity: .comfortable,
          tapTargetSize: .shrinkWrap,
          padding: WidgetStatePropertyAll(.zero),
        ),
        onPressed: () {
          enable = !enable;
          _searchController.recordSearchHistory.value = enable;
          GStorage.setting.put(
            SettingBoxKey.recordSearchHistory,
            enable,
          );
        },
      );
    },
  );

  Widget get _exportBtn => IconButton(
    iconSize: 22,
    tooltip: '导入/导出历史记录',
    icon: Icon(
      Icons.import_export_outlined,
      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
    ),
    style: const ButtonStyle(
      visualDensity: .comfortable,
      tapTargetSize: .shrinkWrap,
      padding: WidgetStatePropertyAll(.zero),
    ),
    onPressed: () => showImportExportDialog<List>(
      context,
      title: '历史记录',
      localFileName: () => 'search',
      onExport: () => jsonEncode(_searchController.historyList),
      onImport: (json) {
        final list = List<String>.from(json);
        _searchController.historyList.value = list;
        GStorage.historyWord.put('cacheList', list);
      },
    ),
  );

  Widget _buildHotKey(
    LoadingState<SearchRcmdData> loadingState,
    bool isTrending,
  ) {
    return switch (loadingState) {
      Success(:final response) when (response.list?.isNotEmpty ?? false) =>
        SliverHotKeyword(
          hotSearchList: response.list!,
          onClick: _searchController.onClickKeyword,
        ),
      Error(:final errMsg) => HttpError(
        safeArea: false,
        errMsg: errMsg,
        onReload: isTrending
            ? _searchController.queryTrendingList
            : _searchController.queryRecommendList,
      ),
      _ => const SliverToBoxAdapter(),
    };
  }
}
