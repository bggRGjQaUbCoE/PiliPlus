import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models/dynamics/vote_model.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/widgets.dart' show Text;
import 'package:get/get.dart';

class CreateVoteController extends GetxController {
  CreateVoteController(this.voteId);
  final int? voteId;

  String key = Utils.generateRandomString(6);
  final RxString title = ''.obs;
  final RxString desc = ''.obs;
  final RxInt type = 0.obs;
  final RxList<Option> options = <Option>[
    Option(optDesc: '', imgUrl: ''),
    Option(optDesc: '', imgUrl: ''),
  ].obs;
  final RxInt choiceCnt = 1.obs;
  final now = DateTime.now();
  late final end = now.copyWith(day: now.day + 90);
  late Rx<DateTime> endtime;
  final RxBool canCreate = false.obs;

  void updateCanCreate() {
    if (type.value == 0) {
      canCreate.value =
          title.value.isNotEmpty &&
          options.every((e) => e.optDesc?.isNotEmpty == true);
    } else {
      canCreate.value =
          title.value.isNotEmpty &&
          options.every(
            (e) =>
                e.optDesc?.isNotEmpty == true && e.imgUrl?.isNotEmpty == true,
          );
    }
  }

  @override
  void onInit() {
    super.onInit();
    endtime = DateTime(
      now.year,
      now.month,
      now.day + 1,
      now.hour,
      now.minute,
    ).obs;
    if (voteId != null) {
      queryData();
    }
  }

  Future<void> queryData() async {
    final res = await DynamicsHttp.voteInfo(voteId);
    if (res case Success(:final response)) {
      key = Utils.generateRandomString(6);
      title.value = response.title!;
      desc.value = response.desc ?? '';
      type.value = response.options.first.imgUrl?.isNotEmpty == true ? 1 : 0;
      options.value = response.options;
      choiceCnt.value = response.choiceCnt!;
      endtime.value = DateTime.fromMillisecondsSinceEpoch(
        response.endTime! * 1000,
      );
      canCreate.value = true;
    } else {
      showConfirmDialog(
        context: Get.context!,
        title: Text(res.toString()),
        onConfirm: Get.back,
      );
    }
  }

  void onDel(int i) {
    options.removeAt(i);
    updateCanCreate();
    if (choiceCnt.value > options.length) {
      choiceCnt.value = options.length;
    }
  }

  Future<void> onCreate() async {
    final voteInfo = VoteInfo(
      title: title.value,
      desc: desc.value,
      type: type.value,
      duration: endtime.value.difference(now).inSeconds,
      options: options,
      onlyFansLevel: 0,
      choiceCnt: choiceCnt.value,
      votePublisher: Accounts.main.mid,
      voteId: voteId,
    );
    final res = await (voteId == null
        ? DynamicsHttp.createVote(voteInfo)
        : DynamicsHttp.updateVote(voteInfo));
    if (res case Success(:final response)) {
      voteInfo.voteId = response;
      Get.back(result: voteInfo);
    } else {
      res.toast();
    }
  }

  Future<void> onUpload(int index, String path) async {
    final res = await MsgHttp.uploadBfs(
      path: path,
      category: 'daily',
      biz: 'vote',
    );
    if (res case Success(:final response)) {
      options
        ..[index].imgUrl = response.imageUrl
        ..refresh();
      updateCanCreate();
    } else {
      res.toast();
    }
  }
}
