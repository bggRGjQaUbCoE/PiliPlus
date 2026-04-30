import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TVFocusWrapper extends StatefulWidget {
  const TVFocusWrapper({
    super.key,
    required this.child,
    this.onSelect,
    this.onLongPress,
    this.focusNode,
    this.autoFocus = false,
    this.scaleFactor = 1.1,
    this.borderWidth = 3.0,
    this.borderRadius = 12.0,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  final Widget child;
  final VoidCallback? onSelect;
  final VoidCallback? onLongPress;
  final FocusNode? focusNode;
  final bool autoFocus;
  final double scaleFactor;
  final double borderWidth;
  final double borderRadius;
  final Duration animationDuration;

  @override
  State<TVFocusWrapper> createState() => _TVFocusWrapperState();
}

class _TVFocusWrapperState extends State<TVFocusWrapper>
    with SingleTickerProviderStateMixin {
  late final FocusNode _focusNode;
  bool _isFocused = false;
  bool _longPressTriggered = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange(bool hasFocus) {
    setState(() => _isFocused = hasFocus);
    if (hasFocus) {
      Scrollable.ensureVisible(
        context,
        alignment: 0.5,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.select) {
      if (event is KeyDownEvent) {
        _longPressTriggered = false;
        widget.onSelect?.call();
        return KeyEventResult.handled;
      }
      if (event is KeyRepeatEvent && widget.onLongPress != null) {
        if (!_longPressTriggered) {
          _longPressTriggered = true;
          widget.onLongPress!.call();
        }
        return KeyEventResult.handled;
      }
      if (event is KeyUpEvent) {
        _longPressTriggered = false;
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autoFocus,
      onFocusChange: _onFocusChange,
      onKeyEvent: _onKeyEvent,
      child: GestureDetector(
        onTap: widget.onSelect,
        onLongPress: widget.onLongPress,
        child: AnimatedScale(
          scale: _isFocused ? widget.scaleFactor : 1.0,
          duration: widget.animationDuration,
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: widget.animationDuration,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: _isFocused
                    ? colorScheme.primary
                    : Colors.transparent,
                width: widget.borderWidth,
              ),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                widget.borderRadius - widget.borderWidth,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
