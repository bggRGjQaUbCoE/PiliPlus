import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo, Content, Member;
import 'package:fixnum/fixnum.dart';
import 'dart:math' as math;

/// 树渲染的扁平行：Item = 实际回复；DeepLink = 深度截断占位行
sealed class ReplyTreeRow {
  ReplyTreeRow({
    required this.depth,
    this.ancestors = const [],
    this.lastAtLevel = const [],
    this.lineAtLevel = const [],
  });
  final int depth;

  /// 各级祖先 rpids，供点击引导线时折叠对应子树。由 buildReplyTree 填充。
  final List<Int64> ancestors;

  /// lineAtLevel[k]：第 k 层引导线在本行是否绘制；lastAtLevel[k]：本行是否为其最后一个直接子节点。
  List<bool> lastAtLevel;
  List<bool> lineAtLevel;
}

class ReplyTreeItem extends ReplyTreeRow {
  ReplyTreeItem({
    required super.depth,
    required this.flatIndex,
    required this.reply,
    required this.hasChildren,
    super.ancestors = const [],
    super.lastAtLevel = const [],
    super.lineAtLevel = const [],
  });
  final int flatIndex;
  final ReplyInfo reply;
  final bool hasChildren;
}

class ReplyTreeDeepLink extends ReplyTreeRow {
  ReplyTreeDeepLink({
    required super.depth,
    required this.rpid,
    required this.count,
    super.ancestors = const [],
    super.lastAtLevel = const [],
    super.lineAtLevel = const [],
  });
  final Int64 rpid;
  final int count;
}

class _Node {
  _Node(this.reply);
  final ReplyInfo reply;
  final List<_Node> children = [];
}

/// 由扁平子回复列表构建树并扁平化为行序列。
///
/// - parent == rootId → 本线程根节点（depth 0）
/// - parent 不在集合中（被删 / 未加载 / 自引用）→ 升级为根节点
/// - 每层按 ctime 升序；DFS 保证父行紧跟其子树
/// - 命中 collapsed 的节点折叠整棵子树：只输出该节点自身，不输出任何子行
/// - 深度 >= maxDepth 且有子节点时输出 ReplyTreeDeepLink 占位行，截断子树
/// - 每行附带 lineAtLevel（该层竖线在本行是否绘制）/ lastAtLevel（该层竖线在本行收尾）
///   与 ancestors（供点击折叠）
List<ReplyTreeRow> buildReplyTree({
  required List<ReplyInfo> flat,
  required Int64 rootId,
  required Set<Int64> collapsed,
  required int maxDepth,
}) {
  final map = <Int64, _Node>{};
  final indexMap = <Int64, int>{};
  for (var i = 0; i < flat.length; i++) {
    map[flat[i].id] = _Node(flat[i]);
    indexMap[flat[i].id] = i;
  }

  final roots = <_Node>[];
  for (final reply in flat) {
    final node = map[reply.id]!;
    final parent = reply.parent != rootId ? map[reply.parent] : null;
    if (parent != null && parent != node) {
      parent.children.add(node);
    } else {
      roots.add(node);
    }
  }

  int cmp(_Node a, _Node b) => a.reply.ctime.compareTo(b.reply.ctime);
  void sortNode(_Node node) {
    node.children.sort(cmp);
    for (final child in node.children) {
      sortNode(child);
    }
  }

  roots.sort(cmp);
  for (final root in roots) {
    sortNode(root);
  }

  int subtreeSize(_Node node) =>
      1 + node.children.fold(0, (sum, c) => sum + subtreeSize(c));

  final rows = <ReplyTreeRow>[];
  final visited = <Int64>{};
  final rowIndex = <Int64, int>{}; // 节点 id -> 其 Item 行下标
  final nodesInOrder = <_Node>[]; // 按行序收集的节点
  final truncated = <Int64>{}; // 被深度截断的节点 id
  var lastDepth0Row = 0; // 最后一个 depth-0 行下标（主引导线终点）

  void walk(_Node node, int depth, List<Int64> ancestors) {
    if (!visited.add(node.reply.id)) return; // 环保护
    final idx = rows.length;
    rowIndex[node.reply.id] = idx;
    nodesInOrder.add(node);
    if (depth == 0) {
      lastDepth0Row = idx;
    }
    rows.add(
      ReplyTreeItem(
        depth: depth,
        flatIndex: indexMap[node.reply.id]!,
        reply: node.reply,
        hasChildren: node.children.isNotEmpty,
        ancestors: List.of(ancestors),
      ),
    );
    final path = [...ancestors, node.reply.id];
    if (collapsed.contains(node.reply.id) && node.children.isNotEmpty) {
      return; // 折叠：不输出子树
    }
    if (depth >= maxDepth && node.children.isNotEmpty) {
      truncated.add(node.reply.id);
      rows.add(
        ReplyTreeDeepLink(
          depth: depth + 1,
          rpid: node.reply.id,
          count: subtreeSize(node) - 1,
          ancestors: path,
        ),
      );
      return;
    }
    for (final child in node.children) {
      walk(child, depth + 1, path);
    }
  }

  for (final root in roots) {
    walk(root, 0, const []);
  }

  // 不可达节点（循环引用等）追加为根节点，避免丢失
  final reachable = <Int64>{};
  void markReachable(_Node node) {
    if (!reachable.add(node.reply.id)) return;
    for (final child in node.children) {
      markReachable(child);
    }
  }
  for (final root in roots) {
    markReachable(root);
  }
  final extraRoots = map.values
      .where((node) => !reachable.contains(node.reply.id))
      .toList()
    ..sort(cmp);
  for (final root in extraRoots) {
    walk(root, 0, const []);
  }

  // 每个节点最后一个直接子节点的行下标，决定其引导线的终止位置
  final lastChildRow = <Int64, int>{};
  for (final node in nodesInOrder) {
    if (node.children.isEmpty) continue;
    if (collapsed.contains(node.reply.id) || truncated.contains(node.reply.id)) {
      continue; // 子节点未被 walk，无直接子节点行
    }
    final lastChild = node.children.last;
    final idx = rowIndex[lastChild.reply.id];
    if (idx != null) {
      lastChildRow[node.reply.id] = idx;
    }
  }

  // 填充每行的 lineAtLevel / lastAtLevel：
  // 第 k 层线属于 ancestors[k-1]（k>=1）或头部评论（k=0），终止于其最后直接子节点。
  List<bool> lineFlags(int i, int depth, List<Int64> ancestors) =>
      List.generate(depth + 1, (k) {
        if (k == 0) return i <= lastDepth0Row;
        if (k == depth && rows[i] is ReplyTreeDeepLink) {
          return true; // 截断节点的线延伸到按钮行
        }
        return i <= (lastChildRow[ancestors[k - 1]] ?? -1);
      });
  List<bool> lastFlags(int i, int depth, List<Int64> ancestors) =>
      List.generate(depth + 1, (k) {
        if (k == 0) return i == lastDepth0Row;
        if (k == depth && rows[i] is ReplyTreeDeepLink) {
          return true;
        }
        return i == (lastChildRow[ancestors[k - 1]] ?? -2);
      });
  for (var i = 0; i < rows.length; i++) {
    final item = rows[i];
    item
      ..lineAtLevel = lineFlags(i, item.depth, item.ancestors)
      ..lastAtLevel = lastFlags(i, item.depth, item.ancestors);
  }

  return rows;
}

