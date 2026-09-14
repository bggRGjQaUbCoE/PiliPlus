import 'dart:convert' show jsonDecode, jsonEncode, utf8;

import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/http/reply.dart';
import 'package:PiliPlus/utils/comment_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

/// 导出某个评论对象（视频 aid / 课程 epId）的全部评论，含楼中楼。
///
/// 热门视频评论量可达上万条，抓取要跑几分钟，所以弹窗内带进度和停止；
/// 触发风控或中途失败时断点落盘，下次打开同一页面可接着爬。
Future<void> showCommentExportDialog(
  BuildContext context, {
  required int oid,
  required int type,
  required String fileName,
}) => showDialog<void>(
  context: context,
  builder: (context) => CommentExportDialog(
    oid: oid,
    type: type,
    fileName: fileName,
  ),
);

class CommentExportDialog extends StatefulWidget {
  const CommentExportDialog({
    super.key,
    required this.oid,
    required this.type,
    required this.fileName,
  });

  /// 评论对象 id，视频为 aid，课程为 epId
  final int oid;

  /// 评论类型，见 VideoType.replyType
  final int type;

  /// 不含扩展名的文件名
  final String fileName;

  @override
  State<CommentExportDialog> createState() => _CommentExportDialogState();
}

class _CommentExportDialogState extends State<CommentExportDialog> {
  CommentExportFormat _format = CommentExportFormat.txt;
  late final String _resumeKey;
  late final CommentCrawlState _state;
  late String _status;
  bool _running = false;
  bool _stopped = false;
  int _lastTick = 0;

  @override
  void initState() {
    super.initState();
    _resumeKey = '${LocalCacheKey.commentExportPrefix}${widget.oid}';
    _state = _restore();
    _status = _state.comments.isEmpty
        ? '将抓取全部评论（含楼中楼），预计需要一会儿'
        : '检测到上次未完成的抓取，已恢复 ${_state.comments.length} 条，可继续';
  }

  CommentCrawlState _restore() {
    final saved = GStorage.localCache.get(_resumeKey);
    if (saved is String) {
      try {
        return CommentCrawlState.fromJson(
          jsonDecode(saved) as Map<String, dynamic>,
        );
      } catch (_) {}
    }
    return CommentCrawlState();
  }

  void _saveCheckpoint() =>
      GStorage.localCache.put(_resumeKey, jsonEncode(_state.toJson()));

  /// 按当前选中的格式生成文本，复制和落盘共用
  String _buildText() => _format == CommentExportFormat.csv
      ? CommentUtils.toCsv(_state.comments)
      : CommentUtils.toTxt(_state.comments);

  void _copy() => Utils.copyText(_buildText());

  Future<void> _start() async {
    // 运行中再点一次 = 停止，让正在跑的那次去收尾
    if (_running) {
      setState(() => _stopped = true);
      return;
    }
    setState(() {
      _running = true;
      _stopped = false;
      _status = '正在抓取...';
    });
    final watch = Stopwatch()..start();
    try {
      await ReplyHttp.crawlComments(
        oid: widget.oid,
        type: widget.type,
        state: _state,
        isCancelled: () => _stopped,
        onCheckpoint: (_) => _saveCheckpoint(),
        onProgress: () {
          // 回调很密，限到约 5 次/秒，避免整棵树频繁重建
          final ms = watch.elapsedMilliseconds;
          if (ms - _lastTick < 200 || !mounted) return;
          _lastTick = ms;
          setState(() => _status = '正在抓取...已获取 ${_state.comments.length} 条');
        },
      );
      if (!mounted) return;
      GStorage.localCache.delete(_resumeKey);
      final stopped = _stopped;
      await StorageUtils.saveBytes2File(
        name: '${widget.fileName}.${_format.name}',
        bytes: utf8.encode(_buildText()),
        allowedExtensions: [_format.name],
      );
      if (!mounted) return;
      setState(() {
        _status = stopped
            ? '已停止：导出前 ${_state.comments.length} 条评论'
            : '导出完成：共 ${_state.comments.length} 条评论，'
                  '耗时 ${watch.elapsed.inSeconds} 秒';
      });
    } on CommentCrawlException catch (e) {
      _saveCheckpoint();
      if (!mounted) return;
      setState(() {
        _status = e.isRiskControl
            ? '触发B站风控：${e.message}\n'
                  '已抓 ${_state.comments.length} 条，断点已保存，稍后点"继续抓取"可续爬'
            : '抓取失败：${e.message}';
      });
    } catch (e) {
      _saveCheckpoint();
      if (!mounted) return;
      setState(() => _status = '抓取失败：$e\n断点已保存，稍后点"继续抓取"可续爬');
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final secondary = colorScheme.secondary;
    final running = _running;
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      constraints: Style.dialogFixedConstraints,
      title: const Text('导出评论'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('格式', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 8),
              for (final format in CommentExportFormat.values)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TextButton(
                    onPressed: running
                        ? null
                        : () => setState(() => _format = format),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(64, 32),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      foregroundColor: secondary,
                      backgroundColor: _format == format
                          ? secondary.withValues(alpha: 0.12)
                          : null,
                    ),
                    child: Text(
                      format.name.toUpperCase(),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _status,
            style: TextStyle(fontSize: 12, color: secondary),
          ),
          TextButton.icon(
            // 抓取中不给复制，避免复制到半截数据
            onPressed: running || _state.comments.isEmpty ? null : _copy,
            icon: const Icon(Icons.copy_all_outlined, size: 16),
            label: const Text(
              '复制到剪贴板',
              style: TextStyle(fontSize: 13),
            ),
            style: TextButton.styleFrom(
              minimumSize: const Size(0, 32),
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: running ? null : Get.back,
          child: Text('关闭', style: TextStyle(color: colorScheme.outline)),
        ),
        TextButton(
          onPressed: _start,
          child: Text(
            running
                ? '停止并导出'
                : _state.comments.isEmpty
                ? '开始抓取'
                : '继续抓取',
          ),
        ),
      ],
    );
  }
}
