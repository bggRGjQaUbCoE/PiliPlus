import 'package:PiliPlus/services/temporary_queue_batch.dart';
import 'package:material_ui/material_ui.dart';

typedef TemporaryQueueBatchWork = Future<TemporaryQueueBatchProgress> Function(
  bool Function() cancelled,
  void Function(TemporaryQueueBatchProgress) onProgress,
);

Future<TemporaryQueueBatchProgress?> showTemporaryQueueBatchDialog(
  BuildContext context, {
  required String title,
  required TemporaryQueueBatchWork work,
}) => showDialog<TemporaryQueueBatchProgress>(
  context: context,
  barrierDismissible: false,
  builder: (context) => _TemporaryQueueBatchDialog(title: title, work: work),
);

class _TemporaryQueueBatchDialog extends StatefulWidget {
  const _TemporaryQueueBatchDialog({required this.title, required this.work});
  final String title;
  final TemporaryQueueBatchWork work;

  @override
  State<_TemporaryQueueBatchDialog> createState() =>
      _TemporaryQueueBatchDialogState();
}

class _TemporaryQueueBatchDialogState
    extends State<_TemporaryQueueBatchDialog> {
  TemporaryQueueBatchProgress progress = const TemporaryQueueBatchProgress();
  bool cancelRequested = false;
  bool done = false;

  @override
  void initState() {
    super.initState();
    Future<void>(() async {
      try {
        final result = await widget.work(
          () => cancelRequested,
          (value) {
            if (mounted) setState(() => progress = value);
          },
        );
        if (mounted) {
          setState(() {
            progress = result;
            done = true;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            progress = TemporaryQueueBatchProgress(error: '$e');
            done = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final value = progress.total == null || progress.total == 0
        ? null
        : (progress.scanned / progress.total!).clamp(0.0, 1.0);
    return PopScope(
      canPop: done,
      child: AlertDialog(
        title: Text(widget.title),
        content: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(value: done ? 1 : value),
              const SizedBox(height: 12),
              Text(
                '已检查 ${progress.scanned}${progress.total == null ? '' : ' / ${progress.total}'}',
              ),
              Text(
                '新加入 ${progress.added} · 调整位置 ${progress.moved} · 跳过 ${progress.skipped}',
              ),
              if (progress.error case final error?) Text(error),
              if (progress.cancelled) const Text('已取消剩余项目；已完成的项目保留。'),
              if (done && !progress.incomplete) const Text('处理完成。'),
            ],
          ),
        ),
        actions: [
          if (!done)
            TextButton(
              onPressed: () => setState(() => cancelRequested = true),
              child: Text(cancelRequested ? '正在取消…' : '取消剩余'),
            )
          else
            FilledButton(
              onPressed: () => Navigator.pop(context, progress),
              child: const Text('完成'),
            ),
        ],
      ),
    );
  }
}