/// 从扁平列表中提取以 rootId 为根的子树的全部节点（含间接后代，不含 rootId 自身）。
///
/// 用于「继续此讨论串」：父面板已加载整棵楼中楼的扁平列表，
/// 从中提取深层评论的子树作为新面板的数据源。
/// 保持原列表顺序，供 flatIndex 使用。
List<ReplyInfo> extractSubtree(List<ReplyInfo> flat, Int64 rootId) {
  final children = <Int64, List<ReplyInfo>>{};
  for (final r in flat) {
    (children[r.parent] ??= []).add(r);
  }

  final result = <ReplyInfo>[];
  final visited = <Int64>{rootId};
  final stack = <Int64>[rootId];
  while (stack.isNotEmpty) {
    final pid = stack.removeLast();
    for (final child in children[pid] ?? const <ReplyInfo>[]) {
      if (visited.add(child.id)) {
        result.add(child);
        stack.add(child.id);
      }
    }
  }
  return result;
}

/// 无法显示父评论的原因分类
enum ReplySuppressReason { deleted, blocked }

/// 回复消息中的 @提及正则（支持「回复 @xx : …」等非前缀位置）
final _mentionRe = RegExp(r'@([^@\s：:，,]+)');

/// 从回复的 @提及提取 (名字, 头像, mid)。
/// 消息文本里的 `@名字` 优先查 `content.members`（含 face）、`atNameToMid`；
/// 改名/失效的提及未解析为成员时，回退只取文本中的名字（无头像无 mid）；
/// 消息无 @ 时回退 members / atNameToMid 首项；皆空则返回 null。
(String name, String? face, Int64 mid)? extractMention(ReplyInfo reply) {
  final content = reply.content;
  final match = _mentionRe.firstMatch(content.message);
  final lead = match?.group(1);
  if (lead != null) {
    final member = content.members[lead];
    final mid = content.atNameToMid[lead];
    if (member != null) return (member.name, member.face, mid ?? member.mid);
    if (mid != null) return (lead, null, mid);
    return (lead, null, Int64.ZERO); // 提及未解析为成员：名字仅取自文本
  }
  if (content.members.isNotEmpty) {
    final m = content.members.values.first;
    return (m.name, m.face, m.mid);
  }
  if (content.atNameToMid.isNotEmpty) {
    final name = content.atNameToMid.keys.first;
    return (name, null, content.atNameToMid[name]!);
  }
  return null;
}

