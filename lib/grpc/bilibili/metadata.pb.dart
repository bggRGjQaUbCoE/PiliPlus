// This is a generated file - do not edit.
//
// Generated from bilibili/metadata.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Metadata extends $pb.GeneratedMessage {
  factory Metadata({
    $core.String? accessKey,
    $core.String? mobiApp,
    $core.String? device,
    $core.int? build,
    $core.String? channel,
    $core.String? buvid,
    $core.String? platform,
  }) {
    final result = Metadata._();
    if (accessKey != null) result.accessKey = accessKey;
    if (mobiApp != null) result.mobiApp = mobiApp;
    if (device != null) result.device = device;
    if (build != null) result.build = build;
    if (channel != null) result.channel = channel;
    if (buvid != null) result.buvid = buvid;
    if (platform != null) result.platform = platform;
    return result;
  }

  Metadata._();

  factory Metadata.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Metadata()..mergeFromBuffer(data, registry);
  factory Metadata.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Metadata()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Metadata',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.metadata'),
      createEmptyInstance: Metadata.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'accessKey')
    ..aOS(2, _omitFieldNames ? '' : 'mobiApp')
    ..aOS(3, _omitFieldNames ? '' : 'device')
    ..aI(4, _omitFieldNames ? '' : 'build')
    ..aOS(5, _omitFieldNames ? '' : 'channel')
    ..aOS(6, _omitFieldNames ? '' : 'buvid')
    ..aOS(7, _omitFieldNames ? '' : 'platform')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Metadata clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Metadata copyWith(void Function(Metadata) updates) =>
      super.copyWith((message) => updates(message as Metadata)) as Metadata;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Metadata() / Metadata.new instead')
  static Metadata create() => Metadata._();
  static $pb.GeneratedMessage $_createMessage() => Metadata._();
  @$core.override
  Metadata createEmptyInstance() => Metadata._();
  @$core.pragma('dart2js:noInline')
  static Metadata getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Metadata>(Metadata.$_createMessage);
  static Metadata? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accessKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set accessKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccessKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccessKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mobiApp => $_getSZ(1);
  @$pb.TagNumber(2)
  set mobiApp($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMobiApp() => $_has(1);
  @$pb.TagNumber(2)
  void clearMobiApp() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get device => $_getSZ(2);
  @$pb.TagNumber(3)
  set device($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDevice() => $_has(2);
  @$pb.TagNumber(3)
  void clearDevice() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get build => $_getIZ(3);
  @$pb.TagNumber(4)
  set build($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBuild() => $_has(3);
  @$pb.TagNumber(4)
  void clearBuild() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get channel => $_getSZ(4);
  @$pb.TagNumber(5)
  set channel($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasChannel() => $_has(4);
  @$pb.TagNumber(5)
  void clearChannel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get buvid => $_getSZ(5);
  @$pb.TagNumber(6)
  set buvid($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBuvid() => $_has(5);
  @$pb.TagNumber(6)
  void clearBuvid() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get platform => $_getSZ(6);
  @$pb.TagNumber(7)
  set platform($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPlatform() => $_has(6);
  @$pb.TagNumber(7)
  void clearPlatform() => $_clearField(7);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
