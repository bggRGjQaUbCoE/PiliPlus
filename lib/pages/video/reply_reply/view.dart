import 'dart:math' as math;

import 'package:PiliPlus/common/skeleton/video_reply.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/colored_box_transition.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/common/widgets/scaffold/mini_scaffold.dart';
import 'package:PiliPlus/common/widgets/scaffold/simple_scaffold.dart';
import 'package:PiliPlus/common/widgets/simple_colored_box.dart';
import 'package:PiliPlus/common/widgets/sliver/sliver_pinned_header.dart';
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/slide/common_slide_page.dart';
import 'package:PiliPlus/pages/video/reply/widgets/reply_item_grpc.dart';
import 'package:PiliPlus/pages/video/reply_reply/controller.dart';
import 'package:PiliPlus/pages/video/reply_reply/reply_tree.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/extension/widget_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:fixnum/fixnum.dart' show Int64;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class VideoReplyReplyPanel extends CommonSlidePage {
  const VideoReplyReplyPanel({
    super.key,
    super.enableSlide,
    this.id,
    required this.oid,
    required this.rpid,
    this.dialog,
    this.firstFloor,
    this.seedReplies,
    this.seedRootId,
    this.seedOffset,
    required this.isVideoDetail,
    required this.replyType,
    this.isNested = false,
    this.upMid,
  });
  final int? id;
  final int oid;
  final int rpid;
  final int? dialog;
  final ReplyInfo? firstFloor;
  final List<ReplyInfo>? seedReplies;
  final int? seedRootId;
  final String? seedOffset;
  final bool isVideoDetail;
  final int replyType;
  final bool isNested;
  final Int64? upMid;

  @override
  State<VideoReplyReplyPanel> createState() => _VideoReplyReplyPanelState();

  static Future<void>? toReply({
    required int oid,
    required int rootId,
    String? rpIdStr,
    required int type,
    Uri? uri,
  }) {
    final rpId = rpIdStr == null ? null : int.tryParse(rpIdStr);
    return Get.to(
      arguments: {
        'oid': oid,
        'rpid': rootId,
        'id': ?rpId,
        'type': type,
        'enterUri': ?uri?.toString(), // save panel
      },
      () => SimpleScaffold(
        appBar: AppBar(
          title: const Text('评论详情'),
          actions: [
            IconButton(
              tooltip: '前往',
              onPressed: uri == null
                  ? null
                  : () => PiliScheme.routePush(uri, businessId: type),
              icon: const Icon(Icons.open_in_browser),
            ),
          ],
        ),
        body: ViewSafeArea(
          child: VideoReplyReplyPanel(
            enableSlide: false,
            oid: oid,
            rpid: rootId,
            isVideoDetail: false,
            replyType: type,
            firstFloor: null,
            id: rpId,
          ),
        ).constraintWidth(),
      ),
    );
  }
}

