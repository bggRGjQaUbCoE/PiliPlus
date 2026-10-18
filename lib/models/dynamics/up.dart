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
    upList = (json['list'] as List?)?.map((e) => UpItem.fromJson(e)).toList();
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

  /// 动态流条目表示该条是否为视频，列表摘要表示该作者是否仍有未读视频。
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
    // 缺失或异常的官方状态必须保持未知，不能据此判定已读。
    hasUpdate = switch (json['has_update']) {
      true || 1 => true,
      false || 0 => false,
      _ => null,
    };
    latestUpdateAt = safeToInt(json['latest_update_at']);
    mid = safeToInt(json['mid']) ?? 0;
    uname = json['uname'];
    // 仅用于读取本地红点缓存，接口本身不会下发该键。
    isVideo = json['is_video'] is bool ? json['is_video'] : null;
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
  const DynamicUpdateEntry({
    required this.dynamicId,
    this.up,
    this.videoAid,
    this.videoBvid,
    this.isPinned = false,
  });

  /// 动态 id；缺失或解析失败按 0 处理，不收集该条，也不能据此判定扫描完成。
  final int dynamicId;

  /// 仅当作者处于关注状态且 mid 有效时非空，番剧、直播推荐等记录为 null。
  final UpItem? up;

  /// 视频身份用于精确匹配观看历史；图文和无法识别身份的视频保持为空。
  final int? videoAid;
  final String? videoBvid;

  /// 置顶记录不属于时间排序，不能用来判断是否已经翻到旧基线。
  final bool isPinned;
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
      // 只取当前动态的视频身份；转发正文内原作者的视频不能冒充转发者投稿。
      final dynamicModule = modules is Map ? modules['module_dynamic'] : null;
      final major = dynamicModule is Map ? dynamicModule['major'] : null;
      final archive = major is Map ? major['archive'] : null;
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
          videoAid: archive is Map ? safeToInt(archive['aid']) : null,
          videoBvid: archive is Map && archive['bvid'] is String
              ? archive['bvid']
              : null,
          isPinned: author is Map && author['is_top'] == true,
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
typedef DynamicPageLoader = Future<DynamicUpUpdatePage?> Function(
  String? offset,
);

/// 未完成扫描的游标与固定时间范围，跨刷新和应用重启继续补齐同一段增量。
class DynamicUpScanProgress {
  const DynamicUpScanProgress({
    required this.baselineId,
    required this.targetBaseline,
    required this.offset,
  });

  /// 完整扫描的旧截止线；不能在尚有后续页时提前推进。
  final int baselineId;
  final String targetBaseline;
  final String offset;

  /// 保存续扫范围，避免下一轮把新出现的动态与旧扫描截止线混在一起。
  Map<String, dynamic> toJson() => {
    'baseline': baselineId,
    'target': targetBaseline,
    'offset': offset,
  };

  /// 校验缓存范围和游标，损坏时由调用方从完整旧基线重新开始扫描。
  static DynamicUpScanProgress? fromJson(dynamic value) {
    if (value is! Map) return null;
    final baseline = safeToInt(value['baseline']);
    final target = safeToInt(value['target']);
    final offset = value['offset'];
    if (baseline == null ||
        baseline <= 0 ||
        target == null ||
        target < baseline ||
        offset is! String ||
        offset.isEmpty) {
      return null;
    }
    return DynamicUpScanProgress(
      baselineId: baseline,
      targetBaseline: '$target',
      offset: offset,
    );
  }
}

/// 一次更新检查的完整结果；同一 UP 发布多条动态时只保留一份作者信息。
class DynamicUpUpdateResult {
  const DynamicUpUpdateResult({
    required this.updateBaseline,
    required this.updatedUps,
    this.entries = const [],
    this.progress,
    this.isComplete = true,
  });

  final String? updateBaseline;
  final List<UpItem> updatedUps;

  /// 未读判定保留每条内容，避免最新图文覆盖旧视频以及观看旧视频误清新视频。
  final List<DynamicUpdateEntry> entries;
  final DynamicUpScanProgress? progress;
  final bool isComplete;

  /// 收集本页中动态 id 严格大于 [baselineId] 的已关注作者。
  ///
  /// [baselineId] 为 0 表示首次启用后的回补，此时本页所有已关注作者都计入。
  /// 摘要按最新发布时间排序，但保留该作者在窗口内是否存在视频的事实。
  static void collectPage(
    Map<int, UpItem> updatedUps,
    DynamicUpUpdatePage page,
    int baselineId,
  ) {
    for (final entry in page.entries) {
      if (entry.dynamicId <= 0 || entry.dynamicId <= baselineId) continue;
      final up = entry.up;
      if (up == null) continue;
      final old = updatedUps[up.mid];
      // 摘要使用副本，不能改写原始条目中的类型，内容级已读仍依赖原始类型。
      final latest =
          old == null || (up.latestUpdateAt ?? 0) > (old.latestUpdateAt ?? 0)
          ? up
          : old;
      updatedUps[up.mid] = UpItem(
        mid: up.mid,
        face: latest.face,
        uname: latest.uname,
        hasUpdate: true,
        latestUpdateAt: latest.latestUpdateAt,
        isVideo: old?.isVideo == true || up.isVideo == true,
      );
    }
  }

