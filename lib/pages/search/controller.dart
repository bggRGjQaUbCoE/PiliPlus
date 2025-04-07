import 'package:PiliPlus/common/widgets/dialog.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/search/suggest.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

class SSearchController extends GetxController {
  late final historyOff =
      '<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#000000"><path d="m785-289-58-58q16-29 24.5-63t8.5-70q0-117-81.5-198.5T480-760q-35 0-68.5 8.5T348-726l-59-59q43-26 91.5-40.5T480-840q75 0 140.5 28.5t114 77q48.5 48.5 77 114T840-480q0 53-14.5 101T785-289ZM520-554l-80-80v-46h80v126ZM792-56 672-176q-42 26-90 41t-102 15q-138 0-240.5-91.5T122-440h82q14 104 92.5 172T480-200q37 0 70.5-8.5T614-234L288-560H120v-168l-64-64 56-56 736 736-56 56Z"/></svg>';

  final searchFocusNode = FocusNode();
  final controller = TextEditingController();

  RxList<String> historyList = <String>[].obs;

  RxList<SearchSuggestItem> searchSuggestList = <SearchSuggestItem>[].obs;

  String hintText = '搜索';

  late bool enableHotKey;

  Rx<LoadingState> loadingState = LoadingState.loading().obs;

  int initIndex = 0;

  RxBool showUidBtn = false.obs;

  final _debouncer = Debouncer(delay: const Duration(milliseconds: 200));
  late final searchSuggestion = GStorage.searchSuggestion;
  late final RxBool recordSearchHistory = GStorage.recordSearchHistory.obs;

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

    if (enableHotKey) {
      queryHotSearchList();
    }
  }

  void validateUid() {
    showUidBtn.value = RegExp(r'^\d+$').hasMatch(controller.text);
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
    dynamic result = await SearchHttp.hotSearchList();
    if (result['status']) {
      loadingState.value = LoadingState.success(result['data'].list);
    } else {
      loadingState.value = LoadingState.error(result['msg']);
    }
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
