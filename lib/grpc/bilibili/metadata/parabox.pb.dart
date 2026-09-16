// This is a generated file - do not edit.
//
// Generated from bilibili/metadata/parabox.proto.

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

class Exp extends $pb.GeneratedMessage {
  factory Exp({
    $fixnum.Int64? id,
    $core.int? bucket,
  }) {
    final result = Exp._();
    if (id != null) result.id = id;
    if (bucket != null) result.bucket = bucket;
    return result;
  }

  Exp._();

  factory Exp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Exp()..mergeFromBuffer(data, registry);
  factory Exp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Exp()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Exp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.metadata.parabox'),
      createEmptyInstance: Exp.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aI(2, _omitFieldNames ? '' : 'bucket')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Exp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Exp copyWith(void Function(Exp) updates) =>
      super.copyWith((message) => updates(message as Exp)) as Exp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Exp() / Exp.new instead')
  static Exp create() => Exp._();
  static $pb.GeneratedMessage $_createMessage() => Exp._();
  @$core.override
  Exp createEmptyInstance() => Exp._();
  @$core.pragma('dart2js:noInline')
  static Exp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Exp>(Exp.$_createMessage);
  static Exp? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get bucket => $_getIZ(1);
  @$pb.TagNumber(2)
  set bucket($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBucket() => $_has(1);
  @$pb.TagNumber(2)
  void clearBucket() => $_clearField(2);
}

class Exps extends $pb.GeneratedMessage {
  factory Exps({
    $core.Iterable<Exp>? exps,
  }) {
    final result = Exps._();
    if (exps != null) result.exps.addAll(exps);
    return result;
  }

  Exps._();

  factory Exps.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Exps()..mergeFromBuffer(data, registry);
  factory Exps.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Exps()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Exps',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.metadata.parabox'),
      createEmptyInstance: Exps.$_createMessage)
    ..pPM<Exp>(1, _omitFieldNames ? '' : 'exps',
        subBuilder: Exp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Exps clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Exps copyWith(void Function(Exps) updates) =>
      super.copyWith((message) => updates(message as Exps)) as Exps;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Exps() / Exps.new instead')
  static Exps create() => Exps._();
  static $pb.GeneratedMessage $_createMessage() => Exps._();
  @$core.override
  Exps createEmptyInstance() => Exps._();
  @$core.pragma('dart2js:noInline')
  static Exps getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Exps>(Exps.$_createMessage);
  static Exps? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Exp> get exps => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
