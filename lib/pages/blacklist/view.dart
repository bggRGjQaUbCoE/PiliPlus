import 'package:PiliPlus/common/skeleton/msg_feed_top.dart';
import 'package:PiliPlus/common/widgets/http_error.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/user/black.dart';
import 'package:PiliPlus/pages/blacklist/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';

class BlackListPage extends StatefulWidget {
  const BlackListPage({super.key});

  @override
  State<BlackListPage> createState() => _BlackListPageState();
}

class _BlackListPageState extends State<BlackListPage> {
  final _blackListController = Get.put(BlackListController());

  @override
  void dispose() {
    List<BlackListItem> list =
        _blackListController.loadingState.value is Success
            ? (_blackListController.loadingState.value as Success).response
            : <BlackListItem>[];
    GStorage.blackMids = list.map((e) => e.mid!).toSet();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
              '黑名单管理${_blackListController.total.value == -1 ? '' : ': ${_blackListController.total.value}'}'),
        ),
      ),
      body: refreshIndicator(
        onRefresh: () async => await _blackListController.onRefresh(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _blackListController.scrollController,
          slivers: [
            Obx(() => _buildBody(_blackListController.loadingState.value))
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LoadingState<List<BlackListItem>?> loadingState) {
    return switch (loadingState) {
      Loading() => SliverList.builder(
          itemCount: 12,
          itemBuilder: (context, index) {
            return const MsgFeedTopSkeleton();
          },
        ),
      Success() => loadingState.response?.isNotEmpty == true
          ? SliverList.builder(
              itemCount: loadingState.response!.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == loadingState.response!.length - 1) {
                  _blackListController.onLoadMore();
                }
                final item = loadingState.response![index];
                return ListTile(
                  onTap: () {
                    Get.toNamed('/member?mid=${item.mid}');
                  },
                  leading: NetworkImgLayer(
                    width: 45,
                    height: 45,
                    type: 'avatar',
                    src: item.face,
                  ),
                  title: Text(
                    item.uname!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    Utils.dateFormat(item.mtime),
                    maxLines: 1,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.outline),
                    overflow: TextOverflow.ellipsis,
                  ),
                  dense: true,
                  trailing: TextButton(
                    onPressed: () => _blackListController.onRemove(
                      context,
                      index,
                      item.uname,
                      item.mid,
                    ),
                    child: const Text('移除'),
                  ),
                );
              },
            )
          : HttpError(
              onReload: _blackListController.onReload,
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          onReload: _blackListController.onReload,
        ),
    };
  }
}
