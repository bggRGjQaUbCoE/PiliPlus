import 'dart:convert';

import 'package:PiliPlus/common/widgets/avatar.dart';
import 'package:PiliPlus/models/model_owner.dart';

import 'article_content_model.dart';

class DynamicsDataModel {
  bool? hasMore;
  List<DynamicItemModel>? items;
  String? offset;
  int? total;

  DynamicsDataModel.fromJson(Map<String, dynamic> json) {
    hasMore = json['has_more'];
    items = (json['items'] as List?)
        ?.map<DynamicItemModel>((e) => DynamicItemModel.fromJson(e))
        .toList();
    offset = json['offset'];
    total = json['total'];
  }
}

// 单个动态
class DynamicItemModel {
  Basic? basic;
  dynamic idStr;
  late ItemModulesModel modules;

  DynamicItemModel? orig;
  String? type;
  bool? visible;
  bool? isForwarded;

  // opus
  Fallback? fallback;

  DynamicItemModel.fromJson(Map<String, dynamic> json) {
    if (json['basic'] != null) basic = Basic.fromJson(json['basic']);
    idStr = json['id_str'];
    modules = json['modules'] == null
        ? ItemModulesModel()
        : ItemModulesModel.fromJson(json['modules']);
    if (json['orig'] != null) {
      orig = DynamicItemModel.fromJson(json['orig'])..isForwarded = true;
    }
    type = json['type'];
    visible = json['visible'];
  }

  DynamicItemModel.fromOpusJson(Map<String, dynamic> json) {
    if (json['item']?['basic'] != null) {
      basic = Basic.fromJson(json['item']['basic']);
    }
    idStr = json['item']?['id_str'];
    // type = json['type']; // int
    modules = json['item']?['modules'] == null
        ? ItemModulesModel()
        : ItemModulesModel.fromOpusJson(
            (json['item']?['modules'] as List).cast());

    if (json['fallback'] != null) {
      fallback = Fallback.fromJson(json['fallback']);
    }
  }
}

class Fallback {
  String? id;
  int? type;

  Fallback({
    this.id,
    this.type,
  });

  factory Fallback.fromJson(Map<String, dynamic> json) => Fallback(
        id: json['id'],
        type: json['type'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
      };
}

// 单个动态详情
class ItemModulesModel {
  ItemModulesModel();

  ModuleAuthorModel? moduleAuthor;
  ModuleStatModel? moduleStat;
  ModuleTag? moduleTag; // 也做opus的title用

  // 动态
  ModuleDynamicModel? moduleDynamic;
  // ModuleInterModel? moduleInter;

  // 专栏
  List<ModuleTag>? moduleExtend; // opus的tag
  List<ArticleContentModel>? moduleContent;

  // moduleBottom

  ItemModulesModel.fromJson(Map<String, dynamic> json) {
    moduleAuthor = json['module_author'] != null
        ? ModuleAuthorModel.fromJson(json['module_author'])
        : null;
    moduleDynamic = json['module_dynamic'] != null
        ? ModuleDynamicModel.fromJson(json['module_dynamic'])
        : null;
    // moduleInter = ModuleInterModel.fromJson(json['module_interaction']);
    moduleStat = json['module_stat'] != null
        ? ModuleStatModel.fromJson(json['module_stat'])
        : null;
    moduleTag = json['module_tag'] != null
        ? ModuleTag.fromJson(json['module_tag'])
        : null;
  }

  ItemModulesModel.fromOpusJson(List<Map<String, dynamic>> json) {
    for (var i in json) {
      switch (i['module_type']) {
        case 'MODULE_TYPE_TITLE':
          moduleTag = i['module_title'] == null
              ? null
              : ModuleTag.fromJson(i['module_title']);
          break;
        case 'MODULE_TYPE_AUTHOR':
          moduleAuthor = i['module_author'] == null
              ? null
              : ModuleAuthorModel.fromJson(i['module_author']);
          break;
        case 'MODULE_TYPE_CONTENT':
          moduleContent = (i['module_content']?['paragraphs'] as List?)
              ?.map((i) => ArticleContentModel.fromJson(i))
              .toList();
          break;
        case 'MODULE_TYPE_EXTEND':
          moduleExtend = (i['module_extend']['items'] as List?)
              ?.map((i) => ModuleTag.fromJson(i))
              .toList();
          break;
        case 'MODULE_TYPE_STAT':
          moduleStat = i['module_stat'] == null
              ? null
              : ModuleStatModel.fromJson(i['module_stat']);
          break;
        // case 'MODULE_TYPE_BOTTOM':
        //   break;
        // default:
        //   debugPrint('unknown type: ${i}');
      }
    }
  }
}

class Basic {
  String? commentIdStr;
  int? commentType;
  Map<String, dynamic>? likeIcon;
  String? ridStr;

