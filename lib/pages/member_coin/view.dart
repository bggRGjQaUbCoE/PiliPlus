import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/skeleton/video_card_v.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/member/coin.dart';
import 'package:PiliPlus/pages/member_coin/controller.dart';
import 'package:PiliPlus/pages/member_coin/widgets/item.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberCoinPage extends StatefulWidget {
  const MemberCoinPage({
    super.key,
    required this.mid,
    this.name,
  });

  final dynamic mid;
  final String? name;

  @override
  State<MemberCoinPage> createState() => _MemberCoinPageState();
}

class _MemberCoinPageState extends State<MemberCoinPage> {
  late final _ownerMid = Accounts.main.mid;

  late final _ctr = Get.put(
    MemberCoinController(mid: widget.mid),
    tag: Utils.makeHeroTag(widget.mid),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.mid == _ownerMid ? '我' : '${widget.name}'}的最近投币'),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                top: StyleString.safeSpace - 5,
                left: StyleString.safeSpace,
                right: StyleString.safeSpace,
                bottom: MediaQuery.paddingOf(context).bottom + 80,
              ),
              sliver: Obx(() => _buildBody(_ctr.loadingState.value)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LoadingState<List<MemberCoinsDataModel>?> loadingState) {
    return switch (loadingState) {
      Loading() => SliverGrid.builder(
          gridDelegate: SliverGridDelegateWithExtentAndRatio(
            mainAxisSpacing: StyleString.cardSpace,
            crossAxisSpacing: StyleString.cardSpace,
            maxCrossAxisExtent: Grid.smallCardWidth,
            childAspectRatio: StyleString.aspectRatio,
            mainAxisExtent: MediaQuery.textScalerOf(context).scale(90),
          ),
          itemCount: 16,
          itemBuilder: (context, index) {
            return const VideoCardVSkeleton();
          },
        ),
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithExtentAndRatio(
                mainAxisSpacing: StyleString.cardSpace,
                crossAxisSpacing: StyleString.cardSpace,
                maxCrossAxisExtent: Grid.smallCardWidth,
                childAspectRatio: StyleString.aspectRatio,
                mainAxisExtent: MediaQuery.textScalerOf(context).scale(75),
              ),
              itemCount: loadingState.response!.length,
              itemBuilder: (context, index) {
                return MemberCoinsItem(coinItem: loadingState.response![index]);
              },
            )
          : HttpError(onReload: _ctr.onReload),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _ctr.onReload,
        ),
    };
  }
}
