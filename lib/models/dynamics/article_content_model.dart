import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models/dynamics/vote_model.dart';

class ArticleContentModel {
  int? align;
  int? paraType;
  Text? text;
  Format? format;
  Line? line;
  Pic? pic;
  LinkCard? linkCard;
  Code? code;
  L1st? list;
  Text? heading;

  ArticleContentModel.fromJson(Map<String, dynamic> json) {
    align = json['align'];
    paraType = json['para_type'];
    text = json['text'] == null ? null : Text.fromJson(json['text']);
    format = json['format'] == null ? null : Format.fromJson(json['format']);
    line = json['line'] == null ? null : Line.fromJson(json['line']);
    pic = json['pic'] == null ? null : Pic.fromJson(json['pic']);
    linkCard = json['link_card'] == null
        ? null
        : LinkCard.fromJson(json['link_card']);
    code = json['code'] == null ? null : Code.fromJson(json['code']);
    list = json['list'] == null ? null : L1st.fromJson(json['list']);
    heading = json['heading'] == null ? null : Text.fromJson(json['heading']);
  }
}

class Pic {
  List<Pic>? pics;
  int? style;
  String? url;
  double? width;
  double? height;
  num? size;
  String? liveUrl;
  bool? isLongPic;

  Pic.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = (json['width'] as num?)?.toDouble();
    height = (json['height'] as num?)?.toDouble();
    size = json['size'];
    pics = (json['pics'] as List?)?.map((item) => Pic.fromJson(item)).toList();
    style = json['style'];
    liveUrl = json['live_url'];
    if (width != null && height != null) {
      isLongPic = (height! / width!) > 22 / 9;
    }
  }
}

class Line {
  Line({
    this.pic,
  });
  Pic? pic;

  Line.fromJson(Map<String, dynamic> json) {
    pic = json['pic'] == null ? null : Pic.fromJson(json['pic']);
  }
}

class Format {
  Format({
    this.align,
  });
  int? align;

  Format.fromJson(Map<String, dynamic> json) {
    align = json['align'];
  }
}

class Text {
  Text({
    this.nodes,
  });
  List<Node>? nodes;

  Text.fromJson(Map<String, dynamic> json) {
    nodes = (json['nodes'] as List?)
        ?.map((item) => Node.fromJson(item))
        .toList();
  }
}

class Node {
  int? nodeType;
  Word? word;
  Rich? rich;
  Formula? formula;
  String? type;

  Node.fromJson(Map<String, dynamic> json) {
    nodeType = json['node_type'];
    word = json['word'] == null ? null : Word.fromJson(json['word']);
    rich = json['rich'] == null ? null : Rich.fromJson(json['rich']);
    formula = json['formula'] == null
        ? null
        : Formula.fromJson(json['formula']);
    type = json['type'];
  }
}

class Formula {
  String? latexContent;

  Formula.fromJson(Map<String, dynamic> json) {
    latexContent = json['latex_content'];
  }
}

class Word {
  String? words;
  double? fontSize;
  Style? style;
  int? color;
  String? fontLevel;

  Word.fromJson(Map<String, dynamic> json) {
    words = json['words'];
    fontSize = (json['font_size'] as num?)?.toDouble();
    style = json['style'] == null ? null : Style.fromJson(json['style']);
    color = json['color'] == null
        ? null
        : int.tryParse(
            'FF${(json['color'] as String).substring(1)}',
            radix: 16,
          );
    fontLevel = json['font_level'];
  }
}

class Style {
  Style({
    this.bold,
    this.italic,
    this.strikethrough,
  });
  bool? bold;
  bool? italic;
  bool? strikethrough;

  Style.fromJson(Map<String, dynamic> json) {
    bold = json['bold'];
    italic = json['italic'];
    strikethrough = json['strikethrough'];
  }
}

class Rich {
  Style? style;
  String? jumpUrl;
  String? origText;
  String? text;
  String? type;
  String? rid;
  Emoji? emoji;

  Rich.fromJson(Map<String, dynamic> json) {
    style = json['style'] == null ? null : Style.fromJson(json['style']);
    jumpUrl = json['jump_url'];
    origText = json['orig_text'];
    text = json['text'];
    type = json['type'];
    rid = json['rid'];
    emoji = json['emoji'] == null ? null : Emoji.fromJson(json['emoji']);
  }
}

class Ugc {
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

class Card {
  String? oid;
  String? type;
  Ugc? ugc;
  ItemNull? itemNull;
  Common? common;
  Live? live;
  Opus? opus;
  SimpleVoteInfo? vote;
  Music? music;
  Goods? goods;

