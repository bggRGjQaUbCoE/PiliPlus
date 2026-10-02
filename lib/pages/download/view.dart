import 'dart:io' show Platform;

import 'package:PiliPlus/common/widgets/appbar/appbar.dart';
import 'package:PiliPlus/common/widgets/flutter/popup_menu.dart';
import 'package:PiliPlus/common/widgets/flutter/pop_scope.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/download/download_collection.dart';
import 'package:PiliPlus/pages/common/fab_mixin.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/pages/download/controller.dart';
import 'package:PiliPlus/pages/download/detail/widgets/item.dart';
import 'package:PiliPlus/pages/download/folder/view.dart';
import 'package:PiliPlus/pages/download/folder_manage/view.dart';
import 'package:PiliPlus/pages/download/search/view.dart';
import 'package:PiliPlus/pages/download/sort/view.dart';
import 'package:PiliPlus/pages/download/utils/cache_delete_confirm.dart';
import 'package:PiliPlus/pages/download/utils/cache_export.dart';
import 'package:PiliPlus/pages/download/utils/open_download_entry.dart';
import 'package:PiliPlus/pages/download/widgets/folder_card.dart';
import 'package:PiliPlus/pages/download/widgets/folder_dialog.dart';
import 'package:PiliPlus/services/download/download_collection_service.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:collection/collection.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart'
    hide SliverGridDelegateWithMaxCrossAxisExtent;

enum _DownloadTab {
  videos('全部视频'),
  folders('文件夹')
  ;

  final String label;
  const _DownloadTab(this.label);
}

