// This is a generated file - do not edit.
//
// Generated from bilibili/app/archive/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Arc extends $pb.GeneratedMessage {
  factory Arc({
    $fixnum.Int64? aid,
    $fixnum.Int64? videos,
    $core.String? pic,
    $core.String? title,
    $fixnum.Int64? pubdate,
    $fixnum.Int64? ctime,
    $fixnum.Int64? duration,
    $core.String? redirectUrl,
    Author? author,
    Stat? stat,
    $fixnum.Int64? firstCid,
    Dimension? dimension,
    $fixnum.Int64? seasonId,
  }) {
    final result = create();
    if (aid != null) result.aid = aid;
    if (videos != null) result.videos = videos;
    if (pic != null) result.pic = pic;
    if (title != null) result.title = title;
    if (pubdate != null) result.pubdate = pubdate;
    if (ctime != null) result.ctime = ctime;
    if (duration != null) result.duration = duration;
    if (redirectUrl != null) result.redirectUrl = redirectUrl;
    if (author != null) result.author = author;
    if (stat != null) result.stat = stat;
    if (firstCid != null) result.firstCid = firstCid;
    if (dimension != null) result.dimension = dimension;
    if (seasonId != null) result.seasonId = seasonId;
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
    ..aOS(6, _omitFieldNames ? '' : 'pic')
    ..aOS(7, _omitFieldNames ? '' : 'title')
    ..aInt64(8, _omitFieldNames ? '' : 'pubdate')
    ..aInt64(9, _omitFieldNames ? '' : 'ctime')
    ..aInt64(16, _omitFieldNames ? '' : 'duration')
    ..aOS(19, _omitFieldNames ? '' : 'redirectUrl')
    ..aOM<Author>(22, _omitFieldNames ? '' : 'author',
        subBuilder: Author.create)
    ..aOM<Stat>(23, _omitFieldNames ? '' : 'stat', subBuilder: Stat.create)
    ..aInt64(26, _omitFieldNames ? '' : 'firstCid')
    ..aOM<Dimension>(27, _omitFieldNames ? '' : 'dimension',
        subBuilder: Dimension.create)
    ..aInt64(29, _omitFieldNames ? '' : 'seasonId')
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

  /// 封面地址
  @$pb.TagNumber(6)
  $core.String get pic => $_getSZ(2);
  @$pb.TagNumber(6)
  set pic($core.String value) => $_setString(2, value);
  @$pb.TagNumber(6)
  $core.bool hasPic() => $_has(2);
  @$pb.TagNumber(6)
  void clearPic() => $_clearField(6);

  /// 标题
  @$pb.TagNumber(7)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(7)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(7)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(7)
  void clearTitle() => $_clearField(7);

  /// 发布时间戳
  @$pb.TagNumber(8)
  $fixnum.Int64 get pubdate => $_getI64(4);
  @$pb.TagNumber(8)
  set pubdate($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(8)
  $core.bool hasPubdate() => $_has(4);
  @$pb.TagNumber(8)
  void clearPubdate() => $_clearField(8);

  /// 提交时间戳
  @$pb.TagNumber(9)
  $fixnum.Int64 get ctime => $_getI64(5);
  @$pb.TagNumber(9)
  set ctime($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(9)
  $core.bool hasCtime() => $_has(5);
  @$pb.TagNumber(9)
  void clearCtime() => $_clearField(9);

  /// 所有分 P 加起来的总时长 (seconds)
  @$pb.TagNumber(16)
  $fixnum.Int64 get duration => $_getI64(6);
  @$pb.TagNumber(16)
  set duration($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(16)
  $core.bool hasDuration() => $_has(6);
  @$pb.TagNumber(16)
  void clearDuration() => $_clearField(16);

  /// 强制跳转地址
  @$pb.TagNumber(19)
  $core.String get redirectUrl => $_getSZ(7);
  @$pb.TagNumber(19)
  set redirectUrl($core.String value) => $_setString(7, value);
  @$pb.TagNumber(19)
  $core.bool hasRedirectUrl() => $_has(7);
  @$pb.TagNumber(19)
  void clearRedirectUrl() => $_clearField(19);

  /// 稿件作者信息, 参见 [`Author`]
  @$pb.TagNumber(22)
  Author get author => $_getN(8);
  @$pb.TagNumber(22)
  set author(Author value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasAuthor() => $_has(8);
  @$pb.TagNumber(22)
  void clearAuthor() => $_clearField(22);
  @$pb.TagNumber(22)
  Author ensureAuthor() => $_ensure(8);

  /// 稿件计数信息, 参见 [`Stat`]
  @$pb.TagNumber(23)
  Stat get stat => $_getN(9);
  @$pb.TagNumber(23)
  set stat(Stat value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasStat() => $_has(9);
  @$pb.TagNumber(23)
  void clearStat() => $_clearField(23);
  @$pb.TagNumber(23)
  Stat ensureStat() => $_ensure(9);

  /// 首个分 P 的 cid
  @$pb.TagNumber(26)
  $fixnum.Int64 get firstCid => $_getI64(10);
  @$pb.TagNumber(26)
  set firstCid($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(26)
  $core.bool hasFirstCid() => $_has(10);
  @$pb.TagNumber(26)
  void clearFirstCid() => $_clearField(26);

  /// 首个分 P 的分辨率
  @$pb.TagNumber(27)
  Dimension get dimension => $_getN(11);
  @$pb.TagNumber(27)
  set dimension(Dimension value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasDimension() => $_has(11);
  @$pb.TagNumber(27)
  void clearDimension() => $_clearField(27);
  @$pb.TagNumber(27)
  Dimension ensureDimension() => $_ensure(11);

  /// UGC 剧集 ID
  @$pb.TagNumber(29)
  $fixnum.Int64 get seasonId => $_getI64(12);
  @$pb.TagNumber(29)
  set seasonId($fixnum.Int64 value) => $_setInt64(12, value);
  @$pb.TagNumber(29)
  $core.bool hasSeasonId() => $_has(12);
  @$pb.TagNumber(29)
  void clearSeasonId() => $_clearField(29);
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

/// 计数相关信息
class Stat extends $pb.GeneratedMessage {
  factory Stat({
    $core.int? view,
    $core.int? danmaku,
  }) {
    final result = create();
    if (view != null) result.view = view;
    if (danmaku != null) result.danmaku = danmaku;
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
    ..aI(2, _omitFieldNames ? '' : 'view')
    ..aI(3, _omitFieldNames ? '' : 'danmaku')
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
  @$core.pragma('dart2js:noInline')
  static Stat getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Stat>(create);
  static Stat? _defaultInstance;

  /// 播放量
  @$pb.TagNumber(2)
  $core.int get view => $_getIZ(0);
  @$pb.TagNumber(2)
  set view($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(2)
  $core.bool hasView() => $_has(0);
  @$pb.TagNumber(2)
  void clearView() => $_clearField(2);

  /// 弹幕数
  @$pb.TagNumber(3)
  $core.int get danmaku => $_getIZ(1);
  @$pb.TagNumber(3)
  set danmaku($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(3)
  $core.bool hasDanmaku() => $_has(1);
  @$pb.TagNumber(3)
  void clearDanmaku() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
