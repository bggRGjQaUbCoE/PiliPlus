import '../model_owner.dart';
import '../model_video.dart';
import 'fav_folder.dart';

class FavDetailData {
  FavFolderItemData? info;
  List<FavDetailItemData>? list;
  List<FavDetailItemData>? get medias => list;
  bool? hasMore;

  FavDetailData.fromJson(Map<String, dynamic> json) {
    info =
        json['info'] == null ? null : FavFolderItemData.fromJson(json['info']);
    list = (json['medias'] as List?)
        ?.map<FavDetailItemData>((e) => FavDetailItemData.fromJson(e))
        .toList();
    hasMore = json['has_more'];
  }
}

class FavDetailItemData extends BaseVideoItemModel {
  int? id;
  int? type;
  int? page;
  // https://github.com/SocialSisterYi/bilibili-API-collect/blob/master/docs/fav/list.md
  // | attr     | num  | 失效  | 0: 正常；9: up自己删除；1: 其他原因删除                                                         |
  int? attr;
  Map? cntInfo;
  String? link;
  int? ctime;
  int? favTime;
  Map? ogv;
  String? epId;
  bool? checked;

  FavDetailItemData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    aid = id;
    type = json['type'];
    title = json['title'];
    pic = json['cover'];
    desc = json['intro'];
    page = json['page'];
    duration = json['duration'];
    owner = Owner.fromJson(json['upper']);
    attr = json['attr'];
    cntInfo = json['cnt_info'];
    link = json['link'];
    ctime = json['ctime'];
    pubdate = json['pubtime'];
    favTime = json['fav_time'];
    bvid = json['bvid'];
    ogv = json['ogv'];
    stat = PlayStat.fromJson(json['cnt_info']);
    cid = json['ugc']?['first_cid'];
    if (json['link'] != null && json['link'].contains('/bangumi')) {
      epId = resolveEpId(json['link']);
    }
  }

  static final _digitRegExp = RegExp(r'\d+');
  String resolveEpId(String url) => _digitRegExp.firstMatch(url)!.group(0)!;

  // @override
  // bool isFollowed;
}
