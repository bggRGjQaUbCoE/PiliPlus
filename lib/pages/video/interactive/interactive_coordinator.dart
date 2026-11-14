import 'dart:async';

import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/choice.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/data.dart';
import 'package:PiliPlus/models_new/video/video_stein_edgeinfo/story_item.dart';
import 'package:PiliPlus/pages/video/interactive/interactive_session.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// 拉取互动节点的可注入入口（便于测试）。
typedef SteinNodeFetch = Future<(EdgeInfoData?, int, String)> Function(
  String bvid,
  int graphVersion, {
  int? edgeId,
});

/// 互动视频协调器：节点加载、变量推进、播放完成驱动、回溯。
///
/// 时序（关键）：
/// 1. [enterNode] 只负责「取节点 → 合并变量 → 规划」，绝不立刻跳走：
///    每个互动节点本身就是一段视频（自己的 cid），必须先播完；
/// 2. 播放器上报 completion → [onPlaybackCompleted]：
///    - 用户选择节点：展示选项（并按 pause_video 暂停）；
///    - 自动节点（type=0）：推进 [kMaxAutoAdvanceDepth] 内的单步跳转；
///    - 叶子节点：展示结束态。
/// 3. 每次跳转前先在变量副本上执行 native_action，切换分 P 成功后才提交，
///    失败则回滚到点击前的快照（不会出现「变量变了但没跳转」）。
class InteractiveCoordinator {
  InteractiveCoordinator({
    required this.onSwitchPart,
    required this.getBvid,
    required this.getGraphVersion,
    required this.onShowQuestion,
    required this.onHideQuestion,
    this.onPausePlayer,
    required this.fetchNode,
  }) {
    onCountdownEnd = _submitDefault;
  }

  /// 切换分 P（返回是否成功）。
  final Future<bool> Function(int cid, String? title) onSwitchPart;

  /// 当前稿件 bvid。
  final String Function() getBvid;

  /// 当前 graph_version（null 表示非互动视频）。
  final int? Function() getGraphVersion;

  /// 通知 UI 展示互动层。
  final void Function() onShowQuestion;

  /// 通知 UI 隐藏互动层（切换分 P 时用，避免旧选项残留）。
  final void Function() onHideQuestion;

  /// 暂停播放器（pause_video=1 时）。
  final void Function()? onPausePlayer;

  /// 节点拉取实现（必填，便于测试注入与解耦网络层）。
  final SteinNodeFetch fetchNode;

  /// 变量会话。
  InteractiveSession session = InteractiveSession();

  /// 当前节点。
  EdgeInfoData? currentNode;

  /// 当前节点的规划结果。
  NodePlan? currentPlan;

  /// UI 状态。
  final Rx<SteinUiState> uiState = Rx<SteinUiState>(const SteinUiState.idle());

  /// 回溯栈（每个已到达节点一条，UI 可据此渲染「进度回溯」）。
  final RxList<InteractiveCheckpoint> history = <InteractiveCheckpoint>[].obs;

  /// 互动层是否可见。
  ///
  /// `uiState` 在节点拉取完成时就会变成 question/autoWaiting，但选项必须等
  /// **本段视频播放完成**（或失败需要重试）才允许出现，故另设此开关。
  final RxBool overlayVisible = false.obs;

  int _generation = 0;
  bool _switching = false;

  /// 当前分 P 是否已播放完成（决定节点就绪后是否立刻展示/推进）。
  bool _segmentCompleted = false;

  /// 正在进入但尚未成功的 edge_id（失败重试用）。
  int? _pendingEdgeId;

  /// 自动跳转的「选项 + 变量签名」集合，用于环图保护。
  final Set<String> _visitedSigs = <String>{};
  int _autoDepth = 0;

  Timer? _countdownTimer;

  /// 倒计时剩余毫秒（0 表示不倒计时）。
  final RxInt countdownMs = 0.obs;

  /// 倒计时结束回调（默认提交默认项）。
  VoidCallback? onCountdownEnd;

  final RxBool loadFailed = false.obs;
  String? lastError;

