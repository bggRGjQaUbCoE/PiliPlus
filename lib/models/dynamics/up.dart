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
        ?.map((e) => UpItem.fromJson(e))
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
  int? latestUpdateAt;
  late int mid;
  String? uname;

  UpItem({
    this.face,
    this.hasUpdate,
    this.latestUpdateAt,
    required this.mid,
    this.uname,
  });

  UpItem.fromJson(Map<String, dynamic> json) {
    face = json['face'];
    hasUpdate = json['has_update'];
    latestUpdateAt = safeToInt(json['latest_update_at']);
    mid = safeToInt(json['mid']) ?? 0;
    uname = json['uname'];
  }

  /// 从动态流的作者模块构建 UP，用于补齐官方“常看”列表之外的更新作者。
  UpItem.fromDynamicAuthor(Map<String, dynamic> json) {
    face = json['face'];
    hasUpdate = true;
    latestUpdateAt = safeToInt(json['pub_ts']);
    mid = safeToInt(json['mid']) ?? 0;
    uname = json['name'];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UpItem && mid == other.mid;

  @override
  int get hashCode => mid.hashCode;
}

/// 动态流单页携带的更新基线及作者摘要。
class DynamicUpUpdatePage {
  DynamicUpUpdatePage.fromJson(Map<String, dynamic> json) {
    updateBaseline = json['update_baseline']?.toString();
    updateNum = safeToInt(json['update_num']) ?? 0;
    offset = json['offset']?.toString();
    hasMore = json['has_more'] == true;

    final rawItems = json['items'] as List?;
    if (rawItems == null) return;
    // 个别响应缺少显式基线时，以首条动态 ID 作为下一次检查基线。
    if (updateBaseline?.isNotEmpty != true && rawItems.isNotEmpty) {
      final firstItem = rawItems.first;
      if (firstItem is Map) updateBaseline = firstItem['id_str']?.toString();
    }
    for (final rawItem in rawItems) {
      final modules = rawItem is Map ? rawItem['modules'] : null;
      final author = modules is Map ? modules['module_author'] : null;
      // 动态流还可能包含番剧等非关注作者，只为明确处于关注状态的 UP 标红。
      if (author is Map && author['following'] == true) {
        final up = UpItem.fromDynamicAuthor(
          Map<String, dynamic>.from(author),
        );
        items.add(up.mid > 0 ? up : null);
      } else {
        // 保留空位，确保按 `update_num` 截取时与服务端动态条数严格对齐。
        items.add(null);
      }
    }
  }

  String? updateBaseline;
  int updateNum = 0;
  String? offset;
  bool hasMore = false;
  int get itemCount => items.length;
  final List<UpItem?> items = <UpItem?>[];
}

/// 一次更新检查的完整结果；同一 UP 发布多条动态时只保留一份作者信息。
class DynamicUpUpdateResult {
  const DynamicUpUpdateResult({
    required this.updateBaseline,
    required this.updatedUps,
  });

  final String? updateBaseline;
  final List<UpItem> updatedUps;

  /// 收集当前页仍处于更新范围内的作者，并返回尚待读取的动态条数。
  static int collectPage(
    Map<int, UpItem> updatedUps,
    DynamicUpUpdatePage page,
    int remaining,
  ) {
    for (final up in page.items.take(remaining)) {
      // 动态流按时间倒序，首次出现的记录就是该 UP 最新的一条更新。
      if (up != null) updatedUps.putIfAbsent(up.mid, () => up);
    }
    // `update_num` 统计的是动态条数，不是去重后的作者数。
    return remaining - page.itemCount;
  }

  /// 将有更新的 UP 按最新发布时间倒序置顶，未更新 UP 保持接口原顺序。
  static void sortUnreadFirst(List<UpItem> upList) {
    final updated = upList.indexed
        .where((entry) => entry.$2.hasUpdate == true)
        .toList();
    final unchanged = upList.where((up) => up.hasUpdate != true).toList();
    updated.sort((a, b) {
      final timeOrder = (b.$2.latestUpdateAt ?? 0).compareTo(
        a.$2.latestUpdateAt ?? 0,
      );
      return timeOrder != 0 ? timeOrder : a.$1.compareTo(b.$1);
    });
    upList
      ..clear()
      ..addAll(updated.map((entry) => entry.$2))
      ..addAll(unchanged);
  }
}
