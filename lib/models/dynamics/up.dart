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

  /// 该 UP 最新一条动态是否为视频投稿。
  ///
  /// 接口不返回该字段，它由动态流的动态类型推导而来，只服务于本地红点的
  /// 「仅视频」筛选；持久化时落在 `is_video` 上，null 表示尚不可知
  /// （例如来自官方常看列表、没有类型信息的红点）。
  bool? isVideo;

  UpItem({
    this.face,
    this.hasUpdate,
    this.latestUpdateAt,
    required this.mid,
    this.uname,
    this.isVideo,
  });

  UpItem.fromJson(Map<String, dynamic> json) {
    face = json['face'];
    hasUpdate = json['has_update'];
    latestUpdateAt = safeToInt(json['latest_update_at']);
    mid = safeToInt(json['mid']) ?? 0;
    uname = json['uname'];
    // 仅用于读取本地红点缓存，接口本身不会下发该键。
    isVideo = json['is_video'] == true ? true : null;
  }

  /// 从动态流的作者模块构建 UP，用于补齐官方“常看”列表之外的更新作者。
  UpItem.fromDynamicAuthor(Map<String, dynamic> json, {this.isVideo}) {
    face = json['face'];
    hasUpdate = true;
    latestUpdateAt = safeToInt(json['pub_ts']);
    mid = safeToInt(json['mid']) ?? 0;
    uname = json['name'];
  }

  /// 判断作者是否处于关注状态。
  ///
  /// 服务端对 `module_author.following` 的下发形态并不统一：既可能是布尔 `true`，
  /// 也可能是整数 `1`（实测动态流返回的就是整数 1）。早期实现写作
  /// `following == true`，在整数 1 上恒为 false，使每条动态都被当成番剧等
  /// 非关注作者过滤掉，红点增量于是永久为空。这里同时接受两种形态。
  static bool isFollowingAuthor(dynamic following) =>
      following == true || following == 1;

  /// 判断动态类型是否为视频投稿（含以动态形式发布的小视频）。
  ///
  /// 实测在同一时间窗内，综合动态流里 `DYNAMIC_TYPE_AV` 的集合与视频流
  /// （`type=video`）返回的集合完全一致，因此这里可以替代再发一次视频流请求。
  static bool isVideoDynamicType(dynamic type) => type == 'DYNAMIC_TYPE_AV';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UpItem && mid == other.mid;

  @override
  int get hashCode => mid.hashCode;
}

/// 动态流中的单条记录：保留动态 id 与已关注作者摘要。
///
/// 动态 id 是随时间单调递增的雪花号，因此「动态 id 严格大于本地基线」可以
/// 自证「是否为新动态」。之所以不沿用接口的 `update_num`：实测该字段在有基线
/// 时恒为字符串 `'0'`，与基线深浅无关，按它截取条数只会得到空集。
class DynamicUpdateEntry {
  const DynamicUpdateEntry({required this.dynamicId, this.up});

  /// 动态 id；缺失或解析失败按 0 处理，视为早于任何基线。
  final int dynamicId;

  /// 仅当作者处于关注状态且 mid 有效时非空，番剧、直播推荐等记录为 null。
  final UpItem? up;
}

/// 动态流单页：一次更新检查所需的分页信息与作者摘要。
class DynamicUpUpdatePage {
  DynamicUpUpdatePage.fromJson(Map<String, dynamic> json) {
    updateBaseline = json['update_baseline']?.toString();
    offset = json['offset']?.toString();
    hasMore = json['has_more'] == true;

    final rawItems = json['items'] as List?;
    if (rawItems == null) return;
    for (final rawItem in rawItems) {
      if (rawItem is! Map) {
        entries.add(const DynamicUpdateEntry(dynamicId: 0));
        continue;
      }
      final modules = rawItem['modules'];
      final author = modules is Map ? modules['module_author'] : null;
      UpItem? up;
      // 动态流可能混入番剧、直播推荐等非关注作者，只为关注中的 UP 标红。
      if (author is Map && UpItem.isFollowingAuthor(author['following'])) {
        final parsed = UpItem.fromDynamicAuthor(
          Map<String, dynamic>.from(author),
          isVideo: UpItem.isVideoDynamicType(rawItem['type']),
        );
        if (parsed.mid > 0) up = parsed;
      }
      entries.add(
        DynamicUpdateEntry(
          dynamicId: safeToInt(rawItem['id_str']) ?? 0,
          up: up,
        ),
      );
    }
  }

  /// 服务端给出的当前基线，代表「此刻」对应的动态 id，用作下一次检查的截止线。
  String? updateBaseline;
  String? offset;
  bool hasMore = false;
  final List<DynamicUpdateEntry> entries = <DynamicUpdateEntry>[];

  int get itemCount => entries.length;

  /// 本页最后一条动态的 id；用于判断本页是否已经越过基线。
  int? get lastId => entries.isEmpty ? null : entries.last.dynamicId;

