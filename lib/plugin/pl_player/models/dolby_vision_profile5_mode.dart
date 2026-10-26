import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:PiliPlus/plugin/pl_player/models/hwdec_type.dart';

enum DolbyVisionProfile5Mode implements EnumWithLabel {
  software('软解（兼容）', HwDecType.no),
  media3('Media3 原生播放器（实验性）', null);

  @override
  final String label;
  final HwDecType? decoding;

  const DolbyVisionProfile5Mode(this.label, this.decoding);

  String get hwdec =>
      decoding?.hwdec ??
      (throw StateError('Media3 is a separate player, not an mpv decoder'));

  static DolbyVisionProfile5Mode fromPreference(String value) => switch (value) {
    // Retired experimental mpv modes keep the safe compatibility fallback.
    'mediacodec' || 'mediacodecCopy' => software,
    _ => values.byName(value),
  };

  static bool isProfile5Codec(String? codecs) =>
      codecs != null &&
      RegExp(
        r'^(dvhe|dvh1)\.0?5\.',
        caseSensitive: false,
      ).hasMatch(codecs.trim());
}