enum _DownloadSortAction {
  manual,
  reset,
}

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage>
    with TickerProviderStateMixin, BaseFabMixin, FabMixin {
  final _downloadService = Get.find<DownloadService>();
  final _collectionService = Get.find<DownloadCollectionService>();
  final _controller = Get.put(DownloadPageController());
  late final _folderSelectController = Get.put(
    DownloadFolderSelectController(_controller),
  );
  final _progress = ChangeNotifier();

  late final TabController _tabController;
  int _tabIndex = 0;
  bool _isOpeningContinue = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _DownloadTab.values.length,
      vsync: this,
    )..addListener(_handleTabChanged);
  }

  void _handleTabChanged() {
    if (_tabController.indexIsChanging) {
      return;
    }
    if (_tabIndex != _tabController.index && mounted) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
    if (_tabController.index != 0 && _controller.enableMultiSelect.value) {
      _controller.handleSelect();
    }
    if (_tabController.index != 1 &&
        _folderSelectController.enableMultiSelect.value) {
      _folderSelectController.handleSelect();
    }
    if (_tabController.index == 0 &&
        !_controller.enableMultiSelect.value &&
        _controller.continueTarget.value != null) {
      showFab();
    }
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_handleTabChanged)
      ..dispose();
    _progress.dispose();
    super.dispose();
  }

  Future<void> _createFolder() async {
    final title = await showDownloadFolderNameDialog(
      context: context,
      title: '新建文件夹',
      initialValue: _collectionService.buildDefaultFolderTitle(),
    );
    if (title == null) {
      return;
    }
    await _collectionService.createFolder(title);
    SmartDialog.showToast('创建成功');
  }

  Future<void> _renameFolder(DownloadFolder folder) async {
    final title = await showDownloadFolderNameDialog(
      context: context,
      title: '重命名文件夹',
      initialValue: folder.title,
    );
    if (title == null || title == folder.title) {
      return;
    }
    await _collectionService.renameFolder(folder.id, title);
    SmartDialog.showToast('重命名成功');
  }

  Future<void> _deleteFolder(DownloadFolder folder) async {
    await confirmDeleteFolders(
      context: context,
      collectionService: _collectionService,
      downloadService: _downloadService,
      folders: [folder],
    );
  }

  Future<void> _addSelectedToFolders() async {
    final folderIds = await showDownloadFolderPickerDialog(
      context: context,
      collectionService: _collectionService,
      title: '添加到文件夹',
    );
    if (folderIds == null || folderIds.isEmpty) {
      return;
    }
    await _collectionService.addVideosToFolders(
      _controller.allChecked.map((item) => item.cid),
      folderIds,
    );
    _controller.handleSelect();
    SmartDialog.showToast('已添加到文件夹');
  }

  Future<void> _exportSelected() async {
    final entries = _controller.allChecked.toList();
    _controller.handleSelect();
    await exportDownloadEntries(entries);
  }

  Future<void> _exportSelectedFolders() async {
    final folders = _folderSelectController.allChecked.toList();
    final seenCids = <int>{};
    final entries = folders
        .expand((folder) => _controller.resolveFolderEntries(folder.id))
        .where((entry) => seenCids.add(entry.cid))
        .toList();
    _folderSelectController.handleSelect();
    if (entries.isEmpty) {
      SmartDialog.showToast('选中的文件夹里没有可导出的缓存');
      return;
    }
    await exportDownloadEntries(entries);
  }

  Future<void> _openContinueTarget(DownloadContinueTarget target) async {
    if (_isOpeningContinue) {
      return;
    }
    setState(() {
      _isOpeningContinue = true;
    });
    try {
      await openDownloadEntry(
        entry: target.entry,
        playContext: target.playContext,
      );
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) {
        return;
      }
      _progress.notifyListeners();
      await _controller.refreshContinueTarget();
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningContinue = false;
        });
      }
    }
  }

  Future<void> _openAllSortPage() async {
    if (_controller.allVideos.isEmpty) {
      return;
    }
    await Get.to(
      DownloadVideoSortPage(
        title: '排序: 全部视频',
        entries: _controller.allVideos,
        onSave: _collectionService.saveAllVideoOrder,
      ),
    );
  }

  Future<void> _resetAllSort() async {
    await _collectionService.resetAllVideoOrder();
    SmartDialog.showToast('已按缓存时间显示');
  }

  void _onAllSortSelected(_DownloadSortAction action) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }
      if (action == _DownloadSortAction.manual) {
        await _openAllSortPage();
      } else {
        await _resetAllSort();
      }
    });
  }

  Future<void> _openFolderManagePage() async {
    await Get.to(
      DownloadFolderManagePage(collectionService: _collectionService),
    );
  }

  List<PopupMenuEntry<void>> _buildFolderQuickMenuItems(
    BuildContext context,
    BiliDownloadEntryInfo entry,
  ) {
    final folders = _controller.folders;
    if (folders.isEmpty) {
      return [
        CustomPopupMenuItem<void>(
          height: 38,
          child: const Text('添加到文件夹', style: TextStyle(fontSize: 13)),
          onTap: () async {
            final selectedIds = await showDownloadFolderPickerDialog(
              context: context,
              collectionService: _collectionService,
              title: '添加到文件夹',
            );
            if (selectedIds == null || selectedIds.isEmpty) {
              return;
            }
            await _collectionService.addVideosToFolders(
              [entry.cid],
              selectedIds,
            );
            SmartDialog.showToast('已添加到文件夹');
          },
        ),
      ];
    }
    return [
      const PopupMenuDivider(height: 8),
      ...folders.map(
        (folder) => CustomPopupMenuItem<void>(
          height: 38,
          child: Text(
            '添加到「${folder.title}」',
            style: const TextStyle(fontSize: 13),
          ),
          onTap: () async {
            await _collectionService.addVideosToFolders(
              [entry.cid],
              [folder.id],
            );
            SmartDialog.showToast('已添加到「${folder.title}」');
          },
        ),
      ),
      CustomPopupMenuItem<void>(
        height: 38,
        child: const Text('添加到其他文件夹', style: TextStyle(fontSize: 13)),
        onTap: () async {
          final selectedIds = await showDownloadFolderPickerDialog(
            context: context,
            collectionService: _collectionService,
            title: '添加到文件夹',
          );
          if (selectedIds == null || selectedIds.isEmpty) {
            return;
          }
          await _collectionService.addVideosToFolders(
            [entry.cid],
            selectedIds,
          );
          SmartDialog.showToast('已添加到文件夹');
        },
      ),
    ];
  }

  Widget _buildFolderMoreBtn(DownloadFolder folder) {
    return Builder(
      builder: (context) => IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.more_vert_outlined,
          color: Theme.of(context).colorScheme.outline,
          size: 18,
        ),
        onPressed: () {
          showStaticPositionMenu<int>(
            context: context,
            items: [
              const CustomPopupMenuItem(
                value: 0,
                height: 38,
                child: Text('重命名', style: TextStyle(fontSize: 13)),
              ),
              CustomPopupMenuItem(
                value: 1,
                height: 38,
                child: Text(
                  '删除',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          ).then((value) {
            if (value == 0) _renameFolder(folder);
            if (value == 1) _deleteFolder(folder);
          });
        },
      ),
    );
  }

  Widget _buildAllSortBtn() {
    return Builder(
      builder: (context) => IconButton(
        tooltip: '排序',
        icon: const Icon(Icons.sort),
        onPressed: () {
          showStaticPositionMenu<_DownloadSortAction>(
            context: context,
            items: const [
              CustomPopupMenuItem(
                value: _DownloadSortAction.manual,
                child: Text('手动排序'),
              ),
              CustomPopupMenuItem(
                value: _DownloadSortAction.reset,
                child: Text('按缓存时间'),
              ),
            ],
          ).then((value) {
            if (value != null) _onAllSortSelected(value);
          });
        },
      ),
    );
  }

  Widget _buildContinueFab() {
    return Obx(() {
      final target = _controller.continueTarget.value;
      final shouldShow =
          _tabIndex == 0 &&
          !_controller.enableMultiSelect.value &&
          target != null;
      if (!shouldShow) {
        return const SizedBox.shrink();
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showFab();
        }
      });
      final padding = MediaQuery.viewPaddingOf(context);
      return Positioned(
        right: padding.right + kFloatingActionButtonMargin,
        bottom: 0,
        child: SlideTransition(
          position: fabAnimation,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: padding.bottom + kFloatingActionButtonMargin,
            ),
            child: FloatingActionButton.extended(
              onPressed: _isOpeningContinue
                  ? null
                  : () => _openContinueTarget(target),
              label: const Text('继续播放'),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentTab = _DownloadTab.values[_tabIndex];
      final isVideoTab = currentTab == _DownloadTab.videos;
      final MultiSelectBase activeMultiSelectCtr = isVideoTab
          ? _controller
          : _folderSelectController;
      final enableMultiSelect = isVideoTab
          ? _controller.enableMultiSelect.value
          : _folderSelectController.enableMultiSelect.value;
      return popScope(
        canPop: !enableMultiSelect,
        onPopInvokedWithResult: (didPop, result) {
          if (enableMultiSelect) {
            activeMultiSelectCtr.handleSelect();
          }
        },
        child: SimpleScaffold(
          appBar: MultiSelectAppBarWidget(
            ctr: activeMultiSelectCtr,
            visible: enableMultiSelect,
            actions: isVideoTab
                ? [
                    TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () async {
                        final futures = _controller.allChecked
                            .map(
                              (e) => _downloadService.downloadDanmaku(
                                entry: e,
                                isUpdate: true,
                              ),
                            )
                            .toList();
                        _controller.handleSelect();
                        final res = await Future.wait(futures);
                        SmartDialog.showToast(
                          res.every((item) => item) ? '更新成功' : '更新失败',
                        );
                      },
                      child: Text(
                        '更新',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: _controller.checkedCount == 0
                          ? null
                          : _addSelectedToFolders,
                      child: const Text('添加到'),
                    ),
                    if (Platform.isAndroid)
                      TextButton(
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: _controller.checkedCount == 0
                            ? null
                            : _exportSelected,
                        child: const Text('导出'),
                      ),
                  ]
                : Platform.isAndroid
                ? [
                    TextButton(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: _folderSelectController.checkedCount == 0
                          ? null
                          : _exportSelectedFolders,
                      child: const Text('导出'),
                    ),
                  ]
                : null,
            child: AppBar(
              title: const Text('离线缓存'),
              actions: [
                if (isVideoTab) ...[
                  IconButton(
                    tooltip: '搜索',
                    onPressed: () async {
                      await _downloadService.waitForInitialization;
                      if (!mounted) {
                        return;
                      }
                      await Get.to(DownloadSearchPage(progress: _progress));
                      if (mounted) {
                        await _controller.refreshContinueTarget();
                      }
                    },
                    icon: const Icon(Icons.search),
                  ),
                  IconButton(
                    tooltip: '多选',
                    onPressed: () {
                      if (_controller.enableMultiSelect.value) {
                        _controller.handleSelect();
                      } else {
                        _controller.enableMultiSelect.value = true;
                      }
                    },
                    icon: const Icon(Icons.edit_note),
                  ),
                  _buildAllSortBtn(),
                ] else ...[
                  IconButton(
                    tooltip: '新建文件夹',
                    onPressed: _createFolder,
                    icon: const Icon(Icons.create_new_folder_outlined),
                  ),
                  IconButton(
                    tooltip: '多选',
                    onPressed: () {
                      if (_folderSelectController.enableMultiSelect.value) {
                        _folderSelectController.handleSelect();
                      } else {
                        _folderSelectController.enableMultiSelect.value = true;
                      }
                    },
                    icon: const Icon(Icons.edit_note),
                  ),
                  IconButton(
                    tooltip: '排序',
                    onPressed: _openFolderManagePage,
                    icon: const Icon(Icons.sort),
                  ),
                ],
                const SizedBox(width: 6),
              ],
              bottom: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Obx(
                      () => Text('全部视频(${_controller.allVideos.length})'),
                    ),
                  ),
                  Tab(
                    child: Obx(
                      () => Text('文件夹(${_controller.folders.length})'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
                  if (_tabIndex != 0) {
                    return false;
                  }
                  final direction = notification.direction;
                  if (direction == .forward) {
                    showFab();
                  } else if (direction == .reverse) {
                    hideFab();
                  }
                  return false;
                },
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAllVideosTab(),
                    _buildFoldersTab(),
                  ],
                ),
              ),
              _buildContinueFab(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAllVideosTab() {
    final padding = MediaQuery.viewPaddingOf(context);
    return Padding(
      padding: EdgeInsets.only(left: padding.left, right: padding.right),
      child: CustomScrollView(
        slivers: [
          Obx(() {
            final entry =
                _downloadService.waitDownloadQueue.firstWhereOrNull(
                  (item) => item.cid == _downloadService.curCid,
                ) ??
                _downloadService.waitDownloadQueue.firstOrNull;
            if (entry == null) {
              return const SliverToBoxAdapter();
            }
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 7),
                      child: Text(
                        '正在缓存 (${_downloadService.waitDownloadQueue.length})',
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: DetailItem(
                        entry: entry,
                        progress: _progress,
                        downloadService: _downloadService,
                        showTitle: true,
                        isCurr: true,
                        controller: _controller,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          Obx(() {
            if (_controller.allVideos.isEmpty) {
              if (_downloadService.waitDownloadQueue.isNotEmpty) {
                return const SliverToBoxAdapter();
              }
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: HttpError(isSliver: false),
              );
            }
            return SliverPadding(
              padding: EdgeInsets.only(
                top: _downloadService.waitDownloadQueue.isNotEmpty ? 0 : 7,
              ),
              sliver: SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 2,
                  mainAxisExtent: 100,
                  maxCrossAxisExtent: Grid.smallCardWidth * 2,
                ),
                itemCount: _controller.allVideos.length,
                itemBuilder: (context, index) {
                  final entry = _controller.allVideos[index];
                  return DetailItem(
                    entry: entry,
                    progress: _progress,
                    downloadService: _downloadService,
                    showTitle: true,
                    onDelete: () async {
                      await GStorage.watchProgress.delete(entry.cid.toString());
                      await _collectionService.clearLastLocalPlayedIfCid(
                        entry.cid,
                      );
                      await _downloadService.deleteDownload(
                        entry: entry,
                        removeList: true,
                      );
                    },
                    controller: _controller,
                    playContext: const DownloadVideoPlayContext.all(),
                    onPlayReturned: _controller.refreshContinueTarget,
                    customOnLongPress: () => _controller
                      ..enableMultiSelect.value = true
                      ..onSelect(entry),
                    extraMoreItemsBuilder: (menuContext) =>
                        _buildFolderQuickMenuItems(menuContext, entry),
                  );
                },
              ),
            );
          }),
          SliverToBoxAdapter(
            child: SizedBox(height: padding.bottom + 100),
          ),
        ],
      ),
    );
  }

  Widget _buildFoldersTab() {
    final padding = MediaQuery.viewPaddingOf(context);
    return Padding(
      padding: EdgeInsets.only(left: padding.left, right: padding.right),
      child: CustomScrollView(
        slivers: [
          Obx(() {
            if (_controller.folders.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('还没有文件夹'),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _createFolder,
                        icon: const Icon(Icons.create_new_folder_outlined),
                        label: const Text('新建文件夹'),
                      ),
                    ],
                  ),
                ),
              );
            }
            return SliverPadding(
              padding: EdgeInsets.only(top: 7, bottom: padding.bottom + 100),
              sliver: SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 2,
                  mainAxisExtent: 100,
                  maxCrossAxisExtent: Grid.smallCardWidth * 2,
                ),
                itemCount: _controller.folders.length,
                itemBuilder: (context, index) {
                  final folder = _controller.folders[index];
                  final entries = _controller.resolveFolderEntries(folder.id);
                  return DownloadFolderCard(
                    title: folder.title,
                    count: entries.length,
                    entry: entries.firstOrNull,
                    checked: folder.checked,
                    onTap: _folderSelectController.enableMultiSelect.value
                        ? () => _folderSelectController.onSelect(folder)
                        : () async {
                            await Get.to(
                              DownloadFolderPage(folderId: folder.id),
                            );
                            await _controller.refreshContinueTarget();
                          },
                    onLongPress: () => _folderSelectController
                      ..enableMultiSelect.value = true
                      ..onSelect(folder),
                    trailing: _folderSelectController.enableMultiSelect.value
                        ? null
                        : _buildFolderMoreBtn(folder),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
