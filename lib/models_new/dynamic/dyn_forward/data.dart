import 'package:PiliPlus/models_new/dynamic/dyn_forward/item.dart';
import 'package:PiliPlus/utils/parse_int.dart';

class DynForwardData {
  bool? hasMore;
  List<DynForwardItem>? items;
  String? offset;
  int total;

  DynForwardData({
    this.hasMore,
    this.items,
    this.offset,
    this.total = 0,
  });

  factory DynForwardData.fromJson(Map<String, dynamic> json) {
    final items = json['items'];
    return DynForwardData(
      hasMore: json['has_more'] as bool?,
      items: items is List
          ? items
                .whereType<Map>()
                .map(
                  (e) => DynForwardItem.fromJson(
                    Map<String, dynamic>.from(e),
                  ),
                )
                .toList()
          : null,
      offset: json['offset']?.toString(),
      total: safeToInt(json['total']) ?? 0,
    );
  }
}
