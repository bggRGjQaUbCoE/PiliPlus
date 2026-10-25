import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:PiliPlus/plugin/pl_player/models/hwdec_type.dart';

enum DolbyVisionProfile5Mode implements EnumWithLabel {
  software('软解（兼容）', HwDecType.no),
  mediacodec('MediaCodec 硬解（实验性）', HwDecType.mediacodec),
  mediacodecCopy('MediaCodec-copy 硬解（实验性）', HwDecType.mediacodecCopy);

  @override
  final String label;
  final HwDecType decoding;

  const DolbyVisionProfile5Mode(this.label, this.decoding);

  String get hwdec => decoding.hwdec;
}
