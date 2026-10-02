import 'dart:io' show Directory;

import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/download/download_collection.dart';
import 'package:PiliPlus/services/download/download_collection_service.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/cache_manager.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

enum _CacheChoice {
  relationOnly,
  withCache,
}

class _CacheDeleteResult {
  const _CacheDeleteResult({
    required this.failed,
  });

  final List<BiliDownloadEntryInfo> failed;
}

Future<bool> confirmRemoveEntriesFromFolder({
  required BuildContext context,
  required DownloadCollectionService collectionService,
  required DownloadService downloadService,
  required String folderId,
  required Iterable<BiliDownloadEntryInfo> entries,
}) async {
  final entryList = _uniqueEntries(entries);
  if (entryList.isEmpty) {
    return false;
  }
  final choice = await _showPrimaryDialog(
    context: context,
    title: '确定移出当前文件夹？',
    description: '只会移出文件夹分类，不会删除本地离线缓存。',
    cacheCount: entryList.length,
  );
  if (choice == null) {
    return false;
  }
  if (choice == _CacheChoice.relationOnly) {
    SmartDialog.showLoading();
    await collectionService.removeVideosFromFolder(
      folderId,
      entryList.map((item) => item.cid),
    );
    SmartDialog.dismiss();
    return true;
  }
  if (!context.mounted) {
    return false;
  }
  final confirmed = await _showCacheConfirmDialog(
    context: context,
    title: '同时删除本地离线缓存？',
    entries: entryList,
    otherFolderCount: _otherFolderCount(
      collectionService,
      entryList,
      excludedFolderIds: {folderId},
    ),
    confirmText: '删除缓存并移出',
  );
  if (!confirmed) {
    return false;
  }
  SmartDialog.showLoading();
  final result = await _deleteLocalCaches(
    downloadService: downloadService,
    collectionService: collectionService,
    entries: entryList,
  );
  SmartDialog.dismiss();
  if (result.failed.isNotEmpty) {
    SmartDialog.showToast(
      '${result.failed.length} 个本地离线缓存删除失败，已保留在文件夹中',
    );
  }
  return true;
}

Future<bool> confirmDeleteFolders({
  required BuildContext context,
  required DownloadCollectionService collectionService,
  required DownloadService downloadService,
  required Iterable<DownloadFolder> folders,
}) async {
  final folderList = folders.toList();
  if (folderList.isEmpty) {
    return false;
  }
  final folderIds = folderList.map((item) => item.id).toSet();
  final entries = _uniqueEntries(
    folderList.expand((folder) => collectionService.resolveFolderEntries(
      folder.id,
    )),
  );
  final choice = await _showPrimaryDialog(
    context: context,
    title: folderList.length == 1 ? '确定删除该文件夹？' : '确定删除选中文件夹？',
    description: '只会删除文件夹关联，不会删除本地离线缓存。',
    cacheCount: entries.length,
  );
  if (choice == null) {
    return false;
  }
  if (choice == _CacheChoice.relationOnly) {
    SmartDialog.showLoading();
    for (final folder in folderList) {
      await collectionService.deleteFolder(folder.id);
    }
    SmartDialog.dismiss();
    return true;
  }
  if (!context.mounted) {
    return false;
  }
  final confirmed = await _showCacheConfirmDialog(
    context: context,
    title: '同时删除本地离线缓存？',
    entries: entries,
    otherFolderCount: _otherFolderCount(
      collectionService,
      entries,
      excludedFolderIds: folderIds,
    ),
    confirmText: '删除缓存并删除文件夹',
  );
  if (!confirmed) {
    return false;
  }
  SmartDialog.showLoading();
  final result = await _deleteLocalCaches(
    downloadService: downloadService,
    collectionService: collectionService,
    entries: entries,
  );
  final failedCids = result.failed.map((item) => item.cid).toSet();
  for (final folder in folderList) {
    if (!folder.videoCids.any(failedCids.contains)) {
      await collectionService.deleteFolder(folder.id);
    }
  }
  SmartDialog.dismiss();
  if (result.failed.isNotEmpty) {
    SmartDialog.showToast(
      '${result.failed.length} 个本地离线缓存删除失败，已保留在文件夹中',
    );
  }
  return true;
}

