import 'package:PiliPlus/common/skeleton/msg_feed_top.dart';
import 'package:PiliPlus/common/widgets/dialog.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/fans/result.dart';
import 'package:PiliPlus/pages/video/detail/share/view.dart' show UserModel;
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';

import '../../utils/grid.dart';
import 'controller.dart';

class FansPage extends StatefulWidget {
  const FansPage({
    super.key,
    this.mid,
    this.onSelect,
  });

  final int? mid;
  final ValueChanged<UserModel>? onSelect;

  @override
  State<FansPage> createState() => _FansPageState();
}

class _FansPageState extends State<FansPage> {
  late int mid;
  String? name;
  late bool isOwner;
  late FansController _fansController;

  @override
  void initState() {
    super.initState();
    final userInfo = GStorage.userInfo.get('userInfoCache');
    mid = widget.mid ??
        (Get.parameters['mid'] != null
            ? int.parse(Get.parameters['mid']!)
            : userInfo?.mid);
    isOwner = mid == userInfo?.mid;
    name = Get.parameters['name'] ?? userInfo?.uname;
    _fansController = Get.put(FansController(mid), tag: Utils.makeHeroTag(mid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.onSelect != null
          ? null
          : AppBar(title: Text(isOwner ? '我的粉丝' : '$name的粉丝')),
      body: SafeArea(
        bottom: false,
        child: refreshIndicator(
          onRefresh: () async => await _fansController.onRefresh(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _fansController.scrollController,
            slivers: [
              Obx(() => _buildBody(_fansController.loadingState.value)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(LoadingState<List<FansItemModel>?> loadingState) {
    return switch (loadingState) {
      Loading() => SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: Grid.smallCardWidth * 2,
            mainAxisExtent: 66,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return const MsgFeedTopSkeleton();
            },
            childCount: 16,
          ),
        ),
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverPadding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 80),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: Grid.smallCardWidth * 2,
                  mainAxisExtent: 66,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (index == loadingState.response!.length - 1) {
                      _fansController.onLoadMore();
                    }
                    final item = loadingState.response![index];
                    String heroTag = Utils.makeHeroTag(item.mid);
                    return ListTile(
                      onTap: () {
                        if (widget.onSelect != null) {
                          widget.onSelect!(UserModel(
                            mid: item.mid!,
                            name: item.uname!,
                            avatar: item.face!,
                          ));
                          return;
                        }
                        Get.toNamed(
                          '/member?mid=${item.mid}',
                          arguments: {'face': item.face, 'heroTag': heroTag},
                        );
                      },
                      onLongPress: widget.onSelect != null
                          ? null
                          : isOwner
                              ? () {
                                  showConfirmDialog(
                                    context: context,
                                    title: '确定移除 ${item.uname} ？',
                                    onConfirm: () {
                                      _fansController.onRemoveFan(
                                          index, item.mid!);
                                    },
                                  );
                                }
                              : null,
                      leading: Hero(
                        tag: heroTag,
                        child: NetworkImgLayer(
                          width: 45,
                          height: 45,
                          type: 'avatar',
                          src: item.face,
                        ),
                      ),
                      title: Text(
                        item.uname!,
                        style: const TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        item.sign ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      dense: true,
                      trailing: const SizedBox(width: 6),
                    );
                  },
                  childCount: loadingState.response!.length,
                ),
              ),
            )
          : HttpError(
              onReload: _fansController.onReload,
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _fansController.onReload,
        ),
    };
  }
}
