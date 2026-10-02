import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

const _batchExportDialogTag = 'download-batch-export';

Future<void> exportDownloadEntries(
  Iterable<BiliDownloadEntryInfo> entries,
) async {
  if (!await ImageUtils.checkPermissionDependOnSdkInt()) {
    return;
  }
  final items = entries.toList(growable: false);
  if (items.isEmpty) {
    return;
  }
  final total = items.length;
  for (var i = 0; i < total; i++) {
    final entry = items[i];
    SmartDialog.show(
      tag: _batchExportDialogTag,
      clickMaskDismiss: false,
      builder: (_) => _BatchExportDialog(
        title: entry.showTitle,
        current: i + 1,
        total: total,
      ),
      maskColor: Colors.black.withValues(alpha: 0.35),
    );
    try {
      await DownloadService.exportEntry(entry, null);
    } catch (_) {
      // 保持现有批量导出行为，单个失败时继续后续任务。
    } finally {
      SmartDialog.dismiss(tag: _batchExportDialogTag);
    }
  }
  SmartDialog.showToast('导出完成 ($total)');
}

class _BatchExportDialog extends StatelessWidget {
  const _BatchExportDialog({
    required this.title,
    required this.current,
    required this.total,
  });

  final String title;
  final int current;
  final int total;

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
                '正在导出 ($current/$total)',
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
              LinearProgressIndicator(
                value: current / total,
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
                color: theme.colorScheme.primary,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
