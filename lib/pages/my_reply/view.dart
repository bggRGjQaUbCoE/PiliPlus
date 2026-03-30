import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/dialog/export_import.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/view_sliver_safe_area.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/reply_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/waterfall.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class MyReply extends StatefulWidget {
  const MyReply({super.key});

  @override
  State<MyReply> createState() => _MyReplyState();
}

class _MyReplyState extends State<MyReply> with DynMixin {
  final List<ReplyInfo> _replies = <ReplyInfo>[];

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的评论'),
        actions: [
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
          const SizedBox(width: 6),
        ],
      ),
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _replies.isNotEmpty
              ? ViewSliverSafeArea(
                  sliver: SliverWaterfallFlow(
                    gridDelegate: dynGridDelegate,
                    delegate: SliverChildBuilderDelegate(
                      childCount: _replies.length,
                      (context, index) => ReplyItemGrpc(
                        replyLevel: 0,
                        needDivider: false,
                        replyItem: _replies[index],
                        replyReply: _replyReply,
                        onDelete: (_, _) => _onDelete(index),
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

  void _replyReply(ReplyInfo replyInfo, int? rpid) {
    switch (replyInfo.type.toInt()) {
      case 1:
        PiliScheme.videoPush(
          replyInfo.oid.toInt(),
          null,
        );
      case 12:
        PageUtils.toDupNamed(
          '/articlePage',
          parameters: {
            'id': replyInfo.oid.toString(),
            'type': 'read',
          },
        );
      case _:
        PageUtils.pushDynFromId(
          rid: replyInfo.oid.toString(),
          type: replyInfo.type,
        );
    }
  }

  void _onDelete(int index) {
    _replies.removeAt(index);
    setState(() {});
  }

  void _onCheckReply(ReplyInfo replyInfo) {
    final oid = replyInfo.oid.toInt();
    ReplyUtils.onCheckReply(
      replyInfo: replyInfo,
      biliSendCommAntifraud: Pref.biliSendCommAntifraud,
      sourceId: switch (oid) {
        1 => IdUtils.av2bv(oid),
        _ => oid.toString(),
      },
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
