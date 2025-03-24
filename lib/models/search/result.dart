import 'package:PiliPlus/utils/em.dart';
import 'package:PiliPlus/utils/utils.dart';

import '../model_owner.dart';
import '../model_video.dart';

class SearchVideoModel {
  int? numResults;
  List<SearchVideoItemModel>? list;

  SearchVideoModel.fromJson(Map<String, dynamic> json) {
    numResults = (json['numResults'] as num?)?.toInt();
    list = (json['result'] as List?)
        ?.where((e) => e['available'] == true)
        .map<SearchVideoItemModel>((e) => SearchVideoItemModel.fromJson(e))
        .toList();
  }
}

class SearchVideoItemModel extends BaseVideoItemModel {
  String? type;
  int? id;
  // String? author;
  // String? typeid;
  // String? typename;
  String? arcurl;
  // String? play;
  // int? videoReview;
  // String? favorites;
  String? tag;
  // String? review;
  int? ctime;
  // String? duration;
  // String? viewType;
  // String? like;
  // String? upic;
  // String? danmaku;
  List<Map<String, String>>? titleList;

  SearchVideoItemModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    arcurl = json['arcurl'];
    aid = json['aid'];
    bvid = json['bvid'];
    // title = json['title'].replaceAll(RegExp(r'<.*?>'), '');
    titleList = Em.regTitle(json['title']);
    title = titleList!.map((i) => i['text']!).join();
    desc = json['description'];
    pic = json['pic'] != null && json['pic'].startsWith('//')
        ? 'https:${json['pic']}'
        : json['pic'] ?? '';
    pubdate = json['pubdate'];
    ctime = json['senddate'];
    duration = Utils.duration(json['duration']);
    owner = SearchOwner.fromJson(json);
    stat = SearchStat.fromJson(json);
  }

  // @override
  // String? goto;
  // @override
  // bool isFollowed;
  // @override
  // String? uri;
}

class SearchStat extends BaseStat {
  // 收藏数
  int? favorite;
  // 评论数
  int? reply;

  SearchStat.fromJson(Map<String, dynamic> json) {
    view = json['play'];
    danmu = json['danmaku'];
    favorite = json['favorite'];
    reply = json['review'];
    like = json['like'];
  }
}

class SearchOwner extends Owner {
  SearchOwner.fromJson(Map<String, dynamic> json) {
    mid = json["mid"];
    name = json["author"];
    face = json['upic'];
  }
}

class SearchUserModel {
  SearchUserModel({
    this.numResults,
    this.list,
  });

  int? numResults;
  List<SearchUserItemModel>? list;

  SearchUserModel.fromJson(Map<String, dynamic> json) {
    numResults = (json['numResults'] as num?)?.toInt();
    list = (json['result'] as List?)
        ?.map<SearchUserItemModel>((e) => SearchUserItemModel.fromJson(e))
        .toList();
  }
}

class SearchUserItemModel {
  SearchUserItemModel({
    this.type,
    this.mid,
    this.uname,
    this.usign,
    this.fans,
    this.videos,
    this.upic,
    this.faceNft,
    this.faceNftType,
    this.verifyInfo,
    this.level,
    this.gender,
    this.isUpUser,
    this.isLive,
    this.roomId,
    this.officialVerify,
  });

  String? type;
  int? mid;
  String? uname;
  String? usign;
  int? fans;
  int? videos;
  String? upic;
  int? faceNft;
  int? faceNftType;
  String? verifyInfo;
  int? level;
  int? gender;
  int? isUpUser;
  int? isLive;
  int? roomId;
  Map? officialVerify;

  SearchUserItemModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    mid = json['mid'];
    uname = json['uname'];
    usign = json['usign'];
    fans = json['fans'];
    videos = json['videos'];
    upic = 'https:${json['upic']}';
    faceNft = json['face_nft'];
    faceNftType = json['face_nft_type'];
    verifyInfo = json['verify_info'];
    level = json['level'];
    gender = json['gender'];
    isUpUser = json['is_upuser'];
    isLive = json['is_live'];
    roomId = json['room_id'];
    officialVerify = json['official_verify'];
  }
}

class SearchLiveModel {
  SearchLiveModel({
    this.numResults,
    this.list,
  });

  int? numResults;
  List<SearchLiveItemModel>? list;

  SearchLiveModel.fromJson(Map<String, dynamic> json) {
    numResults = (json['numResults'] as num?)?.toInt();
    list = json['result']
        ?.map<SearchLiveItemModel>((e) => SearchLiveItemModel.fromJson(e))
        .toList();
  }
}

class SearchLiveItemModel {
  SearchLiveItemModel({
    this.rankOffset,
    this.uid,
    this.tags,
    this.liveTime,
    this.uname,
    this.uface,
    this.face,
    this.userCover,
    this.type,
    this.title,
    this.cover,
    this.pic,
    this.online,
    this.rankIndex,
    this.rankScore,
    this.roomid,
    this.attentions,
    this.cateName,
  });

  int? rankOffset;
  int? uid;
  String? tags;
  String? liveTime;
  String? uname;
  String? uface;
  String? face;
  String? userCover;
  String? type;
  List? title;
  String? cover;
  String? pic;
  int? online;
  int? rankIndex;
  int? rankScore;
  int? roomid;
  int? attentions;
  String? cateName;
  Map? watchedShow;

