import 'package:PiliPlus/http/live.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/live/live_feed_index/card_data_list_item.dart';
import 'package:PiliPlus/pages_tv/common/tv_card.dart';
import 'package:PiliPlus/pages_tv/common/tv_page.dart';
import 'package:PiliPlus/pages_tv/common/tv_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TVLivePage extends StatefulWidget {
  const TVLivePage({super.key});

  @override
  State<TVLivePage> createState() => _TVLivePageState();
}

class _TVLivePageState extends State<TVLivePage> {
  final _state = Rx<LoadingState<List?>>(LoadingState.loading());

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final res = await LiveHttp.liveFeedIndex(pn: 1);
    if (res is Success) {
      final data = res.data;
      final cardList = data.cardList;
      if (cardList != null && cardList.isNotEmpty) {
        final items = <CardLiveItem>[];
        for (final card in cardList) {
          final item = card.cardData?.smallCardV1;
          if (item != null) {
            items.add(item);
          }
        }
        _state.value = Success(items);
      } else {
        _state.value = const Success(null);
      }
    } else {
      _state.value = Error(res is Error ? (res as Error).errMsg : '加载失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TVPage(
      child: Scaffold(
        appBar: AppBar(title: const Text('直播')),
        body: Obx(() {
          final state = _state.value;
          return switch (state) {
            Loading() => const Center(child: CircularProgressIndicator()),
            Success(:final response) =>
              response != null && response.isNotEmpty
                  ? TVRow(
                      title: '推荐直播',
                      height: 220,
                      itemCount: response.length,
                      itemBuilder: (ctx, i) {
                        final item = response[i] as CardLiveItem;
                        return TVCard(
                          title: item.title ?? '',
                          subtitle: item.uname ?? '',
                          coverUrl: item.cover,
                          badge: item.areaName,
                          autoFocus: i == 0,
                          onSelect: () {
                            final roomId = item.roomid;
                            if (roomId != null) {
                              Get.toNamed(
                                '/liveRoom',
                                arguments: {'roomId': roomId},
                              );
                            }
                          },
                        );
                      },
                    )
                  : const Center(child: Text('暂无直播')),
            Error(:final errMsg) => Center(child: Text(errMsg ?? '加载失败')),
          };
        }),
      ),
    );
  }
}
