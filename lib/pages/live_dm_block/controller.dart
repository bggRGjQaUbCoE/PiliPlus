import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/live/live_dm_block/shield_user_list.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class LiveDmBlockController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final roomId = Get.parameters['roomId']!;
  LiveRoomController? _controller;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is LiveRoomController) {
      _controller = args;
    }
    tabController = TabController(length: 2, vsync: this);
    queryData();
  }

  late final TabController tabController;

  bool _isLoaded = false;
  final RxList<String> keywordList = <String>[].obs;
  final RxList<ShieldUserList> shieldUserList = <ShieldUserList>[].obs;

  Future<void> queryData() async {
    final res = await LiveHttp.getLiveInfoByUser(roomId);
    if (res case Success(:final response)) {
      _isLoaded = true;
      if (response == null) return;
      if (response.keywordList case final list? when list.isNotEmpty) {
        keywordList.addAll(list);
      }
      if (response.shieldUserList case final list? when list.isNotEmpty) {
        shieldUserList.addAll(list);
      }
    } else {
      res.toast();
    }
  }

  void _updateLiveRoomRules() {
    if (_isLoaded && _controller != null) {
      _controller!.updateBlockRules(
        keywordList,
        shieldUserList.map((e) => e.uid).toSet(),
      );
    }
    _controller = null;
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
        uid: item.uid,
        roomid: roomId,
        type: 0,
      );
      if (res.isSuccess) {
        shieldUserList.removeAt(index);
      } else {
        res.toast();
      }
    } else {
      final res = await LiveHttp.delShieldKeyword(keyword: item as String);
      if (res.isSuccess) {
        keywordList.removeAt(index);
      } else {
        res.toast();
      }
    }
  }

  @override
  void onClose() {
    _updateLiveRoomRules();
    tabController.dispose();
    super.onClose();
  }
}
