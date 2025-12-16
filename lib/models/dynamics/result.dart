import 'dart:convert';

import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/models/dynamics/article_content_model.dart';
import 'package:PiliPlus/models/model_avatar.dart';
import 'package:PiliPlus/models_new/live/live_feed_index/watched_show.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';

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
    total = Utils.safeToInt(json['total']);
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

  Fallback({
    this.id,
  });

  factory Fallback.fromJson(Map<String, dynamic> json) => Fallback(
    id: json['id'],
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

  ItemModulesModel.fromJson(Map<String, dynamic> json) {
    moduleAuthor = json['module_author'] != null
        ? ModuleAuthorModel.fromJson(json['module_author'])
        : null;
    moduleDynamic = json['module_dynamic'] != null
        ? ModuleDynamicModel.fromJson(json['module_dynamic'])
        : null;
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
      }
    }
  }
}

class ModuleFold {
  List<String>? ids;
  String? statement;

  ModuleFold.fromJson(Map<String, dynamic> json) {
    ids = (json['ids'] as List?)?.fromCast();
    statement = json['statement'];
  }
}

class ModuleCollection {
  String? count;
  int? id;
  String? name;
  String? title;

  ModuleCollection.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    id = Utils.safeToInt(json['id']);
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

  ModuleTopDisplay.fromJson(Map<String, dynamic> json) {
    album = json['album'] == null
        ? null
        : ModuleTopAlbum.fromJson(json['album']);
  }
}

class ModuleTopAlbum {
  List<Pic>? pics;

  ModuleTopAlbum.fromJson(Map<String, dynamic> json) {
    pics = (json['pics'] as List?)?.map((e) => Pic.fromJson(e)).toList();
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
    blockedType = Utils.safeToInt(json['blocked_type']);
    button = json['button'] == null ? null : Button.fromJson(json['button']);
    title = json['title'];
    hintMessage = json['hint_message'];
    icon = json['icon'] == null ? null : BgImg.fromJson(json['icon']);
  }
}

class Button {
  String? icon;
  String? jumpUrl;
  String? text;
  JumpStyle? jumpStyle;
  Check? check;

  Button.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    jumpUrl = json['jump_url'];
    text = json['text'];
    jumpStyle = json['jump_style'] == null
        ? null
        : JumpStyle.fromJson(json['jump_style']);
    check = json['check'] == null ? null : Check.fromJson(json['check']);
  }
}

class Check {
  String? text;

  Check.fromJson(Map<String, dynamic> json) {
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
  String? ridStr;

  Basic.fromJson(Map<String, dynamic> json) {
    commentIdStr = json['comment_id_str'];
    commentType = Utils.safeToInt(json['comment_type']);
    ridStr = json['rid_str'];
  }
}

// 单个动态详情 - 作者信息
class ModuleAuthorModel extends Avatar {
  String? pubAction;
  String? pubTime;
  int? pubTs;
  String? type;
  Decorate? decorate;

  ModuleAuthorModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['official'] != null) {
      officialVerify ??= BaseOfficialVerify.fromJson(json['official']); // opus
    }
    pubAction = json['pub_action'];
    pubTime = json['pub_time'];
    pubTs = json['pub_ts'] == 0 ? null : Utils.safeToInt(json['pub_ts']);
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

  Decorate({
    this.cardUrl,
    this.fan,
  });

  factory Decorate.fromJson(Map<String, dynamic> json) => Decorate(
    cardUrl: json["card_url"],
    fan: json["fan"] == null ? null : Fan.fromJson(json["fan"]),
  );
}

class Fan {
  String? color;
  String? numStr;

  Fan({
    this.color,
    this.numStr,
  });

