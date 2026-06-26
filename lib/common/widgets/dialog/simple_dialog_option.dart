import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/material.dart';

final EdgeInsets _padding = PlatformUtils.isMobile
    ? const .symmetric(horizontal: 16, vertical: 14)
    : const .symmetric(horizontal: 16, vertical: 10);

class DialogOption extends StatelessWidget {
  const DialogOption({
    super.key,
    this.onPressed,
    this.child,
  });

  final VoidCallback? onPressed;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: _padding,
        child: child,
      ),
    );
  }
}
