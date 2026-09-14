// This is a generated file - do not edit.
//
// Generated from bilibili/app/im/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../account/service/v1.pb.dart' as $1;
import '../../dagw/component/avatar/v1.pb.dart' as $0;
import 'v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'v1.pbenum.dart';

class AirDropShareUserInfo extends $pb.GeneratedMessage {
  factory AirDropShareUserInfo({
    $fixnum.Int64? mid,
    $core.String? face,
    $core.String? url,
    $core.String? name,
  }) {
    final result = AirDropShareUserInfo._();
    if (mid != null) result.mid = mid;
    if (face != null) result.face = face;
    if (url != null) result.url = url;
    if (name != null) result.name = name;
    return result;
  }

  AirDropShareUserInfo._();

  factory AirDropShareUserInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AirDropShareUserInfo()..mergeFromBuffer(data, registry);
  factory AirDropShareUserInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AirDropShareUserInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AirDropShareUserInfo',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: AirDropShareUserInfo.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'face')
    ..aOS(3, _omitFieldNames ? '' : 'url')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AirDropShareUserInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AirDropShareUserInfo copyWith(void Function(AirDropShareUserInfo) updates) =>
      super.copyWith((message) => updates(message as AirDropShareUserInfo))
          as AirDropShareUserInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AirDropShareUserInfo() / AirDropShareUserInfo.new instead')
  static AirDropShareUserInfo create() => AirDropShareUserInfo._();
  static $pb.GeneratedMessage $_createMessage() => AirDropShareUserInfo._();
  @$core.override
  AirDropShareUserInfo createEmptyInstance() => AirDropShareUserInfo._();
  @$core.pragma('dart2js:noInline')
  static AirDropShareUserInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AirDropShareUserInfo>(
          AirDropShareUserInfo.$_createMessage);
  static AirDropShareUserInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get mid => $_getI64(0);
  @$pb.TagNumber(1)
  set mid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearMid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get face => $_getSZ(1);
  @$pb.TagNumber(2)
  set face($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFace() => $_has(1);
  @$pb.TagNumber(2)
  void clearFace() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get url => $_getSZ(2);
  @$pb.TagNumber(3)
  set url($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);
}

class AirDropToImReply extends $pb.GeneratedMessage {
  factory AirDropToImReply({
    $core.Iterable<AirDropShareUserInfo>? userInfos,
  }) {
    final result = AirDropToImReply._();
    if (userInfos != null) result.userInfos.addAll(userInfos);
    return result;
  }

  AirDropToImReply._();

  factory AirDropToImReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AirDropToImReply()..mergeFromBuffer(data, registry);
  factory AirDropToImReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AirDropToImReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AirDropToImReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: AirDropToImReply.$_createMessage)
    ..pPM<AirDropShareUserInfo>(1, _omitFieldNames ? '' : 'userInfos',
        subBuilder: AirDropShareUserInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AirDropToImReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AirDropToImReply copyWith(void Function(AirDropToImReply) updates) =>
      super.copyWith((message) => updates(message as AirDropToImReply))
          as AirDropToImReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AirDropToImReply() / AirDropToImReply.new instead')
  static AirDropToImReply create() => AirDropToImReply._();
  static $pb.GeneratedMessage $_createMessage() => AirDropToImReply._();
  @$core.override
  AirDropToImReply createEmptyInstance() => AirDropToImReply._();
  @$core.pragma('dart2js:noInline')
  static AirDropToImReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AirDropToImReply>(
          AirDropToImReply.$_createMessage);
  static AirDropToImReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AirDropShareUserInfo> get userInfos => $_getList(0);
}

class AirDropToImReq extends $pb.GeneratedMessage {
  factory AirDropToImReq({
    AirDropFrom? adf,
  }) {
    final result = AirDropToImReq._();
    if (adf != null) result.adf = adf;
    return result;
  }

  AirDropToImReq._();

  factory AirDropToImReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AirDropToImReq()..mergeFromBuffer(data, registry);
  factory AirDropToImReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AirDropToImReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AirDropToImReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: AirDropToImReq.$_createMessage)
    ..aE<AirDropFrom>(1, _omitFieldNames ? '' : 'adf',
        enumValues: AirDropFrom.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AirDropToImReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AirDropToImReq copyWith(void Function(AirDropToImReq) updates) =>
      super.copyWith((message) => updates(message as AirDropToImReq))
          as AirDropToImReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AirDropToImReq() / AirDropToImReq.new instead')
  static AirDropToImReq create() => AirDropToImReq._();
  static $pb.GeneratedMessage $_createMessage() => AirDropToImReq._();
  @$core.override
  AirDropToImReq createEmptyInstance() => AirDropToImReq._();
  @$core.pragma('dart2js:noInline')
  static AirDropToImReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AirDropToImReq>(
          AirDropToImReq.$_createMessage);
  static AirDropToImReq? _defaultInstance;

  @$pb.TagNumber(1)
  AirDropFrom get adf => $_getN(0);
  @$pb.TagNumber(1)
  set adf(AirDropFrom value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAdf() => $_has(0);
  @$pb.TagNumber(1)
  void clearAdf() => $_clearField(1);
}

class AutoReplyToast extends $pb.GeneratedMessage {
  factory AutoReplyToast({
    $core.String? title,
    $core.String? url,
  }) {
    final result = AutoReplyToast._();
    if (title != null) result.title = title;
    if (url != null) result.url = url;
    return result;
  }

  AutoReplyToast._();

  factory AutoReplyToast.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AutoReplyToast()..mergeFromBuffer(data, registry);
  factory AutoReplyToast.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AutoReplyToast()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AutoReplyToast',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: AutoReplyToast.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AutoReplyToast clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AutoReplyToast copyWith(void Function(AutoReplyToast) updates) =>
      super.copyWith((message) => updates(message as AutoReplyToast))
          as AutoReplyToast;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AutoReplyToast() / AutoReplyToast.new instead')
  static AutoReplyToast create() => AutoReplyToast._();
  static $pb.GeneratedMessage $_createMessage() => AutoReplyToast._();
  @$core.override
  AutoReplyToast createEmptyInstance() => AutoReplyToast._();
  @$core.pragma('dart2js:noInline')
  static AutoReplyToast getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AutoReplyToast>(
          AutoReplyToast.$_createMessage);
  static AutoReplyToast? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);
}

class BehaviorAlertToast extends $pb.GeneratedMessage {
  factory BehaviorAlertToast({
    $core.String? title,
    $core.String? content,
    $core.String? typeStr,
    AlertToastType? type,
  }) {
    final result = BehaviorAlertToast._();
    if (title != null) result.title = title;
    if (content != null) result.content = content;
    if (typeStr != null) result.typeStr = typeStr;
    if (type != null) result.type = type;
    return result;
  }

  BehaviorAlertToast._();

