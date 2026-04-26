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
import 'package:protobuf/well_known_types/google/protobuf/any.pb.dart' as $1;

import '../../../account/service/v1.pb.dart' as $5;
import '../../../app/dynamic/v2.pb.dart' as $6;
import '../../../dagw/component/avatar/v1.pb.dart' as $4;
import '../../../pagination.pb.dart' as $2;
import '../../../vas/garb/model.pb.dart' as $3;
import 'v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'v1.pbenum.dart';

class Activity extends $pb.GeneratedMessage {
  factory Activity({
    $fixnum.Int64? activityId,
    $fixnum.Int64? activityState,
    $core.String? activityPlaceholder,
  }) {
    final result = create();
    if (activityId != null) result.activityId = activityId;
    if (activityState != null) result.activityState = activityState;
    if (activityPlaceholder != null)
      result.activityPlaceholder = activityPlaceholder;
    return result;
  }

  Activity._();

  factory Activity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Activity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Activity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'activityId')
    ..aInt64(2, _omitFieldNames ? '' : 'activityState')
    ..aOS(3, _omitFieldNames ? '' : 'activityPlaceholder')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Activity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Activity copyWith(void Function(Activity) updates) =>
      super.copyWith((message) => updates(message as Activity)) as Activity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Activity create() => Activity._();
  @$core.override
  Activity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Activity getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Activity>(create);
  static Activity? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get activityId => $_getI64(0);
  @$pb.TagNumber(1)
  set activityId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActivityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearActivityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get activityState => $_getI64(1);
  @$pb.TagNumber(2)
  set activityState($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasActivityState() => $_has(1);
  @$pb.TagNumber(2)
  void clearActivityState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get activityPlaceholder => $_getSZ(2);
  @$pb.TagNumber(3)
  set activityPlaceholder($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActivityPlaceholder() => $_has(2);
  @$pb.TagNumber(3)
  void clearActivityPlaceholder() => $_clearField(3);
}

class AnswerQuestionReq extends $pb.GeneratedMessage {
  factory AnswerQuestionReq({
    $fixnum.Int64? qid,
    $core.String? optionKey,
  }) {
    final result = create();
    if (qid != null) result.qid = qid;
    if (optionKey != null) result.optionKey = optionKey;
    return result;
  }

  AnswerQuestionReq._();

  factory AnswerQuestionReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AnswerQuestionReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AnswerQuestionReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'qid')
    ..aOS(2, _omitFieldNames ? '' : 'optionKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnswerQuestionReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnswerQuestionReq copyWith(void Function(AnswerQuestionReq) updates) =>
      super.copyWith((message) => updates(message as AnswerQuestionReq))
          as AnswerQuestionReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AnswerQuestionReq create() => AnswerQuestionReq._();
  @$core.override
  AnswerQuestionReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AnswerQuestionReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AnswerQuestionReq>(create);
  static AnswerQuestionReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get qid => $_getI64(0);
  @$pb.TagNumber(1)
  set qid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQid() => $_has(0);
  @$pb.TagNumber(1)
  void clearQid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get optionKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set optionKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOptionKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearOptionKey() => $_clearField(2);
}

class AnswerQuestionResp_MemberPassedPopup extends $pb.GeneratedMessage {
  factory AnswerQuestionResp_MemberPassedPopup({
    $core.String? title,
    $core.String? subtitle,
    $core.String? h5Link,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    if (h5Link != null) result.h5Link = h5Link;
    return result;
  }

  AnswerQuestionResp_MemberPassedPopup._();

  factory AnswerQuestionResp_MemberPassedPopup.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AnswerQuestionResp_MemberPassedPopup.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AnswerQuestionResp.MemberPassedPopup',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'subtitle')
    ..aOS(3, _omitFieldNames ? '' : 'h5Link')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnswerQuestionResp_MemberPassedPopup clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnswerQuestionResp_MemberPassedPopup copyWith(
          void Function(AnswerQuestionResp_MemberPassedPopup) updates) =>
      super.copyWith((message) =>
              updates(message as AnswerQuestionResp_MemberPassedPopup))
          as AnswerQuestionResp_MemberPassedPopup;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AnswerQuestionResp_MemberPassedPopup create() =>
      AnswerQuestionResp_MemberPassedPopup._();
  @$core.override
  AnswerQuestionResp_MemberPassedPopup createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AnswerQuestionResp_MemberPassedPopup getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          AnswerQuestionResp_MemberPassedPopup>(create);
  static AnswerQuestionResp_MemberPassedPopup? _defaultInstance;

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
  $core.String get h5Link => $_getSZ(2);
  @$pb.TagNumber(3)
  set h5Link($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasH5Link() => $_has(2);
  @$pb.TagNumber(3)
  void clearH5Link() => $_clearField(3);
}

class AnswerQuestionResp extends $pb.GeneratedMessage {
  factory AnswerQuestionResp({
    $core.bool? passed,
    $core.bool? memberPassed,
    AnswerQuestionResp_MemberPassedPopup? memberPassedPopup,
    $core.String? bottomText,
    QuestionCardStat? stat,
  }) {
    final result = create();
    if (passed != null) result.passed = passed;
    if (memberPassed != null) result.memberPassed = memberPassed;
    if (memberPassedPopup != null) result.memberPassedPopup = memberPassedPopup;
    if (bottomText != null) result.bottomText = bottomText;
    if (stat != null) result.stat = stat;
    return result;
  }

  AnswerQuestionResp._();

  factory AnswerQuestionResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AnswerQuestionResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AnswerQuestionResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'passed')
    ..aOB(2, _omitFieldNames ? '' : 'memberPassed')
    ..aOM<AnswerQuestionResp_MemberPassedPopup>(
        3, _omitFieldNames ? '' : 'memberPassedPopup',
        subBuilder: AnswerQuestionResp_MemberPassedPopup.create)
    ..aOS(4, _omitFieldNames ? '' : 'bottomText')
    ..aOM<QuestionCardStat>(5, _omitFieldNames ? '' : 'stat',
        subBuilder: QuestionCardStat.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnswerQuestionResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnswerQuestionResp copyWith(void Function(AnswerQuestionResp) updates) =>
      super.copyWith((message) => updates(message as AnswerQuestionResp))
          as AnswerQuestionResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AnswerQuestionResp create() => AnswerQuestionResp._();
  @$core.override
  AnswerQuestionResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AnswerQuestionResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AnswerQuestionResp>(create);
  static AnswerQuestionResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get passed => $_getBF(0);
  @$pb.TagNumber(1)
  set passed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPassed() => $_has(0);
  @$pb.TagNumber(1)
  void clearPassed() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get memberPassed => $_getBF(1);
  @$pb.TagNumber(2)
  set memberPassed($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMemberPassed() => $_has(1);
  @$pb.TagNumber(2)
  void clearMemberPassed() => $_clearField(2);

  @$pb.TagNumber(3)
  AnswerQuestionResp_MemberPassedPopup get memberPassedPopup => $_getN(2);
  @$pb.TagNumber(3)
  set memberPassedPopup(AnswerQuestionResp_MemberPassedPopup value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMemberPassedPopup() => $_has(2);
  @$pb.TagNumber(3)
  void clearMemberPassedPopup() => $_clearField(3);
  @$pb.TagNumber(3)
  AnswerQuestionResp_MemberPassedPopup ensureMemberPassedPopup() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get bottomText => $_getSZ(3);
  @$pb.TagNumber(4)
  set bottomText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBottomText() => $_has(3);
  @$pb.TagNumber(4)
  void clearBottomText() => $_clearField(4);

  @$pb.TagNumber(5)
  QuestionCardStat get stat => $_getN(4);
  @$pb.TagNumber(5)
  set stat(QuestionCardStat value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStat() => $_has(4);
  @$pb.TagNumber(5)
  void clearStat() => $_clearField(5);
  @$pb.TagNumber(5)
  QuestionCardStat ensureStat() => $_ensure(4);
}

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

class AtGroup extends $pb.GeneratedMessage {
  factory AtGroup({
    AtGroup_Type? groupType,
    $core.String? groupName,
    $core.Iterable<AtItem>? items,
  }) {
    final result = create();
    if (groupType != null) result.groupType = groupType;
    if (groupName != null) result.groupName = groupName;
    if (items != null) result.items.addAll(items);
    return result;
  }

  AtGroup._();

  factory AtGroup.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AtGroup.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AtGroup',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aE<AtGroup_Type>(1, _omitFieldNames ? '' : 'groupType',
        enumValues: AtGroup_Type.values)
    ..aOS(2, _omitFieldNames ? '' : 'groupName')
    ..pPM<AtItem>(3, _omitFieldNames ? '' : 'items', subBuilder: AtItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AtGroup clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AtGroup copyWith(void Function(AtGroup) updates) =>
      super.copyWith((message) => updates(message as AtGroup)) as AtGroup;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AtGroup create() => AtGroup._();
  @$core.override
  AtGroup createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AtGroup getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AtGroup>(create);
  static AtGroup? _defaultInstance;

  @$pb.TagNumber(1)
  AtGroup_Type get groupType => $_getN(0);
  @$pb.TagNumber(1)
  set groupType(AtGroup_Type value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGroupType() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get groupName => $_getSZ(1);
  @$pb.TagNumber(2)
  set groupName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGroupName() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupName() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<AtItem> get items => $_getList(2);
}

class AtItem extends $pb.GeneratedMessage {
  factory AtItem({
    $fixnum.Int64? mid,
    $core.String? name,
    $core.String? face,
    $core.int? fans,
    $core.int? officialVerifyType,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    if (name != null) result.name = name;
    if (face != null) result.face = face;
    if (fans != null) result.fans = fans;
    if (officialVerifyType != null)
      result.officialVerifyType = officialVerifyType;
    return result;
  }

  AtItem._();

  factory AtItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AtItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AtItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'face')
    ..aI(4, _omitFieldNames ? '' : 'fans')
    ..aI(5, _omitFieldNames ? '' : 'officialVerifyType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AtItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AtItem copyWith(void Function(AtItem) updates) =>
      super.copyWith((message) => updates(message as AtItem)) as AtItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AtItem create() => AtItem._();
  @$core.override
  AtItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AtItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AtItem>(create);
  static AtItem? _defaultInstance;

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
  $core.String get face => $_getSZ(2);
  @$pb.TagNumber(3)
  set face($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFace() => $_has(2);
  @$pb.TagNumber(3)
  void clearFace() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get fans => $_getIZ(3);
  @$pb.TagNumber(4)
  set fans($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFans() => $_has(3);
  @$pb.TagNumber(4)
  void clearFans() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get officialVerifyType => $_getIZ(4);
  @$pb.TagNumber(5)
  set officialVerifyType($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOfficialVerifyType() => $_has(4);
  @$pb.TagNumber(5)
  void clearOfficialVerifyType() => $_clearField(5);
}

class AtSearchReply extends $pb.GeneratedMessage {
  factory AtSearchReply({
    $core.Iterable<AtGroup>? groups,
  }) {
    final result = create();
    if (groups != null) result.groups.addAll(groups);
    return result;
  }

  AtSearchReply._();

  factory AtSearchReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AtSearchReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AtSearchReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..pPM<AtGroup>(1, _omitFieldNames ? '' : 'groups',
        subBuilder: AtGroup.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AtSearchReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AtSearchReply copyWith(void Function(AtSearchReply) updates) =>
      super.copyWith((message) => updates(message as AtSearchReply))
          as AtSearchReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AtSearchReply create() => AtSearchReply._();
  @$core.override
  AtSearchReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AtSearchReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AtSearchReply>(create);
  static AtSearchReply? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AtGroup> get groups => $_getList(0);
}

class AtSearchReq extends $pb.GeneratedMessage {
  factory AtSearchReq({
    $fixnum.Int64? mid,
    $core.String? keyword,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    if (keyword != null) result.keyword = keyword;
    return result;
  }

  AtSearchReq._();

  factory AtSearchReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AtSearchReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AtSearchReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'keyword')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AtSearchReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AtSearchReq copyWith(void Function(AtSearchReq) updates) =>
      super.copyWith((message) => updates(message as AtSearchReq))
          as AtSearchReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AtSearchReq create() => AtSearchReq._();
  @$core.override
  AtSearchReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AtSearchReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AtSearchReq>(create);
  static AtSearchReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get mid => $_getI64(0);
  @$pb.TagNumber(1)
  set mid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearMid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get keyword => $_getSZ(1);
  @$pb.TagNumber(2)
  set keyword($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKeyword() => $_has(1);
  @$pb.TagNumber(2)
  void clearKeyword() => $_clearField(2);
}

class CM extends $pb.GeneratedMessage {
  factory CM({
    $1.Any? sourceContent,
  }) {
    final result = create();
    if (sourceContent != null) result.sourceContent = sourceContent;
    return result;
  }

  CM._();

  factory CM.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CM.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CM',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Any>(1, _omitFieldNames ? '' : 'sourceContent',
        subBuilder: $1.Any.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CM clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CM copyWith(void Function(CM) updates) =>
      super.copyWith((message) => updates(message as CM)) as CM;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CM create() => CM._();
  @$core.override
  CM createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CM getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CM>(create);
  static CM? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Any get sourceContent => $_getN(0);
  @$pb.TagNumber(1)
  set sourceContent($1.Any value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSourceContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearSourceContent() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Any ensureSourceContent() => $_ensure(0);
}

class Content extends $pb.GeneratedMessage {
  factory Content({
    $core.String? message,
    $core.Iterable<$core.MapEntry<$core.String, Member>>? members,
    $core.Iterable<$core.MapEntry<$core.String, Emote>>? emotes,
    $core.Iterable<$core.MapEntry<$core.String, Topic>>? topics,
    $core.Iterable<$core.MapEntry<$core.String, Url>>? urls,
    Vote? vote,
    $core.Iterable<$core.MapEntry<$core.String, $fixnum.Int64>>? atNameToMid,
    RichText? richText,
    $core.Iterable<Picture>? pictures,
    $core.double? pictureScale,
  }) {
    final result = create();
    if (message != null) result.message = message;
    if (members != null) result.members.addEntries(members);
    if (emotes != null) result.emotes.addEntries(emotes);
    if (topics != null) result.topics.addEntries(topics);
    if (urls != null) result.urls.addEntries(urls);
    if (vote != null) result.vote = vote;
    if (atNameToMid != null) result.atNameToMid.addEntries(atNameToMid);
    if (richText != null) result.richText = richText;
    if (pictures != null) result.pictures.addAll(pictures);
    if (pictureScale != null) result.pictureScale = pictureScale;
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
    ..m<$core.String, Member>(2, _omitFieldNames ? '' : 'members',
        entryClassName: 'Content.MembersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: Member.create,
        valueDefaultOrMaker: Member.getDefault,
        packageName: const $pb.PackageName('bilibili.main.community.reply.v1'))
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
    ..aD(10, _omitFieldNames ? '' : 'pictureScale')
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

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, Member> get members => $_getMap(1);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, Emote> get emotes => $_getMap(2);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, Topic> get topics => $_getMap(3);

  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, Url> get urls => $_getMap(4);

  @$pb.TagNumber(6)
  Vote get vote => $_getN(5);
  @$pb.TagNumber(6)
  set vote(Vote value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasVote() => $_has(5);
  @$pb.TagNumber(6)
  void clearVote() => $_clearField(6);
  @$pb.TagNumber(6)
  Vote ensureVote() => $_ensure(5);

  @$pb.TagNumber(7)
  $pb.PbMap<$core.String, $fixnum.Int64> get atNameToMid => $_getMap(6);

  @$pb.TagNumber(8)
  RichText get richText => $_getN(7);
  @$pb.TagNumber(8)
  set richText(RichText value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRichText() => $_has(7);
  @$pb.TagNumber(8)
  void clearRichText() => $_clearField(8);
  @$pb.TagNumber(8)
  RichText ensureRichText() => $_ensure(7);

  @$pb.TagNumber(9)
  $pb.PbList<Picture> get pictures => $_getList(8);

  @$pb.TagNumber(10)
  $core.double get pictureScale => $_getN(9);
  @$pb.TagNumber(10)
  set pictureScale($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPictureScale() => $_has(9);
  @$pb.TagNumber(10)
  void clearPictureScale() => $_clearField(10);
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

class DetailListReply_SubjectTitle extends $pb.GeneratedMessage {
  factory DetailListReply_SubjectTitle({
    $core.String? leftIcon,
    $core.String? title,
    $core.String? link,
    $fixnum.Int64? rpidMute,
    ReplyNotificationSwitch? pushSwitch,
  }) {
    final result = create();
    if (leftIcon != null) result.leftIcon = leftIcon;
    if (title != null) result.title = title;
    if (link != null) result.link = link;
    if (rpidMute != null) result.rpidMute = rpidMute;
    if (pushSwitch != null) result.pushSwitch = pushSwitch;
    return result;
  }

  DetailListReply_SubjectTitle._();

  factory DetailListReply_SubjectTitle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DetailListReply_SubjectTitle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DetailListReply.SubjectTitle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'leftIcon')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'link')
    ..aInt64(4, _omitFieldNames ? '' : 'rpidMute')
    ..aE<ReplyNotificationSwitch>(5, _omitFieldNames ? '' : 'pushSwitch',
        enumValues: ReplyNotificationSwitch.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DetailListReply_SubjectTitle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DetailListReply_SubjectTitle copyWith(
          void Function(DetailListReply_SubjectTitle) updates) =>
      super.copyWith(
              (message) => updates(message as DetailListReply_SubjectTitle))
          as DetailListReply_SubjectTitle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DetailListReply_SubjectTitle create() =>
      DetailListReply_SubjectTitle._();
  @$core.override
  DetailListReply_SubjectTitle createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DetailListReply_SubjectTitle getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DetailListReply_SubjectTitle>(create);
  static DetailListReply_SubjectTitle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get leftIcon => $_getSZ(0);
  @$pb.TagNumber(1)
  set leftIcon($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLeftIcon() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeftIcon() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get link => $_getSZ(2);
  @$pb.TagNumber(3)
  set link($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLink() => $_has(2);
  @$pb.TagNumber(3)
  void clearLink() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get rpidMute => $_getI64(3);
  @$pb.TagNumber(4)
  set rpidMute($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRpidMute() => $_has(3);
  @$pb.TagNumber(4)
  void clearRpidMute() => $_clearField(4);

  @$pb.TagNumber(5)
  ReplyNotificationSwitch get pushSwitch => $_getN(4);
  @$pb.TagNumber(5)
  set pushSwitch(ReplyNotificationSwitch value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPushSwitch() => $_has(4);
  @$pb.TagNumber(5)
  void clearPushSwitch() => $_clearField(5);
}

class DetailListReply extends $pb.GeneratedMessage {
  factory DetailListReply({
    CursorReply? cursor,
    SubjectControl? subjectControl,
    ReplyInfo? root,
    Activity? activity,
    LikeInfo? likes,
    Mode? mode,
    $core.String? modeText,
    $2.FeedPaginationReply? paginationReply,
    $core.String? sessionId,
    DetailListReply_SubjectTitle? subjectTitle,
  }) {
    final result = create();
    if (cursor != null) result.cursor = cursor;
    if (subjectControl != null) result.subjectControl = subjectControl;
    if (root != null) result.root = root;
    if (activity != null) result.activity = activity;
    if (likes != null) result.likes = likes;
    if (mode != null) result.mode = mode;
    if (modeText != null) result.modeText = modeText;
    if (paginationReply != null) result.paginationReply = paginationReply;
    if (sessionId != null) result.sessionId = sessionId;
    if (subjectTitle != null) result.subjectTitle = subjectTitle;
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
    ..aOM<Activity>(4, _omitFieldNames ? '' : 'activity',
        subBuilder: Activity.create)
    ..aOM<LikeInfo>(5, _omitFieldNames ? '' : 'likes',
        subBuilder: LikeInfo.create)
    ..aE<Mode>(6, _omitFieldNames ? '' : 'mode', enumValues: Mode.values)
    ..aOS(7, _omitFieldNames ? '' : 'modeText')
    ..aOM<$2.FeedPaginationReply>(8, _omitFieldNames ? '' : 'paginationReply',
        subBuilder: $2.FeedPaginationReply.create)
    ..aOS(9, _omitFieldNames ? '' : 'sessionId')
    ..aOM<DetailListReply_SubjectTitle>(
        10, _omitFieldNames ? '' : 'subjectTitle',
        subBuilder: DetailListReply_SubjectTitle.create)
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

  @$pb.TagNumber(4)
  Activity get activity => $_getN(3);
  @$pb.TagNumber(4)
  set activity(Activity value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasActivity() => $_has(3);
  @$pb.TagNumber(4)
  void clearActivity() => $_clearField(4);
  @$pb.TagNumber(4)
  Activity ensureActivity() => $_ensure(3);

  @$pb.TagNumber(5)
  LikeInfo get likes => $_getN(4);
  @$pb.TagNumber(5)
  set likes(LikeInfo value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLikes() => $_has(4);
  @$pb.TagNumber(5)
  void clearLikes() => $_clearField(5);
  @$pb.TagNumber(5)
  LikeInfo ensureLikes() => $_ensure(4);

  @$pb.TagNumber(6)
  Mode get mode => $_getN(5);
  @$pb.TagNumber(6)
  set mode(Mode value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasMode() => $_has(5);
  @$pb.TagNumber(6)
  void clearMode() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get modeText => $_getSZ(6);
  @$pb.TagNumber(7)
  set modeText($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasModeText() => $_has(6);
  @$pb.TagNumber(7)
  void clearModeText() => $_clearField(7);

  @$pb.TagNumber(8)
  $2.FeedPaginationReply get paginationReply => $_getN(7);
  @$pb.TagNumber(8)
  set paginationReply($2.FeedPaginationReply value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPaginationReply() => $_has(7);
  @$pb.TagNumber(8)
  void clearPaginationReply() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.FeedPaginationReply ensurePaginationReply() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get sessionId => $_getSZ(8);
  @$pb.TagNumber(9)
  set sessionId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSessionId() => $_has(8);
  @$pb.TagNumber(9)
  void clearSessionId() => $_clearField(9);

  @$pb.TagNumber(10)
  DetailListReply_SubjectTitle get subjectTitle => $_getN(9);
  @$pb.TagNumber(10)
  set subjectTitle(DetailListReply_SubjectTitle value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasSubjectTitle() => $_has(9);
  @$pb.TagNumber(10)
  void clearSubjectTitle() => $_clearField(10);
  @$pb.TagNumber(10)
  DetailListReply_SubjectTitle ensureSubjectTitle() => $_ensure(9);
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
    $2.FeedPagination? pagination,
    $core.String? extra,
    $core.String? adExtra,
    $core.bool? needSubjectTitle,
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
    if (extra != null) result.extra = extra;
    if (adExtra != null) result.adExtra = adExtra;
    if (needSubjectTitle != null) result.needSubjectTitle = needSubjectTitle;
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
    ..aOM<$2.FeedPagination>(8, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.FeedPagination.create)
    ..aOS(9, _omitFieldNames ? '' : 'extra')
    ..aOS(10, _omitFieldNames ? '' : 'adExtra')
    ..aOB(11, _omitFieldNames ? '' : 'needSubjectTitle')
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
  $2.FeedPagination get pagination => $_getN(7);
  @$pb.TagNumber(8)
  set pagination($2.FeedPagination value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPagination() => $_has(7);
  @$pb.TagNumber(8)
  void clearPagination() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.FeedPagination ensurePagination() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get extra => $_getSZ(8);
  @$pb.TagNumber(9)
  set extra($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasExtra() => $_has(8);
  @$pb.TagNumber(9)
  void clearExtra() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get adExtra => $_getSZ(9);
  @$pb.TagNumber(10)
  set adExtra($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAdExtra() => $_has(9);
  @$pb.TagNumber(10)
  void clearAdExtra() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get needSubjectTitle => $_getBF(10);
  @$pb.TagNumber(11)
  set needSubjectTitle($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasNeedSubjectTitle() => $_has(10);
  @$pb.TagNumber(11)
  void clearNeedSubjectTitle() => $_clearField(11);
}

class DialogListReply extends $pb.GeneratedMessage {
  factory DialogListReply({
    CursorReply? cursor,
    SubjectControl? subjectControl,
    $core.Iterable<ReplyInfo>? replies,
    Activity? activity,
    $2.FeedPaginationReply? paginationReply,
    $core.String? sessionId,
  }) {
    final result = create();
    if (cursor != null) result.cursor = cursor;
    if (subjectControl != null) result.subjectControl = subjectControl;
    if (replies != null) result.replies.addAll(replies);
    if (activity != null) result.activity = activity;
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
    ..aOM<Activity>(4, _omitFieldNames ? '' : 'activity',
        subBuilder: Activity.create)
    ..aOM<$2.FeedPaginationReply>(5, _omitFieldNames ? '' : 'paginationReply',
        subBuilder: $2.FeedPaginationReply.create)
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

  @$pb.TagNumber(4)
  Activity get activity => $_getN(3);
  @$pb.TagNumber(4)
  set activity(Activity value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasActivity() => $_has(3);
  @$pb.TagNumber(4)
  void clearActivity() => $_clearField(4);
  @$pb.TagNumber(4)
  Activity ensureActivity() => $_ensure(3);

  @$pb.TagNumber(5)
  $2.FeedPaginationReply get paginationReply => $_getN(4);
  @$pb.TagNumber(5)
  set paginationReply($2.FeedPaginationReply value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPaginationReply() => $_has(4);
  @$pb.TagNumber(5)
  void clearPaginationReply() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.FeedPaginationReply ensurePaginationReply() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get sessionId => $_getSZ(5);
  @$pb.TagNumber(6)
  set sessionId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSessionId() => $_has(5);
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
    $2.FeedPagination? pagination,
    $core.String? extra,
    $core.String? adExtra,
  }) {
    final result = create();
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    if (root != null) result.root = root;
    if (dialog != null) result.dialog = dialog;
    if (cursor != null) result.cursor = cursor;
    if (pagination != null) result.pagination = pagination;
    if (extra != null) result.extra = extra;
    if (adExtra != null) result.adExtra = adExtra;
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
    ..aOM<$2.FeedPagination>(6, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.FeedPagination.create)
    ..aOS(7, _omitFieldNames ? '' : 'extra')
    ..aOS(8, _omitFieldNames ? '' : 'adExtra')
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
  $2.FeedPagination get pagination => $_getN(5);
  @$pb.TagNumber(6)
  set pagination($2.FeedPagination value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPagination() => $_has(5);
  @$pb.TagNumber(6)
  void clearPagination() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.FeedPagination ensurePagination() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get extra => $_getSZ(6);
  @$pb.TagNumber(7)
  set extra($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasExtra() => $_has(6);
  @$pb.TagNumber(7)
  void clearExtra() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get adExtra => $_getSZ(7);
  @$pb.TagNumber(8)
  set adExtra($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAdExtra() => $_has(7);
  @$pb.TagNumber(8)
  void clearAdExtra() => $_clearField(8);
}

class DoVoteReq extends $pb.GeneratedMessage {
  factory DoVoteReq({
    $fixnum.Int64? oid,
    $fixnum.Int64? type,
    $fixnum.Int64? voteId,
    $fixnum.Int64? option,
  }) {
    final result = create();
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    if (voteId != null) result.voteId = voteId;
    if (option != null) result.option = option;
    return result;
  }

  DoVoteReq._();

  factory DoVoteReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DoVoteReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DoVoteReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'oid')
    ..aInt64(2, _omitFieldNames ? '' : 'type')
    ..aInt64(3, _omitFieldNames ? '' : 'voteId')
    ..aInt64(4, _omitFieldNames ? '' : 'option')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DoVoteReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DoVoteReq copyWith(void Function(DoVoteReq) updates) =>
      super.copyWith((message) => updates(message as DoVoteReq)) as DoVoteReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DoVoteReq create() => DoVoteReq._();
  @$core.override
  DoVoteReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DoVoteReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DoVoteReq>(create);
  static DoVoteReq? _defaultInstance;

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
  $fixnum.Int64 get voteId => $_getI64(2);
  @$pb.TagNumber(3)
  set voteId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVoteId() => $_has(2);
  @$pb.TagNumber(3)
  void clearVoteId() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get option => $_getI64(3);
  @$pb.TagNumber(4)
  set option($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOption() => $_has(3);
  @$pb.TagNumber(4)
  void clearOption() => $_clearField(4);
}

class DoVoteResp extends $pb.GeneratedMessage {
  factory DoVoteResp() => create();

  DoVoteResp._();

  factory DoVoteResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DoVoteResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DoVoteResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DoVoteResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DoVoteResp copyWith(void Function(DoVoteResp) updates) =>
      super.copyWith((message) => updates(message as DoVoteResp)) as DoVoteResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DoVoteResp create() => DoVoteResp._();
  @$core.override
  DoVoteResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DoVoteResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DoVoteResp>(create);
  static DoVoteResp? _defaultInstance;
}

class ESportsGradeCard extends $pb.GeneratedMessage {
  factory ESportsGradeCard({
    $core.String? title,
    $core.String? description,
    $core.String? image,
    $core.String? link,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (image != null) result.image = image;
    if (link != null) result.link = link;
    return result;
  }

  ESportsGradeCard._();

  factory ESportsGradeCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ESportsGradeCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ESportsGradeCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aOS(3, _omitFieldNames ? '' : 'image')
    ..aOS(4, _omitFieldNames ? '' : 'link')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ESportsGradeCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ESportsGradeCard copyWith(void Function(ESportsGradeCard) updates) =>
      super.copyWith((message) => updates(message as ESportsGradeCard))
          as ESportsGradeCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ESportsGradeCard create() => ESportsGradeCard._();
  @$core.override
  ESportsGradeCard createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ESportsGradeCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ESportsGradeCard>(create);
  static ESportsGradeCard? _defaultInstance;

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
  $core.String get image => $_getSZ(2);
  @$pb.TagNumber(3)
  set image($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasImage() => $_has(2);
  @$pb.TagNumber(3)
  void clearImage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get link => $_getSZ(3);
  @$pb.TagNumber(4)
  set link($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLink() => $_has(3);
  @$pb.TagNumber(4)
  void clearLink() => $_clearField(4);
}

class Effects extends $pb.GeneratedMessage {
  factory Effects({
    $core.String? preloading,
  }) {
    final result = create();
    if (preloading != null) result.preloading = preloading;
    return result;
  }

  Effects._();

  factory Effects.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Effects.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Effects',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'preloading')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Effects clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Effects copyWith(void Function(Effects) updates) =>
      super.copyWith((message) => updates(message as Effects)) as Effects;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Effects create() => Effects._();
  @$core.override
  Effects createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Effects getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Effects>(create);
  static Effects? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get preloading => $_getSZ(0);
  @$pb.TagNumber(1)
  set preloading($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPreloading() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreloading() => $_clearField(1);
}

class Emote extends $pb.GeneratedMessage {
  factory Emote({
    $fixnum.Int64? size,
    $core.String? url,
    $core.String? jumpUrl,
    $core.String? jumpTitle,
    $fixnum.Int64? id,
    $fixnum.Int64? packageId,
    $core.String? gifUrl,
    $core.String? text,
    $core.String? webpUrl,
  }) {
    final result = create();
    if (size != null) result.size = size;
    if (url != null) result.url = url;
    if (jumpUrl != null) result.jumpUrl = jumpUrl;
    if (jumpTitle != null) result.jumpTitle = jumpTitle;
    if (id != null) result.id = id;
    if (packageId != null) result.packageId = packageId;
    if (gifUrl != null) result.gifUrl = gifUrl;
    if (text != null) result.text = text;
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
    ..aOS(3, _omitFieldNames ? '' : 'jumpUrl')
    ..aOS(4, _omitFieldNames ? '' : 'jumpTitle')
    ..aInt64(5, _omitFieldNames ? '' : 'id')
    ..aInt64(6, _omitFieldNames ? '' : 'packageId')
    ..aOS(7, _omitFieldNames ? '' : 'gifUrl')
    ..aOS(8, _omitFieldNames ? '' : 'text')
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

  @$pb.TagNumber(3)
  $core.String get jumpUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set jumpUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasJumpUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearJumpUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get jumpTitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set jumpTitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasJumpTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearJumpTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get id => $_getI64(4);
  @$pb.TagNumber(5)
  set id($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasId() => $_has(4);
  @$pb.TagNumber(5)
  void clearId() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get packageId => $_getI64(5);
  @$pb.TagNumber(6)
  set packageId($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPackageId() => $_has(5);
  @$pb.TagNumber(6)
  void clearPackageId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get gifUrl => $_getSZ(6);
  @$pb.TagNumber(7)
  set gifUrl($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasGifUrl() => $_has(6);
  @$pb.TagNumber(7)
  void clearGifUrl() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get text => $_getSZ(7);
  @$pb.TagNumber(8)
  set text($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasText() => $_has(7);
  @$pb.TagNumber(8)
  void clearText() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get webpUrl => $_getSZ(8);
  @$pb.TagNumber(9)
  set webpUrl($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasWebpUrl() => $_has(8);
  @$pb.TagNumber(9)
  void clearWebpUrl() => $_clearField(9);
}

class EmptyPage_Button extends $pb.GeneratedMessage {
  factory EmptyPage_Button({
    $core.String? title,
    EmptyPage_Action? action,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (action != null) result.action = action;
    return result;
  }

  EmptyPage_Button._();

  factory EmptyPage_Button.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmptyPage_Button.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmptyPage.Button',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aE<EmptyPage_Action>(2, _omitFieldNames ? '' : 'action',
        enumValues: EmptyPage_Action.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmptyPage_Button clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmptyPage_Button copyWith(void Function(EmptyPage_Button) updates) =>
      super.copyWith((message) => updates(message as EmptyPage_Button))
          as EmptyPage_Button;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmptyPage_Button create() => EmptyPage_Button._();
  @$core.override
  EmptyPage_Button createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmptyPage_Button getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmptyPage_Button>(create);
  static EmptyPage_Button? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  EmptyPage_Action get action => $_getN(1);
  @$pb.TagNumber(2)
  set action(EmptyPage_Action value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => $_clearField(2);
}

class EmptyPage_Text extends $pb.GeneratedMessage {
  factory EmptyPage_Text({
    $core.String? raw,
    TextStyle? style,
    EmptyPage_Action? action,
  }) {
    final result = create();
    if (raw != null) result.raw = raw;
    if (style != null) result.style = style;
    if (action != null) result.action = action;
    return result;
  }

  EmptyPage_Text._();

  factory EmptyPage_Text.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmptyPage_Text.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmptyPage.Text',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'raw')
    ..aOM<TextStyle>(2, _omitFieldNames ? '' : 'style',
        subBuilder: TextStyle.create)
    ..aE<EmptyPage_Action>(3, _omitFieldNames ? '' : 'action',
        enumValues: EmptyPage_Action.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmptyPage_Text clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmptyPage_Text copyWith(void Function(EmptyPage_Text) updates) =>
      super.copyWith((message) => updates(message as EmptyPage_Text))
          as EmptyPage_Text;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmptyPage_Text create() => EmptyPage_Text._();
  @$core.override
  EmptyPage_Text createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmptyPage_Text getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EmptyPage_Text>(create);
  static EmptyPage_Text? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get raw => $_getSZ(0);
  @$pb.TagNumber(1)
  set raw($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRaw() => $_has(0);
  @$pb.TagNumber(1)
  void clearRaw() => $_clearField(1);

  @$pb.TagNumber(2)
  TextStyle get style => $_getN(1);
  @$pb.TagNumber(2)
  set style(TextStyle value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStyle() => $_has(1);
  @$pb.TagNumber(2)
  void clearStyle() => $_clearField(2);
  @$pb.TagNumber(2)
  TextStyle ensureStyle() => $_ensure(1);

  @$pb.TagNumber(3)
  EmptyPage_Action get action => $_getN(2);
  @$pb.TagNumber(3)
  set action(EmptyPage_Action value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAction() => $_has(2);
  @$pb.TagNumber(3)
  void clearAction() => $_clearField(3);
}

class EmptyPage extends $pb.GeneratedMessage {
  factory EmptyPage({
    $core.String? imageUrl,
    $core.Iterable<EmptyPage_Text>? texts,
    EmptyPage_Button? leftButton,
    EmptyPage_Button? rightButton,
  }) {
    final result = create();
    if (imageUrl != null) result.imageUrl = imageUrl;
    if (texts != null) result.texts.addAll(texts);
    if (leftButton != null) result.leftButton = leftButton;
    if (rightButton != null) result.rightButton = rightButton;
    return result;
  }

  EmptyPage._();

  factory EmptyPage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EmptyPage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EmptyPage',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'imageUrl')
    ..pPM<EmptyPage_Text>(2, _omitFieldNames ? '' : 'texts',
        subBuilder: EmptyPage_Text.create)
    ..aOM<EmptyPage_Button>(3, _omitFieldNames ? '' : 'leftButton',
        subBuilder: EmptyPage_Button.create)
    ..aOM<EmptyPage_Button>(4, _omitFieldNames ? '' : 'rightButton',
        subBuilder: EmptyPage_Button.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmptyPage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EmptyPage copyWith(void Function(EmptyPage) updates) =>
      super.copyWith((message) => updates(message as EmptyPage)) as EmptyPage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EmptyPage create() => EmptyPage._();
  @$core.override
  EmptyPage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EmptyPage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EmptyPage>(create);
  static EmptyPage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get imageUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set imageUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasImageUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearImageUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<EmptyPage_Text> get texts => $_getList(1);

  @$pb.TagNumber(3)
  EmptyPage_Button get leftButton => $_getN(2);
  @$pb.TagNumber(3)
  set leftButton(EmptyPage_Button value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLeftButton() => $_has(2);
  @$pb.TagNumber(3)
  void clearLeftButton() => $_clearField(3);
  @$pb.TagNumber(3)
  EmptyPage_Button ensureLeftButton() => $_ensure(2);

  @$pb.TagNumber(4)
  EmptyPage_Button get rightButton => $_getN(3);
  @$pb.TagNumber(4)
  set rightButton(EmptyPage_Button value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRightButton() => $_has(3);
  @$pb.TagNumber(4)
  void clearRightButton() => $_clearField(4);
  @$pb.TagNumber(4)
  EmptyPage_Button ensureRightButton() => $_ensure(3);
}

class Form extends $pb.GeneratedMessage {
  factory Form({
    $core.int? type,
    $core.Iterable<QoeOption>? options,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (options != null) result.options.addAll(options);
    return result;
  }

  Form._();

  factory Form.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Form.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Form',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'type')
    ..pPM<QoeOption>(2, _omitFieldNames ? '' : 'options',
        subBuilder: QoeOption.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Form clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Form copyWith(void Function(Form) updates) =>
      super.copyWith((message) => updates(message as Form)) as Form;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Form create() => Form._();
  @$core.override
  Form createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Form getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Form>(create);
  static Form? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<QoeOption> get options => $_getList(1);
}

class GoodsSearchItem extends $pb.GeneratedMessage {
  factory GoodsSearchItem({
    $fixnum.Int64? id,
    $core.String? name,
    $core.String? price,
    $core.String? income,
    $core.String? img,
    $core.String? label,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (price != null) result.price = price;
    if (income != null) result.income = income;
    if (img != null) result.img = img;
    if (label != null) result.label = label;
    return result;
  }

  GoodsSearchItem._();

  factory GoodsSearchItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GoodsSearchItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GoodsSearchItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'price')
    ..aOS(4, _omitFieldNames ? '' : 'income')
    ..aOS(5, _omitFieldNames ? '' : 'img')
    ..aOS(6, _omitFieldNames ? '' : 'label')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GoodsSearchItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GoodsSearchItem copyWith(void Function(GoodsSearchItem) updates) =>
      super.copyWith((message) => updates(message as GoodsSearchItem))
          as GoodsSearchItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GoodsSearchItem create() => GoodsSearchItem._();
  @$core.override
  GoodsSearchItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GoodsSearchItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GoodsSearchItem>(create);
  static GoodsSearchItem? _defaultInstance;

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
  $core.String get price => $_getSZ(2);
  @$pb.TagNumber(3)
  set price($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrice() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get income => $_getSZ(3);
  @$pb.TagNumber(4)
  set income($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIncome() => $_has(3);
  @$pb.TagNumber(4)
  void clearIncome() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get img => $_getSZ(4);
  @$pb.TagNumber(5)
  set img($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasImg() => $_has(4);
  @$pb.TagNumber(5)
  void clearImg() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get label => $_getSZ(5);
  @$pb.TagNumber(6)
  set label($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLabel() => $_has(5);
  @$pb.TagNumber(6)
  void clearLabel() => $_clearField(6);
}

class LikeInfo_Item extends $pb.GeneratedMessage {
  factory LikeInfo_Item({
    Member? member,
  }) {
    final result = create();
    if (member != null) result.member = member;
    return result;
  }

  LikeInfo_Item._();

  factory LikeInfo_Item.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LikeInfo_Item.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LikeInfo.Item',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOM<Member>(1, _omitFieldNames ? '' : 'member', subBuilder: Member.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeInfo_Item clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeInfo_Item copyWith(void Function(LikeInfo_Item) updates) =>
      super.copyWith((message) => updates(message as LikeInfo_Item))
          as LikeInfo_Item;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LikeInfo_Item create() => LikeInfo_Item._();
  @$core.override
  LikeInfo_Item createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LikeInfo_Item getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LikeInfo_Item>(create);
  static LikeInfo_Item? _defaultInstance;

  @$pb.TagNumber(1)
  Member get member => $_getN(0);
  @$pb.TagNumber(1)
  set member(Member value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMember() => $_has(0);
  @$pb.TagNumber(1)
  void clearMember() => $_clearField(1);
  @$pb.TagNumber(1)
  Member ensureMember() => $_ensure(0);
}

class LikeInfo extends $pb.GeneratedMessage {
  factory LikeInfo({
    $core.Iterable<LikeInfo_Item>? items,
    $core.String? title,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    if (title != null) result.title = title;
    return result;
  }

  LikeInfo._();

  factory LikeInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LikeInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LikeInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..pPM<LikeInfo_Item>(1, _omitFieldNames ? '' : 'items',
        subBuilder: LikeInfo_Item.create)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeInfo copyWith(void Function(LikeInfo) updates) =>
      super.copyWith((message) => updates(message as LikeInfo)) as LikeInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LikeInfo create() => LikeInfo._();
  @$core.override
  LikeInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LikeInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LikeInfo>(create);
  static LikeInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<LikeInfo_Item> get items => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);
}

class Lottery extends $pb.GeneratedMessage {
  factory Lottery({
    $fixnum.Int64? lotteryId,
    $fixnum.Int64? lotteryStatus,
    $fixnum.Int64? lotteryMid,
    $fixnum.Int64? lotteryTime,
    $fixnum.Int64? oid,
    $fixnum.Int64? type,
    $fixnum.Int64? ctime,
    Content? content,
    Member? member,
    ReplyControl? replyControl,
  }) {
    final result = create();
    if (lotteryId != null) result.lotteryId = lotteryId;
    if (lotteryStatus != null) result.lotteryStatus = lotteryStatus;
    if (lotteryMid != null) result.lotteryMid = lotteryMid;
    if (lotteryTime != null) result.lotteryTime = lotteryTime;
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    if (ctime != null) result.ctime = ctime;
    if (content != null) result.content = content;
    if (member != null) result.member = member;
    if (replyControl != null) result.replyControl = replyControl;
    return result;
  }

  Lottery._();

  factory Lottery.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Lottery.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Lottery',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'lotteryId')
    ..aInt64(2, _omitFieldNames ? '' : 'lotteryStatus')
    ..aInt64(3, _omitFieldNames ? '' : 'lotteryMid')
    ..aInt64(4, _omitFieldNames ? '' : 'lotteryTime')
    ..aInt64(5, _omitFieldNames ? '' : 'oid')
    ..aInt64(6, _omitFieldNames ? '' : 'type')
    ..aInt64(7, _omitFieldNames ? '' : 'ctime')
    ..aOM<Content>(8, _omitFieldNames ? '' : 'content',
        subBuilder: Content.create)
    ..aOM<Member>(9, _omitFieldNames ? '' : 'member', subBuilder: Member.create)
    ..aOM<ReplyControl>(10, _omitFieldNames ? '' : 'replyControl',
        subBuilder: ReplyControl.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Lottery clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Lottery copyWith(void Function(Lottery) updates) =>
      super.copyWith((message) => updates(message as Lottery)) as Lottery;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Lottery create() => Lottery._();
  @$core.override
  Lottery createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Lottery getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Lottery>(create);
  static Lottery? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get lotteryId => $_getI64(0);
  @$pb.TagNumber(1)
  set lotteryId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLotteryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLotteryId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get lotteryStatus => $_getI64(1);
  @$pb.TagNumber(2)
  set lotteryStatus($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLotteryStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearLotteryStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get lotteryMid => $_getI64(2);
  @$pb.TagNumber(3)
  set lotteryMid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLotteryMid() => $_has(2);
  @$pb.TagNumber(3)
  void clearLotteryMid() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get lotteryTime => $_getI64(3);
  @$pb.TagNumber(4)
  set lotteryTime($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLotteryTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearLotteryTime() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get oid => $_getI64(4);
  @$pb.TagNumber(5)
  set oid($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOid() => $_has(4);
  @$pb.TagNumber(5)
  void clearOid() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get type => $_getI64(5);
  @$pb.TagNumber(6)
  set type($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasType() => $_has(5);
  @$pb.TagNumber(6)
  void clearType() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get ctime => $_getI64(6);
  @$pb.TagNumber(7)
  set ctime($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCtime() => $_has(6);
  @$pb.TagNumber(7)
  void clearCtime() => $_clearField(7);

  @$pb.TagNumber(8)
  Content get content => $_getN(7);
  @$pb.TagNumber(8)
  set content(Content value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasContent() => $_has(7);
  @$pb.TagNumber(8)
  void clearContent() => $_clearField(8);
  @$pb.TagNumber(8)
  Content ensureContent() => $_ensure(7);

  @$pb.TagNumber(9)
  Member get member => $_getN(8);
  @$pb.TagNumber(9)
  set member(Member value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasMember() => $_has(8);
  @$pb.TagNumber(9)
  void clearMember() => $_clearField(9);
  @$pb.TagNumber(9)
  Member ensureMember() => $_ensure(8);

  @$pb.TagNumber(10)
  ReplyControl get replyControl => $_getN(9);
  @$pb.TagNumber(10)
  set replyControl(ReplyControl value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasReplyControl() => $_has(9);
  @$pb.TagNumber(10)
  void clearReplyControl() => $_clearField(10);
  @$pb.TagNumber(10)
  ReplyControl ensureReplyControl() => $_ensure(9);
}

class MainListReply extends $pb.GeneratedMessage {
  factory MainListReply({
    CursorReply? cursor,
    $core.Iterable<ReplyInfo>? replies,
    SubjectControl? subjectControl,
    ReplyInfo? upTop,
    ReplyInfo? adminTop,
    ReplyInfo? voteTop,
    Notice? notice,
    Lottery? lottery,
    Activity? activity,
    UpSelection? upSelection,
    CM? cm,
    Effects? effects,
    Operation? operation,
    $core.Iterable<ReplyInfo>? topReplies,
    QoeInfo? qoe,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? callbacks,
    OperationV2? operationV2,
    Mode? mode,
    $core.String? modeText,
    $2.FeedPaginationReply? paginationReply,
    $core.String? sessionId,
    $core.String? reportParams,
    VoteCard? voteCard,
    ESportsGradeCard? esportsGradeCard,
    $core.String? contextFeature,
    $core.String? paginationEndText,
    $core.Iterable<MixedCard>? mixedCards,
    $core.Iterable<SubjectTopCards>? subjectTopCards,
  }) {
    final result = create();
    if (cursor != null) result.cursor = cursor;
    if (replies != null) result.replies.addAll(replies);
    if (subjectControl != null) result.subjectControl = subjectControl;
    if (upTop != null) result.upTop = upTop;
    if (adminTop != null) result.adminTop = adminTop;
    if (voteTop != null) result.voteTop = voteTop;
    if (notice != null) result.notice = notice;
    if (lottery != null) result.lottery = lottery;
    if (activity != null) result.activity = activity;
    if (upSelection != null) result.upSelection = upSelection;
    if (cm != null) result.cm = cm;
    if (effects != null) result.effects = effects;
    if (operation != null) result.operation = operation;
    if (topReplies != null) result.topReplies.addAll(topReplies);
    if (qoe != null) result.qoe = qoe;
    if (callbacks != null) result.callbacks.addEntries(callbacks);
    if (operationV2 != null) result.operationV2 = operationV2;
    if (mode != null) result.mode = mode;
    if (modeText != null) result.modeText = modeText;
    if (paginationReply != null) result.paginationReply = paginationReply;
    if (sessionId != null) result.sessionId = sessionId;
    if (reportParams != null) result.reportParams = reportParams;
    if (voteCard != null) result.voteCard = voteCard;
    if (esportsGradeCard != null) result.esportsGradeCard = esportsGradeCard;
    if (contextFeature != null) result.contextFeature = contextFeature;
    if (paginationEndText != null) result.paginationEndText = paginationEndText;
    if (mixedCards != null) result.mixedCards.addAll(mixedCards);
    if (subjectTopCards != null) result.subjectTopCards.addAll(subjectTopCards);
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
    ..aOM<ReplyInfo>(5, _omitFieldNames ? '' : 'adminTop',
        subBuilder: ReplyInfo.create)
    ..aOM<ReplyInfo>(6, _omitFieldNames ? '' : 'voteTop',
        subBuilder: ReplyInfo.create)
    ..aOM<Notice>(7, _omitFieldNames ? '' : 'notice', subBuilder: Notice.create)
    ..aOM<Lottery>(8, _omitFieldNames ? '' : 'lottery',
        subBuilder: Lottery.create)
    ..aOM<Activity>(9, _omitFieldNames ? '' : 'activity',
        subBuilder: Activity.create)
    ..aOM<UpSelection>(10, _omitFieldNames ? '' : 'upSelection',
        subBuilder: UpSelection.create)
    ..aOM<CM>(11, _omitFieldNames ? '' : 'cm', subBuilder: CM.create)
    ..aOM<Effects>(12, _omitFieldNames ? '' : 'effects',
        subBuilder: Effects.create)
    ..aOM<Operation>(13, _omitFieldNames ? '' : 'operation',
        subBuilder: Operation.create)
    ..pPM<ReplyInfo>(14, _omitFieldNames ? '' : 'topReplies',
        subBuilder: ReplyInfo.create)
    ..aOM<QoeInfo>(15, _omitFieldNames ? '' : 'qoe', subBuilder: QoeInfo.create)
    ..m<$core.String, $core.int>(16, _omitFieldNames ? '' : 'callbacks',
        entryClassName: 'MainListReply.CallbacksEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('bilibili.main.community.reply.v1'))
    ..aOM<OperationV2>(17, _omitFieldNames ? '' : 'operationV2',
        subBuilder: OperationV2.create)
    ..aE<Mode>(18, _omitFieldNames ? '' : 'mode', enumValues: Mode.values)
    ..aOS(19, _omitFieldNames ? '' : 'modeText')
    ..aOM<$2.FeedPaginationReply>(20, _omitFieldNames ? '' : 'paginationReply',
        subBuilder: $2.FeedPaginationReply.create)
    ..aOS(21, _omitFieldNames ? '' : 'sessionId')
    ..aOS(22, _omitFieldNames ? '' : 'reportParams')
    ..aOM<VoteCard>(23, _omitFieldNames ? '' : 'voteCard',
        subBuilder: VoteCard.create)
    ..aOM<ESportsGradeCard>(24, _omitFieldNames ? '' : 'esportsGradeCard',
        subBuilder: ESportsGradeCard.create)
    ..aOS(25, _omitFieldNames ? '' : 'contextFeature')
    ..aOS(26, _omitFieldNames ? '' : 'paginationEndText')
    ..pPM<MixedCard>(27, _omitFieldNames ? '' : 'mixedCards',
        subBuilder: MixedCard.create)
    ..pPM<SubjectTopCards>(28, _omitFieldNames ? '' : 'subjectTopCards',
        subBuilder: SubjectTopCards.create)
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

  @$pb.TagNumber(5)
  ReplyInfo get adminTop => $_getN(4);
  @$pb.TagNumber(5)
  set adminTop(ReplyInfo value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAdminTop() => $_has(4);
  @$pb.TagNumber(5)
  void clearAdminTop() => $_clearField(5);
  @$pb.TagNumber(5)
  ReplyInfo ensureAdminTop() => $_ensure(4);

  @$pb.TagNumber(6)
  ReplyInfo get voteTop => $_getN(5);
  @$pb.TagNumber(6)
  set voteTop(ReplyInfo value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasVoteTop() => $_has(5);
  @$pb.TagNumber(6)
  void clearVoteTop() => $_clearField(6);
  @$pb.TagNumber(6)
  ReplyInfo ensureVoteTop() => $_ensure(5);

  @$pb.TagNumber(7)
  Notice get notice => $_getN(6);
  @$pb.TagNumber(7)
  set notice(Notice value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasNotice() => $_has(6);
  @$pb.TagNumber(7)
  void clearNotice() => $_clearField(7);
  @$pb.TagNumber(7)
  Notice ensureNotice() => $_ensure(6);

  @$pb.TagNumber(8)
  Lottery get lottery => $_getN(7);
  @$pb.TagNumber(8)
  set lottery(Lottery value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasLottery() => $_has(7);
  @$pb.TagNumber(8)
  void clearLottery() => $_clearField(8);
  @$pb.TagNumber(8)
  Lottery ensureLottery() => $_ensure(7);

  @$pb.TagNumber(9)
  Activity get activity => $_getN(8);
  @$pb.TagNumber(9)
  set activity(Activity value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasActivity() => $_has(8);
  @$pb.TagNumber(9)
  void clearActivity() => $_clearField(9);
  @$pb.TagNumber(9)
  Activity ensureActivity() => $_ensure(8);

  @$pb.TagNumber(10)
  UpSelection get upSelection => $_getN(9);
  @$pb.TagNumber(10)
  set upSelection(UpSelection value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasUpSelection() => $_has(9);
  @$pb.TagNumber(10)
  void clearUpSelection() => $_clearField(10);
  @$pb.TagNumber(10)
  UpSelection ensureUpSelection() => $_ensure(9);

  @$pb.TagNumber(11)
  CM get cm => $_getN(10);
  @$pb.TagNumber(11)
  set cm(CM value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasCm() => $_has(10);
  @$pb.TagNumber(11)
  void clearCm() => $_clearField(11);
  @$pb.TagNumber(11)
  CM ensureCm() => $_ensure(10);

  @$pb.TagNumber(12)
  Effects get effects => $_getN(11);
  @$pb.TagNumber(12)
  set effects(Effects value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasEffects() => $_has(11);
  @$pb.TagNumber(12)
  void clearEffects() => $_clearField(12);
  @$pb.TagNumber(12)
  Effects ensureEffects() => $_ensure(11);

  @$pb.TagNumber(13)
  Operation get operation => $_getN(12);
  @$pb.TagNumber(13)
  set operation(Operation value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasOperation() => $_has(12);
  @$pb.TagNumber(13)
  void clearOperation() => $_clearField(13);
  @$pb.TagNumber(13)
  Operation ensureOperation() => $_ensure(12);

  @$pb.TagNumber(14)
  $pb.PbList<ReplyInfo> get topReplies => $_getList(13);

  @$pb.TagNumber(15)
  QoeInfo get qoe => $_getN(14);
  @$pb.TagNumber(15)
  set qoe(QoeInfo value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasQoe() => $_has(14);
  @$pb.TagNumber(15)
  void clearQoe() => $_clearField(15);
  @$pb.TagNumber(15)
  QoeInfo ensureQoe() => $_ensure(14);

  @$pb.TagNumber(16)
  $pb.PbMap<$core.String, $core.int> get callbacks => $_getMap(15);

  @$pb.TagNumber(17)
  OperationV2 get operationV2 => $_getN(16);
  @$pb.TagNumber(17)
  set operationV2(OperationV2 value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasOperationV2() => $_has(16);
  @$pb.TagNumber(17)
  void clearOperationV2() => $_clearField(17);
  @$pb.TagNumber(17)
  OperationV2 ensureOperationV2() => $_ensure(16);

  @$pb.TagNumber(18)
  Mode get mode => $_getN(17);
  @$pb.TagNumber(18)
  set mode(Mode value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasMode() => $_has(17);
  @$pb.TagNumber(18)
  void clearMode() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get modeText => $_getSZ(18);
  @$pb.TagNumber(19)
  set modeText($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasModeText() => $_has(18);
  @$pb.TagNumber(19)
  void clearModeText() => $_clearField(19);

  @$pb.TagNumber(20)
  $2.FeedPaginationReply get paginationReply => $_getN(19);
  @$pb.TagNumber(20)
  set paginationReply($2.FeedPaginationReply value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasPaginationReply() => $_has(19);
  @$pb.TagNumber(20)
  void clearPaginationReply() => $_clearField(20);
  @$pb.TagNumber(20)
  $2.FeedPaginationReply ensurePaginationReply() => $_ensure(19);

  @$pb.TagNumber(21)
  $core.String get sessionId => $_getSZ(20);
  @$pb.TagNumber(21)
  set sessionId($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasSessionId() => $_has(20);
  @$pb.TagNumber(21)
  void clearSessionId() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.String get reportParams => $_getSZ(21);
  @$pb.TagNumber(22)
  set reportParams($core.String value) => $_setString(21, value);
  @$pb.TagNumber(22)
  $core.bool hasReportParams() => $_has(21);
  @$pb.TagNumber(22)
  void clearReportParams() => $_clearField(22);

  @$pb.TagNumber(23)
  VoteCard get voteCard => $_getN(22);
  @$pb.TagNumber(23)
  set voteCard(VoteCard value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasVoteCard() => $_has(22);
  @$pb.TagNumber(23)
  void clearVoteCard() => $_clearField(23);
  @$pb.TagNumber(23)
  VoteCard ensureVoteCard() => $_ensure(22);

  @$pb.TagNumber(24)
  ESportsGradeCard get esportsGradeCard => $_getN(23);
  @$pb.TagNumber(24)
  set esportsGradeCard(ESportsGradeCard value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasEsportsGradeCard() => $_has(23);
  @$pb.TagNumber(24)
  void clearEsportsGradeCard() => $_clearField(24);
  @$pb.TagNumber(24)
  ESportsGradeCard ensureEsportsGradeCard() => $_ensure(23);

  @$pb.TagNumber(25)
  $core.String get contextFeature => $_getSZ(24);
  @$pb.TagNumber(25)
  set contextFeature($core.String value) => $_setString(24, value);
  @$pb.TagNumber(25)
  $core.bool hasContextFeature() => $_has(24);
  @$pb.TagNumber(25)
  void clearContextFeature() => $_clearField(25);

  @$pb.TagNumber(26)
  $core.String get paginationEndText => $_getSZ(25);
  @$pb.TagNumber(26)
  set paginationEndText($core.String value) => $_setString(25, value);
  @$pb.TagNumber(26)
  $core.bool hasPaginationEndText() => $_has(25);
  @$pb.TagNumber(26)
  void clearPaginationEndText() => $_clearField(26);

  @$pb.TagNumber(27)
  $pb.PbList<MixedCard> get mixedCards => $_getList(26);

  @$pb.TagNumber(28)
  $pb.PbList<SubjectTopCards> get subjectTopCards => $_getList(27);
}

class MainListReq extends $pb.GeneratedMessage {
  factory MainListReq({
    $fixnum.Int64? oid,
    $fixnum.Int64? type,
    CursorReq? cursor,
    $core.String? extra,
    $core.String? adExtra,
    $fixnum.Int64? rpid,
    $fixnum.Int64? seekRpid,
    $core.String? filterTagName,
    Mode? mode,
    $2.FeedPagination? pagination,
    $core.Iterable<$fixnum.Int64>? clientRecallRpids,
    WordSearchParam? wordSearchParam,
  }) {
    final result = create();
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    if (cursor != null) result.cursor = cursor;
    if (extra != null) result.extra = extra;
    if (adExtra != null) result.adExtra = adExtra;
    if (rpid != null) result.rpid = rpid;
    if (seekRpid != null) result.seekRpid = seekRpid;
    if (filterTagName != null) result.filterTagName = filterTagName;
    if (mode != null) result.mode = mode;
    if (pagination != null) result.pagination = pagination;
    if (clientRecallRpids != null)
      result.clientRecallRpids.addAll(clientRecallRpids);
    if (wordSearchParam != null) result.wordSearchParam = wordSearchParam;
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
    ..aOS(4, _omitFieldNames ? '' : 'extra')
    ..aOS(5, _omitFieldNames ? '' : 'adExtra')
    ..aInt64(6, _omitFieldNames ? '' : 'rpid')
    ..aInt64(7, _omitFieldNames ? '' : 'seekRpid')
    ..aOS(8, _omitFieldNames ? '' : 'filterTagName')
    ..aE<Mode>(9, _omitFieldNames ? '' : 'mode', enumValues: Mode.values)
    ..aOM<$2.FeedPagination>(10, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.FeedPagination.create)
    ..p<$fixnum.Int64>(
        11, _omitFieldNames ? '' : 'clientRecallRpids', $pb.PbFieldType.K6)
    ..aOM<WordSearchParam>(12, _omitFieldNames ? '' : 'wordSearchParam',
        subBuilder: WordSearchParam.create)
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

  @$pb.TagNumber(4)
  $core.String get extra => $_getSZ(3);
  @$pb.TagNumber(4)
  set extra($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExtra() => $_has(3);
  @$pb.TagNumber(4)
  void clearExtra() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get adExtra => $_getSZ(4);
  @$pb.TagNumber(5)
  set adExtra($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAdExtra() => $_has(4);
  @$pb.TagNumber(5)
  void clearAdExtra() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get rpid => $_getI64(5);
  @$pb.TagNumber(6)
  set rpid($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRpid() => $_has(5);
  @$pb.TagNumber(6)
  void clearRpid() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get seekRpid => $_getI64(6);
  @$pb.TagNumber(7)
  set seekRpid($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSeekRpid() => $_has(6);
  @$pb.TagNumber(7)
  void clearSeekRpid() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get filterTagName => $_getSZ(7);
  @$pb.TagNumber(8)
  set filterTagName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFilterTagName() => $_has(7);
  @$pb.TagNumber(8)
  void clearFilterTagName() => $_clearField(8);

  @$pb.TagNumber(9)
  Mode get mode => $_getN(8);
  @$pb.TagNumber(9)
  set mode(Mode value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasMode() => $_has(8);
  @$pb.TagNumber(9)
  void clearMode() => $_clearField(9);

  @$pb.TagNumber(10)
  $2.FeedPagination get pagination => $_getN(9);
  @$pb.TagNumber(10)
  set pagination($2.FeedPagination value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasPagination() => $_has(9);
  @$pb.TagNumber(10)
  void clearPagination() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.FeedPagination ensurePagination() => $_ensure(9);

  @$pb.TagNumber(11)
  $pb.PbList<$fixnum.Int64> get clientRecallRpids => $_getList(10);

  @$pb.TagNumber(12)
  WordSearchParam get wordSearchParam => $_getN(11);
  @$pb.TagNumber(12)
  set wordSearchParam(WordSearchParam value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasWordSearchParam() => $_has(11);
  @$pb.TagNumber(12)
  void clearWordSearchParam() => $_clearField(12);
  @$pb.TagNumber(12)
  WordSearchParam ensureWordSearchParam() => $_ensure(11);
}

class Member_NftInteraction_Region extends $pb.GeneratedMessage {
  factory Member_NftInteraction_Region({
    Member_NftInteraction_RegionType? type,
    $core.String? icon,
    Member_NftInteraction_ShowStatus? showStatus,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (icon != null) result.icon = icon;
    if (showStatus != null) result.showStatus = showStatus;
    return result;
  }

  Member_NftInteraction_Region._();

  factory Member_NftInteraction_Region.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Member_NftInteraction_Region.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Member.NftInteraction.Region',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aE<Member_NftInteraction_RegionType>(1, _omitFieldNames ? '' : 'type',
        enumValues: Member_NftInteraction_RegionType.values)
    ..aOS(2, _omitFieldNames ? '' : 'icon')
    ..aE<Member_NftInteraction_ShowStatus>(
        3, _omitFieldNames ? '' : 'showStatus',
        enumValues: Member_NftInteraction_ShowStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Member_NftInteraction_Region clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Member_NftInteraction_Region copyWith(
          void Function(Member_NftInteraction_Region) updates) =>
      super.copyWith(
              (message) => updates(message as Member_NftInteraction_Region))
          as Member_NftInteraction_Region;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Member_NftInteraction_Region create() =>
      Member_NftInteraction_Region._();
  @$core.override
  Member_NftInteraction_Region createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Member_NftInteraction_Region getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Member_NftInteraction_Region>(create);
  static Member_NftInteraction_Region? _defaultInstance;

  @$pb.TagNumber(1)
  Member_NftInteraction_RegionType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(Member_NftInteraction_RegionType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get icon => $_getSZ(1);
  @$pb.TagNumber(2)
  set icon($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIcon() => $_has(1);
  @$pb.TagNumber(2)
  void clearIcon() => $_clearField(2);

  @$pb.TagNumber(3)
  Member_NftInteraction_ShowStatus get showStatus => $_getN(2);
  @$pb.TagNumber(3)
  set showStatus(Member_NftInteraction_ShowStatus value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasShowStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearShowStatus() => $_clearField(3);
}

class Member_NftInteraction extends $pb.GeneratedMessage {
  factory Member_NftInteraction({
    $core.String? itype,
    $core.String? metadataUrl,
    $core.String? nftId,
    Member_NftInteraction_Region? region,
  }) {
    final result = create();
    if (itype != null) result.itype = itype;
    if (metadataUrl != null) result.metadataUrl = metadataUrl;
    if (nftId != null) result.nftId = nftId;
    if (region != null) result.region = region;
    return result;
  }

  Member_NftInteraction._();

  factory Member_NftInteraction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Member_NftInteraction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Member.NftInteraction',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itype')
    ..aOS(2, _omitFieldNames ? '' : 'metadataUrl')
    ..aOS(3, _omitFieldNames ? '' : 'nftId')
    ..aOM<Member_NftInteraction_Region>(4, _omitFieldNames ? '' : 'region',
        subBuilder: Member_NftInteraction_Region.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Member_NftInteraction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Member_NftInteraction copyWith(
          void Function(Member_NftInteraction) updates) =>
      super.copyWith((message) => updates(message as Member_NftInteraction))
          as Member_NftInteraction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Member_NftInteraction create() => Member_NftInteraction._();
  @$core.override
  Member_NftInteraction createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Member_NftInteraction getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Member_NftInteraction>(create);
  static Member_NftInteraction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itype => $_getSZ(0);
  @$pb.TagNumber(1)
  set itype($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItype() => $_has(0);
  @$pb.TagNumber(1)
  void clearItype() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get metadataUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set metadataUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMetadataUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetadataUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get nftId => $_getSZ(2);
  @$pb.TagNumber(3)
  set nftId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNftId() => $_has(2);
  @$pb.TagNumber(3)
  void clearNftId() => $_clearField(3);

  @$pb.TagNumber(4)
  Member_NftInteraction_Region get region => $_getN(3);
  @$pb.TagNumber(4)
  set region(Member_NftInteraction_Region value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRegion() => $_has(3);
  @$pb.TagNumber(4)
  void clearRegion() => $_clearField(4);
  @$pb.TagNumber(4)
  Member_NftInteraction_Region ensureRegion() => $_ensure(3);
}

class Member extends $pb.GeneratedMessage {
  factory Member({
    $fixnum.Int64? mid,
    $core.String? name,
    $core.String? sex,
    $core.String? face,
    $fixnum.Int64? level,
    $fixnum.Int64? officialVerifyType,
    $fixnum.Int64? vipType,
    $fixnum.Int64? vipStatus,
    $fixnum.Int64? vipThemeType,
    $core.String? vipLabelPath,
    $core.String? garbPendantImage,
    $core.String? garbCardImage,
    $core.String? garbCardImageWithFocus,
    $core.String? garbCardJumpUrl,
    $core.String? garbCardNumber,
    $core.String? garbCardFanColor,
    $core.bool? garbCardIsFan,
    $core.String? fansMedalName,
    $fixnum.Int64? fansMedalLevel,
    $fixnum.Int64? fansMedalColor,
    $core.String? vipNicknameColor,
    $core.int? vipAvatarSubscript,
    $core.String? vipLabelText,
    $core.String? vipLabelTheme,
    $fixnum.Int64? fansMedalColorEnd,
    $fixnum.Int64? fansMedalColorBorder,
    $fixnum.Int64? fansMedalColorName,
    $fixnum.Int64? fansMedalColorLevel,
    $fixnum.Int64? fansGuardLevel,
    $core.int? faceNft,
    $core.int? faceNftNew,
    $core.int? isSeniorMember,
    Member_NftInteraction? nftInteraction,
    $core.String? fansGuardIcon,
    $core.String? fansHonorIcon,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    if (name != null) result.name = name;
    if (sex != null) result.sex = sex;
    if (face != null) result.face = face;
    if (level != null) result.level = level;
    if (officialVerifyType != null)
      result.officialVerifyType = officialVerifyType;
    if (vipType != null) result.vipType = vipType;
    if (vipStatus != null) result.vipStatus = vipStatus;
    if (vipThemeType != null) result.vipThemeType = vipThemeType;
    if (vipLabelPath != null) result.vipLabelPath = vipLabelPath;
    if (garbPendantImage != null) result.garbPendantImage = garbPendantImage;
    if (garbCardImage != null) result.garbCardImage = garbCardImage;
    if (garbCardImageWithFocus != null)
      result.garbCardImageWithFocus = garbCardImageWithFocus;
    if (garbCardJumpUrl != null) result.garbCardJumpUrl = garbCardJumpUrl;
    if (garbCardNumber != null) result.garbCardNumber = garbCardNumber;
    if (garbCardFanColor != null) result.garbCardFanColor = garbCardFanColor;
    if (garbCardIsFan != null) result.garbCardIsFan = garbCardIsFan;
    if (fansMedalName != null) result.fansMedalName = fansMedalName;
    if (fansMedalLevel != null) result.fansMedalLevel = fansMedalLevel;
    if (fansMedalColor != null) result.fansMedalColor = fansMedalColor;
    if (vipNicknameColor != null) result.vipNicknameColor = vipNicknameColor;
    if (vipAvatarSubscript != null)
      result.vipAvatarSubscript = vipAvatarSubscript;
    if (vipLabelText != null) result.vipLabelText = vipLabelText;
    if (vipLabelTheme != null) result.vipLabelTheme = vipLabelTheme;
    if (fansMedalColorEnd != null) result.fansMedalColorEnd = fansMedalColorEnd;
    if (fansMedalColorBorder != null)
      result.fansMedalColorBorder = fansMedalColorBorder;
    if (fansMedalColorName != null)
      result.fansMedalColorName = fansMedalColorName;
    if (fansMedalColorLevel != null)
      result.fansMedalColorLevel = fansMedalColorLevel;
    if (fansGuardLevel != null) result.fansGuardLevel = fansGuardLevel;
    if (faceNft != null) result.faceNft = faceNft;
    if (faceNftNew != null) result.faceNftNew = faceNftNew;
    if (isSeniorMember != null) result.isSeniorMember = isSeniorMember;
    if (nftInteraction != null) result.nftInteraction = nftInteraction;
    if (fansGuardIcon != null) result.fansGuardIcon = fansGuardIcon;
    if (fansHonorIcon != null) result.fansHonorIcon = fansHonorIcon;
    return result;
  }

  Member._();

  factory Member.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Member.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Member',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'sex')
    ..aOS(4, _omitFieldNames ? '' : 'face')
    ..aInt64(5, _omitFieldNames ? '' : 'level')
    ..aInt64(6, _omitFieldNames ? '' : 'officialVerifyType')
    ..aInt64(7, _omitFieldNames ? '' : 'vipType')
    ..aInt64(8, _omitFieldNames ? '' : 'vipStatus')
    ..aInt64(9, _omitFieldNames ? '' : 'vipThemeType')
    ..aOS(10, _omitFieldNames ? '' : 'vipLabelPath')
    ..aOS(11, _omitFieldNames ? '' : 'garbPendantImage')
    ..aOS(12, _omitFieldNames ? '' : 'garbCardImage')
    ..aOS(13, _omitFieldNames ? '' : 'garbCardImageWithFocus')
    ..aOS(14, _omitFieldNames ? '' : 'garbCardJumpUrl')
    ..aOS(15, _omitFieldNames ? '' : 'garbCardNumber')
    ..aOS(16, _omitFieldNames ? '' : 'garbCardFanColor')
    ..aOB(17, _omitFieldNames ? '' : 'garbCardIsFan')
    ..aOS(18, _omitFieldNames ? '' : 'fansMedalName')
    ..aInt64(19, _omitFieldNames ? '' : 'fansMedalLevel')
    ..aInt64(20, _omitFieldNames ? '' : 'fansMedalColor')
    ..aOS(21, _omitFieldNames ? '' : 'vipNicknameColor')
    ..aI(22, _omitFieldNames ? '' : 'vipAvatarSubscript')
    ..aOS(23, _omitFieldNames ? '' : 'vipLabelText')
    ..aOS(24, _omitFieldNames ? '' : 'vipLabelTheme')
    ..aInt64(25, _omitFieldNames ? '' : 'fansMedalColorEnd')
    ..aInt64(26, _omitFieldNames ? '' : 'fansMedalColorBorder')
    ..aInt64(27, _omitFieldNames ? '' : 'fansMedalColorName')
    ..aInt64(28, _omitFieldNames ? '' : 'fansMedalColorLevel')
    ..aInt64(29, _omitFieldNames ? '' : 'fansGuardLevel')
    ..aI(30, _omitFieldNames ? '' : 'faceNft')
    ..aI(31, _omitFieldNames ? '' : 'faceNftNew')
    ..aI(32, _omitFieldNames ? '' : 'isSeniorMember')
    ..aOM<Member_NftInteraction>(33, _omitFieldNames ? '' : 'nftInteraction',
        subBuilder: Member_NftInteraction.create)
    ..aOS(34, _omitFieldNames ? '' : 'fansGuardIcon')
    ..aOS(35, _omitFieldNames ? '' : 'fansHonorIcon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Member clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Member copyWith(void Function(Member) updates) =>
      super.copyWith((message) => updates(message as Member)) as Member;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Member create() => Member._();
  @$core.override
  Member createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Member getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Member>(create);
  static Member? _defaultInstance;

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
  $core.String get sex => $_getSZ(2);
  @$pb.TagNumber(3)
  set sex($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSex() => $_has(2);
  @$pb.TagNumber(3)
  void clearSex() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get face => $_getSZ(3);
  @$pb.TagNumber(4)
  set face($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFace() => $_has(3);
  @$pb.TagNumber(4)
  void clearFace() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get level => $_getI64(4);
  @$pb.TagNumber(5)
  set level($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLevel() => $_has(4);
  @$pb.TagNumber(5)
  void clearLevel() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get officialVerifyType => $_getI64(5);
  @$pb.TagNumber(6)
  set officialVerifyType($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOfficialVerifyType() => $_has(5);
  @$pb.TagNumber(6)
  void clearOfficialVerifyType() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get vipType => $_getI64(6);
  @$pb.TagNumber(7)
  set vipType($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVipType() => $_has(6);
  @$pb.TagNumber(7)
  void clearVipType() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get vipStatus => $_getI64(7);
  @$pb.TagNumber(8)
  set vipStatus($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVipStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearVipStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get vipThemeType => $_getI64(8);
  @$pb.TagNumber(9)
  set vipThemeType($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasVipThemeType() => $_has(8);
  @$pb.TagNumber(9)
  void clearVipThemeType() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get vipLabelPath => $_getSZ(9);
  @$pb.TagNumber(10)
  set vipLabelPath($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVipLabelPath() => $_has(9);
  @$pb.TagNumber(10)
  void clearVipLabelPath() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get garbPendantImage => $_getSZ(10);
  @$pb.TagNumber(11)
  set garbPendantImage($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasGarbPendantImage() => $_has(10);
  @$pb.TagNumber(11)
  void clearGarbPendantImage() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get garbCardImage => $_getSZ(11);
  @$pb.TagNumber(12)
  set garbCardImage($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasGarbCardImage() => $_has(11);
  @$pb.TagNumber(12)
  void clearGarbCardImage() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get garbCardImageWithFocus => $_getSZ(12);
  @$pb.TagNumber(13)
  set garbCardImageWithFocus($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasGarbCardImageWithFocus() => $_has(12);
  @$pb.TagNumber(13)
  void clearGarbCardImageWithFocus() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get garbCardJumpUrl => $_getSZ(13);
  @$pb.TagNumber(14)
  set garbCardJumpUrl($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasGarbCardJumpUrl() => $_has(13);
  @$pb.TagNumber(14)
  void clearGarbCardJumpUrl() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get garbCardNumber => $_getSZ(14);
  @$pb.TagNumber(15)
  set garbCardNumber($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasGarbCardNumber() => $_has(14);
  @$pb.TagNumber(15)
  void clearGarbCardNumber() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get garbCardFanColor => $_getSZ(15);
  @$pb.TagNumber(16)
  set garbCardFanColor($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasGarbCardFanColor() => $_has(15);
  @$pb.TagNumber(16)
  void clearGarbCardFanColor() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.bool get garbCardIsFan => $_getBF(16);
  @$pb.TagNumber(17)
  set garbCardIsFan($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasGarbCardIsFan() => $_has(16);
  @$pb.TagNumber(17)
  void clearGarbCardIsFan() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get fansMedalName => $_getSZ(17);
  @$pb.TagNumber(18)
  set fansMedalName($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasFansMedalName() => $_has(17);
  @$pb.TagNumber(18)
  void clearFansMedalName() => $_clearField(18);

  @$pb.TagNumber(19)
  $fixnum.Int64 get fansMedalLevel => $_getI64(18);
  @$pb.TagNumber(19)
  set fansMedalLevel($fixnum.Int64 value) => $_setInt64(18, value);
  @$pb.TagNumber(19)
  $core.bool hasFansMedalLevel() => $_has(18);
  @$pb.TagNumber(19)
  void clearFansMedalLevel() => $_clearField(19);

  @$pb.TagNumber(20)
  $fixnum.Int64 get fansMedalColor => $_getI64(19);
  @$pb.TagNumber(20)
  set fansMedalColor($fixnum.Int64 value) => $_setInt64(19, value);
  @$pb.TagNumber(20)
  $core.bool hasFansMedalColor() => $_has(19);
  @$pb.TagNumber(20)
  void clearFansMedalColor() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get vipNicknameColor => $_getSZ(20);
  @$pb.TagNumber(21)
  set vipNicknameColor($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasVipNicknameColor() => $_has(20);
  @$pb.TagNumber(21)
  void clearVipNicknameColor() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.int get vipAvatarSubscript => $_getIZ(21);
  @$pb.TagNumber(22)
  set vipAvatarSubscript($core.int value) => $_setSignedInt32(21, value);
  @$pb.TagNumber(22)
  $core.bool hasVipAvatarSubscript() => $_has(21);
  @$pb.TagNumber(22)
  void clearVipAvatarSubscript() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.String get vipLabelText => $_getSZ(22);
  @$pb.TagNumber(23)
  set vipLabelText($core.String value) => $_setString(22, value);
  @$pb.TagNumber(23)
  $core.bool hasVipLabelText() => $_has(22);
  @$pb.TagNumber(23)
  void clearVipLabelText() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.String get vipLabelTheme => $_getSZ(23);
  @$pb.TagNumber(24)
  set vipLabelTheme($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasVipLabelTheme() => $_has(23);
  @$pb.TagNumber(24)
  void clearVipLabelTheme() => $_clearField(24);

  @$pb.TagNumber(25)
  $fixnum.Int64 get fansMedalColorEnd => $_getI64(24);
  @$pb.TagNumber(25)
  set fansMedalColorEnd($fixnum.Int64 value) => $_setInt64(24, value);
  @$pb.TagNumber(25)
  $core.bool hasFansMedalColorEnd() => $_has(24);
  @$pb.TagNumber(25)
  void clearFansMedalColorEnd() => $_clearField(25);

  @$pb.TagNumber(26)
  $fixnum.Int64 get fansMedalColorBorder => $_getI64(25);
  @$pb.TagNumber(26)
  set fansMedalColorBorder($fixnum.Int64 value) => $_setInt64(25, value);
  @$pb.TagNumber(26)
  $core.bool hasFansMedalColorBorder() => $_has(25);
  @$pb.TagNumber(26)
  void clearFansMedalColorBorder() => $_clearField(26);

  @$pb.TagNumber(27)
  $fixnum.Int64 get fansMedalColorName => $_getI64(26);
  @$pb.TagNumber(27)
  set fansMedalColorName($fixnum.Int64 value) => $_setInt64(26, value);
  @$pb.TagNumber(27)
  $core.bool hasFansMedalColorName() => $_has(26);
  @$pb.TagNumber(27)
  void clearFansMedalColorName() => $_clearField(27);

  @$pb.TagNumber(28)
  $fixnum.Int64 get fansMedalColorLevel => $_getI64(27);
  @$pb.TagNumber(28)
  set fansMedalColorLevel($fixnum.Int64 value) => $_setInt64(27, value);
  @$pb.TagNumber(28)
  $core.bool hasFansMedalColorLevel() => $_has(27);
  @$pb.TagNumber(28)
  void clearFansMedalColorLevel() => $_clearField(28);

  @$pb.TagNumber(29)
  $fixnum.Int64 get fansGuardLevel => $_getI64(28);
  @$pb.TagNumber(29)
  set fansGuardLevel($fixnum.Int64 value) => $_setInt64(28, value);
  @$pb.TagNumber(29)
  $core.bool hasFansGuardLevel() => $_has(28);
  @$pb.TagNumber(29)
  void clearFansGuardLevel() => $_clearField(29);

  @$pb.TagNumber(30)
  $core.int get faceNft => $_getIZ(29);
  @$pb.TagNumber(30)
  set faceNft($core.int value) => $_setSignedInt32(29, value);
  @$pb.TagNumber(30)
  $core.bool hasFaceNft() => $_has(29);
  @$pb.TagNumber(30)
  void clearFaceNft() => $_clearField(30);

  @$pb.TagNumber(31)
  $core.int get faceNftNew => $_getIZ(30);
  @$pb.TagNumber(31)
  set faceNftNew($core.int value) => $_setSignedInt32(30, value);
  @$pb.TagNumber(31)
  $core.bool hasFaceNftNew() => $_has(30);
  @$pb.TagNumber(31)
  void clearFaceNftNew() => $_clearField(31);

  @$pb.TagNumber(32)
  $core.int get isSeniorMember => $_getIZ(31);
  @$pb.TagNumber(32)
  set isSeniorMember($core.int value) => $_setSignedInt32(31, value);
  @$pb.TagNumber(32)
  $core.bool hasIsSeniorMember() => $_has(31);
  @$pb.TagNumber(32)
  void clearIsSeniorMember() => $_clearField(32);

  @$pb.TagNumber(33)
  Member_NftInteraction get nftInteraction => $_getN(32);
  @$pb.TagNumber(33)
  set nftInteraction(Member_NftInteraction value) => $_setField(33, value);
  @$pb.TagNumber(33)
  $core.bool hasNftInteraction() => $_has(32);
  @$pb.TagNumber(33)
  void clearNftInteraction() => $_clearField(33);
  @$pb.TagNumber(33)
  Member_NftInteraction ensureNftInteraction() => $_ensure(32);

  @$pb.TagNumber(34)
  $core.String get fansGuardIcon => $_getSZ(33);
  @$pb.TagNumber(34)
  set fansGuardIcon($core.String value) => $_setString(33, value);
  @$pb.TagNumber(34)
  $core.bool hasFansGuardIcon() => $_has(33);
  @$pb.TagNumber(34)
  void clearFansGuardIcon() => $_clearField(34);

  @$pb.TagNumber(35)
  $core.String get fansHonorIcon => $_getSZ(34);
  @$pb.TagNumber(35)
  set fansHonorIcon($core.String value) => $_setString(34, value);
  @$pb.TagNumber(35)
  $core.bool hasFansHonorIcon() => $_has(34);
  @$pb.TagNumber(35)
  void clearFansHonorIcon() => $_clearField(35);
}

class MemberV2_Basic extends $pb.GeneratedMessage {
  factory MemberV2_Basic({
    $fixnum.Int64? mid,
    $core.String? name,
    $core.String? sex,
    $core.String? face,
    $fixnum.Int64? level,
    $4.AvatarItem? avatarItem,
    $5.NameRender? nameRender,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    if (name != null) result.name = name;
    if (sex != null) result.sex = sex;
    if (face != null) result.face = face;
    if (level != null) result.level = level;
    if (avatarItem != null) result.avatarItem = avatarItem;
    if (nameRender != null) result.nameRender = nameRender;
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
    ..aOS(3, _omitFieldNames ? '' : 'sex')
    ..aOS(4, _omitFieldNames ? '' : 'face')
    ..aInt64(5, _omitFieldNames ? '' : 'level')
    ..aOM<$4.AvatarItem>(6, _omitFieldNames ? '' : 'avatarItem',
        subBuilder: $4.AvatarItem.create)
    ..aOM<$5.NameRender>(7, _omitFieldNames ? '' : 'nameRender',
        subBuilder: $5.NameRender.create)
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

  @$pb.TagNumber(3)
  $core.String get sex => $_getSZ(2);
  @$pb.TagNumber(3)
  set sex($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSex() => $_has(2);
  @$pb.TagNumber(3)
  void clearSex() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get face => $_getSZ(3);
  @$pb.TagNumber(4)
  set face($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFace() => $_has(3);
  @$pb.TagNumber(4)
  void clearFace() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get level => $_getI64(4);
  @$pb.TagNumber(5)
  set level($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLevel() => $_has(4);
  @$pb.TagNumber(5)
  void clearLevel() => $_clearField(5);

  @$pb.TagNumber(6)
  $4.AvatarItem get avatarItem => $_getN(5);
  @$pb.TagNumber(6)
  set avatarItem($4.AvatarItem value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAvatarItem() => $_has(5);
  @$pb.TagNumber(6)
  void clearAvatarItem() => $_clearField(6);
  @$pb.TagNumber(6)
  $4.AvatarItem ensureAvatarItem() => $_ensure(5);

  @$pb.TagNumber(7)
  $5.NameRender get nameRender => $_getN(6);
  @$pb.TagNumber(7)
  set nameRender($5.NameRender value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasNameRender() => $_has(6);
  @$pb.TagNumber(7)
  void clearNameRender() => $_clearField(7);
  @$pb.TagNumber(7)
  $5.NameRender ensureNameRender() => $_ensure(6);
}

class MemberV2_Contractor extends $pb.GeneratedMessage {
  factory MemberV2_Contractor({
    $core.bool? isContractor,
    $core.String? contractDesc,
  }) {
    final result = create();
    if (isContractor != null) result.isContractor = isContractor;
    if (contractDesc != null) result.contractDesc = contractDesc;
    return result;
  }

  MemberV2_Contractor._();

  factory MemberV2_Contractor.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MemberV2_Contractor.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MemberV2.Contractor',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'isContractor')
    ..aOS(2, _omitFieldNames ? '' : 'contractDesc')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Contractor clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Contractor copyWith(void Function(MemberV2_Contractor) updates) =>
      super.copyWith((message) => updates(message as MemberV2_Contractor))
          as MemberV2_Contractor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MemberV2_Contractor create() => MemberV2_Contractor._();
  @$core.override
  MemberV2_Contractor createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MemberV2_Contractor getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MemberV2_Contractor>(create);
  static MemberV2_Contractor? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isContractor => $_getBF(0);
  @$pb.TagNumber(1)
  set isContractor($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsContractor() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsContractor() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get contractDesc => $_getSZ(1);
  @$pb.TagNumber(2)
  set contractDesc($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContractDesc() => $_has(1);
  @$pb.TagNumber(2)
  void clearContractDesc() => $_clearField(2);
}

class MemberV2_Garb_FanNumColorFormat extends $pb.GeneratedMessage {
  factory MemberV2_Garb_FanNumColorFormat({
    $core.String? startPoint,
    $core.String? endPoint,
    $core.Iterable<$core.String>? colors,
    $core.Iterable<$fixnum.Int64>? gradients,
  }) {
    final result = create();
    if (startPoint != null) result.startPoint = startPoint;
    if (endPoint != null) result.endPoint = endPoint;
    if (colors != null) result.colors.addAll(colors);
    if (gradients != null) result.gradients.addAll(gradients);
    return result;
  }

  MemberV2_Garb_FanNumColorFormat._();

  factory MemberV2_Garb_FanNumColorFormat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MemberV2_Garb_FanNumColorFormat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MemberV2.Garb.FanNumColorFormat',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'startPoint')
    ..aOS(2, _omitFieldNames ? '' : 'endPoint')
    ..pPS(3, _omitFieldNames ? '' : 'colors')
    ..p<$fixnum.Int64>(
        4, _omitFieldNames ? '' : 'gradients', $pb.PbFieldType.K6)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Garb_FanNumColorFormat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Garb_FanNumColorFormat copyWith(
          void Function(MemberV2_Garb_FanNumColorFormat) updates) =>
      super.copyWith(
              (message) => updates(message as MemberV2_Garb_FanNumColorFormat))
          as MemberV2_Garb_FanNumColorFormat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MemberV2_Garb_FanNumColorFormat create() =>
      MemberV2_Garb_FanNumColorFormat._();
  @$core.override
  MemberV2_Garb_FanNumColorFormat createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MemberV2_Garb_FanNumColorFormat getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MemberV2_Garb_FanNumColorFormat>(
          create);
  static MemberV2_Garb_FanNumColorFormat? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get startPoint => $_getSZ(0);
  @$pb.TagNumber(1)
  set startPoint($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStartPoint() => $_has(0);
  @$pb.TagNumber(1)
  void clearStartPoint() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get endPoint => $_getSZ(1);
  @$pb.TagNumber(2)
  set endPoint($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEndPoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndPoint() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get colors => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$fixnum.Int64> get gradients => $_getList(3);
}

class MemberV2_Garb extends $pb.GeneratedMessage {
  factory MemberV2_Garb({
    $core.String? pendantImage,
    $core.String? cardImage,
    $core.String? cardImageWithFocus,
    $core.String? cardJumpUrl,
    $core.String? cardNumber,
    $core.String? cardFanColor,
    $core.bool? cardIsFan,
    $core.String? fanNumPrefix,
    MemberV2_Garb_FanNumColorFormat? fanNumColorFormat,
  }) {
    final result = create();
    if (pendantImage != null) result.pendantImage = pendantImage;
    if (cardImage != null) result.cardImage = cardImage;
    if (cardImageWithFocus != null)
      result.cardImageWithFocus = cardImageWithFocus;
    if (cardJumpUrl != null) result.cardJumpUrl = cardJumpUrl;
    if (cardNumber != null) result.cardNumber = cardNumber;
    if (cardFanColor != null) result.cardFanColor = cardFanColor;
    if (cardIsFan != null) result.cardIsFan = cardIsFan;
    if (fanNumPrefix != null) result.fanNumPrefix = fanNumPrefix;
    if (fanNumColorFormat != null) result.fanNumColorFormat = fanNumColorFormat;
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
    ..aOS(3, _omitFieldNames ? '' : 'cardImageWithFocus')
    ..aOS(4, _omitFieldNames ? '' : 'cardJumpUrl')
    ..aOS(5, _omitFieldNames ? '' : 'cardNumber')
    ..aOS(6, _omitFieldNames ? '' : 'cardFanColor')
    ..aOB(7, _omitFieldNames ? '' : 'cardIsFan')
    ..aOS(8, _omitFieldNames ? '' : 'fanNumPrefix')
    ..aOM<MemberV2_Garb_FanNumColorFormat>(
        9, _omitFieldNames ? '' : 'fanNumColorFormat',
        subBuilder: MemberV2_Garb_FanNumColorFormat.create)
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

  @$pb.TagNumber(3)
  $core.String get cardImageWithFocus => $_getSZ(2);
  @$pb.TagNumber(3)
  set cardImageWithFocus($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCardImageWithFocus() => $_has(2);
  @$pb.TagNumber(3)
  void clearCardImageWithFocus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get cardJumpUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set cardJumpUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCardJumpUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearCardJumpUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get cardNumber => $_getSZ(4);
  @$pb.TagNumber(5)
  set cardNumber($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCardNumber() => $_has(4);
  @$pb.TagNumber(5)
  void clearCardNumber() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get cardFanColor => $_getSZ(5);
  @$pb.TagNumber(6)
  set cardFanColor($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCardFanColor() => $_has(5);
  @$pb.TagNumber(6)
  void clearCardFanColor() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get cardIsFan => $_getBF(6);
  @$pb.TagNumber(7)
  set cardIsFan($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCardIsFan() => $_has(6);
  @$pb.TagNumber(7)
  void clearCardIsFan() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get fanNumPrefix => $_getSZ(7);
  @$pb.TagNumber(8)
  set fanNumPrefix($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFanNumPrefix() => $_has(7);
  @$pb.TagNumber(8)
  void clearFanNumPrefix() => $_clearField(8);

  @$pb.TagNumber(9)
  MemberV2_Garb_FanNumColorFormat get fanNumColorFormat => $_getN(8);
  @$pb.TagNumber(9)
  set fanNumColorFormat(MemberV2_Garb_FanNumColorFormat value) =>
      $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasFanNumColorFormat() => $_has(8);
  @$pb.TagNumber(9)
  void clearFanNumColorFormat() => $_clearField(9);
  @$pb.TagNumber(9)
  MemberV2_Garb_FanNumColorFormat ensureFanNumColorFormat() => $_ensure(8);
}

class MemberV2_Medal extends $pb.GeneratedMessage {
  factory MemberV2_Medal({
    $core.String? name,
    $fixnum.Int64? level,
    $fixnum.Int64? colorStart,
    $fixnum.Int64? colorEnd,
    $fixnum.Int64? colorBorder,
    $fixnum.Int64? colorName,
    $fixnum.Int64? colorLevel,
    $fixnum.Int64? guardLevel,
    $core.String? firstIcon,
    $core.String? secondIcon,
    $fixnum.Int64? levelBgColor,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (level != null) result.level = level;
    if (colorStart != null) result.colorStart = colorStart;
    if (colorEnd != null) result.colorEnd = colorEnd;
    if (colorBorder != null) result.colorBorder = colorBorder;
    if (colorName != null) result.colorName = colorName;
    if (colorLevel != null) result.colorLevel = colorLevel;
    if (guardLevel != null) result.guardLevel = guardLevel;
    if (firstIcon != null) result.firstIcon = firstIcon;
    if (secondIcon != null) result.secondIcon = secondIcon;
    if (levelBgColor != null) result.levelBgColor = levelBgColor;
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
    ..aInt64(4, _omitFieldNames ? '' : 'colorEnd')
    ..aInt64(5, _omitFieldNames ? '' : 'colorBorder')
    ..aInt64(6, _omitFieldNames ? '' : 'colorName')
    ..aInt64(7, _omitFieldNames ? '' : 'colorLevel')
    ..aInt64(8, _omitFieldNames ? '' : 'guardLevel')
    ..aOS(9, _omitFieldNames ? '' : 'firstIcon')
    ..aOS(10, _omitFieldNames ? '' : 'secondIcon')
    ..aInt64(11, _omitFieldNames ? '' : 'levelBgColor')
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

  @$pb.TagNumber(4)
  $fixnum.Int64 get colorEnd => $_getI64(3);
  @$pb.TagNumber(4)
  set colorEnd($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasColorEnd() => $_has(3);
  @$pb.TagNumber(4)
  void clearColorEnd() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get colorBorder => $_getI64(4);
  @$pb.TagNumber(5)
  set colorBorder($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasColorBorder() => $_has(4);
  @$pb.TagNumber(5)
  void clearColorBorder() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get colorName => $_getI64(5);
  @$pb.TagNumber(6)
  set colorName($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasColorName() => $_has(5);
  @$pb.TagNumber(6)
  void clearColorName() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get colorLevel => $_getI64(6);
  @$pb.TagNumber(7)
  set colorLevel($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasColorLevel() => $_has(6);
  @$pb.TagNumber(7)
  void clearColorLevel() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get guardLevel => $_getI64(7);
  @$pb.TagNumber(8)
  set guardLevel($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasGuardLevel() => $_has(7);
  @$pb.TagNumber(8)
  void clearGuardLevel() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get firstIcon => $_getSZ(8);
  @$pb.TagNumber(9)
  set firstIcon($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFirstIcon() => $_has(8);
  @$pb.TagNumber(9)
  void clearFirstIcon() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get secondIcon => $_getSZ(9);
  @$pb.TagNumber(10)
  set secondIcon($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSecondIcon() => $_has(9);
  @$pb.TagNumber(10)
  void clearSecondIcon() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get levelBgColor => $_getI64(10);
  @$pb.TagNumber(11)
  set levelBgColor($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasLevelBgColor() => $_has(10);
  @$pb.TagNumber(11)
  void clearLevelBgColor() => $_clearField(11);
}

class MemberV2_Nft_Interaction_Region extends $pb.GeneratedMessage {
  factory MemberV2_Nft_Interaction_Region({
    MemberV2_Nft_Interaction_RegionType? type,
    $core.String? icon,
    MemberV2_Nft_Interaction_ShowStatus? showStatus,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (icon != null) result.icon = icon;
    if (showStatus != null) result.showStatus = showStatus;
    return result;
  }

  MemberV2_Nft_Interaction_Region._();

  factory MemberV2_Nft_Interaction_Region.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MemberV2_Nft_Interaction_Region.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MemberV2.Nft.Interaction.Region',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aE<MemberV2_Nft_Interaction_RegionType>(1, _omitFieldNames ? '' : 'type',
        enumValues: MemberV2_Nft_Interaction_RegionType.values)
    ..aOS(2, _omitFieldNames ? '' : 'icon')
    ..aE<MemberV2_Nft_Interaction_ShowStatus>(
        3, _omitFieldNames ? '' : 'showStatus',
        enumValues: MemberV2_Nft_Interaction_ShowStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Nft_Interaction_Region clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Nft_Interaction_Region copyWith(
          void Function(MemberV2_Nft_Interaction_Region) updates) =>
      super.copyWith(
              (message) => updates(message as MemberV2_Nft_Interaction_Region))
          as MemberV2_Nft_Interaction_Region;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MemberV2_Nft_Interaction_Region create() =>
      MemberV2_Nft_Interaction_Region._();
  @$core.override
  MemberV2_Nft_Interaction_Region createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MemberV2_Nft_Interaction_Region getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MemberV2_Nft_Interaction_Region>(
          create);
  static MemberV2_Nft_Interaction_Region? _defaultInstance;

  @$pb.TagNumber(1)
  MemberV2_Nft_Interaction_RegionType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(MemberV2_Nft_Interaction_RegionType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get icon => $_getSZ(1);
  @$pb.TagNumber(2)
  set icon($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIcon() => $_has(1);
  @$pb.TagNumber(2)
  void clearIcon() => $_clearField(2);

  @$pb.TagNumber(3)
  MemberV2_Nft_Interaction_ShowStatus get showStatus => $_getN(2);
  @$pb.TagNumber(3)
  set showStatus(MemberV2_Nft_Interaction_ShowStatus value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasShowStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearShowStatus() => $_clearField(3);
}

class MemberV2_Nft_Interaction extends $pb.GeneratedMessage {
  factory MemberV2_Nft_Interaction({
    $core.String? itype,
    $core.String? metadataUrl,
    $core.String? nftId,
    MemberV2_Nft_Interaction_Region? region,
  }) {
    final result = create();
    if (itype != null) result.itype = itype;
    if (metadataUrl != null) result.metadataUrl = metadataUrl;
    if (nftId != null) result.nftId = nftId;
    if (region != null) result.region = region;
    return result;
  }

  MemberV2_Nft_Interaction._();

  factory MemberV2_Nft_Interaction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MemberV2_Nft_Interaction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MemberV2.Nft.Interaction',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itype')
    ..aOS(2, _omitFieldNames ? '' : 'metadataUrl')
    ..aOS(3, _omitFieldNames ? '' : 'nftId')
    ..aOM<MemberV2_Nft_Interaction_Region>(4, _omitFieldNames ? '' : 'region',
        subBuilder: MemberV2_Nft_Interaction_Region.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Nft_Interaction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Nft_Interaction copyWith(
          void Function(MemberV2_Nft_Interaction) updates) =>
      super.copyWith((message) => updates(message as MemberV2_Nft_Interaction))
          as MemberV2_Nft_Interaction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MemberV2_Nft_Interaction create() => MemberV2_Nft_Interaction._();
  @$core.override
  MemberV2_Nft_Interaction createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MemberV2_Nft_Interaction getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MemberV2_Nft_Interaction>(create);
  static MemberV2_Nft_Interaction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itype => $_getSZ(0);
  @$pb.TagNumber(1)
  set itype($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItype() => $_has(0);
  @$pb.TagNumber(1)
  void clearItype() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get metadataUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set metadataUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMetadataUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetadataUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get nftId => $_getSZ(2);
  @$pb.TagNumber(3)
  set nftId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNftId() => $_has(2);
  @$pb.TagNumber(3)
  void clearNftId() => $_clearField(3);

  @$pb.TagNumber(4)
  MemberV2_Nft_Interaction_Region get region => $_getN(3);
  @$pb.TagNumber(4)
  set region(MemberV2_Nft_Interaction_Region value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRegion() => $_has(3);
  @$pb.TagNumber(4)
  void clearRegion() => $_clearField(4);
  @$pb.TagNumber(4)
  MemberV2_Nft_Interaction_Region ensureRegion() => $_ensure(3);
}

class MemberV2_Nft extends $pb.GeneratedMessage {
  factory MemberV2_Nft({
    $core.int? face,
    MemberV2_Nft_Interaction? interaction,
  }) {
    final result = create();
    if (face != null) result.face = face;
    if (interaction != null) result.interaction = interaction;
    return result;
  }

  MemberV2_Nft._();

  factory MemberV2_Nft.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MemberV2_Nft.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MemberV2.Nft',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'face')
    ..aOM<MemberV2_Nft_Interaction>(2, _omitFieldNames ? '' : 'interaction',
        subBuilder: MemberV2_Nft_Interaction.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Nft clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberV2_Nft copyWith(void Function(MemberV2_Nft) updates) =>
      super.copyWith((message) => updates(message as MemberV2_Nft))
          as MemberV2_Nft;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MemberV2_Nft create() => MemberV2_Nft._();
  @$core.override
  MemberV2_Nft createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MemberV2_Nft getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MemberV2_Nft>(create);
  static MemberV2_Nft? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get face => $_getIZ(0);
  @$pb.TagNumber(1)
  set face($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFace() => $_has(0);
  @$pb.TagNumber(1)
  void clearFace() => $_clearField(1);

  @$pb.TagNumber(2)
  MemberV2_Nft_Interaction get interaction => $_getN(1);
  @$pb.TagNumber(2)
  set interaction(MemberV2_Nft_Interaction value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasInteraction() => $_has(1);
  @$pb.TagNumber(2)
  void clearInteraction() => $_clearField(2);
  @$pb.TagNumber(2)
  MemberV2_Nft_Interaction ensureInteraction() => $_ensure(1);
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
    MemberV2_Senior_Status? status,
  }) {
    final result = create();
    if (isSeniorMember != null) result.isSeniorMember = isSeniorMember;
    if (status != null) result.status = status;
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
    ..aE<MemberV2_Senior_Status>(2, _omitFieldNames ? '' : 'status',
        enumValues: MemberV2_Senior_Status.values)
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

  @$pb.TagNumber(2)
  MemberV2_Senior_Status get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(MemberV2_Senior_Status value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);
}

class MemberV2_Vip extends $pb.GeneratedMessage {
  factory MemberV2_Vip({
    $fixnum.Int64? type,
    $fixnum.Int64? status,
    $fixnum.Int64? themeType,
    $core.String? labelPath,
    $core.String? nicknameColor,
    $core.int? avatarSubscript,
    $core.String? labelText,
    $core.String? vipLabelTheme,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (status != null) result.status = status;
    if (themeType != null) result.themeType = themeType;
    if (labelPath != null) result.labelPath = labelPath;
    if (nicknameColor != null) result.nicknameColor = nicknameColor;
    if (avatarSubscript != null) result.avatarSubscript = avatarSubscript;
    if (labelText != null) result.labelText = labelText;
    if (vipLabelTheme != null) result.vipLabelTheme = vipLabelTheme;
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
    ..aInt64(3, _omitFieldNames ? '' : 'themeType')
    ..aOS(4, _omitFieldNames ? '' : 'labelPath')
    ..aOS(5, _omitFieldNames ? '' : 'nicknameColor')
    ..aI(6, _omitFieldNames ? '' : 'avatarSubscript')
    ..aOS(7, _omitFieldNames ? '' : 'labelText')
    ..aOS(8, _omitFieldNames ? '' : 'vipLabelTheme')
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

  @$pb.TagNumber(3)
  $fixnum.Int64 get themeType => $_getI64(2);
  @$pb.TagNumber(3)
  set themeType($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThemeType() => $_has(2);
  @$pb.TagNumber(3)
  void clearThemeType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get labelPath => $_getSZ(3);
  @$pb.TagNumber(4)
  set labelPath($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLabelPath() => $_has(3);
  @$pb.TagNumber(4)
  void clearLabelPath() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get nicknameColor => $_getSZ(4);
  @$pb.TagNumber(5)
  set nicknameColor($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNicknameColor() => $_has(4);
  @$pb.TagNumber(5)
  void clearNicknameColor() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get avatarSubscript => $_getIZ(5);
  @$pb.TagNumber(6)
  set avatarSubscript($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAvatarSubscript() => $_has(5);
  @$pb.TagNumber(6)
  void clearAvatarSubscript() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get labelText => $_getSZ(6);
  @$pb.TagNumber(7)
  set labelText($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLabelText() => $_has(6);
  @$pb.TagNumber(7)
  void clearLabelText() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get vipLabelTheme => $_getSZ(7);
  @$pb.TagNumber(8)
  set vipLabelTheme($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVipLabelTheme() => $_has(7);
  @$pb.TagNumber(8)
  void clearVipLabelTheme() => $_clearField(8);
}

class MemberV2 extends $pb.GeneratedMessage {
  factory MemberV2({
    MemberV2_Basic? basic,
    MemberV2_Official? official,
    MemberV2_Vip? vip,
    MemberV2_Garb? garb,
    MemberV2_Medal? medal,
    MemberV2_Nft? nft,
    MemberV2_Senior? senior,
    MemberV2_Contractor? contractor,
    $3.UserSailing? userSailing,
  }) {
    final result = create();
    if (basic != null) result.basic = basic;
    if (official != null) result.official = official;
    if (vip != null) result.vip = vip;
    if (garb != null) result.garb = garb;
    if (medal != null) result.medal = medal;
    if (nft != null) result.nft = nft;
    if (senior != null) result.senior = senior;
    if (contractor != null) result.contractor = contractor;
    if (userSailing != null) result.userSailing = userSailing;
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
    ..aOM<MemberV2_Nft>(6, _omitFieldNames ? '' : 'nft',
        subBuilder: MemberV2_Nft.create)
    ..aOM<MemberV2_Senior>(7, _omitFieldNames ? '' : 'senior',
        subBuilder: MemberV2_Senior.create)
    ..aOM<MemberV2_Contractor>(8, _omitFieldNames ? '' : 'contractor',
        subBuilder: MemberV2_Contractor.create)
    ..aOM<$3.UserSailing>(9, _omitFieldNames ? '' : 'userSailing',
        subBuilder: $3.UserSailing.create)
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

  @$pb.TagNumber(6)
  MemberV2_Nft get nft => $_getN(5);
  @$pb.TagNumber(6)
  set nft(MemberV2_Nft value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasNft() => $_has(5);
  @$pb.TagNumber(6)
  void clearNft() => $_clearField(6);
  @$pb.TagNumber(6)
  MemberV2_Nft ensureNft() => $_ensure(5);

  @$pb.TagNumber(7)
  MemberV2_Senior get senior => $_getN(6);
  @$pb.TagNumber(7)
  set senior(MemberV2_Senior value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSenior() => $_has(6);
  @$pb.TagNumber(7)
  void clearSenior() => $_clearField(7);
  @$pb.TagNumber(7)
  MemberV2_Senior ensureSenior() => $_ensure(6);

  @$pb.TagNumber(8)
  MemberV2_Contractor get contractor => $_getN(7);
  @$pb.TagNumber(8)
  set contractor(MemberV2_Contractor value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasContractor() => $_has(7);
  @$pb.TagNumber(8)
  void clearContractor() => $_clearField(8);
  @$pb.TagNumber(8)
  MemberV2_Contractor ensureContractor() => $_ensure(7);

  @$pb.TagNumber(9)
  $3.UserSailing get userSailing => $_getN(8);
  @$pb.TagNumber(9)
  set userSailing($3.UserSailing value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasUserSailing() => $_has(8);
  @$pb.TagNumber(9)
  void clearUserSailing() => $_clearField(9);
  @$pb.TagNumber(9)
  $3.UserSailing ensureUserSailing() => $_ensure(8);
}

enum MixedCard_Item { question, notSet }

class MixedCard extends $pb.GeneratedMessage {
  factory MixedCard({
    MixedCard_Type? type,
    $core.String? oid,
    $fixnum.Int64? displayRank,
    QuestionCard? question,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (oid != null) result.oid = oid;
    if (displayRank != null) result.displayRank = displayRank;
    if (question != null) result.question = question;
    return result;
  }

  MixedCard._();

  factory MixedCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MixedCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, MixedCard_Item> _MixedCard_ItemByTag = {
    4: MixedCard_Item.question,
    0: MixedCard_Item.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MixedCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..oo(0, [4])
    ..aE<MixedCard_Type>(1, _omitFieldNames ? '' : 'type',
        enumValues: MixedCard_Type.values)
    ..aOS(2, _omitFieldNames ? '' : 'oid')
    ..aInt64(3, _omitFieldNames ? '' : 'displayRank')
    ..aOM<QuestionCard>(4, _omitFieldNames ? '' : 'question',
        subBuilder: QuestionCard.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MixedCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MixedCard copyWith(void Function(MixedCard) updates) =>
      super.copyWith((message) => updates(message as MixedCard)) as MixedCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MixedCard create() => MixedCard._();
  @$core.override
  MixedCard createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MixedCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MixedCard>(create);
  static MixedCard? _defaultInstance;

  @$pb.TagNumber(4)
  MixedCard_Item whichItem() => _MixedCard_ItemByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(4)
  void clearItem() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  MixedCard_Type get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(MixedCard_Type value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get oid => $_getSZ(1);
  @$pb.TagNumber(2)
  set oid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get displayRank => $_getI64(2);
  @$pb.TagNumber(3)
  set displayRank($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayRank() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayRank() => $_clearField(3);

  @$pb.TagNumber(4)
  QuestionCard get question => $_getN(3);
  @$pb.TagNumber(4)
  set question(QuestionCard value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasQuestion() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuestion() => $_clearField(4);
  @$pb.TagNumber(4)
  QuestionCard ensureQuestion() => $_ensure(3);
}

class Notice extends $pb.GeneratedMessage {
  factory Notice({
    $fixnum.Int64? id,
    $core.String? content,
    $core.String? link,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (content != null) result.content = content;
    if (link != null) result.link = link;
    return result;
  }

  Notice._();

  factory Notice.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Notice.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Notice',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'content')
    ..aOS(3, _omitFieldNames ? '' : 'link')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notice clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notice copyWith(void Function(Notice) updates) =>
      super.copyWith((message) => updates(message as Notice)) as Notice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notice create() => Notice._();
  @$core.override
  Notice createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Notice getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Notice>(create);
  static Notice? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get content => $_getSZ(1);
  @$pb.TagNumber(2)
  set content($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get link => $_getSZ(2);
  @$pb.TagNumber(3)
  set link($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLink() => $_has(2);
  @$pb.TagNumber(3)
  void clearLink() => $_clearField(3);
}

class OgvGradeCard extends $pb.GeneratedMessage {
  factory OgvGradeCard({
    $core.String? title,
    $core.String? subTitle,
    $core.String? buttonText,
    $core.String? gotoUrl,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (subTitle != null) result.subTitle = subTitle;
    if (buttonText != null) result.buttonText = buttonText;
    if (gotoUrl != null) result.gotoUrl = gotoUrl;
    return result;
  }

  OgvGradeCard._();

  factory OgvGradeCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OgvGradeCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OgvGradeCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'subTitle')
    ..aOS(3, _omitFieldNames ? '' : 'buttonText')
    ..aOS(4, _omitFieldNames ? '' : 'gotoUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OgvGradeCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OgvGradeCard copyWith(void Function(OgvGradeCard) updates) =>
      super.copyWith((message) => updates(message as OgvGradeCard))
          as OgvGradeCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OgvGradeCard create() => OgvGradeCard._();
  @$core.override
  OgvGradeCard createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OgvGradeCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OgvGradeCard>(create);
  static OgvGradeCard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get subTitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set subTitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get buttonText => $_getSZ(2);
  @$pb.TagNumber(3)
  set buttonText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasButtonText() => $_has(2);
  @$pb.TagNumber(3)
  void clearButtonText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get gotoUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set gotoUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasGotoUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearGotoUrl() => $_clearField(4);
}

class Operation extends $pb.GeneratedMessage {
  factory Operation({
    Operation_Type? type,
    $fixnum.Int64? id,
    OperationTitle? title,
    OperationTitle? subtitle,
    $core.String? link,
    $core.String? reportExtra,
    $core.String? icon,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    if (link != null) result.link = link;
    if (reportExtra != null) result.reportExtra = reportExtra;
    if (icon != null) result.icon = icon;
    return result;
  }

  Operation._();

  factory Operation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Operation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Operation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aE<Operation_Type>(1, _omitFieldNames ? '' : 'type',
        enumValues: Operation_Type.values)
    ..aInt64(2, _omitFieldNames ? '' : 'id')
    ..aOM<OperationTitle>(3, _omitFieldNames ? '' : 'title',
        subBuilder: OperationTitle.create)
    ..aOM<OperationTitle>(4, _omitFieldNames ? '' : 'subtitle',
        subBuilder: OperationTitle.create)
    ..aOS(5, _omitFieldNames ? '' : 'link')
    ..aOS(6, _omitFieldNames ? '' : 'reportExtra')
    ..aOS(7, _omitFieldNames ? '' : 'icon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Operation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Operation copyWith(void Function(Operation) updates) =>
      super.copyWith((message) => updates(message as Operation)) as Operation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Operation create() => Operation._();
  @$core.override
  Operation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Operation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Operation>(create);
  static Operation? _defaultInstance;

  @$pb.TagNumber(1)
  Operation_Type get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(Operation_Type value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get id => $_getI64(1);
  @$pb.TagNumber(2)
  set id($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  @$pb.TagNumber(3)
  OperationTitle get title => $_getN(2);
  @$pb.TagNumber(3)
  set title(OperationTitle value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);
  @$pb.TagNumber(3)
  OperationTitle ensureTitle() => $_ensure(2);

  @$pb.TagNumber(4)
  OperationTitle get subtitle => $_getN(3);
  @$pb.TagNumber(4)
  set subtitle(OperationTitle value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSubtitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubtitle() => $_clearField(4);
  @$pb.TagNumber(4)
  OperationTitle ensureSubtitle() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get link => $_getSZ(4);
  @$pb.TagNumber(5)
  set link($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLink() => $_has(4);
  @$pb.TagNumber(5)
  void clearLink() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get reportExtra => $_getSZ(5);
  @$pb.TagNumber(6)
  set reportExtra($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReportExtra() => $_has(5);
  @$pb.TagNumber(6)
  void clearReportExtra() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get icon => $_getSZ(6);
  @$pb.TagNumber(7)
  set icon($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIcon() => $_has(6);
  @$pb.TagNumber(7)
  void clearIcon() => $_clearField(7);
}

class OperationTitle extends $pb.GeneratedMessage {
  factory OperationTitle({
    $core.String? content,
    $core.bool? isHighlight,
  }) {
    final result = create();
    if (content != null) result.content = content;
    if (isHighlight != null) result.isHighlight = isHighlight;
    return result;
  }

  OperationTitle._();

  factory OperationTitle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OperationTitle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OperationTitle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'content')
    ..aOB(2, _omitFieldNames ? '' : 'isHighlight')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperationTitle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperationTitle copyWith(void Function(OperationTitle) updates) =>
      super.copyWith((message) => updates(message as OperationTitle))
          as OperationTitle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OperationTitle create() => OperationTitle._();
  @$core.override
  OperationTitle createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OperationTitle getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OperationTitle>(create);
  static OperationTitle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get content => $_getSZ(0);
  @$pb.TagNumber(1)
  set content($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isHighlight => $_getBF(1);
  @$pb.TagNumber(2)
  set isHighlight($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsHighlight() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsHighlight() => $_clearField(2);
}

class OperationV2_Icon extends $pb.GeneratedMessage {
  factory OperationV2_Icon({
    OperationV2_Icon_Position? position,
    $core.String? url,
  }) {
    final result = create();
    if (position != null) result.position = position;
    if (url != null) result.url = url;
    return result;
  }

  OperationV2_Icon._();

  factory OperationV2_Icon.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OperationV2_Icon.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OperationV2.Icon',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aE<OperationV2_Icon_Position>(1, _omitFieldNames ? '' : 'position',
        enumValues: OperationV2_Icon_Position.values)
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperationV2_Icon clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperationV2_Icon copyWith(void Function(OperationV2_Icon) updates) =>
      super.copyWith((message) => updates(message as OperationV2_Icon))
          as OperationV2_Icon;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OperationV2_Icon create() => OperationV2_Icon._();
  @$core.override
  OperationV2_Icon createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OperationV2_Icon getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OperationV2_Icon>(create);
  static OperationV2_Icon? _defaultInstance;

  @$pb.TagNumber(1)
  OperationV2_Icon_Position get position => $_getN(0);
  @$pb.TagNumber(1)
  set position(OperationV2_Icon_Position value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPosition() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosition() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);
}

class OperationV2 extends $pb.GeneratedMessage {
  factory OperationV2({
    OperationV2_Type? type,
    $core.String? prefixText,
    OperationV2_Icon? icon,
    $core.String? title,
    $core.String? link,
    $core.String? reportExtra,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (prefixText != null) result.prefixText = prefixText;
    if (icon != null) result.icon = icon;
    if (title != null) result.title = title;
    if (link != null) result.link = link;
    if (reportExtra != null) result.reportExtra = reportExtra;
    return result;
  }

  OperationV2._();

  factory OperationV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OperationV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OperationV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aE<OperationV2_Type>(1, _omitFieldNames ? '' : 'type',
        enumValues: OperationV2_Type.values)
    ..aOS(2, _omitFieldNames ? '' : 'prefixText')
    ..aOM<OperationV2_Icon>(3, _omitFieldNames ? '' : 'icon',
        subBuilder: OperationV2_Icon.create)
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'link')
    ..aOS(6, _omitFieldNames ? '' : 'reportExtra')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperationV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperationV2 copyWith(void Function(OperationV2) updates) =>
      super.copyWith((message) => updates(message as OperationV2))
          as OperationV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OperationV2 create() => OperationV2._();
  @$core.override
  OperationV2 createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OperationV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OperationV2>(create);
  static OperationV2? _defaultInstance;

  @$pb.TagNumber(1)
  OperationV2_Type get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(OperationV2_Type value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get prefixText => $_getSZ(1);
  @$pb.TagNumber(2)
  set prefixText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrefixText() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrefixText() => $_clearField(2);

  @$pb.TagNumber(3)
  OperationV2_Icon get icon => $_getN(2);
  @$pb.TagNumber(3)
  set icon(OperationV2_Icon value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearIcon() => $_clearField(3);
  @$pb.TagNumber(3)
  OperationV2_Icon ensureIcon() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get link => $_getSZ(4);
  @$pb.TagNumber(5)
  set link($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLink() => $_has(4);
  @$pb.TagNumber(5)
  void clearLink() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get reportExtra => $_getSZ(5);
  @$pb.TagNumber(6)
  set reportExtra($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReportExtra() => $_has(5);
  @$pb.TagNumber(6)
  void clearReportExtra() => $_clearField(6);
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
    $core.double? imgSize,
    $core.String? topRightIcon,
    $core.bool? playGifThumbnail,
  }) {
    final result = create();
    if (imgSrc != null) result.imgSrc = imgSrc;
    if (imgWidth != null) result.imgWidth = imgWidth;
    if (imgHeight != null) result.imgHeight = imgHeight;
    if (imgSize != null) result.imgSize = imgSize;
    if (topRightIcon != null) result.topRightIcon = topRightIcon;
    if (playGifThumbnail != null) result.playGifThumbnail = playGifThumbnail;
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
    ..aD(4, _omitFieldNames ? '' : 'imgSize')
    ..aOS(5, _omitFieldNames ? '' : 'topRightIcon')
    ..aOB(6, _omitFieldNames ? '' : 'playGifThumbnail')
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

  @$pb.TagNumber(4)
  $core.double get imgSize => $_getN(3);
  @$pb.TagNumber(4)
  set imgSize($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasImgSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearImgSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get topRightIcon => $_getSZ(4);
  @$pb.TagNumber(5)
  set topRightIcon($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTopRightIcon() => $_has(4);
  @$pb.TagNumber(5)
  void clearTopRightIcon() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get playGifThumbnail => $_getBF(5);
  @$pb.TagNumber(6)
  set playGifThumbnail($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPlayGifThumbnail() => $_has(5);
  @$pb.TagNumber(6)
  void clearPlayGifThumbnail() => $_clearField(6);
}

class PictureListReq extends $pb.GeneratedMessage {
  factory PictureListReq({
    $fixnum.Int64? oid,
    $fixnum.Int64? type,
    $core.String? extra,
    $fixnum.Int64? afterRpid,
    Mode? mode,
    $2.FeedPagination? pagination,
    $core.String? sessionId,
    $core.String? mainListSessionId,
  }) {
    final result = create();
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    if (extra != null) result.extra = extra;
    if (afterRpid != null) result.afterRpid = afterRpid;
    if (mode != null) result.mode = mode;
    if (pagination != null) result.pagination = pagination;
    if (sessionId != null) result.sessionId = sessionId;
    if (mainListSessionId != null) result.mainListSessionId = mainListSessionId;
    return result;
  }

  PictureListReq._();

  factory PictureListReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PictureListReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PictureListReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'oid')
    ..aInt64(2, _omitFieldNames ? '' : 'type')
    ..aOS(3, _omitFieldNames ? '' : 'extra')
    ..aInt64(4, _omitFieldNames ? '' : 'afterRpid')
    ..aE<Mode>(5, _omitFieldNames ? '' : 'mode', enumValues: Mode.values)
    ..aOM<$2.FeedPagination>(6, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.FeedPagination.create)
    ..aOS(7, _omitFieldNames ? '' : 'sessionId')
    ..aOS(8, _omitFieldNames ? '' : 'mainListSessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PictureListReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PictureListReq copyWith(void Function(PictureListReq) updates) =>
      super.copyWith((message) => updates(message as PictureListReq))
          as PictureListReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PictureListReq create() => PictureListReq._();
  @$core.override
  PictureListReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PictureListReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PictureListReq>(create);
  static PictureListReq? _defaultInstance;

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
  $core.String get extra => $_getSZ(2);
  @$pb.TagNumber(3)
  set extra($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExtra() => $_has(2);
  @$pb.TagNumber(3)
  void clearExtra() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get afterRpid => $_getI64(3);
  @$pb.TagNumber(4)
  set afterRpid($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAfterRpid() => $_has(3);
  @$pb.TagNumber(4)
  void clearAfterRpid() => $_clearField(4);

  @$pb.TagNumber(5)
  Mode get mode => $_getN(4);
  @$pb.TagNumber(5)
  set mode(Mode value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMode() => $_has(4);
  @$pb.TagNumber(5)
  void clearMode() => $_clearField(5);

  @$pb.TagNumber(6)
  $2.FeedPagination get pagination => $_getN(5);
  @$pb.TagNumber(6)
  set pagination($2.FeedPagination value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPagination() => $_has(5);
  @$pb.TagNumber(6)
  void clearPagination() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.FeedPagination ensurePagination() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get sessionId => $_getSZ(6);
  @$pb.TagNumber(7)
  set sessionId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSessionId() => $_has(6);
  @$pb.TagNumber(7)
  void clearSessionId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get mainListSessionId => $_getSZ(7);
  @$pb.TagNumber(8)
  set mainListSessionId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMainListSessionId() => $_has(7);
  @$pb.TagNumber(8)
  void clearMainListSessionId() => $_clearField(8);
}

class PictureListResp extends $pb.GeneratedMessage {
  factory PictureListResp({
    $core.Iterable<ReplyInfo>? replies,
    $2.FeedPaginationReply? paginationReply,
    $core.String? sessionId,
    $core.String? reportParams,
    $core.String? contextFeature,
    $core.String? paginationEndText,
  }) {
    final result = create();
    if (replies != null) result.replies.addAll(replies);
    if (paginationReply != null) result.paginationReply = paginationReply;
    if (sessionId != null) result.sessionId = sessionId;
    if (reportParams != null) result.reportParams = reportParams;
    if (contextFeature != null) result.contextFeature = contextFeature;
    if (paginationEndText != null) result.paginationEndText = paginationEndText;
    return result;
  }

  PictureListResp._();

  factory PictureListResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PictureListResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PictureListResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..pPM<ReplyInfo>(1, _omitFieldNames ? '' : 'replies',
        subBuilder: ReplyInfo.create)
    ..aOM<$2.FeedPaginationReply>(2, _omitFieldNames ? '' : 'paginationReply',
        subBuilder: $2.FeedPaginationReply.create)
    ..aOS(3, _omitFieldNames ? '' : 'sessionId')
    ..aOS(4, _omitFieldNames ? '' : 'reportParams')
    ..aOS(5, _omitFieldNames ? '' : 'contextFeature')
    ..aOS(6, _omitFieldNames ? '' : 'paginationEndText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PictureListResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PictureListResp copyWith(void Function(PictureListResp) updates) =>
      super.copyWith((message) => updates(message as PictureListResp))
          as PictureListResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PictureListResp create() => PictureListResp._();
  @$core.override
  PictureListResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PictureListResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PictureListResp>(create);
  static PictureListResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ReplyInfo> get replies => $_getList(0);

  @$pb.TagNumber(2)
  $2.FeedPaginationReply get paginationReply => $_getN(1);
  @$pb.TagNumber(2)
  set paginationReply($2.FeedPaginationReply value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPaginationReply() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaginationReply() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.FeedPaginationReply ensurePaginationReply() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get sessionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set sessionId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSessionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSessionId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reportParams => $_getSZ(3);
  @$pb.TagNumber(4)
  set reportParams($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReportParams() => $_has(3);
  @$pb.TagNumber(4)
  void clearReportParams() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get contextFeature => $_getSZ(4);
  @$pb.TagNumber(5)
  set contextFeature($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContextFeature() => $_has(4);
  @$pb.TagNumber(5)
  void clearContextFeature() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get paginationEndText => $_getSZ(5);
  @$pb.TagNumber(6)
  set paginationEndText($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPaginationEndText() => $_has(5);
  @$pb.TagNumber(6)
  void clearPaginationEndText() => $_clearField(6);
}

class PreviewListReply extends $pb.GeneratedMessage {
  factory PreviewListReply({
    CursorReply? cursor,
    $core.Iterable<ReplyInfo>? replies,
    SubjectControl? subjectControl,
    ReplyInfo? upTop,
    ReplyInfo? adminTop,
    ReplyInfo? voteTop,
  }) {
    final result = create();
    if (cursor != null) result.cursor = cursor;
    if (replies != null) result.replies.addAll(replies);
    if (subjectControl != null) result.subjectControl = subjectControl;
    if (upTop != null) result.upTop = upTop;
    if (adminTop != null) result.adminTop = adminTop;
    if (voteTop != null) result.voteTop = voteTop;
    return result;
  }

  PreviewListReply._();

  factory PreviewListReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PreviewListReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PreviewListReply',
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
    ..aOM<ReplyInfo>(5, _omitFieldNames ? '' : 'adminTop',
        subBuilder: ReplyInfo.create)
    ..aOM<ReplyInfo>(6, _omitFieldNames ? '' : 'voteTop',
        subBuilder: ReplyInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreviewListReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreviewListReply copyWith(void Function(PreviewListReply) updates) =>
      super.copyWith((message) => updates(message as PreviewListReply))
          as PreviewListReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PreviewListReply create() => PreviewListReply._();
  @$core.override
  PreviewListReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PreviewListReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PreviewListReply>(create);
  static PreviewListReply? _defaultInstance;

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

  @$pb.TagNumber(5)
  ReplyInfo get adminTop => $_getN(4);
  @$pb.TagNumber(5)
  set adminTop(ReplyInfo value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAdminTop() => $_has(4);
  @$pb.TagNumber(5)
  void clearAdminTop() => $_clearField(5);
  @$pb.TagNumber(5)
  ReplyInfo ensureAdminTop() => $_ensure(4);

  @$pb.TagNumber(6)
  ReplyInfo get voteTop => $_getN(5);
  @$pb.TagNumber(6)
  set voteTop(ReplyInfo value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasVoteTop() => $_has(5);
  @$pb.TagNumber(6)
  void clearVoteTop() => $_clearField(6);
  @$pb.TagNumber(6)
  ReplyInfo ensureVoteTop() => $_ensure(5);
}

class PreviewListReq extends $pb.GeneratedMessage {
  factory PreviewListReq({
    $fixnum.Int64? oid,
    $fixnum.Int64? type,
    CursorReq? cursor,
  }) {
    final result = create();
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    if (cursor != null) result.cursor = cursor;
    return result;
  }

  PreviewListReq._();

  factory PreviewListReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PreviewListReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PreviewListReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'oid')
    ..aInt64(2, _omitFieldNames ? '' : 'type')
    ..aOM<CursorReq>(3, _omitFieldNames ? '' : 'cursor',
        subBuilder: CursorReq.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreviewListReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PreviewListReq copyWith(void Function(PreviewListReq) updates) =>
      super.copyWith((message) => updates(message as PreviewListReq))
          as PreviewListReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PreviewListReq create() => PreviewListReq._();
  @$core.override
  PreviewListReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PreviewListReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PreviewListReq>(create);
  static PreviewListReq? _defaultInstance;

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
}

class QoeInfo extends $pb.GeneratedMessage {
  factory QoeInfo({
    $fixnum.Int64? id,
    $core.int? type,
    $core.int? style,
    $core.String? title,
    $core.String? feedbackTitle,
    $core.Iterable<QoeScoreItem>? scoreItems,
    $fixnum.Int64? displayRank,
    Form? form,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (type != null) result.type = type;
    if (style != null) result.style = style;
    if (title != null) result.title = title;
    if (feedbackTitle != null) result.feedbackTitle = feedbackTitle;
    if (scoreItems != null) result.scoreItems.addAll(scoreItems);
    if (displayRank != null) result.displayRank = displayRank;
    if (form != null) result.form = form;
    return result;
  }

  QoeInfo._();

  factory QoeInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QoeInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QoeInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aI(2, _omitFieldNames ? '' : 'type')
    ..aI(3, _omitFieldNames ? '' : 'style')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'feedbackTitle')
    ..pPM<QoeScoreItem>(6, _omitFieldNames ? '' : 'scoreItems',
        subBuilder: QoeScoreItem.create)
    ..aInt64(7, _omitFieldNames ? '' : 'displayRank')
    ..aOM<Form>(8, _omitFieldNames ? '' : 'form', subBuilder: Form.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QoeInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QoeInfo copyWith(void Function(QoeInfo) updates) =>
      super.copyWith((message) => updates(message as QoeInfo)) as QoeInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QoeInfo create() => QoeInfo._();
  @$core.override
  QoeInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QoeInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QoeInfo>(create);
  static QoeInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get type => $_getIZ(1);
  @$pb.TagNumber(2)
  set type($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get style => $_getIZ(2);
  @$pb.TagNumber(3)
  set style($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStyle() => $_has(2);
  @$pb.TagNumber(3)
  void clearStyle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get feedbackTitle => $_getSZ(4);
  @$pb.TagNumber(5)
  set feedbackTitle($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFeedbackTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearFeedbackTitle() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<QoeScoreItem> get scoreItems => $_getList(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get displayRank => $_getI64(6);
  @$pb.TagNumber(7)
  set displayRank($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDisplayRank() => $_has(6);
  @$pb.TagNumber(7)
  void clearDisplayRank() => $_clearField(7);

  @$pb.TagNumber(8)
  Form get form => $_getN(7);
  @$pb.TagNumber(8)
  set form(Form value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasForm() => $_has(7);
  @$pb.TagNumber(8)
  void clearForm() => $_clearField(8);
  @$pb.TagNumber(8)
  Form ensureForm() => $_ensure(7);
}

class QoeOption extends $pb.GeneratedMessage {
  factory QoeOption({
    $core.String? title,
    $core.double? score,
    $core.String? imgUrl,
    $core.Iterable<$core.String>? desc,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (score != null) result.score = score;
    if (imgUrl != null) result.imgUrl = imgUrl;
    if (desc != null) result.desc.addAll(desc);
    return result;
  }

  QoeOption._();

  factory QoeOption.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QoeOption.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QoeOption',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aD(2, _omitFieldNames ? '' : 'score', fieldType: $pb.PbFieldType.OF)
    ..aOS(3, _omitFieldNames ? '' : 'imgUrl')
    ..pPS(4, _omitFieldNames ? '' : 'desc')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QoeOption clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QoeOption copyWith(void Function(QoeOption) updates) =>
      super.copyWith((message) => updates(message as QoeOption)) as QoeOption;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QoeOption create() => QoeOption._();
  @$core.override
  QoeOption createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QoeOption getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QoeOption>(create);
  static QoeOption? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get score => $_getN(1);
  @$pb.TagNumber(2)
  set score($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScore() => $_has(1);
  @$pb.TagNumber(2)
  void clearScore() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get imgUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set imgUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasImgUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearImgUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get desc => $_getList(3);
}

class QoeOptionDesc extends $pb.GeneratedMessage {
  factory QoeOptionDesc({
    $core.Iterable<$core.String>? desc,
  }) {
    final result = create();
    if (desc != null) result.desc.addAll(desc);
    return result;
  }

  QoeOptionDesc._();

  factory QoeOptionDesc.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QoeOptionDesc.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QoeOptionDesc',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'desc')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QoeOptionDesc clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QoeOptionDesc copyWith(void Function(QoeOptionDesc) updates) =>
      super.copyWith((message) => updates(message as QoeOptionDesc))
          as QoeOptionDesc;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QoeOptionDesc create() => QoeOptionDesc._();
  @$core.override
  QoeOptionDesc createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QoeOptionDesc getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QoeOptionDesc>(create);
  static QoeOptionDesc? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get desc => $_getList(0);
}

class QoeScoreItem extends $pb.GeneratedMessage {
  factory QoeScoreItem({
    $core.String? title,
    $core.String? url,
    $core.double? score,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (url != null) result.url = url;
    if (score != null) result.score = score;
    return result;
  }

  QoeScoreItem._();

  factory QoeScoreItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QoeScoreItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QoeScoreItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..aD(3, _omitFieldNames ? '' : 'score', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QoeScoreItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QoeScoreItem copyWith(void Function(QoeScoreItem) updates) =>
      super.copyWith((message) => updates(message as QoeScoreItem))
          as QoeScoreItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QoeScoreItem create() => QoeScoreItem._();
  @$core.override
  QoeScoreItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QoeScoreItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QoeScoreItem>(create);
  static QoeScoreItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get score => $_getN(2);
  @$pb.TagNumber(3)
  set score($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScore() => $_has(2);
  @$pb.TagNumber(3)
  void clearScore() => $_clearField(3);
}

class QuestionCard_Option extends $pb.GeneratedMessage {
  factory QuestionCard_Option({
    $core.String? key,
    $core.String? title,
  }) {
    final result = create();
    if (key != null) result.key = key;
    if (title != null) result.title = title;
    return result;
  }

  QuestionCard_Option._();

  factory QuestionCard_Option.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QuestionCard_Option.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuestionCard.Option',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuestionCard_Option clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuestionCard_Option copyWith(void Function(QuestionCard_Option) updates) =>
      super.copyWith((message) => updates(message as QuestionCard_Option))
          as QuestionCard_Option;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QuestionCard_Option create() => QuestionCard_Option._();
  @$core.override
  QuestionCard_Option createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QuestionCard_Option getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QuestionCard_Option>(create);
  static QuestionCard_Option? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);
}

class QuestionCard_Question extends $pb.GeneratedMessage {
  factory QuestionCard_Question({
    $fixnum.Int64? qid,
    $core.String? title,
    $core.bool? mustRight,
    $core.Iterable<QuestionCard_Option>? options,
  }) {
    final result = create();
    if (qid != null) result.qid = qid;
    if (title != null) result.title = title;
    if (mustRight != null) result.mustRight = mustRight;
    if (options != null) result.options.addAll(options);
    return result;
  }

  QuestionCard_Question._();

  factory QuestionCard_Question.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QuestionCard_Question.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuestionCard.Question',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'qid')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOB(3, _omitFieldNames ? '' : 'mustRight')
    ..pPM<QuestionCard_Option>(4, _omitFieldNames ? '' : 'options',
        subBuilder: QuestionCard_Option.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuestionCard_Question clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuestionCard_Question copyWith(
          void Function(QuestionCard_Question) updates) =>
      super.copyWith((message) => updates(message as QuestionCard_Question))
          as QuestionCard_Question;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QuestionCard_Question create() => QuestionCard_Question._();
  @$core.override
  QuestionCard_Question createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QuestionCard_Question getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QuestionCard_Question>(create);
  static QuestionCard_Question? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get qid => $_getI64(0);
  @$pb.TagNumber(1)
  set qid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQid() => $_has(0);
  @$pb.TagNumber(1)
  void clearQid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get mustRight => $_getBF(2);
  @$pb.TagNumber(3)
  set mustRight($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMustRight() => $_has(2);
  @$pb.TagNumber(3)
  void clearMustRight() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<QuestionCard_Option> get options => $_getList(3);
}

class QuestionCard extends $pb.GeneratedMessage {
  factory QuestionCard({
    QuestionCard_Question? question,
    QuestionCardStat? stat,
    $core.String? bottomText,
  }) {
    final result = create();
    if (question != null) result.question = question;
    if (stat != null) result.stat = stat;
    if (bottomText != null) result.bottomText = bottomText;
    return result;
  }

  QuestionCard._();

  factory QuestionCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QuestionCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuestionCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOM<QuestionCard_Question>(1, _omitFieldNames ? '' : 'question',
        subBuilder: QuestionCard_Question.create)
    ..aOM<QuestionCardStat>(2, _omitFieldNames ? '' : 'stat',
        subBuilder: QuestionCardStat.create)
    ..aOS(3, _omitFieldNames ? '' : 'bottomText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuestionCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuestionCard copyWith(void Function(QuestionCard) updates) =>
      super.copyWith((message) => updates(message as QuestionCard))
          as QuestionCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QuestionCard create() => QuestionCard._();
  @$core.override
  QuestionCard createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QuestionCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QuestionCard>(create);
  static QuestionCard? _defaultInstance;

  @$pb.TagNumber(1)
  QuestionCard_Question get question => $_getN(0);
  @$pb.TagNumber(1)
  set question(QuestionCard_Question value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasQuestion() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuestion() => $_clearField(1);
  @$pb.TagNumber(1)
  QuestionCard_Question ensureQuestion() => $_ensure(0);

  @$pb.TagNumber(2)
  QuestionCardStat get stat => $_getN(1);
  @$pb.TagNumber(2)
  set stat(QuestionCardStat value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStat() => $_has(1);
  @$pb.TagNumber(2)
  void clearStat() => $_clearField(2);
  @$pb.TagNumber(2)
  QuestionCardStat ensureStat() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get bottomText => $_getSZ(2);
  @$pb.TagNumber(3)
  set bottomText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBottomText() => $_has(2);
  @$pb.TagNumber(3)
  void clearBottomText() => $_clearField(3);
}

class QuestionCardStat extends $pb.GeneratedMessage {
  factory QuestionCardStat({
    $fixnum.Int64? rightCnt,
    $fixnum.Int64? rightMidCnt,
    $fixnum.Int64? submitMidCnt,
  }) {
    final result = create();
    if (rightCnt != null) result.rightCnt = rightCnt;
    if (rightMidCnt != null) result.rightMidCnt = rightMidCnt;
    if (submitMidCnt != null) result.submitMidCnt = submitMidCnt;
    return result;
  }

  QuestionCardStat._();

  factory QuestionCardStat.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QuestionCardStat.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuestionCardStat',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'rightCnt')
    ..aInt64(2, _omitFieldNames ? '' : 'rightMidCnt')
    ..aInt64(3, _omitFieldNames ? '' : 'submitMidCnt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuestionCardStat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuestionCardStat copyWith(void Function(QuestionCardStat) updates) =>
      super.copyWith((message) => updates(message as QuestionCardStat))
          as QuestionCardStat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QuestionCardStat create() => QuestionCardStat._();
  @$core.override
  QuestionCardStat createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QuestionCardStat getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QuestionCardStat>(create);
  static QuestionCardStat? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get rightCnt => $_getI64(0);
  @$pb.TagNumber(1)
  set rightCnt($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRightCnt() => $_has(0);
  @$pb.TagNumber(1)
  void clearRightCnt() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get rightMidCnt => $_getI64(1);
  @$pb.TagNumber(2)
  set rightMidCnt($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRightMidCnt() => $_has(1);
  @$pb.TagNumber(2)
  void clearRightMidCnt() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get submitMidCnt => $_getI64(2);
  @$pb.TagNumber(3)
  set submitMidCnt($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubmitMidCnt() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubmitMidCnt() => $_clearField(3);
}

class ReplyCardLabel extends $pb.GeneratedMessage {
  factory ReplyCardLabel({
    $core.String? textContent,
    $core.String? textColorDay,
    $core.String? textColorNight,
    $core.String? labelColorDay,
    $core.String? labelColorNight,
    $core.String? image,
    ReplyCardLabel_Type? type,
    $core.String? background,
    $core.double? backgroundWidth,
    $core.double? backgroundHeight,
    $core.String? jumpUrl,
    $fixnum.Int64? effect,
    $fixnum.Int64? effectStartTime,
  }) {
    final result = create();
    if (textContent != null) result.textContent = textContent;
    if (textColorDay != null) result.textColorDay = textColorDay;
    if (textColorNight != null) result.textColorNight = textColorNight;
    if (labelColorDay != null) result.labelColorDay = labelColorDay;
    if (labelColorNight != null) result.labelColorNight = labelColorNight;
    if (image != null) result.image = image;
    if (type != null) result.type = type;
    if (background != null) result.background = background;
    if (backgroundWidth != null) result.backgroundWidth = backgroundWidth;
    if (backgroundHeight != null) result.backgroundHeight = backgroundHeight;
    if (jumpUrl != null) result.jumpUrl = jumpUrl;
    if (effect != null) result.effect = effect;
    if (effectStartTime != null) result.effectStartTime = effectStartTime;
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
    ..aOS(2, _omitFieldNames ? '' : 'textColorDay')
    ..aOS(3, _omitFieldNames ? '' : 'textColorNight')
    ..aOS(4, _omitFieldNames ? '' : 'labelColorDay')
    ..aOS(5, _omitFieldNames ? '' : 'labelColorNight')
    ..aOS(6, _omitFieldNames ? '' : 'image')
    ..aE<ReplyCardLabel_Type>(7, _omitFieldNames ? '' : 'type',
        enumValues: ReplyCardLabel_Type.values)
    ..aOS(8, _omitFieldNames ? '' : 'background')
    ..aD(9, _omitFieldNames ? '' : 'backgroundWidth')
    ..aD(10, _omitFieldNames ? '' : 'backgroundHeight')
    ..aOS(11, _omitFieldNames ? '' : 'jumpUrl')
    ..aInt64(12, _omitFieldNames ? '' : 'effect')
    ..aInt64(13, _omitFieldNames ? '' : 'effectStartTime')
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

  @$pb.TagNumber(2)
  $core.String get textColorDay => $_getSZ(1);
  @$pb.TagNumber(2)
  set textColorDay($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTextColorDay() => $_has(1);
  @$pb.TagNumber(2)
  void clearTextColorDay() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get textColorNight => $_getSZ(2);
  @$pb.TagNumber(3)
  set textColorNight($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTextColorNight() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextColorNight() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get labelColorDay => $_getSZ(3);
  @$pb.TagNumber(4)
  set labelColorDay($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLabelColorDay() => $_has(3);
  @$pb.TagNumber(4)
  void clearLabelColorDay() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get labelColorNight => $_getSZ(4);
  @$pb.TagNumber(5)
  set labelColorNight($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLabelColorNight() => $_has(4);
  @$pb.TagNumber(5)
  void clearLabelColorNight() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get image => $_getSZ(5);
  @$pb.TagNumber(6)
  set image($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasImage() => $_has(5);
  @$pb.TagNumber(6)
  void clearImage() => $_clearField(6);

  @$pb.TagNumber(7)
  ReplyCardLabel_Type get type => $_getN(6);
  @$pb.TagNumber(7)
  set type(ReplyCardLabel_Type value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasType() => $_has(6);
  @$pb.TagNumber(7)
  void clearType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get background => $_getSZ(7);
  @$pb.TagNumber(8)
  set background($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBackground() => $_has(7);
  @$pb.TagNumber(8)
  void clearBackground() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get backgroundWidth => $_getN(8);
  @$pb.TagNumber(9)
  set backgroundWidth($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBackgroundWidth() => $_has(8);
  @$pb.TagNumber(9)
  void clearBackgroundWidth() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get backgroundHeight => $_getN(9);
  @$pb.TagNumber(10)
  set backgroundHeight($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasBackgroundHeight() => $_has(9);
  @$pb.TagNumber(10)
  void clearBackgroundHeight() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get jumpUrl => $_getSZ(10);
  @$pb.TagNumber(11)
  set jumpUrl($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasJumpUrl() => $_has(10);
  @$pb.TagNumber(11)
  void clearJumpUrl() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get effect => $_getI64(11);
  @$pb.TagNumber(12)
  set effect($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasEffect() => $_has(11);
  @$pb.TagNumber(12)
  void clearEffect() => $_clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get effectStartTime => $_getI64(12);
  @$pb.TagNumber(13)
  set effectStartTime($fixnum.Int64 value) => $_setInt64(12, value);
  @$pb.TagNumber(13)
  $core.bool hasEffectStartTime() => $_has(12);
  @$pb.TagNumber(13)
  void clearEffectStartTime() => $_clearField(13);
}

class ReplyControl_EasterEggLabel extends $pb.GeneratedMessage {
  factory ReplyControl_EasterEggLabel({
    $core.String? image,
    $core.String? jumpUrl,
  }) {
    final result = create();
    if (image != null) result.image = image;
    if (jumpUrl != null) result.jumpUrl = jumpUrl;
    return result;
  }

  ReplyControl_EasterEggLabel._();

  factory ReplyControl_EasterEggLabel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplyControl_EasterEggLabel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyControl.EasterEggLabel',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'image')
    ..aOS(2, _omitFieldNames ? '' : 'jumpUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyControl_EasterEggLabel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyControl_EasterEggLabel copyWith(
          void Function(ReplyControl_EasterEggLabel) updates) =>
      super.copyWith(
              (message) => updates(message as ReplyControl_EasterEggLabel))
          as ReplyControl_EasterEggLabel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplyControl_EasterEggLabel create() =>
      ReplyControl_EasterEggLabel._();
  @$core.override
  ReplyControl_EasterEggLabel createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReplyControl_EasterEggLabel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyControl_EasterEggLabel>(create);
  static ReplyControl_EasterEggLabel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get image => $_getSZ(0);
  @$pb.TagNumber(1)
  set image($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasImage() => $_has(0);
  @$pb.TagNumber(1)
  void clearImage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get jumpUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set jumpUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJumpUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearJumpUrl() => $_clearField(2);
}

class ReplyControl_GradeRecord_Text extends $pb.GeneratedMessage {
  factory ReplyControl_GradeRecord_Text({
    $core.String? raw,
    TextStyle? style,
  }) {
    final result = create();
    if (raw != null) result.raw = raw;
    if (style != null) result.style = style;
    return result;
  }

  ReplyControl_GradeRecord_Text._();

  factory ReplyControl_GradeRecord_Text.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplyControl_GradeRecord_Text.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyControl.GradeRecord.Text',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'raw')
    ..aOM<TextStyle>(2, _omitFieldNames ? '' : 'style',
        subBuilder: TextStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyControl_GradeRecord_Text clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyControl_GradeRecord_Text copyWith(
          void Function(ReplyControl_GradeRecord_Text) updates) =>
      super.copyWith(
              (message) => updates(message as ReplyControl_GradeRecord_Text))
          as ReplyControl_GradeRecord_Text;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplyControl_GradeRecord_Text create() =>
      ReplyControl_GradeRecord_Text._();
  @$core.override
  ReplyControl_GradeRecord_Text createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReplyControl_GradeRecord_Text getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyControl_GradeRecord_Text>(create);
  static ReplyControl_GradeRecord_Text? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get raw => $_getSZ(0);
  @$pb.TagNumber(1)
  set raw($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRaw() => $_has(0);
  @$pb.TagNumber(1)
  void clearRaw() => $_clearField(1);

  @$pb.TagNumber(2)
  TextStyle get style => $_getN(1);
  @$pb.TagNumber(2)
  set style(TextStyle value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStyle() => $_has(1);
  @$pb.TagNumber(2)
  void clearStyle() => $_clearField(2);
  @$pb.TagNumber(2)
  TextStyle ensureStyle() => $_ensure(1);
}

class ReplyControl_GradeRecord extends $pb.GeneratedMessage {
  factory ReplyControl_GradeRecord({
    $core.int? score,
    $core.Iterable<ReplyControl_GradeRecord_Text>? texts,
  }) {
    final result = create();
    if (score != null) result.score = score;
    if (texts != null) result.texts.addAll(texts);
    return result;
  }

  ReplyControl_GradeRecord._();

  factory ReplyControl_GradeRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplyControl_GradeRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyControl.GradeRecord',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'score')
    ..pPM<ReplyControl_GradeRecord_Text>(2, _omitFieldNames ? '' : 'texts',
        subBuilder: ReplyControl_GradeRecord_Text.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyControl_GradeRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyControl_GradeRecord copyWith(
          void Function(ReplyControl_GradeRecord) updates) =>
      super.copyWith((message) => updates(message as ReplyControl_GradeRecord))
          as ReplyControl_GradeRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplyControl_GradeRecord create() => ReplyControl_GradeRecord._();
  @$core.override
  ReplyControl_GradeRecord createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReplyControl_GradeRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyControl_GradeRecord>(create);
  static ReplyControl_GradeRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get score => $_getIZ(0);
  @$pb.TagNumber(1)
  set score($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasScore() => $_has(0);
  @$pb.TagNumber(1)
  void clearScore() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ReplyControl_GradeRecord_Text> get texts => $_getList(1);
}

class ReplyControl_InsertEffect extends $pb.GeneratedMessage {
  factory ReplyControl_InsertEffect({
    $core.String? content,
    $core.String? icon,
  }) {
    final result = create();
    if (content != null) result.content = content;
    if (icon != null) result.icon = icon;
    return result;
  }

  ReplyControl_InsertEffect._();

  factory ReplyControl_InsertEffect.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplyControl_InsertEffect.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyControl.InsertEffect',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'content')
    ..aOS(2, _omitFieldNames ? '' : 'icon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyControl_InsertEffect clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyControl_InsertEffect copyWith(
          void Function(ReplyControl_InsertEffect) updates) =>
      super.copyWith((message) => updates(message as ReplyControl_InsertEffect))
          as ReplyControl_InsertEffect;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplyControl_InsertEffect create() => ReplyControl_InsertEffect._();
  @$core.override
  ReplyControl_InsertEffect createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReplyControl_InsertEffect getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyControl_InsertEffect>(create);
  static ReplyControl_InsertEffect? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get content => $_getSZ(0);
  @$pb.TagNumber(1)
  set content($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasContent() => $_has(0);
  @$pb.TagNumber(1)
  void clearContent() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get icon => $_getSZ(1);
  @$pb.TagNumber(2)
  set icon($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIcon() => $_has(1);
  @$pb.TagNumber(2)
  void clearIcon() => $_clearField(2);
}

class ReplyControl_VoteOption extends $pb.GeneratedMessage {
  factory ReplyControl_VoteOption({
    ReplyControl_VoteOption_LabelKind? labelKind,
    $core.String? desc,
    $fixnum.Int64? idx,
    $fixnum.Int64? voteId,
  }) {
    final result = create();
    if (labelKind != null) result.labelKind = labelKind;
    if (desc != null) result.desc = desc;
    if (idx != null) result.idx = idx;
    if (voteId != null) result.voteId = voteId;
    return result;
  }

  ReplyControl_VoteOption._();

  factory ReplyControl_VoteOption.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplyControl_VoteOption.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyControl.VoteOption',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aE<ReplyControl_VoteOption_LabelKind>(
        1, _omitFieldNames ? '' : 'labelKind',
        enumValues: ReplyControl_VoteOption_LabelKind.values)
    ..aOS(2, _omitFieldNames ? '' : 'desc')
    ..aInt64(3, _omitFieldNames ? '' : 'idx')
    ..aInt64(4, _omitFieldNames ? '' : 'voteId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyControl_VoteOption clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyControl_VoteOption copyWith(
          void Function(ReplyControl_VoteOption) updates) =>
      super.copyWith((message) => updates(message as ReplyControl_VoteOption))
          as ReplyControl_VoteOption;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplyControl_VoteOption create() => ReplyControl_VoteOption._();
  @$core.override
  ReplyControl_VoteOption createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReplyControl_VoteOption getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyControl_VoteOption>(create);
  static ReplyControl_VoteOption? _defaultInstance;

  @$pb.TagNumber(1)
  ReplyControl_VoteOption_LabelKind get labelKind => $_getN(0);
  @$pb.TagNumber(1)
  set labelKind(ReplyControl_VoteOption_LabelKind value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLabelKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearLabelKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get desc => $_getSZ(1);
  @$pb.TagNumber(2)
  set desc($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDesc() => $_has(1);
  @$pb.TagNumber(2)
  void clearDesc() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get idx => $_getI64(2);
  @$pb.TagNumber(3)
  set idx($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIdx() => $_has(2);
  @$pb.TagNumber(3)
  void clearIdx() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get voteId => $_getI64(3);
  @$pb.TagNumber(4)
  set voteId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVoteId() => $_has(3);
  @$pb.TagNumber(4)
  void clearVoteId() => $_clearField(4);
}

class ReplyControl extends $pb.GeneratedMessage {
  factory ReplyControl({
    $fixnum.Int64? action,
    $core.bool? upLike,
    $core.bool? upReply,
    $core.bool? showFollowBtn,
    $core.bool? isAssist,
    $core.String? labelText,
    $core.bool? following,
    $core.bool? followed,
    $core.bool? blocked,
    $core.bool? hasFoldedReply,
    $core.bool? isFoldedReply,
    $core.bool? isUpTop,
    $core.bool? isAdminTop,
    $core.bool? isVoteTop,
    $fixnum.Int64? maxLine,
    $core.bool? invisible,
    $core.bool? isContractor,
    $core.bool? isNote,
    $core.Iterable<ReplyCardLabel>? cardLabels,
    $core.String? subReplyEntryText,
    $core.String? subReplyTitleText,
    $core.String? contractDesc,
    $core.String? timeDesc,
    $core.String? bizScene,
    $core.String? location,
    $core.bool? foldPictures,
    $core.bool? isNoteV2,
    $core.bool? hideNoteIcon,
    $core.String? cmRecommendComponent,
    ReplyControl_VoteOption? voteOption,
    $core.String? chargedDesc,
    ReplyControl_GradeRecord? gradeRecord,
    $core.String? presetReplyText,
    ReplyControl_EasterEggLabel? easterEggLabel,
    $core.String? contextFeature,
    ReplyControl_InsertEffect? insertEffect,
    TranslationSwitch? translationSwitch,
    $core.bool? showTranslation,
  }) {
    final result = create();
    if (action != null) result.action = action;
    if (upLike != null) result.upLike = upLike;
    if (upReply != null) result.upReply = upReply;
    if (showFollowBtn != null) result.showFollowBtn = showFollowBtn;
    if (isAssist != null) result.isAssist = isAssist;
    if (labelText != null) result.labelText = labelText;
    if (following != null) result.following = following;
    if (followed != null) result.followed = followed;
    if (blocked != null) result.blocked = blocked;
    if (hasFoldedReply != null) result.hasFoldedReply = hasFoldedReply;
    if (isFoldedReply != null) result.isFoldedReply = isFoldedReply;
    if (isUpTop != null) result.isUpTop = isUpTop;
    if (isAdminTop != null) result.isAdminTop = isAdminTop;
    if (isVoteTop != null) result.isVoteTop = isVoteTop;
    if (maxLine != null) result.maxLine = maxLine;
    if (invisible != null) result.invisible = invisible;
    if (isContractor != null) result.isContractor = isContractor;
    if (isNote != null) result.isNote = isNote;
    if (cardLabels != null) result.cardLabels.addAll(cardLabels);
    if (subReplyEntryText != null) result.subReplyEntryText = subReplyEntryText;
    if (subReplyTitleText != null) result.subReplyTitleText = subReplyTitleText;
    if (contractDesc != null) result.contractDesc = contractDesc;
    if (timeDesc != null) result.timeDesc = timeDesc;
    if (bizScene != null) result.bizScene = bizScene;
    if (location != null) result.location = location;
    if (foldPictures != null) result.foldPictures = foldPictures;
    if (isNoteV2 != null) result.isNoteV2 = isNoteV2;
    if (hideNoteIcon != null) result.hideNoteIcon = hideNoteIcon;
    if (cmRecommendComponent != null)
      result.cmRecommendComponent = cmRecommendComponent;
    if (voteOption != null) result.voteOption = voteOption;
    if (chargedDesc != null) result.chargedDesc = chargedDesc;
    if (gradeRecord != null) result.gradeRecord = gradeRecord;
    if (presetReplyText != null) result.presetReplyText = presetReplyText;
    if (easterEggLabel != null) result.easterEggLabel = easterEggLabel;
    if (contextFeature != null) result.contextFeature = contextFeature;
    if (insertEffect != null) result.insertEffect = insertEffect;
    if (translationSwitch != null) result.translationSwitch = translationSwitch;
    if (showTranslation != null) result.showTranslation = showTranslation;
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
    ..aOB(4, _omitFieldNames ? '' : 'showFollowBtn')
    ..aOB(5, _omitFieldNames ? '' : 'isAssist')
    ..aOS(6, _omitFieldNames ? '' : 'labelText')
    ..aOB(7, _omitFieldNames ? '' : 'following')
    ..aOB(8, _omitFieldNames ? '' : 'followed')
    ..aOB(9, _omitFieldNames ? '' : 'blocked')
    ..aOB(10, _omitFieldNames ? '' : 'hasFoldedReply')
    ..aOB(11, _omitFieldNames ? '' : 'isFoldedReply')
    ..aOB(12, _omitFieldNames ? '' : 'isUpTop')
    ..aOB(13, _omitFieldNames ? '' : 'isAdminTop')
    ..aOB(14, _omitFieldNames ? '' : 'isVoteTop')
    ..aInt64(15, _omitFieldNames ? '' : 'maxLine')
    ..aOB(16, _omitFieldNames ? '' : 'invisible')
    ..aOB(17, _omitFieldNames ? '' : 'isContractor')
    ..aOB(18, _omitFieldNames ? '' : 'isNote')
    ..pPM<ReplyCardLabel>(19, _omitFieldNames ? '' : 'cardLabels',
        subBuilder: ReplyCardLabel.create)
    ..aOS(20, _omitFieldNames ? '' : 'subReplyEntryText')
    ..aOS(21, _omitFieldNames ? '' : 'subReplyTitleText')
    ..aOS(22, _omitFieldNames ? '' : 'contractDesc')
    ..aOS(23, _omitFieldNames ? '' : 'timeDesc')
    ..aOS(24, _omitFieldNames ? '' : 'bizScene')
    ..aOS(25, _omitFieldNames ? '' : 'location')
    ..aOB(26, _omitFieldNames ? '' : 'foldPictures')
    ..aOB(27, _omitFieldNames ? '' : 'isNoteV2')
    ..aOB(28, _omitFieldNames ? '' : 'hideNoteIcon')
    ..aOS(29, _omitFieldNames ? '' : 'cmRecommendComponent')
    ..aOM<ReplyControl_VoteOption>(30, _omitFieldNames ? '' : 'voteOption',
        subBuilder: ReplyControl_VoteOption.create)
    ..aOS(31, _omitFieldNames ? '' : 'chargedDesc')
    ..aOM<ReplyControl_GradeRecord>(32, _omitFieldNames ? '' : 'gradeRecord',
        subBuilder: ReplyControl_GradeRecord.create)
    ..aOS(33, _omitFieldNames ? '' : 'presetReplyText')
    ..aOM<ReplyControl_EasterEggLabel>(
        34, _omitFieldNames ? '' : 'easterEggLabel',
        subBuilder: ReplyControl_EasterEggLabel.create)
    ..aOS(35, _omitFieldNames ? '' : 'contextFeature')
    ..aOM<ReplyControl_InsertEffect>(36, _omitFieldNames ? '' : 'insertEffect',
        subBuilder: ReplyControl_InsertEffect.create)
    ..aE<TranslationSwitch>(37, _omitFieldNames ? '' : 'translationSwitch',
        enumValues: TranslationSwitch.values)
    ..aOB(100, _omitFieldNames ? '' : 'showTranslation')
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

  @$pb.TagNumber(4)
  $core.bool get showFollowBtn => $_getBF(3);
  @$pb.TagNumber(4)
  set showFollowBtn($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasShowFollowBtn() => $_has(3);
  @$pb.TagNumber(4)
  void clearShowFollowBtn() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isAssist => $_getBF(4);
  @$pb.TagNumber(5)
  set isAssist($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsAssist() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsAssist() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get labelText => $_getSZ(5);
  @$pb.TagNumber(6)
  set labelText($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLabelText() => $_has(5);
  @$pb.TagNumber(6)
  void clearLabelText() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get following => $_getBF(6);
  @$pb.TagNumber(7)
  set following($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFollowing() => $_has(6);
  @$pb.TagNumber(7)
  void clearFollowing() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get followed => $_getBF(7);
  @$pb.TagNumber(8)
  set followed($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFollowed() => $_has(7);
  @$pb.TagNumber(8)
  void clearFollowed() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get blocked => $_getBF(8);
  @$pb.TagNumber(9)
  set blocked($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBlocked() => $_has(8);
  @$pb.TagNumber(9)
  void clearBlocked() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get hasFoldedReply => $_getBF(9);
  @$pb.TagNumber(10)
  set hasFoldedReply($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasHasFoldedReply() => $_has(9);
  @$pb.TagNumber(10)
  void clearHasFoldedReply() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get isFoldedReply => $_getBF(10);
  @$pb.TagNumber(11)
  set isFoldedReply($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasIsFoldedReply() => $_has(10);
  @$pb.TagNumber(11)
  void clearIsFoldedReply() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get isUpTop => $_getBF(11);
  @$pb.TagNumber(12)
  set isUpTop($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasIsUpTop() => $_has(11);
  @$pb.TagNumber(12)
  void clearIsUpTop() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get isAdminTop => $_getBF(12);
  @$pb.TagNumber(13)
  set isAdminTop($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasIsAdminTop() => $_has(12);
  @$pb.TagNumber(13)
  void clearIsAdminTop() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get isVoteTop => $_getBF(13);
  @$pb.TagNumber(14)
  set isVoteTop($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasIsVoteTop() => $_has(13);
  @$pb.TagNumber(14)
  void clearIsVoteTop() => $_clearField(14);

  @$pb.TagNumber(15)
  $fixnum.Int64 get maxLine => $_getI64(14);
  @$pb.TagNumber(15)
  set maxLine($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(15)
  $core.bool hasMaxLine() => $_has(14);
  @$pb.TagNumber(15)
  void clearMaxLine() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.bool get invisible => $_getBF(15);
  @$pb.TagNumber(16)
  set invisible($core.bool value) => $_setBool(15, value);
  @$pb.TagNumber(16)
  $core.bool hasInvisible() => $_has(15);
  @$pb.TagNumber(16)
  void clearInvisible() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.bool get isContractor => $_getBF(16);
  @$pb.TagNumber(17)
  set isContractor($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasIsContractor() => $_has(16);
  @$pb.TagNumber(17)
  void clearIsContractor() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.bool get isNote => $_getBF(17);
  @$pb.TagNumber(18)
  set isNote($core.bool value) => $_setBool(17, value);
  @$pb.TagNumber(18)
  $core.bool hasIsNote() => $_has(17);
  @$pb.TagNumber(18)
  void clearIsNote() => $_clearField(18);

  @$pb.TagNumber(19)
  $pb.PbList<ReplyCardLabel> get cardLabels => $_getList(18);

  @$pb.TagNumber(20)
  $core.String get subReplyEntryText => $_getSZ(19);
  @$pb.TagNumber(20)
  set subReplyEntryText($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasSubReplyEntryText() => $_has(19);
  @$pb.TagNumber(20)
  void clearSubReplyEntryText() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get subReplyTitleText => $_getSZ(20);
  @$pb.TagNumber(21)
  set subReplyTitleText($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasSubReplyTitleText() => $_has(20);
  @$pb.TagNumber(21)
  void clearSubReplyTitleText() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.String get contractDesc => $_getSZ(21);
  @$pb.TagNumber(22)
  set contractDesc($core.String value) => $_setString(21, value);
  @$pb.TagNumber(22)
  $core.bool hasContractDesc() => $_has(21);
  @$pb.TagNumber(22)
  void clearContractDesc() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.String get timeDesc => $_getSZ(22);
  @$pb.TagNumber(23)
  set timeDesc($core.String value) => $_setString(22, value);
  @$pb.TagNumber(23)
  $core.bool hasTimeDesc() => $_has(22);
  @$pb.TagNumber(23)
  void clearTimeDesc() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.String get bizScene => $_getSZ(23);
  @$pb.TagNumber(24)
  set bizScene($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasBizScene() => $_has(23);
  @$pb.TagNumber(24)
  void clearBizScene() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.String get location => $_getSZ(24);
  @$pb.TagNumber(25)
  set location($core.String value) => $_setString(24, value);
  @$pb.TagNumber(25)
  $core.bool hasLocation() => $_has(24);
  @$pb.TagNumber(25)
  void clearLocation() => $_clearField(25);

  @$pb.TagNumber(26)
  $core.bool get foldPictures => $_getBF(25);
  @$pb.TagNumber(26)
  set foldPictures($core.bool value) => $_setBool(25, value);
  @$pb.TagNumber(26)
  $core.bool hasFoldPictures() => $_has(25);
  @$pb.TagNumber(26)
  void clearFoldPictures() => $_clearField(26);

  @$pb.TagNumber(27)
  $core.bool get isNoteV2 => $_getBF(26);
  @$pb.TagNumber(27)
  set isNoteV2($core.bool value) => $_setBool(26, value);
  @$pb.TagNumber(27)
  $core.bool hasIsNoteV2() => $_has(26);
  @$pb.TagNumber(27)
  void clearIsNoteV2() => $_clearField(27);

  @$pb.TagNumber(28)
  $core.bool get hideNoteIcon => $_getBF(27);
  @$pb.TagNumber(28)
  set hideNoteIcon($core.bool value) => $_setBool(27, value);
  @$pb.TagNumber(28)
  $core.bool hasHideNoteIcon() => $_has(27);
  @$pb.TagNumber(28)
  void clearHideNoteIcon() => $_clearField(28);

  @$pb.TagNumber(29)
  $core.String get cmRecommendComponent => $_getSZ(28);
  @$pb.TagNumber(29)
  set cmRecommendComponent($core.String value) => $_setString(28, value);
  @$pb.TagNumber(29)
  $core.bool hasCmRecommendComponent() => $_has(28);
  @$pb.TagNumber(29)
  void clearCmRecommendComponent() => $_clearField(29);

  @$pb.TagNumber(30)
  ReplyControl_VoteOption get voteOption => $_getN(29);
  @$pb.TagNumber(30)
  set voteOption(ReplyControl_VoteOption value) => $_setField(30, value);
  @$pb.TagNumber(30)
  $core.bool hasVoteOption() => $_has(29);
  @$pb.TagNumber(30)
  void clearVoteOption() => $_clearField(30);
  @$pb.TagNumber(30)
  ReplyControl_VoteOption ensureVoteOption() => $_ensure(29);

  @$pb.TagNumber(31)
  $core.String get chargedDesc => $_getSZ(30);
  @$pb.TagNumber(31)
  set chargedDesc($core.String value) => $_setString(30, value);
  @$pb.TagNumber(31)
  $core.bool hasChargedDesc() => $_has(30);
  @$pb.TagNumber(31)
  void clearChargedDesc() => $_clearField(31);

  @$pb.TagNumber(32)
  ReplyControl_GradeRecord get gradeRecord => $_getN(31);
  @$pb.TagNumber(32)
  set gradeRecord(ReplyControl_GradeRecord value) => $_setField(32, value);
  @$pb.TagNumber(32)
  $core.bool hasGradeRecord() => $_has(31);
  @$pb.TagNumber(32)
  void clearGradeRecord() => $_clearField(32);
  @$pb.TagNumber(32)
  ReplyControl_GradeRecord ensureGradeRecord() => $_ensure(31);

  @$pb.TagNumber(33)
  $core.String get presetReplyText => $_getSZ(32);
  @$pb.TagNumber(33)
  set presetReplyText($core.String value) => $_setString(32, value);
  @$pb.TagNumber(33)
  $core.bool hasPresetReplyText() => $_has(32);
  @$pb.TagNumber(33)
  void clearPresetReplyText() => $_clearField(33);

  @$pb.TagNumber(34)
  ReplyControl_EasterEggLabel get easterEggLabel => $_getN(33);
  @$pb.TagNumber(34)
  set easterEggLabel(ReplyControl_EasterEggLabel value) =>
      $_setField(34, value);
  @$pb.TagNumber(34)
  $core.bool hasEasterEggLabel() => $_has(33);
  @$pb.TagNumber(34)
  void clearEasterEggLabel() => $_clearField(34);
  @$pb.TagNumber(34)
  ReplyControl_EasterEggLabel ensureEasterEggLabel() => $_ensure(33);

  @$pb.TagNumber(35)
  $core.String get contextFeature => $_getSZ(34);
  @$pb.TagNumber(35)
  set contextFeature($core.String value) => $_setString(34, value);
  @$pb.TagNumber(35)
  $core.bool hasContextFeature() => $_has(34);
  @$pb.TagNumber(35)
  void clearContextFeature() => $_clearField(35);

  @$pb.TagNumber(36)
  ReplyControl_InsertEffect get insertEffect => $_getN(35);
  @$pb.TagNumber(36)
  set insertEffect(ReplyControl_InsertEffect value) => $_setField(36, value);
  @$pb.TagNumber(36)
  $core.bool hasInsertEffect() => $_has(35);
  @$pb.TagNumber(36)
  void clearInsertEffect() => $_clearField(36);
  @$pb.TagNumber(36)
  ReplyControl_InsertEffect ensureInsertEffect() => $_ensure(35);

  @$pb.TagNumber(37)
  TranslationSwitch get translationSwitch => $_getN(36);
  @$pb.TagNumber(37)
  set translationSwitch(TranslationSwitch value) => $_setField(37, value);
  @$pb.TagNumber(37)
  $core.bool hasTranslationSwitch() => $_has(36);
  @$pb.TagNumber(37)
  void clearTranslationSwitch() => $_clearField(37);

  /// extra field
  @$pb.TagNumber(100)
  $core.bool get showTranslation => $_getBF(37);
  @$pb.TagNumber(100)
  set showTranslation($core.bool value) => $_setBool(37, value);
  @$pb.TagNumber(100)
  $core.bool hasShowTranslation() => $_has(37);
  @$pb.TagNumber(100)
  void clearShowTranslation() => $_clearField(100);
}

class ReplyExtra extends $pb.GeneratedMessage {
  factory ReplyExtra({
    $fixnum.Int64? seasonId,
    $fixnum.Int64? seasonType,
    $fixnum.Int64? epId,
    $core.bool? isStory,
    $core.String? spmid,
    $core.String? fromSpmid,
    $core.bool? disableUnderline,
    $core.bool? disableWeSearch,
    $core.bool? disableFilterTag,
    $core.bool? isActivityMode,
    $core.String? trackId,
  }) {
    final result = create();
    if (seasonId != null) result.seasonId = seasonId;
    if (seasonType != null) result.seasonType = seasonType;
    if (epId != null) result.epId = epId;
    if (isStory != null) result.isStory = isStory;
    if (spmid != null) result.spmid = spmid;
    if (fromSpmid != null) result.fromSpmid = fromSpmid;
    if (disableUnderline != null) result.disableUnderline = disableUnderline;
    if (disableWeSearch != null) result.disableWeSearch = disableWeSearch;
    if (disableFilterTag != null) result.disableFilterTag = disableFilterTag;
    if (isActivityMode != null) result.isActivityMode = isActivityMode;
    if (trackId != null) result.trackId = trackId;
    return result;
  }

  ReplyExtra._();

  factory ReplyExtra.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplyExtra.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyExtra',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'seasonId')
    ..aInt64(2, _omitFieldNames ? '' : 'seasonType')
    ..aInt64(3, _omitFieldNames ? '' : 'epId')
    ..aOB(4, _omitFieldNames ? '' : 'isStory')
    ..aOS(5, _omitFieldNames ? '' : 'spmid')
    ..aOS(6, _omitFieldNames ? '' : 'fromSpmid')
    ..aOB(7, _omitFieldNames ? '' : 'disableUnderline')
    ..aOB(8, _omitFieldNames ? '' : 'disableWeSearch')
    ..aOB(9, _omitFieldNames ? '' : 'disableFilterTag')
    ..aOB(10, _omitFieldNames ? '' : 'isActivityMode')
    ..aOS(11, _omitFieldNames ? '' : 'trackId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyExtra clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyExtra copyWith(void Function(ReplyExtra) updates) =>
      super.copyWith((message) => updates(message as ReplyExtra)) as ReplyExtra;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplyExtra create() => ReplyExtra._();
  @$core.override
  ReplyExtra createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReplyExtra getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyExtra>(create);
  static ReplyExtra? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get seasonId => $_getI64(0);
  @$pb.TagNumber(1)
  set seasonId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeasonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeasonId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get seasonType => $_getI64(1);
  @$pb.TagNumber(2)
  set seasonType($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSeasonType() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeasonType() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get epId => $_getI64(2);
  @$pb.TagNumber(3)
  set epId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEpId() => $_has(2);
  @$pb.TagNumber(3)
  void clearEpId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isStory => $_getBF(3);
  @$pb.TagNumber(4)
  set isStory($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsStory() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsStory() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get spmid => $_getSZ(4);
  @$pb.TagNumber(5)
  set spmid($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSpmid() => $_has(4);
  @$pb.TagNumber(5)
  void clearSpmid() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get fromSpmid => $_getSZ(5);
  @$pb.TagNumber(6)
  set fromSpmid($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFromSpmid() => $_has(5);
  @$pb.TagNumber(6)
  void clearFromSpmid() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get disableUnderline => $_getBF(6);
  @$pb.TagNumber(7)
  set disableUnderline($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDisableUnderline() => $_has(6);
  @$pb.TagNumber(7)
  void clearDisableUnderline() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get disableWeSearch => $_getBF(7);
  @$pb.TagNumber(8)
  set disableWeSearch($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDisableWeSearch() => $_has(7);
  @$pb.TagNumber(8)
  void clearDisableWeSearch() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get disableFilterTag => $_getBF(8);
  @$pb.TagNumber(9)
  set disableFilterTag($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDisableFilterTag() => $_has(8);
  @$pb.TagNumber(9)
  void clearDisableFilterTag() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get isActivityMode => $_getBF(9);
  @$pb.TagNumber(10)
  set isActivityMode($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIsActivityMode() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsActivityMode() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get trackId => $_getSZ(10);
  @$pb.TagNumber(11)
  set trackId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasTrackId() => $_has(10);
  @$pb.TagNumber(11)
  void clearTrackId() => $_clearField(11);
}

class ReplyInAppPushPayload_Content extends $pb.GeneratedMessage {
  factory ReplyInAppPushPayload_Content({
    $core.String? message,
    $core.Iterable<$core.MapEntry<$core.String, Emote>>? emotes,
    $core.Iterable<$core.MapEntry<$core.String, $fixnum.Int64>>? atNameToMid,
    $core.Iterable<Picture>? pictures,
  }) {
    final result = create();
    if (message != null) result.message = message;
    if (emotes != null) result.emotes.addEntries(emotes);
    if (atNameToMid != null) result.atNameToMid.addEntries(atNameToMid);
    if (pictures != null) result.pictures.addAll(pictures);
    return result;
  }

  ReplyInAppPushPayload_Content._();

  factory ReplyInAppPushPayload_Content.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplyInAppPushPayload_Content.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyInAppPushPayload.Content',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..m<$core.String, Emote>(2, _omitFieldNames ? '' : 'emotes',
        entryClassName: 'ReplyInAppPushPayload.Content.EmotesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: Emote.create,
        valueDefaultOrMaker: Emote.getDefault,
        packageName: const $pb.PackageName('bilibili.main.community.reply.v1'))
    ..m<$core.String, $fixnum.Int64>(3, _omitFieldNames ? '' : 'atNameToMid',
        entryClassName: 'ReplyInAppPushPayload.Content.AtNameToMidEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O6,
        packageName: const $pb.PackageName('bilibili.main.community.reply.v1'))
    ..pPM<Picture>(4, _omitFieldNames ? '' : 'pictures',
        subBuilder: Picture.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInAppPushPayload_Content clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInAppPushPayload_Content copyWith(
          void Function(ReplyInAppPushPayload_Content) updates) =>
      super.copyWith(
              (message) => updates(message as ReplyInAppPushPayload_Content))
          as ReplyInAppPushPayload_Content;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplyInAppPushPayload_Content create() =>
      ReplyInAppPushPayload_Content._();
  @$core.override
  ReplyInAppPushPayload_Content createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReplyInAppPushPayload_Content getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyInAppPushPayload_Content>(create);
  static ReplyInAppPushPayload_Content? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, Emote> get emotes => $_getMap(1);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $fixnum.Int64> get atNameToMid => $_getMap(2);

  @$pb.TagNumber(4)
  $pb.PbList<Picture> get pictures => $_getList(3);
}

class ReplyInAppPushPayload_Member extends $pb.GeneratedMessage {
  factory ReplyInAppPushPayload_Member({
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

  ReplyInAppPushPayload_Member._();

  factory ReplyInAppPushPayload_Member.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplyInAppPushPayload_Member.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyInAppPushPayload.Member',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'face')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInAppPushPayload_Member clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInAppPushPayload_Member copyWith(
          void Function(ReplyInAppPushPayload_Member) updates) =>
      super.copyWith(
              (message) => updates(message as ReplyInAppPushPayload_Member))
          as ReplyInAppPushPayload_Member;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplyInAppPushPayload_Member create() =>
      ReplyInAppPushPayload_Member._();
  @$core.override
  ReplyInAppPushPayload_Member createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReplyInAppPushPayload_Member getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyInAppPushPayload_Member>(create);
  static ReplyInAppPushPayload_Member? _defaultInstance;

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
  $core.String get face => $_getSZ(2);
  @$pb.TagNumber(3)
  set face($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFace() => $_has(2);
  @$pb.TagNumber(3)
  void clearFace() => $_clearField(3);
}

class ReplyInAppPushPayload_Reply extends $pb.GeneratedMessage {
  factory ReplyInAppPushPayload_Reply({
    $fixnum.Int64? id,
    $fixnum.Int64? type,
    $fixnum.Int64? oid,
    $fixnum.Int64? mid,
    $fixnum.Int64? root,
    $fixnum.Int64? parent,
    $fixnum.Int64? dialog,
    $fixnum.Int64? ctime,
    ReplyInAppPushPayload_Content? content,
    ReplyInAppPushPayload_Member? member,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (type != null) result.type = type;
    if (oid != null) result.oid = oid;
    if (mid != null) result.mid = mid;
    if (root != null) result.root = root;
    if (parent != null) result.parent = parent;
    if (dialog != null) result.dialog = dialog;
    if (ctime != null) result.ctime = ctime;
    if (content != null) result.content = content;
    if (member != null) result.member = member;
    return result;
  }

  ReplyInAppPushPayload_Reply._();

  factory ReplyInAppPushPayload_Reply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplyInAppPushPayload_Reply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyInAppPushPayload.Reply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aInt64(2, _omitFieldNames ? '' : 'type')
    ..aInt64(3, _omitFieldNames ? '' : 'oid')
    ..aInt64(4, _omitFieldNames ? '' : 'mid')
    ..aInt64(5, _omitFieldNames ? '' : 'root')
    ..aInt64(6, _omitFieldNames ? '' : 'parent')
    ..aInt64(7, _omitFieldNames ? '' : 'dialog')
    ..aInt64(8, _omitFieldNames ? '' : 'ctime')
    ..aOM<ReplyInAppPushPayload_Content>(9, _omitFieldNames ? '' : 'content',
        subBuilder: ReplyInAppPushPayload_Content.create)
    ..aOM<ReplyInAppPushPayload_Member>(10, _omitFieldNames ? '' : 'member',
        subBuilder: ReplyInAppPushPayload_Member.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInAppPushPayload_Reply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInAppPushPayload_Reply copyWith(
          void Function(ReplyInAppPushPayload_Reply) updates) =>
      super.copyWith(
              (message) => updates(message as ReplyInAppPushPayload_Reply))
          as ReplyInAppPushPayload_Reply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplyInAppPushPayload_Reply create() =>
      ReplyInAppPushPayload_Reply._();
  @$core.override
  ReplyInAppPushPayload_Reply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReplyInAppPushPayload_Reply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyInAppPushPayload_Reply>(create);
  static ReplyInAppPushPayload_Reply? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get type => $_getI64(1);
  @$pb.TagNumber(2)
  set type($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get oid => $_getI64(2);
  @$pb.TagNumber(3)
  set oid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOid() => $_has(2);
  @$pb.TagNumber(3)
  void clearOid() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get mid => $_getI64(3);
  @$pb.TagNumber(4)
  set mid($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMid() => $_has(3);
  @$pb.TagNumber(4)
  void clearMid() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get root => $_getI64(4);
  @$pb.TagNumber(5)
  set root($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRoot() => $_has(4);
  @$pb.TagNumber(5)
  void clearRoot() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get parent => $_getI64(5);
  @$pb.TagNumber(6)
  set parent($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasParent() => $_has(5);
  @$pb.TagNumber(6)
  void clearParent() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get dialog => $_getI64(6);
  @$pb.TagNumber(7)
  set dialog($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDialog() => $_has(6);
  @$pb.TagNumber(7)
  void clearDialog() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get ctime => $_getI64(7);
  @$pb.TagNumber(8)
  set ctime($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCtime() => $_has(7);
  @$pb.TagNumber(8)
  void clearCtime() => $_clearField(8);

  @$pb.TagNumber(9)
  ReplyInAppPushPayload_Content get content => $_getN(8);
  @$pb.TagNumber(9)
  set content(ReplyInAppPushPayload_Content value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasContent() => $_has(8);
  @$pb.TagNumber(9)
  void clearContent() => $_clearField(9);
  @$pb.TagNumber(9)
  ReplyInAppPushPayload_Content ensureContent() => $_ensure(8);

  @$pb.TagNumber(10)
  ReplyInAppPushPayload_Member get member => $_getN(9);
  @$pb.TagNumber(10)
  set member(ReplyInAppPushPayload_Member value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasMember() => $_has(9);
  @$pb.TagNumber(10)
  void clearMember() => $_clearField(10);
  @$pb.TagNumber(10)
  ReplyInAppPushPayload_Member ensureMember() => $_ensure(9);
}

class ReplyInAppPushPayload_Subject extends $pb.GeneratedMessage {
  factory ReplyInAppPushPayload_Subject({
    $fixnum.Int64? type,
    $fixnum.Int64? oid,
    $fixnum.Int64? upMid,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (oid != null) result.oid = oid;
    if (upMid != null) result.upMid = upMid;
    return result;
  }

  ReplyInAppPushPayload_Subject._();

  factory ReplyInAppPushPayload_Subject.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplyInAppPushPayload_Subject.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyInAppPushPayload.Subject',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'type')
    ..aInt64(2, _omitFieldNames ? '' : 'oid')
    ..aInt64(3, _omitFieldNames ? '' : 'upMid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInAppPushPayload_Subject clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInAppPushPayload_Subject copyWith(
          void Function(ReplyInAppPushPayload_Subject) updates) =>
      super.copyWith(
              (message) => updates(message as ReplyInAppPushPayload_Subject))
          as ReplyInAppPushPayload_Subject;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplyInAppPushPayload_Subject create() =>
      ReplyInAppPushPayload_Subject._();
  @$core.override
  ReplyInAppPushPayload_Subject createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReplyInAppPushPayload_Subject getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyInAppPushPayload_Subject>(create);
  static ReplyInAppPushPayload_Subject? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get type => $_getI64(0);
  @$pb.TagNumber(1)
  set type($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get oid => $_getI64(1);
  @$pb.TagNumber(2)
  set oid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get upMid => $_getI64(2);
  @$pb.TagNumber(3)
  set upMid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUpMid() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpMid() => $_clearField(3);
}

class ReplyInAppPushPayload_SubjectMaterial_Archive
    extends $pb.GeneratedMessage {
  factory ReplyInAppPushPayload_SubjectMaterial_Archive({
    $fixnum.Int64? aid,
    $core.String? title,
    $core.String? cover,
  }) {
    final result = create();
    if (aid != null) result.aid = aid;
    if (title != null) result.title = title;
    if (cover != null) result.cover = cover;
    return result;
  }

  ReplyInAppPushPayload_SubjectMaterial_Archive._();

  factory ReplyInAppPushPayload_SubjectMaterial_Archive.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplyInAppPushPayload_SubjectMaterial_Archive.fromJson(
          $core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyInAppPushPayload.SubjectMaterial.Archive',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'cover')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInAppPushPayload_SubjectMaterial_Archive clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInAppPushPayload_SubjectMaterial_Archive copyWith(
          void Function(ReplyInAppPushPayload_SubjectMaterial_Archive)
              updates) =>
      super.copyWith((message) =>
              updates(message as ReplyInAppPushPayload_SubjectMaterial_Archive))
          as ReplyInAppPushPayload_SubjectMaterial_Archive;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplyInAppPushPayload_SubjectMaterial_Archive create() =>
      ReplyInAppPushPayload_SubjectMaterial_Archive._();
  @$core.override
  ReplyInAppPushPayload_SubjectMaterial_Archive createEmptyInstance() =>
      create();
  @$core.pragma('dart2js:noInline')
  static ReplyInAppPushPayload_SubjectMaterial_Archive getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          ReplyInAppPushPayload_SubjectMaterial_Archive>(create);
  static ReplyInAppPushPayload_SubjectMaterial_Archive? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get aid => $_getI64(0);
  @$pb.TagNumber(1)
  set aid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => $_clearField(1);

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
}

enum ReplyInAppPushPayload_SubjectMaterial_Item { arc, notSet }

class ReplyInAppPushPayload_SubjectMaterial extends $pb.GeneratedMessage {
  factory ReplyInAppPushPayload_SubjectMaterial({
    ReplyInAppPushPayload_SubjectMaterial_Archive? arc,
  }) {
    final result = create();
    if (arc != null) result.arc = arc;
    return result;
  }

  ReplyInAppPushPayload_SubjectMaterial._();

  factory ReplyInAppPushPayload_SubjectMaterial.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplyInAppPushPayload_SubjectMaterial.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ReplyInAppPushPayload_SubjectMaterial_Item>
      _ReplyInAppPushPayload_SubjectMaterial_ItemByTag = {
    1: ReplyInAppPushPayload_SubjectMaterial_Item.arc,
    0: ReplyInAppPushPayload_SubjectMaterial_Item.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyInAppPushPayload.SubjectMaterial',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..oo(0, [1])
    ..aOM<ReplyInAppPushPayload_SubjectMaterial_Archive>(
        1, _omitFieldNames ? '' : 'arc',
        subBuilder: ReplyInAppPushPayload_SubjectMaterial_Archive.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInAppPushPayload_SubjectMaterial clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInAppPushPayload_SubjectMaterial copyWith(
          void Function(ReplyInAppPushPayload_SubjectMaterial) updates) =>
      super.copyWith((message) =>
              updates(message as ReplyInAppPushPayload_SubjectMaterial))
          as ReplyInAppPushPayload_SubjectMaterial;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplyInAppPushPayload_SubjectMaterial create() =>
      ReplyInAppPushPayload_SubjectMaterial._();
  @$core.override
  ReplyInAppPushPayload_SubjectMaterial createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReplyInAppPushPayload_SubjectMaterial getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          ReplyInAppPushPayload_SubjectMaterial>(create);
  static ReplyInAppPushPayload_SubjectMaterial? _defaultInstance;

  @$pb.TagNumber(1)
  ReplyInAppPushPayload_SubjectMaterial_Item whichItem() =>
      _ReplyInAppPushPayload_SubjectMaterial_ItemByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  void clearItem() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ReplyInAppPushPayload_SubjectMaterial_Archive get arc => $_getN(0);
  @$pb.TagNumber(1)
  set arc(ReplyInAppPushPayload_SubjectMaterial_Archive value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArc() => $_has(0);
  @$pb.TagNumber(1)
  void clearArc() => $_clearField(1);
  @$pb.TagNumber(1)
  ReplyInAppPushPayload_SubjectMaterial_Archive ensureArc() => $_ensure(0);
}

class ReplyInAppPushPayload extends $pb.GeneratedMessage {
  factory ReplyInAppPushPayload({
    ReplyInAppPushPayload_Reply? reply,
    ReplyInAppPushPayload_Reply? parentReply,
    ReplyInAppPushPayload_Subject? subject,
    ReplyInAppPushPayload_SubjectMaterial? subjectMaterial,
  }) {
    final result = create();
    if (reply != null) result.reply = reply;
    if (parentReply != null) result.parentReply = parentReply;
    if (subject != null) result.subject = subject;
    if (subjectMaterial != null) result.subjectMaterial = subjectMaterial;
    return result;
  }

  ReplyInAppPushPayload._();

  factory ReplyInAppPushPayload.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplyInAppPushPayload.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyInAppPushPayload',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOM<ReplyInAppPushPayload_Reply>(1, _omitFieldNames ? '' : 'reply',
        subBuilder: ReplyInAppPushPayload_Reply.create)
    ..aOM<ReplyInAppPushPayload_Reply>(2, _omitFieldNames ? '' : 'parentReply',
        subBuilder: ReplyInAppPushPayload_Reply.create)
    ..aOM<ReplyInAppPushPayload_Subject>(3, _omitFieldNames ? '' : 'subject',
        subBuilder: ReplyInAppPushPayload_Subject.create)
    ..aOM<ReplyInAppPushPayload_SubjectMaterial>(
        4, _omitFieldNames ? '' : 'subjectMaterial',
        subBuilder: ReplyInAppPushPayload_SubjectMaterial.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInAppPushPayload clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInAppPushPayload copyWith(
          void Function(ReplyInAppPushPayload) updates) =>
      super.copyWith((message) => updates(message as ReplyInAppPushPayload))
          as ReplyInAppPushPayload;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplyInAppPushPayload create() => ReplyInAppPushPayload._();
  @$core.override
  ReplyInAppPushPayload createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReplyInAppPushPayload getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyInAppPushPayload>(create);
  static ReplyInAppPushPayload? _defaultInstance;

  @$pb.TagNumber(1)
  ReplyInAppPushPayload_Reply get reply => $_getN(0);
  @$pb.TagNumber(1)
  set reply(ReplyInAppPushPayload_Reply value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReply() => $_has(0);
  @$pb.TagNumber(1)
  void clearReply() => $_clearField(1);
  @$pb.TagNumber(1)
  ReplyInAppPushPayload_Reply ensureReply() => $_ensure(0);

  @$pb.TagNumber(2)
  ReplyInAppPushPayload_Reply get parentReply => $_getN(1);
  @$pb.TagNumber(2)
  set parentReply(ReplyInAppPushPayload_Reply value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasParentReply() => $_has(1);
  @$pb.TagNumber(2)
  void clearParentReply() => $_clearField(2);
  @$pb.TagNumber(2)
  ReplyInAppPushPayload_Reply ensureParentReply() => $_ensure(1);

  @$pb.TagNumber(3)
  ReplyInAppPushPayload_Subject get subject => $_getN(2);
  @$pb.TagNumber(3)
  set subject(ReplyInAppPushPayload_Subject value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSubject() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubject() => $_clearField(3);
  @$pb.TagNumber(3)
  ReplyInAppPushPayload_Subject ensureSubject() => $_ensure(2);

  @$pb.TagNumber(4)
  ReplyInAppPushPayload_SubjectMaterial get subjectMaterial => $_getN(3);
  @$pb.TagNumber(4)
  set subjectMaterial(ReplyInAppPushPayload_SubjectMaterial value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSubjectMaterial() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubjectMaterial() => $_clearField(4);
  @$pb.TagNumber(4)
  ReplyInAppPushPayload_SubjectMaterial ensureSubjectMaterial() => $_ensure(3);
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
    Member? member,
    ReplyControl? replyControl,
    MemberV2? memberV2,
    $core.String? trackInfo,
    Content? translatedContent,
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
    if (member != null) result.member = member;
    if (replyControl != null) result.replyControl = replyControl;
    if (memberV2 != null) result.memberV2 = memberV2;
    if (trackInfo != null) result.trackInfo = trackInfo;
    if (translatedContent != null) result.translatedContent = translatedContent;
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
    ..aOM<Member>(13, _omitFieldNames ? '' : 'member',
        subBuilder: Member.create)
    ..aOM<ReplyControl>(14, _omitFieldNames ? '' : 'replyControl',
        subBuilder: ReplyControl.create)
    ..aOM<MemberV2>(15, _omitFieldNames ? '' : 'memberV2',
        subBuilder: MemberV2.create)
    ..aOS(16, _omitFieldNames ? '' : 'trackInfo')
    ..aOM<Content>(17, _omitFieldNames ? '' : 'translatedContent',
        subBuilder: Content.create)
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

  @$pb.TagNumber(13)
  Member get member => $_getN(12);
  @$pb.TagNumber(13)
  set member(Member value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasMember() => $_has(12);
  @$pb.TagNumber(13)
  void clearMember() => $_clearField(13);
  @$pb.TagNumber(13)
  Member ensureMember() => $_ensure(12);

  @$pb.TagNumber(14)
  ReplyControl get replyControl => $_getN(13);
  @$pb.TagNumber(14)
  set replyControl(ReplyControl value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasReplyControl() => $_has(13);
  @$pb.TagNumber(14)
  void clearReplyControl() => $_clearField(14);
  @$pb.TagNumber(14)
  ReplyControl ensureReplyControl() => $_ensure(13);

  @$pb.TagNumber(15)
  MemberV2 get memberV2 => $_getN(14);
  @$pb.TagNumber(15)
  set memberV2(MemberV2 value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasMemberV2() => $_has(14);
  @$pb.TagNumber(15)
  void clearMemberV2() => $_clearField(15);
  @$pb.TagNumber(15)
  MemberV2 ensureMemberV2() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.String get trackInfo => $_getSZ(15);
  @$pb.TagNumber(16)
  set trackInfo($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasTrackInfo() => $_has(15);
  @$pb.TagNumber(16)
  void clearTrackInfo() => $_clearField(16);

  @$pb.TagNumber(17)
  Content get translatedContent => $_getN(16);
  @$pb.TagNumber(17)
  set translatedContent(Content value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasTranslatedContent() => $_has(16);
  @$pb.TagNumber(17)
  void clearTranslatedContent() => $_clearField(17);
  @$pb.TagNumber(17)
  Content ensureTranslatedContent() => $_ensure(16);
}

class ReplyInfoReply extends $pb.GeneratedMessage {
  factory ReplyInfoReply({
    ReplyInfo? reply,
  }) {
    final result = create();
    if (reply != null) result.reply = reply;
    return result;
  }

  ReplyInfoReply._();

  factory ReplyInfoReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplyInfoReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyInfoReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOM<ReplyInfo>(1, _omitFieldNames ? '' : 'reply',
        subBuilder: ReplyInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInfoReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInfoReply copyWith(void Function(ReplyInfoReply) updates) =>
      super.copyWith((message) => updates(message as ReplyInfoReply))
          as ReplyInfoReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplyInfoReply create() => ReplyInfoReply._();
  @$core.override
  ReplyInfoReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReplyInfoReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyInfoReply>(create);
  static ReplyInfoReply? _defaultInstance;

  @$pb.TagNumber(1)
  ReplyInfo get reply => $_getN(0);
  @$pb.TagNumber(1)
  set reply(ReplyInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReply() => $_has(0);
  @$pb.TagNumber(1)
  void clearReply() => $_clearField(1);
  @$pb.TagNumber(1)
  ReplyInfo ensureReply() => $_ensure(0);
}

class ReplyInfoReq extends $pb.GeneratedMessage {
  factory ReplyInfoReq({
    $fixnum.Int64? rpid,
    ReplyInfoReq_ReplyInfoScene? scene,
  }) {
    final result = create();
    if (rpid != null) result.rpid = rpid;
    if (scene != null) result.scene = scene;
    return result;
  }

  ReplyInfoReq._();

  factory ReplyInfoReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplyInfoReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyInfoReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'rpid')
    ..aE<ReplyInfoReq_ReplyInfoScene>(2, _omitFieldNames ? '' : 'scene',
        enumValues: ReplyInfoReq_ReplyInfoScene.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInfoReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyInfoReq copyWith(void Function(ReplyInfoReq) updates) =>
      super.copyWith((message) => updates(message as ReplyInfoReq))
          as ReplyInfoReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplyInfoReq create() => ReplyInfoReq._();
  @$core.override
  ReplyInfoReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReplyInfoReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyInfoReq>(create);
  static ReplyInfoReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get rpid => $_getI64(0);
  @$pb.TagNumber(1)
  set rpid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRpid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRpid() => $_clearField(1);

  @$pb.TagNumber(2)
  ReplyInfoReq_ReplyInfoScene get scene => $_getN(1);
  @$pb.TagNumber(2)
  set scene(ReplyInfoReq_ReplyInfoScene value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasScene() => $_has(1);
  @$pb.TagNumber(2)
  void clearScene() => $_clearField(2);
}

class ReplyTrackInfo extends $pb.GeneratedMessage {
  factory ReplyTrackInfo({
    $core.String? trackId,
  }) {
    final result = create();
    if (trackId != null) result.trackId = trackId;
    return result;
  }

  ReplyTrackInfo._();

  factory ReplyTrackInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReplyTrackInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReplyTrackInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trackId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyTrackInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReplyTrackInfo copyWith(void Function(ReplyTrackInfo) updates) =>
      super.copyWith((message) => updates(message as ReplyTrackInfo))
          as ReplyTrackInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReplyTrackInfo create() => ReplyTrackInfo._();
  @$core.override
  ReplyTrackInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReplyTrackInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReplyTrackInfo>(create);
  static ReplyTrackInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trackId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trackId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrackId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrackId() => $_clearField(1);
}

enum RichText_Item { note, opus, notSet }

class RichText extends $pb.GeneratedMessage {
  factory RichText({
    RichTextNote? note,
    $6.OpusItem? opus,
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
    ..aOM<$6.OpusItem>(2, _omitFieldNames ? '' : 'opus',
        subBuilder: $6.OpusItem.create)
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
  $6.OpusItem get opus => $_getN(1);
  @$pb.TagNumber(2)
  set opus($6.OpusItem value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpus() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpus() => $_clearField(2);
  @$pb.TagNumber(2)
  $6.OpusItem ensureOpus() => $_ensure(1);
}

class RichTextNote extends $pb.GeneratedMessage {
  factory RichTextNote({
    $core.String? summary,
    $core.Iterable<$core.String>? images,
    $core.String? clickUrl,
    $core.String? lastMtimeText,
  }) {
    final result = create();
    if (summary != null) result.summary = summary;
    if (images != null) result.images.addAll(images);
    if (clickUrl != null) result.clickUrl = clickUrl;
    if (lastMtimeText != null) result.lastMtimeText = lastMtimeText;
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
    ..aOS(1, _omitFieldNames ? '' : 'summary')
    ..pPS(2, _omitFieldNames ? '' : 'images')
    ..aOS(3, _omitFieldNames ? '' : 'clickUrl')
    ..aOS(4, _omitFieldNames ? '' : 'lastMtimeText')
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

  @$pb.TagNumber(1)
  $core.String get summary => $_getSZ(0);
  @$pb.TagNumber(1)
  set summary($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get images => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get clickUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set clickUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasClickUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearClickUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get lastMtimeText => $_getSZ(3);
  @$pb.TagNumber(4)
  set lastMtimeText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLastMtimeText() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastMtimeText() => $_clearField(4);
}

enum SearchItem_Item { goods, video, article, notSet }

class SearchItem extends $pb.GeneratedMessage {
  factory SearchItem({
    $core.String? url,
    GoodsSearchItem? goods,
    VideoSearchItem? video,
    ArticleSearchItem? article,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (goods != null) result.goods = goods;
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
    2: SearchItem_Item.goods,
    3: SearchItem_Item.video,
    4: SearchItem_Item.article,
    0: SearchItem_Item.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOM<GoodsSearchItem>(2, _omitFieldNames ? '' : 'goods',
        subBuilder: GoodsSearchItem.create)
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

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  SearchItem_Item whichItem() => _SearchItem_ItemByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
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

  @$pb.TagNumber(2)
  GoodsSearchItem get goods => $_getN(1);
  @$pb.TagNumber(2)
  set goods(GoodsSearchItem value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasGoods() => $_has(1);
  @$pb.TagNumber(2)
  void clearGoods() => $_clearField(2);
  @$pb.TagNumber(2)
  GoodsSearchItem ensureGoods() => $_ensure(1);

  @$pb.TagNumber(3)
  VideoSearchItem get video => $_getN(2);
  @$pb.TagNumber(3)
  set video(VideoSearchItem value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasVideo() => $_has(2);
  @$pb.TagNumber(3)
  void clearVideo() => $_clearField(3);
  @$pb.TagNumber(3)
  VideoSearchItem ensureVideo() => $_ensure(2);

  @$pb.TagNumber(4)
  ArticleSearchItem get article => $_getN(3);
  @$pb.TagNumber(4)
  set article(ArticleSearchItem value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasArticle() => $_has(3);
  @$pb.TagNumber(4)
  void clearArticle() => $_clearField(4);
  @$pb.TagNumber(4)
  ArticleSearchItem ensureArticle() => $_ensure(3);
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

class SearchItemPreHookReply extends $pb.GeneratedMessage {
  factory SearchItemPreHookReply({
    $core.String? placeholderText,
    $core.String? backgroundText,
    $core.Iterable<$core.int>? orderedType,
  }) {
    final result = create();
    if (placeholderText != null) result.placeholderText = placeholderText;
    if (backgroundText != null) result.backgroundText = backgroundText;
    if (orderedType != null) result.orderedType.addAll(orderedType);
    return result;
  }

  SearchItemPreHookReply._();

  factory SearchItemPreHookReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchItemPreHookReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchItemPreHookReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'placeholderText')
    ..aOS(2, _omitFieldNames ? '' : 'backgroundText')
    ..p<$core.int>(3, _omitFieldNames ? '' : 'orderedType', $pb.PbFieldType.K3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchItemPreHookReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchItemPreHookReply copyWith(
          void Function(SearchItemPreHookReply) updates) =>
      super.copyWith((message) => updates(message as SearchItemPreHookReply))
          as SearchItemPreHookReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchItemPreHookReply create() => SearchItemPreHookReply._();
  @$core.override
  SearchItemPreHookReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchItemPreHookReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchItemPreHookReply>(create);
  static SearchItemPreHookReply? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get placeholderText => $_getSZ(0);
  @$pb.TagNumber(1)
  set placeholderText($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaceholderText() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaceholderText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get backgroundText => $_getSZ(1);
  @$pb.TagNumber(2)
  set backgroundText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBackgroundText() => $_has(1);
  @$pb.TagNumber(2)
  void clearBackgroundText() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.int> get orderedType => $_getList(2);
}

class SearchItemPreHookReq extends $pb.GeneratedMessage {
  factory SearchItemPreHookReq({
    $fixnum.Int64? oid,
    $fixnum.Int64? type,
  }) {
    final result = create();
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    return result;
  }

  SearchItemPreHookReq._();

  factory SearchItemPreHookReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchItemPreHookReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchItemPreHookReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'oid')
    ..aInt64(2, _omitFieldNames ? '' : 'type')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchItemPreHookReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchItemPreHookReq copyWith(void Function(SearchItemPreHookReq) updates) =>
      super.copyWith((message) => updates(message as SearchItemPreHookReq))
          as SearchItemPreHookReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchItemPreHookReq create() => SearchItemPreHookReq._();
  @$core.override
  SearchItemPreHookReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchItemPreHookReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchItemPreHookReq>(create);
  static SearchItemPreHookReq? _defaultInstance;

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
}

class SearchItemReply extends $pb.GeneratedMessage {
  factory SearchItemReply({
    SearchItemCursorReply? cursor,
    $core.Iterable<SearchItem>? items,
    SearchItemReplyExtraInfo? extra,
  }) {
    final result = create();
    if (cursor != null) result.cursor = cursor;
    if (items != null) result.items.addAll(items);
    if (extra != null) result.extra = extra;
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
    ..aOM<SearchItemReplyExtraInfo>(3, _omitFieldNames ? '' : 'extra',
        subBuilder: SearchItemReplyExtraInfo.create)
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

  @$pb.TagNumber(3)
  SearchItemReplyExtraInfo get extra => $_getN(2);
  @$pb.TagNumber(3)
  set extra(SearchItemReplyExtraInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasExtra() => $_has(2);
  @$pb.TagNumber(3)
  void clearExtra() => $_clearField(3);
  @$pb.TagNumber(3)
  SearchItemReplyExtraInfo ensureExtra() => $_ensure(2);
}

class SearchItemReplyExtraInfo extends $pb.GeneratedMessage {
  factory SearchItemReplyExtraInfo({
    $core.String? eventId,
  }) {
    final result = create();
    if (eventId != null) result.eventId = eventId;
    return result;
  }

  SearchItemReplyExtraInfo._();

  factory SearchItemReplyExtraInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchItemReplyExtraInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchItemReplyExtraInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'eventId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchItemReplyExtraInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchItemReplyExtraInfo copyWith(
          void Function(SearchItemReplyExtraInfo) updates) =>
      super.copyWith((message) => updates(message as SearchItemReplyExtraInfo))
          as SearchItemReplyExtraInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchItemReplyExtraInfo create() => SearchItemReplyExtraInfo._();
  @$core.override
  SearchItemReplyExtraInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchItemReplyExtraInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchItemReplyExtraInfo>(create);
  static SearchItemReplyExtraInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get eventId => $_getSZ(0);
  @$pb.TagNumber(1)
  set eventId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEventId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEventId() => $_clearField(1);
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

class ShareRepliesInfoReq extends $pb.GeneratedMessage {
  factory ShareRepliesInfoReq({
    $core.Iterable<$fixnum.Int64>? rpids,
    $fixnum.Int64? oid,
    $fixnum.Int64? type,
  }) {
    final result = create();
    if (rpids != null) result.rpids.addAll(rpids);
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    return result;
  }

  ShareRepliesInfoReq._();

  factory ShareRepliesInfoReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShareRepliesInfoReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShareRepliesInfoReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..p<$fixnum.Int64>(1, _omitFieldNames ? '' : 'rpids', $pb.PbFieldType.K6)
    ..aInt64(2, _omitFieldNames ? '' : 'oid')
    ..aInt64(3, _omitFieldNames ? '' : 'type')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareRepliesInfoReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareRepliesInfoReq copyWith(void Function(ShareRepliesInfoReq) updates) =>
      super.copyWith((message) => updates(message as ShareRepliesInfoReq))
          as ShareRepliesInfoReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShareRepliesInfoReq create() => ShareRepliesInfoReq._();
  @$core.override
  ShareRepliesInfoReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ShareRepliesInfoReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShareRepliesInfoReq>(create);
  static ShareRepliesInfoReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$fixnum.Int64> get rpids => $_getList(0);

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
}

class ShareRepliesInfoResp_ShareExtra extends $pb.GeneratedMessage {
  factory ShareRepliesInfoResp_ShareExtra({
    $core.bool? isPgc,
  }) {
    final result = create();
    if (isPgc != null) result.isPgc = isPgc;
    return result;
  }

  ShareRepliesInfoResp_ShareExtra._();

  factory ShareRepliesInfoResp_ShareExtra.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShareRepliesInfoResp_ShareExtra.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShareRepliesInfoResp.ShareExtra',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'isPgc')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareRepliesInfoResp_ShareExtra clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareRepliesInfoResp_ShareExtra copyWith(
          void Function(ShareRepliesInfoResp_ShareExtra) updates) =>
      super.copyWith(
              (message) => updates(message as ShareRepliesInfoResp_ShareExtra))
          as ShareRepliesInfoResp_ShareExtra;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShareRepliesInfoResp_ShareExtra create() =>
      ShareRepliesInfoResp_ShareExtra._();
  @$core.override
  ShareRepliesInfoResp_ShareExtra createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ShareRepliesInfoResp_ShareExtra getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShareRepliesInfoResp_ShareExtra>(
          create);
  static ShareRepliesInfoResp_ShareExtra? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isPgc => $_getBF(0);
  @$pb.TagNumber(1)
  set isPgc($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsPgc() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsPgc() => $_clearField(1);
}

class ShareRepliesInfoResp extends $pb.GeneratedMessage {
  factory ShareRepliesInfoResp({
    $core.Iterable<ShareReplyInfo>? infos,
    $core.String? fromTitle,
    $core.String? fromUp,
    $core.String? fromPic,
    $core.String? url,
    $core.String? sloganPic,
    $core.String? sloganText,
    ShareReplyTopic? topic,
    ShareRepliesInfoResp_ShareExtra? extra,
  }) {
    final result = create();
    if (infos != null) result.infos.addAll(infos);
    if (fromTitle != null) result.fromTitle = fromTitle;
    if (fromUp != null) result.fromUp = fromUp;
    if (fromPic != null) result.fromPic = fromPic;
    if (url != null) result.url = url;
    if (sloganPic != null) result.sloganPic = sloganPic;
    if (sloganText != null) result.sloganText = sloganText;
    if (topic != null) result.topic = topic;
    if (extra != null) result.extra = extra;
    return result;
  }

  ShareRepliesInfoResp._();

  factory ShareRepliesInfoResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShareRepliesInfoResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShareRepliesInfoResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..pPM<ShareReplyInfo>(1, _omitFieldNames ? '' : 'infos',
        subBuilder: ShareReplyInfo.create)
    ..aOS(2, _omitFieldNames ? '' : 'fromTitle')
    ..aOS(3, _omitFieldNames ? '' : 'fromUp')
    ..aOS(4, _omitFieldNames ? '' : 'fromPic')
    ..aOS(5, _omitFieldNames ? '' : 'url')
    ..aOS(6, _omitFieldNames ? '' : 'sloganPic')
    ..aOS(7, _omitFieldNames ? '' : 'sloganText')
    ..aOM<ShareReplyTopic>(8, _omitFieldNames ? '' : 'topic',
        subBuilder: ShareReplyTopic.create)
    ..aOM<ShareRepliesInfoResp_ShareExtra>(9, _omitFieldNames ? '' : 'extra',
        subBuilder: ShareRepliesInfoResp_ShareExtra.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareRepliesInfoResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareRepliesInfoResp copyWith(void Function(ShareRepliesInfoResp) updates) =>
      super.copyWith((message) => updates(message as ShareRepliesInfoResp))
          as ShareRepliesInfoResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShareRepliesInfoResp create() => ShareRepliesInfoResp._();
  @$core.override
  ShareRepliesInfoResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ShareRepliesInfoResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShareRepliesInfoResp>(create);
  static ShareRepliesInfoResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ShareReplyInfo> get infos => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get fromTitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set fromTitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFromTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get fromUp => $_getSZ(2);
  @$pb.TagNumber(3)
  set fromUp($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFromUp() => $_has(2);
  @$pb.TagNumber(3)
  void clearFromUp() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get fromPic => $_getSZ(3);
  @$pb.TagNumber(4)
  set fromPic($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFromPic() => $_has(3);
  @$pb.TagNumber(4)
  void clearFromPic() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get url => $_getSZ(4);
  @$pb.TagNumber(5)
  set url($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get sloganPic => $_getSZ(5);
  @$pb.TagNumber(6)
  set sloganPic($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSloganPic() => $_has(5);
  @$pb.TagNumber(6)
  void clearSloganPic() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get sloganText => $_getSZ(6);
  @$pb.TagNumber(7)
  set sloganText($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSloganText() => $_has(6);
  @$pb.TagNumber(7)
  void clearSloganText() => $_clearField(7);

  @$pb.TagNumber(8)
  ShareReplyTopic get topic => $_getN(7);
  @$pb.TagNumber(8)
  set topic(ShareReplyTopic value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasTopic() => $_has(7);
  @$pb.TagNumber(8)
  void clearTopic() => $_clearField(8);
  @$pb.TagNumber(8)
  ShareReplyTopic ensureTopic() => $_ensure(7);

  @$pb.TagNumber(9)
  ShareRepliesInfoResp_ShareExtra get extra => $_getN(8);
  @$pb.TagNumber(9)
  set extra(ShareRepliesInfoResp_ShareExtra value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasExtra() => $_has(8);
  @$pb.TagNumber(9)
  void clearExtra() => $_clearField(9);
  @$pb.TagNumber(9)
  ShareRepliesInfoResp_ShareExtra ensureExtra() => $_ensure(8);
}

class ShareReplyInfo extends $pb.GeneratedMessage {
  factory ShareReplyInfo({
    Member? member,
    Content? content,
    $core.String? title,
    $core.String? subTitle,
    $core.String? achievementText,
    $core.String? labelUrl,
  }) {
    final result = create();
    if (member != null) result.member = member;
    if (content != null) result.content = content;
    if (title != null) result.title = title;
    if (subTitle != null) result.subTitle = subTitle;
    if (achievementText != null) result.achievementText = achievementText;
    if (labelUrl != null) result.labelUrl = labelUrl;
    return result;
  }

  ShareReplyInfo._();

  factory ShareReplyInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShareReplyInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShareReplyInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOM<Member>(1, _omitFieldNames ? '' : 'member', subBuilder: Member.create)
    ..aOM<Content>(2, _omitFieldNames ? '' : 'content',
        subBuilder: Content.create)
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'subTitle')
    ..aOS(5, _omitFieldNames ? '' : 'achievementText')
    ..aOS(6, _omitFieldNames ? '' : 'labelUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareReplyInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareReplyInfo copyWith(void Function(ShareReplyInfo) updates) =>
      super.copyWith((message) => updates(message as ShareReplyInfo))
          as ShareReplyInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShareReplyInfo create() => ShareReplyInfo._();
  @$core.override
  ShareReplyInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ShareReplyInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShareReplyInfo>(create);
  static ShareReplyInfo? _defaultInstance;

  @$pb.TagNumber(1)
  Member get member => $_getN(0);
  @$pb.TagNumber(1)
  set member(Member value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMember() => $_has(0);
  @$pb.TagNumber(1)
  void clearMember() => $_clearField(1);
  @$pb.TagNumber(1)
  Member ensureMember() => $_ensure(0);

  @$pb.TagNumber(2)
  Content get content => $_getN(1);
  @$pb.TagNumber(2)
  set content(Content value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => $_clearField(2);
  @$pb.TagNumber(2)
  Content ensureContent() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get subTitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set subTitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get achievementText => $_getSZ(4);
  @$pb.TagNumber(5)
  set achievementText($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAchievementText() => $_has(4);
  @$pb.TagNumber(5)
  void clearAchievementText() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get labelUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set labelUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLabelUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearLabelUrl() => $_clearField(6);
}

class ShareReplyMaterialReq extends $pb.GeneratedMessage {
  factory ShareReplyMaterialReq({
    $fixnum.Int64? oid,
    $fixnum.Int64? type,
    $fixnum.Int64? rpid,
  }) {
    final result = create();
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    if (rpid != null) result.rpid = rpid;
    return result;
  }

  ShareReplyMaterialReq._();

  factory ShareReplyMaterialReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShareReplyMaterialReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShareReplyMaterialReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'oid')
    ..aInt64(2, _omitFieldNames ? '' : 'type')
    ..aInt64(3, _omitFieldNames ? '' : 'rpid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareReplyMaterialReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareReplyMaterialReq copyWith(
          void Function(ShareReplyMaterialReq) updates) =>
      super.copyWith((message) => updates(message as ShareReplyMaterialReq))
          as ShareReplyMaterialReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShareReplyMaterialReq create() => ShareReplyMaterialReq._();
  @$core.override
  ShareReplyMaterialReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ShareReplyMaterialReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShareReplyMaterialReq>(create);
  static ShareReplyMaterialReq? _defaultInstance;

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
  $fixnum.Int64 get rpid => $_getI64(2);
  @$pb.TagNumber(3)
  set rpid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRpid() => $_has(2);
  @$pb.TagNumber(3)
  void clearRpid() => $_clearField(3);
}

class ShareReplyMaterialResp_ArchiveMaterial extends $pb.GeneratedMessage {
  factory ShareReplyMaterialResp_ArchiveMaterial({
    $core.String? title,
    $core.String? cover,
    $core.String? upName,
    $core.String? upIcon,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (cover != null) result.cover = cover;
    if (upName != null) result.upName = upName;
    if (upIcon != null) result.upIcon = upIcon;
    return result;
  }

  ShareReplyMaterialResp_ArchiveMaterial._();

  factory ShareReplyMaterialResp_ArchiveMaterial.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShareReplyMaterialResp_ArchiveMaterial.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShareReplyMaterialResp.ArchiveMaterial',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'cover')
    ..aOS(3, _omitFieldNames ? '' : 'upName')
    ..aOS(4, _omitFieldNames ? '' : 'upIcon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareReplyMaterialResp_ArchiveMaterial clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareReplyMaterialResp_ArchiveMaterial copyWith(
          void Function(ShareReplyMaterialResp_ArchiveMaterial) updates) =>
      super.copyWith((message) =>
              updates(message as ShareReplyMaterialResp_ArchiveMaterial))
          as ShareReplyMaterialResp_ArchiveMaterial;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShareReplyMaterialResp_ArchiveMaterial create() =>
      ShareReplyMaterialResp_ArchiveMaterial._();
  @$core.override
  ShareReplyMaterialResp_ArchiveMaterial createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ShareReplyMaterialResp_ArchiveMaterial getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          ShareReplyMaterialResp_ArchiveMaterial>(create);
  static ShareReplyMaterialResp_ArchiveMaterial? _defaultInstance;

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
  $core.String get upName => $_getSZ(2);
  @$pb.TagNumber(3)
  set upName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUpName() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get upIcon => $_getSZ(3);
  @$pb.TagNumber(4)
  set upIcon($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUpIcon() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpIcon() => $_clearField(4);
}

class ShareReplyMaterialResp_ArticleMaterial extends $pb.GeneratedMessage {
  factory ShareReplyMaterialResp_ArticleMaterial({
    $core.String? title,
    $core.String? message,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (message != null) result.message = message;
    return result;
  }

  ShareReplyMaterialResp_ArticleMaterial._();

  factory ShareReplyMaterialResp_ArticleMaterial.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShareReplyMaterialResp_ArticleMaterial.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShareReplyMaterialResp.ArticleMaterial',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareReplyMaterialResp_ArticleMaterial clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareReplyMaterialResp_ArticleMaterial copyWith(
          void Function(ShareReplyMaterialResp_ArticleMaterial) updates) =>
      super.copyWith((message) =>
              updates(message as ShareReplyMaterialResp_ArticleMaterial))
          as ShareReplyMaterialResp_ArticleMaterial;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShareReplyMaterialResp_ArticleMaterial create() =>
      ShareReplyMaterialResp_ArticleMaterial._();
  @$core.override
  ShareReplyMaterialResp_ArticleMaterial createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ShareReplyMaterialResp_ArticleMaterial getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          ShareReplyMaterialResp_ArticleMaterial>(create);
  static ShareReplyMaterialResp_ArticleMaterial? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class ShareReplyMaterialResp_DynamicMaterial extends $pb.GeneratedMessage {
  factory ShareReplyMaterialResp_DynamicMaterial({
    $core.String? title,
    $core.String? message,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (message != null) result.message = message;
    return result;
  }

  ShareReplyMaterialResp_DynamicMaterial._();

  factory ShareReplyMaterialResp_DynamicMaterial.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShareReplyMaterialResp_DynamicMaterial.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShareReplyMaterialResp.DynamicMaterial',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareReplyMaterialResp_DynamicMaterial clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareReplyMaterialResp_DynamicMaterial copyWith(
          void Function(ShareReplyMaterialResp_DynamicMaterial) updates) =>
      super.copyWith((message) =>
              updates(message as ShareReplyMaterialResp_DynamicMaterial))
          as ShareReplyMaterialResp_DynamicMaterial;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShareReplyMaterialResp_DynamicMaterial create() =>
      ShareReplyMaterialResp_DynamicMaterial._();
  @$core.override
  ShareReplyMaterialResp_DynamicMaterial createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ShareReplyMaterialResp_DynamicMaterial getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          ShareReplyMaterialResp_DynamicMaterial>(create);
  static ShareReplyMaterialResp_DynamicMaterial? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class ShareReplyMaterialResp_ExtraData extends $pb.GeneratedMessage {
  factory ShareReplyMaterialResp_ExtraData({
    $core.bool? isPgc,
    $core.String? originText,
    $fixnum.Int64? topicId,
  }) {
    final result = create();
    if (isPgc != null) result.isPgc = isPgc;
    if (originText != null) result.originText = originText;
    if (topicId != null) result.topicId = topicId;
    return result;
  }

  ShareReplyMaterialResp_ExtraData._();

  factory ShareReplyMaterialResp_ExtraData.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShareReplyMaterialResp_ExtraData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShareReplyMaterialResp.ExtraData',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'isPgc')
    ..aOS(2, _omitFieldNames ? '' : 'originText')
    ..aInt64(3, _omitFieldNames ? '' : 'topicId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareReplyMaterialResp_ExtraData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareReplyMaterialResp_ExtraData copyWith(
          void Function(ShareReplyMaterialResp_ExtraData) updates) =>
      super.copyWith(
              (message) => updates(message as ShareReplyMaterialResp_ExtraData))
          as ShareReplyMaterialResp_ExtraData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShareReplyMaterialResp_ExtraData create() =>
      ShareReplyMaterialResp_ExtraData._();
  @$core.override
  ShareReplyMaterialResp_ExtraData createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ShareReplyMaterialResp_ExtraData getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShareReplyMaterialResp_ExtraData>(
          create);
  static ShareReplyMaterialResp_ExtraData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isPgc => $_getBF(0);
  @$pb.TagNumber(1)
  set isPgc($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsPgc() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsPgc() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get originText => $_getSZ(1);
  @$pb.TagNumber(2)
  set originText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOriginText() => $_has(1);
  @$pb.TagNumber(2)
  void clearOriginText() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get topicId => $_getI64(2);
  @$pb.TagNumber(3)
  set topicId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTopicId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTopicId() => $_clearField(3);
}

enum ShareReplyMaterialResp_SubjectMaterial_Item {
  archiveMaterial,
  dynamicMaterial,
  articleMaterial,
  notSet
}

class ShareReplyMaterialResp_SubjectMaterial extends $pb.GeneratedMessage {
  factory ShareReplyMaterialResp_SubjectMaterial({
    ShareReplyMaterialResp_ArchiveMaterial? archiveMaterial,
    ShareReplyMaterialResp_DynamicMaterial? dynamicMaterial,
    ShareReplyMaterialResp_ArticleMaterial? articleMaterial,
  }) {
    final result = create();
    if (archiveMaterial != null) result.archiveMaterial = archiveMaterial;
    if (dynamicMaterial != null) result.dynamicMaterial = dynamicMaterial;
    if (articleMaterial != null) result.articleMaterial = articleMaterial;
    return result;
  }

  ShareReplyMaterialResp_SubjectMaterial._();

  factory ShareReplyMaterialResp_SubjectMaterial.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShareReplyMaterialResp_SubjectMaterial.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ShareReplyMaterialResp_SubjectMaterial_Item>
      _ShareReplyMaterialResp_SubjectMaterial_ItemByTag = {
    1: ShareReplyMaterialResp_SubjectMaterial_Item.archiveMaterial,
    2: ShareReplyMaterialResp_SubjectMaterial_Item.dynamicMaterial,
    3: ShareReplyMaterialResp_SubjectMaterial_Item.articleMaterial,
    0: ShareReplyMaterialResp_SubjectMaterial_Item.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShareReplyMaterialResp.SubjectMaterial',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<ShareReplyMaterialResp_ArchiveMaterial>(
        1, _omitFieldNames ? '' : 'archiveMaterial',
        subBuilder: ShareReplyMaterialResp_ArchiveMaterial.create)
    ..aOM<ShareReplyMaterialResp_DynamicMaterial>(
        2, _omitFieldNames ? '' : 'dynamicMaterial',
        subBuilder: ShareReplyMaterialResp_DynamicMaterial.create)
    ..aOM<ShareReplyMaterialResp_ArticleMaterial>(
        3, _omitFieldNames ? '' : 'articleMaterial',
        subBuilder: ShareReplyMaterialResp_ArticleMaterial.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareReplyMaterialResp_SubjectMaterial clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareReplyMaterialResp_SubjectMaterial copyWith(
          void Function(ShareReplyMaterialResp_SubjectMaterial) updates) =>
      super.copyWith((message) =>
              updates(message as ShareReplyMaterialResp_SubjectMaterial))
          as ShareReplyMaterialResp_SubjectMaterial;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShareReplyMaterialResp_SubjectMaterial create() =>
      ShareReplyMaterialResp_SubjectMaterial._();
  @$core.override
  ShareReplyMaterialResp_SubjectMaterial createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ShareReplyMaterialResp_SubjectMaterial getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          ShareReplyMaterialResp_SubjectMaterial>(create);
  static ShareReplyMaterialResp_SubjectMaterial? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  ShareReplyMaterialResp_SubjectMaterial_Item whichItem() =>
      _ShareReplyMaterialResp_SubjectMaterial_ItemByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearItem() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ShareReplyMaterialResp_ArchiveMaterial get archiveMaterial => $_getN(0);
  @$pb.TagNumber(1)
  set archiveMaterial(ShareReplyMaterialResp_ArchiveMaterial value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArchiveMaterial() => $_has(0);
  @$pb.TagNumber(1)
  void clearArchiveMaterial() => $_clearField(1);
  @$pb.TagNumber(1)
  ShareReplyMaterialResp_ArchiveMaterial ensureArchiveMaterial() => $_ensure(0);

  @$pb.TagNumber(2)
  ShareReplyMaterialResp_DynamicMaterial get dynamicMaterial => $_getN(1);
  @$pb.TagNumber(2)
  set dynamicMaterial(ShareReplyMaterialResp_DynamicMaterial value) =>
      $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDynamicMaterial() => $_has(1);
  @$pb.TagNumber(2)
  void clearDynamicMaterial() => $_clearField(2);
  @$pb.TagNumber(2)
  ShareReplyMaterialResp_DynamicMaterial ensureDynamicMaterial() => $_ensure(1);

  @$pb.TagNumber(3)
  ShareReplyMaterialResp_ArticleMaterial get articleMaterial => $_getN(2);
  @$pb.TagNumber(3)
  set articleMaterial(ShareReplyMaterialResp_ArticleMaterial value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasArticleMaterial() => $_has(2);
  @$pb.TagNumber(3)
  void clearArticleMaterial() => $_clearField(3);
  @$pb.TagNumber(3)
  ShareReplyMaterialResp_ArticleMaterial ensureArticleMaterial() => $_ensure(2);
}

class ShareReplyMaterialResp extends $pb.GeneratedMessage {
  factory ShareReplyMaterialResp({
    ShareReplyMaterialResp_SubjectMaterial? subjectMaterial,
    $core.String? qrcodeUrl,
    $core.String? savePicText,
    $core.String? openAppText,
    $core.String? shareTimeText,
    $core.String? biliLogoIcon,
    ShareReplyMaterialResp_ExtraData? extra,
  }) {
    final result = create();
    if (subjectMaterial != null) result.subjectMaterial = subjectMaterial;
    if (qrcodeUrl != null) result.qrcodeUrl = qrcodeUrl;
    if (savePicText != null) result.savePicText = savePicText;
    if (openAppText != null) result.openAppText = openAppText;
    if (shareTimeText != null) result.shareTimeText = shareTimeText;
    if (biliLogoIcon != null) result.biliLogoIcon = biliLogoIcon;
    if (extra != null) result.extra = extra;
    return result;
  }

  ShareReplyMaterialResp._();

  factory ShareReplyMaterialResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShareReplyMaterialResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShareReplyMaterialResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOM<ShareReplyMaterialResp_SubjectMaterial>(
        1, _omitFieldNames ? '' : 'subjectMaterial',
        subBuilder: ShareReplyMaterialResp_SubjectMaterial.create)
    ..aOS(2, _omitFieldNames ? '' : 'qrcodeUrl')
    ..aOS(3, _omitFieldNames ? '' : 'savePicText')
    ..aOS(4, _omitFieldNames ? '' : 'openAppText')
    ..aOS(5, _omitFieldNames ? '' : 'shareTimeText')
    ..aOS(6, _omitFieldNames ? '' : 'biliLogoIcon')
    ..aOM<ShareReplyMaterialResp_ExtraData>(7, _omitFieldNames ? '' : 'extra',
        subBuilder: ShareReplyMaterialResp_ExtraData.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareReplyMaterialResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareReplyMaterialResp copyWith(
          void Function(ShareReplyMaterialResp) updates) =>
      super.copyWith((message) => updates(message as ShareReplyMaterialResp))
          as ShareReplyMaterialResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShareReplyMaterialResp create() => ShareReplyMaterialResp._();
  @$core.override
  ShareReplyMaterialResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ShareReplyMaterialResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShareReplyMaterialResp>(create);
  static ShareReplyMaterialResp? _defaultInstance;

  @$pb.TagNumber(1)
  ShareReplyMaterialResp_SubjectMaterial get subjectMaterial => $_getN(0);
  @$pb.TagNumber(1)
  set subjectMaterial(ShareReplyMaterialResp_SubjectMaterial value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSubjectMaterial() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubjectMaterial() => $_clearField(1);
  @$pb.TagNumber(1)
  ShareReplyMaterialResp_SubjectMaterial ensureSubjectMaterial() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get qrcodeUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set qrcodeUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQrcodeUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearQrcodeUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get savePicText => $_getSZ(2);
  @$pb.TagNumber(3)
  set savePicText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSavePicText() => $_has(2);
  @$pb.TagNumber(3)
  void clearSavePicText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get openAppText => $_getSZ(3);
  @$pb.TagNumber(4)
  set openAppText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOpenAppText() => $_has(3);
  @$pb.TagNumber(4)
  void clearOpenAppText() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get shareTimeText => $_getSZ(4);
  @$pb.TagNumber(5)
  set shareTimeText($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasShareTimeText() => $_has(4);
  @$pb.TagNumber(5)
  void clearShareTimeText() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get biliLogoIcon => $_getSZ(5);
  @$pb.TagNumber(6)
  set biliLogoIcon($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBiliLogoIcon() => $_has(5);
  @$pb.TagNumber(6)
  void clearBiliLogoIcon() => $_clearField(6);

  @$pb.TagNumber(7)
  ShareReplyMaterialResp_ExtraData get extra => $_getN(6);
  @$pb.TagNumber(7)
  set extra(ShareReplyMaterialResp_ExtraData value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasExtra() => $_has(6);
  @$pb.TagNumber(7)
  void clearExtra() => $_clearField(7);
  @$pb.TagNumber(7)
  ShareReplyMaterialResp_ExtraData ensureExtra() => $_ensure(6);
}

class ShareReplyTopic extends $pb.GeneratedMessage {
  factory ShareReplyTopic({
    Topic? topic,
    $core.String? originText,
  }) {
    final result = create();
    if (topic != null) result.topic = topic;
    if (originText != null) result.originText = originText;
    return result;
  }

  ShareReplyTopic._();

  factory ShareReplyTopic.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ShareReplyTopic.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ShareReplyTopic',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOM<Topic>(1, _omitFieldNames ? '' : 'topic', subBuilder: Topic.create)
    ..aOS(2, _omitFieldNames ? '' : 'originText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareReplyTopic clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ShareReplyTopic copyWith(void Function(ShareReplyTopic) updates) =>
      super.copyWith((message) => updates(message as ShareReplyTopic))
          as ShareReplyTopic;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShareReplyTopic create() => ShareReplyTopic._();
  @$core.override
  ShareReplyTopic createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ShareReplyTopic getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ShareReplyTopic>(create);
  static ShareReplyTopic? _defaultInstance;

  @$pb.TagNumber(1)
  Topic get topic => $_getN(0);
  @$pb.TagNumber(1)
  set topic(Topic value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTopic() => $_has(0);
  @$pb.TagNumber(1)
  void clearTopic() => $_clearField(1);
  @$pb.TagNumber(1)
  Topic ensureTopic() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get originText => $_getSZ(1);
  @$pb.TagNumber(2)
  set originText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOriginText() => $_has(1);
  @$pb.TagNumber(2)
  void clearOriginText() => $_clearField(2);
}

class SubjectControl_CmTopReplyProtection extends $pb.GeneratedMessage {
  factory SubjectControl_CmTopReplyProtection({
    $fixnum.Int64? protectedTopRpid,
    $core.String? popupMessage,
    $core.String? appealUrl,
  }) {
    final result = create();
    if (protectedTopRpid != null) result.protectedTopRpid = protectedTopRpid;
    if (popupMessage != null) result.popupMessage = popupMessage;
    if (appealUrl != null) result.appealUrl = appealUrl;
    return result;
  }

  SubjectControl_CmTopReplyProtection._();

  factory SubjectControl_CmTopReplyProtection.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubjectControl_CmTopReplyProtection.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubjectControl.CmTopReplyProtection',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'protectedTopRpid')
    ..aOS(2, _omitFieldNames ? '' : 'popupMessage')
    ..aOS(3, _omitFieldNames ? '' : 'appealUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubjectControl_CmTopReplyProtection clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubjectControl_CmTopReplyProtection copyWith(
          void Function(SubjectControl_CmTopReplyProtection) updates) =>
      super.copyWith((message) =>
              updates(message as SubjectControl_CmTopReplyProtection))
          as SubjectControl_CmTopReplyProtection;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubjectControl_CmTopReplyProtection create() =>
      SubjectControl_CmTopReplyProtection._();
  @$core.override
  SubjectControl_CmTopReplyProtection createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubjectControl_CmTopReplyProtection getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          SubjectControl_CmTopReplyProtection>(create);
  static SubjectControl_CmTopReplyProtection? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get protectedTopRpid => $_getI64(0);
  @$pb.TagNumber(1)
  set protectedTopRpid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProtectedTopRpid() => $_has(0);
  @$pb.TagNumber(1)
  void clearProtectedTopRpid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get popupMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set popupMessage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPopupMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearPopupMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get appealUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set appealUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAppealUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearAppealUrl() => $_clearField(3);
}

class SubjectControl_FilterTag extends $pb.GeneratedMessage {
  factory SubjectControl_FilterTag({
    $core.String? name,
    $core.String? eventId,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (eventId != null) result.eventId = eventId;
    return result;
  }

  SubjectControl_FilterTag._();

  factory SubjectControl_FilterTag.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubjectControl_FilterTag.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubjectControl.FilterTag',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'eventId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubjectControl_FilterTag clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubjectControl_FilterTag copyWith(
          void Function(SubjectControl_FilterTag) updates) =>
      super.copyWith((message) => updates(message as SubjectControl_FilterTag))
          as SubjectControl_FilterTag;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubjectControl_FilterTag create() => SubjectControl_FilterTag._();
  @$core.override
  SubjectControl_FilterTag createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubjectControl_FilterTag getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubjectControl_FilterTag>(create);
  static SubjectControl_FilterTag? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get eventId => $_getSZ(1);
  @$pb.TagNumber(2)
  set eventId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEventId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEventId() => $_clearField(2);
}

class SubjectControl extends $pb.GeneratedMessage {
  factory SubjectControl({
    $fixnum.Int64? upMid,
    $core.bool? isAssist,
    $core.bool? readOnly,
    $core.bool? hasVoteAccess,
    $core.bool? hasLotteryAccess,
    $core.bool? hasFoldedReply,
    $core.String? bgText,
    $core.bool? upBlocked,
    $core.bool? hasActivityAccess,
    $core.bool? showTitle,
    $core.bool? showUpAction,
    $fixnum.Int64? switcherType,
    $core.bool? inputDisable,
    $core.String? rootText,
    $core.String? childText,
    $fixnum.Int64? count,
    $core.String? title,
    $core.String? giveupText,
    $core.bool? hasNoteAccess,
    $core.bool? disableJumpEmote,
    $core.String? emptyBackgroundTextPlain,
    $core.String? emptyBackgroundTextHighlight,
    $core.String? emptyBackgroundUri,
    $core.Iterable<SubjectControl_FilterTag>? supportFilterTags,
    EditorIconState? screenshotIconState,
    EditorIconState? uploadPictureIconState,
    EmptyPage? emptyPage,
    SubjectControl_CmTopReplyProtection? cmTopReplyProtection,
    $core.bool? enableCharged,
  }) {
    final result = create();
    if (upMid != null) result.upMid = upMid;
    if (isAssist != null) result.isAssist = isAssist;
    if (readOnly != null) result.readOnly = readOnly;
    if (hasVoteAccess != null) result.hasVoteAccess = hasVoteAccess;
    if (hasLotteryAccess != null) result.hasLotteryAccess = hasLotteryAccess;
    if (hasFoldedReply != null) result.hasFoldedReply = hasFoldedReply;
    if (bgText != null) result.bgText = bgText;
    if (upBlocked != null) result.upBlocked = upBlocked;
    if (hasActivityAccess != null) result.hasActivityAccess = hasActivityAccess;
    if (showTitle != null) result.showTitle = showTitle;
    if (showUpAction != null) result.showUpAction = showUpAction;
    if (switcherType != null) result.switcherType = switcherType;
    if (inputDisable != null) result.inputDisable = inputDisable;
    if (rootText != null) result.rootText = rootText;
    if (childText != null) result.childText = childText;
    if (count != null) result.count = count;
    if (title != null) result.title = title;
    if (giveupText != null) result.giveupText = giveupText;
    if (hasNoteAccess != null) result.hasNoteAccess = hasNoteAccess;
    if (disableJumpEmote != null) result.disableJumpEmote = disableJumpEmote;
    if (emptyBackgroundTextPlain != null)
      result.emptyBackgroundTextPlain = emptyBackgroundTextPlain;
    if (emptyBackgroundTextHighlight != null)
      result.emptyBackgroundTextHighlight = emptyBackgroundTextHighlight;
    if (emptyBackgroundUri != null)
      result.emptyBackgroundUri = emptyBackgroundUri;
    if (supportFilterTags != null)
      result.supportFilterTags.addAll(supportFilterTags);
    if (screenshotIconState != null)
      result.screenshotIconState = screenshotIconState;
    if (uploadPictureIconState != null)
      result.uploadPictureIconState = uploadPictureIconState;
    if (emptyPage != null) result.emptyPage = emptyPage;
    if (cmTopReplyProtection != null)
      result.cmTopReplyProtection = cmTopReplyProtection;
    if (enableCharged != null) result.enableCharged = enableCharged;
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
    ..aOB(2, _omitFieldNames ? '' : 'isAssist')
    ..aOB(3, _omitFieldNames ? '' : 'readOnly')
    ..aOB(4, _omitFieldNames ? '' : 'hasVoteAccess')
    ..aOB(5, _omitFieldNames ? '' : 'hasLotteryAccess')
    ..aOB(6, _omitFieldNames ? '' : 'hasFoldedReply')
    ..aOS(7, _omitFieldNames ? '' : 'bgText')
    ..aOB(8, _omitFieldNames ? '' : 'upBlocked')
    ..aOB(9, _omitFieldNames ? '' : 'hasActivityAccess')
    ..aOB(10, _omitFieldNames ? '' : 'showTitle')
    ..aOB(11, _omitFieldNames ? '' : 'showUpAction')
    ..aInt64(12, _omitFieldNames ? '' : 'switcherType')
    ..aOB(13, _omitFieldNames ? '' : 'inputDisable')
    ..aOS(14, _omitFieldNames ? '' : 'rootText')
    ..aOS(15, _omitFieldNames ? '' : 'childText')
    ..aInt64(16, _omitFieldNames ? '' : 'count')
    ..aOS(17, _omitFieldNames ? '' : 'title')
    ..aOS(18, _omitFieldNames ? '' : 'giveupText')
    ..aOB(19, _omitFieldNames ? '' : 'hasNoteAccess')
    ..aOB(20, _omitFieldNames ? '' : 'disableJumpEmote')
    ..aOS(21, _omitFieldNames ? '' : 'emptyBackgroundTextPlain')
    ..aOS(22, _omitFieldNames ? '' : 'emptyBackgroundTextHighlight')
    ..aOS(23, _omitFieldNames ? '' : 'emptyBackgroundUri')
    ..pPM<SubjectControl_FilterTag>(
        24, _omitFieldNames ? '' : 'supportFilterTags',
        subBuilder: SubjectControl_FilterTag.create)
    ..aE<EditorIconState>(25, _omitFieldNames ? '' : 'screenshotIconState',
        enumValues: EditorIconState.values)
    ..aE<EditorIconState>(26, _omitFieldNames ? '' : 'uploadPictureIconState',
        enumValues: EditorIconState.values)
    ..aOM<EmptyPage>(27, _omitFieldNames ? '' : 'emptyPage',
        subBuilder: EmptyPage.create)
    ..aOM<SubjectControl_CmTopReplyProtection>(
        28, _omitFieldNames ? '' : 'cmTopReplyProtection',
        subBuilder: SubjectControl_CmTopReplyProtection.create)
    ..aOB(29, _omitFieldNames ? '' : 'enableCharged')
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

  @$pb.TagNumber(2)
  $core.bool get isAssist => $_getBF(1);
  @$pb.TagNumber(2)
  set isAssist($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsAssist() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsAssist() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get readOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set readOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReadOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearReadOnly() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get hasVoteAccess => $_getBF(3);
  @$pb.TagNumber(4)
  set hasVoteAccess($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHasVoteAccess() => $_has(3);
  @$pb.TagNumber(4)
  void clearHasVoteAccess() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get hasLotteryAccess => $_getBF(4);
  @$pb.TagNumber(5)
  set hasLotteryAccess($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHasLotteryAccess() => $_has(4);
  @$pb.TagNumber(5)
  void clearHasLotteryAccess() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get hasFoldedReply => $_getBF(5);
  @$pb.TagNumber(6)
  set hasFoldedReply($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHasFoldedReply() => $_has(5);
  @$pb.TagNumber(6)
  void clearHasFoldedReply() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get bgText => $_getSZ(6);
  @$pb.TagNumber(7)
  set bgText($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBgText() => $_has(6);
  @$pb.TagNumber(7)
  void clearBgText() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get upBlocked => $_getBF(7);
  @$pb.TagNumber(8)
  set upBlocked($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUpBlocked() => $_has(7);
  @$pb.TagNumber(8)
  void clearUpBlocked() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get hasActivityAccess => $_getBF(8);
  @$pb.TagNumber(9)
  set hasActivityAccess($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasHasActivityAccess() => $_has(8);
  @$pb.TagNumber(9)
  void clearHasActivityAccess() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get showTitle => $_getBF(9);
  @$pb.TagNumber(10)
  set showTitle($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasShowTitle() => $_has(9);
  @$pb.TagNumber(10)
  void clearShowTitle() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get showUpAction => $_getBF(10);
  @$pb.TagNumber(11)
  set showUpAction($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasShowUpAction() => $_has(10);
  @$pb.TagNumber(11)
  void clearShowUpAction() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get switcherType => $_getI64(11);
  @$pb.TagNumber(12)
  set switcherType($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSwitcherType() => $_has(11);
  @$pb.TagNumber(12)
  void clearSwitcherType() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get inputDisable => $_getBF(12);
  @$pb.TagNumber(13)
  set inputDisable($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasInputDisable() => $_has(12);
  @$pb.TagNumber(13)
  void clearInputDisable() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get rootText => $_getSZ(13);
  @$pb.TagNumber(14)
  set rootText($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasRootText() => $_has(13);
  @$pb.TagNumber(14)
  void clearRootText() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get childText => $_getSZ(14);
  @$pb.TagNumber(15)
  set childText($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasChildText() => $_has(14);
  @$pb.TagNumber(15)
  void clearChildText() => $_clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get count => $_getI64(15);
  @$pb.TagNumber(16)
  set count($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasCount() => $_has(15);
  @$pb.TagNumber(16)
  void clearCount() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get title => $_getSZ(16);
  @$pb.TagNumber(17)
  set title($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasTitle() => $_has(16);
  @$pb.TagNumber(17)
  void clearTitle() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get giveupText => $_getSZ(17);
  @$pb.TagNumber(18)
  set giveupText($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasGiveupText() => $_has(17);
  @$pb.TagNumber(18)
  void clearGiveupText() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.bool get hasNoteAccess => $_getBF(18);
  @$pb.TagNumber(19)
  set hasNoteAccess($core.bool value) => $_setBool(18, value);
  @$pb.TagNumber(19)
  $core.bool hasHasNoteAccess() => $_has(18);
  @$pb.TagNumber(19)
  void clearHasNoteAccess() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.bool get disableJumpEmote => $_getBF(19);
  @$pb.TagNumber(20)
  set disableJumpEmote($core.bool value) => $_setBool(19, value);
  @$pb.TagNumber(20)
  $core.bool hasDisableJumpEmote() => $_has(19);
  @$pb.TagNumber(20)
  void clearDisableJumpEmote() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get emptyBackgroundTextPlain => $_getSZ(20);
  @$pb.TagNumber(21)
  set emptyBackgroundTextPlain($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasEmptyBackgroundTextPlain() => $_has(20);
  @$pb.TagNumber(21)
  void clearEmptyBackgroundTextPlain() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.String get emptyBackgroundTextHighlight => $_getSZ(21);
  @$pb.TagNumber(22)
  set emptyBackgroundTextHighlight($core.String value) =>
      $_setString(21, value);
  @$pb.TagNumber(22)
  $core.bool hasEmptyBackgroundTextHighlight() => $_has(21);
  @$pb.TagNumber(22)
  void clearEmptyBackgroundTextHighlight() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.String get emptyBackgroundUri => $_getSZ(22);
  @$pb.TagNumber(23)
  set emptyBackgroundUri($core.String value) => $_setString(22, value);
  @$pb.TagNumber(23)
  $core.bool hasEmptyBackgroundUri() => $_has(22);
  @$pb.TagNumber(23)
  void clearEmptyBackgroundUri() => $_clearField(23);

  @$pb.TagNumber(24)
  $pb.PbList<SubjectControl_FilterTag> get supportFilterTags => $_getList(23);

  @$pb.TagNumber(25)
  EditorIconState get screenshotIconState => $_getN(24);
  @$pb.TagNumber(25)
  set screenshotIconState(EditorIconState value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasScreenshotIconState() => $_has(24);
  @$pb.TagNumber(25)
  void clearScreenshotIconState() => $_clearField(25);

  @$pb.TagNumber(26)
  EditorIconState get uploadPictureIconState => $_getN(25);
  @$pb.TagNumber(26)
  set uploadPictureIconState(EditorIconState value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasUploadPictureIconState() => $_has(25);
  @$pb.TagNumber(26)
  void clearUploadPictureIconState() => $_clearField(26);

  @$pb.TagNumber(27)
  EmptyPage get emptyPage => $_getN(26);
  @$pb.TagNumber(27)
  set emptyPage(EmptyPage value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasEmptyPage() => $_has(26);
  @$pb.TagNumber(27)
  void clearEmptyPage() => $_clearField(27);
  @$pb.TagNumber(27)
  EmptyPage ensureEmptyPage() => $_ensure(26);

  @$pb.TagNumber(28)
  SubjectControl_CmTopReplyProtection get cmTopReplyProtection => $_getN(27);
  @$pb.TagNumber(28)
  set cmTopReplyProtection(SubjectControl_CmTopReplyProtection value) =>
      $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasCmTopReplyProtection() => $_has(27);
  @$pb.TagNumber(28)
  void clearCmTopReplyProtection() => $_clearField(28);
  @$pb.TagNumber(28)
  SubjectControl_CmTopReplyProtection ensureCmTopReplyProtection() =>
      $_ensure(27);

  @$pb.TagNumber(29)
  $core.bool get enableCharged => $_getBF(28);
  @$pb.TagNumber(29)
  set enableCharged($core.bool value) => $_setBool(28, value);
  @$pb.TagNumber(29)
  $core.bool hasEnableCharged() => $_has(28);
  @$pb.TagNumber(29)
  void clearEnableCharged() => $_clearField(29);
}

enum SubjectTopCards_Item { ogvGrade, notSet }

class SubjectTopCards extends $pb.GeneratedMessage {
  factory SubjectTopCards({
    SubjectTopCards_Type? type,
    $core.String? oid,
    OgvGradeCard? ogvGrade,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (oid != null) result.oid = oid;
    if (ogvGrade != null) result.ogvGrade = ogvGrade;
    return result;
  }

  SubjectTopCards._();

  factory SubjectTopCards.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubjectTopCards.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SubjectTopCards_Item>
      _SubjectTopCards_ItemByTag = {
    3: SubjectTopCards_Item.ogvGrade,
    0: SubjectTopCards_Item.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubjectTopCards',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..oo(0, [3])
    ..aE<SubjectTopCards_Type>(1, _omitFieldNames ? '' : 'type',
        enumValues: SubjectTopCards_Type.values)
    ..aOS(2, _omitFieldNames ? '' : 'oid')
    ..aOM<OgvGradeCard>(3, _omitFieldNames ? '' : 'ogvGrade',
        subBuilder: OgvGradeCard.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubjectTopCards clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubjectTopCards copyWith(void Function(SubjectTopCards) updates) =>
      super.copyWith((message) => updates(message as SubjectTopCards))
          as SubjectTopCards;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubjectTopCards create() => SubjectTopCards._();
  @$core.override
  SubjectTopCards createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubjectTopCards getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubjectTopCards>(create);
  static SubjectTopCards? _defaultInstance;

  @$pb.TagNumber(3)
  SubjectTopCards_Item whichItem() =>
      _SubjectTopCards_ItemByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(3)
  void clearItem() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  SubjectTopCards_Type get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(SubjectTopCards_Type value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get oid => $_getSZ(1);
  @$pb.TagNumber(2)
  set oid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => $_clearField(2);

  @$pb.TagNumber(3)
  OgvGradeCard get ogvGrade => $_getN(2);
  @$pb.TagNumber(3)
  set ogvGrade(OgvGradeCard value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOgvGrade() => $_has(2);
  @$pb.TagNumber(3)
  void clearOgvGrade() => $_clearField(3);
  @$pb.TagNumber(3)
  OgvGradeCard ensureOgvGrade() => $_ensure(2);
}

class SuggestEmotesReq extends $pb.GeneratedMessage {
  factory SuggestEmotesReq({
    $fixnum.Int64? oid,
    $fixnum.Int64? type,
  }) {
    final result = create();
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    return result;
  }

  SuggestEmotesReq._();

  factory SuggestEmotesReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SuggestEmotesReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SuggestEmotesReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'oid')
    ..aInt64(2, _omitFieldNames ? '' : 'type')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestEmotesReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestEmotesReq copyWith(void Function(SuggestEmotesReq) updates) =>
      super.copyWith((message) => updates(message as SuggestEmotesReq))
          as SuggestEmotesReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SuggestEmotesReq create() => SuggestEmotesReq._();
  @$core.override
  SuggestEmotesReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SuggestEmotesReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SuggestEmotesReq>(create);
  static SuggestEmotesReq? _defaultInstance;

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
}

class SuggestEmotesResp extends $pb.GeneratedMessage {
  factory SuggestEmotesResp({
    $core.Iterable<Emote>? emotes,
  }) {
    final result = create();
    if (emotes != null) result.emotes.addAll(emotes);
    return result;
  }

  SuggestEmotesResp._();

  factory SuggestEmotesResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SuggestEmotesResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SuggestEmotesResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..pPM<Emote>(1, _omitFieldNames ? '' : 'emotes', subBuilder: Emote.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestEmotesResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestEmotesResp copyWith(void Function(SuggestEmotesResp) updates) =>
      super.copyWith((message) => updates(message as SuggestEmotesResp))
          as SuggestEmotesResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SuggestEmotesResp create() => SuggestEmotesResp._();
  @$core.override
  SuggestEmotesResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SuggestEmotesResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SuggestEmotesResp>(create);
  static SuggestEmotesResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Emote> get emotes => $_getList(0);
}

class TextStyle extends $pb.GeneratedMessage {
  factory TextStyle({
    $core.int? fontSize,
    TextStyle_FontStyle? fontStyle,
    $core.String? textDayColor,
    $core.String? textNightColor,
  }) {
    final result = create();
    if (fontSize != null) result.fontSize = fontSize;
    if (fontStyle != null) result.fontStyle = fontStyle;
    if (textDayColor != null) result.textDayColor = textDayColor;
    if (textNightColor != null) result.textNightColor = textNightColor;
    return result;
  }

  TextStyle._();

  factory TextStyle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TextStyle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TextStyle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'fontSize')
    ..aE<TextStyle_FontStyle>(2, _omitFieldNames ? '' : 'fontStyle',
        enumValues: TextStyle_FontStyle.values)
    ..aOS(3, _omitFieldNames ? '' : 'textDayColor')
    ..aOS(4, _omitFieldNames ? '' : 'textNightColor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextStyle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextStyle copyWith(void Function(TextStyle) updates) =>
      super.copyWith((message) => updates(message as TextStyle)) as TextStyle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TextStyle create() => TextStyle._();
  @$core.override
  TextStyle createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TextStyle getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TextStyle>(create);
  static TextStyle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get fontSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set fontSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFontSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearFontSize() => $_clearField(1);

  @$pb.TagNumber(2)
  TextStyle_FontStyle get fontStyle => $_getN(1);
  @$pb.TagNumber(2)
  set fontStyle(TextStyle_FontStyle value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFontStyle() => $_has(1);
  @$pb.TagNumber(2)
  void clearFontStyle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get textDayColor => $_getSZ(2);
  @$pb.TagNumber(3)
  set textDayColor($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTextDayColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextDayColor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get textNightColor => $_getSZ(3);
  @$pb.TagNumber(4)
  set textNightColor($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTextNightColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearTextNightColor() => $_clearField(4);
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

class UpSelection extends $pb.GeneratedMessage {
  factory UpSelection({
    $fixnum.Int64? pendingCount,
    $fixnum.Int64? ignoreCount,
  }) {
    final result = create();
    if (pendingCount != null) result.pendingCount = pendingCount;
    if (ignoreCount != null) result.ignoreCount = ignoreCount;
    return result;
  }

  UpSelection._();

  factory UpSelection.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpSelection.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpSelection',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'pendingCount')
    ..aInt64(2, _omitFieldNames ? '' : 'ignoreCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpSelection clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpSelection copyWith(void Function(UpSelection) updates) =>
      super.copyWith((message) => updates(message as UpSelection))
          as UpSelection;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpSelection create() => UpSelection._();
  @$core.override
  UpSelection createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpSelection getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpSelection>(create);
  static UpSelection? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get pendingCount => $_getI64(0);
  @$pb.TagNumber(1)
  set pendingCount($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPendingCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearPendingCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get ignoreCount => $_getI64(1);
  @$pb.TagNumber(2)
  set ignoreCount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIgnoreCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearIgnoreCount() => $_clearField(2);
}

class UpdateSingleReplyNotificationConfigReq extends $pb.GeneratedMessage {
  factory UpdateSingleReplyNotificationConfigReq({
    $fixnum.Int64? rpid,
    $fixnum.Int64? type,
    $fixnum.Int64? oid,
    ReplyNotificationSwitch? pushSwitch,
  }) {
    final result = create();
    if (rpid != null) result.rpid = rpid;
    if (type != null) result.type = type;
    if (oid != null) result.oid = oid;
    if (pushSwitch != null) result.pushSwitch = pushSwitch;
    return result;
  }

  UpdateSingleReplyNotificationConfigReq._();

  factory UpdateSingleReplyNotificationConfigReq.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateSingleReplyNotificationConfigReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSingleReplyNotificationConfigReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'rpid')
    ..aInt64(2, _omitFieldNames ? '' : 'type')
    ..aInt64(3, _omitFieldNames ? '' : 'oid')
    ..aE<ReplyNotificationSwitch>(4, _omitFieldNames ? '' : 'pushSwitch',
        enumValues: ReplyNotificationSwitch.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSingleReplyNotificationConfigReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSingleReplyNotificationConfigReq copyWith(
          void Function(UpdateSingleReplyNotificationConfigReq) updates) =>
      super.copyWith((message) =>
              updates(message as UpdateSingleReplyNotificationConfigReq))
          as UpdateSingleReplyNotificationConfigReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateSingleReplyNotificationConfigReq create() =>
      UpdateSingleReplyNotificationConfigReq._();
  @$core.override
  UpdateSingleReplyNotificationConfigReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateSingleReplyNotificationConfigReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          UpdateSingleReplyNotificationConfigReq>(create);
  static UpdateSingleReplyNotificationConfigReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get rpid => $_getI64(0);
  @$pb.TagNumber(1)
  set rpid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRpid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRpid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get type => $_getI64(1);
  @$pb.TagNumber(2)
  set type($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get oid => $_getI64(2);
  @$pb.TagNumber(3)
  set oid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOid() => $_has(2);
  @$pb.TagNumber(3)
  void clearOid() => $_clearField(3);

  @$pb.TagNumber(4)
  ReplyNotificationSwitch get pushSwitch => $_getN(3);
  @$pb.TagNumber(4)
  set pushSwitch(ReplyNotificationSwitch value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPushSwitch() => $_has(3);
  @$pb.TagNumber(4)
  void clearPushSwitch() => $_clearField(4);
}

class UpdateSingleReplyNotificationConfigResp extends $pb.GeneratedMessage {
  factory UpdateSingleReplyNotificationConfigResp() => create();

  UpdateSingleReplyNotificationConfigResp._();

  factory UpdateSingleReplyNotificationConfigResp.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateSingleReplyNotificationConfigResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateSingleReplyNotificationConfigResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSingleReplyNotificationConfigResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateSingleReplyNotificationConfigResp copyWith(
          void Function(UpdateSingleReplyNotificationConfigResp) updates) =>
      super.copyWith((message) =>
              updates(message as UpdateSingleReplyNotificationConfigResp))
          as UpdateSingleReplyNotificationConfigResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateSingleReplyNotificationConfigResp create() =>
      UpdateSingleReplyNotificationConfigResp._();
  @$core.override
  UpdateSingleReplyNotificationConfigResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateSingleReplyNotificationConfigResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          UpdateSingleReplyNotificationConfigResp>(create);
  static UpdateSingleReplyNotificationConfigResp? _defaultInstance;
}

class Url_Extra extends $pb.GeneratedMessage {
  factory Url_Extra({
    $fixnum.Int64? goodsItemId,
    $core.String? goodsPrefetchedCache,
    Url_Extra_GoodsShowType? goodsShowType,
    $core.bool? isWordSearch,
    $fixnum.Int64? goodsCmControl,
    $core.String? goodsClickReport,
    $core.String? goodsExposureReport,
    $fixnum.Int64? goodsShowPopWindow,
  }) {
    final result = create();
    if (goodsItemId != null) result.goodsItemId = goodsItemId;
    if (goodsPrefetchedCache != null)
      result.goodsPrefetchedCache = goodsPrefetchedCache;
    if (goodsShowType != null) result.goodsShowType = goodsShowType;
    if (isWordSearch != null) result.isWordSearch = isWordSearch;
    if (goodsCmControl != null) result.goodsCmControl = goodsCmControl;
    if (goodsClickReport != null) result.goodsClickReport = goodsClickReport;
    if (goodsExposureReport != null)
      result.goodsExposureReport = goodsExposureReport;
    if (goodsShowPopWindow != null)
      result.goodsShowPopWindow = goodsShowPopWindow;
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
    ..aE<Url_Extra_GoodsShowType>(3, _omitFieldNames ? '' : 'goodsShowType',
        enumValues: Url_Extra_GoodsShowType.values)
    ..aOB(4, _omitFieldNames ? '' : 'isWordSearch')
    ..aInt64(5, _omitFieldNames ? '' : 'goodsCmControl')
    ..aOS(6, _omitFieldNames ? '' : 'goodsClickReport')
    ..aOS(7, _omitFieldNames ? '' : 'goodsExposureReport')
    ..aInt64(8, _omitFieldNames ? '' : 'goodsShowPopWindow')
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

  @$pb.TagNumber(3)
  Url_Extra_GoodsShowType get goodsShowType => $_getN(2);
  @$pb.TagNumber(3)
  set goodsShowType(Url_Extra_GoodsShowType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasGoodsShowType() => $_has(2);
  @$pb.TagNumber(3)
  void clearGoodsShowType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isWordSearch => $_getBF(3);
  @$pb.TagNumber(4)
  set isWordSearch($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsWordSearch() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsWordSearch() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get goodsCmControl => $_getI64(4);
  @$pb.TagNumber(5)
  set goodsCmControl($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasGoodsCmControl() => $_has(4);
  @$pb.TagNumber(5)
  void clearGoodsCmControl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get goodsClickReport => $_getSZ(5);
  @$pb.TagNumber(6)
  set goodsClickReport($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasGoodsClickReport() => $_has(5);
  @$pb.TagNumber(6)
  void clearGoodsClickReport() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get goodsExposureReport => $_getSZ(6);
  @$pb.TagNumber(7)
  set goodsExposureReport($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasGoodsExposureReport() => $_has(6);
  @$pb.TagNumber(7)
  void clearGoodsExposureReport() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get goodsShowPopWindow => $_getI64(7);
  @$pb.TagNumber(8)
  set goodsShowPopWindow($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasGoodsShowPopWindow() => $_has(7);
  @$pb.TagNumber(8)
  void clearGoodsShowPopWindow() => $_clearField(8);
}

class Url extends $pb.GeneratedMessage {
  factory Url({
    $core.String? title,
    $fixnum.Int64? state,
    $core.String? prefixIcon,
    $core.String? appUrlSchema,
    $core.String? appName,
    $core.String? appPackageName,
    $core.String? clickReport,
    $core.bool? isHalfScreen,
    $core.String? exposureReport,
    Url_Extra? extra,
    $core.bool? underline,
    $core.bool? matchOnce,
    $core.String? pcUrl,
    Url_IconPosition? iconPosition,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (state != null) result.state = state;
    if (prefixIcon != null) result.prefixIcon = prefixIcon;
    if (appUrlSchema != null) result.appUrlSchema = appUrlSchema;
    if (appName != null) result.appName = appName;
    if (appPackageName != null) result.appPackageName = appPackageName;
    if (clickReport != null) result.clickReport = clickReport;
    if (isHalfScreen != null) result.isHalfScreen = isHalfScreen;
    if (exposureReport != null) result.exposureReport = exposureReport;
    if (extra != null) result.extra = extra;
    if (underline != null) result.underline = underline;
    if (matchOnce != null) result.matchOnce = matchOnce;
    if (pcUrl != null) result.pcUrl = pcUrl;
    if (iconPosition != null) result.iconPosition = iconPosition;
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
    ..aInt64(2, _omitFieldNames ? '' : 'state')
    ..aOS(3, _omitFieldNames ? '' : 'prefixIcon')
    ..aOS(4, _omitFieldNames ? '' : 'appUrlSchema')
    ..aOS(5, _omitFieldNames ? '' : 'appName')
    ..aOS(6, _omitFieldNames ? '' : 'appPackageName')
    ..aOS(7, _omitFieldNames ? '' : 'clickReport')
    ..aOB(8, _omitFieldNames ? '' : 'isHalfScreen')
    ..aOS(9, _omitFieldNames ? '' : 'exposureReport')
    ..aOM<Url_Extra>(10, _omitFieldNames ? '' : 'extra',
        subBuilder: Url_Extra.create)
    ..aOB(11, _omitFieldNames ? '' : 'underline')
    ..aOB(12, _omitFieldNames ? '' : 'matchOnce')
    ..aOS(13, _omitFieldNames ? '' : 'pcUrl')
    ..aE<Url_IconPosition>(14, _omitFieldNames ? '' : 'iconPosition',
        enumValues: Url_IconPosition.values)
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

  @$pb.TagNumber(2)
  $fixnum.Int64 get state => $_getI64(1);
  @$pb.TagNumber(2)
  set state($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get prefixIcon => $_getSZ(2);
  @$pb.TagNumber(3)
  set prefixIcon($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrefixIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrefixIcon() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get appUrlSchema => $_getSZ(3);
  @$pb.TagNumber(4)
  set appUrlSchema($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAppUrlSchema() => $_has(3);
  @$pb.TagNumber(4)
  void clearAppUrlSchema() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get appName => $_getSZ(4);
  @$pb.TagNumber(5)
  set appName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAppName() => $_has(4);
  @$pb.TagNumber(5)
  void clearAppName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get appPackageName => $_getSZ(5);
  @$pb.TagNumber(6)
  set appPackageName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAppPackageName() => $_has(5);
  @$pb.TagNumber(6)
  void clearAppPackageName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get clickReport => $_getSZ(6);
  @$pb.TagNumber(7)
  set clickReport($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasClickReport() => $_has(6);
  @$pb.TagNumber(7)
  void clearClickReport() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isHalfScreen => $_getBF(7);
  @$pb.TagNumber(8)
  set isHalfScreen($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsHalfScreen() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsHalfScreen() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get exposureReport => $_getSZ(8);
  @$pb.TagNumber(9)
  set exposureReport($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasExposureReport() => $_has(8);
  @$pb.TagNumber(9)
  void clearExposureReport() => $_clearField(9);

  @$pb.TagNumber(10)
  Url_Extra get extra => $_getN(9);
  @$pb.TagNumber(10)
  set extra(Url_Extra value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasExtra() => $_has(9);
  @$pb.TagNumber(10)
  void clearExtra() => $_clearField(10);
  @$pb.TagNumber(10)
  Url_Extra ensureExtra() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.bool get underline => $_getBF(10);
  @$pb.TagNumber(11)
  set underline($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasUnderline() => $_has(10);
  @$pb.TagNumber(11)
  void clearUnderline() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get matchOnce => $_getBF(11);
  @$pb.TagNumber(12)
  set matchOnce($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasMatchOnce() => $_has(11);
  @$pb.TagNumber(12)
  void clearMatchOnce() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get pcUrl => $_getSZ(12);
  @$pb.TagNumber(13)
  set pcUrl($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasPcUrl() => $_has(12);
  @$pb.TagNumber(13)
  void clearPcUrl() => $_clearField(13);

  @$pb.TagNumber(14)
  Url_IconPosition get iconPosition => $_getN(13);
  @$pb.TagNumber(14)
  set iconPosition(Url_IconPosition value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasIconPosition() => $_has(13);
  @$pb.TagNumber(14)
  void clearIconPosition() => $_clearField(14);
}

class UserCallbackReply extends $pb.GeneratedMessage {
  factory UserCallbackReply() => create();

  UserCallbackReply._();

  factory UserCallbackReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserCallbackReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserCallbackReply',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCallbackReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCallbackReply copyWith(void Function(UserCallbackReply) updates) =>
      super.copyWith((message) => updates(message as UserCallbackReply))
          as UserCallbackReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserCallbackReply create() => UserCallbackReply._();
  @$core.override
  UserCallbackReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserCallbackReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserCallbackReply>(create);
  static UserCallbackReply? _defaultInstance;
}

class UserCallbackReq extends $pb.GeneratedMessage {
  factory UserCallbackReq({
    $fixnum.Int64? mid,
    UserCallbackScene? scene,
    UserCallbackAction? action,
    $fixnum.Int64? oid,
    $fixnum.Int64? type,
    $core.Iterable<$fixnum.Int64>? rpids,
  }) {
    final result = create();
    if (mid != null) result.mid = mid;
    if (scene != null) result.scene = scene;
    if (action != null) result.action = action;
    if (oid != null) result.oid = oid;
    if (type != null) result.type = type;
    if (rpids != null) result.rpids.addAll(rpids);
    return result;
  }

  UserCallbackReq._();

  factory UserCallbackReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserCallbackReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserCallbackReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aE<UserCallbackScene>(2, _omitFieldNames ? '' : 'scene',
        enumValues: UserCallbackScene.values)
    ..aE<UserCallbackAction>(3, _omitFieldNames ? '' : 'action',
        enumValues: UserCallbackAction.values)
    ..aInt64(4, _omitFieldNames ? '' : 'oid')
    ..aInt64(5, _omitFieldNames ? '' : 'type')
    ..p<$fixnum.Int64>(6, _omitFieldNames ? '' : 'rpids', $pb.PbFieldType.K6)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCallbackReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCallbackReq copyWith(void Function(UserCallbackReq) updates) =>
      super.copyWith((message) => updates(message as UserCallbackReq))
          as UserCallbackReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserCallbackReq create() => UserCallbackReq._();
  @$core.override
  UserCallbackReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserCallbackReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserCallbackReq>(create);
  static UserCallbackReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get mid => $_getI64(0);
  @$pb.TagNumber(1)
  set mid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearMid() => $_clearField(1);

  @$pb.TagNumber(2)
  UserCallbackScene get scene => $_getN(1);
  @$pb.TagNumber(2)
  set scene(UserCallbackScene value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasScene() => $_has(1);
  @$pb.TagNumber(2)
  void clearScene() => $_clearField(2);

  @$pb.TagNumber(3)
  UserCallbackAction get action => $_getN(2);
  @$pb.TagNumber(3)
  set action(UserCallbackAction value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAction() => $_has(2);
  @$pb.TagNumber(3)
  void clearAction() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get oid => $_getI64(3);
  @$pb.TagNumber(4)
  set oid($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOid() => $_has(3);
  @$pb.TagNumber(4)
  void clearOid() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get type => $_getI64(4);
  @$pb.TagNumber(5)
  set type($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasType() => $_has(4);
  @$pb.TagNumber(5)
  void clearType() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$fixnum.Int64> get rpids => $_getList(5);
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
    $fixnum.Int64? count,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (count != null) result.count = count;
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
    ..aInt64(3, _omitFieldNames ? '' : 'count')
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

  @$pb.TagNumber(3)
  $fixnum.Int64 get count => $_getI64(2);
  @$pb.TagNumber(3)
  set count($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCount() => $_clearField(3);
}

class VoteCard_Option extends $pb.GeneratedMessage {
  factory VoteCard_Option({
    $fixnum.Int64? idx,
    $core.String? desc,
    $fixnum.Int64? count,
  }) {
    final result = create();
    if (idx != null) result.idx = idx;
    if (desc != null) result.desc = desc;
    if (count != null) result.count = count;
    return result;
  }

  VoteCard_Option._();

  factory VoteCard_Option.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VoteCard_Option.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoteCard.Option',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'idx')
    ..aOS(2, _omitFieldNames ? '' : 'desc')
    ..aInt64(3, _omitFieldNames ? '' : 'count')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoteCard_Option clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoteCard_Option copyWith(void Function(VoteCard_Option) updates) =>
      super.copyWith((message) => updates(message as VoteCard_Option))
          as VoteCard_Option;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VoteCard_Option create() => VoteCard_Option._();
  @$core.override
  VoteCard_Option createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VoteCard_Option getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VoteCard_Option>(create);
  static VoteCard_Option? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get idx => $_getI64(0);
  @$pb.TagNumber(1)
  set idx($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdx() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdx() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get desc => $_getSZ(1);
  @$pb.TagNumber(2)
  set desc($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDesc() => $_has(1);
  @$pb.TagNumber(2)
  void clearDesc() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get count => $_getI64(2);
  @$pb.TagNumber(3)
  set count($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCount() => $_clearField(3);
}

class VoteCard extends $pb.GeneratedMessage {
  factory VoteCard({
    $fixnum.Int64? voteId,
    $core.String? title,
    $fixnum.Int64? count,
    $core.Iterable<VoteCard_Option>? options,
    $fixnum.Int64? myVoteOption,
  }) {
    final result = create();
    if (voteId != null) result.voteId = voteId;
    if (title != null) result.title = title;
    if (count != null) result.count = count;
    if (options != null) result.options.addAll(options);
    if (myVoteOption != null) result.myVoteOption = myVoteOption;
    return result;
  }

  VoteCard._();

  factory VoteCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VoteCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoteCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'voteId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aInt64(3, _omitFieldNames ? '' : 'count')
    ..pPM<VoteCard_Option>(4, _omitFieldNames ? '' : 'options',
        subBuilder: VoteCard_Option.create)
    ..aInt64(5, _omitFieldNames ? '' : 'myVoteOption')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoteCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoteCard copyWith(void Function(VoteCard) updates) =>
      super.copyWith((message) => updates(message as VoteCard)) as VoteCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VoteCard create() => VoteCard._();
  @$core.override
  VoteCard createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VoteCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VoteCard>(create);
  static VoteCard? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get voteId => $_getI64(0);
  @$pb.TagNumber(1)
  set voteId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVoteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVoteId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get count => $_getI64(2);
  @$pb.TagNumber(3)
  set count($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<VoteCard_Option> get options => $_getList(3);

  @$pb.TagNumber(5)
  $fixnum.Int64 get myVoteOption => $_getI64(4);
  @$pb.TagNumber(5)
  set myVoteOption($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMyVoteOption() => $_has(4);
  @$pb.TagNumber(5)
  void clearMyVoteOption() => $_clearField(5);
}

class WordSearchParam extends $pb.GeneratedMessage {
  factory WordSearchParam({
    $fixnum.Int64? shownCount,
  }) {
    final result = create();
    if (shownCount != null) result.shownCount = shownCount;
    return result;
  }

  WordSearchParam._();

  factory WordSearchParam.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WordSearchParam.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WordSearchParam',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'shownCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WordSearchParam clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WordSearchParam copyWith(void Function(WordSearchParam) updates) =>
      super.copyWith((message) => updates(message as WordSearchParam))
          as WordSearchParam;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WordSearchParam create() => WordSearchParam._();
  @$core.override
  WordSearchParam createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WordSearchParam getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WordSearchParam>(create);
  static WordSearchParam? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get shownCount => $_getI64(0);
  @$pb.TagNumber(1)
  set shownCount($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShownCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearShownCount() => $_clearField(1);
}

class TranslateReplyReq extends $pb.GeneratedMessage {
  factory TranslateReplyReq({
    $fixnum.Int64? type,
    $fixnum.Int64? oid,
    $core.Iterable<$fixnum.Int64>? rpids,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (oid != null) result.oid = oid;
    if (rpids != null) result.rpids.addAll(rpids);
    return result;
  }

  TranslateReplyReq._();

  factory TranslateReplyReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TranslateReplyReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TranslateReplyReq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'type')
    ..aInt64(2, _omitFieldNames ? '' : 'oid')
    ..p<$fixnum.Int64>(3, _omitFieldNames ? '' : 'rpids', $pb.PbFieldType.K6)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslateReplyReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslateReplyReq copyWith(void Function(TranslateReplyReq) updates) =>
      super.copyWith((message) => updates(message as TranslateReplyReq))
          as TranslateReplyReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TranslateReplyReq create() => TranslateReplyReq._();
  @$core.override
  TranslateReplyReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TranslateReplyReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TranslateReplyReq>(create);
  static TranslateReplyReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get type => $_getI64(0);
  @$pb.TagNumber(1)
  set type($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get oid => $_getI64(1);
  @$pb.TagNumber(2)
  set oid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOid() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$fixnum.Int64> get rpids => $_getList(2);
}

class TranslateReplyResp extends $pb.GeneratedMessage {
  factory TranslateReplyResp({
    $core.Iterable<$core.MapEntry<$fixnum.Int64, ReplyInfo>>? translatedReplies,
  }) {
    final result = create();
    if (translatedReplies != null)
      result.translatedReplies.addEntries(translatedReplies);
    return result;
  }

  TranslateReplyResp._();

  factory TranslateReplyResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TranslateReplyResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TranslateReplyResp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.main.community.reply.v1'),
      createEmptyInstance: create)
    ..m<$fixnum.Int64, ReplyInfo>(1, _omitFieldNames ? '' : 'translatedReplies',
        entryClassName: 'TranslateReplyResp.TranslatedRepliesEntry',
        keyFieldType: $pb.PbFieldType.O6,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: ReplyInfo.create,
        valueDefaultOrMaker: ReplyInfo.getDefault,
        packageName: const $pb.PackageName('bilibili.main.community.reply.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslateReplyResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TranslateReplyResp copyWith(void Function(TranslateReplyResp) updates) =>
      super.copyWith((message) => updates(message as TranslateReplyResp))
          as TranslateReplyResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TranslateReplyResp create() => TranslateReplyResp._();
  @$core.override
  TranslateReplyResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TranslateReplyResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TranslateReplyResp>(create);
  static TranslateReplyResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$fixnum.Int64, ReplyInfo> get translatedReplies => $_getMap(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
