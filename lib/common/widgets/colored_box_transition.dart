import 'package:material_ui/material_ui.dart';

class ColoredBoxTransition extends AnimatedWidget {
  const ColoredBoxTransition({
    super.key,
    required this.color,
    this.child,
  }) : super(listenable: color);

  final Animation<Color?> color;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color.value!,
      child: child,
    );
  }
}
