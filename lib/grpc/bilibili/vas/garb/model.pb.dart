// This is a generated file - do not edit.
//
// Generated from bilibili/vas/garb/model.proto.

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

class FanNumColorFormat extends $pb.GeneratedMessage {
  factory FanNumColorFormat({
    $core.String? startPoint,
    $core.String? endPoint,
    $core.Iterable<$core.String>? colors,
    $core.Iterable<$fixnum.Int64>? gradients,
  }) {
    final result = FanNumColorFormat._();
    if (startPoint != null) result.startPoint = startPoint;
    if (endPoint != null) result.endPoint = endPoint;
    if (colors != null) result.colors.addAll(colors);
    if (gradients != null) result.gradients.addAll(gradients);
    return result;
  }

  FanNumColorFormat._();

  factory FanNumColorFormat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FanNumColorFormat()..mergeFromBuffer(data, registry);
  factory FanNumColorFormat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FanNumColorFormat()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FanNumColorFormat',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.vas.garb.model'),
      createEmptyInstance: FanNumColorFormat.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'startPoint')
    ..aOS(2, _omitFieldNames ? '' : 'endPoint')
    ..pPS(3, _omitFieldNames ? '' : 'colors')
    ..p<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'gradients', $pb.PbFieldType.K6)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FanNumColorFormat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FanNumColorFormat copyWith(void Function(FanNumColorFormat) updates) =>
      super.copyWith((message) => updates(message as FanNumColorFormat))
          as FanNumColorFormat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FanNumColorFormat() / FanNumColorFormat.new instead')
  static FanNumColorFormat create() => FanNumColorFormat._();
  static $pb.GeneratedMessage $_createMessage() => FanNumColorFormat._();
  @$core.override
  FanNumColorFormat createEmptyInstance() => FanNumColorFormat._();
  @$core.pragma('dart2js:noInline')
  static FanNumColorFormat getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FanNumColorFormat>(
          FanNumColorFormat.$_createMessage);
  static FanNumColorFormat? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get startPoint => $_getSZ(0);
  @$pb.TagNumber(1)
  set startPoint($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStartPoint() => $_has(0);
  @$pb.TagNumber(1)
  void clearStartPoint() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get endPoint => $_getSZ(1);
  @$pb.TagNumber(2)
  set endPoint($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEndPoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndPoint() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get colors => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$fixnum.Int64> get gradients => $_getList(3);
}

class ImageGroup_VisualEffect extends $pb.GeneratedMessage {
  factory ImageGroup_VisualEffect({
    $core.String? medalImage,
    $core.String? colorTheme,
  }) {
    final result = ImageGroup_VisualEffect._();
    if (medalImage != null) result.medalImage = medalImage;
    if (colorTheme != null) result.colorTheme = colorTheme;
    return result;
  }

  ImageGroup_VisualEffect._();

  factory ImageGroup_VisualEffect.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImageGroup_VisualEffect()..mergeFromBuffer(data, registry);
  factory ImageGroup_VisualEffect.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImageGroup_VisualEffect()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImageGroup.VisualEffect',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.vas.garb.model'),
      createEmptyInstance: ImageGroup_VisualEffect.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'medalImage')
    ..aOS(2, _omitFieldNames ? '' : 'colorTheme')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImageGroup_VisualEffect clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImageGroup_VisualEffect copyWith(
          void Function(ImageGroup_VisualEffect) updates) =>
      super.copyWith((message) => updates(message as ImageGroup_VisualEffect))
          as ImageGroup_VisualEffect;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ImageGroup_VisualEffect() / ImageGroup_VisualEffect.new instead')
  static ImageGroup_VisualEffect create() => ImageGroup_VisualEffect._();
  static $pb.GeneratedMessage $_createMessage() => ImageGroup_VisualEffect._();
  @$core.override
  ImageGroup_VisualEffect createEmptyInstance() => ImageGroup_VisualEffect._();
  @$core.pragma('dart2js:noInline')
  static ImageGroup_VisualEffect getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ImageGroup_VisualEffect>(
          ImageGroup_VisualEffect.$_createMessage);
  static ImageGroup_VisualEffect? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get medalImage => $_getSZ(0);
  @$pb.TagNumber(1)
  set medalImage($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMedalImage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMedalImage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get colorTheme => $_getSZ(1);
  @$pb.TagNumber(2)
  set colorTheme($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasColorTheme() => $_has(1);
  @$pb.TagNumber(2)
  void clearColorTheme() => $_clearField(2);
}

class ImageGroup extends $pb.GeneratedMessage {
  factory ImageGroup({
    $fixnum.Int64? type,
    ImageGroup_VisualEffect? effectVisual,
  }) {
    final result = ImageGroup._();
    if (type != null) result.type = type;
    if (effectVisual != null) result.effectVisual = effectVisual;
    return result;
  }

  ImageGroup._();

  factory ImageGroup.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImageGroup()..mergeFromBuffer(data, registry);
  factory ImageGroup.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImageGroup()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImageGroup',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.vas.garb.model'),
      createEmptyInstance: ImageGroup.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'type')
    ..aOM<ImageGroup_VisualEffect>(2, _omitFieldNames ? '' : 'effectVisual',
        subBuilder: ImageGroup_VisualEffect.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImageGroup clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImageGroup copyWith(void Function(ImageGroup) updates) =>
      super.copyWith((message) => updates(message as ImageGroup)) as ImageGroup;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ImageGroup() / ImageGroup.new instead')
  static ImageGroup create() => ImageGroup._();
  static $pb.GeneratedMessage $_createMessage() => ImageGroup._();
  @$core.override
  ImageGroup createEmptyInstance() => ImageGroup._();
  @$core.pragma('dart2js:noInline')
  static ImageGroup getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ImageGroup>(ImageGroup.$_createMessage);
  static ImageGroup? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get type => $_getI64(0);
  @$pb.TagNumber(1)
  set type($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  ImageGroup_VisualEffect get effectVisual => $_getN(1);
  @$pb.TagNumber(2)
  set effectVisual(ImageGroup_VisualEffect value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEffectVisual() => $_has(1);
  @$pb.TagNumber(2)
  void clearEffectVisual() => $_clearField(2);
  @$pb.TagNumber(2)
  ImageGroup_VisualEffect ensureEffectVisual() => $_ensure(1);
}

class UserCardBG extends $pb.GeneratedMessage {
  factory UserCardBG({
    $fixnum.Int64? id,
    $core.String? name,
    $core.String? image,
    $core.String? jumpUrl,
    UserFanShow? fan,
    $core.String? type,
    ImageGroup? imageGroup,
  }) {
    final result = UserCardBG._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (image != null) result.image = image;
    if (jumpUrl != null) result.jumpUrl = jumpUrl;
    if (fan != null) result.fan = fan;
    if (type != null) result.type = type;
    if (imageGroup != null) result.imageGroup = imageGroup;
    return result;
  }

  UserCardBG._();

  factory UserCardBG.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserCardBG()..mergeFromBuffer(data, registry);
  factory UserCardBG.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserCardBG()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserCardBG',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.vas.garb.model'),
      createEmptyInstance: UserCardBG.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'image')
    ..aOS(4, _omitFieldNames ? '' : 'jumpUrl')
    ..aOM<UserFanShow>(5, _omitFieldNames ? '' : 'fan',
        subBuilder: UserFanShow.$_createMessage)
    ..aOS(6, _omitFieldNames ? '' : 'type')
    ..aOM<ImageGroup>(7, _omitFieldNames ? '' : 'imageGroup',
        subBuilder: ImageGroup.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCardBG clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCardBG copyWith(void Function(UserCardBG) updates) =>
      super.copyWith((message) => updates(message as UserCardBG)) as UserCardBG;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UserCardBG() / UserCardBG.new instead')
  static UserCardBG create() => UserCardBG._();
  static $pb.GeneratedMessage $_createMessage() => UserCardBG._();
  @$core.override
  UserCardBG createEmptyInstance() => UserCardBG._();
  @$core.pragma('dart2js:noInline')
  static UserCardBG getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserCardBG>(UserCardBG.$_createMessage);
  static UserCardBG? _defaultInstance;

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
  $core.String get image => $_getSZ(2);
  @$pb.TagNumber(3)
  set image($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasImage() => $_has(2);
  @$pb.TagNumber(3)
  void clearImage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get jumpUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set jumpUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasJumpUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearJumpUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  UserFanShow get fan => $_getN(4);
  @$pb.TagNumber(5)
  set fan(UserFanShow value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasFan() => $_has(4);
  @$pb.TagNumber(5)
  void clearFan() => $_clearField(5);
  @$pb.TagNumber(5)
  UserFanShow ensureFan() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get type => $_getSZ(5);
  @$pb.TagNumber(6)
  set type($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasType() => $_has(5);
  @$pb.TagNumber(6)
  void clearType() => $_clearField(6);

  @$pb.TagNumber(7)
  ImageGroup get imageGroup => $_getN(6);
  @$pb.TagNumber(7)
  set imageGroup(ImageGroup value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasImageGroup() => $_has(6);
  @$pb.TagNumber(7)
  void clearImageGroup() => $_clearField(7);
  @$pb.TagNumber(7)
  ImageGroup ensureImageGroup() => $_ensure(6);
}

class UserFanShow extends $pb.GeneratedMessage {
  factory UserFanShow({
    $fixnum.Int64? isFan,
    $fixnum.Int64? number,
    $core.String? color,
    $core.String? name,
    $core.String? numDesc,
    $core.String? numPrefix,
    FanNumColorFormat? colorFormat,
  }) {
    final result = UserFanShow._();
    if (isFan != null) result.isFan = isFan;
    if (number != null) result.number = number;
    if (color != null) result.color = color;
    if (name != null) result.name = name;
    if (numDesc != null) result.numDesc = numDesc;
    if (numPrefix != null) result.numPrefix = numPrefix;
    if (colorFormat != null) result.colorFormat = colorFormat;
    return result;
  }

  UserFanShow._();

  factory UserFanShow.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserFanShow()..mergeFromBuffer(data, registry);
  factory UserFanShow.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserFanShow()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserFanShow',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.vas.garb.model'),
      createEmptyInstance: UserFanShow.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'isFan')
    ..aInt64(2, _omitFieldNames ? '' : 'number')
    ..aOS(3, _omitFieldNames ? '' : 'color')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOS(5, _omitFieldNames ? '' : 'numDesc')
    ..aOS(6, _omitFieldNames ? '' : 'numPrefix')
    ..aOM<FanNumColorFormat>(7, _omitFieldNames ? '' : 'colorFormat',
        subBuilder: FanNumColorFormat.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserFanShow clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserFanShow copyWith(void Function(UserFanShow) updates) =>
      super.copyWith((message) => updates(message as UserFanShow))
          as UserFanShow;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UserFanShow() / UserFanShow.new instead')
  static UserFanShow create() => UserFanShow._();
  static $pb.GeneratedMessage $_createMessage() => UserFanShow._();
  @$core.override
  UserFanShow createEmptyInstance() => UserFanShow._();
  @$core.pragma('dart2js:noInline')
  static UserFanShow getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserFanShow>(
          UserFanShow.$_createMessage);
  static UserFanShow? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get isFan => $_getI64(0);
  @$pb.TagNumber(1)
  set isFan($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsFan() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsFan() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get number => $_getI64(1);
  @$pb.TagNumber(2)
  set number($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get color => $_getSZ(2);
  @$pb.TagNumber(3)
  set color($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearColor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get numDesc => $_getSZ(4);
  @$pb.TagNumber(5)
  set numDesc($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNumDesc() => $_has(4);
  @$pb.TagNumber(5)
  void clearNumDesc() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get numPrefix => $_getSZ(5);
  @$pb.TagNumber(6)
  set numPrefix($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNumPrefix() => $_has(5);
  @$pb.TagNumber(6)
  void clearNumPrefix() => $_clearField(6);

  @$pb.TagNumber(7)
  FanNumColorFormat get colorFormat => $_getN(6);
  @$pb.TagNumber(7)
  set colorFormat(FanNumColorFormat value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasColorFormat() => $_has(6);
  @$pb.TagNumber(7)
  void clearColorFormat() => $_clearField(7);
  @$pb.TagNumber(7)
  FanNumColorFormat ensureColorFormat() => $_ensure(6);
}

class UserPendant extends $pb.GeneratedMessage {
  factory UserPendant({
    $fixnum.Int64? id,
    $core.String? name,
    $core.String? image,
    $core.String? jumpUrl,
    $core.String? type,
    $core.String? imageEnhance,
    $core.String? imageEnhanceFrame,
  }) {
    final result = UserPendant._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (image != null) result.image = image;
    if (jumpUrl != null) result.jumpUrl = jumpUrl;
    if (type != null) result.type = type;
    if (imageEnhance != null) result.imageEnhance = imageEnhance;
    if (imageEnhanceFrame != null) result.imageEnhanceFrame = imageEnhanceFrame;
    return result;
  }

  UserPendant._();

  factory UserPendant.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserPendant()..mergeFromBuffer(data, registry);
  factory UserPendant.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserPendant()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserPendant',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.vas.garb.model'),
      createEmptyInstance: UserPendant.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'image')
    ..aOS(4, _omitFieldNames ? '' : 'jumpUrl')
    ..aOS(5, _omitFieldNames ? '' : 'type')
    ..aOS(6, _omitFieldNames ? '' : 'imageEnhance')
    ..aOS(7, _omitFieldNames ? '' : 'imageEnhanceFrame')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserPendant clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserPendant copyWith(void Function(UserPendant) updates) =>
      super.copyWith((message) => updates(message as UserPendant))
          as UserPendant;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UserPendant() / UserPendant.new instead')
  static UserPendant create() => UserPendant._();
  static $pb.GeneratedMessage $_createMessage() => UserPendant._();
  @$core.override
  UserPendant createEmptyInstance() => UserPendant._();
  @$core.pragma('dart2js:noInline')
  static UserPendant getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserPendant>(
          UserPendant.$_createMessage);
  static UserPendant? _defaultInstance;

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
  $core.String get image => $_getSZ(2);
  @$pb.TagNumber(3)
  set image($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasImage() => $_has(2);
  @$pb.TagNumber(3)
  void clearImage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get jumpUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set jumpUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasJumpUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearJumpUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get type => $_getSZ(4);
  @$pb.TagNumber(5)
  set type($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasType() => $_has(4);
  @$pb.TagNumber(5)
  void clearType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get imageEnhance => $_getSZ(5);
  @$pb.TagNumber(6)
  set imageEnhance($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasImageEnhance() => $_has(5);
  @$pb.TagNumber(6)
  void clearImageEnhance() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get imageEnhanceFrame => $_getSZ(6);
  @$pb.TagNumber(7)
  set imageEnhanceFrame($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasImageEnhanceFrame() => $_has(6);
  @$pb.TagNumber(7)
  void clearImageEnhanceFrame() => $_clearField(7);
}

class UserSailing extends $pb.GeneratedMessage {
  factory UserSailing({
    UserPendant? pendant,
    UserCardBG? cardBg,
    UserCardBG? cardBgWithFocus,
  }) {
    final result = UserSailing._();
    if (pendant != null) result.pendant = pendant;
    if (cardBg != null) result.cardBg = cardBg;
    if (cardBgWithFocus != null) result.cardBgWithFocus = cardBgWithFocus;
    return result;
  }

  UserSailing._();

  factory UserSailing.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserSailing()..mergeFromBuffer(data, registry);
  factory UserSailing.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserSailing()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserSailing',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.vas.garb.model'),
      createEmptyInstance: UserSailing.$_createMessage)
    ..aOM<UserPendant>(1, _omitFieldNames ? '' : 'pendant',
        subBuilder: UserPendant.$_createMessage)
    ..aOM<UserCardBG>(2, _omitFieldNames ? '' : 'cardBg',
        subBuilder: UserCardBG.$_createMessage)
    ..aOM<UserCardBG>(3, _omitFieldNames ? '' : 'cardBgWithFocus',
        subBuilder: UserCardBG.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserSailing clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserSailing copyWith(void Function(UserSailing) updates) =>
      super.copyWith((message) => updates(message as UserSailing))
          as UserSailing;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UserSailing() / UserSailing.new instead')
  static UserSailing create() => UserSailing._();
  static $pb.GeneratedMessage $_createMessage() => UserSailing._();
  @$core.override
  UserSailing createEmptyInstance() => UserSailing._();
  @$core.pragma('dart2js:noInline')
  static UserSailing getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserSailing>(
          UserSailing.$_createMessage);
  static UserSailing? _defaultInstance;

  @$pb.TagNumber(1)
  UserPendant get pendant => $_getN(0);
  @$pb.TagNumber(1)
  set pendant(UserPendant value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPendant() => $_has(0);
  @$pb.TagNumber(1)
  void clearPendant() => $_clearField(1);
  @$pb.TagNumber(1)
  UserPendant ensurePendant() => $_ensure(0);

  @$pb.TagNumber(2)
  UserCardBG get cardBg => $_getN(1);
  @$pb.TagNumber(2)
  set cardBg(UserCardBG value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCardBg() => $_has(1);
  @$pb.TagNumber(2)
  void clearCardBg() => $_clearField(2);
  @$pb.TagNumber(2)
  UserCardBG ensureCardBg() => $_ensure(1);

  @$pb.TagNumber(3)
  UserCardBG get cardBgWithFocus => $_getN(2);
  @$pb.TagNumber(3)
  set cardBgWithFocus(UserCardBG value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCardBgWithFocus() => $_has(2);
  @$pb.TagNumber(3)
  void clearCardBgWithFocus() => $_clearField(3);
  @$pb.TagNumber(3)
  UserCardBG ensureCardBgWithFocus() => $_ensure(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