class _VideoReplyReplyPanelState extends State<VideoReplyReplyPanel>
    with SingleTickerProviderStateMixin, CommonSlideMixin {
  late VideoReplyReplyController _controller;
  late final _tag = Utils.makeHeroTag('${widget.rpid}${widget.dialog}');
  Animation<Color?>? _colorAnimation;

  late final bool isDialogue = widget.dialog != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _colorAnimation = null;
    final controller = PrimaryScrollController.of(context);
    _controller
      ..didChangeDependencies(context)
      ..nestedController = controller is ExtendedNestedScrollController
          ? controller
          : null;
  }

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      VideoReplyReplyController(
        hasRoot: widget.firstFloor != null,
        id: widget.id,
        oid: widget.oid,
        rpid: widget.rpid,
        dialog: widget.dialog,
        replyType: widget.replyType,
        seedReplies: widget.seedReplies,
        seedRootId: widget.seedRootId,
        seedOffset: widget.seedOffset,
      ),
      tag: _tag,
    );
  }

  @override
  void dispose() {
    Get.delete<VideoReplyReplyController>(tag: _tag);
    super.dispose();
  }

  @override
  Widget buildPage(ThemeData theme) {
    Widget child() => enableSlide ? slideList(theme) : buildList(theme);
    return SimpleColoredBox(
      color: theme.canvasColor,
      child: MiniScaffold(
        body: widget.isVideoDetail
            ? Column(
                children: [
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: theme.dividerColor.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 12, right: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(isDialogue ? '对话列表' : '评论详情'),
                        IconButton(
                          tooltip: '关闭',
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: Get.back,
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: child()),
                ],
              )
            : child(),
      ),
    );
  }

  ReplyInfo? get firstFloor =>
      widget.firstFloor ?? _controller.firstFloor.value;

  ScrollController get scrollController =>
      _controller.nestedController ?? _controller.scrollController;

  @override
  Widget buildList(ThemeData theme) {
    return refreshIndicator(
      onRefresh: _controller.onRefresh,
      isClampingScrollPhysics: widget.isNested,
      child: CustomScrollView(
        key: ValueKey(scrollController.hashCode),
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (!isDialogue) ...[
            if ((widget.firstFloor ?? _controller.firstFloor.value)
                case final firstFloor?)
              _header(theme, firstFloor)
            else
              Obx(() {
                final firstFloor = _controller.firstFloor.value;
                if (firstFloor == null) {
                  return const SliverToBoxAdapter();
                }
                return _header(theme, firstFloor);
              }),
            Obx(() {
              // 整树折叠时不显示分隔行
              _controller.collapsedRpids.length;
              return _sortWidget(
                theme.colorScheme,
                hide: Pref.replyTreeEnabled &&
                    _controller.collapsedRpids.contains(Int64(widget.rpid)),
              );
            }),
          ],
          Obx(
            () {
              final state = _controller.loadingState.value;
              // 订阅折叠状态变化，避免嵌套 Obx 导致生命周期冲突
              _controller.collapsedRpids.length;
              // 整树折叠：不渲染任何树行
              if (!isDialogue &&
                  Pref.replyTreeEnabled &&
                  _controller.collapsedRpids.contains(Int64(widget.rpid))) {
                return const SliverToBoxAdapter();
              }
              return _buildBody(theme.colorScheme, state);
            },
          ),
        ],
      ),
    );
  }

  Widget _header(ThemeData theme, ReplyInfo firstFloor) {
    final colorScheme = theme.colorScheme;
    final replyItem = ReplyItemGrpc(
      replyItem: firstFloor,
      replyLevel: 2,
      needDivider: false,
      onReply: (replyItem) => _controller.onReply(replyItem, index: -1),
      upMid: widget.upMid ?? _controller.upMid,
      onCheckReply: (item) => _controller.onCheckReply(item, isManual: true),
    );
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Pref.replyTreeEnabled
              ? _HeaderGuide(
                  headerRpid: widget.rpid,
                  colorScheme: colorScheme,
                  collapsedRpids: _controller.collapsedRpids,
                  onToggleCollapse: _controller.toggleCollapse,
                  hoveredLine: _controller.hoveredLine,
                  child: replyItem,
                )
              : replyItem,
        ),
        SliverToBoxAdapter(
          child: Divider(
            height: 20,
            color: theme.dividerColor.withValues(alpha: 0.1),
            thickness: 6,
          ),
        ),
      ],
    );
  }

  Widget _sortWidget(ColorScheme colorScheme, {required bool hide}) {
    if (hide) {
      return const SliverToBoxAdapter();
    }
    final tree = Pref.replyTreeEnabled;
    // 树模式下文本右移到与 depth-0 回复内容对齐（indentAt(1)=base），避开 x=29 主引导线；flat 模式保持原 x=12
    final leftPad = tree
        ? (MediaQuery.sizeOf(context).width <= 640 ? 40.0 : 44.0)
        : 12.0;
    final padding = Padding(
      padding: EdgeInsets.fromLTRB(leftPad, 2.5, 6, 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() {
            final count = _controller.count.value;
            return count != -1
                ? Text(
                    '相关回复共${NumUtils.numFormat(count)}条',
                    style: const TextStyle(fontSize: 13),
                  )
                : const SizedBox.shrink();
          }),
          TextButton.icon(
            style: Style.buttonStyle,
            onPressed: _controller.queryBySort,
            icon: Icon(Icons.sort, size: 16, color: colorScheme.secondary),
            label: Obx(
              () => Text(
                _controller.sortType.value.text!,
                style: TextStyle(fontSize: 13, color: colorScheme.secondary),
              ),
            ),
          ),
        ],
      ),
    );
    return SliverPinnedHeader(
      backgroundColor: colorScheme.surface,
      child: tree
          ? _SortStripGuide(
              headerRpid: widget.rpid,
              colorScheme: colorScheme,
              onToggleCollapse: _controller.toggleCollapse,
              hoveredLine: _controller.hoveredLine,
              child: padding,
            )
          : padding,
    );
  }

  Widget _buildBody(
    ColorScheme colorScheme,
    LoadingState<List<ReplyInfo>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => SliverPrototypeExtentList.builder(
        prototypeItem: const VideoReplySkeleton(),
        itemBuilder: (_, _) => const VideoReplySkeleton(),
        itemCount: 8,
      ),
      Success(:final response!) => _buildReplyList(colorScheme, response),
      Error(:final errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  Widget _buildReplyList(ColorScheme colorScheme, List<ReplyInfo> response) {
    final availableWidth = MediaQuery.sizeOf(context).width;
    final indent = ReplyTreeIndent(base: availableWidth <= 640 ? 40 : 44);
    final treeMaxDepth = Pref.replyTreeMaxDepth;
    final jumpIndex = _controller.index.value;
    // seed 模式：只显示深层评论的子树（父面板数据已含整棵楼中楼）
    final list = _controller.isSeedMode
        ? extractSubtree(response, Int64(widget.rpid))
        : response;
    final useTree = !isDialogue && Pref.replyTreeEnabled;
    // 树输入：有效 flat（保留被屏蔽 + 合成缺失父）+ suppressed 映射
    final input = _controller.treeInput;
    final wholeTreeCollapsed = useTree &&
        _controller.collapsedRpids.contains(Int64(widget.rpid));
    final rows = !useTree
        ? <ReplyTreeRow>[
            for (var i = 0; i < list.length; i++)
              ReplyTreeItem(
                depth: 0,
                flatIndex: i,
                reply: list[i],
                hasChildren: false,
              ),
          ]
        : wholeTreeCollapsed
        ? const <ReplyTreeRow>[]
        : buildReplyTree(
            flat: input.flat,
            rootId: Int64(widget.rpid),
            collapsed: _controller.collapsedRpids,
            maxDepth: treeMaxDepth,
          );
    return SuperSliverList.builder(
      listController: _controller.listController,
      itemBuilder: (context, index) {
        if (index == rows.length) {
          _controller.onLoadMore();
          return Container(
            height: 125,
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              bottom: MediaQuery.viewPaddingOf(context).bottom,
            ),
            child: Text(
              _controller.isEnd ? '没有更多了' : '加载中...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: colorScheme.outline),
            ),
          );
        }
        final Widget child = switch (rows[index]) {
          ReplyTreeItem(
            :final reply,
            :final flatIndex,
          ) =>
            !useTree
                ? _replyItem(context, reply, flatIndex)
                : _TreeRow(
                    row: rows[index] as ReplyTreeItem,
                    replyWidget: input.suppressed[reply.id] != null
                        ? _placeholderContent(
                            reply,
                            input.suppressed[reply.id]!,
                          )
                        : _replyItem(context, reply, flatIndex),
                    indent: indent,
                    colorScheme: colorScheme,
                    headerRpid: widget.rpid,
                    collapsedRpids: _controller.collapsedRpids,
                    onToggleCollapse: _controller.toggleCollapse,
                    hoveredLine: _controller.hoveredLine,
                  ),
          ReplyTreeDeepLink(:final depth, :final rpid, :final count) =>
            _DeepLinkRow(
              depth: depth,
              rpid: rpid,
              count: count,
              ancestors: (rows[index] as ReplyTreeDeepLink).ancestors,
              lastAtLevel: (rows[index] as ReplyTreeDeepLink).lastAtLevel,
              lineAtLevel: (rows[index] as ReplyTreeDeepLink).lineAtLevel,
              indent: indent,
              colorScheme: colorScheme,
              headerRpid: widget.rpid,
              collapsedRpids: _controller.collapsedRpids,
              onToggleCollapse: _controller.toggleCollapse,
              hoveredLine: _controller.hoveredLine,
              onOpen: () {
                final seedList = _controller.loadingState.value.data;
                ReplyInfo? target;
                if (seedList != null) {
                  for (final r in seedList) {
                    if (r.id == rpid) {
                      target = r;
                      break;
                    }
                  }
                }
                MiniScaffold.of(context).showBottomSheet(
                  constraints: const BoxConstraints(),
                  (context) => VideoReplyReplyPanel(
                    oid: widget.oid,
                    rpid: rpid.toInt(),
                    firstFloor: target,
                    seedReplies: seedList == null ? null : List.of(seedList),
                    seedRootId: widget.rpid,
                    seedOffset: _controller.paginationReply?.nextOffset,
                    replyType: widget.replyType,
                    isVideoDetail: true,
                    isNested: widget.isNested,
                  ),
                );
              },
            ),
        };
        if (jumpIndex == index) {
          return ColoredBoxTransition(
            color: _colorAnimation ??= _controller.animController.drive(
              ColorTween(
                begin: colorScheme.onInverseSurface,
                end: colorScheme.surface,
                // 前0.8s不变, 后0.2s开始动画
              ).chain(CurveTween(curve: const Interval(0.8, 1.0))),
            ),
            child: child,
          );
        }
        return child;
      },
      itemCount: rows.length + 1,
    );
  }

  Widget _replyItem(BuildContext context, ReplyInfo replyItem, int index) {
    return ReplyItemGrpc(
      replyItem: replyItem,
      replyLevel: isDialogue ? 3 : 2,
      // 树状模式下「查看对话」已冗余（完整对话树可见），屏蔽其入口
      enableViewDialogue: !(Pref.replyTreeEnabled && !isDialogue),
      onReply: (replyItem) => _controller.onReply(replyItem, index: index),
      onDelete: (item, subIndex) => _controller.onRemove(index, item, null),
      upMid: _controller.upMid,
      showDialogue: () => MiniScaffold.of(context).showBottomSheet(
        constraints: const BoxConstraints(),
        (context) => VideoReplyReplyPanel(
          oid: replyItem.oid.toInt(),
          rpid: replyItem.root.toInt(),
          dialog: replyItem.dialog.toInt(),
          replyType: widget.replyType,
          isVideoDetail: true,
          isNested: widget.isNested,
        ),
      ),
      jumpToDialogue: () {
        if (!_controller.setIndexById(replyItem.parent)) {
          SmartDialog.showToast('评论可能已被删除');
        }
      },
      onCheckReply: (item) => _controller.onCheckReply(item, isManual: true),
    );
  }

  /// 无法显示父评论的占位行：头像 + 名字 + 分类文本。
  /// 有有效 mid 时可点击进入主页（手型光标）；折叠/引导线由外层 _TreeRow 提供。
  Widget _placeholderContent(ReplyInfo reply, ReplySuppressReason reason) {
    final colorScheme = ColorScheme.of(context);
    final text = switch (reason) {
      ReplySuppressReason.deleted => '已删除',
      ReplySuppressReason.blocked => '已屏蔽',
    };
    final mid = reply.mid;
    final content = Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 8, 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PendantAvatar(reply.member.face, size: 34),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (reply.member.name.isNotEmpty)
                  Text(
                    reply.member.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: colorScheme.outline),
                  ),
                Text(
                  text,
                  style: TextStyle(fontSize: 12, color: colorScheme.outline),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    if (mid == Int64.ZERO) return content;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          feedBack();
          Get.toNamed('/member?mid=${mid.toInt()}');
        },
        child: content,
      ),
    );
  }
}

