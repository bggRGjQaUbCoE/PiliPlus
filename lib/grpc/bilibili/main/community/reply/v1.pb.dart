// This is a generated file - do not edit.
//
// Generated from bilibili/main/community/reply/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../../pagination.pb.dart' as $1;
import 'v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'v1.pbenum.dart';

class ArticleSearchItem extends $pb.GeneratedMessage {
  factory ArticleSearchItem({
    $core.String? title,
    $core.String? upNickname,
    $core.Iterable<$core.String>? covers,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (upNickname != null) result.upNickname = upNickname;
    if (covers != null) result.covers.addAll(covers);
    return result;
  }

  ArticleSearchItem._();

  factory ArticleSearchItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ArticleSearchItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArticleSearchItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'upNickname')
    ..pPS(3, _omitFieldNames ? '' : 'covers')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArticleSearchItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArticleSearchItem copyWith(void Function(ArticleSearchItem) updates) =>
      super.copyWith((message) => updates(message as ArticleSearchItem))
          as ArticleSearchItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ArticleSearchItem create() => ArticleSearchItem._();
  @$core.override
  ArticleSearchItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ArticleSearchItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ArticleSearchItem>(create);
  static ArticleSearchItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get upNickname => $_getSZ(1);
  @$pb.TagNumber(2)
  set upNickname($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUpNickname() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpNickname() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get covers => $_getList(2);
}

class Content extends $pb.GeneratedMessage {
  factory Content({
    $core.String? message,
    $core.Iterable<$core.MapEntry<$core.String, Emote>>? emotes,
    $core.Iterable<$core.MapEntry<$core.String, Topic>>? topics,
    $core.Iterable<$core.MapEntry<$core.String, Url>>? urls,
    Vote? vote,
    $core.Iterable<$core.MapEntry<$core.String, $fixnum.Int64>>? atNameToMid,
    RichText? richText,
    $core.Iterable<Picture>? pictures,
  }) {
    final result = create();
    if (message != null) result.message = message;
    if (emotes != null) result.emotes.addEntries(emotes);
    if (topics != null) result.topics.addEntries(topics);
    if (urls != null) result.urls.addEntries(urls);
    if (vote != null) result.vote = vote;
    if (atNameToMid != null) result.atNameToMid.addEntries(atNameToMid);
    if (richText != null) result.richText = richText;
    if (pictures != null) result.pictures.addAll(pictures);
    return result;
  }

  Content._();

