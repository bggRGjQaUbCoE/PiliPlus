import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:material_ui/material_ui.dart';

class SimpleAppBar extends StatelessWidget {
  const SimpleAppBar({
    super.key,
    required this.height,
    required this.brightness,
    this.statusBarBrightness = .dark,
    this.statusBarIconBrightness = .light,
    this.backgroundColor = Colors.black,
  });

  final double height;
  final Brightness brightness;
  final Brightness statusBarBrightness;
  final Brightness statusBarIconBrightness;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: statusBarBrightness,
        statusBarIconBrightness: statusBarIconBrightness,
        statusBarColor: Colors.transparent,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: brightness.reverse,
      ),
      child: ColoredBox(
        color: backgroundColor,
        child: SizedBox(height: height, width: .infinity),
      ),
    );
  }
}
