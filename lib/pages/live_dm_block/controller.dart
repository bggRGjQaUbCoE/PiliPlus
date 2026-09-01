import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/live/live_dm_block/shield_user_list.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class LiveDmBlockController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final roomId = Get.parameters['roomId']!;
  final LiveRoomController? liveRoomController =
      Get.arguments is LiveRoomController ? Get.arguments : null;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    queryData();
  }

  late final TabController tabController;

  final RxList<String> keywordList = <String>[].obs;
  final RxList<ShieldUserList> shieldUserList = <ShieldUserList>[].obs;

  Future<void> queryData() async {
    final res = await LiveHttp.getLiveInfoByUser(roomId);
    if (res case Success(:final response)) {
      keywordList.assignAll(response?.keywordList ?? const []);
      shieldUserList.assignAll(response?.shieldUserList ?? const []);
      updateLiveRoomRules();
    } else {
      res.toast();
    }
  }

  void updateLiveRoomRules() {
    liveRoomController?.updateBlockRules(
      keywordList,
      shieldUserList.map((e) => e.uid).whereType<int>(),
    );
  }

  Future<void> addShieldKeyword(bool isKeyword, String value) async {
    if (isKeyword) {
      final res = await LiveHttp.addShieldKeyword(keyword: value);
      if (res.isSuccess) {
        keywordList.insert(0, value);
        updateLiveRoomRules();
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
        updateLiveRoomRules();
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
        shieldUserList.removeAt(index);
        updateLiveRoomRules();
      } else {
        res.toast();
      }
    } else {
      final res = await LiveHttp.delShieldKeyword(keyword: item as String);
      if (res.isSuccess) {
        keywordList.removeAt(index);
        updateLiveRoomRules();
      } else {
        res.toast();
      }
    }
  }

  @override
  void onClose() {
    updateLiveRoomRules();
    tabController.dispose();
    super.onClose();
  }
}
