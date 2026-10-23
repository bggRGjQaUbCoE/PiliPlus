import 'dart:collection';

import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart';
import 'package:collection/collection.dart';
import 'package:fixnum/fixnum.dart';

/// 无法显示父评论的原因分类
enum ReasonType {
  deleted('已删除'),
  blocked('已屏蔽'),
  ;

  final String desc;
  const ReasonType(this.desc);
}

/// DFS 序里的一行（含合成占位）。
class ReplyTreeNode {
  ReplyTreeNode({
    required this.reply,
    required this.depth,
    this._parent,
    this.reason,
  });

  final ReplyInfo reply;
  final int depth;

  int collapsed = 0;
  ReasonType? reason;

  final ReplyTreeNode? _parent;
  List<ReplyTreeNode>? _children;

  bool get isLeaf => _children == null || _children!.isEmpty;
  bool get hasChildren => _children != null && _children!.isNotEmpty;

  void _addChild(ReplyTreeNode node) {
    if (_children case final kids?) {
      kids.add(node);
    } else {
      _children = [node];
    }
  }

  // @override
  // int get hashCode => identityHashCode(reply);

  // @override
  // bool operator ==(Object other) {
  //   return other is ReplyTreeNode && identical(reply, other.reply);
  // }

  @override
  String toString({bool deep = false}) =>
      'ReplyTreeNode('
      'replyId=${reply.id}'
      ',depth=$depth'
      '${reason == null ? "" : ",suppressReason=${reason!.name}"}'
      '${isLeaf ? "" : ",children=[${deep ? _children!.map((i) => i.toString(deep: true)).join(',') : '...'}]"}'
      ')';
}

