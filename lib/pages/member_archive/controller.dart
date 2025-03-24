import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/models/member/archive.dart';

class MemberArchiveController extends GetxController {
  final ScrollController scrollController = ScrollController();
  late int mid;
  int pn = 1;
  int count = 0;
  RxMap<String, String> currentOrder = <String, String>{}.obs;
  static const List<Map<String, String>> orderList = [
    {'type': 'pubdate', 'label': '最新发布'},
    {'type': 'click', 'label': '最多播放'},
    {'type': 'stow', 'label': '最多收藏'},
  ];
  RxList<VListItemModel> archivesList = <VListItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.parameters['mid']!);
    currentOrder.value = orderList.first;
  }

  // 获取用户投稿
  Future getMemberArchive(type) async {
    if (type == 'init') {
      pn = 1;
    }
    var res = await MemberHttp.memberArchive(
      mid: mid,
      pn: pn,
      order: currentOrder['type']!,
    );
    if (res['status']) {
      if (type == 'init') {
        archivesList.value = res['data'].list.vlist;
      } else if (type == 'onLoad') {
        archivesList.addAll(res['data'].list.vlist);
      }
      count = res['data'].page['count'];
      pn += 1;
    } else {
      SmartDialog.showToast(res['msg']);
    }
    return res;
  }

  toggleSort() {
    List<String> typeList = orderList.map((e) => e['type']!).toList();
    int index = typeList.indexOf(currentOrder['type']!);
    if (index == orderList.length - 1) {
      currentOrder.value = orderList.first;
    } else {
      currentOrder.value = orderList[index + 1];
    }
    getMemberArchive('init');
  }

  // 上拉加载
  Future onLoad() => getMemberArchive('onLoad');

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
