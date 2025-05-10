import 'dart:convert';
import 'dart:typed_data';

import 'package:PiliPlus/build_config.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/grpc/bilibili/metadata.pb.dart';
import 'package:PiliPlus/grpc/bilibili/metadata/device.pb.dart';
import 'package:PiliPlus/grpc/bilibili/metadata/fawkes.pb.dart';
import 'package:PiliPlus/grpc/bilibili/metadata/locale.pb.dart';
import 'package:PiliPlus/grpc/bilibili/metadata/network.pb.dart' as network;
import 'package:PiliPlus/grpc/bilibili/metadata/restriction.pb.dart';
import 'package:PiliPlus/grpc/google/rpc/status.pb.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' show GeneratedMessage;

class GrpcUrl {
  // static const playerOnline =
  //     '/bilibili.app.playeronline.v1.PlayerOnline/PlayerOnline';
  // static const popular = '/bilibili.app.show.v1.Popular/Index';

  // dynamic
  static const dynV1 = '/bilibili.app.dynamic.v1.Dynamic';
  static const dynV2 = '/bilibili.app.dynamic.v2.Dynamic';
  static const opusV2 = '/bilibili.app.dynamic.v2.Opus';
  static const dynRed = '$dynV1/DynRed';
  static const opusSpaceFlow = '$opusV2/OpusSpaceFlow';
  // static const dynSpace = '$dynV2/DynSpace';

  // danmaku
  static const dmSegMobile = '/bilibili.community.service.dm.v1.DM/DmSegMobile';

  // reply
  static const reply = '/bilibili.main.community.reply.v1.Reply';
  static const mainList = '$reply/MainList';
  static const detailList = '$reply/DetailList';
  static const dialogList = '$reply/DialogList';
  // static const replyInfo = '$reply/ReplyInfo';

  // im
  static const im = '/bilibili.im.interface.v1.ImInterface';
  static const im2 = '/bilibili.app.im.v1.im';
  static const sendMsg = '$im/SendMsg';
  static const shareList = '$im/ShareList';
  static const sessionMain = '$im2/SessionMain';
  static const sessionSecondary = '$im2/SessionSecondary';
  static const clearUnread = '$im2/ClearUnread';
  static const sessionUpdate = '$im2/SessionUpdate';
  static const pinSession = '$im2/PinSession';
  static const unpinSession = '$im2/UnpinSession';
  static const deleteSessionList = '$im2/DeleteSessionList';
  static const getImSettings = '$im2/GetImSettings';
  static const setImSettings = '$im2/SetImSettings';
  static const keywordBlockingList = '$im2/KeywordBlockingList';
  static const keywordBlockingAdd = '$im2/KeywordBlockingAdd';
  static const keywordBlockingDelete = '$im2/KeywordBlockingDelete';
  static const syncFetchSessionMsgs = '$im/SyncFetchSessionMsgs';
  static const getTotalUnread = '$im/GetTotalUnread';
}

class GrpcRepo {
  static String? _accessKey = Accounts.main.accessKey;
  static const _build = 2001100;
  static const _biliChannel = 'bili';
  static const _mobiApp = 'android_hd';
  static const _phone = 'phone';

  static final _buvid = LoginUtils.buvid;
  static final _traceId = Utils.genTraceId();
  static final _sessionId = Utils.generateRandomString(8);

  static void updateHeaders(String? accessKey) {
    _accessKey = accessKey;
    if (_accessKey != null) {
      headers['authorization'] = 'identify_v1 $_accessKey';
    } else {
      headers.remove('authorization');
    }
    headers['x-bili-metadata-bin'] = base64Encode(Metadata(
      accessKey: _accessKey ?? '',
      mobiApp: _mobiApp,
      device: _phone,
      build: _build,
      channel: _biliChannel,
      buvid: _buvid,
      platform: _mobiApp,
    ).writeToBuffer());
  }

