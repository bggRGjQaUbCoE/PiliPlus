import 'dart:convert';

import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/dynamics/article_content_model.dart';
import 'package:PiliPlus/models/model_avatar.dart';
import 'package:PiliPlus/models_new/live/live_feed_index/watched_show.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage_pref.dart';

class DynamicsDataModel {
  bool? hasMore;
  List<DynamicItemModel>? items;
  String? offset;
  int? total;
  bool? loadNext;

  static String _getMatchText(DynamicItemModel item) {
    final moduleDynamic = item.modules.moduleDynamic;
    final opus = moduleDynamic?.major?.opus;
    return (opus?.title ?? '') +
        (opus?.summary?.text ?? '') +
        (moduleDynamic?.desc?.text ?? '') +
        _getArcTitle(moduleDynamic?.major);
  }

  static String _getArcTitle(DynamicMajorModel? major) {
    final title = switch (major?.type) {
      'MAJOR_TYPE_ARCHIVE' => major?.archive?.title,
      'MAJOR_TYPE_UGC_SEASON' => major?.ugcSeason?.title,
      'MAJOR_TYPE_PGC' => major?.pgc?.title,
      'MAJOR_TYPE_COURSES' => major?.courses?.title,
      _ => null,
    };
    return title ?? '';
  }

  static RegExp banWordForDyn = RegExp(
    Pref.banWordForDyn,
    caseSensitive: false,
  );
  static bool enableFilter = banWordForDyn.pattern.isNotEmpty;

  static bool antiGoodsDyn = Pref.antiGoodsDyn;

  DynamicsDataModel.fromJson(
    Map<String, dynamic> json, {
    DynamicsTabType type = DynamicsTabType.all,
    Set<int>? tempBannedList,
  }) {
    hasMore = json['has_more'];

    List? list = json['items'] as List?;
    if (list != null && list.isNotEmpty) {
      items = <DynamicItemModel>[];
      late final filterBan =
          type != DynamicsTabType.up && tempBannedList?.isNotEmpty == true;
      for (var e in list) {
        DynamicItemModel item = DynamicItemModel.fromJson(e);
        if (antiGoodsDyn &&
            (item.orig?.modules.moduleDynamic?.additional?.type ==
                    'ADDITIONAL_TYPE_GOODS' ||
                item.modules.moduleDynamic?.additional?.type ==
                    'ADDITIONAL_TYPE_GOODS')) {
          continue;
        }
        if (enableFilter) {
          if (item.orig case final orig?) {
            if (banWordForDyn.hasMatch(_getMatchText(orig))) {
              continue;
            }
          }
          if (banWordForDyn.hasMatch(_getMatchText(item))) {
            continue;
          }
        }
        if (filterBan &&
            tempBannedList!.contains(item.modules.moduleAuthor?.mid)) {
          continue;
        }
        items!.add(item);
      }
      // filtered all
      if (items!.isEmpty) {
        loadNext = hasMore;
      }
    }

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

  // opus
  Fallback? fallback;

  DynamicItemModel.fromJson(Map<String, dynamic> json) {
    if (json['basic'] != null) basic = Basic.fromJson(json['basic']);
    idStr = json['id_str'];
    modules = json['modules'] == null
        ? ItemModulesModel()
        : ItemModulesModel.fromJson(json['modules']);
    if (json['orig'] != null) {
      orig = DynamicItemModel.fromJson(json['orig']);
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
    if (json['item']?['modules'] case List list) {
      modules = ItemModulesModel.fromOpusJson(list);
    } else {
      modules = ItemModulesModel();
    }

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
  ModuleTop? moduleTop;
  ModuleCollection? moduleCollection;
  List<ModuleTag>? moduleExtend; // opus的tag
  List<ArticleContentModel>? moduleContent;
  ModuleBlocked? moduleBlocked;
  ModuleFold? moduleFold;

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
    moduleFold = json['module_fold'] != null
        ? ModuleFold.fromJson(json['module_fold'])
        : null;
  }

  ItemModulesModel.fromOpusJson(List json) {
    for (Map<String, dynamic> i in json) {
      switch (i['module_type']) {
        case 'MODULE_TYPE_TOP':
          moduleTop = i['module_top'] == null
              ? null
              : ModuleTop.fromJson(i['module_top']);
          break;
        case 'MODULE_TYPE_TITLE':
          moduleTag = i['module_title'] == null
              ? null
              : ModuleTag.fromJson(i['module_title']);
          break;
        case 'MODULE_TYPE_COLLECTION':
          moduleCollection = i['module_collection'] == null
              ? null
              : ModuleCollection.fromJson(i['module_collection']);
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
        case 'MODULE_TYPE_BLOCKED':
          moduleBlocked = i['module_blocked'] == null
              ? null
              : ModuleBlocked.fromJson(i['module_blocked']);
          break;
        case 'MODULE_TYPE_EXTEND':
          moduleExtend = (i['module_extend']?['items'] as List?)
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
        // if (kDebugMode) debugPrint('unknown type: ${i}');
      }
    }
  }
}

class ModuleFold {
  List<String>? ids;
  String? statement;
  int? type;

  ModuleFold.fromJson(Map<String, dynamic> json) {
    ids = (json['ids'] as List?)?.fromCast();
    statement = json['statement'];
    type = json['type'];
  }
}

class ModuleCollection {
  String? count;
  int? id;
  String? name;
  String? title;

  ModuleCollection.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    id = json['id'];
    name = json['name'];
    title = json['title'];
  }
}

class ModuleTop {
  ModuleTopDisplay? display;

