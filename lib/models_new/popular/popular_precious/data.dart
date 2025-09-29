import 'package:PiliPlus/models/model_hot_video_item.dart';

class PopularPreciousData {
  String? title;
  int? mediaId;
  String? explain;
  List<HotVideoItemModel>? list;

  PopularPreciousData({this.title, this.mediaId, this.explain, this.list});

  factory PopularPreciousData.fromJson(Map<String, dynamic> json) =>
      PopularPreciousData(
        title: json['title'] as String?,
        mediaId: json['media_id'] as int?,
        explain: json['explain'] as String?,
        list: (json['list'] as List<dynamic>?)
            ?.map((e) => HotVideoItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
