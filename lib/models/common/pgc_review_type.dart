import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/l10n/l10n.dart';

enum PgcReviewType {
  long(api: Api.pgcReviewL),
  short(api: Api.pgcReviewS),
  ;

  String get label => switch (this) {
    long => L10n.current.pgcReviewTypeLongLabel,
    short => L10n.current.pgcReviewTypeShortLabel,
  };
  final String api;
  const PgcReviewType({required this.api});
}

enum PgcReviewSortType {
  def(0),
  latest(1),
  ;

  final int sort;
  String get label => switch (this) {
    def => L10n.current.defaultOption,
    latest => L10n.current.newest,
  };
  const PgcReviewSortType(this.sort);
}
