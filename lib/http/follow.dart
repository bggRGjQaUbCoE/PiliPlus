import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/follow/result.dart';

class FollowHttp {
  static Future<LoadingState<FollowDataModel>> followings({
    int? vmid,
    int? pn,
    int? ps,
    String orderType = '',
  }) async {
    var res = await Request().get(Api.followings, queryParameters: {
      'vmid': vmid,
      'pn': pn,
      'ps': ps,
      'order': 'desc',
      'order_type': orderType,
    });
    if (res.data['code'] == 0) {
      return Success(
        FollowDataModel.fromJson(res.data['data']),
      );
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<FollowDataModel>> followingsNew({
    int? vmid,
    int? pn,
    int? ps,
    String orderType = '', // ''=>最近关注，'attention'=>最常访问
  }) async {
    var res = await Request().get(Api.followings, queryParameters: {
      'vmid': vmid,
      'pn': pn,
      'ps': ps,
      'order': 'desc',
      'order_type': orderType,
    });

    if (res.data['code'] == 0) {
      return Success(
        FollowDataModel.fromJson(res.data['data']),
      );
    } else {
      return Error(res.data['message']);
    }
  }
}
