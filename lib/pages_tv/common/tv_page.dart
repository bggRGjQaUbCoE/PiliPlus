import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TVPage extends StatefulWidget {
  const TVPage({
    super.key,
    required this.child,
    this.isRoot = false,
  });

  final Widget child;
  final bool isRoot;

  @override
  State<TVPage> createState() => _TVPageState();
}

class _TVPageState extends State<TVPage> {
  static bool _isExitDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    Widget child = SafeArea(
      minimum: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width * 0.03,
        vertical: MediaQuery.sizeOf(context).height * 0.03,
      ),
      child: widget.child,
    );

    if (widget.isRoot) {
      child = PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) {
            _showExitDialog(context);
          }
        },
        child: child,
      );
    }

    return child;
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
