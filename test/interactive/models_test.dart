import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/choice.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/data.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/hidden_var.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/question.dart';
import 'package:flutter_test/flutter_test.dart';

String _fixture(String name) => File(
  '${Directory.current.path}/test/interactive/fixtures/$name',
).readAsStringSync();

Map<String, dynamic> _json(String name) =>
    jsonDecode(_fixture(name)) as Map<String, dynamic>;

/// Accept both wrapped API responses and a raw data object fixture.
EdgeInfoData _node(String name) {
  final Map<String, dynamic> json = _json(name);
  final dynamic data = json['data'];
  return EdgeInfoData.fromJson(
    data is Map<String, dynamic> ? data : json,
  );
}

/// 真实样本（BV1GbNd6bEj2 edge 1，底部选项 + 5 个隐藏变量）。
void main() {
  group('models: 真实样本', () {
    test('start_bottom.json 解析', () {
      final EdgeInfoData data = _node('start_bottom.json');
      expect(data.edgeId, 1);
      expect(data.title, '开始测试');
      expect(data.isLeaf, isFalse);
      expect(data.currentCid, 40040008614);

      final Question q = data.edges!.questions!.single;
      expect(q.type, Question.typeBottom);
      expect(q.isBottomType, isTrue);
      expect(q.isAutoType, isFalse);
      expect(q.isHotspotType, isFalse);
      expect(q.pauseVideo, isTrue);
      expect(q.startTimeR, 300);
      expect(q.duration, -1);
      expect(q.isTimed, isFalse);
      expect(q.countdown, isNull);

      final Choice choice = q.choices!.single;
      expect(choice.id, 47007148);
      expect(choice.cid, 40040006182);
      expect(choice.option, 'A 点击开始');
      expect(choice.isDefault, isTrue);
      expect(choice.isHidden, isFalse);
      expect(choice.condition, '');
      expect(choice.nativeAction, '');
      expect(choice.platformAction, 'JUMP 47007148 40040006182');

      expect(data.hiddenVars, isNotEmpty);
      final HiddenVar random = data.hiddenVars!.singleWhere(
        (HiddenVar v) => v.isRandom,
      );
      expect(random.key, r'$ZsVIeVo8M7d');
      expect(random.type, HiddenVar.typeRandom);
    });

    test('auto_node.json 解析（type=0 自动节点）', () {
      final EdgeInfoData data = _node('auto_node.json');
      expect(data.edgeId, 47007157);
      final Question q = data.edges!.questions!.single;
      expect(q.type, Question.typeNone);
      expect(q.isAutoType, isTrue);
      expect(q.pauseVideo, isFalse);
      // 自动节点没有 start_time_r（服务端不下发）
      expect(q.startTimeR, isNull);
      expect(q.choices!.single.id, 47007161);
      expect(q.choices!.single.cid, 40040006274);
      expect(data.preload!.video!.single.cid, 40040006274);
    });

    test('home_hotspot.json 保留 type=2 的四个像素坐标选项', () {
      final EdgeInfoData data = _node('home_hotspot.json');
      expect(data.edgeId, 45728410);
      expect(data.edges!.dimension!.displayWidth, 854);
      expect(data.edges!.dimension!.displayHeight, 480);

      final Question q = data.edges!.questions!.single;
      expect(q.type, Question.typeHotspot);
      expect(q.choices, hasLength(4));
      expect(
        q.choices!.map((Choice choice) => choice.option).toList(),
        <String>['A 检查收音机', 'B 检查保险箱', 'C 出门', 'D 回去睡下'],
      );
      expect(
        q.choices!.map((Choice choice) => <double?>[choice.x, choice.y]),
        <List<double?>>[
          <double?>[41, 206],
          <double?>[534, 224],
          <double?>[630, 52],
          <double?>[203, 342],
        ],
      );
      expect(
        q.choices!.every((Choice choice) => choice.condition!.isEmpty),
        isTrue,
      );
    });

    test('doc_start.json（文档样本）解析', () {
      final EdgeInfoData data = _node('doc_start.json');
      expect(data.edgeId, 1);
      expect(data.isLeaf, isFalse);
      final Choice c = data.edges!.questions!.single.choices!.single;
      expect(
        c.option,
        'A <你现在的身份是萌新>  开始循环！',
      );
      final HiddenVar loop = data.hiddenVars!.singleWhere(
        (HiddenVar v) => v.name == '循环编号',
      );
      expect(loop.value, 1);
      expect(loop.key, r'$lMQqQ994Sk');
      expect(loop.id, 'v-lMQqQ994Sk');
      expect(loop.isRandom, isFalse);
    });
  });

  group('models: 缺失/异常字段', () {
    test('空 data / 非 Map', () {
      expect(EdgeInfoData.fromJson(null).edgeId, isNull);
      expect(EdgeInfoData.fromJson('x').edges, isNull);
      expect(EdgeInfoData.fromJson(<String, dynamic>{}).isLeaf, isFalse);
    });

    test('数值以字符串/小数下发', () {
      final EdgeInfoData data = EdgeInfoData.fromJson(<String, dynamic>{
        'edge_id': '47007157',
        'is_leaf': 1,
        'no_backtracking': '1',
        'story_list': <dynamic>[
          <String, dynamic>{'cid': 123.0, 'is_current': 1},
        ],
      });
      expect(data.edgeId, 47007157);
      expect(data.isLeaf, isTrue);
      // no_backtracking 以字符串下发：无法按 num 判定，保持 false
      expect(data.noBacktracking, isFalse);
      expect(data.currentCid, 123);
    });

    test('hidden_vars 类型混杂：int/double/字符串/null 都得到 double', () {
      final EdgeInfoData data = EdgeInfoData.fromJson(<String, dynamic>{
        'edge_id': 1,
        'hidden_vars': <dynamic>[
          <String, dynamic>{'id_v2': r'$a', 'value': 3, 'type': 1},
          <String, dynamic>{'id_v2': r'$b', 'value': 2.5, 'type': 1},
          <String, dynamic>{'id_v2': r'$c', 'value': '4.00', 'type': 2},
          <String, dynamic>{'id_v2': r'$d', 'value': null, 'type': 1},
          <String, dynamic>{'id_v2': r'$e'},
          'bad element',
          null,
        ],
      });
      final List<HiddenVar> vars = data.hiddenVars!;
      expect(vars.length, 5);
      expect(vars[0].value, 3.0);
      expect(vars[1].value, 2.5);
      expect(vars[2].value, 4.0);
      expect(vars[3].value, isNull);
      expect(vars[4].value, isNull);
      expect(vars[2].isRandom, isTrue);
    });

    test('choices 中个别坏元素不影响整组', () {
      final Question q = Question.fromJson(<String, dynamic>{
        'id': 1,
        'type': 1,
        'duration': -1,
        'choices': <dynamic>[
          <String, dynamic>{'id': 10, 'cid': 11, 'option': 'A'},
          'bad',
          null,
          <String, dynamic>{'id': '12', 'cid': '13', 'option': 'B'},
        ],
      });
      expect(q.choices!.length, 2);
      expect(q.choices!.last.id, 12);
      expect(q.choices!.last.cid, 13);
    });

    test('duration>0 → isTimed / countdown', () {
      final Question q = Question.fromJson(<String, dynamic>{
        'type': 1,
        'duration': 10000,
        'fade_in_time': 500,
        'fade_out_time': 300,
      });
      expect(q.isTimed, isTrue);
      expect(q.countdown, const Duration(seconds: 10));
      expect(q.fadeIn, const Duration(milliseconds: 500));
      expect(q.fadeOut, const Duration(milliseconds: 300));
    });

    test('缺 edges/questions → 视为叶子', () {
      final EdgeInfoData data = EdgeInfoData.fromJson(<String, dynamic>{
        'edge_id': 9,
        'is_leaf': 1,
      });
      expect(data.edges, isNull);
      expect(data.isLeaf, isTrue);
      expect(data.currentCid, isNull);
    });
  });
}
