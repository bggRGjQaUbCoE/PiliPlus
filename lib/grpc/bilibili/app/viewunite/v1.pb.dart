// This is a generated file - do not edit.
//
// Generated from bilibili/app/viewunite/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/any.pb.dart' as $2;

import '../../pagination.pb.dart' as $3;
import '../../playershared.pb.dart' as $5;
import '../archive/middleware/v1.pb.dart' as $4;
import 'common.pb.dart' as $1;
import 'v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'v1.pbenum.dart';

class ActivityResource extends $pb.GeneratedMessage {
  factory ActivityResource({
    $core.String? darkTextColor,
    $core.String? dividerColor,
    $core.String? bgColor,
    $core.String? selectedBgColor,
    $core.String? textColor,
    $core.String? lightTextColor,
  }) {
    final result = ActivityResource._();
    if (darkTextColor != null) result.darkTextColor = darkTextColor;
    if (dividerColor != null) result.dividerColor = dividerColor;
    if (bgColor != null) result.bgColor = bgColor;
    if (selectedBgColor != null) result.selectedBgColor = selectedBgColor;
    if (textColor != null) result.textColor = textColor;
    if (lightTextColor != null) result.lightTextColor = lightTextColor;
    return result;
  }

  ActivityResource._();

  factory ActivityResource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActivityResource()..mergeFromBuffer(data, registry);
  factory ActivityResource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActivityResource()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActivityResource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: ActivityResource.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'darkTextColor')
    ..aOS(2, _omitFieldNames ? '' : 'dividerColor')
    ..aOS(3, _omitFieldNames ? '' : 'bgColor')
    ..aOS(4, _omitFieldNames ? '' : 'selectedBgColor')
    ..aOS(5, _omitFieldNames ? '' : 'textColor')
    ..aOS(6, _omitFieldNames ? '' : 'lightTextColor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivityResource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivityResource copyWith(void Function(ActivityResource) updates) =>
      super.copyWith((message) => updates(message as ActivityResource))
          as ActivityResource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ActivityResource() / ActivityResource.new instead')
  static ActivityResource create() => ActivityResource._();
  static $pb.GeneratedMessage $_createMessage() => ActivityResource._();
  @$core.override
  ActivityResource createEmptyInstance() => ActivityResource._();
  @$core.pragma('dart2js:noInline')
  static ActivityResource getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActivityResource>(
          ActivityResource.$_createMessage);
  static ActivityResource? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get darkTextColor => $_getSZ(0);
  @$pb.TagNumber(1)
  set darkTextColor($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDarkTextColor() => $_has(0);
  @$pb.TagNumber(1)
  void clearDarkTextColor() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get dividerColor => $_getSZ(1);
  @$pb.TagNumber(2)
  set dividerColor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDividerColor() => $_has(1);
  @$pb.TagNumber(2)
  void clearDividerColor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get bgColor => $_getSZ(2);
  @$pb.TagNumber(3)
  set bgColor($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBgColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearBgColor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get selectedBgColor => $_getSZ(3);
  @$pb.TagNumber(4)
  set selectedBgColor($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSelectedBgColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearSelectedBgColor() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get textColor => $_getSZ(4);
  @$pb.TagNumber(5)
  set textColor($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTextColor() => $_has(4);
  @$pb.TagNumber(5)
  void clearTextColor() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get lightTextColor => $_getSZ(5);
  @$pb.TagNumber(6)
  set lightTextColor($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLightTextColor() => $_has(5);
  @$pb.TagNumber(6)
  void clearLightTextColor() => $_clearField(6);
}

class Arc extends $pb.GeneratedMessage {
  factory Arc({
    $fixnum.Int64? aid,
    $fixnum.Int64? cid,
    $fixnum.Int64? duration,
    $1.Stat? stat,
    $core.String? bvid,
    $core.int? copyright,
    Rights? right,
    $core.String? cover,
    $fixnum.Int64? typeId,
    $core.String? title,
  }) {
    final result = Arc._();
    if (aid != null) result.aid = aid;
    if (cid != null) result.cid = cid;
    if (duration != null) result.duration = duration;
    if (stat != null) result.stat = stat;
    if (bvid != null) result.bvid = bvid;
    if (copyright != null) result.copyright = copyright;
    if (right != null) result.right = right;
    if (cover != null) result.cover = cover;
    if (typeId != null) result.typeId = typeId;
    if (title != null) result.title = title;
    return result;
  }

  Arc._();

  factory Arc.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Arc()..mergeFromBuffer(data, registry);
  factory Arc.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Arc()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Arc',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: Arc.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aInt64(2, _omitFieldNames ? '' : 'cid')
    ..aInt64(3, _omitFieldNames ? '' : 'duration')
    ..aOM<$1.Stat>(4, _omitFieldNames ? '' : 'stat',
        subBuilder: $1.Stat.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'bvid')
    ..aI(6, _omitFieldNames ? '' : 'copyright')
    ..aOM<Rights>(7, _omitFieldNames ? '' : 'right',
        subBuilder: Rights.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'cover')
    ..aInt64(9, _omitFieldNames ? '' : 'typeId')
    ..aOS(10, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Arc clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Arc copyWith(void Function(Arc) updates) =>
      super.copyWith((message) => updates(message as Arc)) as Arc;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Arc() / Arc.new instead')
  static Arc create() => Arc._();
  static $pb.GeneratedMessage $_createMessage() => Arc._();
  @$core.override
  Arc createEmptyInstance() => Arc._();
  @$core.pragma('dart2js:noInline')
  static Arc getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Arc>(Arc.$_createMessage);
  static Arc? _defaultInstance;

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
  $fixnum.Int64 get duration => $_getI64(2);
  @$pb.TagNumber(3)
  set duration($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDuration() => $_has(2);
  @$pb.TagNumber(3)
  void clearDuration() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.Stat get stat => $_getN(3);
  @$pb.TagNumber(4)
  set stat($1.Stat value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStat() => $_has(3);
  @$pb.TagNumber(4)
  void clearStat() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Stat ensureStat() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get bvid => $_getSZ(4);
  @$pb.TagNumber(5)
  set bvid($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBvid() => $_has(4);
  @$pb.TagNumber(5)
  void clearBvid() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get copyright => $_getIZ(5);
  @$pb.TagNumber(6)
  set copyright($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCopyright() => $_has(5);
  @$pb.TagNumber(6)
  void clearCopyright() => $_clearField(6);

  @$pb.TagNumber(7)
  Rights get right => $_getN(6);
  @$pb.TagNumber(7)
  set right(Rights value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasRight() => $_has(6);
  @$pb.TagNumber(7)
  void clearRight() => $_clearField(7);
  @$pb.TagNumber(7)
  Rights ensureRight() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get cover => $_getSZ(7);
  @$pb.TagNumber(8)
  set cover($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCover() => $_has(7);
  @$pb.TagNumber(8)
  void clearCover() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get typeId => $_getI64(8);
  @$pb.TagNumber(9)
  set typeId($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTypeId() => $_has(8);
  @$pb.TagNumber(9)
  void clearTypeId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get title => $_getSZ(9);
  @$pb.TagNumber(10)
  set title($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTitle() => $_has(9);
  @$pb.TagNumber(10)
  void clearTitle() => $_clearField(10);
}

class ArcRefreshReply extends $pb.GeneratedMessage {
  factory ArcRefreshReply({
    $1.Stat? stat,
    SimpleReqUser? reqUser,
    SimpleArc? arc,
    Online? online,
    LikeConfig? likeConfig,
    SimpleOwner? owner,
    ReplyStyle? replyStyle,
  }) {
    final result = ArcRefreshReply._();
    if (stat != null) result.stat = stat;
    if (reqUser != null) result.reqUser = reqUser;
    if (arc != null) result.arc = arc;
    if (online != null) result.online = online;
    if (likeConfig != null) result.likeConfig = likeConfig;
    if (owner != null) result.owner = owner;
    if (replyStyle != null) result.replyStyle = replyStyle;
    return result;
  }

  ArcRefreshReply._();

  factory ArcRefreshReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArcRefreshReply()..mergeFromBuffer(data, registry);
  factory ArcRefreshReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArcRefreshReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArcRefreshReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: ArcRefreshReply.$_createMessage)
    ..aOM<$1.Stat>(1, _omitFieldNames ? '' : 'stat',
        subBuilder: $1.Stat.$_createMessage)
    ..aOM<SimpleReqUser>(2, _omitFieldNames ? '' : 'reqUser',
        subBuilder: SimpleReqUser.$_createMessage)
    ..aOM<SimpleArc>(3, _omitFieldNames ? '' : 'arc',
        subBuilder: SimpleArc.$_createMessage)
    ..aOM<Online>(4, _omitFieldNames ? '' : 'online',
        subBuilder: Online.$_createMessage)
    ..aOM<LikeConfig>(5, _omitFieldNames ? '' : 'likeConfig',
        subBuilder: LikeConfig.$_createMessage)
    ..aOM<SimpleOwner>(6, _omitFieldNames ? '' : 'owner',
        subBuilder: SimpleOwner.$_createMessage)
    ..aOM<ReplyStyle>(7, _omitFieldNames ? '' : 'replyStyle',
        subBuilder: ReplyStyle.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArcRefreshReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArcRefreshReply copyWith(void Function(ArcRefreshReply) updates) =>
      super.copyWith((message) => updates(message as ArcRefreshReply))
          as ArcRefreshReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ArcRefreshReply() / ArcRefreshReply.new instead')
  static ArcRefreshReply create() => ArcRefreshReply._();
  static $pb.GeneratedMessage $_createMessage() => ArcRefreshReply._();
  @$core.override
  ArcRefreshReply createEmptyInstance() => ArcRefreshReply._();
  @$core.pragma('dart2js:noInline')
  static ArcRefreshReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ArcRefreshReply>(
          ArcRefreshReply.$_createMessage);
  static ArcRefreshReply? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Stat get stat => $_getN(0);
  @$pb.TagNumber(1)
  set stat($1.Stat value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStat() => $_has(0);
  @$pb.TagNumber(1)
  void clearStat() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Stat ensureStat() => $_ensure(0);

  @$pb.TagNumber(2)
  SimpleReqUser get reqUser => $_getN(1);
  @$pb.TagNumber(2)
  set reqUser(SimpleReqUser value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasReqUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearReqUser() => $_clearField(2);
  @$pb.TagNumber(2)
  SimpleReqUser ensureReqUser() => $_ensure(1);

  @$pb.TagNumber(3)
  SimpleArc get arc => $_getN(2);
  @$pb.TagNumber(3)
  set arc(SimpleArc value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasArc() => $_has(2);
  @$pb.TagNumber(3)
  void clearArc() => $_clearField(3);
  @$pb.TagNumber(3)
  SimpleArc ensureArc() => $_ensure(2);

  @$pb.TagNumber(4)
  Online get online => $_getN(3);
  @$pb.TagNumber(4)
  set online(Online value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasOnline() => $_has(3);
  @$pb.TagNumber(4)
  void clearOnline() => $_clearField(4);
  @$pb.TagNumber(4)
  Online ensureOnline() => $_ensure(3);

  @$pb.TagNumber(5)
  LikeConfig get likeConfig => $_getN(4);
  @$pb.TagNumber(5)
  set likeConfig(LikeConfig value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLikeConfig() => $_has(4);
  @$pb.TagNumber(5)
  void clearLikeConfig() => $_clearField(5);
  @$pb.TagNumber(5)
  LikeConfig ensureLikeConfig() => $_ensure(4);

  @$pb.TagNumber(6)
  SimpleOwner get owner => $_getN(5);
  @$pb.TagNumber(6)
  set owner(SimpleOwner value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasOwner() => $_has(5);
  @$pb.TagNumber(6)
  void clearOwner() => $_clearField(6);
  @$pb.TagNumber(6)
  SimpleOwner ensureOwner() => $_ensure(5);

  @$pb.TagNumber(7)
  ReplyStyle get replyStyle => $_getN(6);
  @$pb.TagNumber(7)
  set replyStyle(ReplyStyle value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasReplyStyle() => $_has(6);
  @$pb.TagNumber(7)
  void clearReplyStyle() => $_clearField(7);
  @$pb.TagNumber(7)
  ReplyStyle ensureReplyStyle() => $_ensure(6);
}

class ArcRefreshReq extends $pb.GeneratedMessage {
  factory ArcRefreshReq({
    $fixnum.Int64? aid,
    $core.String? bvid,
    UnionType? type,
  }) {
    final result = ArcRefreshReq._();
    if (aid != null) result.aid = aid;
    if (bvid != null) result.bvid = bvid;
    if (type != null) result.type = type;
    return result;
  }

  ArcRefreshReq._();

  factory ArcRefreshReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArcRefreshReq()..mergeFromBuffer(data, registry);
  factory ArcRefreshReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArcRefreshReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArcRefreshReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: ArcRefreshReq.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aOS(2, _omitFieldNames ? '' : 'bvid')
    ..aE<UnionType>(3, _omitFieldNames ? '' : 'type',
        enumValues: UnionType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArcRefreshReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArcRefreshReq copyWith(void Function(ArcRefreshReq) updates) =>
      super.copyWith((message) => updates(message as ArcRefreshReq))
          as ArcRefreshReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ArcRefreshReq() / ArcRefreshReq.new instead')
  static ArcRefreshReq create() => ArcRefreshReq._();
  static $pb.GeneratedMessage $_createMessage() => ArcRefreshReq._();
  @$core.override
  ArcRefreshReq createEmptyInstance() => ArcRefreshReq._();
  @$core.pragma('dart2js:noInline')
  static ArcRefreshReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ArcRefreshReq>(
          ArcRefreshReq.$_createMessage);
  static ArcRefreshReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get aid => $_getI64(0);
  @$pb.TagNumber(1)
  set aid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get bvid => $_getSZ(1);
  @$pb.TagNumber(2)
  set bvid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBvid() => $_has(1);
  @$pb.TagNumber(2)
  void clearBvid() => $_clearField(2);

  @$pb.TagNumber(3)
  UnionType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(UnionType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);
}

class AttentionCard extends $pb.GeneratedMessage {
  factory AttentionCard({
    $core.Iterable<ShowTime>? showTime,
  }) {
    final result = AttentionCard._();
    if (showTime != null) result.showTime.addAll(showTime);
    return result;
  }

  AttentionCard._();

  factory AttentionCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AttentionCard()..mergeFromBuffer(data, registry);
  factory AttentionCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AttentionCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AttentionCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: AttentionCard.$_createMessage)
    ..pPM<ShowTime>(1, _omitFieldNames ? '' : 'showTime',
        subBuilder: ShowTime.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttentionCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttentionCard copyWith(void Function(AttentionCard) updates) =>
      super.copyWith((message) => updates(message as AttentionCard))
          as AttentionCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AttentionCard() / AttentionCard.new instead')
  static AttentionCard create() => AttentionCard._();
  static $pb.GeneratedMessage $_createMessage() => AttentionCard._();
  @$core.override
  AttentionCard createEmptyInstance() => AttentionCard._();
  @$core.pragma('dart2js:noInline')
  static AttentionCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AttentionCard>(
          AttentionCard.$_createMessage);
  static AttentionCard? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ShowTime> get showTime => $_getList(0);
}

class BgPlayNotice extends $pb.GeneratedMessage {
  factory BgPlayNotice({
    $core.bool? allowShow,
    $core.String? text,
    $core.String? btnText1,
    $core.String? btnText2,
  }) {
    final result = BgPlayNotice._();
    if (allowShow != null) result.allowShow = allowShow;
    if (text != null) result.text = text;
    if (btnText1 != null) result.btnText1 = btnText1;
    if (btnText2 != null) result.btnText2 = btnText2;
    return result;
  }

  BgPlayNotice._();

  factory BgPlayNotice.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BgPlayNotice()..mergeFromBuffer(data, registry);
  factory BgPlayNotice.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BgPlayNotice()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BgPlayNotice',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: BgPlayNotice.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'allowShow')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'btnText1')
    ..aOS(4, _omitFieldNames ? '' : 'btnText2')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BgPlayNotice clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BgPlayNotice copyWith(void Function(BgPlayNotice) updates) =>
      super.copyWith((message) => updates(message as BgPlayNotice))
          as BgPlayNotice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BgPlayNotice() / BgPlayNotice.new instead')
  static BgPlayNotice create() => BgPlayNotice._();
  static $pb.GeneratedMessage $_createMessage() => BgPlayNotice._();
  @$core.override
  BgPlayNotice createEmptyInstance() => BgPlayNotice._();
  @$core.pragma('dart2js:noInline')
  static BgPlayNotice getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BgPlayNotice>(
          BgPlayNotice.$_createMessage);
  static BgPlayNotice? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get allowShow => $_getBF(0);
  @$pb.TagNumber(1)
  set allowShow($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAllowShow() => $_has(0);
  @$pb.TagNumber(1)
  void clearAllowShow() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get btnText1 => $_getSZ(2);
  @$pb.TagNumber(3)
  set btnText1($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBtnText1() => $_has(2);
  @$pb.TagNumber(3)
  void clearBtnText1() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get btnText2 => $_getSZ(3);
  @$pb.TagNumber(4)
  set btnText2($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBtnText2() => $_has(3);
  @$pb.TagNumber(4)
  void clearBtnText2() => $_clearField(4);
}

class BizFollowVideoParam extends $pb.GeneratedMessage {
  factory BizFollowVideoParam({
    $fixnum.Int64? seasonId,
  }) {
    final result = BizFollowVideoParam._();
    if (seasonId != null) result.seasonId = seasonId;
    return result;
  }

  BizFollowVideoParam._();

  factory BizFollowVideoParam.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BizFollowVideoParam()..mergeFromBuffer(data, registry);
  factory BizFollowVideoParam.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BizFollowVideoParam()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BizFollowVideoParam',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: BizFollowVideoParam.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'seasonId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BizFollowVideoParam clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BizFollowVideoParam copyWith(void Function(BizFollowVideoParam) updates) =>
      super.copyWith((message) => updates(message as BizFollowVideoParam))
          as BizFollowVideoParam;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use BizFollowVideoParam() / BizFollowVideoParam.new instead')
  static BizFollowVideoParam create() => BizFollowVideoParam._();
  static $pb.GeneratedMessage $_createMessage() => BizFollowVideoParam._();
  @$core.override
  BizFollowVideoParam createEmptyInstance() => BizFollowVideoParam._();
  @$core.pragma('dart2js:noInline')
  static BizFollowVideoParam getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BizFollowVideoParam>(
          BizFollowVideoParam.$_createMessage);
  static BizFollowVideoParam? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get seasonId => $_getI64(0);
  @$pb.TagNumber(1)
  set seasonId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeasonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeasonId() => $_clearField(1);
}

class BizGameBackflowParam extends $pb.GeneratedMessage {
  factory BizGameBackflowParam({
    $core.String? extra,
  }) {
    final result = BizGameBackflowParam._();
    if (extra != null) result.extra = extra;
    return result;
  }

  BizGameBackflowParam._();

  factory BizGameBackflowParam.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BizGameBackflowParam()..mergeFromBuffer(data, registry);
  factory BizGameBackflowParam.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BizGameBackflowParam()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BizGameBackflowParam',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: BizGameBackflowParam.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'extra')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BizGameBackflowParam clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BizGameBackflowParam copyWith(void Function(BizGameBackflowParam) updates) =>
      super.copyWith((message) => updates(message as BizGameBackflowParam))
          as BizGameBackflowParam;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BizGameBackflowParam() / BizGameBackflowParam.new instead')
  static BizGameBackflowParam create() => BizGameBackflowParam._();
  static $pb.GeneratedMessage $_createMessage() => BizGameBackflowParam._();
  @$core.override
  BizGameBackflowParam createEmptyInstance() => BizGameBackflowParam._();
  @$core.pragma('dart2js:noInline')
  static BizGameBackflowParam getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BizGameBackflowParam>(
          BizGameBackflowParam.$_createMessage);
  static BizGameBackflowParam? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get extra => $_getSZ(0);
  @$pb.TagNumber(1)
  set extra($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExtra() => $_has(0);
  @$pb.TagNumber(1)
  void clearExtra() => $_clearField(1);
}

class BizJumpLinkParam extends $pb.GeneratedMessage {
  factory BizJumpLinkParam({
    $core.String? url,
  }) {
    final result = BizJumpLinkParam._();
    if (url != null) result.url = url;
    return result;
  }

  BizJumpLinkParam._();

  factory BizJumpLinkParam.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BizJumpLinkParam()..mergeFromBuffer(data, registry);
  factory BizJumpLinkParam.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BizJumpLinkParam()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BizJumpLinkParam',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: BizJumpLinkParam.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BizJumpLinkParam clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BizJumpLinkParam copyWith(void Function(BizJumpLinkParam) updates) =>
      super.copyWith((message) => updates(message as BizJumpLinkParam))
          as BizJumpLinkParam;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BizJumpLinkParam() / BizJumpLinkParam.new instead')
  static BizJumpLinkParam create() => BizJumpLinkParam._();
  static $pb.GeneratedMessage $_createMessage() => BizJumpLinkParam._();
  @$core.override
  BizJumpLinkParam createEmptyInstance() => BizJumpLinkParam._();
  @$core.pragma('dart2js:noInline')
  static BizJumpLinkParam getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BizJumpLinkParam>(
          BizJumpLinkParam.$_createMessage);
  static BizJumpLinkParam? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);
}

class BizReserveActivityParam extends $pb.GeneratedMessage {
  factory BizReserveActivityParam({
    $fixnum.Int64? activityId,
    $core.String? from,
    $core.String? type,
    $fixnum.Int64? oid,
    $fixnum.Int64? reserveId,
  }) {
    final result = BizReserveActivityParam._();
    if (activityId != null) result.activityId = activityId;
    if (from != null) result.from = from;
    if (type != null) result.type = type;
    if (oid != null) result.oid = oid;
    if (reserveId != null) result.reserveId = reserveId;
    return result;
  }

  BizReserveActivityParam._();

  factory BizReserveActivityParam.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BizReserveActivityParam()..mergeFromBuffer(data, registry);
  factory BizReserveActivityParam.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BizReserveActivityParam()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BizReserveActivityParam',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: BizReserveActivityParam.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'activityId')
    ..aOS(2, _omitFieldNames ? '' : 'from')
    ..aOS(3, _omitFieldNames ? '' : 'type')
    ..aInt64(4, _omitFieldNames ? '' : 'oid')
    ..aInt64(5, _omitFieldNames ? '' : 'reserveId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BizReserveActivityParam clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BizReserveActivityParam copyWith(
          void Function(BizReserveActivityParam) updates) =>
      super.copyWith((message) => updates(message as BizReserveActivityParam))
          as BizReserveActivityParam;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BizReserveActivityParam() / BizReserveActivityParam.new instead')
  static BizReserveActivityParam create() => BizReserveActivityParam._();
  static $pb.GeneratedMessage $_createMessage() => BizReserveActivityParam._();
  @$core.override
  BizReserveActivityParam createEmptyInstance() => BizReserveActivityParam._();
  @$core.pragma('dart2js:noInline')
  static BizReserveActivityParam getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BizReserveActivityParam>(
          BizReserveActivityParam.$_createMessage);
  static BizReserveActivityParam? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get activityId => $_getI64(0);
  @$pb.TagNumber(1)
  set activityId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActivityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearActivityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get from => $_getSZ(1);
  @$pb.TagNumber(2)
  set from($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearFrom() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get type => $_getSZ(2);
  @$pb.TagNumber(3)
  set type($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get oid => $_getI64(3);
  @$pb.TagNumber(4)
  set oid($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOid() => $_has(3);
  @$pb.TagNumber(4)
  void clearOid() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get reserveId => $_getI64(4);
  @$pb.TagNumber(5)
  set reserveId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReserveId() => $_has(4);
  @$pb.TagNumber(5)
  void clearReserveId() => $_clearField(5);
}

class BizReserveGameParam extends $pb.GeneratedMessage {
  factory BizReserveGameParam({
    $fixnum.Int64? gameId,
  }) {
    final result = BizReserveGameParam._();
    if (gameId != null) result.gameId = gameId;
    return result;
  }

  BizReserveGameParam._();

  factory BizReserveGameParam.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BizReserveGameParam()..mergeFromBuffer(data, registry);
  factory BizReserveGameParam.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BizReserveGameParam()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BizReserveGameParam',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: BizReserveGameParam.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'gameId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BizReserveGameParam clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BizReserveGameParam copyWith(void Function(BizReserveGameParam) updates) =>
      super.copyWith((message) => updates(message as BizReserveGameParam))
          as BizReserveGameParam;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use BizReserveGameParam() / BizReserveGameParam.new instead')
  static BizReserveGameParam create() => BizReserveGameParam._();
  static $pb.GeneratedMessage $_createMessage() => BizReserveGameParam._();
  @$core.override
  BizReserveGameParam createEmptyInstance() => BizReserveGameParam._();
  @$core.pragma('dart2js:noInline')
  static BizReserveGameParam getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BizReserveGameParam>(
          BizReserveGameParam.$_createMessage);
  static BizReserveGameParam? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get gameId => $_getI64(0);
  @$pb.TagNumber(1)
  set gameId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGameId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGameId() => $_clearField(1);
}

class Button extends $pb.GeneratedMessage {
  factory Button({
    $core.String? title,
    $core.String? uri,
    $core.String? icon,
    JumpShowType? jumpShowType,
  }) {
    final result = Button._();
    if (title != null) result.title = title;
    if (uri != null) result.uri = uri;
    if (icon != null) result.icon = icon;
    if (jumpShowType != null) result.jumpShowType = jumpShowType;
    return result;
  }

  Button._();

  factory Button.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Button()..mergeFromBuffer(data, registry);
  factory Button.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Button()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Button',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: Button.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'uri')
    ..aOS(3, _omitFieldNames ? '' : 'icon')
    ..aE<JumpShowType>(4, _omitFieldNames ? '' : 'jumpShowType',
        enumValues: JumpShowType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Button clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Button copyWith(void Function(Button) updates) =>
      super.copyWith((message) => updates(message as Button)) as Button;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Button() / Button.new instead')
  static Button create() => Button._();
  static $pb.GeneratedMessage $_createMessage() => Button._();
  @$core.override
  Button createEmptyInstance() => Button._();
  @$core.pragma('dart2js:noInline')
  static Button getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Button>(Button.$_createMessage);
  static Button? _defaultInstance;

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
  $core.String get icon => $_getSZ(2);
  @$pb.TagNumber(3)
  set icon($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearIcon() => $_clearField(3);

  @$pb.TagNumber(4)
  JumpShowType get jumpShowType => $_getN(3);
  @$pb.TagNumber(4)
  set jumpShowType(JumpShowType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasJumpShowType() => $_has(3);
  @$pb.TagNumber(4)
  void clearJumpShowType() => $_clearField(4);
}

class CM extends $pb.GeneratedMessage {
  factory CM({
    $2.Any? cmUnderPlayer,
    $2.Any? adsControl,
    $core.Iterable<$2.Any>? sourceContent,
    PadRelateCM? padRelateCm,
    $core.Iterable<SourceContentItem>? sourceContentItem,
  }) {
    final result = CM._();
    if (cmUnderPlayer != null) result.cmUnderPlayer = cmUnderPlayer;
    if (adsControl != null) result.adsControl = adsControl;
    if (sourceContent != null) result.sourceContent.addAll(sourceContent);
    if (padRelateCm != null) result.padRelateCm = padRelateCm;
    if (sourceContentItem != null)
      result.sourceContentItem.addAll(sourceContentItem);
    return result;
  }

  CM._();

  factory CM.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CM()..mergeFromBuffer(data, registry);
  factory CM.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CM()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CM',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: CM.$_createMessage)
    ..aOM<$2.Any>(1, _omitFieldNames ? '' : 'cmUnderPlayer',
        subBuilder: $2.Any.$_createMessage)
    ..aOM<$2.Any>(2, _omitFieldNames ? '' : 'adsControl',
        subBuilder: $2.Any.$_createMessage)
    ..pPM<$2.Any>(3, _omitFieldNames ? '' : 'sourceContent',
        subBuilder: $2.Any.$_createMessage)
    ..aOM<PadRelateCM>(4, _omitFieldNames ? '' : 'padRelateCm',
        subBuilder: PadRelateCM.$_createMessage)
    ..pPM<SourceContentItem>(5, _omitFieldNames ? '' : 'sourceContentItem',
        subBuilder: SourceContentItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CM clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CM copyWith(void Function(CM) updates) =>
      super.copyWith((message) => updates(message as CM)) as CM;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CM() / CM.new instead')
  static CM create() => CM._();
  static $pb.GeneratedMessage $_createMessage() => CM._();
  @$core.override
  CM createEmptyInstance() => CM._();
  @$core.pragma('dart2js:noInline')
  static CM getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CM>(CM.$_createMessage);
  static CM? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Any get cmUnderPlayer => $_getN(0);
  @$pb.TagNumber(1)
  set cmUnderPlayer($2.Any value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCmUnderPlayer() => $_has(0);
  @$pb.TagNumber(1)
  void clearCmUnderPlayer() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Any ensureCmUnderPlayer() => $_ensure(0);

  @$pb.TagNumber(2)
  $2.Any get adsControl => $_getN(1);
  @$pb.TagNumber(2)
  set adsControl($2.Any value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAdsControl() => $_has(1);
  @$pb.TagNumber(2)
  void clearAdsControl() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Any ensureAdsControl() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<$2.Any> get sourceContent => $_getList(2);

  @$pb.TagNumber(4)
  PadRelateCM get padRelateCm => $_getN(3);
  @$pb.TagNumber(4)
  set padRelateCm(PadRelateCM value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPadRelateCm() => $_has(3);
  @$pb.TagNumber(4)
  void clearPadRelateCm() => $_clearField(4);
  @$pb.TagNumber(4)
  PadRelateCM ensurePadRelateCm() => $_ensure(3);

  @$pb.TagNumber(5)
  $pb.PbList<SourceContentItem> get sourceContentItem => $_getList(4);
}

class CacheAuthenticationReply extends $pb.GeneratedMessage {
  factory CacheAuthenticationReply({
    $core.Iterable<$core.MapEntry<$fixnum.Int64, CachePlayAvRly>>? item,
  }) {
    final result = CacheAuthenticationReply._();
    if (item != null) result.item.addEntries(item);
    return result;
  }

  CacheAuthenticationReply._();

  factory CacheAuthenticationReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CacheAuthenticationReply()..mergeFromBuffer(data, registry);
  factory CacheAuthenticationReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CacheAuthenticationReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CacheAuthenticationReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: CacheAuthenticationReply.$_createMessage)
    ..m<$fixnum.Int64, CachePlayAvRly>(1, _omitFieldNames ? '' : 'item',
        entryClassName: 'CacheAuthenticationReply.ItemEntry',
        keyFieldType: $pb.PbFieldType.O6,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: CachePlayAvRly.$_createMessage,
        valueDefaultOrMaker: CachePlayAvRly.getDefault,
        packageName: const $pb.PackageName('bilibili.app.viewunite.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CacheAuthenticationReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CacheAuthenticationReply copyWith(
          void Function(CacheAuthenticationReply) updates) =>
      super.copyWith((message) => updates(message as CacheAuthenticationReply))
          as CacheAuthenticationReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CacheAuthenticationReply() / CacheAuthenticationReply.new instead')
  static CacheAuthenticationReply create() => CacheAuthenticationReply._();
  static $pb.GeneratedMessage $_createMessage() => CacheAuthenticationReply._();
  @$core.override
  CacheAuthenticationReply createEmptyInstance() =>
      CacheAuthenticationReply._();
  @$core.pragma('dart2js:noInline')
  static CacheAuthenticationReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CacheAuthenticationReply>(
          CacheAuthenticationReply.$_createMessage);
  static CacheAuthenticationReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$fixnum.Int64, CachePlayAvRly> get item => $_getMap(0);
}

class CacheAuthenticationReq extends $pb.GeneratedMessage {
  factory CacheAuthenticationReq({
    $core.Iterable<CachePlayAv>? av,
  }) {
    final result = CacheAuthenticationReq._();
    if (av != null) result.av.addAll(av);
    return result;
  }

  CacheAuthenticationReq._();

  factory CacheAuthenticationReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CacheAuthenticationReq()..mergeFromBuffer(data, registry);
  factory CacheAuthenticationReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CacheAuthenticationReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CacheAuthenticationReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: CacheAuthenticationReq.$_createMessage)
    ..pPM<CachePlayAv>(1, _omitFieldNames ? '' : 'av',
        subBuilder: CachePlayAv.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CacheAuthenticationReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CacheAuthenticationReq copyWith(
          void Function(CacheAuthenticationReq) updates) =>
      super.copyWith((message) => updates(message as CacheAuthenticationReq))
          as CacheAuthenticationReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CacheAuthenticationReq() / CacheAuthenticationReq.new instead')
  static CacheAuthenticationReq create() => CacheAuthenticationReq._();
  static $pb.GeneratedMessage $_createMessage() => CacheAuthenticationReq._();
  @$core.override
  CacheAuthenticationReq createEmptyInstance() => CacheAuthenticationReq._();
  @$core.pragma('dart2js:noInline')
  static CacheAuthenticationReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CacheAuthenticationReq>(
          CacheAuthenticationReq.$_createMessage);
  static CacheAuthenticationReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CachePlayAv> get av => $_getList(0);
}

class CachePlayAv extends $pb.GeneratedMessage {
  factory CachePlayAv({
    $fixnum.Int64? aid,
  }) {
    final result = CachePlayAv._();
    if (aid != null) result.aid = aid;
    return result;
  }

  CachePlayAv._();

  factory CachePlayAv.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CachePlayAv()..mergeFromBuffer(data, registry);
  factory CachePlayAv.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CachePlayAv()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CachePlayAv',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: CachePlayAv.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CachePlayAv clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CachePlayAv copyWith(void Function(CachePlayAv) updates) =>
      super.copyWith((message) => updates(message as CachePlayAv))
          as CachePlayAv;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CachePlayAv() / CachePlayAv.new instead')
  static CachePlayAv create() => CachePlayAv._();
  static $pb.GeneratedMessage $_createMessage() => CachePlayAv._();
  @$core.override
  CachePlayAv createEmptyInstance() => CachePlayAv._();
  @$core.pragma('dart2js:noInline')
  static CachePlayAv getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CachePlayAv>(
          CachePlayAv.$_createMessage);
  static CachePlayAv? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get aid => $_getI64(0);
  @$pb.TagNumber(1)
  set aid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => $_clearField(1);
}

class CachePlayAvRly extends $pb.GeneratedMessage {
  factory CachePlayAvRly({
    CacheCode? code,
  }) {
    final result = CachePlayAvRly._();
    if (code != null) result.code = code;
    return result;
  }

  CachePlayAvRly._();

  factory CachePlayAvRly.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CachePlayAvRly()..mergeFromBuffer(data, registry);
  factory CachePlayAvRly.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CachePlayAvRly()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CachePlayAvRly',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: CachePlayAvRly.$_createMessage)
    ..aE<CacheCode>(1, _omitFieldNames ? '' : 'code',
        enumValues: CacheCode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CachePlayAvRly clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CachePlayAvRly copyWith(void Function(CachePlayAvRly) updates) =>
      super.copyWith((message) => updates(message as CachePlayAvRly))
          as CachePlayAvRly;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CachePlayAvRly() / CachePlayAvRly.new instead')
  static CachePlayAvRly create() => CachePlayAvRly._();
  static $pb.GeneratedMessage $_createMessage() => CachePlayAvRly._();
  @$core.override
  CachePlayAvRly createEmptyInstance() => CachePlayAvRly._();
  @$core.pragma('dart2js:noInline')
  static CachePlayAvRly getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CachePlayAvRly>(
          CachePlayAvRly.$_createMessage);
  static CachePlayAvRly? _defaultInstance;

  @$pb.TagNumber(1)
  CacheCode get code => $_getN(0);
  @$pb.TagNumber(1)
  set code(CacheCode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);
}

class ChargingPlus extends $pb.GeneratedMessage {
  factory ChargingPlus({
    $core.bool? pass,
    $core.Iterable<PlayToast>? playToast,
  }) {
    final result = ChargingPlus._();
    if (pass != null) result.pass = pass;
    if (playToast != null) result.playToast.addAll(playToast);
    return result;
  }

  ChargingPlus._();

  factory ChargingPlus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChargingPlus()..mergeFromBuffer(data, registry);
  factory ChargingPlus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChargingPlus()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChargingPlus',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: ChargingPlus.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'pass')
    ..pPM<PlayToast>(2, _omitFieldNames ? '' : 'playToast',
        subBuilder: PlayToast.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChargingPlus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChargingPlus copyWith(void Function(ChargingPlus) updates) =>
      super.copyWith((message) => updates(message as ChargingPlus))
          as ChargingPlus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ChargingPlus() / ChargingPlus.new instead')
  static ChargingPlus create() => ChargingPlus._();
  static $pb.GeneratedMessage $_createMessage() => ChargingPlus._();
  @$core.override
  ChargingPlus createEmptyInstance() => ChargingPlus._();
  @$core.pragma('dart2js:noInline')
  static ChargingPlus getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChargingPlus>(
          ChargingPlus.$_createMessage);
  static ChargingPlus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get pass => $_getBF(0);
  @$pb.TagNumber(1)
  set pass($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPass() => $_has(0);
  @$pb.TagNumber(1)
  void clearPass() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<PlayToast> get playToast => $_getList(1);
}

class Chronos extends $pb.GeneratedMessage {
  factory Chronos({
    $core.String? md5,
    $core.String? file,
    $core.String? sign,
  }) {
    final result = Chronos._();
    if (md5 != null) result.md5 = md5;
    if (file != null) result.file = file;
    if (sign != null) result.sign = sign;
    return result;
  }

  Chronos._();

  factory Chronos.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Chronos()..mergeFromBuffer(data, registry);
  factory Chronos.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Chronos()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Chronos',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: Chronos.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'md5')
    ..aOS(2, _omitFieldNames ? '' : 'file')
    ..aOS(3, _omitFieldNames ? '' : 'sign')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chronos clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chronos copyWith(void Function(Chronos) updates) =>
      super.copyWith((message) => updates(message as Chronos)) as Chronos;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Chronos() / Chronos.new instead')
  static Chronos create() => Chronos._();
  static $pb.GeneratedMessage $_createMessage() => Chronos._();
  @$core.override
  Chronos createEmptyInstance() => Chronos._();
  @$core.pragma('dart2js:noInline')
  static Chronos getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Chronos>(Chronos.$_createMessage);
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

  @$pb.TagNumber(3)
  $core.String get sign => $_getSZ(2);
  @$pb.TagNumber(3)
  set sign($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSign() => $_has(2);
  @$pb.TagNumber(3)
  void clearSign() => $_clearField(3);
}

class ChronosParam extends $pb.GeneratedMessage {
  factory ChronosParam({
    $core.String? engineVersion,
    $core.String? messageProtocol,
    $core.String? serviceKey,
  }) {
    final result = ChronosParam._();
    if (engineVersion != null) result.engineVersion = engineVersion;
    if (messageProtocol != null) result.messageProtocol = messageProtocol;
    if (serviceKey != null) result.serviceKey = serviceKey;
    return result;
  }

  ChronosParam._();

  factory ChronosParam.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChronosParam()..mergeFromBuffer(data, registry);
  factory ChronosParam.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChronosParam()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChronosParam',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: ChronosParam.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'engineVersion')
    ..aOS(2, _omitFieldNames ? '' : 'messageProtocol')
    ..aOS(3, _omitFieldNames ? '' : 'serviceKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChronosParam clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChronosParam copyWith(void Function(ChronosParam) updates) =>
      super.copyWith((message) => updates(message as ChronosParam))
          as ChronosParam;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ChronosParam() / ChronosParam.new instead')
  static ChronosParam create() => ChronosParam._();
  static $pb.GeneratedMessage $_createMessage() => ChronosParam._();
  @$core.override
  ChronosParam createEmptyInstance() => ChronosParam._();
  @$core.pragma('dart2js:noInline')
  static ChronosParam getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChronosParam>(
          ChronosParam.$_createMessage);
  static ChronosParam? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get engineVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set engineVersion($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEngineVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearEngineVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get messageProtocol => $_getSZ(1);
  @$pb.TagNumber(2)
  set messageProtocol($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageProtocol() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageProtocol() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get serviceKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set serviceKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasServiceKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearServiceKey() => $_clearField(3);
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
    $core.String? idStr,
  }) {
    final result = CommandDm._();
    if (id != null) result.id = id;
    if (oid != null) result.oid = oid;
    if (mid != null) result.mid = mid;
    if (command != null) result.command = command;
    if (content != null) result.content = content;
    if (progress != null) result.progress = progress;
    if (ctime != null) result.ctime = ctime;
    if (mtime != null) result.mtime = mtime;
    if (extra != null) result.extra = extra;
    if (idStr != null) result.idStr = idStr;
    return result;
  }

  CommandDm._();

  factory CommandDm.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommandDm()..mergeFromBuffer(data, registry);
  factory CommandDm.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommandDm()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommandDm',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: CommandDm.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aInt64(2, _omitFieldNames ? '' : 'oid')
    ..aInt64(3, _omitFieldNames ? '' : 'mid')
    ..aOS(4, _omitFieldNames ? '' : 'command')
    ..aOS(5, _omitFieldNames ? '' : 'content')
    ..aI(6, _omitFieldNames ? '' : 'progress')
    ..aOS(7, _omitFieldNames ? '' : 'ctime')
    ..aOS(8, _omitFieldNames ? '' : 'mtime')
    ..aOS(9, _omitFieldNames ? '' : 'extra')
    ..aOS(10, _omitFieldNames ? '' : 'idStr')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommandDm clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommandDm copyWith(void Function(CommandDm) updates) =>
      super.copyWith((message) => updates(message as CommandDm)) as CommandDm;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CommandDm() / CommandDm.new instead')
  static CommandDm create() => CommandDm._();
  static $pb.GeneratedMessage $_createMessage() => CommandDm._();
  @$core.override
  CommandDm createEmptyInstance() => CommandDm._();
  @$core.pragma('dart2js:noInline')
  static CommandDm getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommandDm>(CommandDm.$_createMessage);
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
  $core.String get idStr => $_getSZ(9);
  @$pb.TagNumber(10)
  set idStr($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIdStr() => $_has(9);
  @$pb.TagNumber(10)
  void clearIdStr() => $_clearField(10);
}

class Config extends $pb.GeneratedMessage {
  factory Config({
    Online? online,
    PlayerIcon? playerIcon,
    StoryEntrance? storyEntrance,
    BgPlayNotice? bgPlayNotice,
  }) {
    final result = Config._();
    if (online != null) result.online = online;
    if (playerIcon != null) result.playerIcon = playerIcon;
    if (storyEntrance != null) result.storyEntrance = storyEntrance;
    if (bgPlayNotice != null) result.bgPlayNotice = bgPlayNotice;
    return result;
  }

  Config._();

  factory Config.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Config()..mergeFromBuffer(data, registry);
  factory Config.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Config()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Config',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: Config.$_createMessage)
    ..aOM<Online>(1, _omitFieldNames ? '' : 'online',
        subBuilder: Online.$_createMessage)
    ..aOM<PlayerIcon>(2, _omitFieldNames ? '' : 'playerIcon',
        subBuilder: PlayerIcon.$_createMessage)
    ..aOM<StoryEntrance>(3, _omitFieldNames ? '' : 'storyEntrance',
        subBuilder: StoryEntrance.$_createMessage)
    ..aOM<BgPlayNotice>(4, _omitFieldNames ? '' : 'bgPlayNotice',
        subBuilder: BgPlayNotice.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Config clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Config copyWith(void Function(Config) updates) =>
      super.copyWith((message) => updates(message as Config)) as Config;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Config() / Config.new instead')
  static Config create() => Config._();
  static $pb.GeneratedMessage $_createMessage() => Config._();
  @$core.override
  Config createEmptyInstance() => Config._();
  @$core.pragma('dart2js:noInline')
  static Config getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Config>(Config.$_createMessage);
  static Config? _defaultInstance;

  @$pb.TagNumber(1)
  Online get online => $_getN(0);
  @$pb.TagNumber(1)
  set online(Online value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOnline() => $_has(0);
  @$pb.TagNumber(1)
  void clearOnline() => $_clearField(1);
  @$pb.TagNumber(1)
  Online ensureOnline() => $_ensure(0);

  @$pb.TagNumber(2)
  PlayerIcon get playerIcon => $_getN(1);
  @$pb.TagNumber(2)
  set playerIcon(PlayerIcon value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlayerIcon() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayerIcon() => $_clearField(2);
  @$pb.TagNumber(2)
  PlayerIcon ensurePlayerIcon() => $_ensure(1);

  @$pb.TagNumber(3)
  StoryEntrance get storyEntrance => $_getN(2);
  @$pb.TagNumber(3)
  set storyEntrance(StoryEntrance value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStoryEntrance() => $_has(2);
  @$pb.TagNumber(3)
  void clearStoryEntrance() => $_clearField(3);
  @$pb.TagNumber(3)
  StoryEntrance ensureStoryEntrance() => $_ensure(2);

  @$pb.TagNumber(4)
  BgPlayNotice get bgPlayNotice => $_getN(3);
  @$pb.TagNumber(4)
  set bgPlayNotice(BgPlayNotice value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBgPlayNotice() => $_has(3);
  @$pb.TagNumber(4)
  void clearBgPlayNotice() => $_clearField(4);
  @$pb.TagNumber(4)
  BgPlayNotice ensureBgPlayNotice() => $_ensure(3);
}

class ContractCard extends $pb.GeneratedMessage {
  factory ContractCard({
    $core.double? displayProgress,
    $fixnum.Int64? displayAccuracy,
    $fixnum.Int64? displayDuration,
    $core.int? showMode,
    $core.int? pageType,
    UpperInfos? upper,
    $core.int? isFollowDisplay,
    ContractText? text,
    $fixnum.Int64? followDisplayEndDuration,
    $core.int? isPlayDisplay,
    $core.int? isInteractDisplay,
    $core.bool? playDisplaySwitch,
  }) {
    final result = ContractCard._();
    if (displayProgress != null) result.displayProgress = displayProgress;
    if (displayAccuracy != null) result.displayAccuracy = displayAccuracy;
    if (displayDuration != null) result.displayDuration = displayDuration;
    if (showMode != null) result.showMode = showMode;
    if (pageType != null) result.pageType = pageType;
    if (upper != null) result.upper = upper;
    if (isFollowDisplay != null) result.isFollowDisplay = isFollowDisplay;
    if (text != null) result.text = text;
    if (followDisplayEndDuration != null)
      result.followDisplayEndDuration = followDisplayEndDuration;
    if (isPlayDisplay != null) result.isPlayDisplay = isPlayDisplay;
    if (isInteractDisplay != null) result.isInteractDisplay = isInteractDisplay;
    if (playDisplaySwitch != null) result.playDisplaySwitch = playDisplaySwitch;
    return result;
  }

  ContractCard._();

  factory ContractCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContractCard()..mergeFromBuffer(data, registry);
  factory ContractCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContractCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContractCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: ContractCard.$_createMessage)
    ..aD(1, _omitFieldNames ? '' : 'displayProgress',
        fieldType: $pb.PbFieldType.OF)
    ..aInt64(2, _omitFieldNames ? '' : 'displayAccuracy')
    ..aInt64(3, _omitFieldNames ? '' : 'displayDuration')
    ..aI(4, _omitFieldNames ? '' : 'showMode')
    ..aI(5, _omitFieldNames ? '' : 'pageType')
    ..aOM<UpperInfos>(6, _omitFieldNames ? '' : 'upper',
        subBuilder: UpperInfos.$_createMessage)
    ..aI(7, _omitFieldNames ? '' : 'isFollowDisplay')
    ..aOM<ContractText>(8, _omitFieldNames ? '' : 'text',
        subBuilder: ContractText.$_createMessage)
    ..aInt64(9, _omitFieldNames ? '' : 'followDisplayEndDuration')
    ..aI(10, _omitFieldNames ? '' : 'isPlayDisplay')
    ..aI(11, _omitFieldNames ? '' : 'isInteractDisplay')
    ..aOB(12, _omitFieldNames ? '' : 'playDisplaySwitch')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContractCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContractCard copyWith(void Function(ContractCard) updates) =>
      super.copyWith((message) => updates(message as ContractCard))
          as ContractCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ContractCard() / ContractCard.new instead')
  static ContractCard create() => ContractCard._();
  static $pb.GeneratedMessage $_createMessage() => ContractCard._();
  @$core.override
  ContractCard createEmptyInstance() => ContractCard._();
  @$core.pragma('dart2js:noInline')
  static ContractCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContractCard>(
          ContractCard.$_createMessage);
  static ContractCard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get displayProgress => $_getN(0);
  @$pb.TagNumber(1)
  set displayProgress($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDisplayProgress() => $_has(0);
  @$pb.TagNumber(1)
  void clearDisplayProgress() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get displayAccuracy => $_getI64(1);
  @$pb.TagNumber(2)
  set displayAccuracy($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayAccuracy() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayAccuracy() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get displayDuration => $_getI64(2);
  @$pb.TagNumber(3)
  set displayDuration($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayDuration() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayDuration() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get showMode => $_getIZ(3);
  @$pb.TagNumber(4)
  set showMode($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasShowMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearShowMode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pageType => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageType($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageType() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageType() => $_clearField(5);

  @$pb.TagNumber(6)
  UpperInfos get upper => $_getN(5);
  @$pb.TagNumber(6)
  set upper(UpperInfos value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasUpper() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpper() => $_clearField(6);
  @$pb.TagNumber(6)
  UpperInfos ensureUpper() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.int get isFollowDisplay => $_getIZ(6);
  @$pb.TagNumber(7)
  set isFollowDisplay($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsFollowDisplay() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsFollowDisplay() => $_clearField(7);

  @$pb.TagNumber(8)
  ContractText get text => $_getN(7);
  @$pb.TagNumber(8)
  set text(ContractText value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasText() => $_has(7);
  @$pb.TagNumber(8)
  void clearText() => $_clearField(8);
  @$pb.TagNumber(8)
  ContractText ensureText() => $_ensure(7);

  @$pb.TagNumber(9)
  $fixnum.Int64 get followDisplayEndDuration => $_getI64(8);
  @$pb.TagNumber(9)
  set followDisplayEndDuration($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFollowDisplayEndDuration() => $_has(8);
  @$pb.TagNumber(9)
  void clearFollowDisplayEndDuration() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get isPlayDisplay => $_getIZ(9);
  @$pb.TagNumber(10)
  set isPlayDisplay($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIsPlayDisplay() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsPlayDisplay() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get isInteractDisplay => $_getIZ(10);
  @$pb.TagNumber(11)
  set isInteractDisplay($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasIsInteractDisplay() => $_has(10);
  @$pb.TagNumber(11)
  void clearIsInteractDisplay() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get playDisplaySwitch => $_getBF(11);
  @$pb.TagNumber(12)
  set playDisplaySwitch($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasPlayDisplaySwitch() => $_has(11);
  @$pb.TagNumber(12)
  void clearPlayDisplaySwitch() => $_clearField(12);
}

class ContractText extends $pb.GeneratedMessage {
  factory ContractText({
    $core.String? title,
    $core.String? subtitle,
    $core.String? inlineTitle,
  }) {
    final result = ContractText._();
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    if (inlineTitle != null) result.inlineTitle = inlineTitle;
    return result;
  }

  ContractText._();

  factory ContractText.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContractText()..mergeFromBuffer(data, registry);
  factory ContractText.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContractText()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContractText',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: ContractText.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'subtitle')
    ..aOS(3, _omitFieldNames ? '' : 'inlineTitle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContractText clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContractText copyWith(void Function(ContractText) updates) =>
      super.copyWith((message) => updates(message as ContractText))
          as ContractText;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ContractText() / ContractText.new instead')
  static ContractText create() => ContractText._();
  static $pb.GeneratedMessage $_createMessage() => ContractText._();
  @$core.override
  ContractText createEmptyInstance() => ContractText._();
  @$core.pragma('dart2js:noInline')
  static ContractText getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContractText>(
          ContractText.$_createMessage);
  static ContractText? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get subtitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set subtitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubtitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubtitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get inlineTitle => $_getSZ(2);
  @$pb.TagNumber(3)
  set inlineTitle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInlineTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearInlineTitle() => $_clearField(3);
}

class Control extends $pb.GeneratedMessage {
  factory Control({
    $core.bool? limit,
  }) {
    final result = Control._();
    if (limit != null) result.limit = limit;
    return result;
  }

  Control._();

  factory Control.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Control()..mergeFromBuffer(data, registry);
  factory Control.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Control()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Control',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: Control.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Control clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Control copyWith(void Function(Control) updates) =>
      super.copyWith((message) => updates(message as Control)) as Control;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Control() / Control.new instead')
  static Control create() => Control._();
  static $pb.GeneratedMessage $_createMessage() => Control._();
  @$core.override
  Control createEmptyInstance() => Control._();
  @$core.pragma('dart2js:noInline')
  static Control getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Control>(Control.$_createMessage);
  static Control? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get limit => $_getBF(0);
  @$pb.TagNumber(1)
  set limit($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);
}

class DmResource extends $pb.GeneratedMessage {
  factory DmResource({
    $core.Iterable<CommandDm>? commandDms,
    AttentionCard? attention,
    $core.Iterable<OperationCard>? cards,
  }) {
    final result = DmResource._();
    if (commandDms != null) result.commandDms.addAll(commandDms);
    if (attention != null) result.attention = attention;
    if (cards != null) result.cards.addAll(cards);
    return result;
  }

  DmResource._();

  factory DmResource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DmResource()..mergeFromBuffer(data, registry);
  factory DmResource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DmResource()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DmResource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: DmResource.$_createMessage)
    ..pPM<CommandDm>(1, _omitFieldNames ? '' : 'commandDms',
        subBuilder: CommandDm.$_createMessage)
    ..aOM<AttentionCard>(2, _omitFieldNames ? '' : 'attention',
        subBuilder: AttentionCard.$_createMessage)
    ..pPM<OperationCard>(3, _omitFieldNames ? '' : 'cards',
        subBuilder: OperationCard.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmResource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DmResource copyWith(void Function(DmResource) updates) =>
      super.copyWith((message) => updates(message as DmResource)) as DmResource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DmResource() / DmResource.new instead')
  static DmResource create() => DmResource._();
  static $pb.GeneratedMessage $_createMessage() => DmResource._();
  @$core.override
  DmResource createEmptyInstance() => DmResource._();
  @$core.pragma('dart2js:noInline')
  static DmResource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DmResource>(DmResource.$_createMessage);
  static DmResource? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CommandDm> get commandDms => $_getList(0);

  @$pb.TagNumber(2)
  AttentionCard get attention => $_getN(1);
  @$pb.TagNumber(2)
  set attention(AttentionCard value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAttention() => $_has(1);
  @$pb.TagNumber(2)
  void clearAttention() => $_clearField(2);
  @$pb.TagNumber(2)
  AttentionCard ensureAttention() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<OperationCard> get cards => $_getList(2);
}

class ECodeConfig extends $pb.GeneratedMessage {
  factory ECodeConfig({
    $core.String? redirectUrl,
    $core.String? msg,
  }) {
    final result = ECodeConfig._();
    if (redirectUrl != null) result.redirectUrl = redirectUrl;
    if (msg != null) result.msg = msg;
    return result;
  }

  ECodeConfig._();

  factory ECodeConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ECodeConfig()..mergeFromBuffer(data, registry);
  factory ECodeConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ECodeConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ECodeConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: ECodeConfig.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'redirectUrl')
    ..aOS(2, _omitFieldNames ? '' : 'msg')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ECodeConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ECodeConfig copyWith(void Function(ECodeConfig) updates) =>
      super.copyWith((message) => updates(message as ECodeConfig))
          as ECodeConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ECodeConfig() / ECodeConfig.new instead')
  static ECodeConfig create() => ECodeConfig._();
  static $pb.GeneratedMessage $_createMessage() => ECodeConfig._();
  @$core.override
  ECodeConfig createEmptyInstance() => ECodeConfig._();
  @$core.pragma('dart2js:noInline')
  static ECodeConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ECodeConfig>(
          ECodeConfig.$_createMessage);
  static ECodeConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get redirectUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set redirectUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRedirectUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearRedirectUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get msg => $_getSZ(1);
  @$pb.TagNumber(2)
  set msg($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearMsg() => $_clearField(2);
}

class FloorAdSearchItem extends $pb.GeneratedMessage {
  factory FloorAdSearchItem({
    $2.Any? sourceContent,
  }) {
    final result = FloorAdSearchItem._();
    if (sourceContent != null) result.sourceContent = sourceContent;
    return result;
  }

  FloorAdSearchItem._();

  factory FloorAdSearchItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FloorAdSearchItem()..mergeFromBuffer(data, registry);
  factory FloorAdSearchItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FloorAdSearchItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FloorAdSearchItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: FloorAdSearchItem.$_createMessage)
    ..aOM<$2.Any>(1, _omitFieldNames ? '' : 'sourceContent',
        subBuilder: $2.Any.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FloorAdSearchItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FloorAdSearchItem copyWith(void Function(FloorAdSearchItem) updates) =>
      super.copyWith((message) => updates(message as FloorAdSearchItem))
          as FloorAdSearchItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FloorAdSearchItem() / FloorAdSearchItem.new instead')
  static FloorAdSearchItem create() => FloorAdSearchItem._();
  static $pb.GeneratedMessage $_createMessage() => FloorAdSearchItem._();
  @$core.override
  FloorAdSearchItem createEmptyInstance() => FloorAdSearchItem._();
  @$core.pragma('dart2js:noInline')
  static FloorAdSearchItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FloorAdSearchItem>(
          FloorAdSearchItem.$_createMessage);
  static FloorAdSearchItem? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Any get sourceContent => $_getN(0);
  @$pb.TagNumber(1)
  set sourceContent($2.Any value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSourceContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearSourceContent() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Any ensureSourceContent() => $_ensure(0);
}

class FloorAdSearchReply extends $pb.GeneratedMessage {
  factory FloorAdSearchReply({
    FloorAdSearchTab? tab,
    $core.Iterable<FloorAdSearchItem>? item,
  }) {
    final result = FloorAdSearchReply._();
    if (tab != null) result.tab = tab;
    if (item != null) result.item.addAll(item);
    return result;
  }

  FloorAdSearchReply._();

  factory FloorAdSearchReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FloorAdSearchReply()..mergeFromBuffer(data, registry);
  factory FloorAdSearchReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FloorAdSearchReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FloorAdSearchReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: FloorAdSearchReply.$_createMessage)
    ..aOM<FloorAdSearchTab>(1, _omitFieldNames ? '' : 'tab',
        subBuilder: FloorAdSearchTab.$_createMessage)
    ..pPM<FloorAdSearchItem>(3, _omitFieldNames ? '' : 'item',
        subBuilder: FloorAdSearchItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FloorAdSearchReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FloorAdSearchReply copyWith(void Function(FloorAdSearchReply) updates) =>
      super.copyWith((message) => updates(message as FloorAdSearchReply))
          as FloorAdSearchReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FloorAdSearchReply() / FloorAdSearchReply.new instead')
  static FloorAdSearchReply create() => FloorAdSearchReply._();
  static $pb.GeneratedMessage $_createMessage() => FloorAdSearchReply._();
  @$core.override
  FloorAdSearchReply createEmptyInstance() => FloorAdSearchReply._();
  @$core.pragma('dart2js:noInline')
  static FloorAdSearchReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FloorAdSearchReply>(
          FloorAdSearchReply.$_createMessage);
  static FloorAdSearchReply? _defaultInstance;

  @$pb.TagNumber(1)
  FloorAdSearchTab get tab => $_getN(0);
  @$pb.TagNumber(1)
  set tab(FloorAdSearchTab value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTab() => $_has(0);
  @$pb.TagNumber(1)
  void clearTab() => $_clearField(1);
  @$pb.TagNumber(1)
  FloorAdSearchTab ensureTab() => $_ensure(0);

  @$pb.TagNumber(3)
  $pb.PbList<FloorAdSearchItem> get item => $_getList(1);
}

class FloorAdSearchReq extends $pb.GeneratedMessage {
  factory FloorAdSearchReq({
    $fixnum.Int64? aid,
    $core.String? adExtra,
    $core.String? spmid,
    $core.String? fromSpmid,
  }) {
    final result = FloorAdSearchReq._();
    if (aid != null) result.aid = aid;
    if (adExtra != null) result.adExtra = adExtra;
    if (spmid != null) result.spmid = spmid;
    if (fromSpmid != null) result.fromSpmid = fromSpmid;
    return result;
  }

  FloorAdSearchReq._();

  factory FloorAdSearchReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FloorAdSearchReq()..mergeFromBuffer(data, registry);
  factory FloorAdSearchReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FloorAdSearchReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FloorAdSearchReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: FloorAdSearchReq.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aOS(2, _omitFieldNames ? '' : 'adExtra')
    ..aOS(3, _omitFieldNames ? '' : 'spmid')
    ..aOS(4, _omitFieldNames ? '' : 'fromSpmid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FloorAdSearchReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FloorAdSearchReq copyWith(void Function(FloorAdSearchReq) updates) =>
      super.copyWith((message) => updates(message as FloorAdSearchReq))
          as FloorAdSearchReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FloorAdSearchReq() / FloorAdSearchReq.new instead')
  static FloorAdSearchReq create() => FloorAdSearchReq._();
  static $pb.GeneratedMessage $_createMessage() => FloorAdSearchReq._();
  @$core.override
  FloorAdSearchReq createEmptyInstance() => FloorAdSearchReq._();
  @$core.pragma('dart2js:noInline')
  static FloorAdSearchReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FloorAdSearchReq>(
          FloorAdSearchReq.$_createMessage);
  static FloorAdSearchReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get aid => $_getI64(0);
  @$pb.TagNumber(1)
  set aid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get adExtra => $_getSZ(1);
  @$pb.TagNumber(2)
  set adExtra($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAdExtra() => $_has(1);
  @$pb.TagNumber(2)
  void clearAdExtra() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get spmid => $_getSZ(2);
  @$pb.TagNumber(3)
  set spmid($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSpmid() => $_has(2);
  @$pb.TagNumber(3)
  void clearSpmid() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get fromSpmid => $_getSZ(3);
  @$pb.TagNumber(4)
  set fromSpmid($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFromSpmid() => $_has(3);
  @$pb.TagNumber(4)
  void clearFromSpmid() => $_clearField(4);
}

class FloorAdSearchTab extends $pb.GeneratedMessage {
  factory FloorAdSearchTab({
    $core.String? title,
    $core.String? butTitle,
    $core.String? butUrl,
  }) {
    final result = FloorAdSearchTab._();
    if (title != null) result.title = title;
    if (butTitle != null) result.butTitle = butTitle;
    if (butUrl != null) result.butUrl = butUrl;
    return result;
  }

  FloorAdSearchTab._();

  factory FloorAdSearchTab.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FloorAdSearchTab()..mergeFromBuffer(data, registry);
  factory FloorAdSearchTab.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FloorAdSearchTab()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FloorAdSearchTab',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: FloorAdSearchTab.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'butTitle')
    ..aOS(3, _omitFieldNames ? '' : 'butUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FloorAdSearchTab clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FloorAdSearchTab copyWith(void Function(FloorAdSearchTab) updates) =>
      super.copyWith((message) => updates(message as FloorAdSearchTab))
          as FloorAdSearchTab;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FloorAdSearchTab() / FloorAdSearchTab.new instead')
  static FloorAdSearchTab create() => FloorAdSearchTab._();
  static $pb.GeneratedMessage $_createMessage() => FloorAdSearchTab._();
  @$core.override
  FloorAdSearchTab createEmptyInstance() => FloorAdSearchTab._();
  @$core.pragma('dart2js:noInline')
  static FloorAdSearchTab getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FloorAdSearchTab>(
          FloorAdSearchTab.$_createMessage);
  static FloorAdSearchTab? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get butTitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set butTitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasButTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearButTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get butUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set butUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasButUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearButUrl() => $_clearField(3);
}

class FragmentArc extends $pb.GeneratedMessage {
  factory FragmentArc({
    $fixnum.Int64? aid,
    $fixnum.Int64? cid,
  }) {
    final result = FragmentArc._();
    if (aid != null) result.aid = aid;
    if (cid != null) result.cid = cid;
    return result;
  }

  FragmentArc._();

  factory FragmentArc.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FragmentArc()..mergeFromBuffer(data, registry);
  factory FragmentArc.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FragmentArc()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FragmentArc',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: FragmentArc.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aInt64(2, _omitFieldNames ? '' : 'cid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FragmentArc clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FragmentArc copyWith(void Function(FragmentArc) updates) =>
      super.copyWith((message) => updates(message as FragmentArc))
          as FragmentArc;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FragmentArc() / FragmentArc.new instead')
  static FragmentArc create() => FragmentArc._();
  static $pb.GeneratedMessage $_createMessage() => FragmentArc._();
  @$core.override
  FragmentArc createEmptyInstance() => FragmentArc._();
  @$core.pragma('dart2js:noInline')
  static FragmentArc getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FragmentArc>(
          FragmentArc.$_createMessage);
  static FragmentArc? _defaultInstance;

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
}

class FragmentParam extends $pb.GeneratedMessage {
  factory FragmentParam({
    $core.Iterable<FragmentArc>? fragmentArcs,
  }) {
    final result = FragmentParam._();
    if (fragmentArcs != null) result.fragmentArcs.addAll(fragmentArcs);
    return result;
  }

  FragmentParam._();

  factory FragmentParam.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FragmentParam()..mergeFromBuffer(data, registry);
  factory FragmentParam.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FragmentParam()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FragmentParam',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: FragmentParam.$_createMessage)
    ..pPM<FragmentArc>(1, _omitFieldNames ? '' : 'fragmentArcs',
        subBuilder: FragmentArc.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FragmentParam clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FragmentParam copyWith(void Function(FragmentParam) updates) =>
      super.copyWith((message) => updates(message as FragmentParam))
          as FragmentParam;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FragmentParam() / FragmentParam.new instead')
  static FragmentParam create() => FragmentParam._();
  static $pb.GeneratedMessage $_createMessage() => FragmentParam._();
  @$core.override
  FragmentParam createEmptyInstance() => FragmentParam._();
  @$core.pragma('dart2js:noInline')
  static FragmentParam getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FragmentParam>(
          FragmentParam.$_createMessage);
  static FragmentParam? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FragmentArc> get fragmentArcs => $_getList(0);
}

class FragmentRes extends $pb.GeneratedMessage {
  factory FragmentRes({
    $core.Iterable<$core.MapEntry<$fixnum.Int64, VideoShot>>? videoShot,
  }) {
    final result = FragmentRes._();
    if (videoShot != null) result.videoShot.addEntries(videoShot);
    return result;
  }

  FragmentRes._();

  factory FragmentRes.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FragmentRes()..mergeFromBuffer(data, registry);
  factory FragmentRes.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FragmentRes()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FragmentRes',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: FragmentRes.$_createMessage)
    ..m<$fixnum.Int64, VideoShot>(1, _omitFieldNames ? '' : 'videoShot',
        entryClassName: 'FragmentRes.VideoShotEntry',
        keyFieldType: $pb.PbFieldType.O6,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: VideoShot.$_createMessage,
        valueDefaultOrMaker: VideoShot.getDefault,
        packageName: const $pb.PackageName('bilibili.app.viewunite.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FragmentRes clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FragmentRes copyWith(void Function(FragmentRes) updates) =>
      super.copyWith((message) => updates(message as FragmentRes))
          as FragmentRes;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FragmentRes() / FragmentRes.new instead')
  static FragmentRes create() => FragmentRes._();
  static $pb.GeneratedMessage $_createMessage() => FragmentRes._();
  @$core.override
  FragmentRes createEmptyInstance() => FragmentRes._();
  @$core.pragma('dart2js:noInline')
  static FragmentRes getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FragmentRes>(
          FragmentRes.$_createMessage);
  static FragmentRes? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$fixnum.Int64, VideoShot> get videoShot => $_getMap(0);
}

class IconData extends $pb.GeneratedMessage {
  factory IconData({
    $core.String? metaJson,
    $core.String? spritsImg,
  }) {
    final result = IconData._();
    if (metaJson != null) result.metaJson = metaJson;
    if (spritsImg != null) result.spritsImg = spritsImg;
    return result;
  }

  IconData._();

  factory IconData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IconData()..mergeFromBuffer(data, registry);
  factory IconData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IconData()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IconData',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: IconData.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'metaJson')
    ..aOS(2, _omitFieldNames ? '' : 'spritsImg')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IconData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IconData copyWith(void Function(IconData) updates) =>
      super.copyWith((message) => updates(message as IconData)) as IconData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use IconData() / IconData.new instead')
  static IconData create() => IconData._();
  static $pb.GeneratedMessage $_createMessage() => IconData._();
  @$core.override
  IconData createEmptyInstance() => IconData._();
  @$core.pragma('dart2js:noInline')
  static IconData getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IconData>(IconData.$_createMessage);
  static IconData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get metaJson => $_getSZ(0);
  @$pb.TagNumber(1)
  set metaJson($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMetaJson() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetaJson() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get spritsImg => $_getSZ(1);
  @$pb.TagNumber(2)
  set spritsImg($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSpritsImg() => $_has(1);
  @$pb.TagNumber(2)
  void clearSpritsImg() => $_clearField(2);
}

class IntroductionTab extends $pb.GeneratedMessage {
  factory IntroductionTab({
    $core.String? title,
    $core.Iterable<$1.Module>? modules,
  }) {
    final result = IntroductionTab._();
    if (title != null) result.title = title;
    if (modules != null) result.modules.addAll(modules);
    return result;
  }

  IntroductionTab._();

  factory IntroductionTab.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IntroductionTab()..mergeFromBuffer(data, registry);
  factory IntroductionTab.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IntroductionTab()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IntroductionTab',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: IntroductionTab.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..pPM<$1.Module>(2, _omitFieldNames ? '' : 'modules',
        subBuilder: $1.Module.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IntroductionTab clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IntroductionTab copyWith(void Function(IntroductionTab) updates) =>
      super.copyWith((message) => updates(message as IntroductionTab))
          as IntroductionTab;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use IntroductionTab() / IntroductionTab.new instead')
  static IntroductionTab create() => IntroductionTab._();
  static $pb.GeneratedMessage $_createMessage() => IntroductionTab._();
  @$core.override
  IntroductionTab createEmptyInstance() => IntroductionTab._();
  @$core.pragma('dart2js:noInline')
  static IntroductionTab getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IntroductionTab>(
          IntroductionTab.$_createMessage);
  static IntroductionTab? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$1.Module> get modules => $_getList(1);
}

class LikeConfig extends $pb.GeneratedMessage {
  factory LikeConfig({
    $1.UpLikeImg? tripleLike,
    $core.String? likeAnimation,
  }) {
    final result = LikeConfig._();
    if (tripleLike != null) result.tripleLike = tripleLike;
    if (likeAnimation != null) result.likeAnimation = likeAnimation;
    return result;
  }

  LikeConfig._();

  factory LikeConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LikeConfig()..mergeFromBuffer(data, registry);
  factory LikeConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LikeConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LikeConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: LikeConfig.$_createMessage)
    ..aOM<$1.UpLikeImg>(1, _omitFieldNames ? '' : 'tripleLike',
        subBuilder: $1.UpLikeImg.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'likeAnimation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeConfig copyWith(void Function(LikeConfig) updates) =>
      super.copyWith((message) => updates(message as LikeConfig)) as LikeConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LikeConfig() / LikeConfig.new instead')
  static LikeConfig create() => LikeConfig._();
  static $pb.GeneratedMessage $_createMessage() => LikeConfig._();
  @$core.override
  LikeConfig createEmptyInstance() => LikeConfig._();
  @$core.pragma('dart2js:noInline')
  static LikeConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LikeConfig>(LikeConfig.$_createMessage);
  static LikeConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UpLikeImg get tripleLike => $_getN(0);
  @$pb.TagNumber(1)
  set tripleLike($1.UpLikeImg value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTripleLike() => $_has(0);
  @$pb.TagNumber(1)
  void clearTripleLike() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UpLikeImg ensureTripleLike() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get likeAnimation => $_getSZ(1);
  @$pb.TagNumber(2)
  set likeAnimation($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLikeAnimation() => $_has(1);
  @$pb.TagNumber(2)
  void clearLikeAnimation() => $_clearField(2);
}

class Material extends $pb.GeneratedMessage {
  factory Material({
    $core.String? icon,
    $core.String? text,
    $core.String? url,
    MaterialBizType? type,
    $core.String? param,
    $core.String? staticIcon,
    $core.String? bgColor,
    $core.String? bgPic,
    $core.int? jumpType,
    PageType? pageType,
    $core.bool? needLogin,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
  }) {
    final result = Material._();
    if (icon != null) result.icon = icon;
    if (text != null) result.text = text;
    if (url != null) result.url = url;
    if (type != null) result.type = type;
    if (param != null) result.param = param;
    if (staticIcon != null) result.staticIcon = staticIcon;
    if (bgColor != null) result.bgColor = bgColor;
    if (bgPic != null) result.bgPic = bgPic;
    if (jumpType != null) result.jumpType = jumpType;
    if (pageType != null) result.pageType = pageType;
    if (needLogin != null) result.needLogin = needLogin;
    if (report != null) result.report.addEntries(report);
    return result;
  }

  Material._();

  factory Material.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Material()..mergeFromBuffer(data, registry);
  factory Material.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Material()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Material',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: Material.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'icon')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'url')
    ..aE<MaterialBizType>(4, _omitFieldNames ? '' : 'type',
        enumValues: MaterialBizType.values)
    ..aOS(5, _omitFieldNames ? '' : 'param')
    ..aOS(6, _omitFieldNames ? '' : 'staticIcon')
    ..aOS(7, _omitFieldNames ? '' : 'bgColor')
    ..aOS(8, _omitFieldNames ? '' : 'bgPic')
    ..aI(9, _omitFieldNames ? '' : 'jumpType')
    ..aE<PageType>(10, _omitFieldNames ? '' : 'pageType',
        enumValues: PageType.values)
    ..aOB(11, _omitFieldNames ? '' : 'needLogin')
    ..m<$core.String, $core.String>(12, _omitFieldNames ? '' : 'report',
        entryClassName: 'Material.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Material clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Material copyWith(void Function(Material) updates) =>
      super.copyWith((message) => updates(message as Material)) as Material;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Material() / Material.new instead')
  static Material create() => Material._();
  static $pb.GeneratedMessage $_createMessage() => Material._();
  @$core.override
  Material createEmptyInstance() => Material._();
  @$core.pragma('dart2js:noInline')
  static Material getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Material>(Material.$_createMessage);
  static Material? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get icon => $_getSZ(0);
  @$pb.TagNumber(1)
  set icon($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIcon() => $_has(0);
  @$pb.TagNumber(1)
  void clearIcon() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get url => $_getSZ(2);
  @$pb.TagNumber(3)
  set url($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  MaterialBizType get type => $_getN(3);
  @$pb.TagNumber(4)
  set type(MaterialBizType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasType() => $_has(3);
  @$pb.TagNumber(4)
  void clearType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get param => $_getSZ(4);
  @$pb.TagNumber(5)
  set param($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasParam() => $_has(4);
  @$pb.TagNumber(5)
  void clearParam() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get staticIcon => $_getSZ(5);
  @$pb.TagNumber(6)
  set staticIcon($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasStaticIcon() => $_has(5);
  @$pb.TagNumber(6)
  void clearStaticIcon() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get bgColor => $_getSZ(6);
  @$pb.TagNumber(7)
  set bgColor($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBgColor() => $_has(6);
  @$pb.TagNumber(7)
  void clearBgColor() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get bgPic => $_getSZ(7);
  @$pb.TagNumber(8)
  set bgPic($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBgPic() => $_has(7);
  @$pb.TagNumber(8)
  void clearBgPic() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get jumpType => $_getIZ(8);
  @$pb.TagNumber(9)
  set jumpType($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasJumpType() => $_has(8);
  @$pb.TagNumber(9)
  void clearJumpType() => $_clearField(9);

  @$pb.TagNumber(10)
  PageType get pageType => $_getN(9);
  @$pb.TagNumber(10)
  set pageType(PageType value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasPageType() => $_has(9);
  @$pb.TagNumber(10)
  void clearPageType() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get needLogin => $_getBF(10);
  @$pb.TagNumber(11)
  set needLogin($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasNeedLogin() => $_has(10);
  @$pb.TagNumber(11)
  void clearNeedLogin() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(11);
}

class OldFan extends $pb.GeneratedMessage {
  factory OldFan({
    $core.int? isFollowDisplay,
    $core.String? wingPic,
  }) {
    final result = OldFan._();
    if (isFollowDisplay != null) result.isFollowDisplay = isFollowDisplay;
    if (wingPic != null) result.wingPic = wingPic;
    return result;
  }

  OldFan._();

  factory OldFan.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OldFan()..mergeFromBuffer(data, registry);
  factory OldFan.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OldFan()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OldFan',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: OldFan.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'isFollowDisplay')
    ..aOS(2, _omitFieldNames ? '' : 'wingPic')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OldFan clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OldFan copyWith(void Function(OldFan) updates) =>
      super.copyWith((message) => updates(message as OldFan)) as OldFan;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OldFan() / OldFan.new instead')
  static OldFan create() => OldFan._();
  static $pb.GeneratedMessage $_createMessage() => OldFan._();
  @$core.override
  OldFan createEmptyInstance() => OldFan._();
  @$core.pragma('dart2js:noInline')
  static OldFan getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OldFan>(OldFan.$_createMessage);
  static OldFan? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get isFollowDisplay => $_getIZ(0);
  @$pb.TagNumber(1)
  set isFollowDisplay($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsFollowDisplay() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsFollowDisplay() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get wingPic => $_getSZ(1);
  @$pb.TagNumber(2)
  set wingPic($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWingPic() => $_has(1);
  @$pb.TagNumber(2)
  void clearWingPic() => $_clearField(2);
}

class Online extends $pb.GeneratedMessage {
  factory Online({
    $core.bool? onlineShow,
  }) {
    final result = Online._();
    if (onlineShow != null) result.onlineShow = onlineShow;
    return result;
  }

  Online._();

  factory Online.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Online()..mergeFromBuffer(data, registry);
  factory Online.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Online()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Online',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: Online.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'onlineShow')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Online clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Online copyWith(void Function(Online) updates) =>
      super.copyWith((message) => updates(message as Online)) as Online;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Online() / Online.new instead')
  static Online create() => Online._();
  static $pb.GeneratedMessage $_createMessage() => Online._();
  @$core.override
  Online createEmptyInstance() => Online._();
  @$core.pragma('dart2js:noInline')
  static Online getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Online>(Online.$_createMessage);
  static Online? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get onlineShow => $_getBF(0);
  @$pb.TagNumber(1)
  set onlineShow($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOnlineShow() => $_has(0);
  @$pb.TagNumber(1)
  void clearOnlineShow() => $_clearField(1);
}

enum OperationCard_Param { follow, reserve, jump, game, gameBackflow, notSet }

class OperationCard extends $pb.GeneratedMessage {
  factory OperationCard({
    $fixnum.Int64? id,
    $core.int? from,
    $core.int? to,
    $core.bool? status,
    BizType? bizType,
    OperationCardContent? content,
    BizFollowVideoParam? follow,
    BizReserveActivityParam? reserve,
    BizJumpLinkParam? jump,
    BizReserveGameParam? game,
    BizGameBackflowParam? gameBackflow,
  }) {
    final result = OperationCard._();
    if (id != null) result.id = id;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (status != null) result.status = status;
    if (bizType != null) result.bizType = bizType;
    if (content != null) result.content = content;
    if (follow != null) result.follow = follow;
    if (reserve != null) result.reserve = reserve;
    if (jump != null) result.jump = jump;
    if (game != null) result.game = game;
    if (gameBackflow != null) result.gameBackflow = gameBackflow;
    return result;
  }

  OperationCard._();

  factory OperationCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OperationCard()..mergeFromBuffer(data, registry);
  factory OperationCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OperationCard()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, OperationCard_Param>
      _OperationCard_ParamByTag = {
    7: OperationCard_Param.follow,
    8: OperationCard_Param.reserve,
    9: OperationCard_Param.jump,
    10: OperationCard_Param.game,
    11: OperationCard_Param.gameBackflow,
    0: OperationCard_Param.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OperationCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: OperationCard.$_createMessage)
    ..oo(0, [7, 8, 9, 10, 11])
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aI(2, _omitFieldNames ? '' : 'from')
    ..aI(3, _omitFieldNames ? '' : 'to')
    ..aOB(4, _omitFieldNames ? '' : 'status')
    ..aE<BizType>(5, _omitFieldNames ? '' : 'bizType',
        enumValues: BizType.values)
    ..aOM<OperationCardContent>(6, _omitFieldNames ? '' : 'content',
        subBuilder: OperationCardContent.$_createMessage)
    ..aOM<BizFollowVideoParam>(7, _omitFieldNames ? '' : 'follow',
        subBuilder: BizFollowVideoParam.$_createMessage)
    ..aOM<BizReserveActivityParam>(8, _omitFieldNames ? '' : 'reserve',
        subBuilder: BizReserveActivityParam.$_createMessage)
    ..aOM<BizJumpLinkParam>(9, _omitFieldNames ? '' : 'jump',
        subBuilder: BizJumpLinkParam.$_createMessage)
    ..aOM<BizReserveGameParam>(10, _omitFieldNames ? '' : 'game',
        subBuilder: BizReserveGameParam.$_createMessage)
    ..aOM<BizGameBackflowParam>(11, _omitFieldNames ? '' : 'gameBackflow',
        subBuilder: BizGameBackflowParam.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperationCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperationCard copyWith(void Function(OperationCard) updates) =>
      super.copyWith((message) => updates(message as OperationCard))
          as OperationCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OperationCard() / OperationCard.new instead')
  static OperationCard create() => OperationCard._();
  static $pb.GeneratedMessage $_createMessage() => OperationCard._();
  @$core.override
  OperationCard createEmptyInstance() => OperationCard._();
  @$core.pragma('dart2js:noInline')
  static OperationCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OperationCard>(
          OperationCard.$_createMessage);
  static OperationCard? _defaultInstance;

  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  OperationCard_Param whichParam() =>
      _OperationCard_ParamByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  void clearParam() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get from => $_getIZ(1);
  @$pb.TagNumber(2)
  set from($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearFrom() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get to => $_getIZ(2);
  @$pb.TagNumber(3)
  set to($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTo() => $_has(2);
  @$pb.TagNumber(3)
  void clearTo() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get status => $_getBF(3);
  @$pb.TagNumber(4)
  set status($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  BizType get bizType => $_getN(4);
  @$pb.TagNumber(5)
  set bizType(BizType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasBizType() => $_has(4);
  @$pb.TagNumber(5)
  void clearBizType() => $_clearField(5);

  @$pb.TagNumber(6)
  OperationCardContent get content => $_getN(5);
  @$pb.TagNumber(6)
  set content(OperationCardContent value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasContent() => $_has(5);
  @$pb.TagNumber(6)
  void clearContent() => $_clearField(6);
  @$pb.TagNumber(6)
  OperationCardContent ensureContent() => $_ensure(5);

  @$pb.TagNumber(7)
  BizFollowVideoParam get follow => $_getN(6);
  @$pb.TagNumber(7)
  set follow(BizFollowVideoParam value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasFollow() => $_has(6);
  @$pb.TagNumber(7)
  void clearFollow() => $_clearField(7);
  @$pb.TagNumber(7)
  BizFollowVideoParam ensureFollow() => $_ensure(6);

  @$pb.TagNumber(8)
  BizReserveActivityParam get reserve => $_getN(7);
  @$pb.TagNumber(8)
  set reserve(BizReserveActivityParam value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasReserve() => $_has(7);
  @$pb.TagNumber(8)
  void clearReserve() => $_clearField(8);
  @$pb.TagNumber(8)
  BizReserveActivityParam ensureReserve() => $_ensure(7);

  @$pb.TagNumber(9)
  BizJumpLinkParam get jump => $_getN(8);
  @$pb.TagNumber(9)
  set jump(BizJumpLinkParam value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasJump() => $_has(8);
  @$pb.TagNumber(9)
  void clearJump() => $_clearField(9);
  @$pb.TagNumber(9)
  BizJumpLinkParam ensureJump() => $_ensure(8);

  @$pb.TagNumber(10)
  BizReserveGameParam get game => $_getN(9);
  @$pb.TagNumber(10)
  set game(BizReserveGameParam value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasGame() => $_has(9);
  @$pb.TagNumber(10)
  void clearGame() => $_clearField(10);
  @$pb.TagNumber(10)
  BizReserveGameParam ensureGame() => $_ensure(9);

  @$pb.TagNumber(11)
  BizGameBackflowParam get gameBackflow => $_getN(10);
  @$pb.TagNumber(11)
  set gameBackflow(BizGameBackflowParam value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasGameBackflow() => $_has(10);
  @$pb.TagNumber(11)
  void clearGameBackflow() => $_clearField(11);
  @$pb.TagNumber(11)
  BizGameBackflowParam ensureGameBackflow() => $_ensure(10);
}

class OperationCardContent extends $pb.GeneratedMessage {
  factory OperationCardContent({
    $core.String? title,
    $core.String? subtitle,
    $core.String? icon,
    $core.String? buttonTitle,
    $core.String? buttonSelectedTitle,
    $core.bool? showSelected,
  }) {
    final result = OperationCardContent._();
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    if (icon != null) result.icon = icon;
    if (buttonTitle != null) result.buttonTitle = buttonTitle;
    if (buttonSelectedTitle != null)
      result.buttonSelectedTitle = buttonSelectedTitle;
    if (showSelected != null) result.showSelected = showSelected;
    return result;
  }

  OperationCardContent._();

  factory OperationCardContent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OperationCardContent()..mergeFromBuffer(data, registry);
  factory OperationCardContent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OperationCardContent()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OperationCardContent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: OperationCardContent.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'subtitle')
    ..aOS(3, _omitFieldNames ? '' : 'icon')
    ..aOS(4, _omitFieldNames ? '' : 'buttonTitle')
    ..aOS(5, _omitFieldNames ? '' : 'buttonSelectedTitle')
    ..aOB(6, _omitFieldNames ? '' : 'showSelected')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperationCardContent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperationCardContent copyWith(void Function(OperationCardContent) updates) =>
      super.copyWith((message) => updates(message as OperationCardContent))
          as OperationCardContent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OperationCardContent() / OperationCardContent.new instead')
  static OperationCardContent create() => OperationCardContent._();
  static $pb.GeneratedMessage $_createMessage() => OperationCardContent._();
  @$core.override
  OperationCardContent createEmptyInstance() => OperationCardContent._();
  @$core.pragma('dart2js:noInline')
  static OperationCardContent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OperationCardContent>(
          OperationCardContent.$_createMessage);
  static OperationCardContent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get subtitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set subtitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubtitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubtitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get icon => $_getSZ(2);
  @$pb.TagNumber(3)
  set icon($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearIcon() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get buttonTitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set buttonTitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasButtonTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearButtonTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get buttonSelectedTitle => $_getSZ(4);
  @$pb.TagNumber(5)
  set buttonSelectedTitle($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasButtonSelectedTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearButtonSelectedTitle() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get showSelected => $_getBF(5);
  @$pb.TagNumber(6)
  set showSelected($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasShowSelected() => $_has(5);
  @$pb.TagNumber(6)
  void clearShowSelected() => $_clearField(6);
}

class PadRelateCM extends $pb.GeneratedMessage {
  factory PadRelateCM({
    RelateCM? cm,
  }) {
    final result = PadRelateCM._();
    if (cm != null) result.cm = cm;
    return result;
  }

  PadRelateCM._();

  factory PadRelateCM.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PadRelateCM()..mergeFromBuffer(data, registry);
  factory PadRelateCM.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PadRelateCM()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PadRelateCM',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: PadRelateCM.$_createMessage)
    ..aOM<RelateCM>(1, _omitFieldNames ? '' : 'cm',
        subBuilder: RelateCM.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PadRelateCM clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PadRelateCM copyWith(void Function(PadRelateCM) updates) =>
      super.copyWith((message) => updates(message as PadRelateCM))
          as PadRelateCM;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PadRelateCM() / PadRelateCM.new instead')
  static PadRelateCM create() => PadRelateCM._();
  static $pb.GeneratedMessage $_createMessage() => PadRelateCM._();
  @$core.override
  PadRelateCM createEmptyInstance() => PadRelateCM._();
  @$core.pragma('dart2js:noInline')
  static PadRelateCM getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PadRelateCM>(
          PadRelateCM.$_createMessage);
  static PadRelateCM? _defaultInstance;

  @$pb.TagNumber(1)
  RelateCM get cm => $_getN(0);
  @$pb.TagNumber(1)
  set cm(RelateCM value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCm() => $_has(0);
  @$pb.TagNumber(1)
  void clearCm() => $_clearField(1);
  @$pb.TagNumber(1)
  RelateCM ensureCm() => $_ensure(0);
}

class PageControl extends $pb.GeneratedMessage {
  factory PageControl({
    Control? toastShow,
    Control? materialShow,
    Control? upShow,
  }) {
    final result = PageControl._();
    if (toastShow != null) result.toastShow = toastShow;
    if (materialShow != null) result.materialShow = materialShow;
    if (upShow != null) result.upShow = upShow;
    return result;
  }

  PageControl._();

  factory PageControl.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PageControl()..mergeFromBuffer(data, registry);
  factory PageControl.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PageControl()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PageControl',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: PageControl.$_createMessage)
    ..aOM<Control>(1, _omitFieldNames ? '' : 'toastShow',
        subBuilder: Control.$_createMessage)
    ..aOM<Control>(2, _omitFieldNames ? '' : 'materialShow',
        subBuilder: Control.$_createMessage)
    ..aOM<Control>(3, _omitFieldNames ? '' : 'upShow',
        subBuilder: Control.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PageControl clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PageControl copyWith(void Function(PageControl) updates) =>
      super.copyWith((message) => updates(message as PageControl))
          as PageControl;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PageControl() / PageControl.new instead')
  static PageControl create() => PageControl._();
  static $pb.GeneratedMessage $_createMessage() => PageControl._();
  @$core.override
  PageControl createEmptyInstance() => PageControl._();
  @$core.pragma('dart2js:noInline')
  static PageControl getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PageControl>(
          PageControl.$_createMessage);
  static PageControl? _defaultInstance;

  @$pb.TagNumber(1)
  Control get toastShow => $_getN(0);
  @$pb.TagNumber(1)
  set toastShow(Control value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasToastShow() => $_has(0);
  @$pb.TagNumber(1)
  void clearToastShow() => $_clearField(1);
  @$pb.TagNumber(1)
  Control ensureToastShow() => $_ensure(0);

  @$pb.TagNumber(2)
  Control get materialShow => $_getN(1);
  @$pb.TagNumber(2)
  set materialShow(Control value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMaterialShow() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaterialShow() => $_clearField(2);
  @$pb.TagNumber(2)
  Control ensureMaterialShow() => $_ensure(1);

  @$pb.TagNumber(3)
  Control get upShow => $_getN(2);
  @$pb.TagNumber(3)
  set upShow(Control value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUpShow() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpShow() => $_clearField(3);
  @$pb.TagNumber(3)
  Control ensureUpShow() => $_ensure(2);
}

class PlayListReqParam extends $pb.GeneratedMessage {
  factory PlayListReqParam({
    $fixnum.Int64? mediaId,
    $fixnum.Int64? bizId,
    $fixnum.Int64? type,
    $core.bool? pageDirection,
    $core.bool? firstPage,
    $fixnum.Int64? offset,
    $fixnum.Int64? sortDesc,
    $fixnum.Int64? sortField,
  }) {
    final result = PlayListReqParam._();
    if (mediaId != null) result.mediaId = mediaId;
    if (bizId != null) result.bizId = bizId;
    if (type != null) result.type = type;
    if (pageDirection != null) result.pageDirection = pageDirection;
    if (firstPage != null) result.firstPage = firstPage;
    if (offset != null) result.offset = offset;
    if (sortDesc != null) result.sortDesc = sortDesc;
    if (sortField != null) result.sortField = sortField;
    return result;
  }

  PlayListReqParam._();

  factory PlayListReqParam.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayListReqParam()..mergeFromBuffer(data, registry);
  factory PlayListReqParam.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayListReqParam()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayListReqParam',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: PlayListReqParam.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'mediaId')
    ..aInt64(2, _omitFieldNames ? '' : 'bizId')
    ..aInt64(3, _omitFieldNames ? '' : 'type')
    ..aOB(4, _omitFieldNames ? '' : 'pageDirection')
    ..aOB(5, _omitFieldNames ? '' : 'firstPage')
    ..aInt64(6, _omitFieldNames ? '' : 'offset')
    ..aInt64(7, _omitFieldNames ? '' : 'sortDesc')
    ..aInt64(8, _omitFieldNames ? '' : 'sortField')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayListReqParam clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayListReqParam copyWith(void Function(PlayListReqParam) updates) =>
      super.copyWith((message) => updates(message as PlayListReqParam))
          as PlayListReqParam;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PlayListReqParam() / PlayListReqParam.new instead')
  static PlayListReqParam create() => PlayListReqParam._();
  static $pb.GeneratedMessage $_createMessage() => PlayListReqParam._();
  @$core.override
  PlayListReqParam createEmptyInstance() => PlayListReqParam._();
  @$core.pragma('dart2js:noInline')
  static PlayListReqParam getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayListReqParam>(
          PlayListReqParam.$_createMessage);
  static PlayListReqParam? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get mediaId => $_getI64(0);
  @$pb.TagNumber(1)
  set mediaId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get bizId => $_getI64(1);
  @$pb.TagNumber(2)
  set bizId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBizId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBizId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get type => $_getI64(2);
  @$pb.TagNumber(3)
  set type($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get pageDirection => $_getBF(3);
  @$pb.TagNumber(4)
  set pageDirection($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageDirection() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageDirection() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get firstPage => $_getBF(4);
  @$pb.TagNumber(5)
  set firstPage($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFirstPage() => $_has(4);
  @$pb.TagNumber(5)
  void clearFirstPage() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get offset => $_getI64(5);
  @$pb.TagNumber(6)
  set offset($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOffset() => $_has(5);
  @$pb.TagNumber(6)
  void clearOffset() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get sortDesc => $_getI64(6);
  @$pb.TagNumber(7)
  set sortDesc($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSortDesc() => $_has(6);
  @$pb.TagNumber(7)
  void clearSortDesc() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get sortField => $_getI64(7);
  @$pb.TagNumber(8)
  set sortField($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSortField() => $_has(7);
  @$pb.TagNumber(8)
  void clearSortField() => $_clearField(8);
}

class PlayToast extends $pb.GeneratedMessage {
  factory PlayToast({
    PlayToastEnum? business,
    $core.String? iconUrl,
    $core.String? text,
  }) {
    final result = PlayToast._();
    if (business != null) result.business = business;
    if (iconUrl != null) result.iconUrl = iconUrl;
    if (text != null) result.text = text;
    return result;
  }

  PlayToast._();

  factory PlayToast.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayToast()..mergeFromBuffer(data, registry);
  factory PlayToast.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayToast()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayToast',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: PlayToast.$_createMessage)
    ..aE<PlayToastEnum>(1, _omitFieldNames ? '' : 'business',
        enumValues: PlayToastEnum.values)
    ..aOS(2, _omitFieldNames ? '' : 'iconUrl')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayToast clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayToast copyWith(void Function(PlayToast) updates) =>
      super.copyWith((message) => updates(message as PlayToast)) as PlayToast;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PlayToast() / PlayToast.new instead')
  static PlayToast create() => PlayToast._();
  static $pb.GeneratedMessage $_createMessage() => PlayToast._();
  @$core.override
  PlayToast createEmptyInstance() => PlayToast._();
  @$core.pragma('dart2js:noInline')
  static PlayToast getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayToast>(PlayToast.$_createMessage);
  static PlayToast? _defaultInstance;

  @$pb.TagNumber(1)
  PlayToastEnum get business => $_getN(0);
  @$pb.TagNumber(1)
  set business(PlayToastEnum value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBusiness() => $_has(0);
  @$pb.TagNumber(1)
  void clearBusiness() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get iconUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set iconUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIconUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearIconUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);
}

class PlayerIcon extends $pb.GeneratedMessage {
  factory PlayerIcon({
    $core.String? url1,
    $core.String? hash1,
    $core.String? url2,
    $core.String? hash2,
    $core.String? dragLeftPng,
    $core.String? middlePng,
    $core.String? dragRightPng,
    IconData? dragData,
    IconData? nodragData,
  }) {
    final result = PlayerIcon._();
    if (url1 != null) result.url1 = url1;
    if (hash1 != null) result.hash1 = hash1;
    if (url2 != null) result.url2 = url2;
    if (hash2 != null) result.hash2 = hash2;
    if (dragLeftPng != null) result.dragLeftPng = dragLeftPng;
    if (middlePng != null) result.middlePng = middlePng;
    if (dragRightPng != null) result.dragRightPng = dragRightPng;
    if (dragData != null) result.dragData = dragData;
    if (nodragData != null) result.nodragData = nodragData;
    return result;
  }

  PlayerIcon._();

  factory PlayerIcon.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayerIcon()..mergeFromBuffer(data, registry);
  factory PlayerIcon.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayerIcon()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerIcon',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: PlayerIcon.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'url1')
    ..aOS(2, _omitFieldNames ? '' : 'hash1')
    ..aOS(3, _omitFieldNames ? '' : 'url2')
    ..aOS(4, _omitFieldNames ? '' : 'hash2')
    ..aOS(5, _omitFieldNames ? '' : 'dragLeftPng')
    ..aOS(6, _omitFieldNames ? '' : 'middlePng')
    ..aOS(7, _omitFieldNames ? '' : 'dragRightPng')
    ..aOM<IconData>(8, _omitFieldNames ? '' : 'dragData',
        subBuilder: IconData.$_createMessage)
    ..aOM<IconData>(9, _omitFieldNames ? '' : 'nodragData',
        subBuilder: IconData.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerIcon clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerIcon copyWith(void Function(PlayerIcon) updates) =>
      super.copyWith((message) => updates(message as PlayerIcon)) as PlayerIcon;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PlayerIcon() / PlayerIcon.new instead')
  static PlayerIcon create() => PlayerIcon._();
  static $pb.GeneratedMessage $_createMessage() => PlayerIcon._();
  @$core.override
  PlayerIcon createEmptyInstance() => PlayerIcon._();
  @$core.pragma('dart2js:noInline')
  static PlayerIcon getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerIcon>(PlayerIcon.$_createMessage);
  static PlayerIcon? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url1 => $_getSZ(0);
  @$pb.TagNumber(1)
  set url1($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl1() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl1() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get hash1 => $_getSZ(1);
  @$pb.TagNumber(2)
  set hash1($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHash1() => $_has(1);
  @$pb.TagNumber(2)
  void clearHash1() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get url2 => $_getSZ(2);
  @$pb.TagNumber(3)
  set url2($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUrl2() => $_has(2);
  @$pb.TagNumber(3)
  void clearUrl2() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get hash2 => $_getSZ(3);
  @$pb.TagNumber(4)
  set hash2($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHash2() => $_has(3);
  @$pb.TagNumber(4)
  void clearHash2() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get dragLeftPng => $_getSZ(4);
  @$pb.TagNumber(5)
  set dragLeftPng($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDragLeftPng() => $_has(4);
  @$pb.TagNumber(5)
  void clearDragLeftPng() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get middlePng => $_getSZ(5);
  @$pb.TagNumber(6)
  set middlePng($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMiddlePng() => $_has(5);
  @$pb.TagNumber(6)
  void clearMiddlePng() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get dragRightPng => $_getSZ(6);
  @$pb.TagNumber(7)
  set dragRightPng($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDragRightPng() => $_has(6);
  @$pb.TagNumber(7)
  void clearDragRightPng() => $_clearField(7);

  @$pb.TagNumber(8)
  IconData get dragData => $_getN(7);
  @$pb.TagNumber(8)
  set dragData(IconData value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDragData() => $_has(7);
  @$pb.TagNumber(8)
  void clearDragData() => $_clearField(8);
  @$pb.TagNumber(8)
  IconData ensureDragData() => $_ensure(7);

  @$pb.TagNumber(9)
  IconData get nodragData => $_getN(8);
  @$pb.TagNumber(9)
  set nodragData(IconData value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasNodragData() => $_has(8);
  @$pb.TagNumber(9)
  void clearNodragData() => $_clearField(9);
  @$pb.TagNumber(9)
  IconData ensureNodragData() => $_ensure(8);
}

class PointMaterial extends $pb.GeneratedMessage {
  factory PointMaterial({
    $core.String? url,
    MaterialSource? materialSource,
  }) {
    final result = PointMaterial._();
    if (url != null) result.url = url;
    if (materialSource != null) result.materialSource = materialSource;
    return result;
  }

  PointMaterial._();

  factory PointMaterial.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PointMaterial()..mergeFromBuffer(data, registry);
  factory PointMaterial.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PointMaterial()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PointMaterial',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: PointMaterial.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aE<MaterialSource>(2, _omitFieldNames ? '' : 'materialSource',
        enumValues: MaterialSource.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PointMaterial clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PointMaterial copyWith(void Function(PointMaterial) updates) =>
      super.copyWith((message) => updates(message as PointMaterial))
          as PointMaterial;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PointMaterial() / PointMaterial.new instead')
  static PointMaterial create() => PointMaterial._();
  static $pb.GeneratedMessage $_createMessage() => PointMaterial._();
  @$core.override
  PointMaterial createEmptyInstance() => PointMaterial._();
  @$core.pragma('dart2js:noInline')
  static PointMaterial getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PointMaterial>(
          PointMaterial.$_createMessage);
  static PointMaterial? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  MaterialSource get materialSource => $_getN(1);
  @$pb.TagNumber(2)
  set materialSource(MaterialSource value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMaterialSource() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaterialSource() => $_clearField(2);
}

class Relate extends $pb.GeneratedMessage {
  factory Relate({
    $fixnum.Int64? deviceType,
    $3.Pagination? pagination,
  }) {
    final result = Relate._();
    if (deviceType != null) result.deviceType = deviceType;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  Relate._();

  factory Relate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Relate()..mergeFromBuffer(data, registry);
  factory Relate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Relate()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Relate',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: Relate.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'deviceType')
    ..aOM<$3.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $3.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Relate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Relate copyWith(void Function(Relate) updates) =>
      super.copyWith((message) => updates(message as Relate)) as Relate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Relate() / Relate.new instead')
  static Relate create() => Relate._();
  static $pb.GeneratedMessage $_createMessage() => Relate._();
  @$core.override
  Relate createEmptyInstance() => Relate._();
  @$core.pragma('dart2js:noInline')
  static Relate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Relate>(Relate.$_createMessage);
  static Relate? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get deviceType => $_getI64(0);
  @$pb.TagNumber(1)
  set deviceType($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceType() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceType() => $_clearField(1);

  @$pb.TagNumber(2)
  $3.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($3.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $3.Pagination ensurePagination() => $_ensure(1);
}

class RelateCM extends $pb.GeneratedMessage {
  factory RelateCM({
    $fixnum.Int64? aid,
    $2.Any? sourceContent,
    $fixnum.Int64? duration,
    $1.Stat? stat,
    $1.Owner? owner,
  }) {
    final result = RelateCM._();
    if (aid != null) result.aid = aid;
    if (sourceContent != null) result.sourceContent = sourceContent;
    if (duration != null) result.duration = duration;
    if (stat != null) result.stat = stat;
    if (owner != null) result.owner = owner;
    return result;
  }

  RelateCM._();

  factory RelateCM.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateCM()..mergeFromBuffer(data, registry);
  factory RelateCM.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateCM()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelateCM',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: RelateCM.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aOM<$2.Any>(2, _omitFieldNames ? '' : 'sourceContent',
        subBuilder: $2.Any.$_createMessage)
    ..aInt64(3, _omitFieldNames ? '' : 'duration')
    ..aOM<$1.Stat>(4, _omitFieldNames ? '' : 'stat',
        subBuilder: $1.Stat.$_createMessage)
    ..aOM<$1.Owner>(5, _omitFieldNames ? '' : 'owner',
        subBuilder: $1.Owner.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateCM clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateCM copyWith(void Function(RelateCM) updates) =>
      super.copyWith((message) => updates(message as RelateCM)) as RelateCM;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RelateCM() / RelateCM.new instead')
  static RelateCM create() => RelateCM._();
  static $pb.GeneratedMessage $_createMessage() => RelateCM._();
  @$core.override
  RelateCM createEmptyInstance() => RelateCM._();
  @$core.pragma('dart2js:noInline')
  static RelateCM getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RelateCM>(RelateCM.$_createMessage);
  static RelateCM? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get aid => $_getI64(0);
  @$pb.TagNumber(1)
  set aid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.Any get sourceContent => $_getN(1);
  @$pb.TagNumber(2)
  set sourceContent($2.Any value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSourceContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearSourceContent() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Any ensureSourceContent() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get duration => $_getI64(2);
  @$pb.TagNumber(3)
  set duration($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDuration() => $_has(2);
  @$pb.TagNumber(3)
  void clearDuration() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.Stat get stat => $_getN(3);
  @$pb.TagNumber(4)
  set stat($1.Stat value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStat() => $_has(3);
  @$pb.TagNumber(4)
  void clearStat() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Stat ensureStat() => $_ensure(3);

  @$pb.TagNumber(5)
  $1.Owner get owner => $_getN(4);
  @$pb.TagNumber(5)
  set owner($1.Owner value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasOwner() => $_has(4);
  @$pb.TagNumber(5)
  void clearOwner() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Owner ensureOwner() => $_ensure(4);
}

class RelatesFeedReply extends $pb.GeneratedMessage {
  factory RelatesFeedReply({
    $core.Iterable<$1.RelateCard>? relates,
    $3.Pagination? pagination,
  }) {
    final result = RelatesFeedReply._();
    if (relates != null) result.relates.addAll(relates);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  RelatesFeedReply._();

  factory RelatesFeedReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelatesFeedReply()..mergeFromBuffer(data, registry);
  factory RelatesFeedReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelatesFeedReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelatesFeedReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: RelatesFeedReply.$_createMessage)
    ..pPM<$1.RelateCard>(1, _omitFieldNames ? '' : 'relates',
        subBuilder: $1.RelateCard.$_createMessage)
    ..aOM<$3.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $3.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelatesFeedReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelatesFeedReply copyWith(void Function(RelatesFeedReply) updates) =>
      super.copyWith((message) => updates(message as RelatesFeedReply))
          as RelatesFeedReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RelatesFeedReply() / RelatesFeedReply.new instead')
  static RelatesFeedReply create() => RelatesFeedReply._();
  static $pb.GeneratedMessage $_createMessage() => RelatesFeedReply._();
  @$core.override
  RelatesFeedReply createEmptyInstance() => RelatesFeedReply._();
  @$core.pragma('dart2js:noInline')
  static RelatesFeedReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RelatesFeedReply>(
          RelatesFeedReply.$_createMessage);
  static RelatesFeedReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.RelateCard> get relates => $_getList(0);

  @$pb.TagNumber(2)
  $3.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($3.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $3.Pagination ensurePagination() => $_ensure(1);
}

class RelatesFeedReq extends $pb.GeneratedMessage {
  factory RelatesFeedReq({
    $fixnum.Int64? aid,
    $core.String? bvid,
    $core.String? from,
    $core.String? spmid,
    $core.String? fromSpmid,
    $4.PlayerArgs? playerArgs,
    $3.Pagination? pagination,
    $core.String? sessionId,
    $fixnum.Int64? autoPlay,
    $core.String? fromTrackId,
    $core.String? bizExtra,
    $core.String? adExtra,
    $fixnum.Int64? tabCategory,
    $core.String? tabCategoryName,
  }) {
    final result = RelatesFeedReq._();
    if (aid != null) result.aid = aid;
    if (bvid != null) result.bvid = bvid;
    if (from != null) result.from = from;
    if (spmid != null) result.spmid = spmid;
    if (fromSpmid != null) result.fromSpmid = fromSpmid;
    if (playerArgs != null) result.playerArgs = playerArgs;
    if (pagination != null) result.pagination = pagination;
    if (sessionId != null) result.sessionId = sessionId;
    if (autoPlay != null) result.autoPlay = autoPlay;
    if (fromTrackId != null) result.fromTrackId = fromTrackId;
    if (bizExtra != null) result.bizExtra = bizExtra;
    if (adExtra != null) result.adExtra = adExtra;
    if (tabCategory != null) result.tabCategory = tabCategory;
    if (tabCategoryName != null) result.tabCategoryName = tabCategoryName;
    return result;
  }

  RelatesFeedReq._();

  factory RelatesFeedReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelatesFeedReq()..mergeFromBuffer(data, registry);
  factory RelatesFeedReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelatesFeedReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelatesFeedReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: RelatesFeedReq.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aOS(2, _omitFieldNames ? '' : 'bvid')
    ..aOS(3, _omitFieldNames ? '' : 'from')
    ..aOS(4, _omitFieldNames ? '' : 'spmid')
    ..aOS(5, _omitFieldNames ? '' : 'fromSpmid')
    ..aOM<$4.PlayerArgs>(6, _omitFieldNames ? '' : 'playerArgs',
        subBuilder: $4.PlayerArgs.$_createMessage)
    ..aOM<$3.Pagination>(7, _omitFieldNames ? '' : 'pagination',
        subBuilder: $3.Pagination.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'sessionId')
    ..aInt64(9, _omitFieldNames ? '' : 'autoPlay')
    ..aOS(10, _omitFieldNames ? '' : 'fromTrackId')
    ..aOS(11, _omitFieldNames ? '' : 'bizExtra')
    ..aOS(12, _omitFieldNames ? '' : 'adExtra')
    ..aInt64(13, _omitFieldNames ? '' : 'tabCategory')
    ..aOS(14, _omitFieldNames ? '' : 'tabCategoryName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelatesFeedReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelatesFeedReq copyWith(void Function(RelatesFeedReq) updates) =>
      super.copyWith((message) => updates(message as RelatesFeedReq))
          as RelatesFeedReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RelatesFeedReq() / RelatesFeedReq.new instead')
  static RelatesFeedReq create() => RelatesFeedReq._();
  static $pb.GeneratedMessage $_createMessage() => RelatesFeedReq._();
  @$core.override
  RelatesFeedReq createEmptyInstance() => RelatesFeedReq._();
  @$core.pragma('dart2js:noInline')
  static RelatesFeedReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RelatesFeedReq>(
          RelatesFeedReq.$_createMessage);
  static RelatesFeedReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get aid => $_getI64(0);
  @$pb.TagNumber(1)
  set aid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get bvid => $_getSZ(1);
  @$pb.TagNumber(2)
  set bvid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBvid() => $_has(1);
  @$pb.TagNumber(2)
  void clearBvid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get from => $_getSZ(2);
  @$pb.TagNumber(3)
  set from($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFrom() => $_has(2);
  @$pb.TagNumber(3)
  void clearFrom() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get spmid => $_getSZ(3);
  @$pb.TagNumber(4)
  set spmid($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSpmid() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpmid() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get fromSpmid => $_getSZ(4);
  @$pb.TagNumber(5)
  set fromSpmid($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFromSpmid() => $_has(4);
  @$pb.TagNumber(5)
  void clearFromSpmid() => $_clearField(5);

  @$pb.TagNumber(6)
  $4.PlayerArgs get playerArgs => $_getN(5);
  @$pb.TagNumber(6)
  set playerArgs($4.PlayerArgs value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPlayerArgs() => $_has(5);
  @$pb.TagNumber(6)
  void clearPlayerArgs() => $_clearField(6);
  @$pb.TagNumber(6)
  $4.PlayerArgs ensurePlayerArgs() => $_ensure(5);

  @$pb.TagNumber(7)
  $3.Pagination get pagination => $_getN(6);
  @$pb.TagNumber(7)
  set pagination($3.Pagination value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPagination() => $_has(6);
  @$pb.TagNumber(7)
  void clearPagination() => $_clearField(7);
  @$pb.TagNumber(7)
  $3.Pagination ensurePagination() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get sessionId => $_getSZ(7);
  @$pb.TagNumber(8)
  set sessionId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSessionId() => $_has(7);
  @$pb.TagNumber(8)
  void clearSessionId() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get autoPlay => $_getI64(8);
  @$pb.TagNumber(9)
  set autoPlay($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAutoPlay() => $_has(8);
  @$pb.TagNumber(9)
  void clearAutoPlay() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get fromTrackId => $_getSZ(9);
  @$pb.TagNumber(10)
  set fromTrackId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasFromTrackId() => $_has(9);
  @$pb.TagNumber(10)
  void clearFromTrackId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get bizExtra => $_getSZ(10);
  @$pb.TagNumber(11)
  set bizExtra($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasBizExtra() => $_has(10);
  @$pb.TagNumber(11)
  void clearBizExtra() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get adExtra => $_getSZ(11);
  @$pb.TagNumber(12)
  set adExtra($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAdExtra() => $_has(11);
  @$pb.TagNumber(12)
  void clearAdExtra() => $_clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get tabCategory => $_getI64(12);
  @$pb.TagNumber(13)
  set tabCategory($fixnum.Int64 value) => $_setInt64(12, value);
  @$pb.TagNumber(13)
  $core.bool hasTabCategory() => $_has(12);
  @$pb.TagNumber(13)
  void clearTabCategory() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get tabCategoryName => $_getSZ(13);
  @$pb.TagNumber(14)
  set tabCategoryName($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasTabCategoryName() => $_has(13);
  @$pb.TagNumber(14)
  void clearTabCategoryName() => $_clearField(14);
}

class ReplyStyle extends $pb.GeneratedMessage {
  factory ReplyStyle({
    $core.String? badgeUrl,
    $core.String? badgeText,
    $fixnum.Int64? badgeType,
  }) {
    final result = ReplyStyle._();
    if (badgeUrl != null) result.badgeUrl = badgeUrl;
    if (badgeText != null) result.badgeText = badgeText;
    if (badgeType != null) result.badgeType = badgeType;
    return result;
  }

  ReplyStyle._();

  factory ReplyStyle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReplyStyle()..mergeFromBuffer(data, registry);
  factory ReplyStyle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReplyStyle()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyStyle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: ReplyStyle.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'badgeUrl')
    ..aOS(2, _omitFieldNames ? '' : 'badgeText')
    ..aInt64(3, _omitFieldNames ? '' : 'badgeType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyStyle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyStyle copyWith(void Function(ReplyStyle) updates) =>
      super.copyWith((message) => updates(message as ReplyStyle)) as ReplyStyle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReplyStyle() / ReplyStyle.new instead')
  static ReplyStyle create() => ReplyStyle._();
  static $pb.GeneratedMessage $_createMessage() => ReplyStyle._();
  @$core.override
  ReplyStyle createEmptyInstance() => ReplyStyle._();
  @$core.pragma('dart2js:noInline')
  static ReplyStyle getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyStyle>(ReplyStyle.$_createMessage);
  static ReplyStyle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get badgeUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set badgeUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBadgeUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearBadgeUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get badgeText => $_getSZ(1);
  @$pb.TagNumber(2)
  set badgeText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBadgeText() => $_has(1);
  @$pb.TagNumber(2)
  void clearBadgeText() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get badgeType => $_getI64(2);
  @$pb.TagNumber(3)
  set badgeType($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBadgeType() => $_has(2);
  @$pb.TagNumber(3)
  void clearBadgeType() => $_clearField(3);
}

class ReplyTab extends $pb.GeneratedMessage {
  factory ReplyTab({
    ReplyStyle? replyStyle,
    $core.String? title,
    TabControl? control,
  }) {
    final result = ReplyTab._();
    if (replyStyle != null) result.replyStyle = replyStyle;
    if (title != null) result.title = title;
    if (control != null) result.control = control;
    return result;
  }

  ReplyTab._();

  factory ReplyTab.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReplyTab()..mergeFromBuffer(data, registry);
  factory ReplyTab.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReplyTab()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyTab',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: ReplyTab.$_createMessage)
    ..aOM<ReplyStyle>(1, _omitFieldNames ? '' : 'replyStyle',
        subBuilder: ReplyStyle.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOM<TabControl>(3, _omitFieldNames ? '' : 'control',
        subBuilder: TabControl.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyTab clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyTab copyWith(void Function(ReplyTab) updates) =>
      super.copyWith((message) => updates(message as ReplyTab)) as ReplyTab;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReplyTab() / ReplyTab.new instead')
  static ReplyTab create() => ReplyTab._();
  static $pb.GeneratedMessage $_createMessage() => ReplyTab._();
  @$core.override
  ReplyTab createEmptyInstance() => ReplyTab._();
  @$core.pragma('dart2js:noInline')
  static ReplyTab getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyTab>(ReplyTab.$_createMessage);
  static ReplyTab? _defaultInstance;

  @$pb.TagNumber(1)
  ReplyStyle get replyStyle => $_getN(0);
  @$pb.TagNumber(1)
  set replyStyle(ReplyStyle value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReplyStyle() => $_has(0);
  @$pb.TagNumber(1)
  void clearReplyStyle() => $_clearField(1);
  @$pb.TagNumber(1)
  ReplyStyle ensureReplyStyle() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  TabControl get control => $_getN(2);
  @$pb.TagNumber(3)
  set control(TabControl value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasControl() => $_has(2);
  @$pb.TagNumber(3)
  void clearControl() => $_clearField(3);
  @$pb.TagNumber(3)
  TabControl ensureControl() => $_ensure(2);
}

class ReqUser extends $pb.GeneratedMessage {
  factory ReqUser({
    $core.int? favorite,
    $core.int? like,
    $core.int? coin,
    $core.int? favSeason,
    $core.int? follow,
    $core.int? dislike,
    Button? elecPlusBtn,
    ChargingPlus? chargingPlus,
    ReqUserExtra? extra,
    $core.int? paid,
    OldFan? oldFan,
  }) {
    final result = ReqUser._();
    if (favorite != null) result.favorite = favorite;
    if (like != null) result.like = like;
    if (coin != null) result.coin = coin;
    if (favSeason != null) result.favSeason = favSeason;
    if (follow != null) result.follow = follow;
    if (dislike != null) result.dislike = dislike;
    if (elecPlusBtn != null) result.elecPlusBtn = elecPlusBtn;
    if (chargingPlus != null) result.chargingPlus = chargingPlus;
    if (extra != null) result.extra = extra;
    if (paid != null) result.paid = paid;
    if (oldFan != null) result.oldFan = oldFan;
    return result;
  }

  ReqUser._();

  factory ReqUser.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReqUser()..mergeFromBuffer(data, registry);
  factory ReqUser.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReqUser()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReqUser',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: ReqUser.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'favorite')
    ..aI(2, _omitFieldNames ? '' : 'like')
    ..aI(3, _omitFieldNames ? '' : 'coin')
    ..aI(4, _omitFieldNames ? '' : 'favSeason')
    ..aI(5, _omitFieldNames ? '' : 'follow')
    ..aI(6, _omitFieldNames ? '' : 'dislike')
    ..aOM<Button>(7, _omitFieldNames ? '' : 'elecPlusBtn',
        subBuilder: Button.$_createMessage)
    ..aOM<ChargingPlus>(8, _omitFieldNames ? '' : 'chargingPlus',
        subBuilder: ChargingPlus.$_createMessage)
    ..aOM<ReqUserExtra>(9, _omitFieldNames ? '' : 'extra',
        subBuilder: ReqUserExtra.$_createMessage)
    ..aI(10, _omitFieldNames ? '' : 'paid')
    ..aOM<OldFan>(11, _omitFieldNames ? '' : 'oldFan',
        subBuilder: OldFan.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReqUser clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReqUser copyWith(void Function(ReqUser) updates) =>
      super.copyWith((message) => updates(message as ReqUser)) as ReqUser;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReqUser() / ReqUser.new instead')
  static ReqUser create() => ReqUser._();
  static $pb.GeneratedMessage $_createMessage() => ReqUser._();
  @$core.override
  ReqUser createEmptyInstance() => ReqUser._();
  @$core.pragma('dart2js:noInline')
  static ReqUser getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReqUser>(ReqUser.$_createMessage);
  static ReqUser? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get favorite => $_getIZ(0);
  @$pb.TagNumber(1)
  set favorite($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFavorite() => $_has(0);
  @$pb.TagNumber(1)
  void clearFavorite() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get like => $_getIZ(1);
  @$pb.TagNumber(2)
  set like($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLike() => $_has(1);
  @$pb.TagNumber(2)
  void clearLike() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get coin => $_getIZ(2);
  @$pb.TagNumber(3)
  set coin($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCoin() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoin() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get favSeason => $_getIZ(3);
  @$pb.TagNumber(4)
  set favSeason($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFavSeason() => $_has(3);
  @$pb.TagNumber(4)
  void clearFavSeason() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get follow => $_getIZ(4);
  @$pb.TagNumber(5)
  set follow($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFollow() => $_has(4);
  @$pb.TagNumber(5)
  void clearFollow() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get dislike => $_getIZ(5);
  @$pb.TagNumber(6)
  set dislike($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDislike() => $_has(5);
  @$pb.TagNumber(6)
  void clearDislike() => $_clearField(6);

  @$pb.TagNumber(7)
  Button get elecPlusBtn => $_getN(6);
  @$pb.TagNumber(7)
  set elecPlusBtn(Button value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasElecPlusBtn() => $_has(6);
  @$pb.TagNumber(7)
  void clearElecPlusBtn() => $_clearField(7);
  @$pb.TagNumber(7)
  Button ensureElecPlusBtn() => $_ensure(6);

  @$pb.TagNumber(8)
  ChargingPlus get chargingPlus => $_getN(7);
  @$pb.TagNumber(8)
  set chargingPlus(ChargingPlus value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasChargingPlus() => $_has(7);
  @$pb.TagNumber(8)
  void clearChargingPlus() => $_clearField(8);
  @$pb.TagNumber(8)
  ChargingPlus ensureChargingPlus() => $_ensure(7);

  @$pb.TagNumber(9)
  ReqUserExtra get extra => $_getN(8);
  @$pb.TagNumber(9)
  set extra(ReqUserExtra value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasExtra() => $_has(8);
  @$pb.TagNumber(9)
  void clearExtra() => $_clearField(9);
  @$pb.TagNumber(9)
  ReqUserExtra ensureExtra() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.int get paid => $_getIZ(9);
  @$pb.TagNumber(10)
  set paid($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPaid() => $_has(9);
  @$pb.TagNumber(10)
  void clearPaid() => $_clearField(10);

  @$pb.TagNumber(11)
  OldFan get oldFan => $_getN(10);
  @$pb.TagNumber(11)
  set oldFan(OldFan value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasOldFan() => $_has(10);
  @$pb.TagNumber(11)
  void clearOldFan() => $_clearField(11);
  @$pb.TagNumber(11)
  OldFan ensureOldFan() => $_ensure(10);
}

class ReqUserExtra extends $pb.GeneratedMessage {
  factory ReqUserExtra({
    $core.bool? userFlagNew,
  }) {
    final result = ReqUserExtra._();
    if (userFlagNew != null) result.userFlagNew = userFlagNew;
    return result;
  }

  ReqUserExtra._();

  factory ReqUserExtra.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReqUserExtra()..mergeFromBuffer(data, registry);
  factory ReqUserExtra.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReqUserExtra()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReqUserExtra',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: ReqUserExtra.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'userFlagNew')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReqUserExtra clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReqUserExtra copyWith(void Function(ReqUserExtra) updates) =>
      super.copyWith((message) => updates(message as ReqUserExtra))
          as ReqUserExtra;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReqUserExtra() / ReqUserExtra.new instead')
  static ReqUserExtra create() => ReqUserExtra._();
  static $pb.GeneratedMessage $_createMessage() => ReqUserExtra._();
  @$core.override
  ReqUserExtra createEmptyInstance() => ReqUserExtra._();
  @$core.pragma('dart2js:noInline')
  static ReqUserExtra getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReqUserExtra>(
          ReqUserExtra.$_createMessage);
  static ReqUserExtra? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get userFlagNew => $_getBF(0);
  @$pb.TagNumber(1)
  set userFlagNew($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserFlagNew() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserFlagNew() => $_clearField(1);
}

class Rights extends $pb.GeneratedMessage {
  factory Rights({
    $core.bool? onlyVipDownload,
    $core.bool? noReprint,
    $core.bool? download,
    $core.bool? isChargingPay,
  }) {
    final result = Rights._();
    if (onlyVipDownload != null) result.onlyVipDownload = onlyVipDownload;
    if (noReprint != null) result.noReprint = noReprint;
    if (download != null) result.download = download;
    if (isChargingPay != null) result.isChargingPay = isChargingPay;
    return result;
  }

  Rights._();

  factory Rights.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Rights()..mergeFromBuffer(data, registry);
  factory Rights.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Rights()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Rights',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: Rights.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'onlyVipDownload')
    ..aOB(2, _omitFieldNames ? '' : 'noReprint')
    ..aOB(3, _omitFieldNames ? '' : 'download')
    ..aOB(4, _omitFieldNames ? '' : 'isChargingPay')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Rights clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Rights copyWith(void Function(Rights) updates) =>
      super.copyWith((message) => updates(message as Rights)) as Rights;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Rights() / Rights.new instead')
  static Rights create() => Rights._();
  static $pb.GeneratedMessage $_createMessage() => Rights._();
  @$core.override
  Rights createEmptyInstance() => Rights._();
  @$core.pragma('dart2js:noInline')
  static Rights getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Rights>(Rights.$_createMessage);
  static Rights? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get onlyVipDownload => $_getBF(0);
  @$pb.TagNumber(1)
  set onlyVipDownload($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOnlyVipDownload() => $_has(0);
  @$pb.TagNumber(1)
  void clearOnlyVipDownload() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get noReprint => $_getBF(1);
  @$pb.TagNumber(2)
  set noReprint($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNoReprint() => $_has(1);
  @$pb.TagNumber(2)
  void clearNoReprint() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get download => $_getBF(2);
  @$pb.TagNumber(3)
  set download($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDownload() => $_has(2);
  @$pb.TagNumber(3)
  void clearDownload() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isChargingPay => $_getBF(3);
  @$pb.TagNumber(4)
  set isChargingPay($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsChargingPay() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsChargingPay() => $_clearField(4);
}

class ShowTime extends $pb.GeneratedMessage {
  factory ShowTime({
    $core.int? startTime,
    $core.int? endTime,
    $core.double? posX,
    $core.double? posY,
  }) {
    final result = ShowTime._();
    if (startTime != null) result.startTime = startTime;
    if (endTime != null) result.endTime = endTime;
    if (posX != null) result.posX = posX;
    if (posY != null) result.posY = posY;
    return result;
  }

  ShowTime._();

  factory ShowTime.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShowTime()..mergeFromBuffer(data, registry);
  factory ShowTime.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ShowTime()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShowTime',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: ShowTime.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'startTime')
    ..aI(2, _omitFieldNames ? '' : 'endTime')
    ..aD(3, _omitFieldNames ? '' : 'posX')
    ..aD(4, _omitFieldNames ? '' : 'posY')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShowTime clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShowTime copyWith(void Function(ShowTime) updates) =>
      super.copyWith((message) => updates(message as ShowTime)) as ShowTime;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ShowTime() / ShowTime.new instead')
  static ShowTime create() => ShowTime._();
  static $pb.GeneratedMessage $_createMessage() => ShowTime._();
  @$core.override
  ShowTime createEmptyInstance() => ShowTime._();
  @$core.pragma('dart2js:noInline')
  static ShowTime getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShowTime>(ShowTime.$_createMessage);
  static ShowTime? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get startTime => $_getIZ(0);
  @$pb.TagNumber(1)
  set startTime($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStartTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearStartTime() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get endTime => $_getIZ(1);
  @$pb.TagNumber(2)
  set endTime($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEndTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndTime() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get posX => $_getN(2);
  @$pb.TagNumber(3)
  set posX($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPosX() => $_has(2);
  @$pb.TagNumber(3)
  void clearPosX() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get posY => $_getN(3);
  @$pb.TagNumber(4)
  set posY($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPosY() => $_has(3);
  @$pb.TagNumber(4)
  void clearPosY() => $_clearField(4);
}

class SimpleArc extends $pb.GeneratedMessage {
  factory SimpleArc({
    $core.int? copyright,
  }) {
    final result = SimpleArc._();
    if (copyright != null) result.copyright = copyright;
    return result;
  }

  SimpleArc._();

  factory SimpleArc.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SimpleArc()..mergeFromBuffer(data, registry);
  factory SimpleArc.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SimpleArc()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SimpleArc',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: SimpleArc.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'copyright')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SimpleArc clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SimpleArc copyWith(void Function(SimpleArc) updates) =>
      super.copyWith((message) => updates(message as SimpleArc)) as SimpleArc;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SimpleArc() / SimpleArc.new instead')
  static SimpleArc create() => SimpleArc._();
  static $pb.GeneratedMessage $_createMessage() => SimpleArc._();
  @$core.override
  SimpleArc createEmptyInstance() => SimpleArc._();
  @$core.pragma('dart2js:noInline')
  static SimpleArc getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SimpleArc>(SimpleArc.$_createMessage);
  static SimpleArc? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get copyright => $_getIZ(0);
  @$pb.TagNumber(1)
  set copyright($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCopyright() => $_has(0);
  @$pb.TagNumber(1)
  void clearCopyright() => $_clearField(1);
}

class SimpleOwner extends $pb.GeneratedMessage {
  factory SimpleOwner({
    $1.AttentionRelationStatus? attentionRelation,
  }) {
    final result = SimpleOwner._();
    if (attentionRelation != null) result.attentionRelation = attentionRelation;
    return result;
  }

  SimpleOwner._();

  factory SimpleOwner.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SimpleOwner()..mergeFromBuffer(data, registry);
  factory SimpleOwner.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SimpleOwner()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SimpleOwner',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: SimpleOwner.$_createMessage)
    ..aE<$1.AttentionRelationStatus>(
        1, _omitFieldNames ? '' : 'attentionRelation',
        enumValues: $1.AttentionRelationStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SimpleOwner clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SimpleOwner copyWith(void Function(SimpleOwner) updates) =>
      super.copyWith((message) => updates(message as SimpleOwner))
          as SimpleOwner;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SimpleOwner() / SimpleOwner.new instead')
  static SimpleOwner create() => SimpleOwner._();
  static $pb.GeneratedMessage $_createMessage() => SimpleOwner._();
  @$core.override
  SimpleOwner createEmptyInstance() => SimpleOwner._();
  @$core.pragma('dart2js:noInline')
  static SimpleOwner getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SimpleOwner>(
          SimpleOwner.$_createMessage);
  static SimpleOwner? _defaultInstance;

  @$pb.TagNumber(1)
  $1.AttentionRelationStatus get attentionRelation => $_getN(0);
  @$pb.TagNumber(1)
  set attentionRelation($1.AttentionRelationStatus value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAttentionRelation() => $_has(0);
  @$pb.TagNumber(1)
  void clearAttentionRelation() => $_clearField(1);
}

class SimpleReqUser extends $pb.GeneratedMessage {
  factory SimpleReqUser({
    $core.int? favorite,
    $core.int? like,
    $core.int? coin,
  }) {
    final result = SimpleReqUser._();
    if (favorite != null) result.favorite = favorite;
    if (like != null) result.like = like;
    if (coin != null) result.coin = coin;
    return result;
  }

  SimpleReqUser._();

  factory SimpleReqUser.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SimpleReqUser()..mergeFromBuffer(data, registry);
  factory SimpleReqUser.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SimpleReqUser()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SimpleReqUser',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: SimpleReqUser.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'favorite')
    ..aI(2, _omitFieldNames ? '' : 'like')
    ..aI(3, _omitFieldNames ? '' : 'coin')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SimpleReqUser clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SimpleReqUser copyWith(void Function(SimpleReqUser) updates) =>
      super.copyWith((message) => updates(message as SimpleReqUser))
          as SimpleReqUser;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SimpleReqUser() / SimpleReqUser.new instead')
  static SimpleReqUser create() => SimpleReqUser._();
  static $pb.GeneratedMessage $_createMessage() => SimpleReqUser._();
  @$core.override
  SimpleReqUser createEmptyInstance() => SimpleReqUser._();
  @$core.pragma('dart2js:noInline')
  static SimpleReqUser getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SimpleReqUser>(
          SimpleReqUser.$_createMessage);
  static SimpleReqUser? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get favorite => $_getIZ(0);
  @$pb.TagNumber(1)
  set favorite($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFavorite() => $_has(0);
  @$pb.TagNumber(1)
  void clearFavorite() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get like => $_getIZ(1);
  @$pb.TagNumber(2)
  set like($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLike() => $_has(1);
  @$pb.TagNumber(2)
  void clearLike() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get coin => $_getIZ(2);
  @$pb.TagNumber(3)
  set coin($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCoin() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoin() => $_clearField(3);
}

class SourceContentAV extends $pb.GeneratedMessage {
  factory SourceContentAV({
    $fixnum.Int64? aid,
    $1.Stat? stat,
  }) {
    final result = SourceContentAV._();
    if (aid != null) result.aid = aid;
    if (stat != null) result.stat = stat;
    return result;
  }

  SourceContentAV._();

  factory SourceContentAV.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SourceContentAV()..mergeFromBuffer(data, registry);
  factory SourceContentAV.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SourceContentAV()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SourceContentAV',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: SourceContentAV.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aOM<$1.Stat>(2, _omitFieldNames ? '' : 'stat',
        subBuilder: $1.Stat.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SourceContentAV clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SourceContentAV copyWith(void Function(SourceContentAV) updates) =>
      super.copyWith((message) => updates(message as SourceContentAV))
          as SourceContentAV;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SourceContentAV() / SourceContentAV.new instead')
  static SourceContentAV create() => SourceContentAV._();
  static $pb.GeneratedMessage $_createMessage() => SourceContentAV._();
  @$core.override
  SourceContentAV createEmptyInstance() => SourceContentAV._();
  @$core.pragma('dart2js:noInline')
  static SourceContentAV getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SourceContentAV>(
          SourceContentAV.$_createMessage);
  static SourceContentAV? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get aid => $_getI64(0);
  @$pb.TagNumber(1)
  set aid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Stat get stat => $_getN(1);
  @$pb.TagNumber(2)
  set stat($1.Stat value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStat() => $_has(1);
  @$pb.TagNumber(2)
  void clearStat() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Stat ensureStat() => $_ensure(1);
}

enum SourceContentItem_Data { av, notSet }

class SourceContentItem extends $pb.GeneratedMessage {
  factory SourceContentItem({
    $2.Any? sourceContent,
    SourceContentType? scType,
    SourceContentAV? av,
  }) {
    final result = SourceContentItem._();
    if (sourceContent != null) result.sourceContent = sourceContent;
    if (scType != null) result.scType = scType;
    if (av != null) result.av = av;
    return result;
  }

  SourceContentItem._();

  factory SourceContentItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SourceContentItem()..mergeFromBuffer(data, registry);
  factory SourceContentItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SourceContentItem()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SourceContentItem_Data>
      _SourceContentItem_DataByTag = {
    3: SourceContentItem_Data.av,
    0: SourceContentItem_Data.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SourceContentItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: SourceContentItem.$_createMessage)
    ..oo(0, [3])
    ..aOM<$2.Any>(1, _omitFieldNames ? '' : 'sourceContent',
        subBuilder: $2.Any.$_createMessage)
    ..aE<SourceContentType>(2, _omitFieldNames ? '' : 'scType',
        enumValues: SourceContentType.values)
    ..aOM<SourceContentAV>(3, _omitFieldNames ? '' : 'av',
        subBuilder: SourceContentAV.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SourceContentItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SourceContentItem copyWith(void Function(SourceContentItem) updates) =>
      super.copyWith((message) => updates(message as SourceContentItem))
          as SourceContentItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SourceContentItem() / SourceContentItem.new instead')
  static SourceContentItem create() => SourceContentItem._();
  static $pb.GeneratedMessage $_createMessage() => SourceContentItem._();
  @$core.override
  SourceContentItem createEmptyInstance() => SourceContentItem._();
  @$core.pragma('dart2js:noInline')
  static SourceContentItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SourceContentItem>(
          SourceContentItem.$_createMessage);
  static SourceContentItem? _defaultInstance;

  @$pb.TagNumber(3)
  SourceContentItem_Data whichData() =>
      _SourceContentItem_DataByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(3)
  void clearData() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $2.Any get sourceContent => $_getN(0);
  @$pb.TagNumber(1)
  set sourceContent($2.Any value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSourceContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearSourceContent() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Any ensureSourceContent() => $_ensure(0);

  @$pb.TagNumber(2)
  SourceContentType get scType => $_getN(1);
  @$pb.TagNumber(2)
  set scType(SourceContentType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasScType() => $_has(1);
  @$pb.TagNumber(2)
  void clearScType() => $_clearField(2);

  @$pb.TagNumber(3)
  SourceContentAV get av => $_getN(2);
  @$pb.TagNumber(3)
  set av(SourceContentAV value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAv() => $_has(2);
  @$pb.TagNumber(3)
  void clearAv() => $_clearField(3);
  @$pb.TagNumber(3)
  SourceContentAV ensureAv() => $_ensure(2);
}

enum StoryActualCardWrapper_ActualCard { videoCard, notSet }

class StoryActualCardWrapper extends $pb.GeneratedMessage {
  factory StoryActualCardWrapper({
    StoryVideoCard? videoCard,
  }) {
    final result = StoryActualCardWrapper._();
    if (videoCard != null) result.videoCard = videoCard;
    return result;
  }

  StoryActualCardWrapper._();

  factory StoryActualCardWrapper.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoryActualCardWrapper()..mergeFromBuffer(data, registry);
  factory StoryActualCardWrapper.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoryActualCardWrapper()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, StoryActualCardWrapper_ActualCard>
      _StoryActualCardWrapper_ActualCardByTag = {
    1: StoryActualCardWrapper_ActualCard.videoCard,
    0: StoryActualCardWrapper_ActualCard.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoryActualCardWrapper',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: StoryActualCardWrapper.$_createMessage)
    ..oo(0, [1])
    ..aOM<StoryVideoCard>(1, _omitFieldNames ? '' : 'videoCard',
        subBuilder: StoryVideoCard.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoryActualCardWrapper clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoryActualCardWrapper copyWith(
          void Function(StoryActualCardWrapper) updates) =>
      super.copyWith((message) => updates(message as StoryActualCardWrapper))
          as StoryActualCardWrapper;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoryActualCardWrapper() / StoryActualCardWrapper.new instead')
  static StoryActualCardWrapper create() => StoryActualCardWrapper._();
  static $pb.GeneratedMessage $_createMessage() => StoryActualCardWrapper._();
  @$core.override
  StoryActualCardWrapper createEmptyInstance() => StoryActualCardWrapper._();
  @$core.pragma('dart2js:noInline')
  static StoryActualCardWrapper getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoryActualCardWrapper>(
          StoryActualCardWrapper.$_createMessage);
  static StoryActualCardWrapper? _defaultInstance;

  @$pb.TagNumber(1)
  StoryActualCardWrapper_ActualCard whichActualCard() =>
      _StoryActualCardWrapper_ActualCardByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  void clearActualCard() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  StoryVideoCard get videoCard => $_getN(0);
  @$pb.TagNumber(1)
  set videoCard(StoryVideoCard value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVideoCard() => $_has(0);
  @$pb.TagNumber(1)
  void clearVideoCard() => $_clearField(1);
  @$pb.TagNumber(1)
  StoryVideoCard ensureVideoCard() => $_ensure(0);
}

class StoryEntrance extends $pb.GeneratedMessage {
  factory StoryEntrance({
    $core.bool? arcPlayStory,
    $core.String? storyIcon,
    $core.bool? arcLandscapeStory,
    $core.String? landscapeIcon,
    $core.bool? playStory,
  }) {
    final result = StoryEntrance._();
    if (arcPlayStory != null) result.arcPlayStory = arcPlayStory;
    if (storyIcon != null) result.storyIcon = storyIcon;
    if (arcLandscapeStory != null) result.arcLandscapeStory = arcLandscapeStory;
    if (landscapeIcon != null) result.landscapeIcon = landscapeIcon;
    if (playStory != null) result.playStory = playStory;
    return result;
  }

  StoryEntrance._();

  factory StoryEntrance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoryEntrance()..mergeFromBuffer(data, registry);
  factory StoryEntrance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoryEntrance()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoryEntrance',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: StoryEntrance.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'arcPlayStory')
    ..aOS(2, _omitFieldNames ? '' : 'storyIcon')
    ..aOB(3, _omitFieldNames ? '' : 'arcLandscapeStory')
    ..aOS(4, _omitFieldNames ? '' : 'landscapeIcon')
    ..aOB(5, _omitFieldNames ? '' : 'playStory')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoryEntrance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoryEntrance copyWith(void Function(StoryEntrance) updates) =>
      super.copyWith((message) => updates(message as StoryEntrance))
          as StoryEntrance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StoryEntrance() / StoryEntrance.new instead')
  static StoryEntrance create() => StoryEntrance._();
  static $pb.GeneratedMessage $_createMessage() => StoryEntrance._();
  @$core.override
  StoryEntrance createEmptyInstance() => StoryEntrance._();
  @$core.pragma('dart2js:noInline')
  static StoryEntrance getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StoryEntrance>(
          StoryEntrance.$_createMessage);
  static StoryEntrance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get arcPlayStory => $_getBF(0);
  @$pb.TagNumber(1)
  set arcPlayStory($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasArcPlayStory() => $_has(0);
  @$pb.TagNumber(1)
  void clearArcPlayStory() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get storyIcon => $_getSZ(1);
  @$pb.TagNumber(2)
  set storyIcon($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStoryIcon() => $_has(1);
  @$pb.TagNumber(2)
  void clearStoryIcon() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get arcLandscapeStory => $_getBF(2);
  @$pb.TagNumber(3)
  set arcLandscapeStory($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasArcLandscapeStory() => $_has(2);
  @$pb.TagNumber(3)
  void clearArcLandscapeStory() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get landscapeIcon => $_getSZ(3);
  @$pb.TagNumber(4)
  set landscapeIcon($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLandscapeIcon() => $_has(3);
  @$pb.TagNumber(4)
  void clearLandscapeIcon() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get playStory => $_getBF(4);
  @$pb.TagNumber(5)
  set playStory($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPlayStory() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlayStory() => $_clearField(5);
}

class StoryReply extends $pb.GeneratedMessage {
  factory StoryReply({
    $core.Iterable<StoryActualCardWrapper>? storyCardWrappers,
  }) {
    final result = StoryReply._();
    if (storyCardWrappers != null)
      result.storyCardWrappers.addAll(storyCardWrappers);
    return result;
  }

  StoryReply._();

  factory StoryReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoryReply()..mergeFromBuffer(data, registry);
  factory StoryReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoryReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoryReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: StoryReply.$_createMessage)
    ..pPM<StoryActualCardWrapper>(1, _omitFieldNames ? '' : 'storyCardWrappers',
        subBuilder: StoryActualCardWrapper.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoryReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoryReply copyWith(void Function(StoryReply) updates) =>
      super.copyWith((message) => updates(message as StoryReply)) as StoryReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StoryReply() / StoryReply.new instead')
  static StoryReply create() => StoryReply._();
  static $pb.GeneratedMessage $_createMessage() => StoryReply._();
  @$core.override
  StoryReply createEmptyInstance() => StoryReply._();
  @$core.pragma('dart2js:noInline')
  static StoryReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoryReply>(StoryReply.$_createMessage);
  static StoryReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<StoryActualCardWrapper> get storyCardWrappers => $_getList(0);
}

enum StoryReq_Param { storyReqParam, playListReqParam, notSet }

class StoryReq extends $pb.GeneratedMessage {
  factory StoryReq({
    $fixnum.Int64? aid,
    $core.String? bvid,
    $4.PlayerArgs? playerArgs,
    StoryReqParam? storyReqParam,
    PlayListReqParam? playListReqParam,
    $fixnum.Int64? pull,
    $core.String? from,
    $core.String? spmid,
    $core.String? fromSpmid,
  }) {
    final result = StoryReq._();
    if (aid != null) result.aid = aid;
    if (bvid != null) result.bvid = bvid;
    if (playerArgs != null) result.playerArgs = playerArgs;
    if (storyReqParam != null) result.storyReqParam = storyReqParam;
    if (playListReqParam != null) result.playListReqParam = playListReqParam;
    if (pull != null) result.pull = pull;
    if (from != null) result.from = from;
    if (spmid != null) result.spmid = spmid;
    if (fromSpmid != null) result.fromSpmid = fromSpmid;
    return result;
  }

  StoryReq._();

  factory StoryReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoryReq()..mergeFromBuffer(data, registry);
  factory StoryReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoryReq()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, StoryReq_Param> _StoryReq_ParamByTag = {
    4: StoryReq_Param.storyReqParam,
    5: StoryReq_Param.playListReqParam,
    0: StoryReq_Param.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoryReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: StoryReq.$_createMessage)
    ..oo(0, [4, 5])
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aOS(2, _omitFieldNames ? '' : 'bvid')
    ..aOM<$4.PlayerArgs>(3, _omitFieldNames ? '' : 'playerArgs',
        subBuilder: $4.PlayerArgs.$_createMessage)
    ..aOM<StoryReqParam>(4, _omitFieldNames ? '' : 'storyReqParam',
        subBuilder: StoryReqParam.$_createMessage)
    ..aOM<PlayListReqParam>(5, _omitFieldNames ? '' : 'playListReqParam',
        subBuilder: PlayListReqParam.$_createMessage)
    ..aInt64(6, _omitFieldNames ? '' : 'pull')
    ..aOS(7, _omitFieldNames ? '' : 'from')
    ..aOS(8, _omitFieldNames ? '' : 'spmid')
    ..aOS(9, _omitFieldNames ? '' : 'fromSpmid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoryReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoryReq copyWith(void Function(StoryReq) updates) =>
      super.copyWith((message) => updates(message as StoryReq)) as StoryReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StoryReq() / StoryReq.new instead')
  static StoryReq create() => StoryReq._();
  static $pb.GeneratedMessage $_createMessage() => StoryReq._();
  @$core.override
  StoryReq createEmptyInstance() => StoryReq._();
  @$core.pragma('dart2js:noInline')
  static StoryReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoryReq>(StoryReq.$_createMessage);
  static StoryReq? _defaultInstance;

  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  StoryReq_Param whichParam() => _StoryReq_ParamByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearParam() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get aid => $_getI64(0);
  @$pb.TagNumber(1)
  set aid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get bvid => $_getSZ(1);
  @$pb.TagNumber(2)
  set bvid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBvid() => $_has(1);
  @$pb.TagNumber(2)
  void clearBvid() => $_clearField(2);

  @$pb.TagNumber(3)
  $4.PlayerArgs get playerArgs => $_getN(2);
  @$pb.TagNumber(3)
  set playerArgs($4.PlayerArgs value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPlayerArgs() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlayerArgs() => $_clearField(3);
  @$pb.TagNumber(3)
  $4.PlayerArgs ensurePlayerArgs() => $_ensure(2);

  @$pb.TagNumber(4)
  StoryReqParam get storyReqParam => $_getN(3);
  @$pb.TagNumber(4)
  set storyReqParam(StoryReqParam value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStoryReqParam() => $_has(3);
  @$pb.TagNumber(4)
  void clearStoryReqParam() => $_clearField(4);
  @$pb.TagNumber(4)
  StoryReqParam ensureStoryReqParam() => $_ensure(3);

  @$pb.TagNumber(5)
  PlayListReqParam get playListReqParam => $_getN(4);
  @$pb.TagNumber(5)
  set playListReqParam(PlayListReqParam value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPlayListReqParam() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlayListReqParam() => $_clearField(5);
  @$pb.TagNumber(5)
  PlayListReqParam ensurePlayListReqParam() => $_ensure(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get pull => $_getI64(5);
  @$pb.TagNumber(6)
  set pull($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPull() => $_has(5);
  @$pb.TagNumber(6)
  void clearPull() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get from => $_getSZ(6);
  @$pb.TagNumber(7)
  set from($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFrom() => $_has(6);
  @$pb.TagNumber(7)
  void clearFrom() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get spmid => $_getSZ(7);
  @$pb.TagNumber(8)
  set spmid($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSpmid() => $_has(7);
  @$pb.TagNumber(8)
  void clearSpmid() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get fromSpmid => $_getSZ(8);
  @$pb.TagNumber(9)
  set fromSpmid($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFromSpmid() => $_has(8);
  @$pb.TagNumber(9)
  void clearFromSpmid() => $_clearField(9);
}

class StoryReqParam extends $pb.GeneratedMessage {
  factory StoryReqParam({
    $core.String? trackId,
    $fixnum.Int64? displayId,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? extraContent,
    $core.bool? refresh,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? businessInfo,
  }) {
    final result = StoryReqParam._();
    if (trackId != null) result.trackId = trackId;
    if (displayId != null) result.displayId = displayId;
    if (extraContent != null) result.extraContent.addEntries(extraContent);
    if (refresh != null) result.refresh = refresh;
    if (businessInfo != null) result.businessInfo.addEntries(businessInfo);
    return result;
  }

  StoryReqParam._();

  factory StoryReqParam.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoryReqParam()..mergeFromBuffer(data, registry);
  factory StoryReqParam.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoryReqParam()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoryReqParam',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: StoryReqParam.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'trackId')
    ..aInt64(2, _omitFieldNames ? '' : 'displayId')
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'extraContent',
        entryClassName: 'StoryReqParam.ExtraContentEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.v1'))
    ..aOB(4, _omitFieldNames ? '' : 'refresh')
    ..m<$core.String, $core.String>(5, _omitFieldNames ? '' : 'businessInfo',
        entryClassName: 'StoryReqParam.BusinessInfoEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoryReqParam clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoryReqParam copyWith(void Function(StoryReqParam) updates) =>
      super.copyWith((message) => updates(message as StoryReqParam))
          as StoryReqParam;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StoryReqParam() / StoryReqParam.new instead')
  static StoryReqParam create() => StoryReqParam._();
  static $pb.GeneratedMessage $_createMessage() => StoryReqParam._();
  @$core.override
  StoryReqParam createEmptyInstance() => StoryReqParam._();
  @$core.pragma('dart2js:noInline')
  static StoryReqParam getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StoryReqParam>(
          StoryReqParam.$_createMessage);
  static StoryReqParam? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trackId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trackId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrackId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrackId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get displayId => $_getI64(1);
  @$pb.TagNumber(2)
  set displayId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get extraContent => $_getMap(2);

  @$pb.TagNumber(4)
  $core.bool get refresh => $_getBF(3);
  @$pb.TagNumber(4)
  set refresh($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRefresh() => $_has(3);
  @$pb.TagNumber(4)
  void clearRefresh() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.String> get businessInfo => $_getMap(4);
}

class StoryVideoCard extends $pb.GeneratedMessage {
  factory StoryVideoCard({
    VideoPlayData? playData,
    ViewReply? viewContent,
    $core.String? recommendSessionId,
    $core.String? cover,
    $core.String? trackId,
    $core.String? goto,
  }) {
    final result = StoryVideoCard._();
    if (playData != null) result.playData = playData;
    if (viewContent != null) result.viewContent = viewContent;
    if (recommendSessionId != null)
      result.recommendSessionId = recommendSessionId;
    if (cover != null) result.cover = cover;
    if (trackId != null) result.trackId = trackId;
    if (goto != null) result.goto = goto;
    return result;
  }

  StoryVideoCard._();

  factory StoryVideoCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoryVideoCard()..mergeFromBuffer(data, registry);
  factory StoryVideoCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoryVideoCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoryVideoCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: StoryVideoCard.$_createMessage)
    ..aOM<VideoPlayData>(1, _omitFieldNames ? '' : 'playData',
        subBuilder: VideoPlayData.$_createMessage)
    ..aOM<ViewReply>(2, _omitFieldNames ? '' : 'viewContent',
        subBuilder: ViewReply.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'recommendSessionId')
    ..aOS(4, _omitFieldNames ? '' : 'cover')
    ..aOS(5, _omitFieldNames ? '' : 'trackId')
    ..aOS(6, _omitFieldNames ? '' : 'goto')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoryVideoCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoryVideoCard copyWith(void Function(StoryVideoCard) updates) =>
      super.copyWith((message) => updates(message as StoryVideoCard))
          as StoryVideoCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StoryVideoCard() / StoryVideoCard.new instead')
  static StoryVideoCard create() => StoryVideoCard._();
  static $pb.GeneratedMessage $_createMessage() => StoryVideoCard._();
  @$core.override
  StoryVideoCard createEmptyInstance() => StoryVideoCard._();
  @$core.pragma('dart2js:noInline')
  static StoryVideoCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StoryVideoCard>(
          StoryVideoCard.$_createMessage);
  static StoryVideoCard? _defaultInstance;

  @$pb.TagNumber(1)
  VideoPlayData get playData => $_getN(0);
  @$pb.TagNumber(1)
  set playData(VideoPlayData value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlayData() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayData() => $_clearField(1);
  @$pb.TagNumber(1)
  VideoPlayData ensurePlayData() => $_ensure(0);

  @$pb.TagNumber(2)
  ViewReply get viewContent => $_getN(1);
  @$pb.TagNumber(2)
  set viewContent(ViewReply value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasViewContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearViewContent() => $_clearField(2);
  @$pb.TagNumber(2)
  ViewReply ensureViewContent() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get recommendSessionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set recommendSessionId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecommendSessionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecommendSessionId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get cover => $_getSZ(3);
  @$pb.TagNumber(4)
  set cover($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCover() => $_has(3);
  @$pb.TagNumber(4)
  void clearCover() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get trackId => $_getSZ(4);
  @$pb.TagNumber(5)
  set trackId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTrackId() => $_has(4);
  @$pb.TagNumber(5)
  void clearTrackId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get goto => $_getSZ(5);
  @$pb.TagNumber(6)
  set goto($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasGoto() => $_has(5);
  @$pb.TagNumber(6)
  void clearGoto() => $_clearField(6);
}

class Tab extends $pb.GeneratedMessage {
  factory Tab({
    $core.Iterable<TabModule>? tabModule,
    $core.String? tabBg,
    TabControl? danmakuEntrance,
    $core.String? tabBgPad,
  }) {
    final result = Tab._();
    if (tabModule != null) result.tabModule.addAll(tabModule);
    if (tabBg != null) result.tabBg = tabBg;
    if (danmakuEntrance != null) result.danmakuEntrance = danmakuEntrance;
    if (tabBgPad != null) result.tabBgPad = tabBgPad;
    return result;
  }

  Tab._();

  factory Tab.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Tab()..mergeFromBuffer(data, registry);
  factory Tab.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Tab()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Tab',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: Tab.$_createMessage)
    ..pPM<TabModule>(1, _omitFieldNames ? '' : 'tabModule',
        subBuilder: TabModule.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'tabBg')
    ..aOM<TabControl>(3, _omitFieldNames ? '' : 'danmakuEntrance',
        subBuilder: TabControl.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'tabBgPad')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tab clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tab copyWith(void Function(Tab) updates) =>
      super.copyWith((message) => updates(message as Tab)) as Tab;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Tab() / Tab.new instead')
  static Tab create() => Tab._();
  static $pb.GeneratedMessage $_createMessage() => Tab._();
  @$core.override
  Tab createEmptyInstance() => Tab._();
  @$core.pragma('dart2js:noInline')
  static Tab getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Tab>(Tab.$_createMessage);
  static Tab? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TabModule> get tabModule => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get tabBg => $_getSZ(1);
  @$pb.TagNumber(2)
  set tabBg($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTabBg() => $_has(1);
  @$pb.TagNumber(2)
  void clearTabBg() => $_clearField(2);

  @$pb.TagNumber(3)
  TabControl get danmakuEntrance => $_getN(2);
  @$pb.TagNumber(3)
  set danmakuEntrance(TabControl value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDanmakuEntrance() => $_has(2);
  @$pb.TagNumber(3)
  void clearDanmakuEntrance() => $_clearField(3);
  @$pb.TagNumber(3)
  TabControl ensureDanmakuEntrance() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get tabBgPad => $_getSZ(3);
  @$pb.TagNumber(4)
  set tabBgPad($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTabBgPad() => $_has(3);
  @$pb.TagNumber(4)
  void clearTabBgPad() => $_clearField(4);
}

class TabControl extends $pb.GeneratedMessage {
  factory TabControl({
    $core.bool? limit,
    $core.bool? disable,
    $core.String? disableClickTip,
  }) {
    final result = TabControl._();
    if (limit != null) result.limit = limit;
    if (disable != null) result.disable = disable;
    if (disableClickTip != null) result.disableClickTip = disableClickTip;
    return result;
  }

  TabControl._();

  factory TabControl.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TabControl()..mergeFromBuffer(data, registry);
  factory TabControl.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TabControl()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TabControl',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: TabControl.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'limit')
    ..aOB(2, _omitFieldNames ? '' : 'disable')
    ..aOS(3, _omitFieldNames ? '' : 'disableClickTip')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TabControl clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TabControl copyWith(void Function(TabControl) updates) =>
      super.copyWith((message) => updates(message as TabControl)) as TabControl;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TabControl() / TabControl.new instead')
  static TabControl create() => TabControl._();
  static $pb.GeneratedMessage $_createMessage() => TabControl._();
  @$core.override
  TabControl createEmptyInstance() => TabControl._();
  @$core.pragma('dart2js:noInline')
  static TabControl getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TabControl>(TabControl.$_createMessage);
  static TabControl? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get limit => $_getBF(0);
  @$pb.TagNumber(1)
  set limit($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get disable => $_getBF(1);
  @$pb.TagNumber(2)
  set disable($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisable() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisable() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get disableClickTip => $_getSZ(2);
  @$pb.TagNumber(3)
  set disableClickTip($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisableClickTip() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisableClickTip() => $_clearField(3);
}

enum TabModule_Tab { introduction, reply, activityTab, catalog, notSet }

class TabModule extends $pb.GeneratedMessage {
  factory TabModule({
    TabType? tabType,
    IntroductionTab? introduction,
    ReplyTab? reply,
    $1.ActivityTab? activityTab,
    $1.CatalogTab? catalog,
  }) {
    final result = TabModule._();
    if (tabType != null) result.tabType = tabType;
    if (introduction != null) result.introduction = introduction;
    if (reply != null) result.reply = reply;
    if (activityTab != null) result.activityTab = activityTab;
    if (catalog != null) result.catalog = catalog;
    return result;
  }

  TabModule._();

  factory TabModule.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TabModule()..mergeFromBuffer(data, registry);
  factory TabModule.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TabModule()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, TabModule_Tab> _TabModule_TabByTag = {
    2: TabModule_Tab.introduction,
    3: TabModule_Tab.reply,
    4: TabModule_Tab.activityTab,
    5: TabModule_Tab.catalog,
    0: TabModule_Tab.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TabModule',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: TabModule.$_createMessage)
    ..oo(0, [2, 3, 4, 5])
    ..aE<TabType>(1, _omitFieldNames ? '' : 'tabType',
        enumValues: TabType.values)
    ..aOM<IntroductionTab>(2, _omitFieldNames ? '' : 'introduction',
        subBuilder: IntroductionTab.$_createMessage)
    ..aOM<ReplyTab>(3, _omitFieldNames ? '' : 'reply',
        subBuilder: ReplyTab.$_createMessage)
    ..aOM<$1.ActivityTab>(4, _omitFieldNames ? '' : 'activityTab',
        subBuilder: $1.ActivityTab.$_createMessage)
    ..aOM<$1.CatalogTab>(5, _omitFieldNames ? '' : 'catalog',
        subBuilder: $1.CatalogTab.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TabModule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TabModule copyWith(void Function(TabModule) updates) =>
      super.copyWith((message) => updates(message as TabModule)) as TabModule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TabModule() / TabModule.new instead')
  static TabModule create() => TabModule._();
  static $pb.GeneratedMessage $_createMessage() => TabModule._();
  @$core.override
  TabModule createEmptyInstance() => TabModule._();
  @$core.pragma('dart2js:noInline')
  static TabModule getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TabModule>(TabModule.$_createMessage);
  static TabModule? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  TabModule_Tab whichTab() => _TabModule_TabByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearTab() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  TabType get tabType => $_getN(0);
  @$pb.TagNumber(1)
  set tabType(TabType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTabType() => $_has(0);
  @$pb.TagNumber(1)
  void clearTabType() => $_clearField(1);

  @$pb.TagNumber(2)
  IntroductionTab get introduction => $_getN(1);
  @$pb.TagNumber(2)
  set introduction(IntroductionTab value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasIntroduction() => $_has(1);
  @$pb.TagNumber(2)
  void clearIntroduction() => $_clearField(2);
  @$pb.TagNumber(2)
  IntroductionTab ensureIntroduction() => $_ensure(1);

  @$pb.TagNumber(3)
  ReplyTab get reply => $_getN(2);
  @$pb.TagNumber(3)
  set reply(ReplyTab value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReply() => $_has(2);
  @$pb.TagNumber(3)
  void clearReply() => $_clearField(3);
  @$pb.TagNumber(3)
  ReplyTab ensureReply() => $_ensure(2);

  @$pb.TagNumber(4)
  $1.ActivityTab get activityTab => $_getN(3);
  @$pb.TagNumber(4)
  set activityTab($1.ActivityTab value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasActivityTab() => $_has(3);
  @$pb.TagNumber(4)
  void clearActivityTab() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.ActivityTab ensureActivityTab() => $_ensure(3);

  @$pb.TagNumber(5)
  $1.CatalogTab get catalog => $_getN(4);
  @$pb.TagNumber(5)
  set catalog($1.CatalogTab value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCatalog() => $_has(4);
  @$pb.TagNumber(5)
  void clearCatalog() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.CatalogTab ensureCatalog() => $_ensure(4);
}

class UpperInfos extends $pb.GeneratedMessage {
  factory UpperInfos({
    $fixnum.Int64? fansCount,
    $fixnum.Int64? arcCountLastHalfYear,
    $fixnum.Int64? firstUpDates,
    $fixnum.Int64? totalPlayCount,
  }) {
    final result = UpperInfos._();
    if (fansCount != null) result.fansCount = fansCount;
    if (arcCountLastHalfYear != null)
      result.arcCountLastHalfYear = arcCountLastHalfYear;
    if (firstUpDates != null) result.firstUpDates = firstUpDates;
    if (totalPlayCount != null) result.totalPlayCount = totalPlayCount;
    return result;
  }

  UpperInfos._();

  factory UpperInfos.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpperInfos()..mergeFromBuffer(data, registry);
  factory UpperInfos.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpperInfos()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpperInfos',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: UpperInfos.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'fansCount')
    ..aInt64(2, _omitFieldNames ? '' : 'arcCountLastHalfYear')
    ..aInt64(3, _omitFieldNames ? '' : 'firstUpDates')
    ..aInt64(4, _omitFieldNames ? '' : 'totalPlayCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpperInfos clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpperInfos copyWith(void Function(UpperInfos) updates) =>
      super.copyWith((message) => updates(message as UpperInfos)) as UpperInfos;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UpperInfos() / UpperInfos.new instead')
  static UpperInfos create() => UpperInfos._();
  static $pb.GeneratedMessage $_createMessage() => UpperInfos._();
  @$core.override
  UpperInfos createEmptyInstance() => UpperInfos._();
  @$core.pragma('dart2js:noInline')
  static UpperInfos getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpperInfos>(UpperInfos.$_createMessage);
  static UpperInfos? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get fansCount => $_getI64(0);
  @$pb.TagNumber(1)
  set fansCount($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFansCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearFansCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get arcCountLastHalfYear => $_getI64(1);
  @$pb.TagNumber(2)
  set arcCountLastHalfYear($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasArcCountLastHalfYear() => $_has(1);
  @$pb.TagNumber(2)
  void clearArcCountLastHalfYear() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get firstUpDates => $_getI64(2);
  @$pb.TagNumber(3)
  set firstUpDates($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFirstUpDates() => $_has(2);
  @$pb.TagNumber(3)
  void clearFirstUpDates() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get totalPlayCount => $_getI64(3);
  @$pb.TagNumber(4)
  set totalPlayCount($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalPlayCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalPlayCount() => $_clearField(4);
}

class VideoGuide extends $pb.GeneratedMessage {
  factory VideoGuide({
    $core.Iterable<Material>? material,
    VideoViewPoint? videoPoint,
    ContractCard? contractCard,
    Material? rightMaterial,
  }) {
    final result = VideoGuide._();
    if (material != null) result.material.addAll(material);
    if (videoPoint != null) result.videoPoint = videoPoint;
    if (contractCard != null) result.contractCard = contractCard;
    if (rightMaterial != null) result.rightMaterial = rightMaterial;
    return result;
  }

  VideoGuide._();

  factory VideoGuide.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoGuide()..mergeFromBuffer(data, registry);
  factory VideoGuide.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoGuide()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoGuide',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: VideoGuide.$_createMessage)
    ..pPM<Material>(1, _omitFieldNames ? '' : 'material',
        subBuilder: Material.$_createMessage)
    ..aOM<VideoViewPoint>(2, _omitFieldNames ? '' : 'videoPoint',
        subBuilder: VideoViewPoint.$_createMessage)
    ..aOM<ContractCard>(3, _omitFieldNames ? '' : 'contractCard',
        subBuilder: ContractCard.$_createMessage)
    ..aOM<Material>(4, _omitFieldNames ? '' : 'rightMaterial',
        subBuilder: Material.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoGuide clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoGuide copyWith(void Function(VideoGuide) updates) =>
      super.copyWith((message) => updates(message as VideoGuide)) as VideoGuide;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use VideoGuide() / VideoGuide.new instead')
  static VideoGuide create() => VideoGuide._();
  static $pb.GeneratedMessage $_createMessage() => VideoGuide._();
  @$core.override
  VideoGuide createEmptyInstance() => VideoGuide._();
  @$core.pragma('dart2js:noInline')
  static VideoGuide getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoGuide>(VideoGuide.$_createMessage);
  static VideoGuide? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Material> get material => $_getList(0);

  @$pb.TagNumber(2)
  VideoViewPoint get videoPoint => $_getN(1);
  @$pb.TagNumber(2)
  set videoPoint(VideoViewPoint value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasVideoPoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearVideoPoint() => $_clearField(2);
  @$pb.TagNumber(2)
  VideoViewPoint ensureVideoPoint() => $_ensure(1);

  @$pb.TagNumber(3)
  ContractCard get contractCard => $_getN(2);
  @$pb.TagNumber(3)
  set contractCard(ContractCard value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasContractCard() => $_has(2);
  @$pb.TagNumber(3)
  void clearContractCard() => $_clearField(3);
  @$pb.TagNumber(3)
  ContractCard ensureContractCard() => $_ensure(2);

  @$pb.TagNumber(4)
  Material get rightMaterial => $_getN(3);
  @$pb.TagNumber(4)
  set rightMaterial(Material value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRightMaterial() => $_has(3);
  @$pb.TagNumber(4)
  void clearRightMaterial() => $_clearField(4);
  @$pb.TagNumber(4)
  Material ensureRightMaterial() => $_ensure(3);
}

class VideoPlayData extends $pb.GeneratedMessage {
  factory VideoPlayData({
    $core.String? url,
    $5.Dimension? dimension,
    $fixnum.Int64? aid,
    $fixnum.Int64? epId,
    $fixnum.Int64? cid,
  }) {
    final result = VideoPlayData._();
    if (url != null) result.url = url;
    if (dimension != null) result.dimension = dimension;
    if (aid != null) result.aid = aid;
    if (epId != null) result.epId = epId;
    if (cid != null) result.cid = cid;
    return result;
  }

  VideoPlayData._();

  factory VideoPlayData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoPlayData()..mergeFromBuffer(data, registry);
  factory VideoPlayData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoPlayData()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoPlayData',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: VideoPlayData.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOM<$5.Dimension>(2, _omitFieldNames ? '' : 'dimension',
        subBuilder: $5.Dimension.$_createMessage)
    ..aInt64(3, _omitFieldNames ? '' : 'aid')
    ..aInt64(4, _omitFieldNames ? '' : 'epId')
    ..aInt64(5, _omitFieldNames ? '' : 'cid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoPlayData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoPlayData copyWith(void Function(VideoPlayData) updates) =>
      super.copyWith((message) => updates(message as VideoPlayData))
          as VideoPlayData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use VideoPlayData() / VideoPlayData.new instead')
  static VideoPlayData create() => VideoPlayData._();
  static $pb.GeneratedMessage $_createMessage() => VideoPlayData._();
  @$core.override
  VideoPlayData createEmptyInstance() => VideoPlayData._();
  @$core.pragma('dart2js:noInline')
  static VideoPlayData getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoPlayData>(
          VideoPlayData.$_createMessage);
  static VideoPlayData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $5.Dimension get dimension => $_getN(1);
  @$pb.TagNumber(2)
  set dimension($5.Dimension value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDimension() => $_has(1);
  @$pb.TagNumber(2)
  void clearDimension() => $_clearField(2);
  @$pb.TagNumber(2)
  $5.Dimension ensureDimension() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get aid => $_getI64(2);
  @$pb.TagNumber(3)
  set aid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAid() => $_has(2);
  @$pb.TagNumber(3)
  void clearAid() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get epId => $_getI64(3);
  @$pb.TagNumber(4)
  set epId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEpId() => $_has(3);
  @$pb.TagNumber(4)
  void clearEpId() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get cid => $_getI64(4);
  @$pb.TagNumber(5)
  set cid($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCid() => $_has(4);
  @$pb.TagNumber(5)
  void clearCid() => $_clearField(5);
}

class VideoPoint extends $pb.GeneratedMessage {
  factory VideoPoint({
    $core.int? type,
    $fixnum.Int64? from,
    $fixnum.Int64? to,
    $core.String? content,
    $core.String? cover,
    $core.String? logoUrl,
    $core.String? teamType,
    $core.String? teamName,
  }) {
    final result = VideoPoint._();
    if (type != null) result.type = type;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (content != null) result.content = content;
    if (cover != null) result.cover = cover;
    if (logoUrl != null) result.logoUrl = logoUrl;
    if (teamType != null) result.teamType = teamType;
    if (teamName != null) result.teamName = teamName;
    return result;
  }

  VideoPoint._();

  factory VideoPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoPoint()..mergeFromBuffer(data, registry);
  factory VideoPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoPoint()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoPoint',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: VideoPoint.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'type')
    ..aInt64(2, _omitFieldNames ? '' : 'from')
    ..aInt64(3, _omitFieldNames ? '' : 'to')
    ..aOS(4, _omitFieldNames ? '' : 'content')
    ..aOS(5, _omitFieldNames ? '' : 'cover')
    ..aOS(6, _omitFieldNames ? '' : 'logoUrl')
    ..aOS(7, _omitFieldNames ? '' : 'teamType')
    ..aOS(8, _omitFieldNames ? '' : 'teamName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoPoint copyWith(void Function(VideoPoint) updates) =>
      super.copyWith((message) => updates(message as VideoPoint)) as VideoPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use VideoPoint() / VideoPoint.new instead')
  static VideoPoint create() => VideoPoint._();
  static $pb.GeneratedMessage $_createMessage() => VideoPoint._();
  @$core.override
  VideoPoint createEmptyInstance() => VideoPoint._();
  @$core.pragma('dart2js:noInline')
  static VideoPoint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoPoint>(VideoPoint.$_createMessage);
  static VideoPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get from => $_getI64(1);
  @$pb.TagNumber(2)
  set from($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearFrom() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get to => $_getI64(2);
  @$pb.TagNumber(3)
  set to($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTo() => $_has(2);
  @$pb.TagNumber(3)
  void clearTo() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get content => $_getSZ(3);
  @$pb.TagNumber(4)
  set content($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContent() => $_has(3);
  @$pb.TagNumber(4)
  void clearContent() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get cover => $_getSZ(4);
  @$pb.TagNumber(5)
  set cover($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCover() => $_has(4);
  @$pb.TagNumber(5)
  void clearCover() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get logoUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set logoUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLogoUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearLogoUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get teamType => $_getSZ(6);
  @$pb.TagNumber(7)
  set teamType($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTeamType() => $_has(6);
  @$pb.TagNumber(7)
  void clearTeamType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get teamName => $_getSZ(7);
  @$pb.TagNumber(8)
  set teamName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTeamName() => $_has(7);
  @$pb.TagNumber(8)
  void clearTeamName() => $_clearField(8);
}

class VideoShot extends $pb.GeneratedMessage {
  factory VideoShot({
    $core.String? pvData,
    $core.int? imgXLen,
    $core.int? imgYLen,
    $core.int? imgXSize,
    $core.int? imgYSize,
    $core.Iterable<$core.String>? image,
  }) {
    final result = VideoShot._();
    if (pvData != null) result.pvData = pvData;
    if (imgXLen != null) result.imgXLen = imgXLen;
    if (imgYLen != null) result.imgYLen = imgYLen;
    if (imgXSize != null) result.imgXSize = imgXSize;
    if (imgYSize != null) result.imgYSize = imgYSize;
    if (image != null) result.image.addAll(image);
    return result;
  }

  VideoShot._();

  factory VideoShot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoShot()..mergeFromBuffer(data, registry);
  factory VideoShot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoShot()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoShot',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: VideoShot.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'pvData')
    ..aI(2, _omitFieldNames ? '' : 'imgXLen')
    ..aI(3, _omitFieldNames ? '' : 'imgYLen')
    ..aI(4, _omitFieldNames ? '' : 'imgXSize')
    ..aI(5, _omitFieldNames ? '' : 'imgYSize')
    ..pPS(6, _omitFieldNames ? '' : 'image')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoShot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoShot copyWith(void Function(VideoShot) updates) =>
      super.copyWith((message) => updates(message as VideoShot)) as VideoShot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use VideoShot() / VideoShot.new instead')
  static VideoShot create() => VideoShot._();
  static $pb.GeneratedMessage $_createMessage() => VideoShot._();
  @$core.override
  VideoShot createEmptyInstance() => VideoShot._();
  @$core.pragma('dart2js:noInline')
  static VideoShot getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VideoShot>(VideoShot.$_createMessage);
  static VideoShot? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pvData => $_getSZ(0);
  @$pb.TagNumber(1)
  set pvData($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPvData() => $_has(0);
  @$pb.TagNumber(1)
  void clearPvData() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get imgXLen => $_getIZ(1);
  @$pb.TagNumber(2)
  set imgXLen($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasImgXLen() => $_has(1);
  @$pb.TagNumber(2)
  void clearImgXLen() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get imgYLen => $_getIZ(2);
  @$pb.TagNumber(3)
  set imgYLen($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasImgYLen() => $_has(2);
  @$pb.TagNumber(3)
  void clearImgYLen() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get imgXSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set imgXSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasImgXSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearImgXSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get imgYSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set imgYSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasImgYSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearImgYSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get image => $_getList(5);
}

class VideoViewPoint extends $pb.GeneratedMessage {
  factory VideoViewPoint({
    $core.Iterable<VideoPoint>? points,
    PointMaterial? pointMaterial,
    $core.bool? pointPermanent,
  }) {
    final result = VideoViewPoint._();
    if (points != null) result.points.addAll(points);
    if (pointMaterial != null) result.pointMaterial = pointMaterial;
    if (pointPermanent != null) result.pointPermanent = pointPermanent;
    return result;
  }

  VideoViewPoint._();

  factory VideoViewPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoViewPoint()..mergeFromBuffer(data, registry);
  factory VideoViewPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VideoViewPoint()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VideoViewPoint',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: VideoViewPoint.$_createMessage)
    ..pPM<VideoPoint>(1, _omitFieldNames ? '' : 'points',
        subBuilder: VideoPoint.$_createMessage)
    ..aOM<PointMaterial>(2, _omitFieldNames ? '' : 'pointMaterial',
        subBuilder: PointMaterial.$_createMessage)
    ..aOB(3, _omitFieldNames ? '' : 'pointPermanent')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoViewPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VideoViewPoint copyWith(void Function(VideoViewPoint) updates) =>
      super.copyWith((message) => updates(message as VideoViewPoint))
          as VideoViewPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use VideoViewPoint() / VideoViewPoint.new instead')
  static VideoViewPoint create() => VideoViewPoint._();
  static $pb.GeneratedMessage $_createMessage() => VideoViewPoint._();
  @$core.override
  VideoViewPoint createEmptyInstance() => VideoViewPoint._();
  @$core.pragma('dart2js:noInline')
  static VideoViewPoint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoViewPoint>(
          VideoViewPoint.$_createMessage);
  static VideoViewPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<VideoPoint> get points => $_getList(0);

  @$pb.TagNumber(2)
  PointMaterial get pointMaterial => $_getN(1);
  @$pb.TagNumber(2)
  set pointMaterial(PointMaterial value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPointMaterial() => $_has(1);
  @$pb.TagNumber(2)
  void clearPointMaterial() => $_clearField(2);
  @$pb.TagNumber(2)
  PointMaterial ensurePointMaterial() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get pointPermanent => $_getBF(2);
  @$pb.TagNumber(3)
  set pointPermanent($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPointPermanent() => $_has(2);
  @$pb.TagNumber(3)
  void clearPointPermanent() => $_clearField(3);
}

class ViewBase extends $pb.GeneratedMessage {
  factory ViewBase({
    $5.BizType? bizType,
    PageCategory? pageType,
    PageControl? control,
    ActivityResource? activityResource,
    Config? config,
  }) {
    final result = ViewBase._();
    if (bizType != null) result.bizType = bizType;
    if (pageType != null) result.pageType = pageType;
    if (control != null) result.control = control;
    if (activityResource != null) result.activityResource = activityResource;
    if (config != null) result.config = config;
    return result;
  }

  ViewBase._();

  factory ViewBase.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewBase()..mergeFromBuffer(data, registry);
  factory ViewBase.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewBase()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ViewBase',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: ViewBase.$_createMessage)
    ..aE<$5.BizType>(1, _omitFieldNames ? '' : 'bizType',
        enumValues: $5.BizType.values)
    ..aE<PageCategory>(2, _omitFieldNames ? '' : 'pageType',
        enumValues: PageCategory.values)
    ..aOM<PageControl>(3, _omitFieldNames ? '' : 'control',
        subBuilder: PageControl.$_createMessage)
    ..aOM<ActivityResource>(4, _omitFieldNames ? '' : 'activityResource',
        subBuilder: ActivityResource.$_createMessage)
    ..aOM<Config>(5, _omitFieldNames ? '' : 'config',
        subBuilder: Config.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewBase clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewBase copyWith(void Function(ViewBase) updates) =>
      super.copyWith((message) => updates(message as ViewBase)) as ViewBase;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ViewBase() / ViewBase.new instead')
  static ViewBase create() => ViewBase._();
  static $pb.GeneratedMessage $_createMessage() => ViewBase._();
  @$core.override
  ViewBase createEmptyInstance() => ViewBase._();
  @$core.pragma('dart2js:noInline')
  static ViewBase getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ViewBase>(ViewBase.$_createMessage);
  static ViewBase? _defaultInstance;

  @$pb.TagNumber(1)
  $5.BizType get bizType => $_getN(0);
  @$pb.TagNumber(1)
  set bizType($5.BizType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBizType() => $_has(0);
  @$pb.TagNumber(1)
  void clearBizType() => $_clearField(1);

  @$pb.TagNumber(2)
  PageCategory get pageType => $_getN(1);
  @$pb.TagNumber(2)
  set pageType(PageCategory value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPageType() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageType() => $_clearField(2);

  @$pb.TagNumber(3)
  PageControl get control => $_getN(2);
  @$pb.TagNumber(3)
  set control(PageControl value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasControl() => $_has(2);
  @$pb.TagNumber(3)
  void clearControl() => $_clearField(3);
  @$pb.TagNumber(3)
  PageControl ensureControl() => $_ensure(2);

  @$pb.TagNumber(4)
  ActivityResource get activityResource => $_getN(3);
  @$pb.TagNumber(4)
  set activityResource(ActivityResource value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasActivityResource() => $_has(3);
  @$pb.TagNumber(4)
  void clearActivityResource() => $_clearField(4);
  @$pb.TagNumber(4)
  ActivityResource ensureActivityResource() => $_ensure(3);

  @$pb.TagNumber(5)
  Config get config => $_getN(4);
  @$pb.TagNumber(5)
  set config(Config value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasConfig() => $_has(4);
  @$pb.TagNumber(5)
  void clearConfig() => $_clearField(5);
  @$pb.TagNumber(5)
  Config ensureConfig() => $_ensure(4);
}

class ViewProgressReply extends $pb.GeneratedMessage {
  factory ViewProgressReply({
    VideoGuide? videoGuide,
    Chronos? chronos,
    VideoShot? arcShot,
    DmResource? dm,
    FragmentRes? fragmentRes,
  }) {
    final result = ViewProgressReply._();
    if (videoGuide != null) result.videoGuide = videoGuide;
    if (chronos != null) result.chronos = chronos;
    if (arcShot != null) result.arcShot = arcShot;
    if (dm != null) result.dm = dm;
    if (fragmentRes != null) result.fragmentRes = fragmentRes;
    return result;
  }

  ViewProgressReply._();

  factory ViewProgressReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewProgressReply()..mergeFromBuffer(data, registry);
  factory ViewProgressReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewProgressReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ViewProgressReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: ViewProgressReply.$_createMessage)
    ..aOM<VideoGuide>(1, _omitFieldNames ? '' : 'videoGuide',
        subBuilder: VideoGuide.$_createMessage)
    ..aOM<Chronos>(2, _omitFieldNames ? '' : 'chronos',
        subBuilder: Chronos.$_createMessage)
    ..aOM<VideoShot>(3, _omitFieldNames ? '' : 'arcShot',
        subBuilder: VideoShot.$_createMessage)
    ..aOM<DmResource>(4, _omitFieldNames ? '' : 'dm',
        subBuilder: DmResource.$_createMessage)
    ..aOM<FragmentRes>(5, _omitFieldNames ? '' : 'fragmentRes',
        subBuilder: FragmentRes.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewProgressReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewProgressReply copyWith(void Function(ViewProgressReply) updates) =>
      super.copyWith((message) => updates(message as ViewProgressReply))
          as ViewProgressReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ViewProgressReply() / ViewProgressReply.new instead')
  static ViewProgressReply create() => ViewProgressReply._();
  static $pb.GeneratedMessage $_createMessage() => ViewProgressReply._();
  @$core.override
  ViewProgressReply createEmptyInstance() => ViewProgressReply._();
  @$core.pragma('dart2js:noInline')
  static ViewProgressReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ViewProgressReply>(
          ViewProgressReply.$_createMessage);
  static ViewProgressReply? _defaultInstance;

  @$pb.TagNumber(1)
  VideoGuide get videoGuide => $_getN(0);
  @$pb.TagNumber(1)
  set videoGuide(VideoGuide value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVideoGuide() => $_has(0);
  @$pb.TagNumber(1)
  void clearVideoGuide() => $_clearField(1);
  @$pb.TagNumber(1)
  VideoGuide ensureVideoGuide() => $_ensure(0);

  @$pb.TagNumber(2)
  Chronos get chronos => $_getN(1);
  @$pb.TagNumber(2)
  set chronos(Chronos value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasChronos() => $_has(1);
  @$pb.TagNumber(2)
  void clearChronos() => $_clearField(2);
  @$pb.TagNumber(2)
  Chronos ensureChronos() => $_ensure(1);

  @$pb.TagNumber(3)
  VideoShot get arcShot => $_getN(2);
  @$pb.TagNumber(3)
  set arcShot(VideoShot value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasArcShot() => $_has(2);
  @$pb.TagNumber(3)
  void clearArcShot() => $_clearField(3);
  @$pb.TagNumber(3)
  VideoShot ensureArcShot() => $_ensure(2);

  @$pb.TagNumber(4)
  DmResource get dm => $_getN(3);
  @$pb.TagNumber(4)
  set dm(DmResource value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDm() => $_has(3);
  @$pb.TagNumber(4)
  void clearDm() => $_clearField(4);
  @$pb.TagNumber(4)
  DmResource ensureDm() => $_ensure(3);

  @$pb.TagNumber(5)
  FragmentRes get fragmentRes => $_getN(4);
  @$pb.TagNumber(5)
  set fragmentRes(FragmentRes value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasFragmentRes() => $_has(4);
  @$pb.TagNumber(5)
  void clearFragmentRes() => $_clearField(5);
  @$pb.TagNumber(5)
  FragmentRes ensureFragmentRes() => $_ensure(4);
}

class ViewProgressReq extends $pb.GeneratedMessage {
  factory ViewProgressReq({
    $fixnum.Int64? aid,
    $fixnum.Int64? cid,
    $fixnum.Int64? upMid,
    ChronosParam? chronosParam,
    UnionType? type,
    FragmentParam? fragmentParam,
    $core.String? fromScene,
    $5.PlayCtrl? playCtrl,
  }) {
    final result = ViewProgressReq._();
    if (aid != null) result.aid = aid;
    if (cid != null) result.cid = cid;
    if (upMid != null) result.upMid = upMid;
    if (chronosParam != null) result.chronosParam = chronosParam;
    if (type != null) result.type = type;
    if (fragmentParam != null) result.fragmentParam = fragmentParam;
    if (fromScene != null) result.fromScene = fromScene;
    if (playCtrl != null) result.playCtrl = playCtrl;
    return result;
  }

  ViewProgressReq._();

  factory ViewProgressReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewProgressReq()..mergeFromBuffer(data, registry);
  factory ViewProgressReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewProgressReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ViewProgressReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: ViewProgressReq.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aInt64(2, _omitFieldNames ? '' : 'cid')
    ..aInt64(3, _omitFieldNames ? '' : 'upMid')
    ..aOM<ChronosParam>(4, _omitFieldNames ? '' : 'chronosParam',
        subBuilder: ChronosParam.$_createMessage)
    ..aE<UnionType>(5, _omitFieldNames ? '' : 'type',
        enumValues: UnionType.values)
    ..aOM<FragmentParam>(6, _omitFieldNames ? '' : 'fragmentParam',
        subBuilder: FragmentParam.$_createMessage)
    ..aOS(7, _omitFieldNames ? '' : 'fromScene')
    ..aE<$5.PlayCtrl>(8, _omitFieldNames ? '' : 'playCtrl',
        enumValues: $5.PlayCtrl.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewProgressReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewProgressReq copyWith(void Function(ViewProgressReq) updates) =>
      super.copyWith((message) => updates(message as ViewProgressReq))
          as ViewProgressReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ViewProgressReq() / ViewProgressReq.new instead')
  static ViewProgressReq create() => ViewProgressReq._();
  static $pb.GeneratedMessage $_createMessage() => ViewProgressReq._();
  @$core.override
  ViewProgressReq createEmptyInstance() => ViewProgressReq._();
  @$core.pragma('dart2js:noInline')
  static ViewProgressReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ViewProgressReq>(
          ViewProgressReq.$_createMessage);
  static ViewProgressReq? _defaultInstance;

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
  $fixnum.Int64 get upMid => $_getI64(2);
  @$pb.TagNumber(3)
  set upMid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUpMid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpMid() => $_clearField(3);

  @$pb.TagNumber(4)
  ChronosParam get chronosParam => $_getN(3);
  @$pb.TagNumber(4)
  set chronosParam(ChronosParam value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasChronosParam() => $_has(3);
  @$pb.TagNumber(4)
  void clearChronosParam() => $_clearField(4);
  @$pb.TagNumber(4)
  ChronosParam ensureChronosParam() => $_ensure(3);

  @$pb.TagNumber(5)
  UnionType get type => $_getN(4);
  @$pb.TagNumber(5)
  set type(UnionType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasType() => $_has(4);
  @$pb.TagNumber(5)
  void clearType() => $_clearField(5);

  @$pb.TagNumber(6)
  FragmentParam get fragmentParam => $_getN(5);
  @$pb.TagNumber(6)
  set fragmentParam(FragmentParam value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasFragmentParam() => $_has(5);
  @$pb.TagNumber(6)
  void clearFragmentParam() => $_clearField(6);
  @$pb.TagNumber(6)
  FragmentParam ensureFragmentParam() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get fromScene => $_getSZ(6);
  @$pb.TagNumber(7)
  set fromScene($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFromScene() => $_has(6);
  @$pb.TagNumber(7)
  void clearFromScene() => $_clearField(7);

  @$pb.TagNumber(8)
  $5.PlayCtrl get playCtrl => $_getN(7);
  @$pb.TagNumber(8)
  set playCtrl($5.PlayCtrl value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPlayCtrl() => $_has(7);
  @$pb.TagNumber(8)
  void clearPlayCtrl() => $_clearField(8);
}

class ViewReply extends $pb.GeneratedMessage {
  factory ViewReply({
    ViewBase? viewBase,
    Arc? arc,
    ReqUser? reqUser,
    $1.Owner? owner,
    Tab? tab,
    $2.Any? supplement,
    CM? cm,
    ECode? ecode,
    ECodeConfig? ecodeConfig,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
  }) {
    final result = ViewReply._();
    if (viewBase != null) result.viewBase = viewBase;
    if (arc != null) result.arc = arc;
    if (reqUser != null) result.reqUser = reqUser;
    if (owner != null) result.owner = owner;
    if (tab != null) result.tab = tab;
    if (supplement != null) result.supplement = supplement;
    if (cm != null) result.cm = cm;
    if (ecode != null) result.ecode = ecode;
    if (ecodeConfig != null) result.ecodeConfig = ecodeConfig;
    if (report != null) result.report.addEntries(report);
    return result;
  }

  ViewReply._();

  factory ViewReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewReply()..mergeFromBuffer(data, registry);
  factory ViewReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ViewReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: ViewReply.$_createMessage)
    ..aOM<ViewBase>(1, _omitFieldNames ? '' : 'viewBase',
        subBuilder: ViewBase.$_createMessage)
    ..aOM<Arc>(2, _omitFieldNames ? '' : 'arc', subBuilder: Arc.$_createMessage)
    ..aOM<ReqUser>(3, _omitFieldNames ? '' : 'reqUser',
        subBuilder: ReqUser.$_createMessage)
    ..aOM<$1.Owner>(4, _omitFieldNames ? '' : 'owner',
        subBuilder: $1.Owner.$_createMessage)
    ..aOM<Tab>(5, _omitFieldNames ? '' : 'tab', subBuilder: Tab.$_createMessage)
    ..aOM<$2.Any>(6, _omitFieldNames ? '' : 'supplement',
        subBuilder: $2.Any.$_createMessage)
    ..aOM<CM>(7, _omitFieldNames ? '' : 'cm', subBuilder: CM.$_createMessage)
    ..aE<ECode>(8, _omitFieldNames ? '' : 'ecode', enumValues: ECode.values)
    ..aOM<ECodeConfig>(9, _omitFieldNames ? '' : 'ecodeConfig',
        subBuilder: ECodeConfig.$_createMessage)
    ..m<$core.String, $core.String>(10, _omitFieldNames ? '' : 'report',
        entryClassName: 'ViewReply.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewReply copyWith(void Function(ViewReply) updates) =>
      super.copyWith((message) => updates(message as ViewReply)) as ViewReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ViewReply() / ViewReply.new instead')
  static ViewReply create() => ViewReply._();
  static $pb.GeneratedMessage $_createMessage() => ViewReply._();
  @$core.override
  ViewReply createEmptyInstance() => ViewReply._();
  @$core.pragma('dart2js:noInline')
  static ViewReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ViewReply>(ViewReply.$_createMessage);
  static ViewReply? _defaultInstance;

  @$pb.TagNumber(1)
  ViewBase get viewBase => $_getN(0);
  @$pb.TagNumber(1)
  set viewBase(ViewBase value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasViewBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearViewBase() => $_clearField(1);
  @$pb.TagNumber(1)
  ViewBase ensureViewBase() => $_ensure(0);

  @$pb.TagNumber(2)
  Arc get arc => $_getN(1);
  @$pb.TagNumber(2)
  set arc(Arc value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasArc() => $_has(1);
  @$pb.TagNumber(2)
  void clearArc() => $_clearField(2);
  @$pb.TagNumber(2)
  Arc ensureArc() => $_ensure(1);

  @$pb.TagNumber(3)
  ReqUser get reqUser => $_getN(2);
  @$pb.TagNumber(3)
  set reqUser(ReqUser value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReqUser() => $_has(2);
  @$pb.TagNumber(3)
  void clearReqUser() => $_clearField(3);
  @$pb.TagNumber(3)
  ReqUser ensureReqUser() => $_ensure(2);

  @$pb.TagNumber(4)
  $1.Owner get owner => $_getN(3);
  @$pb.TagNumber(4)
  set owner($1.Owner value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasOwner() => $_has(3);
  @$pb.TagNumber(4)
  void clearOwner() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Owner ensureOwner() => $_ensure(3);

  @$pb.TagNumber(5)
  Tab get tab => $_getN(4);
  @$pb.TagNumber(5)
  set tab(Tab value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTab() => $_has(4);
  @$pb.TagNumber(5)
  void clearTab() => $_clearField(5);
  @$pb.TagNumber(5)
  Tab ensureTab() => $_ensure(4);

  @$pb.TagNumber(6)
  $2.Any get supplement => $_getN(5);
  @$pb.TagNumber(6)
  set supplement($2.Any value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSupplement() => $_has(5);
  @$pb.TagNumber(6)
  void clearSupplement() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.Any ensureSupplement() => $_ensure(5);

  @$pb.TagNumber(7)
  CM get cm => $_getN(6);
  @$pb.TagNumber(7)
  set cm(CM value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCm() => $_has(6);
  @$pb.TagNumber(7)
  void clearCm() => $_clearField(7);
  @$pb.TagNumber(7)
  CM ensureCm() => $_ensure(6);

  @$pb.TagNumber(8)
  ECode get ecode => $_getN(7);
  @$pb.TagNumber(8)
  set ecode(ECode value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasEcode() => $_has(7);
  @$pb.TagNumber(8)
  void clearEcode() => $_clearField(8);

  @$pb.TagNumber(9)
  ECodeConfig get ecodeConfig => $_getN(8);
  @$pb.TagNumber(9)
  set ecodeConfig(ECodeConfig value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasEcodeConfig() => $_has(8);
  @$pb.TagNumber(9)
  void clearEcodeConfig() => $_clearField(9);
  @$pb.TagNumber(9)
  ECodeConfig ensureEcodeConfig() => $_ensure(8);

  @$pb.TagNumber(10)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(9);
}

class ViewReq extends $pb.GeneratedMessage {
  factory ViewReq({
    $fixnum.Int64? aid,
    $core.String? bvid,
    $core.String? from,
    $core.String? spmid,
    $core.String? fromSpmid,
    $core.String? sessionId,
    $4.PlayerArgs? playerArgs,
    $core.String? trackId,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? extraContent,
    $core.String? playMode,
    Relate? relate,
    $core.String? bizExtra,
    $core.String? adExtra,
    $core.String? fromScene,
    $5.PlayCtrl? playCtrl,
  }) {
    final result = ViewReq._();
    if (aid != null) result.aid = aid;
    if (bvid != null) result.bvid = bvid;
    if (from != null) result.from = from;
    if (spmid != null) result.spmid = spmid;
    if (fromSpmid != null) result.fromSpmid = fromSpmid;
    if (sessionId != null) result.sessionId = sessionId;
    if (playerArgs != null) result.playerArgs = playerArgs;
    if (trackId != null) result.trackId = trackId;
    if (extraContent != null) result.extraContent.addEntries(extraContent);
    if (playMode != null) result.playMode = playMode;
    if (relate != null) result.relate = relate;
    if (bizExtra != null) result.bizExtra = bizExtra;
    if (adExtra != null) result.adExtra = adExtra;
    if (fromScene != null) result.fromScene = fromScene;
    if (playCtrl != null) result.playCtrl = playCtrl;
    return result;
  }

  ViewReq._();

  factory ViewReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewReq()..mergeFromBuffer(data, registry);
  factory ViewReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ViewReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.v1'),
      createEmptyInstance: ViewReq.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aOS(2, _omitFieldNames ? '' : 'bvid')
    ..aOS(3, _omitFieldNames ? '' : 'from')
    ..aOS(4, _omitFieldNames ? '' : 'spmid')
    ..aOS(5, _omitFieldNames ? '' : 'fromSpmid')
    ..aOS(6, _omitFieldNames ? '' : 'sessionId')
    ..aOM<$4.PlayerArgs>(7, _omitFieldNames ? '' : 'playerArgs',
        subBuilder: $4.PlayerArgs.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'trackId')
    ..m<$core.String, $core.String>(9, _omitFieldNames ? '' : 'extraContent',
        entryClassName: 'ViewReq.ExtraContentEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.v1'))
    ..aOS(10, _omitFieldNames ? '' : 'playMode')
    ..aOM<Relate>(11, _omitFieldNames ? '' : 'relate',
        subBuilder: Relate.$_createMessage)
    ..aOS(12, _omitFieldNames ? '' : 'bizExtra')
    ..aOS(13, _omitFieldNames ? '' : 'adExtra')
    ..aOS(14, _omitFieldNames ? '' : 'fromScene')
    ..aE<$5.PlayCtrl>(15, _omitFieldNames ? '' : 'playCtrl',
        enumValues: $5.PlayCtrl.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewReq copyWith(void Function(ViewReq) updates) =>
      super.copyWith((message) => updates(message as ViewReq)) as ViewReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ViewReq() / ViewReq.new instead')
  static ViewReq create() => ViewReq._();
  static $pb.GeneratedMessage $_createMessage() => ViewReq._();
  @$core.override
  ViewReq createEmptyInstance() => ViewReq._();
  @$core.pragma('dart2js:noInline')
  static ViewReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ViewReq>(ViewReq.$_createMessage);
  static ViewReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get aid => $_getI64(0);
  @$pb.TagNumber(1)
  set aid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get bvid => $_getSZ(1);
  @$pb.TagNumber(2)
  set bvid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBvid() => $_has(1);
  @$pb.TagNumber(2)
  void clearBvid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get from => $_getSZ(2);
  @$pb.TagNumber(3)
  set from($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFrom() => $_has(2);
  @$pb.TagNumber(3)
  void clearFrom() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get spmid => $_getSZ(3);
  @$pb.TagNumber(4)
  set spmid($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSpmid() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpmid() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get fromSpmid => $_getSZ(4);
  @$pb.TagNumber(5)
  set fromSpmid($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFromSpmid() => $_has(4);
  @$pb.TagNumber(5)
  void clearFromSpmid() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get sessionId => $_getSZ(5);
  @$pb.TagNumber(6)
  set sessionId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSessionId() => $_has(5);
  @$pb.TagNumber(6)
  void clearSessionId() => $_clearField(6);

  @$pb.TagNumber(7)
  $4.PlayerArgs get playerArgs => $_getN(6);
  @$pb.TagNumber(7)
  set playerArgs($4.PlayerArgs value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPlayerArgs() => $_has(6);
  @$pb.TagNumber(7)
  void clearPlayerArgs() => $_clearField(7);
  @$pb.TagNumber(7)
  $4.PlayerArgs ensurePlayerArgs() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get trackId => $_getSZ(7);
  @$pb.TagNumber(8)
  set trackId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTrackId() => $_has(7);
  @$pb.TagNumber(8)
  void clearTrackId() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbMap<$core.String, $core.String> get extraContent => $_getMap(8);

  @$pb.TagNumber(10)
  $core.String get playMode => $_getSZ(9);
  @$pb.TagNumber(10)
  set playMode($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPlayMode() => $_has(9);
  @$pb.TagNumber(10)
  void clearPlayMode() => $_clearField(10);

  @$pb.TagNumber(11)
  Relate get relate => $_getN(10);
  @$pb.TagNumber(11)
  set relate(Relate value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasRelate() => $_has(10);
  @$pb.TagNumber(11)
  void clearRelate() => $_clearField(11);
  @$pb.TagNumber(11)
  Relate ensureRelate() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get bizExtra => $_getSZ(11);
  @$pb.TagNumber(12)
  set bizExtra($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasBizExtra() => $_has(11);
  @$pb.TagNumber(12)
  void clearBizExtra() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get adExtra => $_getSZ(12);
  @$pb.TagNumber(13)
  set adExtra($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasAdExtra() => $_has(12);
  @$pb.TagNumber(13)
  void clearAdExtra() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get fromScene => $_getSZ(13);
  @$pb.TagNumber(14)
  set fromScene($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasFromScene() => $_has(13);
  @$pb.TagNumber(14)
  void clearFromScene() => $_clearField(14);

  @$pb.TagNumber(15)
  $5.PlayCtrl get playCtrl => $_getN(14);
  @$pb.TagNumber(15)
  set playCtrl($5.PlayCtrl value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasPlayCtrl() => $_has(14);
  @$pb.TagNumber(15)
  void clearPlayCtrl() => $_clearField(15);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
