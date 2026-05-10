// This is a generated file - do not edit.
//
// Generated from bilibili/app/listener/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../pagination.pb.dart' as $2;
import '../archive/middleware/v1.pb.dart' as $1;
import 'v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'v1.pbenum.dart';

class Author extends $pb.GeneratedMessage {
  factory Author({
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

class BKArchive extends $pb.GeneratedMessage {
  factory BKArchive({
    $fixnum.Int64? oid,
    $core.String? title,
    $core.String? cover,
    $core.String? desc,
    $fixnum.Int64? duration,
    $core.int? rid,
    $fixnum.Int64? publish,
    $core.String? displayedOid,
    $core.int? copyright,
  }) {
    final result = create();
    if (oid != null) result.oid = oid;
    if (title != null) result.title = title;
    if (cover != null) result.cover = cover;
    if (desc != null) result.desc = desc;
    if (duration != null) result.duration = duration;
    if (rid != null) result.rid = rid;
    if (publish != null) result.publish = publish;
    if (displayedOid != null) result.displayedOid = displayedOid;
    if (copyright != null) result.copyright = copyright;
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
    ..aInt64(8, _omitFieldNames ? '' : 'publish')
    ..aOS(9, _omitFieldNames ? '' : 'displayedOid')
    ..aI(10, _omitFieldNames ? '' : 'copyright')
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

  @$pb.TagNumber(8)
  $fixnum.Int64 get publish => $_getI64(6);
  @$pb.TagNumber(8)
  set publish($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(8)
  $core.bool hasPublish() => $_has(6);
  @$pb.TagNumber(8)
  void clearPublish() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get displayedOid => $_getSZ(7);
  @$pb.TagNumber(9)
  set displayedOid($core.String value) => $_setString(7, value);
  @$pb.TagNumber(9)
  $core.bool hasDisplayedOid() => $_has(7);
  @$pb.TagNumber(9)
  void clearDisplayedOid() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get copyright => $_getIZ(8);
  @$pb.TagNumber(10)
  set copyright($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(10)
  $core.bool hasCopyright() => $_has(8);
  @$pb.TagNumber(10)
  void clearCopyright() => $_clearField(10);
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
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (baseUrl != null) result.baseUrl = baseUrl;
    if (backupUrl != null) result.backupUrl.addAll(backupUrl);
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
    PlayItem? associatedItem,
    $fixnum.Int64? lastPlayTime,
  }) {
    final result = create();
    if (item != null) result.item = item;
    if (arc != null) result.arc = arc;
    if (parts != null) result.parts.addAll(parts);
    if (owner != null) result.owner = owner;
    if (stat != null) result.stat = stat;
    if (lastPart != null) result.lastPart = lastPart;
    if (progress != null) result.progress = progress;
    if (associatedItem != null) result.associatedItem = associatedItem;
    if (lastPlayTime != null) result.lastPlayTime = lastPlayTime;
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
    ..aOM<PlayItem>(11, _omitFieldNames ? '' : 'associatedItem',
        subBuilder: PlayItem.create)
    ..aInt64(12, _omitFieldNames ? '' : 'lastPlayTime')
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

  @$pb.TagNumber(11)
  PlayItem get associatedItem => $_getN(7);
  @$pb.TagNumber(11)
  set associatedItem(PlayItem value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasAssociatedItem() => $_has(7);
  @$pb.TagNumber(11)
  void clearAssociatedItem() => $_clearField(11);
  @$pb.TagNumber(11)
  PlayItem ensureAssociatedItem() => $_ensure(7);

  @$pb.TagNumber(12)
  $fixnum.Int64 get lastPlayTime => $_getI64(8);
  @$pb.TagNumber(12)
  set lastPlayTime($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(12)
  $core.bool hasLastPlayTime() => $_has(8);
  @$pb.TagNumber(12)
  void clearLastPlayTime() => $_clearField(12);
}

class PlayDASH extends $pb.GeneratedMessage {
  factory PlayDASH({
    $core.Iterable<DashItem>? audio,
  }) {
    final result = create();
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
  @$core.pragma('dart2js:noInline')
  static PlayDASH getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayDASH>(create);
  static PlayDASH? _defaultInstance;

  @$pb.TagNumber(3)
  $pb.PbList<DashItem> get audio => $_getList(0);
}

enum PlayInfo_Info { playUrl, playDash, notSet }

class PlayInfo extends $pb.GeneratedMessage {
  factory PlayInfo({
    PlayURL? playUrl,
    PlayDASH? playDash,
  }) {
    final result = create();
    if (playUrl != null) result.playUrl = playUrl;
    if (playDash != null) result.playDash = playDash;
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
    ..aOM<PlayURL>(4, _omitFieldNames ? '' : 'playUrl',
        subBuilder: PlayURL.create)
    ..aOM<PlayDASH>(5, _omitFieldNames ? '' : 'playDash',
        subBuilder: PlayDASH.create)
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

  @$pb.TagNumber(4)
  PlayURL get playUrl => $_getN(0);
  @$pb.TagNumber(4)
  set playUrl(PlayURL value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPlayUrl() => $_has(0);
  @$pb.TagNumber(4)
  void clearPlayUrl() => $_clearField(4);
  @$pb.TagNumber(4)
  PlayURL ensurePlayUrl() => $_ensure(0);

  @$pb.TagNumber(5)
  PlayDASH get playDash => $_getN(1);
  @$pb.TagNumber(5)
  set playDash(PlayDASH value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPlayDash() => $_has(1);
  @$pb.TagNumber(5)
  void clearPlayDash() => $_clearField(5);
  @$pb.TagNumber(5)
  PlayDASH ensurePlayDash() => $_ensure(1);
}

class PlayItem extends $pb.GeneratedMessage {
  factory PlayItem({
    $core.int? itemType,
    $fixnum.Int64? oid,
    $core.Iterable<$fixnum.Int64>? subId,
    $fixnum.Int64? pos,
  }) {
    final result = create();
    if (itemType != null) result.itemType = itemType;
    if (oid != null) result.oid = oid;
    if (subId != null) result.subId.addAll(subId);
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

  @$pb.TagNumber(6)
  $fixnum.Int64 get pos => $_getI64(3);
  @$pb.TagNumber(6)
  set pos($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(6)
  $core.bool hasPos() => $_has(3);
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
    $1.PlayerArgs? playerArgs,
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
    ..aOM<$1.PlayerArgs>(2, _omitFieldNames ? '' : 'playerArgs',
        subBuilder: $1.PlayerArgs.create)
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
  $1.PlayerArgs get playerArgs => $_getN(1);
  @$pb.TagNumber(2)
  set playerArgs($1.PlayerArgs value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlayerArgs() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayerArgs() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PlayerArgs ensurePlayerArgs() => $_ensure(1);
}

class PlayURLResp extends $pb.GeneratedMessage {
  factory PlayURLResp({
    PlayItem? item,
    $core.String? message,
    $core.Iterable<$core.MapEntry<$fixnum.Int64, PlayInfo>>? playerInfo,
  }) {
    final result = create();
    if (item != null) result.item = item;
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

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbMap<$fixnum.Int64, PlayInfo> get playerInfo => $_getMap(2);
}

class PlaylistReq extends $pb.GeneratedMessage {
  factory PlaylistReq({
    PlaylistSource? from,
    $fixnum.Int64? id,
    PlayItem? anchor,
    $1.PlayerArgs? playerArgs,
    $fixnum.Int64? extraId,
    SortOption? sortOpt,
    $2.Pagination? pagination,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (id != null) result.id = id;
    if (anchor != null) result.anchor = anchor;
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
    ..aOM<$1.PlayerArgs>(5, _omitFieldNames ? '' : 'playerArgs',
        subBuilder: $1.PlayerArgs.create)
    ..aInt64(6, _omitFieldNames ? '' : 'extraId')
    ..aOM<SortOption>(7, _omitFieldNames ? '' : 'sortOpt',
        subBuilder: SortOption.create)
    ..aOM<$2.Pagination>(8, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.create)
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

  @$pb.TagNumber(5)
  $1.PlayerArgs get playerArgs => $_getN(3);
  @$pb.TagNumber(5)
  set playerArgs($1.PlayerArgs value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPlayerArgs() => $_has(3);
  @$pb.TagNumber(5)
  void clearPlayerArgs() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.PlayerArgs ensurePlayerArgs() => $_ensure(3);

  @$pb.TagNumber(6)
  $fixnum.Int64 get extraId => $_getI64(4);
  @$pb.TagNumber(6)
  set extraId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(6)
  $core.bool hasExtraId() => $_has(4);
  @$pb.TagNumber(6)
  void clearExtraId() => $_clearField(6);

  @$pb.TagNumber(7)
  SortOption get sortOpt => $_getN(5);
  @$pb.TagNumber(7)
  set sortOpt(SortOption value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSortOpt() => $_has(5);
  @$pb.TagNumber(7)
  void clearSortOpt() => $_clearField(7);
  @$pb.TagNumber(7)
  SortOption ensureSortOpt() => $_ensure(5);

  @$pb.TagNumber(8)
  $2.Pagination get pagination => $_getN(6);
  @$pb.TagNumber(8)
  set pagination($2.Pagination value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPagination() => $_has(6);
  @$pb.TagNumber(8)
  void clearPagination() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Pagination ensurePagination() => $_ensure(6);
}

class PlaylistResp extends $pb.GeneratedMessage {
  factory PlaylistResp({
    $core.int? total,
    $core.bool? reachStart,
    $core.bool? reachEnd,
    $core.Iterable<DetailItem>? list,
    PlayItem? lastPlay,
    $fixnum.Int64? lastProgress,
    $2.PaginationReply? paginationReply,
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
    ..aOM<$2.PaginationReply>(7, _omitFieldNames ? '' : 'paginationReply',
        subBuilder: $2.PaginationReply.create)
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
  $2.PaginationReply get paginationReply => $_getN(6);
  @$pb.TagNumber(7)
  set paginationReply($2.PaginationReply value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPaginationReply() => $_has(6);
  @$pb.TagNumber(7)
  void clearPaginationReply() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.PaginationReply ensurePaginationReply() => $_ensure(6);
}

class ResponseUrl extends $pb.GeneratedMessage {
  factory ResponseUrl({
    $core.String? url,
    $core.Iterable<$core.String>? backupUrl,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (backupUrl != null) result.backupUrl.addAll(backupUrl);
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
    ..aOS(6, _omitFieldNames ? '' : 'url')
    ..pPS(7, _omitFieldNames ? '' : 'backupUrl')
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
  @$core.pragma('dart2js:noInline')
  static ResponseUrl getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResponseUrl>(create);
  static ResponseUrl? _defaultInstance;

  @$pb.TagNumber(6)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(6)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(6)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(6)
  void clearUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get backupUrl => $_getList(1);
}

class SortOption extends $pb.GeneratedMessage {
  factory SortOption({
    ListOrder? order,
    ListSortField? sortField,
  }) {
    final result = create();
    if (order != null) result.order = order;
    if (sortField != null) result.sortField = sortField;
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
