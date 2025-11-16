import 'package:PiliPlus/common/widgets/flutter/dyn/text_button.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/dynamics_repost/view.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:flutter/material.dart' hide TextButton;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActionPanel extends StatelessWidget {
  const ActionPanel({
    super.key,
    required this.item,
  });
  final DynamicItemModel item;

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
      padding: const EdgeInsets.symmetric(horizontal: 15),
      foregroundColor: outline,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: TextButton.icon(
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (_) => RepostPanel(
                item: item,
                callback: () {
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
              forward.count != null ? NumUtils.numFormat(forward.count) : '转发',
            ),
          ),
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: () => PageUtils.pushDynDetail(item, isPush: true),
            icon: Icon(
              FontAwesomeIcons.comment,
              size: 16,
              color: outline,
              semanticLabel: "评论",
            ),
            style: btnStyle,
            label: Text(
              comment.count != null ? NumUtils.numFormat(comment.count) : '评论',
            ),
          ),
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: () => RequestUtils.onLikeDynamic(item, () {
              if (context.mounted) {
                (context as Element?)?.markNeedsBuild();
              }
            }),
            icon: Icon(
              like.status!
                  ? FontAwesomeIcons.solidThumbsUp
                  : FontAwesomeIcons.thumbsUp,
              size: 16,
              color: like.status! ? primary : outline,
              semanticLabel: like.status! ? "已赞" : "点赞",
            ),
            style: btnStyle,
            label: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                like.count != null ? NumUtils.numFormat(like.count) : '点赞',
                key: ValueKey<String>(like.count?.toString() ?? '点赞'),
                style: TextStyle(color: like.status! ? primary : outline),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
