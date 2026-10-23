import 'package:PiliPlus/utils/feed_back.dart';
import 'package:material_ui/material_ui.dart';

class ActionRowLineItem extends StatelessWidget {
  const ActionRowLineItem({
    super.key,
    required this.selectStatus,
    this.onTap,
    this.text,
    this.iconData,
    this.icon,
  });
  final bool selectStatus;
  final VoidCallback? onTap;
  final String? text;
  final IconData? iconData;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return Material(
      color: selectStatus ? colorScheme.secondaryContainer : null,
      type: selectStatus ? MaterialType.canvas : MaterialType.transparency,
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        onTap: () => {
          feedBack(),
          onTap?.call(),
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(13, 5.5, 13, 4.5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            border: Border.all(
              color: selectStatus
                  ? Colors.transparent
                  : colorScheme.secondaryContainer,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconData != null)
                Icon(
                  iconData,
                  size: 13,
                  color: selectStatus
                      ? colorScheme.onSecondaryContainer
                      : colorScheme.outline,
                )
              else
                ?icon,
              Text(
                text!,
                style: TextStyle(
                  fontSize: 13,
                  color: selectStatus
                      ? colorScheme.onSecondaryContainer
                      : colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionIconItem extends StatelessWidget {
  const ActionIconItem({
    super.key,
    required this.tooltip,
    required this.onTap,
    required this.iconData,
  });

  final String tooltip;
  final VoidCallback onTap;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return Tooltip(
      message: tooltip,
      child: Material(
        type: .transparency,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => {
            feedBack(),
            onTap(),
          },
          child: Container(
            padding: const .all(5),
            decoration: BoxDecoration(
              shape: .circle,
              border: Border.all(color: colorScheme.secondaryContainer),
            ),
            child: Icon(
              iconData,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
