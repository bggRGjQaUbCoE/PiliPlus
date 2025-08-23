import 'package:PiliPlus/models_new/article/article_list/category.dart';
import 'package:PiliPlus/models_new/article/article_list/stats.dart';
import 'package:PiliPlus/utils/extension.dart';

class ArticleListItemModel {
  int? id;
  String? title;
  int? state;
  int? publishTime;
  int? words;
  List<String>? imageUrls;
  Category? category;
  List<Category>? categories;
  String? summary;
  int? type;
  String? dynIdStr;
  int? attributes;
  int? authorUid;
  int? onlyFans;
  Stats? stats;
  int? likeState;

  ArticleListItemModel({
    this.id,
    this.title,
    this.state,
    this.publishTime,
    this.words,
    this.imageUrls,
    this.category,
    this.categories,
    this.summary,
    this.type,
    this.dynIdStr,
    this.attributes,
    this.authorUid,
    this.onlyFans,
    this.stats,
    this.likeState,
  });

  factory ArticleListItemModel.fromJson(Map<String, dynamic> json) =>
      ArticleListItemModel(
        id: json['id'] as int?,
        title: json['title'] as String?,
        state: json['state'] as int?,
        publishTime: json['publish_time'] as int?,
        words: json['words'] as int?,
        imageUrls: (json['image_urls'] as List?)?.fromCast(),
        category: json['category'] == null
            ? null
            : Category.fromJson(json['category'] as Map<String, dynamic>),
        categories: (json['categories'] as List<dynamic>?)
            ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList(),
        summary: json['summary'] as String?,
        type: json['type'] as int?,
        dynIdStr: json['dyn_id_str'] as String?,
        attributes: json['attributes'] as int?,
        authorUid: json['author_uid'] as int?,
        onlyFans: json['only_fans'] as int?,
        stats: json['stats'] == null
            ? null
            : Stats.fromJson(json['stats'] as Map<String, dynamic>),
        likeState: json['like_state'] as int?,
      );
}
