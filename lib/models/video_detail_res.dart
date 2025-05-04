import 'dart:convert';

import 'package:PiliPlus/models/model_avatar.dart';

class VideoDetailResponse {
  int? code;
  String? message;
  int? ttl;
  VideoDetailData? data;

  VideoDetailResponse({
    this.code,
    this.message,
    this.ttl,
    this.data,
  });

  VideoDetailResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    message = json["message"];
    ttl = json["ttl"];
    data = json["data"] == null ? null : VideoDetailData.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["code"] = code;
    data["message"] = message;
    data["ttl"] = ttl;
    data["data"] = data;

    return data;
  }
}

class VideoDetailData {
  String? bvid;
  int? aid;
  int? videos;
  int? tid;
  String? tname;
  int? copyright;
  String? pic;
  String? title;
  int? pubdate;
  int? ctime;
  String? desc;
  List<DescV2>? descV2;
  int? state;
  int? duration;
  Map? rights;
  Owner? owner;
  Stat? stat;
  String? argueMsg;
  String? videoDynamic;
  int? cid;
  Dimension? dimension;
  dynamic premiere;
  int? teenageMode;
  bool? isChargeableSeason;
  bool? isStory;
  bool? noCache;
  List<Part>? pages;
  Subtitle? subtitle;
  // Label? label;
  UgcSeason? ugcSeason;
  bool? isSeasonDisplay;
  UserGarb? userGarb;
  HonorReply? honorReply;
  String? likeIcon;
  bool? needJumpBv;
  String? epId;
  List<Staff>? staff;
  late bool isPageReversed;

  VideoDetailData({
    this.bvid,
    this.aid,
    this.videos,
    this.tid,
    this.tname,
    this.copyright,
    this.pic,
    this.title,
    this.pubdate,
    this.ctime,
    this.desc,
    this.descV2,
    this.state,
    this.duration,
    this.rights,
    this.owner,
    this.stat,
    this.argueMsg,
    this.videoDynamic,
    this.cid,
    this.dimension,
    this.premiere,
    this.teenageMode,
    this.isChargeableSeason,
    this.isStory,
    this.noCache,
    this.pages,
    this.subtitle,
    this.ugcSeason,
    this.isSeasonDisplay,
    this.userGarb,
    this.honorReply,
    this.likeIcon,
    this.needJumpBv,
    this.epId,
    this.staff,
    this.isPageReversed = false,
  });

  VideoDetailData.fromJson(Map<String, dynamic> json) {
    bvid = json["bvid"];
    aid = json["aid"];
    videos = json["videos"];
    tid = json["tid"];
    tname = json["tname"];
    copyright = json["copyright"];
    pic = json["pic"];
    title = json["title"];
    pubdate = json["pubdate"];
    ctime = json["ctime"];
    desc = json["desc"];
    descV2 =
        (json["desc_v2"] as List?)?.map((e) => DescV2.fromJson(e)).toList();
    state = json["state"];
    duration = json["duration"];
    rights = json["rights"];
    owner = json["owner"] == null ? null : Owner.fromJson(json["owner"]);
    stat = json["stat"] == null ? null : Stat.fromJson(json["stat"]);
    argueMsg = json['argue_info']?['argue_msg'];
    videoDynamic = json["dynamic"];
    cid = json["cid"];
    dimension = json["dimension"] == null
        ? null
        : Dimension.fromJson(json["dimension"]);
    premiere = json["premiere"];
    teenageMode = json["teenage_mode"];
    isChargeableSeason = json["is_chargeable_season"];
    isStory = json["is_story"];
    noCache = json["no_cache"];
    pages = (json["pages"] as List?)?.map((e) => Part.fromJson(e)).toList();
    subtitle =
        json["subtitle"] == null ? null : Subtitle.fromJson(json["subtitle"]);
    ugcSeason = json["ugc_season"] != null
        ? UgcSeason.fromJson(json["ugc_season"])
        : null;
    isSeasonDisplay = json["is_season_display"];
    userGarb =
        json["user_garb"] == null ? null : UserGarb.fromJson(json["user_garb"]);
    honorReply = json["honor_reply"] == null
        ? null
        : HonorReply.fromJson(json["honor_reply"]);
    likeIcon = json["like_icon"];
    needJumpBv = json["need_jump_bv"];
    staff =
        (json["staff"] as List?)?.map((item) => Staff.fromJson(item)).toList();
    if (json['redirect_url'] != null) {
      epId = resolveEpId(json['redirect_url']);
    }
    isPageReversed = false;
  }

