import 'dart:async' show unawaited;
import 'dart:io' show Directory;

import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/download/download_collection.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:collection/collection.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:get/get.dart';

class DownloadCollectionService extends GetxService {
  final _downloadService = Get.find<DownloadService>();

  static const _version = 1;
  static const _minContinueProgressMs = 5000;
  static const _completedThresholdMs = 400;

  final flagNotifier = SetNotifier();

  final List<DownloadFolder> _folders = <DownloadFolder>[];
  final List<String> _folderOrder = <String>[];
  final List<int> _allVideoOrder = <int>[];

  late final Future<void> waitForInitialization;

  List<DownloadFolder> get folders => _orderedFolders();

  @override
  void onInit() {
    super.onInit();
    waitForInitialization = _init();
  }

  Future<void> _init() async {
    _readFromStorage();
    await _downloadService.waitForInitialization;
    final customTitleChanged = _markExistingCustomTitles();
    final syncChanged = await _syncWithDownloads(notify: false);
    if (customTitleChanged && !syncChanged) {
      await _save();
    }
    _downloadService.flagNotifier.add(_handleDownloadRefresh);
    _downloadService.completedEntryNotifier.add(_handleDownloadCompleted);
  }

  @override
  void onClose() {
    _downloadService.flagNotifier.remove(_handleDownloadRefresh);
    _downloadService.completedEntryNotifier.remove(_handleDownloadCompleted);
    super.onClose();
  }

  Future<void> _handleDownloadRefresh() async {
    await waitForInitialization;
    final changed = await _syncWithDownloads(notify: false);
    if (!changed) {
      flagNotifier.refresh();
    }
  }

  Future<void> _handleDownloadCompleted(BiliDownloadEntryInfo entry) async {
    await waitForInitialization;
    final title = entry.autoFolderTitle?.trim();
    final sourceKey = entry.autoFolderSourceKey;
    if (title == null ||
        title.isEmpty ||
        sourceKey == null ||
        sourceKey.isEmpty) {
      return;
    }
    final folder = await ensureAutoFolder(
      title: title,
      sourceKey: sourceKey,
    );
    await addVideosToFolders([entry.cid], [folder.id]);
  }

  Future<void> syncWithDownloads({bool notify = true}) =>
      _syncWithDownloads(notify: notify);

  bool _isContinueProgress(int progressMs, int durationMs) =>
      durationMs > 0 &&
      progressMs > _minContinueProgressMs &&
      progressMs < durationMs - _completedThresholdMs;

  Future<void> updateLastLocalPlayed({
    required BiliDownloadEntryInfo entry,
    required int progressMs,
    required DownloadVideoPlayContext playContext,
  }) async {
    if (!_isContinueProgress(progressMs, entry.totalTimeMilli)) {
      await clearLastLocalPlayedIfCid(entry.cid);
      return;
    }
    final scope = playContext.scope == DownloadPlaylistScope.folder &&
            playContext.folderId?.isNotEmpty == true
        ? DownloadPlaylistScope.folder
        : DownloadPlaylistScope.all;
    final record = DownloadContinueRecord(
      cid: entry.cid,
      updatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      scope: scope,
      folderId: scope == DownloadPlaylistScope.folder
          ? playContext.folderId
          : null,
    );
    await GStorage.localCache.put(
      LocalCacheKey.lastLocalPlayed,
      record.toJson(),
    );
  }

  Future<void> clearLastLocalPlayed() =>
      GStorage.localCache.delete(LocalCacheKey.lastLocalPlayed);

  Future<void> clearLastLocalPlayedIfCid(int cid) async {
    final record = DownloadContinueRecord.fromJson(
      GStorage.localCache.get(LocalCacheKey.lastLocalPlayed),
    );
    if (record?.cid == cid) {
      await clearLastLocalPlayed();
    }
  }

  DownloadContinueTarget? resolveLastLocalPlayed() {
    final raw = GStorage.localCache.get(LocalCacheKey.lastLocalPlayed);
    final record = DownloadContinueRecord.fromJson(raw);
    if (raw != null && record == null) {
      unawaited(clearLastLocalPlayed());
      return null;
    }
    if (record == null) {
      return null;
    }

    final entry = _downloadService.downloadList.firstWhereOrNull(
      (item) => item.cid == record.cid && item.isCompleted,
    );
    if (entry == null ||
        entry.totalTimeMilli <= 0 ||
        !Directory(entry.entryDirPath).existsSync()) {
      unawaited(clearLastLocalPlayed());
      return null;
    }

    final progressMs = GStorage.watchProgress.get(record.cid.toString());
    if (progressMs == null ||
        !_isContinueProgress(progressMs, entry.totalTimeMilli)) {
      unawaited(clearLastLocalPlayed());
      return null;
    }

    var playContext = const DownloadVideoPlayContext.all();
    if (record.scope == DownloadPlaylistScope.folder) {
      final folderId = record.folderId;
      if (folderId == null || folderId.isEmpty) {
        unawaited(clearLastLocalPlayed());
        return null;
      }
      final folder = getFolder(folderId);
      if (folder != null && folder.videoCids.contains(record.cid)) {
        playContext = DownloadVideoPlayContext.folder(folderId);
      }
    }

    return DownloadContinueTarget(
      entry: entry,
      playContext: playContext,
      progressMs: progressMs,
      durationMs: entry.totalTimeMilli,
    );
  }

