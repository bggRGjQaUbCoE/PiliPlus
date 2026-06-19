import 'dart:math';

import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/flutter/text_field/controller.dart';
import 'package:PiliPlus/common/widgets/icon/bili_icons.dart';
import 'package:PiliPlus/common/widgets/icon/custom_icons.dart';
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/common/widgets/scaffold.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart';
import 'package:PiliPlus/common/widgets/sliver/sliver_floating_header.dart';
import 'package:PiliPlus/common/widgets/sliver/sliver_to_box_adapter.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/reply/reply_option_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/common/dyn/common_dyn_page.dart';
import 'package:PiliPlus/pages/common/dyn/reaction/controller.dart';
import 'package:PiliPlus/pages/common/dyn/reaction/view.dart';
import 'package:PiliPlus/pages/dynamics/widgets/author_panel.dart';
import 'package:PiliPlus/pages/dynamics/widgets/dynamic_panel.dart';
import 'package:PiliPlus/pages/dynamics_create/view.dart';
import 'package:PiliPlus/pages/dynamics_detail/controller.dart';
import 'package:PiliPlus/pages/dynamics_repost/view.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/share_utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DynamicDetailPage extends StatefulWidget {
  const DynamicDetailPage({super.key});

  @override
  State<DynamicDetailPage> createState() => _DynamicDetailPageState();
}