  Basic.fromJson(Map<String, dynamic> json) {
    commentIdStr = json['comment_id_str'];
    commentType = json['comment_type'];
    likeIcon = json['like_icon'];
    ridStr = json['rid_str'];
  }
}

// 单个动态详情 - 作者信息
class ModuleAuthorModel extends Owner {
  bool? following;
  String? jumpUrl;
  String? label;
  String? pubAction;
  String? pubTime;
  int? pubTs;
  String? type;
  Map? vip;
  Map? decorate;
  Map? pendant;

  ModuleAuthorModel.fromJson(Map<String, dynamic> json) {
    face = json['face'];
    following = json['following'];
    jumpUrl = json['jump_url'];
    label = json['label'];
    mid = json['mid'];
    name = json['name'];
    pubAction = json['pub_action'];
    pubTime = json['pub_time'];
    pubTs = json['pub_ts'] == 0 ? null : json['pub_ts'];
    type = json['type'];
    vip = json['vip'];
    if (Avatar.showDynDecorate) {
      decorate = json['decorate'];
      pendant = json['pendant'];
    }
  }
}

// 单个动态详情 - 动态信息
class ModuleDynamicModel {
  ModuleDynamicModel({
    this.additional,
    this.desc,
    this.major,
    this.topic,
  });

  DynamicAddModel? additional;
  DynamicDescModel? desc;
  DynamicMajorModel? major;
  DynamicTopicModel? topic;

  ModuleDynamicModel.fromJson(Map<String, dynamic> json) {
    additional = json['additional'] != null
        ? DynamicAddModel.fromJson(json['additional'])
        : null;
    desc =
        json['desc'] != null ? DynamicDescModel.fromJson(json['desc']) : null;
    if (json['major'] != null) {
      major = DynamicMajorModel.fromJson(json['major']);
    }
    topic = json['topic'] != null
        ? DynamicTopicModel.fromJson(json['topic'])
        : null;
  }
}

// 单个动态详情 - 评论？信息
// class ModuleInterModel {
//   ModuleInterModel({

//   });

//   ModuleInterModel.fromJson(Map<String, dynamic> json) {

//   }
// }
class DynamicAddModel {
  DynamicAddModel({
    this.type,
    this.vote,
    this.ugc,
    this.reserve,
    this.goods,
  });

  String? type;
  Vote? vote;
  Ugc? ugc;
  Reserve? reserve;
  Good? goods;

  /// TODO 比赛vs
  String? match;

  /// TODO 游戏信息
  String? common;

  DynamicAddModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    vote = json['vote'] != null ? Vote.fromJson(json['vote']) : null;
    ugc = json['ugc'] != null ? Ugc.fromJson(json['ugc']) : null;
    reserve =
        json['reserve'] != null ? Reserve.fromJson(json['reserve']) : null;
    goods = json['goods'] != null ? Good.fromJson(json['goods']) : null;
  }
}

class Vote {
  Vote({
    this.choiceCnt,
    this.defaultShare,
    this.share,
    this.endTime,
    this.joinNum,
    this.status,
    this.type,
    this.uid,
    this.voteId,
  });

  int? choiceCnt;
  String? share;
  int? defaultShare;
  int? endTime;
  int? joinNum;
  int? status;
  int? type;
  int? uid;
  int? voteId;

  Vote.fromJson(Map<String, dynamic> json) {
    choiceCnt = json['choice_cnt'];
    share = json['share'];
    defaultShare = json['default_share'];
    endTime = json['end_time'] is int
        ? json['end_time']
        : int.parse(json['end_time']);
    joinNum = json['join_num'];
    status = json['status'];
    type = json['type'];
    uid = json['uid'];
    voteId = json['vote_id'];
  }
}

class Ugc {
  Ugc({
    this.cover,
    this.descSecond,
    this.duration,
    this.headText,
    this.idStr,
    this.jumpUrl,
    this.multiLine,
    this.title,
  });

  String? cover;
  String? descSecond;
  String? duration;
  String? headText;
  String? idStr;
  String? jumpUrl;
  bool? multiLine;
  String? title;