  factory BehaviorAlertToast.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BehaviorAlertToast()..mergeFromBuffer(data, registry);
  factory BehaviorAlertToast.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BehaviorAlertToast()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BehaviorAlertToast',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: BehaviorAlertToast.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'content')
    ..aOS(3, _omitFieldNames ? '' : 'typeStr')
    ..aE<AlertToastType>(4, _omitFieldNames ? '' : 'type',
        enumValues: AlertToastType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BehaviorAlertToast clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BehaviorAlertToast copyWith(void Function(BehaviorAlertToast) updates) =>
      super.copyWith((message) => updates(message as BehaviorAlertToast))
          as BehaviorAlertToast;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BehaviorAlertToast() / BehaviorAlertToast.new instead')
  static BehaviorAlertToast create() => BehaviorAlertToast._();
  static $pb.GeneratedMessage $_createMessage() => BehaviorAlertToast._();
  @$core.override
  BehaviorAlertToast createEmptyInstance() => BehaviorAlertToast._();
  @$core.pragma('dart2js:noInline')
  static BehaviorAlertToast getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BehaviorAlertToast>(
          BehaviorAlertToast.$_createMessage);
  static BehaviorAlertToast? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get content => $_getSZ(1);
  @$pb.TagNumber(2)
  set content($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get typeStr => $_getSZ(2);
  @$pb.TagNumber(3)
  set typeStr($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTypeStr() => $_has(2);
  @$pb.TagNumber(3)
  void clearTypeStr() => $_clearField(3);

  @$pb.TagNumber(4)
  AlertToastType get type => $_getN(3);
  @$pb.TagNumber(4)
  set type(AlertToastType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasType() => $_has(3);
  @$pb.TagNumber(4)
  void clearType() => $_clearField(4);
}

class BorderedLabel extends $pb.GeneratedMessage {
  factory BorderedLabel({
    $core.String? icon,
    $core.String? text,
  }) {
    final result = BorderedLabel._();
    if (icon != null) result.icon = icon;
    if (text != null) result.text = text;
    return result;
  }

  BorderedLabel._();

  factory BorderedLabel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BorderedLabel()..mergeFromBuffer(data, registry);
  factory BorderedLabel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BorderedLabel()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BorderedLabel',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: BorderedLabel.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'icon')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BorderedLabel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BorderedLabel copyWith(void Function(BorderedLabel) updates) =>
      super.copyWith((message) => updates(message as BorderedLabel))
          as BorderedLabel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BorderedLabel() / BorderedLabel.new instead')
  static BorderedLabel create() => BorderedLabel._();
  static $pb.GeneratedMessage $_createMessage() => BorderedLabel._();
  @$core.override
  BorderedLabel createEmptyInstance() => BorderedLabel._();
  @$core.pragma('dart2js:noInline')
  static BorderedLabel getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BorderedLabel>(
          BorderedLabel.$_createMessage);
  static BorderedLabel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get icon => $_getSZ(0);
  @$pb.TagNumber(1)
  set icon($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIcon() => $_has(0);
  @$pb.TagNumber(1)
  void clearIcon() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);
}

class CancelInterceptInDustbinReply extends $pb.GeneratedMessage {
  factory CancelInterceptInDustbinReply() => CancelInterceptInDustbinReply._();

  CancelInterceptInDustbinReply._();

  factory CancelInterceptInDustbinReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelInterceptInDustbinReply()..mergeFromBuffer(data, registry);
  factory CancelInterceptInDustbinReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelInterceptInDustbinReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelInterceptInDustbinReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: CancelInterceptInDustbinReply.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelInterceptInDustbinReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelInterceptInDustbinReply copyWith(
          void Function(CancelInterceptInDustbinReply) updates) =>
      super.copyWith(
              (message) => updates(message as CancelInterceptInDustbinReply))
          as CancelInterceptInDustbinReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CancelInterceptInDustbinReply() / CancelInterceptInDustbinReply.new instead')
  static CancelInterceptInDustbinReply create() =>
      CancelInterceptInDustbinReply._();
  static $pb.GeneratedMessage $_createMessage() =>
      CancelInterceptInDustbinReply._();
  @$core.override
  CancelInterceptInDustbinReply createEmptyInstance() =>
      CancelInterceptInDustbinReply._();
  @$core.pragma('dart2js:noInline')
  static CancelInterceptInDustbinReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelInterceptInDustbinReply>(
          CancelInterceptInDustbinReply.$_createMessage);
  static CancelInterceptInDustbinReply? _defaultInstance;
}

class CancelInterceptInDustbinReq extends $pb.GeneratedMessage {
  factory CancelInterceptInDustbinReq({
    SessionId? sessionId,
  }) {
    final result = CancelInterceptInDustbinReq._();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  CancelInterceptInDustbinReq._();

  factory CancelInterceptInDustbinReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelInterceptInDustbinReq()..mergeFromBuffer(data, registry);
  factory CancelInterceptInDustbinReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelInterceptInDustbinReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelInterceptInDustbinReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: CancelInterceptInDustbinReq.$_createMessage)
    ..aOM<SessionId>(1, _omitFieldNames ? '' : 'sessionId',
        subBuilder: SessionId.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelInterceptInDustbinReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelInterceptInDustbinReq copyWith(
          void Function(CancelInterceptInDustbinReq) updates) =>
      super.copyWith(
              (message) => updates(message as CancelInterceptInDustbinReq))
          as CancelInterceptInDustbinReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CancelInterceptInDustbinReq() / CancelInterceptInDustbinReq.new instead')
  static CancelInterceptInDustbinReq create() =>
      CancelInterceptInDustbinReq._();
  static $pb.GeneratedMessage $_createMessage() =>
      CancelInterceptInDustbinReq._();
  @$core.override
  CancelInterceptInDustbinReq createEmptyInstance() =>
      CancelInterceptInDustbinReq._();
  @$core.pragma('dart2js:noInline')
  static CancelInterceptInDustbinReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelInterceptInDustbinReq>(
          CancelInterceptInDustbinReq.$_createMessage);
  static CancelInterceptInDustbinReq? _defaultInstance;

  @$pb.TagNumber(1)
  SessionId get sessionId => $_getN(0);
  @$pb.TagNumber(1)
  set sessionId(SessionId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
  @$pb.TagNumber(1)
  SessionId ensureSessionId() => $_ensure(0);
}

class ClearAlertReply extends $pb.GeneratedMessage {
  factory ClearAlertReply() => ClearAlertReply._();

  ClearAlertReply._();

  factory ClearAlertReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearAlertReply()..mergeFromBuffer(data, registry);
  factory ClearAlertReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearAlertReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearAlertReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: ClearAlertReply.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearAlertReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearAlertReply copyWith(void Function(ClearAlertReply) updates) =>
      super.copyWith((message) => updates(message as ClearAlertReply))
          as ClearAlertReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ClearAlertReply() / ClearAlertReply.new instead')
  static ClearAlertReply create() => ClearAlertReply._();
  static $pb.GeneratedMessage $_createMessage() => ClearAlertReply._();
  @$core.override
  ClearAlertReply createEmptyInstance() => ClearAlertReply._();
  @$core.pragma('dart2js:noInline')
  static ClearAlertReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClearAlertReply>(
          ClearAlertReply.$_createMessage);
  static ClearAlertReply? _defaultInstance;
}

class ClearAlertReq extends $pb.GeneratedMessage {
  factory ClearAlertReq({
    AlertToastType? type,
  }) {
    final result = ClearAlertReq._();
    if (type != null) result.type = type;
    return result;
  }

  ClearAlertReq._();

  factory ClearAlertReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearAlertReq()..mergeFromBuffer(data, registry);
  factory ClearAlertReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearAlertReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearAlertReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: ClearAlertReq.$_createMessage)
    ..aE<AlertToastType>(1, _omitFieldNames ? '' : 'type',
        enumValues: AlertToastType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearAlertReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearAlertReq copyWith(void Function(ClearAlertReq) updates) =>
      super.copyWith((message) => updates(message as ClearAlertReq))
          as ClearAlertReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ClearAlertReq() / ClearAlertReq.new instead')
  static ClearAlertReq create() => ClearAlertReq._();
  static $pb.GeneratedMessage $_createMessage() => ClearAlertReq._();
  @$core.override
  ClearAlertReq createEmptyInstance() => ClearAlertReq._();
  @$core.pragma('dart2js:noInline')
  static ClearAlertReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClearAlertReq>(
          ClearAlertReq.$_createMessage);
  static ClearAlertReq? _defaultInstance;

  @$pb.TagNumber(1)
  AlertToastType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(AlertToastType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);
}

class ClearUnreadReply extends $pb.GeneratedMessage {
  factory ClearUnreadReply() => ClearUnreadReply._();

  ClearUnreadReply._();

  factory ClearUnreadReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearUnreadReply()..mergeFromBuffer(data, registry);
  factory ClearUnreadReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearUnreadReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearUnreadReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: ClearUnreadReply.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearUnreadReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearUnreadReply copyWith(void Function(ClearUnreadReply) updates) =>
      super.copyWith((message) => updates(message as ClearUnreadReply))
          as ClearUnreadReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ClearUnreadReply() / ClearUnreadReply.new instead')
  static ClearUnreadReply create() => ClearUnreadReply._();
  static $pb.GeneratedMessage $_createMessage() => ClearUnreadReply._();
  @$core.override
  ClearUnreadReply createEmptyInstance() => ClearUnreadReply._();
  @$core.pragma('dart2js:noInline')
  static ClearUnreadReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClearUnreadReply>(
          ClearUnreadReply.$_createMessage);
  static ClearUnreadReply? _defaultInstance;
}

class ClearUnreadReq extends $pb.GeneratedMessage {
  factory ClearUnreadReq({
    SessionPageType? pageType,
    SessionId? sessionId,
  }) {
    final result = ClearUnreadReq._();
    if (pageType != null) result.pageType = pageType;
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  ClearUnreadReq._();

  factory ClearUnreadReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearUnreadReq()..mergeFromBuffer(data, registry);
  factory ClearUnreadReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClearUnreadReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearUnreadReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: ClearUnreadReq.$_createMessage)
    ..aE<SessionPageType>(1, _omitFieldNames ? '' : 'pageType',
        enumValues: SessionPageType.values)
    ..aOM<SessionId>(2, _omitFieldNames ? '' : 'sessionId',
        subBuilder: SessionId.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearUnreadReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearUnreadReq copyWith(void Function(ClearUnreadReq) updates) =>
      super.copyWith((message) => updates(message as ClearUnreadReq))
          as ClearUnreadReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ClearUnreadReq() / ClearUnreadReq.new instead')
  static ClearUnreadReq create() => ClearUnreadReq._();
  static $pb.GeneratedMessage $_createMessage() => ClearUnreadReq._();
  @$core.override
  ClearUnreadReq createEmptyInstance() => ClearUnreadReq._();
  @$core.pragma('dart2js:noInline')
  static ClearUnreadReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClearUnreadReq>(
          ClearUnreadReq.$_createMessage);
  static ClearUnreadReq? _defaultInstance;

  @$pb.TagNumber(1)
  SessionPageType get pageType => $_getN(0);
  @$pb.TagNumber(1)
  set pageType(SessionPageType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPageType() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageType() => $_clearField(1);

  @$pb.TagNumber(2)
  SessionId get sessionId => $_getN(1);
  @$pb.TagNumber(2)
  set sessionId(SessionId value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);
  @$pb.TagNumber(2)
  SessionId ensureSessionId() => $_ensure(1);
}

class Contact extends $pb.GeneratedMessage {
  factory Contact({
    $fixnum.Int64? id,
    $core.String? name,
    $0.AvatarItem? avatar,
    $core.String? vipInfo,
    $core.String? url,
    $1.NameRender? nameRender,
    $core.bool? isSpecialFollow,
    $core.String? face,
    $core.int? officialType,
  }) {
    final result = Contact._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (avatar != null) result.avatar = avatar;
    if (vipInfo != null) result.vipInfo = vipInfo;
    if (url != null) result.url = url;
    if (nameRender != null) result.nameRender = nameRender;
    if (isSpecialFollow != null) result.isSpecialFollow = isSpecialFollow;
    if (face != null) result.face = face;
    if (officialType != null) result.officialType = officialType;
    return result;
  }

  Contact._();

  factory Contact.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Contact()..mergeFromBuffer(data, registry);
  factory Contact.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Contact()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Contact',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: Contact.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOM<$0.AvatarItem>(3, _omitFieldNames ? '' : 'avatar',
        subBuilder: $0.AvatarItem.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'vipInfo')
    ..aOS(5, _omitFieldNames ? '' : 'url')
    ..aOM<$1.NameRender>(6, _omitFieldNames ? '' : 'nameRender',
        subBuilder: $1.NameRender.$_createMessage)
    ..aOB(7, _omitFieldNames ? '' : 'isSpecialFollow')
    ..aOS(8, _omitFieldNames ? '' : 'face')
    ..aI(9, _omitFieldNames ? '' : 'officialType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Contact clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Contact copyWith(void Function(Contact) updates) =>
      super.copyWith((message) => updates(message as Contact)) as Contact;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Contact() / Contact.new instead')
  static Contact create() => Contact._();
  static $pb.GeneratedMessage $_createMessage() => Contact._();
  @$core.override
  Contact createEmptyInstance() => Contact._();
  @$core.pragma('dart2js:noInline')
  static Contact getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Contact>(Contact.$_createMessage);
  static Contact? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.AvatarItem get avatar => $_getN(2);
  @$pb.TagNumber(3)
  set avatar($0.AvatarItem value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAvatar() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvatar() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.AvatarItem ensureAvatar() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get vipInfo => $_getSZ(3);
  @$pb.TagNumber(4)
  set vipInfo($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVipInfo() => $_has(3);
  @$pb.TagNumber(4)
  void clearVipInfo() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get url => $_getSZ(4);
  @$pb.TagNumber(5)
  set url($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.NameRender get nameRender => $_getN(5);
  @$pb.TagNumber(6)
  set nameRender($1.NameRender value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasNameRender() => $_has(5);
  @$pb.TagNumber(6)
  void clearNameRender() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.NameRender ensureNameRender() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.bool get isSpecialFollow => $_getBF(6);
  @$pb.TagNumber(7)
  set isSpecialFollow($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsSpecialFollow() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsSpecialFollow() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get face => $_getSZ(7);
  @$pb.TagNumber(8)
  set face($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFace() => $_has(7);
  @$pb.TagNumber(8)
  void clearFace() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get officialType => $_getIZ(8);
  @$pb.TagNumber(9)
  set officialType($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOfficialType() => $_has(8);
  @$pb.TagNumber(9)
  void clearOfficialType() => $_clearField(9);
}

class ContactTab extends $pb.GeneratedMessage {
  factory ContactTab({
    ContactTabType? tab,
    $core.String? name,
  }) {
    final result = ContactTab._();
    if (tab != null) result.tab = tab;
    if (name != null) result.name = name;
    return result;
  }

  ContactTab._();

  factory ContactTab.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContactTab()..mergeFromBuffer(data, registry);
  factory ContactTab.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContactTab()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContactTab',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: ContactTab.$_createMessage)
    ..aE<ContactTabType>(1, _omitFieldNames ? '' : 'tab',
        enumValues: ContactTabType.values)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactTab clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactTab copyWith(void Function(ContactTab) updates) =>
      super.copyWith((message) => updates(message as ContactTab)) as ContactTab;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ContactTab() / ContactTab.new instead')
  static ContactTab create() => ContactTab._();
  static $pb.GeneratedMessage $_createMessage() => ContactTab._();
  @$core.override
  ContactTab createEmptyInstance() => ContactTab._();
  @$core.pragma('dart2js:noInline')
  static ContactTab getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContactTab>(ContactTab.$_createMessage);
  static ContactTab? _defaultInstance;

  @$pb.TagNumber(1)
  ContactTabType get tab => $_getN(0);
  @$pb.TagNumber(1)
  set tab(ContactTabType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTab() => $_has(0);
  @$pb.TagNumber(1)
  void clearTab() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

class ContactsReply extends $pb.GeneratedMessage {
  factory ContactsReply({
    $core.Iterable<Contact>? contacts,
    $core.Iterable<ContactTab>? tab,
    ContactTabType? currentTab,
    PaginationParams? paginationParams,
  }) {
    final result = ContactsReply._();
    if (contacts != null) result.contacts.addAll(contacts);
    if (tab != null) result.tab.addAll(tab);
    if (currentTab != null) result.currentTab = currentTab;
    if (paginationParams != null) result.paginationParams = paginationParams;
    return result;
  }

  ContactsReply._();

  factory ContactsReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContactsReply()..mergeFromBuffer(data, registry);
  factory ContactsReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContactsReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContactsReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: ContactsReply.$_createMessage)
    ..pPM<Contact>(1, _omitFieldNames ? '' : 'contacts',
        subBuilder: Contact.$_createMessage)
    ..pPM<ContactTab>(2, _omitFieldNames ? '' : 'tab',
        subBuilder: ContactTab.$_createMessage)
    ..aE<ContactTabType>(3, _omitFieldNames ? '' : 'currentTab',
        enumValues: ContactTabType.values)
    ..aOM<PaginationParams>(4, _omitFieldNames ? '' : 'paginationParams',
        subBuilder: PaginationParams.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsReply copyWith(void Function(ContactsReply) updates) =>
      super.copyWith((message) => updates(message as ContactsReply))
          as ContactsReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ContactsReply() / ContactsReply.new instead')
  static ContactsReply create() => ContactsReply._();
  static $pb.GeneratedMessage $_createMessage() => ContactsReply._();
  @$core.override
  ContactsReply createEmptyInstance() => ContactsReply._();
  @$core.pragma('dart2js:noInline')
  static ContactsReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsReply>(
          ContactsReply.$_createMessage);
  static ContactsReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Contact> get contacts => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<ContactTab> get tab => $_getList(1);

  @$pb.TagNumber(3)
  ContactTabType get currentTab => $_getN(2);
  @$pb.TagNumber(3)
  set currentTab(ContactTabType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCurrentTab() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrentTab() => $_clearField(3);

  @$pb.TagNumber(4)
  PaginationParams get paginationParams => $_getN(3);
  @$pb.TagNumber(4)
  set paginationParams(PaginationParams value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPaginationParams() => $_has(3);
  @$pb.TagNumber(4)
  void clearPaginationParams() => $_clearField(4);
  @$pb.TagNumber(4)
  PaginationParams ensurePaginationParams() => $_ensure(3);
}

class ContactsReq extends $pb.GeneratedMessage {
  factory ContactsReq({
    ContactTabType? tab,
    PaginationParams? paginationParams,
  }) {
    final result = ContactsReq._();
    if (tab != null) result.tab = tab;
    if (paginationParams != null) result.paginationParams = paginationParams;
    return result;
  }

  ContactsReq._();

  factory ContactsReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContactsReq()..mergeFromBuffer(data, registry);
  factory ContactsReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContactsReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContactsReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: ContactsReq.$_createMessage)
    ..aE<ContactTabType>(1, _omitFieldNames ? '' : 'tab',
        enumValues: ContactTabType.values)
    ..aOM<PaginationParams>(2, _omitFieldNames ? '' : 'paginationParams',
        subBuilder: PaginationParams.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsReq copyWith(void Function(ContactsReq) updates) =>
      super.copyWith((message) => updates(message as ContactsReq))
          as ContactsReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ContactsReq() / ContactsReq.new instead')
  static ContactsReq create() => ContactsReq._();
  static $pb.GeneratedMessage $_createMessage() => ContactsReq._();
  @$core.override
  ContactsReq createEmptyInstance() => ContactsReq._();
  @$core.pragma('dart2js:noInline')
  static ContactsReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsReq>(
          ContactsReq.$_createMessage);
  static ContactsReq? _defaultInstance;

  @$pb.TagNumber(1)
  ContactTabType get tab => $_getN(0);
  @$pb.TagNumber(1)
  set tab(ContactTabType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTab() => $_has(0);
  @$pb.TagNumber(1)
  void clearTab() => $_clearField(1);

  @$pb.TagNumber(2)
  PaginationParams get paginationParams => $_getN(1);
  @$pb.TagNumber(2)
  set paginationParams(PaginationParams value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPaginationParams() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaginationParams() => $_clearField(2);
  @$pb.TagNumber(2)
  PaginationParams ensurePaginationParams() => $_ensure(1);
}

class ContactsSearchReply extends $pb.GeneratedMessage {
  factory ContactsSearchReply({
    $core.Iterable<Contact>? contacts,
    PaginationParams? paginationParams,
  }) {
    final result = ContactsSearchReply._();
    if (contacts != null) result.contacts.addAll(contacts);
    if (paginationParams != null) result.paginationParams = paginationParams;
    return result;
  }

  ContactsSearchReply._();

  factory ContactsSearchReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContactsSearchReply()..mergeFromBuffer(data, registry);
  factory ContactsSearchReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContactsSearchReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContactsSearchReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: ContactsSearchReply.$_createMessage)
    ..pPM<Contact>(1, _omitFieldNames ? '' : 'contacts',
        subBuilder: Contact.$_createMessage)
    ..aOM<PaginationParams>(2, _omitFieldNames ? '' : 'paginationParams',
        subBuilder: PaginationParams.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsSearchReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsSearchReply copyWith(void Function(ContactsSearchReply) updates) =>
      super.copyWith((message) => updates(message as ContactsSearchReply))
          as ContactsSearchReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ContactsSearchReply() / ContactsSearchReply.new instead')
  static ContactsSearchReply create() => ContactsSearchReply._();
  static $pb.GeneratedMessage $_createMessage() => ContactsSearchReply._();
  @$core.override
  ContactsSearchReply createEmptyInstance() => ContactsSearchReply._();
  @$core.pragma('dart2js:noInline')
  static ContactsSearchReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContactsSearchReply>(
          ContactsSearchReply.$_createMessage);
  static ContactsSearchReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Contact> get contacts => $_getList(0);

  @$pb.TagNumber(2)
  PaginationParams get paginationParams => $_getN(1);
  @$pb.TagNumber(2)
  set paginationParams(PaginationParams value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPaginationParams() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaginationParams() => $_clearField(2);
  @$pb.TagNumber(2)
  PaginationParams ensurePaginationParams() => $_ensure(1);
}

class ContactsSearchReq extends $pb.GeneratedMessage {
  factory ContactsSearchReq({
    $core.String? keyword,
    ContactTabType? tab,
    PaginationParams? paginationParams,
  }) {
    final result = ContactsSearchReq._();
    if (keyword != null) result.keyword = keyword;
    if (tab != null) result.tab = tab;
    if (paginationParams != null) result.paginationParams = paginationParams;
    return result;
  }

  ContactsSearchReq._();

  factory ContactsSearchReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContactsSearchReq()..mergeFromBuffer(data, registry);
  factory ContactsSearchReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContactsSearchReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContactsSearchReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: ContactsSearchReq.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..aE<ContactTabType>(2, _omitFieldNames ? '' : 'tab',
        enumValues: ContactTabType.values)
    ..aOM<PaginationParams>(3, _omitFieldNames ? '' : 'paginationParams',
        subBuilder: PaginationParams.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsSearchReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactsSearchReq copyWith(void Function(ContactsSearchReq) updates) =>
      super.copyWith((message) => updates(message as ContactsSearchReq))
          as ContactsSearchReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ContactsSearchReq() / ContactsSearchReq.new instead')
  static ContactsSearchReq create() => ContactsSearchReq._();
  static $pb.GeneratedMessage $_createMessage() => ContactsSearchReq._();
  @$core.override
  ContactsSearchReq createEmptyInstance() => ContactsSearchReq._();
  @$core.pragma('dart2js:noInline')
  static ContactsSearchReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactsSearchReq>(
          ContactsSearchReq.$_createMessage);
  static ContactsSearchReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);

  @$pb.TagNumber(2)
  ContactTabType get tab => $_getN(1);
  @$pb.TagNumber(2)
  set tab(ContactTabType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTab() => $_has(1);
  @$pb.TagNumber(2)
  void clearTab() => $_clearField(2);

  @$pb.TagNumber(3)
  PaginationParams get paginationParams => $_getN(2);
  @$pb.TagNumber(3)
  set paginationParams(PaginationParams value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPaginationParams() => $_has(2);
  @$pb.TagNumber(3)
  void clearPaginationParams() => $_clearField(3);
  @$pb.TagNumber(3)
  PaginationParams ensurePaginationParams() => $_ensure(2);
}

class CustomerId extends $pb.GeneratedMessage {
  factory CustomerId({
    $fixnum.Int64? shopId,
    $fixnum.Int64? shopType,
  }) {
    final result = CustomerId._();
    if (shopId != null) result.shopId = shopId;
    if (shopType != null) result.shopType = shopType;
    return result;
  }

  CustomerId._();

  factory CustomerId.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CustomerId()..mergeFromBuffer(data, registry);
  factory CustomerId.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CustomerId()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CustomerId',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: CustomerId.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'shopId')
    ..aInt64(2, _omitFieldNames ? '' : 'shopType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CustomerId clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CustomerId copyWith(void Function(CustomerId) updates) =>
      super.copyWith((message) => updates(message as CustomerId)) as CustomerId;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CustomerId() / CustomerId.new instead')
  static CustomerId create() => CustomerId._();
  static $pb.GeneratedMessage $_createMessage() => CustomerId._();
  @$core.override
  CustomerId createEmptyInstance() => CustomerId._();
  @$core.pragma('dart2js:noInline')
  static CustomerId getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CustomerId>(CustomerId.$_createMessage);
  static CustomerId? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get shopId => $_getI64(0);
  @$pb.TagNumber(1)
  set shopId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShopId() => $_has(0);
  @$pb.TagNumber(1)
  void clearShopId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get shopType => $_getI64(1);
  @$pb.TagNumber(2)
  set shopType($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShopType() => $_has(1);
  @$pb.TagNumber(2)
  void clearShopType() => $_clearField(2);
}

class DeleteSessionListReply extends $pb.GeneratedMessage {
  factory DeleteSessionListReply() => DeleteSessionListReply._();

  DeleteSessionListReply._();

  factory DeleteSessionListReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteSessionListReply()..mergeFromBuffer(data, registry);
  factory DeleteSessionListReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteSessionListReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteSessionListReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: DeleteSessionListReply.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteSessionListReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteSessionListReply copyWith(
          void Function(DeleteSessionListReply) updates) =>
      super.copyWith((message) => updates(message as DeleteSessionListReply))
          as DeleteSessionListReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteSessionListReply() / DeleteSessionListReply.new instead')
  static DeleteSessionListReply create() => DeleteSessionListReply._();
  static $pb.GeneratedMessage $_createMessage() => DeleteSessionListReply._();
  @$core.override
  DeleteSessionListReply createEmptyInstance() => DeleteSessionListReply._();
  @$core.pragma('dart2js:noInline')
  static DeleteSessionListReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteSessionListReply>(
          DeleteSessionListReply.$_createMessage);
  static DeleteSessionListReply? _defaultInstance;
}

class DeleteSessionListReq extends $pb.GeneratedMessage {
  factory DeleteSessionListReq({
    SessionPageType? pageType,
  }) {
    final result = DeleteSessionListReq._();
    if (pageType != null) result.pageType = pageType;
    return result;
  }

  DeleteSessionListReq._();

  factory DeleteSessionListReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteSessionListReq()..mergeFromBuffer(data, registry);
  factory DeleteSessionListReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteSessionListReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteSessionListReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: DeleteSessionListReq.$_createMessage)
    ..aE<SessionPageType>(1, _omitFieldNames ? '' : 'pageType',
        enumValues: SessionPageType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteSessionListReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteSessionListReq copyWith(void Function(DeleteSessionListReq) updates) =>
      super.copyWith((message) => updates(message as DeleteSessionListReq))
          as DeleteSessionListReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteSessionListReq() / DeleteSessionListReq.new instead')
  static DeleteSessionListReq create() => DeleteSessionListReq._();
  static $pb.GeneratedMessage $_createMessage() => DeleteSessionListReq._();
  @$core.override
  DeleteSessionListReq createEmptyInstance() => DeleteSessionListReq._();
  @$core.pragma('dart2js:noInline')
  static DeleteSessionListReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteSessionListReq>(
          DeleteSessionListReq.$_createMessage);
  static DeleteSessionListReq? _defaultInstance;

  @$pb.TagNumber(1)
  SessionPageType get pageType => $_getN(0);
  @$pb.TagNumber(1)
  set pageType(SessionPageType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPageType() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageType() => $_clearField(1);
}

class DeleteSessionReply extends $pb.GeneratedMessage {
  factory DeleteSessionReply() => DeleteSessionReply._();

  DeleteSessionReply._();

  factory DeleteSessionReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteSessionReply()..mergeFromBuffer(data, registry);
  factory DeleteSessionReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteSessionReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteSessionReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: DeleteSessionReply.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteSessionReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteSessionReply copyWith(void Function(DeleteSessionReply) updates) =>
      super.copyWith((message) => updates(message as DeleteSessionReply))
          as DeleteSessionReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DeleteSessionReply() / DeleteSessionReply.new instead')
  static DeleteSessionReply create() => DeleteSessionReply._();
  static $pb.GeneratedMessage $_createMessage() => DeleteSessionReply._();
  @$core.override
  DeleteSessionReply createEmptyInstance() => DeleteSessionReply._();
  @$core.pragma('dart2js:noInline')
  static DeleteSessionReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteSessionReply>(
          DeleteSessionReply.$_createMessage);
  static DeleteSessionReply? _defaultInstance;
}

class DeleteSessionReq extends $pb.GeneratedMessage {
  factory DeleteSessionReq({
    SessionId? sessionId,
  }) {
    final result = DeleteSessionReq._();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  DeleteSessionReq._();

  factory DeleteSessionReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteSessionReq()..mergeFromBuffer(data, registry);
  factory DeleteSessionReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteSessionReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteSessionReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: DeleteSessionReq.$_createMessage)
    ..aOM<SessionId>(1, _omitFieldNames ? '' : 'sessionId',
        subBuilder: SessionId.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteSessionReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteSessionReq copyWith(void Function(DeleteSessionReq) updates) =>
      super.copyWith((message) => updates(message as DeleteSessionReq))
          as DeleteSessionReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DeleteSessionReq() / DeleteSessionReq.new instead')
  static DeleteSessionReq create() => DeleteSessionReq._();
  static $pb.GeneratedMessage $_createMessage() => DeleteSessionReq._();
  @$core.override
  DeleteSessionReq createEmptyInstance() => DeleteSessionReq._();
  @$core.pragma('dart2js:noInline')
  static DeleteSessionReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteSessionReq>(
          DeleteSessionReq.$_createMessage);
  static DeleteSessionReq? _defaultInstance;

  @$pb.TagNumber(1)
  SessionId get sessionId => $_getN(0);
  @$pb.TagNumber(1)
  set sessionId(SessionId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
  @$pb.TagNumber(1)
  SessionId ensureSessionId() => $_ensure(0);
}

class FilledLabel extends $pb.GeneratedMessage {
  factory FilledLabel({
    $core.String? text,
  }) {
    final result = FilledLabel._();
    if (text != null) result.text = text;
    return result;
  }

  FilledLabel._();

  factory FilledLabel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FilledLabel()..mergeFromBuffer(data, registry);
  factory FilledLabel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FilledLabel()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FilledLabel',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: FilledLabel.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FilledLabel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FilledLabel copyWith(void Function(FilledLabel) updates) =>
      super.copyWith((message) => updates(message as FilledLabel))
          as FilledLabel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FilledLabel() / FilledLabel.new instead')
  static FilledLabel create() => FilledLabel._();
  static $pb.GeneratedMessage $_createMessage() => FilledLabel._();
  @$core.override
  FilledLabel createEmptyInstance() => FilledLabel._();
  @$core.pragma('dart2js:noInline')
  static FilledLabel getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FilledLabel>(
          FilledLabel.$_createMessage);
  static FilledLabel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);
}

class FilterConfig extends $pb.GeneratedMessage {
  factory FilterConfig({
    $core.Iterable<SessionsFilter>? filters,
    SessionFilterType? currentFilter,
  }) {
    final result = FilterConfig._();
    if (filters != null) result.filters.addAll(filters);
    if (currentFilter != null) result.currentFilter = currentFilter;
    return result;
  }

  FilterConfig._();

  factory FilterConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FilterConfig()..mergeFromBuffer(data, registry);
  factory FilterConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FilterConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FilterConfig',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: FilterConfig.$_createMessage)
    ..pPM<SessionsFilter>(1, _omitFieldNames ? '' : 'filters',
        subBuilder: SessionsFilter.$_createMessage)
    ..aE<SessionFilterType>(2, _omitFieldNames ? '' : 'currentFilter',
        enumValues: SessionFilterType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FilterConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FilterConfig copyWith(void Function(FilterConfig) updates) =>
      super.copyWith((message) => updates(message as FilterConfig))
          as FilterConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FilterConfig() / FilterConfig.new instead')
  static FilterConfig create() => FilterConfig._();
  static $pb.GeneratedMessage $_createMessage() => FilterConfig._();
  @$core.override
  FilterConfig createEmptyInstance() => FilterConfig._();
  @$core.pragma('dart2js:noInline')
  static FilterConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FilterConfig>(
          FilterConfig.$_createMessage);
  static FilterConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SessionsFilter> get filters => $_getList(0);

  @$pb.TagNumber(2)
  SessionFilterType get currentFilter => $_getN(1);
  @$pb.TagNumber(2)
  set currentFilter(SessionFilterType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrentFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentFilter() => $_clearField(2);
}

class FoldId extends $pb.GeneratedMessage {
  factory FoldId({
    SessionType? type,
  }) {
    final result = FoldId._();
    if (type != null) result.type = type;
    return result;
  }

  FoldId._();

  factory FoldId.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FoldId()..mergeFromBuffer(data, registry);
  factory FoldId.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FoldId()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FoldId',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: FoldId.$_createMessage)
    ..aE<SessionType>(1, _omitFieldNames ? '' : 'type',
        enumValues: SessionType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FoldId clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FoldId copyWith(void Function(FoldId) updates) =>
      super.copyWith((message) => updates(message as FoldId)) as FoldId;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FoldId() / FoldId.new instead')
  static FoldId create() => FoldId._();
  static $pb.GeneratedMessage $_createMessage() => FoldId._();
  @$core.override
  FoldId createEmptyInstance() => FoldId._();
  @$core.pragma('dart2js:noInline')
  static FoldId getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FoldId>(FoldId.$_createMessage);
  static FoldId? _defaultInstance;

  @$pb.TagNumber(1)
  SessionType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(SessionType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);
}

class GetImSettingsReply extends $pb.GeneratedMessage {
  factory GetImSettingsReply({
    $core.String? pageTitle,
    $core.Iterable<$core.MapEntry<$core.int, Setting>>? settings,
  }) {
    final result = GetImSettingsReply._();
    if (pageTitle != null) result.pageTitle = pageTitle;
    if (settings != null) result.settings.addEntries(settings);
    return result;
  }

  GetImSettingsReply._();

  factory GetImSettingsReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetImSettingsReply()..mergeFromBuffer(data, registry);
  factory GetImSettingsReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetImSettingsReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetImSettingsReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: GetImSettingsReply.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'pageTitle')
    ..m<$core.int, Setting>(2, _omitFieldNames ? '' : 'settings',
        entryClassName: 'GetImSettingsReply.SettingsEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: Setting.$_createMessage,
        valueDefaultOrMaker: Setting.getDefault,
        packageName: const $pb.PackageName('bilibili.app.im.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetImSettingsReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetImSettingsReply copyWith(void Function(GetImSettingsReply) updates) =>
      super.copyWith((message) => updates(message as GetImSettingsReply))
          as GetImSettingsReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetImSettingsReply() / GetImSettingsReply.new instead')
  static GetImSettingsReply create() => GetImSettingsReply._();
  static $pb.GeneratedMessage $_createMessage() => GetImSettingsReply._();
  @$core.override
  GetImSettingsReply createEmptyInstance() => GetImSettingsReply._();
  @$core.pragma('dart2js:noInline')
  static GetImSettingsReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetImSettingsReply>(
          GetImSettingsReply.$_createMessage);
  static GetImSettingsReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pageTitle => $_getSZ(0);
  @$pb.TagNumber(1)
  set pageTitle($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.int, Setting> get settings => $_getMap(1);
}

class GetImSettingsReq extends $pb.GeneratedMessage {
  factory GetImSettingsReq({
    IMSettingType? type,
  }) {
    final result = GetImSettingsReq._();
    if (type != null) result.type = type;
    return result;
  }

  GetImSettingsReq._();

  factory GetImSettingsReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetImSettingsReq()..mergeFromBuffer(data, registry);
  factory GetImSettingsReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetImSettingsReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetImSettingsReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: GetImSettingsReq.$_createMessage)
    ..aE<IMSettingType>(1, _omitFieldNames ? '' : 'type',
        enumValues: IMSettingType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetImSettingsReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetImSettingsReq copyWith(void Function(GetImSettingsReq) updates) =>
      super.copyWith((message) => updates(message as GetImSettingsReq))
          as GetImSettingsReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetImSettingsReq() / GetImSettingsReq.new instead')
  static GetImSettingsReq create() => GetImSettingsReq._();
  static $pb.GeneratedMessage $_createMessage() => GetImSettingsReq._();
  @$core.override
  GetImSettingsReq createEmptyInstance() => GetImSettingsReq._();
  @$core.pragma('dart2js:noInline')
  static GetImSettingsReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetImSettingsReq>(
          GetImSettingsReq.$_createMessage);
  static GetImSettingsReq? _defaultInstance;

  @$pb.TagNumber(1)
  IMSettingType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(IMSettingType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);
}

class GetQuickLinkUnreadReply extends $pb.GeneratedMessage {
  factory GetQuickLinkUnreadReply({
    $core.Iterable<QuickLinkUnreadItem>? items,
  }) {
    final result = GetQuickLinkUnreadReply._();
    if (items != null) result.items.addAll(items);
    return result;
  }

  GetQuickLinkUnreadReply._();

  factory GetQuickLinkUnreadReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetQuickLinkUnreadReply()..mergeFromBuffer(data, registry);
  factory GetQuickLinkUnreadReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetQuickLinkUnreadReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetQuickLinkUnreadReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: GetQuickLinkUnreadReply.$_createMessage)
    ..pPM<QuickLinkUnreadItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: QuickLinkUnreadItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetQuickLinkUnreadReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetQuickLinkUnreadReply copyWith(
          void Function(GetQuickLinkUnreadReply) updates) =>
      super.copyWith((message) => updates(message as GetQuickLinkUnreadReply))
          as GetQuickLinkUnreadReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetQuickLinkUnreadReply() / GetQuickLinkUnreadReply.new instead')
  static GetQuickLinkUnreadReply create() => GetQuickLinkUnreadReply._();
  static $pb.GeneratedMessage $_createMessage() => GetQuickLinkUnreadReply._();
  @$core.override
  GetQuickLinkUnreadReply createEmptyInstance() => GetQuickLinkUnreadReply._();
  @$core.pragma('dart2js:noInline')
  static GetQuickLinkUnreadReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetQuickLinkUnreadReply>(
          GetQuickLinkUnreadReply.$_createMessage);
  static GetQuickLinkUnreadReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<QuickLinkUnreadItem> get items => $_getList(0);
}

class GetQuickLinkUnreadReq extends $pb.GeneratedMessage {
  factory GetQuickLinkUnreadReq() => GetQuickLinkUnreadReq._();

  GetQuickLinkUnreadReq._();

  factory GetQuickLinkUnreadReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetQuickLinkUnreadReq()..mergeFromBuffer(data, registry);
  factory GetQuickLinkUnreadReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetQuickLinkUnreadReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetQuickLinkUnreadReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: GetQuickLinkUnreadReq.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetQuickLinkUnreadReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetQuickLinkUnreadReq copyWith(
          void Function(GetQuickLinkUnreadReq) updates) =>
      super.copyWith((message) => updates(message as GetQuickLinkUnreadReq))
          as GetQuickLinkUnreadReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetQuickLinkUnreadReq() / GetQuickLinkUnreadReq.new instead')
  static GetQuickLinkUnreadReq create() => GetQuickLinkUnreadReq._();
  static $pb.GeneratedMessage $_createMessage() => GetQuickLinkUnreadReq._();
  @$core.override
  GetQuickLinkUnreadReq createEmptyInstance() => GetQuickLinkUnreadReq._();
  @$core.pragma('dart2js:noInline')
  static GetQuickLinkUnreadReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetQuickLinkUnreadReq>(
          GetQuickLinkUnreadReq.$_createMessage);
  static GetQuickLinkUnreadReq? _defaultInstance;
}

class GetTotalUnreadReply extends $pb.GeneratedMessage {
  factory GetTotalUnreadReply({
    Unread? total,
  }) {
    final result = GetTotalUnreadReply._();
    if (total != null) result.total = total;
    return result;
  }

  GetTotalUnreadReply._();

  factory GetTotalUnreadReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTotalUnreadReply()..mergeFromBuffer(data, registry);
  factory GetTotalUnreadReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTotalUnreadReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTotalUnreadReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: GetTotalUnreadReply.$_createMessage)
    ..aOM<Unread>(1, _omitFieldNames ? '' : 'total',
        subBuilder: Unread.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTotalUnreadReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTotalUnreadReply copyWith(void Function(GetTotalUnreadReply) updates) =>
      super.copyWith((message) => updates(message as GetTotalUnreadReply))
          as GetTotalUnreadReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetTotalUnreadReply() / GetTotalUnreadReply.new instead')
  static GetTotalUnreadReply create() => GetTotalUnreadReply._();
  static $pb.GeneratedMessage $_createMessage() => GetTotalUnreadReply._();
  @$core.override
  GetTotalUnreadReply createEmptyInstance() => GetTotalUnreadReply._();
  @$core.pragma('dart2js:noInline')
  static GetTotalUnreadReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTotalUnreadReply>(
          GetTotalUnreadReply.$_createMessage);
  static GetTotalUnreadReply? _defaultInstance;

  @$pb.TagNumber(1)
  Unread get total => $_getN(0);
  @$pb.TagNumber(1)
  set total(Unread value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);
  @$pb.TagNumber(1)
  Unread ensureTotal() => $_ensure(0);
}

class GetTotalUnreadReq extends $pb.GeneratedMessage {
  factory GetTotalUnreadReq() => GetTotalUnreadReq._();

  GetTotalUnreadReq._();

  factory GetTotalUnreadReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTotalUnreadReq()..mergeFromBuffer(data, registry);
  factory GetTotalUnreadReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTotalUnreadReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTotalUnreadReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: GetTotalUnreadReq.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTotalUnreadReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTotalUnreadReq copyWith(void Function(GetTotalUnreadReq) updates) =>
      super.copyWith((message) => updates(message as GetTotalUnreadReq))
          as GetTotalUnreadReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetTotalUnreadReq() / GetTotalUnreadReq.new instead')
  static GetTotalUnreadReq create() => GetTotalUnreadReq._();
  static $pb.GeneratedMessage $_createMessage() => GetTotalUnreadReq._();
  @$core.override
  GetTotalUnreadReq createEmptyInstance() => GetTotalUnreadReq._();
  @$core.pragma('dart2js:noInline')
  static GetTotalUnreadReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetTotalUnreadReq>(
          GetTotalUnreadReq.$_createMessage);
  static GetTotalUnreadReq? _defaultInstance;
}

class GroupId extends $pb.GeneratedMessage {
  factory GroupId({
    $fixnum.Int64? groupId,
  }) {
    final result = GroupId._();
    if (groupId != null) result.groupId = groupId;
    return result;
  }

  GroupId._();

  factory GroupId.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GroupId()..mergeFromBuffer(data, registry);
  factory GroupId.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GroupId()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupId',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: GroupId.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'groupId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupId clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupId copyWith(void Function(GroupId) updates) =>
      super.copyWith((message) => updates(message as GroupId)) as GroupId;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GroupId() / GroupId.new instead')
  static GroupId create() => GroupId._();
  static $pb.GeneratedMessage $_createMessage() => GroupId._();
  @$core.override
  GroupId createEmptyInstance() => GroupId._();
  @$core.pragma('dart2js:noInline')
  static GroupId getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupId>(GroupId.$_createMessage);
  static GroupId? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get groupId => $_getI64(0);
  @$pb.TagNumber(1)
  set groupId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGroupId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupId() => $_clearField(1);
}

class ImageLabel extends $pb.GeneratedMessage {
  factory ImageLabel({
    $core.String? url,
    $core.int? width,
    $core.int? height,
  }) {
    final result = ImageLabel._();
    if (url != null) result.url = url;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    return result;
  }

  ImageLabel._();

  factory ImageLabel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImageLabel()..mergeFromBuffer(data, registry);
  factory ImageLabel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImageLabel()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImageLabel',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: ImageLabel.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aI(2, _omitFieldNames ? '' : 'width')
    ..aI(3, _omitFieldNames ? '' : 'height')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImageLabel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImageLabel copyWith(void Function(ImageLabel) updates) =>
      super.copyWith((message) => updates(message as ImageLabel)) as ImageLabel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ImageLabel() / ImageLabel.new instead')
  static ImageLabel create() => ImageLabel._();
  static $pb.GeneratedMessage $_createMessage() => ImageLabel._();
  @$core.override
  ImageLabel createEmptyInstance() => ImageLabel._();
  @$core.pragma('dart2js:noInline')
  static ImageLabel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ImageLabel>(ImageLabel.$_createMessage);
  static ImageLabel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get width => $_getIZ(1);
  @$pb.TagNumber(2)
  set width($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWidth() => $_has(1);
  @$pb.TagNumber(2)
  void clearWidth() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get height => $_getIZ(2);
  @$pb.TagNumber(3)
  set height($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearHeight() => $_clearField(3);
}

class KeywordBlockingAddReply extends $pb.GeneratedMessage {
  factory KeywordBlockingAddReply({
    $core.String? toast,
    KeywordBlockingItem? item,
  }) {
    final result = KeywordBlockingAddReply._();
    if (toast != null) result.toast = toast;
    if (item != null) result.item = item;
    return result;
  }

  KeywordBlockingAddReply._();

  factory KeywordBlockingAddReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KeywordBlockingAddReply()..mergeFromBuffer(data, registry);
  factory KeywordBlockingAddReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KeywordBlockingAddReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KeywordBlockingAddReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: KeywordBlockingAddReply.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'toast')
    ..aOM<KeywordBlockingItem>(2, _omitFieldNames ? '' : 'item',
        subBuilder: KeywordBlockingItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeywordBlockingAddReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeywordBlockingAddReply copyWith(
          void Function(KeywordBlockingAddReply) updates) =>
      super.copyWith((message) => updates(message as KeywordBlockingAddReply))
          as KeywordBlockingAddReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use KeywordBlockingAddReply() / KeywordBlockingAddReply.new instead')
  static KeywordBlockingAddReply create() => KeywordBlockingAddReply._();
  static $pb.GeneratedMessage $_createMessage() => KeywordBlockingAddReply._();
  @$core.override
  KeywordBlockingAddReply createEmptyInstance() => KeywordBlockingAddReply._();
  @$core.pragma('dart2js:noInline')
  static KeywordBlockingAddReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KeywordBlockingAddReply>(
          KeywordBlockingAddReply.$_createMessage);
  static KeywordBlockingAddReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get toast => $_getSZ(0);
  @$pb.TagNumber(1)
  set toast($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToast() => $_has(0);
  @$pb.TagNumber(1)
  void clearToast() => $_clearField(1);

  @$pb.TagNumber(2)
  KeywordBlockingItem get item => $_getN(1);
  @$pb.TagNumber(2)
  set item(KeywordBlockingItem value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasItem() => $_has(1);
  @$pb.TagNumber(2)
  void clearItem() => $_clearField(2);
  @$pb.TagNumber(2)
  KeywordBlockingItem ensureItem() => $_ensure(1);
}

class KeywordBlockingAddReq extends $pb.GeneratedMessage {
  factory KeywordBlockingAddReq({
    $core.String? keyword,
  }) {
    final result = KeywordBlockingAddReq._();
    if (keyword != null) result.keyword = keyword;
    return result;
  }

  KeywordBlockingAddReq._();

  factory KeywordBlockingAddReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KeywordBlockingAddReq()..mergeFromBuffer(data, registry);
  factory KeywordBlockingAddReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KeywordBlockingAddReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KeywordBlockingAddReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: KeywordBlockingAddReq.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeywordBlockingAddReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeywordBlockingAddReq copyWith(
          void Function(KeywordBlockingAddReq) updates) =>
      super.copyWith((message) => updates(message as KeywordBlockingAddReq))
          as KeywordBlockingAddReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use KeywordBlockingAddReq() / KeywordBlockingAddReq.new instead')
  static KeywordBlockingAddReq create() => KeywordBlockingAddReq._();
  static $pb.GeneratedMessage $_createMessage() => KeywordBlockingAddReq._();
  @$core.override
  KeywordBlockingAddReq createEmptyInstance() => KeywordBlockingAddReq._();
  @$core.pragma('dart2js:noInline')
  static KeywordBlockingAddReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KeywordBlockingAddReq>(
          KeywordBlockingAddReq.$_createMessage);
  static KeywordBlockingAddReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);
}

class KeywordBlockingDeleteReply extends $pb.GeneratedMessage {
  factory KeywordBlockingDeleteReply({
    $core.String? toast,
  }) {
    final result = KeywordBlockingDeleteReply._();
    if (toast != null) result.toast = toast;
    return result;
  }

  KeywordBlockingDeleteReply._();

  factory KeywordBlockingDeleteReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KeywordBlockingDeleteReply()..mergeFromBuffer(data, registry);
  factory KeywordBlockingDeleteReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KeywordBlockingDeleteReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KeywordBlockingDeleteReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: KeywordBlockingDeleteReply.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'toast')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeywordBlockingDeleteReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeywordBlockingDeleteReply copyWith(
          void Function(KeywordBlockingDeleteReply) updates) =>
      super.copyWith(
              (message) => updates(message as KeywordBlockingDeleteReply))
          as KeywordBlockingDeleteReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use KeywordBlockingDeleteReply() / KeywordBlockingDeleteReply.new instead')
  static KeywordBlockingDeleteReply create() => KeywordBlockingDeleteReply._();
  static $pb.GeneratedMessage $_createMessage() =>
      KeywordBlockingDeleteReply._();
  @$core.override
  KeywordBlockingDeleteReply createEmptyInstance() =>
      KeywordBlockingDeleteReply._();
  @$core.pragma('dart2js:noInline')
  static KeywordBlockingDeleteReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KeywordBlockingDeleteReply>(
          KeywordBlockingDeleteReply.$_createMessage);
  static KeywordBlockingDeleteReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get toast => $_getSZ(0);
  @$pb.TagNumber(1)
  set toast($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToast() => $_has(0);
  @$pb.TagNumber(1)
  void clearToast() => $_clearField(1);
}

class KeywordBlockingDeleteReq extends $pb.GeneratedMessage {
  factory KeywordBlockingDeleteReq({
    $core.String? keyword,
  }) {
    final result = KeywordBlockingDeleteReq._();
    if (keyword != null) result.keyword = keyword;
    return result;
  }

  KeywordBlockingDeleteReq._();

  factory KeywordBlockingDeleteReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KeywordBlockingDeleteReq()..mergeFromBuffer(data, registry);
  factory KeywordBlockingDeleteReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KeywordBlockingDeleteReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KeywordBlockingDeleteReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: KeywordBlockingDeleteReq.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeywordBlockingDeleteReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeywordBlockingDeleteReq copyWith(
          void Function(KeywordBlockingDeleteReq) updates) =>
      super.copyWith((message) => updates(message as KeywordBlockingDeleteReq))
          as KeywordBlockingDeleteReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use KeywordBlockingDeleteReq() / KeywordBlockingDeleteReq.new instead')
  static KeywordBlockingDeleteReq create() => KeywordBlockingDeleteReq._();
  static $pb.GeneratedMessage $_createMessage() => KeywordBlockingDeleteReq._();
  @$core.override
  KeywordBlockingDeleteReq createEmptyInstance() =>
      KeywordBlockingDeleteReq._();
  @$core.pragma('dart2js:noInline')
  static KeywordBlockingDeleteReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KeywordBlockingDeleteReq>(
          KeywordBlockingDeleteReq.$_createMessage);
  static KeywordBlockingDeleteReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);
}

class KeywordBlockingItem extends $pb.GeneratedMessage {
  factory KeywordBlockingItem({
    $core.String? keyword,
  }) {
    final result = KeywordBlockingItem._();
    if (keyword != null) result.keyword = keyword;
    return result;
  }

  KeywordBlockingItem._();

  factory KeywordBlockingItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KeywordBlockingItem()..mergeFromBuffer(data, registry);
  factory KeywordBlockingItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KeywordBlockingItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KeywordBlockingItem',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: KeywordBlockingItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeywordBlockingItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeywordBlockingItem copyWith(void Function(KeywordBlockingItem) updates) =>
      super.copyWith((message) => updates(message as KeywordBlockingItem))
          as KeywordBlockingItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use KeywordBlockingItem() / KeywordBlockingItem.new instead')
  static KeywordBlockingItem create() => KeywordBlockingItem._();
  static $pb.GeneratedMessage $_createMessage() => KeywordBlockingItem._();
  @$core.override
  KeywordBlockingItem createEmptyInstance() => KeywordBlockingItem._();
  @$core.pragma('dart2js:noInline')
  static KeywordBlockingItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KeywordBlockingItem>(
          KeywordBlockingItem.$_createMessage);
  static KeywordBlockingItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);
}

class KeywordBlockingListReply extends $pb.GeneratedMessage {
  factory KeywordBlockingListReply({
    $core.Iterable<KeywordBlockingItem>? items,
    $core.int? listLimit,
    $core.int? charLimit,
    $core.String? listLimitText,
  }) {
    final result = KeywordBlockingListReply._();
    if (items != null) result.items.addAll(items);
    if (listLimit != null) result.listLimit = listLimit;
    if (charLimit != null) result.charLimit = charLimit;
    if (listLimitText != null) result.listLimitText = listLimitText;
    return result;
  }

  KeywordBlockingListReply._();

  factory KeywordBlockingListReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KeywordBlockingListReply()..mergeFromBuffer(data, registry);
  factory KeywordBlockingListReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KeywordBlockingListReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KeywordBlockingListReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: KeywordBlockingListReply.$_createMessage)
    ..pPM<KeywordBlockingItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: KeywordBlockingItem.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'listLimit')
    ..aI(3, _omitFieldNames ? '' : 'charLimit')
    ..aOS(4, _omitFieldNames ? '' : 'listLimitText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeywordBlockingListReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeywordBlockingListReply copyWith(
          void Function(KeywordBlockingListReply) updates) =>
      super.copyWith((message) => updates(message as KeywordBlockingListReply))
          as KeywordBlockingListReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use KeywordBlockingListReply() / KeywordBlockingListReply.new instead')
  static KeywordBlockingListReply create() => KeywordBlockingListReply._();
  static $pb.GeneratedMessage $_createMessage() => KeywordBlockingListReply._();
  @$core.override
  KeywordBlockingListReply createEmptyInstance() =>
      KeywordBlockingListReply._();
  @$core.pragma('dart2js:noInline')
  static KeywordBlockingListReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KeywordBlockingListReply>(
          KeywordBlockingListReply.$_createMessage);
  static KeywordBlockingListReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<KeywordBlockingItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get listLimit => $_getIZ(1);
  @$pb.TagNumber(2)
  set listLimit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasListLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearListLimit() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get charLimit => $_getIZ(2);
  @$pb.TagNumber(3)
  set charLimit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCharLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearCharLimit() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get listLimitText => $_getSZ(3);
  @$pb.TagNumber(4)
  set listLimitText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasListLimitText() => $_has(3);
  @$pb.TagNumber(4)
  void clearListLimitText() => $_clearField(4);
}

class KeywordBlockingListReq extends $pb.GeneratedMessage {
  factory KeywordBlockingListReq() => KeywordBlockingListReq._();

  KeywordBlockingListReq._();

  factory KeywordBlockingListReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KeywordBlockingListReq()..mergeFromBuffer(data, registry);
  factory KeywordBlockingListReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KeywordBlockingListReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KeywordBlockingListReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: KeywordBlockingListReq.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeywordBlockingListReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KeywordBlockingListReq copyWith(
          void Function(KeywordBlockingListReq) updates) =>
      super.copyWith((message) => updates(message as KeywordBlockingListReq))
          as KeywordBlockingListReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use KeywordBlockingListReq() / KeywordBlockingListReq.new instead')
  static KeywordBlockingListReq create() => KeywordBlockingListReq._();
  static $pb.GeneratedMessage $_createMessage() => KeywordBlockingListReq._();
  @$core.override
  KeywordBlockingListReq createEmptyInstance() => KeywordBlockingListReq._();
  @$core.pragma('dart2js:noInline')
  static KeywordBlockingListReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KeywordBlockingListReq>(
          KeywordBlockingListReq.$_createMessage);
  static KeywordBlockingListReq? _defaultInstance;
}

class Medal extends $pb.GeneratedMessage {
  factory Medal({
    $fixnum.Int64? uid,
    $core.int? medalId,
    $core.int? level,
    $core.String? medalName,
    $core.int? score,
    $core.int? intimacy,
    $core.int? masterStatus,
    $core.int? isReceive,
    $core.String? medalColorStart,
    $core.String? medalColorEnd,
    $core.String? medalColorBorder,
    $core.String? medalColorName,
    $core.String? medalColorLevel,
    $fixnum.Int64? guardLevel,
  }) {
    final result = Medal._();
    if (uid != null) result.uid = uid;
    if (medalId != null) result.medalId = medalId;
    if (level != null) result.level = level;
    if (medalName != null) result.medalName = medalName;
    if (score != null) result.score = score;
    if (intimacy != null) result.intimacy = intimacy;
    if (masterStatus != null) result.masterStatus = masterStatus;
    if (isReceive != null) result.isReceive = isReceive;
    if (medalColorStart != null) result.medalColorStart = medalColorStart;
    if (medalColorEnd != null) result.medalColorEnd = medalColorEnd;
    if (medalColorBorder != null) result.medalColorBorder = medalColorBorder;
    if (medalColorName != null) result.medalColorName = medalColorName;
    if (medalColorLevel != null) result.medalColorLevel = medalColorLevel;
    if (guardLevel != null) result.guardLevel = guardLevel;
    return result;
  }

  Medal._();

  factory Medal.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Medal()..mergeFromBuffer(data, registry);
  factory Medal.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Medal()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Medal',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: Medal.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'uid')
    ..aI(2, _omitFieldNames ? '' : 'medalId')
    ..aI(3, _omitFieldNames ? '' : 'level')
    ..aOS(4, _omitFieldNames ? '' : 'medalName')
    ..aI(5, _omitFieldNames ? '' : 'score')
    ..aI(6, _omitFieldNames ? '' : 'intimacy')
    ..aI(7, _omitFieldNames ? '' : 'masterStatus')
    ..aI(8, _omitFieldNames ? '' : 'isReceive')
    ..aOS(9, _omitFieldNames ? '' : 'medalColorStart')
    ..aOS(10, _omitFieldNames ? '' : 'medalColorEnd')
    ..aOS(11, _omitFieldNames ? '' : 'medalColorBorder')
    ..aOS(12, _omitFieldNames ? '' : 'medalColorName')
    ..aOS(13, _omitFieldNames ? '' : 'medalColorLevel')
    ..aInt64(14, _omitFieldNames ? '' : 'guardLevel')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Medal clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Medal copyWith(void Function(Medal) updates) =>
      super.copyWith((message) => updates(message as Medal)) as Medal;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Medal() / Medal.new instead')
  static Medal create() => Medal._();
  static $pb.GeneratedMessage $_createMessage() => Medal._();
  @$core.override
  Medal createEmptyInstance() => Medal._();
  @$core.pragma('dart2js:noInline')
  static Medal getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Medal>(Medal.$_createMessage);
  static Medal? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get uid => $_getI64(0);
  @$pb.TagNumber(1)
  set uid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get medalId => $_getIZ(1);
  @$pb.TagNumber(2)
  set medalId($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMedalId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMedalId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get level => $_getIZ(2);
  @$pb.TagNumber(3)
  set level($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLevel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLevel() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get medalName => $_getSZ(3);
  @$pb.TagNumber(4)
  set medalName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMedalName() => $_has(3);
  @$pb.TagNumber(4)
  void clearMedalName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get score => $_getIZ(4);
  @$pb.TagNumber(5)
  set score($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasScore() => $_has(4);
  @$pb.TagNumber(5)
  void clearScore() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get intimacy => $_getIZ(5);
  @$pb.TagNumber(6)
  set intimacy($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIntimacy() => $_has(5);
  @$pb.TagNumber(6)
  void clearIntimacy() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get masterStatus => $_getIZ(6);
  @$pb.TagNumber(7)
  set masterStatus($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMasterStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearMasterStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get isReceive => $_getIZ(7);
  @$pb.TagNumber(8)
  set isReceive($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsReceive() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsReceive() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get medalColorStart => $_getSZ(8);
  @$pb.TagNumber(9)
  set medalColorStart($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMedalColorStart() => $_has(8);
  @$pb.TagNumber(9)
  void clearMedalColorStart() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get medalColorEnd => $_getSZ(9);
  @$pb.TagNumber(10)
  set medalColorEnd($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMedalColorEnd() => $_has(9);
  @$pb.TagNumber(10)
  void clearMedalColorEnd() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get medalColorBorder => $_getSZ(10);
  @$pb.TagNumber(11)
  set medalColorBorder($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasMedalColorBorder() => $_has(10);
  @$pb.TagNumber(11)
  void clearMedalColorBorder() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get medalColorName => $_getSZ(11);
  @$pb.TagNumber(12)
  set medalColorName($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasMedalColorName() => $_has(11);
  @$pb.TagNumber(12)
  void clearMedalColorName() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get medalColorLevel => $_getSZ(12);
  @$pb.TagNumber(13)
  set medalColorLevel($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasMedalColorLevel() => $_has(12);
  @$pb.TagNumber(13)
  void clearMedalColorLevel() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get guardLevel => $_getI64(13);
  @$pb.TagNumber(14)
  set guardLevel($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasGuardLevel() => $_has(13);
  @$pb.TagNumber(14)
  void clearGuardLevel() => $_clearField(14);
}

class MsgSummary extends $pb.GeneratedMessage {
  factory MsgSummary({
    $core.String? rawMsg,
    MsgSummaryPrefixType? prefixType,
    $core.String? prefixText,
    $core.bool? isGroupOwner,
  }) {
    final result = MsgSummary._();
    if (rawMsg != null) result.rawMsg = rawMsg;
    if (prefixType != null) result.prefixType = prefixType;
    if (prefixText != null) result.prefixText = prefixText;
    if (isGroupOwner != null) result.isGroupOwner = isGroupOwner;
    return result;
  }

  MsgSummary._();

  factory MsgSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MsgSummary()..mergeFromBuffer(data, registry);
  factory MsgSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MsgSummary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MsgSummary',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: MsgSummary.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'rawMsg')
    ..aE<MsgSummaryPrefixType>(2, _omitFieldNames ? '' : 'prefixType',
        enumValues: MsgSummaryPrefixType.values)
    ..aOS(3, _omitFieldNames ? '' : 'prefixText')
    ..aOB(4, _omitFieldNames ? '' : 'isGroupOwner')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MsgSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MsgSummary copyWith(void Function(MsgSummary) updates) =>
      super.copyWith((message) => updates(message as MsgSummary)) as MsgSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MsgSummary() / MsgSummary.new instead')
  static MsgSummary create() => MsgSummary._();
  static $pb.GeneratedMessage $_createMessage() => MsgSummary._();
  @$core.override
  MsgSummary createEmptyInstance() => MsgSummary._();
  @$core.pragma('dart2js:noInline')
  static MsgSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MsgSummary>(MsgSummary.$_createMessage);
  static MsgSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get rawMsg => $_getSZ(0);
  @$pb.TagNumber(1)
  set rawMsg($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRawMsg() => $_has(0);
  @$pb.TagNumber(1)
  void clearRawMsg() => $_clearField(1);

  @$pb.TagNumber(2)
  MsgSummaryPrefixType get prefixType => $_getN(1);
  @$pb.TagNumber(2)
  set prefixType(MsgSummaryPrefixType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPrefixType() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrefixType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get prefixText => $_getSZ(2);
  @$pb.TagNumber(3)
  set prefixText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrefixText() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrefixText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isGroupOwner => $_getBF(3);
  @$pb.TagNumber(4)
  set isGroupOwner($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsGroupOwner() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsGroupOwner() => $_clearField(4);
}

class Offset extends $pb.GeneratedMessage {
  factory Offset({
    $fixnum.Int64? normalOffset,
    $fixnum.Int64? topOffset,
  }) {
    final result = Offset._();
    if (normalOffset != null) result.normalOffset = normalOffset;
    if (topOffset != null) result.topOffset = topOffset;
    return result;
  }

  Offset._();

  factory Offset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Offset()..mergeFromBuffer(data, registry);
  factory Offset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Offset()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Offset',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: Offset.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'normalOffset')
    ..aInt64(2, _omitFieldNames ? '' : 'topOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Offset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Offset copyWith(void Function(Offset) updates) =>
      super.copyWith((message) => updates(message as Offset)) as Offset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Offset() / Offset.new instead')
  static Offset create() => Offset._();
  static $pb.GeneratedMessage $_createMessage() => Offset._();
  @$core.override
  Offset createEmptyInstance() => Offset._();
  @$core.pragma('dart2js:noInline')
  static Offset getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Offset>(Offset.$_createMessage);
  static Offset? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get normalOffset => $_getI64(0);
  @$pb.TagNumber(1)
  set normalOffset($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNormalOffset() => $_has(0);
  @$pb.TagNumber(1)
  void clearNormalOffset() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get topOffset => $_getI64(1);
  @$pb.TagNumber(2)
  set topOffset($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTopOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearTopOffset() => $_clearField(2);
}

class OperationContent extends $pb.GeneratedMessage {
  factory OperationContent({
    $core.bool? show,
    $core.String? text,
  }) {
    final result = OperationContent._();
    if (show != null) result.show = show;
    if (text != null) result.text = text;
    return result;
  }

  OperationContent._();

  factory OperationContent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OperationContent()..mergeFromBuffer(data, registry);
  factory OperationContent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OperationContent()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OperationContent',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: OperationContent.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'show')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperationContent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperationContent copyWith(void Function(OperationContent) updates) =>
      super.copyWith((message) => updates(message as OperationContent))
          as OperationContent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OperationContent() / OperationContent.new instead')
  static OperationContent create() => OperationContent._();
  static $pb.GeneratedMessage $_createMessage() => OperationContent._();
  @$core.override
  OperationContent createEmptyInstance() => OperationContent._();
  @$core.pragma('dart2js:noInline')
  static OperationContent getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OperationContent>(
          OperationContent.$_createMessage);
  static OperationContent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get show => $_getBF(0);
  @$pb.TagNumber(1)
  set show($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShow() => $_has(0);
  @$pb.TagNumber(1)
  void clearShow() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);
}

class PaginationParams extends $pb.GeneratedMessage {
  factory PaginationParams({
    $core.Iterable<$core.MapEntry<$core.int, Offset>>? offsets,
    $core.bool? hasMore,
  }) {
    final result = PaginationParams._();
    if (offsets != null) result.offsets.addEntries(offsets);
    if (hasMore != null) result.hasMore = hasMore;
    return result;
  }

  PaginationParams._();

  factory PaginationParams.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaginationParams()..mergeFromBuffer(data, registry);
  factory PaginationParams.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaginationParams()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaginationParams',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: PaginationParams.$_createMessage)
    ..m<$core.int, Offset>(1, _omitFieldNames ? '' : 'offsets',
        entryClassName: 'PaginationParams.OffsetsEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: Offset.$_createMessage,
        valueDefaultOrMaker: Offset.getDefault,
        packageName: const $pb.PackageName('bilibili.app.im.v1'))
    ..aOB(2, _omitFieldNames ? '' : 'hasMore')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaginationParams clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaginationParams copyWith(void Function(PaginationParams) updates) =>
      super.copyWith((message) => updates(message as PaginationParams))
          as PaginationParams;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PaginationParams() / PaginationParams.new instead')
  static PaginationParams create() => PaginationParams._();
  static $pb.GeneratedMessage $_createMessage() => PaginationParams._();
  @$core.override
  PaginationParams createEmptyInstance() => PaginationParams._();
  @$core.pragma('dart2js:noInline')
  static PaginationParams getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaginationParams>(
          PaginationParams.$_createMessage);
  static PaginationParams? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.int, Offset> get offsets => $_getMap(0);

  @$pb.TagNumber(2)
  $core.bool get hasMore => $_getBF(1);
  @$pb.TagNumber(2)
  set hasMore($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHasMore() => $_has(1);
  @$pb.TagNumber(2)
  void clearHasMore() => $_clearField(2);
}

class PinSessionReply extends $pb.GeneratedMessage {
  factory PinSessionReply({
    $fixnum.Int64? sequenceNumber,
    $fixnum.Int64? code,
    $core.String? message,
  }) {
    final result = PinSessionReply._();
    if (sequenceNumber != null) result.sequenceNumber = sequenceNumber;
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    return result;
  }

  PinSessionReply._();

  factory PinSessionReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PinSessionReply()..mergeFromBuffer(data, registry);
  factory PinSessionReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PinSessionReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PinSessionReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: PinSessionReply.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'sequenceNumber')
    ..aInt64(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PinSessionReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PinSessionReply copyWith(void Function(PinSessionReply) updates) =>
      super.copyWith((message) => updates(message as PinSessionReply))
          as PinSessionReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PinSessionReply() / PinSessionReply.new instead')
  static PinSessionReply create() => PinSessionReply._();
  static $pb.GeneratedMessage $_createMessage() => PinSessionReply._();
  @$core.override
  PinSessionReply createEmptyInstance() => PinSessionReply._();
  @$core.pragma('dart2js:noInline')
  static PinSessionReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PinSessionReply>(
          PinSessionReply.$_createMessage);
  static PinSessionReply? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get sequenceNumber => $_getI64(0);
  @$pb.TagNumber(1)
  set sequenceNumber($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSequenceNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearSequenceNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get code => $_getI64(1);
  @$pb.TagNumber(2)
  set code($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);
}

class PinSessionReq extends $pb.GeneratedMessage {
  factory PinSessionReq({
    SessionId? sessionId,
    $fixnum.Int64? topTimeMicros,
  }) {
    final result = PinSessionReq._();
    if (sessionId != null) result.sessionId = sessionId;
    if (topTimeMicros != null) result.topTimeMicros = topTimeMicros;
    return result;
  }

  PinSessionReq._();

  factory PinSessionReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PinSessionReq()..mergeFromBuffer(data, registry);
  factory PinSessionReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PinSessionReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PinSessionReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: PinSessionReq.$_createMessage)
    ..aOM<SessionId>(1, _omitFieldNames ? '' : 'sessionId',
        subBuilder: SessionId.$_createMessage)
    ..aInt64(2, _omitFieldNames ? '' : 'topTimeMicros')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PinSessionReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PinSessionReq copyWith(void Function(PinSessionReq) updates) =>
      super.copyWith((message) => updates(message as PinSessionReq))
          as PinSessionReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PinSessionReq() / PinSessionReq.new instead')
  static PinSessionReq create() => PinSessionReq._();
  static $pb.GeneratedMessage $_createMessage() => PinSessionReq._();
  @$core.override
  PinSessionReq createEmptyInstance() => PinSessionReq._();
  @$core.pragma('dart2js:noInline')
  static PinSessionReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PinSessionReq>(
          PinSessionReq.$_createMessage);
  static PinSessionReq? _defaultInstance;

  @$pb.TagNumber(1)
  SessionId get sessionId => $_getN(0);
  @$pb.TagNumber(1)
  set sessionId(SessionId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
  @$pb.TagNumber(1)
  SessionId ensureSessionId() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get topTimeMicros => $_getI64(1);
  @$pb.TagNumber(2)
  set topTimeMicros($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTopTimeMicros() => $_has(1);
  @$pb.TagNumber(2)
  void clearTopTimeMicros() => $_clearField(2);
}

class PrivateId extends $pb.GeneratedMessage {
  factory PrivateId({
    $fixnum.Int64? talkerUid,
  }) {
    final result = PrivateId._();
    if (talkerUid != null) result.talkerUid = talkerUid;
    return result;
  }

  PrivateId._();

  factory PrivateId.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PrivateId()..mergeFromBuffer(data, registry);
  factory PrivateId.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PrivateId()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrivateId',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: PrivateId.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'talkerUid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivateId clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivateId copyWith(void Function(PrivateId) updates) =>
      super.copyWith((message) => updates(message as PrivateId)) as PrivateId;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PrivateId() / PrivateId.new instead')
  static PrivateId create() => PrivateId._();
  static $pb.GeneratedMessage $_createMessage() => PrivateId._();
  @$core.override
  PrivateId createEmptyInstance() => PrivateId._();
  @$core.pragma('dart2js:noInline')
  static PrivateId getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrivateId>(PrivateId.$_createMessage);
  static PrivateId? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get talkerUid => $_getI64(0);
  @$pb.TagNumber(1)
  set talkerUid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTalkerUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTalkerUid() => $_clearField(1);
}

class QuickLinkBubble extends $pb.GeneratedMessage {
  factory QuickLinkBubble({
    $fixnum.Int64? mid,
    $core.String? avatar,
    $core.String? nickName,
    $core.String? content,
    QuickLinkItemType? quickLinkItem,
    QuickLinkMsgType? msgType,
  }) {
    final result = QuickLinkBubble._();
    if (mid != null) result.mid = mid;
    if (avatar != null) result.avatar = avatar;
    if (nickName != null) result.nickName = nickName;
    if (content != null) result.content = content;
    if (quickLinkItem != null) result.quickLinkItem = quickLinkItem;
    if (msgType != null) result.msgType = msgType;
    return result;
  }

  QuickLinkBubble._();

  factory QuickLinkBubble.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickLinkBubble()..mergeFromBuffer(data, registry);
  factory QuickLinkBubble.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickLinkBubble()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuickLinkBubble',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: QuickLinkBubble.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'avatar')
    ..aOS(3, _omitFieldNames ? '' : 'nickName')
    ..aOS(4, _omitFieldNames ? '' : 'content')
    ..aE<QuickLinkItemType>(5, _omitFieldNames ? '' : 'quickLinkItem',
        enumValues: QuickLinkItemType.values)
    ..aE<QuickLinkMsgType>(6, _omitFieldNames ? '' : 'msgType',
        enumValues: QuickLinkMsgType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickLinkBubble clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickLinkBubble copyWith(void Function(QuickLinkBubble) updates) =>
      super.copyWith((message) => updates(message as QuickLinkBubble))
          as QuickLinkBubble;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use QuickLinkBubble() / QuickLinkBubble.new instead')
  static QuickLinkBubble create() => QuickLinkBubble._();
  static $pb.GeneratedMessage $_createMessage() => QuickLinkBubble._();
  @$core.override
  QuickLinkBubble createEmptyInstance() => QuickLinkBubble._();
  @$core.pragma('dart2js:noInline')
  static QuickLinkBubble getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QuickLinkBubble>(
          QuickLinkBubble.$_createMessage);
  static QuickLinkBubble? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get mid => $_getI64(0);
  @$pb.TagNumber(1)
  set mid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearMid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get avatar => $_getSZ(1);
  @$pb.TagNumber(2)
  set avatar($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAvatar() => $_has(1);
  @$pb.TagNumber(2)
  void clearAvatar() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get nickName => $_getSZ(2);
  @$pb.TagNumber(3)
  set nickName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNickName() => $_has(2);
  @$pb.TagNumber(3)
  void clearNickName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get content => $_getSZ(3);
  @$pb.TagNumber(4)
  set content($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContent() => $_has(3);
  @$pb.TagNumber(4)
  void clearContent() => $_clearField(4);

  @$pb.TagNumber(5)
  QuickLinkItemType get quickLinkItem => $_getN(4);
  @$pb.TagNumber(5)
  set quickLinkItem(QuickLinkItemType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasQuickLinkItem() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuickLinkItem() => $_clearField(5);

  @$pb.TagNumber(6)
  QuickLinkMsgType get msgType => $_getN(5);
  @$pb.TagNumber(6)
  set msgType(QuickLinkMsgType value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasMsgType() => $_has(5);
  @$pb.TagNumber(6)
  void clearMsgType() => $_clearField(6);
}

class QuickLinkConfig extends $pb.GeneratedMessage {
  factory QuickLinkConfig({
    $core.Iterable<QuickLinkItem>? items,
    QuickLinkBubble? bubble,
    $core.bool? isLegacyStyle,
  }) {
    final result = QuickLinkConfig._();
    if (items != null) result.items.addAll(items);
    if (bubble != null) result.bubble = bubble;
    if (isLegacyStyle != null) result.isLegacyStyle = isLegacyStyle;
    return result;
  }

  QuickLinkConfig._();

  factory QuickLinkConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickLinkConfig()..mergeFromBuffer(data, registry);
  factory QuickLinkConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickLinkConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuickLinkConfig',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: QuickLinkConfig.$_createMessage)
    ..pPM<QuickLinkItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: QuickLinkItem.$_createMessage)
    ..aOM<QuickLinkBubble>(2, _omitFieldNames ? '' : 'bubble',
        subBuilder: QuickLinkBubble.$_createMessage)
    ..aOB(3, _omitFieldNames ? '' : 'isLegacyStyle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickLinkConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickLinkConfig copyWith(void Function(QuickLinkConfig) updates) =>
      super.copyWith((message) => updates(message as QuickLinkConfig))
          as QuickLinkConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use QuickLinkConfig() / QuickLinkConfig.new instead')
  static QuickLinkConfig create() => QuickLinkConfig._();
  static $pb.GeneratedMessage $_createMessage() => QuickLinkConfig._();
  @$core.override
  QuickLinkConfig createEmptyInstance() => QuickLinkConfig._();
  @$core.pragma('dart2js:noInline')
  static QuickLinkConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QuickLinkConfig>(
          QuickLinkConfig.$_createMessage);
  static QuickLinkConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<QuickLinkItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  QuickLinkBubble get bubble => $_getN(1);
  @$pb.TagNumber(2)
  set bubble(QuickLinkBubble value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasBubble() => $_has(1);
  @$pb.TagNumber(2)
  void clearBubble() => $_clearField(2);
  @$pb.TagNumber(2)
  QuickLinkBubble ensureBubble() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get isLegacyStyle => $_getBF(2);
  @$pb.TagNumber(3)
  set isLegacyStyle($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsLegacyStyle() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsLegacyStyle() => $_clearField(3);
}

class QuickLinkItem extends $pb.GeneratedMessage {
  factory QuickLinkItem({
    $core.String? title,
    $core.String? icon,
    $core.String? iconDark,
    $core.String? url,
    Unread? unread,
    QuickLinkItemType? itemType,
  }) {
    final result = QuickLinkItem._();
    if (title != null) result.title = title;
    if (icon != null) result.icon = icon;
    if (iconDark != null) result.iconDark = iconDark;
    if (url != null) result.url = url;
    if (unread != null) result.unread = unread;
    if (itemType != null) result.itemType = itemType;
    return result;
  }

  QuickLinkItem._();

  factory QuickLinkItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickLinkItem()..mergeFromBuffer(data, registry);
  factory QuickLinkItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickLinkItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuickLinkItem',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: QuickLinkItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'icon')
    ..aOS(3, _omitFieldNames ? '' : 'iconDark')
    ..aOS(4, _omitFieldNames ? '' : 'url')
    ..aOM<Unread>(5, _omitFieldNames ? '' : 'unread',
        subBuilder: Unread.$_createMessage)
    ..aE<QuickLinkItemType>(6, _omitFieldNames ? '' : 'itemType',
        enumValues: QuickLinkItemType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickLinkItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickLinkItem copyWith(void Function(QuickLinkItem) updates) =>
      super.copyWith((message) => updates(message as QuickLinkItem))
          as QuickLinkItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use QuickLinkItem() / QuickLinkItem.new instead')
  static QuickLinkItem create() => QuickLinkItem._();
  static $pb.GeneratedMessage $_createMessage() => QuickLinkItem._();
  @$core.override
  QuickLinkItem createEmptyInstance() => QuickLinkItem._();
  @$core.pragma('dart2js:noInline')
  static QuickLinkItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QuickLinkItem>(
          QuickLinkItem.$_createMessage);
  static QuickLinkItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get icon => $_getSZ(1);
  @$pb.TagNumber(2)
  set icon($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIcon() => $_has(1);
  @$pb.TagNumber(2)
  void clearIcon() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get iconDark => $_getSZ(2);
  @$pb.TagNumber(3)
  set iconDark($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIconDark() => $_has(2);
  @$pb.TagNumber(3)
  void clearIconDark() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get url => $_getSZ(3);
  @$pb.TagNumber(4)
  set url($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  Unread get unread => $_getN(4);
  @$pb.TagNumber(5)
  set unread(Unread value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasUnread() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnread() => $_clearField(5);
  @$pb.TagNumber(5)
  Unread ensureUnread() => $_ensure(4);

  @$pb.TagNumber(6)
  QuickLinkItemType get itemType => $_getN(5);
  @$pb.TagNumber(6)
  set itemType(QuickLinkItemType value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasItemType() => $_has(5);
  @$pb.TagNumber(6)
  void clearItemType() => $_clearField(6);
}

class QuickLinkUnreadItem extends $pb.GeneratedMessage {
  factory QuickLinkUnreadItem({
    QuickLinkItemType? itemType,
    Unread? unread,
  }) {
    final result = QuickLinkUnreadItem._();
    if (itemType != null) result.itemType = itemType;
    if (unread != null) result.unread = unread;
    return result;
  }

  QuickLinkUnreadItem._();

  factory QuickLinkUnreadItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickLinkUnreadItem()..mergeFromBuffer(data, registry);
  factory QuickLinkUnreadItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickLinkUnreadItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuickLinkUnreadItem',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: QuickLinkUnreadItem.$_createMessage)
    ..aE<QuickLinkItemType>(1, _omitFieldNames ? '' : 'itemType',
        enumValues: QuickLinkItemType.values)
    ..aOM<Unread>(2, _omitFieldNames ? '' : 'unread',
        subBuilder: Unread.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickLinkUnreadItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickLinkUnreadItem copyWith(void Function(QuickLinkUnreadItem) updates) =>
      super.copyWith((message) => updates(message as QuickLinkUnreadItem))
          as QuickLinkUnreadItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use QuickLinkUnreadItem() / QuickLinkUnreadItem.new instead')
  static QuickLinkUnreadItem create() => QuickLinkUnreadItem._();
  static $pb.GeneratedMessage $_createMessage() => QuickLinkUnreadItem._();
  @$core.override
  QuickLinkUnreadItem createEmptyInstance() => QuickLinkUnreadItem._();
  @$core.pragma('dart2js:noInline')
  static QuickLinkUnreadItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QuickLinkUnreadItem>(
          QuickLinkUnreadItem.$_createMessage);
  static QuickLinkUnreadItem? _defaultInstance;

  @$pb.TagNumber(1)
  QuickLinkItemType get itemType => $_getN(0);
  @$pb.TagNumber(1)
  set itemType(QuickLinkItemType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItemType() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemType() => $_clearField(1);

  @$pb.TagNumber(2)
  Unread get unread => $_getN(1);
  @$pb.TagNumber(2)
  set unread(Unread value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUnread() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnread() => $_clearField(2);
  @$pb.TagNumber(2)
  Unread ensureUnread() => $_ensure(1);
}

class RestrictedMode extends $pb.GeneratedMessage {
  factory RestrictedMode({
    $core.bool? teenagers,
    $core.bool? lessons,
  }) {
    final result = RestrictedMode._();
    if (teenagers != null) result.teenagers = teenagers;
    if (lessons != null) result.lessons = lessons;
    return result;
  }

  RestrictedMode._();

  factory RestrictedMode.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RestrictedMode()..mergeFromBuffer(data, registry);
  factory RestrictedMode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RestrictedMode()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RestrictedMode',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: RestrictedMode.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'teenagers')
    ..aOB(2, _omitFieldNames ? '' : 'lessons')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestrictedMode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestrictedMode copyWith(void Function(RestrictedMode) updates) =>
      super.copyWith((message) => updates(message as RestrictedMode))
          as RestrictedMode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RestrictedMode() / RestrictedMode.new instead')
  static RestrictedMode create() => RestrictedMode._();
  static $pb.GeneratedMessage $_createMessage() => RestrictedMode._();
  @$core.override
  RestrictedMode createEmptyInstance() => RestrictedMode._();
  @$core.pragma('dart2js:noInline')
  static RestrictedMode getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RestrictedMode>(
          RestrictedMode.$_createMessage);
  static RestrictedMode? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get teenagers => $_getBF(0);
  @$pb.TagNumber(1)
  set teenagers($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTeenagers() => $_has(0);
  @$pb.TagNumber(1)
  void clearTeenagers() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get lessons => $_getBF(1);
  @$pb.TagNumber(2)
  set lessons($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLessons() => $_has(1);
  @$pb.TagNumber(2)
  void clearLessons() => $_clearField(2);
}

class SelectItem extends $pb.GeneratedMessage {
  factory SelectItem({
    $core.int? itemType,
    $core.String? text,
    $core.bool? selected,
  }) {
    final result = SelectItem._();
    if (itemType != null) result.itemType = itemType;
    if (text != null) result.text = text;
    if (selected != null) result.selected = selected;
    return result;
  }

  SelectItem._();

  factory SelectItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SelectItem()..mergeFromBuffer(data, registry);
  factory SelectItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SelectItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SelectItem',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SelectItem.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'itemType')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOB(3, _omitFieldNames ? '' : 'selected')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectItem copyWith(void Function(SelectItem) updates) =>
      super.copyWith((message) => updates(message as SelectItem)) as SelectItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SelectItem() / SelectItem.new instead')
  static SelectItem create() => SelectItem._();
  static $pb.GeneratedMessage $_createMessage() => SelectItem._();
  @$core.override
  SelectItem createEmptyInstance() => SelectItem._();
  @$core.pragma('dart2js:noInline')
  static SelectItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SelectItem>(SelectItem.$_createMessage);
  static SelectItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get itemType => $_getIZ(0);
  @$pb.TagNumber(1)
  set itemType($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemType() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get selected => $_getBF(2);
  @$pb.TagNumber(3)
  set selected($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSelected() => $_has(2);
  @$pb.TagNumber(3)
  void clearSelected() => $_clearField(3);
}

class Session extends $pb.GeneratedMessage {
  factory Session({
    SessionId? id,
    SessionInfo? sessionInfo,
    Unread? unread,
    MsgSummary? msgSummary,
    $fixnum.Int64? timestamp,
    $core.bool? isPinned,
    $fixnum.Int64? sequenceNumber,
    $core.bool? isMuted,
    $core.String? chatUrl,
    SessionOperation? operation,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? traceParams,
  }) {
    final result = Session._();
    if (id != null) result.id = id;
    if (sessionInfo != null) result.sessionInfo = sessionInfo;
    if (unread != null) result.unread = unread;
    if (msgSummary != null) result.msgSummary = msgSummary;
    if (timestamp != null) result.timestamp = timestamp;
    if (isPinned != null) result.isPinned = isPinned;
    if (sequenceNumber != null) result.sequenceNumber = sequenceNumber;
    if (isMuted != null) result.isMuted = isMuted;
    if (chatUrl != null) result.chatUrl = chatUrl;
    if (operation != null) result.operation = operation;
    if (traceParams != null) result.traceParams.addEntries(traceParams);
    return result;
  }

  Session._();

  factory Session.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Session()..mergeFromBuffer(data, registry);
  factory Session.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Session()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Session',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: Session.$_createMessage)
    ..aOM<SessionId>(1, _omitFieldNames ? '' : 'id',
        subBuilder: SessionId.$_createMessage)
    ..aOM<SessionInfo>(2, _omitFieldNames ? '' : 'sessionInfo',
        subBuilder: SessionInfo.$_createMessage)
    ..aOM<Unread>(3, _omitFieldNames ? '' : 'unread',
        subBuilder: Unread.$_createMessage)
    ..aOM<MsgSummary>(4, _omitFieldNames ? '' : 'msgSummary',
        subBuilder: MsgSummary.$_createMessage)
    ..aInt64(5, _omitFieldNames ? '' : 'timestamp')
    ..aOB(6, _omitFieldNames ? '' : 'isPinned')
    ..aInt64(7, _omitFieldNames ? '' : 'sequenceNumber')
    ..aOB(8, _omitFieldNames ? '' : 'isMuted')
    ..aOS(9, _omitFieldNames ? '' : 'chatUrl')
    ..aOM<SessionOperation>(10, _omitFieldNames ? '' : 'operation',
        subBuilder: SessionOperation.$_createMessage)
    ..m<$core.String, $core.String>(11, _omitFieldNames ? '' : 'traceParams',
        entryClassName: 'Session.TraceParamsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.im.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Session clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Session copyWith(void Function(Session) updates) =>
      super.copyWith((message) => updates(message as Session)) as Session;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Session() / Session.new instead')
  static Session create() => Session._();
  static $pb.GeneratedMessage $_createMessage() => Session._();
  @$core.override
  Session createEmptyInstance() => Session._();
  @$core.pragma('dart2js:noInline')
  static Session getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Session>(Session.$_createMessage);
  static Session? _defaultInstance;

  @$pb.TagNumber(1)
  SessionId get id => $_getN(0);
  @$pb.TagNumber(1)
  set id(SessionId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
  @$pb.TagNumber(1)
  SessionId ensureId() => $_ensure(0);

  @$pb.TagNumber(2)
  SessionInfo get sessionInfo => $_getN(1);
  @$pb.TagNumber(2)
  set sessionInfo(SessionInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionInfo() => $_clearField(2);
  @$pb.TagNumber(2)
  SessionInfo ensureSessionInfo() => $_ensure(1);

  @$pb.TagNumber(3)
  Unread get unread => $_getN(2);
  @$pb.TagNumber(3)
  set unread(Unread value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUnread() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnread() => $_clearField(3);
  @$pb.TagNumber(3)
  Unread ensureUnread() => $_ensure(2);

  @$pb.TagNumber(4)
  MsgSummary get msgSummary => $_getN(3);
  @$pb.TagNumber(4)
  set msgSummary(MsgSummary value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMsgSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearMsgSummary() => $_clearField(4);
  @$pb.TagNumber(4)
  MsgSummary ensureMsgSummary() => $_ensure(3);

  @$pb.TagNumber(5)
  $fixnum.Int64 get timestamp => $_getI64(4);
  @$pb.TagNumber(5)
  set timestamp($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTimestamp() => $_has(4);
  @$pb.TagNumber(5)
  void clearTimestamp() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isPinned => $_getBF(5);
  @$pb.TagNumber(6)
  set isPinned($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsPinned() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsPinned() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get sequenceNumber => $_getI64(6);
  @$pb.TagNumber(7)
  set sequenceNumber($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSequenceNumber() => $_has(6);
  @$pb.TagNumber(7)
  void clearSequenceNumber() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isMuted => $_getBF(7);
  @$pb.TagNumber(8)
  set isMuted($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsMuted() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsMuted() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get chatUrl => $_getSZ(8);
  @$pb.TagNumber(9)
  set chatUrl($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasChatUrl() => $_has(8);
  @$pb.TagNumber(9)
  void clearChatUrl() => $_clearField(9);

  @$pb.TagNumber(10)
  SessionOperation get operation => $_getN(9);
  @$pb.TagNumber(10)
  set operation(SessionOperation value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasOperation() => $_has(9);
  @$pb.TagNumber(10)
  void clearOperation() => $_clearField(10);
  @$pb.TagNumber(10)
  SessionOperation ensureOperation() => $_ensure(9);

  @$pb.TagNumber(11)
  $pb.PbMap<$core.String, $core.String> get traceParams => $_getMap(10);
}

enum SessionId_Id { privateId, groupId, foldId, systemId, customerId, notSet }

class SessionId extends $pb.GeneratedMessage {
  factory SessionId({
    PrivateId? privateId,
    GroupId? groupId,
    FoldId? foldId,
    SystemId? systemId,
    CustomerId? customerId,
  }) {
    final result = SessionId._();
    if (privateId != null) result.privateId = privateId;
    if (groupId != null) result.groupId = groupId;
    if (foldId != null) result.foldId = foldId;
    if (systemId != null) result.systemId = systemId;
    if (customerId != null) result.customerId = customerId;
    return result;
  }

  SessionId._();

  factory SessionId.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionId()..mergeFromBuffer(data, registry);
  factory SessionId.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionId()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SessionId_Id> _SessionId_IdByTag = {
    1: SessionId_Id.privateId,
    2: SessionId_Id.groupId,
    3: SessionId_Id.foldId,
    4: SessionId_Id.systemId,
    5: SessionId_Id.customerId,
    0: SessionId_Id.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionId',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SessionId.$_createMessage)
    ..oo(0, [1, 2, 3, 4, 5])
    ..aOM<PrivateId>(1, _omitFieldNames ? '' : 'privateId',
        subBuilder: PrivateId.$_createMessage)
    ..aOM<GroupId>(2, _omitFieldNames ? '' : 'groupId',
        subBuilder: GroupId.$_createMessage)
    ..aOM<FoldId>(3, _omitFieldNames ? '' : 'foldId',
        subBuilder: FoldId.$_createMessage)
    ..aOM<SystemId>(4, _omitFieldNames ? '' : 'systemId',
        subBuilder: SystemId.$_createMessage)
    ..aOM<CustomerId>(5, _omitFieldNames ? '' : 'customerId',
        subBuilder: CustomerId.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionId clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionId copyWith(void Function(SessionId) updates) =>
      super.copyWith((message) => updates(message as SessionId)) as SessionId;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SessionId() / SessionId.new instead')
  static SessionId create() => SessionId._();
  static $pb.GeneratedMessage $_createMessage() => SessionId._();
  @$core.override
  SessionId createEmptyInstance() => SessionId._();
  @$core.pragma('dart2js:noInline')
  static SessionId getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionId>(SessionId.$_createMessage);
  static SessionId? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  SessionId_Id whichId() => _SessionId_IdByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearId() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  PrivateId get privateId => $_getN(0);
  @$pb.TagNumber(1)
  set privateId(PrivateId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPrivateId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrivateId() => $_clearField(1);
  @$pb.TagNumber(1)
  PrivateId ensurePrivateId() => $_ensure(0);

  @$pb.TagNumber(2)
  GroupId get groupId => $_getN(1);
  @$pb.TagNumber(2)
  set groupId(GroupId value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasGroupId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupId() => $_clearField(2);
  @$pb.TagNumber(2)
  GroupId ensureGroupId() => $_ensure(1);

  @$pb.TagNumber(3)
  FoldId get foldId => $_getN(2);
  @$pb.TagNumber(3)
  set foldId(FoldId value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFoldId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFoldId() => $_clearField(3);
  @$pb.TagNumber(3)
  FoldId ensureFoldId() => $_ensure(2);

  @$pb.TagNumber(4)
  SystemId get systemId => $_getN(3);
  @$pb.TagNumber(4)
  set systemId(SystemId value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSystemId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSystemId() => $_clearField(4);
  @$pb.TagNumber(4)
  SystemId ensureSystemId() => $_ensure(3);

  @$pb.TagNumber(5)
  CustomerId get customerId => $_getN(4);
  @$pb.TagNumber(5)
  set customerId(CustomerId value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCustomerId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCustomerId() => $_clearField(5);
  @$pb.TagNumber(5)
  CustomerId ensureCustomerId() => $_ensure(4);
}

class SessionInfo extends $pb.GeneratedMessage {
  factory SessionInfo({
    $core.String? sessionName,
    $1.NameRender? nameRender,
    $0.AvatarItem? avatar,
    $core.String? vipInfo,
    UserLabel? userLabel,
    $core.bool? isLive,
  }) {
    final result = SessionInfo._();
    if (sessionName != null) result.sessionName = sessionName;
    if (nameRender != null) result.nameRender = nameRender;
    if (avatar != null) result.avatar = avatar;
    if (vipInfo != null) result.vipInfo = vipInfo;
    if (userLabel != null) result.userLabel = userLabel;
    if (isLive != null) result.isLive = isLive;
    return result;
  }

  SessionInfo._();

  factory SessionInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionInfo()..mergeFromBuffer(data, registry);
  factory SessionInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionInfo',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SessionInfo.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sessionName')
    ..aOM<$1.NameRender>(2, _omitFieldNames ? '' : 'nameRender',
        subBuilder: $1.NameRender.$_createMessage)
    ..aOM<$0.AvatarItem>(3, _omitFieldNames ? '' : 'avatar',
        subBuilder: $0.AvatarItem.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'vipInfo')
    ..aOM<UserLabel>(5, _omitFieldNames ? '' : 'userLabel',
        subBuilder: UserLabel.$_createMessage)
    ..aOB(6, _omitFieldNames ? '' : 'isLive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionInfo copyWith(void Function(SessionInfo) updates) =>
      super.copyWith((message) => updates(message as SessionInfo))
          as SessionInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SessionInfo() / SessionInfo.new instead')
  static SessionInfo create() => SessionInfo._();
  static $pb.GeneratedMessage $_createMessage() => SessionInfo._();
  @$core.override
  SessionInfo createEmptyInstance() => SessionInfo._();
  @$core.pragma('dart2js:noInline')
  static SessionInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SessionInfo>(
          SessionInfo.$_createMessage);
  static SessionInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionName => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionName() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionName() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.NameRender get nameRender => $_getN(1);
  @$pb.TagNumber(2)
  set nameRender($1.NameRender value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasNameRender() => $_has(1);
  @$pb.TagNumber(2)
  void clearNameRender() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.NameRender ensureNameRender() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.AvatarItem get avatar => $_getN(2);
  @$pb.TagNumber(3)
  set avatar($0.AvatarItem value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAvatar() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvatar() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.AvatarItem ensureAvatar() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get vipInfo => $_getSZ(3);
  @$pb.TagNumber(4)
  set vipInfo($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVipInfo() => $_has(3);
  @$pb.TagNumber(4)
  void clearVipInfo() => $_clearField(4);

  @$pb.TagNumber(5)
  UserLabel get userLabel => $_getN(4);
  @$pb.TagNumber(5)
  set userLabel(UserLabel value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasUserLabel() => $_has(4);
  @$pb.TagNumber(5)
  void clearUserLabel() => $_clearField(5);
  @$pb.TagNumber(5)
  UserLabel ensureUserLabel() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.bool get isLive => $_getBF(5);
  @$pb.TagNumber(6)
  set isLive($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsLive() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsLive() => $_clearField(6);
}

class SessionListExtraInfo extends $pb.GeneratedMessage {
  factory SessionListExtraInfo({
    AutoReplyToast? autoReplyToast,
    $core.bool? showAntiHarassmentPopup,
    $core.String? customerHintTitle,
    BehaviorAlertToast? behaviorAlertToast,
  }) {
    final result = SessionListExtraInfo._();
    if (autoReplyToast != null) result.autoReplyToast = autoReplyToast;
    if (showAntiHarassmentPopup != null)
      result.showAntiHarassmentPopup = showAntiHarassmentPopup;
    if (customerHintTitle != null) result.customerHintTitle = customerHintTitle;
    if (behaviorAlertToast != null)
      result.behaviorAlertToast = behaviorAlertToast;
    return result;
  }

  SessionListExtraInfo._();

  factory SessionListExtraInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionListExtraInfo()..mergeFromBuffer(data, registry);
  factory SessionListExtraInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionListExtraInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionListExtraInfo',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SessionListExtraInfo.$_createMessage)
    ..aOM<AutoReplyToast>(1, _omitFieldNames ? '' : 'autoReplyToast',
        subBuilder: AutoReplyToast.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'showAntiHarassmentPopup')
    ..aOS(3, _omitFieldNames ? '' : 'customerHintTitle')
    ..aOM<BehaviorAlertToast>(4, _omitFieldNames ? '' : 'behaviorAlertToast',
        subBuilder: BehaviorAlertToast.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionListExtraInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionListExtraInfo copyWith(void Function(SessionListExtraInfo) updates) =>
      super.copyWith((message) => updates(message as SessionListExtraInfo))
          as SessionListExtraInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SessionListExtraInfo() / SessionListExtraInfo.new instead')
  static SessionListExtraInfo create() => SessionListExtraInfo._();
  static $pb.GeneratedMessage $_createMessage() => SessionListExtraInfo._();
  @$core.override
  SessionListExtraInfo createEmptyInstance() => SessionListExtraInfo._();
  @$core.pragma('dart2js:noInline')
  static SessionListExtraInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionListExtraInfo>(
          SessionListExtraInfo.$_createMessage);
  static SessionListExtraInfo? _defaultInstance;

  @$pb.TagNumber(1)
  AutoReplyToast get autoReplyToast => $_getN(0);
  @$pb.TagNumber(1)
  set autoReplyToast(AutoReplyToast value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAutoReplyToast() => $_has(0);
  @$pb.TagNumber(1)
  void clearAutoReplyToast() => $_clearField(1);
  @$pb.TagNumber(1)
  AutoReplyToast ensureAutoReplyToast() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get showAntiHarassmentPopup => $_getBF(1);
  @$pb.TagNumber(2)
  set showAntiHarassmentPopup($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShowAntiHarassmentPopup() => $_has(1);
  @$pb.TagNumber(2)
  void clearShowAntiHarassmentPopup() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get customerHintTitle => $_getSZ(2);
  @$pb.TagNumber(3)
  set customerHintTitle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCustomerHintTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearCustomerHintTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  BehaviorAlertToast get behaviorAlertToast => $_getN(3);
  @$pb.TagNumber(4)
  set behaviorAlertToast(BehaviorAlertToast value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBehaviorAlertToast() => $_has(3);
  @$pb.TagNumber(4)
  void clearBehaviorAlertToast() => $_clearField(4);
  @$pb.TagNumber(4)
  BehaviorAlertToast ensureBehaviorAlertToast() => $_ensure(3);
}

class SessionListUpdateReply extends $pb.GeneratedMessage {
  factory SessionListUpdateReply({
    $core.Iterable<Session>? sessions,
    UpdateSessionParams? updateSessionParams,
  }) {
    final result = SessionListUpdateReply._();
    if (sessions != null) result.sessions.addAll(sessions);
    if (updateSessionParams != null)
      result.updateSessionParams = updateSessionParams;
    return result;
  }

  SessionListUpdateReply._();

  factory SessionListUpdateReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionListUpdateReply()..mergeFromBuffer(data, registry);
  factory SessionListUpdateReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionListUpdateReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionListUpdateReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SessionListUpdateReply.$_createMessage)
    ..pPM<Session>(1, _omitFieldNames ? '' : 'sessions',
        subBuilder: Session.$_createMessage)
    ..aOM<UpdateSessionParams>(2, _omitFieldNames ? '' : 'updateSessionParams',
        subBuilder: UpdateSessionParams.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionListUpdateReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionListUpdateReply copyWith(
          void Function(SessionListUpdateReply) updates) =>
      super.copyWith((message) => updates(message as SessionListUpdateReply))
          as SessionListUpdateReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SessionListUpdateReply() / SessionListUpdateReply.new instead')
  static SessionListUpdateReply create() => SessionListUpdateReply._();
  static $pb.GeneratedMessage $_createMessage() => SessionListUpdateReply._();
  @$core.override
  SessionListUpdateReply createEmptyInstance() => SessionListUpdateReply._();
  @$core.pragma('dart2js:noInline')
  static SessionListUpdateReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionListUpdateReply>(
          SessionListUpdateReply.$_createMessage);
  static SessionListUpdateReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Session> get sessions => $_getList(0);

  @$pb.TagNumber(2)
  UpdateSessionParams get updateSessionParams => $_getN(1);
  @$pb.TagNumber(2)
  set updateSessionParams(UpdateSessionParams value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateSessionParams() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateSessionParams() => $_clearField(2);
  @$pb.TagNumber(2)
  UpdateSessionParams ensureUpdateSessionParams() => $_ensure(1);
}

class SessionListUpdateReq extends $pb.GeneratedMessage {
  factory SessionListUpdateReq({
    RestrictedMode? restrictedMode,
    UpdateSessionParams? updateParams,
    SessionPageType? pageType,
    SessionFilterType? filterType,
  }) {
    final result = SessionListUpdateReq._();
    if (restrictedMode != null) result.restrictedMode = restrictedMode;
    if (updateParams != null) result.updateParams = updateParams;
    if (pageType != null) result.pageType = pageType;
    if (filterType != null) result.filterType = filterType;
    return result;
  }

  SessionListUpdateReq._();

  factory SessionListUpdateReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionListUpdateReq()..mergeFromBuffer(data, registry);
  factory SessionListUpdateReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionListUpdateReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionListUpdateReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SessionListUpdateReq.$_createMessage)
    ..aOM<RestrictedMode>(1, _omitFieldNames ? '' : 'restrictedMode',
        subBuilder: RestrictedMode.$_createMessage)
    ..aOM<UpdateSessionParams>(2, _omitFieldNames ? '' : 'updateParams',
        subBuilder: UpdateSessionParams.$_createMessage)
    ..aE<SessionPageType>(3, _omitFieldNames ? '' : 'pageType',
        enumValues: SessionPageType.values)
    ..aE<SessionFilterType>(4, _omitFieldNames ? '' : 'filterType',
        enumValues: SessionFilterType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionListUpdateReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionListUpdateReq copyWith(void Function(SessionListUpdateReq) updates) =>
      super.copyWith((message) => updates(message as SessionListUpdateReq))
          as SessionListUpdateReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SessionListUpdateReq() / SessionListUpdateReq.new instead')
  static SessionListUpdateReq create() => SessionListUpdateReq._();
  static $pb.GeneratedMessage $_createMessage() => SessionListUpdateReq._();
  @$core.override
  SessionListUpdateReq createEmptyInstance() => SessionListUpdateReq._();
  @$core.pragma('dart2js:noInline')
  static SessionListUpdateReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionListUpdateReq>(
          SessionListUpdateReq.$_createMessage);
  static SessionListUpdateReq? _defaultInstance;

  @$pb.TagNumber(1)
  RestrictedMode get restrictedMode => $_getN(0);
  @$pb.TagNumber(1)
  set restrictedMode(RestrictedMode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRestrictedMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearRestrictedMode() => $_clearField(1);
  @$pb.TagNumber(1)
  RestrictedMode ensureRestrictedMode() => $_ensure(0);

  @$pb.TagNumber(2)
  UpdateSessionParams get updateParams => $_getN(1);
  @$pb.TagNumber(2)
  set updateParams(UpdateSessionParams value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateParams() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateParams() => $_clearField(2);
  @$pb.TagNumber(2)
  UpdateSessionParams ensureUpdateParams() => $_ensure(1);

  @$pb.TagNumber(3)
  SessionPageType get pageType => $_getN(2);
  @$pb.TagNumber(3)
  set pageType(SessionPageType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPageType() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageType() => $_clearField(3);

  @$pb.TagNumber(4)
  SessionFilterType get filterType => $_getN(3);
  @$pb.TagNumber(4)
  set filterType(SessionFilterType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFilterType() => $_has(3);
  @$pb.TagNumber(4)
  void clearFilterType() => $_clearField(4);
}

class SessionMainReply extends $pb.GeneratedMessage {
  factory SessionMainReply({
    PaginationParams? paginationParams,
    UpdateSessionParams? updateSessionParams,
    QuickLinkConfig? quickLinkConfig,
    FilterConfig? filterConfig,
    $core.Iterable<Session>? sessions,
    $core.Iterable<ThreeDotItem>? threeDotItems,
    $core.Iterable<ThreeDotItem>? outsideItem,
    SessionListExtraInfo? extraInfo,
  }) {
    final result = SessionMainReply._();
    if (paginationParams != null) result.paginationParams = paginationParams;
    if (updateSessionParams != null)
      result.updateSessionParams = updateSessionParams;
    if (quickLinkConfig != null) result.quickLinkConfig = quickLinkConfig;
    if (filterConfig != null) result.filterConfig = filterConfig;
    if (sessions != null) result.sessions.addAll(sessions);
    if (threeDotItems != null) result.threeDotItems.addAll(threeDotItems);
    if (outsideItem != null) result.outsideItem.addAll(outsideItem);
    if (extraInfo != null) result.extraInfo = extraInfo;
    return result;
  }

  SessionMainReply._();

  factory SessionMainReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionMainReply()..mergeFromBuffer(data, registry);
  factory SessionMainReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionMainReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionMainReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SessionMainReply.$_createMessage)
    ..aOM<PaginationParams>(1, _omitFieldNames ? '' : 'paginationParams',
        subBuilder: PaginationParams.$_createMessage)
    ..aOM<UpdateSessionParams>(2, _omitFieldNames ? '' : 'updateSessionParams',
        subBuilder: UpdateSessionParams.$_createMessage)
    ..aOM<QuickLinkConfig>(3, _omitFieldNames ? '' : 'quickLinkConfig',
        subBuilder: QuickLinkConfig.$_createMessage)
    ..aOM<FilterConfig>(4, _omitFieldNames ? '' : 'filterConfig',
        subBuilder: FilterConfig.$_createMessage)
    ..pPM<Session>(5, _omitFieldNames ? '' : 'sessions',
        subBuilder: Session.$_createMessage)
    ..pPM<ThreeDotItem>(6, _omitFieldNames ? '' : 'threeDotItems',
        subBuilder: ThreeDotItem.$_createMessage)
    ..pPM<ThreeDotItem>(7, _omitFieldNames ? '' : 'outsideItem',
        subBuilder: ThreeDotItem.$_createMessage)
    ..aOM<SessionListExtraInfo>(8, _omitFieldNames ? '' : 'extraInfo',
        subBuilder: SessionListExtraInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionMainReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionMainReply copyWith(void Function(SessionMainReply) updates) =>
      super.copyWith((message) => updates(message as SessionMainReply))
          as SessionMainReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SessionMainReply() / SessionMainReply.new instead')
  static SessionMainReply create() => SessionMainReply._();
  static $pb.GeneratedMessage $_createMessage() => SessionMainReply._();
  @$core.override
  SessionMainReply createEmptyInstance() => SessionMainReply._();
  @$core.pragma('dart2js:noInline')
  static SessionMainReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SessionMainReply>(
          SessionMainReply.$_createMessage);
  static SessionMainReply? _defaultInstance;

  @$pb.TagNumber(1)
  PaginationParams get paginationParams => $_getN(0);
  @$pb.TagNumber(1)
  set paginationParams(PaginationParams value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPaginationParams() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaginationParams() => $_clearField(1);
  @$pb.TagNumber(1)
  PaginationParams ensurePaginationParams() => $_ensure(0);

  @$pb.TagNumber(2)
  UpdateSessionParams get updateSessionParams => $_getN(1);
  @$pb.TagNumber(2)
  set updateSessionParams(UpdateSessionParams value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateSessionParams() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateSessionParams() => $_clearField(2);
  @$pb.TagNumber(2)
  UpdateSessionParams ensureUpdateSessionParams() => $_ensure(1);

  @$pb.TagNumber(3)
  QuickLinkConfig get quickLinkConfig => $_getN(2);
  @$pb.TagNumber(3)
  set quickLinkConfig(QuickLinkConfig value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasQuickLinkConfig() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuickLinkConfig() => $_clearField(3);
  @$pb.TagNumber(3)
  QuickLinkConfig ensureQuickLinkConfig() => $_ensure(2);

  @$pb.TagNumber(4)
  FilterConfig get filterConfig => $_getN(3);
  @$pb.TagNumber(4)
  set filterConfig(FilterConfig value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFilterConfig() => $_has(3);
  @$pb.TagNumber(4)
  void clearFilterConfig() => $_clearField(4);
  @$pb.TagNumber(4)
  FilterConfig ensureFilterConfig() => $_ensure(3);

  @$pb.TagNumber(5)
  $pb.PbList<Session> get sessions => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<ThreeDotItem> get threeDotItems => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<ThreeDotItem> get outsideItem => $_getList(6);

  @$pb.TagNumber(8)
  SessionListExtraInfo get extraInfo => $_getN(7);
  @$pb.TagNumber(8)
  set extraInfo(SessionListExtraInfo value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasExtraInfo() => $_has(7);
  @$pb.TagNumber(8)
  void clearExtraInfo() => $_clearField(8);
  @$pb.TagNumber(8)
  SessionListExtraInfo ensureExtraInfo() => $_ensure(7);
}

class SessionMainReq extends $pb.GeneratedMessage {
  factory SessionMainReq({
    RestrictedMode? restrictedMode,
    PaginationParams? paginationParams,
    SessionFilterType? filterType,
  }) {
    final result = SessionMainReq._();
    if (restrictedMode != null) result.restrictedMode = restrictedMode;
    if (paginationParams != null) result.paginationParams = paginationParams;
    if (filterType != null) result.filterType = filterType;
    return result;
  }

  SessionMainReq._();

  factory SessionMainReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionMainReq()..mergeFromBuffer(data, registry);
  factory SessionMainReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionMainReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionMainReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SessionMainReq.$_createMessage)
    ..aOM<RestrictedMode>(1, _omitFieldNames ? '' : 'restrictedMode',
        subBuilder: RestrictedMode.$_createMessage)
    ..aOM<PaginationParams>(2, _omitFieldNames ? '' : 'paginationParams',
        subBuilder: PaginationParams.$_createMessage)
    ..aE<SessionFilterType>(3, _omitFieldNames ? '' : 'filterType',
        enumValues: SessionFilterType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionMainReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionMainReq copyWith(void Function(SessionMainReq) updates) =>
      super.copyWith((message) => updates(message as SessionMainReq))
          as SessionMainReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SessionMainReq() / SessionMainReq.new instead')
  static SessionMainReq create() => SessionMainReq._();
  static $pb.GeneratedMessage $_createMessage() => SessionMainReq._();
  @$core.override
  SessionMainReq createEmptyInstance() => SessionMainReq._();
  @$core.pragma('dart2js:noInline')
  static SessionMainReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SessionMainReq>(
          SessionMainReq.$_createMessage);
  static SessionMainReq? _defaultInstance;

  @$pb.TagNumber(1)
  RestrictedMode get restrictedMode => $_getN(0);
  @$pb.TagNumber(1)
  set restrictedMode(RestrictedMode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRestrictedMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearRestrictedMode() => $_clearField(1);
  @$pb.TagNumber(1)
  RestrictedMode ensureRestrictedMode() => $_ensure(0);

  @$pb.TagNumber(2)
  PaginationParams get paginationParams => $_getN(1);
  @$pb.TagNumber(2)
  set paginationParams(PaginationParams value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPaginationParams() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaginationParams() => $_clearField(2);
  @$pb.TagNumber(2)
  PaginationParams ensurePaginationParams() => $_ensure(1);

  @$pb.TagNumber(3)
  SessionFilterType get filterType => $_getN(2);
  @$pb.TagNumber(3)
  set filterType(SessionFilterType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFilterType() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilterType() => $_clearField(3);
}

class SessionOperation extends $pb.GeneratedMessage {
  factory SessionOperation({
    OperationContent? pin,
    OperationContent? unpin,
    OperationContent? delete,
    OperationContent? clearUnread,
    OperationContent? unblock,
  }) {
    final result = SessionOperation._();
    if (pin != null) result.pin = pin;
    if (unpin != null) result.unpin = unpin;
    if (delete != null) result.delete = delete;
    if (clearUnread != null) result.clearUnread = clearUnread;
    if (unblock != null) result.unblock = unblock;
    return result;
  }

  SessionOperation._();

  factory SessionOperation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionOperation()..mergeFromBuffer(data, registry);
  factory SessionOperation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionOperation()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionOperation',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SessionOperation.$_createMessage)
    ..aOM<OperationContent>(1, _omitFieldNames ? '' : 'pin',
        subBuilder: OperationContent.$_createMessage)
    ..aOM<OperationContent>(2, _omitFieldNames ? '' : 'unpin',
        subBuilder: OperationContent.$_createMessage)
    ..aOM<OperationContent>(3, _omitFieldNames ? '' : 'delete',
        subBuilder: OperationContent.$_createMessage)
    ..aOM<OperationContent>(4, _omitFieldNames ? '' : 'clearUnread',
        subBuilder: OperationContent.$_createMessage)
    ..aOM<OperationContent>(5, _omitFieldNames ? '' : 'unblock',
        subBuilder: OperationContent.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionOperation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionOperation copyWith(void Function(SessionOperation) updates) =>
      super.copyWith((message) => updates(message as SessionOperation))
          as SessionOperation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SessionOperation() / SessionOperation.new instead')
  static SessionOperation create() => SessionOperation._();
  static $pb.GeneratedMessage $_createMessage() => SessionOperation._();
  @$core.override
  SessionOperation createEmptyInstance() => SessionOperation._();
  @$core.pragma('dart2js:noInline')
  static SessionOperation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SessionOperation>(
          SessionOperation.$_createMessage);
  static SessionOperation? _defaultInstance;

  @$pb.TagNumber(1)
  OperationContent get pin => $_getN(0);
  @$pb.TagNumber(1)
  set pin(OperationContent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPin() => $_has(0);
  @$pb.TagNumber(1)
  void clearPin() => $_clearField(1);
  @$pb.TagNumber(1)
  OperationContent ensurePin() => $_ensure(0);

  @$pb.TagNumber(2)
  OperationContent get unpin => $_getN(1);
  @$pb.TagNumber(2)
  set unpin(OperationContent value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUnpin() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnpin() => $_clearField(2);
  @$pb.TagNumber(2)
  OperationContent ensureUnpin() => $_ensure(1);

  @$pb.TagNumber(3)
  OperationContent get delete => $_getN(2);
  @$pb.TagNumber(3)
  set delete(OperationContent value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDelete() => $_has(2);
  @$pb.TagNumber(3)
  void clearDelete() => $_clearField(3);
  @$pb.TagNumber(3)
  OperationContent ensureDelete() => $_ensure(2);

  @$pb.TagNumber(4)
  OperationContent get clearUnread => $_getN(3);
  @$pb.TagNumber(4)
  set clearUnread(OperationContent value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasClearUnread() => $_has(3);
  @$pb.TagNumber(4)
  void clearClearUnread() => $_clearField(4);
  @$pb.TagNumber(4)
  OperationContent ensureClearUnread() => $_ensure(3);

  @$pb.TagNumber(5)
  OperationContent get unblock => $_getN(4);
  @$pb.TagNumber(5)
  set unblock(OperationContent value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasUnblock() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnblock() => $_clearField(5);
  @$pb.TagNumber(5)
  OperationContent ensureUnblock() => $_ensure(4);
}

class SessionSecondaryReply extends $pb.GeneratedMessage {
  factory SessionSecondaryReply({
    PaginationParams? paginationParams,
    UpdateSessionParams? updateSessionParams,
    $core.Iterable<Session>? sessions,
    $core.Iterable<ThreeDotItem>? threeDotItems,
    $core.Iterable<ThreeDotItem>? outsideItem,
  }) {
    final result = SessionSecondaryReply._();
    if (paginationParams != null) result.paginationParams = paginationParams;
    if (updateSessionParams != null)
      result.updateSessionParams = updateSessionParams;
    if (sessions != null) result.sessions.addAll(sessions);
    if (threeDotItems != null) result.threeDotItems.addAll(threeDotItems);
    if (outsideItem != null) result.outsideItem.addAll(outsideItem);
    return result;
  }

  SessionSecondaryReply._();

  factory SessionSecondaryReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionSecondaryReply()..mergeFromBuffer(data, registry);
  factory SessionSecondaryReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionSecondaryReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionSecondaryReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SessionSecondaryReply.$_createMessage)
    ..aOM<PaginationParams>(1, _omitFieldNames ? '' : 'paginationParams',
        subBuilder: PaginationParams.$_createMessage)
    ..aOM<UpdateSessionParams>(2, _omitFieldNames ? '' : 'updateSessionParams',
        subBuilder: UpdateSessionParams.$_createMessage)
    ..pPM<Session>(3, _omitFieldNames ? '' : 'sessions',
        subBuilder: Session.$_createMessage)
    ..pPM<ThreeDotItem>(4, _omitFieldNames ? '' : 'threeDotItems',
        subBuilder: ThreeDotItem.$_createMessage)
    ..pPM<ThreeDotItem>(5, _omitFieldNames ? '' : 'outsideItem',
        subBuilder: ThreeDotItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionSecondaryReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionSecondaryReply copyWith(
          void Function(SessionSecondaryReply) updates) =>
      super.copyWith((message) => updates(message as SessionSecondaryReply))
          as SessionSecondaryReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SessionSecondaryReply() / SessionSecondaryReply.new instead')
  static SessionSecondaryReply create() => SessionSecondaryReply._();
  static $pb.GeneratedMessage $_createMessage() => SessionSecondaryReply._();
  @$core.override
  SessionSecondaryReply createEmptyInstance() => SessionSecondaryReply._();
  @$core.pragma('dart2js:noInline')
  static SessionSecondaryReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionSecondaryReply>(
          SessionSecondaryReply.$_createMessage);
  static SessionSecondaryReply? _defaultInstance;

  @$pb.TagNumber(1)
  PaginationParams get paginationParams => $_getN(0);
  @$pb.TagNumber(1)
  set paginationParams(PaginationParams value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPaginationParams() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaginationParams() => $_clearField(1);
  @$pb.TagNumber(1)
  PaginationParams ensurePaginationParams() => $_ensure(0);

  @$pb.TagNumber(2)
  UpdateSessionParams get updateSessionParams => $_getN(1);
  @$pb.TagNumber(2)
  set updateSessionParams(UpdateSessionParams value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateSessionParams() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateSessionParams() => $_clearField(2);
  @$pb.TagNumber(2)
  UpdateSessionParams ensureUpdateSessionParams() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<Session> get sessions => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<ThreeDotItem> get threeDotItems => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<ThreeDotItem> get outsideItem => $_getList(4);
}

class SessionSecondaryReq extends $pb.GeneratedMessage {
  factory SessionSecondaryReq({
    RestrictedMode? restrictedMode,
    PaginationParams? paginationParams,
    SessionPageType? pageType,
  }) {
    final result = SessionSecondaryReq._();
    if (restrictedMode != null) result.restrictedMode = restrictedMode;
    if (paginationParams != null) result.paginationParams = paginationParams;
    if (pageType != null) result.pageType = pageType;
    return result;
  }

  SessionSecondaryReq._();

  factory SessionSecondaryReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionSecondaryReq()..mergeFromBuffer(data, registry);
  factory SessionSecondaryReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionSecondaryReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionSecondaryReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SessionSecondaryReq.$_createMessage)
    ..aOM<RestrictedMode>(1, _omitFieldNames ? '' : 'restrictedMode',
        subBuilder: RestrictedMode.$_createMessage)
    ..aOM<PaginationParams>(2, _omitFieldNames ? '' : 'paginationParams',
        subBuilder: PaginationParams.$_createMessage)
    ..aE<SessionPageType>(3, _omitFieldNames ? '' : 'pageType',
        enumValues: SessionPageType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionSecondaryReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionSecondaryReq copyWith(void Function(SessionSecondaryReq) updates) =>
      super.copyWith((message) => updates(message as SessionSecondaryReq))
          as SessionSecondaryReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use SessionSecondaryReq() / SessionSecondaryReq.new instead')
  static SessionSecondaryReq create() => SessionSecondaryReq._();
  static $pb.GeneratedMessage $_createMessage() => SessionSecondaryReq._();
  @$core.override
  SessionSecondaryReq createEmptyInstance() => SessionSecondaryReq._();
  @$core.pragma('dart2js:noInline')
  static SessionSecondaryReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionSecondaryReq>(
          SessionSecondaryReq.$_createMessage);
  static SessionSecondaryReq? _defaultInstance;

  @$pb.TagNumber(1)
  RestrictedMode get restrictedMode => $_getN(0);
  @$pb.TagNumber(1)
  set restrictedMode(RestrictedMode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRestrictedMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearRestrictedMode() => $_clearField(1);
  @$pb.TagNumber(1)
  RestrictedMode ensureRestrictedMode() => $_ensure(0);

  @$pb.TagNumber(2)
  PaginationParams get paginationParams => $_getN(1);
  @$pb.TagNumber(2)
  set paginationParams(PaginationParams value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPaginationParams() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaginationParams() => $_clearField(2);
  @$pb.TagNumber(2)
  PaginationParams ensurePaginationParams() => $_ensure(1);

  @$pb.TagNumber(3)
  SessionPageType get pageType => $_getN(2);
  @$pb.TagNumber(3)
  set pageType(SessionPageType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPageType() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageType() => $_clearField(3);
}

class SessionUpdateReply extends $pb.GeneratedMessage {
  factory SessionUpdateReply({
    Session? session,
  }) {
    final result = SessionUpdateReply._();
    if (session != null) result.session = session;
    return result;
  }

  SessionUpdateReply._();

  factory SessionUpdateReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionUpdateReply()..mergeFromBuffer(data, registry);
  factory SessionUpdateReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionUpdateReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionUpdateReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SessionUpdateReply.$_createMessage)
    ..aOM<Session>(1, _omitFieldNames ? '' : 'session',
        subBuilder: Session.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionUpdateReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionUpdateReply copyWith(void Function(SessionUpdateReply) updates) =>
      super.copyWith((message) => updates(message as SessionUpdateReply))
          as SessionUpdateReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SessionUpdateReply() / SessionUpdateReply.new instead')
  static SessionUpdateReply create() => SessionUpdateReply._();
  static $pb.GeneratedMessage $_createMessage() => SessionUpdateReply._();
  @$core.override
  SessionUpdateReply createEmptyInstance() => SessionUpdateReply._();
  @$core.pragma('dart2js:noInline')
  static SessionUpdateReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionUpdateReply>(
          SessionUpdateReply.$_createMessage);
  static SessionUpdateReply? _defaultInstance;

  @$pb.TagNumber(1)
  Session get session => $_getN(0);
  @$pb.TagNumber(1)
  set session(Session value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);
  @$pb.TagNumber(1)
  Session ensureSession() => $_ensure(0);
}

class SessionUpdateReq extends $pb.GeneratedMessage {
  factory SessionUpdateReq({
    SessionId? sessionId,
    SessionPageType? pageType,
  }) {
    final result = SessionUpdateReq._();
    if (sessionId != null) result.sessionId = sessionId;
    if (pageType != null) result.pageType = pageType;
    return result;
  }

  SessionUpdateReq._();

  factory SessionUpdateReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionUpdateReq()..mergeFromBuffer(data, registry);
  factory SessionUpdateReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionUpdateReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionUpdateReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SessionUpdateReq.$_createMessage)
    ..aOM<SessionId>(1, _omitFieldNames ? '' : 'sessionId',
        subBuilder: SessionId.$_createMessage)
    ..aE<SessionPageType>(2, _omitFieldNames ? '' : 'pageType',
        enumValues: SessionPageType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionUpdateReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionUpdateReq copyWith(void Function(SessionUpdateReq) updates) =>
      super.copyWith((message) => updates(message as SessionUpdateReq))
          as SessionUpdateReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SessionUpdateReq() / SessionUpdateReq.new instead')
  static SessionUpdateReq create() => SessionUpdateReq._();
  static $pb.GeneratedMessage $_createMessage() => SessionUpdateReq._();
  @$core.override
  SessionUpdateReq createEmptyInstance() => SessionUpdateReq._();
  @$core.pragma('dart2js:noInline')
  static SessionUpdateReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SessionUpdateReq>(
          SessionUpdateReq.$_createMessage);
  static SessionUpdateReq? _defaultInstance;

  @$pb.TagNumber(1)
  SessionId get sessionId => $_getN(0);
  @$pb.TagNumber(1)
  set sessionId(SessionId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
  @$pb.TagNumber(1)
  SessionId ensureSessionId() => $_ensure(0);

  @$pb.TagNumber(2)
  SessionPageType get pageType => $_getN(1);
  @$pb.TagNumber(2)
  set pageType(SessionPageType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPageType() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageType() => $_clearField(2);
}

class SessionsFilter extends $pb.GeneratedMessage {
  factory SessionsFilter({
    SessionFilterType? stype,
    $core.String? title,
  }) {
    final result = SessionsFilter._();
    if (stype != null) result.stype = stype;
    if (title != null) result.title = title;
    return result;
  }

  SessionsFilter._();

  factory SessionsFilter.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionsFilter()..mergeFromBuffer(data, registry);
  factory SessionsFilter.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SessionsFilter()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionsFilter',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SessionsFilter.$_createMessage)
    ..aE<SessionFilterType>(1, _omitFieldNames ? '' : 'stype',
        enumValues: SessionFilterType.values)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionsFilter clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionsFilter copyWith(void Function(SessionsFilter) updates) =>
      super.copyWith((message) => updates(message as SessionsFilter))
          as SessionsFilter;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SessionsFilter() / SessionsFilter.new instead')
  static SessionsFilter create() => SessionsFilter._();
  static $pb.GeneratedMessage $_createMessage() => SessionsFilter._();
  @$core.override
  SessionsFilter createEmptyInstance() => SessionsFilter._();
  @$core.pragma('dart2js:noInline')
  static SessionsFilter getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SessionsFilter>(
          SessionsFilter.$_createMessage);
  static SessionsFilter? _defaultInstance;

  @$pb.TagNumber(1)
  SessionFilterType get stype => $_getN(0);
  @$pb.TagNumber(1)
  set stype(SessionFilterType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStype() => $_has(0);
  @$pb.TagNumber(1)
  void clearStype() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);
}

class SetImSettingsReply extends $pb.GeneratedMessage {
  factory SetImSettingsReply({
    $core.String? toast,
  }) {
    final result = SetImSettingsReply._();
    if (toast != null) result.toast = toast;
    return result;
  }

  SetImSettingsReply._();

  factory SetImSettingsReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetImSettingsReply()..mergeFromBuffer(data, registry);
  factory SetImSettingsReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetImSettingsReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetImSettingsReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SetImSettingsReply.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'toast')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetImSettingsReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetImSettingsReply copyWith(void Function(SetImSettingsReply) updates) =>
      super.copyWith((message) => updates(message as SetImSettingsReply))
          as SetImSettingsReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SetImSettingsReply() / SetImSettingsReply.new instead')
  static SetImSettingsReply create() => SetImSettingsReply._();
  static $pb.GeneratedMessage $_createMessage() => SetImSettingsReply._();
  @$core.override
  SetImSettingsReply createEmptyInstance() => SetImSettingsReply._();
  @$core.pragma('dart2js:noInline')
  static SetImSettingsReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetImSettingsReply>(
          SetImSettingsReply.$_createMessage);
  static SetImSettingsReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get toast => $_getSZ(0);
  @$pb.TagNumber(1)
  set toast($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToast() => $_has(0);
  @$pb.TagNumber(1)
  void clearToast() => $_clearField(1);
}

class SetImSettingsReq extends $pb.GeneratedMessage {
  factory SetImSettingsReq({
    $core.Iterable<$core.MapEntry<$core.int, Setting>>? settings,
  }) {
    final result = SetImSettingsReq._();
    if (settings != null) result.settings.addEntries(settings);
    return result;
  }

  SetImSettingsReq._();

  factory SetImSettingsReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetImSettingsReq()..mergeFromBuffer(data, registry);
  factory SetImSettingsReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetImSettingsReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetImSettingsReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SetImSettingsReq.$_createMessage)
    ..m<$core.int, Setting>(1, _omitFieldNames ? '' : 'settings',
        entryClassName: 'SetImSettingsReq.SettingsEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: Setting.$_createMessage,
        valueDefaultOrMaker: Setting.getDefault,
        packageName: const $pb.PackageName('bilibili.app.im.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetImSettingsReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetImSettingsReq copyWith(void Function(SetImSettingsReq) updates) =>
      super.copyWith((message) => updates(message as SetImSettingsReq))
          as SetImSettingsReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SetImSettingsReq() / SetImSettingsReq.new instead')
  static SetImSettingsReq create() => SetImSettingsReq._();
  static $pb.GeneratedMessage $_createMessage() => SetImSettingsReq._();
  @$core.override
  SetImSettingsReq createEmptyInstance() => SetImSettingsReq._();
  @$core.pragma('dart2js:noInline')
  static SetImSettingsReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SetImSettingsReq>(
          SetImSettingsReq.$_createMessage);
  static SetImSettingsReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.int, Setting> get settings => $_getMap(0);
}

enum Setting_Content { switch_1, select, redirect, text, notSet }

class Setting extends $pb.GeneratedMessage {
  factory Setting({
    SettingSwitch? switch_1,
    SettingSelect? select,
    SettingRedirect? redirect,
    SettingText? text,
  }) {
    final result = Setting._();
    if (switch_1 != null) result.switch_1 = switch_1;
    if (select != null) result.select = select;
    if (redirect != null) result.redirect = redirect;
    if (text != null) result.text = text;
    return result;
  }

  Setting._();

  factory Setting.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Setting()..mergeFromBuffer(data, registry);
  factory Setting.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Setting()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Setting_Content> _Setting_ContentByTag = {
    1: Setting_Content.switch_1,
    2: Setting_Content.select,
    3: Setting_Content.redirect,
    4: Setting_Content.text,
    0: Setting_Content.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Setting',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: Setting.$_createMessage)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<SettingSwitch>(1, _omitFieldNames ? '' : 'switch',
        subBuilder: SettingSwitch.$_createMessage)
    ..aOM<SettingSelect>(2, _omitFieldNames ? '' : 'select',
        subBuilder: SettingSelect.$_createMessage)
    ..aOM<SettingRedirect>(3, _omitFieldNames ? '' : 'redirect',
        subBuilder: SettingRedirect.$_createMessage)
    ..aOM<SettingText>(4, _omitFieldNames ? '' : 'text',
        subBuilder: SettingText.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Setting clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Setting copyWith(void Function(Setting) updates) =>
      super.copyWith((message) => updates(message as Setting)) as Setting;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Setting() / Setting.new instead')
  static Setting create() => Setting._();
  static $pb.GeneratedMessage $_createMessage() => Setting._();
  @$core.override
  Setting createEmptyInstance() => Setting._();
  @$core.pragma('dart2js:noInline')
  static Setting getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Setting>(Setting.$_createMessage);
  static Setting? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  Setting_Content whichContent() => _Setting_ContentByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearContent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  SettingSwitch get switch_1 => $_getN(0);
  @$pb.TagNumber(1)
  set switch_1(SettingSwitch value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSwitch_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearSwitch_1() => $_clearField(1);
  @$pb.TagNumber(1)
  SettingSwitch ensureSwitch_1() => $_ensure(0);

  @$pb.TagNumber(2)
  SettingSelect get select => $_getN(1);
  @$pb.TagNumber(2)
  set select(SettingSelect value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSelect() => $_has(1);
  @$pb.TagNumber(2)
  void clearSelect() => $_clearField(2);
  @$pb.TagNumber(2)
  SettingSelect ensureSelect() => $_ensure(1);

  @$pb.TagNumber(3)
  SettingRedirect get redirect => $_getN(2);
  @$pb.TagNumber(3)
  set redirect(SettingRedirect value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRedirect() => $_has(2);
  @$pb.TagNumber(3)
  void clearRedirect() => $_clearField(3);
  @$pb.TagNumber(3)
  SettingRedirect ensureRedirect() => $_ensure(2);

  @$pb.TagNumber(4)
  SettingText get text => $_getN(3);
  @$pb.TagNumber(4)
  set text(SettingText value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasText() => $_has(3);
  @$pb.TagNumber(4)
  void clearText() => $_clearField(4);
  @$pb.TagNumber(4)
  SettingText ensureText() => $_ensure(3);
}

enum SettingRedirect_Content {
  settingPage,
  otherPage,
  popup,
  windowSelect,
  notSet
}

class SettingRedirect extends $pb.GeneratedMessage {
  factory SettingRedirect({
    redirect2SettingPage? settingPage,
    redirect2OtherPage? otherPage,
    $core.String? title,
    $core.String? subtitle,
    $core.String? selectedSummary,
    redirect2Popup? popup,
    redirectWindowSelect? windowSelect,
  }) {
    final result = SettingRedirect._();
    if (settingPage != null) result.settingPage = settingPage;
    if (otherPage != null) result.otherPage = otherPage;
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    if (selectedSummary != null) result.selectedSummary = selectedSummary;
    if (popup != null) result.popup = popup;
    if (windowSelect != null) result.windowSelect = windowSelect;
    return result;
  }

  SettingRedirect._();

  factory SettingRedirect.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettingRedirect()..mergeFromBuffer(data, registry);
  factory SettingRedirect.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettingRedirect()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SettingRedirect_Content>
      _SettingRedirect_ContentByTag = {
    1: SettingRedirect_Content.settingPage,
    2: SettingRedirect_Content.otherPage,
    6: SettingRedirect_Content.popup,
    7: SettingRedirect_Content.windowSelect,
    0: SettingRedirect_Content.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SettingRedirect',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SettingRedirect.$_createMessage)
    ..oo(0, [1, 2, 6, 7])
    ..aOM<redirect2SettingPage>(1, _omitFieldNames ? '' : 'settingPage',
        subBuilder: redirect2SettingPage.$_createMessage)
    ..aOM<redirect2OtherPage>(2, _omitFieldNames ? '' : 'otherPage',
        subBuilder: redirect2OtherPage.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'subtitle')
    ..aOS(5, _omitFieldNames ? '' : 'selectedSummary')
    ..aOM<redirect2Popup>(6, _omitFieldNames ? '' : 'popup',
        subBuilder: redirect2Popup.$_createMessage)
    ..aOM<redirectWindowSelect>(7, _omitFieldNames ? '' : 'windowSelect',
        subBuilder: redirectWindowSelect.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettingRedirect clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettingRedirect copyWith(void Function(SettingRedirect) updates) =>
      super.copyWith((message) => updates(message as SettingRedirect))
          as SettingRedirect;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SettingRedirect() / SettingRedirect.new instead')
  static SettingRedirect create() => SettingRedirect._();
  static $pb.GeneratedMessage $_createMessage() => SettingRedirect._();
  @$core.override
  SettingRedirect createEmptyInstance() => SettingRedirect._();
  @$core.pragma('dart2js:noInline')
  static SettingRedirect getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SettingRedirect>(
          SettingRedirect.$_createMessage);
  static SettingRedirect? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  SettingRedirect_Content whichContent() =>
      _SettingRedirect_ContentByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  void clearContent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  redirect2SettingPage get settingPage => $_getN(0);
  @$pb.TagNumber(1)
  set settingPage(redirect2SettingPage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettingPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettingPage() => $_clearField(1);
  @$pb.TagNumber(1)
  redirect2SettingPage ensureSettingPage() => $_ensure(0);

  @$pb.TagNumber(2)
  redirect2OtherPage get otherPage => $_getN(1);
  @$pb.TagNumber(2)
  set otherPage(redirect2OtherPage value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOtherPage() => $_has(1);
  @$pb.TagNumber(2)
  void clearOtherPage() => $_clearField(2);
  @$pb.TagNumber(2)
  redirect2OtherPage ensureOtherPage() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get subtitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set subtitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubtitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubtitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get selectedSummary => $_getSZ(4);
  @$pb.TagNumber(5)
  set selectedSummary($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSelectedSummary() => $_has(4);
  @$pb.TagNumber(5)
  void clearSelectedSummary() => $_clearField(5);

  @$pb.TagNumber(6)
  redirect2Popup get popup => $_getN(5);
  @$pb.TagNumber(6)
  set popup(redirect2Popup value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPopup() => $_has(5);
  @$pb.TagNumber(6)
  void clearPopup() => $_clearField(6);
  @$pb.TagNumber(6)
  redirect2Popup ensurePopup() => $_ensure(5);

  @$pb.TagNumber(7)
  redirectWindowSelect get windowSelect => $_getN(6);
  @$pb.TagNumber(7)
  set windowSelect(redirectWindowSelect value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasWindowSelect() => $_has(6);
  @$pb.TagNumber(7)
  void clearWindowSelect() => $_clearField(7);
  @$pb.TagNumber(7)
  redirectWindowSelect ensureWindowSelect() => $_ensure(6);
}

class SettingSelect extends $pb.GeneratedMessage {
  factory SettingSelect({
    $core.Iterable<SelectItem>? item,
  }) {
    final result = SettingSelect._();
    if (item != null) result.item.addAll(item);
    return result;
  }

  SettingSelect._();

  factory SettingSelect.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettingSelect()..mergeFromBuffer(data, registry);
  factory SettingSelect.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettingSelect()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SettingSelect',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SettingSelect.$_createMessage)
    ..pPM<SelectItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: SelectItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettingSelect clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettingSelect copyWith(void Function(SettingSelect) updates) =>
      super.copyWith((message) => updates(message as SettingSelect))
          as SettingSelect;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SettingSelect() / SettingSelect.new instead')
  static SettingSelect create() => SettingSelect._();
  static $pb.GeneratedMessage $_createMessage() => SettingSelect._();
  @$core.override
  SettingSelect createEmptyInstance() => SettingSelect._();
  @$core.pragma('dart2js:noInline')
  static SettingSelect getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SettingSelect>(
          SettingSelect.$_createMessage);
  static SettingSelect? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SelectItem> get item => $_getList(0);
}

class SettingSwitch extends $pb.GeneratedMessage {
  factory SettingSwitch({
    $core.bool? switchOn,
    $core.String? title,
    $core.String? subtitle,
  }) {
    final result = SettingSwitch._();
    if (switchOn != null) result.switchOn = switchOn;
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    return result;
  }

  SettingSwitch._();

  factory SettingSwitch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettingSwitch()..mergeFromBuffer(data, registry);
  factory SettingSwitch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettingSwitch()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SettingSwitch',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SettingSwitch.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'switchOn')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'subtitle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettingSwitch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettingSwitch copyWith(void Function(SettingSwitch) updates) =>
      super.copyWith((message) => updates(message as SettingSwitch))
          as SettingSwitch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SettingSwitch() / SettingSwitch.new instead')
  static SettingSwitch create() => SettingSwitch._();
  static $pb.GeneratedMessage $_createMessage() => SettingSwitch._();
  @$core.override
  SettingSwitch createEmptyInstance() => SettingSwitch._();
  @$core.pragma('dart2js:noInline')
  static SettingSwitch getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SettingSwitch>(
          SettingSwitch.$_createMessage);
  static SettingSwitch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get switchOn => $_getBF(0);
  @$pb.TagNumber(1)
  set switchOn($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSwitchOn() => $_has(0);
  @$pb.TagNumber(1)
  void clearSwitchOn() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get subtitle => $_getSZ(2);
  @$pb.TagNumber(3)
  set subtitle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubtitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubtitle() => $_clearField(3);
}

class SettingText extends $pb.GeneratedMessage {
  factory SettingText({
    $core.String? text,
  }) {
    final result = SettingText._();
    if (text != null) result.text = text;
    return result;
  }

  SettingText._();

  factory SettingText.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettingText()..mergeFromBuffer(data, registry);
  factory SettingText.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettingText()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SettingText',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SettingText.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettingText clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettingText copyWith(void Function(SettingText) updates) =>
      super.copyWith((message) => updates(message as SettingText))
          as SettingText;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SettingText() / SettingText.new instead')
  static SettingText create() => SettingText._();
  static $pb.GeneratedMessage $_createMessage() => SettingText._();
  @$core.override
  SettingText createEmptyInstance() => SettingText._();
  @$core.pragma('dart2js:noInline')
  static SettingText getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SettingText>(
          SettingText.$_createMessage);
  static SettingText? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);
}

class SystemId extends $pb.GeneratedMessage {
  factory SystemId({
    SessionType? type,
  }) {
    final result = SystemId._();
    if (type != null) result.type = type;
    return result;
  }

  SystemId._();

  factory SystemId.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SystemId()..mergeFromBuffer(data, registry);
  factory SystemId.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SystemId()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SystemId',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: SystemId.$_createMessage)
    ..aE<SessionType>(1, _omitFieldNames ? '' : 'type',
        enumValues: SessionType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SystemId clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SystemId copyWith(void Function(SystemId) updates) =>
      super.copyWith((message) => updates(message as SystemId)) as SystemId;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SystemId() / SystemId.new instead')
  static SystemId create() => SystemId._();
  static $pb.GeneratedMessage $_createMessage() => SystemId._();
  @$core.override
  SystemId createEmptyInstance() => SystemId._();
  @$core.pragma('dart2js:noInline')
  static SystemId getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SystemId>(SystemId.$_createMessage);
  static SystemId? _defaultInstance;

  @$pb.TagNumber(1)
  SessionType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(SessionType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);
}

class ThreeDotItem extends $pb.GeneratedMessage {
  factory ThreeDotItem({
    $core.String? title,
    $core.String? icon,
    $core.String? url,
    ThreeDotItemType? type,
    $core.bool? hasRedDot,
  }) {
    final result = ThreeDotItem._();
    if (title != null) result.title = title;
    if (icon != null) result.icon = icon;
    if (url != null) result.url = url;
    if (type != null) result.type = type;
    if (hasRedDot != null) result.hasRedDot = hasRedDot;
    return result;
  }

  ThreeDotItem._();

  factory ThreeDotItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreeDotItem()..mergeFromBuffer(data, registry);
  factory ThreeDotItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ThreeDotItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreeDotItem',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: ThreeDotItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'icon')
    ..aOS(3, _omitFieldNames ? '' : 'url')
    ..aE<ThreeDotItemType>(4, _omitFieldNames ? '' : 'type',
        enumValues: ThreeDotItemType.values)
    ..aOB(5, _omitFieldNames ? '' : 'hasRedDot')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreeDotItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreeDotItem copyWith(void Function(ThreeDotItem) updates) =>
      super.copyWith((message) => updates(message as ThreeDotItem))
          as ThreeDotItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ThreeDotItem() / ThreeDotItem.new instead')
  static ThreeDotItem create() => ThreeDotItem._();
  static $pb.GeneratedMessage $_createMessage() => ThreeDotItem._();
  @$core.override
  ThreeDotItem createEmptyInstance() => ThreeDotItem._();
  @$core.pragma('dart2js:noInline')
  static ThreeDotItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ThreeDotItem>(
          ThreeDotItem.$_createMessage);
  static ThreeDotItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get icon => $_getSZ(1);
  @$pb.TagNumber(2)
  set icon($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIcon() => $_has(1);
  @$pb.TagNumber(2)
  void clearIcon() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get url => $_getSZ(2);
  @$pb.TagNumber(3)
  set url($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  ThreeDotItemType get type => $_getN(3);
  @$pb.TagNumber(4)
  set type(ThreeDotItemType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasType() => $_has(3);
  @$pb.TagNumber(4)
  void clearType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get hasRedDot => $_getBF(4);
  @$pb.TagNumber(5)
  set hasRedDot($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHasRedDot() => $_has(4);
  @$pb.TagNumber(5)
  void clearHasRedDot() => $_clearField(5);
}

class UnPinSessionReply extends $pb.GeneratedMessage {
  factory UnPinSessionReply({
    $fixnum.Int64? sequenceNumber,
  }) {
    final result = UnPinSessionReply._();
    if (sequenceNumber != null) result.sequenceNumber = sequenceNumber;
    return result;
  }

  UnPinSessionReply._();

  factory UnPinSessionReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UnPinSessionReply()..mergeFromBuffer(data, registry);
  factory UnPinSessionReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UnPinSessionReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnPinSessionReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: UnPinSessionReply.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'sequenceNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnPinSessionReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnPinSessionReply copyWith(void Function(UnPinSessionReply) updates) =>
      super.copyWith((message) => updates(message as UnPinSessionReply))
          as UnPinSessionReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UnPinSessionReply() / UnPinSessionReply.new instead')
  static UnPinSessionReply create() => UnPinSessionReply._();
  static $pb.GeneratedMessage $_createMessage() => UnPinSessionReply._();
  @$core.override
  UnPinSessionReply createEmptyInstance() => UnPinSessionReply._();
  @$core.pragma('dart2js:noInline')
  static UnPinSessionReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnPinSessionReply>(
          UnPinSessionReply.$_createMessage);
  static UnPinSessionReply? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get sequenceNumber => $_getI64(0);
  @$pb.TagNumber(1)
  set sequenceNumber($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSequenceNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearSequenceNumber() => $_clearField(1);
}

class UnPinSessionReq extends $pb.GeneratedMessage {
  factory UnPinSessionReq({
    SessionId? sessionId,
  }) {
    final result = UnPinSessionReq._();
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  UnPinSessionReq._();

  factory UnPinSessionReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UnPinSessionReq()..mergeFromBuffer(data, registry);
  factory UnPinSessionReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UnPinSessionReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnPinSessionReq',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: UnPinSessionReq.$_createMessage)
    ..aOM<SessionId>(1, _omitFieldNames ? '' : 'sessionId',
        subBuilder: SessionId.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnPinSessionReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnPinSessionReq copyWith(void Function(UnPinSessionReq) updates) =>
      super.copyWith((message) => updates(message as UnPinSessionReq))
          as UnPinSessionReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UnPinSessionReq() / UnPinSessionReq.new instead')
  static UnPinSessionReq create() => UnPinSessionReq._();
  static $pb.GeneratedMessage $_createMessage() => UnPinSessionReq._();
  @$core.override
  UnPinSessionReq createEmptyInstance() => UnPinSessionReq._();
  @$core.pragma('dart2js:noInline')
  static UnPinSessionReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnPinSessionReq>(
          UnPinSessionReq.$_createMessage);
  static UnPinSessionReq? _defaultInstance;

  @$pb.TagNumber(1)
  SessionId get sessionId => $_getN(0);
  @$pb.TagNumber(1)
  set sessionId(SessionId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);
  @$pb.TagNumber(1)
  SessionId ensureSessionId() => $_ensure(0);
}

class Unread extends $pb.GeneratedMessage {
  factory Unread({
    UnreadStyle? style,
    $fixnum.Int64? number,
    $core.String? numberShow,
  }) {
    final result = Unread._();
    if (style != null) result.style = style;
    if (number != null) result.number = number;
    if (numberShow != null) result.numberShow = numberShow;
    return result;
  }

  Unread._();

  factory Unread.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Unread()..mergeFromBuffer(data, registry);
  factory Unread.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Unread()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Unread',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: Unread.$_createMessage)
    ..aE<UnreadStyle>(1, _omitFieldNames ? '' : 'style',
        enumValues: UnreadStyle.values)
    ..aInt64(2, _omitFieldNames ? '' : 'number')
    ..aOS(3, _omitFieldNames ? '' : 'numberShow')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Unread clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Unread copyWith(void Function(Unread) updates) =>
      super.copyWith((message) => updates(message as Unread)) as Unread;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Unread() / Unread.new instead')
  static Unread create() => Unread._();
  static $pb.GeneratedMessage $_createMessage() => Unread._();
  @$core.override
  Unread createEmptyInstance() => Unread._();
  @$core.pragma('dart2js:noInline')
  static Unread getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Unread>(Unread.$_createMessage);
  static Unread? _defaultInstance;

  @$pb.TagNumber(1)
  UnreadStyle get style => $_getN(0);
  @$pb.TagNumber(1)
  set style(UnreadStyle value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStyle() => $_has(0);
  @$pb.TagNumber(1)
  void clearStyle() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get number => $_getI64(1);
  @$pb.TagNumber(2)
  set number($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get numberShow => $_getSZ(2);
  @$pb.TagNumber(3)
  set numberShow($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNumberShow() => $_has(2);
  @$pb.TagNumber(3)
  void clearNumberShow() => $_clearField(3);
}

class UpdateSessionParams extends $pb.GeneratedMessage {
  factory UpdateSessionParams({
    $core.Iterable<$core.MapEntry<$core.int, Offset>>? maxSessionTs,
  }) {
    final result = UpdateSessionParams._();
    if (maxSessionTs != null) result.maxSessionTs.addEntries(maxSessionTs);
    return result;
  }

  UpdateSessionParams._();

  factory UpdateSessionParams.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateSessionParams()..mergeFromBuffer(data, registry);
  factory UpdateSessionParams.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateSessionParams()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSessionParams',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: UpdateSessionParams.$_createMessage)
    ..m<$core.int, Offset>(1, _omitFieldNames ? '' : 'maxSessionTs',
        entryClassName: 'UpdateSessionParams.MaxSessionTsEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: Offset.$_createMessage,
        valueDefaultOrMaker: Offset.getDefault,
        packageName: const $pb.PackageName('bilibili.app.im.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSessionParams clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSessionParams copyWith(void Function(UpdateSessionParams) updates) =>
      super.copyWith((message) => updates(message as UpdateSessionParams))
          as UpdateSessionParams;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use UpdateSessionParams() / UpdateSessionParams.new instead')
  static UpdateSessionParams create() => UpdateSessionParams._();
  static $pb.GeneratedMessage $_createMessage() => UpdateSessionParams._();
  @$core.override
  UpdateSessionParams createEmptyInstance() => UpdateSessionParams._();
  @$core.pragma('dart2js:noInline')
  static UpdateSessionParams getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateSessionParams>(
          UpdateSessionParams.$_createMessage);
  static UpdateSessionParams? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.int, Offset> get maxSessionTs => $_getMap(0);
}

class UserLabel extends $pb.GeneratedMessage {
  factory UserLabel({
    LabelType? type,
    UserLabelStyle? style,
  }) {
    final result = UserLabel._();
    if (type != null) result.type = type;
    if (style != null) result.style = style;
    return result;
  }

  UserLabel._();

  factory UserLabel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserLabel()..mergeFromBuffer(data, registry);
  factory UserLabel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserLabel()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserLabel',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: UserLabel.$_createMessage)
    ..aE<LabelType>(1, _omitFieldNames ? '' : 'type',
        enumValues: LabelType.values)
    ..aOM<UserLabelStyle>(2, _omitFieldNames ? '' : 'style',
        subBuilder: UserLabelStyle.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserLabel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserLabel copyWith(void Function(UserLabel) updates) =>
      super.copyWith((message) => updates(message as UserLabel)) as UserLabel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UserLabel() / UserLabel.new instead')
  static UserLabel create() => UserLabel._();
  static $pb.GeneratedMessage $_createMessage() => UserLabel._();
  @$core.override
  UserLabel createEmptyInstance() => UserLabel._();
  @$core.pragma('dart2js:noInline')
  static UserLabel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserLabel>(UserLabel.$_createMessage);
  static UserLabel? _defaultInstance;

  @$pb.TagNumber(1)
  LabelType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(LabelType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  UserLabelStyle get style => $_getN(1);
  @$pb.TagNumber(2)
  set style(UserLabelStyle value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStyle() => $_has(1);
  @$pb.TagNumber(2)
  void clearStyle() => $_clearField(2);
  @$pb.TagNumber(2)
  UserLabelStyle ensureStyle() => $_ensure(1);
}

enum UserLabelStyle_Style {
  borderedLabel,
  filledLabel,
  imageLabel,
  medalLabel,
  notSet
}

class UserLabelStyle extends $pb.GeneratedMessage {
  factory UserLabelStyle({
    BorderedLabel? borderedLabel,
    FilledLabel? filledLabel,
    ImageLabel? imageLabel,
    Medal? medalLabel,
  }) {
    final result = UserLabelStyle._();
    if (borderedLabel != null) result.borderedLabel = borderedLabel;
    if (filledLabel != null) result.filledLabel = filledLabel;
    if (imageLabel != null) result.imageLabel = imageLabel;
    if (medalLabel != null) result.medalLabel = medalLabel;
    return result;
  }

  UserLabelStyle._();

  factory UserLabelStyle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserLabelStyle()..mergeFromBuffer(data, registry);
  factory UserLabelStyle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserLabelStyle()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, UserLabelStyle_Style>
      _UserLabelStyle_StyleByTag = {
    2: UserLabelStyle_Style.borderedLabel,
    3: UserLabelStyle_Style.filledLabel,
    4: UserLabelStyle_Style.imageLabel,
    5: UserLabelStyle_Style.medalLabel,
    0: UserLabelStyle_Style.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserLabelStyle',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: UserLabelStyle.$_createMessage)
    ..oo(0, [2, 3, 4, 5])
    ..aOM<BorderedLabel>(2, _omitFieldNames ? '' : 'borderedLabel',
        subBuilder: BorderedLabel.$_createMessage)
    ..aOM<FilledLabel>(3, _omitFieldNames ? '' : 'filledLabel',
        subBuilder: FilledLabel.$_createMessage)
    ..aOM<ImageLabel>(4, _omitFieldNames ? '' : 'imageLabel',
        subBuilder: ImageLabel.$_createMessage)
    ..aOM<Medal>(5, _omitFieldNames ? '' : 'medalLabel',
        subBuilder: Medal.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserLabelStyle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserLabelStyle copyWith(void Function(UserLabelStyle) updates) =>
      super.copyWith((message) => updates(message as UserLabelStyle))
          as UserLabelStyle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UserLabelStyle() / UserLabelStyle.new instead')
  static UserLabelStyle create() => UserLabelStyle._();
  static $pb.GeneratedMessage $_createMessage() => UserLabelStyle._();
  @$core.override
  UserLabelStyle createEmptyInstance() => UserLabelStyle._();
  @$core.pragma('dart2js:noInline')
  static UserLabelStyle getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserLabelStyle>(
          UserLabelStyle.$_createMessage);
  static UserLabelStyle? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  UserLabelStyle_Style whichStyle() =>
      _UserLabelStyle_StyleByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearStyle() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(2)
  BorderedLabel get borderedLabel => $_getN(0);
  @$pb.TagNumber(2)
  set borderedLabel(BorderedLabel value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasBorderedLabel() => $_has(0);
  @$pb.TagNumber(2)
  void clearBorderedLabel() => $_clearField(2);
  @$pb.TagNumber(2)
  BorderedLabel ensureBorderedLabel() => $_ensure(0);

  @$pb.TagNumber(3)
  FilledLabel get filledLabel => $_getN(1);
  @$pb.TagNumber(3)
  set filledLabel(FilledLabel value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFilledLabel() => $_has(1);
  @$pb.TagNumber(3)
  void clearFilledLabel() => $_clearField(3);
  @$pb.TagNumber(3)
  FilledLabel ensureFilledLabel() => $_ensure(1);

  @$pb.TagNumber(4)
  ImageLabel get imageLabel => $_getN(2);
  @$pb.TagNumber(4)
  set imageLabel(ImageLabel value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasImageLabel() => $_has(2);
  @$pb.TagNumber(4)
  void clearImageLabel() => $_clearField(4);
  @$pb.TagNumber(4)
  ImageLabel ensureImageLabel() => $_ensure(2);

  @$pb.TagNumber(5)
  Medal get medalLabel => $_getN(3);
  @$pb.TagNumber(5)
  set medalLabel(Medal value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMedalLabel() => $_has(3);
  @$pb.TagNumber(5)
  void clearMedalLabel() => $_clearField(5);
  @$pb.TagNumber(5)
  Medal ensureMedalLabel() => $_ensure(3);
}

class redirect2OtherPage extends $pb.GeneratedMessage {
  factory redirect2OtherPage({
    $core.String? url,
  }) {
    final result = redirect2OtherPage._();
    if (url != null) result.url = url;
    return result;
  }

  redirect2OtherPage._();

  factory redirect2OtherPage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      redirect2OtherPage()..mergeFromBuffer(data, registry);
  factory redirect2OtherPage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      redirect2OtherPage()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'redirect2OtherPage',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: redirect2OtherPage.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  redirect2OtherPage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  redirect2OtherPage copyWith(void Function(redirect2OtherPage) updates) =>
      super.copyWith((message) => updates(message as redirect2OtherPage))
          as redirect2OtherPage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use redirect2OtherPage() / redirect2OtherPage.new instead')
  static redirect2OtherPage create() => redirect2OtherPage._();
  static $pb.GeneratedMessage $_createMessage() => redirect2OtherPage._();
  @$core.override
  redirect2OtherPage createEmptyInstance() => redirect2OtherPage._();
  @$core.pragma('dart2js:noInline')
  static redirect2OtherPage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<redirect2OtherPage>(
          redirect2OtherPage.$_createMessage);
  static redirect2OtherPage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);
}

class redirect2Popup extends $pb.GeneratedMessage {
  factory redirect2Popup({
    $core.String? title,
    $core.String? subtitle,
    $core.String? url,
  }) {
    final result = redirect2Popup._();
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    if (url != null) result.url = url;
    return result;
  }

  redirect2Popup._();

  factory redirect2Popup.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      redirect2Popup()..mergeFromBuffer(data, registry);
  factory redirect2Popup.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      redirect2Popup()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'redirect2Popup',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: redirect2Popup.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'subtitle')
    ..aOS(3, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  redirect2Popup clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  redirect2Popup copyWith(void Function(redirect2Popup) updates) =>
      super.copyWith((message) => updates(message as redirect2Popup))
          as redirect2Popup;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use redirect2Popup() / redirect2Popup.new instead')
  static redirect2Popup create() => redirect2Popup._();
  static $pb.GeneratedMessage $_createMessage() => redirect2Popup._();
  @$core.override
  redirect2Popup createEmptyInstance() => redirect2Popup._();
  @$core.pragma('dart2js:noInline')
  static redirect2Popup getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<redirect2Popup>(
          redirect2Popup.$_createMessage);
  static redirect2Popup? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get subtitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set subtitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubtitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubtitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get url => $_getSZ(2);
  @$pb.TagNumber(3)
  set url($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearUrl() => $_clearField(3);
}

class redirect2SettingPage extends $pb.GeneratedMessage {
  factory redirect2SettingPage({
    $core.Iterable<$core.MapEntry<$core.int, Setting>>? subSettings,
    $core.String? pageTitle,
    $core.String? url,
    IMSettingType? parentSettingType,
  }) {
    final result = redirect2SettingPage._();
    if (subSettings != null) result.subSettings.addEntries(subSettings);
    if (pageTitle != null) result.pageTitle = pageTitle;
    if (url != null) result.url = url;
    if (parentSettingType != null) result.parentSettingType = parentSettingType;
    return result;
  }

  redirect2SettingPage._();

  factory redirect2SettingPage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      redirect2SettingPage()..mergeFromBuffer(data, registry);
  factory redirect2SettingPage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      redirect2SettingPage()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'redirect2SettingPage',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: redirect2SettingPage.$_createMessage)
    ..m<$core.int, Setting>(1, _omitFieldNames ? '' : 'subSettings',
        entryClassName: 'redirect2SettingPage.SubSettingsEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: Setting.$_createMessage,
        valueDefaultOrMaker: Setting.getDefault,
        packageName: const $pb.PackageName('bilibili.app.im.v1'))
    ..aOS(2, _omitFieldNames ? '' : 'pageTitle')
    ..aOS(3, _omitFieldNames ? '' : 'url')
    ..aE<IMSettingType>(4, _omitFieldNames ? '' : 'parentSettingType',
        enumValues: IMSettingType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  redirect2SettingPage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  redirect2SettingPage copyWith(void Function(redirect2SettingPage) updates) =>
      super.copyWith((message) => updates(message as redirect2SettingPage))
          as redirect2SettingPage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use redirect2SettingPage() / redirect2SettingPage.new instead')
  static redirect2SettingPage create() => redirect2SettingPage._();
  static $pb.GeneratedMessage $_createMessage() => redirect2SettingPage._();
  @$core.override
  redirect2SettingPage createEmptyInstance() => redirect2SettingPage._();
  @$core.pragma('dart2js:noInline')
  static redirect2SettingPage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<redirect2SettingPage>(
          redirect2SettingPage.$_createMessage);
  static redirect2SettingPage? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.int, Setting> get subSettings => $_getMap(0);

  @$pb.TagNumber(2)
  $core.String get pageTitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set pageTitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get url => $_getSZ(2);
  @$pb.TagNumber(3)
  set url($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  IMSettingType get parentSettingType => $_getN(3);
  @$pb.TagNumber(4)
  set parentSettingType(IMSettingType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasParentSettingType() => $_has(3);
  @$pb.TagNumber(4)
  void clearParentSettingType() => $_clearField(4);
}

class redirectWindowSelect extends $pb.GeneratedMessage {
  factory redirectWindowSelect({
    $core.String? title,
    $core.Iterable<SelectItem>? item,
  }) {
    final result = redirectWindowSelect._();
    if (title != null) result.title = title;
    if (item != null) result.item.addAll(item);
    return result;
  }

  redirectWindowSelect._();

  factory redirectWindowSelect.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      redirectWindowSelect()..mergeFromBuffer(data, registry);
  factory redirectWindowSelect.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      redirectWindowSelect()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'redirectWindowSelect',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.app.im.v1'),
      createEmptyInstance: redirectWindowSelect.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..pPM<SelectItem>(2, _omitFieldNames ? '' : 'item',
        subBuilder: SelectItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  redirectWindowSelect clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  redirectWindowSelect copyWith(void Function(redirectWindowSelect) updates) =>
      super.copyWith((message) => updates(message as redirectWindowSelect))
          as redirectWindowSelect;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use redirectWindowSelect() / redirectWindowSelect.new instead')
  static redirectWindowSelect create() => redirectWindowSelect._();
  static $pb.GeneratedMessage $_createMessage() => redirectWindowSelect._();
  @$core.override
  redirectWindowSelect createEmptyInstance() => redirectWindowSelect._();
  @$core.pragma('dart2js:noInline')
  static redirectWindowSelect getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<redirectWindowSelect>(
          redirectWindowSelect.$_createMessage);
  static redirectWindowSelect? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<SelectItem> get item => $_getList(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
