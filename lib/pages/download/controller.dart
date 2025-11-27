import 'dart:async';

import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/models_new/download/download_info.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart'
    show BaseMultiSelectMixin;
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class DownloadPageController extends GetxController
    with BaseMultiSelectMixin<DownloadPageInfo> {
  final _downloadService = Get.find<DownloadService>();
  final pages = RxList<DownloadPageInfo>();
  final flag = RxInt(0);

  @override
  List<DownloadPageInfo> get list => pages;
  @override
  RxList<DownloadPageInfo> get state => pages;

  @override
  void onInit() {
    super.onInit();
    _loadList();
    _downloadService.flagNotifier.add(_loadList);
  }

  @override
  void onClose() {
    _downloadService.flagNotifier.remove(_loadList);
    super.onClose();
  }

  Future<void> _loadList() async {
    await _downloadService.waitForInitialization;
    if (isClosed) return;
    if (_downloadService.downloadList.isEmpty) {
      pages.clear();
      return;
    }
    final list = <DownloadPageInfo>[];
    for (final entry in _downloadService.downloadList) {
      final pageId = entry.pageId;
      final page = list.firstWhereOrNull((e) => e.pageId == pageId);
      if (page != null) {
        final aSortKey = entry.sortKey;
        final bSortKey = page.sortKey;
        if (aSortKey < bSortKey) {
          page
            ..cover = entry.cover
            ..sortKey = aSortKey;
        }
        page.entrys.add(entry);
      } else {
        list.add(
          DownloadPageInfo(
            pageId: pageId,
            dirPath: entry.pageDirPath,
            title: entry.title,
            cover: entry.cover,
            sortKey: entry.sortKey,
            seasonType: entry.ep?.seasonType,
            entrys: [entry],
          ),
        );
      }
    }
    pages.value = list;
    flag.value++;
  }

  @override
  void onRemove() {
    showConfirmDialog(
      context: Get.context!,
      title: '确定删除选中视频？',
      onConfirm: () async {
        SmartDialog.showLoading();
        final allChecked = this.allChecked.toList();
        final watchProgress = GStorage.watchProgress;
        for (var page in allChecked) {
          await watchProgress.deleteAll(
            page.entrys.map((e) => e.cid.toString()),
          );
          await _downloadService.deletePage(
            pageDirPath: page.dirPath,
            refresh: false,
          );
        }
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
