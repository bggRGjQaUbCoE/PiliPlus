import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/skeleton/space_opus.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/space/space_opus/item.dart';
import 'package:PiliPlus/pages/member_opus/controller.dart';
import 'package:PiliPlus/pages/member_opus/widgets/space_opus_item.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/waterfall.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waterfall_flow/waterfall_flow.dart'
    hide SliverWaterfallFlowDelegateWithMaxCrossAxisExtent;

class MemberOpus extends StatefulWidget {
  const MemberOpus({
    super.key,
    this.isSingle = false,
    required this.heroTag,
    required this.mid,
  });

  final bool isSingle;
  final String? heroTag;
  final int mid;

  @override
  State<MemberOpus> createState() => _MemberOpusState();
}

class _MemberOpusState extends State<MemberOpus>
    with AutomaticKeepAliveClientMixin {
  late final _controller = Get.put(
    MemberOpusController(
      mid: widget.mid,
      heroTag: widget.heroTag,
    ),
    tag: widget.heroTag,
  );

  late double _maxWidth;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bottom = MediaQuery.viewPaddingOf(context).bottom;
    return Stack(
      children: [
        refreshIndicator(
          onRefresh: _controller.onRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(
                  top: widget.isSingle ? 12 : 0,
                  left: StyleString.safeSpace,
                  right: StyleString.safeSpace,
                  bottom: bottom + 100,
                ),
                sliver: Obx(() => _buildBody(_controller.loadingState.value)),
              ),
            ],
          ),
        ),
        if (_controller.filter?.isNotEmpty == true)
          Positioned(
            right: 16,
            bottom: bottom + 16,
            child: FloatingActionButton.extended(
              onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    clipBehavior: Clip.hardEdge,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _controller.filter!
                          .map(
                            (e) => ListTile(
                              onTap: () {
                                if (e == _controller.type.value) {
                                  return;
                                }
                                Get.back();
                                _controller
                                  ..type.value = e
                                  ..onReload();
                              },
                              tileColor: e == _controller.type.value
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.onInverseSurface
                                  : null,
                              dense: true,
                              title: Text(
                                e.text ?? e.tabName!,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ),
              icon: const Icon(size: 20, Icons.sort),
              label: Obx(
                () {
                  final type = _controller.type.value;
                  return Text(type.text ?? type.tabName!);
                },
              ),
            ),
          ),
      ],
    );
  }

  late final gridDelegate = SliverWaterfallFlowDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: Grid.smallCardWidth,
    mainAxisSpacing: StyleString.safeSpace,
    crossAxisSpacing: StyleString.safeSpace,
    callback: (value) => _maxWidth = value,
  );

  Widget _buildBody(LoadingState<List<SpaceOpusItemModel>?> loadingState) {
    return switch (loadingState) {
      Loading() => SliverWaterfallFlow(
        gridDelegate: gridDelegate,
        delegate: SliverChildBuilderDelegate(
          (context, index) => const SpaceOpusSkeleton(),
          childCount: 10,
        ),
      ),
      Success(:var response) =>
        response?.isNotEmpty == true
            ? SliverWaterfallFlow(
                gridDelegate: gridDelegate,
                delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    if (index == response.length - 1) {
                      _controller.onLoadMore();
                    }
                    return SpaceOpusItem(
                      item: response[index],
                      maxWidth: _maxWidth,
                    );
                  },
                  childCount: response!.length,
                ),
              )
            : HttpError(onReload: _controller.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }

  @override
  bool get wantKeepAlive => true;
}
