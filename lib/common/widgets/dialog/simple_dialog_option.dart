import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/material.dart';

final EdgeInsets _padding = PlatformUtils.isMobile
    ? const .only(left: 16, top: 14, bottom: 14)
    : const .only(left: 16, top: 10, bottom: 10);

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
