// This is a generated file - do not edit.
//
// Generated from bilibili/pagination.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class FeedPagination extends $pb.GeneratedMessage {
  factory FeedPagination({
    $core.int? pageSize,
    $core.String? offset,
    $core.bool? isRefresh,
  }) {
    final result = FeedPagination._();
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    if (isRefresh != null) result.isRefresh = isRefresh;
    return result;
  }

  FeedPagination._();

  factory FeedPagination.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeedPagination()..mergeFromBuffer(data, registry);
  factory FeedPagination.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeedPagination()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FeedPagination',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.pagination'),
      createEmptyInstance: FeedPagination.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..aOS(2, _omitFieldNames ? '' : 'offset')
    ..aOB(3, _omitFieldNames ? '' : 'isRefresh')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeedPagination clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeedPagination copyWith(void Function(FeedPagination) updates) =>
      super.copyWith((message) => updates(message as FeedPagination))
          as FeedPagination;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FeedPagination() / FeedPagination.new instead')
  static FeedPagination create() => FeedPagination._();
  static $pb.GeneratedMessage $_createMessage() => FeedPagination._();
  @$core.override
  FeedPagination createEmptyInstance() => FeedPagination._();
  @$core.pragma('dart2js:noInline')
  static FeedPagination getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeedPagination>(
          FeedPagination.$_createMessage);
  static FeedPagination? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get offset => $_getSZ(1);
  @$pb.TagNumber(2)
  set offset($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isRefresh => $_getBF(2);
  @$pb.TagNumber(3)
  set isRefresh($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsRefresh() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsRefresh() => $_clearField(3);
}

class FeedPaginationReply extends $pb.GeneratedMessage {
  factory FeedPaginationReply({
    $core.String? nextOffset,
    $core.String? prevOffset,
    $core.String? lastReadOffset,
  }) {
    final result = FeedPaginationReply._();
    if (nextOffset != null) result.nextOffset = nextOffset;
    if (prevOffset != null) result.prevOffset = prevOffset;
    if (lastReadOffset != null) result.lastReadOffset = lastReadOffset;
    return result;
  }

  FeedPaginationReply._();

  factory FeedPaginationReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeedPaginationReply()..mergeFromBuffer(data, registry);
  factory FeedPaginationReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FeedPaginationReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FeedPaginationReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.pagination'),
      createEmptyInstance: FeedPaginationReply.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'nextOffset')
    ..aOS(2, _omitFieldNames ? '' : 'prevOffset')
    ..aOS(3, _omitFieldNames ? '' : 'lastReadOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeedPaginationReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FeedPaginationReply copyWith(void Function(FeedPaginationReply) updates) =>
      super.copyWith((message) => updates(message as FeedPaginationReply))
          as FeedPaginationReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use FeedPaginationReply() / FeedPaginationReply.new instead')
  static FeedPaginationReply create() => FeedPaginationReply._();
  static $pb.GeneratedMessage $_createMessage() => FeedPaginationReply._();
  @$core.override
  FeedPaginationReply createEmptyInstance() => FeedPaginationReply._();
  @$core.pragma('dart2js:noInline')
  static FeedPaginationReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FeedPaginationReply>(
          FeedPaginationReply.$_createMessage);
  static FeedPaginationReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nextOffset => $_getSZ(0);
  @$pb.TagNumber(1)
  set nextOffset($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNextOffset() => $_has(0);
  @$pb.TagNumber(1)
  void clearNextOffset() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get prevOffset => $_getSZ(1);
  @$pb.TagNumber(2)
  set prevOffset($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrevOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrevOffset() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get lastReadOffset => $_getSZ(2);
  @$pb.TagNumber(3)
  set lastReadOffset($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLastReadOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearLastReadOffset() => $_clearField(3);
}

class Pagination extends $pb.GeneratedMessage {
  factory Pagination({
    $core.int? pageSize,
    $core.String? next,
  }) {
    final result = Pagination._();
    if (pageSize != null) result.pageSize = pageSize;
    if (next != null) result.next = next;
    return result;
  }

  Pagination._();

  factory Pagination.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Pagination()..mergeFromBuffer(data, registry);
  factory Pagination.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Pagination()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Pagination',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.pagination'),
      createEmptyInstance: Pagination.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..aOS(2, _omitFieldNames ? '' : 'next')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Pagination clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Pagination copyWith(void Function(Pagination) updates) =>
      super.copyWith((message) => updates(message as Pagination)) as Pagination;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Pagination() / Pagination.new instead')
  static Pagination create() => Pagination._();
  static $pb.GeneratedMessage $_createMessage() => Pagination._();
  @$core.override
  Pagination createEmptyInstance() => Pagination._();
  @$core.pragma('dart2js:noInline')
  static Pagination getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Pagination>(Pagination.$_createMessage);
  static Pagination? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get next => $_getSZ(1);
  @$pb.TagNumber(2)
  set next($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNext() => $_has(1);
  @$pb.TagNumber(2)
  void clearNext() => $_clearField(2);
}

class PaginationReply extends $pb.GeneratedMessage {
  factory PaginationReply({
    $core.String? next,
    $core.String? prev,
  }) {
    final result = PaginationReply._();
    if (next != null) result.next = next;
    if (prev != null) result.prev = prev;
    return result;
  }

  PaginationReply._();

  factory PaginationReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaginationReply()..mergeFromBuffer(data, registry);
  factory PaginationReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaginationReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaginationReply',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'bilibili.pagination'),
      createEmptyInstance: PaginationReply.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'next')
    ..aOS(2, _omitFieldNames ? '' : 'prev')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaginationReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaginationReply copyWith(void Function(PaginationReply) updates) =>
      super.copyWith((message) => updates(message as PaginationReply))
          as PaginationReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PaginationReply() / PaginationReply.new instead')
  static PaginationReply create() => PaginationReply._();
  static $pb.GeneratedMessage $_createMessage() => PaginationReply._();
  @$core.override
  PaginationReply createEmptyInstance() => PaginationReply._();
  @$core.pragma('dart2js:noInline')
  static PaginationReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaginationReply>(
          PaginationReply.$_createMessage);
  static PaginationReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get next => $_getSZ(0);
  @$pb.TagNumber(1)
  set next($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNext() => $_has(0);
  @$pb.TagNumber(1)
  void clearNext() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get prev => $_getSZ(1);
  @$pb.TagNumber(2)
  set prev($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrev() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrev() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
