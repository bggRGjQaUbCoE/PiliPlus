//
//  Generated code. Do not modify.
//  source: status.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'status.pbenum.dart';

export 'status.pbenum.dart';

class BiliStatus extends $pb.GeneratedMessage {
  factory BiliStatus({
    $core.int? code,
    $core.String? message,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  BiliStatus._() : super();
  factory BiliStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BiliStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BiliStatus', package: const $pb.PackageName(_omitMessageNames ? '' : 'google.rpc'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BiliStatus clone() => BiliStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BiliStatus copyWith(void Function(BiliStatus) updates) => super.copyWith((message) => updates(message as BiliStatus)) as BiliStatus;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BiliStatus create() => BiliStatus._();
  BiliStatus createEmptyInstance() => create();
  static $pb.PbList<BiliStatus> createRepeated() => $pb.PbList<BiliStatus>();
  @$core.pragma('dart2js:noInline')
  static BiliStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BiliStatus>(create);
  static BiliStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class GrpcDetail extends $pb.GeneratedMessage {
  factory GrpcDetail({
    $core.String? grpcType,
    BiliStatus? status,
  }) {
    final $result = create();
    if (grpcType != null) {
      $result.grpcType = grpcType;
    }
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  GrpcDetail._() : super();
  factory GrpcDetail.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GrpcDetail.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GrpcDetail', package: const $pb.PackageName(_omitMessageNames ? '' : 'google.rpc'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'grpcType')
    ..aOM<BiliStatus>(2, _omitFieldNames ? '' : 'status', subBuilder: BiliStatus.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GrpcDetail clone() => GrpcDetail()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GrpcDetail copyWith(void Function(GrpcDetail) updates) => super.copyWith((message) => updates(message as GrpcDetail)) as GrpcDetail;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GrpcDetail create() => GrpcDetail._();
  GrpcDetail createEmptyInstance() => create();
  static $pb.PbList<GrpcDetail> createRepeated() => $pb.PbList<GrpcDetail>();
  @$core.pragma('dart2js:noInline')
  static GrpcDetail getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GrpcDetail>(create);
  static GrpcDetail? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get grpcType => $_getSZ(0);
  @$pb.TagNumber(1)
  set grpcType($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGrpcType() => $_has(0);
  @$pb.TagNumber(1)
  void clearGrpcType() => clearField(1);

  @$pb.TagNumber(2)
  BiliStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(BiliStatus v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => clearField(2);
  @$pb.TagNumber(2)
  BiliStatus ensureStatus() => $_ensure(1);
}

class Status extends $pb.GeneratedMessage {
  factory Status({
    Code? code,
    $core.String? message,
    $core.Iterable<GrpcDetail>? details,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (message != null) {
      $result.message = message;
    }
    if (details != null) {
      $result.details.addAll(details);
    }
    return $result;
  }
  Status._() : super();
  factory Status.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Status.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Status', package: const $pb.PackageName(_omitMessageNames ? '' : 'google.rpc'), createEmptyInstance: create)
    ..e<Code>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.OE, defaultOrMaker: Code.OK, valueOf: Code.valueOf, enumValues: Code.values)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..pc<GrpcDetail>(3, _omitFieldNames ? '' : 'details', $pb.PbFieldType.PM, subBuilder: GrpcDetail.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Status clone() => Status()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Status copyWith(void Function(Status) updates) => super.copyWith((message) => updates(message as Status)) as Status;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Status create() => Status._();
  Status createEmptyInstance() => create();
  static $pb.PbList<Status> createRepeated() => $pb.PbList<Status>();
  @$core.pragma('dart2js:noInline')
  static Status getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Status>(create);
  static Status? _defaultInstance;

  /// The status code, which should be an enum value of
  /// [google.rpc.Code][google.rpc.Code].
  @$pb.TagNumber(1)
  Code get code => $_getN(0);
  @$pb.TagNumber(1)
  set code(Code v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  /// A developer-facing error message, which should be in English. Any
  /// user-facing error message should be localized and sent in the
  /// [google.rpc.Status.details][google.rpc.Status.details] field, or localized
  /// by the client.
  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  /// A list of messages that carry the error details.  There is a common set of
  /// message types for APIs to use.
  @$pb.TagNumber(3)
  $core.List<GrpcDetail> get details => $_getList(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
