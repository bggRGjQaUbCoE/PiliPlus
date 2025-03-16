import 'dart:convert';
import 'dart:typed_data';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/grpc/app/dynamic/v1/dynamic.pb.dart';
import 'package:PiliPlus/grpc/app/dynamic/v2/dynamic.pb.dart';
import 'package:PiliPlus/grpc/app/main/community/reply/v1/reply.pb.dart';
import 'package:PiliPlus/grpc/app/playeronline/v1/playeronline.pb.dart';
import 'package:PiliPlus/grpc/app/show/popular/v1/popular.pb.dart';
import 'package:PiliPlus/grpc/device/device.pb.dart';
import 'package:PiliPlus/grpc/dm/v1/dm.pb.dart';
import 'package:PiliPlus/grpc/fawkes/fawkes.pb.dart';
import 'package:PiliPlus/grpc/locale/locale.pb.dart';
import 'package:PiliPlus/grpc/metadata/metadata.pb.dart';
import 'package:PiliPlus/grpc/network/network.pb.dart' as network;
import 'package:PiliPlus/grpc/restriction/restriction.pb.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/utils/login.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:fixnum/src/int64.dart';
import 'package:protobuf/protobuf.dart' show GeneratedMessage;

class GrpcUrl {
  static const playerOnline =
      '/bilibili.app.playeronline.v1.PlayerOnline/PlayerOnline';
  static const popular = '/bilibili.app.show.v1.Popular/Index';
  static const dialogList =
      '/bilibili.main.community.reply.v1.Reply/DialogList';
  static const detailList =
      '/bilibili.main.community.reply.v1.Reply/DetailList';
  static const replyInfo = '/bilibili.main.community.reply.v1.Reply/ReplyInfo';
  static const mainList = '/bilibili.main.community.reply.v1.Reply/MainList';
  static const dynSpace = '/bilibili.app.dynamic.v2.Dynamic/DynSpace';
  static const dynRed = '/bilibili.app.dynamic.v1.Dynamic/DynRed';
  static const dmSegMobile = '/bilibili.community.service.dm.v1.DM/DmSegMobile';
}

class GrpcRepo {
  static const gzipEncoder = GZipEncoder();
  static const gzipDecoder = GZipDecoder();

  static final String? _accessKey = Accounts.main.accessKey;
  static const _build = 1462100;
  static const _biliChannel = 'bili';
  static const _mobiApp = 'android_hd';
  static const _phone = 'phone';

  static final _buvid = LoginUtils.buvid;
  static final _traceId = Utils.genTraceId();
  static final _sessionId = Utils.generateRandomString(8);

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

  static final unprintableRegExp = RegExp(r"[^\u4e00-\u9fa5，。；！？UP]");

  static Uint8List compressProtobuf(Uint8List proto) {
    proto = gzipEncoder.encodeBytes(proto, level: 0);
    var byteLength = ByteData(4);
    byteLength.setInt32(0, proto.length, Endian.big);
    var compressed = Uint8List(5 + proto.length);
    compressed[0] = 1;
    compressed.setRange(1, 5, byteLength.buffer.asUint8List());
    compressed.setAll(5, proto);
    return compressed;
  }

  static Uint8List decompressProtobuf(Uint8List data) {
    var length = ByteData.sublistView(data, 1, 5).getInt32(0, Endian.big);

    if (data[0] == 1) {
      return gzipDecoder.decodeBytes(data.sublist(5, length + 5));
    } else {
      return data.sublist(5, length + 5);
    }
  }