  bool _markExistingCustomTitles() {
    final autoTitles = <String, Set<String>>{};
    for (final entry in _downloadService.downloadList.followedBy(
      _downloadService.waitDownloadQueue,
    )) {
      final title = entry.autoFolderTitle?.trim();
      final sourceKey = entry.autoFolderSourceKey;
      if (title == null ||
          title.isEmpty ||
          sourceKey == null ||
          sourceKey.isEmpty) {
        continue;
      }
      (autoTitles[sourceKey] ??= <String>{}).add(title);
    }

    var changed = false;
    for (final folder in _folders) {
      final sourceKey = folder.sourceKey;
      if (folder.isCustomTitle || sourceKey == null || sourceKey.isEmpty) {
        continue;
      }
      final titles = autoTitles[sourceKey];
      if (titles != null && !titles.contains(folder.title.trim())) {
        folder.isCustomTitle = true;
        changed = true;
      }
    }
    return changed;
  }

  void _readFromStorage() {
    final raw = GStorage.localCache.get(LocalCacheKey.downloadCollections);
    if (raw is! Map) {
      return;
    }
    final json = raw.cast<dynamic, dynamic>();
    final folders = (json['folders'] as List? ?? const <dynamic>[])
        .whereType<Map>()
        .map((item) => DownloadFolder.fromJson(item.cast<String, dynamic>()))
        .toList();
    final folderOrder = (json['folderOrder'] as List? ?? const <dynamic>[])
        .whereType<String>()
        .toList();
    final allVideoOrder = (json['allVideoOrder'] as List? ?? const <dynamic>[])
        .whereType<int>()
        .toList();

    _folders
      ..clear()
      ..addAll(folders);
    _folderOrder
      ..clear()
      ..addAll(folderOrder);
    _allVideoOrder
      ..clear()
      ..addAll(allVideoOrder);
  }

  Future<void> _save() {
    return GStorage.localCache.put(LocalCacheKey.downloadCollections, {
      'version': _version,
      'folders': _folders.map((item) => item.toJson()).toList(),
      'folderOrder': _folderOrder,
      'allVideoOrder': _allVideoOrder,
    });
  }

  List<DownloadFolder> _orderedFolders() {
    final order = _folderOrder.toList();
    final remaining = _folders
        .where((folder) => !order.contains(folder.id))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final result = <DownloadFolder>[];
    for (final id in order) {
      final folder = _folders.firstWhereOrNull((item) => item.id == id);
      if (folder != null) {
        result.add(folder);
      }
    }
    result.addAll(remaining);
    return result;
  }

  DownloadFolder? getFolder(String folderId) =>
      _folders.firstWhereOrNull((item) => item.id == folderId);

  DownloadFolder? getFolderBySourceKey(String sourceKey) =>
      _folders.firstWhereOrNull((item) => item.sourceKey == sourceKey);

  List<BiliDownloadEntryInfo> resolveAllEntries([
    List<BiliDownloadEntryInfo>? entries,
  ]) {
    final list = List<BiliDownloadEntryInfo>.from(
      entries ?? _downloadService.downloadList,
    )..sort((a, b) => b.timeUpdateStamp.compareTo(a.timeUpdateStamp));
    if (_allVideoOrder.isEmpty) {
      return list;
    }
    return _orderEntries(list, _allVideoOrder, missingFirst: true);
  }

  List<BiliDownloadEntryInfo> resolveFolderEntries(
    String folderId, [
    List<BiliDownloadEntryInfo>? entries,
  ]) {
    final folder = getFolder(folderId);
    if (folder == null) {
      return const <BiliDownloadEntryInfo>[];
    }
    final source = entries ?? _downloadService.downloadList;
    final map = {for (final entry in source) entry.cid: entry};
    return folder.videoCids
        .map((cid) => map[cid])
        .whereType<BiliDownloadEntryInfo>()
        .toList();
  }

  String buildDefaultFolderTitle([String base = '新建文件夹']) {
    final titles = _folders.map((item) => item.title).toSet();
    if (!titles.contains(base)) {
      return base;
    }
    var index = 2;
    while (titles.contains('$base $index')) {
      index++;
    }
    return '$base $index';
  }

  Future<DownloadFolder> createFolder(String title) {
    return _createFolder(
      title: title,
      sourceKey: null,
    );
  }

