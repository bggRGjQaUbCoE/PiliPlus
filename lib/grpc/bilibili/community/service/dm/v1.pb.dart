// This is a generated file - do not edit.
//
// Generated from bilibili/community/service/dm/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'v1.pbenum.dart';

class Avatar extends $pb.GeneratedMessage {
  factory Avatar({
    $core.String? id,
    $core.String? url,
    AvatarType? avatarType,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (url != null) result.url = url;
    if (avatarType != null) result.avatarType = avatarType;
    return result;
  }

  Avatar._();

  factory Avatar.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Avatar.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Avatar',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..aE<AvatarType>(3, _omitFieldNames ? '' : 'avatarType',
        enumValues: AvatarType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Avatar clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Avatar copyWith(void Function(Avatar) updates) =>
      super.copyWith((message) => updates(message as Avatar)) as Avatar;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Avatar create() => Avatar._();
  @$core.override
  Avatar createEmptyInstance() => create();
  static $pb.PbList<Avatar> createRepeated() => $pb.PbList<Avatar>();
  @$core.pragma('dart2js:noInline')
  static Avatar getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Avatar>(create);
  static Avatar? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  AvatarType get avatarType => $_getN(2);
  @$pb.TagNumber(3)
  set avatarType(AvatarType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAvatarType() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvatarType() => $_clearField(3);
}

class Bubble extends $pb.GeneratedMessage {
  factory Bubble({
    $core.String? text,
    $core.String? url,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (url != null) result.url = url;
    return result;
  }

  Bubble._();

  factory Bubble.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Bubble.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Bubble',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Bubble clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Bubble copyWith(void Function(Bubble) updates) =>
      super.copyWith((message) => updates(message as Bubble)) as Bubble;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Bubble create() => Bubble._();
  @$core.override
  Bubble createEmptyInstance() => create();
  static $pb.PbList<Bubble> createRepeated() => $pb.PbList<Bubble>();
  @$core.pragma('dart2js:noInline')
  static Bubble getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Bubble>(create);
  static Bubble? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);
}

class BubbleV2 extends $pb.GeneratedMessage {
  factory BubbleV2({
    $core.String? text,
    $core.String? url,
    BubbleType? bubbleType,
    $core.bool? exposureOnce,
    ExposureType? exposureType,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (url != null) result.url = url;
    if (bubbleType != null) result.bubbleType = bubbleType;
    if (exposureOnce != null) result.exposureOnce = exposureOnce;
    if (exposureType != null) result.exposureType = exposureType;
    return result;
  }

  BubbleV2._();

  factory BubbleV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BubbleV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BubbleV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..aE<BubbleType>(3, _omitFieldNames ? '' : 'bubbleType',
        enumValues: BubbleType.values)
    ..aOB(4, _omitFieldNames ? '' : 'exposureOnce')
    ..aE<ExposureType>(5, _omitFieldNames ? '' : 'exposureType',
        enumValues: ExposureType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BubbleV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BubbleV2 copyWith(void Function(BubbleV2) updates) =>
      super.copyWith((message) => updates(message as BubbleV2)) as BubbleV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BubbleV2 create() => BubbleV2._();
  @$core.override
  BubbleV2 createEmptyInstance() => create();
  static $pb.PbList<BubbleV2> createRepeated() => $pb.PbList<BubbleV2>();
  @$core.pragma('dart2js:noInline')
  static BubbleV2 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BubbleV2>(create);
  static BubbleV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  BubbleType get bubbleType => $_getN(2);
  @$pb.TagNumber(3)
  set bubbleType(BubbleType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBubbleType() => $_has(2);
  @$pb.TagNumber(3)
  void clearBubbleType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get exposureOnce => $_getBF(3);
  @$pb.TagNumber(4)
  set exposureOnce($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExposureOnce() => $_has(3);
  @$pb.TagNumber(4)
  void clearExposureOnce() => $_clearField(4);

  @$pb.TagNumber(5)
  ExposureType get exposureType => $_getN(4);
  @$pb.TagNumber(5)
  set exposureType(ExposureType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasExposureType() => $_has(4);
  @$pb.TagNumber(5)
  void clearExposureType() => $_clearField(5);
}

class Button extends $pb.GeneratedMessage {
  factory Button({
    $core.String? text,
    ToastFunctionType? action,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (action != null) result.action = action;
    return result;
  }

  Button._();

  factory Button.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Button.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Button',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aE<ToastFunctionType>(2, _omitFieldNames ? '' : 'action',
        enumValues: ToastFunctionType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Button clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Button copyWith(void Function(Button) updates) =>
      super.copyWith((message) => updates(message as Button)) as Button;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Button create() => Button._();
  @$core.override
  Button createEmptyInstance() => create();
  static $pb.PbList<Button> createRepeated() => $pb.PbList<Button>();
  @$core.pragma('dart2js:noInline')
  static Button getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Button>(create);
  static Button? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  ToastFunctionType get action => $_getN(1);
  @$pb.TagNumber(2)
  set action(ToastFunctionType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => $_clearField(2);
}

class BuzzwordConfig extends $pb.GeneratedMessage {
  factory BuzzwordConfig({
    $core.Iterable<BuzzwordShowConfig>? keywords,
  }) {
    final result = create();
    if (keywords != null) result.keywords.addAll(keywords);
    return result;
  }

  BuzzwordConfig._();

  factory BuzzwordConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BuzzwordConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BuzzwordConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pPM<BuzzwordShowConfig>(1, _omitFieldNames ? '' : 'keywords',
        subBuilder: BuzzwordShowConfig.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BuzzwordConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BuzzwordConfig copyWith(void Function(BuzzwordConfig) updates) =>
      super.copyWith((message) => updates(message as BuzzwordConfig))
          as BuzzwordConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BuzzwordConfig create() => BuzzwordConfig._();
  @$core.override
  BuzzwordConfig createEmptyInstance() => create();
  static $pb.PbList<BuzzwordConfig> createRepeated() =>
      $pb.PbList<BuzzwordConfig>();
  @$core.pragma('dart2js:noInline')
  static BuzzwordConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BuzzwordConfig>(create);
  static BuzzwordConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BuzzwordShowConfig> get keywords => $_getList(0);
}

class BuzzwordShowConfig extends $pb.GeneratedMessage {
  factory BuzzwordShowConfig({
    $core.String? name,
    $core.String? schema,
    $core.int? source,
    $fixnum.Int64? id,
    $fixnum.Int64? buzzwordId,
    $core.int? schemaType,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (schema != null) result.schema = schema;
    if (source != null) result.source = source;
    if (id != null) result.id = id;
    if (buzzwordId != null) result.buzzwordId = buzzwordId;
    if (schemaType != null) result.schemaType = schemaType;
    return result;
  }

  BuzzwordShowConfig._();

  factory BuzzwordShowConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BuzzwordShowConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BuzzwordShowConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'schema')
    ..aI(3, _omitFieldNames ? '' : 'source')
    ..aInt64(4, _omitFieldNames ? '' : 'id')
    ..aInt64(5, _omitFieldNames ? '' : 'buzzwordId')
    ..aI(6, _omitFieldNames ? '' : 'schemaType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BuzzwordShowConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BuzzwordShowConfig copyWith(void Function(BuzzwordShowConfig) updates) =>
      super.copyWith((message) => updates(message as BuzzwordShowConfig))
          as BuzzwordShowConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BuzzwordShowConfig create() => BuzzwordShowConfig._();
  @$core.override
  BuzzwordShowConfig createEmptyInstance() => create();
  static $pb.PbList<BuzzwordShowConfig> createRepeated() =>
      $pb.PbList<BuzzwordShowConfig>();
  @$core.pragma('dart2js:noInline')
  static BuzzwordShowConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BuzzwordShowConfig>(create);
  static BuzzwordShowConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get schema => $_getSZ(1);
  @$pb.TagNumber(2)
  set schema($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSchema() => $_has(1);
  @$pb.TagNumber(2)
  void clearSchema() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get source => $_getIZ(2);
  @$pb.TagNumber(3)
  set source($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get id => $_getI64(3);
  @$pb.TagNumber(4)
  set id($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasId() => $_has(3);
  @$pb.TagNumber(4)
  void clearId() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get buzzwordId => $_getI64(4);
  @$pb.TagNumber(5)
  set buzzwordId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBuzzwordId() => $_has(4);
  @$pb.TagNumber(5)
  void clearBuzzwordId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get schemaType => $_getIZ(5);
  @$pb.TagNumber(6)
  set schemaType($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSchemaType() => $_has(5);
  @$pb.TagNumber(6)
  void clearSchemaType() => $_clearField(6);
}

class CheckBox extends $pb.GeneratedMessage {
  factory CheckBox({
    $core.String? text,
    CheckboxType? type,
    $core.bool? defaultValue,
    $core.bool? show,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (type != null) result.type = type;
    if (defaultValue != null) result.defaultValue = defaultValue;
    if (show != null) result.show = show;
    return result;
  }

  CheckBox._();

  factory CheckBox.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckBox.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckBox',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aE<CheckboxType>(2, _omitFieldNames ? '' : 'type',
        enumValues: CheckboxType.values)
    ..aOB(3, _omitFieldNames ? '' : 'defaultValue')
    ..aOB(4, _omitFieldNames ? '' : 'show')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckBox clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckBox copyWith(void Function(CheckBox) updates) =>
      super.copyWith((message) => updates(message as CheckBox)) as CheckBox;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckBox create() => CheckBox._();
  @$core.override
  CheckBox createEmptyInstance() => create();
  static $pb.PbList<CheckBox> createRepeated() => $pb.PbList<CheckBox>();
  @$core.pragma('dart2js:noInline')
  static CheckBox getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CheckBox>(create);
  static CheckBox? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  CheckboxType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(CheckboxType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get defaultValue => $_getBF(2);
  @$pb.TagNumber(3)
  set defaultValue($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDefaultValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearDefaultValue() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get show => $_getBF(3);
  @$pb.TagNumber(4)
  set show($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasShow() => $_has(3);
  @$pb.TagNumber(4)
  void clearShow() => $_clearField(4);
}

class CheckBoxV2 extends $pb.GeneratedMessage {
  factory CheckBoxV2({
    $core.String? text,
    CheckboxType? type,
    $core.bool? defaultValue,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (type != null) result.type = type;
    if (defaultValue != null) result.defaultValue = defaultValue;
    return result;
  }

  CheckBoxV2._();

  factory CheckBoxV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckBoxV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckBoxV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aE<CheckboxType>(2, _omitFieldNames ? '' : 'type',
        enumValues: CheckboxType.values)
    ..aOB(3, _omitFieldNames ? '' : 'defaultValue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckBoxV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckBoxV2 copyWith(void Function(CheckBoxV2) updates) =>
      super.copyWith((message) => updates(message as CheckBoxV2)) as CheckBoxV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckBoxV2 create() => CheckBoxV2._();
  @$core.override
  CheckBoxV2 createEmptyInstance() => create();
  static $pb.PbList<CheckBoxV2> createRepeated() => $pb.PbList<CheckBoxV2>();
  @$core.pragma('dart2js:noInline')
  static CheckBoxV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckBoxV2>(create);
  static CheckBoxV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  CheckboxType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(CheckboxType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get defaultValue => $_getBF(2);
  @$pb.TagNumber(3)
  set defaultValue($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDefaultValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearDefaultValue() => $_clearField(3);
}

class ClickButton extends $pb.GeneratedMessage {
  factory ClickButton({
    $core.Iterable<$core.String>? portraitText,
    $core.Iterable<$core.String>? landscapeText,
    $core.Iterable<$core.String>? portraitTextFocus,
    $core.Iterable<$core.String>? landscapeTextFocus,
    RenderType? renderType,
    $core.bool? show,
    Bubble? bubble,
  }) {
    final result = create();
    if (portraitText != null) result.portraitText.addAll(portraitText);
    if (landscapeText != null) result.landscapeText.addAll(landscapeText);
    if (portraitTextFocus != null)
      result.portraitTextFocus.addAll(portraitTextFocus);
    if (landscapeTextFocus != null)
      result.landscapeTextFocus.addAll(landscapeTextFocus);
    if (renderType != null) result.renderType = renderType;
    if (show != null) result.show = show;
    if (bubble != null) result.bubble = bubble;
    return result;
  }

  ClickButton._();

  factory ClickButton.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClickButton.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClickButton',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'portraitText')
    ..pPS(2, _omitFieldNames ? '' : 'landscapeText')
    ..pPS(3, _omitFieldNames ? '' : 'portraitTextFocus')
    ..pPS(4, _omitFieldNames ? '' : 'landscapeTextFocus')
    ..aE<RenderType>(5, _omitFieldNames ? '' : 'renderType',
        enumValues: RenderType.values)
    ..aOB(6, _omitFieldNames ? '' : 'show')
    ..aOM<Bubble>(7, _omitFieldNames ? '' : 'bubble', subBuilder: Bubble.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClickButton clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClickButton copyWith(void Function(ClickButton) updates) =>
      super.copyWith((message) => updates(message as ClickButton))
          as ClickButton;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClickButton create() => ClickButton._();
  @$core.override
  ClickButton createEmptyInstance() => create();
  static $pb.PbList<ClickButton> createRepeated() => $pb.PbList<ClickButton>();
  @$core.pragma('dart2js:noInline')
  static ClickButton getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClickButton>(create);
  static ClickButton? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get portraitText => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get landscapeText => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get portraitTextFocus => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get landscapeTextFocus => $_getList(3);

  @$pb.TagNumber(5)
  RenderType get renderType => $_getN(4);
  @$pb.TagNumber(5)
  set renderType(RenderType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRenderType() => $_has(4);
  @$pb.TagNumber(5)
  void clearRenderType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get show => $_getBF(5);
  @$pb.TagNumber(6)
  set show($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasShow() => $_has(5);
  @$pb.TagNumber(6)
  void clearShow() => $_clearField(6);

  @$pb.TagNumber(7)
  Bubble get bubble => $_getN(6);
  @$pb.TagNumber(7)
  set bubble(Bubble value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasBubble() => $_has(6);
  @$pb.TagNumber(7)
  void clearBubble() => $_clearField(7);
  @$pb.TagNumber(7)
  Bubble ensureBubble() => $_ensure(6);
}

class ClickButtonV2 extends $pb.GeneratedMessage {
  factory ClickButtonV2({
    $core.Iterable<$core.String>? portraitText,
    $core.Iterable<$core.String>? landscapeText,
    $core.Iterable<$core.String>? portraitTextFocus,
    $core.Iterable<$core.String>? landscapeTextFocus,
    RenderType? renderType,
    $core.bool? textInputPost,
    $core.bool? exposureOnce,
    ExposureType? exposureType,
  }) {
    final result = create();
    if (portraitText != null) result.portraitText.addAll(portraitText);
    if (landscapeText != null) result.landscapeText.addAll(landscapeText);
    if (portraitTextFocus != null)
      result.portraitTextFocus.addAll(portraitTextFocus);
    if (landscapeTextFocus != null)
      result.landscapeTextFocus.addAll(landscapeTextFocus);
    if (renderType != null) result.renderType = renderType;
    if (textInputPost != null) result.textInputPost = textInputPost;
    if (exposureOnce != null) result.exposureOnce = exposureOnce;
    if (exposureType != null) result.exposureType = exposureType;
    return result;
  }

  ClickButtonV2._();

  factory ClickButtonV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClickButtonV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClickButtonV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'portraitText')
    ..pPS(2, _omitFieldNames ? '' : 'landscapeText')
    ..pPS(3, _omitFieldNames ? '' : 'portraitTextFocus')
    ..pPS(4, _omitFieldNames ? '' : 'landscapeTextFocus')
    ..aE<RenderType>(5, _omitFieldNames ? '' : 'renderType',
        enumValues: RenderType.values)
    ..aOB(6, _omitFieldNames ? '' : 'textInputPost')
    ..aOB(7, _omitFieldNames ? '' : 'exposureOnce')
    ..aE<ExposureType>(8, _omitFieldNames ? '' : 'exposureType',
        enumValues: ExposureType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClickButtonV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClickButtonV2 copyWith(void Function(ClickButtonV2) updates) =>
      super.copyWith((message) => updates(message as ClickButtonV2))
          as ClickButtonV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClickButtonV2 create() => ClickButtonV2._();
  @$core.override
  ClickButtonV2 createEmptyInstance() => create();
  static $pb.PbList<ClickButtonV2> createRepeated() =>
      $pb.PbList<ClickButtonV2>();
  @$core.pragma('dart2js:noInline')
  static ClickButtonV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClickButtonV2>(create);
  static ClickButtonV2? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get portraitText => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get landscapeText => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get portraitTextFocus => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get landscapeTextFocus => $_getList(3);

  @$pb.TagNumber(5)
  RenderType get renderType => $_getN(4);
  @$pb.TagNumber(5)
  set renderType(RenderType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRenderType() => $_has(4);
  @$pb.TagNumber(5)
  void clearRenderType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get textInputPost => $_getBF(5);
  @$pb.TagNumber(6)
  set textInputPost($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTextInputPost() => $_has(5);
  @$pb.TagNumber(6)
  void clearTextInputPost() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get exposureOnce => $_getBF(6);
  @$pb.TagNumber(7)
  set exposureOnce($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasExposureOnce() => $_has(6);
  @$pb.TagNumber(7)
  void clearExposureOnce() => $_clearField(7);

  @$pb.TagNumber(8)
  ExposureType get exposureType => $_getN(7);
  @$pb.TagNumber(8)
  set exposureType(ExposureType value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasExposureType() => $_has(7);
  @$pb.TagNumber(8)
  void clearExposureType() => $_clearField(8);
}

class Command extends $pb.GeneratedMessage {
  factory Command({
    $core.Iterable<CommandDm>? commandDms,
  }) {
    final result = create();
    if (commandDms != null) result.commandDms.addAll(commandDms);
    return result;
  }

  Command._();

  factory Command.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Command.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Command',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pPM<CommandDm>(1, _omitFieldNames ? '' : 'commandDms',
        subBuilder: CommandDm.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Command clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Command copyWith(void Function(Command) updates) =>
      super.copyWith((message) => updates(message as Command)) as Command;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Command create() => Command._();
  @$core.override
  Command createEmptyInstance() => create();
  static $pb.PbList<Command> createRepeated() => $pb.PbList<Command>();
  @$core.pragma('dart2js:noInline')
  static Command getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Command>(create);
  static Command? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CommandDm> get commandDms => $_getList(0);
}

class CommandDm extends $pb.GeneratedMessage {
  factory CommandDm({
    $fixnum.Int64? id,
    $fixnum.Int64? oid,
    $fixnum.Int64? mid,
    $core.String? command,
    $core.String? content,
    $core.int? progress,
    $core.String? ctime,
    $core.String? mtime,
    $core.String? extra,
    $core.String? idstr,
    $core.int? type,
    $core.bool? autoCreate,
    $core.int? countDown,
    $core.int? attr,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (oid != null) result.oid = oid;
    if (mid != null) result.mid = mid;
    if (command != null) result.command = command;
    if (content != null) result.content = content;
    if (progress != null) result.progress = progress;
    if (ctime != null) result.ctime = ctime;
    if (mtime != null) result.mtime = mtime;
    if (extra != null) result.extra = extra;
    if (idstr != null) result.idstr = idstr;
    if (type != null) result.type = type;
    if (autoCreate != null) result.autoCreate = autoCreate;
    if (countDown != null) result.countDown = countDown;
    if (attr != null) result.attr = attr;
    return result;
  }

  CommandDm._();

  factory CommandDm.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommandDm.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommandDm',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aInt64(2, _omitFieldNames ? '' : 'oid')
    ..aInt64(3, _omitFieldNames ? '' : 'mid')
    ..aOS(4, _omitFieldNames ? '' : 'command')
    ..aOS(5, _omitFieldNames ? '' : 'content')
    ..aI(6, _omitFieldNames ? '' : 'progress')
    ..aOS(7, _omitFieldNames ? '' : 'ctime')
    ..aOS(8, _omitFieldNames ? '' : 'mtime')
    ..aOS(9, _omitFieldNames ? '' : 'extra')
    ..aOS(10, _omitFieldNames ? '' : 'idstr')
    ..aI(11, _omitFieldNames ? '' : 'type')
    ..aOB(12, _omitFieldNames ? '' : 'autoCreate')
    ..aI(13, _omitFieldNames ? '' : 'countDown')
    ..aI(14, _omitFieldNames ? '' : 'attr')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommandDm clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommandDm copyWith(void Function(CommandDm) updates) =>
      super.copyWith((message) => updates(message as CommandDm)) as CommandDm;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommandDm create() => CommandDm._();
  @$core.override
  CommandDm createEmptyInstance() => create();
  static $pb.PbList<CommandDm> createRepeated() => $pb.PbList<CommandDm>();
  @$core.pragma('dart2js:noInline')
  static CommandDm getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommandDm>(create);
  static CommandDm? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get oid => $_getI64(1);
  @$pb.TagNumber(2)
  set oid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get mid => $_getI64(2);
  @$pb.TagNumber(3)
  set mid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMid() => $_has(2);
  @$pb.TagNumber(3)
  void clearMid() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get command => $_getSZ(3);
  @$pb.TagNumber(4)
  set command($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCommand() => $_has(3);
  @$pb.TagNumber(4)
  void clearCommand() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get content => $_getSZ(4);
  @$pb.TagNumber(5)
  set content($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContent() => $_has(4);
  @$pb.TagNumber(5)
  void clearContent() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get progress => $_getIZ(5);
  @$pb.TagNumber(6)
  set progress($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasProgress() => $_has(5);
  @$pb.TagNumber(6)
  void clearProgress() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get ctime => $_getSZ(6);
  @$pb.TagNumber(7)
  set ctime($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCtime() => $_has(6);
  @$pb.TagNumber(7)
  void clearCtime() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get mtime => $_getSZ(7);
  @$pb.TagNumber(8)
  set mtime($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMtime() => $_has(7);
  @$pb.TagNumber(8)
  void clearMtime() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get extra => $_getSZ(8);
  @$pb.TagNumber(9)
  set extra($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasExtra() => $_has(8);
  @$pb.TagNumber(9)
  void clearExtra() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get idstr => $_getSZ(9);
  @$pb.TagNumber(10)
  set idstr($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIdstr() => $_has(9);
  @$pb.TagNumber(10)
  void clearIdstr() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get type => $_getIZ(10);
  @$pb.TagNumber(11)
  set type($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasType() => $_has(10);
  @$pb.TagNumber(11)
  void clearType() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get autoCreate => $_getBF(11);
  @$pb.TagNumber(12)
  set autoCreate($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAutoCreate() => $_has(11);
  @$pb.TagNumber(12)
  void clearAutoCreate() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get countDown => $_getIZ(12);
  @$pb.TagNumber(13)
  set countDown($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCountDown() => $_has(12);
  @$pb.TagNumber(13)
  void clearCountDown() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get attr => $_getIZ(13);
  @$pb.TagNumber(14)
  set attr($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasAttr() => $_has(13);
  @$pb.TagNumber(14)
  void clearAttr() => $_clearField(14);
}

class DanmakuAIFlag extends $pb.GeneratedMessage {
  factory DanmakuAIFlag({
    $core.Iterable<DanmakuFlag>? dmFlags,
  }) {
    final result = create();
    if (dmFlags != null) result.dmFlags.addAll(dmFlags);
    return result;
  }

  DanmakuAIFlag._();

  factory DanmakuAIFlag.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DanmakuAIFlag.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DanmakuAIFlag',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pPM<DanmakuFlag>(1, _omitFieldNames ? '' : 'dmFlags',
        subBuilder: DanmakuFlag.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmakuAIFlag clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmakuAIFlag copyWith(void Function(DanmakuAIFlag) updates) =>
      super.copyWith((message) => updates(message as DanmakuAIFlag))
          as DanmakuAIFlag;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DanmakuAIFlag create() => DanmakuAIFlag._();
  @$core.override
  DanmakuAIFlag createEmptyInstance() => create();
  static $pb.PbList<DanmakuAIFlag> createRepeated() =>
      $pb.PbList<DanmakuAIFlag>();
  @$core.pragma('dart2js:noInline')
  static DanmakuAIFlag getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmakuAIFlag>(create);
  static DanmakuAIFlag? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DanmakuFlag> get dmFlags => $_getList(0);
}

class DanmakuElem extends $pb.GeneratedMessage {
  factory DanmakuElem({
    $fixnum.Int64? id,
    $core.int? progress,
    $core.int? mode,
    $core.int? fontsize,
    $core.int? color,
    $core.String? midHash,
    $core.String? content,
    $fixnum.Int64? ctime,
    $core.int? weight,
    $core.String? action,
    $core.int? pool,
    $core.String? idStr,
    $core.int? attr,
    $fixnum.Int64? like,
    $core.String? animation,
    $core.String? extra,
    DmColorfulType? colorful,
    $core.int? type,
    $fixnum.Int64? oid,
    DmFromType? dmFrom,
    $core.int? count,
    $core.bool? isSelf,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (progress != null) result.progress = progress;
    if (mode != null) result.mode = mode;
    if (fontsize != null) result.fontsize = fontsize;
    if (color != null) result.color = color;
    if (midHash != null) result.midHash = midHash;
    if (content != null) result.content = content;
    if (ctime != null) result.ctime = ctime;
    if (weight != null) result.weight = weight;
    if (action != null) result.action = action;
    if (pool != null) result.pool = pool;
    if (idStr != null) result.idStr = idStr;
    if (attr != null) result.attr = attr;
    if (like != null) result.like = like;
    if (animation != null) result.animation = animation;
    if (extra != null) result.extra = extra;
    if (colorful != null) result.colorful = colorful;
    if (type != null) result.type = type;
    if (oid != null) result.oid = oid;
    if (dmFrom != null) result.dmFrom = dmFrom;
    if (count != null) result.count = count;
    if (isSelf != null) result.isSelf = isSelf;
    return result;
  }

  DanmakuElem._();

  factory DanmakuElem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DanmakuElem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DanmakuElem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aI(2, _omitFieldNames ? '' : 'progress')
    ..aI(3, _omitFieldNames ? '' : 'mode')
    ..aI(4, _omitFieldNames ? '' : 'fontsize')
    ..aI(5, _omitFieldNames ? '' : 'color', fieldType: $pb.PbFieldType.OU3)
    ..aOS(6, _omitFieldNames ? '' : 'midHash')
    ..aOS(7, _omitFieldNames ? '' : 'content')
    ..aInt64(8, _omitFieldNames ? '' : 'ctime')
    ..aI(9, _omitFieldNames ? '' : 'weight')
    ..aOS(10, _omitFieldNames ? '' : 'action')
    ..aI(11, _omitFieldNames ? '' : 'pool')
    ..aOS(12, _omitFieldNames ? '' : 'idStr')
    ..aI(13, _omitFieldNames ? '' : 'attr')
    ..aInt64(15, _omitFieldNames ? '' : 'like')
    ..aOS(22, _omitFieldNames ? '' : 'animation')
    ..aOS(23, _omitFieldNames ? '' : 'extra')
    ..aE<DmColorfulType>(24, _omitFieldNames ? '' : 'colorful',
        enumValues: DmColorfulType.values)
    ..aI(25, _omitFieldNames ? '' : 'type')
    ..aInt64(26, _omitFieldNames ? '' : 'oid')
    ..aE<DmFromType>(27, _omitFieldNames ? '' : 'dmFrom',
        enumValues: DmFromType.values)
    ..aI(28, _omitFieldNames ? '' : 'count')
    ..aOB(29, _omitFieldNames ? '' : 'isSelf')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmakuElem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmakuElem copyWith(void Function(DanmakuElem) updates) =>
      super.copyWith((message) => updates(message as DanmakuElem))
          as DanmakuElem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DanmakuElem create() => DanmakuElem._();
  @$core.override
  DanmakuElem createEmptyInstance() => create();
  static $pb.PbList<DanmakuElem> createRepeated() => $pb.PbList<DanmakuElem>();
  @$core.pragma('dart2js:noInline')
  static DanmakuElem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmakuElem>(create);
  static DanmakuElem? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get progress => $_getIZ(1);
  @$pb.TagNumber(2)
  set progress($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProgress() => $_has(1);
  @$pb.TagNumber(2)
  void clearProgress() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get mode => $_getIZ(2);
  @$pb.TagNumber(3)
  set mode($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get fontsize => $_getIZ(3);
  @$pb.TagNumber(4)
  set fontsize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFontsize() => $_has(3);
  @$pb.TagNumber(4)
  void clearFontsize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get color => $_getIZ(4);
  @$pb.TagNumber(5)
  set color($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasColor() => $_has(4);
  @$pb.TagNumber(5)
  void clearColor() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get midHash => $_getSZ(5);
  @$pb.TagNumber(6)
  set midHash($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMidHash() => $_has(5);
  @$pb.TagNumber(6)
  void clearMidHash() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get content => $_getSZ(6);
  @$pb.TagNumber(7)
  set content($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasContent() => $_has(6);
  @$pb.TagNumber(7)
  void clearContent() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get ctime => $_getI64(7);
  @$pb.TagNumber(8)
  set ctime($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCtime() => $_has(7);
  @$pb.TagNumber(8)
  void clearCtime() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get weight => $_getIZ(8);
  @$pb.TagNumber(9)
  set weight($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasWeight() => $_has(8);
  @$pb.TagNumber(9)
  void clearWeight() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get action => $_getSZ(9);
  @$pb.TagNumber(10)
  set action($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAction() => $_has(9);
  @$pb.TagNumber(10)
  void clearAction() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get pool => $_getIZ(10);
  @$pb.TagNumber(11)
  set pool($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasPool() => $_has(10);
  @$pb.TagNumber(11)
  void clearPool() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get idStr => $_getSZ(11);
  @$pb.TagNumber(12)
  set idStr($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasIdStr() => $_has(11);
  @$pb.TagNumber(12)
  void clearIdStr() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get attr => $_getIZ(12);
  @$pb.TagNumber(13)
  set attr($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasAttr() => $_has(12);
  @$pb.TagNumber(13)
  void clearAttr() => $_clearField(13);

  @$pb.TagNumber(15)
  $fixnum.Int64 get like => $_getI64(13);
  @$pb.TagNumber(15)
  set like($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(15)
  $core.bool hasLike() => $_has(13);
  @$pb.TagNumber(15)
  void clearLike() => $_clearField(15);

  @$pb.TagNumber(22)
  $core.String get animation => $_getSZ(14);
  @$pb.TagNumber(22)
  set animation($core.String value) => $_setString(14, value);
  @$pb.TagNumber(22)
  $core.bool hasAnimation() => $_has(14);
  @$pb.TagNumber(22)
  void clearAnimation() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.String get extra => $_getSZ(15);
  @$pb.TagNumber(23)
  set extra($core.String value) => $_setString(15, value);
  @$pb.TagNumber(23)
  $core.bool hasExtra() => $_has(15);
  @$pb.TagNumber(23)
  void clearExtra() => $_clearField(23);

  @$pb.TagNumber(24)
  DmColorfulType get colorful => $_getN(16);
  @$pb.TagNumber(24)
  set colorful(DmColorfulType value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasColorful() => $_has(16);
  @$pb.TagNumber(24)
  void clearColorful() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.int get type => $_getIZ(17);
  @$pb.TagNumber(25)
  set type($core.int value) => $_setSignedInt32(17, value);
  @$pb.TagNumber(25)
  $core.bool hasType() => $_has(17);
  @$pb.TagNumber(25)
  void clearType() => $_clearField(25);

  @$pb.TagNumber(26)
  $fixnum.Int64 get oid => $_getI64(18);
  @$pb.TagNumber(26)
  set oid($fixnum.Int64 value) => $_setInt64(18, value);
  @$pb.TagNumber(26)
  $core.bool hasOid() => $_has(18);
  @$pb.TagNumber(26)
  void clearOid() => $_clearField(26);

  @$pb.TagNumber(27)
  DmFromType get dmFrom => $_getN(19);
  @$pb.TagNumber(27)
  set dmFrom(DmFromType value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasDmFrom() => $_has(19);
  @$pb.TagNumber(27)
  void clearDmFrom() => $_clearField(27);

  @$pb.TagNumber(28)
  $core.int get count => $_getIZ(20);
  @$pb.TagNumber(28)
  set count($core.int value) => $_setSignedInt32(20, value);
  @$pb.TagNumber(28)
  $core.bool hasCount() => $_has(20);
  @$pb.TagNumber(28)
  void clearCount() => $_clearField(28);

  @$pb.TagNumber(29)
  $core.bool get isSelf => $_getBF(21);
  @$pb.TagNumber(29)
  set isSelf($core.bool value) => $_setBool(21, value);
  @$pb.TagNumber(29)
  $core.bool hasIsSelf() => $_has(21);
  @$pb.TagNumber(29)
  void clearIsSelf() => $_clearField(29);
}

class DanmakuFlag extends $pb.GeneratedMessage {
  factory DanmakuFlag({
    $fixnum.Int64? dmid,
    $core.int? flag,
  }) {
    final result = create();
    if (dmid != null) result.dmid = dmid;
    if (flag != null) result.flag = flag;
    return result;
  }

  DanmakuFlag._();

  factory DanmakuFlag.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DanmakuFlag.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DanmakuFlag',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'dmid')
    ..aI(2, _omitFieldNames ? '' : 'flag')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmakuFlag clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmakuFlag copyWith(void Function(DanmakuFlag) updates) =>
      super.copyWith((message) => updates(message as DanmakuFlag))
          as DanmakuFlag;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DanmakuFlag create() => DanmakuFlag._();
  @$core.override
  DanmakuFlag createEmptyInstance() => create();
  static $pb.PbList<DanmakuFlag> createRepeated() => $pb.PbList<DanmakuFlag>();
  @$core.pragma('dart2js:noInline')
  static DanmakuFlag getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmakuFlag>(create);
  static DanmakuFlag? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get dmid => $_getI64(0);
  @$pb.TagNumber(1)
  set dmid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDmid() => $_has(0);
  @$pb.TagNumber(1)
  void clearDmid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get flag => $_getIZ(1);
  @$pb.TagNumber(2)
  set flag($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFlag() => $_has(1);
  @$pb.TagNumber(2)
  void clearFlag() => $_clearField(2);
}

class DanmakuFlagConfig extends $pb.GeneratedMessage {
  factory DanmakuFlagConfig({
    $core.int? recFlag,
    $core.String? recText,
    $core.int? recSwitch,
  }) {
    final result = create();
    if (recFlag != null) result.recFlag = recFlag;
    if (recText != null) result.recText = recText;
    if (recSwitch != null) result.recSwitch = recSwitch;
    return result;
  }

  DanmakuFlagConfig._();

  factory DanmakuFlagConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DanmakuFlagConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DanmakuFlagConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'recFlag')
    ..aOS(2, _omitFieldNames ? '' : 'recText')
    ..aI(3, _omitFieldNames ? '' : 'recSwitch')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmakuFlagConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmakuFlagConfig copyWith(void Function(DanmakuFlagConfig) updates) =>
      super.copyWith((message) => updates(message as DanmakuFlagConfig))
          as DanmakuFlagConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DanmakuFlagConfig create() => DanmakuFlagConfig._();
  @$core.override
  DanmakuFlagConfig createEmptyInstance() => create();
  static $pb.PbList<DanmakuFlagConfig> createRepeated() =>
      $pb.PbList<DanmakuFlagConfig>();
  @$core.pragma('dart2js:noInline')
  static DanmakuFlagConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmakuFlagConfig>(create);
  static DanmakuFlagConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get recFlag => $_getIZ(0);
  @$pb.TagNumber(1)
  set recFlag($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecFlag() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecFlag() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recText => $_getSZ(1);
  @$pb.TagNumber(2)
  set recText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecText() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get recSwitch => $_getIZ(2);
  @$pb.TagNumber(3)
  set recSwitch($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecSwitch() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecSwitch() => $_clearField(3);
}

class DanmuDefaultPlayerConfig extends $pb.GeneratedMessage {
  factory DanmuDefaultPlayerConfig({
    $core.bool? playerDanmakuUseDefaultConfig,
    $core.bool? playerDanmakuAiRecommendedSwitch,
    $core.int? playerDanmakuAiRecommendedLevel,
    $core.bool? playerDanmakuBlocktop,
    $core.bool? playerDanmakuBlockscroll,
    $core.bool? playerDanmakuBlockbottom,
    $core.bool? playerDanmakuBlockcolorful,
    $core.bool? playerDanmakuBlockrepeat,
    $core.bool? playerDanmakuBlockspecial,
    $core.double? playerDanmakuOpacity,
    $core.double? playerDanmakuScalingfactor,
    $core.double? playerDanmakuDomain,
    $core.int? playerDanmakuSpeed,
    $core.bool? inlinePlayerDanmakuSwitch,
    $core.int? playerDanmakuSeniorModeSwitch,
    $core.int? playerDanmakuAiRecommendedLevelV2,
    $core.Iterable<$core.MapEntry<$core.int, $core.int>>?
        playerDanmakuAiRecommendedLevelV2Map,
    $core.bool? playerDanmakuEnableHerdDm,
  }) {
    final result = create();
    if (playerDanmakuUseDefaultConfig != null)
      result.playerDanmakuUseDefaultConfig = playerDanmakuUseDefaultConfig;
    if (playerDanmakuAiRecommendedSwitch != null)
      result.playerDanmakuAiRecommendedSwitch =
          playerDanmakuAiRecommendedSwitch;
    if (playerDanmakuAiRecommendedLevel != null)
      result.playerDanmakuAiRecommendedLevel = playerDanmakuAiRecommendedLevel;
    if (playerDanmakuBlocktop != null)
      result.playerDanmakuBlocktop = playerDanmakuBlocktop;
    if (playerDanmakuBlockscroll != null)
      result.playerDanmakuBlockscroll = playerDanmakuBlockscroll;
    if (playerDanmakuBlockbottom != null)
      result.playerDanmakuBlockbottom = playerDanmakuBlockbottom;
    if (playerDanmakuBlockcolorful != null)
      result.playerDanmakuBlockcolorful = playerDanmakuBlockcolorful;
    if (playerDanmakuBlockrepeat != null)
      result.playerDanmakuBlockrepeat = playerDanmakuBlockrepeat;
    if (playerDanmakuBlockspecial != null)
      result.playerDanmakuBlockspecial = playerDanmakuBlockspecial;
    if (playerDanmakuOpacity != null)
      result.playerDanmakuOpacity = playerDanmakuOpacity;
    if (playerDanmakuScalingfactor != null)
      result.playerDanmakuScalingfactor = playerDanmakuScalingfactor;
    if (playerDanmakuDomain != null)
      result.playerDanmakuDomain = playerDanmakuDomain;
    if (playerDanmakuSpeed != null)
      result.playerDanmakuSpeed = playerDanmakuSpeed;
    if (inlinePlayerDanmakuSwitch != null)
      result.inlinePlayerDanmakuSwitch = inlinePlayerDanmakuSwitch;
    if (playerDanmakuSeniorModeSwitch != null)
      result.playerDanmakuSeniorModeSwitch = playerDanmakuSeniorModeSwitch;
    if (playerDanmakuAiRecommendedLevelV2 != null)
      result.playerDanmakuAiRecommendedLevelV2 =
          playerDanmakuAiRecommendedLevelV2;
    if (playerDanmakuAiRecommendedLevelV2Map != null)
      result.playerDanmakuAiRecommendedLevelV2Map
          .addEntries(playerDanmakuAiRecommendedLevelV2Map);
    if (playerDanmakuEnableHerdDm != null)
      result.playerDanmakuEnableHerdDm = playerDanmakuEnableHerdDm;
    return result;
  }

  DanmuDefaultPlayerConfig._();

  factory DanmuDefaultPlayerConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DanmuDefaultPlayerConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DanmuDefaultPlayerConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'playerDanmakuUseDefaultConfig')
    ..aOB(4, _omitFieldNames ? '' : 'playerDanmakuAiRecommendedSwitch')
    ..aI(5, _omitFieldNames ? '' : 'playerDanmakuAiRecommendedLevel')
    ..aOB(6, _omitFieldNames ? '' : 'playerDanmakuBlocktop')
    ..aOB(7, _omitFieldNames ? '' : 'playerDanmakuBlockscroll')
    ..aOB(8, _omitFieldNames ? '' : 'playerDanmakuBlockbottom')
    ..aOB(9, _omitFieldNames ? '' : 'playerDanmakuBlockcolorful')
    ..aOB(10, _omitFieldNames ? '' : 'playerDanmakuBlockrepeat')
    ..aOB(11, _omitFieldNames ? '' : 'playerDanmakuBlockspecial')
    ..aD(12, _omitFieldNames ? '' : 'playerDanmakuOpacity',
        fieldType: $pb.PbFieldType.OF)
    ..aD(13, _omitFieldNames ? '' : 'playerDanmakuScalingfactor',
        fieldType: $pb.PbFieldType.OF)
    ..aD(14, _omitFieldNames ? '' : 'playerDanmakuDomain',
        fieldType: $pb.PbFieldType.OF)
    ..aI(15, _omitFieldNames ? '' : 'playerDanmakuSpeed')
    ..aOB(16, _omitFieldNames ? '' : 'inlinePlayerDanmakuSwitch')
    ..aI(17, _omitFieldNames ? '' : 'playerDanmakuSeniorModeSwitch')
    ..aI(18, _omitFieldNames ? '' : 'playerDanmakuAiRecommendedLevelV2')
    ..m<$core.int, $core.int>(
        19, _omitFieldNames ? '' : 'playerDanmakuAiRecommendedLevelV2Map',
        entryClassName:
            'DanmuDefaultPlayerConfig.PlayerDanmakuAiRecommendedLevelV2MapEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('bilibili.community.service.dm.v1'))
    ..aOB(20, _omitFieldNames ? '' : 'playerDanmakuEnableHerdDm')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmuDefaultPlayerConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmuDefaultPlayerConfig copyWith(
          void Function(DanmuDefaultPlayerConfig) updates) =>
      super.copyWith((message) => updates(message as DanmuDefaultPlayerConfig))
          as DanmuDefaultPlayerConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DanmuDefaultPlayerConfig create() => DanmuDefaultPlayerConfig._();
  @$core.override
  DanmuDefaultPlayerConfig createEmptyInstance() => create();
  static $pb.PbList<DanmuDefaultPlayerConfig> createRepeated() =>
      $pb.PbList<DanmuDefaultPlayerConfig>();
  @$core.pragma('dart2js:noInline')
  static DanmuDefaultPlayerConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmuDefaultPlayerConfig>(create);
  static DanmuDefaultPlayerConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get playerDanmakuUseDefaultConfig => $_getBF(0);
  @$pb.TagNumber(1)
  set playerDanmakuUseDefaultConfig($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlayerDanmakuUseDefaultConfig() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayerDanmakuUseDefaultConfig() => $_clearField(1);

  @$pb.TagNumber(4)
  $core.bool get playerDanmakuAiRecommendedSwitch => $_getBF(1);
  @$pb.TagNumber(4)
  set playerDanmakuAiRecommendedSwitch($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(4)
  $core.bool hasPlayerDanmakuAiRecommendedSwitch() => $_has(1);
  @$pb.TagNumber(4)
  void clearPlayerDanmakuAiRecommendedSwitch() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get playerDanmakuAiRecommendedLevel => $_getIZ(2);
  @$pb.TagNumber(5)
  set playerDanmakuAiRecommendedLevel($core.int value) =>
      $_setSignedInt32(2, value);
  @$pb.TagNumber(5)
  $core.bool hasPlayerDanmakuAiRecommendedLevel() => $_has(2);
  @$pb.TagNumber(5)
  void clearPlayerDanmakuAiRecommendedLevel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get playerDanmakuBlocktop => $_getBF(3);
  @$pb.TagNumber(6)
  set playerDanmakuBlocktop($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(6)
  $core.bool hasPlayerDanmakuBlocktop() => $_has(3);
  @$pb.TagNumber(6)
  void clearPlayerDanmakuBlocktop() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get playerDanmakuBlockscroll => $_getBF(4);
  @$pb.TagNumber(7)
  set playerDanmakuBlockscroll($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(7)
  $core.bool hasPlayerDanmakuBlockscroll() => $_has(4);
  @$pb.TagNumber(7)
  void clearPlayerDanmakuBlockscroll() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get playerDanmakuBlockbottom => $_getBF(5);
  @$pb.TagNumber(8)
  set playerDanmakuBlockbottom($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(8)
  $core.bool hasPlayerDanmakuBlockbottom() => $_has(5);
  @$pb.TagNumber(8)
  void clearPlayerDanmakuBlockbottom() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get playerDanmakuBlockcolorful => $_getBF(6);
  @$pb.TagNumber(9)
  set playerDanmakuBlockcolorful($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(9)
  $core.bool hasPlayerDanmakuBlockcolorful() => $_has(6);
  @$pb.TagNumber(9)
  void clearPlayerDanmakuBlockcolorful() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get playerDanmakuBlockrepeat => $_getBF(7);
  @$pb.TagNumber(10)
  set playerDanmakuBlockrepeat($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(10)
  $core.bool hasPlayerDanmakuBlockrepeat() => $_has(7);
  @$pb.TagNumber(10)
  void clearPlayerDanmakuBlockrepeat() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get playerDanmakuBlockspecial => $_getBF(8);
  @$pb.TagNumber(11)
  set playerDanmakuBlockspecial($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(11)
  $core.bool hasPlayerDanmakuBlockspecial() => $_has(8);
  @$pb.TagNumber(11)
  void clearPlayerDanmakuBlockspecial() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get playerDanmakuOpacity => $_getN(9);
  @$pb.TagNumber(12)
  set playerDanmakuOpacity($core.double value) => $_setFloat(9, value);
  @$pb.TagNumber(12)
  $core.bool hasPlayerDanmakuOpacity() => $_has(9);
  @$pb.TagNumber(12)
  void clearPlayerDanmakuOpacity() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get playerDanmakuScalingfactor => $_getN(10);
  @$pb.TagNumber(13)
  set playerDanmakuScalingfactor($core.double value) => $_setFloat(10, value);
  @$pb.TagNumber(13)
  $core.bool hasPlayerDanmakuScalingfactor() => $_has(10);
  @$pb.TagNumber(13)
  void clearPlayerDanmakuScalingfactor() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.double get playerDanmakuDomain => $_getN(11);
  @$pb.TagNumber(14)
  set playerDanmakuDomain($core.double value) => $_setFloat(11, value);
  @$pb.TagNumber(14)
  $core.bool hasPlayerDanmakuDomain() => $_has(11);
  @$pb.TagNumber(14)
  void clearPlayerDanmakuDomain() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get playerDanmakuSpeed => $_getIZ(12);
  @$pb.TagNumber(15)
  set playerDanmakuSpeed($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(15)
  $core.bool hasPlayerDanmakuSpeed() => $_has(12);
  @$pb.TagNumber(15)
  void clearPlayerDanmakuSpeed() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.bool get inlinePlayerDanmakuSwitch => $_getBF(13);
  @$pb.TagNumber(16)
  set inlinePlayerDanmakuSwitch($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(16)
  $core.bool hasInlinePlayerDanmakuSwitch() => $_has(13);
  @$pb.TagNumber(16)
  void clearInlinePlayerDanmakuSwitch() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.int get playerDanmakuSeniorModeSwitch => $_getIZ(14);
  @$pb.TagNumber(17)
  set playerDanmakuSeniorModeSwitch($core.int value) =>
      $_setSignedInt32(14, value);
  @$pb.TagNumber(17)
  $core.bool hasPlayerDanmakuSeniorModeSwitch() => $_has(14);
  @$pb.TagNumber(17)
  void clearPlayerDanmakuSeniorModeSwitch() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.int get playerDanmakuAiRecommendedLevelV2 => $_getIZ(15);
  @$pb.TagNumber(18)
  set playerDanmakuAiRecommendedLevelV2($core.int value) =>
      $_setSignedInt32(15, value);
  @$pb.TagNumber(18)
  $core.bool hasPlayerDanmakuAiRecommendedLevelV2() => $_has(15);
  @$pb.TagNumber(18)
  void clearPlayerDanmakuAiRecommendedLevelV2() => $_clearField(18);

  @$pb.TagNumber(19)
  $pb.PbMap<$core.int, $core.int> get playerDanmakuAiRecommendedLevelV2Map =>
      $_getMap(16);

  @$pb.TagNumber(20)
  $core.bool get playerDanmakuEnableHerdDm => $_getBF(17);
  @$pb.TagNumber(20)
  set playerDanmakuEnableHerdDm($core.bool value) => $_setBool(17, value);
  @$pb.TagNumber(20)
  $core.bool hasPlayerDanmakuEnableHerdDm() => $_has(17);
  @$pb.TagNumber(20)
  void clearPlayerDanmakuEnableHerdDm() => $_clearField(20);
}

class DanmuPlayerConfig extends $pb.GeneratedMessage {
  factory DanmuPlayerConfig({
    $core.bool? playerDanmakuSwitch,
    $core.bool? playerDanmakuSwitchSave,
    $core.bool? playerDanmakuUseDefaultConfig,
    $core.bool? playerDanmakuAiRecommendedSwitch,
    $core.int? playerDanmakuAiRecommendedLevel,
    $core.bool? playerDanmakuBlocktop,
    $core.bool? playerDanmakuBlockscroll,
    $core.bool? playerDanmakuBlockbottom,
    $core.bool? playerDanmakuBlockcolorful,
    $core.bool? playerDanmakuBlockrepeat,
    $core.bool? playerDanmakuBlockspecial,
    $core.double? playerDanmakuOpacity,
    $core.double? playerDanmakuScalingfactor,
    $core.double? playerDanmakuDomain,
    $core.int? playerDanmakuSpeed,
    $core.bool? playerDanmakuEnableblocklist,
    $core.bool? inlinePlayerDanmakuSwitch,
    $core.int? inlinePlayerDanmakuConfig,
    $core.int? playerDanmakuIosSwitchSave,
    $core.int? playerDanmakuSeniorModeSwitch,
    $core.int? playerDanmakuAiRecommendedLevelV2,
    $core.Iterable<$core.MapEntry<$core.int, $core.int>>?
        playerDanmakuAiRecommendedLevelV2Map,
    $core.bool? playerDanmakuEnableHerdDm,
    $core.bool? playerDanmakuBlocktopBottom,
    $core.int? playerDanmakuDomainV2,
    $core.int? playerDanmakuDensity,
    $core.bool? playerDanmakuSubtitleProof,
    $core.bool? playerDanmakuPeopleProof,
  }) {
    final result = create();
    if (playerDanmakuSwitch != null)
      result.playerDanmakuSwitch = playerDanmakuSwitch;
    if (playerDanmakuSwitchSave != null)
      result.playerDanmakuSwitchSave = playerDanmakuSwitchSave;
    if (playerDanmakuUseDefaultConfig != null)
      result.playerDanmakuUseDefaultConfig = playerDanmakuUseDefaultConfig;
    if (playerDanmakuAiRecommendedSwitch != null)
      result.playerDanmakuAiRecommendedSwitch =
          playerDanmakuAiRecommendedSwitch;
    if (playerDanmakuAiRecommendedLevel != null)
      result.playerDanmakuAiRecommendedLevel = playerDanmakuAiRecommendedLevel;
    if (playerDanmakuBlocktop != null)
      result.playerDanmakuBlocktop = playerDanmakuBlocktop;
    if (playerDanmakuBlockscroll != null)
      result.playerDanmakuBlockscroll = playerDanmakuBlockscroll;
    if (playerDanmakuBlockbottom != null)
      result.playerDanmakuBlockbottom = playerDanmakuBlockbottom;
    if (playerDanmakuBlockcolorful != null)
      result.playerDanmakuBlockcolorful = playerDanmakuBlockcolorful;
    if (playerDanmakuBlockrepeat != null)
      result.playerDanmakuBlockrepeat = playerDanmakuBlockrepeat;
    if (playerDanmakuBlockspecial != null)
      result.playerDanmakuBlockspecial = playerDanmakuBlockspecial;
    if (playerDanmakuOpacity != null)
      result.playerDanmakuOpacity = playerDanmakuOpacity;
    if (playerDanmakuScalingfactor != null)
      result.playerDanmakuScalingfactor = playerDanmakuScalingfactor;
    if (playerDanmakuDomain != null)
      result.playerDanmakuDomain = playerDanmakuDomain;
    if (playerDanmakuSpeed != null)
      result.playerDanmakuSpeed = playerDanmakuSpeed;
    if (playerDanmakuEnableblocklist != null)
      result.playerDanmakuEnableblocklist = playerDanmakuEnableblocklist;
    if (inlinePlayerDanmakuSwitch != null)
      result.inlinePlayerDanmakuSwitch = inlinePlayerDanmakuSwitch;
    if (inlinePlayerDanmakuConfig != null)
      result.inlinePlayerDanmakuConfig = inlinePlayerDanmakuConfig;
    if (playerDanmakuIosSwitchSave != null)
      result.playerDanmakuIosSwitchSave = playerDanmakuIosSwitchSave;
    if (playerDanmakuSeniorModeSwitch != null)
      result.playerDanmakuSeniorModeSwitch = playerDanmakuSeniorModeSwitch;
    if (playerDanmakuAiRecommendedLevelV2 != null)
      result.playerDanmakuAiRecommendedLevelV2 =
          playerDanmakuAiRecommendedLevelV2;
    if (playerDanmakuAiRecommendedLevelV2Map != null)
      result.playerDanmakuAiRecommendedLevelV2Map
          .addEntries(playerDanmakuAiRecommendedLevelV2Map);
    if (playerDanmakuEnableHerdDm != null)
      result.playerDanmakuEnableHerdDm = playerDanmakuEnableHerdDm;
    if (playerDanmakuBlocktopBottom != null)
      result.playerDanmakuBlocktopBottom = playerDanmakuBlocktopBottom;
    if (playerDanmakuDomainV2 != null)
      result.playerDanmakuDomainV2 = playerDanmakuDomainV2;
    if (playerDanmakuDensity != null)
      result.playerDanmakuDensity = playerDanmakuDensity;
    if (playerDanmakuSubtitleProof != null)
      result.playerDanmakuSubtitleProof = playerDanmakuSubtitleProof;
    if (playerDanmakuPeopleProof != null)
      result.playerDanmakuPeopleProof = playerDanmakuPeopleProof;
    return result;
  }

  DanmuPlayerConfig._();

  factory DanmuPlayerConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DanmuPlayerConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DanmuPlayerConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'playerDanmakuSwitch')
    ..aOB(2, _omitFieldNames ? '' : 'playerDanmakuSwitchSave')
    ..aOB(3, _omitFieldNames ? '' : 'playerDanmakuUseDefaultConfig')
    ..aOB(4, _omitFieldNames ? '' : 'playerDanmakuAiRecommendedSwitch')
    ..aI(5, _omitFieldNames ? '' : 'playerDanmakuAiRecommendedLevel')
    ..aOB(6, _omitFieldNames ? '' : 'playerDanmakuBlocktop')
    ..aOB(7, _omitFieldNames ? '' : 'playerDanmakuBlockscroll')
    ..aOB(8, _omitFieldNames ? '' : 'playerDanmakuBlockbottom')
    ..aOB(9, _omitFieldNames ? '' : 'playerDanmakuBlockcolorful')
    ..aOB(10, _omitFieldNames ? '' : 'playerDanmakuBlockrepeat')
    ..aOB(11, _omitFieldNames ? '' : 'playerDanmakuBlockspecial')
    ..aD(12, _omitFieldNames ? '' : 'playerDanmakuOpacity',
        fieldType: $pb.PbFieldType.OF)
    ..aD(13, _omitFieldNames ? '' : 'playerDanmakuScalingfactor',
        fieldType: $pb.PbFieldType.OF)
    ..aD(14, _omitFieldNames ? '' : 'playerDanmakuDomain',
        fieldType: $pb.PbFieldType.OF)
    ..aI(15, _omitFieldNames ? '' : 'playerDanmakuSpeed')
    ..aOB(16, _omitFieldNames ? '' : 'playerDanmakuEnableblocklist')
    ..aOB(17, _omitFieldNames ? '' : 'inlinePlayerDanmakuSwitch')
    ..aI(18, _omitFieldNames ? '' : 'inlinePlayerDanmakuConfig')
    ..aI(19, _omitFieldNames ? '' : 'playerDanmakuIosSwitchSave')
    ..aI(20, _omitFieldNames ? '' : 'playerDanmakuSeniorModeSwitch')
    ..aI(21, _omitFieldNames ? '' : 'playerDanmakuAiRecommendedLevelV2')
    ..m<$core.int, $core.int>(
        22, _omitFieldNames ? '' : 'playerDanmakuAiRecommendedLevelV2Map',
        entryClassName:
            'DanmuPlayerConfig.PlayerDanmakuAiRecommendedLevelV2MapEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('bilibili.community.service.dm.v1'))
    ..aOB(23, _omitFieldNames ? '' : 'playerDanmakuEnableHerdDm')
    ..aOB(24, _omitFieldNames ? '' : 'playerDanmakuBlocktopBottom')
    ..aI(25, _omitFieldNames ? '' : 'playerDanmakuDomainV2')
    ..aI(26, _omitFieldNames ? '' : 'playerDanmakuDensity')
    ..aOB(27, _omitFieldNames ? '' : 'playerDanmakuSubtitleProof')
    ..aOB(28, _omitFieldNames ? '' : 'playerDanmakuPeopleProof')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmuPlayerConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmuPlayerConfig copyWith(void Function(DanmuPlayerConfig) updates) =>
      super.copyWith((message) => updates(message as DanmuPlayerConfig))
          as DanmuPlayerConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DanmuPlayerConfig create() => DanmuPlayerConfig._();
  @$core.override
  DanmuPlayerConfig createEmptyInstance() => create();
  static $pb.PbList<DanmuPlayerConfig> createRepeated() =>
      $pb.PbList<DanmuPlayerConfig>();
  @$core.pragma('dart2js:noInline')
  static DanmuPlayerConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmuPlayerConfig>(create);
  static DanmuPlayerConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get playerDanmakuSwitch => $_getBF(0);
  @$pb.TagNumber(1)
  set playerDanmakuSwitch($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlayerDanmakuSwitch() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayerDanmakuSwitch() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get playerDanmakuSwitchSave => $_getBF(1);
  @$pb.TagNumber(2)
  set playerDanmakuSwitchSave($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlayerDanmakuSwitchSave() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayerDanmakuSwitchSave() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get playerDanmakuUseDefaultConfig => $_getBF(2);
  @$pb.TagNumber(3)
  set playerDanmakuUseDefaultConfig($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlayerDanmakuUseDefaultConfig() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlayerDanmakuUseDefaultConfig() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get playerDanmakuAiRecommendedSwitch => $_getBF(3);
  @$pb.TagNumber(4)
  set playerDanmakuAiRecommendedSwitch($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPlayerDanmakuAiRecommendedSwitch() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlayerDanmakuAiRecommendedSwitch() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get playerDanmakuAiRecommendedLevel => $_getIZ(4);
  @$pb.TagNumber(5)
  set playerDanmakuAiRecommendedLevel($core.int value) =>
      $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPlayerDanmakuAiRecommendedLevel() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlayerDanmakuAiRecommendedLevel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get playerDanmakuBlocktop => $_getBF(5);
  @$pb.TagNumber(6)
  set playerDanmakuBlocktop($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPlayerDanmakuBlocktop() => $_has(5);
  @$pb.TagNumber(6)
  void clearPlayerDanmakuBlocktop() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get playerDanmakuBlockscroll => $_getBF(6);
  @$pb.TagNumber(7)
  set playerDanmakuBlockscroll($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPlayerDanmakuBlockscroll() => $_has(6);
  @$pb.TagNumber(7)
  void clearPlayerDanmakuBlockscroll() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get playerDanmakuBlockbottom => $_getBF(7);
  @$pb.TagNumber(8)
  set playerDanmakuBlockbottom($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPlayerDanmakuBlockbottom() => $_has(7);
  @$pb.TagNumber(8)
  void clearPlayerDanmakuBlockbottom() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get playerDanmakuBlockcolorful => $_getBF(8);
  @$pb.TagNumber(9)
  set playerDanmakuBlockcolorful($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPlayerDanmakuBlockcolorful() => $_has(8);
  @$pb.TagNumber(9)
  void clearPlayerDanmakuBlockcolorful() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get playerDanmakuBlockrepeat => $_getBF(9);
  @$pb.TagNumber(10)
  set playerDanmakuBlockrepeat($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPlayerDanmakuBlockrepeat() => $_has(9);
  @$pb.TagNumber(10)
  void clearPlayerDanmakuBlockrepeat() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get playerDanmakuBlockspecial => $_getBF(10);
  @$pb.TagNumber(11)
  set playerDanmakuBlockspecial($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasPlayerDanmakuBlockspecial() => $_has(10);
  @$pb.TagNumber(11)
  void clearPlayerDanmakuBlockspecial() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get playerDanmakuOpacity => $_getN(11);
  @$pb.TagNumber(12)
  set playerDanmakuOpacity($core.double value) => $_setFloat(11, value);
  @$pb.TagNumber(12)
  $core.bool hasPlayerDanmakuOpacity() => $_has(11);
  @$pb.TagNumber(12)
  void clearPlayerDanmakuOpacity() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get playerDanmakuScalingfactor => $_getN(12);
  @$pb.TagNumber(13)
  set playerDanmakuScalingfactor($core.double value) => $_setFloat(12, value);
  @$pb.TagNumber(13)
  $core.bool hasPlayerDanmakuScalingfactor() => $_has(12);
  @$pb.TagNumber(13)
  void clearPlayerDanmakuScalingfactor() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.double get playerDanmakuDomain => $_getN(13);
  @$pb.TagNumber(14)
  set playerDanmakuDomain($core.double value) => $_setFloat(13, value);
  @$pb.TagNumber(14)
  $core.bool hasPlayerDanmakuDomain() => $_has(13);
  @$pb.TagNumber(14)
  void clearPlayerDanmakuDomain() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get playerDanmakuSpeed => $_getIZ(14);
  @$pb.TagNumber(15)
  set playerDanmakuSpeed($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasPlayerDanmakuSpeed() => $_has(14);
  @$pb.TagNumber(15)
  void clearPlayerDanmakuSpeed() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.bool get playerDanmakuEnableblocklist => $_getBF(15);
  @$pb.TagNumber(16)
  set playerDanmakuEnableblocklist($core.bool value) => $_setBool(15, value);
  @$pb.TagNumber(16)
  $core.bool hasPlayerDanmakuEnableblocklist() => $_has(15);
  @$pb.TagNumber(16)
  void clearPlayerDanmakuEnableblocklist() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.bool get inlinePlayerDanmakuSwitch => $_getBF(16);
  @$pb.TagNumber(17)
  set inlinePlayerDanmakuSwitch($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasInlinePlayerDanmakuSwitch() => $_has(16);
  @$pb.TagNumber(17)
  void clearInlinePlayerDanmakuSwitch() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.int get inlinePlayerDanmakuConfig => $_getIZ(17);
  @$pb.TagNumber(18)
  set inlinePlayerDanmakuConfig($core.int value) => $_setSignedInt32(17, value);
  @$pb.TagNumber(18)
  $core.bool hasInlinePlayerDanmakuConfig() => $_has(17);
  @$pb.TagNumber(18)
  void clearInlinePlayerDanmakuConfig() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.int get playerDanmakuIosSwitchSave => $_getIZ(18);
  @$pb.TagNumber(19)
  set playerDanmakuIosSwitchSave($core.int value) =>
      $_setSignedInt32(18, value);
  @$pb.TagNumber(19)
  $core.bool hasPlayerDanmakuIosSwitchSave() => $_has(18);
  @$pb.TagNumber(19)
  void clearPlayerDanmakuIosSwitchSave() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.int get playerDanmakuSeniorModeSwitch => $_getIZ(19);
  @$pb.TagNumber(20)
  set playerDanmakuSeniorModeSwitch($core.int value) =>
      $_setSignedInt32(19, value);
  @$pb.TagNumber(20)
  $core.bool hasPlayerDanmakuSeniorModeSwitch() => $_has(19);
  @$pb.TagNumber(20)
  void clearPlayerDanmakuSeniorModeSwitch() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.int get playerDanmakuAiRecommendedLevelV2 => $_getIZ(20);
  @$pb.TagNumber(21)
  set playerDanmakuAiRecommendedLevelV2($core.int value) =>
      $_setSignedInt32(20, value);
  @$pb.TagNumber(21)
  $core.bool hasPlayerDanmakuAiRecommendedLevelV2() => $_has(20);
  @$pb.TagNumber(21)
  void clearPlayerDanmakuAiRecommendedLevelV2() => $_clearField(21);

  @$pb.TagNumber(22)
  $pb.PbMap<$core.int, $core.int> get playerDanmakuAiRecommendedLevelV2Map =>
      $_getMap(21);

  @$pb.TagNumber(23)
  $core.bool get playerDanmakuEnableHerdDm => $_getBF(22);
  @$pb.TagNumber(23)
  set playerDanmakuEnableHerdDm($core.bool value) => $_setBool(22, value);
  @$pb.TagNumber(23)
  $core.bool hasPlayerDanmakuEnableHerdDm() => $_has(22);
  @$pb.TagNumber(23)
  void clearPlayerDanmakuEnableHerdDm() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.bool get playerDanmakuBlocktopBottom => $_getBF(23);
  @$pb.TagNumber(24)
  set playerDanmakuBlocktopBottom($core.bool value) => $_setBool(23, value);
  @$pb.TagNumber(24)
  $core.bool hasPlayerDanmakuBlocktopBottom() => $_has(23);
  @$pb.TagNumber(24)
  void clearPlayerDanmakuBlocktopBottom() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.int get playerDanmakuDomainV2 => $_getIZ(24);
  @$pb.TagNumber(25)
  set playerDanmakuDomainV2($core.int value) => $_setSignedInt32(24, value);
  @$pb.TagNumber(25)
  $core.bool hasPlayerDanmakuDomainV2() => $_has(24);
  @$pb.TagNumber(25)
  void clearPlayerDanmakuDomainV2() => $_clearField(25);

  @$pb.TagNumber(26)
  $core.int get playerDanmakuDensity => $_getIZ(25);
  @$pb.TagNumber(26)
  set playerDanmakuDensity($core.int value) => $_setSignedInt32(25, value);
  @$pb.TagNumber(26)
  $core.bool hasPlayerDanmakuDensity() => $_has(25);
  @$pb.TagNumber(26)
  void clearPlayerDanmakuDensity() => $_clearField(26);

  @$pb.TagNumber(27)
  $core.bool get playerDanmakuSubtitleProof => $_getBF(26);
  @$pb.TagNumber(27)
  set playerDanmakuSubtitleProof($core.bool value) => $_setBool(26, value);
  @$pb.TagNumber(27)
  $core.bool hasPlayerDanmakuSubtitleProof() => $_has(26);
  @$pb.TagNumber(27)
  void clearPlayerDanmakuSubtitleProof() => $_clearField(27);

  @$pb.TagNumber(28)
  $core.bool get playerDanmakuPeopleProof => $_getBF(27);
  @$pb.TagNumber(28)
  set playerDanmakuPeopleProof($core.bool value) => $_setBool(27, value);
  @$pb.TagNumber(28)
  $core.bool hasPlayerDanmakuPeopleProof() => $_has(27);
  @$pb.TagNumber(28)
  void clearPlayerDanmakuPeopleProof() => $_clearField(28);
}

class DanmuPlayerConfigPanel extends $pb.GeneratedMessage {
  factory DanmuPlayerConfigPanel({
    $core.String? selectionText,
  }) {
    final result = create();
    if (selectionText != null) result.selectionText = selectionText;
    return result;
  }

  DanmuPlayerConfigPanel._();

  factory DanmuPlayerConfigPanel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DanmuPlayerConfigPanel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DanmuPlayerConfigPanel',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'selectionText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmuPlayerConfigPanel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmuPlayerConfigPanel copyWith(
          void Function(DanmuPlayerConfigPanel) updates) =>
      super.copyWith((message) => updates(message as DanmuPlayerConfigPanel))
          as DanmuPlayerConfigPanel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DanmuPlayerConfigPanel create() => DanmuPlayerConfigPanel._();
  @$core.override
  DanmuPlayerConfigPanel createEmptyInstance() => create();
  static $pb.PbList<DanmuPlayerConfigPanel> createRepeated() =>
      $pb.PbList<DanmuPlayerConfigPanel>();
  @$core.pragma('dart2js:noInline')
  static DanmuPlayerConfigPanel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmuPlayerConfigPanel>(create);
  static DanmuPlayerConfigPanel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get selectionText => $_getSZ(0);
  @$pb.TagNumber(1)
  set selectionText($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSelectionText() => $_has(0);
  @$pb.TagNumber(1)
  void clearSelectionText() => $_clearField(1);
}

class DanmuPlayerDynamicConfig extends $pb.GeneratedMessage {
  factory DanmuPlayerDynamicConfig({
    $core.int? progress,
    $core.double? playerDanmakuDomain,
  }) {
    final result = create();
    if (progress != null) result.progress = progress;
    if (playerDanmakuDomain != null)
      result.playerDanmakuDomain = playerDanmakuDomain;
    return result;
  }

  DanmuPlayerDynamicConfig._();

  factory DanmuPlayerDynamicConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DanmuPlayerDynamicConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DanmuPlayerDynamicConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'progress')
    ..aD(14, _omitFieldNames ? '' : 'playerDanmakuDomain',
        fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmuPlayerDynamicConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmuPlayerDynamicConfig copyWith(
          void Function(DanmuPlayerDynamicConfig) updates) =>
      super.copyWith((message) => updates(message as DanmuPlayerDynamicConfig))
          as DanmuPlayerDynamicConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DanmuPlayerDynamicConfig create() => DanmuPlayerDynamicConfig._();
  @$core.override
  DanmuPlayerDynamicConfig createEmptyInstance() => create();
  static $pb.PbList<DanmuPlayerDynamicConfig> createRepeated() =>
      $pb.PbList<DanmuPlayerDynamicConfig>();
  @$core.pragma('dart2js:noInline')
  static DanmuPlayerDynamicConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmuPlayerDynamicConfig>(create);
  static DanmuPlayerDynamicConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get progress => $_getIZ(0);
  @$pb.TagNumber(1)
  set progress($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProgress() => $_has(0);
  @$pb.TagNumber(1)
  void clearProgress() => $_clearField(1);

  @$pb.TagNumber(14)
  $core.double get playerDanmakuDomain => $_getN(1);
  @$pb.TagNumber(14)
  set playerDanmakuDomain($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(14)
  $core.bool hasPlayerDanmakuDomain() => $_has(1);
  @$pb.TagNumber(14)
  void clearPlayerDanmakuDomain() => $_clearField(14);
}

class DanmuPlayerViewConfig extends $pb.GeneratedMessage {
  factory DanmuPlayerViewConfig({
    DanmuDefaultPlayerConfig? danmukuDefaultPlayerConfig,
    DanmuPlayerConfig? danmukuPlayerConfig,
    $core.Iterable<DanmuPlayerDynamicConfig>? danmukuPlayerDynamicConfig,
    DanmuPlayerConfigPanel? danmukuPlayerConfigPanel,
  }) {
    final result = create();
    if (danmukuDefaultPlayerConfig != null)
      result.danmukuDefaultPlayerConfig = danmukuDefaultPlayerConfig;
    if (danmukuPlayerConfig != null)
      result.danmukuPlayerConfig = danmukuPlayerConfig;
    if (danmukuPlayerDynamicConfig != null)
      result.danmukuPlayerDynamicConfig.addAll(danmukuPlayerDynamicConfig);
    if (danmukuPlayerConfigPanel != null)
      result.danmukuPlayerConfigPanel = danmukuPlayerConfigPanel;
    return result;
  }

  DanmuPlayerViewConfig._();

  factory DanmuPlayerViewConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DanmuPlayerViewConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DanmuPlayerViewConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOM<DanmuDefaultPlayerConfig>(
        1, _omitFieldNames ? '' : 'danmukuDefaultPlayerConfig',
        subBuilder: DanmuDefaultPlayerConfig.create)
    ..aOM<DanmuPlayerConfig>(2, _omitFieldNames ? '' : 'danmukuPlayerConfig',
        subBuilder: DanmuPlayerConfig.create)
    ..pPM<DanmuPlayerDynamicConfig>(
        3, _omitFieldNames ? '' : 'danmukuPlayerDynamicConfig',
        subBuilder: DanmuPlayerDynamicConfig.create)
    ..aOM<DanmuPlayerConfigPanel>(
        4, _omitFieldNames ? '' : 'danmukuPlayerConfigPanel',
        subBuilder: DanmuPlayerConfigPanel.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmuPlayerViewConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmuPlayerViewConfig copyWith(
          void Function(DanmuPlayerViewConfig) updates) =>
      super.copyWith((message) => updates(message as DanmuPlayerViewConfig))
          as DanmuPlayerViewConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DanmuPlayerViewConfig create() => DanmuPlayerViewConfig._();
  @$core.override
  DanmuPlayerViewConfig createEmptyInstance() => create();
  static $pb.PbList<DanmuPlayerViewConfig> createRepeated() =>
      $pb.PbList<DanmuPlayerViewConfig>();
  @$core.pragma('dart2js:noInline')
  static DanmuPlayerViewConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmuPlayerViewConfig>(create);
  static DanmuPlayerViewConfig? _defaultInstance;

  @$pb.TagNumber(1)
  DanmuDefaultPlayerConfig get danmukuDefaultPlayerConfig => $_getN(0);
  @$pb.TagNumber(1)
  set danmukuDefaultPlayerConfig(DanmuDefaultPlayerConfig value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDanmukuDefaultPlayerConfig() => $_has(0);
  @$pb.TagNumber(1)
  void clearDanmukuDefaultPlayerConfig() => $_clearField(1);
  @$pb.TagNumber(1)
  DanmuDefaultPlayerConfig ensureDanmukuDefaultPlayerConfig() => $_ensure(0);

  @$pb.TagNumber(2)
  DanmuPlayerConfig get danmukuPlayerConfig => $_getN(1);
  @$pb.TagNumber(2)
  set danmukuPlayerConfig(DanmuPlayerConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDanmukuPlayerConfig() => $_has(1);
  @$pb.TagNumber(2)
  void clearDanmukuPlayerConfig() => $_clearField(2);
  @$pb.TagNumber(2)
  DanmuPlayerConfig ensureDanmukuPlayerConfig() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<DanmuPlayerDynamicConfig> get danmukuPlayerDynamicConfig =>
      $_getList(2);

  @$pb.TagNumber(4)
  DanmuPlayerConfigPanel get danmukuPlayerConfigPanel => $_getN(3);
  @$pb.TagNumber(4)
  set danmukuPlayerConfigPanel(DanmuPlayerConfigPanel value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDanmukuPlayerConfigPanel() => $_has(3);
  @$pb.TagNumber(4)
  void clearDanmukuPlayerConfigPanel() => $_clearField(4);
  @$pb.TagNumber(4)
  DanmuPlayerConfigPanel ensureDanmukuPlayerConfigPanel() => $_ensure(3);
}

class DanmuWebPlayerConfig extends $pb.GeneratedMessage {
  factory DanmuWebPlayerConfig({
    $core.bool? dmSwitch,
    $core.bool? aiSwitch,
    $core.int? aiLevel,
    $core.bool? blocktop,
    $core.bool? blockscroll,
    $core.bool? blockbottom,
    $core.bool? blockcolor,
    $core.bool? blockspecial,
    $core.bool? preventshade,
    $core.bool? dmask,
    $core.double? opacity,
    $core.int? dmarea,
    $core.double? speedplus,
    $core.double? fontsize,
    $core.bool? screensync,
    $core.bool? speedsync,
    $core.String? fontfamily,
    $core.bool? bold,
    $core.int? fontborder,
    $core.String? drawType,
    $core.int? seniorModeSwitch,
    $core.int? aiLevelV2,
    $core.Iterable<$core.MapEntry<$core.int, $core.int>>? aiLevelV2Map,
    $core.bool? blocktopBottom,
    $core.int? dmAreaV2,
    $core.int? dmDensity,
  }) {
    final result = create();
    if (dmSwitch != null) result.dmSwitch = dmSwitch;
    if (aiSwitch != null) result.aiSwitch = aiSwitch;
    if (aiLevel != null) result.aiLevel = aiLevel;
    if (blocktop != null) result.blocktop = blocktop;
    if (blockscroll != null) result.blockscroll = blockscroll;
    if (blockbottom != null) result.blockbottom = blockbottom;
    if (blockcolor != null) result.blockcolor = blockcolor;
    if (blockspecial != null) result.blockspecial = blockspecial;
    if (preventshade != null) result.preventshade = preventshade;
    if (dmask != null) result.dmask = dmask;
    if (opacity != null) result.opacity = opacity;
    if (dmarea != null) result.dmarea = dmarea;
    if (speedplus != null) result.speedplus = speedplus;
    if (fontsize != null) result.fontsize = fontsize;
    if (screensync != null) result.screensync = screensync;
    if (speedsync != null) result.speedsync = speedsync;
    if (fontfamily != null) result.fontfamily = fontfamily;
    if (bold != null) result.bold = bold;
    if (fontborder != null) result.fontborder = fontborder;
    if (drawType != null) result.drawType = drawType;
    if (seniorModeSwitch != null) result.seniorModeSwitch = seniorModeSwitch;
    if (aiLevelV2 != null) result.aiLevelV2 = aiLevelV2;
    if (aiLevelV2Map != null) result.aiLevelV2Map.addEntries(aiLevelV2Map);
    if (blocktopBottom != null) result.blocktopBottom = blocktopBottom;
    if (dmAreaV2 != null) result.dmAreaV2 = dmAreaV2;
    if (dmDensity != null) result.dmDensity = dmDensity;
    return result;
  }

  DanmuWebPlayerConfig._();

  factory DanmuWebPlayerConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DanmuWebPlayerConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DanmuWebPlayerConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'dmSwitch')
    ..aOB(2, _omitFieldNames ? '' : 'aiSwitch')
    ..aI(3, _omitFieldNames ? '' : 'aiLevel')
    ..aOB(4, _omitFieldNames ? '' : 'blocktop')
    ..aOB(5, _omitFieldNames ? '' : 'blockscroll')
    ..aOB(6, _omitFieldNames ? '' : 'blockbottom')
    ..aOB(7, _omitFieldNames ? '' : 'blockcolor')
    ..aOB(8, _omitFieldNames ? '' : 'blockspecial')
    ..aOB(9, _omitFieldNames ? '' : 'preventshade')
    ..aOB(10, _omitFieldNames ? '' : 'dmask')
    ..aD(11, _omitFieldNames ? '' : 'opacity', fieldType: $pb.PbFieldType.OF)
    ..aI(12, _omitFieldNames ? '' : 'dmarea')
    ..aD(13, _omitFieldNames ? '' : 'speedplus', fieldType: $pb.PbFieldType.OF)
    ..aD(14, _omitFieldNames ? '' : 'fontsize', fieldType: $pb.PbFieldType.OF)
    ..aOB(15, _omitFieldNames ? '' : 'screensync')
    ..aOB(16, _omitFieldNames ? '' : 'speedsync')
    ..aOS(17, _omitFieldNames ? '' : 'fontfamily')
    ..aOB(18, _omitFieldNames ? '' : 'bold')
    ..aI(19, _omitFieldNames ? '' : 'fontborder')
    ..aOS(20, _omitFieldNames ? '' : 'drawType')
    ..aI(21, _omitFieldNames ? '' : 'seniorModeSwitch')
    ..aI(22, _omitFieldNames ? '' : 'aiLevelV2')
    ..m<$core.int, $core.int>(23, _omitFieldNames ? '' : 'aiLevelV2Map',
        entryClassName: 'DanmuWebPlayerConfig.AiLevelV2MapEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('bilibili.community.service.dm.v1'))
    ..aOB(24, _omitFieldNames ? '' : 'blocktopBottom')
    ..aI(25, _omitFieldNames ? '' : 'dmAreaV2')
    ..aI(26, _omitFieldNames ? '' : 'dmDensity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmuWebPlayerConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DanmuWebPlayerConfig copyWith(void Function(DanmuWebPlayerConfig) updates) =>
      super.copyWith((message) => updates(message as DanmuWebPlayerConfig))
          as DanmuWebPlayerConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DanmuWebPlayerConfig create() => DanmuWebPlayerConfig._();
  @$core.override
  DanmuWebPlayerConfig createEmptyInstance() => create();
  static $pb.PbList<DanmuWebPlayerConfig> createRepeated() =>
      $pb.PbList<DanmuWebPlayerConfig>();
  @$core.pragma('dart2js:noInline')
  static DanmuWebPlayerConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DanmuWebPlayerConfig>(create);
  static DanmuWebPlayerConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get dmSwitch => $_getBF(0);
  @$pb.TagNumber(1)
  set dmSwitch($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDmSwitch() => $_has(0);
  @$pb.TagNumber(1)
  void clearDmSwitch() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get aiSwitch => $_getBF(1);
  @$pb.TagNumber(2)
  set aiSwitch($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAiSwitch() => $_has(1);
  @$pb.TagNumber(2)
  void clearAiSwitch() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get aiLevel => $_getIZ(2);
  @$pb.TagNumber(3)
  set aiLevel($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAiLevel() => $_has(2);
  @$pb.TagNumber(3)
  void clearAiLevel() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get blocktop => $_getBF(3);
  @$pb.TagNumber(4)
  set blocktop($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBlocktop() => $_has(3);
  @$pb.TagNumber(4)
  void clearBlocktop() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get blockscroll => $_getBF(4);
  @$pb.TagNumber(5)
  set blockscroll($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBlockscroll() => $_has(4);
  @$pb.TagNumber(5)
  void clearBlockscroll() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get blockbottom => $_getBF(5);
  @$pb.TagNumber(6)
  set blockbottom($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBlockbottom() => $_has(5);
  @$pb.TagNumber(6)
  void clearBlockbottom() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get blockcolor => $_getBF(6);
  @$pb.TagNumber(7)
  set blockcolor($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBlockcolor() => $_has(6);
  @$pb.TagNumber(7)
  void clearBlockcolor() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get blockspecial => $_getBF(7);
  @$pb.TagNumber(8)
  set blockspecial($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBlockspecial() => $_has(7);
  @$pb.TagNumber(8)
  void clearBlockspecial() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get preventshade => $_getBF(8);
  @$pb.TagNumber(9)
  set preventshade($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPreventshade() => $_has(8);
  @$pb.TagNumber(9)
  void clearPreventshade() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get dmask => $_getBF(9);
  @$pb.TagNumber(10)
  set dmask($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDmask() => $_has(9);
  @$pb.TagNumber(10)
  void clearDmask() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get opacity => $_getN(10);
  @$pb.TagNumber(11)
  set opacity($core.double value) => $_setFloat(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOpacity() => $_has(10);
  @$pb.TagNumber(11)
  void clearOpacity() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get dmarea => $_getIZ(11);
  @$pb.TagNumber(12)
  set dmarea($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasDmarea() => $_has(11);
  @$pb.TagNumber(12)
  void clearDmarea() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get speedplus => $_getN(12);
  @$pb.TagNumber(13)
  set speedplus($core.double value) => $_setFloat(12, value);
  @$pb.TagNumber(13)
  $core.bool hasSpeedplus() => $_has(12);
  @$pb.TagNumber(13)
  void clearSpeedplus() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.double get fontsize => $_getN(13);
  @$pb.TagNumber(14)
  set fontsize($core.double value) => $_setFloat(13, value);
  @$pb.TagNumber(14)
  $core.bool hasFontsize() => $_has(13);
  @$pb.TagNumber(14)
  void clearFontsize() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.bool get screensync => $_getBF(14);
  @$pb.TagNumber(15)
  set screensync($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasScreensync() => $_has(14);
  @$pb.TagNumber(15)
  void clearScreensync() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.bool get speedsync => $_getBF(15);
  @$pb.TagNumber(16)
  set speedsync($core.bool value) => $_setBool(15, value);
  @$pb.TagNumber(16)
  $core.bool hasSpeedsync() => $_has(15);
  @$pb.TagNumber(16)
  void clearSpeedsync() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get fontfamily => $_getSZ(16);
  @$pb.TagNumber(17)
  set fontfamily($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasFontfamily() => $_has(16);
  @$pb.TagNumber(17)
  void clearFontfamily() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.bool get bold => $_getBF(17);
  @$pb.TagNumber(18)
  set bold($core.bool value) => $_setBool(17, value);
  @$pb.TagNumber(18)
  $core.bool hasBold() => $_has(17);
  @$pb.TagNumber(18)
  void clearBold() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.int get fontborder => $_getIZ(18);
  @$pb.TagNumber(19)
  set fontborder($core.int value) => $_setSignedInt32(18, value);
  @$pb.TagNumber(19)
  $core.bool hasFontborder() => $_has(18);
  @$pb.TagNumber(19)
  void clearFontborder() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.String get drawType => $_getSZ(19);
  @$pb.TagNumber(20)
  set drawType($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasDrawType() => $_has(19);
  @$pb.TagNumber(20)
  void clearDrawType() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.int get seniorModeSwitch => $_getIZ(20);
  @$pb.TagNumber(21)
  set seniorModeSwitch($core.int value) => $_setSignedInt32(20, value);
  @$pb.TagNumber(21)
  $core.bool hasSeniorModeSwitch() => $_has(20);
  @$pb.TagNumber(21)
  void clearSeniorModeSwitch() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.int get aiLevelV2 => $_getIZ(21);
  @$pb.TagNumber(22)
  set aiLevelV2($core.int value) => $_setSignedInt32(21, value);
  @$pb.TagNumber(22)
  $core.bool hasAiLevelV2() => $_has(21);
  @$pb.TagNumber(22)
  void clearAiLevelV2() => $_clearField(22);

  @$pb.TagNumber(23)
  $pb.PbMap<$core.int, $core.int> get aiLevelV2Map => $_getMap(22);

  @$pb.TagNumber(24)
  $core.bool get blocktopBottom => $_getBF(23);
  @$pb.TagNumber(24)
  set blocktopBottom($core.bool value) => $_setBool(23, value);
  @$pb.TagNumber(24)
  $core.bool hasBlocktopBottom() => $_has(23);
  @$pb.TagNumber(24)
  void clearBlocktopBottom() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.int get dmAreaV2 => $_getIZ(24);
  @$pb.TagNumber(25)
  set dmAreaV2($core.int value) => $_setSignedInt32(24, value);
  @$pb.TagNumber(25)
  $core.bool hasDmAreaV2() => $_has(24);
  @$pb.TagNumber(25)
  void clearDmAreaV2() => $_clearField(25);

  @$pb.TagNumber(26)
  $core.int get dmDensity => $_getIZ(25);
  @$pb.TagNumber(26)
  set dmDensity($core.int value) => $_setSignedInt32(25, value);
  @$pb.TagNumber(26)
  $core.bool hasDmDensity() => $_has(25);
  @$pb.TagNumber(26)
  void clearDmDensity() => $_clearField(26);
}

class DmColorful extends $pb.GeneratedMessage {
  factory DmColorful({
    DmColorfulType? type,
    $core.String? src,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (src != null) result.src = src;
    return result;
  }

  DmColorful._();

  factory DmColorful.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DmColorful.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmColorful',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aE<DmColorfulType>(1, _omitFieldNames ? '' : 'type',
        enumValues: DmColorfulType.values)
    ..aOS(2, _omitFieldNames ? '' : 'src')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmColorful clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmColorful copyWith(void Function(DmColorful) updates) =>
      super.copyWith((message) => updates(message as DmColorful)) as DmColorful;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DmColorful create() => DmColorful._();
  @$core.override
  DmColorful createEmptyInstance() => create();
  static $pb.PbList<DmColorful> createRepeated() => $pb.PbList<DmColorful>();
  @$core.pragma('dart2js:noInline')
  static DmColorful getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmColorful>(create);
  static DmColorful? _defaultInstance;

  @$pb.TagNumber(1)
  DmColorfulType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(DmColorfulType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get src => $_getSZ(1);
  @$pb.TagNumber(2)
  set src($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSrc() => $_has(1);
  @$pb.TagNumber(2)
  void clearSrc() => $_clearField(2);
}

class DmExpoReportReq extends $pb.GeneratedMessage {
  factory DmExpoReportReq({
    $core.String? sessionId,
    $fixnum.Int64? oid,
    $core.List<$core.int>? dmids,
    $core.String? spmid,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (oid != null) result.oid = oid;
    if (dmids != null) result.dmids = dmids;
    if (spmid != null) result.spmid = spmid;
    return result;
  }

  DmExpoReportReq._();

  factory DmExpoReportReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DmExpoReportReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmExpoReportReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aInt64(2, _omitFieldNames ? '' : 'oid')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'dmids', $pb.PbFieldType.OY)
    ..aOS(4, _omitFieldNames ? '' : 'spmid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmExpoReportReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmExpoReportReq copyWith(void Function(DmExpoReportReq) updates) =>
      super.copyWith((message) => updates(message as DmExpoReportReq))
          as DmExpoReportReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DmExpoReportReq create() => DmExpoReportReq._();
  @$core.override
  DmExpoReportReq createEmptyInstance() => create();
  static $pb.PbList<DmExpoReportReq> createRepeated() =>
      $pb.PbList<DmExpoReportReq>();
  @$core.pragma('dart2js:noInline')
  static DmExpoReportReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmExpoReportReq>(create);
  static DmExpoReportReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get oid => $_getI64(1);
  @$pb.TagNumber(2)
  set oid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get dmids => $_getN(2);
  @$pb.TagNumber(3)
  set dmids($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDmids() => $_has(2);
  @$pb.TagNumber(3)
  void clearDmids() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get spmid => $_getSZ(3);
  @$pb.TagNumber(4)
  set spmid($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSpmid() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpmid() => $_clearField(4);
}

class DmExpoReportRes extends $pb.GeneratedMessage {
  factory DmExpoReportRes() => create();

  DmExpoReportRes._();

  factory DmExpoReportRes.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DmExpoReportRes.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmExpoReportRes',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmExpoReportRes clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmExpoReportRes copyWith(void Function(DmExpoReportRes) updates) =>
      super.copyWith((message) => updates(message as DmExpoReportRes))
          as DmExpoReportRes;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DmExpoReportRes create() => DmExpoReportRes._();
  @$core.override
  DmExpoReportRes createEmptyInstance() => create();
  static $pb.PbList<DmExpoReportRes> createRepeated() =>
      $pb.PbList<DmExpoReportRes>();
  @$core.pragma('dart2js:noInline')
  static DmExpoReportRes getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmExpoReportRes>(create);
  static DmExpoReportRes? _defaultInstance;
}

class DmHerdView extends $pb.GeneratedMessage {
  factory DmHerdView({
    $core.int? displayHerdDmNum,
    $core.Iterable<ViewHerdDmElem>? herdDms,
  }) {
    final result = create();
    if (displayHerdDmNum != null) result.displayHerdDmNum = displayHerdDmNum;
    if (herdDms != null) result.herdDms.addAll(herdDms);
    return result;
  }

  DmHerdView._();

  factory DmHerdView.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DmHerdView.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmHerdView',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'displayHerdDmNum')
    ..pPM<ViewHerdDmElem>(2, _omitFieldNames ? '' : 'herdDms',
        subBuilder: ViewHerdDmElem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmHerdView clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmHerdView copyWith(void Function(DmHerdView) updates) =>
      super.copyWith((message) => updates(message as DmHerdView)) as DmHerdView;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DmHerdView create() => DmHerdView._();
  @$core.override
  DmHerdView createEmptyInstance() => create();
  static $pb.PbList<DmHerdView> createRepeated() => $pb.PbList<DmHerdView>();
  @$core.pragma('dart2js:noInline')
  static DmHerdView getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmHerdView>(create);
  static DmHerdView? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get displayHerdDmNum => $_getIZ(0);
  @$pb.TagNumber(1)
  set displayHerdDmNum($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDisplayHerdDmNum() => $_has(0);
  @$pb.TagNumber(1)
  void clearDisplayHerdDmNum() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ViewHerdDmElem> get herdDms => $_getList(1);
}

class DmMaskWall extends $pb.GeneratedMessage {
  factory DmMaskWall({
    $fixnum.Int64? start,
    $fixnum.Int64? end,
    $core.String? content,
    DmMaskWallContentType? contentType,
    DmMaskWallBizType? bizType,
    $core.Iterable<DmMaskWallContent>? contents,
  }) {
    final result = create();
    if (start != null) result.start = start;
    if (end != null) result.end = end;
    if (content != null) result.content = content;
    if (contentType != null) result.contentType = contentType;
    if (bizType != null) result.bizType = bizType;
    if (contents != null) result.contents.addAll(contents);
    return result;
  }

  DmMaskWall._();

  factory DmMaskWall.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DmMaskWall.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmMaskWall',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'start')
    ..aInt64(2, _omitFieldNames ? '' : 'end')
    ..aOS(3, _omitFieldNames ? '' : 'content')
    ..aE<DmMaskWallContentType>(4, _omitFieldNames ? '' : 'contentType',
        enumValues: DmMaskWallContentType.values)
    ..aE<DmMaskWallBizType>(5, _omitFieldNames ? '' : 'bizType',
        enumValues: DmMaskWallBizType.values)
    ..pPM<DmMaskWallContent>(6, _omitFieldNames ? '' : 'contents',
        subBuilder: DmMaskWallContent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmMaskWall clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmMaskWall copyWith(void Function(DmMaskWall) updates) =>
      super.copyWith((message) => updates(message as DmMaskWall)) as DmMaskWall;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DmMaskWall create() => DmMaskWall._();
  @$core.override
  DmMaskWall createEmptyInstance() => create();
  static $pb.PbList<DmMaskWall> createRepeated() => $pb.PbList<DmMaskWall>();
  @$core.pragma('dart2js:noInline')
  static DmMaskWall getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmMaskWall>(create);
  static DmMaskWall? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get start => $_getI64(0);
  @$pb.TagNumber(1)
  set start($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get end => $_getI64(1);
  @$pb.TagNumber(2)
  set end($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnd() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get content => $_getSZ(2);
  @$pb.TagNumber(3)
  set content($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => $_clearField(3);

  @$pb.TagNumber(4)
  DmMaskWallContentType get contentType => $_getN(3);
  @$pb.TagNumber(4)
  set contentType(DmMaskWallContentType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasContentType() => $_has(3);
  @$pb.TagNumber(4)
  void clearContentType() => $_clearField(4);

  @$pb.TagNumber(5)
  DmMaskWallBizType get bizType => $_getN(4);
  @$pb.TagNumber(5)
  set bizType(DmMaskWallBizType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasBizType() => $_has(4);
  @$pb.TagNumber(5)
  void clearBizType() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<DmMaskWallContent> get contents => $_getList(5);
}

class DmMaskWallContent extends $pb.GeneratedMessage {
  factory DmMaskWallContent({
    DmMaskWallContentType? type,
    $core.String? content,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (content != null) result.content = content;
    return result;
  }

  DmMaskWallContent._();

  factory DmMaskWallContent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DmMaskWallContent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmMaskWallContent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aE<DmMaskWallContentType>(1, _omitFieldNames ? '' : 'type',
        enumValues: DmMaskWallContentType.values)
    ..aOS(2, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmMaskWallContent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmMaskWallContent copyWith(void Function(DmMaskWallContent) updates) =>
      super.copyWith((message) => updates(message as DmMaskWallContent))
          as DmMaskWallContent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DmMaskWallContent create() => DmMaskWallContent._();
  @$core.override
  DmMaskWallContent createEmptyInstance() => create();
  static $pb.PbList<DmMaskWallContent> createRepeated() =>
      $pb.PbList<DmMaskWallContent>();
  @$core.pragma('dart2js:noInline')
  static DmMaskWallContent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmMaskWallContent>(create);
  static DmMaskWallContent? _defaultInstance;

  @$pb.TagNumber(1)
  DmMaskWallContentType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(DmMaskWallContentType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get content => $_getSZ(1);
  @$pb.TagNumber(2)
  set content($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => $_clearField(2);
}

class DmPlayerConfigReq extends $pb.GeneratedMessage {
  factory DmPlayerConfigReq({
    $fixnum.Int64? ts,
    PlayerDanmakuSwitch? switch_2,
    PlayerDanmakuSwitchSave? switchSave,
    PlayerDanmakuUseDefaultConfig? useDefaultConfig,
    PlayerDanmakuAiRecommendedSwitch? aiRecommendedSwitch,
    PlayerDanmakuAiRecommendedLevel? aiRecommendedLevel,
    PlayerDanmakuBlocktop? blocktop,
    PlayerDanmakuBlockscroll? blockscroll,
    PlayerDanmakuBlockbottom? blockbottom,
    PlayerDanmakuBlockcolorful? blockcolorful,
    PlayerDanmakuBlockrepeat? blockrepeat,
    PlayerDanmakuBlockspecial? blockspecial,
    PlayerDanmakuOpacity? opacity,
    PlayerDanmakuScalingfactor? scalingfactor,
    PlayerDanmakuDomain? domain,
    PlayerDanmakuSpeed? speed,
    PlayerDanmakuEnableblocklist? enableblocklist,
    InlinePlayerDanmakuSwitch? inlinePlayerDanmakuSwitch,
    PlayerDanmakuSeniorModeSwitch? seniorModeSwitch,
    PlayerDanmakuAiRecommendedLevelV2? aiRecommendedLevelV2,
    PlayerDanmakuEnableHerdDm? enableHerdDm,
    PlayerDanmakuBlocktopBottom? blocktopBottom,
    PlayerDanmakuDomainV2? domainV2,
    PlayerDanmakuDensity? density,
    PlayerDanmakuSubtitleProof? subtitleProof,
    PlayerDanmakuPeopleProof? peopleProof,
  }) {
    final result = create();
    if (ts != null) result.ts = ts;
    if (switch_2 != null) result.switch_2 = switch_2;
    if (switchSave != null) result.switchSave = switchSave;
    if (useDefaultConfig != null) result.useDefaultConfig = useDefaultConfig;
    if (aiRecommendedSwitch != null)
      result.aiRecommendedSwitch = aiRecommendedSwitch;
    if (aiRecommendedLevel != null)
      result.aiRecommendedLevel = aiRecommendedLevel;
    if (blocktop != null) result.blocktop = blocktop;
    if (blockscroll != null) result.blockscroll = blockscroll;
    if (blockbottom != null) result.blockbottom = blockbottom;
    if (blockcolorful != null) result.blockcolorful = blockcolorful;
    if (blockrepeat != null) result.blockrepeat = blockrepeat;
    if (blockspecial != null) result.blockspecial = blockspecial;
    if (opacity != null) result.opacity = opacity;
    if (scalingfactor != null) result.scalingfactor = scalingfactor;
    if (domain != null) result.domain = domain;
    if (speed != null) result.speed = speed;
    if (enableblocklist != null) result.enableblocklist = enableblocklist;
    if (inlinePlayerDanmakuSwitch != null)
      result.inlinePlayerDanmakuSwitch = inlinePlayerDanmakuSwitch;
    if (seniorModeSwitch != null) result.seniorModeSwitch = seniorModeSwitch;
    if (aiRecommendedLevelV2 != null)
      result.aiRecommendedLevelV2 = aiRecommendedLevelV2;
    if (enableHerdDm != null) result.enableHerdDm = enableHerdDm;
    if (blocktopBottom != null) result.blocktopBottom = blocktopBottom;
    if (domainV2 != null) result.domainV2 = domainV2;
    if (density != null) result.density = density;
    if (subtitleProof != null) result.subtitleProof = subtitleProof;
    if (peopleProof != null) result.peopleProof = peopleProof;
    return result;
  }

  DmPlayerConfigReq._();

  factory DmPlayerConfigReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DmPlayerConfigReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmPlayerConfigReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'ts')
    ..aOM<PlayerDanmakuSwitch>(2, _omitFieldNames ? '' : 'switch',
        subBuilder: PlayerDanmakuSwitch.create)
    ..aOM<PlayerDanmakuSwitchSave>(3, _omitFieldNames ? '' : 'switchSave',
        subBuilder: PlayerDanmakuSwitchSave.create)
    ..aOM<PlayerDanmakuUseDefaultConfig>(
        4, _omitFieldNames ? '' : 'useDefaultConfig',
        subBuilder: PlayerDanmakuUseDefaultConfig.create)
    ..aOM<PlayerDanmakuAiRecommendedSwitch>(
        5, _omitFieldNames ? '' : 'aiRecommendedSwitch',
        subBuilder: PlayerDanmakuAiRecommendedSwitch.create)
    ..aOM<PlayerDanmakuAiRecommendedLevel>(
        6, _omitFieldNames ? '' : 'aiRecommendedLevel',
        subBuilder: PlayerDanmakuAiRecommendedLevel.create)
    ..aOM<PlayerDanmakuBlocktop>(7, _omitFieldNames ? '' : 'blocktop',
        subBuilder: PlayerDanmakuBlocktop.create)
    ..aOM<PlayerDanmakuBlockscroll>(8, _omitFieldNames ? '' : 'blockscroll',
        subBuilder: PlayerDanmakuBlockscroll.create)
    ..aOM<PlayerDanmakuBlockbottom>(9, _omitFieldNames ? '' : 'blockbottom',
        subBuilder: PlayerDanmakuBlockbottom.create)
    ..aOM<PlayerDanmakuBlockcolorful>(
        10, _omitFieldNames ? '' : 'blockcolorful',
        subBuilder: PlayerDanmakuBlockcolorful.create)
    ..aOM<PlayerDanmakuBlockrepeat>(11, _omitFieldNames ? '' : 'blockrepeat',
        subBuilder: PlayerDanmakuBlockrepeat.create)
    ..aOM<PlayerDanmakuBlockspecial>(12, _omitFieldNames ? '' : 'blockspecial',
        subBuilder: PlayerDanmakuBlockspecial.create)
    ..aOM<PlayerDanmakuOpacity>(13, _omitFieldNames ? '' : 'opacity',
        subBuilder: PlayerDanmakuOpacity.create)
    ..aOM<PlayerDanmakuScalingfactor>(
        14, _omitFieldNames ? '' : 'scalingfactor',
        subBuilder: PlayerDanmakuScalingfactor.create)
    ..aOM<PlayerDanmakuDomain>(15, _omitFieldNames ? '' : 'domain',
        subBuilder: PlayerDanmakuDomain.create)
    ..aOM<PlayerDanmakuSpeed>(16, _omitFieldNames ? '' : 'speed',
        subBuilder: PlayerDanmakuSpeed.create)
    ..aOM<PlayerDanmakuEnableblocklist>(
        17, _omitFieldNames ? '' : 'enableblocklist',
        subBuilder: PlayerDanmakuEnableblocklist.create)
    ..aOM<InlinePlayerDanmakuSwitch>(
        18, _omitFieldNames ? '' : 'inlinePlayerDanmakuSwitch',
        subBuilder: InlinePlayerDanmakuSwitch.create)
    ..aOM<PlayerDanmakuSeniorModeSwitch>(
        19, _omitFieldNames ? '' : 'seniorModeSwitch',
        subBuilder: PlayerDanmakuSeniorModeSwitch.create)
    ..aOM<PlayerDanmakuAiRecommendedLevelV2>(
        20, _omitFieldNames ? '' : 'aiRecommendedLevelV2',
        subBuilder: PlayerDanmakuAiRecommendedLevelV2.create)
    ..aOM<PlayerDanmakuEnableHerdDm>(21, _omitFieldNames ? '' : 'enableHerdDm',
        subBuilder: PlayerDanmakuEnableHerdDm.create)
    ..aOM<PlayerDanmakuBlocktopBottom>(
        22, _omitFieldNames ? '' : 'blocktopBottom',
        subBuilder: PlayerDanmakuBlocktopBottom.create)
    ..aOM<PlayerDanmakuDomainV2>(23, _omitFieldNames ? '' : 'domainV2',
        subBuilder: PlayerDanmakuDomainV2.create)
    ..aOM<PlayerDanmakuDensity>(24, _omitFieldNames ? '' : 'density',
        subBuilder: PlayerDanmakuDensity.create)
    ..aOM<PlayerDanmakuSubtitleProof>(
        25, _omitFieldNames ? '' : 'subtitleProof',
        subBuilder: PlayerDanmakuSubtitleProof.create)
    ..aOM<PlayerDanmakuPeopleProof>(26, _omitFieldNames ? '' : 'peopleProof',
        subBuilder: PlayerDanmakuPeopleProof.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmPlayerConfigReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmPlayerConfigReq copyWith(void Function(DmPlayerConfigReq) updates) =>
      super.copyWith((message) => updates(message as DmPlayerConfigReq))
          as DmPlayerConfigReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DmPlayerConfigReq create() => DmPlayerConfigReq._();
  @$core.override
  DmPlayerConfigReq createEmptyInstance() => create();
  static $pb.PbList<DmPlayerConfigReq> createRepeated() =>
      $pb.PbList<DmPlayerConfigReq>();
  @$core.pragma('dart2js:noInline')
  static DmPlayerConfigReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmPlayerConfigReq>(create);
  static DmPlayerConfigReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get ts => $_getI64(0);
  @$pb.TagNumber(1)
  set ts($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTs() => $_has(0);
  @$pb.TagNumber(1)
  void clearTs() => $_clearField(1);

  @$pb.TagNumber(2)
  PlayerDanmakuSwitch get switch_2 => $_getN(1);
  @$pb.TagNumber(2)
  set switch_2(PlayerDanmakuSwitch value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSwitch_2() => $_has(1);
  @$pb.TagNumber(2)
  void clearSwitch_2() => $_clearField(2);
  @$pb.TagNumber(2)
  PlayerDanmakuSwitch ensureSwitch_2() => $_ensure(1);

  @$pb.TagNumber(3)
  PlayerDanmakuSwitchSave get switchSave => $_getN(2);
  @$pb.TagNumber(3)
  set switchSave(PlayerDanmakuSwitchSave value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSwitchSave() => $_has(2);
  @$pb.TagNumber(3)
  void clearSwitchSave() => $_clearField(3);
  @$pb.TagNumber(3)
  PlayerDanmakuSwitchSave ensureSwitchSave() => $_ensure(2);

  @$pb.TagNumber(4)
  PlayerDanmakuUseDefaultConfig get useDefaultConfig => $_getN(3);
  @$pb.TagNumber(4)
  set useDefaultConfig(PlayerDanmakuUseDefaultConfig value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUseDefaultConfig() => $_has(3);
  @$pb.TagNumber(4)
  void clearUseDefaultConfig() => $_clearField(4);
  @$pb.TagNumber(4)
  PlayerDanmakuUseDefaultConfig ensureUseDefaultConfig() => $_ensure(3);

  @$pb.TagNumber(5)
  PlayerDanmakuAiRecommendedSwitch get aiRecommendedSwitch => $_getN(4);
  @$pb.TagNumber(5)
  set aiRecommendedSwitch(PlayerDanmakuAiRecommendedSwitch value) =>
      $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAiRecommendedSwitch() => $_has(4);
  @$pb.TagNumber(5)
  void clearAiRecommendedSwitch() => $_clearField(5);
  @$pb.TagNumber(5)
  PlayerDanmakuAiRecommendedSwitch ensureAiRecommendedSwitch() => $_ensure(4);

  @$pb.TagNumber(6)
  PlayerDanmakuAiRecommendedLevel get aiRecommendedLevel => $_getN(5);
  @$pb.TagNumber(6)
  set aiRecommendedLevel(PlayerDanmakuAiRecommendedLevel value) =>
      $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAiRecommendedLevel() => $_has(5);
  @$pb.TagNumber(6)
  void clearAiRecommendedLevel() => $_clearField(6);
  @$pb.TagNumber(6)
  PlayerDanmakuAiRecommendedLevel ensureAiRecommendedLevel() => $_ensure(5);

  @$pb.TagNumber(7)
  PlayerDanmakuBlocktop get blocktop => $_getN(6);
  @$pb.TagNumber(7)
  set blocktop(PlayerDanmakuBlocktop value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasBlocktop() => $_has(6);
  @$pb.TagNumber(7)
  void clearBlocktop() => $_clearField(7);
  @$pb.TagNumber(7)
  PlayerDanmakuBlocktop ensureBlocktop() => $_ensure(6);

  @$pb.TagNumber(8)
  PlayerDanmakuBlockscroll get blockscroll => $_getN(7);
  @$pb.TagNumber(8)
  set blockscroll(PlayerDanmakuBlockscroll value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasBlockscroll() => $_has(7);
  @$pb.TagNumber(8)
  void clearBlockscroll() => $_clearField(8);
  @$pb.TagNumber(8)
  PlayerDanmakuBlockscroll ensureBlockscroll() => $_ensure(7);

  @$pb.TagNumber(9)
  PlayerDanmakuBlockbottom get blockbottom => $_getN(8);
  @$pb.TagNumber(9)
  set blockbottom(PlayerDanmakuBlockbottom value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasBlockbottom() => $_has(8);
  @$pb.TagNumber(9)
  void clearBlockbottom() => $_clearField(9);
  @$pb.TagNumber(9)
  PlayerDanmakuBlockbottom ensureBlockbottom() => $_ensure(8);

  @$pb.TagNumber(10)
  PlayerDanmakuBlockcolorful get blockcolorful => $_getN(9);
  @$pb.TagNumber(10)
  set blockcolorful(PlayerDanmakuBlockcolorful value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasBlockcolorful() => $_has(9);
  @$pb.TagNumber(10)
  void clearBlockcolorful() => $_clearField(10);
  @$pb.TagNumber(10)
  PlayerDanmakuBlockcolorful ensureBlockcolorful() => $_ensure(9);

  @$pb.TagNumber(11)
  PlayerDanmakuBlockrepeat get blockrepeat => $_getN(10);
  @$pb.TagNumber(11)
  set blockrepeat(PlayerDanmakuBlockrepeat value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasBlockrepeat() => $_has(10);
  @$pb.TagNumber(11)
  void clearBlockrepeat() => $_clearField(11);
  @$pb.TagNumber(11)
  PlayerDanmakuBlockrepeat ensureBlockrepeat() => $_ensure(10);

  @$pb.TagNumber(12)
  PlayerDanmakuBlockspecial get blockspecial => $_getN(11);
  @$pb.TagNumber(12)
  set blockspecial(PlayerDanmakuBlockspecial value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasBlockspecial() => $_has(11);
  @$pb.TagNumber(12)
  void clearBlockspecial() => $_clearField(12);
  @$pb.TagNumber(12)
  PlayerDanmakuBlockspecial ensureBlockspecial() => $_ensure(11);

  @$pb.TagNumber(13)
  PlayerDanmakuOpacity get opacity => $_getN(12);
  @$pb.TagNumber(13)
  set opacity(PlayerDanmakuOpacity value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasOpacity() => $_has(12);
  @$pb.TagNumber(13)
  void clearOpacity() => $_clearField(13);
  @$pb.TagNumber(13)
  PlayerDanmakuOpacity ensureOpacity() => $_ensure(12);

  @$pb.TagNumber(14)
  PlayerDanmakuScalingfactor get scalingfactor => $_getN(13);
  @$pb.TagNumber(14)
  set scalingfactor(PlayerDanmakuScalingfactor value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasScalingfactor() => $_has(13);
  @$pb.TagNumber(14)
  void clearScalingfactor() => $_clearField(14);
  @$pb.TagNumber(14)
  PlayerDanmakuScalingfactor ensureScalingfactor() => $_ensure(13);

  @$pb.TagNumber(15)
  PlayerDanmakuDomain get domain => $_getN(14);
  @$pb.TagNumber(15)
  set domain(PlayerDanmakuDomain value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasDomain() => $_has(14);
  @$pb.TagNumber(15)
  void clearDomain() => $_clearField(15);
  @$pb.TagNumber(15)
  PlayerDanmakuDomain ensureDomain() => $_ensure(14);

  @$pb.TagNumber(16)
  PlayerDanmakuSpeed get speed => $_getN(15);
  @$pb.TagNumber(16)
  set speed(PlayerDanmakuSpeed value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasSpeed() => $_has(15);
  @$pb.TagNumber(16)
  void clearSpeed() => $_clearField(16);
  @$pb.TagNumber(16)
  PlayerDanmakuSpeed ensureSpeed() => $_ensure(15);

  @$pb.TagNumber(17)
  PlayerDanmakuEnableblocklist get enableblocklist => $_getN(16);
  @$pb.TagNumber(17)
  set enableblocklist(PlayerDanmakuEnableblocklist value) =>
      $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasEnableblocklist() => $_has(16);
  @$pb.TagNumber(17)
  void clearEnableblocklist() => $_clearField(17);
  @$pb.TagNumber(17)
  PlayerDanmakuEnableblocklist ensureEnableblocklist() => $_ensure(16);

  @$pb.TagNumber(18)
  InlinePlayerDanmakuSwitch get inlinePlayerDanmakuSwitch => $_getN(17);
  @$pb.TagNumber(18)
  set inlinePlayerDanmakuSwitch(InlinePlayerDanmakuSwitch value) =>
      $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasInlinePlayerDanmakuSwitch() => $_has(17);
  @$pb.TagNumber(18)
  void clearInlinePlayerDanmakuSwitch() => $_clearField(18);
  @$pb.TagNumber(18)
  InlinePlayerDanmakuSwitch ensureInlinePlayerDanmakuSwitch() => $_ensure(17);

  @$pb.TagNumber(19)
  PlayerDanmakuSeniorModeSwitch get seniorModeSwitch => $_getN(18);
  @$pb.TagNumber(19)
  set seniorModeSwitch(PlayerDanmakuSeniorModeSwitch value) =>
      $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasSeniorModeSwitch() => $_has(18);
  @$pb.TagNumber(19)
  void clearSeniorModeSwitch() => $_clearField(19);
  @$pb.TagNumber(19)
  PlayerDanmakuSeniorModeSwitch ensureSeniorModeSwitch() => $_ensure(18);

  @$pb.TagNumber(20)
  PlayerDanmakuAiRecommendedLevelV2 get aiRecommendedLevelV2 => $_getN(19);
  @$pb.TagNumber(20)
  set aiRecommendedLevelV2(PlayerDanmakuAiRecommendedLevelV2 value) =>
      $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasAiRecommendedLevelV2() => $_has(19);
  @$pb.TagNumber(20)
  void clearAiRecommendedLevelV2() => $_clearField(20);
  @$pb.TagNumber(20)
  PlayerDanmakuAiRecommendedLevelV2 ensureAiRecommendedLevelV2() =>
      $_ensure(19);

  @$pb.TagNumber(21)
  PlayerDanmakuEnableHerdDm get enableHerdDm => $_getN(20);
  @$pb.TagNumber(21)
  set enableHerdDm(PlayerDanmakuEnableHerdDm value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasEnableHerdDm() => $_has(20);
  @$pb.TagNumber(21)
  void clearEnableHerdDm() => $_clearField(21);
  @$pb.TagNumber(21)
  PlayerDanmakuEnableHerdDm ensureEnableHerdDm() => $_ensure(20);

  @$pb.TagNumber(22)
  PlayerDanmakuBlocktopBottom get blocktopBottom => $_getN(21);
  @$pb.TagNumber(22)
  set blocktopBottom(PlayerDanmakuBlocktopBottom value) =>
      $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasBlocktopBottom() => $_has(21);
  @$pb.TagNumber(22)
  void clearBlocktopBottom() => $_clearField(22);
  @$pb.TagNumber(22)
  PlayerDanmakuBlocktopBottom ensureBlocktopBottom() => $_ensure(21);

  @$pb.TagNumber(23)
  PlayerDanmakuDomainV2 get domainV2 => $_getN(22);
  @$pb.TagNumber(23)
  set domainV2(PlayerDanmakuDomainV2 value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasDomainV2() => $_has(22);
  @$pb.TagNumber(23)
  void clearDomainV2() => $_clearField(23);
  @$pb.TagNumber(23)
  PlayerDanmakuDomainV2 ensureDomainV2() => $_ensure(22);

  @$pb.TagNumber(24)
  PlayerDanmakuDensity get density => $_getN(23);
  @$pb.TagNumber(24)
  set density(PlayerDanmakuDensity value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasDensity() => $_has(23);
  @$pb.TagNumber(24)
  void clearDensity() => $_clearField(24);
  @$pb.TagNumber(24)
  PlayerDanmakuDensity ensureDensity() => $_ensure(23);

  @$pb.TagNumber(25)
  PlayerDanmakuSubtitleProof get subtitleProof => $_getN(24);
  @$pb.TagNumber(25)
  set subtitleProof(PlayerDanmakuSubtitleProof value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasSubtitleProof() => $_has(24);
  @$pb.TagNumber(25)
  void clearSubtitleProof() => $_clearField(25);
  @$pb.TagNumber(25)
  PlayerDanmakuSubtitleProof ensureSubtitleProof() => $_ensure(24);

  @$pb.TagNumber(26)
  PlayerDanmakuPeopleProof get peopleProof => $_getN(25);
  @$pb.TagNumber(26)
  set peopleProof(PlayerDanmakuPeopleProof value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasPeopleProof() => $_has(25);
  @$pb.TagNumber(26)
  void clearPeopleProof() => $_clearField(26);
  @$pb.TagNumber(26)
  PlayerDanmakuPeopleProof ensurePeopleProof() => $_ensure(25);
}

class DmSegCacheReq extends $pb.GeneratedMessage {
  factory DmSegCacheReq({
    $core.int? type,
    $fixnum.Int64? oid,
    $fixnum.Int64? pid,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (oid != null) result.oid = oid;
    if (pid != null) result.pid = pid;
    return result;
  }

  DmSegCacheReq._();

  factory DmSegCacheReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DmSegCacheReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmSegCacheReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'type')
    ..aInt64(2, _omitFieldNames ? '' : 'oid')
    ..aInt64(3, _omitFieldNames ? '' : 'pid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmSegCacheReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmSegCacheReq copyWith(void Function(DmSegCacheReq) updates) =>
      super.copyWith((message) => updates(message as DmSegCacheReq))
          as DmSegCacheReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DmSegCacheReq create() => DmSegCacheReq._();
  @$core.override
  DmSegCacheReq createEmptyInstance() => create();
  static $pb.PbList<DmSegCacheReq> createRepeated() =>
      $pb.PbList<DmSegCacheReq>();
  @$core.pragma('dart2js:noInline')
  static DmSegCacheReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmSegCacheReq>(create);
  static DmSegCacheReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get oid => $_getI64(1);
  @$pb.TagNumber(2)
  set oid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get pid => $_getI64(2);
  @$pb.TagNumber(3)
  set pid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPid() => $_has(2);
  @$pb.TagNumber(3)
  void clearPid() => $_clearField(3);
}

class DmSegConfig extends $pb.GeneratedMessage {
  factory DmSegConfig({
    $fixnum.Int64? pageSize,
    $fixnum.Int64? total,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    if (total != null) result.total = total;
    return result;
  }

  DmSegConfig._();

  factory DmSegConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DmSegConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmSegConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'pageSize')
    ..aInt64(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmSegConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmSegConfig copyWith(void Function(DmSegConfig) updates) =>
      super.copyWith((message) => updates(message as DmSegConfig))
          as DmSegConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DmSegConfig create() => DmSegConfig._();
  @$core.override
  DmSegConfig createEmptyInstance() => create();
  static $pb.PbList<DmSegConfig> createRepeated() => $pb.PbList<DmSegConfig>();
  @$core.pragma('dart2js:noInline')
  static DmSegConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmSegConfig>(create);
  static DmSegConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get pageSize => $_getI64(0);
  @$pb.TagNumber(1)
  set pageSize($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class DmSegMobileReply extends $pb.GeneratedMessage {
  factory DmSegMobileReply({
    $core.Iterable<DanmakuElem>? elems,
    $core.int? state,
    DanmakuAIFlag? aiFlag,
    $core.Iterable<$fixnum.Int64>? segmentRules,
    $core.Iterable<DmColorful>? colorfulSrc,
    $core.String? contextSrc,
  }) {
    final result = create();
    if (elems != null) result.elems.addAll(elems);
    if (state != null) result.state = state;
    if (aiFlag != null) result.aiFlag = aiFlag;
    if (segmentRules != null) result.segmentRules.addAll(segmentRules);
    if (colorfulSrc != null) result.colorfulSrc.addAll(colorfulSrc);
    if (contextSrc != null) result.contextSrc = contextSrc;
    return result;
  }

  DmSegMobileReply._();

  factory DmSegMobileReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DmSegMobileReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmSegMobileReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pPM<DanmakuElem>(1, _omitFieldNames ? '' : 'elems',
        subBuilder: DanmakuElem.create)
    ..aI(2, _omitFieldNames ? '' : 'state')
    ..aOM<DanmakuAIFlag>(3, _omitFieldNames ? '' : 'aiFlag',
        subBuilder: DanmakuAIFlag.create)
    ..p<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'segmentRules', $pb.PbFieldType.K6)
    ..pPM<DmColorful>(5, _omitFieldNames ? '' : 'colorfulSrc',
        subBuilder: DmColorful.create)
    ..aOS(6, _omitFieldNames ? '' : 'contextSrc')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmSegMobileReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmSegMobileReply copyWith(void Function(DmSegMobileReply) updates) =>
      super.copyWith((message) => updates(message as DmSegMobileReply))
          as DmSegMobileReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DmSegMobileReply create() => DmSegMobileReply._();
  @$core.override
  DmSegMobileReply createEmptyInstance() => create();
  static $pb.PbList<DmSegMobileReply> createRepeated() =>
      $pb.PbList<DmSegMobileReply>();
  @$core.pragma('dart2js:noInline')
  static DmSegMobileReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmSegMobileReply>(create);
  static DmSegMobileReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DanmakuElem> get elems => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get state => $_getIZ(1);
  @$pb.TagNumber(2)
  set state($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  DanmakuAIFlag get aiFlag => $_getN(2);
  @$pb.TagNumber(3)
  set aiFlag(DanmakuAIFlag value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAiFlag() => $_has(2);
  @$pb.TagNumber(3)
  void clearAiFlag() => $_clearField(3);
  @$pb.TagNumber(3)
  DanmakuAIFlag ensureAiFlag() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<$fixnum.Int64> get segmentRules => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<DmColorful> get colorfulSrc => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get contextSrc => $_getSZ(5);
  @$pb.TagNumber(6)
  set contextSrc($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasContextSrc() => $_has(5);
  @$pb.TagNumber(6)
  void clearContextSrc() => $_clearField(6);
}

class DmSegMobileReq extends $pb.GeneratedMessage {
  factory DmSegMobileReq({
    $fixnum.Int64? pid,
    $fixnum.Int64? oid,
    $core.int? type,
    $fixnum.Int64? segmentIndex,
    $core.int? teenagersMode,
    $fixnum.Int64? ps,
    $fixnum.Int64? pe,
    $core.int? pullMode,
    $core.int? fromScene,
    $core.String? spmid,
    $core.String? contextExt,
  }) {
    final result = create();
    if (pid != null) result.pid = pid;
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    if (segmentIndex != null) result.segmentIndex = segmentIndex;
    if (teenagersMode != null) result.teenagersMode = teenagersMode;
    if (ps != null) result.ps = ps;
    if (pe != null) result.pe = pe;
    if (pullMode != null) result.pullMode = pullMode;
    if (fromScene != null) result.fromScene = fromScene;
    if (spmid != null) result.spmid = spmid;
    if (contextExt != null) result.contextExt = contextExt;
    return result;
  }

  DmSegMobileReq._();

  factory DmSegMobileReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DmSegMobileReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmSegMobileReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'pid')
    ..aInt64(2, _omitFieldNames ? '' : 'oid')
    ..aI(3, _omitFieldNames ? '' : 'type')
    ..aInt64(4, _omitFieldNames ? '' : 'segmentIndex')
    ..aI(5, _omitFieldNames ? '' : 'teenagersMode')
    ..aInt64(6, _omitFieldNames ? '' : 'ps')
    ..aInt64(7, _omitFieldNames ? '' : 'pe')
    ..aI(8, _omitFieldNames ? '' : 'pullMode')
    ..aI(9, _omitFieldNames ? '' : 'fromScene')
    ..aOS(10, _omitFieldNames ? '' : 'spmid')
    ..aOS(11, _omitFieldNames ? '' : 'contextExt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmSegMobileReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmSegMobileReq copyWith(void Function(DmSegMobileReq) updates) =>
      super.copyWith((message) => updates(message as DmSegMobileReq))
          as DmSegMobileReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DmSegMobileReq create() => DmSegMobileReq._();
  @$core.override
  DmSegMobileReq createEmptyInstance() => create();
  static $pb.PbList<DmSegMobileReq> createRepeated() =>
      $pb.PbList<DmSegMobileReq>();
  @$core.pragma('dart2js:noInline')
  static DmSegMobileReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmSegMobileReq>(create);
  static DmSegMobileReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get pid => $_getI64(0);
  @$pb.TagNumber(1)
  set pid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPid() => $_has(0);
  @$pb.TagNumber(1)
  void clearPid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get oid => $_getI64(1);
  @$pb.TagNumber(2)
  set oid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get type => $_getIZ(2);
  @$pb.TagNumber(3)
  set type($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get segmentIndex => $_getI64(3);
  @$pb.TagNumber(4)
  set segmentIndex($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSegmentIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearSegmentIndex() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get teenagersMode => $_getIZ(4);
  @$pb.TagNumber(5)
  set teenagersMode($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTeenagersMode() => $_has(4);
  @$pb.TagNumber(5)
  void clearTeenagersMode() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get ps => $_getI64(5);
  @$pb.TagNumber(6)
  set ps($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPs() => $_has(5);
  @$pb.TagNumber(6)
  void clearPs() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get pe => $_getI64(6);
  @$pb.TagNumber(7)
  set pe($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPe() => $_has(6);
  @$pb.TagNumber(7)
  void clearPe() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get pullMode => $_getIZ(7);
  @$pb.TagNumber(8)
  set pullMode($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPullMode() => $_has(7);
  @$pb.TagNumber(8)
  void clearPullMode() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get fromScene => $_getIZ(8);
  @$pb.TagNumber(9)
  set fromScene($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFromScene() => $_has(8);
  @$pb.TagNumber(9)
  void clearFromScene() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get spmid => $_getSZ(9);
  @$pb.TagNumber(10)
  set spmid($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSpmid() => $_has(9);
  @$pb.TagNumber(10)
  void clearSpmid() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get contextExt => $_getSZ(10);
  @$pb.TagNumber(11)
  set contextExt($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasContextExt() => $_has(10);
  @$pb.TagNumber(11)
  void clearContextExt() => $_clearField(11);
}

class DmSegOttReply extends $pb.GeneratedMessage {
  factory DmSegOttReply({
    $core.Iterable<DanmakuElem>? elems,
    $core.int? state,
  }) {
    final result = create();
    if (elems != null) result.elems.addAll(elems);
    if (state != null) result.state = state;
    return result;
  }

  DmSegOttReply._();

  factory DmSegOttReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DmSegOttReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmSegOttReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pPM<DanmakuElem>(1, _omitFieldNames ? '' : 'elems',
        subBuilder: DanmakuElem.create)
    ..aI(2, _omitFieldNames ? '' : 'state')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmSegOttReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmSegOttReply copyWith(void Function(DmSegOttReply) updates) =>
      super.copyWith((message) => updates(message as DmSegOttReply))
          as DmSegOttReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DmSegOttReply create() => DmSegOttReply._();
  @$core.override
  DmSegOttReply createEmptyInstance() => create();
  static $pb.PbList<DmSegOttReply> createRepeated() =>
      $pb.PbList<DmSegOttReply>();
  @$core.pragma('dart2js:noInline')
  static DmSegOttReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmSegOttReply>(create);
  static DmSegOttReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DanmakuElem> get elems => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get state => $_getIZ(1);
  @$pb.TagNumber(2)
  set state($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);
}

class DmSegOttReq extends $pb.GeneratedMessage {
  factory DmSegOttReq({
    $fixnum.Int64? pid,
    $fixnum.Int64? oid,
    $core.int? type,
    $fixnum.Int64? segmentIndex,
  }) {
    final result = create();
    if (pid != null) result.pid = pid;
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    if (segmentIndex != null) result.segmentIndex = segmentIndex;
    return result;
  }

  DmSegOttReq._();

  factory DmSegOttReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DmSegOttReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmSegOttReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'pid')
    ..aInt64(2, _omitFieldNames ? '' : 'oid')
    ..aI(3, _omitFieldNames ? '' : 'type')
    ..aInt64(4, _omitFieldNames ? '' : 'segmentIndex')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmSegOttReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmSegOttReq copyWith(void Function(DmSegOttReq) updates) =>
      super.copyWith((message) => updates(message as DmSegOttReq))
          as DmSegOttReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DmSegOttReq create() => DmSegOttReq._();
  @$core.override
  DmSegOttReq createEmptyInstance() => create();
  static $pb.PbList<DmSegOttReq> createRepeated() => $pb.PbList<DmSegOttReq>();
  @$core.pragma('dart2js:noInline')
  static DmSegOttReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmSegOttReq>(create);
  static DmSegOttReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get pid => $_getI64(0);
  @$pb.TagNumber(1)
  set pid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPid() => $_has(0);
  @$pb.TagNumber(1)
  void clearPid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get oid => $_getI64(1);
  @$pb.TagNumber(2)
  set oid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get type => $_getIZ(2);
  @$pb.TagNumber(3)
  set type($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get segmentIndex => $_getI64(3);
  @$pb.TagNumber(4)
  set segmentIndex($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSegmentIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearSegmentIndex() => $_clearField(4);
}

class DmSegSDKReply extends $pb.GeneratedMessage {
  factory DmSegSDKReply({
    $core.bool? closed,
    $core.Iterable<DanmakuElem>? elems,
  }) {
    final result = create();
    if (closed != null) result.closed = closed;
    if (elems != null) result.elems.addAll(elems);
    return result;
  }

  DmSegSDKReply._();

  factory DmSegSDKReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DmSegSDKReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmSegSDKReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'closed')
    ..pPM<DanmakuElem>(2, _omitFieldNames ? '' : 'elems',
        subBuilder: DanmakuElem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmSegSDKReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmSegSDKReply copyWith(void Function(DmSegSDKReply) updates) =>
      super.copyWith((message) => updates(message as DmSegSDKReply))
          as DmSegSDKReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DmSegSDKReply create() => DmSegSDKReply._();
  @$core.override
  DmSegSDKReply createEmptyInstance() => create();
  static $pb.PbList<DmSegSDKReply> createRepeated() =>
      $pb.PbList<DmSegSDKReply>();
  @$core.pragma('dart2js:noInline')
  static DmSegSDKReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmSegSDKReply>(create);
  static DmSegSDKReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get closed => $_getBF(0);
  @$pb.TagNumber(1)
  set closed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClosed() => $_has(0);
  @$pb.TagNumber(1)
  void clearClosed() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<DanmakuElem> get elems => $_getList(1);
}

class DmSegSDKReq extends $pb.GeneratedMessage {
  factory DmSegSDKReq({
    $fixnum.Int64? pid,
    $fixnum.Int64? oid,
    $core.int? type,
    $fixnum.Int64? segmentIndex,
  }) {
    final result = create();
    if (pid != null) result.pid = pid;
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    if (segmentIndex != null) result.segmentIndex = segmentIndex;
    return result;
  }

  DmSegSDKReq._();

  factory DmSegSDKReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DmSegSDKReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmSegSDKReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'pid')
    ..aInt64(2, _omitFieldNames ? '' : 'oid')
    ..aI(3, _omitFieldNames ? '' : 'type')
    ..aInt64(4, _omitFieldNames ? '' : 'segmentIndex')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmSegSDKReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmSegSDKReq copyWith(void Function(DmSegSDKReq) updates) =>
      super.copyWith((message) => updates(message as DmSegSDKReq))
          as DmSegSDKReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DmSegSDKReq create() => DmSegSDKReq._();
  @$core.override
  DmSegSDKReq createEmptyInstance() => create();
  static $pb.PbList<DmSegSDKReq> createRepeated() => $pb.PbList<DmSegSDKReq>();
  @$core.pragma('dart2js:noInline')
  static DmSegSDKReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmSegSDKReq>(create);
  static DmSegSDKReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get pid => $_getI64(0);
  @$pb.TagNumber(1)
  set pid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPid() => $_has(0);
  @$pb.TagNumber(1)
  void clearPid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get oid => $_getI64(1);
  @$pb.TagNumber(2)
  set oid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get type => $_getIZ(2);
  @$pb.TagNumber(3)
  set type($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get segmentIndex => $_getI64(3);
  @$pb.TagNumber(4)
  set segmentIndex($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSegmentIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearSegmentIndex() => $_clearField(4);
}

class DmSubView extends $pb.GeneratedMessage {
  factory DmSubView({
    $core.int? type,
    $fixnum.Int64? oid,
    $fixnum.Int64? pid,
    $core.Iterable<PostPanelV2>? postPanel2,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (oid != null) result.oid = oid;
    if (pid != null) result.pid = pid;
    if (postPanel2 != null) result.postPanel2.addAll(postPanel2);
    return result;
  }

  DmSubView._();

  factory DmSubView.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DmSubView.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmSubView',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'type')
    ..aInt64(2, _omitFieldNames ? '' : 'oid')
    ..aInt64(3, _omitFieldNames ? '' : 'pid')
    ..pPM<PostPanelV2>(4, _omitFieldNames ? '' : 'postPanel2',
        subBuilder: PostPanelV2.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmSubView clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmSubView copyWith(void Function(DmSubView) updates) =>
      super.copyWith((message) => updates(message as DmSubView)) as DmSubView;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DmSubView create() => DmSubView._();
  @$core.override
  DmSubView createEmptyInstance() => create();
  static $pb.PbList<DmSubView> createRepeated() => $pb.PbList<DmSubView>();
  @$core.pragma('dart2js:noInline')
  static DmSubView getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DmSubView>(create);
  static DmSubView? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get oid => $_getI64(1);
  @$pb.TagNumber(2)
  set oid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get pid => $_getI64(2);
  @$pb.TagNumber(3)
  set pid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPid() => $_has(2);
  @$pb.TagNumber(3)
  void clearPid() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<PostPanelV2> get postPanel2 => $_getList(3);
}

class DmViewReply extends $pb.GeneratedMessage {
  factory DmViewReply({
    $core.bool? closed,
    VideoMask? mask,
    VideoSubtitle? subtitle,
    $core.Iterable<$core.String>? specialDms,
    DanmakuFlagConfig? aiFlag,
    DanmuPlayerViewConfig? playerConfig,
    $core.int? sendBoxStyle,
    $core.bool? allow,
    $core.bool? checkBox,
    $core.String? checkBoxShowMsg,
    $core.String? textPlaceholder,
    $core.String? inputPlaceholder,
    $core.Iterable<$core.String>? reportFilterContent,
    ExpoReport? expoReport,
    BuzzwordConfig? buzzwordConfig,
    $core.Iterable<Expressions>? expressions,
    $core.Iterable<PostPanel>? postPanel,
    $core.Iterable<$core.String>? activityMeta,
    $core.Iterable<PostPanelV2>? postPanel2,
    $core.Iterable<DmMaskWall>? dmMaskWall,
    DmHerdView? dmHerd,
    Command? command,
    $core.String? kv,
    $core.Iterable<DmSubView>? subViews,
    QoeInfo? qoe,
  }) {
    final result = create();
    if (closed != null) result.closed = closed;
    if (mask != null) result.mask = mask;
    if (subtitle != null) result.subtitle = subtitle;
    if (specialDms != null) result.specialDms.addAll(specialDms);
    if (aiFlag != null) result.aiFlag = aiFlag;
    if (playerConfig != null) result.playerConfig = playerConfig;
    if (sendBoxStyle != null) result.sendBoxStyle = sendBoxStyle;
    if (allow != null) result.allow = allow;
    if (checkBox != null) result.checkBox = checkBox;
    if (checkBoxShowMsg != null) result.checkBoxShowMsg = checkBoxShowMsg;
    if (textPlaceholder != null) result.textPlaceholder = textPlaceholder;
    if (inputPlaceholder != null) result.inputPlaceholder = inputPlaceholder;
    if (reportFilterContent != null)
      result.reportFilterContent.addAll(reportFilterContent);
    if (expoReport != null) result.expoReport = expoReport;
    if (buzzwordConfig != null) result.buzzwordConfig = buzzwordConfig;
    if (expressions != null) result.expressions.addAll(expressions);
    if (postPanel != null) result.postPanel.addAll(postPanel);
    if (activityMeta != null) result.activityMeta.addAll(activityMeta);
    if (postPanel2 != null) result.postPanel2.addAll(postPanel2);
    if (dmMaskWall != null) result.dmMaskWall.addAll(dmMaskWall);
    if (dmHerd != null) result.dmHerd = dmHerd;
    if (command != null) result.command = command;
    if (kv != null) result.kv = kv;
    if (subViews != null) result.subViews.addAll(subViews);
    if (qoe != null) result.qoe = qoe;
    return result;
  }

  DmViewReply._();

  factory DmViewReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DmViewReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmViewReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'closed')
    ..aOM<VideoMask>(2, _omitFieldNames ? '' : 'mask',
        subBuilder: VideoMask.create)
    ..aOM<VideoSubtitle>(3, _omitFieldNames ? '' : 'subtitle',
        subBuilder: VideoSubtitle.create)
    ..pPS(4, _omitFieldNames ? '' : 'specialDms')
    ..aOM<DanmakuFlagConfig>(5, _omitFieldNames ? '' : 'aiFlag',
        subBuilder: DanmakuFlagConfig.create)
    ..aOM<DanmuPlayerViewConfig>(6, _omitFieldNames ? '' : 'playerConfig',
        subBuilder: DanmuPlayerViewConfig.create)
    ..aI(7, _omitFieldNames ? '' : 'sendBoxStyle')
    ..aOB(8, _omitFieldNames ? '' : 'allow')
    ..aOB(9, _omitFieldNames ? '' : 'checkBox')
    ..aOS(10, _omitFieldNames ? '' : 'checkBoxShowMsg')
    ..aOS(11, _omitFieldNames ? '' : 'textPlaceholder')
    ..aOS(12, _omitFieldNames ? '' : 'inputPlaceholder')
    ..pPS(13, _omitFieldNames ? '' : 'reportFilterContent')
    ..aOM<ExpoReport>(14, _omitFieldNames ? '' : 'expoReport',
        subBuilder: ExpoReport.create)
    ..aOM<BuzzwordConfig>(15, _omitFieldNames ? '' : 'buzzwordConfig',
        subBuilder: BuzzwordConfig.create)
    ..pPM<Expressions>(16, _omitFieldNames ? '' : 'expressions',
        subBuilder: Expressions.create)
    ..pPM<PostPanel>(17, _omitFieldNames ? '' : 'postPanel',
        subBuilder: PostPanel.create)
    ..pPS(18, _omitFieldNames ? '' : 'activityMeta')
    ..pPM<PostPanelV2>(19, _omitFieldNames ? '' : 'postPanel2',
        subBuilder: PostPanelV2.create)
    ..pPM<DmMaskWall>(20, _omitFieldNames ? '' : 'dmMaskWall',
        subBuilder: DmMaskWall.create)
    ..aOM<DmHerdView>(21, _omitFieldNames ? '' : 'dmHerd',
        subBuilder: DmHerdView.create)
    ..aOM<Command>(22, _omitFieldNames ? '' : 'command',
        subBuilder: Command.create)
    ..aOS(23, _omitFieldNames ? '' : 'kv')
    ..pPM<DmSubView>(24, _omitFieldNames ? '' : 'subViews',
        subBuilder: DmSubView.create)
    ..aOM<QoeInfo>(25, _omitFieldNames ? '' : 'qoe', subBuilder: QoeInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmViewReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmViewReply copyWith(void Function(DmViewReply) updates) =>
      super.copyWith((message) => updates(message as DmViewReply))
          as DmViewReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DmViewReply create() => DmViewReply._();
  @$core.override
  DmViewReply createEmptyInstance() => create();
  static $pb.PbList<DmViewReply> createRepeated() => $pb.PbList<DmViewReply>();
  @$core.pragma('dart2js:noInline')
  static DmViewReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmViewReply>(create);
  static DmViewReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get closed => $_getBF(0);
  @$pb.TagNumber(1)
  set closed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClosed() => $_has(0);
  @$pb.TagNumber(1)
  void clearClosed() => $_clearField(1);

  @$pb.TagNumber(2)
  VideoMask get mask => $_getN(1);
  @$pb.TagNumber(2)
  set mask(VideoMask value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMask() => $_has(1);
  @$pb.TagNumber(2)
  void clearMask() => $_clearField(2);
  @$pb.TagNumber(2)
  VideoMask ensureMask() => $_ensure(1);

  @$pb.TagNumber(3)
  VideoSubtitle get subtitle => $_getN(2);
  @$pb.TagNumber(3)
  set subtitle(VideoSubtitle value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSubtitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubtitle() => $_clearField(3);
  @$pb.TagNumber(3)
  VideoSubtitle ensureSubtitle() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get specialDms => $_getList(3);

  @$pb.TagNumber(5)
  DanmakuFlagConfig get aiFlag => $_getN(4);
  @$pb.TagNumber(5)
  set aiFlag(DanmakuFlagConfig value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAiFlag() => $_has(4);
  @$pb.TagNumber(5)
  void clearAiFlag() => $_clearField(5);
  @$pb.TagNumber(5)
  DanmakuFlagConfig ensureAiFlag() => $_ensure(4);

  @$pb.TagNumber(6)
  DanmuPlayerViewConfig get playerConfig => $_getN(5);
  @$pb.TagNumber(6)
  set playerConfig(DanmuPlayerViewConfig value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPlayerConfig() => $_has(5);
  @$pb.TagNumber(6)
  void clearPlayerConfig() => $_clearField(6);
  @$pb.TagNumber(6)
  DanmuPlayerViewConfig ensurePlayerConfig() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.int get sendBoxStyle => $_getIZ(6);
  @$pb.TagNumber(7)
  set sendBoxStyle($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSendBoxStyle() => $_has(6);
  @$pb.TagNumber(7)
  void clearSendBoxStyle() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get allow => $_getBF(7);
  @$pb.TagNumber(8)
  set allow($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAllow() => $_has(7);
  @$pb.TagNumber(8)
  void clearAllow() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get checkBox => $_getBF(8);
  @$pb.TagNumber(9)
  set checkBox($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCheckBox() => $_has(8);
  @$pb.TagNumber(9)
  void clearCheckBox() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get checkBoxShowMsg => $_getSZ(9);
  @$pb.TagNumber(10)
  set checkBoxShowMsg($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCheckBoxShowMsg() => $_has(9);
  @$pb.TagNumber(10)
  void clearCheckBoxShowMsg() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get textPlaceholder => $_getSZ(10);
  @$pb.TagNumber(11)
  set textPlaceholder($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasTextPlaceholder() => $_has(10);
  @$pb.TagNumber(11)
  void clearTextPlaceholder() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get inputPlaceholder => $_getSZ(11);
  @$pb.TagNumber(12)
  set inputPlaceholder($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasInputPlaceholder() => $_has(11);
  @$pb.TagNumber(12)
  void clearInputPlaceholder() => $_clearField(12);

  @$pb.TagNumber(13)
  $pb.PbList<$core.String> get reportFilterContent => $_getList(12);

  @$pb.TagNumber(14)
  ExpoReport get expoReport => $_getN(13);
  @$pb.TagNumber(14)
  set expoReport(ExpoReport value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasExpoReport() => $_has(13);
  @$pb.TagNumber(14)
  void clearExpoReport() => $_clearField(14);
  @$pb.TagNumber(14)
  ExpoReport ensureExpoReport() => $_ensure(13);

  @$pb.TagNumber(15)
  BuzzwordConfig get buzzwordConfig => $_getN(14);
  @$pb.TagNumber(15)
  set buzzwordConfig(BuzzwordConfig value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasBuzzwordConfig() => $_has(14);
  @$pb.TagNumber(15)
  void clearBuzzwordConfig() => $_clearField(15);
  @$pb.TagNumber(15)
  BuzzwordConfig ensureBuzzwordConfig() => $_ensure(14);

  @$pb.TagNumber(16)
  $pb.PbList<Expressions> get expressions => $_getList(15);

  @$pb.TagNumber(17)
  $pb.PbList<PostPanel> get postPanel => $_getList(16);

  @$pb.TagNumber(18)
  $pb.PbList<$core.String> get activityMeta => $_getList(17);

  @$pb.TagNumber(19)
  $pb.PbList<PostPanelV2> get postPanel2 => $_getList(18);

  @$pb.TagNumber(20)
  $pb.PbList<DmMaskWall> get dmMaskWall => $_getList(19);

  @$pb.TagNumber(21)
  DmHerdView get dmHerd => $_getN(20);
  @$pb.TagNumber(21)
  set dmHerd(DmHerdView value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasDmHerd() => $_has(20);
  @$pb.TagNumber(21)
  void clearDmHerd() => $_clearField(21);
  @$pb.TagNumber(21)
  DmHerdView ensureDmHerd() => $_ensure(20);

  @$pb.TagNumber(22)
  Command get command => $_getN(21);
  @$pb.TagNumber(22)
  set command(Command value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasCommand() => $_has(21);
  @$pb.TagNumber(22)
  void clearCommand() => $_clearField(22);
  @$pb.TagNumber(22)
  Command ensureCommand() => $_ensure(21);

  @$pb.TagNumber(23)
  $core.String get kv => $_getSZ(22);
  @$pb.TagNumber(23)
  set kv($core.String value) => $_setString(22, value);
  @$pb.TagNumber(23)
  $core.bool hasKv() => $_has(22);
  @$pb.TagNumber(23)
  void clearKv() => $_clearField(23);

  @$pb.TagNumber(24)
  $pb.PbList<DmSubView> get subViews => $_getList(23);

  @$pb.TagNumber(25)
  QoeInfo get qoe => $_getN(24);
  @$pb.TagNumber(25)
  set qoe(QoeInfo value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasQoe() => $_has(24);
  @$pb.TagNumber(25)
  void clearQoe() => $_clearField(25);
  @$pb.TagNumber(25)
  QoeInfo ensureQoe() => $_ensure(24);
}

class DmViewReq extends $pb.GeneratedMessage {
  factory DmViewReq({
    $fixnum.Int64? pid,
    $fixnum.Int64? oid,
    $core.int? type,
    $core.String? spmid,
    $core.int? isHardBoot,
    $core.String? contextExt,
  }) {
    final result = create();
    if (pid != null) result.pid = pid;
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    if (spmid != null) result.spmid = spmid;
    if (isHardBoot != null) result.isHardBoot = isHardBoot;
    if (contextExt != null) result.contextExt = contextExt;
    return result;
  }

  DmViewReq._();

  factory DmViewReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DmViewReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmViewReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'pid')
    ..aInt64(2, _omitFieldNames ? '' : 'oid')
    ..aI(3, _omitFieldNames ? '' : 'type')
    ..aOS(4, _omitFieldNames ? '' : 'spmid')
    ..aI(5, _omitFieldNames ? '' : 'isHardBoot')
    ..aOS(6, _omitFieldNames ? '' : 'contextExt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmViewReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmViewReq copyWith(void Function(DmViewReq) updates) =>
      super.copyWith((message) => updates(message as DmViewReq)) as DmViewReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DmViewReq create() => DmViewReq._();
  @$core.override
  DmViewReq createEmptyInstance() => create();
  static $pb.PbList<DmViewReq> createRepeated() => $pb.PbList<DmViewReq>();
  @$core.pragma('dart2js:noInline')
  static DmViewReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DmViewReq>(create);
  static DmViewReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get pid => $_getI64(0);
  @$pb.TagNumber(1)
  set pid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPid() => $_has(0);
  @$pb.TagNumber(1)
  void clearPid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get oid => $_getI64(1);
  @$pb.TagNumber(2)
  set oid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get type => $_getIZ(2);
  @$pb.TagNumber(3)
  set type($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get spmid => $_getSZ(3);
  @$pb.TagNumber(4)
  set spmid($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSpmid() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpmid() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get isHardBoot => $_getIZ(4);
  @$pb.TagNumber(5)
  set isHardBoot($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsHardBoot() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsHardBoot() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get contextExt => $_getSZ(5);
  @$pb.TagNumber(6)
  set contextExt($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasContextExt() => $_has(5);
  @$pb.TagNumber(6)
  void clearContextExt() => $_clearField(6);
}

class DmWebViewReply extends $pb.GeneratedMessage {
  factory DmWebViewReply({
    $core.int? state,
    $core.String? text,
    $core.String? textSide,
    DmSegConfig? dmSge,
    DanmakuFlagConfig? flag,
    $core.Iterable<$core.String>? specialDms,
    $core.bool? checkBox,
    $fixnum.Int64? count,
    $core.Iterable<CommandDm>? commandDms,
    DanmuWebPlayerConfig? playerConfig,
    $core.Iterable<$core.String>? reportFilterContent,
    $core.Iterable<Expressions>? expressions,
    $core.Iterable<PostPanel>? postPanel,
    $core.Iterable<$core.String>? activityMeta,
    $core.Iterable<PostPanelV2>? postPanel2,
    $core.Iterable<DmSubView>? subViews,
    QoeInfo? qoe,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (text != null) result.text = text;
    if (textSide != null) result.textSide = textSide;
    if (dmSge != null) result.dmSge = dmSge;
    if (flag != null) result.flag = flag;
    if (specialDms != null) result.specialDms.addAll(specialDms);
    if (checkBox != null) result.checkBox = checkBox;
    if (count != null) result.count = count;
    if (commandDms != null) result.commandDms.addAll(commandDms);
    if (playerConfig != null) result.playerConfig = playerConfig;
    if (reportFilterContent != null)
      result.reportFilterContent.addAll(reportFilterContent);
    if (expressions != null) result.expressions.addAll(expressions);
    if (postPanel != null) result.postPanel.addAll(postPanel);
    if (activityMeta != null) result.activityMeta.addAll(activityMeta);
    if (postPanel2 != null) result.postPanel2.addAll(postPanel2);
    if (subViews != null) result.subViews.addAll(subViews);
    if (qoe != null) result.qoe = qoe;
    return result;
  }

  DmWebViewReply._();

  factory DmWebViewReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DmWebViewReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmWebViewReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'state')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'textSide')
    ..aOM<DmSegConfig>(4, _omitFieldNames ? '' : 'dmSge',
        subBuilder: DmSegConfig.create)
    ..aOM<DanmakuFlagConfig>(5, _omitFieldNames ? '' : 'flag',
        subBuilder: DanmakuFlagConfig.create)
    ..pPS(6, _omitFieldNames ? '' : 'specialDms')
    ..aOB(7, _omitFieldNames ? '' : 'checkBox')
    ..aInt64(8, _omitFieldNames ? '' : 'count')
    ..pPM<CommandDm>(9, _omitFieldNames ? '' : 'commandDms',
        subBuilder: CommandDm.create)
    ..aOM<DanmuWebPlayerConfig>(10, _omitFieldNames ? '' : 'playerConfig',
        subBuilder: DanmuWebPlayerConfig.create)
    ..pPS(11, _omitFieldNames ? '' : 'reportFilterContent')
    ..pPM<Expressions>(12, _omitFieldNames ? '' : 'expressions',
        subBuilder: Expressions.create)
    ..pPM<PostPanel>(13, _omitFieldNames ? '' : 'postPanel',
        subBuilder: PostPanel.create)
    ..pPS(14, _omitFieldNames ? '' : 'activityMeta')
    ..pPM<PostPanelV2>(15, _omitFieldNames ? '' : 'postPanel2',
        subBuilder: PostPanelV2.create)
    ..pPM<DmSubView>(16, _omitFieldNames ? '' : 'subViews',
        subBuilder: DmSubView.create)
    ..aOM<QoeInfo>(17, _omitFieldNames ? '' : 'qoe', subBuilder: QoeInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmWebViewReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmWebViewReply copyWith(void Function(DmWebViewReply) updates) =>
      super.copyWith((message) => updates(message as DmWebViewReply))
          as DmWebViewReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DmWebViewReply create() => DmWebViewReply._();
  @$core.override
  DmWebViewReply createEmptyInstance() => create();
  static $pb.PbList<DmWebViewReply> createRepeated() =>
      $pb.PbList<DmWebViewReply>();
  @$core.pragma('dart2js:noInline')
  static DmWebViewReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmWebViewReply>(create);
  static DmWebViewReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get state => $_getIZ(0);
  @$pb.TagNumber(1)
  set state($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get textSide => $_getSZ(2);
  @$pb.TagNumber(3)
  set textSide($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTextSide() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextSide() => $_clearField(3);

  @$pb.TagNumber(4)
  DmSegConfig get dmSge => $_getN(3);
  @$pb.TagNumber(4)
  set dmSge(DmSegConfig value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDmSge() => $_has(3);
  @$pb.TagNumber(4)
  void clearDmSge() => $_clearField(4);
  @$pb.TagNumber(4)
  DmSegConfig ensureDmSge() => $_ensure(3);

  @$pb.TagNumber(5)
  DanmakuFlagConfig get flag => $_getN(4);
  @$pb.TagNumber(5)
  set flag(DanmakuFlagConfig value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasFlag() => $_has(4);
  @$pb.TagNumber(5)
  void clearFlag() => $_clearField(5);
  @$pb.TagNumber(5)
  DanmakuFlagConfig ensureFlag() => $_ensure(4);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get specialDms => $_getList(5);

  @$pb.TagNumber(7)
  $core.bool get checkBox => $_getBF(6);
  @$pb.TagNumber(7)
  set checkBox($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCheckBox() => $_has(6);
  @$pb.TagNumber(7)
  void clearCheckBox() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get count => $_getI64(7);
  @$pb.TagNumber(8)
  set count($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearCount() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<CommandDm> get commandDms => $_getList(8);

  @$pb.TagNumber(10)
  DanmuWebPlayerConfig get playerConfig => $_getN(9);
  @$pb.TagNumber(10)
  set playerConfig(DanmuWebPlayerConfig value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasPlayerConfig() => $_has(9);
  @$pb.TagNumber(10)
  void clearPlayerConfig() => $_clearField(10);
  @$pb.TagNumber(10)
  DanmuWebPlayerConfig ensurePlayerConfig() => $_ensure(9);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get reportFilterContent => $_getList(10);

  @$pb.TagNumber(12)
  $pb.PbList<Expressions> get expressions => $_getList(11);

  @$pb.TagNumber(13)
  $pb.PbList<PostPanel> get postPanel => $_getList(12);

  @$pb.TagNumber(14)
  $pb.PbList<$core.String> get activityMeta => $_getList(13);

  @$pb.TagNumber(15)
  $pb.PbList<PostPanelV2> get postPanel2 => $_getList(14);

  @$pb.TagNumber(16)
  $pb.PbList<DmSubView> get subViews => $_getList(15);

  @$pb.TagNumber(17)
  QoeInfo get qoe => $_getN(16);
  @$pb.TagNumber(17)
  set qoe(QoeInfo value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasQoe() => $_has(16);
  @$pb.TagNumber(17)
  void clearQoe() => $_clearField(17);
  @$pb.TagNumber(17)
  QoeInfo ensureQoe() => $_ensure(16);
}

class ExpoReport extends $pb.GeneratedMessage {
  factory ExpoReport({
    $core.bool? shouldReportAtEnd,
    $core.double? playerSample,
    $core.Iterable<ReportDuration>? durations,
    $core.int? maxSize,
  }) {
    final result = create();
    if (shouldReportAtEnd != null) result.shouldReportAtEnd = shouldReportAtEnd;
    if (playerSample != null) result.playerSample = playerSample;
    if (durations != null) result.durations.addAll(durations);
    if (maxSize != null) result.maxSize = maxSize;
    return result;
  }

  ExpoReport._();

  factory ExpoReport.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExpoReport.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExpoReport',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'shouldReportAtEnd')
    ..aD(2, _omitFieldNames ? '' : 'playerSample')
    ..pPM<ReportDuration>(3, _omitFieldNames ? '' : 'durations',
        subBuilder: ReportDuration.create)
    ..aI(4, _omitFieldNames ? '' : 'maxSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExpoReport clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExpoReport copyWith(void Function(ExpoReport) updates) =>
      super.copyWith((message) => updates(message as ExpoReport)) as ExpoReport;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExpoReport create() => ExpoReport._();
  @$core.override
  ExpoReport createEmptyInstance() => create();
  static $pb.PbList<ExpoReport> createRepeated() => $pb.PbList<ExpoReport>();
  @$core.pragma('dart2js:noInline')
  static ExpoReport getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExpoReport>(create);
  static ExpoReport? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get shouldReportAtEnd => $_getBF(0);
  @$pb.TagNumber(1)
  set shouldReportAtEnd($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShouldReportAtEnd() => $_has(0);
  @$pb.TagNumber(1)
  void clearShouldReportAtEnd() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get playerSample => $_getN(1);
  @$pb.TagNumber(2)
  set playerSample($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlayerSample() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayerSample() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<ReportDuration> get durations => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get maxSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set maxSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxSize() => $_clearField(4);
}

class Expression extends $pb.GeneratedMessage {
  factory Expression({
    $core.Iterable<$core.String>? keyword,
    $core.String? url,
    $core.Iterable<Period>? period,
  }) {
    final result = create();
    if (keyword != null) result.keyword.addAll(keyword);
    if (url != null) result.url = url;
    if (period != null) result.period.addAll(period);
    return result;
  }

  Expression._();

  factory Expression.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Expression.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Expression',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'keyword')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..pPM<Period>(3, _omitFieldNames ? '' : 'period', subBuilder: Period.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Expression clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Expression copyWith(void Function(Expression) updates) =>
      super.copyWith((message) => updates(message as Expression)) as Expression;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Expression create() => Expression._();
  @$core.override
  Expression createEmptyInstance() => create();
  static $pb.PbList<Expression> createRepeated() => $pb.PbList<Expression>();
  @$core.pragma('dart2js:noInline')
  static Expression getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Expression>(create);
  static Expression? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get keyword => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<Period> get period => $_getList(2);
}

class Expressions extends $pb.GeneratedMessage {
  factory Expressions({
    $core.Iterable<Expression>? data,
  }) {
    final result = create();
    if (data != null) result.data.addAll(data);
    return result;
  }

  Expressions._();

  factory Expressions.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Expressions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Expressions',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pPM<Expression>(1, _omitFieldNames ? '' : 'data',
        subBuilder: Expression.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Expressions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Expressions copyWith(void Function(Expressions) updates) =>
      super.copyWith((message) => updates(message as Expressions))
          as Expressions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Expressions create() => Expressions._();
  @$core.override
  Expressions createEmptyInstance() => create();
  static $pb.PbList<Expressions> createRepeated() => $pb.PbList<Expressions>();
  @$core.pragma('dart2js:noInline')
  static Expressions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Expressions>(create);
  static Expressions? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Expression> get data => $_getList(0);
}

class InlinePlayerDanmakuSwitch extends $pb.GeneratedMessage {
  factory InlinePlayerDanmakuSwitch({
    $core.bool? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  InlinePlayerDanmakuSwitch._();

  factory InlinePlayerDanmakuSwitch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InlinePlayerDanmakuSwitch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InlinePlayerDanmakuSwitch',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InlinePlayerDanmakuSwitch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InlinePlayerDanmakuSwitch copyWith(
          void Function(InlinePlayerDanmakuSwitch) updates) =>
      super.copyWith((message) => updates(message as InlinePlayerDanmakuSwitch))
          as InlinePlayerDanmakuSwitch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InlinePlayerDanmakuSwitch create() => InlinePlayerDanmakuSwitch._();
  @$core.override
  InlinePlayerDanmakuSwitch createEmptyInstance() => create();
  static $pb.PbList<InlinePlayerDanmakuSwitch> createRepeated() =>
      $pb.PbList<InlinePlayerDanmakuSwitch>();
  @$core.pragma('dart2js:noInline')
  static InlinePlayerDanmakuSwitch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InlinePlayerDanmakuSwitch>(create);
  static InlinePlayerDanmakuSwitch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class Label extends $pb.GeneratedMessage {
  factory Label({
    $core.String? title,
    $core.Iterable<$core.String>? content,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (content != null) result.content.addAll(content);
    return result;
  }

  Label._();

  factory Label.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Label.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Label',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..pPS(2, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Label clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Label copyWith(void Function(Label) updates) =>
      super.copyWith((message) => updates(message as Label)) as Label;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Label create() => Label._();
  @$core.override
  Label createEmptyInstance() => create();
  static $pb.PbList<Label> createRepeated() => $pb.PbList<Label>();
  @$core.pragma('dart2js:noInline')
  static Label getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Label>(create);
  static Label? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get content => $_getList(1);
}

class LabelV2 extends $pb.GeneratedMessage {
  factory LabelV2({
    $core.String? title,
    $core.Iterable<$core.String>? content,
    $core.bool? exposureOnce,
    ExposureType? exposureType,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (content != null) result.content.addAll(content);
    if (exposureOnce != null) result.exposureOnce = exposureOnce;
    if (exposureType != null) result.exposureType = exposureType;
    return result;
  }

  LabelV2._();

  factory LabelV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LabelV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LabelV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..pPS(2, _omitFieldNames ? '' : 'content')
    ..aOB(3, _omitFieldNames ? '' : 'exposureOnce')
    ..aE<ExposureType>(4, _omitFieldNames ? '' : 'exposureType',
        enumValues: ExposureType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LabelV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LabelV2 copyWith(void Function(LabelV2) updates) =>
      super.copyWith((message) => updates(message as LabelV2)) as LabelV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LabelV2 create() => LabelV2._();
  @$core.override
  LabelV2 createEmptyInstance() => create();
  static $pb.PbList<LabelV2> createRepeated() => $pb.PbList<LabelV2>();
  @$core.pragma('dart2js:noInline')
  static LabelV2 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LabelV2>(create);
  static LabelV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get content => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get exposureOnce => $_getBF(2);
  @$pb.TagNumber(3)
  set exposureOnce($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExposureOnce() => $_has(2);
  @$pb.TagNumber(3)
  void clearExposureOnce() => $_clearField(3);

  @$pb.TagNumber(4)
  ExposureType get exposureType => $_getN(3);
  @$pb.TagNumber(4)
  set exposureType(ExposureType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasExposureType() => $_has(3);
  @$pb.TagNumber(4)
  void clearExposureType() => $_clearField(4);
}

class Period extends $pb.GeneratedMessage {
  factory Period({
    $fixnum.Int64? start,
    $fixnum.Int64? end,
  }) {
    final result = create();
    if (start != null) result.start = start;
    if (end != null) result.end = end;
    return result;
  }

  Period._();

  factory Period.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Period.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Period',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'start')
    ..aInt64(2, _omitFieldNames ? '' : 'end')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Period clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Period copyWith(void Function(Period) updates) =>
      super.copyWith((message) => updates(message as Period)) as Period;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Period create() => Period._();
  @$core.override
  Period createEmptyInstance() => create();
  static $pb.PbList<Period> createRepeated() => $pb.PbList<Period>();
  @$core.pragma('dart2js:noInline')
  static Period getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Period>(create);
  static Period? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get start => $_getI64(0);
  @$pb.TagNumber(1)
  set start($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get end => $_getI64(1);
  @$pb.TagNumber(2)
  set end($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnd() => $_clearField(2);
}

class PlayerDanmakuAiRecommendedLevel extends $pb.GeneratedMessage {
  factory PlayerDanmakuAiRecommendedLevel({
    $core.int? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuAiRecommendedLevel._();

  factory PlayerDanmakuAiRecommendedLevel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuAiRecommendedLevel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuAiRecommendedLevel',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuAiRecommendedLevel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuAiRecommendedLevel copyWith(
          void Function(PlayerDanmakuAiRecommendedLevel) updates) =>
      super.copyWith(
              (message) => updates(message as PlayerDanmakuAiRecommendedLevel))
          as PlayerDanmakuAiRecommendedLevel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuAiRecommendedLevel create() =>
      PlayerDanmakuAiRecommendedLevel._();
  @$core.override
  PlayerDanmakuAiRecommendedLevel createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuAiRecommendedLevel> createRepeated() =>
      $pb.PbList<PlayerDanmakuAiRecommendedLevel>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuAiRecommendedLevel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuAiRecommendedLevel>(
          create);
  static PlayerDanmakuAiRecommendedLevel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get value => $_getIZ(0);
  @$pb.TagNumber(1)
  set value($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuAiRecommendedLevelV2 extends $pb.GeneratedMessage {
  factory PlayerDanmakuAiRecommendedLevelV2({
    $core.int? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuAiRecommendedLevelV2._();

  factory PlayerDanmakuAiRecommendedLevelV2.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuAiRecommendedLevelV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuAiRecommendedLevelV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuAiRecommendedLevelV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuAiRecommendedLevelV2 copyWith(
          void Function(PlayerDanmakuAiRecommendedLevelV2) updates) =>
      super.copyWith((message) =>
              updates(message as PlayerDanmakuAiRecommendedLevelV2))
          as PlayerDanmakuAiRecommendedLevelV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuAiRecommendedLevelV2 create() =>
      PlayerDanmakuAiRecommendedLevelV2._();
  @$core.override
  PlayerDanmakuAiRecommendedLevelV2 createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuAiRecommendedLevelV2> createRepeated() =>
      $pb.PbList<PlayerDanmakuAiRecommendedLevelV2>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuAiRecommendedLevelV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuAiRecommendedLevelV2>(
          create);
  static PlayerDanmakuAiRecommendedLevelV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get value => $_getIZ(0);
  @$pb.TagNumber(1)
  set value($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuAiRecommendedSwitch extends $pb.GeneratedMessage {
  factory PlayerDanmakuAiRecommendedSwitch({
    $core.bool? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuAiRecommendedSwitch._();

  factory PlayerDanmakuAiRecommendedSwitch.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuAiRecommendedSwitch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuAiRecommendedSwitch',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuAiRecommendedSwitch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuAiRecommendedSwitch copyWith(
          void Function(PlayerDanmakuAiRecommendedSwitch) updates) =>
      super.copyWith(
              (message) => updates(message as PlayerDanmakuAiRecommendedSwitch))
          as PlayerDanmakuAiRecommendedSwitch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuAiRecommendedSwitch create() =>
      PlayerDanmakuAiRecommendedSwitch._();
  @$core.override
  PlayerDanmakuAiRecommendedSwitch createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuAiRecommendedSwitch> createRepeated() =>
      $pb.PbList<PlayerDanmakuAiRecommendedSwitch>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuAiRecommendedSwitch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuAiRecommendedSwitch>(
          create);
  static PlayerDanmakuAiRecommendedSwitch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuBlockbottom extends $pb.GeneratedMessage {
  factory PlayerDanmakuBlockbottom({
    $core.bool? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuBlockbottom._();

  factory PlayerDanmakuBlockbottom.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuBlockbottom.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuBlockbottom',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuBlockbottom clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuBlockbottom copyWith(
          void Function(PlayerDanmakuBlockbottom) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuBlockbottom))
          as PlayerDanmakuBlockbottom;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockbottom create() => PlayerDanmakuBlockbottom._();
  @$core.override
  PlayerDanmakuBlockbottom createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuBlockbottom> createRepeated() =>
      $pb.PbList<PlayerDanmakuBlockbottom>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockbottom getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuBlockbottom>(create);
  static PlayerDanmakuBlockbottom? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuBlockcolorful extends $pb.GeneratedMessage {
  factory PlayerDanmakuBlockcolorful({
    $core.bool? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuBlockcolorful._();

  factory PlayerDanmakuBlockcolorful.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuBlockcolorful.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuBlockcolorful',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuBlockcolorful clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuBlockcolorful copyWith(
          void Function(PlayerDanmakuBlockcolorful) updates) =>
      super.copyWith(
              (message) => updates(message as PlayerDanmakuBlockcolorful))
          as PlayerDanmakuBlockcolorful;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockcolorful create() => PlayerDanmakuBlockcolorful._();
  @$core.override
  PlayerDanmakuBlockcolorful createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuBlockcolorful> createRepeated() =>
      $pb.PbList<PlayerDanmakuBlockcolorful>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockcolorful getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuBlockcolorful>(create);
  static PlayerDanmakuBlockcolorful? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuBlockrepeat extends $pb.GeneratedMessage {
  factory PlayerDanmakuBlockrepeat({
    $core.bool? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuBlockrepeat._();

  factory PlayerDanmakuBlockrepeat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuBlockrepeat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuBlockrepeat',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuBlockrepeat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuBlockrepeat copyWith(
          void Function(PlayerDanmakuBlockrepeat) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuBlockrepeat))
          as PlayerDanmakuBlockrepeat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockrepeat create() => PlayerDanmakuBlockrepeat._();
  @$core.override
  PlayerDanmakuBlockrepeat createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuBlockrepeat> createRepeated() =>
      $pb.PbList<PlayerDanmakuBlockrepeat>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockrepeat getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuBlockrepeat>(create);
  static PlayerDanmakuBlockrepeat? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuBlockscroll extends $pb.GeneratedMessage {
  factory PlayerDanmakuBlockscroll({
    $core.bool? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuBlockscroll._();

  factory PlayerDanmakuBlockscroll.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuBlockscroll.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuBlockscroll',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuBlockscroll clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuBlockscroll copyWith(
          void Function(PlayerDanmakuBlockscroll) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuBlockscroll))
          as PlayerDanmakuBlockscroll;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockscroll create() => PlayerDanmakuBlockscroll._();
  @$core.override
  PlayerDanmakuBlockscroll createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuBlockscroll> createRepeated() =>
      $pb.PbList<PlayerDanmakuBlockscroll>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockscroll getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuBlockscroll>(create);
  static PlayerDanmakuBlockscroll? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuBlockspecial extends $pb.GeneratedMessage {
  factory PlayerDanmakuBlockspecial({
    $core.bool? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuBlockspecial._();

  factory PlayerDanmakuBlockspecial.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuBlockspecial.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuBlockspecial',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuBlockspecial clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuBlockspecial copyWith(
          void Function(PlayerDanmakuBlockspecial) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuBlockspecial))
          as PlayerDanmakuBlockspecial;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockspecial create() => PlayerDanmakuBlockspecial._();
  @$core.override
  PlayerDanmakuBlockspecial createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuBlockspecial> createRepeated() =>
      $pb.PbList<PlayerDanmakuBlockspecial>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlockspecial getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuBlockspecial>(create);
  static PlayerDanmakuBlockspecial? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuBlocktop extends $pb.GeneratedMessage {
  factory PlayerDanmakuBlocktop({
    $core.bool? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuBlocktop._();

  factory PlayerDanmakuBlocktop.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuBlocktop.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuBlocktop',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuBlocktop clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuBlocktop copyWith(
          void Function(PlayerDanmakuBlocktop) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuBlocktop))
          as PlayerDanmakuBlocktop;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlocktop create() => PlayerDanmakuBlocktop._();
  @$core.override
  PlayerDanmakuBlocktop createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuBlocktop> createRepeated() =>
      $pb.PbList<PlayerDanmakuBlocktop>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlocktop getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuBlocktop>(create);
  static PlayerDanmakuBlocktop? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuBlocktopBottom extends $pb.GeneratedMessage {
  factory PlayerDanmakuBlocktopBottom({
    $core.bool? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuBlocktopBottom._();

  factory PlayerDanmakuBlocktopBottom.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuBlocktopBottom.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuBlocktopBottom',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuBlocktopBottom clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuBlocktopBottom copyWith(
          void Function(PlayerDanmakuBlocktopBottom) updates) =>
      super.copyWith(
              (message) => updates(message as PlayerDanmakuBlocktopBottom))
          as PlayerDanmakuBlocktopBottom;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlocktopBottom create() =>
      PlayerDanmakuBlocktopBottom._();
  @$core.override
  PlayerDanmakuBlocktopBottom createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuBlocktopBottom> createRepeated() =>
      $pb.PbList<PlayerDanmakuBlocktopBottom>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuBlocktopBottom getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuBlocktopBottom>(create);
  static PlayerDanmakuBlocktopBottom? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuDensity extends $pb.GeneratedMessage {
  factory PlayerDanmakuDensity({
    $core.int? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuDensity._();

  factory PlayerDanmakuDensity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuDensity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuDensity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuDensity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuDensity copyWith(void Function(PlayerDanmakuDensity) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuDensity))
          as PlayerDanmakuDensity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuDensity create() => PlayerDanmakuDensity._();
  @$core.override
  PlayerDanmakuDensity createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuDensity> createRepeated() =>
      $pb.PbList<PlayerDanmakuDensity>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuDensity getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuDensity>(create);
  static PlayerDanmakuDensity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get value => $_getIZ(0);
  @$pb.TagNumber(1)
  set value($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuDomain extends $pb.GeneratedMessage {
  factory PlayerDanmakuDomain({
    $core.double? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuDomain._();

  factory PlayerDanmakuDomain.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuDomain.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuDomain',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'value', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuDomain clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuDomain copyWith(void Function(PlayerDanmakuDomain) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuDomain))
          as PlayerDanmakuDomain;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuDomain create() => PlayerDanmakuDomain._();
  @$core.override
  PlayerDanmakuDomain createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuDomain> createRepeated() =>
      $pb.PbList<PlayerDanmakuDomain>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuDomain getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuDomain>(create);
  static PlayerDanmakuDomain? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get value => $_getN(0);
  @$pb.TagNumber(1)
  set value($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuDomainV2 extends $pb.GeneratedMessage {
  factory PlayerDanmakuDomainV2({
    $core.int? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuDomainV2._();

  factory PlayerDanmakuDomainV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuDomainV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuDomainV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuDomainV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuDomainV2 copyWith(
          void Function(PlayerDanmakuDomainV2) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuDomainV2))
          as PlayerDanmakuDomainV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuDomainV2 create() => PlayerDanmakuDomainV2._();
  @$core.override
  PlayerDanmakuDomainV2 createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuDomainV2> createRepeated() =>
      $pb.PbList<PlayerDanmakuDomainV2>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuDomainV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuDomainV2>(create);
  static PlayerDanmakuDomainV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get value => $_getIZ(0);
  @$pb.TagNumber(1)
  set value($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuEnableHerdDm extends $pb.GeneratedMessage {
  factory PlayerDanmakuEnableHerdDm({
    $core.bool? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuEnableHerdDm._();

  factory PlayerDanmakuEnableHerdDm.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuEnableHerdDm.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuEnableHerdDm',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuEnableHerdDm clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuEnableHerdDm copyWith(
          void Function(PlayerDanmakuEnableHerdDm) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuEnableHerdDm))
          as PlayerDanmakuEnableHerdDm;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuEnableHerdDm create() => PlayerDanmakuEnableHerdDm._();
  @$core.override
  PlayerDanmakuEnableHerdDm createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuEnableHerdDm> createRepeated() =>
      $pb.PbList<PlayerDanmakuEnableHerdDm>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuEnableHerdDm getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuEnableHerdDm>(create);
  static PlayerDanmakuEnableHerdDm? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuEnableblocklist extends $pb.GeneratedMessage {
  factory PlayerDanmakuEnableblocklist({
    $core.bool? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuEnableblocklist._();

  factory PlayerDanmakuEnableblocklist.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuEnableblocklist.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuEnableblocklist',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuEnableblocklist clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuEnableblocklist copyWith(
          void Function(PlayerDanmakuEnableblocklist) updates) =>
      super.copyWith(
              (message) => updates(message as PlayerDanmakuEnableblocklist))
          as PlayerDanmakuEnableblocklist;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuEnableblocklist create() =>
      PlayerDanmakuEnableblocklist._();
  @$core.override
  PlayerDanmakuEnableblocklist createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuEnableblocklist> createRepeated() =>
      $pb.PbList<PlayerDanmakuEnableblocklist>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuEnableblocklist getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuEnableblocklist>(create);
  static PlayerDanmakuEnableblocklist? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuOpacity extends $pb.GeneratedMessage {
  factory PlayerDanmakuOpacity({
    $core.double? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuOpacity._();

  factory PlayerDanmakuOpacity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuOpacity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuOpacity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'value', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuOpacity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuOpacity copyWith(void Function(PlayerDanmakuOpacity) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuOpacity))
          as PlayerDanmakuOpacity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuOpacity create() => PlayerDanmakuOpacity._();
  @$core.override
  PlayerDanmakuOpacity createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuOpacity> createRepeated() =>
      $pb.PbList<PlayerDanmakuOpacity>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuOpacity getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuOpacity>(create);
  static PlayerDanmakuOpacity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get value => $_getN(0);
  @$pb.TagNumber(1)
  set value($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuPeopleProof extends $pb.GeneratedMessage {
  factory PlayerDanmakuPeopleProof({
    $core.bool? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuPeopleProof._();

  factory PlayerDanmakuPeopleProof.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuPeopleProof.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuPeopleProof',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuPeopleProof clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuPeopleProof copyWith(
          void Function(PlayerDanmakuPeopleProof) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuPeopleProof))
          as PlayerDanmakuPeopleProof;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuPeopleProof create() => PlayerDanmakuPeopleProof._();
  @$core.override
  PlayerDanmakuPeopleProof createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuPeopleProof> createRepeated() =>
      $pb.PbList<PlayerDanmakuPeopleProof>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuPeopleProof getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuPeopleProof>(create);
  static PlayerDanmakuPeopleProof? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuScalingfactor extends $pb.GeneratedMessage {
  factory PlayerDanmakuScalingfactor({
    $core.double? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuScalingfactor._();

  factory PlayerDanmakuScalingfactor.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuScalingfactor.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuScalingfactor',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'value', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuScalingfactor clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuScalingfactor copyWith(
          void Function(PlayerDanmakuScalingfactor) updates) =>
      super.copyWith(
              (message) => updates(message as PlayerDanmakuScalingfactor))
          as PlayerDanmakuScalingfactor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuScalingfactor create() => PlayerDanmakuScalingfactor._();
  @$core.override
  PlayerDanmakuScalingfactor createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuScalingfactor> createRepeated() =>
      $pb.PbList<PlayerDanmakuScalingfactor>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuScalingfactor getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuScalingfactor>(create);
  static PlayerDanmakuScalingfactor? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get value => $_getN(0);
  @$pb.TagNumber(1)
  set value($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuSeniorModeSwitch extends $pb.GeneratedMessage {
  factory PlayerDanmakuSeniorModeSwitch({
    $core.int? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuSeniorModeSwitch._();

  factory PlayerDanmakuSeniorModeSwitch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuSeniorModeSwitch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuSeniorModeSwitch',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuSeniorModeSwitch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuSeniorModeSwitch copyWith(
          void Function(PlayerDanmakuSeniorModeSwitch) updates) =>
      super.copyWith(
              (message) => updates(message as PlayerDanmakuSeniorModeSwitch))
          as PlayerDanmakuSeniorModeSwitch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuSeniorModeSwitch create() =>
      PlayerDanmakuSeniorModeSwitch._();
  @$core.override
  PlayerDanmakuSeniorModeSwitch createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuSeniorModeSwitch> createRepeated() =>
      $pb.PbList<PlayerDanmakuSeniorModeSwitch>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuSeniorModeSwitch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuSeniorModeSwitch>(create);
  static PlayerDanmakuSeniorModeSwitch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get value => $_getIZ(0);
  @$pb.TagNumber(1)
  set value($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuSpeed extends $pb.GeneratedMessage {
  factory PlayerDanmakuSpeed({
    $core.int? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuSpeed._();

  factory PlayerDanmakuSpeed.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuSpeed.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuSpeed',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuSpeed clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuSpeed copyWith(void Function(PlayerDanmakuSpeed) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuSpeed))
          as PlayerDanmakuSpeed;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuSpeed create() => PlayerDanmakuSpeed._();
  @$core.override
  PlayerDanmakuSpeed createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuSpeed> createRepeated() =>
      $pb.PbList<PlayerDanmakuSpeed>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuSpeed getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuSpeed>(create);
  static PlayerDanmakuSpeed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get value => $_getIZ(0);
  @$pb.TagNumber(1)
  set value($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuSubtitleProof extends $pb.GeneratedMessage {
  factory PlayerDanmakuSubtitleProof({
    $core.bool? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuSubtitleProof._();

  factory PlayerDanmakuSubtitleProof.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuSubtitleProof.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuSubtitleProof',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuSubtitleProof clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuSubtitleProof copyWith(
          void Function(PlayerDanmakuSubtitleProof) updates) =>
      super.copyWith(
              (message) => updates(message as PlayerDanmakuSubtitleProof))
          as PlayerDanmakuSubtitleProof;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuSubtitleProof create() => PlayerDanmakuSubtitleProof._();
  @$core.override
  PlayerDanmakuSubtitleProof createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuSubtitleProof> createRepeated() =>
      $pb.PbList<PlayerDanmakuSubtitleProof>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuSubtitleProof getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuSubtitleProof>(create);
  static PlayerDanmakuSubtitleProof? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuSwitch extends $pb.GeneratedMessage {
  factory PlayerDanmakuSwitch({
    $core.bool? value,
    $core.bool? canIgnore,
  }) {
    final result = create();
    if (value != null) result.value = value;
    if (canIgnore != null) result.canIgnore = canIgnore;
    return result;
  }

  PlayerDanmakuSwitch._();

  factory PlayerDanmakuSwitch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuSwitch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuSwitch',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..aOB(2, _omitFieldNames ? '' : 'canIgnore')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuSwitch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuSwitch copyWith(void Function(PlayerDanmakuSwitch) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuSwitch))
          as PlayerDanmakuSwitch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuSwitch create() => PlayerDanmakuSwitch._();
  @$core.override
  PlayerDanmakuSwitch createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuSwitch> createRepeated() =>
      $pb.PbList<PlayerDanmakuSwitch>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuSwitch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuSwitch>(create);
  static PlayerDanmakuSwitch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get canIgnore => $_getBF(1);
  @$pb.TagNumber(2)
  set canIgnore($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCanIgnore() => $_has(1);
  @$pb.TagNumber(2)
  void clearCanIgnore() => $_clearField(2);
}

class PlayerDanmakuSwitchSave extends $pb.GeneratedMessage {
  factory PlayerDanmakuSwitchSave({
    $core.bool? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuSwitchSave._();

  factory PlayerDanmakuSwitchSave.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuSwitchSave.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuSwitchSave',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuSwitchSave clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuSwitchSave copyWith(
          void Function(PlayerDanmakuSwitchSave) updates) =>
      super.copyWith((message) => updates(message as PlayerDanmakuSwitchSave))
          as PlayerDanmakuSwitchSave;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuSwitchSave create() => PlayerDanmakuSwitchSave._();
  @$core.override
  PlayerDanmakuSwitchSave createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuSwitchSave> createRepeated() =>
      $pb.PbList<PlayerDanmakuSwitchSave>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuSwitchSave getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuSwitchSave>(create);
  static PlayerDanmakuSwitchSave? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PlayerDanmakuUseDefaultConfig extends $pb.GeneratedMessage {
  factory PlayerDanmakuUseDefaultConfig({
    $core.bool? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  PlayerDanmakuUseDefaultConfig._();

  factory PlayerDanmakuUseDefaultConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerDanmakuUseDefaultConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerDanmakuUseDefaultConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuUseDefaultConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerDanmakuUseDefaultConfig copyWith(
          void Function(PlayerDanmakuUseDefaultConfig) updates) =>
      super.copyWith(
              (message) => updates(message as PlayerDanmakuUseDefaultConfig))
          as PlayerDanmakuUseDefaultConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuUseDefaultConfig create() =>
      PlayerDanmakuUseDefaultConfig._();
  @$core.override
  PlayerDanmakuUseDefaultConfig createEmptyInstance() => create();
  static $pb.PbList<PlayerDanmakuUseDefaultConfig> createRepeated() =>
      $pb.PbList<PlayerDanmakuUseDefaultConfig>();
  @$core.pragma('dart2js:noInline')
  static PlayerDanmakuUseDefaultConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerDanmakuUseDefaultConfig>(create);
  static PlayerDanmakuUseDefaultConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class PostPanel extends $pb.GeneratedMessage {
  factory PostPanel({
    $fixnum.Int64? start,
    $fixnum.Int64? end,
    $fixnum.Int64? priority,
    $fixnum.Int64? bizId,
    PostPanelBizType? bizType,
    ClickButton? clickButton,
    TextInput? textInput,
    CheckBox? checkBox,
    Toast? toast,
  }) {
    final result = create();
    if (start != null) result.start = start;
    if (end != null) result.end = end;
    if (priority != null) result.priority = priority;
    if (bizId != null) result.bizId = bizId;
    if (bizType != null) result.bizType = bizType;
    if (clickButton != null) result.clickButton = clickButton;
    if (textInput != null) result.textInput = textInput;
    if (checkBox != null) result.checkBox = checkBox;
    if (toast != null) result.toast = toast;
    return result;
  }

  PostPanel._();

  factory PostPanel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PostPanel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PostPanel',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'start')
    ..aInt64(2, _omitFieldNames ? '' : 'end')
    ..aInt64(3, _omitFieldNames ? '' : 'priority')
    ..aInt64(4, _omitFieldNames ? '' : 'bizId')
    ..aE<PostPanelBizType>(5, _omitFieldNames ? '' : 'bizType',
        enumValues: PostPanelBizType.values)
    ..aOM<ClickButton>(6, _omitFieldNames ? '' : 'clickButton',
        subBuilder: ClickButton.create)
    ..aOM<TextInput>(7, _omitFieldNames ? '' : 'textInput',
        subBuilder: TextInput.create)
    ..aOM<CheckBox>(8, _omitFieldNames ? '' : 'checkBox',
        subBuilder: CheckBox.create)
    ..aOM<Toast>(9, _omitFieldNames ? '' : 'toast', subBuilder: Toast.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostPanel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostPanel copyWith(void Function(PostPanel) updates) =>
      super.copyWith((message) => updates(message as PostPanel)) as PostPanel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PostPanel create() => PostPanel._();
  @$core.override
  PostPanel createEmptyInstance() => create();
  static $pb.PbList<PostPanel> createRepeated() => $pb.PbList<PostPanel>();
  @$core.pragma('dart2js:noInline')
  static PostPanel getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PostPanel>(create);
  static PostPanel? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get start => $_getI64(0);
  @$pb.TagNumber(1)
  set start($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get end => $_getI64(1);
  @$pb.TagNumber(2)
  set end($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnd() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get priority => $_getI64(2);
  @$pb.TagNumber(3)
  set priority($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPriority() => $_has(2);
  @$pb.TagNumber(3)
  void clearPriority() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get bizId => $_getI64(3);
  @$pb.TagNumber(4)
  set bizId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBizId() => $_has(3);
  @$pb.TagNumber(4)
  void clearBizId() => $_clearField(4);

  @$pb.TagNumber(5)
  PostPanelBizType get bizType => $_getN(4);
  @$pb.TagNumber(5)
  set bizType(PostPanelBizType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasBizType() => $_has(4);
  @$pb.TagNumber(5)
  void clearBizType() => $_clearField(5);

  @$pb.TagNumber(6)
  ClickButton get clickButton => $_getN(5);
  @$pb.TagNumber(6)
  set clickButton(ClickButton value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasClickButton() => $_has(5);
  @$pb.TagNumber(6)
  void clearClickButton() => $_clearField(6);
  @$pb.TagNumber(6)
  ClickButton ensureClickButton() => $_ensure(5);

  @$pb.TagNumber(7)
  TextInput get textInput => $_getN(6);
  @$pb.TagNumber(7)
  set textInput(TextInput value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTextInput() => $_has(6);
  @$pb.TagNumber(7)
  void clearTextInput() => $_clearField(7);
  @$pb.TagNumber(7)
  TextInput ensureTextInput() => $_ensure(6);

  @$pb.TagNumber(8)
  CheckBox get checkBox => $_getN(7);
  @$pb.TagNumber(8)
  set checkBox(CheckBox value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCheckBox() => $_has(7);
  @$pb.TagNumber(8)
  void clearCheckBox() => $_clearField(8);
  @$pb.TagNumber(8)
  CheckBox ensureCheckBox() => $_ensure(7);

  @$pb.TagNumber(9)
  Toast get toast => $_getN(8);
  @$pb.TagNumber(9)
  set toast(Toast value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasToast() => $_has(8);
  @$pb.TagNumber(9)
  void clearToast() => $_clearField(9);
  @$pb.TagNumber(9)
  Toast ensureToast() => $_ensure(8);
}

class PostPanelV2 extends $pb.GeneratedMessage {
  factory PostPanelV2({
    $fixnum.Int64? start,
    $fixnum.Int64? end,
    PostPanelBizType? bizType,
    ClickButtonV2? clickButton,
    TextInputV2? textInput,
    CheckBoxV2? checkBox,
    ToastV2? toast,
    BubbleV2? bubble,
    LabelV2? label,
    PostStatus? postStatus,
  }) {
    final result = create();
    if (start != null) result.start = start;
    if (end != null) result.end = end;
    if (bizType != null) result.bizType = bizType;
    if (clickButton != null) result.clickButton = clickButton;
    if (textInput != null) result.textInput = textInput;
    if (checkBox != null) result.checkBox = checkBox;
    if (toast != null) result.toast = toast;
    if (bubble != null) result.bubble = bubble;
    if (label != null) result.label = label;
    if (postStatus != null) result.postStatus = postStatus;
    return result;
  }

  PostPanelV2._();

  factory PostPanelV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PostPanelV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PostPanelV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'start')
    ..aInt64(2, _omitFieldNames ? '' : 'end')
    ..aE<PostPanelBizType>(3, _omitFieldNames ? '' : 'bizType',
        enumValues: PostPanelBizType.values)
    ..aOM<ClickButtonV2>(4, _omitFieldNames ? '' : 'clickButton',
        subBuilder: ClickButtonV2.create)
    ..aOM<TextInputV2>(5, _omitFieldNames ? '' : 'textInput',
        subBuilder: TextInputV2.create)
    ..aOM<CheckBoxV2>(6, _omitFieldNames ? '' : 'checkBox',
        subBuilder: CheckBoxV2.create)
    ..aOM<ToastV2>(7, _omitFieldNames ? '' : 'toast',
        subBuilder: ToastV2.create)
    ..aOM<BubbleV2>(8, _omitFieldNames ? '' : 'bubble',
        subBuilder: BubbleV2.create)
    ..aOM<LabelV2>(9, _omitFieldNames ? '' : 'label',
        subBuilder: LabelV2.create)
    ..aE<PostStatus>(10, _omitFieldNames ? '' : 'postStatus',
        enumValues: PostStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostPanelV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostPanelV2 copyWith(void Function(PostPanelV2) updates) =>
      super.copyWith((message) => updates(message as PostPanelV2))
          as PostPanelV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PostPanelV2 create() => PostPanelV2._();
  @$core.override
  PostPanelV2 createEmptyInstance() => create();
  static $pb.PbList<PostPanelV2> createRepeated() => $pb.PbList<PostPanelV2>();
  @$core.pragma('dart2js:noInline')
  static PostPanelV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PostPanelV2>(create);
  static PostPanelV2? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get start => $_getI64(0);
  @$pb.TagNumber(1)
  set start($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get end => $_getI64(1);
  @$pb.TagNumber(2)
  set end($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnd() => $_clearField(2);

  @$pb.TagNumber(3)
  PostPanelBizType get bizType => $_getN(2);
  @$pb.TagNumber(3)
  set bizType(PostPanelBizType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBizType() => $_has(2);
  @$pb.TagNumber(3)
  void clearBizType() => $_clearField(3);

  @$pb.TagNumber(4)
  ClickButtonV2 get clickButton => $_getN(3);
  @$pb.TagNumber(4)
  set clickButton(ClickButtonV2 value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasClickButton() => $_has(3);
  @$pb.TagNumber(4)
  void clearClickButton() => $_clearField(4);
  @$pb.TagNumber(4)
  ClickButtonV2 ensureClickButton() => $_ensure(3);

  @$pb.TagNumber(5)
  TextInputV2 get textInput => $_getN(4);
  @$pb.TagNumber(5)
  set textInput(TextInputV2 value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTextInput() => $_has(4);
  @$pb.TagNumber(5)
  void clearTextInput() => $_clearField(5);
  @$pb.TagNumber(5)
  TextInputV2 ensureTextInput() => $_ensure(4);

  @$pb.TagNumber(6)
  CheckBoxV2 get checkBox => $_getN(5);
  @$pb.TagNumber(6)
  set checkBox(CheckBoxV2 value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCheckBox() => $_has(5);
  @$pb.TagNumber(6)
  void clearCheckBox() => $_clearField(6);
  @$pb.TagNumber(6)
  CheckBoxV2 ensureCheckBox() => $_ensure(5);

  @$pb.TagNumber(7)
  ToastV2 get toast => $_getN(6);
  @$pb.TagNumber(7)
  set toast(ToastV2 value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasToast() => $_has(6);
  @$pb.TagNumber(7)
  void clearToast() => $_clearField(7);
  @$pb.TagNumber(7)
  ToastV2 ensureToast() => $_ensure(6);

  @$pb.TagNumber(8)
  BubbleV2 get bubble => $_getN(7);
  @$pb.TagNumber(8)
  set bubble(BubbleV2 value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasBubble() => $_has(7);
  @$pb.TagNumber(8)
  void clearBubble() => $_clearField(8);
  @$pb.TagNumber(8)
  BubbleV2 ensureBubble() => $_ensure(7);

  @$pb.TagNumber(9)
  LabelV2 get label => $_getN(8);
  @$pb.TagNumber(9)
  set label(LabelV2 value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasLabel() => $_has(8);
  @$pb.TagNumber(9)
  void clearLabel() => $_clearField(9);
  @$pb.TagNumber(9)
  LabelV2 ensureLabel() => $_ensure(8);

  @$pb.TagNumber(10)
  PostStatus get postStatus => $_getN(9);
  @$pb.TagNumber(10)
  set postStatus(PostStatus value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasPostStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearPostStatus() => $_clearField(10);
}

class QoeInfo extends $pb.GeneratedMessage {
  factory QoeInfo({
    $core.String? info,
  }) {
    final result = create();
    if (info != null) result.info = info;
    return result;
  }

  QoeInfo._();

  factory QoeInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QoeInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QoeInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'info')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QoeInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QoeInfo copyWith(void Function(QoeInfo) updates) =>
      super.copyWith((message) => updates(message as QoeInfo)) as QoeInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QoeInfo create() => QoeInfo._();
  @$core.override
  QoeInfo createEmptyInstance() => create();
  static $pb.PbList<QoeInfo> createRepeated() => $pb.PbList<QoeInfo>();
  @$core.pragma('dart2js:noInline')
  static QoeInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QoeInfo>(create);
  static QoeInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get info => $_getSZ(0);
  @$pb.TagNumber(1)
  set info($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearInfo() => $_clearField(1);
}

class ReportDuration extends $pb.GeneratedMessage {
  factory ReportDuration({
    $fixnum.Int64? startSecond,
    $fixnum.Int64? endSecond,
  }) {
    final result = create();
    if (startSecond != null) result.startSecond = startSecond;
    if (endSecond != null) result.endSecond = endSecond;
    return result;
  }

  ReportDuration._();

  factory ReportDuration.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReportDuration.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportDuration',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'startSecond')
    ..aInt64(2, _omitFieldNames ? '' : 'endSecond')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportDuration clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportDuration copyWith(void Function(ReportDuration) updates) =>
      super.copyWith((message) => updates(message as ReportDuration))
          as ReportDuration;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportDuration create() => ReportDuration._();
  @$core.override
  ReportDuration createEmptyInstance() => create();
  static $pb.PbList<ReportDuration> createRepeated() =>
      $pb.PbList<ReportDuration>();
  @$core.pragma('dart2js:noInline')
  static ReportDuration getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportDuration>(create);
  static ReportDuration? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get startSecond => $_getI64(0);
  @$pb.TagNumber(1)
  set startSecond($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStartSecond() => $_has(0);
  @$pb.TagNumber(1)
  void clearStartSecond() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get endSecond => $_getI64(1);
  @$pb.TagNumber(2)
  set endSecond($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEndSecond() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndSecond() => $_clearField(2);
}

class Response extends $pb.GeneratedMessage {
  factory Response({
    $core.int? code,
    $core.String? message,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    return result;
  }

  Response._();

  factory Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Response.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Response',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Response copyWith(void Function(Response) updates) =>
      super.copyWith((message) => updates(message as Response)) as Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Response create() => Response._();
  @$core.override
  Response createEmptyInstance() => create();
  static $pb.PbList<Response> createRepeated() => $pb.PbList<Response>();
  @$core.pragma('dart2js:noInline')
  static Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Response>(create);
  static Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class SubtitleItem extends $pb.GeneratedMessage {
  factory SubtitleItem({
    $fixnum.Int64? id,
    $core.String? idStr,
    $core.String? lan,
    $core.String? lanDoc,
    $core.String? subtitleUrl,
    UserInfo? author,
    SubtitleType? type,
    $core.String? lanDocBrief,
    SubtitleAiType? aiType,
    SubtitleAiStatus? aiStatus,
    SubtitleRole? role,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (idStr != null) result.idStr = idStr;
    if (lan != null) result.lan = lan;
    if (lanDoc != null) result.lanDoc = lanDoc;
    if (subtitleUrl != null) result.subtitleUrl = subtitleUrl;
    if (author != null) result.author = author;
    if (type != null) result.type = type;
    if (lanDocBrief != null) result.lanDocBrief = lanDocBrief;
    if (aiType != null) result.aiType = aiType;
    if (aiStatus != null) result.aiStatus = aiStatus;
    if (role != null) result.role = role;
    return result;
  }

  SubtitleItem._();

  factory SubtitleItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubtitleItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubtitleItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'idStr')
    ..aOS(3, _omitFieldNames ? '' : 'lan')
    ..aOS(4, _omitFieldNames ? '' : 'lanDoc')
    ..aOS(5, _omitFieldNames ? '' : 'subtitleUrl')
    ..aOM<UserInfo>(6, _omitFieldNames ? '' : 'author',
        subBuilder: UserInfo.create)
    ..aE<SubtitleType>(7, _omitFieldNames ? '' : 'type',
        enumValues: SubtitleType.values)
    ..aOS(8, _omitFieldNames ? '' : 'lanDocBrief')
    ..aE<SubtitleAiType>(9, _omitFieldNames ? '' : 'aiType',
        enumValues: SubtitleAiType.values)
    ..aE<SubtitleAiStatus>(10, _omitFieldNames ? '' : 'aiStatus',
        enumValues: SubtitleAiStatus.values)
    ..aE<SubtitleRole>(11, _omitFieldNames ? '' : 'role',
        enumValues: SubtitleRole.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubtitleItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubtitleItem copyWith(void Function(SubtitleItem) updates) =>
      super.copyWith((message) => updates(message as SubtitleItem))
          as SubtitleItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubtitleItem create() => SubtitleItem._();
  @$core.override
  SubtitleItem createEmptyInstance() => create();
  static $pb.PbList<SubtitleItem> createRepeated() =>
      $pb.PbList<SubtitleItem>();
  @$core.pragma('dart2js:noInline')
  static SubtitleItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubtitleItem>(create);
  static SubtitleItem? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get idStr => $_getSZ(1);
  @$pb.TagNumber(2)
  set idStr($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIdStr() => $_has(1);
  @$pb.TagNumber(2)
  void clearIdStr() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get lan => $_getSZ(2);
  @$pb.TagNumber(3)
  set lan($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLan() => $_has(2);
  @$pb.TagNumber(3)
  void clearLan() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get lanDoc => $_getSZ(3);
  @$pb.TagNumber(4)
  set lanDoc($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLanDoc() => $_has(3);
  @$pb.TagNumber(4)
  void clearLanDoc() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get subtitleUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set subtitleUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSubtitleUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearSubtitleUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  UserInfo get author => $_getN(5);
  @$pb.TagNumber(6)
  set author(UserInfo value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAuthor() => $_has(5);
  @$pb.TagNumber(6)
  void clearAuthor() => $_clearField(6);
  @$pb.TagNumber(6)
  UserInfo ensureAuthor() => $_ensure(5);

  @$pb.TagNumber(7)
  SubtitleType get type => $_getN(6);
  @$pb.TagNumber(7)
  set type(SubtitleType value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasType() => $_has(6);
  @$pb.TagNumber(7)
  void clearType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get lanDocBrief => $_getSZ(7);
  @$pb.TagNumber(8)
  set lanDocBrief($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLanDocBrief() => $_has(7);
  @$pb.TagNumber(8)
  void clearLanDocBrief() => $_clearField(8);

  @$pb.TagNumber(9)
  SubtitleAiType get aiType => $_getN(8);
  @$pb.TagNumber(9)
  set aiType(SubtitleAiType value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasAiType() => $_has(8);
  @$pb.TagNumber(9)
  void clearAiType() => $_clearField(9);

  @$pb.TagNumber(10)
  SubtitleAiStatus get aiStatus => $_getN(9);
  @$pb.TagNumber(10)
  set aiStatus(SubtitleAiStatus value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasAiStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearAiStatus() => $_clearField(10);

  @$pb.TagNumber(11)
  SubtitleRole get role => $_getN(10);
  @$pb.TagNumber(11)
  set role(SubtitleRole value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasRole() => $_has(10);
  @$pb.TagNumber(11)
  void clearRole() => $_clearField(11);
}

class TextInput extends $pb.GeneratedMessage {
  factory TextInput({
    $core.Iterable<$core.String>? portraitPlaceholder,
    $core.Iterable<$core.String>? landscapePlaceholder,
    RenderType? renderType,
    $core.bool? placeholderPost,
    $core.bool? show,
    $core.Iterable<Avatar>? avatar,
    PostStatus? postStatus,
    Label? label,
  }) {
    final result = create();
    if (portraitPlaceholder != null)
      result.portraitPlaceholder.addAll(portraitPlaceholder);
    if (landscapePlaceholder != null)
      result.landscapePlaceholder.addAll(landscapePlaceholder);
    if (renderType != null) result.renderType = renderType;
    if (placeholderPost != null) result.placeholderPost = placeholderPost;
    if (show != null) result.show = show;
    if (avatar != null) result.avatar.addAll(avatar);
    if (postStatus != null) result.postStatus = postStatus;
    if (label != null) result.label = label;
    return result;
  }

  TextInput._();

  factory TextInput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TextInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TextInput',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'portraitPlaceholder')
    ..pPS(2, _omitFieldNames ? '' : 'landscapePlaceholder')
    ..aE<RenderType>(3, _omitFieldNames ? '' : 'renderType',
        enumValues: RenderType.values)
    ..aOB(4, _omitFieldNames ? '' : 'placeholderPost')
    ..aOB(5, _omitFieldNames ? '' : 'show')
    ..pPM<Avatar>(6, _omitFieldNames ? '' : 'avatar', subBuilder: Avatar.create)
    ..aE<PostStatus>(7, _omitFieldNames ? '' : 'postStatus',
        enumValues: PostStatus.values)
    ..aOM<Label>(8, _omitFieldNames ? '' : 'label', subBuilder: Label.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextInput copyWith(void Function(TextInput) updates) =>
      super.copyWith((message) => updates(message as TextInput)) as TextInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TextInput create() => TextInput._();
  @$core.override
  TextInput createEmptyInstance() => create();
  static $pb.PbList<TextInput> createRepeated() => $pb.PbList<TextInput>();
  @$core.pragma('dart2js:noInline')
  static TextInput getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TextInput>(create);
  static TextInput? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get portraitPlaceholder => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get landscapePlaceholder => $_getList(1);

  @$pb.TagNumber(3)
  RenderType get renderType => $_getN(2);
  @$pb.TagNumber(3)
  set renderType(RenderType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRenderType() => $_has(2);
  @$pb.TagNumber(3)
  void clearRenderType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get placeholderPost => $_getBF(3);
  @$pb.TagNumber(4)
  set placeholderPost($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPlaceholderPost() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlaceholderPost() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get show => $_getBF(4);
  @$pb.TagNumber(5)
  set show($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasShow() => $_has(4);
  @$pb.TagNumber(5)
  void clearShow() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<Avatar> get avatar => $_getList(5);

  @$pb.TagNumber(7)
  PostStatus get postStatus => $_getN(6);
  @$pb.TagNumber(7)
  set postStatus(PostStatus value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPostStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearPostStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  Label get label => $_getN(7);
  @$pb.TagNumber(8)
  set label(Label value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasLabel() => $_has(7);
  @$pb.TagNumber(8)
  void clearLabel() => $_clearField(8);
  @$pb.TagNumber(8)
  Label ensureLabel() => $_ensure(7);
}

class TextInputV2 extends $pb.GeneratedMessage {
  factory TextInputV2({
    $core.Iterable<$core.String>? portraitPlaceholder,
    $core.Iterable<$core.String>? landscapePlaceholder,
    RenderType? renderType,
    $core.bool? placeholderPost,
    $core.Iterable<Avatar>? avatar,
    $core.int? textInputLimit,
  }) {
    final result = create();
    if (portraitPlaceholder != null)
      result.portraitPlaceholder.addAll(portraitPlaceholder);
    if (landscapePlaceholder != null)
      result.landscapePlaceholder.addAll(landscapePlaceholder);
    if (renderType != null) result.renderType = renderType;
    if (placeholderPost != null) result.placeholderPost = placeholderPost;
    if (avatar != null) result.avatar.addAll(avatar);
    if (textInputLimit != null) result.textInputLimit = textInputLimit;
    return result;
  }

  TextInputV2._();

  factory TextInputV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TextInputV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TextInputV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'portraitPlaceholder')
    ..pPS(2, _omitFieldNames ? '' : 'landscapePlaceholder')
    ..aE<RenderType>(3, _omitFieldNames ? '' : 'renderType',
        enumValues: RenderType.values)
    ..aOB(4, _omitFieldNames ? '' : 'placeholderPost')
    ..pPM<Avatar>(5, _omitFieldNames ? '' : 'avatar', subBuilder: Avatar.create)
    ..aI(6, _omitFieldNames ? '' : 'textInputLimit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextInputV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextInputV2 copyWith(void Function(TextInputV2) updates) =>
      super.copyWith((message) => updates(message as TextInputV2))
          as TextInputV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TextInputV2 create() => TextInputV2._();
  @$core.override
  TextInputV2 createEmptyInstance() => create();
  static $pb.PbList<TextInputV2> createRepeated() => $pb.PbList<TextInputV2>();
  @$core.pragma('dart2js:noInline')
  static TextInputV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TextInputV2>(create);
  static TextInputV2? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get portraitPlaceholder => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get landscapePlaceholder => $_getList(1);

  @$pb.TagNumber(3)
  RenderType get renderType => $_getN(2);
  @$pb.TagNumber(3)
  set renderType(RenderType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRenderType() => $_has(2);
  @$pb.TagNumber(3)
  void clearRenderType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get placeholderPost => $_getBF(3);
  @$pb.TagNumber(4)
  set placeholderPost($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPlaceholderPost() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlaceholderPost() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<Avatar> get avatar => $_getList(4);

  @$pb.TagNumber(6)
  $core.int get textInputLimit => $_getIZ(5);
  @$pb.TagNumber(6)
  set textInputLimit($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTextInputLimit() => $_has(5);
  @$pb.TagNumber(6)
  void clearTextInputLimit() => $_clearField(6);
}

class Toast extends $pb.GeneratedMessage {
  factory Toast({
    $core.String? text,
    $core.int? duration,
    $core.bool? show,
    Button? button,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (duration != null) result.duration = duration;
    if (show != null) result.show = show;
    if (button != null) result.button = button;
    return result;
  }

  Toast._();

  factory Toast.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Toast.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Toast',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aI(2, _omitFieldNames ? '' : 'duration')
    ..aOB(3, _omitFieldNames ? '' : 'show')
    ..aOM<Button>(4, _omitFieldNames ? '' : 'button', subBuilder: Button.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Toast clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Toast copyWith(void Function(Toast) updates) =>
      super.copyWith((message) => updates(message as Toast)) as Toast;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Toast create() => Toast._();
  @$core.override
  Toast createEmptyInstance() => create();
  static $pb.PbList<Toast> createRepeated() => $pb.PbList<Toast>();
  @$core.pragma('dart2js:noInline')
  static Toast getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Toast>(create);
  static Toast? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get duration => $_getIZ(1);
  @$pb.TagNumber(2)
  set duration($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDuration() => $_has(1);
  @$pb.TagNumber(2)
  void clearDuration() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get show => $_getBF(2);
  @$pb.TagNumber(3)
  set show($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasShow() => $_has(2);
  @$pb.TagNumber(3)
  void clearShow() => $_clearField(3);

  @$pb.TagNumber(4)
  Button get button => $_getN(3);
  @$pb.TagNumber(4)
  set button(Button value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasButton() => $_has(3);
  @$pb.TagNumber(4)
  void clearButton() => $_clearField(4);
  @$pb.TagNumber(4)
  Button ensureButton() => $_ensure(3);
}

class ToastButtonV2 extends $pb.GeneratedMessage {
  factory ToastButtonV2({
    $core.String? text,
    ToastFunctionType? action,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (action != null) result.action = action;
    return result;
  }

  ToastButtonV2._();

  factory ToastButtonV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToastButtonV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToastButtonV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aE<ToastFunctionType>(2, _omitFieldNames ? '' : 'action',
        enumValues: ToastFunctionType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToastButtonV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToastButtonV2 copyWith(void Function(ToastButtonV2) updates) =>
      super.copyWith((message) => updates(message as ToastButtonV2))
          as ToastButtonV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToastButtonV2 create() => ToastButtonV2._();
  @$core.override
  ToastButtonV2 createEmptyInstance() => create();
  static $pb.PbList<ToastButtonV2> createRepeated() =>
      $pb.PbList<ToastButtonV2>();
  @$core.pragma('dart2js:noInline')
  static ToastButtonV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToastButtonV2>(create);
  static ToastButtonV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  ToastFunctionType get action => $_getN(1);
  @$pb.TagNumber(2)
  set action(ToastFunctionType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => $_clearField(2);
}

class ToastV2 extends $pb.GeneratedMessage {
  factory ToastV2({
    $core.String? text,
    $core.int? duration,
    ToastButtonV2? toastButtonV2,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (duration != null) result.duration = duration;
    if (toastButtonV2 != null) result.toastButtonV2 = toastButtonV2;
    return result;
  }

  ToastV2._();

  factory ToastV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToastV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToastV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aI(2, _omitFieldNames ? '' : 'duration')
    ..aOM<ToastButtonV2>(3, _omitFieldNames ? '' : 'toastButtonV2',
        subBuilder: ToastButtonV2.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToastV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToastV2 copyWith(void Function(ToastV2) updates) =>
      super.copyWith((message) => updates(message as ToastV2)) as ToastV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToastV2 create() => ToastV2._();
  @$core.override
  ToastV2 createEmptyInstance() => create();
  static $pb.PbList<ToastV2> createRepeated() => $pb.PbList<ToastV2>();
  @$core.pragma('dart2js:noInline')
  static ToastV2 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ToastV2>(create);
  static ToastV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get duration => $_getIZ(1);
  @$pb.TagNumber(2)
  set duration($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDuration() => $_has(1);
  @$pb.TagNumber(2)
  void clearDuration() => $_clearField(2);

  @$pb.TagNumber(3)
  ToastButtonV2 get toastButtonV2 => $_getN(2);
  @$pb.TagNumber(3)
  set toastButtonV2(ToastButtonV2 value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasToastButtonV2() => $_has(2);
  @$pb.TagNumber(3)
  void clearToastButtonV2() => $_clearField(3);
  @$pb.TagNumber(3)
  ToastButtonV2 ensureToastButtonV2() => $_ensure(2);
}

class UserInfo extends $pb.GeneratedMessage {
  factory UserInfo({
    $fixnum.Int64? mid,
    $core.String? name,
    $core.String? sex,
    $core.String? face,
    $core.String? sign,
    $core.int? rank,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    if (name != null) result.name = name;
    if (sex != null) result.sex = sex;
    if (face != null) result.face = face;
    if (sign != null) result.sign = sign;
    if (rank != null) result.rank = rank;
    return result;
  }

  UserInfo._();

  factory UserInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'sex')
    ..aOS(4, _omitFieldNames ? '' : 'face')
    ..aOS(5, _omitFieldNames ? '' : 'sign')
    ..aI(6, _omitFieldNames ? '' : 'rank')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserInfo copyWith(void Function(UserInfo) updates) =>
      super.copyWith((message) => updates(message as UserInfo)) as UserInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserInfo create() => UserInfo._();
  @$core.override
  UserInfo createEmptyInstance() => create();
  static $pb.PbList<UserInfo> createRepeated() => $pb.PbList<UserInfo>();
  @$core.pragma('dart2js:noInline')
  static UserInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserInfo>(create);
  static UserInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get mid => $_getI64(0);
  @$pb.TagNumber(1)
  set mid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearMid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sex => $_getSZ(2);
  @$pb.TagNumber(3)
  set sex($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSex() => $_has(2);
  @$pb.TagNumber(3)
  void clearSex() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get face => $_getSZ(3);
  @$pb.TagNumber(4)
  set face($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFace() => $_has(3);
  @$pb.TagNumber(4)
  void clearFace() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sign => $_getSZ(4);
  @$pb.TagNumber(5)
  set sign($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSign() => $_has(4);
  @$pb.TagNumber(5)
  void clearSign() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get rank => $_getIZ(5);
  @$pb.TagNumber(6)
  set rank($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRank() => $_has(5);
  @$pb.TagNumber(6)
  void clearRank() => $_clearField(6);
}

class VideoMask extends $pb.GeneratedMessage {
  factory VideoMask({
    $fixnum.Int64? cid,
    $core.int? plat,
    $core.int? fps,
    $fixnum.Int64? time,
    $core.String? maskUrl,
  }) {
    final result = create();
    if (cid != null) result.cid = cid;
    if (plat != null) result.plat = plat;
    if (fps != null) result.fps = fps;
    if (time != null) result.time = time;
    if (maskUrl != null) result.maskUrl = maskUrl;
    return result;
  }

  VideoMask._();

  factory VideoMask.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VideoMask.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoMask',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'cid')
    ..aI(2, _omitFieldNames ? '' : 'plat')
    ..aI(3, _omitFieldNames ? '' : 'fps')
    ..aInt64(4, _omitFieldNames ? '' : 'time')
    ..aOS(5, _omitFieldNames ? '' : 'maskUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoMask clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoMask copyWith(void Function(VideoMask) updates) =>
      super.copyWith((message) => updates(message as VideoMask)) as VideoMask;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VideoMask create() => VideoMask._();
  @$core.override
  VideoMask createEmptyInstance() => create();
  static $pb.PbList<VideoMask> createRepeated() => $pb.PbList<VideoMask>();
  @$core.pragma('dart2js:noInline')
  static VideoMask getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoMask>(create);
  static VideoMask? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get cid => $_getI64(0);
  @$pb.TagNumber(1)
  set cid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get plat => $_getIZ(1);
  @$pb.TagNumber(2)
  set plat($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlat() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlat() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get fps => $_getIZ(2);
  @$pb.TagNumber(3)
  set fps($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFps() => $_has(2);
  @$pb.TagNumber(3)
  void clearFps() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get time => $_getI64(3);
  @$pb.TagNumber(4)
  set time($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearTime() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get maskUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set maskUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMaskUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaskUrl() => $_clearField(5);
}

class VideoSubtitle extends $pb.GeneratedMessage {
  factory VideoSubtitle({
    $core.String? lan,
    $core.String? lanDoc,
    $core.Iterable<SubtitleItem>? subtitles,
  }) {
    final result = create();
    if (lan != null) result.lan = lan;
    if (lanDoc != null) result.lanDoc = lanDoc;
    if (subtitles != null) result.subtitles.addAll(subtitles);
    return result;
  }

  VideoSubtitle._();

  factory VideoSubtitle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VideoSubtitle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoSubtitle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lan')
    ..aOS(2, _omitFieldNames ? '' : 'lanDoc')
    ..pPM<SubtitleItem>(3, _omitFieldNames ? '' : 'subtitles',
        subBuilder: SubtitleItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoSubtitle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoSubtitle copyWith(void Function(VideoSubtitle) updates) =>
      super.copyWith((message) => updates(message as VideoSubtitle))
          as VideoSubtitle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VideoSubtitle create() => VideoSubtitle._();
  @$core.override
  VideoSubtitle createEmptyInstance() => create();
  static $pb.PbList<VideoSubtitle> createRepeated() =>
      $pb.PbList<VideoSubtitle>();
  @$core.pragma('dart2js:noInline')
  static VideoSubtitle getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoSubtitle>(create);
  static VideoSubtitle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lan => $_getSZ(0);
  @$pb.TagNumber(1)
  set lan($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLan() => $_has(0);
  @$pb.TagNumber(1)
  void clearLan() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lanDoc => $_getSZ(1);
  @$pb.TagNumber(2)
  set lanDoc($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLanDoc() => $_has(1);
  @$pb.TagNumber(2)
  void clearLanDoc() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<SubtitleItem> get subtitles => $_getList(2);
}

class ViewHerdDmElem extends $pb.GeneratedMessage {
  factory ViewHerdDmElem({
    $core.String? herdMsg,
    $core.int? herdStartCnt,
    $core.int? herdEndCnt,
    $core.String? regexRule,
    $core.int? startProgress,
    $core.int? endProgress,
  }) {
    final result = create();
    if (herdMsg != null) result.herdMsg = herdMsg;
    if (herdStartCnt != null) result.herdStartCnt = herdStartCnt;
    if (herdEndCnt != null) result.herdEndCnt = herdEndCnt;
    if (regexRule != null) result.regexRule = regexRule;
    if (startProgress != null) result.startProgress = startProgress;
    if (endProgress != null) result.endProgress = endProgress;
    return result;
  }

  ViewHerdDmElem._();

  factory ViewHerdDmElem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ViewHerdDmElem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ViewHerdDmElem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.community.service.dm.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'herdMsg')
    ..aI(2, _omitFieldNames ? '' : 'herdStartCnt')
    ..aI(3, _omitFieldNames ? '' : 'herdEndCnt')
    ..aOS(4, _omitFieldNames ? '' : 'regexRule')
    ..aI(5, _omitFieldNames ? '' : 'startProgress')
    ..aI(6, _omitFieldNames ? '' : 'endProgress')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewHerdDmElem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewHerdDmElem copyWith(void Function(ViewHerdDmElem) updates) =>
      super.copyWith((message) => updates(message as ViewHerdDmElem))
          as ViewHerdDmElem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ViewHerdDmElem create() => ViewHerdDmElem._();
  @$core.override
  ViewHerdDmElem createEmptyInstance() => create();
  static $pb.PbList<ViewHerdDmElem> createRepeated() =>
      $pb.PbList<ViewHerdDmElem>();
  @$core.pragma('dart2js:noInline')
  static ViewHerdDmElem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ViewHerdDmElem>(create);
  static ViewHerdDmElem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get herdMsg => $_getSZ(0);
  @$pb.TagNumber(1)
  set herdMsg($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHerdMsg() => $_has(0);
  @$pb.TagNumber(1)
  void clearHerdMsg() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get herdStartCnt => $_getIZ(1);
  @$pb.TagNumber(2)
  set herdStartCnt($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHerdStartCnt() => $_has(1);
  @$pb.TagNumber(2)
  void clearHerdStartCnt() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get herdEndCnt => $_getIZ(2);
  @$pb.TagNumber(3)
  set herdEndCnt($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHerdEndCnt() => $_has(2);
  @$pb.TagNumber(3)
  void clearHerdEndCnt() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get regexRule => $_getSZ(3);
  @$pb.TagNumber(4)
  set regexRule($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRegexRule() => $_has(3);
  @$pb.TagNumber(4)
  void clearRegexRule() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get startProgress => $_getIZ(4);
  @$pb.TagNumber(5)
  set startProgress($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStartProgress() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartProgress() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get endProgress => $_getIZ(5);
  @$pb.TagNumber(6)
  set endProgress($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEndProgress() => $_has(5);
  @$pb.TagNumber(6)
  void clearEndProgress() => $_clearField(6);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
