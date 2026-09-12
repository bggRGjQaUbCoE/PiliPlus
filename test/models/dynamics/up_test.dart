import 'package:PiliPlus/models/common/dynamic/dynamic_up_list_mode.dart';
import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:flutter_test/flutter_test.dart';

/// 验证动态更新解析、基线截断和红点排序的核心业务规则。
///
/// 夹具刻意沿用真实接口的字段形态，避免再次出现“测试通过但线上失效”：
///   * `module_author.following` 实测为整数 `1`（不是布尔 `true`）
///   * `update_num` 实测为字符串 `'0'`，且与基线深浅无关，不能用于截取条数
void main() {
  /// 构造一条动态流记录，字段层级与 `/feed/all` 返回一致。
  Map<String, dynamic> dynItem({
    required String idStr,
    required int mid,
    Object? following = 1,
    int pubTs = 100,
    String type = 'DYNAMIC_TYPE_AV',
    String name = 'UP',
  }) => {
    'id_str': idStr,
    'type': type,
    'modules': {
      'module_author': {
        'mid': mid,
        'name': name,
        'face': 'face-$mid',
        'following': following,
        'pub_ts': pubTs,
      },
    },
  };

  test('关注状态兼容整数 1 与布尔 true，两种形态都要识别', () {
    // 真实接口下发整数 1；早期写成 following == true 会导致整条动态被过滤。
    expect(UpItem.isFollowingAuthor(1), isTrue);
    expect(UpItem.isFollowingAuthor(true), isTrue);
    expect(UpItem.isFollowingAuthor(0), isFalse);
    expect(UpItem.isFollowingAuthor(false), isFalse);
    expect(UpItem.isFollowingAuthor(null), isFalse);
  });

  test('解析单页：保留动态 id，只收录关注中的作者', () {
    final page = DynamicUpUpdatePage.fromJson({
      'update_baseline': '1247174239795019776',
      'update_num': '0',
      'offset': '1247140481416036368',
      'has_more': true,
      'items': [
        dynItem(idStr: '300', mid: 1, pubTs: 300),
        // 番剧、直播推荐等非关注作者必须被排除，但位置仍要保留供基线比较。
        dynItem(idStr: '200', mid: 2, following: 0, pubTs: 200),
        // 缺少 id 的异常记录按 0 处理，视为早于任何基线。
        <String, dynamic>{},
      ],
    });

    expect(page.updateBaseline, '1247174239795019776');
    expect(page.offset, '1247140481416036368');
    expect(page.hasMore, isTrue);
    expect(page.itemCount, 3);
    expect(page.entries[0].dynamicId, 300);
    expect(page.entries[0].up?.mid, 1);
    expect(page.entries[0].up?.latestUpdateAt, 300);
    // 非关注作者：条目保留、作者为空
    expect(page.entries[1].dynamicId, 200);
    expect(page.entries[1].up, isNull);
    expect(page.entries[2].dynamicId, 0);
    expect(page.entries[2].up, isNull);
    expect(page.lastId, 0);
  });

  test('服务端未下发基线时用本页最大 id 兜底，不被置顶动态拉低', () {
    final page = DynamicUpUpdatePage.fromJson({
      'items': [
        // 置顶动态会以较早的 id 排在最前面
        dynItem(idStr: '100', mid: 9, pubTs: 100),
        dynItem(idStr: '900', mid: 8, pubTs: 900),
      ],
    });

    expect(page.updateBaseline, isNull);
    expect(page.maxId, 900);
    expect(page.lastId, 900);
  });

  test('只收集动态 id 严格大于基线的作者，基线为 0 时视为首次回补全收', () {
    final page = DynamicUpUpdatePage.fromJson({
      'items': [
        dynItem(idStr: '500', mid: 1, pubTs: 500),
        dynItem(idStr: '300', mid: 2, pubTs: 300),
        dynItem(idStr: '100', mid: 3, pubTs: 100),
      ],
    });

    // 基线 300：500 算新，300 与 100 都不算（边界取严格大于）
    final incremental = <int, UpItem>{};
    DynamicUpUpdateResult.collectPage(incremental, page, 300);
    expect(incremental.keys, [1]);

    // 基线 0：首次回补，全部已关注作者都计入
    final backfill = <int, UpItem>{};
    DynamicUpUpdateResult.collectPage(backfill, page, 0);
    expect(backfill.keys, [1, 2, 3]);
  });

  test('同一 UP 多条新动态只保留发布时间最新的一条', () {
    final page = DynamicUpUpdatePage.fromJson({
      'items': [
        dynItem(idStr: '500', mid: 1, pubTs: 500),
        dynItem(idStr: '400', mid: 1, pubTs: 400),
        dynItem(idStr: '300', mid: 1, pubTs: 300),
      ],
    });

    final ups = <int, UpItem>{};
    DynamicUpUpdateResult.collectPage(ups, page, 0);

    expect(ups.length, 1);
    expect(ups[1]?.latestUpdateAt, 500);
  });

  test('跨页收集：基线之上的作者全部收集，越过基线即停止', () {
    final firstPage = DynamicUpUpdatePage.fromJson({
      'items': [
        dynItem(idStr: '900', mid: 1, pubTs: 900),
        dynItem(idStr: '800', mid: 2, pubTs: 800),
      ],
    });
    final secondPage = DynamicUpUpdatePage.fromJson({
      'items': [
        dynItem(idStr: '300', mid: 3, pubTs: 300),
        dynItem(idStr: '200', mid: 4, pubTs: 200),
      ],
    });

    final ups = <int, UpItem>{};
    DynamicUpUpdateResult.collectPage(ups, firstPage, 100);
    expect(DynamicUpUpdateResult.passedBaseline(firstPage, 100), isFalse);

    DynamicUpUpdateResult.collectPage(ups, secondPage, 100);
    // 300/200 仍大于基线 100，继续收集；末条 200 也未越过基线。
    expect(ups.keys, [1, 2, 3, 4]);
    expect(DynamicUpUpdateResult.passedBaseline(secondPage, 100), isFalse);

    // 基线抬到 250 后，第二页只剩 300 算新，且末条 200 已越过基线。
    final ups2 = <int, UpItem>{};
    DynamicUpUpdateResult.collectPage(ups2, secondPage, 250);
    expect(ups2.keys, [3]);
    expect(DynamicUpUpdateResult.passedBaseline(secondPage, 250), isTrue);
  });

  test('红点展示范围：仅视频模式只认确知是视频的更新', () {
    // 「所有动态」不筛类型；「常看」走官方红点，同样不筛。
    expect(DynamicUpListMode.all.showsBadge(true), isTrue);
    expect(DynamicUpListMode.all.showsBadge(false), isTrue);
    expect(DynamicUpListMode.all.showsBadge(null), isTrue);
    expect(DynamicUpListMode.frequent.showsBadge(null), isTrue);

    // 「仅视频」只展示确知是视频的更新；官方带入的无类型红点（null）必须排除，
    // 否则只发了图文的 UP 也会被标红。
    expect(DynamicUpListMode.video.showsBadge(true), isTrue);
    expect(DynamicUpListMode.video.showsBadge(false), isFalse);
    expect(DynamicUpListMode.video.showsBadge(null), isFalse);
  });

  test('更新 UP 按发布时间置顶且未更新组保持原顺序', () {
    final items = [
      UpItem(mid: 1, uname: '未更新一'),
      UpItem(mid: 2, uname: '较早更新', hasUpdate: true, latestUpdateAt: 100),
      UpItem(mid: 3, uname: '未更新二'),
      UpItem(mid: 4, uname: '最新更新', hasUpdate: true, latestUpdateAt: 200),
      UpItem(mid: 5, uname: '同时间更新', hasUpdate: true, latestUpdateAt: 100),
    ];

    DynamicUpUpdateResult.sortUnreadFirst(items);

    expect(items.map((item) => item.mid), [4, 2, 5, 1, 3]);
  });
}
