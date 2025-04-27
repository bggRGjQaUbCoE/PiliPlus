import 'package:PiliPlus/common/widgets/dialog.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models/user/fav_detail.dart';
import 'package:PiliPlus/models/user/fav_folder.dart';
import 'package:PiliPlus/pages/fav_detail/fav_sort_page.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/skeleton/video_card_h.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/pages/fav_detail/index.dart';

import '../../common/constants.dart';
import '../../utils/grid.dart';
import 'widget/fav_video_card.dart';

class FavDetailPage extends StatefulWidget {
  const FavDetailPage({super.key});

  @override
  State<FavDetailPage> createState() => _FavDetailPageState();
}

class _FavDetailPageState extends State<FavDetailPage> {
  late final FavDetailController _favDetailController =
      Get.put(FavDetailController(), tag: Utils.makeHeroTag(mediaId));
  late String mediaId;

  @override
  void initState() {
    super.initState();
    mediaId = Get.parameters['mediaId']!;
    _favDetailController.scrollController.addListener(listener);
  }

  void listener() {
    if (_favDetailController.scrollController.offset > 160) {
      _favDetailController.titleCtr.value = true;
    } else if (_favDetailController.scrollController.offset <= 160) {
      _favDetailController.titleCtr.value = false;
    }
  }

