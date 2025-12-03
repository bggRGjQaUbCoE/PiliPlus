import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart';
import 'package:PiliPlus/common/widgets/loading_widget/http_error.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:PiliPlus/pages/member_pgc/controller.dart';
import 'package:PiliPlus/pages/member_pgc/widgets/pgc_card_v_member_pgc.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberBangumi extends StatefulWidget {
  const MemberBangumi({
    super.key,
    required this.heroTag,
    required this.mid,
  });

  final String? heroTag;
  final int mid;

  @override
  State<MemberBangumi> createState() => _MemberBangumiState();
}

class _MemberBangumiState extends State<MemberBangumi>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final _controller = Get.put(
    MemberBangumiCtr(
      heroTag: widget.heroTag,
      mid: widget.mid,
    ),
    tag: widget.heroTag,
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return refreshIndicator(
      onRefresh: _controller.onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              left: StyleString.safeSpace,
              right: StyleString.safeSpace,
              top: StyleString.safeSpace,
              bottom: MediaQuery.viewPaddingOf(context).bottom + 100,
            ),
            sliver: Obx(
              () => _buildBody(_controller.loadingState.value),
            ),
          ),
        ],
      ),
    );
  }

  late final gridDelegate = SliverGridDelegateWithExtentAndRatio(
    mainAxisSpacing: StyleString.cardSpace,
    crossAxisSpacing: StyleString.cardSpace,
    maxCrossAxisExtent: Grid.smallCardWidth * 0.6,
    childAspectRatio: 0.75,
    mainAxisExtent: MediaQuery.textScalerOf(context).scale(52),
  );

  Widget _buildBody(LoadingState<List<SpaceArchiveItem>?> loadingState) {
    return switch (loadingState) {
      Loading() => const SliverToBoxAdapter(),
      Success(:var response) =>
        response != null && response.isNotEmpty
            ? SliverGrid.builder(
                gridDelegate: gridDelegate,
                itemBuilder: (context, index) {
                  if (index == response.length - 1) {
                    _controller.onLoadMore();
                  }
                  return PgcCardVMemberPgc(
                    item: response[index],
                  );
                },
                itemCount: response.length,
              )
            : HttpError(onReload: _controller.onReload),
      Error(:var errMsg) => HttpError(
        errMsg: errMsg,
        onReload: _controller.onReload,
      ),
    };
  }
}
