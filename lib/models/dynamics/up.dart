import 'package:PiliPlus/models_new/follow/list.dart';
import 'package:PiliPlus/utils/parse_int.dart';

class FollowUpModel {
  LiveUsers? liveUsers;
  List<UpItem>? upList;
  bool? hasMore;
  String? offset;

  void addAllUpList(List<UpItem> newList) {
    if (upList != null) {
      upList!.addAll(newList);
    } else {
      upList = newList;
    }
  }

  factory FollowUpModel.fromJson(Map<String, dynamic> json) {
    final model = FollowUpModel.fromUpList(json['up_list']);
    final liveUsers = json['live_users'];
    if (liveUsers != null) {
      model.liveUsers = LiveUsers.fromJson(liveUsers);
    }
    return model;
  }

  FollowUpModel.fromUpList(Map<String, dynamic>? json) {
    if (json != null) {
      upList = (json['items'] as List?)
          ?.map((e) => UpItem.fromJson(e))
          .toList();
      hasMore = json['has_more'];
      offset = json['offset'];
    }
  }

  FollowUpModel.fromFollowList(Map<String, dynamic> json) {
    upList = (json['list'] as List?)
        ?.map((e) => FollowItemModel.fromJson(e))
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
    count = safeToInt(json['count']) ?? 0;
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
    roomId = safeToInt(json['room_id']);
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
    mid = safeToInt(json['mid']) ?? 0;
    uname = json['uname'];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UpItem && mid == other.mid;

  @override
  int get hashCode => mid.hashCode;
}
