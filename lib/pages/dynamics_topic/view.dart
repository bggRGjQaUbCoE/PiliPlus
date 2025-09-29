import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/custom_sliver_persistent_header_delegate.dart';
import 'package:PiliPlus/common/widgets/dynamic_sliver_appbar_medium.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/pair.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_topic_feed/item.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_topic_top/top_details.dart';
import 'package:PiliPlus/pages/dynamics/widgets/dynamic_panel.dart';
import 'package:PiliPlus/pages/dynamics_create/view.dart';
import 'package:PiliPlus/pages/dynamics_topic/controller.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:PiliPlus/utils/waterfall.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:waterfall_flow/waterfall_flow.dart'
    hide SliverWaterfallFlowDelegateWithMaxCrossAxisExtent;

class DynTopicPage extends StatefulWidget {
  const DynTopicPage({super.key});

  @override
  State<DynTopicPage> createState() => _DynTopicPageState();
}

class _DynTopicPageState extends State<DynTopicPage> with DynMixin {
  final DynTopicController _controller = Get.put(
    DynTopicController(),
    tag: Utils.generateRandomString(8),
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final padding = MediaQuery.viewPaddingOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_controller.accountService.isLogin.value) {
            CreateDynPanel.onCreateDyn(
              context,
              topic: Pair(
                first: int.parse(_controller.topicId),
                second: _controller.topicName,
              ),
            );
          } else {
            SmartDialog.showToast('账号未登录');
          }
        },
        icon: const Icon(CustomIcons.topic_tag, size: 20),
        label: const Text('参与话题'),
      ),
      body: refreshIndicator(
        onRefresh: _controller.onRefresh,
        child: CustomScrollView(
          controller: _controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            Obx(
              () => _buildAppBar(
                theme,
                padding,
                _controller.topState.value,
              ),
            ),
            Obx(() {
              final allSortBy = _controller.topicSortByConf.value?.allSortBy;
              if (allSortBy != null && allSortBy.isNotEmpty) {
                return SliverPersistentHeader(
                  pinned: true,
                  delegate: CustomSliverPersistentHeaderDelegate(
                    extent: 30,
                    needRebuild: true,
                    bgColor: theme.colorScheme.surface,
                    child: Container(
                      height: 30,
                      padding: EdgeInsets.only(
                        left: 12 + padding.left,
                        bottom: 6,
                      ),
                      child: Builder(
                        builder: (context) {
                          return ToggleButtons(
                            fillColor: theme.colorScheme.secondaryContainer,
                            selectedColor:
                                theme.colorScheme.onSecondaryContainer,
                            constraints: const BoxConstraints(
                              minWidth: 54,
                              minHeight: 24,
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(25),
                            ),
                            onPressed: (index) {
                              _controller.onSort(allSortBy[index].sortBy!);
                              (context as Element).markNeedsBuild();
                            },
                            isSelected: allSortBy.map((e) {
                              return e.sortBy == _controller.sortBy;
                            }).toList(),
                            children: allSortBy.map((e) {
                              return Text(
                                e.sortName!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1,
                                ),
                                strutStyle: const StrutStyle(
                                  height: 1,
                                  leading: 0,
                                  fontSize: 13,
                                ),
                                textScaler: TextScaler.noScaling,
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ),
                );
              }
              return const SliverToBoxAdapter();
            }),
            SliverPadding(
              padding: EdgeInsets.only(
                left: padding.left,
                right: padding.right,
                bottom: padding.bottom + 100,
              ),
              sliver: buildPage(
                Obx(() => _buildBody(_controller.loadingState.value)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(
    ThemeData theme,
    EdgeInsets padding,
    LoadingState<TopDetails?> topState,
  ) {
    return switch (topState) {
      Loading() => const SliverAppBar(),
      Success(:var response) when (topState.dataOrNull != null) =>
        DynamicSliverAppBarMedium(
          pinned: true,
          callback: (value) =>
              _controller.appbarOffset = value - kToolbarHeight - padding.top,
          title: IgnorePointer(child: Text(response!.topicItem!.name)),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.asset(
                  'assets/images/topic-header-bg.png',
                ).image,
                filterQuality: FilterQuality.low,
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.only(
              top: padding.top,
              left: 12 + padding.left,
              right: 12 + padding.right,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: kToolbarHeight,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 45, right: 78),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Get.toNamed(
                      '/member?mid=${response.topicCreator!.uid}',
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NetworkImgLayer(
                          width: 28,
                          height: 28,
                          src: response.topicCreator!.face!,
                          type: ImageType.avatar,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            response.topicCreator!.name!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          ' 发起',
                          style: TextStyle(color: theme.colorScheme.outline),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  response.topicItem!.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                SelectableText(
                  response.topicItem!.description!,
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '${NumUtils.numFormat(response.topicItem!.view)}浏览 · ${NumUtils.numFormat(response.topicItem!.discuss)}讨论',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          width: 1,
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.2,
                          ),
                        ),
                        foregroundColor: _controller.isLike.value == true
                            ? null
                            : theme.colorScheme.onSurfaceVariant,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        visualDensity: const VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: _controller.onLike,
                      icon: _controller.isLike.value == true
                          ? const Icon(FontAwesomeIcons.solidThumbsUp, size: 13)
                          : const Icon(FontAwesomeIcons.thumbsUp, size: 13),
                      label: Text(
                        NumUtils.numFormat(response.topicItem!.like),
                        style: const TextStyle(fontSize: 13),
                        textScaler: TextScaler.noScaling,
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          width: 1,
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.2,
                          ),
                        ),
                        foregroundColor: _controller.isFav.value == true
                            ? null
                            : theme.colorScheme.onSurfaceVariant,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        visualDensity: const VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: _controller.onFav,
                      icon: _controller.isFav.value == true
                          ? const Icon(FontAwesomeIcons.solidStar, size: 13)
                          : const Icon(FontAwesomeIcons.star, size: 13),
                      label: Text(
                        NumUtils.numFormat(response.topicItem!.fav),
                        style: const TextStyle(fontSize: 13),
                        textScaler: TextScaler.noScaling,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => Utils.shareText(
                '${_controller.topicName} https://m.bilibili.com/topic-detail?topic_id=${_controller.topicId}',
              ),
              // https://www.bilibili.com/v/topic/detail?topic_id=${_controller.topicId}
              icon: const Icon(MdiIcons.share),
            ),
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: _controller.onFav,
                    child: Text(
                      '${_controller.isFav.value == true ? '取消' : ''}收藏',
                    ),
                  ),
                  PopupMenuItem(
                    child: const Text('举报'),
                    onTap: () {
                      if (!_controller.accountService.isLogin.value) {
                        SmartDialog.showToast('账号未登录');
                        return;
                      }
                      final isDark = Get.isDarkMode;
                      PageUtils.inAppWebview(
                        'https://www.bilibili.com/h5/topic-active/topic-report?topic_id=${_controller.topicId}&topic_name=${_controller.topicName}&native.theme=${isDark ? 2 : 1}&night=${isDark ? 1 : 0}',
                      );
                    },
                  ),
                ];
              },
            ),
            const SizedBox(width: 4),
          ],
        ),
      _ => SliverAppBar(
        pinned: true,
        title: Text(_controller.topicName),
      ),
    };
  }

  Widget _buildBody(LoadingState<List<TopicCardItem>?> loadingState) {
    return switch (loadingState) {
      Loading() => dynSkeleton,
      Success(:var response) =>
        response?.isNotEmpty == true
            ? GlobalData().dynamicsWaterfallFlow
                  ? SliverWaterfallFlow(
                      gridDelegate: dynGridDelegate,
                      delegate: SliverChildBuilderDelegate(
                        (_, index) {
                          if (index == response.length - 1) {
                            _controller.onLoadMore();
                          }

                          final item = response[index];
                          if (item.dynamicCardItem != null) {
                            return DynamicPanel(
                              item: item.dynamicCardItem!,
                              maxWidth: maxWidth,
                            );
                          }

                          return Text(item.topicType ?? 'err');
                        },
                        childCount: response!.length,
                      ),
                    )
                  : SliverList.builder(
                      itemBuilder: (context, index) {
                        if (index == response.length - 1) {
                          _controller.onLoadMore();
                        }
                        final item = response[index];
                        if (item.dynamicCardItem != null) {
                          return DynamicPanel(
                            item: item.dynamicCardItem!,
                            maxWidth: maxWidth,
                          );
                        } else {
                          return Text(item.topicType ?? 'err');
                        }
                      },
                      itemCount: response!.length,
                    )
            : HttpError(onReload: _controller.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }
}