  factory Content.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Content.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Content',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..m<$core.String, Emote>(3, _omitFieldNames ? '' : 'emotes',
        entryClassName: 'Content.EmotesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: Emote.create,
        valueDefaultOrMaker: Emote.getDefault,
        packageName: const $pb.PackageName('bilibili.main.community.reply.v1'))
    ..m<$core.String, Topic>(4, _omitFieldNames ? '' : 'topics',
        entryClassName: 'Content.TopicsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: Topic.create,
        valueDefaultOrMaker: Topic.getDefault,
        packageName: const $pb.PackageName('bilibili.main.community.reply.v1'))
    ..m<$core.String, Url>(5, _omitFieldNames ? '' : 'urls',
        entryClassName: 'Content.UrlsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: Url.create,
        valueDefaultOrMaker: Url.getDefault,
        packageName: const $pb.PackageName('bilibili.main.community.reply.v1'))
    ..aOM<Vote>(6, _omitFieldNames ? '' : 'vote', subBuilder: Vote.create)
    ..m<$core.String, $fixnum.Int64>(7, _omitFieldNames ? '' : 'atNameToMid',
        entryClassName: 'Content.AtNameToMidEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O6,
        packageName: const $pb.PackageName('bilibili.main.community.reply.v1'))
    ..aOM<RichText>(8, _omitFieldNames ? '' : 'richText',
        subBuilder: RichText.create)
    ..pPM<Picture>(9, _omitFieldNames ? '' : 'pictures',
        subBuilder: Picture.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Content clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Content copyWith(void Function(Content) updates) =>
      super.copyWith((message) => updates(message as Content)) as Content;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Content create() => Content._();
  @$core.override
  Content createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Content getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Content>(create);
  static Content? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, Emote> get emotes => $_getMap(1);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, Topic> get topics => $_getMap(2);

  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, Url> get urls => $_getMap(3);

  @$pb.TagNumber(6)
  Vote get vote => $_getN(4);
  @$pb.TagNumber(6)
  set vote(Vote value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasVote() => $_has(4);
  @$pb.TagNumber(6)
  void clearVote() => $_clearField(6);
  @$pb.TagNumber(6)
  Vote ensureVote() => $_ensure(4);

  @$pb.TagNumber(7)
  $pb.PbMap<$core.String, $fixnum.Int64> get atNameToMid => $_getMap(5);

  @$pb.TagNumber(8)
  RichText get richText => $_getN(6);
  @$pb.TagNumber(8)
  set richText(RichText value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRichText() => $_has(6);
  @$pb.TagNumber(8)
  void clearRichText() => $_clearField(8);
  @$pb.TagNumber(8)
  RichText ensureRichText() => $_ensure(6);

  @$pb.TagNumber(9)
  $pb.PbList<Picture> get pictures => $_getList(7);
}

class CursorReply extends $pb.GeneratedMessage {
  factory CursorReply({
    $fixnum.Int64? next,
    $fixnum.Int64? prev,
    $core.bool? isBegin,
    $core.bool? isEnd,
    Mode? mode,
    $core.String? modeText,
  }) {
    final result = create();
    if (next != null) result.next = next;
    if (prev != null) result.prev = prev;
    if (isBegin != null) result.isBegin = isBegin;
    if (isEnd != null) result.isEnd = isEnd;
    if (mode != null) result.mode = mode;
    if (modeText != null) result.modeText = modeText;
    return result;
  }

  CursorReply._();

  factory CursorReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CursorReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CursorReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'next')
    ..aInt64(2, _omitFieldNames ? '' : 'prev')
    ..aOB(3, _omitFieldNames ? '' : 'isBegin')
    ..aOB(4, _omitFieldNames ? '' : 'isEnd')
    ..aE<Mode>(5, _omitFieldNames ? '' : 'mode', enumValues: Mode.values)
    ..aOS(6, _omitFieldNames ? '' : 'modeText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CursorReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CursorReply copyWith(void Function(CursorReply) updates) =>
      super.copyWith((message) => updates(message as CursorReply))
          as CursorReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CursorReply create() => CursorReply._();
  @$core.override
  CursorReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CursorReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CursorReply>(create);
  static CursorReply? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get next => $_getI64(0);
  @$pb.TagNumber(1)
  set next($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNext() => $_has(0);
  @$pb.TagNumber(1)
  void clearNext() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get prev => $_getI64(1);
  @$pb.TagNumber(2)
  set prev($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrev() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrev() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isBegin => $_getBF(2);
  @$pb.TagNumber(3)
  set isBegin($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsBegin() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsBegin() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isEnd => $_getBF(3);
  @$pb.TagNumber(4)
  set isEnd($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsEnd() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsEnd() => $_clearField(4);

  @$pb.TagNumber(5)
  Mode get mode => $_getN(4);
  @$pb.TagNumber(5)
  set mode(Mode value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMode() => $_has(4);
  @$pb.TagNumber(5)
  void clearMode() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get modeText => $_getSZ(5);
  @$pb.TagNumber(6)
  set modeText($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasModeText() => $_has(5);
  @$pb.TagNumber(6)
  void clearModeText() => $_clearField(6);
}

class CursorReq extends $pb.GeneratedMessage {
  factory CursorReq({
    $fixnum.Int64? next,
    $fixnum.Int64? prev,
    Mode? mode,
  }) {
    final result = create();
    if (next != null) result.next = next;
    if (prev != null) result.prev = prev;
    if (mode != null) result.mode = mode;
    return result;
  }

  CursorReq._();

  factory CursorReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CursorReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CursorReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'next')
    ..aInt64(2, _omitFieldNames ? '' : 'prev')
    ..aE<Mode>(4, _omitFieldNames ? '' : 'mode', enumValues: Mode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CursorReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CursorReq copyWith(void Function(CursorReq) updates) =>
      super.copyWith((message) => updates(message as CursorReq)) as CursorReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CursorReq create() => CursorReq._();
  @$core.override
  CursorReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CursorReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CursorReq>(create);
  static CursorReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get next => $_getI64(0);
  @$pb.TagNumber(1)
  set next($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNext() => $_has(0);
  @$pb.TagNumber(1)
  void clearNext() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get prev => $_getI64(1);
  @$pb.TagNumber(2)
  set prev($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrev() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrev() => $_clearField(2);

  @$pb.TagNumber(4)
  Mode get mode => $_getN(2);
  @$pb.TagNumber(4)
  set mode(Mode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMode() => $_has(2);
  @$pb.TagNumber(4)
  void clearMode() => $_clearField(4);
}

class DetailListReply extends $pb.GeneratedMessage {
  factory DetailListReply({
    CursorReply? cursor,
    SubjectControl? subjectControl,
    ReplyInfo? root,
    Mode? mode,
    $core.String? modeText,
    $1.FeedPaginationReply? paginationReply,
    $core.String? sessionId,
  }) {
    final result = create();
    if (cursor != null) result.cursor = cursor;
    if (subjectControl != null) result.subjectControl = subjectControl;
    if (root != null) result.root = root;
    if (mode != null) result.mode = mode;
    if (modeText != null) result.modeText = modeText;
    if (paginationReply != null) result.paginationReply = paginationReply;
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  DetailListReply._();

  factory DetailListReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DetailListReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DetailListReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOM<CursorReply>(1, _omitFieldNames ? '' : 'cursor',
        subBuilder: CursorReply.create)
    ..aOM<SubjectControl>(2, _omitFieldNames ? '' : 'subjectControl',
        subBuilder: SubjectControl.create)
    ..aOM<ReplyInfo>(3, _omitFieldNames ? '' : 'root',
        subBuilder: ReplyInfo.create)
    ..aE<Mode>(6, _omitFieldNames ? '' : 'mode', enumValues: Mode.values)
    ..aOS(7, _omitFieldNames ? '' : 'modeText')
    ..aOM<$1.FeedPaginationReply>(8, _omitFieldNames ? '' : 'paginationReply',
        subBuilder: $1.FeedPaginationReply.create)
    ..aOS(9, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DetailListReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DetailListReply copyWith(void Function(DetailListReply) updates) =>
      super.copyWith((message) => updates(message as DetailListReply))
          as DetailListReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DetailListReply create() => DetailListReply._();
  @$core.override
  DetailListReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DetailListReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DetailListReply>(create);
  static DetailListReply? _defaultInstance;

  @$pb.TagNumber(1)
  CursorReply get cursor => $_getN(0);
  @$pb.TagNumber(1)
  set cursor(CursorReply value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCursor() => $_has(0);
  @$pb.TagNumber(1)
  void clearCursor() => $_clearField(1);
  @$pb.TagNumber(1)
  CursorReply ensureCursor() => $_ensure(0);

  @$pb.TagNumber(2)
  SubjectControl get subjectControl => $_getN(1);
  @$pb.TagNumber(2)
  set subjectControl(SubjectControl value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSubjectControl() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubjectControl() => $_clearField(2);
  @$pb.TagNumber(2)
  SubjectControl ensureSubjectControl() => $_ensure(1);

  @$pb.TagNumber(3)
  ReplyInfo get root => $_getN(2);
  @$pb.TagNumber(3)
  set root(ReplyInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRoot() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoot() => $_clearField(3);
  @$pb.TagNumber(3)
  ReplyInfo ensureRoot() => $_ensure(2);

  @$pb.TagNumber(6)
  Mode get mode => $_getN(3);
  @$pb.TagNumber(6)
  set mode(Mode value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasMode() => $_has(3);
  @$pb.TagNumber(6)
  void clearMode() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get modeText => $_getSZ(4);
  @$pb.TagNumber(7)
  set modeText($core.String value) => $_setString(4, value);
  @$pb.TagNumber(7)
  $core.bool hasModeText() => $_has(4);
  @$pb.TagNumber(7)
  void clearModeText() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.FeedPaginationReply get paginationReply => $_getN(5);
  @$pb.TagNumber(8)
  set paginationReply($1.FeedPaginationReply value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPaginationReply() => $_has(5);
  @$pb.TagNumber(8)
  void clearPaginationReply() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.FeedPaginationReply ensurePaginationReply() => $_ensure(5);

  @$pb.TagNumber(9)
  $core.String get sessionId => $_getSZ(6);
  @$pb.TagNumber(9)
  set sessionId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(9)
  $core.bool hasSessionId() => $_has(6);
  @$pb.TagNumber(9)
  void clearSessionId() => $_clearField(9);
}

class DetailListReq extends $pb.GeneratedMessage {
  factory DetailListReq({
    $fixnum.Int64? oid,
    $fixnum.Int64? type,
    $fixnum.Int64? root,
    $fixnum.Int64? rpid,
    CursorReq? cursor,
    DetailListScene? scene,
    Mode? mode,
    $1.FeedPagination? pagination,
  }) {
    final result = create();
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    if (root != null) result.root = root;
    if (rpid != null) result.rpid = rpid;
    if (cursor != null) result.cursor = cursor;
    if (scene != null) result.scene = scene;
    if (mode != null) result.mode = mode;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  DetailListReq._();

  factory DetailListReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DetailListReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DetailListReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'oid')
    ..aInt64(2, _omitFieldNames ? '' : 'type')
    ..aInt64(3, _omitFieldNames ? '' : 'root')
    ..aInt64(4, _omitFieldNames ? '' : 'rpid')
    ..aOM<CursorReq>(5, _omitFieldNames ? '' : 'cursor',
        subBuilder: CursorReq.create)
    ..aE<DetailListScene>(6, _omitFieldNames ? '' : 'scene',
        enumValues: DetailListScene.values)
    ..aE<Mode>(7, _omitFieldNames ? '' : 'mode', enumValues: Mode.values)
    ..aOM<$1.FeedPagination>(8, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.FeedPagination.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DetailListReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DetailListReq copyWith(void Function(DetailListReq) updates) =>
      super.copyWith((message) => updates(message as DetailListReq))
          as DetailListReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DetailListReq create() => DetailListReq._();
  @$core.override
  DetailListReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DetailListReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DetailListReq>(create);
  static DetailListReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get oid => $_getI64(0);
  @$pb.TagNumber(1)
  set oid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOid() => $_has(0);
  @$pb.TagNumber(1)
  void clearOid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get type => $_getI64(1);
  @$pb.TagNumber(2)
  set type($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get root => $_getI64(2);
  @$pb.TagNumber(3)
  set root($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRoot() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoot() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get rpid => $_getI64(3);
  @$pb.TagNumber(4)
  set rpid($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRpid() => $_has(3);
  @$pb.TagNumber(4)
  void clearRpid() => $_clearField(4);

  @$pb.TagNumber(5)
  CursorReq get cursor => $_getN(4);
  @$pb.TagNumber(5)
  set cursor(CursorReq value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCursor() => $_has(4);
  @$pb.TagNumber(5)
  void clearCursor() => $_clearField(5);
  @$pb.TagNumber(5)
  CursorReq ensureCursor() => $_ensure(4);

  @$pb.TagNumber(6)
  DetailListScene get scene => $_getN(5);
  @$pb.TagNumber(6)
  set scene(DetailListScene value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasScene() => $_has(5);
  @$pb.TagNumber(6)
  void clearScene() => $_clearField(6);

  @$pb.TagNumber(7)
  Mode get mode => $_getN(6);
  @$pb.TagNumber(7)
  set mode(Mode value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasMode() => $_has(6);
  @$pb.TagNumber(7)
  void clearMode() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.FeedPagination get pagination => $_getN(7);
  @$pb.TagNumber(8)
  set pagination($1.FeedPagination value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPagination() => $_has(7);
  @$pb.TagNumber(8)
  void clearPagination() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.FeedPagination ensurePagination() => $_ensure(7);
}

class DialogListReply extends $pb.GeneratedMessage {
  factory DialogListReply({
    CursorReply? cursor,
    SubjectControl? subjectControl,
    $core.Iterable<ReplyInfo>? replies,
    $1.FeedPaginationReply? paginationReply,
    $core.String? sessionId,
  }) {
    final result = create();
    if (cursor != null) result.cursor = cursor;
    if (subjectControl != null) result.subjectControl = subjectControl;
    if (replies != null) result.replies.addAll(replies);
    if (paginationReply != null) result.paginationReply = paginationReply;
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  DialogListReply._();

  factory DialogListReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DialogListReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DialogListReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOM<CursorReply>(1, _omitFieldNames ? '' : 'cursor',
        subBuilder: CursorReply.create)
    ..aOM<SubjectControl>(2, _omitFieldNames ? '' : 'subjectControl',
        subBuilder: SubjectControl.create)
    ..pPM<ReplyInfo>(3, _omitFieldNames ? '' : 'replies',
        subBuilder: ReplyInfo.create)
    ..aOM<$1.FeedPaginationReply>(5, _omitFieldNames ? '' : 'paginationReply',
        subBuilder: $1.FeedPaginationReply.create)
    ..aOS(6, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DialogListReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DialogListReply copyWith(void Function(DialogListReply) updates) =>
      super.copyWith((message) => updates(message as DialogListReply))
          as DialogListReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DialogListReply create() => DialogListReply._();
  @$core.override
  DialogListReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DialogListReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DialogListReply>(create);
  static DialogListReply? _defaultInstance;

  @$pb.TagNumber(1)
  CursorReply get cursor => $_getN(0);
  @$pb.TagNumber(1)
  set cursor(CursorReply value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCursor() => $_has(0);
  @$pb.TagNumber(1)
  void clearCursor() => $_clearField(1);
  @$pb.TagNumber(1)
  CursorReply ensureCursor() => $_ensure(0);

  @$pb.TagNumber(2)
  SubjectControl get subjectControl => $_getN(1);
  @$pb.TagNumber(2)
  set subjectControl(SubjectControl value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSubjectControl() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubjectControl() => $_clearField(2);
  @$pb.TagNumber(2)
  SubjectControl ensureSubjectControl() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<ReplyInfo> get replies => $_getList(2);

  @$pb.TagNumber(5)
  $1.FeedPaginationReply get paginationReply => $_getN(3);
  @$pb.TagNumber(5)
  set paginationReply($1.FeedPaginationReply value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPaginationReply() => $_has(3);
  @$pb.TagNumber(5)
  void clearPaginationReply() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.FeedPaginationReply ensurePaginationReply() => $_ensure(3);

  @$pb.TagNumber(6)
  $core.String get sessionId => $_getSZ(4);
  @$pb.TagNumber(6)
  set sessionId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(6)
  $core.bool hasSessionId() => $_has(4);
  @$pb.TagNumber(6)
  void clearSessionId() => $_clearField(6);
}

class DialogListReq extends $pb.GeneratedMessage {
  factory DialogListReq({
    $fixnum.Int64? oid,
    $fixnum.Int64? type,
    $fixnum.Int64? root,
    $fixnum.Int64? dialog,
    CursorReq? cursor,
    $1.FeedPagination? pagination,
  }) {
    final result = create();
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    if (root != null) result.root = root;
    if (dialog != null) result.dialog = dialog;
    if (cursor != null) result.cursor = cursor;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  DialogListReq._();

  factory DialogListReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DialogListReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DialogListReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'oid')
    ..aInt64(2, _omitFieldNames ? '' : 'type')
    ..aInt64(3, _omitFieldNames ? '' : 'root')
    ..aInt64(4, _omitFieldNames ? '' : 'dialog')
    ..aOM<CursorReq>(5, _omitFieldNames ? '' : 'cursor',
        subBuilder: CursorReq.create)
    ..aOM<$1.FeedPagination>(6, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.FeedPagination.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DialogListReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DialogListReq copyWith(void Function(DialogListReq) updates) =>
      super.copyWith((message) => updates(message as DialogListReq))
          as DialogListReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DialogListReq create() => DialogListReq._();
  @$core.override
  DialogListReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DialogListReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DialogListReq>(create);
  static DialogListReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get oid => $_getI64(0);
  @$pb.TagNumber(1)
  set oid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOid() => $_has(0);
  @$pb.TagNumber(1)
  void clearOid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get type => $_getI64(1);
  @$pb.TagNumber(2)
  set type($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get root => $_getI64(2);
  @$pb.TagNumber(3)
  set root($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRoot() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoot() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get dialog => $_getI64(3);
  @$pb.TagNumber(4)
  set dialog($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDialog() => $_has(3);
  @$pb.TagNumber(4)
  void clearDialog() => $_clearField(4);

  @$pb.TagNumber(5)
  CursorReq get cursor => $_getN(4);
  @$pb.TagNumber(5)
  set cursor(CursorReq value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCursor() => $_has(4);
  @$pb.TagNumber(5)
  void clearCursor() => $_clearField(5);
  @$pb.TagNumber(5)
  CursorReq ensureCursor() => $_ensure(4);

  @$pb.TagNumber(6)
  $1.FeedPagination get pagination => $_getN(5);
  @$pb.TagNumber(6)
  set pagination($1.FeedPagination value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPagination() => $_has(5);
  @$pb.TagNumber(6)
  void clearPagination() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.FeedPagination ensurePagination() => $_ensure(5);
}

class Emote extends $pb.GeneratedMessage {
  factory Emote({
    $fixnum.Int64? size,
    $core.String? url,
    $core.String? webpUrl,
  }) {
    final result = create();
    if (size != null) result.size = size;
    if (url != null) result.url = url;
    if (webpUrl != null) result.webpUrl = webpUrl;
    return result;
  }

  Emote._();

  factory Emote.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Emote.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Emote',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'size')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..aOS(9, _omitFieldNames ? '' : 'webpUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Emote clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Emote copyWith(void Function(Emote) updates) =>
      super.copyWith((message) => updates(message as Emote)) as Emote;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Emote create() => Emote._();
  @$core.override
  Emote createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Emote getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Emote>(create);
  static Emote? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get size => $_getI64(0);
  @$pb.TagNumber(1)
  set size($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearSize() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);

  @$pb.TagNumber(9)
  $core.String get webpUrl => $_getSZ(2);
  @$pb.TagNumber(9)
  set webpUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(9)
  $core.bool hasWebpUrl() => $_has(2);
  @$pb.TagNumber(9)
  void clearWebpUrl() => $_clearField(9);
}

class MainListReply extends $pb.GeneratedMessage {
  factory MainListReply({
    CursorReply? cursor,
    $core.Iterable<ReplyInfo>? replies,
    SubjectControl? subjectControl,
    ReplyInfo? upTop,
    $core.Iterable<ReplyInfo>? topReplies,
    Mode? mode,
    $core.String? modeText,
    $1.FeedPaginationReply? paginationReply,
    $core.String? sessionId,
  }) {
    final result = create();
    if (cursor != null) result.cursor = cursor;
    if (replies != null) result.replies.addAll(replies);
    if (subjectControl != null) result.subjectControl = subjectControl;
    if (upTop != null) result.upTop = upTop;
    if (topReplies != null) result.topReplies.addAll(topReplies);
    if (mode != null) result.mode = mode;
    if (modeText != null) result.modeText = modeText;
    if (paginationReply != null) result.paginationReply = paginationReply;
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  MainListReply._();

  factory MainListReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MainListReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MainListReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOM<CursorReply>(1, _omitFieldNames ? '' : 'cursor',
        subBuilder: CursorReply.create)
    ..pPM<ReplyInfo>(2, _omitFieldNames ? '' : 'replies',
        subBuilder: ReplyInfo.create)
    ..aOM<SubjectControl>(3, _omitFieldNames ? '' : 'subjectControl',
        subBuilder: SubjectControl.create)
    ..aOM<ReplyInfo>(4, _omitFieldNames ? '' : 'upTop',
        subBuilder: ReplyInfo.create)
    ..pPM<ReplyInfo>(14, _omitFieldNames ? '' : 'topReplies',
        subBuilder: ReplyInfo.create)
    ..aE<Mode>(18, _omitFieldNames ? '' : 'mode', enumValues: Mode.values)
    ..aOS(19, _omitFieldNames ? '' : 'modeText')
    ..aOM<$1.FeedPaginationReply>(20, _omitFieldNames ? '' : 'paginationReply',
        subBuilder: $1.FeedPaginationReply.create)
    ..aOS(21, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MainListReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MainListReply copyWith(void Function(MainListReply) updates) =>
      super.copyWith((message) => updates(message as MainListReply))
          as MainListReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MainListReply create() => MainListReply._();
  @$core.override
  MainListReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MainListReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MainListReply>(create);
  static MainListReply? _defaultInstance;

  @$pb.TagNumber(1)
  CursorReply get cursor => $_getN(0);
  @$pb.TagNumber(1)
  set cursor(CursorReply value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCursor() => $_has(0);
  @$pb.TagNumber(1)
  void clearCursor() => $_clearField(1);
  @$pb.TagNumber(1)
  CursorReply ensureCursor() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<ReplyInfo> get replies => $_getList(1);

  @$pb.TagNumber(3)
  SubjectControl get subjectControl => $_getN(2);
  @$pb.TagNumber(3)
  set subjectControl(SubjectControl value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSubjectControl() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubjectControl() => $_clearField(3);
  @$pb.TagNumber(3)
  SubjectControl ensureSubjectControl() => $_ensure(2);

  @$pb.TagNumber(4)
  ReplyInfo get upTop => $_getN(3);
  @$pb.TagNumber(4)
  set upTop(ReplyInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUpTop() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpTop() => $_clearField(4);
  @$pb.TagNumber(4)
  ReplyInfo ensureUpTop() => $_ensure(3);

  @$pb.TagNumber(14)
  $pb.PbList<ReplyInfo> get topReplies => $_getList(4);

  @$pb.TagNumber(18)
  Mode get mode => $_getN(5);
  @$pb.TagNumber(18)
  set mode(Mode value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasMode() => $_has(5);
  @$pb.TagNumber(18)
  void clearMode() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get modeText => $_getSZ(6);
  @$pb.TagNumber(19)
  set modeText($core.String value) => $_setString(6, value);
  @$pb.TagNumber(19)
  $core.bool hasModeText() => $_has(6);
  @$pb.TagNumber(19)
  void clearModeText() => $_clearField(19);

  @$pb.TagNumber(20)
  $1.FeedPaginationReply get paginationReply => $_getN(7);
  @$pb.TagNumber(20)
  set paginationReply($1.FeedPaginationReply value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasPaginationReply() => $_has(7);
  @$pb.TagNumber(20)
  void clearPaginationReply() => $_clearField(20);
  @$pb.TagNumber(20)
  $1.FeedPaginationReply ensurePaginationReply() => $_ensure(7);

  @$pb.TagNumber(21)
  $core.String get sessionId => $_getSZ(8);
  @$pb.TagNumber(21)
  set sessionId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(21)
  $core.bool hasSessionId() => $_has(8);
  @$pb.TagNumber(21)
  void clearSessionId() => $_clearField(21);
}

class MainListReq extends $pb.GeneratedMessage {
  factory MainListReq({
    $fixnum.Int64? oid,
    $fixnum.Int64? type,
    CursorReq? cursor,
    $fixnum.Int64? rpid,
    $fixnum.Int64? seekRpid,
    $core.String? filterTagName,
    Mode? mode,
    $1.FeedPagination? pagination,
  }) {
    final result = create();
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    if (cursor != null) result.cursor = cursor;
    if (rpid != null) result.rpid = rpid;
    if (seekRpid != null) result.seekRpid = seekRpid;
    if (filterTagName != null) result.filterTagName = filterTagName;
    if (mode != null) result.mode = mode;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  MainListReq._();

  factory MainListReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MainListReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MainListReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'oid')
    ..aInt64(2, _omitFieldNames ? '' : 'type')
    ..aOM<CursorReq>(3, _omitFieldNames ? '' : 'cursor',
        subBuilder: CursorReq.create)
    ..aInt64(6, _omitFieldNames ? '' : 'rpid')
    ..aInt64(7, _omitFieldNames ? '' : 'seekRpid')
    ..aOS(8, _omitFieldNames ? '' : 'filterTagName')
    ..aE<Mode>(9, _omitFieldNames ? '' : 'mode', enumValues: Mode.values)
    ..aOM<$1.FeedPagination>(10, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.FeedPagination.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MainListReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MainListReq copyWith(void Function(MainListReq) updates) =>
      super.copyWith((message) => updates(message as MainListReq))
          as MainListReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MainListReq create() => MainListReq._();
  @$core.override
  MainListReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MainListReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MainListReq>(create);
  static MainListReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get oid => $_getI64(0);
  @$pb.TagNumber(1)
  set oid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOid() => $_has(0);
  @$pb.TagNumber(1)
  void clearOid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get type => $_getI64(1);
  @$pb.TagNumber(2)
  set type($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  CursorReq get cursor => $_getN(2);
  @$pb.TagNumber(3)
  set cursor(CursorReq value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCursor() => $_has(2);
  @$pb.TagNumber(3)
  void clearCursor() => $_clearField(3);
  @$pb.TagNumber(3)
  CursorReq ensureCursor() => $_ensure(2);

  @$pb.TagNumber(6)
  $fixnum.Int64 get rpid => $_getI64(3);
  @$pb.TagNumber(6)
  set rpid($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(6)
  $core.bool hasRpid() => $_has(3);
  @$pb.TagNumber(6)
  void clearRpid() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get seekRpid => $_getI64(4);
  @$pb.TagNumber(7)
  set seekRpid($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(7)
  $core.bool hasSeekRpid() => $_has(4);
  @$pb.TagNumber(7)
  void clearSeekRpid() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get filterTagName => $_getSZ(5);
  @$pb.TagNumber(8)
  set filterTagName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(8)
  $core.bool hasFilterTagName() => $_has(5);
  @$pb.TagNumber(8)
  void clearFilterTagName() => $_clearField(8);

  @$pb.TagNumber(9)
  Mode get mode => $_getN(6);
  @$pb.TagNumber(9)
  set mode(Mode value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasMode() => $_has(6);
  @$pb.TagNumber(9)
  void clearMode() => $_clearField(9);

  @$pb.TagNumber(10)
  $1.FeedPagination get pagination => $_getN(7);
  @$pb.TagNumber(10)
  set pagination($1.FeedPagination value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasPagination() => $_has(7);
  @$pb.TagNumber(10)
  void clearPagination() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.FeedPagination ensurePagination() => $_ensure(7);
}

class MemberV2_Basic extends $pb.GeneratedMessage {
  factory MemberV2_Basic({
    $fixnum.Int64? mid,
    $core.String? name,
    $core.String? face,
    $fixnum.Int64? level,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    if (name != null) result.name = name;
    if (face != null) result.face = face;
    if (level != null) result.level = level;
    return result;
  }

  MemberV2_Basic._();

  factory MemberV2_Basic.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MemberV2_Basic.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MemberV2.Basic',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'face')
    ..aInt64(5, _omitFieldNames ? '' : 'level')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Basic clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Basic copyWith(void Function(MemberV2_Basic) updates) =>
      super.copyWith((message) => updates(message as MemberV2_Basic))
          as MemberV2_Basic;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MemberV2_Basic create() => MemberV2_Basic._();
  @$core.override
  MemberV2_Basic createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MemberV2_Basic getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MemberV2_Basic>(create);
  static MemberV2_Basic? _defaultInstance;

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

  @$pb.TagNumber(4)
  $core.String get face => $_getSZ(2);
  @$pb.TagNumber(4)
  set face($core.String value) => $_setString(2, value);
  @$pb.TagNumber(4)
  $core.bool hasFace() => $_has(2);
  @$pb.TagNumber(4)
  void clearFace() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get level => $_getI64(3);
  @$pb.TagNumber(5)
  set level($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(5)
  $core.bool hasLevel() => $_has(3);
  @$pb.TagNumber(5)
  void clearLevel() => $_clearField(5);
}

class MemberV2_Garb extends $pb.GeneratedMessage {
  factory MemberV2_Garb({
    $core.String? pendantImage,
    $core.String? cardImage,
    $core.String? cardNumber,
    $core.String? cardFanColor,
    $core.String? fanNumPrefix,
  }) {
    final result = create();
    if (pendantImage != null) result.pendantImage = pendantImage;
    if (cardImage != null) result.cardImage = cardImage;
    if (cardNumber != null) result.cardNumber = cardNumber;
    if (cardFanColor != null) result.cardFanColor = cardFanColor;
    if (fanNumPrefix != null) result.fanNumPrefix = fanNumPrefix;
    return result;
  }

  MemberV2_Garb._();

  factory MemberV2_Garb.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MemberV2_Garb.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MemberV2.Garb',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'pendantImage')
    ..aOS(2, _omitFieldNames ? '' : 'cardImage')
    ..aOS(5, _omitFieldNames ? '' : 'cardNumber')
    ..aOS(6, _omitFieldNames ? '' : 'cardFanColor')
    ..aOS(8, _omitFieldNames ? '' : 'fanNumPrefix')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Garb clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Garb copyWith(void Function(MemberV2_Garb) updates) =>
      super.copyWith((message) => updates(message as MemberV2_Garb))
          as MemberV2_Garb;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MemberV2_Garb create() => MemberV2_Garb._();
  @$core.override
  MemberV2_Garb createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MemberV2_Garb getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MemberV2_Garb>(create);
  static MemberV2_Garb? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pendantImage => $_getSZ(0);
  @$pb.TagNumber(1)
  set pendantImage($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPendantImage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPendantImage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cardImage => $_getSZ(1);
  @$pb.TagNumber(2)
  set cardImage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCardImage() => $_has(1);
  @$pb.TagNumber(2)
  void clearCardImage() => $_clearField(2);

  @$pb.TagNumber(5)
  $core.String get cardNumber => $_getSZ(2);
  @$pb.TagNumber(5)
  set cardNumber($core.String value) => $_setString(2, value);
  @$pb.TagNumber(5)
  $core.bool hasCardNumber() => $_has(2);
  @$pb.TagNumber(5)
  void clearCardNumber() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get cardFanColor => $_getSZ(3);
  @$pb.TagNumber(6)
  set cardFanColor($core.String value) => $_setString(3, value);
  @$pb.TagNumber(6)
  $core.bool hasCardFanColor() => $_has(3);
  @$pb.TagNumber(6)
  void clearCardFanColor() => $_clearField(6);

  @$pb.TagNumber(8)
  $core.String get fanNumPrefix => $_getSZ(4);
  @$pb.TagNumber(8)
  set fanNumPrefix($core.String value) => $_setString(4, value);
  @$pb.TagNumber(8)
  $core.bool hasFanNumPrefix() => $_has(4);
  @$pb.TagNumber(8)
  void clearFanNumPrefix() => $_clearField(8);
}

class MemberV2_Medal extends $pb.GeneratedMessage {
  factory MemberV2_Medal({
    $core.String? name,
    $fixnum.Int64? level,
    $fixnum.Int64? colorStart,
    $fixnum.Int64? colorName,
    $fixnum.Int64? guardLevel,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (level != null) result.level = level;
    if (colorStart != null) result.colorStart = colorStart;
    if (colorName != null) result.colorName = colorName;
    if (guardLevel != null) result.guardLevel = guardLevel;
    return result;
  }

  MemberV2_Medal._();

  factory MemberV2_Medal.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MemberV2_Medal.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MemberV2.Medal',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aInt64(2, _omitFieldNames ? '' : 'level')
    ..aInt64(3, _omitFieldNames ? '' : 'colorStart')
    ..aInt64(6, _omitFieldNames ? '' : 'colorName')
    ..aInt64(8, _omitFieldNames ? '' : 'guardLevel')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Medal clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Medal copyWith(void Function(MemberV2_Medal) updates) =>
      super.copyWith((message) => updates(message as MemberV2_Medal))
          as MemberV2_Medal;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MemberV2_Medal create() => MemberV2_Medal._();
  @$core.override
  MemberV2_Medal createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MemberV2_Medal getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MemberV2_Medal>(create);
  static MemberV2_Medal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get level => $_getI64(1);
  @$pb.TagNumber(2)
  set level($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLevel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLevel() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get colorStart => $_getI64(2);
  @$pb.TagNumber(3)
  set colorStart($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasColorStart() => $_has(2);
  @$pb.TagNumber(3)
  void clearColorStart() => $_clearField(3);

  @$pb.TagNumber(6)
  $fixnum.Int64 get colorName => $_getI64(3);
  @$pb.TagNumber(6)
  set colorName($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(6)
  $core.bool hasColorName() => $_has(3);
  @$pb.TagNumber(6)
  void clearColorName() => $_clearField(6);

  @$pb.TagNumber(8)
  $fixnum.Int64 get guardLevel => $_getI64(4);
  @$pb.TagNumber(8)
  set guardLevel($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(8)
  $core.bool hasGuardLevel() => $_has(4);
  @$pb.TagNumber(8)
  void clearGuardLevel() => $_clearField(8);
}

class MemberV2_Official extends $pb.GeneratedMessage {
  factory MemberV2_Official({
    $fixnum.Int64? verifyType,
  }) {
    final result = create();
    if (verifyType != null) result.verifyType = verifyType;
    return result;
  }

  MemberV2_Official._();

  factory MemberV2_Official.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MemberV2_Official.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MemberV2.Official',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'verifyType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Official clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Official copyWith(void Function(MemberV2_Official) updates) =>
      super.copyWith((message) => updates(message as MemberV2_Official))
          as MemberV2_Official;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MemberV2_Official create() => MemberV2_Official._();
  @$core.override
  MemberV2_Official createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MemberV2_Official getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MemberV2_Official>(create);
  static MemberV2_Official? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get verifyType => $_getI64(0);
  @$pb.TagNumber(1)
  set verifyType($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVerifyType() => $_has(0);
  @$pb.TagNumber(1)
  void clearVerifyType() => $_clearField(1);
}

class MemberV2_Senior extends $pb.GeneratedMessage {
  factory MemberV2_Senior({
    $core.int? isSeniorMember,
  }) {
    final result = create();
    if (isSeniorMember != null) result.isSeniorMember = isSeniorMember;
    return result;
  }

  MemberV2_Senior._();

  factory MemberV2_Senior.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MemberV2_Senior.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MemberV2.Senior',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'isSeniorMember')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Senior clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Senior copyWith(void Function(MemberV2_Senior) updates) =>
      super.copyWith((message) => updates(message as MemberV2_Senior))
          as MemberV2_Senior;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MemberV2_Senior create() => MemberV2_Senior._();
  @$core.override
  MemberV2_Senior createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MemberV2_Senior getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MemberV2_Senior>(create);
  static MemberV2_Senior? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get isSeniorMember => $_getIZ(0);
  @$pb.TagNumber(1)
  set isSeniorMember($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsSeniorMember() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsSeniorMember() => $_clearField(1);
}

class MemberV2_Vip extends $pb.GeneratedMessage {
  factory MemberV2_Vip({
    $fixnum.Int64? type,
    $fixnum.Int64? status,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (status != null) result.status = status;
    return result;
  }

  MemberV2_Vip._();

  factory MemberV2_Vip.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MemberV2_Vip.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MemberV2.Vip',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'type')
    ..aInt64(2, _omitFieldNames ? '' : 'status')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Vip clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Vip copyWith(void Function(MemberV2_Vip) updates) =>
      super.copyWith((message) => updates(message as MemberV2_Vip))
          as MemberV2_Vip;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MemberV2_Vip create() => MemberV2_Vip._();
  @$core.override
  MemberV2_Vip createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MemberV2_Vip getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MemberV2_Vip>(create);
  static MemberV2_Vip? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get type => $_getI64(0);
  @$pb.TagNumber(1)
  set type($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get status => $_getI64(1);
  @$pb.TagNumber(2)
  set status($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);
}

class MemberV2 extends $pb.GeneratedMessage {
  factory MemberV2({
    MemberV2_Basic? basic,
    MemberV2_Official? official,
    MemberV2_Vip? vip,
    MemberV2_Garb? garb,
    MemberV2_Medal? medal,
    MemberV2_Senior? senior,
  }) {
    final result = create();
    if (basic != null) result.basic = basic;
    if (official != null) result.official = official;
    if (vip != null) result.vip = vip;
    if (garb != null) result.garb = garb;
    if (medal != null) result.medal = medal;
    if (senior != null) result.senior = senior;
    return result;
  }

  MemberV2._();

  factory MemberV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MemberV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MemberV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOM<MemberV2_Basic>(1, _omitFieldNames ? '' : 'basic',
        subBuilder: MemberV2_Basic.create)
    ..aOM<MemberV2_Official>(2, _omitFieldNames ? '' : 'official',
        subBuilder: MemberV2_Official.create)
    ..aOM<MemberV2_Vip>(3, _omitFieldNames ? '' : 'vip',
        subBuilder: MemberV2_Vip.create)
    ..aOM<MemberV2_Garb>(4, _omitFieldNames ? '' : 'garb',
        subBuilder: MemberV2_Garb.create)
    ..aOM<MemberV2_Medal>(5, _omitFieldNames ? '' : 'medal',
        subBuilder: MemberV2_Medal.create)
    ..aOM<MemberV2_Senior>(7, _omitFieldNames ? '' : 'senior',
        subBuilder: MemberV2_Senior.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2 copyWith(void Function(MemberV2) updates) =>
      super.copyWith((message) => updates(message as MemberV2)) as MemberV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MemberV2 create() => MemberV2._();
  @$core.override
  MemberV2 createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MemberV2 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MemberV2>(create);
  static MemberV2? _defaultInstance;

  @$pb.TagNumber(1)
  MemberV2_Basic get basic => $_getN(0);
  @$pb.TagNumber(1)
  set basic(MemberV2_Basic value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBasic() => $_has(0);
  @$pb.TagNumber(1)
  void clearBasic() => $_clearField(1);
  @$pb.TagNumber(1)
  MemberV2_Basic ensureBasic() => $_ensure(0);

  @$pb.TagNumber(2)
  MemberV2_Official get official => $_getN(1);
  @$pb.TagNumber(2)
  set official(MemberV2_Official value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOfficial() => $_has(1);
  @$pb.TagNumber(2)
  void clearOfficial() => $_clearField(2);
  @$pb.TagNumber(2)
  MemberV2_Official ensureOfficial() => $_ensure(1);

  @$pb.TagNumber(3)
  MemberV2_Vip get vip => $_getN(2);
  @$pb.TagNumber(3)
  set vip(MemberV2_Vip value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasVip() => $_has(2);
  @$pb.TagNumber(3)
  void clearVip() => $_clearField(3);
  @$pb.TagNumber(3)
  MemberV2_Vip ensureVip() => $_ensure(2);

  @$pb.TagNumber(4)
  MemberV2_Garb get garb => $_getN(3);
  @$pb.TagNumber(4)
  set garb(MemberV2_Garb value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasGarb() => $_has(3);
  @$pb.TagNumber(4)
  void clearGarb() => $_clearField(4);
  @$pb.TagNumber(4)
  MemberV2_Garb ensureGarb() => $_ensure(3);

  @$pb.TagNumber(5)
  MemberV2_Medal get medal => $_getN(4);
  @$pb.TagNumber(5)
  set medal(MemberV2_Medal value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMedal() => $_has(4);
  @$pb.TagNumber(5)
  void clearMedal() => $_clearField(5);
  @$pb.TagNumber(5)
  MemberV2_Medal ensureMedal() => $_ensure(4);

  @$pb.TagNumber(7)
  MemberV2_Senior get senior => $_getN(5);
  @$pb.TagNumber(7)
  set senior(MemberV2_Senior value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSenior() => $_has(5);
  @$pb.TagNumber(7)
  void clearSenior() => $_clearField(7);
  @$pb.TagNumber(7)
  MemberV2_Senior ensureSenior() => $_ensure(5);
}

class OpusItem extends $pb.GeneratedMessage {
  factory OpusItem({
    $fixnum.Int64? opusId,
  }) {
    final result = create();
    if (opusId != null) result.opusId = opusId;
    return result;
  }

  OpusItem._();

  factory OpusItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpusItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpusItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'opusId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpusItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpusItem copyWith(void Function(OpusItem) updates) =>
      super.copyWith((message) => updates(message as OpusItem)) as OpusItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpusItem create() => OpusItem._();
  @$core.override
  OpusItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpusItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpusItem>(create);
  static OpusItem? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get opusId => $_getI64(0);
  @$pb.TagNumber(1)
  set opusId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOpusId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpusId() => $_clearField(1);
}

class PGCVideoSearchItem extends $pb.GeneratedMessage {
  factory PGCVideoSearchItem({
    $core.String? title,
    $core.String? category,
    $core.String? cover,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (category != null) result.category = category;
    if (cover != null) result.cover = cover;
    return result;
  }

  PGCVideoSearchItem._();

  factory PGCVideoSearchItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PGCVideoSearchItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PGCVideoSearchItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'category')
    ..aOS(3, _omitFieldNames ? '' : 'cover')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PGCVideoSearchItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PGCVideoSearchItem copyWith(void Function(PGCVideoSearchItem) updates) =>
      super.copyWith((message) => updates(message as PGCVideoSearchItem))
          as PGCVideoSearchItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PGCVideoSearchItem create() => PGCVideoSearchItem._();
  @$core.override
  PGCVideoSearchItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PGCVideoSearchItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PGCVideoSearchItem>(create);
  static PGCVideoSearchItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get category => $_getSZ(1);
  @$pb.TagNumber(2)
  set category($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCategory() => $_has(1);
  @$pb.TagNumber(2)
  void clearCategory() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get cover => $_getSZ(2);
  @$pb.TagNumber(3)
  set cover($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCover() => $_has(2);
  @$pb.TagNumber(3)
  void clearCover() => $_clearField(3);
}

class Picture extends $pb.GeneratedMessage {
  factory Picture({
    $core.String? imgSrc,
    $core.double? imgWidth,
    $core.double? imgHeight,
  }) {
    final result = create();
    if (imgSrc != null) result.imgSrc = imgSrc;
    if (imgWidth != null) result.imgWidth = imgWidth;
    if (imgHeight != null) result.imgHeight = imgHeight;
    return result;
  }

  Picture._();

  factory Picture.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Picture.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Picture',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'imgSrc')
    ..aD(2, _omitFieldNames ? '' : 'imgWidth')
    ..aD(3, _omitFieldNames ? '' : 'imgHeight')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Picture clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Picture copyWith(void Function(Picture) updates) =>
      super.copyWith((message) => updates(message as Picture)) as Picture;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Picture create() => Picture._();
  @$core.override
  Picture createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Picture getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Picture>(create);
  static Picture? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get imgSrc => $_getSZ(0);
  @$pb.TagNumber(1)
  set imgSrc($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasImgSrc() => $_has(0);
  @$pb.TagNumber(1)
  void clearImgSrc() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get imgWidth => $_getN(1);
  @$pb.TagNumber(2)
  set imgWidth($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasImgWidth() => $_has(1);
  @$pb.TagNumber(2)
  void clearImgWidth() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get imgHeight => $_getN(2);
  @$pb.TagNumber(3)
  set imgHeight($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasImgHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearImgHeight() => $_clearField(3);
}

class ReplyCardLabel extends $pb.GeneratedMessage {
  factory ReplyCardLabel({
    $core.String? textContent,
  }) {
    final result = create();
    if (textContent != null) result.textContent = textContent;
    return result;
  }

  ReplyCardLabel._();

  factory ReplyCardLabel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplyCardLabel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyCardLabel',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'textContent')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyCardLabel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyCardLabel copyWith(void Function(ReplyCardLabel) updates) =>
      super.copyWith((message) => updates(message as ReplyCardLabel))
          as ReplyCardLabel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplyCardLabel create() => ReplyCardLabel._();
  @$core.override
  ReplyCardLabel createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReplyCardLabel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyCardLabel>(create);
  static ReplyCardLabel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get textContent => $_getSZ(0);
  @$pb.TagNumber(1)
  set textContent($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTextContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearTextContent() => $_clearField(1);
}

class ReplyControl extends $pb.GeneratedMessage {
  factory ReplyControl({
    $fixnum.Int64? action,
    $core.bool? upLike,
    $core.bool? upReply,
    $core.bool? isUpTop,
    $core.bool? isNote,
    $core.Iterable<ReplyCardLabel>? cardLabels,
    $core.String? location,
    $core.bool? isNoteV2,
  }) {
    final result = create();
    if (action != null) result.action = action;
    if (upLike != null) result.upLike = upLike;
    if (upReply != null) result.upReply = upReply;
    if (isUpTop != null) result.isUpTop = isUpTop;
    if (isNote != null) result.isNote = isNote;
    if (cardLabels != null) result.cardLabels.addAll(cardLabels);
    if (location != null) result.location = location;
    if (isNoteV2 != null) result.isNoteV2 = isNoteV2;
    return result;
  }

  ReplyControl._();

  factory ReplyControl.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplyControl.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyControl',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'action')
    ..aOB(2, _omitFieldNames ? '' : 'upLike')
    ..aOB(3, _omitFieldNames ? '' : 'upReply')
    ..aOB(12, _omitFieldNames ? '' : 'isUpTop')
    ..aOB(18, _omitFieldNames ? '' : 'isNote')
    ..pPM<ReplyCardLabel>(19, _omitFieldNames ? '' : 'cardLabels',
        subBuilder: ReplyCardLabel.create)
    ..aOS(25, _omitFieldNames ? '' : 'location')
    ..aOB(27, _omitFieldNames ? '' : 'isNoteV2')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyControl clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyControl copyWith(void Function(ReplyControl) updates) =>
      super.copyWith((message) => updates(message as ReplyControl))
          as ReplyControl;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplyControl create() => ReplyControl._();
  @$core.override
  ReplyControl createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReplyControl getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyControl>(create);
  static ReplyControl? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get action => $_getI64(0);
  @$pb.TagNumber(1)
  set action($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAction() => $_has(0);
  @$pb.TagNumber(1)
  void clearAction() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get upLike => $_getBF(1);
  @$pb.TagNumber(2)
  set upLike($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUpLike() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpLike() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get upReply => $_getBF(2);
  @$pb.TagNumber(3)
  set upReply($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUpReply() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpReply() => $_clearField(3);

  @$pb.TagNumber(12)
  $core.bool get isUpTop => $_getBF(3);
  @$pb.TagNumber(12)
  set isUpTop($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(12)
  $core.bool hasIsUpTop() => $_has(3);
  @$pb.TagNumber(12)
  void clearIsUpTop() => $_clearField(12);

  @$pb.TagNumber(18)
  $core.bool get isNote => $_getBF(4);
  @$pb.TagNumber(18)
  set isNote($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(18)
  $core.bool hasIsNote() => $_has(4);
  @$pb.TagNumber(18)
  void clearIsNote() => $_clearField(18);

  @$pb.TagNumber(19)
  $pb.PbList<ReplyCardLabel> get cardLabels => $_getList(5);

  @$pb.TagNumber(25)
  $core.String get location => $_getSZ(6);
  @$pb.TagNumber(25)
  set location($core.String value) => $_setString(6, value);
  @$pb.TagNumber(25)
  $core.bool hasLocation() => $_has(6);
  @$pb.TagNumber(25)
  void clearLocation() => $_clearField(25);

  @$pb.TagNumber(27)
  $core.bool get isNoteV2 => $_getBF(7);
  @$pb.TagNumber(27)
  set isNoteV2($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(27)
  $core.bool hasIsNoteV2() => $_has(7);
  @$pb.TagNumber(27)
  void clearIsNoteV2() => $_clearField(27);
}

class ReplyInfo extends $pb.GeneratedMessage {
  factory ReplyInfo({
    $core.Iterable<ReplyInfo>? replies,
    $fixnum.Int64? id,
    $fixnum.Int64? oid,
    $fixnum.Int64? type,
    $fixnum.Int64? mid,
    $fixnum.Int64? root,
    $fixnum.Int64? parent,
    $fixnum.Int64? dialog,
    $fixnum.Int64? like,
    $fixnum.Int64? ctime,
    $fixnum.Int64? count,
    Content? content,
    ReplyControl? replyControl,
    MemberV2? memberV2,
  }) {
    final result = create();
    if (replies != null) result.replies.addAll(replies);
    if (id != null) result.id = id;
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    if (mid != null) result.mid = mid;
    if (root != null) result.root = root;
    if (parent != null) result.parent = parent;
    if (dialog != null) result.dialog = dialog;
    if (like != null) result.like = like;
    if (ctime != null) result.ctime = ctime;
    if (count != null) result.count = count;
    if (content != null) result.content = content;
    if (replyControl != null) result.replyControl = replyControl;
    if (memberV2 != null) result.memberV2 = memberV2;
    return result;
  }

  ReplyInfo._();

  factory ReplyInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplyInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..pPM<ReplyInfo>(1, _omitFieldNames ? '' : 'replies',
        subBuilder: ReplyInfo.create)
    ..aInt64(2, _omitFieldNames ? '' : 'id')
    ..aInt64(3, _omitFieldNames ? '' : 'oid')
    ..aInt64(4, _omitFieldNames ? '' : 'type')
    ..aInt64(5, _omitFieldNames ? '' : 'mid')
    ..aInt64(6, _omitFieldNames ? '' : 'root')
    ..aInt64(7, _omitFieldNames ? '' : 'parent')
    ..aInt64(8, _omitFieldNames ? '' : 'dialog')
    ..aInt64(9, _omitFieldNames ? '' : 'like')
    ..aInt64(10, _omitFieldNames ? '' : 'ctime')
    ..aInt64(11, _omitFieldNames ? '' : 'count')
    ..aOM<Content>(12, _omitFieldNames ? '' : 'content',
        subBuilder: Content.create)
    ..aOM<ReplyControl>(14, _omitFieldNames ? '' : 'replyControl',
        subBuilder: ReplyControl.create)
    ..aOM<MemberV2>(15, _omitFieldNames ? '' : 'memberV2',
        subBuilder: MemberV2.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInfo copyWith(void Function(ReplyInfo) updates) =>
      super.copyWith((message) => updates(message as ReplyInfo)) as ReplyInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplyInfo create() => ReplyInfo._();
  @$core.override
  ReplyInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReplyInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReplyInfo>(create);
  static ReplyInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ReplyInfo> get replies => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get id => $_getI64(1);
  @$pb.TagNumber(2)
  set id($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get oid => $_getI64(2);
  @$pb.TagNumber(3)
  set oid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOid() => $_has(2);
  @$pb.TagNumber(3)
  void clearOid() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get type => $_getI64(3);
  @$pb.TagNumber(4)
  set type($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasType() => $_has(3);
  @$pb.TagNumber(4)
  void clearType() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get mid => $_getI64(4);
  @$pb.TagNumber(5)
  set mid($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMid() => $_has(4);
  @$pb.TagNumber(5)
  void clearMid() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get root => $_getI64(5);
  @$pb.TagNumber(6)
  set root($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRoot() => $_has(5);
  @$pb.TagNumber(6)
  void clearRoot() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get parent => $_getI64(6);
  @$pb.TagNumber(7)
  set parent($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasParent() => $_has(6);
  @$pb.TagNumber(7)
  void clearParent() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get dialog => $_getI64(7);
  @$pb.TagNumber(8)
  set dialog($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDialog() => $_has(7);
  @$pb.TagNumber(8)
  void clearDialog() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get like => $_getI64(8);
  @$pb.TagNumber(9)
  set like($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLike() => $_has(8);
  @$pb.TagNumber(9)
  void clearLike() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get ctime => $_getI64(9);
  @$pb.TagNumber(10)
  set ctime($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCtime() => $_has(9);
  @$pb.TagNumber(10)
  void clearCtime() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get count => $_getI64(10);
  @$pb.TagNumber(11)
  set count($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCount() => $_has(10);
  @$pb.TagNumber(11)
  void clearCount() => $_clearField(11);

  @$pb.TagNumber(12)
  Content get content => $_getN(11);
  @$pb.TagNumber(12)
  set content(Content value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasContent() => $_has(11);
  @$pb.TagNumber(12)
  void clearContent() => $_clearField(12);
  @$pb.TagNumber(12)
  Content ensureContent() => $_ensure(11);

  @$pb.TagNumber(14)
  ReplyControl get replyControl => $_getN(12);
  @$pb.TagNumber(14)
  set replyControl(ReplyControl value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasReplyControl() => $_has(12);
  @$pb.TagNumber(14)
  void clearReplyControl() => $_clearField(14);
  @$pb.TagNumber(14)
  ReplyControl ensureReplyControl() => $_ensure(12);

  @$pb.TagNumber(15)
  MemberV2 get memberV2 => $_getN(13);
  @$pb.TagNumber(15)
  set memberV2(MemberV2 value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasMemberV2() => $_has(13);
  @$pb.TagNumber(15)
  void clearMemberV2() => $_clearField(15);
  @$pb.TagNumber(15)
  MemberV2 ensureMemberV2() => $_ensure(13);
}

enum RichText_Item { note, opus, notSet }

class RichText extends $pb.GeneratedMessage {
  factory RichText({
    RichTextNote? note,
    OpusItem? opus,
  }) {
    final result = create();
    if (note != null) result.note = note;
    if (opus != null) result.opus = opus;
    return result;
  }

  RichText._();

  factory RichText.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RichText.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, RichText_Item> _RichText_ItemByTag = {
    1: RichText_Item.note,
    2: RichText_Item.opus,
    0: RichText_Item.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RichText',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<RichTextNote>(1, _omitFieldNames ? '' : 'note',
        subBuilder: RichTextNote.create)
    ..aOM<OpusItem>(2, _omitFieldNames ? '' : 'opus',
        subBuilder: OpusItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RichText clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RichText copyWith(void Function(RichText) updates) =>
      super.copyWith((message) => updates(message as RichText)) as RichText;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RichText create() => RichText._();
  @$core.override
  RichText createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RichText getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RichText>(create);
  static RichText? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  RichText_Item whichItem() => _RichText_ItemByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearItem() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  RichTextNote get note => $_getN(0);
  @$pb.TagNumber(1)
  set note(RichTextNote value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNote() => $_has(0);
  @$pb.TagNumber(1)
  void clearNote() => $_clearField(1);
  @$pb.TagNumber(1)
  RichTextNote ensureNote() => $_ensure(0);

  @$pb.TagNumber(2)
  OpusItem get opus => $_getN(1);
  @$pb.TagNumber(2)
  set opus(OpusItem value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpus() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpus() => $_clearField(2);
  @$pb.TagNumber(2)
  OpusItem ensureOpus() => $_ensure(1);
}

class RichTextNote extends $pb.GeneratedMessage {
  factory RichTextNote({
    $core.String? clickUrl,
  }) {
    final result = create();
    if (clickUrl != null) result.clickUrl = clickUrl;
    return result;
  }

  RichTextNote._();

  factory RichTextNote.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RichTextNote.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RichTextNote',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(3, _omitFieldNames ? '' : 'clickUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RichTextNote clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RichTextNote copyWith(void Function(RichTextNote) updates) =>
      super.copyWith((message) => updates(message as RichTextNote))
          as RichTextNote;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RichTextNote create() => RichTextNote._();
  @$core.override
  RichTextNote createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RichTextNote getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RichTextNote>(create);
  static RichTextNote? _defaultInstance;

  @$pb.TagNumber(3)
  $core.String get clickUrl => $_getSZ(0);
  @$pb.TagNumber(3)
  set clickUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(3)
  $core.bool hasClickUrl() => $_has(0);
  @$pb.TagNumber(3)
  void clearClickUrl() => $_clearField(3);
}

enum SearchItem_Item { video, article, notSet }

class SearchItem extends $pb.GeneratedMessage {
  factory SearchItem({
    $core.String? url,
    VideoSearchItem? video,
    ArticleSearchItem? article,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (video != null) result.video = video;
    if (article != null) result.article = article;
    return result;
  }

  SearchItem._();

  factory SearchItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SearchItem_Item> _SearchItem_ItemByTag = {
    3: SearchItem_Item.video,
    4: SearchItem_Item.article,
    0: SearchItem_Item.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..oo(0, [3, 4])
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOM<VideoSearchItem>(3, _omitFieldNames ? '' : 'video',
        subBuilder: VideoSearchItem.create)
    ..aOM<ArticleSearchItem>(4, _omitFieldNames ? '' : 'article',
        subBuilder: ArticleSearchItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchItem copyWith(void Function(SearchItem) updates) =>
      super.copyWith((message) => updates(message as SearchItem)) as SearchItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchItem create() => SearchItem._();
  @$core.override
  SearchItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchItem>(create);
  static SearchItem? _defaultInstance;

  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  SearchItem_Item whichItem() => _SearchItem_ItemByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearItem() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(3)
  VideoSearchItem get video => $_getN(1);
  @$pb.TagNumber(3)
  set video(VideoSearchItem value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasVideo() => $_has(1);
  @$pb.TagNumber(3)
  void clearVideo() => $_clearField(3);
  @$pb.TagNumber(3)
  VideoSearchItem ensureVideo() => $_ensure(1);

  @$pb.TagNumber(4)
  ArticleSearchItem get article => $_getN(2);
  @$pb.TagNumber(4)
  set article(ArticleSearchItem value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasArticle() => $_has(2);
  @$pb.TagNumber(4)
  void clearArticle() => $_clearField(4);
  @$pb.TagNumber(4)
  ArticleSearchItem ensureArticle() => $_ensure(2);
}

class SearchItemCursorReply extends $pb.GeneratedMessage {
  factory SearchItemCursorReply({
    $core.bool? hasNext,
    $fixnum.Int64? next_2,
  }) {
    final result = create();
    if (hasNext != null) result.hasNext = hasNext;
    if (next_2 != null) result.next_2 = next_2;
    return result;
  }

  SearchItemCursorReply._();

  factory SearchItemCursorReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchItemCursorReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchItemCursorReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'hasNext')
    ..aInt64(2, _omitFieldNames ? '' : 'next')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchItemCursorReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchItemCursorReply copyWith(
          void Function(SearchItemCursorReply) updates) =>
      super.copyWith((message) => updates(message as SearchItemCursorReply))
          as SearchItemCursorReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchItemCursorReply create() => SearchItemCursorReply._();
  @$core.override
  SearchItemCursorReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchItemCursorReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchItemCursorReply>(create);
  static SearchItemCursorReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get hasNext => $_getBF(0);
  @$pb.TagNumber(1)
  set hasNext($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHasNext() => $_has(0);
  @$pb.TagNumber(1)
  void clearHasNext() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get next_2 => $_getI64(1);
  @$pb.TagNumber(2)
  set next_2($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNext_2() => $_has(1);
  @$pb.TagNumber(2)
  void clearNext_2() => $_clearField(2);
}

class SearchItemCursorReq extends $pb.GeneratedMessage {
  factory SearchItemCursorReq({
    $fixnum.Int64? next,
    SearchItemType? itemType,
  }) {
    final result = create();
    if (next != null) result.next = next;
    if (itemType != null) result.itemType = itemType;
    return result;
  }

  SearchItemCursorReq._();

  factory SearchItemCursorReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchItemCursorReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchItemCursorReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'next')
    ..aE<SearchItemType>(2, _omitFieldNames ? '' : 'itemType',
        enumValues: SearchItemType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchItemCursorReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchItemCursorReq copyWith(void Function(SearchItemCursorReq) updates) =>
      super.copyWith((message) => updates(message as SearchItemCursorReq))
          as SearchItemCursorReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchItemCursorReq create() => SearchItemCursorReq._();
  @$core.override
  SearchItemCursorReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchItemCursorReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchItemCursorReq>(create);
  static SearchItemCursorReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get next => $_getI64(0);
  @$pb.TagNumber(1)
  set next($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNext() => $_has(0);
  @$pb.TagNumber(1)
  void clearNext() => $_clearField(1);

  @$pb.TagNumber(2)
  SearchItemType get itemType => $_getN(1);
  @$pb.TagNumber(2)
  set itemType(SearchItemType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasItemType() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemType() => $_clearField(2);
}

class SearchItemReply extends $pb.GeneratedMessage {
  factory SearchItemReply({
    SearchItemCursorReply? cursor,
    $core.Iterable<SearchItem>? items,
  }) {
    final result = create();
    if (cursor != null) result.cursor = cursor;
    if (items != null) result.items.addAll(items);
    return result;
  }

  SearchItemReply._();

  factory SearchItemReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchItemReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchItemReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOM<SearchItemCursorReply>(1, _omitFieldNames ? '' : 'cursor',
        subBuilder: SearchItemCursorReply.create)
    ..pPM<SearchItem>(2, _omitFieldNames ? '' : 'items',
        subBuilder: SearchItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchItemReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchItemReply copyWith(void Function(SearchItemReply) updates) =>
      super.copyWith((message) => updates(message as SearchItemReply))
          as SearchItemReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchItemReply create() => SearchItemReply._();
  @$core.override
  SearchItemReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchItemReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchItemReply>(create);
  static SearchItemReply? _defaultInstance;

  @$pb.TagNumber(1)
  SearchItemCursorReply get cursor => $_getN(0);
  @$pb.TagNumber(1)
  set cursor(SearchItemCursorReply value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCursor() => $_has(0);
  @$pb.TagNumber(1)
  void clearCursor() => $_clearField(1);
  @$pb.TagNumber(1)
  SearchItemCursorReply ensureCursor() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<SearchItem> get items => $_getList(1);
}

class SearchItemReq extends $pb.GeneratedMessage {
  factory SearchItemReq({
    SearchItemCursorReq? cursor,
    $fixnum.Int64? oid,
    $fixnum.Int64? type,
    $core.String? keyword,
  }) {
    final result = create();
    if (cursor != null) result.cursor = cursor;
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    if (keyword != null) result.keyword = keyword;
    return result;
  }

  SearchItemReq._();

  factory SearchItemReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchItemReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchItemReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOM<SearchItemCursorReq>(1, _omitFieldNames ? '' : 'cursor',
        subBuilder: SearchItemCursorReq.create)
    ..aInt64(2, _omitFieldNames ? '' : 'oid')
    ..aInt64(3, _omitFieldNames ? '' : 'type')
    ..aOS(4, _omitFieldNames ? '' : 'keyword')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchItemReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchItemReq copyWith(void Function(SearchItemReq) updates) =>
      super.copyWith((message) => updates(message as SearchItemReq))
          as SearchItemReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchItemReq create() => SearchItemReq._();
  @$core.override
  SearchItemReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchItemReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchItemReq>(create);
  static SearchItemReq? _defaultInstance;

  @$pb.TagNumber(1)
  SearchItemCursorReq get cursor => $_getN(0);
  @$pb.TagNumber(1)
  set cursor(SearchItemCursorReq value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCursor() => $_has(0);
  @$pb.TagNumber(1)
  void clearCursor() => $_clearField(1);
  @$pb.TagNumber(1)
  SearchItemCursorReq ensureCursor() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get oid => $_getI64(1);
  @$pb.TagNumber(2)
  set oid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get type => $_getI64(2);
  @$pb.TagNumber(3)
  set type($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get keyword => $_getSZ(3);
  @$pb.TagNumber(4)
  set keyword($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasKeyword() => $_has(3);
  @$pb.TagNumber(4)
  void clearKeyword() => $_clearField(4);
}

class SubjectControl extends $pb.GeneratedMessage {
  factory SubjectControl({
    $fixnum.Int64? upMid,
    $core.bool? inputDisable,
    $core.String? rootText,
    $fixnum.Int64? count,
    $core.String? title,
  }) {
    final result = create();
    if (upMid != null) result.upMid = upMid;
    if (inputDisable != null) result.inputDisable = inputDisable;
    if (rootText != null) result.rootText = rootText;
    if (count != null) result.count = count;
    if (title != null) result.title = title;
    return result;
  }

  SubjectControl._();

  factory SubjectControl.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubjectControl.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubjectControl',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'upMid')
    ..aOB(13, _omitFieldNames ? '' : 'inputDisable')
    ..aOS(14, _omitFieldNames ? '' : 'rootText')
    ..aInt64(16, _omitFieldNames ? '' : 'count')
    ..aOS(17, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubjectControl clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubjectControl copyWith(void Function(SubjectControl) updates) =>
      super.copyWith((message) => updates(message as SubjectControl))
          as SubjectControl;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubjectControl create() => SubjectControl._();
  @$core.override
  SubjectControl createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubjectControl getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubjectControl>(create);
  static SubjectControl? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get upMid => $_getI64(0);
  @$pb.TagNumber(1)
  set upMid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUpMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpMid() => $_clearField(1);

  @$pb.TagNumber(13)
  $core.bool get inputDisable => $_getBF(1);
  @$pb.TagNumber(13)
  set inputDisable($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(13)
  $core.bool hasInputDisable() => $_has(1);
  @$pb.TagNumber(13)
  void clearInputDisable() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get rootText => $_getSZ(2);
  @$pb.TagNumber(14)
  set rootText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(14)
  $core.bool hasRootText() => $_has(2);
  @$pb.TagNumber(14)
  void clearRootText() => $_clearField(14);

  @$pb.TagNumber(16)
  $fixnum.Int64 get count => $_getI64(3);
  @$pb.TagNumber(16)
  set count($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(16)
  $core.bool hasCount() => $_has(3);
  @$pb.TagNumber(16)
  void clearCount() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(17)
  set title($core.String value) => $_setString(4, value);
  @$pb.TagNumber(17)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(17)
  void clearTitle() => $_clearField(17);
}

class Topic extends $pb.GeneratedMessage {
  factory Topic({
    $core.String? link,
    $fixnum.Int64? id,
  }) {
    final result = create();
    if (link != null) result.link = link;
    if (id != null) result.id = id;
    return result;
  }

  Topic._();

  factory Topic.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Topic.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Topic',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'link')
    ..aInt64(2, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Topic clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Topic copyWith(void Function(Topic) updates) =>
      super.copyWith((message) => updates(message as Topic)) as Topic;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Topic create() => Topic._();
  @$core.override
  Topic createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Topic getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Topic>(create);
  static Topic? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get link => $_getSZ(0);
  @$pb.TagNumber(1)
  set link($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLink() => $_has(0);
  @$pb.TagNumber(1)
  void clearLink() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get id => $_getI64(1);
  @$pb.TagNumber(2)
  set id($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);
}

class UGCVideoSearchItem extends $pb.GeneratedMessage {
  factory UGCVideoSearchItem({
    $core.String? title,
    $core.String? upNickname,
    $fixnum.Int64? duration,
    $core.String? cover,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (upNickname != null) result.upNickname = upNickname;
    if (duration != null) result.duration = duration;
    if (cover != null) result.cover = cover;
    return result;
  }

  UGCVideoSearchItem._();

  factory UGCVideoSearchItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UGCVideoSearchItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UGCVideoSearchItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'upNickname')
    ..aInt64(3, _omitFieldNames ? '' : 'duration')
    ..aOS(4, _omitFieldNames ? '' : 'cover')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UGCVideoSearchItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UGCVideoSearchItem copyWith(void Function(UGCVideoSearchItem) updates) =>
      super.copyWith((message) => updates(message as UGCVideoSearchItem))
          as UGCVideoSearchItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UGCVideoSearchItem create() => UGCVideoSearchItem._();
  @$core.override
  UGCVideoSearchItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UGCVideoSearchItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UGCVideoSearchItem>(create);
  static UGCVideoSearchItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get upNickname => $_getSZ(1);
  @$pb.TagNumber(2)
  set upNickname($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUpNickname() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpNickname() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get duration => $_getI64(2);
  @$pb.TagNumber(3)
  set duration($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDuration() => $_has(2);
  @$pb.TagNumber(3)
  void clearDuration() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get cover => $_getSZ(3);
  @$pb.TagNumber(4)
  set cover($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCover() => $_has(3);
  @$pb.TagNumber(4)
  void clearCover() => $_clearField(4);
}

class Url_Extra extends $pb.GeneratedMessage {
  factory Url_Extra({
    $fixnum.Int64? goodsItemId,
    $core.String? goodsPrefetchedCache,
    $core.bool? isWordSearch,
    $fixnum.Int64? goodsCmControl,
  }) {
    final result = create();
    if (goodsItemId != null) result.goodsItemId = goodsItemId;
    if (goodsPrefetchedCache != null)
      result.goodsPrefetchedCache = goodsPrefetchedCache;
    if (isWordSearch != null) result.isWordSearch = isWordSearch;
    if (goodsCmControl != null) result.goodsCmControl = goodsCmControl;
    return result;
  }

  Url_Extra._();

  factory Url_Extra.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Url_Extra.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Url.Extra',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'goodsItemId')
    ..aOS(2, _omitFieldNames ? '' : 'goodsPrefetchedCache')
    ..aOB(4, _omitFieldNames ? '' : 'isWordSearch')
    ..aInt64(5, _omitFieldNames ? '' : 'goodsCmControl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Url_Extra clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Url_Extra copyWith(void Function(Url_Extra) updates) =>
      super.copyWith((message) => updates(message as Url_Extra)) as Url_Extra;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Url_Extra create() => Url_Extra._();
  @$core.override
  Url_Extra createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Url_Extra getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Url_Extra>(create);
  static Url_Extra? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get goodsItemId => $_getI64(0);
  @$pb.TagNumber(1)
  set goodsItemId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGoodsItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGoodsItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get goodsPrefetchedCache => $_getSZ(1);
  @$pb.TagNumber(2)
  set goodsPrefetchedCache($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGoodsPrefetchedCache() => $_has(1);
  @$pb.TagNumber(2)
  void clearGoodsPrefetchedCache() => $_clearField(2);

  @$pb.TagNumber(4)
  $core.bool get isWordSearch => $_getBF(2);
  @$pb.TagNumber(4)
  set isWordSearch($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(4)
  $core.bool hasIsWordSearch() => $_has(2);
  @$pb.TagNumber(4)
  void clearIsWordSearch() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get goodsCmControl => $_getI64(3);
  @$pb.TagNumber(5)
  set goodsCmControl($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(5)
  $core.bool hasGoodsCmControl() => $_has(3);
  @$pb.TagNumber(5)
  void clearGoodsCmControl() => $_clearField(5);
}

class Url extends $pb.GeneratedMessage {
  factory Url({
    $core.String? title,
    $core.String? prefixIcon,
    $core.String? appUrlSchema,
    $core.String? clickReport,
    Url_Extra? extra,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (prefixIcon != null) result.prefixIcon = prefixIcon;
    if (appUrlSchema != null) result.appUrlSchema = appUrlSchema;
    if (clickReport != null) result.clickReport = clickReport;
    if (extra != null) result.extra = extra;
    return result;
  }

  Url._();

  factory Url.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Url.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Url',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'prefixIcon')
    ..aOS(4, _omitFieldNames ? '' : 'appUrlSchema')
    ..aOS(7, _omitFieldNames ? '' : 'clickReport')
    ..aOM<Url_Extra>(10, _omitFieldNames ? '' : 'extra',
        subBuilder: Url_Extra.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Url clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Url copyWith(void Function(Url) updates) =>
      super.copyWith((message) => updates(message as Url)) as Url;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Url create() => Url._();
  @$core.override
  Url createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Url getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Url>(create);
  static Url? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(3)
  $core.String get prefixIcon => $_getSZ(1);
  @$pb.TagNumber(3)
  set prefixIcon($core.String value) => $_setString(1, value);
  @$pb.TagNumber(3)
  $core.bool hasPrefixIcon() => $_has(1);
  @$pb.TagNumber(3)
  void clearPrefixIcon() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get appUrlSchema => $_getSZ(2);
  @$pb.TagNumber(4)
  set appUrlSchema($core.String value) => $_setString(2, value);
  @$pb.TagNumber(4)
  $core.bool hasAppUrlSchema() => $_has(2);
  @$pb.TagNumber(4)
  void clearAppUrlSchema() => $_clearField(4);

  @$pb.TagNumber(7)
  $core.String get clickReport => $_getSZ(3);
  @$pb.TagNumber(7)
  set clickReport($core.String value) => $_setString(3, value);
  @$pb.TagNumber(7)
  $core.bool hasClickReport() => $_has(3);
  @$pb.TagNumber(7)
  void clearClickReport() => $_clearField(7);

  @$pb.TagNumber(10)
  Url_Extra get extra => $_getN(4);
  @$pb.TagNumber(10)
  set extra(Url_Extra value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasExtra() => $_has(4);
  @$pb.TagNumber(10)
  void clearExtra() => $_clearField(10);
  @$pb.TagNumber(10)
  Url_Extra ensureExtra() => $_ensure(4);
}

enum VideoSearchItem_VideoItem { ugc, pgc, notSet }

class VideoSearchItem extends $pb.GeneratedMessage {
  factory VideoSearchItem({
    SearchItemVideoSubType? type,
    UGCVideoSearchItem? ugc,
    PGCVideoSearchItem? pgc,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (ugc != null) result.ugc = ugc;
    if (pgc != null) result.pgc = pgc;
    return result;
  }

  VideoSearchItem._();

  factory VideoSearchItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VideoSearchItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, VideoSearchItem_VideoItem>
      _VideoSearchItem_VideoItemByTag = {
    2: VideoSearchItem_VideoItem.ugc,
    3: VideoSearchItem_VideoItem.pgc,
    0: VideoSearchItem_VideoItem.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoSearchItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..aE<SearchItemVideoSubType>(1, _omitFieldNames ? '' : 'type',
        enumValues: SearchItemVideoSubType.values)
    ..aOM<UGCVideoSearchItem>(2, _omitFieldNames ? '' : 'ugc',
        subBuilder: UGCVideoSearchItem.create)
    ..aOM<PGCVideoSearchItem>(3, _omitFieldNames ? '' : 'pgc',
        subBuilder: PGCVideoSearchItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoSearchItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoSearchItem copyWith(void Function(VideoSearchItem) updates) =>
      super.copyWith((message) => updates(message as VideoSearchItem))
          as VideoSearchItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VideoSearchItem create() => VideoSearchItem._();
  @$core.override
  VideoSearchItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VideoSearchItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoSearchItem>(create);
  static VideoSearchItem? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  VideoSearchItem_VideoItem whichVideoItem() =>
      _VideoSearchItem_VideoItemByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearVideoItem() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  SearchItemVideoSubType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(SearchItemVideoSubType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  UGCVideoSearchItem get ugc => $_getN(1);
  @$pb.TagNumber(2)
  set ugc(UGCVideoSearchItem value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUgc() => $_has(1);
  @$pb.TagNumber(2)
  void clearUgc() => $_clearField(2);
  @$pb.TagNumber(2)
  UGCVideoSearchItem ensureUgc() => $_ensure(1);

  @$pb.TagNumber(3)
  PGCVideoSearchItem get pgc => $_getN(2);
  @$pb.TagNumber(3)
  set pgc(PGCVideoSearchItem value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPgc() => $_has(2);
  @$pb.TagNumber(3)
  void clearPgc() => $_clearField(3);
  @$pb.TagNumber(3)
  PGCVideoSearchItem ensurePgc() => $_ensure(2);
}

class Vote extends $pb.GeneratedMessage {
  factory Vote({
    $fixnum.Int64? id,
    $core.String? title,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    return result;
  }

  Vote._();

  factory Vote.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Vote.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Vote',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Vote clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Vote copyWith(void Function(Vote) updates) =>
      super.copyWith((message) => updates(message as Vote)) as Vote;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Vote create() => Vote._();
  @$core.override
  Vote createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Vote getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Vote>(create);
  static Vote? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
