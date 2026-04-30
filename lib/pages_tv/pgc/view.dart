import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/pgc.dart';
import 'package:PiliPlus/pages_tv/common/tv_card.dart';
import 'package:PiliPlus/pages_tv/common/tv_page.dart';
import 'package:PiliPlus/pages_tv/common/tv_row.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TVPgcPage extends StatefulWidget {
  const TVPgcPage({super.key});

  @override
  State<TVPgcPage> createState() => _TVPgcPageState();
}

class _TVPgcPageState extends State<TVPgcPage> {
  final _state = Rx<LoadingState<List?>>(LoadingState.loading());

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final res = await PgcHttp.pgcIndex(page: 1);
    if (!mounted) return;
    if (res is Success) {
      _state.value = Success(res.data);
    } else {
      _state.value = Error(res is Error ? (res as Error).errMsg : '加载失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TVPage(
      child: Scaffold(
        appBar: AppBar(title: const Text('番剧')),
        body: Obx(() {
          final state = _state.value;
          return switch (state) {
            Loading() => const Center(child: CircularProgressIndicator()),
            Success(:final response) =>
              response != null && response.isNotEmpty
                  ? SingleChildScrollView(
                      child: TVRow(
                        title: '热门番剧',
                        height: 280,
                        itemCount: response.length,
                        itemBuilder: (ctx, i) {
                          final item = response[i];
                          return TVCard(
                            title: item.title ?? '',
                            subtitle: item.indexShow ?? item.badge ?? '',
                            coverUrl: item.cover,
                            isVertical: true,
                            width: 160,
                            height: 280,
                            autoFocus: i == 0,
                            onSelect: () {
                              final sid = item.seasonId;
                              if (sid != null) {
                                PageUtils.viewPgc(seasonId: sid);
                              }
                            },
                          );
                        },
                      ),
                    )
                  : const Center(child: Text('暂无数据')),
            Error(:final errMsg) => Center(child: Text(errMsg ?? '加载失败')),
          };
        }),
      ),
    );
  }
}
