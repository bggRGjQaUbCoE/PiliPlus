part of 'package:PiliPlus/pages/live_room/controller.dart';

mixin _LiveMedalMixin on GetxController, _LiveDataMixin {
  late bool hasMedal = false;
  late final medal = Rxn<UinfoMedal>();
  late final FansMedalController medalController;

  late final String fansPanelUrl =
      'https://live.bilibili.com/p/html/live-app-fanspanel/index.html?roomId=$roomId&anchorId=$ruid&room_id=$roomId&anchor_id=$ruid';

  Future<bool> getUserMedal() async {
    if (isClosed) return false;

    final res = await LiveHttp.userMedalInfo(uid: mid, upId: ruid!);
    if (res case Success(:final response)) {
      _handleMedalInfo(response);
      return true;
    } else {
      return false;
    }
  }

  void _handleMedalInfo(Medal response, {bool isInit = false}) {
    hasMedal = response.hasMedal;
    final currShow = response.currShow;

    // autoWearMedal
    if (isInit && Pref.autoWearMedal) {
      final lookupV2 = response.lookupV2;
      final currWeared = response.currWearedV2;
      if (lookupV2 != null && lookupV2.ruid != currWeared?.ruid) {
        _autoWearMedal(currShow, lookupV2);
        return;
      }
    }

    medal.value = currShow;
  }

  Future<void> _autoWearMedal(UinfoMedal? currShow, UinfoMedal lookupV2) async {
    var id = lookupV2.id;
    if (id == null || id == 0) {
      final realLookupV2 = (await LiveHttp.userMedalInfo(
        uid: mid,
        upId: ruid!,
      )).dataOrNull?.lookupV2;
      if (isClosed) return;
      id = realLookupV2?.id;
      if (realLookupV2 == null || id == null || id == 0) {
        medal.value = currShow;
        return;
      }
      lookupV2 = realLookupV2;
    }
    final res = await LiveHttp.wearFansMedal(medalId: id);
    if (isClosed) return;
    if (res.isSuccess) {
      medal.value = lookupV2;
    } else {
      medal.value = currShow;
    }
  }
}
