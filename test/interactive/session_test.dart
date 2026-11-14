import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/choice.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/data.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/edges.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/hidden_var.dart';
import 'package:PiliPlus/pages/video/interactive/interactive_session.dart';
import 'package:flutter_test/flutter_test.dart';

EdgeInfoData _node({
  int? edgeId = 1,
  bool isLeaf = false,
  int? type = 1,
  List<Choice>? choices,
  List<HiddenVar>? hiddenVars,
}) => EdgeInfoData(
  edgeId: edgeId,
  isLeaf: isLeaf,
  edges: Edges.fromJson(<String, dynamic>{
    'questions': <dynamic>[
      <String, dynamic>{
        'id': 0,
        'type': type,
        'duration': -1,
        'pause_video': 1,
        'choices':
            choices
                ?.map(
                  (Choice c) => <String, dynamic>{
                    'id': c.id,
                    'cid': c.cid,
                    'option': c.option,
                    'condition': c.condition,
                    'native_action': c.nativeAction,
                    'is_default': c.isDefault ? 1 : 0,
                    'is_hidden': c.isHidden ? 1 : 0,
                  },
                )
                .toList() ??
            <dynamic>[],
      },
    ],
  }),
  hiddenVars: hiddenVars,
);
void main() {
  group('session: 变量合并', () {
    test('首次合并：采用服务端值', () {
      final InteractiveSession session = InteractiveSession()
        ..mergeHiddenVars(<HiddenVar>[
          HiddenVar(
            id: 'v-a',
            idV2: r'$a',
            value: 5,
            type: HiddenVar.typeNormal,
          ),
        ]);
      expect(session.vars[r'$a'], 5);
      // 兼容旧 id
      expect(session.vars['v-a'], 5);
    });

    test('随机变量只掷一次：后续节点不覆盖', () {
      final InteractiveSession session = InteractiveSession()
        ..mergeHiddenVars(<HiddenVar>[
          HiddenVar(
            id: 'v-r',
            idV2: r'$r',
            value: 8,
            type: HiddenVar.typeRandom,
          ),
        ]);
      expect(session.vars[r'$r'], 8);
      // 服务端每个请求都会重掷（真实样本观察到 8/64/96/79...）
      session.mergeHiddenVars(<HiddenVar>[
        HiddenVar(
          id: 'v-r',
          idV2: r'$r',
          value: 96,
          type: HiddenVar.typeRandom,
        ),
      ]);
      expect(session.vars[r'$r'], 8);
    });

    test('skip_overwrite=1 保留会话值', () {
      final InteractiveSession session = InteractiveSession()
        ..mergeHiddenVars(<HiddenVar>[
          HiddenVar(id: 'v-s', idV2: r'$s', value: 1, skipOverwrite: true),
        ])
        ..vars[r'$s'] = 7
        ..mergeHiddenVars(<HiddenVar>[
          HiddenVar(id: 'v-s', idV2: r'$s', value: 2, skipOverwrite: true),
        ]);
      expect(session.vars[r'$s'], 7);
    });

    test('被 native_action 写过的变量不被服务端覆盖', () {
      final InteractiveSession session = InteractiveSession()
        ..mergeHiddenVars(<HiddenVar>[
          HiddenVar(
            id: 'v-n',
            idV2: r'$n',
            value: 0,
            type: HiddenVar.typeNormal,
          ),
        ]);
      final Map<String, double>? next = session.tryApplyNativeAction(
        r'$n=$n+3.00',
      );
      expect(next, isNotNull);
      session.commitVars(next!, action: r'$n=$n+3.00');
      expect(session.vars[r'$n'], 3);
      // 服务端（type=1）恒返回 0，不能覆盖本地累加结果
      session.mergeHiddenVars(<HiddenVar>[
        HiddenVar(id: 'v-n', idV2: r'$n', value: 0, type: HiddenVar.typeNormal),
      ]);
      expect(session.vars[r'$n'], 3);
    });

    test('未被改写的普通变量采用服务端值', () {
      final InteractiveSession session = InteractiveSession()
        ..mergeHiddenVars(<HiddenVar>[
          HiddenVar(
            id: 'v-p',
            idV2: r'$p',
            value: 1,
            type: HiddenVar.typeNormal,
          ),
        ])
        ..mergeHiddenVars(<HiddenVar>[
          HiddenVar(
            id: 'v-p',
            idV2: r'$p',
            value: 9,
            type: HiddenVar.typeNormal,
          ),
        ]);
      expect(session.vars[r'$p'], 9);
    });

    test('value 缺失 → 0；key 为空跳过', () {
      final InteractiveSession session = InteractiveSession()
        ..mergeHiddenVars(<HiddenVar>[
          HiddenVar(idV2: r'$x'),
          HiddenVar(id: null, idV2: null),
        ]);
      expect(session.vars[r'$x'], 0);
      expect(session.vars.length, 1);
    });
  });

  group('session: 快照与回溯', () {
    test('snapshot/restore 还原变量并清理 touched', () {
      final InteractiveSession session = InteractiveSession()
        ..mergeHiddenVars(<HiddenVar>[
          HiddenVar(idV2: r'$a', value: 1, type: HiddenVar.typeNormal),
        ]);
      final Map<String, double> snap = session.snapshot();
      final Map<String, double>? next = session.tryApplyNativeAction(
        r'$a=$a+5.00',
      );
      session.commitVars(next!, action: r'$a=$a+5.00');
      expect(session.vars[r'$a'], 6);
      session.restoreSnapshot(snap);
      expect(session.vars[r'$a'], 1);
      // touched 被清空：服务端值可再次覆盖
      session.mergeHiddenVars(<HiddenVar>[
        HiddenVar(idV2: r'$a', value: 4, type: HiddenVar.typeNormal),
      ]);
      expect(session.vars[r'$a'], 4);
    });

    test('snapshot 是拷贝', () {
      final InteractiveSession session = InteractiveSession();
      session.vars[r'$a'] = 1;
      final Map<String, double> snap = session.snapshot();
      session.vars[r'$a'] = 2;
      expect(snap[r'$a'], 1);
    });
  });

  group('session: 条件过滤', () {
    test('空条件视为可用', () {
      final InteractiveSession session = InteractiveSession();
      expect(session.isChoiceAvailable(Choice(condition: '')), isTrue);
      expect(session.isChoiceAvailable(Choice(condition: '  ')), isTrue);
      expect(session.isChoiceAvailable(Choice()), isTrue);
    });

    test('条件成立/不成立', () {
      final InteractiveSession session = InteractiveSession();
      session.vars[r'$hp'] = 30;
      expect(
        session.isChoiceAvailable(Choice(condition: r'$hp>=10.00')),
        isTrue,
      );
      expect(
        session.isChoiceAvailable(Choice(condition: r'$hp>=50.00')),
        isFalse,
      );
    });

    test('条件求值失败 → 不可用（保守）', () {
      final InteractiveSession session = InteractiveSession();
      expect(
        session.isChoiceAvailable(Choice(condition: r'$missing>=1.00')),
        isFalse,
      );
      expect(session.isChoiceAvailable(Choice(condition: '1 +')), isFalse);
      expect(session.debugLog, isNotEmpty);
    });
  });

  group('session: native_action', () {
    test('空 action 返回当前快照', () {
      final InteractiveSession session = InteractiveSession();
      session.vars[r'$a'] = 2;
      expect(session.tryApplyNativeAction(null), <String, double>{r'$a': 2});
      expect(session.tryApplyNativeAction('  '), <String, double>{r'$a': 2});
    });

    test('多语句执行且在副本上执行', () {
      final InteractiveSession session = InteractiveSession();
      session.vars[r'$a'] = 1;
      session.vars[r'$b'] = 2;
      final Map<String, double>? next = session.tryApplyNativeAction(
        r'$a=$a+1.00;$b=$b-2.00',
      );
      expect(next![r'$a'], 2);
      expect(next[r'$b'], 0);
      // 未提交前会话不变
      expect(session.vars[r'$a'], 1);
    });

    test('执行失败返回 null 且不改会话', () {
      final InteractiveSession session = InteractiveSession();
      session.vars[r'$a'] = 1;
      expect(session.tryApplyNativeAction(r'$a=$a+1.00;$zz=$nope+1'), isNull);
      expect(session.vars[r'$a'], 1);
      expect(session.debugLog, isNotEmpty);
    });
  });

  group('session: planNode', () {
    test('用户节点：可见选项 + 需要选择', () {
      final InteractiveSession session = InteractiveSession();
      final NodePlan plan = planNode(
        _node(
          choices: <Choice>[
            Choice(id: 10, cid: 11, option: 'A', isDefault: true),
            Choice(id: 12, cid: 13, option: 'B'),
          ],
        ),
        session,
      );
      expect(plan.needUserChoice, isTrue);
      expect(plan.visibleChoices.length, 2);
      expect(plan.autoChoice, isNull);
      expect(plan.isStalled, isFalse);
      expect(plan.defaultChoice?.id, 10);
    });

    test('条件过滤：只保留成立且未隐藏的选项', () {
      final InteractiveSession session = InteractiveSession();
      session.vars[r'$k'] = 1;
      final NodePlan plan = planNode(
        _node(
          choices: <Choice>[
            Choice(id: 1, cid: 1, option: 'A', condition: r'$k==1.00'),
            Choice(id: 2, cid: 2, option: 'B', condition: r'$k==2.00'),
            Choice(id: 3, cid: 3, option: 'C', isHidden: true),
          ],
        ),
        session,
      );
      expect(plan.visibleChoices.single.id, 1);
    });

    test('自动节点（type=0）：取首个可用项', () {
      final InteractiveSession session = InteractiveSession();
      final NodePlan plan = planNode(
        _node(
          type: 0,
          choices: <Choice>[
            // 条件为空 → 可用，自动节点按服务端顺序取首个可用项
            Choice(id: 1, cid: 1, option: 'A'),
            Choice(id: 2, cid: 2, option: 'B'),
          ],
        ),
        session,
      );
      expect(plan.needUserChoice, isFalse);
      // 首个可用项（条件为空 → 可用）
      expect(plan.autoChoice?.id, 1);
      expect(plan.visibleChoices, isEmpty);
    });

    test('自动节点无可用项 → 回退 is_default', () {
      final InteractiveSession session = InteractiveSession();
      session.vars[r'$x'] = 1;
      final NodePlan plan = planNode(
        _node(
          type: 0,
          choices: <Choice>[
            Choice(id: 1, cid: 1, option: 'A', condition: r'$x==2.00'),
            Choice(id: 2, cid: 2, option: 'B', isDefault: true),
          ],
        ),
        session,
      );
      expect(plan.autoChoice?.id, 2);
      expect(plan.isStalled, isFalse);
    });

    test('自动节点无可用项且无默认项 → stall', () {
      final InteractiveSession session = InteractiveSession();
      session.vars[r'$x'] = 1;
      final NodePlan plan = planNode(
        _node(
          type: 0,
          choices: <Choice>[
            Choice(id: 1, cid: 1, option: 'A', condition: r'$x==2.00'),
          ],
        ),
        session,
      );
      expect(plan.isStalled, isTrue);
      expect(plan.autoChoice, isNull);
    });

    test('用户节点全部不可见 → 自动跳过', () {
      final InteractiveSession session = InteractiveSession();
      session.vars[r'$x'] = 1;
      final NodePlan plan = planNode(
        _node(
          choices: <Choice>[
            Choice(id: 1, cid: 1, option: 'A', condition: r'$x==2.00'),
            Choice(
              id: 2,
              cid: 2,
              option: 'B',
              condition: r'$x==3.00',
              isDefault: true,
            ),
          ],
        ),
        session,
      );
      expect(plan.needUserChoice, isFalse);
      expect(plan.autoChoice?.id, 2);
    });

    test('无问题/无选项 → 非交互计划（叶子）', () {
      final InteractiveSession session = InteractiveSession();
      final NodePlan noChoice = planNode(
        _node(choices: <Choice>[]),
        session,
      );
      expect(noChoice.needUserChoice, isFalse);
      expect(noChoice.autoChoice, isNull);
      expect(noChoice.isStalled, isFalse);
    });
  });
}
