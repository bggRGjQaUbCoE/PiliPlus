// This is a generated file - do not edit.
//
// Generated from bilibili/account/service/v1.proto.

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

class Color extends $pb.GeneratedMessage {
  factory Color({
    $core.String? colorDay,
    $core.String? colorNight,
  }) {
    final result = Color._();
    if (colorDay != null) result.colorDay = colorDay;
    if (colorNight != null) result.colorNight = colorNight;
    return result;
  }

  Color._();

  factory Color.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Color()..mergeFromBuffer(data, registry);
  factory Color.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Color()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Color',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.account.service.v1'),
      createEmptyInstance: Color.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'colorDay')
    ..aOS(2, _omitFieldNames ? '' : 'colorNight')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Color clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Color copyWith(void Function(Color) updates) =>
      super.copyWith((message) => updates(message as Color)) as Color;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Color() / Color.new instead')
  static Color create() => Color._();
  static $pb.GeneratedMessage $_createMessage() => Color._();
  @$core.override
  Color createEmptyInstance() => Color._();
  @$core.pragma('dart2js:noInline')
  static Color getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Color>(Color.$_createMessage);
  static Color? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get colorDay => $_getSZ(0);
  @$pb.TagNumber(1)
  set colorDay($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasColorDay() => $_has(0);
  @$pb.TagNumber(1)
  void clearColorDay() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get colorNight => $_getSZ(1);
  @$pb.TagNumber(2)
  set colorNight($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasColorNight() => $_has(1);
  @$pb.TagNumber(2)
  void clearColorNight() => $_clearField(2);
}

class ColorsInfo extends $pb.GeneratedMessage {
  factory ColorsInfo({
    $core.Iterable<$fixnum.Int64>? colorIds,
    $core.Iterable<Color>? color,
  }) {
    final result = ColorsInfo._();
    if (colorIds != null) result.colorIds.addAll(colorIds);
    if (color != null) result.color.addAll(color);
    return result;
  }

  ColorsInfo._();

  factory ColorsInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ColorsInfo()..mergeFromBuffer(data, registry);
  factory ColorsInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ColorsInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ColorsInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.account.service.v1'),
      createEmptyInstance: ColorsInfo.$_createMessage)
    ..p<$fixnum.Int64>(1, _omitFieldNames ? '' : 'colorIds', $pb.PbFieldType.K6)
    ..pPM<Color>(2, _omitFieldNames ? '' : 'color',
        subBuilder: Color.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ColorsInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ColorsInfo copyWith(void Function(ColorsInfo) updates) =>
      super.copyWith((message) => updates(message as ColorsInfo)) as ColorsInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ColorsInfo() / ColorsInfo.new instead')
  static ColorsInfo create() => ColorsInfo._();
  static $pb.GeneratedMessage $_createMessage() => ColorsInfo._();
  @$core.override
  ColorsInfo createEmptyInstance() => ColorsInfo._();
  @$core.pragma('dart2js:noInline')
  static ColorsInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ColorsInfo>(ColorsInfo.$_createMessage);
  static ColorsInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$fixnum.Int64> get colorIds => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<Color> get color => $_getList(1);
}

class NameRender extends $pb.GeneratedMessage {
  factory NameRender({
    RenderSchemeEnum? renderScheme,
    ColorsInfo? colorsInfo,
  }) {
    final result = NameRender._();
    if (renderScheme != null) result.renderScheme = renderScheme;
    if (colorsInfo != null) result.colorsInfo = colorsInfo;
    return result;
  }

  NameRender._();

  factory NameRender.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NameRender()..mergeFromBuffer(data, registry);
  factory NameRender.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NameRender()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NameRender',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.account.service.v1'),
      createEmptyInstance: NameRender.$_createMessage)
    ..aE<RenderSchemeEnum>(1, _omitFieldNames ? '' : 'renderScheme',
        enumValues: RenderSchemeEnum.values)
    ..aOM<ColorsInfo>(2, _omitFieldNames ? '' : 'colorsInfo',
        subBuilder: ColorsInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NameRender clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NameRender copyWith(void Function(NameRender) updates) =>
      super.copyWith((message) => updates(message as NameRender)) as NameRender;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use NameRender() / NameRender.new instead')
  static NameRender create() => NameRender._();
  static $pb.GeneratedMessage $_createMessage() => NameRender._();
  @$core.override
  NameRender createEmptyInstance() => NameRender._();
  @$core.pragma('dart2js:noInline')
  static NameRender getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NameRender>(NameRender.$_createMessage);
  static NameRender? _defaultInstance;

  @$pb.TagNumber(1)
  RenderSchemeEnum get renderScheme => $_getN(0);
  @$pb.TagNumber(1)
  set renderScheme(RenderSchemeEnum value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRenderScheme() => $_has(0);
  @$pb.TagNumber(1)
  void clearRenderScheme() => $_clearField(1);

  @$pb.TagNumber(2)
  ColorsInfo get colorsInfo => $_getN(1);
  @$pb.TagNumber(2)
  set colorsInfo(ColorsInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasColorsInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearColorsInfo() => $_clearField(2);
  @$pb.TagNumber(2)
  ColorsInfo ensureColorsInfo() => $_ensure(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
