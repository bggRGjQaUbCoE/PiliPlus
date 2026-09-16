// This is a generated file - do not edit.
//
// Generated from bilibili/metadata/restriction.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'restriction.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'restriction.pbenum.dart';

class Restriction extends $pb.GeneratedMessage {
  factory Restriction({
    $core.bool? teenagersMode,
    $core.bool? lessonsMode,
    ModeType? mode,
    $core.bool? review,
    $core.bool? disableRcmd,
    $core.bool? basicMode,
    $core.int? teenagersAge,
  }) {
    final result = Restriction._();
    if (teenagersMode != null) result.teenagersMode = teenagersMode;
    if (lessonsMode != null) result.lessonsMode = lessonsMode;
    if (mode != null) result.mode = mode;
    if (review != null) result.review = review;
    if (disableRcmd != null) result.disableRcmd = disableRcmd;
    if (basicMode != null) result.basicMode = basicMode;
    if (teenagersAge != null) result.teenagersAge = teenagersAge;
    return result;
  }

  Restriction._();

  factory Restriction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Restriction()..mergeFromBuffer(data, registry);
  factory Restriction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Restriction()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Restriction',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.metadata.restriction'),
      createEmptyInstance: Restriction.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'teenagersMode')
    ..aOB(2, _omitFieldNames ? '' : 'lessonsMode')
    ..aE<ModeType>(3, _omitFieldNames ? '' : 'mode',
        enumValues: ModeType.values)
    ..aOB(4, _omitFieldNames ? '' : 'review')
    ..aOB(5, _omitFieldNames ? '' : 'disableRcmd')
    ..aOB(6, _omitFieldNames ? '' : 'basicMode')
    ..aI(7, _omitFieldNames ? '' : 'teenagersAge')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Restriction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Restriction copyWith(void Function(Restriction) updates) =>
      super.copyWith((message) => updates(message as Restriction))
          as Restriction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Restriction() / Restriction.new instead')
  static Restriction create() => Restriction._();
  static $pb.GeneratedMessage $_createMessage() => Restriction._();
  @$core.override
  Restriction createEmptyInstance() => Restriction._();
  @$core.pragma('dart2js:noInline')
  static Restriction getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Restriction>(
          Restriction.$_createMessage);
  static Restriction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get teenagersMode => $_getBF(0);
  @$pb.TagNumber(1)
  set teenagersMode($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTeenagersMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearTeenagersMode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get lessonsMode => $_getBF(1);
  @$pb.TagNumber(2)
  set lessonsMode($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLessonsMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearLessonsMode() => $_clearField(2);

  @$pb.TagNumber(3)
  ModeType get mode => $_getN(2);
  @$pb.TagNumber(3)
  set mode(ModeType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get review => $_getBF(3);
  @$pb.TagNumber(4)
  set review($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReview() => $_has(3);
  @$pb.TagNumber(4)
  void clearReview() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get disableRcmd => $_getBF(4);
  @$pb.TagNumber(5)
  set disableRcmd($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDisableRcmd() => $_has(4);
  @$pb.TagNumber(5)
  void clearDisableRcmd() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get basicMode => $_getBF(5);
  @$pb.TagNumber(6)
  set basicMode($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBasicMode() => $_has(5);
  @$pb.TagNumber(6)
  void clearBasicMode() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get teenagersAge => $_getIZ(6);
  @$pb.TagNumber(7)
  set teenagersAge($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTeenagersAge() => $_has(6);
  @$pb.TagNumber(7)
  void clearTeenagersAge() => $_clearField(7);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