class _DynamicDetailPageState
    extends CommonDynPageMultiState<DynamicDetailPage> {
  @override
  late final DynamicDetailController controller;
  late final DynReactController _reactController;

  late final RxBool _isRefreshing = false.obs;

  void _startRefresh() {
    _isRefreshing.value = true;
    _refreshController.repeat();
  }

  void _stopRefresh() {
    if (!mounted) return;
    _isRefreshing.value = false;
    _refreshController.stop();
  }

  void _onRefresh(Future<void> future) {
    _startRefresh();
    future.whenComplete(_stopRefresh);
    // Future.delayed(
    //   const Duration(milliseconds: 800),
    // ).whenComplete(_stopRefresh);
  }

  late final AnimationController _refreshController;

  @override
  dynamic get arguments => {'item': controller.dynItem};

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    final item = args['item'] as DynamicItemModel;
    final id = item.idStr.toString();
    if (args['viewComment'] ?? false) {
      WidgetsBinding.instance.addPostFrameCallback(_jumpToComment);
    }
    controller = Get.putOrFind(DynamicDetailController.new, tag: id);
    final stat = item.modules.moduleStat;
    controller.count.value = stat?.comment?.count ?? -1;
    _reactController = Get.put(
      DynReactController(
        id,
        count: (stat?.like?.count ?? -1) + (stat?.forward?.count ?? -1),
      ),
      tag: id,
    );
    _refreshController = AnimationController(
      vsync: this,
      duration: CircularProgressIndicator.defaultAnimationDuration,
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        clipBehavior: .none,
        children: [
          Padding(
            padding: .only(left: padding.left, right: padding.right),
            child: _buildBody(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SlideTransition(
              position: fabAnimation,
              child: _buildBottom(),
            ),
          ),
        ],
      ),
    );
  }

  void _onEdit() {
    final item = controller.dynItem;
    List<RichTextItem>? items;
    final moduleDynamic = item.modules.moduleDynamic;
    final desc = moduleDynamic?.desc;
    final opus = moduleDynamic?.major?.opus;

    Pair<int, String>? topic;
    if (moduleDynamic?.topic case final t?) {
      try {
        topic = Pair(first: t.id!, second: t.name!);
      } catch (_) {
        if (kDebugMode) rethrow;
      }
    }

    final richTextNodes = desc?.richTextNodes ?? opus?.summary?.richTextNodes;
    if (richTextNodes != null && richTextNodes.isNotEmpty) {
      items = <RichTextItem>[];
      final buffer = StringBuffer();
      try {
        for (final e in richTextNodes) {
          if (e.type == 'RICH_TEXT_NODE_TYPE_EMOJI') {
            const placeHolder = '\uFFFC';
            items.add(
              RichTextItem(
                text: placeHolder,
                rawText: e.origText,
                type: .emoji,
                range: TextRange(
                  start: buffer.length,
                  end: buffer.length + placeHolder.length,
                ),
                emote: Emote(
                  url: e.emoji!.url!,
                  width: 22,
                ),
              ),
            );
            buffer.write(placeHolder);
            continue;
          }
          final range = TextRange(
            start: buffer.length,
            end: buffer.length + e.origText!.length,
          );
          final item = switch (e.type) {
            'RICH_TEXT_NODE_TYPE_AT' => RichTextItem(
              text: e.origText!,
              type: .at,
              range: range,
              id: e.rid,
            ),
            'RICH_TEXT_NODE_TYPE_BV' ||
            'RICH_TEXT_NODE_TYPE_TOPIC' ||
            'RICH_TEXT_NODE_TYPE_LOTTERY' ||
            'RICH_TEXT_NODE_TYPE_VIEW_PICTURE' => RichTextItem(
              text: e.origText!,
              type: .common,
              range: range,
              id: e.rid,
            ),
            'RICH_TEXT_NODE_TYPE_VOTE' => RichTextItem(
              text: e.origText!,
              type: .vote,
              range: range,
              id: e.rid,
            ),
            _ => RichTextItem(
              text: e.origText!,
              range: range,
            ),
          };
          items.add(item);
          buffer.write(e.origText!);
        }

        bool isValid = true;
        int cursor = 0;
        for (final e in items) {
          final range = e.range;
          if (range.start == cursor) {
            cursor = range.end;
          } else {
            isValid = false;
            break;
          }
        }
        assert(isValid);
      } catch (e) {
        if (kDebugMode) rethrow;
      }
    } else {
      final text = desc?.text ?? opus?.summary?.text;
      if (text != null && text.isNotEmpty) {
        items = [
          RichTextItem.fromStart(text),
        ];
      }
    }
    ReplyOptionType? replyOption;
    if (controller.loadingState.value case Error(:final code)) {
      if (code == 12061 || code == 12002) {
        replyOption = .close;
      }
    }
    CreateDynPanel.onCreateDyn(
      context,
      title: opus?.title,
      items: items,
      pics: opus?.pics,
      topic: topic,
      replyOption: replyOption ?? .allow,
      isPrivate: item.modules.moduleAuthor?.badgeText != null,
      editConfig: (
        dynId: item.idStr,
        repostDynId: item.orig?.idStr,
      ),
      onSuccess: () {
        Future.delayed(
          const Duration(milliseconds: 500),
          () async {
            if (!mounted) return;
            final res = await DynamicsHttp.dynamicDetail(id: item.idStr);
            if (res case Success(:final response)) {
              if (mounted) {
                controller.dynItem = response;
                setState(() {});
              }
            }
          },
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
    title: Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Obx(
        () {
          final showTitle = controller.showTitle.value;
          return AnimatedOpacity(
            opacity: showTitle ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: IgnorePointer(
              ignoring: !showTitle,
              child: AuthorPanel(
                item: controller.dynItem,
                isDetail: true,
                onSetPubSetting: controller.onSetPubSetting,
                onEdit: _onEdit,
                onSetReplySubject: controller.onSetReplySubject,
              ),
            ),
          );
        },
      ),
    ),
    actions: isPortrait
        ? null
        : [ratioWidget(maxWidth), const SizedBox(width: 16)],
  );

  Widget _buildTabBar() {
    return SizedBox(
      height: 40,
      child: TabBar(
        padding: .zero,
        isScrollable: true,
        indicatorSize: .tab,
        tabAlignment: .start,
        controller: tabController,
        labelPadding: const .symmetric(horizontal: 12),
        dividerColor: theme.colorScheme.outline.withValues(alpha: 0.1),
        onTap: (value) {
          if (!tabController.indexIsChanging) {
            final positions = PrimaryScrollController.of(context).positions;
            if (positions.length == 1) {
              final postion = positions.single;
              if (postion.pixels >= postion.maxScrollExtent) {
                postion.jumpTo(postion.pixels);
              }
            }
            switch (value) {
              case 0:
                _onRefresh(controller.onRefresh());
              case 1:
                _onRefresh(_reactController.onRefresh());
            }
          }
        },
        tabs: [
          Tab(
            child: Obx(() {
              final count = controller.count.value;
              return Text(
                '${DynType.reply.label}${count < 0 ? '' : ' ${NumUtils.numFormat(count)}'}',
              );
            }),
          ),
          Tab(
            child: Obx(() {
              final count = _reactController.count.value;
              return Text(
                '${DynType.reaction.label}${count < 0 ? '' : ' ${NumUtils.numFormat(count)}'}',
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBody([bool isPortrait = true]) {
    final reply = CustomScrollView(
      key: const PageStorageKey(DynType.reply),
      physics: ReloadScrollPhysics(controller: controller),
      slivers: [
        buildReplyHeader(isPortrait),
        Obx(() => replyList(controller.loadingState.value)),
      ],
    );
    return Stack(
      clipBehavior: .none,
      children: [
        tabBarView(
          controller: tabController,
          children: [
            isPortrait
                ? reply
                : refreshIndicator(
                    onRefresh: controller.onRefresh,
                    child: reply,
                  ),
            DynReactPage(
              isPortrait: isPortrait,
              id: controller.dynItem.idStr,
              controller: _reactController,
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          top: displacement,
          child: Obx(() {
            final isRefreshing = _isRefreshing.value;
            return AnimatedScale(
              scale: isRefreshing ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Center(
                child: SizedBox.fromSize(
                  size: const .square(40),
                  child: Material(
                    type: .circle,
                    color: theme.colorScheme.onSecondary,
                    elevation: 2.0,
                    child: Padding(
                      padding: const .all(6),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        controller: _refreshController,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPortrait(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxWithOffsetAdapter(
              offset: 55,
              onVisibilityChanged: controller.showTitle.call,
              child: DynamicPanel(
                item: controller.dynItem,
                isDetail: true,
                isDetailPortraitW: isPortrait,
                onSetPubSetting: controller.onSetPubSetting,
                onEdit: _onEdit,
                onSetReplySubject: controller.onSetReplySubject,
              ),
            ),
          ];
        },
        body: Column(
          children: [
            _buildTabBar(),
            Expanded(child: _buildTabBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontal(double padding) {
    padding = padding / 4;
    final flex = controller.ratio[0].toInt();
    final flex1 = controller.ratio[1].toInt();
    return Row(
      children: [
        Expanded(
          flex: flex,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: .only(
                  left: padding,
                  bottom: this.padding.bottom + 100,
                ),
                sliver: SliverToBoxWithOffsetAdapter(
                  offset: 55,
                  onVisibilityChanged: controller.showTitle.call,
                  child: DynamicPanel(
                    item: controller.dynItem,
                    isDetail: true,
                    isDetailPortraitW: isPortrait,
                    onSetPubSetting: controller.onSetPubSetting,
                    onEdit: _onEdit,
                    onSetReplySubject: controller.onSetReplySubject,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: flex1,
          child: Padding(
            padding: EdgeInsets.only(right: padding),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: Column(
                children: [
                  _buildTabBar(),
                  Expanded(child: _buildTabBody(false)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    double padding = max(maxWidth / 2 - Grid.smallCardWidth, 0);
    Widget child;
    if (isPortrait) {
      child = _buildPortrait(padding);
    } else {
      child = _buildHorizontal(padding);
    }
    return fabAnimWrapper(child);
  }

  Widget _buildBottom() {
    final primary = theme.colorScheme.primary;
    final outline = theme.colorScheme.outline;
    final btnStyle = TextButton.styleFrom(
      tapTargetSize: .padded,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      foregroundColor: outline,
    );

    Widget textIconButton({
      required IconData icon,
      required String text,
      required DynamicStat? stat,
      required ValueChanged<Color> onPressed,
      IconData? activatedIcon,
    }) {
      final status = stat?.status == true;
      final color = status ? primary : outline;
      final iconWidget = Icon(
        status ? activatedIcon : icon,
        size: 16,
        color: color,
      );
      return TextButton.icon(
        onPressed: () => onPressed(iconWidget.color!),
        icon: iconWidget,
        style: btnStyle,
        label: Text(
          stat?.count != null ? NumUtils.numFormat(stat!.count) : text,
          style: TextStyle(color: color),
        ),
      );
    }

    final moduleStat = controller.dynItem.modules.moduleStat;
    return Padding(
      padding: .only(left: padding.left, right: padding.right),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: kFloatingActionButtonMargin,
              bottom: kFloatingActionButtonMargin,
            ),
            child: replyButton,
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withValues(
                    alpha: 0.08,
                  ),
                ),
              ),
            ),
            padding: EdgeInsets.only(bottom: padding.bottom),
            child: Row(
              children: [
                Expanded(
                  child: Builder(
                    builder: (btnContext) {
                      final forward = moduleStat?.forward;
                      return textIconButton(
                        icon: BiliIcons.ic_share,
                        text: '转发',
                        stat: forward,
                        onPressed: (_) => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          builder: (context) => RepostPanel(
                            item: controller.dynItem,
                            onSuccess: () {
                              if (forward != null) {
                                int count = forward.count ?? 0;
                                forward.count = count + 1;
                                if (btnContext.mounted) {
                                  (btnContext as Element).markNeedsBuild();
                                }
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: textIconButton(
                    icon: CustomIcons.share_node,
                    text: '分享',
                    stat: null,
                    onPressed: (_) => ShareUtils.shareText(
                      '${HttpString.dynamicShareBaseUrl}/${controller.dynItem.idStr}',
                    ),
                  ),
                ),
                Expanded(
                  child: textIconButton(
                    icon: BiliIcons.ic_comment,
                    text: '评论',
                    stat: moduleStat?.comment,
                    onPressed: _jumpToComment,
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      return textIconButton(
                        icon: BiliIcons.ic_like,
                        activatedIcon: BiliIcons.ic_liked,
                        text: '点赞',
                        stat: moduleStat?.like,
                        onPressed: (iconColor) => RequestUtils.onLikeDynamic(
                          controller.dynItem,
                          iconColor == primary,
                          () {
                            if (context.mounted) {
                              (context as Element).markNeedsBuild();
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildReplyHeader([bool isPortrait = true]) {
    final secondary = theme.colorScheme.secondary;
    final child = Padding(
      padding: const .fromLTRB(12, 2.5, 6, 2.5),
      child: Obx(
        () {
          final sortType = controller.sortType.value;
          return Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(sortType.title),
              TextButton.icon(
                style: Style.buttonStyle,
                onPressed: controller.queryBySort,
                icon: Icon(Icons.sort, size: 16, color: secondary),
                label: Text(
                  sortType.label,
                  style: TextStyle(fontSize: 13, color: secondary),
                ),
              ),
            ],
          );
        },
      ),
    );
    return SliverFloatingHeaderWidget(
      backgroundColor: theme.colorScheme.surface,
      child: child,
    );
  }

  void _jumpToComment([_]) {
    if (!isPortrait) return;
    try {
      final position = PrimaryScrollController.of(context).position;
      position.jumpTo(position.maxScrollExtent);
    } catch (_) {}
  }
}
