// This is a generated file - do not edit.
//
// Generated from bilibili/dagw/component/avatar/v1/plugin.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../common.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class BorderConfig extends $pb.GeneratedMessage {
  factory BorderConfig({
    $0.ColorConfig? color,
    $core.double? borderWidth,
    $core.double? ratio,
  }) {
    final result = BorderConfig._();
    if (color != null) result.color = color;
    if (borderWidth != null) result.borderWidth = borderWidth;
    if (ratio != null) result.ratio = ratio;
    return result;
  }

  BorderConfig._();

  factory BorderConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BorderConfig()..mergeFromBuffer(data, registry);
  factory BorderConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BorderConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BorderConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1.plugin'),
      createEmptyInstance: BorderConfig.$_createMessage)
    ..aOM<$0.ColorConfig>(1, _omitFieldNames ? '' : 'color',
        subBuilder: $0.ColorConfig.$_createMessage)
    ..aD(2, _omitFieldNames ? '' : 'borderWidth')
    ..aD(3, _omitFieldNames ? '' : 'ratio')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BorderConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BorderConfig copyWith(void Function(BorderConfig) updates) =>
      super.copyWith((message) => updates(message as BorderConfig))
          as BorderConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BorderConfig() / BorderConfig.new instead')
  static BorderConfig create() => BorderConfig._();
  static $pb.GeneratedMessage $_createMessage() => BorderConfig._();
  @$core.override
  BorderConfig createEmptyInstance() => BorderConfig._();
  @$core.pragma('dart2js:noInline')
  static BorderConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BorderConfig>(
          BorderConfig.$_createMessage);
  static BorderConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $0.ColorConfig get color => $_getN(0);
  @$pb.TagNumber(1)
  set color($0.ColorConfig value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasColor() => $_has(0);
  @$pb.TagNumber(1)
  void clearColor() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.ColorConfig ensureColor() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get borderWidth => $_getN(1);
  @$pb.TagNumber(2)
  set borderWidth($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBorderWidth() => $_has(1);
  @$pb.TagNumber(2)
  void clearBorderWidth() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get ratio => $_getN(2);
  @$pb.TagNumber(3)
  set ratio($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRatio() => $_has(2);
  @$pb.TagNumber(3)
  void clearRatio() => $_clearField(3);
}

class CommentDoubleClickConfig extends $pb.GeneratedMessage {
  factory CommentDoubleClickConfig({
    Interaction? interaction,
    $core.double? animationScale,
  }) {
    final result = CommentDoubleClickConfig._();
    if (interaction != null) result.interaction = interaction;
    if (animationScale != null) result.animationScale = animationScale;
    return result;
  }

  CommentDoubleClickConfig._();

  factory CommentDoubleClickConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommentDoubleClickConfig()..mergeFromBuffer(data, registry);
  factory CommentDoubleClickConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommentDoubleClickConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommentDoubleClickConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1.plugin'),
      createEmptyInstance: CommentDoubleClickConfig.$_createMessage)
    ..aOM<Interaction>(1, _omitFieldNames ? '' : 'interaction',
        subBuilder: Interaction.$_createMessage)
    ..aD(2, _omitFieldNames ? '' : 'animationScale')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommentDoubleClickConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommentDoubleClickConfig copyWith(
          void Function(CommentDoubleClickConfig) updates) =>
      super.copyWith((message) => updates(message as CommentDoubleClickConfig))
          as CommentDoubleClickConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CommentDoubleClickConfig() / CommentDoubleClickConfig.new instead')
  static CommentDoubleClickConfig create() => CommentDoubleClickConfig._();
  static $pb.GeneratedMessage $_createMessage() => CommentDoubleClickConfig._();
  @$core.override
  CommentDoubleClickConfig createEmptyInstance() =>
      CommentDoubleClickConfig._();
  @$core.pragma('dart2js:noInline')
  static CommentDoubleClickConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommentDoubleClickConfig>(
          CommentDoubleClickConfig.$_createMessage);
  static CommentDoubleClickConfig? _defaultInstance;

  @$pb.TagNumber(1)
  Interaction get interaction => $_getN(0);
  @$pb.TagNumber(1)
  set interaction(Interaction value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInteraction() => $_has(0);
  @$pb.TagNumber(1)
  void clearInteraction() => $_clearField(1);
  @$pb.TagNumber(1)
  Interaction ensureInteraction() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get animationScale => $_getN(1);
  @$pb.TagNumber(2)
  set animationScale($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAnimationScale() => $_has(1);
  @$pb.TagNumber(2)
  void clearAnimationScale() => $_clearField(2);
}

class FollowActionConfig extends $pb.GeneratedMessage {
  factory FollowActionConfig({
    $core.bool? hasFollow,
    $0.ResourceSource? iconRes,
    $core.double? borderWidth,
    $0.ColorConfig? borderColor,
    $fixnum.Int64? mid,
    $core.double? iconWidthRatio,
    $core.double? iconSizeOffset,
  }) {
    final result = FollowActionConfig._();
    if (hasFollow != null) result.hasFollow = hasFollow;
    if (iconRes != null) result.iconRes = iconRes;
    if (borderWidth != null) result.borderWidth = borderWidth;
    if (borderColor != null) result.borderColor = borderColor;
    if (mid != null) result.mid = mid;
    if (iconWidthRatio != null) result.iconWidthRatio = iconWidthRatio;
    if (iconSizeOffset != null) result.iconSizeOffset = iconSizeOffset;
    return result;
  }

  FollowActionConfig._();

  factory FollowActionConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowActionConfig()..mergeFromBuffer(data, registry);
  factory FollowActionConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowActionConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FollowActionConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1.plugin'),
      createEmptyInstance: FollowActionConfig.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'hasFollow')
    ..aOM<$0.ResourceSource>(2, _omitFieldNames ? '' : 'iconRes',
        subBuilder: $0.ResourceSource.$_createMessage)
    ..aD(3, _omitFieldNames ? '' : 'borderWidth')
    ..aOM<$0.ColorConfig>(4, _omitFieldNames ? '' : 'borderColor',
        subBuilder: $0.ColorConfig.$_createMessage)
    ..aInt64(5, _omitFieldNames ? '' : 'mid')
    ..aD(6, _omitFieldNames ? '' : 'iconWidthRatio')
    ..aD(7, _omitFieldNames ? '' : 'iconSizeOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowActionConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowActionConfig copyWith(void Function(FollowActionConfig) updates) =>
      super.copyWith((message) => updates(message as FollowActionConfig))
          as FollowActionConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FollowActionConfig() / FollowActionConfig.new instead')
  static FollowActionConfig create() => FollowActionConfig._();
  static $pb.GeneratedMessage $_createMessage() => FollowActionConfig._();
  @$core.override
  FollowActionConfig createEmptyInstance() => FollowActionConfig._();
  @$core.pragma('dart2js:noInline')
  static FollowActionConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FollowActionConfig>(
          FollowActionConfig.$_createMessage);
  static FollowActionConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get hasFollow => $_getBF(0);
  @$pb.TagNumber(1)
  set hasFollow($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHasFollow() => $_has(0);
  @$pb.TagNumber(1)
  void clearHasFollow() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.ResourceSource get iconRes => $_getN(1);
  @$pb.TagNumber(2)
  set iconRes($0.ResourceSource value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasIconRes() => $_has(1);
  @$pb.TagNumber(2)
  void clearIconRes() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.ResourceSource ensureIconRes() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.double get borderWidth => $_getN(2);
  @$pb.TagNumber(3)
  set borderWidth($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBorderWidth() => $_has(2);
  @$pb.TagNumber(3)
  void clearBorderWidth() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.ColorConfig get borderColor => $_getN(3);
  @$pb.TagNumber(4)
  set borderColor($0.ColorConfig value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBorderColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearBorderColor() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.ColorConfig ensureBorderColor() => $_ensure(3);

  @$pb.TagNumber(5)
  $fixnum.Int64 get mid => $_getI64(4);
  @$pb.TagNumber(5)
  set mid($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMid() => $_has(4);
  @$pb.TagNumber(5)
  void clearMid() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get iconWidthRatio => $_getN(5);
  @$pb.TagNumber(6)
  set iconWidthRatio($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIconWidthRatio() => $_has(5);
  @$pb.TagNumber(6)
  void clearIconWidthRatio() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get iconSizeOffset => $_getN(6);
  @$pb.TagNumber(7)
  set iconSizeOffset($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIconSizeOffset() => $_has(6);
  @$pb.TagNumber(7)
  void clearIconSizeOffset() => $_clearField(7);
}

class FollowIconConfig extends $pb.GeneratedMessage {
  factory FollowIconConfig({
    $core.bool? hasFollow,
    $0.ResourceSource? iconRes,
    $core.double? borderWidth,
    $0.ColorConfig? borderColor,
    $fixnum.Int64? mid,
  }) {
    final result = FollowIconConfig._();
    if (hasFollow != null) result.hasFollow = hasFollow;
    if (iconRes != null) result.iconRes = iconRes;
    if (borderWidth != null) result.borderWidth = borderWidth;
    if (borderColor != null) result.borderColor = borderColor;
    if (mid != null) result.mid = mid;
    return result;
  }

  FollowIconConfig._();

  factory FollowIconConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowIconConfig()..mergeFromBuffer(data, registry);
  factory FollowIconConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowIconConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FollowIconConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1.plugin'),
      createEmptyInstance: FollowIconConfig.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'hasFollow')
    ..aOM<$0.ResourceSource>(2, _omitFieldNames ? '' : 'iconRes',
        subBuilder: $0.ResourceSource.$_createMessage)
    ..aD(3, _omitFieldNames ? '' : 'borderWidth')
    ..aOM<$0.ColorConfig>(4, _omitFieldNames ? '' : 'borderColor',
        subBuilder: $0.ColorConfig.$_createMessage)
    ..aInt64(5, _omitFieldNames ? '' : 'mid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowIconConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowIconConfig copyWith(void Function(FollowIconConfig) updates) =>
      super.copyWith((message) => updates(message as FollowIconConfig))
          as FollowIconConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FollowIconConfig() / FollowIconConfig.new instead')
  static FollowIconConfig create() => FollowIconConfig._();
  static $pb.GeneratedMessage $_createMessage() => FollowIconConfig._();
  @$core.override
  FollowIconConfig createEmptyInstance() => FollowIconConfig._();
  @$core.pragma('dart2js:noInline')
  static FollowIconConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FollowIconConfig>(
          FollowIconConfig.$_createMessage);
  static FollowIconConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get hasFollow => $_getBF(0);
  @$pb.TagNumber(1)
  set hasFollow($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHasFollow() => $_has(0);
  @$pb.TagNumber(1)
  void clearHasFollow() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.ResourceSource get iconRes => $_getN(1);
  @$pb.TagNumber(2)
  set iconRes($0.ResourceSource value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasIconRes() => $_has(1);
  @$pb.TagNumber(2)
  void clearIconRes() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.ResourceSource ensureIconRes() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.double get borderWidth => $_getN(2);
  @$pb.TagNumber(3)
  set borderWidth($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBorderWidth() => $_has(2);
  @$pb.TagNumber(3)
  void clearBorderWidth() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.ColorConfig get borderColor => $_getN(3);
  @$pb.TagNumber(4)
  set borderColor($0.ColorConfig value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBorderColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearBorderColor() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.ColorConfig ensureBorderColor() => $_ensure(3);

  @$pb.TagNumber(5)
  $fixnum.Int64 get mid => $_getI64(4);
  @$pb.TagNumber(5)
  set mid($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMid() => $_has(4);
  @$pb.TagNumber(5)
  void clearMid() => $_clearField(5);
}

class GyroConfig extends $pb.GeneratedMessage {
  factory GyroConfig({
    NFTImageV2? gyroscope,
  }) {
    final result = GyroConfig._();
    if (gyroscope != null) result.gyroscope = gyroscope;
    return result;
  }

  GyroConfig._();

  factory GyroConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GyroConfig()..mergeFromBuffer(data, registry);
  factory GyroConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GyroConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GyroConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1.plugin'),
      createEmptyInstance: GyroConfig.$_createMessage)
    ..aOM<NFTImageV2>(1, _omitFieldNames ? '' : 'gyroscope',
        subBuilder: NFTImageV2.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GyroConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GyroConfig copyWith(void Function(GyroConfig) updates) =>
      super.copyWith((message) => updates(message as GyroConfig)) as GyroConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GyroConfig() / GyroConfig.new instead')
  static GyroConfig create() => GyroConfig._();
  static $pb.GeneratedMessage $_createMessage() => GyroConfig._();
  @$core.override
  GyroConfig createEmptyInstance() => GyroConfig._();
  @$core.pragma('dart2js:noInline')
  static GyroConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GyroConfig>(GyroConfig.$_createMessage);
  static GyroConfig? _defaultInstance;

  @$pb.TagNumber(1)
  NFTImageV2 get gyroscope => $_getN(0);
  @$pb.TagNumber(1)
  set gyroscope(NFTImageV2 value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGyroscope() => $_has(0);
  @$pb.TagNumber(1)
  void clearGyroscope() => $_clearField(1);
  @$pb.TagNumber(1)
  NFTImageV2 ensureGyroscope() => $_ensure(0);
}

class GyroscopeContentV2 extends $pb.GeneratedMessage {
  factory GyroscopeContentV2({
    $core.String? fileUrl,
    $core.double? scale,
    $core.Iterable<PhysicalOrientationV2>? physicalOrientation,
  }) {
    final result = GyroscopeContentV2._();
    if (fileUrl != null) result.fileUrl = fileUrl;
    if (scale != null) result.scale = scale;
    if (physicalOrientation != null)
      result.physicalOrientation.addAll(physicalOrientation);
    return result;
  }

  GyroscopeContentV2._();

  factory GyroscopeContentV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GyroscopeContentV2()..mergeFromBuffer(data, registry);
  factory GyroscopeContentV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GyroscopeContentV2()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GyroscopeContentV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1.plugin'),
      createEmptyInstance: GyroscopeContentV2.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'fileUrl')
    ..aD(2, _omitFieldNames ? '' : 'scale', fieldType: $pb.PbFieldType.OF)
    ..pPM<PhysicalOrientationV2>(
        3, _omitFieldNames ? '' : 'physicalOrientation',
        subBuilder: PhysicalOrientationV2.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GyroscopeContentV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GyroscopeContentV2 copyWith(void Function(GyroscopeContentV2) updates) =>
      super.copyWith((message) => updates(message as GyroscopeContentV2))
          as GyroscopeContentV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GyroscopeContentV2() / GyroscopeContentV2.new instead')
  static GyroscopeContentV2 create() => GyroscopeContentV2._();
  static $pb.GeneratedMessage $_createMessage() => GyroscopeContentV2._();
  @$core.override
  GyroscopeContentV2 createEmptyInstance() => GyroscopeContentV2._();
  @$core.pragma('dart2js:noInline')
  static GyroscopeContentV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GyroscopeContentV2>(
          GyroscopeContentV2.$_createMessage);
  static GyroscopeContentV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get scale => $_getN(1);
  @$pb.TagNumber(2)
  set scale($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScale() => $_has(1);
  @$pb.TagNumber(2)
  void clearScale() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<PhysicalOrientationV2> get physicalOrientation => $_getList(2);
}

class GyroscopeEntityV2 extends $pb.GeneratedMessage {
  factory GyroscopeEntityV2({
    $core.String? displayType,
    $core.Iterable<GyroscopeContentV2>? contents,
  }) {
    final result = GyroscopeEntityV2._();
    if (displayType != null) result.displayType = displayType;
    if (contents != null) result.contents.addAll(contents);
    return result;
  }

  GyroscopeEntityV2._();

  factory GyroscopeEntityV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GyroscopeEntityV2()..mergeFromBuffer(data, registry);
  factory GyroscopeEntityV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GyroscopeEntityV2()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GyroscopeEntityV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1.plugin'),
      createEmptyInstance: GyroscopeEntityV2.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'displayType')
    ..pPM<GyroscopeContentV2>(2, _omitFieldNames ? '' : 'contents',
        subBuilder: GyroscopeContentV2.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GyroscopeEntityV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GyroscopeEntityV2 copyWith(void Function(GyroscopeEntityV2) updates) =>
      super.copyWith((message) => updates(message as GyroscopeEntityV2))
          as GyroscopeEntityV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GyroscopeEntityV2() / GyroscopeEntityV2.new instead')
  static GyroscopeEntityV2 create() => GyroscopeEntityV2._();
  static $pb.GeneratedMessage $_createMessage() => GyroscopeEntityV2._();
  @$core.override
  GyroscopeEntityV2 createEmptyInstance() => GyroscopeEntityV2._();
  @$core.pragma('dart2js:noInline')
  static GyroscopeEntityV2 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GyroscopeEntityV2>(
          GyroscopeEntityV2.$_createMessage);
  static GyroscopeEntityV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get displayType => $_getSZ(0);
  @$pb.TagNumber(1)
  set displayType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDisplayType() => $_has(0);
  @$pb.TagNumber(1)
  void clearDisplayType() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<GyroscopeContentV2> get contents => $_getList(1);
}

class Interaction extends $pb.GeneratedMessage {
  factory Interaction({
    $core.String? nftId,
    $core.bool? enabled,
    $core.String? itype,
    $core.String? metadataUrl,
  }) {
    final result = Interaction._();
    if (nftId != null) result.nftId = nftId;
    if (enabled != null) result.enabled = enabled;
    if (itype != null) result.itype = itype;
    if (metadataUrl != null) result.metadataUrl = metadataUrl;
    return result;
  }

  Interaction._();

  factory Interaction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Interaction()..mergeFromBuffer(data, registry);
  factory Interaction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Interaction()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Interaction',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1.plugin'),
      createEmptyInstance: Interaction.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'nftId')
    ..aOB(2, _omitFieldNames ? '' : 'enabled')
    ..aOS(3, _omitFieldNames ? '' : 'itype')
    ..aOS(4, _omitFieldNames ? '' : 'metadataUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Interaction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Interaction copyWith(void Function(Interaction) updates) =>
      super.copyWith((message) => updates(message as Interaction))
          as Interaction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Interaction() / Interaction.new instead')
  static Interaction create() => Interaction._();
  static $pb.GeneratedMessage $_createMessage() => Interaction._();
  @$core.override
  Interaction createEmptyInstance() => Interaction._();
  @$core.pragma('dart2js:noInline')
  static Interaction getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Interaction>(
          Interaction.$_createMessage);
  static Interaction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nftId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nftId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNftId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNftId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get enabled => $_getBF(1);
  @$pb.TagNumber(2)
  set enabled($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnabled() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get itype => $_getSZ(2);
  @$pb.TagNumber(3)
  set itype($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasItype() => $_has(2);
  @$pb.TagNumber(3)
  void clearItype() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get metadataUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set metadataUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMetadataUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearMetadataUrl() => $_clearField(4);
}

class LiveAnimeConfig extends $pb.GeneratedMessage {
  factory LiveAnimeConfig({
    $core.bool? isLive,
    LiveTextConfig? config,
    $core.Iterable<LiveAnimeItem>? items,
    $core.Iterable<BorderConfig>? borderConfig,
  }) {
    final result = LiveAnimeConfig._();
    if (isLive != null) result.isLive = isLive;
    if (config != null) result.config = config;
    if (items != null) result.items.addAll(items);
    if (borderConfig != null) result.borderConfig.addAll(borderConfig);
    return result;
  }

  LiveAnimeConfig._();

  factory LiveAnimeConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveAnimeConfig()..mergeFromBuffer(data, registry);
  factory LiveAnimeConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveAnimeConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveAnimeConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1.plugin'),
      createEmptyInstance: LiveAnimeConfig.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'isLive')
    ..aOM<LiveTextConfig>(2, _omitFieldNames ? '' : 'config',
        subBuilder: LiveTextConfig.$_createMessage)
    ..pPM<LiveAnimeItem>(3, _omitFieldNames ? '' : 'items',
        subBuilder: LiveAnimeItem.$_createMessage)
    ..pPM<BorderConfig>(4, _omitFieldNames ? '' : 'borderConfig',
        subBuilder: BorderConfig.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveAnimeConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveAnimeConfig copyWith(void Function(LiveAnimeConfig) updates) =>
      super.copyWith((message) => updates(message as LiveAnimeConfig))
          as LiveAnimeConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LiveAnimeConfig() / LiveAnimeConfig.new instead')
  static LiveAnimeConfig create() => LiveAnimeConfig._();
  static $pb.GeneratedMessage $_createMessage() => LiveAnimeConfig._();
  @$core.override
  LiveAnimeConfig createEmptyInstance() => LiveAnimeConfig._();
  @$core.pragma('dart2js:noInline')
  static LiveAnimeConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LiveAnimeConfig>(
          LiveAnimeConfig.$_createMessage);
  static LiveAnimeConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isLive => $_getBF(0);
  @$pb.TagNumber(1)
  set isLive($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsLive() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsLive() => $_clearField(1);

  @$pb.TagNumber(2)
  LiveTextConfig get config => $_getN(1);
  @$pb.TagNumber(2)
  set config(LiveTextConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasConfig() => $_has(1);
  @$pb.TagNumber(2)
  void clearConfig() => $_clearField(2);
  @$pb.TagNumber(2)
  LiveTextConfig ensureConfig() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<LiveAnimeItem> get items => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<BorderConfig> get borderConfig => $_getList(3);
}

class LiveAnimeItem extends $pb.GeneratedMessage {
  factory LiveAnimeItem({
    $0.ColorConfig? color,
    $core.double? startRatio,
    $core.double? endRatio,
    $core.double? startStroke,
    $core.double? startOpacity,
    $fixnum.Int64? phase,
  }) {
    final result = LiveAnimeItem._();
    if (color != null) result.color = color;
    if (startRatio != null) result.startRatio = startRatio;
    if (endRatio != null) result.endRatio = endRatio;
    if (startStroke != null) result.startStroke = startStroke;
    if (startOpacity != null) result.startOpacity = startOpacity;
    if (phase != null) result.phase = phase;
    return result;
  }

  LiveAnimeItem._();

  factory LiveAnimeItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveAnimeItem()..mergeFromBuffer(data, registry);
  factory LiveAnimeItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveAnimeItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveAnimeItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1.plugin'),
      createEmptyInstance: LiveAnimeItem.$_createMessage)
    ..aOM<$0.ColorConfig>(1, _omitFieldNames ? '' : 'color',
        subBuilder: $0.ColorConfig.$_createMessage)
    ..aD(2, _omitFieldNames ? '' : 'startRatio')
    ..aD(3, _omitFieldNames ? '' : 'endRatio')
    ..aD(4, _omitFieldNames ? '' : 'startStroke')
    ..aD(5, _omitFieldNames ? '' : 'startOpacity')
    ..aInt64(6, _omitFieldNames ? '' : 'phase')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveAnimeItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveAnimeItem copyWith(void Function(LiveAnimeItem) updates) =>
      super.copyWith((message) => updates(message as LiveAnimeItem))
          as LiveAnimeItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LiveAnimeItem() / LiveAnimeItem.new instead')
  static LiveAnimeItem create() => LiveAnimeItem._();
  static $pb.GeneratedMessage $_createMessage() => LiveAnimeItem._();
  @$core.override
  LiveAnimeItem createEmptyInstance() => LiveAnimeItem._();
  @$core.pragma('dart2js:noInline')
  static LiveAnimeItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LiveAnimeItem>(
          LiveAnimeItem.$_createMessage);
  static LiveAnimeItem? _defaultInstance;

  @$pb.TagNumber(1)
  $0.ColorConfig get color => $_getN(0);
  @$pb.TagNumber(1)
  set color($0.ColorConfig value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasColor() => $_has(0);
  @$pb.TagNumber(1)
  void clearColor() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.ColorConfig ensureColor() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get startRatio => $_getN(1);
  @$pb.TagNumber(2)
  set startRatio($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStartRatio() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartRatio() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get endRatio => $_getN(2);
  @$pb.TagNumber(3)
  set endRatio($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEndRatio() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndRatio() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get startStroke => $_getN(3);
  @$pb.TagNumber(4)
  set startStroke($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStartStroke() => $_has(3);
  @$pb.TagNumber(4)
  void clearStartStroke() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get startOpacity => $_getN(4);
  @$pb.TagNumber(5)
  set startOpacity($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStartOpacity() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartOpacity() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get phase => $_getI64(5);
  @$pb.TagNumber(6)
  set phase($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPhase() => $_has(5);
  @$pb.TagNumber(6)
  void clearPhase() => $_clearField(6);
}

class LiveTextConfig extends $pb.GeneratedMessage {
  factory LiveTextConfig({
    $core.double? width,
    $core.double? height,
    $core.double? offsetY,
    $core.double? borderWidth,
    $core.double? textSize,
    $0.ColorConfig? borderColor,
    $0.ColorConfig? background,
  }) {
    final result = LiveTextConfig._();
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (offsetY != null) result.offsetY = offsetY;
    if (borderWidth != null) result.borderWidth = borderWidth;
    if (textSize != null) result.textSize = textSize;
    if (borderColor != null) result.borderColor = borderColor;
    if (background != null) result.background = background;
    return result;
  }

  LiveTextConfig._();

  factory LiveTextConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveTextConfig()..mergeFromBuffer(data, registry);
  factory LiveTextConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveTextConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveTextConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1.plugin'),
      createEmptyInstance: LiveTextConfig.$_createMessage)
    ..aD(1, _omitFieldNames ? '' : 'width')
    ..aD(2, _omitFieldNames ? '' : 'height')
    ..aD(3, _omitFieldNames ? '' : 'offsetY')
    ..aD(4, _omitFieldNames ? '' : 'borderWidth')
    ..aD(5, _omitFieldNames ? '' : 'textSize')
    ..aOM<$0.ColorConfig>(7, _omitFieldNames ? '' : 'borderColor',
        subBuilder: $0.ColorConfig.$_createMessage)
    ..aOM<$0.ColorConfig>(8, _omitFieldNames ? '' : 'background',
        subBuilder: $0.ColorConfig.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveTextConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveTextConfig copyWith(void Function(LiveTextConfig) updates) =>
      super.copyWith((message) => updates(message as LiveTextConfig))
          as LiveTextConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LiveTextConfig() / LiveTextConfig.new instead')
  static LiveTextConfig create() => LiveTextConfig._();
  static $pb.GeneratedMessage $_createMessage() => LiveTextConfig._();
  @$core.override
  LiveTextConfig createEmptyInstance() => LiveTextConfig._();
  @$core.pragma('dart2js:noInline')
  static LiveTextConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LiveTextConfig>(
          LiveTextConfig.$_createMessage);
  static LiveTextConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get width => $_getN(0);
  @$pb.TagNumber(1)
  set width($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get height => $_getN(1);
  @$pb.TagNumber(2)
  set height($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get offsetY => $_getN(2);
  @$pb.TagNumber(3)
  set offsetY($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOffsetY() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffsetY() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get borderWidth => $_getN(3);
  @$pb.TagNumber(4)
  set borderWidth($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBorderWidth() => $_has(3);
  @$pb.TagNumber(4)
  void clearBorderWidth() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get textSize => $_getN(4);
  @$pb.TagNumber(5)
  set textSize($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTextSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearTextSize() => $_clearField(5);

  @$pb.TagNumber(7)
  $0.ColorConfig get borderColor => $_getN(5);
  @$pb.TagNumber(7)
  set borderColor($0.ColorConfig value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasBorderColor() => $_has(5);
  @$pb.TagNumber(7)
  void clearBorderColor() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.ColorConfig ensureBorderColor() => $_ensure(5);

  @$pb.TagNumber(8)
  $0.ColorConfig get background => $_getN(6);
  @$pb.TagNumber(8)
  set background($0.ColorConfig value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasBackground() => $_has(6);
  @$pb.TagNumber(8)
  void clearBackground() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.ColorConfig ensureBackground() => $_ensure(6);
}

class NFTImageV2 extends $pb.GeneratedMessage {
  factory NFTImageV2({
    $core.Iterable<GyroscopeEntityV2>? gyroscope,
  }) {
    final result = NFTImageV2._();
    if (gyroscope != null) result.gyroscope.addAll(gyroscope);
    return result;
  }

  NFTImageV2._();

  factory NFTImageV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NFTImageV2()..mergeFromBuffer(data, registry);
  factory NFTImageV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NFTImageV2()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NFTImageV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1.plugin'),
      createEmptyInstance: NFTImageV2.$_createMessage)
    ..pPM<GyroscopeEntityV2>(1, _omitFieldNames ? '' : 'gyroscope',
        subBuilder: GyroscopeEntityV2.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NFTImageV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NFTImageV2 copyWith(void Function(NFTImageV2) updates) =>
      super.copyWith((message) => updates(message as NFTImageV2)) as NFTImageV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use NFTImageV2() / NFTImageV2.new instead')
  static NFTImageV2 create() => NFTImageV2._();
  static $pb.GeneratedMessage $_createMessage() => NFTImageV2._();
  @$core.override
  NFTImageV2 createEmptyInstance() => NFTImageV2._();
  @$core.pragma('dart2js:noInline')
  static NFTImageV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NFTImageV2>(NFTImageV2.$_createMessage);
  static NFTImageV2? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<GyroscopeEntityV2> get gyroscope => $_getList(0);
}

class PhysicalOrientationAnimation extends $pb.GeneratedMessage {
  factory PhysicalOrientationAnimation({
    $core.String? type,
    $core.Iterable<$core.double>? value,
    $core.String? bezier,
  }) {
    final result = PhysicalOrientationAnimation._();
    if (type != null) result.type = type;
    if (value != null) result.value.addAll(value);
    if (bezier != null) result.bezier = bezier;
    return result;
  }

  PhysicalOrientationAnimation._();

  factory PhysicalOrientationAnimation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PhysicalOrientationAnimation()..mergeFromBuffer(data, registry);
  factory PhysicalOrientationAnimation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PhysicalOrientationAnimation()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PhysicalOrientationAnimation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1.plugin'),
      createEmptyInstance: PhysicalOrientationAnimation.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..p<$core.double>(2, _omitFieldNames ? '' : 'value', $pb.PbFieldType.KF)
    ..aOS(3, _omitFieldNames ? '' : 'bezier')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhysicalOrientationAnimation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhysicalOrientationAnimation copyWith(
          void Function(PhysicalOrientationAnimation) updates) =>
      super.copyWith(
              (message) => updates(message as PhysicalOrientationAnimation))
          as PhysicalOrientationAnimation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PhysicalOrientationAnimation() / PhysicalOrientationAnimation.new instead')
  static PhysicalOrientationAnimation create() =>
      PhysicalOrientationAnimation._();
  static $pb.GeneratedMessage $_createMessage() =>
      PhysicalOrientationAnimation._();
  @$core.override
  PhysicalOrientationAnimation createEmptyInstance() =>
      PhysicalOrientationAnimation._();
  @$core.pragma('dart2js:noInline')
  static PhysicalOrientationAnimation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PhysicalOrientationAnimation>(
          PhysicalOrientationAnimation.$_createMessage);
  static PhysicalOrientationAnimation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.double> get value => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get bezier => $_getSZ(2);
  @$pb.TagNumber(3)
  set bezier($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBezier() => $_has(2);
  @$pb.TagNumber(3)
  void clearBezier() => $_clearField(3);
}

class PhysicalOrientationV2 extends $pb.GeneratedMessage {
  factory PhysicalOrientationV2({
    $core.String? type,
    $core.Iterable<$core.double>? angle,
    $core.Iterable<PhysicalOrientationAnimation>? animations,
  }) {
    final result = PhysicalOrientationV2._();
    if (type != null) result.type = type;
    if (angle != null) result.angle.addAll(angle);
    if (animations != null) result.animations.addAll(animations);
    return result;
  }

  PhysicalOrientationV2._();

  factory PhysicalOrientationV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PhysicalOrientationV2()..mergeFromBuffer(data, registry);
  factory PhysicalOrientationV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PhysicalOrientationV2()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PhysicalOrientationV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1.plugin'),
      createEmptyInstance: PhysicalOrientationV2.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..p<$core.double>(2, _omitFieldNames ? '' : 'angle', $pb.PbFieldType.KF)
    ..pPM<PhysicalOrientationAnimation>(3, _omitFieldNames ? '' : 'animations',
        subBuilder: PhysicalOrientationAnimation.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhysicalOrientationV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhysicalOrientationV2 copyWith(
          void Function(PhysicalOrientationV2) updates) =>
      super.copyWith((message) => updates(message as PhysicalOrientationV2))
          as PhysicalOrientationV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PhysicalOrientationV2() / PhysicalOrientationV2.new instead')
  static PhysicalOrientationV2 create() => PhysicalOrientationV2._();
  static $pb.GeneratedMessage $_createMessage() => PhysicalOrientationV2._();
  @$core.override
  PhysicalOrientationV2 createEmptyInstance() => PhysicalOrientationV2._();
  @$core.pragma('dart2js:noInline')
  static PhysicalOrientationV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PhysicalOrientationV2>(
          PhysicalOrientationV2.$_createMessage);
  static PhysicalOrientationV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.double> get angle => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<PhysicalOrientationAnimation> get animations => $_getList(2);
}

class WebLiveAnimeConfig extends $pb.GeneratedMessage {
  factory WebLiveAnimeConfig({
    $core.double? circleGapWidth,
    $core.double? pinkCircleWidth,
    $core.double? liveLabelWidth,
    $core.double? liveLabelHeight,
    $core.double? liveLabelOffsetY,
    $core.double? liveLabelBorderWidth,
  }) {
    final result = WebLiveAnimeConfig._();
    if (circleGapWidth != null) result.circleGapWidth = circleGapWidth;
    if (pinkCircleWidth != null) result.pinkCircleWidth = pinkCircleWidth;
    if (liveLabelWidth != null) result.liveLabelWidth = liveLabelWidth;
    if (liveLabelHeight != null) result.liveLabelHeight = liveLabelHeight;
    if (liveLabelOffsetY != null) result.liveLabelOffsetY = liveLabelOffsetY;
    if (liveLabelBorderWidth != null)
      result.liveLabelBorderWidth = liveLabelBorderWidth;
    return result;
  }

  WebLiveAnimeConfig._();

  factory WebLiveAnimeConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WebLiveAnimeConfig()..mergeFromBuffer(data, registry);
  factory WebLiveAnimeConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WebLiveAnimeConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WebLiveAnimeConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1.plugin'),
      createEmptyInstance: WebLiveAnimeConfig.$_createMessage)
    ..aD(1, _omitFieldNames ? '' : 'circleGapWidth')
    ..aD(2, _omitFieldNames ? '' : 'pinkCircleWidth')
    ..aD(3, _omitFieldNames ? '' : 'liveLabelWidth')
    ..aD(4, _omitFieldNames ? '' : 'liveLabelHeight')
    ..aD(5, _omitFieldNames ? '' : 'liveLabelOffsetY')
    ..aD(6, _omitFieldNames ? '' : 'liveLabelBorderWidth')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebLiveAnimeConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WebLiveAnimeConfig copyWith(void Function(WebLiveAnimeConfig) updates) =>
      super.copyWith((message) => updates(message as WebLiveAnimeConfig))
          as WebLiveAnimeConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use WebLiveAnimeConfig() / WebLiveAnimeConfig.new instead')
  static WebLiveAnimeConfig create() => WebLiveAnimeConfig._();
  static $pb.GeneratedMessage $_createMessage() => WebLiveAnimeConfig._();
  @$core.override
  WebLiveAnimeConfig createEmptyInstance() => WebLiveAnimeConfig._();
  @$core.pragma('dart2js:noInline')
  static WebLiveAnimeConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WebLiveAnimeConfig>(
          WebLiveAnimeConfig.$_createMessage);
  static WebLiveAnimeConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get circleGapWidth => $_getN(0);
  @$pb.TagNumber(1)
  set circleGapWidth($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCircleGapWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearCircleGapWidth() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get pinkCircleWidth => $_getN(1);
  @$pb.TagNumber(2)
  set pinkCircleWidth($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPinkCircleWidth() => $_has(1);
  @$pb.TagNumber(2)
  void clearPinkCircleWidth() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get liveLabelWidth => $_getN(2);
  @$pb.TagNumber(3)
  set liveLabelWidth($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLiveLabelWidth() => $_has(2);
  @$pb.TagNumber(3)
  void clearLiveLabelWidth() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get liveLabelHeight => $_getN(3);
  @$pb.TagNumber(4)
  set liveLabelHeight($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLiveLabelHeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearLiveLabelHeight() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get liveLabelOffsetY => $_getN(4);
  @$pb.TagNumber(5)
  set liveLabelOffsetY($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLiveLabelOffsetY() => $_has(4);
  @$pb.TagNumber(5)
  void clearLiveLabelOffsetY() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get liveLabelBorderWidth => $_getN(5);
  @$pb.TagNumber(6)
  set liveLabelBorderWidth($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLiveLabelBorderWidth() => $_has(5);
  @$pb.TagNumber(6)
  void clearLiveLabelBorderWidth() => $_clearField(6);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
