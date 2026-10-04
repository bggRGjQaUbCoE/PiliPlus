import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/choice.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/data.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/hidden_var.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/question.dart';
import 'package:PiliPlus/pages/video/interactive/interactive_expression.dart';
import 'package:flutter/foundation.dart';

/// 互动视频会话引擎：变量生命周期、条件过滤、动作执行、自动分支、快照回溯。
///
/// 纯领域层，不依赖 Flutter/GetX/播放器，可单测。
class InteractiveSession {
  /// 变量环境（key 为 id_v2，含 `$` 前缀；兼容 `id`）。
  final ExpressionEnv vars = <String, double>{};

  /// 变量元数据（key 同上）。
  final Map<String, HiddenVar> varMeta = <String, HiddenVar>{};

  /// 随机变量是否已初始化（避免重复掷骰）。
  final Set<String> _randomInit = <String>{};

  /// 已被 native_action 写过的变量。
  final Set<String> _touched = <String>{};

  /// 调试日志（脱敏表达式诊断）。
  final List<String> debugLog = <String>[];

  InteractiveSession();

  /// 从 hidden_vars 初始化/合并会话变量。
  ///
  /// 合并策略（见任务要求）：
  /// - 新变量：直接加入；
  /// - 随机变量（type=2）：已初始化则保留会话值（不重掷）；
  /// - skip_overwrite=1：保留会话值；
  /// - 其余：采用服务端值（服务端持久化了作者设计的累积进度）。
  void mergeHiddenVars(List<HiddenVar>? hiddenVars) {
    if (hiddenVars == null) {
      return;
    }
    for (final HiddenVar hv in hiddenVars) {
      final String key = hv.key;
      if (key.isEmpty) {
        continue;
      }
      varMeta[key] = hv;
      // 兼容：若 id 与 id_v2 不同，把 id 也指向同一值（表达式可能引用旧 id）。
      final String? legacy = hv.id;
      final bool hasLegacy = legacy != null && legacy.isNotEmpty;
      final bool exists = vars.containsKey(key);
      if (!exists) {
        vars[key] = hv.value ?? 0;
        if (hv.isRandom) {
          _randomInit.add(key);
        }
        if (hasLegacy) {
          vars[legacy] = vars[key]!;
        }
        continue;
      }
      // 已存在：决定是否覆盖
      final bool keepSession =
          hv.isRandom || hv.skipOverwrite || _touched.contains(key);
      if (!keepSession) {
        vars[key] = hv.value ?? vars[key] ?? 0;
        if (hasLegacy) {
          vars[legacy] = vars[key]!;
        }
      }
    }
  }

  /// 变量快照（用于回溯与循环保护签名）。
  Map<String, double> snapshot() => Map<String, double>.of(vars);

  /// 恢复变量快照（回溯时还原）。
  void restoreSnapshot(Map<String, double> snap) {
    vars
      ..clear()
      ..addAll(snap);
    _touched.clear();
  }

  void _log(String msg) {
    debugLog.add(msg);
    if (debugLog.length > 200) {
      debugLog.removeAt(0);
    }
    if (kDebugMode) {
      debugPrint('[InteractiveSession] $msg');
    }
  }

  /// 用当前变量过滤 choice：返回是否可用（可见/可自动跳转）。
  ///
  /// - condition 为空 → 可用；
  /// - condition 求值失败或为 0 → 不可用（保守：不误展示、不误跳）。
  bool isChoiceAvailable(Choice choice) {
    final String cond = choice.condition ?? '';
    if (cond.trim().isEmpty) {
      return true;
    }
    final List<ExpressionFailure> log = <ExpressionFailure>[];
    final (bool ok, ExpressionFailure? err) = evalCondition(
      cond,
      vars,
      log: log,
    );
    if (err != null) {
      _log('condition 失败: $err');
      return false;
    }
    return ok;
  }

  /// 在副本上试执行 native_action，成功返回提交后的变量表，失败返回 null。
  Map<String, double>? tryApplyNativeAction(String? action) {
    final String src = (action ?? '').trim();
    if (src.isEmpty) {
      return snapshot();
    }
    final Map<String, double> copy = snapshot();
    final List<ExpressionFailure> log = <ExpressionFailure>[];
    final (Object result, ExpressionFailure? err) = evalAction(
      src,
      copy,
      log: log,
    );
    if (err != null) {
      _log('native_action 失败: $err');
      return null;
    }
    return copy;
  }

  /// 提交变量表（tryApplyNativeAction 成功后调用），并记录 touched。
  void commitVars(Map<String, double> next, {String? action}) {
    vars
      ..clear()
      ..addAll(next);
    if (action != null && action.trim().isNotEmpty) {
      // 把 action 中出现的赋值目标标记为 touched
      for (final String name in _assignmentTargets(action)) {
        _touched
          ..add(name)
          ..add(name.startsWith(r'$') ? name.substring(1) : '\$$name');
      }
    }
  }

