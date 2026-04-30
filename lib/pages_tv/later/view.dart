import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/pages_tv/common/tv_card.dart';
import 'package:PiliPlus/pages_tv/common/tv_page.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TVLaterPage extends StatefulWidget {
  const TVLaterPage({super.key});

  @override
  State<TVLaterPage> createState() => _TVLaterPageState();
}

class _TVLaterPageState extends State<TVLaterPage> {
  final _state = Rx<LoadingState<List?>>(LoadingState.loading());

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final res = await UserHttp.seeYouLater(page: 1);
    if (!mounted) return;
    if (res is Success) {
      final data = res.data;
      _state.value = Success(data.list);
    } else {
      _state.value = Error(res is Error ? (res as Error).errMsg : '加载失败');
    }
  }

  void _showRemoveDialog(dynamic item, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('提示'),
        content: Text('确定移除「${item.title ?? ''}」？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final res =
                  await UserHttp.toViewDel(aids: item.aid.toString());
              if (res.isSuccess) {
                final list =
                    List.from(_state.value.dataOrNull ?? []);
                list.removeAt(index);
                _state.value = Success(list);
              }
            },
            child: const Text('移除'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TVPage(
      child: Scaffold(
        appBar: AppBar(title: const Text('稍后再看')),
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
                          return TVCard(
                            title: item.title ?? '',
                            subtitle: item.owner?.name ?? '',
                            coverUrl: item.pic,
                            autoFocus: i == 0,
                            width: double.infinity,
                            onSelect: () {
                              final cid = item.cid;
                              if (cid != null && cid > 0) {
                                PageUtils.toVideoPage(
                                  aid: item.aid,
                                  bvid: item.bvid ??
                                      IdUtils.av2bv(item.aid),
                                  cid: cid,
                                  cover: item.pic,
                                  title: item.title,
                                  progress: (item.progress ?? 0) * 1000,
                                );
                              }
                            },
                            onLongPress: () => _showRemoveDialog(item, i),
                          );
                        },
                      )
                    : const Center(child: Text('暂无稍后再看')),
              Error(:final errMsg) => Center(child: Text(errMsg ?? '加载失败')),
            };
          }),
        ),
      ),
    );
  }
}
