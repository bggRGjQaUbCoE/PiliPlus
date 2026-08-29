import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/dialog/export_import.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/view_sliver_safe_area.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/pages/video/reply_reply/view.dart';
import 'package:PiliPlus/utils/reply_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/waterfall.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class MyReply extends StatefulWidget {
  const MyReply({super.key});

  @override
  State<MyReply> createState() => _MyReplyState();
}

class _MyReplyState extends State<MyReply> with DynMixin {
  final List<ReplyInfo> _replies = <ReplyInfo>[];
  bool _isSearching = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _initReply();
  }

  void _initReply() {
    _replies
      ..assignAll(GStorage.reply!.values.map(ReplyInfo.fromBuffer))
      ..sort((a, b) => b.ctime.compareTo(a.ctime)); // rpid not aligned;
  }

  @override
  Widget build(BuildContext context) {
    final replies = _query.isEmpty
        ? _replies
        : _replies.where(_matchesQuery).toList();
    return SimpleScaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: '搜索评论内容、用户名或 IP 属地',
                  border: InputBorder.none,
                ),
                onChanged: (value) => setState(() => _query = value.trim()),
              )
            : const Text('我的评论'),
        actions: [
          IconButton(
            tooltip: _isSearching ? '关闭搜索' : '搜索',
            onPressed: () => setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) _query = '';
            }),
            icon: Icon(_isSearching ? Icons.close : Icons.search_outlined),
          ),
          if (!_isSearching) ...[
            if (kDebugMode)
              IconButton(
                tooltip: 'Clear',
                onPressed: () => showConfirmDialog(
                  context: context,
                  title: const Text('Clear Local Storage?'),
                  onConfirm: () {
                    GStorage.reply!.clear();
                    _replies.clear();
                    setState(() {});
                  },
                ),
                icon: const Icon(Icons.clear_all),
              ),
            IconButton(
              tooltip: '导出',
              onPressed: _showExportDialog,
              icon: const Icon(Icons.file_upload_outlined),
            ),
            IconButton(
              tooltip: '导入',
              onPressed: _showImportDialog,
              icon: const Icon(Icons.file_download_outlined),
            ),
          ],
          const SizedBox(width: 6),
        ],
      ),
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          replies.isNotEmpty
              ? ViewSliverSafeArea(
                  sliver: SliverWaterfallFlow(
                    gridDelegate: dynGridDelegate,
                    delegate: SliverChildBuilderDelegate(
                      childCount: replies.length,
                      (context, index) => ReplyItemGrpc(
                        replyLevel: 0,
                        needDivider: false,
                        replyItem: replies[index],
                        replyReply: _replyReply,
                        onDelete: (_, _) => _onDelete(replies[index]),
                        onCheckReply: _onCheckReply,
                      ),
                    ),
                  ),
                )
              : const HttpError(),
        ],
      ),
    );
  }

  bool _matchesQuery(ReplyInfo reply) {
    final query = _query.toLowerCase();
    return reply.content.message.toLowerCase().contains(query) ||
        reply.member.name.toLowerCase().contains(query) ||
        reply.replyControl.location.toLowerCase().contains(query);
  }

  void _replyReply(ReplyInfo replyInfo, int? _) {
    final oid = replyInfo.oid.toInt();
    final id = replyInfo.id.toInt();
    final type = replyInfo.type.toInt();
    final rootId = replyInfo.root == 0 ? id : replyInfo.root.toInt();
    final sourceUri = switch (type) {
      1 => Uri(scheme: 'bilibili', host: 'video', path: '/$oid'),
      12 => Uri.parse('https://www.bilibili.com/read/cv$oid'),
      17 => Uri(scheme: 'bilibili', host: 'following', path: '/detail/$oid'),
      _ => null,
    };
    VideoReplyReplyPanel.toReply(
      oid: oid,
      rootId: rootId,
      rpIdStr: id == rootId ? null : id.toString(),
      type: type,
      uri: sourceUri,
    );
  }

  void _onDelete(ReplyInfo reply) {
    _replies.remove(reply);
    setState(() {});
  }

  void _onCheckReply(ReplyInfo replyInfo) {
    final oid = replyInfo.oid.toInt();
    ReplyUtils.onCheckReply(
      replyInfo: replyInfo,
      biliSendCommAntifraud: Pref.biliSendCommAntifraud,
      sourceId: replyInfo.type.toInt() == 1
          ? IdUtils.av2bv(oid)
          : oid.toString(),
      isManual: true,
    );
  }

  String _onExport() {
    return Utils.jsonEncoder.convert(
      _replies.map((e) => e.toProto3Json()).toList(),
    );
  }

  void _showExportDialog() {
    const style = TextStyle(fontSize: 14);
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        clipBehavior: .hardEdge,
        contentPadding: const .symmetric(vertical: 12),
        children: [
          ListTile(
            dense: true,
            title: const Text('导出至剪贴板', style: style),
            onTap: () {
              Get.back();
              exportToClipBoard(onExport: _onExport);
            },
          ),
          ListTile(
            dense: true,
            title: const Text('导出文件至本地', style: style),
            onTap: () {
              Get.back();
              exportToLocalFile(
                onExport: _onExport,
                localFileName: () => 'reply',
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onImport(List<dynamic> list) async {
    await GStorage.reply!.putAll({
      for (var e in list)
        e['id'].toString(): (ReplyInfo.create()..mergeFromProto3Json(e))
            .writeToBuffer(),
    });
    if (mounted) {
      _initReply();
      setState(() {});
    }
  }

  void _showImportDialog() {
    const style = TextStyle(fontSize: 14);
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        clipBehavior: .hardEdge,
        contentPadding: const .symmetric(vertical: 12),
        children: [
          ListTile(
            dense: true,
            title: const Text('从剪贴板导入', style: style),
            onTap: () {
              Get.back();
              importFromClipBoard<List<dynamic>>(
                context,
                title: '评论',
                onExport: _onExport,
                onImport: _onImport,
                showConfirmDialog: false,
              );
            },
          ),
          ListTile(
            dense: true,
            title: const Text('从本地文件导入', style: style),
            onTap: () {
              Get.back();
              importFromLocalFile<List<dynamic>>(onImport: _onImport);
            },
          ),
        ],
      ),
    );
  }
}
