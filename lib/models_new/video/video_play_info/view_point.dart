import 'package:PiliPlus/common/widgets/progress_bar/segment_progress_bar.dart';

class ViewPoint {
  int? type;
  int? from;
  int? to;
  String? content;
  String? imgUrl;

  ViewPoint({
    this.type,
    this.from,
    this.to,
    this.content,
    this.imgUrl,
  });

  factory ViewPoint.fromJson(Map<String, dynamic> json) => ViewPoint(
    type: json["type"],
    from: json["from"],
    to: json["to"],
    content: json["content"],
    imgUrl: json["imgUrl"],
  );

  static List<ViewPoint>? fromCache(dynamic viewPoints) {
    if (viewPoints == null) return null;
    try {
      return (viewPoints as List?)?.map((e) => ViewPoint.fromJson(e)).toList();
    } catch (_) {}
    return null;
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'from': from,
    'to': to,
    'content': content,
    'imgUrl': imgUrl,
  };

  ViewPointSegment toSegment(double duration) {
    final end = (to! / duration).clamp(0.0, 1.0);
    return ViewPointSegment(
      end: end,
      title: content,
      url: imgUrl,
      from: from,
      to: to,
    );
  }
}
