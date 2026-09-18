import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/services/download/sponsor_block_batch.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:material_ui/material_ui.dart';

Future<void> showSponsorBlockUpdate(
  BuildContext context,
  DownloadService service,
  Iterable<BiliDownloadEntryInfo> entries, {
  bool refresh = false,
}) {
  final targets = [
    for (final entry in entries)
      entry.isCompleted ? DownloadService.sponsorTarget(entry) : null,
  ];
  return showDialog<void>(
    context: context,
    builder: (_) => _UpdateDialog(
      batch: SponsorBlockBatch(service.sponsorBlockCache, targets),
      refresh: refresh,
    ),
  );
}

class _UpdateDialog extends StatefulWidget {
  const _UpdateDialog({required this.batch, required this.refresh});
  final SponsorBlockBatch batch;
  final bool refresh;

  @override
  State<_UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<_UpdateDialog> {
  late bool _refresh = widget.refresh;

  @override
  void dispose() {
    widget.batch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.batch,
    builder: (context, _) {
      final batch = widget.batch;
      return AlertDialog(
        title: const Text('更新空降信息'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('范围：已选择的 ${batch.total} 个视频或剧集'),
              const Text('番剧启用片头片尾跳过时获取官方信息，其余情况获取社区标记。'),
              if (!Pref.enableSponsorBlock)
                const Text('空降助手已关闭，社区标记保存后可启用并重新打开视频使用。'),
              DropdownButton<bool>(
                value: _refresh,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: false, child: Text('补齐缺失')),
                  DropdownMenuItem(value: true, child: Text('重新获取')),
                ],
                onChanged: batch.running || batch.finished
                    ? null
                    : (value) {
                        if (value != null) setState(() => _refresh = value);
                      },
              ),
              Text(batch.summary),
              if (batch.running) ...[
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: batch.total == 0 ? 0 : batch.processed / batch.total,
                ),
              ],
              if (batch.reason case final reason?) Text(reason),
              const SizedBox(height: 8),
              const Text('更新失败时已有空降文件保持原样。重新打开视频后使用更新的信息。'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(batch.running ? '取消更新' : '关闭'),
          ),
          if (!batch.finished)
            TextButton(
              onPressed: batch.running || batch.total == batch.unsupported
                  ? null
                  : () => batch.run(refresh: _refresh),
              child: const Text('开始更新'),
            ),
        ],
      );
    },
  );
}