  Future<DownloadFolder> ensureAutoFolder({
    required String title,
    required String sourceKey,
  }) async {
    await waitForInitialization;
    final existed = getFolderBySourceKey(sourceKey);
    if (existed != null) {
      if (!existed.isCustomTitle && existed.title != title) {
        existed.title = title;
        await _save();
        flagNotifier.refresh();
      }
      return existed;
    }
    return _createFolder(
      title: title,
      sourceKey: sourceKey,
    );
  }

  Future<DownloadFolder> _createFolder({
    required String title,
    required String? sourceKey,
  }) async {
    final folder = DownloadFolder(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      sourceKey: sourceKey,
      videoCids: <int>[],
    );
    _folders.add(folder);
    if (!_folderOrder.contains(folder.id)) {
      _folderOrder.add(folder.id);
    }
    await _save();
    flagNotifier.refresh();
    return folder;
  }

  Future<void> renameFolder(String folderId, String title) async {
    final folder = getFolder(folderId);
    if (folder == null || folder.title == title) {
      return;
    }
    folder.title = title;
    if (folder.sourceKey != null) {
      folder.isCustomTitle = true;
    }
    await _save();
    flagNotifier.refresh();
  }

  Future<void> deleteFolder(String folderId) async {
    _folders.removeWhere((item) => item.id == folderId);
    _folderOrder.removeWhere((item) => item == folderId);
    await _save();
    flagNotifier.refresh();
  }

  Future<void> reorderFolders(List<String> folderIds) async {
    _folderOrder
      ..clear()
      ..addAll(folderIds);
    await _save();
    flagNotifier.refresh();
  }

  Future<void> saveAllVideoOrder(List<int> cids) async {
    _allVideoOrder
      ..clear()
      ..addAll(cids);
    await _save();
    flagNotifier.refresh();
  }

  Future<void> resetAllVideoOrder() async {
    if (_allVideoOrder.isEmpty) {
      return;
    }
    _allVideoOrder.clear();
    await _save();
    flagNotifier.refresh();
  }

  Future<void> reorderFolderVideos(String folderId, List<int> cids) async {
    final folder = getFolder(folderId);
    if (folder == null) {
      return;
    }
    folder.videoCids
      ..clear()
      ..addAll(cids);
    await _save();
    flagNotifier.refresh();
  }

  Future<void> addVideosToFolders(
    Iterable<int> cids,
    Iterable<String> folderIds,
  ) async {
    final videoIds = cids.toList();
    if (videoIds.isEmpty) {
      return;
    }
    var changed = false;
    for (final folderId in folderIds) {
      final folder = getFolder(folderId);
      if (folder == null) {
        continue;
      }
      for (final cid in videoIds) {
        if (!folder.videoCids.contains(cid)) {
          folder.videoCids.add(cid);
          changed = true;
        }
      }
    }
    if (!changed) {
      return;
    }
    await _save();
    flagNotifier.refresh();
  }

  Future<void> removeVideosFromFolder(String folderId, Iterable<int> cids) async {
    final folder = getFolder(folderId);
    if (folder == null) {
      return;
    }
    final before = folder.videoCids.length;
    folder.videoCids.removeWhere(cids.toSet().contains);
    if (before == folder.videoCids.length) {
      return;
    }
    await _save();
    flagNotifier.refresh();
  }

  Future<bool> _syncWithDownloads({bool notify = true}) async {
    final validCids = _downloadService.downloadList
        .followedBy(_downloadService.waitDownloadQueue)
        .map((item) => item.cid)
        .toSet();
    var changed = false;

    final beforeOrderLength = _allVideoOrder.length;
    _allVideoOrder.removeWhere((cid) => !validCids.contains(cid));
    if (beforeOrderLength != _allVideoOrder.length) {
      changed = true;
    }

    for (final folder in _folders) {
      final before = folder.videoCids.length;
      folder.videoCids.removeWhere((cid) => !validCids.contains(cid));
      if (before != folder.videoCids.length) {
        changed = true;
      }
    }

    final validFolderIds = _folders.map((item) => item.id).toSet();
    final beforeFolderOrderLength = _folderOrder.length;
    _folderOrder.removeWhere((id) => !validFolderIds.contains(id));
    if (beforeFolderOrderLength != _folderOrder.length) {
      changed = true;
    }

    if (changed) {
      await _save();
    }
    if (notify) {
      flagNotifier.refresh();
    }
    return changed;
  }

  List<BiliDownloadEntryInfo> _orderEntries(
    List<BiliDownloadEntryInfo> list,
    List<int> order, {
    bool missingFirst = false,
  }) {
    final map = {for (final entry in list) entry.cid: entry};
    final missing = list.where((item) => !order.contains(item.cid)).toList();
    final ordered = order
        .map((cid) => map[cid])
        .whereType<BiliDownloadEntryInfo>()
        .toList();
    return missingFirst ? [...missing, ...ordered] : [...ordered, ...missing];
  }
}
