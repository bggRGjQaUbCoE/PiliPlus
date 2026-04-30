import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/rank_type.dart';
import 'package:PiliPlus/models/model_hot_video_item.dart';
import 'package:PiliPlus/pages_tv/common/tv_card.dart';
import 'package:PiliPlus/pages_tv/common/tv_focus_wrapper.dart';
import 'package:PiliPlus/pages_tv/common/tv_page.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TVRankPage extends StatefulWidget {
  const TVRankPage({super.key});

  @override
  State<TVRankPage> createState() => _TVRankPageState();
}

class _TVRankPageState extends State<TVRankPage> {
  final _selectedIndex = 0.obs;
  final _state = Rx<LoadingState<List?>>(LoadingState.loading());

  @override
  void initState() {
    super.initState();
    _loadRank(0);
  }

  Future<void> _loadRank(int index) async {
    _selectedIndex.value = index;
    _state.value = LoadingState.loading();
    final rankType = RankType.values[index];
    final LoadingState res;
    if (rankType.rid != null) {
      res = await VideoHttp.getRankVideoList(rankType.rid!);
    } else if (rankType.seasonType == 1) {
      res = await VideoHttp.pgcRankList(seasonType: rankType.seasonType!);
    } else {
      res = await VideoHttp.pgcSeasonRankList(seasonType: rankType.seasonType!);
    }
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
        appBar: AppBar(title: const Text('排行榜')),
        body: Row(
          children: [
            SizedBox(
              width: 160,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: RankType.values.length,
                itemBuilder: (ctx, i) {
                  final rt = RankType.values[i];
                  return Obx(() => TVFocusWrapper(
                        autoFocus: i == 0,
                        scaleFactor: 1.02,
                        borderRadius: 8,
                        onSelect: () => _loadRank(i),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: _selectedIndex.value == i
                                ? Theme.of(context)
                                    .colorScheme
                                    .primaryContainer
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(rt.label),
                        ),
                      ));
                },
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Obx(() {
                  final state = _state.value;
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
                                final String title = item.title ?? '';
                                final String? cover = item is HotVideoItemModel
                                    ? item.cover
                                    : item.cover;
                                final String subtitle = item is HotVideoItemModel
                                    ? (item.owner?.name ?? '')
                                    : '';
                                return TVCard(
                                  title: title,
                                  subtitle: subtitle,
                                  coverUrl: cover,
                                  badge: '#${i + 1}',
                                  width: double.infinity,
                                  onSelect: () {
                                    if (item is HotVideoItemModel) {
                                      final cid = item.cid;
                                      if (cid != null && cid > 0) {
                                        PageUtils.toVideoPage(
                                          aid: item.aid,
                                          bvid: item.bvid ??
                                              IdUtils.av2bv(item.aid!),
                                          cid: cid,
                                          cover: item.cover,
                                          title: item.title,
                                        );
                                      }
                                    }
                                  },
                                );
                              },
                            )
                          : const Center(child: Text('暂无数据')),
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