  ModuleTop.fromJson(Map<String, dynamic> json) {
    display = json['display'] == null
        ? null
        : ModuleTopDisplay.fromJson(json['display']);
  }
}

class ModuleTopDisplay {
  ModuleTopAlbum? album;
  int? type;

  ModuleTopDisplay.fromJson(Map<String, dynamic> json) {
    album = json['album'] == null
        ? null
        : ModuleTopAlbum.fromJson(json['album']);
    type = json['type'];
  }
}

class ModuleTopAlbum {
  List<Pic>? pics;
  int? type;

  ModuleTopAlbum.fromJson(Map<String, dynamic> json) {
    pics = (json['pics'] as List?)?.map((e) => Pic.fromJson(e)).toList();
    type = json['type'];
  }
}

class ModuleBlocked {
  BgImg? bgImg;
  int? blockedType;
  Button? button;
  String? title;
  String? hintMessage;
  BgImg? icon;

  ModuleBlocked.fromJson(Map<String, dynamic> json) {
    bgImg = json['bg_img'] == null ? null : BgImg.fromJson(json['bg_img']);
    blockedType = json['blocked_type'];
    button = json['button'] == null ? null : Button.fromJson(json['button']);
    title = json['title'];
    hintMessage = json['hint_message'];
    icon = json['icon'] == null ? null : BgImg.fromJson(json['icon']);
  }
}

class Button {
  int? handleType;
  String? icon;
  String? jumpUrl;
  String? text;
  JumpStyle? jumpStyle;
  int? status;
  int? type;
  Check? check;

  Button.fromJson(Map<String, dynamic> json) {
    handleType = json['handle_type'];
    icon = json['icon'];
    jumpUrl = json['jump_url'];
    text = json['text'];
    jumpStyle = json['jump_style'] == null
        ? null
        : JumpStyle.fromJson(json['jump_style']);
    status = json['status'];
    type = json['type'];
    check = json['check'] == null ? null : Check.fromJson(json['check']);
  }
}

class Check {
  int? disable;
  String? text;

  Check.fromJson(Map<String, dynamic> json) {
    disable = json['disable'];
    text = json['text'];
  }
}

class BgImg {
  String? imgDark;
  String? imgDay;

  BgImg.fromJson(Map<String, dynamic> json) {
    imgDark = json['img_dark'];
    imgDay = json['img_day'];
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
class ModuleAuthorModel extends Avatar {
  bool? following;
  String? jumpUrl;
  String? label;
  String? pubAction;
  String? pubTime;
  int? pubTs;
  String? type;
  Decorate? decorate;

  ModuleAuthorModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['official'] != null) {
      officialVerify ??= BaseOfficialVerify.fromJson(json['official']); // opus
    }
    following = json['following'];
    jumpUrl = json['jump_url'];
    label = json['label'];
    pubAction = json['pub_action'];
    pubTime = json['pub_time'];
    pubTs = json['pub_ts'] == 0 ? null : json['pub_ts'];
    type = json['type'];
    if (PendantAvatar.showDynDecorate) {
      decorate = json['decorate'] == null
          ? null
          : Decorate.fromJson(json['decorate']);
    } else {
      pendant = null;
    }
  }
}

class Decorate {
  String? cardUrl;
  Fan? fan;
  int? id;
  String? jumpUrl;
  String? name;
  int? type;

