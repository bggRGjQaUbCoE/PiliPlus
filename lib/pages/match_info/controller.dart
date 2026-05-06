import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/match.dart';
import 'package:PiliPlus/models_new/match/match_info/contest.dart';
import 'package:PiliPlus/pages/common/dyn/common_dyn_controller.dart';
import 'package:get/get.dart';

class MatchInfoController extends CommonDynController {
  @override
  final int oid = int.parse(Get.parameters['cid']!);
  @override
  final int replyType = 27;

  final Rx<LoadingState<MatchContest?>> infoState =
      LoadingState<MatchContest?>.loading().obs;

  @override
  void onInit() {
    super.onInit();
    getMatchInfo();
  }

  Future<void> getMatchInfo() async {
    final res = await MatchHttp.matchInfo(oid);
    if (res.isSuccess) {
      queryData();
    }
    infoState.value = res;
  }
}
