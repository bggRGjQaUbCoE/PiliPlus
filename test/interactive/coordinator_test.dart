import 'dart:async';

import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/data.dart';
import 'package:PiliPlus/pages/video/interactive/interactive_coordinator.dart';
import 'package:PiliPlus/pages/video/interactive/interactive_session.dart'
    show kMaxAutoAdvanceDepth;
import 'package:flutter_test/flutter_test.dart';

/// 一个互动节点（可调 type/选项/变量）。
Map<String, dynamic> _nodeJson({
  required int edgeId,
  int type = 1,
  int cid = 0,
  bool isLeaf = false,
  bool noBacktracking = false,
  int duration = -1,
  String? cover,
  List<Map<String, dynamic>> choices = const <Map<String, dynamic>>[],
  List<Map<String, dynamic>> hiddenVars = const <Map<String, dynamic>>[],
}) => <String, dynamic>{
  'edge_id': edgeId,
  'is_leaf': isLeaf ? 1 : 0,
  'no_backtracking': noBacktracking ? 1 : 0,
  'title': 'node-$edgeId',
  'story_list': <Map<String, dynamic>>[
    <String, dynamic>{'cid': cid, 'is_current': 1, 'cover': cover},
  ],
  'hidden_vars': hiddenVars,
  'edges': <String, dynamic>{
    'questions': <Map<String, dynamic>>[
      <String, dynamic>{
        'id': 0,
        'type': type,
        'duration': duration,
        'pause_video': 1,
        'choices': choices,
      },
    ],
  },
};

EdgeInfoData _node({
  required int edgeId,
  int type = 1,
  int cid = 0,
  bool isLeaf = false,
  bool noBacktracking = false,
  int duration = -1,
  String? cover,
  List<Map<String, dynamic>> choices = const <Map<String, dynamic>>[],
  List<Map<String, dynamic>> hiddenVars = const <Map<String, dynamic>>[],
}) => EdgeInfoData.fromJson(
  _nodeJson(
    edgeId: edgeId,
    type: type,
    cid: cid,
    isLeaf: isLeaf,
    noBacktracking: noBacktracking,
    duration: duration,
    cover: cover,
    choices: choices,
    hiddenVars: hiddenVars,
  ),
);

/// 测试用协调器宿主。
class _Harness {
  _Harness({
    required this.nodes,
    this.graphVersion = 1633771,
    this.switchResult = true,
  });

  final Map<int?, EdgeInfoData> nodes;
  int? graphVersion;
  bool switchResult;

  final List<int> switchedCids = <int>[];
  int showCount = 0;
  int hideCount = 0;
  int pauseCount = 0;
  Duration? fetchDelay;

  late final InteractiveCoordinator coordinator = InteractiveCoordinator(
    onSwitchPart: (int cid, String? title) async {
      switchedCids.add(cid);
      return switchResult;
    },
    getBvid: () => 'BV1GbNd6bEj2',
    getGraphVersion: () => graphVersion,
    onShowQuestion: () => showCount++,
    onHideQuestion: () => hideCount++,
    onPausePlayer: () => pauseCount++,
    fetchNode: (String bvid, _, {int? edgeId}) async {
      if (fetchDelay != null) {
        await Future<void>.delayed(fetchDelay!);
      }
      final EdgeInfoData? node = nodes[edgeId] ?? nodes[null];
      if (node == null) {
        return (null, -1, 'node $edgeId not found');
      }
      return (node, 0, '0');
    },
  );
}

/// 让出事件循环若干次，等待 unawaited 的推进流程结束。
Future<void> _settle([int times = 6]) async {
  for (int i = 0; i < times; i++) {
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }
}