  /// 是否允许时间回溯：路径中没有节点声明禁止回溯（no_backtracking），
  /// 且栈里存在上一节点。
  bool get canBacktrack =>
      history.length > 1 &&
      !history.any((InteractiveCheckpoint cp) => cp.noBacktracking);

  int get _nextGen => ++_generation;

  /// 开启一次新的互动会话（换稿 / 重进页面）。
  void initSession() {
    _generation++;
    _stopCountdown();
    session = InteractiveSession();
    currentNode = null;
    currentPlan = null;
    _switching = false;
    _segmentCompleted = false;
    _pendingEdgeId = null;
    _visitedSigs.clear();
    _autoDepth = 0;
    history.clear();
    loadFailed.value = false;
    lastError = null;
    overlayVisible.value = false;
    uiState.value = const SteinUiState.idle();
  }

  void dispose() {
    _generation++;
    _stopCountdown();
    overlayVisible.value = false;
  }

  /// 展示互动层（选项 / 失败重试 / 结束态）。
  void _show() {
    overlayVisible.value = true;
    onShowQuestion();
  }

  /// 隐藏互动层（切换分 P 时用，避免旧选项残留）。
  void _hide() {
    overlayVisible.value = false;
    onHideQuestion();
  }

  Future<(EdgeInfoData?, int, String)> _fetch(
    String bvid,
    int graphVersion, {
    int? edgeId,
  }) {
    return fetchNode(bvid, graphVersion, edgeId: edgeId);
  }

  /// 进入 [edgeId] 对应的节点（null 表示起始节点）。
  ///
  /// [cid] 为刚刚切换到的分P（用于回溯记录）；不传则取节点的 current_cid。
  Future<bool> enterNode(int? edgeId, {int? cid}) async {
    final int? gv = getGraphVersion();
    if (gv == null) {
      return false;
    }
    final int gen = _nextGen;
    _stopCountdown();
    _pendingEdgeId = edgeId;
    uiState.value = const SteinUiState.loading();
    loadFailed.value = false;

    final (EdgeInfoData? data, int code, String msg) = await _fetch(
      getBvid(),
      gv,
      edgeId: edgeId,
    );
    if (gen != _generation) {
      return false;
    }
    if (code != 0 || data == null) {
      _fail('互动节点加载失败(code $code)：$msg');
      return false;
    }
    _pendingEdgeId = null;
    currentNode = data;
    session.mergeHiddenVars(data.hiddenVars);
    final NodePlan plan = planNode(data, session);
    currentPlan = plan;
    if (plan.isStalled) {
      _fail(plan.stallReason!);
      return false;
    }
    _pushCheckpoint(data, cid ?? data.currentCid);
    _applyPlan(data, plan);
    return true;
  }

  /// 按规划结果落状态；若当前分 P 已播完则立即展示/推进。
  void _applyPlan(EdgeInfoData node, NodePlan plan) {
    if (plan.needUserChoice) {
      uiState.value = SteinUiState.question(node: node, plan: plan);
      if (_segmentCompleted) {
        showQuestion();
      }
      return;
    }
    if (plan.autoChoice != null) {
      // 自动节点（type=0）/ 全员不可见节点：等本段视频播完再推进。
      uiState.value = SteinUiState.autoWaiting(node: node, plan: plan);
      if (_segmentCompleted) {
        unawaited(_advanceAuto());
      }
      return;
    }
    if (node.isLeaf) {
      uiState.value = const SteinUiState.leaf();
      if (_segmentCompleted) {
        _show();
      }
      return;
    }
    _fail('互动节点无可用分支');
  }

