import 'package:PiliPlus/models_new/video/video_detail/dimension.dart';

class PageItem {
  int cid;
  String? title;
  Dimension? dimension;

  PageItem({
    required this.cid,
    this.title,
    this.dimension,
  });

  factory PageItem.fromJson(Map<String, dynamic> json) => PageItem(
    cid: json['cid'],
    title: json['part'],
    dimension: json['dimension'] == null
        ? null
        : Dimension.fromJson(json['dimension']),
  );
}
