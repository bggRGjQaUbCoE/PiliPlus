import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart'
    show BaseMultiSelectMixin;
import 'package:PiliPlus/pages/common/search/common_search_controller.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/widgets.dart' show Text;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class DownloadSearchController
    extends
        CommonSearchController<
          List<BiliDownloadEntryInfo>,
          BiliDownloadEntryInfo
        >
    with BaseMultiSelectMixin<BiliDownloadEntryInfo> {
  final _downloadService = Get.find<DownloadService>();

  @override
  List<BiliDownloadEntryInfo> get list => loadingState.value.data!;
  @override
  Rx<LoadingState<List<BiliDownloadEntryInfo>?>> get state => loadingState;

  @override
  Future<LoadingState<List<BiliDownloadEntryInfo>>> customGetData() async {
    final text = editController.text.toLowerCase();
    return Success(
      _downloadService.downloadList
          .where(
            (e) =>
                e.title.toLowerCase().contains(text) ||
                e.showTitle.toLowerCase().contains(text) ||
                (e.ownerName?.toLowerCase().contains(text) ?? false),
          )
          .toList(),
    );
  }

  Future<void> onRemoveSingle(BiliDownloadEntryInfo entry) async {
    if (!await _downloadService.deleteDownload(
      entry: entry,
      removeList: true,
    )) {
      return;
    }
    loadingState.value.data?.remove(entry);
    loadingState.refresh();
    await GStorage.watchProgress.delete(entry.cid.toString());
  }

  @override
  void onRemove() {
    showConfirmDialog(
      context: Get.context!,
      title: const Text('确定删除选中视频？'),
      onConfirm: () async {
        SmartDialog.showLoading();
        final allChecked = this.allChecked.toSet();
        for (final entry in allChecked) {
          if (await _downloadService.deleteDownload(
            entry: entry,
            removeList: true,
            refresh: false,
          )) {
            loadingState.value.data?.remove(entry);
            await GStorage.watchProgress.delete(entry.cid.toString());
          }
        }
        loadingState.refresh();
        _downloadService.flagNotifier.refresh();
        if (enableMultiSelect.value) {
          rxCount.value = 0;
          enableMultiSelect.value = false;
        }
        SmartDialog.dismiss();
      },
    );
  }
}
