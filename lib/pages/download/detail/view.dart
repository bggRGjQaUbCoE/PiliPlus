import 'dart:async';

import 'package:PiliPlus/common/widgets/appbar/appbar.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/flutter/pop_scope.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/view_sliver_safe_area.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart'
    show BaseMultiSelectMixin;
import 'package:PiliPlus/pages/download/detail/widgets/item.dart';
import 'package:PiliPlus/pages/download/download/controller.dart';
import 'package:PiliPlus/pages/download/download_action_mixin.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart'
    hide SliverGridDelegateWithMaxCrossAxisExtent;

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
    with
        BaseMultiSelectMixin<BiliDownloadEntryInfo>,
        GridMixin,
        BaseDownloadActionMixin<DownloadDetailPage, BiliDownloadEntryInfo>,
        CommonDownloadActionMixin<DownloadDetailPage> {
  StreamSubscription? _sub;
  final _downloadItems = RxList<BiliDownloadEntryInfo>();
  final _controller = Get.find<DownloadController>();

  @override
  RxList<BiliDownloadEntryInfo> get list => _downloadItems;
  @override
  RxList<BiliDownloadEntryInfo> get state => _downloadItems;

  @override
  final downloadService = Get.find<DownloadService>();

  @override
  BaseMultiSelectMixin<BiliDownloadEntryInfo> get multiSelectCtr => this;

  @override
  void initState() {
    super.initState();
    _loadList();
    _sub = _controller.flag.listen((_) {
      _loadList();
    });
  }

  Future<void> _closeSub() async {
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
    List<BiliDownloadEntryInfo>? list;
    for (final season in _controller.seasons) {
      for (final page in season.pages) {
        if (page.pageId == widget.pageId) {
          list = page.entries..sort(downloadEntrySort);
        }
      }
    }
    if (list != null) {
      _downloadItems.value = list;
    } else {
      _downloadItems.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final enableMultiSelect = this.enableMultiSelect.value;
      return popScope(
        canPop: !enableMultiSelect,
        onPopInvokedWithResult: (didPop, result) {
          if (enableMultiSelect) {
            handleSelect();
          }
        },
        child: SimpleScaffold(
          appBar: MultiSelectAppBarWidget(
            ctr: this,
            actions: [updateBtn()],
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
                      gridDelegate: gridDelegate,
                      itemBuilder: (context, index) {
                        final entry = _downloadItems[index];
                        return DetailItem(
                          entry: entry,
                          progress: widget.progress,
                          downloadService: downloadService,
                          showTitle: false,
                          onDelete: () async {
                            if (_downloadItems.length == 1) {
                              await _closeSub();
                              await downloadService.deletePage(
                                pageDirPath: entry.pageDirPath,
                              );
                              if (mounted) {
                                Get.back();
                              }
                            } else {
                              downloadService.deleteDownload(
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
      title: const Text('确定删除选中视频？'),
      onConfirm: () async {
        SmartDialog.showLoading();
        final allChecked = this.allChecked.toList();
        final isDeleteAll = allChecked.length == _downloadItems.length;
        await Future.wait([
          if (isDeleteAll) _closeSub(),
          GStorage.watchProgress.deleteAll(
            allChecked.map((e) => e.cid.toString()),
          ),
          for (final entry in allChecked)
            downloadService.deleteDownload(
              entry: entry,
              removeList: true,
              refresh: false,
            ),
        ]);
        downloadService.flagNotifier.refresh();
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
