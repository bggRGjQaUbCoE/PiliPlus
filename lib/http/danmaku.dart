import 'package:PiliPlus/grpc/bilibili/community/service/dm/v1.pb.dart';
import 'package:PiliPlus/grpc/grpc_repo.dart';
import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:dio/dio.dart';

class DanmakuHttp {
  // 获取视频弹幕
  static Future<LoadingState<DmSegMobileReply>> queryDanmaku({
    required int cid,
    required int segmentIndex,
    int queryCount = 1,
  }) async {
    // 构建参数对象
    final response =
        await GrpcRepo.dmSegMobile(cid: cid, segmentIndex: segmentIndex);
    if (!response['status']) {
      if (queryCount >= 3) {
        return const Error('');
      } else {
        await Future.delayed(const Duration(seconds: 1));
        return await queryDanmaku(
          cid: cid,
          segmentIndex: segmentIndex,
          queryCount: ++queryCount,
        );
      }
    }
    DmSegMobileReply data = response['data'];
    return LoadingState.success(data);
  }

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
    bool? colorful, //60001：专属渐变彩色（需要会员）
    int? checkboxType, //是否带 UP 身份标识（0：普通；4：带有标识）
    // String? csrf,//CSRF Token（位于 Cookie）	Cookie 方式必要
    // String? access_key,//	APP 登录 Token		APP 方式必要
  }) async {
    // 构建参数对象
    // assert(aid != null || bvid != null);
    // assert(csrf != null || access_key != null);
    // 构建参数对象
    var params = <String, dynamic>{
      'type': type,
      'oid': oid,
      'msg': msg,
      'mode': mode,
      //'aid': aid,
      'bvid': bvid,
      'progress': progress,
      'color': colorful == true ? null : color,
      'fontsize': fontsize,
      'pool': pool,
      'rnd': DateTime.now().microsecondsSinceEpoch,
      'colorful': colorful == true ? 60001 : null,
      'checkbox_type': checkboxType,
      'csrf': Accounts.main.csrf,
      // 'access_key': access_key,
    }..removeWhere((key, value) => value == null);

    var response = await Request().post(
      Api.shootDanmaku,
      data: params,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
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
}