  SearchLiveItemModel.fromJson(Map<String, dynamic> json) {
    rankOffset = json['rank_offset'];
    uid = json['uid'];
    tags = json['tags'];
    liveTime = json['live_time'];
    uname = json['uname'];
    uface = json['uface'];
    face = json['uface'];
    userCover = json['user_cover'];
    type = json['type'];
    title = Em.regTitle(json['title']);
    cover = json['cover'];
    pic = json['cover'];
    online = json['online'];
    rankIndex = json['rank_index'];
    rankScore = json['rank_score'];
    roomid = json['roomid'];
    attentions = json['attentions'];
    cateName = Em.regCate(json['cate_name']);
  }
}

class SearchMBangumiModel {
  SearchMBangumiModel({
    this.numResults,
    this.list,
  });

  int? numResults;
  List<SearchMBangumiItemModel>? list;

  SearchMBangumiModel.fromJson(Map<String, dynamic> json) {
    numResults = (json['numResults'] as num?)?.toInt();
    list = (json['result'] as List?)
        ?.map<SearchMBangumiItemModel>(
            (e) => SearchMBangumiItemModel.fromJson(e))
        .toList();
  }
}

class SearchMBangumiItemModel {
  SearchMBangumiItemModel({
    this.type,
    this.mediaId,
    this.title,
    this.orgTitle,
    this.mediaType,
    this.cv,
    this.staff,
    this.seasonId,
    this.isAvid,
    this.hitEpids,
    this.seasonType,
    this.seasonTypeName,
    this.url,
    this.buttonText,
    this.isFollow,
    this.isSelection,
    this.cover,
    this.areas,
    this.styles,
    this.gotoUrl,
    this.desc,
    this.pubtime,
    this.mediaMode,
    this.mediaScore,
    this.indexShow,
  });

  String? type;
  int? mediaId;
  List? title;
  String? orgTitle;
  int? mediaType;
  String? cv;
  String? staff;
  int? seasonId;
  bool? isAvid;
  String? hitEpids;
  int? seasonType;
  String? seasonTypeName;
  String? url;
  String? buttonText;
  int? isFollow;
  int? isSelection;
  String? cover;
  String? areas;
  String? styles;
  String? gotoUrl;
  String? desc;
  int? pubtime;
  int? mediaMode;
  Map? mediaScore;
  String? indexShow;

  SearchMBangumiItemModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    mediaId = json['media_id'];
    title = Em.regTitle(json['title']);
    orgTitle = json['org_title'];
    mediaType = json['media_type'];
    cv = json['cv'];
    staff = json['staff'];
    seasonId = json['season_id'];
    isAvid = json['is_avid'];
    hitEpids = json['hit_epids'];
    seasonType = json['season_type'];
    seasonTypeName = json['season_type_name'];
    url = json['url'];
    buttonText = json['button_text'];
    isFollow = json['is_follow'];
    isSelection = json['is_selection'];
    cover = json['cover'];
    areas = json['areas'];
    styles = json['styles'];
    gotoUrl = json['goto_url'];
    desc = json['desc'];
    pubtime = json['pubtime'];
    mediaMode = json['media_mode'];
    mediaScore = json['media_score'];
    indexShow = json['index_show'];
  }
}

class SearchArticleModel {
  SearchArticleModel({
    this.numResults,
    this.list,
  });

  int? numResults;
  List<SearchArticleItemModel>? list;

  SearchArticleModel.fromJson(Map<String, dynamic> json) {
    numResults = (json['numResults'] as num?)?.toInt();
    list = (json['result'] as List?)
        ?.map<SearchArticleItemModel>((e) => SearchArticleItemModel.fromJson(e))
        .toList();
  }
}

class SearchArticleItemModel {
  SearchArticleItemModel({
    this.pubTime,
    this.like,
    this.title,
    this.subTitle,
    this.rankOffset,
    this.mid,
    this.imageUrls,
    this.id,
    this.categoryId,
    this.view,
    this.reply,
    this.desc,
    this.rankScore,
    this.type,
    this.templateId,
    this.categoryName,
  });

  int? pubTime;
  int? like;
  List? title;
  String? subTitle;
  int? rankOffset;
  int? mid;
  List? imageUrls;
  int? id;
  int? categoryId;
  int? view;
  int? reply;
  String? desc;
  int? rankScore;
  String? type;
  int? templateId;
  String? categoryName;

  SearchArticleItemModel.fromJson(Map<String, dynamic> json) {
    pubTime = json['pub_time'];
    like = json['like'];
    title = Em.regTitle(json['title']);
    subTitle =
        Em.decodeHtmlEntities(json['title'].replaceAll(RegExp(r'<[^>]*>'), ''));
    rankOffset = json['rank_offset'];
    mid = json['mid'];
    imageUrls = json['image_urls'];
    id = json['id'];
    categoryId = json['category_id'];
    view = json['view'];
    reply = json['reply'];
    desc = json['desc'];
    rankScore = json['rank_score'];
    type = json['type'];
    templateId = json['templateId'];
    categoryName = json['category_name'];
  }
}
