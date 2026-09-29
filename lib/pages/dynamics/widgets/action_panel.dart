import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/dynamics_repost/view.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';

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
                  semanticLabel: L10n.current.repost,
                ),
                style: btnStyle,
                label: Text(
                  forward.count != null
                      ? NumUtils.numFormat(forward.count)
                      : L10n.current.repost,
                ),
              );
            },
          ),
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: () => PageUtils.pushDynDetail(
              item,
              isPush: true,
              viewComment: true,
            ),
            icon: Icon(
              FontAwesomeIcons.comment,
              size: 16,
              color: outline,
              semanticLabel: L10n.current.comments,
            ),
            style: btnStyle,
            label: Text(
              comment.count != null
                  ? NumUtils.numFormat(comment.count)
                  : L10n.current.comments,
            ),
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
                label = L10n.current.liked;
              } else {
                icon = FontAwesomeIcons.thumbsUp;
                color = outline;
                label = L10n.current.like;
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
                    like.count != null
                        ? NumUtils.numFormat(like.count)
                        : L10n.current.like,
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
