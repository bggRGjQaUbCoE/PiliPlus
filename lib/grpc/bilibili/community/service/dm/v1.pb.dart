// This is a generated file - do not edit.
//
// Generated from bilibili/community/service/dm/v1.proto.

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

class DanmakuElem extends $pb.GeneratedMessage {
  factory DanmakuElem({
    $fixnum.Int64? id,
    $core.int? progress,
    $core.int? mode,
    $core.int? fontsize,
    $core.int? color,
    $core.String? midHash,
    $core.String? content,
    $core.int? weight,
    $core.String? action,
    $fixnum.Int64? likeCount,
    DmColorfulType? colorful,
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
    if (weight != null) result.weight = weight;
    if (action != null) result.action = action;
    if (likeCount != null) result.likeCount = likeCount;
    if (colorful != null) result.colorful = colorful;
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
    ..aI(9, _omitFieldNames ? '' : 'weight')
    ..aOS(10, _omitFieldNames ? '' : 'action')
    ..aInt64(15, _omitFieldNames ? '' : 'likeCount')
    ..aE<DmColorfulType>(24, _omitFieldNames ? '' : 'colorful',
        enumValues: DmColorfulType.values)
    ..aI(100, _omitFieldNames ? '' : 'count')
    ..aOB(101, _omitFieldNames ? '' : 'isSelf')
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

  @$pb.TagNumber(9)
  $core.int get weight => $_getIZ(7);
  @$pb.TagNumber(9)
  set weight($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(9)
  $core.bool hasWeight() => $_has(7);
  @$pb.TagNumber(9)
  void clearWeight() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get action => $_getSZ(8);
  @$pb.TagNumber(10)
  set action($core.String value) => $_setString(8, value);
  @$pb.TagNumber(10)
  $core.bool hasAction() => $_has(8);
  @$pb.TagNumber(10)
  void clearAction() => $_clearField(10);

  @$pb.TagNumber(15)
  $fixnum.Int64 get likeCount => $_getI64(9);
  @$pb.TagNumber(15)
  set likeCount($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(15)
  $core.bool hasLikeCount() => $_has(9);
  @$pb.TagNumber(15)
  void clearLikeCount() => $_clearField(15);

  @$pb.TagNumber(24)
  DmColorfulType get colorful => $_getN(10);
  @$pb.TagNumber(24)
  set colorful(DmColorfulType value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasColorful() => $_has(10);
  @$pb.TagNumber(24)
  void clearColorful() => $_clearField(24);

  /// extra field
  @$pb.TagNumber(100)
  $core.int get count => $_getIZ(11);
  @$pb.TagNumber(100)
  set count($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(100)
  $core.bool hasCount() => $_has(11);
  @$pb.TagNumber(100)
  void clearCount() => $_clearField(100);

  /// extra field
  @$pb.TagNumber(101)
  $core.bool get isSelf => $_getBF(12);
  @$pb.TagNumber(101)
  set isSelf($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(101)
  $core.bool hasIsSelf() => $_has(12);
  @$pb.TagNumber(101)
  void clearIsSelf() => $_clearField(101);
}

class DmSegMobileReply extends $pb.GeneratedMessage {
  factory DmSegMobileReply({
    $core.Iterable<DanmakuElem>? elems,
    $core.int? state,
  }) {
    final result = create();
    if (elems != null) result.elems.addAll(elems);
    if (state != null) result.state = state;
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
}

class DmSegMobileReq extends $pb.GeneratedMessage {
  factory DmSegMobileReq({
    $fixnum.Int64? oid,
    $core.int? type,
    $fixnum.Int64? segmentIndex,
  }) {
    final result = create();
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    if (segmentIndex != null) result.segmentIndex = segmentIndex;
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
    ..aInt64(2, _omitFieldNames ? '' : 'oid')
    ..aI(3, _omitFieldNames ? '' : 'type')
    ..aInt64(4, _omitFieldNames ? '' : 'segmentIndex')
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
  @$core.pragma('dart2js:noInline')
  static DmSegMobileReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmSegMobileReq>(create);
  static DmSegMobileReq? _defaultInstance;

  @$pb.TagNumber(2)
  $fixnum.Int64 get oid => $_getI64(0);
  @$pb.TagNumber(2)
  set oid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(0);
  @$pb.TagNumber(2)
  void clearOid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get type => $_getIZ(1);
  @$pb.TagNumber(3)
  set type($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get segmentIndex => $_getI64(2);
  @$pb.TagNumber(4)
  set segmentIndex($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(4)
  $core.bool hasSegmentIndex() => $_has(2);
  @$pb.TagNumber(4)
  void clearSegmentIndex() => $_clearField(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