  Ugc.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
    descSecond = json['desc_second'];
    duration = json['duration'];
    headText = json['head_text'];
    idStr = json['id_str'];
    jumpUrl = json['jump_url'];
    multiLine = json['multi_line'];
    title = json['title'];
  }
}

class Reserve {
  Reserve({
    this.button,
    this.desc1,
    this.desc2,
    this.jumpUrl,
    this.reserveTotal,
    this.rid,
    this.state,
    this.stype,
    this.title,
    this.upMid,
  });

  Map? button;
  Map? desc1;
  Map? desc2;
  String? jumpUrl;
  int? reserveTotal;
  int? rid;
  int? state;
  int? stype;
  String? title;
  int? upMid;

  Reserve.fromJson(Map<String, dynamic> json) {
    button = json['button'];
    desc1 = json['desc1'];
    desc2 = json['desc2'];
    jumpUrl = json['jump_url'];
    reserveTotal = json['reserve_total'];
    rid = json['rid'];
    state = json['state'];
    state = json['state'];
    stype = json['stype'];
    title = json['title'];
    upMid = json['up_mid'];
  }
}

class Good {
  Good({
    this.headIcon,
    this.headText,
    this.items,
    this.jumpUrl,
  });

  String? headIcon;
  String? headText;
  List<GoodItem>? items;
  String? jumpUrl;

  Good.fromJson(Map<String, dynamic> json) {
    headIcon = json['head_icon'];
    headText = json['head_text'];
    items = (json['items'] as List?)
        ?.map<GoodItem>((e) => GoodItem.fromJson(e))
        .toList();
    jumpUrl = json['jump_url'];
  }
}

class GoodItem {
  GoodItem({
    this.brief,
    this.cover,
    this.id,
    this.jumpDesc,
    this.jumpUrl,
    this.name,
    this.price,
  });

  String? brief;
  String? cover;
  dynamic id;
  String? jumpDesc;
  String? jumpUrl;
  String? name;
  String? price;

  GoodItem.fromJson(Map<String, dynamic> json) {
    brief = json['brief'];
    cover = json['cover'];
    id = json['id'];
    jumpDesc = json['jump_desc'];
    jumpUrl = json['jump_url'];
    name = json['name'];
    price = json['price'];
  }
}

class DynamicDescModel {
  DynamicDescModel({
    this.richTextNodes,
    this.text,
  });

  List<RichTextNodeItem>? richTextNodes;
  String? text;

  DynamicDescModel.fromJson(Map<String, dynamic> json) {
    richTextNodes = (json['rich_text_nodes'] as List?)
        ?.map<RichTextNodeItem>((e) => RichTextNodeItem.fromJson(e))
        .toList();
    text = json['text'];
  }
}

//
class DynamicMajorModel {
  DynamicMajorModel({
    this.archive,
    this.draw,
    this.ugcSeason,
    this.opus,
    this.pgc,
    this.liveRcmd,
    this.live,
    this.none,
    this.type,
    this.courses,
    this.common,
    this.music,
    this.blocked,
    this.medialist,
  });

  DynamicArchiveModel? archive;
  DynamicDrawModel? draw;
  DynamicArchiveModel? ugcSeason;
  DynamicOpusModel? opus;
  DynamicArchiveModel? pgc;
  DynamicLiveModel? liveRcmd;
  DynamicLive2Model? live;
  DynamicNoneModel? none;
  // MAJOR_TYPE_DRAW 图片
  // MAJOR_TYPE_ARCHIVE 视频
  // MAJOR_TYPE_OPUS 图文/文章
  String? type;
  Map? courses;
  Map? common;
  Map? music;
  Map? blocked;
  Map? medialist;

  DynamicMajorModel.fromJson(Map<String, dynamic> json) {
    archive = json['archive'] != null
        ? DynamicArchiveModel.fromJson(json['archive'])
        : null;
    draw =
        json['draw'] != null ? DynamicDrawModel.fromJson(json['draw']) : null;
    ugcSeason = json['ugc_season'] != null
        ? DynamicArchiveModel.fromJson(json['ugc_season'])
        : null;
    opus =
        json['opus'] != null ? DynamicOpusModel.fromJson(json['opus']) : null;
    pgc =
        json['pgc'] != null ? DynamicArchiveModel.fromJson(json['pgc']) : null;
    liveRcmd = json['live_rcmd'] != null
        ? DynamicLiveModel.fromJson(json['live_rcmd'])
        : null;
    live =
        json['live'] != null ? DynamicLive2Model.fromJson(json['live']) : null;
    none =
        json['none'] != null ? DynamicNoneModel.fromJson(json['none']) : null;
    type = json['type'];
    courses = json['courses'] ?? {};
    common = json['common'] ?? {};
    music = json['music'] ?? {};
    blocked = json['blocked'];
    medialist = json['medialist'];
  }
}