  Decorate({
    this.cardUrl,
    this.fan,
    this.id,
    this.jumpUrl,
    this.name,
    this.type,
  });

  factory Decorate.fromJson(Map<String, dynamic> json) => Decorate(
    cardUrl: json["card_url"],
    fan: json["fan"] == null ? null : Fan.fromJson(json["fan"]),
    id: json["id"],
    jumpUrl: json["jump_url"],
    name: json["name"],
    type: json["type"],
  );
}

class Fan {
  String? color;
  bool? isFan;
  String? numPrefix;
  String? numStr;
  int? number;

  Fan({
    this.color,
    this.isFan,
    this.numPrefix,
    this.numStr,
    this.number,
  });

  factory Fan.fromJson(Map<String, dynamic> json) => Fan(
    color: json["color"],
    isFan: json["is_fan"],
    numPrefix: json["num_prefix"],
    numStr: json["num_str"],
    number: json["number"],
  );
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
    desc = json['desc'] != null
        ? DynamicDescModel.fromJson(json['desc'])
        : null;
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
  UpowerLottery? upowerLottery;
  AddCommon? common;
  AddMatch? match;

  DynamicAddModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    vote = json['vote'] != null ? Vote.fromJson(json['vote']) : null;
    ugc = json['ugc'] != null ? Ugc.fromJson(json['ugc']) : null;
    reserve = json['reserve'] != null
        ? Reserve.fromJson(json['reserve'])
        : null;
    goods = json['goods'] != null ? Good.fromJson(json['goods']) : null;
    upowerLottery = json['upower_lottery'] != null
        ? UpowerLottery.fromJson(json['upower_lottery'])
        : null;
    common = json['common'] != null ? AddCommon.fromJson(json['common']) : null;
    match = json['match'] != null ? AddMatch.fromJson(json['match']) : null;
  }
}

class AddMatch {
  Button? button;
  String? headText;
  String? idStr;
  String? jumpUrl;
  MatchInfo? matchInfo;

  AddMatch({
    this.button,
    this.headText,
    this.idStr,
    this.jumpUrl,
    this.matchInfo,
  });

  factory AddMatch.fromJson(Map<String, dynamic> json) => AddMatch(
    button: json["button"] == null ? null : Button.fromJson(json["button"]),
    headText: json["head_text"],
    idStr: json["id_str"],
    jumpUrl: json["jump_url"],
    matchInfo: json["match_info"] == null
        ? null
        : MatchInfo.fromJson(json["match_info"]),
  );
}

class MatchInfo {
  String? centerBottom;
  List? centerTop;
  TTeam? leftTeam;
  TTeam? rightTeam;
  int? status;
  dynamic subTitle;
  String? title;

  MatchInfo({
    this.centerBottom,
    this.centerTop,
    this.leftTeam,
    this.rightTeam,
    this.status,
    this.subTitle,
    this.title,
  });

  factory MatchInfo.fromJson(Map<String, dynamic> json) => MatchInfo(
    centerBottom: json["center_bottom"],
    centerTop: json["center_top"],
    leftTeam: json["left_team"] == null
        ? null
        : TTeam.fromJson(json["left_team"]),
    rightTeam: json["right_team"] == null
        ? null
        : TTeam.fromJson(json["right_team"]),
    status: json["status"],
    subTitle: json["sub_title"],
    title: json["title"],
  );
}

class TTeam {
  int? id;
  String? name;
  String? pic;

  TTeam({
    this.id,
    this.name,
    this.pic,
  });

  factory TTeam.fromJson(Map<String, dynamic> json) => TTeam(
    id: json["id"],
    name: json["name"],
    pic: json["pic"],
  );
}

