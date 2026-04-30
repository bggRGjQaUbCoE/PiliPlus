import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/pages_tv/common/tv_card.dart';
import 'package:PiliPlus/pages_tv/common/tv_player_controls.dart';
import 'package:PiliPlus/pages_tv/common/tv_row.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';

class TVVideoPage extends StatefulWidget {
  const TVVideoPage({super.key});

  @override
  State<TVVideoPage> createState() => _TVVideoPageState();
}

class _TVVideoPageState extends State<TVVideoPage> {
  Map get args => Get.arguments as Map;
  int get aid => args['aid'];
  String get bvid => args['bvid'];
  int get cid => args['cid'];
  String? get title => args['title'];

  PlPlayerController? _playerController;
  final _relatedState = Rx<LoadingState<List?>>(LoadingState.loading());

  @override
  void initState() {
    super.initState();
    _playerController = PlPlayerController.instance;
    _loadRelated();
  }

  Future<void> _loadRelated() async {
    final res = await VideoHttp.relatedVideoList(bvid: bvid);
    if (res is Success) {
      _relatedState.value = Success(res.data);
    } else {
      _relatedState.value = const Error('加载失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                if (_playerController?.videoController != null)
                  Video(controller: _playerController!.videoController!),
                if (_playerController != null)
                  TVPlayerControls(
                    controller: _playerController!,
                    title: title,
                  ),
              ],
            ),
          ),
          Container(
            color: theme.colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
                  child: Text(
                    title ?? '',
                    style: theme.textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 180,
                  child: Obx(() {
                    final state = _relatedState.value;
                    return switch (state) {
                      Loading() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      Success(:final response) =>
                        response != null && response.isNotEmpty
                            ? ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                itemCount: response.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (ctx, i) {
                                  final item = response[i];
                                  return TVCard(
                                    title: item.title ?? '',
                                    subtitle: item.owner?.name ?? '',
                                    coverUrl: item.pic ?? item.cover,
                                    width: 180,
                                    onSelect: () {
                                      final int? rcid = item.cid;
                                      if (rcid != null) {
                                        PageUtils.toVideoPage(
                                          aid: item.aid,
                                          bvid: item.bvid ??
                                              IdUtils.av2bv(item.aid),
                                          cid: rcid,
                                          cover: item.pic ?? item.cover,
                                          title: item.title,
                                          off: true,
                                        );
                                      }
                                    },
                                  );
                                },
                              )
                            : const Center(child: Text('暂无相关视频')),
                      Error(:final errMsg) =>
                        Center(child: Text(errMsg ?? '加载失败')),
                    };
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
