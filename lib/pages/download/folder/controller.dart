import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart'
    show BaseMultiSelectMixin;
import 'package:PiliPlus/pages/download/utils/cache_delete_confirm.dart';
import 'package:PiliPlus/services/download/download_collection_service.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:get/get.dart';

class DownloadFolderDetailController extends GetxController
    with BaseMultiSelectMixin<BiliDownloadEntryInfo> {
  DownloadFolderDetailController(this.folderId);

  final String folderId;

  final downloadService = Get.find<DownloadService>();
  final collectionService = Get.find<DownloadCollectionService>();

  final entries = RxList<BiliDownloadEntryInfo>();
  final title = ''.obs;

  @override
  List<BiliDownloadEntryInfo> get list => entries;

  @override
  RxList<BiliDownloadEntryInfo> get state => entries;

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
    final folder = collectionService.getFolder(folderId);
    title.value = folder?.title ?? '';
    entries.value = collectionService.resolveFolderEntries(folderId);
    rxCount.value = allChecked.length;
    if (checkedCount == 0) {
      enableMultiSelect.value = false;
    }
  }

  @override
  void onRemove() {
    confirmRemoveEntriesFromFolder(
      context: Get.context!,
      collectionService: collectionService,
      downloadService: downloadService,
      folderId: folderId,
      entries: allChecked,
    ).then((changed) {
      if (changed) {
        handleSelect();
      }
    });
  }
}
