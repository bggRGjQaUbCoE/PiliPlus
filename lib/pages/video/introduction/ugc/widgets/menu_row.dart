import 'package:PiliPlus/utils/feed_back.dart';
import 'package:flutter/material.dart';

class ActionRowLineItem extends StatelessWidget {
  const ActionRowLineItem({
    super.key,
    required this.selectStatus,
    this.onTap,
    this.text,
    this.isLoading = false,
    this.iconData,
    this.icon,
  });
  final bool selectStatus;
  final Function? onTap;
  final bool isLoading;
  final String? text;
  final IconData? iconData;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: selectStatus ? theme.colorScheme.secondaryContainer : null,
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
                  : theme.colorScheme.secondaryContainer,
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
                      ? theme.colorScheme.onSecondaryContainer
                      : theme.colorScheme.outline,
                )
              else if (icon != null)
                icon!,
              AnimatedOpacity(
                opacity: isLoading ? 0 : 1,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  text!,
                  style: TextStyle(
                    fontSize: 13,
                    color: selectStatus
                        ? theme.colorScheme.onSecondaryContainer
                        : theme.colorScheme.outline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
