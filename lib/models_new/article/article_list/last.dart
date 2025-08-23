import 'package:PiliPlus/models_new/article/article_list/category.dart';
import 'package:PiliPlus/utils/extension.dart';

class Last {
  int? id;
  String? title;
  int? state;
  int? publishTime;
  int? words;
  List<String>? imageUrls;
  Category? category;
  dynamic categories;
  String? summary;
  int? type;
  String? dynIdStr;
  int? attributes;
  int? authorUid;
  int? onlyFans;

  Last({
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
  });

  factory Last.fromJson(Map<String, dynamic> json) => Last(
    id: json['id'] as int?,
    title: json['title'] as String?,
    state: json['state'] as int?,
    publishTime: json['publish_time'] as int?,
    words: json['words'] as int?,
    imageUrls: (json['image_urls'] as List?)?.fromCast(),
    category: json['category'] == null
        ? null
        : Category.fromJson(json['category'] as Map<String, dynamic>),
    categories: json['categories'] as dynamic,
    summary: json['summary'] as String?,
    type: json['type'] as int?,
    dynIdStr: json['dyn_id_str'] as String?,
    attributes: json['attributes'] as int?,
    authorUid: json['author_uid'] as int?,
    onlyFans: json['only_fans'] as int?,
  );
}
