// This is a generated file - do not edit.
//
// Generated from bilibili/im/type.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'type.pbenum.dart';

class Msg extends $pb.GeneratedMessage {
  factory Msg({
    $fixnum.Int64? senderUid,
    $core.int? receiverType,
    $fixnum.Int64? receiverId,
    $fixnum.Int64? cliMsgId,
    $core.int? msgType,
    $core.String? content,
    $fixnum.Int64? msgSeqno,
    $fixnum.Int64? timestamp,
    $core.Iterable<$fixnum.Int64>? atUids,
    $core.Iterable<$fixnum.Int64>? recverIds,
    $fixnum.Int64? msgKey,
    $core.int? msgStatus,
    $core.bool? sysCancel,
    $core.String? notifyCode,
    $core.int? msgSource,
    $core.int? newFaceVersion,
  }) {
    final result = create();
    if (senderUid != null) result.senderUid = senderUid;
    if (receiverType != null) result.receiverType = receiverType;
    if (receiverId != null) result.receiverId = receiverId;
    if (cliMsgId != null) result.cliMsgId = cliMsgId;
    if (msgType != null) result.msgType = msgType;
    if (content != null) result.content = content;
    if (msgSeqno != null) result.msgSeqno = msgSeqno;
    if (timestamp != null) result.timestamp = timestamp;
    if (atUids != null) result.atUids.addAll(atUids);
    if (recverIds != null) result.recverIds.addAll(recverIds);
    if (msgKey != null) result.msgKey = msgKey;
    if (msgStatus != null) result.msgStatus = msgStatus;
    if (sysCancel != null) result.sysCancel = sysCancel;
    if (notifyCode != null) result.notifyCode = notifyCode;
    if (msgSource != null) result.msgSource = msgSource;
    if (newFaceVersion != null) result.newFaceVersion = newFaceVersion;
    return result;
  }

  Msg._();

  factory Msg.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Msg.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Msg',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.im.type'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'senderUid')
    ..aI(2, _omitFieldNames ? '' : 'receiverType')
    ..aInt64(3, _omitFieldNames ? '' : 'receiverId')
    ..aInt64(4, _omitFieldNames ? '' : 'cliMsgId')
    ..aI(5, _omitFieldNames ? '' : 'msgType')
    ..aOS(6, _omitFieldNames ? '' : 'content')
    ..aInt64(7, _omitFieldNames ? '' : 'msgSeqno')
    ..aInt64(8, _omitFieldNames ? '' : 'timestamp')
    ..p<$fixnum.Int64>(9, _omitFieldNames ? '' : 'atUids', $pb.PbFieldType.K6)
    ..p<$fixnum.Int64>(
        10, _omitFieldNames ? '' : 'recverIds', $pb.PbFieldType.K6)
    ..aInt64(11, _omitFieldNames ? '' : 'msgKey')
    ..aI(12, _omitFieldNames ? '' : 'msgStatus')
    ..aOB(13, _omitFieldNames ? '' : 'sysCancel')
    ..aOS(14, _omitFieldNames ? '' : 'notifyCode')
    ..aI(15, _omitFieldNames ? '' : 'msgSource')
    ..aI(16, _omitFieldNames ? '' : 'newFaceVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Msg clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Msg copyWith(void Function(Msg) updates) =>
      super.copyWith((message) => updates(message as Msg)) as Msg;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Msg create() => Msg._();
  @$core.override
  Msg createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Msg getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Msg>(create);
  static Msg? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get senderUid => $_getI64(0);
  @$pb.TagNumber(1)
  set senderUid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSenderUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSenderUid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get receiverType => $_getIZ(1);
  @$pb.TagNumber(2)
  set receiverType($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReceiverType() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceiverType() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get receiverId => $_getI64(2);
  @$pb.TagNumber(3)
  set receiverId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReceiverId() => $_has(2);
  @$pb.TagNumber(3)
  void clearReceiverId() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get cliMsgId => $_getI64(3);
  @$pb.TagNumber(4)
  set cliMsgId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCliMsgId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCliMsgId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get msgType => $_getIZ(4);
  @$pb.TagNumber(5)
  set msgType($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMsgType() => $_has(4);
  @$pb.TagNumber(5)
  void clearMsgType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get content => $_getSZ(5);
  @$pb.TagNumber(6)
  set content($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasContent() => $_has(5);
  @$pb.TagNumber(6)
  void clearContent() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get msgSeqno => $_getI64(6);
  @$pb.TagNumber(7)
  set msgSeqno($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMsgSeqno() => $_has(6);
  @$pb.TagNumber(7)
  void clearMsgSeqno() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get timestamp => $_getI64(7);
  @$pb.TagNumber(8)
  set timestamp($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTimestamp() => $_has(7);
  @$pb.TagNumber(8)
  void clearTimestamp() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$fixnum.Int64> get atUids => $_getList(8);

  @$pb.TagNumber(10)
  $pb.PbList<$fixnum.Int64> get recverIds => $_getList(9);

  @$pb.TagNumber(11)
  $fixnum.Int64 get msgKey => $_getI64(10);
  @$pb.TagNumber(11)
  set msgKey($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasMsgKey() => $_has(10);
  @$pb.TagNumber(11)
  void clearMsgKey() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get msgStatus => $_getIZ(11);
  @$pb.TagNumber(12)
  set msgStatus($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasMsgStatus() => $_has(11);
  @$pb.TagNumber(12)
  void clearMsgStatus() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get sysCancel => $_getBF(12);
  @$pb.TagNumber(13)
  set sysCancel($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasSysCancel() => $_has(12);
  @$pb.TagNumber(13)
  void clearSysCancel() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get notifyCode => $_getSZ(13);
  @$pb.TagNumber(14)
  set notifyCode($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasNotifyCode() => $_has(13);
  @$pb.TagNumber(14)
  void clearNotifyCode() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get msgSource => $_getIZ(14);
  @$pb.TagNumber(15)
  set msgSource($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasMsgSource() => $_has(14);
  @$pb.TagNumber(15)
  void clearMsgSource() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.int get newFaceVersion => $_getIZ(15);
  @$pb.TagNumber(16)
  set newFaceVersion($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasNewFaceVersion() => $_has(15);
  @$pb.TagNumber(16)
  void clearNewFaceVersion() => $_clearField(16);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
