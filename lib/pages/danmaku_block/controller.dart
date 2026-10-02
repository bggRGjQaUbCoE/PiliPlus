import 'dart:convert';

import 'package:PiliPlus/http/danmaku_block.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/dm_block_type.dart';
import 'package:PiliPlus/models/user/danmaku_block.dart';
import 'package:archive/archive.dart' show getCrc32;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class DanmakuBlockController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final List<RxList<SimpleRule>> rules = List.generate(
    DmBlockType.values.length,
    (_) => <SimpleRule>[].obs,
  );

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    queryDanmakuFilter();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> queryDanmakuFilter() async {
    SmartDialog.showLoading(msg: '正在同步弹幕屏蔽规则……');
    final result = await DanmakuFilterHttp.danmakuFilter();
    SmartDialog.dismiss();
    if (result case Success(:final response)) {
      rules[0].addAll(response.rule);
      rules[1].addAll(response.rule1);
      rules[2].addAll(response.rule2);
      if (response.toast case final toast?) {
        SmartDialog.showToast(toast);
      }
    } else {
      result.toast();
    }
  }

  Future<void> danmakuFilterDel(int tabIndex, int itemIndex, int id) async {
    SmartDialog.showLoading(msg: '正在删除弹幕屏蔽规则……');
    final res = await DanmakuFilterHttp.danmakuFilterDel(ids: id);
    SmartDialog.dismiss();
    if (res.isSuccess) {
      rules[tabIndex].removeAt(itemIndex);
      SmartDialog.showToast('删除成功');
    } else {
      res.toast();
    }
  }

  Future<void> danmakuFilterAdd({
    required String filter,
    required int type,
  }) async {
    if (type == 2) {
      filter = getCrc32(ascii.encode(filter), 0).toRadixString(16);
    }
    SmartDialog.showLoading(msg: '正在添加弹幕屏蔽规则……');
    final res = await DanmakuFilterHttp.danmakuFilterAdd(
      filter: filter,
      type: type,
    );
    SmartDialog.dismiss();
    if (res case Success(:final response)) {
      rules[type].add(response);
      SmartDialog.showToast('添加成功');
    } else {
      res.toast();
    }
  }

  List<Map<String, dynamic>> exportRules() {
    return [
      for (final list in rules)
        for (final rule in list)
          {'id': rule.id, 'type': rule.type, 'filter': rule.filter, 'opened': true},
    ];
  }

  Future<void> importDanmakuFilter(List<dynamic> incoming) async {
    final incomingRules = incoming
        .whereType<Map<String, dynamic>>()
        .map((e) => (type: (e['type'] as num).toInt(), filter: e['filter'] as String))
        .toList();

    final existing = [
      for (int t = 0; t < rules.length; t++)
        for (final rule in rules[t]) (type: t, filter: rule.filter, id: rule.id),
    ];

    final incomingSet = {for (final r in incomingRules) (r.type, r.filter)};
    final existingMap = {for (final r in existing) (r.type, r.filter): r.id};

    final toDelete = existing.where((r) => !incomingSet.contains((r.type, r.filter))).toList();
    final toAdd = incomingRules.where((r) => !existingMap.containsKey((r.type, r.filter))).toList();

    if (toDelete.isEmpty && toAdd.isEmpty) {
      SmartDialog.showToast('规则已是最新，无需同步');
      return;
    }

    SmartDialog.showLoading(msg: '正在同步弹幕屏蔽规则……');
    int deleted = 0;
    int added = 0;

    for (final r in toDelete) {
      final res = await DanmakuFilterHttp.danmakuFilterDel(ids: r.id);
      if (res.isSuccess) {
        deleted++;
        final list = rules[r.type];
        final idx = list.indexWhere((e) => e.id == r.id);
        if (idx != -1) list.removeAt(idx);
      }
    }

    for (final r in toAdd) {
      String filter = r.filter;
      final res = await DanmakuFilterHttp.danmakuFilterAdd(
        filter: filter,
        type: r.type,
      );
      if (res case Success(:final response)) {
        rules[r.type].add(response);
        added++;
      }
    }

    SmartDialog.dismiss();
    SmartDialog.showToast('同步完成：新增 $added 条，删除 $deleted 条');
  }
}
