import 'package:PiliPlus/models/model_avatar.dart';
import 'package:PiliPlus/models_new/article/article_view/ops.dart';
import 'package:PiliPlus/models_new/article/article_view/opus.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';

class ArticleViewData {
  int? id;
  String? title;
  Avatar? author;
  int? publishTime;
  List<String>? originImageUrls;
  int? type;
  String? content;
  String? dynIdStr;
  ArticleOpus? opus;
  List<ArticleOps>? ops;

  ArticleViewData({
    this.id,
    this.title,
    this.author,
    this.publishTime,
    this.originImageUrls,
    this.type,
    this.content,
    this.dynIdStr,
    this.opus,
    this.ops,
  });

  factory ArticleViewData.fromJson(Map<String, dynamic> json) =>
      ArticleViewData(
        id: json['id'] as int?,
        title: json['title'] as String?,
        author: json['author'] == null
            ? null
            : Avatar.fromJson(json['author'] as Map<String, dynamic>),
        publishTime: json['publish_time'] as int?,
        originImageUrls: (json['origin_image_urls'] as List?)?.fromCast(),
        type: json['type'] as int?,
        content: json['content'] as String?,
        dynIdStr: json['dyn_id_str'] as String?,
        opus: json['opus'] == null
            ? null
            : ArticleOpus.fromJson(json['opus'] as Map<String, dynamic>),
        ops: (json['ops'] as List?)
            ?.map((e) => ArticleOps.fromJson(e))
            .toList(),
      );
}
