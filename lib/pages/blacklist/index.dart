import 'package:PiliPlus/common/widgets/dialog.dart';
import 'package:PiliPlus/common/widgets/loading_widget.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/user/black.dart';
import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/http/black.dart';
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
    List list = _blackListController.loadingState.value is Success
        ? (_blackListController.loadingState.value as Success).response
        : <BlackListItem>[];
    GStorage.setBlackMidsList(
        list.isNotEmpty ? list.map((e) => e.mid!).toList() : <int>[]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text('黑名单管理: ${_blackListController.total.value}'),
        ),
      ),
      body: refreshIndicator(
        onRefresh: () async => await _blackListController.onRefresh(),
        child: Obx(() => _buildBody(_blackListController.loadingState.value)),
      ),
    );
  }

  Widget _buildBody(LoadingState loadingState) {
    return switch (loadingState) {
      Loading() => loadingWidget,
      Success() => (loadingState.response as List?)?.isNotEmpty == true
          ? ListView.builder(
              controller: _blackListController.scrollController,
              itemCount: loadingState.response.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == loadingState.response.length - 1) {
                  _blackListController.onLoadMore();
                }
                return ListTile(
                  onTap: () {
                    Get.toNamed(
                        '/member?mid=${loadingState.response[index].mid}');
                  },
                  leading: NetworkImgLayer(
                    width: 45,
                    height: 45,
                    type: 'avatar',
                    src: loadingState.response[index].face,
                  ),
                  title: Text(
                    loadingState.response[index].uname!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    Utils.dateFormat(loadingState.response[index].mtime),
                    maxLines: 1,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.outline),
                    overflow: TextOverflow.ellipsis,
                  ),
                  dense: true,
                  trailing: TextButton(
                    onPressed: () => _blackListController.removeBlack(
                      context,
                      loadingState.response[index].uname,
                      loadingState.response[index].mid,
                    ),
                    child: const Text('移除'),
                  ),
                );
              },
            )
          : errorWidget(
              callback: _blackListController.onReload,
            ),
      Error() => errorWidget(
          errMsg: loadingState.errMsg,
          callback: _blackListController.onReload,
        ),
      LoadingState() => throw UnimplementedError(),
    };
  }
}

class BlackListController extends CommonController {
  int pageSize = 50;
  RxInt total = 0.obs;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  bool customHandleResponse(Success response) {
    total.value = response.response.total;
    if ((response.response.list as List?).isNullOrEmpty) {
      isEnd = true;
    }
    if (currentPage != 1 && loadingState.value is Success) {
      response.response.list ??= <BlackListItem>[];
      response.response.list!
          .insertAll(0, (loadingState.value as Success).response);
    }
    if (isEnd.not && response.response.list.length >= total.value) {
      isEnd = true;
    }
    loadingState.value = LoadingState.success(response.response.list.isNotEmpty
        ? response.response.list
        : <BlackListItem>[]);
    return true;
  }

  Future removeBlack(context, name, mid) async {
    showConfirmDialog(
      context: context,
      title: '确定将 $name 移出黑名单？',
      onConfirm: () async {
        Get.back();
        var result = await VideoHttp.relationMod(mid: mid, act: 6, reSrc: 11);
        if (result['status']) {
          List list = (loadingState.value as Success).response;
          list.removeWhere((e) => e.mid == mid);
          total.value = total.value - 1;
          loadingState.value =
              LoadingState.success(list.isNotEmpty ? list : <BlackListItem>[]);
          SmartDialog.showToast('操作成功');
        }
      },
    );
  }

  @override
  Future<LoadingState> customGetData() =>
      BlackHttp.blackList(pn: currentPage, ps: pageSize);
}
