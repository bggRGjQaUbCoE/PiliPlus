import 'dart:async' show StreamSubscription;

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/search/article_search_type.dart';
import 'package:PiliPlus/models/common/search/search_type.dart';
import 'package:PiliPlus/models/common/search/user_search_type.dart';
import 'package:PiliPlus/models/common/search/video_search_type.dart';
import 'package:PiliPlus/models/search/result.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/pages/search_result/controller.dart';
import 'package:PiliPlus/pages/setting/widgets/list_editor_dialog.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class SearchPanelController<R extends SearchNumData<T>, T>
    extends CommonListController<R, T> {
  SearchPanelController({
    required this.keyword,
    required this.searchType,
    required this.tag,
  });
  final String tag;
  final String keyword;
  final SearchType searchType;
  SearchType get searchType_ => searchType;

  // sort
  // common
  String order = '';

  // video
  VideoDurationType? videoDurationType; // int duration
  VideoZoneType? videoZoneType; // int? tids;
  int? pubBegin;
  int? pubEnd;

  // user
  Rx<UserOrderType>? userOrderType;
  Rx<UserType>? userType;

  // article
  Rx<ArticleZoneType>? articleZoneType; // int? categoryId;

  SearchResultController? searchResultController;

  // client-side keyword filter
  final RxList<String> includeKeywords = <String>[].obs;
  final RxList<String> excludeKeywords = <String>[].obs;

  RegExp? _buildRegex(List<String> keywords) {
    if (keywords.isEmpty) return null;
    try {
      final pattern = keywords
          .map((k) => k.contains('|') && !k.startsWith('(') ? '($k)' : k)
          .join('|');
      return RegExp(pattern, caseSensitive: false);
    } catch (_) {
      return null;
    }
  }

  List<E> filterKeywords<E>(List<E> list, String? Function(E) getTitle) {
    final hasInc = includeKeywords.isNotEmpty;
    final hasExc = excludeKeywords.isNotEmpty;
    if (!hasInc && !hasExc) return list;
    final inc = hasInc ? _buildRegex(includeKeywords) : null;
    final exc = hasExc ? _buildRegex(excludeKeywords) : null;
    return list.where((item) {
      final title = getTitle(item);
      if (title == null) return true;
      if (inc != null && !inc.hasMatch(title)) return false;
      if (exc != null && exc.hasMatch(title)) return false;
      return true;
    }).toList();
  }

  Widget buildKeywordFilterSection(
    BuildContext context,
    ThemeData theme,
    void Function(VoidCallback fn) setState,
  ) {
    final hasInc = includeKeywords.isNotEmpty;
    final hasExc = excludeKeywords.isNotEmpty;
    final hasAny = hasInc || hasExc;
    final primary = theme.colorScheme.primary;
    final error = theme.colorScheme.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        const Text('关键词过滤', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        if (hasAny) ...[
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (hasInc)
                ...includeKeywords.asMap().entries.map(
                  (e) => InputChip(
                    avatar: Text('+',
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                        )),
                    label: Text(e.value),
                    labelStyle: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    deleteIconColor: theme.colorScheme.onSecondaryContainer,
                    onDeleted: () {
                      includeKeywords.removeAt(e.key);
                      setState(() {});
                    },
                  ),
                ),
              if (hasExc)
                ...excludeKeywords.asMap().entries.map(
                  (e) => InputChip(
                    avatar: Text('-',
                        style: TextStyle(
                          color: error,
                          fontWeight: FontWeight.bold,
                        )),
                    label: Text(e.value),
                    labelStyle: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                    backgroundColor: theme.colorScheme.errorContainer,
                    deleteIconColor: theme.colorScheme.onErrorContainer,
                    onDeleted: () {
                      excludeKeywords.removeAt(e.key);
                      setState(() {});
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _editKeywords(
                  context,
                  setState,
                  title: '包含关键词',
                  keywords: includeKeywords,
                  theme: theme,
                  isInclude: true,
                ),
                icon: Icon(
                  hasInc ? Icons.edit : Icons.add,
                  size: 16,
                ),
                label: Text(hasInc ? '编辑包含词' : '添加包含词'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _editKeywords(
                  context,
                  setState,
                  title: '排除关键词',
                  keywords: excludeKeywords,
                  theme: theme,
                  isInclude: false,
                ),
                icon: Icon(
                  hasExc ? Icons.edit : Icons.remove,
                  size: 16,
                ),
                label: Text(hasExc ? '编辑排除词' : '添加排除词'),
              ),
            ),
          ],
        ),
        if (hasAny)
          TextButton(
            onPressed: () {
              includeKeywords.clear();
              excludeKeywords.clear();
              setState(() {});
            },
            child: const Text('清除所有关键词'),
          ),
      ],
    );
  }

  Future<void> _editKeywords(
    BuildContext context,
    void Function(VoidCallback fn) setState, {
    required String title,
    required RxList<String> keywords,
    required ThemeData theme,
    required bool isInclude,
  }) async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => ListEditorDialog(
        title: title,
        initialItems: List.from(keywords),
        hintText: '输入关键词或正则表达式',
        itemLabel: isInclude ? '包含词' : '排除词',
        validator: (value) {
          if (value.isEmpty) return '请输入关键词';
          try {
            RegExp(value);
            return null;
          } catch (_) {
            return '无效的正则表达式';
          }
        },
      ),
    );
    if (result != null) {
      keywords.value = result;
      setState(() {});
      SmartDialog.showToast('已更新$title');
    }
  }

  void onSortSearch({
    bool getBack = true,
    String? label,
  }) {
    if (getBack) Get.back();
    SmartDialog.dismiss();
    if (label != null) {
      SmartDialog.showToast("「$label」的筛选结果");
    }
    SmartDialog.showLoading(msg: 'loading');
    onReload().whenComplete(SmartDialog.dismiss);
  }

  StreamSubscription? _listener;

  void cancelListener() {
    _listener?.cancel();
  }

  @override
  void onInit() {
    super.onInit();
    try {
      searchResultController = Get.find<SearchResultController>(tag: tag);
      _listener = searchResultController!.toTopIndex.listen((index) {
        if (index == searchType.index) {
          scrollController.animToTop();
        }
      });
    } catch (_) {}
    queryData();
  }

  @override
  List<T>? getDataList(R response) {
    return response.list;
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<R> response) {
    if (isRefresh) {
      searchResultController?.count[searchType.index] =
          response.response.numResults ?? 0;
    }
    return false;
  }

  String? gaiaVtoken;

  @override
  Future<LoadingState<R>> customGetData() => SearchHttp.searchByType<R>(
    searchType: searchType_,
    keyword: keyword,
    page: page,
    order: order,
    duration: videoDurationType?.index,
    tids: videoZoneType?.tids,
    orderSort: userOrderType?.value.orderSort,
    userType: userType?.value.index,
    categoryId: articleZoneType?.value.categoryId,
    pubBegin: pubBegin,
    pubEnd: pubEnd,
    gaiaVtoken: gaiaVtoken,
    onSuccess: (String gaiaVtoken) {
      this.gaiaVtoken = gaiaVtoken;
      queryData(page == 1);
    },
  );

  @override
  Future<void> onReload() {
    scrollController.jumpToTop();
    return super.onReload();
  }

  int _lastLoadMoreTime = 0;

  bool get hasKeywordFilter =>
      includeKeywords.isNotEmpty || excludeKeywords.isNotEmpty;

  @override
  Future<void> onLoadMore() async {
    if (hasKeywordFilter) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - _lastLoadMoreTime < 1200) return;
      await super.onLoadMore();
      _lastLoadMoreTime = DateTime.now().millisecondsSinceEpoch;
    } else {
      return super.onLoadMore();
    }
  }
}
