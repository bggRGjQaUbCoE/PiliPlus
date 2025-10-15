import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:dio/dio.dart';

abstract final class DanmakuHttp {
  static Future shootDanmaku({
    int type = 1, //弹幕类选择(1：视频弹幕 2：漫画弹幕)
    required int oid, // 视频cid
    required String msg, //弹幕文本(长度小于 100 字符)
    // 弹幕类型(1：滚动弹幕 4：底端弹幕 5：顶端弹幕 6：逆向弹幕(不能使用） 7：高级弹幕 8：代码弹幕（不能使用） 9：BAS弹幕（pool必须为2）)
    int mode = 1,
    // String? aid,// 稿件avid
    // String? bvid,// bvid与aid必须有一个
    required String bvid,
    int? progress, // 弹幕出现在视频内的时间（单位为毫秒，默认为0）
    int? color, // 弹幕颜色(默认白色，16777215）
    int? fontsize, // 弹幕字号（默认25）
    int? pool, // 弹幕池选择（0：普通池 1：字幕池 2：特殊池（代码/BAS弹幕）默认普通池，0）
    //int? rnd,// 当前时间戳*1000000（若无此项，则发送弹幕冷却时间限制为90s；若有此项，则发送弹幕冷却时间限制为5s）
    bool colorful = false, //60001：专属渐变彩色（需要会员）
    int? checkboxType, //是否带 UP 身份标识（0：普通；4：带有标识）
    // String? csrf,//CSRF Token（位于 Cookie）	Cookie 方式必要
    // String? access_key,//	APP 登录 Token		APP 方式必要
  }) async {
    // 构建参数对象
    // assert(aid != null || bvid != null);
    // assert(csrf != null || access_key != null);
    // 构建参数对象
    var data = <String, Object>{
      'type': type,
      'oid': oid,
      'msg': msg,
      'mode': mode,
      //'aid': aid,
      'bvid': bvid,
      'progress': ?progress,
      'color': ?colorful ? 16777215 : color,
      'fontsize': ?fontsize,
      'pool': ?pool,
      'rnd': DateTime.now().microsecondsSinceEpoch,
      'colorful': ?colorful ? 60001 : null,
      'checkbox_type': ?checkboxType,
      'csrf': Accounts.main.csrf,
      // 'access_key': access_key,
    };

    var response = await Request().post(
      Api.shootDanmaku,
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (response.statusCode != 200) {
      return {
        'status': false,
        'msg': '弹幕发送失败，状态码:${response.statusCode}',
      };
    }
    if (response.data['code'] == 0) {
      return {
        'status': true,
        'data': response.data['data'],
      };
    } else {
      return {
        'status': false,
        'msg': "${response.data['code']}: ${response.data['message']}",
      };
    }
  }

  static Future<LoadingState<Null>> danmakuLike({
    required bool isLike,
    required int cid,
    required int id,
  }) async {
    final data = {
      'op': isLike ? 1 : 2,
      'dmid': id,
      'oid': cid,
      'platform': 'web_player',
      'polaris_app_id': 100,
      'polaris_platform': 5,
      'spmid': '333.788.0.0',
      'from_spmid': '333.788.0.0',
      'statistics': '{"appId":100,"platform":5,"abtest":"","version":""}',
      'csrf': Accounts.main.csrf,
    };
    final res = await Request().post(
      Api.danmakuLike,
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return const Success(null);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<Map<String, dynamic>> danmakuReport({
    required int reason,
    required int cid,
    required int id,
    bool block = false,
    String? content,
  }) async {
    final data = {
      'cid': cid,
      'dmid': id,
      'reason': reason,
      'block': block,
      'originCid': cid,
      'content': ?content,
      'polaris_app_id': 100,
      'polaris_platform': 5,
      'spmid': '333.788.0.0',
      'from_spmid': '333.788.0.0',
      'statistics': '{"appId":100,"platform":5,"abtest":"","version":""}',
      'csrf': Accounts.main.csrf,
    };
    final res = await Request().post(
      Api.danmakuReport,
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    return res.data as Map<String, dynamic>;

    /// res.data['data']['block']
    /// {
    ///       0: "举报已提交",
    ///       "-1": "举报失败，请先激活账号。",
    ///       "-2": "举报失败，系统拒绝受理您的举报请求。",
    ///       "-3": "举报失败，您已经被禁言。",
    ///       "-4": "您的操作过于频繁，请稍后再试。",
    ///       "-5": "您已经举报过这条弹幕了。",
    ///       "-6": "举报失败，系统错误。"
    /// }
  }

  static Future<LoadingState<String?>> danmakuRecall({
    required int cid,
    required int id,
  }) async {
    final data = {
      'dmid': id,
      'cid': cid,
      'type': 1,
      'csrf': Accounts.main.csrf,
    };
    final res = await Request().post(
      Api.danmakuRecall,
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return Success(res.data['message']);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<String?>> danmakuEditState({
    required int oid,
    required Iterable<int> ids,
    required int state,
  }) async {
    /// 0: 取消删除
    /// 1：删除弹幕
    /// 2：弹幕保护
    /// 3：取消保护
    final data = {
      'dmids': ids.join(','),
      'oid': oid,
      'state': state,
      'type': 1,
      'csrf': Accounts.main.csrf,
    };
    final res = await Request().post(
      Api.danmakuRecall,
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return Success(res.data['message']);
    } else {
      return Error(res.data['message']);
    }
  }
}