class AddCommon {
  Button? button;
  String? cover;
  String? desc1;
  String? desc2;
  String? headText;
  String? idStr;
  String? jumpUrl;
  int? style;
  String? subType;
  String? title;

  AddCommon({
    this.button,
    this.cover,
    this.desc1,
    this.desc2,
    this.headText,
    this.idStr,
    this.jumpUrl,
    this.style,
    this.subType,
    this.title,
  });

  factory AddCommon.fromJson(Map<String, dynamic> json) => AddCommon(
    button: json["button"] == null ? null : Button.fromJson(json["button"]),
    cover: json["cover"],
    desc1: json["desc1"],
    desc2: json["desc2"],
    headText: json["head_text"],
    idStr: json["id_str"],
    jumpUrl: json["jump_url"],
    style: json["style"],
    subType: json["sub_type"],
    title: json["title"],
  );
}

class UpowerLottery {
  Button? button;
  Desc? desc;
  Hint? hint;
  String? jumpUrl;
  int? rid;
  int? state;
  String? title;
  int? upMid;
  int? upowerActionState;
  int? upowerLevel;

  UpowerLottery({
    this.button,
    this.desc,
    this.hint,
    this.jumpUrl,
    this.rid,
    this.state,
    this.title,
    this.upMid,
    this.upowerActionState,
    this.upowerLevel,
  });

  factory UpowerLottery.fromJson(Map<String, dynamic> json) => UpowerLottery(
    button: json["button"] == null ? null : Button.fromJson(json["button"]),
    desc: json["desc"] == null ? null : Desc.fromJson(json["desc"]),
    hint: json["hint"] == null ? null : Hint.fromJson(json["hint"]),
    jumpUrl: json["jump_url"],
    rid: json["rid"],
    state: json["state"],
    title: json["title"],
    upMid: json["up_mid"],
    upowerActionState: json["upower_action_state"],
    upowerLevel: json["upower_level"],
  );
}

class Hint {
  int? style;
  String? text;

  Hint({
    this.style,
    this.text,
  });

  factory Hint.fromJson(Map<String, dynamic> json) => Hint(
    style: json["style"],
    text: json["text"],
  );
}

class JumpStyle {
  String? iconUrl;
  String? text;

  JumpStyle({
    this.iconUrl,
    this.text,
  });

  factory JumpStyle.fromJson(Map<String, dynamic> json) => JumpStyle(
    iconUrl: json["icon_url"],
    text: json["text"],
  );
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
  String? desc;

  Vote.fromJson(Map<String, dynamic> json) {
    desc = json['desc'];
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
    this.desc3,
    this.jumpUrl,
    this.reserveTotal,
    this.rid,
    this.state,
    this.stype,
    this.title,
    this.upMid,
  });

  ReserveBtn? button;
  Desc? desc1;
  Desc? desc2;
  Desc? desc3;
  String? jumpUrl;
  int? reserveTotal;
  int? rid;
  int? state;
  int? stype;
  String? title;
  int? upMid;

  Reserve.fromJson(Map<String, dynamic> json) {
    button = json['button'] == null
        ? null
        : ReserveBtn.fromJson(json['button']);
    desc1 = json['desc1'] == null ? null : Desc.fromJson(json['desc1']);
    desc2 = json['desc2'] == null ? null : Desc.fromJson(json['desc2']);
    desc3 = json['desc3'] == null ? null : Desc.fromJson(json['desc3']);
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

class ReserveBtn {
  ReserveBtn({
    this.status,
    this.type,
    this.checkText,
    this.uncheckText,
  });

  int? status;
  int? type;
  String? checkText;
  String? uncheckText;
  int? disable;
  String? jumpText;
  String? jumpUrl;

  ReserveBtn.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    type = json['type'];
    checkText = json['check']?['text'] ?? '已预约';
    uncheckText = json['uncheck']?['text'] ?? '预约';
    disable = json['uncheck']?['disable'];
    jumpText = json['jump_style']?['text'];
    jumpUrl = json['jump_url'];
  }
}

class Desc {
  Desc({
    this.style,
    this.text,
    this.visible,
    this.jumpUrl,
  });

  int? style;
  String? text;
  bool? visible;
  String? jumpUrl;

