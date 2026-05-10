// This is a generated file - do not edit.
//
// Generated from bilibili/app/interfaces/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../archive/v1.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Arc extends $pb.GeneratedMessage {
  factory Arc({
    $1.Arc? archive,
    $core.String? uri,
    $core.String? viewContent,
    $core.String? coverIcon,
    $core.bool? isPugv,
    $core.String? publishTimeText,
    $core.Iterable<$core.String>? badges,
  }) {
    final result = create();
    if (archive != null) result.archive = archive;
    if (uri != null) result.uri = uri;
    if (viewContent != null) result.viewContent = viewContent;
    if (coverIcon != null) result.coverIcon = coverIcon;
    if (isPugv != null) result.isPugv = isPugv;
    if (publishTimeText != null) result.publishTimeText = publishTimeText;
    if (badges != null) result.badges.addAll(badges);
    return result;
  }

  Arc._();

  factory Arc.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Arc.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Arc',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Arc>(1, _omitFieldNames ? '' : 'archive',
        subBuilder: $1.Arc.create)
    ..aOS(2, _omitFieldNames ? '' : 'uri')
    ..aOS(3, _omitFieldNames ? '' : 'viewContent')
    ..aOS(5, _omitFieldNames ? '' : 'coverIcon')
    ..aOB(7, _omitFieldNames ? '' : 'isPugv')
    ..aOS(8, _omitFieldNames ? '' : 'publishTimeText')
    ..pPS(9, _omitFieldNames ? '' : 'badges')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Arc clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Arc copyWith(void Function(Arc) updates) =>
      super.copyWith((message) => updates(message as Arc)) as Arc;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Arc create() => Arc._();
  @$core.override
  Arc createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Arc getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Arc>(create);
  static Arc? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Arc get archive => $_getN(0);
  @$pb.TagNumber(1)
  set archive($1.Arc value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArchive() => $_has(0);
  @$pb.TagNumber(1)
  void clearArchive() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Arc ensureArchive() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get uri => $_getSZ(1);
  @$pb.TagNumber(2)
  set uri($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearUri() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get viewContent => $_getSZ(2);
  @$pb.TagNumber(3)
  set viewContent($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasViewContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearViewContent() => $_clearField(3);

  @$pb.TagNumber(5)
  $core.String get coverIcon => $_getSZ(3);
  @$pb.TagNumber(5)
  set coverIcon($core.String value) => $_setString(3, value);
  @$pb.TagNumber(5)
  $core.bool hasCoverIcon() => $_has(3);
  @$pb.TagNumber(5)
  void clearCoverIcon() => $_clearField(5);

  @$pb.TagNumber(7)
  $core.bool get isPugv => $_getBF(4);
  @$pb.TagNumber(7)
  set isPugv($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(7)
  $core.bool hasIsPugv() => $_has(4);
  @$pb.TagNumber(7)
  void clearIsPugv() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get publishTimeText => $_getSZ(5);
  @$pb.TagNumber(8)
  set publishTimeText($core.String value) => $_setString(5, value);
  @$pb.TagNumber(8)
  $core.bool hasPublishTimeText() => $_has(5);
  @$pb.TagNumber(8)
  void clearPublishTimeText() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get badges => $_getList(6);
}

class SearchArchiveReply extends $pb.GeneratedMessage {
  factory SearchArchiveReply({
    $core.Iterable<Arc>? archives,
    $fixnum.Int64? total,
  }) {
    final result = create();
    if (archives != null) result.archives.addAll(archives);
    if (total != null) result.total = total;
    return result;
  }

  SearchArchiveReply._();

  factory SearchArchiveReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchArchiveReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchArchiveReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..pPM<Arc>(1, _omitFieldNames ? '' : 'archives', subBuilder: Arc.create)
    ..aInt64(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchArchiveReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchArchiveReply copyWith(void Function(SearchArchiveReply) updates) =>
      super.copyWith((message) => updates(message as SearchArchiveReply))
          as SearchArchiveReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchArchiveReply create() => SearchArchiveReply._();
  @$core.override
  SearchArchiveReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchArchiveReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchArchiveReply>(create);
  static SearchArchiveReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Arc> get archives => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class SearchArchiveReq extends $pb.GeneratedMessage {
  factory SearchArchiveReq({
    $core.String? keyword,
    $fixnum.Int64? mid,
    $fixnum.Int64? pn,
    $fixnum.Int64? ps,
  }) {
    final result = create();
    if (keyword != null) result.keyword = keyword;
    if (mid != null) result.mid = mid;
    if (pn != null) result.pn = pn;
    if (ps != null) result.ps = ps;
    return result;
  }

  SearchArchiveReq._();

  factory SearchArchiveReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchArchiveReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchArchiveReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..aInt64(2, _omitFieldNames ? '' : 'mid')
    ..aInt64(3, _omitFieldNames ? '' : 'pn')
    ..aInt64(4, _omitFieldNames ? '' : 'ps')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchArchiveReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchArchiveReq copyWith(void Function(SearchArchiveReq) updates) =>
      super.copyWith((message) => updates(message as SearchArchiveReq))
          as SearchArchiveReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchArchiveReq create() => SearchArchiveReq._();
  @$core.override
  SearchArchiveReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchArchiveReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchArchiveReq>(create);
  static SearchArchiveReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get mid => $_getI64(1);
  @$pb.TagNumber(2)
  set mid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMid() => $_has(1);
  @$pb.TagNumber(2)
  void clearMid() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get pn => $_getI64(2);
  @$pb.TagNumber(3)
  set pn($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPn() => $_has(2);
  @$pb.TagNumber(3)
  void clearPn() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get ps => $_getI64(3);
  @$pb.TagNumber(4)
  set ps($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPs() => $_has(3);
  @$pb.TagNumber(4)
  void clearPs() => $_clearField(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
