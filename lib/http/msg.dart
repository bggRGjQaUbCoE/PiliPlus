import 'dart:math';

import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/reply/reply_option_type.dart';
import 'package:PiliPlus/models/msg/account.dart';
import 'package:PiliPlus/models/msg/msgfeed_at_me.dart';
import 'package:PiliPlus/models/msg/msgfeed_like_me.dart';
import 'package:PiliPlus/models/msg/msgfeed_reply_me.dart';
import 'package:PiliPlus/models/msg/msgfeed_sys_msg.dart';
import 'package:PiliPlus/models/msg/session.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/wbi_sign.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class MsgHttp {
  static Future<LoadingState<MsgFeedReplyMe>> msgFeedReplyMe(
      {int cursor = -1, int cursorTime = -1}) async {
    var res = await Request().get(Api.msgFeedReply, queryParameters: {
      'id': cursor == -1 ? null : cursor,
      'reply_time': cursorTime == -1 ? null : cursorTime,
      'platform': 'android',
      'mobi_app': 'android',
      'build': '8350200',
    });
    if (res.data['code'] == 0) {
      MsgFeedReplyMe data = MsgFeedReplyMe.fromJson(res.data['data']);
      return Success(data);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<MsgFeedAtMe>> msgFeedAtMe(
      {int cursor = -1, int cursorTime = -1}) async {
    var res = await Request().get(Api.msgFeedAt, queryParameters: {
      'id': cursor == -1 ? null : cursor,
      'at_time': cursorTime == -1 ? null : cursorTime,
      'platform': 'android',
      'mobi_app': 'android',
      'build': '8350200',
    });
    if (res.data['code'] == 0) {
      MsgFeedAtMe data = MsgFeedAtMe.fromJson(res.data['data']);
      return Success(data);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<MsgFeedLikeMe>> msgFeedLikeMe(
      {int cursor = -1, int cursorTime = -1}) async {
    var res = await Request().get(Api.msgFeedLike, queryParameters: {
      'id': cursor == -1 ? null : cursor,
      'like_time': cursorTime == -1 ? null : cursorTime,
      'platform': 'android',
      'mobi_app': 'android',
      'build': '8350200',
    });
    if (res.data['code'] == 0) {
      MsgFeedLikeMe data = MsgFeedLikeMe.fromJson(res.data['data']);
      return Success(data);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future<LoadingState<List<SystemNotifyList>?>> msgFeedNotify(
      {int cursor = -1, int pageSize = 20}) async {
    var res = await Request().get(Api.msgSysNotify, queryParameters: {
      'cursor': cursor == -1 ? null : cursor,
      'page_size': pageSize,
    });
    if (res.data['code'] == 0) {
      List<SystemNotifyList>? list = (res.data['data'] as List?)
          ?.map((e) => SystemNotifyList.fromJson(e))
          .toList();
      return Success(list);
    } else {
      return Error(res.data['message']);
    }
  }

  static Future msgSysUpdateCursor(int cursor) async {
    String csrf = Accounts.main.csrf;
    var res = await Request().get(Api.msgSysUpdateCursor, queryParameters: {
      'csrf': csrf,
      'cursor': cursor,
    });
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

  static Future createDynamic({
    dynamic mid,
    dynamic dynIdStr, // repost dyn
    dynamic rid, // repost video
    dynamic dynType,
    dynamic rawText,
    List? pics,
    int? publishTime,
    ReplyOptionType? replyOption,
    int? privatePub,
  }) async {
    String csrf = Accounts.main.csrf;
    var res = await Request().post(
      Api.createDynamic,
      queryParameters: {
        'platform': 'web',
        'csrf': csrf,
        'x-bili-device-req-json': {"platform": "web", "device": "pc"},
        'x-bili-web-req-json': {"spm_id": "333.999"},
      },
      data: {
        "dyn_req": {
          "content": {
            "contents": [
              {
                "raw_text": rawText,
                "type": 1,
                "biz_id": "",
              }
            ]
          },
          if (privatePub != null || replyOption != null || publishTime != null)
            "option": {
              if (privatePub != null) 'private_pub': privatePub,
              if (publishTime != null) "timer_pub_time": publishTime,
              if (replyOption == ReplyOptionType.close)
                "close_comment": 1
              else if (replyOption == ReplyOptionType.choose)
                "up_choose_comment": 1,
            },
          "scene": rid != null
              ? 5
              : dynIdStr != null
                  ? 4
                  : pics != null
                      ? 2
                      : 1,
          if (pics != null) 'pics': pics,
          "attach_card": null,
          "upload_id":
              "${rid != null ? 0 : mid}_${DateTime.now().millisecondsSinceEpoch ~/ 1000}_${Random().nextInt(9000) + 1000}",
          "meta": {
            "app_meta": {"from": "create.dynamic.web", "mobi_app": "web"}
          }
        },
        if (dynIdStr != null || rid != null)
          "web_repost_src": {
            if (dynIdStr != null) "dyn_id_str": dynIdStr,
            if (rid != null)
              "revs_id": {
                "dyn_type": dynType,
                "rid": rid,
              }
          }
      },
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

  static Future uploadImage({
    required dynamic path,
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
    dynamic path,
    String? category,
    String? biz,
    CancelToken? cancelToken,
  }) async {
    final file = await MultipartFile.fromFile(path);
    Map<String, dynamic> data = {
      'file_up': file,
      if (category != null) 'category': category,
      if (biz != null) 'biz': biz,
      'csrf': Accounts.main.csrf,
    };
    var res = await Request().post(
      Api.uploadBfs,
      data: FormData.fromMap(data),
      cancelToken: cancelToken,
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data']..['img_size'] = file.length,
      };
    } else {
      return {
        'status': false,
        'msg': res.data['message'],
      };
    }
  }

  static Future createTextDynamic(
    dynamic content,
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
      data: FormData.fromMap(data),
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

  static Future removeDynamic({required dynIdStr, dynType, ridStr}) async {
    var res = await Request().post(
      Api.removeDynamic,
      queryParameters: {
        'platform': 'web',
        'csrf': Accounts.main.csrf,
      },
      data: {
        "dyn_id_str": dynIdStr,
        if (dynType != null) "dyn_type": dynType,
        if (ridStr != null) "rid_str": ridStr,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future removeMsg(
    dynamic talkerId,
  ) async {
    String csrf = Accounts.main.csrf;
    Map<String, dynamic> data = await WbiSign.makSign({
      'talker_id': talkerId,
      'session_type': 1,
      'build': 0,
      'mobi_app': 'web',
      'csrf_token': csrf,
      'csrf': csrf
    });
    var res = await Request().post(
      HttpString.tUrl + Api.removeMsg,
      data: FormData.fromMap(data),
    );
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future delMsgfeed(
    int tp,
    dynamic id,
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
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
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
    dynamic id,
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
    required dynamic talkerId,
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
      'csrf': csrf
    });
    var res = await Request()
        .post(HttpString.tUrl + Api.setTop, data: FormData.fromMap(data));
    if (res.data['code'] == 0) {
      return {'status': true};
    } else {
      return {
        'status': false,
        'msg': res.data['message'],
      };
    }
  }

  // 会话列表
  static Future<LoadingState<List<SessionList>?>> sessionList(
      {int? endTs}) async {
    final params = await WbiSign.makSign({
      'session_type': 1,
      'group_fold': 1,
      'unfollow_fold': 0,
      'sort_rule': 2,
      'build': 0,
      'mobi_app': 'web',
      if (endTs != null) 'end_ts': endTs,
    });
    var res = await Request().get(Api.sessionList, queryParameters: params);
    if (res.data['code'] == 0) {
      try {
        return Success(
          SessionDataModel.fromJson(res.data['data']).sessionList,
        );
      } catch (err) {
        return Error(err.toString());
      }
    } else {
      return Error(res.data['message']);
    }
  }

  static Future accountList(uids) async {
    var res = await Request().get(Api.sessionAccountList, queryParameters: {
      'uids': uids,
      'build': 0,
      'mobi_app': 'web',
    });
    if (res.data['code'] == 0) {
      try {
        return {
          'status': true,
          'data': res.data['data']
              .map<AccountListModel>((e) => AccountListModel.fromJson(e))
              .toList(),
        };
      } catch (err) {
        debugPrint('err🔟: $err');
      }
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<LoadingState<SessionMsgDataModel>> sessionMsg({
    int? talkerId,
    beginSeqno,
    endSeqno,
  }) async {
    final params = await WbiSign.makSign({
      'talker_id': talkerId,
      'session_type': 1,
      'size': 20,
      'sender_device_id': 1,
      'build': 0,
      'mobi_app': 'web',
      if (beginSeqno != null) 'begin_seqno': beginSeqno,
      if (endSeqno != null) 'end_seqno': endSeqno,
    });
    var res = await Request().get(Api.sessionMsg, queryParameters: params);
    if (res.data['code'] == 0) {
      try {
        return Success(SessionMsgDataModel.fromJson(res.data['data']));
      } catch (err) {
        return Error(err.toString());
      }
    } else {
      return Error(res.data['message']);
    }
  }

  // 消息标记已读
  static Future ackSessionMsg({
    int? talkerId,
    int? ackSeqno,
  }) async {
    String csrf = Accounts.main.csrf;
    final params = await WbiSign.makSign({
      'talker_id': talkerId,
      'session_type': 1,
      'ack_seqno': ackSeqno,
      'build': 0,
      'mobi_app': 'web',
      'csrf_token': csrf,
      'csrf': csrf
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
        'msg': "message: ${res.data['message']},"
            " msg: ${res.data['msg']},"
            " code: ${res.data['code']}",
      };
    }
  }

  // 发送私信
  static Future sendMsg({
    int? senderUid,
    int? receiverId,
    int? msgType,
    dynamic content,
  }) async {
    String csrf = Accounts.main.csrf;
    final devId = getDevId();
    Map<String, dynamic> base = {
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
    Map<String, dynamic> params = await WbiSign.makSign(base);
    var res = await Request().post(
      Api.sendMsg,
      queryParameters: <String, dynamic>{
        'w_sender_uid': senderUid,
        'w_receiver_id': receiverId,
        'w_dev_id': devId,
        'w_rid': params['w_rid'],
        'wts': params['wts'],
      },
      data: base,
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
    required dynamic id,
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
}
