// This is a generated file - do not edit.
//
// Generated from bilibili/metadata/locale.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Locale extends $pb.GeneratedMessage {
  factory Locale({
    LocaleIds? cLocale,
    LocaleIds? sLocale,
    $core.String? simCode,
    $core.String? timezone,
    $core.String? utcOffset,
    $core.bool? isDaylightTime,
    $core.bool? alwaysTranslate,
  }) {
    final result = Locale._();
    if (cLocale != null) result.cLocale = cLocale;
    if (sLocale != null) result.sLocale = sLocale;
    if (simCode != null) result.simCode = simCode;
    if (timezone != null) result.timezone = timezone;
    if (utcOffset != null) result.utcOffset = utcOffset;
    if (isDaylightTime != null) result.isDaylightTime = isDaylightTime;
    if (alwaysTranslate != null) result.alwaysTranslate = alwaysTranslate;
    return result;
  }

  Locale._();

  factory Locale.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Locale()..mergeFromBuffer(data, registry);
  factory Locale.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Locale()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Locale',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.metadata.locale'),
      createEmptyInstance: Locale.$_createMessage)
    ..aOM<LocaleIds>(1, _omitFieldNames ? '' : 'cLocale',
        subBuilder: LocaleIds.$_createMessage)
    ..aOM<LocaleIds>(2, _omitFieldNames ? '' : 'sLocale',
        subBuilder: LocaleIds.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'simCode')
    ..aOS(4, _omitFieldNames ? '' : 'timezone')
    ..aOS(5, _omitFieldNames ? '' : 'utcOffset')
    ..aOB(6, _omitFieldNames ? '' : 'isDaylightTime')
    ..aOB(7, _omitFieldNames ? '' : 'alwaysTranslate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Locale clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Locale copyWith(void Function(Locale) updates) =>
      super.copyWith((message) => updates(message as Locale)) as Locale;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Locale() / Locale.new instead')
  static Locale create() => Locale._();
  static $pb.GeneratedMessage $_createMessage() => Locale._();
  @$core.override
  Locale createEmptyInstance() => Locale._();
  @$core.pragma('dart2js:noInline')
  static Locale getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Locale>(Locale.$_createMessage);
  static Locale? _defaultInstance;

  @$pb.TagNumber(1)
  LocaleIds get cLocale => $_getN(0);
  @$pb.TagNumber(1)
  set cLocale(LocaleIds value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCLocale() => $_has(0);
  @$pb.TagNumber(1)
  void clearCLocale() => $_clearField(1);
  @$pb.TagNumber(1)
  LocaleIds ensureCLocale() => $_ensure(0);

  @$pb.TagNumber(2)
  LocaleIds get sLocale => $_getN(1);
  @$pb.TagNumber(2)
  set sLocale(LocaleIds value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSLocale() => $_has(1);
  @$pb.TagNumber(2)
  void clearSLocale() => $_clearField(2);
  @$pb.TagNumber(2)
  LocaleIds ensureSLocale() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get simCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set simCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSimCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearSimCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get timezone => $_getSZ(3);
  @$pb.TagNumber(4)
  set timezone($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTimezone() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimezone() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get utcOffset => $_getSZ(4);
  @$pb.TagNumber(5)
  set utcOffset($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUtcOffset() => $_has(4);
  @$pb.TagNumber(5)
  void clearUtcOffset() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isDaylightTime => $_getBF(5);
  @$pb.TagNumber(6)
  set isDaylightTime($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsDaylightTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsDaylightTime() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get alwaysTranslate => $_getBF(6);
  @$pb.TagNumber(7)
  set alwaysTranslate($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAlwaysTranslate() => $_has(6);
  @$pb.TagNumber(7)
  void clearAlwaysTranslate() => $_clearField(7);
}

class LocaleIds extends $pb.GeneratedMessage {
  factory LocaleIds({
    $core.String? language,
    $core.String? script,
    $core.String? region,
  }) {
    final result = LocaleIds._();
    if (language != null) result.language = language;
    if (script != null) result.script = script;
    if (region != null) result.region = region;
    return result;
  }

  LocaleIds._();

  factory LocaleIds.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LocaleIds()..mergeFromBuffer(data, registry);
  factory LocaleIds.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LocaleIds()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LocaleIds',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.metadata.locale'),
      createEmptyInstance: LocaleIds.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'language')
    ..aOS(2, _omitFieldNames ? '' : 'script')
    ..aOS(3, _omitFieldNames ? '' : 'region')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LocaleIds clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LocaleIds copyWith(void Function(LocaleIds) updates) =>
      super.copyWith((message) => updates(message as LocaleIds)) as LocaleIds;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LocaleIds() / LocaleIds.new instead')
  static LocaleIds create() => LocaleIds._();
  static $pb.GeneratedMessage $_createMessage() => LocaleIds._();
  @$core.override
  LocaleIds createEmptyInstance() => LocaleIds._();
  @$core.pragma('dart2js:noInline')
  static LocaleIds getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LocaleIds>(LocaleIds.$_createMessage);
  static LocaleIds? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get language => $_getSZ(0);
  @$pb.TagNumber(1)
  set language($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLanguage() => $_has(0);
  @$pb.TagNumber(1)
  void clearLanguage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get script => $_getSZ(1);
  @$pb.TagNumber(2)
  set script($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScript() => $_has(1);
  @$pb.TagNumber(2)
  void clearScript() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get region => $_getSZ(2);
  @$pb.TagNumber(3)
  set region($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRegion() => $_has(2);
  @$pb.TagNumber(3)
  void clearRegion() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