Future<_CacheChoice?> _showPrimaryDialog({
  required BuildContext context,
  required String title,
  required String description,
  required int cacheCount,
}) {
  var deleteCache = false;
  return showDialog<_CacheChoice>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 8),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              value: deleteCache,
              onChanged: cacheCount == 0
                  ? null
                  : (value) => setState(() {
                      deleteCache = value ?? false;
                    }),
              title: const Text('同时删除本地离线缓存'),
              subtitle: cacheCount == 0
                  ? const Text('当前没有已完成的本地离线缓存')
                  : null,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              '取消',
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(
              result: deleteCache
                  ? _CacheChoice.withCache
                  : _CacheChoice.relationOnly,
            ),
            child: const Text('确认'),
          ),
        ],
      ),
    ),
  );
}

Future<bool> _showCacheConfirmDialog({
  required BuildContext context,
  required String title,
  required List<BiliDownloadEntryInfo> entries,
  required int otherFolderCount,
  required String confirmText,
}) {
  final messages = <String>[
    '删除 ${entries.length} 个本地离线缓存，释放约 ${_formatEntriesSize(entries)}。',
    if (otherFolderCount > 0) '其中 $otherFolderCount 个也存在于其他文件夹。',
    '删除后会从离线缓存列表和所有文件夹中消失，无法恢复。',
  ];
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Builder(
        builder: (context) {
          final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
            height: 1.3,
          );
          return Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: messages
                .map(
                  (message) => Text(
                    message,
                    style: textStyle,
                  ),
                )
                .toList(),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(
            '取消',
            style: TextStyle(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          child: Text(
            confirmText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ],
    ),
  ).then((value) => value ?? false);
}

Future<_CacheDeleteResult> _deleteLocalCaches({
  required DownloadService downloadService,
  required DownloadCollectionService collectionService,
  required List<BiliDownloadEntryInfo> entries,
}) async {
  final failed = <BiliDownloadEntryInfo>[];
  for (final entry in entries) {
    await downloadService.deleteDownload(
      entry: entry,
      removeList: false,
      refresh: false,
      downloadNext: false,
    );
    if (Directory(entry.entryDirPath).existsSync()) {
      failed.add(entry);
    } else {
      downloadService.downloadList.remove(entry);
      await GStorage.watchProgress.delete(entry.cid.toString());
      await collectionService.clearLastLocalPlayedIfCid(entry.cid);
    }
  }
  downloadService.flagNotifier.refresh();
  await collectionService.syncWithDownloads();
  return _CacheDeleteResult(
    failed: failed,
  );
}

List<BiliDownloadEntryInfo> _uniqueEntries(
  Iterable<BiliDownloadEntryInfo> entries,
) {
  final map = <int, BiliDownloadEntryInfo>{};
  for (final entry in entries) {
    map[entry.cid] = entry;
  }
  return map.values.toList();
}

int _otherFolderCount(
  DownloadCollectionService collectionService,
  List<BiliDownloadEntryInfo> entries, {
  required Set<String> excludedFolderIds,
}) {
  final otherFolders = collectionService.folders.where(
    (folder) => !excludedFolderIds.contains(folder.id),
  );
  return entries
      .where(
        (entry) => otherFolders.any(
          (folder) => folder.videoCids.contains(entry.cid),
        ),
      )
      .length;
}

String _formatEntriesSize(List<BiliDownloadEntryInfo> entries) {
  final total = entries.fold<int>(
    0,
    (previous, entry) => previous + entry.totalBytes,
  );
  return CacheManager.formatSize(total);
}