/// 点 p 是否落在圆心 center、半径 radius 的圆内
bool _inCircle(Offset center, double radius, Offset p) {
  final dx = p.dx - center.dx;
  final dy = p.dy - center.dy;
  return dx * dx + dy * dy <= radius * radius;
}

class _TreeRow extends StatefulWidget {
  const _TreeRow({
    required this.row,
    required this.replyWidget,
    required this.indent,
    required this.colorScheme,
    required this.headerRpid,
    required this.collapsedRpids,
    required this.onToggleCollapse,
    required this.hoveredLine,
  });
  final ReplyTreeItem row;
  final Widget replyWidget;
  final ReplyTreeIndent indent;
  final ColorScheme colorScheme;
  final int headerRpid;
  final Set<Int64> collapsedRpids;
  final ValueChanged<Int64> onToggleCollapse;
  final Rxn<Int64> hoveredLine;

  @override
  State<_TreeRow> createState() => _TreeRowState();
}

class _TreeRowState extends State<_TreeRow> {
  static const double _hitHalf = 14;
  int? _hovered;
  Offset? _down; // 原始指针按下位置（Listener 手动识别点击）
  DateTime? _downTime;

  double _lineX(int k) =>
      ReplyTreeGuidePainter.avatarCenter + widget.indent.indentAt(k);

