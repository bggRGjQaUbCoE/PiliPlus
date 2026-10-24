import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/dimension.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/question.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/skin.dart';

/// 当前模块信息：/x/stein/edgeinfo_v2 的 `data.edges` 对象。
class Edges {
  /// 当前分P分辨率（有部分视频无法获取分辨率）
  Dimension? dimension;

  /// 问题列表（结束模块无此项）
  List<Question>? questions;

  /// 问题外观
  Skin? skin;

  Edges({this.dimension, this.questions, this.skin});

  factory Edges.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return Edges();
    }
    return Edges(
      dimension: json['dimension'] is Map<String, dynamic>
          ? Dimension.fromJson(json['dimension'])
          : null,
      questions: _list(json['questions'], Question.fromJson),
      skin: json['skin'] is Map<String, dynamic>
          ? Skin.fromJson(json['skin'])
          : null,
    );
  }

  static List<T>? _list<T>(dynamic list, T Function(dynamic) parse) {
    if (list is! List) {
      return null;
    }
    final List<T> result = <T>[];
    for (final dynamic item in list) {
      try {
        result.add(parse(item));
      } catch (_) {}
    }
    return result;
  }
}
