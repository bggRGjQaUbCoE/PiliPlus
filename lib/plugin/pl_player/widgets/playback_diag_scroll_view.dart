import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Scrolls compact player diagnostics through the normal ScrollPosition
/// lifecycle while bypassing the app SDK's viewport-bottom drag exclusion.
class PlaybackDiagScrollView extends StatefulWidget {
  const PlaybackDiagScrollView({
    super.key,
    this.viewportKey,
    this.physics = const ClampingScrollPhysics(),
    required this.child,
  });

  final Key? viewportKey;
  final ScrollPhysics physics;
  final Widget child;

  @override
  State<PlaybackDiagScrollView> createState() => _PlaybackDiagScrollViewState();
}

class _PlaybackDiagScrollViewState extends State<PlaybackDiagScrollView> {
  final ScrollController _scrollController = ScrollController();
  Drag? _drag;
  ScrollHoldController? _hold;

  void _handleDragDown(DragDownDetails details) {
    if (!_scrollController.hasClients) return;
    _hold = _scrollController.position.hold(_disposeHold);
  }

  void _handleDragStart(DragStartDetails details) {
    if (!_scrollController.hasClients) return;
    _drag = _scrollController.position.drag(details, _disposeDrag);
    if (_hold != null) _disposeHold();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _drag?.update(details);
  }

  void _handleDragEnd(DragEndDetails details) {
    _drag?.end(details);
  }

  void _handleDragCancel() {
    _hold?.cancel();
    _drag?.cancel();
    _hold = null;
    _drag = null;
  }

  void _disposeHold() => _hold = null;

  void _disposeDrag() => _drag = null;

  @override
  void dispose() {
    _hold?.cancel();
    _drag?.cancel();
    _hold = null;
    _drag = null;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrollConfiguration = ScrollConfiguration.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      supportedDevices: scrollConfiguration.dragDevices,
      excludeFromSemantics: true,
      onVerticalDragDown: _handleDragDown,
      onVerticalDragStart: _handleDragStart,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      onVerticalDragCancel: _handleDragCancel,
      child: ScrollConfiguration(
        // Keep wheel and semantics scrolling active while ensuring the SDK's
        // private VerticalDragGestureRecognizer does not reject the viewport's
        // lower 30 dp. The outer recognizer above uses the original device set.
        behavior: scrollConfiguration.copyWith(dragDevices: const {}),
        child: SingleChildScrollView(
          key: widget.viewportKey,
          controller: _scrollController,
          primary: false,
          physics: widget.physics,
          child: widget.child,
        ),
      ),
    );
  }
}