  /// 返回 local 坐标命中的引导线级别（0=主引导线，1..depth=祖先线，depth+1=自己的线），未命中返回 null。
  /// 仅在实际绘制引导线的范围内命中：祖先线受 lineAtLevel/lastAtLevel 约束，自己的线避开按钮圆空角。
  int? _levelAt(Offset local) {
    const double aY = ReplyTreeGuidePainter.avatarY;
    const double aR = ReplyTreeGuidePainter.avatarRadius;
    final d = widget.row.depth;
    final double arcR = ReplyTreeGuidePainter.arcRadiusAt(widget.indent, d);
    final dy = local.dy;
    final dx = local.dx;
    // 入弧区
    if (dy >= aY - arcR - 4 &&
        dy <= aY + 4 &&
        dx >= _lineX(d) - 2 &&
        dx <= _lineX(d + 1) - aR) {
      return d;
    }
    // 祖先线 k=0..d：仅本行绘制该层线且落在线纵向范围内
    for (var k = 0; k <= d; k++) {
      if (widget.row.lineAtLevel.isNotEmpty && !widget.row.lineAtLevel[k]) {
        continue;
      }
      if ((dx - _lineX(k)).abs() > _hitHalf) continue;
      final last = widget.row.lastAtLevel.isNotEmpty &&
          widget.row.lastAtLevel[k];
      final yEnd = last ? (k == d ? aY - arcR : aY) : double.infinity;
      if (dy <= yEnd) return k;
    }
    // 自己的线（d+1）：stub 段 + 按钮圆 + 展开态下段
    if (widget.row.hasChildren) {
      final x = _lineX(d + 1);
      if ((dx - x).abs() <= _hitHalf) {
        const by = ReplyTreeGuidePainter.buttonY;
        const bR = ReplyTreeGuidePainter.buttonRadius;
        if (dy >= aY + aR && dy <= by - bR) return d + 1; // stub 段
        if (_inCircle(Offset(x, by), bR, local)) return d + 1; // 按钮圆内
        if (!widget.collapsedRpids.contains(widget.row.reply.id) &&
            dy >= by + bR) {
          return d + 1; // 展开态下段
        }
      }
    }
    return null;
  }

  void _toggle(int k) {
    final Int64 rpid;
    if (k == 0) {
      rpid = Int64(widget.headerRpid);
    } else if (k <= widget.row.depth) {
      rpid = widget.row.ancestors[k - 1];
    } else {
      rpid = widget.row.reply.id;
    }
    widget.onToggleCollapse(rpid);
  }

  /// 引导线级别 k 在本行对应节点（线的 OWNER）rpid：0=头部评论，1..depth=祖先，depth+1=本行自己的线。
  Int64? _lineKey(int? k) {
    if (k == null) return null;
    if (k == 0) return Int64(widget.headerRpid);
    if (k <= widget.row.depth) return widget.row.ancestors[k - 1];
    return widget.row.reply.id; // 自己的线
  }

