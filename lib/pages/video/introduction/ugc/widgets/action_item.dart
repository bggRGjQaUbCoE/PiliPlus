import 'package:PiliPlus/common/widgets/custom_arc.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/material.dart';

class ActionItem extends StatelessWidget {
  const ActionItem({
    super.key,
    required this.icon,
    this.onTap,
    this.onLongPress,
    this.text,
    this.selectStatus = false,
    this.expand = true,
    this.animation,
    this.onStartTriple,
    this.onCancelTriple,
  }) : _isThumbsUp = onStartTriple != null;

  final Icon icon;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? text;
  final bool selectStatus;
  final bool expand;
  final Animation<double>? animation;
  final VoidCallback? onStartTriple;
  final void Function([bool])? onCancelTriple;
  final bool _isThumbsUp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    late final primary = !expand && colorScheme.isLight
        ? colorScheme.inversePrimary
        : colorScheme.primary;
    Widget child = Icon(
      icon.icon,
      size: icon.size ?? 20.5,
      color: selectStatus ? primary : icon.color ?? colorScheme.outline,
    );

    if (animation != null) {
      child = Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: animation!,
            builder: (context, child) => Arc(
              size: 28,
              color: primary,
              progress: -animation!.value,
              strokeWidth: 1.6,
            ),
          ),
          child,
        ],
      );
    } else {
      child = SizedBox.square(dimension: 28, child: child);
    }

    child = Material(
      type: .transparency,
      child: InkWell(
        borderRadius: const .all(.circular(6)),
        onTap: _isThumbsUp ? null : onTap,
        onLongPress: _isThumbsUp ? null : onLongPress,
        onSecondaryTap: PlatformUtils.isMobile || _isThumbsUp
            ? null
            : onLongPress,
        onTapDown: _isThumbsUp ? (_) => onStartTriple!() : null,
        onTapUp: _isThumbsUp ? (_) => onCancelTriple!(true) : null,
        onTapCancel: _isThumbsUp ? onCancelTriple : null,
        child: expand
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [child, _buildText(theme)],
              )
            : child,
      ),
    );
    return expand ? Expanded(child: child) : child;
  }

  Widget _buildText(ThemeData theme) {
    return Text(
      text != null ? text! : '-',
      style: TextStyle(
        color: selectStatus
            ? theme.colorScheme.primary
            : theme.colorScheme.outline,
        fontSize: theme.textTheme.labelSmall!.fontSize,
      ),
    );
  }
}
