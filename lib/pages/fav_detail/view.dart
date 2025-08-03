import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/skeleton/video_card_h.dart';
import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/fav_order_type.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/fav/fav_detail/data.dart';
import 'package:PiliPlus/models_new/fav/fav_detail/media.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';
import 'package:PiliPlus/pages/dynamics_repost/view.dart';
import 'package:PiliPlus/pages/fav_detail/controller.dart';
import 'package:PiliPlus/pages/fav_detail/widget/fav_video_card.dart';
import 'package:PiliPlus/utils/fav_util.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/page_utils.dart';
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

class _FavDetailPageState extends State<FavDetailPage> {
  late final FavDetailController _favDetailController = Get.put(
    FavDetailController(),
    tag: Utils.makeHeroTag(mediaId),
  );
  late String mediaId;

  @override
  void initState() {
    super.initState();
    mediaId = Get.parameters['mediaId']!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            floatingActionButton: Obx(
              () => _favDetailController.folderInfo.value.mediaCount > 0
                  ? FloatingActionButton.extended(
                      onPressed: _favDetailController.toViewPlayAll,
                      label: const Text('播放全部'),
                      icon: const Icon(Icons.playlist_play),
                    )
                  : const SizedBox.shrink(),
            ),
            body: SafeArea(
              top: false,
              bottom: false,
              child: refreshIndicator(
                onRefresh: _favDetailController.onRefresh,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _favDetailController.scrollController,
                  slivers: [
                    _buildHeader(enableMultiSelect, theme),
                    SliverPadding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.paddingOf(context).bottom + 85,
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
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool enableMultiSelect, ThemeData theme) {
    return SliverAppBar.medium(
      leading: enableMultiSelect
          ? Row(
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
      expandedHeight: kToolbarHeight + 130,
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
              'isOwner': _favDetailController.isOwner.value ?? false,
            },
          );
        },
        icon: const Icon(Icons.search_outlined),
      ),
      Obx(() {
        final attr = _favDetailController.folderInfo.value.attr;
        return attr == -1 || !FavUtil.isPublicFav(attr)
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
          final isOwner = _favDetailController.isOwner.value ?? false;
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
            if (FavUtil.isPublicFav(folderInfo.attr))
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
              if (!FavUtil.isDefaultFav(folderInfo.attr)) ...[
                const PopupMenuDivider(height: 12),
                PopupMenuItem(
                  onTap: () => showConfirmDialog(
                    context: context,
                    title: '确定删除该收藏夹?',
                    onConfirm: () =>
                        FavHttp.deleteFolder(mediaIds: [mediaId]).then((res) {
                          if (res['status']) {
                            SmartDialog.showToast('删除成功');
                            Get.back(result: true);
                          } else {
                            SmartDialog.showToast(res['msg']);
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

  List<Widget> _selectActions(ThemeData theme) => [
    TextButton(
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
      ),
      onPressed: () => _favDetailController.handleSelect(true),
      child: const Text('全选'),
    ),
    TextButton(
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
      ),
      onPressed: () =>
          RequestUtils.onCopyOrMove<FavDetailData, FavDetailItemModel>(
            context: context,
            isCopy: true,
            ctr: _favDetailController,
            mediaId: _favDetailController.mediaId,
            mid: _favDetailController.accountService.mid,
          ),
      child: Text(
        '复制',
        style: TextStyle(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    ),
    TextButton(
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
      ),
      onPressed: () =>
          RequestUtils.onCopyOrMove<FavDetailData, FavDetailItemModel>(
            context: context,
            isCopy: false,
            ctr: _favDetailController,
            mediaId: _favDetailController.mediaId,
            mid: _favDetailController.accountService.mid,
          ),
      child: Text(
        '移动',
        style: TextStyle(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    ),
    TextButton(
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
      ),
      onPressed: _favDetailController.onConfirm,
      child: Text(
        '删除',
        style: TextStyle(color: theme.colorScheme.error),
      ),
    ),
    const SizedBox(width: 10),
  ];

  Widget _flexibleSpace(ThemeData theme) {
    final style = TextStyle(
      fontSize: 12.5,
      color: theme.colorScheme.outline,
    );
    return FlexibleSpaceBar(
      background: Padding(
        padding: EdgeInsets.only(
          top: kToolbarHeight + MediaQuery.paddingOf(context).top + 10,
          left: 14,
          right: 20,
          bottom: 10,
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
                          if (_favDetailController.isOwner.value != false) {
                            return const SizedBox.shrink();
                          }
                          bool isFav = folderInfo.favState == 1;
                          return iconButton(
                            context: context,
                            size: 28,
                            iconSize: 18,
                            tooltip: '${isFav ? '取消' : ''}收藏',
                            onPressed: () => _favDetailController.onFav(isFav),
                            icon: isFav
                                ? Icons.favorite
                                : Icons.favorite_border,
                            bgColor: isFav
                                ? null
                                : theme.colorScheme.onInverseSurface,
                            iconColor: isFav
                                ? null
                                : theme.colorScheme.onSurfaceVariant,
                          );
                        }),
                      ),
                    ],
                  ),
                  if (folderInfo.title.isNotEmpty)
                    Expanded(
                      child: Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            folderInfo.title,
                            style: TextStyle(
                              fontSize: theme.textTheme.titleMedium!.fontSize,
                              fontWeight: FontWeight.bold,
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
                          if (folderInfo.intro?.isNotEmpty == true)
                            Text(
                              folderInfo.intro!,
                              style: style,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                '共${folderInfo.mediaCount}条视频 · ${FavUtil.isPublicFavText(folderInfo.attr)}',
                                textAlign: TextAlign.end,
                                style: style,
                              ),
                            ),
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
      Loading() => SliverGrid(
        gridDelegate: Grid.videoCardHDelegate(context),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return const VideoCardHSkeleton();
          },
          childCount: 10,
        ),
      ),
      Success(:var response) =>
        response?.isNotEmpty == true
            ? SliverGrid(
                gridDelegate: Grid.videoCardHDelegate(context),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
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
                    final isOwner = _favDetailController.isOwner.value ?? false;
                    FavDetailItemModel item = response[index];
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: FavVideoCardH(
                            item: item,
                            onDelFav: isOwner
                                ? () => _favDetailController.onCancelFav(
                                    index,
                                    item.id!,
                                    item.type!,
                                  )
                                : null,
                            onViewFav: () {
                              final folderInfo =
                                  _favDetailController.folderInfo.value;
                              PageUtils.toVideoPage(
                                'bvid=${item.bvid}&cid=${item.ugc?.firstCid}',
                                arguments: {
                                  'videoItem': item,
                                  'heroTag': Utils.makeHeroTag(item.bvid),
                                  'sourceType': SourceType.fav,
                                  'mediaId': folderInfo.id,
                                  'oid': item.id,
                                  'favTitle': folderInfo.title,
                                  'count': folderInfo.mediaCount,
                                  'desc': true,
                                  'isContinuePlaying': index != 0,
                                  'isOwner': isOwner,
                                },
                              );
                            },
                            onTap: enableMultiSelect
                                ? () => _favDetailController.onSelect(item)
                                : null,
                            onLongPress: isOwner
                                ? () {
                                    if (!enableMultiSelect) {
                                      _favDetailController
                                              .enableMultiSelect
                                              .value =
                                          true;
                                      _favDetailController.onSelect(item);
                                    }
                                  }
                                : null,
                          ),
                        ),
                        Positioned(
                          top: 5,
                          left: 12,
                          bottom: 5,
                          child: IgnorePointer(
                            child: LayoutBuilder(
                              builder: (context, constraints) =>
                                  AnimatedOpacity(
                                    opacity: item.checked == true ? 1 : 0,
                                    duration: const Duration(milliseconds: 200),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: constraints.maxHeight,
                                      width:
                                          constraints.maxHeight *
                                          StyleString.aspectRatio,
                                      decoration: BoxDecoration(
                                        borderRadius: StyleString.mdRadius,
                                        color: Colors.black.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                      child: SizedBox(
                                        width: 34,
                                        height: 34,
                                        child: AnimatedScale(
                                          scale: item.checked == true ? 1 : 0,
                                          duration: const Duration(
                                            milliseconds: 250,
                                          ),
                                          curve: Curves.easeInOut,
                                          child: IconButton(
                                            style: ButtonStyle(
                                              padding: WidgetStateProperty.all(
                                                EdgeInsets.zero,
                                              ),
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                    theme.colorScheme.surface
                                                        .withValues(alpha: 0.8),
                                                  ),
                                            ),
                                            onPressed: null,
                                            icon: Icon(
                                              Icons.done_all_outlined,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  childCount: response!.length + 1,
                ),
              )
            : HttpError(
                onReload: _favDetailController.onReload,
              ),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _favDetailController.onReload,
      ),
    };
  }
}
