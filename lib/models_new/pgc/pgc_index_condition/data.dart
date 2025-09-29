import 'package:PiliPlus/models_new/pgc/pgc_index_condition/sort.dart';

class PgcIndexConditionData {
  List<PgcConditionFilter>? filter;
  List<PgcConditionOrder>? order;

  PgcIndexConditionData({this.filter, this.order});

  factory PgcIndexConditionData.fromJson(Map<String, dynamic> json) =>
      PgcIndexConditionData(
        filter: (json['filter'] as List<dynamic>?)
            ?.map((e) => PgcConditionFilter.fromJson(e as Map<String, dynamic>))
            .toList(),
        order: (json['order'] as List<dynamic>?)
            ?.map((e) => PgcConditionOrder.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
