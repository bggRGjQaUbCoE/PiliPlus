import 'package:PiliPlus/models_new/history/history.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/utils/extension.dart';

class HistoryItemModel with MultiSelectData {
  String? title;
  String? longTitle;
  String? cover;
  List<String>? covers;
  String? uri;
  late History history;
  int? videos;
  String? authorName;
  String? authorFace;
  int? authorMid;
  int? viewAt;
  int? progress;
  String? badge;
  String? showTitle;
  int? duration;
  String? current;
  int? total;
  String? newDesc;
  int? isFinish;
  int? isFav;
  int? kid;
  String? tagName;
  int? liveStatus;

  HistoryItemModel({
    this.title,
    this.longTitle,
    this.cover,
    this.covers,
    this.uri,
    required this.history,
    this.videos,
    this.authorName,
    this.authorFace,
    this.authorMid,
    this.viewAt,
    this.progress,
    this.badge,
    this.showTitle,
    this.duration,
    this.current,
    this.total,
    this.newDesc,
    this.isFinish,
    this.isFav,
    this.kid,
    this.tagName,
    this.liveStatus,
  });

  factory HistoryItemModel.fromJson(Map<String, dynamic> json) =>
      HistoryItemModel(
        title: json['title'] as String?,
        longTitle: json['long_title'] as String?,
        cover: json['cover'] as String?,
        covers: (json['covers'] as List?)?.fromCast(),
        uri: json['uri'] as String?,
        history: json['history'] == null
            ? History()
            : History.fromJson(json['history'] as Map<String, dynamic>),
        videos: json['videos'] as int?,
        authorName: json['author_name'] as String?,
        authorFace: json['author_face'] as String?,
        authorMid: json['author_mid'] as int?,
        viewAt: json['view_at'] as int?,
        progress: json['progress'] as int?,
        badge: json['badge'] as String?,
        showTitle: json['show_title'] as String?,
        duration: json['duration'] as int?,
        current: json['current'] as String?,
        total: json['total'] as int?,
        newDesc: json['new_desc'] as String?,
        isFinish: json['is_finish'] as int?,
        isFav: json['is_fav'] as int?,
        kid: json['kid'] as int?,
        tagName: json['tag_name'] as String?,
        liveStatus: json['live_status'] as int?,
      );
}
