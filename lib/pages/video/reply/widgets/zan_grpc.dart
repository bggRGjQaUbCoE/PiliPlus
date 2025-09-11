import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/http/reply.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ZanButtonGrpc extends StatelessWidget {
  const ZanButtonGrpc({
    super.key,
    required this.replyItem,
  });

  final ReplyInfo replyItem;

  Future<void> onHateReply(
    BuildContext context,
    bool isProcessing,
    VoidCallback onDone, {
    required bool isLike,
    required bool isDislike,
  }) async {
    if (isProcessing) {
      return;
    }
    isProcessing = true;
    feedBack();
    final int oid = replyItem.oid.toInt();
    final int rpid = replyItem.id.toInt();
    // 1 已点赞 2 不喜欢 0 未操作
    final int action = isDislike ? 0 : 2;
    final res = await ReplyHttp.hateReply(
      type: replyItem.type.toInt(),
      action: action == 2 ? 1 : 0,
      oid: oid,
      rpid: rpid,
    );
    // SmartDialog.dismiss();
    if (res['status']) {
      SmartDialog.showToast(isDislike ? '取消踩' : '点踩成功');
      if (action == 2) {
        if (isLike) replyItem.like -= $fixnum.Int64.ONE;
        replyItem.replyControl.action = $fixnum.Int64.TWO;
      } else {
        replyItem.replyControl.action = $fixnum.Int64.ZERO;
      }
      if (context.mounted) {
        (context as Element?)?.markNeedsBuild();
      }
    } else {
      SmartDialog.showToast(res['msg']);
    }
    onDone();
  }

  // 评论点赞
  Future<void> onLikeReply(
    BuildContext context,
    bool isProcessing,
    VoidCallback onDone, {
    required bool isLike,
    required bool isDislike,
  }) async {
    if (isProcessing) {
      return;
    }
    isProcessing = true;
    feedBack();
    final int oid = replyItem.oid.toInt();
    final int rpid = replyItem.id.toInt();
    // 1 已点赞 2 不喜欢 0 未操作
    final int action = isLike ? 0 : 1;
    final res = await ReplyHttp.likeReply(
      type: replyItem.type.toInt(),
      oid: oid,
      rpid: rpid,
      action: action,
    );
    if (res['status']) {
      SmartDialog.showToast(isLike ? '取消赞' : '点赞成功');
      if (action == 1) {
        replyItem
          ..like += $fixnum.Int64.ONE
          ..replyControl.action = $fixnum.Int64.ONE;
      } else {
        replyItem
          ..like -= $fixnum.Int64.ONE
          ..replyControl.action = $fixnum.Int64.ZERO;
      }
      if (context.mounted) {
        (context as Element?)?.markNeedsBuild();
      }
    } else {
      SmartDialog.showToast(res['msg']);
    }
    onDone();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    late bool isProcessing = false;
    final action = replyItem.replyControl.action;
    final isLike = action == $fixnum.Int64.ONE;
    final isDislike = action == $fixnum.Int64.TWO;
    final outline = theme.colorScheme.outline;
    final primary = theme.colorScheme.primary;
    final ButtonStyle style = TextButton.styleFrom(
      padding: EdgeInsets.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 32,
          child: TextButton(
            style: style,
            onPressed: () => onHateReply(
              context,
              isProcessing,
              () => isProcessing = false,
              isLike: isLike,
              isDislike: isDislike,
            ),
            child: Icon(
              isDislike
                  ? FontAwesomeIcons.solidThumbsDown
                  : FontAwesomeIcons.thumbsDown,
              size: 16,
              color: isDislike ? primary : outline,
              semanticLabel: isDislike ? '已踩' : '点踩',
            ),
          ),
        ),
        SizedBox(
          height: 32,
          child: TextButton(
            style: style,
            onPressed: () => onLikeReply(
              context,
              isProcessing,
              () => isProcessing = false,
              isLike: isLike,
              isDislike: isDislike,
            ),
            child: Row(
              spacing: 4,
              children: [
                Icon(
                  isLike
                      ? FontAwesomeIcons.solidThumbsUp
                      : FontAwesomeIcons.thumbsUp,
                  size: 16,
                  color: isLike ? primary : outline,
                  semanticLabel: isLike ? '已赞' : '点赞',
                ),
                Text(
                  NumUtils.numFormat(replyItem.like.toInt()),
                  style: TextStyle(
                    color: isLike ? primary : outline,
                    fontSize: theme.textTheme.labelSmall!.fontSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
