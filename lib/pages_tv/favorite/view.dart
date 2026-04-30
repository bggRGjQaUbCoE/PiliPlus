import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages_tv/common/tv_card.dart';
import 'package:PiliPlus/pages_tv/common/tv_focus_wrapper.dart';
import 'package:PiliPlus/pages_tv/common/tv_page.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TVFavoritePage extends StatefulWidget {
  const TVFavoritePage({super.key});

  @override
  State<TVFavoritePage> createState() => _TVFavoritePageState();
}

class _TVFavoritePageState extends State<TVFavoritePage> {
  final _foldersState = Rx<LoadingState<List?>>(LoadingState.loading());
  final _contentState = Rx<LoadingState<List?>>(const Success(null));
  int? _selectedFolderId;

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    final mid = Accounts.main.mid;
    final res = await FavHttp.userfavFolder(
      pn: 1,
      ps: 50,
      mid: mid,
    );
    if (!mounted) return;
    if (res is Success) {
      final data = res.data;
      _foldersState.value = Success(data.list);
    } else {
      _foldersState.value =
          Error(res is Error ? (res as Error).errMsg : '加载失败');
    }
  }

  Future<void> _loadFolderContent(int mediaId) async {
    _selectedFolderId = mediaId;
    _contentState.value = LoadingState.loading();
    final res = await FavHttp.userFavFolderDetail(
      mediaId: mediaId,
      pn: 1,
      ps: 20,
    );
    if (!mounted) return;
    if (res is Success) {
      final data = res.data;
      _contentState.value = Success(data.medias);
    } else {
      _contentState.value =
          Error(res is Error ? (res as Error).errMsg : '加载失败');
    }
  }

  void _showUnfavDialog(dynamic item, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('提示'),
        content: Text('确定取消收藏「${item.title ?? ''}」？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              if (_selectedFolderId == null) return;
              final res = await FavHttp.favVideo(
                resources: '${item.id}:${item.type}',
                delIds: _selectedFolderId.toString(),
              );
              if (res.isSuccess) {
                final list =
                    List.from(_contentState.value.dataOrNull ?? []);
                list.removeAt(index);
                _contentState.value = Success(list);
              }
            },
            child: const Text('取消收藏'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TVPage(
      child: Scaffold(
        appBar: AppBar(title: const Text('收藏')),
        body: Row(
          children: [
            SizedBox(
              width: 240,
              child: Obx(() {
                final state = _foldersState.value;
                return switch (state) {
                  Loading() =>
                    const Center(child: CircularProgressIndicator()),
                  Success(:final response) =>
                    response != null && response.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: response.length,
                            itemBuilder: (ctx, i) {
                              final folder = response[i];
                              final fid = folder.id;
                              return TVFocusWrapper(
                                autoFocus: i == 0,
                                scaleFactor: 1.02,
                                borderRadius: 8,
                                onSelect: () {
                                  if (fid != null) _loadFolderContent(fid);
                                },
                                child: ListTile(
                                  title: Text(folder.title ?? ''),
                                  subtitle:
                                      Text('${folder.mediaCount ?? 0} 个内容'),
                                  selected: _selectedFolderId == fid,
                                ),
                              );
                            },
                          )
                        : const Center(child: Text('暂无收藏夹')),
                  Error(:final errMsg) =>
                    Center(child: Text(errMsg ?? '加载失败')),
                };
              }),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Obx(() {
                  final state = _contentState.value;
                  return switch (state) {
                    Loading() =>
                      const Center(child: CircularProgressIndicator()),
                    Success(:final response) =>
                      response != null && response.isNotEmpty
                          ? GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 16 / 13,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: response.length,
                              itemBuilder: (ctx, i) {
                                final item = response[i];
                                return TVCard(
                                  title: item.title ?? '',
                                  subtitle: item.upper?.name ?? '',
                                  coverUrl: item.cover,
                                  width: double.infinity,
                                  onSelect: () {
                                    final cid = item.ugc?.firstCid;
                                    if (cid != null && cid > 0) {
                                      PageUtils.toVideoPage(
                                        aid: item.id,
                                        bvid: item.bvid ??
                                            IdUtils.av2bv(item.id),
                                        cid: cid,
                                        cover: item.cover,
                                        title: item.title,
                                      );
                                    }
                                  },
                                  onLongPress: () =>
                                      _showUnfavDialog(item, i),
                                );
                              },
                            )
                          : Center(
                              child: Text(
                                _selectedFolderId == null
                                    ? '请选择收藏夹'
                                    : '暂无内容',
                              ),
                            ),
                    Error(:final errMsg) =>
                      Center(child: Text(errMsg ?? '加载失败')),
                  };
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
