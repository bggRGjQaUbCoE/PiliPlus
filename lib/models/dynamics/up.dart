class FollowUpModel {
  FollowUpModel({
    this.liveUsers,
    this.upList,
  });

  String? errMsg;
  LiveUsers? liveUsers;
  List<UpItem>? upList;

  FollowUpModel.fromJson(Map<String, dynamic> json) {
    liveUsers = json['live_users'] != null
        ? LiveUsers.fromJson(json['live_users'])
        : null;
    upList = (json['up_list'] as List?)
        ?.map<UpItem>((e) => UpItem.fromJson(e))
        .toList();
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
    count = json['count'] ?? 0;
    group = json['group'];
    items = (json['items'] as List?)
        ?.map<LiveUserItem>((e) => LiveUserItem.fromJson(e))
        .toList();
  }
}

sealed class UserItem {
  String? face;
  bool? hasUpdate;
  late int mid;
  String? uname;

  UserItem({
    this.face,
    this.hasUpdate,
    int? mid,
    this.uname,
  }) : mid = mid ?? -1;
}

class LiveUserItem extends UserItem {
  bool? isReserveRecall;
  String? jumpUrl;
  int? roomId;
  String? title;

  LiveUserItem.fromJson(Map<String, dynamic> json) {
    face = json['face'];
    isReserveRecall = json['is_reserve_recall'];
    jumpUrl = json['jump_url'];
    mid = json['mid'] ?? -1;
    roomId = json['room_id'];
    title = json['title'];
    uname = json['uname'];
    hasUpdate = false;
  }
}

class UpItem extends UserItem {
  UpItem({
    super.face,
    super.hasUpdate,
    // this.isReserveRecall,
    super.mid,
    super.uname,
  });

  // bool? isReserveRecall;

  UpItem.fromJson(Map<String, dynamic> json) {
    face = json['face'];
    hasUpdate = json['has_update'];
    // isReserveRecall = json['is_reserve_recall'];
    mid = json['mid'] ?? -1;
    uname = json['uname'];
  }
}
