import 'package:PiliPlus/models_new/dynamic/dyn_reaction/item.dart';

class DynReactionData {
  bool? hasMore;
  List<DynReactionItem>? items;
  String? offset;
  int total;

  DynReactionData({this.hasMore, this.items, this.offset, required this.total});

  factory DynReactionData.fromJson(Map<String, dynamic> json) =>
      DynReactionData(
        hasMore: json['has_more'] as bool?,
        items: (json['items'] as List<dynamic>?)
            ?.map((e) => DynReactionItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        offset: json['offset'] as String?,
        total: json['total'] as int? ?? 0,
      );
}