/// 树 + 折叠状态下的可见投影 [_vis]。
///
/// - 树结构：[ReplyTreeNode._parent] / [ReplyTreeNode._children] 指针。
/// - 可见序：[_vis] 是树的 DFS 前序投影，折叠时摘掉折叠节点的整棵子树，
///   展开时按 [ReplyTreeNode._children] 顺序（ctime 升序）插回。
extension type ReplyTree._(List<ReplyTreeNode> _vis)
    implements Iterable<ReplyTreeNode> {
  @pragma('vm:prefer-inline')
  ReplyTreeNode operator [](int index) => _vis[index];

  static int replyCompare(ReplyInfo a, ReplyInfo b) {
    final ctimeCmp = a.ctime.compareTo(b.ctime);
    if (ctimeCmp != 0) return ctimeCmp;
    return a.id.compareTo(b.id);
  }

  /// 从原始数据构建完整 DFS 序。
  /// [root] 可不提供。
  ///
  /// 步骤：
  /// 0. 调用方需先按 [ReplyInfo.id] 去重 [data]，[seen] 与之一一对应，且应当转移 [seen] 所有权。
  /// 1. 上溯 + 建桶（同时保留有实际占位作用的被屏蔽祖先）
  /// 2. 合成缺失父占位
  /// 3. DFS 前序拍平
  factory ReplyTree.build({
    required List<ReplyInfo> data,
    required HashSet<Int64> seen,
    required Int64 rootId,
    required Map<Int64, ReplyInfo> removed,
    int foldDepth = -1,
    ReplyTreeNode? root,
  }) {
    assert(
      root == null || root.reply.id == rootId,
      'rootId: $rootId 与 reply: ${root.reply.id} 不等',
    );
    assert(data.length == seen.length, 'data未去重');

    final children = HashMap<Int64, List<ReplyInfo>>();
    final suppressed = HashMap<Int64, ReasonType>();

    void addNode(ReplyInfo r) {
      assert(r.id != rootId, 'rootId $rootId 出现在子评论内');
      (children[r.parent] ??= []).add(r);
      seen.add(r.id);
    }

    // ── 1. 上溯 + 建桶 ──
    final toSynthDialogs = <Int64>{};
    final toSynthParents = <Int64>{};

    for (final r in data) {
      (children[r.parent] ??= []).add(r);

      // dialog：为 rootId 的直接子节点，无需上溯
      final d = r.dialog;
      if (r.id != d && !seen.contains(d) && !toSynthDialogs.contains(d)) {
        if (removed[d] case final dialog?) {
          assert(dialog.parent == rootId, 'dialog 应当是 rootId 的直接子节点');
          addNode(dialog);
          suppressed[d] = ReasonType.blocked;
        } else {
          toSynthDialogs.add(d);
        }
      }

      // parent：沿 removed 上溯保留被屏蔽祖先，否则登记待合成
      for (var p = r.parent, i = 0; p != rootId && i < 512; i++) {
        assert(i < 511, 'removed里可能出现环');
        if (seen.contains(p)) break;
        final anc = removed[p];
        if (anc == null) {
          toSynthParents.add(p);
          break;
        }
        addNode(anc);
        suppressed[p] = ReasonType.blocked;
        p = anc.parent;
      }
    }

    // ── 2. 合成缺失父 ──
    // 只登记未实体化的 dialog id；2b 后有 kids 才进桶，幽灵直接丢弃
    final deferred = <Int64>[];

    ReplyInfo synthReply(
      Int64 p,
      List<ReplyInfo> kids, [
      bool needAnchor = false,
    ]) {
      assert(kids.isNotEmpty, '节点 $p kids isEmpty');
      var mKidCtime = Int64.MAX_VALUE;

      Member? mention;
      var mPri = 1 << 30;
      var mMentCtime = Int64.MIN_VALUE;

      Int64? anchor;

      for (final r in kids) {
        if (r.ctime < mKidCtime) mKidCtime = r.ctime;

        final (pri, m) = _extractMention(r);
        if (pri < mPri || (pri == mPri && r.ctime > mMentCtime)) {
          mention = m;
          mPri = pri;
          mMentCtime = r.ctime;
        }

        if (needAnchor && anchor == null) {
          final d = r.dialog;
          if (d != p && seen.contains(d)) anchor = d;
        }
      }

      return ReplyInfo(
        id: p,
        parent: anchor ?? rootId,
        dialog: anchor ?? p,
        root: rootId,
        ctime: mKidCtime,
        mid: mention?.mid,
        member: mention,
      );
    }

    // ── 2a. 合成缺失 dialog ──
    // 有 kids：必为真实/blocked，直接实体化、ctime 已定。
    // 无 kids：只登记 seen + deferred，等 b 挂子。
    for (final p in toSynthDialogs) {
      toSynthParents.remove(p); // 交叉 id：已按 dialog 语义处理，2b 不再合成
      if (seen.contains(p)) {
        assert(false, '节点 $p 既是某节点的 dialog，又是另一条链的被屏蔽祖先');
        continue;
      }

      if (children[p] case final kids?) {
        addNode(synthReply(p, kids));
        suppressed[p] = ReasonType.deleted;
      } else {
        seen.add(p);
        deferred.add(p);
      }
    }
    toSynthDialogs.clear();

    // ── 2b. 合成缺失父 ──
    // seen 已含全部 dialog（含 deferred），anchor 检查无顺序依赖。
    // children[p] 非空：p 由上溯触发时其触发节点已建桶。
    for (final p in toSynthParents) {
      if (children[p] case final kids?) {
        addNode(synthReply(p, kids, true));
        suppressed[p] = ReasonType.deleted;
      } else {
        assert(false, '幽灵节点：$p');
      }
    }
    toSynthParents.clear();

    // ── 2c. 实体化 deferred：3b 已挂 children[p] ──
    for (final p in deferred) {
      if (children[p] case final kids?) {
        addNode(synthReply(p, kids));
        suppressed[p] = ReasonType.deleted;
      } else {
        assert(false, '幽灵节点：$p');
      }
    }
    deferred.clear();

    // ── 3. DFS 前序 ──
    final rows = <ReplyTreeNode>[];
    final visited = HashSet<Int64>();

    int walk(ReplyInfo r, int depth, ReplyTreeNode? parent, bool visible) {
      if (!visited.add(r.id)) {
        assert(false, '评论出现环：${r.id}');
        return -1;
      }

      final node = ReplyTreeNode(
        depth: depth,
        reply: r,
        parent: parent,
        reason: suppressed[r.id],
      );
      parent?._addChild(node);
      if (visible) rows.add(node);

      final kids = children[r.id];
      var count = 0;
      if (kids != null) {
        kids.sort(replyCompare);
        final autoFold = depth == foldDepth;
        final childVisible = visible && !autoFold;
        for (final k in kids) {
          if (identical(k, r)) {
            assert(false, '评论自引用：${r.id}');
            continue;
          }
          count += walk(k, depth + 1, node, childVisible) + 1;
        }
        if (autoFold) node.collapsed = count;
      }
      return count;
    }

    final rootKids = children[rootId];
    if (rootKids != null) {
      rootKids.sort(replyCompare);
      for (final i in rootKids) {
        walk(i, 0, root, true);
      }
    } else {
      assert(false, 'root下为空桶');
    }

    assert(seen.length == visited.length, '存在孤儿节点');

    return ReplyTree._(rows);
  }

  /// 返回 [index] 处节点的可见子树在 [_vis] 中的末尾下标（不含）。
  ///
  /// 或许可以考虑多峰有平台的二分，但更复杂。
  int _visibleSubtreeEnd(int index) {
    final a = _vis[index];
    assert(a.collapsed == 0, '折叠的节点无可见子树');
    final d = a.depth;
    var end = index + (a._children?.length ?? 0) + 1;
    while (end < _vis.length && _vis[end].depth > d) {
      end++;
    }
    return end;
  }

  /// 切换 [index] 处的折叠状态。
  int toggleCollapse(int index) {
    final a = _vis[index];
    if (a.isLeaf) return 0;

    final start = index + 1;
    if (a.collapsed == 0) {
      final end = _visibleSubtreeEnd(index);
      _vis.removeRange(start, end);
      return a.collapsed = end - start;
    } else {
      final kids = a._children;
      if (kids == null || kids.isEmpty) return 0;
      final out = <ReplyTreeNode>[];

      /// 按 [ReplyTreeNode._children] 顺序 DFS，跳过嵌套折叠的子树。
      void add(ReplyTreeNode n) {
        out.add(n);
        if (n.collapsed != 0) return;
        final cs = n._children;
        if (cs == null || cs.isEmpty) return;
        for (final c in cs) {
          add(c);
        }
      }

      for (final c in kids) {
        add(c);
      }
      _vis.insertAll(start, out);
      a.collapsed = 0;
      return out.length;
    }
  }

  /// 向 [index] 处节点插入新回复 [c]。
  ///
  /// 前置条件：祖先均处于展开态，否则 [ReplyTreeNode.collapsed] 状态错误。
  /// [c] 是该节点所有子节点里 ctime 最大的。
  int appendLeaf(ReplyInfo c, int index) {
    final parent = _vis[index];
    assert(
      parent.isLeaf || replyCompare(parent._children!.last.reply, c) < 0,
      '回复：${c.id} 必须是 parent 所有子节点里 ctime 最大的',
    );
    assert(parent._debugAncestorsExpanded(), '祖先未处于展开态');

    final node = ReplyTreeNode(
      reply: c,
      depth: parent.depth + 1,
      parent: parent,
    );

    // 先扫再插children，避免叶子节点错位
    int insertIndex = -1;
    if (parent.collapsed == 0) {
      insertIndex = _visibleSubtreeEnd(index);
      _vis.insert(insertIndex, node);
    } else {
      parent.collapsed++;
    }

    parent._addChild(node);
    return insertIndex;
  }

  /// 删除 [index] 处的评论。
  ///
  /// - 有后代：使用「已删除」占位，结构不动（保留子树可见性）。
  /// - 叶子：从 [ReplyTreeNode._children] 与 [_vis] 移除。
  /// 前置条件：祖先均处于展开态，否则 [ReplyTreeNode.collapsed] 状态错误。
  ///
  /// 原始数据的同步删除使用 [ReplyList.reverseIdentityIndexOf] 定位，
  /// [ReplyInfo.==] 是 [DeepCollectionEquality]，不应使用 [List.remove]。
  ReplyTreeNode remove(int index) {
    final node = _vis[index];
    assert(node._debugAncestorsExpanded(), '祖先未处于展开态');

    if (node.hasChildren) {
      node.reason = ReasonType.deleted;
      return node;
    }

    _vis.removeAt(index);

    if (node._parent case final p?) {
      if (p._children case final kids?) {
        final kidsIdx = kids.reverseIdentityIndexOf(node);
        if (kidsIdx >= 0) {
          kids.removeAt(kidsIdx);
        } else {
          assert(false);
        }
      }
    }

    return node;
  }

  bool isParentFirstChild(int index) {
    if (index == 0) return true;
    return identical(_vis[index]._parent, _vis[index - 1]);
  }

  bool isParentLastChild(int index) {
    if (index == _vis.length - 1) return true;
    return _vis[index + 1].depth < _vis[index].depth;
  }

  /// 从 [ReplyInfo.parentReplyMember] 提取被回复者信息，用于合成占位父。
  static (int, Member?) _extractMention(ReplyInfo reply) {
    // 合成节点无parentReplyMember
    if (!reply.hasParentReplyMember()) return const (1 << 30, null);
    final parent = reply.parentReplyMember;
    final members = reply.content.members;

    // 1) 名字命中成员表：直接用
    if (members[parent.name] case final m?) {
      return (1, m);
    }
    // 2) 改名：原名字不在成员表，但 mid 相同，认为是同一人
    if (parent.hasMid()) {
      final mid = parent.mid;
      if (members.values.firstWhereOrNull((i) => i.mid == mid) case final m?) {
        return (1, m);
      }
    }
    // 3) 自回复：无mid属性
    if (parent.name == reply.member.name) {
      return (2, reply.member);
    }
    // 4) 可能自回复但改名，也可能是古早回复无member信息
    return (3, Member(name: parent.name, mid: parent.mid));
  }
}

