import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/space/space_fav/data.dart';
import 'package:PiliPlus/models_new/space/space_fav/list.dart';
import 'package:PiliPlus/pages/common/common_data_controller.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class MemberFavoriteCtr
    extends CommonDataController<List<SpaceFavData>?, List<SpaceFavData>?> {
  MemberFavoriteCtr({
    required this.mid,
  });

  final int mid;

  late int favPage = 2;
  bool _favExpand = true;
  final RxBool favEnd = true.obs;
  final Rx<SpaceFavData> favState = SpaceFavData().obs;

  late int subPage = 2;
  bool _subExpand = true;
  final RxBool subEnd = true.obs;
  final Rx<SpaceFavData> subState = SpaceFavData().obs;

  bool isExpand(bool isFav) {
    return isFav ? _favExpand : _subExpand;
  }

  void setExpand(bool isFav) {
    if (isFav) {
      flag = _favExpand;
      _favExpand = !_favExpand;
    } else {
      _subExpand = !_subExpand;
    }
  }

  bool flag = false;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  Future<void> onRefresh() {
    favPage = 2;
    subPage = 2;
    return super.onRefresh();
  }

  @override
  bool customHandleResponse(
    bool isRefresh,
    Success<List<SpaceFavData>?> response,
  ) {
    try {
      List<SpaceFavData> res = response.response!;
      favState.value = res.first;
      subState.value = res[1];

      favEnd.value =
          (res.first.mediaListResponse?.count ?? -1) <=
          (res.first.mediaListResponse?.list?.length ?? -1);
      subEnd.value =
          (res[1].mediaListResponse?.count ?? -1) <=
          (res[1].mediaListResponse?.list?.length ?? -1);
    } catch (e) {
      if (kDebugMode) debugPrint(e.toString());
    }
    loadingState.value = response;
    return true;
  }

  Future<void> userFavFolder() async {
    try {
      final res = await Request.get(
        Api.userFavFolder,
        queryParameters: {
          'pn': favPage,
          'ps': 20,
          'up_mid': mid,
        },
      );
      if (res.data['code'] == 0) {
        favPage++;
        final data = res.data['data'];
        if (data != null) {
          favEnd.value = data['has_more'] == false;
          final list = (data['list'] as List<dynamic>?)
              ?.map((item) => SpaceFavItemModel.fromJson(item))
              .toList();
          if (list != null && list.isNotEmpty) {
            favState
              ..value.mediaListResponse!.list!.addAll(list)
              ..refresh();
          } else {
            favEnd.value = true;
          }
        } else {
          favEnd.value = true;
        }
      } else {
        SmartDialog.showToast(res.data['message']);
      }
    } catch (e) {
      SmartDialog.showToast(e.toString());
    }
  }

  Future<void> userSubFolder() async {
    try {
      final res = await Request.get(
        Api.userSubFolder,
        queryParameters: {
          'up_mid': mid,
          'ps': 20,
          'pn': subPage,
          'platform': 'web',
        },
      );
      if (res.data['code'] == 0) {
        subPage++;
        final data = res.data['data'];
        if (data != null) {
          subEnd.value = data['has_more'] == false;
          final list = (data['list'] as List<dynamic>?)
              ?.map((item) => SpaceFavItemModel.fromJson(item))
              .toList();
          if (list != null && list.isNotEmpty) {
            subState
              ..value.mediaListResponse!.list!.addAll(list)
              ..refresh();
          } else {
            subEnd.value = true;
          }
        } else {
          subEnd.value = true;
        }
      } else {
        SmartDialog.showToast(res.data['message']);
      }
    } catch (e) {
      SmartDialog.showToast(e.toString());
    }
  }

  @override
  Future<LoadingState<List<SpaceFavData>?>> customGetData() =>
      FavHttp.spaceFav(mid: mid);
}