void main() {
  group('coordinator: 用户选择节点', () {
    test('加载完成后不立即展示，播放完成才展示', () async {
      final _Harness h = _Harness(
        nodes: <int?, EdgeInfoData>{
          null: _node(
            edgeId: 1,
            cid: 111,
            choices: <Map<String, dynamic>>[
              <String, dynamic>{
                'id': 2,
                'cid': 222,
                'option': 'A',
                'is_default': 1,
              },
            ],
          ),
        },
      );
      await h.coordinator.enterNode(null);
      await _settle();
      expect(h.coordinator.uiState.value, isA<SteinQuestion>());
      // 尚未播完：不通知 UI 展示
      expect(h.showCount, 0);

      expect(h.coordinator.onPlaybackCompleted(), isTrue);
      await _settle();
      expect(h.showCount, 1);
      expect(h.pauseCount, 1, reason: 'pause_video=1 应暂停');
    });

    test('选择选项：先执行 action 再切分P再加载下一节点', () async {
      final _Harness h = _Harness(
        nodes: <int?, EdgeInfoData>{
          null: _node(
            edgeId: 1,
            cid: 111,
            hiddenVars: <Map<String, dynamic>>[
              <String, dynamic>{'id_v2': r'$a', 'value': 1, 'type': 1},
            ],
            choices: <Map<String, dynamic>>[
              <String, dynamic>{
                'id': 2,
                'cid': 222,
                'option': 'A',
                'native_action': r'$a=$a+2.00',
              },
            ],
          ),
          2: _node(edgeId: 2, cid: 222),
        },
      );
      await h.coordinator.enterNode(null);
      h.coordinator.onPlaybackCompleted();
      await _settle();

      final SteinQuestion state = h.coordinator.uiState.value as SteinQuestion;
      await h.coordinator.selectChoice(state.plan.visibleChoices.single);
      await _settle();

      expect(h.switchedCids, <int>[222]);
      expect(h.coordinator.currentNode!.edgeId, 2);
      expect(h.coordinator.session.vars[r'$a'], 3);
      expect(h.hideCount, greaterThanOrEqualTo(1));
    });

    test('切分P失败：变量回滚并进入错误态', () async {
      final _Harness h = _Harness(
        nodes: <int?, EdgeInfoData>{
          null: _node(
            edgeId: 1,
            cid: 111,
            hiddenVars: <Map<String, dynamic>>[
              <String, dynamic>{'id_v2': r'$a', 'value': 1, 'type': 1},
            ],
            choices: <Map<String, dynamic>>[
              <String, dynamic>{
                'id': 2,
                'cid': 222,
                'option': 'A',
                'native_action': r'$a=$a+2.00',
              },
            ],
          ),
        },
        switchResult: false,
      );
      await h.coordinator.enterNode(null);
      h.coordinator.onPlaybackCompleted();
      await _settle();

      final SteinQuestion state = h.coordinator.uiState.value as SteinQuestion;
      await h.coordinator.selectChoice(state.plan.visibleChoices.single);
      await _settle();

      expect(h.coordinator.session.vars[r'$a'], 1, reason: '未跳转，变量必须回滚');
      expect(h.coordinator.uiState.value, isA<SteinError>());
      expect(h.coordinator.lastError, contains('切换分P失败'));
      expect(h.coordinator.currentNode!.edgeId, 1, reason: '不应停在旧节点之外');
    });

    test('连点保护：第二次点击被忽略', () async {
      final _Harness h = _Harness(
        nodes: <int?, EdgeInfoData>{
          null: _node(
            edgeId: 1,
            cid: 111,
            choices: <Map<String, dynamic>>[
              <String, dynamic>{'id': 2, 'cid': 222, 'option': 'A'},
            ],
          ),
          2: _node(edgeId: 2, cid: 222),
        },
      );
      await h.coordinator.enterNode(null);
      h.coordinator.onPlaybackCompleted();
      await _settle();
      final SteinQuestion state = h.coordinator.uiState.value as SteinQuestion;
      final choice = state.plan.visibleChoices.single;

      h.coordinator.selectChoice(choice);
      h.coordinator.selectChoice(choice);
      await _settle();
      expect(h.switchedCids.length, 1);
    });
  });

  group('coordinator: 自动节点', () {
    test('type=0 节点播完后才推进', () async {
      final _Harness h = _Harness(
        nodes: <int?, EdgeInfoData>{
          null: _node(
            edgeId: 1,
            cid: 111,
            type: 0,
            hiddenVars: <Map<String, dynamic>>[
              <String, dynamic>{'id_v2': r'$a', 'value': 0, 'type': 1},
            ],
            choices: <Map<String, dynamic>>[
              <String, dynamic>{
                'id': 2,
                'cid': 222,
                'option': 'A ',
                'is_default': 1,
                'native_action': r'$a=$a+1.00',
              },
            ],
          ),
          2: _node(edgeId: 2, cid: 222, isLeaf: true),
        },
      );
      await h.coordinator.enterNode(null);
      await _settle();
      expect(h.coordinator.uiState.value, isA<SteinAutoWaiting>());
      expect(h.switchedCids, isEmpty, reason: '节点自身视频未播完不得跳转');

      expect(h.coordinator.onPlaybackCompleted(), isTrue);
      await _settle();
      expect(h.switchedCids, <int>[222]);
      expect(h.coordinator.session.vars[r'$a'], 1);
      expect(h.coordinator.currentNode!.edgeId, 2);
      // 叶子节点：播完后展示结束态
      h.coordinator.onPlaybackCompleted();
      await _settle();
      expect(h.coordinator.uiState.value, isA<SteinLeaf>());
    });

    test('多级自动节点连续推进', () async {
      final _Harness h = _Harness(
        nodes: <int?, EdgeInfoData>{
          null: _node(
            edgeId: 1,
            cid: 1,
            type: 0,
            choices: <Map<String, dynamic>>[
              <String, dynamic>{'id': 2, 'cid': 2, 'is_default': 1},
            ],
          ),
          2: _node(
            edgeId: 2,
            cid: 2,
            type: 0,
            choices: <Map<String, dynamic>>[
              <String, dynamic>{'id': 3, 'cid': 3, 'is_default': 1},
            ],
          ),
          3: _node(
            edgeId: 3,
            cid: 3,
            type: 0,
            choices: <Map<String, dynamic>>[
              <String, dynamic>{'id': 4, 'cid': 4, 'is_default': 1},
            ],
          ),
          4: _node(edgeId: 4, cid: 4, isLeaf: true),
        },
      );
      await h.coordinator.enterNode(null);
      for (int i = 0; i < 8; i++) {
        if (h.coordinator.uiState.value is SteinLeaf) {
          break;
        }
        h.coordinator.onPlaybackCompleted();
        await _settle();
      }
      expect(h.switchedCids, <int>[2, 3, 4]);
      expect(h.coordinator.uiState.value, isA<SteinLeaf>());
    });

    test('环图保护：重复分支停止推进', () async {
      final _Harness h = _Harness(
        nodes: <int?, EdgeInfoData>{
          null: _node(
            edgeId: 1,
            cid: 1,
            type: 0,
            choices: <Map<String, dynamic>>[
              <String, dynamic>{'id': 2, 'cid': 11, 'is_default': 1},
            ],
          ),
          2: _node(
            edgeId: 2,
            cid: 11,
            type: 0,
            choices: <Map<String, dynamic>>[
              <String, dynamic>{'id': 1, 'cid': 1, 'is_default': 1},
            ],
          ),
        },
      );
      await h.coordinator.enterNode(null);
      for (int i = 0; i < 6; i++) {
        if (h.coordinator.uiState.value is SteinError) {
          break;
        }
        h.coordinator.onPlaybackCompleted();
        await _settle();
      }
      expect(h.coordinator.uiState.value, isA<SteinError>());
      expect(h.coordinator.lastError, contains('重复'));
    });

    test('深度保护：超过 kMaxAutoAdvanceDepth 停止', () async {
      final Map<int?, EdgeInfoData> nodes = <int?, EdgeInfoData>{};
      const int total = kMaxAutoAdvanceDepth + 5;
      for (int i = 1; i <= total; i++) {
        nodes[i == 1 ? null : i] = _node(
          edgeId: i,
          cid: i,
          type: 0,
          choices: <Map<String, dynamic>>[
            <String, dynamic>{'id': i + 1, 'cid': i + 1, 'is_default': 1},
          ],
        );
      }
      nodes[total + 1] = _node(edgeId: total + 1, cid: total + 1, isLeaf: true);
      final _Harness h = _Harness(nodes: nodes);
      await h.coordinator.enterNode(null);
      for (int i = 0; i < total + 3; i++) {
        if (h.coordinator.uiState.value is SteinError) {
          break;
        }
        h.coordinator.onPlaybackCompleted();
        await _settle();
      }
      expect(h.coordinator.uiState.value, isA<SteinError>());
      expect(h.coordinator.lastError, contains('$kMaxAutoAdvanceDepth'));
    });
  });

  group('coordinator: 竞态与陈旧响应', () {
    test('并发 enterNode：陈旧响应被丢弃', () async {
      final _Harness h = _Harness(
        nodes: <int?, EdgeInfoData>{
          1: _node(edgeId: 1, cid: 111),
          2: _node(edgeId: 2, cid: 222),
        },
      );
      final Completer<(EdgeInfoData?, int, String)> slow =
          Completer<(EdgeInfoData?, int, String)>();
      final _Harness delayed = h;
      final InteractiveCoordinator c = InteractiveCoordinator(
        onSwitchPart: (int cid, String? title) async => true,
        getBvid: () => 'BV',
        getGraphVersion: () => 1,
        onShowQuestion: () {},
        onHideQuestion: () {},
        fetchNode: (String bvid, _, {int? edgeId}) {
          if (edgeId == 1) {
            return slow.future;
          }
          return Future<(EdgeInfoData?, int, String)>.value(
            (delayed.nodes[edgeId], 0, '0'),
          );
        },
      );

      final Future<bool> first = c.enterNode(1);
      final Future<bool> second = c.enterNode(2);
      await _settle();
      expect(c.currentNode!.edgeId, 2);

      slow.complete((delayed.nodes[1], 0, '0'));
      await Future.wait(<Future<bool>>[first, second]);
      await _settle();
      expect(c.currentNode!.edgeId, 2, reason: '过期响应不得覆盖新节点');
    });

    test('播放完成早于加载完成：加载完立即展示', () async {
      final _Harness h = _Harness(
        nodes: <int?, EdgeInfoData>{
          null: _node(
            edgeId: 1,
            cid: 111,
            choices: <Map<String, dynamic>>[
              <String, dynamic>{'id': 2, 'cid': 222, 'option': 'A'},
            ],
          ),
        },
      )..fetchDelay = const Duration(milliseconds: 20);

      final Future<bool> loading = h.coordinator.enterNode(null);
      await Future<void>.delayed(const Duration(milliseconds: 1));
      expect(h.coordinator.onPlaybackCompleted(), isTrue);
      await loading;
      await _settle();
      expect(h.coordinator.uiState.value, isA<SteinQuestion>());
      expect(h.showCount, 1);
    });

    test('加载失败 → 错误态，retry 恢复', () async {
      final _Harness h = _Harness(nodes: <int?, EdgeInfoData>{});
      await h.coordinator.enterNode(null);
      await _settle();
      expect(h.coordinator.uiState.value, isA<SteinError>());
      expect(h.coordinator.loadFailed.value, isTrue);

      h.nodes[null] = _node(edgeId: 1, cid: 111, isLeaf: true);
      await h.coordinator.retry();
      await _settle();
      expect(h.coordinator.uiState.value, isA<SteinLeaf>());
      expect(h.coordinator.loadFailed.value, isFalse);
    });
  });

  group('coordinator: 倒计时', () {
    test('限时问题倒计时结束提交默认项', () async {
      final _Harness h = _Harness(
        nodes: <int?, EdgeInfoData>{
          null: _node(
            edgeId: 1,
            cid: 111,
            duration: 300,
            choices: <Map<String, dynamic>>[
              <String, dynamic>{'id': 2, 'cid': 222, 'option': 'A'},
              <String, dynamic>{
                'id': 3,
                'cid': 333,
                'option': 'B',
                'is_default': 1,
              },
            ],
          ),
          3: _node(edgeId: 3, cid: 333, isLeaf: true),
        },
      );
      await h.coordinator.enterNode(null);
      h.coordinator.onPlaybackCompleted();
      expect(h.coordinator.countdownMs.value, 300);
      await Future<void>.delayed(const Duration(milliseconds: 800));
      await _settle();
      expect(h.switchedCids, <int>[333], reason: '倒计时结束应提交 is_default 项');
      expect(h.coordinator.countdownMs.value, 0);
    });

    test('dispose 后倒计时停止', () async {
      final _Harness h = _Harness(
        nodes: <int?, EdgeInfoData>{
          null: _node(
            edgeId: 1,
            cid: 111,
            duration: 3000,
            choices: <Map<String, dynamic>>[
              <String, dynamic>{'id': 2, 'cid': 222, 'option': 'A'},
            ],
          ),
        },
      );
      await h.coordinator.enterNode(null);
      h.coordinator.onPlaybackCompleted();
      await Future<void>.delayed(const Duration(milliseconds: 250));
      final int left = h.coordinator.countdownMs.value;
      expect(left, lessThan(3000));
      h.coordinator.dispose();
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(h.coordinator.countdownMs.value, left);
      expect(h.switchedCids, isEmpty);
    });
  });

  group('coordinator: 回溯（issue #2419）', () {
    test('回溯恢复上一节点与变量快照', () async {
      final _Harness h = _Harness(
        nodes: <int?, EdgeInfoData>{
          null: _node(
            edgeId: 1,
            cid: 111,
            hiddenVars: <Map<String, dynamic>>[
              <String, dynamic>{'id_v2': r'$a', 'value': 0, 'type': 1},
            ],
            choices: <Map<String, dynamic>>[
              <String, dynamic>{
                'id': 2,
                'cid': 222,
                'option': 'A',
                'native_action': r'$a=$a+5.00',
              },
            ],
          ),
          2: _node(edgeId: 2, cid: 222),
        },
      );
      await h.coordinator.enterNode(null);
      h.coordinator.onPlaybackCompleted();
      await _settle();
      expect(h.coordinator.canBacktrack, isFalse, reason: '仅一个节点');

      final SteinQuestion state = h.coordinator.uiState.value as SteinQuestion;
      await h.coordinator.selectChoice(state.plan.visibleChoices.single);
      await _settle();
      expect(h.coordinator.session.vars[r'$a'], 5);
      expect(h.coordinator.canBacktrack, isTrue);

      await h.coordinator.backtrack();
      await _settle();
      expect(h.switchedCids.last, 111);
      expect(h.coordinator.currentNode!.edgeId, 1);
      expect(h.coordinator.session.vars[r'$a'], 0, reason: '变量必须还原');
      expect(h.coordinator.history.length, 1);
    });

    test('no_backtracking=1 禁止回溯', () async {
      final _Harness h = _Harness(
        nodes: <int?, EdgeInfoData>{
          null: _node(
            edgeId: 1,
            cid: 111,
            noBacktracking: true,
            choices: <Map<String, dynamic>>[
              <String, dynamic>{'id': 2, 'cid': 222, 'option': 'A'},
            ],
          ),
          2: _node(edgeId: 2, cid: 222),
        },
      );
      await h.coordinator.enterNode(null);
      h.coordinator.onPlaybackCompleted();
      await _settle();
      final SteinQuestion state = h.coordinator.uiState.value as SteinQuestion;
      await h.coordinator.selectChoice(state.plan.visibleChoices.single);
      await _settle();
      expect(h.coordinator.canBacktrack, isFalse);
      final int before = h.switchedCids.length;
      await h.coordinator.backtrack();
      await _settle();
      expect(h.switchedCids.length, before);
    });
  });

  group('coordinator: 普通视频回归', () {
    test('graphVersion 为 null 时不接管播放完成', () async {
      final _Harness h = _Harness(
        nodes: <int?, EdgeInfoData>{},
        graphVersion: null,
      );
      expect(h.coordinator.onPlaybackCompleted(), isFalse);
      expect(await h.coordinator.enterNode(null), isFalse);
      expect(h.switchedCids, isEmpty);
      expect(h.showCount, 0);
    });
  });

  group('coordinator: 浮层可见性', () {
    test('节点就绪但不展示选项，播放完成才展示', () async {
      final _Harness h = _Harness(
        nodes: <int?, EdgeInfoData>{
          null: _node(
            edgeId: 1,
            cid: 111,
            choices: <Map<String, dynamic>>[
              <String, dynamic>{'id': 2, 'cid': 222, 'option': 'A'},
            ],
          ),
          2: _node(edgeId: 2, cid: 222),
        },
      );
      await h.coordinator.enterNode(null);
      expect(h.coordinator.uiState.value, isA<SteinQuestion>());
      expect(
        h.coordinator.overlayVisible.value,
        isFalse,
        reason: '本段视频未播完，不允许出现选项',
      );
      h.coordinator.onPlaybackCompleted();
      await _settle();
      expect(h.coordinator.overlayVisible.value, isTrue);
    });

    test('选择后立即隐藏，避免旧选项残留', () async {
      final _Harness h = _Harness(
        nodes: <int?, EdgeInfoData>{
          null: _node(
            edgeId: 1,
            cid: 111,
            choices: <Map<String, dynamic>>[
              <String, dynamic>{'id': 2, 'cid': 222, 'option': 'A'},
            ],
          ),
          2: _node(edgeId: 2, cid: 222, isLeaf: true),
        },
      );
      await h.coordinator.enterNode(null);
      h.coordinator.onPlaybackCompleted();
      await _settle();
      final SteinQuestion state = h.coordinator.uiState.value as SteinQuestion;
      unawaited(h.coordinator.selectChoice(state.plan.visibleChoices.single));
      expect(h.coordinator.overlayVisible.value, isFalse);
      await _settle();
      expect(h.coordinator.currentNode!.edgeId, 2);
      expect(h.coordinator.overlayVisible.value, isFalse, reason: '新节点尚未播完');
    });
  });

  group('coordinator: 进度回溯面板', () {
    test('backtrackTo 可跳到任意历史节点并截断其后记录', () async {
      final _Harness h = _Harness(
        nodes: <int?, EdgeInfoData>{
          null: _node(
            edgeId: 1,
            cid: 111,
            choices: <Map<String, dynamic>>[
              <String, dynamic>{'id': 2, 'cid': 222, 'option': 'A'},
            ],
          ),
          2: _node(
            edgeId: 2,
            cid: 222,
            choices: <Map<String, dynamic>>[
              <String, dynamic>{'id': 3, 'cid': 333, 'option': 'B'},
            ],
          ),
          3: _node(edgeId: 3, cid: 333, isLeaf: true),
        },
      );
      await h.coordinator.enterNode(null);
      h.coordinator.onPlaybackCompleted();
      await _settle();
      await h.coordinator.selectChoice(
        (h.coordinator.uiState.value as SteinQuestion)
            .plan
            .visibleChoices
            .single,
      );
      await _settle();
      h.coordinator.onPlaybackCompleted();
      await _settle();
      await h.coordinator.selectChoice(
        (h.coordinator.uiState.value as SteinQuestion)
            .plan
            .visibleChoices
            .single,
      );
      await _settle();
      expect(h.coordinator.history.length, 3);

      await h.coordinator.backtrackTo(0);
      await _settle();
      expect(h.switchedCids.last, 111);
      expect(h.coordinator.currentNode!.edgeId, 1);
      expect(h.coordinator.history.length, 1, reason: '后续记录应被截断');
    });

    test('越界/当前节点索引不触发跳转', () async {
      final _Harness h = _Harness(
        nodes: <int?, EdgeInfoData>{
          null: _node(
            edgeId: 1,
            cid: 111,
            choices: <Map<String, dynamic>>[
              <String, dynamic>{'id': 2, 'cid': 222, 'option': 'A'},
            ],
          ),
          2: _node(edgeId: 2, cid: 222),
        },
      );
      await h.coordinator.enterNode(null);
      h.coordinator.onPlaybackCompleted();
      await _settle();
      await h.coordinator.selectChoice(
        (h.coordinator.uiState.value as SteinQuestion)
            .plan
            .visibleChoices
            .single,
      );
      await _settle();
      final int before = h.switchedCids.length;
      await h.coordinator.backtrackTo(1);
      await h.coordinator.backtrackTo(9);
      await h.coordinator.backtrackTo(-1);
      await _settle();
      expect(h.switchedCids.length, before);
      expect(h.coordinator.history.length, 2);
    });

    test(
      'unrelated root-only story cover is not reused for a branch',
      () async {
        const cover = 'https://i0.hdslb.com/root.jpg';
        final root = _node(
          edgeId: 1,
          cid: 111,
          cover: cover,
          choices: [
            {'id': 2, 'cid': 222, 'option': 'A'},
          ],
        );
        final branch = _nodeJson(edgeId: 2, cid: 222, isLeaf: true);
        branch['story_list'] = [
          {'edge_id': 1, 'cid': 111, 'cover': cover, 'is_current': 1},
        ];
        final h = _Harness(
          nodes: {
            null: root,
            2: EdgeInfoData.fromJson(branch),
          },
        );
        await h.coordinator.enterNode(null);
        h.coordinator.onPlaybackCompleted();
        await h.coordinator.selectChoice(
          (h.coordinator.uiState.value as SteinQuestion)
              .plan
              .visibleChoices
              .single,
        );
        expect(h.coordinator.history.length, 2);
        expect(h.coordinator.history.first.cover, cover);
        expect(h.coordinator.history.last.cid, 222);
        // 不复用根封面，改用该分P自己的服务端截图地址。
        expect(
          h.coordinator.history.last.cover,
          'https://i0.hdslb.com/bfs/steins-gate/222_screenshot.jpg',
        );
        expect(h.coordinator.history.last.cover, isNot(cover));
      },
    );

    test('story_list 命中的封面优先于分P截图地址', () async {
      final json = _nodeJson(edgeId: 2, cid: 222, isLeaf: true);
      json['story_list'] = [
        {'edge_id': 2, 'cid': 222, 'cover': 'https://i0.hdslb.com/branch.jpg'},
      ];
      final h = _Harness(nodes: {null: EdgeInfoData.fromJson(json)});
      await h.coordinator.enterNode(2, cid: 222);
      expect(h.coordinator.history.single.cover, 'https://i0.hdslb.com/branch.jpg');
    });

    test('缺少 cid 的检查点没有封面可拼，保持占位', () async {
      final json = _nodeJson(edgeId: 2, isLeaf: true)..remove('story_list');
      final h = _Harness(nodes: {null: EdgeInfoData.fromJson(json)});
      await h.coordinator.enterNode(2);
      expect(h.coordinator.history.single.cid, isNull);
      expect(h.coordinator.history.single.cover, isNull);
    });

    test('blank CID covers do not prevent later CID or edge matches', () async {
      for (final matchByCid in <bool>[true, false]) {
        final json = _nodeJson(edgeId: 2, cid: 222, isLeaf: true);
        json['story_list'] = [
          {'edge_id': 1, 'cid': 222, 'cover': '  '},
          {
            'edge_id': 2,
            'cid': matchByCid ? 222 : 333,
            'cover': 'https://i0.hdslb.com/branch.jpg',
          },
        ];
        final h = _Harness(nodes: {null: EdgeInfoData.fromJson(json)});
        await h.coordinator.enterNode(2, cid: 222);
        expect(
          h.coordinator.history.single.cover,
          'https://i0.hdslb.com/branch.jpg',
        );
      }
    });

    test('回溯检查点携带 story_list 封面', () async {
      final _Harness h = _Harness(
        nodes: <int?, EdgeInfoData>{
          null: _node(
            edgeId: 1,
            cid: 111,
            cover: 'http://i0.hdslb.com/bfs/steins-gate/111_screenshot.jpg',
            choices: <Map<String, dynamic>>[
              <String, dynamic>{'id': 2, 'cid': 222, 'option': 'A'},
            ],
          ),
          2: _node(edgeId: 2, cid: 222),
        },
      );
      await h.coordinator.enterNode(null);
      expect(
        h.coordinator.history.single.cover,
        'http://i0.hdslb.com/bfs/steins-gate/111_screenshot.jpg',
      );
    });
  });
}
