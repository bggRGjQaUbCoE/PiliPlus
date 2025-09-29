import 'package:PiliPlus/models_new/pgc/pgc_index_condition/value.dart';

class PgcCondition {
  String? field;
  String? name;

  PgcCondition({
    this.field,
    this.name,
  });
}

class PgcConditionFilter extends PgcCondition {
  List<PgcConditionValue>? values;

  PgcConditionFilter({super.field, super.name, this.values});

  factory PgcConditionFilter.fromJson(Map<String, dynamic> json) =>
      PgcConditionFilter(
        field: json['field'] as String?,
        name: json['name'] as String?,
        values: (json['values'] as List<dynamic>?)
            ?.map((e) => PgcConditionValue.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class PgcConditionOrder extends PgcCondition {
  String? sort;

  PgcConditionOrder({super.field, super.name, this.sort});

  factory PgcConditionOrder.fromJson(Map<String, dynamic> json) =>
      PgcConditionOrder(
        field: json['field'] as String?,
        name: json['name'] as String?,
        sort: json['sort'] as String?,
      );
}
