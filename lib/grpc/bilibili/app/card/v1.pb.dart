// This is a generated file - do not edit.
//
// Generated from bilibili/app/card/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class AdInfo extends $pb.GeneratedMessage {
  factory AdInfo({
    $fixnum.Int64? creativeId,
    $core.int? creativeType,
    $core.int? cardType,
    CreativeContent? creativeContent,
    $core.String? adCb,
    $fixnum.Int64? resource,
    $core.int? source,
    $core.String? requestId,
    $core.bool? isAd,
    $fixnum.Int64? cmMark,
    $core.int? index,
    $core.bool? isAdLoc,
    $core.int? cardIndex,
    $core.String? clientIp,
    $core.List<$core.int>? extra,
    $core.int? creativeStyle,
    $fixnum.Int64? natureAd,
    $core.int? contentFastAccess,
  }) {
    final result = create();
    if (creativeId != null) result.creativeId = creativeId;
    if (creativeType != null) result.creativeType = creativeType;
    if (cardType != null) result.cardType = cardType;
    if (creativeContent != null) result.creativeContent = creativeContent;
    if (adCb != null) result.adCb = adCb;
    if (resource != null) result.resource = resource;
    if (source != null) result.source = source;
    if (requestId != null) result.requestId = requestId;
    if (isAd != null) result.isAd = isAd;
    if (cmMark != null) result.cmMark = cmMark;
    if (index != null) result.index = index;
    if (isAdLoc != null) result.isAdLoc = isAdLoc;
    if (cardIndex != null) result.cardIndex = cardIndex;
    if (clientIp != null) result.clientIp = clientIp;
    if (extra != null) result.extra = extra;
    if (creativeStyle != null) result.creativeStyle = creativeStyle;
    if (natureAd != null) result.natureAd = natureAd;
    if (contentFastAccess != null) result.contentFastAccess = contentFastAccess;
    return result;
  }

  AdInfo._();

  factory AdInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'creativeId')
    ..aI(2, _omitFieldNames ? '' : 'creativeType')
    ..aI(3, _omitFieldNames ? '' : 'cardType')
    ..aOM<CreativeContent>(4, _omitFieldNames ? '' : 'creativeContent',
        subBuilder: CreativeContent.create)
    ..aOS(5, _omitFieldNames ? '' : 'adCb')
    ..aInt64(6, _omitFieldNames ? '' : 'resource')
    ..aI(7, _omitFieldNames ? '' : 'source')
    ..aOS(8, _omitFieldNames ? '' : 'requestId')
    ..aOB(9, _omitFieldNames ? '' : 'isAd')
    ..aInt64(10, _omitFieldNames ? '' : 'cmMark')
    ..aI(11, _omitFieldNames ? '' : 'index')
    ..aOB(12, _omitFieldNames ? '' : 'isAdLoc')
    ..aI(13, _omitFieldNames ? '' : 'cardIndex')
    ..aOS(14, _omitFieldNames ? '' : 'clientIp')
    ..a<$core.List<$core.int>>(
        15, _omitFieldNames ? '' : 'extra', $pb.PbFieldType.OY)
    ..aI(16, _omitFieldNames ? '' : 'creativeStyle')
    ..aInt64(17, _omitFieldNames ? '' : 'natureAd')
    ..aI(18, _omitFieldNames ? '' : 'contentFastAccess')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdInfo copyWith(void Function(AdInfo) updates) =>
      super.copyWith((message) => updates(message as AdInfo)) as AdInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdInfo create() => AdInfo._();
  @$core.override
  AdInfo createEmptyInstance() => create();
  static $pb.PbList<AdInfo> createRepeated() => $pb.PbList<AdInfo>();
  @$core.pragma('dart2js:noInline')
  static AdInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AdInfo>(create);
  static AdInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get creativeId => $_getI64(0);
  @$pb.TagNumber(1)
  set creativeId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCreativeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreativeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get creativeType => $_getIZ(1);
  @$pb.TagNumber(2)
  set creativeType($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreativeType() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreativeType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get cardType => $_getIZ(2);
  @$pb.TagNumber(3)
  set cardType($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCardType() => $_has(2);
  @$pb.TagNumber(3)
  void clearCardType() => $_clearField(3);

  @$pb.TagNumber(4)
  CreativeContent get creativeContent => $_getN(3);
  @$pb.TagNumber(4)
  set creativeContent(CreativeContent value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCreativeContent() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreativeContent() => $_clearField(4);
  @$pb.TagNumber(4)
  CreativeContent ensureCreativeContent() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get adCb => $_getSZ(4);
  @$pb.TagNumber(5)
  set adCb($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAdCb() => $_has(4);
  @$pb.TagNumber(5)
  void clearAdCb() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get resource => $_getI64(5);
  @$pb.TagNumber(6)
  set resource($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasResource() => $_has(5);
  @$pb.TagNumber(6)
  void clearResource() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get source => $_getIZ(6);
  @$pb.TagNumber(7)
  set source($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSource() => $_has(6);
  @$pb.TagNumber(7)
  void clearSource() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get requestId => $_getSZ(7);
  @$pb.TagNumber(8)
  set requestId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRequestId() => $_has(7);
  @$pb.TagNumber(8)
  void clearRequestId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get isAd => $_getBF(8);
  @$pb.TagNumber(9)
  set isAd($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIsAd() => $_has(8);
  @$pb.TagNumber(9)
  void clearIsAd() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get cmMark => $_getI64(9);
  @$pb.TagNumber(10)
  set cmMark($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCmMark() => $_has(9);
  @$pb.TagNumber(10)
  void clearCmMark() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get index => $_getIZ(10);
  @$pb.TagNumber(11)
  set index($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasIndex() => $_has(10);
  @$pb.TagNumber(11)
  void clearIndex() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get isAdLoc => $_getBF(11);
  @$pb.TagNumber(12)
  set isAdLoc($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasIsAdLoc() => $_has(11);
  @$pb.TagNumber(12)
  void clearIsAdLoc() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get cardIndex => $_getIZ(12);
  @$pb.TagNumber(13)
  set cardIndex($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCardIndex() => $_has(12);
  @$pb.TagNumber(13)
  void clearCardIndex() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get clientIp => $_getSZ(13);
  @$pb.TagNumber(14)
  set clientIp($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasClientIp() => $_has(13);
  @$pb.TagNumber(14)
  void clearClientIp() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.List<$core.int> get extra => $_getN(14);
  @$pb.TagNumber(15)
  set extra($core.List<$core.int> value) => $_setBytes(14, value);
  @$pb.TagNumber(15)
  $core.bool hasExtra() => $_has(14);
  @$pb.TagNumber(15)
  void clearExtra() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.int get creativeStyle => $_getIZ(15);
  @$pb.TagNumber(16)
  set creativeStyle($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasCreativeStyle() => $_has(15);
  @$pb.TagNumber(16)
  void clearCreativeStyle() => $_clearField(16);

  @$pb.TagNumber(17)
  $fixnum.Int64 get natureAd => $_getI64(16);
  @$pb.TagNumber(17)
  set natureAd($fixnum.Int64 value) => $_setInt64(16, value);
  @$pb.TagNumber(17)
  $core.bool hasNatureAd() => $_has(16);
  @$pb.TagNumber(17)
  void clearNatureAd() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.int get contentFastAccess => $_getIZ(17);
  @$pb.TagNumber(18)
  set contentFastAccess($core.int value) => $_setSignedInt32(17, value);
  @$pb.TagNumber(18)
  $core.bool hasContentFastAccess() => $_has(17);
  @$pb.TagNumber(18)
  void clearContentFastAccess() => $_clearField(18);
}

class Args extends $pb.GeneratedMessage {
  factory Args({
    $core.int? type,
    $fixnum.Int64? upId,
    $core.String? upName,
    $core.int? rid,
    $core.String? rname,
    $fixnum.Int64? tid,
    $core.String? tname,
    $core.String? trackId,
    $core.String? state,
    $core.int? convergeType,
    $fixnum.Int64? aid,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (upId != null) result.upId = upId;
    if (upName != null) result.upName = upName;
    if (rid != null) result.rid = rid;
    if (rname != null) result.rname = rname;
    if (tid != null) result.tid = tid;
    if (tname != null) result.tname = tname;
    if (trackId != null) result.trackId = trackId;
    if (state != null) result.state = state;
    if (convergeType != null) result.convergeType = convergeType;
    if (aid != null) result.aid = aid;
    return result;
  }

  Args._();

  factory Args.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Args.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Args',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'type')
    ..aInt64(2, _omitFieldNames ? '' : 'upId')
    ..aOS(3, _omitFieldNames ? '' : 'upName')
    ..aI(4, _omitFieldNames ? '' : 'rid')
    ..aOS(5, _omitFieldNames ? '' : 'rname')
    ..aInt64(6, _omitFieldNames ? '' : 'tid')
    ..aOS(7, _omitFieldNames ? '' : 'tname')
    ..aOS(8, _omitFieldNames ? '' : 'trackId')
    ..aOS(9, _omitFieldNames ? '' : 'state')
    ..aI(10, _omitFieldNames ? '' : 'convergeType')
    ..aInt64(11, _omitFieldNames ? '' : 'aid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Args clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Args copyWith(void Function(Args) updates) =>
      super.copyWith((message) => updates(message as Args)) as Args;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Args create() => Args._();
  @$core.override
  Args createEmptyInstance() => create();
  static $pb.PbList<Args> createRepeated() => $pb.PbList<Args>();
  @$core.pragma('dart2js:noInline')
  static Args getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Args>(create);
  static Args? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get upId => $_getI64(1);
  @$pb.TagNumber(2)
  set upId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUpId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get upName => $_getSZ(2);
  @$pb.TagNumber(3)
  set upName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUpName() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get rid => $_getIZ(3);
  @$pb.TagNumber(4)
  set rid($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRid() => $_has(3);
  @$pb.TagNumber(4)
  void clearRid() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get rname => $_getSZ(4);
  @$pb.TagNumber(5)
  set rname($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRname() => $_has(4);
  @$pb.TagNumber(5)
  void clearRname() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get tid => $_getI64(5);
  @$pb.TagNumber(6)
  set tid($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTid() => $_has(5);
  @$pb.TagNumber(6)
  void clearTid() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get tname => $_getSZ(6);
  @$pb.TagNumber(7)
  set tname($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTname() => $_has(6);
  @$pb.TagNumber(7)
  void clearTname() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get trackId => $_getSZ(7);
  @$pb.TagNumber(8)
  set trackId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTrackId() => $_has(7);
  @$pb.TagNumber(8)
  void clearTrackId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get state => $_getSZ(8);
  @$pb.TagNumber(9)
  set state($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasState() => $_has(8);
  @$pb.TagNumber(9)
  void clearState() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get convergeType => $_getIZ(9);
  @$pb.TagNumber(10)
  set convergeType($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasConvergeType() => $_has(9);
  @$pb.TagNumber(10)
  void clearConvergeType() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get aid => $_getI64(10);
  @$pb.TagNumber(11)
  set aid($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasAid() => $_has(10);
  @$pb.TagNumber(11)
  void clearAid() => $_clearField(11);
}

class Avatar extends $pb.GeneratedMessage {
  factory Avatar({
    $core.String? cover,
    $core.String? text,
    $core.String? uri,
    $core.int? type,
    $core.String? event,
    $core.String? eventV2,
    $core.int? defalutCover,
  }) {
    final result = create();
    if (cover != null) result.cover = cover;
    if (text != null) result.text = text;
    if (uri != null) result.uri = uri;
    if (type != null) result.type = type;
    if (event != null) result.event = event;
    if (eventV2 != null) result.eventV2 = eventV2;
    if (defalutCover != null) result.defalutCover = defalutCover;
    return result;
  }

  Avatar._();

  factory Avatar.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Avatar.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Avatar',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cover')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..aI(4, _omitFieldNames ? '' : 'type')
    ..aOS(5, _omitFieldNames ? '' : 'event')
    ..aOS(6, _omitFieldNames ? '' : 'eventV2')
    ..aI(7, _omitFieldNames ? '' : 'defalutCover')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Avatar clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Avatar copyWith(void Function(Avatar) updates) =>
      super.copyWith((message) => updates(message as Avatar)) as Avatar;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Avatar create() => Avatar._();
  @$core.override
  Avatar createEmptyInstance() => create();
  static $pb.PbList<Avatar> createRepeated() => $pb.PbList<Avatar>();
  @$core.pragma('dart2js:noInline')
  static Avatar getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Avatar>(create);
  static Avatar? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cover => $_getSZ(0);
  @$pb.TagNumber(1)
  set cover($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCover() => $_has(0);
  @$pb.TagNumber(1)
  void clearCover() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get type => $_getIZ(3);
  @$pb.TagNumber(4)
  set type($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasType() => $_has(3);
  @$pb.TagNumber(4)
  void clearType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get event => $_getSZ(4);
  @$pb.TagNumber(5)
  set event($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEvent() => $_has(4);
  @$pb.TagNumber(5)
  void clearEvent() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get eventV2 => $_getSZ(5);
  @$pb.TagNumber(6)
  set eventV2($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEventV2() => $_has(5);
  @$pb.TagNumber(6)
  void clearEventV2() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get defalutCover => $_getIZ(6);
  @$pb.TagNumber(7)
  set defalutCover($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDefalutCover() => $_has(6);
  @$pb.TagNumber(7)
  void clearDefalutCover() => $_clearField(7);
}

class Base extends $pb.GeneratedMessage {
  factory Base({
    $core.String? cardType,
    $core.String? cardGoto,
    $core.String? goto,
    $core.String? param,
    $core.String? cover,
    $core.String? title,
    $core.String? uri,
    ThreePoint? threePoint,
    Args? args,
    PlayerArgs? playerArgs,
    $fixnum.Int64? idx,
    AdInfo? adInfo,
    Mask? mask,
    $core.String? fromType,
    $core.Iterable<ThreePointV2>? threePointV2,
    $core.Iterable<ThreePointV3>? threePointV3,
    Button? descButton,
    ThreePointV4? threePointV4,
    UpArgs? upArgs,
    $core.String? trackId,
  }) {
    final result = create();
    if (cardType != null) result.cardType = cardType;
    if (cardGoto != null) result.cardGoto = cardGoto;
    if (goto != null) result.goto = goto;
    if (param != null) result.param = param;
    if (cover != null) result.cover = cover;
    if (title != null) result.title = title;
    if (uri != null) result.uri = uri;
    if (threePoint != null) result.threePoint = threePoint;
    if (args != null) result.args = args;
    if (playerArgs != null) result.playerArgs = playerArgs;
    if (idx != null) result.idx = idx;
    if (adInfo != null) result.adInfo = adInfo;
    if (mask != null) result.mask = mask;
    if (fromType != null) result.fromType = fromType;
    if (threePointV2 != null) result.threePointV2.addAll(threePointV2);
    if (threePointV3 != null) result.threePointV3.addAll(threePointV3);
    if (descButton != null) result.descButton = descButton;
    if (threePointV4 != null) result.threePointV4 = threePointV4;
    if (upArgs != null) result.upArgs = upArgs;
    if (trackId != null) result.trackId = trackId;
    return result;
  }

  Base._();

  factory Base.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Base.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Base',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cardType')
    ..aOS(2, _omitFieldNames ? '' : 'cardGoto')
    ..aOS(3, _omitFieldNames ? '' : 'goto')
    ..aOS(4, _omitFieldNames ? '' : 'param')
    ..aOS(5, _omitFieldNames ? '' : 'cover')
    ..aOS(6, _omitFieldNames ? '' : 'title')
    ..aOS(7, _omitFieldNames ? '' : 'uri')
    ..aOM<ThreePoint>(8, _omitFieldNames ? '' : 'threePoint',
        subBuilder: ThreePoint.create)
    ..aOM<Args>(9, _omitFieldNames ? '' : 'args', subBuilder: Args.create)
    ..aOM<PlayerArgs>(10, _omitFieldNames ? '' : 'playerArgs',
        subBuilder: PlayerArgs.create)
    ..aInt64(11, _omitFieldNames ? '' : 'idx')
    ..aOM<AdInfo>(12, _omitFieldNames ? '' : 'adInfo',
        subBuilder: AdInfo.create)
    ..aOM<Mask>(13, _omitFieldNames ? '' : 'mask', subBuilder: Mask.create)
    ..aOS(14, _omitFieldNames ? '' : 'fromType')
    ..pPM<ThreePointV2>(15, _omitFieldNames ? '' : 'threePointV2',
        subBuilder: ThreePointV2.create)
    ..pPM<ThreePointV3>(16, _omitFieldNames ? '' : 'threePointV3',
        subBuilder: ThreePointV3.create)
    ..aOM<Button>(17, _omitFieldNames ? '' : 'descButton',
        subBuilder: Button.create)
    ..aOM<ThreePointV4>(18, _omitFieldNames ? '' : 'threePointV4',
        subBuilder: ThreePointV4.create)
    ..aOM<UpArgs>(19, _omitFieldNames ? '' : 'upArgs',
        subBuilder: UpArgs.create)
    ..aOS(20, _omitFieldNames ? '' : 'trackId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Base clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Base copyWith(void Function(Base) updates) =>
      super.copyWith((message) => updates(message as Base)) as Base;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Base create() => Base._();
  @$core.override
  Base createEmptyInstance() => create();
  static $pb.PbList<Base> createRepeated() => $pb.PbList<Base>();
  @$core.pragma('dart2js:noInline')
  static Base getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Base>(create);
  static Base? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cardType => $_getSZ(0);
  @$pb.TagNumber(1)
  set cardType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCardType() => $_has(0);
  @$pb.TagNumber(1)
  void clearCardType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cardGoto => $_getSZ(1);
  @$pb.TagNumber(2)
  set cardGoto($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCardGoto() => $_has(1);
  @$pb.TagNumber(2)
  void clearCardGoto() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get goto => $_getSZ(2);
  @$pb.TagNumber(3)
  set goto($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGoto() => $_has(2);
  @$pb.TagNumber(3)
  void clearGoto() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get param => $_getSZ(3);
  @$pb.TagNumber(4)
  set param($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParam() => $_has(3);
  @$pb.TagNumber(4)
  void clearParam() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get cover => $_getSZ(4);
  @$pb.TagNumber(5)
  set cover($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCover() => $_has(4);
  @$pb.TagNumber(5)
  void clearCover() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get title => $_getSZ(5);
  @$pb.TagNumber(6)
  set title($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTitle() => $_has(5);
  @$pb.TagNumber(6)
  void clearTitle() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get uri => $_getSZ(6);
  @$pb.TagNumber(7)
  set uri($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUri() => $_has(6);
  @$pb.TagNumber(7)
  void clearUri() => $_clearField(7);

  @$pb.TagNumber(8)
  ThreePoint get threePoint => $_getN(7);
  @$pb.TagNumber(8)
  set threePoint(ThreePoint value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasThreePoint() => $_has(7);
  @$pb.TagNumber(8)
  void clearThreePoint() => $_clearField(8);
  @$pb.TagNumber(8)
  ThreePoint ensureThreePoint() => $_ensure(7);

  @$pb.TagNumber(9)
  Args get args => $_getN(8);
  @$pb.TagNumber(9)
  set args(Args value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasArgs() => $_has(8);
  @$pb.TagNumber(9)
  void clearArgs() => $_clearField(9);
  @$pb.TagNumber(9)
  Args ensureArgs() => $_ensure(8);

  @$pb.TagNumber(10)
  PlayerArgs get playerArgs => $_getN(9);
  @$pb.TagNumber(10)
  set playerArgs(PlayerArgs value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasPlayerArgs() => $_has(9);
  @$pb.TagNumber(10)
  void clearPlayerArgs() => $_clearField(10);
  @$pb.TagNumber(10)
  PlayerArgs ensurePlayerArgs() => $_ensure(9);

  @$pb.TagNumber(11)
  $fixnum.Int64 get idx => $_getI64(10);
  @$pb.TagNumber(11)
  set idx($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasIdx() => $_has(10);
  @$pb.TagNumber(11)
  void clearIdx() => $_clearField(11);

  @$pb.TagNumber(12)
  AdInfo get adInfo => $_getN(11);
  @$pb.TagNumber(12)
  set adInfo(AdInfo value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasAdInfo() => $_has(11);
  @$pb.TagNumber(12)
  void clearAdInfo() => $_clearField(12);
  @$pb.TagNumber(12)
  AdInfo ensureAdInfo() => $_ensure(11);

  @$pb.TagNumber(13)
  Mask get mask => $_getN(12);
  @$pb.TagNumber(13)
  set mask(Mask value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasMask() => $_has(12);
  @$pb.TagNumber(13)
  void clearMask() => $_clearField(13);
  @$pb.TagNumber(13)
  Mask ensureMask() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.String get fromType => $_getSZ(13);
  @$pb.TagNumber(14)
  set fromType($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasFromType() => $_has(13);
  @$pb.TagNumber(14)
  void clearFromType() => $_clearField(14);

  @$pb.TagNumber(15)
  $pb.PbList<ThreePointV2> get threePointV2 => $_getList(14);

  @$pb.TagNumber(16)
  $pb.PbList<ThreePointV3> get threePointV3 => $_getList(15);

  @$pb.TagNumber(17)
  Button get descButton => $_getN(16);
  @$pb.TagNumber(17)
  set descButton(Button value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasDescButton() => $_has(16);
  @$pb.TagNumber(17)
  void clearDescButton() => $_clearField(17);
  @$pb.TagNumber(17)
  Button ensureDescButton() => $_ensure(16);

  @$pb.TagNumber(18)
  ThreePointV4 get threePointV4 => $_getN(17);
  @$pb.TagNumber(18)
  set threePointV4(ThreePointV4 value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasThreePointV4() => $_has(17);
  @$pb.TagNumber(18)
  void clearThreePointV4() => $_clearField(18);
  @$pb.TagNumber(18)
  ThreePointV4 ensureThreePointV4() => $_ensure(17);

  @$pb.TagNumber(19)
  UpArgs get upArgs => $_getN(18);
  @$pb.TagNumber(19)
  set upArgs(UpArgs value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasUpArgs() => $_has(18);
  @$pb.TagNumber(19)
  void clearUpArgs() => $_clearField(19);
  @$pb.TagNumber(19)
  UpArgs ensureUpArgs() => $_ensure(18);

  @$pb.TagNumber(20)
  $core.String get trackId => $_getSZ(19);
  @$pb.TagNumber(20)
  set trackId($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasTrackId() => $_has(19);
  @$pb.TagNumber(20)
  void clearTrackId() => $_clearField(20);
}

class Bubble extends $pb.GeneratedMessage {
  factory Bubble({
    $core.String? bubbleContent,
    $core.int? version,
    $fixnum.Int64? stime,
  }) {
    final result = create();
    if (bubbleContent != null) result.bubbleContent = bubbleContent;
    if (version != null) result.version = version;
    if (stime != null) result.stime = stime;
    return result;
  }

  Bubble._();

  factory Bubble.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Bubble.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Bubble',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'bubbleContent')
    ..aI(2, _omitFieldNames ? '' : 'version')
    ..aInt64(3, _omitFieldNames ? '' : 'stime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Bubble clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Bubble copyWith(void Function(Bubble) updates) =>
      super.copyWith((message) => updates(message as Bubble)) as Bubble;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Bubble create() => Bubble._();
  @$core.override
  Bubble createEmptyInstance() => create();
  static $pb.PbList<Bubble> createRepeated() => $pb.PbList<Bubble>();
  @$core.pragma('dart2js:noInline')
  static Bubble getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Bubble>(create);
  static Bubble? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get bubbleContent => $_getSZ(0);
  @$pb.TagNumber(1)
  set bubbleContent($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBubbleContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearBubbleContent() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get version => $_getIZ(1);
  @$pb.TagNumber(2)
  set version($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get stime => $_getI64(2);
  @$pb.TagNumber(3)
  set stime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStime() => $_has(2);
  @$pb.TagNumber(3)
  void clearStime() => $_clearField(3);
}

class Button extends $pb.GeneratedMessage {
  factory Button({
    $core.String? text,
    $core.String? param,
    $core.String? uri,
    $core.String? event,
    $core.int? selected,
    $core.int? type,
    $core.String? eventV2,
    Relation? relation,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (param != null) result.param = param;
    if (uri != null) result.uri = uri;
    if (event != null) result.event = event;
    if (selected != null) result.selected = selected;
    if (type != null) result.type = type;
    if (eventV2 != null) result.eventV2 = eventV2;
    if (relation != null) result.relation = relation;
    return result;
  }

  Button._();

  factory Button.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Button.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Button',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'param')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..aOS(4, _omitFieldNames ? '' : 'event')
    ..aI(5, _omitFieldNames ? '' : 'selected')
    ..aI(6, _omitFieldNames ? '' : 'type')
    ..aOS(7, _omitFieldNames ? '' : 'eventV2')
    ..aOM<Relation>(8, _omitFieldNames ? '' : 'relation',
        subBuilder: Relation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Button clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Button copyWith(void Function(Button) updates) =>
      super.copyWith((message) => updates(message as Button)) as Button;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Button create() => Button._();
  @$core.override
  Button createEmptyInstance() => create();
  static $pb.PbList<Button> createRepeated() => $pb.PbList<Button>();
  @$core.pragma('dart2js:noInline')
  static Button getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Button>(create);
  static Button? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get param => $_getSZ(1);
  @$pb.TagNumber(2)
  set param($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasParam() => $_has(1);
  @$pb.TagNumber(2)
  void clearParam() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get event => $_getSZ(3);
  @$pb.TagNumber(4)
  set event($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEvent() => $_has(3);
  @$pb.TagNumber(4)
  void clearEvent() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get selected => $_getIZ(4);
  @$pb.TagNumber(5)
  set selected($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSelected() => $_has(4);
  @$pb.TagNumber(5)
  void clearSelected() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get type => $_getIZ(5);
  @$pb.TagNumber(6)
  set type($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasType() => $_has(5);
  @$pb.TagNumber(6)
  void clearType() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get eventV2 => $_getSZ(6);
  @$pb.TagNumber(7)
  set eventV2($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEventV2() => $_has(6);
  @$pb.TagNumber(7)
  void clearEventV2() => $_clearField(7);

  @$pb.TagNumber(8)
  Relation get relation => $_getN(7);
  @$pb.TagNumber(8)
  set relation(Relation value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRelation() => $_has(7);
  @$pb.TagNumber(8)
  void clearRelation() => $_clearField(8);
  @$pb.TagNumber(8)
  Relation ensureRelation() => $_ensure(7);
}

enum Card_Item {
  smallCoverV5,
  largeCoverV1,
  threeItemAllV2,
  threeItemV1,
  hotTopic,
  threeItemHV5,
  middleCoverV3,
  largeCoverV4,
  popularTopEntrance,
  rcmdOneItem,
  smallCoverV5Ad,
  topicList,
  notSet
}

class Card extends $pb.GeneratedMessage {
  factory Card({
    SmallCoverV5? smallCoverV5,
    LargeCoverV1? largeCoverV1,
    ThreeItemAllV2? threeItemAllV2,
    ThreeItemV1? threeItemV1,
    HotTopic? hotTopic,
    DynamicHot? threeItemHV5,
    MiddleCoverV3? middleCoverV3,
    LargeCoverV4? largeCoverV4,
    PopularTopEntrance? popularTopEntrance,
    RcmdOneItem? rcmdOneItem,
    SmallCoverV5Ad? smallCoverV5Ad,
    TopicList? topicList,
  }) {
    final result = create();
    if (smallCoverV5 != null) result.smallCoverV5 = smallCoverV5;
    if (largeCoverV1 != null) result.largeCoverV1 = largeCoverV1;
    if (threeItemAllV2 != null) result.threeItemAllV2 = threeItemAllV2;
    if (threeItemV1 != null) result.threeItemV1 = threeItemV1;
    if (hotTopic != null) result.hotTopic = hotTopic;
    if (threeItemHV5 != null) result.threeItemHV5 = threeItemHV5;
    if (middleCoverV3 != null) result.middleCoverV3 = middleCoverV3;
    if (largeCoverV4 != null) result.largeCoverV4 = largeCoverV4;
    if (popularTopEntrance != null)
      result.popularTopEntrance = popularTopEntrance;
    if (rcmdOneItem != null) result.rcmdOneItem = rcmdOneItem;
    if (smallCoverV5Ad != null) result.smallCoverV5Ad = smallCoverV5Ad;
    if (topicList != null) result.topicList = topicList;
    return result;
  }

  Card._();

  factory Card.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Card.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Card_Item> _Card_ItemByTag = {
    1: Card_Item.smallCoverV5,
    2: Card_Item.largeCoverV1,
    3: Card_Item.threeItemAllV2,
    4: Card_Item.threeItemV1,
    5: Card_Item.hotTopic,
    6: Card_Item.threeItemHV5,
    7: Card_Item.middleCoverV3,
    8: Card_Item.largeCoverV4,
    9: Card_Item.popularTopEntrance,
    10: Card_Item.rcmdOneItem,
    11: Card_Item.smallCoverV5Ad,
    12: Card_Item.topicList,
    0: Card_Item.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Card',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
    ..aOM<SmallCoverV5>(1, _omitFieldNames ? '' : 'smallCoverV5',
        subBuilder: SmallCoverV5.create)
    ..aOM<LargeCoverV1>(2, _omitFieldNames ? '' : 'largeCoverV1',
        subBuilder: LargeCoverV1.create)
    ..aOM<ThreeItemAllV2>(3, _omitFieldNames ? '' : 'threeItemAllV2',
        subBuilder: ThreeItemAllV2.create)
    ..aOM<ThreeItemV1>(4, _omitFieldNames ? '' : 'threeItemV1',
        subBuilder: ThreeItemV1.create)
    ..aOM<HotTopic>(5, _omitFieldNames ? '' : 'hotTopic',
        subBuilder: HotTopic.create)
    ..aOM<DynamicHot>(6, _omitFieldNames ? '' : 'threeItemHV5',
        subBuilder: DynamicHot.create)
    ..aOM<MiddleCoverV3>(7, _omitFieldNames ? '' : 'middleCoverV3',
        subBuilder: MiddleCoverV3.create)
    ..aOM<LargeCoverV4>(8, _omitFieldNames ? '' : 'largeCoverV4',
        subBuilder: LargeCoverV4.create)
    ..aOM<PopularTopEntrance>(9, _omitFieldNames ? '' : 'popularTopEntrance',
        subBuilder: PopularTopEntrance.create)
    ..aOM<RcmdOneItem>(10, _omitFieldNames ? '' : 'rcmdOneItem',
        subBuilder: RcmdOneItem.create)
    ..aOM<SmallCoverV5Ad>(11, _omitFieldNames ? '' : 'smallCoverV5Ad',
        subBuilder: SmallCoverV5Ad.create)
    ..aOM<TopicList>(12, _omitFieldNames ? '' : 'topicList',
        subBuilder: TopicList.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Card clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Card copyWith(void Function(Card) updates) =>
      super.copyWith((message) => updates(message as Card)) as Card;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Card create() => Card._();
  @$core.override
  Card createEmptyInstance() => create();
  static $pb.PbList<Card> createRepeated() => $pb.PbList<Card>();
  @$core.pragma('dart2js:noInline')
  static Card getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Card>(create);
  static Card? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  Card_Item whichItem() => _Card_ItemByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  void clearItem() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  SmallCoverV5 get smallCoverV5 => $_getN(0);
  @$pb.TagNumber(1)
  set smallCoverV5(SmallCoverV5 value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSmallCoverV5() => $_has(0);
  @$pb.TagNumber(1)
  void clearSmallCoverV5() => $_clearField(1);
  @$pb.TagNumber(1)
  SmallCoverV5 ensureSmallCoverV5() => $_ensure(0);

  @$pb.TagNumber(2)
  LargeCoverV1 get largeCoverV1 => $_getN(1);
  @$pb.TagNumber(2)
  set largeCoverV1(LargeCoverV1 value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLargeCoverV1() => $_has(1);
  @$pb.TagNumber(2)
  void clearLargeCoverV1() => $_clearField(2);
  @$pb.TagNumber(2)
  LargeCoverV1 ensureLargeCoverV1() => $_ensure(1);

  @$pb.TagNumber(3)
  ThreeItemAllV2 get threeItemAllV2 => $_getN(2);
  @$pb.TagNumber(3)
  set threeItemAllV2(ThreeItemAllV2 value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasThreeItemAllV2() => $_has(2);
  @$pb.TagNumber(3)
  void clearThreeItemAllV2() => $_clearField(3);
  @$pb.TagNumber(3)
  ThreeItemAllV2 ensureThreeItemAllV2() => $_ensure(2);

  @$pb.TagNumber(4)
  ThreeItemV1 get threeItemV1 => $_getN(3);
  @$pb.TagNumber(4)
  set threeItemV1(ThreeItemV1 value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasThreeItemV1() => $_has(3);
  @$pb.TagNumber(4)
  void clearThreeItemV1() => $_clearField(4);
  @$pb.TagNumber(4)
  ThreeItemV1 ensureThreeItemV1() => $_ensure(3);

  @$pb.TagNumber(5)
  HotTopic get hotTopic => $_getN(4);
  @$pb.TagNumber(5)
  set hotTopic(HotTopic value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasHotTopic() => $_has(4);
  @$pb.TagNumber(5)
  void clearHotTopic() => $_clearField(5);
  @$pb.TagNumber(5)
  HotTopic ensureHotTopic() => $_ensure(4);

  @$pb.TagNumber(6)
  DynamicHot get threeItemHV5 => $_getN(5);
  @$pb.TagNumber(6)
  set threeItemHV5(DynamicHot value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasThreeItemHV5() => $_has(5);
  @$pb.TagNumber(6)
  void clearThreeItemHV5() => $_clearField(6);
  @$pb.TagNumber(6)
  DynamicHot ensureThreeItemHV5() => $_ensure(5);

  @$pb.TagNumber(7)
  MiddleCoverV3 get middleCoverV3 => $_getN(6);
  @$pb.TagNumber(7)
  set middleCoverV3(MiddleCoverV3 value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasMiddleCoverV3() => $_has(6);
  @$pb.TagNumber(7)
  void clearMiddleCoverV3() => $_clearField(7);
  @$pb.TagNumber(7)
  MiddleCoverV3 ensureMiddleCoverV3() => $_ensure(6);

  @$pb.TagNumber(8)
  LargeCoverV4 get largeCoverV4 => $_getN(7);
  @$pb.TagNumber(8)
  set largeCoverV4(LargeCoverV4 value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasLargeCoverV4() => $_has(7);
  @$pb.TagNumber(8)
  void clearLargeCoverV4() => $_clearField(8);
  @$pb.TagNumber(8)
  LargeCoverV4 ensureLargeCoverV4() => $_ensure(7);

  @$pb.TagNumber(9)
  PopularTopEntrance get popularTopEntrance => $_getN(8);
  @$pb.TagNumber(9)
  set popularTopEntrance(PopularTopEntrance value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasPopularTopEntrance() => $_has(8);
  @$pb.TagNumber(9)
  void clearPopularTopEntrance() => $_clearField(9);
  @$pb.TagNumber(9)
  PopularTopEntrance ensurePopularTopEntrance() => $_ensure(8);

  @$pb.TagNumber(10)
  RcmdOneItem get rcmdOneItem => $_getN(9);
  @$pb.TagNumber(10)
  set rcmdOneItem(RcmdOneItem value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasRcmdOneItem() => $_has(9);
  @$pb.TagNumber(10)
  void clearRcmdOneItem() => $_clearField(10);
  @$pb.TagNumber(10)
  RcmdOneItem ensureRcmdOneItem() => $_ensure(9);

  @$pb.TagNumber(11)
  SmallCoverV5Ad get smallCoverV5Ad => $_getN(10);
  @$pb.TagNumber(11)
  set smallCoverV5Ad(SmallCoverV5Ad value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasSmallCoverV5Ad() => $_has(10);
  @$pb.TagNumber(11)
  void clearSmallCoverV5Ad() => $_clearField(11);
  @$pb.TagNumber(11)
  SmallCoverV5Ad ensureSmallCoverV5Ad() => $_ensure(10);

  @$pb.TagNumber(12)
  TopicList get topicList => $_getN(11);
  @$pb.TagNumber(12)
  set topicList(TopicList value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasTopicList() => $_has(11);
  @$pb.TagNumber(12)
  void clearTopicList() => $_clearField(12);
  @$pb.TagNumber(12)
  TopicList ensureTopicList() => $_ensure(11);
}

class CreativeContent extends $pb.GeneratedMessage {
  factory CreativeContent({
    $core.String? title,
    $core.String? description,
    $fixnum.Int64? videoId,
    $core.String? username,
    $core.String? imageUrl,
    $core.String? imageMd5,
    $core.String? logUrl,
    $core.String? logMd5,
    $core.String? url,
    $core.String? clickUrl,
    $core.String? showUrl,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (videoId != null) result.videoId = videoId;
    if (username != null) result.username = username;
    if (imageUrl != null) result.imageUrl = imageUrl;
    if (imageMd5 != null) result.imageMd5 = imageMd5;
    if (logUrl != null) result.logUrl = logUrl;
    if (logMd5 != null) result.logMd5 = logMd5;
    if (url != null) result.url = url;
    if (clickUrl != null) result.clickUrl = clickUrl;
    if (showUrl != null) result.showUrl = showUrl;
    return result;
  }

  CreativeContent._();

  factory CreativeContent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreativeContent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreativeContent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aInt64(3, _omitFieldNames ? '' : 'videoId')
    ..aOS(4, _omitFieldNames ? '' : 'username')
    ..aOS(5, _omitFieldNames ? '' : 'imageUrl')
    ..aOS(6, _omitFieldNames ? '' : 'imageMd5')
    ..aOS(7, _omitFieldNames ? '' : 'logUrl')
    ..aOS(8, _omitFieldNames ? '' : 'logMd5')
    ..aOS(9, _omitFieldNames ? '' : 'url')
    ..aOS(10, _omitFieldNames ? '' : 'clickUrl')
    ..aOS(11, _omitFieldNames ? '' : 'showUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreativeContent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreativeContent copyWith(void Function(CreativeContent) updates) =>
      super.copyWith((message) => updates(message as CreativeContent))
          as CreativeContent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreativeContent create() => CreativeContent._();
  @$core.override
  CreativeContent createEmptyInstance() => create();
  static $pb.PbList<CreativeContent> createRepeated() =>
      $pb.PbList<CreativeContent>();
  @$core.pragma('dart2js:noInline')
  static CreativeContent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreativeContent>(create);
  static CreativeContent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get videoId => $_getI64(2);
  @$pb.TagNumber(3)
  set videoId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVideoId() => $_has(2);
  @$pb.TagNumber(3)
  void clearVideoId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get username => $_getSZ(3);
  @$pb.TagNumber(4)
  set username($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUsername() => $_has(3);
  @$pb.TagNumber(4)
  void clearUsername() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get imageUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set imageUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasImageUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearImageUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get imageMd5 => $_getSZ(5);
  @$pb.TagNumber(6)
  set imageMd5($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasImageMd5() => $_has(5);
  @$pb.TagNumber(6)
  void clearImageMd5() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get logUrl => $_getSZ(6);
  @$pb.TagNumber(7)
  set logUrl($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLogUrl() => $_has(6);
  @$pb.TagNumber(7)
  void clearLogUrl() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get logMd5 => $_getSZ(7);
  @$pb.TagNumber(8)
  set logMd5($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLogMd5() => $_has(7);
  @$pb.TagNumber(8)
  void clearLogMd5() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get url => $_getSZ(8);
  @$pb.TagNumber(9)
  set url($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUrl() => $_has(8);
  @$pb.TagNumber(9)
  void clearUrl() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get clickUrl => $_getSZ(9);
  @$pb.TagNumber(10)
  set clickUrl($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasClickUrl() => $_has(9);
  @$pb.TagNumber(10)
  void clearClickUrl() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get showUrl => $_getSZ(10);
  @$pb.TagNumber(11)
  set showUrl($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasShowUrl() => $_has(10);
  @$pb.TagNumber(11)
  void clearShowUrl() => $_clearField(11);
}

class DislikeReason extends $pb.GeneratedMessage {
  factory DislikeReason({
    $fixnum.Int64? id,
    $core.String? name,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    return result;
  }

  DislikeReason._();

  factory DislikeReason.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DislikeReason.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DislikeReason',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DislikeReason clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DislikeReason copyWith(void Function(DislikeReason) updates) =>
      super.copyWith((message) => updates(message as DislikeReason))
          as DislikeReason;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DislikeReason create() => DislikeReason._();
  @$core.override
  DislikeReason createEmptyInstance() => create();
  static $pb.PbList<DislikeReason> createRepeated() =>
      $pb.PbList<DislikeReason>();
  @$core.pragma('dart2js:noInline')
  static DislikeReason getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DislikeReason>(create);
  static DislikeReason? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

enum DoubleCards_Card { smallCoverV2, onePicV2, threePicV2, notSet }

class DoubleCards extends $pb.GeneratedMessage {
  factory DoubleCards({
    SmallCoverV2? smallCoverV2,
    OnePicV2? onePicV2,
    ThreePicV2? threePicV2,
  }) {
    final result = create();
    if (smallCoverV2 != null) result.smallCoverV2 = smallCoverV2;
    if (onePicV2 != null) result.onePicV2 = onePicV2;
    if (threePicV2 != null) result.threePicV2 = threePicV2;
    return result;
  }

  DoubleCards._();

  factory DoubleCards.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DoubleCards.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, DoubleCards_Card> _DoubleCards_CardByTag = {
    1: DoubleCards_Card.smallCoverV2,
    2: DoubleCards_Card.onePicV2,
    3: DoubleCards_Card.threePicV2,
    0: DoubleCards_Card.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DoubleCards',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<SmallCoverV2>(1, _omitFieldNames ? '' : 'smallCoverV2',
        subBuilder: SmallCoverV2.create)
    ..aOM<OnePicV2>(2, _omitFieldNames ? '' : 'onePicV2',
        subBuilder: OnePicV2.create)
    ..aOM<ThreePicV2>(3, _omitFieldNames ? '' : 'threePicV2',
        subBuilder: ThreePicV2.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DoubleCards clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DoubleCards copyWith(void Function(DoubleCards) updates) =>
      super.copyWith((message) => updates(message as DoubleCards))
          as DoubleCards;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DoubleCards create() => DoubleCards._();
  @$core.override
  DoubleCards createEmptyInstance() => create();
  static $pb.PbList<DoubleCards> createRepeated() => $pb.PbList<DoubleCards>();
  @$core.pragma('dart2js:noInline')
  static DoubleCards getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DoubleCards>(create);
  static DoubleCards? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  DoubleCards_Card whichCard() => _DoubleCards_CardByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearCard() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  SmallCoverV2 get smallCoverV2 => $_getN(0);
  @$pb.TagNumber(1)
  set smallCoverV2(SmallCoverV2 value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSmallCoverV2() => $_has(0);
  @$pb.TagNumber(1)
  void clearSmallCoverV2() => $_clearField(1);
  @$pb.TagNumber(1)
  SmallCoverV2 ensureSmallCoverV2() => $_ensure(0);

  @$pb.TagNumber(2)
  OnePicV2 get onePicV2 => $_getN(1);
  @$pb.TagNumber(2)
  set onePicV2(OnePicV2 value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOnePicV2() => $_has(1);
  @$pb.TagNumber(2)
  void clearOnePicV2() => $_clearField(2);
  @$pb.TagNumber(2)
  OnePicV2 ensureOnePicV2() => $_ensure(1);

  @$pb.TagNumber(3)
  ThreePicV2 get threePicV2 => $_getN(2);
  @$pb.TagNumber(3)
  set threePicV2(ThreePicV2 value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasThreePicV2() => $_has(2);
  @$pb.TagNumber(3)
  void clearThreePicV2() => $_clearField(3);
  @$pb.TagNumber(3)
  ThreePicV2 ensureThreePicV2() => $_ensure(2);
}

class DynamicHot extends $pb.GeneratedMessage {
  factory DynamicHot({
    Base? base,
    $core.String? topLeftTitle,
    $core.String? desc1,
    $core.String? desc2,
    $core.String? moreUri,
    $core.String? moreText,
    $core.Iterable<$core.String>? covers,
    $core.String? coverRightText,
    ReasonStyle? topRcmdReasonStyle,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (topLeftTitle != null) result.topLeftTitle = topLeftTitle;
    if (desc1 != null) result.desc1 = desc1;
    if (desc2 != null) result.desc2 = desc2;
    if (moreUri != null) result.moreUri = moreUri;
    if (moreText != null) result.moreText = moreText;
    if (covers != null) result.covers.addAll(covers);
    if (coverRightText != null) result.coverRightText = coverRightText;
    if (topRcmdReasonStyle != null)
      result.topRcmdReasonStyle = topRcmdReasonStyle;
    return result;
  }

  DynamicHot._();

  factory DynamicHot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DynamicHot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DynamicHot',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'topLeftTitle')
    ..aOS(3, _omitFieldNames ? '' : 'desc1')
    ..aOS(4, _omitFieldNames ? '' : 'desc2')
    ..aOS(5, _omitFieldNames ? '' : 'moreUri')
    ..aOS(6, _omitFieldNames ? '' : 'moreText')
    ..pPS(7, _omitFieldNames ? '' : 'covers')
    ..aOS(8, _omitFieldNames ? '' : 'coverRightText')
    ..aOM<ReasonStyle>(9, _omitFieldNames ? '' : 'topRcmdReasonStyle',
        subBuilder: ReasonStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynamicHot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DynamicHot copyWith(void Function(DynamicHot) updates) =>
      super.copyWith((message) => updates(message as DynamicHot)) as DynamicHot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DynamicHot create() => DynamicHot._();
  @$core.override
  DynamicHot createEmptyInstance() => create();
  static $pb.PbList<DynamicHot> createRepeated() => $pb.PbList<DynamicHot>();
  @$core.pragma('dart2js:noInline')
  static DynamicHot getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DynamicHot>(create);
  static DynamicHot? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get topLeftTitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set topLeftTitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTopLeftTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTopLeftTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get desc1 => $_getSZ(2);
  @$pb.TagNumber(3)
  set desc1($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDesc1() => $_has(2);
  @$pb.TagNumber(3)
  void clearDesc1() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get desc2 => $_getSZ(3);
  @$pb.TagNumber(4)
  set desc2($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDesc2() => $_has(3);
  @$pb.TagNumber(4)
  void clearDesc2() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get moreUri => $_getSZ(4);
  @$pb.TagNumber(5)
  set moreUri($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMoreUri() => $_has(4);
  @$pb.TagNumber(5)
  void clearMoreUri() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get moreText => $_getSZ(5);
  @$pb.TagNumber(6)
  set moreText($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMoreText() => $_has(5);
  @$pb.TagNumber(6)
  void clearMoreText() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get covers => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get coverRightText => $_getSZ(7);
  @$pb.TagNumber(8)
  set coverRightText($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCoverRightText() => $_has(7);
  @$pb.TagNumber(8)
  void clearCoverRightText() => $_clearField(8);

  @$pb.TagNumber(9)
  ReasonStyle get topRcmdReasonStyle => $_getN(8);
  @$pb.TagNumber(9)
  set topRcmdReasonStyle(ReasonStyle value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasTopRcmdReasonStyle() => $_has(8);
  @$pb.TagNumber(9)
  void clearTopRcmdReasonStyle() => $_clearField(9);
  @$pb.TagNumber(9)
  ReasonStyle ensureTopRcmdReasonStyle() => $_ensure(8);
}

class EntranceItem extends $pb.GeneratedMessage {
  factory EntranceItem({
    $core.String? goto,
    $core.String? icon,
    $core.String? title,
    $core.String? moduleId,
    $core.String? uri,
    $fixnum.Int64? entranceId,
    Bubble? bubble,
    $core.int? entranceType,
  }) {
    final result = create();
    if (goto != null) result.goto = goto;
    if (icon != null) result.icon = icon;
    if (title != null) result.title = title;
    if (moduleId != null) result.moduleId = moduleId;
    if (uri != null) result.uri = uri;
    if (entranceId != null) result.entranceId = entranceId;
    if (bubble != null) result.bubble = bubble;
    if (entranceType != null) result.entranceType = entranceType;
    return result;
  }

  EntranceItem._();

  factory EntranceItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EntranceItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntranceItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'goto')
    ..aOS(2, _omitFieldNames ? '' : 'icon')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'moduleId')
    ..aOS(5, _omitFieldNames ? '' : 'uri')
    ..aInt64(6, _omitFieldNames ? '' : 'entranceId')
    ..aOM<Bubble>(7, _omitFieldNames ? '' : 'bubble', subBuilder: Bubble.create)
    ..aI(8, _omitFieldNames ? '' : 'entranceType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntranceItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntranceItem copyWith(void Function(EntranceItem) updates) =>
      super.copyWith((message) => updates(message as EntranceItem))
          as EntranceItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EntranceItem create() => EntranceItem._();
  @$core.override
  EntranceItem createEmptyInstance() => create();
  static $pb.PbList<EntranceItem> createRepeated() =>
      $pb.PbList<EntranceItem>();
  @$core.pragma('dart2js:noInline')
  static EntranceItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntranceItem>(create);
  static EntranceItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get goto => $_getSZ(0);
  @$pb.TagNumber(1)
  set goto($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGoto() => $_has(0);
  @$pb.TagNumber(1)
  void clearGoto() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get icon => $_getSZ(1);
  @$pb.TagNumber(2)
  set icon($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIcon() => $_has(1);
  @$pb.TagNumber(2)
  void clearIcon() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get moduleId => $_getSZ(3);
  @$pb.TagNumber(4)
  set moduleId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasModuleId() => $_has(3);
  @$pb.TagNumber(4)
  void clearModuleId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get uri => $_getSZ(4);
  @$pb.TagNumber(5)
  set uri($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUri() => $_has(4);
  @$pb.TagNumber(5)
  void clearUri() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get entranceId => $_getI64(5);
  @$pb.TagNumber(6)
  set entranceId($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEntranceId() => $_has(5);
  @$pb.TagNumber(6)
  void clearEntranceId() => $_clearField(6);

  @$pb.TagNumber(7)
  Bubble get bubble => $_getN(6);
  @$pb.TagNumber(7)
  set bubble(Bubble value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasBubble() => $_has(6);
  @$pb.TagNumber(7)
  void clearBubble() => $_clearField(7);
  @$pb.TagNumber(7)
  Bubble ensureBubble() => $_ensure(6);

  /// 入口类型
  ///
  /// - 1: 分品类热门
  @$pb.TagNumber(8)
  $core.int get entranceType => $_getIZ(7);
  @$pb.TagNumber(8)
  set entranceType($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEntranceType() => $_has(7);
  @$pb.TagNumber(8)
  void clearEntranceType() => $_clearField(8);
}

class FunctionalButton extends $pb.GeneratedMessage {
  factory FunctionalButton({
    $core.int? type,
    $core.Iterable<FunctionalButtonMeta>? buttonMetas,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (buttonMetas != null) result.buttonMetas.addAll(buttonMetas);
    return result;
  }

  FunctionalButton._();

  factory FunctionalButton.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FunctionalButton.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FunctionalButton',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'type')
    ..pPM<FunctionalButtonMeta>(2, _omitFieldNames ? '' : 'buttonMetas',
        subBuilder: FunctionalButtonMeta.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FunctionalButton clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FunctionalButton copyWith(void Function(FunctionalButton) updates) =>
      super.copyWith((message) => updates(message as FunctionalButton))
          as FunctionalButton;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FunctionalButton create() => FunctionalButton._();
  @$core.override
  FunctionalButton createEmptyInstance() => create();
  static $pb.PbList<FunctionalButton> createRepeated() =>
      $pb.PbList<FunctionalButton>();
  @$core.pragma('dart2js:noInline')
  static FunctionalButton getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FunctionalButton>(create);
  static FunctionalButton? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<FunctionalButtonMeta> get buttonMetas => $_getList(1);
}

class FunctionalButtonMeta extends $pb.GeneratedMessage {
  factory FunctionalButtonMeta({
    $core.String? icon,
    $core.String? text,
    $core.String? buttonStatus,
    $core.String? toast,
  }) {
    final result = create();
    if (icon != null) result.icon = icon;
    if (text != null) result.text = text;
    if (buttonStatus != null) result.buttonStatus = buttonStatus;
    if (toast != null) result.toast = toast;
    return result;
  }

  FunctionalButtonMeta._();

  factory FunctionalButtonMeta.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FunctionalButtonMeta.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FunctionalButtonMeta',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'icon')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'buttonStatus')
    ..aOS(4, _omitFieldNames ? '' : 'toast')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FunctionalButtonMeta clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FunctionalButtonMeta copyWith(void Function(FunctionalButtonMeta) updates) =>
      super.copyWith((message) => updates(message as FunctionalButtonMeta))
          as FunctionalButtonMeta;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FunctionalButtonMeta create() => FunctionalButtonMeta._();
  @$core.override
  FunctionalButtonMeta createEmptyInstance() => create();
  static $pb.PbList<FunctionalButtonMeta> createRepeated() =>
      $pb.PbList<FunctionalButtonMeta>();
  @$core.pragma('dart2js:noInline')
  static FunctionalButtonMeta getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FunctionalButtonMeta>(create);
  static FunctionalButtonMeta? _defaultInstance;

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
  $core.String get buttonStatus => $_getSZ(2);
  @$pb.TagNumber(3)
  set buttonStatus($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasButtonStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearButtonStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get toast => $_getSZ(3);
  @$pb.TagNumber(4)
  set toast($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasToast() => $_has(3);
  @$pb.TagNumber(4)
  void clearToast() => $_clearField(4);
}

class HotTopic extends $pb.GeneratedMessage {
  factory HotTopic({
    Base? base,
    $core.String? desc,
    $core.Iterable<HotTopicItem>? items,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (desc != null) result.desc = desc;
    if (items != null) result.items.addAll(items);
    return result;
  }

  HotTopic._();

  factory HotTopic.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HotTopic.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HotTopic',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'desc')
    ..pPM<HotTopicItem>(3, _omitFieldNames ? '' : 'items',
        subBuilder: HotTopicItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HotTopic clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HotTopic copyWith(void Function(HotTopic) updates) =>
      super.copyWith((message) => updates(message as HotTopic)) as HotTopic;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HotTopic create() => HotTopic._();
  @$core.override
  HotTopic createEmptyInstance() => create();
  static $pb.PbList<HotTopic> createRepeated() => $pb.PbList<HotTopic>();
  @$core.pragma('dart2js:noInline')
  static HotTopic getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HotTopic>(create);
  static HotTopic? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get desc => $_getSZ(1);
  @$pb.TagNumber(2)
  set desc($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDesc() => $_has(1);
  @$pb.TagNumber(2)
  void clearDesc() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<HotTopicItem> get items => $_getList(2);
}

class HotTopicItem extends $pb.GeneratedMessage {
  factory HotTopicItem({
    $core.String? cover,
    $core.String? uri,
    $core.String? param,
    $core.String? name,
  }) {
    final result = create();
    if (cover != null) result.cover = cover;
    if (uri != null) result.uri = uri;
    if (param != null) result.param = param;
    if (name != null) result.name = name;
    return result;
  }

  HotTopicItem._();

  factory HotTopicItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HotTopicItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HotTopicItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cover')
    ..aOS(2, _omitFieldNames ? '' : 'uri')
    ..aOS(3, _omitFieldNames ? '' : 'param')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HotTopicItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HotTopicItem copyWith(void Function(HotTopicItem) updates) =>
      super.copyWith((message) => updates(message as HotTopicItem))
          as HotTopicItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HotTopicItem create() => HotTopicItem._();
  @$core.override
  HotTopicItem createEmptyInstance() => create();
  static $pb.PbList<HotTopicItem> createRepeated() =>
      $pb.PbList<HotTopicItem>();
  @$core.pragma('dart2js:noInline')
  static HotTopicItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HotTopicItem>(create);
  static HotTopicItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cover => $_getSZ(0);
  @$pb.TagNumber(1)
  set cover($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCover() => $_has(0);
  @$pb.TagNumber(1)
  void clearCover() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get uri => $_getSZ(1);
  @$pb.TagNumber(2)
  set uri($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearUri() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get param => $_getSZ(2);
  @$pb.TagNumber(3)
  set param($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasParam() => $_has(2);
  @$pb.TagNumber(3)
  void clearParam() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);
}

class HotwordEntrance extends $pb.GeneratedMessage {
  factory HotwordEntrance({
    $fixnum.Int64? hotwordId,
    $core.String? hotText,
    $core.String? h5Url,
    $core.String? icon,
  }) {
    final result = create();
    if (hotwordId != null) result.hotwordId = hotwordId;
    if (hotText != null) result.hotText = hotText;
    if (h5Url != null) result.h5Url = h5Url;
    if (icon != null) result.icon = icon;
    return result;
  }

  HotwordEntrance._();

  factory HotwordEntrance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HotwordEntrance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HotwordEntrance',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'hotwordId')
    ..aOS(2, _omitFieldNames ? '' : 'hotText')
    ..aOS(3, _omitFieldNames ? '' : 'h5Url')
    ..aOS(4, _omitFieldNames ? '' : 'icon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HotwordEntrance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HotwordEntrance copyWith(void Function(HotwordEntrance) updates) =>
      super.copyWith((message) => updates(message as HotwordEntrance))
          as HotwordEntrance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HotwordEntrance create() => HotwordEntrance._();
  @$core.override
  HotwordEntrance createEmptyInstance() => create();
  static $pb.PbList<HotwordEntrance> createRepeated() =>
      $pb.PbList<HotwordEntrance>();
  @$core.pragma('dart2js:noInline')
  static HotwordEntrance getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HotwordEntrance>(create);
  static HotwordEntrance? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get hotwordId => $_getI64(0);
  @$pb.TagNumber(1)
  set hotwordId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHotwordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearHotwordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get hotText => $_getSZ(1);
  @$pb.TagNumber(2)
  set hotText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHotText() => $_has(1);
  @$pb.TagNumber(2)
  void clearHotText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get h5Url => $_getSZ(2);
  @$pb.TagNumber(3)
  set h5Url($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasH5Url() => $_has(2);
  @$pb.TagNumber(3)
  void clearH5Url() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get icon => $_getSZ(3);
  @$pb.TagNumber(4)
  set icon($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIcon() => $_has(3);
  @$pb.TagNumber(4)
  void clearIcon() => $_clearField(4);
}

class InlineProgressBar extends $pb.GeneratedMessage {
  factory InlineProgressBar({
    $core.String? iconDrag,
    $core.String? iconDragHash,
    $core.String? iconStop,
    $core.String? iconStopHash,
  }) {
    final result = create();
    if (iconDrag != null) result.iconDrag = iconDrag;
    if (iconDragHash != null) result.iconDragHash = iconDragHash;
    if (iconStop != null) result.iconStop = iconStop;
    if (iconStopHash != null) result.iconStopHash = iconStopHash;
    return result;
  }

  InlineProgressBar._();

  factory InlineProgressBar.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InlineProgressBar.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InlineProgressBar',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'iconDrag')
    ..aOS(2, _omitFieldNames ? '' : 'iconDragHash')
    ..aOS(3, _omitFieldNames ? '' : 'iconStop')
    ..aOS(4, _omitFieldNames ? '' : 'iconStopHash')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InlineProgressBar clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InlineProgressBar copyWith(void Function(InlineProgressBar) updates) =>
      super.copyWith((message) => updates(message as InlineProgressBar))
          as InlineProgressBar;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InlineProgressBar create() => InlineProgressBar._();
  @$core.override
  InlineProgressBar createEmptyInstance() => create();
  static $pb.PbList<InlineProgressBar> createRepeated() =>
      $pb.PbList<InlineProgressBar>();
  @$core.pragma('dart2js:noInline')
  static InlineProgressBar getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InlineProgressBar>(create);
  static InlineProgressBar? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get iconDrag => $_getSZ(0);
  @$pb.TagNumber(1)
  set iconDrag($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIconDrag() => $_has(0);
  @$pb.TagNumber(1)
  void clearIconDrag() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get iconDragHash => $_getSZ(1);
  @$pb.TagNumber(2)
  set iconDragHash($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIconDragHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearIconDragHash() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get iconStop => $_getSZ(2);
  @$pb.TagNumber(3)
  set iconStop($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIconStop() => $_has(2);
  @$pb.TagNumber(3)
  void clearIconStop() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get iconStopHash => $_getSZ(3);
  @$pb.TagNumber(4)
  set iconStopHash($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIconStopHash() => $_has(3);
  @$pb.TagNumber(4)
  void clearIconStopHash() => $_clearField(4);
}

class LargeCoverV1 extends $pb.GeneratedMessage {
  factory LargeCoverV1({
    Base? base,
    $core.String? coverGif,
    Avatar? avatar,
    $core.String? coverLeftText1,
    $core.String? coverLeftText2,
    $core.String? coverLeftText3,
    $core.String? coverBadge,
    $core.String? topRcmdReason,
    $core.String? bottomRcmdReason,
    $core.String? desc,
    $core.int? officialIcon,
    $core.int? canPlay,
    ReasonStyle? topRcmdReasonStyle,
    ReasonStyle? bottomRcmdReasonStyle,
    ReasonStyle? rcmdReasonStyleV2,
    ReasonStyle? leftCoverBadgeStyle,
    ReasonStyle? rightCoverBadgeStyle,
    $core.String? coverBadge2,
    LikeButton? likeButton,
    $core.int? titleSingleLine,
    $core.String? coverRightText,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (coverGif != null) result.coverGif = coverGif;
    if (avatar != null) result.avatar = avatar;
    if (coverLeftText1 != null) result.coverLeftText1 = coverLeftText1;
    if (coverLeftText2 != null) result.coverLeftText2 = coverLeftText2;
    if (coverLeftText3 != null) result.coverLeftText3 = coverLeftText3;
    if (coverBadge != null) result.coverBadge = coverBadge;
    if (topRcmdReason != null) result.topRcmdReason = topRcmdReason;
    if (bottomRcmdReason != null) result.bottomRcmdReason = bottomRcmdReason;
    if (desc != null) result.desc = desc;
    if (officialIcon != null) result.officialIcon = officialIcon;
    if (canPlay != null) result.canPlay = canPlay;
    if (topRcmdReasonStyle != null)
      result.topRcmdReasonStyle = topRcmdReasonStyle;
    if (bottomRcmdReasonStyle != null)
      result.bottomRcmdReasonStyle = bottomRcmdReasonStyle;
    if (rcmdReasonStyleV2 != null) result.rcmdReasonStyleV2 = rcmdReasonStyleV2;
    if (leftCoverBadgeStyle != null)
      result.leftCoverBadgeStyle = leftCoverBadgeStyle;
    if (rightCoverBadgeStyle != null)
      result.rightCoverBadgeStyle = rightCoverBadgeStyle;
    if (coverBadge2 != null) result.coverBadge2 = coverBadge2;
    if (likeButton != null) result.likeButton = likeButton;
    if (titleSingleLine != null) result.titleSingleLine = titleSingleLine;
    if (coverRightText != null) result.coverRightText = coverRightText;
    return result;
  }

  LargeCoverV1._();

  factory LargeCoverV1.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LargeCoverV1.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LargeCoverV1',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'coverGif')
    ..aOM<Avatar>(3, _omitFieldNames ? '' : 'avatar', subBuilder: Avatar.create)
    ..aOS(4, _omitFieldNames ? '' : 'coverLeftText1')
    ..aOS(5, _omitFieldNames ? '' : 'coverLeftText2')
    ..aOS(6, _omitFieldNames ? '' : 'coverLeftText3')
    ..aOS(7, _omitFieldNames ? '' : 'coverBadge')
    ..aOS(8, _omitFieldNames ? '' : 'topRcmdReason')
    ..aOS(9, _omitFieldNames ? '' : 'bottomRcmdReason')
    ..aOS(10, _omitFieldNames ? '' : 'desc')
    ..aI(11, _omitFieldNames ? '' : 'officialIcon')
    ..aI(12, _omitFieldNames ? '' : 'canPlay')
    ..aOM<ReasonStyle>(13, _omitFieldNames ? '' : 'topRcmdReasonStyle',
        subBuilder: ReasonStyle.create)
    ..aOM<ReasonStyle>(14, _omitFieldNames ? '' : 'bottomRcmdReasonStyle',
        subBuilder: ReasonStyle.create)
    ..aOM<ReasonStyle>(15, _omitFieldNames ? '' : 'rcmdReasonStyleV2',
        subBuilder: ReasonStyle.create)
    ..aOM<ReasonStyle>(16, _omitFieldNames ? '' : 'leftCoverBadgeStyle',
        subBuilder: ReasonStyle.create)
    ..aOM<ReasonStyle>(17, _omitFieldNames ? '' : 'rightCoverBadgeStyle',
        subBuilder: ReasonStyle.create)
    ..aOS(18, _omitFieldNames ? '' : 'coverBadge2')
    ..aOM<LikeButton>(19, _omitFieldNames ? '' : 'likeButton',
        subBuilder: LikeButton.create)
    ..aI(20, _omitFieldNames ? '' : 'titleSingleLine')
    ..aOS(21, _omitFieldNames ? '' : 'coverRightText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LargeCoverV1 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LargeCoverV1 copyWith(void Function(LargeCoverV1) updates) =>
      super.copyWith((message) => updates(message as LargeCoverV1))
          as LargeCoverV1;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LargeCoverV1 create() => LargeCoverV1._();
  @$core.override
  LargeCoverV1 createEmptyInstance() => create();
  static $pb.PbList<LargeCoverV1> createRepeated() =>
      $pb.PbList<LargeCoverV1>();
  @$core.pragma('dart2js:noInline')
  static LargeCoverV1 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LargeCoverV1>(create);
  static LargeCoverV1? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get coverGif => $_getSZ(1);
  @$pb.TagNumber(2)
  set coverGif($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCoverGif() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoverGif() => $_clearField(2);

  @$pb.TagNumber(3)
  Avatar get avatar => $_getN(2);
  @$pb.TagNumber(3)
  set avatar(Avatar value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAvatar() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvatar() => $_clearField(3);
  @$pb.TagNumber(3)
  Avatar ensureAvatar() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get coverLeftText1 => $_getSZ(3);
  @$pb.TagNumber(4)
  set coverLeftText1($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverLeftText1() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverLeftText1() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get coverLeftText2 => $_getSZ(4);
  @$pb.TagNumber(5)
  set coverLeftText2($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCoverLeftText2() => $_has(4);
  @$pb.TagNumber(5)
  void clearCoverLeftText2() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get coverLeftText3 => $_getSZ(5);
  @$pb.TagNumber(6)
  set coverLeftText3($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCoverLeftText3() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoverLeftText3() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get coverBadge => $_getSZ(6);
  @$pb.TagNumber(7)
  set coverBadge($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCoverBadge() => $_has(6);
  @$pb.TagNumber(7)
  void clearCoverBadge() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get topRcmdReason => $_getSZ(7);
  @$pb.TagNumber(8)
  set topRcmdReason($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTopRcmdReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearTopRcmdReason() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get bottomRcmdReason => $_getSZ(8);
  @$pb.TagNumber(9)
  set bottomRcmdReason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBottomRcmdReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearBottomRcmdReason() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get desc => $_getSZ(9);
  @$pb.TagNumber(10)
  set desc($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDesc() => $_has(9);
  @$pb.TagNumber(10)
  void clearDesc() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get officialIcon => $_getIZ(10);
  @$pb.TagNumber(11)
  set officialIcon($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOfficialIcon() => $_has(10);
  @$pb.TagNumber(11)
  void clearOfficialIcon() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get canPlay => $_getIZ(11);
  @$pb.TagNumber(12)
  set canPlay($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasCanPlay() => $_has(11);
  @$pb.TagNumber(12)
  void clearCanPlay() => $_clearField(12);

  @$pb.TagNumber(13)
  ReasonStyle get topRcmdReasonStyle => $_getN(12);
  @$pb.TagNumber(13)
  set topRcmdReasonStyle(ReasonStyle value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasTopRcmdReasonStyle() => $_has(12);
  @$pb.TagNumber(13)
  void clearTopRcmdReasonStyle() => $_clearField(13);
  @$pb.TagNumber(13)
  ReasonStyle ensureTopRcmdReasonStyle() => $_ensure(12);

  @$pb.TagNumber(14)
  ReasonStyle get bottomRcmdReasonStyle => $_getN(13);
  @$pb.TagNumber(14)
  set bottomRcmdReasonStyle(ReasonStyle value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasBottomRcmdReasonStyle() => $_has(13);
  @$pb.TagNumber(14)
  void clearBottomRcmdReasonStyle() => $_clearField(14);
  @$pb.TagNumber(14)
  ReasonStyle ensureBottomRcmdReasonStyle() => $_ensure(13);

  @$pb.TagNumber(15)
  ReasonStyle get rcmdReasonStyleV2 => $_getN(14);
  @$pb.TagNumber(15)
  set rcmdReasonStyleV2(ReasonStyle value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasRcmdReasonStyleV2() => $_has(14);
  @$pb.TagNumber(15)
  void clearRcmdReasonStyleV2() => $_clearField(15);
  @$pb.TagNumber(15)
  ReasonStyle ensureRcmdReasonStyleV2() => $_ensure(14);

  @$pb.TagNumber(16)
  ReasonStyle get leftCoverBadgeStyle => $_getN(15);
  @$pb.TagNumber(16)
  set leftCoverBadgeStyle(ReasonStyle value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasLeftCoverBadgeStyle() => $_has(15);
  @$pb.TagNumber(16)
  void clearLeftCoverBadgeStyle() => $_clearField(16);
  @$pb.TagNumber(16)
  ReasonStyle ensureLeftCoverBadgeStyle() => $_ensure(15);

  @$pb.TagNumber(17)
  ReasonStyle get rightCoverBadgeStyle => $_getN(16);
  @$pb.TagNumber(17)
  set rightCoverBadgeStyle(ReasonStyle value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasRightCoverBadgeStyle() => $_has(16);
  @$pb.TagNumber(17)
  void clearRightCoverBadgeStyle() => $_clearField(17);
  @$pb.TagNumber(17)
  ReasonStyle ensureRightCoverBadgeStyle() => $_ensure(16);

  @$pb.TagNumber(18)
  $core.String get coverBadge2 => $_getSZ(17);
  @$pb.TagNumber(18)
  set coverBadge2($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasCoverBadge2() => $_has(17);
  @$pb.TagNumber(18)
  void clearCoverBadge2() => $_clearField(18);

  @$pb.TagNumber(19)
  LikeButton get likeButton => $_getN(18);
  @$pb.TagNumber(19)
  set likeButton(LikeButton value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasLikeButton() => $_has(18);
  @$pb.TagNumber(19)
  void clearLikeButton() => $_clearField(19);
  @$pb.TagNumber(19)
  LikeButton ensureLikeButton() => $_ensure(18);

  @$pb.TagNumber(20)
  $core.int get titleSingleLine => $_getIZ(19);
  @$pb.TagNumber(20)
  set titleSingleLine($core.int value) => $_setSignedInt32(19, value);
  @$pb.TagNumber(20)
  $core.bool hasTitleSingleLine() => $_has(19);
  @$pb.TagNumber(20)
  void clearTitleSingleLine() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get coverRightText => $_getSZ(20);
  @$pb.TagNumber(21)
  set coverRightText($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasCoverRightText() => $_has(20);
  @$pb.TagNumber(21)
  void clearCoverRightText() => $_clearField(21);
}

class LargeCoverV2 extends $pb.GeneratedMessage {
  factory LargeCoverV2({
    Base? base,
    Avatar? avatar,
    $core.String? badge,
    Button? coverRightButton,
    $core.String? coverLeftText1,
    $core.int? coverLeftIcon1,
    $core.String? coverLeftText2,
    $core.int? coverLeftIcon2,
    $core.String? rcmdReason,
    $core.int? officialIcon,
    $core.int? canPlay,
    ReasonStyle? rcmdReasonStyle,
    $core.int? showTop,
    $core.int? showBottom,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (avatar != null) result.avatar = avatar;
    if (badge != null) result.badge = badge;
    if (coverRightButton != null) result.coverRightButton = coverRightButton;
    if (coverLeftText1 != null) result.coverLeftText1 = coverLeftText1;
    if (coverLeftIcon1 != null) result.coverLeftIcon1 = coverLeftIcon1;
    if (coverLeftText2 != null) result.coverLeftText2 = coverLeftText2;
    if (coverLeftIcon2 != null) result.coverLeftIcon2 = coverLeftIcon2;
    if (rcmdReason != null) result.rcmdReason = rcmdReason;
    if (officialIcon != null) result.officialIcon = officialIcon;
    if (canPlay != null) result.canPlay = canPlay;
    if (rcmdReasonStyle != null) result.rcmdReasonStyle = rcmdReasonStyle;
    if (showTop != null) result.showTop = showTop;
    if (showBottom != null) result.showBottom = showBottom;
    return result;
  }

  LargeCoverV2._();

  factory LargeCoverV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LargeCoverV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LargeCoverV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOM<Avatar>(2, _omitFieldNames ? '' : 'avatar', subBuilder: Avatar.create)
    ..aOS(3, _omitFieldNames ? '' : 'badge')
    ..aOM<Button>(4, _omitFieldNames ? '' : 'coverRightButton',
        subBuilder: Button.create)
    ..aOS(5, _omitFieldNames ? '' : 'coverLeftText1')
    ..aI(6, _omitFieldNames ? '' : 'coverLeftIcon1')
    ..aOS(7, _omitFieldNames ? '' : 'coverLeftText2')
    ..aI(8, _omitFieldNames ? '' : 'coverLeftIcon2')
    ..aOS(9, _omitFieldNames ? '' : 'rcmdReason')
    ..aI(10, _omitFieldNames ? '' : 'officialIcon')
    ..aI(11, _omitFieldNames ? '' : 'canPlay')
    ..aOM<ReasonStyle>(12, _omitFieldNames ? '' : 'rcmdReasonStyle',
        subBuilder: ReasonStyle.create)
    ..aI(13, _omitFieldNames ? '' : 'showTop')
    ..aI(14, _omitFieldNames ? '' : 'showBottom')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LargeCoverV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LargeCoverV2 copyWith(void Function(LargeCoverV2) updates) =>
      super.copyWith((message) => updates(message as LargeCoverV2))
          as LargeCoverV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LargeCoverV2 create() => LargeCoverV2._();
  @$core.override
  LargeCoverV2 createEmptyInstance() => create();
  static $pb.PbList<LargeCoverV2> createRepeated() =>
      $pb.PbList<LargeCoverV2>();
  @$core.pragma('dart2js:noInline')
  static LargeCoverV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LargeCoverV2>(create);
  static LargeCoverV2? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  Avatar get avatar => $_getN(1);
  @$pb.TagNumber(2)
  set avatar(Avatar value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAvatar() => $_has(1);
  @$pb.TagNumber(2)
  void clearAvatar() => $_clearField(2);
  @$pb.TagNumber(2)
  Avatar ensureAvatar() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get badge => $_getSZ(2);
  @$pb.TagNumber(3)
  set badge($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBadge() => $_has(2);
  @$pb.TagNumber(3)
  void clearBadge() => $_clearField(3);

  @$pb.TagNumber(4)
  Button get coverRightButton => $_getN(3);
  @$pb.TagNumber(4)
  set coverRightButton(Button value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverRightButton() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverRightButton() => $_clearField(4);
  @$pb.TagNumber(4)
  Button ensureCoverRightButton() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get coverLeftText1 => $_getSZ(4);
  @$pb.TagNumber(5)
  set coverLeftText1($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCoverLeftText1() => $_has(4);
  @$pb.TagNumber(5)
  void clearCoverLeftText1() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get coverLeftIcon1 => $_getIZ(5);
  @$pb.TagNumber(6)
  set coverLeftIcon1($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCoverLeftIcon1() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoverLeftIcon1() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get coverLeftText2 => $_getSZ(6);
  @$pb.TagNumber(7)
  set coverLeftText2($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCoverLeftText2() => $_has(6);
  @$pb.TagNumber(7)
  void clearCoverLeftText2() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get coverLeftIcon2 => $_getIZ(7);
  @$pb.TagNumber(8)
  set coverLeftIcon2($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCoverLeftIcon2() => $_has(7);
  @$pb.TagNumber(8)
  void clearCoverLeftIcon2() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get rcmdReason => $_getSZ(8);
  @$pb.TagNumber(9)
  set rcmdReason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRcmdReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearRcmdReason() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get officialIcon => $_getIZ(9);
  @$pb.TagNumber(10)
  set officialIcon($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasOfficialIcon() => $_has(9);
  @$pb.TagNumber(10)
  void clearOfficialIcon() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get canPlay => $_getIZ(10);
  @$pb.TagNumber(11)
  set canPlay($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCanPlay() => $_has(10);
  @$pb.TagNumber(11)
  void clearCanPlay() => $_clearField(11);

  @$pb.TagNumber(12)
  ReasonStyle get rcmdReasonStyle => $_getN(11);
  @$pb.TagNumber(12)
  set rcmdReasonStyle(ReasonStyle value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasRcmdReasonStyle() => $_has(11);
  @$pb.TagNumber(12)
  void clearRcmdReasonStyle() => $_clearField(12);
  @$pb.TagNumber(12)
  ReasonStyle ensureRcmdReasonStyle() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.int get showTop => $_getIZ(12);
  @$pb.TagNumber(13)
  set showTop($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasShowTop() => $_has(12);
  @$pb.TagNumber(13)
  void clearShowTop() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get showBottom => $_getIZ(13);
  @$pb.TagNumber(14)
  set showBottom($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasShowBottom() => $_has(13);
  @$pb.TagNumber(14)
  void clearShowBottom() => $_clearField(14);
}

class LargeCoverV3 extends $pb.GeneratedMessage {
  factory LargeCoverV3({
    Base? base,
    $core.String? coverGif,
    Avatar? avatar,
    ReasonStyle? topRcmdReasonStyle,
    ReasonStyle? bottomRcmdReasonStyle,
    $core.String? coverLeftText1,
    $core.int? coverLeftIcon1,
    $core.String? coverLeftText2,
    $core.int? coverLeftIcon2,
    $core.String? coverRightText,
    $core.String? desc,
    $core.int? officialIcon,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (coverGif != null) result.coverGif = coverGif;
    if (avatar != null) result.avatar = avatar;
    if (topRcmdReasonStyle != null)
      result.topRcmdReasonStyle = topRcmdReasonStyle;
    if (bottomRcmdReasonStyle != null)
      result.bottomRcmdReasonStyle = bottomRcmdReasonStyle;
    if (coverLeftText1 != null) result.coverLeftText1 = coverLeftText1;
    if (coverLeftIcon1 != null) result.coverLeftIcon1 = coverLeftIcon1;
    if (coverLeftText2 != null) result.coverLeftText2 = coverLeftText2;
    if (coverLeftIcon2 != null) result.coverLeftIcon2 = coverLeftIcon2;
    if (coverRightText != null) result.coverRightText = coverRightText;
    if (desc != null) result.desc = desc;
    if (officialIcon != null) result.officialIcon = officialIcon;
    return result;
  }

  LargeCoverV3._();

  factory LargeCoverV3.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LargeCoverV3.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LargeCoverV3',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'coverGif')
    ..aOM<Avatar>(3, _omitFieldNames ? '' : 'avatar', subBuilder: Avatar.create)
    ..aOM<ReasonStyle>(4, _omitFieldNames ? '' : 'topRcmdReasonStyle',
        subBuilder: ReasonStyle.create)
    ..aOM<ReasonStyle>(5, _omitFieldNames ? '' : 'bottomRcmdReasonStyle',
        subBuilder: ReasonStyle.create)
    ..aOS(6, _omitFieldNames ? '' : 'coverLeftText1')
    ..aI(7, _omitFieldNames ? '' : 'coverLeftIcon1')
    ..aOS(8, _omitFieldNames ? '' : 'coverLeftText2')
    ..aI(9, _omitFieldNames ? '' : 'coverLeftIcon2')
    ..aOS(10, _omitFieldNames ? '' : 'coverRightText')
    ..aOS(11, _omitFieldNames ? '' : 'desc')
    ..aI(12, _omitFieldNames ? '' : 'officialIcon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LargeCoverV3 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LargeCoverV3 copyWith(void Function(LargeCoverV3) updates) =>
      super.copyWith((message) => updates(message as LargeCoverV3))
          as LargeCoverV3;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LargeCoverV3 create() => LargeCoverV3._();
  @$core.override
  LargeCoverV3 createEmptyInstance() => create();
  static $pb.PbList<LargeCoverV3> createRepeated() =>
      $pb.PbList<LargeCoverV3>();
  @$core.pragma('dart2js:noInline')
  static LargeCoverV3 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LargeCoverV3>(create);
  static LargeCoverV3? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get coverGif => $_getSZ(1);
  @$pb.TagNumber(2)
  set coverGif($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCoverGif() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoverGif() => $_clearField(2);

  @$pb.TagNumber(3)
  Avatar get avatar => $_getN(2);
  @$pb.TagNumber(3)
  set avatar(Avatar value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAvatar() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvatar() => $_clearField(3);
  @$pb.TagNumber(3)
  Avatar ensureAvatar() => $_ensure(2);

  @$pb.TagNumber(4)
  ReasonStyle get topRcmdReasonStyle => $_getN(3);
  @$pb.TagNumber(4)
  set topRcmdReasonStyle(ReasonStyle value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTopRcmdReasonStyle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTopRcmdReasonStyle() => $_clearField(4);
  @$pb.TagNumber(4)
  ReasonStyle ensureTopRcmdReasonStyle() => $_ensure(3);

  @$pb.TagNumber(5)
  ReasonStyle get bottomRcmdReasonStyle => $_getN(4);
  @$pb.TagNumber(5)
  set bottomRcmdReasonStyle(ReasonStyle value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasBottomRcmdReasonStyle() => $_has(4);
  @$pb.TagNumber(5)
  void clearBottomRcmdReasonStyle() => $_clearField(5);
  @$pb.TagNumber(5)
  ReasonStyle ensureBottomRcmdReasonStyle() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get coverLeftText1 => $_getSZ(5);
  @$pb.TagNumber(6)
  set coverLeftText1($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCoverLeftText1() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoverLeftText1() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get coverLeftIcon1 => $_getIZ(6);
  @$pb.TagNumber(7)
  set coverLeftIcon1($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCoverLeftIcon1() => $_has(6);
  @$pb.TagNumber(7)
  void clearCoverLeftIcon1() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get coverLeftText2 => $_getSZ(7);
  @$pb.TagNumber(8)
  set coverLeftText2($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCoverLeftText2() => $_has(7);
  @$pb.TagNumber(8)
  void clearCoverLeftText2() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get coverLeftIcon2 => $_getIZ(8);
  @$pb.TagNumber(9)
  set coverLeftIcon2($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCoverLeftIcon2() => $_has(8);
  @$pb.TagNumber(9)
  void clearCoverLeftIcon2() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get coverRightText => $_getSZ(9);
  @$pb.TagNumber(10)
  set coverRightText($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCoverRightText() => $_has(9);
  @$pb.TagNumber(10)
  void clearCoverRightText() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get desc => $_getSZ(10);
  @$pb.TagNumber(11)
  set desc($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDesc() => $_has(10);
  @$pb.TagNumber(11)
  void clearDesc() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get officialIcon => $_getIZ(11);
  @$pb.TagNumber(12)
  set officialIcon($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasOfficialIcon() => $_has(11);
  @$pb.TagNumber(12)
  void clearOfficialIcon() => $_clearField(12);
}

class LargeCoverV4 extends $pb.GeneratedMessage {
  factory LargeCoverV4({
    Base? base,
    $core.String? coverLeftText1,
    $core.String? coverLeftText2,
    $core.String? coverLeftText3,
    $core.String? coverBadge,
    $core.int? canPlay,
    Up? up,
    $core.String? shortLink,
    $core.String? shareSubtitle,
    $core.String? playNumber,
    $core.String? bvid,
    $core.String? subParam,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (coverLeftText1 != null) result.coverLeftText1 = coverLeftText1;
    if (coverLeftText2 != null) result.coverLeftText2 = coverLeftText2;
    if (coverLeftText3 != null) result.coverLeftText3 = coverLeftText3;
    if (coverBadge != null) result.coverBadge = coverBadge;
    if (canPlay != null) result.canPlay = canPlay;
    if (up != null) result.up = up;
    if (shortLink != null) result.shortLink = shortLink;
    if (shareSubtitle != null) result.shareSubtitle = shareSubtitle;
    if (playNumber != null) result.playNumber = playNumber;
    if (bvid != null) result.bvid = bvid;
    if (subParam != null) result.subParam = subParam;
    return result;
  }

  LargeCoverV4._();

  factory LargeCoverV4.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LargeCoverV4.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LargeCoverV4',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'coverLeftText1')
    ..aOS(3, _omitFieldNames ? '' : 'coverLeftText2')
    ..aOS(4, _omitFieldNames ? '' : 'coverLeftText3')
    ..aOS(5, _omitFieldNames ? '' : 'coverBadge')
    ..aI(6, _omitFieldNames ? '' : 'canPlay')
    ..aOM<Up>(7, _omitFieldNames ? '' : 'up', subBuilder: Up.create)
    ..aOS(8, _omitFieldNames ? '' : 'shortLink')
    ..aOS(9, _omitFieldNames ? '' : 'shareSubtitle')
    ..aOS(10, _omitFieldNames ? '' : 'playNumber')
    ..aOS(11, _omitFieldNames ? '' : 'bvid')
    ..aOS(12, _omitFieldNames ? '' : 'subParam')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LargeCoverV4 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LargeCoverV4 copyWith(void Function(LargeCoverV4) updates) =>
      super.copyWith((message) => updates(message as LargeCoverV4))
          as LargeCoverV4;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LargeCoverV4 create() => LargeCoverV4._();
  @$core.override
  LargeCoverV4 createEmptyInstance() => create();
  static $pb.PbList<LargeCoverV4> createRepeated() =>
      $pb.PbList<LargeCoverV4>();
  @$core.pragma('dart2js:noInline')
  static LargeCoverV4 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LargeCoverV4>(create);
  static LargeCoverV4? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get coverLeftText1 => $_getSZ(1);
  @$pb.TagNumber(2)
  set coverLeftText1($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCoverLeftText1() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoverLeftText1() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get coverLeftText2 => $_getSZ(2);
  @$pb.TagNumber(3)
  set coverLeftText2($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCoverLeftText2() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoverLeftText2() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get coverLeftText3 => $_getSZ(3);
  @$pb.TagNumber(4)
  set coverLeftText3($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverLeftText3() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverLeftText3() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get coverBadge => $_getSZ(4);
  @$pb.TagNumber(5)
  set coverBadge($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCoverBadge() => $_has(4);
  @$pb.TagNumber(5)
  void clearCoverBadge() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get canPlay => $_getIZ(5);
  @$pb.TagNumber(6)
  set canPlay($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCanPlay() => $_has(5);
  @$pb.TagNumber(6)
  void clearCanPlay() => $_clearField(6);

  @$pb.TagNumber(7)
  Up get up => $_getN(6);
  @$pb.TagNumber(7)
  set up(Up value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasUp() => $_has(6);
  @$pb.TagNumber(7)
  void clearUp() => $_clearField(7);
  @$pb.TagNumber(7)
  Up ensureUp() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get shortLink => $_getSZ(7);
  @$pb.TagNumber(8)
  set shortLink($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasShortLink() => $_has(7);
  @$pb.TagNumber(8)
  void clearShortLink() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get shareSubtitle => $_getSZ(8);
  @$pb.TagNumber(9)
  set shareSubtitle($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasShareSubtitle() => $_has(8);
  @$pb.TagNumber(9)
  void clearShareSubtitle() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get playNumber => $_getSZ(9);
  @$pb.TagNumber(10)
  set playNumber($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPlayNumber() => $_has(9);
  @$pb.TagNumber(10)
  void clearPlayNumber() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get bvid => $_getSZ(10);
  @$pb.TagNumber(11)
  set bvid($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasBvid() => $_has(10);
  @$pb.TagNumber(11)
  void clearBvid() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get subParam => $_getSZ(11);
  @$pb.TagNumber(12)
  set subParam($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSubParam() => $_has(11);
  @$pb.TagNumber(12)
  void clearSubParam() => $_clearField(12);
}

class LikeButton extends $pb.GeneratedMessage {
  factory LikeButton({
    $fixnum.Int64? aid,
    $core.int? count,
    $core.bool? showCount,
    $core.String? event,
    $core.int? selected,
    $core.String? eventV2,
  }) {
    final result = create();
    if (aid != null) result.aid = aid;
    if (count != null) result.count = count;
    if (showCount != null) result.showCount = showCount;
    if (event != null) result.event = event;
    if (selected != null) result.selected = selected;
    if (eventV2 != null) result.eventV2 = eventV2;
    return result;
  }

  LikeButton._();

  factory LikeButton.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LikeButton.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LikeButton',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aI(2, _omitFieldNames ? '' : 'count')
    ..aOB(3, _omitFieldNames ? '' : 'showCount')
    ..aOS(4, _omitFieldNames ? '' : 'event')
    ..aI(5, _omitFieldNames ? '' : 'selected')
    ..aOS(6, _omitFieldNames ? '' : 'eventV2')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeButton clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeButton copyWith(void Function(LikeButton) updates) =>
      super.copyWith((message) => updates(message as LikeButton)) as LikeButton;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LikeButton create() => LikeButton._();
  @$core.override
  LikeButton createEmptyInstance() => create();
  static $pb.PbList<LikeButton> createRepeated() => $pb.PbList<LikeButton>();
  @$core.pragma('dart2js:noInline')
  static LikeButton getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LikeButton>(create);
  static LikeButton? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get aid => $_getI64(0);
  @$pb.TagNumber(1)
  set aid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get count => $_getIZ(1);
  @$pb.TagNumber(2)
  set count($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get showCount => $_getBF(2);
  @$pb.TagNumber(3)
  set showCount($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasShowCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearShowCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get event => $_getSZ(3);
  @$pb.TagNumber(4)
  set event($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEvent() => $_has(3);
  @$pb.TagNumber(4)
  void clearEvent() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get selected => $_getIZ(4);
  @$pb.TagNumber(5)
  set selected($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSelected() => $_has(4);
  @$pb.TagNumber(5)
  void clearSelected() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get eventV2 => $_getSZ(5);
  @$pb.TagNumber(6)
  set eventV2($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEventV2() => $_has(5);
  @$pb.TagNumber(6)
  void clearEventV2() => $_clearField(6);
}

class Mask extends $pb.GeneratedMessage {
  factory Mask({
    Avatar? avatar,
    Button? button,
  }) {
    final result = create();
    if (avatar != null) result.avatar = avatar;
    if (button != null) result.button = button;
    return result;
  }

  Mask._();

  factory Mask.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Mask.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Mask',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Avatar>(1, _omitFieldNames ? '' : 'avatar', subBuilder: Avatar.create)
    ..aOM<Button>(2, _omitFieldNames ? '' : 'button', subBuilder: Button.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Mask clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Mask copyWith(void Function(Mask) updates) =>
      super.copyWith((message) => updates(message as Mask)) as Mask;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Mask create() => Mask._();
  @$core.override
  Mask createEmptyInstance() => create();
  static $pb.PbList<Mask> createRepeated() => $pb.PbList<Mask>();
  @$core.pragma('dart2js:noInline')
  static Mask getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Mask>(create);
  static Mask? _defaultInstance;

  @$pb.TagNumber(1)
  Avatar get avatar => $_getN(0);
  @$pb.TagNumber(1)
  set avatar(Avatar value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAvatar() => $_has(0);
  @$pb.TagNumber(1)
  void clearAvatar() => $_clearField(1);
  @$pb.TagNumber(1)
  Avatar ensureAvatar() => $_ensure(0);

  @$pb.TagNumber(2)
  Button get button => $_getN(1);
  @$pb.TagNumber(2)
  set button(Button value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasButton() => $_has(1);
  @$pb.TagNumber(2)
  void clearButton() => $_clearField(2);
  @$pb.TagNumber(2)
  Button ensureButton() => $_ensure(1);
}

class MiddleCoverV2 extends $pb.GeneratedMessage {
  factory MiddleCoverV2({
    Base? base,
    $core.int? ratio,
    $core.String? desc,
    $core.String? badge,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (ratio != null) result.ratio = ratio;
    if (desc != null) result.desc = desc;
    if (badge != null) result.badge = badge;
    return result;
  }

  MiddleCoverV2._();

  factory MiddleCoverV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MiddleCoverV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MiddleCoverV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aI(2, _omitFieldNames ? '' : 'ratio')
    ..aOS(3, _omitFieldNames ? '' : 'desc')
    ..aOS(4, _omitFieldNames ? '' : 'badge')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MiddleCoverV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MiddleCoverV2 copyWith(void Function(MiddleCoverV2) updates) =>
      super.copyWith((message) => updates(message as MiddleCoverV2))
          as MiddleCoverV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MiddleCoverV2 create() => MiddleCoverV2._();
  @$core.override
  MiddleCoverV2 createEmptyInstance() => create();
  static $pb.PbList<MiddleCoverV2> createRepeated() =>
      $pb.PbList<MiddleCoverV2>();
  @$core.pragma('dart2js:noInline')
  static MiddleCoverV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MiddleCoverV2>(create);
  static MiddleCoverV2? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get ratio => $_getIZ(1);
  @$pb.TagNumber(2)
  set ratio($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRatio() => $_has(1);
  @$pb.TagNumber(2)
  void clearRatio() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get desc => $_getSZ(2);
  @$pb.TagNumber(3)
  set desc($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDesc() => $_has(2);
  @$pb.TagNumber(3)
  void clearDesc() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get badge => $_getSZ(3);
  @$pb.TagNumber(4)
  set badge($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBadge() => $_has(3);
  @$pb.TagNumber(4)
  void clearBadge() => $_clearField(4);
}

class MiddleCoverV3 extends $pb.GeneratedMessage {
  factory MiddleCoverV3({
    Base? base,
    $core.String? desc1,
    $core.String? desc2,
    ReasonStyle? coverBadgeStyle,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (desc1 != null) result.desc1 = desc1;
    if (desc2 != null) result.desc2 = desc2;
    if (coverBadgeStyle != null) result.coverBadgeStyle = coverBadgeStyle;
    return result;
  }

  MiddleCoverV3._();

  factory MiddleCoverV3.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MiddleCoverV3.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MiddleCoverV3',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'desc1')
    ..aOS(3, _omitFieldNames ? '' : 'desc2')
    ..aOM<ReasonStyle>(4, _omitFieldNames ? '' : 'coverBadgeStyle',
        subBuilder: ReasonStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MiddleCoverV3 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MiddleCoverV3 copyWith(void Function(MiddleCoverV3) updates) =>
      super.copyWith((message) => updates(message as MiddleCoverV3))
          as MiddleCoverV3;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MiddleCoverV3 create() => MiddleCoverV3._();
  @$core.override
  MiddleCoverV3 createEmptyInstance() => create();
  static $pb.PbList<MiddleCoverV3> createRepeated() =>
      $pb.PbList<MiddleCoverV3>();
  @$core.pragma('dart2js:noInline')
  static MiddleCoverV3 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MiddleCoverV3>(create);
  static MiddleCoverV3? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get desc1 => $_getSZ(1);
  @$pb.TagNumber(2)
  set desc1($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDesc1() => $_has(1);
  @$pb.TagNumber(2)
  void clearDesc1() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get desc2 => $_getSZ(2);
  @$pb.TagNumber(3)
  set desc2($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDesc2() => $_has(2);
  @$pb.TagNumber(3)
  void clearDesc2() => $_clearField(3);

  @$pb.TagNumber(4)
  ReasonStyle get coverBadgeStyle => $_getN(3);
  @$pb.TagNumber(4)
  set coverBadgeStyle(ReasonStyle value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverBadgeStyle() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverBadgeStyle() => $_clearField(4);
  @$pb.TagNumber(4)
  ReasonStyle ensureCoverBadgeStyle() => $_ensure(3);
}

class MultiItem extends $pb.GeneratedMessage {
  factory MultiItem({
    Base? base,
    $core.String? moreUri,
    $core.String? moreText,
    $core.Iterable<DoubleCards>? items,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (moreUri != null) result.moreUri = moreUri;
    if (moreText != null) result.moreText = moreText;
    if (items != null) result.items.addAll(items);
    return result;
  }

  MultiItem._();

  factory MultiItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MultiItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MultiItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'moreUri')
    ..aOS(3, _omitFieldNames ? '' : 'moreText')
    ..pPM<DoubleCards>(4, _omitFieldNames ? '' : 'items',
        subBuilder: DoubleCards.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiItem copyWith(void Function(MultiItem) updates) =>
      super.copyWith((message) => updates(message as MultiItem)) as MultiItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MultiItem create() => MultiItem._();
  @$core.override
  MultiItem createEmptyInstance() => create();
  static $pb.PbList<MultiItem> createRepeated() => $pb.PbList<MultiItem>();
  @$core.pragma('dart2js:noInline')
  static MultiItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MultiItem>(create);
  static MultiItem? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get moreUri => $_getSZ(1);
  @$pb.TagNumber(2)
  set moreUri($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMoreUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearMoreUri() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get moreText => $_getSZ(2);
  @$pb.TagNumber(3)
  set moreText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMoreText() => $_has(2);
  @$pb.TagNumber(3)
  void clearMoreText() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<DoubleCards> get items => $_getList(3);
}

class OnePicV2 extends $pb.GeneratedMessage {
  factory OnePicV2({
    Base? base,
    $core.int? coverLeftIcon1,
    $core.String? coverLeftText2,
    $core.String? coverRightText,
    $core.int? coverRightIcon,
    $core.String? coverRightBackgroundColor,
    $core.String? badge,
    $core.String? rcmdReason,
    Avatar? avatar,
    ReasonStyle? rcmdReasonStyle,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (coverLeftIcon1 != null) result.coverLeftIcon1 = coverLeftIcon1;
    if (coverLeftText2 != null) result.coverLeftText2 = coverLeftText2;
    if (coverRightText != null) result.coverRightText = coverRightText;
    if (coverRightIcon != null) result.coverRightIcon = coverRightIcon;
    if (coverRightBackgroundColor != null)
      result.coverRightBackgroundColor = coverRightBackgroundColor;
    if (badge != null) result.badge = badge;
    if (rcmdReason != null) result.rcmdReason = rcmdReason;
    if (avatar != null) result.avatar = avatar;
    if (rcmdReasonStyle != null) result.rcmdReasonStyle = rcmdReasonStyle;
    return result;
  }

  OnePicV2._();

  factory OnePicV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OnePicV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OnePicV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aI(2, _omitFieldNames ? '' : 'coverLeftIcon1')
    ..aOS(3, _omitFieldNames ? '' : 'coverLeftText2')
    ..aOS(4, _omitFieldNames ? '' : 'coverRightText')
    ..aI(5, _omitFieldNames ? '' : 'coverRightIcon')
    ..aOS(6, _omitFieldNames ? '' : 'coverRightBackgroundColor')
    ..aOS(7, _omitFieldNames ? '' : 'badge')
    ..aOS(8, _omitFieldNames ? '' : 'rcmdReason')
    ..aOM<Avatar>(9, _omitFieldNames ? '' : 'avatar', subBuilder: Avatar.create)
    ..aOM<ReasonStyle>(10, _omitFieldNames ? '' : 'rcmdReasonStyle',
        subBuilder: ReasonStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OnePicV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OnePicV2 copyWith(void Function(OnePicV2) updates) =>
      super.copyWith((message) => updates(message as OnePicV2)) as OnePicV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OnePicV2 create() => OnePicV2._();
  @$core.override
  OnePicV2 createEmptyInstance() => create();
  static $pb.PbList<OnePicV2> createRepeated() => $pb.PbList<OnePicV2>();
  @$core.pragma('dart2js:noInline')
  static OnePicV2 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OnePicV2>(create);
  static OnePicV2? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get coverLeftIcon1 => $_getIZ(1);
  @$pb.TagNumber(2)
  set coverLeftIcon1($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCoverLeftIcon1() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoverLeftIcon1() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get coverLeftText2 => $_getSZ(2);
  @$pb.TagNumber(3)
  set coverLeftText2($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCoverLeftText2() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoverLeftText2() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get coverRightText => $_getSZ(3);
  @$pb.TagNumber(4)
  set coverRightText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverRightText() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverRightText() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get coverRightIcon => $_getIZ(4);
  @$pb.TagNumber(5)
  set coverRightIcon($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCoverRightIcon() => $_has(4);
  @$pb.TagNumber(5)
  void clearCoverRightIcon() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get coverRightBackgroundColor => $_getSZ(5);
  @$pb.TagNumber(6)
  set coverRightBackgroundColor($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCoverRightBackgroundColor() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoverRightBackgroundColor() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get badge => $_getSZ(6);
  @$pb.TagNumber(7)
  set badge($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBadge() => $_has(6);
  @$pb.TagNumber(7)
  void clearBadge() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get rcmdReason => $_getSZ(7);
  @$pb.TagNumber(8)
  set rcmdReason($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRcmdReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearRcmdReason() => $_clearField(8);

  @$pb.TagNumber(9)
  Avatar get avatar => $_getN(8);
  @$pb.TagNumber(9)
  set avatar(Avatar value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasAvatar() => $_has(8);
  @$pb.TagNumber(9)
  void clearAvatar() => $_clearField(9);
  @$pb.TagNumber(9)
  Avatar ensureAvatar() => $_ensure(8);

  @$pb.TagNumber(10)
  ReasonStyle get rcmdReasonStyle => $_getN(9);
  @$pb.TagNumber(10)
  set rcmdReasonStyle(ReasonStyle value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasRcmdReasonStyle() => $_has(9);
  @$pb.TagNumber(10)
  void clearRcmdReasonStyle() => $_clearField(10);
  @$pb.TagNumber(10)
  ReasonStyle ensureRcmdReasonStyle() => $_ensure(9);
}

class OnePicV3 extends $pb.GeneratedMessage {
  factory OnePicV3({
    Base? base,
    $core.String? coverLeftText1,
    $core.int? coverLeftIcon1,
    $core.String? coverRightText,
    $core.int? coverRightIcon,
    $core.String? coverRightBackgroundColor,
    $core.String? badge,
    ReasonStyle? rcmdReasonStyle,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (coverLeftText1 != null) result.coverLeftText1 = coverLeftText1;
    if (coverLeftIcon1 != null) result.coverLeftIcon1 = coverLeftIcon1;
    if (coverRightText != null) result.coverRightText = coverRightText;
    if (coverRightIcon != null) result.coverRightIcon = coverRightIcon;
    if (coverRightBackgroundColor != null)
      result.coverRightBackgroundColor = coverRightBackgroundColor;
    if (badge != null) result.badge = badge;
    if (rcmdReasonStyle != null) result.rcmdReasonStyle = rcmdReasonStyle;
    return result;
  }

  OnePicV3._();

  factory OnePicV3.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OnePicV3.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OnePicV3',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'coverLeftText1')
    ..aI(3, _omitFieldNames ? '' : 'coverLeftIcon1')
    ..aOS(4, _omitFieldNames ? '' : 'coverRightText')
    ..aI(5, _omitFieldNames ? '' : 'coverRightIcon')
    ..aOS(6, _omitFieldNames ? '' : 'coverRightBackgroundColor')
    ..aOS(7, _omitFieldNames ? '' : 'badge')
    ..aOM<ReasonStyle>(8, _omitFieldNames ? '' : 'rcmdReasonStyle',
        subBuilder: ReasonStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OnePicV3 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OnePicV3 copyWith(void Function(OnePicV3) updates) =>
      super.copyWith((message) => updates(message as OnePicV3)) as OnePicV3;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OnePicV3 create() => OnePicV3._();
  @$core.override
  OnePicV3 createEmptyInstance() => create();
  static $pb.PbList<OnePicV3> createRepeated() => $pb.PbList<OnePicV3>();
  @$core.pragma('dart2js:noInline')
  static OnePicV3 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OnePicV3>(create);
  static OnePicV3? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get coverLeftText1 => $_getSZ(1);
  @$pb.TagNumber(2)
  set coverLeftText1($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCoverLeftText1() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoverLeftText1() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get coverLeftIcon1 => $_getIZ(2);
  @$pb.TagNumber(3)
  set coverLeftIcon1($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCoverLeftIcon1() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoverLeftIcon1() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get coverRightText => $_getSZ(3);
  @$pb.TagNumber(4)
  set coverRightText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverRightText() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverRightText() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get coverRightIcon => $_getIZ(4);
  @$pb.TagNumber(5)
  set coverRightIcon($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCoverRightIcon() => $_has(4);
  @$pb.TagNumber(5)
  void clearCoverRightIcon() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get coverRightBackgroundColor => $_getSZ(5);
  @$pb.TagNumber(6)
  set coverRightBackgroundColor($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCoverRightBackgroundColor() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoverRightBackgroundColor() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get badge => $_getSZ(6);
  @$pb.TagNumber(7)
  set badge($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBadge() => $_has(6);
  @$pb.TagNumber(7)
  void clearBadge() => $_clearField(7);

  @$pb.TagNumber(8)
  ReasonStyle get rcmdReasonStyle => $_getN(7);
  @$pb.TagNumber(8)
  set rcmdReasonStyle(ReasonStyle value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRcmdReasonStyle() => $_has(7);
  @$pb.TagNumber(8)
  void clearRcmdReasonStyle() => $_clearField(8);
  @$pb.TagNumber(8)
  ReasonStyle ensureRcmdReasonStyle() => $_ensure(7);
}

class PanelMeta extends $pb.GeneratedMessage {
  factory PanelMeta({
    $core.int? panelType,
    $core.String? shareOrigin,
    $core.String? shareId,
    $core.Iterable<FunctionalButton>? functionalButtons,
  }) {
    final result = create();
    if (panelType != null) result.panelType = panelType;
    if (shareOrigin != null) result.shareOrigin = shareOrigin;
    if (shareId != null) result.shareId = shareId;
    if (functionalButtons != null)
      result.functionalButtons.addAll(functionalButtons);
    return result;
  }

  PanelMeta._();

  factory PanelMeta.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PanelMeta.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PanelMeta',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'panelType')
    ..aOS(2, _omitFieldNames ? '' : 'shareOrigin')
    ..aOS(3, _omitFieldNames ? '' : 'shareId')
    ..pPM<FunctionalButton>(4, _omitFieldNames ? '' : 'functionalButtons',
        subBuilder: FunctionalButton.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PanelMeta clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PanelMeta copyWith(void Function(PanelMeta) updates) =>
      super.copyWith((message) => updates(message as PanelMeta)) as PanelMeta;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PanelMeta create() => PanelMeta._();
  @$core.override
  PanelMeta createEmptyInstance() => create();
  static $pb.PbList<PanelMeta> createRepeated() => $pb.PbList<PanelMeta>();
  @$core.pragma('dart2js:noInline')
  static PanelMeta getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PanelMeta>(create);
  static PanelMeta? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get panelType => $_getIZ(0);
  @$pb.TagNumber(1)
  set panelType($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPanelType() => $_has(0);
  @$pb.TagNumber(1)
  void clearPanelType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get shareOrigin => $_getSZ(1);
  @$pb.TagNumber(2)
  set shareOrigin($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShareOrigin() => $_has(1);
  @$pb.TagNumber(2)
  void clearShareOrigin() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get shareId => $_getSZ(2);
  @$pb.TagNumber(3)
  set shareId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasShareId() => $_has(2);
  @$pb.TagNumber(3)
  void clearShareId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<FunctionalButton> get functionalButtons => $_getList(3);
}

class PlayerArgs extends $pb.GeneratedMessage {
  factory PlayerArgs({
    $core.int? isLive,
    $fixnum.Int64? aid,
    $fixnum.Int64? cid,
    $core.int? subType,
    $fixnum.Int64? roomId,
    $fixnum.Int64? epId,
    $core.int? isPreview,
    $core.String? type,
    $fixnum.Int64? duration,
    $fixnum.Int64? seasonId,
  }) {
    final result = create();
    if (isLive != null) result.isLive = isLive;
    if (aid != null) result.aid = aid;
    if (cid != null) result.cid = cid;
    if (subType != null) result.subType = subType;
    if (roomId != null) result.roomId = roomId;
    if (epId != null) result.epId = epId;
    if (isPreview != null) result.isPreview = isPreview;
    if (type != null) result.type = type;
    if (duration != null) result.duration = duration;
    if (seasonId != null) result.seasonId = seasonId;
    return result;
  }

  PlayerArgs._();

  factory PlayerArgs.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerArgs.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerArgs',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'isLive')
    ..aInt64(2, _omitFieldNames ? '' : 'aid')
    ..aInt64(3, _omitFieldNames ? '' : 'cid')
    ..aI(4, _omitFieldNames ? '' : 'subType')
    ..aInt64(5, _omitFieldNames ? '' : 'roomId')
    ..aInt64(7, _omitFieldNames ? '' : 'epId')
    ..aI(8, _omitFieldNames ? '' : 'isPreview')
    ..aOS(9, _omitFieldNames ? '' : 'type')
    ..aInt64(10, _omitFieldNames ? '' : 'duration')
    ..aInt64(11, _omitFieldNames ? '' : 'seasonId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerArgs clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerArgs copyWith(void Function(PlayerArgs) updates) =>
      super.copyWith((message) => updates(message as PlayerArgs)) as PlayerArgs;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerArgs create() => PlayerArgs._();
  @$core.override
  PlayerArgs createEmptyInstance() => create();
  static $pb.PbList<PlayerArgs> createRepeated() => $pb.PbList<PlayerArgs>();
  @$core.pragma('dart2js:noInline')
  static PlayerArgs getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerArgs>(create);
  static PlayerArgs? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get isLive => $_getIZ(0);
  @$pb.TagNumber(1)
  set isLive($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsLive() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsLive() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get aid => $_getI64(1);
  @$pb.TagNumber(2)
  set aid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAid() => $_has(1);
  @$pb.TagNumber(2)
  void clearAid() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get cid => $_getI64(2);
  @$pb.TagNumber(3)
  set cid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCid() => $_has(2);
  @$pb.TagNumber(3)
  void clearCid() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get subType => $_getIZ(3);
  @$pb.TagNumber(4)
  set subType($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubType() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubType() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get roomId => $_getI64(4);
  @$pb.TagNumber(5)
  set roomId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRoomId() => $_has(4);
  @$pb.TagNumber(5)
  void clearRoomId() => $_clearField(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get epId => $_getI64(5);
  @$pb.TagNumber(7)
  set epId($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(7)
  $core.bool hasEpId() => $_has(5);
  @$pb.TagNumber(7)
  void clearEpId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get isPreview => $_getIZ(6);
  @$pb.TagNumber(8)
  set isPreview($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(8)
  $core.bool hasIsPreview() => $_has(6);
  @$pb.TagNumber(8)
  void clearIsPreview() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get type => $_getSZ(7);
  @$pb.TagNumber(9)
  set type($core.String value) => $_setString(7, value);
  @$pb.TagNumber(9)
  $core.bool hasType() => $_has(7);
  @$pb.TagNumber(9)
  void clearType() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get duration => $_getI64(8);
  @$pb.TagNumber(10)
  set duration($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(10)
  $core.bool hasDuration() => $_has(8);
  @$pb.TagNumber(10)
  void clearDuration() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get seasonId => $_getI64(9);
  @$pb.TagNumber(11)
  set seasonId($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(11)
  $core.bool hasSeasonId() => $_has(9);
  @$pb.TagNumber(11)
  void clearSeasonId() => $_clearField(11);
}

class PopularTopEntrance extends $pb.GeneratedMessage {
  factory PopularTopEntrance({
    Base? base,
    $core.Iterable<EntranceItem>? items,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (items != null) result.items.addAll(items);
    return result;
  }

  PopularTopEntrance._();

  factory PopularTopEntrance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PopularTopEntrance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PopularTopEntrance',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..pPM<EntranceItem>(2, _omitFieldNames ? '' : 'items',
        subBuilder: EntranceItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PopularTopEntrance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PopularTopEntrance copyWith(void Function(PopularTopEntrance) updates) =>
      super.copyWith((message) => updates(message as PopularTopEntrance))
          as PopularTopEntrance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PopularTopEntrance create() => PopularTopEntrance._();
  @$core.override
  PopularTopEntrance createEmptyInstance() => create();
  static $pb.PbList<PopularTopEntrance> createRepeated() =>
      $pb.PbList<PopularTopEntrance>();
  @$core.pragma('dart2js:noInline')
  static PopularTopEntrance getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PopularTopEntrance>(create);
  static PopularTopEntrance? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<EntranceItem> get items => $_getList(1);
}

class RcmdOneItem extends $pb.GeneratedMessage {
  factory RcmdOneItem({
    Base? base,
    ReasonStyle? topRcmdReasonStyle,
    SmallCoverRcmdItem? item,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (topRcmdReasonStyle != null)
      result.topRcmdReasonStyle = topRcmdReasonStyle;
    if (item != null) result.item = item;
    return result;
  }

  RcmdOneItem._();

  factory RcmdOneItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RcmdOneItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RcmdOneItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOM<ReasonStyle>(2, _omitFieldNames ? '' : 'topRcmdReasonStyle',
        subBuilder: ReasonStyle.create)
    ..aOM<SmallCoverRcmdItem>(3, _omitFieldNames ? '' : 'item',
        subBuilder: SmallCoverRcmdItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RcmdOneItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RcmdOneItem copyWith(void Function(RcmdOneItem) updates) =>
      super.copyWith((message) => updates(message as RcmdOneItem))
          as RcmdOneItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RcmdOneItem create() => RcmdOneItem._();
  @$core.override
  RcmdOneItem createEmptyInstance() => create();
  static $pb.PbList<RcmdOneItem> createRepeated() => $pb.PbList<RcmdOneItem>();
  @$core.pragma('dart2js:noInline')
  static RcmdOneItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RcmdOneItem>(create);
  static RcmdOneItem? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  ReasonStyle get topRcmdReasonStyle => $_getN(1);
  @$pb.TagNumber(2)
  set topRcmdReasonStyle(ReasonStyle value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTopRcmdReasonStyle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTopRcmdReasonStyle() => $_clearField(2);
  @$pb.TagNumber(2)
  ReasonStyle ensureTopRcmdReasonStyle() => $_ensure(1);

  @$pb.TagNumber(3)
  SmallCoverRcmdItem get item => $_getN(2);
  @$pb.TagNumber(3)
  set item(SmallCoverRcmdItem value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasItem() => $_has(2);
  @$pb.TagNumber(3)
  void clearItem() => $_clearField(3);
  @$pb.TagNumber(3)
  SmallCoverRcmdItem ensureItem() => $_ensure(2);
}

class ReasonStyle extends $pb.GeneratedMessage {
  factory ReasonStyle({
    $core.String? text,
    $core.String? textColor,
    $core.String? bgColor,
    $core.String? borderColor,
    $core.String? iconUrl,
    $core.String? textColorNight,
    $core.String? bgColorNight,
    $core.String? borderColorNight,
    $core.String? iconNightUrl,
    $core.int? bgStyle,
    $core.String? uri,
    $core.String? iconBgUrl,
    $core.String? event,
    $core.String? eventV2,
    $core.int? rightIconType,
    $core.String? leftIconType,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (textColor != null) result.textColor = textColor;
    if (bgColor != null) result.bgColor = bgColor;
    if (borderColor != null) result.borderColor = borderColor;
    if (iconUrl != null) result.iconUrl = iconUrl;
    if (textColorNight != null) result.textColorNight = textColorNight;
    if (bgColorNight != null) result.bgColorNight = bgColorNight;
    if (borderColorNight != null) result.borderColorNight = borderColorNight;
    if (iconNightUrl != null) result.iconNightUrl = iconNightUrl;
    if (bgStyle != null) result.bgStyle = bgStyle;
    if (uri != null) result.uri = uri;
    if (iconBgUrl != null) result.iconBgUrl = iconBgUrl;
    if (event != null) result.event = event;
    if (eventV2 != null) result.eventV2 = eventV2;
    if (rightIconType != null) result.rightIconType = rightIconType;
    if (leftIconType != null) result.leftIconType = leftIconType;
    return result;
  }

  ReasonStyle._();

  factory ReasonStyle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReasonStyle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReasonStyle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'textColor')
    ..aOS(3, _omitFieldNames ? '' : 'bgColor')
    ..aOS(4, _omitFieldNames ? '' : 'borderColor')
    ..aOS(5, _omitFieldNames ? '' : 'iconUrl')
    ..aOS(6, _omitFieldNames ? '' : 'textColorNight')
    ..aOS(7, _omitFieldNames ? '' : 'bgColorNight')
    ..aOS(8, _omitFieldNames ? '' : 'borderColorNight')
    ..aOS(9, _omitFieldNames ? '' : 'iconNightUrl')
    ..aI(10, _omitFieldNames ? '' : 'bgStyle')
    ..aOS(11, _omitFieldNames ? '' : 'uri')
    ..aOS(12, _omitFieldNames ? '' : 'iconBgUrl')
    ..aOS(13, _omitFieldNames ? '' : 'event')
    ..aOS(14, _omitFieldNames ? '' : 'eventV2')
    ..aI(15, _omitFieldNames ? '' : 'rightIconType')
    ..aOS(16, _omitFieldNames ? '' : 'leftIconType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReasonStyle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReasonStyle copyWith(void Function(ReasonStyle) updates) =>
      super.copyWith((message) => updates(message as ReasonStyle))
          as ReasonStyle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReasonStyle create() => ReasonStyle._();
  @$core.override
  ReasonStyle createEmptyInstance() => create();
  static $pb.PbList<ReasonStyle> createRepeated() => $pb.PbList<ReasonStyle>();
  @$core.pragma('dart2js:noInline')
  static ReasonStyle getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReasonStyle>(create);
  static ReasonStyle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get textColor => $_getSZ(1);
  @$pb.TagNumber(2)
  set textColor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTextColor() => $_has(1);
  @$pb.TagNumber(2)
  void clearTextColor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get bgColor => $_getSZ(2);
  @$pb.TagNumber(3)
  set bgColor($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBgColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearBgColor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get borderColor => $_getSZ(3);
  @$pb.TagNumber(4)
  set borderColor($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBorderColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearBorderColor() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get iconUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set iconUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIconUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearIconUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get textColorNight => $_getSZ(5);
  @$pb.TagNumber(6)
  set textColorNight($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTextColorNight() => $_has(5);
  @$pb.TagNumber(6)
  void clearTextColorNight() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get bgColorNight => $_getSZ(6);
  @$pb.TagNumber(7)
  set bgColorNight($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBgColorNight() => $_has(6);
  @$pb.TagNumber(7)
  void clearBgColorNight() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get borderColorNight => $_getSZ(7);
  @$pb.TagNumber(8)
  set borderColorNight($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBorderColorNight() => $_has(7);
  @$pb.TagNumber(8)
  void clearBorderColorNight() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get iconNightUrl => $_getSZ(8);
  @$pb.TagNumber(9)
  set iconNightUrl($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIconNightUrl() => $_has(8);
  @$pb.TagNumber(9)
  void clearIconNightUrl() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get bgStyle => $_getIZ(9);
  @$pb.TagNumber(10)
  set bgStyle($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasBgStyle() => $_has(9);
  @$pb.TagNumber(10)
  void clearBgStyle() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get uri => $_getSZ(10);
  @$pb.TagNumber(11)
  set uri($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasUri() => $_has(10);
  @$pb.TagNumber(11)
  void clearUri() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get iconBgUrl => $_getSZ(11);
  @$pb.TagNumber(12)
  set iconBgUrl($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasIconBgUrl() => $_has(11);
  @$pb.TagNumber(12)
  void clearIconBgUrl() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get event => $_getSZ(12);
  @$pb.TagNumber(13)
  set event($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasEvent() => $_has(12);
  @$pb.TagNumber(13)
  void clearEvent() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get eventV2 => $_getSZ(13);
  @$pb.TagNumber(14)
  set eventV2($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasEventV2() => $_has(13);
  @$pb.TagNumber(14)
  void clearEventV2() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get rightIconType => $_getIZ(14);
  @$pb.TagNumber(15)
  set rightIconType($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasRightIconType() => $_has(14);
  @$pb.TagNumber(15)
  void clearRightIconType() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get leftIconType => $_getSZ(15);
  @$pb.TagNumber(16)
  set leftIconType($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasLeftIconType() => $_has(15);
  @$pb.TagNumber(16)
  void clearLeftIconType() => $_clearField(16);
}

/// 新关注组件
class Relation extends $pb.GeneratedMessage {
  factory Relation({
    $core.int? status,
    $core.int? isFollow,
    $core.int? isFollowed,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (isFollow != null) result.isFollow = isFollow;
    if (isFollowed != null) result.isFollowed = isFollowed;
    return result;
  }

  Relation._();

  factory Relation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Relation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Relation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'status')
    ..aI(2, _omitFieldNames ? '' : 'isFollow')
    ..aI(3, _omitFieldNames ? '' : 'isFollowed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Relation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Relation copyWith(void Function(Relation) updates) =>
      super.copyWith((message) => updates(message as Relation)) as Relation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Relation create() => Relation._();
  @$core.override
  Relation createEmptyInstance() => create();
  static $pb.PbList<Relation> createRepeated() => $pb.PbList<Relation>();
  @$core.pragma('dart2js:noInline')
  static Relation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Relation>(create);
  static Relation? _defaultInstance;

  /// - 1: 未关注
  /// - 2: 已关注
  /// - 3: 被关注
  /// - 4: 互相关注
  @$pb.TagNumber(1)
  $core.int get status => $_getIZ(0);
  @$pb.TagNumber(1)
  set status($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  /// 用户关注 UP 主
  ///
  /// - 0: 未关注
  /// - 1: 已关注
  @$pb.TagNumber(2)
  $core.int get isFollow => $_getIZ(1);
  @$pb.TagNumber(2)
  set isFollow($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsFollow() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsFollow() => $_clearField(2);

  ///   UP 主关注用户
  ///
  ///  - 0: 未被关注
  ///  - 1: 已被关注
  @$pb.TagNumber(3)
  $core.int get isFollowed => $_getIZ(2);
  @$pb.TagNumber(3)
  set isFollowed($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsFollowed() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsFollowed() => $_clearField(3);
}

class SharePlane extends $pb.GeneratedMessage {
  factory SharePlane({
    $core.String? title,
    $core.String? shareSubtitle,
    $core.String? desc,
    $core.String? cover,
    $fixnum.Int64? aid,
    $core.String? bvid,
    $core.Iterable<$core.MapEntry<$core.String, $core.bool>>? shareTo,
    $core.String? author,
    $fixnum.Int64? authorId,
    $core.String? shortLink,
    $core.String? playNumber,
    $fixnum.Int64? firstCid,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (shareSubtitle != null) result.shareSubtitle = shareSubtitle;
    if (desc != null) result.desc = desc;
    if (cover != null) result.cover = cover;
    if (aid != null) result.aid = aid;
    if (bvid != null) result.bvid = bvid;
    if (shareTo != null) result.shareTo.addEntries(shareTo);
    if (author != null) result.author = author;
    if (authorId != null) result.authorId = authorId;
    if (shortLink != null) result.shortLink = shortLink;
    if (playNumber != null) result.playNumber = playNumber;
    if (firstCid != null) result.firstCid = firstCid;
    return result;
  }

  SharePlane._();

  factory SharePlane.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SharePlane.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SharePlane',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'shareSubtitle')
    ..aOS(3, _omitFieldNames ? '' : 'desc')
    ..aOS(4, _omitFieldNames ? '' : 'cover')
    ..aInt64(5, _omitFieldNames ? '' : 'aid')
    ..aOS(6, _omitFieldNames ? '' : 'bvid')
    ..m<$core.String, $core.bool>(7, _omitFieldNames ? '' : 'shareTo',
        entryClassName: 'SharePlane.ShareToEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OB,
        packageName: const $pb.PackageName('bilibili.app.card.v1'))
    ..aOS(8, _omitFieldNames ? '' : 'author')
    ..aInt64(9, _omitFieldNames ? '' : 'authorId')
    ..aOS(10, _omitFieldNames ? '' : 'shortLink')
    ..aOS(11, _omitFieldNames ? '' : 'playNumber')
    ..aInt64(12, _omitFieldNames ? '' : 'firstCid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SharePlane clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SharePlane copyWith(void Function(SharePlane) updates) =>
      super.copyWith((message) => updates(message as SharePlane)) as SharePlane;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SharePlane create() => SharePlane._();
  @$core.override
  SharePlane createEmptyInstance() => create();
  static $pb.PbList<SharePlane> createRepeated() => $pb.PbList<SharePlane>();
  @$core.pragma('dart2js:noInline')
  static SharePlane getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SharePlane>(create);
  static SharePlane? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get shareSubtitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set shareSubtitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShareSubtitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearShareSubtitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get desc => $_getSZ(2);
  @$pb.TagNumber(3)
  set desc($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDesc() => $_has(2);
  @$pb.TagNumber(3)
  void clearDesc() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get cover => $_getSZ(3);
  @$pb.TagNumber(4)
  set cover($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCover() => $_has(3);
  @$pb.TagNumber(4)
  void clearCover() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get aid => $_getI64(4);
  @$pb.TagNumber(5)
  set aid($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAid() => $_has(4);
  @$pb.TagNumber(5)
  void clearAid() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get bvid => $_getSZ(5);
  @$pb.TagNumber(6)
  set bvid($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBvid() => $_has(5);
  @$pb.TagNumber(6)
  void clearBvid() => $_clearField(6);

  /// 分享渠道, 如: `"weibo": true`
  @$pb.TagNumber(7)
  $pb.PbMap<$core.String, $core.bool> get shareTo => $_getMap(6);

  @$pb.TagNumber(8)
  $core.String get author => $_getSZ(7);
  @$pb.TagNumber(8)
  set author($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAuthor() => $_has(7);
  @$pb.TagNumber(8)
  void clearAuthor() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get authorId => $_getI64(8);
  @$pb.TagNumber(9)
  set authorId($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAuthorId() => $_has(8);
  @$pb.TagNumber(9)
  void clearAuthorId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get shortLink => $_getSZ(9);
  @$pb.TagNumber(10)
  set shortLink($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasShortLink() => $_has(9);
  @$pb.TagNumber(10)
  void clearShortLink() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get playNumber => $_getSZ(10);
  @$pb.TagNumber(11)
  set playNumber($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasPlayNumber() => $_has(10);
  @$pb.TagNumber(11)
  void clearPlayNumber() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get firstCid => $_getI64(11);
  @$pb.TagNumber(12)
  set firstCid($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasFirstCid() => $_has(11);
  @$pb.TagNumber(12)
  void clearFirstCid() => $_clearField(12);
}

class SmallChannelSpecial extends $pb.GeneratedMessage {
  factory SmallChannelSpecial({
    Base? base,
    $core.String? bgCover,
    $core.String? desc1,
    $core.String? desc2,
    $core.String? badge,
    ReasonStyle? rcmdReasonStyle2,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (bgCover != null) result.bgCover = bgCover;
    if (desc1 != null) result.desc1 = desc1;
    if (desc2 != null) result.desc2 = desc2;
    if (badge != null) result.badge = badge;
    if (rcmdReasonStyle2 != null) result.rcmdReasonStyle2 = rcmdReasonStyle2;
    return result;
  }

  SmallChannelSpecial._();

  factory SmallChannelSpecial.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SmallChannelSpecial.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SmallChannelSpecial',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'bgCover')
    ..aOS(3, _omitFieldNames ? '' : 'desc1')
    ..aOS(4, _omitFieldNames ? '' : 'desc2')
    ..aOS(5, _omitFieldNames ? '' : 'badge')
    ..aOM<ReasonStyle>(6, _omitFieldNames ? '' : 'rcmdReasonStyle2',
        subBuilder: ReasonStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallChannelSpecial clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallChannelSpecial copyWith(void Function(SmallChannelSpecial) updates) =>
      super.copyWith((message) => updates(message as SmallChannelSpecial))
          as SmallChannelSpecial;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SmallChannelSpecial create() => SmallChannelSpecial._();
  @$core.override
  SmallChannelSpecial createEmptyInstance() => create();
  static $pb.PbList<SmallChannelSpecial> createRepeated() =>
      $pb.PbList<SmallChannelSpecial>();
  @$core.pragma('dart2js:noInline')
  static SmallChannelSpecial getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SmallChannelSpecial>(create);
  static SmallChannelSpecial? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get bgCover => $_getSZ(1);
  @$pb.TagNumber(2)
  set bgCover($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBgCover() => $_has(1);
  @$pb.TagNumber(2)
  void clearBgCover() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get desc1 => $_getSZ(2);
  @$pb.TagNumber(3)
  set desc1($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDesc1() => $_has(2);
  @$pb.TagNumber(3)
  void clearDesc1() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get desc2 => $_getSZ(3);
  @$pb.TagNumber(4)
  set desc2($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDesc2() => $_has(3);
  @$pb.TagNumber(4)
  void clearDesc2() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get badge => $_getSZ(4);
  @$pb.TagNumber(5)
  set badge($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBadge() => $_has(4);
  @$pb.TagNumber(5)
  void clearBadge() => $_clearField(5);

  @$pb.TagNumber(6)
  ReasonStyle get rcmdReasonStyle2 => $_getN(5);
  @$pb.TagNumber(6)
  set rcmdReasonStyle2(ReasonStyle value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRcmdReasonStyle2() => $_has(5);
  @$pb.TagNumber(6)
  void clearRcmdReasonStyle2() => $_clearField(6);
  @$pb.TagNumber(6)
  ReasonStyle ensureRcmdReasonStyle2() => $_ensure(5);
}

class SmallCoverConvergeV2 extends $pb.GeneratedMessage {
  factory SmallCoverConvergeV2({
    Base? base,
    $core.String? coverLeftText1,
    $core.int? coverLeftIcon1,
    $core.String? coverLeftText2,
    $core.int? coverLeftIcon2,
    $core.String? coverRightText,
    $core.String? coverRightTopText,
    ReasonStyle? rcmdReasonStyle,
    ReasonStyle? rcmdReasonStyleV2,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (coverLeftText1 != null) result.coverLeftText1 = coverLeftText1;
    if (coverLeftIcon1 != null) result.coverLeftIcon1 = coverLeftIcon1;
    if (coverLeftText2 != null) result.coverLeftText2 = coverLeftText2;
    if (coverLeftIcon2 != null) result.coverLeftIcon2 = coverLeftIcon2;
    if (coverRightText != null) result.coverRightText = coverRightText;
    if (coverRightTopText != null) result.coverRightTopText = coverRightTopText;
    if (rcmdReasonStyle != null) result.rcmdReasonStyle = rcmdReasonStyle;
    if (rcmdReasonStyleV2 != null) result.rcmdReasonStyleV2 = rcmdReasonStyleV2;
    return result;
  }

  SmallCoverConvergeV2._();

  factory SmallCoverConvergeV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SmallCoverConvergeV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SmallCoverConvergeV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'coverLeftText1')
    ..aI(3, _omitFieldNames ? '' : 'coverLeftIcon1')
    ..aOS(4, _omitFieldNames ? '' : 'coverLeftText2')
    ..aI(5, _omitFieldNames ? '' : 'coverLeftIcon2')
    ..aOS(6, _omitFieldNames ? '' : 'coverRightText')
    ..aOS(7, _omitFieldNames ? '' : 'coverRightTopText')
    ..aOM<ReasonStyle>(8, _omitFieldNames ? '' : 'rcmdReasonStyle',
        subBuilder: ReasonStyle.create)
    ..aOM<ReasonStyle>(9, _omitFieldNames ? '' : 'rcmdReasonStyleV2',
        subBuilder: ReasonStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallCoverConvergeV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallCoverConvergeV2 copyWith(void Function(SmallCoverConvergeV2) updates) =>
      super.copyWith((message) => updates(message as SmallCoverConvergeV2))
          as SmallCoverConvergeV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SmallCoverConvergeV2 create() => SmallCoverConvergeV2._();
  @$core.override
  SmallCoverConvergeV2 createEmptyInstance() => create();
  static $pb.PbList<SmallCoverConvergeV2> createRepeated() =>
      $pb.PbList<SmallCoverConvergeV2>();
  @$core.pragma('dart2js:noInline')
  static SmallCoverConvergeV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SmallCoverConvergeV2>(create);
  static SmallCoverConvergeV2? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get coverLeftText1 => $_getSZ(1);
  @$pb.TagNumber(2)
  set coverLeftText1($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCoverLeftText1() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoverLeftText1() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get coverLeftIcon1 => $_getIZ(2);
  @$pb.TagNumber(3)
  set coverLeftIcon1($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCoverLeftIcon1() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoverLeftIcon1() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get coverLeftText2 => $_getSZ(3);
  @$pb.TagNumber(4)
  set coverLeftText2($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverLeftText2() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverLeftText2() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get coverLeftIcon2 => $_getIZ(4);
  @$pb.TagNumber(5)
  set coverLeftIcon2($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCoverLeftIcon2() => $_has(4);
  @$pb.TagNumber(5)
  void clearCoverLeftIcon2() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get coverRightText => $_getSZ(5);
  @$pb.TagNumber(6)
  set coverRightText($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCoverRightText() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoverRightText() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get coverRightTopText => $_getSZ(6);
  @$pb.TagNumber(7)
  set coverRightTopText($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCoverRightTopText() => $_has(6);
  @$pb.TagNumber(7)
  void clearCoverRightTopText() => $_clearField(7);

  @$pb.TagNumber(8)
  ReasonStyle get rcmdReasonStyle => $_getN(7);
  @$pb.TagNumber(8)
  set rcmdReasonStyle(ReasonStyle value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRcmdReasonStyle() => $_has(7);
  @$pb.TagNumber(8)
  void clearRcmdReasonStyle() => $_clearField(8);
  @$pb.TagNumber(8)
  ReasonStyle ensureRcmdReasonStyle() => $_ensure(7);

  @$pb.TagNumber(9)
  ReasonStyle get rcmdReasonStyleV2 => $_getN(8);
  @$pb.TagNumber(9)
  set rcmdReasonStyleV2(ReasonStyle value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasRcmdReasonStyleV2() => $_has(8);
  @$pb.TagNumber(9)
  void clearRcmdReasonStyleV2() => $_clearField(9);
  @$pb.TagNumber(9)
  ReasonStyle ensureRcmdReasonStyleV2() => $_ensure(8);
}

class SmallCoverRcmdItem extends $pb.GeneratedMessage {
  factory SmallCoverRcmdItem({
    $core.String? title,
    $core.String? cover,
    $core.String? uri,
    $core.String? param,
    $core.String? goto,
    $core.String? coverRightText1,
    $core.String? rightDesc1,
    $core.String? rightDesc2,
    $core.String? coverGif,
    $core.int? rightIcon1,
    $core.int? rightIcon2,
    $core.String? coverRightTextContentDescription,
    $core.String? rightDesc1ContentDescription,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (cover != null) result.cover = cover;
    if (uri != null) result.uri = uri;
    if (param != null) result.param = param;
    if (goto != null) result.goto = goto;
    if (coverRightText1 != null) result.coverRightText1 = coverRightText1;
    if (rightDesc1 != null) result.rightDesc1 = rightDesc1;
    if (rightDesc2 != null) result.rightDesc2 = rightDesc2;
    if (coverGif != null) result.coverGif = coverGif;
    if (rightIcon1 != null) result.rightIcon1 = rightIcon1;
    if (rightIcon2 != null) result.rightIcon2 = rightIcon2;
    if (coverRightTextContentDescription != null)
      result.coverRightTextContentDescription =
          coverRightTextContentDescription;
    if (rightDesc1ContentDescription != null)
      result.rightDesc1ContentDescription = rightDesc1ContentDescription;
    return result;
  }

  SmallCoverRcmdItem._();

  factory SmallCoverRcmdItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SmallCoverRcmdItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SmallCoverRcmdItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'cover')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..aOS(4, _omitFieldNames ? '' : 'param')
    ..aOS(5, _omitFieldNames ? '' : 'goto')
    ..aOS(6, _omitFieldNames ? '' : 'coverRightText1')
    ..aOS(7, _omitFieldNames ? '' : 'rightDesc1')
    ..aOS(8, _omitFieldNames ? '' : 'rightDesc2')
    ..aOS(9, _omitFieldNames ? '' : 'coverGif')
    ..aI(10, _omitFieldNames ? '' : 'rightIcon1')
    ..aI(11, _omitFieldNames ? '' : 'rightIcon2')
    ..aOS(12, _omitFieldNames ? '' : 'coverRightTextContentDescription')
    ..aOS(13, _omitFieldNames ? '' : 'rightDesc1ContentDescription')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallCoverRcmdItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallCoverRcmdItem copyWith(void Function(SmallCoverRcmdItem) updates) =>
      super.copyWith((message) => updates(message as SmallCoverRcmdItem))
          as SmallCoverRcmdItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SmallCoverRcmdItem create() => SmallCoverRcmdItem._();
  @$core.override
  SmallCoverRcmdItem createEmptyInstance() => create();
  static $pb.PbList<SmallCoverRcmdItem> createRepeated() =>
      $pb.PbList<SmallCoverRcmdItem>();
  @$core.pragma('dart2js:noInline')
  static SmallCoverRcmdItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SmallCoverRcmdItem>(create);
  static SmallCoverRcmdItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cover => $_getSZ(1);
  @$pb.TagNumber(2)
  set cover($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCover() => $_has(1);
  @$pb.TagNumber(2)
  void clearCover() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get param => $_getSZ(3);
  @$pb.TagNumber(4)
  set param($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParam() => $_has(3);
  @$pb.TagNumber(4)
  void clearParam() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get goto => $_getSZ(4);
  @$pb.TagNumber(5)
  set goto($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasGoto() => $_has(4);
  @$pb.TagNumber(5)
  void clearGoto() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get coverRightText1 => $_getSZ(5);
  @$pb.TagNumber(6)
  set coverRightText1($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCoverRightText1() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoverRightText1() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get rightDesc1 => $_getSZ(6);
  @$pb.TagNumber(7)
  set rightDesc1($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRightDesc1() => $_has(6);
  @$pb.TagNumber(7)
  void clearRightDesc1() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get rightDesc2 => $_getSZ(7);
  @$pb.TagNumber(8)
  set rightDesc2($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRightDesc2() => $_has(7);
  @$pb.TagNumber(8)
  void clearRightDesc2() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get coverGif => $_getSZ(8);
  @$pb.TagNumber(9)
  set coverGif($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCoverGif() => $_has(8);
  @$pb.TagNumber(9)
  void clearCoverGif() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get rightIcon1 => $_getIZ(9);
  @$pb.TagNumber(10)
  set rightIcon1($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRightIcon1() => $_has(9);
  @$pb.TagNumber(10)
  void clearRightIcon1() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get rightIcon2 => $_getIZ(10);
  @$pb.TagNumber(11)
  set rightIcon2($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRightIcon2() => $_has(10);
  @$pb.TagNumber(11)
  void clearRightIcon2() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get coverRightTextContentDescription => $_getSZ(11);
  @$pb.TagNumber(12)
  set coverRightTextContentDescription($core.String value) =>
      $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasCoverRightTextContentDescription() => $_has(11);
  @$pb.TagNumber(12)
  void clearCoverRightTextContentDescription() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get rightDesc1ContentDescription => $_getSZ(12);
  @$pb.TagNumber(13)
  set rightDesc1ContentDescription($core.String value) =>
      $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRightDesc1ContentDescription() => $_has(12);
  @$pb.TagNumber(13)
  void clearRightDesc1ContentDescription() => $_clearField(13);
}

class SmallCoverV2 extends $pb.GeneratedMessage {
  factory SmallCoverV2({
    Base? base,
    $core.String? coverGif,
    $core.int? coverBlur,
    $core.String? coverLeftText1,
    $core.int? coverLeftIcon1,
    $core.String? coverLeftText2,
    $core.int? coverLeftIcon2,
    $core.String? coverRightText,
    $core.int? coverRightIcon,
    $core.String? coverRightBackgroundColor,
    $core.String? subtitle,
    $core.String? badge,
    $core.String? rcmdReason,
    $core.String? desc,
    Avatar? avatar,
    $core.int? officialIcon,
    $core.int? canPlay,
    ReasonStyle? rcmdReasonStyle,
    ReasonStyle? rcmdReasonStyleV2,
    LikeButton? likeButton,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (coverGif != null) result.coverGif = coverGif;
    if (coverBlur != null) result.coverBlur = coverBlur;
    if (coverLeftText1 != null) result.coverLeftText1 = coverLeftText1;
    if (coverLeftIcon1 != null) result.coverLeftIcon1 = coverLeftIcon1;
    if (coverLeftText2 != null) result.coverLeftText2 = coverLeftText2;
    if (coverLeftIcon2 != null) result.coverLeftIcon2 = coverLeftIcon2;
    if (coverRightText != null) result.coverRightText = coverRightText;
    if (coverRightIcon != null) result.coverRightIcon = coverRightIcon;
    if (coverRightBackgroundColor != null)
      result.coverRightBackgroundColor = coverRightBackgroundColor;
    if (subtitle != null) result.subtitle = subtitle;
    if (badge != null) result.badge = badge;
    if (rcmdReason != null) result.rcmdReason = rcmdReason;
    if (desc != null) result.desc = desc;
    if (avatar != null) result.avatar = avatar;
    if (officialIcon != null) result.officialIcon = officialIcon;
    if (canPlay != null) result.canPlay = canPlay;
    if (rcmdReasonStyle != null) result.rcmdReasonStyle = rcmdReasonStyle;
    if (rcmdReasonStyleV2 != null) result.rcmdReasonStyleV2 = rcmdReasonStyleV2;
    if (likeButton != null) result.likeButton = likeButton;
    return result;
  }

  SmallCoverV2._();

  factory SmallCoverV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SmallCoverV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SmallCoverV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'coverGif')
    ..aI(3, _omitFieldNames ? '' : 'coverBlur')
    ..aOS(4, _omitFieldNames ? '' : 'coverLeftText1')
    ..aI(5, _omitFieldNames ? '' : 'coverLeftIcon1')
    ..aOS(6, _omitFieldNames ? '' : 'coverLeftText2')
    ..aI(7, _omitFieldNames ? '' : 'coverLeftIcon2')
    ..aOS(8, _omitFieldNames ? '' : 'coverRightText')
    ..aI(9, _omitFieldNames ? '' : 'coverRightIcon')
    ..aOS(10, _omitFieldNames ? '' : 'coverRightBackgroundColor')
    ..aOS(11, _omitFieldNames ? '' : 'subtitle')
    ..aOS(12, _omitFieldNames ? '' : 'badge')
    ..aOS(13, _omitFieldNames ? '' : 'rcmdReason')
    ..aOS(14, _omitFieldNames ? '' : 'desc')
    ..aOM<Avatar>(15, _omitFieldNames ? '' : 'avatar',
        subBuilder: Avatar.create)
    ..aI(16, _omitFieldNames ? '' : 'officialIcon')
    ..aI(17, _omitFieldNames ? '' : 'canPlay')
    ..aOM<ReasonStyle>(18, _omitFieldNames ? '' : 'rcmdReasonStyle',
        subBuilder: ReasonStyle.create)
    ..aOM<ReasonStyle>(19, _omitFieldNames ? '' : 'rcmdReasonStyleV2',
        subBuilder: ReasonStyle.create)
    ..aOM<LikeButton>(20, _omitFieldNames ? '' : 'likeButton',
        subBuilder: LikeButton.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallCoverV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallCoverV2 copyWith(void Function(SmallCoverV2) updates) =>
      super.copyWith((message) => updates(message as SmallCoverV2))
          as SmallCoverV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SmallCoverV2 create() => SmallCoverV2._();
  @$core.override
  SmallCoverV2 createEmptyInstance() => create();
  static $pb.PbList<SmallCoverV2> createRepeated() =>
      $pb.PbList<SmallCoverV2>();
  @$core.pragma('dart2js:noInline')
  static SmallCoverV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SmallCoverV2>(create);
  static SmallCoverV2? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get coverGif => $_getSZ(1);
  @$pb.TagNumber(2)
  set coverGif($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCoverGif() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoverGif() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get coverBlur => $_getIZ(2);
  @$pb.TagNumber(3)
  set coverBlur($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCoverBlur() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoverBlur() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get coverLeftText1 => $_getSZ(3);
  @$pb.TagNumber(4)
  set coverLeftText1($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverLeftText1() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverLeftText1() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get coverLeftIcon1 => $_getIZ(4);
  @$pb.TagNumber(5)
  set coverLeftIcon1($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCoverLeftIcon1() => $_has(4);
  @$pb.TagNumber(5)
  void clearCoverLeftIcon1() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get coverLeftText2 => $_getSZ(5);
  @$pb.TagNumber(6)
  set coverLeftText2($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCoverLeftText2() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoverLeftText2() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get coverLeftIcon2 => $_getIZ(6);
  @$pb.TagNumber(7)
  set coverLeftIcon2($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCoverLeftIcon2() => $_has(6);
  @$pb.TagNumber(7)
  void clearCoverLeftIcon2() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get coverRightText => $_getSZ(7);
  @$pb.TagNumber(8)
  set coverRightText($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCoverRightText() => $_has(7);
  @$pb.TagNumber(8)
  void clearCoverRightText() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get coverRightIcon => $_getIZ(8);
  @$pb.TagNumber(9)
  set coverRightIcon($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCoverRightIcon() => $_has(8);
  @$pb.TagNumber(9)
  void clearCoverRightIcon() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get coverRightBackgroundColor => $_getSZ(9);
  @$pb.TagNumber(10)
  set coverRightBackgroundColor($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCoverRightBackgroundColor() => $_has(9);
  @$pb.TagNumber(10)
  void clearCoverRightBackgroundColor() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get subtitle => $_getSZ(10);
  @$pb.TagNumber(11)
  set subtitle($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSubtitle() => $_has(10);
  @$pb.TagNumber(11)
  void clearSubtitle() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get badge => $_getSZ(11);
  @$pb.TagNumber(12)
  set badge($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasBadge() => $_has(11);
  @$pb.TagNumber(12)
  void clearBadge() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get rcmdReason => $_getSZ(12);
  @$pb.TagNumber(13)
  set rcmdReason($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRcmdReason() => $_has(12);
  @$pb.TagNumber(13)
  void clearRcmdReason() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get desc => $_getSZ(13);
  @$pb.TagNumber(14)
  set desc($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasDesc() => $_has(13);
  @$pb.TagNumber(14)
  void clearDesc() => $_clearField(14);

  @$pb.TagNumber(15)
  Avatar get avatar => $_getN(14);
  @$pb.TagNumber(15)
  set avatar(Avatar value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasAvatar() => $_has(14);
  @$pb.TagNumber(15)
  void clearAvatar() => $_clearField(15);
  @$pb.TagNumber(15)
  Avatar ensureAvatar() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.int get officialIcon => $_getIZ(15);
  @$pb.TagNumber(16)
  set officialIcon($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasOfficialIcon() => $_has(15);
  @$pb.TagNumber(16)
  void clearOfficialIcon() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.int get canPlay => $_getIZ(16);
  @$pb.TagNumber(17)
  set canPlay($core.int value) => $_setSignedInt32(16, value);
  @$pb.TagNumber(17)
  $core.bool hasCanPlay() => $_has(16);
  @$pb.TagNumber(17)
  void clearCanPlay() => $_clearField(17);

  @$pb.TagNumber(18)
  ReasonStyle get rcmdReasonStyle => $_getN(17);
  @$pb.TagNumber(18)
  set rcmdReasonStyle(ReasonStyle value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasRcmdReasonStyle() => $_has(17);
  @$pb.TagNumber(18)
  void clearRcmdReasonStyle() => $_clearField(18);
  @$pb.TagNumber(18)
  ReasonStyle ensureRcmdReasonStyle() => $_ensure(17);

  @$pb.TagNumber(19)
  ReasonStyle get rcmdReasonStyleV2 => $_getN(18);
  @$pb.TagNumber(19)
  set rcmdReasonStyleV2(ReasonStyle value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasRcmdReasonStyleV2() => $_has(18);
  @$pb.TagNumber(19)
  void clearRcmdReasonStyleV2() => $_clearField(19);
  @$pb.TagNumber(19)
  ReasonStyle ensureRcmdReasonStyleV2() => $_ensure(18);

  @$pb.TagNumber(20)
  LikeButton get likeButton => $_getN(19);
  @$pb.TagNumber(20)
  set likeButton(LikeButton value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasLikeButton() => $_has(19);
  @$pb.TagNumber(20)
  void clearLikeButton() => $_clearField(20);
  @$pb.TagNumber(20)
  LikeButton ensureLikeButton() => $_ensure(19);
}

class SmallCoverV3 extends $pb.GeneratedMessage {
  factory SmallCoverV3({
    Base? base,
    Avatar? avatar,
    $core.String? coverLeftText,
    Button? coverRightButton,
    $core.String? rcmdReason,
    $core.String? desc,
    $core.int? officialIcon,
    $core.int? canPlay,
    ReasonStyle? rcmdReasonStyle,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (avatar != null) result.avatar = avatar;
    if (coverLeftText != null) result.coverLeftText = coverLeftText;
    if (coverRightButton != null) result.coverRightButton = coverRightButton;
    if (rcmdReason != null) result.rcmdReason = rcmdReason;
    if (desc != null) result.desc = desc;
    if (officialIcon != null) result.officialIcon = officialIcon;
    if (canPlay != null) result.canPlay = canPlay;
    if (rcmdReasonStyle != null) result.rcmdReasonStyle = rcmdReasonStyle;
    return result;
  }

  SmallCoverV3._();

  factory SmallCoverV3.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SmallCoverV3.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SmallCoverV3',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOM<Avatar>(2, _omitFieldNames ? '' : 'avatar', subBuilder: Avatar.create)
    ..aOS(3, _omitFieldNames ? '' : 'coverLeftText')
    ..aOM<Button>(4, _omitFieldNames ? '' : 'coverRightButton',
        subBuilder: Button.create)
    ..aOS(5, _omitFieldNames ? '' : 'rcmdReason')
    ..aOS(6, _omitFieldNames ? '' : 'desc')
    ..aI(7, _omitFieldNames ? '' : 'officialIcon')
    ..aI(8, _omitFieldNames ? '' : 'canPlay')
    ..aOM<ReasonStyle>(9, _omitFieldNames ? '' : 'rcmdReasonStyle',
        subBuilder: ReasonStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallCoverV3 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallCoverV3 copyWith(void Function(SmallCoverV3) updates) =>
      super.copyWith((message) => updates(message as SmallCoverV3))
          as SmallCoverV3;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SmallCoverV3 create() => SmallCoverV3._();
  @$core.override
  SmallCoverV3 createEmptyInstance() => create();
  static $pb.PbList<SmallCoverV3> createRepeated() =>
      $pb.PbList<SmallCoverV3>();
  @$core.pragma('dart2js:noInline')
  static SmallCoverV3 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SmallCoverV3>(create);
  static SmallCoverV3? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  Avatar get avatar => $_getN(1);
  @$pb.TagNumber(2)
  set avatar(Avatar value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAvatar() => $_has(1);
  @$pb.TagNumber(2)
  void clearAvatar() => $_clearField(2);
  @$pb.TagNumber(2)
  Avatar ensureAvatar() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get coverLeftText => $_getSZ(2);
  @$pb.TagNumber(3)
  set coverLeftText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCoverLeftText() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoverLeftText() => $_clearField(3);

  @$pb.TagNumber(4)
  Button get coverRightButton => $_getN(3);
  @$pb.TagNumber(4)
  set coverRightButton(Button value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverRightButton() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverRightButton() => $_clearField(4);
  @$pb.TagNumber(4)
  Button ensureCoverRightButton() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get rcmdReason => $_getSZ(4);
  @$pb.TagNumber(5)
  set rcmdReason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRcmdReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearRcmdReason() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get desc => $_getSZ(5);
  @$pb.TagNumber(6)
  set desc($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDesc() => $_has(5);
  @$pb.TagNumber(6)
  void clearDesc() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get officialIcon => $_getIZ(6);
  @$pb.TagNumber(7)
  set officialIcon($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOfficialIcon() => $_has(6);
  @$pb.TagNumber(7)
  void clearOfficialIcon() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get canPlay => $_getIZ(7);
  @$pb.TagNumber(8)
  set canPlay($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCanPlay() => $_has(7);
  @$pb.TagNumber(8)
  void clearCanPlay() => $_clearField(8);

  @$pb.TagNumber(9)
  ReasonStyle get rcmdReasonStyle => $_getN(8);
  @$pb.TagNumber(9)
  set rcmdReasonStyle(ReasonStyle value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasRcmdReasonStyle() => $_has(8);
  @$pb.TagNumber(9)
  void clearRcmdReasonStyle() => $_clearField(9);
  @$pb.TagNumber(9)
  ReasonStyle ensureRcmdReasonStyle() => $_ensure(8);
}

class SmallCoverV4 extends $pb.GeneratedMessage {
  factory SmallCoverV4({
    Base? base,
    $core.String? coverBadge,
    $core.String? desc,
    $core.String? titleRightText,
    $core.int? titleRightPic,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (coverBadge != null) result.coverBadge = coverBadge;
    if (desc != null) result.desc = desc;
    if (titleRightText != null) result.titleRightText = titleRightText;
    if (titleRightPic != null) result.titleRightPic = titleRightPic;
    return result;
  }

  SmallCoverV4._();

  factory SmallCoverV4.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SmallCoverV4.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SmallCoverV4',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'coverBadge')
    ..aOS(3, _omitFieldNames ? '' : 'desc')
    ..aOS(4, _omitFieldNames ? '' : 'titleRightText')
    ..aI(5, _omitFieldNames ? '' : 'titleRightPic')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallCoverV4 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallCoverV4 copyWith(void Function(SmallCoverV4) updates) =>
      super.copyWith((message) => updates(message as SmallCoverV4))
          as SmallCoverV4;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SmallCoverV4 create() => SmallCoverV4._();
  @$core.override
  SmallCoverV4 createEmptyInstance() => create();
  static $pb.PbList<SmallCoverV4> createRepeated() =>
      $pb.PbList<SmallCoverV4>();
  @$core.pragma('dart2js:noInline')
  static SmallCoverV4 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SmallCoverV4>(create);
  static SmallCoverV4? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get coverBadge => $_getSZ(1);
  @$pb.TagNumber(2)
  set coverBadge($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCoverBadge() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoverBadge() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get desc => $_getSZ(2);
  @$pb.TagNumber(3)
  set desc($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDesc() => $_has(2);
  @$pb.TagNumber(3)
  void clearDesc() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get titleRightText => $_getSZ(3);
  @$pb.TagNumber(4)
  set titleRightText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitleRightText() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitleRightText() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get titleRightPic => $_getIZ(4);
  @$pb.TagNumber(5)
  set titleRightPic($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitleRightPic() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitleRightPic() => $_clearField(5);
}

class SmallCoverV5 extends $pb.GeneratedMessage {
  factory SmallCoverV5({
    Base? base,
    $core.String? coverGif,
    Up? up,
    $core.String? coverRightText1,
    $core.String? rightDesc1,
    $core.String? rightDesc2,
    ReasonStyle? rcmdReasonStyle,
    HotwordEntrance? hotwordEntrance,
    ReasonStyle? cornerMarkStyle,
    $core.int? rightIcon1,
    $core.int? rightIcon2,
    ReasonStyle? leftCornerMarkStyle,
    $core.String? coverRightTextContentDescription,
    $core.String? rightDesc1ContentDescription,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (coverGif != null) result.coverGif = coverGif;
    if (up != null) result.up = up;
    if (coverRightText1 != null) result.coverRightText1 = coverRightText1;
    if (rightDesc1 != null) result.rightDesc1 = rightDesc1;
    if (rightDesc2 != null) result.rightDesc2 = rightDesc2;
    if (rcmdReasonStyle != null) result.rcmdReasonStyle = rcmdReasonStyle;
    if (hotwordEntrance != null) result.hotwordEntrance = hotwordEntrance;
    if (cornerMarkStyle != null) result.cornerMarkStyle = cornerMarkStyle;
    if (rightIcon1 != null) result.rightIcon1 = rightIcon1;
    if (rightIcon2 != null) result.rightIcon2 = rightIcon2;
    if (leftCornerMarkStyle != null)
      result.leftCornerMarkStyle = leftCornerMarkStyle;
    if (coverRightTextContentDescription != null)
      result.coverRightTextContentDescription =
          coverRightTextContentDescription;
    if (rightDesc1ContentDescription != null)
      result.rightDesc1ContentDescription = rightDesc1ContentDescription;
    return result;
  }

  SmallCoverV5._();

  factory SmallCoverV5.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SmallCoverV5.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SmallCoverV5',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'coverGif')
    ..aOM<Up>(3, _omitFieldNames ? '' : 'up', subBuilder: Up.create)
    ..aOS(4, _omitFieldNames ? '' : 'coverRightText1')
    ..aOS(5, _omitFieldNames ? '' : 'rightDesc1')
    ..aOS(6, _omitFieldNames ? '' : 'rightDesc2')
    ..aOM<ReasonStyle>(7, _omitFieldNames ? '' : 'rcmdReasonStyle',
        subBuilder: ReasonStyle.create)
    ..aOM<HotwordEntrance>(8, _omitFieldNames ? '' : 'hotwordEntrance',
        subBuilder: HotwordEntrance.create)
    ..aOM<ReasonStyle>(9, _omitFieldNames ? '' : 'cornerMarkStyle',
        subBuilder: ReasonStyle.create)
    ..aI(10, _omitFieldNames ? '' : 'rightIcon1')
    ..aI(11, _omitFieldNames ? '' : 'rightIcon2')
    ..aOM<ReasonStyle>(12, _omitFieldNames ? '' : 'leftCornerMarkStyle',
        subBuilder: ReasonStyle.create)
    ..aOS(13, _omitFieldNames ? '' : 'coverRightTextContentDescription')
    ..aOS(14, _omitFieldNames ? '' : 'rightDesc1ContentDescription')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallCoverV5 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallCoverV5 copyWith(void Function(SmallCoverV5) updates) =>
      super.copyWith((message) => updates(message as SmallCoverV5))
          as SmallCoverV5;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SmallCoverV5 create() => SmallCoverV5._();
  @$core.override
  SmallCoverV5 createEmptyInstance() => create();
  static $pb.PbList<SmallCoverV5> createRepeated() =>
      $pb.PbList<SmallCoverV5>();
  @$core.pragma('dart2js:noInline')
  static SmallCoverV5 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SmallCoverV5>(create);
  static SmallCoverV5? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get coverGif => $_getSZ(1);
  @$pb.TagNumber(2)
  set coverGif($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCoverGif() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoverGif() => $_clearField(2);

  @$pb.TagNumber(3)
  Up get up => $_getN(2);
  @$pb.TagNumber(3)
  set up(Up value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUp() => $_has(2);
  @$pb.TagNumber(3)
  void clearUp() => $_clearField(3);
  @$pb.TagNumber(3)
  Up ensureUp() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get coverRightText1 => $_getSZ(3);
  @$pb.TagNumber(4)
  set coverRightText1($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverRightText1() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverRightText1() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get rightDesc1 => $_getSZ(4);
  @$pb.TagNumber(5)
  set rightDesc1($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRightDesc1() => $_has(4);
  @$pb.TagNumber(5)
  void clearRightDesc1() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get rightDesc2 => $_getSZ(5);
  @$pb.TagNumber(6)
  set rightDesc2($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRightDesc2() => $_has(5);
  @$pb.TagNumber(6)
  void clearRightDesc2() => $_clearField(6);

  @$pb.TagNumber(7)
  ReasonStyle get rcmdReasonStyle => $_getN(6);
  @$pb.TagNumber(7)
  set rcmdReasonStyle(ReasonStyle value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasRcmdReasonStyle() => $_has(6);
  @$pb.TagNumber(7)
  void clearRcmdReasonStyle() => $_clearField(7);
  @$pb.TagNumber(7)
  ReasonStyle ensureRcmdReasonStyle() => $_ensure(6);

  @$pb.TagNumber(8)
  HotwordEntrance get hotwordEntrance => $_getN(7);
  @$pb.TagNumber(8)
  set hotwordEntrance(HotwordEntrance value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasHotwordEntrance() => $_has(7);
  @$pb.TagNumber(8)
  void clearHotwordEntrance() => $_clearField(8);
  @$pb.TagNumber(8)
  HotwordEntrance ensureHotwordEntrance() => $_ensure(7);

  /// 直播小卡角标
  @$pb.TagNumber(9)
  ReasonStyle get cornerMarkStyle => $_getN(8);
  @$pb.TagNumber(9)
  set cornerMarkStyle(ReasonStyle value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCornerMarkStyle() => $_has(8);
  @$pb.TagNumber(9)
  void clearCornerMarkStyle() => $_clearField(9);
  @$pb.TagNumber(9)
  ReasonStyle ensureCornerMarkStyle() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.int get rightIcon1 => $_getIZ(9);
  @$pb.TagNumber(10)
  set rightIcon1($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRightIcon1() => $_has(9);
  @$pb.TagNumber(10)
  void clearRightIcon1() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get rightIcon2 => $_getIZ(10);
  @$pb.TagNumber(11)
  set rightIcon2($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRightIcon2() => $_has(10);
  @$pb.TagNumber(11)
  void clearRightIcon2() => $_clearField(11);

  @$pb.TagNumber(12)
  ReasonStyle get leftCornerMarkStyle => $_getN(11);
  @$pb.TagNumber(12)
  set leftCornerMarkStyle(ReasonStyle value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasLeftCornerMarkStyle() => $_has(11);
  @$pb.TagNumber(12)
  void clearLeftCornerMarkStyle() => $_clearField(12);
  @$pb.TagNumber(12)
  ReasonStyle ensureLeftCornerMarkStyle() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get coverRightTextContentDescription => $_getSZ(12);
  @$pb.TagNumber(13)
  set coverRightTextContentDescription($core.String value) =>
      $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCoverRightTextContentDescription() => $_has(12);
  @$pb.TagNumber(13)
  void clearCoverRightTextContentDescription() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get rightDesc1ContentDescription => $_getSZ(13);
  @$pb.TagNumber(14)
  set rightDesc1ContentDescription($core.String value) =>
      $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasRightDesc1ContentDescription() => $_has(13);
  @$pb.TagNumber(14)
  void clearRightDesc1ContentDescription() => $_clearField(14);
}

class SmallCoverV5Ad extends $pb.GeneratedMessage {
  factory SmallCoverV5Ad({
    Base? base,
    $core.String? coverGif,
    Up? up,
    $core.String? coverRightText1,
    $core.String? rightDesc1,
    $core.String? rightDesc2,
    ReasonStyle? rcmdReasonStyle,
    HotwordEntrance? hotwordEntrance,
    ReasonStyle? cornerMarkStyle,
    $core.int? rightIcon1,
    $core.int? rightIcon2,
    ReasonStyle? leftCornerMarkStyle,
    $core.String? coverRightTextContentDescription,
    $core.String? rightDesc1ContentDescription,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (coverGif != null) result.coverGif = coverGif;
    if (up != null) result.up = up;
    if (coverRightText1 != null) result.coverRightText1 = coverRightText1;
    if (rightDesc1 != null) result.rightDesc1 = rightDesc1;
    if (rightDesc2 != null) result.rightDesc2 = rightDesc2;
    if (rcmdReasonStyle != null) result.rcmdReasonStyle = rcmdReasonStyle;
    if (hotwordEntrance != null) result.hotwordEntrance = hotwordEntrance;
    if (cornerMarkStyle != null) result.cornerMarkStyle = cornerMarkStyle;
    if (rightIcon1 != null) result.rightIcon1 = rightIcon1;
    if (rightIcon2 != null) result.rightIcon2 = rightIcon2;
    if (leftCornerMarkStyle != null)
      result.leftCornerMarkStyle = leftCornerMarkStyle;
    if (coverRightTextContentDescription != null)
      result.coverRightTextContentDescription =
          coverRightTextContentDescription;
    if (rightDesc1ContentDescription != null)
      result.rightDesc1ContentDescription = rightDesc1ContentDescription;
    return result;
  }

  SmallCoverV5Ad._();

  factory SmallCoverV5Ad.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SmallCoverV5Ad.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SmallCoverV5Ad',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'coverGif')
    ..aOM<Up>(3, _omitFieldNames ? '' : 'up', subBuilder: Up.create)
    ..aOS(4, _omitFieldNames ? '' : 'coverRightText1')
    ..aOS(5, _omitFieldNames ? '' : 'rightDesc1')
    ..aOS(6, _omitFieldNames ? '' : 'rightDesc2')
    ..aOM<ReasonStyle>(7, _omitFieldNames ? '' : 'rcmdReasonStyle',
        subBuilder: ReasonStyle.create)
    ..aOM<HotwordEntrance>(8, _omitFieldNames ? '' : 'hotwordEntrance',
        subBuilder: HotwordEntrance.create)
    ..aOM<ReasonStyle>(9, _omitFieldNames ? '' : 'cornerMarkStyle',
        subBuilder: ReasonStyle.create)
    ..aI(10, _omitFieldNames ? '' : 'rightIcon1')
    ..aI(11, _omitFieldNames ? '' : 'rightIcon2')
    ..aOM<ReasonStyle>(12, _omitFieldNames ? '' : 'leftCornerMarkStyle',
        subBuilder: ReasonStyle.create)
    ..aOS(13, _omitFieldNames ? '' : 'coverRightTextContentDescription')
    ..aOS(14, _omitFieldNames ? '' : 'rightDesc1ContentDescription')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallCoverV5Ad clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallCoverV5Ad copyWith(void Function(SmallCoverV5Ad) updates) =>
      super.copyWith((message) => updates(message as SmallCoverV5Ad))
          as SmallCoverV5Ad;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SmallCoverV5Ad create() => SmallCoverV5Ad._();
  @$core.override
  SmallCoverV5Ad createEmptyInstance() => create();
  static $pb.PbList<SmallCoverV5Ad> createRepeated() =>
      $pb.PbList<SmallCoverV5Ad>();
  @$core.pragma('dart2js:noInline')
  static SmallCoverV5Ad getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SmallCoverV5Ad>(create);
  static SmallCoverV5Ad? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get coverGif => $_getSZ(1);
  @$pb.TagNumber(2)
  set coverGif($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCoverGif() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoverGif() => $_clearField(2);

  @$pb.TagNumber(3)
  Up get up => $_getN(2);
  @$pb.TagNumber(3)
  set up(Up value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUp() => $_has(2);
  @$pb.TagNumber(3)
  void clearUp() => $_clearField(3);
  @$pb.TagNumber(3)
  Up ensureUp() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get coverRightText1 => $_getSZ(3);
  @$pb.TagNumber(4)
  set coverRightText1($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverRightText1() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverRightText1() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get rightDesc1 => $_getSZ(4);
  @$pb.TagNumber(5)
  set rightDesc1($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRightDesc1() => $_has(4);
  @$pb.TagNumber(5)
  void clearRightDesc1() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get rightDesc2 => $_getSZ(5);
  @$pb.TagNumber(6)
  set rightDesc2($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRightDesc2() => $_has(5);
  @$pb.TagNumber(6)
  void clearRightDesc2() => $_clearField(6);

  @$pb.TagNumber(7)
  ReasonStyle get rcmdReasonStyle => $_getN(6);
  @$pb.TagNumber(7)
  set rcmdReasonStyle(ReasonStyle value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasRcmdReasonStyle() => $_has(6);
  @$pb.TagNumber(7)
  void clearRcmdReasonStyle() => $_clearField(7);
  @$pb.TagNumber(7)
  ReasonStyle ensureRcmdReasonStyle() => $_ensure(6);

  @$pb.TagNumber(8)
  HotwordEntrance get hotwordEntrance => $_getN(7);
  @$pb.TagNumber(8)
  set hotwordEntrance(HotwordEntrance value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasHotwordEntrance() => $_has(7);
  @$pb.TagNumber(8)
  void clearHotwordEntrance() => $_clearField(8);
  @$pb.TagNumber(8)
  HotwordEntrance ensureHotwordEntrance() => $_ensure(7);

  @$pb.TagNumber(9)
  ReasonStyle get cornerMarkStyle => $_getN(8);
  @$pb.TagNumber(9)
  set cornerMarkStyle(ReasonStyle value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCornerMarkStyle() => $_has(8);
  @$pb.TagNumber(9)
  void clearCornerMarkStyle() => $_clearField(9);
  @$pb.TagNumber(9)
  ReasonStyle ensureCornerMarkStyle() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.int get rightIcon1 => $_getIZ(9);
  @$pb.TagNumber(10)
  set rightIcon1($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRightIcon1() => $_has(9);
  @$pb.TagNumber(10)
  void clearRightIcon1() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get rightIcon2 => $_getIZ(10);
  @$pb.TagNumber(11)
  set rightIcon2($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRightIcon2() => $_has(10);
  @$pb.TagNumber(11)
  void clearRightIcon2() => $_clearField(11);

  @$pb.TagNumber(12)
  ReasonStyle get leftCornerMarkStyle => $_getN(11);
  @$pb.TagNumber(12)
  set leftCornerMarkStyle(ReasonStyle value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasLeftCornerMarkStyle() => $_has(11);
  @$pb.TagNumber(12)
  void clearLeftCornerMarkStyle() => $_clearField(12);
  @$pb.TagNumber(12)
  ReasonStyle ensureLeftCornerMarkStyle() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get coverRightTextContentDescription => $_getSZ(12);
  @$pb.TagNumber(13)
  set coverRightTextContentDescription($core.String value) =>
      $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCoverRightTextContentDescription() => $_has(12);
  @$pb.TagNumber(13)
  void clearCoverRightTextContentDescription() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get rightDesc1ContentDescription => $_getSZ(13);
  @$pb.TagNumber(14)
  set rightDesc1ContentDescription($core.String value) =>
      $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasRightDesc1ContentDescription() => $_has(13);
  @$pb.TagNumber(14)
  void clearRightDesc1ContentDescription() => $_clearField(14);
}

class SmallCoverV7 extends $pb.GeneratedMessage {
  factory SmallCoverV7({
    Base? base,
    $core.String? desc,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (desc != null) result.desc = desc;
    return result;
  }

  SmallCoverV7._();

  factory SmallCoverV7.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SmallCoverV7.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SmallCoverV7',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'desc')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallCoverV7 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallCoverV7 copyWith(void Function(SmallCoverV7) updates) =>
      super.copyWith((message) => updates(message as SmallCoverV7))
          as SmallCoverV7;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SmallCoverV7 create() => SmallCoverV7._();
  @$core.override
  SmallCoverV7 createEmptyInstance() => create();
  static $pb.PbList<SmallCoverV7> createRepeated() =>
      $pb.PbList<SmallCoverV7>();
  @$core.pragma('dart2js:noInline')
  static SmallCoverV7 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SmallCoverV7>(create);
  static SmallCoverV7? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get desc => $_getSZ(1);
  @$pb.TagNumber(2)
  set desc($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDesc() => $_has(1);
  @$pb.TagNumber(2)
  void clearDesc() => $_clearField(2);
}

class SmallCoverV9 extends $pb.GeneratedMessage {
  factory SmallCoverV9({
    Base? base,
    $core.String? coverLeftText1,
    $core.int? coverLeftIcon1,
    $core.String? coverLeftText2,
    $core.int? coverLeftIcon2,
    $core.String? coverRightText,
    $core.int? coverRightIcon,
    $core.int? canPlay,
    ReasonStyle? rcmdReasonStyle,
    Up? up,
    ReasonStyle? leftCoverBadgeStyle,
    ReasonStyle? leftBottomRcmdReasonStyle,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (coverLeftText1 != null) result.coverLeftText1 = coverLeftText1;
    if (coverLeftIcon1 != null) result.coverLeftIcon1 = coverLeftIcon1;
    if (coverLeftText2 != null) result.coverLeftText2 = coverLeftText2;
    if (coverLeftIcon2 != null) result.coverLeftIcon2 = coverLeftIcon2;
    if (coverRightText != null) result.coverRightText = coverRightText;
    if (coverRightIcon != null) result.coverRightIcon = coverRightIcon;
    if (canPlay != null) result.canPlay = canPlay;
    if (rcmdReasonStyle != null) result.rcmdReasonStyle = rcmdReasonStyle;
    if (up != null) result.up = up;
    if (leftCoverBadgeStyle != null)
      result.leftCoverBadgeStyle = leftCoverBadgeStyle;
    if (leftBottomRcmdReasonStyle != null)
      result.leftBottomRcmdReasonStyle = leftBottomRcmdReasonStyle;
    return result;
  }

  SmallCoverV9._();

  factory SmallCoverV9.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SmallCoverV9.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SmallCoverV9',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'coverLeftText1')
    ..aI(3, _omitFieldNames ? '' : 'coverLeftIcon1')
    ..aOS(4, _omitFieldNames ? '' : 'coverLeftText2')
    ..aI(5, _omitFieldNames ? '' : 'coverLeftIcon2')
    ..aOS(6, _omitFieldNames ? '' : 'coverRightText')
    ..aI(7, _omitFieldNames ? '' : 'coverRightIcon')
    ..aI(8, _omitFieldNames ? '' : 'canPlay')
    ..aOM<ReasonStyle>(9, _omitFieldNames ? '' : 'rcmdReasonStyle',
        subBuilder: ReasonStyle.create)
    ..aOM<Up>(10, _omitFieldNames ? '' : 'up', subBuilder: Up.create)
    ..aOM<ReasonStyle>(11, _omitFieldNames ? '' : 'leftCoverBadgeStyle',
        subBuilder: ReasonStyle.create)
    ..aOM<ReasonStyle>(12, _omitFieldNames ? '' : 'leftBottomRcmdReasonStyle',
        subBuilder: ReasonStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallCoverV9 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallCoverV9 copyWith(void Function(SmallCoverV9) updates) =>
      super.copyWith((message) => updates(message as SmallCoverV9))
          as SmallCoverV9;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SmallCoverV9 create() => SmallCoverV9._();
  @$core.override
  SmallCoverV9 createEmptyInstance() => create();
  static $pb.PbList<SmallCoverV9> createRepeated() =>
      $pb.PbList<SmallCoverV9>();
  @$core.pragma('dart2js:noInline')
  static SmallCoverV9 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SmallCoverV9>(create);
  static SmallCoverV9? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get coverLeftText1 => $_getSZ(1);
  @$pb.TagNumber(2)
  set coverLeftText1($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCoverLeftText1() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoverLeftText1() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get coverLeftIcon1 => $_getIZ(2);
  @$pb.TagNumber(3)
  set coverLeftIcon1($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCoverLeftIcon1() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoverLeftIcon1() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get coverLeftText2 => $_getSZ(3);
  @$pb.TagNumber(4)
  set coverLeftText2($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverLeftText2() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverLeftText2() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get coverLeftIcon2 => $_getIZ(4);
  @$pb.TagNumber(5)
  set coverLeftIcon2($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCoverLeftIcon2() => $_has(4);
  @$pb.TagNumber(5)
  void clearCoverLeftIcon2() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get coverRightText => $_getSZ(5);
  @$pb.TagNumber(6)
  set coverRightText($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCoverRightText() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoverRightText() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get coverRightIcon => $_getIZ(6);
  @$pb.TagNumber(7)
  set coverRightIcon($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCoverRightIcon() => $_has(6);
  @$pb.TagNumber(7)
  void clearCoverRightIcon() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get canPlay => $_getIZ(7);
  @$pb.TagNumber(8)
  set canPlay($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCanPlay() => $_has(7);
  @$pb.TagNumber(8)
  void clearCanPlay() => $_clearField(8);

  @$pb.TagNumber(9)
  ReasonStyle get rcmdReasonStyle => $_getN(8);
  @$pb.TagNumber(9)
  set rcmdReasonStyle(ReasonStyle value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasRcmdReasonStyle() => $_has(8);
  @$pb.TagNumber(9)
  void clearRcmdReasonStyle() => $_clearField(9);
  @$pb.TagNumber(9)
  ReasonStyle ensureRcmdReasonStyle() => $_ensure(8);

  @$pb.TagNumber(10)
  Up get up => $_getN(9);
  @$pb.TagNumber(10)
  set up(Up value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasUp() => $_has(9);
  @$pb.TagNumber(10)
  void clearUp() => $_clearField(10);
  @$pb.TagNumber(10)
  Up ensureUp() => $_ensure(9);

  @$pb.TagNumber(11)
  ReasonStyle get leftCoverBadgeStyle => $_getN(10);
  @$pb.TagNumber(11)
  set leftCoverBadgeStyle(ReasonStyle value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasLeftCoverBadgeStyle() => $_has(10);
  @$pb.TagNumber(11)
  void clearLeftCoverBadgeStyle() => $_clearField(11);
  @$pb.TagNumber(11)
  ReasonStyle ensureLeftCoverBadgeStyle() => $_ensure(10);

  @$pb.TagNumber(12)
  ReasonStyle get leftBottomRcmdReasonStyle => $_getN(11);
  @$pb.TagNumber(12)
  set leftBottomRcmdReasonStyle(ReasonStyle value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasLeftBottomRcmdReasonStyle() => $_has(11);
  @$pb.TagNumber(12)
  void clearLeftBottomRcmdReasonStyle() => $_clearField(12);
  @$pb.TagNumber(12)
  ReasonStyle ensureLeftBottomRcmdReasonStyle() => $_ensure(11);
}

class ThreeItemAllV2 extends $pb.GeneratedMessage {
  factory ThreeItemAllV2({
    Base? base,
    ReasonStyle? topRcmdReasonStyle,
    $core.Iterable<TwoItemHV1Item>? item,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (topRcmdReasonStyle != null)
      result.topRcmdReasonStyle = topRcmdReasonStyle;
    if (item != null) result.item.addAll(item);
    return result;
  }

  ThreeItemAllV2._();

  factory ThreeItemAllV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ThreeItemAllV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreeItemAllV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOM<ReasonStyle>(2, _omitFieldNames ? '' : 'topRcmdReasonStyle',
        subBuilder: ReasonStyle.create)
    ..pPM<TwoItemHV1Item>(3, _omitFieldNames ? '' : 'item',
        subBuilder: TwoItemHV1Item.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreeItemAllV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreeItemAllV2 copyWith(void Function(ThreeItemAllV2) updates) =>
      super.copyWith((message) => updates(message as ThreeItemAllV2))
          as ThreeItemAllV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThreeItemAllV2 create() => ThreeItemAllV2._();
  @$core.override
  ThreeItemAllV2 createEmptyInstance() => create();
  static $pb.PbList<ThreeItemAllV2> createRepeated() =>
      $pb.PbList<ThreeItemAllV2>();
  @$core.pragma('dart2js:noInline')
  static ThreeItemAllV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreeItemAllV2>(create);
  static ThreeItemAllV2? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  ReasonStyle get topRcmdReasonStyle => $_getN(1);
  @$pb.TagNumber(2)
  set topRcmdReasonStyle(ReasonStyle value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTopRcmdReasonStyle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTopRcmdReasonStyle() => $_clearField(2);
  @$pb.TagNumber(2)
  ReasonStyle ensureTopRcmdReasonStyle() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<TwoItemHV1Item> get item => $_getList(2);
}

class ThreeItemV1 extends $pb.GeneratedMessage {
  factory ThreeItemV1({
    Base? base,
    $core.int? titleIcon,
    $core.String? moreUri,
    $core.String? moreText,
    $core.Iterable<ThreeItemV1Item>? items,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (titleIcon != null) result.titleIcon = titleIcon;
    if (moreUri != null) result.moreUri = moreUri;
    if (moreText != null) result.moreText = moreText;
    if (items != null) result.items.addAll(items);
    return result;
  }

  ThreeItemV1._();

  factory ThreeItemV1.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ThreeItemV1.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreeItemV1',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aI(2, _omitFieldNames ? '' : 'titleIcon')
    ..aOS(3, _omitFieldNames ? '' : 'moreUri')
    ..aOS(4, _omitFieldNames ? '' : 'moreText')
    ..pPM<ThreeItemV1Item>(5, _omitFieldNames ? '' : 'items',
        subBuilder: ThreeItemV1Item.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreeItemV1 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreeItemV1 copyWith(void Function(ThreeItemV1) updates) =>
      super.copyWith((message) => updates(message as ThreeItemV1))
          as ThreeItemV1;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThreeItemV1 create() => ThreeItemV1._();
  @$core.override
  ThreeItemV1 createEmptyInstance() => create();
  static $pb.PbList<ThreeItemV1> createRepeated() => $pb.PbList<ThreeItemV1>();
  @$core.pragma('dart2js:noInline')
  static ThreeItemV1 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreeItemV1>(create);
  static ThreeItemV1? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get titleIcon => $_getIZ(1);
  @$pb.TagNumber(2)
  set titleIcon($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitleIcon() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitleIcon() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get moreUri => $_getSZ(2);
  @$pb.TagNumber(3)
  set moreUri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMoreUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearMoreUri() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get moreText => $_getSZ(3);
  @$pb.TagNumber(4)
  set moreText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMoreText() => $_has(3);
  @$pb.TagNumber(4)
  void clearMoreText() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<ThreeItemV1Item> get items => $_getList(4);
}

class ThreeItemV1Item extends $pb.GeneratedMessage {
  factory ThreeItemV1Item({
    Base? base,
    $core.String? coverLeftText,
    $core.int? coverLeftIcon,
    $core.String? desc1,
    $core.String? desc2,
    $core.String? badge,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (coverLeftText != null) result.coverLeftText = coverLeftText;
    if (coverLeftIcon != null) result.coverLeftIcon = coverLeftIcon;
    if (desc1 != null) result.desc1 = desc1;
    if (desc2 != null) result.desc2 = desc2;
    if (badge != null) result.badge = badge;
    return result;
  }

  ThreeItemV1Item._();

  factory ThreeItemV1Item.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ThreeItemV1Item.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreeItemV1Item',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'coverLeftText')
    ..aI(3, _omitFieldNames ? '' : 'coverLeftIcon')
    ..aOS(4, _omitFieldNames ? '' : 'desc1')
    ..aOS(5, _omitFieldNames ? '' : 'desc2')
    ..aOS(6, _omitFieldNames ? '' : 'badge')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreeItemV1Item clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreeItemV1Item copyWith(void Function(ThreeItemV1Item) updates) =>
      super.copyWith((message) => updates(message as ThreeItemV1Item))
          as ThreeItemV1Item;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThreeItemV1Item create() => ThreeItemV1Item._();
  @$core.override
  ThreeItemV1Item createEmptyInstance() => create();
  static $pb.PbList<ThreeItemV1Item> createRepeated() =>
      $pb.PbList<ThreeItemV1Item>();
  @$core.pragma('dart2js:noInline')
  static ThreeItemV1Item getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreeItemV1Item>(create);
  static ThreeItemV1Item? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get coverLeftText => $_getSZ(1);
  @$pb.TagNumber(2)
  set coverLeftText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCoverLeftText() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoverLeftText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get coverLeftIcon => $_getIZ(2);
  @$pb.TagNumber(3)
  set coverLeftIcon($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCoverLeftIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoverLeftIcon() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get desc1 => $_getSZ(3);
  @$pb.TagNumber(4)
  set desc1($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDesc1() => $_has(3);
  @$pb.TagNumber(4)
  void clearDesc1() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get desc2 => $_getSZ(4);
  @$pb.TagNumber(5)
  set desc2($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDesc2() => $_has(4);
  @$pb.TagNumber(5)
  void clearDesc2() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get badge => $_getSZ(5);
  @$pb.TagNumber(6)
  set badge($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBadge() => $_has(5);
  @$pb.TagNumber(6)
  void clearBadge() => $_clearField(6);
}

class ThreeItemV2 extends $pb.GeneratedMessage {
  factory ThreeItemV2({
    Base? base,
    $core.int? titleIcon,
    $core.String? moreUri,
    $core.String? moreText,
    $core.Iterable<ThreeItemV2Item>? items,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (titleIcon != null) result.titleIcon = titleIcon;
    if (moreUri != null) result.moreUri = moreUri;
    if (moreText != null) result.moreText = moreText;
    if (items != null) result.items.addAll(items);
    return result;
  }

  ThreeItemV2._();

  factory ThreeItemV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ThreeItemV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreeItemV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aI(2, _omitFieldNames ? '' : 'titleIcon')
    ..aOS(3, _omitFieldNames ? '' : 'moreUri')
    ..aOS(4, _omitFieldNames ? '' : 'moreText')
    ..pPM<ThreeItemV2Item>(5, _omitFieldNames ? '' : 'items',
        subBuilder: ThreeItemV2Item.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreeItemV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreeItemV2 copyWith(void Function(ThreeItemV2) updates) =>
      super.copyWith((message) => updates(message as ThreeItemV2))
          as ThreeItemV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThreeItemV2 create() => ThreeItemV2._();
  @$core.override
  ThreeItemV2 createEmptyInstance() => create();
  static $pb.PbList<ThreeItemV2> createRepeated() => $pb.PbList<ThreeItemV2>();
  @$core.pragma('dart2js:noInline')
  static ThreeItemV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreeItemV2>(create);
  static ThreeItemV2? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get titleIcon => $_getIZ(1);
  @$pb.TagNumber(2)
  set titleIcon($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitleIcon() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitleIcon() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get moreUri => $_getSZ(2);
  @$pb.TagNumber(3)
  set moreUri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMoreUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearMoreUri() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get moreText => $_getSZ(3);
  @$pb.TagNumber(4)
  set moreText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMoreText() => $_has(3);
  @$pb.TagNumber(4)
  void clearMoreText() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<ThreeItemV2Item> get items => $_getList(4);
}

class ThreeItemV2Item extends $pb.GeneratedMessage {
  factory ThreeItemV2Item({
    Base? base,
    $core.int? coverLeftIcon,
    $core.String? descText1,
    $core.int? descIcon1,
    $core.String? descText2,
    $core.int? descIcon2,
    $core.String? badge,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (coverLeftIcon != null) result.coverLeftIcon = coverLeftIcon;
    if (descText1 != null) result.descText1 = descText1;
    if (descIcon1 != null) result.descIcon1 = descIcon1;
    if (descText2 != null) result.descText2 = descText2;
    if (descIcon2 != null) result.descIcon2 = descIcon2;
    if (badge != null) result.badge = badge;
    return result;
  }

  ThreeItemV2Item._();

  factory ThreeItemV2Item.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ThreeItemV2Item.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreeItemV2Item',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aI(2, _omitFieldNames ? '' : 'coverLeftIcon')
    ..aOS(3, _omitFieldNames ? '' : 'descText1')
    ..aI(4, _omitFieldNames ? '' : 'descIcon1')
    ..aOS(5, _omitFieldNames ? '' : 'descText2')
    ..aI(6, _omitFieldNames ? '' : 'descIcon2')
    ..aOS(7, _omitFieldNames ? '' : 'badge')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreeItemV2Item clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreeItemV2Item copyWith(void Function(ThreeItemV2Item) updates) =>
      super.copyWith((message) => updates(message as ThreeItemV2Item))
          as ThreeItemV2Item;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThreeItemV2Item create() => ThreeItemV2Item._();
  @$core.override
  ThreeItemV2Item createEmptyInstance() => create();
  static $pb.PbList<ThreeItemV2Item> createRepeated() =>
      $pb.PbList<ThreeItemV2Item>();
  @$core.pragma('dart2js:noInline')
  static ThreeItemV2Item getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreeItemV2Item>(create);
  static ThreeItemV2Item? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get coverLeftIcon => $_getIZ(1);
  @$pb.TagNumber(2)
  set coverLeftIcon($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCoverLeftIcon() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoverLeftIcon() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get descText1 => $_getSZ(2);
  @$pb.TagNumber(3)
  set descText1($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescText1() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescText1() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get descIcon1 => $_getIZ(3);
  @$pb.TagNumber(4)
  set descIcon1($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescIcon1() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescIcon1() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get descText2 => $_getSZ(4);
  @$pb.TagNumber(5)
  set descText2($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescText2() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescText2() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get descIcon2 => $_getIZ(5);
  @$pb.TagNumber(6)
  set descIcon2($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDescIcon2() => $_has(5);
  @$pb.TagNumber(6)
  void clearDescIcon2() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get badge => $_getSZ(6);
  @$pb.TagNumber(7)
  set badge($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBadge() => $_has(6);
  @$pb.TagNumber(7)
  void clearBadge() => $_clearField(7);
}

class ThreePicV2 extends $pb.GeneratedMessage {
  factory ThreePicV2({
    Base? base,
    $core.String? leftCover,
    $core.String? rightCover1,
    $core.String? rightCover2,
    $core.String? coverLeftText1,
    $core.int? coverLeftIcon1,
    $core.String? coverLeftText2,
    $core.int? coverLeftIcon2,
    $core.String? coverRightText,
    $core.int? coverRightIcon,
    $core.String? coverRightBackgroundColor,
    $core.String? badge,
    $core.String? rcmdReason,
    $core.String? desc,
    Avatar? avatar,
    ReasonStyle? rcmdReasonStyle,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (leftCover != null) result.leftCover = leftCover;
    if (rightCover1 != null) result.rightCover1 = rightCover1;
    if (rightCover2 != null) result.rightCover2 = rightCover2;
    if (coverLeftText1 != null) result.coverLeftText1 = coverLeftText1;
    if (coverLeftIcon1 != null) result.coverLeftIcon1 = coverLeftIcon1;
    if (coverLeftText2 != null) result.coverLeftText2 = coverLeftText2;
    if (coverLeftIcon2 != null) result.coverLeftIcon2 = coverLeftIcon2;
    if (coverRightText != null) result.coverRightText = coverRightText;
    if (coverRightIcon != null) result.coverRightIcon = coverRightIcon;
    if (coverRightBackgroundColor != null)
      result.coverRightBackgroundColor = coverRightBackgroundColor;
    if (badge != null) result.badge = badge;
    if (rcmdReason != null) result.rcmdReason = rcmdReason;
    if (desc != null) result.desc = desc;
    if (avatar != null) result.avatar = avatar;
    if (rcmdReasonStyle != null) result.rcmdReasonStyle = rcmdReasonStyle;
    return result;
  }

  ThreePicV2._();

  factory ThreePicV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ThreePicV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreePicV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'leftCover')
    ..aOS(3, _omitFieldNames ? '' : 'rightCover1')
    ..aOS(4, _omitFieldNames ? '' : 'rightCover2')
    ..aOS(5, _omitFieldNames ? '' : 'coverLeftText1')
    ..aI(6, _omitFieldNames ? '' : 'coverLeftIcon1')
    ..aOS(7, _omitFieldNames ? '' : 'coverLeftText2')
    ..aI(8, _omitFieldNames ? '' : 'coverLeftIcon2')
    ..aOS(9, _omitFieldNames ? '' : 'coverRightText')
    ..aI(10, _omitFieldNames ? '' : 'coverRightIcon')
    ..aOS(11, _omitFieldNames ? '' : 'coverRightBackgroundColor')
    ..aOS(12, _omitFieldNames ? '' : 'badge')
    ..aOS(13, _omitFieldNames ? '' : 'rcmdReason')
    ..aOS(14, _omitFieldNames ? '' : 'desc')
    ..aOM<Avatar>(15, _omitFieldNames ? '' : 'avatar',
        subBuilder: Avatar.create)
    ..aOM<ReasonStyle>(16, _omitFieldNames ? '' : 'rcmdReasonStyle',
        subBuilder: ReasonStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreePicV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreePicV2 copyWith(void Function(ThreePicV2) updates) =>
      super.copyWith((message) => updates(message as ThreePicV2)) as ThreePicV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThreePicV2 create() => ThreePicV2._();
  @$core.override
  ThreePicV2 createEmptyInstance() => create();
  static $pb.PbList<ThreePicV2> createRepeated() => $pb.PbList<ThreePicV2>();
  @$core.pragma('dart2js:noInline')
  static ThreePicV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreePicV2>(create);
  static ThreePicV2? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get leftCover => $_getSZ(1);
  @$pb.TagNumber(2)
  set leftCover($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLeftCover() => $_has(1);
  @$pb.TagNumber(2)
  void clearLeftCover() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get rightCover1 => $_getSZ(2);
  @$pb.TagNumber(3)
  set rightCover1($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRightCover1() => $_has(2);
  @$pb.TagNumber(3)
  void clearRightCover1() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get rightCover2 => $_getSZ(3);
  @$pb.TagNumber(4)
  set rightCover2($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRightCover2() => $_has(3);
  @$pb.TagNumber(4)
  void clearRightCover2() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get coverLeftText1 => $_getSZ(4);
  @$pb.TagNumber(5)
  set coverLeftText1($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCoverLeftText1() => $_has(4);
  @$pb.TagNumber(5)
  void clearCoverLeftText1() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get coverLeftIcon1 => $_getIZ(5);
  @$pb.TagNumber(6)
  set coverLeftIcon1($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCoverLeftIcon1() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoverLeftIcon1() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get coverLeftText2 => $_getSZ(6);
  @$pb.TagNumber(7)
  set coverLeftText2($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCoverLeftText2() => $_has(6);
  @$pb.TagNumber(7)
  void clearCoverLeftText2() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get coverLeftIcon2 => $_getIZ(7);
  @$pb.TagNumber(8)
  set coverLeftIcon2($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCoverLeftIcon2() => $_has(7);
  @$pb.TagNumber(8)
  void clearCoverLeftIcon2() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get coverRightText => $_getSZ(8);
  @$pb.TagNumber(9)
  set coverRightText($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCoverRightText() => $_has(8);
  @$pb.TagNumber(9)
  void clearCoverRightText() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get coverRightIcon => $_getIZ(9);
  @$pb.TagNumber(10)
  set coverRightIcon($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCoverRightIcon() => $_has(9);
  @$pb.TagNumber(10)
  void clearCoverRightIcon() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get coverRightBackgroundColor => $_getSZ(10);
  @$pb.TagNumber(11)
  set coverRightBackgroundColor($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCoverRightBackgroundColor() => $_has(10);
  @$pb.TagNumber(11)
  void clearCoverRightBackgroundColor() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get badge => $_getSZ(11);
  @$pb.TagNumber(12)
  set badge($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasBadge() => $_has(11);
  @$pb.TagNumber(12)
  void clearBadge() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get rcmdReason => $_getSZ(12);
  @$pb.TagNumber(13)
  set rcmdReason($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRcmdReason() => $_has(12);
  @$pb.TagNumber(13)
  void clearRcmdReason() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get desc => $_getSZ(13);
  @$pb.TagNumber(14)
  set desc($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasDesc() => $_has(13);
  @$pb.TagNumber(14)
  void clearDesc() => $_clearField(14);

  @$pb.TagNumber(15)
  Avatar get avatar => $_getN(14);
  @$pb.TagNumber(15)
  set avatar(Avatar value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasAvatar() => $_has(14);
  @$pb.TagNumber(15)
  void clearAvatar() => $_clearField(15);
  @$pb.TagNumber(15)
  Avatar ensureAvatar() => $_ensure(14);

  @$pb.TagNumber(16)
  ReasonStyle get rcmdReasonStyle => $_getN(15);
  @$pb.TagNumber(16)
  set rcmdReasonStyle(ReasonStyle value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasRcmdReasonStyle() => $_has(15);
  @$pb.TagNumber(16)
  void clearRcmdReasonStyle() => $_clearField(16);
  @$pb.TagNumber(16)
  ReasonStyle ensureRcmdReasonStyle() => $_ensure(15);
}

class ThreePicV3 extends $pb.GeneratedMessage {
  factory ThreePicV3({
    Base? base,
    $core.String? leftCover,
    $core.String? rightCover1,
    $core.String? rightCover2,
    $core.String? coverLeftText1,
    $core.int? coverLeftIcon1,
    $core.String? coverLeftText2,
    $core.int? coverLeftIcon2,
    $core.String? coverRightText,
    $core.int? coverRightIcon,
    $core.String? coverRightBackgroundColor,
    $core.String? badge,
    ReasonStyle? rcmdReasonStyle,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (leftCover != null) result.leftCover = leftCover;
    if (rightCover1 != null) result.rightCover1 = rightCover1;
    if (rightCover2 != null) result.rightCover2 = rightCover2;
    if (coverLeftText1 != null) result.coverLeftText1 = coverLeftText1;
    if (coverLeftIcon1 != null) result.coverLeftIcon1 = coverLeftIcon1;
    if (coverLeftText2 != null) result.coverLeftText2 = coverLeftText2;
    if (coverLeftIcon2 != null) result.coverLeftIcon2 = coverLeftIcon2;
    if (coverRightText != null) result.coverRightText = coverRightText;
    if (coverRightIcon != null) result.coverRightIcon = coverRightIcon;
    if (coverRightBackgroundColor != null)
      result.coverRightBackgroundColor = coverRightBackgroundColor;
    if (badge != null) result.badge = badge;
    if (rcmdReasonStyle != null) result.rcmdReasonStyle = rcmdReasonStyle;
    return result;
  }

  ThreePicV3._();

  factory ThreePicV3.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ThreePicV3.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreePicV3',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'leftCover')
    ..aOS(3, _omitFieldNames ? '' : 'rightCover1')
    ..aOS(4, _omitFieldNames ? '' : 'rightCover2')
    ..aOS(5, _omitFieldNames ? '' : 'coverLeftText1')
    ..aI(6, _omitFieldNames ? '' : 'coverLeftIcon1')
    ..aOS(7, _omitFieldNames ? '' : 'coverLeftText2')
    ..aI(8, _omitFieldNames ? '' : 'coverLeftIcon2')
    ..aOS(9, _omitFieldNames ? '' : 'coverRightText')
    ..aI(10, _omitFieldNames ? '' : 'coverRightIcon')
    ..aOS(11, _omitFieldNames ? '' : 'coverRightBackgroundColor')
    ..aOS(12, _omitFieldNames ? '' : 'badge')
    ..aOM<ReasonStyle>(13, _omitFieldNames ? '' : 'rcmdReasonStyle',
        subBuilder: ReasonStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreePicV3 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreePicV3 copyWith(void Function(ThreePicV3) updates) =>
      super.copyWith((message) => updates(message as ThreePicV3)) as ThreePicV3;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThreePicV3 create() => ThreePicV3._();
  @$core.override
  ThreePicV3 createEmptyInstance() => create();
  static $pb.PbList<ThreePicV3> createRepeated() => $pb.PbList<ThreePicV3>();
  @$core.pragma('dart2js:noInline')
  static ThreePicV3 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreePicV3>(create);
  static ThreePicV3? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get leftCover => $_getSZ(1);
  @$pb.TagNumber(2)
  set leftCover($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLeftCover() => $_has(1);
  @$pb.TagNumber(2)
  void clearLeftCover() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get rightCover1 => $_getSZ(2);
  @$pb.TagNumber(3)
  set rightCover1($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRightCover1() => $_has(2);
  @$pb.TagNumber(3)
  void clearRightCover1() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get rightCover2 => $_getSZ(3);
  @$pb.TagNumber(4)
  set rightCover2($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRightCover2() => $_has(3);
  @$pb.TagNumber(4)
  void clearRightCover2() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get coverLeftText1 => $_getSZ(4);
  @$pb.TagNumber(5)
  set coverLeftText1($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCoverLeftText1() => $_has(4);
  @$pb.TagNumber(5)
  void clearCoverLeftText1() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get coverLeftIcon1 => $_getIZ(5);
  @$pb.TagNumber(6)
  set coverLeftIcon1($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCoverLeftIcon1() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoverLeftIcon1() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get coverLeftText2 => $_getSZ(6);
  @$pb.TagNumber(7)
  set coverLeftText2($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCoverLeftText2() => $_has(6);
  @$pb.TagNumber(7)
  void clearCoverLeftText2() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get coverLeftIcon2 => $_getIZ(7);
  @$pb.TagNumber(8)
  set coverLeftIcon2($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCoverLeftIcon2() => $_has(7);
  @$pb.TagNumber(8)
  void clearCoverLeftIcon2() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get coverRightText => $_getSZ(8);
  @$pb.TagNumber(9)
  set coverRightText($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCoverRightText() => $_has(8);
  @$pb.TagNumber(9)
  void clearCoverRightText() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get coverRightIcon => $_getIZ(9);
  @$pb.TagNumber(10)
  set coverRightIcon($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCoverRightIcon() => $_has(9);
  @$pb.TagNumber(10)
  void clearCoverRightIcon() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get coverRightBackgroundColor => $_getSZ(10);
  @$pb.TagNumber(11)
  set coverRightBackgroundColor($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCoverRightBackgroundColor() => $_has(10);
  @$pb.TagNumber(11)
  void clearCoverRightBackgroundColor() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get badge => $_getSZ(11);
  @$pb.TagNumber(12)
  set badge($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasBadge() => $_has(11);
  @$pb.TagNumber(12)
  void clearBadge() => $_clearField(12);

  @$pb.TagNumber(13)
  ReasonStyle get rcmdReasonStyle => $_getN(12);
  @$pb.TagNumber(13)
  set rcmdReasonStyle(ReasonStyle value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasRcmdReasonStyle() => $_has(12);
  @$pb.TagNumber(13)
  void clearRcmdReasonStyle() => $_clearField(13);
  @$pb.TagNumber(13)
  ReasonStyle ensureRcmdReasonStyle() => $_ensure(12);
}

class ThreePoint extends $pb.GeneratedMessage {
  factory ThreePoint({
    $core.Iterable<DislikeReason>? dislikeReasons,
    $core.Iterable<DislikeReason>? feedbacks,
    $core.int? watchLater,
  }) {
    final result = create();
    if (dislikeReasons != null) result.dislikeReasons.addAll(dislikeReasons);
    if (feedbacks != null) result.feedbacks.addAll(feedbacks);
    if (watchLater != null) result.watchLater = watchLater;
    return result;
  }

  ThreePoint._();

  factory ThreePoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ThreePoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreePoint',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..pPM<DislikeReason>(1, _omitFieldNames ? '' : 'dislikeReasons',
        subBuilder: DislikeReason.create)
    ..pPM<DislikeReason>(2, _omitFieldNames ? '' : 'feedbacks',
        subBuilder: DislikeReason.create)
    ..aI(3, _omitFieldNames ? '' : 'watchLater')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreePoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreePoint copyWith(void Function(ThreePoint) updates) =>
      super.copyWith((message) => updates(message as ThreePoint)) as ThreePoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThreePoint create() => ThreePoint._();
  @$core.override
  ThreePoint createEmptyInstance() => create();
  static $pb.PbList<ThreePoint> createRepeated() => $pb.PbList<ThreePoint>();
  @$core.pragma('dart2js:noInline')
  static ThreePoint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreePoint>(create);
  static ThreePoint? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DislikeReason> get dislikeReasons => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<DislikeReason> get feedbacks => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get watchLater => $_getIZ(2);
  @$pb.TagNumber(3)
  set watchLater($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWatchLater() => $_has(2);
  @$pb.TagNumber(3)
  void clearWatchLater() => $_clearField(3);
}

class ThreePointV2 extends $pb.GeneratedMessage {
  factory ThreePointV2({
    $core.String? title,
    $core.String? subtitle,
    $core.Iterable<DislikeReason>? reasons,
    $core.String? type,
    $fixnum.Int64? id,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    if (reasons != null) result.reasons.addAll(reasons);
    if (type != null) result.type = type;
    if (id != null) result.id = id;
    return result;
  }

  ThreePointV2._();

  factory ThreePointV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ThreePointV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreePointV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'subtitle')
    ..pPM<DislikeReason>(3, _omitFieldNames ? '' : 'reasons',
        subBuilder: DislikeReason.create)
    ..aOS(4, _omitFieldNames ? '' : 'type')
    ..aInt64(5, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreePointV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreePointV2 copyWith(void Function(ThreePointV2) updates) =>
      super.copyWith((message) => updates(message as ThreePointV2))
          as ThreePointV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThreePointV2 create() => ThreePointV2._();
  @$core.override
  ThreePointV2 createEmptyInstance() => create();
  static $pb.PbList<ThreePointV2> createRepeated() =>
      $pb.PbList<ThreePointV2>();
  @$core.pragma('dart2js:noInline')
  static ThreePointV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreePointV2>(create);
  static ThreePointV2? _defaultInstance;

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
  $pb.PbList<DislikeReason> get reasons => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get type => $_getSZ(3);
  @$pb.TagNumber(4)
  set type($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasType() => $_has(3);
  @$pb.TagNumber(4)
  void clearType() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get id => $_getI64(4);
  @$pb.TagNumber(5)
  set id($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasId() => $_has(4);
  @$pb.TagNumber(5)
  void clearId() => $_clearField(5);
}

class ThreePointV3 extends $pb.GeneratedMessage {
  factory ThreePointV3({
    $core.String? title,
    $core.String? selectedTitle,
    $core.String? subtitle,
    $core.Iterable<DislikeReason>? reasons,
    $core.String? type,
    $fixnum.Int64? id,
    $core.int? selected,
    $core.String? icon,
    $core.String? selectedIcon,
    $core.String? url,
    $core.int? defaultId,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (selectedTitle != null) result.selectedTitle = selectedTitle;
    if (subtitle != null) result.subtitle = subtitle;
    if (reasons != null) result.reasons.addAll(reasons);
    if (type != null) result.type = type;
    if (id != null) result.id = id;
    if (selected != null) result.selected = selected;
    if (icon != null) result.icon = icon;
    if (selectedIcon != null) result.selectedIcon = selectedIcon;
    if (url != null) result.url = url;
    if (defaultId != null) result.defaultId = defaultId;
    return result;
  }

  ThreePointV3._();

  factory ThreePointV3.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ThreePointV3.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreePointV3',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'selectedTitle')
    ..aOS(3, _omitFieldNames ? '' : 'subtitle')
    ..pPM<DislikeReason>(4, _omitFieldNames ? '' : 'reasons',
        subBuilder: DislikeReason.create)
    ..aOS(5, _omitFieldNames ? '' : 'type')
    ..aInt64(6, _omitFieldNames ? '' : 'id')
    ..aI(7, _omitFieldNames ? '' : 'selected')
    ..aOS(8, _omitFieldNames ? '' : 'icon')
    ..aOS(9, _omitFieldNames ? '' : 'selectedIcon')
    ..aOS(10, _omitFieldNames ? '' : 'url')
    ..aI(11, _omitFieldNames ? '' : 'defaultId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreePointV3 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreePointV3 copyWith(void Function(ThreePointV3) updates) =>
      super.copyWith((message) => updates(message as ThreePointV3))
          as ThreePointV3;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThreePointV3 create() => ThreePointV3._();
  @$core.override
  ThreePointV3 createEmptyInstance() => create();
  static $pb.PbList<ThreePointV3> createRepeated() =>
      $pb.PbList<ThreePointV3>();
  @$core.pragma('dart2js:noInline')
  static ThreePointV3 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreePointV3>(create);
  static ThreePointV3? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get selectedTitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set selectedTitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSelectedTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearSelectedTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get subtitle => $_getSZ(2);
  @$pb.TagNumber(3)
  set subtitle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubtitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubtitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<DislikeReason> get reasons => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get type => $_getSZ(4);
  @$pb.TagNumber(5)
  set type($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasType() => $_has(4);
  @$pb.TagNumber(5)
  void clearType() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get id => $_getI64(5);
  @$pb.TagNumber(6)
  set id($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasId() => $_has(5);
  @$pb.TagNumber(6)
  void clearId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get selected => $_getIZ(6);
  @$pb.TagNumber(7)
  set selected($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSelected() => $_has(6);
  @$pb.TagNumber(7)
  void clearSelected() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get icon => $_getSZ(7);
  @$pb.TagNumber(8)
  set icon($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIcon() => $_has(7);
  @$pb.TagNumber(8)
  void clearIcon() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get selectedIcon => $_getSZ(8);
  @$pb.TagNumber(9)
  set selectedIcon($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSelectedIcon() => $_has(8);
  @$pb.TagNumber(9)
  void clearSelectedIcon() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get url => $_getSZ(9);
  @$pb.TagNumber(10)
  set url($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasUrl() => $_has(9);
  @$pb.TagNumber(10)
  void clearUrl() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get defaultId => $_getIZ(10);
  @$pb.TagNumber(11)
  set defaultId($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDefaultId() => $_has(10);
  @$pb.TagNumber(11)
  void clearDefaultId() => $_clearField(11);
}

class ThreePointV4 extends $pb.GeneratedMessage {
  factory ThreePointV4({
    SharePlane? sharePlane,
    WatchLater? watchLater,
  }) {
    final result = create();
    if (sharePlane != null) result.sharePlane = sharePlane;
    if (watchLater != null) result.watchLater = watchLater;
    return result;
  }

  ThreePointV4._();

  factory ThreePointV4.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ThreePointV4.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ThreePointV4',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<SharePlane>(1, _omitFieldNames ? '' : 'sharePlane',
        subBuilder: SharePlane.create)
    ..aOM<WatchLater>(2, _omitFieldNames ? '' : 'watchLater',
        subBuilder: WatchLater.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreePointV4 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ThreePointV4 copyWith(void Function(ThreePointV4) updates) =>
      super.copyWith((message) => updates(message as ThreePointV4))
          as ThreePointV4;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ThreePointV4 create() => ThreePointV4._();
  @$core.override
  ThreePointV4 createEmptyInstance() => create();
  static $pb.PbList<ThreePointV4> createRepeated() =>
      $pb.PbList<ThreePointV4>();
  @$core.pragma('dart2js:noInline')
  static ThreePointV4 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ThreePointV4>(create);
  static ThreePointV4? _defaultInstance;

  @$pb.TagNumber(1)
  SharePlane get sharePlane => $_getN(0);
  @$pb.TagNumber(1)
  set sharePlane(SharePlane value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSharePlane() => $_has(0);
  @$pb.TagNumber(1)
  void clearSharePlane() => $_clearField(1);
  @$pb.TagNumber(1)
  SharePlane ensureSharePlane() => $_ensure(0);

  @$pb.TagNumber(2)
  WatchLater get watchLater => $_getN(1);
  @$pb.TagNumber(2)
  set watchLater(WatchLater value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWatchLater() => $_has(1);
  @$pb.TagNumber(2)
  void clearWatchLater() => $_clearField(2);
  @$pb.TagNumber(2)
  WatchLater ensureWatchLater() => $_ensure(1);
}

class TopicButton extends $pb.GeneratedMessage {
  factory TopicButton({
    $core.String? title,
    $core.String? jumpUri,
    $core.bool? redDot,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (jumpUri != null) result.jumpUri = jumpUri;
    if (redDot != null) result.redDot = redDot;
    return result;
  }

  TopicButton._();

  factory TopicButton.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TopicButton.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TopicButton',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'jumpUri')
    ..aOB(3, _omitFieldNames ? '' : 'redDot')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TopicButton clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TopicButton copyWith(void Function(TopicButton) updates) =>
      super.copyWith((message) => updates(message as TopicButton))
          as TopicButton;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TopicButton create() => TopicButton._();
  @$core.override
  TopicButton createEmptyInstance() => create();
  static $pb.PbList<TopicButton> createRepeated() => $pb.PbList<TopicButton>();
  @$core.pragma('dart2js:noInline')
  static TopicButton getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TopicButton>(create);
  static TopicButton? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get jumpUri => $_getSZ(1);
  @$pb.TagNumber(2)
  set jumpUri($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJumpUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearJumpUri() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get redDot => $_getBF(2);
  @$pb.TagNumber(3)
  set redDot($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRedDot() => $_has(2);
  @$pb.TagNumber(3)
  void clearRedDot() => $_clearField(3);
}

class TopicList extends $pb.GeneratedMessage {
  factory TopicList({
    Base? base,
    $core.String? title,
    $core.String? titleIcon,
    TopicButton? moreButton,
    $core.Iterable<TopicListItem>? topicListItem,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (title != null) result.title = title;
    if (titleIcon != null) result.titleIcon = titleIcon;
    if (moreButton != null) result.moreButton = moreButton;
    if (topicListItem != null) result.topicListItem.addAll(topicListItem);
    return result;
  }

  TopicList._();

  factory TopicList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TopicList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TopicList',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'titleIcon')
    ..aOM<TopicButton>(4, _omitFieldNames ? '' : 'moreButton',
        subBuilder: TopicButton.create)
    ..pPM<TopicListItem>(5, _omitFieldNames ? '' : 'topicListItem',
        subBuilder: TopicListItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TopicList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TopicList copyWith(void Function(TopicList) updates) =>
      super.copyWith((message) => updates(message as TopicList)) as TopicList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TopicList create() => TopicList._();
  @$core.override
  TopicList createEmptyInstance() => create();
  static $pb.PbList<TopicList> createRepeated() => $pb.PbList<TopicList>();
  @$core.pragma('dart2js:noInline')
  static TopicList getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TopicList>(create);
  static TopicList? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get titleIcon => $_getSZ(2);
  @$pb.TagNumber(3)
  set titleIcon($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitleIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitleIcon() => $_clearField(3);

  @$pb.TagNumber(4)
  TopicButton get moreButton => $_getN(3);
  @$pb.TagNumber(4)
  set moreButton(TopicButton value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMoreButton() => $_has(3);
  @$pb.TagNumber(4)
  void clearMoreButton() => $_clearField(4);
  @$pb.TagNumber(4)
  TopicButton ensureMoreButton() => $_ensure(3);

  @$pb.TagNumber(5)
  $pb.PbList<TopicListItem> get topicListItem => $_getList(4);
}

class TopicListItem extends $pb.GeneratedMessage {
  factory TopicListItem({
    $core.String? icon,
    $core.String? iconTitle,
    $fixnum.Int64? topicId,
    $core.String? topicName,
    $core.String? url,
    $fixnum.Int64? upMid,
    $fixnum.Int64? position,
  }) {
    final result = create();
    if (icon != null) result.icon = icon;
    if (iconTitle != null) result.iconTitle = iconTitle;
    if (topicId != null) result.topicId = topicId;
    if (topicName != null) result.topicName = topicName;
    if (url != null) result.url = url;
    if (upMid != null) result.upMid = upMid;
    if (position != null) result.position = position;
    return result;
  }

  TopicListItem._();

  factory TopicListItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TopicListItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TopicListItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'icon')
    ..aOS(2, _omitFieldNames ? '' : 'iconTitle')
    ..aInt64(3, _omitFieldNames ? '' : 'topicId')
    ..aOS(4, _omitFieldNames ? '' : 'topicName')
    ..aOS(5, _omitFieldNames ? '' : 'url')
    ..aInt64(6, _omitFieldNames ? '' : 'upMid')
    ..aInt64(7, _omitFieldNames ? '' : 'position')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TopicListItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TopicListItem copyWith(void Function(TopicListItem) updates) =>
      super.copyWith((message) => updates(message as TopicListItem))
          as TopicListItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TopicListItem create() => TopicListItem._();
  @$core.override
  TopicListItem createEmptyInstance() => create();
  static $pb.PbList<TopicListItem> createRepeated() =>
      $pb.PbList<TopicListItem>();
  @$core.pragma('dart2js:noInline')
  static TopicListItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TopicListItem>(create);
  static TopicListItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get icon => $_getSZ(0);
  @$pb.TagNumber(1)
  set icon($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIcon() => $_has(0);
  @$pb.TagNumber(1)
  void clearIcon() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get iconTitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set iconTitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIconTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearIconTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get topicId => $_getI64(2);
  @$pb.TagNumber(3)
  set topicId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTopicId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTopicId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get topicName => $_getSZ(3);
  @$pb.TagNumber(4)
  set topicName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTopicName() => $_has(3);
  @$pb.TagNumber(4)
  void clearTopicName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get url => $_getSZ(4);
  @$pb.TagNumber(5)
  set url($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get upMid => $_getI64(5);
  @$pb.TagNumber(6)
  set upMid($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUpMid() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpMid() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get position => $_getI64(6);
  @$pb.TagNumber(7)
  set position($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPosition() => $_has(6);
  @$pb.TagNumber(7)
  void clearPosition() => $_clearField(7);
}

class TwoItemHV1Item extends $pb.GeneratedMessage {
  factory TwoItemHV1Item({
    $core.String? title,
    $core.String? cover,
    $core.String? uri,
    $core.String? param,
    Args? args,
    $core.String? goto,
    $core.String? coverLeftText1,
    $core.int? coverLeftIcon1,
    $core.String? coverRightText,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (cover != null) result.cover = cover;
    if (uri != null) result.uri = uri;
    if (param != null) result.param = param;
    if (args != null) result.args = args;
    if (goto != null) result.goto = goto;
    if (coverLeftText1 != null) result.coverLeftText1 = coverLeftText1;
    if (coverLeftIcon1 != null) result.coverLeftIcon1 = coverLeftIcon1;
    if (coverRightText != null) result.coverRightText = coverRightText;
    return result;
  }

  TwoItemHV1Item._();

  factory TwoItemHV1Item.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TwoItemHV1Item.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TwoItemHV1Item',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'cover')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..aOS(4, _omitFieldNames ? '' : 'param')
    ..aOM<Args>(5, _omitFieldNames ? '' : 'args', subBuilder: Args.create)
    ..aOS(6, _omitFieldNames ? '' : 'goto')
    ..aOS(7, _omitFieldNames ? '' : 'coverLeftText1')
    ..aI(8, _omitFieldNames ? '' : 'coverLeftIcon1')
    ..aOS(9, _omitFieldNames ? '' : 'coverRightText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwoItemHV1Item clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwoItemHV1Item copyWith(void Function(TwoItemHV1Item) updates) =>
      super.copyWith((message) => updates(message as TwoItemHV1Item))
          as TwoItemHV1Item;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TwoItemHV1Item create() => TwoItemHV1Item._();
  @$core.override
  TwoItemHV1Item createEmptyInstance() => create();
  static $pb.PbList<TwoItemHV1Item> createRepeated() =>
      $pb.PbList<TwoItemHV1Item>();
  @$core.pragma('dart2js:noInline')
  static TwoItemHV1Item getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TwoItemHV1Item>(create);
  static TwoItemHV1Item? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cover => $_getSZ(1);
  @$pb.TagNumber(2)
  set cover($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCover() => $_has(1);
  @$pb.TagNumber(2)
  void clearCover() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get param => $_getSZ(3);
  @$pb.TagNumber(4)
  set param($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParam() => $_has(3);
  @$pb.TagNumber(4)
  void clearParam() => $_clearField(4);

  @$pb.TagNumber(5)
  Args get args => $_getN(4);
  @$pb.TagNumber(5)
  set args(Args value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasArgs() => $_has(4);
  @$pb.TagNumber(5)
  void clearArgs() => $_clearField(5);
  @$pb.TagNumber(5)
  Args ensureArgs() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get goto => $_getSZ(5);
  @$pb.TagNumber(6)
  set goto($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasGoto() => $_has(5);
  @$pb.TagNumber(6)
  void clearGoto() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get coverLeftText1 => $_getSZ(6);
  @$pb.TagNumber(7)
  set coverLeftText1($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCoverLeftText1() => $_has(6);
  @$pb.TagNumber(7)
  void clearCoverLeftText1() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get coverLeftIcon1 => $_getIZ(7);
  @$pb.TagNumber(8)
  set coverLeftIcon1($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCoverLeftIcon1() => $_has(7);
  @$pb.TagNumber(8)
  void clearCoverLeftIcon1() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get coverRightText => $_getSZ(8);
  @$pb.TagNumber(9)
  set coverRightText($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCoverRightText() => $_has(8);
  @$pb.TagNumber(9)
  void clearCoverRightText() => $_clearField(9);
}

class TwoItemV2 extends $pb.GeneratedMessage {
  factory TwoItemV2({
    Base? base,
    $core.Iterable<TwoItemV2Item>? items,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (items != null) result.items.addAll(items);
    return result;
  }

  TwoItemV2._();

  factory TwoItemV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TwoItemV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TwoItemV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..pPM<TwoItemV2Item>(2, _omitFieldNames ? '' : 'items',
        subBuilder: TwoItemV2Item.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwoItemV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwoItemV2 copyWith(void Function(TwoItemV2) updates) =>
      super.copyWith((message) => updates(message as TwoItemV2)) as TwoItemV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TwoItemV2 create() => TwoItemV2._();
  @$core.override
  TwoItemV2 createEmptyInstance() => create();
  static $pb.PbList<TwoItemV2> createRepeated() => $pb.PbList<TwoItemV2>();
  @$core.pragma('dart2js:noInline')
  static TwoItemV2 getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TwoItemV2>(create);
  static TwoItemV2? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<TwoItemV2Item> get items => $_getList(1);
}

class TwoItemV2Item extends $pb.GeneratedMessage {
  factory TwoItemV2Item({
    Base? base,
    $core.String? badge,
    $core.String? coverLeftText1,
    $core.int? coverLeftIcon1,
  }) {
    final result = create();
    if (base != null) result.base = base;
    if (badge != null) result.badge = badge;
    if (coverLeftText1 != null) result.coverLeftText1 = coverLeftText1;
    if (coverLeftIcon1 != null) result.coverLeftIcon1 = coverLeftIcon1;
    return result;
  }

  TwoItemV2Item._();

  factory TwoItemV2Item.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TwoItemV2Item.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TwoItemV2Item',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aOM<Base>(1, _omitFieldNames ? '' : 'base', subBuilder: Base.create)
    ..aOS(2, _omitFieldNames ? '' : 'badge')
    ..aOS(3, _omitFieldNames ? '' : 'coverLeftText1')
    ..aI(4, _omitFieldNames ? '' : 'coverLeftIcon1')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwoItemV2Item clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwoItemV2Item copyWith(void Function(TwoItemV2Item) updates) =>
      super.copyWith((message) => updates(message as TwoItemV2Item))
          as TwoItemV2Item;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TwoItemV2Item create() => TwoItemV2Item._();
  @$core.override
  TwoItemV2Item createEmptyInstance() => create();
  static $pb.PbList<TwoItemV2Item> createRepeated() =>
      $pb.PbList<TwoItemV2Item>();
  @$core.pragma('dart2js:noInline')
  static TwoItemV2Item getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TwoItemV2Item>(create);
  static TwoItemV2Item? _defaultInstance;

  @$pb.TagNumber(1)
  Base get base => $_getN(0);
  @$pb.TagNumber(1)
  set base(Base value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBase() => $_has(0);
  @$pb.TagNumber(1)
  void clearBase() => $_clearField(1);
  @$pb.TagNumber(1)
  Base ensureBase() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get badge => $_getSZ(1);
  @$pb.TagNumber(2)
  set badge($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBadge() => $_has(1);
  @$pb.TagNumber(2)
  void clearBadge() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get coverLeftText1 => $_getSZ(2);
  @$pb.TagNumber(3)
  set coverLeftText1($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCoverLeftText1() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoverLeftText1() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get coverLeftIcon1 => $_getIZ(3);
  @$pb.TagNumber(4)
  set coverLeftIcon1($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverLeftIcon1() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverLeftIcon1() => $_clearField(4);
}

class Up extends $pb.GeneratedMessage {
  factory Up({
    $fixnum.Int64? id,
    $core.String? name,
    $core.String? desc,
    Avatar? avatar,
    $core.int? officialIcon,
    Button? descButton,
    $core.String? cooperation,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (desc != null) result.desc = desc;
    if (avatar != null) result.avatar = avatar;
    if (officialIcon != null) result.officialIcon = officialIcon;
    if (descButton != null) result.descButton = descButton;
    if (cooperation != null) result.cooperation = cooperation;
    return result;
  }

  Up._();

  factory Up.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Up.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Up',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'desc')
    ..aOM<Avatar>(4, _omitFieldNames ? '' : 'avatar', subBuilder: Avatar.create)
    ..aI(5, _omitFieldNames ? '' : 'officialIcon')
    ..aOM<Button>(6, _omitFieldNames ? '' : 'descButton',
        subBuilder: Button.create)
    ..aOS(7, _omitFieldNames ? '' : 'cooperation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Up clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Up copyWith(void Function(Up) updates) =>
      super.copyWith((message) => updates(message as Up)) as Up;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Up create() => Up._();
  @$core.override
  Up createEmptyInstance() => create();
  static $pb.PbList<Up> createRepeated() => $pb.PbList<Up>();
  @$core.pragma('dart2js:noInline')
  static Up getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Up>(create);
  static Up? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get desc => $_getSZ(2);
  @$pb.TagNumber(3)
  set desc($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDesc() => $_has(2);
  @$pb.TagNumber(3)
  void clearDesc() => $_clearField(3);

  @$pb.TagNumber(4)
  Avatar get avatar => $_getN(3);
  @$pb.TagNumber(4)
  set avatar(Avatar value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAvatar() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvatar() => $_clearField(4);
  @$pb.TagNumber(4)
  Avatar ensureAvatar() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get officialIcon => $_getIZ(4);
  @$pb.TagNumber(5)
  set officialIcon($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOfficialIcon() => $_has(4);
  @$pb.TagNumber(5)
  void clearOfficialIcon() => $_clearField(5);

  @$pb.TagNumber(6)
  Button get descButton => $_getN(5);
  @$pb.TagNumber(6)
  set descButton(Button value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasDescButton() => $_has(5);
  @$pb.TagNumber(6)
  void clearDescButton() => $_clearField(6);
  @$pb.TagNumber(6)
  Button ensureDescButton() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get cooperation => $_getSZ(6);
  @$pb.TagNumber(7)
  set cooperation($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCooperation() => $_has(6);
  @$pb.TagNumber(7)
  void clearCooperation() => $_clearField(7);
}

class UpArgs extends $pb.GeneratedMessage {
  factory UpArgs({
    $fixnum.Int64? upId,
    $core.String? upName,
    $core.String? upFace,
    $fixnum.Int64? selected,
  }) {
    final result = create();
    if (upId != null) result.upId = upId;
    if (upName != null) result.upName = upName;
    if (upFace != null) result.upFace = upFace;
    if (selected != null) result.selected = selected;
    return result;
  }

  UpArgs._();

  factory UpArgs.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpArgs.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpArgs',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'upId')
    ..aOS(2, _omitFieldNames ? '' : 'upName')
    ..aOS(3, _omitFieldNames ? '' : 'upFace')
    ..aInt64(4, _omitFieldNames ? '' : 'selected')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpArgs clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpArgs copyWith(void Function(UpArgs) updates) =>
      super.copyWith((message) => updates(message as UpArgs)) as UpArgs;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpArgs create() => UpArgs._();
  @$core.override
  UpArgs createEmptyInstance() => create();
  static $pb.PbList<UpArgs> createRepeated() => $pb.PbList<UpArgs>();
  @$core.pragma('dart2js:noInline')
  static UpArgs getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpArgs>(create);
  static UpArgs? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get upId => $_getI64(0);
  @$pb.TagNumber(1)
  set upId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUpId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get upName => $_getSZ(1);
  @$pb.TagNumber(2)
  set upName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUpName() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get upFace => $_getSZ(2);
  @$pb.TagNumber(3)
  set upFace($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUpFace() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpFace() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get selected => $_getI64(3);
  @$pb.TagNumber(4)
  set selected($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSelected() => $_has(3);
  @$pb.TagNumber(4)
  void clearSelected() => $_clearField(4);
}

class WatchLater extends $pb.GeneratedMessage {
  factory WatchLater({
    $fixnum.Int64? aid,
    $core.String? bvid,
  }) {
    final result = create();
    if (aid != null) result.aid = aid;
    if (bvid != null) result.bvid = bvid;
    return result;
  }

  WatchLater._();

  factory WatchLater.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchLater.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchLater',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.card.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aOS(2, _omitFieldNames ? '' : 'bvid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchLater clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchLater copyWith(void Function(WatchLater) updates) =>
      super.copyWith((message) => updates(message as WatchLater)) as WatchLater;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchLater create() => WatchLater._();
  @$core.override
  WatchLater createEmptyInstance() => create();
  static $pb.PbList<WatchLater> createRepeated() => $pb.PbList<WatchLater>();
  @$core.pragma('dart2js:noInline')
  static WatchLater getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchLater>(create);
  static WatchLater? _defaultInstance;

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
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