class DynamicTopicModel {
  DynamicTopicModel({
    this.id,
    this.jumpUrl,
    this.name,
  });

  int? id;
  String? jumpUrl;
  String? name;

  DynamicTopicModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jumpUrl = json['jump_url'];
    name = json['name'];
  }
}

class DynamicArchiveModel {
  DynamicArchiveModel({
    this.aid,
    this.badge,
    this.bvid,
    this.cover,
    this.desc,
    this.disablePreview,
    this.durationText,
    this.jumpUrl,
    this.stat,
    this.title,
    this.type,
    this.epid,
    this.seasonId,
  });

  int? aid;
  Map? badge;
  String? bvid;
  String? cover;
  String? desc;
  int? disablePreview;
  String? durationText;
  String? jumpUrl;
  Stat? stat;
  String? title;
  int? type;
  int? epid;
  int? seasonId;

  DynamicArchiveModel.fromJson(Map<String, dynamic> json) {
    aid = json['aid'] is String ? int.parse(json['aid']) : json['aid'];
    badge = json['badge'];
    bvid = json['bvid'] ?? json['epid'].toString() ?? ' ';
    cover = json['cover'];
    disablePreview = json['disable_preview'];
    durationText = json['duration_text'];
    jumpUrl = json['jump_url'];
    stat = json['stat'] != null ? Stat.fromJson(json['stat']) : null;
    title = json['title'];
    type = json['type'];
    epid = json['epid'];
    seasonId = json['season_id'];
  }
}

class DynamicDrawModel {
  DynamicDrawModel({
    this.id,
    this.items,
  });

  int? id;
  List<DynamicDrawItemModel>? items;

  DynamicDrawModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    items = (json['items'] as List?)
        ?.map<DynamicDrawItemModel>((e) => DynamicDrawItemModel.fromJson(e))
        .toList();
  }
}

class DynamicOpusModel {
  DynamicOpusModel({
    this.jumpUrl,
    this.pics,
    this.summary,
    this.title,
  });

  String? jumpUrl;
  List<OpusPicsModel>? pics;
  SummaryModel? summary;
  String? title;
  DynamicOpusModel.fromJson(Map<String, dynamic> json) {
    jumpUrl = json['jump_url'];
    pics = (json['pics'] as List?)
        ?.map<OpusPicsModel>((e) => OpusPicsModel.fromJson(e))
        .toList();
    summary =
        json['summary'] != null ? SummaryModel.fromJson(json['summary']) : null;
    title = json['title'];
  }
}

class SummaryModel {
  SummaryModel({
    this.richTextNodes,
    this.text,
  });

  List<RichTextNodeItem>? richTextNodes;
  String? text;

  SummaryModel.fromJson(Map<String, dynamic> json) {
    richTextNodes = (json['rich_text_nodes'] as List?)
        ?.map<RichTextNodeItem>((e) => RichTextNodeItem.fromJson(e))
        .toList();
    text = json['text'];
  }
}

class RichTextNodeItem {
  RichTextNodeItem({
    this.emoji,
    this.origText,
    this.text,
    this.type,
    this.rid,
  });
  Emoji? emoji;
  String? origText;
  String? text;
  String? type;
  String? rid;
  List<OpusPicsModel>? pics;

  RichTextNodeItem.fromJson(Map<String, dynamic> json) {
    emoji = json['emoji'] != null ? Emoji.fromJson(json['emoji']) : null;
    origText = json['orig_text'];
    text = json['text'];
    type = json['type'];
    rid = json['rid'];
    pics = json['pics'] == null
        ? null
        : (json['pics'] as List?)
            ?.map((e) => OpusPicsModel.fromJson(e))
            .toList();
  }
}

class Emoji {
  Emoji({
    this.iconUrl,
    this.size,
    this.text,
    this.type,
  });

  String? iconUrl;
  String? webpUrl;
  String? gifUrl;
  double? size;
  String? text;
  int? type;
  Emoji.fromJson(Map<String, dynamic> json) {
    iconUrl = json['icon_url'];
    webpUrl = json['webp_url'];
    gifUrl = json['gif_url'];
    size = json['size'].toDouble();
    text = json['text'];
    type = json['type'];
  }
}

