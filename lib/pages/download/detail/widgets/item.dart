import 'dart:io';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/progress_bar/video_progress_indicator.dart';
import 'package:PiliPlus/common/widgets/select_mask.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/pages/download/downloading/view.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/cache_manager.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

class DetailItem extends StatelessWidget {
  const DetailItem({
    super.key,
    required this.entry,
    this.progress,
    required this.downloadService,
    this.onDelete,
    required this.showTitle,
    this.isCurr = false,
    //
    required this.controller,
    this.checked,
    this.onSelect,
  });

  final BiliDownloadEntryInfo entry;
  final ChangeNotifier? progress;
  final DownloadService downloadService;
  final VoidCallback? onDelete;
  final bool showTitle;
  final bool isCurr;
  //
  final MultiSelectBase controller;
  final bool? checked;
  final ValueChanged<BiliDownloadEntryInfo>? onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline;
    final cid = entry.source?.cid ?? entry.pageData?.cid;
    final canDel = onDelete != null;
    final enableMultiSelect = controller.enableMultiSelect.value;
    void onLongPress() => canDel && !enableMultiSelect
        ? showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                clipBehavior: Clip.hardEdge,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      onTap: () {
                        Get.back();
                        showConfirmDialog(
                          context: context,
                          title: '确定删除该视频？',
                          onConfirm: onDelete,
                        );
                      },
                      dense: true,
                      title: const Text(
                        '删除',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        Get.back();
                        final res = await downloadService.downloadDanmaku(
                          entry: entry,
                          isUpdate: true,
                        );
                        if (res) {
                          SmartDialog.showToast('更新成功');
                        } else {
                          SmartDialog.showToast('更新失败');
                        }
                      },
                      dense: true,
                      title: const Text(
                        '更新弹幕',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        : null;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () async {
          if (!canDel) {
            Get.to(const DownloadingPage());
            return;
          }
          if (enableMultiSelect) {
            (onSelect ?? controller.onSelect).call(entry);
            return;
          }
          if (entry.isCompleted) {
            await PageUtils.toVideoPage(
              aid: entry.avid,
              cid: cid!,
              cover: entry.cover,
              title: entry.showTitle,
              extraArguments: {
                'sourceType': SourceType.file,
                'entry': entry,
                'dirPath': entry.entryDirPath,
              },
            );
            if (context.mounted) {
              Future.delayed(const Duration(milliseconds: 400), () {
                if (context.mounted) {
                  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                  progress?.notifyListeners();
                }
              });
            }
          } else {
            final curDownload = downloadService.curDownload.value;
            if (curDownload != null &&
                curDownload.cid == cid &&
                curDownload.status!.index <= 3) {
              downloadService.cancelDownload(
                isDelete: false,
                downloadNext: false,
              );
            } else {
              downloadService.startDownload(entry);
            }
          }
        },
        onLongPress: onLongPress,
        onSecondaryTap: PlatformUtils.isMobile ? null : onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: StyleString.safeSpace,
            vertical: 5,
          ),
          child: Row(
            spacing: 10,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AspectRatio(
                    aspectRatio: StyleString.aspectRatio,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final cover = File(
                          path.join(entry.entryDirPath, PathUtils.coverName),
                        );
                        return cover.existsSync()
                            ? ClipRRect(
                                borderRadius: StyleString.mdRadius,
                                child: Image.file(
                                  cover,
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight,
                                  fit: BoxFit.cover,
                                  cacheHeight: constraints.maxWidth.cacheSize(
                                    context,
                                  ),
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
                                width: constraints.maxWidth,
                                height: constraints.maxHeight,
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
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                videoProgressIndicator(
                                  progress / entry.totalTimeMilli,
                                ),
                                PBadge(
                                  text: progress >= entry.totalTimeMilli - 400
                                      ? '已看完'
                                      : '${DurationUtils.formatDuration(
                                              progress ~/ 1000,
                                            )}/'
                                            '${DurationUtils.formatDuration(
                                              entry.totalTimeMilli ~/ 1000,
                                            )}',
                                  right: 6,
                                  bottom: 7,
                                  type: PBadgeType.gray,
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
                    child: selectMask(theme, checked ?? entry.checked),
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
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: entry.moreBtn(theme),
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
                                        statusMsg: status!.message,
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
    statusMsg: entry.status?.message ?? '暂停中',
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
          borderRadius: StyleString.mdRadius,
          color: color,
          backgroundColor: highlightColor,
          value: progress,
        ),
      ],
    );
  }
}
