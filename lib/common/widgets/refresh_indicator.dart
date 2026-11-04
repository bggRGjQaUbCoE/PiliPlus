import 'dart:async' show StreamSubscription;

import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart' show RxBool;
import 'package:material_ui/material_ui.dart';

// ignore: camel_case_types
class RefreshIndicator_ extends StatefulWidget {
  const RefreshIndicator_({
    super.key,
    required this.isRefreshing,
  });

  final RxBool isRefreshing;

  @override
  State<RefreshIndicator_> createState() => _RefreshIndicatorState();
}

class _RefreshIndicatorState extends State<RefreshIndicator_>
    with TickerProviderStateMixin {
  late Color _color;
  late final StreamSubscription _listener;
  late final AnimationController _scaleController;

  void _onRefreshChanged(bool isRefreshing) {
    if (!mounted) return;
    if (isRefreshing) {
      _scaleController.value = 1;
      setState(() {});
    } else {
      _scaleController.reverse().whenComplete(_stopProgress);
    }
  }

  void _stopProgress() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _listener = widget.isRefreshing.listen(_onRefreshChanged);
  }

  @override
  void dispose() {
    _listener.cancel();
    _scaleController.dispose();
    super.dispose();
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
    if (!widget.isRefreshing.value) {
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
            child: const Padding(
              padding: .all(6),
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ),
        ),
      ),
    );
  }
}
