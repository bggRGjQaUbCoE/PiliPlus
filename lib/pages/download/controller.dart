import 'dart:async';

import 'package:PiliPlus/models_new/download/download_info.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:get/get.dart';

class DownloadPageController extends GetxController {
  final _downloadService = Get.find<DownloadService>();
  final pages = RxList<DownloadPageInfo>();
  final flag = RxInt(0);

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
        if (!entry.isCompleted) {
          if (page.entry case final lastEntry?) {
            if (aSortKey < lastEntry.sortKey) {
              page.entry = entry;
            }
          } else {
            page.entry = entry;
          }
        }
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
            entry: entry.isCompleted ? null : entry,
          ),
        );
      }
    }
    pages.value = list;
    flag.value++;
  }
}