  Card.fromJson(Map<String, dynamic> json) {
    oid = json['oid'];
    type = json['type'];
    ugc = json['ugc'] == null ? null : Ugc.fromJson(json['ugc']);
    itemNull = json['item_null'] == null
        ? null
        : ItemNull.fromJson(json['item_null']);
    common = json['common'] == null ? null : Common.fromJson(json['common']);
    live = json['live'] == null ? null : Live.fromJson(json['live']);
    opus = json['opus'] == null ? null : Opus.fromJson(json['opus']);
    vote = json['vote'] == null ? null : SimpleVoteInfo.fromJson(json['vote']);
    music = json['music'] == null ? null : Music.fromJson(json['music']);
    goods = json['goods'] == null ? null : Goods.fromJson(json['goods']);
  }
}

class Goods {
  String? headIcon;
  String? headText;
  String? jumpUrl;
  List<GoodsItem>? items;

  Goods.fromJson(Map<String, dynamic> json) {
    headIcon = json['head_icon'];
    headText = json['head_text'];
    jumpUrl = json['jump_url'];
    items = (json['items'] as List?)
        ?.map((item) => GoodsItem.fromJson(item))
        .toList();
  }
}

class GoodsItem {
  String? brief;
  String? cover;
  dynamic id;
  String? jumpDesc;
  String? jumpUrl;
  String? name;
  String? price;

  GoodsItem.fromJson(Map<String, dynamic> json) {
    brief = json['brief'];
    cover = json['cover'];
    id = json['id'];
    jumpDesc = json['jump_desc'];
    jumpUrl = json['jump_url'];
    name = json['name'];
    price = json['price'];
  }
}

class Music {
  String? cover;
  int? id;
  String? jumpUrl;
  String? label;
  String? title;

  Music.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
    id = json['id'];
    jumpUrl = json['jump_url'];
    label = json['label'];
    title = json['title'];
  }
}

class Opus {
  int? authorMid;
  String? authorName;
  String? cover;
  String? jumpUrl;
  String? title;
  int? statView;

  Opus.fromJson(Map<String, dynamic> json) {
    authorMid = json['author']?['mid'];
    authorName = json['author']?['name'];
    cover = json['cover'];
    jumpUrl = json['jump_url'];
    title = json['title'];
    statView = json['stat']?['view'];
  }
}

class Live {
  String? cover;
  String? descFirst;
  String? descSecond;
  String? title;
  String? jumpUrl;
  int? id;
  int? liveState;
  int? reserveType;
  String? badgeText;

  Live.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
    descFirst = json['desc_first'];
    descSecond = json['desc_second'];
    title = json['title'];
    jumpUrl = json['jump_url'];
    id = json['id'];
    liveState = json['live_state'];
    reserveType = json['reserve_type'];
    badgeText = json['badge']?['text'];
  }
}

class Common {
  Common({
    this.cover,
    this.desc,
    this.desc1,
    this.desc2,
    this.headText,
    this.idStr,
    this.jumpUrl,
    this.style,
    this.subType,
    this.title,
  });
  String? cover;
  String? desc;
  String? desc1;
  String? desc2;
  String? headText;
  String? idStr;
  String? jumpUrl;
  int? style;
  String? subType;
  String? title;

  Common.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
    desc = json['desc'];
    desc1 = json['desc1'];
    desc2 = json['desc2'];
    headText = json['head_text'];
    idStr = json['id_str'];
    jumpUrl = json['jump_url'];
    style = json['style'];
    subType = json['sub_type'];
    title = json['title'];
  }
}

class ItemNull {
  ItemNull({
    this.icon,
    this.text,
  });
  String? icon;
  String? text;

  ItemNull.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    text = json['text'];
  }
}

class LinkCard {
  LinkCard({
    this.card,
  });
  Card? card;

  LinkCard.fromJson(Map<String, dynamic> json) {
    card = json['card'] == null ? null : Card.fromJson(json['card']);
  }
}

class L1st {
  List<Item>? items;
  int? style;

  L1st.fromJson(Map<String, dynamic> json) {
    items = (json['items'] as List?)?.map((e) => Item.fromJson(e)).toList();
    style = json['style'];
  }
}

class Item {
  int? level;
  int? order;
  List<Node>? nodes;

  Item.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    order = json['order'];
    nodes = (json['nodes'] as List?)?.map((e) => Node.fromJson(e)).toList();
  }
}

class Code {
  String? content;
  String? lang;

  Code.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    lang = json['lang'];
  }
}
