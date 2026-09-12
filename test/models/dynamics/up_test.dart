import 'package:PiliPlus/models/dynamics/up.dart';
import 'package:flutter_test/flutter_test.dart';

/// 验证动态更新解析、分页收集和红点排序的核心业务规则。
void main() {
  test('动态更新页保留条目位置并只解析已关注 UP', () {
    final page = DynamicUpUpdatePage.fromJson({
      'update_baseline': '300',
      'update_num': 3,
      'offset': '100',
      'has_more': true,
      'items': [
        {
          'id_str': '300',
          'modules': {
            'module_author': {
              'mid': 1,
              'name': '已关注作者',
              'face': 'face-1',
              'following': true,
              'pub_ts': 300,
            },
          },
        },
        {
          'modules': {
            'module_author': {
              'mid': 2,
              'name': '番剧等非关注作者',
              'following': false,
              'pub_ts': 200,
            },
          },
        },
        <String, dynamic>{},
      ],
    });

    expect(page.updateBaseline, '300');
    expect(page.updateNum, 3);
    expect(page.offset, '100');
    expect(page.hasMore, isTrue);
    expect(page.itemCount, 3);
    expect(page.items[0]?.mid, 1);
    expect(page.items[0]?.latestUpdateAt, 300);
    expect(page.items[1], isNull);
    expect(page.items[2], isNull);
  });

  test('接口省略更新基线时回退到首条动态 ID', () {
    final page = DynamicUpUpdatePage.fromJson({
      'items': [
        {'id_str': 'fallback-baseline'},
      ],
    });

    expect(page.updateBaseline, 'fallback-baseline');
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

  test('跨页仅收集更新数量内的作者并保留每位 UP 最新时间', () {
    // 构造最小动态作者模块，保持测试数据与真实接口层级一致。
    Map<String, dynamic> item(int mid, int pubTs) => {
      'modules': {
        'module_author': {
          'mid': mid,
          'name': 'UP$mid',
          'following': true,
          'pub_ts': pubTs,
        },
      },
    };

    final firstPage = DynamicUpUpdatePage.fromJson({
      'items': [item(1, 300), item(1, 200)],
    });
    final secondPage = DynamicUpUpdatePage.fromJson({
      'items': [item(2, 100), item(3, 50)],
    });
    final updatedUps = <int, UpItem>{};

    int remaining = DynamicUpUpdateResult.collectPage(
      updatedUps,
      firstPage,
      3,
    );
    remaining = DynamicUpUpdateResult.collectPage(
      updatedUps,
      secondPage,
      remaining,
    );

    expect(remaining, -1);
    expect(updatedUps.keys, [1, 2]);
    expect(updatedUps[1]?.latestUpdateAt, 300);
    expect(updatedUps.containsKey(3), isFalse);
  });
}
