// This is a generated file - do not edit.
//
// Generated from bilibili/metadata/network.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'network.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'network.pbenum.dart';

class NetQuality extends $pb.GeneratedMessage {
  factory NetQuality({
    $core.double? successRate,
    $core.int? speed,
    $fixnum.Int64? speedTimestamp,
    $core.int? netType,
  }) {
    final result = NetQuality._();
    if (successRate != null) result.successRate = successRate;
    if (speed != null) result.speed = speed;
    if (speedTimestamp != null) result.speedTimestamp = speedTimestamp;
    if (netType != null) result.netType = netType;
    return result;
  }

  NetQuality._();

  factory NetQuality.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NetQuality()..mergeFromBuffer(data, registry);
  factory NetQuality.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NetQuality()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NetQuality',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.metadata.network'),
      createEmptyInstance: NetQuality.$_createMessage)
    ..aD(1, _omitFieldNames ? '' : 'successRate', fieldType: $pb.PbFieldType.OF)
    ..aI(2, _omitFieldNames ? '' : 'speed')
    ..aInt64(3, _omitFieldNames ? '' : 'speedTimestamp')
    ..aI(4, _omitFieldNames ? '' : 'netType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NetQuality clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NetQuality copyWith(void Function(NetQuality) updates) =>
      super.copyWith((message) => updates(message as NetQuality)) as NetQuality;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use NetQuality() / NetQuality.new instead')
  static NetQuality create() => NetQuality._();
  static $pb.GeneratedMessage $_createMessage() => NetQuality._();
  @$core.override
  NetQuality createEmptyInstance() => NetQuality._();
  @$core.pragma('dart2js:noInline')
  static NetQuality getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NetQuality>(NetQuality.$_createMessage);
  static NetQuality? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get successRate => $_getN(0);
  @$pb.TagNumber(1)
  set successRate($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccessRate() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccessRate() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get speed => $_getIZ(1);
  @$pb.TagNumber(2)
  set speed($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSpeed() => $_has(1);
  @$pb.TagNumber(2)
  void clearSpeed() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get speedTimestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set speedTimestamp($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSpeedTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearSpeedTimestamp() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get netType => $_getIZ(3);
  @$pb.TagNumber(4)
  set netType($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNetType() => $_has(3);
  @$pb.TagNumber(4)
  void clearNetType() => $_clearField(4);
}

class Network extends $pb.GeneratedMessage {
  factory Network({
    NetworkType? type,
    TFType? tf,
    $core.String? oid,
  }) {
    final result = Network._();
    if (type != null) result.type = type;
    if (tf != null) result.tf = tf;
    if (oid != null) result.oid = oid;
    return result;
  }

  Network._();

  factory Network.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Network()..mergeFromBuffer(data, registry);
  factory Network.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Network()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Network',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.metadata.network'),
      createEmptyInstance: Network.$_createMessage)
    ..aE<NetworkType>(1, _omitFieldNames ? '' : 'type',
        enumValues: NetworkType.values)
    ..aE<TFType>(2, _omitFieldNames ? '' : 'tf', enumValues: TFType.values)
    ..aOS(3, _omitFieldNames ? '' : 'oid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Network clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Network copyWith(void Function(Network) updates) =>
      super.copyWith((message) => updates(message as Network)) as Network;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Network() / Network.new instead')
  static Network create() => Network._();
  static $pb.GeneratedMessage $_createMessage() => Network._();
  @$core.override
  Network createEmptyInstance() => Network._();
  @$core.pragma('dart2js:noInline')
  static Network getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Network>(Network.$_createMessage);
  static Network? _defaultInstance;

  @$pb.TagNumber(1)
  NetworkType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(NetworkType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  TFType get tf => $_getN(1);
  @$pb.TagNumber(2)
  set tf(TFType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTf() => $_has(1);
  @$pb.TagNumber(2)
  void clearTf() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get oid => $_getSZ(2);
  @$pb.TagNumber(3)
  set oid($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOid() => $_has(2);
  @$pb.TagNumber(3)
  void clearOid() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
