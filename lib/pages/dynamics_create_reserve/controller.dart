import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_reserve_info/data.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:get/get.dart';

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
    var res = await DynamicsHttp.reserveInfo(sid: sid!);
    if (res.isSuccess) {
      ReserveInfoData data = res.data;
      key = Utils.generateRandomString(6);
      title.value = data.title!;
      date.value = DateTime.fromMillisecondsSinceEpoch(
        data.livePlanStartTime! * 1000,
      );
      canCreate.value = true;
    } else {
      res.toast();
    }
  }

  Future<void> onCreate() async {
    final livePlanStartTime = date.value.millisecondsSinceEpoch ~/ 1000;
    var res = sid == null
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
    if (res.isSuccess) {
      Get.back(
        result: ReserveInfoData(
          id: res.data,
          title: title.value,
          livePlanStartTime: livePlanStartTime,
        ),
      );
    } else {
      res.toast();
    }
  }
}
