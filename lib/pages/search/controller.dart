import 'dart:async' show StreamController, StreamSubscription;

import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/search/suggest.dart';
import 'package:PiliPlus/models_new/search/search_trending/data.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:stream_transform/stream_transform.dart';

mixin DebounceStreamMixin<T> {
  final Duration duration = const Duration(milliseconds: 200);
  StreamController<T>? ctr;
  StreamSubscription<T>? _sub;
  void onValueChanged(T value);

  void subInit() {
    _sub = (ctr = StreamController<T>()).stream
        .debounce(duration, trailing: true)
        .listen(onValueChanged);
  }

  void subDispose() {
    _sub?.cancel();
    ctr?.close();
    _sub = null;
    ctr = null;
  }
}

abstract class DebounceStreamState<T extends StatefulWidget, S> extends State<T>
    with DebounceStreamMixin<S> {
  @override
  void dispose() {
    subDispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    subInit();
  }
}

class BaseSearchController extends GetxController {
  final historyList = List<String>.from(
    GStorage.historyWord.get('cacheList') ?? const <String>[],
  ).obs;

  late final Rx<LoadingState<SearchTrendingData>> trendingState;

  @override
  void onInit() {
    super.onInit();

    trendingState = LoadingState<SearchTrendingData>.loading().obs;
    queryTrendingList();
  }

  // 获取热搜关键词
  Future<void> queryTrendingList() async {
    trendingState.value = await SearchHttp.searchTrending(limit: 10);
  }
}

class SSearchController extends GetxController
    with DebounceStreamMixin<String> {
  SSearchController(this.tag);
  final String tag;

  final searchFocusNode = FocusNode();
  final controller = TextEditingController();
  final _baseCtr = Get.putOrFind(BaseSearchController.new);

  String? hintText;

  int initIndex = 0;

  // uid
  final RxBool showUidBtn = false.obs;

  // history
  RxList<String> get historyList => _baseCtr.historyList;

  // suggestion
  late final RxList<SearchSuggestItem> searchSuggestList;

  // trending
  Rx<LoadingState<SearchTrendingData>> get trendingState =>
      _baseCtr.trendingState;

  Future<void> Function() get queryTrendingList => _baseCtr.queryTrendingList;

  @override
  void onInit() {
    super.onInit();
    final params = Get.parameters;
    hintText = params['hintText'];
    final text = params['text'];
    if (text != null) {
      controller.text = text;
    }

    subInit();
    searchSuggestList = <SearchSuggestItem>[].obs;
  }

  void validateUid() {
    showUidBtn.value = IdUtils.digitOnlyRegExp.hasMatch(controller.text);
  }

  void onChange(String value) {
    validateUid();
    if (value.isEmpty) {
      searchSuggestList.clear();
    } else {
      ctr!.add(value);
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
  Future<void> submit([_]) async {
    if (controller.text.isEmpty) {
      if (hintText.isNullOrEmpty) {
        return;
      }
      controller.text = hintText!;
      validateUid();
    }

    historyList
      ..remove(controller.text)
      ..insert(0, controller.text);
    GStorage.historyWord.put('cacheList', historyList);

    searchFocusNode.unfocus();
    await Get.toNamed(
      '/searchResult',
      parameters: {
        'tag': tag,
        'keyword': controller.text,
      },
      arguments: {
        'initIndex': initIndex,
        'fromSearch': true,
      },
    );
    searchFocusNode.requestFocus();
    if (PlatformUtils.isDesktop) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        controller.selection = TextSelection.collapsed(
          offset: controller.text.length,
        );
      });
    }
  }

  void onClickKeyword(String keyword) {
    controller.text = keyword;
    validateUid();

    searchSuggestList.clear();
    submit();
  }

  @override
  Future<void> onValueChanged(String value) async {
    final res = await SearchHttp.searchSuggest(term: value);
    if (res case Success(:final response)) {
      if (response.tag?.isNotEmpty == true) {
        searchSuggestList.value = response.tag!;
      }
    }
  }

  void onLongSelect(String word) {
    historyList.remove(word);
    GStorage.historyWord.put('cacheList', historyList);
  }

  void onClearHistory() {
    showConfirmDialog(
      context: Get.context!,
      title: const Text('确定清空搜索历史？'),
      onConfirm: () {
        historyList.clear();
        GStorage.historyWord.delete('cacheList');
      },
    );
  }

  @override
  void onClose() {
    subDispose();
    searchFocusNode.dispose();
    controller.dispose();
    super.onClose();
  }
}