  @override
  Widget build(BuildContext context) {
    final row = widget.row;
    return MouseRegion(
      cursor: _hovered != null ? SystemMouseCursors.click : MouseCursor.defer,
      onHover: (e) {
        final k = _levelAt(e.localPosition);
        final key = _lineKey(k);
        if (key != null) {
          if (key != widget.hoveredLine.value) {
            widget.hoveredLine.value = key;
          }
        } else {
          if (widget.hoveredLine.value != null) {
            widget.hoveredLine.value = null;
          }
        }
        if (k != _hovered) setState(() => _hovered = k);
      },
      onExit: (_) {
        widget.hoveredLine.value = null;
        setState(() => _hovered = null);
      },
      child: Listener(
        onPointerDown: (e) {
          _down = e.localPosition;
          _downTime = DateTime.now();
        },
        onPointerUp: (e) {
          final k = _levelAt(e.localPosition);
          final down = _down;
          final t = _downTime;
          _down = null;
          _downTime = null;
          if (k == null || down == null || t == null) return;
          final moved = (e.localPosition - down).distance;
          if (moved < kTouchSlop &&
              DateTime.now().difference(t).inMilliseconds < 300) {
            _toggle(k);
          }
        },
        child: Obx(() {
          final hovered = widget.hoveredLine.value;
          final levels = <int>{};
          if (hovered != null) {
            for (var k = 0; k <= row.depth; k++) {
              if (_lineKey(k) == hovered) levels.add(k);
            }
          }
          final own = row.hasChildren && hovered == row.reply.id;
          return CustomPaint(
            painter: ReplyTreeGuidePainter(
              depth: row.depth,
              indent: widget.indent,
              color: widget.colorScheme.outline.withValues(alpha: 0.3),
              highlightColor: widget.colorScheme.primary,
              lastAtLevel: row.lastAtLevel,
              lineAtLevel: row.lineAtLevel,
              hasOwnLine: row.hasChildren,
              collapsed: widget.collapsedRpids.contains(row.reply.id),
              highlightLevels: levels,
              highlightOwn: own,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: widget.indent.indentAt(row.depth + 1),
              ),
              child: widget.replyWidget,
            ),
          );
        }),
      ),
    );
  }
}

class _DeepLinkRow extends StatefulWidget {
  const _DeepLinkRow({
    required this.depth,
    required this.rpid,
    required this.count,
    required this.ancestors,
    required this.lastAtLevel,
    required this.lineAtLevel,
    required this.indent,
    required this.colorScheme,
    required this.headerRpid,
    required this.collapsedRpids,
    required this.onToggleCollapse,
    required this.onOpen,
    required this.hoveredLine,
  });
  final int depth;
  final Int64 rpid;
  final int count;
  final List<Int64> ancestors;
  final List<bool> lastAtLevel;
  final List<bool> lineAtLevel;
  final ReplyTreeIndent indent;
  final ColorScheme colorScheme;
  final int headerRpid;
  final Set<Int64> collapsedRpids;
  final ValueChanged<Int64> onToggleCollapse;
  final VoidCallback onOpen;
  final Rxn<Int64> hoveredLine;

  @override
  State<_DeepLinkRow> createState() => _DeepLinkRowState();
}

class _DeepLinkRowState extends State<_DeepLinkRow> {
  static const double _hitHalf = 14;
  int? _hovered;
  Offset? _down;
  DateTime? _downTime;

  double _lineX(int k) =>
      ReplyTreeGuidePainter.avatarCenter + widget.indent.indentAt(k);

  /// 深链接行仅绘制祖先线：受 lineAtLevel/lastAtLevel 约束，最深一层收尾于行中部（terminalY）。
  int? _levelAt(Offset local) {
    final h = context.size?.height ?? 0;
    final double terminalY = h / 2;
    final double arcR = ReplyTreeGuidePainter.arcRadiusAt(
      widget.indent,
      widget.depth,
    );
    final dy = local.dy;
    for (var k = 0; k <= widget.depth; k++) {
      if (widget.lineAtLevel.isNotEmpty && !widget.lineAtLevel[k]) continue;
      if ((local.dx - _lineX(k)).abs() > _hitHalf) continue;
      final last = widget.lastAtLevel.isNotEmpty && widget.lastAtLevel[k];
      final yEnd = last
          ? (k == widget.depth ? terminalY - arcR : terminalY)
          : double.infinity;
      if (dy <= yEnd) return k;
    }
    return null;
  }

  void _toggle(int k) {
    final Int64 rpid = k == 0
        ? Int64(widget.headerRpid)
        : widget.ancestors[k - 1];
    widget.onToggleCollapse(rpid);
  }

