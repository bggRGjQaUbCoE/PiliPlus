// This is a generated file - do not edit.
//
// Generated from bilibili/app/interfaces/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../archive/middleware/v1.pb.dart' as $3;
import '../archive/v1.pb.dart' as $1;
import '../card/v1.pb.dart' as $2;
import '../dynamic/v2.pb.dart' as $4;
import 'v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'v1.pbenum.dart';

class Arc extends $pb.GeneratedMessage {
  factory Arc({
    $1.Arc? archive,
    $core.String? uri,
    $core.String? viewContent,
    $fixnum.Int64? iconType,
    $core.String? coverIcon,
    $core.bool? isFold,
    $core.bool? isPugv,
    $core.String? publishTimeText,
    $core.Iterable<$core.String>? badges,
    $core.bool? isOneself,
  }) {
    final result = create();
    if (archive != null) result.archive = archive;
    if (uri != null) result.uri = uri;
    if (viewContent != null) result.viewContent = viewContent;
    if (iconType != null) result.iconType = iconType;
    if (coverIcon != null) result.coverIcon = coverIcon;
    if (isFold != null) result.isFold = isFold;
    if (isPugv != null) result.isPugv = isPugv;
    if (publishTimeText != null) result.publishTimeText = publishTimeText;
    if (badges != null) result.badges.addAll(badges);
    if (isOneself != null) result.isOneself = isOneself;
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
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Arc>(1, _omitFieldNames ? '' : 'archive',
        subBuilder: $1.Arc.create)
    ..aOS(2, _omitFieldNames ? '' : 'uri')
    ..aOS(3, _omitFieldNames ? '' : 'viewContent')
    ..aInt64(4, _omitFieldNames ? '' : 'iconType')
    ..aOS(5, _omitFieldNames ? '' : 'coverIcon')
    ..aOB(6, _omitFieldNames ? '' : 'isFold')
    ..aOB(7, _omitFieldNames ? '' : 'isPugv')
    ..aOS(8, _omitFieldNames ? '' : 'publishTimeText')
    ..pPS(9, _omitFieldNames ? '' : 'badges')
    ..aOB(10, _omitFieldNames ? '' : 'isOneself')
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
  $1.Arc get archive => $_getN(0);
  @$pb.TagNumber(1)
  set archive($1.Arc value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArchive() => $_has(0);
  @$pb.TagNumber(1)
  void clearArchive() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Arc ensureArchive() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get uri => $_getSZ(1);
  @$pb.TagNumber(2)
  set uri($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearUri() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get viewContent => $_getSZ(2);
  @$pb.TagNumber(3)
  set viewContent($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasViewContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearViewContent() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get iconType => $_getI64(3);
  @$pb.TagNumber(4)
  set iconType($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIconType() => $_has(3);
  @$pb.TagNumber(4)
  void clearIconType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get coverIcon => $_getSZ(4);
  @$pb.TagNumber(5)
  set coverIcon($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCoverIcon() => $_has(4);
  @$pb.TagNumber(5)
  void clearCoverIcon() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isFold => $_getBF(5);
  @$pb.TagNumber(6)
  set isFold($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsFold() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsFold() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isPugv => $_getBF(6);
  @$pb.TagNumber(7)
  set isPugv($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsPugv() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsPugv() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get publishTimeText => $_getSZ(7);
  @$pb.TagNumber(8)
  set publishTimeText($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPublishTimeText() => $_has(7);
  @$pb.TagNumber(8)
  void clearPublishTimeText() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get badges => $_getList(8);

  @$pb.TagNumber(10)
  $core.bool get isOneself => $_getBF(9);
  @$pb.TagNumber(10)
  set isOneself($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIsOneself() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsOneself() => $_clearField(10);
}

class Badge extends $pb.GeneratedMessage {
  factory Badge({
    $core.String? text,
    $core.String? icon,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (icon != null) result.icon = icon;
    return result;
  }

  Badge._();

  factory Badge.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Badge.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Badge',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'icon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Badge clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Badge copyWith(void Function(Badge) updates) =>
      super.copyWith((message) => updates(message as Badge)) as Badge;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Badge create() => Badge._();
  @$core.override
  Badge createEmptyInstance() => create();
  static $pb.PbList<Badge> createRepeated() => $pb.PbList<Badge>();
  @$core.pragma('dart2js:noInline')
  static Badge getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Badge>(create);
  static Badge? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get icon => $_getSZ(1);
  @$pb.TagNumber(2)
  set icon($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIcon() => $_has(1);
  @$pb.TagNumber(2)
  void clearIcon() => $_clearField(2);
}

class BigItem extends $pb.GeneratedMessage {
  factory BigItem({
    $core.String? title,
    $core.String? coverImageUri,
    $core.String? uri,
    $core.String? coverRightText,
    $core.String? coverLeftText1,
    $fixnum.Int64? coverLeftIcon1,
    $core.String? coverLeftText2,
    $fixnum.Int64? coverLeftIcon2,
    UserCard? userCard,
    LikeButton? likeButton,
    $fixnum.Int64? param,
    $2.SharePlane? sharePlane,
    $2.PanelMeta? threePointMeta,
    $2.InlineProgressBar? inlineProgressBar,
    $core.int? canPlay,
    $3.PlayerArgs? playerArgs,
    $core.bool? isFav,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (coverImageUri != null) result.coverImageUri = coverImageUri;
    if (uri != null) result.uri = uri;
    if (coverRightText != null) result.coverRightText = coverRightText;
    if (coverLeftText1 != null) result.coverLeftText1 = coverLeftText1;
    if (coverLeftIcon1 != null) result.coverLeftIcon1 = coverLeftIcon1;
    if (coverLeftText2 != null) result.coverLeftText2 = coverLeftText2;
    if (coverLeftIcon2 != null) result.coverLeftIcon2 = coverLeftIcon2;
    if (userCard != null) result.userCard = userCard;
    if (likeButton != null) result.likeButton = likeButton;
    if (param != null) result.param = param;
    if (sharePlane != null) result.sharePlane = sharePlane;
    if (threePointMeta != null) result.threePointMeta = threePointMeta;
    if (inlineProgressBar != null) result.inlineProgressBar = inlineProgressBar;
    if (canPlay != null) result.canPlay = canPlay;
    if (playerArgs != null) result.playerArgs = playerArgs;
    if (isFav != null) result.isFav = isFav;
    return result;
  }

  BigItem._();

  factory BigItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BigItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BigItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'coverImageUri')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..aOS(4, _omitFieldNames ? '' : 'coverRightText')
    ..aOS(5, _omitFieldNames ? '' : 'coverLeftText1')
    ..aInt64(6, _omitFieldNames ? '' : 'coverLeftIcon1')
    ..aOS(7, _omitFieldNames ? '' : 'coverLeftText2')
    ..aInt64(8, _omitFieldNames ? '' : 'coverLeftIcon2')
    ..aOM<UserCard>(9, _omitFieldNames ? '' : 'userCard',
        subBuilder: UserCard.create)
    ..aOM<LikeButton>(10, _omitFieldNames ? '' : 'likeButton',
        subBuilder: LikeButton.create)
    ..aInt64(11, _omitFieldNames ? '' : 'param')
    ..aOM<$2.SharePlane>(12, _omitFieldNames ? '' : 'sharePlane',
        subBuilder: $2.SharePlane.create)
    ..aOM<$2.PanelMeta>(13, _omitFieldNames ? '' : 'threePointMeta',
        subBuilder: $2.PanelMeta.create)
    ..aOM<$2.InlineProgressBar>(14, _omitFieldNames ? '' : 'inlineProgressBar',
        subBuilder: $2.InlineProgressBar.create)
    ..aI(15, _omitFieldNames ? '' : 'canPlay')
    ..aOM<$3.PlayerArgs>(16, _omitFieldNames ? '' : 'playerArgs',
        subBuilder: $3.PlayerArgs.create)
    ..aOB(17, _omitFieldNames ? '' : 'isFav')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BigItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BigItem copyWith(void Function(BigItem) updates) =>
      super.copyWith((message) => updates(message as BigItem)) as BigItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BigItem create() => BigItem._();
  @$core.override
  BigItem createEmptyInstance() => create();
  static $pb.PbList<BigItem> createRepeated() => $pb.PbList<BigItem>();
  @$core.pragma('dart2js:noInline')
  static BigItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BigItem>(create);
  static BigItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get coverImageUri => $_getSZ(1);
  @$pb.TagNumber(2)
  set coverImageUri($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCoverImageUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoverImageUri() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get coverRightText => $_getSZ(3);
  @$pb.TagNumber(4)
  set coverRightText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverRightText() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverRightText() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get coverLeftText1 => $_getSZ(4);
  @$pb.TagNumber(5)
  set coverLeftText1($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCoverLeftText1() => $_has(4);
  @$pb.TagNumber(5)
  void clearCoverLeftText1() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get coverLeftIcon1 => $_getI64(5);
  @$pb.TagNumber(6)
  set coverLeftIcon1($fixnum.Int64 value) => $_setInt64(5, value);
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
  $fixnum.Int64 get coverLeftIcon2 => $_getI64(7);
  @$pb.TagNumber(8)
  set coverLeftIcon2($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCoverLeftIcon2() => $_has(7);
  @$pb.TagNumber(8)
  void clearCoverLeftIcon2() => $_clearField(8);

  @$pb.TagNumber(9)
  UserCard get userCard => $_getN(8);
  @$pb.TagNumber(9)
  set userCard(UserCard value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasUserCard() => $_has(8);
  @$pb.TagNumber(9)
  void clearUserCard() => $_clearField(9);
  @$pb.TagNumber(9)
  UserCard ensureUserCard() => $_ensure(8);

  @$pb.TagNumber(10)
  LikeButton get likeButton => $_getN(9);
  @$pb.TagNumber(10)
  set likeButton(LikeButton value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasLikeButton() => $_has(9);
  @$pb.TagNumber(10)
  void clearLikeButton() => $_clearField(10);
  @$pb.TagNumber(10)
  LikeButton ensureLikeButton() => $_ensure(9);

  @$pb.TagNumber(11)
  $fixnum.Int64 get param => $_getI64(10);
  @$pb.TagNumber(11)
  set param($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasParam() => $_has(10);
  @$pb.TagNumber(11)
  void clearParam() => $_clearField(11);

  @$pb.TagNumber(12)
  $2.SharePlane get sharePlane => $_getN(11);
  @$pb.TagNumber(12)
  set sharePlane($2.SharePlane value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasSharePlane() => $_has(11);
  @$pb.TagNumber(12)
  void clearSharePlane() => $_clearField(12);
  @$pb.TagNumber(12)
  $2.SharePlane ensureSharePlane() => $_ensure(11);

  @$pb.TagNumber(13)
  $2.PanelMeta get threePointMeta => $_getN(12);
  @$pb.TagNumber(13)
  set threePointMeta($2.PanelMeta value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasThreePointMeta() => $_has(12);
  @$pb.TagNumber(13)
  void clearThreePointMeta() => $_clearField(13);
  @$pb.TagNumber(13)
  $2.PanelMeta ensureThreePointMeta() => $_ensure(12);

  @$pb.TagNumber(14)
  $2.InlineProgressBar get inlineProgressBar => $_getN(13);
  @$pb.TagNumber(14)
  set inlineProgressBar($2.InlineProgressBar value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasInlineProgressBar() => $_has(13);
  @$pb.TagNumber(14)
  void clearInlineProgressBar() => $_clearField(14);
  @$pb.TagNumber(14)
  $2.InlineProgressBar ensureInlineProgressBar() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.int get canPlay => $_getIZ(14);
  @$pb.TagNumber(15)
  set canPlay($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasCanPlay() => $_has(14);
  @$pb.TagNumber(15)
  void clearCanPlay() => $_clearField(15);

  @$pb.TagNumber(16)
  $3.PlayerArgs get playerArgs => $_getN(15);
  @$pb.TagNumber(16)
  set playerArgs($3.PlayerArgs value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasPlayerArgs() => $_has(15);
  @$pb.TagNumber(16)
  void clearPlayerArgs() => $_clearField(16);
  @$pb.TagNumber(16)
  $3.PlayerArgs ensurePlayerArgs() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.bool get isFav => $_getBF(16);
  @$pb.TagNumber(17)
  set isFav($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasIsFav() => $_has(16);
  @$pb.TagNumber(17)
  void clearIsFav() => $_clearField(17);
}

class Button extends $pb.GeneratedMessage {
  factory Button({
    $core.String? title,
    $core.String? link,
    $core.String? id,
    $fixnum.Int64? icon,
    ButType? butType,
    $core.int? followState,
    $core.String? hasTitle_7,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (link != null) result.link = link;
    if (id != null) result.id = id;
    if (icon != null) result.icon = icon;
    if (butType != null) result.butType = butType;
    if (followState != null) result.followState = followState;
    if (hasTitle_7 != null) result.hasTitle_7 = hasTitle_7;
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
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'link')
    ..aOS(3, _omitFieldNames ? '' : 'id')
    ..aInt64(4, _omitFieldNames ? '' : 'icon')
    ..aE<ButType>(5, _omitFieldNames ? '' : 'butType',
        enumValues: ButType.values)
    ..aI(6, _omitFieldNames ? '' : 'followState')
    ..aOS(7, _omitFieldNames ? '' : 'hasTitle')
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
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get link => $_getSZ(1);
  @$pb.TagNumber(2)
  set link($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLink() => $_has(1);
  @$pb.TagNumber(2)
  void clearLink() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get id => $_getSZ(2);
  @$pb.TagNumber(3)
  set id($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(2);
  @$pb.TagNumber(3)
  void clearId() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get icon => $_getI64(3);
  @$pb.TagNumber(4)
  set icon($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIcon() => $_has(3);
  @$pb.TagNumber(4)
  void clearIcon() => $_clearField(4);

  @$pb.TagNumber(5)
  ButType get butType => $_getN(4);
  @$pb.TagNumber(5)
  set butType(ButType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasButType() => $_has(4);
  @$pb.TagNumber(5)
  void clearButType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get followState => $_getIZ(5);
  @$pb.TagNumber(6)
  set followState($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFollowState() => $_has(5);
  @$pb.TagNumber(6)
  void clearFollowState() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get hasTitle_7 => $_getSZ(6);
  @$pb.TagNumber(7)
  set hasTitle_7($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasHasTitle_7() => $_has(6);
  @$pb.TagNumber(7)
  void clearHasTitle_7() => $_clearField(7);
}

/// 专栏卡片
class CardArticle extends $pb.GeneratedMessage {
  factory CardArticle({
    $core.Iterable<$core.String>? covers,
    $core.String? name,
    $fixnum.Int64? mid,
    $core.bool? displayAttention,
    $core.String? badge,
    Relation? relation,
  }) {
    final result = create();
    if (covers != null) result.covers.addAll(covers);
    if (name != null) result.name = name;
    if (mid != null) result.mid = mid;
    if (displayAttention != null) result.displayAttention = displayAttention;
    if (badge != null) result.badge = badge;
    if (relation != null) result.relation = relation;
    return result;
  }

  CardArticle._();

  factory CardArticle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CardArticle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CardArticle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'covers')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aInt64(3, _omitFieldNames ? '' : 'mid')
    ..aOB(4, _omitFieldNames ? '' : 'displayAttention')
    ..aOS(5, _omitFieldNames ? '' : 'badge')
    ..aOM<Relation>(6, _omitFieldNames ? '' : 'relation',
        subBuilder: Relation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardArticle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardArticle copyWith(void Function(CardArticle) updates) =>
      super.copyWith((message) => updates(message as CardArticle))
          as CardArticle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CardArticle create() => CardArticle._();
  @$core.override
  CardArticle createEmptyInstance() => create();
  static $pb.PbList<CardArticle> createRepeated() => $pb.PbList<CardArticle>();
  @$core.pragma('dart2js:noInline')
  static CardArticle getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CardArticle>(create);
  static CardArticle? _defaultInstance;

  /// 封面
  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get covers => $_getList(0);

  /// 标题
  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// UP 主 mid
  @$pb.TagNumber(3)
  $fixnum.Int64 get mid => $_getI64(2);
  @$pb.TagNumber(3)
  set mid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMid() => $_has(2);
  @$pb.TagNumber(3)
  void clearMid() => $_clearField(3);

  /// 是否展示 "关注" 按钮
  @$pb.TagNumber(4)
  $core.bool get displayAttention => $_getBF(3);
  @$pb.TagNumber(4)
  set displayAttention($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDisplayAttention() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisplayAttention() => $_clearField(4);

  /// 角标
  @$pb.TagNumber(5)
  $core.String get badge => $_getSZ(4);
  @$pb.TagNumber(5)
  set badge($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBadge() => $_has(4);
  @$pb.TagNumber(5)
  void clearBadge() => $_clearField(5);

  /// 新关注组件
  @$pb.TagNumber(6)
  Relation get relation => $_getN(5);
  @$pb.TagNumber(6)
  set relation(Relation value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRelation() => $_has(5);
  @$pb.TagNumber(6)
  void clearRelation() => $_clearField(6);
  @$pb.TagNumber(6)
  Relation ensureRelation() => $_ensure(5);
}

/// 付费课程卡片
class CardCheese extends $pb.GeneratedMessage {
  factory CardCheese({
    $core.String? cover,
    $fixnum.Int64? progress,
    $fixnum.Int64? duration,
    $core.String? subtitle,
    $fixnum.Int64? state,
  }) {
    final result = create();
    if (cover != null) result.cover = cover;
    if (progress != null) result.progress = progress;
    if (duration != null) result.duration = duration;
    if (subtitle != null) result.subtitle = subtitle;
    if (state != null) result.state = state;
    return result;
  }

  CardCheese._();

  factory CardCheese.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CardCheese.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CardCheese',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cover')
    ..aInt64(2, _omitFieldNames ? '' : 'progress')
    ..aInt64(3, _omitFieldNames ? '' : 'duration')
    ..aOS(4, _omitFieldNames ? '' : 'subtitle')
    ..aInt64(5, _omitFieldNames ? '' : 'state')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardCheese clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardCheese copyWith(void Function(CardCheese) updates) =>
      super.copyWith((message) => updates(message as CardCheese)) as CardCheese;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CardCheese create() => CardCheese._();
  @$core.override
  CardCheese createEmptyInstance() => create();
  static $pb.PbList<CardCheese> createRepeated() => $pb.PbList<CardCheese>();
  @$core.pragma('dart2js:noInline')
  static CardCheese getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CardCheese>(create);
  static CardCheese? _defaultInstance;

  /// 封面
  @$pb.TagNumber(1)
  $core.String get cover => $_getSZ(0);
  @$pb.TagNumber(1)
  set cover($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCover() => $_has(0);
  @$pb.TagNumber(1)
  void clearCover() => $_clearField(1);

  /// 观看进度
  @$pb.TagNumber(2)
  $fixnum.Int64 get progress => $_getI64(1);
  @$pb.TagNumber(2)
  set progress($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProgress() => $_has(1);
  @$pb.TagNumber(2)
  void clearProgress() => $_clearField(2);

  /// 时长
  @$pb.TagNumber(3)
  $fixnum.Int64 get duration => $_getI64(2);
  @$pb.TagNumber(3)
  set duration($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDuration() => $_has(2);
  @$pb.TagNumber(3)
  void clearDuration() => $_clearField(3);

  /// 分集标题
  @$pb.TagNumber(4)
  $core.String get subtitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set subtitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubtitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubtitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get state => $_getI64(4);
  @$pb.TagNumber(5)
  set state($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasState() => $_has(4);
  @$pb.TagNumber(5)
  void clearState() => $_clearField(5);
}

/// 直播卡片
class CardLive extends $pb.GeneratedMessage {
  factory CardLive({
    $core.String? cover,
    $core.String? name,
    $fixnum.Int64? mid,
    $core.String? tag,
    $core.int? status,
    $core.bool? displayAttention,
    Relation? relation,
  }) {
    final result = create();
    if (cover != null) result.cover = cover;
    if (name != null) result.name = name;
    if (mid != null) result.mid = mid;
    if (tag != null) result.tag = tag;
    if (status != null) result.status = status;
    if (displayAttention != null) result.displayAttention = displayAttention;
    if (relation != null) result.relation = relation;
    return result;
  }

  CardLive._();

  factory CardLive.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CardLive.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CardLive',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cover')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aInt64(3, _omitFieldNames ? '' : 'mid')
    ..aOS(4, _omitFieldNames ? '' : 'tag')
    ..aI(5, _omitFieldNames ? '' : 'status')
    ..aOB(6, _omitFieldNames ? '' : 'displayAttention')
    ..aOM<Relation>(7, _omitFieldNames ? '' : 'relation',
        subBuilder: Relation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardLive clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardLive copyWith(void Function(CardLive) updates) =>
      super.copyWith((message) => updates(message as CardLive)) as CardLive;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CardLive create() => CardLive._();
  @$core.override
  CardLive createEmptyInstance() => create();
  static $pb.PbList<CardLive> createRepeated() => $pb.PbList<CardLive>();
  @$core.pragma('dart2js:noInline')
  static CardLive getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CardLive>(create);
  static CardLive? _defaultInstance;

  /// 封面
  @$pb.TagNumber(1)
  $core.String get cover => $_getSZ(0);
  @$pb.TagNumber(1)
  set cover($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCover() => $_has(0);
  @$pb.TagNumber(1)
  void clearCover() => $_clearField(1);

  /// UP 主昵称
  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// UP 主 mid
  @$pb.TagNumber(3)
  $fixnum.Int64 get mid => $_getI64(2);
  @$pb.TagNumber(3)
  set mid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMid() => $_has(2);
  @$pb.TagNumber(3)
  void clearMid() => $_clearField(3);

  /// tag 名称
  @$pb.TagNumber(4)
  $core.String get tag => $_getSZ(3);
  @$pb.TagNumber(4)
  set tag($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTag() => $_has(3);
  @$pb.TagNumber(4)
  void clearTag() => $_clearField(4);

  /// 直播状态
  @$pb.TagNumber(5)
  $core.int get status => $_getIZ(4);
  @$pb.TagNumber(5)
  set status($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  /// 是否展示 "关注" 按钮
  @$pb.TagNumber(6)
  $core.bool get displayAttention => $_getBF(5);
  @$pb.TagNumber(6)
  set displayAttention($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDisplayAttention() => $_has(5);
  @$pb.TagNumber(6)
  void clearDisplayAttention() => $_clearField(6);

  /// 新关注组件
  @$pb.TagNumber(7)
  Relation get relation => $_getN(6);
  @$pb.TagNumber(7)
  set relation(Relation value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasRelation() => $_has(6);
  @$pb.TagNumber(7)
  void clearRelation() => $_clearField(7);
  @$pb.TagNumber(7)
  Relation ensureRelation() => $_ensure(6);
}

/// OGV 稿件卡片
class CardOGV extends $pb.GeneratedMessage {
  factory CardOGV({
    $core.String? cover,
    $fixnum.Int64? progress,
    $fixnum.Int64? duration,
    $core.String? subtitle,
    $core.String? badge,
    $fixnum.Int64? state,
  }) {
    final result = create();
    if (cover != null) result.cover = cover;
    if (progress != null) result.progress = progress;
    if (duration != null) result.duration = duration;
    if (subtitle != null) result.subtitle = subtitle;
    if (badge != null) result.badge = badge;
    if (state != null) result.state = state;
    return result;
  }

  CardOGV._();

  factory CardOGV.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CardOGV.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CardOGV',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cover')
    ..aInt64(2, _omitFieldNames ? '' : 'progress')
    ..aInt64(3, _omitFieldNames ? '' : 'duration')
    ..aOS(4, _omitFieldNames ? '' : 'subtitle')
    ..aOS(5, _omitFieldNames ? '' : 'badge')
    ..aInt64(6, _omitFieldNames ? '' : 'state')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardOGV clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardOGV copyWith(void Function(CardOGV) updates) =>
      super.copyWith((message) => updates(message as CardOGV)) as CardOGV;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CardOGV create() => CardOGV._();
  @$core.override
  CardOGV createEmptyInstance() => create();
  static $pb.PbList<CardOGV> createRepeated() => $pb.PbList<CardOGV>();
  @$core.pragma('dart2js:noInline')
  static CardOGV getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CardOGV>(create);
  static CardOGV? _defaultInstance;

  /// 封面
  @$pb.TagNumber(1)
  $core.String get cover => $_getSZ(0);
  @$pb.TagNumber(1)
  set cover($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCover() => $_has(0);
  @$pb.TagNumber(1)
  void clearCover() => $_clearField(1);

  /// 观看进度
  @$pb.TagNumber(2)
  $fixnum.Int64 get progress => $_getI64(1);
  @$pb.TagNumber(2)
  set progress($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProgress() => $_has(1);
  @$pb.TagNumber(2)
  void clearProgress() => $_clearField(2);

  /// 总时长
  @$pb.TagNumber(3)
  $fixnum.Int64 get duration => $_getI64(2);
  @$pb.TagNumber(3)
  set duration($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDuration() => $_has(2);
  @$pb.TagNumber(3)
  void clearDuration() => $_clearField(3);

  /// 番剧卡分集标题
  @$pb.TagNumber(4)
  $core.String get subtitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set subtitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubtitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubtitle() => $_clearField(4);

  /// 角标
  @$pb.TagNumber(5)
  $core.String get badge => $_getSZ(4);
  @$pb.TagNumber(5)
  set badge($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBadge() => $_has(4);
  @$pb.TagNumber(5)
  void clearBadge() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get state => $_getI64(5);
  @$pb.TagNumber(6)
  set state($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasState() => $_has(5);
  @$pb.TagNumber(6)
  void clearState() => $_clearField(6);
}

/// UGC 稿件卡片
class CardUGC extends $pb.GeneratedMessage {
  factory CardUGC({
    $core.String? cover,
    $fixnum.Int64? progress,
    $fixnum.Int64? duration,
    $core.String? name,
    $fixnum.Int64? mid,
    $core.bool? displayAttention,
    $fixnum.Int64? cid,
    $core.int? page,
    $core.String? subtitle,
    Relation? relation,
    $core.String? bvid,
    $fixnum.Int64? videos,
    $core.String? shortLink,
    $core.String? shareSubtitle,
    $fixnum.Int64? view,
    $fixnum.Int64? state,
    $core.String? badge,
    Badge? badgeV2,
  }) {
    final result = create();
    if (cover != null) result.cover = cover;
    if (progress != null) result.progress = progress;
    if (duration != null) result.duration = duration;
    if (name != null) result.name = name;
    if (mid != null) result.mid = mid;
    if (displayAttention != null) result.displayAttention = displayAttention;
    if (cid != null) result.cid = cid;
    if (page != null) result.page = page;
    if (subtitle != null) result.subtitle = subtitle;
    if (relation != null) result.relation = relation;
    if (bvid != null) result.bvid = bvid;
    if (videos != null) result.videos = videos;
    if (shortLink != null) result.shortLink = shortLink;
    if (shareSubtitle != null) result.shareSubtitle = shareSubtitle;
    if (view != null) result.view = view;
    if (state != null) result.state = state;
    if (badge != null) result.badge = badge;
    if (badgeV2 != null) result.badgeV2 = badgeV2;
    return result;
  }

  CardUGC._();

  factory CardUGC.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CardUGC.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CardUGC',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cover')
    ..aInt64(2, _omitFieldNames ? '' : 'progress')
    ..aInt64(3, _omitFieldNames ? '' : 'duration')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aInt64(5, _omitFieldNames ? '' : 'mid')
    ..aOB(6, _omitFieldNames ? '' : 'displayAttention')
    ..aInt64(7, _omitFieldNames ? '' : 'cid')
    ..aI(8, _omitFieldNames ? '' : 'page')
    ..aOS(9, _omitFieldNames ? '' : 'subtitle')
    ..aOM<Relation>(10, _omitFieldNames ? '' : 'relation',
        subBuilder: Relation.create)
    ..aOS(11, _omitFieldNames ? '' : 'bvid')
    ..aInt64(12, _omitFieldNames ? '' : 'videos')
    ..aOS(13, _omitFieldNames ? '' : 'shortLink')
    ..aOS(14, _omitFieldNames ? '' : 'shareSubtitle')
    ..aInt64(15, _omitFieldNames ? '' : 'view')
    ..aInt64(16, _omitFieldNames ? '' : 'state')
    ..aOS(17, _omitFieldNames ? '' : 'badge')
    ..aOM<Badge>(18, _omitFieldNames ? '' : 'badgeV2', subBuilder: Badge.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardUGC clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardUGC copyWith(void Function(CardUGC) updates) =>
      super.copyWith((message) => updates(message as CardUGC)) as CardUGC;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CardUGC create() => CardUGC._();
  @$core.override
  CardUGC createEmptyInstance() => create();
  static $pb.PbList<CardUGC> createRepeated() => $pb.PbList<CardUGC>();
  @$core.pragma('dart2js:noInline')
  static CardUGC getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CardUGC>(create);
  static CardUGC? _defaultInstance;

  /// 封面
  @$pb.TagNumber(1)
  $core.String get cover => $_getSZ(0);
  @$pb.TagNumber(1)
  set cover($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCover() => $_has(0);
  @$pb.TagNumber(1)
  void clearCover() => $_clearField(1);

  /// 观看进度
  @$pb.TagNumber(2)
  $fixnum.Int64 get progress => $_getI64(1);
  @$pb.TagNumber(2)
  set progress($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProgress() => $_has(1);
  @$pb.TagNumber(2)
  void clearProgress() => $_clearField(2);

  /// 时长
  @$pb.TagNumber(3)
  $fixnum.Int64 get duration => $_getI64(2);
  @$pb.TagNumber(3)
  set duration($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDuration() => $_has(2);
  @$pb.TagNumber(3)
  void clearDuration() => $_clearField(3);

  /// UP 昵称
  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  /// UP mid
  @$pb.TagNumber(5)
  $fixnum.Int64 get mid => $_getI64(4);
  @$pb.TagNumber(5)
  set mid($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMid() => $_has(4);
  @$pb.TagNumber(5)
  void clearMid() => $_clearField(5);

  /// 是否展示 "关注" 按钮
  @$pb.TagNumber(6)
  $core.bool get displayAttention => $_getBF(5);
  @$pb.TagNumber(6)
  set displayAttention($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDisplayAttention() => $_has(5);
  @$pb.TagNumber(6)
  void clearDisplayAttention() => $_clearField(6);

  /// 分 P 的 cid
  @$pb.TagNumber(7)
  $fixnum.Int64 get cid => $_getI64(6);
  @$pb.TagNumber(7)
  set cid($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCid() => $_has(6);
  @$pb.TagNumber(7)
  void clearCid() => $_clearField(7);

  /// 分 P
  @$pb.TagNumber(8)
  $core.int get page => $_getIZ(7);
  @$pb.TagNumber(8)
  set page($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPage() => $_has(7);
  @$pb.TagNumber(8)
  void clearPage() => $_clearField(8);

  /// 分 P 的标题
  @$pb.TagNumber(9)
  $core.String get subtitle => $_getSZ(8);
  @$pb.TagNumber(9)
  set subtitle($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSubtitle() => $_has(8);
  @$pb.TagNumber(9)
  void clearSubtitle() => $_clearField(9);

  /// 新关注组件
  @$pb.TagNumber(10)
  Relation get relation => $_getN(9);
  @$pb.TagNumber(10)
  set relation(Relation value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasRelation() => $_has(9);
  @$pb.TagNumber(10)
  void clearRelation() => $_clearField(10);
  @$pb.TagNumber(10)
  Relation ensureRelation() => $_ensure(9);

  /// 稿件 bvid
  @$pb.TagNumber(11)
  $core.String get bvid => $_getSZ(10);
  @$pb.TagNumber(11)
  set bvid($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasBvid() => $_has(10);
  @$pb.TagNumber(11)
  void clearBvid() => $_clearField(11);

  /// ? 分 P 总数
  @$pb.TagNumber(12)
  $fixnum.Int64 get videos => $_getI64(11);
  @$pb.TagNumber(12)
  set videos($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasVideos() => $_has(11);
  @$pb.TagNumber(12)
  void clearVideos() => $_clearField(12);

  /// ? 短链接
  @$pb.TagNumber(13)
  $core.String get shortLink => $_getSZ(12);
  @$pb.TagNumber(13)
  set shortLink($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasShortLink() => $_has(12);
  @$pb.TagNumber(13)
  void clearShortLink() => $_clearField(13);

  /// ? 分享标题
  @$pb.TagNumber(14)
  $core.String get shareSubtitle => $_getSZ(13);
  @$pb.TagNumber(14)
  set shareSubtitle($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasShareSubtitle() => $_has(13);
  @$pb.TagNumber(14)
  void clearShareSubtitle() => $_clearField(14);

  /// ? 播放量
  @$pb.TagNumber(15)
  $fixnum.Int64 get view => $_getI64(14);
  @$pb.TagNumber(15)
  set view($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(15)
  $core.bool hasView() => $_has(14);
  @$pb.TagNumber(15)
  void clearView() => $_clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get state => $_getI64(15);
  @$pb.TagNumber(16)
  set state($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasState() => $_has(15);
  @$pb.TagNumber(16)
  void clearState() => $_clearField(16);

  /// ? 角标
  @$pb.TagNumber(17)
  $core.String get badge => $_getSZ(16);
  @$pb.TagNumber(17)
  set badge($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasBadge() => $_has(16);
  @$pb.TagNumber(17)
  void clearBadge() => $_clearField(17);

  /// ? 角标
  @$pb.TagNumber(18)
  Badge get badgeV2 => $_getN(17);
  @$pb.TagNumber(18)
  set badgeV2(Badge value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasBadgeV2() => $_has(17);
  @$pb.TagNumber(18)
  void clearBadgeV2() => $_clearField(18);
  @$pb.TagNumber(18)
  Badge ensureBadgeV2() => $_ensure(17);
}

class Cast extends $pb.GeneratedMessage {
  factory Cast({
    $core.Iterable<MediaPerson>? person,
    $core.String? title,
  }) {
    final result = create();
    if (person != null) result.person.addAll(person);
    if (title != null) result.title = title;
    return result;
  }

  Cast._();

  factory Cast.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Cast.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Cast',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..pPM<MediaPerson>(1, _omitFieldNames ? '' : 'person',
        subBuilder: MediaPerson.create)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Cast clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Cast copyWith(void Function(Cast) updates) =>
      super.copyWith((message) => updates(message as Cast)) as Cast;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Cast create() => Cast._();
  @$core.override
  Cast createEmptyInstance() => create();
  static $pb.PbList<Cast> createRepeated() => $pb.PbList<Cast>();
  @$core.pragma('dart2js:noInline')
  static Cast getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Cast>(create);
  static Cast? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MediaPerson> get person => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);
}

class ChannelInfo extends $pb.GeneratedMessage {
  factory ChannelInfo({
    $fixnum.Int64? channelId,
    $core.bool? subscribed,
  }) {
    final result = create();
    if (channelId != null) result.channelId = channelId;
    if (subscribed != null) result.subscribed = subscribed;
    return result;
  }

  ChannelInfo._();

  factory ChannelInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChannelInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChannelInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'channelId')
    ..aOB(2, _omitFieldNames ? '' : 'subscribed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChannelInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChannelInfo copyWith(void Function(ChannelInfo) updates) =>
      super.copyWith((message) => updates(message as ChannelInfo))
          as ChannelInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChannelInfo create() => ChannelInfo._();
  @$core.override
  ChannelInfo createEmptyInstance() => create();
  static $pb.PbList<ChannelInfo> createRepeated() => $pb.PbList<ChannelInfo>();
  @$core.pragma('dart2js:noInline')
  static ChannelInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChannelInfo>(create);
  static ChannelInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get channelId => $_getI64(0);
  @$pb.TagNumber(1)
  set channelId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get subscribed => $_getBF(1);
  @$pb.TagNumber(2)
  set subscribed($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubscribed() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubscribed() => $_clearField(2);
}

class ClearReq extends $pb.GeneratedMessage {
  factory ClearReq({
    $core.String? business,
  }) {
    final result = create();
    if (business != null) result.business = business;
    return result;
  }

  ClearReq._();

  factory ClearReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClearReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'business')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearReq copyWith(void Function(ClearReq) updates) =>
      super.copyWith((message) => updates(message as ClearReq)) as ClearReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClearReq create() => ClearReq._();
  @$core.override
  ClearReq createEmptyInstance() => create();
  static $pb.PbList<ClearReq> createRepeated() => $pb.PbList<ClearReq>();
  @$core.pragma('dart2js:noInline')
  static ClearReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClearReq>(create);
  static ClearReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get business => $_getSZ(0);
  @$pb.TagNumber(1)
  set business($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBusiness() => $_has(0);
  @$pb.TagNumber(1)
  void clearBusiness() => $_clearField(1);
}

class CommentItem extends $pb.GeneratedMessage {
  factory CommentItem({
    $core.String? icon,
    $core.String? url,
    $core.String? title,
    CommentType? type,
    $core.String? actionType,
    $core.String? id,
  }) {
    final result = create();
    if (icon != null) result.icon = icon;
    if (url != null) result.url = url;
    if (title != null) result.title = title;
    if (type != null) result.type = type;
    if (actionType != null) result.actionType = actionType;
    if (id != null) result.id = id;
    return result;
  }

  CommentItem._();

  factory CommentItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommentItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommentItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'icon')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aE<CommentType>(4, _omitFieldNames ? '' : 'type',
        enumValues: CommentType.values)
    ..aOS(5, _omitFieldNames ? '' : 'actionType')
    ..aOS(6, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommentItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommentItem copyWith(void Function(CommentItem) updates) =>
      super.copyWith((message) => updates(message as CommentItem))
          as CommentItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommentItem create() => CommentItem._();
  @$core.override
  CommentItem createEmptyInstance() => create();
  static $pb.PbList<CommentItem> createRepeated() => $pb.PbList<CommentItem>();
  @$core.pragma('dart2js:noInline')
  static CommentItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommentItem>(create);
  static CommentItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get icon => $_getSZ(0);
  @$pb.TagNumber(1)
  set icon($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIcon() => $_has(0);
  @$pb.TagNumber(1)
  void clearIcon() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  CommentType get type => $_getN(3);
  @$pb.TagNumber(4)
  set type(CommentType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasType() => $_has(3);
  @$pb.TagNumber(4)
  void clearType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get actionType => $_getSZ(4);
  @$pb.TagNumber(5)
  set actionType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasActionType() => $_has(4);
  @$pb.TagNumber(5)
  void clearActionType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get id => $_getSZ(5);
  @$pb.TagNumber(6)
  set id($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasId() => $_has(5);
  @$pb.TagNumber(6)
  void clearId() => $_clearField(6);
}

/// 历史记录游标
class Cursor extends $pb.GeneratedMessage {
  factory Cursor({
    $fixnum.Int64? max,
    $core.int? maxTp,
  }) {
    final result = create();
    if (max != null) result.max = max;
    if (maxTp != null) result.maxTp = maxTp;
    return result;
  }

  Cursor._();

  factory Cursor.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Cursor.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Cursor',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'max')
    ..aI(2, _omitFieldNames ? '' : 'maxTp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Cursor clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Cursor copyWith(void Function(Cursor) updates) =>
      super.copyWith((message) => updates(message as Cursor)) as Cursor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Cursor create() => Cursor._();
  @$core.override
  Cursor createEmptyInstance() => create();
  static $pb.PbList<Cursor> createRepeated() => $pb.PbList<Cursor>();
  @$core.pragma('dart2js:noInline')
  static Cursor getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Cursor>(create);
  static Cursor? _defaultInstance;

  /// 本页最大值游标值
  @$pb.TagNumber(1)
  $fixnum.Int64 get max => $_getI64(0);
  @$pb.TagNumber(1)
  set max($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMax() => $_has(0);
  @$pb.TagNumber(1)
  void clearMax() => $_clearField(1);

  /// 本页最大值游标类型
  @$pb.TagNumber(2)
  $core.int get maxTp => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxTp($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxTp() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxTp() => $_clearField(2);
}

enum CursorItem_CardItem {
  cardUgc,
  cardOgv,
  cardArticle,
  cardLive,
  cardCheese,
  notSet
}

/// 历史记录卡片内容
class CursorItem extends $pb.GeneratedMessage {
  factory CursorItem({
    CardUGC? cardUgc,
    CardOGV? cardOgv,
    CardArticle? cardArticle,
    CardLive? cardLive,
    CardCheese? cardCheese,
    $core.String? title,
    $core.String? uri,
    $fixnum.Int64? viewAt,
    $fixnum.Int64? kid,
    $fixnum.Int64? oid,
    $core.String? business,
    $core.int? tp,
    DeviceType? dt,
    $core.bool? hasShare,
    $core.String? report,
  }) {
    final result = create();
    if (cardUgc != null) result.cardUgc = cardUgc;
    if (cardOgv != null) result.cardOgv = cardOgv;
    if (cardArticle != null) result.cardArticle = cardArticle;
    if (cardLive != null) result.cardLive = cardLive;
    if (cardCheese != null) result.cardCheese = cardCheese;
    if (title != null) result.title = title;
    if (uri != null) result.uri = uri;
    if (viewAt != null) result.viewAt = viewAt;
    if (kid != null) result.kid = kid;
    if (oid != null) result.oid = oid;
    if (business != null) result.business = business;
    if (tp != null) result.tp = tp;
    if (dt != null) result.dt = dt;
    if (hasShare != null) result.hasShare = hasShare;
    if (report != null) result.report = report;
    return result;
  }

  CursorItem._();

  factory CursorItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CursorItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, CursorItem_CardItem>
      _CursorItem_CardItemByTag = {
    1: CursorItem_CardItem.cardUgc,
    2: CursorItem_CardItem.cardOgv,
    3: CursorItem_CardItem.cardArticle,
    4: CursorItem_CardItem.cardLive,
    5: CursorItem_CardItem.cardCheese,
    0: CursorItem_CardItem.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CursorItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5])
    ..aOM<CardUGC>(1, _omitFieldNames ? '' : 'cardUgc',
        subBuilder: CardUGC.create)
    ..aOM<CardOGV>(2, _omitFieldNames ? '' : 'cardOgv',
        subBuilder: CardOGV.create)
    ..aOM<CardArticle>(3, _omitFieldNames ? '' : 'cardArticle',
        subBuilder: CardArticle.create)
    ..aOM<CardLive>(4, _omitFieldNames ? '' : 'cardLive',
        subBuilder: CardLive.create)
    ..aOM<CardCheese>(5, _omitFieldNames ? '' : 'cardCheese',
        subBuilder: CardCheese.create)
    ..aOS(6, _omitFieldNames ? '' : 'title')
    ..aOS(7, _omitFieldNames ? '' : 'uri')
    ..aInt64(8, _omitFieldNames ? '' : 'viewAt')
    ..aInt64(9, _omitFieldNames ? '' : 'kid')
    ..aInt64(10, _omitFieldNames ? '' : 'oid')
    ..aOS(11, _omitFieldNames ? '' : 'business')
    ..aI(12, _omitFieldNames ? '' : 'tp')
    ..aOM<DeviceType>(13, _omitFieldNames ? '' : 'dt',
        subBuilder: DeviceType.create)
    ..aOB(14, _omitFieldNames ? '' : 'hasShare')
    ..aOS(15, _omitFieldNames ? '' : 'report')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CursorItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CursorItem copyWith(void Function(CursorItem) updates) =>
      super.copyWith((message) => updates(message as CursorItem)) as CursorItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CursorItem create() => CursorItem._();
  @$core.override
  CursorItem createEmptyInstance() => create();
  static $pb.PbList<CursorItem> createRepeated() => $pb.PbList<CursorItem>();
  @$core.pragma('dart2js:noInline')
  static CursorItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CursorItem>(create);
  static CursorItem? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  CursorItem_CardItem whichCardItem() =>
      _CursorItem_CardItemByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearCardItem() => $_clearField($_whichOneof(0));

  /// 参见 [`CardUGC`]
  @$pb.TagNumber(1)
  CardUGC get cardUgc => $_getN(0);
  @$pb.TagNumber(1)
  set cardUgc(CardUGC value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCardUgc() => $_has(0);
  @$pb.TagNumber(1)
  void clearCardUgc() => $_clearField(1);
  @$pb.TagNumber(1)
  CardUGC ensureCardUgc() => $_ensure(0);

  /// 参见 [`CardOGV`]
  @$pb.TagNumber(2)
  CardOGV get cardOgv => $_getN(1);
  @$pb.TagNumber(2)
  set cardOgv(CardOGV value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCardOgv() => $_has(1);
  @$pb.TagNumber(2)
  void clearCardOgv() => $_clearField(2);
  @$pb.TagNumber(2)
  CardOGV ensureCardOgv() => $_ensure(1);

  /// 参见 [`CardArticle`]
  @$pb.TagNumber(3)
  CardArticle get cardArticle => $_getN(2);
  @$pb.TagNumber(3)
  set cardArticle(CardArticle value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCardArticle() => $_has(2);
  @$pb.TagNumber(3)
  void clearCardArticle() => $_clearField(3);
  @$pb.TagNumber(3)
  CardArticle ensureCardArticle() => $_ensure(2);

  /// 参见 [`CardLive`]
  @$pb.TagNumber(4)
  CardLive get cardLive => $_getN(3);
  @$pb.TagNumber(4)
  set cardLive(CardLive value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCardLive() => $_has(3);
  @$pb.TagNumber(4)
  void clearCardLive() => $_clearField(4);
  @$pb.TagNumber(4)
  CardLive ensureCardLive() => $_ensure(3);

  /// 参见 [`CardCheese`]
  @$pb.TagNumber(5)
  CardCheese get cardCheese => $_getN(4);
  @$pb.TagNumber(5)
  set cardCheese(CardCheese value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCardCheese() => $_has(4);
  @$pb.TagNumber(5)
  void clearCardCheese() => $_clearField(5);
  @$pb.TagNumber(5)
  CardCheese ensureCardCheese() => $_ensure(4);

  /// 标题
  @$pb.TagNumber(6)
  $core.String get title => $_getSZ(5);
  @$pb.TagNumber(6)
  set title($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTitle() => $_has(5);
  @$pb.TagNumber(6)
  void clearTitle() => $_clearField(6);

  /// 跳转链接
  @$pb.TagNumber(7)
  $core.String get uri => $_getSZ(6);
  @$pb.TagNumber(7)
  set uri($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUri() => $_has(6);
  @$pb.TagNumber(7)
  void clearUri() => $_clearField(7);

  /// 观看时间
  @$pb.TagNumber(8)
  $fixnum.Int64 get viewAt => $_getI64(7);
  @$pb.TagNumber(8)
  set viewAt($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasViewAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearViewAt() => $_clearField(8);

  /// 历史记录主键
  @$pb.TagNumber(9)
  $fixnum.Int64 get kid => $_getI64(8);
  @$pb.TagNumber(9)
  set kid($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasKid() => $_has(8);
  @$pb.TagNumber(9)
  void clearKid() => $_clearField(9);

  /// 业务 ID (如稿件 avid 或直播间 room_id 等)
  @$pb.TagNumber(10)
  $fixnum.Int64 get oid => $_getI64(9);
  @$pb.TagNumber(10)
  set oid($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasOid() => $_has(9);
  @$pb.TagNumber(10)
  void clearOid() => $_clearField(10);

  /// 业务类型
  @$pb.TagNumber(11)
  $core.String get business => $_getSZ(10);
  @$pb.TagNumber(11)
  set business($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasBusiness() => $_has(10);
  @$pb.TagNumber(11)
  void clearBusiness() => $_clearField(11);

  /// 业务类型
  @$pb.TagNumber(12)
  $core.int get tp => $_getIZ(11);
  @$pb.TagNumber(12)
  set tp($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasTp() => $_has(11);
  @$pb.TagNumber(12)
  void clearTp() => $_clearField(12);

  /// 播放设备
  @$pb.TagNumber(13)
  DeviceType get dt => $_getN(12);
  @$pb.TagNumber(13)
  set dt(DeviceType value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasDt() => $_has(12);
  @$pb.TagNumber(13)
  void clearDt() => $_clearField(13);
  @$pb.TagNumber(13)
  DeviceType ensureDt() => $_ensure(12);

  /// ? 是否带分享按钮
  @$pb.TagNumber(14)
  $core.bool get hasShare => $_getBF(13);
  @$pb.TagNumber(14)
  set hasShare($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasHasShare() => $_has(13);
  @$pb.TagNumber(14)
  void clearHasShare() => $_clearField(14);

  /// ? 埋点上报参数
  @$pb.TagNumber(15)
  $core.String get report => $_getSZ(14);
  @$pb.TagNumber(15)
  set report($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasReport() => $_has(14);
  @$pb.TagNumber(15)
  void clearReport() => $_clearField(15);
}

/// 历史记录列表请求返回值
class CursorReply extends $pb.GeneratedMessage {
  factory CursorReply({
    $core.Iterable<CursorItem>? items,
    $core.Iterable<CursorTab>? tab,
    Cursor? cursor,
    $core.bool? hasMore,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (tab != null) result.tab.addAll(tab);
    if (cursor != null) result.cursor = cursor;
    if (hasMore != null) result.hasMore = hasMore;
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
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..pPM<CursorItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: CursorItem.create)
    ..pPM<CursorTab>(2, _omitFieldNames ? '' : 'tab',
        subBuilder: CursorTab.create)
    ..aOM<Cursor>(3, _omitFieldNames ? '' : 'cursor', subBuilder: Cursor.create)
    ..aOB(4, _omitFieldNames ? '' : 'hasMore')
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
  static $pb.PbList<CursorReply> createRepeated() => $pb.PbList<CursorReply>();
  @$core.pragma('dart2js:noInline')
  static CursorReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CursorReply>(create);
  static CursorReply? _defaultInstance;

  /// 参见 [`CursorItem`]
  @$pb.TagNumber(1)
  $pb.PbList<CursorItem> get items => $_getList(0);

  /// 参见 [`CursorTab`]
  @$pb.TagNumber(2)
  $pb.PbList<CursorTab> get tab => $_getList(1);

  /// 当前偏移
  @$pb.TagNumber(3)
  Cursor get cursor => $_getN(2);
  @$pb.TagNumber(3)
  set cursor(Cursor value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCursor() => $_has(2);
  @$pb.TagNumber(3)
  void clearCursor() => $_clearField(3);
  @$pb.TagNumber(3)
  Cursor ensureCursor() => $_ensure(2);

  /// 是否还有更多数据
  @$pb.TagNumber(4)
  $core.bool get hasMore => $_getBF(3);
  @$pb.TagNumber(4)
  set hasMore($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHasMore() => $_has(3);
  @$pb.TagNumber(4)
  void clearHasMore() => $_clearField(4);
}

/// 历史记录列表请求参数
class CursorReq extends $pb.GeneratedMessage {
  factory CursorReq({
    Cursor? cursor,
    $core.String? business,
    PlayerPreloadParams? playerPreload,
    $3.PlayerArgs? playerArgs,
  }) {
    final result = create();
    if (cursor != null) result.cursor = cursor;
    if (business != null) result.business = business;
    if (playerPreload != null) result.playerPreload = playerPreload;
    if (playerArgs != null) result.playerArgs = playerArgs;
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
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOM<Cursor>(1, _omitFieldNames ? '' : 'cursor', subBuilder: Cursor.create)
    ..aOS(2, _omitFieldNames ? '' : 'business')
    ..aOM<PlayerPreloadParams>(3, _omitFieldNames ? '' : 'playerPreload',
        subBuilder: PlayerPreloadParams.create)
    ..aOM<$3.PlayerArgs>(4, _omitFieldNames ? '' : 'playerArgs',
        subBuilder: $3.PlayerArgs.create)
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
  static $pb.PbList<CursorReq> createRepeated() => $pb.PbList<CursorReq>();
  @$core.pragma('dart2js:noInline')
  static CursorReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CursorReq>(create);
  static CursorReq? _defaultInstance;

  /// 翻页游标 (透传上一页的游标)
  @$pb.TagNumber(1)
  Cursor get cursor => $_getN(0);
  @$pb.TagNumber(1)
  set cursor(Cursor value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCursor() => $_has(0);
  @$pb.TagNumber(1)
  void clearCursor() => $_clearField(1);
  @$pb.TagNumber(1)
  Cursor ensureCursor() => $_ensure(0);

  /// 业务类型
  ///
  /// - 全部: `all`
  /// - 视频: `archive`
  /// - 直播: `live`
  /// - 专栏: `article`
  @$pb.TagNumber(2)
  $core.String get business => $_getSZ(1);
  @$pb.TagNumber(2)
  set business($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBusiness() => $_has(1);
  @$pb.TagNumber(2)
  void clearBusiness() => $_clearField(2);

  /// 秒开参数
  @$pb.TagNumber(3)
  PlayerPreloadParams get playerPreload => $_getN(2);
  @$pb.TagNumber(3)
  set playerPreload(PlayerPreloadParams value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPlayerPreload() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlayerPreload() => $_clearField(3);
  @$pb.TagNumber(3)
  PlayerPreloadParams ensurePlayerPreload() => $_ensure(2);

  /// 秒开参数
  @$pb.TagNumber(4)
  $3.PlayerArgs get playerArgs => $_getN(3);
  @$pb.TagNumber(4)
  set playerArgs($3.PlayerArgs value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPlayerArgs() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlayerArgs() => $_clearField(4);
  @$pb.TagNumber(4)
  $3.PlayerArgs ensurePlayerArgs() => $_ensure(3);
}

/// 历史记录顶部 tab
class CursorTab extends $pb.GeneratedMessage {
  factory CursorTab({
    $core.String? business,
    $core.String? name,
    $core.String? router,
    $core.bool? focus,
  }) {
    final result = create();
    if (business != null) result.business = business;
    if (name != null) result.name = name;
    if (router != null) result.router = router;
    if (focus != null) result.focus = focus;
    return result;
  }

  CursorTab._();

  factory CursorTab.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CursorTab.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CursorTab',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'business')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'router')
    ..aOB(4, _omitFieldNames ? '' : 'focus')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CursorTab clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CursorTab copyWith(void Function(CursorTab) updates) =>
      super.copyWith((message) => updates(message as CursorTab)) as CursorTab;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CursorTab create() => CursorTab._();
  @$core.override
  CursorTab createEmptyInstance() => create();
  static $pb.PbList<CursorTab> createRepeated() => $pb.PbList<CursorTab>();
  @$core.pragma('dart2js:noInline')
  static CursorTab getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CursorTab>(create);
  static CursorTab? _defaultInstance;

  /// 业务类型
  @$pb.TagNumber(1)
  $core.String get business => $_getSZ(0);
  @$pb.TagNumber(1)
  set business($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBusiness() => $_has(0);
  @$pb.TagNumber(1)
  void clearBusiness() => $_clearField(1);

  /// 业务名称
  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// ? app 内部跳转路由
  @$pb.TagNumber(3)
  $core.String get router => $_getSZ(2);
  @$pb.TagNumber(3)
  set router($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRouter() => $_has(2);
  @$pb.TagNumber(3)
  void clearRouter() => $_clearField(3);

  /// ? 是否选中
  @$pb.TagNumber(4)
  $core.bool get focus => $_getBF(3);
  @$pb.TagNumber(4)
  set focus($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFocus() => $_has(3);
  @$pb.TagNumber(4)
  void clearFocus() => $_clearField(4);
}

/// 参见 [`CursorReply`]
class CursorV2Reply extends $pb.GeneratedMessage {
  factory CursorV2Reply({
    $core.Iterable<CursorItem>? items,
    Cursor? cursor,
    $core.bool? hasMore,
    $core.String? emptyLink,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (cursor != null) result.cursor = cursor;
    if (hasMore != null) result.hasMore = hasMore;
    if (emptyLink != null) result.emptyLink = emptyLink;
    return result;
  }

  CursorV2Reply._();

  factory CursorV2Reply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CursorV2Reply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CursorV2Reply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..pPM<CursorItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: CursorItem.create)
    ..aOM<Cursor>(2, _omitFieldNames ? '' : 'cursor', subBuilder: Cursor.create)
    ..aOB(3, _omitFieldNames ? '' : 'hasMore')
    ..aOS(4, _omitFieldNames ? '' : 'emptyLink')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CursorV2Reply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CursorV2Reply copyWith(void Function(CursorV2Reply) updates) =>
      super.copyWith((message) => updates(message as CursorV2Reply))
          as CursorV2Reply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CursorV2Reply create() => CursorV2Reply._();
  @$core.override
  CursorV2Reply createEmptyInstance() => create();
  static $pb.PbList<CursorV2Reply> createRepeated() =>
      $pb.PbList<CursorV2Reply>();
  @$core.pragma('dart2js:noInline')
  static CursorV2Reply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CursorV2Reply>(create);
  static CursorV2Reply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CursorItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  Cursor get cursor => $_getN(1);
  @$pb.TagNumber(2)
  set cursor(Cursor value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCursor() => $_has(1);
  @$pb.TagNumber(2)
  void clearCursor() => $_clearField(2);
  @$pb.TagNumber(2)
  Cursor ensureCursor() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get hasMore => $_getBF(2);
  @$pb.TagNumber(3)
  set hasMore($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasMore() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasMore() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get emptyLink => $_getSZ(3);
  @$pb.TagNumber(4)
  set emptyLink($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEmptyLink() => $_has(3);
  @$pb.TagNumber(4)
  void clearEmptyLink() => $_clearField(4);
}

/// 参见 [`CursorReq`]
class CursorV2Req extends $pb.GeneratedMessage {
  factory CursorV2Req({
    Cursor? cursor,
    $core.String? business,
    PlayerPreloadParams? playerPreload,
    $3.PlayerArgs? playerArgs,
    $core.bool? isLocal,
  }) {
    final result = create();
    if (cursor != null) result.cursor = cursor;
    if (business != null) result.business = business;
    if (playerPreload != null) result.playerPreload = playerPreload;
    if (playerArgs != null) result.playerArgs = playerArgs;
    if (isLocal != null) result.isLocal = isLocal;
    return result;
  }

  CursorV2Req._();

  factory CursorV2Req.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CursorV2Req.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CursorV2Req',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOM<Cursor>(1, _omitFieldNames ? '' : 'cursor', subBuilder: Cursor.create)
    ..aOS(2, _omitFieldNames ? '' : 'business')
    ..aOM<PlayerPreloadParams>(3, _omitFieldNames ? '' : 'playerPreload',
        subBuilder: PlayerPreloadParams.create)
    ..aOM<$3.PlayerArgs>(4, _omitFieldNames ? '' : 'playerArgs',
        subBuilder: $3.PlayerArgs.create)
    ..aOB(5, _omitFieldNames ? '' : 'isLocal')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CursorV2Req clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CursorV2Req copyWith(void Function(CursorV2Req) updates) =>
      super.copyWith((message) => updates(message as CursorV2Req))
          as CursorV2Req;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CursorV2Req create() => CursorV2Req._();
  @$core.override
  CursorV2Req createEmptyInstance() => create();
  static $pb.PbList<CursorV2Req> createRepeated() => $pb.PbList<CursorV2Req>();
  @$core.pragma('dart2js:noInline')
  static CursorV2Req getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CursorV2Req>(create);
  static CursorV2Req? _defaultInstance;

  @$pb.TagNumber(1)
  Cursor get cursor => $_getN(0);
  @$pb.TagNumber(1)
  set cursor(Cursor value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCursor() => $_has(0);
  @$pb.TagNumber(1)
  void clearCursor() => $_clearField(1);
  @$pb.TagNumber(1)
  Cursor ensureCursor() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get business => $_getSZ(1);
  @$pb.TagNumber(2)
  set business($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBusiness() => $_has(1);
  @$pb.TagNumber(2)
  void clearBusiness() => $_clearField(2);

  @$pb.TagNumber(3)
  PlayerPreloadParams get playerPreload => $_getN(2);
  @$pb.TagNumber(3)
  set playerPreload(PlayerPreloadParams value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPlayerPreload() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlayerPreload() => $_clearField(3);
  @$pb.TagNumber(3)
  PlayerPreloadParams ensurePlayerPreload() => $_ensure(2);

  @$pb.TagNumber(4)
  $3.PlayerArgs get playerArgs => $_getN(3);
  @$pb.TagNumber(4)
  set playerArgs($3.PlayerArgs value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPlayerArgs() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlayerArgs() => $_clearField(4);
  @$pb.TagNumber(4)
  $3.PlayerArgs ensurePlayerArgs() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get isLocal => $_getBF(4);
  @$pb.TagNumber(5)
  set isLocal($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsLocal() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsLocal() => $_clearField(5);
}

class DefaultWordsReply extends $pb.GeneratedMessage {
  factory DefaultWordsReply({
    $core.String? trackid,
    $core.String? param,
    $core.String? show,
    $core.String? word,
    $fixnum.Int64? showFront,
    $core.String? expStr,
    $core.String? goto,
    $core.String? value,
    $core.String? uri,
    $fixnum.Int64? enableRefresh,
    $fixnum.Int64? refreshIntervalMilli,
    $fixnum.Int64? enableAnimation,
    $fixnum.Int64? animationTimeMilli,
  }) {
    final result = create();
    if (trackid != null) result.trackid = trackid;
    if (param != null) result.param = param;
    if (show != null) result.show = show;
    if (word != null) result.word = word;
    if (showFront != null) result.showFront = showFront;
    if (expStr != null) result.expStr = expStr;
    if (goto != null) result.goto = goto;
    if (value != null) result.value = value;
    if (uri != null) result.uri = uri;
    if (enableRefresh != null) result.enableRefresh = enableRefresh;
    if (refreshIntervalMilli != null)
      result.refreshIntervalMilli = refreshIntervalMilli;
    if (enableAnimation != null) result.enableAnimation = enableAnimation;
    if (animationTimeMilli != null)
      result.animationTimeMilli = animationTimeMilli;
    return result;
  }

  DefaultWordsReply._();

  factory DefaultWordsReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefaultWordsReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefaultWordsReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trackid')
    ..aOS(2, _omitFieldNames ? '' : 'param')
    ..aOS(3, _omitFieldNames ? '' : 'show')
    ..aOS(4, _omitFieldNames ? '' : 'word')
    ..aInt64(5, _omitFieldNames ? '' : 'showFront')
    ..aOS(6, _omitFieldNames ? '' : 'expStr')
    ..aOS(7, _omitFieldNames ? '' : 'goto')
    ..aOS(8, _omitFieldNames ? '' : 'value')
    ..aOS(9, _omitFieldNames ? '' : 'uri')
    ..aInt64(10, _omitFieldNames ? '' : 'enableRefresh')
    ..aInt64(11, _omitFieldNames ? '' : 'refreshIntervalMilli')
    ..aInt64(12, _omitFieldNames ? '' : 'enableAnimation')
    ..aInt64(13, _omitFieldNames ? '' : 'animationTimeMilli')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefaultWordsReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefaultWordsReply copyWith(void Function(DefaultWordsReply) updates) =>
      super.copyWith((message) => updates(message as DefaultWordsReply))
          as DefaultWordsReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefaultWordsReply create() => DefaultWordsReply._();
  @$core.override
  DefaultWordsReply createEmptyInstance() => create();
  static $pb.PbList<DefaultWordsReply> createRepeated() =>
      $pb.PbList<DefaultWordsReply>();
  @$core.pragma('dart2js:noInline')
  static DefaultWordsReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefaultWordsReply>(create);
  static DefaultWordsReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trackid => $_getSZ(0);
  @$pb.TagNumber(1)
  set trackid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrackid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrackid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get param => $_getSZ(1);
  @$pb.TagNumber(2)
  set param($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasParam() => $_has(1);
  @$pb.TagNumber(2)
  void clearParam() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get show => $_getSZ(2);
  @$pb.TagNumber(3)
  set show($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasShow() => $_has(2);
  @$pb.TagNumber(3)
  void clearShow() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get word => $_getSZ(3);
  @$pb.TagNumber(4)
  set word($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWord() => $_has(3);
  @$pb.TagNumber(4)
  void clearWord() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get showFront => $_getI64(4);
  @$pb.TagNumber(5)
  set showFront($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasShowFront() => $_has(4);
  @$pb.TagNumber(5)
  void clearShowFront() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get expStr => $_getSZ(5);
  @$pb.TagNumber(6)
  set expStr($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExpStr() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpStr() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get goto => $_getSZ(6);
  @$pb.TagNumber(7)
  set goto($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasGoto() => $_has(6);
  @$pb.TagNumber(7)
  void clearGoto() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get value => $_getSZ(7);
  @$pb.TagNumber(8)
  set value($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasValue() => $_has(7);
  @$pb.TagNumber(8)
  void clearValue() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get uri => $_getSZ(8);
  @$pb.TagNumber(9)
  set uri($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUri() => $_has(8);
  @$pb.TagNumber(9)
  void clearUri() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get enableRefresh => $_getI64(9);
  @$pb.TagNumber(10)
  set enableRefresh($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasEnableRefresh() => $_has(9);
  @$pb.TagNumber(10)
  void clearEnableRefresh() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get refreshIntervalMilli => $_getI64(10);
  @$pb.TagNumber(11)
  set refreshIntervalMilli($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRefreshIntervalMilli() => $_has(10);
  @$pb.TagNumber(11)
  void clearRefreshIntervalMilli() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get enableAnimation => $_getI64(11);
  @$pb.TagNumber(12)
  set enableAnimation($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasEnableAnimation() => $_has(11);
  @$pb.TagNumber(12)
  void clearEnableAnimation() => $_clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get animationTimeMilli => $_getI64(12);
  @$pb.TagNumber(13)
  set animationTimeMilli($fixnum.Int64 value) => $_setInt64(12, value);
  @$pb.TagNumber(13)
  $core.bool hasAnimationTimeMilli() => $_has(12);
  @$pb.TagNumber(13)
  void clearAnimationTimeMilli() => $_clearField(13);
}

class DefaultWordsReq extends $pb.GeneratedMessage {
  factory DefaultWordsReq({
    $fixnum.Int64? from,
    $fixnum.Int64? loginEvent,
    $core.int? teenagersMode,
    $core.int? lessonsMode,
    $core.String? tab,
    $core.String? eventId,
    $core.String? avid,
    $core.String? query,
    $fixnum.Int64? an,
    $fixnum.Int64? isFresh,
    $core.String? splashGuide,
    $fixnum.Int64? splashId,
    $fixnum.Int64? refreshType,
    $core.String? userAct,
    $core.int? searchPageReturn,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (loginEvent != null) result.loginEvent = loginEvent;
    if (teenagersMode != null) result.teenagersMode = teenagersMode;
    if (lessonsMode != null) result.lessonsMode = lessonsMode;
    if (tab != null) result.tab = tab;
    if (eventId != null) result.eventId = eventId;
    if (avid != null) result.avid = avid;
    if (query != null) result.query = query;
    if (an != null) result.an = an;
    if (isFresh != null) result.isFresh = isFresh;
    if (splashGuide != null) result.splashGuide = splashGuide;
    if (splashId != null) result.splashId = splashId;
    if (refreshType != null) result.refreshType = refreshType;
    if (userAct != null) result.userAct = userAct;
    if (searchPageReturn != null) result.searchPageReturn = searchPageReturn;
    return result;
  }

  DefaultWordsReq._();

  factory DefaultWordsReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefaultWordsReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefaultWordsReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'from')
    ..aInt64(2, _omitFieldNames ? '' : 'loginEvent')
    ..aI(3, _omitFieldNames ? '' : 'teenagersMode')
    ..aI(4, _omitFieldNames ? '' : 'lessonsMode')
    ..aOS(5, _omitFieldNames ? '' : 'tab')
    ..aOS(6, _omitFieldNames ? '' : 'eventId')
    ..aOS(7, _omitFieldNames ? '' : 'avid')
    ..aOS(8, _omitFieldNames ? '' : 'query')
    ..aInt64(9, _omitFieldNames ? '' : 'an')
    ..aInt64(10, _omitFieldNames ? '' : 'isFresh')
    ..aOS(11, _omitFieldNames ? '' : 'splashGuide')
    ..aInt64(12, _omitFieldNames ? '' : 'splashId')
    ..aInt64(13, _omitFieldNames ? '' : 'refreshType')
    ..aOS(14, _omitFieldNames ? '' : 'userAct')
    ..aI(15, _omitFieldNames ? '' : 'searchPageReturn')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefaultWordsReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefaultWordsReq copyWith(void Function(DefaultWordsReq) updates) =>
      super.copyWith((message) => updates(message as DefaultWordsReq))
          as DefaultWordsReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefaultWordsReq create() => DefaultWordsReq._();
  @$core.override
  DefaultWordsReq createEmptyInstance() => create();
  static $pb.PbList<DefaultWordsReq> createRepeated() =>
      $pb.PbList<DefaultWordsReq>();
  @$core.pragma('dart2js:noInline')
  static DefaultWordsReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefaultWordsReq>(create);
  static DefaultWordsReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get from => $_getI64(0);
  @$pb.TagNumber(1)
  set from($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get loginEvent => $_getI64(1);
  @$pb.TagNumber(2)
  set loginEvent($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLoginEvent() => $_has(1);
  @$pb.TagNumber(2)
  void clearLoginEvent() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get teenagersMode => $_getIZ(2);
  @$pb.TagNumber(3)
  set teenagersMode($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTeenagersMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearTeenagersMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get lessonsMode => $_getIZ(3);
  @$pb.TagNumber(4)
  set lessonsMode($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLessonsMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearLessonsMode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get tab => $_getSZ(4);
  @$pb.TagNumber(5)
  set tab($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTab() => $_has(4);
  @$pb.TagNumber(5)
  void clearTab() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get eventId => $_getSZ(5);
  @$pb.TagNumber(6)
  set eventId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEventId() => $_has(5);
  @$pb.TagNumber(6)
  void clearEventId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get avid => $_getSZ(6);
  @$pb.TagNumber(7)
  set avid($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAvid() => $_has(6);
  @$pb.TagNumber(7)
  void clearAvid() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get query => $_getSZ(7);
  @$pb.TagNumber(8)
  set query($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasQuery() => $_has(7);
  @$pb.TagNumber(8)
  void clearQuery() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get an => $_getI64(8);
  @$pb.TagNumber(9)
  set an($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAn() => $_has(8);
  @$pb.TagNumber(9)
  void clearAn() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get isFresh => $_getI64(9);
  @$pb.TagNumber(10)
  set isFresh($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIsFresh() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsFresh() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get splashGuide => $_getSZ(10);
  @$pb.TagNumber(11)
  set splashGuide($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSplashGuide() => $_has(10);
  @$pb.TagNumber(11)
  void clearSplashGuide() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get splashId => $_getI64(11);
  @$pb.TagNumber(12)
  set splashId($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSplashId() => $_has(11);
  @$pb.TagNumber(12)
  void clearSplashId() => $_clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get refreshType => $_getI64(12);
  @$pb.TagNumber(13)
  set refreshType($fixnum.Int64 value) => $_setInt64(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRefreshType() => $_has(12);
  @$pb.TagNumber(13)
  void clearRefreshType() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get userAct => $_getSZ(13);
  @$pb.TagNumber(14)
  set userAct($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasUserAct() => $_has(13);
  @$pb.TagNumber(14)
  void clearUserAct() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get searchPageReturn => $_getIZ(14);
  @$pb.TagNumber(15)
  set searchPageReturn($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasSearchPageReturn() => $_has(14);
  @$pb.TagNumber(15)
  void clearSearchPageReturn() => $_clearField(15);
}

/// 历史记录删除请求参数
class DeleteReq extends $pb.GeneratedMessage {
  factory DeleteReq({
    $core.Iterable<HisInfo>? hisInfo,
    $core.String? tab,
  }) {
    final result = create();
    if (hisInfo != null) result.hisInfo.addAll(hisInfo);
    if (tab != null) result.tab = tab;
    return result;
  }

  DeleteReq._();

  factory DeleteReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..pPM<HisInfo>(1, _omitFieldNames ? '' : 'hisInfo',
        subBuilder: HisInfo.create)
    ..aOS(2, _omitFieldNames ? '' : 'tab')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteReq copyWith(void Function(DeleteReq) updates) =>
      super.copyWith((message) => updates(message as DeleteReq)) as DeleteReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteReq create() => DeleteReq._();
  @$core.override
  DeleteReq createEmptyInstance() => create();
  static $pb.PbList<DeleteReq> createRepeated() => $pb.PbList<DeleteReq>();
  @$core.pragma('dart2js:noInline')
  static DeleteReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteReq>(create);
  static DeleteReq? _defaultInstance;

  /// 要删除的历史信息
  @$pb.TagNumber(1)
  $pb.PbList<HisInfo> get hisInfo => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get tab => $_getSZ(1);
  @$pb.TagNumber(2)
  set tab($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTab() => $_has(1);
  @$pb.TagNumber(2)
  void clearTab() => $_clearField(2);
}

/// 设备类型
class DeviceType extends $pb.GeneratedMessage {
  factory DeviceType({
    DT? type,
    $core.String? icon,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (icon != null) result.icon = icon;
    return result;
  }

  DeviceType._();

  factory DeviceType.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceType.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceType',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aE<DT>(1, _omitFieldNames ? '' : 'type', enumValues: DT.values)
    ..aOS(2, _omitFieldNames ? '' : 'icon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceType clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceType copyWith(void Function(DeviceType) updates) =>
      super.copyWith((message) => updates(message as DeviceType)) as DeviceType;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceType create() => DeviceType._();
  @$core.override
  DeviceType createEmptyInstance() => create();
  static $pb.PbList<DeviceType> createRepeated() => $pb.PbList<DeviceType>();
  @$core.pragma('dart2js:noInline')
  static DeviceType getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceType>(create);
  static DeviceType? _defaultInstance;

  /// 设备类型
  @$pb.TagNumber(1)
  DT get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(DT value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  /// 图标
  @$pb.TagNumber(2)
  $core.String get icon => $_getSZ(1);
  @$pb.TagNumber(2)
  set icon($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIcon() => $_has(1);
  @$pb.TagNumber(2)
  void clearIcon() => $_clearField(2);
}

class Dynamic extends $pb.GeneratedMessage {
  factory Dynamic({
    $4.DynamicItem? dynamic,
  }) {
    final result = create();
    if (dynamic != null) result.dynamic = dynamic;
    return result;
  }

  Dynamic._();

  factory Dynamic.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Dynamic.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Dynamic',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOM<$4.DynamicItem>(1, _omitFieldNames ? '' : 'dynamic',
        subBuilder: $4.DynamicItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Dynamic clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Dynamic copyWith(void Function(Dynamic) updates) =>
      super.copyWith((message) => updates(message as Dynamic)) as Dynamic;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Dynamic create() => Dynamic._();
  @$core.override
  Dynamic createEmptyInstance() => create();
  static $pb.PbList<Dynamic> createRepeated() => $pb.PbList<Dynamic>();
  @$core.pragma('dart2js:noInline')
  static Dynamic getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Dynamic>(create);
  static Dynamic? _defaultInstance;

  @$pb.TagNumber(1)
  $4.DynamicItem get dynamic => $_getN(0);
  @$pb.TagNumber(1)
  set dynamic($4.DynamicItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDynamic() => $_has(0);
  @$pb.TagNumber(1)
  void clearDynamic() => $_clearField(1);
  @$pb.TagNumber(1)
  $4.DynamicItem ensureDynamic() => $_ensure(0);
}

class FacialRecognitionVerifyReply extends $pb.GeneratedMessage {
  factory FacialRecognitionVerifyReply() => create();

  FacialRecognitionVerifyReply._();

  factory FacialRecognitionVerifyReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FacialRecognitionVerifyReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FacialRecognitionVerifyReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FacialRecognitionVerifyReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FacialRecognitionVerifyReply copyWith(
          void Function(FacialRecognitionVerifyReply) updates) =>
      super.copyWith(
              (message) => updates(message as FacialRecognitionVerifyReply))
          as FacialRecognitionVerifyReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FacialRecognitionVerifyReply create() =>
      FacialRecognitionVerifyReply._();
  @$core.override
  FacialRecognitionVerifyReply createEmptyInstance() => create();
  static $pb.PbList<FacialRecognitionVerifyReply> createRepeated() =>
      $pb.PbList<FacialRecognitionVerifyReply>();
  @$core.pragma('dart2js:noInline')
  static FacialRecognitionVerifyReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FacialRecognitionVerifyReply>(create);
  static FacialRecognitionVerifyReply? _defaultInstance;
}

class FacialRecognitionVerifyReq extends $pb.GeneratedMessage {
  factory FacialRecognitionVerifyReq({
    FacialRecognitionVerifyFrom? from,
    $core.String? deviceToken,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (deviceToken != null) result.deviceToken = deviceToken;
    return result;
  }

  FacialRecognitionVerifyReq._();

  factory FacialRecognitionVerifyReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FacialRecognitionVerifyReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FacialRecognitionVerifyReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aE<FacialRecognitionVerifyFrom>(1, _omitFieldNames ? '' : 'from',
        enumValues: FacialRecognitionVerifyFrom.values)
    ..aOS(2, _omitFieldNames ? '' : 'deviceToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FacialRecognitionVerifyReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FacialRecognitionVerifyReq copyWith(
          void Function(FacialRecognitionVerifyReq) updates) =>
      super.copyWith(
              (message) => updates(message as FacialRecognitionVerifyReq))
          as FacialRecognitionVerifyReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FacialRecognitionVerifyReq create() => FacialRecognitionVerifyReq._();
  @$core.override
  FacialRecognitionVerifyReq createEmptyInstance() => create();
  static $pb.PbList<FacialRecognitionVerifyReq> createRepeated() =>
      $pb.PbList<FacialRecognitionVerifyReq>();
  @$core.pragma('dart2js:noInline')
  static FacialRecognitionVerifyReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FacialRecognitionVerifyReq>(create);
  static FacialRecognitionVerifyReq? _defaultInstance;

  @$pb.TagNumber(1)
  FacialRecognitionVerifyFrom get from => $_getN(0);
  @$pb.TagNumber(1)
  set from(FacialRecognitionVerifyFrom value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeviceToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceToken() => $_clearField(2);
}

class HisInfo extends $pb.GeneratedMessage {
  factory HisInfo({
    $core.String? business,
    $fixnum.Int64? kid,
  }) {
    final result = create();
    if (business != null) result.business = business;
    if (kid != null) result.kid = kid;
    return result;
  }

  HisInfo._();

  factory HisInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HisInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HisInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'business')
    ..aInt64(2, _omitFieldNames ? '' : 'kid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HisInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HisInfo copyWith(void Function(HisInfo) updates) =>
      super.copyWith((message) => updates(message as HisInfo)) as HisInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HisInfo create() => HisInfo._();
  @$core.override
  HisInfo createEmptyInstance() => create();
  static $pb.PbList<HisInfo> createRepeated() => $pb.PbList<HisInfo>();
  @$core.pragma('dart2js:noInline')
  static HisInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HisInfo>(create);
  static HisInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get business => $_getSZ(0);
  @$pb.TagNumber(1)
  set business($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBusiness() => $_has(0);
  @$pb.TagNumber(1)
  void clearBusiness() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get kid => $_getI64(1);
  @$pb.TagNumber(2)
  set kid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKid() => $_has(1);
  @$pb.TagNumber(2)
  void clearKid() => $_clearField(2);
}

class HistoryTabReply extends $pb.GeneratedMessage {
  factory HistoryTabReply({
    $core.Iterable<CursorTab>? tab,
  }) {
    final result = create();
    if (tab != null) result.tab.addAll(tab);
    return result;
  }

  HistoryTabReply._();

  factory HistoryTabReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HistoryTabReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HistoryTabReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..pPM<CursorTab>(1, _omitFieldNames ? '' : 'tab',
        subBuilder: CursorTab.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HistoryTabReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HistoryTabReply copyWith(void Function(HistoryTabReply) updates) =>
      super.copyWith((message) => updates(message as HistoryTabReply))
          as HistoryTabReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HistoryTabReply create() => HistoryTabReply._();
  @$core.override
  HistoryTabReply createEmptyInstance() => create();
  static $pb.PbList<HistoryTabReply> createRepeated() =>
      $pb.PbList<HistoryTabReply>();
  @$core.pragma('dart2js:noInline')
  static HistoryTabReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HistoryTabReply>(create);
  static HistoryTabReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CursorTab> get tab => $_getList(0);
}

class HistoryTabReq extends $pb.GeneratedMessage {
  factory HistoryTabReq({
    $core.String? business,
    HistorySource? source,
    $core.String? keyword,
  }) {
    final result = create();
    if (business != null) result.business = business;
    if (source != null) result.source = source;
    if (keyword != null) result.keyword = keyword;
    return result;
  }

  HistoryTabReq._();

  factory HistoryTabReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HistoryTabReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HistoryTabReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'business')
    ..aE<HistorySource>(2, _omitFieldNames ? '' : 'source',
        enumValues: HistorySource.values)
    ..aOS(3, _omitFieldNames ? '' : 'keyword')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HistoryTabReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HistoryTabReq copyWith(void Function(HistoryTabReq) updates) =>
      super.copyWith((message) => updates(message as HistoryTabReq))
          as HistoryTabReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HistoryTabReq create() => HistoryTabReq._();
  @$core.override
  HistoryTabReq createEmptyInstance() => create();
  static $pb.PbList<HistoryTabReq> createRepeated() =>
      $pb.PbList<HistoryTabReq>();
  @$core.pragma('dart2js:noInline')
  static HistoryTabReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HistoryTabReq>(create);
  static HistoryTabReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get business => $_getSZ(0);
  @$pb.TagNumber(1)
  set business($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBusiness() => $_has(0);
  @$pb.TagNumber(1)
  void clearBusiness() => $_clearField(1);

  @$pb.TagNumber(2)
  HistorySource get source => $_getN(1);
  @$pb.TagNumber(2)
  set source(HistorySource value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSource() => $_has(1);
  @$pb.TagNumber(2)
  void clearSource() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get keyword => $_getSZ(2);
  @$pb.TagNumber(3)
  set keyword($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasKeyword() => $_has(2);
  @$pb.TagNumber(3)
  void clearKeyword() => $_clearField(3);
}

class LatestHistoryReply extends $pb.GeneratedMessage {
  factory LatestHistoryReply({
    CursorItem? items,
    $core.String? scene,
    $fixnum.Int64? rtime,
    $core.String? flag,
  }) {
    final result = create();
    if (items != null) result.items = items;
    if (scene != null) result.scene = scene;
    if (rtime != null) result.rtime = rtime;
    if (flag != null) result.flag = flag;
    return result;
  }

  LatestHistoryReply._();

  factory LatestHistoryReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LatestHistoryReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LatestHistoryReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOM<CursorItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: CursorItem.create)
    ..aOS(2, _omitFieldNames ? '' : 'scene')
    ..aInt64(3, _omitFieldNames ? '' : 'rtime')
    ..aOS(4, _omitFieldNames ? '' : 'flag')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LatestHistoryReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LatestHistoryReply copyWith(void Function(LatestHistoryReply) updates) =>
      super.copyWith((message) => updates(message as LatestHistoryReply))
          as LatestHistoryReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LatestHistoryReply create() => LatestHistoryReply._();
  @$core.override
  LatestHistoryReply createEmptyInstance() => create();
  static $pb.PbList<LatestHistoryReply> createRepeated() =>
      $pb.PbList<LatestHistoryReply>();
  @$core.pragma('dart2js:noInline')
  static LatestHistoryReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LatestHistoryReply>(create);
  static LatestHistoryReply? _defaultInstance;

  @$pb.TagNumber(1)
  CursorItem get items => $_getN(0);
  @$pb.TagNumber(1)
  set items(CursorItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItems() => $_has(0);
  @$pb.TagNumber(1)
  void clearItems() => $_clearField(1);
  @$pb.TagNumber(1)
  CursorItem ensureItems() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get scene => $_getSZ(1);
  @$pb.TagNumber(2)
  set scene($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScene() => $_has(1);
  @$pb.TagNumber(2)
  void clearScene() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get rtime => $_getI64(2);
  @$pb.TagNumber(3)
  set rtime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRtime() => $_has(2);
  @$pb.TagNumber(3)
  void clearRtime() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get flag => $_getSZ(3);
  @$pb.TagNumber(4)
  set flag($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFlag() => $_has(3);
  @$pb.TagNumber(4)
  void clearFlag() => $_clearField(4);
}

class LatestHistoryReq extends $pb.GeneratedMessage {
  factory LatestHistoryReq({
    $core.String? business,
    PlayerPreloadParams? playerPreload,
  }) {
    final result = create();
    if (business != null) result.business = business;
    if (playerPreload != null) result.playerPreload = playerPreload;
    return result;
  }

  LatestHistoryReq._();

  factory LatestHistoryReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LatestHistoryReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LatestHistoryReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'business')
    ..aOM<PlayerPreloadParams>(2, _omitFieldNames ? '' : 'playerPreload',
        subBuilder: PlayerPreloadParams.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LatestHistoryReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LatestHistoryReq copyWith(void Function(LatestHistoryReq) updates) =>
      super.copyWith((message) => updates(message as LatestHistoryReq))
          as LatestHistoryReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LatestHistoryReq create() => LatestHistoryReq._();
  @$core.override
  LatestHistoryReq createEmptyInstance() => create();
  static $pb.PbList<LatestHistoryReq> createRepeated() =>
      $pb.PbList<LatestHistoryReq>();
  @$core.pragma('dart2js:noInline')
  static LatestHistoryReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LatestHistoryReq>(create);
  static LatestHistoryReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get business => $_getSZ(0);
  @$pb.TagNumber(1)
  set business($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBusiness() => $_has(0);
  @$pb.TagNumber(1)
  void clearBusiness() => $_clearField(1);

  @$pb.TagNumber(2)
  PlayerPreloadParams get playerPreload => $_getN(1);
  @$pb.TagNumber(2)
  set playerPreload(PlayerPreloadParams value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlayerPreload() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayerPreload() => $_clearField(2);
  @$pb.TagNumber(2)
  PlayerPreloadParams ensurePlayerPreload() => $_ensure(1);
}

class LikeButton extends $pb.GeneratedMessage {
  factory LikeButton({
    $fixnum.Int64? aid,
    $core.int? count,
    $core.bool? showCount,
    $core.String? event,
    $core.int? selected,
    $core.String? eventV2,
    LikeButtonResource? likeResource,
    LikeButtonResource? disLikeResource,
    LikeButtonResource? likeNightResource,
    LikeButtonResource? disLikeNightResource,
  }) {
    final result = create();
    if (aid != null) result.aid = aid;
    if (count != null) result.count = count;
    if (showCount != null) result.showCount = showCount;
    if (event != null) result.event = event;
    if (selected != null) result.selected = selected;
    if (eventV2 != null) result.eventV2 = eventV2;
    if (likeResource != null) result.likeResource = likeResource;
    if (disLikeResource != null) result.disLikeResource = disLikeResource;
    if (likeNightResource != null) result.likeNightResource = likeNightResource;
    if (disLikeNightResource != null)
      result.disLikeNightResource = disLikeNightResource;
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
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aI(2, _omitFieldNames ? '' : 'count')
    ..aOB(3, _omitFieldNames ? '' : 'showCount')
    ..aOS(4, _omitFieldNames ? '' : 'event')
    ..aI(5, _omitFieldNames ? '' : 'selected')
    ..aOS(6, _omitFieldNames ? '' : 'eventV2')
    ..aOM<LikeButtonResource>(7, _omitFieldNames ? '' : 'likeResource',
        subBuilder: LikeButtonResource.create)
    ..aOM<LikeButtonResource>(8, _omitFieldNames ? '' : 'disLikeResource',
        subBuilder: LikeButtonResource.create)
    ..aOM<LikeButtonResource>(9, _omitFieldNames ? '' : 'likeNightResource',
        subBuilder: LikeButtonResource.create)
    ..aOM<LikeButtonResource>(10, _omitFieldNames ? '' : 'disLikeNightResource',
        subBuilder: LikeButtonResource.create)
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

  @$pb.TagNumber(7)
  LikeButtonResource get likeResource => $_getN(6);
  @$pb.TagNumber(7)
  set likeResource(LikeButtonResource value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasLikeResource() => $_has(6);
  @$pb.TagNumber(7)
  void clearLikeResource() => $_clearField(7);
  @$pb.TagNumber(7)
  LikeButtonResource ensureLikeResource() => $_ensure(6);

  @$pb.TagNumber(8)
  LikeButtonResource get disLikeResource => $_getN(7);
  @$pb.TagNumber(8)
  set disLikeResource(LikeButtonResource value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDisLikeResource() => $_has(7);
  @$pb.TagNumber(8)
  void clearDisLikeResource() => $_clearField(8);
  @$pb.TagNumber(8)
  LikeButtonResource ensureDisLikeResource() => $_ensure(7);

  @$pb.TagNumber(9)
  LikeButtonResource get likeNightResource => $_getN(8);
  @$pb.TagNumber(9)
  set likeNightResource(LikeButtonResource value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasLikeNightResource() => $_has(8);
  @$pb.TagNumber(9)
  void clearLikeNightResource() => $_clearField(9);
  @$pb.TagNumber(9)
  LikeButtonResource ensureLikeNightResource() => $_ensure(8);

  @$pb.TagNumber(10)
  LikeButtonResource get disLikeNightResource => $_getN(9);
  @$pb.TagNumber(10)
  set disLikeNightResource(LikeButtonResource value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasDisLikeNightResource() => $_has(9);
  @$pb.TagNumber(10)
  void clearDisLikeNightResource() => $_clearField(10);
  @$pb.TagNumber(10)
  LikeButtonResource ensureDisLikeNightResource() => $_ensure(9);
}

class LikeButtonResource extends $pb.GeneratedMessage {
  factory LikeButtonResource({
    $core.String? url,
    $core.String? hash,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (hash != null) result.hash = hash;
    return result;
  }

  LikeButtonResource._();

  factory LikeButtonResource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LikeButtonResource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LikeButtonResource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOS(2, _omitFieldNames ? '' : 'hash')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeButtonResource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeButtonResource copyWith(void Function(LikeButtonResource) updates) =>
      super.copyWith((message) => updates(message as LikeButtonResource))
          as LikeButtonResource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LikeButtonResource create() => LikeButtonResource._();
  @$core.override
  LikeButtonResource createEmptyInstance() => create();
  static $pb.PbList<LikeButtonResource> createRepeated() =>
      $pb.PbList<LikeButtonResource>();
  @$core.pragma('dart2js:noInline')
  static LikeButtonResource getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LikeButtonResource>(create);
  static LikeButtonResource? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get hash => $_getSZ(1);
  @$pb.TagNumber(2)
  set hash($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearHash() => $_clearField(2);
}

class LikeCard extends $pb.GeneratedMessage {
  factory LikeCard({
    $fixnum.Int64? like,
    $core.bool? isFollow,
  }) {
    final result = create();
    if (like != null) result.like = like;
    if (isFollow != null) result.isFollow = isFollow;
    return result;
  }

  LikeCard._();

  factory LikeCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LikeCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LikeCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'like')
    ..aOB(2, _omitFieldNames ? '' : 'isFollow')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeCard copyWith(void Function(LikeCard) updates) =>
      super.copyWith((message) => updates(message as LikeCard)) as LikeCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LikeCard create() => LikeCard._();
  @$core.override
  LikeCard createEmptyInstance() => create();
  static $pb.PbList<LikeCard> createRepeated() => $pb.PbList<LikeCard>();
  @$core.pragma('dart2js:noInline')
  static LikeCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LikeCard>(create);
  static LikeCard? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get like => $_getI64(0);
  @$pb.TagNumber(1)
  set like($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLike() => $_has(0);
  @$pb.TagNumber(1)
  void clearLike() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isFollow => $_getBF(1);
  @$pb.TagNumber(2)
  set isFollow($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsFollow() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsFollow() => $_clearField(2);
}

class MediaCard extends $pb.GeneratedMessage {
  factory MediaCard({
    $core.String? cover,
    $core.String? curTitle,
    $core.String? style,
    $core.String? label,
    Button? butFirst,
    Supernatant? butSecond,
    Scores? scores,
  }) {
    final result = create();
    if (cover != null) result.cover = cover;
    if (curTitle != null) result.curTitle = curTitle;
    if (style != null) result.style = style;
    if (label != null) result.label = label;
    if (butFirst != null) result.butFirst = butFirst;
    if (butSecond != null) result.butSecond = butSecond;
    if (scores != null) result.scores = scores;
    return result;
  }

  MediaCard._();

  factory MediaCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cover')
    ..aOS(2, _omitFieldNames ? '' : 'curTitle')
    ..aOS(3, _omitFieldNames ? '' : 'style')
    ..aOS(4, _omitFieldNames ? '' : 'label')
    ..aOM<Button>(5, _omitFieldNames ? '' : 'butFirst',
        subBuilder: Button.create)
    ..aOM<Supernatant>(6, _omitFieldNames ? '' : 'butSecond',
        subBuilder: Supernatant.create)
    ..aOM<Scores>(7, _omitFieldNames ? '' : 'scores', subBuilder: Scores.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaCard copyWith(void Function(MediaCard) updates) =>
      super.copyWith((message) => updates(message as MediaCard)) as MediaCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaCard create() => MediaCard._();
  @$core.override
  MediaCard createEmptyInstance() => create();
  static $pb.PbList<MediaCard> createRepeated() => $pb.PbList<MediaCard>();
  @$core.pragma('dart2js:noInline')
  static MediaCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MediaCard>(create);
  static MediaCard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cover => $_getSZ(0);
  @$pb.TagNumber(1)
  set cover($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCover() => $_has(0);
  @$pb.TagNumber(1)
  void clearCover() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get curTitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set curTitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get style => $_getSZ(2);
  @$pb.TagNumber(3)
  set style($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStyle() => $_has(2);
  @$pb.TagNumber(3)
  void clearStyle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get label => $_getSZ(3);
  @$pb.TagNumber(4)
  set label($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLabel() => $_has(3);
  @$pb.TagNumber(4)
  void clearLabel() => $_clearField(4);

  @$pb.TagNumber(5)
  Button get butFirst => $_getN(4);
  @$pb.TagNumber(5)
  set butFirst(Button value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasButFirst() => $_has(4);
  @$pb.TagNumber(5)
  void clearButFirst() => $_clearField(5);
  @$pb.TagNumber(5)
  Button ensureButFirst() => $_ensure(4);

  @$pb.TagNumber(6)
  Supernatant get butSecond => $_getN(5);
  @$pb.TagNumber(6)
  set butSecond(Supernatant value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasButSecond() => $_has(5);
  @$pb.TagNumber(6)
  void clearButSecond() => $_clearField(6);
  @$pb.TagNumber(6)
  Supernatant ensureButSecond() => $_ensure(5);

  @$pb.TagNumber(7)
  Scores get scores => $_getN(6);
  @$pb.TagNumber(7)
  set scores(Scores value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasScores() => $_has(6);
  @$pb.TagNumber(7)
  void clearScores() => $_clearField(7);
  @$pb.TagNumber(7)
  Scores ensureScores() => $_ensure(6);
}

class MediaCommentReply extends $pb.GeneratedMessage {
  factory MediaCommentReply({
    $core.String? errMsg,
  }) {
    final result = create();
    if (errMsg != null) result.errMsg = errMsg;
    return result;
  }

  MediaCommentReply._();

  factory MediaCommentReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaCommentReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaCommentReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'errMsg')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaCommentReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaCommentReply copyWith(void Function(MediaCommentReply) updates) =>
      super.copyWith((message) => updates(message as MediaCommentReply))
          as MediaCommentReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaCommentReply create() => MediaCommentReply._();
  @$core.override
  MediaCommentReply createEmptyInstance() => create();
  static $pb.PbList<MediaCommentReply> createRepeated() =>
      $pb.PbList<MediaCommentReply>();
  @$core.pragma('dart2js:noInline')
  static MediaCommentReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaCommentReply>(create);
  static MediaCommentReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get errMsg => $_getSZ(0);
  @$pb.TagNumber(1)
  set errMsg($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasErrMsg() => $_has(0);
  @$pb.TagNumber(1)
  void clearErrMsg() => $_clearField(1);
}

class MediaCommentReq extends $pb.GeneratedMessage {
  factory MediaCommentReq({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  MediaCommentReq._();

  factory MediaCommentReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaCommentReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaCommentReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaCommentReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaCommentReq copyWith(void Function(MediaCommentReq) updates) =>
      super.copyWith((message) => updates(message as MediaCommentReq))
          as MediaCommentReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaCommentReq create() => MediaCommentReq._();
  @$core.override
  MediaCommentReq createEmptyInstance() => create();
  static $pb.PbList<MediaCommentReq> createRepeated() =>
      $pb.PbList<MediaCommentReq>();
  @$core.pragma('dart2js:noInline')
  static MediaCommentReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaCommentReq>(create);
  static MediaCommentReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class MediaDetailReply extends $pb.GeneratedMessage {
  factory MediaDetailReply({
    Cast? cast,
    Staff? staff,
    Overview? overview,
  }) {
    final result = create();
    if (cast != null) result.cast = cast;
    if (staff != null) result.staff = staff;
    if (overview != null) result.overview = overview;
    return result;
  }

  MediaDetailReply._();

  factory MediaDetailReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaDetailReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaDetailReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOM<Cast>(1, _omitFieldNames ? '' : 'cast', subBuilder: Cast.create)
    ..aOM<Staff>(2, _omitFieldNames ? '' : 'staff', subBuilder: Staff.create)
    ..aOM<Overview>(3, _omitFieldNames ? '' : 'overview',
        subBuilder: Overview.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaDetailReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaDetailReply copyWith(void Function(MediaDetailReply) updates) =>
      super.copyWith((message) => updates(message as MediaDetailReply))
          as MediaDetailReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaDetailReply create() => MediaDetailReply._();
  @$core.override
  MediaDetailReply createEmptyInstance() => create();
  static $pb.PbList<MediaDetailReply> createRepeated() =>
      $pb.PbList<MediaDetailReply>();
  @$core.pragma('dart2js:noInline')
  static MediaDetailReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaDetailReply>(create);
  static MediaDetailReply? _defaultInstance;

  @$pb.TagNumber(1)
  Cast get cast => $_getN(0);
  @$pb.TagNumber(1)
  set cast(Cast value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCast() => $_has(0);
  @$pb.TagNumber(1)
  void clearCast() => $_clearField(1);
  @$pb.TagNumber(1)
  Cast ensureCast() => $_ensure(0);

  @$pb.TagNumber(2)
  Staff get staff => $_getN(1);
  @$pb.TagNumber(2)
  set staff(Staff value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStaff() => $_has(1);
  @$pb.TagNumber(2)
  void clearStaff() => $_clearField(2);
  @$pb.TagNumber(2)
  Staff ensureStaff() => $_ensure(1);

  @$pb.TagNumber(3)
  Overview get overview => $_getN(2);
  @$pb.TagNumber(3)
  set overview(Overview value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOverview() => $_has(2);
  @$pb.TagNumber(3)
  void clearOverview() => $_clearField(3);
  @$pb.TagNumber(3)
  Overview ensureOverview() => $_ensure(2);
}

class MediaDetailReq extends $pb.GeneratedMessage {
  factory MediaDetailReq({
    $fixnum.Int64? bizId,
    $fixnum.Int64? bizType,
  }) {
    final result = create();
    if (bizId != null) result.bizId = bizId;
    if (bizType != null) result.bizType = bizType;
    return result;
  }

  MediaDetailReq._();

  factory MediaDetailReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaDetailReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaDetailReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'bizId')
    ..aInt64(2, _omitFieldNames ? '' : 'bizType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaDetailReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaDetailReq copyWith(void Function(MediaDetailReq) updates) =>
      super.copyWith((message) => updates(message as MediaDetailReq))
          as MediaDetailReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaDetailReq create() => MediaDetailReq._();
  @$core.override
  MediaDetailReq createEmptyInstance() => create();
  static $pb.PbList<MediaDetailReq> createRepeated() =>
      $pb.PbList<MediaDetailReq>();
  @$core.pragma('dart2js:noInline')
  static MediaDetailReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaDetailReq>(create);
  static MediaDetailReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get bizId => $_getI64(0);
  @$pb.TagNumber(1)
  set bizId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBizId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBizId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get bizType => $_getI64(1);
  @$pb.TagNumber(2)
  set bizType($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBizType() => $_has(1);
  @$pb.TagNumber(2)
  void clearBizType() => $_clearField(2);
}

class MediaFollowReply extends $pb.GeneratedMessage {
  factory MediaFollowReply() => create();

  MediaFollowReply._();

  factory MediaFollowReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaFollowReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaFollowReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaFollowReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaFollowReply copyWith(void Function(MediaFollowReply) updates) =>
      super.copyWith((message) => updates(message as MediaFollowReply))
          as MediaFollowReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaFollowReply create() => MediaFollowReply._();
  @$core.override
  MediaFollowReply createEmptyInstance() => create();
  static $pb.PbList<MediaFollowReply> createRepeated() =>
      $pb.PbList<MediaFollowReply>();
  @$core.pragma('dart2js:noInline')
  static MediaFollowReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaFollowReply>(create);
  static MediaFollowReply? _defaultInstance;
}

class MediaFollowReq extends $pb.GeneratedMessage {
  factory MediaFollowReq({
    $core.String? id,
    ButType? type,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (type != null) result.type = type;
    return result;
  }

  MediaFollowReq._();

  factory MediaFollowReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaFollowReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaFollowReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aE<ButType>(2, _omitFieldNames ? '' : 'type', enumValues: ButType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaFollowReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaFollowReq copyWith(void Function(MediaFollowReq) updates) =>
      super.copyWith((message) => updates(message as MediaFollowReq))
          as MediaFollowReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaFollowReq create() => MediaFollowReq._();
  @$core.override
  MediaFollowReq createEmptyInstance() => create();
  static $pb.PbList<MediaFollowReq> createRepeated() =>
      $pb.PbList<MediaFollowReq>();
  @$core.pragma('dart2js:noInline')
  static MediaFollowReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaFollowReq>(create);
  static MediaFollowReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  ButType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(ButType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);
}

class MediaPerson extends $pb.GeneratedMessage {
  factory MediaPerson({
    $core.String? realName,
    $core.String? squareUrl,
    $core.String? character,
    $fixnum.Int64? personId,
    $core.String? type,
  }) {
    final result = create();
    if (realName != null) result.realName = realName;
    if (squareUrl != null) result.squareUrl = squareUrl;
    if (character != null) result.character = character;
    if (personId != null) result.personId = personId;
    if (type != null) result.type = type;
    return result;
  }

  MediaPerson._();

  factory MediaPerson.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaPerson.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaPerson',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'realName')
    ..aOS(2, _omitFieldNames ? '' : 'squareUrl')
    ..aOS(3, _omitFieldNames ? '' : 'character')
    ..aInt64(4, _omitFieldNames ? '' : 'personId')
    ..aOS(5, _omitFieldNames ? '' : 'type')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaPerson clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaPerson copyWith(void Function(MediaPerson) updates) =>
      super.copyWith((message) => updates(message as MediaPerson))
          as MediaPerson;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaPerson create() => MediaPerson._();
  @$core.override
  MediaPerson createEmptyInstance() => create();
  static $pb.PbList<MediaPerson> createRepeated() => $pb.PbList<MediaPerson>();
  @$core.pragma('dart2js:noInline')
  static MediaPerson getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaPerson>(create);
  static MediaPerson? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get realName => $_getSZ(0);
  @$pb.TagNumber(1)
  set realName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRealName() => $_has(0);
  @$pb.TagNumber(1)
  void clearRealName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get squareUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set squareUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSquareUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearSquareUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get character => $_getSZ(2);
  @$pb.TagNumber(3)
  set character($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCharacter() => $_has(2);
  @$pb.TagNumber(3)
  void clearCharacter() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get personId => $_getI64(3);
  @$pb.TagNumber(4)
  set personId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPersonId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPersonId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get type => $_getSZ(4);
  @$pb.TagNumber(5)
  set type($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasType() => $_has(4);
  @$pb.TagNumber(5)
  void clearType() => $_clearField(5);
}

class MediaRelationReply extends $pb.GeneratedMessage {
  factory MediaRelationReply({
    $core.String? offset,
    $core.bool? hasMore,
    $core.Iterable<SmallItem>? list,
  }) {
    final result = create();
    if (offset != null) result.offset = offset;
    if (hasMore != null) result.hasMore = hasMore;
    if (list != null) result.list.addAll(list);
    return result;
  }

  MediaRelationReply._();

  factory MediaRelationReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaRelationReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaRelationReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'offset')
    ..aOB(2, _omitFieldNames ? '' : 'hasMore')
    ..pPM<SmallItem>(3, _omitFieldNames ? '' : 'list',
        subBuilder: SmallItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaRelationReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaRelationReply copyWith(void Function(MediaRelationReply) updates) =>
      super.copyWith((message) => updates(message as MediaRelationReply))
          as MediaRelationReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaRelationReply create() => MediaRelationReply._();
  @$core.override
  MediaRelationReply createEmptyInstance() => create();
  static $pb.PbList<MediaRelationReply> createRepeated() =>
      $pb.PbList<MediaRelationReply>();
  @$core.pragma('dart2js:noInline')
  static MediaRelationReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaRelationReply>(create);
  static MediaRelationReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get offset => $_getSZ(0);
  @$pb.TagNumber(1)
  set offset($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOffset() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffset() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get hasMore => $_getBF(1);
  @$pb.TagNumber(2)
  set hasMore($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHasMore() => $_has(1);
  @$pb.TagNumber(2)
  void clearHasMore() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<SmallItem> get list => $_getList(2);
}

class MediaRelationReq extends $pb.GeneratedMessage {
  factory MediaRelationReq({
    $fixnum.Int64? bizId,
    $fixnum.Int64? bizType,
    $fixnum.Int64? feedId,
    $core.String? offset,
    $core.int? ps,
  }) {
    final result = create();
    if (bizId != null) result.bizId = bizId;
    if (bizType != null) result.bizType = bizType;
    if (feedId != null) result.feedId = feedId;
    if (offset != null) result.offset = offset;
    if (ps != null) result.ps = ps;
    return result;
  }

  MediaRelationReq._();

  factory MediaRelationReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaRelationReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaRelationReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'bizId')
    ..aInt64(2, _omitFieldNames ? '' : 'bizType')
    ..aInt64(3, _omitFieldNames ? '' : 'feedId')
    ..aOS(5, _omitFieldNames ? '' : 'offset')
    ..aI(6, _omitFieldNames ? '' : 'ps')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaRelationReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaRelationReq copyWith(void Function(MediaRelationReq) updates) =>
      super.copyWith((message) => updates(message as MediaRelationReq))
          as MediaRelationReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaRelationReq create() => MediaRelationReq._();
  @$core.override
  MediaRelationReq createEmptyInstance() => create();
  static $pb.PbList<MediaRelationReq> createRepeated() =>
      $pb.PbList<MediaRelationReq>();
  @$core.pragma('dart2js:noInline')
  static MediaRelationReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaRelationReq>(create);
  static MediaRelationReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get bizId => $_getI64(0);
  @$pb.TagNumber(1)
  set bizId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBizId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBizId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get bizType => $_getI64(1);
  @$pb.TagNumber(2)
  set bizType($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBizType() => $_has(1);
  @$pb.TagNumber(2)
  void clearBizType() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get feedId => $_getI64(2);
  @$pb.TagNumber(3)
  set feedId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFeedId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeedId() => $_clearField(3);

  @$pb.TagNumber(5)
  $core.String get offset => $_getSZ(3);
  @$pb.TagNumber(5)
  set offset($core.String value) => $_setString(3, value);
  @$pb.TagNumber(5)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(5)
  void clearOffset() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get ps => $_getIZ(4);
  @$pb.TagNumber(6)
  set ps($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(6)
  $core.bool hasPs() => $_has(4);
  @$pb.TagNumber(6)
  void clearPs() => $_clearField(6);
}

class MediaTabReply extends $pb.GeneratedMessage {
  factory MediaTabReply({
    MediaCard? mediaCard,
    $core.Iterable<ShowTab>? tab,
    $fixnum.Int64? defaultTabIndex,
    ChannelInfo? channelInfo,
  }) {
    final result = create();
    if (mediaCard != null) result.mediaCard = mediaCard;
    if (tab != null) result.tab.addAll(tab);
    if (defaultTabIndex != null) result.defaultTabIndex = defaultTabIndex;
    if (channelInfo != null) result.channelInfo = channelInfo;
    return result;
  }

  MediaTabReply._();

  factory MediaTabReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaTabReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaTabReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOM<MediaCard>(1, _omitFieldNames ? '' : 'mediaCard',
        subBuilder: MediaCard.create)
    ..pPM<ShowTab>(2, _omitFieldNames ? '' : 'tab', subBuilder: ShowTab.create)
    ..aInt64(3, _omitFieldNames ? '' : 'defaultTabIndex')
    ..aOM<ChannelInfo>(4, _omitFieldNames ? '' : 'channelInfo',
        subBuilder: ChannelInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaTabReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaTabReply copyWith(void Function(MediaTabReply) updates) =>
      super.copyWith((message) => updates(message as MediaTabReply))
          as MediaTabReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaTabReply create() => MediaTabReply._();
  @$core.override
  MediaTabReply createEmptyInstance() => create();
  static $pb.PbList<MediaTabReply> createRepeated() =>
      $pb.PbList<MediaTabReply>();
  @$core.pragma('dart2js:noInline')
  static MediaTabReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaTabReply>(create);
  static MediaTabReply? _defaultInstance;

  @$pb.TagNumber(1)
  MediaCard get mediaCard => $_getN(0);
  @$pb.TagNumber(1)
  set mediaCard(MediaCard value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaCard() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaCard() => $_clearField(1);
  @$pb.TagNumber(1)
  MediaCard ensureMediaCard() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<ShowTab> get tab => $_getList(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get defaultTabIndex => $_getI64(2);
  @$pb.TagNumber(3)
  set defaultTabIndex($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDefaultTabIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearDefaultTabIndex() => $_clearField(3);

  @$pb.TagNumber(4)
  ChannelInfo get channelInfo => $_getN(3);
  @$pb.TagNumber(4)
  set channelInfo(ChannelInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasChannelInfo() => $_has(3);
  @$pb.TagNumber(4)
  void clearChannelInfo() => $_clearField(4);
  @$pb.TagNumber(4)
  ChannelInfo ensureChannelInfo() => $_ensure(3);
}

class MediaTabReq extends $pb.GeneratedMessage {
  factory MediaTabReq({
    $fixnum.Int64? bizId,
    $fixnum.Int64? bizType,
    $core.String? source,
    $core.String? spmid,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? args,
  }) {
    final result = create();
    if (bizId != null) result.bizId = bizId;
    if (bizType != null) result.bizType = bizType;
    if (source != null) result.source = source;
    if (spmid != null) result.spmid = spmid;
    if (args != null) result.args.addEntries(args);
    return result;
  }

  MediaTabReq._();

  factory MediaTabReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaTabReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaTabReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'bizId')
    ..aInt64(2, _omitFieldNames ? '' : 'bizType')
    ..aOS(3, _omitFieldNames ? '' : 'source')
    ..aOS(4, _omitFieldNames ? '' : 'spmid')
    ..m<$core.String, $core.String>(5, _omitFieldNames ? '' : 'args',
        entryClassName: 'MediaTabReq.ArgsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.interfaces.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaTabReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaTabReq copyWith(void Function(MediaTabReq) updates) =>
      super.copyWith((message) => updates(message as MediaTabReq))
          as MediaTabReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaTabReq create() => MediaTabReq._();
  @$core.override
  MediaTabReq createEmptyInstance() => create();
  static $pb.PbList<MediaTabReq> createRepeated() => $pb.PbList<MediaTabReq>();
  @$core.pragma('dart2js:noInline')
  static MediaTabReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaTabReq>(create);
  static MediaTabReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get bizId => $_getI64(0);
  @$pb.TagNumber(1)
  set bizId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBizId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBizId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get bizType => $_getI64(1);
  @$pb.TagNumber(2)
  set bizType($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBizType() => $_has(1);
  @$pb.TagNumber(2)
  void clearBizType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get source => $_getSZ(2);
  @$pb.TagNumber(3)
  set source($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get spmid => $_getSZ(3);
  @$pb.TagNumber(4)
  set spmid($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSpmid() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpmid() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.String> get args => $_getMap(4);
}

class MediaVideoReply extends $pb.GeneratedMessage {
  factory MediaVideoReply({
    $core.String? offset,
    $core.bool? hasMore,
    $core.Iterable<BigItem>? list,
  }) {
    final result = create();
    if (offset != null) result.offset = offset;
    if (hasMore != null) result.hasMore = hasMore;
    if (list != null) result.list.addAll(list);
    return result;
  }

  MediaVideoReply._();

  factory MediaVideoReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaVideoReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaVideoReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'offset')
    ..aOB(2, _omitFieldNames ? '' : 'hasMore')
    ..pPM<BigItem>(3, _omitFieldNames ? '' : 'list', subBuilder: BigItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaVideoReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaVideoReply copyWith(void Function(MediaVideoReply) updates) =>
      super.copyWith((message) => updates(message as MediaVideoReply))
          as MediaVideoReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaVideoReply create() => MediaVideoReply._();
  @$core.override
  MediaVideoReply createEmptyInstance() => create();
  static $pb.PbList<MediaVideoReply> createRepeated() =>
      $pb.PbList<MediaVideoReply>();
  @$core.pragma('dart2js:noInline')
  static MediaVideoReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaVideoReply>(create);
  static MediaVideoReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get offset => $_getSZ(0);
  @$pb.TagNumber(1)
  set offset($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOffset() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffset() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get hasMore => $_getBF(1);
  @$pb.TagNumber(2)
  set hasMore($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHasMore() => $_has(1);
  @$pb.TagNumber(2)
  void clearHasMore() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<BigItem> get list => $_getList(2);
}

class MediaVideoReq extends $pb.GeneratedMessage {
  factory MediaVideoReq({
    $fixnum.Int64? bizId,
    $fixnum.Int64? bizType,
    $fixnum.Int64? feedId,
    $core.String? offset,
    $core.int? ps,
    $3.PlayerArgs? playerArgs,
  }) {
    final result = create();
    if (bizId != null) result.bizId = bizId;
    if (bizType != null) result.bizType = bizType;
    if (feedId != null) result.feedId = feedId;
    if (offset != null) result.offset = offset;
    if (ps != null) result.ps = ps;
    if (playerArgs != null) result.playerArgs = playerArgs;
    return result;
  }

  MediaVideoReq._();

  factory MediaVideoReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MediaVideoReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaVideoReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'bizId')
    ..aInt64(2, _omitFieldNames ? '' : 'bizType')
    ..aInt64(3, _omitFieldNames ? '' : 'feedId')
    ..aOS(5, _omitFieldNames ? '' : 'offset')
    ..aI(6, _omitFieldNames ? '' : 'ps')
    ..aOM<$3.PlayerArgs>(7, _omitFieldNames ? '' : 'playerArgs',
        subBuilder: $3.PlayerArgs.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaVideoReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaVideoReq copyWith(void Function(MediaVideoReq) updates) =>
      super.copyWith((message) => updates(message as MediaVideoReq))
          as MediaVideoReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MediaVideoReq create() => MediaVideoReq._();
  @$core.override
  MediaVideoReq createEmptyInstance() => create();
  static $pb.PbList<MediaVideoReq> createRepeated() =>
      $pb.PbList<MediaVideoReq>();
  @$core.pragma('dart2js:noInline')
  static MediaVideoReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaVideoReq>(create);
  static MediaVideoReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get bizId => $_getI64(0);
  @$pb.TagNumber(1)
  set bizId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBizId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBizId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get bizType => $_getI64(1);
  @$pb.TagNumber(2)
  set bizType($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBizType() => $_has(1);
  @$pb.TagNumber(2)
  void clearBizType() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get feedId => $_getI64(2);
  @$pb.TagNumber(3)
  set feedId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFeedId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeedId() => $_clearField(3);

  @$pb.TagNumber(5)
  $core.String get offset => $_getSZ(3);
  @$pb.TagNumber(5)
  set offset($core.String value) => $_setString(3, value);
  @$pb.TagNumber(5)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(5)
  void clearOffset() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get ps => $_getIZ(4);
  @$pb.TagNumber(6)
  set ps($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(6)
  $core.bool hasPs() => $_has(4);
  @$pb.TagNumber(6)
  void clearPs() => $_clearField(6);

  @$pb.TagNumber(7)
  $3.PlayerArgs get playerArgs => $_getN(5);
  @$pb.TagNumber(7)
  set playerArgs($3.PlayerArgs value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPlayerArgs() => $_has(5);
  @$pb.TagNumber(7)
  void clearPlayerArgs() => $_clearField(7);
  @$pb.TagNumber(7)
  $3.PlayerArgs ensurePlayerArgs() => $_ensure(5);
}

class ModeStatusReply extends $pb.GeneratedMessage {
  factory ModeStatusReply({
    $core.Iterable<UserModel>? userModels,
  }) {
    final result = create();
    if (userModels != null) result.userModels.addAll(userModels);
    return result;
  }

  ModeStatusReply._();

  factory ModeStatusReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ModeStatusReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModeStatusReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..pPM<UserModel>(1, _omitFieldNames ? '' : 'userModels',
        subBuilder: UserModel.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModeStatusReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModeStatusReply copyWith(void Function(ModeStatusReply) updates) =>
      super.copyWith((message) => updates(message as ModeStatusReply))
          as ModeStatusReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ModeStatusReply create() => ModeStatusReply._();
  @$core.override
  ModeStatusReply createEmptyInstance() => create();
  static $pb.PbList<ModeStatusReply> createRepeated() =>
      $pb.PbList<ModeStatusReply>();
  @$core.pragma('dart2js:noInline')
  static ModeStatusReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModeStatusReply>(create);
  static ModeStatusReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<UserModel> get userModels => $_getList(0);
}

class ModeStatusReq extends $pb.GeneratedMessage {
  factory ModeStatusReq({
    $core.String? deviceToken,
  }) {
    final result = create();
    if (deviceToken != null) result.deviceToken = deviceToken;
    return result;
  }

  ModeStatusReq._();

  factory ModeStatusReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ModeStatusReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModeStatusReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModeStatusReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModeStatusReq copyWith(void Function(ModeStatusReq) updates) =>
      super.copyWith((message) => updates(message as ModeStatusReq))
          as ModeStatusReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ModeStatusReq create() => ModeStatusReq._();
  @$core.override
  ModeStatusReq createEmptyInstance() => create();
  static $pb.PbList<ModeStatusReq> createRepeated() =>
      $pb.PbList<ModeStatusReq>();
  @$core.pragma('dart2js:noInline')
  static ModeStatusReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModeStatusReq>(create);
  static ModeStatusReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceToken() => $_clearField(1);
}

class ModifyPwdReply extends $pb.GeneratedMessage {
  factory ModifyPwdReply() => create();

  ModifyPwdReply._();

  factory ModifyPwdReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ModifyPwdReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModifyPwdReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModifyPwdReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModifyPwdReply copyWith(void Function(ModifyPwdReply) updates) =>
      super.copyWith((message) => updates(message as ModifyPwdReply))
          as ModifyPwdReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ModifyPwdReply create() => ModifyPwdReply._();
  @$core.override
  ModifyPwdReply createEmptyInstance() => create();
  static $pb.PbList<ModifyPwdReply> createRepeated() =>
      $pb.PbList<ModifyPwdReply>();
  @$core.pragma('dart2js:noInline')
  static ModifyPwdReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModifyPwdReply>(create);
  static ModifyPwdReply? _defaultInstance;
}

class ModifyPwdReq extends $pb.GeneratedMessage {
  factory ModifyPwdReq({
    $core.String? oldPwd,
    $core.String? newPwd,
    $core.String? deviceToken,
  }) {
    final result = create();
    if (oldPwd != null) result.oldPwd = oldPwd;
    if (newPwd != null) result.newPwd = newPwd;
    if (deviceToken != null) result.deviceToken = deviceToken;
    return result;
  }

  ModifyPwdReq._();

  factory ModifyPwdReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ModifyPwdReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ModifyPwdReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'oldPwd')
    ..aOS(2, _omitFieldNames ? '' : 'newPwd')
    ..aOS(3, _omitFieldNames ? '' : 'deviceToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModifyPwdReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ModifyPwdReq copyWith(void Function(ModifyPwdReq) updates) =>
      super.copyWith((message) => updates(message as ModifyPwdReq))
          as ModifyPwdReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ModifyPwdReq create() => ModifyPwdReq._();
  @$core.override
  ModifyPwdReq createEmptyInstance() => create();
  static $pb.PbList<ModifyPwdReq> createRepeated() =>
      $pb.PbList<ModifyPwdReq>();
  @$core.pragma('dart2js:noInline')
  static ModifyPwdReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ModifyPwdReq>(create);
  static ModifyPwdReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get oldPwd => $_getSZ(0);
  @$pb.TagNumber(1)
  set oldPwd($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOldPwd() => $_has(0);
  @$pb.TagNumber(1)
  void clearOldPwd() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get newPwd => $_getSZ(1);
  @$pb.TagNumber(2)
  set newPwd($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNewPwd() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewPwd() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get deviceToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set deviceToken($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeviceToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeviceToken() => $_clearField(3);
}

class NftFaceIcon extends $pb.GeneratedMessage {
  factory NftFaceIcon({
    $core.int? regionType,
    $core.String? icon,
    $core.int? showStatus,
  }) {
    final result = create();
    if (regionType != null) result.regionType = regionType;
    if (icon != null) result.icon = icon;
    if (showStatus != null) result.showStatus = showStatus;
    return result;
  }

  NftFaceIcon._();

  factory NftFaceIcon.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NftFaceIcon.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NftFaceIcon',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'regionType')
    ..aOS(2, _omitFieldNames ? '' : 'icon')
    ..aI(3, _omitFieldNames ? '' : 'showStatus')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NftFaceIcon clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NftFaceIcon copyWith(void Function(NftFaceIcon) updates) =>
      super.copyWith((message) => updates(message as NftFaceIcon))
          as NftFaceIcon;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NftFaceIcon create() => NftFaceIcon._();
  @$core.override
  NftFaceIcon createEmptyInstance() => create();
  static $pb.PbList<NftFaceIcon> createRepeated() => $pb.PbList<NftFaceIcon>();
  @$core.pragma('dart2js:noInline')
  static NftFaceIcon getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NftFaceIcon>(create);
  static NftFaceIcon? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get regionType => $_getIZ(0);
  @$pb.TagNumber(1)
  set regionType($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRegionType() => $_has(0);
  @$pb.TagNumber(1)
  void clearRegionType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get icon => $_getSZ(1);
  @$pb.TagNumber(2)
  set icon($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIcon() => $_has(1);
  @$pb.TagNumber(2)
  void clearIcon() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get showStatus => $_getIZ(2);
  @$pb.TagNumber(3)
  set showStatus($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasShowStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearShowStatus() => $_clearField(3);
}

class NoReply extends $pb.GeneratedMessage {
  factory NoReply() => create();

  NoReply._();

  factory NoReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NoReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NoReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NoReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NoReply copyWith(void Function(NoReply) updates) =>
      super.copyWith((message) => updates(message as NoReply)) as NoReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NoReply create() => NoReply._();
  @$core.override
  NoReply createEmptyInstance() => create();
  static $pb.PbList<NoReply> createRepeated() => $pb.PbList<NoReply>();
  @$core.pragma('dart2js:noInline')
  static NoReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NoReply>(create);
  static NoReply? _defaultInstance;
}

class OfficialVerify extends $pb.GeneratedMessage {
  factory OfficialVerify({
    $core.int? type,
    $core.String? desc,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (desc != null) result.desc = desc;
    return result;
  }

  OfficialVerify._();

  factory OfficialVerify.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OfficialVerify.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfficialVerify',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'type')
    ..aOS(2, _omitFieldNames ? '' : 'desc')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfficialVerify clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfficialVerify copyWith(void Function(OfficialVerify) updates) =>
      super.copyWith((message) => updates(message as OfficialVerify))
          as OfficialVerify;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OfficialVerify create() => OfficialVerify._();
  @$core.override
  OfficialVerify createEmptyInstance() => create();
  static $pb.PbList<OfficialVerify> createRepeated() =>
      $pb.PbList<OfficialVerify>();
  @$core.pragma('dart2js:noInline')
  static OfficialVerify getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfficialVerify>(create);
  static OfficialVerify? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get desc => $_getSZ(1);
  @$pb.TagNumber(2)
  set desc($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDesc() => $_has(1);
  @$pb.TagNumber(2)
  void clearDesc() => $_clearField(2);
}

class Overview extends $pb.GeneratedMessage {
  factory Overview({
    $core.String? title,
    $core.String? text,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (text != null) result.text = text;
    return result;
  }

  Overview._();

  factory Overview.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Overview.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Overview',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Overview clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Overview copyWith(void Function(Overview) updates) =>
      super.copyWith((message) => updates(message as Overview)) as Overview;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Overview create() => Overview._();
  @$core.override
  Overview createEmptyInstance() => create();
  static $pb.PbList<Overview> createRepeated() => $pb.PbList<Overview>();
  @$core.pragma('dart2js:noInline')
  static Overview getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Overview>(create);
  static Overview? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);
}

class Page extends $pb.GeneratedMessage {
  factory Page({
    $fixnum.Int64? pn,
    $fixnum.Int64? total,
  }) {
    final result = create();
    if (pn != null) result.pn = pn;
    if (total != null) result.total = total;
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
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'pn')
    ..aInt64(2, _omitFieldNames ? '' : 'total')
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

  @$pb.TagNumber(1)
  $fixnum.Int64 get pn => $_getI64(0);
  @$pb.TagNumber(1)
  set pn($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPn() => $_has(0);
  @$pb.TagNumber(1)
  void clearPn() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class PlayerPreloadParams extends $pb.GeneratedMessage {
  factory PlayerPreloadParams({
    $fixnum.Int64? qn,
    $fixnum.Int64? fnver,
    $fixnum.Int64? fnval,
    $fixnum.Int64? forceHost,
    $fixnum.Int64? fourk,
  }) {
    final result = create();
    if (qn != null) result.qn = qn;
    if (fnver != null) result.fnver = fnver;
    if (fnval != null) result.fnval = fnval;
    if (forceHost != null) result.forceHost = forceHost;
    if (fourk != null) result.fourk = fourk;
    return result;
  }

  PlayerPreloadParams._();

  factory PlayerPreloadParams.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlayerPreloadParams.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerPreloadParams',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'qn')
    ..aInt64(2, _omitFieldNames ? '' : 'fnver')
    ..aInt64(3, _omitFieldNames ? '' : 'fnval')
    ..aInt64(4, _omitFieldNames ? '' : 'forceHost')
    ..aInt64(5, _omitFieldNames ? '' : 'fourk')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerPreloadParams clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerPreloadParams copyWith(void Function(PlayerPreloadParams) updates) =>
      super.copyWith((message) => updates(message as PlayerPreloadParams))
          as PlayerPreloadParams;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlayerPreloadParams create() => PlayerPreloadParams._();
  @$core.override
  PlayerPreloadParams createEmptyInstance() => create();
  static $pb.PbList<PlayerPreloadParams> createRepeated() =>
      $pb.PbList<PlayerPreloadParams>();
  @$core.pragma('dart2js:noInline')
  static PlayerPreloadParams getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayerPreloadParams>(create);
  static PlayerPreloadParams? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get qn => $_getI64(0);
  @$pb.TagNumber(1)
  set qn($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQn() => $_has(0);
  @$pb.TagNumber(1)
  void clearQn() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get fnver => $_getI64(1);
  @$pb.TagNumber(2)
  set fnver($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFnver() => $_has(1);
  @$pb.TagNumber(2)
  void clearFnver() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get fnval => $_getI64(2);
  @$pb.TagNumber(3)
  set fnval($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFnval() => $_has(2);
  @$pb.TagNumber(3)
  void clearFnval() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get forceHost => $_getI64(3);
  @$pb.TagNumber(4)
  set forceHost($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasForceHost() => $_has(3);
  @$pb.TagNumber(4)
  void clearForceHost() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get fourk => $_getI64(4);
  @$pb.TagNumber(5)
  set fourk($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFourk() => $_has(4);
  @$pb.TagNumber(5)
  void clearFourk() => $_clearField(5);
}

class Policy extends $pb.GeneratedMessage {
  factory Policy({
    $fixnum.Int64? interval,
    $core.bool? useLocalTime,
  }) {
    final result = create();
    if (interval != null) result.interval = interval;
    if (useLocalTime != null) result.useLocalTime = useLocalTime;
    return result;
  }

  Policy._();

  factory Policy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Policy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Policy',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'interval')
    ..aOB(2, _omitFieldNames ? '' : 'useLocalTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Policy clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Policy copyWith(void Function(Policy) updates) =>
      super.copyWith((message) => updates(message as Policy)) as Policy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Policy create() => Policy._();
  @$core.override
  Policy createEmptyInstance() => create();
  static $pb.PbList<Policy> createRepeated() => $pb.PbList<Policy>();
  @$core.pragma('dart2js:noInline')
  static Policy getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Policy>(create);
  static Policy? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get interval => $_getI64(0);
  @$pb.TagNumber(1)
  set interval($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInterval() => $_has(0);
  @$pb.TagNumber(1)
  void clearInterval() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get useLocalTime => $_getBF(1);
  @$pb.TagNumber(2)
  set useLocalTime($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUseLocalTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearUseLocalTime() => $_clearField(2);
}

class ReasonStyle extends $pb.GeneratedMessage {
  factory ReasonStyle({
    $core.String? text,
    $core.String? textColor,
    $core.String? textColorNight,
    $core.String? bgColor,
    $core.String? bgColorNight,
    $core.String? borderColor,
    $core.String? borderColorNight,
    $core.int? bgStyle,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (textColor != null) result.textColor = textColor;
    if (textColorNight != null) result.textColorNight = textColorNight;
    if (bgColor != null) result.bgColor = bgColor;
    if (bgColorNight != null) result.bgColorNight = bgColorNight;
    if (borderColor != null) result.borderColor = borderColor;
    if (borderColorNight != null) result.borderColorNight = borderColorNight;
    if (bgStyle != null) result.bgStyle = bgStyle;
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
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'textColor')
    ..aOS(3, _omitFieldNames ? '' : 'textColorNight')
    ..aOS(4, _omitFieldNames ? '' : 'bgColor')
    ..aOS(5, _omitFieldNames ? '' : 'bgColorNight')
    ..aOS(6, _omitFieldNames ? '' : 'borderColor')
    ..aOS(7, _omitFieldNames ? '' : 'borderColorNight')
    ..aI(8, _omitFieldNames ? '' : 'bgStyle')
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
  $core.String get textColorNight => $_getSZ(2);
  @$pb.TagNumber(3)
  set textColorNight($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTextColorNight() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextColorNight() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get bgColor => $_getSZ(3);
  @$pb.TagNumber(4)
  set bgColor($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBgColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearBgColor() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get bgColorNight => $_getSZ(4);
  @$pb.TagNumber(5)
  set bgColorNight($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBgColorNight() => $_has(4);
  @$pb.TagNumber(5)
  void clearBgColorNight() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get borderColor => $_getSZ(5);
  @$pb.TagNumber(6)
  set borderColor($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBorderColor() => $_has(5);
  @$pb.TagNumber(6)
  void clearBorderColor() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get borderColorNight => $_getSZ(6);
  @$pb.TagNumber(7)
  set borderColorNight($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBorderColorNight() => $_has(6);
  @$pb.TagNumber(7)
  void clearBorderColorNight() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get bgStyle => $_getIZ(7);
  @$pb.TagNumber(8)
  set bgStyle($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBgStyle() => $_has(7);
  @$pb.TagNumber(8)
  void clearBgStyle() => $_clearField(8);
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
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
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

  /// 按钮展示文案
  ///
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

  /// UP 主关注用户
  ///
  /// - 0: 未被关注
  /// - 1: 已被关注
  @$pb.TagNumber(3)
  $core.int get isFollowed => $_getIZ(2);
  @$pb.TagNumber(3)
  set isFollowed($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsFollowed() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsFollowed() => $_clearField(3);
}

class ResultItem extends $pb.GeneratedMessage {
  factory ResultItem({
    $core.String? from,
    $core.String? title,
    $core.String? keyword,
    $core.int? position,
    $core.String? cover,
    $core.double? coverSize,
    $core.String? sugType,
    $core.int? termType,
    $core.String? goto,
    $core.String? uri,
    OfficialVerify? officialVerify,
    $core.String? param,
    $fixnum.Int64? mid,
    $core.int? fans,
    $core.int? level,
    $core.int? archives,
    $fixnum.Int64? ptime,
    $core.String? seasonTypeName,
    $core.String? area,
    $core.String? style,
    $core.String? label,
    $core.double? rating,
    $core.int? vote,
    $core.Iterable<ReasonStyle>? badges,
    $core.String? styles,
    $fixnum.Int64? moduleId,
    $core.String? liveLink,
    $core.int? faceNftNew,
    NftFaceIcon? nftFaceIcon,
    $core.int? isSeniorMember,
    $core.int? isSugStyleExp,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (title != null) result.title = title;
    if (keyword != null) result.keyword = keyword;
    if (position != null) result.position = position;
    if (cover != null) result.cover = cover;
    if (coverSize != null) result.coverSize = coverSize;
    if (sugType != null) result.sugType = sugType;
    if (termType != null) result.termType = termType;
    if (goto != null) result.goto = goto;
    if (uri != null) result.uri = uri;
    if (officialVerify != null) result.officialVerify = officialVerify;
    if (param != null) result.param = param;
    if (mid != null) result.mid = mid;
    if (fans != null) result.fans = fans;
    if (level != null) result.level = level;
    if (archives != null) result.archives = archives;
    if (ptime != null) result.ptime = ptime;
    if (seasonTypeName != null) result.seasonTypeName = seasonTypeName;
    if (area != null) result.area = area;
    if (style != null) result.style = style;
    if (label != null) result.label = label;
    if (rating != null) result.rating = rating;
    if (vote != null) result.vote = vote;
    if (badges != null) result.badges.addAll(badges);
    if (styles != null) result.styles = styles;
    if (moduleId != null) result.moduleId = moduleId;
    if (liveLink != null) result.liveLink = liveLink;
    if (faceNftNew != null) result.faceNftNew = faceNftNew;
    if (nftFaceIcon != null) result.nftFaceIcon = nftFaceIcon;
    if (isSeniorMember != null) result.isSeniorMember = isSeniorMember;
    if (isSugStyleExp != null) result.isSugStyleExp = isSugStyleExp;
    return result;
  }

  ResultItem._();

  factory ResultItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResultItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResultItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'from')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'keyword')
    ..aI(4, _omitFieldNames ? '' : 'position')
    ..aOS(5, _omitFieldNames ? '' : 'cover')
    ..aD(6, _omitFieldNames ? '' : 'coverSize')
    ..aOS(7, _omitFieldNames ? '' : 'sugType')
    ..aI(8, _omitFieldNames ? '' : 'termType')
    ..aOS(9, _omitFieldNames ? '' : 'goto')
    ..aOS(10, _omitFieldNames ? '' : 'uri')
    ..aOM<OfficialVerify>(11, _omitFieldNames ? '' : 'officialVerify',
        subBuilder: OfficialVerify.create)
    ..aOS(12, _omitFieldNames ? '' : 'param')
    ..aInt64(13, _omitFieldNames ? '' : 'mid')
    ..aI(14, _omitFieldNames ? '' : 'fans')
    ..aI(15, _omitFieldNames ? '' : 'level')
    ..aI(16, _omitFieldNames ? '' : 'archives')
    ..aInt64(17, _omitFieldNames ? '' : 'ptime')
    ..aOS(18, _omitFieldNames ? '' : 'seasonTypeName')
    ..aOS(19, _omitFieldNames ? '' : 'area')
    ..aOS(20, _omitFieldNames ? '' : 'style')
    ..aOS(21, _omitFieldNames ? '' : 'label')
    ..aD(22, _omitFieldNames ? '' : 'rating')
    ..aI(23, _omitFieldNames ? '' : 'vote')
    ..pPM<ReasonStyle>(24, _omitFieldNames ? '' : 'badges',
        subBuilder: ReasonStyle.create)
    ..aOS(25, _omitFieldNames ? '' : 'styles')
    ..aInt64(26, _omitFieldNames ? '' : 'moduleId')
    ..aOS(27, _omitFieldNames ? '' : 'liveLink')
    ..aI(28, _omitFieldNames ? '' : 'faceNftNew')
    ..aOM<NftFaceIcon>(29, _omitFieldNames ? '' : 'nftFaceIcon',
        subBuilder: NftFaceIcon.create)
    ..aI(30, _omitFieldNames ? '' : 'isSeniorMember')
    ..aI(31, _omitFieldNames ? '' : 'isSugStyleExp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResultItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResultItem copyWith(void Function(ResultItem) updates) =>
      super.copyWith((message) => updates(message as ResultItem)) as ResultItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResultItem create() => ResultItem._();
  @$core.override
  ResultItem createEmptyInstance() => create();
  static $pb.PbList<ResultItem> createRepeated() => $pb.PbList<ResultItem>();
  @$core.pragma('dart2js:noInline')
  static ResultItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResultItem>(create);
  static ResultItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get from => $_getSZ(0);
  @$pb.TagNumber(1)
  set from($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get keyword => $_getSZ(2);
  @$pb.TagNumber(3)
  set keyword($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasKeyword() => $_has(2);
  @$pb.TagNumber(3)
  void clearKeyword() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get position => $_getIZ(3);
  @$pb.TagNumber(4)
  set position($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPosition() => $_has(3);
  @$pb.TagNumber(4)
  void clearPosition() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get cover => $_getSZ(4);
  @$pb.TagNumber(5)
  set cover($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCover() => $_has(4);
  @$pb.TagNumber(5)
  void clearCover() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get coverSize => $_getN(5);
  @$pb.TagNumber(6)
  set coverSize($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCoverSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoverSize() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get sugType => $_getSZ(6);
  @$pb.TagNumber(7)
  set sugType($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSugType() => $_has(6);
  @$pb.TagNumber(7)
  void clearSugType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get termType => $_getIZ(7);
  @$pb.TagNumber(8)
  set termType($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTermType() => $_has(7);
  @$pb.TagNumber(8)
  void clearTermType() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get goto => $_getSZ(8);
  @$pb.TagNumber(9)
  set goto($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasGoto() => $_has(8);
  @$pb.TagNumber(9)
  void clearGoto() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get uri => $_getSZ(9);
  @$pb.TagNumber(10)
  set uri($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasUri() => $_has(9);
  @$pb.TagNumber(10)
  void clearUri() => $_clearField(10);

  @$pb.TagNumber(11)
  OfficialVerify get officialVerify => $_getN(10);
  @$pb.TagNumber(11)
  set officialVerify(OfficialVerify value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasOfficialVerify() => $_has(10);
  @$pb.TagNumber(11)
  void clearOfficialVerify() => $_clearField(11);
  @$pb.TagNumber(11)
  OfficialVerify ensureOfficialVerify() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get param => $_getSZ(11);
  @$pb.TagNumber(12)
  set param($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasParam() => $_has(11);
  @$pb.TagNumber(12)
  void clearParam() => $_clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get mid => $_getI64(12);
  @$pb.TagNumber(13)
  set mid($fixnum.Int64 value) => $_setInt64(12, value);
  @$pb.TagNumber(13)
  $core.bool hasMid() => $_has(12);
  @$pb.TagNumber(13)
  void clearMid() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get fans => $_getIZ(13);
  @$pb.TagNumber(14)
  set fans($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasFans() => $_has(13);
  @$pb.TagNumber(14)
  void clearFans() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get level => $_getIZ(14);
  @$pb.TagNumber(15)
  set level($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasLevel() => $_has(14);
  @$pb.TagNumber(15)
  void clearLevel() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.int get archives => $_getIZ(15);
  @$pb.TagNumber(16)
  set archives($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasArchives() => $_has(15);
  @$pb.TagNumber(16)
  void clearArchives() => $_clearField(16);

  @$pb.TagNumber(17)
  $fixnum.Int64 get ptime => $_getI64(16);
  @$pb.TagNumber(17)
  set ptime($fixnum.Int64 value) => $_setInt64(16, value);
  @$pb.TagNumber(17)
  $core.bool hasPtime() => $_has(16);
  @$pb.TagNumber(17)
  void clearPtime() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get seasonTypeName => $_getSZ(17);
  @$pb.TagNumber(18)
  set seasonTypeName($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasSeasonTypeName() => $_has(17);
  @$pb.TagNumber(18)
  void clearSeasonTypeName() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get area => $_getSZ(18);
  @$pb.TagNumber(19)
  set area($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasArea() => $_has(18);
  @$pb.TagNumber(19)
  void clearArea() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.String get style => $_getSZ(19);
  @$pb.TagNumber(20)
  set style($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasStyle() => $_has(19);
  @$pb.TagNumber(20)
  void clearStyle() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get label => $_getSZ(20);
  @$pb.TagNumber(21)
  set label($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasLabel() => $_has(20);
  @$pb.TagNumber(21)
  void clearLabel() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.double get rating => $_getN(21);
  @$pb.TagNumber(22)
  set rating($core.double value) => $_setDouble(21, value);
  @$pb.TagNumber(22)
  $core.bool hasRating() => $_has(21);
  @$pb.TagNumber(22)
  void clearRating() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.int get vote => $_getIZ(22);
  @$pb.TagNumber(23)
  set vote($core.int value) => $_setSignedInt32(22, value);
  @$pb.TagNumber(23)
  $core.bool hasVote() => $_has(22);
  @$pb.TagNumber(23)
  void clearVote() => $_clearField(23);

  @$pb.TagNumber(24)
  $pb.PbList<ReasonStyle> get badges => $_getList(23);

  @$pb.TagNumber(25)
  $core.String get styles => $_getSZ(24);
  @$pb.TagNumber(25)
  set styles($core.String value) => $_setString(24, value);
  @$pb.TagNumber(25)
  $core.bool hasStyles() => $_has(24);
  @$pb.TagNumber(25)
  void clearStyles() => $_clearField(25);

  @$pb.TagNumber(26)
  $fixnum.Int64 get moduleId => $_getI64(25);
  @$pb.TagNumber(26)
  set moduleId($fixnum.Int64 value) => $_setInt64(25, value);
  @$pb.TagNumber(26)
  $core.bool hasModuleId() => $_has(25);
  @$pb.TagNumber(26)
  void clearModuleId() => $_clearField(26);

  @$pb.TagNumber(27)
  $core.String get liveLink => $_getSZ(26);
  @$pb.TagNumber(27)
  set liveLink($core.String value) => $_setString(26, value);
  @$pb.TagNumber(27)
  $core.bool hasLiveLink() => $_has(26);
  @$pb.TagNumber(27)
  void clearLiveLink() => $_clearField(27);

  @$pb.TagNumber(28)
  $core.int get faceNftNew => $_getIZ(27);
  @$pb.TagNumber(28)
  set faceNftNew($core.int value) => $_setSignedInt32(27, value);
  @$pb.TagNumber(28)
  $core.bool hasFaceNftNew() => $_has(27);
  @$pb.TagNumber(28)
  void clearFaceNftNew() => $_clearField(28);

  @$pb.TagNumber(29)
  NftFaceIcon get nftFaceIcon => $_getN(28);
  @$pb.TagNumber(29)
  set nftFaceIcon(NftFaceIcon value) => $_setField(29, value);
  @$pb.TagNumber(29)
  $core.bool hasNftFaceIcon() => $_has(28);
  @$pb.TagNumber(29)
  void clearNftFaceIcon() => $_clearField(29);
  @$pb.TagNumber(29)
  NftFaceIcon ensureNftFaceIcon() => $_ensure(28);

  @$pb.TagNumber(30)
  $core.int get isSeniorMember => $_getIZ(29);
  @$pb.TagNumber(30)
  set isSeniorMember($core.int value) => $_setSignedInt32(29, value);
  @$pb.TagNumber(30)
  $core.bool hasIsSeniorMember() => $_has(29);
  @$pb.TagNumber(30)
  void clearIsSeniorMember() => $_clearField(30);

  @$pb.TagNumber(31)
  $core.int get isSugStyleExp => $_getIZ(30);
  @$pb.TagNumber(31)
  set isSugStyleExp($core.int value) => $_setSignedInt32(30, value);
  @$pb.TagNumber(31)
  $core.bool hasIsSugStyleExp() => $_has(30);
  @$pb.TagNumber(31)
  void clearIsSugStyleExp() => $_clearField(31);
}

class Scores extends $pb.GeneratedMessage {
  factory Scores({
    $core.double? score,
  }) {
    final result = create();
    if (score != null) result.score = score;
    return result;
  }

  Scores._();

  factory Scores.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Scores.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Scores',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'score', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Scores clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Scores copyWith(void Function(Scores) updates) =>
      super.copyWith((message) => updates(message as Scores)) as Scores;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Scores create() => Scores._();
  @$core.override
  Scores createEmptyInstance() => create();
  static $pb.PbList<Scores> createRepeated() => $pb.PbList<Scores>();
  @$core.pragma('dart2js:noInline')
  static Scores getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Scores>(create);
  static Scores? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get score => $_getN(0);
  @$pb.TagNumber(1)
  set score($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasScore() => $_has(0);
  @$pb.TagNumber(1)
  void clearScore() => $_clearField(1);
}

class SearchArchiveReply extends $pb.GeneratedMessage {
  factory SearchArchiveReply({
    $core.Iterable<Arc>? archives,
    $fixnum.Int64? total,
  }) {
    final result = create();
    if (archives != null) result.archives.addAll(archives);
    if (total != null) result.total = total;
    return result;
  }

  SearchArchiveReply._();

  factory SearchArchiveReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchArchiveReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchArchiveReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..pPM<Arc>(1, _omitFieldNames ? '' : 'archives', subBuilder: Arc.create)
    ..aInt64(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchArchiveReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchArchiveReply copyWith(void Function(SearchArchiveReply) updates) =>
      super.copyWith((message) => updates(message as SearchArchiveReply))
          as SearchArchiveReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchArchiveReply create() => SearchArchiveReply._();
  @$core.override
  SearchArchiveReply createEmptyInstance() => create();
  static $pb.PbList<SearchArchiveReply> createRepeated() =>
      $pb.PbList<SearchArchiveReply>();
  @$core.pragma('dart2js:noInline')
  static SearchArchiveReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchArchiveReply>(create);
  static SearchArchiveReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Arc> get archives => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class SearchArchiveReq extends $pb.GeneratedMessage {
  factory SearchArchiveReq({
    $core.String? keyword,
    $fixnum.Int64? mid,
    $fixnum.Int64? pn,
    $fixnum.Int64? ps,
    $3.PlayerArgs? playerArgs,
  }) {
    final result = create();
    if (keyword != null) result.keyword = keyword;
    if (mid != null) result.mid = mid;
    if (pn != null) result.pn = pn;
    if (ps != null) result.ps = ps;
    if (playerArgs != null) result.playerArgs = playerArgs;
    return result;
  }

  SearchArchiveReq._();

  factory SearchArchiveReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchArchiveReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchArchiveReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..aInt64(2, _omitFieldNames ? '' : 'mid')
    ..aInt64(3, _omitFieldNames ? '' : 'pn')
    ..aInt64(4, _omitFieldNames ? '' : 'ps')
    ..aOM<$3.PlayerArgs>(5, _omitFieldNames ? '' : 'playerArgs',
        subBuilder: $3.PlayerArgs.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchArchiveReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchArchiveReq copyWith(void Function(SearchArchiveReq) updates) =>
      super.copyWith((message) => updates(message as SearchArchiveReq))
          as SearchArchiveReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchArchiveReq create() => SearchArchiveReq._();
  @$core.override
  SearchArchiveReq createEmptyInstance() => create();
  static $pb.PbList<SearchArchiveReq> createRepeated() =>
      $pb.PbList<SearchArchiveReq>();
  @$core.pragma('dart2js:noInline')
  static SearchArchiveReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchArchiveReq>(create);
  static SearchArchiveReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get mid => $_getI64(1);
  @$pb.TagNumber(2)
  set mid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMid() => $_has(1);
  @$pb.TagNumber(2)
  void clearMid() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get pn => $_getI64(2);
  @$pb.TagNumber(3)
  set pn($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPn() => $_has(2);
  @$pb.TagNumber(3)
  void clearPn() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get ps => $_getI64(3);
  @$pb.TagNumber(4)
  set ps($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPs() => $_has(3);
  @$pb.TagNumber(4)
  void clearPs() => $_clearField(4);

  @$pb.TagNumber(5)
  $3.PlayerArgs get playerArgs => $_getN(4);
  @$pb.TagNumber(5)
  set playerArgs($3.PlayerArgs value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPlayerArgs() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlayerArgs() => $_clearField(5);
  @$pb.TagNumber(5)
  $3.PlayerArgs ensurePlayerArgs() => $_ensure(4);
}

class SearchDynamicReply extends $pb.GeneratedMessage {
  factory SearchDynamicReply({
    $core.Iterable<Dynamic>? dynamics,
    $fixnum.Int64? total,
  }) {
    final result = create();
    if (dynamics != null) result.dynamics.addAll(dynamics);
    if (total != null) result.total = total;
    return result;
  }

  SearchDynamicReply._();

  factory SearchDynamicReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchDynamicReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchDynamicReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..pPM<Dynamic>(1, _omitFieldNames ? '' : 'dynamics',
        subBuilder: Dynamic.create)
    ..aInt64(2, _omitFieldNames ? '' : 'total')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchDynamicReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchDynamicReply copyWith(void Function(SearchDynamicReply) updates) =>
      super.copyWith((message) => updates(message as SearchDynamicReply))
          as SearchDynamicReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchDynamicReply create() => SearchDynamicReply._();
  @$core.override
  SearchDynamicReply createEmptyInstance() => create();
  static $pb.PbList<SearchDynamicReply> createRepeated() =>
      $pb.PbList<SearchDynamicReply>();
  @$core.pragma('dart2js:noInline')
  static SearchDynamicReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchDynamicReply>(create);
  static SearchDynamicReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Dynamic> get dynamics => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);
}

class SearchDynamicReq extends $pb.GeneratedMessage {
  factory SearchDynamicReq({
    $core.String? keyword,
    $fixnum.Int64? mid,
    $fixnum.Int64? pn,
    $fixnum.Int64? ps,
    $3.PlayerArgs? playerArgs,
  }) {
    final result = create();
    if (keyword != null) result.keyword = keyword;
    if (mid != null) result.mid = mid;
    if (pn != null) result.pn = pn;
    if (ps != null) result.ps = ps;
    if (playerArgs != null) result.playerArgs = playerArgs;
    return result;
  }

  SearchDynamicReq._();

  factory SearchDynamicReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchDynamicReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchDynamicReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..aInt64(2, _omitFieldNames ? '' : 'mid')
    ..aInt64(3, _omitFieldNames ? '' : 'pn')
    ..aInt64(4, _omitFieldNames ? '' : 'ps')
    ..aOM<$3.PlayerArgs>(5, _omitFieldNames ? '' : 'playerArgs',
        subBuilder: $3.PlayerArgs.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchDynamicReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchDynamicReq copyWith(void Function(SearchDynamicReq) updates) =>
      super.copyWith((message) => updates(message as SearchDynamicReq))
          as SearchDynamicReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchDynamicReq create() => SearchDynamicReq._();
  @$core.override
  SearchDynamicReq createEmptyInstance() => create();
  static $pb.PbList<SearchDynamicReq> createRepeated() =>
      $pb.PbList<SearchDynamicReq>();
  @$core.pragma('dart2js:noInline')
  static SearchDynamicReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchDynamicReq>(create);
  static SearchDynamicReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get mid => $_getI64(1);
  @$pb.TagNumber(2)
  set mid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMid() => $_has(1);
  @$pb.TagNumber(2)
  void clearMid() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get pn => $_getI64(2);
  @$pb.TagNumber(3)
  set pn($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPn() => $_has(2);
  @$pb.TagNumber(3)
  void clearPn() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get ps => $_getI64(3);
  @$pb.TagNumber(4)
  set ps($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPs() => $_has(3);
  @$pb.TagNumber(4)
  void clearPs() => $_clearField(4);

  @$pb.TagNumber(5)
  $3.PlayerArgs get playerArgs => $_getN(4);
  @$pb.TagNumber(5)
  set playerArgs($3.PlayerArgs value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPlayerArgs() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlayerArgs() => $_clearField(5);
  @$pb.TagNumber(5)
  $3.PlayerArgs ensurePlayerArgs() => $_ensure(4);
}

class SearchReply extends $pb.GeneratedMessage {
  factory SearchReply({
    $core.Iterable<CursorItem>? items,
    $core.bool? hasMore,
    Page? page,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (hasMore != null) result.hasMore = hasMore;
    if (page != null) result.page = page;
    return result;
  }

  SearchReply._();

  factory SearchReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..pPM<CursorItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: CursorItem.create)
    ..aOB(2, _omitFieldNames ? '' : 'hasMore')
    ..aOM<Page>(3, _omitFieldNames ? '' : 'page', subBuilder: Page.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchReply copyWith(void Function(SearchReply) updates) =>
      super.copyWith((message) => updates(message as SearchReply))
          as SearchReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchReply create() => SearchReply._();
  @$core.override
  SearchReply createEmptyInstance() => create();
  static $pb.PbList<SearchReply> createRepeated() => $pb.PbList<SearchReply>();
  @$core.pragma('dart2js:noInline')
  static SearchReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchReply>(create);
  static SearchReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CursorItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get hasMore => $_getBF(1);
  @$pb.TagNumber(2)
  set hasMore($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHasMore() => $_has(1);
  @$pb.TagNumber(2)
  void clearHasMore() => $_clearField(2);

  @$pb.TagNumber(3)
  Page get page => $_getN(2);
  @$pb.TagNumber(3)
  set page(Page value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPage() => $_has(2);
  @$pb.TagNumber(3)
  void clearPage() => $_clearField(3);
  @$pb.TagNumber(3)
  Page ensurePage() => $_ensure(2);
}

class SearchReq extends $pb.GeneratedMessage {
  factory SearchReq({
    $core.String? keyword,
    $fixnum.Int64? pn,
    $core.String? business,
  }) {
    final result = create();
    if (keyword != null) result.keyword = keyword;
    if (pn != null) result.pn = pn;
    if (business != null) result.business = business;
    return result;
  }

  SearchReq._();

  factory SearchReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..aInt64(2, _omitFieldNames ? '' : 'pn')
    ..aOS(3, _omitFieldNames ? '' : 'business')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchReq copyWith(void Function(SearchReq) updates) =>
      super.copyWith((message) => updates(message as SearchReq)) as SearchReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchReq create() => SearchReq._();
  @$core.override
  SearchReq createEmptyInstance() => create();
  static $pb.PbList<SearchReq> createRepeated() => $pb.PbList<SearchReq>();
  @$core.pragma('dart2js:noInline')
  static SearchReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchReq>(create);
  static SearchReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get pn => $_getI64(1);
  @$pb.TagNumber(2)
  set pn($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPn() => $_has(1);
  @$pb.TagNumber(2)
  void clearPn() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get business => $_getSZ(2);
  @$pb.TagNumber(3)
  set business($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBusiness() => $_has(2);
  @$pb.TagNumber(3)
  void clearBusiness() => $_clearField(3);
}

class SearchTabReply extends $pb.GeneratedMessage {
  factory SearchTabReply({
    $fixnum.Int64? focus,
    $core.Iterable<Tab>? tabs,
  }) {
    final result = create();
    if (focus != null) result.focus = focus;
    if (tabs != null) result.tabs.addAll(tabs);
    return result;
  }

  SearchTabReply._();

  factory SearchTabReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchTabReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchTabReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'focus')
    ..pPM<Tab>(2, _omitFieldNames ? '' : 'tabs', subBuilder: Tab.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchTabReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchTabReply copyWith(void Function(SearchTabReply) updates) =>
      super.copyWith((message) => updates(message as SearchTabReply))
          as SearchTabReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchTabReply create() => SearchTabReply._();
  @$core.override
  SearchTabReply createEmptyInstance() => create();
  static $pb.PbList<SearchTabReply> createRepeated() =>
      $pb.PbList<SearchTabReply>();
  @$core.pragma('dart2js:noInline')
  static SearchTabReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchTabReply>(create);
  static SearchTabReply? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get focus => $_getI64(0);
  @$pb.TagNumber(1)
  set focus($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFocus() => $_has(0);
  @$pb.TagNumber(1)
  void clearFocus() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Tab> get tabs => $_getList(1);
}

class SearchTabReq extends $pb.GeneratedMessage {
  factory SearchTabReq({
    $core.String? keyword,
    $fixnum.Int64? mid,
    From? from,
  }) {
    final result = create();
    if (keyword != null) result.keyword = keyword;
    if (mid != null) result.mid = mid;
    if (from != null) result.from = from;
    return result;
  }

  SearchTabReq._();

  factory SearchTabReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchTabReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchTabReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..aInt64(2, _omitFieldNames ? '' : 'mid')
    ..aE<From>(3, _omitFieldNames ? '' : 'from', enumValues: From.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchTabReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchTabReq copyWith(void Function(SearchTabReq) updates) =>
      super.copyWith((message) => updates(message as SearchTabReq))
          as SearchTabReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchTabReq create() => SearchTabReq._();
  @$core.override
  SearchTabReq createEmptyInstance() => create();
  static $pb.PbList<SearchTabReq> createRepeated() =>
      $pb.PbList<SearchTabReq>();
  @$core.pragma('dart2js:noInline')
  static SearchTabReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchTabReq>(create);
  static SearchTabReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get mid => $_getI64(1);
  @$pb.TagNumber(2)
  set mid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMid() => $_has(1);
  @$pb.TagNumber(2)
  void clearMid() => $_clearField(2);

  @$pb.TagNumber(3)
  From get from => $_getN(2);
  @$pb.TagNumber(3)
  set from(From value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFrom() => $_has(2);
  @$pb.TagNumber(3)
  void clearFrom() => $_clearField(3);
}

class SetTeenagersModelAgeReply extends $pb.GeneratedMessage {
  factory SetTeenagersModelAgeReply() => create();

  SetTeenagersModelAgeReply._();

  factory SetTeenagersModelAgeReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetTeenagersModelAgeReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetTeenagersModelAgeReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTeenagersModelAgeReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTeenagersModelAgeReply copyWith(
          void Function(SetTeenagersModelAgeReply) updates) =>
      super.copyWith((message) => updates(message as SetTeenagersModelAgeReply))
          as SetTeenagersModelAgeReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetTeenagersModelAgeReply create() => SetTeenagersModelAgeReply._();
  @$core.override
  SetTeenagersModelAgeReply createEmptyInstance() => create();
  static $pb.PbList<SetTeenagersModelAgeReply> createRepeated() =>
      $pb.PbList<SetTeenagersModelAgeReply>();
  @$core.pragma('dart2js:noInline')
  static SetTeenagersModelAgeReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetTeenagersModelAgeReply>(create);
  static SetTeenagersModelAgeReply? _defaultInstance;
}

class SetTeenagersModelAgeReq extends $pb.GeneratedMessage {
  factory SetTeenagersModelAgeReq({
    $core.String? pwd,
    PwdFrom? pwdFrom,
    $core.String? deviceToken,
    $core.int? age,
    $core.bool? isDynamic,
  }) {
    final result = create();
    if (pwd != null) result.pwd = pwd;
    if (pwdFrom != null) result.pwdFrom = pwdFrom;
    if (deviceToken != null) result.deviceToken = deviceToken;
    if (age != null) result.age = age;
    if (isDynamic != null) result.isDynamic = isDynamic;
    return result;
  }

  SetTeenagersModelAgeReq._();

  factory SetTeenagersModelAgeReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetTeenagersModelAgeReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetTeenagersModelAgeReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'pwd')
    ..aE<PwdFrom>(2, _omitFieldNames ? '' : 'pwdFrom',
        enumValues: PwdFrom.values)
    ..aOS(3, _omitFieldNames ? '' : 'deviceToken')
    ..aI(4, _omitFieldNames ? '' : 'age')
    ..aOB(5, _omitFieldNames ? '' : 'isDynamic')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTeenagersModelAgeReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTeenagersModelAgeReq copyWith(
          void Function(SetTeenagersModelAgeReq) updates) =>
      super.copyWith((message) => updates(message as SetTeenagersModelAgeReq))
          as SetTeenagersModelAgeReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetTeenagersModelAgeReq create() => SetTeenagersModelAgeReq._();
  @$core.override
  SetTeenagersModelAgeReq createEmptyInstance() => create();
  static $pb.PbList<SetTeenagersModelAgeReq> createRepeated() =>
      $pb.PbList<SetTeenagersModelAgeReq>();
  @$core.pragma('dart2js:noInline')
  static SetTeenagersModelAgeReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetTeenagersModelAgeReq>(create);
  static SetTeenagersModelAgeReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pwd => $_getSZ(0);
  @$pb.TagNumber(1)
  set pwd($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPwd() => $_has(0);
  @$pb.TagNumber(1)
  void clearPwd() => $_clearField(1);

  @$pb.TagNumber(2)
  PwdFrom get pwdFrom => $_getN(1);
  @$pb.TagNumber(2)
  set pwdFrom(PwdFrom value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPwdFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearPwdFrom() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get deviceToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set deviceToken($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeviceToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeviceToken() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get age => $_getIZ(3);
  @$pb.TagNumber(4)
  set age($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAge() => $_has(3);
  @$pb.TagNumber(4)
  void clearAge() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isDynamic => $_getBF(4);
  @$pb.TagNumber(5)
  set isDynamic($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsDynamic() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsDynamic() => $_clearField(5);
}

class ShowTab extends $pb.GeneratedMessage {
  factory ShowTab({
    TabType? tabType,
    $core.String? title,
    $core.String? url,
  }) {
    final result = create();
    if (tabType != null) result.tabType = tabType;
    if (title != null) result.title = title;
    if (url != null) result.url = url;
    return result;
  }

  ShowTab._();

  factory ShowTab.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShowTab.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShowTab',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aE<TabType>(1, _omitFieldNames ? '' : 'tabType',
        enumValues: TabType.values)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShowTab clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShowTab copyWith(void Function(ShowTab) updates) =>
      super.copyWith((message) => updates(message as ShowTab)) as ShowTab;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShowTab create() => ShowTab._();
  @$core.override
  ShowTab createEmptyInstance() => create();
  static $pb.PbList<ShowTab> createRepeated() => $pb.PbList<ShowTab>();
  @$core.pragma('dart2js:noInline')
  static ShowTab getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ShowTab>(create);
  static ShowTab? _defaultInstance;

  @$pb.TagNumber(1)
  TabType get tabType => $_getN(0);
  @$pb.TagNumber(1)
  set tabType(TabType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTabType() => $_has(0);
  @$pb.TagNumber(1)
  void clearTabType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get url => $_getSZ(2);
  @$pb.TagNumber(3)
  set url($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearUrl() => $_clearField(3);
}

class SmallItem extends $pb.GeneratedMessage {
  factory SmallItem({
    $core.String? title,
    $core.String? coverImageUri,
    $core.String? uri,
    $core.String? coverRightText,
    $core.String? coverLeftText1,
    $fixnum.Int64? coverLeftIcon1,
    $core.String? coverLeftText2,
    $fixnum.Int64? coverLeftIcon2,
    $fixnum.Int64? param,
    $fixnum.Int64? mid,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (coverImageUri != null) result.coverImageUri = coverImageUri;
    if (uri != null) result.uri = uri;
    if (coverRightText != null) result.coverRightText = coverRightText;
    if (coverLeftText1 != null) result.coverLeftText1 = coverLeftText1;
    if (coverLeftIcon1 != null) result.coverLeftIcon1 = coverLeftIcon1;
    if (coverLeftText2 != null) result.coverLeftText2 = coverLeftText2;
    if (coverLeftIcon2 != null) result.coverLeftIcon2 = coverLeftIcon2;
    if (param != null) result.param = param;
    if (mid != null) result.mid = mid;
    return result;
  }

  SmallItem._();

  factory SmallItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SmallItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SmallItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'coverImageUri')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..aOS(4, _omitFieldNames ? '' : 'coverRightText')
    ..aOS(5, _omitFieldNames ? '' : 'coverLeftText1')
    ..aInt64(6, _omitFieldNames ? '' : 'coverLeftIcon1')
    ..aOS(7, _omitFieldNames ? '' : 'coverLeftText2')
    ..aInt64(8, _omitFieldNames ? '' : 'coverLeftIcon2')
    ..aInt64(9, _omitFieldNames ? '' : 'param')
    ..aInt64(10, _omitFieldNames ? '' : 'mid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SmallItem copyWith(void Function(SmallItem) updates) =>
      super.copyWith((message) => updates(message as SmallItem)) as SmallItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SmallItem create() => SmallItem._();
  @$core.override
  SmallItem createEmptyInstance() => create();
  static $pb.PbList<SmallItem> createRepeated() => $pb.PbList<SmallItem>();
  @$core.pragma('dart2js:noInline')
  static SmallItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SmallItem>(create);
  static SmallItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get coverImageUri => $_getSZ(1);
  @$pb.TagNumber(2)
  set coverImageUri($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCoverImageUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoverImageUri() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get coverRightText => $_getSZ(3);
  @$pb.TagNumber(4)
  set coverRightText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverRightText() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverRightText() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get coverLeftText1 => $_getSZ(4);
  @$pb.TagNumber(5)
  set coverLeftText1($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCoverLeftText1() => $_has(4);
  @$pb.TagNumber(5)
  void clearCoverLeftText1() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get coverLeftIcon1 => $_getI64(5);
  @$pb.TagNumber(6)
  set coverLeftIcon1($fixnum.Int64 value) => $_setInt64(5, value);
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
  $fixnum.Int64 get coverLeftIcon2 => $_getI64(7);
  @$pb.TagNumber(8)
  set coverLeftIcon2($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCoverLeftIcon2() => $_has(7);
  @$pb.TagNumber(8)
  void clearCoverLeftIcon2() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get param => $_getI64(8);
  @$pb.TagNumber(9)
  set param($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasParam() => $_has(8);
  @$pb.TagNumber(9)
  void clearParam() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get mid => $_getI64(9);
  @$pb.TagNumber(10)
  set mid($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMid() => $_has(9);
  @$pb.TagNumber(10)
  void clearMid() => $_clearField(10);
}

class Staff extends $pb.GeneratedMessage {
  factory Staff({
    $core.String? title,
    $core.String? text,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (text != null) result.text = text;
    return result;
  }

  Staff._();

  factory Staff.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Staff.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Staff',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Staff clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Staff copyWith(void Function(Staff) updates) =>
      super.copyWith((message) => updates(message as Staff)) as Staff;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Staff create() => Staff._();
  @$core.override
  Staff createEmptyInstance() => create();
  static $pb.PbList<Staff> createRepeated() => $pb.PbList<Staff>();
  @$core.pragma('dart2js:noInline')
  static Staff getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Staff>(create);
  static Staff? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);
}

class SuggestionResult3Reply extends $pb.GeneratedMessage {
  factory SuggestionResult3Reply({
    $core.String? trackid,
    $core.Iterable<ResultItem>? list,
    $core.String? expStr,
  }) {
    final result = create();
    if (trackid != null) result.trackid = trackid;
    if (list != null) result.list.addAll(list);
    if (expStr != null) result.expStr = expStr;
    return result;
  }

  SuggestionResult3Reply._();

  factory SuggestionResult3Reply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SuggestionResult3Reply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SuggestionResult3Reply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trackid')
    ..pPM<ResultItem>(2, _omitFieldNames ? '' : 'list',
        subBuilder: ResultItem.create)
    ..aOS(3, _omitFieldNames ? '' : 'expStr')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestionResult3Reply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestionResult3Reply copyWith(
          void Function(SuggestionResult3Reply) updates) =>
      super.copyWith((message) => updates(message as SuggestionResult3Reply))
          as SuggestionResult3Reply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SuggestionResult3Reply create() => SuggestionResult3Reply._();
  @$core.override
  SuggestionResult3Reply createEmptyInstance() => create();
  static $pb.PbList<SuggestionResult3Reply> createRepeated() =>
      $pb.PbList<SuggestionResult3Reply>();
  @$core.pragma('dart2js:noInline')
  static SuggestionResult3Reply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SuggestionResult3Reply>(create);
  static SuggestionResult3Reply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trackid => $_getSZ(0);
  @$pb.TagNumber(1)
  set trackid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrackid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrackid() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ResultItem> get list => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get expStr => $_getSZ(2);
  @$pb.TagNumber(3)
  set expStr($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpStr() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpStr() => $_clearField(3);
}

class SuggestionResult3Req extends $pb.GeneratedMessage {
  factory SuggestionResult3Req({
    $core.String? keyword,
    $core.int? highlight,
    $core.int? teenagersMode,
    $core.String? userAct,
  }) {
    final result = create();
    if (keyword != null) result.keyword = keyword;
    if (highlight != null) result.highlight = highlight;
    if (teenagersMode != null) result.teenagersMode = teenagersMode;
    if (userAct != null) result.userAct = userAct;
    return result;
  }

  SuggestionResult3Req._();

  factory SuggestionResult3Req.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SuggestionResult3Req.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SuggestionResult3Req',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..aI(2, _omitFieldNames ? '' : 'highlight')
    ..aI(3, _omitFieldNames ? '' : 'teenagersMode')
    ..aOS(4, _omitFieldNames ? '' : 'userAct')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestionResult3Req clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestionResult3Req copyWith(void Function(SuggestionResult3Req) updates) =>
      super.copyWith((message) => updates(message as SuggestionResult3Req))
          as SuggestionResult3Req;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SuggestionResult3Req create() => SuggestionResult3Req._();
  @$core.override
  SuggestionResult3Req createEmptyInstance() => create();
  static $pb.PbList<SuggestionResult3Req> createRepeated() =>
      $pb.PbList<SuggestionResult3Req>();
  @$core.pragma('dart2js:noInline')
  static SuggestionResult3Req getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SuggestionResult3Req>(create);
  static SuggestionResult3Req? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get highlight => $_getIZ(1);
  @$pb.TagNumber(2)
  set highlight($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHighlight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHighlight() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get teenagersMode => $_getIZ(2);
  @$pb.TagNumber(3)
  set teenagersMode($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTeenagersMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearTeenagersMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get userAct => $_getSZ(3);
  @$pb.TagNumber(4)
  set userAct($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUserAct() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserAct() => $_clearField(4);
}

class Supernatant extends $pb.GeneratedMessage {
  factory Supernatant({
    $core.String? title,
    $core.Iterable<CommentItem>? item,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (item != null) result.item.addAll(item);
    return result;
  }

  Supernatant._();

  factory Supernatant.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Supernatant.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Supernatant',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..pPM<CommentItem>(2, _omitFieldNames ? '' : 'item',
        subBuilder: CommentItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Supernatant clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Supernatant copyWith(void Function(Supernatant) updates) =>
      super.copyWith((message) => updates(message as Supernatant))
          as Supernatant;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Supernatant create() => Supernatant._();
  @$core.override
  Supernatant createEmptyInstance() => create();
  static $pb.PbList<Supernatant> createRepeated() => $pb.PbList<Supernatant>();
  @$core.pragma('dart2js:noInline')
  static Supernatant getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Supernatant>(create);
  static Supernatant? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<CommentItem> get item => $_getList(1);
}

class Tab extends $pb.GeneratedMessage {
  factory Tab({
    $core.String? title,
    $core.String? uri,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (uri != null) result.uri = uri;
    return result;
  }

  Tab._();

  factory Tab.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Tab.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Tab',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'uri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tab clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tab copyWith(void Function(Tab) updates) =>
      super.copyWith((message) => updates(message as Tab)) as Tab;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Tab create() => Tab._();
  @$core.override
  Tab createEmptyInstance() => create();
  static $pb.PbList<Tab> createRepeated() => $pb.PbList<Tab>();
  @$core.pragma('dart2js:noInline')
  static Tab getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Tab>(create);
  static Tab? _defaultInstance;

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
}

class UpdateReserveStartTimeReply extends $pb.GeneratedMessage {
  factory UpdateReserveStartTimeReply({
    $core.String? descText,
  }) {
    final result = create();
    if (descText != null) result.descText = descText;
    return result;
  }

  UpdateReserveStartTimeReply._();

  factory UpdateReserveStartTimeReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateReserveStartTimeReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateReserveStartTimeReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'descText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateReserveStartTimeReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateReserveStartTimeReply copyWith(
          void Function(UpdateReserveStartTimeReply) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateReserveStartTimeReply))
          as UpdateReserveStartTimeReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateReserveStartTimeReply create() =>
      UpdateReserveStartTimeReply._();
  @$core.override
  UpdateReserveStartTimeReply createEmptyInstance() => create();
  static $pb.PbList<UpdateReserveStartTimeReply> createRepeated() =>
      $pb.PbList<UpdateReserveStartTimeReply>();
  @$core.pragma('dart2js:noInline')
  static UpdateReserveStartTimeReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateReserveStartTimeReply>(create);
  static UpdateReserveStartTimeReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get descText => $_getSZ(0);
  @$pb.TagNumber(1)
  set descText($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDescText() => $_has(0);
  @$pb.TagNumber(1)
  void clearDescText() => $_clearField(1);
}

class UpdateReserveStartTimeReq extends $pb.GeneratedMessage {
  factory UpdateReserveStartTimeReq({
    $fixnum.Int64? sid,
    $fixnum.Int64? newLivePlanStartTime,
  }) {
    final result = create();
    if (sid != null) result.sid = sid;
    if (newLivePlanStartTime != null)
      result.newLivePlanStartTime = newLivePlanStartTime;
    return result;
  }

  UpdateReserveStartTimeReq._();

  factory UpdateReserveStartTimeReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateReserveStartTimeReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateReserveStartTimeReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'sid')
    ..aInt64(2, _omitFieldNames ? '' : 'newLivePlanStartTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateReserveStartTimeReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateReserveStartTimeReq copyWith(
          void Function(UpdateReserveStartTimeReq) updates) =>
      super.copyWith((message) => updates(message as UpdateReserveStartTimeReq))
          as UpdateReserveStartTimeReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateReserveStartTimeReq create() => UpdateReserveStartTimeReq._();
  @$core.override
  UpdateReserveStartTimeReq createEmptyInstance() => create();
  static $pb.PbList<UpdateReserveStartTimeReq> createRepeated() =>
      $pb.PbList<UpdateReserveStartTimeReq>();
  @$core.pragma('dart2js:noInline')
  static UpdateReserveStartTimeReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateReserveStartTimeReq>(create);
  static UpdateReserveStartTimeReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get sid => $_getI64(0);
  @$pb.TagNumber(1)
  set sid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get newLivePlanStartTime => $_getI64(1);
  @$pb.TagNumber(2)
  set newLivePlanStartTime($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNewLivePlanStartTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewLivePlanStartTime() => $_clearField(2);
}

class UpdateStatusReply extends $pb.GeneratedMessage {
  factory UpdateStatusReply() => create();

  UpdateStatusReply._();

  factory UpdateStatusReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateStatusReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateStatusReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateStatusReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateStatusReply copyWith(void Function(UpdateStatusReply) updates) =>
      super.copyWith((message) => updates(message as UpdateStatusReply))
          as UpdateStatusReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateStatusReply create() => UpdateStatusReply._();
  @$core.override
  UpdateStatusReply createEmptyInstance() => create();
  static $pb.PbList<UpdateStatusReply> createRepeated() =>
      $pb.PbList<UpdateStatusReply>();
  @$core.pragma('dart2js:noInline')
  static UpdateStatusReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateStatusReply>(create);
  static UpdateStatusReply? _defaultInstance;
}

class UpdateStatusReq extends $pb.GeneratedMessage {
  factory UpdateStatusReq({
    $core.String? pwd,
    $core.bool? switch_2,
    PwdFrom? pwdFrom,
    $core.String? deviceToken,
  }) {
    final result = create();
    if (pwd != null) result.pwd = pwd;
    if (switch_2 != null) result.switch_2 = switch_2;
    if (pwdFrom != null) result.pwdFrom = pwdFrom;
    if (deviceToken != null) result.deviceToken = deviceToken;
    return result;
  }

  UpdateStatusReq._();

  factory UpdateStatusReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateStatusReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateStatusReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'pwd')
    ..aOB(2, _omitFieldNames ? '' : 'switch')
    ..aE<PwdFrom>(3, _omitFieldNames ? '' : 'pwdFrom',
        enumValues: PwdFrom.values)
    ..aOS(4, _omitFieldNames ? '' : 'deviceToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateStatusReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateStatusReq copyWith(void Function(UpdateStatusReq) updates) =>
      super.copyWith((message) => updates(message as UpdateStatusReq))
          as UpdateStatusReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateStatusReq create() => UpdateStatusReq._();
  @$core.override
  UpdateStatusReq createEmptyInstance() => create();
  static $pb.PbList<UpdateStatusReq> createRepeated() =>
      $pb.PbList<UpdateStatusReq>();
  @$core.pragma('dart2js:noInline')
  static UpdateStatusReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateStatusReq>(create);
  static UpdateStatusReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pwd => $_getSZ(0);
  @$pb.TagNumber(1)
  set pwd($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPwd() => $_has(0);
  @$pb.TagNumber(1)
  void clearPwd() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get switch_2 => $_getBF(1);
  @$pb.TagNumber(2)
  set switch_2($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSwitch_2() => $_has(1);
  @$pb.TagNumber(2)
  void clearSwitch_2() => $_clearField(2);

  @$pb.TagNumber(3)
  PwdFrom get pwdFrom => $_getN(2);
  @$pb.TagNumber(3)
  set pwdFrom(PwdFrom value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPwdFrom() => $_has(2);
  @$pb.TagNumber(3)
  void clearPwdFrom() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get deviceToken => $_getSZ(3);
  @$pb.TagNumber(4)
  set deviceToken($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDeviceToken() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeviceToken() => $_clearField(4);
}

class UserCard extends $pb.GeneratedMessage {
  factory UserCard({
    $core.String? userName,
    $core.String? userFace,
    $core.String? userUrl,
    $fixnum.Int64? mid,
  }) {
    final result = create();
    if (userName != null) result.userName = userName;
    if (userFace != null) result.userFace = userFace;
    if (userUrl != null) result.userUrl = userUrl;
    if (mid != null) result.mid = mid;
    return result;
  }

  UserCard._();

  factory UserCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userName')
    ..aOS(2, _omitFieldNames ? '' : 'userFace')
    ..aOS(3, _omitFieldNames ? '' : 'userUrl')
    ..aInt64(4, _omitFieldNames ? '' : 'mid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCard copyWith(void Function(UserCard) updates) =>
      super.copyWith((message) => updates(message as UserCard)) as UserCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserCard create() => UserCard._();
  @$core.override
  UserCard createEmptyInstance() => create();
  static $pb.PbList<UserCard> createRepeated() => $pb.PbList<UserCard>();
  @$core.pragma('dart2js:noInline')
  static UserCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserCard>(create);
  static UserCard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userName => $_getSZ(0);
  @$pb.TagNumber(1)
  set userName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserName() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userFace => $_getSZ(1);
  @$pb.TagNumber(2)
  set userFace($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserFace() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserFace() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get userUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set userUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUserUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get mid => $_getI64(3);
  @$pb.TagNumber(4)
  set mid($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMid() => $_has(3);
  @$pb.TagNumber(4)
  void clearMid() => $_clearField(4);
}

class UserModel extends $pb.GeneratedMessage {
  factory UserModel({
    $fixnum.Int64? mid,
    $core.String? mode,
    $core.String? wsxcde,
    ModelStatus? status,
    Policy? policy,
    $core.bool? isForced,
    $core.bool? mustTeen,
    $core.bool? mustRealName,
    $core.bool? isParentControl,
    $core.int? age,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    if (mode != null) result.mode = mode;
    if (wsxcde != null) result.wsxcde = wsxcde;
    if (status != null) result.status = status;
    if (policy != null) result.policy = policy;
    if (isForced != null) result.isForced = isForced;
    if (mustTeen != null) result.mustTeen = mustTeen;
    if (mustRealName != null) result.mustRealName = mustRealName;
    if (isParentControl != null) result.isParentControl = isParentControl;
    if (age != null) result.age = age;
    return result;
  }

  UserModel._();

  factory UserModel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserModel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserModel',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'mode')
    ..aOS(3, _omitFieldNames ? '' : 'wsxcde')
    ..aE<ModelStatus>(4, _omitFieldNames ? '' : 'status',
        enumValues: ModelStatus.values)
    ..aOM<Policy>(5, _omitFieldNames ? '' : 'policy', subBuilder: Policy.create)
    ..aOB(6, _omitFieldNames ? '' : 'isForced')
    ..aOB(7, _omitFieldNames ? '' : 'mustTeen')
    ..aOB(8, _omitFieldNames ? '' : 'mustRealName')
    ..aOB(9, _omitFieldNames ? '' : 'isParentControl')
    ..aI(10, _omitFieldNames ? '' : 'age')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserModel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserModel copyWith(void Function(UserModel) updates) =>
      super.copyWith((message) => updates(message as UserModel)) as UserModel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserModel create() => UserModel._();
  @$core.override
  UserModel createEmptyInstance() => create();
  static $pb.PbList<UserModel> createRepeated() => $pb.PbList<UserModel>();
  @$core.pragma('dart2js:noInline')
  static UserModel getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserModel>(create);
  static UserModel? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get mid => $_getI64(0);
  @$pb.TagNumber(1)
  set mid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearMid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mode => $_getSZ(1);
  @$pb.TagNumber(2)
  set mode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearMode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get wsxcde => $_getSZ(2);
  @$pb.TagNumber(3)
  set wsxcde($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWsxcde() => $_has(2);
  @$pb.TagNumber(3)
  void clearWsxcde() => $_clearField(3);

  @$pb.TagNumber(4)
  ModelStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(ModelStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  Policy get policy => $_getN(4);
  @$pb.TagNumber(5)
  set policy(Policy value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPolicy() => $_has(4);
  @$pb.TagNumber(5)
  void clearPolicy() => $_clearField(5);
  @$pb.TagNumber(5)
  Policy ensurePolicy() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.bool get isForced => $_getBF(5);
  @$pb.TagNumber(6)
  set isForced($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsForced() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsForced() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get mustTeen => $_getBF(6);
  @$pb.TagNumber(7)
  set mustTeen($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMustTeen() => $_has(6);
  @$pb.TagNumber(7)
  void clearMustTeen() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get mustRealName => $_getBF(7);
  @$pb.TagNumber(8)
  set mustRealName($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMustRealName() => $_has(7);
  @$pb.TagNumber(8)
  void clearMustRealName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get isParentControl => $_getBF(8);
  @$pb.TagNumber(9)
  set isParentControl($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIsParentControl() => $_has(8);
  @$pb.TagNumber(9)
  void clearIsParentControl() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get age => $_getIZ(9);
  @$pb.TagNumber(10)
  set age($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAge() => $_has(9);
  @$pb.TagNumber(10)
  void clearAge() => $_clearField(10);
}

class VerifyPwdReply extends $pb.GeneratedMessage {
  factory VerifyPwdReply() => create();

  VerifyPwdReply._();

  factory VerifyPwdReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyPwdReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyPwdReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyPwdReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyPwdReply copyWith(void Function(VerifyPwdReply) updates) =>
      super.copyWith((message) => updates(message as VerifyPwdReply))
          as VerifyPwdReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyPwdReply create() => VerifyPwdReply._();
  @$core.override
  VerifyPwdReply createEmptyInstance() => create();
  static $pb.PbList<VerifyPwdReply> createRepeated() =>
      $pb.PbList<VerifyPwdReply>();
  @$core.pragma('dart2js:noInline')
  static VerifyPwdReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyPwdReply>(create);
  static VerifyPwdReply? _defaultInstance;
}

class VerifyPwdReq extends $pb.GeneratedMessage {
  factory VerifyPwdReq({
    $core.String? pwd,
    PwdFrom? pwdFrom,
    $core.bool? isDynamic,
    $core.bool? closeDevice,
    $core.String? deviceToken,
  }) {
    final result = create();
    if (pwd != null) result.pwd = pwd;
    if (pwdFrom != null) result.pwdFrom = pwdFrom;
    if (isDynamic != null) result.isDynamic = isDynamic;
    if (closeDevice != null) result.closeDevice = closeDevice;
    if (deviceToken != null) result.deviceToken = deviceToken;
    return result;
  }

  VerifyPwdReq._();

  factory VerifyPwdReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyPwdReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyPwdReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.interfaces.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'pwd')
    ..aE<PwdFrom>(2, _omitFieldNames ? '' : 'pwdFrom',
        enumValues: PwdFrom.values)
    ..aOB(3, _omitFieldNames ? '' : 'isDynamic')
    ..aOB(4, _omitFieldNames ? '' : 'closeDevice')
    ..aOS(5, _omitFieldNames ? '' : 'deviceToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyPwdReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyPwdReq copyWith(void Function(VerifyPwdReq) updates) =>
      super.copyWith((message) => updates(message as VerifyPwdReq))
          as VerifyPwdReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyPwdReq create() => VerifyPwdReq._();
  @$core.override
  VerifyPwdReq createEmptyInstance() => create();
  static $pb.PbList<VerifyPwdReq> createRepeated() =>
      $pb.PbList<VerifyPwdReq>();
  @$core.pragma('dart2js:noInline')
  static VerifyPwdReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyPwdReq>(create);
  static VerifyPwdReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pwd => $_getSZ(0);
  @$pb.TagNumber(1)
  set pwd($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPwd() => $_has(0);
  @$pb.TagNumber(1)
  void clearPwd() => $_clearField(1);

  @$pb.TagNumber(2)
  PwdFrom get pwdFrom => $_getN(1);
  @$pb.TagNumber(2)
  set pwdFrom(PwdFrom value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPwdFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearPwdFrom() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isDynamic => $_getBF(2);
  @$pb.TagNumber(3)
  set isDynamic($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsDynamic() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsDynamic() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get closeDevice => $_getBF(3);
  @$pb.TagNumber(4)
  set closeDevice($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCloseDevice() => $_has(3);
  @$pb.TagNumber(4)
  void clearCloseDevice() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get deviceToken => $_getSZ(4);
  @$pb.TagNumber(5)
  set deviceToken($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDeviceToken() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeviceToken() => $_clearField(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
