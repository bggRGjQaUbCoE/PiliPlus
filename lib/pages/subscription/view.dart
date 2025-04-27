import 'package:PiliPlus/common/skeleton/video_card_h.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/user/sub_folder.dart';
import 'package:PiliPlus/pages/subscription/widgets/item.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'controller.dart';

class SubPage extends StatefulWidget {
  const SubPage({super.key});

  @override
  State<SubPage> createState() => _SubPageState();
}

class _SubPageState extends State<SubPage> {
  final SubController _subController = Get.put(SubController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的订阅')),
      body: SafeArea(
        top: false,
        bottom: false,
        child: refreshIndicator(
          onRefresh: () async {
            await _subController.onRefresh();
          },
          child: CustomScrollView(
            slivers: [
              Obx(() => _buildBody(_subController.loadingState.value)),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 80,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(LoadingState<List<SubFolderItemData>?> loadingState) {
    return switch (loadingState) {
      Loading() => SliverGrid(
          gridDelegate: Grid.videoCardHDelegate(context),
          delegate: SliverChildBuilderDelegate(
            (context, index) => const VideoCardHSkeleton(),
            childCount: 10,
          ),
        ),
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverGrid(
              gridDelegate: Grid.videoCardHDelegate(context),
              delegate: SliverChildBuilderDelegate(
                childCount: loadingState.response!.length,
                (BuildContext context, int index) {
                  if (index == loadingState.response!.length - 1) {
                    _subController.onLoadMore();
                  }
                  return SubItem(
                    subFolderItem: loadingState.response![index],
                    cancelSub: _subController.cancelSub,
                  );
                },
              ),
            )
          : HttpError(
              onReload: _subController.onReload,
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _subController.onReload,
        ),
    };
  }
}
