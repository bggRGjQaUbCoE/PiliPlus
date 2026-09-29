import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';

enum SkipType implements EnumWithLabel {
  alwaysSkip,
  skipOnce,
  skipManually,
  showOnly,
  disable,
  ;

  @override
  String get label => switch (this) {
    alwaysSkip => L10n.current.skipTypeAlwaysSkipLabel,
    skipOnce => L10n.current.skipTypeSkipOnceLabel,
    skipManually => L10n.current.skipTypeSkipManuallyLabel,
    showOnly => L10n.current.skipTypeShowOnlyLabel,
    disable => L10n.current.disable,
  };
}
