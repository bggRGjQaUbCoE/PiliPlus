import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/http/black.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models_new/blacklist/data.dart';
import 'package:PiliPlus/models_new/blacklist/list.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class BlackListController
    extends CommonListController<BlackListData, BlackListItem> {
  int? _total;
  final onlineBlackMids = GlobalData().onlineBlackMids;
  final localBlackMids = GlobalData().localBlackMids;
  final onlineCount = 0.obs;

  @override
  void onInit() {
    onlineCount.value = onlineBlackMids.length;
    super.onInit();
    if (Accounts.main.isLogin) {
      queryData();
    } else {
      loadingState.value = const Error('账号未登录');
    }
  }

  @override
  List<BlackListItem>? getDataList(BlackListData response) {
    _total = response.total;
    onlineCount.value = response.total ?? 0;
    return response.list;
  }

  @override
  void checkIsEnd(int length) {
    if (_total != null && length >= _total!) {
      isEnd = true;
    }
  }

  Future<bool> onRemove(BuildContext context, int index, name, mid) async {
    final confirm = await showConfirmDialog(
      context: context,
      title: Text('确定将 $name 移出黑名单？'),
    );
    if (confirm) {
      final result = await VideoHttp.relationMod(mid: mid, act: 6, reSrc: 11);
      if (result.isSuccess) {
        loadingState
          ..value.data!.removeAt(index)
          ..refresh();
        _total = (_total ?? 1) - 1;
        onlineCount.value = _total!;
        onlineBlackMids.remove(mid);
        if (!localBlackMids.contains(mid)) {
          GlobalData().blackMids.remove(mid);
        }
        Pref.blackMids = onlineBlackMids;
        SmartDialog.showToast('移除成功');
        return true;
      }
    }
    return false;
  }

  @override
  Future<LoadingState<BlackListData>> customGetData() =>
      BlackHttp.blackList(pn: page);

  @override
  void onClose() {
    super.onClose();
    if (loadingState.value case Success(:final response?)) {
      final mids = response.map((item) => item.mid!).toSet();
      onlineBlackMids.addAll(mids);
      GlobalData().blackMids.addAll(mids);
    }
    Pref.blackMids = onlineBlackMids;
  }
}
