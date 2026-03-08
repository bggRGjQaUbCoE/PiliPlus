import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/view_sliver_safe_area.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart';
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/reply_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/waterfall.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class MyReply extends StatefulWidget {
  const MyReply({super.key});

  @override
  State<MyReply> createState() => _MyReplyState();
}

class _MyReplyState extends State<MyReply> with DynMixin {
  late final List<ReplyInfo> _replies;

  @override
  void initState() {
    super.initState();
    _replies = GStorage.reply!.values.map(ReplyInfo.fromBuffer).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的评论'),
        actions: kDebugMode
            ? [
                IconButton(
                  tooltip: 'Clear',
                  onPressed: () => showConfirmDialog(
                    context: context,
                    title: 'Clear Local Storage?',
                    onConfirm: () {
                      GStorage.reply!.clear();
                      _replies.clear();
                      setState(() {});
                    },
                  ),
                  icon: const Icon(Icons.clear_all),
                ),
                const SizedBox(width: 6),
              ]
            : null,
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
}
