import 'package:flutter/material.dart';

class ViewInsetsSafeArea extends StatelessWidget {
  const ViewInsetsSafeArea({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    return Padding(
      padding: .only(bottom: viewInsets.bottom),
      child: child,
    );
  }
}
