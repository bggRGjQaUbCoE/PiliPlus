// This is a generated file - do not edit.
//
// Generated from bilibili/dagw/component/avatar/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $0;
import 'v1.pbenum.dart';
import 'v1/plugin.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'v1.pbenum.dart';

class AvatarItem extends $pb.GeneratedMessage {
  factory AvatarItem({
    $0.SizeSpec? containerSize,
    $core.Iterable<LayerGroup>? layers,
    LayerGroup? fallbackLayers,
    $fixnum.Int64? mid,
  }) {
    final result = AvatarItem._();
    if (containerSize != null) result.containerSize = containerSize;
    if (layers != null) result.layers.addAll(layers);
    if (fallbackLayers != null) result.fallbackLayers = fallbackLayers;
    if (mid != null) result.mid = mid;
    return result;
  }

  AvatarItem._();

  factory AvatarItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AvatarItem()..mergeFromBuffer(data, registry);
  factory AvatarItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AvatarItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AvatarItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1'),
      createEmptyInstance: AvatarItem.$_createMessage)
    ..aOM<$0.SizeSpec>(1, _omitFieldNames ? '' : 'containerSize',
        subBuilder: $0.SizeSpec.$_createMessage)
    ..pPM<LayerGroup>(2, _omitFieldNames ? '' : 'layers',
        subBuilder: LayerGroup.$_createMessage)
    ..aOM<LayerGroup>(3, _omitFieldNames ? '' : 'fallbackLayers',
        subBuilder: LayerGroup.$_createMessage)
    ..aInt64(4, _omitFieldNames ? '' : 'mid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AvatarItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AvatarItem copyWith(void Function(AvatarItem) updates) =>
      super.copyWith((message) => updates(message as AvatarItem)) as AvatarItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AvatarItem() / AvatarItem.new instead')
  static AvatarItem create() => AvatarItem._();
  static $pb.GeneratedMessage $_createMessage() => AvatarItem._();
  @$core.override
  AvatarItem createEmptyInstance() => AvatarItem._();
  @$core.pragma('dart2js:noInline')
  static AvatarItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AvatarItem>(AvatarItem.$_createMessage);
  static AvatarItem? _defaultInstance;

  @$pb.TagNumber(1)
  $0.SizeSpec get containerSize => $_getN(0);
  @$pb.TagNumber(1)
  set containerSize($0.SizeSpec value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContainerSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearContainerSize() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.SizeSpec ensureContainerSize() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<LayerGroup> get layers => $_getList(1);

  @$pb.TagNumber(3)
  LayerGroup get fallbackLayers => $_getN(2);
  @$pb.TagNumber(3)
  set fallbackLayers(LayerGroup value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFallbackLayers() => $_has(2);
  @$pb.TagNumber(3)
  void clearFallbackLayers() => $_clearField(3);
  @$pb.TagNumber(3)
  LayerGroup ensureFallbackLayers() => $_ensure(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get mid => $_getI64(3);
  @$pb.TagNumber(4)
  set mid($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMid() => $_has(3);
  @$pb.TagNumber(4)
  void clearMid() => $_clearField(4);
}

enum BasicLayerResource_Payload {
  resImage,
  resAnimation,
  resNativeDraw,
  notSet
}

class BasicLayerResource extends $pb.GeneratedMessage {
  factory BasicLayerResource({
    BasicLayerResource_ResType? resType,
    ResImage? resImage,
    ResAnimation? resAnimation,
    ResNativeDraw? resNativeDraw,
  }) {
    final result = BasicLayerResource._();
    if (resType != null) result.resType = resType;
    if (resImage != null) result.resImage = resImage;
    if (resAnimation != null) result.resAnimation = resAnimation;
    if (resNativeDraw != null) result.resNativeDraw = resNativeDraw;
    return result;
  }

  BasicLayerResource._();

  factory BasicLayerResource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BasicLayerResource()..mergeFromBuffer(data, registry);
  factory BasicLayerResource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BasicLayerResource()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, BasicLayerResource_Payload>
      _BasicLayerResource_PayloadByTag = {
    2: BasicLayerResource_Payload.resImage,
    3: BasicLayerResource_Payload.resAnimation,
    4: BasicLayerResource_Payload.resNativeDraw,
    0: BasicLayerResource_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BasicLayerResource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1'),
      createEmptyInstance: BasicLayerResource.$_createMessage)
    ..oo(0, [2, 3, 4])
    ..aE<BasicLayerResource_ResType>(1, _omitFieldNames ? '' : 'resType',
        enumValues: BasicLayerResource_ResType.values)
    ..aOM<ResImage>(2, _omitFieldNames ? '' : 'resImage',
        subBuilder: ResImage.$_createMessage)
    ..aOM<ResAnimation>(3, _omitFieldNames ? '' : 'resAnimation',
        subBuilder: ResAnimation.$_createMessage)
    ..aOM<ResNativeDraw>(4, _omitFieldNames ? '' : 'resNativeDraw',
        subBuilder: ResNativeDraw.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BasicLayerResource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BasicLayerResource copyWith(void Function(BasicLayerResource) updates) =>
      super.copyWith((message) => updates(message as BasicLayerResource))
          as BasicLayerResource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BasicLayerResource() / BasicLayerResource.new instead')
  static BasicLayerResource create() => BasicLayerResource._();
  static $pb.GeneratedMessage $_createMessage() => BasicLayerResource._();
  @$core.override
  BasicLayerResource createEmptyInstance() => BasicLayerResource._();
  @$core.pragma('dart2js:noInline')
  static BasicLayerResource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BasicLayerResource>(
          BasicLayerResource.$_createMessage);
  static BasicLayerResource? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  BasicLayerResource_Payload whichPayload() =>
      _BasicLayerResource_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  BasicLayerResource_ResType get resType => $_getN(0);
  @$pb.TagNumber(1)
  set resType(BasicLayerResource_ResType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResType() => $_has(0);
  @$pb.TagNumber(1)
  void clearResType() => $_clearField(1);

  @$pb.TagNumber(2)
  ResImage get resImage => $_getN(1);
  @$pb.TagNumber(2)
  set resImage(ResImage value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasResImage() => $_has(1);
  @$pb.TagNumber(2)
  void clearResImage() => $_clearField(2);
  @$pb.TagNumber(2)
  ResImage ensureResImage() => $_ensure(1);

  @$pb.TagNumber(3)
  ResAnimation get resAnimation => $_getN(2);
  @$pb.TagNumber(3)
  set resAnimation(ResAnimation value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasResAnimation() => $_has(2);
  @$pb.TagNumber(3)
  void clearResAnimation() => $_clearField(3);
  @$pb.TagNumber(3)
  ResAnimation ensureResAnimation() => $_ensure(2);

  @$pb.TagNumber(4)
  ResNativeDraw get resNativeDraw => $_getN(3);
  @$pb.TagNumber(4)
  set resNativeDraw(ResNativeDraw value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasResNativeDraw() => $_has(3);
  @$pb.TagNumber(4)
  void clearResNativeDraw() => $_clearField(4);
  @$pb.TagNumber(4)
  ResNativeDraw ensureResNativeDraw() => $_ensure(3);
}

class GeneralConfig extends $pb.GeneratedMessage {
  factory GeneralConfig({
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? webCssStyle,
  }) {
    final result = GeneralConfig._();
    if (webCssStyle != null) result.webCssStyle.addEntries(webCssStyle);
    return result;
  }

  GeneralConfig._();

  factory GeneralConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeneralConfig()..mergeFromBuffer(data, registry);
  factory GeneralConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeneralConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GeneralConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1'),
      createEmptyInstance: GeneralConfig.$_createMessage)
    ..m<$core.String, $core.String>(1, _omitFieldNames ? '' : 'webCssStyle',
        entryClassName: 'GeneralConfig.WebCssStyleEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.dagw.component.avatar.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeneralConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeneralConfig copyWith(void Function(GeneralConfig) updates) =>
      super.copyWith((message) => updates(message as GeneralConfig))
          as GeneralConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GeneralConfig() / GeneralConfig.new instead')
  static GeneralConfig create() => GeneralConfig._();
  static $pb.GeneratedMessage $_createMessage() => GeneralConfig._();
  @$core.override
  GeneralConfig createEmptyInstance() => GeneralConfig._();
  @$core.pragma('dart2js:noInline')
  static GeneralConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GeneralConfig>(
          GeneralConfig.$_createMessage);
  static GeneralConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, $core.String> get webCssStyle => $_getMap(0);
}

class Layer extends $pb.GeneratedMessage {
  factory Layer({
    $core.String? layerId,
    $core.bool? visible,
    $0.LayerGeneralSpec? generalSpec,
    LayerConfig? layerConfig,
    BasicLayerResource? resource,
  }) {
    final result = Layer._();
    if (layerId != null) result.layerId = layerId;
    if (visible != null) result.visible = visible;
    if (generalSpec != null) result.generalSpec = generalSpec;
    if (layerConfig != null) result.layerConfig = layerConfig;
    if (resource != null) result.resource = resource;
    return result;
  }

  Layer._();

  factory Layer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Layer()..mergeFromBuffer(data, registry);
  factory Layer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Layer()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Layer',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1'),
      createEmptyInstance: Layer.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'layerId')
    ..aOB(2, _omitFieldNames ? '' : 'visible')
    ..aOM<$0.LayerGeneralSpec>(3, _omitFieldNames ? '' : 'generalSpec',
        subBuilder: $0.LayerGeneralSpec.$_createMessage)
    ..aOM<LayerConfig>(4, _omitFieldNames ? '' : 'layerConfig',
        subBuilder: LayerConfig.$_createMessage)
    ..aOM<BasicLayerResource>(5, _omitFieldNames ? '' : 'resource',
        subBuilder: BasicLayerResource.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Layer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Layer copyWith(void Function(Layer) updates) =>
      super.copyWith((message) => updates(message as Layer)) as Layer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Layer() / Layer.new instead')
  static Layer create() => Layer._();
  static $pb.GeneratedMessage $_createMessage() => Layer._();
  @$core.override
  Layer createEmptyInstance() => Layer._();
  @$core.pragma('dart2js:noInline')
  static Layer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Layer>(Layer.$_createMessage);
  static Layer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get layerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set layerId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get visible => $_getBF(1);
  @$pb.TagNumber(2)
  set visible($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVisible() => $_has(1);
  @$pb.TagNumber(2)
  void clearVisible() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.LayerGeneralSpec get generalSpec => $_getN(2);
  @$pb.TagNumber(3)
  set generalSpec($0.LayerGeneralSpec value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasGeneralSpec() => $_has(2);
  @$pb.TagNumber(3)
  void clearGeneralSpec() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.LayerGeneralSpec ensureGeneralSpec() => $_ensure(2);

  @$pb.TagNumber(4)
  LayerConfig get layerConfig => $_getN(3);
  @$pb.TagNumber(4)
  set layerConfig(LayerConfig value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLayerConfig() => $_has(3);
  @$pb.TagNumber(4)
  void clearLayerConfig() => $_clearField(4);
  @$pb.TagNumber(4)
  LayerConfig ensureLayerConfig() => $_ensure(3);

  @$pb.TagNumber(5)
  BasicLayerResource get resource => $_getN(4);
  @$pb.TagNumber(5)
  set resource(BasicLayerResource value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasResource() => $_has(4);
  @$pb.TagNumber(5)
  void clearResource() => $_clearField(5);
  @$pb.TagNumber(5)
  BasicLayerResource ensureResource() => $_ensure(4);
}

class LayerConfig extends $pb.GeneratedMessage {
  factory LayerConfig({
    $core.Iterable<$core.MapEntry<$core.String, LayerTagConfig>>? tags,
    $core.bool? isCritical,
    $core.bool? allowOverPaint,
    $0.MaskProperty? layerMask,
  }) {
    final result = LayerConfig._();
    if (tags != null) result.tags.addEntries(tags);
    if (isCritical != null) result.isCritical = isCritical;
    if (allowOverPaint != null) result.allowOverPaint = allowOverPaint;
    if (layerMask != null) result.layerMask = layerMask;
    return result;
  }

  LayerConfig._();

  factory LayerConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LayerConfig()..mergeFromBuffer(data, registry);
  factory LayerConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LayerConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LayerConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1'),
      createEmptyInstance: LayerConfig.$_createMessage)
    ..m<$core.String, LayerTagConfig>(1, _omitFieldNames ? '' : 'tags',
        entryClassName: 'LayerConfig.TagsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: LayerTagConfig.$_createMessage,
        valueDefaultOrMaker: LayerTagConfig.getDefault,
        packageName: const $pb.PackageName('bilibili.dagw.component.avatar.v1'))
    ..aOB(2, _omitFieldNames ? '' : 'isCritical')
    ..aOB(3, _omitFieldNames ? '' : 'allowOverPaint')
    ..aOM<$0.MaskProperty>(4, _omitFieldNames ? '' : 'layerMask',
        subBuilder: $0.MaskProperty.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LayerConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LayerConfig copyWith(void Function(LayerConfig) updates) =>
      super.copyWith((message) => updates(message as LayerConfig))
          as LayerConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LayerConfig() / LayerConfig.new instead')
  static LayerConfig create() => LayerConfig._();
  static $pb.GeneratedMessage $_createMessage() => LayerConfig._();
  @$core.override
  LayerConfig createEmptyInstance() => LayerConfig._();
  @$core.pragma('dart2js:noInline')
  static LayerConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LayerConfig>(
          LayerConfig.$_createMessage);
  static LayerConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, LayerTagConfig> get tags => $_getMap(0);

  @$pb.TagNumber(2)
  $core.bool get isCritical => $_getBF(1);
  @$pb.TagNumber(2)
  set isCritical($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsCritical() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsCritical() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get allowOverPaint => $_getBF(2);
  @$pb.TagNumber(3)
  set allowOverPaint($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAllowOverPaint() => $_has(2);
  @$pb.TagNumber(3)
  void clearAllowOverPaint() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.MaskProperty get layerMask => $_getN(3);
  @$pb.TagNumber(4)
  set layerMask($0.MaskProperty value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLayerMask() => $_has(3);
  @$pb.TagNumber(4)
  void clearLayerMask() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.MaskProperty ensureLayerMask() => $_ensure(3);
}

class LayerGroup extends $pb.GeneratedMessage {
  factory LayerGroup({
    $core.String? groupId,
    $core.Iterable<Layer>? layers,
    $0.MaskProperty? groupMask,
    $core.bool? isCriticalGroup,
  }) {
    final result = LayerGroup._();
    if (groupId != null) result.groupId = groupId;
    if (layers != null) result.layers.addAll(layers);
    if (groupMask != null) result.groupMask = groupMask;
    if (isCriticalGroup != null) result.isCriticalGroup = isCriticalGroup;
    return result;
  }

  LayerGroup._();

  factory LayerGroup.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LayerGroup()..mergeFromBuffer(data, registry);
  factory LayerGroup.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LayerGroup()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LayerGroup',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1'),
      createEmptyInstance: LayerGroup.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'groupId')
    ..pPM<Layer>(2, _omitFieldNames ? '' : 'layers',
        subBuilder: Layer.$_createMessage)
    ..aOM<$0.MaskProperty>(3, _omitFieldNames ? '' : 'groupMask',
        subBuilder: $0.MaskProperty.$_createMessage)
    ..aOB(4, _omitFieldNames ? '' : 'isCriticalGroup')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LayerGroup clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LayerGroup copyWith(void Function(LayerGroup) updates) =>
      super.copyWith((message) => updates(message as LayerGroup)) as LayerGroup;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LayerGroup() / LayerGroup.new instead')
  static LayerGroup create() => LayerGroup._();
  static $pb.GeneratedMessage $_createMessage() => LayerGroup._();
  @$core.override
  LayerGroup createEmptyInstance() => LayerGroup._();
  @$core.pragma('dart2js:noInline')
  static LayerGroup getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LayerGroup>(LayerGroup.$_createMessage);
  static LayerGroup? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get groupId => $_getSZ(0);
  @$pb.TagNumber(1)
  set groupId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGroupId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Layer> get layers => $_getList(1);

  @$pb.TagNumber(3)
  $0.MaskProperty get groupMask => $_getN(2);
  @$pb.TagNumber(3)
  set groupMask($0.MaskProperty value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasGroupMask() => $_has(2);
  @$pb.TagNumber(3)
  void clearGroupMask() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.MaskProperty ensureGroupMask() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get isCriticalGroup => $_getBF(3);
  @$pb.TagNumber(4)
  set isCriticalGroup($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsCriticalGroup() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsCriticalGroup() => $_clearField(4);
}

enum LayerTagConfig_Config {
  generalConfig,
  gyroConfig,
  commentDoubleClickConfig,
  liveAnimeConfig,
  webLiveAnimeConfig,
  followIconConfig,
  followActionConfig,
  notSet
}

class LayerTagConfig extends $pb.GeneratedMessage {
  factory LayerTagConfig({
    LayerTagConfig_TagConfigType? configType,
    GeneralConfig? generalConfig,
    $1.GyroConfig? gyroConfig,
    $1.CommentDoubleClickConfig? commentDoubleClickConfig,
    $1.LiveAnimeConfig? liveAnimeConfig,
    $1.WebLiveAnimeConfig? webLiveAnimeConfig,
    $1.FollowIconConfig? followIconConfig,
    $1.FollowActionConfig? followActionConfig,
  }) {
    final result = LayerTagConfig._();
    if (configType != null) result.configType = configType;
    if (generalConfig != null) result.generalConfig = generalConfig;
    if (gyroConfig != null) result.gyroConfig = gyroConfig;
    if (commentDoubleClickConfig != null)
      result.commentDoubleClickConfig = commentDoubleClickConfig;
    if (liveAnimeConfig != null) result.liveAnimeConfig = liveAnimeConfig;
    if (webLiveAnimeConfig != null)
      result.webLiveAnimeConfig = webLiveAnimeConfig;
    if (followIconConfig != null) result.followIconConfig = followIconConfig;
    if (followActionConfig != null)
      result.followActionConfig = followActionConfig;
    return result;
  }

  LayerTagConfig._();

  factory LayerTagConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LayerTagConfig()..mergeFromBuffer(data, registry);
  factory LayerTagConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LayerTagConfig()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, LayerTagConfig_Config>
      _LayerTagConfig_ConfigByTag = {
    2: LayerTagConfig_Config.generalConfig,
    3: LayerTagConfig_Config.gyroConfig,
    4: LayerTagConfig_Config.commentDoubleClickConfig,
    5: LayerTagConfig_Config.liveAnimeConfig,
    6: LayerTagConfig_Config.webLiveAnimeConfig,
    7: LayerTagConfig_Config.followIconConfig,
    8: LayerTagConfig_Config.followActionConfig,
    0: LayerTagConfig_Config.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LayerTagConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1'),
      createEmptyInstance: LayerTagConfig.$_createMessage)
    ..oo(0, [2, 3, 4, 5, 6, 7, 8])
    ..aE<LayerTagConfig_TagConfigType>(1, _omitFieldNames ? '' : 'configType',
        enumValues: LayerTagConfig_TagConfigType.values)
    ..aOM<GeneralConfig>(2, _omitFieldNames ? '' : 'generalConfig',
        subBuilder: GeneralConfig.$_createMessage)
    ..aOM<$1.GyroConfig>(3, _omitFieldNames ? '' : 'gyroConfig',
        subBuilder: $1.GyroConfig.$_createMessage)
    ..aOM<$1.CommentDoubleClickConfig>(
        4, _omitFieldNames ? '' : 'commentDoubleClickConfig',
        subBuilder: $1.CommentDoubleClickConfig.$_createMessage)
    ..aOM<$1.LiveAnimeConfig>(5, _omitFieldNames ? '' : 'liveAnimeConfig',
        subBuilder: $1.LiveAnimeConfig.$_createMessage)
    ..aOM<$1.WebLiveAnimeConfig>(6, _omitFieldNames ? '' : 'webLiveAnimeConfig',
        subBuilder: $1.WebLiveAnimeConfig.$_createMessage)
    ..aOM<$1.FollowIconConfig>(7, _omitFieldNames ? '' : 'followIconConfig',
        subBuilder: $1.FollowIconConfig.$_createMessage)
    ..aOM<$1.FollowActionConfig>(8, _omitFieldNames ? '' : 'followActionConfig',
        subBuilder: $1.FollowActionConfig.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LayerTagConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LayerTagConfig copyWith(void Function(LayerTagConfig) updates) =>
      super.copyWith((message) => updates(message as LayerTagConfig))
          as LayerTagConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LayerTagConfig() / LayerTagConfig.new instead')
  static LayerTagConfig create() => LayerTagConfig._();
  static $pb.GeneratedMessage $_createMessage() => LayerTagConfig._();
  @$core.override
  LayerTagConfig createEmptyInstance() => LayerTagConfig._();
  @$core.pragma('dart2js:noInline')
  static LayerTagConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LayerTagConfig>(
          LayerTagConfig.$_createMessage);
  static LayerTagConfig? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  LayerTagConfig_Config whichConfig() =>
      _LayerTagConfig_ConfigByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  void clearConfig() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  LayerTagConfig_TagConfigType get configType => $_getN(0);
  @$pb.TagNumber(1)
  set configType(LayerTagConfig_TagConfigType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasConfigType() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfigType() => $_clearField(1);

  @$pb.TagNumber(2)
  GeneralConfig get generalConfig => $_getN(1);
  @$pb.TagNumber(2)
  set generalConfig(GeneralConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasGeneralConfig() => $_has(1);
  @$pb.TagNumber(2)
  void clearGeneralConfig() => $_clearField(2);
  @$pb.TagNumber(2)
  GeneralConfig ensureGeneralConfig() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.GyroConfig get gyroConfig => $_getN(2);
  @$pb.TagNumber(3)
  set gyroConfig($1.GyroConfig value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasGyroConfig() => $_has(2);
  @$pb.TagNumber(3)
  void clearGyroConfig() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.GyroConfig ensureGyroConfig() => $_ensure(2);

  @$pb.TagNumber(4)
  $1.CommentDoubleClickConfig get commentDoubleClickConfig => $_getN(3);
  @$pb.TagNumber(4)
  set commentDoubleClickConfig($1.CommentDoubleClickConfig value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCommentDoubleClickConfig() => $_has(3);
  @$pb.TagNumber(4)
  void clearCommentDoubleClickConfig() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.CommentDoubleClickConfig ensureCommentDoubleClickConfig() => $_ensure(3);

  @$pb.TagNumber(5)
  $1.LiveAnimeConfig get liveAnimeConfig => $_getN(4);
  @$pb.TagNumber(5)
  set liveAnimeConfig($1.LiveAnimeConfig value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLiveAnimeConfig() => $_has(4);
  @$pb.TagNumber(5)
  void clearLiveAnimeConfig() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.LiveAnimeConfig ensureLiveAnimeConfig() => $_ensure(4);

  @$pb.TagNumber(6)
  $1.WebLiveAnimeConfig get webLiveAnimeConfig => $_getN(5);
  @$pb.TagNumber(6)
  set webLiveAnimeConfig($1.WebLiveAnimeConfig value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasWebLiveAnimeConfig() => $_has(5);
  @$pb.TagNumber(6)
  void clearWebLiveAnimeConfig() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.WebLiveAnimeConfig ensureWebLiveAnimeConfig() => $_ensure(5);

  @$pb.TagNumber(7)
  $1.FollowIconConfig get followIconConfig => $_getN(6);
  @$pb.TagNumber(7)
  set followIconConfig($1.FollowIconConfig value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasFollowIconConfig() => $_has(6);
  @$pb.TagNumber(7)
  void clearFollowIconConfig() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.FollowIconConfig ensureFollowIconConfig() => $_ensure(6);

  @$pb.TagNumber(8)
  $1.FollowActionConfig get followActionConfig => $_getN(7);
  @$pb.TagNumber(8)
  set followActionConfig($1.FollowActionConfig value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasFollowActionConfig() => $_has(7);
  @$pb.TagNumber(8)
  void clearFollowActionConfig() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.FollowActionConfig ensureFollowActionConfig() => $_ensure(7);
}

class ResAnimation extends $pb.GeneratedMessage {
  factory ResAnimation({
    $0.ResourceSource? webpSrc,
  }) {
    final result = ResAnimation._();
    if (webpSrc != null) result.webpSrc = webpSrc;
    return result;
  }

  ResAnimation._();

  factory ResAnimation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResAnimation()..mergeFromBuffer(data, registry);
  factory ResAnimation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResAnimation()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResAnimation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1'),
      createEmptyInstance: ResAnimation.$_createMessage)
    ..aOM<$0.ResourceSource>(1, _omitFieldNames ? '' : 'webpSrc',
        subBuilder: $0.ResourceSource.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResAnimation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResAnimation copyWith(void Function(ResAnimation) updates) =>
      super.copyWith((message) => updates(message as ResAnimation))
          as ResAnimation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ResAnimation() / ResAnimation.new instead')
  static ResAnimation create() => ResAnimation._();
  static $pb.GeneratedMessage $_createMessage() => ResAnimation._();
  @$core.override
  ResAnimation createEmptyInstance() => ResAnimation._();
  @$core.pragma('dart2js:noInline')
  static ResAnimation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResAnimation>(
          ResAnimation.$_createMessage);
  static ResAnimation? _defaultInstance;

  @$pb.TagNumber(1)
  $0.ResourceSource get webpSrc => $_getN(0);
  @$pb.TagNumber(1)
  set webpSrc($0.ResourceSource value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWebpSrc() => $_has(0);
  @$pb.TagNumber(1)
  void clearWebpSrc() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.ResourceSource ensureWebpSrc() => $_ensure(0);
}

class ResImage extends $pb.GeneratedMessage {
  factory ResImage({
    $0.ResourceSource? imageSrc,
  }) {
    final result = ResImage._();
    if (imageSrc != null) result.imageSrc = imageSrc;
    return result;
  }

  ResImage._();

  factory ResImage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResImage()..mergeFromBuffer(data, registry);
  factory ResImage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResImage()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResImage',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1'),
      createEmptyInstance: ResImage.$_createMessage)
    ..aOM<$0.ResourceSource>(1, _omitFieldNames ? '' : 'imageSrc',
        subBuilder: $0.ResourceSource.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResImage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResImage copyWith(void Function(ResImage) updates) =>
      super.copyWith((message) => updates(message as ResImage)) as ResImage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ResImage() / ResImage.new instead')
  static ResImage create() => ResImage._();
  static $pb.GeneratedMessage $_createMessage() => ResImage._();
  @$core.override
  ResImage createEmptyInstance() => ResImage._();
  @$core.pragma('dart2js:noInline')
  static ResImage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResImage>(ResImage.$_createMessage);
  static ResImage? _defaultInstance;

  @$pb.TagNumber(1)
  $0.ResourceSource get imageSrc => $_getN(0);
  @$pb.TagNumber(1)
  set imageSrc($0.ResourceSource value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasImageSrc() => $_has(0);
  @$pb.TagNumber(1)
  void clearImageSrc() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.ResourceSource ensureImageSrc() => $_ensure(0);
}

class ResNativeDraw extends $pb.GeneratedMessage {
  factory ResNativeDraw({
    $0.ResourceSource? drawSrc,
  }) {
    final result = ResNativeDraw._();
    if (drawSrc != null) result.drawSrc = drawSrc;
    return result;
  }

  ResNativeDraw._();

  factory ResNativeDraw.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResNativeDraw()..mergeFromBuffer(data, registry);
  factory ResNativeDraw.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ResNativeDraw()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResNativeDraw',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.dagw.component.avatar.v1'),
      createEmptyInstance: ResNativeDraw.$_createMessage)
    ..aOM<$0.ResourceSource>(1, _omitFieldNames ? '' : 'drawSrc',
        subBuilder: $0.ResourceSource.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResNativeDraw clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResNativeDraw copyWith(void Function(ResNativeDraw) updates) =>
      super.copyWith((message) => updates(message as ResNativeDraw))
          as ResNativeDraw;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ResNativeDraw() / ResNativeDraw.new instead')
  static ResNativeDraw create() => ResNativeDraw._();
  static $pb.GeneratedMessage $_createMessage() => ResNativeDraw._();
  @$core.override
  ResNativeDraw createEmptyInstance() => ResNativeDraw._();
  @$core.pragma('dart2js:noInline')
  static ResNativeDraw getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResNativeDraw>(
          ResNativeDraw.$_createMessage);
  static ResNativeDraw? _defaultInstance;

  @$pb.TagNumber(1)
  $0.ResourceSource get drawSrc => $_getN(0);
  @$pb.TagNumber(1)
  set drawSrc($0.ResourceSource value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDrawSrc() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawSrc() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.ResourceSource ensureDrawSrc() => $_ensure(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
