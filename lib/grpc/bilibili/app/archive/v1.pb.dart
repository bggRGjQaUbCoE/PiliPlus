// This is a generated file - do not edit.
//
// Generated from bilibili/app/archive/v1.proto.

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

class Arc extends $pb.GeneratedMessage {
  factory Arc({
    $fixnum.Int64? aid,
    $fixnum.Int64? videos,
    $core.int? typeId,
    $core.String? typeName,
    $core.int? copyright,
    $core.String? pic,
    $core.String? title,
    $fixnum.Int64? pubdate,
    $fixnum.Int64? ctime,
    $core.String? desc,
    $core.int? state,
    $core.int? access,
    $core.int? attribute,
    $core.String? tag,
    $core.Iterable<$core.String>? tags,
    $fixnum.Int64? duration,
    $fixnum.Int64? missionId,
    $fixnum.Int64? orderId,
    $core.String? redirectUrl,
    $fixnum.Int64? forward,
    Rights? rights,
    Author? author,
    Stat? stat,
    $core.String? reportResult,
    $core.String? dynamic,
    $fixnum.Int64? firstCid,
    Dimension? dimension,
    $core.Iterable<StaffInfo>? staffInfo,
    $fixnum.Int64? seasonId,
    $fixnum.Int64? attributeV2,
    SeasonTheme? seasonTheme,
    $core.String? shortLinkV2,
    $core.int? upFromV2,
    $core.String? firstFrame,
  }) {
    final result = create();
    if (aid != null) result.aid = aid;
    if (videos != null) result.videos = videos;
    if (typeId != null) result.typeId = typeId;
    if (typeName != null) result.typeName = typeName;
    if (copyright != null) result.copyright = copyright;
    if (pic != null) result.pic = pic;
    if (title != null) result.title = title;
    if (pubdate != null) result.pubdate = pubdate;
    if (ctime != null) result.ctime = ctime;
    if (desc != null) result.desc = desc;
    if (state != null) result.state = state;
    if (access != null) result.access = access;
    if (attribute != null) result.attribute = attribute;
    if (tag != null) result.tag = tag;
    if (tags != null) result.tags.addAll(tags);
    if (duration != null) result.duration = duration;
    if (missionId != null) result.missionId = missionId;
    if (orderId != null) result.orderId = orderId;
    if (redirectUrl != null) result.redirectUrl = redirectUrl;
    if (forward != null) result.forward = forward;
    if (rights != null) result.rights = rights;
    if (author != null) result.author = author;
    if (stat != null) result.stat = stat;
    if (reportResult != null) result.reportResult = reportResult;
    if (dynamic != null) result.dynamic = dynamic;
    if (firstCid != null) result.firstCid = firstCid;
    if (dimension != null) result.dimension = dimension;
    if (staffInfo != null) result.staffInfo.addAll(staffInfo);
    if (seasonId != null) result.seasonId = seasonId;
    if (attributeV2 != null) result.attributeV2 = attributeV2;
    if (seasonTheme != null) result.seasonTheme = seasonTheme;
    if (shortLinkV2 != null) result.shortLinkV2 = shortLinkV2;
    if (upFromV2 != null) result.upFromV2 = upFromV2;
    if (firstFrame != null) result.firstFrame = firstFrame;
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
          _omitMessageNames ? '' : 'bilibili.app.archive.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aInt64(2, _omitFieldNames ? '' : 'videos')
    ..aI(3, _omitFieldNames ? '' : 'typeId')
    ..aOS(4, _omitFieldNames ? '' : 'typeName')
    ..aI(5, _omitFieldNames ? '' : 'copyright')
    ..aOS(6, _omitFieldNames ? '' : 'pic')
    ..aOS(7, _omitFieldNames ? '' : 'title')
    ..aInt64(8, _omitFieldNames ? '' : 'pubdate')
    ..aInt64(9, _omitFieldNames ? '' : 'ctime')
    ..aOS(10, _omitFieldNames ? '' : 'desc')
    ..aI(11, _omitFieldNames ? '' : 'state')
    ..aI(12, _omitFieldNames ? '' : 'access')
    ..aI(13, _omitFieldNames ? '' : 'attribute')
    ..aOS(14, _omitFieldNames ? '' : 'tag')
    ..pPS(15, _omitFieldNames ? '' : 'tags')
    ..aInt64(16, _omitFieldNames ? '' : 'duration')
    ..aInt64(17, _omitFieldNames ? '' : 'missionId')
    ..aInt64(18, _omitFieldNames ? '' : 'orderId')
    ..aOS(19, _omitFieldNames ? '' : 'redirectUrl')
    ..aInt64(20, _omitFieldNames ? '' : 'forward')
    ..aOM<Rights>(21, _omitFieldNames ? '' : 'rights',
        subBuilder: Rights.create)
    ..aOM<Author>(22, _omitFieldNames ? '' : 'author',
        subBuilder: Author.create)
    ..aOM<Stat>(23, _omitFieldNames ? '' : 'stat', subBuilder: Stat.create)
    ..aOS(24, _omitFieldNames ? '' : 'reportResult')
    ..aOS(25, _omitFieldNames ? '' : 'dynamic')
    ..aInt64(26, _omitFieldNames ? '' : 'firstCid')
    ..aOM<Dimension>(27, _omitFieldNames ? '' : 'dimension',
        subBuilder: Dimension.create)
    ..pPM<StaffInfo>(28, _omitFieldNames ? '' : 'staffInfo',
        subBuilder: StaffInfo.create)
    ..aInt64(29, _omitFieldNames ? '' : 'seasonId')
    ..aInt64(30, _omitFieldNames ? '' : 'attributeV2')
    ..aOM<SeasonTheme>(31, _omitFieldNames ? '' : 'seasonTheme',
        subBuilder: SeasonTheme.create)
    ..aOS(40, _omitFieldNames ? '' : 'shortLinkV2')
    ..aI(41, _omitFieldNames ? '' : 'upFromV2')
    ..aOS(42, _omitFieldNames ? '' : 'firstFrame')
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
  static $pb.PbList<Arc> createRepeated() => $pb.PbList<Arc>();
  @$core.pragma('dart2js:noInline')
  static Arc getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Arc>(create);
  static Arc? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get aid => $_getI64(0);
  @$pb.TagNumber(1)
  set aid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => $_clearField(1);

  /// 分 P 数
  @$pb.TagNumber(2)
  $fixnum.Int64 get videos => $_getI64(1);
  @$pb.TagNumber(2)
  set videos($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVideos() => $_has(1);
  @$pb.TagNumber(2)
  void clearVideos() => $_clearField(2);

  /// 分区 ID
  @$pb.TagNumber(3)
  $core.int get typeId => $_getIZ(2);
  @$pb.TagNumber(3)
  set typeId($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTypeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTypeId() => $_clearField(3);

  /// 分区名称
  @$pb.TagNumber(4)
  $core.String get typeName => $_getSZ(3);
  @$pb.TagNumber(4)
  set typeName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTypeName() => $_has(3);
  @$pb.TagNumber(4)
  void clearTypeName() => $_clearField(4);

  /// 是否转载
  ///
  /// - 0: 历史上可能遗留的脏数据
  /// - 1: 原创
  /// - 2: 转载
  @$pb.TagNumber(5)
  $core.int get copyright => $_getIZ(4);
  @$pb.TagNumber(5)
  set copyright($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCopyright() => $_has(4);
  @$pb.TagNumber(5)
  void clearCopyright() => $_clearField(5);

  /// 封面地址
  @$pb.TagNumber(6)
  $core.String get pic => $_getSZ(5);
  @$pb.TagNumber(6)
  set pic($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPic() => $_has(5);
  @$pb.TagNumber(6)
  void clearPic() => $_clearField(6);

  /// 标题
  @$pb.TagNumber(7)
  $core.String get title => $_getSZ(6);
  @$pb.TagNumber(7)
  set title($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTitle() => $_has(6);
  @$pb.TagNumber(7)
  void clearTitle() => $_clearField(7);

  /// 发布时间戳
  @$pb.TagNumber(8)
  $fixnum.Int64 get pubdate => $_getI64(7);
  @$pb.TagNumber(8)
  set pubdate($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPubdate() => $_has(7);
  @$pb.TagNumber(8)
  void clearPubdate() => $_clearField(8);

  /// 提交时间戳
  @$pb.TagNumber(9)
  $fixnum.Int64 get ctime => $_getI64(8);
  @$pb.TagNumber(9)
  set ctime($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCtime() => $_has(8);
  @$pb.TagNumber(9)
  void clearCtime() => $_clearField(9);

  /// 简介
  @$pb.TagNumber(10)
  $core.String get desc => $_getSZ(9);
  @$pb.TagNumber(10)
  set desc($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDesc() => $_has(9);
  @$pb.TagNumber(10)
  void clearDesc() => $_clearField(10);

  /// 状态 (>= 0 为正常可见状态)
  @$pb.TagNumber(11)
  $core.int get state => $_getIZ(10);
  @$pb.TagNumber(11)
  set state($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasState() => $_has(10);
  @$pb.TagNumber(11)
  void clearState() => $_clearField(11);

  /// 是否可访问
  ///
  /// - 0: 公开
  /// - 10000: 仅登录用户
  @$pb.TagNumber(12)
  $core.int get access => $_getIZ(11);
  @$pb.TagNumber(12)
  set access($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAccess() => $_has(11);
  @$pb.TagNumber(12)
  void clearAccess() => $_clearField(12);

  /// 属性
  @$pb.TagNumber(13)
  $core.int get attribute => $_getIZ(12);
  @$pb.TagNumber(13)
  set attribute($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasAttribute() => $_has(12);
  @$pb.TagNumber(13)
  void clearAttribute() => $_clearField(13);

  /// Deprecated
  @$pb.TagNumber(14)
  $core.String get tag => $_getSZ(13);
  @$pb.TagNumber(14)
  set tag($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasTag() => $_has(13);
  @$pb.TagNumber(14)
  void clearTag() => $_clearField(14);

  /// Deprecated
  @$pb.TagNumber(15)
  $pb.PbList<$core.String> get tags => $_getList(14);

  /// 所有分 P 加起来的总时长 (seconds)
  @$pb.TagNumber(16)
  $fixnum.Int64 get duration => $_getI64(15);
  @$pb.TagNumber(16)
  set duration($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasDuration() => $_has(15);
  @$pb.TagNumber(16)
  void clearDuration() => $_clearField(16);

  /// 参与的活动 id
  @$pb.TagNumber(17)
  $fixnum.Int64 get missionId => $_getI64(16);
  @$pb.TagNumber(17)
  set missionId($fixnum.Int64 value) => $_setInt64(16, value);
  @$pb.TagNumber(17)
  $core.bool hasMissionId() => $_has(16);
  @$pb.TagNumber(17)
  void clearMissionId() => $_clearField(17);

  /// 参与的商单 id
  @$pb.TagNumber(18)
  $fixnum.Int64 get orderId => $_getI64(17);
  @$pb.TagNumber(18)
  set orderId($fixnum.Int64 value) => $_setInt64(17, value);
  @$pb.TagNumber(18)
  $core.bool hasOrderId() => $_has(17);
  @$pb.TagNumber(18)
  void clearOrderId() => $_clearField(18);

  /// 强制跳转地址
  @$pb.TagNumber(19)
  $core.String get redirectUrl => $_getSZ(18);
  @$pb.TagNumber(19)
  set redirectUrl($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasRedirectUrl() => $_has(18);
  @$pb.TagNumber(19)
  void clearRedirectUrl() => $_clearField(19);

  @$pb.TagNumber(20)
  $fixnum.Int64 get forward => $_getI64(19);
  @$pb.TagNumber(20)
  set forward($fixnum.Int64 value) => $_setInt64(19, value);
  @$pb.TagNumber(20)
  $core.bool hasForward() => $_has(19);
  @$pb.TagNumber(20)
  void clearForward() => $_clearField(20);

  /// 参见 [`Rights`]
  @$pb.TagNumber(21)
  Rights get rights => $_getN(20);
  @$pb.TagNumber(21)
  set rights(Rights value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasRights() => $_has(20);
  @$pb.TagNumber(21)
  void clearRights() => $_clearField(21);
  @$pb.TagNumber(21)
  Rights ensureRights() => $_ensure(20);

  /// 稿件作者信息, 参见 [`Author`]
  @$pb.TagNumber(22)
  Author get author => $_getN(21);
  @$pb.TagNumber(22)
  set author(Author value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasAuthor() => $_has(21);
  @$pb.TagNumber(22)
  void clearAuthor() => $_clearField(22);
  @$pb.TagNumber(22)
  Author ensureAuthor() => $_ensure(21);

  /// 稿件计数信息, 参见 [`Stat`]
  @$pb.TagNumber(23)
  Stat get stat => $_getN(22);
  @$pb.TagNumber(23)
  set stat(Stat value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasStat() => $_has(22);
  @$pb.TagNumber(23)
  void clearStat() => $_clearField(23);
  @$pb.TagNumber(23)
  Stat ensureStat() => $_ensure(22);

  @$pb.TagNumber(24)
  $core.String get reportResult => $_getSZ(23);
  @$pb.TagNumber(24)
  set reportResult($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasReportResult() => $_has(23);
  @$pb.TagNumber(24)
  void clearReportResult() => $_clearField(24);

  /// 发布时动态描述
  @$pb.TagNumber(25)
  $core.String get dynamic => $_getSZ(24);
  @$pb.TagNumber(25)
  set dynamic($core.String value) => $_setString(24, value);
  @$pb.TagNumber(25)
  $core.bool hasDynamic() => $_has(24);
  @$pb.TagNumber(25)
  void clearDynamic() => $_clearField(25);

  /// 首个分 P 的 cid
  @$pb.TagNumber(26)
  $fixnum.Int64 get firstCid => $_getI64(25);
  @$pb.TagNumber(26)
  set firstCid($fixnum.Int64 value) => $_setInt64(25, value);
  @$pb.TagNumber(26)
  $core.bool hasFirstCid() => $_has(25);
  @$pb.TagNumber(26)
  void clearFirstCid() => $_clearField(26);

  /// 首个分 P 的分辨率
  @$pb.TagNumber(27)
  Dimension get dimension => $_getN(26);
  @$pb.TagNumber(27)
  set dimension(Dimension value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasDimension() => $_has(26);
  @$pb.TagNumber(27)
  void clearDimension() => $_clearField(27);
  @$pb.TagNumber(27)
  Dimension ensureDimension() => $_ensure(26);

  /// 联合投稿信息
  @$pb.TagNumber(28)
  $pb.PbList<StaffInfo> get staffInfo => $_getList(27);

  /// UGC 剧集 ID
  @$pb.TagNumber(29)
  $fixnum.Int64 get seasonId => $_getI64(28);
  @$pb.TagNumber(29)
  set seasonId($fixnum.Int64 value) => $_setInt64(28, value);
  @$pb.TagNumber(29)
  $core.bool hasSeasonId() => $_has(28);
  @$pb.TagNumber(29)
  void clearSeasonId() => $_clearField(29);

  /// 属性 (旧的 int32 不够用了)
  @$pb.TagNumber(30)
  $fixnum.Int64 get attributeV2 => $_getI64(29);
  @$pb.TagNumber(30)
  set attributeV2($fixnum.Int64 value) => $_setInt64(29, value);
  @$pb.TagNumber(30)
  $core.bool hasAttributeV2() => $_has(29);
  @$pb.TagNumber(30)
  void clearAttributeV2() => $_clearField(30);

  /// ? UGC 剧集主题
  @$pb.TagNumber(31)
  SeasonTheme get seasonTheme => $_getN(30);
  @$pb.TagNumber(31)
  set seasonTheme(SeasonTheme value) => $_setField(31, value);
  @$pb.TagNumber(31)
  $core.bool hasSeasonTheme() => $_has(30);
  @$pb.TagNumber(31)
  void clearSeasonTheme() => $_clearField(31);
  @$pb.TagNumber(31)
  SeasonTheme ensureSeasonTheme() => $_ensure(30);

  /// ? 短链接
  @$pb.TagNumber(40)
  $core.String get shortLinkV2 => $_getSZ(31);
  @$pb.TagNumber(40)
  set shortLinkV2($core.String value) => $_setString(31, value);
  @$pb.TagNumber(40)
  $core.bool hasShortLinkV2() => $_has(31);
  @$pb.TagNumber(40)
  void clearShortLinkV2() => $_clearField(40);

  @$pb.TagNumber(41)
  $core.int get upFromV2 => $_getIZ(32);
  @$pb.TagNumber(41)
  set upFromV2($core.int value) => $_setSignedInt32(32, value);
  @$pb.TagNumber(41)
  $core.bool hasUpFromV2() => $_has(32);
  @$pb.TagNumber(41)
  void clearUpFromV2() => $_clearField(41);

  @$pb.TagNumber(42)
  $core.String get firstFrame => $_getSZ(33);
  @$pb.TagNumber(42)
  set firstFrame($core.String value) => $_setString(33, value);
  @$pb.TagNumber(42)
  $core.bool hasFirstFrame() => $_has(33);
  @$pb.TagNumber(42)
  void clearFirstFrame() => $_clearField(42);
}

/// 作者信息
class Author extends $pb.GeneratedMessage {
  factory Author({
    $fixnum.Int64? mid,
    $core.String? name,
    $core.String? face,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    if (name != null) result.name = name;
    if (face != null) result.face = face;
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
          _omitMessageNames ? '' : 'bilibili.app.archive.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'face')
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

  /// UP mid
  @$pb.TagNumber(1)
  $fixnum.Int64 get mid => $_getI64(0);
  @$pb.TagNumber(1)
  set mid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearMid() => $_clearField(1);

  /// UP 昵称
  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// UP 头像
  @$pb.TagNumber(3)
  $core.String get face => $_getSZ(2);
  @$pb.TagNumber(3)
  set face($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFace() => $_has(2);
  @$pb.TagNumber(3)
  void clearFace() => $_clearField(3);
}

/// 视频分辨率
class Dimension extends $pb.GeneratedMessage {
  factory Dimension({
    $fixnum.Int64? width,
    $fixnum.Int64? height,
    $fixnum.Int64? rotate,
  }) {
    final result = create();
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (rotate != null) result.rotate = rotate;
    return result;
  }

  Dimension._();

  factory Dimension.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Dimension.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Dimension',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.archive.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'width')
    ..aInt64(2, _omitFieldNames ? '' : 'height')
    ..aInt64(3, _omitFieldNames ? '' : 'rotate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Dimension clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Dimension copyWith(void Function(Dimension) updates) =>
      super.copyWith((message) => updates(message as Dimension)) as Dimension;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Dimension create() => Dimension._();
  @$core.override
  Dimension createEmptyInstance() => create();
  static $pb.PbList<Dimension> createRepeated() => $pb.PbList<Dimension>();
  @$core.pragma('dart2js:noInline')
  static Dimension getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Dimension>(create);
  static Dimension? _defaultInstance;

  /// 宽
  @$pb.TagNumber(1)
  $fixnum.Int64 get width => $_getI64(0);
  @$pb.TagNumber(1)
  set width($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => $_clearField(1);

  /// 高
  @$pb.TagNumber(2)
  $fixnum.Int64 get height => $_getI64(1);
  @$pb.TagNumber(2)
  set height($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => $_clearField(2);

  /// 是否竖屏
  @$pb.TagNumber(3)
  $fixnum.Int64 get rotate => $_getI64(2);
  @$pb.TagNumber(3)
  set rotate($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRotate() => $_has(2);
  @$pb.TagNumber(3)
  void clearRotate() => $_clearField(3);
}

/// 分 P 信息
class Page extends $pb.GeneratedMessage {
  factory Page({
    $fixnum.Int64? cid,
    $core.int? page,
    $core.String? from,
    $core.String? part,
    $fixnum.Int64? duration,
    $core.String? vid,
    $core.String? desc,
    $core.String? webLink,
    Dimension? dimension,
    $core.String? firstFrame,
  }) {
    final result = create();
    if (cid != null) result.cid = cid;
    if (page != null) result.page = page;
    if (from != null) result.from = from;
    if (part != null) result.part = part;
    if (duration != null) result.duration = duration;
    if (vid != null) result.vid = vid;
    if (desc != null) result.desc = desc;
    if (webLink != null) result.webLink = webLink;
    if (dimension != null) result.dimension = dimension;
    if (firstFrame != null) result.firstFrame = firstFrame;
    return result;
  }

  Page._();

  factory Page.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Page.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Page',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.archive.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'cid')
    ..aI(2, _omitFieldNames ? '' : 'page')
    ..aOS(3, _omitFieldNames ? '' : 'from')
    ..aOS(4, _omitFieldNames ? '' : 'part')
    ..aInt64(5, _omitFieldNames ? '' : 'duration')
    ..aOS(6, _omitFieldNames ? '' : 'vid')
    ..aOS(7, _omitFieldNames ? '' : 'desc')
    ..aOS(8, _omitFieldNames ? '' : 'webLink')
    ..aOM<Dimension>(9, _omitFieldNames ? '' : 'dimension',
        subBuilder: Dimension.create)
    ..aOS(10, _omitFieldNames ? '' : 'firstFrame')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Page clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Page copyWith(void Function(Page) updates) =>
      super.copyWith((message) => updates(message as Page)) as Page;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Page create() => Page._();
  @$core.override
  Page createEmptyInstance() => create();
  static $pb.PbList<Page> createRepeated() => $pb.PbList<Page>();
  @$core.pragma('dart2js:noInline')
  static Page getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Page>(create);
  static Page? _defaultInstance;

  /// 视频流 CID
  @$pb.TagNumber(1)
  $fixnum.Int64 get cid => $_getI64(0);
  @$pb.TagNumber(1)
  set cid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCid() => $_clearField(1);

  /// 视频序号
  @$pb.TagNumber(2)
  $core.int get page => $_getIZ(1);
  @$pb.TagNumber(2)
  set page($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPage() => $_has(1);
  @$pb.TagNumber(2)
  void clearPage() => $_clearField(2);

  /// 视频来源
  ///
  /// - vupload
  /// - qq: Tencent
  /// - hunan: Hunan TV
  @$pb.TagNumber(3)
  $core.String get from => $_getSZ(2);
  @$pb.TagNumber(3)
  set from($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFrom() => $_has(2);
  @$pb.TagNumber(3)
  void clearFrom() => $_clearField(3);

  /// 视频标题
  @$pb.TagNumber(4)
  $core.String get part => $_getSZ(3);
  @$pb.TagNumber(4)
  set part($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPart() => $_has(3);
  @$pb.TagNumber(4)
  void clearPart() => $_clearField(4);

  /// 视频时长 (seconds)
  @$pb.TagNumber(5)
  $fixnum.Int64 get duration => $_getI64(4);
  @$pb.TagNumber(5)
  set duration($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDuration() => $_has(4);
  @$pb.TagNumber(5)
  void clearDuration() => $_clearField(5);

  /// 站外视频 vid
  @$pb.TagNumber(6)
  $core.String get vid => $_getSZ(5);
  @$pb.TagNumber(6)
  set vid($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVid() => $_has(5);
  @$pb.TagNumber(6)
  void clearVid() => $_clearField(6);

  /// 视频简介
  @$pb.TagNumber(7)
  $core.String get desc => $_getSZ(6);
  @$pb.TagNumber(7)
  set desc($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDesc() => $_has(6);
  @$pb.TagNumber(7)
  void clearDesc() => $_clearField(7);

  /// 站外视频跳转地址
  @$pb.TagNumber(8)
  $core.String get webLink => $_getSZ(7);
  @$pb.TagNumber(8)
  set webLink($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasWebLink() => $_has(7);
  @$pb.TagNumber(8)
  void clearWebLink() => $_clearField(8);

  /// 见 [`Dimension`]
  @$pb.TagNumber(9)
  Dimension get dimension => $_getN(8);
  @$pb.TagNumber(9)
  set dimension(Dimension value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasDimension() => $_has(8);
  @$pb.TagNumber(9)
  void clearDimension() => $_clearField(9);
  @$pb.TagNumber(9)
  Dimension ensureDimension() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get firstFrame => $_getSZ(9);
  @$pb.TagNumber(10)
  set firstFrame($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasFirstFrame() => $_has(9);
  @$pb.TagNumber(10)
  void clearFirstFrame() => $_clearField(10);
}

/// 常用属性, 0 否 1 是
class Rights extends $pb.GeneratedMessage {
  factory Rights({
    $core.int? bp,
    $core.int? elec,
    $core.int? download,
    $core.int? movie,
    $core.int? pay,
    $core.int? hd5,
    $core.int? noReprint,
    $core.int? autoplay,
    $core.int? ugcPay,
    $core.int? isCooperation,
    $core.int? ugcPayPreview,
    $core.int? noBackground,
    $core.int? arcPay,
    $core.int? payFreeWatch,
  }) {
    final result = create();
    if (bp != null) result.bp = bp;
    if (elec != null) result.elec = elec;
    if (download != null) result.download = download;
    if (movie != null) result.movie = movie;
    if (pay != null) result.pay = pay;
    if (hd5 != null) result.hd5 = hd5;
    if (noReprint != null) result.noReprint = noReprint;
    if (autoplay != null) result.autoplay = autoplay;
    if (ugcPay != null) result.ugcPay = ugcPay;
    if (isCooperation != null) result.isCooperation = isCooperation;
    if (ugcPayPreview != null) result.ugcPayPreview = ugcPayPreview;
    if (noBackground != null) result.noBackground = noBackground;
    if (arcPay != null) result.arcPay = arcPay;
    if (payFreeWatch != null) result.payFreeWatch = payFreeWatch;
    return result;
  }

  Rights._();

  factory Rights.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Rights.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Rights',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.archive.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'bp')
    ..aI(2, _omitFieldNames ? '' : 'elec')
    ..aI(3, _omitFieldNames ? '' : 'download')
    ..aI(4, _omitFieldNames ? '' : 'movie')
    ..aI(5, _omitFieldNames ? '' : 'pay')
    ..aI(6, _omitFieldNames ? '' : 'hd5')
    ..aI(7, _omitFieldNames ? '' : 'noReprint')
    ..aI(8, _omitFieldNames ? '' : 'autoplay')
    ..aI(9, _omitFieldNames ? '' : 'ugcPay')
    ..aI(10, _omitFieldNames ? '' : 'isCooperation')
    ..aI(11, _omitFieldNames ? '' : 'ugcPayPreview')
    ..aI(12, _omitFieldNames ? '' : 'noBackground')
    ..aI(13, _omitFieldNames ? '' : 'arcPay')
    ..aI(14, _omitFieldNames ? '' : 'payFreeWatch')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Rights clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Rights copyWith(void Function(Rights) updates) =>
      super.copyWith((message) => updates(message as Rights)) as Rights;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Rights create() => Rights._();
  @$core.override
  Rights createEmptyInstance() => create();
  static $pb.PbList<Rights> createRepeated() => $pb.PbList<Rights>();
  @$core.pragma('dart2js:noInline')
  static Rights getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Rights>(create);
  static Rights? _defaultInstance;

  /// 是否付费(旧版)
  @$pb.TagNumber(1)
  $core.int get bp => $_getIZ(0);
  @$pb.TagNumber(1)
  set bp($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBp() => $_has(0);
  @$pb.TagNumber(1)
  void clearBp() => $_clearField(1);

  /// 是否支持充电
  @$pb.TagNumber(2)
  $core.int get elec => $_getIZ(1);
  @$pb.TagNumber(2)
  set elec($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasElec() => $_has(1);
  @$pb.TagNumber(2)
  void clearElec() => $_clearField(2);

  /// 是否下载
  @$pb.TagNumber(3)
  $core.int get download => $_getIZ(2);
  @$pb.TagNumber(3)
  set download($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDownload() => $_has(2);
  @$pb.TagNumber(3)
  void clearDownload() => $_clearField(3);

  /// 是否电影
  @$pb.TagNumber(4)
  $core.int get movie => $_getIZ(3);
  @$pb.TagNumber(4)
  set movie($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMovie() => $_has(3);
  @$pb.TagNumber(4)
  void clearMovie() => $_clearField(4);

  /// 是否是需要付费的 PGC 稿件
  @$pb.TagNumber(5)
  $core.int get pay => $_getIZ(4);
  @$pb.TagNumber(5)
  set pay($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPay() => $_has(4);
  @$pb.TagNumber(5)
  void clearPay() => $_clearField(5);

  /// Deprecated
  @$pb.TagNumber(6)
  $core.int get hd5 => $_getIZ(5);
  @$pb.TagNumber(6)
  set hd5($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHd5() => $_has(5);
  @$pb.TagNumber(6)
  void clearHd5() => $_clearField(6);

  /// 是否允许转发
  @$pb.TagNumber(7)
  $core.int get noReprint => $_getIZ(6);
  @$pb.TagNumber(7)
  set noReprint($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNoReprint() => $_has(6);
  @$pb.TagNumber(7)
  void clearNoReprint() => $_clearField(7);

  /// 是否可以自动播放
  @$pb.TagNumber(8)
  $core.int get autoplay => $_getIZ(7);
  @$pb.TagNumber(8)
  set autoplay($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAutoplay() => $_has(7);
  @$pb.TagNumber(8)
  void clearAutoplay() => $_clearField(8);

  /// 是否是需要付费的 UGC 稿件
  @$pb.TagNumber(9)
  $core.int get ugcPay => $_getIZ(8);
  @$pb.TagNumber(9)
  set ugcPay($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUgcPay() => $_has(8);
  @$pb.TagNumber(9)
  void clearUgcPay() => $_clearField(9);

  /// 是否联合投稿
  @$pb.TagNumber(10)
  $core.int get isCooperation => $_getIZ(9);
  @$pb.TagNumber(10)
  set isCooperation($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIsCooperation() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsCooperation() => $_clearField(10);

  /// 需要付费的 PGC 稿件是否支持预览
  @$pb.TagNumber(11)
  $core.int get ugcPayPreview => $_getIZ(10);
  @$pb.TagNumber(11)
  set ugcPayPreview($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasUgcPayPreview() => $_has(10);
  @$pb.TagNumber(11)
  void clearUgcPayPreview() => $_clearField(11);

  /// 是否禁止后台播放
  @$pb.TagNumber(12)
  $core.int get noBackground => $_getIZ(11);
  @$pb.TagNumber(12)
  set noBackground($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasNoBackground() => $_has(11);
  @$pb.TagNumber(12)
  void clearNoBackground() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get arcPay => $_getIZ(12);
  @$pb.TagNumber(13)
  set arcPay($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasArcPay() => $_has(12);
  @$pb.TagNumber(13)
  void clearArcPay() => $_clearField(13);

  /// ? 需要付费的稿件是否支持免费畅览
  @$pb.TagNumber(14)
  $core.int get payFreeWatch => $_getIZ(13);
  @$pb.TagNumber(14)
  set payFreeWatch($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasPayFreeWatch() => $_has(13);
  @$pb.TagNumber(14)
  void clearPayFreeWatch() => $_clearField(14);
}

class SeasonTheme extends $pb.GeneratedMessage {
  factory SeasonTheme({
    $core.String? bgColor,
    $core.String? selectedBgColor,
    $core.String? textColor,
  }) {
    final result = create();
    if (bgColor != null) result.bgColor = bgColor;
    if (selectedBgColor != null) result.selectedBgColor = selectedBgColor;
    if (textColor != null) result.textColor = textColor;
    return result;
  }

  SeasonTheme._();

  factory SeasonTheme.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SeasonTheme.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeasonTheme',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.archive.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'bgColor')
    ..aOS(2, _omitFieldNames ? '' : 'selectedBgColor')
    ..aOS(3, _omitFieldNames ? '' : 'textColor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeasonTheme clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeasonTheme copyWith(void Function(SeasonTheme) updates) =>
      super.copyWith((message) => updates(message as SeasonTheme))
          as SeasonTheme;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SeasonTheme create() => SeasonTheme._();
  @$core.override
  SeasonTheme createEmptyInstance() => create();
  static $pb.PbList<SeasonTheme> createRepeated() => $pb.PbList<SeasonTheme>();
  @$core.pragma('dart2js:noInline')
  static SeasonTheme getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeasonTheme>(create);
  static SeasonTheme? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get bgColor => $_getSZ(0);
  @$pb.TagNumber(1)
  set bgColor($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBgColor() => $_has(0);
  @$pb.TagNumber(1)
  void clearBgColor() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get selectedBgColor => $_getSZ(1);
  @$pb.TagNumber(2)
  set selectedBgColor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSelectedBgColor() => $_has(1);
  @$pb.TagNumber(2)
  void clearSelectedBgColor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get textColor => $_getSZ(2);
  @$pb.TagNumber(3)
  set textColor($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTextColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextColor() => $_clearField(3);
}

/// 联合投稿成员
class StaffInfo extends $pb.GeneratedMessage {
  factory StaffInfo({
    $fixnum.Int64? mid,
    $core.String? title,
    $fixnum.Int64? attribute,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    if (title != null) result.title = title;
    if (attribute != null) result.attribute = attribute;
    return result;
  }

  StaffInfo._();

  factory StaffInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StaffInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StaffInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.archive.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aInt64(3, _omitFieldNames ? '' : 'attribute')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StaffInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StaffInfo copyWith(void Function(StaffInfo) updates) =>
      super.copyWith((message) => updates(message as StaffInfo)) as StaffInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StaffInfo create() => StaffInfo._();
  @$core.override
  StaffInfo createEmptyInstance() => create();
  static $pb.PbList<StaffInfo> createRepeated() => $pb.PbList<StaffInfo>();
  @$core.pragma('dart2js:noInline')
  static StaffInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StaffInfo>(create);
  static StaffInfo? _defaultInstance;

  /// 联合投稿成员 mid
  @$pb.TagNumber(1)
  $fixnum.Int64 get mid => $_getI64(0);
  @$pb.TagNumber(1)
  set mid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearMid() => $_clearField(1);

  /// 联合投稿成员角色
  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  /// 属性
  @$pb.TagNumber(3)
  $fixnum.Int64 get attribute => $_getI64(2);
  @$pb.TagNumber(3)
  set attribute($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAttribute() => $_has(2);
  @$pb.TagNumber(3)
  void clearAttribute() => $_clearField(3);
}

/// 计数相关信息
class Stat extends $pb.GeneratedMessage {
  factory Stat({
    $fixnum.Int64? aid,
    $core.int? view,
    $core.int? danmaku,
    $core.int? reply,
    $core.int? fav,
    $core.int? coin,
    $core.int? share,
    $core.int? nowRank,
    $core.int? hisRank,
    $core.int? like,
    $core.int? dislike,
  }) {
    final result = create();
    if (aid != null) result.aid = aid;
    if (view != null) result.view = view;
    if (danmaku != null) result.danmaku = danmaku;
    if (reply != null) result.reply = reply;
    if (fav != null) result.fav = fav;
    if (coin != null) result.coin = coin;
    if (share != null) result.share = share;
    if (nowRank != null) result.nowRank = nowRank;
    if (hisRank != null) result.hisRank = hisRank;
    if (like != null) result.like = like;
    if (dislike != null) result.dislike = dislike;
    return result;
  }

  Stat._();

  factory Stat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Stat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Stat',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.archive.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aI(2, _omitFieldNames ? '' : 'view')
    ..aI(3, _omitFieldNames ? '' : 'danmaku')
    ..aI(4, _omitFieldNames ? '' : 'reply')
    ..aI(5, _omitFieldNames ? '' : 'fav')
    ..aI(6, _omitFieldNames ? '' : 'coin')
    ..aI(7, _omitFieldNames ? '' : 'share')
    ..aI(8, _omitFieldNames ? '' : 'nowRank')
    ..aI(9, _omitFieldNames ? '' : 'hisRank')
    ..aI(10, _omitFieldNames ? '' : 'like')
    ..aI(11, _omitFieldNames ? '' : 'dislike')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Stat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Stat copyWith(void Function(Stat) updates) =>
      super.copyWith((message) => updates(message as Stat)) as Stat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Stat create() => Stat._();
  @$core.override
  Stat createEmptyInstance() => create();
  static $pb.PbList<Stat> createRepeated() => $pb.PbList<Stat>();
  @$core.pragma('dart2js:noInline')
  static Stat getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Stat>(create);
  static Stat? _defaultInstance;

  /// 稿件 avid
  @$pb.TagNumber(1)
  $fixnum.Int64 get aid => $_getI64(0);
  @$pb.TagNumber(1)
  set aid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => $_clearField(1);

  /// 播放量
  @$pb.TagNumber(2)
  $core.int get view => $_getIZ(1);
  @$pb.TagNumber(2)
  set view($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasView() => $_has(1);
  @$pb.TagNumber(2)
  void clearView() => $_clearField(2);

  /// 弹幕数
  @$pb.TagNumber(3)
  $core.int get danmaku => $_getIZ(2);
  @$pb.TagNumber(3)
  set danmaku($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDanmaku() => $_has(2);
  @$pb.TagNumber(3)
  void clearDanmaku() => $_clearField(3);

  /// 评论数
  @$pb.TagNumber(4)
  $core.int get reply => $_getIZ(3);
  @$pb.TagNumber(4)
  set reply($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReply() => $_has(3);
  @$pb.TagNumber(4)
  void clearReply() => $_clearField(4);

  /// 收藏数
  @$pb.TagNumber(5)
  $core.int get fav => $_getIZ(4);
  @$pb.TagNumber(5)
  set fav($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFav() => $_has(4);
  @$pb.TagNumber(5)
  void clearFav() => $_clearField(5);

  /// 投币数
  @$pb.TagNumber(6)
  $core.int get coin => $_getIZ(5);
  @$pb.TagNumber(6)
  set coin($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCoin() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoin() => $_clearField(6);

  /// 分享数
  @$pb.TagNumber(7)
  $core.int get share => $_getIZ(6);
  @$pb.TagNumber(7)
  set share($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasShare() => $_has(6);
  @$pb.TagNumber(7)
  void clearShare() => $_clearField(7);

  /// 当前排名
  @$pb.TagNumber(8)
  $core.int get nowRank => $_getIZ(7);
  @$pb.TagNumber(8)
  set nowRank($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasNowRank() => $_has(7);
  @$pb.TagNumber(8)
  void clearNowRank() => $_clearField(8);

  /// 历史最高排名
  @$pb.TagNumber(9)
  $core.int get hisRank => $_getIZ(8);
  @$pb.TagNumber(9)
  set hisRank($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasHisRank() => $_has(8);
  @$pb.TagNumber(9)
  void clearHisRank() => $_clearField(9);

  /// 点赞数
  @$pb.TagNumber(10)
  $core.int get like => $_getIZ(9);
  @$pb.TagNumber(10)
  set like($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasLike() => $_has(9);
  @$pb.TagNumber(10)
  void clearLike() => $_clearField(10);

  /// 点踩数 (Deprecated)
  @$pb.TagNumber(11)
  $core.int get dislike => $_getIZ(10);
  @$pb.TagNumber(11)
  set dislike($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDislike() => $_has(10);
  @$pb.TagNumber(11)
  void clearDislike() => $_clearField(11);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
