// This is a generated file - do not edit.
//
// Generated from bilibili/app/viewunite/pgcanymodel.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Earphone extends $pb.GeneratedMessage {
  factory Earphone({
    $core.String? productModel,
    $core.String? likeToastText,
    $core.String? switchToastText,
    $core.String? likeToastVoice,
  }) {
    final result = Earphone._();
    if (productModel != null) result.productModel = productModel;
    if (likeToastText != null) result.likeToastText = likeToastText;
    if (switchToastText != null) result.switchToastText = switchToastText;
    if (likeToastVoice != null) result.likeToastVoice = likeToastVoice;
    return result;
  }

  Earphone._();

  factory Earphone.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Earphone()..mergeFromBuffer(data, registry);
  factory Earphone.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Earphone()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Earphone',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.pgcanymodel'),
      createEmptyInstance: Earphone.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'productModel')
    ..aOS(2, _omitFieldNames ? '' : 'likeToastText')
    ..aOS(3, _omitFieldNames ? '' : 'switchToastText')
    ..aOS(4, _omitFieldNames ? '' : 'likeToastVoice')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Earphone clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Earphone copyWith(void Function(Earphone) updates) =>
      super.copyWith((message) => updates(message as Earphone)) as Earphone;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Earphone() / Earphone.new instead')
  static Earphone create() => Earphone._();
  static $pb.GeneratedMessage $_createMessage() => Earphone._();
  @$core.override
  Earphone createEmptyInstance() => Earphone._();
  @$core.pragma('dart2js:noInline')
  static Earphone getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Earphone>(Earphone.$_createMessage);
  static Earphone? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get productModel => $_getSZ(0);
  @$pb.TagNumber(1)
  set productModel($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProductModel() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductModel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get likeToastText => $_getSZ(1);
  @$pb.TagNumber(2)
  set likeToastText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLikeToastText() => $_has(1);
  @$pb.TagNumber(2)
  void clearLikeToastText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get switchToastText => $_getSZ(2);
  @$pb.TagNumber(3)
  set switchToastText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSwitchToastText() => $_has(2);
  @$pb.TagNumber(3)
  void clearSwitchToastText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get likeToastVoice => $_getSZ(3);
  @$pb.TagNumber(4)
  set likeToastVoice($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLikeToastVoice() => $_has(3);
  @$pb.TagNumber(4)
  void clearLikeToastVoice() => $_clearField(4);
}

class EarphoneConf extends $pb.GeneratedMessage {
  factory EarphoneConf({
    $core.Iterable<Earphone>? spPhones,
  }) {
    final result = EarphoneConf._();
    if (spPhones != null) result.spPhones.addAll(spPhones);
    return result;
  }

  EarphoneConf._();

  factory EarphoneConf.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EarphoneConf()..mergeFromBuffer(data, registry);
  factory EarphoneConf.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EarphoneConf()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EarphoneConf',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.pgcanymodel'),
      createEmptyInstance: EarphoneConf.$_createMessage)
    ..pPM<Earphone>(1, _omitFieldNames ? '' : 'spPhones',
        subBuilder: Earphone.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EarphoneConf clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EarphoneConf copyWith(void Function(EarphoneConf) updates) =>
      super.copyWith((message) => updates(message as EarphoneConf))
          as EarphoneConf;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use EarphoneConf() / EarphoneConf.new instead')
  static EarphoneConf create() => EarphoneConf._();
  static $pb.GeneratedMessage $_createMessage() => EarphoneConf._();
  @$core.override
  EarphoneConf createEmptyInstance() => EarphoneConf._();
  @$core.pragma('dart2js:noInline')
  static EarphoneConf getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EarphoneConf>(
          EarphoneConf.$_createMessage);
  static EarphoneConf? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Earphone> get spPhones => $_getList(0);
}

class MultiViewInfo extends $pb.GeneratedMessage {
  factory MultiViewInfo({
    $core.bool? isMultiViewSeason,
    $core.String? changingDance,
  }) {
    final result = MultiViewInfo._();
    if (isMultiViewSeason != null) result.isMultiViewSeason = isMultiViewSeason;
    if (changingDance != null) result.changingDance = changingDance;
    return result;
  }

  MultiViewInfo._();

