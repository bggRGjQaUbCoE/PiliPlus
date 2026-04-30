import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/dynamic/dynamics_type.dart';
import 'package:PiliPlus/pages_tv/common/tv_card.dart';
import 'package:PiliPlus/pages_tv/common/tv_page.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TVDynamicsPage extends StatefulWidget {
  const TVDynamicsPage({super.key});

  @override
  State<TVDynamicsPage> createState() => _TVDynamicsPageState();
}

class _TVDynamicsPageState extends State<TVDynamicsPage> {
  final _state = Rx<LoadingState<List?>>(LoadingState.loading());

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final res = await DynamicsHttp.followDynamic(type: DynamicsTabType.video);
    if (!mounted) return;
    if (res is Success) {
      final data = res.data;
      final items = data.items;
      _state.value = Success(items);
    } else {
      _state.value = Error(res is Error ? (res as Error).errMsg : '加载失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TVPage(
      child: Scaffold(
        appBar: AppBar(title: const Text('动态')),
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
                          final module = item.modules;
                          final major = module?.moduleDynamic?.major;
                          final archive = major?.archive;
                          final author = module?.moduleAuthor;
                          return TVCard(
                            title: archive?.title ?? item.idStr ?? '',
                            subtitle: author?.name ?? '',
                            coverUrl: archive?.cover,
                            autoFocus: i == 0,
                            width: double.infinity,
                            onSelect: () {
                              PageUtils.pushDynDetail(item);
                            },
                          );
                        },
                      )
                    : const Center(child: Text('暂无动态')),
              Error(:final errMsg) => Center(child: Text(errMsg ?? '加载失败')),
            };
          }),
        ),
      ),
    );
  }
}
