import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/live/live_dm_silent_type.dart';
import 'package:PiliPlus/models_new/live/live_dm_block/shield_user_list.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveDmBlockController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final roomId = Get.parameters['roomId']!;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    queryData();
  }

  late final TabController tabController;

  int? oldLevel;
  final RxInt level = 0.obs;
  final RxInt rank = 0.obs;
  final RxInt verify = 0.obs;
  final RxBool isEnable = false.obs;

  final RxList<String> keywordList = <String>[].obs;
  final RxList<ShieldUserList> shieldUserList = <ShieldUserList>[].obs;

  void updateValue() {
    isEnable.value = level.value != 0 || rank.value != 0 || verify.value != 0;
  }

  Future<void> queryData() async {
    final res = await LiveHttp.getLiveInfoByUser(roomId);
    if (res case Success(:final response)) {
      final shieldRules = response?.shieldRules;
      level.value = shieldRules?.level ?? 0;
      rank.value = shieldRules?.rank ?? 0;
      verify.value = shieldRules?.verify ?? 0;
      updateValue();

      if (response?.keywordList case final keywordList?) {
        this.keywordList.addAll(keywordList);
      }
      if (response?.shieldUserList case final shieldUserList?) {
        this.shieldUserList.addAll(shieldUserList);
      }
    } else {
      res.toast();
    }
  }

  Future<bool> setSilent(
    LiveDmSilentType type,
    int level, {
    VoidCallback? onError,
  }) async {
    final res = await LiveHttp.liveSetSilent(type: type.name, level: level);
    if (res.isSuccess) {
      switch (type) {
        case LiveDmSilentType.level:
          this.level.value = level;
        case LiveDmSilentType.rank:
          rank.value = level;
        case LiveDmSilentType.verify:
          verify.value = level;
      }
      updateValue();
      return true;
    } else {
      onError?.call();
      res.toast();
      return false;
    }
  }

  Future<void> setEnable(bool enable) async {
    if (enable == isEnable.value) {
      return;
    }
    final futures = enable
        ? [
            setSilent(LiveDmSilentType.rank, 1),
            setSilent(LiveDmSilentType.verify, 1),
          ]
        : [
            for (final e in LiveDmSilentType.values) setSilent(e, 0),
          ];
    final res = await Future.wait(futures);
    if (enable) {
      if (res.any((e) => e)) {
        isEnable.value = true;
      }
    } else {
      if (res.every((e) => e)) {
        isEnable.value = false;
      }
    }
  }

  Future<void> addShieldKeyword(bool isKeyword, String value) async {
    if (isKeyword) {
      final res = await LiveHttp.addShieldKeyword(keyword: value);
      if (res.isSuccess) {
        keywordList.insert(0, value);
      } else {
        res.toast();
      }
    } else {
      final res = await LiveHttp.liveShieldUser(
        uid: value,
        roomid: roomId,
        type: 1,
      );
      if (res case Success(:final response)) {
        shieldUserList.insert(0, response);
      } else {
        res.toast();
      }
    }
  }

  Future<void> onRemove(int index, Object item) async {
    assert(item is ShieldUserList || item is String);
    if (item is ShieldUserList) {
      final res = await LiveHttp.liveShieldUser(
        uid: item.uid!,
        roomid: roomId,
        type: 0,
      );
      if (res.isSuccess) {
        shieldUserList.removeFirstWhere((current) => current.uid == item.uid);
      } else {
        res.toast();
      }
    } else {
      final res = await LiveHttp.delShieldKeyword(keyword: item as String);
      if (res.isSuccess) {
        keywordList.removeFirstWhere((current) => current == item);
      } else {
        res.toast();
      }
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
