import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/pages_tv/common/tv_card.dart';
import 'package:PiliPlus/pages_tv/common/tv_page.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TVHistoryPage extends StatefulWidget {
  const TVHistoryPage({super.key});

  @override
  State<TVHistoryPage> createState() => _TVHistoryPageState();
}

class _TVHistoryPageState extends State<TVHistoryPage> {
  final _state = Rx<LoadingState<List?>>(LoadingState.loading());

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final res = await UserHttp.historyList(type: '');
    if (!mounted) return;
    if (res is Success) {
      final data = res.data;
      _state.value = Success(data.list);
    } else {
      _state.value = Error(res is Error ? (res as Error).errMsg : '加载失败');
    }
  }

  void _showDeleteDialog(dynamic item, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('提示'),
        content: Text('确定删除「${item.title ?? ''}」？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final kid = '${item.history.business}_${item.kid}';
              final res = await UserHttp.delHistory(kid);
              if (res.isSuccess) {
                final list =
                    List.from(_state.value.dataOrNull ?? []);
                list.removeAt(index);
                _state.value = Success(list);
              }
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TVPage(
      child: Scaffold(
        appBar: AppBar(title: const Text('历史记录')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            final state = _state.value;
            return switch (state) {
              Loading() => const Center(child: CircularProgressIndicator()),
              Success(:final response) =>
                response != null && response.isNotEmpty
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          childAspectRatio: 16 / 13,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: response.length,
                        itemBuilder: (ctx, i) {
                          final item = response[i];
                          final history = item.history;
                          return TVCard(
                            title: item.title ?? '',
                            subtitle: item.authorName ?? '',
                            coverUrl: item.cover,
                            autoFocus: i == 0,
                            width: double.infinity,
                            onSelect: () {
                              final oid = history.oid;
                              final cid = history.cid;
                              final bvid = history.bvid;
                              if (cid != null && cid > 0) {
                                PageUtils.toVideoPage(
                                  aid: oid,
                                  bvid: bvid ?? (oid != null
                                      ? IdUtils.av2bv(oid)
                                      : null),
                                  cid: cid,
                                  cover: item.cover,
                                  title: item.title,
                                  progress: (item.progress ?? 0) * 1000,
                                );
                              }
                            },
                            onLongPress: () => _showDeleteDialog(item, i),
                          );
                        },
                      )
                    : const Center(child: Text('暂无历史记录')),
              Error(:final errMsg) => Center(child: Text(errMsg ?? '加载失败')),
            };
          }),
        ),
      ),
    );
  }
}
