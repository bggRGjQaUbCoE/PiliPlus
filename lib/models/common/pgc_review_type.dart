import 'package:PiliPlus/http/api.dart';

enum PgcReviewType {
  long(label: '长评', api: Api.pgcReviewL),
  short(label: '短评', api: Api.pgcReviewS);

  final String label;
  final String api;
  const PgcReviewType({required this.label, required this.api});
}

enum PgcReviewSortType {
  def('默认', 0),
  latest('最新', 1);

  final int sort;
  final String label;
  const PgcReviewSortType(this.label, this.sort);
}