  static final Map<String, String> headers = {
    Headers.contentTypeHeader: 'application/grpc',
    'grpc-encoding': 'gzip',
    'gzip-accept-encoding': 'gzip,identity',
    'user-agent': '${Constants.userAgent} grpc-java-cronet/1.36.1',
    'x-bili-gaia-vtoken': '',
    'x-bili-aurora-zone': '',
    'x-bili-trace-id': _traceId,
    if (_accessKey != null) 'authorization': 'identify_v1 $_accessKey',
    'buvid': _buvid,
    'bili-http-engine': 'cronet',
    'te': 'trailers',
    'x-bili-fawkes-req-bin': base64Encode(
        FawkesReq(appkey: _mobiApp, env: 'prod', sessionId: _sessionId)
            .writeToBuffer()),
    'x-bili-metadata-bin': base64Encode(Metadata(
      accessKey: _accessKey ?? '',
      mobiApp: _mobiApp,
      device: _phone,
      build: _build,
      channel: _biliChannel,
      buvid: _buvid,
      platform: _mobiApp,
    ).writeToBuffer()),
    'x-bili-device-bin': base64Encode(Device(
            appId: 1,
            build: _build,
            buvid: _buvid,
            mobiApp: _mobiApp,
            platform: _mobiApp,
            device: _phone,
            channel: _biliChannel,
            brand: _phone,
            model: _phone,
            osver: '14',
            fpLocal: '',
            fpRemote: '',
            versionName: _build.toString(),
            fp: '',
            fts: Int64())
        .writeToBuffer()),
    'x-bili-network-bin': base64Encode(network.Network(
            type: network.NetworkType.WIFI,
            tf: network.TFType.TF_UNKNOWN,
            oid: '')
        .writeToBuffer()),
    'x-bili-restriction-bin': base64Encode(Restriction(
            teenagersMode: false,
            lessonsMode: false,
            mode: ModeType.NORMAL,
            review: false,
            disableRcmd: false,
            basicMode: false)
        .writeToBuffer()),
    'x-bili-locale-bin': base64Encode(Locale(
            cLocale: LocaleIds(language: 'zh', region: 'CN'),
            sLocale: LocaleIds(language: 'zh', region: 'CN'),
            simCode: '',
            timezone: 'Asia/Shanghai')
        .writeToBuffer()),
    'x-bili-exps-bin': '',
  };

  static final _unprintableRegExp = RegExp(r"[^\u4e00-\u9fa5，。；！？UP]");

  static Uint8List compressProtobuf(Uint8List proto) {
    proto = const GZipEncoder().encodeBytes(proto);
    var byteLength = ByteData(4)..setInt32(0, proto.length, Endian.big);
    return Uint8List(5 + proto.length)
      ..[0] = 1
      ..setRange(1, 5, byteLength.buffer.asUint8List())
      ..setAll(5, proto);
  }

  static Uint8List decompressProtobuf(Uint8List data) {
    var length = ByteData.sublistView(data, 1, 5).getInt32(0, Endian.big);

    if (data[0] == 1) {
      return const GZipDecoder().decodeBytes(data.sublist(5, length + 5));
    } else {
      return data.sublist(5, length + 5);
    }
  }

  static Future<LoadingState<T>> request<T>(String url,
      GeneratedMessage request, T Function(Uint8List) grpcParser) async {
    final response = await Request().post(HttpString.appBaseUrl + url,
        data: compressProtobuf(request.writeToBuffer()),
        options: Options(headers: headers, responseType: ResponseType.bytes));

    if (response.data is Map) {
      return Error(response.data['message']);
    }

    if (response.headers.value('Grpc-Status') == '0') {
      try {
        Uint8List data = response.data;
        data = decompressProtobuf(data);
        final grpcResponse = grpcParser(data);
        return Success(grpcResponse);
      } catch (e) {
        return Error(e.toString());
      }
    } else {
      try {
        String msg = response.headers.value('Grpc-Status-Details-Bin') ?? '';
        if (msg.isNotEmpty) {
          while (msg.length % 4 != 0) {
            msg += '=';
          }
          final msgBytes = base64Decode(msg);
          try {
            final grpcMsg = Status.fromBuffer(msgBytes);
            // UNKNOWN : -400 : msg
            final errMsg =
                grpcMsg.details.map((e) => e.status.message).join('\n');
            msg = BuildConfig.isDebug
                ? 'CODE: ${grpcMsg.code}(${grpcMsg.message})\nMSG: $errMsg'
                : errMsg;
          } catch (e) {
            msg = utf8
                .decode(msgBytes, allowMalformed: true)
                .replaceAll(_unprintableRegExp, '');
          }
        }
        return Error(msg);
      } catch (e) {
        return Error(e.toString());
      }
    }
  }

  // static Future playerOnline({
  //   int aid = 0,
  //   int cid = 0,
  // }) {
  //   return _request(
  //       GrpcUrl.playerOnline,
  //       PlayerOnlineReq(aid: Int64(aid), cid: Int64(cid), playOpen: true),
  //       PlayerOnlineReply.fromBuffer,
  //       onSuccess: (response) => response.totalNumberText);
  // }

  // static Future popular(int idx) {
  //   return _request(GrpcUrl.popular, PopularResultReq(idx: Int64(idx)),
  //       PopularReply.fromBuffer, onSuccess: (response) {
  //     response.items.retainWhere((item) => item.smallCoverV5.base.goto == 'av');
  //     return {'status': true, 'data': response.items};
  //   });
  // }
}
