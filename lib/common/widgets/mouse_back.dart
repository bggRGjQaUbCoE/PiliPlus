import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MouseBackDetector extends StatelessWidget {
  const MouseBackDetector({
    super.key,
    required this.onTapDown,
    required this.child,
  });

  final Widget child;

  final VoidCallback onTapDown;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        if (event.buttons == kBackMouseButton) {
          onTapDown();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}
