import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/msg.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/pages/dynamics/controller.dart';
import 'package:PiliPlus/pages/main/controller.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class DynamicsTabController
    extends CommonListController<DynamicsDataModel, DynamicItemModel>
    with AccountMixin {
  DynamicsTabController({required this.dynamicsType});
  final DynamicsTabType dynamicsType;

  String? offset;

  late final mainController = Get.find<MainController>();
  final dynamicsController = Get.find<DynamicsController>();

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  Future<void> onRefresh() {
    if (dynamicsType == .all) {
      mainController.setDynCount();
    }
    offset = null;
    return super.onRefresh();
  }

  @override
  List<DynamicItemModel>? getDataList(DynamicsDataModel response) {
    offset = response.offset;
    return response.items;
  }

  @override
  Future<LoadingState<DynamicsDataModel>> customGetData() =>
      DynamicsHttp.followDynamic(
        offset: offset,
        type: dynamicsType,
        hostMid: dynamicsController.hostMid,
        tempBannedList: dynamicsController.tempBannedList,
      );

  Future<void> onRemove(int index, dynamic dynamicId) async {
    final res = await MsgHttp.removeDynamic(dynIdStr: dynamicId);
    if (res.isSuccess) {
      loadingState
        ..value.data!.removeAt(index)
        ..refresh();
      SmartDialog.showToast('删除成功');
    } else {
      res.toast();
    }
  }

  @override
  Future<void> onReload() {
    scrollController.jumpToTop();
    return super.onReload();
  }

  void onBlock(int index) {
    if (dynamicsType != .up) {
      loadingState
        ..value.data!.removeAt(index)
        ..refresh();
    }
  }

  void onAddBanWords(List<String> keywords) {
    final validKeywords = keywords
        .map((k) => k.trim())
        .where((k) => k.isNotEmpty && !k.contains('|'))
        .toList();
    if (validKeywords.isEmpty) return;

    // 读取当前屏蔽词列表（存储原始值，不转义）
    String banWord = GStorage.setting.get(
      SettingBoxKey.banWordForDyn,
      defaultValue: '',
    );
    final words = banWord.isNotEmpty ? banWord.split('|') : <String>[];
    final existingLower = words.map((w) => w.toLowerCase()).toSet();

    // 过滤出真正新增的关键词（含批次内大小写去重）
    final newKeywords = <String>[];
    for (final keyword in validKeywords) {
      final lower = keyword.toLowerCase();
      if (!existingLower.contains(lower)) {
        newKeywords.add(keyword);
        existingLower.add(lower);
      }
    }

    if (newKeywords.isEmpty) {
      SmartDialog.showToast('所选关键词已存在屏蔽列表中');
      return;
    }

    // 存储原始关键词，不转义
    final newValue = banWord.isEmpty
        ? newKeywords.join('|')
        : '$banWord|${newKeywords.join('|')}';
    GStorage.setting.put(SettingBoxKey.banWordForDyn, newValue);
    // 构造 RegExp 时对每段转义，防止特殊字符破坏匹配规则
    final escapedPattern = newValue
        .split('|')
        .where((w) => w.isNotEmpty)
        .map(RegExp.escape)
        .join('|');
    DynamicsDataModel.banWordForDyn = RegExp(escapedPattern, caseSensitive: false);
    DynamicsDataModel.enableFilter = escapedPattern.isNotEmpty;
    SmartDialog.showToast('已添加 ${newKeywords.length} 个屏蔽词');
    // 刷新列表，重新过滤
    onRefresh();
  }

  void onUnfold(DynamicItemModel item, int index) {
    try {
      final list = loadingState.value.data!;
      final ids = item.modules.moduleFold!.ids!;
      final flag = index + ids.length + 1;
      for (int i = index + 1; i < flag; i++) {
        list[i].visible = true;
      }
      item.modules.moduleFold = null;
      loadingState.refresh();
    } catch (_) {}
  }

  @override
  void onChangeAccount(bool isLogin) => onReload();
}
