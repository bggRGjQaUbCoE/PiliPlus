class BangumiListDataModel {
  BangumiListDataModel({
    this.hasNext,
    this.list,
    this.num,
    this.size,
    this.total,
  });

  int? hasNext;
  List<BangumiListItemModel>? list;
  int? num;
  int? size;
  int? total;

  BangumiListDataModel.fromJson(Map<String, dynamic> json) {
    hasNext = json['has_next'];
    list = (json['list'] as List?)
        ?.map<BangumiListItemModel>((e) => BangumiListItemModel.fromJson(e))
        .toList();
    num = json['num'];
    size = json['size'];
    total = json['total'];
  }
}

class BangumiListItemModel {
  BangumiListItemModel({
    this.badge,
    this.badgeType,
    this.cover,
    // this.firstEp,
    this.indexShow,
    this.isFinish,
    this.link,
    this.mediaId,
    this.order,
    this.orderType,
    this.score,
    this.seasonId,
    this.seaconStatus,
    this.seasonType,
    this.subTitle,
    this.title,
    this.titleIcon,
    this.progress,
  });

  String? badge;
  int? badgeType;
  String? cover;
  String? indexShow;
  int? isFinish;
  String? link;
  int? mediaId;
  String? order;
  String? orderType;
  String? score;
  int? seasonId;
  int? seaconStatus;
  int? seasonType;
  String? subTitle;
  String? title;
  String? titleIcon;

  String? progress;

  BangumiListItemModel.fromJson(Map<String, dynamic> json) {
    badge = json['badge'] == '' ? null : json['badge'];
    badgeType = json['badge_type'];
    cover = json['cover'];
    indexShow = json['index_show'];
    isFinish = json['is_finish'];
    link = json['link'];
    mediaId = json['media_id'];
    order = json['order'];
    orderType = json['order_type'];
    score = json['score'];
    seasonId = json['season_id'];
    seaconStatus = json['seacon_status'];
    seasonType = json['season_type'];
    subTitle = json['sub_title'];
    title = json['title'];
    titleIcon = json['title_icon'];

    progress = json['progress'];
  }
}
