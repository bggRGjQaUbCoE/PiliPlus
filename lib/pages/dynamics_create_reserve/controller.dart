import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_reserve_info/data.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/utils/nav.dart';

class CreateReserveController extends GetxController {
  CreateReserveController(this.sid);
  final int? sid;
  final RxInt subType = 0.obs;
  String key = Utils.generateRandomString(6);
  final RxString title = ''.obs;
  final now = DateTime.now();
  late final Rx<DateTime> date;
  late final end = now.copyWith(day: now.day + 90);
  final RxBool canCreate = false.obs;

  @override
  void onInit() {
    super.onInit();
    date = DateTime(now.year, now.month, now.day + 1, 20, 0).obs;
    if (sid != null) {
      queryData();
    }
  }

  void updateCanCreate() {
    canCreate.value = title.value.trim().isNotEmpty;
  }

  Future<void> queryData() async {
    final res = await DynamicsHttp.reserveInfo(sid: sid);
    if (res case Success(:final response)) {
      key = Utils.generateRandomString(6);
      title.value = response.title!;
      date.value = DateTime.fromMillisecondsSinceEpoch(
        response.livePlanStartTime! * 1000,
      );
      canCreate.value = true;
    } else {
      res.toast();
    }
  }

  Future<void> onCreate() async {
    final livePlanStartTime = date.value.millisecondsSinceEpoch ~/ 1000;
    final res = sid == null
        ? await DynamicsHttp.createReserve(
            title: title.value,
            subType: subType.value,
            livePlanStartTime: livePlanStartTime,
          )
        : await DynamicsHttp.updateReserve(
            sid: sid!,
            subType: subType.value,
            title: title.value,
            livePlanStartTime: livePlanStartTime,
          );
    if (res case Success(:final response)) {
      Nav.back(
        ReserveInfoData(
          id: response,
          title: title.value,
          livePlanStartTime: livePlanStartTime,
        ),
      );
    } else {
      res.toast();
    }
  }
}
