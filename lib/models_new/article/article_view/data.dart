import 'package:PiliPlus/models/model_avatar.dart';
import 'package:PiliPlus/models_new/article/article_view/category.dart';
import 'package:PiliPlus/models_new/article/article_view/media.dart';
import 'package:PiliPlus/models_new/article/article_view/ops.dart';
import 'package:PiliPlus/models_new/article/article_view/opus.dart';
import 'package:PiliPlus/models_new/article/article_view/stats.dart';
import 'package:PiliPlus/models_new/article/article_view/tag.dart';
import 'package:PiliPlus/utils/extension.dart';

class ArticleViewData {
  int? id;
  Category? category;
  List<Category>? categories;
  String? title;
  String? summary;
  String? bannerUrl;
  int? templateId;
  int? state;
  Avatar? author;
  int? reprint;
  List<String>? imageUrls;
  int? publishTime;
  int? ctime;
  int? mtime;
  Stats? stats;
  List<Tag>? tags;
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
  int? privatePub;
  dynamic contentPicList;
  String? content;
  String? keywords;
  int? versionId;
  String? dynIdStr;
  int? totalArtNum;
  ArticleOpus? opus;
  List<ArticleOps>? ops;

  ArticleViewData({
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
    this.tags,
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
    this.privatePub,
    this.contentPicList,
    this.content,
    this.keywords,
    this.versionId,
    this.dynIdStr,
    this.totalArtNum,
    this.opus,
    this.ops,
  });

  factory ArticleViewData.fromJson(Map<String, dynamic> json) =>
      ArticleViewData(
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
            : Avatar.fromJson(json['author'] as Map<String, dynamic>),
        reprint: json['reprint'] as int?,
        imageUrls: (json['image_urls'] as List?)?.fromCast(),
        publishTime: json['publish_time'] as int?,
        ctime: json['ctime'] as int?,
        mtime: json['mtime'] as int?,
        stats: json['stats'] == null
            ? null
            : Stats.fromJson(json['stats'] as Map<String, dynamic>),
        tags: (json['tags'] as List<dynamic>?)
            ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
            .toList(),
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
        privatePub: json['private_pub'] as int?,
        contentPicList: json['content_pic_list'] as dynamic,
        content: json['content'] as String?,
        keywords: json['keywords'] as String?,
        versionId: json['version_id'] as int?,
        dynIdStr: json['dyn_id_str'] as String?,
        totalArtNum: json['total_art_num'] as int?,
        opus: json['opus'] == null
            ? null
            : ArticleOpus.fromJson(json['opus'] as Map<String, dynamic>),
        ops: (json['ops'] as List?)
            ?.map((e) => ArticleOps.fromJson(e))
            .toList(),
      );
}
