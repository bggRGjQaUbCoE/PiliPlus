import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/download/download_collection.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart'
    show BaseMultiSelectMixin;
import 'package:PiliPlus/pages/download/utils/cache_delete_confirm.dart';
import 'package:PiliPlus/services/download/download_collection_service.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/widgets.dart' show Text;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class DownloadPageController extends GetxController
    with BaseMultiSelectMixin<BiliDownloadEntryInfo> {
  final downloadService = Get.find<DownloadService>();
  final collectionService = Get.find<DownloadCollectionService>();

  final allVideos = RxList<BiliDownloadEntryInfo>();
  final folders = RxList<DownloadFolder>();
  final continueTarget = Rxn<DownloadContinueTarget>();

  @override
  List<BiliDownloadEntryInfo> get list => allVideos;

  @override
  RxList<BiliDownloadEntryInfo> get state => allVideos;

  @override
  void onInit() {
    super.onInit();
    _loadData();
    collectionService.flagNotifier.add(_loadData);
  }

  @override
  void onClose() {
    collectionService.flagNotifier.remove(_loadData);
    super.onClose();
  }

  Future<void> _loadData() async {
    await Future.wait([
      downloadService.waitForInitialization,
      collectionService.waitForInitialization,
    ]);
    if (isClosed) {
      return;
    }
    allVideos.value = collectionService.resolveAllEntries();
    folders.value = collectionService.folders;
    continueTarget.value = collectionService.resolveLastLocalPlayed();
    rxCount.value = allChecked.length;
    if (checkedCount == 0) {
      enableMultiSelect.value = false;
    }
  }

  Future<void> refreshContinueTarget() async {
    await Future.wait([
      downloadService.waitForInitialization,
      collectionService.waitForInitialization,
    ]);
    if (isClosed) {
      return;
    }
    continueTarget.value = collectionService.resolveLastLocalPlayed();
  }

  List<BiliDownloadEntryInfo> resolveFolderEntries(String folderId) =>
      collectionService.resolveFolderEntries(folderId);

  @override
  void onRemove() {
    showConfirmDialog(
      context: Get.context!,
      title: const Text('确定删除选中视频？'),
      onConfirm: () async {
        SmartDialog.showLoading();
        final selected = allChecked.toSet();
        for (final entry in selected) {
          await GStorage.watchProgress.delete(entry.cid.toString());
          await collectionService.clearLastLocalPlayedIfCid(entry.cid);
          await downloadService.deleteDownload(
            entry: entry,
            removeList: true,
            refresh: false,
          );
        }
        downloadService.flagNotifier.refresh();
        handleSelect();
        SmartDialog.dismiss();
      },
    );
  }
}

class DownloadFolderSelectController extends GetxController
    with BaseMultiSelectMixin<DownloadFolder> {
  DownloadFolderSelectController(this.pageController);

  final DownloadPageController pageController;

  @override
  List<DownloadFolder> get list => pageController.folders;

  @override
  RxList<DownloadFolder> get state => pageController.folders;

  @override
  void onRemove() {
    confirmDeleteFolders(
      context: Get.context!,
      collectionService: pageController.collectionService,
      downloadService: pageController.downloadService,
      folders: allChecked,
    ).then((changed) {
      if (changed) {
        handleSelect();
      }
    });
  }
}
