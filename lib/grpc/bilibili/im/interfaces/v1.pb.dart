// This is a generated file - do not edit.
//
// Generated from bilibili/im/interfaces/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../type.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class EmotionInfo extends $pb.GeneratedMessage {
  factory EmotionInfo({
    $core.String? text,
    $core.String? url,
    $core.int? size,
    $core.String? gifUrl,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (url != null) result.url = url;
    if (size != null) result.size = size;
    if (gifUrl != null) result.gifUrl = gifUrl;
    return result;
  }

  EmotionInfo._();

  factory EmotionInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmotionInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmotionInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.im.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..aI(3, _omitFieldNames ? '' : 'size')
    ..aOS(4, _omitFieldNames ? '' : 'gifUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmotionInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmotionInfo copyWith(void Function(EmotionInfo) updates) =>
      super.copyWith((message) => updates(message as EmotionInfo))
          as EmotionInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmotionInfo create() => EmotionInfo._();
  @$core.override
  EmotionInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmotionInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmotionInfo>(create);
  static EmotionInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get size => $_getIZ(2);
  @$pb.TagNumber(3)
  set size($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get gifUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set gifUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasGifUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearGifUrl() => $_clearField(4);
}

class MsgFeedUnreadRsp extends $pb.GeneratedMessage {
  factory MsgFeedUnreadRsp({
    $core.Iterable<$core.MapEntry<$core.String, $fixnum.Int64>>? unread,
  }) {
    final result = create();
    if (unread != null) result.unread.addEntries(unread);
    return result;
  }

  MsgFeedUnreadRsp._();

  factory MsgFeedUnreadRsp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MsgFeedUnreadRsp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MsgFeedUnreadRsp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.im.interfaces.v1'),
      createEmptyInstance: create)
    ..m<$core.String, $fixnum.Int64>(1, _omitFieldNames ? '' : 'unread',
        entryClassName: 'MsgFeedUnreadRsp.UnreadEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O6,
        packageName: const $pb.PackageName('bilibili.im.interfaces.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MsgFeedUnreadRsp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MsgFeedUnreadRsp copyWith(void Function(MsgFeedUnreadRsp) updates) =>
      super.copyWith((message) => updates(message as MsgFeedUnreadRsp))
          as MsgFeedUnreadRsp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MsgFeedUnreadRsp create() => MsgFeedUnreadRsp._();
  @$core.override
  MsgFeedUnreadRsp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MsgFeedUnreadRsp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MsgFeedUnreadRsp>(create);
  static MsgFeedUnreadRsp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, $fixnum.Int64> get unread => $_getMap(0);
}

class ReqSendMsg extends $pb.GeneratedMessage {
  factory ReqSendMsg({
    $1.Msg? msg,
    $core.String? cookie,
    $core.String? cookie2,
    $core.int? errorCode,
    $core.String? devId,
  }) {
    final result = create();
    if (msg != null) result.msg = msg;
    if (cookie != null) result.cookie = cookie;
    if (cookie2 != null) result.cookie2 = cookie2;
    if (errorCode != null) result.errorCode = errorCode;
    if (devId != null) result.devId = devId;
    return result;
  }

  ReqSendMsg._();

  factory ReqSendMsg.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReqSendMsg.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReqSendMsg',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.im.interfaces.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Msg>(1, _omitFieldNames ? '' : 'msg', subBuilder: $1.Msg.create)
    ..aOS(2, _omitFieldNames ? '' : 'cookie')
    ..aOS(3, _omitFieldNames ? '' : 'cookie2')
    ..aI(4, _omitFieldNames ? '' : 'errorCode')
    ..aOS(5, _omitFieldNames ? '' : 'devId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReqSendMsg clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReqSendMsg copyWith(void Function(ReqSendMsg) updates) =>
      super.copyWith((message) => updates(message as ReqSendMsg)) as ReqSendMsg;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReqSendMsg create() => ReqSendMsg._();
  @$core.override
  ReqSendMsg createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReqSendMsg getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReqSendMsg>(create);
  static ReqSendMsg? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Msg get msg => $_getN(0);
  @$pb.TagNumber(1)
  set msg($1.Msg value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMsg() => $_has(0);
  @$pb.TagNumber(1)
  void clearMsg() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Msg ensureMsg() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get cookie => $_getSZ(1);
  @$pb.TagNumber(2)
  set cookie($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCookie() => $_has(1);
  @$pb.TagNumber(2)
  void clearCookie() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get cookie2 => $_getSZ(2);
  @$pb.TagNumber(3)
  set cookie2($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCookie2() => $_has(2);
  @$pb.TagNumber(3)
  void clearCookie2() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get errorCode => $_getIZ(3);
  @$pb.TagNumber(4)
  set errorCode($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasErrorCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearErrorCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get devId => $_getSZ(4);
  @$pb.TagNumber(5)
  set devId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDevId() => $_has(4);
  @$pb.TagNumber(5)
  void clearDevId() => $_clearField(5);
}

class ReqSessionMsg extends $pb.GeneratedMessage {
  factory ReqSessionMsg({
    $fixnum.Int64? talkerId,
    $core.int? sessionType,
    $fixnum.Int64? endSeqno,
    $fixnum.Int64? beginSeqno,
    $core.int? size,
    $core.int? order,
    $core.String? devId,
    $core.String? canalToken,
  }) {
    final result = create();
    if (talkerId != null) result.talkerId = talkerId;
    if (sessionType != null) result.sessionType = sessionType;
    if (endSeqno != null) result.endSeqno = endSeqno;
    if (beginSeqno != null) result.beginSeqno = beginSeqno;
    if (size != null) result.size = size;
    if (order != null) result.order = order;
    if (devId != null) result.devId = devId;
    if (canalToken != null) result.canalToken = canalToken;
    return result;
  }

  ReqSessionMsg._();

  factory ReqSessionMsg.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReqSessionMsg.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReqSessionMsg',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.im.interfaces.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'talkerId')
    ..aI(2, _omitFieldNames ? '' : 'sessionType')
    ..aInt64(3, _omitFieldNames ? '' : 'endSeqno')
    ..aInt64(4, _omitFieldNames ? '' : 'beginSeqno')
    ..aI(5, _omitFieldNames ? '' : 'size')
    ..aI(6, _omitFieldNames ? '' : 'order')
    ..aOS(7, _omitFieldNames ? '' : 'devId')
    ..aOS(8, _omitFieldNames ? '' : 'canalToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReqSessionMsg clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReqSessionMsg copyWith(void Function(ReqSessionMsg) updates) =>
      super.copyWith((message) => updates(message as ReqSessionMsg))
          as ReqSessionMsg;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReqSessionMsg create() => ReqSessionMsg._();
  @$core.override
  ReqSessionMsg createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReqSessionMsg getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReqSessionMsg>(create);
  static ReqSessionMsg? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get talkerId => $_getI64(0);
  @$pb.TagNumber(1)
  set talkerId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTalkerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTalkerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get sessionType => $_getIZ(1);
  @$pb.TagNumber(2)
  set sessionType($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionType() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionType() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get endSeqno => $_getI64(2);
  @$pb.TagNumber(3)
  set endSeqno($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEndSeqno() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndSeqno() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get beginSeqno => $_getI64(3);
  @$pb.TagNumber(4)
  set beginSeqno($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBeginSeqno() => $_has(3);
  @$pb.TagNumber(4)
  void clearBeginSeqno() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get size => $_getIZ(4);
  @$pb.TagNumber(5)
  set size($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get order => $_getIZ(5);
  @$pb.TagNumber(6)
  set order($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOrder() => $_has(5);
  @$pb.TagNumber(6)
  void clearOrder() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get devId => $_getSZ(6);
  @$pb.TagNumber(7)
  set devId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDevId() => $_has(6);
  @$pb.TagNumber(7)
  void clearDevId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get canalToken => $_getSZ(7);
  @$pb.TagNumber(8)
  set canalToken($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCanalToken() => $_has(7);
  @$pb.TagNumber(8)
  void clearCanalToken() => $_clearField(8);
}

class ReqShareList extends $pb.GeneratedMessage {
  factory ReqShareList({
    $core.int? size,
    $core.int? source,
  }) {
    final result = create();
    if (size != null) result.size = size;
    if (source != null) result.source = source;
    return result;
  }

  ReqShareList._();

  factory ReqShareList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReqShareList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReqShareList',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.im.interfaces.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'size')
    ..aI(2, _omitFieldNames ? '' : 'source')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReqShareList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReqShareList copyWith(void Function(ReqShareList) updates) =>
      super.copyWith((message) => updates(message as ReqShareList))
          as ReqShareList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReqShareList create() => ReqShareList._();
  @$core.override
  ReqShareList createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReqShareList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReqShareList>(create);
  static ReqShareList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get size => $_getIZ(0);
  @$pb.TagNumber(1)
  set size($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearSize() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get source => $_getIZ(1);
  @$pb.TagNumber(2)
  set source($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSource() => $_has(1);
  @$pb.TagNumber(2)
  void clearSource() => $_clearField(2);
}

class ReqTotalUnread extends $pb.GeneratedMessage {
  factory ReqTotalUnread({
    $core.int? unreadType,
    $core.int? showUnfollowList,
    $fixnum.Int64? uid,
    $core.int? showDustbin,
    $core.int? singleunreadOn,
    $core.int? msgfeedOn,
    $core.int? sysupOn,
  }) {
    final result = create();
    if (unreadType != null) result.unreadType = unreadType;
    if (showUnfollowList != null) result.showUnfollowList = showUnfollowList;
    if (uid != null) result.uid = uid;
    if (showDustbin != null) result.showDustbin = showDustbin;
    if (singleunreadOn != null) result.singleunreadOn = singleunreadOn;
    if (msgfeedOn != null) result.msgfeedOn = msgfeedOn;
    if (sysupOn != null) result.sysupOn = sysupOn;
    return result;
  }

  ReqTotalUnread._();

  factory ReqTotalUnread.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReqTotalUnread.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReqTotalUnread',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.im.interfaces.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'unreadType')
    ..aI(2, _omitFieldNames ? '' : 'showUnfollowList')
    ..aInt64(3, _omitFieldNames ? '' : 'uid')
    ..aI(4, _omitFieldNames ? '' : 'showDustbin')
    ..aI(5, _omitFieldNames ? '' : 'singleunreadOn')
    ..aI(6, _omitFieldNames ? '' : 'msgfeedOn')
    ..aI(7, _omitFieldNames ? '' : 'sysupOn')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReqTotalUnread clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReqTotalUnread copyWith(void Function(ReqTotalUnread) updates) =>
      super.copyWith((message) => updates(message as ReqTotalUnread))
          as ReqTotalUnread;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReqTotalUnread create() => ReqTotalUnread._();
  @$core.override
  ReqTotalUnread createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReqTotalUnread getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReqTotalUnread>(create);
  static ReqTotalUnread? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get unreadType => $_getIZ(0);
  @$pb.TagNumber(1)
  set unreadType($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnreadType() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnreadType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get showUnfollowList => $_getIZ(1);
  @$pb.TagNumber(2)
  set showUnfollowList($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShowUnfollowList() => $_has(1);
  @$pb.TagNumber(2)
  void clearShowUnfollowList() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get uid => $_getI64(2);
  @$pb.TagNumber(3)
  set uid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUid() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get showDustbin => $_getIZ(3);
  @$pb.TagNumber(4)
  set showDustbin($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasShowDustbin() => $_has(3);
  @$pb.TagNumber(4)
  void clearShowDustbin() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get singleunreadOn => $_getIZ(4);
  @$pb.TagNumber(5)
  set singleunreadOn($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSingleunreadOn() => $_has(4);
  @$pb.TagNumber(5)
  void clearSingleunreadOn() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get msgfeedOn => $_getIZ(5);
  @$pb.TagNumber(6)
  set msgfeedOn($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMsgfeedOn() => $_has(5);
  @$pb.TagNumber(6)
  void clearMsgfeedOn() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get sysupOn => $_getIZ(6);
  @$pb.TagNumber(7)
  set sysupOn($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSysupOn() => $_has(6);
  @$pb.TagNumber(7)
  void clearSysupOn() => $_clearField(7);
}

class RspSendMsg extends $pb.GeneratedMessage {
  factory RspSendMsg({
    $fixnum.Int64? msgKey,
    $core.Iterable<EmotionInfo>? eInfos,
    $core.String? msgContent,
    $fixnum.Int64? seqno,
  }) {
    final result = create();
    if (msgKey != null) result.msgKey = msgKey;
    if (eInfos != null) result.eInfos.addAll(eInfos);
    if (msgContent != null) result.msgContent = msgContent;
    if (seqno != null) result.seqno = seqno;
    return result;
  }

  RspSendMsg._();

  factory RspSendMsg.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RspSendMsg.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RspSendMsg',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.im.interfaces.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'msgKey')
    ..pPM<EmotionInfo>(2, _omitFieldNames ? '' : 'eInfos',
        subBuilder: EmotionInfo.create)
    ..aOS(3, _omitFieldNames ? '' : 'msgContent')
    ..aInt64(6, _omitFieldNames ? '' : 'seqno')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RspSendMsg clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RspSendMsg copyWith(void Function(RspSendMsg) updates) =>
      super.copyWith((message) => updates(message as RspSendMsg)) as RspSendMsg;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RspSendMsg create() => RspSendMsg._();
  @$core.override
  RspSendMsg createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RspSendMsg getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RspSendMsg>(create);
  static RspSendMsg? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get msgKey => $_getI64(0);
  @$pb.TagNumber(1)
  set msgKey($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMsgKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearMsgKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<EmotionInfo> get eInfos => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get msgContent => $_getSZ(2);
  @$pb.TagNumber(3)
  set msgContent($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMsgContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearMsgContent() => $_clearField(3);

  @$pb.TagNumber(6)
  $fixnum.Int64 get seqno => $_getI64(3);
  @$pb.TagNumber(6)
  set seqno($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(6)
  $core.bool hasSeqno() => $_has(3);
  @$pb.TagNumber(6)
  void clearSeqno() => $_clearField(6);
}

class RspSessionMsg extends $pb.GeneratedMessage {
  factory RspSessionMsg({
    $core.Iterable<$1.Msg>? messages,
    $core.int? hasMore,
    $fixnum.Int64? minSeqno,
    $fixnum.Int64? maxSeqno,
    $core.Iterable<EmotionInfo>? eInfos,
  }) {
    final result = create();
    if (messages != null) result.messages.addAll(messages);
    if (hasMore != null) result.hasMore = hasMore;
    if (minSeqno != null) result.minSeqno = minSeqno;
    if (maxSeqno != null) result.maxSeqno = maxSeqno;
    if (eInfos != null) result.eInfos.addAll(eInfos);
    return result;
  }

  RspSessionMsg._();

  factory RspSessionMsg.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RspSessionMsg.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RspSessionMsg',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.im.interfaces.v1'),
      createEmptyInstance: create)
    ..pPM<$1.Msg>(1, _omitFieldNames ? '' : 'messages',
        subBuilder: $1.Msg.create)
    ..aI(2, _omitFieldNames ? '' : 'hasMore')
    ..aInt64(3, _omitFieldNames ? '' : 'minSeqno')
    ..aInt64(4, _omitFieldNames ? '' : 'maxSeqno')
    ..pPM<EmotionInfo>(5, _omitFieldNames ? '' : 'eInfos',
        subBuilder: EmotionInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RspSessionMsg clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RspSessionMsg copyWith(void Function(RspSessionMsg) updates) =>
      super.copyWith((message) => updates(message as RspSessionMsg))
          as RspSessionMsg;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RspSessionMsg create() => RspSessionMsg._();
  @$core.override
  RspSessionMsg createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RspSessionMsg getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RspSessionMsg>(create);
  static RspSessionMsg? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.Msg> get messages => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get hasMore => $_getIZ(1);
  @$pb.TagNumber(2)
  set hasMore($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHasMore() => $_has(1);
  @$pb.TagNumber(2)
  void clearHasMore() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get minSeqno => $_getI64(2);
  @$pb.TagNumber(3)
  set minSeqno($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMinSeqno() => $_has(2);
  @$pb.TagNumber(3)
  void clearMinSeqno() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get maxSeqno => $_getI64(3);
  @$pb.TagNumber(4)
  set maxSeqno($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxSeqno() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxSeqno() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<EmotionInfo> get eInfos => $_getList(4);
}

class RspShareList extends $pb.GeneratedMessage {
  factory RspShareList({
    $core.Iterable<ShareSessionInfo>? sessionList,
  }) {
    final result = create();
    if (sessionList != null) result.sessionList.addAll(sessionList);
    return result;
  }

  RspShareList._();

  factory RspShareList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RspShareList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RspShareList',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.im.interfaces.v1'),
      createEmptyInstance: create)
    ..pPM<ShareSessionInfo>(1, _omitFieldNames ? '' : 'sessionList',
        subBuilder: ShareSessionInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RspShareList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RspShareList copyWith(void Function(RspShareList) updates) =>
      super.copyWith((message) => updates(message as RspShareList))
          as RspShareList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RspShareList create() => RspShareList._();
  @$core.override
  RspShareList createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RspShareList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RspShareList>(create);
  static RspShareList? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ShareSessionInfo> get sessionList => $_getList(0);
}

class RspTotalUnread extends $pb.GeneratedMessage {
  factory RspTotalUnread({
    SessionSingleUnreadRsp? sessionSingleUnread,
    MsgFeedUnreadRsp? msgFeedUnread,
    SysMsgInterfaceLastMsgRsp? sysMsgInterfaceLastMsg,
    $core.int? totalUnread,
    $fixnum.Int64? customUnread,
    NewTotalUnread? newTotalUnread,
  }) {
    final result = create();
    if (sessionSingleUnread != null)
      result.sessionSingleUnread = sessionSingleUnread;
    if (msgFeedUnread != null) result.msgFeedUnread = msgFeedUnread;
    if (sysMsgInterfaceLastMsg != null)
      result.sysMsgInterfaceLastMsg = sysMsgInterfaceLastMsg;
    if (totalUnread != null) result.totalUnread = totalUnread;
    if (customUnread != null) result.customUnread = customUnread;
    if (newTotalUnread != null) result.newTotalUnread = newTotalUnread;
    return result;
  }

  RspTotalUnread._();

  factory RspTotalUnread.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RspTotalUnread.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RspTotalUnread',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.im.interfaces.v1'),
      createEmptyInstance: create)
    ..aOM<SessionSingleUnreadRsp>(
        1, _omitFieldNames ? '' : 'sessionSingleUnread',
        subBuilder: SessionSingleUnreadRsp.create)
    ..aOM<MsgFeedUnreadRsp>(2, _omitFieldNames ? '' : 'msgFeedUnread',
        subBuilder: MsgFeedUnreadRsp.create)
    ..aOM<SysMsgInterfaceLastMsgRsp>(
        3, _omitFieldNames ? '' : 'sysMsgInterfaceLastMsg',
        subBuilder: SysMsgInterfaceLastMsgRsp.create)
    ..aI(4, _omitFieldNames ? '' : 'totalUnread')
    ..aInt64(5, _omitFieldNames ? '' : 'customUnread')
    ..aOM<NewTotalUnread>(6, _omitFieldNames ? '' : 'newTotalUnread',
        subBuilder: NewTotalUnread.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RspTotalUnread clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RspTotalUnread copyWith(void Function(RspTotalUnread) updates) =>
      super.copyWith((message) => updates(message as RspTotalUnread))
          as RspTotalUnread;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RspTotalUnread create() => RspTotalUnread._();
  @$core.override
  RspTotalUnread createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RspTotalUnread getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RspTotalUnread>(create);
  static RspTotalUnread? _defaultInstance;

  @$pb.TagNumber(1)
  SessionSingleUnreadRsp get sessionSingleUnread => $_getN(0);
  @$pb.TagNumber(1)
  set sessionSingleUnread(SessionSingleUnreadRsp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionSingleUnread() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionSingleUnread() => $_clearField(1);
  @$pb.TagNumber(1)
  SessionSingleUnreadRsp ensureSessionSingleUnread() => $_ensure(0);

  @$pb.TagNumber(2)
  MsgFeedUnreadRsp get msgFeedUnread => $_getN(1);
  @$pb.TagNumber(2)
  set msgFeedUnread(MsgFeedUnreadRsp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMsgFeedUnread() => $_has(1);
  @$pb.TagNumber(2)
  void clearMsgFeedUnread() => $_clearField(2);
  @$pb.TagNumber(2)
  MsgFeedUnreadRsp ensureMsgFeedUnread() => $_ensure(1);

  @$pb.TagNumber(3)
  SysMsgInterfaceLastMsgRsp get sysMsgInterfaceLastMsg => $_getN(2);
  @$pb.TagNumber(3)
  set sysMsgInterfaceLastMsg(SysMsgInterfaceLastMsgRsp value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSysMsgInterfaceLastMsg() => $_has(2);
  @$pb.TagNumber(3)
  void clearSysMsgInterfaceLastMsg() => $_clearField(3);
  @$pb.TagNumber(3)
  SysMsgInterfaceLastMsgRsp ensureSysMsgInterfaceLastMsg() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get totalUnread => $_getIZ(3);
  @$pb.TagNumber(4)
  set totalUnread($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalUnread() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalUnread() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get customUnread => $_getI64(4);
  @$pb.TagNumber(5)
  set customUnread($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCustomUnread() => $_has(4);
  @$pb.TagNumber(5)
  void clearCustomUnread() => $_clearField(5);

  @$pb.TagNumber(6)
  NewTotalUnread get newTotalUnread => $_getN(5);
  @$pb.TagNumber(6)
  set newTotalUnread(NewTotalUnread value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasNewTotalUnread() => $_has(5);
  @$pb.TagNumber(6)
  void clearNewTotalUnread() => $_clearField(6);
  @$pb.TagNumber(6)
  NewTotalUnread ensureNewTotalUnread() => $_ensure(5);
}

class NewTotalUnread extends $pb.GeneratedMessage {
  factory NewTotalUnread({
    $core.int? unreadCount,
    $core.int? unreadType,
  }) {
    final result = create();
    if (unreadCount != null) result.unreadCount = unreadCount;
    if (unreadType != null) result.unreadType = unreadType;
    return result;
  }

  NewTotalUnread._();

  factory NewTotalUnread.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NewTotalUnread.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NewTotalUnread',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.im.interfaces.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'unreadCount')
    ..aI(2, _omitFieldNames ? '' : 'unreadType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NewTotalUnread clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NewTotalUnread copyWith(void Function(NewTotalUnread) updates) =>
      super.copyWith((message) => updates(message as NewTotalUnread))
          as NewTotalUnread;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NewTotalUnread create() => NewTotalUnread._();
  @$core.override
  NewTotalUnread createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NewTotalUnread getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NewTotalUnread>(create);
  static NewTotalUnread? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get unreadCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set unreadCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnreadCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnreadCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get unreadType => $_getIZ(1);
  @$pb.TagNumber(2)
  set unreadType($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnreadType() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnreadType() => $_clearField(2);
}

class SessionSingleUnreadRsp extends $pb.GeneratedMessage {
  factory SessionSingleUnreadRsp({
    $fixnum.Int64? unfollowUnread,
    $fixnum.Int64? followUnread,
    $core.int? unfollowPushMsg,
    $core.int? dustbinPushMsg,
    $fixnum.Int64? dustbinUnread,
    $fixnum.Int64? bizMsgUnfollowUnread,
    $fixnum.Int64? bizMsgFollowUnread,
    $fixnum.Int64? huahuoUnread,
    $fixnum.Int64? customUnread,
  }) {
    final result = create();
    if (unfollowUnread != null) result.unfollowUnread = unfollowUnread;
    if (followUnread != null) result.followUnread = followUnread;
    if (unfollowPushMsg != null) result.unfollowPushMsg = unfollowPushMsg;
    if (dustbinPushMsg != null) result.dustbinPushMsg = dustbinPushMsg;
    if (dustbinUnread != null) result.dustbinUnread = dustbinUnread;
    if (bizMsgUnfollowUnread != null)
      result.bizMsgUnfollowUnread = bizMsgUnfollowUnread;
    if (bizMsgFollowUnread != null)
      result.bizMsgFollowUnread = bizMsgFollowUnread;
    if (huahuoUnread != null) result.huahuoUnread = huahuoUnread;
    if (customUnread != null) result.customUnread = customUnread;
    return result;
  }

  SessionSingleUnreadRsp._();

  factory SessionSingleUnreadRsp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SessionSingleUnreadRsp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionSingleUnreadRsp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.im.interfaces.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'unfollowUnread')
    ..aInt64(2, _omitFieldNames ? '' : 'followUnread')
    ..aI(3, _omitFieldNames ? '' : 'unfollowPushMsg')
    ..aI(4, _omitFieldNames ? '' : 'dustbinPushMsg')
    ..aInt64(5, _omitFieldNames ? '' : 'dustbinUnread')
    ..aInt64(6, _omitFieldNames ? '' : 'bizMsgUnfollowUnread')
    ..aInt64(7, _omitFieldNames ? '' : 'bizMsgFollowUnread')
    ..aInt64(8, _omitFieldNames ? '' : 'huahuoUnread')
    ..aInt64(9, _omitFieldNames ? '' : 'customUnread')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionSingleUnreadRsp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionSingleUnreadRsp copyWith(
          void Function(SessionSingleUnreadRsp) updates) =>
      super.copyWith((message) => updates(message as SessionSingleUnreadRsp))
          as SessionSingleUnreadRsp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SessionSingleUnreadRsp create() => SessionSingleUnreadRsp._();
  @$core.override
  SessionSingleUnreadRsp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SessionSingleUnreadRsp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionSingleUnreadRsp>(create);
  static SessionSingleUnreadRsp? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get unfollowUnread => $_getI64(0);
  @$pb.TagNumber(1)
  set unfollowUnread($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnfollowUnread() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnfollowUnread() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get followUnread => $_getI64(1);
  @$pb.TagNumber(2)
  set followUnread($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFollowUnread() => $_has(1);
  @$pb.TagNumber(2)
  void clearFollowUnread() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get unfollowPushMsg => $_getIZ(2);
  @$pb.TagNumber(3)
  set unfollowPushMsg($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnfollowPushMsg() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnfollowPushMsg() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get dustbinPushMsg => $_getIZ(3);
  @$pb.TagNumber(4)
  set dustbinPushMsg($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDustbinPushMsg() => $_has(3);
  @$pb.TagNumber(4)
  void clearDustbinPushMsg() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get dustbinUnread => $_getI64(4);
  @$pb.TagNumber(5)
  set dustbinUnread($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDustbinUnread() => $_has(4);
  @$pb.TagNumber(5)
  void clearDustbinUnread() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get bizMsgUnfollowUnread => $_getI64(5);
  @$pb.TagNumber(6)
  set bizMsgUnfollowUnread($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBizMsgUnfollowUnread() => $_has(5);
  @$pb.TagNumber(6)
  void clearBizMsgUnfollowUnread() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get bizMsgFollowUnread => $_getI64(6);
  @$pb.TagNumber(7)
  set bizMsgFollowUnread($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBizMsgFollowUnread() => $_has(6);
  @$pb.TagNumber(7)
  void clearBizMsgFollowUnread() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get huahuoUnread => $_getI64(7);
  @$pb.TagNumber(8)
  set huahuoUnread($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHuahuoUnread() => $_has(7);
  @$pb.TagNumber(8)
  void clearHuahuoUnread() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get customUnread => $_getI64(8);
  @$pb.TagNumber(9)
  set customUnread($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCustomUnread() => $_has(8);
  @$pb.TagNumber(9)
  void clearCustomUnread() => $_clearField(9);
}

class ShareSessionInfo extends $pb.GeneratedMessage {
  factory ShareSessionInfo({
    $fixnum.Int64? talkerId,
    $core.String? talkerUname,
    $core.String? talkerIcon,
    $core.int? officialType,
  }) {
    final result = create();
    if (talkerId != null) result.talkerId = talkerId;
    if (talkerUname != null) result.talkerUname = talkerUname;
    if (talkerIcon != null) result.talkerIcon = talkerIcon;
    if (officialType != null) result.officialType = officialType;
    return result;
  }

  ShareSessionInfo._();

  factory ShareSessionInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShareSessionInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShareSessionInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.im.interfaces.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'talkerId')
    ..aOS(2, _omitFieldNames ? '' : 'talkerUname')
    ..aOS(3, _omitFieldNames ? '' : 'talkerIcon')
    ..aI(4, _omitFieldNames ? '' : 'officialType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareSessionInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareSessionInfo copyWith(void Function(ShareSessionInfo) updates) =>
      super.copyWith((message) => updates(message as ShareSessionInfo))
          as ShareSessionInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShareSessionInfo create() => ShareSessionInfo._();
  @$core.override
  ShareSessionInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ShareSessionInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShareSessionInfo>(create);
  static ShareSessionInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get talkerId => $_getI64(0);
  @$pb.TagNumber(1)
  set talkerId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTalkerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTalkerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get talkerUname => $_getSZ(1);
  @$pb.TagNumber(2)
  set talkerUname($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTalkerUname() => $_has(1);
  @$pb.TagNumber(2)
  void clearTalkerUname() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get talkerIcon => $_getSZ(2);
  @$pb.TagNumber(3)
  set talkerIcon($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTalkerIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearTalkerIcon() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get officialType => $_getIZ(3);
  @$pb.TagNumber(4)
  set officialType($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOfficialType() => $_has(3);
  @$pb.TagNumber(4)
  void clearOfficialType() => $_clearField(4);
}

class SysMsgInterfaceLastMsgRsp extends $pb.GeneratedMessage {
  factory SysMsgInterfaceLastMsgRsp({
    $core.int? unread,
    $core.String? title,
    $core.String? time,
    $fixnum.Int64? id,
  }) {
    final result = create();
    if (unread != null) result.unread = unread;
    if (title != null) result.title = title;
    if (time != null) result.time = time;
    if (id != null) result.id = id;
    return result;
  }

  SysMsgInterfaceLastMsgRsp._();

  factory SysMsgInterfaceLastMsgRsp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SysMsgInterfaceLastMsgRsp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SysMsgInterfaceLastMsgRsp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.im.interfaces.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'unread')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'time')
    ..aInt64(4, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SysMsgInterfaceLastMsgRsp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SysMsgInterfaceLastMsgRsp copyWith(
          void Function(SysMsgInterfaceLastMsgRsp) updates) =>
      super.copyWith((message) => updates(message as SysMsgInterfaceLastMsgRsp))
          as SysMsgInterfaceLastMsgRsp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SysMsgInterfaceLastMsgRsp create() => SysMsgInterfaceLastMsgRsp._();
  @$core.override
  SysMsgInterfaceLastMsgRsp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SysMsgInterfaceLastMsgRsp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SysMsgInterfaceLastMsgRsp>(create);
  static SysMsgInterfaceLastMsgRsp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get unread => $_getIZ(0);
  @$pb.TagNumber(1)
  set unread($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnread() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnread() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get time => $_getSZ(2);
  @$pb.TagNumber(3)
  set time($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearTime() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get id => $_getI64(3);
  @$pb.TagNumber(4)
  set id($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasId() => $_has(3);
  @$pb.TagNumber(4)
  void clearId() => $_clearField(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