  String resolveEpId(url) {
    RegExp regex = RegExp(r'\d+');
    Iterable<Match> matches = regex.allMatches(url);
    List<String> numbers = [];
    for (Match match in matches) {
      numbers.add(match.group(0)!);
    }
    return numbers[0];
  }

  Map<String, dynamic> toJson() => {
        "bvid": bvid,
        "aid": aid,
        "videos": videos,
        "tid": tid,
        "tname": tname,
        "copyright": copyright,
        "pic": pic,
        "title": title,
        "pubdate": pubdate,
        "ctime": ctime,
        "desc": desc,
        "desc_v2": descV2 == null
            ? []
            : List<dynamic>.from(descV2!.map((e) => e.toJson())),
        "state": state,
        "duration": duration,
        "rights": rights == null
            ? {}
            : Map.from(rights!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "owner": owner?.toJson(),
        "stat": stat?.toJson(),
        "dynamic": videoDynamic,
        "cid": cid,
        "dimension": dimension?.toJson(),
        "premiere": premiere,
        "teenage_mode": teenageMode,
        "is_chargeable_season": isChargeableSeason,
        "is_story": isStory,
        "no_cache": noCache,
        "pages": pages == null
            ? []
            : List<dynamic>.from(pages!.map((e) => e.toJson())),
        "subtitle": subtitle?.toJson(),
        "is_season_display": isSeasonDisplay,
        "user_garb": userGarb?.toJson(),
        "honor_reply": honorReply?.toJson(),
        "like_icon": likeIcon,
        "need_jump_bv": needJumpBv,
      };
}

class DescV2 {
  String? rawText;
  int? type;
  int? bizId;

  DescV2({
    this.rawText,
    this.type,
    this.bizId,
  });

