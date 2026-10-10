import 'dart:async';

import 'package:PiliPlus/models/common/later_view_type.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:get/get.dart';

class LaterBaseController extends GetxController {
  int _changeVersion = 0;
  int get changeVersion => _changeVersion;

  bool _isVisible = false;
  bool _refreshScheduled = false;
  final Map<LaterViewType, Future<void> Function()> _refreshers = {};

  // A playback request can finish after its route has already been popped.
  static void notifyChanged() {
    if (Get.isRegistered<LaterBaseController>()) {
      Get.find<LaterBaseController>().markChanged();
    }
  }

  void markChanged() {
    _changeVersion++;
    _scheduleRefresh();
  }

  void setVisible(bool visible) {
    _isVisible = visible;
    if (visible) _scheduleRefresh();
  }

  void registerRefresh(LaterViewType type, Future<void> Function() refresh) {
    _refreshers[type] = refresh;
  }

  void unregisterRefresh(LaterViewType type, Future<void> Function() refresh) {
    if (_refreshers[type] == refresh) _refreshers.remove(type);
  }

  void _scheduleRefresh() {
    if (!_isVisible || _refreshScheduled || isClosed) return;
    _refreshScheduled = true;
    scheduleMicrotask(() {
      _refreshScheduled = false;
      if (!_isVisible || isClosed) return;
      for (final refresh in _refreshers.values.toList()) {
        unawaited(refresh());
      }
    });
  }

  @override
  void onClose() {
    _refreshers.clear();
    super.onClose();
  }

  RxBool enableMultiSelect = false.obs;
  RxInt checkedCount = 0.obs;

  RxList<int> counts = List.filled(LaterViewType.values.length, -1).obs;

  late double dx = 0;
  late final RxBool isPlayAll = Pref.enablePlayAll.obs;

  void setIsPlayAll(bool isPlayAll) {
    if (this.isPlayAll.value == isPlayAll) return;
    this.isPlayAll.value = isPlayAll;
    GStorage.setting.put(SettingBoxKey.enablePlayAll, isPlayAll);
  }
}
