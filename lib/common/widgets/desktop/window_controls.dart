import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowControls extends StatefulWidget {
  const WindowControls({super.key});

  @override
  State<WindowControls> createState() => _WindowControlsState();
}

class _WindowControlsState extends State<WindowControls> {
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    windowManager.isMaximized().then((v) {
      if (mounted) setState(() => _isMaximized = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ControlButton(
          icon: Icons.remove,
          onPressed: windowManager.minimize,
          hoverColor: colorScheme.surfaceContainerHighest,
        ),
        _ControlButton(
          icon: _isMaximized ? Icons.filter_none_rounded : Icons.crop_square,
          iconSize: _isMaximized ? 14 : 16,
          onPressed: () async {
            if (_isMaximized) {
              await windowManager.unmaximize();
            } else {
              await windowManager.maximize();
            }
            setState(() => _isMaximized = !_isMaximized);
          },
          hoverColor: colorScheme.surfaceContainerHighest,
        ),
        _ControlButton(
          icon: Icons.close,
          onPressed: windowManager.close,
          hoverColor: Colors.red,
          hoverIconColor: Colors.white,
        ),
      ],
    );
  }
}

class _ControlButton extends StatefulWidget {
  const _ControlButton({
    required this.icon,
    required this.onPressed,
    this.iconSize = 16,
    this.hoverColor,
    this.hoverIconColor,
  });

  final IconData icon;
  final double iconSize;
  final VoidCallback onPressed;
  final Color? hoverColor;
  final Color? hoverIconColor;

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: 46,
          height: 32,
          color: _hovering ? widget.hoverColor : Colors.transparent,
          alignment: Alignment.center,
          child: Icon(
            widget.icon,
            size: widget.iconSize,
            color: _hovering && widget.hoverIconColor != null
                ? widget.hoverIconColor
                : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