  DescV2 fromRawJson(String str) {
    return DescV2.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  DescV2.fromJson(Map<String, dynamic> json) {
    rawText = json["raw_text"];
    type = json["type"];
    bizId = json["biz_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["raw_text"] = rawText;
    data["type"] = type;
    data["biz_id"] = bizId;

    return data;
  }
}

class Dimension {
  int? width;
  int? height;
  int? rotate;

  Dimension({
    this.width,
    this.height,
    this.rotate,
  });

  Dimension fromRawJson(String str) => Dimension.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  Dimension.fromJson(Map<String, dynamic> json) {
    width = json["width"];
    height = json["height"];
    rotate = json["rotate"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["width"] = width;
    data["height"] = height;
    data["rotate"] = rotate;
    data["data"] = data;

    return data;
  }
}

class Staff {
  dynamic mid;
  String? title;
  String? name;
  String? face;
  Vip? vip;
  Map? official;

  Staff({
    this.mid,
    this.title,
    this.name,
    this.face,
    this.vip,
  });

  Staff.fromJson(Map<String, dynamic> json) {
    mid = json["mid"];
    title = json["title"];
    name = json["name"];
    face = json["face"];
    vip = json["vip"] == null ? null : Vip.fromJson(json["vip"]);
    official = json['official'];
  }
}

class HonorReply {
  List<Honor>? honor;

  HonorReply({
    this.honor,
  });

  HonorReply fromRawJson(String str) => HonorReply.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  HonorReply.fromJson(Map<String, dynamic> json) {
    honor = (json["honor"] as List?)?.map((x) => Honor.fromJson(x)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["honor"] =
        honor == null ? [] : List<dynamic>.from(honor!.map((x) => x.toJson()));
    return data;
  }
}

class Honor {
  int? aid;
  int? type;
  String? desc;
  int? weeklyRecommendNum;

  Honor({
    this.aid,
    this.type,
    this.desc,
    this.weeklyRecommendNum,
  });

  Honor fromRawJson(String str) => Honor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  Honor.fromJson(Map<String, dynamic> json) {
    aid = json["aid"];
    type = json["type"];
    desc = json["desc"];
    weeklyRecommendNum = json["weekly_recommend_num"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["aid"] = aid;
    data["type"] = type;
    data["desc"] = desc;
    data["weekly_recommend_num"] = weeklyRecommendNum;

    return data;
  }
}

class Owner {
  int? mid;
  String? name;
  String? face;

  Owner({
    this.mid,
    this.name,
    this.face,
  });

  Owner fromRawJson(String str) => Owner.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  Owner.fromJson(Map<String, dynamic> json) {
    mid = json["mid"];
    name = json["name"];
    face = json["face"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["mid"] = mid;
    data["name"] = name;
    data["face"] = face;
    return data;
  }
}

class Part {
  int? cid;
  int? page;
  String? from;
  String? pagePart;
  int? duration;
  String? vid;
  String? weblink;
  Dimension? dimension;
  String? firstFrame;
  String? badge;
  int? ctime;

  Part({
    this.cid,
    this.page,
    this.from,
    this.pagePart,
    this.duration,
    this.vid,
    this.weblink,
    this.dimension,
    this.firstFrame,
    this.badge,
    this.ctime,
  });

  Part fromRawJson(String str) => Part.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  Part.fromJson(Map<String, dynamic> json) {
    cid = json["cid"];
    page = json["page"];
    from = json["from"];
    pagePart = json["part"];
    duration = json["duration"];
    vid = json["vid"];
    weblink = json["weblink"];
    dimension = json["dimension"] == null
        ? null
        : Dimension.fromJson(json["dimension"]);
    firstFrame = json["first_frame"];
    badge = json["badge"];
    ctime = json["ctime"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["cid"] = cid;
    data["page"] = page;
    data["from"] = from;
    data["part"] = pagePart;
    data["duration"] = duration;
    data["vid"] = vid;
    data["weblink"] = weblink;
    data["dimension"] = dimension?.toJson();
    data["first_frame"] = firstFrame;
    data["badge"] = badge;
    return data;
  }
}

class Stat {
  int? aid;
  int? view;
  int? danmaku;
  int? reply;
  int? favorite;
  int? coin;
  int? share;
  int? nowRank;
  int? hisRank;
  int? like;
  int? dislike;
  String? evaluation;

  Stat({
    this.aid,
    this.view,
    this.danmaku,
    this.reply,
    this.favorite,
    this.coin,
    this.share,
    this.nowRank,
    this.hisRank,
    this.like,
    this.dislike,
    this.evaluation,
  });

  Stat fromRawJson(String str) => Stat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  Stat.fromJson(Map<String, dynamic> json) {
    aid = json["aid"];
    view = json["view"];
    danmaku = json["danmaku"];
    reply = json["reply"];
    favorite = json["favorite"];
    coin = json["coin"];
    share = json["share"];
    nowRank = json["now_rank"];
    hisRank = json["his_rank"];
    like = json["like"];
    dislike = json["dislike"];
    evaluation = json["evaluation"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["aid"] = aid;
    data["view"] = view;
    data["danmaku"] = danmaku;
    data["reply"] = reply;
    data["favorite"] = favorite;
    data["coin"] = coin;
    data["share"] = share;
    data["now_rank"] = nowRank;
    data["his_rank"] = hisRank;
    data["like"] = like;
    data["dislike"] = dislike;
    data["evaluation"] = evaluation;
    return data;
  }
}

class Subtitle {
  bool? allowSubmit;
  List<dynamic>? list;

  Subtitle({
    this.allowSubmit,
    this.list,
  });

  Subtitle fromRawJson(String str) => Subtitle.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  Subtitle.fromJson(Map<String, dynamic> json) {
    allowSubmit = json["allow_submit"];
    list = json["list"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["allow_submit"] = allowSubmit;
    data["list"] = list == null ? [] : List<dynamic>.from(list!.map((x) => x));
    return data;
  }
}

class UserGarb {
  String? urlImageAniCut;

  UserGarb({
    this.urlImageAniCut,
  });

  UserGarb fromRawJson(String str) => UserGarb.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  UserGarb.fromJson(Map<String, dynamic> json) {
    urlImageAniCut = json["url_image_ani_cut"];
  }

  Map<String, dynamic> toJson() => {"url_image_ani_cut": urlImageAniCut};
}

class Label {}

class UgcSeason {
  UgcSeason({
    this.id,
    this.title,
    this.cover,
    this.mid,
    this.intro,
    this.signState,
    this.attribute,
    this.sections,
    this.stat,
    this.epCount,
    this.seasonType,
    this.isPaySeason,
  });

  int? id;
  String? title;
  String? cover;
  int? mid;
  String? intro;
  int? signState;
  int? attribute;
  List<SectionItem>? sections;
  Stat? stat;
  int? epCount;
  int? seasonType;
  bool? isPaySeason;

  UgcSeason.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    cover = json['cover'];
    mid = json['mid'];
    intro = json['intro'];
    signState = json['sign_state'];
    attribute = json['attribute'];
    sections = (json['sections'] as List?)
        ?.map<SectionItem>((e) => SectionItem.fromJson(e))
        .toList();
    stat = Stat.fromJson(json['stat']);
    epCount = json['ep_count'];
    seasonType = json['season_type'];
    isPaySeason = json['is_pay_count'];
  }
}

class Arc {
  Arc({
    this.pic,
    this.duration,
    this.pubdate,
    this.stat,
  });

  String? pic;
  num? duration;
  int? pubdate;
  Stat? stat;

  Arc.fromJson(Map<String, dynamic> json) {
    pic = json['pic'] as String?;
    duration = json['duration'];
    pubdate = json['pubdate'];
    stat = json['stat'] == null
        ? null
        : Stat.fromJson(json['stat'] as Map<String, dynamic>);
  }
}

class SectionItem {
  SectionItem({
    this.seasonId,
    this.id,
    this.title,
    this.type,
    this.episodes,
    this.isReversed = false,
  });

  int? epCount;
  int? seasonId;
  int? id;
  String? title;
  int? type;
  List<EpisodeItem>? episodes;
  late bool isReversed;

  SectionItem.fromJson(Map<String, dynamic> json) {
    epCount = json['ep_count'];
    seasonId = json['season_id'];
    id = json['id'];
    title = json['title'];
    type = json['type'];
    episodes = (json['episodes'] as List?)
        ?.map<EpisodeItem>((e) => EpisodeItem.fromJson(e))
        .toList();
    isReversed = false;
  }
}

class EpisodeItem {
  EpisodeItem({
    this.seasonId,
    this.sectionId,
    this.id,
    this.aid,
    this.cid,
    this.title,
    this.longTitle,
    this.attribute,
    this.page,
    this.bvid,
    this.badge,
    this.arc,
    this.pages,
  });
  int? seasonId;
  int? sectionId;
  int? id;
  int? aid;
  int? cid;
  String? title;
  String? longTitle;
  int? attribute;
  Part? page;
  String? bvid;
  String? badge;
  Arc? arc;
  List<Part>? pages;

  EpisodeItem.fromJson(Map<String, dynamic> json) {
    seasonId = json['season_id'];
    sectionId = json['sectionId'];
    id = json['id'];
    aid = json['aid'];
    cid = json['cid'];
    title = json['title'];
    longTitle = json['long_title'];
    attribute = json['attribute'];
    page = Part.fromJson(json['page']);
    bvid = json['bvid'];
    badge = json['badge'];
    arc = json['arc'] == null
        ? null
        : Arc.fromJson(json['arc'] as Map<String, dynamic>);
    pages =
        (json['pages'] as List?)?.map((json) => Part.fromJson(json)).toList();
  }
}
