import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TVPage extends StatefulWidget {
  const TVPage({
    super.key,
    required this.child,
    this.isRoot = false,
    this.onMenuPressed,
  });

  final Widget child;
  final bool isRoot;
  final VoidCallback? onMenuPressed;

  @override
  State<TVPage> createState() => _TVPageState();
}

class _TVPageState extends State<TVPage> {
  late final FocusNode _focusNode;
  static bool _isExitDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: false,
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        if (event.logicalKey == LogicalKeyboardKey.goBack ||
            event.logicalKey == LogicalKeyboardKey.escape) {
          if (widget.isRoot) {
            _showExitDialog(context);
          } else if (mounted) {
            Get.back();
          }
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.contextMenu) {
          widget.onMenuPressed?.call();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: SafeArea(
        minimum: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.03,
          vertical: MediaQuery.sizeOf(context).height * 0.03,
        ),
        child: widget.child,
      ),
    );
  }

  static void _showExitDialog(BuildContext context) {
    if (_isExitDialogShowing) return;
    _isExitDialogShowing = true;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('提示'),
        content: const Text('确定退出应用吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    ).then((_) {
      _isExitDialogShowing = false;
    });
  }
}
