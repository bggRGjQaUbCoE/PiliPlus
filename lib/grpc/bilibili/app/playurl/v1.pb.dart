// This is a generated file - do not edit.
//
// Generated from bilibili/app/playurl/v1.proto.

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

class AB extends $pb.GeneratedMessage {
  factory AB({
    Glance? glance,
    Group? group,
  }) {
    final result = create();
    if (glance != null) result.glance = glance;
    if (group != null) result.group = group;
    return result;
  }

  AB._();

  factory AB.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AB.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AB',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOM<Glance>(1, _omitFieldNames ? '' : 'glance', subBuilder: Glance.create)
    ..aE<Group>(2, _omitFieldNames ? '' : 'group', enumValues: Group.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AB clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AB copyWith(void Function(AB) updates) =>
      super.copyWith((message) => updates(message as AB)) as AB;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AB create() => AB._();
  @$core.override
  AB createEmptyInstance() => create();
  static $pb.PbList<AB> createRepeated() => $pb.PbList<AB>();
  @$core.pragma('dart2js:noInline')
  static AB getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AB>(create);
  static AB? _defaultInstance;

  @$pb.TagNumber(1)
  Glance get glance => $_getN(0);
  @$pb.TagNumber(1)
  set glance(Glance value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGlance() => $_has(0);
  @$pb.TagNumber(1)
  void clearGlance() => $_clearField(1);
  @$pb.TagNumber(1)
  Glance ensureGlance() => $_ensure(0);

  @$pb.TagNumber(2)
  Group get group => $_getN(1);
  @$pb.TagNumber(2)
  set group(Group value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasGroup() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroup() => $_clearField(2);
}

class ArcConf extends $pb.GeneratedMessage {
  factory ArcConf({
    $core.bool? isSupport,
    $core.bool? disabled,
    ExtraContent? extraContent,
    $core.Iterable<$fixnum.Int64>? unsupportScene,
  }) {
    final result = create();
    if (isSupport != null) result.isSupport = isSupport;
    if (disabled != null) result.disabled = disabled;
    if (extraContent != null) result.extraContent = extraContent;
    if (unsupportScene != null) result.unsupportScene.addAll(unsupportScene);
    return result;
  }

  ArcConf._();

  factory ArcConf.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ArcConf.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArcConf',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'isSupport')
    ..aOB(2, _omitFieldNames ? '' : 'disabled')
    ..aOM<ExtraContent>(3, _omitFieldNames ? '' : 'extraContent',
        subBuilder: ExtraContent.create)
    ..p<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'unsupportScene', $pb.PbFieldType.K6)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArcConf clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArcConf copyWith(void Function(ArcConf) updates) =>
      super.copyWith((message) => updates(message as ArcConf)) as ArcConf;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ArcConf create() => ArcConf._();
  @$core.override
  ArcConf createEmptyInstance() => create();
  static $pb.PbList<ArcConf> createRepeated() => $pb.PbList<ArcConf>();
  @$core.pragma('dart2js:noInline')
  static ArcConf getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ArcConf>(create);
  static ArcConf? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isSupport => $_getBF(0);
  @$pb.TagNumber(1)
  set isSupport($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsSupport() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsSupport() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get disabled => $_getBF(1);
  @$pb.TagNumber(2)
  set disabled($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisabled() => $_clearField(2);

  @$pb.TagNumber(3)
  ExtraContent get extraContent => $_getN(2);
  @$pb.TagNumber(3)
  set extraContent(ExtraContent value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasExtraContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearExtraContent() => $_clearField(3);
  @$pb.TagNumber(3)
  ExtraContent ensureExtraContent() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<$fixnum.Int64> get unsupportScene => $_getList(3);
}

class ButtonInfo extends $pb.GeneratedMessage {
  factory ButtonInfo({
    $core.String? text,
    $core.String? textColor,
    $core.String? textColorNight,
    $core.String? bgColor,
    $core.String? bgColorNight,
    $core.String? link,
    ButtonAction? actionType,
    Report? report,
    $core.String? frameColor,
    $core.String? icon,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (textColor != null) result.textColor = textColor;
    if (textColorNight != null) result.textColorNight = textColorNight;
    if (bgColor != null) result.bgColor = bgColor;
    if (bgColorNight != null) result.bgColorNight = bgColorNight;
    if (link != null) result.link = link;
    if (actionType != null) result.actionType = actionType;
    if (report != null) result.report = report;
    if (frameColor != null) result.frameColor = frameColor;
    if (icon != null) result.icon = icon;
    return result;
  }

  ButtonInfo._();

  factory ButtonInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ButtonInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ButtonInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'textColor')
    ..aOS(3, _omitFieldNames ? '' : 'textColorNight')
    ..aOS(4, _omitFieldNames ? '' : 'bgColor')
    ..aOS(5, _omitFieldNames ? '' : 'bgColorNight')
    ..aOS(6, _omitFieldNames ? '' : 'link')
    ..aE<ButtonAction>(7, _omitFieldNames ? '' : 'actionType',
        enumValues: ButtonAction.values)
    ..aOM<Report>(8, _omitFieldNames ? '' : 'report', subBuilder: Report.create)
    ..aOS(9, _omitFieldNames ? '' : 'frameColor')
    ..aOS(10, _omitFieldNames ? '' : 'icon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ButtonInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ButtonInfo copyWith(void Function(ButtonInfo) updates) =>
      super.copyWith((message) => updates(message as ButtonInfo)) as ButtonInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ButtonInfo create() => ButtonInfo._();
  @$core.override
  ButtonInfo createEmptyInstance() => create();
  static $pb.PbList<ButtonInfo> createRepeated() => $pb.PbList<ButtonInfo>();
  @$core.pragma('dart2js:noInline')
  static ButtonInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ButtonInfo>(create);
  static ButtonInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get textColor => $_getSZ(1);
  @$pb.TagNumber(2)
  set textColor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTextColor() => $_has(1);
  @$pb.TagNumber(2)
  void clearTextColor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get textColorNight => $_getSZ(2);
  @$pb.TagNumber(3)
  set textColorNight($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTextColorNight() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextColorNight() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get bgColor => $_getSZ(3);
  @$pb.TagNumber(4)
  set bgColor($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBgColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearBgColor() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get bgColorNight => $_getSZ(4);
  @$pb.TagNumber(5)
  set bgColorNight($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBgColorNight() => $_has(4);
  @$pb.TagNumber(5)
  void clearBgColorNight() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get link => $_getSZ(5);
  @$pb.TagNumber(6)
  set link($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLink() => $_has(5);
  @$pb.TagNumber(6)
  void clearLink() => $_clearField(6);

  @$pb.TagNumber(7)
  ButtonAction get actionType => $_getN(6);
  @$pb.TagNumber(7)
  set actionType(ButtonAction value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasActionType() => $_has(6);
  @$pb.TagNumber(7)
  void clearActionType() => $_clearField(7);

  @$pb.TagNumber(8)
  Report get report => $_getN(7);
  @$pb.TagNumber(8)
  set report(Report value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasReport() => $_has(7);
  @$pb.TagNumber(8)
  void clearReport() => $_clearField(8);
  @$pb.TagNumber(8)
  Report ensureReport() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get frameColor => $_getSZ(8);
  @$pb.TagNumber(9)
  set frameColor($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFrameColor() => $_has(8);
  @$pb.TagNumber(9)
  void clearFrameColor() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get icon => $_getSZ(9);
  @$pb.TagNumber(10)
  set icon($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIcon() => $_has(9);
  @$pb.TagNumber(10)
  void clearIcon() => $_clearField(10);
}

class ButtonStyle extends $pb.GeneratedMessage {
  factory ButtonStyle({
    $core.String? text,
    $core.String? textColor,
    $core.String? bgColor,
    $core.String? jumpLink,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (textColor != null) result.textColor = textColor;
    if (bgColor != null) result.bgColor = bgColor;
    if (jumpLink != null) result.jumpLink = jumpLink;
    return result;
  }

  ButtonStyle._();

  factory ButtonStyle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ButtonStyle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ButtonStyle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'textColor')
    ..aOS(3, _omitFieldNames ? '' : 'bgColor')
    ..aOS(4, _omitFieldNames ? '' : 'jumpLink')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ButtonStyle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ButtonStyle copyWith(void Function(ButtonStyle) updates) =>
      super.copyWith((message) => updates(message as ButtonStyle))
          as ButtonStyle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ButtonStyle create() => ButtonStyle._();
  @$core.override
  ButtonStyle createEmptyInstance() => create();
  static $pb.PbList<ButtonStyle> createRepeated() => $pb.PbList<ButtonStyle>();
  @$core.pragma('dart2js:noInline')
  static ButtonStyle getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ButtonStyle>(create);
  static ButtonStyle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get textColor => $_getSZ(1);
  @$pb.TagNumber(2)
  set textColor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTextColor() => $_has(1);
  @$pb.TagNumber(2)
  void clearTextColor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get bgColor => $_getSZ(2);
  @$pb.TagNumber(3)
  set bgColor($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBgColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearBgColor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get jumpLink => $_getSZ(3);
  @$pb.TagNumber(4)
  set jumpLink($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasJumpLink() => $_has(3);
  @$pb.TagNumber(4)
  void clearJumpLink() => $_clearField(4);
}

class Chronos extends $pb.GeneratedMessage {
  factory Chronos({
    $core.String? md5,
    $core.String? file,
  }) {
    final result = create();
    if (md5 != null) result.md5 = md5;
    if (file != null) result.file = file;
    return result;
  }

  Chronos._();

  factory Chronos.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chronos.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Chronos',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'md5')
    ..aOS(2, _omitFieldNames ? '' : 'file')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chronos clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chronos copyWith(void Function(Chronos) updates) =>
      super.copyWith((message) => updates(message as Chronos)) as Chronos;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chronos create() => Chronos._();
  @$core.override
  Chronos createEmptyInstance() => create();
  static $pb.PbList<Chronos> createRepeated() => $pb.PbList<Chronos>();
  @$core.pragma('dart2js:noInline')
  static Chronos getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chronos>(create);
  static Chronos? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get md5 => $_getSZ(0);
  @$pb.TagNumber(1)
  set md5($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMd5() => $_has(0);
  @$pb.TagNumber(1)
  void clearMd5() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get file => $_getSZ(1);
  @$pb.TagNumber(2)
  set file($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFile() => $_has(1);
  @$pb.TagNumber(2)
  void clearFile() => $_clearField(2);
}

class CloudConf extends $pb.GeneratedMessage {
  factory CloudConf({
    $core.bool? show,
    ConfType? confType,
    FieldValue? fieldValue,
    ConfValue? confValue,
  }) {
    final result = create();
    if (show != null) result.show = show;
    if (confType != null) result.confType = confType;
    if (fieldValue != null) result.fieldValue = fieldValue;
    if (confValue != null) result.confValue = confValue;
    return result;
  }

  CloudConf._();

  factory CloudConf.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloudConf.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloudConf',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'show')
    ..aE<ConfType>(2, _omitFieldNames ? '' : 'confType',
        enumValues: ConfType.values)
    ..aOM<FieldValue>(3, _omitFieldNames ? '' : 'fieldValue',
        subBuilder: FieldValue.create)
    ..aOM<ConfValue>(4, _omitFieldNames ? '' : 'confValue',
        subBuilder: ConfValue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudConf clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloudConf copyWith(void Function(CloudConf) updates) =>
      super.copyWith((message) => updates(message as CloudConf)) as CloudConf;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloudConf create() => CloudConf._();
  @$core.override
  CloudConf createEmptyInstance() => create();
  static $pb.PbList<CloudConf> createRepeated() => $pb.PbList<CloudConf>();
  @$core.pragma('dart2js:noInline')
  static CloudConf getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CloudConf>(create);
  static CloudConf? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get show => $_getBF(0);
  @$pb.TagNumber(1)
  set show($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShow() => $_has(0);
  @$pb.TagNumber(1)
  void clearShow() => $_clearField(1);

  @$pb.TagNumber(2)
  ConfType get confType => $_getN(1);
  @$pb.TagNumber(2)
  set confType(ConfType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasConfType() => $_has(1);
  @$pb.TagNumber(2)
  void clearConfType() => $_clearField(2);

  @$pb.TagNumber(3)
  FieldValue get fieldValue => $_getN(2);
  @$pb.TagNumber(3)
  set fieldValue(FieldValue value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFieldValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearFieldValue() => $_clearField(3);
  @$pb.TagNumber(3)
  FieldValue ensureFieldValue() => $_ensure(2);

  @$pb.TagNumber(4)
  ConfValue get confValue => $_getN(3);
  @$pb.TagNumber(4)
  set confValue(ConfValue value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasConfValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearConfValue() => $_clearField(4);
  @$pb.TagNumber(4)
  ConfValue ensureConfValue() => $_ensure(3);
}

class ComprehensiveToast extends $pb.GeneratedMessage {
  factory ComprehensiveToast({
    ToastType? type,
    ButtonInfo? button,
    $core.String? icon,
    TextInfo? toastText,
    Report? report,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (button != null) result.button = button;
    if (icon != null) result.icon = icon;
    if (toastText != null) result.toastText = toastText;
    if (report != null) result.report = report;
    return result;
  }

  ComprehensiveToast._();

  factory ComprehensiveToast.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ComprehensiveToast.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ComprehensiveToast',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aE<ToastType>(1, _omitFieldNames ? '' : 'type',
        enumValues: ToastType.values)
    ..aOM<ButtonInfo>(2, _omitFieldNames ? '' : 'button',
        subBuilder: ButtonInfo.create)
    ..aOS(3, _omitFieldNames ? '' : 'icon')
    ..aOM<TextInfo>(4, _omitFieldNames ? '' : 'toastText',
        subBuilder: TextInfo.create)
    ..aOM<Report>(5, _omitFieldNames ? '' : 'report', subBuilder: Report.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComprehensiveToast clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComprehensiveToast copyWith(void Function(ComprehensiveToast) updates) =>
      super.copyWith((message) => updates(message as ComprehensiveToast))
          as ComprehensiveToast;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComprehensiveToast create() => ComprehensiveToast._();
  @$core.override
  ComprehensiveToast createEmptyInstance() => create();
  static $pb.PbList<ComprehensiveToast> createRepeated() =>
      $pb.PbList<ComprehensiveToast>();
  @$core.pragma('dart2js:noInline')
  static ComprehensiveToast getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ComprehensiveToast>(create);
  static ComprehensiveToast? _defaultInstance;

  @$pb.TagNumber(1)
  ToastType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(ToastType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  ButtonInfo get button => $_getN(1);
  @$pb.TagNumber(2)
  set button(ButtonInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasButton() => $_has(1);
  @$pb.TagNumber(2)
  void clearButton() => $_clearField(2);
  @$pb.TagNumber(2)
  ButtonInfo ensureButton() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get icon => $_getSZ(2);
  @$pb.TagNumber(3)
  set icon($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearIcon() => $_clearField(3);

  @$pb.TagNumber(4)
  TextInfo get toastText => $_getN(3);
  @$pb.TagNumber(4)
  set toastText(TextInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasToastText() => $_has(3);
  @$pb.TagNumber(4)
  void clearToastText() => $_clearField(4);
  @$pb.TagNumber(4)
  TextInfo ensureToastText() => $_ensure(3);

  @$pb.TagNumber(5)
  Report get report => $_getN(4);
  @$pb.TagNumber(5)
  set report(Report value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasReport() => $_has(4);
  @$pb.TagNumber(5)
  void clearReport() => $_clearField(5);
  @$pb.TagNumber(5)
  Report ensureReport() => $_ensure(4);
}

enum ConfValue_Value { switchVal, selectedVal, notSet }

class ConfValue extends $pb.GeneratedMessage {
  factory ConfValue({
    $core.bool? switchVal,
    $fixnum.Int64? selectedVal,
  }) {
    final result = create();
    if (switchVal != null) result.switchVal = switchVal;
    if (selectedVal != null) result.selectedVal = selectedVal;
    return result;
  }

  ConfValue._();

  factory ConfValue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfValue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ConfValue_Value> _ConfValue_ValueByTag = {
    1: ConfValue_Value.switchVal,
    2: ConfValue_Value.selectedVal,
    0: ConfValue_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfValue',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOB(1, _omitFieldNames ? '' : 'switchVal')
    ..aInt64(2, _omitFieldNames ? '' : 'selectedVal')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfValue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfValue copyWith(void Function(ConfValue) updates) =>
      super.copyWith((message) => updates(message as ConfValue)) as ConfValue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfValue create() => ConfValue._();
  @$core.override
  ConfValue createEmptyInstance() => create();
  static $pb.PbList<ConfValue> createRepeated() => $pb.PbList<ConfValue>();
  @$core.pragma('dart2js:noInline')
  static ConfValue getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConfValue>(create);
  static ConfValue? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  ConfValue_Value whichValue() => _ConfValue_ValueByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearValue() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.bool get switchVal => $_getBF(0);
  @$pb.TagNumber(1)
  set switchVal($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSwitchVal() => $_has(0);
  @$pb.TagNumber(1)
  void clearSwitchVal() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get selectedVal => $_getI64(1);
  @$pb.TagNumber(2)
  set selectedVal($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSelectedVal() => $_has(1);
  @$pb.TagNumber(2)
  void clearSelectedVal() => $_clearField(2);
}

class DashItem extends $pb.GeneratedMessage {
  factory DashItem({
    $core.int? id,
    $core.String? baseUrl,
    $core.Iterable<$core.String>? backupUrl,
    $core.int? bandwidth,
    $core.int? codecid,
    $core.String? md5,
    $fixnum.Int64? size,
    $core.String? frameRate,
    $core.String? widevinePssh,
    $core.String? bilidrmUri,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (baseUrl != null) result.baseUrl = baseUrl;
    if (backupUrl != null) result.backupUrl.addAll(backupUrl);
    if (bandwidth != null) result.bandwidth = bandwidth;
    if (codecid != null) result.codecid = codecid;
    if (md5 != null) result.md5 = md5;
    if (size != null) result.size = size;
    if (frameRate != null) result.frameRate = frameRate;
    if (widevinePssh != null) result.widevinePssh = widevinePssh;
    if (bilidrmUri != null) result.bilidrmUri = bilidrmUri;
    return result;
  }

  DashItem._();

  factory DashItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DashItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DashItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'baseUrl')
    ..pPS(3, _omitFieldNames ? '' : 'backupUrl')
    ..aI(4, _omitFieldNames ? '' : 'bandwidth')
    ..aI(5, _omitFieldNames ? '' : 'codecid')
    ..aOS(6, _omitFieldNames ? '' : 'md5')
    ..aInt64(7, _omitFieldNames ? '' : 'size')
    ..aOS(8, _omitFieldNames ? '' : 'frameRate')
    ..aOS(9, _omitFieldNames ? '' : 'widevinePssh')
    ..aOS(10, _omitFieldNames ? '' : 'bilidrmUri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DashItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DashItem copyWith(void Function(DashItem) updates) =>
      super.copyWith((message) => updates(message as DashItem)) as DashItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DashItem create() => DashItem._();
  @$core.override
  DashItem createEmptyInstance() => create();
  static $pb.PbList<DashItem> createRepeated() => $pb.PbList<DashItem>();
  @$core.pragma('dart2js:noInline')
  static DashItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DashItem>(create);
  static DashItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get baseUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set baseUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBaseUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get backupUrl => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get bandwidth => $_getIZ(3);
  @$pb.TagNumber(4)
  set bandwidth($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBandwidth() => $_has(3);
  @$pb.TagNumber(4)
  void clearBandwidth() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get codecid => $_getIZ(4);
  @$pb.TagNumber(5)
  set codecid($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCodecid() => $_has(4);
  @$pb.TagNumber(5)
  void clearCodecid() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get md5 => $_getSZ(5);
  @$pb.TagNumber(6)
  set md5($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMd5() => $_has(5);
  @$pb.TagNumber(6)
  void clearMd5() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get size => $_getI64(6);
  @$pb.TagNumber(7)
  set size($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSize() => $_has(6);
  @$pb.TagNumber(7)
  void clearSize() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get frameRate => $_getSZ(7);
  @$pb.TagNumber(8)
  set frameRate($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFrameRate() => $_has(7);
  @$pb.TagNumber(8)
  void clearFrameRate() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get widevinePssh => $_getSZ(8);
  @$pb.TagNumber(9)
  set widevinePssh($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasWidevinePssh() => $_has(8);
  @$pb.TagNumber(9)
  void clearWidevinePssh() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get bilidrmUri => $_getSZ(9);
  @$pb.TagNumber(10)
  set bilidrmUri($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasBilidrmUri() => $_has(9);
  @$pb.TagNumber(10)
  void clearBilidrmUri() => $_clearField(10);
}

class DashVideo extends $pb.GeneratedMessage {
  factory DashVideo({
    $core.String? baseUrl,
    $core.Iterable<$core.String>? backupUrl,
    $core.int? bandwidth,
    $core.int? codecid,
    $core.String? md5,
    $fixnum.Int64? size,
    $core.int? audioId,
    $core.bool? noRexcode,
    $core.String? frameRate,
    $core.int? width,
    $core.int? height,
    $core.String? widevinePssh,
    $core.String? bilidrmUri,
  }) {
    final result = create();
    if (baseUrl != null) result.baseUrl = baseUrl;
    if (backupUrl != null) result.backupUrl.addAll(backupUrl);
    if (bandwidth != null) result.bandwidth = bandwidth;
    if (codecid != null) result.codecid = codecid;
    if (md5 != null) result.md5 = md5;
    if (size != null) result.size = size;
    if (audioId != null) result.audioId = audioId;
    if (noRexcode != null) result.noRexcode = noRexcode;
    if (frameRate != null) result.frameRate = frameRate;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (widevinePssh != null) result.widevinePssh = widevinePssh;
    if (bilidrmUri != null) result.bilidrmUri = bilidrmUri;
    return result;
  }

  DashVideo._();

  factory DashVideo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DashVideo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DashVideo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'baseUrl')
    ..pPS(2, _omitFieldNames ? '' : 'backupUrl')
    ..aI(3, _omitFieldNames ? '' : 'bandwidth')
    ..aI(4, _omitFieldNames ? '' : 'codecid')
    ..aOS(5, _omitFieldNames ? '' : 'md5')
    ..aInt64(6, _omitFieldNames ? '' : 'size')
    ..aI(7, _omitFieldNames ? '' : 'audioId')
    ..aOB(8, _omitFieldNames ? '' : 'noRexcode')
    ..aOS(9, _omitFieldNames ? '' : 'frameRate')
    ..aI(10, _omitFieldNames ? '' : 'width')
    ..aI(11, _omitFieldNames ? '' : 'height')
    ..aOS(12, _omitFieldNames ? '' : 'widevinePssh')
    ..aOS(13, _omitFieldNames ? '' : 'bilidrmUri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DashVideo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DashVideo copyWith(void Function(DashVideo) updates) =>
      super.copyWith((message) => updates(message as DashVideo)) as DashVideo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DashVideo create() => DashVideo._();
  @$core.override
  DashVideo createEmptyInstance() => create();
  static $pb.PbList<DashVideo> createRepeated() => $pb.PbList<DashVideo>();
  @$core.pragma('dart2js:noInline')
  static DashVideo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DashVideo>(create);
  static DashVideo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get baseUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set baseUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get backupUrl => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get bandwidth => $_getIZ(2);
  @$pb.TagNumber(3)
  set bandwidth($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBandwidth() => $_has(2);
  @$pb.TagNumber(3)
  void clearBandwidth() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get codecid => $_getIZ(3);
  @$pb.TagNumber(4)
  set codecid($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCodecid() => $_has(3);
  @$pb.TagNumber(4)
  void clearCodecid() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get md5 => $_getSZ(4);
  @$pb.TagNumber(5)
  set md5($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMd5() => $_has(4);
  @$pb.TagNumber(5)
  void clearMd5() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get size => $_getI64(5);
  @$pb.TagNumber(6)
  set size($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearSize() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get audioId => $_getIZ(6);
  @$pb.TagNumber(7)
  set audioId($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAudioId() => $_has(6);
  @$pb.TagNumber(7)
  void clearAudioId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get noRexcode => $_getBF(7);
  @$pb.TagNumber(8)
  set noRexcode($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasNoRexcode() => $_has(7);
  @$pb.TagNumber(8)
  void clearNoRexcode() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get frameRate => $_getSZ(8);
  @$pb.TagNumber(9)
  set frameRate($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFrameRate() => $_has(8);
  @$pb.TagNumber(9)
  void clearFrameRate() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get width => $_getIZ(9);
  @$pb.TagNumber(10)
  set width($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasWidth() => $_has(9);
  @$pb.TagNumber(10)
  void clearWidth() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get height => $_getIZ(10);
  @$pb.TagNumber(11)
  set height($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasHeight() => $_has(10);
  @$pb.TagNumber(11)
  void clearHeight() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get widevinePssh => $_getSZ(11);
  @$pb.TagNumber(12)
  set widevinePssh($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasWidevinePssh() => $_has(11);
  @$pb.TagNumber(12)
  void clearWidevinePssh() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get bilidrmUri => $_getSZ(12);
  @$pb.TagNumber(13)
  set bilidrmUri($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasBilidrmUri() => $_has(12);
  @$pb.TagNumber(13)
  void clearBilidrmUri() => $_clearField(13);
}

class Dialog extends $pb.GeneratedMessage {
  factory Dialog({
    GuideStyle? styleType,
    Report? report,
    TextInfo? title,
    TextInfo? subtitle,
    $core.Iterable<ButtonInfo>? button,
  }) {
    final result = create();
    if (styleType != null) result.styleType = styleType;
    if (report != null) result.report = report;
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    if (button != null) result.button.addAll(button);
    return result;
  }

  Dialog._();

  factory Dialog.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Dialog.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Dialog',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aE<GuideStyle>(1, _omitFieldNames ? '' : 'styleType',
        enumValues: GuideStyle.values)
    ..aOM<Report>(2, _omitFieldNames ? '' : 'report', subBuilder: Report.create)
    ..aOM<TextInfo>(3, _omitFieldNames ? '' : 'title',
        subBuilder: TextInfo.create)
    ..aOM<TextInfo>(4, _omitFieldNames ? '' : 'subtitle',
        subBuilder: TextInfo.create)
    ..pPM<ButtonInfo>(5, _omitFieldNames ? '' : 'button',
        subBuilder: ButtonInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Dialog clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Dialog copyWith(void Function(Dialog) updates) =>
      super.copyWith((message) => updates(message as Dialog)) as Dialog;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Dialog create() => Dialog._();
  @$core.override
  Dialog createEmptyInstance() => create();
  static $pb.PbList<Dialog> createRepeated() => $pb.PbList<Dialog>();
  @$core.pragma('dart2js:noInline')
  static Dialog getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Dialog>(create);
  static Dialog? _defaultInstance;

  @$pb.TagNumber(1)
  GuideStyle get styleType => $_getN(0);
  @$pb.TagNumber(1)
  set styleType(GuideStyle value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStyleType() => $_has(0);
  @$pb.TagNumber(1)
  void clearStyleType() => $_clearField(1);

  @$pb.TagNumber(2)
  Report get report => $_getN(1);
  @$pb.TagNumber(2)
  set report(Report value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasReport() => $_has(1);
  @$pb.TagNumber(2)
  void clearReport() => $_clearField(2);
  @$pb.TagNumber(2)
  Report ensureReport() => $_ensure(1);

  @$pb.TagNumber(3)
  TextInfo get title => $_getN(2);
  @$pb.TagNumber(3)
  set title(TextInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);
  @$pb.TagNumber(3)
  TextInfo ensureTitle() => $_ensure(2);

  @$pb.TagNumber(4)
  TextInfo get subtitle => $_getN(3);
  @$pb.TagNumber(4)
  set subtitle(TextInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSubtitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubtitle() => $_clearField(4);
  @$pb.TagNumber(4)
  TextInfo ensureSubtitle() => $_ensure(3);

  @$pb.TagNumber(5)
  $pb.PbList<ButtonInfo> get button => $_getList(4);
}

class DolbyItem extends $pb.GeneratedMessage {
  factory DolbyItem({
    DolbyItem_Type? type,
    $core.Iterable<DashItem>? audio,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (audio != null) result.audio.addAll(audio);
    return result;
  }

  DolbyItem._();

  factory DolbyItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DolbyItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DolbyItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aE<DolbyItem_Type>(1, _omitFieldNames ? '' : 'type',
        enumValues: DolbyItem_Type.values)
    ..pPM<DashItem>(2, _omitFieldNames ? '' : 'audio',
        subBuilder: DashItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DolbyItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DolbyItem copyWith(void Function(DolbyItem) updates) =>
      super.copyWith((message) => updates(message as DolbyItem)) as DolbyItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DolbyItem create() => DolbyItem._();
  @$core.override
  DolbyItem createEmptyInstance() => create();
  static $pb.PbList<DolbyItem> createRepeated() => $pb.PbList<DolbyItem>();
  @$core.pragma('dart2js:noInline')
  static DolbyItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DolbyItem>(create);
  static DolbyItem? _defaultInstance;

  @$pb.TagNumber(1)
  DolbyItem_Type get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(DolbyItem_Type value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<DashItem> get audio => $_getList(1);
}

class Event extends $pb.GeneratedMessage {
  factory Event({
    Shake? shake,
  }) {
    final result = create();
    if (shake != null) result.shake = shake;
    return result;
  }

  Event._();

  factory Event.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Event.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Event',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOM<Shake>(1, _omitFieldNames ? '' : 'shake', subBuilder: Shake.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Event clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Event copyWith(void Function(Event) updates) =>
      super.copyWith((message) => updates(message as Event)) as Event;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Event create() => Event._();
  @$core.override
  Event createEmptyInstance() => create();
  static $pb.PbList<Event> createRepeated() => $pb.PbList<Event>();
  @$core.pragma('dart2js:noInline')
  static Event getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Event>(create);
  static Event? _defaultInstance;

  @$pb.TagNumber(1)
  Shake get shake => $_getN(0);
  @$pb.TagNumber(1)
  set shake(Shake value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasShake() => $_has(0);
  @$pb.TagNumber(1)
  void clearShake() => $_clearField(1);
  @$pb.TagNumber(1)
  Shake ensureShake() => $_ensure(0);
}

class ExtraContent extends $pb.GeneratedMessage {
  factory ExtraContent({
    $core.String? disabledReason,
    $fixnum.Int64? disabledCode,
  }) {
    final result = create();
    if (disabledReason != null) result.disabledReason = disabledReason;
    if (disabledCode != null) result.disabledCode = disabledCode;
    return result;
  }

  ExtraContent._();

  factory ExtraContent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExtraContent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExtraContent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'disabledReason')
    ..aInt64(2, _omitFieldNames ? '' : 'disabledCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtraContent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtraContent copyWith(void Function(ExtraContent) updates) =>
      super.copyWith((message) => updates(message as ExtraContent))
          as ExtraContent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExtraContent create() => ExtraContent._();
  @$core.override
  ExtraContent createEmptyInstance() => create();
  static $pb.PbList<ExtraContent> createRepeated() =>
      $pb.PbList<ExtraContent>();
  @$core.pragma('dart2js:noInline')
  static ExtraContent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExtraContent>(create);
  static ExtraContent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get disabledReason => $_getSZ(0);
  @$pb.TagNumber(1)
  set disabledReason($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDisabledReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearDisabledReason() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get disabledCode => $_getI64(1);
  @$pb.TagNumber(2)
  set disabledCode($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisabledCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisabledCode() => $_clearField(2);
}

enum FieldValue_Value { switch_1, notSet }

class FieldValue extends $pb.GeneratedMessage {
  factory FieldValue({
    $core.bool? switch_1,
  }) {
    final result = create();
    if (switch_1 != null) result.switch_1 = switch_1;
    return result;
  }

  FieldValue._();

  factory FieldValue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FieldValue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, FieldValue_Value> _FieldValue_ValueByTag = {
    1: FieldValue_Value.switch_1,
    0: FieldValue_Value.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FieldValue',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..oo(0, [1])
    ..aOB(1, _omitFieldNames ? '' : 'switch')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldValue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldValue copyWith(void Function(FieldValue) updates) =>
      super.copyWith((message) => updates(message as FieldValue)) as FieldValue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FieldValue create() => FieldValue._();
  @$core.override
  FieldValue createEmptyInstance() => create();
  static $pb.PbList<FieldValue> createRepeated() => $pb.PbList<FieldValue>();
  @$core.pragma('dart2js:noInline')
  static FieldValue getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FieldValue>(create);
  static FieldValue? _defaultInstance;

  @$pb.TagNumber(1)
  FieldValue_Value whichValue() => _FieldValue_ValueByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  void clearValue() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.bool get switch_1 => $_getBF(0);
  @$pb.TagNumber(1)
  set switch_1($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSwitch_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearSwitch_1() => $_clearField(1);
}

class FormatDescription extends $pb.GeneratedMessage {
  factory FormatDescription({
    $core.int? quality,
    $core.String? format,
    $core.String? description,
    $core.String? newDescription,
    $core.String? displayDesc,
    $core.String? superscript,
  }) {
    final result = create();
    if (quality != null) result.quality = quality;
    if (format != null) result.format = format;
    if (description != null) result.description = description;
    if (newDescription != null) result.newDescription = newDescription;
    if (displayDesc != null) result.displayDesc = displayDesc;
    if (superscript != null) result.superscript = superscript;
    return result;
  }

  FormatDescription._();

  factory FormatDescription.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FormatDescription.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FormatDescription',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'quality')
    ..aOS(2, _omitFieldNames ? '' : 'format')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOS(4, _omitFieldNames ? '' : 'newDescription')
    ..aOS(5, _omitFieldNames ? '' : 'displayDesc')
    ..aOS(6, _omitFieldNames ? '' : 'superscript')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FormatDescription clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FormatDescription copyWith(void Function(FormatDescription) updates) =>
      super.copyWith((message) => updates(message as FormatDescription))
          as FormatDescription;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FormatDescription create() => FormatDescription._();
  @$core.override
  FormatDescription createEmptyInstance() => create();
  static $pb.PbList<FormatDescription> createRepeated() =>
      $pb.PbList<FormatDescription>();
  @$core.pragma('dart2js:noInline')
  static FormatDescription getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FormatDescription>(create);
  static FormatDescription? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get quality => $_getIZ(0);
  @$pb.TagNumber(1)
  set quality($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuality() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuality() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get format => $_getSZ(1);
  @$pb.TagNumber(2)
  set format($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFormat() => $_has(1);
  @$pb.TagNumber(2)
  void clearFormat() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get newDescription => $_getSZ(3);
  @$pb.TagNumber(4)
  set newDescription($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNewDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearNewDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get displayDesc => $_getSZ(4);
  @$pb.TagNumber(5)
  set displayDesc($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDisplayDesc() => $_has(4);
  @$pb.TagNumber(5)
  void clearDisplayDesc() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get superscript => $_getSZ(5);
  @$pb.TagNumber(6)
  set superscript($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSuperscript() => $_has(5);
  @$pb.TagNumber(6)
  void clearSuperscript() => $_clearField(6);
}

class Glance extends $pb.GeneratedMessage {
  factory Glance({
    $core.bool? canWatch,
    $fixnum.Int64? times,
    $fixnum.Int64? duration,
  }) {
    final result = create();
    if (canWatch != null) result.canWatch = canWatch;
    if (times != null) result.times = times;
    if (duration != null) result.duration = duration;
    return result;
  }

  Glance._();

  factory Glance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Glance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Glance',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'canWatch')
    ..aInt64(2, _omitFieldNames ? '' : 'times')
    ..aInt64(3, _omitFieldNames ? '' : 'duration')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Glance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Glance copyWith(void Function(Glance) updates) =>
      super.copyWith((message) => updates(message as Glance)) as Glance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Glance create() => Glance._();
  @$core.override
  Glance createEmptyInstance() => create();
  static $pb.PbList<Glance> createRepeated() => $pb.PbList<Glance>();
  @$core.pragma('dart2js:noInline')
  static Glance getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Glance>(create);
  static Glance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get canWatch => $_getBF(0);
  @$pb.TagNumber(1)
  set canWatch($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCanWatch() => $_has(0);
  @$pb.TagNumber(1)
  void clearCanWatch() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get times => $_getI64(1);
  @$pb.TagNumber(2)
  set times($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimes() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimes() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get duration => $_getI64(2);
  @$pb.TagNumber(3)
  set duration($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDuration() => $_has(2);
  @$pb.TagNumber(3)
  void clearDuration() => $_clearField(3);
}

class LossLessItem extends $pb.GeneratedMessage {
  factory LossLessItem({
    $core.bool? isLosslessAudio,
    DashItem? audio,
    $core.bool? needVip,
  }) {
    final result = create();
    if (isLosslessAudio != null) result.isLosslessAudio = isLosslessAudio;
    if (audio != null) result.audio = audio;
    if (needVip != null) result.needVip = needVip;
    return result;
  }

  LossLessItem._();

  factory LossLessItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LossLessItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LossLessItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'isLosslessAudio')
    ..aOM<DashItem>(2, _omitFieldNames ? '' : 'audio',
        subBuilder: DashItem.create)
    ..aOB(3, _omitFieldNames ? '' : 'needVip')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LossLessItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LossLessItem copyWith(void Function(LossLessItem) updates) =>
      super.copyWith((message) => updates(message as LossLessItem))
          as LossLessItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LossLessItem create() => LossLessItem._();
  @$core.override
  LossLessItem createEmptyInstance() => create();
  static $pb.PbList<LossLessItem> createRepeated() =>
      $pb.PbList<LossLessItem>();
  @$core.pragma('dart2js:noInline')
  static LossLessItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LossLessItem>(create);
  static LossLessItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isLosslessAudio => $_getBF(0);
  @$pb.TagNumber(1)
  set isLosslessAudio($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsLosslessAudio() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsLosslessAudio() => $_clearField(1);

  @$pb.TagNumber(2)
  DashItem get audio => $_getN(1);
  @$pb.TagNumber(2)
  set audio(DashItem value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAudio() => $_has(1);
  @$pb.TagNumber(2)
  void clearAudio() => $_clearField(2);
  @$pb.TagNumber(2)
  DashItem ensureAudio() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get needVip => $_getBF(2);
  @$pb.TagNumber(3)
  set needVip($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNeedVip() => $_has(2);
  @$pb.TagNumber(3)
  void clearNeedVip() => $_clearField(3);
}

class MultiDashVideo extends $pb.GeneratedMessage {
  factory MultiDashVideo({
    $core.Iterable<DashVideo>? dashVideos,
  }) {
    final result = create();
    if (dashVideos != null) result.dashVideos.addAll(dashVideos);
    return result;
  }

  MultiDashVideo._();

  factory MultiDashVideo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MultiDashVideo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MultiDashVideo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..pPM<DashVideo>(1, _omitFieldNames ? '' : 'dashVideos',
        subBuilder: DashVideo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiDashVideo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiDashVideo copyWith(void Function(MultiDashVideo) updates) =>
      super.copyWith((message) => updates(message as MultiDashVideo))
          as MultiDashVideo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MultiDashVideo create() => MultiDashVideo._();
  @$core.override
  MultiDashVideo createEmptyInstance() => create();
  static $pb.PbList<MultiDashVideo> createRepeated() =>
      $pb.PbList<MultiDashVideo>();
  @$core.pragma('dart2js:noInline')
  static MultiDashVideo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MultiDashVideo>(create);
  static MultiDashVideo? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DashVideo> get dashVideos => $_getList(0);
}

class PlayAbilityConf extends $pb.GeneratedMessage {
  factory PlayAbilityConf({
    CloudConf? backgroundPlayConf,
    CloudConf? flipConf,
    CloudConf? castConf,
    CloudConf? feedbackConf,
    CloudConf? subtitleConf,
    CloudConf? playbackRateConf,
    CloudConf? timeUpConf,
    CloudConf? playbackModeConf,
    CloudConf? scaleModeConf,
    CloudConf? likeConf,
    CloudConf? dislikeConf,
    CloudConf? coinConf,
    CloudConf? elecConf,
    CloudConf? shareConf,
    CloudConf? screenShotConf,
    CloudConf? lockScreenConf,
    CloudConf? recommendConf,
    CloudConf? playbackSpeedConf,
    CloudConf? definitionConf,
    CloudConf? selectionsConf,
    CloudConf? nextConf,
    CloudConf? editDmConf,
    CloudConf? smallWindowConf,
    CloudConf? shakeConf,
    CloudConf? outerDmConf,
    CloudConf? innerDmConf,
    CloudConf? panoramaConf,
    CloudConf? dolbyConf,
    CloudConf? colorFilterConf,
    CloudConf? lossLessConf,
  }) {
    final result = create();
    if (backgroundPlayConf != null)
      result.backgroundPlayConf = backgroundPlayConf;
    if (flipConf != null) result.flipConf = flipConf;
    if (castConf != null) result.castConf = castConf;
    if (feedbackConf != null) result.feedbackConf = feedbackConf;
    if (subtitleConf != null) result.subtitleConf = subtitleConf;
    if (playbackRateConf != null) result.playbackRateConf = playbackRateConf;
    if (timeUpConf != null) result.timeUpConf = timeUpConf;
    if (playbackModeConf != null) result.playbackModeConf = playbackModeConf;
    if (scaleModeConf != null) result.scaleModeConf = scaleModeConf;
    if (likeConf != null) result.likeConf = likeConf;
    if (dislikeConf != null) result.dislikeConf = dislikeConf;
    if (coinConf != null) result.coinConf = coinConf;
    if (elecConf != null) result.elecConf = elecConf;
    if (shareConf != null) result.shareConf = shareConf;
    if (screenShotConf != null) result.screenShotConf = screenShotConf;
    if (lockScreenConf != null) result.lockScreenConf = lockScreenConf;
    if (recommendConf != null) result.recommendConf = recommendConf;
    if (playbackSpeedConf != null) result.playbackSpeedConf = playbackSpeedConf;
    if (definitionConf != null) result.definitionConf = definitionConf;
    if (selectionsConf != null) result.selectionsConf = selectionsConf;
    if (nextConf != null) result.nextConf = nextConf;
    if (editDmConf != null) result.editDmConf = editDmConf;
    if (smallWindowConf != null) result.smallWindowConf = smallWindowConf;
    if (shakeConf != null) result.shakeConf = shakeConf;
    if (outerDmConf != null) result.outerDmConf = outerDmConf;
    if (innerDmConf != null) result.innerDmConf = innerDmConf;
    if (panoramaConf != null) result.panoramaConf = panoramaConf;
    if (dolbyConf != null) result.dolbyConf = dolbyConf;
    if (colorFilterConf != null) result.colorFilterConf = colorFilterConf;
    if (lossLessConf != null) result.lossLessConf = lossLessConf;
    return result;
  }

  PlayAbilityConf._();

  factory PlayAbilityConf.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayAbilityConf.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayAbilityConf',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOM<CloudConf>(1, _omitFieldNames ? '' : 'backgroundPlayConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(2, _omitFieldNames ? '' : 'flipConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(3, _omitFieldNames ? '' : 'castConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(4, _omitFieldNames ? '' : 'feedbackConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(5, _omitFieldNames ? '' : 'subtitleConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(6, _omitFieldNames ? '' : 'playbackRateConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(7, _omitFieldNames ? '' : 'timeUpConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(8, _omitFieldNames ? '' : 'playbackModeConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(9, _omitFieldNames ? '' : 'scaleModeConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(10, _omitFieldNames ? '' : 'likeConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(11, _omitFieldNames ? '' : 'dislikeConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(12, _omitFieldNames ? '' : 'coinConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(13, _omitFieldNames ? '' : 'elecConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(14, _omitFieldNames ? '' : 'shareConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(15, _omitFieldNames ? '' : 'screenShotConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(16, _omitFieldNames ? '' : 'lockScreenConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(17, _omitFieldNames ? '' : 'recommendConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(18, _omitFieldNames ? '' : 'playbackSpeedConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(19, _omitFieldNames ? '' : 'definitionConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(20, _omitFieldNames ? '' : 'selectionsConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(21, _omitFieldNames ? '' : 'nextConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(22, _omitFieldNames ? '' : 'editDmConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(23, _omitFieldNames ? '' : 'smallWindowConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(24, _omitFieldNames ? '' : 'shakeConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(25, _omitFieldNames ? '' : 'outerDmConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(26, _omitFieldNames ? '' : 'innerDmConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(27, _omitFieldNames ? '' : 'panoramaConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(28, _omitFieldNames ? '' : 'dolbyConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(29, _omitFieldNames ? '' : 'colorFilterConf',
        subBuilder: CloudConf.create)
    ..aOM<CloudConf>(30, _omitFieldNames ? '' : 'lossLessConf',
        subBuilder: CloudConf.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayAbilityConf clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayAbilityConf copyWith(void Function(PlayAbilityConf) updates) =>
      super.copyWith((message) => updates(message as PlayAbilityConf))
          as PlayAbilityConf;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayAbilityConf create() => PlayAbilityConf._();
  @$core.override
  PlayAbilityConf createEmptyInstance() => create();
  static $pb.PbList<PlayAbilityConf> createRepeated() =>
      $pb.PbList<PlayAbilityConf>();
  @$core.pragma('dart2js:noInline')
  static PlayAbilityConf getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayAbilityConf>(create);
  static PlayAbilityConf? _defaultInstance;

  @$pb.TagNumber(1)
  CloudConf get backgroundPlayConf => $_getN(0);
  @$pb.TagNumber(1)
  set backgroundPlayConf(CloudConf value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBackgroundPlayConf() => $_has(0);
  @$pb.TagNumber(1)
  void clearBackgroundPlayConf() => $_clearField(1);
  @$pb.TagNumber(1)
  CloudConf ensureBackgroundPlayConf() => $_ensure(0);

  @$pb.TagNumber(2)
  CloudConf get flipConf => $_getN(1);
  @$pb.TagNumber(2)
  set flipConf(CloudConf value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFlipConf() => $_has(1);
  @$pb.TagNumber(2)
  void clearFlipConf() => $_clearField(2);
  @$pb.TagNumber(2)
  CloudConf ensureFlipConf() => $_ensure(1);

  @$pb.TagNumber(3)
  CloudConf get castConf => $_getN(2);
  @$pb.TagNumber(3)
  set castConf(CloudConf value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCastConf() => $_has(2);
  @$pb.TagNumber(3)
  void clearCastConf() => $_clearField(3);
  @$pb.TagNumber(3)
  CloudConf ensureCastConf() => $_ensure(2);

  @$pb.TagNumber(4)
  CloudConf get feedbackConf => $_getN(3);
  @$pb.TagNumber(4)
  set feedbackConf(CloudConf value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFeedbackConf() => $_has(3);
  @$pb.TagNumber(4)
  void clearFeedbackConf() => $_clearField(4);
  @$pb.TagNumber(4)
  CloudConf ensureFeedbackConf() => $_ensure(3);

  @$pb.TagNumber(5)
  CloudConf get subtitleConf => $_getN(4);
  @$pb.TagNumber(5)
  set subtitleConf(CloudConf value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSubtitleConf() => $_has(4);
  @$pb.TagNumber(5)
  void clearSubtitleConf() => $_clearField(5);
  @$pb.TagNumber(5)
  CloudConf ensureSubtitleConf() => $_ensure(4);

  @$pb.TagNumber(6)
  CloudConf get playbackRateConf => $_getN(5);
  @$pb.TagNumber(6)
  set playbackRateConf(CloudConf value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPlaybackRateConf() => $_has(5);
  @$pb.TagNumber(6)
  void clearPlaybackRateConf() => $_clearField(6);
  @$pb.TagNumber(6)
  CloudConf ensurePlaybackRateConf() => $_ensure(5);

  @$pb.TagNumber(7)
  CloudConf get timeUpConf => $_getN(6);
  @$pb.TagNumber(7)
  set timeUpConf(CloudConf value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTimeUpConf() => $_has(6);
  @$pb.TagNumber(7)
  void clearTimeUpConf() => $_clearField(7);
  @$pb.TagNumber(7)
  CloudConf ensureTimeUpConf() => $_ensure(6);

  @$pb.TagNumber(8)
  CloudConf get playbackModeConf => $_getN(7);
  @$pb.TagNumber(8)
  set playbackModeConf(CloudConf value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPlaybackModeConf() => $_has(7);
  @$pb.TagNumber(8)
  void clearPlaybackModeConf() => $_clearField(8);
  @$pb.TagNumber(8)
  CloudConf ensurePlaybackModeConf() => $_ensure(7);

  @$pb.TagNumber(9)
  CloudConf get scaleModeConf => $_getN(8);
  @$pb.TagNumber(9)
  set scaleModeConf(CloudConf value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasScaleModeConf() => $_has(8);
  @$pb.TagNumber(9)
  void clearScaleModeConf() => $_clearField(9);
  @$pb.TagNumber(9)
  CloudConf ensureScaleModeConf() => $_ensure(8);

  @$pb.TagNumber(10)
  CloudConf get likeConf => $_getN(9);
  @$pb.TagNumber(10)
  set likeConf(CloudConf value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasLikeConf() => $_has(9);
  @$pb.TagNumber(10)
  void clearLikeConf() => $_clearField(10);
  @$pb.TagNumber(10)
  CloudConf ensureLikeConf() => $_ensure(9);

  @$pb.TagNumber(11)
  CloudConf get dislikeConf => $_getN(10);
  @$pb.TagNumber(11)
  set dislikeConf(CloudConf value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasDislikeConf() => $_has(10);
  @$pb.TagNumber(11)
  void clearDislikeConf() => $_clearField(11);
  @$pb.TagNumber(11)
  CloudConf ensureDislikeConf() => $_ensure(10);

  @$pb.TagNumber(12)
  CloudConf get coinConf => $_getN(11);
  @$pb.TagNumber(12)
  set coinConf(CloudConf value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCoinConf() => $_has(11);
  @$pb.TagNumber(12)
  void clearCoinConf() => $_clearField(12);
  @$pb.TagNumber(12)
  CloudConf ensureCoinConf() => $_ensure(11);

  @$pb.TagNumber(13)
  CloudConf get elecConf => $_getN(12);
  @$pb.TagNumber(13)
  set elecConf(CloudConf value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasElecConf() => $_has(12);
  @$pb.TagNumber(13)
  void clearElecConf() => $_clearField(13);
  @$pb.TagNumber(13)
  CloudConf ensureElecConf() => $_ensure(12);

  @$pb.TagNumber(14)
  CloudConf get shareConf => $_getN(13);
  @$pb.TagNumber(14)
  set shareConf(CloudConf value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasShareConf() => $_has(13);
  @$pb.TagNumber(14)
  void clearShareConf() => $_clearField(14);
  @$pb.TagNumber(14)
  CloudConf ensureShareConf() => $_ensure(13);

  @$pb.TagNumber(15)
  CloudConf get screenShotConf => $_getN(14);
  @$pb.TagNumber(15)
  set screenShotConf(CloudConf value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasScreenShotConf() => $_has(14);
  @$pb.TagNumber(15)
  void clearScreenShotConf() => $_clearField(15);
  @$pb.TagNumber(15)
  CloudConf ensureScreenShotConf() => $_ensure(14);

  @$pb.TagNumber(16)
  CloudConf get lockScreenConf => $_getN(15);
  @$pb.TagNumber(16)
  set lockScreenConf(CloudConf value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasLockScreenConf() => $_has(15);
  @$pb.TagNumber(16)
  void clearLockScreenConf() => $_clearField(16);
  @$pb.TagNumber(16)
  CloudConf ensureLockScreenConf() => $_ensure(15);

  @$pb.TagNumber(17)
  CloudConf get recommendConf => $_getN(16);
  @$pb.TagNumber(17)
  set recommendConf(CloudConf value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasRecommendConf() => $_has(16);
  @$pb.TagNumber(17)
  void clearRecommendConf() => $_clearField(17);
  @$pb.TagNumber(17)
  CloudConf ensureRecommendConf() => $_ensure(16);

  @$pb.TagNumber(18)
  CloudConf get playbackSpeedConf => $_getN(17);
  @$pb.TagNumber(18)
  set playbackSpeedConf(CloudConf value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasPlaybackSpeedConf() => $_has(17);
  @$pb.TagNumber(18)
  void clearPlaybackSpeedConf() => $_clearField(18);
  @$pb.TagNumber(18)
  CloudConf ensurePlaybackSpeedConf() => $_ensure(17);

  @$pb.TagNumber(19)
  CloudConf get definitionConf => $_getN(18);
  @$pb.TagNumber(19)
  set definitionConf(CloudConf value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasDefinitionConf() => $_has(18);
  @$pb.TagNumber(19)
  void clearDefinitionConf() => $_clearField(19);
  @$pb.TagNumber(19)
  CloudConf ensureDefinitionConf() => $_ensure(18);

  @$pb.TagNumber(20)
  CloudConf get selectionsConf => $_getN(19);
  @$pb.TagNumber(20)
  set selectionsConf(CloudConf value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasSelectionsConf() => $_has(19);
  @$pb.TagNumber(20)
  void clearSelectionsConf() => $_clearField(20);
  @$pb.TagNumber(20)
  CloudConf ensureSelectionsConf() => $_ensure(19);

  @$pb.TagNumber(21)
  CloudConf get nextConf => $_getN(20);
  @$pb.TagNumber(21)
  set nextConf(CloudConf value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasNextConf() => $_has(20);
  @$pb.TagNumber(21)
  void clearNextConf() => $_clearField(21);
  @$pb.TagNumber(21)
  CloudConf ensureNextConf() => $_ensure(20);

  @$pb.TagNumber(22)
  CloudConf get editDmConf => $_getN(21);
  @$pb.TagNumber(22)
  set editDmConf(CloudConf value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasEditDmConf() => $_has(21);
  @$pb.TagNumber(22)
  void clearEditDmConf() => $_clearField(22);
  @$pb.TagNumber(22)
  CloudConf ensureEditDmConf() => $_ensure(21);

  @$pb.TagNumber(23)
  CloudConf get smallWindowConf => $_getN(22);
  @$pb.TagNumber(23)
  set smallWindowConf(CloudConf value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasSmallWindowConf() => $_has(22);
  @$pb.TagNumber(23)
  void clearSmallWindowConf() => $_clearField(23);
  @$pb.TagNumber(23)
  CloudConf ensureSmallWindowConf() => $_ensure(22);

  @$pb.TagNumber(24)
  CloudConf get shakeConf => $_getN(23);
  @$pb.TagNumber(24)
  set shakeConf(CloudConf value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasShakeConf() => $_has(23);
  @$pb.TagNumber(24)
  void clearShakeConf() => $_clearField(24);
  @$pb.TagNumber(24)
  CloudConf ensureShakeConf() => $_ensure(23);

  @$pb.TagNumber(25)
  CloudConf get outerDmConf => $_getN(24);
  @$pb.TagNumber(25)
  set outerDmConf(CloudConf value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasOuterDmConf() => $_has(24);
  @$pb.TagNumber(25)
  void clearOuterDmConf() => $_clearField(25);
  @$pb.TagNumber(25)
  CloudConf ensureOuterDmConf() => $_ensure(24);

  @$pb.TagNumber(26)
  CloudConf get innerDmConf => $_getN(25);
  @$pb.TagNumber(26)
  set innerDmConf(CloudConf value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasInnerDmConf() => $_has(25);
  @$pb.TagNumber(26)
  void clearInnerDmConf() => $_clearField(26);
  @$pb.TagNumber(26)
  CloudConf ensureInnerDmConf() => $_ensure(25);

  @$pb.TagNumber(27)
  CloudConf get panoramaConf => $_getN(26);
  @$pb.TagNumber(27)
  set panoramaConf(CloudConf value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasPanoramaConf() => $_has(26);
  @$pb.TagNumber(27)
  void clearPanoramaConf() => $_clearField(27);
  @$pb.TagNumber(27)
  CloudConf ensurePanoramaConf() => $_ensure(26);

  @$pb.TagNumber(28)
  CloudConf get dolbyConf => $_getN(27);
  @$pb.TagNumber(28)
  set dolbyConf(CloudConf value) => $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasDolbyConf() => $_has(27);
  @$pb.TagNumber(28)
  void clearDolbyConf() => $_clearField(28);
  @$pb.TagNumber(28)
  CloudConf ensureDolbyConf() => $_ensure(27);

  @$pb.TagNumber(29)
  CloudConf get colorFilterConf => $_getN(28);
  @$pb.TagNumber(29)
  set colorFilterConf(CloudConf value) => $_setField(29, value);
  @$pb.TagNumber(29)
  $core.bool hasColorFilterConf() => $_has(28);
  @$pb.TagNumber(29)
  void clearColorFilterConf() => $_clearField(29);
  @$pb.TagNumber(29)
  CloudConf ensureColorFilterConf() => $_ensure(28);

  @$pb.TagNumber(30)
  CloudConf get lossLessConf => $_getN(29);
  @$pb.TagNumber(30)
  set lossLessConf(CloudConf value) => $_setField(30, value);
  @$pb.TagNumber(30)
  $core.bool hasLossLessConf() => $_has(29);
  @$pb.TagNumber(30)
  void clearLossLessConf() => $_clearField(30);
  @$pb.TagNumber(30)
  CloudConf ensureLossLessConf() => $_ensure(29);
}

class PlayArc extends $pb.GeneratedMessage {
  factory PlayArc({
    $core.bool? isPreview,
  }) {
    final result = create();
    if (isPreview != null) result.isPreview = isPreview;
    return result;
  }

  PlayArc._();

  factory PlayArc.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayArc.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayArc',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'isPreview')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayArc clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayArc copyWith(void Function(PlayArc) updates) =>
      super.copyWith((message) => updates(message as PlayArc)) as PlayArc;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayArc create() => PlayArc._();
  @$core.override
  PlayArc createEmptyInstance() => create();
  static $pb.PbList<PlayArc> createRepeated() => $pb.PbList<PlayArc>();
  @$core.pragma('dart2js:noInline')
  static PlayArc getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayArc>(create);
  static PlayArc? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isPreview => $_getBF(0);
  @$pb.TagNumber(1)
  set isPreview($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsPreview() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsPreview() => $_clearField(1);
}

class PlayArcConf extends $pb.GeneratedMessage {
  factory PlayArcConf({
    ArcConf? backgroundPlayConf,
    ArcConf? flipConf,
    ArcConf? castConf,
    ArcConf? feedbackConf,
    ArcConf? subtitleConf,
    ArcConf? playbackRateConf,
    ArcConf? timeUpConf,
    ArcConf? playbackModeConf,
    ArcConf? scaleModeConf,
    ArcConf? likeConf,
    ArcConf? dislikeConf,
    ArcConf? coinConf,
    ArcConf? elecConf,
    ArcConf? shareConf,
    ArcConf? screenShotConf,
    ArcConf? lockScreenConf,
    ArcConf? recommendConf,
    ArcConf? playbackSpeedConf,
    ArcConf? definitionConf,
    ArcConf? selectionsConf,
    ArcConf? nextConf,
    ArcConf? editDmConf,
    ArcConf? smallWindowConf,
    ArcConf? shakeConf,
    ArcConf? outerDmConf,
    ArcConf? innerDmConf,
    ArcConf? panoramaConf,
    ArcConf? dolbyConf,
    ArcConf? screenRecordingConf,
    ArcConf? colorFilterConf,
    ArcConf? lossLessConf,
    ArcConf? systemRecordConf,
  }) {
    final result = create();
    if (backgroundPlayConf != null)
      result.backgroundPlayConf = backgroundPlayConf;
    if (flipConf != null) result.flipConf = flipConf;
    if (castConf != null) result.castConf = castConf;
    if (feedbackConf != null) result.feedbackConf = feedbackConf;
    if (subtitleConf != null) result.subtitleConf = subtitleConf;
    if (playbackRateConf != null) result.playbackRateConf = playbackRateConf;
    if (timeUpConf != null) result.timeUpConf = timeUpConf;
    if (playbackModeConf != null) result.playbackModeConf = playbackModeConf;
    if (scaleModeConf != null) result.scaleModeConf = scaleModeConf;
    if (likeConf != null) result.likeConf = likeConf;
    if (dislikeConf != null) result.dislikeConf = dislikeConf;
    if (coinConf != null) result.coinConf = coinConf;
    if (elecConf != null) result.elecConf = elecConf;
    if (shareConf != null) result.shareConf = shareConf;
    if (screenShotConf != null) result.screenShotConf = screenShotConf;
    if (lockScreenConf != null) result.lockScreenConf = lockScreenConf;
    if (recommendConf != null) result.recommendConf = recommendConf;
    if (playbackSpeedConf != null) result.playbackSpeedConf = playbackSpeedConf;
    if (definitionConf != null) result.definitionConf = definitionConf;
    if (selectionsConf != null) result.selectionsConf = selectionsConf;
    if (nextConf != null) result.nextConf = nextConf;
    if (editDmConf != null) result.editDmConf = editDmConf;
    if (smallWindowConf != null) result.smallWindowConf = smallWindowConf;
    if (shakeConf != null) result.shakeConf = shakeConf;
    if (outerDmConf != null) result.outerDmConf = outerDmConf;
    if (innerDmConf != null) result.innerDmConf = innerDmConf;
    if (panoramaConf != null) result.panoramaConf = panoramaConf;
    if (dolbyConf != null) result.dolbyConf = dolbyConf;
    if (screenRecordingConf != null)
      result.screenRecordingConf = screenRecordingConf;
    if (colorFilterConf != null) result.colorFilterConf = colorFilterConf;
    if (lossLessConf != null) result.lossLessConf = lossLessConf;
    if (systemRecordConf != null) result.systemRecordConf = systemRecordConf;
    return result;
  }

  PlayArcConf._();

  factory PlayArcConf.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayArcConf.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayArcConf',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOM<ArcConf>(1, _omitFieldNames ? '' : 'backgroundPlayConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(2, _omitFieldNames ? '' : 'flipConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(3, _omitFieldNames ? '' : 'castConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(4, _omitFieldNames ? '' : 'feedbackConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(5, _omitFieldNames ? '' : 'subtitleConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(6, _omitFieldNames ? '' : 'playbackRateConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(7, _omitFieldNames ? '' : 'timeUpConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(8, _omitFieldNames ? '' : 'playbackModeConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(9, _omitFieldNames ? '' : 'scaleModeConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(10, _omitFieldNames ? '' : 'likeConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(11, _omitFieldNames ? '' : 'dislikeConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(12, _omitFieldNames ? '' : 'coinConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(13, _omitFieldNames ? '' : 'elecConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(14, _omitFieldNames ? '' : 'shareConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(15, _omitFieldNames ? '' : 'screenShotConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(16, _omitFieldNames ? '' : 'lockScreenConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(17, _omitFieldNames ? '' : 'recommendConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(18, _omitFieldNames ? '' : 'playbackSpeedConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(19, _omitFieldNames ? '' : 'definitionConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(20, _omitFieldNames ? '' : 'selectionsConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(21, _omitFieldNames ? '' : 'nextConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(22, _omitFieldNames ? '' : 'editDmConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(23, _omitFieldNames ? '' : 'smallWindowConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(24, _omitFieldNames ? '' : 'shakeConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(25, _omitFieldNames ? '' : 'outerDmConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(26, _omitFieldNames ? '' : 'innerDmConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(27, _omitFieldNames ? '' : 'panoramaConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(28, _omitFieldNames ? '' : 'dolbyConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(29, _omitFieldNames ? '' : 'screenRecordingConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(30, _omitFieldNames ? '' : 'colorFilterConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(31, _omitFieldNames ? '' : 'lossLessConf',
        subBuilder: ArcConf.create)
    ..aOM<ArcConf>(32, _omitFieldNames ? '' : 'systemRecordConf',
        subBuilder: ArcConf.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayArcConf clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayArcConf copyWith(void Function(PlayArcConf) updates) =>
      super.copyWith((message) => updates(message as PlayArcConf))
          as PlayArcConf;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayArcConf create() => PlayArcConf._();
  @$core.override
  PlayArcConf createEmptyInstance() => create();
  static $pb.PbList<PlayArcConf> createRepeated() => $pb.PbList<PlayArcConf>();
  @$core.pragma('dart2js:noInline')
  static PlayArcConf getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayArcConf>(create);
  static PlayArcConf? _defaultInstance;

  @$pb.TagNumber(1)
  ArcConf get backgroundPlayConf => $_getN(0);
  @$pb.TagNumber(1)
  set backgroundPlayConf(ArcConf value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBackgroundPlayConf() => $_has(0);
  @$pb.TagNumber(1)
  void clearBackgroundPlayConf() => $_clearField(1);
  @$pb.TagNumber(1)
  ArcConf ensureBackgroundPlayConf() => $_ensure(0);

  @$pb.TagNumber(2)
  ArcConf get flipConf => $_getN(1);
  @$pb.TagNumber(2)
  set flipConf(ArcConf value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFlipConf() => $_has(1);
  @$pb.TagNumber(2)
  void clearFlipConf() => $_clearField(2);
  @$pb.TagNumber(2)
  ArcConf ensureFlipConf() => $_ensure(1);

  @$pb.TagNumber(3)
  ArcConf get castConf => $_getN(2);
  @$pb.TagNumber(3)
  set castConf(ArcConf value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCastConf() => $_has(2);
  @$pb.TagNumber(3)
  void clearCastConf() => $_clearField(3);
  @$pb.TagNumber(3)
  ArcConf ensureCastConf() => $_ensure(2);

  @$pb.TagNumber(4)
  ArcConf get feedbackConf => $_getN(3);
  @$pb.TagNumber(4)
  set feedbackConf(ArcConf value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFeedbackConf() => $_has(3);
  @$pb.TagNumber(4)
  void clearFeedbackConf() => $_clearField(4);
  @$pb.TagNumber(4)
  ArcConf ensureFeedbackConf() => $_ensure(3);

  @$pb.TagNumber(5)
  ArcConf get subtitleConf => $_getN(4);
  @$pb.TagNumber(5)
  set subtitleConf(ArcConf value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSubtitleConf() => $_has(4);
  @$pb.TagNumber(5)
  void clearSubtitleConf() => $_clearField(5);
  @$pb.TagNumber(5)
  ArcConf ensureSubtitleConf() => $_ensure(4);

  @$pb.TagNumber(6)
  ArcConf get playbackRateConf => $_getN(5);
  @$pb.TagNumber(6)
  set playbackRateConf(ArcConf value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPlaybackRateConf() => $_has(5);
  @$pb.TagNumber(6)
  void clearPlaybackRateConf() => $_clearField(6);
  @$pb.TagNumber(6)
  ArcConf ensurePlaybackRateConf() => $_ensure(5);

  @$pb.TagNumber(7)
  ArcConf get timeUpConf => $_getN(6);
  @$pb.TagNumber(7)
  set timeUpConf(ArcConf value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTimeUpConf() => $_has(6);
  @$pb.TagNumber(7)
  void clearTimeUpConf() => $_clearField(7);
  @$pb.TagNumber(7)
  ArcConf ensureTimeUpConf() => $_ensure(6);

  @$pb.TagNumber(8)
  ArcConf get playbackModeConf => $_getN(7);
  @$pb.TagNumber(8)
  set playbackModeConf(ArcConf value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPlaybackModeConf() => $_has(7);
  @$pb.TagNumber(8)
  void clearPlaybackModeConf() => $_clearField(8);
  @$pb.TagNumber(8)
  ArcConf ensurePlaybackModeConf() => $_ensure(7);

  @$pb.TagNumber(9)
  ArcConf get scaleModeConf => $_getN(8);
  @$pb.TagNumber(9)
  set scaleModeConf(ArcConf value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasScaleModeConf() => $_has(8);
  @$pb.TagNumber(9)
  void clearScaleModeConf() => $_clearField(9);
  @$pb.TagNumber(9)
  ArcConf ensureScaleModeConf() => $_ensure(8);

  @$pb.TagNumber(10)
  ArcConf get likeConf => $_getN(9);
  @$pb.TagNumber(10)
  set likeConf(ArcConf value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasLikeConf() => $_has(9);
  @$pb.TagNumber(10)
  void clearLikeConf() => $_clearField(10);
  @$pb.TagNumber(10)
  ArcConf ensureLikeConf() => $_ensure(9);

  @$pb.TagNumber(11)
  ArcConf get dislikeConf => $_getN(10);
  @$pb.TagNumber(11)
  set dislikeConf(ArcConf value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasDislikeConf() => $_has(10);
  @$pb.TagNumber(11)
  void clearDislikeConf() => $_clearField(11);
  @$pb.TagNumber(11)
  ArcConf ensureDislikeConf() => $_ensure(10);

  @$pb.TagNumber(12)
  ArcConf get coinConf => $_getN(11);
  @$pb.TagNumber(12)
  set coinConf(ArcConf value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCoinConf() => $_has(11);
  @$pb.TagNumber(12)
  void clearCoinConf() => $_clearField(12);
  @$pb.TagNumber(12)
  ArcConf ensureCoinConf() => $_ensure(11);

  @$pb.TagNumber(13)
  ArcConf get elecConf => $_getN(12);
  @$pb.TagNumber(13)
  set elecConf(ArcConf value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasElecConf() => $_has(12);
  @$pb.TagNumber(13)
  void clearElecConf() => $_clearField(13);
  @$pb.TagNumber(13)
  ArcConf ensureElecConf() => $_ensure(12);

  @$pb.TagNumber(14)
  ArcConf get shareConf => $_getN(13);
  @$pb.TagNumber(14)
  set shareConf(ArcConf value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasShareConf() => $_has(13);
  @$pb.TagNumber(14)
  void clearShareConf() => $_clearField(14);
  @$pb.TagNumber(14)
  ArcConf ensureShareConf() => $_ensure(13);

  @$pb.TagNumber(15)
  ArcConf get screenShotConf => $_getN(14);
  @$pb.TagNumber(15)
  set screenShotConf(ArcConf value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasScreenShotConf() => $_has(14);
  @$pb.TagNumber(15)
  void clearScreenShotConf() => $_clearField(15);
  @$pb.TagNumber(15)
  ArcConf ensureScreenShotConf() => $_ensure(14);

  @$pb.TagNumber(16)
  ArcConf get lockScreenConf => $_getN(15);
  @$pb.TagNumber(16)
  set lockScreenConf(ArcConf value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasLockScreenConf() => $_has(15);
  @$pb.TagNumber(16)
  void clearLockScreenConf() => $_clearField(16);
  @$pb.TagNumber(16)
  ArcConf ensureLockScreenConf() => $_ensure(15);

  @$pb.TagNumber(17)
  ArcConf get recommendConf => $_getN(16);
  @$pb.TagNumber(17)
  set recommendConf(ArcConf value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasRecommendConf() => $_has(16);
  @$pb.TagNumber(17)
  void clearRecommendConf() => $_clearField(17);
  @$pb.TagNumber(17)
  ArcConf ensureRecommendConf() => $_ensure(16);

  @$pb.TagNumber(18)
  ArcConf get playbackSpeedConf => $_getN(17);
  @$pb.TagNumber(18)
  set playbackSpeedConf(ArcConf value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasPlaybackSpeedConf() => $_has(17);
  @$pb.TagNumber(18)
  void clearPlaybackSpeedConf() => $_clearField(18);
  @$pb.TagNumber(18)
  ArcConf ensurePlaybackSpeedConf() => $_ensure(17);

  @$pb.TagNumber(19)
  ArcConf get definitionConf => $_getN(18);
  @$pb.TagNumber(19)
  set definitionConf(ArcConf value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasDefinitionConf() => $_has(18);
  @$pb.TagNumber(19)
  void clearDefinitionConf() => $_clearField(19);
  @$pb.TagNumber(19)
  ArcConf ensureDefinitionConf() => $_ensure(18);

  @$pb.TagNumber(20)
  ArcConf get selectionsConf => $_getN(19);
  @$pb.TagNumber(20)
  set selectionsConf(ArcConf value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasSelectionsConf() => $_has(19);
  @$pb.TagNumber(20)
  void clearSelectionsConf() => $_clearField(20);
  @$pb.TagNumber(20)
  ArcConf ensureSelectionsConf() => $_ensure(19);

  @$pb.TagNumber(21)
  ArcConf get nextConf => $_getN(20);
  @$pb.TagNumber(21)
  set nextConf(ArcConf value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasNextConf() => $_has(20);
  @$pb.TagNumber(21)
  void clearNextConf() => $_clearField(21);
  @$pb.TagNumber(21)
  ArcConf ensureNextConf() => $_ensure(20);

  @$pb.TagNumber(22)
  ArcConf get editDmConf => $_getN(21);
  @$pb.TagNumber(22)
  set editDmConf(ArcConf value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasEditDmConf() => $_has(21);
  @$pb.TagNumber(22)
  void clearEditDmConf() => $_clearField(22);
  @$pb.TagNumber(22)
  ArcConf ensureEditDmConf() => $_ensure(21);

  @$pb.TagNumber(23)
  ArcConf get smallWindowConf => $_getN(22);
  @$pb.TagNumber(23)
  set smallWindowConf(ArcConf value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasSmallWindowConf() => $_has(22);
  @$pb.TagNumber(23)
  void clearSmallWindowConf() => $_clearField(23);
  @$pb.TagNumber(23)
  ArcConf ensureSmallWindowConf() => $_ensure(22);

  @$pb.TagNumber(24)
  ArcConf get shakeConf => $_getN(23);
  @$pb.TagNumber(24)
  set shakeConf(ArcConf value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasShakeConf() => $_has(23);
  @$pb.TagNumber(24)
  void clearShakeConf() => $_clearField(24);
  @$pb.TagNumber(24)
  ArcConf ensureShakeConf() => $_ensure(23);

  @$pb.TagNumber(25)
  ArcConf get outerDmConf => $_getN(24);
  @$pb.TagNumber(25)
  set outerDmConf(ArcConf value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasOuterDmConf() => $_has(24);
  @$pb.TagNumber(25)
  void clearOuterDmConf() => $_clearField(25);
  @$pb.TagNumber(25)
  ArcConf ensureOuterDmConf() => $_ensure(24);

  @$pb.TagNumber(26)
  ArcConf get innerDmConf => $_getN(25);
  @$pb.TagNumber(26)
  set innerDmConf(ArcConf value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasInnerDmConf() => $_has(25);
  @$pb.TagNumber(26)
  void clearInnerDmConf() => $_clearField(26);
  @$pb.TagNumber(26)
  ArcConf ensureInnerDmConf() => $_ensure(25);

  @$pb.TagNumber(27)
  ArcConf get panoramaConf => $_getN(26);
  @$pb.TagNumber(27)
  set panoramaConf(ArcConf value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasPanoramaConf() => $_has(26);
  @$pb.TagNumber(27)
  void clearPanoramaConf() => $_clearField(27);
  @$pb.TagNumber(27)
  ArcConf ensurePanoramaConf() => $_ensure(26);

  @$pb.TagNumber(28)
  ArcConf get dolbyConf => $_getN(27);
  @$pb.TagNumber(28)
  set dolbyConf(ArcConf value) => $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasDolbyConf() => $_has(27);
  @$pb.TagNumber(28)
  void clearDolbyConf() => $_clearField(28);
  @$pb.TagNumber(28)
  ArcConf ensureDolbyConf() => $_ensure(27);

  @$pb.TagNumber(29)
  ArcConf get screenRecordingConf => $_getN(28);
  @$pb.TagNumber(29)
  set screenRecordingConf(ArcConf value) => $_setField(29, value);
  @$pb.TagNumber(29)
  $core.bool hasScreenRecordingConf() => $_has(28);
  @$pb.TagNumber(29)
  void clearScreenRecordingConf() => $_clearField(29);
  @$pb.TagNumber(29)
  ArcConf ensureScreenRecordingConf() => $_ensure(28);

  @$pb.TagNumber(30)
  ArcConf get colorFilterConf => $_getN(29);
  @$pb.TagNumber(30)
  set colorFilterConf(ArcConf value) => $_setField(30, value);
  @$pb.TagNumber(30)
  $core.bool hasColorFilterConf() => $_has(29);
  @$pb.TagNumber(30)
  void clearColorFilterConf() => $_clearField(30);
  @$pb.TagNumber(30)
  ArcConf ensureColorFilterConf() => $_ensure(29);

  @$pb.TagNumber(31)
  ArcConf get lossLessConf => $_getN(30);
  @$pb.TagNumber(31)
  set lossLessConf(ArcConf value) => $_setField(31, value);
  @$pb.TagNumber(31)
  $core.bool hasLossLessConf() => $_has(30);
  @$pb.TagNumber(31)
  void clearLossLessConf() => $_clearField(31);
  @$pb.TagNumber(31)
  ArcConf ensureLossLessConf() => $_ensure(30);

  @$pb.TagNumber(32)
  ArcConf get systemRecordConf => $_getN(31);
  @$pb.TagNumber(32)
  set systemRecordConf(ArcConf value) => $_setField(32, value);
  @$pb.TagNumber(32)
  $core.bool hasSystemRecordConf() => $_has(31);
  @$pb.TagNumber(32)
  void clearSystemRecordConf() => $_clearField(32);
  @$pb.TagNumber(32)
  ArcConf ensureSystemRecordConf() => $_ensure(31);
}

class PlayConfEditReply extends $pb.GeneratedMessage {
  factory PlayConfEditReply() => create();

  PlayConfEditReply._();

  factory PlayConfEditReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayConfEditReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayConfEditReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayConfEditReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayConfEditReply copyWith(void Function(PlayConfEditReply) updates) =>
      super.copyWith((message) => updates(message as PlayConfEditReply))
          as PlayConfEditReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayConfEditReply create() => PlayConfEditReply._();
  @$core.override
  PlayConfEditReply createEmptyInstance() => create();
  static $pb.PbList<PlayConfEditReply> createRepeated() =>
      $pb.PbList<PlayConfEditReply>();
  @$core.pragma('dart2js:noInline')
  static PlayConfEditReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayConfEditReply>(create);
  static PlayConfEditReply? _defaultInstance;
}

class PlayConfEditReq extends $pb.GeneratedMessage {
  factory PlayConfEditReq({
    $core.Iterable<PlayConfState>? playConf,
  }) {
    final result = create();
    if (playConf != null) result.playConf.addAll(playConf);
    return result;
  }

  PlayConfEditReq._();

  factory PlayConfEditReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayConfEditReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayConfEditReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..pPM<PlayConfState>(1, _omitFieldNames ? '' : 'playConf',
        subBuilder: PlayConfState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayConfEditReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayConfEditReq copyWith(void Function(PlayConfEditReq) updates) =>
      super.copyWith((message) => updates(message as PlayConfEditReq))
          as PlayConfEditReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayConfEditReq create() => PlayConfEditReq._();
  @$core.override
  PlayConfEditReq createEmptyInstance() => create();
  static $pb.PbList<PlayConfEditReq> createRepeated() =>
      $pb.PbList<PlayConfEditReq>();
  @$core.pragma('dart2js:noInline')
  static PlayConfEditReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayConfEditReq>(create);
  static PlayConfEditReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PlayConfState> get playConf => $_getList(0);
}

class PlayConfReply extends $pb.GeneratedMessage {
  factory PlayConfReply({
    PlayAbilityConf? playConf,
  }) {
    final result = create();
    if (playConf != null) result.playConf = playConf;
    return result;
  }

  PlayConfReply._();

  factory PlayConfReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayConfReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayConfReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOM<PlayAbilityConf>(1, _omitFieldNames ? '' : 'playConf',
        subBuilder: PlayAbilityConf.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayConfReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayConfReply copyWith(void Function(PlayConfReply) updates) =>
      super.copyWith((message) => updates(message as PlayConfReply))
          as PlayConfReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayConfReply create() => PlayConfReply._();
  @$core.override
  PlayConfReply createEmptyInstance() => create();
  static $pb.PbList<PlayConfReply> createRepeated() =>
      $pb.PbList<PlayConfReply>();
  @$core.pragma('dart2js:noInline')
  static PlayConfReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayConfReply>(create);
  static PlayConfReply? _defaultInstance;

  @$pb.TagNumber(1)
  PlayAbilityConf get playConf => $_getN(0);
  @$pb.TagNumber(1)
  set playConf(PlayAbilityConf value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlayConf() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayConf() => $_clearField(1);
  @$pb.TagNumber(1)
  PlayAbilityConf ensurePlayConf() => $_ensure(0);
}

class PlayConfReq extends $pb.GeneratedMessage {
  factory PlayConfReq() => create();

  PlayConfReq._();

  factory PlayConfReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayConfReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayConfReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayConfReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayConfReq copyWith(void Function(PlayConfReq) updates) =>
      super.copyWith((message) => updates(message as PlayConfReq))
          as PlayConfReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayConfReq create() => PlayConfReq._();
  @$core.override
  PlayConfReq createEmptyInstance() => create();
  static $pb.PbList<PlayConfReq> createRepeated() => $pb.PbList<PlayConfReq>();
  @$core.pragma('dart2js:noInline')
  static PlayConfReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayConfReq>(create);
  static PlayConfReq? _defaultInstance;
}

class PlayConfState extends $pb.GeneratedMessage {
  factory PlayConfState({
    ConfType? confType,
    $core.bool? show,
    FieldValue? fieldValue,
    ConfValue? confValue,
  }) {
    final result = create();
    if (confType != null) result.confType = confType;
    if (show != null) result.show = show;
    if (fieldValue != null) result.fieldValue = fieldValue;
    if (confValue != null) result.confValue = confValue;
    return result;
  }

  PlayConfState._();

  factory PlayConfState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayConfState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayConfState',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aE<ConfType>(1, _omitFieldNames ? '' : 'confType',
        enumValues: ConfType.values)
    ..aOB(2, _omitFieldNames ? '' : 'show')
    ..aOM<FieldValue>(3, _omitFieldNames ? '' : 'fieldValue',
        subBuilder: FieldValue.create)
    ..aOM<ConfValue>(4, _omitFieldNames ? '' : 'confValue',
        subBuilder: ConfValue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayConfState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayConfState copyWith(void Function(PlayConfState) updates) =>
      super.copyWith((message) => updates(message as PlayConfState))
          as PlayConfState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayConfState create() => PlayConfState._();
  @$core.override
  PlayConfState createEmptyInstance() => create();
  static $pb.PbList<PlayConfState> createRepeated() =>
      $pb.PbList<PlayConfState>();
  @$core.pragma('dart2js:noInline')
  static PlayConfState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayConfState>(create);
  static PlayConfState? _defaultInstance;

  @$pb.TagNumber(1)
  ConfType get confType => $_getN(0);
  @$pb.TagNumber(1)
  set confType(ConfType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasConfType() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get show => $_getBF(1);
  @$pb.TagNumber(2)
  set show($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShow() => $_has(1);
  @$pb.TagNumber(2)
  void clearShow() => $_clearField(2);

  @$pb.TagNumber(3)
  FieldValue get fieldValue => $_getN(2);
  @$pb.TagNumber(3)
  set fieldValue(FieldValue value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFieldValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearFieldValue() => $_clearField(3);
  @$pb.TagNumber(3)
  FieldValue ensureFieldValue() => $_ensure(2);

  @$pb.TagNumber(4)
  ConfValue get confValue => $_getN(3);
  @$pb.TagNumber(4)
  set confValue(ConfValue value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasConfValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearConfValue() => $_clearField(4);
  @$pb.TagNumber(4)
  ConfValue ensureConfValue() => $_ensure(3);
}

class PlayLimit extends $pb.GeneratedMessage {
  factory PlayLimit({
    PlayLimitCode? code,
    $core.String? message,
    $core.String? subMessage,
    ButtonStyle? button,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    if (subMessage != null) result.subMessage = subMessage;
    if (button != null) result.button = button;
    return result;
  }

  PlayLimit._();

  factory PlayLimit.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayLimit.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayLimit',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aE<PlayLimitCode>(1, _omitFieldNames ? '' : 'code',
        enumValues: PlayLimitCode.values)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOS(3, _omitFieldNames ? '' : 'subMessage')
    ..aOM<ButtonStyle>(4, _omitFieldNames ? '' : 'button',
        subBuilder: ButtonStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayLimit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayLimit copyWith(void Function(PlayLimit) updates) =>
      super.copyWith((message) => updates(message as PlayLimit)) as PlayLimit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayLimit create() => PlayLimit._();
  @$core.override
  PlayLimit createEmptyInstance() => create();
  static $pb.PbList<PlayLimit> createRepeated() => $pb.PbList<PlayLimit>();
  @$core.pragma('dart2js:noInline')
  static PlayLimit getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayLimit>(create);
  static PlayLimit? _defaultInstance;

  @$pb.TagNumber(1)
  PlayLimitCode get code => $_getN(0);
  @$pb.TagNumber(1)
  set code(PlayLimitCode value) => $_setField(1, value);
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

  @$pb.TagNumber(3)
  $core.String get subMessage => $_getSZ(2);
  @$pb.TagNumber(3)
  set subMessage($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubMessage() => $_clearField(3);

  @$pb.TagNumber(4)
  ButtonStyle get button => $_getN(3);
  @$pb.TagNumber(4)
  set button(ButtonStyle value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasButton() => $_has(3);
  @$pb.TagNumber(4)
  void clearButton() => $_clearField(4);
  @$pb.TagNumber(4)
  ButtonStyle ensureButton() => $_ensure(3);
}

class PlayURLReply extends $pb.GeneratedMessage {
  factory PlayURLReply({
    $core.int? quality,
    $core.String? format,
    $fixnum.Int64? timelength,
    $core.int? videoCodecid,
    $core.int? fnver,
    $core.int? fnval,
    $core.bool? videoProject,
    $core.Iterable<ResponseUrl>? durl,
    ResponseDash? dash,
    $core.int? noRexcode,
    UpgradeLimit? upgradeLimit,
    $core.Iterable<FormatDescription>? supportFormats,
    VideoType? type,
    VipRisk? vipRisk,
  }) {
    final result = create();
    if (quality != null) result.quality = quality;
    if (format != null) result.format = format;
    if (timelength != null) result.timelength = timelength;
    if (videoCodecid != null) result.videoCodecid = videoCodecid;
    if (fnver != null) result.fnver = fnver;
    if (fnval != null) result.fnval = fnval;
    if (videoProject != null) result.videoProject = videoProject;
    if (durl != null) result.durl.addAll(durl);
    if (dash != null) result.dash = dash;
    if (noRexcode != null) result.noRexcode = noRexcode;
    if (upgradeLimit != null) result.upgradeLimit = upgradeLimit;
    if (supportFormats != null) result.supportFormats.addAll(supportFormats);
    if (type != null) result.type = type;
    if (vipRisk != null) result.vipRisk = vipRisk;
    return result;
  }

  PlayURLReply._();

  factory PlayURLReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayURLReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayURLReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'quality')
    ..aOS(2, _omitFieldNames ? '' : 'format')
    ..aInt64(3, _omitFieldNames ? '' : 'timelength')
    ..aI(4, _omitFieldNames ? '' : 'videoCodecid')
    ..aI(5, _omitFieldNames ? '' : 'fnver')
    ..aI(6, _omitFieldNames ? '' : 'fnval')
    ..aOB(7, _omitFieldNames ? '' : 'videoProject')
    ..pPM<ResponseUrl>(8, _omitFieldNames ? '' : 'durl',
        subBuilder: ResponseUrl.create)
    ..aOM<ResponseDash>(9, _omitFieldNames ? '' : 'dash',
        subBuilder: ResponseDash.create)
    ..aI(10, _omitFieldNames ? '' : 'noRexcode')
    ..aOM<UpgradeLimit>(11, _omitFieldNames ? '' : 'upgradeLimit',
        subBuilder: UpgradeLimit.create)
    ..pPM<FormatDescription>(12, _omitFieldNames ? '' : 'supportFormats',
        subBuilder: FormatDescription.create)
    ..aE<VideoType>(13, _omitFieldNames ? '' : 'type',
        enumValues: VideoType.values)
    ..aOM<VipRisk>(14, _omitFieldNames ? '' : 'vipRisk',
        subBuilder: VipRisk.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayURLReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayURLReply copyWith(void Function(PlayURLReply) updates) =>
      super.copyWith((message) => updates(message as PlayURLReply))
          as PlayURLReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayURLReply create() => PlayURLReply._();
  @$core.override
  PlayURLReply createEmptyInstance() => create();
  static $pb.PbList<PlayURLReply> createRepeated() =>
      $pb.PbList<PlayURLReply>();
  @$core.pragma('dart2js:noInline')
  static PlayURLReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayURLReply>(create);
  static PlayURLReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get quality => $_getIZ(0);
  @$pb.TagNumber(1)
  set quality($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuality() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuality() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get format => $_getSZ(1);
  @$pb.TagNumber(2)
  set format($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFormat() => $_has(1);
  @$pb.TagNumber(2)
  void clearFormat() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timelength => $_getI64(2);
  @$pb.TagNumber(3)
  set timelength($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimelength() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimelength() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get videoCodecid => $_getIZ(3);
  @$pb.TagNumber(4)
  set videoCodecid($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVideoCodecid() => $_has(3);
  @$pb.TagNumber(4)
  void clearVideoCodecid() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get fnver => $_getIZ(4);
  @$pb.TagNumber(5)
  set fnver($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFnver() => $_has(4);
  @$pb.TagNumber(5)
  void clearFnver() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get fnval => $_getIZ(5);
  @$pb.TagNumber(6)
  set fnval($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFnval() => $_has(5);
  @$pb.TagNumber(6)
  void clearFnval() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get videoProject => $_getBF(6);
  @$pb.TagNumber(7)
  set videoProject($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVideoProject() => $_has(6);
  @$pb.TagNumber(7)
  void clearVideoProject() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<ResponseUrl> get durl => $_getList(7);

  @$pb.TagNumber(9)
  ResponseDash get dash => $_getN(8);
  @$pb.TagNumber(9)
  set dash(ResponseDash value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasDash() => $_has(8);
  @$pb.TagNumber(9)
  void clearDash() => $_clearField(9);
  @$pb.TagNumber(9)
  ResponseDash ensureDash() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.int get noRexcode => $_getIZ(9);
  @$pb.TagNumber(10)
  set noRexcode($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasNoRexcode() => $_has(9);
  @$pb.TagNumber(10)
  void clearNoRexcode() => $_clearField(10);

  @$pb.TagNumber(11)
  UpgradeLimit get upgradeLimit => $_getN(10);
  @$pb.TagNumber(11)
  set upgradeLimit(UpgradeLimit value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasUpgradeLimit() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpgradeLimit() => $_clearField(11);
  @$pb.TagNumber(11)
  UpgradeLimit ensureUpgradeLimit() => $_ensure(10);

  @$pb.TagNumber(12)
  $pb.PbList<FormatDescription> get supportFormats => $_getList(11);

  @$pb.TagNumber(13)
  VideoType get type => $_getN(12);
  @$pb.TagNumber(13)
  set type(VideoType value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasType() => $_has(12);
  @$pb.TagNumber(13)
  void clearType() => $_clearField(13);

  @$pb.TagNumber(14)
  VipRisk get vipRisk => $_getN(13);
  @$pb.TagNumber(14)
  set vipRisk(VipRisk value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasVipRisk() => $_has(13);
  @$pb.TagNumber(14)
  void clearVipRisk() => $_clearField(14);
  @$pb.TagNumber(14)
  VipRisk ensureVipRisk() => $_ensure(13);
}

class PlayURLReq extends $pb.GeneratedMessage {
  factory PlayURLReq({
    $fixnum.Int64? aid,
    $fixnum.Int64? cid,
    $fixnum.Int64? qn,
    $core.int? fnver,
    $core.int? fnval,
    $core.int? download,
    $core.int? forceHost,
    $core.bool? fourk,
    $core.String? spmid,
    $core.String? fromSpmid,
  }) {
    final result = create();
    if (aid != null) result.aid = aid;
    if (cid != null) result.cid = cid;
    if (qn != null) result.qn = qn;
    if (fnver != null) result.fnver = fnver;
    if (fnval != null) result.fnval = fnval;
    if (download != null) result.download = download;
    if (forceHost != null) result.forceHost = forceHost;
    if (fourk != null) result.fourk = fourk;
    if (spmid != null) result.spmid = spmid;
    if (fromSpmid != null) result.fromSpmid = fromSpmid;
    return result;
  }

  PlayURLReq._();

  factory PlayURLReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayURLReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayURLReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aInt64(2, _omitFieldNames ? '' : 'cid')
    ..aInt64(3, _omitFieldNames ? '' : 'qn')
    ..aI(4, _omitFieldNames ? '' : 'fnver')
    ..aI(5, _omitFieldNames ? '' : 'fnval')
    ..aI(6, _omitFieldNames ? '' : 'download')
    ..aI(7, _omitFieldNames ? '' : 'forceHost')
    ..aOB(8, _omitFieldNames ? '' : 'fourk')
    ..aOS(9, _omitFieldNames ? '' : 'spmid')
    ..aOS(10, _omitFieldNames ? '' : 'fromSpmid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayURLReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayURLReq copyWith(void Function(PlayURLReq) updates) =>
      super.copyWith((message) => updates(message as PlayURLReq)) as PlayURLReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayURLReq create() => PlayURLReq._();
  @$core.override
  PlayURLReq createEmptyInstance() => create();
  static $pb.PbList<PlayURLReq> createRepeated() => $pb.PbList<PlayURLReq>();
  @$core.pragma('dart2js:noInline')
  static PlayURLReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayURLReq>(create);
  static PlayURLReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get aid => $_getI64(0);
  @$pb.TagNumber(1)
  set aid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get cid => $_getI64(1);
  @$pb.TagNumber(2)
  set cid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCid() => $_has(1);
  @$pb.TagNumber(2)
  void clearCid() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get qn => $_getI64(2);
  @$pb.TagNumber(3)
  set qn($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQn() => $_has(2);
  @$pb.TagNumber(3)
  void clearQn() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get fnver => $_getIZ(3);
  @$pb.TagNumber(4)
  set fnver($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFnver() => $_has(3);
  @$pb.TagNumber(4)
  void clearFnver() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get fnval => $_getIZ(4);
  @$pb.TagNumber(5)
  set fnval($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFnval() => $_has(4);
  @$pb.TagNumber(5)
  void clearFnval() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get download => $_getIZ(5);
  @$pb.TagNumber(6)
  set download($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDownload() => $_has(5);
  @$pb.TagNumber(6)
  void clearDownload() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get forceHost => $_getIZ(6);
  @$pb.TagNumber(7)
  set forceHost($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasForceHost() => $_has(6);
  @$pb.TagNumber(7)
  void clearForceHost() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get fourk => $_getBF(7);
  @$pb.TagNumber(8)
  set fourk($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFourk() => $_has(7);
  @$pb.TagNumber(8)
  void clearFourk() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get spmid => $_getSZ(8);
  @$pb.TagNumber(9)
  set spmid($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSpmid() => $_has(8);
  @$pb.TagNumber(9)
  void clearSpmid() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get fromSpmid => $_getSZ(9);
  @$pb.TagNumber(10)
  set fromSpmid($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasFromSpmid() => $_has(9);
  @$pb.TagNumber(10)
  void clearFromSpmid() => $_clearField(10);
}

class PlayViewReply extends $pb.GeneratedMessage {
  factory PlayViewReply({
    VideoInfo? videoInfo,
    PlayAbilityConf? playConf,
    UpgradeLimit? upgradeLimit,
    Chronos? chronos,
    PlayArcConf? playArc,
    Event? event,
    AB? ab,
    PlayLimit? playLimit,
    ViewInfo? viewInfo,
    PlayArc? arc,
  }) {
    final result = create();
    if (videoInfo != null) result.videoInfo = videoInfo;
    if (playConf != null) result.playConf = playConf;
    if (upgradeLimit != null) result.upgradeLimit = upgradeLimit;
    if (chronos != null) result.chronos = chronos;
    if (playArc != null) result.playArc = playArc;
    if (event != null) result.event = event;
    if (ab != null) result.ab = ab;
    if (playLimit != null) result.playLimit = playLimit;
    if (viewInfo != null) result.viewInfo = viewInfo;
    if (arc != null) result.arc = arc;
    return result;
  }

  PlayViewReply._();

  factory PlayViewReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayViewReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayViewReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOM<VideoInfo>(1, _omitFieldNames ? '' : 'videoInfo',
        subBuilder: VideoInfo.create)
    ..aOM<PlayAbilityConf>(2, _omitFieldNames ? '' : 'playConf',
        subBuilder: PlayAbilityConf.create)
    ..aOM<UpgradeLimit>(3, _omitFieldNames ? '' : 'upgradeLimit',
        subBuilder: UpgradeLimit.create)
    ..aOM<Chronos>(4, _omitFieldNames ? '' : 'chronos',
        subBuilder: Chronos.create)
    ..aOM<PlayArcConf>(5, _omitFieldNames ? '' : 'playArc',
        subBuilder: PlayArcConf.create)
    ..aOM<Event>(6, _omitFieldNames ? '' : 'event', subBuilder: Event.create)
    ..aOM<AB>(7, _omitFieldNames ? '' : 'ab', subBuilder: AB.create)
    ..aOM<PlayLimit>(8, _omitFieldNames ? '' : 'playLimit',
        subBuilder: PlayLimit.create)
    ..aOM<ViewInfo>(9, _omitFieldNames ? '' : 'viewInfo',
        subBuilder: ViewInfo.create)
    ..aOM<PlayArc>(10, _omitFieldNames ? '' : 'arc', subBuilder: PlayArc.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayViewReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayViewReply copyWith(void Function(PlayViewReply) updates) =>
      super.copyWith((message) => updates(message as PlayViewReply))
          as PlayViewReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayViewReply create() => PlayViewReply._();
  @$core.override
  PlayViewReply createEmptyInstance() => create();
  static $pb.PbList<PlayViewReply> createRepeated() =>
      $pb.PbList<PlayViewReply>();
  @$core.pragma('dart2js:noInline')
  static PlayViewReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayViewReply>(create);
  static PlayViewReply? _defaultInstance;

  @$pb.TagNumber(1)
  VideoInfo get videoInfo => $_getN(0);
  @$pb.TagNumber(1)
  set videoInfo(VideoInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVideoInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearVideoInfo() => $_clearField(1);
  @$pb.TagNumber(1)
  VideoInfo ensureVideoInfo() => $_ensure(0);

  @$pb.TagNumber(2)
  PlayAbilityConf get playConf => $_getN(1);
  @$pb.TagNumber(2)
  set playConf(PlayAbilityConf value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlayConf() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayConf() => $_clearField(2);
  @$pb.TagNumber(2)
  PlayAbilityConf ensurePlayConf() => $_ensure(1);

  @$pb.TagNumber(3)
  UpgradeLimit get upgradeLimit => $_getN(2);
  @$pb.TagNumber(3)
  set upgradeLimit(UpgradeLimit value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUpgradeLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpgradeLimit() => $_clearField(3);
  @$pb.TagNumber(3)
  UpgradeLimit ensureUpgradeLimit() => $_ensure(2);

  @$pb.TagNumber(4)
  Chronos get chronos => $_getN(3);
  @$pb.TagNumber(4)
  set chronos(Chronos value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasChronos() => $_has(3);
  @$pb.TagNumber(4)
  void clearChronos() => $_clearField(4);
  @$pb.TagNumber(4)
  Chronos ensureChronos() => $_ensure(3);

  @$pb.TagNumber(5)
  PlayArcConf get playArc => $_getN(4);
  @$pb.TagNumber(5)
  set playArc(PlayArcConf value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPlayArc() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlayArc() => $_clearField(5);
  @$pb.TagNumber(5)
  PlayArcConf ensurePlayArc() => $_ensure(4);

  @$pb.TagNumber(6)
  Event get event => $_getN(5);
  @$pb.TagNumber(6)
  set event(Event value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEvent() => $_has(5);
  @$pb.TagNumber(6)
  void clearEvent() => $_clearField(6);
  @$pb.TagNumber(6)
  Event ensureEvent() => $_ensure(5);

  @$pb.TagNumber(7)
  AB get ab => $_getN(6);
  @$pb.TagNumber(7)
  set ab(AB value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAb() => $_has(6);
  @$pb.TagNumber(7)
  void clearAb() => $_clearField(7);
  @$pb.TagNumber(7)
  AB ensureAb() => $_ensure(6);

  @$pb.TagNumber(8)
  PlayLimit get playLimit => $_getN(7);
  @$pb.TagNumber(8)
  set playLimit(PlayLimit value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPlayLimit() => $_has(7);
  @$pb.TagNumber(8)
  void clearPlayLimit() => $_clearField(8);
  @$pb.TagNumber(8)
  PlayLimit ensurePlayLimit() => $_ensure(7);

  @$pb.TagNumber(9)
  ViewInfo get viewInfo => $_getN(8);
  @$pb.TagNumber(9)
  set viewInfo(ViewInfo value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasViewInfo() => $_has(8);
  @$pb.TagNumber(9)
  void clearViewInfo() => $_clearField(9);
  @$pb.TagNumber(9)
  ViewInfo ensureViewInfo() => $_ensure(8);

  @$pb.TagNumber(10)
  PlayArc get arc => $_getN(9);
  @$pb.TagNumber(10)
  set arc(PlayArc value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasArc() => $_has(9);
  @$pb.TagNumber(10)
  void clearArc() => $_clearField(10);
  @$pb.TagNumber(10)
  PlayArc ensureArc() => $_ensure(9);
}

class PlayViewReq extends $pb.GeneratedMessage {
  factory PlayViewReq({
    $fixnum.Int64? aid,
    $fixnum.Int64? cid,
    $fixnum.Int64? qn,
    $core.int? fnver,
    $core.int? fnval,
    $core.int? download,
    $core.int? forceHost,
    $core.bool? fourk,
    $core.String? spmid,
    $core.String? fromSpmid,
    $core.int? teenagersMode,
    CodeType? preferCodecType,
    Business? business,
    $fixnum.Int64? voiceBalance,
  }) {
    final result = create();
    if (aid != null) result.aid = aid;
    if (cid != null) result.cid = cid;
    if (qn != null) result.qn = qn;
    if (fnver != null) result.fnver = fnver;
    if (fnval != null) result.fnval = fnval;
    if (download != null) result.download = download;
    if (forceHost != null) result.forceHost = forceHost;
    if (fourk != null) result.fourk = fourk;
    if (spmid != null) result.spmid = spmid;
    if (fromSpmid != null) result.fromSpmid = fromSpmid;
    if (teenagersMode != null) result.teenagersMode = teenagersMode;
    if (preferCodecType != null) result.preferCodecType = preferCodecType;
    if (business != null) result.business = business;
    if (voiceBalance != null) result.voiceBalance = voiceBalance;
    return result;
  }

  PlayViewReq._();

  factory PlayViewReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayViewReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayViewReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aInt64(2, _omitFieldNames ? '' : 'cid')
    ..aInt64(3, _omitFieldNames ? '' : 'qn')
    ..aI(4, _omitFieldNames ? '' : 'fnver')
    ..aI(5, _omitFieldNames ? '' : 'fnval')
    ..aI(6, _omitFieldNames ? '' : 'download')
    ..aI(7, _omitFieldNames ? '' : 'forceHost')
    ..aOB(8, _omitFieldNames ? '' : 'fourk')
    ..aOS(9, _omitFieldNames ? '' : 'spmid')
    ..aOS(10, _omitFieldNames ? '' : 'fromSpmid')
    ..aI(11, _omitFieldNames ? '' : 'teenagersMode')
    ..aE<CodeType>(12, _omitFieldNames ? '' : 'preferCodecType',
        enumValues: CodeType.values)
    ..aE<Business>(13, _omitFieldNames ? '' : 'business',
        enumValues: Business.values)
    ..aInt64(14, _omitFieldNames ? '' : 'voiceBalance')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayViewReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayViewReq copyWith(void Function(PlayViewReq) updates) =>
      super.copyWith((message) => updates(message as PlayViewReq))
          as PlayViewReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayViewReq create() => PlayViewReq._();
  @$core.override
  PlayViewReq createEmptyInstance() => create();
  static $pb.PbList<PlayViewReq> createRepeated() => $pb.PbList<PlayViewReq>();
  @$core.pragma('dart2js:noInline')
  static PlayViewReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayViewReq>(create);
  static PlayViewReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get aid => $_getI64(0);
  @$pb.TagNumber(1)
  set aid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get cid => $_getI64(1);
  @$pb.TagNumber(2)
  set cid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCid() => $_has(1);
  @$pb.TagNumber(2)
  void clearCid() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get qn => $_getI64(2);
  @$pb.TagNumber(3)
  set qn($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQn() => $_has(2);
  @$pb.TagNumber(3)
  void clearQn() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get fnver => $_getIZ(3);
  @$pb.TagNumber(4)
  set fnver($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFnver() => $_has(3);
  @$pb.TagNumber(4)
  void clearFnver() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get fnval => $_getIZ(4);
  @$pb.TagNumber(5)
  set fnval($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFnval() => $_has(4);
  @$pb.TagNumber(5)
  void clearFnval() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get download => $_getIZ(5);
  @$pb.TagNumber(6)
  set download($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDownload() => $_has(5);
  @$pb.TagNumber(6)
  void clearDownload() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get forceHost => $_getIZ(6);
  @$pb.TagNumber(7)
  set forceHost($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasForceHost() => $_has(6);
  @$pb.TagNumber(7)
  void clearForceHost() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get fourk => $_getBF(7);
  @$pb.TagNumber(8)
  set fourk($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFourk() => $_has(7);
  @$pb.TagNumber(8)
  void clearFourk() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get spmid => $_getSZ(8);
  @$pb.TagNumber(9)
  set spmid($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSpmid() => $_has(8);
  @$pb.TagNumber(9)
  void clearSpmid() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get fromSpmid => $_getSZ(9);
  @$pb.TagNumber(10)
  set fromSpmid($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasFromSpmid() => $_has(9);
  @$pb.TagNumber(10)
  void clearFromSpmid() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get teenagersMode => $_getIZ(10);
  @$pb.TagNumber(11)
  set teenagersMode($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasTeenagersMode() => $_has(10);
  @$pb.TagNumber(11)
  void clearTeenagersMode() => $_clearField(11);

  @$pb.TagNumber(12)
  CodeType get preferCodecType => $_getN(11);
  @$pb.TagNumber(12)
  set preferCodecType(CodeType value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasPreferCodecType() => $_has(11);
  @$pb.TagNumber(12)
  void clearPreferCodecType() => $_clearField(12);

  @$pb.TagNumber(13)
  Business get business => $_getN(12);
  @$pb.TagNumber(13)
  set business(Business value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasBusiness() => $_has(12);
  @$pb.TagNumber(13)
  void clearBusiness() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get voiceBalance => $_getI64(13);
  @$pb.TagNumber(14)
  set voiceBalance($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasVoiceBalance() => $_has(13);
  @$pb.TagNumber(14)
  void clearVoiceBalance() => $_clearField(14);
}

class ProjectReply extends $pb.GeneratedMessage {
  factory ProjectReply({
    PlayURLReply? project,
  }) {
    final result = create();
    if (project != null) result.project = project;
    return result;
  }

  ProjectReply._();

  factory ProjectReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProjectReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProjectReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOM<PlayURLReply>(1, _omitFieldNames ? '' : 'project',
        subBuilder: PlayURLReply.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProjectReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProjectReply copyWith(void Function(ProjectReply) updates) =>
      super.copyWith((message) => updates(message as ProjectReply))
          as ProjectReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProjectReply create() => ProjectReply._();
  @$core.override
  ProjectReply createEmptyInstance() => create();
  static $pb.PbList<ProjectReply> createRepeated() =>
      $pb.PbList<ProjectReply>();
  @$core.pragma('dart2js:noInline')
  static ProjectReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProjectReply>(create);
  static ProjectReply? _defaultInstance;

  @$pb.TagNumber(1)
  PlayURLReply get project => $_getN(0);
  @$pb.TagNumber(1)
  set project(PlayURLReply value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);
  @$pb.TagNumber(1)
  PlayURLReply ensureProject() => $_ensure(0);
}

class ProjectReq extends $pb.GeneratedMessage {
  factory ProjectReq({
    $fixnum.Int64? aid,
    $fixnum.Int64? cid,
    $fixnum.Int64? qn,
    $core.int? fnver,
    $core.int? fnval,
    $core.int? download,
    $core.int? forceHost,
    $core.bool? fourk,
    $core.String? spmid,
    $core.String? fromSpmid,
    $core.int? protocol,
    $core.int? deviceType,
  }) {
    final result = create();
    if (aid != null) result.aid = aid;
    if (cid != null) result.cid = cid;
    if (qn != null) result.qn = qn;
    if (fnver != null) result.fnver = fnver;
    if (fnval != null) result.fnval = fnval;
    if (download != null) result.download = download;
    if (forceHost != null) result.forceHost = forceHost;
    if (fourk != null) result.fourk = fourk;
    if (spmid != null) result.spmid = spmid;
    if (fromSpmid != null) result.fromSpmid = fromSpmid;
    if (protocol != null) result.protocol = protocol;
    if (deviceType != null) result.deviceType = deviceType;
    return result;
  }

  ProjectReq._();

  factory ProjectReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProjectReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProjectReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aInt64(2, _omitFieldNames ? '' : 'cid')
    ..aInt64(3, _omitFieldNames ? '' : 'qn')
    ..aI(4, _omitFieldNames ? '' : 'fnver')
    ..aI(5, _omitFieldNames ? '' : 'fnval')
    ..aI(6, _omitFieldNames ? '' : 'download')
    ..aI(7, _omitFieldNames ? '' : 'forceHost')
    ..aOB(8, _omitFieldNames ? '' : 'fourk')
    ..aOS(9, _omitFieldNames ? '' : 'spmid')
    ..aOS(10, _omitFieldNames ? '' : 'fromSpmid')
    ..aI(11, _omitFieldNames ? '' : 'protocol')
    ..aI(12, _omitFieldNames ? '' : 'deviceType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProjectReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProjectReq copyWith(void Function(ProjectReq) updates) =>
      super.copyWith((message) => updates(message as ProjectReq)) as ProjectReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProjectReq create() => ProjectReq._();
  @$core.override
  ProjectReq createEmptyInstance() => create();
  static $pb.PbList<ProjectReq> createRepeated() => $pb.PbList<ProjectReq>();
  @$core.pragma('dart2js:noInline')
  static ProjectReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProjectReq>(create);
  static ProjectReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get aid => $_getI64(0);
  @$pb.TagNumber(1)
  set aid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get cid => $_getI64(1);
  @$pb.TagNumber(2)
  set cid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCid() => $_has(1);
  @$pb.TagNumber(2)
  void clearCid() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get qn => $_getI64(2);
  @$pb.TagNumber(3)
  set qn($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQn() => $_has(2);
  @$pb.TagNumber(3)
  void clearQn() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get fnver => $_getIZ(3);
  @$pb.TagNumber(4)
  set fnver($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFnver() => $_has(3);
  @$pb.TagNumber(4)
  void clearFnver() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get fnval => $_getIZ(4);
  @$pb.TagNumber(5)
  set fnval($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFnval() => $_has(4);
  @$pb.TagNumber(5)
  void clearFnval() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get download => $_getIZ(5);
  @$pb.TagNumber(6)
  set download($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDownload() => $_has(5);
  @$pb.TagNumber(6)
  void clearDownload() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get forceHost => $_getIZ(6);
  @$pb.TagNumber(7)
  set forceHost($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasForceHost() => $_has(6);
  @$pb.TagNumber(7)
  void clearForceHost() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get fourk => $_getBF(7);
  @$pb.TagNumber(8)
  set fourk($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFourk() => $_has(7);
  @$pb.TagNumber(8)
  void clearFourk() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get spmid => $_getSZ(8);
  @$pb.TagNumber(9)
  set spmid($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSpmid() => $_has(8);
  @$pb.TagNumber(9)
  void clearSpmid() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get fromSpmid => $_getSZ(9);
  @$pb.TagNumber(10)
  set fromSpmid($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasFromSpmid() => $_has(9);
  @$pb.TagNumber(10)
  void clearFromSpmid() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get protocol => $_getIZ(10);
  @$pb.TagNumber(11)
  set protocol($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasProtocol() => $_has(10);
  @$pb.TagNumber(11)
  void clearProtocol() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get deviceType => $_getIZ(11);
  @$pb.TagNumber(12)
  set deviceType($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasDeviceType() => $_has(11);
  @$pb.TagNumber(12)
  void clearDeviceType() => $_clearField(12);
}

class PromptBar extends $pb.GeneratedMessage {
  factory PromptBar({
    TextInfo? title,
    TextInfo? subTitle,
    $core.String? subTitleIcon,
    $core.String? bgImage,
    $core.Iterable<ButtonInfo>? button,
    Report? report,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (subTitle != null) result.subTitle = subTitle;
    if (subTitleIcon != null) result.subTitleIcon = subTitleIcon;
    if (bgImage != null) result.bgImage = bgImage;
    if (button != null) result.button.addAll(button);
    if (report != null) result.report = report;
    return result;
  }

  PromptBar._();

  factory PromptBar.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PromptBar.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PromptBar',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOM<TextInfo>(1, _omitFieldNames ? '' : 'title',
        subBuilder: TextInfo.create)
    ..aOM<TextInfo>(2, _omitFieldNames ? '' : 'subTitle',
        subBuilder: TextInfo.create)
    ..aOS(3, _omitFieldNames ? '' : 'subTitleIcon')
    ..aOS(4, _omitFieldNames ? '' : 'bgImage')
    ..pPM<ButtonInfo>(5, _omitFieldNames ? '' : 'button',
        subBuilder: ButtonInfo.create)
    ..aOM<Report>(6, _omitFieldNames ? '' : 'report', subBuilder: Report.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptBar clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromptBar copyWith(void Function(PromptBar) updates) =>
      super.copyWith((message) => updates(message as PromptBar)) as PromptBar;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PromptBar create() => PromptBar._();
  @$core.override
  PromptBar createEmptyInstance() => create();
  static $pb.PbList<PromptBar> createRepeated() => $pb.PbList<PromptBar>();
  @$core.pragma('dart2js:noInline')
  static PromptBar getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PromptBar>(create);
  static PromptBar? _defaultInstance;

  @$pb.TagNumber(1)
  TextInfo get title => $_getN(0);
  @$pb.TagNumber(1)
  set title(TextInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);
  @$pb.TagNumber(1)
  TextInfo ensureTitle() => $_ensure(0);

  @$pb.TagNumber(2)
  TextInfo get subTitle => $_getN(1);
  @$pb.TagNumber(2)
  set subTitle(TextInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSubTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubTitle() => $_clearField(2);
  @$pb.TagNumber(2)
  TextInfo ensureSubTitle() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get subTitleIcon => $_getSZ(2);
  @$pb.TagNumber(3)
  set subTitleIcon($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubTitleIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubTitleIcon() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get bgImage => $_getSZ(3);
  @$pb.TagNumber(4)
  set bgImage($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBgImage() => $_has(3);
  @$pb.TagNumber(4)
  void clearBgImage() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<ButtonInfo> get button => $_getList(4);

  @$pb.TagNumber(6)
  Report get report => $_getN(5);
  @$pb.TagNumber(6)
  set report(Report value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasReport() => $_has(5);
  @$pb.TagNumber(6)
  void clearReport() => $_clearField(6);
  @$pb.TagNumber(6)
  Report ensureReport() => $_ensure(5);
}

class Report extends $pb.GeneratedMessage {
  factory Report({
    $core.String? showEventId,
    $core.String? clickEventId,
    $core.String? extends_3,
  }) {
    final result = create();
    if (showEventId != null) result.showEventId = showEventId;
    if (clickEventId != null) result.clickEventId = clickEventId;
    if (extends_3 != null) result.extends_3 = extends_3;
    return result;
  }

  Report._();

  factory Report.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Report.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Report',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'showEventId')
    ..aOS(2, _omitFieldNames ? '' : 'clickEventId')
    ..aOS(3, _omitFieldNames ? '' : 'extends')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Report clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Report copyWith(void Function(Report) updates) =>
      super.copyWith((message) => updates(message as Report)) as Report;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Report create() => Report._();
  @$core.override
  Report createEmptyInstance() => create();
  static $pb.PbList<Report> createRepeated() => $pb.PbList<Report>();
  @$core.pragma('dart2js:noInline')
  static Report getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Report>(create);
  static Report? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get showEventId => $_getSZ(0);
  @$pb.TagNumber(1)
  set showEventId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShowEventId() => $_has(0);
  @$pb.TagNumber(1)
  void clearShowEventId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clickEventId => $_getSZ(1);
  @$pb.TagNumber(2)
  set clickEventId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClickEventId() => $_has(1);
  @$pb.TagNumber(2)
  void clearClickEventId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get extends_3 => $_getSZ(2);
  @$pb.TagNumber(3)
  set extends_3($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExtends_3() => $_has(2);
  @$pb.TagNumber(3)
  void clearExtends_3() => $_clearField(3);
}

class ResponseDash extends $pb.GeneratedMessage {
  factory ResponseDash({
    $core.Iterable<DashItem>? video,
    $core.Iterable<DashItem>? audio,
  }) {
    final result = create();
    if (video != null) result.video.addAll(video);
    if (audio != null) result.audio.addAll(audio);
    return result;
  }

  ResponseDash._();

  factory ResponseDash.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseDash.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseDash',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..pPM<DashItem>(1, _omitFieldNames ? '' : 'video',
        subBuilder: DashItem.create)
    ..pPM<DashItem>(2, _omitFieldNames ? '' : 'audio',
        subBuilder: DashItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseDash clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseDash copyWith(void Function(ResponseDash) updates) =>
      super.copyWith((message) => updates(message as ResponseDash))
          as ResponseDash;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseDash create() => ResponseDash._();
  @$core.override
  ResponseDash createEmptyInstance() => create();
  static $pb.PbList<ResponseDash> createRepeated() =>
      $pb.PbList<ResponseDash>();
  @$core.pragma('dart2js:noInline')
  static ResponseDash getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseDash>(create);
  static ResponseDash? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DashItem> get video => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<DashItem> get audio => $_getList(1);
}

class ResponseUrl extends $pb.GeneratedMessage {
  factory ResponseUrl({
    $core.int? order,
    $fixnum.Int64? length,
    $fixnum.Int64? size,
    $core.String? url,
    $core.Iterable<$core.String>? backupUrl,
    $core.String? md5,
    $core.int? quality,
  }) {
    final result = create();
    if (order != null) result.order = order;
    if (length != null) result.length = length;
    if (size != null) result.size = size;
    if (url != null) result.url = url;
    if (backupUrl != null) result.backupUrl.addAll(backupUrl);
    if (md5 != null) result.md5 = md5;
    if (quality != null) result.quality = quality;
    return result;
  }

  ResponseUrl._();

  factory ResponseUrl.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResponseUrl.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResponseUrl',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'order')
    ..aInt64(2, _omitFieldNames ? '' : 'length')
    ..aInt64(3, _omitFieldNames ? '' : 'size')
    ..aOS(4, _omitFieldNames ? '' : 'url')
    ..pPS(5, _omitFieldNames ? '' : 'backupUrl')
    ..aOS(6, _omitFieldNames ? '' : 'md5')
    ..aI(7, _omitFieldNames ? '' : 'quality')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseUrl clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResponseUrl copyWith(void Function(ResponseUrl) updates) =>
      super.copyWith((message) => updates(message as ResponseUrl))
          as ResponseUrl;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResponseUrl create() => ResponseUrl._();
  @$core.override
  ResponseUrl createEmptyInstance() => create();
  static $pb.PbList<ResponseUrl> createRepeated() => $pb.PbList<ResponseUrl>();
  @$core.pragma('dart2js:noInline')
  static ResponseUrl getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseUrl>(create);
  static ResponseUrl? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get order => $_getIZ(0);
  @$pb.TagNumber(1)
  set order($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get length => $_getI64(1);
  @$pb.TagNumber(2)
  set length($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLength() => $_has(1);
  @$pb.TagNumber(2)
  void clearLength() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get size => $_getI64(2);
  @$pb.TagNumber(3)
  set size($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get url => $_getSZ(3);
  @$pb.TagNumber(4)
  set url($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get backupUrl => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get md5 => $_getSZ(5);
  @$pb.TagNumber(6)
  set md5($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMd5() => $_has(5);
  @$pb.TagNumber(6)
  void clearMd5() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get quality => $_getIZ(6);
  @$pb.TagNumber(7)
  set quality($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasQuality() => $_has(6);
  @$pb.TagNumber(7)
  void clearQuality() => $_clearField(7);
}

class Scheme extends $pb.GeneratedMessage {
  factory Scheme({
    Scheme_ActionType? actionType,
    $core.String? toast,
  }) {
    final result = create();
    if (actionType != null) result.actionType = actionType;
    if (toast != null) result.toast = toast;
    return result;
  }

  Scheme._();

  factory Scheme.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Scheme.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Scheme',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aE<Scheme_ActionType>(1, _omitFieldNames ? '' : 'actionType',
        enumValues: Scheme_ActionType.values)
    ..aOS(2, _omitFieldNames ? '' : 'toast')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Scheme clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Scheme copyWith(void Function(Scheme) updates) =>
      super.copyWith((message) => updates(message as Scheme)) as Scheme;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Scheme create() => Scheme._();
  @$core.override
  Scheme createEmptyInstance() => create();
  static $pb.PbList<Scheme> createRepeated() => $pb.PbList<Scheme>();
  @$core.pragma('dart2js:noInline')
  static Scheme getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Scheme>(create);
  static Scheme? _defaultInstance;

  @$pb.TagNumber(1)
  Scheme_ActionType get actionType => $_getN(0);
  @$pb.TagNumber(1)
  set actionType(Scheme_ActionType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasActionType() => $_has(0);
  @$pb.TagNumber(1)
  void clearActionType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toast => $_getSZ(1);
  @$pb.TagNumber(2)
  set toast($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToast() => $_has(1);
  @$pb.TagNumber(2)
  void clearToast() => $_clearField(2);
}

class SegmentVideo extends $pb.GeneratedMessage {
  factory SegmentVideo({
    $core.Iterable<ResponseUrl>? segment,
  }) {
    final result = create();
    if (segment != null) result.segment.addAll(segment);
    return result;
  }

  SegmentVideo._();

  factory SegmentVideo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SegmentVideo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SegmentVideo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..pPM<ResponseUrl>(1, _omitFieldNames ? '' : 'segment',
        subBuilder: ResponseUrl.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SegmentVideo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SegmentVideo copyWith(void Function(SegmentVideo) updates) =>
      super.copyWith((message) => updates(message as SegmentVideo))
          as SegmentVideo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SegmentVideo create() => SegmentVideo._();
  @$core.override
  SegmentVideo createEmptyInstance() => create();
  static $pb.PbList<SegmentVideo> createRepeated() =>
      $pb.PbList<SegmentVideo>();
  @$core.pragma('dart2js:noInline')
  static SegmentVideo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SegmentVideo>(create);
  static SegmentVideo? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ResponseUrl> get segment => $_getList(0);
}

class Shake extends $pb.GeneratedMessage {
  factory Shake({
    $core.String? file,
  }) {
    final result = create();
    if (file != null) result.file = file;
    return result;
  }

  Shake._();

  factory Shake.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Shake.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Shake',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'file')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Shake clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Shake copyWith(void Function(Shake) updates) =>
      super.copyWith((message) => updates(message as Shake)) as Shake;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Shake create() => Shake._();
  @$core.override
  Shake createEmptyInstance() => create();
  static $pb.PbList<Shake> createRepeated() => $pb.PbList<Shake>();
  @$core.pragma('dart2js:noInline')
  static Shake getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Shake>(create);
  static Shake? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get file => $_getSZ(0);
  @$pb.TagNumber(1)
  set file($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFile() => $_has(0);
  @$pb.TagNumber(1)
  void clearFile() => $_clearField(1);
}

enum Stream_Content { dashVideo, segmentVideo, multiDashVideo, notSet }

class Stream extends $pb.GeneratedMessage {
  factory Stream({
    StreamInfo? streamInfo,
    DashVideo? dashVideo,
    SegmentVideo? segmentVideo,
    MultiDashVideo? multiDashVideo,
  }) {
    final result = create();
    if (streamInfo != null) result.streamInfo = streamInfo;
    if (dashVideo != null) result.dashVideo = dashVideo;
    if (segmentVideo != null) result.segmentVideo = segmentVideo;
    if (multiDashVideo != null) result.multiDashVideo = multiDashVideo;
    return result;
  }

  Stream._();

  factory Stream.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Stream.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Stream_Content> _Stream_ContentByTag = {
    2: Stream_Content.dashVideo,
    3: Stream_Content.segmentVideo,
    4: Stream_Content.multiDashVideo,
    0: Stream_Content.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Stream',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..aOM<StreamInfo>(1, _omitFieldNames ? '' : 'streamInfo',
        subBuilder: StreamInfo.create)
    ..aOM<DashVideo>(2, _omitFieldNames ? '' : 'dashVideo',
        subBuilder: DashVideo.create)
    ..aOM<SegmentVideo>(3, _omitFieldNames ? '' : 'segmentVideo',
        subBuilder: SegmentVideo.create)
    ..aOM<MultiDashVideo>(4, _omitFieldNames ? '' : 'multiDashVideo',
        subBuilder: MultiDashVideo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Stream clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Stream copyWith(void Function(Stream) updates) =>
      super.copyWith((message) => updates(message as Stream)) as Stream;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Stream create() => Stream._();
  @$core.override
  Stream createEmptyInstance() => create();
  static $pb.PbList<Stream> createRepeated() => $pb.PbList<Stream>();
  @$core.pragma('dart2js:noInline')
  static Stream getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Stream>(create);
  static Stream? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  Stream_Content whichContent() => _Stream_ContentByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearContent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  StreamInfo get streamInfo => $_getN(0);
  @$pb.TagNumber(1)
  set streamInfo(StreamInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStreamInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearStreamInfo() => $_clearField(1);
  @$pb.TagNumber(1)
  StreamInfo ensureStreamInfo() => $_ensure(0);

  @$pb.TagNumber(2)
  DashVideo get dashVideo => $_getN(1);
  @$pb.TagNumber(2)
  set dashVideo(DashVideo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDashVideo() => $_has(1);
  @$pb.TagNumber(2)
  void clearDashVideo() => $_clearField(2);
  @$pb.TagNumber(2)
  DashVideo ensureDashVideo() => $_ensure(1);

  @$pb.TagNumber(3)
  SegmentVideo get segmentVideo => $_getN(2);
  @$pb.TagNumber(3)
  set segmentVideo(SegmentVideo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSegmentVideo() => $_has(2);
  @$pb.TagNumber(3)
  void clearSegmentVideo() => $_clearField(3);
  @$pb.TagNumber(3)
  SegmentVideo ensureSegmentVideo() => $_ensure(2);

  @$pb.TagNumber(4)
  MultiDashVideo get multiDashVideo => $_getN(3);
  @$pb.TagNumber(4)
  set multiDashVideo(MultiDashVideo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMultiDashVideo() => $_has(3);
  @$pb.TagNumber(4)
  void clearMultiDashVideo() => $_clearField(4);
  @$pb.TagNumber(4)
  MultiDashVideo ensureMultiDashVideo() => $_ensure(3);
}

class StreamInfo extends $pb.GeneratedMessage {
  factory StreamInfo({
    $core.int? quality,
    $core.String? format,
    $core.String? description,
    PlayErr? errCode,
    StreamLimit? limit,
    $core.bool? needVip,
    $core.bool? needLogin,
    $core.bool? intact,
    $core.bool? noRexcode,
    $fixnum.Int64? attribute,
    $core.String? newDescription,
    $core.String? displayDesc,
    $core.String? superscript,
    $core.bool? vipFree,
    $core.String? subtitle,
    Scheme? scheme,
    $core.bool? supportDrm,
    $core.bool? hasPreview,
  }) {
    final result = create();
    if (quality != null) result.quality = quality;
    if (format != null) result.format = format;
    if (description != null) result.description = description;
    if (errCode != null) result.errCode = errCode;
    if (limit != null) result.limit = limit;
    if (needVip != null) result.needVip = needVip;
    if (needLogin != null) result.needLogin = needLogin;
    if (intact != null) result.intact = intact;
    if (noRexcode != null) result.noRexcode = noRexcode;
    if (attribute != null) result.attribute = attribute;
    if (newDescription != null) result.newDescription = newDescription;
    if (displayDesc != null) result.displayDesc = displayDesc;
    if (superscript != null) result.superscript = superscript;
    if (vipFree != null) result.vipFree = vipFree;
    if (subtitle != null) result.subtitle = subtitle;
    if (scheme != null) result.scheme = scheme;
    if (supportDrm != null) result.supportDrm = supportDrm;
    if (hasPreview != null) result.hasPreview = hasPreview;
    return result;
  }

  StreamInfo._();

  factory StreamInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'quality')
    ..aOS(2, _omitFieldNames ? '' : 'format')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aE<PlayErr>(4, _omitFieldNames ? '' : 'errCode',
        enumValues: PlayErr.values)
    ..aOM<StreamLimit>(5, _omitFieldNames ? '' : 'limit',
        subBuilder: StreamLimit.create)
    ..aOB(6, _omitFieldNames ? '' : 'needVip')
    ..aOB(7, _omitFieldNames ? '' : 'needLogin')
    ..aOB(8, _omitFieldNames ? '' : 'intact')
    ..aOB(9, _omitFieldNames ? '' : 'noRexcode')
    ..aInt64(10, _omitFieldNames ? '' : 'attribute')
    ..aOS(11, _omitFieldNames ? '' : 'newDescription')
    ..aOS(12, _omitFieldNames ? '' : 'displayDesc')
    ..aOS(13, _omitFieldNames ? '' : 'superscript')
    ..aOB(14, _omitFieldNames ? '' : 'vipFree')
    ..aOS(15, _omitFieldNames ? '' : 'subtitle')
    ..aOM<Scheme>(16, _omitFieldNames ? '' : 'scheme',
        subBuilder: Scheme.create)
    ..aOB(17, _omitFieldNames ? '' : 'supportDrm')
    ..aOB(18, _omitFieldNames ? '' : 'hasPreview')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamInfo copyWith(void Function(StreamInfo) updates) =>
      super.copyWith((message) => updates(message as StreamInfo)) as StreamInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamInfo create() => StreamInfo._();
  @$core.override
  StreamInfo createEmptyInstance() => create();
  static $pb.PbList<StreamInfo> createRepeated() => $pb.PbList<StreamInfo>();
  @$core.pragma('dart2js:noInline')
  static StreamInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamInfo>(create);
  static StreamInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get quality => $_getIZ(0);
  @$pb.TagNumber(1)
  set quality($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuality() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuality() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get format => $_getSZ(1);
  @$pb.TagNumber(2)
  set format($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFormat() => $_has(1);
  @$pb.TagNumber(2)
  void clearFormat() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  PlayErr get errCode => $_getN(3);
  @$pb.TagNumber(4)
  set errCode(PlayErr value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasErrCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearErrCode() => $_clearField(4);

  @$pb.TagNumber(5)
  StreamLimit get limit => $_getN(4);
  @$pb.TagNumber(5)
  set limit(StreamLimit value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLimit() => $_has(4);
  @$pb.TagNumber(5)
  void clearLimit() => $_clearField(5);
  @$pb.TagNumber(5)
  StreamLimit ensureLimit() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.bool get needVip => $_getBF(5);
  @$pb.TagNumber(6)
  set needVip($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNeedVip() => $_has(5);
  @$pb.TagNumber(6)
  void clearNeedVip() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get needLogin => $_getBF(6);
  @$pb.TagNumber(7)
  set needLogin($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNeedLogin() => $_has(6);
  @$pb.TagNumber(7)
  void clearNeedLogin() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get intact => $_getBF(7);
  @$pb.TagNumber(8)
  set intact($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIntact() => $_has(7);
  @$pb.TagNumber(8)
  void clearIntact() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get noRexcode => $_getBF(8);
  @$pb.TagNumber(9)
  set noRexcode($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasNoRexcode() => $_has(8);
  @$pb.TagNumber(9)
  void clearNoRexcode() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get attribute => $_getI64(9);
  @$pb.TagNumber(10)
  set attribute($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAttribute() => $_has(9);
  @$pb.TagNumber(10)
  void clearAttribute() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get newDescription => $_getSZ(10);
  @$pb.TagNumber(11)
  set newDescription($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasNewDescription() => $_has(10);
  @$pb.TagNumber(11)
  void clearNewDescription() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get displayDesc => $_getSZ(11);
  @$pb.TagNumber(12)
  set displayDesc($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasDisplayDesc() => $_has(11);
  @$pb.TagNumber(12)
  void clearDisplayDesc() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get superscript => $_getSZ(12);
  @$pb.TagNumber(13)
  set superscript($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasSuperscript() => $_has(12);
  @$pb.TagNumber(13)
  void clearSuperscript() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get vipFree => $_getBF(13);
  @$pb.TagNumber(14)
  set vipFree($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasVipFree() => $_has(13);
  @$pb.TagNumber(14)
  void clearVipFree() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get subtitle => $_getSZ(14);
  @$pb.TagNumber(15)
  set subtitle($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasSubtitle() => $_has(14);
  @$pb.TagNumber(15)
  void clearSubtitle() => $_clearField(15);

  @$pb.TagNumber(16)
  Scheme get scheme => $_getN(15);
  @$pb.TagNumber(16)
  set scheme(Scheme value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasScheme() => $_has(15);
  @$pb.TagNumber(16)
  void clearScheme() => $_clearField(16);
  @$pb.TagNumber(16)
  Scheme ensureScheme() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.bool get supportDrm => $_getBF(16);
  @$pb.TagNumber(17)
  set supportDrm($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasSupportDrm() => $_has(16);
  @$pb.TagNumber(17)
  void clearSupportDrm() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.bool get hasPreview => $_getBF(17);
  @$pb.TagNumber(18)
  set hasPreview($core.bool value) => $_setBool(17, value);
  @$pb.TagNumber(18)
  $core.bool hasHasPreview() => $_has(17);
  @$pb.TagNumber(18)
  void clearHasPreview() => $_clearField(18);
}

class StreamLimit extends $pb.GeneratedMessage {
  factory StreamLimit({
    $core.String? title,
    $core.String? uri,
    $core.String? msg,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (uri != null) result.uri = uri;
    if (msg != null) result.msg = msg;
    return result;
  }

  StreamLimit._();

  factory StreamLimit.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamLimit.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamLimit',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'uri')
    ..aOS(3, _omitFieldNames ? '' : 'msg')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamLimit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamLimit copyWith(void Function(StreamLimit) updates) =>
      super.copyWith((message) => updates(message as StreamLimit))
          as StreamLimit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamLimit create() => StreamLimit._();
  @$core.override
  StreamLimit createEmptyInstance() => create();
  static $pb.PbList<StreamLimit> createRepeated() => $pb.PbList<StreamLimit>();
  @$core.pragma('dart2js:noInline')
  static StreamLimit getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamLimit>(create);
  static StreamLimit? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get uri => $_getSZ(1);
  @$pb.TagNumber(2)
  set uri($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearUri() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get msg => $_getSZ(2);
  @$pb.TagNumber(3)
  set msg($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMsg() => $_has(2);
  @$pb.TagNumber(3)
  void clearMsg() => $_clearField(3);
}

class TextInfo extends $pb.GeneratedMessage {
  factory TextInfo({
    $core.String? text,
    $core.String? textColor,
    $core.String? textColorNight,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (textColor != null) result.textColor = textColor;
    if (textColorNight != null) result.textColorNight = textColorNight;
    return result;
  }

  TextInfo._();

  factory TextInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TextInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TextInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'textColor')
    ..aOS(3, _omitFieldNames ? '' : 'textColorNight')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextInfo copyWith(void Function(TextInfo) updates) =>
      super.copyWith((message) => updates(message as TextInfo)) as TextInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TextInfo create() => TextInfo._();
  @$core.override
  TextInfo createEmptyInstance() => create();
  static $pb.PbList<TextInfo> createRepeated() => $pb.PbList<TextInfo>();
  @$core.pragma('dart2js:noInline')
  static TextInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TextInfo>(create);
  static TextInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get textColor => $_getSZ(1);
  @$pb.TagNumber(2)
  set textColor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTextColor() => $_has(1);
  @$pb.TagNumber(2)
  void clearTextColor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get textColorNight => $_getSZ(2);
  @$pb.TagNumber(3)
  set textColorNight($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTextColorNight() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextColorNight() => $_clearField(3);
}

class UpgradeButton extends $pb.GeneratedMessage {
  factory UpgradeButton({
    $core.String? title,
    $core.String? link,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (link != null) result.link = link;
    return result;
  }

  UpgradeButton._();

  factory UpgradeButton.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpgradeButton.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpgradeButton',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'link')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpgradeButton clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpgradeButton copyWith(void Function(UpgradeButton) updates) =>
      super.copyWith((message) => updates(message as UpgradeButton))
          as UpgradeButton;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpgradeButton create() => UpgradeButton._();
  @$core.override
  UpgradeButton createEmptyInstance() => create();
  static $pb.PbList<UpgradeButton> createRepeated() =>
      $pb.PbList<UpgradeButton>();
  @$core.pragma('dart2js:noInline')
  static UpgradeButton getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpgradeButton>(create);
  static UpgradeButton? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get link => $_getSZ(1);
  @$pb.TagNumber(2)
  set link($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLink() => $_has(1);
  @$pb.TagNumber(2)
  void clearLink() => $_clearField(2);
}

class UpgradeLimit extends $pb.GeneratedMessage {
  factory UpgradeLimit({
    $core.int? code,
    $core.String? message,
    $core.String? image,
    UpgradeButton? button,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    if (image != null) result.image = image;
    if (button != null) result.button = button;
    return result;
  }

  UpgradeLimit._();

  factory UpgradeLimit.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpgradeLimit.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpgradeLimit',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOS(3, _omitFieldNames ? '' : 'image')
    ..aOM<UpgradeButton>(4, _omitFieldNames ? '' : 'button',
        subBuilder: UpgradeButton.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpgradeLimit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpgradeLimit copyWith(void Function(UpgradeLimit) updates) =>
      super.copyWith((message) => updates(message as UpgradeLimit))
          as UpgradeLimit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpgradeLimit create() => UpgradeLimit._();
  @$core.override
  UpgradeLimit createEmptyInstance() => create();
  static $pb.PbList<UpgradeLimit> createRepeated() =>
      $pb.PbList<UpgradeLimit>();
  @$core.pragma('dart2js:noInline')
  static UpgradeLimit getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpgradeLimit>(create);
  static UpgradeLimit? _defaultInstance;

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

  @$pb.TagNumber(3)
  $core.String get image => $_getSZ(2);
  @$pb.TagNumber(3)
  set image($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasImage() => $_has(2);
  @$pb.TagNumber(3)
  void clearImage() => $_clearField(3);

  @$pb.TagNumber(4)
  UpgradeButton get button => $_getN(3);
  @$pb.TagNumber(4)
  set button(UpgradeButton value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasButton() => $_has(3);
  @$pb.TagNumber(4)
  void clearButton() => $_clearField(4);
  @$pb.TagNumber(4)
  UpgradeButton ensureButton() => $_ensure(3);
}

class VideoInfo extends $pb.GeneratedMessage {
  factory VideoInfo({
    $core.int? quality,
    $core.String? format,
    $fixnum.Int64? timelength,
    $core.int? videoCodecid,
    $core.Iterable<Stream>? streamList,
    $core.Iterable<DashItem>? dashAudio,
    DolbyItem? dolby,
    VolumeInfo? volume,
    LossLessItem? lossLessItem,
    $fixnum.Int64? mainTimelength,
  }) {
    final result = create();
    if (quality != null) result.quality = quality;
    if (format != null) result.format = format;
    if (timelength != null) result.timelength = timelength;
    if (videoCodecid != null) result.videoCodecid = videoCodecid;
    if (streamList != null) result.streamList.addAll(streamList);
    if (dashAudio != null) result.dashAudio.addAll(dashAudio);
    if (dolby != null) result.dolby = dolby;
    if (volume != null) result.volume = volume;
    if (lossLessItem != null) result.lossLessItem = lossLessItem;
    if (mainTimelength != null) result.mainTimelength = mainTimelength;
    return result;
  }

  VideoInfo._();

  factory VideoInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VideoInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'quality')
    ..aOS(2, _omitFieldNames ? '' : 'format')
    ..aInt64(3, _omitFieldNames ? '' : 'timelength')
    ..aI(4, _omitFieldNames ? '' : 'videoCodecid')
    ..pPM<Stream>(5, _omitFieldNames ? '' : 'streamList',
        subBuilder: Stream.create)
    ..pPM<DashItem>(6, _omitFieldNames ? '' : 'dashAudio',
        subBuilder: DashItem.create)
    ..aOM<DolbyItem>(7, _omitFieldNames ? '' : 'dolby',
        subBuilder: DolbyItem.create)
    ..aOM<VolumeInfo>(8, _omitFieldNames ? '' : 'volume',
        subBuilder: VolumeInfo.create)
    ..aOM<LossLessItem>(9, _omitFieldNames ? '' : 'lossLessItem',
        subBuilder: LossLessItem.create)
    ..aInt64(10, _omitFieldNames ? '' : 'mainTimelength')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoInfo copyWith(void Function(VideoInfo) updates) =>
      super.copyWith((message) => updates(message as VideoInfo)) as VideoInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VideoInfo create() => VideoInfo._();
  @$core.override
  VideoInfo createEmptyInstance() => create();
  static $pb.PbList<VideoInfo> createRepeated() => $pb.PbList<VideoInfo>();
  @$core.pragma('dart2js:noInline')
  static VideoInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoInfo>(create);
  static VideoInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get quality => $_getIZ(0);
  @$pb.TagNumber(1)
  set quality($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuality() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuality() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get format => $_getSZ(1);
  @$pb.TagNumber(2)
  set format($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFormat() => $_has(1);
  @$pb.TagNumber(2)
  void clearFormat() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timelength => $_getI64(2);
  @$pb.TagNumber(3)
  set timelength($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimelength() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimelength() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get videoCodecid => $_getIZ(3);
  @$pb.TagNumber(4)
  set videoCodecid($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVideoCodecid() => $_has(3);
  @$pb.TagNumber(4)
  void clearVideoCodecid() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<Stream> get streamList => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<DashItem> get dashAudio => $_getList(5);

  @$pb.TagNumber(7)
  DolbyItem get dolby => $_getN(6);
  @$pb.TagNumber(7)
  set dolby(DolbyItem value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDolby() => $_has(6);
  @$pb.TagNumber(7)
  void clearDolby() => $_clearField(7);
  @$pb.TagNumber(7)
  DolbyItem ensureDolby() => $_ensure(6);

  @$pb.TagNumber(8)
  VolumeInfo get volume => $_getN(7);
  @$pb.TagNumber(8)
  set volume(VolumeInfo value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasVolume() => $_has(7);
  @$pb.TagNumber(8)
  void clearVolume() => $_clearField(8);
  @$pb.TagNumber(8)
  VolumeInfo ensureVolume() => $_ensure(7);

  @$pb.TagNumber(9)
  LossLessItem get lossLessItem => $_getN(8);
  @$pb.TagNumber(9)
  set lossLessItem(LossLessItem value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasLossLessItem() => $_has(8);
  @$pb.TagNumber(9)
  void clearLossLessItem() => $_clearField(9);
  @$pb.TagNumber(9)
  LossLessItem ensureLossLessItem() => $_ensure(8);

  @$pb.TagNumber(10)
  $fixnum.Int64 get mainTimelength => $_getI64(9);
  @$pb.TagNumber(10)
  set mainTimelength($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMainTimelength() => $_has(9);
  @$pb.TagNumber(10)
  void clearMainTimelength() => $_clearField(10);
}

class ViewInfo extends $pb.GeneratedMessage {
  factory ViewInfo({
    $core.Iterable<$core.MapEntry<$core.String, Dialog>>? dialogMap,
    PromptBar? promptBar,
    $core.Iterable<ComprehensiveToast>? toasts,
  }) {
    final result = create();
    if (dialogMap != null) result.dialogMap.addEntries(dialogMap);
    if (promptBar != null) result.promptBar = promptBar;
    if (toasts != null) result.toasts.addAll(toasts);
    return result;
  }

  ViewInfo._();

  factory ViewInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ViewInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ViewInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..m<$core.String, Dialog>(1, _omitFieldNames ? '' : 'dialogMap',
        entryClassName: 'ViewInfo.DialogMapEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: Dialog.create,
        valueDefaultOrMaker: Dialog.getDefault,
        packageName: const $pb.PackageName('bilibili.app.playurl.v1'))
    ..aOM<PromptBar>(2, _omitFieldNames ? '' : 'promptBar',
        subBuilder: PromptBar.create)
    ..pPM<ComprehensiveToast>(3, _omitFieldNames ? '' : 'toasts',
        subBuilder: ComprehensiveToast.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewInfo copyWith(void Function(ViewInfo) updates) =>
      super.copyWith((message) => updates(message as ViewInfo)) as ViewInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ViewInfo create() => ViewInfo._();
  @$core.override
  ViewInfo createEmptyInstance() => create();
  static $pb.PbList<ViewInfo> createRepeated() => $pb.PbList<ViewInfo>();
  @$core.pragma('dart2js:noInline')
  static ViewInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ViewInfo>(create);
  static ViewInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, Dialog> get dialogMap => $_getMap(0);

  @$pb.TagNumber(2)
  PromptBar get promptBar => $_getN(1);
  @$pb.TagNumber(2)
  set promptBar(PromptBar value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPromptBar() => $_has(1);
  @$pb.TagNumber(2)
  void clearPromptBar() => $_clearField(2);
  @$pb.TagNumber(2)
  PromptBar ensurePromptBar() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<ComprehensiveToast> get toasts => $_getList(2);
}

class VipRisk extends $pb.GeneratedMessage {
  factory VipRisk({
    $core.bool? allow,
    $fixnum.Int64? type,
    $fixnum.Int64? reason,
    $fixnum.Int64? deviceStatus,
  }) {
    final result = create();
    if (allow != null) result.allow = allow;
    if (type != null) result.type = type;
    if (reason != null) result.reason = reason;
    if (deviceStatus != null) result.deviceStatus = deviceStatus;
    return result;
  }

  VipRisk._();

  factory VipRisk.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VipRisk.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VipRisk',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'allow')
    ..aInt64(2, _omitFieldNames ? '' : 'type')
    ..aInt64(3, _omitFieldNames ? '' : 'reason')
    ..aInt64(4, _omitFieldNames ? '' : 'deviceStatus')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VipRisk clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VipRisk copyWith(void Function(VipRisk) updates) =>
      super.copyWith((message) => updates(message as VipRisk)) as VipRisk;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VipRisk create() => VipRisk._();
  @$core.override
  VipRisk createEmptyInstance() => create();
  static $pb.PbList<VipRisk> createRepeated() => $pb.PbList<VipRisk>();
  @$core.pragma('dart2js:noInline')
  static VipRisk getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VipRisk>(create);
  static VipRisk? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get allow => $_getBF(0);
  @$pb.TagNumber(1)
  set allow($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAllow() => $_has(0);
  @$pb.TagNumber(1)
  void clearAllow() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get type => $_getI64(1);
  @$pb.TagNumber(2)
  set type($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get reason => $_getI64(2);
  @$pb.TagNumber(3)
  set reason($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get deviceStatus => $_getI64(3);
  @$pb.TagNumber(4)
  set deviceStatus($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDeviceStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeviceStatus() => $_clearField(4);
}

class VolumeInfo extends $pb.GeneratedMessage {
  factory VolumeInfo({
    $core.double? measuredI,
    $core.double? measuredLra,
    $core.double? measuredTp,
    $core.double? measuredThreshold,
    $core.double? targetOffset,
    $core.double? targetI,
    $core.double? targetTp,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? multiSceneArgs,
  }) {
    final result = create();
    if (measuredI != null) result.measuredI = measuredI;
    if (measuredLra != null) result.measuredLra = measuredLra;
    if (measuredTp != null) result.measuredTp = measuredTp;
    if (measuredThreshold != null) result.measuredThreshold = measuredThreshold;
    if (targetOffset != null) result.targetOffset = targetOffset;
    if (targetI != null) result.targetI = targetI;
    if (targetTp != null) result.targetTp = targetTp;
    if (multiSceneArgs != null)
      result.multiSceneArgs.addEntries(multiSceneArgs);
    return result;
  }

  VolumeInfo._();

  factory VolumeInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VolumeInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VolumeInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.playurl.v1'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'measuredI')
    ..aD(2, _omitFieldNames ? '' : 'measuredLra')
    ..aD(3, _omitFieldNames ? '' : 'measuredTp')
    ..aD(4, _omitFieldNames ? '' : 'measuredThreshold')
    ..aD(5, _omitFieldNames ? '' : 'targetOffset')
    ..aD(6, _omitFieldNames ? '' : 'targetI')
    ..aD(7, _omitFieldNames ? '' : 'targetTp')
    ..m<$core.String, $core.String>(8, _omitFieldNames ? '' : 'multiSceneArgs',
        entryClassName: 'VolumeInfo.MultiSceneArgsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.playurl.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VolumeInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VolumeInfo copyWith(void Function(VolumeInfo) updates) =>
      super.copyWith((message) => updates(message as VolumeInfo)) as VolumeInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VolumeInfo create() => VolumeInfo._();
  @$core.override
  VolumeInfo createEmptyInstance() => create();
  static $pb.PbList<VolumeInfo> createRepeated() => $pb.PbList<VolumeInfo>();
  @$core.pragma('dart2js:noInline')
  static VolumeInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VolumeInfo>(create);
  static VolumeInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get measuredI => $_getN(0);
  @$pb.TagNumber(1)
  set measuredI($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMeasuredI() => $_has(0);
  @$pb.TagNumber(1)
  void clearMeasuredI() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get measuredLra => $_getN(1);
  @$pb.TagNumber(2)
  set measuredLra($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMeasuredLra() => $_has(1);
  @$pb.TagNumber(2)
  void clearMeasuredLra() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get measuredTp => $_getN(2);
  @$pb.TagNumber(3)
  set measuredTp($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMeasuredTp() => $_has(2);
  @$pb.TagNumber(3)
  void clearMeasuredTp() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get measuredThreshold => $_getN(3);
  @$pb.TagNumber(4)
  set measuredThreshold($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMeasuredThreshold() => $_has(3);
  @$pb.TagNumber(4)
  void clearMeasuredThreshold() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get targetOffset => $_getN(4);
  @$pb.TagNumber(5)
  set targetOffset($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTargetOffset() => $_has(4);
  @$pb.TagNumber(5)
  void clearTargetOffset() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get targetI => $_getN(5);
  @$pb.TagNumber(6)
  set targetI($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTargetI() => $_has(5);
  @$pb.TagNumber(6)
  void clearTargetI() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get targetTp => $_getN(6);
  @$pb.TagNumber(7)
  set targetTp($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTargetTp() => $_has(6);
  @$pb.TagNumber(7)
  void clearTargetTp() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbMap<$core.String, $core.String> get multiSceneArgs => $_getMap(7);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
