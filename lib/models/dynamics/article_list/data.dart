import 'package:PiliPlus/models/dynamics/article_list/list.dart';
import 'package:PiliPlus/models/model_owner.dart';
import 'package:PiliPlus/models/space_article/item.dart';

class ArticleListData {
  ArticleList? list;
  List<SpaceArticleItem>? articles;
  Owner? author;
  bool? attention;

  ArticleListData({
    this.list,
    this.articles,
    this.author,
    this.attention,
  });

  factory ArticleListData.fromJson(Map<String, dynamic> json) =>
      ArticleListData(
        list: json['list'] == null
            ? null
            : ArticleList.fromJson(json['list'] as Map<String, dynamic>),
        articles: (json['articles'] as List<dynamic>?)
            ?.map((e) => SpaceArticleItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        author: json['author'] == null
            ? null
            : Owner.fromJson(json['author'] as Map<String, dynamic>),
        attention: json['attention'] as bool?,
      );
}
