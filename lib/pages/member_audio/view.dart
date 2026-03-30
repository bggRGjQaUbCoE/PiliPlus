import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/loading_widget/loading_widget.dart';
import 'package:PiliPlus/common/widgets/sliver/sliver_floating_header.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/space/space_audio/item.dart';
import 'package:PiliPlus/pages/member_audio/controller.dart';
import 'package:PiliPlus/pages/member_audio/widgets/item.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberAudio extends StatefulWidget {
  const MemberAudio({
    super.key,
    required this.heroTag,
    required this.mid,
  });

  final String? heroTag;
  final int mid;

  @override
  State<MemberAudio> createState() => _MemberAudioState();
}

class _MemberAudioState extends State<MemberAudio>
    with AutomaticKeepAliveClientMixin {
  late final MemberAudioController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      MemberAudioController(widget.mid),
      tag: widget.heroTag,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colorScheme = ColorScheme.of(context);
    return refreshIndicator(
      onRefresh: _controller.onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
            ),
            sliver: Obx(
              () => _buildBody(colorScheme, _controller.loadingState.value),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  late final gridDelegate = SliverGridDelegateWithExtentAndRatio(
    mainAxisSpacing: 2,
    maxCrossAxisExtent: Grid.smallCardWidth * 2,
    childAspectRatio: Style.aspectRatio * 2.6,
    minHeight: MediaQuery.textScalerOf(context).scale(90),
  );

  Widget _buildBody(
    ColorScheme colorScheme,
    LoadingState<List<SpaceAudioItem>?> loadingState,
  ) {
    return switch (loadingState) {
      Loading() => linearLoading,
      Success(:final response) =>
        response != null && response.isNotEmpty
            ? SliverMainAxisGroup(
                slivers: [
                  SliverFloatingHeaderWidget(
                    backgroundColor: colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 2.5, 8, 2.5),
                      child: Row(
                        children: [
                          Text(
                            '共${_controller.totalSize ?? 0}首',
                            style: const TextStyle(fontSize: 13),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: TextButton.icon(
                              style: Style.buttonStyle,
                              onPressed: _controller.toViewPlayAll,
                              icon: Icon(
                                Icons.play_circle_outline_rounded,
                                size: 16,
                                color: colorScheme.secondary,
                              ),
                              label: Text(
                                '播放全部',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: colorScheme.secondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverGrid.builder(
                    gridDelegate: gridDelegate,
                    itemBuilder: (context, index) {
                      if (index == response.length - 1) {
                        _controller.onLoadMore();
                      }
                      return MemberAudioItem(
                        item: response[index],
                      );
                    },
                    itemCount: response.length,
                  ),
                ],
              )
            : HttpError(onReload: _controller.onReload),
      Error(:final errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }
}