extension ReplyTreeNodeUi on ReplyTreeNode {
  /// 根据某节点的 [ancestors]，判断 [this] 该高亮拿一根线，高亮线如图。
  /// ```
  /// R
  /// ║ A
  /// │ ║ B
  /// │ ║ └ C
  /// │ ║   └ D
  /// │ ║ E
  /// │ │ ║ F
  /// │ │ │ ║ G ([ancestors] sources)
  /// │ │ │ │ └ H (调用方应当提前过滤 index > G，否则将产生错误高亮)
  /// ```
  int highlightLineOf(HashSet<ReplyTreeNode> ancestors) {
    var step = -1;
    for (var p = _parent; p != null && !ancestors.contains(p); p = p._parent) {
      step++;
    }
    return depth - step;
  }

  ReplyTreeNode? lookupAncestorForDepth(int depth) {
    assert(0 <= depth && depth < this.depth, '祖先深度应小于当前深度且非负');
    var p = _parent;
    while (p != null && p.depth > depth) {
      p = p._parent;
    }
    return p;
  }

  bool _debugAncestorsExpanded() {
    for (var p = _parent; p != null; p = p._parent) {
      if (p.collapsed != 0) {
        return false;
      }
    }
    return true;
  }
}

extension ReplyList<T> on Iterable<T> {
  /// Do NOT invoke it on non [IndexedIterable] object.
  int reverseIdentityIndexOf(T element, [int? end]) {
    for (int i = end ?? length - 1; i >= 0; i--) {
      if (identical(element, elementAt(i))) {
        return i;
      }
    }
    return -1;
  }
}
