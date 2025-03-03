class SystemNotifyList {
  int? id;
  int? cursor;
  Publisher? publisher;
  int? type;
  String? title;
  String? content;
  Source? source;
  String? timeAt;
  int? cardType;
  String? cardBrief;
  String? cardMsgBrief;
  String? cardCover;
  String? cardStoryTitle;
  String? cardLink;
  String? mc;
  int? isStation;
  int? isSend;
  int? notifyCursor;

  SystemNotifyList(
      {this.id,
      this.cursor,
      this.publisher,
      this.type,
      this.title,
      this.content,
      this.source,
      this.timeAt,
      this.cardType,
      this.cardBrief,
      this.cardMsgBrief,
      this.cardCover,
      this.cardStoryTitle,
      this.cardLink,
      this.mc,
      this.isStation,
      this.isSend,
      this.notifyCursor});

  SystemNotifyList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cursor = json['cursor'];
    publisher = json['publisher'] != null
        ? Publisher.fromJson(json['publisher'])
        : null;
    type = json['type'];
    title = json['title'];
    content = json['content'];
    source = json['source'] != null ? Source.fromJson(json['source']) : null;
    timeAt = json['time_at'];
    cardType = json['card_type'];
    cardBrief = json['card_brief'];
    cardMsgBrief = json['card_msg_brief'];
    cardCover = json['card_cover'];
    cardStoryTitle = json['card_story_title'];
    cardLink = json['card_link'];
    mc = json['mc'];
    isStation = json['is_station'];
    isSend = json['is_send'];
    notifyCursor = json['notify_cursor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cursor'] = cursor;
    if (publisher != null) {
      data['publisher'] = publisher!.toJson();
    }
    data['type'] = type;
    data['title'] = title;
    data['content'] = content;
    if (source != null) {
      data['source'] = source!.toJson();
    }
    data['time_at'] = timeAt;
    data['card_type'] = cardType;
    data['card_brief'] = cardBrief;
    data['card_msg_brief'] = cardMsgBrief;
    data['card_cover'] = cardCover;
    data['card_story_title'] = cardStoryTitle;
    data['card_link'] = cardLink;
    data['mc'] = mc;
    data['is_station'] = isStation;
    data['is_send'] = isSend;
    data['notify_cursor'] = notifyCursor;
    return data;
  }
}

class Publisher {
  String? name;
  int? mid;
  String? face;

  Publisher({this.name, this.mid, this.face});

  Publisher.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mid = json['mid'];
    face = json['face'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['mid'] = mid;
    data['face'] = face;
    return data;
  }
}

class Source {
  String? name;
  String? logo;

  Source({this.name, this.logo});

  Source.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['logo'] = logo;
    return data;
  }
}