  Desc.fromJson(Map<String, dynamic> json) {
    style = json['style'];
    text = json['text'];
    visible = json['visible'];
    jumpUrl = json["jump_url"];
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
  DynamicArchiveModel? courses;
  Common? common;
  Map? music;
  ModuleBlocked? blocked;
  Medialist? medialist;

  SubscriptionNew? subscriptionNew;

  DynamicMajorModel.fromJson(Map<String, dynamic> json) {
    archive = json['archive'] != null
        ? DynamicArchiveModel.fromJson(json['archive'])
        : null;
    draw = json['draw'] != null
        ? DynamicDrawModel.fromJson(json['draw'])
        : null;
    ugcSeason = json['ugc_season'] != null
        ? DynamicArchiveModel.fromJson(json['ugc_season'])
        : null;
    opus = json['opus'] != null
        ? DynamicOpusModel.fromJson(json['opus'])
        : null;
    pgc = json['pgc'] != null
        ? DynamicArchiveModel.fromJson(json['pgc'])
        : null;
    liveRcmd = json['live_rcmd'] != null
        ? DynamicLiveModel.fromJson(json['live_rcmd'])
        : null;
    live = json['live'] != null
        ? DynamicLive2Model.fromJson(json['live'])
        : null;
    none = json['none'] != null
        ? DynamicNoneModel.fromJson(json['none'])
        : null;
    type = json['type'];
    courses = json['courses'] == null
        ? null
        : DynamicArchiveModel.fromJson(json['courses']);
    common = json['common'] == null ? null : Common.fromJson(json['common']);
    music = json['music'];
    blocked = json['blocked'] == null
        ? null
        : ModuleBlocked.fromJson(json['blocked']);
    medialist = json['medialist'] == null
        ? null
        : Medialist.fromJson(json['medialist']);
    subscriptionNew = json['subscription_new'] == null
        ? null
        : SubscriptionNew.fromJson(json['subscription_new']);
  }
}

class Medialist {
  dynamic id;
  String? cover;
  String? title;
  String? subTitle;
  String? jumpUrl;
  Badge? badge;

  Medialist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cover = json['cover'];
    title = json['title'];
    subTitle = json['sub_title'];
    jumpUrl = json['jump_url'];
    badge = json['badge'] == null ? null : Badge.fromJson(json['badge']);
  }
}

class SubscriptionNew {
  LiveRcmd? liveRcmd;
  String? style;

  SubscriptionNew({
    this.liveRcmd,
    this.style,
  });

  factory SubscriptionNew.fromJson(Map<String, dynamic> json) =>
      SubscriptionNew(
        liveRcmd: json["live_rcmd"] == null
            ? null
            : LiveRcmd.fromJson(json["live_rcmd"]),
        style: json["style"],
      );
}

class LiveRcmd {
  LiveRcmdContent? content;
  int? reserveType;

  LiveRcmd({
    this.content,
    this.reserveType,
  });

  factory LiveRcmd.fromJson(Map<String, dynamic> json) => LiveRcmd(
    content: json["content"] == null
        ? null
        : LiveRcmdContent.fromJson(jsonDecode(json["content"])),
    reserveType: json["reserve_type"],
  );
}

class LiveRcmdContent {
  int? type;
  LivePlayInfo? livePlayInfo;

  LiveRcmdContent({
    this.type,
    this.livePlayInfo,
  });

  factory LiveRcmdContent.fromJson(Map<String, dynamic> json) =>
      LiveRcmdContent(
        type: json["type"],
        livePlayInfo: json["live_play_info"] == null
            ? null
            : LivePlayInfo.fromJson(json["live_play_info"]),
      );
}

class LivePlayInfo {
  int? roomId;
  int? uid;
  int? liveStatus;
  int? roomType;
  int? playType;
  String? title;
  String? cover;
  int? online;
  int? areaId;
  String? areaName;
  int? parentAreaId;
  String? parentAreaName;
  int? liveScreenType;
  int? liveStartTime;
  String? link;
  WatchedShow? watchedShow;
  int? roomPaidType;

  LivePlayInfo({
    this.roomId,
    this.uid,
    this.liveStatus,
    this.roomType,
    this.playType,
    this.title,
    this.cover,
    this.online,
    this.areaId,
    this.areaName,
    this.parentAreaId,
    this.parentAreaName,
    this.liveScreenType,
    this.liveStartTime,
    this.link,
    this.watchedShow,
    this.roomPaidType,
  });