  /// 引导线级别 k 在本行对应节点（线的 OWNER）rpid：0=头部评论，1..depth=祖先（无自己的线）。
  Int64? _lineKey(int? k) {
    if (k == null) return null;
    return k == 0 ? Int64(widget.headerRpid) : widget.ancestors[k - 1];
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _hovered != null ? SystemMouseCursors.click : MouseCursor.defer,
      onHover: (e) {
        final k = _levelAt(e.localPosition);
        final key = _lineKey(k);
        if (key != null) {
          if (key != widget.hoveredLine.value) {
            widget.hoveredLine.value = key;
          }
        } else {
          if (widget.hoveredLine.value != null) {
            widget.hoveredLine.value = null;
          }
        }
        if (k != _hovered) setState(() => _hovered = k);
      },
      onExit: (_) {
        widget.hoveredLine.value = null;
        setState(() => _hovered = null);
      },
      // Listener 识别祖先引导线点击；按钮的 InkWell 不受影响
      child: Listener(
        onPointerDown: (e) {
          _down = e.localPosition;
          _downTime = DateTime.now();
        },
        onPointerUp: (e) {
          final k = _levelAt(e.localPosition);
          final down = _down;
          final t = _downTime;
          _down = null;
          _downTime = null;
          if (k == null || down == null || t == null) return;
          final moved = (e.localPosition - down).distance;
          if (moved < kTouchSlop &&
              DateTime.now().difference(t).inMilliseconds < 300) {
            _toggle(k);
          }
        },
        child: Obx(() {
          final hovered = widget.hoveredLine.value;
          final levels = <int>{};
          if (hovered != null) {
            for (var k = 0; k <= widget.depth; k++) {
              if (_lineKey(k) == hovered) levels.add(k);
            }
          }
          return CustomPaint(
            painter: ReplyTreeGuidePainter(
              depth: widget.depth,
              indent: widget.indent,
              color: widget.colorScheme.outline.withValues(alpha: 0.3),
              highlightColor: widget.colorScheme.primary,
              lastAtLevel: widget.lastAtLevel,
              lineAtLevel: widget.lineAtLevel,
              hasOwnLine: false,
              collapsed: false,
              isDeepLink: true,
              highlightLevels: levels,
              highlightOwn: false,
            ),
            child: InkWell(
              onTap: widget.onOpen,
              child: Padding(
                padding: EdgeInsets.only(
                  left: widget.indent.indentAt(widget.depth + 1) + 12,
                  top: 6,
                  bottom: 6,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.subdirectory_arrow_right,
                      size: 18,
                      color: widget.colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '继续此讨论串（${widget.count} 条回复）',
                      style: TextStyle(
                        fontSize: 13,
                        color: widget.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _HeaderGuide extends StatefulWidget {
  const _HeaderGuide({
    required this.child,
    required this.headerRpid,
    required this.colorScheme,
    required this.collapsedRpids,
    required this.onToggleCollapse,
    required this.hoveredLine,
  });
  final Widget child;
  final int headerRpid;
  final ColorScheme colorScheme;
  final Set<Int64> collapsedRpids;
  final ValueChanged<Int64> onToggleCollapse;
  final Rxn<Int64> hoveredLine;

  @override
  State<_HeaderGuide> createState() => _HeaderGuideState();
}

class _HeaderGuideState extends State<_HeaderGuide> {
  static const double _hitHalf = 14;
  bool _hovered = false;
  Offset? _down;
  DateTime? _downTime;

  /// 主引导线命中范围与渲染一致：上段（头像下沿→按钮上缘）、按钮圆内、展开态下段（按钮下缘→底）。
  bool _inLine(Offset p) {
    const double aY = ReplyTreeGuidePainter.avatarY;
    const double aR = ReplyTreeGuidePainter.avatarRadius;
    const double bR = ReplyTreeGuidePainter.buttonRadius;
    const double by = ReplyTreeGuidePainter.buttonY;
    final double dy = p.dy;
    if ((p.dx - ReplyTreeGuidePainter.avatarCenter).abs() > _hitHalf) {
      return false;
    }
    if (dy < aY + aR) return false; // 头像下沿以上无线
    if (dy <= by - bR) return true; // 上段
    if (dy <= by + bR) {
      // 按钮圆带：仅圆内命中（圆外空角无线）
      return _inCircle(
        const Offset(ReplyTreeGuidePainter.avatarCenter, by),
        bR,
        p,
      );
    }
    // 按钮下缘以下：仅展开态有线
    return !widget.collapsedRpids.contains(Int64(widget.headerRpid));
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _hovered ? SystemMouseCursors.click : MouseCursor.defer,
      onHover: (e) {
        final on = _inLine(e.localPosition);
        if (on) {
          final key = Int64(widget.headerRpid);
          if (key != widget.hoveredLine.value) {
            widget.hoveredLine.value = key;
          }
        } else {
          if (widget.hoveredLine.value != null) {
            widget.hoveredLine.value = null;
          }
        }
        if (on != _hovered) setState(() => _hovered = on);
      },
      onExit: (_) {
        widget.hoveredLine.value = null;
        setState(() => _hovered = false);
      },
      // Listener 识别主引导线点击（头部评论的 InkWell 覆盖全块，GestureDetector 会输掉竞技场）
      child: Listener(
        onPointerDown: (e) {
          _down = e.localPosition;
          _downTime = DateTime.now();
        },
        onPointerUp: (e) {
          final inLine = _inLine(e.localPosition);
          final down = _down;
          final t = _downTime;
          _down = null;
          _downTime = null;
          if (!inLine || down == null || t == null) return;
          final moved = (e.localPosition - down).distance;
          if (moved < kTouchSlop &&
              DateTime.now().difference(t).inMilliseconds < 300) {
            widget.onToggleCollapse(Int64(widget.headerRpid));
          }
        },
        child: Obx(
          () => CustomPaint(
            painter: HeaderGuidePainter(
              color: widget.colorScheme.outline.withValues(alpha: 0.3),
              highlightColor: widget.colorScheme.primary,
              collapsed:
                  widget.collapsedRpids.contains(Int64(widget.headerRpid)),
              hovered: widget.hoveredLine.value == Int64(widget.headerRpid),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// 排序条处的主引导线段：与 header/树行的主引导线共享 hoveredLine，整条线联动高亮；
/// 点击折叠整树（与 _HeaderGuide 一致）。
class _SortStripGuide extends StatefulWidget {
  const _SortStripGuide({
    required this.child,
    required this.headerRpid,
    required this.colorScheme,
    required this.onToggleCollapse,
    required this.hoveredLine,
  });
  final Widget child;
  final int headerRpid;
  final ColorScheme colorScheme;
  final ValueChanged<Int64> onToggleCollapse;
  final Rxn<Int64> hoveredLine;

  @override
  State<_SortStripGuide> createState() => _SortStripGuideState();
}

class _SortStripGuideState extends State<_SortStripGuide> {
  static const double _hitHalf = 14;
  bool _hovered = false;
  Offset? _down;
  DateTime? _downTime;

  bool _inLine(Offset p) =>
      (p.dx - ReplyTreeGuidePainter.avatarCenter).abs() <= _hitHalf;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _hovered ? SystemMouseCursors.click : MouseCursor.defer,
      onHover: (e) {
        final on = _inLine(e.localPosition);
        final key = Int64(widget.headerRpid);
        if (on) {
          if (key != widget.hoveredLine.value) {
            widget.hoveredLine.value = key;
          }
        } else {
          if (widget.hoveredLine.value != null) {
            widget.hoveredLine.value = null;
          }
        }
        if (on != _hovered) setState(() => _hovered = on);
      },
      onExit: (_) {
        widget.hoveredLine.value = null;
        setState(() => _hovered = false);
      },
      child: Listener(
        onPointerDown: (e) {
          _down = e.localPosition;
          _downTime = DateTime.now();
        },
        onPointerUp: (e) {
          final down = _down;
          final t = _downTime;
          _down = null;
          _downTime = null;
          if (!_inLine(e.localPosition) || down == null || t == null) return;
          final moved = (e.localPosition - down).distance;
          if (moved < kTouchSlop &&
              DateTime.now().difference(t).inMilliseconds < 300) {
            widget.onToggleCollapse(Int64(widget.headerRpid));
          }
        },
        child: Obx(
          () => CustomPaint(
            painter: SingleVerticalPainter(
              color: widget.colorScheme.outline.withValues(alpha: 0.3),
              highlightColor: widget.colorScheme.primary,
              hovered:
                  widget.hoveredLine.value == Int64(widget.headerRpid),
              x: ReplyTreeGuidePainter.avatarCenter,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class ReplyTreeGuidePainter extends CustomPainter {
  ReplyTreeGuidePainter({
    required this.depth,
    required this.indent,
    required this.color,
    required this.highlightColor,
    required this.lastAtLevel,
    required this.lineAtLevel,
    required this.hasOwnLine,
    required this.collapsed,
    this.isDeepLink = false,
    this.highlightLevels = const {},
    this.highlightOwn = false,
  });

  static const double avatarCenter = 29; // 主引导线 x（头部评论头像中心距行左）
  static const double avatarY = 31; // 头像中心距行顶
  static const double avatarRadius = 17;
  static const double arcRadius = 12;
  static const double buttonRadius = 8;
  static const double buttonY = avatarY + avatarRadius + 16; // 折叠按钮圆心 y

  final int depth;
  final ReplyTreeIndent indent;
  final Color color;
  final Color highlightColor;
  final List<bool> lastAtLevel;
  final List<bool> lineAtLevel;
  final bool hasOwnLine;
  final bool collapsed;
  final bool isDeepLink;
  final Set<int> highlightLevels;
  final bool highlightOwn;

  double _lineX(int k) => avatarCenter + indent.indentAt(k);

  /// 第 depth 层入弧半径：受该层步进与头像半径约束，兜底 ≥0。
  static double arcRadiusAt(ReplyTreeIndent indent, int depth) =>
      math.max(0, math.min(arcRadius, indent.stepAt(depth) - avatarRadius));

  @override
  void paint(Canvas canvas, Size size) {
    final normal = Paint()
      ..color = color
      ..strokeWidth = 1.75
      // 平头帽：逐行拼接的竖线/入弧在行交界与肘部不产生重叠叠加（圆头帽会叠出暗珠）
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
    final hover = Paint()
      ..color = highlightColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    final terminalY = isDeepLink ? size.height / 2 : avatarY;
    final arcR = arcRadiusAt(indent, depth);
    // 祖先竖线 k=0..depth（lineAtLevel 为 false 的行不再绘制该层线）
    for (var k = 0; k <= depth; k++) {
      if (lineAtLevel.isNotEmpty && !lineAtLevel[k]) continue;
      final last = lastAtLevel.isNotEmpty && lastAtLevel[k];
      final y1 = last
          ? (k == depth ? terminalY - arcR : terminalY)
          : size.height;
      canvas.drawLine(
        Offset(_lineX(k), 0),
        Offset(_lineX(k), y1),
        highlightLevels.contains(k) ? hover : normal,
      );
    }

    if (isDeepLink) return; // 按钮行：无线以下、无入弧

    // 入弧：level depth 的线 → 本行头像左缘
    final arc = Path()
      ..moveTo(_lineX(depth), avatarY - arcR)
      ..quadraticBezierTo(
        _lineX(depth),
        avatarY,
        _lineX(depth) + arcR,
        avatarY,
      )
      ..lineTo(_lineX(depth + 1) - avatarRadius, avatarY);
    canvas.drawPath(arc, highlightLevels.contains(depth) ? hover : normal);

    // 自己的线 / stub + ⊖⊕
    if (!hasOwnLine) return;
    final x = _lineX(depth + 1);
    final p = highlightOwn ? hover : normal;
    const buttonTop = buttonY - buttonRadius;
    if (collapsed) {
      canvas.drawLine(Offset(x, avatarY + avatarRadius), Offset(x, buttonTop), p);
      paintTreeCollapseButton(
        canvas,
        Offset(x, buttonY),
        plus: true,
        highlighted: highlightOwn,
        color: color,
        highlightColor: highlightColor,
      );
    } else {
      canvas
        ..drawLine(Offset(x, avatarY + avatarRadius), Offset(x, buttonTop), p)
        ..drawLine(Offset(x, buttonY + buttonRadius), Offset(x, size.height), p);
      paintTreeCollapseButton(
        canvas,
        Offset(x, buttonY),
        plus: false,
        highlighted: highlightOwn,
        color: color,
        highlightColor: highlightColor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ReplyTreeGuidePainter old) =>
      old.depth != depth ||
      old.indent.base != indent.base ||
      old.indent.decay != indent.decay ||
      old.indent.minStep != indent.minStep ||
      old.color != color ||
      old.highlightColor != highlightColor ||
      old.lastAtLevel != lastAtLevel ||
      old.lineAtLevel != lineAtLevel ||
      old.hasOwnLine != hasOwnLine ||
      old.collapsed != collapsed ||
      old.isDeepLink != isDeepLink ||
      old.highlightLevels != highlightLevels ||
      old.highlightOwn != highlightOwn;
}

/// 绘制 ⊖/⊕ 折叠按钮（圆 + 减号/加号）。highlighted 时填充高亮色、符号白色。
void paintTreeCollapseButton(
  Canvas canvas,
  Offset center, {
  required bool plus,
  required bool highlighted,
  required Color color,
  required Color highlightColor,
  double radius = ReplyTreeGuidePainter.buttonRadius,
}) {
  final fill = Paint()
    ..color = highlighted ? highlightColor : color.withValues(alpha: 0.15);
  final stroke = Paint()
    ..color = highlighted ? Colors.white : color
    ..strokeWidth = 1.5;
  canvas
    ..drawCircle(center, radius, fill)
    ..drawCircle(center, radius, stroke);
  final glyph = Paint()
    ..color = highlighted ? Colors.white : color
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round;
  final arm = radius - 3;
  canvas.drawLine(center - Offset(arm, 0), center + Offset(arm, 0), glyph);
  if (plus) {
    canvas.drawLine(center - Offset(0, arm), center + Offset(0, arm), glyph);
  }
}

/// 主引导线（头部评论头像下方那条）：从头像下沿到 widget 底部；整树折叠时 stub + ⊕。
class HeaderGuidePainter extends CustomPainter {
  HeaderGuidePainter({
    required this.color,
    required this.highlightColor,
    required this.collapsed,
    required this.hovered,
  });
  final Color color;
  final Color highlightColor;
  final bool collapsed;
  final bool hovered;

  @override
  void paint(Canvas canvas, Size size) {
    const x = ReplyTreeGuidePainter.avatarCenter;
    const top = ReplyTreeGuidePainter.avatarY + ReplyTreeGuidePainter.avatarRadius;
    const by = top + 16;
    // 线在按钮圆处断开，避免穿过 ⊖/⊕ 圆圈造成符号混淆
    const buttonTop = by - ReplyTreeGuidePainter.buttonRadius;
    final p = Paint()
      ..color = hovered ? highlightColor : color
      ..strokeWidth = hovered ? 3 : 1.75
      ..strokeCap = StrokeCap.round;
    if (collapsed) {
      canvas.drawLine(const Offset(x, top), const Offset(x, buttonTop), p);
    } else {
      canvas
        ..drawLine(const Offset(x, top), const Offset(x, buttonTop), p)
        ..drawLine(
          const Offset(x, by + ReplyTreeGuidePainter.buttonRadius),
          Offset(x, size.height),
          p,
        );
    }
    paintTreeCollapseButton(
      canvas,
      const Offset(x, by),
      plus: collapsed,
      highlighted: hovered,
      color: color,
      highlightColor: highlightColor,
    );
  }

  @override
  bool shouldRepaint(covariant HeaderGuidePainter old) =>
      old.color != color ||
      old.highlightColor != highlightColor ||
      old.collapsed != collapsed ||
      old.hovered != hovered;
}

/// 单条竖直引导线（排序条处的主引导线段；hovered 时高亮加粗，联动整条主引导线）。
class SingleVerticalPainter extends CustomPainter {
  SingleVerticalPainter({
    required this.color,
    required this.x,
    required this.highlightColor,
    this.hovered = false,
  });
  final Color color;
  final Color highlightColor;
  final bool hovered;
  final double x;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(x, 0),
      Offset(x, size.height),
      Paint()
        ..color = hovered ? highlightColor : color
        ..strokeWidth = hovered ? 3 : 1.75
        ..strokeCap = StrokeCap.butt,
    );
  }
  @override
  bool shouldRepaint(covariant SingleVerticalPainter old) =>
      old.color != color ||
      old.x != x ||
      old.hovered != hovered ||
      old.highlightColor != highlightColor;
}
