import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/user/danmaku_block.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:dio/dio.dart';

class DanmakuFilterHttp {
  static Future<LoadingState<DanmakuBlockDataModel>> danmakuFilter() async {
    var res = await Request().get(Api.danmakuFilter);
    if (res.data['code'] == 0) {
      return Success(DanmakuBlockDataModel.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<Null>> danmakuFilterDel({required int ids}) async {
    var res = await Request().post(
      Api.danmakuFilterDel,
      data: {
        'ids': ids,
        'csrf': Accounts.main.csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return const Success(null);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<SimpleRule>> danmakuFilterAdd({
    required String filter,
    required int type,
  }) async {
    var res = await Request().post(
      Api.danmakuFilterAdd,
      data: {
        'type': type,
        'filter': filter,
        'csrf': Accounts.main.csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return Success(SimpleRule.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }
}
