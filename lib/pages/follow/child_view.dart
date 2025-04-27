import 'package:PiliPlus/common/skeleton/msg_feed_top.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/follow/result.dart';
import 'package:PiliPlus/pages/follow/child_controller.dart';
import 'package:PiliPlus/pages/follow/controller.dart';
import 'package:PiliPlus/pages/follow/widgets/follow_item.dart';
import 'package:PiliPlus/pages/video/detail/share/view.dart' show UserModel;
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowChildPage extends StatefulWidget {
  const FollowChildPage({
    super.key,
    this.controller,
    required this.mid,
    this.tagid,
    this.onSelect,
  });

  final FollowController? controller;
  final int mid;
  final int? tagid;
  final ValueChanged<UserModel>? onSelect;

  @override
  State<FollowChildPage> createState() => _FollowChildPageState();
}

class _FollowChildPageState extends State<FollowChildPage>
    with AutomaticKeepAliveClientMixin {
  late final _followController = Get.put(
      FollowChildController(widget.controller, widget.mid, widget.tagid),
      tag: Utils.generateRandomString(8));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.onSelect != null ||
        (widget.controller?.isOwner == true && widget.tagid == null)) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: _child,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _followController
              ..orderType.value =
                  _followController.orderType.value == OrderType.def
                      ? OrderType.attention
                      : OrderType.def
              ..onReload();
          },
          icon: const Icon(Icons.format_list_bulleted, size: 20),
          label: Obx(() => Text(_followController.orderType.value.title)),
        ),
      );
    }
    return _child;
  }

  Widget get _child => refreshIndicator(
        onRefresh: () async {
          await _followController.onRefresh();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 80),
              sliver:
                  Obx(() => _buildBody(_followController.loadingState.value)),
            ),
          ],
        ),
      );

  Widget _buildBody(LoadingState<List<FollowItemModel>?> loadingState) {
    return switch (loadingState) {
      Loading() => SliverList.builder(
          itemCount: 12,
          itemBuilder: (context, index) {
            return MsgFeedTopSkeleton();
          },
        ),
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverList.builder(
              itemCount: loadingState.response!.length,
              itemBuilder: (context, index) {
                if (index == loadingState.response!.length - 1) {
                  _followController.onLoadMore();
                }
                return FollowItem(
                  item: loadingState.response![index],
                  isOwner: widget.controller?.isOwner,
                  onSelect: widget.onSelect,
                  callback: (attr) {
                    List<FollowItemModel> list =
                        (_followController.loadingState.value as Success)
                            .response;
                    list[index].attribute = attr == 0 ? -1 : 0;
                    _followController.loadingState.refresh();
                  },
                );
              },
            )
          : HttpError(
              onReload: _followController.onReload,
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _followController.onReload,
        ),
    };
  }

  @override
  bool get wantKeepAlive =>
      widget.onSelect != null || widget.controller?.tabController != null;
}