class DynamicNoneModel {
  DynamicNoneModel({
    this.tips,
  });
  String? tips;
  DynamicNoneModel.fromJson(Map<String, dynamic> json) {
    tips = json['tips'];
  }
}

class OpusPicsModel {
  OpusPicsModel({
    this.width,
    this.height,
    this.size,
    this.src,
    this.url,
  });

  int? width;
  int? height;
  int? size;
  String? src;
  String? url;
  String? liveUrl;

  OpusPicsModel.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    size = json['size'] != null ? json['size'].toInt() : 0;
    src = json['src'];
    url = json['url'];
    liveUrl = json['live_url'];
  }
}

class DynamicDrawItemModel {
  DynamicDrawItemModel({
    this.height,
    this.size,
    this.src,
    this.tags,
    this.width,
  });
  int? height;
  int? size;
  String? src;
  List? tags;
  int? width;
  DynamicDrawItemModel.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    size = json['size'].toInt();
    src = json['src'];
    tags = json['tags'];
    width = json['width'];
  }
}

class DynamicLiveModel {
  DynamicLiveModel({
    this.content,
  });

  String? content;
  int? type;
  Map? livePlayInfo;
  int? uid;
  String? parentAreaName;
  int? roomId;
  String? liveId;
  int? liveStatus;
  String? cover;
  int? online;
  String? areaName;
  String? title;
  int? liveStartTime;
  Map? watchedShow;

  DynamicLiveModel.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    if (json['content'] != null) {
      Map<String, dynamic> data = jsonDecode(json['content']);

      type = data['type'];
      Map livePlayInfo = data['live_play_info'];
      uid = livePlayInfo['uid'];
      parentAreaName = livePlayInfo['parent_area_name'];
      roomId = livePlayInfo['room_id'];
      liveId = livePlayInfo['live_id'];
      liveStatus = livePlayInfo['live_status'];
      cover = livePlayInfo['cover'];
      online = livePlayInfo['online'];
      areaName = livePlayInfo['area_name'];
      title = livePlayInfo['title'];
      liveStartTime = livePlayInfo['live_start_time'];
      watchedShow = livePlayInfo['watched_show'];
    }
  }
}

class DynamicLive2Model {
  DynamicLive2Model({
    this.badge,
    this.cover,
    this.descFirst,
    this.descSecond,
    this.id,
    this.jumpUrl,
    this.liveState,
    this.reserveType,
    this.title,
  });

  Map? badge;
  String? cover;
  String? descFirst;
  String? descSecond;
  int? id;
  String? jumpUrl;
  int? liveState;
  int? reserveType;
  String? title;

  DynamicLive2Model.fromJson(Map<String, dynamic> json) {
    badge = json['badge'];
    cover = json['cover'];
    descFirst = json['desc_first'];
    descSecond = json['desc_second'];
    id = json['id'];
    jumpUrl = json['jump_url'];
    liveState = json['liv_state'];
    reserveType = json['reserve_type'];
    title = json['title'];
  }
}

class ModuleTag {
  ModuleTag({
    this.text,
  });

  String? text;

  ModuleTag.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }
}

// 动态状态 转发、评论、点赞
class ModuleStatModel {
  ModuleStatModel({
    this.comment,
    this.forward,
    this.like,
    this.favorite,
  });

  DynamicStat? comment;
  DynamicStat? forward;
  DynamicStat? like;
  DynamicStat? favorite;
  // DynamicStat? coin;

  ModuleStatModel.fromJson(Map<String, dynamic> json) {
    comment = DynamicStat.fromJson(json['comment']);
    forward = DynamicStat.fromJson(json['forward']);
    like = DynamicStat.fromJson(json['like']);
    if (json['favorite'] != null) {
      favorite = DynamicStat.fromJson(json['favorite']);
    }
  }
}

// 动态状态
class DynamicStat {
  DynamicStat({
    this.count,
    this.forbidden,
    this.status,
  });

  int? count;
  bool? forbidden;
  bool? status;

  DynamicStat.fromJson(Map<String, dynamic> json) {
    count = json['count'] == 0 ? null : _parseInt(json['count']);
    forbidden = json['forbidden'];
    status = json['status'];
  }

  static int? _parseInt(dynamic x) => switch (x) {
        int() => x,
        String() => int.tryParse(x),
        double() => x.toInt(),
        _ => null
      };
}

class Stat {
  Stat({
    this.danmu,
    this.play,
  });

  String? danmu;
  String? play;

  Stat.fromJson(Map<String, dynamic> json) {
    danmu = json['danmaku'];
    play = json['play'];
  }
}