/// 树输入派生：保留被屏蔽评论 + 合成缺失父占位。
///
/// 返回 (有效 flat, suppressed 映射) 供 `buildReplyTree` 与视图渲染使用。
/// - `removed`：detailList 过滤掉的被屏蔽评论，仅保留「是某条真实回复祖先」者
///   （沿 parent 链自底向上）；被屏蔽叶评论不保留、不渲染。
/// - 缺失父（≠ rootId、不在 flat）合成一条「已删除」占位：第一条引用它的子评论
///   加载后即形成，父稍后加载时自愈为真实评论。ctime 取子评论最小 ctime，
///   名字/头像/mid 取自子回复 @提及。
({List<ReplyInfo> flat, Map<Int64, ReplySuppressReason> suppressed}) buildTreeInput({
  required List<ReplyInfo> replies,
  required Map<Int64, ReplyInfo> removed,
  required Int64 rootId,
}) {
  final suppressed = <Int64, ReplySuppressReason>{};
  final flat = <ReplyInfo>[...replies];
  final idSet = <Int64>{}..addAll(flat.map((r) => r.id));

  // 1) 保留「是某条真实回复祖先」或被删父级引用的被屏蔽评论
  final kept = <Int64, ReplyInfo>{};
  // 1a) 沿真实回复的 parent 链自底向上保留被屏蔽祖先
  for (final r in replies) {
    var cur = r.parent;
    while (cur != rootId &&
        !idSet.contains(cur) &&
        removed.containsKey(cur) &&
        !kept.containsKey(cur)) {
      kept[cur] = removed[cur]!;
      cur = removed[cur]!.parent;
    }
  }
  // 1b) 保留「父级缺失」的被屏蔽评论：父既非真实回复、也非被屏蔽评论
  //     （父被删/未加载 → 将被合成为 deleted 占位，屏蔽评论作为锚点，
  //     避免「父删 + 子屏」时整条链丢失；父为被屏蔽叶评论则不保留）
  final realIds = Set<Int64>.of(idSet);
  for (final entry in removed.entries) {
    final b = entry.value;
    if (kept.containsKey(b.id)) continue;
    final bp = b.parent;
    if (bp != rootId && !realIds.contains(bp) && !removed.containsKey(bp)) {
      kept[b.id] = b;
    }
  }
  flat.addAll(kept.values);
  for (final k in kept.keys) {
    suppressed[k] = ReplySuppressReason.blocked;
    idSet.add(k);
  }

  // 2) 对缺失父合成「已删除」占位（第一条引用它的子评论加载后即形成；父稍后加载则自愈）
  final toAdd = <Int64, ReplyInfo>{};
  for (final r in List.of(flat)) {
    final p = r.parent;
    if (p == rootId || idSet.contains(p)) {
      continue;
    }
    final children = flat.where((c) => c.parent == p).toList();
    if (children.isEmpty) continue;
    (String, String?, Int64)? mention;
    for (final c in children) {
      final m = extractMention(c);
      if (m != null) {
        mention = m;
        break;
      }
    }
    var minCtime = Int64.MAX_VALUE;
    for (final c in children) {
      if (c.ctime < minCtime) minCtime = c.ctime;
    }
    final syn = ReplyInfo()
      ..id = p
      ..parent = rootId
      ..root = rootId
      ..ctime = minCtime
      ..content = Content();
    if (mention != null) {
      syn
        ..mid = mention.$3
        ..member = (Member()
          ..mid = mention.$3
          ..name = mention.$1
          ..face = mention.$2 ?? '');
    }
    toAdd[p] = syn;
    suppressed[p] = ReplySuppressReason.deleted;
    idSet.add(p);
  }

  // 3) dialog 分组启发式：被删占位挂到已知对话祖先之下（深度取浅收紧）
  for (final p in toAdd.keys) {
    Int64? anchor;
    for (final c in flat) {
      if (c.parent != p) continue;
      final d = c.dialog;
      if (!d.isZero && d != p && idSet.contains(d)) {
        anchor = d;
        break;
      }
    }
    if (anchor != null) toAdd[p]!.parent = anchor;
  }
  flat.addAll(toAdd.values);

  return (flat: flat, suppressed: suppressed);
}

/// 逐级递减缩进：第 k 级步进 = base·decay^k（下限 minStep），
/// indentAt(k) 为前 k 级累积偏移。纯几何，无像素常量。
class ReplyTreeIndent {
  ReplyTreeIndent({
    required this.base,
    this.decay = 0.85,
    this.minStep = 22,
  });
  final double base;
  final double decay;
  final double minStep;

  /// 第 k 级自身步进（受 minStep 下限约束）。
  double stepAt(int k) => math.max(base * math.pow(decay, k), minStep);

  /// 前 k 级累积偏移；indentAt(0) == 0。
  double indentAt(int k) {
    var s = 0.0;
    for (var i = 0; i < k; i++) {
      s += stepAt(i);
    }
    return s;
  }
}
