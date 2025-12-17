import 'dart:async';

import 'package:PiliPlus/common/widgets/appbar/appbar.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/view_sliver_safe_area.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart'
    show BaseMultiSelectMixin;
import 'package:PiliPlus/pages/download/controller.dart';
import 'package:PiliPlus/pages/download/detail/widgets/item.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart'
    hide SliverGridDelegateWithMaxCrossAxisExtent;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class DownloadDetailPage extends StatefulWidget {
  const DownloadDetailPage({
    super.key,
    required this.pageId,
    required this.title,
    required this.progress,
  });

  final String pageId;
  final String title;
  final ChangeNotifier progress;

  @override
  State<DownloadDetailPage> createState() => _DownloadDetailPageState();
}

class _DownloadDetailPageState extends State<DownloadDetailPage>
    with BaseMultiSelectMixin<BiliDownloadEntryInfo> {
  StreamSubscription? _sub;
  final _downloadItems = RxList<BiliDownloadEntryInfo>();
  final _controller = Get.find<DownloadPageController>();
  final _downloadService = Get.find<DownloadService>();
  @override
  RxList<BiliDownloadEntryInfo> get list => _downloadItems;
  @override
  RxList<BiliDownloadEntryInfo> get state => _downloadItems;

  @override
  void initState() {
    super.initState();
    _loadList();
    _sub = _controller.flag.listen((_) {
      _loadList();
    });
  }

  Future _closeSub() async {
    if (_sub != null) {
      await _sub?.cancel();
      _sub = null;
    }
  }

  @override
  void dispose() {
    _closeSub();
    super.dispose();
  }

  void _loadList() {
    final list =
        _controller.pages
            .firstWhereOrNull((e) => e.pageId == widget.pageId)
            ?.entries
          ?..sort((a, b) => a.sortKey.compareTo(b.sortKey));
    if (list != null) {
      _downloadItems.value = list;
    } else {
      _downloadItems.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return Obx(() {
      final enableMultiSelect = this.enableMultiSelect.value;
      return PopScope(
        canPop: !enableMultiSelect,
        onPopInvokedWithResult: (didPop, result) {
          if (enableMultiSelect) {
            handleSelect();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: MultiSelectAppBarWidget(
            ctr: this,
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () async {
                  final allChecked = this.allChecked.toSet();
                  handleSelect();
                  final res = await Future.wait(
                    allChecked.map(
                      (e) => _downloadService.downloadDanmaku(
                        entry: e,
                        isUpdate: true,
                      ),
                    ),
                  );
                  if (res.every((e) => e)) {
                    SmartDialog.showToast('更新成功');
                  } else {
                    SmartDialog.showToast('更新失败');
                  }
                },
                child: Text(
                  '更新',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ),
            ],
            child: AppBar(
              title: Text(widget.title),
              actions: [
                IconButton(
                  tooltip: '多选',
                  onPressed: () {
                    if (enableMultiSelect) {
                      handleSelect();
                    } else {
                      this.enableMultiSelect.value = true;
                    }
                  },
                  icon: const Icon(Icons.edit_note),
                ),
                const SizedBox(width: 6),
              ],
            ),
          ),
          body: CustomScrollView(
            slivers: [
              ViewSliverSafeArea(
                sliver: Obx(() {
                  if (_downloadItems.isNotEmpty) {
                    return SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        mainAxisSpacing: 2,
                        mainAxisExtent: 100,
                        maxCrossAxisExtent: Grid.smallCardWidth * 2,
                      ),
                      itemBuilder: (context, index) {
                        final entry = _downloadItems[index];
                        return DetailItem(
                          entry: entry,
                          progress: widget.progress,
                          downloadService: _downloadService,
                          showTitle: false,
                          onDelete: () async {
                            if (_downloadItems.length == 1) {
                              await _closeSub();
                              await _downloadService.deletePage(
                                pageDirPath: entry.pageDirPath,
                              );
                              if (mounted) {
                                Get.back();
                              }
                            } else {
                              _downloadService.deleteDownload(
                                entry: entry,
                                removeList: true,
                              );
                            }
                            GStorage.watchProgress.delete(entry.cid.toString());
                          },
                          controller: this,
                        );
                      },
                      itemCount: _downloadItems.length,
                    );
                  }
                  return const HttpError();
                }),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  void onRemove() {
    showConfirmDialog(
      context: context,
      title: '确定删除选中视频？',
      onConfirm: () async {
        SmartDialog.showLoading();
        final watchProgress = GStorage.watchProgress;
        final allChecked = this.allChecked.toSet();
        final isDeleteAll = allChecked.length == _downloadItems.length;
        if (isDeleteAll) {
          await _closeSub();
        }
        for (var entry in allChecked) {
          await watchProgress.deleteAll(
            allChecked.map((e) => e.cid.toString()),
          );
          await _downloadService.deleteDownload(
            entry: entry,
            removeList: true,
            refresh: false,
          );
        }
        _downloadService.flagNotifier.refresh();
        if (isDeleteAll) {
          SmartDialog.dismiss();
          if (mounted) {
            Get.back();
          }
        } else {
          if (enableMultiSelect.value) {
            rxCount.value = 0;
            enableMultiSelect.value = false;
          }
          SmartDialog.dismiss();
        }
      },
    );
  }
}
