import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';

enum SuperResolutionType with EnumWithLabel {
  disable,
  efficiency,
  quality,
  ;

  @override
  String get label => switch (this) {
    disable => L10n.current.disable,
    efficiency => L10n.current.superResolutionTypeEfficiencyLabel,
    quality => L10n.current.videoQuality,
  };
}
