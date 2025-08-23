import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models/dynamics/vote_model.dart';
import 'package:PiliPlus/models_new/upload_bfs/data.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
    var res = await DynamicsHttp.voteInfo(voteId!);
    if (res.isSuccess) {
      key = Utils.generateRandomString(6);
      final VoteInfo data = res.data;
      title.value = data.title!;
      desc.value = data.desc ?? '';
      type.value = data.options.first.imgUrl?.isNotEmpty == true ? 1 : 0;
      options.value = data.options;
      choiceCnt.value = data.choiceCnt!;
      endtime.value = DateTime.fromMillisecondsSinceEpoch(data.endTime! * 1000);
      canCreate.value = true;
    } else {
      showConfirmDialog(
        context: Get.context!,
        title: res.toString(),
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
    var res = voteId == null
        ? await DynamicsHttp.createVote(voteInfo)
        : await DynamicsHttp.updateVote(voteInfo);
    if (res.isSuccess) {
      voteInfo.voteId = res.data;
      Get.back(result: voteInfo);
    } else {
      res.toast();
    }
  }

  Future<void> onUpload(int index, XFile pickedFile) async {
    var res = await MsgHttp.uploadBfs(
      path: pickedFile.path,
      category: 'daily',
      biz: 'vote',
    );
    if (res['status']) {
      UploadBfsResData data = res['data'];
      options
        ..[index].imgUrl = data.imageUrl
        ..refresh();
      updateCanCreate();
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }
}
