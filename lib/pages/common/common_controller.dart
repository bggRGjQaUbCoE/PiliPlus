import 'dart:async';

import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract mixin class ScrollOrRefreshMixin {
  ScrollController get scrollController;

  void animateToTop() => scrollController.animToTop();

  Future<void> onRefresh();

  void toTopOrRefresh() {
    if (scrollController.hasClients) {
      if (scrollController.position.pixels == 0) {
        EasyThrottle.throttle(
            'topOrRefresh', const Duration(milliseconds: 500), onRefresh);
      } else {
        animateToTop();
      }
    }
  }
}

abstract class CommonController<R, T> extends GetxController
    with ScrollOrRefreshMixin {
  @override
  final ScrollController scrollController = ScrollController();

  late int currentPage = 1;
  bool isLoading = false;
  late bool isEnd = false;
  Rx<LoadingState> get loadingState;
  bool? hasFooter;

  Future<LoadingState<R>> customGetData();

  void handleListResponse(List<T> dataList) {}

  bool customHandleResponse(bool isRefresh, Success<R> response) {
    return false;
  }

  bool handleError(String? errMsg) {
    return false;
  }

  List<T>? getDataList(R response) {
    return response as List<T>?;
  }

  void checkIsEnd(int length) {}

  Future queryData([bool isRefresh = true]) async {
    if (isLoading || (isRefresh.not && isEnd)) return;
    isLoading = true;
    LoadingState<R> response = await customGetData();
    if (response is Success<R>) {
      if (!customHandleResponse(isRefresh, response)) {
        List<T>? dataList = getDataList(response.response);
        if (dataList.isNullOrEmpty) {
          isEnd = true;
          if (isRefresh) {
            loadingState.value = LoadingState<List<T>?>.success(dataList);
          } else if (hasFooter == true) {
            loadingState.refresh();
          }
          isLoading = false;
          return;
        }
        handleListResponse(dataList!);
        if (isRefresh) {
          checkIsEnd(dataList.length);
          loadingState.value = LoadingState<List<T>?>.success(dataList);
        } else if (loadingState.value is Success) {
          final list = (loadingState.value.data! as List<T>)..addAll(dataList);
          checkIsEnd(list.length);
          loadingState.refresh();
        }
      }
      currentPage++;
    } else {
      if (isRefresh &&
          handleError(response is Error ? response.errMsg : null).not) {
        loadingState.value = response;
      }
    }
    isLoading = false;
  }

  @override
  Future<void> onRefresh() async {
    currentPage = 1;
    isEnd = false;
    await queryData();
  }

  Future onLoadMore() async {
    await queryData(false);
  }

  Future onReload() async {
    loadingState.value = LoadingState.loading();
    await onRefresh();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
