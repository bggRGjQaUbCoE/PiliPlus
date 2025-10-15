import 'package:PiliPlus/models_new/follow/list.dart';

class FollowData {
  late List<FollowItemModel> list;
  int? total;

  FollowData({required this.list, this.total});

  factory FollowData.fromJson(Map<String, dynamic> json) => FollowData(
    list:
        (json['list'] as List<dynamic>?)
            ?.map((e) => FollowItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        <FollowItemModel>[],
    total: json['total'] as int?,
  );
}
