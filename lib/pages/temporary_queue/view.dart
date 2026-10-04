import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/common/widgets/route_aware_mixin.dart';
import 'package:PiliPlus/services/temporary_queue_actions.dart';
import 'package:PiliPlus/services/temporary_queue_favorite_status.dart';
import 'package:PiliPlus/services/temporary_queue_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:material_ui/material_ui.dart';

class TemporaryQueuePage extends StatefulWidget {
  const TemporaryQueuePage({super.key});

  @override
  State<TemporaryQueuePage> createState() => _TemporaryQueuePageState();
}

class _TemporaryQueuePageState extends State<TemporaryQueuePage>
    with RouteAware, RouteAwareMixin {
  final TemporaryQueueService queue = TemporaryQueueService.instance;
  bool _writingFavorite = false;
  bool _cancelFavorite = false;
  int _finishedFavorite = 0;
  int _favoriteTotal = 0;

  @override
  void didPopNext() {
    queue.refreshAccount();
    super.didPopNext();
  }

  Future<void> _play(TemporaryQueueEntry item) async {
    final playable = await TemporaryQueueActions.resolveVideo(
      bvid: item.bvid,
      cid: item.cid,
      aid: item.aid,
      title: item.title,
      cover: item.cover,
    );
    if (playable == null) return;
    final attempt = item.failureReason != null
        ? queue.retryFailed(item, resolved: playable)
        : queue.beginAttempt(playable);
    if (attempt == null) return;
    PageUtils.toVideoPage(
      bvid: playable.bvid,
      cid: playable.cid!,
      title: playable.title,
      cover: playable.cover,
      aid: playable.aid,
      extraArguments: {TemporaryQueueService.attemptArgument: attempt},
    );
  }

  Future<List<({int id, String title})>?> _loadFolders() async {
    final result = <({int id, String title})>[];
    try {
      for (var page = 1; page < 1000; page++) {
        final response = await FavHttp.userfavFolder(
          pn: page,
          ps: 20,
          mid: Accounts.main.mid,
        );
        if (response case Success(:final response)) {
          final entries = response.list ?? const [];
          result.addAll(entries.map((e) => (id: e.id, title: e.title)));
          if (entries.isEmpty || response.hasMore == false) return result;
        } else {
          SmartDialog.showToast('获取收藏夹失败：$response');
          return null;
        }
      }
    } catch (e) {
      SmartDialog.showToast('获取收藏夹失败：$e');
      return null;
    }
    SmartDialog.showToast('收藏夹过多，无法确认完整列表');
    return null;
  }

  Future<int?> _createFolder() async {
    final text = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新建收藏夹'),
        content: TextField(
          controller: text,
          autofocus: true,
          maxLength: 40,
          decoration: const InputDecoration(hintText: '收藏夹名称'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, text.text.trim()),
            child: const Text('创建'),
          ),
        ],
      ),
    );
    text.dispose();
    if (name == null || name.isEmpty || !Accounts.main.isLogin) return null;
    try {
      final response = await FavHttp.addOrEditFolder(
        isAdd: true,
        title: name,
        privacy: 1,
        cover: '',
        intro: '',
      );
      if (response case Success(:final response)) return response.id;
      SmartDialog.showToast('创建收藏夹失败：$response');
    } catch (e) {
      SmartDialog.showToast('创建收藏夹结果未知：$e');
    }
    return null;
  }

  Future<void> _addAllToFavorite() async {
    if (!Accounts.main.isLogin) {
      SmartDialog.showToast('请先登录后再添加收藏');
      return;
    }
    if (_writingFavorite) return;
    final items = queue.visibleItems;
    if (items.isEmpty) {
      SmartDialog.showToast('临时播放列表为空');
      return;
    }
    SmartDialog.showLoading(msg: '正在读取收藏夹');
    final folders = await _loadFolders();
    SmartDialog.dismiss();
    if (!mounted || folders == null) return;
    final destination = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('全部添加至收藏'),
        content: SizedBox(
          width: 360,
          height: 360,
          child: ListView(
            children: [
              Text('选择目标收藏夹，共 ${items.length} 条；已存在项将跳过'),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.create_new_folder_outlined),
                title: const Text('新建收藏夹'),
                onTap: () => Navigator.pop(context, -1),
              ),
              for (final folder in folders)
                ListTile(
                  title: Text(folder.title),
                  onTap: () => Navigator.pop(context, folder.id),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
    if (destination == null || !mounted) return;
    final folderId = destination == -1 ? await _createFolder() : destination;
    if (folderId == null || !mounted || !Accounts.main.isLogin) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认添加至收藏'),
        content: Text(
          '将 ${items.length} 条视频添加到收藏夹 #$folderId。已有的视频会跳过，结果未知时会停止，不会自动重试。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确认添加'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      _writingFavorite = true;
      _cancelFavorite = false;
      _finishedFavorite = 0;
      _favoriteTotal = items.length;
    });
    var added = 0;
    var existed = 0;
    var failed = 0;
    var unknown = false;
    final accountId = Accounts.main.mid;
    for (final item in items) {
      if (_cancelFavorite ||
          !Accounts.main.isLogin ||
          Accounts.main.mid != accountId) {
        break;
      }
      try {
        final aid = item.aid ?? IdUtils.bv2av(item.bvid);
        final before = await FavHttp.videoInFolder(
          mid: accountId,
          rid: aid,
          type: 2,
        );
        if (before case Success(:final response)) {
          if (isConfirmedFavoriteInFolder(response.list, folderId)) {
            existed++;
          } else {
            final write = await FavHttp.favVideo(
              resources: '$aid:2',
              addIds: '$folderId',
            );
            if (write is! Success) {
              failed++;
              break;
            }
            final after = await FavHttp.videoInFolder(
              mid: accountId,
              rid: aid,
              type: 2,
            );
            if (after case Success(:final response)) {
              if (isConfirmedFavoriteInFolder(response.list, folderId)) {
                added++;
              } else {
                unknown = true;
                break;
              }
            } else {
              unknown = true;
              break;
            }
          }
        } else {
          failed++;
          break;
        }
      } catch (_) {
        unknown = true;
        break;
      }
      if (mounted) setState(() => _finishedFavorite++);
    }
    if (!mounted) return;
    setState(() => _writingFavorite = false);
    SmartDialog.showToast(
      '已确认新增 $added，已存在 $existed，失败 $failed'
      '${unknown ? '；有结果未知项，请到收藏夹核对' : ''}'
      '${_cancelFavorite ? '；已取消剩余项目' : ''}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: queue,
      builder: (context, _) {
        final items = queue.items;
        final current = queue.current;
        return Scaffold(
          appBar: AppBar(
            title: Text('临时播放列表 · 待播 ${items.length}'),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'favorite':
                      _addAllToFavorite();
                    case 'clear':
                      queue.clearPending();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'favorite',
                    child: Text('全部添加至收藏'),
                  ),
                  if (items.isNotEmpty)
                    const PopupMenuItem(value: 'clear', child: Text('清空待播')),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              if (_writingFavorite)
                ListTile(
                  title: Text('添加收藏：$_finishedFavorite / $_favoriteTotal'),
                  trailing: TextButton(
                    onPressed: () => _cancelFavorite = true,
                    child: const Text('取消剩余'),
                  ),
                ),
              Expanded(
                child: items.isEmpty && current == null
                    ? const Center(child: Text('暂无待播视频。可从视频的更多菜单添加。'))
                    : Column(
                        children: [
                          if (current != null)
                            ListTile(
                              leading: const Icon(Icons.play_circle),
                              title: Text(current.title),
                              subtitle: const Text('正在播放'),
                            ),
                          Expanded(
                            child: items.isEmpty
                                ? const Center(child: Text('待播队列为空'))
                                : ReorderableListView.builder(
                                    buildDefaultDragHandles: false,
                                    itemCount: items.length,
                                    onReorderItem: (oldIndex, newIndex) =>
                                        queue.reorder(
                                          oldIndex,
                                          newIndex > oldIndex
                                              ? newIndex + 1
                                              : newIndex,
                                        ),
                                    itemBuilder: (context, index) {
                                      final item = items[index];
                                      return ListTile(
                                        key: ValueKey(
                                          '${item.bvid}:${item.cid}',
                                        ),
                                        leading: Icon(
                                          item.failureReason == null
                                              ? Icons.play_arrow
                                              : Icons.error_outline,
                                        ),
                                        title: Text(item.title),
                                        subtitle: Text(
                                          item.failureReason == null
                                              ? '待播第 ${index + 1} 条 · ${item.bvid}'
                                              : '播放失败：${item.failureReason}',
                                        ),
                                        onTap: () => _play(item),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (item.failureReason != null) ...[
                                              IconButton(
                                                tooltip: '重试播放',
                                                onPressed: () => _play(item),
                                                icon: const Icon(Icons.refresh),
                                              ),
                                              IconButton(
                                                tooltip: '跳过并移除',
                                                onPressed: () =>
                                                    queue.remove(item),
                                                icon: const Icon(
                                                  Icons.skip_next,
                                                ),
                                              ),
                                            ],
                                            PopupMenuButton<String>(
                                              tooltip: '调整顺序',
                                              onSelected: (value) {
                                                if (value == 'up') {
                                                  queue.reorder(
                                                    index,
                                                    index - 1,
                                                  );
                                                }
                                                if (value == 'down') {
                                                  queue.reorder(
                                                    index,
                                                    index + 2,
                                                  );
                                                }
                                                if (value == 'remove') {
                                                  queue.remove(item);
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                if (index > 0)
                                                  const PopupMenuItem(
                                                    value: 'up',
                                                    child: Text('上移'),
                                                  ),
                                                if (index < items.length - 1)
                                                  const PopupMenuItem(
                                                    value: 'down',
                                                    child: Text('下移'),
                                                  ),
                                                const PopupMenuItem(
                                                  value: 'remove',
                                                  child: Text('移除'),
                                                ),
                                              ],
                                            ),
                                            ReorderableDragStartListener(
                                              index: index,
                                              child: const Icon(
                                                Icons.drag_handle,
                                              ),
                                            ),
                                          ],
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
      },
    );
  }
}
