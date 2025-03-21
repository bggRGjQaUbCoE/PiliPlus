import '../models/user/danmaku_block.dart';
import 'index.dart';

class DanmakuFilterHttp {
  static Future danmakuFilter() async {
    var res = await Request().get(Api.danmakuFilter);
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': DanmakuBlockDataModel.fromJson(res.data['data'])
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future danmakuFilterDel({required int ids}) async {
    var res = await Request().post(
      Api.danmakuFilterDel,
      queryParameters: {
        'ids': ids,
        'csrf': await Request.getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'msg': '操作成功',
      };
    } else {
      return {
        'status': false,
        'msg': res.data['message'],
      };
    }
  }

  static Future danmakuFilterAdd(
      {required String filter, required int type}) async {
    var res = await Request().post(
      Api.danmakuFilterAdd,
      queryParameters: {
        'type': type,
        'filter': filter,
        'csrf': await Request.getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': SimpleRule.fromJson(res.data['data']),
      };
    } else {
      return {
        'status': false,
        'msg': res.data['message'],
      };
    }
  }
}
