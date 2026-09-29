import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/enum_with_label.dart';

enum SuperChatType implements EnumWithLabel {
  valid,
  persist,
  disable,
  ;

  @override
  String get label => switch (this) {
    valid => L10n.current.superChatTypeValidLabel,
    persist => L10n.current.superChatTypePersistLabel,
    disable => L10n.current.superChatTypeDisableLabel,
  };
}
