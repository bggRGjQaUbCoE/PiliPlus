import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/member_coin/widgets/item.dart';
import 'package:PiliPlus/pages/member_like/controller.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberLikePage extends StatefulWidget {
  const MemberLikePage({
    super.key,
    required this.mid,
    this.name,
  });

  final dynamic mid;
  final String? name;

  @override
  State<MemberLikePage> createState() => _MemberLikePageState();
}

class _MemberLikePageState extends State<MemberLikePage> {
  late final _ownerMid = Accounts.main.mid;

  late final _ctr = Get.put(
    MemberLikeController(mid: widget.mid),
    tag: Utils.makeHeroTag(widget.mid),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.mid == _ownerMid ? '我' : '${widget.name}'}的推荐'),
      ),
      body: Obx(() => _buildBody(_ctr.loadingState.value)),
    );
  }

  Widget _buildBody(LoadingState loadingState) {
    return switch (loadingState) {
      Loading() => loadingWidget,
      Success() => (loadingState.response as List?)?.isNotEmpty == true
          ? GridView.builder(
              padding: EdgeInsets.only(
                top: StyleString.safeSpace - 5,
                left: StyleString.safeSpace,
                right: StyleString.safeSpace,
                bottom: MediaQuery.paddingOf(context).bottom + 80,
              ),
              gridDelegate: SliverGridDelegateWithExtentAndRatio(
                mainAxisSpacing: StyleString.cardSpace,
                crossAxisSpacing: StyleString.cardSpace,
                maxCrossAxisExtent: Grid.smallCardWidth,
                childAspectRatio: StyleString.aspectRatio,
                mainAxisExtent: MediaQuery.textScalerOf(context).scale(75),
              ),
              itemCount: loadingState.response.length,
              itemBuilder: (context, index) {
                return MemberCoinsItem(coinItem: loadingState.response[index]);
              },
            )
          : scrollErrorWidget(callback: _ctr.onReload),
      Error() => scrollErrorWidget(
          errMsg: loadingState.errMsg,
          callback: _ctr.onReload,
        ),
      LoadingState() => throw UnimplementedError(),
    };
  }
}
