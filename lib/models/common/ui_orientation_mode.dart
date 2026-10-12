import 'package:PiliPlus/models/common/enum_with_label.dart';

/// Preferred orientation for the app UI and fullscreen video playback.
enum UiOrientationMode with EnumWithLabel {
  off('关闭'),
  landscape('正向横屏'),
  reverseLandscape('反向横屏');

  @override
  final String label;

  const UiOrientationMode(this.label);
}
