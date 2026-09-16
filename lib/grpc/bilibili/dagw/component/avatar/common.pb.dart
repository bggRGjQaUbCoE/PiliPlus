// This is a generated file - do not edit.
//
// Generated from bilibili/dagw/component/avatar/common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'common.pbenum.dart';

class BasicRenderSpec extends $pb.GeneratedMessage {
  factory BasicRenderSpec({
    $core.double? opacity,
  }) {
    final result = BasicRenderSpec._();
    if (opacity != null) result.opacity = opacity;
    return result;
  }

  BasicRenderSpec._();

  factory BasicRenderSpec.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BasicRenderSpec()..mergeFromBuffer(data, registry);
  factory BasicRenderSpec.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BasicRenderSpec()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BasicRenderSpec',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.common'),
      createEmptyInstance: BasicRenderSpec.$_createMessage)
    ..aD(1, _omitFieldNames ? '' : 'opacity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BasicRenderSpec clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BasicRenderSpec copyWith(void Function(BasicRenderSpec) updates) =>
      super.copyWith((message) => updates(message as BasicRenderSpec))
          as BasicRenderSpec;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BasicRenderSpec() / BasicRenderSpec.new instead')
  static BasicRenderSpec create() => BasicRenderSpec._();
  static $pb.GeneratedMessage $_createMessage() => BasicRenderSpec._();
  @$core.override
  BasicRenderSpec createEmptyInstance() => BasicRenderSpec._();
  @$core.pragma('dart2js:noInline')
  static BasicRenderSpec getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BasicRenderSpec>(
          BasicRenderSpec.$_createMessage);
  static BasicRenderSpec? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get opacity => $_getN(0);
  @$pb.TagNumber(1)
  set opacity($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOpacity() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpacity() => $_clearField(1);
}

class ColorConfig extends $pb.GeneratedMessage {
  factory ColorConfig({
    $core.bool? isDarkModeAware,
    ColorSpec? day,
    ColorSpec? night,
  }) {
    final result = ColorConfig._();
    if (isDarkModeAware != null) result.isDarkModeAware = isDarkModeAware;
    if (day != null) result.day = day;
    if (night != null) result.night = night;
    return result;
  }

  ColorConfig._();

  factory ColorConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ColorConfig()..mergeFromBuffer(data, registry);
  factory ColorConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ColorConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ColorConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.common'),
      createEmptyInstance: ColorConfig.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'isDarkModeAware')
    ..aOM<ColorSpec>(2, _omitFieldNames ? '' : 'day',
        subBuilder: ColorSpec.$_createMessage)
    ..aOM<ColorSpec>(3, _omitFieldNames ? '' : 'night',
        subBuilder: ColorSpec.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ColorConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ColorConfig copyWith(void Function(ColorConfig) updates) =>
      super.copyWith((message) => updates(message as ColorConfig))
          as ColorConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ColorConfig() / ColorConfig.new instead')
  static ColorConfig create() => ColorConfig._();
  static $pb.GeneratedMessage $_createMessage() => ColorConfig._();
  @$core.override
  ColorConfig createEmptyInstance() => ColorConfig._();
  @$core.pragma('dart2js:noInline')
  static ColorConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ColorConfig>(
          ColorConfig.$_createMessage);
  static ColorConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isDarkModeAware => $_getBF(0);
  @$pb.TagNumber(1)
  set isDarkModeAware($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsDarkModeAware() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsDarkModeAware() => $_clearField(1);

  @$pb.TagNumber(2)
  ColorSpec get day => $_getN(1);
  @$pb.TagNumber(2)
  set day(ColorSpec value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDay() => $_has(1);
  @$pb.TagNumber(2)
  void clearDay() => $_clearField(2);
  @$pb.TagNumber(2)
  ColorSpec ensureDay() => $_ensure(1);

  @$pb.TagNumber(3)
  ColorSpec get night => $_getN(2);
  @$pb.TagNumber(3)
  set night(ColorSpec value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNight() => $_has(2);
  @$pb.TagNumber(3)
  void clearNight() => $_clearField(3);
  @$pb.TagNumber(3)
  ColorSpec ensureNight() => $_ensure(2);
}

class ColorSpec extends $pb.GeneratedMessage {
  factory ColorSpec({
    $core.String? argb,
  }) {
    final result = ColorSpec._();
    if (argb != null) result.argb = argb;
    return result;
  }

  ColorSpec._();

  factory ColorSpec.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ColorSpec()..mergeFromBuffer(data, registry);
  factory ColorSpec.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ColorSpec()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ColorSpec',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.common'),
      createEmptyInstance: ColorSpec.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'argb')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ColorSpec clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ColorSpec copyWith(void Function(ColorSpec) updates) =>
      super.copyWith((message) => updates(message as ColorSpec)) as ColorSpec;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ColorSpec() / ColorSpec.new instead')
  static ColorSpec create() => ColorSpec._();
  static $pb.GeneratedMessage $_createMessage() => ColorSpec._();
  @$core.override
  ColorSpec createEmptyInstance() => ColorSpec._();
  @$core.pragma('dart2js:noInline')
  static ColorSpec getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ColorSpec>(ColorSpec.$_createMessage);
  static ColorSpec? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get argb => $_getSZ(0);
  @$pb.TagNumber(1)
  set argb($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasArgb() => $_has(0);
  @$pb.TagNumber(1)
  void clearArgb() => $_clearField(1);
}

class LayerGeneralSpec extends $pb.GeneratedMessage {
  factory LayerGeneralSpec({
    PositionSpec? posSpec,
    SizeSpec? sizeSpec,
    BasicRenderSpec? renderSpec,
  }) {
    final result = LayerGeneralSpec._();
    if (posSpec != null) result.posSpec = posSpec;
    if (sizeSpec != null) result.sizeSpec = sizeSpec;
    if (renderSpec != null) result.renderSpec = renderSpec;
    return result;
  }

  LayerGeneralSpec._();

  factory LayerGeneralSpec.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LayerGeneralSpec()..mergeFromBuffer(data, registry);
  factory LayerGeneralSpec.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LayerGeneralSpec()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LayerGeneralSpec',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.common'),
      createEmptyInstance: LayerGeneralSpec.$_createMessage)
    ..aOM<PositionSpec>(1, _omitFieldNames ? '' : 'posSpec',
        subBuilder: PositionSpec.$_createMessage)
    ..aOM<SizeSpec>(2, _omitFieldNames ? '' : 'sizeSpec',
        subBuilder: SizeSpec.$_createMessage)
    ..aOM<BasicRenderSpec>(3, _omitFieldNames ? '' : 'renderSpec',
        subBuilder: BasicRenderSpec.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LayerGeneralSpec clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LayerGeneralSpec copyWith(void Function(LayerGeneralSpec) updates) =>
      super.copyWith((message) => updates(message as LayerGeneralSpec))
          as LayerGeneralSpec;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LayerGeneralSpec() / LayerGeneralSpec.new instead')
  static LayerGeneralSpec create() => LayerGeneralSpec._();
  static $pb.GeneratedMessage $_createMessage() => LayerGeneralSpec._();
  @$core.override
  LayerGeneralSpec createEmptyInstance() => LayerGeneralSpec._();
  @$core.pragma('dart2js:noInline')
  static LayerGeneralSpec getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LayerGeneralSpec>(
          LayerGeneralSpec.$_createMessage);
  static LayerGeneralSpec? _defaultInstance;

  @$pb.TagNumber(1)
  PositionSpec get posSpec => $_getN(0);
  @$pb.TagNumber(1)
  set posSpec(PositionSpec value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPosSpec() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosSpec() => $_clearField(1);
  @$pb.TagNumber(1)
  PositionSpec ensurePosSpec() => $_ensure(0);

  @$pb.TagNumber(2)
  SizeSpec get sizeSpec => $_getN(1);
  @$pb.TagNumber(2)
  set sizeSpec(SizeSpec value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSizeSpec() => $_has(1);
  @$pb.TagNumber(2)
  void clearSizeSpec() => $_clearField(2);
  @$pb.TagNumber(2)
  SizeSpec ensureSizeSpec() => $_ensure(1);

  @$pb.TagNumber(3)
  BasicRenderSpec get renderSpec => $_getN(2);
  @$pb.TagNumber(3)
  set renderSpec(BasicRenderSpec value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRenderSpec() => $_has(2);
  @$pb.TagNumber(3)
  void clearRenderSpec() => $_clearField(3);
  @$pb.TagNumber(3)
  BasicRenderSpec ensureRenderSpec() => $_ensure(2);
}

class MaskProperty extends $pb.GeneratedMessage {
  factory MaskProperty({
    LayerGeneralSpec? generalSpec,
    ResourceSource? maskSrc,
  }) {
    final result = MaskProperty._();
    if (generalSpec != null) result.generalSpec = generalSpec;
    if (maskSrc != null) result.maskSrc = maskSrc;
    return result;
  }

  MaskProperty._();

  factory MaskProperty.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MaskProperty()..mergeFromBuffer(data, registry);
  factory MaskProperty.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MaskProperty()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MaskProperty',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.common'),
      createEmptyInstance: MaskProperty.$_createMessage)
    ..aOM<LayerGeneralSpec>(1, _omitFieldNames ? '' : 'generalSpec',
        subBuilder: LayerGeneralSpec.$_createMessage)
    ..aOM<ResourceSource>(2, _omitFieldNames ? '' : 'maskSrc',
        subBuilder: ResourceSource.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MaskProperty clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MaskProperty copyWith(void Function(MaskProperty) updates) =>
      super.copyWith((message) => updates(message as MaskProperty))
          as MaskProperty;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MaskProperty() / MaskProperty.new instead')
  static MaskProperty create() => MaskProperty._();
  static $pb.GeneratedMessage $_createMessage() => MaskProperty._();
  @$core.override
  MaskProperty createEmptyInstance() => MaskProperty._();
  @$core.pragma('dart2js:noInline')
  static MaskProperty getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MaskProperty>(
          MaskProperty.$_createMessage);
  static MaskProperty? _defaultInstance;

  @$pb.TagNumber(1)
  LayerGeneralSpec get generalSpec => $_getN(0);
  @$pb.TagNumber(1)
  set generalSpec(LayerGeneralSpec value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGeneralSpec() => $_has(0);
  @$pb.TagNumber(1)
  void clearGeneralSpec() => $_clearField(1);
  @$pb.TagNumber(1)
  LayerGeneralSpec ensureGeneralSpec() => $_ensure(0);

  @$pb.TagNumber(2)
  ResourceSource get maskSrc => $_getN(1);
  @$pb.TagNumber(2)
  set maskSrc(ResourceSource value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMaskSrc() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaskSrc() => $_clearField(2);
  @$pb.TagNumber(2)
  ResourceSource ensureMaskSrc() => $_ensure(1);
}

class NativeDrawRes extends $pb.GeneratedMessage {
  factory NativeDrawRes({
    NativeDrawRes_NativeDraw? drawType,
    NativeDrawRes_FillMode? fillMode,
    ColorConfig? colorConfig,
    $core.double? edgeWeight,
  }) {
    final result = NativeDrawRes._();
    if (drawType != null) result.drawType = drawType;
    if (fillMode != null) result.fillMode = fillMode;
    if (colorConfig != null) result.colorConfig = colorConfig;
    if (edgeWeight != null) result.edgeWeight = edgeWeight;
    return result;
  }

  NativeDrawRes._();

  factory NativeDrawRes.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NativeDrawRes()..mergeFromBuffer(data, registry);
  factory NativeDrawRes.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NativeDrawRes()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NativeDrawRes',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.common'),
      createEmptyInstance: NativeDrawRes.$_createMessage)
    ..aE<NativeDrawRes_NativeDraw>(1, _omitFieldNames ? '' : 'drawType',
        enumValues: NativeDrawRes_NativeDraw.values)
    ..aE<NativeDrawRes_FillMode>(2, _omitFieldNames ? '' : 'fillMode',
        enumValues: NativeDrawRes_FillMode.values)
    ..aOM<ColorConfig>(3, _omitFieldNames ? '' : 'colorConfig',
        subBuilder: ColorConfig.$_createMessage)
    ..aD(4, _omitFieldNames ? '' : 'edgeWeight')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NativeDrawRes clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NativeDrawRes copyWith(void Function(NativeDrawRes) updates) =>
      super.copyWith((message) => updates(message as NativeDrawRes))
          as NativeDrawRes;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use NativeDrawRes() / NativeDrawRes.new instead')
  static NativeDrawRes create() => NativeDrawRes._();
  static $pb.GeneratedMessage $_createMessage() => NativeDrawRes._();
  @$core.override
  NativeDrawRes createEmptyInstance() => NativeDrawRes._();
  @$core.pragma('dart2js:noInline')
  static NativeDrawRes getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NativeDrawRes>(
          NativeDrawRes.$_createMessage);
  static NativeDrawRes? _defaultInstance;

  @$pb.TagNumber(1)
  NativeDrawRes_NativeDraw get drawType => $_getN(0);
  @$pb.TagNumber(1)
  set drawType(NativeDrawRes_NativeDraw value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDrawType() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawType() => $_clearField(1);

  @$pb.TagNumber(2)
  NativeDrawRes_FillMode get fillMode => $_getN(1);
  @$pb.TagNumber(2)
  set fillMode(NativeDrawRes_FillMode value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFillMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearFillMode() => $_clearField(2);

  @$pb.TagNumber(3)
  ColorConfig get colorConfig => $_getN(2);
  @$pb.TagNumber(3)
  set colorConfig(ColorConfig value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasColorConfig() => $_has(2);
  @$pb.TagNumber(3)
  void clearColorConfig() => $_clearField(3);
  @$pb.TagNumber(3)
  ColorConfig ensureColorConfig() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.double get edgeWeight => $_getN(3);
  @$pb.TagNumber(4)
  set edgeWeight($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEdgeWeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearEdgeWeight() => $_clearField(4);
}

class PositionSpec extends $pb.GeneratedMessage {
  factory PositionSpec({
    PositionSpec_CoordinatePos? coordinatePos,
    $core.double? axisX,
    $core.double? axisY,
  }) {
    final result = PositionSpec._();
    if (coordinatePos != null) result.coordinatePos = coordinatePos;
    if (axisX != null) result.axisX = axisX;
    if (axisY != null) result.axisY = axisY;
    return result;
  }

  PositionSpec._();

  factory PositionSpec.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PositionSpec()..mergeFromBuffer(data, registry);
  factory PositionSpec.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PositionSpec()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PositionSpec',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.common'),
      createEmptyInstance: PositionSpec.$_createMessage)
    ..aE<PositionSpec_CoordinatePos>(1, _omitFieldNames ? '' : 'coordinatePos',
        enumValues: PositionSpec_CoordinatePos.values)
    ..aD(2, _omitFieldNames ? '' : 'axisX')
    ..aD(3, _omitFieldNames ? '' : 'axisY')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PositionSpec clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PositionSpec copyWith(void Function(PositionSpec) updates) =>
      super.copyWith((message) => updates(message as PositionSpec))
          as PositionSpec;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PositionSpec() / PositionSpec.new instead')
  static PositionSpec create() => PositionSpec._();
  static $pb.GeneratedMessage $_createMessage() => PositionSpec._();
  @$core.override
  PositionSpec createEmptyInstance() => PositionSpec._();
  @$core.pragma('dart2js:noInline')
  static PositionSpec getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PositionSpec>(
          PositionSpec.$_createMessage);
  static PositionSpec? _defaultInstance;

  @$pb.TagNumber(1)
  PositionSpec_CoordinatePos get coordinatePos => $_getN(0);
  @$pb.TagNumber(1)
  set coordinatePos(PositionSpec_CoordinatePos value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCoordinatePos() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoordinatePos() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get axisX => $_getN(1);
  @$pb.TagNumber(2)
  set axisX($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAxisX() => $_has(1);
  @$pb.TagNumber(2)
  void clearAxisX() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get axisY => $_getN(2);
  @$pb.TagNumber(3)
  set axisY($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAxisY() => $_has(2);
  @$pb.TagNumber(3)
  void clearAxisY() => $_clearField(3);
}

class RemoteRes extends $pb.GeneratedMessage {
  factory RemoteRes({
    $core.String? url,
    $core.String? bfsStyle,
  }) {
    final result = RemoteRes._();
    if (url != null) result.url = url;
    if (bfsStyle != null) result.bfsStyle = bfsStyle;
    return result;
  }

  RemoteRes._();

  factory RemoteRes.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemoteRes()..mergeFromBuffer(data, registry);
  factory RemoteRes.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RemoteRes()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoteRes',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.common'),
      createEmptyInstance: RemoteRes.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOS(2, _omitFieldNames ? '' : 'bfsStyle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoteRes clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoteRes copyWith(void Function(RemoteRes) updates) =>
      super.copyWith((message) => updates(message as RemoteRes)) as RemoteRes;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RemoteRes() / RemoteRes.new instead')
  static RemoteRes create() => RemoteRes._();
  static $pb.GeneratedMessage $_createMessage() => RemoteRes._();
  @$core.override
  RemoteRes createEmptyInstance() => RemoteRes._();
  @$core.pragma('dart2js:noInline')
  static RemoteRes getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoteRes>(RemoteRes.$_createMessage);
  static RemoteRes? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get bfsStyle => $_getSZ(1);
  @$pb.TagNumber(2)
  set bfsStyle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBfsStyle() => $_has(1);
  @$pb.TagNumber(2)
  void clearBfsStyle() => $_clearField(2);
}

enum ResourceSource_Res { remote, localValue, draw, notSet }

class ResourceSource extends $pb.GeneratedMessage {
  factory ResourceSource({
    ResourceSource_SourceType? srcType,
    ResourceSource_LocalRes? placeholder,
    RemoteRes? remote,
    $core.int? localValue,
    NativeDrawRes? draw,
  }) {
    final result = ResourceSource._();
    if (srcType != null) result.srcType = srcType;
    if (placeholder != null) result.placeholder = placeholder;
    if (remote != null) result.remote = remote;
    if (localValue != null) result.localValue = localValue;
    if (draw != null) result.draw = draw;
    return result;
  }

  ResourceSource._();

  factory ResourceSource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResourceSource()..mergeFromBuffer(data, registry);
  factory ResourceSource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResourceSource()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ResourceSource_Res>
      _ResourceSource_ResByTag = {
    3: ResourceSource_Res.remote,
    4: ResourceSource_Res.localValue,
    5: ResourceSource_Res.draw,
    0: ResourceSource_Res.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResourceSource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.common'),
      createEmptyInstance: ResourceSource.$_createMessage)
    ..oo(0, [3, 4, 5])
    ..aE<ResourceSource_SourceType>(1, _omitFieldNames ? '' : 'srcType',
        enumValues: ResourceSource_SourceType.values)
    ..aE<ResourceSource_LocalRes>(2, _omitFieldNames ? '' : 'placeholder',
        enumValues: ResourceSource_LocalRes.values)
    ..aOM<RemoteRes>(3, _omitFieldNames ? '' : 'remote',
        subBuilder: RemoteRes.$_createMessage)
    ..aI(4, _omitFieldNames ? '' : 'localValue')
    ..aOM<NativeDrawRes>(5, _omitFieldNames ? '' : 'draw',
        subBuilder: NativeDrawRes.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceSource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResourceSource copyWith(void Function(ResourceSource) updates) =>
      super.copyWith((message) => updates(message as ResourceSource))
          as ResourceSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ResourceSource() / ResourceSource.new instead')
  static ResourceSource create() => ResourceSource._();
  static $pb.GeneratedMessage $_createMessage() => ResourceSource._();
  @$core.override
  ResourceSource createEmptyInstance() => ResourceSource._();
  @$core.pragma('dart2js:noInline')
  static ResourceSource getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResourceSource>(
          ResourceSource.$_createMessage);
  static ResourceSource? _defaultInstance;

  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  ResourceSource_Res whichRes() => _ResourceSource_ResByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearRes() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ResourceSource_SourceType get srcType => $_getN(0);
  @$pb.TagNumber(1)
  set srcType(ResourceSource_SourceType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSrcType() => $_has(0);
  @$pb.TagNumber(1)
  void clearSrcType() => $_clearField(1);

  @$pb.TagNumber(2)
  ResourceSource_LocalRes get placeholder => $_getN(1);
  @$pb.TagNumber(2)
  set placeholder(ResourceSource_LocalRes value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlaceholder() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaceholder() => $_clearField(2);

  @$pb.TagNumber(3)
  RemoteRes get remote => $_getN(2);
  @$pb.TagNumber(3)
  set remote(RemoteRes value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRemote() => $_has(2);
  @$pb.TagNumber(3)
  void clearRemote() => $_clearField(3);
  @$pb.TagNumber(3)
  RemoteRes ensureRemote() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get localValue => $_getIZ(3);
  @$pb.TagNumber(4)
  set localValue($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLocalValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocalValue() => $_clearField(4);

  @$pb.TagNumber(5)
  NativeDrawRes get draw => $_getN(4);
  @$pb.TagNumber(5)
  set draw(NativeDrawRes value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDraw() => $_has(4);
  @$pb.TagNumber(5)
  void clearDraw() => $_clearField(5);
  @$pb.TagNumber(5)
  NativeDrawRes ensureDraw() => $_ensure(4);
}

class SizeSpec extends $pb.GeneratedMessage {
  factory SizeSpec({
    $core.double? width,
    $core.double? height,
  }) {
    final result = SizeSpec._();
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    return result;
  }

  SizeSpec._();

  factory SizeSpec.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SizeSpec()..mergeFromBuffer(data, registry);
  factory SizeSpec.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SizeSpec()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SizeSpec',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.common'),
      createEmptyInstance: SizeSpec.$_createMessage)
    ..aD(1, _omitFieldNames ? '' : 'width')
    ..aD(2, _omitFieldNames ? '' : 'height')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SizeSpec clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SizeSpec copyWith(void Function(SizeSpec) updates) =>
      super.copyWith((message) => updates(message as SizeSpec)) as SizeSpec;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SizeSpec() / SizeSpec.new instead')
  static SizeSpec create() => SizeSpec._();
  static $pb.GeneratedMessage $_createMessage() => SizeSpec._();
  @$core.override
  SizeSpec createEmptyInstance() => SizeSpec._();
  @$core.pragma('dart2js:noInline')
  static SizeSpec getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SizeSpec>(SizeSpec.$_createMessage);
  static SizeSpec? _defaultInstance;

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
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