  factory Fan.fromJson(Map<String, dynamic> json) => Fan(
    color: json["color"],
    numStr: json["num_str"],
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
  String? jumpUrl;
  MatchInfo? matchInfo;

  AddMatch({
    this.button,
    this.jumpUrl,
    this.matchInfo,
  });

  factory AddMatch.fromJson(Map<String, dynamic> json) => AddMatch(
    button: json["button"] == null ? null : Button.fromJson(json["button"]),
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
  dynamic subTitle;
  String? title;

  MatchInfo({
    this.centerBottom,
    this.centerTop,
    this.leftTeam,
    this.rightTeam,
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
    subTitle: json["sub_title"],
    title: json["title"],
  );
}

class TTeam {
  String? name;
  String? pic;

  TTeam({
    this.name,
    this.pic,
  });

  factory TTeam.fromJson(Map<String, dynamic> json) => TTeam(
    name: json["name"],
    pic: json["pic"],
  );
}

class AddCommon {
  Button? button;
  String? cover;
  String? desc1;
  String? desc2;
  String? jumpUrl;
  String? title;

  AddCommon({
    this.button,
    this.cover,
    this.desc1,
    this.desc2,
    this.jumpUrl,
    this.title,
  });

  factory AddCommon.fromJson(Map<String, dynamic> json) => AddCommon(
    button: json["button"] == null ? null : Button.fromJson(json["button"]),
    cover: json["cover"],
    desc1: json["desc1"],
    desc2: json["desc2"],
    jumpUrl: json["jump_url"],
    title: json["title"],
  );
}

class UpowerLottery {
  Button? button;
  Desc? desc;
  Hint? hint;
  String? jumpUrl;
  String? title;

  UpowerLottery({
    this.button,
    this.desc,
    this.hint,
    this.jumpUrl,
    this.title,
  });

  factory UpowerLottery.fromJson(Map<String, dynamic> json) => UpowerLottery(
    button: json["button"] == null ? null : Button.fromJson(json["button"]),
    desc: json["desc"] == null ? null : Desc.fromJson(json["desc"]),
    hint: json["hint"] == null ? null : Hint.fromJson(json["hint"]),
    jumpUrl: json["jump_url"],
    title: json["title"],
  );
}

class Hint {
  String? text;

  Hint({
    this.text,
  });

  factory Hint.fromJson(Map<String, dynamic> json) => Hint(
    text: json["text"],
  );
}

class JumpStyle {
  String? text;

  JumpStyle({
    this.text,
  });

  factory JumpStyle.fromJson(Map<String, dynamic> json) => JumpStyle(
    text: json["text"],
  );
}

class Vote {
  Vote({
    this.joinNum,
    this.voteId,
    this.desc,
  });

  int? joinNum;
  int? voteId;
  String? desc;

  Vote.fromJson(Map<String, dynamic> json) {
    joinNum = Utils.safeToInt(json['join_num']);
    voteId = Utils.safeToInt(json['vote_id']);
    desc = json['desc'];
  }
}

class Ugc {
  Ugc({
    this.cover,
    this.descSecond,
    this.jumpUrl,
    this.title,
  });

  String? cover;
  String? descSecond;
  String? jumpUrl;
  String? title;

  Ugc.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
    descSecond = json['desc_second'];
    jumpUrl = json['jump_url'];
    title = json['title'];
  }
}

class Reserve {
  Reserve({
    this.button,
    this.desc1,
    this.desc2,
    this.desc3,
    this.reserveTotal,
    this.rid,
    this.state,
    this.title,
  });

  ReserveBtn? button;
  Desc? desc1;
  Desc? desc2;
  Desc? desc3;
  int? reserveTotal;
  int? rid;
  int? state;
  String? title;

  Reserve.fromJson(Map<String, dynamic> json) {
    button = json['button'] == null
        ? null
        : ReserveBtn.fromJson(json['button']);
    desc1 = json['desc1'] == null ? null : Desc.fromJson(json['desc1']);
    desc2 = json['desc2'] == null ? null : Desc.fromJson(json['desc2']);
    desc3 = json['desc3'] == null ? null : Desc.fromJson(json['desc3']);
    reserveTotal = Utils.safeToInt(json['reserve_total']);
    rid = Utils.safeToInt(json['rid']);
    state = Utils.safeToInt(json['state']);
    state = Utils.safeToInt(json['state']);
    title = json['title'];
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
    status = Utils.safeToInt(json['status']);
    type = Utils.safeToInt(json['type']);
    checkText = json['check']?['text'] ?? '已预约';
    uncheckText = json['uncheck']?['text'] ?? '预约';
    disable = Utils.safeToInt(json['uncheck']?['disable']);
    jumpText = json['jump_style']?['text'];
    jumpUrl = json['jump_url'];
  }
}

class Desc {
  Desc({
    this.text,
    this.jumpUrl,
  });

  String? text;
  String? jumpUrl;

  Desc.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    jumpUrl = json["jump_url"];
  }
}

class Good {
  Good({
    this.items,
  });

  List<GoodItem>? items;

  Good.fromJson(Map<String, dynamic> json) {
    items = (json['items'] as List?)
        ?.map<GoodItem>((e) => GoodItem.fromJson(e))
        .toList();
  }
}

class GoodItem {
  GoodItem({
    this.cover,
    this.jumpDesc,
    this.jumpUrl,
    this.name,
    this.price,
  });

  String? cover;
  String? jumpDesc;
  String? jumpUrl;
  String? name;
  String? price;

