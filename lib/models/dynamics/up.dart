import 'package:PiliPlus/utils/utils.dart';

class FollowUpModel {
  FollowUpModel({
    this.liveUsers,
    required this.upList,
  });

  LiveUsers? liveUsers;
  late List<UpItem> upList;
  bool? hasMore;
  String? offset;

  FollowUpModel.fromJson(Map<String, dynamic> json) {
    liveUsers = json['live_users'] != null
        ? LiveUsers.fromJson(json['live_users'])
        : null;
    upList =
        (json['up_list']?['items'] as List?)
            ?.map<UpItem>((e) => UpItem.fromJson(e))
            .toList() ??
        <UpItem>[];
    hasMore = json['up_list']?['has_more'];
    offset = json['up_list']?['offset'];
  }
}

class DynUpList {
  List<UpItem>? upList;
  bool? hasMore;
  String? offset;

  DynUpList.fromJson(Map<String, dynamic> json) {
    upList = (json['items'] as List?)
        ?.map<UpItem>((e) => UpItem.fromJson(e))
        .toList();
    hasMore = json['has_more'];
    offset = json['offset'];
  }
}

class LiveUsers {
  LiveUsers({
    this.count,
    this.group,
    this.items,
  });

  int? count;
  String? group;
  List<LiveUserItem>? items;

  LiveUsers.fromJson(Map<String, dynamic> json) {
    count = Utils.safeToInt(json['count']) ?? 0;
    group = json['group'];
    items = (json['items'] as List?)
        ?.map<LiveUserItem>((e) => LiveUserItem.fromJson(e))
        .toList();
  }
}

class LiveUserItem extends UpItem {
  bool? isReserveRecall;
  String? jumpUrl;
  int? roomId;
  String? title;

  LiveUserItem.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    isReserveRecall = json['is_reserve_recall'];
    jumpUrl = json['jump_url'];
    roomId = Utils.safeToInt(json['room_id']);
    title = json['title'];
  }
}

class UpItem {
  String? face;
  bool? hasUpdate;
  late int mid;
  String? uname;

  UpItem({
    this.face,
    this.hasUpdate,
    required this.mid,
    this.uname,
  });

  UpItem.fromJson(Map<String, dynamic> json) {
    face = json['face'];
    hasUpdate = json['has_update'];
    mid = Utils.safeToInt(json['mid']) ?? 0;
    uname = json['uname'];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UpItem && mid == other.mid;

  @override
  int get hashCode => mid.hashCode;
}
