import 'dart:async';

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/search/search_type.dart';
import 'package:PiliPlus/pages_tv/common/tv_card.dart';
import 'package:PiliPlus/pages_tv/common/tv_focus_wrapper.dart';
import 'package:PiliPlus/pages_tv/common/tv_keyboard.dart';
import 'package:PiliPlus/pages_tv/common/tv_page.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TVSearchPage extends StatefulWidget {
  const TVSearchPage({super.key});

  @override
  State<TVSearchPage> createState() => _TVSearchPageState();
}

class _TVSearchPageState extends State<TVSearchPage> {
  final _suggestState = Rx<LoadingState<List?>>(const Success(null));
  final _resultState = Rx<LoadingState<List?>>(const Success(null));
  final _trendingState = Rx<LoadingState<List?>>(LoadingState.loading());
  final _historyList = List<String>.from(
    GStorage.historyWord.get('cacheList') ?? const <String>[],
  ).obs;
  Timer? _debounce;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTrending();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadTrending() async {
    final res = await SearchHttp.searchTrending(limit: 10);
    if (!mounted) return;
    if (res is Success) {
      final data = res.data;
      _trendingState.value = Success(data.list ?? []);
    } else {
      _trendingState.value = const Success([]);
    }
  }

  void _addHistory(String keyword) {
    if (keyword.isEmpty) return;
    _historyList.remove(keyword);
    _historyList.insert(0, keyword);
    if (_historyList.length > 20) {
      _historyList.removeRange(20, _historyList.length);
    }
    GStorage.historyWord.put('cacheList', _historyList.toList());
  }

  void _clearHistory() {
    _historyList.clear();
    GStorage.historyWord.delete('cacheList');
  }

  void _onTextChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (text.isNotEmpty) {
        _loadSuggestions(text);
      } else {
        _suggestState.value = const Success(null);
      }
    });
  }

  Future<void> _loadSuggestions(String term) async {
    final res = await SearchHttp.searchSuggest(term: term);
    if (!mounted) return;
    if (res is Success) {
      final data = res.data;
      _suggestState.value = Success(data.tag ?? []);
    }
  }

  Future<void> _doSearch(String keyword) async {
    if (keyword.isEmpty) return;
    _lastQuery = keyword;
    _addHistory(keyword);
    _resultState.value = LoadingState.loading();
    final res = await SearchHttp.searchByType(
      searchType: SearchType.video,
      keyword: keyword,
      page: 1,
      onSuccess: (_) {},
    );
    if (!mounted) return;
    if (res is Success) {
      final data = res.data;
      _resultState.value = Success(data.list);
    } else {
      _resultState.value = Error(res is Error ? (res as Error).errMsg : '搜索失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TVPage(
      child: Scaffold(
        appBar: AppBar(title: const Text('搜索')),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 360,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TVKeyboard(
                        onTextChanged: _onTextChanged,
                        onConfirm: _doSearch,
                      ),
                      const SizedBox(height: 16),
                      _buildTrendingSection(),
                      const SizedBox(height: 16),
                      _buildHistorySection(),
                    ],
                  ),
                ),
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final state = _suggestState.value;
                      if (state case Success(:final response)) {
                        if (response != null && response.isNotEmpty) {
                          return Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: response.map<Widget>((tag) {
                              final text = tag.term ?? '';
                              return ActionChip(
                                label: Text(text),
                                onPressed: () => _doSearch(text),
                              );
                            }).toList(),
                          );
                        }
                      }
                      return const SizedBox.shrink();
                    }),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Obx(() {
                        final state = _resultState.value;
                        return switch (state) {
                          Loading() => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          Success(:final response) =>
                            response != null && response.isNotEmpty
                                ? GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio: 16 / 13,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                    ),
                                    itemCount: response.length,
                                    itemBuilder: (ctx, i) {
                                      final item = response[i];
                                      return TVCard(
                                        title: _stripHtml(
                                            item.title ?? ''),
                                        subtitle: item.author ?? '',
                                        coverUrl: _fixCover(
                                            item.cover),
                                        width: double.infinity,
                                        autoFocus: i == 0,
                                        onSelect: () {
                                          final bvid = item.bvid;
                                          final aid = item.aid;
                                          if (bvid != null || aid != null) {
                                            PageUtils.toVideoPage(
                                              aid: aid ?? IdUtils.bv2av(bvid!),
                                              bvid: bvid ??
                                                  IdUtils.av2bv(aid!),
                                              cid: item.cid ?? 0,
                                              title: _stripHtml(
                                                  item.title ?? ''),
                                              cover: _fixCover(
                                                  item.cover),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      _lastQuery.isEmpty
                                          ? '输入关键词搜索'
                                          : '未找到结果',
                                    ),
                                  ),
                          Error(:final errMsg) =>
                            Center(child: Text(errMsg ?? '搜索失败')),
                        };
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingSection() {
    return Obx(() {
      final state = _trendingState.value;
      if (state case Success(:final response)) {
        if (response != null && response.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '热搜',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: response.map<Widget>((item) {
                  final keyword = item.keyword ?? '';
                  return TVFocusWrapper(
                    scaleFactor: 1.05,
                    borderRadius: 16,
                    onSelect: () => _doSearch(keyword),
                    child: Chip(label: Text(keyword)),
                  );
                }).toList(),
              ),
            ],
          );
        }
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildHistorySection() {
    return Obx(() {
      if (_historyList.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '搜索历史',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              TVFocusWrapper(
                scaleFactor: 1.05,
                borderRadius: 16,
                onSelect: _clearHistory,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text('清除', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _historyList.map<Widget>((keyword) {
              return TVFocusWrapper(
                scaleFactor: 1.05,
                borderRadius: 16,
                onSelect: () => _doSearch(keyword),
                child: Chip(label: Text(keyword)),
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  static String _stripHtml(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  static String? _fixCover(String? url) {
    if (url == null) return null;
    if (url.startsWith('//')) return 'https:$url';
    return url;
  }
}
