import 'package:PiliPlus/common/widgets/dialog.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/search/search_trending/trending_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/search/suggest.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

class SSearchController extends GetxController {
  final searchFocusNode = FocusNode();
  final controller = TextEditingController();

  RxList<String> historyList = <String>[].obs;

  RxList<SearchSuggestItem> searchSuggestList = <SearchSuggestItem>[].obs;

  String hintText = '搜索';

  late bool enableHotKey;
  late bool enableSearchRcmd;

  Rx<LoadingState<TrendingData>> loadingState =
      LoadingState<TrendingData>.loading().obs;

  Rx<LoadingState<SearchKeywordData>> recommendData =
      LoadingState<SearchKeywordData>.loading().obs;

  int initIndex = 0;

  RxBool showUidBtn = false.obs;

  final _debouncer = Debouncer(delay: const Duration(milliseconds: 200));
  late final searchSuggestion = GStorage.searchSuggestion;
  late final RxBool recordSearchHistory = GStorage.recordSearchHistory.obs;

  late final digitOnlyRegExp = RegExp(r'^\d+$');

  @override
  void onInit() {
    super.onInit();
    // 其他页面跳转过来
    if (Get.parameters.keys.isNotEmpty) {
      if (Get.parameters['keyword'] != null) {
        onClickKeyword(Get.parameters['keyword']!);
      }
      if (Get.parameters['hintText'] != null) {
        hintText = Get.parameters['hintText']!;
      }
      if (Get.parameters['text'] != null) {
        controller.text = Get.parameters['text']!;
      }
    }

    historyList.value = List.from(GStorage.historyWord.get('cacheList') ?? []);

    enableHotKey =
        GStorage.setting.get(SettingBoxKey.enableHotKey, defaultValue: true);

    enableSearchRcmd = GStorage.setting
        .get(SettingBoxKey.enableSearchRcmd, defaultValue: true);

    if (enableHotKey) {
      queryHotSearchList();
    }

    if (enableSearchRcmd) {
      queryRecommendList();
    }
  }

  void validateUid() {
    showUidBtn.value = digitOnlyRegExp.hasMatch(controller.text);
  }

  void onChange(String value) {
    validateUid();
    if (value.isEmpty) {
      searchSuggestList.clear();
    } else if (searchSuggestion) {
      _debouncer.call(() => querySearchSuggest(value));
    }
  }

  void onClear() {
    if (controller.value.text != '') {
      controller.clear();
      searchSuggestList.clear();
      searchFocusNode.requestFocus();
      showUidBtn.value = false;
    } else {
      Get.back();
    }
  }

  // 搜索
  void submit() async {
    if (controller.text.isEmpty) {
      if (hintText.isEmpty) {
        return;
      }
      controller.text = hintText;
      validateUid();
    }

    if (recordSearchHistory.value) {
      historyList.remove(controller.text);
      historyList.insert(0, controller.text);
      GStorage.historyWord.put('cacheList', historyList);
    }

    searchFocusNode.unfocus();

    await Get.toNamed(
      '/searchResult',
      parameters: {
        'keyword': controller.text,
      },
      arguments: initIndex,
    );
    searchFocusNode.requestFocus();
  }

  // 获取热搜关键词
  Future queryHotSearchList() async {
    loadingState.value = await SearchHttp.searchTrending(limit: 10);
  }

  Future queryRecommendList() async {
    recommendData.value = await SearchHttp.searchRecommend();
  }

  void onClickKeyword(String keyword) {
    controller.text = keyword;
    validateUid();

    searchSuggestList.clear();
    submit();
  }

  Future querySearchSuggest(String value) async {
    var result = await SearchHttp.searchSuggest(term: value);
    if (result['status']) {
      if (result['data'] is SearchSuggestModel) {
        searchSuggestList.value = result['data'].tag;
      }
    }
  }

  onLongSelect(word) {
    historyList.remove(word);
    GStorage.historyWord.put('cacheList', historyList);
  }

  onClearHistory() {
    showConfirmDialog(
      context: Get.context!,
      title: '确定清空搜索历史？',
      onConfirm: () {
        historyList.clear();
        GStorage.historyWord.put('cacheList', []);
      },
    );
  }

  @override
  void onClose() {
    searchFocusNode.dispose();
    controller.dispose();
    _debouncer.cancel();
    super.onClose();
  }
}
