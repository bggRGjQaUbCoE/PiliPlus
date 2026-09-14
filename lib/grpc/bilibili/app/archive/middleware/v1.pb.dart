// This is a generated file - do not edit.
//
// Generated from bilibili/app/archive/middleware/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'v1.pbenum.dart';

class PlayerArgs extends $pb.GeneratedMessage {
  factory PlayerArgs({
    $fixnum.Int64? qn,
    $fixnum.Int64? fnver,
    $fixnum.Int64? fnval,
    $fixnum.Int64? forceHost,
    $fixnum.Int64? voiceBalance,
    QnPolicy? qnPolicy,
  }) {
    final result = PlayerArgs._();
    if (qn != null) result.qn = qn;
    if (fnver != null) result.fnver = fnver;
    if (fnval != null) result.fnval = fnval;
    if (forceHost != null) result.forceHost = forceHost;
    if (voiceBalance != null) result.voiceBalance = voiceBalance;
    if (qnPolicy != null) result.qnPolicy = qnPolicy;
    return result;
  }

  PlayerArgs._();

  factory PlayerArgs.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayerArgs()..mergeFromBuffer(data, registry);
  factory PlayerArgs.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayerArgs()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerArgs',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.archive.middleware.v1'),
      createEmptyInstance: PlayerArgs.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'qn')
    ..aInt64(2, _omitFieldNames ? '' : 'fnver')
    ..aInt64(3, _omitFieldNames ? '' : 'fnval')
    ..aInt64(4, _omitFieldNames ? '' : 'forceHost')
    ..aInt64(5, _omitFieldNames ? '' : 'voiceBalance')
    ..aE<QnPolicy>(6, _omitFieldNames ? '' : 'qnPolicy',
        enumValues: QnPolicy.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerArgs clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerArgs copyWith(void Function(PlayerArgs) updates) =>
      super.copyWith((message) => updates(message as PlayerArgs)) as PlayerArgs;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PlayerArgs() / PlayerArgs.new instead')
  static PlayerArgs create() => PlayerArgs._();
  static $pb.GeneratedMessage $_createMessage() => PlayerArgs._();
  @$core.override
  PlayerArgs createEmptyInstance() => PlayerArgs._();
  @$core.pragma('dart2js:noInline')
  static PlayerArgs getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerArgs>(PlayerArgs.$_createMessage);
  static PlayerArgs? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get qn => $_getI64(0);
  @$pb.TagNumber(1)
  set qn($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQn() => $_has(0);
  @$pb.TagNumber(1)
  void clearQn() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get fnver => $_getI64(1);
  @$pb.TagNumber(2)
  set fnver($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFnver() => $_has(1);
  @$pb.TagNumber(2)
  void clearFnver() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get fnval => $_getI64(2);
  @$pb.TagNumber(3)
  set fnval($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFnval() => $_has(2);
  @$pb.TagNumber(3)
  void clearFnval() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get forceHost => $_getI64(3);
  @$pb.TagNumber(4)
  set forceHost($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasForceHost() => $_has(3);
  @$pb.TagNumber(4)
  void clearForceHost() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get voiceBalance => $_getI64(4);
  @$pb.TagNumber(5)
  set voiceBalance($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVoiceBalance() => $_has(4);
  @$pb.TagNumber(5)
  void clearVoiceBalance() => $_clearField(5);

  @$pb.TagNumber(6)
  QnPolicy get qnPolicy => $_getN(5);
  @$pb.TagNumber(6)
  set qnPolicy(QnPolicy value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasQnPolicy() => $_has(5);
  @$pb.TagNumber(6)
  void clearQnPolicy() => $_clearField(6);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
