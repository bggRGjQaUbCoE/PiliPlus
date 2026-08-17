import 'package:flutter/gestures.dart' show kBackMouseButton;
import 'package:material_ui/material_ui.dart';

class BackDetector extends StatelessWidget {
  const BackDetector({
    super.key,
    required this.onBack,
    required this.child,
  });

  final Widget child;

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: .translucent,
      onPointerDown: _onPointerDown,
      child: child,
    );
  }

  void _onPointerDown(PointerDownEvent event) {
    if (event.buttons == kBackMouseButton) {
      onBack();
    }
  }
}
