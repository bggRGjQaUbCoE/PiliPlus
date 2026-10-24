import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models_new/download/download_video_info.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

abstract final class DownloadUtils {
  /// 弹出画质选择框并批量缓存
  ///
  /// [items] 为可缓存的内容，[invalidCount] 为被过滤掉、不支持缓存的数量
  static Future<void> batchDownload({
    required BuildContext context,
    required List<DownloadVideoInfo> items,
    int invalidCount = 0,
  }) async {
    if (items.isEmpty) {
      SmartDialog.showToast(
        invalidCount > 0 ? '所选内容暂不支持缓存' : '没有可缓存的内容',
      );
      return;
    }

    final downloadService = Get.find<DownloadService>();
    await downloadService.waitForInitialization;
    if (!context.mounted) {
      return;
    }

    var quality = VideoQuality.fromCode(Pref.defaultVideoQa);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final colorScheme = ColorScheme.of(context);
          return AlertDialog(
            title: const Text('批量缓存'),
            contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('共选择 ${items.length} 个视频'),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('最高画质'),
                    PopupMenuButton<VideoQuality>(
                      initialValue: quality,
                      onSelected: (value) => setState(() => quality = value),
                      itemBuilder: (context) => [
                        for (final e in VideoQuality.values)
                          PopupMenuItem(value: e, child: Text(e.desc)),
                      ],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              quality.desc,
                              style: const TextStyle(height: 1),
                              strutStyle: const StrutStyle(
                                height: 1,
                                leading: 0,
                              ),
                            ),
                            Icon(
                              size: 18,
                              Icons.keyboard_arrow_down,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (invalidCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '$invalidCount 个内容不支持缓存，已自动跳过',
                      style: TextStyle(fontSize: 12, color: colorScheme.outline),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: Get.back,
                child: Text(
                  '取消',
                  style: TextStyle(color: colorScheme.outline),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text('确定'),
              ),
            ],
          );
        },
      ),
    );

    if (confirm != true) {
      return;
    }

    final count = downloadService.batchDownload(
      items: items,
      videoQuality: quality,
    );
    if (count == 0) {
      SmartDialog.showToast('所选视频已在缓存列表中');
    } else {
      SmartDialog.showToast('已加入缓存队列：$count 个');
    }
  }
}
