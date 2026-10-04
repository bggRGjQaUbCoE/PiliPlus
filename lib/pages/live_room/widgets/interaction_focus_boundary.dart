import 'package:material_ui/material_ui.dart';

/// EditableText receives events first; keys it leaves unhandled must not reach
/// the surrounding player (space, arrows, F, R and Enter control playback).
class LiveInteractionFocusBoundary extends StatelessWidget {
  const LiveInteractionFocusBoundary({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Focus(
    onKeyEvent: (_, _) => KeyEventResult.skipRemainingHandlers,
    child: child,
  );
}
