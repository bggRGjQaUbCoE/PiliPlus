// This is a generated file - do not edit.
//
// Generated from bilibili/app/dynamic/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../archive/middleware/v1.pb.dart' as $1;
import 'v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'v1.pbenum.dart';

class AdInfo extends $pb.GeneratedMessage {
  factory AdInfo({
    $core.String? nationCode,
    $core.String? adcode,
    $core.String? cityCode,
    $core.String? name,
    Gps? gps,
  }) {
    final result = AdInfo._();
    if (nationCode != null) result.nationCode = nationCode;
    if (adcode != null) result.adcode = adcode;
    if (cityCode != null) result.cityCode = cityCode;
    if (name != null) result.name = name;
    if (gps != null) result.gps = gps;
    return result;
  }

  AdInfo._();

  factory AdInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AdInfo()..mergeFromBuffer(data, registry);
  factory AdInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AdInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: AdInfo.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'nationCode')
    ..aOS(2, _omitFieldNames ? '' : 'adcode')
    ..aOS(3, _omitFieldNames ? '' : 'cityCode')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOM<Gps>(5, _omitFieldNames ? '' : 'gps', subBuilder: Gps.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdInfo copyWith(void Function(AdInfo) updates) =>
      super.copyWith((message) => updates(message as AdInfo)) as AdInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AdInfo() / AdInfo.new instead')
  static AdInfo create() => AdInfo._();
  static $pb.GeneratedMessage $_createMessage() => AdInfo._();
  @$core.override
  AdInfo createEmptyInstance() => AdInfo._();
  @$core.pragma('dart2js:noInline')
  static AdInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdInfo>(AdInfo.$_createMessage);
  static AdInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nationCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set nationCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNationCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearNationCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get adcode => $_getSZ(1);
  @$pb.TagNumber(2)
  set adcode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAdcode() => $_has(1);
  @$pb.TagNumber(2)
  void clearAdcode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get cityCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set cityCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCityCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCityCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  @$pb.TagNumber(5)
  Gps get gps => $_getN(4);
  @$pb.TagNumber(5)
  set gps(Gps value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasGps() => $_has(4);
  @$pb.TagNumber(5)
  void clearGps() => $_clearField(5);
  @$pb.TagNumber(5)
  Gps ensureGps() => $_ensure(4);
}

class AddressComponent extends $pb.GeneratedMessage {
  factory AddressComponent({
    $core.String? nation,
    $core.String? province,
    $core.String? city,
    $core.String? district,
    $core.String? street,
    $core.String? streetNumber,
  }) {
    final result = AddressComponent._();
    if (nation != null) result.nation = nation;
    if (province != null) result.province = province;
    if (city != null) result.city = city;
    if (district != null) result.district = district;
    if (street != null) result.street = street;
    if (streetNumber != null) result.streetNumber = streetNumber;
    return result;
  }

  AddressComponent._();

  factory AddressComponent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddressComponent()..mergeFromBuffer(data, registry);
  factory AddressComponent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddressComponent()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddressComponent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: AddressComponent.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'nation')
    ..aOS(2, _omitFieldNames ? '' : 'province')
    ..aOS(3, _omitFieldNames ? '' : 'city')
    ..aOS(4, _omitFieldNames ? '' : 'district')
    ..aOS(5, _omitFieldNames ? '' : 'street')
    ..aOS(6, _omitFieldNames ? '' : 'streetNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddressComponent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddressComponent copyWith(void Function(AddressComponent) updates) =>
      super.copyWith((message) => updates(message as AddressComponent))
          as AddressComponent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AddressComponent() / AddressComponent.new instead')
  static AddressComponent create() => AddressComponent._();
  static $pb.GeneratedMessage $_createMessage() => AddressComponent._();
  @$core.override
  AddressComponent createEmptyInstance() => AddressComponent._();
  @$core.pragma('dart2js:noInline')
  static AddressComponent getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddressComponent>(
          AddressComponent.$_createMessage);
  static AddressComponent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nation => $_getSZ(0);
  @$pb.TagNumber(1)
  set nation($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNation() => $_has(0);
  @$pb.TagNumber(1)
  void clearNation() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get province => $_getSZ(1);
  @$pb.TagNumber(2)
  set province($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProvince() => $_has(1);
  @$pb.TagNumber(2)
  void clearProvince() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get city => $_getSZ(2);
  @$pb.TagNumber(3)
  set city($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCity() => $_has(2);
  @$pb.TagNumber(3)
  void clearCity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get district => $_getSZ(3);
  @$pb.TagNumber(4)
  set district($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDistrict() => $_has(3);
  @$pb.TagNumber(4)
  void clearDistrict() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get street => $_getSZ(4);
  @$pb.TagNumber(5)
  set street($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStreet() => $_has(4);
  @$pb.TagNumber(5)
  void clearStreet() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get streetNumber => $_getSZ(5);
  @$pb.TagNumber(6)
  set streetNumber($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasStreetNumber() => $_has(5);
  @$pb.TagNumber(6)
  void clearStreetNumber() => $_clearField(6);
}

class BubbleInfo extends $pb.GeneratedMessage {
  factory BubbleInfo({
    $core.Iterable<BubbleModule>? modules,
    $core.String? trackId,
    $core.String? bubbleRecallExtraWhenShow,
  }) {
    final result = BubbleInfo._();
    if (modules != null) result.modules.addAll(modules);
    if (trackId != null) result.trackId = trackId;
    if (bubbleRecallExtraWhenShow != null)
      result.bubbleRecallExtraWhenShow = bubbleRecallExtraWhenShow;
    return result;
  }

  BubbleInfo._();

  factory BubbleInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BubbleInfo()..mergeFromBuffer(data, registry);
  factory BubbleInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BubbleInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BubbleInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: BubbleInfo.$_createMessage)
    ..pPM<BubbleModule>(1, _omitFieldNames ? '' : 'modules',
        subBuilder: BubbleModule.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'trackId')
    ..aOS(3, _omitFieldNames ? '' : 'bubbleRecallExtraWhenShow')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BubbleInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BubbleInfo copyWith(void Function(BubbleInfo) updates) =>
      super.copyWith((message) => updates(message as BubbleInfo)) as BubbleInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BubbleInfo() / BubbleInfo.new instead')
  static BubbleInfo create() => BubbleInfo._();
  static $pb.GeneratedMessage $_createMessage() => BubbleInfo._();
  @$core.override
  BubbleInfo createEmptyInstance() => BubbleInfo._();
  @$core.pragma('dart2js:noInline')
  static BubbleInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BubbleInfo>(BubbleInfo.$_createMessage);
  static BubbleInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BubbleModule> get modules => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get trackId => $_getSZ(1);
  @$pb.TagNumber(2)
  set trackId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTrackId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTrackId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get bubbleRecallExtraWhenShow => $_getSZ(2);
  @$pb.TagNumber(3)
  set bubbleRecallExtraWhenShow($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBubbleRecallExtraWhenShow() => $_has(2);
  @$pb.TagNumber(3)
  void clearBubbleRecallExtraWhenShow() => $_clearField(3);
}

enum BubbleModule_Module { user, text, coloredTip, pic, notSet }

class BubbleModule extends $pb.GeneratedMessage {
  factory BubbleModule({
    BubbleModuleType? moduleType,
    BubbleModuleUser? user,
    BubbleModuleText? text,
    BubbleModuleColoredTip? coloredTip,
    BubbleModulePic? pic,
  }) {
    final result = BubbleModule._();
    if (moduleType != null) result.moduleType = moduleType;
    if (user != null) result.user = user;
    if (text != null) result.text = text;
    if (coloredTip != null) result.coloredTip = coloredTip;
    if (pic != null) result.pic = pic;
    return result;
  }

  BubbleModule._();

  factory BubbleModule.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BubbleModule()..mergeFromBuffer(data, registry);
  factory BubbleModule.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BubbleModule()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, BubbleModule_Module>
      _BubbleModule_ModuleByTag = {
    2: BubbleModule_Module.user,
    3: BubbleModule_Module.text,
    4: BubbleModule_Module.coloredTip,
    5: BubbleModule_Module.pic,
    0: BubbleModule_Module.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BubbleModule',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: BubbleModule.$_createMessage)
    ..oo(0, [2, 3, 4, 5])
    ..aE<BubbleModuleType>(1, _omitFieldNames ? '' : 'moduleType',
        enumValues: BubbleModuleType.values)
    ..aOM<BubbleModuleUser>(2, _omitFieldNames ? '' : 'user',
        subBuilder: BubbleModuleUser.$_createMessage)
    ..aOM<BubbleModuleText>(3, _omitFieldNames ? '' : 'text',
        subBuilder: BubbleModuleText.$_createMessage)
    ..aOM<BubbleModuleColoredTip>(4, _omitFieldNames ? '' : 'coloredTip',
        subBuilder: BubbleModuleColoredTip.$_createMessage)
    ..aOM<BubbleModulePic>(5, _omitFieldNames ? '' : 'pic',
        subBuilder: BubbleModulePic.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BubbleModule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BubbleModule copyWith(void Function(BubbleModule) updates) =>
      super.copyWith((message) => updates(message as BubbleModule))
          as BubbleModule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BubbleModule() / BubbleModule.new instead')
  static BubbleModule create() => BubbleModule._();
  static $pb.GeneratedMessage $_createMessage() => BubbleModule._();
  @$core.override
  BubbleModule createEmptyInstance() => BubbleModule._();
  @$core.pragma('dart2js:noInline')
  static BubbleModule getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BubbleModule>(
          BubbleModule.$_createMessage);
  static BubbleModule? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  BubbleModule_Module whichModule() =>
      _BubbleModule_ModuleByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearModule() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  BubbleModuleType get moduleType => $_getN(0);
  @$pb.TagNumber(1)
  set moduleType(BubbleModuleType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasModuleType() => $_has(0);
  @$pb.TagNumber(1)
  void clearModuleType() => $_clearField(1);

  @$pb.TagNumber(2)
  BubbleModuleUser get user => $_getN(1);
  @$pb.TagNumber(2)
  set user(BubbleModuleUser value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearUser() => $_clearField(2);
  @$pb.TagNumber(2)
  BubbleModuleUser ensureUser() => $_ensure(1);

  @$pb.TagNumber(3)
  BubbleModuleText get text => $_getN(2);
  @$pb.TagNumber(3)
  set text(BubbleModuleText value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);
  @$pb.TagNumber(3)
  BubbleModuleText ensureText() => $_ensure(2);

  @$pb.TagNumber(4)
  BubbleModuleColoredTip get coloredTip => $_getN(3);
  @$pb.TagNumber(4)
  set coloredTip(BubbleModuleColoredTip value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasColoredTip() => $_has(3);
  @$pb.TagNumber(4)
  void clearColoredTip() => $_clearField(4);
  @$pb.TagNumber(4)
  BubbleModuleColoredTip ensureColoredTip() => $_ensure(3);

  @$pb.TagNumber(5)
  BubbleModulePic get pic => $_getN(4);
  @$pb.TagNumber(5)
  set pic(BubbleModulePic value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPic() => $_has(4);
  @$pb.TagNumber(5)
  void clearPic() => $_clearField(5);
  @$pb.TagNumber(5)
  BubbleModulePic ensurePic() => $_ensure(4);
}

class BubbleModuleColoredTip extends $pb.GeneratedMessage {
  factory BubbleModuleColoredTip({
    $core.String? prefixIcon,
    $core.bool? isSvgaPrefixIcon,
    $core.String? text,
    Color? textColor,
  }) {
    final result = BubbleModuleColoredTip._();
    if (prefixIcon != null) result.prefixIcon = prefixIcon;
    if (isSvgaPrefixIcon != null) result.isSvgaPrefixIcon = isSvgaPrefixIcon;
    if (text != null) result.text = text;
    if (textColor != null) result.textColor = textColor;
    return result;
  }

  BubbleModuleColoredTip._();

  factory BubbleModuleColoredTip.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BubbleModuleColoredTip()..mergeFromBuffer(data, registry);
  factory BubbleModuleColoredTip.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BubbleModuleColoredTip()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BubbleModuleColoredTip',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: BubbleModuleColoredTip.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'prefixIcon')
    ..aOB(2, _omitFieldNames ? '' : 'isSvgaPrefixIcon')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..aOM<Color>(4, _omitFieldNames ? '' : 'textColor',
        subBuilder: Color.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BubbleModuleColoredTip clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BubbleModuleColoredTip copyWith(
          void Function(BubbleModuleColoredTip) updates) =>
      super.copyWith((message) => updates(message as BubbleModuleColoredTip))
          as BubbleModuleColoredTip;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BubbleModuleColoredTip() / BubbleModuleColoredTip.new instead')
  static BubbleModuleColoredTip create() => BubbleModuleColoredTip._();
  static $pb.GeneratedMessage $_createMessage() => BubbleModuleColoredTip._();
  @$core.override
  BubbleModuleColoredTip createEmptyInstance() => BubbleModuleColoredTip._();
  @$core.pragma('dart2js:noInline')
  static BubbleModuleColoredTip getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BubbleModuleColoredTip>(
          BubbleModuleColoredTip.$_createMessage);
  static BubbleModuleColoredTip? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get prefixIcon => $_getSZ(0);
  @$pb.TagNumber(1)
  set prefixIcon($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrefixIcon() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrefixIcon() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isSvgaPrefixIcon => $_getBF(1);
  @$pb.TagNumber(2)
  set isSvgaPrefixIcon($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsSvgaPrefixIcon() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsSvgaPrefixIcon() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  @$pb.TagNumber(4)
  Color get textColor => $_getN(3);
  @$pb.TagNumber(4)
  set textColor(Color value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTextColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearTextColor() => $_clearField(4);
  @$pb.TagNumber(4)
  Color ensureTextColor() => $_ensure(3);
}

class BubbleModulePic extends $pb.GeneratedMessage {
  factory BubbleModulePic({
    $core.String? picDay,
    $core.String? picNight,
    $fixnum.Int64? picWidth,
    $fixnum.Int64? picHeight,
    $core.bool? roundedCorner,
    $fixnum.Int64? roundedCornerRadius,
  }) {
    final result = BubbleModulePic._();
    if (picDay != null) result.picDay = picDay;
    if (picNight != null) result.picNight = picNight;
    if (picWidth != null) result.picWidth = picWidth;
    if (picHeight != null) result.picHeight = picHeight;
    if (roundedCorner != null) result.roundedCorner = roundedCorner;
    if (roundedCornerRadius != null)
      result.roundedCornerRadius = roundedCornerRadius;
    return result;
  }

  BubbleModulePic._();

  factory BubbleModulePic.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BubbleModulePic()..mergeFromBuffer(data, registry);
  factory BubbleModulePic.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BubbleModulePic()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BubbleModulePic',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: BubbleModulePic.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'picDay')
    ..aOS(2, _omitFieldNames ? '' : 'picNight')
    ..aInt64(3, _omitFieldNames ? '' : 'picWidth')
    ..aInt64(4, _omitFieldNames ? '' : 'picHeight')
    ..aOB(5, _omitFieldNames ? '' : 'roundedCorner')
    ..aInt64(6, _omitFieldNames ? '' : 'roundedCornerRadius')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BubbleModulePic clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BubbleModulePic copyWith(void Function(BubbleModulePic) updates) =>
      super.copyWith((message) => updates(message as BubbleModulePic))
          as BubbleModulePic;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BubbleModulePic() / BubbleModulePic.new instead')
  static BubbleModulePic create() => BubbleModulePic._();
  static $pb.GeneratedMessage $_createMessage() => BubbleModulePic._();
  @$core.override
  BubbleModulePic createEmptyInstance() => BubbleModulePic._();
  @$core.pragma('dart2js:noInline')
  static BubbleModulePic getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BubbleModulePic>(
          BubbleModulePic.$_createMessage);
  static BubbleModulePic? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get picDay => $_getSZ(0);
  @$pb.TagNumber(1)
  set picDay($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPicDay() => $_has(0);
  @$pb.TagNumber(1)
  void clearPicDay() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get picNight => $_getSZ(1);
  @$pb.TagNumber(2)
  set picNight($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPicNight() => $_has(1);
  @$pb.TagNumber(2)
  void clearPicNight() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get picWidth => $_getI64(2);
  @$pb.TagNumber(3)
  set picWidth($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPicWidth() => $_has(2);
  @$pb.TagNumber(3)
  void clearPicWidth() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get picHeight => $_getI64(3);
  @$pb.TagNumber(4)
  set picHeight($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPicHeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearPicHeight() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get roundedCorner => $_getBF(4);
  @$pb.TagNumber(5)
  set roundedCorner($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRoundedCorner() => $_has(4);
  @$pb.TagNumber(5)
  void clearRoundedCorner() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get roundedCornerRadius => $_getI64(5);
  @$pb.TagNumber(6)
  set roundedCornerRadius($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRoundedCornerRadius() => $_has(5);
  @$pb.TagNumber(6)
  void clearRoundedCornerRadius() => $_clearField(6);
}

class BubbleModuleText extends $pb.GeneratedMessage {
  factory BubbleModuleText({
    $core.String? content,
  }) {
    final result = BubbleModuleText._();
    if (content != null) result.content = content;
    return result;
  }

  BubbleModuleText._();

  factory BubbleModuleText.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BubbleModuleText()..mergeFromBuffer(data, registry);
  factory BubbleModuleText.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BubbleModuleText()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BubbleModuleText',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: BubbleModuleText.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BubbleModuleText clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BubbleModuleText copyWith(void Function(BubbleModuleText) updates) =>
      super.copyWith((message) => updates(message as BubbleModuleText))
          as BubbleModuleText;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BubbleModuleText() / BubbleModuleText.new instead')
  static BubbleModuleText create() => BubbleModuleText._();
  static $pb.GeneratedMessage $_createMessage() => BubbleModuleText._();
  @$core.override
  BubbleModuleText createEmptyInstance() => BubbleModuleText._();
  @$core.pragma('dart2js:noInline')
  static BubbleModuleText getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BubbleModuleText>(
          BubbleModuleText.$_createMessage);
  static BubbleModuleText? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get content => $_getSZ(0);
  @$pb.TagNumber(1)
  set content($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => $_clearField(1);
}

class BubbleModuleUser extends $pb.GeneratedMessage {
  factory BubbleModuleUser({
    $core.Iterable<UserInfo>? users,
  }) {
    final result = BubbleModuleUser._();
    if (users != null) result.users.addAll(users);
    return result;
  }

  BubbleModuleUser._();

  factory BubbleModuleUser.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BubbleModuleUser()..mergeFromBuffer(data, registry);
  factory BubbleModuleUser.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BubbleModuleUser()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BubbleModuleUser',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: BubbleModuleUser.$_createMessage)
    ..pPM<UserInfo>(1, _omitFieldNames ? '' : 'users',
        subBuilder: UserInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BubbleModuleUser clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BubbleModuleUser copyWith(void Function(BubbleModuleUser) updates) =>
      super.copyWith((message) => updates(message as BubbleModuleUser))
          as BubbleModuleUser;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BubbleModuleUser() / BubbleModuleUser.new instead')
  static BubbleModuleUser create() => BubbleModuleUser._();
  static $pb.GeneratedMessage $_createMessage() => BubbleModuleUser._();
  @$core.override
  BubbleModuleUser createEmptyInstance() => BubbleModuleUser._();
  @$core.pragma('dart2js:noInline')
  static BubbleModuleUser getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BubbleModuleUser>(
          BubbleModuleUser.$_createMessage);
  static BubbleModuleUser? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<UserInfo> get users => $_getList(0);
}

/// 付费课程批次卡片数据
class CardCurrBatch extends $pb.GeneratedMessage {
  factory CardCurrBatch({
    $core.String? title,
    $core.String? cover,
    $core.String? uri,
    $core.String? text1,
    $core.String? text2,
    VideoBadge? badge,
  }) {
    final result = CardCurrBatch._();
    if (title != null) result.title = title;
    if (cover != null) result.cover = cover;
    if (uri != null) result.uri = uri;
    if (text1 != null) result.text1 = text1;
    if (text2 != null) result.text2 = text2;
    if (badge != null) result.badge = badge;
    return result;
  }

  CardCurrBatch._();

  factory CardCurrBatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CardCurrBatch()..mergeFromBuffer(data, registry);
  factory CardCurrBatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CardCurrBatch()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CardCurrBatch',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: CardCurrBatch.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'cover')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..aOS(4, _omitFieldNames ? '' : 'text1')
    ..aOS(5, _omitFieldNames ? '' : 'text2')
    ..aOM<VideoBadge>(6, _omitFieldNames ? '' : 'badge',
        subBuilder: VideoBadge.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardCurrBatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardCurrBatch copyWith(void Function(CardCurrBatch) updates) =>
      super.copyWith((message) => updates(message as CardCurrBatch))
          as CardCurrBatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CardCurrBatch() / CardCurrBatch.new instead')
  static CardCurrBatch create() => CardCurrBatch._();
  static $pb.GeneratedMessage $_createMessage() => CardCurrBatch._();
  @$core.override
  CardCurrBatch createEmptyInstance() => CardCurrBatch._();
  @$core.pragma('dart2js:noInline')
  static CardCurrBatch getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CardCurrBatch>(
          CardCurrBatch.$_createMessage);
  static CardCurrBatch? _defaultInstance;

  /// 标题
  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  /// 封面
  @$pb.TagNumber(2)
  $core.String get cover => $_getSZ(1);
  @$pb.TagNumber(2)
  set cover($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCover() => $_has(1);
  @$pb.TagNumber(2)
  void clearCover() => $_clearField(2);

  /// 跳转地址
  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);

  /// 展示项 1: 本集标题
  @$pb.TagNumber(4)
  $core.String get text1 => $_getSZ(3);
  @$pb.TagNumber(4)
  set text1($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasText1() => $_has(3);
  @$pb.TagNumber(4)
  void clearText1() => $_clearField(4);

  /// 展示项 2: 更新了多少个视频
  @$pb.TagNumber(5)
  $core.String get text2 => $_getSZ(4);
  @$pb.TagNumber(5)
  set text2($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasText2() => $_has(4);
  @$pb.TagNumber(5)
  void clearText2() => $_clearField(5);

  /// 角标
  @$pb.TagNumber(6)
  VideoBadge get badge => $_getN(5);
  @$pb.TagNumber(6)
  set badge(VideoBadge value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasBadge() => $_has(5);
  @$pb.TagNumber(6)
  void clearBadge() => $_clearField(6);
  @$pb.TagNumber(6)
  VideoBadge ensureBadge() => $_ensure(5);
}

/// 付费课程系列卡片数据
class CardCurrSeason extends $pb.GeneratedMessage {
  factory CardCurrSeason({
    $core.String? title,
    $core.String? cover,
    $core.String? uri,
    $core.String? text1,
    $core.String? desc,
    VideoBadge? badge,
  }) {
    final result = CardCurrSeason._();
    if (title != null) result.title = title;
    if (cover != null) result.cover = cover;
    if (uri != null) result.uri = uri;
    if (text1 != null) result.text1 = text1;
    if (desc != null) result.desc = desc;
    if (badge != null) result.badge = badge;
    return result;
  }

  CardCurrSeason._();

  factory CardCurrSeason.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CardCurrSeason()..mergeFromBuffer(data, registry);
  factory CardCurrSeason.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CardCurrSeason()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CardCurrSeason',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: CardCurrSeason.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'cover')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..aOS(4, _omitFieldNames ? '' : 'text1')
    ..aOS(5, _omitFieldNames ? '' : 'desc')
    ..aOM<VideoBadge>(6, _omitFieldNames ? '' : 'badge',
        subBuilder: VideoBadge.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardCurrSeason clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardCurrSeason copyWith(void Function(CardCurrSeason) updates) =>
      super.copyWith((message) => updates(message as CardCurrSeason))
          as CardCurrSeason;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CardCurrSeason() / CardCurrSeason.new instead')
  static CardCurrSeason create() => CardCurrSeason._();
  static $pb.GeneratedMessage $_createMessage() => CardCurrSeason._();
  @$core.override
  CardCurrSeason createEmptyInstance() => CardCurrSeason._();
  @$core.pragma('dart2js:noInline')
  static CardCurrSeason getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CardCurrSeason>(
          CardCurrSeason.$_createMessage);
  static CardCurrSeason? _defaultInstance;

  /// 标题
  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  /// 封面
  @$pb.TagNumber(2)
  $core.String get cover => $_getSZ(1);
  @$pb.TagNumber(2)
  set cover($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCover() => $_has(1);
  @$pb.TagNumber(2)
  void clearCover() => $_clearField(2);

  /// 跳转地址
  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);

  /// 展示项 1 (展示更新信息)
  @$pb.TagNumber(4)
  $core.String get text1 => $_getSZ(3);
  @$pb.TagNumber(4)
  set text1($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasText1() => $_has(3);
  @$pb.TagNumber(4)
  void clearText1() => $_clearField(4);

  /// 描述信息
  @$pb.TagNumber(5)
  $core.String get desc => $_getSZ(4);
  @$pb.TagNumber(5)
  set desc($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDesc() => $_has(4);
  @$pb.TagNumber(5)
  void clearDesc() => $_clearField(5);

  /// 角标
  @$pb.TagNumber(6)
  VideoBadge get badge => $_getN(5);
  @$pb.TagNumber(6)
  set badge(VideoBadge value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasBadge() => $_has(5);
  @$pb.TagNumber(6)
  void clearBadge() => $_clearField(6);
  @$pb.TagNumber(6)
  VideoBadge ensureBadge() => $_ensure(5);
}

/// PGC 视频卡片数据
class CardPGC extends $pb.GeneratedMessage {
  factory CardPGC({
    $core.String? title,
    $core.String? cover,
    $core.String? uri,
    $core.String? coverLeftText1,
    $core.String? coverLeftText2,
    $core.String? coverLeftText3,
    $fixnum.Int64? cid,
    $fixnum.Int64? seasonId,
    $fixnum.Int64? epid,
    $fixnum.Int64? aid,
    MediaType? mediaType,
    VideoSubType? subType,
    $core.int? isPreview,
    Dimension? dimension,
    $core.Iterable<VideoBadge>? badge,
    $core.int? canPlay,
    PGCSeason? season,
  }) {
    final result = CardPGC._();
    if (title != null) result.title = title;
    if (cover != null) result.cover = cover;
    if (uri != null) result.uri = uri;
    if (coverLeftText1 != null) result.coverLeftText1 = coverLeftText1;
    if (coverLeftText2 != null) result.coverLeftText2 = coverLeftText2;
    if (coverLeftText3 != null) result.coverLeftText3 = coverLeftText3;
    if (cid != null) result.cid = cid;
    if (seasonId != null) result.seasonId = seasonId;
    if (epid != null) result.epid = epid;
    if (aid != null) result.aid = aid;
    if (mediaType != null) result.mediaType = mediaType;
    if (subType != null) result.subType = subType;
    if (isPreview != null) result.isPreview = isPreview;
    if (dimension != null) result.dimension = dimension;
    if (badge != null) result.badge.addAll(badge);
    if (canPlay != null) result.canPlay = canPlay;
    if (season != null) result.season = season;
    return result;
  }

  CardPGC._();

  factory CardPGC.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CardPGC()..mergeFromBuffer(data, registry);
  factory CardPGC.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CardPGC()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CardPGC',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: CardPGC.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'cover')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..aOS(4, _omitFieldNames ? '' : 'coverLeftText1')
    ..aOS(5, _omitFieldNames ? '' : 'coverLeftText2')
    ..aOS(6, _omitFieldNames ? '' : 'coverLeftText3')
    ..aInt64(7, _omitFieldNames ? '' : 'cid')
    ..aInt64(8, _omitFieldNames ? '' : 'seasonId')
    ..aInt64(9, _omitFieldNames ? '' : 'epid')
    ..aInt64(10, _omitFieldNames ? '' : 'aid')
    ..aE<MediaType>(11, _omitFieldNames ? '' : 'mediaType',
        enumValues: MediaType.values)
    ..aE<VideoSubType>(12, _omitFieldNames ? '' : 'subType',
        enumValues: VideoSubType.values)
    ..aI(13, _omitFieldNames ? '' : 'isPreview')
    ..aOM<Dimension>(14, _omitFieldNames ? '' : 'dimension',
        subBuilder: Dimension.$_createMessage)
    ..pPM<VideoBadge>(15, _omitFieldNames ? '' : 'badge',
        subBuilder: VideoBadge.$_createMessage)
    ..aI(16, _omitFieldNames ? '' : 'canPlay')
    ..aOM<PGCSeason>(17, _omitFieldNames ? '' : 'season',
        subBuilder: PGCSeason.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardPGC clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardPGC copyWith(void Function(CardPGC) updates) =>
      super.copyWith((message) => updates(message as CardPGC)) as CardPGC;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CardPGC() / CardPGC.new instead')
  static CardPGC create() => CardPGC._();
  static $pb.GeneratedMessage $_createMessage() => CardPGC._();
  @$core.override
  CardPGC createEmptyInstance() => CardPGC._();
  @$core.pragma('dart2js:noInline')
  static CardPGC getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CardPGC>(CardPGC.$_createMessage);
  static CardPGC? _defaultInstance;

  /// 标题
  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  /// 封面
  @$pb.TagNumber(2)
  $core.String get cover => $_getSZ(1);
  @$pb.TagNumber(2)
  set cover($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCover() => $_has(1);
  @$pb.TagNumber(2)
  void clearCover() => $_clearField(2);

  /// 秒开地址
  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);

  /// 视频封面展示项 1
  @$pb.TagNumber(4)
  $core.String get coverLeftText1 => $_getSZ(3);
  @$pb.TagNumber(4)
  set coverLeftText1($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverLeftText1() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverLeftText1() => $_clearField(4);

  /// 视频封面展示项 2
  @$pb.TagNumber(5)
  $core.String get coverLeftText2 => $_getSZ(4);
  @$pb.TagNumber(5)
  set coverLeftText2($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCoverLeftText2() => $_has(4);
  @$pb.TagNumber(5)
  void clearCoverLeftText2() => $_clearField(5);

  /// 视频封面展示项 3
  @$pb.TagNumber(6)
  $core.String get coverLeftText3 => $_getSZ(5);
  @$pb.TagNumber(6)
  set coverLeftText3($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCoverLeftText3() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoverLeftText3() => $_clearField(6);

  /// 视频 cid
  @$pb.TagNumber(7)
  $fixnum.Int64 get cid => $_getI64(6);
  @$pb.TagNumber(7)
  set cid($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCid() => $_has(6);
  @$pb.TagNumber(7)
  void clearCid() => $_clearField(7);

  /// PGC 剧集 ID
  @$pb.TagNumber(8)
  $fixnum.Int64 get seasonId => $_getI64(7);
  @$pb.TagNumber(8)
  set seasonId($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSeasonId() => $_has(7);
  @$pb.TagNumber(8)
  void clearSeasonId() => $_clearField(8);

  /// PGC 剧集分集 ID
  @$pb.TagNumber(9)
  $fixnum.Int64 get epid => $_getI64(8);
  @$pb.TagNumber(9)
  set epid($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEpid() => $_has(8);
  @$pb.TagNumber(9)
  void clearEpid() => $_clearField(9);

  /// 视频 avid
  @$pb.TagNumber(10)
  $fixnum.Int64 get aid => $_getI64(9);
  @$pb.TagNumber(10)
  set aid($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAid() => $_has(9);
  @$pb.TagNumber(10)
  void clearAid() => $_clearField(10);

  /// 视频源类型
  @$pb.TagNumber(11)
  MediaType get mediaType => $_getN(10);
  @$pb.TagNumber(11)
  set mediaType(MediaType value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasMediaType() => $_has(10);
  @$pb.TagNumber(11)
  void clearMediaType() => $_clearField(11);

  /// 番剧类型
  @$pb.TagNumber(12)
  VideoSubType get subType => $_getN(11);
  @$pb.TagNumber(12)
  set subType(VideoSubType value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasSubType() => $_has(11);
  @$pb.TagNumber(12)
  void clearSubType() => $_clearField(12);

  /// 番剧是否为预览视频
  @$pb.TagNumber(13)
  $core.int get isPreview => $_getIZ(12);
  @$pb.TagNumber(13)
  set isPreview($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasIsPreview() => $_has(12);
  @$pb.TagNumber(13)
  void clearIsPreview() => $_clearField(13);

  /// 分辨率
  @$pb.TagNumber(14)
  Dimension get dimension => $_getN(13);
  @$pb.TagNumber(14)
  set dimension(Dimension value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasDimension() => $_has(13);
  @$pb.TagNumber(14)
  void clearDimension() => $_clearField(14);
  @$pb.TagNumber(14)
  Dimension ensureDimension() => $_ensure(13);

  /// 角标
  @$pb.TagNumber(15)
  $pb.PbList<VideoBadge> get badge => $_getList(14);

  /// 是否能够自动播放
  @$pb.TagNumber(16)
  $core.int get canPlay => $_getIZ(15);
  @$pb.TagNumber(16)
  set canPlay($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasCanPlay() => $_has(15);
  @$pb.TagNumber(16)
  void clearCanPlay() => $_clearField(16);

  /// PGC 剧集信息
  @$pb.TagNumber(17)
  PGCSeason get season => $_getN(16);
  @$pb.TagNumber(17)
  set season(PGCSeason value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasSeason() => $_has(16);
  @$pb.TagNumber(17)
  void clearSeason() => $_clearField(17);
  @$pb.TagNumber(17)
  PGCSeason ensureSeason() => $_ensure(16);
}

/// UGC 视频卡片数据
class CardUGC extends $pb.GeneratedMessage {
  factory CardUGC({
    $core.String? title,
    $core.String? cover,
    $core.String? uri,
    $core.String? coverLeftText1,
    $core.String? coverLeftText2,
    $core.String? coverLeftText3,
    $fixnum.Int64? avid,
    $fixnum.Int64? cid,
    MediaType? mediaType,
    Dimension? dimension,
    $core.Iterable<VideoBadge>? badge,
    $core.int? canPlay,
  }) {
    final result = CardUGC._();
    if (title != null) result.title = title;
    if (cover != null) result.cover = cover;
    if (uri != null) result.uri = uri;
    if (coverLeftText1 != null) result.coverLeftText1 = coverLeftText1;
    if (coverLeftText2 != null) result.coverLeftText2 = coverLeftText2;
    if (coverLeftText3 != null) result.coverLeftText3 = coverLeftText3;
    if (avid != null) result.avid = avid;
    if (cid != null) result.cid = cid;
    if (mediaType != null) result.mediaType = mediaType;
    if (dimension != null) result.dimension = dimension;
    if (badge != null) result.badge.addAll(badge);
    if (canPlay != null) result.canPlay = canPlay;
    return result;
  }

  CardUGC._();

  factory CardUGC.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CardUGC()..mergeFromBuffer(data, registry);
  factory CardUGC.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CardUGC()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CardUGC',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: CardUGC.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'cover')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..aOS(4, _omitFieldNames ? '' : 'coverLeftText1')
    ..aOS(5, _omitFieldNames ? '' : 'coverLeftText2')
    ..aOS(6, _omitFieldNames ? '' : 'coverLeftText3')
    ..aInt64(7, _omitFieldNames ? '' : 'avid')
    ..aInt64(8, _omitFieldNames ? '' : 'cid')
    ..aE<MediaType>(9, _omitFieldNames ? '' : 'mediaType',
        enumValues: MediaType.values)
    ..aOM<Dimension>(10, _omitFieldNames ? '' : 'dimension',
        subBuilder: Dimension.$_createMessage)
    ..pPM<VideoBadge>(11, _omitFieldNames ? '' : 'badge',
        subBuilder: VideoBadge.$_createMessage)
    ..aI(12, _omitFieldNames ? '' : 'canPlay')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardUGC clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardUGC copyWith(void Function(CardUGC) updates) =>
      super.copyWith((message) => updates(message as CardUGC)) as CardUGC;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CardUGC() / CardUGC.new instead')
  static CardUGC create() => CardUGC._();
  static $pb.GeneratedMessage $_createMessage() => CardUGC._();
  @$core.override
  CardUGC createEmptyInstance() => CardUGC._();
  @$core.pragma('dart2js:noInline')
  static CardUGC getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CardUGC>(CardUGC.$_createMessage);
  static CardUGC? _defaultInstance;

  /// 标题
  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  /// 封面图
  @$pb.TagNumber(2)
  $core.String get cover => $_getSZ(1);
  @$pb.TagNumber(2)
  set cover($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCover() => $_has(1);
  @$pb.TagNumber(2)
  void clearCover() => $_clearField(2);

  /// 秒开地址
  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);

  /// 视频封面展示项 1
  @$pb.TagNumber(4)
  $core.String get coverLeftText1 => $_getSZ(3);
  @$pb.TagNumber(4)
  set coverLeftText1($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverLeftText1() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverLeftText1() => $_clearField(4);

  /// 视频封面展示项 2
  @$pb.TagNumber(5)
  $core.String get coverLeftText2 => $_getSZ(4);
  @$pb.TagNumber(5)
  set coverLeftText2($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCoverLeftText2() => $_has(4);
  @$pb.TagNumber(5)
  void clearCoverLeftText2() => $_clearField(5);

  /// 视频封面展示项 3
  @$pb.TagNumber(6)
  $core.String get coverLeftText3 => $_getSZ(5);
  @$pb.TagNumber(6)
  set coverLeftText3($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCoverLeftText3() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoverLeftText3() => $_clearField(6);

  /// 视频 avid
  @$pb.TagNumber(7)
  $fixnum.Int64 get avid => $_getI64(6);
  @$pb.TagNumber(7)
  set avid($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAvid() => $_has(6);
  @$pb.TagNumber(7)
  void clearAvid() => $_clearField(7);

  /// 视频 cid
  @$pb.TagNumber(8)
  $fixnum.Int64 get cid => $_getI64(7);
  @$pb.TagNumber(8)
  set cid($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCid() => $_has(7);
  @$pb.TagNumber(8)
  void clearCid() => $_clearField(8);

  /// 视频源类型
  @$pb.TagNumber(9)
  MediaType get mediaType => $_getN(8);
  @$pb.TagNumber(9)
  set mediaType(MediaType value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasMediaType() => $_has(8);
  @$pb.TagNumber(9)
  void clearMediaType() => $_clearField(9);

  /// 分辨率
  @$pb.TagNumber(10)
  Dimension get dimension => $_getN(9);
  @$pb.TagNumber(10)
  set dimension(Dimension value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasDimension() => $_has(9);
  @$pb.TagNumber(10)
  void clearDimension() => $_clearField(10);
  @$pb.TagNumber(10)
  Dimension ensureDimension() => $_ensure(9);

  /// 角标
  @$pb.TagNumber(11)
  $pb.PbList<VideoBadge> get badge => $_getList(10);

  /// 是否能够自动播放
  @$pb.TagNumber(12)
  $core.int get canPlay => $_getIZ(11);
  @$pb.TagNumber(12)
  set canPlay($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasCanPlay() => $_has(11);
  @$pb.TagNumber(12)
  void clearCanPlay() => $_clearField(12);
}

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
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
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

class CornerInfo extends $pb.GeneratedMessage {
  factory CornerInfo({
    CornerType? cornerType,
    $core.String? cornerText,
    Color? cornerTextColor,
    Color? cornerTextBgColor,
    $core.String? cornerIcon,
    $fixnum.Int64? cornerNumber,
  }) {
    final result = CornerInfo._();
    if (cornerType != null) result.cornerType = cornerType;
    if (cornerText != null) result.cornerText = cornerText;
    if (cornerTextColor != null) result.cornerTextColor = cornerTextColor;
    if (cornerTextBgColor != null) result.cornerTextBgColor = cornerTextBgColor;
    if (cornerIcon != null) result.cornerIcon = cornerIcon;
    if (cornerNumber != null) result.cornerNumber = cornerNumber;
    return result;
  }

  CornerInfo._();

  factory CornerInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CornerInfo()..mergeFromBuffer(data, registry);
  factory CornerInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CornerInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CornerInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: CornerInfo.$_createMessage)
    ..aE<CornerType>(1, _omitFieldNames ? '' : 'cornerType',
        enumValues: CornerType.values)
    ..aOS(2, _omitFieldNames ? '' : 'cornerText')
    ..aOM<Color>(3, _omitFieldNames ? '' : 'cornerTextColor',
        subBuilder: Color.$_createMessage)
    ..aOM<Color>(4, _omitFieldNames ? '' : 'cornerTextBgColor',
        subBuilder: Color.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'cornerIcon')
    ..aInt64(6, _omitFieldNames ? '' : 'cornerNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CornerInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CornerInfo copyWith(void Function(CornerInfo) updates) =>
      super.copyWith((message) => updates(message as CornerInfo)) as CornerInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CornerInfo() / CornerInfo.new instead')
  static CornerInfo create() => CornerInfo._();
  static $pb.GeneratedMessage $_createMessage() => CornerInfo._();
  @$core.override
  CornerInfo createEmptyInstance() => CornerInfo._();
  @$core.pragma('dart2js:noInline')
  static CornerInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CornerInfo>(CornerInfo.$_createMessage);
  static CornerInfo? _defaultInstance;

  @$pb.TagNumber(1)
  CornerType get cornerType => $_getN(0);
  @$pb.TagNumber(1)
  set cornerType(CornerType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCornerType() => $_has(0);
  @$pb.TagNumber(1)
  void clearCornerType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cornerText => $_getSZ(1);
  @$pb.TagNumber(2)
  set cornerText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCornerText() => $_has(1);
  @$pb.TagNumber(2)
  void clearCornerText() => $_clearField(2);

  @$pb.TagNumber(3)
  Color get cornerTextColor => $_getN(2);
  @$pb.TagNumber(3)
  set cornerTextColor(Color value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCornerTextColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearCornerTextColor() => $_clearField(3);
  @$pb.TagNumber(3)
  Color ensureCornerTextColor() => $_ensure(2);

  @$pb.TagNumber(4)
  Color get cornerTextBgColor => $_getN(3);
  @$pb.TagNumber(4)
  set cornerTextBgColor(Color value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCornerTextBgColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearCornerTextBgColor() => $_clearField(4);
  @$pb.TagNumber(4)
  Color ensureCornerTextBgColor() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get cornerIcon => $_getSZ(4);
  @$pb.TagNumber(5)
  set cornerIcon($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCornerIcon() => $_has(4);
  @$pb.TagNumber(5)
  void clearCornerIcon() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get cornerNumber => $_getI64(5);
  @$pb.TagNumber(6)
  set cornerNumber($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCornerNumber() => $_has(5);
  @$pb.TagNumber(6)
  void clearCornerNumber() => $_clearField(6);
}

/// 粉丝样式
class DecoCardFan extends $pb.GeneratedMessage {
  factory DecoCardFan({
    $core.int? isFan,
    $core.int? number,
    $core.String? color,
  }) {
    final result = DecoCardFan._();
    if (isFan != null) result.isFan = isFan;
    if (number != null) result.number = number;
    if (color != null) result.color = color;
    return result;
  }

  DecoCardFan._();

  factory DecoCardFan.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DecoCardFan()..mergeFromBuffer(data, registry);
  factory DecoCardFan.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DecoCardFan()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DecoCardFan',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DecoCardFan.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'isFan')
    ..aI(2, _omitFieldNames ? '' : 'number')
    ..aOS(3, _omitFieldNames ? '' : 'color')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecoCardFan clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecoCardFan copyWith(void Function(DecoCardFan) updates) =>
      super.copyWith((message) => updates(message as DecoCardFan))
          as DecoCardFan;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DecoCardFan() / DecoCardFan.new instead')
  static DecoCardFan create() => DecoCardFan._();
  static $pb.GeneratedMessage $_createMessage() => DecoCardFan._();
  @$core.override
  DecoCardFan createEmptyInstance() => DecoCardFan._();
  @$core.pragma('dart2js:noInline')
  static DecoCardFan getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DecoCardFan>(
          DecoCardFan.$_createMessage);
  static DecoCardFan? _defaultInstance;

  /// 是否是粉丝
  @$pb.TagNumber(1)
  $core.int get isFan => $_getIZ(0);
  @$pb.TagNumber(1)
  set isFan($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsFan() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsFan() => $_clearField(1);

  /// 数量
  @$pb.TagNumber(2)
  $core.int get number => $_getIZ(1);
  @$pb.TagNumber(2)
  set number($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumber() => $_clearField(2);

  /// 颜色
  @$pb.TagNumber(3)
  $core.String get color => $_getSZ(2);
  @$pb.TagNumber(3)
  set color($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearColor() => $_clearField(3);
}

/// 装扮卡片
class DecorateCard extends $pb.GeneratedMessage {
  factory DecorateCard({
    $fixnum.Int64? id,
    $core.String? cardUrl,
    $core.String? jumpUrl,
    DecoCardFan? fan,
  }) {
    final result = DecorateCard._();
    if (id != null) result.id = id;
    if (cardUrl != null) result.cardUrl = cardUrl;
    if (jumpUrl != null) result.jumpUrl = jumpUrl;
    if (fan != null) result.fan = fan;
    return result;
  }

  DecorateCard._();

  factory DecorateCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DecorateCard()..mergeFromBuffer(data, registry);
  factory DecorateCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DecorateCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DecorateCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DecorateCard.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'cardUrl')
    ..aOS(3, _omitFieldNames ? '' : 'jumpUrl')
    ..aOM<DecoCardFan>(4, _omitFieldNames ? '' : 'fan',
        subBuilder: DecoCardFan.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecorateCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecorateCard copyWith(void Function(DecorateCard) updates) =>
      super.copyWith((message) => updates(message as DecorateCard))
          as DecorateCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DecorateCard() / DecorateCard.new instead')
  static DecorateCard create() => DecorateCard._();
  static $pb.GeneratedMessage $_createMessage() => DecorateCard._();
  @$core.override
  DecorateCard createEmptyInstance() => DecorateCard._();
  @$core.pragma('dart2js:noInline')
  static DecorateCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DecorateCard>(
          DecorateCard.$_createMessage);
  static DecorateCard? _defaultInstance;

  /// 装扮卡片 ID
  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// 装扮卡片链接
  @$pb.TagNumber(2)
  $core.String get cardUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set cardUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCardUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearCardUrl() => $_clearField(2);

  /// 装扮卡片点击跳转链接
  @$pb.TagNumber(3)
  $core.String get jumpUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set jumpUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasJumpUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearJumpUrl() => $_clearField(3);

  /// 粉丝样式
  @$pb.TagNumber(4)
  DecoCardFan get fan => $_getN(3);
  @$pb.TagNumber(4)
  set fan(DecoCardFan value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFan() => $_has(3);
  @$pb.TagNumber(4)
  void clearFan() => $_clearField(4);
  @$pb.TagNumber(4)
  DecoCardFan ensureFan() => $_ensure(3);
}

/// 文本描述
class Description extends $pb.GeneratedMessage {
  factory Description({
    $core.String? text,
    $core.String? type,
    $core.String? uri,
    $core.String? emojiType,
    $core.String? goodsType,
  }) {
    final result = Description._();
    if (text != null) result.text = text;
    if (type != null) result.type = type;
    if (uri != null) result.uri = uri;
    if (emojiType != null) result.emojiType = emojiType;
    if (goodsType != null) result.goodsType = goodsType;
    return result;
  }

  Description._();

  factory Description.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Description()..mergeFromBuffer(data, registry);
  factory Description.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Description()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Description',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: Description.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'type')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..aOS(4, _omitFieldNames ? '' : 'emojiType')
    ..aOS(5, _omitFieldNames ? '' : 'goodsType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Description clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Description copyWith(void Function(Description) updates) =>
      super.copyWith((message) => updates(message as Description))
          as Description;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Description() / Description.new instead')
  static Description create() => Description._();
  static $pb.GeneratedMessage $_createMessage() => Description._();
  @$core.override
  Description createEmptyInstance() => Description._();
  @$core.pragma('dart2js:noInline')
  static Description getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Description>(
          Description.$_createMessage);
  static Description? _defaultInstance;

  /// 文本内容
  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  /// 文本类型
  @$pb.TagNumber(2)
  $core.String get type => $_getSZ(1);
  @$pb.TagNumber(2)
  set type($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  /// 跳转地址
  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);

  /// emoji 类型
  @$pb.TagNumber(4)
  $core.String get emojiType => $_getSZ(3);
  @$pb.TagNumber(4)
  set emojiType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEmojiType() => $_has(3);
  @$pb.TagNumber(4)
  void clearEmojiType() => $_clearField(4);

  /// 商品类型
  @$pb.TagNumber(5)
  $core.String get goodsType => $_getSZ(4);
  @$pb.TagNumber(5)
  set goodsType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasGoodsType() => $_has(4);
  @$pb.TagNumber(5)
  void clearGoodsType() => $_clearField(5);
}

/// 分辨率信息
class Dimension extends $pb.GeneratedMessage {
  factory Dimension({
    $fixnum.Int64? height,
    $fixnum.Int64? width,
    $fixnum.Int64? rotate,
  }) {
    final result = Dimension._();
    if (height != null) result.height = height;
    if (width != null) result.width = width;
    if (rotate != null) result.rotate = rotate;
    return result;
  }

  Dimension._();

  factory Dimension.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Dimension()..mergeFromBuffer(data, registry);
  factory Dimension.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Dimension()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Dimension',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: Dimension.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'height')
    ..aInt64(2, _omitFieldNames ? '' : 'width')
    ..aInt64(3, _omitFieldNames ? '' : 'rotate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Dimension clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Dimension copyWith(void Function(Dimension) updates) =>
      super.copyWith((message) => updates(message as Dimension)) as Dimension;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Dimension() / Dimension.new instead')
  static Dimension create() => Dimension._();
  static $pb.GeneratedMessage $_createMessage() => Dimension._();
  @$core.override
  Dimension createEmptyInstance() => Dimension._();
  @$core.pragma('dart2js:noInline')
  static Dimension getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Dimension>(Dimension.$_createMessage);
  static Dimension? _defaultInstance;

  /// 高
  @$pb.TagNumber(1)
  $fixnum.Int64 get height => $_getI64(0);
  @$pb.TagNumber(1)
  set height($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHeight() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeight() => $_clearField(1);

  /// 宽
  @$pb.TagNumber(2)
  $fixnum.Int64 get width => $_getI64(1);
  @$pb.TagNumber(2)
  set width($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWidth() => $_has(1);
  @$pb.TagNumber(2)
  void clearWidth() => $_clearField(2);

  /// 是否为竖屏
  @$pb.TagNumber(3)
  $fixnum.Int64 get rotate => $_getI64(2);
  @$pb.TagNumber(3)
  set rotate($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRotate() => $_has(2);
  @$pb.TagNumber(3)
  void clearRotate() => $_clearField(3);
}

/// 通过动态 ID 批量获取动态详情返回值
class DynDetailsReply extends $pb.GeneratedMessage {
  factory DynDetailsReply({
    $core.Iterable<DynamicItem>? list,
  }) {
    final result = DynDetailsReply._();
    if (list != null) result.list.addAll(list);
    return result;
  }

  DynDetailsReply._();

  factory DynDetailsReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynDetailsReply()..mergeFromBuffer(data, registry);
  factory DynDetailsReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynDetailsReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynDetailsReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynDetailsReply.$_createMessage)
    ..pPM<DynamicItem>(1, _omitFieldNames ? '' : 'list',
        subBuilder: DynamicItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynDetailsReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynDetailsReply copyWith(void Function(DynDetailsReply) updates) =>
      super.copyWith((message) => updates(message as DynDetailsReply))
          as DynDetailsReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DynDetailsReply() / DynDetailsReply.new instead')
  static DynDetailsReply create() => DynDetailsReply._();
  static $pb.GeneratedMessage $_createMessage() => DynDetailsReply._();
  @$core.override
  DynDetailsReply createEmptyInstance() => DynDetailsReply._();
  @$core.pragma('dart2js:noInline')
  static DynDetailsReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DynDetailsReply>(
          DynDetailsReply.$_createMessage);
  static DynDetailsReply? _defaultInstance;

  /// 动态列表
  @$pb.TagNumber(1)
  $pb.PbList<DynamicItem> get list => $_getList(0);
}

/// 通过动态 ID 批量获取动态详情请求参数
class DynDetailsReq extends $pb.GeneratedMessage {
  factory DynDetailsReq({
    $core.int? teenagersMode,
    $core.String? dynamicIds,
    $core.int? qn,
    $core.int? fnver,
    $core.int? fnval,
    $core.int? forceHost,
    $core.int? fourk,
  }) {
    final result = DynDetailsReq._();
    if (teenagersMode != null) result.teenagersMode = teenagersMode;
    if (dynamicIds != null) result.dynamicIds = dynamicIds;
    if (qn != null) result.qn = qn;
    if (fnver != null) result.fnver = fnver;
    if (fnval != null) result.fnval = fnval;
    if (forceHost != null) result.forceHost = forceHost;
    if (fourk != null) result.fourk = fourk;
    return result;
  }

  DynDetailsReq._();

  factory DynDetailsReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynDetailsReq()..mergeFromBuffer(data, registry);
  factory DynDetailsReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynDetailsReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynDetailsReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynDetailsReq.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'teenagersMode')
    ..aOS(2, _omitFieldNames ? '' : 'dynamicIds')
    ..aI(3, _omitFieldNames ? '' : 'qn')
    ..aI(4, _omitFieldNames ? '' : 'fnver')
    ..aI(5, _omitFieldNames ? '' : 'fnval')
    ..aI(6, _omitFieldNames ? '' : 'forceHost')
    ..aI(7, _omitFieldNames ? '' : 'fourk')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynDetailsReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynDetailsReq copyWith(void Function(DynDetailsReq) updates) =>
      super.copyWith((message) => updates(message as DynDetailsReq))
          as DynDetailsReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DynDetailsReq() / DynDetailsReq.new instead')
  static DynDetailsReq create() => DynDetailsReq._();
  static $pb.GeneratedMessage $_createMessage() => DynDetailsReq._();
  @$core.override
  DynDetailsReq createEmptyInstance() => DynDetailsReq._();
  @$core.pragma('dart2js:noInline')
  static DynDetailsReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DynDetailsReq>(
          DynDetailsReq.$_createMessage);
  static DynDetailsReq? _defaultInstance;

  /// 青少年模式
  @$pb.TagNumber(1)
  $core.int get teenagersMode => $_getIZ(0);
  @$pb.TagNumber(1)
  set teenagersMode($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTeenagersMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearTeenagersMode() => $_clearField(1);

  /// 动态 ID
  @$pb.TagNumber(2)
  $core.String get dynamicIds => $_getSZ(1);
  @$pb.TagNumber(2)
  set dynamicIds($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDynamicIds() => $_has(1);
  @$pb.TagNumber(2)
  void clearDynamicIds() => $_clearField(2);

  /// 清晰度 (供秒开)
  @$pb.TagNumber(3)
  $core.int get qn => $_getIZ(2);
  @$pb.TagNumber(3)
  set qn($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQn() => $_has(2);
  @$pb.TagNumber(3)
  void clearQn() => $_clearField(3);

  /// 功能版本号 (供秒开)
  @$pb.TagNumber(4)
  $core.int get fnver => $_getIZ(3);
  @$pb.TagNumber(4)
  set fnver($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFnver() => $_has(3);
  @$pb.TagNumber(4)
  void clearFnver() => $_clearField(4);

  /// 功能标识 (供秒开)
  @$pb.TagNumber(5)
  $core.int get fnval => $_getIZ(4);
  @$pb.TagNumber(5)
  set fnval($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFnval() => $_has(4);
  @$pb.TagNumber(5)
  void clearFnval() => $_clearField(5);

  /// 返回 playurl 是否强制使用域名 (供秒开)
  @$pb.TagNumber(6)
  $core.int get forceHost => $_getIZ(5);
  @$pb.TagNumber(6)
  set forceHost($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasForceHost() => $_has(5);
  @$pb.TagNumber(6)
  void clearForceHost() => $_clearField(6);

  /// 是否需要 4K 视频 (供秒开)
  @$pb.TagNumber(7)
  $core.int get fourk => $_getIZ(6);
  @$pb.TagNumber(7)
  set fourk($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFourk() => $_has(6);
  @$pb.TagNumber(7)
  void clearFourk() => $_clearField(7);
}

class DynMixUpListSearchReply extends $pb.GeneratedMessage {
  factory DynMixUpListSearchReply({
    $core.Iterable<MixUpListItem>? items,
  }) {
    final result = DynMixUpListSearchReply._();
    if (items != null) result.items.addAll(items);
    return result;
  }

  DynMixUpListSearchReply._();

  factory DynMixUpListSearchReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynMixUpListSearchReply()..mergeFromBuffer(data, registry);
  factory DynMixUpListSearchReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynMixUpListSearchReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynMixUpListSearchReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynMixUpListSearchReply.$_createMessage)
    ..pPM<MixUpListItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: MixUpListItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynMixUpListSearchReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynMixUpListSearchReply copyWith(
          void Function(DynMixUpListSearchReply) updates) =>
      super.copyWith((message) => updates(message as DynMixUpListSearchReply))
          as DynMixUpListSearchReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DynMixUpListSearchReply() / DynMixUpListSearchReply.new instead')
  static DynMixUpListSearchReply create() => DynMixUpListSearchReply._();
  static $pb.GeneratedMessage $_createMessage() => DynMixUpListSearchReply._();
  @$core.override
  DynMixUpListSearchReply createEmptyInstance() => DynMixUpListSearchReply._();
  @$core.pragma('dart2js:noInline')
  static DynMixUpListSearchReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DynMixUpListSearchReply>(
          DynMixUpListSearchReply.$_createMessage);
  static DynMixUpListSearchReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MixUpListItem> get items => $_getList(0);
}

class DynMixUpListSearchReq extends $pb.GeneratedMessage {
  factory DynMixUpListSearchReq({
    $core.String? name,
  }) {
    final result = DynMixUpListSearchReq._();
    if (name != null) result.name = name;
    return result;
  }

  DynMixUpListSearchReq._();

  factory DynMixUpListSearchReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynMixUpListSearchReq()..mergeFromBuffer(data, registry);
  factory DynMixUpListSearchReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynMixUpListSearchReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynMixUpListSearchReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynMixUpListSearchReq.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynMixUpListSearchReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynMixUpListSearchReq copyWith(
          void Function(DynMixUpListSearchReq) updates) =>
      super.copyWith((message) => updates(message as DynMixUpListSearchReq))
          as DynMixUpListSearchReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DynMixUpListSearchReq() / DynMixUpListSearchReq.new instead')
  static DynMixUpListSearchReq create() => DynMixUpListSearchReq._();
  static $pb.GeneratedMessage $_createMessage() => DynMixUpListSearchReq._();
  @$core.override
  DynMixUpListSearchReq createEmptyInstance() => DynMixUpListSearchReq._();
  @$core.pragma('dart2js:noInline')
  static DynMixUpListSearchReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DynMixUpListSearchReq>(
          DynMixUpListSearchReq.$_createMessage);
  static DynMixUpListSearchReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class DynMixUpListViewMoreReply extends $pb.GeneratedMessage {
  factory DynMixUpListViewMoreReply({
    $core.Iterable<MixUpListItem>? items,
    $core.String? searchDefaultText,
  }) {
    final result = DynMixUpListViewMoreReply._();
    if (items != null) result.items.addAll(items);
    if (searchDefaultText != null) result.searchDefaultText = searchDefaultText;
    return result;
  }

  DynMixUpListViewMoreReply._();

  factory DynMixUpListViewMoreReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynMixUpListViewMoreReply()..mergeFromBuffer(data, registry);
  factory DynMixUpListViewMoreReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynMixUpListViewMoreReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynMixUpListViewMoreReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynMixUpListViewMoreReply.$_createMessage)
    ..pPM<MixUpListItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: MixUpListItem.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'searchDefaultText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynMixUpListViewMoreReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynMixUpListViewMoreReply copyWith(
          void Function(DynMixUpListViewMoreReply) updates) =>
      super.copyWith((message) => updates(message as DynMixUpListViewMoreReply))
          as DynMixUpListViewMoreReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DynMixUpListViewMoreReply() / DynMixUpListViewMoreReply.new instead')
  static DynMixUpListViewMoreReply create() => DynMixUpListViewMoreReply._();
  static $pb.GeneratedMessage $_createMessage() =>
      DynMixUpListViewMoreReply._();
  @$core.override
  DynMixUpListViewMoreReply createEmptyInstance() =>
      DynMixUpListViewMoreReply._();
  @$core.pragma('dart2js:noInline')
  static DynMixUpListViewMoreReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DynMixUpListViewMoreReply>(
          DynMixUpListViewMoreReply.$_createMessage);
  static DynMixUpListViewMoreReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MixUpListItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get searchDefaultText => $_getSZ(1);
  @$pb.TagNumber(2)
  set searchDefaultText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSearchDefaultText() => $_has(1);
  @$pb.TagNumber(2)
  void clearSearchDefaultText() => $_clearField(2);
}

/// 动态同城物料
class DynOurCityItem extends $pb.GeneratedMessage {
  factory DynOurCityItem({
    $core.String? cardType,
    $fixnum.Int64? dynId,
    $core.String? uri,
    $core.Iterable<DynOurCityModule>? modules,
    $fixnum.Int64? rid,
    $core.String? debugInfo,
  }) {
    final result = DynOurCityItem._();
    if (cardType != null) result.cardType = cardType;
    if (dynId != null) result.dynId = dynId;
    if (uri != null) result.uri = uri;
    if (modules != null) result.modules.addAll(modules);
    if (rid != null) result.rid = rid;
    if (debugInfo != null) result.debugInfo = debugInfo;
    return result;
  }

  DynOurCityItem._();

  factory DynOurCityItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCityItem()..mergeFromBuffer(data, registry);
  factory DynOurCityItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCityItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynOurCityItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynOurCityItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'cardType')
    ..aInt64(2, _omitFieldNames ? '' : 'dynId')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..pPM<DynOurCityModule>(4, _omitFieldNames ? '' : 'modules',
        subBuilder: DynOurCityModule.$_createMessage)
    ..aInt64(5, _omitFieldNames ? '' : 'rid')
    ..aOS(6, _omitFieldNames ? '' : 'debugInfo')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCityItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCityItem copyWith(void Function(DynOurCityItem) updates) =>
      super.copyWith((message) => updates(message as DynOurCityItem))
          as DynOurCityItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DynOurCityItem() / DynOurCityItem.new instead')
  static DynOurCityItem create() => DynOurCityItem._();
  static $pb.GeneratedMessage $_createMessage() => DynOurCityItem._();
  @$core.override
  DynOurCityItem createEmptyInstance() => DynOurCityItem._();
  @$core.pragma('dart2js:noInline')
  static DynOurCityItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DynOurCityItem>(
          DynOurCityItem.$_createMessage);
  static DynOurCityItem? _defaultInstance;

  /// 卡片类型
  ///
  /// - av: 稿件
  /// - draw: 图文
  @$pb.TagNumber(1)
  $core.String get cardType => $_getSZ(0);
  @$pb.TagNumber(1)
  set cardType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCardType() => $_has(0);
  @$pb.TagNumber(1)
  void clearCardType() => $_clearField(1);

  /// 动态 ID
  @$pb.TagNumber(2)
  $fixnum.Int64 get dynId => $_getI64(1);
  @$pb.TagNumber(2)
  set dynId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDynId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDynId() => $_clearField(2);

  /// 跳转地址
  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);

  /// 模块列表
  @$pb.TagNumber(4)
  $pb.PbList<DynOurCityModule> get modules => $_getList(3);

  /// 资源 ID
  @$pb.TagNumber(5)
  $fixnum.Int64 get rid => $_getI64(4);
  @$pb.TagNumber(5)
  set rid($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRid() => $_has(4);
  @$pb.TagNumber(5)
  void clearRid() => $_clearField(5);

  /// ? DEBUG 信息
  @$pb.TagNumber(6)
  $core.String get debugInfo => $_getSZ(5);
  @$pb.TagNumber(6)
  set debugInfo($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDebugInfo() => $_has(5);
  @$pb.TagNumber(6)
  void clearDebugInfo() => $_clearField(6);
}

enum DynOurCityModule_ModuleItem {
  moduleCover,
  moduleDesc,
  moduleAuthor,
  moduleExtend,
  notSet
}

/// 动态同城物料模块
class DynOurCityModule extends $pb.GeneratedMessage {
  factory DynOurCityModule({
    $core.String? moduleType,
    DynOurCityModuleCover? moduleCover,
    DynOurCityModuleDesc? moduleDesc,
    DynOurCityModuleAuthor? moduleAuthor,
    DynOurCityModuleExtend? moduleExtend,
  }) {
    final result = DynOurCityModule._();
    if (moduleType != null) result.moduleType = moduleType;
    if (moduleCover != null) result.moduleCover = moduleCover;
    if (moduleDesc != null) result.moduleDesc = moduleDesc;
    if (moduleAuthor != null) result.moduleAuthor = moduleAuthor;
    if (moduleExtend != null) result.moduleExtend = moduleExtend;
    return result;
  }

  DynOurCityModule._();

  factory DynOurCityModule.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCityModule()..mergeFromBuffer(data, registry);
  factory DynOurCityModule.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCityModule()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, DynOurCityModule_ModuleItem>
      _DynOurCityModule_ModuleItemByTag = {
    2: DynOurCityModule_ModuleItem.moduleCover,
    3: DynOurCityModule_ModuleItem.moduleDesc,
    4: DynOurCityModule_ModuleItem.moduleAuthor,
    5: DynOurCityModule_ModuleItem.moduleExtend,
    0: DynOurCityModule_ModuleItem.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynOurCityModule',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynOurCityModule.$_createMessage)
    ..oo(0, [2, 3, 4, 5])
    ..aOS(1, _omitFieldNames ? '' : 'moduleType')
    ..aOM<DynOurCityModuleCover>(2, _omitFieldNames ? '' : 'moduleCover',
        subBuilder: DynOurCityModuleCover.$_createMessage)
    ..aOM<DynOurCityModuleDesc>(3, _omitFieldNames ? '' : 'moduleDesc',
        subBuilder: DynOurCityModuleDesc.$_createMessage)
    ..aOM<DynOurCityModuleAuthor>(4, _omitFieldNames ? '' : 'moduleAuthor',
        subBuilder: DynOurCityModuleAuthor.$_createMessage)
    ..aOM<DynOurCityModuleExtend>(5, _omitFieldNames ? '' : 'moduleExtend',
        subBuilder: DynOurCityModuleExtend.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCityModule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCityModule copyWith(void Function(DynOurCityModule) updates) =>
      super.copyWith((message) => updates(message as DynOurCityModule))
          as DynOurCityModule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DynOurCityModule() / DynOurCityModule.new instead')
  static DynOurCityModule create() => DynOurCityModule._();
  static $pb.GeneratedMessage $_createMessage() => DynOurCityModule._();
  @$core.override
  DynOurCityModule createEmptyInstance() => DynOurCityModule._();
  @$core.pragma('dart2js:noInline')
  static DynOurCityModule getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DynOurCityModule>(
          DynOurCityModule.$_createMessage);
  static DynOurCityModule? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  DynOurCityModule_ModuleItem whichModuleItem() =>
      _DynOurCityModule_ModuleItemByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearModuleItem() => $_clearField($_whichOneof(0));

  /// 模块类型
  ///
  /// - `cover`: 封面
  /// - `desc`: 描述
  /// - `author`: 发布人
  /// - `extend`: 扩展部分
  @$pb.TagNumber(1)
  $core.String get moduleType => $_getSZ(0);
  @$pb.TagNumber(1)
  set moduleType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasModuleType() => $_has(0);
  @$pb.TagNumber(1)
  void clearModuleType() => $_clearField(1);

  /// 参见 [`DynOurCityModuleCover`]
  @$pb.TagNumber(2)
  DynOurCityModuleCover get moduleCover => $_getN(1);
  @$pb.TagNumber(2)
  set moduleCover(DynOurCityModuleCover value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasModuleCover() => $_has(1);
  @$pb.TagNumber(2)
  void clearModuleCover() => $_clearField(2);
  @$pb.TagNumber(2)
  DynOurCityModuleCover ensureModuleCover() => $_ensure(1);

  /// 参见 [`DynOurCityModuleDesc`]
  @$pb.TagNumber(3)
  DynOurCityModuleDesc get moduleDesc => $_getN(2);
  @$pb.TagNumber(3)
  set moduleDesc(DynOurCityModuleDesc value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasModuleDesc() => $_has(2);
  @$pb.TagNumber(3)
  void clearModuleDesc() => $_clearField(3);
  @$pb.TagNumber(3)
  DynOurCityModuleDesc ensureModuleDesc() => $_ensure(2);

  /// 参见 [`DynOurCityModuleAuthor`]
  @$pb.TagNumber(4)
  DynOurCityModuleAuthor get moduleAuthor => $_getN(3);
  @$pb.TagNumber(4)
  set moduleAuthor(DynOurCityModuleAuthor value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasModuleAuthor() => $_has(3);
  @$pb.TagNumber(4)
  void clearModuleAuthor() => $_clearField(4);
  @$pb.TagNumber(4)
  DynOurCityModuleAuthor ensureModuleAuthor() => $_ensure(3);

  /// 参见 [`DynOurCityModuleExtend`]
  @$pb.TagNumber(5)
  DynOurCityModuleExtend get moduleExtend => $_getN(4);
  @$pb.TagNumber(5)
  set moduleExtend(DynOurCityModuleExtend value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasModuleExtend() => $_has(4);
  @$pb.TagNumber(5)
  void clearModuleExtend() => $_clearField(5);
  @$pb.TagNumber(5)
  DynOurCityModuleExtend ensureModuleExtend() => $_ensure(4);
}

/// 动态同城物料发布人模块
class DynOurCityModuleAuthor extends $pb.GeneratedMessage {
  factory DynOurCityModuleAuthor({
    $fixnum.Int64? mid,
    $core.String? name,
    $core.String? face,
    $core.String? uri,
  }) {
    final result = DynOurCityModuleAuthor._();
    if (mid != null) result.mid = mid;
    if (name != null) result.name = name;
    if (face != null) result.face = face;
    if (uri != null) result.uri = uri;
    return result;
  }

  DynOurCityModuleAuthor._();

  factory DynOurCityModuleAuthor.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCityModuleAuthor()..mergeFromBuffer(data, registry);
  factory DynOurCityModuleAuthor.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCityModuleAuthor()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynOurCityModuleAuthor',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynOurCityModuleAuthor.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'face')
    ..aOS(4, _omitFieldNames ? '' : 'uri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCityModuleAuthor clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCityModuleAuthor copyWith(
          void Function(DynOurCityModuleAuthor) updates) =>
      super.copyWith((message) => updates(message as DynOurCityModuleAuthor))
          as DynOurCityModuleAuthor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DynOurCityModuleAuthor() / DynOurCityModuleAuthor.new instead')
  static DynOurCityModuleAuthor create() => DynOurCityModuleAuthor._();
  static $pb.GeneratedMessage $_createMessage() => DynOurCityModuleAuthor._();
  @$core.override
  DynOurCityModuleAuthor createEmptyInstance() => DynOurCityModuleAuthor._();
  @$core.pragma('dart2js:noInline')
  static DynOurCityModuleAuthor getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DynOurCityModuleAuthor>(
          DynOurCityModuleAuthor.$_createMessage);
  static DynOurCityModuleAuthor? _defaultInstance;

  /// 发布人 mid
  @$pb.TagNumber(1)
  $fixnum.Int64 get mid => $_getI64(0);
  @$pb.TagNumber(1)
  set mid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearMid() => $_clearField(1);

  /// 发布人昵称
  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// 发布人头像
  @$pb.TagNumber(3)
  $core.String get face => $_getSZ(2);
  @$pb.TagNumber(3)
  set face($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFace() => $_has(2);
  @$pb.TagNumber(3)
  void clearFace() => $_clearField(3);

  /// 跳转地址
  @$pb.TagNumber(4)
  $core.String get uri => $_getSZ(3);
  @$pb.TagNumber(4)
  set uri($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUri() => $_has(3);
  @$pb.TagNumber(4)
  void clearUri() => $_clearField(4);
}

/// 动态同城物料封面模块
class DynOurCityModuleCover extends $pb.GeneratedMessage {
  factory DynOurCityModuleCover({
    $core.Iterable<$core.String>? covers,
    $core.int? style,
    $core.int? coverLeftIcon1,
    $core.String? coverLeftText1,
    $core.int? coverLeftIcon2,
    $core.String? coverLeftText2,
    $core.String? coverLeftText3,
    $core.Iterable<VideoBadge>? badge,
  }) {
    final result = DynOurCityModuleCover._();
    if (covers != null) result.covers.addAll(covers);
    if (style != null) result.style = style;
    if (coverLeftIcon1 != null) result.coverLeftIcon1 = coverLeftIcon1;
    if (coverLeftText1 != null) result.coverLeftText1 = coverLeftText1;
    if (coverLeftIcon2 != null) result.coverLeftIcon2 = coverLeftIcon2;
    if (coverLeftText2 != null) result.coverLeftText2 = coverLeftText2;
    if (coverLeftText3 != null) result.coverLeftText3 = coverLeftText3;
    if (badge != null) result.badge.addAll(badge);
    return result;
  }

  DynOurCityModuleCover._();

  factory DynOurCityModuleCover.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCityModuleCover()..mergeFromBuffer(data, registry);
  factory DynOurCityModuleCover.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCityModuleCover()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynOurCityModuleCover',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynOurCityModuleCover.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'covers')
    ..aI(2, _omitFieldNames ? '' : 'style')
    ..aI(3, _omitFieldNames ? '' : 'coverLeftIcon1')
    ..aOS(4, _omitFieldNames ? '' : 'coverLeftText1')
    ..aI(5, _omitFieldNames ? '' : 'coverLeftIcon2')
    ..aOS(6, _omitFieldNames ? '' : 'coverLeftText2')
    ..aOS(7, _omitFieldNames ? '' : 'coverLeftText3')
    ..pPM<VideoBadge>(8, _omitFieldNames ? '' : 'badge',
        subBuilder: VideoBadge.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCityModuleCover clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCityModuleCover copyWith(
          void Function(DynOurCityModuleCover) updates) =>
      super.copyWith((message) => updates(message as DynOurCityModuleCover))
          as DynOurCityModuleCover;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DynOurCityModuleCover() / DynOurCityModuleCover.new instead')
  static DynOurCityModuleCover create() => DynOurCityModuleCover._();
  static $pb.GeneratedMessage $_createMessage() => DynOurCityModuleCover._();
  @$core.override
  DynOurCityModuleCover createEmptyInstance() => DynOurCityModuleCover._();
  @$core.pragma('dart2js:noInline')
  static DynOurCityModuleCover getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DynOurCityModuleCover>(
          DynOurCityModuleCover.$_createMessage);
  static DynOurCityModuleCover? _defaultInstance;

  /// 封面图
  ///
  /// 单图样式取第一个元素
  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get covers => $_getList(0);

  /// 封面样式
  ///
  /// - 1: 横图
  /// - 2: 竖图
  /// - 3: 方图
  @$pb.TagNumber(2)
  $core.int get style => $_getIZ(1);
  @$pb.TagNumber(2)
  set style($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStyle() => $_has(1);
  @$pb.TagNumber(2)
  void clearStyle() => $_clearField(2);

  /// 视频封面展示项图标 1
  @$pb.TagNumber(3)
  $core.int get coverLeftIcon1 => $_getIZ(2);
  @$pb.TagNumber(3)
  set coverLeftIcon1($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCoverLeftIcon1() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoverLeftIcon1() => $_clearField(3);

  /// 视频封面展示项 1
  @$pb.TagNumber(4)
  $core.String get coverLeftText1 => $_getSZ(3);
  @$pb.TagNumber(4)
  set coverLeftText1($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverLeftText1() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverLeftText1() => $_clearField(4);

  /// 视频封面展示项图标 2
  @$pb.TagNumber(5)
  $core.int get coverLeftIcon2 => $_getIZ(4);
  @$pb.TagNumber(5)
  set coverLeftIcon2($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCoverLeftIcon2() => $_has(4);
  @$pb.TagNumber(5)
  void clearCoverLeftIcon2() => $_clearField(5);

  /// 视频封面展示项 2
  @$pb.TagNumber(6)
  $core.String get coverLeftText2 => $_getSZ(5);
  @$pb.TagNumber(6)
  set coverLeftText2($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCoverLeftText2() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoverLeftText2() => $_clearField(6);

  /// 视频封面展示项 3
  @$pb.TagNumber(7)
  $core.String get coverLeftText3 => $_getSZ(6);
  @$pb.TagNumber(7)
  set coverLeftText3($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCoverLeftText3() => $_has(6);
  @$pb.TagNumber(7)
  void clearCoverLeftText3() => $_clearField(7);

  /// 角标
  @$pb.TagNumber(8)
  $pb.PbList<VideoBadge> get badge => $_getList(7);
}

/// 动态同城物料详情模块
class DynOurCityModuleDesc extends $pb.GeneratedMessage {
  factory DynOurCityModuleDesc({
    $core.String? desc,
  }) {
    final result = DynOurCityModuleDesc._();
    if (desc != null) result.desc = desc;
    return result;
  }

  DynOurCityModuleDesc._();

  factory DynOurCityModuleDesc.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCityModuleDesc()..mergeFromBuffer(data, registry);
  factory DynOurCityModuleDesc.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCityModuleDesc()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynOurCityModuleDesc',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynOurCityModuleDesc.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'desc')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCityModuleDesc clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCityModuleDesc copyWith(void Function(DynOurCityModuleDesc) updates) =>
      super.copyWith((message) => updates(message as DynOurCityModuleDesc))
          as DynOurCityModuleDesc;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DynOurCityModuleDesc() / DynOurCityModuleDesc.new instead')
  static DynOurCityModuleDesc create() => DynOurCityModuleDesc._();
  static $pb.GeneratedMessage $_createMessage() => DynOurCityModuleDesc._();
  @$core.override
  DynOurCityModuleDesc createEmptyInstance() => DynOurCityModuleDesc._();
  @$core.pragma('dart2js:noInline')
  static DynOurCityModuleDesc getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DynOurCityModuleDesc>(
          DynOurCityModuleDesc.$_createMessage);
  static DynOurCityModuleDesc? _defaultInstance;

  /// 详情
  @$pb.TagNumber(1)
  $core.String get desc => $_getSZ(0);
  @$pb.TagNumber(1)
  set desc($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDesc() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesc() => $_clearField(1);
}

enum DynOurCityModuleExtend_Extend { extendLbs, notSet }

/// 动态同城物料拓展模块
class DynOurCityModuleExtend extends $pb.GeneratedMessage {
  factory DynOurCityModuleExtend({
    $core.String? type,
    DynOurCityModuleExtendLBS? extendLbs,
  }) {
    final result = DynOurCityModuleExtend._();
    if (type != null) result.type = type;
    if (extendLbs != null) result.extendLbs = extendLbs;
    return result;
  }

  DynOurCityModuleExtend._();

  factory DynOurCityModuleExtend.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCityModuleExtend()..mergeFromBuffer(data, registry);
  factory DynOurCityModuleExtend.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCityModuleExtend()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, DynOurCityModuleExtend_Extend>
      _DynOurCityModuleExtend_ExtendByTag = {
    2: DynOurCityModuleExtend_Extend.extendLbs,
    0: DynOurCityModuleExtend_Extend.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynOurCityModuleExtend',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynOurCityModuleExtend.$_createMessage)
    ..oo(0, [2])
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..aOM<DynOurCityModuleExtendLBS>(2, _omitFieldNames ? '' : 'extendLbs',
        subBuilder: DynOurCityModuleExtendLBS.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCityModuleExtend clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCityModuleExtend copyWith(
          void Function(DynOurCityModuleExtend) updates) =>
      super.copyWith((message) => updates(message as DynOurCityModuleExtend))
          as DynOurCityModuleExtend;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DynOurCityModuleExtend() / DynOurCityModuleExtend.new instead')
  static DynOurCityModuleExtend create() => DynOurCityModuleExtend._();
  static $pb.GeneratedMessage $_createMessage() => DynOurCityModuleExtend._();
  @$core.override
  DynOurCityModuleExtend createEmptyInstance() => DynOurCityModuleExtend._();
  @$core.pragma('dart2js:noInline')
  static DynOurCityModuleExtend getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DynOurCityModuleExtend>(
          DynOurCityModuleExtend.$_createMessage);
  static DynOurCityModuleExtend? _defaultInstance;

  @$pb.TagNumber(2)
  DynOurCityModuleExtend_Extend whichExtend() =>
      _DynOurCityModuleExtend_ExtendByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  void clearExtend() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  DynOurCityModuleExtendLBS get extendLbs => $_getN(1);
  @$pb.TagNumber(2)
  set extendLbs(DynOurCityModuleExtendLBS value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasExtendLbs() => $_has(1);
  @$pb.TagNumber(2)
  void clearExtendLbs() => $_clearField(2);
  @$pb.TagNumber(2)
  DynOurCityModuleExtendLBS ensureExtendLbs() => $_ensure(1);
}

/// 动态同城物料拓展模块: LBS
class DynOurCityModuleExtendLBS extends $pb.GeneratedMessage {
  factory DynOurCityModuleExtendLBS({
    $core.String? title,
    $core.String? uri,
    $core.String? icon,
    $core.int? poiType,
  }) {
    final result = DynOurCityModuleExtendLBS._();
    if (title != null) result.title = title;
    if (uri != null) result.uri = uri;
    if (icon != null) result.icon = icon;
    if (poiType != null) result.poiType = poiType;
    return result;
  }

  DynOurCityModuleExtendLBS._();

  factory DynOurCityModuleExtendLBS.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCityModuleExtendLBS()..mergeFromBuffer(data, registry);
  factory DynOurCityModuleExtendLBS.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCityModuleExtendLBS()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynOurCityModuleExtendLBS',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynOurCityModuleExtendLBS.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'uri')
    ..aOS(3, _omitFieldNames ? '' : 'icon')
    ..aI(4, _omitFieldNames ? '' : 'poiType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCityModuleExtendLBS clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCityModuleExtendLBS copyWith(
          void Function(DynOurCityModuleExtendLBS) updates) =>
      super.copyWith((message) => updates(message as DynOurCityModuleExtendLBS))
          as DynOurCityModuleExtendLBS;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DynOurCityModuleExtendLBS() / DynOurCityModuleExtendLBS.new instead')
  static DynOurCityModuleExtendLBS create() => DynOurCityModuleExtendLBS._();
  static $pb.GeneratedMessage $_createMessage() =>
      DynOurCityModuleExtendLBS._();
  @$core.override
  DynOurCityModuleExtendLBS createEmptyInstance() =>
      DynOurCityModuleExtendLBS._();
  @$core.pragma('dart2js:noInline')
  static DynOurCityModuleExtendLBS getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DynOurCityModuleExtendLBS>(
          DynOurCityModuleExtendLBS.$_createMessage);
  static DynOurCityModuleExtendLBS? _defaultInstance;

  /// 标题
  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  /// 跳转地址
  @$pb.TagNumber(2)
  $core.String get uri => $_getSZ(1);
  @$pb.TagNumber(2)
  set uri($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearUri() => $_clearField(2);

  /// 小图标
  @$pb.TagNumber(3)
  $core.String get icon => $_getSZ(2);
  @$pb.TagNumber(3)
  set icon($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearIcon() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get poiType => $_getIZ(3);
  @$pb.TagNumber(4)
  set poiType($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPoiType() => $_has(3);
  @$pb.TagNumber(4)
  void clearPoiType() => $_clearField(4);
}

/// 动态同城页请求返回值
class DynOurCityReply extends $pb.GeneratedMessage {
  factory DynOurCityReply({
    $core.String? offset,
    $core.int? hasMore,
    $core.int? style,
    $core.String? topLabel,
    $core.Iterable<DynOurCityItem>? list,
    $core.String? topButtonLabel,
    $core.int? cityId,
    $core.String? cityName,
  }) {
    final result = DynOurCityReply._();
    if (offset != null) result.offset = offset;
    if (hasMore != null) result.hasMore = hasMore;
    if (style != null) result.style = style;
    if (topLabel != null) result.topLabel = topLabel;
    if (list != null) result.list.addAll(list);
    if (topButtonLabel != null) result.topButtonLabel = topButtonLabel;
    if (cityId != null) result.cityId = cityId;
    if (cityName != null) result.cityName = cityName;
    return result;
  }

  DynOurCityReply._();

  factory DynOurCityReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCityReply()..mergeFromBuffer(data, registry);
  factory DynOurCityReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCityReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynOurCityReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynOurCityReply.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'offset')
    ..aI(2, _omitFieldNames ? '' : 'hasMore')
    ..aI(3, _omitFieldNames ? '' : 'style')
    ..aOS(4, _omitFieldNames ? '' : 'topLabel')
    ..pPM<DynOurCityItem>(5, _omitFieldNames ? '' : 'list',
        subBuilder: DynOurCityItem.$_createMessage)
    ..aOS(6, _omitFieldNames ? '' : 'topButtonLabel')
    ..aI(7, _omitFieldNames ? '' : 'cityId')
    ..aOS(8, _omitFieldNames ? '' : 'cityName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCityReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCityReply copyWith(void Function(DynOurCityReply) updates) =>
      super.copyWith((message) => updates(message as DynOurCityReply))
          as DynOurCityReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DynOurCityReply() / DynOurCityReply.new instead')
  static DynOurCityReply create() => DynOurCityReply._();
  static $pb.GeneratedMessage $_createMessage() => DynOurCityReply._();
  @$core.override
  DynOurCityReply createEmptyInstance() => DynOurCityReply._();
  @$core.pragma('dart2js:noInline')
  static DynOurCityReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DynOurCityReply>(
          DynOurCityReply.$_createMessage);
  static DynOurCityReply? _defaultInstance;

  /// 翻页游标
  @$pb.TagNumber(1)
  $core.String get offset => $_getSZ(0);
  @$pb.TagNumber(1)
  set offset($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOffset() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffset() => $_clearField(1);

  /// 是否还有更多
  @$pb.TagNumber(2)
  $core.int get hasMore => $_getIZ(1);
  @$pb.TagNumber(2)
  set hasMore($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHasMore() => $_has(1);
  @$pb.TagNumber(2)
  void clearHasMore() => $_clearField(2);

  /// 样式类型
  ///
  /// - 1: 双列
  /// - 2: 瀑布流
  @$pb.TagNumber(3)
  $core.int get style => $_getIZ(2);
  @$pb.TagNumber(3)
  set style($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStyle() => $_has(2);
  @$pb.TagNumber(3)
  void clearStyle() => $_clearField(3);

  /// ? 顶部导引信息
  @$pb.TagNumber(4)
  $core.String get topLabel => $_getSZ(3);
  @$pb.TagNumber(4)
  set topLabel($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTopLabel() => $_has(3);
  @$pb.TagNumber(4)
  void clearTopLabel() => $_clearField(4);

  /// 列表详情
  @$pb.TagNumber(5)
  $pb.PbList<DynOurCityItem> get list => $_getList(4);

  /// ? 顶部导引按钮信息
  @$pb.TagNumber(6)
  $core.String get topButtonLabel => $_getSZ(5);
  @$pb.TagNumber(6)
  set topButtonLabel($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTopButtonLabel() => $_has(5);
  @$pb.TagNumber(6)
  void clearTopButtonLabel() => $_clearField(6);

  /// 城市 ID
  @$pb.TagNumber(7)
  $core.int get cityId => $_getIZ(6);
  @$pb.TagNumber(7)
  set cityId($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCityId() => $_has(6);
  @$pb.TagNumber(7)
  void clearCityId() => $_clearField(7);

  /// 城市名称
  @$pb.TagNumber(8)
  $core.String get cityName => $_getSZ(7);
  @$pb.TagNumber(8)
  set cityName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCityName() => $_has(7);
  @$pb.TagNumber(8)
  void clearCityName() => $_clearField(8);
}

/// 动态同城页请求参数
class DynOurCityReq extends $pb.GeneratedMessage {
  factory DynOurCityReq({
    $fixnum.Int64? cityId,
    $core.double? lat,
    $core.double? lng,
    $core.String? offset,
    $core.int? pageSize,
    $core.int? teenagersMode,
    $core.int? qn,
    $core.int? fnver,
    $core.int? fnval,
    $core.int? forceHost,
    $core.int? fourk,
    $core.int? lbsState,
    $core.int? refreshCity,
    ExpConf? expConf,
    $1.PlayerArgs? playerArgs,
    $fixnum.Int64? cityCode,
    $fixnum.Int64? buildTime,
  }) {
    final result = DynOurCityReq._();
    if (cityId != null) result.cityId = cityId;
    if (lat != null) result.lat = lat;
    if (lng != null) result.lng = lng;
    if (offset != null) result.offset = offset;
    if (pageSize != null) result.pageSize = pageSize;
    if (teenagersMode != null) result.teenagersMode = teenagersMode;
    if (qn != null) result.qn = qn;
    if (fnver != null) result.fnver = fnver;
    if (fnval != null) result.fnval = fnval;
    if (forceHost != null) result.forceHost = forceHost;
    if (fourk != null) result.fourk = fourk;
    if (lbsState != null) result.lbsState = lbsState;
    if (refreshCity != null) result.refreshCity = refreshCity;
    if (expConf != null) result.expConf = expConf;
    if (playerArgs != null) result.playerArgs = playerArgs;
    if (cityCode != null) result.cityCode = cityCode;
    if (buildTime != null) result.buildTime = buildTime;
    return result;
  }

  DynOurCityReq._();

  factory DynOurCityReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCityReq()..mergeFromBuffer(data, registry);
  factory DynOurCityReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCityReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynOurCityReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynOurCityReq.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'cityId')
    ..aD(2, _omitFieldNames ? '' : 'lat')
    ..aD(3, _omitFieldNames ? '' : 'lng')
    ..aOS(4, _omitFieldNames ? '' : 'offset')
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..aI(6, _omitFieldNames ? '' : 'teenagersMode')
    ..aI(7, _omitFieldNames ? '' : 'qn')
    ..aI(8, _omitFieldNames ? '' : 'fnver')
    ..aI(9, _omitFieldNames ? '' : 'fnval')
    ..aI(10, _omitFieldNames ? '' : 'forceHost')
    ..aI(11, _omitFieldNames ? '' : 'fourk')
    ..aI(12, _omitFieldNames ? '' : 'lbsState')
    ..aI(13, _omitFieldNames ? '' : 'refreshCity')
    ..aOM<ExpConf>(14, _omitFieldNames ? '' : 'expConf',
        subBuilder: ExpConf.$_createMessage)
    ..aOM<$1.PlayerArgs>(15, _omitFieldNames ? '' : 'playerArgs',
        subBuilder: $1.PlayerArgs.$_createMessage)
    ..aInt64(16, _omitFieldNames ? '' : 'cityCode')
    ..aInt64(17, _omitFieldNames ? '' : 'buildTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCityReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCityReq copyWith(void Function(DynOurCityReq) updates) =>
      super.copyWith((message) => updates(message as DynOurCityReq))
          as DynOurCityReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DynOurCityReq() / DynOurCityReq.new instead')
  static DynOurCityReq create() => DynOurCityReq._();
  static $pb.GeneratedMessage $_createMessage() => DynOurCityReq._();
  @$core.override
  DynOurCityReq createEmptyInstance() => DynOurCityReq._();
  @$core.pragma('dart2js:noInline')
  static DynOurCityReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DynOurCityReq>(
          DynOurCityReq.$_createMessage);
  static DynOurCityReq? _defaultInstance;

  /// 城市 ID
  @$pb.TagNumber(1)
  $fixnum.Int64 get cityId => $_getI64(0);
  @$pb.TagNumber(1)
  set cityId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCityId() => $_clearField(1);

  /// 纬度
  @$pb.TagNumber(2)
  $core.double get lat => $_getN(1);
  @$pb.TagNumber(2)
  set lat($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLat() => $_has(1);
  @$pb.TagNumber(2)
  void clearLat() => $_clearField(2);

  /// 精度
  @$pb.TagNumber(3)
  $core.double get lng => $_getN(2);
  @$pb.TagNumber(3)
  set lng($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLng() => $_has(2);
  @$pb.TagNumber(3)
  void clearLng() => $_clearField(3);

  /// 透传上一次接口请求返回的 offset
  @$pb.TagNumber(4)
  $core.String get offset => $_getSZ(3);
  @$pb.TagNumber(4)
  set offset($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearOffset() => $_clearField(4);

  /// 每页元素个数
  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);

  /// 青少年模式
  @$pb.TagNumber(6)
  $core.int get teenagersMode => $_getIZ(5);
  @$pb.TagNumber(6)
  set teenagersMode($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTeenagersMode() => $_has(5);
  @$pb.TagNumber(6)
  void clearTeenagersMode() => $_clearField(6);

  /// 清晰度 (供秒开)
  @$pb.TagNumber(7)
  $core.int get qn => $_getIZ(6);
  @$pb.TagNumber(7)
  set qn($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasQn() => $_has(6);
  @$pb.TagNumber(7)
  void clearQn() => $_clearField(7);

  /// 功能版本号 (供秒开)
  @$pb.TagNumber(8)
  $core.int get fnver => $_getIZ(7);
  @$pb.TagNumber(8)
  set fnver($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFnver() => $_has(7);
  @$pb.TagNumber(8)
  void clearFnver() => $_clearField(8);

  /// 功能标识 (供秒开)
  @$pb.TagNumber(9)
  $core.int get fnval => $_getIZ(8);
  @$pb.TagNumber(9)
  set fnval($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFnval() => $_has(8);
  @$pb.TagNumber(9)
  void clearFnval() => $_clearField(9);

  /// 返回 playurl 是否强制使用域名 (供秒开)
  @$pb.TagNumber(10)
  $core.int get forceHost => $_getIZ(9);
  @$pb.TagNumber(10)
  set forceHost($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasForceHost() => $_has(9);
  @$pb.TagNumber(10)
  void clearForceHost() => $_clearField(10);

  /// 是否需要 4K 视频 (供秒开)
  @$pb.TagNumber(11)
  $core.int get fourk => $_getIZ(10);
  @$pb.TagNumber(11)
  set fourk($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasFourk() => $_has(10);
  @$pb.TagNumber(11)
  void clearFourk() => $_clearField(11);

  /// 是否开启 LBS
  @$pb.TagNumber(12)
  $core.int get lbsState => $_getIZ(11);
  @$pb.TagNumber(12)
  set lbsState($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasLbsState() => $_has(11);
  @$pb.TagNumber(12)
  void clearLbsState() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get refreshCity => $_getIZ(12);
  @$pb.TagNumber(13)
  set refreshCity($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRefreshCity() => $_has(12);
  @$pb.TagNumber(13)
  void clearRefreshCity() => $_clearField(13);

  /// ab 测试配置
  @$pb.TagNumber(14)
  ExpConf get expConf => $_getN(13);
  @$pb.TagNumber(14)
  set expConf(ExpConf value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasExpConf() => $_has(13);
  @$pb.TagNumber(14)
  void clearExpConf() => $_clearField(14);
  @$pb.TagNumber(14)
  ExpConf ensureExpConf() => $_ensure(13);

  /// 播放器参数 (供秒开)
  @$pb.TagNumber(15)
  $1.PlayerArgs get playerArgs => $_getN(14);
  @$pb.TagNumber(15)
  set playerArgs($1.PlayerArgs value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasPlayerArgs() => $_has(14);
  @$pb.TagNumber(15)
  void clearPlayerArgs() => $_clearField(15);
  @$pb.TagNumber(15)
  $1.PlayerArgs ensurePlayerArgs() => $_ensure(14);

  @$pb.TagNumber(16)
  $fixnum.Int64 get cityCode => $_getI64(15);
  @$pb.TagNumber(16)
  set cityCode($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasCityCode() => $_has(15);
  @$pb.TagNumber(16)
  void clearCityCode() => $_clearField(16);

  @$pb.TagNumber(17)
  $fixnum.Int64 get buildTime => $_getI64(16);
  @$pb.TagNumber(17)
  set buildTime($fixnum.Int64 value) => $_setInt64(16, value);
  @$pb.TagNumber(17)
  $core.bool hasBuildTime() => $_has(16);
  @$pb.TagNumber(17)
  void clearBuildTime() => $_clearField(17);
}

/// 动态同城开关请求参数
class DynOurCitySwitchReq extends $pb.GeneratedMessage {
  factory DynOurCitySwitchReq({
    $core.int? switch_1,
  }) {
    final result = DynOurCitySwitchReq._();
    if (switch_1 != null) result.switch_1 = switch_1;
    return result;
  }

  DynOurCitySwitchReq._();

  factory DynOurCitySwitchReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCitySwitchReq()..mergeFromBuffer(data, registry);
  factory DynOurCitySwitchReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynOurCitySwitchReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynOurCitySwitchReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynOurCitySwitchReq.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'switch')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCitySwitchReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynOurCitySwitchReq copyWith(void Function(DynOurCitySwitchReq) updates) =>
      super.copyWith((message) => updates(message as DynOurCitySwitchReq))
          as DynOurCitySwitchReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use DynOurCitySwitchReq() / DynOurCitySwitchReq.new instead')
  static DynOurCitySwitchReq create() => DynOurCitySwitchReq._();
  static $pb.GeneratedMessage $_createMessage() => DynOurCitySwitchReq._();
  @$core.override
  DynOurCitySwitchReq createEmptyInstance() => DynOurCitySwitchReq._();
  @$core.pragma('dart2js:noInline')
  static DynOurCitySwitchReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DynOurCitySwitchReq>(
          DynOurCitySwitchReq.$_createMessage);
  static DynOurCitySwitchReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get switch_1 => $_getIZ(0);
  @$pb.TagNumber(1)
  set switch_1($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSwitch_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearSwitch_1() => $_clearField(1);
}

/// 红点具体信息
class DynRedItem extends $pb.GeneratedMessage {
  factory DynRedItem({
    $fixnum.Int64? count,
  }) {
    final result = DynRedItem._();
    if (count != null) result.count = count;
    return result;
  }

  DynRedItem._();

  factory DynRedItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynRedItem()..mergeFromBuffer(data, registry);
  factory DynRedItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynRedItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynRedItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynRedItem.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'count')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynRedItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynRedItem copyWith(void Function(DynRedItem) updates) =>
      super.copyWith((message) => updates(message as DynRedItem)) as DynRedItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DynRedItem() / DynRedItem.new instead')
  static DynRedItem create() => DynRedItem._();
  static $pb.GeneratedMessage $_createMessage() => DynRedItem._();
  @$core.override
  DynRedItem createEmptyInstance() => DynRedItem._();
  @$core.pragma('dart2js:noInline')
  static DynRedItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DynRedItem>(DynRedItem.$_createMessage);
  static DynRedItem? _defaultInstance;

  /// 数字红点有效更新数
  @$pb.TagNumber(1)
  $fixnum.Int64 get count => $_getI64(0);
  @$pb.TagNumber(1)
  set count($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => $_clearField(1);
}

/// 动态红点返回值
class DynRedReply extends $pb.GeneratedMessage {
  factory DynRedReply({
    $core.String? redType,
    DynRedItem? dynRedItem,
    $core.String? defaultTab,
    DynRedStyle? redStyle,
    $core.String? tabRecallExtra,
    BubbleInfo? bubbleInfo,
  }) {
    final result = DynRedReply._();
    if (redType != null) result.redType = redType;
    if (dynRedItem != null) result.dynRedItem = dynRedItem;
    if (defaultTab != null) result.defaultTab = defaultTab;
    if (redStyle != null) result.redStyle = redStyle;
    if (tabRecallExtra != null) result.tabRecallExtra = tabRecallExtra;
    if (bubbleInfo != null) result.bubbleInfo = bubbleInfo;
    return result;
  }

  DynRedReply._();

  factory DynRedReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynRedReply()..mergeFromBuffer(data, registry);
  factory DynRedReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynRedReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynRedReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynRedReply.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'redType')
    ..aOM<DynRedItem>(2, _omitFieldNames ? '' : 'dynRedItem',
        subBuilder: DynRedItem.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'defaultTab')
    ..aOM<DynRedStyle>(4, _omitFieldNames ? '' : 'redStyle',
        subBuilder: DynRedStyle.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'tabRecallExtra')
    ..aOM<BubbleInfo>(6, _omitFieldNames ? '' : 'bubbleInfo',
        subBuilder: BubbleInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynRedReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynRedReply copyWith(void Function(DynRedReply) updates) =>
      super.copyWith((message) => updates(message as DynRedReply))
          as DynRedReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DynRedReply() / DynRedReply.new instead')
  static DynRedReply create() => DynRedReply._();
  static $pb.GeneratedMessage $_createMessage() => DynRedReply._();
  @$core.override
  DynRedReply createEmptyInstance() => DynRedReply._();
  @$core.pragma('dart2js:noInline')
  static DynRedReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DynRedReply>(
          DynRedReply.$_createMessage);
  static DynRedReply? _defaultInstance;

  /// 动态红点类型
  ///
  /// - count: 数字红点
  /// - point: 普通红点
  /// - no_point: 没有红点
  @$pb.TagNumber(1)
  $core.String get redType => $_getSZ(0);
  @$pb.TagNumber(1)
  set redType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRedType() => $_has(0);
  @$pb.TagNumber(1)
  void clearRedType() => $_clearField(1);

  /// 动态红点具体信息, 参见 [`DynRedItem`]
  @$pb.TagNumber(2)
  DynRedItem get dynRedItem => $_getN(1);
  @$pb.TagNumber(2)
  set dynRedItem(DynRedItem value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDynRedItem() => $_has(1);
  @$pb.TagNumber(2)
  void clearDynRedItem() => $_clearField(2);
  @$pb.TagNumber(2)
  DynRedItem ensureDynRedItem() => $_ensure(1);

  /// 动态红点默认 tab 值, 对应 tab 接口下发的 anchor
  @$pb.TagNumber(3)
  $core.String get defaultTab => $_getSZ(2);
  @$pb.TagNumber(3)
  set defaultTab($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDefaultTab() => $_has(2);
  @$pb.TagNumber(3)
  void clearDefaultTab() => $_clearField(3);

  /// 动态红点样式
  @$pb.TagNumber(4)
  DynRedStyle get redStyle => $_getN(3);
  @$pb.TagNumber(4)
  set redStyle(DynRedStyle value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRedStyle() => $_has(3);
  @$pb.TagNumber(4)
  void clearRedStyle() => $_clearField(4);
  @$pb.TagNumber(4)
  DynRedStyle ensureRedStyle() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get tabRecallExtra => $_getSZ(4);
  @$pb.TagNumber(5)
  set tabRecallExtra($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTabRecallExtra() => $_has(4);
  @$pb.TagNumber(5)
  void clearTabRecallExtra() => $_clearField(5);

  @$pb.TagNumber(6)
  BubbleInfo get bubbleInfo => $_getN(5);
  @$pb.TagNumber(6)
  set bubbleInfo(BubbleInfo value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasBubbleInfo() => $_has(5);
  @$pb.TagNumber(6)
  void clearBubbleInfo() => $_clearField(6);
  @$pb.TagNumber(6)
  BubbleInfo ensureBubbleInfo() => $_ensure(5);
}

/// 动态红点请求参数
class DynRedReq extends $pb.GeneratedMessage {
  factory DynRedReq({
    $core.Iterable<TabOffset>? tabOffset,
    $core.bool? isNewInstall,
    $core.bool? isCodeStart,
    $core.Iterable<$fixnum.Int64>? newFollowUpMids,
    DynRedReq_DynRedReqScene? reqScene,
  }) {
    final result = DynRedReq._();
    if (tabOffset != null) result.tabOffset.addAll(tabOffset);
    if (isNewInstall != null) result.isNewInstall = isNewInstall;
    if (isCodeStart != null) result.isCodeStart = isCodeStart;
    if (newFollowUpMids != null) result.newFollowUpMids.addAll(newFollowUpMids);
    if (reqScene != null) result.reqScene = reqScene;
    return result;
  }

  DynRedReq._();

  factory DynRedReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynRedReq()..mergeFromBuffer(data, registry);
  factory DynRedReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynRedReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynRedReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynRedReq.$_createMessage)
    ..pPM<TabOffset>(1, _omitFieldNames ? '' : 'tabOffset',
        subBuilder: TabOffset.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'isNewInstall')
    ..aOB(3, _omitFieldNames ? '' : 'isCodeStart')
    ..p<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'newFollowUpMids', $pb.PbFieldType.K6)
    ..aE<DynRedReq_DynRedReqScene>(5, _omitFieldNames ? '' : 'reqScene',
        enumValues: DynRedReq_DynRedReqScene.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynRedReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynRedReq copyWith(void Function(DynRedReq) updates) =>
      super.copyWith((message) => updates(message as DynRedReq)) as DynRedReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DynRedReq() / DynRedReq.new instead')
  static DynRedReq create() => DynRedReq._();
  static $pb.GeneratedMessage $_createMessage() => DynRedReq._();
  @$core.override
  DynRedReq createEmptyInstance() => DynRedReq._();
  @$core.pragma('dart2js:noInline')
  static DynRedReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DynRedReq>(DynRedReq.$_createMessage);
  static DynRedReq? _defaultInstance;

  /// 参见 [`TabOffset`]
  @$pb.TagNumber(1)
  $pb.PbList<TabOffset> get tabOffset => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get isNewInstall => $_getBF(1);
  @$pb.TagNumber(2)
  set isNewInstall($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsNewInstall() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsNewInstall() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isCodeStart => $_getBF(2);
  @$pb.TagNumber(3)
  set isCodeStart($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsCodeStart() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsCodeStart() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$fixnum.Int64> get newFollowUpMids => $_getList(3);

  @$pb.TagNumber(5)
  DynRedReq_DynRedReqScene get reqScene => $_getN(4);
  @$pb.TagNumber(5)
  set reqScene(DynRedReq_DynRedReqScene value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasReqScene() => $_has(4);
  @$pb.TagNumber(5)
  void clearReqScene() => $_clearField(5);
}

/// 动态红点样式
class DynRedStyle extends $pb.GeneratedMessage {
  factory DynRedStyle({
    BgType? bgType,
    CornerType? cornerType,
    $core.int? displayTime,
    $core.String? cornerMark,
    DynRedStyleUp? up,
    StyleType? type,
    CornerInfo? cornerInfo,
  }) {
    final result = DynRedStyle._();
    if (bgType != null) result.bgType = bgType;
    if (cornerType != null) result.cornerType = cornerType;
    if (displayTime != null) result.displayTime = displayTime;
    if (cornerMark != null) result.cornerMark = cornerMark;
    if (up != null) result.up = up;
    if (type != null) result.type = type;
    if (cornerInfo != null) result.cornerInfo = cornerInfo;
    return result;
  }

  DynRedStyle._();

  factory DynRedStyle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynRedStyle()..mergeFromBuffer(data, registry);
  factory DynRedStyle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynRedStyle()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynRedStyle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynRedStyle.$_createMessage)
    ..aE<BgType>(1, _omitFieldNames ? '' : 'bgType', enumValues: BgType.values)
    ..aE<CornerType>(2, _omitFieldNames ? '' : 'cornerType',
        enumValues: CornerType.values)
    ..aI(3, _omitFieldNames ? '' : 'displayTime')
    ..aOS(4, _omitFieldNames ? '' : 'cornerMark')
    ..aOM<DynRedStyleUp>(5, _omitFieldNames ? '' : 'up',
        subBuilder: DynRedStyleUp.$_createMessage)
    ..aE<StyleType>(6, _omitFieldNames ? '' : 'type',
        enumValues: StyleType.values)
    ..aOM<CornerInfo>(7, _omitFieldNames ? '' : 'cornerInfo',
        subBuilder: CornerInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynRedStyle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynRedStyle copyWith(void Function(DynRedStyle) updates) =>
      super.copyWith((message) => updates(message as DynRedStyle))
          as DynRedStyle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DynRedStyle() / DynRedStyle.new instead')
  static DynRedStyle create() => DynRedStyle._();
  static $pb.GeneratedMessage $_createMessage() => DynRedStyle._();
  @$core.override
  DynRedStyle createEmptyInstance() => DynRedStyle._();
  @$core.pragma('dart2js:noInline')
  static DynRedStyle getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DynRedStyle>(
          DynRedStyle.$_createMessage);
  static DynRedStyle? _defaultInstance;

  @$pb.TagNumber(1)
  BgType get bgType => $_getN(0);
  @$pb.TagNumber(1)
  set bgType(BgType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBgType() => $_has(0);
  @$pb.TagNumber(1)
  void clearBgType() => $_clearField(1);

  @$pb.TagNumber(2)
  CornerType get cornerType => $_getN(1);
  @$pb.TagNumber(2)
  set cornerType(CornerType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCornerType() => $_has(1);
  @$pb.TagNumber(2)
  void clearCornerType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get displayTime => $_getIZ(2);
  @$pb.TagNumber(3)
  set displayTime($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayTime() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get cornerMark => $_getSZ(3);
  @$pb.TagNumber(4)
  set cornerMark($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCornerMark() => $_has(3);
  @$pb.TagNumber(4)
  void clearCornerMark() => $_clearField(4);

  @$pb.TagNumber(5)
  DynRedStyleUp get up => $_getN(4);
  @$pb.TagNumber(5)
  set up(DynRedStyleUp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasUp() => $_has(4);
  @$pb.TagNumber(5)
  void clearUp() => $_clearField(5);
  @$pb.TagNumber(5)
  DynRedStyleUp ensureUp() => $_ensure(4);

  @$pb.TagNumber(6)
  StyleType get type => $_getN(5);
  @$pb.TagNumber(6)
  set type(StyleType value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasType() => $_has(5);
  @$pb.TagNumber(6)
  void clearType() => $_clearField(6);

  @$pb.TagNumber(7)
  CornerInfo get cornerInfo => $_getN(6);
  @$pb.TagNumber(7)
  set cornerInfo(CornerInfo value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCornerInfo() => $_has(6);
  @$pb.TagNumber(7)
  void clearCornerInfo() => $_clearField(7);
  @$pb.TagNumber(7)
  CornerInfo ensureCornerInfo() => $_ensure(6);
}

class DynRedStyleUp extends $pb.GeneratedMessage {
  factory DynRedStyleUp({
    $fixnum.Int64? uid,
    $core.String? face,
    StyleType? faceType,
    Color? borderColor,
  }) {
    final result = DynRedStyleUp._();
    if (uid != null) result.uid = uid;
    if (face != null) result.face = face;
    if (faceType != null) result.faceType = faceType;
    if (borderColor != null) result.borderColor = borderColor;
    return result;
  }

  DynRedStyleUp._();

  factory DynRedStyleUp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynRedStyleUp()..mergeFromBuffer(data, registry);
  factory DynRedStyleUp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynRedStyleUp()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynRedStyleUp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynRedStyleUp.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'uid')
    ..aOS(2, _omitFieldNames ? '' : 'face')
    ..aE<StyleType>(3, _omitFieldNames ? '' : 'faceType',
        enumValues: StyleType.values)
    ..aOM<Color>(4, _omitFieldNames ? '' : 'borderColor',
        subBuilder: Color.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynRedStyleUp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynRedStyleUp copyWith(void Function(DynRedStyleUp) updates) =>
      super.copyWith((message) => updates(message as DynRedStyleUp))
          as DynRedStyleUp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DynRedStyleUp() / DynRedStyleUp.new instead')
  static DynRedStyleUp create() => DynRedStyleUp._();
  static $pb.GeneratedMessage $_createMessage() => DynRedStyleUp._();
  @$core.override
  DynRedStyleUp createEmptyInstance() => DynRedStyleUp._();
  @$core.pragma('dart2js:noInline')
  static DynRedStyleUp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DynRedStyleUp>(
          DynRedStyleUp.$_createMessage);
  static DynRedStyleUp? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get uid => $_getI64(0);
  @$pb.TagNumber(1)
  set uid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get face => $_getSZ(1);
  @$pb.TagNumber(2)
  set face($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFace() => $_has(1);
  @$pb.TagNumber(2)
  void clearFace() => $_clearField(2);

  @$pb.TagNumber(3)
  StyleType get faceType => $_getN(2);
  @$pb.TagNumber(3)
  set faceType(StyleType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFaceType() => $_has(2);
  @$pb.TagNumber(3)
  void clearFaceType() => $_clearField(3);

  @$pb.TagNumber(4)
  Color get borderColor => $_getN(3);
  @$pb.TagNumber(4)
  set borderColor(Color value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBorderColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearBorderColor() => $_clearField(4);
  @$pb.TagNumber(4)
  Color ensureBorderColor() => $_ensure(3);
}

/// 动态 tab
class DynTab extends $pb.GeneratedMessage {
  factory DynTab({
    $core.String? title,
    $core.String? uri,
    $core.String? bubble,
    $core.int? redPoint,
    $fixnum.Int64? cityId,
    $core.int? isPopup,
    Popup? popup,
    $core.bool? defaultTab,
    $core.String? subTitle,
    $core.String? anchor,
    $core.String? internalTest,
  }) {
    final result = DynTab._();
    if (title != null) result.title = title;
    if (uri != null) result.uri = uri;
    if (bubble != null) result.bubble = bubble;
    if (redPoint != null) result.redPoint = redPoint;
    if (cityId != null) result.cityId = cityId;
    if (isPopup != null) result.isPopup = isPopup;
    if (popup != null) result.popup = popup;
    if (defaultTab != null) result.defaultTab = defaultTab;
    if (subTitle != null) result.subTitle = subTitle;
    if (anchor != null) result.anchor = anchor;
    if (internalTest != null) result.internalTest = internalTest;
    return result;
  }

  DynTab._();

  factory DynTab.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynTab()..mergeFromBuffer(data, registry);
  factory DynTab.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynTab()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynTab',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynTab.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'uri')
    ..aOS(3, _omitFieldNames ? '' : 'bubble')
    ..aI(4, _omitFieldNames ? '' : 'redPoint')
    ..aInt64(5, _omitFieldNames ? '' : 'cityId')
    ..aI(6, _omitFieldNames ? '' : 'isPopup')
    ..aOM<Popup>(7, _omitFieldNames ? '' : 'popup',
        subBuilder: Popup.$_createMessage)
    ..aOB(8, _omitFieldNames ? '' : 'defaultTab')
    ..aOS(9, _omitFieldNames ? '' : 'subTitle')
    ..aOS(10, _omitFieldNames ? '' : 'anchor')
    ..aOS(11, _omitFieldNames ? '' : 'internalTest')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynTab clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynTab copyWith(void Function(DynTab) updates) =>
      super.copyWith((message) => updates(message as DynTab)) as DynTab;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DynTab() / DynTab.new instead')
  static DynTab create() => DynTab._();
  static $pb.GeneratedMessage $_createMessage() => DynTab._();
  @$core.override
  DynTab createEmptyInstance() => DynTab._();
  @$core.pragma('dart2js:noInline')
  static DynTab getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DynTab>(DynTab.$_createMessage);
  static DynTab? _defaultInstance;

  /// tab 标题
  ///
  /// 优先展示用, 未开启状态第一次请求返回 `同城`, 后续请求返回对应城市名
  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  /// 跳转链接
  @$pb.TagNumber(2)
  $core.String get uri => $_getSZ(1);
  @$pb.TagNumber(2)
  set uri($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearUri() => $_clearField(2);

  /// 气泡内容
  @$pb.TagNumber(3)
  $core.String get bubble => $_getSZ(2);
  @$pb.TagNumber(3)
  set bubble($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBubble() => $_has(2);
  @$pb.TagNumber(3)
  void clearBubble() => $_clearField(3);

  /// 是否推红点
  @$pb.TagNumber(4)
  $core.int get redPoint => $_getIZ(3);
  @$pb.TagNumber(4)
  set redPoint($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRedPoint() => $_has(3);
  @$pb.TagNumber(4)
  void clearRedPoint() => $_clearField(4);

  /// 城市 ID
  @$pb.TagNumber(5)
  $fixnum.Int64 get cityId => $_getI64(4);
  @$pb.TagNumber(5)
  set cityId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCityId() => $_clearField(5);

  /// 是否弹窗
  @$pb.TagNumber(6)
  $core.int get isPopup => $_getIZ(5);
  @$pb.TagNumber(6)
  set isPopup($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsPopup() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsPopup() => $_clearField(6);

  /// 弹窗内容
  @$pb.TagNumber(7)
  Popup get popup => $_getN(6);
  @$pb.TagNumber(7)
  set popup(Popup value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPopup() => $_has(6);
  @$pb.TagNumber(7)
  void clearPopup() => $_clearField(7);
  @$pb.TagNumber(7)
  Popup ensurePopup() => $_ensure(6);

  /// 是否默认 tab
  @$pb.TagNumber(8)
  $core.bool get defaultTab => $_getBF(7);
  @$pb.TagNumber(8)
  set defaultTab($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDefaultTab() => $_has(7);
  @$pb.TagNumber(8)
  void clearDefaultTab() => $_clearField(8);

  /// 副标题
  ///
  /// 对应城市名
  @$pb.TagNumber(9)
  $core.String get subTitle => $_getSZ(8);
  @$pb.TagNumber(9)
  set subTitle($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSubTitle() => $_has(8);
  @$pb.TagNumber(9)
  void clearSubTitle() => $_clearField(9);

  /// 锚点字段
  @$pb.TagNumber(10)
  $core.String get anchor => $_getSZ(9);
  @$pb.TagNumber(10)
  set anchor($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAnchor() => $_has(9);
  @$pb.TagNumber(10)
  void clearAnchor() => $_clearField(10);

  /// ? 内部测试
  @$pb.TagNumber(11)
  $core.String get internalTest => $_getSZ(10);
  @$pb.TagNumber(11)
  set internalTest($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasInternalTest() => $_has(10);
  @$pb.TagNumber(11)
  void clearInternalTest() => $_clearField(11);
}

/// 动态 tab 请求返回值
class DynTabReply extends $pb.GeneratedMessage {
  factory DynTabReply({
    $core.Iterable<DynTab>? dynTab,
  }) {
    final result = DynTabReply._();
    if (dynTab != null) result.dynTab.addAll(dynTab);
    return result;
  }

  DynTabReply._();

  factory DynTabReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynTabReply()..mergeFromBuffer(data, registry);
  factory DynTabReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynTabReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynTabReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynTabReply.$_createMessage)
    ..pPM<DynTab>(1, _omitFieldNames ? '' : 'dynTab',
        subBuilder: DynTab.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynTabReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynTabReply copyWith(void Function(DynTabReply) updates) =>
      super.copyWith((message) => updates(message as DynTabReply))
          as DynTabReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DynTabReply() / DynTabReply.new instead')
  static DynTabReply create() => DynTabReply._();
  static $pb.GeneratedMessage $_createMessage() => DynTabReply._();
  @$core.override
  DynTabReply createEmptyInstance() => DynTabReply._();
  @$core.pragma('dart2js:noInline')
  static DynTabReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DynTabReply>(
          DynTabReply.$_createMessage);
  static DynTabReply? _defaultInstance;

  /// 参见 [`DynTab`]
  @$pb.TagNumber(1)
  $pb.PbList<DynTab> get dynTab => $_getList(0);
}

/// 动态 tab 请求参数
class DynTabReq extends $pb.GeneratedMessage {
  factory DynTabReq({
    $core.int? teenagersMode,
  }) {
    final result = DynTabReq._();
    if (teenagersMode != null) result.teenagersMode = teenagersMode;
    return result;
  }

  DynTabReq._();

  factory DynTabReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynTabReq()..mergeFromBuffer(data, registry);
  factory DynTabReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynTabReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynTabReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynTabReq.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'teenagersMode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynTabReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynTabReq copyWith(void Function(DynTabReq) updates) =>
      super.copyWith((message) => updates(message as DynTabReq)) as DynTabReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DynTabReq() / DynTabReq.new instead')
  static DynTabReq create() => DynTabReq._();
  static $pb.GeneratedMessage $_createMessage() => DynTabReq._();
  @$core.override
  DynTabReq createEmptyInstance() => DynTabReq._();
  @$core.pragma('dart2js:noInline')
  static DynTabReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DynTabReq>(DynTabReq.$_createMessage);
  static DynTabReq? _defaultInstance;

  /// 青少年模式
  @$pb.TagNumber(1)
  $core.int get teenagersMode => $_getIZ(0);
  @$pb.TagNumber(1)
  set teenagersMode($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTeenagersMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearTeenagersMode() => $_clearField(1);
}

/// 最近访问标记已读请求参数
class DynUpdOffsetReq extends $pb.GeneratedMessage {
  factory DynUpdOffsetReq({
    $fixnum.Int64? hostUid,
    $core.String? readOffset,
  }) {
    final result = DynUpdOffsetReq._();
    if (hostUid != null) result.hostUid = hostUid;
    if (readOffset != null) result.readOffset = readOffset;
    return result;
  }

  DynUpdOffsetReq._();

  factory DynUpdOffsetReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynUpdOffsetReq()..mergeFromBuffer(data, registry);
  factory DynUpdOffsetReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynUpdOffsetReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynUpdOffsetReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynUpdOffsetReq.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'hostUid')
    ..aOS(2, _omitFieldNames ? '' : 'readOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynUpdOffsetReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynUpdOffsetReq copyWith(void Function(DynUpdOffsetReq) updates) =>
      super.copyWith((message) => updates(message as DynUpdOffsetReq))
          as DynUpdOffsetReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DynUpdOffsetReq() / DynUpdOffsetReq.new instead')
  static DynUpdOffsetReq create() => DynUpdOffsetReq._();
  static $pb.GeneratedMessage $_createMessage() => DynUpdOffsetReq._();
  @$core.override
  DynUpdOffsetReq createEmptyInstance() => DynUpdOffsetReq._();
  @$core.pragma('dart2js:noInline')
  static DynUpdOffsetReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DynUpdOffsetReq>(
          DynUpdOffsetReq.$_createMessage);
  static DynUpdOffsetReq? _defaultInstance;

  /// 被访问者的 mid
  @$pb.TagNumber(1)
  $fixnum.Int64 get hostUid => $_getI64(0);
  @$pb.TagNumber(1)
  set hostUid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHostUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearHostUid() => $_clearField(1);

  /// 用户已读进度
  @$pb.TagNumber(2)
  $core.String get readOffset => $_getSZ(1);
  @$pb.TagNumber(2)
  set readOffset($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReadOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearReadOffset() => $_clearField(2);
}

/// 最近访问个人视频 feed 流返回值
class DynVideoPersonalReply extends $pb.GeneratedMessage {
  factory DynVideoPersonalReply({
    $core.Iterable<DynamicItem>? list,
    $core.String? offset,
    $core.int? hasMore,
    $core.String? readOffset,
  }) {
    final result = DynVideoPersonalReply._();
    if (list != null) result.list.addAll(list);
    if (offset != null) result.offset = offset;
    if (hasMore != null) result.hasMore = hasMore;
    if (readOffset != null) result.readOffset = readOffset;
    return result;
  }

  DynVideoPersonalReply._();

  factory DynVideoPersonalReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynVideoPersonalReply()..mergeFromBuffer(data, registry);
  factory DynVideoPersonalReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynVideoPersonalReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynVideoPersonalReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynVideoPersonalReply.$_createMessage)
    ..pPM<DynamicItem>(1, _omitFieldNames ? '' : 'list',
        subBuilder: DynamicItem.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'offset')
    ..aI(3, _omitFieldNames ? '' : 'hasMore')
    ..aOS(4, _omitFieldNames ? '' : 'readOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynVideoPersonalReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynVideoPersonalReply copyWith(
          void Function(DynVideoPersonalReply) updates) =>
      super.copyWith((message) => updates(message as DynVideoPersonalReply))
          as DynVideoPersonalReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DynVideoPersonalReply() / DynVideoPersonalReply.new instead')
  static DynVideoPersonalReply create() => DynVideoPersonalReply._();
  static $pb.GeneratedMessage $_createMessage() => DynVideoPersonalReply._();
  @$core.override
  DynVideoPersonalReply createEmptyInstance() => DynVideoPersonalReply._();
  @$core.pragma('dart2js:noInline')
  static DynVideoPersonalReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DynVideoPersonalReply>(
          DynVideoPersonalReply.$_createMessage);
  static DynVideoPersonalReply? _defaultInstance;

  /// 参见 [`DynamicItem`]
  @$pb.TagNumber(1)
  $pb.PbList<DynamicItem> get list => $_getList(0);

  /// 偏移量
  @$pb.TagNumber(2)
  $core.String get offset => $_getSZ(1);
  @$pb.TagNumber(2)
  set offset($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);

  /// 是否还有更多
  @$pb.TagNumber(3)
  $core.int get hasMore => $_getIZ(2);
  @$pb.TagNumber(3)
  set hasMore($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasMore() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasMore() => $_clearField(3);

  /// 已读进度
  @$pb.TagNumber(4)
  $core.String get readOffset => $_getSZ(3);
  @$pb.TagNumber(4)
  set readOffset($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReadOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearReadOffset() => $_clearField(4);
}

/// 最近访问个人视频 feed 流请求参数
class DynVideoPersonalReq extends $pb.GeneratedMessage {
  factory DynVideoPersonalReq({
    $core.int? teenagersMode,
    $fixnum.Int64? hostUid,
    $core.String? offset,
    $core.int? page,
    $core.int? isPreload,
    $core.int? qn,
    $core.int? fnver,
    $core.int? fnval,
    $core.int? forceHost,
    $core.int? fourk,
  }) {
    final result = DynVideoPersonalReq._();
    if (teenagersMode != null) result.teenagersMode = teenagersMode;
    if (hostUid != null) result.hostUid = hostUid;
    if (offset != null) result.offset = offset;
    if (page != null) result.page = page;
    if (isPreload != null) result.isPreload = isPreload;
    if (qn != null) result.qn = qn;
    if (fnver != null) result.fnver = fnver;
    if (fnval != null) result.fnval = fnval;
    if (forceHost != null) result.forceHost = forceHost;
    if (fourk != null) result.fourk = fourk;
    return result;
  }

  DynVideoPersonalReq._();

  factory DynVideoPersonalReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynVideoPersonalReq()..mergeFromBuffer(data, registry);
  factory DynVideoPersonalReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynVideoPersonalReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynVideoPersonalReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynVideoPersonalReq.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'teenagersMode')
    ..aInt64(2, _omitFieldNames ? '' : 'hostUid')
    ..aOS(3, _omitFieldNames ? '' : 'offset')
    ..aI(4, _omitFieldNames ? '' : 'page')
    ..aI(5, _omitFieldNames ? '' : 'isPreload')
    ..aI(6, _omitFieldNames ? '' : 'qn')
    ..aI(7, _omitFieldNames ? '' : 'fnver')
    ..aI(8, _omitFieldNames ? '' : 'fnval')
    ..aI(9, _omitFieldNames ? '' : 'forceHost')
    ..aI(10, _omitFieldNames ? '' : 'fourk')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynVideoPersonalReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynVideoPersonalReq copyWith(void Function(DynVideoPersonalReq) updates) =>
      super.copyWith((message) => updates(message as DynVideoPersonalReq))
          as DynVideoPersonalReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use DynVideoPersonalReq() / DynVideoPersonalReq.new instead')
  static DynVideoPersonalReq create() => DynVideoPersonalReq._();
  static $pb.GeneratedMessage $_createMessage() => DynVideoPersonalReq._();
  @$core.override
  DynVideoPersonalReq createEmptyInstance() => DynVideoPersonalReq._();
  @$core.pragma('dart2js:noInline')
  static DynVideoPersonalReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DynVideoPersonalReq>(
          DynVideoPersonalReq.$_createMessage);
  static DynVideoPersonalReq? _defaultInstance;

  /// 青少年模式
  @$pb.TagNumber(1)
  $core.int get teenagersMode => $_getIZ(0);
  @$pb.TagNumber(1)
  set teenagersMode($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTeenagersMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearTeenagersMode() => $_clearField(1);

  /// 被访问者的 mid
  @$pb.TagNumber(2)
  $fixnum.Int64 get hostUid => $_getI64(1);
  @$pb.TagNumber(2)
  set hostUid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHostUid() => $_has(1);
  @$pb.TagNumber(2)
  void clearHostUid() => $_clearField(2);

  /// 偏移量
  ///
  /// 第一页可传空
  @$pb.TagNumber(3)
  $core.String get offset => $_getSZ(2);
  @$pb.TagNumber(3)
  set offset($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => $_clearField(3);

  /// 标明下拉几次
  @$pb.TagNumber(4)
  $core.int get page => $_getIZ(3);
  @$pb.TagNumber(4)
  set page($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPage() => $_has(3);
  @$pb.TagNumber(4)
  void clearPage() => $_clearField(4);

  /// 是否是预加载
  @$pb.TagNumber(5)
  $core.int get isPreload => $_getIZ(4);
  @$pb.TagNumber(5)
  set isPreload($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsPreload() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsPreload() => $_clearField(5);

  /// 清晰度 (供秒开)
  @$pb.TagNumber(6)
  $core.int get qn => $_getIZ(5);
  @$pb.TagNumber(6)
  set qn($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasQn() => $_has(5);
  @$pb.TagNumber(6)
  void clearQn() => $_clearField(6);

  /// 功能版本号 (供秒开)
  @$pb.TagNumber(7)
  $core.int get fnver => $_getIZ(6);
  @$pb.TagNumber(7)
  set fnver($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFnver() => $_has(6);
  @$pb.TagNumber(7)
  void clearFnver() => $_clearField(7);

  /// 功能标识 (供秒开)
  @$pb.TagNumber(8)
  $core.int get fnval => $_getIZ(7);
  @$pb.TagNumber(8)
  set fnval($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFnval() => $_has(7);
  @$pb.TagNumber(8)
  void clearFnval() => $_clearField(8);

  /// 返回 playurl 是否强制使用域名 (供秒开)
  @$pb.TagNumber(9)
  $core.int get forceHost => $_getIZ(8);
  @$pb.TagNumber(9)
  set forceHost($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasForceHost() => $_has(8);
  @$pb.TagNumber(9)
  void clearForceHost() => $_clearField(9);

  /// 是否需要 4K 视频 (供秒开)
  @$pb.TagNumber(10)
  $core.int get fourk => $_getIZ(9);
  @$pb.TagNumber(10)
  set fourk($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasFourk() => $_has(9);
  @$pb.TagNumber(10)
  void clearFourk() => $_clearField(10);
}

/// 动态视频页请求参数
class DynVideoReq extends $pb.GeneratedMessage {
  factory DynVideoReq({
    $core.int? teenagersMode,
    $core.String? updateBaseline,
    $core.String? offset,
    $core.int? page,
    $core.int? refreshType,
    $core.int? qn,
    $core.int? fnver,
    $core.int? fnval,
    $core.int? forceHost,
    $core.int? fourk,
  }) {
    final result = DynVideoReq._();
    if (teenagersMode != null) result.teenagersMode = teenagersMode;
    if (updateBaseline != null) result.updateBaseline = updateBaseline;
    if (offset != null) result.offset = offset;
    if (page != null) result.page = page;
    if (refreshType != null) result.refreshType = refreshType;
    if (qn != null) result.qn = qn;
    if (fnver != null) result.fnver = fnver;
    if (fnval != null) result.fnval = fnval;
    if (forceHost != null) result.forceHost = forceHost;
    if (fourk != null) result.fourk = fourk;
    return result;
  }

  DynVideoReq._();

  factory DynVideoReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynVideoReq()..mergeFromBuffer(data, registry);
  factory DynVideoReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynVideoReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynVideoReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynVideoReq.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'teenagersMode')
    ..aOS(2, _omitFieldNames ? '' : 'updateBaseline')
    ..aOS(3, _omitFieldNames ? '' : 'offset')
    ..aI(4, _omitFieldNames ? '' : 'page')
    ..aI(5, _omitFieldNames ? '' : 'refreshType')
    ..aI(6, _omitFieldNames ? '' : 'qn')
    ..aI(7, _omitFieldNames ? '' : 'fnver')
    ..aI(8, _omitFieldNames ? '' : 'fnval')
    ..aI(9, _omitFieldNames ? '' : 'forceHost')
    ..aI(10, _omitFieldNames ? '' : 'fourk')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynVideoReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynVideoReq copyWith(void Function(DynVideoReq) updates) =>
      super.copyWith((message) => updates(message as DynVideoReq))
          as DynVideoReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DynVideoReq() / DynVideoReq.new instead')
  static DynVideoReq create() => DynVideoReq._();
  static $pb.GeneratedMessage $_createMessage() => DynVideoReq._();
  @$core.override
  DynVideoReq createEmptyInstance() => DynVideoReq._();
  @$core.pragma('dart2js:noInline')
  static DynVideoReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DynVideoReq>(
          DynVideoReq.$_createMessage);
  static DynVideoReq? _defaultInstance;

  /// 青少年模式
  @$pb.TagNumber(1)
  $core.int get teenagersMode => $_getIZ(0);
  @$pb.TagNumber(1)
  set teenagersMode($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTeenagersMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearTeenagersMode() => $_clearField(1);

  /// 透传参数
  @$pb.TagNumber(2)
  $core.String get updateBaseline => $_getSZ(1);
  @$pb.TagNumber(2)
  set updateBaseline($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateBaseline() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateBaseline() => $_clearField(2);

  /// 透传参数
  @$pb.TagNumber(3)
  $core.String get offset => $_getSZ(2);
  @$pb.TagNumber(3)
  set offset($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => $_clearField(3);

  /// 向下翻页数
  @$pb.TagNumber(4)
  $core.int get page => $_getIZ(3);
  @$pb.TagNumber(4)
  set page($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPage() => $_has(3);
  @$pb.TagNumber(4)
  void clearPage() => $_clearField(4);

  /// 刷新方式
  ///
  /// - 1: 向上刷新
  /// - 2: 向下翻页
  @$pb.TagNumber(5)
  $core.int get refreshType => $_getIZ(4);
  @$pb.TagNumber(5)
  set refreshType($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRefreshType() => $_has(4);
  @$pb.TagNumber(5)
  void clearRefreshType() => $_clearField(5);

  /// 清晰度 (供秒开)
  @$pb.TagNumber(6)
  $core.int get qn => $_getIZ(5);
  @$pb.TagNumber(6)
  set qn($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasQn() => $_has(5);
  @$pb.TagNumber(6)
  void clearQn() => $_clearField(6);

  /// 功能版本号 (供秒开)
  @$pb.TagNumber(7)
  $core.int get fnver => $_getIZ(6);
  @$pb.TagNumber(7)
  set fnver($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFnver() => $_has(6);
  @$pb.TagNumber(7)
  void clearFnver() => $_clearField(7);

  /// 功能标识 (供秒开)
  @$pb.TagNumber(8)
  $core.int get fnval => $_getIZ(7);
  @$pb.TagNumber(8)
  set fnval($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFnval() => $_has(7);
  @$pb.TagNumber(8)
  void clearFnval() => $_clearField(8);

  /// 返回 playurl 是否强制使用域名 (供秒开)
  @$pb.TagNumber(9)
  $core.int get forceHost => $_getIZ(8);
  @$pb.TagNumber(9)
  set forceHost($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasForceHost() => $_has(8);
  @$pb.TagNumber(9)
  void clearForceHost() => $_clearField(9);

  /// 是否需要 4K 视频 (供秒开)
  @$pb.TagNumber(10)
  $core.int get fourk => $_getIZ(9);
  @$pb.TagNumber(10)
  set fourk($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasFourk() => $_has(9);
  @$pb.TagNumber(10)
  void clearFourk() => $_clearField(10);
}

/// 动态视频页返回值
class DynVideoReqReply extends $pb.GeneratedMessage {
  factory DynVideoReqReply({
    $core.Iterable<DynamicItem>? list,
    $core.int? updateNum,
    $core.String? historyOffset,
    $core.String? updateBaseline,
    $core.int? hasMore,
  }) {
    final result = DynVideoReqReply._();
    if (list != null) result.list.addAll(list);
    if (updateNum != null) result.updateNum = updateNum;
    if (historyOffset != null) result.historyOffset = historyOffset;
    if (updateBaseline != null) result.updateBaseline = updateBaseline;
    if (hasMore != null) result.hasMore = hasMore;
    return result;
  }

  DynVideoReqReply._();

  factory DynVideoReqReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynVideoReqReply()..mergeFromBuffer(data, registry);
  factory DynVideoReqReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynVideoReqReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynVideoReqReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynVideoReqReply.$_createMessage)
    ..pPM<DynamicItem>(1, _omitFieldNames ? '' : 'list',
        subBuilder: DynamicItem.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'updateNum')
    ..aOS(3, _omitFieldNames ? '' : 'historyOffset')
    ..aOS(4, _omitFieldNames ? '' : 'updateBaseline')
    ..aI(5, _omitFieldNames ? '' : 'hasMore')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynVideoReqReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynVideoReqReply copyWith(void Function(DynVideoReqReply) updates) =>
      super.copyWith((message) => updates(message as DynVideoReqReply))
          as DynVideoReqReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DynVideoReqReply() / DynVideoReqReply.new instead')
  static DynVideoReqReply create() => DynVideoReqReply._();
  static $pb.GeneratedMessage $_createMessage() => DynVideoReqReply._();
  @$core.override
  DynVideoReqReply createEmptyInstance() => DynVideoReqReply._();
  @$core.pragma('dart2js:noInline')
  static DynVideoReqReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DynVideoReqReply>(
          DynVideoReqReply.$_createMessage);
  static DynVideoReqReply? _defaultInstance;

  /// 动态列表
  @$pb.TagNumber(1)
  $pb.PbList<DynamicItem> get list => $_getList(0);

  /// 更新的动态数
  @$pb.TagNumber(2)
  $core.int get updateNum => $_getIZ(1);
  @$pb.TagNumber(2)
  set updateNum($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateNum() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateNum() => $_clearField(2);

  /// 历史偏移
  @$pb.TagNumber(3)
  $core.String get historyOffset => $_getSZ(2);
  @$pb.TagNumber(3)
  set historyOffset($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHistoryOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearHistoryOffset() => $_clearField(3);

  /// 更新基础信息
  @$pb.TagNumber(4)
  $core.String get updateBaseline => $_getSZ(3);
  @$pb.TagNumber(4)
  set updateBaseline($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUpdateBaseline() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpdateBaseline() => $_clearField(4);

  /// 是否还有更多
  @$pb.TagNumber(5)
  $core.int get hasMore => $_getIZ(4);
  @$pb.TagNumber(5)
  set hasMore($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHasMore() => $_has(4);
  @$pb.TagNumber(5)
  void clearHasMore() => $_clearField(5);
}

/// 动态卡片项
class DynamicItem extends $pb.GeneratedMessage {
  factory DynamicItem({
    $core.String? cardType,
    $core.String? itemType,
    $core.Iterable<Module>? modules,
    $core.String? dynIdStr,
    $core.String? origDynIdStr,
    $core.int? rType,
    $core.int? hasFold,
  }) {
    final result = DynamicItem._();
    if (cardType != null) result.cardType = cardType;
    if (itemType != null) result.itemType = itemType;
    if (modules != null) result.modules.addAll(modules);
    if (dynIdStr != null) result.dynIdStr = dynIdStr;
    if (origDynIdStr != null) result.origDynIdStr = origDynIdStr;
    if (rType != null) result.rType = rType;
    if (hasFold != null) result.hasFold = hasFold;
    return result;
  }

  DynamicItem._();

  factory DynamicItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynamicItem()..mergeFromBuffer(data, registry);
  factory DynamicItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DynamicItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynamicItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: DynamicItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'cardType')
    ..aOS(2, _omitFieldNames ? '' : 'itemType')
    ..pPM<Module>(3, _omitFieldNames ? '' : 'modules',
        subBuilder: Module.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'dynIdStr')
    ..aOS(5, _omitFieldNames ? '' : 'origDynIdStr')
    ..aI(6, _omitFieldNames ? '' : 'rType')
    ..aI(7, _omitFieldNames ? '' : 'hasFold')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynamicItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynamicItem copyWith(void Function(DynamicItem) updates) =>
      super.copyWith((message) => updates(message as DynamicItem))
          as DynamicItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DynamicItem() / DynamicItem.new instead')
  static DynamicItem create() => DynamicItem._();
  static $pb.GeneratedMessage $_createMessage() => DynamicItem._();
  @$core.override
  DynamicItem createEmptyInstance() => DynamicItem._();
  @$core.pragma('dart2js:noInline')
  static DynamicItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DynamicItem>(
          DynamicItem.$_createMessage);
  static DynamicItem? _defaultInstance;

  /// 动态卡片类型
  ///
  /// - 转发: `forward`
  /// - 稿件视频: `av`
  /// - 折叠: `fold`
  /// - PGC 内容: `pgc`
  /// - 付费视频: `courses`
  /// - 最近访问列表: `upList`
  /// - 我的追番列表: `followList`
  @$pb.TagNumber(1)
  $core.String get cardType => $_getSZ(0);
  @$pb.TagNumber(1)
  set cardType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCardType() => $_has(0);
  @$pb.TagNumber(1)
  void clearCardType() => $_clearField(1);

  /// 转发类型的 items 的类型
  @$pb.TagNumber(2)
  $core.String get itemType => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemType() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemType() => $_clearField(2);

  /// 模块内容
  @$pb.TagNumber(3)
  $pb.PbList<Module> get modules => $_getList(2);

  /// 动态 ID (string)
  @$pb.TagNumber(4)
  $core.String get dynIdStr => $_getSZ(3);
  @$pb.TagNumber(4)
  set dynIdStr($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDynIdStr() => $_has(3);
  @$pb.TagNumber(4)
  void clearDynIdStr() => $_clearField(4);

  /// 转发源动态 ID(string)
  @$pb.TagNumber(5)
  $core.String get origDynIdStr => $_getSZ(4);
  @$pb.TagNumber(5)
  set origDynIdStr($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOrigDynIdStr() => $_has(4);
  @$pb.TagNumber(5)
  void clearOrigDynIdStr() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get rType => $_getIZ(5);
  @$pb.TagNumber(6)
  set rType($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRType() => $_has(5);
  @$pb.TagNumber(6)
  void clearRType() => $_clearField(6);

  /// 该卡片下面是否含折叠卡片
  @$pb.TagNumber(7)
  $core.int get hasFold => $_getIZ(6);
  @$pb.TagNumber(7)
  set hasFold($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasHasFold() => $_has(6);
  @$pb.TagNumber(7)
  void clearHasFold() => $_clearField(7);
}

class Exp extends $pb.GeneratedMessage {
  factory Exp({
    $core.String? expName,
    $core.String? expGroup,
  }) {
    final result = Exp._();
    if (expName != null) result.expName = expName;
    if (expGroup != null) result.expGroup = expGroup;
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
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: Exp.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'expName')
    ..aOS(2, _omitFieldNames ? '' : 'expGroup')
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
  $core.String get expName => $_getSZ(0);
  @$pb.TagNumber(1)
  set expName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExpName() => $_has(0);
  @$pb.TagNumber(1)
  void clearExpName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get expGroup => $_getSZ(1);
  @$pb.TagNumber(2)
  set expGroup($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpGroup() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpGroup() => $_clearField(2);
}

class ExpConf extends $pb.GeneratedMessage {
  factory ExpConf({
    $core.int? expEnable,
    $core.Iterable<Exp>? exps,
  }) {
    final result = ExpConf._();
    if (expEnable != null) result.expEnable = expEnable;
    if (exps != null) result.exps.addAll(exps);
    return result;
  }

  ExpConf._();

  factory ExpConf.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExpConf()..mergeFromBuffer(data, registry);
  factory ExpConf.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExpConf()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExpConf',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: ExpConf.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'expEnable')
    ..pPM<Exp>(2, _omitFieldNames ? '' : 'exps',
        subBuilder: Exp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExpConf clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExpConf copyWith(void Function(ExpConf) updates) =>
      super.copyWith((message) => updates(message as ExpConf)) as ExpConf;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ExpConf() / ExpConf.new instead')
  static ExpConf create() => ExpConf._();
  static $pb.GeneratedMessage $_createMessage() => ExpConf._();
  @$core.override
  ExpConf createEmptyInstance() => ExpConf._();
  @$core.pragma('dart2js:noInline')
  static ExpConf getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExpConf>(ExpConf.$_createMessage);
  static ExpConf? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get expEnable => $_getIZ(0);
  @$pb.TagNumber(1)
  set expEnable($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExpEnable() => $_has(0);
  @$pb.TagNumber(1)
  void clearExpEnable() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Exp> get exps => $_getList(1);
}

/// 拓展信息: 游戏小卡
class ExtInfoGame extends $pb.GeneratedMessage {
  factory ExtInfoGame({
    $core.String? title,
    $core.String? uri,
    $core.String? icon,
  }) {
    final result = ExtInfoGame._();
    if (title != null) result.title = title;
    if (uri != null) result.uri = uri;
    if (icon != null) result.icon = icon;
    return result;
  }

  ExtInfoGame._();

  factory ExtInfoGame.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtInfoGame()..mergeFromBuffer(data, registry);
  factory ExtInfoGame.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtInfoGame()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExtInfoGame',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: ExtInfoGame.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'uri')
    ..aOS(3, _omitFieldNames ? '' : 'icon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtInfoGame clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtInfoGame copyWith(void Function(ExtInfoGame) updates) =>
      super.copyWith((message) => updates(message as ExtInfoGame))
          as ExtInfoGame;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ExtInfoGame() / ExtInfoGame.new instead')
  static ExtInfoGame create() => ExtInfoGame._();
  static $pb.GeneratedMessage $_createMessage() => ExtInfoGame._();
  @$core.override
  ExtInfoGame createEmptyInstance() => ExtInfoGame._();
  @$core.pragma('dart2js:noInline')
  static ExtInfoGame getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExtInfoGame>(
          ExtInfoGame.$_createMessage);
  static ExtInfoGame? _defaultInstance;

  /// 标题
  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  /// 跳转地址
  @$pb.TagNumber(2)
  $core.String get uri => $_getSZ(1);
  @$pb.TagNumber(2)
  set uri($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearUri() => $_clearField(2);

  /// 图标
  @$pb.TagNumber(3)
  $core.String get icon => $_getSZ(2);
  @$pb.TagNumber(3)
  set icon($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearIcon() => $_clearField(3);
}

/// 拓展信息: 热门视频
class ExtInfoHot extends $pb.GeneratedMessage {
  factory ExtInfoHot({
    $core.String? title,
    $core.String? uri,
    $core.String? icon,
  }) {
    final result = ExtInfoHot._();
    if (title != null) result.title = title;
    if (uri != null) result.uri = uri;
    if (icon != null) result.icon = icon;
    return result;
  }

  ExtInfoHot._();

  factory ExtInfoHot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtInfoHot()..mergeFromBuffer(data, registry);
  factory ExtInfoHot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtInfoHot()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExtInfoHot',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: ExtInfoHot.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'uri')
    ..aOS(3, _omitFieldNames ? '' : 'icon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtInfoHot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtInfoHot copyWith(void Function(ExtInfoHot) updates) =>
      super.copyWith((message) => updates(message as ExtInfoHot)) as ExtInfoHot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ExtInfoHot() / ExtInfoHot.new instead')
  static ExtInfoHot create() => ExtInfoHot._();
  static $pb.GeneratedMessage $_createMessage() => ExtInfoHot._();
  @$core.override
  ExtInfoHot createEmptyInstance() => ExtInfoHot._();
  @$core.pragma('dart2js:noInline')
  static ExtInfoHot getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExtInfoHot>(ExtInfoHot.$_createMessage);
  static ExtInfoHot? _defaultInstance;

  /// 标题
  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  /// 跳转地址
  @$pb.TagNumber(2)
  $core.String get uri => $_getSZ(1);
  @$pb.TagNumber(2)
  set uri($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearUri() => $_clearField(2);

  /// 图标
  @$pb.TagNumber(3)
  $core.String get icon => $_getSZ(2);
  @$pb.TagNumber(3)
  set icon($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearIcon() => $_clearField(3);
}

/// 拓展信息: LBS
class ExtInfoLBS extends $pb.GeneratedMessage {
  factory ExtInfoLBS({
    $core.String? title,
    $core.String? uri,
    $core.String? icon,
    $core.int? poiType,
  }) {
    final result = ExtInfoLBS._();
    if (title != null) result.title = title;
    if (uri != null) result.uri = uri;
    if (icon != null) result.icon = icon;
    if (poiType != null) result.poiType = poiType;
    return result;
  }

  ExtInfoLBS._();

  factory ExtInfoLBS.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtInfoLBS()..mergeFromBuffer(data, registry);
  factory ExtInfoLBS.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtInfoLBS()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExtInfoLBS',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: ExtInfoLBS.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'uri')
    ..aOS(3, _omitFieldNames ? '' : 'icon')
    ..aI(4, _omitFieldNames ? '' : 'poiType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtInfoLBS clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtInfoLBS copyWith(void Function(ExtInfoLBS) updates) =>
      super.copyWith((message) => updates(message as ExtInfoLBS)) as ExtInfoLBS;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ExtInfoLBS() / ExtInfoLBS.new instead')
  static ExtInfoLBS create() => ExtInfoLBS._();
  static $pb.GeneratedMessage $_createMessage() => ExtInfoLBS._();
  @$core.override
  ExtInfoLBS createEmptyInstance() => ExtInfoLBS._();
  @$core.pragma('dart2js:noInline')
  static ExtInfoLBS getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExtInfoLBS>(ExtInfoLBS.$_createMessage);
  static ExtInfoLBS? _defaultInstance;

  /// 标题
  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  /// 跳转地址
  @$pb.TagNumber(2)
  $core.String get uri => $_getSZ(1);
  @$pb.TagNumber(2)
  set uri($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearUri() => $_clearField(2);

  /// 图标
  @$pb.TagNumber(3)
  $core.String get icon => $_getSZ(2);
  @$pb.TagNumber(3)
  set icon($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearIcon() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get poiType => $_getIZ(3);
  @$pb.TagNumber(4)
  set poiType($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPoiType() => $_has(3);
  @$pb.TagNumber(4)
  void clearPoiType() => $_clearField(4);
}

/// 拓展信息: 话题小卡
class ExtInfoTopic extends $pb.GeneratedMessage {
  factory ExtInfoTopic({
    $core.String? title,
    $core.String? uri,
    $core.String? icon,
  }) {
    final result = ExtInfoTopic._();
    if (title != null) result.title = title;
    if (uri != null) result.uri = uri;
    if (icon != null) result.icon = icon;
    return result;
  }

  ExtInfoTopic._();

  factory ExtInfoTopic.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtInfoTopic()..mergeFromBuffer(data, registry);
  factory ExtInfoTopic.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtInfoTopic()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExtInfoTopic',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: ExtInfoTopic.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'uri')
    ..aOS(3, _omitFieldNames ? '' : 'icon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtInfoTopic clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtInfoTopic copyWith(void Function(ExtInfoTopic) updates) =>
      super.copyWith((message) => updates(message as ExtInfoTopic))
          as ExtInfoTopic;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ExtInfoTopic() / ExtInfoTopic.new instead')
  static ExtInfoTopic create() => ExtInfoTopic._();
  static $pb.GeneratedMessage $_createMessage() => ExtInfoTopic._();
  @$core.override
  ExtInfoTopic createEmptyInstance() => ExtInfoTopic._();
  @$core.pragma('dart2js:noInline')
  static ExtInfoTopic getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExtInfoTopic>(
          ExtInfoTopic.$_createMessage);
  static ExtInfoTopic? _defaultInstance;

  /// 话题名
  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  /// 跳转地址
  @$pb.TagNumber(2)
  $core.String get uri => $_getSZ(1);
  @$pb.TagNumber(2)
  set uri($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearUri() => $_clearField(2);

  /// 图标
  @$pb.TagNumber(3)
  $core.String get icon => $_getSZ(2);
  @$pb.TagNumber(3)
  set icon($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearIcon() => $_clearField(3);
}

enum Extend_Extend { extInfoTopic, extInfoLbs, extInfoHot, extInfoGame, notSet }

/// 拓展
class Extend extends $pb.GeneratedMessage {
  factory Extend({
    $core.String? type,
    ExtInfoTopic? extInfoTopic,
    ExtInfoLBS? extInfoLbs,
    ExtInfoHot? extInfoHot,
    ExtInfoGame? extInfoGame,
  }) {
    final result = Extend._();
    if (type != null) result.type = type;
    if (extInfoTopic != null) result.extInfoTopic = extInfoTopic;
    if (extInfoLbs != null) result.extInfoLbs = extInfoLbs;
    if (extInfoHot != null) result.extInfoHot = extInfoHot;
    if (extInfoGame != null) result.extInfoGame = extInfoGame;
    return result;
  }

  Extend._();

  factory Extend.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Extend()..mergeFromBuffer(data, registry);
  factory Extend.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Extend()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Extend_Extend> _Extend_ExtendByTag = {
    2: Extend_Extend.extInfoTopic,
    3: Extend_Extend.extInfoLbs,
    4: Extend_Extend.extInfoHot,
    5: Extend_Extend.extInfoGame,
    0: Extend_Extend.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Extend',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: Extend.$_createMessage)
    ..oo(0, [2, 3, 4, 5])
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..aOM<ExtInfoTopic>(2, _omitFieldNames ? '' : 'extInfoTopic',
        subBuilder: ExtInfoTopic.$_createMessage)
    ..aOM<ExtInfoLBS>(3, _omitFieldNames ? '' : 'extInfoLbs',
        subBuilder: ExtInfoLBS.$_createMessage)
    ..aOM<ExtInfoHot>(4, _omitFieldNames ? '' : 'extInfoHot',
        subBuilder: ExtInfoHot.$_createMessage)
    ..aOM<ExtInfoGame>(5, _omitFieldNames ? '' : 'extInfoGame',
        subBuilder: ExtInfoGame.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Extend clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Extend copyWith(void Function(Extend) updates) =>
      super.copyWith((message) => updates(message as Extend)) as Extend;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Extend() / Extend.new instead')
  static Extend create() => Extend._();
  static $pb.GeneratedMessage $_createMessage() => Extend._();
  @$core.override
  Extend createEmptyInstance() => Extend._();
  @$core.pragma('dart2js:noInline')
  static Extend getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Extend>(Extend.$_createMessage);
  static Extend? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  Extend_Extend whichExtend() => _Extend_ExtendByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearExtend() => $_clearField($_whichOneof(0));

  /// 类型
  ///
  /// - 话题小卡: `topic`
  /// - lbs: `lbs`
  /// - 热门视频: `hot`
  /// - 游戏: `game`
  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  /// 参见 [`ExtInfoTopic`]
  @$pb.TagNumber(2)
  ExtInfoTopic get extInfoTopic => $_getN(1);
  @$pb.TagNumber(2)
  set extInfoTopic(ExtInfoTopic value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasExtInfoTopic() => $_has(1);
  @$pb.TagNumber(2)
  void clearExtInfoTopic() => $_clearField(2);
  @$pb.TagNumber(2)
  ExtInfoTopic ensureExtInfoTopic() => $_ensure(1);

  /// 参见 [`ExtInfoLBS`]
  @$pb.TagNumber(3)
  ExtInfoLBS get extInfoLbs => $_getN(2);
  @$pb.TagNumber(3)
  set extInfoLbs(ExtInfoLBS value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasExtInfoLbs() => $_has(2);
  @$pb.TagNumber(3)
  void clearExtInfoLbs() => $_clearField(3);
  @$pb.TagNumber(3)
  ExtInfoLBS ensureExtInfoLbs() => $_ensure(2);

  /// 参见 [`ExtInfoHot`]
  @$pb.TagNumber(4)
  ExtInfoHot get extInfoHot => $_getN(3);
  @$pb.TagNumber(4)
  set extInfoHot(ExtInfoHot value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasExtInfoHot() => $_has(3);
  @$pb.TagNumber(4)
  void clearExtInfoHot() => $_clearField(4);
  @$pb.TagNumber(4)
  ExtInfoHot ensureExtInfoHot() => $_ensure(3);

  /// 参见 [`ExtInfoGame`]
  @$pb.TagNumber(5)
  ExtInfoGame get extInfoGame => $_getN(4);
  @$pb.TagNumber(5)
  set extInfoGame(ExtInfoGame value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasExtInfoGame() => $_has(4);
  @$pb.TagNumber(5)
  void clearExtInfoGame() => $_clearField(5);
  @$pb.TagNumber(5)
  ExtInfoGame ensureExtInfoGame() => $_ensure(4);
}

/// 我的追番列表项目
class FollowListItem extends $pb.GeneratedMessage {
  factory FollowListItem({
    $core.int? seasonId,
    $core.String? title,
    $core.String? cover,
    $core.String? url,
    NewEP? newEp,
  }) {
    final result = FollowListItem._();
    if (seasonId != null) result.seasonId = seasonId;
    if (title != null) result.title = title;
    if (cover != null) result.cover = cover;
    if (url != null) result.url = url;
    if (newEp != null) result.newEp = newEp;
    return result;
  }

  FollowListItem._();

  factory FollowListItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowListItem()..mergeFromBuffer(data, registry);
  factory FollowListItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowListItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FollowListItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: FollowListItem.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'seasonId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'cover')
    ..aOS(4, _omitFieldNames ? '' : 'url')
    ..aOM<NewEP>(5, _omitFieldNames ? '' : 'newEp',
        subBuilder: NewEP.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowListItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowListItem copyWith(void Function(FollowListItem) updates) =>
      super.copyWith((message) => updates(message as FollowListItem))
          as FollowListItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FollowListItem() / FollowListItem.new instead')
  static FollowListItem create() => FollowListItem._();
  static $pb.GeneratedMessage $_createMessage() => FollowListItem._();
  @$core.override
  FollowListItem createEmptyInstance() => FollowListItem._();
  @$core.pragma('dart2js:noInline')
  static FollowListItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FollowListItem>(
          FollowListItem.$_createMessage);
  static FollowListItem? _defaultInstance;

  /// 剧集 ID
  @$pb.TagNumber(1)
  $core.int get seasonId => $_getIZ(0);
  @$pb.TagNumber(1)
  set seasonId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeasonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeasonId() => $_clearField(1);

  /// 标题
  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  /// 封面
  @$pb.TagNumber(3)
  $core.String get cover => $_getSZ(2);
  @$pb.TagNumber(3)
  set cover($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCover() => $_has(2);
  @$pb.TagNumber(3)
  void clearCover() => $_clearField(3);

  /// 跳转链接
  @$pb.TagNumber(4)
  $core.String get url => $_getSZ(3);
  @$pb.TagNumber(4)
  set url($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearUrl() => $_clearField(4);

  /// 剧集最新分集
  @$pb.TagNumber(5)
  NewEP get newEp => $_getN(4);
  @$pb.TagNumber(5)
  set newEp(NewEP value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasNewEp() => $_has(4);
  @$pb.TagNumber(5)
  void clearNewEp() => $_clearField(5);
  @$pb.TagNumber(5)
  NewEP ensureNewEp() => $_ensure(4);
}

class GeoCoderReply extends $pb.GeneratedMessage {
  factory GeoCoderReply({
    $core.String? address,
    AddressComponent? addressComponent,
    AdInfo? adInfo,
  }) {
    final result = GeoCoderReply._();
    if (address != null) result.address = address;
    if (addressComponent != null) result.addressComponent = addressComponent;
    if (adInfo != null) result.adInfo = adInfo;
    return result;
  }

  GeoCoderReply._();

  factory GeoCoderReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoCoderReply()..mergeFromBuffer(data, registry);
  factory GeoCoderReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoCoderReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GeoCoderReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: GeoCoderReply.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'address')
    ..aOM<AddressComponent>(2, _omitFieldNames ? '' : 'addressComponent',
        subBuilder: AddressComponent.$_createMessage)
    ..aOM<AdInfo>(3, _omitFieldNames ? '' : 'adInfo',
        subBuilder: AdInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoCoderReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoCoderReply copyWith(void Function(GeoCoderReply) updates) =>
      super.copyWith((message) => updates(message as GeoCoderReply))
          as GeoCoderReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GeoCoderReply() / GeoCoderReply.new instead')
  static GeoCoderReply create() => GeoCoderReply._();
  static $pb.GeneratedMessage $_createMessage() => GeoCoderReply._();
  @$core.override
  GeoCoderReply createEmptyInstance() => GeoCoderReply._();
  @$core.pragma('dart2js:noInline')
  static GeoCoderReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GeoCoderReply>(
          GeoCoderReply.$_createMessage);
  static GeoCoderReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => $_clearField(1);

  @$pb.TagNumber(2)
  AddressComponent get addressComponent => $_getN(1);
  @$pb.TagNumber(2)
  set addressComponent(AddressComponent value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAddressComponent() => $_has(1);
  @$pb.TagNumber(2)
  void clearAddressComponent() => $_clearField(2);
  @$pb.TagNumber(2)
  AddressComponent ensureAddressComponent() => $_ensure(1);

  @$pb.TagNumber(3)
  AdInfo get adInfo => $_getN(2);
  @$pb.TagNumber(3)
  set adInfo(AdInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAdInfo() => $_has(2);
  @$pb.TagNumber(3)
  void clearAdInfo() => $_clearField(3);
  @$pb.TagNumber(3)
  AdInfo ensureAdInfo() => $_ensure(2);
}

class GeoCoderReq extends $pb.GeneratedMessage {
  factory GeoCoderReq({
    $core.double? lat,
    $core.double? lng,
    $core.String? from,
  }) {
    final result = GeoCoderReq._();
    if (lat != null) result.lat = lat;
    if (lng != null) result.lng = lng;
    if (from != null) result.from = from;
    return result;
  }

  GeoCoderReq._();

  factory GeoCoderReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoCoderReq()..mergeFromBuffer(data, registry);
  factory GeoCoderReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GeoCoderReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GeoCoderReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: GeoCoderReq.$_createMessage)
    ..aD(1, _omitFieldNames ? '' : 'lat')
    ..aD(2, _omitFieldNames ? '' : 'lng')
    ..aOS(3, _omitFieldNames ? '' : 'from')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoCoderReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GeoCoderReq copyWith(void Function(GeoCoderReq) updates) =>
      super.copyWith((message) => updates(message as GeoCoderReq))
          as GeoCoderReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GeoCoderReq() / GeoCoderReq.new instead')
  static GeoCoderReq create() => GeoCoderReq._();
  static $pb.GeneratedMessage $_createMessage() => GeoCoderReq._();
  @$core.override
  GeoCoderReq createEmptyInstance() => GeoCoderReq._();
  @$core.pragma('dart2js:noInline')
  static GeoCoderReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GeoCoderReq>(
          GeoCoderReq.$_createMessage);
  static GeoCoderReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get lat => $_getN(0);
  @$pb.TagNumber(1)
  set lat($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLat() => $_has(0);
  @$pb.TagNumber(1)
  void clearLat() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get lng => $_getN(1);
  @$pb.TagNumber(2)
  set lng($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLng() => $_has(1);
  @$pb.TagNumber(2)
  void clearLng() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get from => $_getSZ(2);
  @$pb.TagNumber(3)
  set from($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFrom() => $_has(2);
  @$pb.TagNumber(3)
  void clearFrom() => $_clearField(3);
}

class Gps extends $pb.GeneratedMessage {
  factory Gps({
    $core.double? lat,
    $core.double? lng,
  }) {
    final result = Gps._();
    if (lat != null) result.lat = lat;
    if (lng != null) result.lng = lng;
    return result;
  }

  Gps._();

  factory Gps.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Gps()..mergeFromBuffer(data, registry);
  factory Gps.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Gps()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Gps',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: Gps.$_createMessage)
    ..aD(1, _omitFieldNames ? '' : 'lat')
    ..aD(2, _omitFieldNames ? '' : 'lng')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Gps clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Gps copyWith(void Function(Gps) updates) =>
      super.copyWith((message) => updates(message as Gps)) as Gps;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Gps() / Gps.new instead')
  static Gps create() => Gps._();
  static $pb.GeneratedMessage $_createMessage() => Gps._();
  @$core.override
  Gps createEmptyInstance() => Gps._();
  @$core.pragma('dart2js:noInline')
  static Gps getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Gps>(Gps.$_createMessage);
  static Gps? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get lat => $_getN(0);
  @$pb.TagNumber(1)
  set lat($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLat() => $_has(0);
  @$pb.TagNumber(1)
  void clearLat() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get lng => $_getN(1);
  @$pb.TagNumber(2)
  set lng($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLng() => $_has(1);
  @$pb.TagNumber(2)
  void clearLng() => $_clearField(2);
}

/// 点赞动画
class LikeAnimation extends $pb.GeneratedMessage {
  factory LikeAnimation({
    $core.String? begin,
    $core.String? proc,
    $core.String? end,
    $fixnum.Int64? likeIconId,
  }) {
    final result = LikeAnimation._();
    if (begin != null) result.begin = begin;
    if (proc != null) result.proc = proc;
    if (end != null) result.end = end;
    if (likeIconId != null) result.likeIconId = likeIconId;
    return result;
  }

  LikeAnimation._();

  factory LikeAnimation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LikeAnimation()..mergeFromBuffer(data, registry);
  factory LikeAnimation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LikeAnimation()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LikeAnimation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: LikeAnimation.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'begin')
    ..aOS(2, _omitFieldNames ? '' : 'proc')
    ..aOS(3, _omitFieldNames ? '' : 'end')
    ..aInt64(4, _omitFieldNames ? '' : 'likeIconId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeAnimation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeAnimation copyWith(void Function(LikeAnimation) updates) =>
      super.copyWith((message) => updates(message as LikeAnimation))
          as LikeAnimation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LikeAnimation() / LikeAnimation.new instead')
  static LikeAnimation create() => LikeAnimation._();
  static $pb.GeneratedMessage $_createMessage() => LikeAnimation._();
  @$core.override
  LikeAnimation createEmptyInstance() => LikeAnimation._();
  @$core.pragma('dart2js:noInline')
  static LikeAnimation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LikeAnimation>(
          LikeAnimation.$_createMessage);
  static LikeAnimation? _defaultInstance;

  /// 开始动画
  @$pb.TagNumber(1)
  $core.String get begin => $_getSZ(0);
  @$pb.TagNumber(1)
  set begin($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBegin() => $_has(0);
  @$pb.TagNumber(1)
  void clearBegin() => $_clearField(1);

  /// 过程动画
  @$pb.TagNumber(2)
  $core.String get proc => $_getSZ(1);
  @$pb.TagNumber(2)
  set proc($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProc() => $_has(1);
  @$pb.TagNumber(2)
  void clearProc() => $_clearField(2);

  /// 结束动画
  @$pb.TagNumber(3)
  $core.String get end => $_getSZ(2);
  @$pb.TagNumber(3)
  set end($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEnd() => $_has(2);
  @$pb.TagNumber(3)
  void clearEnd() => $_clearField(3);

  /// ID
  @$pb.TagNumber(4)
  $fixnum.Int64 get likeIconId => $_getI64(3);
  @$pb.TagNumber(4)
  set likeIconId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLikeIconId() => $_has(3);
  @$pb.TagNumber(4)
  void clearLikeIconId() => $_clearField(4);
}

/// 点赞拓展信息
class LikeInfo extends $pb.GeneratedMessage {
  factory LikeInfo({
    LikeAnimation? animation,
    $core.int? isLike,
  }) {
    final result = LikeInfo._();
    if (animation != null) result.animation = animation;
    if (isLike != null) result.isLike = isLike;
    return result;
  }

  LikeInfo._();

  factory LikeInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LikeInfo()..mergeFromBuffer(data, registry);
  factory LikeInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LikeInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LikeInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: LikeInfo.$_createMessage)
    ..aOM<LikeAnimation>(1, _omitFieldNames ? '' : 'animation',
        subBuilder: LikeAnimation.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'isLike')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeInfo copyWith(void Function(LikeInfo) updates) =>
      super.copyWith((message) => updates(message as LikeInfo)) as LikeInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LikeInfo() / LikeInfo.new instead')
  static LikeInfo create() => LikeInfo._();
  static $pb.GeneratedMessage $_createMessage() => LikeInfo._();
  @$core.override
  LikeInfo createEmptyInstance() => LikeInfo._();
  @$core.pragma('dart2js:noInline')
  static LikeInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LikeInfo>(LikeInfo.$_createMessage);
  static LikeInfo? _defaultInstance;

  /// 点赞动画
  @$pb.TagNumber(1)
  LikeAnimation get animation => $_getN(0);
  @$pb.TagNumber(1)
  set animation(LikeAnimation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAnimation() => $_has(0);
  @$pb.TagNumber(1)
  void clearAnimation() => $_clearField(1);
  @$pb.TagNumber(1)
  LikeAnimation ensureAnimation() => $_ensure(0);

  /// 是否点赞
  @$pb.TagNumber(2)
  $core.int get isLike => $_getIZ(1);
  @$pb.TagNumber(2)
  set isLike($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsLike() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsLike() => $_clearField(2);
}

/// 点赞用户
class LikeUser extends $pb.GeneratedMessage {
  factory LikeUser({
    $fixnum.Int64? uid,
    $core.String? uname,
    $core.String? uri,
  }) {
    final result = LikeUser._();
    if (uid != null) result.uid = uid;
    if (uname != null) result.uname = uname;
    if (uri != null) result.uri = uri;
    return result;
  }

  LikeUser._();

  factory LikeUser.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LikeUser()..mergeFromBuffer(data, registry);
  factory LikeUser.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LikeUser()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LikeUser',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: LikeUser.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'uid')
    ..aOS(2, _omitFieldNames ? '' : 'uname')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeUser clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeUser copyWith(void Function(LikeUser) updates) =>
      super.copyWith((message) => updates(message as LikeUser)) as LikeUser;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LikeUser() / LikeUser.new instead')
  static LikeUser create() => LikeUser._();
  static $pb.GeneratedMessage $_createMessage() => LikeUser._();
  @$core.override
  LikeUser createEmptyInstance() => LikeUser._();
  @$core.pragma('dart2js:noInline')
  static LikeUser getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LikeUser>(LikeUser.$_createMessage);
  static LikeUser? _defaultInstance;

  /// 点赞用户 mid
  @$pb.TagNumber(1)
  $fixnum.Int64 get uid => $_getI64(0);
  @$pb.TagNumber(1)
  set uid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUid() => $_clearField(1);

  /// 点赞用户昵称
  @$pb.TagNumber(2)
  $core.String get uname => $_getSZ(1);
  @$pb.TagNumber(2)
  set uname($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUname() => $_has(1);
  @$pb.TagNumber(2)
  void clearUname() => $_clearField(2);

  /// 点击跳转链接
  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);
}

/// 直播信息
class LiveInfo extends $pb.GeneratedMessage {
  factory LiveInfo({
    $core.int? isLiving,
    $core.String? uri,
  }) {
    final result = LiveInfo._();
    if (isLiving != null) result.isLiving = isLiving;
    if (uri != null) result.uri = uri;
    return result;
  }

  LiveInfo._();

  factory LiveInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveInfo()..mergeFromBuffer(data, registry);
  factory LiveInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: LiveInfo.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'isLiving')
    ..aOS(2, _omitFieldNames ? '' : 'uri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveInfo copyWith(void Function(LiveInfo) updates) =>
      super.copyWith((message) => updates(message as LiveInfo)) as LiveInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LiveInfo() / LiveInfo.new instead')
  static LiveInfo create() => LiveInfo._();
  static $pb.GeneratedMessage $_createMessage() => LiveInfo._();
  @$core.override
  LiveInfo createEmptyInstance() => LiveInfo._();
  @$core.pragma('dart2js:noInline')
  static LiveInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LiveInfo>(LiveInfo.$_createMessage);
  static LiveInfo? _defaultInstance;

  /// 正在直播
  @$pb.TagNumber(1)
  $core.int get isLiving => $_getIZ(0);
  @$pb.TagNumber(1)
  set isLiving($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsLiving() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsLiving() => $_clearField(1);

  /// 跳转地址
  @$pb.TagNumber(2)
  $core.String get uri => $_getSZ(1);
  @$pb.TagNumber(2)
  set uri($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearUri() => $_clearField(2);
}

class MixUpListItem extends $pb.GeneratedMessage {
  factory MixUpListItem({
    $fixnum.Int64? uid,
    $core.int? specialAttention,
    $core.int? reddotState,
    MixUpListLiveItem? liveInfo,
    $core.String? name,
    $core.String? face,
    OfficialVerify? official,
    VipInfo? vip,
    Relation? relation,
    $core.int? premiereState,
    $core.String? uri,
  }) {
    final result = MixUpListItem._();
    if (uid != null) result.uid = uid;
    if (specialAttention != null) result.specialAttention = specialAttention;
    if (reddotState != null) result.reddotState = reddotState;
    if (liveInfo != null) result.liveInfo = liveInfo;
    if (name != null) result.name = name;
    if (face != null) result.face = face;
    if (official != null) result.official = official;
    if (vip != null) result.vip = vip;
    if (relation != null) result.relation = relation;
    if (premiereState != null) result.premiereState = premiereState;
    if (uri != null) result.uri = uri;
    return result;
  }

  MixUpListItem._();

  factory MixUpListItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MixUpListItem()..mergeFromBuffer(data, registry);
  factory MixUpListItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MixUpListItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MixUpListItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: MixUpListItem.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'uid')
    ..aI(2, _omitFieldNames ? '' : 'specialAttention')
    ..aI(3, _omitFieldNames ? '' : 'reddotState')
    ..aOM<MixUpListLiveItem>(4, _omitFieldNames ? '' : 'liveInfo',
        subBuilder: MixUpListLiveItem.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'name')
    ..aOS(6, _omitFieldNames ? '' : 'face')
    ..aOM<OfficialVerify>(7, _omitFieldNames ? '' : 'official',
        subBuilder: OfficialVerify.$_createMessage)
    ..aOM<VipInfo>(8, _omitFieldNames ? '' : 'vip',
        subBuilder: VipInfo.$_createMessage)
    ..aOM<Relation>(9, _omitFieldNames ? '' : 'relation',
        subBuilder: Relation.$_createMessage)
    ..aI(10, _omitFieldNames ? '' : 'premiereState')
    ..aOS(11, _omitFieldNames ? '' : 'uri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MixUpListItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MixUpListItem copyWith(void Function(MixUpListItem) updates) =>
      super.copyWith((message) => updates(message as MixUpListItem))
          as MixUpListItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MixUpListItem() / MixUpListItem.new instead')
  static MixUpListItem create() => MixUpListItem._();
  static $pb.GeneratedMessage $_createMessage() => MixUpListItem._();
  @$core.override
  MixUpListItem createEmptyInstance() => MixUpListItem._();
  @$core.pragma('dart2js:noInline')
  static MixUpListItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MixUpListItem>(
          MixUpListItem.$_createMessage);
  static MixUpListItem? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get uid => $_getI64(0);
  @$pb.TagNumber(1)
  set uid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get specialAttention => $_getIZ(1);
  @$pb.TagNumber(2)
  set specialAttention($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSpecialAttention() => $_has(1);
  @$pb.TagNumber(2)
  void clearSpecialAttention() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get reddotState => $_getIZ(2);
  @$pb.TagNumber(3)
  set reddotState($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReddotState() => $_has(2);
  @$pb.TagNumber(3)
  void clearReddotState() => $_clearField(3);

  @$pb.TagNumber(4)
  MixUpListLiveItem get liveInfo => $_getN(3);
  @$pb.TagNumber(4)
  set liveInfo(MixUpListLiveItem value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLiveInfo() => $_has(3);
  @$pb.TagNumber(4)
  void clearLiveInfo() => $_clearField(4);
  @$pb.TagNumber(4)
  MixUpListLiveItem ensureLiveInfo() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(4);
  @$pb.TagNumber(5)
  set name($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(4);
  @$pb.TagNumber(5)
  void clearName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get face => $_getSZ(5);
  @$pb.TagNumber(6)
  set face($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFace() => $_has(5);
  @$pb.TagNumber(6)
  void clearFace() => $_clearField(6);

  @$pb.TagNumber(7)
  OfficialVerify get official => $_getN(6);
  @$pb.TagNumber(7)
  set official(OfficialVerify value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasOfficial() => $_has(6);
  @$pb.TagNumber(7)
  void clearOfficial() => $_clearField(7);
  @$pb.TagNumber(7)
  OfficialVerify ensureOfficial() => $_ensure(6);

  @$pb.TagNumber(8)
  VipInfo get vip => $_getN(7);
  @$pb.TagNumber(8)
  set vip(VipInfo value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasVip() => $_has(7);
  @$pb.TagNumber(8)
  void clearVip() => $_clearField(8);
  @$pb.TagNumber(8)
  VipInfo ensureVip() => $_ensure(7);

  @$pb.TagNumber(9)
  Relation get relation => $_getN(8);
  @$pb.TagNumber(9)
  set relation(Relation value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasRelation() => $_has(8);
  @$pb.TagNumber(9)
  void clearRelation() => $_clearField(9);
  @$pb.TagNumber(9)
  Relation ensureRelation() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.int get premiereState => $_getIZ(9);
  @$pb.TagNumber(10)
  set premiereState($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPremiereState() => $_has(9);
  @$pb.TagNumber(10)
  void clearPremiereState() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get uri => $_getSZ(10);
  @$pb.TagNumber(11)
  set uri($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasUri() => $_has(10);
  @$pb.TagNumber(11)
  void clearUri() => $_clearField(11);
}

class MixUpListLiveItem extends $pb.GeneratedMessage {
  factory MixUpListLiveItem({
    $core.bool? status,
    $fixnum.Int64? roomId,
    $core.String? uri,
  }) {
    final result = MixUpListLiveItem._();
    if (status != null) result.status = status;
    if (roomId != null) result.roomId = roomId;
    if (uri != null) result.uri = uri;
    return result;
  }

  MixUpListLiveItem._();

  factory MixUpListLiveItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MixUpListLiveItem()..mergeFromBuffer(data, registry);
  factory MixUpListLiveItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MixUpListLiveItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MixUpListLiveItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: MixUpListLiveItem.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'status')
    ..aInt64(2, _omitFieldNames ? '' : 'roomId')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MixUpListLiveItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MixUpListLiveItem copyWith(void Function(MixUpListLiveItem) updates) =>
      super.copyWith((message) => updates(message as MixUpListLiveItem))
          as MixUpListLiveItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MixUpListLiveItem() / MixUpListLiveItem.new instead')
  static MixUpListLiveItem create() => MixUpListLiveItem._();
  static $pb.GeneratedMessage $_createMessage() => MixUpListLiveItem._();
  @$core.override
  MixUpListLiveItem createEmptyInstance() => MixUpListLiveItem._();
  @$core.pragma('dart2js:noInline')
  static MixUpListLiveItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MixUpListLiveItem>(
          MixUpListLiveItem.$_createMessage);
  static MixUpListLiveItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get status => $_getBF(0);
  @$pb.TagNumber(1)
  set status($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get roomId => $_getI64(1);
  @$pb.TagNumber(2)
  set roomId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoomId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);
}

enum Module_ModuleItem {
  moduleFold,
  moduleAuthor,
  moduleDynamic,
  moduleState,
  moduleForward,
  moduleExtend,
  moduleDispute,
  moduleDesc,
  moduleLikeUser,
  moduleUpList,
  moduleFollowList,
  notSet
}

/// 卡片模块
class Module extends $pb.GeneratedMessage {
  factory Module({
    $core.String? moduleType,
    ModuleFold? moduleFold,
    ModuleAuthor? moduleAuthor,
    ModuleDynamic? moduleDynamic,
    ModuleState? moduleState,
    ModuleForward? moduleForward,
    ModuleExtend? moduleExtend,
    ModuleDispute? moduleDispute,
    ModuleDesc? moduleDesc,
    ModuleLikeUser? moduleLikeUser,
    ModuleDynUpList? moduleUpList,
    ModuleFollowList? moduleFollowList,
  }) {
    final result = Module._();
    if (moduleType != null) result.moduleType = moduleType;
    if (moduleFold != null) result.moduleFold = moduleFold;
    if (moduleAuthor != null) result.moduleAuthor = moduleAuthor;
    if (moduleDynamic != null) result.moduleDynamic = moduleDynamic;
    if (moduleState != null) result.moduleState = moduleState;
    if (moduleForward != null) result.moduleForward = moduleForward;
    if (moduleExtend != null) result.moduleExtend = moduleExtend;
    if (moduleDispute != null) result.moduleDispute = moduleDispute;
    if (moduleDesc != null) result.moduleDesc = moduleDesc;
    if (moduleLikeUser != null) result.moduleLikeUser = moduleLikeUser;
    if (moduleUpList != null) result.moduleUpList = moduleUpList;
    if (moduleFollowList != null) result.moduleFollowList = moduleFollowList;
    return result;
  }

  Module._();

  factory Module.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Module()..mergeFromBuffer(data, registry);
  factory Module.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Module()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Module_ModuleItem> _Module_ModuleItemByTag =
      {
    2: Module_ModuleItem.moduleFold,
    3: Module_ModuleItem.moduleAuthor,
    4: Module_ModuleItem.moduleDynamic,
    5: Module_ModuleItem.moduleState,
    6: Module_ModuleItem.moduleForward,
    7: Module_ModuleItem.moduleExtend,
    8: Module_ModuleItem.moduleDispute,
    9: Module_ModuleItem.moduleDesc,
    10: Module_ModuleItem.moduleLikeUser,
    11: Module_ModuleItem.moduleUpList,
    12: Module_ModuleItem.moduleFollowList,
    0: Module_ModuleItem.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Module',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: Module.$_createMessage)
    ..oo(0, [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
    ..aOS(1, _omitFieldNames ? '' : 'moduleType')
    ..aOM<ModuleFold>(2, _omitFieldNames ? '' : 'moduleFold',
        subBuilder: ModuleFold.$_createMessage)
    ..aOM<ModuleAuthor>(3, _omitFieldNames ? '' : 'moduleAuthor',
        subBuilder: ModuleAuthor.$_createMessage)
    ..aOM<ModuleDynamic>(4, _omitFieldNames ? '' : 'moduleDynamic',
        subBuilder: ModuleDynamic.$_createMessage)
    ..aOM<ModuleState>(5, _omitFieldNames ? '' : 'moduleState',
        subBuilder: ModuleState.$_createMessage)
    ..aOM<ModuleForward>(6, _omitFieldNames ? '' : 'moduleForward',
        subBuilder: ModuleForward.$_createMessage)
    ..aOM<ModuleExtend>(7, _omitFieldNames ? '' : 'moduleExtend',
        subBuilder: ModuleExtend.$_createMessage)
    ..aOM<ModuleDispute>(8, _omitFieldNames ? '' : 'moduleDispute',
        subBuilder: ModuleDispute.$_createMessage)
    ..aOM<ModuleDesc>(9, _omitFieldNames ? '' : 'moduleDesc',
        subBuilder: ModuleDesc.$_createMessage)
    ..aOM<ModuleLikeUser>(10, _omitFieldNames ? '' : 'moduleLikeUser',
        subBuilder: ModuleLikeUser.$_createMessage)
    ..aOM<ModuleDynUpList>(11, _omitFieldNames ? '' : 'moduleUpList',
        subBuilder: ModuleDynUpList.$_createMessage)
    ..aOM<ModuleFollowList>(12, _omitFieldNames ? '' : 'moduleFollowList',
        subBuilder: ModuleFollowList.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Module clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Module copyWith(void Function(Module) updates) =>
      super.copyWith((message) => updates(message as Module)) as Module;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Module() / Module.new instead')
  static Module create() => Module._();
  static $pb.GeneratedMessage $_createMessage() => Module._();
  @$core.override
  Module createEmptyInstance() => Module._();
  @$core.pragma('dart2js:noInline')
  static Module getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Module>(Module.$_createMessage);
  static Module? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  Module_ModuleItem whichModuleItem() =>
      _Module_ModuleItemByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  void clearModuleItem() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get moduleType => $_getSZ(0);
  @$pb.TagNumber(1)
  set moduleType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasModuleType() => $_has(0);
  @$pb.TagNumber(1)
  void clearModuleType() => $_clearField(1);

  /// 参见 [`ModuleFold`]
  @$pb.TagNumber(2)
  ModuleFold get moduleFold => $_getN(1);
  @$pb.TagNumber(2)
  set moduleFold(ModuleFold value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasModuleFold() => $_has(1);
  @$pb.TagNumber(2)
  void clearModuleFold() => $_clearField(2);
  @$pb.TagNumber(2)
  ModuleFold ensureModuleFold() => $_ensure(1);

  /// 参见 [`ModuleAuthor`]
  @$pb.TagNumber(3)
  ModuleAuthor get moduleAuthor => $_getN(2);
  @$pb.TagNumber(3)
  set moduleAuthor(ModuleAuthor value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasModuleAuthor() => $_has(2);
  @$pb.TagNumber(3)
  void clearModuleAuthor() => $_clearField(3);
  @$pb.TagNumber(3)
  ModuleAuthor ensureModuleAuthor() => $_ensure(2);

  /// 参见 [`ModuleDynamic`]
  @$pb.TagNumber(4)
  ModuleDynamic get moduleDynamic => $_getN(3);
  @$pb.TagNumber(4)
  set moduleDynamic(ModuleDynamic value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasModuleDynamic() => $_has(3);
  @$pb.TagNumber(4)
  void clearModuleDynamic() => $_clearField(4);
  @$pb.TagNumber(4)
  ModuleDynamic ensureModuleDynamic() => $_ensure(3);

  /// 参见 [`ModuleState`]
  @$pb.TagNumber(5)
  ModuleState get moduleState => $_getN(4);
  @$pb.TagNumber(5)
  set moduleState(ModuleState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasModuleState() => $_has(4);
  @$pb.TagNumber(5)
  void clearModuleState() => $_clearField(5);
  @$pb.TagNumber(5)
  ModuleState ensureModuleState() => $_ensure(4);

  /// 参见 [`ModuleForward`]
  @$pb.TagNumber(6)
  ModuleForward get moduleForward => $_getN(5);
  @$pb.TagNumber(6)
  set moduleForward(ModuleForward value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasModuleForward() => $_has(5);
  @$pb.TagNumber(6)
  void clearModuleForward() => $_clearField(6);
  @$pb.TagNumber(6)
  ModuleForward ensureModuleForward() => $_ensure(5);

  /// 参见 [`ModuleExtend`]
  @$pb.TagNumber(7)
  ModuleExtend get moduleExtend => $_getN(6);
  @$pb.TagNumber(7)
  set moduleExtend(ModuleExtend value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasModuleExtend() => $_has(6);
  @$pb.TagNumber(7)
  void clearModuleExtend() => $_clearField(7);
  @$pb.TagNumber(7)
  ModuleExtend ensureModuleExtend() => $_ensure(6);

  /// 参见 [`ModuleDispute`]
  @$pb.TagNumber(8)
  ModuleDispute get moduleDispute => $_getN(7);
  @$pb.TagNumber(8)
  set moduleDispute(ModuleDispute value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasModuleDispute() => $_has(7);
  @$pb.TagNumber(8)
  void clearModuleDispute() => $_clearField(8);
  @$pb.TagNumber(8)
  ModuleDispute ensureModuleDispute() => $_ensure(7);

  /// 参见 [`ModuleDesc`]
  @$pb.TagNumber(9)
  ModuleDesc get moduleDesc => $_getN(8);
  @$pb.TagNumber(9)
  set moduleDesc(ModuleDesc value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasModuleDesc() => $_has(8);
  @$pb.TagNumber(9)
  void clearModuleDesc() => $_clearField(9);
  @$pb.TagNumber(9)
  ModuleDesc ensureModuleDesc() => $_ensure(8);

  /// 参见 [`ModuleLikeUser`]
  @$pb.TagNumber(10)
  ModuleLikeUser get moduleLikeUser => $_getN(9);
  @$pb.TagNumber(10)
  set moduleLikeUser(ModuleLikeUser value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasModuleLikeUser() => $_has(9);
  @$pb.TagNumber(10)
  void clearModuleLikeUser() => $_clearField(10);
  @$pb.TagNumber(10)
  ModuleLikeUser ensureModuleLikeUser() => $_ensure(9);

  /// 参见 [`ModuleDynUpList`]
  @$pb.TagNumber(11)
  ModuleDynUpList get moduleUpList => $_getN(10);
  @$pb.TagNumber(11)
  set moduleUpList(ModuleDynUpList value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasModuleUpList() => $_has(10);
  @$pb.TagNumber(11)
  void clearModuleUpList() => $_clearField(11);
  @$pb.TagNumber(11)
  ModuleDynUpList ensureModuleUpList() => $_ensure(10);

  /// 参见 [`ModuleFollowList`]
  @$pb.TagNumber(12)
  ModuleFollowList get moduleFollowList => $_getN(11);
  @$pb.TagNumber(12)
  set moduleFollowList(ModuleFollowList value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasModuleFollowList() => $_has(11);
  @$pb.TagNumber(12)
  void clearModuleFollowList() => $_clearField(12);
  @$pb.TagNumber(12)
  ModuleFollowList ensureModuleFollowList() => $_ensure(11);
}

/// Module: 作者信息
class ModuleAuthor extends $pb.GeneratedMessage {
  factory ModuleAuthor({
    $fixnum.Int64? id,
    $core.String? ptimeLabelText,
    UserInfo? author,
    DecorateCard? decorateCard,
  }) {
    final result = ModuleAuthor._();
    if (id != null) result.id = id;
    if (ptimeLabelText != null) result.ptimeLabelText = ptimeLabelText;
    if (author != null) result.author = author;
    if (decorateCard != null) result.decorateCard = decorateCard;
    return result;
  }

  ModuleAuthor._();

  factory ModuleAuthor.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleAuthor()..mergeFromBuffer(data, registry);
  factory ModuleAuthor.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleAuthor()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModuleAuthor',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: ModuleAuthor.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'ptimeLabelText')
    ..aOM<UserInfo>(3, _omitFieldNames ? '' : 'author',
        subBuilder: UserInfo.$_createMessage)
    ..aOM<DecorateCard>(4, _omitFieldNames ? '' : 'decorateCard',
        subBuilder: DecorateCard.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleAuthor clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleAuthor copyWith(void Function(ModuleAuthor) updates) =>
      super.copyWith((message) => updates(message as ModuleAuthor))
          as ModuleAuthor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ModuleAuthor() / ModuleAuthor.new instead')
  static ModuleAuthor create() => ModuleAuthor._();
  static $pb.GeneratedMessage $_createMessage() => ModuleAuthor._();
  @$core.override
  ModuleAuthor createEmptyInstance() => ModuleAuthor._();
  @$core.pragma('dart2js:noInline')
  static ModuleAuthor getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ModuleAuthor>(
          ModuleAuthor.$_createMessage);
  static ModuleAuthor? _defaultInstance;

  /// 作者 mid
  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// 时间标签
  @$pb.TagNumber(2)
  $core.String get ptimeLabelText => $_getSZ(1);
  @$pb.TagNumber(2)
  set ptimeLabelText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPtimeLabelText() => $_has(1);
  @$pb.TagNumber(2)
  void clearPtimeLabelText() => $_clearField(2);

  /// 用户详情
  @$pb.TagNumber(3)
  UserInfo get author => $_getN(2);
  @$pb.TagNumber(3)
  set author(UserInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAuthor() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthor() => $_clearField(3);
  @$pb.TagNumber(3)
  UserInfo ensureAuthor() => $_ensure(2);

  /// 装扮卡片
  @$pb.TagNumber(4)
  DecorateCard get decorateCard => $_getN(3);
  @$pb.TagNumber(4)
  set decorateCard(DecorateCard value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDecorateCard() => $_has(3);
  @$pb.TagNumber(4)
  void clearDecorateCard() => $_clearField(4);
  @$pb.TagNumber(4)
  DecorateCard ensureDecorateCard() => $_ensure(3);
}

/// Module: 文本内容
class ModuleDesc extends $pb.GeneratedMessage {
  factory ModuleDesc({
    $core.Iterable<Description>? desc,
  }) {
    final result = ModuleDesc._();
    if (desc != null) result.desc.addAll(desc);
    return result;
  }

  ModuleDesc._();

  factory ModuleDesc.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleDesc()..mergeFromBuffer(data, registry);
  factory ModuleDesc.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleDesc()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModuleDesc',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: ModuleDesc.$_createMessage)
    ..pPM<Description>(1, _omitFieldNames ? '' : 'desc',
        subBuilder: Description.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleDesc clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleDesc copyWith(void Function(ModuleDesc) updates) =>
      super.copyWith((message) => updates(message as ModuleDesc)) as ModuleDesc;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ModuleDesc() / ModuleDesc.new instead')
  static ModuleDesc create() => ModuleDesc._();
  static $pb.GeneratedMessage $_createMessage() => ModuleDesc._();
  @$core.override
  ModuleDesc createEmptyInstance() => ModuleDesc._();
  @$core.pragma('dart2js:noInline')
  static ModuleDesc getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModuleDesc>(ModuleDesc.$_createMessage);
  static ModuleDesc? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Description> get desc => $_getList(0);
}

/// Module: 争议小黄条
class ModuleDispute extends $pb.GeneratedMessage {
  factory ModuleDispute({
    $core.String? title,
    $core.String? desc,
    $core.String? uri,
  }) {
    final result = ModuleDispute._();
    if (title != null) result.title = title;
    if (desc != null) result.desc = desc;
    if (uri != null) result.uri = uri;
    return result;
  }

  ModuleDispute._();

  factory ModuleDispute.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleDispute()..mergeFromBuffer(data, registry);
  factory ModuleDispute.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleDispute()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModuleDispute',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: ModuleDispute.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'desc')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleDispute clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleDispute copyWith(void Function(ModuleDispute) updates) =>
      super.copyWith((message) => updates(message as ModuleDispute))
          as ModuleDispute;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ModuleDispute() / ModuleDispute.new instead')
  static ModuleDispute create() => ModuleDispute._();
  static $pb.GeneratedMessage $_createMessage() => ModuleDispute._();
  @$core.override
  ModuleDispute createEmptyInstance() => ModuleDispute._();
  @$core.pragma('dart2js:noInline')
  static ModuleDispute getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ModuleDispute>(
          ModuleDispute.$_createMessage);
  static ModuleDispute? _defaultInstance;

  /// 标题
  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  /// 描述
  @$pb.TagNumber(2)
  $core.String get desc => $_getSZ(1);
  @$pb.TagNumber(2)
  set desc($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDesc() => $_has(1);
  @$pb.TagNumber(2)
  void clearDesc() => $_clearField(2);

  /// 跳转地址
  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);
}

/// 最近访问 UP 主列表
class ModuleDynUpList extends $pb.GeneratedMessage {
  factory ModuleDynUpList({
    $core.String? moduleTitle,
    $core.String? showAll,
    $core.Iterable<UpListItem>? list,
  }) {
    final result = ModuleDynUpList._();
    if (moduleTitle != null) result.moduleTitle = moduleTitle;
    if (showAll != null) result.showAll = showAll;
    if (list != null) result.list.addAll(list);
    return result;
  }

  ModuleDynUpList._();

  factory ModuleDynUpList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleDynUpList()..mergeFromBuffer(data, registry);
  factory ModuleDynUpList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleDynUpList()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModuleDynUpList',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: ModuleDynUpList.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'moduleTitle')
    ..aOS(2, _omitFieldNames ? '' : 'showAll')
    ..pPM<UpListItem>(3, _omitFieldNames ? '' : 'list',
        subBuilder: UpListItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleDynUpList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleDynUpList copyWith(void Function(ModuleDynUpList) updates) =>
      super.copyWith((message) => updates(message as ModuleDynUpList))
          as ModuleDynUpList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ModuleDynUpList() / ModuleDynUpList.new instead')
  static ModuleDynUpList create() => ModuleDynUpList._();
  static $pb.GeneratedMessage $_createMessage() => ModuleDynUpList._();
  @$core.override
  ModuleDynUpList createEmptyInstance() => ModuleDynUpList._();
  @$core.pragma('dart2js:noInline')
  static ModuleDynUpList getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ModuleDynUpList>(
          ModuleDynUpList.$_createMessage);
  static ModuleDynUpList? _defaultInstance;

  /// 标题展示文案
  @$pb.TagNumber(1)
  $core.String get moduleTitle => $_getSZ(0);
  @$pb.TagNumber(1)
  set moduleTitle($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasModuleTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearModuleTitle() => $_clearField(1);

  /// "全部" 按钮文案
  @$pb.TagNumber(2)
  $core.String get showAll => $_getSZ(1);
  @$pb.TagNumber(2)
  set showAll($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShowAll() => $_has(1);
  @$pb.TagNumber(2)
  void clearShowAll() => $_clearField(2);

  /// UP 主列表
  @$pb.TagNumber(3)
  $pb.PbList<UpListItem> get list => $_getList(2);
}

enum ModuleDynamic_Card {
  cardUgc,
  cardPgc,
  cardCurrSeason,
  cardCurrBatch,
  notSet
}

/// Module: 动态详情
class ModuleDynamic extends $pb.GeneratedMessage {
  factory ModuleDynamic({
    $core.String? cardType,
    CardUGC? cardUgc,
    CardPGC? cardPgc,
    CardCurrSeason? cardCurrSeason,
    CardCurrBatch? cardCurrBatch,
  }) {
    final result = ModuleDynamic._();
    if (cardType != null) result.cardType = cardType;
    if (cardUgc != null) result.cardUgc = cardUgc;
    if (cardPgc != null) result.cardPgc = cardPgc;
    if (cardCurrSeason != null) result.cardCurrSeason = cardCurrSeason;
    if (cardCurrBatch != null) result.cardCurrBatch = cardCurrBatch;
    return result;
  }

  ModuleDynamic._();

  factory ModuleDynamic.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleDynamic()..mergeFromBuffer(data, registry);
  factory ModuleDynamic.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleDynamic()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ModuleDynamic_Card>
      _ModuleDynamic_CardByTag = {
    2: ModuleDynamic_Card.cardUgc,
    3: ModuleDynamic_Card.cardPgc,
    4: ModuleDynamic_Card.cardCurrSeason,
    5: ModuleDynamic_Card.cardCurrBatch,
    0: ModuleDynamic_Card.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModuleDynamic',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: ModuleDynamic.$_createMessage)
    ..oo(0, [2, 3, 4, 5])
    ..aOS(1, _omitFieldNames ? '' : 'cardType')
    ..aOM<CardUGC>(2, _omitFieldNames ? '' : 'cardUgc',
        subBuilder: CardUGC.$_createMessage)
    ..aOM<CardPGC>(3, _omitFieldNames ? '' : 'cardPgc',
        subBuilder: CardPGC.$_createMessage)
    ..aOM<CardCurrSeason>(4, _omitFieldNames ? '' : 'cardCurrSeason',
        subBuilder: CardCurrSeason.$_createMessage)
    ..aOM<CardCurrBatch>(5, _omitFieldNames ? '' : 'cardCurrBatch',
        subBuilder: CardCurrBatch.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleDynamic clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleDynamic copyWith(void Function(ModuleDynamic) updates) =>
      super.copyWith((message) => updates(message as ModuleDynamic))
          as ModuleDynamic;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ModuleDynamic() / ModuleDynamic.new instead')
  static ModuleDynamic create() => ModuleDynamic._();
  static $pb.GeneratedMessage $_createMessage() => ModuleDynamic._();
  @$core.override
  ModuleDynamic createEmptyInstance() => ModuleDynamic._();
  @$core.pragma('dart2js:noInline')
  static ModuleDynamic getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ModuleDynamic>(
          ModuleDynamic.$_createMessage);
  static ModuleDynamic? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  ModuleDynamic_Card whichCard() => _ModuleDynamic_CardByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearCard() => $_clearField($_whichOneof(0));

  /// 动态卡片类型
  ///
  /// - UGC 视频卡片: `ugc`
  /// - PGC 视频卡片: `pgc`
  /// - 付费课程系列: `currSeason`
  /// - 付费课程批次: `currBatch`
  @$pb.TagNumber(1)
  $core.String get cardType => $_getSZ(0);
  @$pb.TagNumber(1)
  set cardType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCardType() => $_has(0);
  @$pb.TagNumber(1)
  void clearCardType() => $_clearField(1);

  /// UGC 视频卡片
  @$pb.TagNumber(2)
  CardUGC get cardUgc => $_getN(1);
  @$pb.TagNumber(2)
  set cardUgc(CardUGC value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCardUgc() => $_has(1);
  @$pb.TagNumber(2)
  void clearCardUgc() => $_clearField(2);
  @$pb.TagNumber(2)
  CardUGC ensureCardUgc() => $_ensure(1);

  /// PGC 视频卡片
  @$pb.TagNumber(3)
  CardPGC get cardPgc => $_getN(2);
  @$pb.TagNumber(3)
  set cardPgc(CardPGC value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCardPgc() => $_has(2);
  @$pb.TagNumber(3)
  void clearCardPgc() => $_clearField(3);
  @$pb.TagNumber(3)
  CardPGC ensureCardPgc() => $_ensure(2);

  /// 付费课程系列
  @$pb.TagNumber(4)
  CardCurrSeason get cardCurrSeason => $_getN(3);
  @$pb.TagNumber(4)
  set cardCurrSeason(CardCurrSeason value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCardCurrSeason() => $_has(3);
  @$pb.TagNumber(4)
  void clearCardCurrSeason() => $_clearField(4);
  @$pb.TagNumber(4)
  CardCurrSeason ensureCardCurrSeason() => $_ensure(3);

  /// 付费课程批次
  @$pb.TagNumber(5)
  CardCurrBatch get cardCurrBatch => $_getN(4);
  @$pb.TagNumber(5)
  set cardCurrBatch(CardCurrBatch value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCardCurrBatch() => $_has(4);
  @$pb.TagNumber(5)
  void clearCardCurrBatch() => $_clearField(5);
  @$pb.TagNumber(5)
  CardCurrBatch ensureCardCurrBatch() => $_ensure(4);
}

/// Module: 拓展
class ModuleExtend extends $pb.GeneratedMessage {
  factory ModuleExtend({
    $core.Iterable<Extend>? extend,
  }) {
    final result = ModuleExtend._();
    if (extend != null) result.extend.addAll(extend);
    return result;
  }

  ModuleExtend._();

  factory ModuleExtend.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleExtend()..mergeFromBuffer(data, registry);
  factory ModuleExtend.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleExtend()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModuleExtend',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: ModuleExtend.$_createMessage)
    ..pPM<Extend>(1, _omitFieldNames ? '' : 'extend',
        subBuilder: Extend.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleExtend clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleExtend copyWith(void Function(ModuleExtend) updates) =>
      super.copyWith((message) => updates(message as ModuleExtend))
          as ModuleExtend;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ModuleExtend() / ModuleExtend.new instead')
  static ModuleExtend create() => ModuleExtend._();
  static $pb.GeneratedMessage $_createMessage() => ModuleExtend._();
  @$core.override
  ModuleExtend createEmptyInstance() => ModuleExtend._();
  @$core.pragma('dart2js:noInline')
  static ModuleExtend getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ModuleExtend>(
          ModuleExtend.$_createMessage);
  static ModuleExtend? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Extend> get extend => $_getList(0);
}

/// Module: 折叠
class ModuleFold extends $pb.GeneratedMessage {
  factory ModuleFold({
    FoldType? foldType,
    $core.String? text,
    $core.String? foldIds,
    $core.Iterable<UserInfo>? foldUsers,
    FoldType? foldTypeV2,
  }) {
    final result = ModuleFold._();
    if (foldType != null) result.foldType = foldType;
    if (text != null) result.text = text;
    if (foldIds != null) result.foldIds = foldIds;
    if (foldUsers != null) result.foldUsers.addAll(foldUsers);
    if (foldTypeV2 != null) result.foldTypeV2 = foldTypeV2;
    return result;
  }

  ModuleFold._();

  factory ModuleFold.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleFold()..mergeFromBuffer(data, registry);
  factory ModuleFold.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleFold()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModuleFold',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: ModuleFold.$_createMessage)
    ..aE<FoldType>(1, _omitFieldNames ? '' : 'foldType',
        enumValues: FoldType.values)
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'foldIds')
    ..pPM<UserInfo>(4, _omitFieldNames ? '' : 'foldUsers',
        subBuilder: UserInfo.$_createMessage)
    ..aE<FoldType>(5, _omitFieldNames ? '' : 'foldTypeV2',
        enumValues: FoldType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleFold clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleFold copyWith(void Function(ModuleFold) updates) =>
      super.copyWith((message) => updates(message as ModuleFold)) as ModuleFold;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ModuleFold() / ModuleFold.new instead')
  static ModuleFold create() => ModuleFold._();
  static $pb.GeneratedMessage $_createMessage() => ModuleFold._();
  @$core.override
  ModuleFold createEmptyInstance() => ModuleFold._();
  @$core.pragma('dart2js:noInline')
  static ModuleFold getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModuleFold>(ModuleFold.$_createMessage);
  static ModuleFold? _defaultInstance;

  /// Deprecated, see [`Self::fold_type_v2`] instead.
  @$pb.TagNumber(1)
  FoldType get foldType => $_getN(0);
  @$pb.TagNumber(1)
  set foldType(FoldType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFoldType() => $_has(0);
  @$pb.TagNumber(1)
  void clearFoldType() => $_clearField(1);

  /// 折叠文案
  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  /// 被折叠的动态
  @$pb.TagNumber(3)
  $core.String get foldIds => $_getSZ(2);
  @$pb.TagNumber(3)
  set foldIds($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFoldIds() => $_has(2);
  @$pb.TagNumber(3)
  void clearFoldIds() => $_clearField(3);

  /// 被折叠的用户
  @$pb.TagNumber(4)
  $pb.PbList<UserInfo> get foldUsers => $_getList(3);

  /// 折叠分类
  @$pb.TagNumber(5)
  FoldType get foldTypeV2 => $_getN(4);
  @$pb.TagNumber(5)
  set foldTypeV2(FoldType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasFoldTypeV2() => $_has(4);
  @$pb.TagNumber(5)
  void clearFoldTypeV2() => $_clearField(5);
}

/// 我的追番列表
class ModuleFollowList extends $pb.GeneratedMessage {
  factory ModuleFollowList({
    $core.String? viewAllLink,
    $core.Iterable<FollowListItem>? list,
  }) {
    final result = ModuleFollowList._();
    if (viewAllLink != null) result.viewAllLink = viewAllLink;
    if (list != null) result.list.addAll(list);
    return result;
  }

  ModuleFollowList._();

  factory ModuleFollowList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleFollowList()..mergeFromBuffer(data, registry);
  factory ModuleFollowList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleFollowList()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModuleFollowList',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: ModuleFollowList.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'viewAllLink')
    ..pPM<FollowListItem>(2, _omitFieldNames ? '' : 'list',
        subBuilder: FollowListItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleFollowList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleFollowList copyWith(void Function(ModuleFollowList) updates) =>
      super.copyWith((message) => updates(message as ModuleFollowList))
          as ModuleFollowList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ModuleFollowList() / ModuleFollowList.new instead')
  static ModuleFollowList create() => ModuleFollowList._();
  static $pb.GeneratedMessage $_createMessage() => ModuleFollowList._();
  @$core.override
  ModuleFollowList createEmptyInstance() => ModuleFollowList._();
  @$core.pragma('dart2js:noInline')
  static ModuleFollowList getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ModuleFollowList>(
          ModuleFollowList.$_createMessage);
  static ModuleFollowList? _defaultInstance;

  /// 查看全部的跳转链接
  @$pb.TagNumber(1)
  $core.String get viewAllLink => $_getSZ(0);
  @$pb.TagNumber(1)
  set viewAllLink($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasViewAllLink() => $_has(0);
  @$pb.TagNumber(1)
  void clearViewAllLink() => $_clearField(1);

  /// 参见 [`FollowListItem`]
  @$pb.TagNumber(2)
  $pb.PbList<FollowListItem> get list => $_getList(1);
}

/// Module: 转发
class ModuleForward extends $pb.GeneratedMessage {
  factory ModuleForward({
    $core.String? cardType,
    $core.Iterable<Module>? modules,
  }) {
    final result = ModuleForward._();
    if (cardType != null) result.cardType = cardType;
    if (modules != null) result.modules.addAll(modules);
    return result;
  }

  ModuleForward._();

  factory ModuleForward.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleForward()..mergeFromBuffer(data, registry);
  factory ModuleForward.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleForward()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModuleForward',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: ModuleForward.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'cardType')
    ..pPM<Module>(2, _omitFieldNames ? '' : 'modules',
        subBuilder: Module.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleForward clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleForward copyWith(void Function(ModuleForward) updates) =>
      super.copyWith((message) => updates(message as ModuleForward))
          as ModuleForward;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ModuleForward() / ModuleForward.new instead')
  static ModuleForward create() => ModuleForward._();
  static $pb.GeneratedMessage $_createMessage() => ModuleForward._();
  @$core.override
  ModuleForward createEmptyInstance() => ModuleForward._();
  @$core.pragma('dart2js:noInline')
  static ModuleForward getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ModuleForward>(
          ModuleForward.$_createMessage);
  static ModuleForward? _defaultInstance;

  /// 卡片类型
  @$pb.TagNumber(1)
  $core.String get cardType => $_getSZ(0);
  @$pb.TagNumber(1)
  set cardType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCardType() => $_has(0);
  @$pb.TagNumber(1)
  void clearCardType() => $_clearField(1);

  /// 嵌套的 modules
  @$pb.TagNumber(2)
  $pb.PbList<Module> get modules => $_getList(1);
}

/// Module: 点赞用户
class ModuleLikeUser extends $pb.GeneratedMessage {
  factory ModuleLikeUser({
    $core.Iterable<LikeUser>? likeUsers,
    $core.String? displayText,
  }) {
    final result = ModuleLikeUser._();
    if (likeUsers != null) result.likeUsers.addAll(likeUsers);
    if (displayText != null) result.displayText = displayText;
    return result;
  }

  ModuleLikeUser._();

  factory ModuleLikeUser.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleLikeUser()..mergeFromBuffer(data, registry);
  factory ModuleLikeUser.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleLikeUser()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModuleLikeUser',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: ModuleLikeUser.$_createMessage)
    ..pPM<LikeUser>(1, _omitFieldNames ? '' : 'likeUsers',
        subBuilder: LikeUser.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'displayText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleLikeUser clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleLikeUser copyWith(void Function(ModuleLikeUser) updates) =>
      super.copyWith((message) => updates(message as ModuleLikeUser))
          as ModuleLikeUser;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ModuleLikeUser() / ModuleLikeUser.new instead')
  static ModuleLikeUser create() => ModuleLikeUser._();
  static $pb.GeneratedMessage $_createMessage() => ModuleLikeUser._();
  @$core.override
  ModuleLikeUser createEmptyInstance() => ModuleLikeUser._();
  @$core.pragma('dart2js:noInline')
  static ModuleLikeUser getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ModuleLikeUser>(
          ModuleLikeUser.$_createMessage);
  static ModuleLikeUser? _defaultInstance;

  /// 点赞用户
  @$pb.TagNumber(1)
  $pb.PbList<LikeUser> get likeUsers => $_getList(0);

  /// 文案
  @$pb.TagNumber(2)
  $core.String get displayText => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayText() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayText() => $_clearField(2);
}

/// Module: 计数状态
class ModuleState extends $pb.GeneratedMessage {
  factory ModuleState({
    $core.int? repost,
    $core.int? like,
    $core.int? reply,
    LikeInfo? likeInfo,
    $core.bool? noComment,
    $core.bool? noForward,
  }) {
    final result = ModuleState._();
    if (repost != null) result.repost = repost;
    if (like != null) result.like = like;
    if (reply != null) result.reply = reply;
    if (likeInfo != null) result.likeInfo = likeInfo;
    if (noComment != null) result.noComment = noComment;
    if (noForward != null) result.noForward = noForward;
    return result;
  }

  ModuleState._();

  factory ModuleState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleState()..mergeFromBuffer(data, registry);
  factory ModuleState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ModuleState()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModuleState',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: ModuleState.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'repost')
    ..aI(2, _omitFieldNames ? '' : 'like')
    ..aI(3, _omitFieldNames ? '' : 'reply')
    ..aOM<LikeInfo>(4, _omitFieldNames ? '' : 'likeInfo',
        subBuilder: LikeInfo.$_createMessage)
    ..aOB(5, _omitFieldNames ? '' : 'noComment')
    ..aOB(6, _omitFieldNames ? '' : 'noForward')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModuleState copyWith(void Function(ModuleState) updates) =>
      super.copyWith((message) => updates(message as ModuleState))
          as ModuleState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ModuleState() / ModuleState.new instead')
  static ModuleState create() => ModuleState._();
  static $pb.GeneratedMessage $_createMessage() => ModuleState._();
  @$core.override
  ModuleState createEmptyInstance() => ModuleState._();
  @$core.pragma('dart2js:noInline')
  static ModuleState getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ModuleState>(
          ModuleState.$_createMessage);
  static ModuleState? _defaultInstance;

  /// 转发数
  @$pb.TagNumber(1)
  $core.int get repost => $_getIZ(0);
  @$pb.TagNumber(1)
  set repost($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRepost() => $_has(0);
  @$pb.TagNumber(1)
  void clearRepost() => $_clearField(1);

  /// 点赞数
  @$pb.TagNumber(2)
  $core.int get like => $_getIZ(1);
  @$pb.TagNumber(2)
  set like($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLike() => $_has(1);
  @$pb.TagNumber(2)
  void clearLike() => $_clearField(2);

  /// 评论数
  @$pb.TagNumber(3)
  $core.int get reply => $_getIZ(2);
  @$pb.TagNumber(3)
  set reply($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReply() => $_has(2);
  @$pb.TagNumber(3)
  void clearReply() => $_clearField(3);

  /// 点赞拓展信息
  @$pb.TagNumber(4)
  LikeInfo get likeInfo => $_getN(3);
  @$pb.TagNumber(4)
  set likeInfo(LikeInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLikeInfo() => $_has(3);
  @$pb.TagNumber(4)
  void clearLikeInfo() => $_clearField(4);
  @$pb.TagNumber(4)
  LikeInfo ensureLikeInfo() => $_ensure(3);

  /// 禁止评论
  @$pb.TagNumber(5)
  $core.bool get noComment => $_getBF(4);
  @$pb.TagNumber(5)
  set noComment($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNoComment() => $_has(4);
  @$pb.TagNumber(5)
  void clearNoComment() => $_clearField(5);

  /// 禁止转发
  @$pb.TagNumber(6)
  $core.bool get noForward => $_getBF(5);
  @$pb.TagNumber(6)
  set noForward($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNoForward() => $_has(5);
  @$pb.TagNumber(6)
  void clearNoForward() => $_clearField(6);
}

/// 认证名牌
class Nameplate extends $pb.GeneratedMessage {
  factory Nameplate({
    $fixnum.Int64? nid,
    $core.String? name,
    $core.String? image,
    $core.String? imageSmall,
    $core.String? level,
    $core.String? condition,
  }) {
    final result = Nameplate._();
    if (nid != null) result.nid = nid;
    if (name != null) result.name = name;
    if (image != null) result.image = image;
    if (imageSmall != null) result.imageSmall = imageSmall;
    if (level != null) result.level = level;
    if (condition != null) result.condition = condition;
    return result;
  }

  Nameplate._();

  factory Nameplate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Nameplate()..mergeFromBuffer(data, registry);
  factory Nameplate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Nameplate()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Nameplate',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: Nameplate.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'nid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'image')
    ..aOS(4, _omitFieldNames ? '' : 'imageSmall')
    ..aOS(5, _omitFieldNames ? '' : 'level')
    ..aOS(6, _omitFieldNames ? '' : 'condition')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Nameplate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Nameplate copyWith(void Function(Nameplate) updates) =>
      super.copyWith((message) => updates(message as Nameplate)) as Nameplate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Nameplate() / Nameplate.new instead')
  static Nameplate create() => Nameplate._();
  static $pb.GeneratedMessage $_createMessage() => Nameplate._();
  @$core.override
  Nameplate createEmptyInstance() => Nameplate._();
  @$core.pragma('dart2js:noInline')
  static Nameplate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Nameplate>(Nameplate.$_createMessage);
  static Nameplate? _defaultInstance;

  /// 认证名牌 ID
  @$pb.TagNumber(1)
  $fixnum.Int64 get nid => $_getI64(0);
  @$pb.TagNumber(1)
  set nid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNid() => $_has(0);
  @$pb.TagNumber(1)
  void clearNid() => $_clearField(1);

  /// 认证名牌名称
  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// 认证名牌图片
  @$pb.TagNumber(3)
  $core.String get image => $_getSZ(2);
  @$pb.TagNumber(3)
  set image($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasImage() => $_has(2);
  @$pb.TagNumber(3)
  void clearImage() => $_clearField(3);

  /// 认证名牌图片(小)
  @$pb.TagNumber(4)
  $core.String get imageSmall => $_getSZ(3);
  @$pb.TagNumber(4)
  set imageSmall($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasImageSmall() => $_has(3);
  @$pb.TagNumber(4)
  void clearImageSmall() => $_clearField(4);

  /// 等级
  @$pb.TagNumber(5)
  $core.String get level => $_getSZ(4);
  @$pb.TagNumber(5)
  set level($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLevel() => $_has(4);
  @$pb.TagNumber(5)
  void clearLevel() => $_clearField(5);

  /// 获取条件
  @$pb.TagNumber(6)
  $core.String get condition => $_getSZ(5);
  @$pb.TagNumber(6)
  set condition($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCondition() => $_has(5);
  @$pb.TagNumber(6)
  void clearCondition() => $_clearField(6);
}

/// 剧集最新分集
class NewEP extends $pb.GeneratedMessage {
  factory NewEP({
    $core.int? id,
    $core.String? indexShow,
    $core.String? cover,
  }) {
    final result = NewEP._();
    if (id != null) result.id = id;
    if (indexShow != null) result.indexShow = indexShow;
    if (cover != null) result.cover = cover;
    return result;
  }

  NewEP._();

  factory NewEP.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NewEP()..mergeFromBuffer(data, registry);
  factory NewEP.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NewEP()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NewEP',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: NewEP.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'indexShow')
    ..aOS(3, _omitFieldNames ? '' : 'cover')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NewEP clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NewEP copyWith(void Function(NewEP) updates) =>
      super.copyWith((message) => updates(message as NewEP)) as NewEP;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use NewEP() / NewEP.new instead')
  static NewEP create() => NewEP._();
  static $pb.GeneratedMessage $_createMessage() => NewEP._();
  @$core.override
  NewEP createEmptyInstance() => NewEP._();
  @$core.pragma('dart2js:noInline')
  static NewEP getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NewEP>(NewEP.$_createMessage);
  static NewEP? _defaultInstance;

  /// 剧集最新分集的 ID
  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// 更新至 XX 话
  @$pb.TagNumber(2)
  $core.String get indexShow => $_getSZ(1);
  @$pb.TagNumber(2)
  set indexShow($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIndexShow() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndexShow() => $_clearField(2);

  /// 更新剧集的封面
  @$pb.TagNumber(3)
  $core.String get cover => $_getSZ(2);
  @$pb.TagNumber(3)
  set cover($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCover() => $_has(2);
  @$pb.TagNumber(3)
  void clearCover() => $_clearField(3);
}

class NoReply extends $pb.GeneratedMessage {
  factory NoReply() => NoReply._();

  NoReply._();

  factory NoReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NoReply()..mergeFromBuffer(data, registry);
  factory NoReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NoReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NoReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: NoReply.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NoReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NoReply copyWith(void Function(NoReply) updates) =>
      super.copyWith((message) => updates(message as NoReply)) as NoReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use NoReply() / NoReply.new instead')
  static NoReply create() => NoReply._();
  static $pb.GeneratedMessage $_createMessage() => NoReply._();
  @$core.override
  NoReply createEmptyInstance() => NoReply._();
  @$core.pragma('dart2js:noInline')
  static NoReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NoReply>(NoReply.$_createMessage);
  static NoReply? _defaultInstance;
}

class NoReq extends $pb.GeneratedMessage {
  factory NoReq() => NoReq._();

  NoReq._();

  factory NoReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NoReq()..mergeFromBuffer(data, registry);
  factory NoReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NoReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NoReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: NoReq.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NoReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NoReq copyWith(void Function(NoReq) updates) =>
      super.copyWith((message) => updates(message as NoReq)) as NoReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use NoReq() / NoReq.new instead')
  static NoReq create() => NoReq._();
  static $pb.GeneratedMessage $_createMessage() => NoReq._();
  @$core.override
  NoReq createEmptyInstance() => NoReq._();
  @$core.pragma('dart2js:noInline')
  static NoReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NoReq>(NoReq.$_createMessage);
  static NoReq? _defaultInstance;
}

/// 认证信息
class OfficialVerify extends $pb.GeneratedMessage {
  factory OfficialVerify({
    $core.int? type,
    $core.String? desc,
    $core.int? isAtten,
  }) {
    final result = OfficialVerify._();
    if (type != null) result.type = type;
    if (desc != null) result.desc = desc;
    if (isAtten != null) result.isAtten = isAtten;
    return result;
  }

  OfficialVerify._();

  factory OfficialVerify.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfficialVerify()..mergeFromBuffer(data, registry);
  factory OfficialVerify.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfficialVerify()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfficialVerify',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: OfficialVerify.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'type')
    ..aOS(2, _omitFieldNames ? '' : 'desc')
    ..aI(3, _omitFieldNames ? '' : 'isAtten')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfficialVerify clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfficialVerify copyWith(void Function(OfficialVerify) updates) =>
      super.copyWith((message) => updates(message as OfficialVerify))
          as OfficialVerify;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OfficialVerify() / OfficialVerify.new instead')
  static OfficialVerify create() => OfficialVerify._();
  static $pb.GeneratedMessage $_createMessage() => OfficialVerify._();
  @$core.override
  OfficialVerify createEmptyInstance() => OfficialVerify._();
  @$core.pragma('dart2js:noInline')
  static OfficialVerify getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OfficialVerify>(
          OfficialVerify.$_createMessage);
  static OfficialVerify? _defaultInstance;

  /// - 0: 个人
  /// - 1: 官方
  /// - 127: 未认证
  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  /// 认证描述
  @$pb.TagNumber(2)
  $core.String get desc => $_getSZ(1);
  @$pb.TagNumber(2)
  set desc($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDesc() => $_has(1);
  @$pb.TagNumber(2)
  void clearDesc() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get isAtten => $_getIZ(2);
  @$pb.TagNumber(3)
  set isAtten($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsAtten() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsAtten() => $_clearField(3);
}

class OurCityClickReportReply extends $pb.GeneratedMessage {
  factory OurCityClickReportReply() => OurCityClickReportReply._();

  OurCityClickReportReply._();

  factory OurCityClickReportReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OurCityClickReportReply()..mergeFromBuffer(data, registry);
  factory OurCityClickReportReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OurCityClickReportReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OurCityClickReportReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: OurCityClickReportReply.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OurCityClickReportReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OurCityClickReportReply copyWith(
          void Function(OurCityClickReportReply) updates) =>
      super.copyWith((message) => updates(message as OurCityClickReportReply))
          as OurCityClickReportReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OurCityClickReportReply() / OurCityClickReportReply.new instead')
  static OurCityClickReportReply create() => OurCityClickReportReply._();
  static $pb.GeneratedMessage $_createMessage() => OurCityClickReportReply._();
  @$core.override
  OurCityClickReportReply createEmptyInstance() => OurCityClickReportReply._();
  @$core.pragma('dart2js:noInline')
  static OurCityClickReportReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OurCityClickReportReply>(
          OurCityClickReportReply.$_createMessage);
  static OurCityClickReportReply? _defaultInstance;
}

class OurCityClickReportReq extends $pb.GeneratedMessage {
  factory OurCityClickReportReq({
    $core.String? dynamicId,
    $fixnum.Int64? cityId,
    $core.double? lat,
    $core.double? lng,
  }) {
    final result = OurCityClickReportReq._();
    if (dynamicId != null) result.dynamicId = dynamicId;
    if (cityId != null) result.cityId = cityId;
    if (lat != null) result.lat = lat;
    if (lng != null) result.lng = lng;
    return result;
  }

  OurCityClickReportReq._();

  factory OurCityClickReportReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OurCityClickReportReq()..mergeFromBuffer(data, registry);
  factory OurCityClickReportReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OurCityClickReportReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OurCityClickReportReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: OurCityClickReportReq.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'dynamicId')
    ..aInt64(2, _omitFieldNames ? '' : 'cityId')
    ..aD(3, _omitFieldNames ? '' : 'lat')
    ..aD(4, _omitFieldNames ? '' : 'lng')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OurCityClickReportReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OurCityClickReportReq copyWith(
          void Function(OurCityClickReportReq) updates) =>
      super.copyWith((message) => updates(message as OurCityClickReportReq))
          as OurCityClickReportReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OurCityClickReportReq() / OurCityClickReportReq.new instead')
  static OurCityClickReportReq create() => OurCityClickReportReq._();
  static $pb.GeneratedMessage $_createMessage() => OurCityClickReportReq._();
  @$core.override
  OurCityClickReportReq createEmptyInstance() => OurCityClickReportReq._();
  @$core.pragma('dart2js:noInline')
  static OurCityClickReportReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OurCityClickReportReq>(
          OurCityClickReportReq.$_createMessage);
  static OurCityClickReportReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get dynamicId => $_getSZ(0);
  @$pb.TagNumber(1)
  set dynamicId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDynamicId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDynamicId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get cityId => $_getI64(1);
  @$pb.TagNumber(2)
  set cityId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get lat => $_getN(2);
  @$pb.TagNumber(3)
  set lat($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLat() => $_has(2);
  @$pb.TagNumber(3)
  void clearLat() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get lng => $_getN(3);
  @$pb.TagNumber(4)
  set lng($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLng() => $_has(3);
  @$pb.TagNumber(4)
  void clearLng() => $_clearField(4);
}

/// PGC 剧集信息
class PGCSeason extends $pb.GeneratedMessage {
  factory PGCSeason({
    $core.int? isFinish,
    $core.String? title,
    $core.int? type,
  }) {
    final result = PGCSeason._();
    if (isFinish != null) result.isFinish = isFinish;
    if (title != null) result.title = title;
    if (type != null) result.type = type;
    return result;
  }

  PGCSeason._();

  factory PGCSeason.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PGCSeason()..mergeFromBuffer(data, registry);
  factory PGCSeason.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PGCSeason()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PGCSeason',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: PGCSeason.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'isFinish')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aI(3, _omitFieldNames ? '' : 'type')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PGCSeason clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PGCSeason copyWith(void Function(PGCSeason) updates) =>
      super.copyWith((message) => updates(message as PGCSeason)) as PGCSeason;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PGCSeason() / PGCSeason.new instead')
  static PGCSeason create() => PGCSeason._();
  static $pb.GeneratedMessage $_createMessage() => PGCSeason._();
  @$core.override
  PGCSeason createEmptyInstance() => PGCSeason._();
  @$core.pragma('dart2js:noInline')
  static PGCSeason getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PGCSeason>(PGCSeason.$_createMessage);
  static PGCSeason? _defaultInstance;

  /// 已完结
  @$pb.TagNumber(1)
  $core.int get isFinish => $_getIZ(0);
  @$pb.TagNumber(1)
  set isFinish($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsFinish() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsFinish() => $_clearField(1);

  /// 标题
  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  /// 类型
  @$pb.TagNumber(3)
  $core.int get type => $_getIZ(2);
  @$pb.TagNumber(3)
  set type($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);
}

class PlayerPreloadParams extends $pb.GeneratedMessage {
  factory PlayerPreloadParams({
    $core.int? qn,
    $core.int? fnver,
    $core.int? fnval,
    $core.int? forceHost,
    $core.int? fourk,
  }) {
    final result = PlayerPreloadParams._();
    if (qn != null) result.qn = qn;
    if (fnver != null) result.fnver = fnver;
    if (fnval != null) result.fnval = fnval;
    if (forceHost != null) result.forceHost = forceHost;
    if (fourk != null) result.fourk = fourk;
    return result;
  }

  PlayerPreloadParams._();

  factory PlayerPreloadParams.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayerPreloadParams()..mergeFromBuffer(data, registry);
  factory PlayerPreloadParams.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayerPreloadParams()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerPreloadParams',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: PlayerPreloadParams.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'qn')
    ..aI(2, _omitFieldNames ? '' : 'fnver')
    ..aI(3, _omitFieldNames ? '' : 'fnval')
    ..aI(4, _omitFieldNames ? '' : 'forceHost')
    ..aI(5, _omitFieldNames ? '' : 'fourk')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerPreloadParams clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerPreloadParams copyWith(void Function(PlayerPreloadParams) updates) =>
      super.copyWith((message) => updates(message as PlayerPreloadParams))
          as PlayerPreloadParams;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use PlayerPreloadParams() / PlayerPreloadParams.new instead')
  static PlayerPreloadParams create() => PlayerPreloadParams._();
  static $pb.GeneratedMessage $_createMessage() => PlayerPreloadParams._();
  @$core.override
  PlayerPreloadParams createEmptyInstance() => PlayerPreloadParams._();
  @$core.pragma('dart2js:noInline')
  static PlayerPreloadParams getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerPreloadParams>(
          PlayerPreloadParams.$_createMessage);
  static PlayerPreloadParams? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get qn => $_getIZ(0);
  @$pb.TagNumber(1)
  set qn($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQn() => $_has(0);
  @$pb.TagNumber(1)
  void clearQn() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get fnver => $_getIZ(1);
  @$pb.TagNumber(2)
  set fnver($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFnver() => $_has(1);
  @$pb.TagNumber(2)
  void clearFnver() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get fnval => $_getIZ(2);
  @$pb.TagNumber(3)
  set fnval($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFnval() => $_has(2);
  @$pb.TagNumber(3)
  void clearFnval() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get forceHost => $_getIZ(3);
  @$pb.TagNumber(4)
  set forceHost($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasForceHost() => $_has(3);
  @$pb.TagNumber(4)
  void clearForceHost() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get fourk => $_getIZ(4);
  @$pb.TagNumber(5)
  set fourk($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFourk() => $_has(4);
  @$pb.TagNumber(5)
  void clearFourk() => $_clearField(5);
}

/// 动态 tab 弹窗详情
class Popup extends $pb.GeneratedMessage {
  factory Popup({
    $core.String? title,
    $core.String? desc,
    $core.String? uri,
  }) {
    final result = Popup._();
    if (title != null) result.title = title;
    if (desc != null) result.desc = desc;
    if (uri != null) result.uri = uri;
    return result;
  }

  Popup._();

  factory Popup.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Popup()..mergeFromBuffer(data, registry);
  factory Popup.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Popup()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Popup',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: Popup.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'desc')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Popup clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Popup copyWith(void Function(Popup) updates) =>
      super.copyWith((message) => updates(message as Popup)) as Popup;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Popup() / Popup.new instead')
  static Popup create() => Popup._();
  static $pb.GeneratedMessage $_createMessage() => Popup._();
  @$core.override
  Popup createEmptyInstance() => Popup._();
  @$core.pragma('dart2js:noInline')
  static Popup getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Popup>(Popup.$_createMessage);
  static Popup? _defaultInstance;

  /// 标题
  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  /// 文案
  @$pb.TagNumber(2)
  $core.String get desc => $_getSZ(1);
  @$pb.TagNumber(2)
  set desc($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDesc() => $_has(1);
  @$pb.TagNumber(2)
  void clearDesc() => $_clearField(2);

  /// 文案附加跳转地址
  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);
}

class Relation extends $pb.GeneratedMessage {
  factory Relation({
    RelationStatus? status,
    $core.int? isFollow,
    $core.int? isFollowed,
    $core.String? title,
  }) {
    final result = Relation._();
    if (status != null) result.status = status;
    if (isFollow != null) result.isFollow = isFollow;
    if (isFollowed != null) result.isFollowed = isFollowed;
    if (title != null) result.title = title;
    return result;
  }

  Relation._();

  factory Relation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Relation()..mergeFromBuffer(data, registry);
  factory Relation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Relation()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Relation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: Relation.$_createMessage)
    ..aE<RelationStatus>(1, _omitFieldNames ? '' : 'status',
        enumValues: RelationStatus.values)
    ..aI(2, _omitFieldNames ? '' : 'isFollow')
    ..aI(3, _omitFieldNames ? '' : 'isFollowed')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Relation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Relation copyWith(void Function(Relation) updates) =>
      super.copyWith((message) => updates(message as Relation)) as Relation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Relation() / Relation.new instead')
  static Relation create() => Relation._();
  static $pb.GeneratedMessage $_createMessage() => Relation._();
  @$core.override
  Relation createEmptyInstance() => Relation._();
  @$core.pragma('dart2js:noInline')
  static Relation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Relation>(Relation.$_createMessage);
  static Relation? _defaultInstance;

  @$pb.TagNumber(1)
  RelationStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(RelationStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get isFollow => $_getIZ(1);
  @$pb.TagNumber(2)
  set isFollow($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsFollow() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsFollow() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get isFollowed => $_getIZ(2);
  @$pb.TagNumber(3)
  set isFollowed($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsFollowed() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsFollowed() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);
}

class SVideoItem extends $pb.GeneratedMessage {
  factory SVideoItem({
    $core.String? cardType,
    $core.Iterable<SVideoModule>? modules,
    $core.String? dynIdStr,
    $fixnum.Int64? index,
  }) {
    final result = SVideoItem._();
    if (cardType != null) result.cardType = cardType;
    if (modules != null) result.modules.addAll(modules);
    if (dynIdStr != null) result.dynIdStr = dynIdStr;
    if (index != null) result.index = index;
    return result;
  }

  SVideoItem._();

  factory SVideoItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoItem()..mergeFromBuffer(data, registry);
  factory SVideoItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SVideoItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: SVideoItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'cardType')
    ..pPM<SVideoModule>(2, _omitFieldNames ? '' : 'modules',
        subBuilder: SVideoModule.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'dynIdStr')
    ..aInt64(4, _omitFieldNames ? '' : 'index')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoItem copyWith(void Function(SVideoItem) updates) =>
      super.copyWith((message) => updates(message as SVideoItem)) as SVideoItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SVideoItem() / SVideoItem.new instead')
  static SVideoItem create() => SVideoItem._();
  static $pb.GeneratedMessage $_createMessage() => SVideoItem._();
  @$core.override
  SVideoItem createEmptyInstance() => SVideoItem._();
  @$core.pragma('dart2js:noInline')
  static SVideoItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SVideoItem>(SVideoItem.$_createMessage);
  static SVideoItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cardType => $_getSZ(0);
  @$pb.TagNumber(1)
  set cardType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCardType() => $_has(0);
  @$pb.TagNumber(1)
  void clearCardType() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<SVideoModule> get modules => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get dynIdStr => $_getSZ(2);
  @$pb.TagNumber(3)
  set dynIdStr($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDynIdStr() => $_has(2);
  @$pb.TagNumber(3)
  void clearDynIdStr() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get index => $_getI64(3);
  @$pb.TagNumber(4)
  set index($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearIndex() => $_clearField(4);
}

enum SVideoModule_ModuleItem {
  moduleAuthor,
  modulePlayer,
  moduleDesc,
  moduleStat,
  notSet
}

class SVideoModule extends $pb.GeneratedMessage {
  factory SVideoModule({
    $core.String? moduleType,
    SVideoModuleAuthor? moduleAuthor,
    SVideoModulePlayer? modulePlayer,
    SVideoModuleDesc? moduleDesc,
    SVideoModuleStat? moduleStat,
  }) {
    final result = SVideoModule._();
    if (moduleType != null) result.moduleType = moduleType;
    if (moduleAuthor != null) result.moduleAuthor = moduleAuthor;
    if (modulePlayer != null) result.modulePlayer = modulePlayer;
    if (moduleDesc != null) result.moduleDesc = moduleDesc;
    if (moduleStat != null) result.moduleStat = moduleStat;
    return result;
  }

  SVideoModule._();

  factory SVideoModule.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoModule()..mergeFromBuffer(data, registry);
  factory SVideoModule.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoModule()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SVideoModule_ModuleItem>
      _SVideoModule_ModuleItemByTag = {
    2: SVideoModule_ModuleItem.moduleAuthor,
    3: SVideoModule_ModuleItem.modulePlayer,
    4: SVideoModule_ModuleItem.moduleDesc,
    5: SVideoModule_ModuleItem.moduleStat,
    0: SVideoModule_ModuleItem.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SVideoModule',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: SVideoModule.$_createMessage)
    ..oo(0, [2, 3, 4, 5])
    ..aOS(1, _omitFieldNames ? '' : 'moduleType')
    ..aOM<SVideoModuleAuthor>(2, _omitFieldNames ? '' : 'moduleAuthor',
        subBuilder: SVideoModuleAuthor.$_createMessage)
    ..aOM<SVideoModulePlayer>(3, _omitFieldNames ? '' : 'modulePlayer',
        subBuilder: SVideoModulePlayer.$_createMessage)
    ..aOM<SVideoModuleDesc>(4, _omitFieldNames ? '' : 'moduleDesc',
        subBuilder: SVideoModuleDesc.$_createMessage)
    ..aOM<SVideoModuleStat>(5, _omitFieldNames ? '' : 'moduleStat',
        subBuilder: SVideoModuleStat.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoModule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoModule copyWith(void Function(SVideoModule) updates) =>
      super.copyWith((message) => updates(message as SVideoModule))
          as SVideoModule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SVideoModule() / SVideoModule.new instead')
  static SVideoModule create() => SVideoModule._();
  static $pb.GeneratedMessage $_createMessage() => SVideoModule._();
  @$core.override
  SVideoModule createEmptyInstance() => SVideoModule._();
  @$core.pragma('dart2js:noInline')
  static SVideoModule getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SVideoModule>(
          SVideoModule.$_createMessage);
  static SVideoModule? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  SVideoModule_ModuleItem whichModuleItem() =>
      _SVideoModule_ModuleItemByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearModuleItem() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get moduleType => $_getSZ(0);
  @$pb.TagNumber(1)
  set moduleType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasModuleType() => $_has(0);
  @$pb.TagNumber(1)
  void clearModuleType() => $_clearField(1);

  @$pb.TagNumber(2)
  SVideoModuleAuthor get moduleAuthor => $_getN(1);
  @$pb.TagNumber(2)
  set moduleAuthor(SVideoModuleAuthor value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasModuleAuthor() => $_has(1);
  @$pb.TagNumber(2)
  void clearModuleAuthor() => $_clearField(2);
  @$pb.TagNumber(2)
  SVideoModuleAuthor ensureModuleAuthor() => $_ensure(1);

  @$pb.TagNumber(3)
  SVideoModulePlayer get modulePlayer => $_getN(2);
  @$pb.TagNumber(3)
  set modulePlayer(SVideoModulePlayer value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasModulePlayer() => $_has(2);
  @$pb.TagNumber(3)
  void clearModulePlayer() => $_clearField(3);
  @$pb.TagNumber(3)
  SVideoModulePlayer ensureModulePlayer() => $_ensure(2);

  @$pb.TagNumber(4)
  SVideoModuleDesc get moduleDesc => $_getN(3);
  @$pb.TagNumber(4)
  set moduleDesc(SVideoModuleDesc value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasModuleDesc() => $_has(3);
  @$pb.TagNumber(4)
  void clearModuleDesc() => $_clearField(4);
  @$pb.TagNumber(4)
  SVideoModuleDesc ensureModuleDesc() => $_ensure(3);

  @$pb.TagNumber(5)
  SVideoModuleStat get moduleStat => $_getN(4);
  @$pb.TagNumber(5)
  set moduleStat(SVideoModuleStat value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasModuleStat() => $_has(4);
  @$pb.TagNumber(5)
  void clearModuleStat() => $_clearField(5);
  @$pb.TagNumber(5)
  SVideoModuleStat ensureModuleStat() => $_ensure(4);
}

class SVideoModuleAuthor extends $pb.GeneratedMessage {
  factory SVideoModuleAuthor({
    $fixnum.Int64? mid,
    $core.String? name,
    $core.String? face,
    $core.String? pubDesc,
    $core.int? isAttention,
    $core.String? uri,
  }) {
    final result = SVideoModuleAuthor._();
    if (mid != null) result.mid = mid;
    if (name != null) result.name = name;
    if (face != null) result.face = face;
    if (pubDesc != null) result.pubDesc = pubDesc;
    if (isAttention != null) result.isAttention = isAttention;
    if (uri != null) result.uri = uri;
    return result;
  }

  SVideoModuleAuthor._();

  factory SVideoModuleAuthor.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoModuleAuthor()..mergeFromBuffer(data, registry);
  factory SVideoModuleAuthor.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoModuleAuthor()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SVideoModuleAuthor',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: SVideoModuleAuthor.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'face')
    ..aOS(4, _omitFieldNames ? '' : 'pubDesc')
    ..aI(5, _omitFieldNames ? '' : 'isAttention')
    ..aOS(6, _omitFieldNames ? '' : 'uri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoModuleAuthor clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoModuleAuthor copyWith(void Function(SVideoModuleAuthor) updates) =>
      super.copyWith((message) => updates(message as SVideoModuleAuthor))
          as SVideoModuleAuthor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SVideoModuleAuthor() / SVideoModuleAuthor.new instead')
  static SVideoModuleAuthor create() => SVideoModuleAuthor._();
  static $pb.GeneratedMessage $_createMessage() => SVideoModuleAuthor._();
  @$core.override
  SVideoModuleAuthor createEmptyInstance() => SVideoModuleAuthor._();
  @$core.pragma('dart2js:noInline')
  static SVideoModuleAuthor getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SVideoModuleAuthor>(
          SVideoModuleAuthor.$_createMessage);
  static SVideoModuleAuthor? _defaultInstance;

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
  $core.String get face => $_getSZ(2);
  @$pb.TagNumber(3)
  set face($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFace() => $_has(2);
  @$pb.TagNumber(3)
  void clearFace() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get pubDesc => $_getSZ(3);
  @$pb.TagNumber(4)
  set pubDesc($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPubDesc() => $_has(3);
  @$pb.TagNumber(4)
  void clearPubDesc() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get isAttention => $_getIZ(4);
  @$pb.TagNumber(5)
  set isAttention($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsAttention() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsAttention() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get uri => $_getSZ(5);
  @$pb.TagNumber(6)
  set uri($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUri() => $_has(5);
  @$pb.TagNumber(6)
  void clearUri() => $_clearField(6);
}

class SVideoModuleDesc extends $pb.GeneratedMessage {
  factory SVideoModuleDesc({
    $core.String? text,
    $core.String? uri,
  }) {
    final result = SVideoModuleDesc._();
    if (text != null) result.text = text;
    if (uri != null) result.uri = uri;
    return result;
  }

  SVideoModuleDesc._();

  factory SVideoModuleDesc.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoModuleDesc()..mergeFromBuffer(data, registry);
  factory SVideoModuleDesc.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoModuleDesc()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SVideoModuleDesc',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: SVideoModuleDesc.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'uri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoModuleDesc clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoModuleDesc copyWith(void Function(SVideoModuleDesc) updates) =>
      super.copyWith((message) => updates(message as SVideoModuleDesc))
          as SVideoModuleDesc;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SVideoModuleDesc() / SVideoModuleDesc.new instead')
  static SVideoModuleDesc create() => SVideoModuleDesc._();
  static $pb.GeneratedMessage $_createMessage() => SVideoModuleDesc._();
  @$core.override
  SVideoModuleDesc createEmptyInstance() => SVideoModuleDesc._();
  @$core.pragma('dart2js:noInline')
  static SVideoModuleDesc getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SVideoModuleDesc>(
          SVideoModuleDesc.$_createMessage);
  static SVideoModuleDesc? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get uri => $_getSZ(1);
  @$pb.TagNumber(2)
  set uri($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearUri() => $_clearField(2);
}

class SVideoModulePlayer extends $pb.GeneratedMessage {
  factory SVideoModulePlayer({
    $core.String? title,
    $core.String? cover,
    $core.String? uri,
    $fixnum.Int64? aid,
    $fixnum.Int64? cid,
    $fixnum.Int64? duration,
    Dimension? dimension,
  }) {
    final result = SVideoModulePlayer._();
    if (title != null) result.title = title;
    if (cover != null) result.cover = cover;
    if (uri != null) result.uri = uri;
    if (aid != null) result.aid = aid;
    if (cid != null) result.cid = cid;
    if (duration != null) result.duration = duration;
    if (dimension != null) result.dimension = dimension;
    return result;
  }

  SVideoModulePlayer._();

  factory SVideoModulePlayer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoModulePlayer()..mergeFromBuffer(data, registry);
  factory SVideoModulePlayer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoModulePlayer()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SVideoModulePlayer',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: SVideoModulePlayer.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'cover')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..aInt64(4, _omitFieldNames ? '' : 'aid')
    ..aInt64(5, _omitFieldNames ? '' : 'cid')
    ..aInt64(6, _omitFieldNames ? '' : 'duration')
    ..aOM<Dimension>(7, _omitFieldNames ? '' : 'dimension',
        subBuilder: Dimension.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoModulePlayer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoModulePlayer copyWith(void Function(SVideoModulePlayer) updates) =>
      super.copyWith((message) => updates(message as SVideoModulePlayer))
          as SVideoModulePlayer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SVideoModulePlayer() / SVideoModulePlayer.new instead')
  static SVideoModulePlayer create() => SVideoModulePlayer._();
  static $pb.GeneratedMessage $_createMessage() => SVideoModulePlayer._();
  @$core.override
  SVideoModulePlayer createEmptyInstance() => SVideoModulePlayer._();
  @$core.pragma('dart2js:noInline')
  static SVideoModulePlayer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SVideoModulePlayer>(
          SVideoModulePlayer.$_createMessage);
  static SVideoModulePlayer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cover => $_getSZ(1);
  @$pb.TagNumber(2)
  set cover($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCover() => $_has(1);
  @$pb.TagNumber(2)
  void clearCover() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get aid => $_getI64(3);
  @$pb.TagNumber(4)
  set aid($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAid() => $_has(3);
  @$pb.TagNumber(4)
  void clearAid() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get cid => $_getI64(4);
  @$pb.TagNumber(5)
  set cid($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCid() => $_has(4);
  @$pb.TagNumber(5)
  void clearCid() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get duration => $_getI64(5);
  @$pb.TagNumber(6)
  set duration($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDuration() => $_has(5);
  @$pb.TagNumber(6)
  void clearDuration() => $_clearField(6);

  @$pb.TagNumber(7)
  Dimension get dimension => $_getN(6);
  @$pb.TagNumber(7)
  set dimension(Dimension value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDimension() => $_has(6);
  @$pb.TagNumber(7)
  void clearDimension() => $_clearField(7);
  @$pb.TagNumber(7)
  Dimension ensureDimension() => $_ensure(6);
}

class SVideoModuleStat extends $pb.GeneratedMessage {
  factory SVideoModuleStat({
    $core.Iterable<SVideoStatInfo>? statInfo,
    ShareInfo? shareInfo,
  }) {
    final result = SVideoModuleStat._();
    if (statInfo != null) result.statInfo.addAll(statInfo);
    if (shareInfo != null) result.shareInfo = shareInfo;
    return result;
  }

  SVideoModuleStat._();

  factory SVideoModuleStat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoModuleStat()..mergeFromBuffer(data, registry);
  factory SVideoModuleStat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoModuleStat()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SVideoModuleStat',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: SVideoModuleStat.$_createMessage)
    ..pPM<SVideoStatInfo>(1, _omitFieldNames ? '' : 'statInfo',
        subBuilder: SVideoStatInfo.$_createMessage)
    ..aOM<ShareInfo>(2, _omitFieldNames ? '' : 'shareInfo',
        subBuilder: ShareInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoModuleStat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoModuleStat copyWith(void Function(SVideoModuleStat) updates) =>
      super.copyWith((message) => updates(message as SVideoModuleStat))
          as SVideoModuleStat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SVideoModuleStat() / SVideoModuleStat.new instead')
  static SVideoModuleStat create() => SVideoModuleStat._();
  static $pb.GeneratedMessage $_createMessage() => SVideoModuleStat._();
  @$core.override
  SVideoModuleStat createEmptyInstance() => SVideoModuleStat._();
  @$core.pragma('dart2js:noInline')
  static SVideoModuleStat getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SVideoModuleStat>(
          SVideoModuleStat.$_createMessage);
  static SVideoModuleStat? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SVideoStatInfo> get statInfo => $_getList(0);

  @$pb.TagNumber(2)
  ShareInfo get shareInfo => $_getN(1);
  @$pb.TagNumber(2)
  set shareInfo(ShareInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasShareInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearShareInfo() => $_clearField(2);
  @$pb.TagNumber(2)
  ShareInfo ensureShareInfo() => $_ensure(1);
}

class SVideoReply extends $pb.GeneratedMessage {
  factory SVideoReply({
    $core.Iterable<SVideoItem>? list,
    $core.String? offset,
    $core.int? hasMore,
    SVideoTop? top,
  }) {
    final result = SVideoReply._();
    if (list != null) result.list.addAll(list);
    if (offset != null) result.offset = offset;
    if (hasMore != null) result.hasMore = hasMore;
    if (top != null) result.top = top;
    return result;
  }

  SVideoReply._();

  factory SVideoReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoReply()..mergeFromBuffer(data, registry);
  factory SVideoReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SVideoReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: SVideoReply.$_createMessage)
    ..pPM<SVideoItem>(1, _omitFieldNames ? '' : 'list',
        subBuilder: SVideoItem.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'offset')
    ..aI(3, _omitFieldNames ? '' : 'hasMore')
    ..aOM<SVideoTop>(4, _omitFieldNames ? '' : 'top',
        subBuilder: SVideoTop.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoReply copyWith(void Function(SVideoReply) updates) =>
      super.copyWith((message) => updates(message as SVideoReply))
          as SVideoReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SVideoReply() / SVideoReply.new instead')
  static SVideoReply create() => SVideoReply._();
  static $pb.GeneratedMessage $_createMessage() => SVideoReply._();
  @$core.override
  SVideoReply createEmptyInstance() => SVideoReply._();
  @$core.pragma('dart2js:noInline')
  static SVideoReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SVideoReply>(
          SVideoReply.$_createMessage);
  static SVideoReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SVideoItem> get list => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get offset => $_getSZ(1);
  @$pb.TagNumber(2)
  set offset($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get hasMore => $_getIZ(2);
  @$pb.TagNumber(3)
  set hasMore($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasMore() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasMore() => $_clearField(3);

  @$pb.TagNumber(4)
  SVideoTop get top => $_getN(3);
  @$pb.TagNumber(4)
  set top(SVideoTop value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTop() => $_has(3);
  @$pb.TagNumber(4)
  void clearTop() => $_clearField(4);
  @$pb.TagNumber(4)
  SVideoTop ensureTop() => $_ensure(3);
}

/// 小视频连播页请求参数
class SVideoReq extends $pb.GeneratedMessage {
  factory SVideoReq({
    $fixnum.Int64? oid,
    SVideoType? type,
    $core.String? offset,
    $core.int? qn,
    $core.int? fnver,
    $core.int? fnval,
    $core.int? forceHost,
    $core.int? fourk,
    $core.String? spmid,
    $core.String? fromSpmid,
    PlayerPreloadParams? playerPreload,
    $fixnum.Int64? focusAid,
    $1.PlayerArgs? playerArgs,
  }) {
    final result = SVideoReq._();
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    if (offset != null) result.offset = offset;
    if (qn != null) result.qn = qn;
    if (fnver != null) result.fnver = fnver;
    if (fnval != null) result.fnval = fnval;
    if (forceHost != null) result.forceHost = forceHost;
    if (fourk != null) result.fourk = fourk;
    if (spmid != null) result.spmid = spmid;
    if (fromSpmid != null) result.fromSpmid = fromSpmid;
    if (playerPreload != null) result.playerPreload = playerPreload;
    if (focusAid != null) result.focusAid = focusAid;
    if (playerArgs != null) result.playerArgs = playerArgs;
    return result;
  }

  SVideoReq._();

  factory SVideoReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoReq()..mergeFromBuffer(data, registry);
  factory SVideoReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SVideoReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: SVideoReq.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'oid')
    ..aE<SVideoType>(2, _omitFieldNames ? '' : 'type',
        enumValues: SVideoType.values)
    ..aOS(3, _omitFieldNames ? '' : 'offset')
    ..aI(4, _omitFieldNames ? '' : 'qn')
    ..aI(5, _omitFieldNames ? '' : 'fnver')
    ..aI(6, _omitFieldNames ? '' : 'fnval')
    ..aI(7, _omitFieldNames ? '' : 'forceHost')
    ..aI(8, _omitFieldNames ? '' : 'fourk')
    ..aOS(9, _omitFieldNames ? '' : 'spmid')
    ..aOS(10, _omitFieldNames ? '' : 'fromSpmid')
    ..aOM<PlayerPreloadParams>(11, _omitFieldNames ? '' : 'playerPreload',
        subBuilder: PlayerPreloadParams.$_createMessage)
    ..aInt64(12, _omitFieldNames ? '' : 'focusAid')
    ..aOM<$1.PlayerArgs>(13, _omitFieldNames ? '' : 'playerArgs',
        subBuilder: $1.PlayerArgs.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoReq copyWith(void Function(SVideoReq) updates) =>
      super.copyWith((message) => updates(message as SVideoReq)) as SVideoReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SVideoReq() / SVideoReq.new instead')
  static SVideoReq create() => SVideoReq._();
  static $pb.GeneratedMessage $_createMessage() => SVideoReq._();
  @$core.override
  SVideoReq createEmptyInstance() => SVideoReq._();
  @$core.pragma('dart2js:noInline')
  static SVideoReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SVideoReq>(SVideoReq.$_createMessage);
  static SVideoReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get oid => $_getI64(0);
  @$pb.TagNumber(1)
  set oid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOid() => $_has(0);
  @$pb.TagNumber(1)
  void clearOid() => $_clearField(1);

  @$pb.TagNumber(2)
  SVideoType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(SVideoType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get offset => $_getSZ(2);
  @$pb.TagNumber(3)
  set offset($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get qn => $_getIZ(3);
  @$pb.TagNumber(4)
  set qn($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQn() => $_has(3);
  @$pb.TagNumber(4)
  void clearQn() => $_clearField(4);

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
  $core.int get forceHost => $_getIZ(6);
  @$pb.TagNumber(7)
  set forceHost($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasForceHost() => $_has(6);
  @$pb.TagNumber(7)
  void clearForceHost() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get fourk => $_getIZ(7);
  @$pb.TagNumber(8)
  set fourk($core.int value) => $_setSignedInt32(7, value);
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
  PlayerPreloadParams get playerPreload => $_getN(10);
  @$pb.TagNumber(11)
  set playerPreload(PlayerPreloadParams value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasPlayerPreload() => $_has(10);
  @$pb.TagNumber(11)
  void clearPlayerPreload() => $_clearField(11);
  @$pb.TagNumber(11)
  PlayerPreloadParams ensurePlayerPreload() => $_ensure(10);

  @$pb.TagNumber(12)
  $fixnum.Int64 get focusAid => $_getI64(11);
  @$pb.TagNumber(12)
  set focusAid($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasFocusAid() => $_has(11);
  @$pb.TagNumber(12)
  void clearFocusAid() => $_clearField(12);

  @$pb.TagNumber(13)
  $1.PlayerArgs get playerArgs => $_getN(12);
  @$pb.TagNumber(13)
  set playerArgs($1.PlayerArgs value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasPlayerArgs() => $_has(12);
  @$pb.TagNumber(13)
  void clearPlayerArgs() => $_clearField(13);
  @$pb.TagNumber(13)
  $1.PlayerArgs ensurePlayerArgs() => $_ensure(12);
}

class SVideoStatInfo extends $pb.GeneratedMessage {
  factory SVideoStatInfo({
    $core.int? icon,
    $fixnum.Int64? num,
    $core.int? selected,
    $core.String? uri,
  }) {
    final result = SVideoStatInfo._();
    if (icon != null) result.icon = icon;
    if (num != null) result.num = num;
    if (selected != null) result.selected = selected;
    if (uri != null) result.uri = uri;
    return result;
  }

  SVideoStatInfo._();

  factory SVideoStatInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoStatInfo()..mergeFromBuffer(data, registry);
  factory SVideoStatInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoStatInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SVideoStatInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: SVideoStatInfo.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'icon')
    ..aInt64(2, _omitFieldNames ? '' : 'num')
    ..aI(3, _omitFieldNames ? '' : 'selected')
    ..aOS(4, _omitFieldNames ? '' : 'uri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoStatInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoStatInfo copyWith(void Function(SVideoStatInfo) updates) =>
      super.copyWith((message) => updates(message as SVideoStatInfo))
          as SVideoStatInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SVideoStatInfo() / SVideoStatInfo.new instead')
  static SVideoStatInfo create() => SVideoStatInfo._();
  static $pb.GeneratedMessage $_createMessage() => SVideoStatInfo._();
  @$core.override
  SVideoStatInfo createEmptyInstance() => SVideoStatInfo._();
  @$core.pragma('dart2js:noInline')
  static SVideoStatInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SVideoStatInfo>(
          SVideoStatInfo.$_createMessage);
  static SVideoStatInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get icon => $_getIZ(0);
  @$pb.TagNumber(1)
  set icon($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIcon() => $_has(0);
  @$pb.TagNumber(1)
  void clearIcon() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get num => $_getI64(1);
  @$pb.TagNumber(2)
  set num($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNum() => $_has(1);
  @$pb.TagNumber(2)
  void clearNum() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get selected => $_getIZ(2);
  @$pb.TagNumber(3)
  set selected($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSelected() => $_has(2);
  @$pb.TagNumber(3)
  void clearSelected() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get uri => $_getSZ(3);
  @$pb.TagNumber(4)
  set uri($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUri() => $_has(3);
  @$pb.TagNumber(4)
  void clearUri() => $_clearField(4);
}

class SVideoTop extends $pb.GeneratedMessage {
  factory SVideoTop({
    $core.String? title,
    $core.String? desc,
  }) {
    final result = SVideoTop._();
    if (title != null) result.title = title;
    if (desc != null) result.desc = desc;
    return result;
  }

  SVideoTop._();

  factory SVideoTop.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoTop()..mergeFromBuffer(data, registry);
  factory SVideoTop.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SVideoTop()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SVideoTop',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: SVideoTop.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'desc')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoTop clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SVideoTop copyWith(void Function(SVideoTop) updates) =>
      super.copyWith((message) => updates(message as SVideoTop)) as SVideoTop;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SVideoTop() / SVideoTop.new instead')
  static SVideoTop create() => SVideoTop._();
  static $pb.GeneratedMessage $_createMessage() => SVideoTop._();
  @$core.override
  SVideoTop createEmptyInstance() => SVideoTop._();
  @$core.pragma('dart2js:noInline')
  static SVideoTop getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SVideoTop>(SVideoTop.$_createMessage);
  static SVideoTop? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get desc => $_getSZ(1);
  @$pb.TagNumber(2)
  set desc($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDesc() => $_has(1);
  @$pb.TagNumber(2)
  void clearDesc() => $_clearField(2);
}

/// 分享信息
class ShareInfo extends $pb.GeneratedMessage {
  factory ShareInfo({
    $fixnum.Int64? aid,
    $core.String? bvid,
    $core.String? title,
    $core.String? subtitle,
    $core.String? cover,
    $fixnum.Int64? mid,
    $core.String? name,
  }) {
    final result = ShareInfo._();
    if (aid != null) result.aid = aid;
    if (bvid != null) result.bvid = bvid;
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    if (cover != null) result.cover = cover;
    if (mid != null) result.mid = mid;
    if (name != null) result.name = name;
    return result;
  }

  ShareInfo._();

  factory ShareInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShareInfo()..mergeFromBuffer(data, registry);
  factory ShareInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShareInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShareInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: ShareInfo.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aOS(2, _omitFieldNames ? '' : 'bvid')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'subtitle')
    ..aOS(5, _omitFieldNames ? '' : 'cover')
    ..aInt64(6, _omitFieldNames ? '' : 'mid')
    ..aOS(7, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareInfo copyWith(void Function(ShareInfo) updates) =>
      super.copyWith((message) => updates(message as ShareInfo)) as ShareInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ShareInfo() / ShareInfo.new instead')
  static ShareInfo create() => ShareInfo._();
  static $pb.GeneratedMessage $_createMessage() => ShareInfo._();
  @$core.override
  ShareInfo createEmptyInstance() => ShareInfo._();
  @$core.pragma('dart2js:noInline')
  static ShareInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShareInfo>(ShareInfo.$_createMessage);
  static ShareInfo? _defaultInstance;

  /// 稿件 avid
  @$pb.TagNumber(1)
  $fixnum.Int64 get aid => $_getI64(0);
  @$pb.TagNumber(1)
  set aid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => $_clearField(1);

  /// 稿件 bvid
  @$pb.TagNumber(2)
  $core.String get bvid => $_getSZ(1);
  @$pb.TagNumber(2)
  set bvid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBvid() => $_has(1);
  @$pb.TagNumber(2)
  void clearBvid() => $_clearField(2);

  /// 稿件标题
  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  /// 稿件字幕
  @$pb.TagNumber(4)
  $core.String get subtitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set subtitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubtitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubtitle() => $_clearField(4);

  /// 稿件方面
  @$pb.TagNumber(5)
  $core.String get cover => $_getSZ(4);
  @$pb.TagNumber(5)
  set cover($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCover() => $_has(4);
  @$pb.TagNumber(5)
  void clearCover() => $_clearField(5);

  /// UP 主 mid
  @$pb.TagNumber(6)
  $fixnum.Int64 get mid => $_getI64(5);
  @$pb.TagNumber(6)
  set mid($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMid() => $_has(5);
  @$pb.TagNumber(6)
  void clearMid() => $_clearField(6);

  /// UP 主昵称
  @$pb.TagNumber(7)
  $core.String get name => $_getSZ(6);
  @$pb.TagNumber(7)
  set name($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasName() => $_has(6);
  @$pb.TagNumber(7)
  void clearName() => $_clearField(7);
}

/// 动态红点接口各 tab offset 信息
class TabOffset extends $pb.GeneratedMessage {
  factory TabOffset({
    $core.int? tab,
    $core.String? offset,
  }) {
    final result = TabOffset._();
    if (tab != null) result.tab = tab;
    if (offset != null) result.offset = offset;
    return result;
  }

  TabOffset._();

  factory TabOffset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TabOffset()..mergeFromBuffer(data, registry);
  factory TabOffset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TabOffset()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TabOffset',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: TabOffset.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'tab')
    ..aOS(2, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TabOffset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TabOffset copyWith(void Function(TabOffset) updates) =>
      super.copyWith((message) => updates(message as TabOffset)) as TabOffset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TabOffset() / TabOffset.new instead')
  static TabOffset create() => TabOffset._();
  static $pb.GeneratedMessage $_createMessage() => TabOffset._();
  @$core.override
  TabOffset createEmptyInstance() => TabOffset._();
  @$core.pragma('dart2js:noInline')
  static TabOffset getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TabOffset>(TabOffset.$_createMessage);
  static TabOffset? _defaultInstance;

  /// - 1: 综合页
  /// - 2: 视频页
  @$pb.TagNumber(1)
  $core.int get tab => $_getIZ(0);
  @$pb.TagNumber(1)
  set tab($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTab() => $_has(0);
  @$pb.TagNumber(1)
  void clearTab() => $_clearField(1);

  /// 上一次对应列表页 offset
  @$pb.TagNumber(2)
  $core.String get offset => $_getSZ(1);
  @$pb.TagNumber(2)
  set offset($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);
}

/// UP 主列表
class UpListItem extends $pb.GeneratedMessage {
  factory UpListItem({
    $core.int? hasUpdate,
    $core.String? face,
    $core.String? name,
    $fixnum.Int64? uid,
  }) {
    final result = UpListItem._();
    if (hasUpdate != null) result.hasUpdate = hasUpdate;
    if (face != null) result.face = face;
    if (name != null) result.name = name;
    if (uid != null) result.uid = uid;
    return result;
  }

  UpListItem._();

  factory UpListItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpListItem()..mergeFromBuffer(data, registry);
  factory UpListItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpListItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpListItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: UpListItem.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'hasUpdate')
    ..aOS(2, _omitFieldNames ? '' : 'face')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aInt64(4, _omitFieldNames ? '' : 'uid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpListItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpListItem copyWith(void Function(UpListItem) updates) =>
      super.copyWith((message) => updates(message as UpListItem)) as UpListItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UpListItem() / UpListItem.new instead')
  static UpListItem create() => UpListItem._();
  static $pb.GeneratedMessage $_createMessage() => UpListItem._();
  @$core.override
  UpListItem createEmptyInstance() => UpListItem._();
  @$core.pragma('dart2js:noInline')
  static UpListItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpListItem>(UpListItem.$_createMessage);
  static UpListItem? _defaultInstance;

  /// 是否有更新
  @$pb.TagNumber(1)
  $core.int get hasUpdate => $_getIZ(0);
  @$pb.TagNumber(1)
  set hasUpdate($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHasUpdate() => $_has(0);
  @$pb.TagNumber(1)
  void clearHasUpdate() => $_clearField(1);

  /// 头像
  @$pb.TagNumber(2)
  $core.String get face => $_getSZ(1);
  @$pb.TagNumber(2)
  set face($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFace() => $_has(1);
  @$pb.TagNumber(2)
  void clearFace() => $_clearField(2);

  /// 昵称
  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  /// mid
  @$pb.TagNumber(4)
  $fixnum.Int64 get uid => $_getI64(3);
  @$pb.TagNumber(4)
  set uid($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUid() => $_has(3);
  @$pb.TagNumber(4)
  void clearUid() => $_clearField(4);
}

/// 用户信息
class UserInfo extends $pb.GeneratedMessage {
  factory UserInfo({
    $fixnum.Int64? mid,
    $core.String? name,
    $core.String? face,
    OfficialVerify? official,
    VipInfo? vip,
    LiveInfo? live,
    $core.String? uri,
    UserPendant? pendant,
    Nameplate? nameplate,
  }) {
    final result = UserInfo._();
    if (mid != null) result.mid = mid;
    if (name != null) result.name = name;
    if (face != null) result.face = face;
    if (official != null) result.official = official;
    if (vip != null) result.vip = vip;
    if (live != null) result.live = live;
    if (uri != null) result.uri = uri;
    if (pendant != null) result.pendant = pendant;
    if (nameplate != null) result.nameplate = nameplate;
    return result;
  }

  UserInfo._();

  factory UserInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserInfo()..mergeFromBuffer(data, registry);
  factory UserInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: UserInfo.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'face')
    ..aOM<OfficialVerify>(4, _omitFieldNames ? '' : 'official',
        subBuilder: OfficialVerify.$_createMessage)
    ..aOM<VipInfo>(5, _omitFieldNames ? '' : 'vip',
        subBuilder: VipInfo.$_createMessage)
    ..aOM<LiveInfo>(6, _omitFieldNames ? '' : 'live',
        subBuilder: LiveInfo.$_createMessage)
    ..aOS(7, _omitFieldNames ? '' : 'uri')
    ..aOM<UserPendant>(8, _omitFieldNames ? '' : 'pendant',
        subBuilder: UserPendant.$_createMessage)
    ..aOM<Nameplate>(9, _omitFieldNames ? '' : 'nameplate',
        subBuilder: Nameplate.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserInfo copyWith(void Function(UserInfo) updates) =>
      super.copyWith((message) => updates(message as UserInfo)) as UserInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UserInfo() / UserInfo.new instead')
  static UserInfo create() => UserInfo._();
  static $pb.GeneratedMessage $_createMessage() => UserInfo._();
  @$core.override
  UserInfo createEmptyInstance() => UserInfo._();
  @$core.pragma('dart2js:noInline')
  static UserInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserInfo>(UserInfo.$_createMessage);
  static UserInfo? _defaultInstance;

  /// 用户 mid
  @$pb.TagNumber(1)
  $fixnum.Int64 get mid => $_getI64(0);
  @$pb.TagNumber(1)
  set mid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearMid() => $_clearField(1);

  /// 用户昵称
  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// 用户头像
  @$pb.TagNumber(3)
  $core.String get face => $_getSZ(2);
  @$pb.TagNumber(3)
  set face($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFace() => $_has(2);
  @$pb.TagNumber(3)
  void clearFace() => $_clearField(3);

  /// 用户认证信息
  @$pb.TagNumber(4)
  OfficialVerify get official => $_getN(3);
  @$pb.TagNumber(4)
  set official(OfficialVerify value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasOfficial() => $_has(3);
  @$pb.TagNumber(4)
  void clearOfficial() => $_clearField(4);
  @$pb.TagNumber(4)
  OfficialVerify ensureOfficial() => $_ensure(3);

  /// 用户大会员信息
  @$pb.TagNumber(5)
  VipInfo get vip => $_getN(4);
  @$pb.TagNumber(5)
  set vip(VipInfo value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasVip() => $_has(4);
  @$pb.TagNumber(5)
  void clearVip() => $_clearField(5);
  @$pb.TagNumber(5)
  VipInfo ensureVip() => $_ensure(4);

  /// 用户直播信息
  @$pb.TagNumber(6)
  LiveInfo get live => $_getN(5);
  @$pb.TagNumber(6)
  set live(LiveInfo value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLive() => $_has(5);
  @$pb.TagNumber(6)
  void clearLive() => $_clearField(6);
  @$pb.TagNumber(6)
  LiveInfo ensureLive() => $_ensure(5);

  /// 空间页跳转链接
  @$pb.TagNumber(7)
  $core.String get uri => $_getSZ(6);
  @$pb.TagNumber(7)
  set uri($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUri() => $_has(6);
  @$pb.TagNumber(7)
  void clearUri() => $_clearField(7);

  /// 挂件
  @$pb.TagNumber(8)
  UserPendant get pendant => $_getN(7);
  @$pb.TagNumber(8)
  set pendant(UserPendant value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPendant() => $_has(7);
  @$pb.TagNumber(8)
  void clearPendant() => $_clearField(8);
  @$pb.TagNumber(8)
  UserPendant ensurePendant() => $_ensure(7);

  /// 认证名牌
  @$pb.TagNumber(9)
  Nameplate get nameplate => $_getN(8);
  @$pb.TagNumber(9)
  set nameplate(Nameplate value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasNameplate() => $_has(8);
  @$pb.TagNumber(9)
  void clearNameplate() => $_clearField(9);
  @$pb.TagNumber(9)
  Nameplate ensureNameplate() => $_ensure(8);
}

/// 挂件
class UserPendant extends $pb.GeneratedMessage {
  factory UserPendant({
    $fixnum.Int64? pid,
    $core.String? name,
    $core.String? image,
    $fixnum.Int64? expire,
  }) {
    final result = UserPendant._();
    if (pid != null) result.pid = pid;
    if (name != null) result.name = name;
    if (image != null) result.image = image;
    if (expire != null) result.expire = expire;
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
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: UserPendant.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'pid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'image')
    ..aInt64(4, _omitFieldNames ? '' : 'expire')
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

  /// 挂件 ID
  @$pb.TagNumber(1)
  $fixnum.Int64 get pid => $_getI64(0);
  @$pb.TagNumber(1)
  set pid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPid() => $_has(0);
  @$pb.TagNumber(1)
  void clearPid() => $_clearField(1);

  /// 挂件名称
  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// 挂件图片
  @$pb.TagNumber(3)
  $core.String get image => $_getSZ(2);
  @$pb.TagNumber(3)
  set image($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasImage() => $_has(2);
  @$pb.TagNumber(3)
  void clearImage() => $_clearField(3);

  /// 挂件有效期
  @$pb.TagNumber(4)
  $fixnum.Int64 get expire => $_getI64(3);
  @$pb.TagNumber(4)
  set expire($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpire() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpire() => $_clearField(4);
}

/// 角标
class VideoBadge extends $pb.GeneratedMessage {
  factory VideoBadge({
    $core.String? text,
    $core.String? textColor,
    $core.String? textColorNight,
    $core.String? bgColor,
    $core.String? bgColorNight,
    $core.String? borderColor,
    $core.String? borderColorNight,
    $core.int? bgStyle,
  }) {
    final result = VideoBadge._();
    if (text != null) result.text = text;
    if (textColor != null) result.textColor = textColor;
    if (textColorNight != null) result.textColorNight = textColorNight;
    if (bgColor != null) result.bgColor = bgColor;
    if (bgColorNight != null) result.bgColorNight = bgColorNight;
    if (borderColor != null) result.borderColor = borderColor;
    if (borderColorNight != null) result.borderColorNight = borderColorNight;
    if (bgStyle != null) result.bgStyle = bgStyle;
    return result;
  }

  VideoBadge._();

  factory VideoBadge.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoBadge()..mergeFromBuffer(data, registry);
  factory VideoBadge.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoBadge()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoBadge',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: VideoBadge.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'textColor')
    ..aOS(3, _omitFieldNames ? '' : 'textColorNight')
    ..aOS(4, _omitFieldNames ? '' : 'bgColor')
    ..aOS(5, _omitFieldNames ? '' : 'bgColorNight')
    ..aOS(6, _omitFieldNames ? '' : 'borderColor')
    ..aOS(7, _omitFieldNames ? '' : 'borderColorNight')
    ..aI(8, _omitFieldNames ? '' : 'bgStyle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoBadge clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoBadge copyWith(void Function(VideoBadge) updates) =>
      super.copyWith((message) => updates(message as VideoBadge)) as VideoBadge;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use VideoBadge() / VideoBadge.new instead')
  static VideoBadge create() => VideoBadge._();
  static $pb.GeneratedMessage $_createMessage() => VideoBadge._();
  @$core.override
  VideoBadge createEmptyInstance() => VideoBadge._();
  @$core.pragma('dart2js:noInline')
  static VideoBadge getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoBadge>(VideoBadge.$_createMessage);
  static VideoBadge? _defaultInstance;

  /// 文案
  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  /// 文案文本颜色
  @$pb.TagNumber(2)
  $core.String get textColor => $_getSZ(1);
  @$pb.TagNumber(2)
  set textColor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTextColor() => $_has(1);
  @$pb.TagNumber(2)
  void clearTextColor() => $_clearField(2);

  /// 文案文本颜色 (暗黑模式下)
  @$pb.TagNumber(3)
  $core.String get textColorNight => $_getSZ(2);
  @$pb.TagNumber(3)
  set textColorNight($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTextColorNight() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextColorNight() => $_clearField(3);

  /// 背景颜色
  @$pb.TagNumber(4)
  $core.String get bgColor => $_getSZ(3);
  @$pb.TagNumber(4)
  set bgColor($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBgColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearBgColor() => $_clearField(4);

  /// 背景颜色 (暗黑模式下)
  @$pb.TagNumber(5)
  $core.String get bgColorNight => $_getSZ(4);
  @$pb.TagNumber(5)
  set bgColorNight($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBgColorNight() => $_has(4);
  @$pb.TagNumber(5)
  void clearBgColorNight() => $_clearField(5);

  /// 边框颜色
  @$pb.TagNumber(6)
  $core.String get borderColor => $_getSZ(5);
  @$pb.TagNumber(6)
  set borderColor($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBorderColor() => $_has(5);
  @$pb.TagNumber(6)
  void clearBorderColor() => $_clearField(6);

  /// 边框颜色 (暗黑模式下)
  @$pb.TagNumber(7)
  $core.String get borderColorNight => $_getSZ(6);
  @$pb.TagNumber(7)
  set borderColorNight($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBorderColorNight() => $_has(6);
  @$pb.TagNumber(7)
  void clearBorderColorNight() => $_clearField(7);

  /// 样式
  @$pb.TagNumber(8)
  $core.int get bgStyle => $_getIZ(7);
  @$pb.TagNumber(8)
  set bgStyle($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBgStyle() => $_has(7);
  @$pb.TagNumber(8)
  void clearBgStyle() => $_clearField(8);
}

/// 大会员信息
class VipInfo extends $pb.GeneratedMessage {
  factory VipInfo({
    $core.int? type,
    $core.int? status,
    $fixnum.Int64? dueDate,
    VipLabel? label,
    $core.int? themeType,
  }) {
    final result = VipInfo._();
    if (type != null) result.type = type;
    if (status != null) result.status = status;
    if (dueDate != null) result.dueDate = dueDate;
    if (label != null) result.label = label;
    if (themeType != null) result.themeType = themeType;
    return result;
  }

  VipInfo._();

  factory VipInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VipInfo()..mergeFromBuffer(data, registry);
  factory VipInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VipInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VipInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: VipInfo.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'type')
    ..aI(2, _omitFieldNames ? '' : 'status')
    ..aInt64(3, _omitFieldNames ? '' : 'dueDate')
    ..aOM<VipLabel>(4, _omitFieldNames ? '' : 'label',
        subBuilder: VipLabel.$_createMessage)
    ..aI(5, _omitFieldNames ? '' : 'themeType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VipInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VipInfo copyWith(void Function(VipInfo) updates) =>
      super.copyWith((message) => updates(message as VipInfo)) as VipInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use VipInfo() / VipInfo.new instead')
  static VipInfo create() => VipInfo._();
  static $pb.GeneratedMessage $_createMessage() => VipInfo._();
  @$core.override
  VipInfo createEmptyInstance() => VipInfo._();
  @$core.pragma('dart2js:noInline')
  static VipInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VipInfo>(VipInfo.$_createMessage);
  static VipInfo? _defaultInstance;

  /// 大会员类型
  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  /// 大会员状态
  @$pb.TagNumber(2)
  $core.int get status => $_getIZ(1);
  @$pb.TagNumber(2)
  set status($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  /// 大会员过期时间
  @$pb.TagNumber(3)
  $fixnum.Int64 get dueDate => $_getI64(2);
  @$pb.TagNumber(3)
  set dueDate($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDueDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearDueDate() => $_clearField(3);

  /// 大会员标签
  @$pb.TagNumber(4)
  VipLabel get label => $_getN(3);
  @$pb.TagNumber(4)
  set label(VipLabel value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLabel() => $_has(3);
  @$pb.TagNumber(4)
  void clearLabel() => $_clearField(4);
  @$pb.TagNumber(4)
  VipLabel ensureLabel() => $_ensure(3);

  /// 大会员主题
  @$pb.TagNumber(5)
  $core.int get themeType => $_getIZ(4);
  @$pb.TagNumber(5)
  set themeType($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasThemeType() => $_has(4);
  @$pb.TagNumber(5)
  void clearThemeType() => $_clearField(5);
}

/// 大会员标签
class VipLabel extends $pb.GeneratedMessage {
  factory VipLabel({
    $core.String? path,
  }) {
    final result = VipLabel._();
    if (path != null) result.path = path;
    return result;
  }

  VipLabel._();

  factory VipLabel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VipLabel()..mergeFromBuffer(data, registry);
  factory VipLabel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VipLabel()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VipLabel',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: VipLabel.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VipLabel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VipLabel copyWith(void Function(VipLabel) updates) =>
      super.copyWith((message) => updates(message as VipLabel)) as VipLabel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use VipLabel() / VipLabel.new instead')
  static VipLabel create() => VipLabel._();
  static $pb.GeneratedMessage $_createMessage() => VipLabel._();
  @$core.override
  VipLabel createEmptyInstance() => VipLabel._();
  @$core.pragma('dart2js:noInline')
  static VipLabel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VipLabel>(VipLabel.$_createMessage);
  static VipLabel? _defaultInstance;

  /// 图片地址
  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
