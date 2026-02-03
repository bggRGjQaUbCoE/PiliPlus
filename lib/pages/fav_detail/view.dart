import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/fav_order_type.dart';
import 'package:PiliPlus/models_new/fav/fav_detail/media.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';
import 'package:PiliPlus/pages/dynamics_repost/view.dart';
import 'package:PiliPlus/pages/fav_detail/controller.dart';
import 'package:PiliPlus/pages/fav_detail/widget/fav_video_card.dart';
import 'package:PiliPlus/utils/fav_utils.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class FavDetailPage extends StatefulWidget {
  const FavDetailPage({super.key});

  @override
  State<FavDetailPage> createState() => _FavDetailPageState();
}

class _FavDetailPageState extends State<FavDetailPage> with GridMixin {
  late final FavDetailController _favDetailController;
  late String mediaId;

  @override
  void initState() {
    super.initState();
    mediaId = Get.parameters['mediaId']!;
    _favDetailController = Get.put(
      FavDetailController(),
      tag: Utils.makeHeroTag(mediaId),
    );
  }

  late EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    padding = MediaQuery.viewPaddingOf(context);
    return Obx(
      () {
        final enableMultiSelect = _favDetailController.enableMultiSelect.value;
        return PopScope(
          canPop: !enableMultiSelect,
          onPopInvokedWithResult: (didPop, result) {
            if (enableMultiSelect) {
              _favDetailController.handleSelect();
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            floatingActionButtonLocation: const CustomFabLocation(),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(
                right: kFloatingActionButtonMargin,
              ),
              child: Obx(
                () => _favDetailController.folderInfo.value.mediaCount > 0
                    ? AnimatedSlide(
                        offset: _favDetailController.isPlayAll.value
                            ? Offset.zero
                            : const Offset(0.75, 0),
                        duration: const Duration(milliseconds: 120),
                        child: GestureDetector(
                          onHorizontalDragDown: (details) =>
                              _favDetailController.dx =
                                  details.localPosition.dx,
                          onHorizontalDragStart: (details) =>
                              _favDetailController.setIsPlayAll(
                                details.localPosition.dx <
                                    _favDetailController.dx,
                              ),
                          child: FloatingActionButton.extended(
                            onPressed: () {
                              if (_favDetailController.isPlayAll.value) {
                                _favDetailController.toViewPlayAll();
                              } else {
                                _favDetailController.setIsPlayAll(true);
                              }
                            },
                            label: const Text('播放全部'),
                            icon: const Icon(Icons.playlist_play),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
            body: refreshIndicator(
              onRefresh: _favDetailController.onRefresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _favDetailController.scrollController,
                slivers: [
                  _buildHeader(enableMultiSelect, theme),
                  SliverPadding(
                    padding: EdgeInsets.only(
                      left: padding.left,
                      right: padding.right,
                      bottom: padding.bottom + 100,
                    ),
                    sliver: Obx(
                      () => _buildBody(
                        enableMultiSelect,
                        theme,
                        _favDetailController.loadingState.value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool enableMultiSelect, ThemeData theme) {
    return SliverAppBar.medium(
      leadingWidth: enableMultiSelect ? 125 : null,
      leading: enableMultiSelect
          ? Row(
              mainAxisSize: .min,
              children: [
                IconButton(
                  tooltip: '取消',
                  onPressed: _favDetailController.handleSelect,
                  icon: const Icon(Icons.close_outlined),
                ),
                Obx(
                  () {
                    return Text(
                      '已选: ${_favDetailController.checkedCount}',
                      style: const TextStyle(fontSize: 15),
                    );
                  },
                ),
              ],
            )
          : null,
      expandedHeight: kToolbarHeight + 127,
      pinned: true,
      title: enableMultiSelect
          ? null
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _favDetailController.folderInfo.value.title,
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  '共${_favDetailController.folderInfo.value.mediaCount}条视频',
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
      actions: enableMultiSelect ? _selectActions(theme) : _actions(theme),
      flexibleSpace: _flexibleSpace(theme),
    );
  }

  List<Widget> _actions(ThemeData theme) {
    return [
      IconButton(
        tooltip: '搜索',
        onPressed: () {
          final folderInfo = _favDetailController.folderInfo.value;
          Get.toNamed(
            '/favSearch',
            arguments: {
              'type': 0,
              'mediaId': int.parse(mediaId),
              'title': folderInfo.title,
              'count': folderInfo.mediaCount,
              'isOwner': _favDetailController.isOwner,
            },
          );
        },
        icon: const Icon(Icons.search_outlined),
      ),
      Obx(() {
        final attr = _favDetailController.folderInfo.value.attr;
        return attr == -1 || !FavUtils.isPublicFav(attr)
            ? const SizedBox.shrink()
            : IconButton(
                iconSize: 22,
                tooltip: '分享',
                onPressed: () => Utils.shareText(
                  'https://www.bilibili.com/medialist/detail/ml${_favDetailController.mediaId}',
                ),
                icon: const Icon(Icons.share),
              );
      }),
      Obx(
        () {
          return PopupMenuButton<FavOrderType>(
            icon: const Icon(Icons.sort),
            initialValue: _favDetailController.order.value,
            tooltip: '排序方式',
            onSelected: (value) => _favDetailController
              ..order.value = value
              ..onReload(),
            itemBuilder: (context) => FavOrderType.values
                .map(
                  (e) => PopupMenuItem(
                    value: e,
                    child: Text(e.label),
                  ),
                )
                .toList(),
          );
        },
      ),
      PopupMenuButton(
        icon: const Icon(Icons.more_vert),
        itemBuilder: (context) {
          final isOwner = _favDetailController.isOwner;
          final folderInfo = _favDetailController.folderInfo.value;
          return [
            if (isOwner) ...[
              PopupMenuItem(
                onTap: _favDetailController.onSort,
                child: const Text('排序'),
              ),
              PopupMenuItem(
                onTap: () =>
                    Get.toNamed(
                      '/createFav',
                      parameters: {'mediaId': mediaId},
                    )?.then((res) {
                      if (res is FavFolderInfo) {
                        _favDetailController.folderInfo.value = res;
                      }
                    }),
                child: const Text('编辑信息'),
              ),
            ] else
              PopupMenuItem(
                onTap: () =>
                    _favDetailController.onFav(folderInfo.favState == 1),
                child: Text('${folderInfo.favState == 1 ? '取消' : ''}收藏'),
              ),
            if (FavUtils.isPublicFav(folderInfo.attr))
              PopupMenuItem(
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (context) => RepostPanel(
                    rid: _favDetailController.mediaId,
                    dynType: 4300,
                    pic: folderInfo.cover,
                    title: folderInfo.title,
                    uname: folderInfo.upper?.name,
                  ),
                ),
                child: const Text('分享至动态'),
              ),
            if (isOwner) ...<PopupMenuEntry>[
              PopupMenuItem(
                onTap: _favDetailController.cleanFav,
                child: const Text('清除失效内容'),
              ),
              if (!FavUtils.isDefaultFav(folderInfo.attr)) ...[
                const PopupMenuDivider(height: 12),
                PopupMenuItem(
                  onTap: () => showConfirmDialog(
                    context: context,
                    title: '确定删除该收藏夹?',
                    onConfirm: () =>
                        FavHttp.deleteFolder(mediaIds: mediaId).then((res) {
                          if (res.isSuccess) {
                            SmartDialog.showToast('删除成功');
                            Get.back(result: true);
                          } else {
                            res.toast();
                          }
                        }),
                  ),
                  child: Text(
                    '删除',
                    style: TextStyle(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ],
          ];
        },
      ),
      const SizedBox(width: 10),
    ];
  }

  List<Widget> _selectActions(ThemeData theme) {
    final btnStyle = TextButton.styleFrom(visualDensity: .compact);
    final textStyle = TextStyle(color: theme.colorScheme.onSurfaceVariant);
    return [
      TextButton(
        style: btnStyle,
        onPressed: () => _favDetailController.handleSelect(checked: true),
        child: const Text('全选'),
      ),
      TextButton(
        style: btnStyle,
        onPressed: () => RequestUtils.onCopyOrMove<FavDetailItemModel>(
          context: context,
          isCopy: true,
          ctr: _favDetailController,
          mediaId: _favDetailController.mediaId,
          mid: _favDetailController.account.mid,
        ),
        child: Text('复制', style: textStyle),
      ),
      TextButton(
        style: btnStyle,
        onPressed: () => RequestUtils.onCopyOrMove<FavDetailItemModel>(
          context: context,
          isCopy: false,
          ctr: _favDetailController,
          mediaId: _favDetailController.mediaId,
          mid: _favDetailController.account.mid,
        ),
        child: Text('移动', style: textStyle),
      ),
      TextButton(
        style: btnStyle,
        onPressed: _favDetailController.onRemove,
        child: Text(
          '删除',
          style: TextStyle(color: theme.colorScheme.error),
        ),
      ),
      const SizedBox(width: 10),
    ];
  }

  Widget _flexibleSpace(ThemeData theme) {
    final style = TextStyle(
      height: 1,
      fontSize: 12.5,
      color: theme.colorScheme.outline,
    );
    return FlexibleSpaceBar(
      background: Padding(
        padding: EdgeInsets.only(
          top: kToolbarHeight + padding.top + 10,
          left: 12 + padding.left,
          right: 12,
          bottom: 7,
        ),
        child: SizedBox(
          height: 110,
          child: Obx(
            () {
              final folderInfo = _favDetailController.folderInfo.value;
              return Row(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Hero(
                        tag: _favDetailController.heroTag,
                        child: NetworkImgLayer(
                          width: 176,
                          height: 110,
                          src: folderInfo.cover,
                        ),
                      ),
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Obx(() {
                          if (_favDetailController.isOwner ||
                              _favDetailController.loadingState.value
                                  is! Success) {
                            return const SizedBox.shrink();
                          }
                          bool isFav = folderInfo.favState == 1;
                          return iconButton(
                            size: 28,
                            iconSize: 18,
                            tooltip: '${isFav ? '取消' : ''}收藏',
                            onPressed: () => _favDetailController.onFav(isFav),
                            icon: isFav
                                ? const Icon(Icons.favorite)
                                : const Icon(Icons.favorite_border),
                            bgColor: isFav
                                ? theme.colorScheme.secondaryContainer
                                : theme.colorScheme.onInverseSurface,
                            iconColor: isFav
                                ? theme.colorScheme.onSecondaryContainer
                                : theme.colorScheme.onSurfaceVariant,
                          );
                        }),
                      ),
                    ],
                  ),
                  if (folderInfo.title.isNotEmpty)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              folderInfo.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: theme.textTheme.titleMedium!.fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed(
                              '/member?mid=${folderInfo.upper!.mid}',
                            ),
                            child: Text(
                              folderInfo.upper!.name!,
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (folderInfo.intro?.isNotEmpty == true) ...[
                            Text(
                              folderInfo.intro!,
                              style: style,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                          ],
                          Text(
                            '共${folderInfo.mediaCount}条视频 · '
                            '${FavUtils.isPublicFavText(folderInfo.attr)}',
                            style: style,
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    bool enableMultiSelect,
    ThemeData theme,
    LoadingState<List<FavDetailItemModel>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => gridSkeleton,
      Success(:final response) =>
        response != null && response.isNotEmpty
            ? SliverGrid.builder(
                gridDelegate: gridDelegate,
                itemBuilder: (context, index) {
                  if (index == response.length) {
                    _favDetailController.onLoadMore();
                    return Container(
                      height: 60,
                      alignment: Alignment.center,
                      child: Text(
                        _favDetailController.isEnd ? '没有更多了' : '加载中...',
                        style: TextStyle(
                          color: theme.colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }
                  FavDetailItemModel item = response[index];
                  return FavVideoCardH(
                    item: item,
                    index: index,
                    ctr: _favDetailController,
                  );
                },
                itemCount: response.length + 1,
              )
            : HttpError(onReload: _favDetailController.onReload),
      Error(:final errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _favDetailController.onReload,
      ),
    };
  }
}

class CustomFabLocation extends StandardFabLocation with FabFloatOffsetY {
  const CustomFabLocation();

  @override
  double getOffsetX(
    ScaffoldPrelayoutGeometry scaffoldGeometry,
    double adjustment,
  ) {
    return scaffoldGeometry.scaffoldSize.width -
        scaffoldGeometry.minInsets.right -
        scaffoldGeometry.floatingActionButtonSize.width +
        adjustment;
  }
}
