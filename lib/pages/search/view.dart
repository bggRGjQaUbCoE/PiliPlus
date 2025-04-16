import 'package:PiliPlus/common/widgets/disabled_icon.dart';
import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/search/search_trending/trending_data.dart';
import 'package:PiliPlus/models/search/suggest.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'widgets/hot_keyword.dart';
import 'widgets/search_text.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _tag = Utils.generateRandomString(6);
  late final SSearchController _searchController = Get.put(
    SSearchController(),
    tag: _tag,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.08),
            width: 1,
          ),
        ),
        actions: [
          Obx(
            () => _searchController.showUidBtn.value
                ? IconButton(
                    tooltip: 'UID搜索用户',
                    icon: const Icon(Icons.person_outline, size: 22),
                    onPressed: () {
                      Get.toNamed(
                          '/member?mid=${_searchController.controller.text}');
                    },
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
            onPressed: () => _searchController.submit(),
            icon: const Icon(Icons.search, size: 22),
          ),
          const SizedBox(width: 10)
        ],
        title: TextField(
          autofocus: true,
          focusNode: _searchController.searchFocusNode,
          controller: _searchController.controller,
          textInputAction: TextInputAction.search,
          onChanged: _searchController.onChange,
          // textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: _searchController.hintText,
            border: InputBorder.none,
          ),
          onSubmitted: (value) => _searchController.submit(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 搜索建议
            if (_searchController.searchSuggestion) _searchSuggest(),
            if (context.orientation == Orientation.portrait) ...[
              if (_searchController.enableHotKey) hotSearch(),
              _history(),
              if (_searchController.enableSearchRcmd) hotSearch(false)
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_searchController.enableHotKey)
                    Expanded(child: hotSearch()),
                  Expanded(child: _history()),
                  if (_searchController.enableSearchRcmd)
                    Expanded(child: hotSearch(false)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _searchSuggest() {
    return Obx(
      () => _searchController.searchSuggestList.isNotEmpty &&
              _searchController.searchSuggestList.first.term != null &&
              _searchController.controller.text != ''
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _searchController.searchSuggestList
                  .map(
                    (item) => InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onTap: () => _searchController.onClickKeyword(item.term!),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          left: 20,
                          top: 9,
                          bottom: 9,
                        ),
                        child: highlightText(context, item.textRich),
                      ),
                    ),
                  )
                  .toList(),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget hotSearch([bool isHot = true]) {
    final text = Text(
      isHot ? '大家都在搜' : '搜索发现',
      strutStyle: const StrutStyle(leading: 0, height: 1),
      style: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(height: 1, fontWeight: FontWeight.bold),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 25, 4, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isHot
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          text,
                          Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: SizedBox(
                              height: 34,
                              child: TextButton.icon(
                                onPressed: () {
                                  Get.toNamed(
                                    '/searchTrending',
                                    parameters: {'tag': _tag},
                                  );
                                },
                                label: Text(
                                  '完整榜单',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                                icon: Icon(
                                  size: 16,
                                  Icons.keyboard_arrow_right,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                iconAlignment: IconAlignment.end,
                              ),
                            ),
                          )
                        ],
                      )
                    : text,
                SizedBox(
                  height: 34,
                  child: TextButton.icon(
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                    ),
                    onPressed: isHot
                        ? _searchController.queryHotSearchList
                        : _searchController.queryRecommendList,
                    icon: Icon(
                      Icons.refresh_outlined,
                      size: 18,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    label: Text(
                      '刷新',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(() => _buildHotKey(
                isHot
                    ? _searchController.loadingState.value
                    : _searchController.recommendData.value,
              )),
        ],
      ),
    );
  }

  Widget _history() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.fromLTRB(
          10,
          context.orientation == Orientation.landscape
              ? 25
              : _searchController.enableHotKey
                  ? 0
                  : 6,
          6,
          25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_searchController.historyList.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                child: Row(
                  children: [
                    Text(
                      '搜索历史',
                      strutStyle: StrutStyle(leading: 0, height: 1),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(height: 1, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12),
                    Obx(
                      () => SizedBox(
                        width: 34,
                        height: 34,
                        child: IconButton(
                          iconSize: 22,
                          tooltip: _searchController.recordSearchHistory.value
                              ? '记录搜索'
                              : '无痕搜索',
                          icon: _searchController.recordSearchHistory.value
                              ? historyIcon
                              : historyIcon.disable(),
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            _searchController.recordSearchHistory.value =
                                !_searchController.recordSearchHistory.value;
                            GStorage.setting.put(
                              SettingBoxKey.recordSearchHistory,
                              _searchController.recordSearchHistory.value,
                            );
                          },
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 34,
                      child: TextButton.icon(
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.only(
                              left: 10,
                              top: 6,
                              bottom: 6,
                              right: 10,
                            ),
                          ),
                        ),
                        onPressed: _searchController.onClearHistory,
                        icon: Icon(
                          Icons.clear_all_outlined,
                          size: 18,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        label: Text(
                          '清空',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            Obx(
              () => Wrap(
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
            ),
          ],
        ),
      ),
    );
  }

  Icon get historyIcon => Icon(Icons.history,
      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.8));

  Widget _buildHotKey(LoadingState<SearchKeywordData> loadingState) {
    return switch (loadingState) {
      Success() => loadingState.response.list?.isNotEmpty == true
          ? LayoutBuilder(
              builder: (context, constraints) => HotKeyword(
                width: constraints.maxWidth,
                hotSearchList: loadingState.response.list!,
                onClick: _searchController.onClickKeyword,
              ),
            )
          : const SizedBox.shrink(),
      Error() => errorWidget(
          errMsg: loadingState.errMsg,
          callback: _searchController.queryHotSearchList,
        ),
      _ => const SizedBox.shrink(),
    };
  }
}
