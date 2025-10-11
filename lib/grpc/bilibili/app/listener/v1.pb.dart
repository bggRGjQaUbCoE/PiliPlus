// This is a generated file - do not edit.
//
// Generated from bilibili/app/listener/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../pagination.pb.dart' as $4;
import '../archive/middleware/v1.pb.dart' as $2;
import '../interfaces/v1.pb.dart' as $3;
import '../playurl/v1.pb.dart' as $5;
import 'v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'v1.pbenum.dart';

class Author extends $pb.GeneratedMessage {
  factory Author({
    $fixnum.Int64? mid,
    $core.String? name,
    $core.String? avatar,
    FollowRelation? relation,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    if (name != null) result.name = name;
    if (avatar != null) result.avatar = avatar;
    if (relation != null) result.relation = relation;
    return result;
  }

  Author._();

  factory Author.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Author.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Author',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'avatar')
    ..aOM<FollowRelation>(4, _omitFieldNames ? '' : 'relation',
        subBuilder: FollowRelation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Author clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Author copyWith(void Function(Author) updates) =>
      super.copyWith((message) => updates(message as Author)) as Author;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Author create() => Author._();
  @$core.override
  Author createEmptyInstance() => create();
  static $pb.PbList<Author> createRepeated() => $pb.PbList<Author>();
  @$core.pragma('dart2js:noInline')
  static Author getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Author>(create);
  static Author? _defaultInstance;

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
  $core.String get avatar => $_getSZ(2);
  @$pb.TagNumber(3)
  set avatar($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAvatar() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvatar() => $_clearField(3);

  @$pb.TagNumber(4)
  FollowRelation get relation => $_getN(3);
  @$pb.TagNumber(4)
  set relation(FollowRelation value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRelation() => $_has(3);
  @$pb.TagNumber(4)
  void clearRelation() => $_clearField(4);
  @$pb.TagNumber(4)
  FollowRelation ensureRelation() => $_ensure(3);
}

class BKArcDetailsReq extends $pb.GeneratedMessage {
  factory BKArcDetailsReq({
    $core.Iterable<PlayItem>? items,
    $2.PlayerArgs? playerArgs,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (playerArgs != null) result.playerArgs = playerArgs;
    return result;
  }

  BKArcDetailsReq._();

  factory BKArcDetailsReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BKArcDetailsReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BKArcDetailsReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..pPM<PlayItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: PlayItem.create)
    ..aOM<$2.PlayerArgs>(2, _omitFieldNames ? '' : 'playerArgs',
        subBuilder: $2.PlayerArgs.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BKArcDetailsReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BKArcDetailsReq copyWith(void Function(BKArcDetailsReq) updates) =>
      super.copyWith((message) => updates(message as BKArcDetailsReq))
          as BKArcDetailsReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BKArcDetailsReq create() => BKArcDetailsReq._();
  @$core.override
  BKArcDetailsReq createEmptyInstance() => create();
  static $pb.PbList<BKArcDetailsReq> createRepeated() =>
      $pb.PbList<BKArcDetailsReq>();
  @$core.pragma('dart2js:noInline')
  static BKArcDetailsReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BKArcDetailsReq>(create);
  static BKArcDetailsReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PlayItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  $2.PlayerArgs get playerArgs => $_getN(1);
  @$pb.TagNumber(2)
  set playerArgs($2.PlayerArgs value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlayerArgs() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayerArgs() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PlayerArgs ensurePlayerArgs() => $_ensure(1);
}

class BKArcDetailsResp extends $pb.GeneratedMessage {
  factory BKArcDetailsResp({
    $core.Iterable<DetailItem>? list,
  }) {
    final result = create();
    if (list != null) result.list.addAll(list);
    return result;
  }

  BKArcDetailsResp._();

  factory BKArcDetailsResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BKArcDetailsResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BKArcDetailsResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..pPM<DetailItem>(1, _omitFieldNames ? '' : 'list',
        subBuilder: DetailItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BKArcDetailsResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BKArcDetailsResp copyWith(void Function(BKArcDetailsResp) updates) =>
      super.copyWith((message) => updates(message as BKArcDetailsResp))
          as BKArcDetailsResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BKArcDetailsResp create() => BKArcDetailsResp._();
  @$core.override
  BKArcDetailsResp createEmptyInstance() => create();
  static $pb.PbList<BKArcDetailsResp> createRepeated() =>
      $pb.PbList<BKArcDetailsResp>();
  @$core.pragma('dart2js:noInline')
  static BKArcDetailsResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BKArcDetailsResp>(create);
  static BKArcDetailsResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DetailItem> get list => $_getList(0);
}

class BKArcPart extends $pb.GeneratedMessage {
  factory BKArcPart({
    $fixnum.Int64? oid,
    $fixnum.Int64? subId,
    $core.String? title,
    $fixnum.Int64? duration,
    $core.int? page,
  }) {
    final result = create();
    if (oid != null) result.oid = oid;
    if (subId != null) result.subId = subId;
    if (title != null) result.title = title;
    if (duration != null) result.duration = duration;
    if (page != null) result.page = page;
    return result;
  }

  BKArcPart._();

  factory BKArcPart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BKArcPart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BKArcPart',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'oid')
    ..aInt64(2, _omitFieldNames ? '' : 'subId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aInt64(4, _omitFieldNames ? '' : 'duration')
    ..aI(5, _omitFieldNames ? '' : 'page')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BKArcPart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BKArcPart copyWith(void Function(BKArcPart) updates) =>
      super.copyWith((message) => updates(message as BKArcPart)) as BKArcPart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BKArcPart create() => BKArcPart._();
  @$core.override
  BKArcPart createEmptyInstance() => create();
  static $pb.PbList<BKArcPart> createRepeated() => $pb.PbList<BKArcPart>();
  @$core.pragma('dart2js:noInline')
  static BKArcPart getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BKArcPart>(create);
  static BKArcPart? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get oid => $_getI64(0);
  @$pb.TagNumber(1)
  set oid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOid() => $_has(0);
  @$pb.TagNumber(1)
  void clearOid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get subId => $_getI64(1);
  @$pb.TagNumber(2)
  set subId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get duration => $_getI64(3);
  @$pb.TagNumber(4)
  set duration($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDuration() => $_has(3);
  @$pb.TagNumber(4)
  void clearDuration() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get page => $_getIZ(4);
  @$pb.TagNumber(5)
  set page($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPage() => $_has(4);
  @$pb.TagNumber(5)
  void clearPage() => $_clearField(5);
}

class BKArcRights extends $pb.GeneratedMessage {
  factory BKArcRights({
    $core.int? noReprint,
  }) {
    final result = create();
    if (noReprint != null) result.noReprint = noReprint;
    return result;
  }

  BKArcRights._();

  factory BKArcRights.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BKArcRights.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BKArcRights',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'noReprint')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BKArcRights clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BKArcRights copyWith(void Function(BKArcRights) updates) =>
      super.copyWith((message) => updates(message as BKArcRights))
          as BKArcRights;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BKArcRights create() => BKArcRights._();
  @$core.override
  BKArcRights createEmptyInstance() => create();
  static $pb.PbList<BKArcRights> createRepeated() => $pb.PbList<BKArcRights>();
  @$core.pragma('dart2js:noInline')
  static BKArcRights getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BKArcRights>(create);
  static BKArcRights? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get noReprint => $_getIZ(0);
  @$pb.TagNumber(1)
  set noReprint($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNoReprint() => $_has(0);
  @$pb.TagNumber(1)
  void clearNoReprint() => $_clearField(1);
}

class BKArchive extends $pb.GeneratedMessage {
  factory BKArchive({
    $fixnum.Int64? oid,
    $core.String? title,
    $core.String? cover,
    $core.String? desc,
    $fixnum.Int64? duration,
    $core.int? rid,
    $core.String? rname,
    $fixnum.Int64? publish,
    $core.String? displayedOid,
    $core.int? copyright,
    BKArcRights? rights,
  }) {
    final result = create();
    if (oid != null) result.oid = oid;
    if (title != null) result.title = title;
    if (cover != null) result.cover = cover;
    if (desc != null) result.desc = desc;
    if (duration != null) result.duration = duration;
    if (rid != null) result.rid = rid;
    if (rname != null) result.rname = rname;
    if (publish != null) result.publish = publish;
    if (displayedOid != null) result.displayedOid = displayedOid;
    if (copyright != null) result.copyright = copyright;
    if (rights != null) result.rights = rights;
    return result;
  }

  BKArchive._();

  factory BKArchive.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BKArchive.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BKArchive',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'oid')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'cover')
    ..aOS(4, _omitFieldNames ? '' : 'desc')
    ..aInt64(5, _omitFieldNames ? '' : 'duration')
    ..aI(6, _omitFieldNames ? '' : 'rid')
    ..aOS(7, _omitFieldNames ? '' : 'rname')
    ..aInt64(8, _omitFieldNames ? '' : 'publish')
    ..aOS(9, _omitFieldNames ? '' : 'displayedOid')
    ..aI(10, _omitFieldNames ? '' : 'copyright')
    ..aOM<BKArcRights>(11, _omitFieldNames ? '' : 'rights',
        subBuilder: BKArcRights.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BKArchive clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BKArchive copyWith(void Function(BKArchive) updates) =>
      super.copyWith((message) => updates(message as BKArchive)) as BKArchive;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BKArchive create() => BKArchive._();
  @$core.override
  BKArchive createEmptyInstance() => create();
  static $pb.PbList<BKArchive> createRepeated() => $pb.PbList<BKArchive>();
  @$core.pragma('dart2js:noInline')
  static BKArchive getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BKArchive>(create);
  static BKArchive? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get oid => $_getI64(0);
  @$pb.TagNumber(1)
  set oid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOid() => $_has(0);
  @$pb.TagNumber(1)
  void clearOid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get cover => $_getSZ(2);
  @$pb.TagNumber(3)
  set cover($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCover() => $_has(2);
  @$pb.TagNumber(3)
  void clearCover() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get desc => $_getSZ(3);
  @$pb.TagNumber(4)
  set desc($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDesc() => $_has(3);
  @$pb.TagNumber(4)
  void clearDesc() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get duration => $_getI64(4);
  @$pb.TagNumber(5)
  set duration($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDuration() => $_has(4);
  @$pb.TagNumber(5)
  void clearDuration() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get rid => $_getIZ(5);
  @$pb.TagNumber(6)
  set rid($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRid() => $_has(5);
  @$pb.TagNumber(6)
  void clearRid() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get rname => $_getSZ(6);
  @$pb.TagNumber(7)
  set rname($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRname() => $_has(6);
  @$pb.TagNumber(7)
  void clearRname() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get publish => $_getI64(7);
  @$pb.TagNumber(8)
  set publish($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPublish() => $_has(7);
  @$pb.TagNumber(8)
  void clearPublish() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get displayedOid => $_getSZ(8);
  @$pb.TagNumber(9)
  set displayedOid($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDisplayedOid() => $_has(8);
  @$pb.TagNumber(9)
  void clearDisplayedOid() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get copyright => $_getIZ(9);
  @$pb.TagNumber(10)
  set copyright($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCopyright() => $_has(9);
  @$pb.TagNumber(10)
  void clearCopyright() => $_clearField(10);

  @$pb.TagNumber(11)
  BKArcRights get rights => $_getN(10);
  @$pb.TagNumber(11)
  set rights(BKArcRights value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasRights() => $_has(10);
  @$pb.TagNumber(11)
  void clearRights() => $_clearField(11);
  @$pb.TagNumber(11)
  BKArcRights ensureRights() => $_ensure(10);
}

class BKStat extends $pb.GeneratedMessage {
  factory BKStat({
    $core.int? like,
    $core.int? coin,
    $core.int? favourite,
    $core.int? reply,
    $core.int? share,
    $core.int? view,
    $core.bool? hasLike_7,
    $core.bool? hasCoin_8,
    $core.bool? hasFav,
    $core.bool? useViewVt,
    $core.String? viewVtText,
  }) {
    final result = create();
    if (like != null) result.like = like;
    if (coin != null) result.coin = coin;
    if (favourite != null) result.favourite = favourite;
    if (reply != null) result.reply = reply;
    if (share != null) result.share = share;
    if (view != null) result.view = view;
    if (hasLike_7 != null) result.hasLike_7 = hasLike_7;
    if (hasCoin_8 != null) result.hasCoin_8 = hasCoin_8;
    if (hasFav != null) result.hasFav = hasFav;
    if (useViewVt != null) result.useViewVt = useViewVt;
    if (viewVtText != null) result.viewVtText = viewVtText;
    return result;
  }

  BKStat._();

  factory BKStat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BKStat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BKStat',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'like')
    ..aI(2, _omitFieldNames ? '' : 'coin')
    ..aI(3, _omitFieldNames ? '' : 'favourite')
    ..aI(4, _omitFieldNames ? '' : 'reply')
    ..aI(5, _omitFieldNames ? '' : 'share')
    ..aI(6, _omitFieldNames ? '' : 'view')
    ..aOB(7, _omitFieldNames ? '' : 'hasLike')
    ..aOB(8, _omitFieldNames ? '' : 'hasCoin')
    ..aOB(9, _omitFieldNames ? '' : 'hasFav')
    ..aOB(10, _omitFieldNames ? '' : 'useViewVt')
    ..aOS(11, _omitFieldNames ? '' : 'viewVtText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BKStat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BKStat copyWith(void Function(BKStat) updates) =>
      super.copyWith((message) => updates(message as BKStat)) as BKStat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BKStat create() => BKStat._();
  @$core.override
  BKStat createEmptyInstance() => create();
  static $pb.PbList<BKStat> createRepeated() => $pb.PbList<BKStat>();
  @$core.pragma('dart2js:noInline')
  static BKStat getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BKStat>(create);
  static BKStat? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get like => $_getIZ(0);
  @$pb.TagNumber(1)
  set like($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLike() => $_has(0);
  @$pb.TagNumber(1)
  void clearLike() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get coin => $_getIZ(1);
  @$pb.TagNumber(2)
  set coin($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCoin() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoin() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get favourite => $_getIZ(2);
  @$pb.TagNumber(3)
  set favourite($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFavourite() => $_has(2);
  @$pb.TagNumber(3)
  void clearFavourite() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get reply => $_getIZ(3);
  @$pb.TagNumber(4)
  set reply($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReply() => $_has(3);
  @$pb.TagNumber(4)
  void clearReply() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get share => $_getIZ(4);
  @$pb.TagNumber(5)
  set share($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasShare() => $_has(4);
  @$pb.TagNumber(5)
  void clearShare() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get view => $_getIZ(5);
  @$pb.TagNumber(6)
  set view($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasView() => $_has(5);
  @$pb.TagNumber(6)
  void clearView() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get hasLike_7 => $_getBF(6);
  @$pb.TagNumber(7)
  set hasLike_7($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasHasLike_7() => $_has(6);
  @$pb.TagNumber(7)
  void clearHasLike_7() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get hasCoin_8 => $_getBF(7);
  @$pb.TagNumber(8)
  set hasCoin_8($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHasCoin_8() => $_has(7);
  @$pb.TagNumber(8)
  void clearHasCoin_8() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get hasFav => $_getBF(8);
  @$pb.TagNumber(9)
  set hasFav($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasHasFav() => $_has(8);
  @$pb.TagNumber(9)
  void clearHasFav() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get useViewVt => $_getBF(9);
  @$pb.TagNumber(10)
  set useViewVt($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasUseViewVt() => $_has(9);
  @$pb.TagNumber(10)
  void clearUseViewVt() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get viewVtText => $_getSZ(10);
  @$pb.TagNumber(11)
  set viewVtText($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasViewVtText() => $_has(10);
  @$pb.TagNumber(11)
  void clearViewVtText() => $_clearField(11);
}

enum CardModule_Module { moduleHeader, moduleArchive, moduleCbtn, notSet }

class CardModule extends $pb.GeneratedMessage {
  factory CardModule({
    CardModuleType? moduleType,
    PkcmHeader? moduleHeader,
    PkcmArchive? moduleArchive,
    PkcmCenterButton? moduleCbtn,
  }) {
    final result = create();
    if (moduleType != null) result.moduleType = moduleType;
    if (moduleHeader != null) result.moduleHeader = moduleHeader;
    if (moduleArchive != null) result.moduleArchive = moduleArchive;
    if (moduleCbtn != null) result.moduleCbtn = moduleCbtn;
    return result;
  }

  CardModule._();

  factory CardModule.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CardModule.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, CardModule_Module> _CardModule_ModuleByTag =
      {
    2: CardModule_Module.moduleHeader,
    3: CardModule_Module.moduleArchive,
    4: CardModule_Module.moduleCbtn,
    0: CardModule_Module.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CardModule',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..aE<CardModuleType>(1, _omitFieldNames ? '' : 'moduleType',
        enumValues: CardModuleType.values)
    ..aOM<PkcmHeader>(2, _omitFieldNames ? '' : 'moduleHeader',
        subBuilder: PkcmHeader.create)
    ..aOM<PkcmArchive>(3, _omitFieldNames ? '' : 'moduleArchive',
        subBuilder: PkcmArchive.create)
    ..aOM<PkcmCenterButton>(4, _omitFieldNames ? '' : 'moduleCbtn',
        subBuilder: PkcmCenterButton.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardModule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardModule copyWith(void Function(CardModule) updates) =>
      super.copyWith((message) => updates(message as CardModule)) as CardModule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CardModule create() => CardModule._();
  @$core.override
  CardModule createEmptyInstance() => create();
  static $pb.PbList<CardModule> createRepeated() => $pb.PbList<CardModule>();
  @$core.pragma('dart2js:noInline')
  static CardModule getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CardModule>(create);
  static CardModule? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  CardModule_Module whichModule() => _CardModule_ModuleByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearModule() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  CardModuleType get moduleType => $_getN(0);
  @$pb.TagNumber(1)
  set moduleType(CardModuleType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasModuleType() => $_has(0);
  @$pb.TagNumber(1)
  void clearModuleType() => $_clearField(1);

  @$pb.TagNumber(2)
  PkcmHeader get moduleHeader => $_getN(1);
  @$pb.TagNumber(2)
  set moduleHeader(PkcmHeader value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasModuleHeader() => $_has(1);
  @$pb.TagNumber(2)
  void clearModuleHeader() => $_clearField(2);
  @$pb.TagNumber(2)
  PkcmHeader ensureModuleHeader() => $_ensure(1);

  @$pb.TagNumber(3)
  PkcmArchive get moduleArchive => $_getN(2);
  @$pb.TagNumber(3)
  set moduleArchive(PkcmArchive value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasModuleArchive() => $_has(2);
  @$pb.TagNumber(3)
  void clearModuleArchive() => $_clearField(3);
  @$pb.TagNumber(3)
  PkcmArchive ensureModuleArchive() => $_ensure(2);

  @$pb.TagNumber(4)
  PkcmCenterButton get moduleCbtn => $_getN(3);
  @$pb.TagNumber(4)
  set moduleCbtn(PkcmCenterButton value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasModuleCbtn() => $_has(3);
  @$pb.TagNumber(4)
  void clearModuleCbtn() => $_clearField(4);
  @$pb.TagNumber(4)
  PkcmCenterButton ensureModuleCbtn() => $_ensure(3);
}

class ClickReq extends $pb.GeneratedMessage {
  factory ClickReq({
    $fixnum.Int64? sid,
    ClickReq_ClickAction? action,
  }) {
    final result = create();
    if (sid != null) result.sid = sid;
    if (action != null) result.action = action;
    return result;
  }

  ClickReq._();

  factory ClickReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClickReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClickReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'sid')
    ..aE<ClickReq_ClickAction>(2, _omitFieldNames ? '' : 'action',
        enumValues: ClickReq_ClickAction.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClickReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClickReq copyWith(void Function(ClickReq) updates) =>
      super.copyWith((message) => updates(message as ClickReq)) as ClickReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClickReq create() => ClickReq._();
  @$core.override
  ClickReq createEmptyInstance() => create();
  static $pb.PbList<ClickReq> createRepeated() => $pb.PbList<ClickReq>();
  @$core.pragma('dart2js:noInline')
  static ClickReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClickReq>(create);
  static ClickReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get sid => $_getI64(0);
  @$pb.TagNumber(1)
  set sid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSid() => $_clearField(1);

  @$pb.TagNumber(2)
  ClickReq_ClickAction get action => $_getN(1);
  @$pb.TagNumber(2)
  set action(ClickReq_ClickAction value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => $_clearField(2);
}

class ClickResp extends $pb.GeneratedMessage {
  factory ClickResp() => create();

  ClickResp._();

  factory ClickResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClickResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClickResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClickResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClickResp copyWith(void Function(ClickResp) updates) =>
      super.copyWith((message) => updates(message as ClickResp)) as ClickResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClickResp create() => ClickResp._();
  @$core.override
  ClickResp createEmptyInstance() => create();
  static $pb.PbList<ClickResp> createRepeated() => $pb.PbList<ClickResp>();
  @$core.pragma('dart2js:noInline')
  static ClickResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClickResp>(create);
  static ClickResp? _defaultInstance;
}

class CoinAddReq extends $pb.GeneratedMessage {
  factory CoinAddReq({
    PlayItem? item,
    $core.int? num,
    $core.bool? thumbUp,
  }) {
    final result = create();
    if (item != null) result.item = item;
    if (num != null) result.num = num;
    if (thumbUp != null) result.thumbUp = thumbUp;
    return result;
  }

  CoinAddReq._();

  factory CoinAddReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CoinAddReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CoinAddReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOM<PlayItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PlayItem.create)
    ..aI(2, _omitFieldNames ? '' : 'num')
    ..aOB(3, _omitFieldNames ? '' : 'thumbUp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CoinAddReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CoinAddReq copyWith(void Function(CoinAddReq) updates) =>
      super.copyWith((message) => updates(message as CoinAddReq)) as CoinAddReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CoinAddReq create() => CoinAddReq._();
  @$core.override
  CoinAddReq createEmptyInstance() => create();
  static $pb.PbList<CoinAddReq> createRepeated() => $pb.PbList<CoinAddReq>();
  @$core.pragma('dart2js:noInline')
  static CoinAddReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CoinAddReq>(create);
  static CoinAddReq? _defaultInstance;

  @$pb.TagNumber(1)
  PlayItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PlayItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PlayItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get num => $_getIZ(1);
  @$pb.TagNumber(2)
  set num($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNum() => $_has(1);
  @$pb.TagNumber(2)
  void clearNum() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get thumbUp => $_getBF(2);
  @$pb.TagNumber(3)
  set thumbUp($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThumbUp() => $_has(2);
  @$pb.TagNumber(3)
  void clearThumbUp() => $_clearField(3);
}

class CoinAddResp extends $pb.GeneratedMessage {
  factory CoinAddResp({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  CoinAddResp._();

  factory CoinAddResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CoinAddResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CoinAddResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CoinAddResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CoinAddResp copyWith(void Function(CoinAddResp) updates) =>
      super.copyWith((message) => updates(message as CoinAddResp))
          as CoinAddResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CoinAddResp create() => CoinAddResp._();
  @$core.override
  CoinAddResp createEmptyInstance() => create();
  static $pb.PbList<CoinAddResp> createRepeated() => $pb.PbList<CoinAddResp>();
  @$core.pragma('dart2js:noInline')
  static CoinAddResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CoinAddResp>(create);
  static CoinAddResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

class DashItem extends $pb.GeneratedMessage {
  factory DashItem({
    $core.int? id,
    $core.String? baseUrl,
    $core.Iterable<$core.String>? backupUrl,
    $core.int? bandwidth,
    $core.String? mimeType,
    $core.String? codecs,
    DashSegmentBase? segmentBase,
    $core.int? codecid,
    $core.String? md5,
    $fixnum.Int64? size,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (baseUrl != null) result.baseUrl = baseUrl;
    if (backupUrl != null) result.backupUrl.addAll(backupUrl);
    if (bandwidth != null) result.bandwidth = bandwidth;
    if (mimeType != null) result.mimeType = mimeType;
    if (codecs != null) result.codecs = codecs;
    if (segmentBase != null) result.segmentBase = segmentBase;
    if (codecid != null) result.codecid = codecid;
    if (md5 != null) result.md5 = md5;
    if (size != null) result.size = size;
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
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'baseUrl')
    ..pPS(3, _omitFieldNames ? '' : 'backupUrl')
    ..aI(4, _omitFieldNames ? '' : 'bandwidth')
    ..aOS(5, _omitFieldNames ? '' : 'mimeType')
    ..aOS(6, _omitFieldNames ? '' : 'codecs')
    ..aOM<DashSegmentBase>(12, _omitFieldNames ? '' : 'segmentBase',
        subBuilder: DashSegmentBase.create)
    ..aI(13, _omitFieldNames ? '' : 'codecid')
    ..aOS(14, _omitFieldNames ? '' : 'md5')
    ..aInt64(15, _omitFieldNames ? '' : 'size')
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
  $core.String get mimeType => $_getSZ(4);
  @$pb.TagNumber(5)
  set mimeType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMimeType() => $_has(4);
  @$pb.TagNumber(5)
  void clearMimeType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get codecs => $_getSZ(5);
  @$pb.TagNumber(6)
  set codecs($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCodecs() => $_has(5);
  @$pb.TagNumber(6)
  void clearCodecs() => $_clearField(6);

  @$pb.TagNumber(12)
  DashSegmentBase get segmentBase => $_getN(6);
  @$pb.TagNumber(12)
  set segmentBase(DashSegmentBase value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasSegmentBase() => $_has(6);
  @$pb.TagNumber(12)
  void clearSegmentBase() => $_clearField(12);
  @$pb.TagNumber(12)
  DashSegmentBase ensureSegmentBase() => $_ensure(6);

  @$pb.TagNumber(13)
  $core.int get codecid => $_getIZ(7);
  @$pb.TagNumber(13)
  set codecid($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(13)
  $core.bool hasCodecid() => $_has(7);
  @$pb.TagNumber(13)
  void clearCodecid() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get md5 => $_getSZ(8);
  @$pb.TagNumber(14)
  set md5($core.String value) => $_setString(8, value);
  @$pb.TagNumber(14)
  $core.bool hasMd5() => $_has(8);
  @$pb.TagNumber(14)
  void clearMd5() => $_clearField(14);

  @$pb.TagNumber(15)
  $fixnum.Int64 get size => $_getI64(9);
  @$pb.TagNumber(15)
  set size($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(15)
  $core.bool hasSize() => $_has(9);
  @$pb.TagNumber(15)
  void clearSize() => $_clearField(15);
}

class DashSegmentBase extends $pb.GeneratedMessage {
  factory DashSegmentBase({
    $core.String? initialization,
    $core.String? indexRange,
  }) {
    final result = create();
    if (initialization != null) result.initialization = initialization;
    if (indexRange != null) result.indexRange = indexRange;
    return result;
  }

  DashSegmentBase._();

  factory DashSegmentBase.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DashSegmentBase.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DashSegmentBase',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'initialization')
    ..aOS(2, _omitFieldNames ? '' : 'indexRange')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DashSegmentBase clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DashSegmentBase copyWith(void Function(DashSegmentBase) updates) =>
      super.copyWith((message) => updates(message as DashSegmentBase))
          as DashSegmentBase;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DashSegmentBase create() => DashSegmentBase._();
  @$core.override
  DashSegmentBase createEmptyInstance() => create();
  static $pb.PbList<DashSegmentBase> createRepeated() =>
      $pb.PbList<DashSegmentBase>();
  @$core.pragma('dart2js:noInline')
  static DashSegmentBase getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DashSegmentBase>(create);
  static DashSegmentBase? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get initialization => $_getSZ(0);
  @$pb.TagNumber(1)
  set initialization($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInitialization() => $_has(0);
  @$pb.TagNumber(1)
  void clearInitialization() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get indexRange => $_getSZ(1);
  @$pb.TagNumber(2)
  set indexRange($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIndexRange() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndexRange() => $_clearField(2);
}

class DetailItem extends $pb.GeneratedMessage {
  factory DetailItem({
    PlayItem? item,
    BKArchive? arc,
    $core.Iterable<BKArcPart>? parts,
    Author? owner,
    BKStat? stat,
    $fixnum.Int64? lastPart,
    $fixnum.Int64? progress,
    $core.int? playable,
    $core.String? message,
    $core.Iterable<$core.MapEntry<$fixnum.Int64, PlayInfo>>? playerInfo,
    PlayItem? associatedItem,
    $fixnum.Int64? lastPlayTime,
    $core.String? historyTag,
    $3.DeviceType? deviceType,
    FavFolder? ugcSeasonInfo,
  }) {
    final result = create();
    if (item != null) result.item = item;
    if (arc != null) result.arc = arc;
    if (parts != null) result.parts.addAll(parts);
    if (owner != null) result.owner = owner;
    if (stat != null) result.stat = stat;
    if (lastPart != null) result.lastPart = lastPart;
    if (progress != null) result.progress = progress;
    if (playable != null) result.playable = playable;
    if (message != null) result.message = message;
    if (playerInfo != null) result.playerInfo.addEntries(playerInfo);
    if (associatedItem != null) result.associatedItem = associatedItem;
    if (lastPlayTime != null) result.lastPlayTime = lastPlayTime;
    if (historyTag != null) result.historyTag = historyTag;
    if (deviceType != null) result.deviceType = deviceType;
    if (ugcSeasonInfo != null) result.ugcSeasonInfo = ugcSeasonInfo;
    return result;
  }

  DetailItem._();

  factory DetailItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DetailItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DetailItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOM<PlayItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PlayItem.create)
    ..aOM<BKArchive>(2, _omitFieldNames ? '' : 'arc',
        subBuilder: BKArchive.create)
    ..pPM<BKArcPart>(3, _omitFieldNames ? '' : 'parts',
        subBuilder: BKArcPart.create)
    ..aOM<Author>(4, _omitFieldNames ? '' : 'owner', subBuilder: Author.create)
    ..aOM<BKStat>(5, _omitFieldNames ? '' : 'stat', subBuilder: BKStat.create)
    ..aInt64(6, _omitFieldNames ? '' : 'lastPart')
    ..aInt64(7, _omitFieldNames ? '' : 'progress')
    ..aI(8, _omitFieldNames ? '' : 'playable')
    ..aOS(9, _omitFieldNames ? '' : 'message')
    ..m<$fixnum.Int64, PlayInfo>(10, _omitFieldNames ? '' : 'playerInfo',
        entryClassName: 'DetailItem.PlayerInfoEntry',
        keyFieldType: $pb.PbFieldType.O6,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: PlayInfo.create,
        valueDefaultOrMaker: PlayInfo.getDefault,
        packageName: const $pb.PackageName('bilibili.app.listener.v1'))
    ..aOM<PlayItem>(11, _omitFieldNames ? '' : 'associatedItem',
        subBuilder: PlayItem.create)
    ..aInt64(12, _omitFieldNames ? '' : 'lastPlayTime')
    ..aOS(13, _omitFieldNames ? '' : 'historyTag')
    ..aOM<$3.DeviceType>(14, _omitFieldNames ? '' : 'deviceType',
        subBuilder: $3.DeviceType.create)
    ..aOM<FavFolder>(15, _omitFieldNames ? '' : 'ugcSeasonInfo',
        subBuilder: FavFolder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DetailItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DetailItem copyWith(void Function(DetailItem) updates) =>
      super.copyWith((message) => updates(message as DetailItem)) as DetailItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DetailItem create() => DetailItem._();
  @$core.override
  DetailItem createEmptyInstance() => create();
  static $pb.PbList<DetailItem> createRepeated() => $pb.PbList<DetailItem>();
  @$core.pragma('dart2js:noInline')
  static DetailItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DetailItem>(create);
  static DetailItem? _defaultInstance;

  @$pb.TagNumber(1)
  PlayItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PlayItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PlayItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  BKArchive get arc => $_getN(1);
  @$pb.TagNumber(2)
  set arc(BKArchive value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasArc() => $_has(1);
  @$pb.TagNumber(2)
  void clearArc() => $_clearField(2);
  @$pb.TagNumber(2)
  BKArchive ensureArc() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<BKArcPart> get parts => $_getList(2);

  @$pb.TagNumber(4)
  Author get owner => $_getN(3);
  @$pb.TagNumber(4)
  set owner(Author value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasOwner() => $_has(3);
  @$pb.TagNumber(4)
  void clearOwner() => $_clearField(4);
  @$pb.TagNumber(4)
  Author ensureOwner() => $_ensure(3);

  @$pb.TagNumber(5)
  BKStat get stat => $_getN(4);
  @$pb.TagNumber(5)
  set stat(BKStat value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStat() => $_has(4);
  @$pb.TagNumber(5)
  void clearStat() => $_clearField(5);
  @$pb.TagNumber(5)
  BKStat ensureStat() => $_ensure(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get lastPart => $_getI64(5);
  @$pb.TagNumber(6)
  set lastPart($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLastPart() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastPart() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get progress => $_getI64(6);
  @$pb.TagNumber(7)
  set progress($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasProgress() => $_has(6);
  @$pb.TagNumber(7)
  void clearProgress() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get playable => $_getIZ(7);
  @$pb.TagNumber(8)
  set playable($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPlayable() => $_has(7);
  @$pb.TagNumber(8)
  void clearPlayable() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get message => $_getSZ(8);
  @$pb.TagNumber(9)
  set message($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMessage() => $_has(8);
  @$pb.TagNumber(9)
  void clearMessage() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbMap<$fixnum.Int64, PlayInfo> get playerInfo => $_getMap(9);

  @$pb.TagNumber(11)
  PlayItem get associatedItem => $_getN(10);
  @$pb.TagNumber(11)
  set associatedItem(PlayItem value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasAssociatedItem() => $_has(10);
  @$pb.TagNumber(11)
  void clearAssociatedItem() => $_clearField(11);
  @$pb.TagNumber(11)
  PlayItem ensureAssociatedItem() => $_ensure(10);

  @$pb.TagNumber(12)
  $fixnum.Int64 get lastPlayTime => $_getI64(11);
  @$pb.TagNumber(12)
  set lastPlayTime($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasLastPlayTime() => $_has(11);
  @$pb.TagNumber(12)
  void clearLastPlayTime() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get historyTag => $_getSZ(12);
  @$pb.TagNumber(13)
  set historyTag($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasHistoryTag() => $_has(12);
  @$pb.TagNumber(13)
  void clearHistoryTag() => $_clearField(13);

  @$pb.TagNumber(14)
  $3.DeviceType get deviceType => $_getN(13);
  @$pb.TagNumber(14)
  set deviceType($3.DeviceType value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasDeviceType() => $_has(13);
  @$pb.TagNumber(14)
  void clearDeviceType() => $_clearField(14);
  @$pb.TagNumber(14)
  $3.DeviceType ensureDeviceType() => $_ensure(13);

  @$pb.TagNumber(15)
  FavFolder get ugcSeasonInfo => $_getN(14);
  @$pb.TagNumber(15)
  set ugcSeasonInfo(FavFolder value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasUgcSeasonInfo() => $_has(14);
  @$pb.TagNumber(15)
  void clearUgcSeasonInfo() => $_clearField(15);
  @$pb.TagNumber(15)
  FavFolder ensureUgcSeasonInfo() => $_ensure(14);
}

class EventReq extends $pb.GeneratedMessage {
  factory EventReq({
    EventReq_EventType? eventType,
    PlayItem? item,
  }) {
    final result = create();
    if (eventType != null) result.eventType = eventType;
    if (item != null) result.item = item;
    return result;
  }

  EventReq._();

  factory EventReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EventReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EventReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aE<EventReq_EventType>(1, _omitFieldNames ? '' : 'eventType',
        enumValues: EventReq_EventType.values)
    ..aOM<PlayItem>(2, _omitFieldNames ? '' : 'item',
        subBuilder: PlayItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EventReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EventReq copyWith(void Function(EventReq) updates) =>
      super.copyWith((message) => updates(message as EventReq)) as EventReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EventReq create() => EventReq._();
  @$core.override
  EventReq createEmptyInstance() => create();
  static $pb.PbList<EventReq> createRepeated() => $pb.PbList<EventReq>();
  @$core.pragma('dart2js:noInline')
  static EventReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventReq>(create);
  static EventReq? _defaultInstance;

  @$pb.TagNumber(1)
  EventReq_EventType get eventType => $_getN(0);
  @$pb.TagNumber(1)
  set eventType(EventReq_EventType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEventType() => $_has(0);
  @$pb.TagNumber(1)
  void clearEventType() => $_clearField(1);

  @$pb.TagNumber(2)
  PlayItem get item => $_getN(1);
  @$pb.TagNumber(2)
  set item(PlayItem value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasItem() => $_has(1);
  @$pb.TagNumber(2)
  void clearItem() => $_clearField(2);
  @$pb.TagNumber(2)
  PlayItem ensureItem() => $_ensure(1);
}

class EventResp extends $pb.GeneratedMessage {
  factory EventResp() => create();

  EventResp._();

  factory EventResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EventResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EventResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EventResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EventResp copyWith(void Function(EventResp) updates) =>
      super.copyWith((message) => updates(message as EventResp)) as EventResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EventResp create() => EventResp._();
  @$core.override
  EventResp createEmptyInstance() => create();
  static $pb.PbList<EventResp> createRepeated() => $pb.PbList<EventResp>();
  @$core.pragma('dart2js:noInline')
  static EventResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventResp>(create);
  static EventResp? _defaultInstance;
}

class EventTracking extends $pb.GeneratedMessage {
  factory EventTracking({
    $core.String? operator,
    $core.String? batch,
    $core.String? trackId,
    $core.String? entityType,
    $core.String? entityId,
    $core.String? trackJson,
  }) {
    final result = create();
    if (operator != null) result.operator = operator;
    if (batch != null) result.batch = batch;
    if (trackId != null) result.trackId = trackId;
    if (entityType != null) result.entityType = entityType;
    if (entityId != null) result.entityId = entityId;
    if (trackJson != null) result.trackJson = trackJson;
    return result;
  }

  EventTracking._();

  factory EventTracking.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EventTracking.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EventTracking',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'operator')
    ..aOS(2, _omitFieldNames ? '' : 'batch')
    ..aOS(3, _omitFieldNames ? '' : 'trackId')
    ..aOS(4, _omitFieldNames ? '' : 'entityType')
    ..aOS(5, _omitFieldNames ? '' : 'entityId')
    ..aOS(6, _omitFieldNames ? '' : 'trackJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EventTracking clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EventTracking copyWith(void Function(EventTracking) updates) =>
      super.copyWith((message) => updates(message as EventTracking))
          as EventTracking;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EventTracking create() => EventTracking._();
  @$core.override
  EventTracking createEmptyInstance() => create();
  static $pb.PbList<EventTracking> createRepeated() =>
      $pb.PbList<EventTracking>();
  @$core.pragma('dart2js:noInline')
  static EventTracking getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EventTracking>(create);
  static EventTracking? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get operator => $_getSZ(0);
  @$pb.TagNumber(1)
  set operator($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOperator() => $_has(0);
  @$pb.TagNumber(1)
  void clearOperator() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get batch => $_getSZ(1);
  @$pb.TagNumber(2)
  set batch($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBatch() => $_has(1);
  @$pb.TagNumber(2)
  void clearBatch() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get trackId => $_getSZ(2);
  @$pb.TagNumber(3)
  set trackId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTrackId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTrackId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get entityType => $_getSZ(3);
  @$pb.TagNumber(4)
  set entityType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEntityType() => $_has(3);
  @$pb.TagNumber(4)
  void clearEntityType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get entityId => $_getSZ(4);
  @$pb.TagNumber(5)
  set entityId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEntityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearEntityId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get trackJson => $_getSZ(5);
  @$pb.TagNumber(6)
  set trackJson($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTrackJson() => $_has(5);
  @$pb.TagNumber(6)
  void clearTrackJson() => $_clearField(6);
}

class FavFolder extends $pb.GeneratedMessage {
  factory FavFolder({
    $fixnum.Int64? fid,
    $core.int? folderType,
    FavFolderAuthor? owner,
    $core.String? name,
    $core.String? cover,
    $core.String? desc,
    $core.int? count,
    $core.int? attr,
    $core.int? state,
    $core.int? favored,
    $fixnum.Int64? ctime,
    $fixnum.Int64? mtime,
    $core.int? statFavCnt,
    $core.int? statShareCnt,
    $core.int? statLikeCnt,
    $core.int? statPlayCnt,
    $core.int? statReplyCnt,
    $core.int? favState,
    $core.bool? useViewVt,
    $core.String? viewVtText,
  }) {
    final result = create();
    if (fid != null) result.fid = fid;
    if (folderType != null) result.folderType = folderType;
    if (owner != null) result.owner = owner;
    if (name != null) result.name = name;
    if (cover != null) result.cover = cover;
    if (desc != null) result.desc = desc;
    if (count != null) result.count = count;
    if (attr != null) result.attr = attr;
    if (state != null) result.state = state;
    if (favored != null) result.favored = favored;
    if (ctime != null) result.ctime = ctime;
    if (mtime != null) result.mtime = mtime;
    if (statFavCnt != null) result.statFavCnt = statFavCnt;
    if (statShareCnt != null) result.statShareCnt = statShareCnt;
    if (statLikeCnt != null) result.statLikeCnt = statLikeCnt;
    if (statPlayCnt != null) result.statPlayCnt = statPlayCnt;
    if (statReplyCnt != null) result.statReplyCnt = statReplyCnt;
    if (favState != null) result.favState = favState;
    if (useViewVt != null) result.useViewVt = useViewVt;
    if (viewVtText != null) result.viewVtText = viewVtText;
    return result;
  }

  FavFolder._();

  factory FavFolder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavFolder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavFolder',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'fid')
    ..aI(2, _omitFieldNames ? '' : 'folderType')
    ..aOM<FavFolderAuthor>(3, _omitFieldNames ? '' : 'owner',
        subBuilder: FavFolderAuthor.create)
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOS(5, _omitFieldNames ? '' : 'cover')
    ..aOS(6, _omitFieldNames ? '' : 'desc')
    ..aI(7, _omitFieldNames ? '' : 'count')
    ..aI(8, _omitFieldNames ? '' : 'attr')
    ..aI(9, _omitFieldNames ? '' : 'state')
    ..aI(10, _omitFieldNames ? '' : 'favored')
    ..aInt64(11, _omitFieldNames ? '' : 'ctime')
    ..aInt64(12, _omitFieldNames ? '' : 'mtime')
    ..aI(13, _omitFieldNames ? '' : 'statFavCnt')
    ..aI(14, _omitFieldNames ? '' : 'statShareCnt')
    ..aI(15, _omitFieldNames ? '' : 'statLikeCnt')
    ..aI(16, _omitFieldNames ? '' : 'statPlayCnt')
    ..aI(17, _omitFieldNames ? '' : 'statReplyCnt')
    ..aI(18, _omitFieldNames ? '' : 'favState')
    ..aOB(19, _omitFieldNames ? '' : 'useViewVt')
    ..aOS(20, _omitFieldNames ? '' : 'viewVtText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolder copyWith(void Function(FavFolder) updates) =>
      super.copyWith((message) => updates(message as FavFolder)) as FavFolder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavFolder create() => FavFolder._();
  @$core.override
  FavFolder createEmptyInstance() => create();
  static $pb.PbList<FavFolder> createRepeated() => $pb.PbList<FavFolder>();
  @$core.pragma('dart2js:noInline')
  static FavFolder getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FavFolder>(create);
  static FavFolder? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get fid => $_getI64(0);
  @$pb.TagNumber(1)
  set fid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFid() => $_has(0);
  @$pb.TagNumber(1)
  void clearFid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get folderType => $_getIZ(1);
  @$pb.TagNumber(2)
  set folderType($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFolderType() => $_has(1);
  @$pb.TagNumber(2)
  void clearFolderType() => $_clearField(2);

  @$pb.TagNumber(3)
  FavFolderAuthor get owner => $_getN(2);
  @$pb.TagNumber(3)
  set owner(FavFolderAuthor value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOwner() => $_has(2);
  @$pb.TagNumber(3)
  void clearOwner() => $_clearField(3);
  @$pb.TagNumber(3)
  FavFolderAuthor ensureOwner() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get cover => $_getSZ(4);
  @$pb.TagNumber(5)
  set cover($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCover() => $_has(4);
  @$pb.TagNumber(5)
  void clearCover() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get desc => $_getSZ(5);
  @$pb.TagNumber(6)
  set desc($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDesc() => $_has(5);
  @$pb.TagNumber(6)
  void clearDesc() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get count => $_getIZ(6);
  @$pb.TagNumber(7)
  set count($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get attr => $_getIZ(7);
  @$pb.TagNumber(8)
  set attr($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAttr() => $_has(7);
  @$pb.TagNumber(8)
  void clearAttr() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get state => $_getIZ(8);
  @$pb.TagNumber(9)
  set state($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasState() => $_has(8);
  @$pb.TagNumber(9)
  void clearState() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get favored => $_getIZ(9);
  @$pb.TagNumber(10)
  set favored($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasFavored() => $_has(9);
  @$pb.TagNumber(10)
  void clearFavored() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get ctime => $_getI64(10);
  @$pb.TagNumber(11)
  set ctime($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCtime() => $_has(10);
  @$pb.TagNumber(11)
  void clearCtime() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get mtime => $_getI64(11);
  @$pb.TagNumber(12)
  set mtime($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasMtime() => $_has(11);
  @$pb.TagNumber(12)
  void clearMtime() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get statFavCnt => $_getIZ(12);
  @$pb.TagNumber(13)
  set statFavCnt($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasStatFavCnt() => $_has(12);
  @$pb.TagNumber(13)
  void clearStatFavCnt() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get statShareCnt => $_getIZ(13);
  @$pb.TagNumber(14)
  set statShareCnt($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasStatShareCnt() => $_has(13);
  @$pb.TagNumber(14)
  void clearStatShareCnt() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get statLikeCnt => $_getIZ(14);
  @$pb.TagNumber(15)
  set statLikeCnt($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasStatLikeCnt() => $_has(14);
  @$pb.TagNumber(15)
  void clearStatLikeCnt() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.int get statPlayCnt => $_getIZ(15);
  @$pb.TagNumber(16)
  set statPlayCnt($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasStatPlayCnt() => $_has(15);
  @$pb.TagNumber(16)
  void clearStatPlayCnt() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.int get statReplyCnt => $_getIZ(16);
  @$pb.TagNumber(17)
  set statReplyCnt($core.int value) => $_setSignedInt32(16, value);
  @$pb.TagNumber(17)
  $core.bool hasStatReplyCnt() => $_has(16);
  @$pb.TagNumber(17)
  void clearStatReplyCnt() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.int get favState => $_getIZ(17);
  @$pb.TagNumber(18)
  set favState($core.int value) => $_setSignedInt32(17, value);
  @$pb.TagNumber(18)
  $core.bool hasFavState() => $_has(17);
  @$pb.TagNumber(18)
  void clearFavState() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.bool get useViewVt => $_getBF(18);
  @$pb.TagNumber(19)
  set useViewVt($core.bool value) => $_setBool(18, value);
  @$pb.TagNumber(19)
  $core.bool hasUseViewVt() => $_has(18);
  @$pb.TagNumber(19)
  void clearUseViewVt() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.String get viewVtText => $_getSZ(19);
  @$pb.TagNumber(20)
  set viewVtText($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasViewVtText() => $_has(19);
  @$pb.TagNumber(20)
  void clearViewVtText() => $_clearField(20);
}

class FavFolderAction extends $pb.GeneratedMessage {
  factory FavFolderAction({
    $fixnum.Int64? fid,
    $core.int? folderType,
    FavFolderAction_Action? action,
  }) {
    final result = create();
    if (fid != null) result.fid = fid;
    if (folderType != null) result.folderType = folderType;
    if (action != null) result.action = action;
    return result;
  }

  FavFolderAction._();

  factory FavFolderAction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavFolderAction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavFolderAction',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'fid')
    ..aI(2, _omitFieldNames ? '' : 'folderType')
    ..aE<FavFolderAction_Action>(3, _omitFieldNames ? '' : 'action',
        enumValues: FavFolderAction_Action.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderAction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderAction copyWith(void Function(FavFolderAction) updates) =>
      super.copyWith((message) => updates(message as FavFolderAction))
          as FavFolderAction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavFolderAction create() => FavFolderAction._();
  @$core.override
  FavFolderAction createEmptyInstance() => create();
  static $pb.PbList<FavFolderAction> createRepeated() =>
      $pb.PbList<FavFolderAction>();
  @$core.pragma('dart2js:noInline')
  static FavFolderAction getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavFolderAction>(create);
  static FavFolderAction? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get fid => $_getI64(0);
  @$pb.TagNumber(1)
  set fid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFid() => $_has(0);
  @$pb.TagNumber(1)
  void clearFid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get folderType => $_getIZ(1);
  @$pb.TagNumber(2)
  set folderType($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFolderType() => $_has(1);
  @$pb.TagNumber(2)
  void clearFolderType() => $_clearField(2);

  @$pb.TagNumber(3)
  FavFolderAction_Action get action => $_getN(2);
  @$pb.TagNumber(3)
  set action(FavFolderAction_Action value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAction() => $_has(2);
  @$pb.TagNumber(3)
  void clearAction() => $_clearField(3);
}

class FavFolderAuthor extends $pb.GeneratedMessage {
  factory FavFolderAuthor({
    $fixnum.Int64? mid,
    $core.String? name,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    if (name != null) result.name = name;
    return result;
  }

  FavFolderAuthor._();

  factory FavFolderAuthor.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavFolderAuthor.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavFolderAuthor',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderAuthor clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderAuthor copyWith(void Function(FavFolderAuthor) updates) =>
      super.copyWith((message) => updates(message as FavFolderAuthor))
          as FavFolderAuthor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavFolderAuthor create() => FavFolderAuthor._();
  @$core.override
  FavFolderAuthor createEmptyInstance() => create();
  static $pb.PbList<FavFolderAuthor> createRepeated() =>
      $pb.PbList<FavFolderAuthor>();
  @$core.pragma('dart2js:noInline')
  static FavFolderAuthor getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavFolderAuthor>(create);
  static FavFolderAuthor? _defaultInstance;

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
}

class FavFolderCreateReq extends $pb.GeneratedMessage {
  factory FavFolderCreateReq({
    $core.String? name,
    $core.String? desc,
    $core.int? public,
    $core.int? folderType,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (desc != null) result.desc = desc;
    if (public != null) result.public = public;
    if (folderType != null) result.folderType = folderType;
    return result;
  }

  FavFolderCreateReq._();

  factory FavFolderCreateReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavFolderCreateReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavFolderCreateReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'desc')
    ..aI(3, _omitFieldNames ? '' : 'public')
    ..aI(4, _omitFieldNames ? '' : 'folderType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderCreateReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderCreateReq copyWith(void Function(FavFolderCreateReq) updates) =>
      super.copyWith((message) => updates(message as FavFolderCreateReq))
          as FavFolderCreateReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavFolderCreateReq create() => FavFolderCreateReq._();
  @$core.override
  FavFolderCreateReq createEmptyInstance() => create();
  static $pb.PbList<FavFolderCreateReq> createRepeated() =>
      $pb.PbList<FavFolderCreateReq>();
  @$core.pragma('dart2js:noInline')
  static FavFolderCreateReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavFolderCreateReq>(create);
  static FavFolderCreateReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get desc => $_getSZ(1);
  @$pb.TagNumber(2)
  set desc($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDesc() => $_has(1);
  @$pb.TagNumber(2)
  void clearDesc() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get public => $_getIZ(2);
  @$pb.TagNumber(3)
  set public($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPublic() => $_has(2);
  @$pb.TagNumber(3)
  void clearPublic() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get folderType => $_getIZ(3);
  @$pb.TagNumber(4)
  set folderType($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFolderType() => $_has(3);
  @$pb.TagNumber(4)
  void clearFolderType() => $_clearField(4);
}

class FavFolderCreateResp extends $pb.GeneratedMessage {
  factory FavFolderCreateResp({
    $fixnum.Int64? fid,
    $core.int? folderType,
    $core.String? message,
  }) {
    final result = create();
    if (fid != null) result.fid = fid;
    if (folderType != null) result.folderType = folderType;
    if (message != null) result.message = message;
    return result;
  }

  FavFolderCreateResp._();

  factory FavFolderCreateResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavFolderCreateResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavFolderCreateResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'fid')
    ..aI(2, _omitFieldNames ? '' : 'folderType')
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderCreateResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderCreateResp copyWith(void Function(FavFolderCreateResp) updates) =>
      super.copyWith((message) => updates(message as FavFolderCreateResp))
          as FavFolderCreateResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavFolderCreateResp create() => FavFolderCreateResp._();
  @$core.override
  FavFolderCreateResp createEmptyInstance() => create();
  static $pb.PbList<FavFolderCreateResp> createRepeated() =>
      $pb.PbList<FavFolderCreateResp>();
  @$core.pragma('dart2js:noInline')
  static FavFolderCreateResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavFolderCreateResp>(create);
  static FavFolderCreateResp? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get fid => $_getI64(0);
  @$pb.TagNumber(1)
  set fid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFid() => $_has(0);
  @$pb.TagNumber(1)
  void clearFid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get folderType => $_getIZ(1);
  @$pb.TagNumber(2)
  set folderType($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFolderType() => $_has(1);
  @$pb.TagNumber(2)
  void clearFolderType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);
}

class FavFolderDeleteReq extends $pb.GeneratedMessage {
  factory FavFolderDeleteReq({
    $fixnum.Int64? fid,
    $core.int? folderType,
  }) {
    final result = create();
    if (fid != null) result.fid = fid;
    if (folderType != null) result.folderType = folderType;
    return result;
  }

  FavFolderDeleteReq._();

  factory FavFolderDeleteReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavFolderDeleteReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavFolderDeleteReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'fid')
    ..aI(2, _omitFieldNames ? '' : 'folderType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderDeleteReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderDeleteReq copyWith(void Function(FavFolderDeleteReq) updates) =>
      super.copyWith((message) => updates(message as FavFolderDeleteReq))
          as FavFolderDeleteReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavFolderDeleteReq create() => FavFolderDeleteReq._();
  @$core.override
  FavFolderDeleteReq createEmptyInstance() => create();
  static $pb.PbList<FavFolderDeleteReq> createRepeated() =>
      $pb.PbList<FavFolderDeleteReq>();
  @$core.pragma('dart2js:noInline')
  static FavFolderDeleteReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavFolderDeleteReq>(create);
  static FavFolderDeleteReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get fid => $_getI64(0);
  @$pb.TagNumber(1)
  set fid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFid() => $_has(0);
  @$pb.TagNumber(1)
  void clearFid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get folderType => $_getIZ(1);
  @$pb.TagNumber(2)
  set folderType($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFolderType() => $_has(1);
  @$pb.TagNumber(2)
  void clearFolderType() => $_clearField(2);
}

class FavFolderDeleteResp extends $pb.GeneratedMessage {
  factory FavFolderDeleteResp({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  FavFolderDeleteResp._();

  factory FavFolderDeleteResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavFolderDeleteResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavFolderDeleteResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderDeleteResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderDeleteResp copyWith(void Function(FavFolderDeleteResp) updates) =>
      super.copyWith((message) => updates(message as FavFolderDeleteResp))
          as FavFolderDeleteResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavFolderDeleteResp create() => FavFolderDeleteResp._();
  @$core.override
  FavFolderDeleteResp createEmptyInstance() => create();
  static $pb.PbList<FavFolderDeleteResp> createRepeated() =>
      $pb.PbList<FavFolderDeleteResp>();
  @$core.pragma('dart2js:noInline')
  static FavFolderDeleteResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavFolderDeleteResp>(create);
  static FavFolderDeleteResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

class FavFolderDetailReq extends $pb.GeneratedMessage {
  factory FavFolderDetailReq({
    $fixnum.Int64? fid,
    $core.int? folderType,
    $fixnum.Int64? favMid,
    FavItem? lastItem,
    $core.int? pageSize,
    $core.bool? needFolderInfo,
  }) {
    final result = create();
    if (fid != null) result.fid = fid;
    if (folderType != null) result.folderType = folderType;
    if (favMid != null) result.favMid = favMid;
    if (lastItem != null) result.lastItem = lastItem;
    if (pageSize != null) result.pageSize = pageSize;
    if (needFolderInfo != null) result.needFolderInfo = needFolderInfo;
    return result;
  }

  FavFolderDetailReq._();

  factory FavFolderDetailReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavFolderDetailReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavFolderDetailReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'fid')
    ..aI(2, _omitFieldNames ? '' : 'folderType')
    ..aInt64(3, _omitFieldNames ? '' : 'favMid')
    ..aOM<FavItem>(4, _omitFieldNames ? '' : 'lastItem',
        subBuilder: FavItem.create)
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..aOB(6, _omitFieldNames ? '' : 'needFolderInfo')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderDetailReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderDetailReq copyWith(void Function(FavFolderDetailReq) updates) =>
      super.copyWith((message) => updates(message as FavFolderDetailReq))
          as FavFolderDetailReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavFolderDetailReq create() => FavFolderDetailReq._();
  @$core.override
  FavFolderDetailReq createEmptyInstance() => create();
  static $pb.PbList<FavFolderDetailReq> createRepeated() =>
      $pb.PbList<FavFolderDetailReq>();
  @$core.pragma('dart2js:noInline')
  static FavFolderDetailReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavFolderDetailReq>(create);
  static FavFolderDetailReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get fid => $_getI64(0);
  @$pb.TagNumber(1)
  set fid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFid() => $_has(0);
  @$pb.TagNumber(1)
  void clearFid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get folderType => $_getIZ(1);
  @$pb.TagNumber(2)
  set folderType($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFolderType() => $_has(1);
  @$pb.TagNumber(2)
  void clearFolderType() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get favMid => $_getI64(2);
  @$pb.TagNumber(3)
  set favMid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFavMid() => $_has(2);
  @$pb.TagNumber(3)
  void clearFavMid() => $_clearField(3);

  @$pb.TagNumber(4)
  FavItem get lastItem => $_getN(3);
  @$pb.TagNumber(4)
  set lastItem(FavItem value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLastItem() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastItem() => $_clearField(4);
  @$pb.TagNumber(4)
  FavItem ensureLastItem() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get needFolderInfo => $_getBF(5);
  @$pb.TagNumber(6)
  set needFolderInfo($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNeedFolderInfo() => $_has(5);
  @$pb.TagNumber(6)
  void clearNeedFolderInfo() => $_clearField(6);
}

class FavFolderDetailResp extends $pb.GeneratedMessage {
  factory FavFolderDetailResp({
    $core.int? total,
    $core.bool? reachEnd,
    $core.Iterable<FavItemDetail>? list,
    FavFolder? folderInfo,
  }) {
    final result = create();
    if (total != null) result.total = total;
    if (reachEnd != null) result.reachEnd = reachEnd;
    if (list != null) result.list.addAll(list);
    if (folderInfo != null) result.folderInfo = folderInfo;
    return result;
  }

  FavFolderDetailResp._();

  factory FavFolderDetailResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavFolderDetailResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavFolderDetailResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'total')
    ..aOB(2, _omitFieldNames ? '' : 'reachEnd')
    ..pPM<FavItemDetail>(3, _omitFieldNames ? '' : 'list',
        subBuilder: FavItemDetail.create)
    ..aOM<FavFolder>(4, _omitFieldNames ? '' : 'folderInfo',
        subBuilder: FavFolder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderDetailResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderDetailResp copyWith(void Function(FavFolderDetailResp) updates) =>
      super.copyWith((message) => updates(message as FavFolderDetailResp))
          as FavFolderDetailResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavFolderDetailResp create() => FavFolderDetailResp._();
  @$core.override
  FavFolderDetailResp createEmptyInstance() => create();
  static $pb.PbList<FavFolderDetailResp> createRepeated() =>
      $pb.PbList<FavFolderDetailResp>();
  @$core.pragma('dart2js:noInline')
  static FavFolderDetailResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavFolderDetailResp>(create);
  static FavFolderDetailResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get total => $_getIZ(0);
  @$pb.TagNumber(1)
  set total($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get reachEnd => $_getBF(1);
  @$pb.TagNumber(2)
  set reachEnd($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReachEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearReachEnd() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<FavItemDetail> get list => $_getList(2);

  @$pb.TagNumber(4)
  FavFolder get folderInfo => $_getN(3);
  @$pb.TagNumber(4)
  set folderInfo(FavFolder value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFolderInfo() => $_has(3);
  @$pb.TagNumber(4)
  void clearFolderInfo() => $_clearField(4);
  @$pb.TagNumber(4)
  FavFolder ensureFolderInfo() => $_ensure(3);
}

class FavFolderListReq extends $pb.GeneratedMessage {
  factory FavFolderListReq({
    $core.Iterable<$core.int>? folderTypes,
    PlayItem? item,
  }) {
    final result = create();
    if (folderTypes != null) result.folderTypes.addAll(folderTypes);
    if (item != null) result.item = item;
    return result;
  }

  FavFolderListReq._();

  factory FavFolderListReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavFolderListReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavFolderListReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..p<$core.int>(1, _omitFieldNames ? '' : 'folderTypes', $pb.PbFieldType.K3)
    ..aOM<PlayItem>(2, _omitFieldNames ? '' : 'item',
        subBuilder: PlayItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderListReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderListReq copyWith(void Function(FavFolderListReq) updates) =>
      super.copyWith((message) => updates(message as FavFolderListReq))
          as FavFolderListReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavFolderListReq create() => FavFolderListReq._();
  @$core.override
  FavFolderListReq createEmptyInstance() => create();
  static $pb.PbList<FavFolderListReq> createRepeated() =>
      $pb.PbList<FavFolderListReq>();
  @$core.pragma('dart2js:noInline')
  static FavFolderListReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavFolderListReq>(create);
  static FavFolderListReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.int> get folderTypes => $_getList(0);

  @$pb.TagNumber(2)
  PlayItem get item => $_getN(1);
  @$pb.TagNumber(2)
  set item(PlayItem value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasItem() => $_has(1);
  @$pb.TagNumber(2)
  void clearItem() => $_clearField(2);
  @$pb.TagNumber(2)
  PlayItem ensureItem() => $_ensure(1);
}

class FavFolderListResp extends $pb.GeneratedMessage {
  factory FavFolderListResp({
    $core.Iterable<FavFolder>? list,
  }) {
    final result = create();
    if (list != null) result.list.addAll(list);
    return result;
  }

  FavFolderListResp._();

  factory FavFolderListResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavFolderListResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavFolderListResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..pPM<FavFolder>(1, _omitFieldNames ? '' : 'list',
        subBuilder: FavFolder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderListResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderListResp copyWith(void Function(FavFolderListResp) updates) =>
      super.copyWith((message) => updates(message as FavFolderListResp))
          as FavFolderListResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavFolderListResp create() => FavFolderListResp._();
  @$core.override
  FavFolderListResp createEmptyInstance() => create();
  static $pb.PbList<FavFolderListResp> createRepeated() =>
      $pb.PbList<FavFolderListResp>();
  @$core.pragma('dart2js:noInline')
  static FavFolderListResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavFolderListResp>(create);
  static FavFolderListResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FavFolder> get list => $_getList(0);
}

class FavFolderMeta extends $pb.GeneratedMessage {
  factory FavFolderMeta({
    $fixnum.Int64? fid,
    $core.int? folderType,
  }) {
    final result = create();
    if (fid != null) result.fid = fid;
    if (folderType != null) result.folderType = folderType;
    return result;
  }

  FavFolderMeta._();

  factory FavFolderMeta.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavFolderMeta.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavFolderMeta',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'fid')
    ..aI(2, _omitFieldNames ? '' : 'folderType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderMeta clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavFolderMeta copyWith(void Function(FavFolderMeta) updates) =>
      super.copyWith((message) => updates(message as FavFolderMeta))
          as FavFolderMeta;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavFolderMeta create() => FavFolderMeta._();
  @$core.override
  FavFolderMeta createEmptyInstance() => create();
  static $pb.PbList<FavFolderMeta> createRepeated() =>
      $pb.PbList<FavFolderMeta>();
  @$core.pragma('dart2js:noInline')
  static FavFolderMeta getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavFolderMeta>(create);
  static FavFolderMeta? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get fid => $_getI64(0);
  @$pb.TagNumber(1)
  set fid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFid() => $_has(0);
  @$pb.TagNumber(1)
  void clearFid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get folderType => $_getIZ(1);
  @$pb.TagNumber(2)
  set folderType($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFolderType() => $_has(1);
  @$pb.TagNumber(2)
  void clearFolderType() => $_clearField(2);
}

class FavItem extends $pb.GeneratedMessage {
  factory FavItem({
    $core.int? itemType,
    $fixnum.Int64? oid,
    $fixnum.Int64? fid,
    $fixnum.Int64? mid,
    $fixnum.Int64? mtime,
    $fixnum.Int64? ctime,
    EventTracking? et,
  }) {
    final result = create();
    if (itemType != null) result.itemType = itemType;
    if (oid != null) result.oid = oid;
    if (fid != null) result.fid = fid;
    if (mid != null) result.mid = mid;
    if (mtime != null) result.mtime = mtime;
    if (ctime != null) result.ctime = ctime;
    if (et != null) result.et = et;
    return result;
  }

  FavItem._();

  factory FavItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'itemType')
    ..aInt64(2, _omitFieldNames ? '' : 'oid')
    ..aInt64(3, _omitFieldNames ? '' : 'fid')
    ..aInt64(4, _omitFieldNames ? '' : 'mid')
    ..aInt64(5, _omitFieldNames ? '' : 'mtime')
    ..aInt64(6, _omitFieldNames ? '' : 'ctime')
    ..aOM<EventTracking>(7, _omitFieldNames ? '' : 'et',
        subBuilder: EventTracking.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItem copyWith(void Function(FavItem) updates) =>
      super.copyWith((message) => updates(message as FavItem)) as FavItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavItem create() => FavItem._();
  @$core.override
  FavItem createEmptyInstance() => create();
  static $pb.PbList<FavItem> createRepeated() => $pb.PbList<FavItem>();
  @$core.pragma('dart2js:noInline')
  static FavItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FavItem>(create);
  static FavItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get itemType => $_getIZ(0);
  @$pb.TagNumber(1)
  set itemType($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemType() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemType() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get oid => $_getI64(1);
  @$pb.TagNumber(2)
  set oid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get fid => $_getI64(2);
  @$pb.TagNumber(3)
  set fid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFid() => $_has(2);
  @$pb.TagNumber(3)
  void clearFid() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get mid => $_getI64(3);
  @$pb.TagNumber(4)
  set mid($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMid() => $_has(3);
  @$pb.TagNumber(4)
  void clearMid() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get mtime => $_getI64(4);
  @$pb.TagNumber(5)
  set mtime($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMtime() => $_has(4);
  @$pb.TagNumber(5)
  void clearMtime() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get ctime => $_getI64(5);
  @$pb.TagNumber(6)
  set ctime($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCtime() => $_has(5);
  @$pb.TagNumber(6)
  void clearCtime() => $_clearField(6);

  @$pb.TagNumber(7)
  EventTracking get et => $_getN(6);
  @$pb.TagNumber(7)
  set et(EventTracking value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasEt() => $_has(6);
  @$pb.TagNumber(7)
  void clearEt() => $_clearField(7);
  @$pb.TagNumber(7)
  EventTracking ensureEt() => $_ensure(6);
}

enum FavItemAddReq_Item { play, fav, notSet }

class FavItemAddReq extends $pb.GeneratedMessage {
  factory FavItemAddReq({
    $fixnum.Int64? fid,
    $core.int? folderType,
    PlayItem? play,
    FavItem? fav,
    $core.bool? isFastAddFav,
  }) {
    final result = create();
    if (fid != null) result.fid = fid;
    if (folderType != null) result.folderType = folderType;
    if (play != null) result.play = play;
    if (fav != null) result.fav = fav;
    if (isFastAddFav != null) result.isFastAddFav = isFastAddFav;
    return result;
  }

  FavItemAddReq._();

  factory FavItemAddReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavItemAddReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, FavItemAddReq_Item>
      _FavItemAddReq_ItemByTag = {
    3: FavItemAddReq_Item.play,
    4: FavItemAddReq_Item.fav,
    0: FavItemAddReq_Item.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavItemAddReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..oo(0, [3, 4])
    ..aInt64(1, _omitFieldNames ? '' : 'fid')
    ..aI(2, _omitFieldNames ? '' : 'folderType')
    ..aOM<PlayItem>(3, _omitFieldNames ? '' : 'play',
        subBuilder: PlayItem.create)
    ..aOM<FavItem>(4, _omitFieldNames ? '' : 'fav', subBuilder: FavItem.create)
    ..aOB(5, _omitFieldNames ? '' : 'isFastAddFav')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItemAddReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItemAddReq copyWith(void Function(FavItemAddReq) updates) =>
      super.copyWith((message) => updates(message as FavItemAddReq))
          as FavItemAddReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavItemAddReq create() => FavItemAddReq._();
  @$core.override
  FavItemAddReq createEmptyInstance() => create();
  static $pb.PbList<FavItemAddReq> createRepeated() =>
      $pb.PbList<FavItemAddReq>();
  @$core.pragma('dart2js:noInline')
  static FavItemAddReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavItemAddReq>(create);
  static FavItemAddReq? _defaultInstance;

  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  FavItemAddReq_Item whichItem() => _FavItemAddReq_ItemByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearItem() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get fid => $_getI64(0);
  @$pb.TagNumber(1)
  set fid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFid() => $_has(0);
  @$pb.TagNumber(1)
  void clearFid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get folderType => $_getIZ(1);
  @$pb.TagNumber(2)
  set folderType($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFolderType() => $_has(1);
  @$pb.TagNumber(2)
  void clearFolderType() => $_clearField(2);

  @$pb.TagNumber(3)
  PlayItem get play => $_getN(2);
  @$pb.TagNumber(3)
  set play(PlayItem value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPlay() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlay() => $_clearField(3);
  @$pb.TagNumber(3)
  PlayItem ensurePlay() => $_ensure(2);

  @$pb.TagNumber(4)
  FavItem get fav => $_getN(3);
  @$pb.TagNumber(4)
  set fav(FavItem value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFav() => $_has(3);
  @$pb.TagNumber(4)
  void clearFav() => $_clearField(4);
  @$pb.TagNumber(4)
  FavItem ensureFav() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get isFastAddFav => $_getBF(4);
  @$pb.TagNumber(5)
  set isFastAddFav($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsFastAddFav() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsFastAddFav() => $_clearField(5);
}

class FavItemAddResp extends $pb.GeneratedMessage {
  factory FavItemAddResp({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  FavItemAddResp._();

  factory FavItemAddResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavItemAddResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavItemAddResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItemAddResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItemAddResp copyWith(void Function(FavItemAddResp) updates) =>
      super.copyWith((message) => updates(message as FavItemAddResp))
          as FavItemAddResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavItemAddResp create() => FavItemAddResp._();
  @$core.override
  FavItemAddResp createEmptyInstance() => create();
  static $pb.PbList<FavItemAddResp> createRepeated() =>
      $pb.PbList<FavItemAddResp>();
  @$core.pragma('dart2js:noInline')
  static FavItemAddResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavItemAddResp>(create);
  static FavItemAddResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

class FavItemAuthor extends $pb.GeneratedMessage {
  factory FavItemAuthor({
    $fixnum.Int64? mid,
    $core.String? name,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    if (name != null) result.name = name;
    return result;
  }

  FavItemAuthor._();

  factory FavItemAuthor.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavItemAuthor.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavItemAuthor',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItemAuthor clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItemAuthor copyWith(void Function(FavItemAuthor) updates) =>
      super.copyWith((message) => updates(message as FavItemAuthor))
          as FavItemAuthor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavItemAuthor create() => FavItemAuthor._();
  @$core.override
  FavItemAuthor createEmptyInstance() => create();
  static $pb.PbList<FavItemAuthor> createRepeated() =>
      $pb.PbList<FavItemAuthor>();
  @$core.pragma('dart2js:noInline')
  static FavItemAuthor getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavItemAuthor>(create);
  static FavItemAuthor? _defaultInstance;

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
}

enum FavItemBatchReq_Item { play, fav, notSet }

class FavItemBatchReq extends $pb.GeneratedMessage {
  factory FavItemBatchReq({
    $core.Iterable<FavFolderAction>? actions,
    PlayItem? play,
    FavItem? fav,
  }) {
    final result = create();
    if (actions != null) result.actions.addAll(actions);
    if (play != null) result.play = play;
    if (fav != null) result.fav = fav;
    return result;
  }

  FavItemBatchReq._();

  factory FavItemBatchReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavItemBatchReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, FavItemBatchReq_Item>
      _FavItemBatchReq_ItemByTag = {
    2: FavItemBatchReq_Item.play,
    3: FavItemBatchReq_Item.fav,
    0: FavItemBatchReq_Item.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavItemBatchReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..pPM<FavFolderAction>(1, _omitFieldNames ? '' : 'actions',
        subBuilder: FavFolderAction.create)
    ..aOM<PlayItem>(2, _omitFieldNames ? '' : 'play',
        subBuilder: PlayItem.create)
    ..aOM<FavItem>(3, _omitFieldNames ? '' : 'fav', subBuilder: FavItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItemBatchReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItemBatchReq copyWith(void Function(FavItemBatchReq) updates) =>
      super.copyWith((message) => updates(message as FavItemBatchReq))
          as FavItemBatchReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavItemBatchReq create() => FavItemBatchReq._();
  @$core.override
  FavItemBatchReq createEmptyInstance() => create();
  static $pb.PbList<FavItemBatchReq> createRepeated() =>
      $pb.PbList<FavItemBatchReq>();
  @$core.pragma('dart2js:noInline')
  static FavItemBatchReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavItemBatchReq>(create);
  static FavItemBatchReq? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  FavItemBatchReq_Item whichItem() =>
      _FavItemBatchReq_ItemByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearItem() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $pb.PbList<FavFolderAction> get actions => $_getList(0);

  @$pb.TagNumber(2)
  PlayItem get play => $_getN(1);
  @$pb.TagNumber(2)
  set play(PlayItem value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlay() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlay() => $_clearField(2);
  @$pb.TagNumber(2)
  PlayItem ensurePlay() => $_ensure(1);

  @$pb.TagNumber(3)
  FavItem get fav => $_getN(2);
  @$pb.TagNumber(3)
  set fav(FavItem value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFav() => $_has(2);
  @$pb.TagNumber(3)
  void clearFav() => $_clearField(3);
  @$pb.TagNumber(3)
  FavItem ensureFav() => $_ensure(2);
}

class FavItemBatchResp extends $pb.GeneratedMessage {
  factory FavItemBatchResp({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  FavItemBatchResp._();

  factory FavItemBatchResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavItemBatchResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavItemBatchResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItemBatchResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItemBatchResp copyWith(void Function(FavItemBatchResp) updates) =>
      super.copyWith((message) => updates(message as FavItemBatchResp))
          as FavItemBatchResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavItemBatchResp create() => FavItemBatchResp._();
  @$core.override
  FavItemBatchResp createEmptyInstance() => create();
  static $pb.PbList<FavItemBatchResp> createRepeated() =>
      $pb.PbList<FavItemBatchResp>();
  @$core.pragma('dart2js:noInline')
  static FavItemBatchResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavItemBatchResp>(create);
  static FavItemBatchResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

enum FavItemDelReq_Item { play, fav, notSet }

class FavItemDelReq extends $pb.GeneratedMessage {
  factory FavItemDelReq({
    $fixnum.Int64? fid,
    $core.int? folderType,
    PlayItem? play,
    FavItem? fav,
    $core.bool? isFastDelFav,
  }) {
    final result = create();
    if (fid != null) result.fid = fid;
    if (folderType != null) result.folderType = folderType;
    if (play != null) result.play = play;
    if (fav != null) result.fav = fav;
    if (isFastDelFav != null) result.isFastDelFav = isFastDelFav;
    return result;
  }

  FavItemDelReq._();

  factory FavItemDelReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavItemDelReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, FavItemDelReq_Item>
      _FavItemDelReq_ItemByTag = {
    3: FavItemDelReq_Item.play,
    4: FavItemDelReq_Item.fav,
    0: FavItemDelReq_Item.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavItemDelReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..oo(0, [3, 4])
    ..aInt64(1, _omitFieldNames ? '' : 'fid')
    ..aI(2, _omitFieldNames ? '' : 'folderType')
    ..aOM<PlayItem>(3, _omitFieldNames ? '' : 'play',
        subBuilder: PlayItem.create)
    ..aOM<FavItem>(4, _omitFieldNames ? '' : 'fav', subBuilder: FavItem.create)
    ..aOB(5, _omitFieldNames ? '' : 'isFastDelFav')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItemDelReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItemDelReq copyWith(void Function(FavItemDelReq) updates) =>
      super.copyWith((message) => updates(message as FavItemDelReq))
          as FavItemDelReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavItemDelReq create() => FavItemDelReq._();
  @$core.override
  FavItemDelReq createEmptyInstance() => create();
  static $pb.PbList<FavItemDelReq> createRepeated() =>
      $pb.PbList<FavItemDelReq>();
  @$core.pragma('dart2js:noInline')
  static FavItemDelReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavItemDelReq>(create);
  static FavItemDelReq? _defaultInstance;

  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  FavItemDelReq_Item whichItem() => _FavItemDelReq_ItemByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearItem() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get fid => $_getI64(0);
  @$pb.TagNumber(1)
  set fid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFid() => $_has(0);
  @$pb.TagNumber(1)
  void clearFid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get folderType => $_getIZ(1);
  @$pb.TagNumber(2)
  set folderType($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFolderType() => $_has(1);
  @$pb.TagNumber(2)
  void clearFolderType() => $_clearField(2);

  @$pb.TagNumber(3)
  PlayItem get play => $_getN(2);
  @$pb.TagNumber(3)
  set play(PlayItem value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPlay() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlay() => $_clearField(3);
  @$pb.TagNumber(3)
  PlayItem ensurePlay() => $_ensure(2);

  @$pb.TagNumber(4)
  FavItem get fav => $_getN(3);
  @$pb.TagNumber(4)
  set fav(FavItem value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFav() => $_has(3);
  @$pb.TagNumber(4)
  void clearFav() => $_clearField(4);
  @$pb.TagNumber(4)
  FavItem ensureFav() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get isFastDelFav => $_getBF(4);
  @$pb.TagNumber(5)
  set isFastDelFav($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsFastDelFav() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsFastDelFav() => $_clearField(5);
}

class FavItemDelResp extends $pb.GeneratedMessage {
  factory FavItemDelResp({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  FavItemDelResp._();

  factory FavItemDelResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavItemDelResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavItemDelResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItemDelResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItemDelResp copyWith(void Function(FavItemDelResp) updates) =>
      super.copyWith((message) => updates(message as FavItemDelResp))
          as FavItemDelResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavItemDelResp create() => FavItemDelResp._();
  @$core.override
  FavItemDelResp createEmptyInstance() => create();
  static $pb.PbList<FavItemDelResp> createRepeated() =>
      $pb.PbList<FavItemDelResp>();
  @$core.pragma('dart2js:noInline')
  static FavItemDelResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavItemDelResp>(create);
  static FavItemDelResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

class FavItemDetail extends $pb.GeneratedMessage {
  factory FavItemDetail({
    FavItem? item,
    FavItemAuthor? owner,
    FavItemStat? stat,
    $core.String? cover,
    $core.String? name,
    $fixnum.Int64? duration,
    $core.int? state,
    $core.String? message,
    $core.int? parts,
  }) {
    final result = create();
    if (item != null) result.item = item;
    if (owner != null) result.owner = owner;
    if (stat != null) result.stat = stat;
    if (cover != null) result.cover = cover;
    if (name != null) result.name = name;
    if (duration != null) result.duration = duration;
    if (state != null) result.state = state;
    if (message != null) result.message = message;
    if (parts != null) result.parts = parts;
    return result;
  }

  FavItemDetail._();

  factory FavItemDetail.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavItemDetail.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavItemDetail',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOM<FavItem>(1, _omitFieldNames ? '' : 'item', subBuilder: FavItem.create)
    ..aOM<FavItemAuthor>(2, _omitFieldNames ? '' : 'owner',
        subBuilder: FavItemAuthor.create)
    ..aOM<FavItemStat>(3, _omitFieldNames ? '' : 'stat',
        subBuilder: FavItemStat.create)
    ..aOS(4, _omitFieldNames ? '' : 'cover')
    ..aOS(5, _omitFieldNames ? '' : 'name')
    ..aInt64(6, _omitFieldNames ? '' : 'duration')
    ..aI(7, _omitFieldNames ? '' : 'state')
    ..aOS(8, _omitFieldNames ? '' : 'message')
    ..aI(9, _omitFieldNames ? '' : 'parts')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItemDetail clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItemDetail copyWith(void Function(FavItemDetail) updates) =>
      super.copyWith((message) => updates(message as FavItemDetail))
          as FavItemDetail;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavItemDetail create() => FavItemDetail._();
  @$core.override
  FavItemDetail createEmptyInstance() => create();
  static $pb.PbList<FavItemDetail> createRepeated() =>
      $pb.PbList<FavItemDetail>();
  @$core.pragma('dart2js:noInline')
  static FavItemDetail getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavItemDetail>(create);
  static FavItemDetail? _defaultInstance;

  @$pb.TagNumber(1)
  FavItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(FavItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  FavItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  FavItemAuthor get owner => $_getN(1);
  @$pb.TagNumber(2)
  set owner(FavItemAuthor value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOwner() => $_has(1);
  @$pb.TagNumber(2)
  void clearOwner() => $_clearField(2);
  @$pb.TagNumber(2)
  FavItemAuthor ensureOwner() => $_ensure(1);

  @$pb.TagNumber(3)
  FavItemStat get stat => $_getN(2);
  @$pb.TagNumber(3)
  set stat(FavItemStat value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStat() => $_has(2);
  @$pb.TagNumber(3)
  void clearStat() => $_clearField(3);
  @$pb.TagNumber(3)
  FavItemStat ensureStat() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get cover => $_getSZ(3);
  @$pb.TagNumber(4)
  set cover($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCover() => $_has(3);
  @$pb.TagNumber(4)
  void clearCover() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(4);
  @$pb.TagNumber(5)
  set name($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(4);
  @$pb.TagNumber(5)
  void clearName() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get duration => $_getI64(5);
  @$pb.TagNumber(6)
  set duration($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDuration() => $_has(5);
  @$pb.TagNumber(6)
  void clearDuration() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get state => $_getIZ(6);
  @$pb.TagNumber(7)
  set state($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasState() => $_has(6);
  @$pb.TagNumber(7)
  void clearState() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get message => $_getSZ(7);
  @$pb.TagNumber(8)
  set message($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMessage() => $_has(7);
  @$pb.TagNumber(8)
  void clearMessage() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get parts => $_getIZ(8);
  @$pb.TagNumber(9)
  set parts($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasParts() => $_has(8);
  @$pb.TagNumber(9)
  void clearParts() => $_clearField(9);
}

class FavItemStat extends $pb.GeneratedMessage {
  factory FavItemStat({
    $core.int? view,
    $core.int? reply,
    $core.bool? useViewVt,
    $core.String? viewVtText,
  }) {
    final result = create();
    if (view != null) result.view = view;
    if (reply != null) result.reply = reply;
    if (useViewVt != null) result.useViewVt = useViewVt;
    if (viewVtText != null) result.viewVtText = viewVtText;
    return result;
  }

  FavItemStat._();

  factory FavItemStat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavItemStat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavItemStat',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'view')
    ..aI(2, _omitFieldNames ? '' : 'reply')
    ..aOB(3, _omitFieldNames ? '' : 'useViewVt')
    ..aOS(4, _omitFieldNames ? '' : 'viewVtText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItemStat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavItemStat copyWith(void Function(FavItemStat) updates) =>
      super.copyWith((message) => updates(message as FavItemStat))
          as FavItemStat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavItemStat create() => FavItemStat._();
  @$core.override
  FavItemStat createEmptyInstance() => create();
  static $pb.PbList<FavItemStat> createRepeated() => $pb.PbList<FavItemStat>();
  @$core.pragma('dart2js:noInline')
  static FavItemStat getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavItemStat>(create);
  static FavItemStat? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get view => $_getIZ(0);
  @$pb.TagNumber(1)
  set view($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasView() => $_has(0);
  @$pb.TagNumber(1)
  void clearView() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get reply => $_getIZ(1);
  @$pb.TagNumber(2)
  set reply($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReply() => $_has(1);
  @$pb.TagNumber(2)
  void clearReply() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get useViewVt => $_getBF(2);
  @$pb.TagNumber(3)
  set useViewVt($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUseViewVt() => $_has(2);
  @$pb.TagNumber(3)
  void clearUseViewVt() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get viewVtText => $_getSZ(3);
  @$pb.TagNumber(4)
  set viewVtText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasViewVtText() => $_has(3);
  @$pb.TagNumber(4)
  void clearViewVtText() => $_clearField(4);
}

class FavTabShowReq extends $pb.GeneratedMessage {
  factory FavTabShowReq({
    $fixnum.Int64? mid,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    return result;
  }

  FavTabShowReq._();

  factory FavTabShowReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavTabShowReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavTabShowReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavTabShowReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavTabShowReq copyWith(void Function(FavTabShowReq) updates) =>
      super.copyWith((message) => updates(message as FavTabShowReq))
          as FavTabShowReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavTabShowReq create() => FavTabShowReq._();
  @$core.override
  FavTabShowReq createEmptyInstance() => create();
  static $pb.PbList<FavTabShowReq> createRepeated() =>
      $pb.PbList<FavTabShowReq>();
  @$core.pragma('dart2js:noInline')
  static FavTabShowReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavTabShowReq>(create);
  static FavTabShowReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get mid => $_getI64(0);
  @$pb.TagNumber(1)
  set mid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearMid() => $_clearField(1);
}

class FavTabShowResp extends $pb.GeneratedMessage {
  factory FavTabShowResp({
    $core.bool? showMenu,
  }) {
    final result = create();
    if (showMenu != null) result.showMenu = showMenu;
    return result;
  }

  FavTabShowResp._();

  factory FavTabShowResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavTabShowResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavTabShowResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'showMenu')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavTabShowResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavTabShowResp copyWith(void Function(FavTabShowResp) updates) =>
      super.copyWith((message) => updates(message as FavTabShowResp))
          as FavTabShowResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavTabShowResp create() => FavTabShowResp._();
  @$core.override
  FavTabShowResp createEmptyInstance() => create();
  static $pb.PbList<FavTabShowResp> createRepeated() =>
      $pb.PbList<FavTabShowResp>();
  @$core.pragma('dart2js:noInline')
  static FavTabShowResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavTabShowResp>(create);
  static FavTabShowResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get showMenu => $_getBF(0);
  @$pb.TagNumber(1)
  set showMenu($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShowMenu() => $_has(0);
  @$pb.TagNumber(1)
  void clearShowMenu() => $_clearField(1);
}

class FavoredInAnyFoldersReq extends $pb.GeneratedMessage {
  factory FavoredInAnyFoldersReq({
    $core.Iterable<$core.int>? folderTypes,
    PlayItem? item,
  }) {
    final result = create();
    if (folderTypes != null) result.folderTypes.addAll(folderTypes);
    if (item != null) result.item = item;
    return result;
  }

  FavoredInAnyFoldersReq._();

  factory FavoredInAnyFoldersReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavoredInAnyFoldersReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavoredInAnyFoldersReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..p<$core.int>(1, _omitFieldNames ? '' : 'folderTypes', $pb.PbFieldType.K3)
    ..aOM<PlayItem>(2, _omitFieldNames ? '' : 'item',
        subBuilder: PlayItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavoredInAnyFoldersReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavoredInAnyFoldersReq copyWith(
          void Function(FavoredInAnyFoldersReq) updates) =>
      super.copyWith((message) => updates(message as FavoredInAnyFoldersReq))
          as FavoredInAnyFoldersReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavoredInAnyFoldersReq create() => FavoredInAnyFoldersReq._();
  @$core.override
  FavoredInAnyFoldersReq createEmptyInstance() => create();
  static $pb.PbList<FavoredInAnyFoldersReq> createRepeated() =>
      $pb.PbList<FavoredInAnyFoldersReq>();
  @$core.pragma('dart2js:noInline')
  static FavoredInAnyFoldersReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavoredInAnyFoldersReq>(create);
  static FavoredInAnyFoldersReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.int> get folderTypes => $_getList(0);

  @$pb.TagNumber(2)
  PlayItem get item => $_getN(1);
  @$pb.TagNumber(2)
  set item(PlayItem value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasItem() => $_has(1);
  @$pb.TagNumber(2)
  void clearItem() => $_clearField(2);
  @$pb.TagNumber(2)
  PlayItem ensureItem() => $_ensure(1);
}

class FavoredInAnyFoldersResp extends $pb.GeneratedMessage {
  factory FavoredInAnyFoldersResp({
    $core.Iterable<FavFolderMeta>? folders,
    PlayItem? item,
  }) {
    final result = create();
    if (folders != null) result.folders.addAll(folders);
    if (item != null) result.item = item;
    return result;
  }

  FavoredInAnyFoldersResp._();

  factory FavoredInAnyFoldersResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavoredInAnyFoldersResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavoredInAnyFoldersResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..pPM<FavFolderMeta>(1, _omitFieldNames ? '' : 'folders',
        subBuilder: FavFolderMeta.create)
    ..aOM<PlayItem>(2, _omitFieldNames ? '' : 'item',
        subBuilder: PlayItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavoredInAnyFoldersResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavoredInAnyFoldersResp copyWith(
          void Function(FavoredInAnyFoldersResp) updates) =>
      super.copyWith((message) => updates(message as FavoredInAnyFoldersResp))
          as FavoredInAnyFoldersResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavoredInAnyFoldersResp create() => FavoredInAnyFoldersResp._();
  @$core.override
  FavoredInAnyFoldersResp createEmptyInstance() => create();
  static $pb.PbList<FavoredInAnyFoldersResp> createRepeated() =>
      $pb.PbList<FavoredInAnyFoldersResp>();
  @$core.pragma('dart2js:noInline')
  static FavoredInAnyFoldersResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavoredInAnyFoldersResp>(create);
  static FavoredInAnyFoldersResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FavFolderMeta> get folders => $_getList(0);

  @$pb.TagNumber(2)
  PlayItem get item => $_getN(1);
  @$pb.TagNumber(2)
  set item(PlayItem value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasItem() => $_has(1);
  @$pb.TagNumber(2)
  void clearItem() => $_clearField(2);
  @$pb.TagNumber(2)
  PlayItem ensureItem() => $_ensure(1);
}

class FollowRelation extends $pb.GeneratedMessage {
  factory FollowRelation({
    FollowRelation_RelationStatus? status,
  }) {
    final result = create();
    if (status != null) result.status = status;
    return result;
  }

  FollowRelation._();

  factory FollowRelation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FollowRelation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FollowRelation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aE<FollowRelation_RelationStatus>(1, _omitFieldNames ? '' : 'status',
        enumValues: FollowRelation_RelationStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowRelation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowRelation copyWith(void Function(FollowRelation) updates) =>
      super.copyWith((message) => updates(message as FollowRelation))
          as FollowRelation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FollowRelation create() => FollowRelation._();
  @$core.override
  FollowRelation createEmptyInstance() => create();
  static $pb.PbList<FollowRelation> createRepeated() =>
      $pb.PbList<FollowRelation>();
  @$core.pragma('dart2js:noInline')
  static FollowRelation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FollowRelation>(create);
  static FollowRelation? _defaultInstance;

  @$pb.TagNumber(1)
  FollowRelation_RelationStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(FollowRelation_RelationStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
}

class FormatDescription extends $pb.GeneratedMessage {
  factory FormatDescription({
    $core.int? quality,
    $core.String? format,
    $core.String? description,
    $core.String? displayDesc,
    $core.String? superscript,
  }) {
    final result = create();
    if (quality != null) result.quality = quality;
    if (format != null) result.format = format;
    if (description != null) result.description = description;
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
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'quality')
    ..aOS(2, _omitFieldNames ? '' : 'format')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOS(4, _omitFieldNames ? '' : 'displayDesc')
    ..aOS(5, _omitFieldNames ? '' : 'superscript')
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
  $core.String get displayDesc => $_getSZ(3);
  @$pb.TagNumber(4)
  set displayDesc($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDisplayDesc() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisplayDesc() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get superscript => $_getSZ(4);
  @$pb.TagNumber(5)
  set superscript($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSuperscript() => $_has(4);
  @$pb.TagNumber(5)
  void clearSuperscript() => $_clearField(5);
}

class MainFavMusicMenuListReq extends $pb.GeneratedMessage {
  factory MainFavMusicMenuListReq({
    $core.int? tabType,
    $core.String? offset,
  }) {
    final result = create();
    if (tabType != null) result.tabType = tabType;
    if (offset != null) result.offset = offset;
    return result;
  }

  MainFavMusicMenuListReq._();

  factory MainFavMusicMenuListReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MainFavMusicMenuListReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MainFavMusicMenuListReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'tabType')
    ..aOS(2, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MainFavMusicMenuListReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MainFavMusicMenuListReq copyWith(
          void Function(MainFavMusicMenuListReq) updates) =>
      super.copyWith((message) => updates(message as MainFavMusicMenuListReq))
          as MainFavMusicMenuListReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MainFavMusicMenuListReq create() => MainFavMusicMenuListReq._();
  @$core.override
  MainFavMusicMenuListReq createEmptyInstance() => create();
  static $pb.PbList<MainFavMusicMenuListReq> createRepeated() =>
      $pb.PbList<MainFavMusicMenuListReq>();
  @$core.pragma('dart2js:noInline')
  static MainFavMusicMenuListReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MainFavMusicMenuListReq>(create);
  static MainFavMusicMenuListReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get tabType => $_getIZ(0);
  @$pb.TagNumber(1)
  set tabType($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTabType() => $_has(0);
  @$pb.TagNumber(1)
  void clearTabType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get offset => $_getSZ(1);
  @$pb.TagNumber(2)
  set offset($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);
}

class MainFavMusicMenuListResp extends $pb.GeneratedMessage {
  factory MainFavMusicMenuListResp({
    $core.int? tabType,
    $core.Iterable<MusicMenu>? menuList,
    $core.bool? hasMore,
    $core.String? offset,
  }) {
    final result = create();
    if (tabType != null) result.tabType = tabType;
    if (menuList != null) result.menuList.addAll(menuList);
    if (hasMore != null) result.hasMore = hasMore;
    if (offset != null) result.offset = offset;
    return result;
  }

  MainFavMusicMenuListResp._();

  factory MainFavMusicMenuListResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MainFavMusicMenuListResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MainFavMusicMenuListResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'tabType')
    ..pPM<MusicMenu>(2, _omitFieldNames ? '' : 'menuList',
        subBuilder: MusicMenu.create)
    ..aOB(3, _omitFieldNames ? '' : 'hasMore')
    ..aOS(4, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MainFavMusicMenuListResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MainFavMusicMenuListResp copyWith(
          void Function(MainFavMusicMenuListResp) updates) =>
      super.copyWith((message) => updates(message as MainFavMusicMenuListResp))
          as MainFavMusicMenuListResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MainFavMusicMenuListResp create() => MainFavMusicMenuListResp._();
  @$core.override
  MainFavMusicMenuListResp createEmptyInstance() => create();
  static $pb.PbList<MainFavMusicMenuListResp> createRepeated() =>
      $pb.PbList<MainFavMusicMenuListResp>();
  @$core.pragma('dart2js:noInline')
  static MainFavMusicMenuListResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MainFavMusicMenuListResp>(create);
  static MainFavMusicMenuListResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get tabType => $_getIZ(0);
  @$pb.TagNumber(1)
  set tabType($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTabType() => $_has(0);
  @$pb.TagNumber(1)
  void clearTabType() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<MusicMenu> get menuList => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get hasMore => $_getBF(2);
  @$pb.TagNumber(3)
  set hasMore($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasMore() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasMore() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get offset => $_getSZ(3);
  @$pb.TagNumber(4)
  set offset($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearOffset() => $_clearField(4);
}

class MainFavMusicSubTabListReq extends $pb.GeneratedMessage {
  factory MainFavMusicSubTabListReq() => create();

  MainFavMusicSubTabListReq._();

  factory MainFavMusicSubTabListReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MainFavMusicSubTabListReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MainFavMusicSubTabListReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MainFavMusicSubTabListReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MainFavMusicSubTabListReq copyWith(
          void Function(MainFavMusicSubTabListReq) updates) =>
      super.copyWith((message) => updates(message as MainFavMusicSubTabListReq))
          as MainFavMusicSubTabListReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MainFavMusicSubTabListReq create() => MainFavMusicSubTabListReq._();
  @$core.override
  MainFavMusicSubTabListReq createEmptyInstance() => create();
  static $pb.PbList<MainFavMusicSubTabListReq> createRepeated() =>
      $pb.PbList<MainFavMusicSubTabListReq>();
  @$core.pragma('dart2js:noInline')
  static MainFavMusicSubTabListReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MainFavMusicSubTabListReq>(create);
  static MainFavMusicSubTabListReq? _defaultInstance;
}

class MainFavMusicSubTabListResp extends $pb.GeneratedMessage {
  factory MainFavMusicSubTabListResp({
    $core.Iterable<MusicSubTab>? tabs,
    MainFavMusicMenuListResp? defaultTabRes,
    $core.Iterable<$core.MapEntry<$core.int, MainFavMusicMenuListResp>>?
        firstPageRes,
  }) {
    final result = create();
    if (tabs != null) result.tabs.addAll(tabs);
    if (defaultTabRes != null) result.defaultTabRes = defaultTabRes;
    if (firstPageRes != null) result.firstPageRes.addEntries(firstPageRes);
    return result;
  }

  MainFavMusicSubTabListResp._();

  factory MainFavMusicSubTabListResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MainFavMusicSubTabListResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MainFavMusicSubTabListResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..pPM<MusicSubTab>(1, _omitFieldNames ? '' : 'tabs',
        subBuilder: MusicSubTab.create)
    ..aOM<MainFavMusicMenuListResp>(2, _omitFieldNames ? '' : 'defaultTabRes',
        subBuilder: MainFavMusicMenuListResp.create)
    ..m<$core.int, MainFavMusicMenuListResp>(
        3, _omitFieldNames ? '' : 'firstPageRes',
        entryClassName: 'MainFavMusicSubTabListResp.FirstPageResEntry',
        keyFieldType: $pb.PbFieldType.O3,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: MainFavMusicMenuListResp.create,
        valueDefaultOrMaker: MainFavMusicMenuListResp.getDefault,
        packageName: const $pb.PackageName('bilibili.app.listener.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MainFavMusicSubTabListResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MainFavMusicSubTabListResp copyWith(
          void Function(MainFavMusicSubTabListResp) updates) =>
      super.copyWith(
              (message) => updates(message as MainFavMusicSubTabListResp))
          as MainFavMusicSubTabListResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MainFavMusicSubTabListResp create() => MainFavMusicSubTabListResp._();
  @$core.override
  MainFavMusicSubTabListResp createEmptyInstance() => create();
  static $pb.PbList<MainFavMusicSubTabListResp> createRepeated() =>
      $pb.PbList<MainFavMusicSubTabListResp>();
  @$core.pragma('dart2js:noInline')
  static MainFavMusicSubTabListResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MainFavMusicSubTabListResp>(create);
  static MainFavMusicSubTabListResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MusicSubTab> get tabs => $_getList(0);

  @$pb.TagNumber(2)
  MainFavMusicMenuListResp get defaultTabRes => $_getN(1);
  @$pb.TagNumber(2)
  set defaultTabRes(MainFavMusicMenuListResp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDefaultTabRes() => $_has(1);
  @$pb.TagNumber(2)
  void clearDefaultTabRes() => $_clearField(2);
  @$pb.TagNumber(2)
  MainFavMusicMenuListResp ensureDefaultTabRes() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.int, MainFavMusicMenuListResp> get firstPageRes =>
      $_getMap(2);
}

class MedialistItem extends $pb.GeneratedMessage {
  factory MedialistItem({
    PlayItem? item,
    $core.String? title,
    $core.String? cover,
    $fixnum.Int64? duration,
    $core.int? parts,
    $fixnum.Int64? upMid,
    $core.String? upName,
    $core.int? state,
    $core.String? message,
    $fixnum.Int64? statView,
    $fixnum.Int64? statReply,
    $core.bool? useStatViewVt,
    $core.String? statViewVtText,
  }) {
    final result = create();
    if (item != null) result.item = item;
    if (title != null) result.title = title;
    if (cover != null) result.cover = cover;
    if (duration != null) result.duration = duration;
    if (parts != null) result.parts = parts;
    if (upMid != null) result.upMid = upMid;
    if (upName != null) result.upName = upName;
    if (state != null) result.state = state;
    if (message != null) result.message = message;
    if (statView != null) result.statView = statView;
    if (statReply != null) result.statReply = statReply;
    if (useStatViewVt != null) result.useStatViewVt = useStatViewVt;
    if (statViewVtText != null) result.statViewVtText = statViewVtText;
    return result;
  }

  MedialistItem._();

  factory MedialistItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MedialistItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MedialistItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOM<PlayItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PlayItem.create)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'cover')
    ..aInt64(4, _omitFieldNames ? '' : 'duration')
    ..aI(5, _omitFieldNames ? '' : 'parts')
    ..aInt64(6, _omitFieldNames ? '' : 'upMid')
    ..aOS(7, _omitFieldNames ? '' : 'upName')
    ..aI(8, _omitFieldNames ? '' : 'state')
    ..aOS(9, _omitFieldNames ? '' : 'message')
    ..aInt64(10, _omitFieldNames ? '' : 'statView')
    ..aInt64(11, _omitFieldNames ? '' : 'statReply')
    ..aOB(12, _omitFieldNames ? '' : 'useStatViewVt')
    ..aOS(13, _omitFieldNames ? '' : 'statViewVtText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MedialistItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MedialistItem copyWith(void Function(MedialistItem) updates) =>
      super.copyWith((message) => updates(message as MedialistItem))
          as MedialistItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MedialistItem create() => MedialistItem._();
  @$core.override
  MedialistItem createEmptyInstance() => create();
  static $pb.PbList<MedialistItem> createRepeated() =>
      $pb.PbList<MedialistItem>();
  @$core.pragma('dart2js:noInline')
  static MedialistItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MedialistItem>(create);
  static MedialistItem? _defaultInstance;

  @$pb.TagNumber(1)
  PlayItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PlayItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PlayItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get cover => $_getSZ(2);
  @$pb.TagNumber(3)
  set cover($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCover() => $_has(2);
  @$pb.TagNumber(3)
  void clearCover() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get duration => $_getI64(3);
  @$pb.TagNumber(4)
  set duration($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDuration() => $_has(3);
  @$pb.TagNumber(4)
  void clearDuration() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get parts => $_getIZ(4);
  @$pb.TagNumber(5)
  set parts($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasParts() => $_has(4);
  @$pb.TagNumber(5)
  void clearParts() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get upMid => $_getI64(5);
  @$pb.TagNumber(6)
  set upMid($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUpMid() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpMid() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get upName => $_getSZ(6);
  @$pb.TagNumber(7)
  set upName($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUpName() => $_has(6);
  @$pb.TagNumber(7)
  void clearUpName() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get state => $_getIZ(7);
  @$pb.TagNumber(8)
  set state($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasState() => $_has(7);
  @$pb.TagNumber(8)
  void clearState() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get message => $_getSZ(8);
  @$pb.TagNumber(9)
  set message($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMessage() => $_has(8);
  @$pb.TagNumber(9)
  void clearMessage() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get statView => $_getI64(9);
  @$pb.TagNumber(10)
  set statView($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasStatView() => $_has(9);
  @$pb.TagNumber(10)
  void clearStatView() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get statReply => $_getI64(10);
  @$pb.TagNumber(11)
  set statReply($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasStatReply() => $_has(10);
  @$pb.TagNumber(11)
  void clearStatReply() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get useStatViewVt => $_getBF(11);
  @$pb.TagNumber(12)
  set useStatViewVt($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasUseStatViewVt() => $_has(11);
  @$pb.TagNumber(12)
  void clearUseStatViewVt() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get statViewVtText => $_getSZ(12);
  @$pb.TagNumber(13)
  set statViewVtText($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasStatViewVtText() => $_has(12);
  @$pb.TagNumber(13)
  void clearStatViewVtText() => $_clearField(13);
}

class MedialistReq extends $pb.GeneratedMessage {
  factory MedialistReq({
    $fixnum.Int64? listType,
    $fixnum.Int64? bizId,
    $core.String? offset,
  }) {
    final result = create();
    if (listType != null) result.listType = listType;
    if (bizId != null) result.bizId = bizId;
    if (offset != null) result.offset = offset;
    return result;
  }

  MedialistReq._();

  factory MedialistReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MedialistReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MedialistReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'listType')
    ..aInt64(2, _omitFieldNames ? '' : 'bizId')
    ..aOS(3, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MedialistReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MedialistReq copyWith(void Function(MedialistReq) updates) =>
      super.copyWith((message) => updates(message as MedialistReq))
          as MedialistReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MedialistReq create() => MedialistReq._();
  @$core.override
  MedialistReq createEmptyInstance() => create();
  static $pb.PbList<MedialistReq> createRepeated() =>
      $pb.PbList<MedialistReq>();
  @$core.pragma('dart2js:noInline')
  static MedialistReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MedialistReq>(create);
  static MedialistReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get listType => $_getI64(0);
  @$pb.TagNumber(1)
  set listType($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasListType() => $_has(0);
  @$pb.TagNumber(1)
  void clearListType() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get bizId => $_getI64(1);
  @$pb.TagNumber(2)
  set bizId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBizId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBizId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get offset => $_getSZ(2);
  @$pb.TagNumber(3)
  set offset($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => $_clearField(3);
}

class MedialistResp extends $pb.GeneratedMessage {
  factory MedialistResp({
    $fixnum.Int64? total,
    $core.bool? hasMore,
    $core.String? offset,
    $core.Iterable<MedialistItem>? items,
    MedialistUpInfo? upInfo,
  }) {
    final result = create();
    if (total != null) result.total = total;
    if (hasMore != null) result.hasMore = hasMore;
    if (offset != null) result.offset = offset;
    if (items != null) result.items.addAll(items);
    if (upInfo != null) result.upInfo = upInfo;
    return result;
  }

  MedialistResp._();

  factory MedialistResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MedialistResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MedialistResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'total')
    ..aOB(2, _omitFieldNames ? '' : 'hasMore')
    ..aOS(3, _omitFieldNames ? '' : 'offset')
    ..pPM<MedialistItem>(4, _omitFieldNames ? '' : 'items',
        subBuilder: MedialistItem.create)
    ..aOM<MedialistUpInfo>(5, _omitFieldNames ? '' : 'upInfo',
        subBuilder: MedialistUpInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MedialistResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MedialistResp copyWith(void Function(MedialistResp) updates) =>
      super.copyWith((message) => updates(message as MedialistResp))
          as MedialistResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MedialistResp create() => MedialistResp._();
  @$core.override
  MedialistResp createEmptyInstance() => create();
  static $pb.PbList<MedialistResp> createRepeated() =>
      $pb.PbList<MedialistResp>();
  @$core.pragma('dart2js:noInline')
  static MedialistResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MedialistResp>(create);
  static MedialistResp? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get total => $_getI64(0);
  @$pb.TagNumber(1)
  set total($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get hasMore => $_getBF(1);
  @$pb.TagNumber(2)
  set hasMore($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHasMore() => $_has(1);
  @$pb.TagNumber(2)
  void clearHasMore() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get offset => $_getSZ(2);
  @$pb.TagNumber(3)
  set offset($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<MedialistItem> get items => $_getList(3);

  @$pb.TagNumber(5)
  MedialistUpInfo get upInfo => $_getN(4);
  @$pb.TagNumber(5)
  set upInfo(MedialistUpInfo value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasUpInfo() => $_has(4);
  @$pb.TagNumber(5)
  void clearUpInfo() => $_clearField(5);
  @$pb.TagNumber(5)
  MedialistUpInfo ensureUpInfo() => $_ensure(4);
}

class MedialistUpInfo extends $pb.GeneratedMessage {
  factory MedialistUpInfo({
    $fixnum.Int64? mid,
    $core.String? avatar,
    $fixnum.Int64? fans,
    $core.String? name,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    if (avatar != null) result.avatar = avatar;
    if (fans != null) result.fans = fans;
    if (name != null) result.name = name;
    return result;
  }

  MedialistUpInfo._();

  factory MedialistUpInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MedialistUpInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MedialistUpInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'avatar')
    ..aInt64(3, _omitFieldNames ? '' : 'fans')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MedialistUpInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MedialistUpInfo copyWith(void Function(MedialistUpInfo) updates) =>
      super.copyWith((message) => updates(message as MedialistUpInfo))
          as MedialistUpInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MedialistUpInfo create() => MedialistUpInfo._();
  @$core.override
  MedialistUpInfo createEmptyInstance() => create();
  static $pb.PbList<MedialistUpInfo> createRepeated() =>
      $pb.PbList<MedialistUpInfo>();
  @$core.pragma('dart2js:noInline')
  static MedialistUpInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MedialistUpInfo>(create);
  static MedialistUpInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get mid => $_getI64(0);
  @$pb.TagNumber(1)
  set mid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearMid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get avatar => $_getSZ(1);
  @$pb.TagNumber(2)
  set avatar($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAvatar() => $_has(1);
  @$pb.TagNumber(2)
  void clearAvatar() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get fans => $_getI64(2);
  @$pb.TagNumber(3)
  set fans($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFans() => $_has(2);
  @$pb.TagNumber(3)
  void clearFans() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);
}

class MenuDeleteReq extends $pb.GeneratedMessage {
  factory MenuDeleteReq({
    $fixnum.Int64? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  MenuDeleteReq._();

  factory MenuDeleteReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MenuDeleteReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MenuDeleteReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MenuDeleteReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MenuDeleteReq copyWith(void Function(MenuDeleteReq) updates) =>
      super.copyWith((message) => updates(message as MenuDeleteReq))
          as MenuDeleteReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MenuDeleteReq create() => MenuDeleteReq._();
  @$core.override
  MenuDeleteReq createEmptyInstance() => create();
  static $pb.PbList<MenuDeleteReq> createRepeated() =>
      $pb.PbList<MenuDeleteReq>();
  @$core.pragma('dart2js:noInline')
  static MenuDeleteReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MenuDeleteReq>(create);
  static MenuDeleteReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class MenuDeleteResp extends $pb.GeneratedMessage {
  factory MenuDeleteResp({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  MenuDeleteResp._();

  factory MenuDeleteResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MenuDeleteResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MenuDeleteResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MenuDeleteResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MenuDeleteResp copyWith(void Function(MenuDeleteResp) updates) =>
      super.copyWith((message) => updates(message as MenuDeleteResp))
          as MenuDeleteResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MenuDeleteResp create() => MenuDeleteResp._();
  @$core.override
  MenuDeleteResp createEmptyInstance() => create();
  static $pb.PbList<MenuDeleteResp> createRepeated() =>
      $pb.PbList<MenuDeleteResp>();
  @$core.pragma('dart2js:noInline')
  static MenuDeleteResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MenuDeleteResp>(create);
  static MenuDeleteResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

class MenuEditReq extends $pb.GeneratedMessage {
  factory MenuEditReq({
    $fixnum.Int64? id,
    $core.String? title,
    $core.String? desc,
    $core.int? isPublic,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (desc != null) result.desc = desc;
    if (isPublic != null) result.isPublic = isPublic;
    return result;
  }

  MenuEditReq._();

  factory MenuEditReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MenuEditReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MenuEditReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'desc')
    ..aI(4, _omitFieldNames ? '' : 'isPublic')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MenuEditReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MenuEditReq copyWith(void Function(MenuEditReq) updates) =>
      super.copyWith((message) => updates(message as MenuEditReq))
          as MenuEditReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MenuEditReq create() => MenuEditReq._();
  @$core.override
  MenuEditReq createEmptyInstance() => create();
  static $pb.PbList<MenuEditReq> createRepeated() => $pb.PbList<MenuEditReq>();
  @$core.pragma('dart2js:noInline')
  static MenuEditReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MenuEditReq>(create);
  static MenuEditReq? _defaultInstance;

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

  @$pb.TagNumber(3)
  $core.String get desc => $_getSZ(2);
  @$pb.TagNumber(3)
  set desc($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDesc() => $_has(2);
  @$pb.TagNumber(3)
  void clearDesc() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get isPublic => $_getIZ(3);
  @$pb.TagNumber(4)
  set isPublic($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsPublic() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsPublic() => $_clearField(4);
}

class MenuEditResp extends $pb.GeneratedMessage {
  factory MenuEditResp({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  MenuEditResp._();

  factory MenuEditResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MenuEditResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MenuEditResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MenuEditResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MenuEditResp copyWith(void Function(MenuEditResp) updates) =>
      super.copyWith((message) => updates(message as MenuEditResp))
          as MenuEditResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MenuEditResp create() => MenuEditResp._();
  @$core.override
  MenuEditResp createEmptyInstance() => create();
  static $pb.PbList<MenuEditResp> createRepeated() =>
      $pb.PbList<MenuEditResp>();
  @$core.pragma('dart2js:noInline')
  static MenuEditResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MenuEditResp>(create);
  static MenuEditResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

class MenuSubscribeReq extends $pb.GeneratedMessage {
  factory MenuSubscribeReq({
    MenuSubscribeReq_SubscribeAction? action,
    $fixnum.Int64? targetId,
  }) {
    final result = create();
    if (action != null) result.action = action;
    if (targetId != null) result.targetId = targetId;
    return result;
  }

  MenuSubscribeReq._();

  factory MenuSubscribeReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MenuSubscribeReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MenuSubscribeReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aE<MenuSubscribeReq_SubscribeAction>(1, _omitFieldNames ? '' : 'action',
        enumValues: MenuSubscribeReq_SubscribeAction.values)
    ..aInt64(2, _omitFieldNames ? '' : 'targetId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MenuSubscribeReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MenuSubscribeReq copyWith(void Function(MenuSubscribeReq) updates) =>
      super.copyWith((message) => updates(message as MenuSubscribeReq))
          as MenuSubscribeReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MenuSubscribeReq create() => MenuSubscribeReq._();
  @$core.override
  MenuSubscribeReq createEmptyInstance() => create();
  static $pb.PbList<MenuSubscribeReq> createRepeated() =>
      $pb.PbList<MenuSubscribeReq>();
  @$core.pragma('dart2js:noInline')
  static MenuSubscribeReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MenuSubscribeReq>(create);
  static MenuSubscribeReq? _defaultInstance;

  @$pb.TagNumber(1)
  MenuSubscribeReq_SubscribeAction get action => $_getN(0);
  @$pb.TagNumber(1)
  set action(MenuSubscribeReq_SubscribeAction value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAction() => $_has(0);
  @$pb.TagNumber(1)
  void clearAction() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get targetId => $_getI64(1);
  @$pb.TagNumber(2)
  set targetId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTargetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetId() => $_clearField(2);
}

class MenuSubscribeResp extends $pb.GeneratedMessage {
  factory MenuSubscribeResp({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  MenuSubscribeResp._();

  factory MenuSubscribeResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MenuSubscribeResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MenuSubscribeResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MenuSubscribeResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MenuSubscribeResp copyWith(void Function(MenuSubscribeResp) updates) =>
      super.copyWith((message) => updates(message as MenuSubscribeResp))
          as MenuSubscribeResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MenuSubscribeResp create() => MenuSubscribeResp._();
  @$core.override
  MenuSubscribeResp createEmptyInstance() => create();
  static $pb.PbList<MenuSubscribeResp> createRepeated() =>
      $pb.PbList<MenuSubscribeResp>();
  @$core.pragma('dart2js:noInline')
  static MenuSubscribeResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MenuSubscribeResp>(create);
  static MenuSubscribeResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

class MusicMenu extends $pb.GeneratedMessage {
  factory MusicMenu({
    $fixnum.Int64? id,
    $core.int? menuType,
    $core.String? title,
    $core.String? desc,
    $core.String? cover,
    MusicMenuAuthor? owner,
    $core.int? state,
    $fixnum.Int64? attr,
    MusicMenuStat? stat,
    $fixnum.Int64? total,
    $fixnum.Int64? ctime,
    $core.String? uri,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (menuType != null) result.menuType = menuType;
    if (title != null) result.title = title;
    if (desc != null) result.desc = desc;
    if (cover != null) result.cover = cover;
    if (owner != null) result.owner = owner;
    if (state != null) result.state = state;
    if (attr != null) result.attr = attr;
    if (stat != null) result.stat = stat;
    if (total != null) result.total = total;
    if (ctime != null) result.ctime = ctime;
    if (uri != null) result.uri = uri;
    return result;
  }

  MusicMenu._();

  factory MusicMenu.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MusicMenu.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MusicMenu',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aI(2, _omitFieldNames ? '' : 'menuType')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'desc')
    ..aOS(5, _omitFieldNames ? '' : 'cover')
    ..aOM<MusicMenuAuthor>(6, _omitFieldNames ? '' : 'owner',
        subBuilder: MusicMenuAuthor.create)
    ..aI(7, _omitFieldNames ? '' : 'state')
    ..aInt64(8, _omitFieldNames ? '' : 'attr')
    ..aOM<MusicMenuStat>(9, _omitFieldNames ? '' : 'stat',
        subBuilder: MusicMenuStat.create)
    ..aInt64(10, _omitFieldNames ? '' : 'total')
    ..aInt64(11, _omitFieldNames ? '' : 'ctime')
    ..aOS(12, _omitFieldNames ? '' : 'uri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MusicMenu clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MusicMenu copyWith(void Function(MusicMenu) updates) =>
      super.copyWith((message) => updates(message as MusicMenu)) as MusicMenu;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MusicMenu create() => MusicMenu._();
  @$core.override
  MusicMenu createEmptyInstance() => create();
  static $pb.PbList<MusicMenu> createRepeated() => $pb.PbList<MusicMenu>();
  @$core.pragma('dart2js:noInline')
  static MusicMenu getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MusicMenu>(create);
  static MusicMenu? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get menuType => $_getIZ(1);
  @$pb.TagNumber(2)
  set menuType($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMenuType() => $_has(1);
  @$pb.TagNumber(2)
  void clearMenuType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get desc => $_getSZ(3);
  @$pb.TagNumber(4)
  set desc($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDesc() => $_has(3);
  @$pb.TagNumber(4)
  void clearDesc() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get cover => $_getSZ(4);
  @$pb.TagNumber(5)
  set cover($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCover() => $_has(4);
  @$pb.TagNumber(5)
  void clearCover() => $_clearField(5);

  @$pb.TagNumber(6)
  MusicMenuAuthor get owner => $_getN(5);
  @$pb.TagNumber(6)
  set owner(MusicMenuAuthor value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasOwner() => $_has(5);
  @$pb.TagNumber(6)
  void clearOwner() => $_clearField(6);
  @$pb.TagNumber(6)
  MusicMenuAuthor ensureOwner() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.int get state => $_getIZ(6);
  @$pb.TagNumber(7)
  set state($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasState() => $_has(6);
  @$pb.TagNumber(7)
  void clearState() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get attr => $_getI64(7);
  @$pb.TagNumber(8)
  set attr($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAttr() => $_has(7);
  @$pb.TagNumber(8)
  void clearAttr() => $_clearField(8);

  @$pb.TagNumber(9)
  MusicMenuStat get stat => $_getN(8);
  @$pb.TagNumber(9)
  set stat(MusicMenuStat value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasStat() => $_has(8);
  @$pb.TagNumber(9)
  void clearStat() => $_clearField(9);
  @$pb.TagNumber(9)
  MusicMenuStat ensureStat() => $_ensure(8);

  @$pb.TagNumber(10)
  $fixnum.Int64 get total => $_getI64(9);
  @$pb.TagNumber(10)
  set total($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTotal() => $_has(9);
  @$pb.TagNumber(10)
  void clearTotal() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get ctime => $_getI64(10);
  @$pb.TagNumber(11)
  set ctime($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCtime() => $_has(10);
  @$pb.TagNumber(11)
  void clearCtime() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get uri => $_getSZ(11);
  @$pb.TagNumber(12)
  set uri($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasUri() => $_has(11);
  @$pb.TagNumber(12)
  void clearUri() => $_clearField(12);
}

class MusicMenuAuthor extends $pb.GeneratedMessage {
  factory MusicMenuAuthor({
    $fixnum.Int64? mid,
    $core.String? name,
    $core.String? avatar,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    if (name != null) result.name = name;
    if (avatar != null) result.avatar = avatar;
    return result;
  }

  MusicMenuAuthor._();

  factory MusicMenuAuthor.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MusicMenuAuthor.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MusicMenuAuthor',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'avatar')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MusicMenuAuthor clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MusicMenuAuthor copyWith(void Function(MusicMenuAuthor) updates) =>
      super.copyWith((message) => updates(message as MusicMenuAuthor))
          as MusicMenuAuthor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MusicMenuAuthor create() => MusicMenuAuthor._();
  @$core.override
  MusicMenuAuthor createEmptyInstance() => create();
  static $pb.PbList<MusicMenuAuthor> createRepeated() =>
      $pb.PbList<MusicMenuAuthor>();
  @$core.pragma('dart2js:noInline')
  static MusicMenuAuthor getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MusicMenuAuthor>(create);
  static MusicMenuAuthor? _defaultInstance;

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
  $core.String get avatar => $_getSZ(2);
  @$pb.TagNumber(3)
  set avatar($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAvatar() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvatar() => $_clearField(3);
}

class MusicMenuStat extends $pb.GeneratedMessage {
  factory MusicMenuStat({
    $fixnum.Int64? play,
    $fixnum.Int64? reply,
  }) {
    final result = create();
    if (play != null) result.play = play;
    if (reply != null) result.reply = reply;
    return result;
  }

  MusicMenuStat._();

  factory MusicMenuStat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MusicMenuStat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MusicMenuStat',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'play')
    ..aInt64(2, _omitFieldNames ? '' : 'reply')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MusicMenuStat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MusicMenuStat copyWith(void Function(MusicMenuStat) updates) =>
      super.copyWith((message) => updates(message as MusicMenuStat))
          as MusicMenuStat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MusicMenuStat create() => MusicMenuStat._();
  @$core.override
  MusicMenuStat createEmptyInstance() => create();
  static $pb.PbList<MusicMenuStat> createRepeated() =>
      $pb.PbList<MusicMenuStat>();
  @$core.pragma('dart2js:noInline')
  static MusicMenuStat getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MusicMenuStat>(create);
  static MusicMenuStat? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get play => $_getI64(0);
  @$pb.TagNumber(1)
  set play($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlay() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlay() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get reply => $_getI64(1);
  @$pb.TagNumber(2)
  set reply($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReply() => $_has(1);
  @$pb.TagNumber(2)
  void clearReply() => $_clearField(2);
}

class MusicSubTab extends $pb.GeneratedMessage {
  factory MusicSubTab({
    $core.String? name,
    $core.int? tabType,
    $fixnum.Int64? total,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (tabType != null) result.tabType = tabType;
    if (total != null) result.total = total;
    return result;
  }

  MusicSubTab._();

  factory MusicSubTab.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MusicSubTab.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MusicSubTab',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aI(2, _omitFieldNames ? '' : 'tabType')
    ..aInt64(3, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MusicSubTab clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MusicSubTab copyWith(void Function(MusicSubTab) updates) =>
      super.copyWith((message) => updates(message as MusicSubTab))
          as MusicSubTab;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MusicSubTab create() => MusicSubTab._();
  @$core.override
  MusicSubTab createEmptyInstance() => create();
  static $pb.PbList<MusicSubTab> createRepeated() => $pb.PbList<MusicSubTab>();
  @$core.pragma('dart2js:noInline')
  static MusicSubTab getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MusicSubTab>(create);
  static MusicSubTab? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get tabType => $_getIZ(1);
  @$pb.TagNumber(2)
  set tabType($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTabType() => $_has(1);
  @$pb.TagNumber(2)
  void clearTabType() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get total => $_getI64(2);
  @$pb.TagNumber(3)
  set total($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotal() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotal() => $_clearField(3);
}

class PageOption extends $pb.GeneratedMessage {
  factory PageOption({
    $core.int? pageSize,
    PageOption_Direction? direction,
    PlayItem? lastItem,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    if (direction != null) result.direction = direction;
    if (lastItem != null) result.lastItem = lastItem;
    return result;
  }

  PageOption._();

  factory PageOption.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PageOption.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PageOption',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..aE<PageOption_Direction>(2, _omitFieldNames ? '' : 'direction',
        enumValues: PageOption_Direction.values)
    ..aOM<PlayItem>(3, _omitFieldNames ? '' : 'lastItem',
        subBuilder: PlayItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PageOption clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PageOption copyWith(void Function(PageOption) updates) =>
      super.copyWith((message) => updates(message as PageOption)) as PageOption;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PageOption create() => PageOption._();
  @$core.override
  PageOption createEmptyInstance() => create();
  static $pb.PbList<PageOption> createRepeated() => $pb.PbList<PageOption>();
  @$core.pragma('dart2js:noInline')
  static PageOption getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PageOption>(create);
  static PageOption? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);

  @$pb.TagNumber(2)
  PageOption_Direction get direction => $_getN(1);
  @$pb.TagNumber(2)
  set direction(PageOption_Direction value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDirection() => $_has(1);
  @$pb.TagNumber(2)
  void clearDirection() => $_clearField(2);

  @$pb.TagNumber(3)
  PlayItem get lastItem => $_getN(2);
  @$pb.TagNumber(3)
  set lastItem(PlayItem value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLastItem() => $_has(2);
  @$pb.TagNumber(3)
  void clearLastItem() => $_clearField(3);
  @$pb.TagNumber(3)
  PlayItem ensureLastItem() => $_ensure(2);
}

class PickArchive extends $pb.GeneratedMessage {
  factory PickArchive({
    PlayItem? item,
    $core.String? title,
    PickArchiveAuthor? owner,
    $core.String? cover,
    $fixnum.Int64? duration,
    $core.int? parts,
    $core.int? statView,
    $core.int? statReply,
    $core.int? state,
    $core.String? message,
    $core.bool? useStatViewVt,
    $core.String? statViewVtText,
  }) {
    final result = create();
    if (item != null) result.item = item;
    if (title != null) result.title = title;
    if (owner != null) result.owner = owner;
    if (cover != null) result.cover = cover;
    if (duration != null) result.duration = duration;
    if (parts != null) result.parts = parts;
    if (statView != null) result.statView = statView;
    if (statReply != null) result.statReply = statReply;
    if (state != null) result.state = state;
    if (message != null) result.message = message;
    if (useStatViewVt != null) result.useStatViewVt = useStatViewVt;
    if (statViewVtText != null) result.statViewVtText = statViewVtText;
    return result;
  }

  PickArchive._();

  factory PickArchive.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PickArchive.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PickArchive',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOM<PlayItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PlayItem.create)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOM<PickArchiveAuthor>(3, _omitFieldNames ? '' : 'owner',
        subBuilder: PickArchiveAuthor.create)
    ..aOS(4, _omitFieldNames ? '' : 'cover')
    ..aInt64(5, _omitFieldNames ? '' : 'duration')
    ..aI(6, _omitFieldNames ? '' : 'parts')
    ..aI(7, _omitFieldNames ? '' : 'statView')
    ..aI(8, _omitFieldNames ? '' : 'statReply')
    ..aI(9, _omitFieldNames ? '' : 'state')
    ..aOS(10, _omitFieldNames ? '' : 'message')
    ..aOB(11, _omitFieldNames ? '' : 'useStatViewVt')
    ..aOS(12, _omitFieldNames ? '' : 'statViewVtText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PickArchive clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PickArchive copyWith(void Function(PickArchive) updates) =>
      super.copyWith((message) => updates(message as PickArchive))
          as PickArchive;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PickArchive create() => PickArchive._();
  @$core.override
  PickArchive createEmptyInstance() => create();
  static $pb.PbList<PickArchive> createRepeated() => $pb.PbList<PickArchive>();
  @$core.pragma('dart2js:noInline')
  static PickArchive getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PickArchive>(create);
  static PickArchive? _defaultInstance;

  @$pb.TagNumber(1)
  PlayItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PlayItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PlayItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  PickArchiveAuthor get owner => $_getN(2);
  @$pb.TagNumber(3)
  set owner(PickArchiveAuthor value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOwner() => $_has(2);
  @$pb.TagNumber(3)
  void clearOwner() => $_clearField(3);
  @$pb.TagNumber(3)
  PickArchiveAuthor ensureOwner() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get cover => $_getSZ(3);
  @$pb.TagNumber(4)
  set cover($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCover() => $_has(3);
  @$pb.TagNumber(4)
  void clearCover() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get duration => $_getI64(4);
  @$pb.TagNumber(5)
  set duration($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDuration() => $_has(4);
  @$pb.TagNumber(5)
  void clearDuration() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get parts => $_getIZ(5);
  @$pb.TagNumber(6)
  set parts($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasParts() => $_has(5);
  @$pb.TagNumber(6)
  void clearParts() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get statView => $_getIZ(6);
  @$pb.TagNumber(7)
  set statView($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStatView() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatView() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get statReply => $_getIZ(7);
  @$pb.TagNumber(8)
  set statReply($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasStatReply() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatReply() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get state => $_getIZ(8);
  @$pb.TagNumber(9)
  set state($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasState() => $_has(8);
  @$pb.TagNumber(9)
  void clearState() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get message => $_getSZ(9);
  @$pb.TagNumber(10)
  set message($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMessage() => $_has(9);
  @$pb.TagNumber(10)
  void clearMessage() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get useStatViewVt => $_getBF(10);
  @$pb.TagNumber(11)
  set useStatViewVt($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasUseStatViewVt() => $_has(10);
  @$pb.TagNumber(11)
  void clearUseStatViewVt() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get statViewVtText => $_getSZ(11);
  @$pb.TagNumber(12)
  set statViewVtText($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasStatViewVtText() => $_has(11);
  @$pb.TagNumber(12)
  void clearStatViewVtText() => $_clearField(12);
}

class PickArchiveAuthor extends $pb.GeneratedMessage {
  factory PickArchiveAuthor({
    $fixnum.Int64? mid,
    $core.String? name,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    if (name != null) result.name = name;
    return result;
  }

  PickArchiveAuthor._();

  factory PickArchiveAuthor.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PickArchiveAuthor.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PickArchiveAuthor',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PickArchiveAuthor clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PickArchiveAuthor copyWith(void Function(PickArchiveAuthor) updates) =>
      super.copyWith((message) => updates(message as PickArchiveAuthor))
          as PickArchiveAuthor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PickArchiveAuthor create() => PickArchiveAuthor._();
  @$core.override
  PickArchiveAuthor createEmptyInstance() => create();
  static $pb.PbList<PickArchiveAuthor> createRepeated() =>
      $pb.PbList<PickArchiveAuthor>();
  @$core.pragma('dart2js:noInline')
  static PickArchiveAuthor getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PickArchiveAuthor>(create);
  static PickArchiveAuthor? _defaultInstance;

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
}

class PickCard extends $pb.GeneratedMessage {
  factory PickCard({
    $fixnum.Int64? pickId,
    $fixnum.Int64? cardId,
    $core.String? cardName,
    $core.Iterable<CardModule>? modules,
  }) {
    final result = create();
    if (pickId != null) result.pickId = pickId;
    if (cardId != null) result.cardId = cardId;
    if (cardName != null) result.cardName = cardName;
    if (modules != null) result.modules.addAll(modules);
    return result;
  }

  PickCard._();

  factory PickCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PickCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PickCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'pickId')
    ..aInt64(2, _omitFieldNames ? '' : 'cardId')
    ..aOS(3, _omitFieldNames ? '' : 'cardName')
    ..pPM<CardModule>(4, _omitFieldNames ? '' : 'modules',
        subBuilder: CardModule.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PickCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PickCard copyWith(void Function(PickCard) updates) =>
      super.copyWith((message) => updates(message as PickCard)) as PickCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PickCard create() => PickCard._();
  @$core.override
  PickCard createEmptyInstance() => create();
  static $pb.PbList<PickCard> createRepeated() => $pb.PbList<PickCard>();
  @$core.pragma('dart2js:noInline')
  static PickCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PickCard>(create);
  static PickCard? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get pickId => $_getI64(0);
  @$pb.TagNumber(1)
  set pickId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPickId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPickId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get cardId => $_getI64(1);
  @$pb.TagNumber(2)
  set cardId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCardId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCardId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get cardName => $_getSZ(2);
  @$pb.TagNumber(3)
  set cardName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCardName() => $_has(2);
  @$pb.TagNumber(3)
  void clearCardName() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<CardModule> get modules => $_getList(3);
}

class PickCardDetailReq extends $pb.GeneratedMessage {
  factory PickCardDetailReq({
    $fixnum.Int64? cardId,
    $fixnum.Int64? pickId,
  }) {
    final result = create();
    if (cardId != null) result.cardId = cardId;
    if (pickId != null) result.pickId = pickId;
    return result;
  }

  PickCardDetailReq._();

  factory PickCardDetailReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PickCardDetailReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PickCardDetailReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'cardId')
    ..aInt64(2, _omitFieldNames ? '' : 'pickId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PickCardDetailReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PickCardDetailReq copyWith(void Function(PickCardDetailReq) updates) =>
      super.copyWith((message) => updates(message as PickCardDetailReq))
          as PickCardDetailReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PickCardDetailReq create() => PickCardDetailReq._();
  @$core.override
  PickCardDetailReq createEmptyInstance() => create();
  static $pb.PbList<PickCardDetailReq> createRepeated() =>
      $pb.PbList<PickCardDetailReq>();
  @$core.pragma('dart2js:noInline')
  static PickCardDetailReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PickCardDetailReq>(create);
  static PickCardDetailReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get cardId => $_getI64(0);
  @$pb.TagNumber(1)
  set cardId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCardId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCardId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get pickId => $_getI64(1);
  @$pb.TagNumber(2)
  set pickId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPickId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPickId() => $_clearField(2);
}

class PickCardDetailResp extends $pb.GeneratedMessage {
  factory PickCardDetailResp({
    $fixnum.Int64? cardId,
    $fixnum.Int64? pickId,
    $core.Iterable<CardModule>? modules,
  }) {
    final result = create();
    if (cardId != null) result.cardId = cardId;
    if (pickId != null) result.pickId = pickId;
    if (modules != null) result.modules.addAll(modules);
    return result;
  }

  PickCardDetailResp._();

  factory PickCardDetailResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PickCardDetailResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PickCardDetailResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'cardId')
    ..aInt64(2, _omitFieldNames ? '' : 'pickId')
    ..pPM<CardModule>(3, _omitFieldNames ? '' : 'modules',
        subBuilder: CardModule.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PickCardDetailResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PickCardDetailResp copyWith(void Function(PickCardDetailResp) updates) =>
      super.copyWith((message) => updates(message as PickCardDetailResp))
          as PickCardDetailResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PickCardDetailResp create() => PickCardDetailResp._();
  @$core.override
  PickCardDetailResp createEmptyInstance() => create();
  static $pb.PbList<PickCardDetailResp> createRepeated() =>
      $pb.PbList<PickCardDetailResp>();
  @$core.pragma('dart2js:noInline')
  static PickCardDetailResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PickCardDetailResp>(create);
  static PickCardDetailResp? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get cardId => $_getI64(0);
  @$pb.TagNumber(1)
  set cardId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCardId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCardId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get pickId => $_getI64(1);
  @$pb.TagNumber(2)
  set pickId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPickId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPickId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<CardModule> get modules => $_getList(2);
}

class PickFeedReq extends $pb.GeneratedMessage {
  factory PickFeedReq({
    $fixnum.Int64? offset,
  }) {
    final result = create();
    if (offset != null) result.offset = offset;
    return result;
  }

  PickFeedReq._();

  factory PickFeedReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PickFeedReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PickFeedReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PickFeedReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PickFeedReq copyWith(void Function(PickFeedReq) updates) =>
      super.copyWith((message) => updates(message as PickFeedReq))
          as PickFeedReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PickFeedReq create() => PickFeedReq._();
  @$core.override
  PickFeedReq createEmptyInstance() => create();
  static $pb.PbList<PickFeedReq> createRepeated() => $pb.PbList<PickFeedReq>();
  @$core.pragma('dart2js:noInline')
  static PickFeedReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PickFeedReq>(create);
  static PickFeedReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get offset => $_getI64(0);
  @$pb.TagNumber(1)
  set offset($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOffset() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffset() => $_clearField(1);
}

class PickFeedResp extends $pb.GeneratedMessage {
  factory PickFeedResp({
    $fixnum.Int64? offset,
    $core.Iterable<PickCard>? cards,
  }) {
    final result = create();
    if (offset != null) result.offset = offset;
    if (cards != null) result.cards.addAll(cards);
    return result;
  }

  PickFeedResp._();

  factory PickFeedResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PickFeedResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PickFeedResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'offset')
    ..pPM<PickCard>(2, _omitFieldNames ? '' : 'cards',
        subBuilder: PickCard.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PickFeedResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PickFeedResp copyWith(void Function(PickFeedResp) updates) =>
      super.copyWith((message) => updates(message as PickFeedResp))
          as PickFeedResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PickFeedResp create() => PickFeedResp._();
  @$core.override
  PickFeedResp createEmptyInstance() => create();
  static $pb.PbList<PickFeedResp> createRepeated() =>
      $pb.PbList<PickFeedResp>();
  @$core.pragma('dart2js:noInline')
  static PickFeedResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PickFeedResp>(create);
  static PickFeedResp? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get offset => $_getI64(0);
  @$pb.TagNumber(1)
  set offset($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOffset() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffset() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<PickCard> get cards => $_getList(1);
}

class PkcmArchive extends $pb.GeneratedMessage {
  factory PkcmArchive({
    PickArchive? arc,
    $core.String? pickReason,
  }) {
    final result = create();
    if (arc != null) result.arc = arc;
    if (pickReason != null) result.pickReason = pickReason;
    return result;
  }

  PkcmArchive._();

  factory PkcmArchive.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PkcmArchive.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PkcmArchive',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOM<PickArchive>(1, _omitFieldNames ? '' : 'arc',
        subBuilder: PickArchive.create)
    ..aOS(2, _omitFieldNames ? '' : 'pickReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PkcmArchive clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PkcmArchive copyWith(void Function(PkcmArchive) updates) =>
      super.copyWith((message) => updates(message as PkcmArchive))
          as PkcmArchive;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PkcmArchive create() => PkcmArchive._();
  @$core.override
  PkcmArchive createEmptyInstance() => create();
  static $pb.PbList<PkcmArchive> createRepeated() => $pb.PbList<PkcmArchive>();
  @$core.pragma('dart2js:noInline')
  static PkcmArchive getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PkcmArchive>(create);
  static PkcmArchive? _defaultInstance;

  @$pb.TagNumber(1)
  PickArchive get arc => $_getN(0);
  @$pb.TagNumber(1)
  set arc(PickArchive value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArc() => $_has(0);
  @$pb.TagNumber(1)
  void clearArc() => $_clearField(1);
  @$pb.TagNumber(1)
  PickArchive ensureArc() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get pickReason => $_getSZ(1);
  @$pb.TagNumber(2)
  set pickReason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPickReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearPickReason() => $_clearField(2);
}

class PkcmCenterButton extends $pb.GeneratedMessage {
  factory PkcmCenterButton({
    $core.String? iconHead,
    $core.String? iconTail,
    $core.String? title,
    $core.String? uri,
  }) {
    final result = create();
    if (iconHead != null) result.iconHead = iconHead;
    if (iconTail != null) result.iconTail = iconTail;
    if (title != null) result.title = title;
    if (uri != null) result.uri = uri;
    return result;
  }

  PkcmCenterButton._();

  factory PkcmCenterButton.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PkcmCenterButton.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PkcmCenterButton',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'iconHead')
    ..aOS(2, _omitFieldNames ? '' : 'iconTail')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'uri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PkcmCenterButton clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PkcmCenterButton copyWith(void Function(PkcmCenterButton) updates) =>
      super.copyWith((message) => updates(message as PkcmCenterButton))
          as PkcmCenterButton;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PkcmCenterButton create() => PkcmCenterButton._();
  @$core.override
  PkcmCenterButton createEmptyInstance() => create();
  static $pb.PbList<PkcmCenterButton> createRepeated() =>
      $pb.PbList<PkcmCenterButton>();
  @$core.pragma('dart2js:noInline')
  static PkcmCenterButton getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PkcmCenterButton>(create);
  static PkcmCenterButton? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get iconHead => $_getSZ(0);
  @$pb.TagNumber(1)
  set iconHead($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIconHead() => $_has(0);
  @$pb.TagNumber(1)
  void clearIconHead() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get iconTail => $_getSZ(1);
  @$pb.TagNumber(2)
  set iconTail($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIconTail() => $_has(1);
  @$pb.TagNumber(2)
  void clearIconTail() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get uri => $_getSZ(3);
  @$pb.TagNumber(4)
  set uri($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUri() => $_has(3);
  @$pb.TagNumber(4)
  void clearUri() => $_clearField(4);
}

class PkcmHeader extends $pb.GeneratedMessage {
  factory PkcmHeader({
    $core.String? title,
    $core.String? desc,
    $core.String? btnIcon,
    $core.String? btnText,
    $core.String? btnUri,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (desc != null) result.desc = desc;
    if (btnIcon != null) result.btnIcon = btnIcon;
    if (btnText != null) result.btnText = btnText;
    if (btnUri != null) result.btnUri = btnUri;
    return result;
  }

  PkcmHeader._();

  factory PkcmHeader.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PkcmHeader.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PkcmHeader',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'desc')
    ..aOS(3, _omitFieldNames ? '' : 'btnIcon')
    ..aOS(4, _omitFieldNames ? '' : 'btnText')
    ..aOS(5, _omitFieldNames ? '' : 'btnUri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PkcmHeader clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PkcmHeader copyWith(void Function(PkcmHeader) updates) =>
      super.copyWith((message) => updates(message as PkcmHeader)) as PkcmHeader;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PkcmHeader create() => PkcmHeader._();
  @$core.override
  PkcmHeader createEmptyInstance() => create();
  static $pb.PbList<PkcmHeader> createRepeated() => $pb.PbList<PkcmHeader>();
  @$core.pragma('dart2js:noInline')
  static PkcmHeader getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PkcmHeader>(create);
  static PkcmHeader? _defaultInstance;

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

  @$pb.TagNumber(3)
  $core.String get btnIcon => $_getSZ(2);
  @$pb.TagNumber(3)
  set btnIcon($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBtnIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearBtnIcon() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get btnText => $_getSZ(3);
  @$pb.TagNumber(4)
  set btnText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBtnText() => $_has(3);
  @$pb.TagNumber(4)
  void clearBtnText() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get btnUri => $_getSZ(4);
  @$pb.TagNumber(5)
  set btnUri($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBtnUri() => $_has(4);
  @$pb.TagNumber(5)
  void clearBtnUri() => $_clearField(5);
}

class PlayActionReportReq extends $pb.GeneratedMessage {
  factory PlayActionReportReq({
    PlayItem? item,
    $core.String? fromSpmid,
  }) {
    final result = create();
    if (item != null) result.item = item;
    if (fromSpmid != null) result.fromSpmid = fromSpmid;
    return result;
  }

  PlayActionReportReq._();

  factory PlayActionReportReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayActionReportReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayActionReportReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOM<PlayItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PlayItem.create)
    ..aOS(2, _omitFieldNames ? '' : 'fromSpmid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayActionReportReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayActionReportReq copyWith(void Function(PlayActionReportReq) updates) =>
      super.copyWith((message) => updates(message as PlayActionReportReq))
          as PlayActionReportReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayActionReportReq create() => PlayActionReportReq._();
  @$core.override
  PlayActionReportReq createEmptyInstance() => create();
  static $pb.PbList<PlayActionReportReq> createRepeated() =>
      $pb.PbList<PlayActionReportReq>();
  @$core.pragma('dart2js:noInline')
  static PlayActionReportReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayActionReportReq>(create);
  static PlayActionReportReq? _defaultInstance;

  @$pb.TagNumber(1)
  PlayItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PlayItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PlayItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get fromSpmid => $_getSZ(1);
  @$pb.TagNumber(2)
  set fromSpmid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFromSpmid() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromSpmid() => $_clearField(2);
}

class PlayDASH extends $pb.GeneratedMessage {
  factory PlayDASH({
    $core.int? duration,
    $core.double? minBufferTime,
    $core.Iterable<DashItem>? audio,
  }) {
    final result = create();
    if (duration != null) result.duration = duration;
    if (minBufferTime != null) result.minBufferTime = minBufferTime;
    if (audio != null) result.audio.addAll(audio);
    return result;
  }

  PlayDASH._();

  factory PlayDASH.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayDASH.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayDASH',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'duration')
    ..aD(2, _omitFieldNames ? '' : 'minBufferTime',
        fieldType: $pb.PbFieldType.OF)
    ..pPM<DashItem>(3, _omitFieldNames ? '' : 'audio',
        subBuilder: DashItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayDASH clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayDASH copyWith(void Function(PlayDASH) updates) =>
      super.copyWith((message) => updates(message as PlayDASH)) as PlayDASH;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayDASH create() => PlayDASH._();
  @$core.override
  PlayDASH createEmptyInstance() => create();
  static $pb.PbList<PlayDASH> createRepeated() => $pb.PbList<PlayDASH>();
  @$core.pragma('dart2js:noInline')
  static PlayDASH getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayDASH>(create);
  static PlayDASH? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get duration => $_getIZ(0);
  @$pb.TagNumber(1)
  set duration($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDuration() => $_has(0);
  @$pb.TagNumber(1)
  void clearDuration() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get minBufferTime => $_getN(1);
  @$pb.TagNumber(2)
  set minBufferTime($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMinBufferTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinBufferTime() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<DashItem> get audio => $_getList(2);
}

class PlayHistoryAddReq extends $pb.GeneratedMessage {
  factory PlayHistoryAddReq({
    PlayItem? item,
    $fixnum.Int64? progress,
    $fixnum.Int64? duration,
    $core.int? playStyle,
  }) {
    final result = create();
    if (item != null) result.item = item;
    if (progress != null) result.progress = progress;
    if (duration != null) result.duration = duration;
    if (playStyle != null) result.playStyle = playStyle;
    return result;
  }

  PlayHistoryAddReq._();

  factory PlayHistoryAddReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayHistoryAddReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayHistoryAddReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOM<PlayItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PlayItem.create)
    ..aInt64(2, _omitFieldNames ? '' : 'progress')
    ..aInt64(3, _omitFieldNames ? '' : 'duration')
    ..aI(4, _omitFieldNames ? '' : 'playStyle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayHistoryAddReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayHistoryAddReq copyWith(void Function(PlayHistoryAddReq) updates) =>
      super.copyWith((message) => updates(message as PlayHistoryAddReq))
          as PlayHistoryAddReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayHistoryAddReq create() => PlayHistoryAddReq._();
  @$core.override
  PlayHistoryAddReq createEmptyInstance() => create();
  static $pb.PbList<PlayHistoryAddReq> createRepeated() =>
      $pb.PbList<PlayHistoryAddReq>();
  @$core.pragma('dart2js:noInline')
  static PlayHistoryAddReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayHistoryAddReq>(create);
  static PlayHistoryAddReq? _defaultInstance;

  @$pb.TagNumber(1)
  PlayItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PlayItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PlayItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get progress => $_getI64(1);
  @$pb.TagNumber(2)
  set progress($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProgress() => $_has(1);
  @$pb.TagNumber(2)
  void clearProgress() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get duration => $_getI64(2);
  @$pb.TagNumber(3)
  set duration($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDuration() => $_has(2);
  @$pb.TagNumber(3)
  void clearDuration() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get playStyle => $_getIZ(3);
  @$pb.TagNumber(4)
  set playStyle($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPlayStyle() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlayStyle() => $_clearField(4);
}

class PlayHistoryDelReq extends $pb.GeneratedMessage {
  factory PlayHistoryDelReq({
    $core.Iterable<PlayItem>? items,
    $core.bool? truncate,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (truncate != null) result.truncate = truncate;
    return result;
  }

  PlayHistoryDelReq._();

  factory PlayHistoryDelReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayHistoryDelReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayHistoryDelReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..pPM<PlayItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: PlayItem.create)
    ..aOB(2, _omitFieldNames ? '' : 'truncate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayHistoryDelReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayHistoryDelReq copyWith(void Function(PlayHistoryDelReq) updates) =>
      super.copyWith((message) => updates(message as PlayHistoryDelReq))
          as PlayHistoryDelReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayHistoryDelReq create() => PlayHistoryDelReq._();
  @$core.override
  PlayHistoryDelReq createEmptyInstance() => create();
  static $pb.PbList<PlayHistoryDelReq> createRepeated() =>
      $pb.PbList<PlayHistoryDelReq>();
  @$core.pragma('dart2js:noInline')
  static PlayHistoryDelReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayHistoryDelReq>(create);
  static PlayHistoryDelReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PlayItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get truncate => $_getBF(1);
  @$pb.TagNumber(2)
  set truncate($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTruncate() => $_has(1);
  @$pb.TagNumber(2)
  void clearTruncate() => $_clearField(2);
}

class PlayHistoryReq extends $pb.GeneratedMessage {
  factory PlayHistoryReq({
    PageOption? pageOpt,
    $fixnum.Int64? localTodayZero,
    $4.Pagination? pagination,
  }) {
    final result = create();
    if (pageOpt != null) result.pageOpt = pageOpt;
    if (localTodayZero != null) result.localTodayZero = localTodayZero;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  PlayHistoryReq._();

  factory PlayHistoryReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayHistoryReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayHistoryReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOM<PageOption>(1, _omitFieldNames ? '' : 'pageOpt',
        subBuilder: PageOption.create)
    ..aInt64(2, _omitFieldNames ? '' : 'localTodayZero')
    ..aOM<$4.Pagination>(3, _omitFieldNames ? '' : 'pagination',
        subBuilder: $4.Pagination.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayHistoryReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayHistoryReq copyWith(void Function(PlayHistoryReq) updates) =>
      super.copyWith((message) => updates(message as PlayHistoryReq))
          as PlayHistoryReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayHistoryReq create() => PlayHistoryReq._();
  @$core.override
  PlayHistoryReq createEmptyInstance() => create();
  static $pb.PbList<PlayHistoryReq> createRepeated() =>
      $pb.PbList<PlayHistoryReq>();
  @$core.pragma('dart2js:noInline')
  static PlayHistoryReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayHistoryReq>(create);
  static PlayHistoryReq? _defaultInstance;

  @$pb.TagNumber(1)
  PageOption get pageOpt => $_getN(0);
  @$pb.TagNumber(1)
  set pageOpt(PageOption value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPageOpt() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageOpt() => $_clearField(1);
  @$pb.TagNumber(1)
  PageOption ensurePageOpt() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get localTodayZero => $_getI64(1);
  @$pb.TagNumber(2)
  set localTodayZero($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocalTodayZero() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocalTodayZero() => $_clearField(2);

  @$pb.TagNumber(3)
  $4.Pagination get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($4.Pagination value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => $_clearField(3);
  @$pb.TagNumber(3)
  $4.Pagination ensurePagination() => $_ensure(2);
}

class PlayHistoryResp extends $pb.GeneratedMessage {
  factory PlayHistoryResp({
    $core.int? total,
    $core.bool? reachEnd,
    $core.Iterable<DetailItem>? list,
    $4.PaginationReply? paginationReply,
  }) {
    final result = create();
    if (total != null) result.total = total;
    if (reachEnd != null) result.reachEnd = reachEnd;
    if (list != null) result.list.addAll(list);
    if (paginationReply != null) result.paginationReply = paginationReply;
    return result;
  }

  PlayHistoryResp._();

  factory PlayHistoryResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayHistoryResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayHistoryResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'total')
    ..aOB(2, _omitFieldNames ? '' : 'reachEnd')
    ..pPM<DetailItem>(3, _omitFieldNames ? '' : 'list',
        subBuilder: DetailItem.create)
    ..aOM<$4.PaginationReply>(4, _omitFieldNames ? '' : 'paginationReply',
        subBuilder: $4.PaginationReply.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayHistoryResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayHistoryResp copyWith(void Function(PlayHistoryResp) updates) =>
      super.copyWith((message) => updates(message as PlayHistoryResp))
          as PlayHistoryResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayHistoryResp create() => PlayHistoryResp._();
  @$core.override
  PlayHistoryResp createEmptyInstance() => create();
  static $pb.PbList<PlayHistoryResp> createRepeated() =>
      $pb.PbList<PlayHistoryResp>();
  @$core.pragma('dart2js:noInline')
  static PlayHistoryResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayHistoryResp>(create);
  static PlayHistoryResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get total => $_getIZ(0);
  @$pb.TagNumber(1)
  set total($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get reachEnd => $_getBF(1);
  @$pb.TagNumber(2)
  set reachEnd($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReachEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearReachEnd() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<DetailItem> get list => $_getList(2);

  @$pb.TagNumber(4)
  $4.PaginationReply get paginationReply => $_getN(3);
  @$pb.TagNumber(4)
  set paginationReply($4.PaginationReply value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPaginationReply() => $_has(3);
  @$pb.TagNumber(4)
  void clearPaginationReply() => $_clearField(4);
  @$pb.TagNumber(4)
  $4.PaginationReply ensurePaginationReply() => $_ensure(3);
}

enum PlayInfo_Info { playUrl, playDash, notSet }

class PlayInfo extends $pb.GeneratedMessage {
  factory PlayInfo({
    $core.int? qn,
    $core.String? format,
    $core.int? qnType,
    PlayURL? playUrl,
    PlayDASH? playDash,
    $core.int? fnver,
    $core.int? fnval,
    $core.Iterable<FormatDescription>? formats,
    $core.int? videoCodecid,
    $fixnum.Int64? length,
    $core.int? code,
    $core.String? message,
    $fixnum.Int64? expireTime,
    $5.VolumeInfo? volume,
  }) {
    final result = create();
    if (qn != null) result.qn = qn;
    if (format != null) result.format = format;
    if (qnType != null) result.qnType = qnType;
    if (playUrl != null) result.playUrl = playUrl;
    if (playDash != null) result.playDash = playDash;
    if (fnver != null) result.fnver = fnver;
    if (fnval != null) result.fnval = fnval;
    if (formats != null) result.formats.addAll(formats);
    if (videoCodecid != null) result.videoCodecid = videoCodecid;
    if (length != null) result.length = length;
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    if (expireTime != null) result.expireTime = expireTime;
    if (volume != null) result.volume = volume;
    return result;
  }

  PlayInfo._();

  factory PlayInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, PlayInfo_Info> _PlayInfo_InfoByTag = {
    4: PlayInfo_Info.playUrl,
    5: PlayInfo_Info.playDash,
    0: PlayInfo_Info.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..oo(0, [4, 5])
    ..aI(1, _omitFieldNames ? '' : 'qn')
    ..aOS(2, _omitFieldNames ? '' : 'format')
    ..aI(3, _omitFieldNames ? '' : 'qnType')
    ..aOM<PlayURL>(4, _omitFieldNames ? '' : 'playUrl',
        subBuilder: PlayURL.create)
    ..aOM<PlayDASH>(5, _omitFieldNames ? '' : 'playDash',
        subBuilder: PlayDASH.create)
    ..aI(6, _omitFieldNames ? '' : 'fnver')
    ..aI(7, _omitFieldNames ? '' : 'fnval')
    ..pPM<FormatDescription>(8, _omitFieldNames ? '' : 'formats',
        subBuilder: FormatDescription.create)
    ..aI(9, _omitFieldNames ? '' : 'videoCodecid')
    ..aInt64(10, _omitFieldNames ? '' : 'length')
    ..aI(11, _omitFieldNames ? '' : 'code')
    ..aOS(12, _omitFieldNames ? '' : 'message')
    ..aInt64(13, _omitFieldNames ? '' : 'expireTime')
    ..aOM<$5.VolumeInfo>(14, _omitFieldNames ? '' : 'volume',
        subBuilder: $5.VolumeInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayInfo copyWith(void Function(PlayInfo) updates) =>
      super.copyWith((message) => updates(message as PlayInfo)) as PlayInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayInfo create() => PlayInfo._();
  @$core.override
  PlayInfo createEmptyInstance() => create();
  static $pb.PbList<PlayInfo> createRepeated() => $pb.PbList<PlayInfo>();
  @$core.pragma('dart2js:noInline')
  static PlayInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayInfo>(create);
  static PlayInfo? _defaultInstance;

  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  PlayInfo_Info whichInfo() => _PlayInfo_InfoByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearInfo() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.int get qn => $_getIZ(0);
  @$pb.TagNumber(1)
  set qn($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQn() => $_has(0);
  @$pb.TagNumber(1)
  void clearQn() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get format => $_getSZ(1);
  @$pb.TagNumber(2)
  set format($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFormat() => $_has(1);
  @$pb.TagNumber(2)
  void clearFormat() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get qnType => $_getIZ(2);
  @$pb.TagNumber(3)
  set qnType($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQnType() => $_has(2);
  @$pb.TagNumber(3)
  void clearQnType() => $_clearField(3);

  @$pb.TagNumber(4)
  PlayURL get playUrl => $_getN(3);
  @$pb.TagNumber(4)
  set playUrl(PlayURL value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPlayUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlayUrl() => $_clearField(4);
  @$pb.TagNumber(4)
  PlayURL ensurePlayUrl() => $_ensure(3);

  @$pb.TagNumber(5)
  PlayDASH get playDash => $_getN(4);
  @$pb.TagNumber(5)
  set playDash(PlayDASH value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPlayDash() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlayDash() => $_clearField(5);
  @$pb.TagNumber(5)
  PlayDASH ensurePlayDash() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.int get fnver => $_getIZ(5);
  @$pb.TagNumber(6)
  set fnver($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFnver() => $_has(5);
  @$pb.TagNumber(6)
  void clearFnver() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get fnval => $_getIZ(6);
  @$pb.TagNumber(7)
  set fnval($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFnval() => $_has(6);
  @$pb.TagNumber(7)
  void clearFnval() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<FormatDescription> get formats => $_getList(7);

  @$pb.TagNumber(9)
  $core.int get videoCodecid => $_getIZ(8);
  @$pb.TagNumber(9)
  set videoCodecid($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasVideoCodecid() => $_has(8);
  @$pb.TagNumber(9)
  void clearVideoCodecid() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get length => $_getI64(9);
  @$pb.TagNumber(10)
  set length($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasLength() => $_has(9);
  @$pb.TagNumber(10)
  void clearLength() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get code => $_getIZ(10);
  @$pb.TagNumber(11)
  set code($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCode() => $_has(10);
  @$pb.TagNumber(11)
  void clearCode() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get message => $_getSZ(11);
  @$pb.TagNumber(12)
  set message($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasMessage() => $_has(11);
  @$pb.TagNumber(12)
  void clearMessage() => $_clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get expireTime => $_getI64(12);
  @$pb.TagNumber(13)
  set expireTime($fixnum.Int64 value) => $_setInt64(12, value);
  @$pb.TagNumber(13)
  $core.bool hasExpireTime() => $_has(12);
  @$pb.TagNumber(13)
  void clearExpireTime() => $_clearField(13);

  @$pb.TagNumber(14)
  $5.VolumeInfo get volume => $_getN(13);
  @$pb.TagNumber(14)
  set volume($5.VolumeInfo value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasVolume() => $_has(13);
  @$pb.TagNumber(14)
  void clearVolume() => $_clearField(14);
  @$pb.TagNumber(14)
  $5.VolumeInfo ensureVolume() => $_ensure(13);
}

class PlayItem extends $pb.GeneratedMessage {
  factory PlayItem({
    $core.int? itemType,
    $fixnum.Int64? oid,
    $core.Iterable<$fixnum.Int64>? subId,
    EventTracking? et,
    $fixnum.Int64? pos,
  }) {
    final result = create();
    if (itemType != null) result.itemType = itemType;
    if (oid != null) result.oid = oid;
    if (subId != null) result.subId.addAll(subId);
    if (et != null) result.et = et;
    if (pos != null) result.pos = pos;
    return result;
  }

  PlayItem._();

  factory PlayItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'itemType')
    ..aInt64(3, _omitFieldNames ? '' : 'oid')
    ..p<$fixnum.Int64>(4, _omitFieldNames ? '' : 'subId', $pb.PbFieldType.K6)
    ..aOM<EventTracking>(5, _omitFieldNames ? '' : 'et',
        subBuilder: EventTracking.create)
    ..aInt64(6, _omitFieldNames ? '' : 'pos')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayItem copyWith(void Function(PlayItem) updates) =>
      super.copyWith((message) => updates(message as PlayItem)) as PlayItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayItem create() => PlayItem._();
  @$core.override
  PlayItem createEmptyInstance() => create();
  static $pb.PbList<PlayItem> createRepeated() => $pb.PbList<PlayItem>();
  @$core.pragma('dart2js:noInline')
  static PlayItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayItem>(create);
  static PlayItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get itemType => $_getIZ(0);
  @$pb.TagNumber(1)
  set itemType($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemType() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemType() => $_clearField(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get oid => $_getI64(1);
  @$pb.TagNumber(3)
  set oid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(3)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(3)
  void clearOid() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$fixnum.Int64> get subId => $_getList(2);

  @$pb.TagNumber(5)
  EventTracking get et => $_getN(3);
  @$pb.TagNumber(5)
  set et(EventTracking value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasEt() => $_has(3);
  @$pb.TagNumber(5)
  void clearEt() => $_clearField(5);
  @$pb.TagNumber(5)
  EventTracking ensureEt() => $_ensure(3);

  @$pb.TagNumber(6)
  $fixnum.Int64 get pos => $_getI64(4);
  @$pb.TagNumber(6)
  set pos($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(6)
  $core.bool hasPos() => $_has(4);
  @$pb.TagNumber(6)
  void clearPos() => $_clearField(6);
}

class PlayURL extends $pb.GeneratedMessage {
  factory PlayURL({
    $core.Iterable<ResponseUrl>? durl,
  }) {
    final result = create();
    if (durl != null) result.durl.addAll(durl);
    return result;
  }

  PlayURL._();

  factory PlayURL.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayURL.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayURL',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..pPM<ResponseUrl>(1, _omitFieldNames ? '' : 'durl',
        subBuilder: ResponseUrl.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayURL clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayURL copyWith(void Function(PlayURL) updates) =>
      super.copyWith((message) => updates(message as PlayURL)) as PlayURL;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayURL create() => PlayURL._();
  @$core.override
  PlayURL createEmptyInstance() => create();
  static $pb.PbList<PlayURL> createRepeated() => $pb.PbList<PlayURL>();
  @$core.pragma('dart2js:noInline')
  static PlayURL getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayURL>(create);
  static PlayURL? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ResponseUrl> get durl => $_getList(0);
}

class PlayURLReq extends $pb.GeneratedMessage {
  factory PlayURLReq({
    PlayItem? item,
    $2.PlayerArgs? playerArgs,
  }) {
    final result = create();
    if (item != null) result.item = item;
    if (playerArgs != null) result.playerArgs = playerArgs;
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
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOM<PlayItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PlayItem.create)
    ..aOM<$2.PlayerArgs>(2, _omitFieldNames ? '' : 'playerArgs',
        subBuilder: $2.PlayerArgs.create)
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
  PlayItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PlayItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PlayItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  $2.PlayerArgs get playerArgs => $_getN(1);
  @$pb.TagNumber(2)
  set playerArgs($2.PlayerArgs value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlayerArgs() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayerArgs() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PlayerArgs ensurePlayerArgs() => $_ensure(1);
}

class PlayURLResp extends $pb.GeneratedMessage {
  factory PlayURLResp({
    PlayItem? item,
    $core.int? playable,
    $core.String? message,
    $core.Iterable<$core.MapEntry<$fixnum.Int64, PlayInfo>>? playerInfo,
  }) {
    final result = create();
    if (item != null) result.item = item;
    if (playable != null) result.playable = playable;
    if (message != null) result.message = message;
    if (playerInfo != null) result.playerInfo.addEntries(playerInfo);
    return result;
  }

  PlayURLResp._();

  factory PlayURLResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayURLResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayURLResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOM<PlayItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PlayItem.create)
    ..aI(2, _omitFieldNames ? '' : 'playable')
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..m<$fixnum.Int64, PlayInfo>(4, _omitFieldNames ? '' : 'playerInfo',
        entryClassName: 'PlayURLResp.PlayerInfoEntry',
        keyFieldType: $pb.PbFieldType.O6,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: PlayInfo.create,
        valueDefaultOrMaker: PlayInfo.getDefault,
        packageName: const $pb.PackageName('bilibili.app.listener.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayURLResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayURLResp copyWith(void Function(PlayURLResp) updates) =>
      super.copyWith((message) => updates(message as PlayURLResp))
          as PlayURLResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayURLResp create() => PlayURLResp._();
  @$core.override
  PlayURLResp createEmptyInstance() => create();
  static $pb.PbList<PlayURLResp> createRepeated() => $pb.PbList<PlayURLResp>();
  @$core.pragma('dart2js:noInline')
  static PlayURLResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayURLResp>(create);
  static PlayURLResp? _defaultInstance;

  @$pb.TagNumber(1)
  PlayItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PlayItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PlayItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get playable => $_getIZ(1);
  @$pb.TagNumber(2)
  set playable($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlayable() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayable() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbMap<$fixnum.Int64, PlayInfo> get playerInfo => $_getMap(3);
}

enum PlaylistAddReq_Pos { after, head, tail, notSet }

class PlaylistAddReq extends $pb.GeneratedMessage {
  factory PlaylistAddReq({
    $core.Iterable<PlayItem>? items,
    PlayItem? after,
    $core.bool? head,
    $core.bool? tail,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (after != null) result.after = after;
    if (head != null) result.head = head;
    if (tail != null) result.tail = tail;
    return result;
  }

  PlaylistAddReq._();

  factory PlaylistAddReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaylistAddReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, PlaylistAddReq_Pos>
      _PlaylistAddReq_PosByTag = {
    2: PlaylistAddReq_Pos.after,
    3: PlaylistAddReq_Pos.head,
    4: PlaylistAddReq_Pos.tail,
    0: PlaylistAddReq_Pos.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaylistAddReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..pPM<PlayItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: PlayItem.create)
    ..aOM<PlayItem>(2, _omitFieldNames ? '' : 'after',
        subBuilder: PlayItem.create)
    ..aOB(3, _omitFieldNames ? '' : 'head')
    ..aOB(4, _omitFieldNames ? '' : 'tail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistAddReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistAddReq copyWith(void Function(PlaylistAddReq) updates) =>
      super.copyWith((message) => updates(message as PlaylistAddReq))
          as PlaylistAddReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaylistAddReq create() => PlaylistAddReq._();
  @$core.override
  PlaylistAddReq createEmptyInstance() => create();
  static $pb.PbList<PlaylistAddReq> createRepeated() =>
      $pb.PbList<PlaylistAddReq>();
  @$core.pragma('dart2js:noInline')
  static PlaylistAddReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaylistAddReq>(create);
  static PlaylistAddReq? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  PlaylistAddReq_Pos whichPos() => _PlaylistAddReq_PosByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearPos() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $pb.PbList<PlayItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  PlayItem get after => $_getN(1);
  @$pb.TagNumber(2)
  set after(PlayItem value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAfter() => $_has(1);
  @$pb.TagNumber(2)
  void clearAfter() => $_clearField(2);
  @$pb.TagNumber(2)
  PlayItem ensureAfter() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get head => $_getBF(2);
  @$pb.TagNumber(3)
  set head($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHead() => $_has(2);
  @$pb.TagNumber(3)
  void clearHead() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get tail => $_getBF(3);
  @$pb.TagNumber(4)
  set tail($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTail() => $_has(3);
  @$pb.TagNumber(4)
  void clearTail() => $_clearField(4);
}

class PlaylistDelReq extends $pb.GeneratedMessage {
  factory PlaylistDelReq({
    $core.Iterable<PlayItem>? items,
    $core.bool? truncate,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (truncate != null) result.truncate = truncate;
    return result;
  }

  PlaylistDelReq._();

  factory PlaylistDelReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaylistDelReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaylistDelReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..pPM<PlayItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: PlayItem.create)
    ..aOB(2, _omitFieldNames ? '' : 'truncate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistDelReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistDelReq copyWith(void Function(PlaylistDelReq) updates) =>
      super.copyWith((message) => updates(message as PlaylistDelReq))
          as PlaylistDelReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaylistDelReq create() => PlaylistDelReq._();
  @$core.override
  PlaylistDelReq createEmptyInstance() => create();
  static $pb.PbList<PlaylistDelReq> createRepeated() =>
      $pb.PbList<PlaylistDelReq>();
  @$core.pragma('dart2js:noInline')
  static PlaylistDelReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaylistDelReq>(create);
  static PlaylistDelReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PlayItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get truncate => $_getBF(1);
  @$pb.TagNumber(2)
  set truncate($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTruncate() => $_has(1);
  @$pb.TagNumber(2)
  void clearTruncate() => $_clearField(2);
}

class PlaylistOffset extends $pb.GeneratedMessage {
  factory PlaylistOffset({
    PlaylistOffset_PlaylistScrollDirection? direction,
    PlayItem? lastItem,
    RandomOrderStatus? randomState,
    SortOption? sortOpt,
  }) {
    final result = create();
    if (direction != null) result.direction = direction;
    if (lastItem != null) result.lastItem = lastItem;
    if (randomState != null) result.randomState = randomState;
    if (sortOpt != null) result.sortOpt = sortOpt;
    return result;
  }

  PlaylistOffset._();

  factory PlaylistOffset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaylistOffset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaylistOffset',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aE<PlaylistOffset_PlaylistScrollDirection>(
        1, _omitFieldNames ? '' : 'direction',
        enumValues: PlaylistOffset_PlaylistScrollDirection.values)
    ..aOM<PlayItem>(2, _omitFieldNames ? '' : 'lastItem',
        subBuilder: PlayItem.create)
    ..aOM<RandomOrderStatus>(3, _omitFieldNames ? '' : 'randomState',
        subBuilder: RandomOrderStatus.create)
    ..aOM<SortOption>(4, _omitFieldNames ? '' : 'sortOpt',
        subBuilder: SortOption.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistOffset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistOffset copyWith(void Function(PlaylistOffset) updates) =>
      super.copyWith((message) => updates(message as PlaylistOffset))
          as PlaylistOffset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaylistOffset create() => PlaylistOffset._();
  @$core.override
  PlaylistOffset createEmptyInstance() => create();
  static $pb.PbList<PlaylistOffset> createRepeated() =>
      $pb.PbList<PlaylistOffset>();
  @$core.pragma('dart2js:noInline')
  static PlaylistOffset getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaylistOffset>(create);
  static PlaylistOffset? _defaultInstance;

  @$pb.TagNumber(1)
  PlaylistOffset_PlaylistScrollDirection get direction => $_getN(0);
  @$pb.TagNumber(1)
  set direction(PlaylistOffset_PlaylistScrollDirection value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDirection() => $_has(0);
  @$pb.TagNumber(1)
  void clearDirection() => $_clearField(1);

  @$pb.TagNumber(2)
  PlayItem get lastItem => $_getN(1);
  @$pb.TagNumber(2)
  set lastItem(PlayItem value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLastItem() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastItem() => $_clearField(2);
  @$pb.TagNumber(2)
  PlayItem ensureLastItem() => $_ensure(1);

  @$pb.TagNumber(3)
  RandomOrderStatus get randomState => $_getN(2);
  @$pb.TagNumber(3)
  set randomState(RandomOrderStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRandomState() => $_has(2);
  @$pb.TagNumber(3)
  void clearRandomState() => $_clearField(3);
  @$pb.TagNumber(3)
  RandomOrderStatus ensureRandomState() => $_ensure(2);

  @$pb.TagNumber(4)
  SortOption get sortOpt => $_getN(3);
  @$pb.TagNumber(4)
  set sortOpt(SortOption value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSortOpt() => $_has(3);
  @$pb.TagNumber(4)
  void clearSortOpt() => $_clearField(4);
  @$pb.TagNumber(4)
  SortOption ensureSortOpt() => $_ensure(3);
}

class PlaylistReq extends $pb.GeneratedMessage {
  factory PlaylistReq({
    PlaylistSource? from,
    $fixnum.Int64? id,
    PlayItem? anchor,
    PageOption? pageOpt,
    $2.PlayerArgs? playerArgs,
    $fixnum.Int64? extraId,
    SortOption? sortOpt,
    $4.Pagination? pagination,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (id != null) result.id = id;
    if (anchor != null) result.anchor = anchor;
    if (pageOpt != null) result.pageOpt = pageOpt;
    if (playerArgs != null) result.playerArgs = playerArgs;
    if (extraId != null) result.extraId = extraId;
    if (sortOpt != null) result.sortOpt = sortOpt;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  PlaylistReq._();

  factory PlaylistReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaylistReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaylistReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aE<PlaylistSource>(1, _omitFieldNames ? '' : 'from',
        enumValues: PlaylistSource.values)
    ..aInt64(2, _omitFieldNames ? '' : 'id')
    ..aOM<PlayItem>(3, _omitFieldNames ? '' : 'anchor',
        subBuilder: PlayItem.create)
    ..aOM<PageOption>(4, _omitFieldNames ? '' : 'pageOpt',
        subBuilder: PageOption.create)
    ..aOM<$2.PlayerArgs>(5, _omitFieldNames ? '' : 'playerArgs',
        subBuilder: $2.PlayerArgs.create)
    ..aInt64(6, _omitFieldNames ? '' : 'extraId')
    ..aOM<SortOption>(7, _omitFieldNames ? '' : 'sortOpt',
        subBuilder: SortOption.create)
    ..aOM<$4.Pagination>(8, _omitFieldNames ? '' : 'pagination',
        subBuilder: $4.Pagination.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistReq copyWith(void Function(PlaylistReq) updates) =>
      super.copyWith((message) => updates(message as PlaylistReq))
          as PlaylistReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaylistReq create() => PlaylistReq._();
  @$core.override
  PlaylistReq createEmptyInstance() => create();
  static $pb.PbList<PlaylistReq> createRepeated() => $pb.PbList<PlaylistReq>();
  @$core.pragma('dart2js:noInline')
  static PlaylistReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaylistReq>(create);
  static PlaylistReq? _defaultInstance;

  @$pb.TagNumber(1)
  PlaylistSource get from => $_getN(0);
  @$pb.TagNumber(1)
  set from(PlaylistSource value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get id => $_getI64(1);
  @$pb.TagNumber(2)
  set id($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  @$pb.TagNumber(3)
  PlayItem get anchor => $_getN(2);
  @$pb.TagNumber(3)
  set anchor(PlayItem value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAnchor() => $_has(2);
  @$pb.TagNumber(3)
  void clearAnchor() => $_clearField(3);
  @$pb.TagNumber(3)
  PlayItem ensureAnchor() => $_ensure(2);

  @$pb.TagNumber(4)
  PageOption get pageOpt => $_getN(3);
  @$pb.TagNumber(4)
  set pageOpt(PageOption value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPageOpt() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageOpt() => $_clearField(4);
  @$pb.TagNumber(4)
  PageOption ensurePageOpt() => $_ensure(3);

  @$pb.TagNumber(5)
  $2.PlayerArgs get playerArgs => $_getN(4);
  @$pb.TagNumber(5)
  set playerArgs($2.PlayerArgs value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPlayerArgs() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlayerArgs() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.PlayerArgs ensurePlayerArgs() => $_ensure(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get extraId => $_getI64(5);
  @$pb.TagNumber(6)
  set extraId($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExtraId() => $_has(5);
  @$pb.TagNumber(6)
  void clearExtraId() => $_clearField(6);

  @$pb.TagNumber(7)
  SortOption get sortOpt => $_getN(6);
  @$pb.TagNumber(7)
  set sortOpt(SortOption value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSortOpt() => $_has(6);
  @$pb.TagNumber(7)
  void clearSortOpt() => $_clearField(7);
  @$pb.TagNumber(7)
  SortOption ensureSortOpt() => $_ensure(6);

  @$pb.TagNumber(8)
  $4.Pagination get pagination => $_getN(7);
  @$pb.TagNumber(8)
  set pagination($4.Pagination value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPagination() => $_has(7);
  @$pb.TagNumber(8)
  void clearPagination() => $_clearField(8);
  @$pb.TagNumber(8)
  $4.Pagination ensurePagination() => $_ensure(7);
}

class PlaylistResp extends $pb.GeneratedMessage {
  factory PlaylistResp({
    $core.int? total,
    $core.bool? reachStart,
    $core.bool? reachEnd,
    $core.Iterable<DetailItem>? list,
    PlayItem? lastPlay,
    $fixnum.Int64? lastProgress,
    $4.PaginationReply? paginationReply,
  }) {
    final result = create();
    if (total != null) result.total = total;
    if (reachStart != null) result.reachStart = reachStart;
    if (reachEnd != null) result.reachEnd = reachEnd;
    if (list != null) result.list.addAll(list);
    if (lastPlay != null) result.lastPlay = lastPlay;
    if (lastProgress != null) result.lastProgress = lastProgress;
    if (paginationReply != null) result.paginationReply = paginationReply;
    return result;
  }

  PlaylistResp._();

  factory PlaylistResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaylistResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaylistResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'total')
    ..aOB(2, _omitFieldNames ? '' : 'reachStart')
    ..aOB(3, _omitFieldNames ? '' : 'reachEnd')
    ..pPM<DetailItem>(4, _omitFieldNames ? '' : 'list',
        subBuilder: DetailItem.create)
    ..aOM<PlayItem>(5, _omitFieldNames ? '' : 'lastPlay',
        subBuilder: PlayItem.create)
    ..aInt64(6, _omitFieldNames ? '' : 'lastProgress')
    ..aOM<$4.PaginationReply>(7, _omitFieldNames ? '' : 'paginationReply',
        subBuilder: $4.PaginationReply.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaylistResp copyWith(void Function(PlaylistResp) updates) =>
      super.copyWith((message) => updates(message as PlaylistResp))
          as PlaylistResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaylistResp create() => PlaylistResp._();
  @$core.override
  PlaylistResp createEmptyInstance() => create();
  static $pb.PbList<PlaylistResp> createRepeated() =>
      $pb.PbList<PlaylistResp>();
  @$core.pragma('dart2js:noInline')
  static PlaylistResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaylistResp>(create);
  static PlaylistResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get total => $_getIZ(0);
  @$pb.TagNumber(1)
  set total($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get reachStart => $_getBF(1);
  @$pb.TagNumber(2)
  set reachStart($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReachStart() => $_has(1);
  @$pb.TagNumber(2)
  void clearReachStart() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get reachEnd => $_getBF(2);
  @$pb.TagNumber(3)
  set reachEnd($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReachEnd() => $_has(2);
  @$pb.TagNumber(3)
  void clearReachEnd() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<DetailItem> get list => $_getList(3);

  @$pb.TagNumber(5)
  PlayItem get lastPlay => $_getN(4);
  @$pb.TagNumber(5)
  set lastPlay(PlayItem value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLastPlay() => $_has(4);
  @$pb.TagNumber(5)
  void clearLastPlay() => $_clearField(5);
  @$pb.TagNumber(5)
  PlayItem ensureLastPlay() => $_ensure(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get lastProgress => $_getI64(5);
  @$pb.TagNumber(6)
  set lastProgress($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLastProgress() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastProgress() => $_clearField(6);

  @$pb.TagNumber(7)
  $4.PaginationReply get paginationReply => $_getN(6);
  @$pb.TagNumber(7)
  set paginationReply($4.PaginationReply value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPaginationReply() => $_has(6);
  @$pb.TagNumber(7)
  void clearPaginationReply() => $_clearField(7);
  @$pb.TagNumber(7)
  $4.PaginationReply ensurePaginationReply() => $_ensure(6);
}

class RandomOrderStatus extends $pb.GeneratedMessage {
  factory RandomOrderStatus({
    $core.Iterable<$fixnum.Int64>? exposedPos,
  }) {
    final result = create();
    if (exposedPos != null) result.exposedPos.addAll(exposedPos);
    return result;
  }

  RandomOrderStatus._();

  factory RandomOrderStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RandomOrderStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RandomOrderStatus',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..p<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'exposedPos', $pb.PbFieldType.K6)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RandomOrderStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RandomOrderStatus copyWith(void Function(RandomOrderStatus) updates) =>
      super.copyWith((message) => updates(message as RandomOrderStatus))
          as RandomOrderStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RandomOrderStatus create() => RandomOrderStatus._();
  @$core.override
  RandomOrderStatus createEmptyInstance() => create();
  static $pb.PbList<RandomOrderStatus> createRepeated() =>
      $pb.PbList<RandomOrderStatus>();
  @$core.pragma('dart2js:noInline')
  static RandomOrderStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RandomOrderStatus>(create);
  static RandomOrderStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$fixnum.Int64> get exposedPos => $_getList(0);
}

class RcmdOffset extends $pb.GeneratedMessage {
  factory RcmdOffset({
    $fixnum.Int64? rcmdFrom,
    $fixnum.Int64? id,
    $core.int? page,
    $core.String? sessionId,
    $core.String? fromTrackid,
  }) {
    final result = create();
    if (rcmdFrom != null) result.rcmdFrom = rcmdFrom;
    if (id != null) result.id = id;
    if (page != null) result.page = page;
    if (sessionId != null) result.sessionId = sessionId;
    if (fromTrackid != null) result.fromTrackid = fromTrackid;
    return result;
  }

  RcmdOffset._();

  factory RcmdOffset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RcmdOffset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RcmdOffset',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'rcmdFrom')
    ..aInt64(2, _omitFieldNames ? '' : 'id')
    ..aI(3, _omitFieldNames ? '' : 'page')
    ..aOS(4, _omitFieldNames ? '' : 'sessionId')
    ..aOS(5, _omitFieldNames ? '' : 'fromTrackid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RcmdOffset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RcmdOffset copyWith(void Function(RcmdOffset) updates) =>
      super.copyWith((message) => updates(message as RcmdOffset)) as RcmdOffset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RcmdOffset create() => RcmdOffset._();
  @$core.override
  RcmdOffset createEmptyInstance() => create();
  static $pb.PbList<RcmdOffset> createRepeated() => $pb.PbList<RcmdOffset>();
  @$core.pragma('dart2js:noInline')
  static RcmdOffset getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RcmdOffset>(create);
  static RcmdOffset? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get rcmdFrom => $_getI64(0);
  @$pb.TagNumber(1)
  set rcmdFrom($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRcmdFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearRcmdFrom() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get id => $_getI64(1);
  @$pb.TagNumber(2)
  set id($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get page => $_getIZ(2);
  @$pb.TagNumber(3)
  set page($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPage() => $_has(2);
  @$pb.TagNumber(3)
  void clearPage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sessionId => $_getSZ(3);
  @$pb.TagNumber(4)
  set sessionId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSessionId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSessionId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get fromTrackid => $_getSZ(4);
  @$pb.TagNumber(5)
  set fromTrackid($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFromTrackid() => $_has(4);
  @$pb.TagNumber(5)
  void clearFromTrackid() => $_clearField(5);
}

class RcmdPlaylistReq extends $pb.GeneratedMessage {
  factory RcmdPlaylistReq({
    RcmdPlaylistReq_RcmdFrom? from,
    $fixnum.Int64? id,
    $core.bool? needHistory,
    $core.bool? needTopCards,
    $2.PlayerArgs? playerArgs,
    $4.Pagination? page,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? annotations,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (id != null) result.id = id;
    if (needHistory != null) result.needHistory = needHistory;
    if (needTopCards != null) result.needTopCards = needTopCards;
    if (playerArgs != null) result.playerArgs = playerArgs;
    if (page != null) result.page = page;
    if (annotations != null) result.annotations.addEntries(annotations);
    return result;
  }

  RcmdPlaylistReq._();

  factory RcmdPlaylistReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RcmdPlaylistReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RcmdPlaylistReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aE<RcmdPlaylistReq_RcmdFrom>(1, _omitFieldNames ? '' : 'from',
        enumValues: RcmdPlaylistReq_RcmdFrom.values)
    ..aInt64(2, _omitFieldNames ? '' : 'id')
    ..aOB(3, _omitFieldNames ? '' : 'needHistory')
    ..aOB(4, _omitFieldNames ? '' : 'needTopCards')
    ..aOM<$2.PlayerArgs>(5, _omitFieldNames ? '' : 'playerArgs',
        subBuilder: $2.PlayerArgs.create)
    ..aOM<$4.Pagination>(6, _omitFieldNames ? '' : 'page',
        subBuilder: $4.Pagination.create)
    ..m<$core.String, $core.String>(7, _omitFieldNames ? '' : 'annotations',
        entryClassName: 'RcmdPlaylistReq.AnnotationsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.listener.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RcmdPlaylistReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RcmdPlaylistReq copyWith(void Function(RcmdPlaylistReq) updates) =>
      super.copyWith((message) => updates(message as RcmdPlaylistReq))
          as RcmdPlaylistReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RcmdPlaylistReq create() => RcmdPlaylistReq._();
  @$core.override
  RcmdPlaylistReq createEmptyInstance() => create();
  static $pb.PbList<RcmdPlaylistReq> createRepeated() =>
      $pb.PbList<RcmdPlaylistReq>();
  @$core.pragma('dart2js:noInline')
  static RcmdPlaylistReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RcmdPlaylistReq>(create);
  static RcmdPlaylistReq? _defaultInstance;

  @$pb.TagNumber(1)
  RcmdPlaylistReq_RcmdFrom get from => $_getN(0);
  @$pb.TagNumber(1)
  set from(RcmdPlaylistReq_RcmdFrom value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get id => $_getI64(1);
  @$pb.TagNumber(2)
  set id($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get needHistory => $_getBF(2);
  @$pb.TagNumber(3)
  set needHistory($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNeedHistory() => $_has(2);
  @$pb.TagNumber(3)
  void clearNeedHistory() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get needTopCards => $_getBF(3);
  @$pb.TagNumber(4)
  set needTopCards($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNeedTopCards() => $_has(3);
  @$pb.TagNumber(4)
  void clearNeedTopCards() => $_clearField(4);

  @$pb.TagNumber(5)
  $2.PlayerArgs get playerArgs => $_getN(4);
  @$pb.TagNumber(5)
  set playerArgs($2.PlayerArgs value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPlayerArgs() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlayerArgs() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.PlayerArgs ensurePlayerArgs() => $_ensure(4);

  @$pb.TagNumber(6)
  $4.Pagination get page => $_getN(5);
  @$pb.TagNumber(6)
  set page($4.Pagination value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPage() => $_has(5);
  @$pb.TagNumber(6)
  void clearPage() => $_clearField(6);
  @$pb.TagNumber(6)
  $4.Pagination ensurePage() => $_ensure(5);

  @$pb.TagNumber(7)
  $pb.PbMap<$core.String, $core.String> get annotations => $_getMap(6);
}

class RcmdPlaylistResp extends $pb.GeneratedMessage {
  factory RcmdPlaylistResp({
    $core.Iterable<DetailItem>? list,
    $fixnum.Int64? historyLen,
    $core.Iterable<TopCard>? topCards,
    $4.PaginationReply? nextPage,
  }) {
    final result = create();
    if (list != null) result.list.addAll(list);
    if (historyLen != null) result.historyLen = historyLen;
    if (topCards != null) result.topCards.addAll(topCards);
    if (nextPage != null) result.nextPage = nextPage;
    return result;
  }

  RcmdPlaylistResp._();

  factory RcmdPlaylistResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RcmdPlaylistResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RcmdPlaylistResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..pPM<DetailItem>(1, _omitFieldNames ? '' : 'list',
        subBuilder: DetailItem.create)
    ..aInt64(2, _omitFieldNames ? '' : 'historyLen')
    ..pPM<TopCard>(3, _omitFieldNames ? '' : 'topCards',
        subBuilder: TopCard.create)
    ..aOM<$4.PaginationReply>(4, _omitFieldNames ? '' : 'nextPage',
        subBuilder: $4.PaginationReply.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RcmdPlaylistResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RcmdPlaylistResp copyWith(void Function(RcmdPlaylistResp) updates) =>
      super.copyWith((message) => updates(message as RcmdPlaylistResp))
          as RcmdPlaylistResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RcmdPlaylistResp create() => RcmdPlaylistResp._();
  @$core.override
  RcmdPlaylistResp createEmptyInstance() => create();
  static $pb.PbList<RcmdPlaylistResp> createRepeated() =>
      $pb.PbList<RcmdPlaylistResp>();
  @$core.pragma('dart2js:noInline')
  static RcmdPlaylistResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RcmdPlaylistResp>(create);
  static RcmdPlaylistResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DetailItem> get list => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get historyLen => $_getI64(1);
  @$pb.TagNumber(2)
  set historyLen($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHistoryLen() => $_has(1);
  @$pb.TagNumber(2)
  void clearHistoryLen() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<TopCard> get topCards => $_getList(2);

  @$pb.TagNumber(4)
  $4.PaginationReply get nextPage => $_getN(3);
  @$pb.TagNumber(4)
  set nextPage($4.PaginationReply value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasNextPage() => $_has(3);
  @$pb.TagNumber(4)
  void clearNextPage() => $_clearField(4);
  @$pb.TagNumber(4)
  $4.PaginationReply ensureNextPage() => $_ensure(3);
}

class ResponseUrl extends $pb.GeneratedMessage {
  factory ResponseUrl({
    $core.int? order,
    $fixnum.Int64? length,
    $fixnum.Int64? size,
    $core.String? ahead,
    $core.String? vhead,
    $core.String? url,
    $core.Iterable<$core.String>? backupUrl,
    $core.String? md5,
  }) {
    final result = create();
    if (order != null) result.order = order;
    if (length != null) result.length = length;
    if (size != null) result.size = size;
    if (ahead != null) result.ahead = ahead;
    if (vhead != null) result.vhead = vhead;
    if (url != null) result.url = url;
    if (backupUrl != null) result.backupUrl.addAll(backupUrl);
    if (md5 != null) result.md5 = md5;
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
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'order')
    ..aInt64(2, _omitFieldNames ? '' : 'length')
    ..aInt64(3, _omitFieldNames ? '' : 'size')
    ..aOS(4, _omitFieldNames ? '' : 'ahead')
    ..aOS(5, _omitFieldNames ? '' : 'vhead')
    ..aOS(6, _omitFieldNames ? '' : 'url')
    ..pPS(7, _omitFieldNames ? '' : 'backupUrl')
    ..aOS(8, _omitFieldNames ? '' : 'md5')
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
  $core.String get ahead => $_getSZ(3);
  @$pb.TagNumber(4)
  set ahead($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAhead() => $_has(3);
  @$pb.TagNumber(4)
  void clearAhead() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get vhead => $_getSZ(4);
  @$pb.TagNumber(5)
  set vhead($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVhead() => $_has(4);
  @$pb.TagNumber(5)
  void clearVhead() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get url => $_getSZ(5);
  @$pb.TagNumber(6)
  set url($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get backupUrl => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get md5 => $_getSZ(7);
  @$pb.TagNumber(8)
  set md5($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMd5() => $_has(7);
  @$pb.TagNumber(8)
  void clearMd5() => $_clearField(8);
}

class SortOption extends $pb.GeneratedMessage {
  factory SortOption({
    ListOrder? order,
    ListSortField? sortField,
    $core.bool? isSwitching,
  }) {
    final result = create();
    if (order != null) result.order = order;
    if (sortField != null) result.sortField = sortField;
    if (isSwitching != null) result.isSwitching = isSwitching;
    return result;
  }

  SortOption._();

  factory SortOption.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SortOption.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SortOption',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aE<ListOrder>(1, _omitFieldNames ? '' : 'order',
        enumValues: ListOrder.values)
    ..aE<ListSortField>(2, _omitFieldNames ? '' : 'sortField',
        enumValues: ListSortField.values)
    ..aOB(3, _omitFieldNames ? '' : 'isSwitching')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SortOption clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SortOption copyWith(void Function(SortOption) updates) =>
      super.copyWith((message) => updates(message as SortOption)) as SortOption;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SortOption create() => SortOption._();
  @$core.override
  SortOption createEmptyInstance() => create();
  static $pb.PbList<SortOption> createRepeated() => $pb.PbList<SortOption>();
  @$core.pragma('dart2js:noInline')
  static SortOption getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SortOption>(create);
  static SortOption? _defaultInstance;

  @$pb.TagNumber(1)
  ListOrder get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(ListOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);

  @$pb.TagNumber(2)
  ListSortField get sortField => $_getN(1);
  @$pb.TagNumber(2)
  set sortField(ListSortField value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSortField() => $_has(1);
  @$pb.TagNumber(2)
  void clearSortField() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isSwitching => $_getBF(2);
  @$pb.TagNumber(3)
  set isSwitching($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsSwitching() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsSwitching() => $_clearField(3);
}

class ThumbUpReq extends $pb.GeneratedMessage {
  factory ThumbUpReq({
    PlayItem? item,
    ThumbUpReq_ThumbType? action,
  }) {
    final result = create();
    if (item != null) result.item = item;
    if (action != null) result.action = action;
    return result;
  }

  ThumbUpReq._();

  factory ThumbUpReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ThumbUpReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThumbUpReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOM<PlayItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PlayItem.create)
    ..aE<ThumbUpReq_ThumbType>(2, _omitFieldNames ? '' : 'action',
        enumValues: ThumbUpReq_ThumbType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThumbUpReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThumbUpReq copyWith(void Function(ThumbUpReq) updates) =>
      super.copyWith((message) => updates(message as ThumbUpReq)) as ThumbUpReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThumbUpReq create() => ThumbUpReq._();
  @$core.override
  ThumbUpReq createEmptyInstance() => create();
  static $pb.PbList<ThumbUpReq> createRepeated() => $pb.PbList<ThumbUpReq>();
  @$core.pragma('dart2js:noInline')
  static ThumbUpReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThumbUpReq>(create);
  static ThumbUpReq? _defaultInstance;

  @$pb.TagNumber(1)
  PlayItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PlayItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PlayItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  ThumbUpReq_ThumbType get action => $_getN(1);
  @$pb.TagNumber(2)
  set action(ThumbUpReq_ThumbType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => $_clearField(2);
}

class ThumbUpResp extends $pb.GeneratedMessage {
  factory ThumbUpResp({
    $core.String? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  ThumbUpResp._();

  factory ThumbUpResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ThumbUpResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThumbUpResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThumbUpResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThumbUpResp copyWith(void Function(ThumbUpResp) updates) =>
      super.copyWith((message) => updates(message as ThumbUpResp))
          as ThumbUpResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThumbUpResp create() => ThumbUpResp._();
  @$core.override
  ThumbUpResp createEmptyInstance() => create();
  static $pb.PbList<ThumbUpResp> createRepeated() => $pb.PbList<ThumbUpResp>();
  @$core.pragma('dart2js:noInline')
  static ThumbUpResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThumbUpResp>(create);
  static ThumbUpResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

enum TopCard_Card { listenHistory, favFolder, upRecall, pickToday, notSet }

class TopCard extends $pb.GeneratedMessage {
  factory TopCard({
    $core.String? title,
    TopCard_PlayStrategy? playStyle,
    TopCardType? cardType,
    TpcdHistory? listenHistory,
    TpcdFavFolder? favFolder,
    TpcdUpRecall? upRecall,
    TpcdPickToday? pickToday,
    $fixnum.Int64? pos,
    $core.String? titleIcon,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (playStyle != null) result.playStyle = playStyle;
    if (cardType != null) result.cardType = cardType;
    if (listenHistory != null) result.listenHistory = listenHistory;
    if (favFolder != null) result.favFolder = favFolder;
    if (upRecall != null) result.upRecall = upRecall;
    if (pickToday != null) result.pickToday = pickToday;
    if (pos != null) result.pos = pos;
    if (titleIcon != null) result.titleIcon = titleIcon;
    return result;
  }

  TopCard._();

  factory TopCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TopCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, TopCard_Card> _TopCard_CardByTag = {
    4: TopCard_Card.listenHistory,
    5: TopCard_Card.favFolder,
    6: TopCard_Card.upRecall,
    7: TopCard_Card.pickToday,
    0: TopCard_Card.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TopCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..oo(0, [4, 5, 6, 7])
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aE<TopCard_PlayStrategy>(2, _omitFieldNames ? '' : 'playStyle',
        enumValues: TopCard_PlayStrategy.values)
    ..aE<TopCardType>(3, _omitFieldNames ? '' : 'cardType',
        enumValues: TopCardType.values)
    ..aOM<TpcdHistory>(4, _omitFieldNames ? '' : 'listenHistory',
        subBuilder: TpcdHistory.create)
    ..aOM<TpcdFavFolder>(5, _omitFieldNames ? '' : 'favFolder',
        subBuilder: TpcdFavFolder.create)
    ..aOM<TpcdUpRecall>(6, _omitFieldNames ? '' : 'upRecall',
        subBuilder: TpcdUpRecall.create)
    ..aOM<TpcdPickToday>(7, _omitFieldNames ? '' : 'pickToday',
        subBuilder: TpcdPickToday.create)
    ..aInt64(8, _omitFieldNames ? '' : 'pos')
    ..aOS(9, _omitFieldNames ? '' : 'titleIcon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TopCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TopCard copyWith(void Function(TopCard) updates) =>
      super.copyWith((message) => updates(message as TopCard)) as TopCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TopCard create() => TopCard._();
  @$core.override
  TopCard createEmptyInstance() => create();
  static $pb.PbList<TopCard> createRepeated() => $pb.PbList<TopCard>();
  @$core.pragma('dart2js:noInline')
  static TopCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TopCard>(create);
  static TopCard? _defaultInstance;

  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  TopCard_Card whichCard() => _TopCard_CardByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  void clearCard() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  TopCard_PlayStrategy get playStyle => $_getN(1);
  @$pb.TagNumber(2)
  set playStyle(TopCard_PlayStrategy value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlayStyle() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayStyle() => $_clearField(2);

  @$pb.TagNumber(3)
  TopCardType get cardType => $_getN(2);
  @$pb.TagNumber(3)
  set cardType(TopCardType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCardType() => $_has(2);
  @$pb.TagNumber(3)
  void clearCardType() => $_clearField(3);

  @$pb.TagNumber(4)
  TpcdHistory get listenHistory => $_getN(3);
  @$pb.TagNumber(4)
  set listenHistory(TpcdHistory value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasListenHistory() => $_has(3);
  @$pb.TagNumber(4)
  void clearListenHistory() => $_clearField(4);
  @$pb.TagNumber(4)
  TpcdHistory ensureListenHistory() => $_ensure(3);

  @$pb.TagNumber(5)
  TpcdFavFolder get favFolder => $_getN(4);
  @$pb.TagNumber(5)
  set favFolder(TpcdFavFolder value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasFavFolder() => $_has(4);
  @$pb.TagNumber(5)
  void clearFavFolder() => $_clearField(5);
  @$pb.TagNumber(5)
  TpcdFavFolder ensureFavFolder() => $_ensure(4);

  @$pb.TagNumber(6)
  TpcdUpRecall get upRecall => $_getN(5);
  @$pb.TagNumber(6)
  set upRecall(TpcdUpRecall value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasUpRecall() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpRecall() => $_clearField(6);
  @$pb.TagNumber(6)
  TpcdUpRecall ensureUpRecall() => $_ensure(5);

  @$pb.TagNumber(7)
  TpcdPickToday get pickToday => $_getN(6);
  @$pb.TagNumber(7)
  set pickToday(TpcdPickToday value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPickToday() => $_has(6);
  @$pb.TagNumber(7)
  void clearPickToday() => $_clearField(7);
  @$pb.TagNumber(7)
  TpcdPickToday ensurePickToday() => $_ensure(6);

  @$pb.TagNumber(8)
  $fixnum.Int64 get pos => $_getI64(7);
  @$pb.TagNumber(8)
  set pos($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPos() => $_has(7);
  @$pb.TagNumber(8)
  void clearPos() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get titleIcon => $_getSZ(8);
  @$pb.TagNumber(9)
  set titleIcon($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTitleIcon() => $_has(8);
  @$pb.TagNumber(9)
  void clearTitleIcon() => $_clearField(9);
}

class TpcdFavFolder extends $pb.GeneratedMessage {
  factory TpcdFavFolder({
    DetailItem? item,
    $core.String? text,
    $core.String? pic,
    $fixnum.Int64? fid,
    $core.int? folderType,
  }) {
    final result = create();
    if (item != null) result.item = item;
    if (text != null) result.text = text;
    if (pic != null) result.pic = pic;
    if (fid != null) result.fid = fid;
    if (folderType != null) result.folderType = folderType;
    return result;
  }

  TpcdFavFolder._();

  factory TpcdFavFolder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TpcdFavFolder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TpcdFavFolder',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOM<DetailItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: DetailItem.create)
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'pic')
    ..aInt64(4, _omitFieldNames ? '' : 'fid')
    ..aI(5, _omitFieldNames ? '' : 'folderType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TpcdFavFolder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TpcdFavFolder copyWith(void Function(TpcdFavFolder) updates) =>
      super.copyWith((message) => updates(message as TpcdFavFolder))
          as TpcdFavFolder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TpcdFavFolder create() => TpcdFavFolder._();
  @$core.override
  TpcdFavFolder createEmptyInstance() => create();
  static $pb.PbList<TpcdFavFolder> createRepeated() =>
      $pb.PbList<TpcdFavFolder>();
  @$core.pragma('dart2js:noInline')
  static TpcdFavFolder getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TpcdFavFolder>(create);
  static TpcdFavFolder? _defaultInstance;

  @$pb.TagNumber(1)
  DetailItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(DetailItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  DetailItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pic => $_getSZ(2);
  @$pb.TagNumber(3)
  set pic($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPic() => $_has(2);
  @$pb.TagNumber(3)
  void clearPic() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get fid => $_getI64(3);
  @$pb.TagNumber(4)
  set fid($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFid() => $_has(3);
  @$pb.TagNumber(4)
  void clearFid() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get folderType => $_getIZ(4);
  @$pb.TagNumber(5)
  set folderType($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFolderType() => $_has(4);
  @$pb.TagNumber(5)
  void clearFolderType() => $_clearField(5);
}

class TpcdHistory extends $pb.GeneratedMessage {
  factory TpcdHistory({
    DetailItem? item,
    $core.String? text,
    $core.String? pic,
  }) {
    final result = create();
    if (item != null) result.item = item;
    if (text != null) result.text = text;
    if (pic != null) result.pic = pic;
    return result;
  }

  TpcdHistory._();

  factory TpcdHistory.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TpcdHistory.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TpcdHistory',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOM<DetailItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: DetailItem.create)
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'pic')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TpcdHistory clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TpcdHistory copyWith(void Function(TpcdHistory) updates) =>
      super.copyWith((message) => updates(message as TpcdHistory))
          as TpcdHistory;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TpcdHistory create() => TpcdHistory._();
  @$core.override
  TpcdHistory createEmptyInstance() => create();
  static $pb.PbList<TpcdHistory> createRepeated() => $pb.PbList<TpcdHistory>();
  @$core.pragma('dart2js:noInline')
  static TpcdHistory getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TpcdHistory>(create);
  static TpcdHistory? _defaultInstance;

  @$pb.TagNumber(1)
  DetailItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(DetailItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  DetailItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pic => $_getSZ(2);
  @$pb.TagNumber(3)
  set pic($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPic() => $_has(2);
  @$pb.TagNumber(3)
  void clearPic() => $_clearField(3);
}

class TpcdPickToday extends $pb.GeneratedMessage {
  factory TpcdPickToday({
    DetailItem? item,
    $core.String? text,
    $core.String? pic,
    $fixnum.Int64? pickId,
    $fixnum.Int64? pickCardId,
  }) {
    final result = create();
    if (item != null) result.item = item;
    if (text != null) result.text = text;
    if (pic != null) result.pic = pic;
    if (pickId != null) result.pickId = pickId;
    if (pickCardId != null) result.pickCardId = pickCardId;
    return result;
  }

  TpcdPickToday._();

  factory TpcdPickToday.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TpcdPickToday.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TpcdPickToday',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOM<DetailItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: DetailItem.create)
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'pic')
    ..aInt64(4, _omitFieldNames ? '' : 'pickId')
    ..aInt64(5, _omitFieldNames ? '' : 'pickCardId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TpcdPickToday clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TpcdPickToday copyWith(void Function(TpcdPickToday) updates) =>
      super.copyWith((message) => updates(message as TpcdPickToday))
          as TpcdPickToday;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TpcdPickToday create() => TpcdPickToday._();
  @$core.override
  TpcdPickToday createEmptyInstance() => create();
  static $pb.PbList<TpcdPickToday> createRepeated() =>
      $pb.PbList<TpcdPickToday>();
  @$core.pragma('dart2js:noInline')
  static TpcdPickToday getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TpcdPickToday>(create);
  static TpcdPickToday? _defaultInstance;

  @$pb.TagNumber(1)
  DetailItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(DetailItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  DetailItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pic => $_getSZ(2);
  @$pb.TagNumber(3)
  set pic($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPic() => $_has(2);
  @$pb.TagNumber(3)
  void clearPic() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get pickId => $_getI64(3);
  @$pb.TagNumber(4)
  set pickId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPickId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPickId() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get pickCardId => $_getI64(4);
  @$pb.TagNumber(5)
  set pickCardId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPickCardId() => $_has(4);
  @$pb.TagNumber(5)
  void clearPickCardId() => $_clearField(5);
}

class TpcdUpRecall extends $pb.GeneratedMessage {
  factory TpcdUpRecall({
    $fixnum.Int64? upMid,
    $core.String? text,
    $core.String? avatar,
    $fixnum.Int64? medialistType,
    $fixnum.Int64? medialistBizId,
    DetailItem? item,
  }) {
    final result = create();
    if (upMid != null) result.upMid = upMid;
    if (text != null) result.text = text;
    if (avatar != null) result.avatar = avatar;
    if (medialistType != null) result.medialistType = medialistType;
    if (medialistBizId != null) result.medialistBizId = medialistBizId;
    if (item != null) result.item = item;
    return result;
  }

  TpcdUpRecall._();

  factory TpcdUpRecall.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TpcdUpRecall.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TpcdUpRecall',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'upMid')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'avatar')
    ..aInt64(4, _omitFieldNames ? '' : 'medialistType')
    ..aInt64(5, _omitFieldNames ? '' : 'medialistBizId')
    ..aOM<DetailItem>(6, _omitFieldNames ? '' : 'item',
        subBuilder: DetailItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TpcdUpRecall clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TpcdUpRecall copyWith(void Function(TpcdUpRecall) updates) =>
      super.copyWith((message) => updates(message as TpcdUpRecall))
          as TpcdUpRecall;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TpcdUpRecall create() => TpcdUpRecall._();
  @$core.override
  TpcdUpRecall createEmptyInstance() => create();
  static $pb.PbList<TpcdUpRecall> createRepeated() =>
      $pb.PbList<TpcdUpRecall>();
  @$core.pragma('dart2js:noInline')
  static TpcdUpRecall getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TpcdUpRecall>(create);
  static TpcdUpRecall? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get upMid => $_getI64(0);
  @$pb.TagNumber(1)
  set upMid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUpMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpMid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get avatar => $_getSZ(2);
  @$pb.TagNumber(3)
  set avatar($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAvatar() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvatar() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get medialistType => $_getI64(3);
  @$pb.TagNumber(4)
  set medialistType($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMedialistType() => $_has(3);
  @$pb.TagNumber(4)
  void clearMedialistType() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get medialistBizId => $_getI64(4);
  @$pb.TagNumber(5)
  set medialistBizId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMedialistBizId() => $_has(4);
  @$pb.TagNumber(5)
  void clearMedialistBizId() => $_clearField(5);

  @$pb.TagNumber(6)
  DetailItem get item => $_getN(5);
  @$pb.TagNumber(6)
  set item(DetailItem value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasItem() => $_has(5);
  @$pb.TagNumber(6)
  void clearItem() => $_clearField(6);
  @$pb.TagNumber(6)
  DetailItem ensureItem() => $_ensure(5);
}

class TripleLikeReq extends $pb.GeneratedMessage {
  factory TripleLikeReq({
    PlayItem? item,
  }) {
    final result = create();
    if (item != null) result.item = item;
    return result;
  }

  TripleLikeReq._();

  factory TripleLikeReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TripleLikeReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TripleLikeReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOM<PlayItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PlayItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TripleLikeReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TripleLikeReq copyWith(void Function(TripleLikeReq) updates) =>
      super.copyWith((message) => updates(message as TripleLikeReq))
          as TripleLikeReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TripleLikeReq create() => TripleLikeReq._();
  @$core.override
  TripleLikeReq createEmptyInstance() => create();
  static $pb.PbList<TripleLikeReq> createRepeated() =>
      $pb.PbList<TripleLikeReq>();
  @$core.pragma('dart2js:noInline')
  static TripleLikeReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TripleLikeReq>(create);
  static TripleLikeReq? _defaultInstance;

  @$pb.TagNumber(1)
  PlayItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PlayItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PlayItem ensureItem() => $_ensure(0);
}

class TripleLikeResp extends $pb.GeneratedMessage {
  factory TripleLikeResp({
    $core.String? message,
    $core.bool? thumbOk,
    $core.bool? coinOk,
    $core.bool? favOk,
  }) {
    final result = create();
    if (message != null) result.message = message;
    if (thumbOk != null) result.thumbOk = thumbOk;
    if (coinOk != null) result.coinOk = coinOk;
    if (favOk != null) result.favOk = favOk;
    return result;
  }

  TripleLikeResp._();

  factory TripleLikeResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TripleLikeResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TripleLikeResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.listener.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..aOB(2, _omitFieldNames ? '' : 'thumbOk')
    ..aOB(3, _omitFieldNames ? '' : 'coinOk')
    ..aOB(4, _omitFieldNames ? '' : 'favOk')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TripleLikeResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TripleLikeResp copyWith(void Function(TripleLikeResp) updates) =>
      super.copyWith((message) => updates(message as TripleLikeResp))
          as TripleLikeResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TripleLikeResp create() => TripleLikeResp._();
  @$core.override
  TripleLikeResp createEmptyInstance() => create();
  static $pb.PbList<TripleLikeResp> createRepeated() =>
      $pb.PbList<TripleLikeResp>();
  @$core.pragma('dart2js:noInline')
  static TripleLikeResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TripleLikeResp>(create);
  static TripleLikeResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get thumbOk => $_getBF(1);
  @$pb.TagNumber(2)
  set thumbOk($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThumbOk() => $_has(1);
  @$pb.TagNumber(2)
  void clearThumbOk() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get coinOk => $_getBF(2);
  @$pb.TagNumber(3)
  set coinOk($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCoinOk() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoinOk() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get favOk => $_getBF(3);
  @$pb.TagNumber(4)
  set favOk($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFavOk() => $_has(3);
  @$pb.TagNumber(4)
  void clearFavOk() => $_clearField(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
