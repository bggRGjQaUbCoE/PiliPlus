import 'dart:async';

import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/appbar/appbar.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/dialog/simple_dialog_option.dart';
import 'package:PiliPlus/common/widgets/flutter/pop_scope.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/select_mask.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/download/download_info.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/pages/download/controller.dart';
import 'package:PiliPlus/pages/download/detail/view.dart';
import 'package:PiliPlus/pages/download/detail/widgets/item.dart';
import 'package:PiliPlus/pages/download/download_action_mixin.dart';
import 'package:PiliPlus/pages/download/search/view.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:collection/collection.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart'
    hide SliverGridDelegateWithMaxCrossAxisExtent;

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage>
    with GridMixin, BaseDownloadActionMixin<DownloadPage, DownloadPageInfo> {
  final _progress = ChangeNotifier();
  final _controller = Get.put(DownloadPageController());

  @override
  final downloadService = Get.find<DownloadService>();

  @override
  BaseMultiSelectMixin<DownloadPageInfo> get multiSelectCtr => _controller;

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  Future<void> onUpdate(
    Future<bool> Function(BiliDownloadEntryInfo e) toElement,
  ) async {
    if (checkUpdateCount(_controller.checkedCount)) return;

    bool dismiss = false;
    SmartDialog.showLoading(
      onDismiss: () {
        dismiss = true;
        _controller.handleSelect();
      },
    );

    bool isSuccess = true;
    for (final chunk in _controller.allChecked.mapChunked(
      kUpdateConcurrency,
      (page) async {
        bool isSuccess = true;
        for (final chunk in page.entries.mapChunked(
          kUpdateConcurrency,
          toElement,
        )) {
          final res = await Future.wait(chunk);
          if (res.any((e) => !e)) isSuccess = false;
          if (dismiss) break;
        }
        return isSuccess;
      },
    )) {
      final res = await Future.wait(chunk);
      if (res.any((e) => !e)) isSuccess = false;
      if (dismiss) break;
    }

    toastUpdateResult(dismiss, isSuccess);
  }

  Future<void> _updatePageDm(DownloadPageInfo pageInfo) async {
    if (checkUpdateCount(pageInfo.entries.length)) return;

    bool dismiss = false;
    SmartDialog.showLoading(onDismiss: () => dismiss = true);

    bool isSuccess = true;
    for (final chunk in pageInfo.entries.mapChunked(
      kUpdateConcurrency,
      (e) => downloadService.downloadDanmaku(
        entry: e,
        isUpdate: true,
      ),
    )) {
      final res = await Future.wait(chunk);
      if (res.any((e) => !e)) isSuccess = false;
      if (dismiss) break;
    }

    toastUpdateResult(dismiss, isSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.viewPaddingOf(context);
    return Obx(() {
      final enableMultiSelect = _controller.enableMultiSelect.value;
      return popScope(
        canPop: !enableMultiSelect,
        onPopInvokedWithResult: (didPop, result) {
          if (enableMultiSelect) {
            _controller.handleSelect();
          }
        },
        child: SimpleScaffold(
          appBar: MultiSelectAppBarWidget(
            ctr: _controller,
            actions: [updateBtn()],
            child: AppBar(
              title: const Text('离线缓存'),
              actions: [
                IconButton(
                  tooltip: '搜索',
                  onPressed: () async {
                    await downloadService.waitForInitialization;
                    if (!mounted) return;
                    Get.to(DownloadSearchPage(progress: _progress));
                  },
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  tooltip: '多选',
                  onPressed: () {
                    if (enableMultiSelect) {
                      _controller.handleSelect();
                    } else {
                      _controller.enableMultiSelect.value = true;
                    }
                  },
                  icon: const Icon(Icons.edit_note),
                ),
                const SizedBox(width: 6),
              ],
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(left: padding.left, right: padding.right),
            child: CustomScrollView(
              slivers: [
                Obx(() {
                  final entry =
                      downloadService.waitDownloadQueue.firstWhereOrNull(
                        (e) => e.cid == downloadService.curCid,
                      ) ??
                      downloadService.waitDownloadQueue.firstOrNull;
                  if (entry != null) {
                    return SliverMainAxisGroup(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.only(left: 12, bottom: 7),
                          sliver: SliverToBoxAdapter(
                            child: Text(
                              '正在缓存 (${downloadService.waitDownloadQueue.length})',
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 110,
                            child: DetailItem(
                              entry: entry,
                              progress: _progress,
                              downloadService: downloadService,
                              showTitle: true,
                              isCurr: true,
                              controller: _controller,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return const SliverToBoxAdapter();
                }),
                Obx(() {
                  if (_controller.pages.isNotEmpty) {
                    return SliverMainAxisGroup(
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.only(
                            left: 12,
                            bottom: 7,
                            top: downloadService.waitDownloadQueue.isEmpty
                                ? 0
                                : 7,
                          ),
                          sliver: const SliverToBoxAdapter(
                            child: Text('已缓存视频'),
                          ),
                        ),
                        SliverGrid.builder(
                          gridDelegate: gridDelegate,
                          itemBuilder: (context, index) {
                            final item = _controller.pages[index];
                            if (item.entries.length == 1) {
                              final entry = item.entries.first;
                              return DetailItem(
                                entry: entry,
                                progress: _progress,
                                downloadService: downloadService,
                                showTitle: true,
                                onDelete: () {
                                  downloadService.deleteDownload(
                                    entry: entry,
                                    removeList: true,
                                  );
                                  GStorage.watchProgress.delete(
                                    entry.cid.toString(),
                                  );
                                },
                                checked: item.checked,
                                onSelect: (_) => _controller.onSelect(item),
                                controller: _controller,
                              );
                            }
                            return _buildItem(item, enableMultiSelect);
                          },
                          itemCount: _controller.pages.length,
                        ),
                      ],
                    );
                  }
                  if (downloadService.waitDownloadQueue.isNotEmpty) {
                    return const SliverToBoxAdapter();
                  }
                  return const HttpError();
                }),
                SliverToBoxAdapter(
                  child: SizedBox(height: padding.bottom + 100),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildItem(DownloadPageInfo pageInfo, bool enableMultiSelect) {
    void onLongPress() => enableMultiSelect
        ? null
        : showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              clipBehavior: Clip.hardEdge,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                DialogOption(
                  onPressed: () {
                    Get.back();
                    showConfirmDialog(
                      context: context,
                      title: const Text('确定删除？'),
                      onConfirm: () async {
                        await GStorage.watchProgress.deleteAll(
                          pageInfo.entries.map((e) => e.cid.toString()),
                        );
                        downloadService.deletePage(
                          pageDirPath: pageInfo.dirPath,
                        );
                      },
                    );
                  },
                  child: const Text('删除', style: TextStyle(fontSize: 14)),
                ),
                DialogOption(
                  onPressed: () {
                    Get.back();
                    _updatePageDm(pageInfo);
                  },
                  child: const Text('更新弹幕', style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          );
    final first = pageInfo.entries.first;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          if (_controller.enableMultiSelect.value) {
            _controller.onSelect(pageInfo);
            return;
          }
          Get.to(
            DownloadDetailPage(
              pageId: pageInfo.pageId,
              title: pageInfo.title,
              progress: _progress,
            ),
          );
        },
        onLongPress: onLongPress,
        onSecondaryTap: PlatformUtils.isMobile ? null : onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Style.safeSpace,
            vertical: 5,
          ),
          child: Row(
            spacing: 10,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AspectRatio(
                    aspectRatio: Style.aspectRatio,
                    child: LayoutBuilder(
                      builder: (context, constraints) => NetworkImgLayer(
                        src: pageInfo.cover,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                      ),
                    ),
                  ),
                  PBadge(
                    text: '${pageInfo.entries.length}个视频',
                    right: 6.0,
                    bottom: 6.0,
                    isBold: false,
                    type: PBadgeType.gray,
                  ),
                  if (pageInfo.seasonType case final pgcType?)
                    PBadge(
                      text: switch (pgcType) {
                        -1 => '课程',
                        1 => '番剧',
                        2 => '电影',
                        3 => '纪录片',
                        4 => '国创',
                        5 => '电视剧',
                        7 => '综艺',
                        _ => null,
                      },
                      right: 6.0,
                      top: 6.0,
                    ),
                  Positioned.fill(
                    child: selectMask(colorScheme, pageInfo.checked),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        pageInfo.title,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          height: 1.42,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: .end,
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          '${pageInfo.entries.fold(0, (p, n) => p + n.totalBytes).formatSize}  ${first.ownerName ?? ""}',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.6,
                            color: colorScheme.outline,
                          ),
                        ),
                        pageInfo.entries.first.moreBtn(colorScheme),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
