import 'package:PiliPlus/models/common/enum_with_label.dart';

enum SeekPreviewPosition implements EnumWithLabel {
  playerCenter('播放器中央'),
  aboveProgressBar('进度条上方');

  const SeekPreviewPosition(this.label);

  @override
  final String label;
}
