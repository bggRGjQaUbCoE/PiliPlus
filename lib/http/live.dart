import 'package:PiliPalaX/common/constants.dart';
import 'package:PiliPalaX/http/loading_state.dart';
import 'package:PiliPalaX/models/live/danmu_info.dart';
import 'package:dio/dio.dart';
import '../models/live/item.dart';
import '../models/live/room_info.dart';
import '../models/live/room_info_h5.dart';
import 'api.dart';
import 'init.dart';

class LiveHttp {
  static Future<LoadingState> liveList(
      {int? vmid, int? pn, int? ps, String? orderType}) async {
    var res = await Request().get(Api.liveList,
        data: {'page': pn, 'page_size': 30, 'platform': 'web'});
    if (res.data['code'] == 0) {
      List<LiveItemModel> list = res.data['data']['list']
          .map<LiveItemModel>((e) => LiveItemModel.fromJson(e))
          .toList();
      if (list.isNotEmpty) {
        return LoadingState.success(list);
      } else {
        return LoadingState.empty();
      }
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  static Future sendLiveMsg({
    roomId,
    msg,
  }) async {
    dynamic csrf = await Request.getCsrf();
    var res = await Request().post(
      Api.sendLiveMsg,
      data: {
        'bubble': 0,
        'msg': msg,
        'color': 16777215,
        'mode': 1,
        'room_type': 0,
        'jumpfrom': 71000,
        'reply_mid': 0,
        'reply_attr': 0,
        'replay_dmid': '',
        'statistics': Constants.statistics,
        'reply_type': 0,
        'reply_uname': '',
        'fontsize': 25,
        'rnd': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'roomid': roomId,
        'csrf': csrf,
        'csrf_token': csrf,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data'],
      };
    } else {
      return {
        'status': false,
        'msg': res.data['message'],
      };
    }
  }

  static Future liveRoomInfo({roomId, qn}) async {
    var res = await Request().get(Api.liveRoomInfo, data: {
      'room_id': roomId,
      'protocol': '0, 1',
      'format': '0, 1, 2',
      'codec': '0, 1',
      'qn': qn,
      'platform': 'web',
      'ptype': 8,
      'dolby': 5,
      'panorama': 1,
    });
    if (res.data['code'] == 0) {
      return {'status': true, 'data': RoomInfoModel.fromJson(res.data['data'])};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future liveRoomInfoH5({roomId, qn}) async {
    var res = await Request().get(Api.liveRoomInfoH5, data: {
      'room_id': roomId,
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': RoomInfoH5Model.fromJson(res.data['data'])
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future liveRoomDanmaPrefetch({roomId}) async {
    var res = await Request().get(Api.liveRoomDmPrefetch, data: {
      'roomid': roomId,
    });
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']['room']};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future liveRoomGetDanmakuToken({roomId}) async {
    var res = await Request().get(Api.liveRoomDmToken, data: {
      'id': roomId,
    });
    if (res.data['code'] == 0) {
      return {'status': true, 'data': LiveDanmakuInfo.fromJson(res.data)};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }
}
