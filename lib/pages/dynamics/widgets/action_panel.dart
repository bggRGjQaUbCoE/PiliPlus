import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/common/publish/publish_route.dart';
import 'package:PiliPlus/pages/dynamics_repost/view.dart';
import 'package:PiliPlus/pages/video/reply_new/view.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class ActionPanel extends StatelessWidget {
  const ActionPanel({
    super.key,
    required this.item,
  });
  final DynamicItemModel item;

  void _onQuickReply(VoidCallback onUpdateUi) {
    feedBack();
    final commentType = item.basic?.commentType;
    final commentIdStr = item.basic?.commentIdStr;
    if (commentType != null &&
        commentType != 0 &&
        commentIdStr != null &&
        commentIdStr.isNotEmpty) {
      _showReplyPage(int.parse(commentIdStr), commentType, onUpdateUi);
    } else {
      SmartDialog.showLoading(msg: '加载中...');
      DynamicsHttp.dynamicDetail(id: item.idStr)
          .then((res) {
            SmartDialog.dismiss(status: SmartStatus.loading);
            if (res case Success(:final response)) {
              final bCommentId = response.basic?.commentIdStr;
              final bCommentType = response.basic?.commentType;
              if (bCommentId != null &&
                  bCommentId.isNotEmpty &&
                  bCommentType != null &&
                  bCommentType != 0) {
                _showReplyPage(int.parse(bCommentId), bCommentType, onUpdateUi);
              } else {
                SmartDialog.showToast('该动态不支持快速评论');
              }
            } else {
              res.toast();
            }
          })
          .catchError((e) {
            SmartDialog.dismiss(status: SmartStatus.loading);
            SmartDialog.showToast(e.toString());
          });
    }
  }

  void _showReplyPage(int oid, int replyType, VoidCallback onUpdateUi) {
    Get.key.currentState!
        .push(
          PublishRoute(
            pageBuilder: (buildContext, animation, secondaryAnimation) {
              return ReplyPage(
                oid: oid,
                root: 0,
                parent: 0,
                replyType: replyType,
              );
            },
          ),
        )
        .then((replyInfo) {
          if (replyInfo is ReplyInfo) {
            final comment = item.modules.moduleStat?.comment;
            if (comment != null) {
              comment.count = (comment.count ?? 0) + 1;
              onUpdateUi();
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final outline = theme.colorScheme.outline;
    final moduleStat = item.modules.moduleStat!;
    final forward = moduleStat.forward!;
    final comment = moduleStat.comment!;
    final like = moduleStat.like!;
    final btnStyle = TextButton.styleFrom(
      tapTargetSize: .padded,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      foregroundColor: outline,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Builder(
            builder: (context) {
              return TextButton.icon(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (_) => RepostPanel(
                    item: item,
                    onSuccess: () {
                      int count = forward.count ?? 0;
                      forward.count = count + 1;
                      if (context.mounted) {
                        (context as Element?)?.markNeedsBuild();
                      }
                    },
                  ),
                ),
                icon: Icon(
                  FontAwesomeIcons.shareFromSquare,
                  size: 16,
                  color: outline,
                  semanticLabel: "转发",
                ),
                style: btnStyle,
                label: Text(
                  forward.count != null
                      ? NumUtils.numFormat(forward.count)
                      : '转发',
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Builder(
            builder: (context) {
              return TextButton.icon(
                onPressed: () => PageUtils.pushDynDetail(
                  item,
                  isPush: true,
                  viewComment: true,
                ),
                onLongPress: Pref.enableQuickReplyDyn
                    ? () => _onQuickReply(() {
                        if (context.mounted) {
                          (context as Element?)?.markNeedsBuild();
                        }
                      })
                    : null,
                icon: Icon(
                  FontAwesomeIcons.comment,
                  size: 16,
                  color: outline,
                  semanticLabel: "评论",
                ),
                style: btnStyle,
                label: Text(
                  comment.count != null
                      ? NumUtils.numFormat(comment.count)
                      : '评论',
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Builder(
            builder: (context) {
              final IconData icon;
              final Color color;
              final String label;
              if (like.status ?? false) {
                icon = FontAwesomeIcons.solidThumbsUp;
                color = primary;
                label = '已赞';
              } else {
                icon = FontAwesomeIcons.thumbsUp;
                color = outline;
                label = '点赞';
              }
              final likeIcon = Icon(
                icon,
                size: 16,
                color: color,
                semanticLabel: label,
              );
              return TextButton.icon(
                onPressed: () => RequestUtils.onLikeDynamic(
                  item,
                  likeIcon.color == primary,
                  () {
                    if (context.mounted) {
                      (context as Element?)?.markNeedsBuild();
                    }
                  },
                ),
                icon: likeIcon,
                style: btnStyle,
                label: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Text(
                    like.count != null ? NumUtils.numFormat(like.count) : '点赞',
                    key: ValueKey<int?>(like.count),
                    style: TextStyle(color: like.status! ? primary : outline),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