  factory MultiViewInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MultiViewInfo()..mergeFromBuffer(data, registry);
  factory MultiViewInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MultiViewInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MultiViewInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.pgcanymodel'),
      createEmptyInstance: MultiViewInfo.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'isMultiViewSeason')
    ..aOS(2, _omitFieldNames ? '' : 'changingDance')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiViewInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiViewInfo copyWith(void Function(MultiViewInfo) updates) =>
      super.copyWith((message) => updates(message as MultiViewInfo))
          as MultiViewInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MultiViewInfo() / MultiViewInfo.new instead')
  static MultiViewInfo create() => MultiViewInfo._();
  static $pb.GeneratedMessage $_createMessage() => MultiViewInfo._();
  @$core.override
  MultiViewInfo createEmptyInstance() => MultiViewInfo._();
  @$core.pragma('dart2js:noInline')
  static MultiViewInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MultiViewInfo>(
          MultiViewInfo.$_createMessage);
  static MultiViewInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isMultiViewSeason => $_getBF(0);
  @$pb.TagNumber(1)
  set isMultiViewSeason($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsMultiViewSeason() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsMultiViewSeason() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get changingDance => $_getSZ(1);
  @$pb.TagNumber(2)
  set changingDance($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChangingDance() => $_has(1);
  @$pb.TagNumber(2)
  void clearChangingDance() => $_clearField(2);
}

class OgvData extends $pb.GeneratedMessage {
  factory OgvData({
    $core.int? mediaId,
    $fixnum.Int64? seasonId,
    $core.int? seasonType,
    $core.int? showSeasonType,
    Rights? rights,
    UserStatus? userStatus,
    $fixnum.Int64? aid,
    Stat? stat,
    $core.int? mode,
    Publish? publish,
    PlayStrategy? playStrategy,
    MultiViewInfo? multiViewInfo,
    OgvSwitch? ogvSwitch,
    $core.int? totalEp,
    $0.NewEp? newEp,
    Reserve? reserve,
    $core.int? status,
    $core.Iterable<PlayFloatLayerActivity>? activityFloatLayer,
    EarphoneConf? earphoneConf,
    $core.String? cover,
    $core.String? squareCover,
    $core.String? shareUrl,
    $core.String? shortLink,
    $core.String? title,
    $core.String? horizontalCover169,
    $core.String? horizontalCover1610,
    $core.int? hasCanPlayEp,
    Skin? skin,
  }) {
    final result = OgvData._();
    if (mediaId != null) result.mediaId = mediaId;
    if (seasonId != null) result.seasonId = seasonId;
    if (seasonType != null) result.seasonType = seasonType;
    if (showSeasonType != null) result.showSeasonType = showSeasonType;
    if (rights != null) result.rights = rights;
    if (userStatus != null) result.userStatus = userStatus;
    if (aid != null) result.aid = aid;
    if (stat != null) result.stat = stat;
    if (mode != null) result.mode = mode;
    if (publish != null) result.publish = publish;
    if (playStrategy != null) result.playStrategy = playStrategy;
    if (multiViewInfo != null) result.multiViewInfo = multiViewInfo;
    if (ogvSwitch != null) result.ogvSwitch = ogvSwitch;
    if (totalEp != null) result.totalEp = totalEp;
    if (newEp != null) result.newEp = newEp;
    if (reserve != null) result.reserve = reserve;
    if (status != null) result.status = status;
    if (activityFloatLayer != null)
      result.activityFloatLayer.addAll(activityFloatLayer);
    if (earphoneConf != null) result.earphoneConf = earphoneConf;
    if (cover != null) result.cover = cover;
    if (squareCover != null) result.squareCover = squareCover;
    if (shareUrl != null) result.shareUrl = shareUrl;
    if (shortLink != null) result.shortLink = shortLink;
    if (title != null) result.title = title;
    if (horizontalCover169 != null)
      result.horizontalCover169 = horizontalCover169;
    if (horizontalCover1610 != null)
      result.horizontalCover1610 = horizontalCover1610;
    if (hasCanPlayEp != null) result.hasCanPlayEp = hasCanPlayEp;
    if (skin != null) result.skin = skin;
    return result;
  }

  OgvData._();

  factory OgvData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OgvData()..mergeFromBuffer(data, registry);
  factory OgvData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OgvData()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OgvData',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.pgcanymodel'),
      createEmptyInstance: OgvData.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'mediaId')
    ..aInt64(2, _omitFieldNames ? '' : 'seasonId')
    ..aI(3, _omitFieldNames ? '' : 'seasonType')
    ..aI(4, _omitFieldNames ? '' : 'showSeasonType')
    ..aOM<Rights>(5, _omitFieldNames ? '' : 'rights',
        subBuilder: Rights.$_createMessage)
    ..aOM<UserStatus>(6, _omitFieldNames ? '' : 'userStatus',
        subBuilder: UserStatus.$_createMessage)
    ..aInt64(7, _omitFieldNames ? '' : 'aid')
    ..aOM<Stat>(8, _omitFieldNames ? '' : 'stat',
        subBuilder: Stat.$_createMessage)
    ..aI(9, _omitFieldNames ? '' : 'mode')
    ..aOM<Publish>(10, _omitFieldNames ? '' : 'publish',
        subBuilder: Publish.$_createMessage)
    ..aOM<PlayStrategy>(11, _omitFieldNames ? '' : 'playStrategy',
        subBuilder: PlayStrategy.$_createMessage)
    ..aOM<MultiViewInfo>(12, _omitFieldNames ? '' : 'multiViewInfo',
        subBuilder: MultiViewInfo.$_createMessage)
    ..aOM<OgvSwitch>(13, _omitFieldNames ? '' : 'ogvSwitch',
        subBuilder: OgvSwitch.$_createMessage)
    ..aI(14, _omitFieldNames ? '' : 'totalEp')
    ..aOM<$0.NewEp>(15, _omitFieldNames ? '' : 'newEp',
        subBuilder: $0.NewEp.$_createMessage)
    ..aOM<Reserve>(16, _omitFieldNames ? '' : 'reserve',
        subBuilder: Reserve.$_createMessage)
    ..aI(17, _omitFieldNames ? '' : 'status')
    ..pPM<PlayFloatLayerActivity>(
        18, _omitFieldNames ? '' : 'activityFloatLayer',
        subBuilder: PlayFloatLayerActivity.$_createMessage)
    ..aOM<EarphoneConf>(19, _omitFieldNames ? '' : 'earphoneConf',
        subBuilder: EarphoneConf.$_createMessage)
    ..aOS(20, _omitFieldNames ? '' : 'cover')
    ..aOS(21, _omitFieldNames ? '' : 'squareCover')
    ..aOS(22, _omitFieldNames ? '' : 'shareUrl')
    ..aOS(23, _omitFieldNames ? '' : 'shortLink')
    ..aOS(24, _omitFieldNames ? '' : 'title')
    ..aOS(25, _omitFieldNames ? '' : 'horizontalCover169')
    ..aOS(26, _omitFieldNames ? '' : 'horizontalCover1610')
    ..aI(27, _omitFieldNames ? '' : 'hasCanPlayEp')
    ..aOM<Skin>(28, _omitFieldNames ? '' : 'skin',
        subBuilder: Skin.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OgvData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OgvData copyWith(void Function(OgvData) updates) =>
      super.copyWith((message) => updates(message as OgvData)) as OgvData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OgvData() / OgvData.new instead')
  static OgvData create() => OgvData._();
  static $pb.GeneratedMessage $_createMessage() => OgvData._();
  @$core.override
  OgvData createEmptyInstance() => OgvData._();
  @$core.pragma('dart2js:noInline')
  static OgvData getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OgvData>(OgvData.$_createMessage);
  static OgvData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get mediaId => $_getIZ(0);
  @$pb.TagNumber(1)
  set mediaId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get seasonId => $_getI64(1);
  @$pb.TagNumber(2)
  set seasonId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSeasonId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeasonId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get seasonType => $_getIZ(2);
  @$pb.TagNumber(3)
  set seasonType($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSeasonType() => $_has(2);
  @$pb.TagNumber(3)
  void clearSeasonType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get showSeasonType => $_getIZ(3);
  @$pb.TagNumber(4)
  set showSeasonType($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasShowSeasonType() => $_has(3);
  @$pb.TagNumber(4)
  void clearShowSeasonType() => $_clearField(4);

  @$pb.TagNumber(5)
  Rights get rights => $_getN(4);
  @$pb.TagNumber(5)
  set rights(Rights value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRights() => $_has(4);
  @$pb.TagNumber(5)
  void clearRights() => $_clearField(5);
  @$pb.TagNumber(5)
  Rights ensureRights() => $_ensure(4);

  @$pb.TagNumber(6)
  UserStatus get userStatus => $_getN(5);
  @$pb.TagNumber(6)
  set userStatus(UserStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasUserStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearUserStatus() => $_clearField(6);
  @$pb.TagNumber(6)
  UserStatus ensureUserStatus() => $_ensure(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get aid => $_getI64(6);
  @$pb.TagNumber(7)
  set aid($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAid() => $_has(6);
  @$pb.TagNumber(7)
  void clearAid() => $_clearField(7);

  @$pb.TagNumber(8)
  Stat get stat => $_getN(7);
  @$pb.TagNumber(8)
  set stat(Stat value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStat() => $_has(7);
  @$pb.TagNumber(8)
  void clearStat() => $_clearField(8);
  @$pb.TagNumber(8)
  Stat ensureStat() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.int get mode => $_getIZ(8);
  @$pb.TagNumber(9)
  set mode($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMode() => $_has(8);
  @$pb.TagNumber(9)
  void clearMode() => $_clearField(9);

  @$pb.TagNumber(10)
  Publish get publish => $_getN(9);
  @$pb.TagNumber(10)
  set publish(Publish value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasPublish() => $_has(9);
  @$pb.TagNumber(10)
  void clearPublish() => $_clearField(10);
  @$pb.TagNumber(10)
  Publish ensurePublish() => $_ensure(9);

  @$pb.TagNumber(11)
  PlayStrategy get playStrategy => $_getN(10);
  @$pb.TagNumber(11)
  set playStrategy(PlayStrategy value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasPlayStrategy() => $_has(10);
  @$pb.TagNumber(11)
  void clearPlayStrategy() => $_clearField(11);
  @$pb.TagNumber(11)
  PlayStrategy ensurePlayStrategy() => $_ensure(10);

  @$pb.TagNumber(12)
  MultiViewInfo get multiViewInfo => $_getN(11);
  @$pb.TagNumber(12)
  set multiViewInfo(MultiViewInfo value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasMultiViewInfo() => $_has(11);
  @$pb.TagNumber(12)
  void clearMultiViewInfo() => $_clearField(12);
  @$pb.TagNumber(12)
  MultiViewInfo ensureMultiViewInfo() => $_ensure(11);

  @$pb.TagNumber(13)
  OgvSwitch get ogvSwitch => $_getN(12);
  @$pb.TagNumber(13)
  set ogvSwitch(OgvSwitch value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasOgvSwitch() => $_has(12);
  @$pb.TagNumber(13)
  void clearOgvSwitch() => $_clearField(13);
  @$pb.TagNumber(13)
  OgvSwitch ensureOgvSwitch() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.int get totalEp => $_getIZ(13);
  @$pb.TagNumber(14)
  set totalEp($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasTotalEp() => $_has(13);
  @$pb.TagNumber(14)
  void clearTotalEp() => $_clearField(14);

  @$pb.TagNumber(15)
  $0.NewEp get newEp => $_getN(14);
  @$pb.TagNumber(15)
  set newEp($0.NewEp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasNewEp() => $_has(14);
  @$pb.TagNumber(15)
  void clearNewEp() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.NewEp ensureNewEp() => $_ensure(14);

  @$pb.TagNumber(16)
  Reserve get reserve => $_getN(15);
  @$pb.TagNumber(16)
  set reserve(Reserve value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasReserve() => $_has(15);
  @$pb.TagNumber(16)
  void clearReserve() => $_clearField(16);
  @$pb.TagNumber(16)
  Reserve ensureReserve() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.int get status => $_getIZ(16);
  @$pb.TagNumber(17)
  set status($core.int value) => $_setSignedInt32(16, value);
  @$pb.TagNumber(17)
  $core.bool hasStatus() => $_has(16);
  @$pb.TagNumber(17)
  void clearStatus() => $_clearField(17);

  @$pb.TagNumber(18)
  $pb.PbList<PlayFloatLayerActivity> get activityFloatLayer => $_getList(17);

  @$pb.TagNumber(19)
  EarphoneConf get earphoneConf => $_getN(18);
  @$pb.TagNumber(19)
  set earphoneConf(EarphoneConf value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasEarphoneConf() => $_has(18);
  @$pb.TagNumber(19)
  void clearEarphoneConf() => $_clearField(19);
  @$pb.TagNumber(19)
  EarphoneConf ensureEarphoneConf() => $_ensure(18);

  @$pb.TagNumber(20)
  $core.String get cover => $_getSZ(19);
  @$pb.TagNumber(20)
  set cover($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasCover() => $_has(19);
  @$pb.TagNumber(20)
  void clearCover() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get squareCover => $_getSZ(20);
  @$pb.TagNumber(21)
  set squareCover($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasSquareCover() => $_has(20);
  @$pb.TagNumber(21)
  void clearSquareCover() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.String get shareUrl => $_getSZ(21);
  @$pb.TagNumber(22)
  set shareUrl($core.String value) => $_setString(21, value);
  @$pb.TagNumber(22)
  $core.bool hasShareUrl() => $_has(21);
  @$pb.TagNumber(22)
  void clearShareUrl() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.String get shortLink => $_getSZ(22);
  @$pb.TagNumber(23)
  set shortLink($core.String value) => $_setString(22, value);
  @$pb.TagNumber(23)
  $core.bool hasShortLink() => $_has(22);
  @$pb.TagNumber(23)
  void clearShortLink() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.String get title => $_getSZ(23);
  @$pb.TagNumber(24)
  set title($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasTitle() => $_has(23);
  @$pb.TagNumber(24)
  void clearTitle() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.String get horizontalCover169 => $_getSZ(24);
  @$pb.TagNumber(25)
  set horizontalCover169($core.String value) => $_setString(24, value);
  @$pb.TagNumber(25)
  $core.bool hasHorizontalCover169() => $_has(24);
  @$pb.TagNumber(25)
  void clearHorizontalCover169() => $_clearField(25);

  @$pb.TagNumber(26)
  $core.String get horizontalCover1610 => $_getSZ(25);
  @$pb.TagNumber(26)
  set horizontalCover1610($core.String value) => $_setString(25, value);
  @$pb.TagNumber(26)
  $core.bool hasHorizontalCover1610() => $_has(25);
  @$pb.TagNumber(26)
  void clearHorizontalCover1610() => $_clearField(26);

  @$pb.TagNumber(27)
  $core.int get hasCanPlayEp => $_getIZ(26);
  @$pb.TagNumber(27)
  set hasCanPlayEp($core.int value) => $_setSignedInt32(26, value);
  @$pb.TagNumber(27)
  $core.bool hasHasCanPlayEp() => $_has(26);
  @$pb.TagNumber(27)
  void clearHasCanPlayEp() => $_clearField(27);

  @$pb.TagNumber(28)
  Skin get skin => $_getN(27);
  @$pb.TagNumber(28)
  set skin(Skin value) => $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasSkin() => $_has(27);
  @$pb.TagNumber(28)
  void clearSkin() => $_clearField(28);
  @$pb.TagNumber(28)
  Skin ensureSkin() => $_ensure(27);
}

class OgvSwitch extends $pb.GeneratedMessage {
  factory OgvSwitch({
    $core.int? reduceShortTitleSpacing,
    $core.int? mergePositionSectionForCinema,
    $core.int? mergePreviewSection,
    $core.int? enableShowVtInfo,
    $core.int? hideEpVvVtDm,
    $core.int? followGuide,
  }) {
    final result = OgvSwitch._();
    if (reduceShortTitleSpacing != null)
      result.reduceShortTitleSpacing = reduceShortTitleSpacing;
    if (mergePositionSectionForCinema != null)
      result.mergePositionSectionForCinema = mergePositionSectionForCinema;
    if (mergePreviewSection != null)
      result.mergePreviewSection = mergePreviewSection;
    if (enableShowVtInfo != null) result.enableShowVtInfo = enableShowVtInfo;
    if (hideEpVvVtDm != null) result.hideEpVvVtDm = hideEpVvVtDm;
    if (followGuide != null) result.followGuide = followGuide;
    return result;
  }

  OgvSwitch._();

  factory OgvSwitch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OgvSwitch()..mergeFromBuffer(data, registry);
  factory OgvSwitch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OgvSwitch()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OgvSwitch',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.pgcanymodel'),
      createEmptyInstance: OgvSwitch.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'reduceShortTitleSpacing')
    ..aI(2, _omitFieldNames ? '' : 'mergePositionSectionForCinema')
    ..aI(3, _omitFieldNames ? '' : 'mergePreviewSection')
    ..aI(4, _omitFieldNames ? '' : 'enableShowVtInfo')
    ..aI(5, _omitFieldNames ? '' : 'hideEpVvVtDm')
    ..aI(6, _omitFieldNames ? '' : 'followGuide')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OgvSwitch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OgvSwitch copyWith(void Function(OgvSwitch) updates) =>
      super.copyWith((message) => updates(message as OgvSwitch)) as OgvSwitch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OgvSwitch() / OgvSwitch.new instead')
  static OgvSwitch create() => OgvSwitch._();
  static $pb.GeneratedMessage $_createMessage() => OgvSwitch._();
  @$core.override
  OgvSwitch createEmptyInstance() => OgvSwitch._();
  @$core.pragma('dart2js:noInline')
  static OgvSwitch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OgvSwitch>(OgvSwitch.$_createMessage);
  static OgvSwitch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get reduceShortTitleSpacing => $_getIZ(0);
  @$pb.TagNumber(1)
  set reduceShortTitleSpacing($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReduceShortTitleSpacing() => $_has(0);
  @$pb.TagNumber(1)
  void clearReduceShortTitleSpacing() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get mergePositionSectionForCinema => $_getIZ(1);
  @$pb.TagNumber(2)
  set mergePositionSectionForCinema($core.int value) =>
      $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMergePositionSectionForCinema() => $_has(1);
  @$pb.TagNumber(2)
  void clearMergePositionSectionForCinema() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get mergePreviewSection => $_getIZ(2);
  @$pb.TagNumber(3)
  set mergePreviewSection($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMergePreviewSection() => $_has(2);
  @$pb.TagNumber(3)
  void clearMergePreviewSection() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get enableShowVtInfo => $_getIZ(3);
  @$pb.TagNumber(4)
  set enableShowVtInfo($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEnableShowVtInfo() => $_has(3);
  @$pb.TagNumber(4)
  void clearEnableShowVtInfo() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get hideEpVvVtDm => $_getIZ(4);
  @$pb.TagNumber(5)
  set hideEpVvVtDm($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHideEpVvVtDm() => $_has(4);
  @$pb.TagNumber(5)
  void clearHideEpVvVtDm() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get followGuide => $_getIZ(5);
  @$pb.TagNumber(6)
  set followGuide($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFollowGuide() => $_has(5);
  @$pb.TagNumber(6)
  void clearFollowGuide() => $_clearField(6);
}

class PlayFloatLayerActivity extends $pb.GeneratedMessage {
  factory PlayFloatLayerActivity({
    $core.int? id,
    $core.String? title,
    $core.int? type,
    $core.int? adBadgeType,
    $core.String? link,
    $core.String? picUrl,
    $core.String? picAnimaUrl,
    $0.BadgeInfo? badge,
    $fixnum.Int64? showRateTime,
  }) {
    final result = PlayFloatLayerActivity._();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (type != null) result.type = type;
    if (adBadgeType != null) result.adBadgeType = adBadgeType;
    if (link != null) result.link = link;
    if (picUrl != null) result.picUrl = picUrl;
    if (picAnimaUrl != null) result.picAnimaUrl = picAnimaUrl;
    if (badge != null) result.badge = badge;
    if (showRateTime != null) result.showRateTime = showRateTime;
    return result;
  }

  PlayFloatLayerActivity._();

  factory PlayFloatLayerActivity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayFloatLayerActivity()..mergeFromBuffer(data, registry);
  factory PlayFloatLayerActivity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayFloatLayerActivity()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayFloatLayerActivity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.pgcanymodel'),
      createEmptyInstance: PlayFloatLayerActivity.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aI(3, _omitFieldNames ? '' : 'type')
    ..aI(4, _omitFieldNames ? '' : 'adBadgeType')
    ..aOS(5, _omitFieldNames ? '' : 'link')
    ..aOS(6, _omitFieldNames ? '' : 'picUrl')
    ..aOS(7, _omitFieldNames ? '' : 'picAnimaUrl')
    ..aOM<$0.BadgeInfo>(8, _omitFieldNames ? '' : 'badge',
        subBuilder: $0.BadgeInfo.$_createMessage)
    ..aInt64(9, _omitFieldNames ? '' : 'showRateTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayFloatLayerActivity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayFloatLayerActivity copyWith(
          void Function(PlayFloatLayerActivity) updates) =>
      super.copyWith((message) => updates(message as PlayFloatLayerActivity))
          as PlayFloatLayerActivity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PlayFloatLayerActivity() / PlayFloatLayerActivity.new instead')
  static PlayFloatLayerActivity create() => PlayFloatLayerActivity._();
  static $pb.GeneratedMessage $_createMessage() => PlayFloatLayerActivity._();
  @$core.override
  PlayFloatLayerActivity createEmptyInstance() => PlayFloatLayerActivity._();
  @$core.pragma('dart2js:noInline')
  static PlayFloatLayerActivity getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayFloatLayerActivity>(
          PlayFloatLayerActivity.$_createMessage);
  static PlayFloatLayerActivity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
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
  $core.int get type => $_getIZ(2);
  @$pb.TagNumber(3)
  set type($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get adBadgeType => $_getIZ(3);
  @$pb.TagNumber(4)
  set adBadgeType($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAdBadgeType() => $_has(3);
  @$pb.TagNumber(4)
  void clearAdBadgeType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get link => $_getSZ(4);
  @$pb.TagNumber(5)
  set link($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLink() => $_has(4);
  @$pb.TagNumber(5)
  void clearLink() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get picUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set picUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPicUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearPicUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get picAnimaUrl => $_getSZ(6);
  @$pb.TagNumber(7)
  set picAnimaUrl($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPicAnimaUrl() => $_has(6);
  @$pb.TagNumber(7)
  void clearPicAnimaUrl() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.BadgeInfo get badge => $_getN(7);
  @$pb.TagNumber(8)
  set badge($0.BadgeInfo value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasBadge() => $_has(7);
  @$pb.TagNumber(8)
  void clearBadge() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.BadgeInfo ensureBadge() => $_ensure(7);

  @$pb.TagNumber(9)
  $fixnum.Int64 get showRateTime => $_getI64(8);
  @$pb.TagNumber(9)
  set showRateTime($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasShowRateTime() => $_has(8);
  @$pb.TagNumber(9)
  void clearShowRateTime() => $_clearField(9);
}

class PlayStrategy extends $pb.GeneratedMessage {
  factory PlayStrategy({
    $core.Iterable<$core.String>? strategies,
    $core.int? recommendShowStrategy,
    $core.String? autoPlayToast,
  }) {
    final result = PlayStrategy._();
    if (strategies != null) result.strategies.addAll(strategies);
    if (recommendShowStrategy != null)
      result.recommendShowStrategy = recommendShowStrategy;
    if (autoPlayToast != null) result.autoPlayToast = autoPlayToast;
    return result;
  }

  PlayStrategy._();

  factory PlayStrategy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayStrategy()..mergeFromBuffer(data, registry);
  factory PlayStrategy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayStrategy()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayStrategy',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.pgcanymodel'),
      createEmptyInstance: PlayStrategy.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'strategies')
    ..aI(2, _omitFieldNames ? '' : 'recommendShowStrategy')
    ..aOS(3, _omitFieldNames ? '' : 'autoPlayToast')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayStrategy clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayStrategy copyWith(void Function(PlayStrategy) updates) =>
      super.copyWith((message) => updates(message as PlayStrategy))
          as PlayStrategy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PlayStrategy() / PlayStrategy.new instead')
  static PlayStrategy create() => PlayStrategy._();
  static $pb.GeneratedMessage $_createMessage() => PlayStrategy._();
  @$core.override
  PlayStrategy createEmptyInstance() => PlayStrategy._();
  @$core.pragma('dart2js:noInline')
  static PlayStrategy getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayStrategy>(
          PlayStrategy.$_createMessage);
  static PlayStrategy? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get strategies => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get recommendShowStrategy => $_getIZ(1);
  @$pb.TagNumber(2)
  set recommendShowStrategy($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecommendShowStrategy() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecommendShowStrategy() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get autoPlayToast => $_getSZ(2);
  @$pb.TagNumber(3)
  set autoPlayToast($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAutoPlayToast() => $_has(2);
  @$pb.TagNumber(3)
  void clearAutoPlayToast() => $_clearField(3);
}

class Publish extends $pb.GeneratedMessage {
  factory Publish({
    $core.String? pubTime,
    $core.String? pubTimeShow,
    $core.int? isStarted,
    $core.int? isFinish,
    $core.int? weekday,
    $core.String? releaseDateShow,
    $core.String? timeLengthShow,
    $core.int? unknowPubDate,
    $core.String? updateInfoDesc,
  }) {
    final result = Publish._();
    if (pubTime != null) result.pubTime = pubTime;
    if (pubTimeShow != null) result.pubTimeShow = pubTimeShow;
    if (isStarted != null) result.isStarted = isStarted;
    if (isFinish != null) result.isFinish = isFinish;
    if (weekday != null) result.weekday = weekday;
    if (releaseDateShow != null) result.releaseDateShow = releaseDateShow;
    if (timeLengthShow != null) result.timeLengthShow = timeLengthShow;
    if (unknowPubDate != null) result.unknowPubDate = unknowPubDate;
    if (updateInfoDesc != null) result.updateInfoDesc = updateInfoDesc;
    return result;
  }

  Publish._();

  factory Publish.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Publish()..mergeFromBuffer(data, registry);
  factory Publish.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Publish()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Publish',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.pgcanymodel'),
      createEmptyInstance: Publish.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'pubTime')
    ..aOS(2, _omitFieldNames ? '' : 'pubTimeShow')
    ..aI(3, _omitFieldNames ? '' : 'isStarted')
    ..aI(4, _omitFieldNames ? '' : 'isFinish')
    ..aI(5, _omitFieldNames ? '' : 'weekday')
    ..aOS(6, _omitFieldNames ? '' : 'releaseDateShow')
    ..aOS(7, _omitFieldNames ? '' : 'timeLengthShow')
    ..aI(8, _omitFieldNames ? '' : 'unknowPubDate')
    ..aOS(9, _omitFieldNames ? '' : 'updateInfoDesc')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Publish clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Publish copyWith(void Function(Publish) updates) =>
      super.copyWith((message) => updates(message as Publish)) as Publish;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Publish() / Publish.new instead')
  static Publish create() => Publish._();
  static $pb.GeneratedMessage $_createMessage() => Publish._();
  @$core.override
  Publish createEmptyInstance() => Publish._();
  @$core.pragma('dart2js:noInline')
  static Publish getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Publish>(Publish.$_createMessage);
  static Publish? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pubTime => $_getSZ(0);
  @$pb.TagNumber(1)
  set pubTime($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPubTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearPubTime() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get pubTimeShow => $_getSZ(1);
  @$pb.TagNumber(2)
  set pubTimeShow($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPubTimeShow() => $_has(1);
  @$pb.TagNumber(2)
  void clearPubTimeShow() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get isStarted => $_getIZ(2);
  @$pb.TagNumber(3)
  set isStarted($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsStarted() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsStarted() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get isFinish => $_getIZ(3);
  @$pb.TagNumber(4)
  set isFinish($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsFinish() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsFinish() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get weekday => $_getIZ(4);
  @$pb.TagNumber(5)
  set weekday($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWeekday() => $_has(4);
  @$pb.TagNumber(5)
  void clearWeekday() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get releaseDateShow => $_getSZ(5);
  @$pb.TagNumber(6)
  set releaseDateShow($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReleaseDateShow() => $_has(5);
  @$pb.TagNumber(6)
  void clearReleaseDateShow() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get timeLengthShow => $_getSZ(6);
  @$pb.TagNumber(7)
  set timeLengthShow($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTimeLengthShow() => $_has(6);
  @$pb.TagNumber(7)
  void clearTimeLengthShow() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get unknowPubDate => $_getIZ(7);
  @$pb.TagNumber(8)
  set unknowPubDate($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUnknowPubDate() => $_has(7);
  @$pb.TagNumber(8)
  void clearUnknowPubDate() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get updateInfoDesc => $_getSZ(8);
  @$pb.TagNumber(9)
  set updateInfoDesc($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUpdateInfoDesc() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdateInfoDesc() => $_clearField(9);
}

class Reserve extends $pb.GeneratedMessage {
  factory Reserve({
    $core.Iterable<$0.ViewEpisode>? episodes,
    $core.String? tip,
  }) {
    final result = Reserve._();
    if (episodes != null) result.episodes.addAll(episodes);
    if (tip != null) result.tip = tip;
    return result;
  }

  Reserve._();

  factory Reserve.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Reserve()..mergeFromBuffer(data, registry);
  factory Reserve.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Reserve()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Reserve',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.pgcanymodel'),
      createEmptyInstance: Reserve.$_createMessage)
    ..pPM<$0.ViewEpisode>(1, _omitFieldNames ? '' : 'episodes',
        subBuilder: $0.ViewEpisode.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'tip')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reserve clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reserve copyWith(void Function(Reserve) updates) =>
      super.copyWith((message) => updates(message as Reserve)) as Reserve;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Reserve() / Reserve.new instead')
  static Reserve create() => Reserve._();
  static $pb.GeneratedMessage $_createMessage() => Reserve._();
  @$core.override
  Reserve createEmptyInstance() => Reserve._();
  @$core.pragma('dart2js:noInline')
  static Reserve getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Reserve>(Reserve.$_createMessage);
  static Reserve? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$0.ViewEpisode> get episodes => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get tip => $_getSZ(1);
  @$pb.TagNumber(2)
  set tip($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTip() => $_has(1);
  @$pb.TagNumber(2)
  void clearTip() => $_clearField(2);
}

class Rights extends $pb.GeneratedMessage {
  factory Rights({
    $core.int? allowDownload,
    $core.int? allowReview,
    $core.int? canWatch,
    $core.int? isCoverShow,
    $core.String? copyright,
    $core.String? copyrightName,
    $core.int? allowBp,
    $core.int? areaLimit,
    $core.int? isPreview,
    $core.int? banAreaShow,
    $core.int? watchPlatform,
    $core.int? allowBpRank,
    $core.String? resource,
    $core.int? forbidPre,
    $core.int? onlyVipDownload,
    $core.int? newAllowDownload,
  }) {
    final result = Rights._();
    if (allowDownload != null) result.allowDownload = allowDownload;
    if (allowReview != null) result.allowReview = allowReview;
    if (canWatch != null) result.canWatch = canWatch;
    if (isCoverShow != null) result.isCoverShow = isCoverShow;
    if (copyright != null) result.copyright = copyright;
    if (copyrightName != null) result.copyrightName = copyrightName;
    if (allowBp != null) result.allowBp = allowBp;
    if (areaLimit != null) result.areaLimit = areaLimit;
    if (isPreview != null) result.isPreview = isPreview;
    if (banAreaShow != null) result.banAreaShow = banAreaShow;
    if (watchPlatform != null) result.watchPlatform = watchPlatform;
    if (allowBpRank != null) result.allowBpRank = allowBpRank;
    if (resource != null) result.resource = resource;
    if (forbidPre != null) result.forbidPre = forbidPre;
    if (onlyVipDownload != null) result.onlyVipDownload = onlyVipDownload;
    if (newAllowDownload != null) result.newAllowDownload = newAllowDownload;
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
          _omitMessageNames ? '' : 'bilibili.app.viewunite.pgcanymodel'),
      createEmptyInstance: Rights.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'allowDownload')
    ..aI(2, _omitFieldNames ? '' : 'allowReview')
    ..aI(3, _omitFieldNames ? '' : 'canWatch')
    ..aI(4, _omitFieldNames ? '' : 'isCoverShow')
    ..aOS(5, _omitFieldNames ? '' : 'copyright')
    ..aOS(6, _omitFieldNames ? '' : 'copyrightName')
    ..aI(7, _omitFieldNames ? '' : 'allowBp')
    ..aI(8, _omitFieldNames ? '' : 'areaLimit')
    ..aI(9, _omitFieldNames ? '' : 'isPreview')
    ..aI(10, _omitFieldNames ? '' : 'banAreaShow')
    ..aI(11, _omitFieldNames ? '' : 'watchPlatform')
    ..aI(12, _omitFieldNames ? '' : 'allowBpRank')
    ..aOS(13, _omitFieldNames ? '' : 'resource')
    ..aI(14, _omitFieldNames ? '' : 'forbidPre')
    ..aI(15, _omitFieldNames ? '' : 'onlyVipDownload')
    ..aI(16, _omitFieldNames ? '' : 'newAllowDownload')
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
  $core.int get allowDownload => $_getIZ(0);
  @$pb.TagNumber(1)
  set allowDownload($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAllowDownload() => $_has(0);
  @$pb.TagNumber(1)
  void clearAllowDownload() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get allowReview => $_getIZ(1);
  @$pb.TagNumber(2)
  set allowReview($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAllowReview() => $_has(1);
  @$pb.TagNumber(2)
  void clearAllowReview() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get canWatch => $_getIZ(2);
  @$pb.TagNumber(3)
  set canWatch($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCanWatch() => $_has(2);
  @$pb.TagNumber(3)
  void clearCanWatch() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get isCoverShow => $_getIZ(3);
  @$pb.TagNumber(4)
  set isCoverShow($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsCoverShow() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsCoverShow() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get copyright => $_getSZ(4);
  @$pb.TagNumber(5)
  set copyright($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCopyright() => $_has(4);
  @$pb.TagNumber(5)
  void clearCopyright() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get copyrightName => $_getSZ(5);
  @$pb.TagNumber(6)
  set copyrightName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCopyrightName() => $_has(5);
  @$pb.TagNumber(6)
  void clearCopyrightName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get allowBp => $_getIZ(6);
  @$pb.TagNumber(7)
  set allowBp($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAllowBp() => $_has(6);
  @$pb.TagNumber(7)
  void clearAllowBp() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get areaLimit => $_getIZ(7);
  @$pb.TagNumber(8)
  set areaLimit($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAreaLimit() => $_has(7);
  @$pb.TagNumber(8)
  void clearAreaLimit() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get isPreview => $_getIZ(8);
  @$pb.TagNumber(9)
  set isPreview($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIsPreview() => $_has(8);
  @$pb.TagNumber(9)
  void clearIsPreview() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get banAreaShow => $_getIZ(9);
  @$pb.TagNumber(10)
  set banAreaShow($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasBanAreaShow() => $_has(9);
  @$pb.TagNumber(10)
  void clearBanAreaShow() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get watchPlatform => $_getIZ(10);
  @$pb.TagNumber(11)
  set watchPlatform($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasWatchPlatform() => $_has(10);
  @$pb.TagNumber(11)
  void clearWatchPlatform() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get allowBpRank => $_getIZ(11);
  @$pb.TagNumber(12)
  set allowBpRank($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAllowBpRank() => $_has(11);
  @$pb.TagNumber(12)
  void clearAllowBpRank() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get resource => $_getSZ(12);
  @$pb.TagNumber(13)
  set resource($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasResource() => $_has(12);
  @$pb.TagNumber(13)
  void clearResource() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get forbidPre => $_getIZ(13);
  @$pb.TagNumber(14)
  set forbidPre($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasForbidPre() => $_has(13);
  @$pb.TagNumber(14)
  void clearForbidPre() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get onlyVipDownload => $_getIZ(14);
  @$pb.TagNumber(15)
  set onlyVipDownload($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasOnlyVipDownload() => $_has(14);
  @$pb.TagNumber(15)
  void clearOnlyVipDownload() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.int get newAllowDownload => $_getIZ(15);
  @$pb.TagNumber(16)
  set newAllowDownload($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasNewAllowDownload() => $_has(15);
  @$pb.TagNumber(16)
  void clearNewAllowDownload() => $_clearField(16);
}

class Skin extends $pb.GeneratedMessage {
  factory Skin({
    $core.String? tabTextColor,
    $core.String? tabTextNightColor,
    $core.String? bgImg,
    $core.String? bgImgNight,
    $core.String? dmInputFrameBgColor,
    $core.String? dmInputFrameBgNightColor,
    $core.String? dmInputFrameColor,
    $core.String? dmInputFrameNightColor,
    $core.String? dmBtnBgColor,
    $core.String? dmBtnBgNightColor,
    $core.String? dmBtnIconColor,
    $core.String? dmBtnIconNightColor,
    $core.String? dmInputTextColor,
    $core.String? dmInputTextNightColor,
  }) {
    final result = Skin._();
    if (tabTextColor != null) result.tabTextColor = tabTextColor;
    if (tabTextNightColor != null) result.tabTextNightColor = tabTextNightColor;
    if (bgImg != null) result.bgImg = bgImg;
    if (bgImgNight != null) result.bgImgNight = bgImgNight;
    if (dmInputFrameBgColor != null)
      result.dmInputFrameBgColor = dmInputFrameBgColor;
    if (dmInputFrameBgNightColor != null)
      result.dmInputFrameBgNightColor = dmInputFrameBgNightColor;
    if (dmInputFrameColor != null) result.dmInputFrameColor = dmInputFrameColor;
    if (dmInputFrameNightColor != null)
      result.dmInputFrameNightColor = dmInputFrameNightColor;
    if (dmBtnBgColor != null) result.dmBtnBgColor = dmBtnBgColor;
    if (dmBtnBgNightColor != null) result.dmBtnBgNightColor = dmBtnBgNightColor;
    if (dmBtnIconColor != null) result.dmBtnIconColor = dmBtnIconColor;
    if (dmBtnIconNightColor != null)
      result.dmBtnIconNightColor = dmBtnIconNightColor;
    if (dmInputTextColor != null) result.dmInputTextColor = dmInputTextColor;
    if (dmInputTextNightColor != null)
      result.dmInputTextNightColor = dmInputTextNightColor;
    return result;
  }

  Skin._();

  factory Skin.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Skin()..mergeFromBuffer(data, registry);
  factory Skin.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Skin()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Skin',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.pgcanymodel'),
      createEmptyInstance: Skin.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'tabTextColor')
    ..aOS(2, _omitFieldNames ? '' : 'tabTextNightColor')
    ..aOS(3, _omitFieldNames ? '' : 'bgImg')
    ..aOS(4, _omitFieldNames ? '' : 'bgImgNight')
    ..aOS(5, _omitFieldNames ? '' : 'dmInputFrameBgColor')
    ..aOS(6, _omitFieldNames ? '' : 'dmInputFrameBgNightColor')
    ..aOS(7, _omitFieldNames ? '' : 'dmInputFrameColor')
    ..aOS(8, _omitFieldNames ? '' : 'dmInputFrameNightColor')
    ..aOS(9, _omitFieldNames ? '' : 'dmBtnBgColor')
    ..aOS(10, _omitFieldNames ? '' : 'dmBtnBgNightColor')
    ..aOS(11, _omitFieldNames ? '' : 'dmBtnIconColor')
    ..aOS(12, _omitFieldNames ? '' : 'dmBtnIconNightColor')
    ..aOS(13, _omitFieldNames ? '' : 'dmInputTextColor')
    ..aOS(14, _omitFieldNames ? '' : 'dmInputTextNightColor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Skin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Skin copyWith(void Function(Skin) updates) =>
      super.copyWith((message) => updates(message as Skin)) as Skin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Skin() / Skin.new instead')
  static Skin create() => Skin._();
  static $pb.GeneratedMessage $_createMessage() => Skin._();
  @$core.override
  Skin createEmptyInstance() => Skin._();
  @$core.pragma('dart2js:noInline')
  static Skin getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Skin>(Skin.$_createMessage);
  static Skin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tabTextColor => $_getSZ(0);
  @$pb.TagNumber(1)
  set tabTextColor($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTabTextColor() => $_has(0);
  @$pb.TagNumber(1)
  void clearTabTextColor() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get tabTextNightColor => $_getSZ(1);
  @$pb.TagNumber(2)
  set tabTextNightColor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTabTextNightColor() => $_has(1);
  @$pb.TagNumber(2)
  void clearTabTextNightColor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get bgImg => $_getSZ(2);
  @$pb.TagNumber(3)
  set bgImg($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBgImg() => $_has(2);
  @$pb.TagNumber(3)
  void clearBgImg() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get bgImgNight => $_getSZ(3);
  @$pb.TagNumber(4)
  set bgImgNight($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBgImgNight() => $_has(3);
  @$pb.TagNumber(4)
  void clearBgImgNight() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get dmInputFrameBgColor => $_getSZ(4);
  @$pb.TagNumber(5)
  set dmInputFrameBgColor($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDmInputFrameBgColor() => $_has(4);
  @$pb.TagNumber(5)
  void clearDmInputFrameBgColor() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get dmInputFrameBgNightColor => $_getSZ(5);
  @$pb.TagNumber(6)
  set dmInputFrameBgNightColor($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDmInputFrameBgNightColor() => $_has(5);
  @$pb.TagNumber(6)
  void clearDmInputFrameBgNightColor() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get dmInputFrameColor => $_getSZ(6);
  @$pb.TagNumber(7)
  set dmInputFrameColor($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDmInputFrameColor() => $_has(6);
  @$pb.TagNumber(7)
  void clearDmInputFrameColor() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get dmInputFrameNightColor => $_getSZ(7);
  @$pb.TagNumber(8)
  set dmInputFrameNightColor($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDmInputFrameNightColor() => $_has(7);
  @$pb.TagNumber(8)
  void clearDmInputFrameNightColor() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get dmBtnBgColor => $_getSZ(8);
  @$pb.TagNumber(9)
  set dmBtnBgColor($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDmBtnBgColor() => $_has(8);
  @$pb.TagNumber(9)
  void clearDmBtnBgColor() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get dmBtnBgNightColor => $_getSZ(9);
  @$pb.TagNumber(10)
  set dmBtnBgNightColor($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDmBtnBgNightColor() => $_has(9);
  @$pb.TagNumber(10)
  void clearDmBtnBgNightColor() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get dmBtnIconColor => $_getSZ(10);
  @$pb.TagNumber(11)
  set dmBtnIconColor($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDmBtnIconColor() => $_has(10);
  @$pb.TagNumber(11)
  void clearDmBtnIconColor() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get dmBtnIconNightColor => $_getSZ(11);
  @$pb.TagNumber(12)
  set dmBtnIconNightColor($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasDmBtnIconNightColor() => $_has(11);
  @$pb.TagNumber(12)
  void clearDmBtnIconNightColor() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get dmInputTextColor => $_getSZ(12);
  @$pb.TagNumber(13)
  set dmInputTextColor($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasDmInputTextColor() => $_has(12);
  @$pb.TagNumber(13)
  void clearDmInputTextColor() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get dmInputTextNightColor => $_getSZ(13);
  @$pb.TagNumber(14)
  set dmInputTextNightColor($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasDmInputTextNightColor() => $_has(13);
  @$pb.TagNumber(14)
  void clearDmInputTextNightColor() => $_clearField(14);
}

class Stat extends $pb.GeneratedMessage {
  factory Stat({
    $core.String? followers,
    $0.StatInfo? playData,
  }) {
    final result = Stat._();
    if (followers != null) result.followers = followers;
    if (playData != null) result.playData = playData;
    return result;
  }

  Stat._();

  factory Stat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Stat()..mergeFromBuffer(data, registry);
  factory Stat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Stat()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Stat',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.pgcanymodel'),
      createEmptyInstance: Stat.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'followers')
    ..aOM<$0.StatInfo>(2, _omitFieldNames ? '' : 'playData',
        subBuilder: $0.StatInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Stat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Stat copyWith(void Function(Stat) updates) =>
      super.copyWith((message) => updates(message as Stat)) as Stat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Stat() / Stat.new instead')
  static Stat create() => Stat._();
  static $pb.GeneratedMessage $_createMessage() => Stat._();
  @$core.override
  Stat createEmptyInstance() => Stat._();
  @$core.pragma('dart2js:noInline')
  static Stat getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Stat>(Stat.$_createMessage);
  static Stat? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get followers => $_getSZ(0);
  @$pb.TagNumber(1)
  set followers($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFollowers() => $_has(0);
  @$pb.TagNumber(1)
  void clearFollowers() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.StatInfo get playData => $_getN(1);
  @$pb.TagNumber(2)
  set playData($0.StatInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlayData() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayData() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.StatInfo ensurePlayData() => $_ensure(1);
}

class UserStatus extends $pb.GeneratedMessage {
  factory UserStatus({
    $core.int? show,
    $core.int? follow,
    $core.int? followStatus,
    $core.int? pay,
    $core.int? sponsor,
    $core.int? vip,
    $core.int? vipFrozen,
    WatchProgress? watchProgress,
  }) {
    final result = UserStatus._();
    if (show != null) result.show = show;
    if (follow != null) result.follow = follow;
    if (followStatus != null) result.followStatus = followStatus;
    if (pay != null) result.pay = pay;
    if (sponsor != null) result.sponsor = sponsor;
    if (vip != null) result.vip = vip;
    if (vipFrozen != null) result.vipFrozen = vipFrozen;
    if (watchProgress != null) result.watchProgress = watchProgress;
    return result;
  }

  UserStatus._();

  factory UserStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserStatus()..mergeFromBuffer(data, registry);
  factory UserStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserStatus()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserStatus',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.pgcanymodel'),
      createEmptyInstance: UserStatus.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'show')
    ..aI(2, _omitFieldNames ? '' : 'follow')
    ..aI(3, _omitFieldNames ? '' : 'followStatus')
    ..aI(4, _omitFieldNames ? '' : 'pay')
    ..aI(5, _omitFieldNames ? '' : 'sponsor')
    ..aI(6, _omitFieldNames ? '' : 'vip')
    ..aI(7, _omitFieldNames ? '' : 'vipFrozen')
    ..aOM<WatchProgress>(8, _omitFieldNames ? '' : 'watchProgress',
        subBuilder: WatchProgress.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserStatus copyWith(void Function(UserStatus) updates) =>
      super.copyWith((message) => updates(message as UserStatus)) as UserStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UserStatus() / UserStatus.new instead')
  static UserStatus create() => UserStatus._();
  static $pb.GeneratedMessage $_createMessage() => UserStatus._();
  @$core.override
  UserStatus createEmptyInstance() => UserStatus._();
  @$core.pragma('dart2js:noInline')
  static UserStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserStatus>(UserStatus.$_createMessage);
  static UserStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get show => $_getIZ(0);
  @$pb.TagNumber(1)
  set show($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShow() => $_has(0);
  @$pb.TagNumber(1)
  void clearShow() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get follow => $_getIZ(1);
  @$pb.TagNumber(2)
  set follow($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFollow() => $_has(1);
  @$pb.TagNumber(2)
  void clearFollow() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get followStatus => $_getIZ(2);
  @$pb.TagNumber(3)
  set followStatus($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFollowStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearFollowStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pay => $_getIZ(3);
  @$pb.TagNumber(4)
  set pay($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPay() => $_has(3);
  @$pb.TagNumber(4)
  void clearPay() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get sponsor => $_getIZ(4);
  @$pb.TagNumber(5)
  set sponsor($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSponsor() => $_has(4);
  @$pb.TagNumber(5)
  void clearSponsor() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get vip => $_getIZ(5);
  @$pb.TagNumber(6)
  set vip($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVip() => $_has(5);
  @$pb.TagNumber(6)
  void clearVip() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get vipFrozen => $_getIZ(6);
  @$pb.TagNumber(7)
  set vipFrozen($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVipFrozen() => $_has(6);
  @$pb.TagNumber(7)
  void clearVipFrozen() => $_clearField(7);

  @$pb.TagNumber(8)
  WatchProgress get watchProgress => $_getN(7);
  @$pb.TagNumber(8)
  set watchProgress(WatchProgress value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasWatchProgress() => $_has(7);
  @$pb.TagNumber(8)
  void clearWatchProgress() => $_clearField(8);
  @$pb.TagNumber(8)
  WatchProgress ensureWatchProgress() => $_ensure(7);
}

class ViewPgcAny extends $pb.GeneratedMessage {
  factory ViewPgcAny({
    OgvData? ogvData,
    $core.Iterable<$core.MapEntry<$fixnum.Int64, $0.Staff>>? allUpInfo,
  }) {
    final result = ViewPgcAny._();
    if (ogvData != null) result.ogvData = ogvData;
    if (allUpInfo != null) result.allUpInfo.addEntries(allUpInfo);
    return result;
  }

  ViewPgcAny._();

  factory ViewPgcAny.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewPgcAny()..mergeFromBuffer(data, registry);
  factory ViewPgcAny.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewPgcAny()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ViewPgcAny',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.pgcanymodel'),
      createEmptyInstance: ViewPgcAny.$_createMessage)
    ..aOM<OgvData>(1, _omitFieldNames ? '' : 'ogvData',
        subBuilder: OgvData.$_createMessage)
    ..m<$fixnum.Int64, $0.Staff>(2, _omitFieldNames ? '' : 'allUpInfo',
        entryClassName: 'ViewPgcAny.AllUpInfoEntry',
        keyFieldType: $pb.PbFieldType.O6,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: $0.Staff.$_createMessage,
        valueDefaultOrMaker: $0.Staff.getDefault,
        packageName:
            const $pb.PackageName('bilibili.app.viewunite.pgcanymodel'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewPgcAny clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewPgcAny copyWith(void Function(ViewPgcAny) updates) =>
      super.copyWith((message) => updates(message as ViewPgcAny)) as ViewPgcAny;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ViewPgcAny() / ViewPgcAny.new instead')
  static ViewPgcAny create() => ViewPgcAny._();
  static $pb.GeneratedMessage $_createMessage() => ViewPgcAny._();
  @$core.override
  ViewPgcAny createEmptyInstance() => ViewPgcAny._();
  @$core.pragma('dart2js:noInline')
  static ViewPgcAny getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ViewPgcAny>(ViewPgcAny.$_createMessage);
  static ViewPgcAny? _defaultInstance;

  @$pb.TagNumber(1)
  OgvData get ogvData => $_getN(0);
  @$pb.TagNumber(1)
  set ogvData(OgvData value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOgvData() => $_has(0);
  @$pb.TagNumber(1)
  void clearOgvData() => $_clearField(1);
  @$pb.TagNumber(1)
  OgvData ensureOgvData() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbMap<$fixnum.Int64, $0.Staff> get allUpInfo => $_getMap(1);
}

class WatchProgress extends $pb.GeneratedMessage {
  factory WatchProgress({
    $fixnum.Int64? lastEpId,
    $core.String? lastEpIndex,
    $fixnum.Int64? lastTime,
  }) {
    final result = WatchProgress._();
    if (lastEpId != null) result.lastEpId = lastEpId;
    if (lastEpIndex != null) result.lastEpIndex = lastEpIndex;
    if (lastTime != null) result.lastTime = lastTime;
    return result;
  }

  WatchProgress._();

  factory WatchProgress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchProgress()..mergeFromBuffer(data, registry);
  factory WatchProgress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WatchProgress()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchProgress',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.pgcanymodel'),
      createEmptyInstance: WatchProgress.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'lastEpId')
    ..aOS(2, _omitFieldNames ? '' : 'lastEpIndex')
    ..aInt64(3, _omitFieldNames ? '' : 'lastTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchProgress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchProgress copyWith(void Function(WatchProgress) updates) =>
      super.copyWith((message) => updates(message as WatchProgress))
          as WatchProgress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use WatchProgress() / WatchProgress.new instead')
  static WatchProgress create() => WatchProgress._();
  static $pb.GeneratedMessage $_createMessage() => WatchProgress._();
  @$core.override
  WatchProgress createEmptyInstance() => WatchProgress._();
  @$core.pragma('dart2js:noInline')
  static WatchProgress getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WatchProgress>(
          WatchProgress.$_createMessage);
  static WatchProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get lastEpId => $_getI64(0);
  @$pb.TagNumber(1)
  set lastEpId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLastEpId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLastEpId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lastEpIndex => $_getSZ(1);
  @$pb.TagNumber(2)
  set lastEpIndex($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLastEpIndex() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastEpIndex() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get lastTime => $_getI64(2);
  @$pb.TagNumber(3)
  set lastTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLastTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearLastTime() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
