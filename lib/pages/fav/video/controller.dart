import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/data.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:get/get.dart';

class FavController extends CommonListController<FavFolderData, FavFolderInfo> {
  late final account = Accounts.main;
  final RxString folderQuery = ''.obs;
  int _searchGeneration = 0;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  Future<void> queryData([bool isRefresh = true]) {
    if (!account.isLogin) {
      loadingState.value = const Error('账号未登录');
      return Future.syncValue(null);
    }
    return super.queryData(isRefresh);
  }

  @override
  List<FavFolderInfo>? getDataList(FavFolderData response) {
    if (response.hasMore == false) {
      isEnd = true;
    }
    return response.list;
  }

  @override
  Future<LoadingState<FavFolderData>> customGetData() => FavHttp.userfavFolder(
    pn: page,
    ps: 20,
    mid: account.mid,
  );

  List<FavFolderInfo> visibleFolders(List<FavFolderInfo> folders) {
    final query = folderQuery.value.trim().toLowerCase();
    if (query.isEmpty) return folders;
    return folders
        .where(
          (folder) =>
              folder.title.toLowerCase().contains(query) ||
              (folder.intro?.toLowerCase().contains(query) ?? false),
        )
        .toList();
  }

  Future<void> updateFolderSearch(String value) async {
    folderQuery.value = value.trim();
    final generation = ++_searchGeneration;
    if (folderQuery.value.isEmpty) return;
    for (var attempt = 0; attempt < 25 && !isEnd; attempt++) {
      if (generation != _searchGeneration) return;
      final folders = loadingState.value.dataOrNull;
      if (folders != null && visibleFolders(folders).isNotEmpty) return;
      await onLoadMore();
    }
  }
}
