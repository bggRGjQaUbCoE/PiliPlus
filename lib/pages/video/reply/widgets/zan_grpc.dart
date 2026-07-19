import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/http/reply.dart';
import 'package:PiliPlus/utils/async_operation_guard.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ZanButtonGrpc extends StatefulWidget {
  const ZanButtonGrpc({
    super.key,
    required this.replyItem,
  });

  final ReplyInfo replyItem;

  @override
  State<ZanButtonGrpc> createState() => _ZanButtonGrpcState();
}

class _ZanButtonGrpcState extends State<ZanButtonGrpc> {
  final _mutationGuard = AsyncOperationGuard();

  ReplyInfo get replyItem => widget.replyItem;

  Future<void> _onHateReply({
    required bool isLike,
    required bool isDislike,
  }) async {
    final target = replyItem;
    feedBack();
    final int oid = target.oid.toInt();
    final int rpid = target.id.toInt();
    // 1 已点赞 2 不喜欢 0 未操作
    final int action = isDislike ? 0 : 2;
    final res = await ReplyHttp.hateReply(
      type: target.type.toInt(),
      action: action == 2 ? 1 : 0,
      oid: oid,
      rpid: rpid,
    );
    // SmartDialog.dismiss();
    if (res.isSuccess) {
      SmartDialog.showToast(isDislike ? '取消踩' : '点踩成功');
      if (action == 2) {
        if (isLike) target.like -= $fixnum.Int64.ONE;
        target.replyControl.action = $fixnum.Int64.TWO;
      } else {
        target.replyControl.action = $fixnum.Int64.ZERO;
      }
      if (mounted) {
        setState(() {});
      }
    } else {
      res.toast();
    }
  }

  // 评论点赞
  Future<void> _onLikeReply({
    required bool isLike,
    required bool isDislike,
  }) async {
    final target = replyItem;
    feedBack();
    final int oid = target.oid.toInt();
    final int rpid = target.id.toInt();
    // 1 已点赞 2 不喜欢 0 未操作
    final int action = isLike ? 0 : 1;
    final res = await ReplyHttp.likeReply(
      type: target.type.toInt(),
      oid: oid,
      rpid: rpid,
      action: action,
    );
    if (res.isSuccess) {
      SmartDialog.showToast(isLike ? '取消赞' : '点赞成功');
      if (action == 1) {
        target
          ..like += $fixnum.Int64.ONE
          ..replyControl.action = $fixnum.Int64.ONE;
      } else {
        target
          ..like -= $fixnum.Int64.ONE
          ..replyControl.action = $fixnum.Int64.ZERO;
      }
      if (mounted) {
        setState(() {});
      }
    } else {
      res.toast();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
            style: const ButtonStyle(
              visualDensity: .compact,
              tapTargetSize: .shrinkWrap,
              padding: WidgetStatePropertyAll(.zero),
              minimumSize: WidgetStatePropertyAll(.square(40)),
            ),
            onPressed: () => _mutationGuard.run(
              () => _onHateReply(
                isLike: isLike,
                isDislike: isDislike,
              ),
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
            onPressed: () => _mutationGuard.run(
              () => _onLikeReply(
                isLike: isLike,
                isDislike: isDislike,
              ),
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
