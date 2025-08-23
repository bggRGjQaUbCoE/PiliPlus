import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/models/common/live_dm_silent_type.dart';
import 'package:PiliPlus/models_new/live/live_dm_block/shield_info.dart';
import 'package:PiliPlus/models_new/live/live_dm_block/shield_rules.dart';
import 'package:PiliPlus/models_new/live/live_dm_block/shield_user_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class LiveDmBlockController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final roomId = Get.parameters['roomId'];

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  late final TabController tabController = TabController(
    length: 2,
    vsync: this,
  );

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
    var res = await LiveHttp.getLiveInfoByUser(roomId!);
    if (res.isSuccess) {
      ShieldInfo? data = res.data;
      ShieldRules? shieldRules = data?.shieldRules;
      level.value = shieldRules?.level ?? 0;
      rank.value = shieldRules?.rank ?? 0;
      verify.value = shieldRules?.verify ?? 0;
      updateValue();

      if (data?.keywordList != null) {
        keywordList.addAll(data!.keywordList!);
      }
      if (data?.shieldUserList != null) {
        shieldUserList.addAll(data!.shieldUserList!);
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
    var res = await LiveHttp.liveSetSilent(type: type.name, level: level);
    if (res['status']) {
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
      SmartDialog.showToast(res['msg']);
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
            for (var e in LiveDmSilentType.values) setSilent(e, 0),
          ];
    var res = await Future.wait(futures);
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
      var res = await LiveHttp.addShieldKeyword(keyword: value);
      if (res['status']) {
        keywordList.insert(0, value);
      } else {
        SmartDialog.showToast(res['msg']);
      }
    } else {
      var res = await LiveHttp.liveShieldUser(
        uid: value,
        roomid: roomId!,
        type: 1,
      );
      if (res['status']) {
        shieldUserList.insert(
          0,
          ShieldUserList(
            uid: res['data']['uid'],
            uname: res['data']['uname'],
          ),
        );
      } else {
        SmartDialog.showToast(res['msg']);
      }
    }
  }

  Future<void> onRemove(int index, Object item) async {
    if (item is ShieldUserList) {
      var res = await LiveHttp.liveShieldUser(
        uid: item.uid!,
        roomid: roomId!,
        type: 0,
      );
      if (res['status']) {
        shieldUserList.removeAt(index);
      } else {
        SmartDialog.showToast(res['msg']);
      }
    } else {
      var res = await LiveHttp.delShieldKeyword(keyword: item as String);
      if (res['status']) {
        keywordList.removeAt(index);
      } else {
        SmartDialog.showToast(res['msg']);
      }
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
