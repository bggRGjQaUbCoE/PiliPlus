import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models_new/msg/im_user_infos/datum.dart';
import 'package:PiliPlus/models_new/msg/msg_at/data.dart';
import 'package:PiliPlus/models_new/msg/msg_dnd/uid_setting.dart';
import 'package:PiliPlus/models_new/msg/msg_like/data.dart';
import 'package:PiliPlus/models_new/msg/msg_like_detail/data.dart';
import 'package:PiliPlus/models_new/msg/msg_reply/data.dart';
import 'package:PiliPlus/models_new/msg/msg_sys/data.dart';
import 'package:PiliPlus/models_new/msg/session_ss/data.dart';
import 'package:PiliPlus/models_new/msgfeed_unread/data.dart';
import 'package:PiliPlus/models_new/single_unread/data.dart';
import 'package:PiliPlus/models_new/upload_bfs/data.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/wbi_sign.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

class MsgHttp {
  static Future<LoadingState<MsgReplyData>> msgFeedReplyMe({
    int? cursor,
    int? cursorTime,
  }) async {
    var res = await Request().get(
      Api.msgFeedReply,
      queryParameters: {
        'id': ?cursor,
        'reply_time': ?cursorTime,
        'platform': 'web',
        'mobi_app': 'web',
        'build': 0,
        'web_location': 333.40164,
      },
    );
    if (res.data['code'] == 0) {
      return Success(MsgReplyData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<MsgAtData>> msgFeedAtMe({
    int? cursor,
    int? cursorTime,
  }) async {
    var res = await Request().get(
      Api.msgFeedAt,
      queryParameters: {
        'id': ?cursor,
        'at_time': ?cursorTime,
        'platform': 'web',
        'mobi_app': 'web',
        'build': 0,
        'web_location': 333.40164,
      },
    );
    if (res.data['code'] == 0) {
      return Success(MsgAtData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<MsgLikeData>> msgFeedLikeMe({
    int? cursor,
    int? cursorTime,
  }) async {
    var res = await Request().get(
      Api.msgFeedLike,
      queryParameters: {
        'id': ?cursor,
        'like_time': ?cursorTime,
        'platform': 'web',
        'mobi_app': 'web',
        'build': 0,
        'web_location': 333.40164,
      },
    );
    if (res.data['code'] == 0) {
      return Success(MsgLikeData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<MsgLikeDetailData>> msgLikeDetail({
    required Object cardId,
    required int pn,
  }) async {
    var res = await Request().get(
      Api.msgLikeDetail,
      queryParameters: {
        'card_id': cardId,
        'pn': pn,
        'last_view_at': 0,
        'platform': 'web',
        'build': 0,
        'mobi_app': 'web',
        'web_location': 333.40164,
      },
    );
    if (res.data['code'] == 0) {
      return Success(MsgLikeDetailData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<List<MsgSysItem>?>> msgFeedNotify({
    int? cursor,
    int pageSize = 20,
  }) async {
    var res = await Request().get(
      Api.msgSysNotify,
      queryParameters: {
        'cursor': ?cursor,
        'page_size': pageSize,
        'mobi_app': 'web',
        'build': 0,
        'web_location': 333.40164,
      },
    );
    if (res.data['code'] == 0) {
      return Success(
        (res.data['data'] as List?)
            ?.map((e) => MsgSysItem.fromJson(e))
            .toList(),
      );
    } else {
      return Error(res.data['message']);
    }
  }

  static Future msgSysUpdateCursor(int cursor) async {
    String csrf = Accounts.main.csrf;
    var res = await Request().get(
      Api.msgSysUpdateCursor,
      queryParameters: {
        'csrf': csrf,
        'cursor': cursor,
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
      };
    } else {
      return {
        'status': false,
        'msg': res.data['message'],
      };
    }
  }

  static Future uploadImage({
    required String path,
    required String bucket,
    required String dir,
  }) async {
    var res = await Request().post(
      Api.uploadImage,
      data: FormData.fromMap({
        'bucket': bucket,
        'file': await MultipartFile.fromFile(path),
        'dir': dir,
        'csrf': Accounts.main.csrf,
      }),
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

  static Future uploadBfs({
    required String path,
    String? category,
    String? biz,
    CancelToken? cancelToken,
  }) async {
    var res = await Request().post(
      Api.uploadBfs,
      data: FormData.fromMap({
        'file_up': await MultipartFile.fromFile(path),
        'category': ?category,
        'biz': ?biz,
        'csrf': Accounts.main.csrf,
      }),
      cancelToken: cancelToken,
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': UploadBfsResData.fromJson(res.data['data']),
      };
    } else {
      return {
        'status': false,
        'msg': res.data['message'],
      };
    }
  }

  static Future createTextDynamic(
    Object content,
  ) async {
    String csrf = Accounts.main.csrf;
    Map<String, dynamic> data = await WbiSign.makSign({
      'dynamic_id': 0,
      'type': 4,
      'rid': 0,
      'content': content,
      'csrf_token': csrf,
      'csrf': csrf,
    });
    var res = await Request().post(
      HttpString.tUrl + Api.createTextDynamic,
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {
        'status': false,
        'msg': res.data['message'],
      };
    }
  }

  static Future removeDynamic({
    required Object dynIdStr,
    Object? dynType,
    Object? ridStr,
  }) async {
    var res = await Request().post(
      Api.removeDynamic,
      queryParameters: {
        'platform': 'web',
        'csrf': Accounts.main.csrf,
      },
      data: {
        "dyn_id_str": dynIdStr,
        "dyn_type": ?dynType,
        "rid_str": ?ridStr,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future removeMsg(
    Object talkerId,
  ) async {
    String csrf = Accounts.main.csrf;
    Map<String, dynamic> data = await WbiSign.makSign({
      'talker_id': talkerId,
      'session_type': 1,
      'build': 0,
      'mobi_app': 'web',
      'csrf_token': csrf,
      'csrf': csrf,
    });
    var res = await Request().post(
      HttpString.tUrl + Api.removeMsg,
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future delMsgfeed(
    int tp,
    Object id,
  ) async {
    String csrf = Accounts.main.csrf;
    var res = await Request().post(
      Api.delMsgfeed,
      data: {
        'tp': tp,
        'id': id,
        'build': 0,
        'mobi_app': 'web',
        'csrf_token': csrf,
        'csrf': csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {
        'status': false,
        'msg': res.data['message'],
      };
    }
  }

  static Future delSysMsg(
    Object id,
  ) async {
    String csrf = Accounts.main.csrf;
    var res = await Request().post(
      HttpString.messageBaseUrl + Api.delSysMsg,
      queryParameters: {
        'mobi_app': 'android',
        'csrf': csrf,
      },
      data: {
        'csrf': csrf,
        'ids': [id],
        'station_ids': [],
        'type': 4,
        'mobi_app': 'android',
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {
        'status': false,
        'msg': res.data['message'],
      };
    }
  }

  static Future setTop({
    required Object talkerId,
    required int opType,
  }) async {
    String csrf = Accounts.main.csrf;
    Map<String, dynamic> data = await WbiSign.makSign({
      'talker_id': talkerId,
      'session_type': 1,
      'op_type': opType,
      'build': 0,
      'mobi_app': 'web',
      'csrf_token': csrf,
      'csrf': csrf,
    });
    var res = await Request().post(
      HttpString.tUrl + Api.setTop,
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {
        'status': false,
        'msg': res.data['message'],
      };
    }
  }

  // 消息标记已读
  static Future ackSessionMsg({
    required int talkerId,
    required int ackSeqno,
  }) async {
    String csrf = Accounts.main.csrf;
    final params = await WbiSign.makSign({
      'talker_id': talkerId,
      'session_type': 1,
      'ack_seqno': ackSeqno,
      'build': 0,
      'mobi_app': 'web',
      'csrf_token': csrf,
      'csrf': csrf,
    });
    var res = await Request().get(Api.ackSessionMsg, queryParameters: params);
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data'],
      };
    } else {
      return {
        'status': false,
        'msg':
            "message: ${res.data['message']},"
            " msg: ${res.data['msg']},"
            " code: ${res.data['code']}",
      };
    }
  }

  // 发送私信
  static Future sendMsg({
    required int senderUid,
    required int receiverId,
    int? msgType,
    required Object content,
  }) async {
    String csrf = Accounts.main.csrf;
    final devId = getDevId();
    final data = {
      'msg': {
        'sender_uid': senderUid,
        'receiver_id': receiverId,
        'receiver_type': 1,
        'msg_type': msgType ?? 1,
        'msg_status': 0,
        'dev_id': devId,
        'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'new_face_version': 1,
        'content': content,
      },
      'from_firework': 0,
      'build': 0,
      'mobi_app': 'web',
      'csrf_token': csrf,
      'csrf': csrf,
    };
    final params = await WbiSign.makSign(data);
    var res = await Request().post(
      Api.sendMsg,
      queryParameters: {
        'w_sender_uid': senderUid,
        'w_receiver_id': receiverId,
        'w_dev_id': devId,
        'w_rid': params['w_rid']!,
        'wts': params['wts']!,
      },
      data: data,
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
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static String getDevId() {
    return const Uuid().v4();
  }

  static Future msgSetNotice({
    required Object id,
    required int noticeState,
  }) async {
    final csrf = Accounts.main.csrf;
    var res = await Request().post(
      Api.msgSetNotice,
      data: {
        'mobi_app': 'web',
        'platform': 'web',
        'tp': 0,
        'id': id,
        'notice_state': noticeState,
        'build': 0,
        'csrf_token': csrf,
        'csrf': csrf,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future setMsgDnd({
    required Object uid,
    required int setting,
    required Object dndUid,
  }) async {
    final csrf = Accounts.main.csrf;
    var res = await Request().post(
      Api.setMsgDnd,
      data: {
        'uid': uid,
        'setting': setting,
        'dnd_uid': dndUid,
        'build': 0,
        'mobi_app': 'web',
        'csrf_token': csrf,
        'csrf': csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future setPushSs({
    required int setting,
    required talkerUid,
  }) async {
    final csrf = Accounts.main.csrf;
    var res = await Request().post(
      Api.setPushSs,
      data: {
        'setting': setting,
        'talker_uid': talkerUid,
        'build': 0,
        'mobi_app': 'web',
        'csrf_token': csrf,
        'csrf': csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<LoadingState<List<ImUserInfosData>?>> imUserInfos({
    required String uids,
  }) async {
    final csrf = Accounts.main.csrf;
    var res = await Request().get(
      Api.imUserInfos,
      queryParameters: {
        'uids': uids,
        'build': 0,
        'mobi_app': 'web',
        'csrf_token': csrf,
        'csrf': csrf,
      },
    );
    if (res.data['code'] == 0) {
      return Success(
        (res.data['data'] as List?)
            ?.map((e) => ImUserInfosData.fromJson(e))
            .toList(),
      );
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<SessionSsData>> getSessionSs({
    required Object talkerUid,
  }) async {
    final csrf = Accounts.main.csrf;
    var res = await Request().get(
      Api.getSessionSs,
      queryParameters: {
        'talker_uid': talkerUid,
        'build': 0,
        'mobi_app': 'web',
        'csrf_token': csrf,
        'csrf': csrf,
      },
    );
    if (res.data['code'] == 0) {
      return Success(SessionSsData.fromJson(res.data['data']));
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<List<UidSetting>?>> getMsgDnd({
    required Object uidsStr,
  }) async {
    final csrf = Accounts.main.csrf;
    var res = await Request().get(
      Api.getMsgDnd,
      queryParameters: {
        'own_uid': Accounts.main.mid,
        'uids_str': uidsStr,
        'build': 0,
        'mobi_app': 'web',
        'csrf_token': csrf,
        'csrf': csrf,
      },
    );
    if (res.data['code'] == 0) {
      return Success(
        (res.data['data']?['uid_settings'] as List?)
            ?.map((e) => UidSetting.fromJson(e))
            .toList(),
      );
    } else {
      return Error(res.data['message']);
    }
  }

  static Future msgUnread() async {
    var res = await Request().get(
      Api.msgUnread,
      queryParameters: {
        'build': 0,
        'mobi_app': 'web',
        'unread_type': 0,
        'web_location': 333.1365,
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': SingleUnreadData.fromJson(res.data['data']),
      };
    } else {
      return {'status': false, 'data': res.data['message']};
    }
  }

  static Future msgFeedUnread() async {
    var res = await Request().get(
      Api.msgFeedUnread,
      queryParameters: {
        'build': 0,
        'mobi_app': 'web',
        'web_location': 333.1365,
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': MsgFeedUnreadData.fromJson(res.data['data']),
      };
    } else {
      return {'status': false, 'data': res.data['message']};
    }
  }
}