  GoodItem.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
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

class DynamicMajorModel {
  DynamicMajorModel({
    this.archive,
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
  DynamicArchiveModel? ugcSeason;
  DynamicOpusModel? opus;
  DynamicArchiveModel? pgc;
  DynamicLiveModel? liveRcmd;
  DynamicLive2Model? live;
  DynamicNoneModel? none;
  String? type;
  DynamicArchiveModel? courses;
  Common? common;
  Music? music;
  ModuleBlocked? blocked;
  Medialist? medialist;

  SubscriptionNew? subscriptionNew;

  DynamicMajorModel.fromJson(Map<String, dynamic> json) {
    archive = json['archive'] != null
        ? DynamicArchiveModel.fromJson(json['archive'])
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
    music = json['music'] == null ? null : Music.fromJson(json['music']);
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

class Music {
  int? id;
  String? cover;
  String? title;
  String? label;

  Music.fromJson(Map<String, dynamic> json) {
    id = Utils.safeToInt(json['id']);
    cover = json['cover'];
    title = json['title'];
    label = json['label'];
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

  SubscriptionNew({
    this.liveRcmd,
  });

  factory SubscriptionNew.fromJson(Map<String, dynamic> json) =>
      SubscriptionNew(
        liveRcmd: json["live_rcmd"] == null
            ? null
            : LiveRcmd.fromJson(json["live_rcmd"]),
      );
}

class LiveRcmd {
  LiveRcmdContent? content;

  LiveRcmd({
    this.content,
  });

  factory LiveRcmd.fromJson(Map<String, dynamic> json) => LiveRcmd(
    content: json["content"] == null
        ? null
        : LiveRcmdContent.fromJson(jsonDecode(json["content"])),
  );
}

class LiveRcmdContent {
  LivePlayInfo? livePlayInfo;

  LiveRcmdContent({
    this.livePlayInfo,
  });

  factory LiveRcmdContent.fromJson(Map<String, dynamic> json) =>
      LiveRcmdContent(
        livePlayInfo: json["live_play_info"] == null
            ? null
            : LivePlayInfo.fromJson(json["live_play_info"]),
      );
}

class LivePlayInfo {
  int? roomId;
  int? liveStatus;
  String? title;
  String? cover;
  String? areaName;
  WatchedShow? watchedShow;

  LivePlayInfo({
    this.roomId,
    this.liveStatus,
    this.title,
    this.cover,
    this.areaName,
    this.watchedShow,
  });

  factory LivePlayInfo.fromJson(Map<String, dynamic> json) => LivePlayInfo(
    roomId: Utils.safeToInt(json["room_id"]),
    liveStatus: Utils.safeToInt(json["live_status"]),
    title: json["title"],
    cover: json["cover"],
    areaName: json["area_name"],
    watchedShow: json["watched_show"] == null
        ? null
        : WatchedShow.fromJson(json["watched_show"]),
  );
}

class DynamicTopicModel {
  DynamicTopicModel({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  DynamicTopicModel.fromJson(Map<String, dynamic> json) {
    id = Utils.safeToInt(json['id']);
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
  String? durationText;
  String? jumpUrl;
  Stat? stat;
  String? title;
  int? type;
  int? epid;
  int? seasonId;

  DynamicArchiveModel.fromJson(Map<String, dynamic> json) {
    id = Utils.safeToInt(json['id']);
    aid = Utils.safeToInt(json['aid']);
    badge = json['badge'] == null ? null : Badge.fromJson(json['badge']);
    bvid = json['bvid'] ?? json['epid'].toString() ?? ' ';
    cover = json['cover'];
    durationText = json['duration_text'];
    jumpUrl = json['jump_url'];
    stat = json['stat'] != null ? Stat.fromJson(json['stat']) : null;
    title = json['title'];
    type = Utils.safeToInt(json['type']);
    epid = Utils.safeToInt(json['epid']);
    seasonId = Utils.safeToInt(json['season_id']);
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

class DynamicOpusModel {
  DynamicOpusModel({
    this.pics,
    this.summary,
    this.title,
  });

  List<OpusPicModel>? pics;
  SummaryModel? summary;
  String? title;

  DynamicOpusModel.fromJson(Map<String, dynamic> json) {
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
  String? url;
  late num size;

  Emoji.fromJson(Map<String, dynamic> json) {
    url = json['webp_url'] ?? json['gif_url'] ?? json['icon_url'];
    size = json['size'] ?? 1;
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
    width = Utils.safeToInt(json['width']);
    height = Utils.safeToInt(json['height']);
    src = json['src'];
    url = json['url'];
    liveUrl = json['live_url'];
  }
}

class DynamicLiveModel {
  int? roomId;
  int? liveStatus;
  String? cover;
  String? areaName;
  String? title;
  WatchedShow? watchedShow;

  DynamicLiveModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      Map<String, dynamic> data = jsonDecode(json['content']);
      Map livePlayInfo = data['live_play_info'];

      roomId = Utils.safeToInt(livePlayInfo['room_id']);
      liveStatus = Utils.safeToInt(livePlayInfo['live_status']);
      cover = livePlayInfo['cover'];
      areaName = livePlayInfo['area_name'];
      title = livePlayInfo['title'];
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
    this.id,
    this.liveState,
    this.title,
  });

  Badge? badge;
  String? cover;
  String? descFirst;
  int? id;
  int? liveState;
  String? title;

  DynamicLive2Model.fromJson(Map<String, dynamic> json) {
    badge = json['badge'] == null ? null : Badge.fromJson(json['badge']);
    cover = json['cover'];
    descFirst = json['desc_first'];
    id = Utils.safeToInt(json['id']);
    liveState = Utils.safeToInt(json['live_state']);
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
    this.status,
  });

  int? count;
  bool? status;

  DynamicStat.fromJson(Map<String, dynamic> json) {
    count = json['count'] == 0 ? null : Utils.safeToInt(json['count']);
    status = json['status'];
  }
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