  void _pushCheckpoint(EdgeInfoData node, int? cid) {
    final List<StoryItem> storyList = node.storyList ?? const <StoryItem>[];
    // 服务端会回传已走过的路径（含封面），用它补齐历史里的缩略图。
    for (int i = 0; i < history.length; i++) {
      final InteractiveCheckpoint old = history[i];
      if (old.cover?.trim().isNotEmpty == true) {
        continue;
      }
      final String? cover =
          _coverOf(storyList, old.cid, old.edgeId) ?? _screenshotCover(old.cid);
      if (cover != null) {
        history[i] = old.copyWith(cover: cover);
      }
    }
    final InteractiveCheckpoint cp = InteractiveCheckpoint(
      edgeId: node.edgeId,
      cid: cid,
      title: node.title,
      cover:
          _coverOf(storyList, cid, node.edgeId) ?? _screenshotCover(cid),
      vars: session.snapshot(),
      noBacktracking: node.noBacktracking,
    );
    if (history.isNotEmpty && history.last.edgeId == cp.edgeId) {
      history[history.length - 1] = cp;
    } else {
      history.add(cp);
    }
  }

  /// 从 story_list 中找出对应节点的封面。
  static String? _coverOf(List<StoryItem> storyList, int? cid, int? edgeId) {
    for (final StoryItem item in storyList) {
      if (cid != null && item.cid == cid) {
        final String? cover = _nonEmptyCover(item.cover);
        if (cover != null) {
          return cover;
        }
      }
    }
    for (final StoryItem item in storyList) {
      if (edgeId != null && item.edgeId == edgeId) {
        final String? cover = _nonEmptyCover(item.cover);
        if (cover != null) {
          return cover;
        }
      }
    }
    // A singleton story_list usually describes the root path entry. Do not
    // reuse its cover for an unrelated branch node.
    return null;
  }

  static String? _nonEmptyCover(String? cover) {
    return cover?.trim().isNotEmpty == true ? cover : null;
  }

  /// 分P的服务端截图地址。
  ///
  /// 服务端的 `story_list` 常常只回传根节点（分支节点的 cover 为空），
  /// 但每个分P的截图地址是固定的：`bfs/steins-gate/{cid}_screenshot.jpg`
  /// （根节点 story_list 里的 cover 正是这个地址）。所以分支节点用 cid 拼出来；
  /// 若该分P没有截图，请求会 404，由缩略图的错误占位兜底。
  static String? _screenshotCover(int? cid) {
    if (cid == null) {
      return null;
    }
    return 'https://i0.hdslb.com/bfs/steins-gate/${cid}_screenshot.jpg';
  }

  /// 播放器上报「本段播放完成」。
  ///
  /// 返回 true 表示已被互动逻辑接管（调用方应跳过普通连播逻辑）。
  bool onPlaybackCompleted() {
    if (getGraphVersion() == null) {
      return false;
    }
    _segmentCompleted = true;
    switch (uiState.value) {
      case SteinQuestion():
        showQuestion();
      case SteinAutoWaiting():
        unawaited(_advanceAuto());
      case SteinLeaf():
      case SteinError():
        _show();
      case SteinIdle():
      case SteinLoading():
        // 节点仍在加载：先抑制普通连播，等加载完成后由 _applyPlan 兜底。
        break;
    }
    return true;
  }

  /// 展示当前问题的选项层。
  void showQuestion() {
    final SteinUiState state = uiState.value;
    if (state is SteinQuestion) {
      uiState.refresh();
      if (state.plan.question?.pauseVideo ?? true) {
        onPausePlayer?.call();
      }
      _startCountdownIfNeeded(state.plan);
    }
    _show();
  }

  /// 自动节点单步推进（仅由播放完成驱动，避免连跳吞掉节点视频）。
  Future<void> _advanceAuto() async {
    if (_switching) {
      return;
    }
    final Choice? auto = currentPlan?.autoChoice;
    if (auto == null) {
      _fail('自动节点无可用分支');
      return;
    }
    if (_autoDepth >= kMaxAutoAdvanceDepth) {
      _fail('自动跳转超过 $kMaxAutoAdvanceDepth 层，已停止（疑似环图）');
      return;
    }
    final Map<String, double>? nextVars = session.tryApplyNativeAction(
      auto.nativeAction,
    );
    if (nextVars == null) {
      _fail('自动节点变量动作执行失败');
      return;
    }
    final String sig = '${auto.id}|${_sigVars(nextVars)}';
    if (!_visitedSigs.add(sig)) {
      _fail('检测到重复的自动分支，已停止（疑似环图）');
      return;
    }
    final int? cid = auto.cid;
    if (cid == null) {
      _fail('自动分支缺少 cid');
      return;
    }

    _switching = true;
    _stopCountdown();
    _hide();
    final bool ok = await onSwitchPart(cid, auto.option ?? auto.title);
    _switching = false;
    if (!ok) {
      // 变量尚未提交，无需回滚。
      _fail('切换分P失败(cid $cid)');
      _show();
      return;
    }
    session.commitVars(nextVars, action: auto.nativeAction);
    _autoDepth++;
    _segmentCompleted = false;
    await enterNode(auto.id, cid: cid);
  }

