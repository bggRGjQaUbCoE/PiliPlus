import 'package:PiliPlus/l10n/l10n.dart';

enum FollowOrderType {
  def(''),
  attention('attention'),
  ;

  final String type;
  String get title => switch (this) {
    def => L10n.current.followOrderTypeDefTitle,
    attention => L10n.current.followOrderTypeAttentionTitle,
  };

  const FollowOrderType(this.type);
}
