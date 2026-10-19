import 'package:PiliPlus/models/model_owner.dart';
import 'package:PiliPlus/models_new/fav/fav_detail/cnt_info.dart';

class SubItemModel {
  int? id;
  int? fid;
  int? mid;
  int? attr;
  String? title;
  String? cover;
  Owner? upper;
  int? coverType;
  String? intro;
  int? ctime;
  int? mtime;
  int? state;
  int? favState;
  int? mediaCount;
  int? viewCount;
  int? type;
  CntInfo? cntInfo;

  String get type2Label => switch (type) {
    11 => '收藏夹',
    21 => '合集',
    _ => '其它($type)',
  };

  SubItemModel({
    this.id,
    this.fid,
    this.mid,
    this.attr,
    this.title,
    this.cover,
    this.upper,
    this.coverType,
    this.intro,
    this.ctime,
    this.mtime,
    this.state,
    this.favState,
    this.mediaCount,
    this.viewCount,
    this.type,
    this.cntInfo,
  });

  factory SubItemModel.fromJson(Map<String, dynamic> json) => SubItemModel(
    id: json['id'] as int?,
    fid: json['fid'] as int?,
    mid: json['mid'] as int?,
    attr: json['attr'] as int?,
    title: json['title'] as String?,
    cover: json['cover'] as String?,
    upper: json['upper'] == null
        ? null
        : Owner.fromJson(json['upper'] as Map<String, dynamic>),
    coverType: json['cover_type'] as int?,
    intro: json['intro'] as String?,
    ctime: json['ctime'] as int?,
    mtime: json['mtime'] as int?,
    state: json['state'] as int?,
    favState: json['fav_state'] as int?,
    mediaCount: json['media_count'] as int?,
    viewCount: json['view_count'] as int?,
    type: json['type'] as int?,
    cntInfo: json['cnt_info'] == null
        ? null
        : CntInfo.fromJson(json['cnt_info']),
  );
}