  factory LivePlayInfo.fromJson(Map<String, dynamic> json) => LivePlayInfo(
    roomId: json["room_id"],
    uid: json["uid"],
    liveStatus: json["live_status"],
    roomType: json["room_type"],
    playType: json["play_type"],
    title: json["title"],
    cover: json["cover"],
    online: json["online"],
    areaId: json["area_id"],
    areaName: json["area_name"],
    parentAreaId: json["parent_area_id"],
    parentAreaName: json["parent_area_name"],
    liveScreenType: json["live_screen_type"],
    liveStartTime: json["live_start_time"],
    link: json["link"],
    watchedShow: json["watched_show"] == null
        ? null
        : WatchedShow.fromJson(json["watched_show"]),
    roomPaidType: json["room_paid_type"],
  );
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
    this.id,
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

  int? id;
  int? aid;
  Badge? badge;
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
    id = json['id'];
    aid = json['aid'] is String ? int.parse(json['aid']) : json['aid'];
    badge = json['badge'] == null ? null : Badge.fromJson(json['badge']);
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

class Badge {
  Badge({
    this.text,
  });

  String? text;

  Badge.fromJson(Map<String, dynamic> json) {
    text = json['text'] == '投稿视频' ? null : json['text'];
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
  List<OpusPicModel>? pics;
  SummaryModel? summary;
  String? title;
  DynamicOpusModel.fromJson(Map<String, dynamic> json) {
    jumpUrl = json['jump_url'];
    pics = (json['pics'] as List?)
        ?.map<OpusPicModel>((e) => OpusPicModel.fromJson(e))
        .toList();
    summary = json['summary'] != null
        ? SummaryModel.fromJson(json['summary'])
        : null;
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
  List<OpusPicModel>? pics;
  List<OpusPicModel>? dynPic;
  String? jumpUrl;

  RichTextNodeItem.fromJson(Map<String, dynamic> json) {
    emoji = json['emoji'] != null ? Emoji.fromJson(json['emoji']) : null;
    origText = json['orig_text'];
    text = json['text'];
    type = json['type'];
    rid = json['rid'];
    pics = (json['pics'] as List?)
        ?.map((e) => OpusPicModel.fromJson(e))
        .toList();
    jumpUrl = json['jump_url'];
  }
}

class Emoji {
  // String? iconUrl;
  // String? webpUrl;
  // String? gifUrl;
  String? url;
  late num size;
  String? text;
  num? type;

  Emoji.fromJson(Map<String, dynamic> json) {
    // iconUrl = json['icon_url'];
    // webpUrl = json['webp_url'];
    // gifUrl = json['gif_url'];
    url = json['webp_url'] ?? json['gif_url'] ?? json['icon_url'];
    size = json['size'] ?? 1;
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

class OpusPicModel {
  OpusPicModel({
    this.width,
    this.height,
    this.src,
    this.url,
  });

  int? width;
  int? height;
  String? src;
  String? url;
  String? liveUrl;

  OpusPicModel.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
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
  WatchedShow? watchedShow;

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
      watchedShow = livePlayInfo['watched_show'] == null
          ? null
          : WatchedShow.fromJson(livePlayInfo['watched_show']);
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

  Badge? badge;
  String? cover;
  String? descFirst;
  String? descSecond;
  int? id;
  String? jumpUrl;
  int? liveState;
  int? reserveType;
  String? title;

  DynamicLive2Model.fromJson(Map<String, dynamic> json) {
    badge = json['badge'] == null ? null : Badge.fromJson(json['badge']);
    cover = json['cover'];
    descFirst = json['desc_first'];
    descSecond = json['desc_second'];
    id = json['id'];
    jumpUrl = json['jump_url'];
    liveState = json['live_state'];
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
    comment = json['comment'] == null
        ? null
        : DynamicStat.fromJson(json['comment']);
    forward = json['forward'] == null
        ? null
        : DynamicStat.fromJson(json['forward']);
    like = json['like'] == null ? null : DynamicStat.fromJson(json['like']);
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
    _ => null,
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
