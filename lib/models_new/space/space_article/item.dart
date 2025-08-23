import 'package:PiliPlus/models_new/space/space_article/author.dart';
import 'package:PiliPlus/models_new/space/space_article/category.dart';
import 'package:PiliPlus/models_new/space/space_article/media.dart';
import 'package:PiliPlus/models_new/space/space_article/stats.dart';
import 'package:PiliPlus/utils/extension.dart';

class SpaceArticleItem {
  int? id;
  Category? category;
  List<Category>? categories;
  String? title;
  String? summary;
  String? bannerUrl;
  int? templateId;
  int? state;
  Author? author;
  int? reprint;
  List<String>? imageUrls;
  int? publishTime;
  int? ctime;
  int? mtime;
  Stats? stats;
  int? attributes;
  int? words;
  List<String>? originImageUrls;
  dynamic list;
  bool? isLike;
  Media? media;
  String? applyTime;
  String? checkTime;
  int? original;
  int? actId;
  dynamic dispute;
  dynamic authenMark;
  int? coverAvid;
  dynamic topVideoInfo;
  int? type;
  int? checkState;
  int? originTemplateId;
  String? uri;
  String? param;
  String? goto;
  String? publishTimeText;
  String? dynam1c;

  SpaceArticleItem({
    this.id,
    this.category,
    this.categories,
    this.title,
    this.summary,
    this.bannerUrl,
    this.templateId,
    this.state,
    this.author,
    this.reprint,
    this.imageUrls,
    this.publishTime,
    this.ctime,
    this.mtime,
    this.stats,
    this.attributes,
    this.words,
    this.originImageUrls,
    this.list,
    this.isLike,
    this.media,
    this.applyTime,
    this.checkTime,
    this.original,
    this.actId,
    this.dispute,
    this.authenMark,
    this.coverAvid,
    this.topVideoInfo,
    this.type,
    this.checkState,
    this.originTemplateId,
    this.uri,
    this.param,
    this.goto,
    this.publishTimeText,
    this.dynam1c,
  });

  factory SpaceArticleItem.fromJson(Map<String, dynamic> json) =>
      SpaceArticleItem(
        id: json['id'] as int?,
        category: json['category'] == null
            ? null
            : Category.fromJson(json['category'] as Map<String, dynamic>),
        categories: (json['categories'] as List<dynamic>?)
            ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList(),
        title: json['title'] as String?,
        summary: json['summary'] as String?,
        bannerUrl: json['banner_url'] as String?,
        templateId: json['template_id'] as int?,
        state: json['state'] as int?,
        author: json['author'] == null
            ? null
            : Author.fromJson(json['author'] as Map<String, dynamic>),
        reprint: json['reprint'] as int?,
        imageUrls: (json['image_urls'] as List?)?.fromCast(),
        publishTime: json['publish_time'] as int?,
        ctime: json['ctime'] as int?,
        mtime: json['mtime'] as int?,
        stats: json['stats'] == null
            ? null
            : Stats.fromJson(json['stats'] as Map<String, dynamic>),
        attributes: json['attributes'] as int?,
        words: json['words'] as int?,
        originImageUrls: (json['origin_image_urls'] as List?)?.fromCast(),
        list: json['list'] as dynamic,
        isLike: json['is_like'] as bool?,
        media: json['media'] == null
            ? null
            : Media.fromJson(json['media'] as Map<String, dynamic>),
        applyTime: json['apply_time'] as String?,
        checkTime: json['check_time'] as String?,
        original: json['original'] as int?,
        actId: json['act_id'] as int?,
        dispute: json['dispute'] as dynamic,
        authenMark: json['authenMark'] as dynamic,
        coverAvid: json['cover_avid'] as int?,
        topVideoInfo: json['top_video_info'] as dynamic,
        type: json['type'] as int?,
        checkState: json['check_state'] as int?,
        originTemplateId: json['origin_template_id'] as int?,
        uri: json['uri'] as String?,
        param: json['param'] as String?,
        goto: json['goto'] as String?,
        publishTimeText: json['publish_time_text'] as String?,
        dynam1c: json['dynamic'] as String?,
      );
}
