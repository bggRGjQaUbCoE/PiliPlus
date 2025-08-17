import 'dart:convert';

import 'package:PiliPlus/common/widgets/disabled_icon.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/search/search_rcmd/data.dart';
import 'package:PiliPlus/pages/about/view.dart' show showInportExportDialog;
import 'package:PiliPlus/pages/search/controller.dart';
import 'package:PiliPlus/pages/search/widgets/hot_keyword.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/em.dart' show Em;
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _tag = Utils.generateRandomString(6);
  late final SSearchController _searchController = Get.put(
    SSearchController(_tag),
    tag: _tag,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPortrait = context.isPortrait;
    return Scaffold(
      appBar: AppBar(
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
            icon: const Icon(Icons.search, size: 22),
          ),
          const SizedBox(width: 10),
        ],
        title: TextField(
          autofocus: true,
          focusNode: _searchController.searchFocusNode,
          controller: _searchController.controller,
          textInputAction: TextInputAction.search,
          onChanged: _searchController.onChange,
          decoration: InputDecoration(
            hintText: _searchController.hintText ?? '搜索',
            border: InputBorder.none,
          ),
          onSubmitted: (value) => _searchController.submit(),
        ),
      ),
      body: ListView(
        padding: MediaQuery.paddingOf(context).copyWith(top: 0),
        children: [
          if (_searchController.searchSuggestion) _searchSuggest(),
          if (isPortrait) ...[
            if (_searchController.enableTrending) hotSearch(theme, isPortrait),
            _history(theme, isPortrait),
            if (_searchController.enableSearchRcmd)
              hotSearch(theme, isPortrait, isTrending: false),
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_searchController.enableTrending ||
                    _searchController.enableSearchRcmd)
                  Expanded(
                    child: Column(
                      children: [
                        if (_searchController.enableTrending)
                          hotSearch(theme, isPortrait),
                        if (_searchController.enableSearchRcmd)
                          hotSearch(theme, isPortrait, isTrending: false),
                      ],
                    ),
                  ),
                Expanded(child: _history(theme, isPortrait)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _searchSuggest() {
    return Obx(
      () =>
          _searchController.searchSuggestList.isNotEmpty &&
              _searchController.searchSuggestList.first.term != null &&
              _searchController.controller.text != ''
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _searchController.searchSuggestList
                  .map(
                    (item) => InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      onTap: () => _searchController.onClickKeyword(item.term!),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          left: 20,
                          top: 9,
                          bottom: 9,
                        ),
                        child: Text.rich(
                          TextSpan(
                            children: Em.regTitle(item.textRich)
                                .map(
                                  (e) => TextSpan(
                                    text: e.text,
                                    style: e.isEm
                                        ? TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
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
          : const SizedBox.shrink(),
    );
  }

  Widget hotSearch(ThemeData theme, bool isPortrait, {bool isTrending = true}) {
    final text = Text(
      isTrending ? '大家都在搜' : '搜索发现',
      strutStyle: const StrutStyle(leading: 0, height: 1),
      style: theme.textTheme.titleMedium!.copyWith(
        height: 1,
        fontWeight: FontWeight.bold,
      ),
    );
    final outline = theme.colorScheme.outline;
    final secondary = theme.colorScheme.secondary;
    final style = TextStyle(
      height: 1,
      fontSize: 13,
      color: outline,
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(
        10,
        !isTrending && (isPortrait || _searchController.enableTrending)
            ? 4
            : 25,
        4,
        25,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isTrending
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          text,
                          const SizedBox(width: 14),
                          SizedBox(
                            height: 34,
                            child: TextButton(
                              onPressed: () => Get.toNamed(
                                '/searchTrending',
                                parameters: {'tag': _tag},
                              ),
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
                          ),
                        ],
                      )
                    : text,
                SizedBox(
                  height: 34,
                  child: TextButton.icon(
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                      style: TextStyle(
                        height: 1,
                        color: secondary,
                      ),
                    ),
                  ),
                ),
              ],
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

  Widget _history(ThemeData theme, bool isPortrait) {
    return Obx(
      () {
        if (_searchController.historyList.isEmpty) {
          return const SizedBox.shrink();
        }
        final secondary = theme.colorScheme.secondary;
        return Padding(
          padding: EdgeInsets.fromLTRB(
            10,
            !isPortrait
                ? 25
                : _searchController.enableTrending
                ? 0
                : 6,
            6,
            25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                child: Row(
                  children: [
                    Text(
                      '搜索历史',
                      strutStyle: const StrutStyle(leading: 0, height: 1),
                      style: theme.textTheme.titleMedium!.copyWith(
                        height: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Obx(
                      () {
                        bool enable =
                            _searchController.recordSearchHistory.value;
                        return SizedBox(
                          width: 34,
                          height: 34,
                          child: IconButton(
                            iconSize: 22,
                            tooltip: enable ? '记录搜索' : '无痕搜索',
                            icon: enable
                                ? historyIcon(theme)
                                : historyIcon(theme).disable(),
                            style: IconButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              enable = !enable;
                              _searchController.recordSearchHistory.value =
                                  enable;
                              GStorage.setting.put(
                                SettingBoxKey.recordSearchHistory,
                                enable,
                              );
                            },
                          ),
                        );
                      },
                    ),
                    _exportHsitory(theme),
                    const Spacer(),
                    SizedBox(
                      height: 34,
                      child: TextButton.icon(
                        style: const ButtonStyle(
                          padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
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
                          style: TextStyle(color: secondary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                direction: Axis.horizontal,
                textDirection: TextDirection.ltr,
                children: _searchController.historyList
                    .map(
                      (item) => SearchText(
                        text: item,
                        onTap: _searchController.onClickKeyword,
                        onLongPress: _searchController.onLongSelect,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _exportHsitory(ThemeData theme) => SizedBox(
    width: 34,
    height: 34,
    child: IconButton(
      iconSize: 22,
      tooltip: '导入/导出历史记录',
      icon: Icon(
        Icons.import_export_outlined,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
      ),
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      onPressed: () => showInportExportDialog<List>(
        context,
        title: '历史记录',
        toJson: () => jsonEncode(_searchController.historyList),
        fromJson: (json) {
          _searchController.historyList.value = json.cast<String>();
        },
      ),
    ),
  );

  Icon historyIcon(ThemeData theme) => Icon(
    Icons.history,
    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
  );

  Widget _buildHotKey(
    LoadingState<SearchRcmdData> loadingState,
    bool isTrending,
  ) {
    return switch (loadingState) {
      Success(:var response) =>
        response.list?.isNotEmpty == true
            ? LayoutBuilder(
                builder: (context, constraints) => HotKeyword(
                  width: constraints.maxWidth,
                  hotSearchList: response.list!,
                  onClick: _searchController.onClickKeyword,
                ),
              )
            : const SizedBox.shrink(),
      Error(:var errMsg) => errorWidget(
        errMsg: errMsg,
        onReload: isTrending
            ? _searchController.queryTrendingList
            : _searchController.queryRecommendList,
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