  /// 用户选择某个选项。
  Future<void> selectChoice(Choice choice) async {
    if (_switching) {
      return;
    }
    _switching = true;
    _stopCountdown();
    // 二次校验：节点数据可能在展示期间被刷新。
    if (!session.isChoiceAvailable(choice)) {
      _switching = false;
      _fail('该选项当前不可用');
      _show();
      return;
    }
    final int? cid = choice.cid;
    if (cid == null) {
      _switching = false;
      _fail('选项缺少 cid');
      _show();
      return;
    }
    final Map<String, double> before = session.snapshot();
    final Map<String, double>? nextVars = session.tryApplyNativeAction(
      choice.nativeAction,
    );
    if (nextVars == null) {
      _switching = false;
      _fail('选项变量动作执行失败');
      _show();
      return;
    }

    _hide();
    final bool ok = await onSwitchPart(cid, choice.option ?? choice.title);
    _switching = false;
    if (!ok) {
      session.restoreSnapshot(before);
      _fail('切换分P失败(cid $cid)');
      _show();
      return;
    }
    session.commitVars(nextVars, action: choice.nativeAction);
    // 用户主动选择后开启新的路径：清空自动跳转的环图记录。
    _visitedSigs.clear();
    _autoDepth = 0;
    _segmentCompleted = false;
    await enterNode(choice.id, cid: cid);
  }

  /// 时间回溯到上一个节点（issue #2419）。
  Future<void> backtrack() async {
    if (!canBacktrack) {
      return;
    }
    await backtrackTo(history.length - 2);
  }

  /// 时间回溯到回溯栈中的第 [index] 个节点（进度回溯面板用）。
  ///
  /// 变量恢复到该节点的快照，栈中其后的节点被丢弃。
  Future<void> backtrackTo(int index) async {
    if (_switching ||
        !canBacktrack ||
        index < 0 ||
        index >= history.length - 1) {
      return;
    }
    final InteractiveCheckpoint cp = history[index];
    _switching = true;
    _stopCountdown();
    _hide();
    session.restoreSnapshot(cp.vars);
    history.removeRange(index + 1, history.length);
    _visitedSigs.clear();
    _autoDepth = 0;
    _segmentCompleted = false;

    final int? cid = cp.cid;
    if (cid != null) {
      final bool ok = await onSwitchPart(cid, cp.title);
      _switching = false;
      if (!ok) {
        _fail('回溯切换分P失败(cid $cid)');
        return;
      }
    } else {
      _switching = false;
    }
    await enterNode(cp.edgeId, cid: cid);
  }

  /// 从头重新体验：回到首个节点并清空会话（叶子节点「重新体验」入口）。
  Future<void> restart() async {
    if (_switching) {
      return;
    }
    final int? startEdgeId = history.firstOrNull?.edgeId;
    final int? startCid = history.firstOrNull?.cid;
    _switching = true;
    _stopCountdown();
    _hide();
    initSession();
    _switching = true;
    if (startCid != null) {
      final bool ok = await onSwitchPart(startCid, null);
      _switching = false;
      if (!ok) {
        _fail('重播切换分P失败(cid $startCid)');
        return;
      }
    } else {
      _switching = false;
    }
    await enterNode(startEdgeId, cid: startCid);
  }

