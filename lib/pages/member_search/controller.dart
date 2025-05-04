import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models/member/archive.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberSearchController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final scrollController = ScrollController();
  late final tabController = TabController(vsync: this, length: 2);
  final textEditingController = TextEditingController();
  final searchFocusNode = FocusNode();

  RxBool hasData = false.obs;

  late int mid;
  RxString uname = ''.obs;

  int archivePn = 1;
  RxInt archiveCount = (-1).obs;
  bool isEndArchive = false;
  Rx<LoadingState<List<VListItemModel>?>> archiveState =
      LoadingState<List<VListItemModel>?>.loading().obs;

  String offset = '';
  int dynamicPn = 1;
  RxInt dynamicCount = (-1).obs;
  bool isEndDynamic = false;
  Rx<LoadingState<List<DynamicItemModel>?>> dynamicState =
      LoadingState<List<DynamicItemModel>?>.loading().obs;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.parameters['mid']!);
    uname.value = Get.parameters['uname']!;
  }

  // 清空搜索
  void onClear() {
    if (textEditingController.value.text.isNotEmpty) {
      textEditingController.clear();
      hasData.value = false;
      searchFocusNode.requestFocus();
    } else {
      Get.back();
    }
  }

  //  提交搜索内容
  void submit() {
    if (textEditingController.text.isNotEmpty) {
      hasData.value = true;

      dynamicCount.value = -1;
      dynamicState.value = LoadingState.loading();
      refreshArchive();

      archiveCount.value = -1;
      archiveState.value = LoadingState.loading();
      refreshDynamic();
    }
  }

  Future refreshDynamic() async {
    offset = '';
    dynamicPn = 1;
    isEndDynamic = false;
    await searchDynamic();
  }

  Future refreshArchive() async {
    archivePn = 1;
    isEndArchive = false;
    await searchArchives();
  }

  Future searchDynamic([bool isRefresh = true]) async {
    if (isRefresh.not && isEndDynamic) return;
    dynamic res = await MemberHttp.memberDynamicSearch(
      mid: mid,
      pn: dynamicPn,
      offset: offset,
      keyword: textEditingController.text,
    );
    if (res['status']) {
      DynamicsDataModel data = res['data'];
      List<DynamicItemModel>? items = data.items;
      dynamicCount.value = data.total ?? 0;
      offset = data.offset ?? '';

      if (data.hasMore == false || items.isNullOrEmpty) {
        isEndDynamic = true;
        if (isRefresh) {
          dynamicState.value = LoadingState.success(items);
        }
        return;
      }

      if (isRefresh) {
        if (items!.length >= dynamicCount.value) {
          isEndDynamic = true;
        }
        dynamicState.value = LoadingState.success(items);
      } else if (dynamicState.value is Success) {
        List<DynamicItemModel> currentList = dynamicState.value.data!
          ..addAll(items!);
        if (currentList.length >= dynamicCount.value) {
          isEndDynamic = true;
        }
        dynamicState.refresh();
      }
      dynamicPn++;
    } else if (isRefresh) {
      dynamicState.value = LoadingState.error(res['msg']);
    }
  }

  // 搜索视频
  Future searchArchives([bool isRefresh = true]) async {
    if (isRefresh.not && isEndArchive) return;
    dynamic res = await MemberHttp.memberArchive(
      mid: mid,
      pn: archivePn,
      keyword: textEditingController.text,
      order: 'pubdate',
    );
    if (res['status']) {
      MemberArchiveDataModel data = res['data'];
      List<VListItemModel>? vlist = data.list?.vlist;
      archiveCount.value = data.page?['count'] ?? 0;

      if (vlist.isNullOrEmpty) {
        isEndArchive = true;
        if (isRefresh) {
          archiveState.value = LoadingState.success(vlist);
        }
        return;
      }

      if (isRefresh) {
        if (vlist!.length >= archiveCount.value) {
          isEndArchive = true;
        }
        archiveState.value = LoadingState.success(vlist);
      } else if (archiveState.value is Success) {
        List<VListItemModel> currentList = archiveState.value.data!
          ..addAll(vlist!);
        if (currentList.length >= archiveCount.value) {
          isEndArchive = true;
        }
        archiveState.refresh();
      }
      archivePn++;
    } else if (isRefresh) {
      archiveState.value = LoadingState.error(res['msg']);
    }
  }

  @override
  void onClose() {
    textEditingController.dispose();
    searchFocusNode.dispose();
    scrollController.dispose();
    tabController.dispose();
    super.onClose();
  }
}
