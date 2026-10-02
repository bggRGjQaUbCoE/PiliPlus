import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/flutter/popup_menu.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/progress_bar/video_progress_indicator.dart';
import 'package:PiliPlus/common/widgets/select_mask.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/download/download_collection.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/pages/download/downloading/view.dart';
import 'package:PiliPlus/pages/download/utils/open_download_entry.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/cache_manager.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as path;

class DetailItem extends StatelessWidget {
  const DetailItem({
    super.key,
    required this.entry,
    this.progress,
    required this.downloadService,
    this.onDelete,
    this.onDeleteRequested,
    required this.showTitle,
    this.isCurr = false,
    this.playContext,
    this.onPlayReturned,
    this.deleteLabel = '删除',
    this.deleteConfirmText,
    this.customOnLongPress,
    this.extraMoreItemsBuilder,
    this.enableTap = true,
    this.showMoreButton = true,
    //
    required this.controller,
    this.checked,
    this.onSelect,
  });

  final BiliDownloadEntryInfo entry;
  final ChangeNotifier? progress;
  final DownloadService downloadService;
  final VoidCallback? onDelete;
  final Future<void> Function(BuildContext context)? onDeleteRequested;
  final bool showTitle;
  final bool isCurr;
  final DownloadVideoPlayContext? playContext;
  final Future<void> Function()? onPlayReturned;
  final String deleteLabel;
  final String? deleteConfirmText;
  final VoidCallback? customOnLongPress;
  final List<PopupMenuEntry<void>> Function(BuildContext context)?
  extraMoreItemsBuilder;
  final bool enableTap;
  final bool showMoreButton;
  //
  final MultiSelectBase controller;
  final bool? checked;
  final ValueChanged<BiliDownloadEntryInfo>? onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline;
    final cid = entry.source?.cid ?? entry.pageData?.cid;
    final canDel = onDelete != null || onDeleteRequested != null;
    final enableMultiSelect = controller.enableMultiSelect.value;
    void onLongPress() {
      if (enableMultiSelect) {
        return;
      }
      customOnLongPress?.call();
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: enableTap
            ? () async {
                if (!canDel) {
                  Get.to(const DownloadingPage());
                  return;
                }
                if (enableMultiSelect) {
                  (onSelect ?? controller.onSelect).call(entry);
                  return;
                }
                if (entry.isCompleted) {
                  await openDownloadEntry(
                    entry: entry,
                    playContext: playContext,
                  );
                  if (context.mounted) {
                    Timer(const Duration(milliseconds: 400), () {
                      if (context.mounted) {
                        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                        progress?.notifyListeners();
                        onPlayReturned?.call();
                      }
                    });
                  }
                } else {
                  final curDownload = downloadService.curDownload.value;
                  if (curDownload != null &&
                      curDownload.cid == cid &&
                      curDownload.status.isDownloading) {
                    downloadService.cancelDownload(
                      isDelete: false,
                      downloadNext: false,
                    );
                  } else {
                    downloadService.startDownload(entry);
                  }
                }
              }
            : null,
        onLongPress: enableTap && customOnLongPress != null
            ? onLongPress
            : null,
        onSecondaryTap:
            !enableTap || PlatformUtils.isMobile || customOnLongPress == null
            ? null
            : onLongPress,
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
                      builder: (context, constraints) {
                        final cover = File(
                          path.join(entry.entryDirPath, PathUtils.coverName),
                        );
                        final maxWidth = constraints.maxWidth;
                        final maxHeight = constraints.maxHeight;
                        int? cacheWidth, cacheHeight;
                        if (entry.pageData?.cacheWidth ?? false) {
                          cacheWidth = maxWidth.cacheSize(context);
                        } else {
                          cacheHeight = maxHeight.cacheSize(context);
                        }
                        return cover.existsSync()
                            ? ClipRRect(
                                borderRadius: Style.mdRadius,
                                child: Image.file(
                                  cover,
                                  width: maxWidth,
                                  height: maxHeight,
                                  fit: BoxFit.cover,
                                  cacheWidth: cacheWidth,
                                  cacheHeight: cacheHeight,
                                  colorBlendMode: NetworkImgLayer.reduce
                                      ? BlendMode.modulate
                                      : null,
                                  color: NetworkImgLayer.reduce
                                      ? NetworkImgLayer.reduceLuxColor
                                      : null,
                                ),
                              )
                            : NetworkImgLayer(
                                src: entry.cover,
                                width: maxWidth,
                                height: maxHeight,
                                cacheWidth: entry.pageData?.cacheWidth,
                              );
                      },
                    ),
                  ),
                  if (entry.videoQuality case final videoQuality?)
                    PBadge(
                      text: VideoQuality.fromCode(videoQuality).shortDesc,
                      right: 6.0,
                      top: 6.0,
                      type: PBadgeType.gray,
                    ),
                  if (progress != null)
                    ListenableBuilder(
                      listenable: progress!,
                      builder: (_, _) {
                        final progress = GStorage.watchProgress.get(
                          cid.toString(),
                        );
                        if (progress != null) {
                          return Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Column(
                              crossAxisAlignment: .end,
                              children: [
                                Padding(
                                  padding: const .only(right: 6, bottom: 3),
                                  child: PBadge(
                                    isStack: false,
                                    text: progress >= entry.totalTimeMilli - 400
                                        ? '已看完'
                                        : '${DurationUtils.formatDuration(
                                                progress ~/ 1000,
                                              )}/'
                                              '${DurationUtils.formatDuration(
                                                entry.totalTimeMilli ~/ 1000,
                                              )}',
                                    type: .gray,
                                  ),
                                ),
                                VideoProgressIndicator(
                                  color: theme.colorScheme.primary,
                                  backgroundColor:
                                      theme.colorScheme.secondaryContainer,
                                  progress: progress / entry.totalTimeMilli,
                                ),
                              ],
                            ),
                          );
                        }
                        return PBadge(
                          text: DurationUtils.formatDuration(
                            entry.totalTimeMilli ~/ 1000,
                          ),
                          right: 6.0,
                          bottom: 7.0,
                          type: PBadgeType.gray,
                        );
                      },
                    )
                  else if (entry.totalTimeMilli != 0)
                    PBadge(
                      text: DurationUtils.formatDuration(
                        entry.totalTimeMilli ~/ 1000,
                      ),
                      right: 6,
                      bottom: 7,
                      type: PBadgeType.gray,
                    ),
                  Positioned.fill(
                    child: selectMask(
                      theme.colorScheme,
                      checked ?? entry.checked,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          showTitle ? entry.title : entry.showTitle,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: theme.textTheme.bodyMedium!.fontSize,
                            height: 1.42,
                            letterSpacing: 0.3,
                          ),
                          maxLines: showTitle
                              ? entry.ep != null
                                    ? 1
                                    : 2
                              : 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (showTitle) ...[
                          if (entry.pageData?.part case final part?)
                            if (part != entry.title)
                              Text(
                                part,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                          if (entry.ep?.showTitle case final showTitle?)
                            Text(
                              showTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ],
                    ),
                    if (entry.isCompleted) ...[
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: Text(
                          '${CacheManager.formatSize(entry.totalBytes)}${entry.ownerName != null ? '  ${entry.ownerName}' : ''}',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.6,
                            color: outline,
                          ),
                        ),
                      ),
                      if (showMoreButton)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: _buildMoreBtn(context, theme),
                        ),
                    ] else
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: isCurr
                            ? RepaintBoundary(
                                child: Obx(
                                  () {
                                    final curDownload =
                                        downloadService.curDownload.value;
                                    if (curDownload != null) {
                                      final status = curDownload.status;
                                      final color =
                                          status != DownloadStatus.pause
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.outline;
                                      return progressWidget(
                                        statusMsg: status.message,
                                        progressStr:
                                            status ==
                                                    DownloadStatus
                                                        .downloading ||
                                                status == DownloadStatus.pause
                                            ? '${CacheManager.formatSize(curDownload.downloadedBytes)}/${CacheManager.formatSize(curDownload.totalBytes)}'
                                            : '',
                                        progress: curDownload.totalBytes == 0
                                            ? 0
                                            : curDownload.downloadedBytes /
                                                  curDownload.totalBytes,
                                        color: color,
                                        highlightColor: theme.highlightColor,
                                      );
                                    }
                                    return entryProgress(theme);
                                  },
                                ),
                              )
                            : entryProgress(theme),
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

  Widget entryProgress(ThemeData theme) => progressWidget(
    statusMsg: entry.status.message,
    progressStr: entry.totalBytes == 0
        ? ''
        : '${CacheManager.formatSize(entry.downloadedBytes)}/${CacheManager.formatSize(entry.totalBytes)}',
    progress: entry.totalBytes == 0
        ? 0
        : entry.downloadedBytes / entry.totalBytes,
    color: theme.colorScheme.outline,
    highlightColor: theme.highlightColor,
  );

  Widget progressWidget({
    required String statusMsg,
    required String progressStr,
    required double progress,
    required Color color,
    required Color highlightColor,
  }) {
    return Column(
      spacing: 6,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              statusMsg,
              style: TextStyle(
                fontSize: 12,
                height: 1,
                color: color,
              ),
            ),
            Text(
              progressStr,
              style: TextStyle(
                fontSize: 12,
                height: 1,
                color: color,
              ),
            ),
          ],
        ),
        LinearProgressIndicator(
          // ignore: deprecated_member_use
          year2023: true,
          minHeight: 2.5,
          borderRadius: Style.mdRadius,
          color: color,
          backgroundColor: highlightColor,
          value: progress,
        ),
      ],
    );
  }

  Widget _buildMoreBtn(BuildContext context, ThemeData theme) {
    final canDel = onDelete != null || onDeleteRequested != null;
    return SizedBox(
      width: 29,
      height: 29,
      child: Builder(
        builder: (menuContext) => IconButton(
          constraints: const BoxConstraints.tightFor(width: 29, height: 29),
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.more_vert_outlined,
            color: theme.colorScheme.outline,
            size: 18,
          ),
          onPressed: () {
            showStaticPositionMenu<void>(
              context: menuContext,
              items: [
                CustomPopupMenuItem<void>(
                  height: 38,
                  child: const Text('查看详情页', style: TextStyle(fontSize: 13)),
                  onTap: () {
                    if (entry.ep case final ep?) {
                      if (ep.from == VideoType.pugv.name) {
                        PageUtils.viewPugv(
                          seasonId: entry.seasonId,
                          epId: ep.episodeId,
                        );
                      } else {
                        PageUtils.viewPgc(
                          seasonId: entry.seasonId,
                          epId: ep.episodeId,
                        );
                      }
                      return;
                    }
                    PageUtils.toVideoPage(
                      aid: entry.avid,
                      bvid: entry.bvid,
                      cid: entry.cid,
                      epId: entry.ep?.episodeId,
                      title: entry.title,
                      cover: entry.cover,
                    );
                  },
                ),
                if (PlatformUtils.isDesktop)
                  CustomPopupMenuItem<void>(
                    height: 38,
                    child: const Text(
                      '打开本地文件夹',
                      style: TextStyle(fontSize: 13),
                    ),
                    onTap: () async {
                      try {
                        final String executable;
                        if (Platform.isWindows) {
                          executable = 'explorer';
                        } else if (Platform.isMacOS) {
                          executable = 'open';
                        } else if (Platform.isLinux) {
                          executable = 'xdg-open';
                        } else {
                          throw UnimplementedError();
                        }
                        await Process.run(executable, [entry.entryDirPath]);
                      } catch (e) {
                        SmartDialog.showToast(e.toString());
                      }
                    },
                  ),
                if (entry.ownerId case final mid?)
                  CustomPopupMenuItem<void>(
                    height: 38,
                    child: Text(
                      '访问${entry.ownerName != null ? '：${entry.ownerName}' : '用户主页'}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    onTap: () => Get.toNamed('/member?mid=$mid'),
                  ),
                if (canDel && Platform.isAndroid)
                  CustomPopupMenuItem<void>(
                    height: 38,
                    child: const Text('导出', style: TextStyle(fontSize: 13)),
                    onTap: () async {
                      if (!await ImageUtils.checkPermissionDependOnSdkInt()) {
                        return;
                      }
                      final title = entry.showTitle;
                      SmartDialog.show(
                        tag: 'export',
                        clickMaskDismiss: false,
                        builder: (_) => _ExportDialog(title: title),
                        maskColor: Colors.black.withValues(alpha: 0.35),
                      );
                      try {
                        final dest = await DownloadService.exportEntry(entry, (
                          progress,
                        ) {
                          _ExportDialog.progressNotifier.value = progress;
                        });
                        SmartDialog.showToast('已导出到 $dest');
                      } catch (e) {
                        SmartDialog.showToast('导出失败: $e');
                      } finally {
                        SmartDialog.dismiss(tag: 'export');
                      }
                    },
                  ),
                ...?extraMoreItemsBuilder?.call(menuContext),
                if (canDel) const PopupMenuDivider(height: 8),
                if (canDel)
                  CustomPopupMenuItem<void>(
                    height: 38,
                    child: Text(
                      deleteLabel,
                      style: const TextStyle(fontSize: 13),
                    ),
                    onTap: () {
                      if (onDeleteRequested != null) {
                        onDeleteRequested!(menuContext);
                        return;
                      }
                      showConfirmDialog(
                        context: menuContext,
                        title: Text(deleteConfirmText ?? '确定删除该视频？'),
                        onConfirm: onDelete,
                      );
                    },
                  ),
                if (canDel)
                  CustomPopupMenuItem<void>(
                    height: 38,
                    child: const Text('更新弹幕', style: TextStyle(fontSize: 13)),
                    onTap: () async {
                      final res = await downloadService.downloadDanmaku(
                        entry: entry,
                        isUpdate: true,
                      );
                      SmartDialog.showToast(res ? '更新成功' : '更新失败');
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ExportDialog extends StatelessWidget {
  _ExportDialog({required this.title}) {
    progressNotifier.value = 0;
  }

  static final progressNotifier = ValueNotifier<double>(0);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Material(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '正在导出',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<double>(
                valueListenable: progressNotifier,
                builder: (_, progress, _) {
                  return Column(
                    children: [
                      LinearProgressIndicator(
                        year2023: true,
                        value: progress,
                        minHeight: 4,
                        borderRadius: BorderRadius.circular(2),
                        color: theme.colorScheme.primary,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${(progress * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
