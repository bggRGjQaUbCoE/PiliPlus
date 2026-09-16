// This is a generated file - do not edit.
//
// Generated from bilibili/vas/garb/service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../metadata/device.pb.dart' as $1;
import 'model.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class SailingEquipMultiReply extends $pb.GeneratedMessage {
  factory SailingEquipMultiReply({
    $core.Iterable<$core.MapEntry<$fixnum.Int64, $0.UserSailing>>? data,
  }) {
    final result = SailingEquipMultiReply._();
    if (data != null) result.data.addEntries(data);
    return result;
  }

  SailingEquipMultiReply._();

  factory SailingEquipMultiReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SailingEquipMultiReply()..mergeFromBuffer(data, registry);
  factory SailingEquipMultiReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SailingEquipMultiReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SailingEquipMultiReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.vas.garb.service'),
      createEmptyInstance: SailingEquipMultiReply.$_createMessage)
    ..m<$fixnum.Int64, $0.UserSailing>(1, _omitFieldNames ? '' : 'data',
        entryClassName: 'SailingEquipMultiReply.DataEntry',
        keyFieldType: $pb.PbFieldType.O6,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: $0.UserSailing.$_createMessage,
        valueDefaultOrMaker: $0.UserSailing.getDefault,
        packageName: const $pb.PackageName('bilibili.vas.garb.service'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SailingEquipMultiReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SailingEquipMultiReply copyWith(
          void Function(SailingEquipMultiReply) updates) =>
      super.copyWith((message) => updates(message as SailingEquipMultiReply))
          as SailingEquipMultiReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SailingEquipMultiReply() / SailingEquipMultiReply.new instead')
  static SailingEquipMultiReply create() => SailingEquipMultiReply._();
  static $pb.GeneratedMessage $_createMessage() => SailingEquipMultiReply._();
  @$core.override
  SailingEquipMultiReply createEmptyInstance() => SailingEquipMultiReply._();
  @$core.pragma('dart2js:noInline')
  static SailingEquipMultiReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SailingEquipMultiReply>(
          SailingEquipMultiReply.$_createMessage);
  static SailingEquipMultiReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$fixnum.Int64, $0.UserSailing> get data => $_getMap(0);
}

class SailingEquipMultiReq extends $pb.GeneratedMessage {
  factory SailingEquipMultiReq({
    $core.Iterable<$fixnum.Int64>? mids,
    $fixnum.Int64? upMid,
    $fixnum.Int64? otype,
    $fixnum.Int64? oid,
    $fixnum.Int64? mid,
    $1.Device? device,
  }) {
    final result = SailingEquipMultiReq._();
    if (mids != null) result.mids.addAll(mids);
    if (upMid != null) result.upMid = upMid;
    if (otype != null) result.otype = otype;
    if (oid != null) result.oid = oid;
    if (mid != null) result.mid = mid;
    if (device != null) result.device = device;
    return result;
  }

  SailingEquipMultiReq._();

  factory SailingEquipMultiReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SailingEquipMultiReq()..mergeFromBuffer(data, registry);
  factory SailingEquipMultiReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SailingEquipMultiReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SailingEquipMultiReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.vas.garb.service'),
      createEmptyInstance: SailingEquipMultiReq.$_createMessage)
    ..p<$fixnum.Int64>(1, _omitFieldNames ? '' : 'mids', $pb.PbFieldType.K6)
    ..aInt64(2, _omitFieldNames ? '' : 'upMid')
    ..aInt64(3, _omitFieldNames ? '' : 'otype')
    ..aInt64(4, _omitFieldNames ? '' : 'oid')
    ..aInt64(5, _omitFieldNames ? '' : 'mid')
    ..aOM<$1.Device>(6, _omitFieldNames ? '' : 'device',
        subBuilder: $1.Device.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SailingEquipMultiReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SailingEquipMultiReq copyWith(void Function(SailingEquipMultiReq) updates) =>
      super.copyWith((message) => updates(message as SailingEquipMultiReq))
          as SailingEquipMultiReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SailingEquipMultiReq() / SailingEquipMultiReq.new instead')
  static SailingEquipMultiReq create() => SailingEquipMultiReq._();
  static $pb.GeneratedMessage $_createMessage() => SailingEquipMultiReq._();
  @$core.override
  SailingEquipMultiReq createEmptyInstance() => SailingEquipMultiReq._();
  @$core.pragma('dart2js:noInline')
  static SailingEquipMultiReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SailingEquipMultiReq>(
          SailingEquipMultiReq.$_createMessage);
  static SailingEquipMultiReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$fixnum.Int64> get mids => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get upMid => $_getI64(1);
  @$pb.TagNumber(2)
  set upMid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUpMid() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpMid() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get otype => $_getI64(2);
  @$pb.TagNumber(3)
  set otype($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOtype() => $_has(2);
  @$pb.TagNumber(3)
  void clearOtype() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get oid => $_getI64(3);
  @$pb.TagNumber(4)
  set oid($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOid() => $_has(3);
  @$pb.TagNumber(4)
  void clearOid() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get mid => $_getI64(4);
  @$pb.TagNumber(5)
  set mid($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMid() => $_has(4);
  @$pb.TagNumber(5)
  void clearMid() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.Device get device => $_getN(5);
  @$pb.TagNumber(6)
  set device($1.Device value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasDevice() => $_has(5);
  @$pb.TagNumber(6)
  void clearDevice() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Device ensureDevice() => $_ensure(5);
}

class UserCard extends $pb.GeneratedMessage {
  factory UserCard({
    $fixnum.Int64? id,
    $fixnum.Int64? itemId,
    $core.String? name,
    $core.String? cardUrl,
    $core.String? bigCardUrl,
    $fixnum.Int64? cardType,
    $fixnum.Int64? expireTime,
    $core.String? cardTypeName,
    $core.String? jumpUrl,
    $0.UserFanShow? fan,
    $core.String? imageEnhance,
    $0.ImageGroup? imageGroup,
  }) {
    final result = UserCard._();
    if (id != null) result.id = id;
    if (itemId != null) result.itemId = itemId;
    if (name != null) result.name = name;
    if (cardUrl != null) result.cardUrl = cardUrl;
    if (bigCardUrl != null) result.bigCardUrl = bigCardUrl;
    if (cardType != null) result.cardType = cardType;
    if (expireTime != null) result.expireTime = expireTime;
    if (cardTypeName != null) result.cardTypeName = cardTypeName;
    if (jumpUrl != null) result.jumpUrl = jumpUrl;
    if (fan != null) result.fan = fan;
    if (imageEnhance != null) result.imageEnhance = imageEnhance;
    if (imageGroup != null) result.imageGroup = imageGroup;
    return result;
  }

  UserCard._();

  factory UserCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserCard()..mergeFromBuffer(data, registry);
  factory UserCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.vas.garb.service'),
      createEmptyInstance: UserCard.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aInt64(2, _omitFieldNames ? '' : 'itemId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'cardUrl')
    ..aOS(5, _omitFieldNames ? '' : 'bigCardUrl')
    ..aInt64(6, _omitFieldNames ? '' : 'cardType')
    ..aInt64(7, _omitFieldNames ? '' : 'expireTime')
    ..aOS(8, _omitFieldNames ? '' : 'cardTypeName')
    ..aOS(9, _omitFieldNames ? '' : 'jumpUrl')
    ..aOM<$0.UserFanShow>(10, _omitFieldNames ? '' : 'fan',
        subBuilder: $0.UserFanShow.$_createMessage)
    ..aOS(12, _omitFieldNames ? '' : 'imageEnhance')
    ..aOM<$0.ImageGroup>(13, _omitFieldNames ? '' : 'imageGroup',
        subBuilder: $0.ImageGroup.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCard copyWith(void Function(UserCard) updates) =>
      super.copyWith((message) => updates(message as UserCard)) as UserCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UserCard() / UserCard.new instead')
  static UserCard create() => UserCard._();
  static $pb.GeneratedMessage $_createMessage() => UserCard._();
  @$core.override
  UserCard createEmptyInstance() => UserCard._();
  @$core.pragma('dart2js:noInline')
  static UserCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserCard>(UserCard.$_createMessage);
  static UserCard? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get itemId => $_getI64(1);
  @$pb.TagNumber(2)
  set itemId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get cardUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set cardUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCardUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearCardUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get bigCardUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set bigCardUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBigCardUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearBigCardUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get cardType => $_getI64(5);
  @$pb.TagNumber(6)
  set cardType($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCardType() => $_has(5);
  @$pb.TagNumber(6)
  void clearCardType() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get expireTime => $_getI64(6);
  @$pb.TagNumber(7)
  set expireTime($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasExpireTime() => $_has(6);
  @$pb.TagNumber(7)
  void clearExpireTime() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get cardTypeName => $_getSZ(7);
  @$pb.TagNumber(8)
  set cardTypeName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCardTypeName() => $_has(7);
  @$pb.TagNumber(8)
  void clearCardTypeName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get jumpUrl => $_getSZ(8);
  @$pb.TagNumber(9)
  set jumpUrl($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasJumpUrl() => $_has(8);
  @$pb.TagNumber(9)
  void clearJumpUrl() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.UserFanShow get fan => $_getN(9);
  @$pb.TagNumber(10)
  set fan($0.UserFanShow value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasFan() => $_has(9);
  @$pb.TagNumber(10)
  void clearFan() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.UserFanShow ensureFan() => $_ensure(9);

  @$pb.TagNumber(12)
  $core.String get imageEnhance => $_getSZ(10);
  @$pb.TagNumber(12)
  set imageEnhance($core.String value) => $_setString(10, value);
  @$pb.TagNumber(12)
  $core.bool hasImageEnhance() => $_has(10);
  @$pb.TagNumber(12)
  void clearImageEnhance() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.ImageGroup get imageGroup => $_getN(11);
  @$pb.TagNumber(13)
  set imageGroup($0.ImageGroup value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasImageGroup() => $_has(11);
  @$pb.TagNumber(13)
  void clearImageGroup() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.ImageGroup ensureImageGroup() => $_ensure(11);
}

class UserCardMultiReply extends $pb.GeneratedMessage {
  factory UserCardMultiReply({
    $core.Iterable<$core.MapEntry<$fixnum.Int64, UserCard>>? cards,
  }) {
    final result = UserCardMultiReply._();
    if (cards != null) result.cards.addEntries(cards);
    return result;
  }

  UserCardMultiReply._();

  factory UserCardMultiReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserCardMultiReply()..mergeFromBuffer(data, registry);
  factory UserCardMultiReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserCardMultiReply()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserCardMultiReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.vas.garb.service'),
      createEmptyInstance: UserCardMultiReply.$_createMessage)
    ..m<$fixnum.Int64, UserCard>(1, _omitFieldNames ? '' : 'cards',
        entryClassName: 'UserCardMultiReply.CardsEntry',
        keyFieldType: $pb.PbFieldType.O6,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: UserCard.$_createMessage,
        valueDefaultOrMaker: UserCard.getDefault,
        packageName: const $pb.PackageName('bilibili.vas.garb.service'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCardMultiReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCardMultiReply copyWith(void Function(UserCardMultiReply) updates) =>
      super.copyWith((message) => updates(message as UserCardMultiReply))
          as UserCardMultiReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UserCardMultiReply() / UserCardMultiReply.new instead')
  static UserCardMultiReply create() => UserCardMultiReply._();
  static $pb.GeneratedMessage $_createMessage() => UserCardMultiReply._();
  @$core.override
  UserCardMultiReply createEmptyInstance() => UserCardMultiReply._();
  @$core.pragma('dart2js:noInline')
  static UserCardMultiReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserCardMultiReply>(
          UserCardMultiReply.$_createMessage);
  static UserCardMultiReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$fixnum.Int64, UserCard> get cards => $_getMap(0);
}

class UserCardMultiReq extends $pb.GeneratedMessage {
  factory UserCardMultiReq({
    $core.Iterable<$fixnum.Int64>? mids,
    $1.Device? device,
  }) {
    final result = UserCardMultiReq._();
    if (mids != null) result.mids.addAll(mids);
    if (device != null) result.device = device;
    return result;
  }

  UserCardMultiReq._();

  factory UserCardMultiReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserCardMultiReq()..mergeFromBuffer(data, registry);
  factory UserCardMultiReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserCardMultiReq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserCardMultiReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.vas.garb.service'),
      createEmptyInstance: UserCardMultiReq.$_createMessage)
    ..p<$fixnum.Int64>(1, _omitFieldNames ? '' : 'mids', $pb.PbFieldType.K6)
    ..aOM<$1.Device>(2, _omitFieldNames ? '' : 'device',
        subBuilder: $1.Device.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCardMultiReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCardMultiReq copyWith(void Function(UserCardMultiReq) updates) =>
      super.copyWith((message) => updates(message as UserCardMultiReq))
          as UserCardMultiReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UserCardMultiReq() / UserCardMultiReq.new instead')
  static UserCardMultiReq create() => UserCardMultiReq._();
  static $pb.GeneratedMessage $_createMessage() => UserCardMultiReq._();
  @$core.override
  UserCardMultiReq createEmptyInstance() => UserCardMultiReq._();
  @$core.pragma('dart2js:noInline')
  static UserCardMultiReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserCardMultiReq>(
          UserCardMultiReq.$_createMessage);
  static UserCardMultiReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$fixnum.Int64> get mids => $_getList(0);

  @$pb.TagNumber(2)
  $1.Device get device => $_getN(1);
  @$pb.TagNumber(2)
  set device($1.Device value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDevice() => $_has(1);
  @$pb.TagNumber(2)
  void clearDevice() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Device ensureDevice() => $_ensure(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