  static Future<Map<String, dynamic>> _request(
      url, GeneratedMessage request, Function grpcParser,
      {Function? onSuccess}) async {
    final response = await Request().post(HttpString.appBaseUrl + url,
        data: compressProtobuf(request.writeToBuffer()),
        options: Options(headers: headers, responseType: ResponseType.bytes));

    if (response.data is Map) {
      return {'status': false, 'msg': response.data['message']};
    }

    if (response.headers.value('Grpc-Status') == '0') {
      try {
        Uint8List data = response.data;
        data = decompressProtobuf(data);
        final grpcResponse = grpcParser(data);
        return {
          'status': true,
          'data': onSuccess == null ? grpcResponse : onSuccess(grpcResponse),
        };
      } catch (e) {
        return {'status': false, 'msg': e.toString()};
      }
    } else {
      try {
        String msg = response.headers.value('Grpc-Status-Details-Bin') ?? '';
        if (msg != '') {
          while (msg.length % 4 != 0) {
            msg += '=';
          }
          msg = utf8
              .decode(base64Decode(msg), allowMalformed: true)
              .replaceAll(unprintableRegExp, '');
        }
        return {'status': false, 'msg': msg};
      } catch (e) {
        return {'status': false, 'msg': e.toString()};
      }
    }
  }

  static Future playerOnline({
    int aid = 0,
    int cid = 0,
  }) async {
    return await _request(
        GrpcUrl.playerOnline,
        PlayerOnlineReq(aid: Int64(aid), cid: Int64(cid), playOpen: true),
        PlayerOnlineReply.fromBuffer,
        onSuccess: (response) => response.totalNumberText);
  }

  static Future popular(int idx) async {
    return await _request(GrpcUrl.popular, PopularResultReq(idx: Int64(idx)),
        PopularReply.fromBuffer, onSuccess: (response) {
      response.items.retainWhere((item) => item.smallCoverV5.base.goto == 'av');
      return {'status': true, 'data': response.items};
    });
  }

  static Future dialogList({
    int type = 1,
    required int oid,
    required int root,
    required int rpid,
    required CursorReq cursor,
    DetailListScene scene = DetailListScene.REPLY,
  }) async {
    return await _request(
        GrpcUrl.dialogList,
        DialogListReq(
            oid: Int64(oid),
            type: Int64(type),
            root: Int64(root),
            rpid: Int64(rpid),
            cursor: cursor),
        DialogListReply.fromBuffer);
  }

  static Future detailList({
    int type = 1,
    required int oid,
    required int root,
    required int rpid,
    required CursorReq cursor,
    DetailListScene scene = DetailListScene.REPLY,
  }) async {
    return await _request(
        GrpcUrl.detailList,
        DetailListReq(
            oid: Int64(oid),
            type: Int64(type),
            root: Int64(root),
            rpid: Int64(rpid),
            cursor: cursor,
            scene: scene),
        DetailListReply.fromBuffer);
  }

  static Future replyInfo({required int rpid}) async {
    return await _request(GrpcUrl.replyInfo, ReplyInfoReq(rpid: Int64(rpid)),
        ReplyInfoReply.fromBuffer,
        onSuccess: (response) => response.reply);
  }

  static Future mainList({
    int type = 1,
    required int oid,
    required CursorReq cursor,
  }) async {
    return await _request(
        GrpcUrl.mainList,
        MainListReq(
            oid: Int64(oid), type: Int64(type), rpid: Int64(0), cursor: cursor),
        MainListReply.fromBuffer);
  }

  static Future dynSpace({
    required int uid,
    required int page,
  }) async {
    return await _request(
        GrpcUrl.dynSpace,
        DynSpaceReq(
            hostUid: Int64(uid),
            localTime: 8,
            page: Int64(page),
            from: 'space'),
        DynSpaceRsp.fromBuffer);
  }

  static Future dynRed() async {
    return await _request(GrpcUrl.dynRed,
        DynRedReq(tabOffset: [TabOffset(tab: 1)]), DynRedReply.fromBuffer,
        onSuccess: (response) => response.dynRedItem.count.toInt());
  }

  static Future dmSegMobile(
      {required int cid, required int segmentIndex, int type = 1}) async {
    return await _request(
        GrpcUrl.dmSegMobile,
        DmSegMobileReq(
            oid: Int64(cid), segmentIndex: Int64(segmentIndex), type: type),
        DmSegMobileReply.fromBuffer);
  }
}