  /// 只有有效、按时间倒序的非置顶记录才能证明本页已经越过基线。
  static bool passedBaseline(DynamicUpUpdatePage page, int baselineId) {
    int? previous;
    for (final entry in page.entries) {
      if (entry.isPinned) continue;
      // 缺失 id 或倒序异常时继续翻页，不把未知记录当作基线之前的记录。
      if (entry.dynamicId <= 0 ||
          previous != null && entry.dynamicId > previous) {
        return false;
      }
      previous = entry.dynamicId;
    }
    return previous != null && previous <= baselineId;
  }

  /// 按官方常看列表的 `has_update` 剔除已在官方客户端读过的红点。
  ///
  /// `has_update` 是服务端维护的「该 UP 是否有你没看过的更新」，在任意官方客户端
  /// 打开该 UP 的动态都会置为 false，因此它能覆盖「在官方 App / 网页看过」的情况。
  /// 它只对官方返回的那批 UP 有效：**未出现在列表里的 UP 不能据此判断**，
  /// 所以这里只处理 [officialUps] 里明确给出状态的条目。
  ///
  /// [freshMids] 是本次扫描刚识别出的 UP，必须跳过 —— 官方状态与动态流是两个请求，
  /// 标志位可能还没跟上，否则会把刚刚出现的新更新立刻抹掉。
  static void pruneSeenByOfficialFlags(
    Map<int, UpItem> unreadUps,
    Iterable<UpItem>? officialUps, {
    Set<int> freshMids = const <int>{},
  }) {
    if (unreadUps.isEmpty || officialUps == null) return;
    for (final up in officialUps) {
      if (up.hasUpdate != false || freshMids.contains(up.mid)) continue;
      unreadUps.remove(up.mid);
    }
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
  /// 达到上限后保留 [DynamicUpScanProgress]，下一批从游标续扫；只有整段增量扫描完成
  /// 才推进完整基线。首次回补仍为有明确页数的最近记录，不能还原启用前全部已读历史。
  static Future<DynamicUpUpdateResult?> scan({
    required DynamicPageLoader loadPage,
    required int baselineId,
    int backfillPages = 0,
    int maxPages = 8,
    DynamicUpScanProgress? resume,
  }) async {
    // 续扫始终使用首次固定的旧基线和截止线，不随新的首屏动态改变扫描范围。
    baselineId = resume?.baselineId ?? baselineId;
    final isInitial = baselineId <= 0;
    // 首次启用且要求回补时，本页全部已关注作者都计入未读；否则只收晚于基线的。
    final collectAll = isInitial && backfillPages > 0;
    // 首次启用即使不回补也至少要取一页，用于把基线推进到此刻。
    final pageLimit = isInitial
        ? (backfillPages < 1 ? 1 : backfillPages)
        : (maxPages < 1 ? 1 : maxPages);

    final updatedUps = <int, UpItem>{};
    final collected = <DynamicUpdateEntry>[];
    String? offset = resume?.offset;
    String? nextBaseline = resume?.targetBaseline;
    bool complete = false;
    DynamicUpScanProgress? progress;
    final requestedOffsets = <String>{};

    for (var page = 0; page < pageLimit; page++) {
      final data = await loadPage(offset);
      if (data == null) return null;

      // 首次取页时锁定本次基线；服务端没有下发时用本页最大动态 id 兜底。
      if (nextBaseline == null) {
        final serverBaseline = safeToInt(data.updateBaseline) ?? 0;
        final latest = serverBaseline > data.maxId
            ? serverBaseline
            : data.maxId;
        nextBaseline = '${latest > baselineId ? latest : baselineId}';
      }

      // 首次零回补只建立基线；其余情况保留有效、在固定范围内的每条关注内容。
      if (!isInitial || collectAll) {
        final ceiling = safeToInt(nextBaseline) ?? 0;
        final eligible = data.entries.where(
          (entry) =>
              entry.up != null &&
              entry.dynamicId > baselineId &&
              entry.dynamicId <= ceiling,
        );
        collected.addAll(eligible);
        collectPage(updatedUps, data, baselineId);
      }

      final nextOffset = data.offset;
      if (!data.hasMore ||
          !isInitial && passedBaseline(data, baselineId) ||
          isInitial && page + 1 >= pageLimit) {
        complete = true;
        break;
      }
      // 游标缺失或重复时不能证明完成，也不能无限重复同一页。
      if (nextOffset == null ||
          nextOffset.isEmpty ||
          nextOffset == offset ||
          !requestedOffsets.add(nextOffset)) {
        // 不可前进的游标不能交给后台反复重试，下次刷新从完整旧基线重新开始。
        progress = null;
        break;
      }
      offset = nextOffset;
      progress = DynamicUpScanProgress(
        baselineId: baselineId,
        targetBaseline: nextBaseline,
        offset: offset,
      );
    }

    return DynamicUpUpdateResult(
      updateBaseline: complete ? nextBaseline : '$baselineId',
      updatedUps: updatedUps.values.toList(),
      entries: collected,
      progress: complete ? null : progress,
      isComplete: complete,
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