  @override
  void dispose() {
    _favDetailController.scrollController.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: _favDetailController.enableMultiSelect.value.not,
        onPopInvokedWithResult: (didPop, result) {
          if (_favDetailController.enableMultiSelect.value) {
            _favDetailController.handleSelect();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: Obx(
            () => (_favDetailController.item.value.mediaCount ?? -1) > 0
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
              onRefresh: () async {
                await _favDetailController.onRefresh();
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _favDetailController.scrollController,
                slivers: [
                  SliverAppBar(
                    leading: _favDetailController.enableMultiSelect.value
                        ? IconButton(
                            tooltip: '取消',
                            onPressed: _favDetailController.handleSelect,
                            icon: const Icon(Icons.close_outlined),
                          )
                        : null,
                    expandedHeight: 200 - MediaQuery.of(context).padding.top,
                    pinned: true,
                    title: _favDetailController.enableMultiSelect.value
                        ? Text(
                            '已选: ${_favDetailController.checkedCount.value}',
                          )
                        : Obx(
                            () => AnimatedOpacity(
                              opacity:
                                  _favDetailController.titleCtr.value ? 1 : 0,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 500),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _favDetailController.item.value.title ?? '',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    '共${_favDetailController.item.value.mediaCount}条视频',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  )
                                ],
                              ),
                            ),
                          ),
                    actions: _favDetailController.enableMultiSelect.value
                        ? [
                            TextButton(
                              style: TextButton.styleFrom(
                                visualDensity:
                                    VisualDensity(horizontal: -2, vertical: -2),
                              ),
                              onPressed: () =>
                                  _favDetailController.handleSelect(true),
                              child: const Text('全选'),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                visualDensity:
                                    VisualDensity(horizontal: -2, vertical: -2),
                              ),
                              onPressed: () {
                                RequestUtils.onCopyOrMove<FavDetailData,
                                    FavDetailItemData>(
                                  context: context,
                                  isCopy: true,
                                  ctr: _favDetailController,
                                  mediaId: _favDetailController.mediaId,
                                  mid: _favDetailController.mid,
                                );
                              },
                              child: Text(
                                '复制',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                visualDensity:
                                    VisualDensity(horizontal: -2, vertical: -2),
                              ),
                              onPressed: () {
                                RequestUtils.onCopyOrMove<FavDetailData,
                                    FavDetailItemData>(
                                  context: context,
                                  isCopy: false,
                                  ctr: _favDetailController,
                                  mediaId: _favDetailController.mediaId,
                                  mid: _favDetailController.mid,
                                );
                              },
                              child: Text(
                                '移动',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                visualDensity:
                                    VisualDensity(horizontal: -2, vertical: -2),
                              ),
                              onPressed: () =>
                                  _favDetailController.onDelChecked(context),
                              child: Text(
                                '删除',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error),
                              ),
                            ),
                            const SizedBox(width: 6),
                          ]
                        : [
                            IconButton(
                              tooltip: '搜索',
                              onPressed: () => Get.toNamed(
                                '/favSearch',
                                arguments: {
                                  'type': 0,
                                  'mediaId': int.parse(mediaId),
                                  'title':
                                      _favDetailController.item.value.title,
                                  'count': _favDetailController
                                      .item.value.mediaCount,
                                  'isOwner': _favDetailController.isOwner.value,
                                },
                              ),
                              icon: const Icon(Icons.search_outlined),
                            ),
                            Obx(
                              () => _favDetailController.isOwner.value
                                  ? PopupMenuButton(
                                      icon: const Icon(Icons.more_vert),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          onTap: () {
                                            Get.toNamed(
                                              '/createFav',
                                              parameters: {'mediaId': mediaId},
                                            )?.then((res) {
                                              if (res is FavFolderItemData) {
                                                _favDetailController
                                                    .item.value = res;
                                              }
                                            });
                                          },
                                          child: Text('编辑信息'),
                                        ),
                                        PopupMenuItem(
                                          onTap: () {
                                            UserHttp.cleanFav(mediaId: mediaId)
                                                .then((data) {
                                              if (data['status']) {
                                                SmartDialog.showToast('清除成功');
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 200), () {
                                                  _favDetailController
                                                      .onReload();
                                                });
                                              } else {
                                                SmartDialog.showToast(
                                                    data['msg']);
                                              }
                                            });
                                          },
                                          child: Text('清除失效内容'),
                                        ),
                                        PopupMenuItem(
                                          onTap: () {
                                            if (_favDetailController
                                                    .loadingState
                                                    .value is Success &&
                                                ((_favDetailController
                                                                    .loadingState
                                                                    .value
                                                                as Success)
                                                            .response as List?)
                                                        ?.isNotEmpty ==
                                                    true) {
                                              if ((_favDetailController.item
                                                          .value.mediaCount ??
                                                      0) >
                                                  1000) {
                                                SmartDialog.showToast(
                                                    '内容太多啦！超过1000不支持排序');
                                                return;
                                              }
                                              Get.to(
                                                FavSortPage(
                                                    favDetailController:
                                                        _favDetailController),
                                              );
                                            }
                                          },
                                          child: Text('排序'),
                                        ),
                                        if (!Utils.isDefaultFav(
                                            _favDetailController
                                                    .item.value.attr ??
                                                0))
                                          PopupMenuItem(
                                            onTap: () {
                                              showConfirmDialog(
                                                context: context,
                                                title: '确定删除该收藏夹?',
                                                onConfirm: () {
                                                  UserHttp.deleteFolder(
                                                          mediaIds: [mediaId])
                                                      .then((data) {
                                                    if (data['status']) {
                                                      SmartDialog.showToast(
                                                          '删除成功');
                                                      Get.back(result: true);
                                                    } else {
                                                      SmartDialog.showToast(
                                                          data['msg']);
                                                    }
                                                  });
                                                },
                                              );
                                            },
                                            child: Text(
                                              '删除',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                              ),
                                            ),
                                          ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            const SizedBox(width: 6),
                          ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        padding: EdgeInsets.only(
                          top: kTextTabBarHeight +
                              MediaQuery.of(context).padding.top +
                              10,
                          left: 14,
                          right: 20,
                        ),
                        child: SizedBox(
                          height: 110,
                          child: Obx(
                            () => Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Hero(
                                  tag: _favDetailController.heroTag,
                                  child: NetworkImgLayer(
                                    width: 180,
                                    height: 110,
                                    src: _favDetailController.item.value.cover,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: SizedBox(
                                    height: 110,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(
                                          _favDetailController
                                                  .item.value.title ??
                                              '',
                                          style: TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .fontSize,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        if (_favDetailController
                                                .item.value.intro?.isNotEmpty ==
                                            true)
                                          Text(
                                            _favDetailController
                                                    .item.value.intro ??
                                                '',
                                            style: TextStyle(
                                                fontSize: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
                                                    .fontSize,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline),
                                          ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _favDetailController
                                                  .item.value.upper?.name ??
                                              '',
                                          style: TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .fontSize,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline),
                                        ),
                                        const Spacer(),
                                        if (_favDetailController
                                                .item.value.attr !=
                                            null)
                                          Text(
                                            '共${_favDetailController.item.value.mediaCount}条视频 · ${Utils.isPublicFavText(_favDetailController.item.value.attr ?? 0)}',
                                            style: TextStyle(
                                                fontSize: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
                                                    .fontSize,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(() =>
                      _buildBody(_favDetailController.loadingState.value)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(LoadingState<List<FavDetailItemData>?> loadingState) {
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
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverPadding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 85,
              ),
              sliver: SliverGrid(
                gridDelegate: Grid.videoCardHDelegate(context),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == loadingState.response!.length) {
                      _favDetailController.onLoadMore();
                      return Container(
                        height: 60,
                        alignment: Alignment.center,
                        child: Text(
                          _favDetailController.isEnd.not ? '加载中...' : '没有更多了',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 13,
                          ),
                        ),
                      );
                    }
                    FavDetailItemData item = loadingState.response![index];
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: FavVideoCardH(
                            videoItem: item,
                            onDelFav: _favDetailController.isOwner.value
                                ? () => _favDetailController.onCancelFav(
                                      index,
                                      item.id!,
                                      item.type!,
                                    )
                                : null,
                            onViewFav: () {
                              PageUtils.toVideoPage(
                                'bvid=${item.bvid}&cid=${item.cid}',
                                arguments: {
                                  'videoItem': item,
                                  'heroTag': Utils.makeHeroTag(item.bvid),
                                  'sourceType': 'fav',
                                  'mediaId': _favDetailController.item.value.id,
                                  'oid': item.id,
                                  'favTitle':
                                      _favDetailController.item.value.title,
                                  'count': _favDetailController
                                      .item.value.mediaCount,
                                  'desc': true,
                                  'isContinuePlaying': index != 0,
                                  'isOwner': _favDetailController.isOwner.value,
                                },
                              );
                            },
                            onTap: _favDetailController.enableMultiSelect.value
                                ? () {
                                    _favDetailController.onSelect(index);
                                  }
                                : null,
                            onLongPress: _favDetailController.isOwner.value
                                ? () {
                                    if (_favDetailController
                                        .enableMultiSelect.value.not) {
                                      _favDetailController
                                          .enableMultiSelect.value = true;
                                      _favDetailController.onSelect(index);
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
                                  width: constraints.maxHeight *
                                      StyleString.aspectRatio,
                                  decoration: BoxDecoration(
                                    borderRadius: StyleString.mdRadius,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  child: SizedBox(
                                    width: 34,
                                    height: 34,
                                    child: AnimatedScale(
                                      scale: item.checked == true ? 1 : 0,
                                      duration:
                                          const Duration(milliseconds: 250),
                                      curve: Curves.easeInOut,
                                      child: IconButton(
                                        style: ButtonStyle(
                                          padding: WidgetStateProperty.all(
                                              EdgeInsets.zero),
                                          backgroundColor:
                                              WidgetStateProperty.resolveWith(
                                            (states) {
                                              return Theme.of(context)
                                                  .colorScheme
                                                  .surface
                                                  .withOpacity(0.8);
                                            },
                                          ),
                                        ),
                                        onPressed: null,
                                        icon: Icon(
                                          Icons.done_all_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
                  childCount: loadingState.response!.length + 1,
                ),
              ),
            )
          : HttpError(
              onReload: _favDetailController.onReload,
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _favDetailController.onReload,
        ),
      LoadingState() => throw UnimplementedError(),
    };
  }
}