  /// 简易扫描赋值目标（无需完整 parse，用于 touched 标记）。
  static Iterable<String> _assignmentTargets(String action) sync* {
    final RegExp pattern = RegExp(r'(\$?[A-Za-z0-9_\u0080-\uFFFF]+)\s*=');
    for (final RegExpMatch m in pattern.allMatches(action)) {
      yield m.group(1)!;
    }
  }

  /// 同步兼容变量别名（id ↔ id_v2）。
  void syncAliases() {
    for (final HiddenVar hv in varMeta.values) {
      final String? legacy = hv.id;
      final String key = hv.key;
      if (legacy == null || legacy.isEmpty || !vars.containsKey(key)) {
        continue;
      }
      if (vars.containsKey(legacy) && vars[legacy] != vars[key]) {
        vars[legacy] = vars[key]!;
      }
    }
  }
}

/// 为当前节点计算 UI/自动跳转计划。
class NodePlan {
  /// 当前节点。
  final EdgeInfoData node;

  /// 当前问题（无问题则为 null）。
  final Question? question;

  /// 问题的可见选项（用户可能看到的）。
  final List<Choice> visibleChoices;

  /// 自动跳转目标（question type=0 或无可 见选项但有可自动项）。
  final Choice? autoChoice;

  /// 是否需要用户选择。
  final bool needUserChoice;

  /// 无法推进的原因（诊断）。
  final String? stallReason;

  const NodePlan({
    required this.node,
    this.question,
    this.visibleChoices = const <Choice>[],
    this.autoChoice,
    this.needUserChoice = false,
    this.stallReason,
  });

  bool get isStalled => stallReason != null;

  /// 倒计时结束/自动节点提交的默认项：优先 is_default，其次首个可见项。
  Choice? get defaultChoice {
    for (final Choice c in visibleChoices) {
      if (c.isDefault) {
        return c;
      }
    }
    return visibleChoices.isEmpty ? null : visibleChoices.first;
  }
}

/// 节点规划器：把节点 + 会话状态 → NodePlan。
NodePlan planNode(EdgeInfoData node, InteractiveSession session) {
  final List<Choice> visible = <Choice>[];
  Choice? autoChoice;
  String? stallReason;

  final List<Question>? questions = node.edges?.questions;
  final Question? question = (questions != null && questions.isNotEmpty)
      ? questions.first
      : null;
  final List<Choice>? choices = question?.choices;

  if (question == null || choices == null || choices.isEmpty) {
    // 叶子节点或无问题
    return NodePlan(node: node, question: question, needUserChoice: false);
  }

  // 过滤可用选项（condition 求值）
  final List<Choice> available = <Choice>[];
  for (final Choice c in choices) {
    if (session.isChoiceAvailable(c)) {
      available.add(c);
    }
  }

  final bool isAutoType = question.isAutoType;
  // 可见选项：非隐藏且可用
  for (final Choice c in available) {
    if (!c.isHidden) {
      visible.add(c);
    }
  }

  if (isAutoType) {
    // 自动节点：按服务端顺序取第一个可用项；无可行时回退 is_default
    if (available.isNotEmpty) {
      autoChoice = available.first;
    } else {
      autoChoice = _defaultOf(choices);
      if (autoChoice == null) {
        stallReason = '自动节点无可用分支且无默认项';
      }
    }
    return NodePlan(
      node: node,
      question: question,
      visibleChoices: const <Choice>[],
      autoChoice: autoChoice,
      needUserChoice: false,
      stallReason: stallReason,
    );
  }

  // 用户节点
  if (visible.isEmpty) {
    // 全部隐藏/条件不成立：官方行为是自动跳过该问题。
    // 采用与自动节点一致的推进策略。
    if (available.isNotEmpty) {
      autoChoice = available.first;
    } else {
      autoChoice = _defaultOf(choices);
      if (autoChoice == null) {
        stallReason = '问题无可用选项且无默认项';
      }
    }
    return NodePlan(
      node: node,
      question: question,
      visibleChoices: const <Choice>[],
      autoChoice: autoChoice,
      needUserChoice: false,
      stallReason: stallReason,
    );
  }

  return NodePlan(
    node: node,
    question: question,
    visibleChoices: visible,
    needUserChoice: true,
  );
}

Choice? _defaultOf(List<Choice> choices) {
  for (final Choice c in choices) {
    if (c.isDefault) {
      return c;
    }
  }
  return null;
}

/// 自动推进深度上限（防坏数据/环图死循环）。
const int kMaxAutoAdvanceDepth = 32;
