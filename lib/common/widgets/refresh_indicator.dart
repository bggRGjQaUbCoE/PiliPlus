import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:material_ui/material_ui.dart';

// ignore: camel_case_types
class RefreshIndicator_ extends StatefulWidget {
  const RefreshIndicator_({
    super.key,
    required this.isRefreshing,
  });

  final bool isRefreshing;

  @override
  State<RefreshIndicator_> createState() => _RefreshIndicatorState();
}

class _RefreshIndicatorState extends State<RefreshIndicator_>
    with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final AnimationController _progressController;
  late Color _color;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addStatusListener(_onScaleStatus);
    _progressController = AnimationController(
      vsync: this,
      duration: CircularProgressIndicator.defaultAnimationDuration,
    );
  }

  // Shrunk away, it lets the spinner go: see build.
  void _onScaleStatus(AnimationStatus status) {
    if (status.isDismissed && mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RefreshIndicator_ oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isRefreshing != widget.isRefreshing) {
      if (widget.isRefreshing) {
        _scaleController.value = 1;
        _progressController
          ..value = 0.0
          ..repeat();
      } else {
        _scaleController.reverse();
        _progressController.stop();
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final colorScheme = ColorScheme.of(context);
    _color = colorScheme.isDark
        ? colorScheme.onInverseSurface
        : colorScheme.surface;
  }

  @override
  Widget build(BuildContext context) {
    // Hidden, it builds no spinner: an indeterminate CircularProgressIndicator
    // repeats an animation of its own, a controller given or not, which drew
    // the page under it at 60 fps forever, still as it stood.
    if (!widget.isRefreshing && _scaleController.isDismissed) {
      return const SizedBox.shrink();
    }
    return ScaleTransition(
      scale: _scaleController,
      child: Center(
        child: SizedBox.square(
          dimension: 40,
          child: Material(
            type: .circle,
            elevation: 2.0,
            color: _color,
            child: Padding(
              padding: const .all(6),
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                controller: _progressController,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