  /// 重新加载当前（或目标）节点。
  Future<void> retry() async {
    await enterNode(_pendingEdgeId ?? currentNode?.edgeId);
  }

  void _fail(String message) {
    lastError = message;
    loadFailed.value = true;
    uiState.value = SteinUiState.error(message);
    if (kDebugMode) {
      debugPrint('[InteractiveCoordinator] $message');
    }
    _show();
  }

  void _startCountdownIfNeeded(NodePlan plan) {
    _stopCountdown();
    final Duration? countdown = plan.question?.countdown;
    if (countdown == null) {
      countdownMs.value = 0;
      return;
    }
    countdownMs.value = countdown.inMilliseconds;
    _countdownTimer = Timer.periodic(const Duration(milliseconds: 100), (
      Timer timer,
    ) {
      countdownMs.value -= 100;
      if (countdownMs.value <= 0) {
        countdownMs.value = 0;
        _stopCountdown();
        onCountdownEnd?.call();
      }
    });
  }

  /// 倒计时结束：提交默认项；无合法默认项则保持等待（不误跳）。
  void _submitDefault() {
    final SteinUiState state = uiState.value;
    if (state is! SteinQuestion) {
      return;
    }
    final Choice? fallback = state.plan.defaultChoice;
    if (fallback == null) {
      if (kDebugMode) {
        debugPrint('[InteractiveCoordinator] 倒计时结束但无默认项，保持等待');
      }
      return;
    }
    unawaited(selectChoice(fallback));
  }

  void _stopCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  /// 变量签名（有序），用于环图检测。
  static String _sigVars(Map<String, double> vars) {
    final List<String> keys = vars.keys.toList()..sort();
    return keys.map((String k) => '$k=${vars[k]}').join('&');
  }
}

/// 回溯检查点。
class InteractiveCheckpoint {
  final int? edgeId;
  final int? cid;
  final String? title;

  /// 节点封面（进度回溯缩略图，可能为 null）。
  final String? cover;
  final Map<String, double> vars;

  /// 该节点是否声明禁止回溯（no_backtracking）。
  final bool noBacktracking;

  const InteractiveCheckpoint({
    this.edgeId,
    this.cid,
    this.title,
    this.cover,
    required this.vars,
    this.noBacktracking = false,
  });

  InteractiveCheckpoint copyWith({String? cover}) => InteractiveCheckpoint(
    edgeId: edgeId,
    cid: cid,
    title: title,
    cover: cover ?? this.cover,
    vars: vars,
    noBacktracking: noBacktracking,
  );
}

/// 互动层的 UI 状态。
sealed class SteinUiState {
  const SteinUiState();

  const factory SteinUiState.idle() = SteinIdle;

  const factory SteinUiState.loading() = SteinLoading;

  /// 用户选择节点（已就绪，等分 P 播完展示）。
  const factory SteinUiState.question({
    required EdgeInfoData node,
    required NodePlan plan,
  }) = SteinQuestion;

  /// 自动节点（已就绪，等分 P 播完推进）。
  const factory SteinUiState.autoWaiting({
    required EdgeInfoData node,
    required NodePlan plan,
  }) = SteinAutoWaiting;

  /// 叶子/结局节点。
  const factory SteinUiState.leaf() = SteinLeaf;

  const factory SteinUiState.error(String message) = SteinError;

  bool get isQuestion => this is SteinQuestion;
}

class SteinIdle extends SteinUiState {
  const SteinIdle();
}

class SteinLoading extends SteinUiState {
  const SteinLoading();
}

class SteinQuestion extends SteinUiState {
  final EdgeInfoData node;
  final NodePlan plan;

  const SteinQuestion({required this.node, required this.plan});
}

class SteinAutoWaiting extends SteinUiState {
  final EdgeInfoData node;
  final NodePlan plan;

  const SteinAutoWaiting({required this.node, required this.plan});
}

class SteinLeaf extends SteinUiState {
  const SteinLeaf();
}

class SteinError extends SteinUiState {
  final String message;

  const SteinError(this.message);
}
