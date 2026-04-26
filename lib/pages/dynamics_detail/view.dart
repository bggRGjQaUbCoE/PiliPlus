import 'dart:math';

import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/flutter/text_field/controller.dart';
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/reply/reply_option_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/common/dyn/common_dyn_page.dart';
import 'package:PiliPlus/pages/dynamics/widgets/author_panel.dart';
import 'package:PiliPlus/pages/dynamics/widgets/dynamic_panel.dart';
import 'package:PiliPlus/pages/dynamics_create/view.dart';
import 'package:PiliPlus/pages/dynamics_detail/controller.dart';
import 'package:PiliPlus/pages/dynamics_repost/view.dart';
import 'package:PiliPlus/utils/extension/get_ext.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DynamicDetailPage extends StatefulWidget {
  const DynamicDetailPage({super.key});

  @override
  State<DynamicDetailPage> createState() => _DynamicDetailPageState();
}

class _DynamicDetailPageState extends CommonDynPageState<DynamicDetailPage> {
  @override
  final DynamicDetailController controller = Get.putOrFind(
    DynamicDetailController.new,
    tag: (Get.arguments['item'] as DynamicItemModel).idStr.toString(),
  );

  @override
  dynamic get arguments => {
    'item': controller.dynItem,
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        controller.showTitle.value =
            scrollController.positions.first.pixels > 55;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.only(left: padding.left, right: padding.right),
        child: isPortrait
            ? refreshIndicator(
                onRefresh: controller.onRefresh,
                child: _buildBody(theme),
              )
            : _buildBody(theme),
      ),
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButton: SlideTransition(
        position: fabAnimation,
        child: _buildBottom(theme),
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

  Widget _buildBody(ThemeData theme) {
    double padding = max(maxWidth / 2 - Grid.smallCardWidth, 0);
    Widget child;
    if (isPortrait) {
      child = Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: CustomScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: DynamicPanel(
                item: controller.dynItem,
                isDetail: true,
                isDetailPortraitW: isPortrait,
                onSetPubSetting: controller.onSetPubSetting,
                onEdit: _onEdit,
                onSetReplySubject: controller.onSetReplySubject,
              ),
            ),
            buildReplyHeader(theme),
            Obx(() => replyList(theme, controller.loadingState.value)),
          ],
        ),
      );
    } else {
      padding = padding / 4;
      final flex = controller.ratio[0].toInt();
      final flex1 = controller.ratio[1].toInt();
      child = Row(
        children: [
          Expanded(
            flex: flex,
            child: CustomScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: padding,
                    bottom: this.padding.bottom + 100,
                  ),
                  sliver: SliverToBoxAdapter(
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
                body: refreshIndicator(
                  onRefresh: controller.onRefresh,
                  child: CustomScrollView(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      buildReplyHeader(theme),
                      Obx(
                        () => replyList(theme, controller.loadingState.value),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return child;
  }

  Widget _buildBottom(ThemeData theme) {
    if (!controller.showDynActionBar) {
      return fabButton;
    }

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
                        icon: FontAwesomeIcons.shareFromSquare,
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
                    onPressed: (_) => Utils.shareText(
                      '${HttpString.dynamicShareBaseUrl}/${controller.dynItem.idStr}',
                    ),
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      return textIconButton(
                        icon: FontAwesomeIcons.thumbsUp,
                        activatedIcon: FontAwesomeIcons.solidThumbsUp,
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
}
