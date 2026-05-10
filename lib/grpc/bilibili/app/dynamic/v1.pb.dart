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

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// 动态红点返回值
class DynRedReply extends $pb.GeneratedMessage {
  factory DynRedReply({
    DynRedItem? dynRedItem,
  }) {
    final result = create();
    if (dynRedItem != null) result.dynRedItem = dynRedItem;
    return result;
  }

  DynRedReply._();

  factory DynRedReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DynRedReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynRedReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: create)
    ..aOM<DynRedItem>(2, _omitFieldNames ? '' : 'dynRedItem',
        subBuilder: DynRedItem.create)
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
  static DynRedReply create() => DynRedReply._();
  @$core.override
  DynRedReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DynRedReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DynRedReply>(create);
  static DynRedReply? _defaultInstance;

  /// 动态红点具体信息, 参见 [`DynRedItem`]
  @$pb.TagNumber(2)
  DynRedItem get dynRedItem => $_getN(0);
  @$pb.TagNumber(2)
  set dynRedItem(DynRedItem value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDynRedItem() => $_has(0);
  @$pb.TagNumber(2)
  void clearDynRedItem() => $_clearField(2);
  @$pb.TagNumber(2)
  DynRedItem ensureDynRedItem() => $_ensure(0);
}

/// 动态红点请求参数
class DynRedReq extends $pb.GeneratedMessage {
  factory DynRedReq({
    $core.Iterable<TabOffset>? tabOffset,
  }) {
    final result = create();
    if (tabOffset != null) result.tabOffset.addAll(tabOffset);
    return result;
  }

  DynRedReq._();

  factory DynRedReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DynRedReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynRedReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: create)
    ..pPM<TabOffset>(1, _omitFieldNames ? '' : 'tabOffset',
        subBuilder: TabOffset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynRedReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynRedReq copyWith(void Function(DynRedReq) updates) =>
      super.copyWith((message) => updates(message as DynRedReq)) as DynRedReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DynRedReq create() => DynRedReq._();
  @$core.override
  DynRedReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DynRedReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DynRedReq>(create);
  static DynRedReq? _defaultInstance;

  /// 参见 [`TabOffset`]
  @$pb.TagNumber(1)
  $pb.PbList<TabOffset> get tabOffset => $_getList(0);
}

/// 红点具体信息
class DynRedItem extends $pb.GeneratedMessage {
  factory DynRedItem({
    $fixnum.Int64? count,
  }) {
    final result = create();
    if (count != null) result.count = count;
    return result;
  }

  DynRedItem._();

  factory DynRedItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DynRedItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynRedItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: create)
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
  static DynRedItem create() => DynRedItem._();
  @$core.override
  DynRedItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DynRedItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DynRedItem>(create);
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

/// 动态红点接口各 tab offset 信息
class TabOffset extends $pb.GeneratedMessage {
  factory TabOffset({
    $core.int? tab,
    $core.String? offset,
  }) {
    final result = create();
    if (tab != null) result.tab = tab;
    if (offset != null) result.offset = offset;
    return result;
  }

  TabOffset._();

  factory TabOffset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TabOffset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TabOffset',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.v1'),
      createEmptyInstance: create)
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
  static TabOffset create() => TabOffset._();
  @$core.override
  TabOffset createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TabOffset getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TabOffset>(create);
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

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