  /// 本页最大的动态 id；服务端未下发基线时用它兜底。
  ///
  /// 不能直接取首条 id：置顶动态（is_top）会以较早的 id 排在最前面。
  int get maxId {
    var max = 0;
    for (final entry in entries) {
      if (entry.dynamicId > max) max = entry.dynamicId;
    }
    return max;
  }
}

/// 动态流取页回调；[offset] 为空表示取第一页，返回 null 表示取页失败。
typedef DynamicPageLoader = Future<DynamicUpUpdatePage?> Function(String? offset);

/// 一次更新检查的完整结果；同一 UP 发布多条动态时只保留一份作者信息。
class DynamicUpUpdateResult {
  const DynamicUpUpdateResult({
    required this.updateBaseline,
    required this.updatedUps,
  });

  final String? updateBaseline;
  final List<UpItem> updatedUps;

  /// 收集本页中动态 id 严格大于 [baselineId] 的已关注作者。
  ///
  /// [baselineId] 为 0 表示首次启用后的回补，此时本页所有已关注作者都计入。
  /// 同一 UP 出现多条新动态时只保留发布时间最新的一条。
  static void collectPage(
    Map<int, UpItem> updatedUps,
    DynamicUpUpdatePage page,
    int baselineId,
  ) {
    for (final entry in page.entries) {
      if (baselineId > 0 && entry.dynamicId <= baselineId) continue;
      final up = entry.up;
      if (up == null) continue;
      final old = updatedUps[up.mid];
      if (old == null || (up.latestUpdateAt ?? 0) > (old.latestUpdateAt ?? 0)) {
        updatedUps[up.mid] = up;
      }
    }
  }

  /// 本页是否已越过基线（末条动态不晚于基线即说明增量已收完）。
  static bool passedBaseline(DynamicUpUpdatePage page, int baselineId) {
    final last = page.lastId;
    return last == null || last <= baselineId;
  }

  /// 按动态 id 基线扫描新增作者的纯逻辑，与网络实现解耦。
  ///
  /// 解耦的目的是让这套翻页/截断规则可以被真实抓包数据直接驱动，而不必依赖设备联网，
  /// 从而避免「单测全绿但线上拿不到红点」的情况再次发生。
  ///
  /// [baselineId] 为 0 表示首次启用（本地还没有基线）：此时按 [backfillPages] 回补最近
  /// 若干页，并把基线锁定到「此刻」对应的动态 id；否则只收集晚于基线的动态，最多翻
  /// [maxPages] 页，遇到末条不晚于基线的页即停止。
  ///
  /// 任意一页取页失败都返回 null，调用方必须保留原基线重试，避免这期间的新动态被跳过。
  /// [maxPages] 是已有基线时的翻页上限，防止长时间未检查导致请求无限翻页。
  /// 按当前关注规模，一页约覆盖 1.5 小时的综合动态流，8 页可覆盖半天左右的离开时长；
  /// 超出部分不会被标为未读（基线仍推进到「此刻」），代价是放弃「很久没看」的陈旧更新，
  /// 换取动态页首屏不会被几十次串行请求拖慢。
  static Future<DynamicUpUpdateResult?> scan({
    required DynamicPageLoader loadPage,
    required int baselineId,
    int backfillPages = 0,
    int maxPages = 8,
  }) async {
    final isInitial = baselineId <= 0;
    // 首次启用且要求回补时，本页全部已关注作者都计入未读；否则只收晚于基线的。
    final collectAll = isInitial && backfillPages > 0;
    // 首次启用即使不回补也至少要取一页，用于把基线推进到此刻。
    final pageLimit = isInitial
        ? (backfillPages < 1 ? 1 : backfillPages)
        : maxPages;

    final updatedUps = <int, UpItem>{};
    String? offset;
    String? nextBaseline;

    for (var page = 0; page < pageLimit; page++) {
      final data = await loadPage(offset);
      if (data == null) return null;
      if (data.itemCount == 0) break;

      // 首次取页时锁定本次基线；服务端没有下发时用本页最大动态 id 兜底。
      if (nextBaseline == null) {
        final serverBaseline = data.updateBaseline;
        if (serverBaseline?.isNotEmpty == true) {
          nextBaseline = serverBaseline;
        } else if (data.maxId > 0) {
          nextBaseline = data.maxId.toString();
        }
      }

      collectPage(
        updatedUps,
        data,
        collectAll ? 0 : baselineId,
      );

      final nextOffset = data.offset;
      if (!data.hasMore || nextOffset == null || nextOffset.isEmpty) {
        break;
      }
      // 已有基线时，本页末条不晚于基线即说明增量已经收完。
      if (!isInitial && passedBaseline(data, baselineId)) {
        break;
      }
      offset = nextOffset;
    }

    return DynamicUpUpdateResult(
      updateBaseline: nextBaseline,
      updatedUps: updatedUps.values.toList(),
    );
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
