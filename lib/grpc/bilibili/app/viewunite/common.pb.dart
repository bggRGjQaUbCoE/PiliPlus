// This is a generated file - do not edit.
//
// Generated from bilibili/app/viewunite/common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/any.pb.dart' as $0;

import '../../account/service/v1.pb.dart' as $2;
import '../../dagw/component/avatar/v1.pb.dart' as $1;
import '../../pagination.pb.dart' as $3;
import '../../playershared.pbenum.dart' as $4;
import 'common.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'common.pbenum.dart';

class ActBannerItem extends $pb.GeneratedMessage {
  factory ActBannerItem({
    $core.String? url,
    $core.String? cover,
    JumpType? jumpType,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
  }) {
    final result = ActBannerItem._();
    if (url != null) result.url = url;
    if (cover != null) result.cover = cover;
    if (jumpType != null) result.jumpType = jumpType;
    if (report != null) result.report.addEntries(report);
    return result;
  }

  ActBannerItem._();

  factory ActBannerItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActBannerItem()..mergeFromBuffer(data, registry);
  factory ActBannerItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActBannerItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActBannerItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ActBannerItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOS(2, _omitFieldNames ? '' : 'cover')
    ..aE<JumpType>(3, _omitFieldNames ? '' : 'jumpType',
        enumValues: JumpType.values)
    ..m<$core.String, $core.String>(4, _omitFieldNames ? '' : 'report',
        entryClassName: 'ActBannerItem.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActBannerItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActBannerItem copyWith(void Function(ActBannerItem) updates) =>
      super.copyWith((message) => updates(message as ActBannerItem))
          as ActBannerItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ActBannerItem() / ActBannerItem.new instead')
  static ActBannerItem create() => ActBannerItem._();
  static $pb.GeneratedMessage $_createMessage() => ActBannerItem._();
  @$core.override
  ActBannerItem createEmptyInstance() => ActBannerItem._();
  @$core.pragma('dart2js:noInline')
  static ActBannerItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActBannerItem>(
          ActBannerItem.$_createMessage);
  static ActBannerItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cover => $_getSZ(1);
  @$pb.TagNumber(2)
  set cover($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCover() => $_has(1);
  @$pb.TagNumber(2)
  void clearCover() => $_clearField(2);

  @$pb.TagNumber(3)
  JumpType get jumpType => $_getN(2);
  @$pb.TagNumber(3)
  set jumpType(JumpType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasJumpType() => $_has(2);
  @$pb.TagNumber(3)
  void clearJumpType() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(3);
}

class ActPageItems extends $pb.GeneratedMessage {
  factory ActPageItems({
    $core.Iterable<ActBannerItem>? item,
    ShowStyle? showStyle,
    $core.String? title,
  }) {
    final result = ActPageItems._();
    if (item != null) result.item.addAll(item);
    if (showStyle != null) result.showStyle = showStyle;
    if (title != null) result.title = title;
    return result;
  }

  ActPageItems._();

  factory ActPageItems.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActPageItems()..mergeFromBuffer(data, registry);
  factory ActPageItems.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActPageItems()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActPageItems',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ActPageItems.$_createMessage)
    ..pPM<ActBannerItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: ActBannerItem.$_createMessage)
    ..aE<ShowStyle>(2, _omitFieldNames ? '' : 'showStyle',
        enumValues: ShowStyle.values)
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActPageItems clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActPageItems copyWith(void Function(ActPageItems) updates) =>
      super.copyWith((message) => updates(message as ActPageItems))
          as ActPageItems;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ActPageItems() / ActPageItems.new instead')
  static ActPageItems create() => ActPageItems._();
  static $pb.GeneratedMessage $_createMessage() => ActPageItems._();
  @$core.override
  ActPageItems createEmptyInstance() => ActPageItems._();
  @$core.pragma('dart2js:noInline')
  static ActPageItems getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActPageItems>(
          ActPageItems.$_createMessage);
  static ActPageItems? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ActBannerItem> get item => $_getList(0);

  @$pb.TagNumber(2)
  ShowStyle get showStyle => $_getN(1);
  @$pb.TagNumber(2)
  set showStyle(ShowStyle value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasShowStyle() => $_has(1);
  @$pb.TagNumber(2)
  void clearShowStyle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);
}

class Activity extends $pb.GeneratedMessage {
  factory Activity({
    $core.int? id,
    $core.String? title,
    $core.String? link,
    $core.String? cover,
    $core.int? type,
    $core.String? ab,
    $core.String? showName,
    $core.String? picurl,
    $core.String? picurlSelected,
    $core.String? h5Link,
    $core.String? jumpMode,
    $core.Iterable<Item>? items,
  }) {
    final result = Activity._();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (link != null) result.link = link;
    if (cover != null) result.cover = cover;
    if (type != null) result.type = type;
    if (ab != null) result.ab = ab;
    if (showName != null) result.showName = showName;
    if (picurl != null) result.picurl = picurl;
    if (picurlSelected != null) result.picurlSelected = picurlSelected;
    if (h5Link != null) result.h5Link = h5Link;
    if (jumpMode != null) result.jumpMode = jumpMode;
    if (items != null) result.items.addAll(items);
    return result;
  }

  Activity._();

  factory Activity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Activity()..mergeFromBuffer(data, registry);
  factory Activity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Activity()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Activity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Activity.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'link')
    ..aOS(4, _omitFieldNames ? '' : 'cover')
    ..aI(5, _omitFieldNames ? '' : 'type')
    ..aOS(6, _omitFieldNames ? '' : 'ab')
    ..aOS(7, _omitFieldNames ? '' : 'showName')
    ..aOS(8, _omitFieldNames ? '' : 'picurl')
    ..aOS(9, _omitFieldNames ? '' : 'picurlSelected')
    ..aOS(10, _omitFieldNames ? '' : 'h5Link')
    ..aOS(11, _omitFieldNames ? '' : 'jumpMode')
    ..pPM<Item>(12, _omitFieldNames ? '' : 'items',
        subBuilder: Item.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Activity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Activity copyWith(void Function(Activity) updates) =>
      super.copyWith((message) => updates(message as Activity)) as Activity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Activity() / Activity.new instead')
  static Activity create() => Activity._();
  static $pb.GeneratedMessage $_createMessage() => Activity._();
  @$core.override
  Activity createEmptyInstance() => Activity._();
  @$core.pragma('dart2js:noInline')
  static Activity getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Activity>(Activity.$_createMessage);
  static Activity? _defaultInstance;

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
  $core.String get link => $_getSZ(2);
  @$pb.TagNumber(3)
  set link($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLink() => $_has(2);
  @$pb.TagNumber(3)
  void clearLink() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get cover => $_getSZ(3);
  @$pb.TagNumber(4)
  set cover($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCover() => $_has(3);
  @$pb.TagNumber(4)
  void clearCover() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get type => $_getIZ(4);
  @$pb.TagNumber(5)
  set type($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasType() => $_has(4);
  @$pb.TagNumber(5)
  void clearType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get ab => $_getSZ(5);
  @$pb.TagNumber(6)
  set ab($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAb() => $_has(5);
  @$pb.TagNumber(6)
  void clearAb() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get showName => $_getSZ(6);
  @$pb.TagNumber(7)
  set showName($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasShowName() => $_has(6);
  @$pb.TagNumber(7)
  void clearShowName() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get picurl => $_getSZ(7);
  @$pb.TagNumber(8)
  set picurl($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPicurl() => $_has(7);
  @$pb.TagNumber(8)
  void clearPicurl() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get picurlSelected => $_getSZ(8);
  @$pb.TagNumber(9)
  set picurlSelected($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPicurlSelected() => $_has(8);
  @$pb.TagNumber(9)
  void clearPicurlSelected() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get h5Link => $_getSZ(9);
  @$pb.TagNumber(10)
  set h5Link($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasH5Link() => $_has(9);
  @$pb.TagNumber(10)
  void clearH5Link() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get jumpMode => $_getSZ(10);
  @$pb.TagNumber(11)
  set jumpMode($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasJumpMode() => $_has(10);
  @$pb.TagNumber(11)
  void clearJumpMode() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<Item> get items => $_getList(11);
}

class ActivityEntrance extends $pb.GeneratedMessage {
  factory ActivityEntrance({
    $core.String? activityCover,
    $core.String? activityTitle,
    $core.String? wordTag,
    $core.String? activitySubtitle,
    $core.String? activityLink,
    $core.int? activityType,
    $core.int? reserveId,
    $core.int? status,
    $core.Iterable<User>? upperList,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>?
        orderReportParams,
  }) {
    final result = ActivityEntrance._();
    if (activityCover != null) result.activityCover = activityCover;
    if (activityTitle != null) result.activityTitle = activityTitle;
    if (wordTag != null) result.wordTag = wordTag;
    if (activitySubtitle != null) result.activitySubtitle = activitySubtitle;
    if (activityLink != null) result.activityLink = activityLink;
    if (activityType != null) result.activityType = activityType;
    if (reserveId != null) result.reserveId = reserveId;
    if (status != null) result.status = status;
    if (upperList != null) result.upperList.addAll(upperList);
    if (report != null) result.report.addEntries(report);
    if (orderReportParams != null)
      result.orderReportParams.addEntries(orderReportParams);
    return result;
  }

  ActivityEntrance._();

  factory ActivityEntrance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActivityEntrance()..mergeFromBuffer(data, registry);
  factory ActivityEntrance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActivityEntrance()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActivityEntrance',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ActivityEntrance.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'activityCover')
    ..aOS(2, _omitFieldNames ? '' : 'activityTitle')
    ..aOS(3, _omitFieldNames ? '' : 'wordTag')
    ..aOS(4, _omitFieldNames ? '' : 'activitySubtitle')
    ..aOS(5, _omitFieldNames ? '' : 'activityLink')
    ..aI(6, _omitFieldNames ? '' : 'activityType')
    ..aI(7, _omitFieldNames ? '' : 'reserveId')
    ..aI(8, _omitFieldNames ? '' : 'status')
    ..pPM<User>(9, _omitFieldNames ? '' : 'upperList',
        subBuilder: User.$_createMessage)
    ..m<$core.String, $core.String>(10, _omitFieldNames ? '' : 'report',
        entryClassName: 'ActivityEntrance.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..m<$core.String, $core.String>(
        11, _omitFieldNames ? '' : 'orderReportParams',
        entryClassName: 'ActivityEntrance.OrderReportParamsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivityEntrance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivityEntrance copyWith(void Function(ActivityEntrance) updates) =>
      super.copyWith((message) => updates(message as ActivityEntrance))
          as ActivityEntrance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ActivityEntrance() / ActivityEntrance.new instead')
  static ActivityEntrance create() => ActivityEntrance._();
  static $pb.GeneratedMessage $_createMessage() => ActivityEntrance._();
  @$core.override
  ActivityEntrance createEmptyInstance() => ActivityEntrance._();
  @$core.pragma('dart2js:noInline')
  static ActivityEntrance getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActivityEntrance>(
          ActivityEntrance.$_createMessage);
  static ActivityEntrance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get activityCover => $_getSZ(0);
  @$pb.TagNumber(1)
  set activityCover($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActivityCover() => $_has(0);
  @$pb.TagNumber(1)
  void clearActivityCover() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get activityTitle => $_getSZ(1);
  @$pb.TagNumber(2)
  set activityTitle($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasActivityTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearActivityTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get wordTag => $_getSZ(2);
  @$pb.TagNumber(3)
  set wordTag($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWordTag() => $_has(2);
  @$pb.TagNumber(3)
  void clearWordTag() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get activitySubtitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set activitySubtitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActivitySubtitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearActivitySubtitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get activityLink => $_getSZ(4);
  @$pb.TagNumber(5)
  set activityLink($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasActivityLink() => $_has(4);
  @$pb.TagNumber(5)
  void clearActivityLink() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get activityType => $_getIZ(5);
  @$pb.TagNumber(6)
  set activityType($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasActivityType() => $_has(5);
  @$pb.TagNumber(6)
  void clearActivityType() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get reserveId => $_getIZ(6);
  @$pb.TagNumber(7)
  set reserveId($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReserveId() => $_has(6);
  @$pb.TagNumber(7)
  void clearReserveId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get status => $_getIZ(7);
  @$pb.TagNumber(8)
  set status($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<User> get upperList => $_getList(8);

  @$pb.TagNumber(10)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(9);

  @$pb.TagNumber(11)
  $pb.PbMap<$core.String, $core.String> get orderReportParams => $_getMap(10);
}

class ActivityEntranceModule extends $pb.GeneratedMessage {
  factory ActivityEntranceModule({
    $core.Iterable<ActivityEntrance>? activityEntrance,
  }) {
    final result = ActivityEntranceModule._();
    if (activityEntrance != null)
      result.activityEntrance.addAll(activityEntrance);
    return result;
  }

  ActivityEntranceModule._();

  factory ActivityEntranceModule.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActivityEntranceModule()..mergeFromBuffer(data, registry);
  factory ActivityEntranceModule.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActivityEntranceModule()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActivityEntranceModule',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ActivityEntranceModule.$_createMessage)
    ..pPM<ActivityEntrance>(1, _omitFieldNames ? '' : 'activityEntrance',
        subBuilder: ActivityEntrance.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivityEntranceModule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivityEntranceModule copyWith(
          void Function(ActivityEntranceModule) updates) =>
      super.copyWith((message) => updates(message as ActivityEntranceModule))
          as ActivityEntranceModule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ActivityEntranceModule() / ActivityEntranceModule.new instead')
  static ActivityEntranceModule create() => ActivityEntranceModule._();
  static $pb.GeneratedMessage $_createMessage() => ActivityEntranceModule._();
  @$core.override
  ActivityEntranceModule createEmptyInstance() => ActivityEntranceModule._();
  @$core.pragma('dart2js:noInline')
  static ActivityEntranceModule getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ActivityEntranceModule>(
          ActivityEntranceModule.$_createMessage);
  static ActivityEntranceModule? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ActivityEntrance> get activityEntrance => $_getList(0);
}

class ActivityGuidanceBar extends $pb.GeneratedMessage {
  factory ActivityGuidanceBar({
    $core.String? winId,
    $core.bool? login,
    $core.String? showTime,
    $core.String? action,
    $core.String? url,
    $core.String? closeType,
    ImagesWidget? images,
    TextWidget? title,
    TextWidget? subTitle,
    ButtonWidget? button,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
  }) {
    final result = ActivityGuidanceBar._();
    if (winId != null) result.winId = winId;
    if (login != null) result.login = login;
    if (showTime != null) result.showTime = showTime;
    if (action != null) result.action = action;
    if (url != null) result.url = url;
    if (closeType != null) result.closeType = closeType;
    if (images != null) result.images = images;
    if (title != null) result.title = title;
    if (subTitle != null) result.subTitle = subTitle;
    if (button != null) result.button = button;
    if (report != null) result.report.addEntries(report);
    return result;
  }

  ActivityGuidanceBar._();

  factory ActivityGuidanceBar.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActivityGuidanceBar()..mergeFromBuffer(data, registry);
  factory ActivityGuidanceBar.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActivityGuidanceBar()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActivityGuidanceBar',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ActivityGuidanceBar.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'winId')
    ..aOB(2, _omitFieldNames ? '' : 'login')
    ..aOS(3, _omitFieldNames ? '' : 'showTime')
    ..aOS(4, _omitFieldNames ? '' : 'action')
    ..aOS(5, _omitFieldNames ? '' : 'url')
    ..aOS(6, _omitFieldNames ? '' : 'closeType')
    ..aOM<ImagesWidget>(7, _omitFieldNames ? '' : 'images',
        subBuilder: ImagesWidget.$_createMessage)
    ..aOM<TextWidget>(8, _omitFieldNames ? '' : 'title',
        subBuilder: TextWidget.$_createMessage)
    ..aOM<TextWidget>(9, _omitFieldNames ? '' : 'subTitle',
        subBuilder: TextWidget.$_createMessage)
    ..aOM<ButtonWidget>(10, _omitFieldNames ? '' : 'button',
        subBuilder: ButtonWidget.$_createMessage)
    ..m<$core.String, $core.String>(11, _omitFieldNames ? '' : 'report',
        entryClassName: 'ActivityGuidanceBar.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivityGuidanceBar clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivityGuidanceBar copyWith(void Function(ActivityGuidanceBar) updates) =>
      super.copyWith((message) => updates(message as ActivityGuidanceBar))
          as ActivityGuidanceBar;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ActivityGuidanceBar() / ActivityGuidanceBar.new instead')
  static ActivityGuidanceBar create() => ActivityGuidanceBar._();
  static $pb.GeneratedMessage $_createMessage() => ActivityGuidanceBar._();
  @$core.override
  ActivityGuidanceBar createEmptyInstance() => ActivityGuidanceBar._();
  @$core.pragma('dart2js:noInline')
  static ActivityGuidanceBar getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ActivityGuidanceBar>(
          ActivityGuidanceBar.$_createMessage);
  static ActivityGuidanceBar? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get winId => $_getSZ(0);
  @$pb.TagNumber(1)
  set winId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWinId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWinId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get login => $_getBF(1);
  @$pb.TagNumber(2)
  set login($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLogin() => $_has(1);
  @$pb.TagNumber(2)
  void clearLogin() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get showTime => $_getSZ(2);
  @$pb.TagNumber(3)
  set showTime($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasShowTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearShowTime() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get action => $_getSZ(3);
  @$pb.TagNumber(4)
  set action($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAction() => $_has(3);
  @$pb.TagNumber(4)
  void clearAction() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get url => $_getSZ(4);
  @$pb.TagNumber(5)
  set url($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get closeType => $_getSZ(5);
  @$pb.TagNumber(6)
  set closeType($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCloseType() => $_has(5);
  @$pb.TagNumber(6)
  void clearCloseType() => $_clearField(6);

  @$pb.TagNumber(7)
  ImagesWidget get images => $_getN(6);
  @$pb.TagNumber(7)
  set images(ImagesWidget value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasImages() => $_has(6);
  @$pb.TagNumber(7)
  void clearImages() => $_clearField(7);
  @$pb.TagNumber(7)
  ImagesWidget ensureImages() => $_ensure(6);

  @$pb.TagNumber(8)
  TextWidget get title => $_getN(7);
  @$pb.TagNumber(8)
  set title(TextWidget value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasTitle() => $_has(7);
  @$pb.TagNumber(8)
  void clearTitle() => $_clearField(8);
  @$pb.TagNumber(8)
  TextWidget ensureTitle() => $_ensure(7);

  @$pb.TagNumber(9)
  TextWidget get subTitle => $_getN(8);
  @$pb.TagNumber(9)
  set subTitle(TextWidget value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSubTitle() => $_has(8);
  @$pb.TagNumber(9)
  void clearSubTitle() => $_clearField(9);
  @$pb.TagNumber(9)
  TextWidget ensureSubTitle() => $_ensure(8);

  @$pb.TagNumber(10)
  ButtonWidget get button => $_getN(9);
  @$pb.TagNumber(10)
  set button(ButtonWidget value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasButton() => $_has(9);
  @$pb.TagNumber(10)
  void clearButton() => $_clearField(10);
  @$pb.TagNumber(10)
  ButtonWidget ensureButton() => $_ensure(9);

  @$pb.TagNumber(11)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(10);
}

class ActivityIFrame extends $pb.GeneratedMessage {
  factory ActivityIFrame({
    $core.String? url,
    $core.double? aspectRatio,
  }) {
    final result = ActivityIFrame._();
    if (url != null) result.url = url;
    if (aspectRatio != null) result.aspectRatio = aspectRatio;
    return result;
  }

  ActivityIFrame._();

  factory ActivityIFrame.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActivityIFrame()..mergeFromBuffer(data, registry);
  factory ActivityIFrame.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActivityIFrame()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActivityIFrame',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ActivityIFrame.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aD(2, _omitFieldNames ? '' : 'aspectRatio')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivityIFrame clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivityIFrame copyWith(void Function(ActivityIFrame) updates) =>
      super.copyWith((message) => updates(message as ActivityIFrame))
          as ActivityIFrame;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ActivityIFrame() / ActivityIFrame.new instead')
  static ActivityIFrame create() => ActivityIFrame._();
  static $pb.GeneratedMessage $_createMessage() => ActivityIFrame._();
  @$core.override
  ActivityIFrame createEmptyInstance() => ActivityIFrame._();
  @$core.pragma('dart2js:noInline')
  static ActivityIFrame getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActivityIFrame>(
          ActivityIFrame.$_createMessage);
  static ActivityIFrame? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get aspectRatio => $_getN(1);
  @$pb.TagNumber(2)
  set aspectRatio($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAspectRatio() => $_has(1);
  @$pb.TagNumber(2)
  void clearAspectRatio() => $_clearField(2);
}

class ActivityReserve extends $pb.GeneratedMessage {
  factory ActivityReserve({
    $core.String? title,
    StatInfo? vt,
    StatInfo? danmaku,
    ReserveButton? button,
  }) {
    final result = ActivityReserve._();
    if (title != null) result.title = title;
    if (vt != null) result.vt = vt;
    if (danmaku != null) result.danmaku = danmaku;
    if (button != null) result.button = button;
    return result;
  }

  ActivityReserve._();

  factory ActivityReserve.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActivityReserve()..mergeFromBuffer(data, registry);
  factory ActivityReserve.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActivityReserve()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActivityReserve',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ActivityReserve.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOM<StatInfo>(2, _omitFieldNames ? '' : 'vt',
        subBuilder: StatInfo.$_createMessage)
    ..aOM<StatInfo>(3, _omitFieldNames ? '' : 'danmaku',
        subBuilder: StatInfo.$_createMessage)
    ..aOM<ReserveButton>(4, _omitFieldNames ? '' : 'button',
        subBuilder: ReserveButton.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivityReserve clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivityReserve copyWith(void Function(ActivityReserve) updates) =>
      super.copyWith((message) => updates(message as ActivityReserve))
          as ActivityReserve;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ActivityReserve() / ActivityReserve.new instead')
  static ActivityReserve create() => ActivityReserve._();
  static $pb.GeneratedMessage $_createMessage() => ActivityReserve._();
  @$core.override
  ActivityReserve createEmptyInstance() => ActivityReserve._();
  @$core.pragma('dart2js:noInline')
  static ActivityReserve getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActivityReserve>(
          ActivityReserve.$_createMessage);
  static ActivityReserve? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  StatInfo get vt => $_getN(1);
  @$pb.TagNumber(2)
  set vt(StatInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasVt() => $_has(1);
  @$pb.TagNumber(2)
  void clearVt() => $_clearField(2);
  @$pb.TagNumber(2)
  StatInfo ensureVt() => $_ensure(1);

  @$pb.TagNumber(3)
  StatInfo get danmaku => $_getN(2);
  @$pb.TagNumber(3)
  set danmaku(StatInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDanmaku() => $_has(2);
  @$pb.TagNumber(3)
  void clearDanmaku() => $_clearField(3);
  @$pb.TagNumber(3)
  StatInfo ensureDanmaku() => $_ensure(2);

  @$pb.TagNumber(4)
  ReserveButton get button => $_getN(3);
  @$pb.TagNumber(4)
  set button(ReserveButton value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasButton() => $_has(3);
  @$pb.TagNumber(4)
  void clearButton() => $_clearField(4);
  @$pb.TagNumber(4)
  ReserveButton ensureButton() => $_ensure(3);
}

class ActivityResource extends $pb.GeneratedMessage {
  factory ActivityResource({
    $core.String? modPoolName,
    $core.String? modResourceName,
  }) {
    final result = ActivityResource._();
    if (modPoolName != null) result.modPoolName = modPoolName;
    if (modResourceName != null) result.modResourceName = modResourceName;
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
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ActivityResource.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'modPoolName')
    ..aOS(2, _omitFieldNames ? '' : 'modResourceName')
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
  $core.String get modPoolName => $_getSZ(0);
  @$pb.TagNumber(1)
  set modPoolName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasModPoolName() => $_has(0);
  @$pb.TagNumber(1)
  void clearModPoolName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get modResourceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set modResourceName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasModResourceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearModResourceName() => $_clearField(2);
}

class ActivityStarRail extends $pb.GeneratedMessage {
  factory ActivityStarRail({
    $core.String? pic,
    $core.Iterable<StarRail>? picGallery,
  }) {
    final result = ActivityStarRail._();
    if (pic != null) result.pic = pic;
    if (picGallery != null) result.picGallery.addAll(picGallery);
    return result;
  }

  ActivityStarRail._();

  factory ActivityStarRail.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActivityStarRail()..mergeFromBuffer(data, registry);
  factory ActivityStarRail.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActivityStarRail()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActivityStarRail',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ActivityStarRail.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'pic')
    ..pPM<StarRail>(2, _omitFieldNames ? '' : 'picGallery',
        subBuilder: StarRail.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivityStarRail clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivityStarRail copyWith(void Function(ActivityStarRail) updates) =>
      super.copyWith((message) => updates(message as ActivityStarRail))
          as ActivityStarRail;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ActivityStarRail() / ActivityStarRail.new instead')
  static ActivityStarRail create() => ActivityStarRail._();
  static $pb.GeneratedMessage $_createMessage() => ActivityStarRail._();
  @$core.override
  ActivityStarRail createEmptyInstance() => ActivityStarRail._();
  @$core.pragma('dart2js:noInline')
  static ActivityStarRail getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActivityStarRail>(
          ActivityStarRail.$_createMessage);
  static ActivityStarRail? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pic => $_getSZ(0);
  @$pb.TagNumber(1)
  set pic($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPic() => $_has(0);
  @$pb.TagNumber(1)
  void clearPic() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<StarRail> get picGallery => $_getList(1);
}

class ActivityTab extends $pb.GeneratedMessage {
  factory ActivityTab({
    $core.int? id,
    $core.String? title,
    $core.int? type,
    $core.String? showName,
    $core.String? picurl,
    $core.String? picurlSelected,
    $core.String? h5Link,
    $core.String? link,
    $core.int? linkType,
    $fixnum.Int64? bizKey,
    $core.String? desc,
    $core.String? actExt,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
  }) {
    final result = ActivityTab._();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (type != null) result.type = type;
    if (showName != null) result.showName = showName;
    if (picurl != null) result.picurl = picurl;
    if (picurlSelected != null) result.picurlSelected = picurlSelected;
    if (h5Link != null) result.h5Link = h5Link;
    if (link != null) result.link = link;
    if (linkType != null) result.linkType = linkType;
    if (bizKey != null) result.bizKey = bizKey;
    if (desc != null) result.desc = desc;
    if (actExt != null) result.actExt = actExt;
    if (report != null) result.report.addEntries(report);
    return result;
  }

  ActivityTab._();

  factory ActivityTab.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActivityTab()..mergeFromBuffer(data, registry);
  factory ActivityTab.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActivityTab()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActivityTab',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ActivityTab.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aI(3, _omitFieldNames ? '' : 'type')
    ..aOS(4, _omitFieldNames ? '' : 'showName')
    ..aOS(5, _omitFieldNames ? '' : 'picurl')
    ..aOS(6, _omitFieldNames ? '' : 'picurlSelected')
    ..aOS(7, _omitFieldNames ? '' : 'h5Link')
    ..aOS(8, _omitFieldNames ? '' : 'link')
    ..aI(9, _omitFieldNames ? '' : 'linkType')
    ..aInt64(10, _omitFieldNames ? '' : 'bizKey')
    ..aOS(11, _omitFieldNames ? '' : 'desc')
    ..aOS(12, _omitFieldNames ? '' : 'actExt')
    ..m<$core.String, $core.String>(13, _omitFieldNames ? '' : 'report',
        entryClassName: 'ActivityTab.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivityTab clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActivityTab copyWith(void Function(ActivityTab) updates) =>
      super.copyWith((message) => updates(message as ActivityTab))
          as ActivityTab;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ActivityTab() / ActivityTab.new instead')
  static ActivityTab create() => ActivityTab._();
  static $pb.GeneratedMessage $_createMessage() => ActivityTab._();
  @$core.override
  ActivityTab createEmptyInstance() => ActivityTab._();
  @$core.pragma('dart2js:noInline')
  static ActivityTab getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActivityTab>(
          ActivityTab.$_createMessage);
  static ActivityTab? _defaultInstance;

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
  $core.String get showName => $_getSZ(3);
  @$pb.TagNumber(4)
  set showName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasShowName() => $_has(3);
  @$pb.TagNumber(4)
  void clearShowName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get picurl => $_getSZ(4);
  @$pb.TagNumber(5)
  set picurl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPicurl() => $_has(4);
  @$pb.TagNumber(5)
  void clearPicurl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get picurlSelected => $_getSZ(5);
  @$pb.TagNumber(6)
  set picurlSelected($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPicurlSelected() => $_has(5);
  @$pb.TagNumber(6)
  void clearPicurlSelected() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get h5Link => $_getSZ(6);
  @$pb.TagNumber(7)
  set h5Link($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasH5Link() => $_has(6);
  @$pb.TagNumber(7)
  void clearH5Link() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get link => $_getSZ(7);
  @$pb.TagNumber(8)
  set link($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLink() => $_has(7);
  @$pb.TagNumber(8)
  void clearLink() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get linkType => $_getIZ(8);
  @$pb.TagNumber(9)
  set linkType($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLinkType() => $_has(8);
  @$pb.TagNumber(9)
  void clearLinkType() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get bizKey => $_getI64(9);
  @$pb.TagNumber(10)
  set bizKey($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasBizKey() => $_has(9);
  @$pb.TagNumber(10)
  void clearBizKey() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get desc => $_getSZ(10);
  @$pb.TagNumber(11)
  set desc($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDesc() => $_has(10);
  @$pb.TagNumber(11)
  void clearDesc() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get actExt => $_getSZ(11);
  @$pb.TagNumber(12)
  set actExt($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasActExt() => $_has(11);
  @$pb.TagNumber(12)
  void clearActExt() => $_clearField(12);

  @$pb.TagNumber(13)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(12);
}

class AggEpCard extends $pb.GeneratedMessage {
  factory AggEpCard({
    $core.String? title,
    $core.String? cover,
    $core.String? icon,
    $core.int? num,
    $core.String? jumpUrl,
  }) {
    final result = AggEpCard._();
    if (title != null) result.title = title;
    if (cover != null) result.cover = cover;
    if (icon != null) result.icon = icon;
    if (num != null) result.num = num;
    if (jumpUrl != null) result.jumpUrl = jumpUrl;
    return result;
  }

  AggEpCard._();

  factory AggEpCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AggEpCard()..mergeFromBuffer(data, registry);
  factory AggEpCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AggEpCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AggEpCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: AggEpCard.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'cover')
    ..aOS(3, _omitFieldNames ? '' : 'icon')
    ..aI(4, _omitFieldNames ? '' : 'num')
    ..aOS(5, _omitFieldNames ? '' : 'jumpUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AggEpCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AggEpCard copyWith(void Function(AggEpCard) updates) =>
      super.copyWith((message) => updates(message as AggEpCard)) as AggEpCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AggEpCard() / AggEpCard.new instead')
  static AggEpCard create() => AggEpCard._();
  static $pb.GeneratedMessage $_createMessage() => AggEpCard._();
  @$core.override
  AggEpCard createEmptyInstance() => AggEpCard._();
  @$core.pragma('dart2js:noInline')
  static AggEpCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AggEpCard>(AggEpCard.$_createMessage);
  static AggEpCard? _defaultInstance;

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
  $core.String get icon => $_getSZ(2);
  @$pb.TagNumber(3)
  set icon($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearIcon() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get num => $_getIZ(3);
  @$pb.TagNumber(4)
  set num($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNum() => $_has(3);
  @$pb.TagNumber(4)
  void clearNum() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get jumpUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set jumpUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasJumpUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearJumpUrl() => $_clearField(5);
}

class AggEps extends $pb.GeneratedMessage {
  factory AggEps({
    $core.Iterable<AggEpCard>? aggEpCards,
    $core.int? placeIndex,
  }) {
    final result = AggEps._();
    if (aggEpCards != null) result.aggEpCards.addAll(aggEpCards);
    if (placeIndex != null) result.placeIndex = placeIndex;
    return result;
  }

  AggEps._();

  factory AggEps.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AggEps()..mergeFromBuffer(data, registry);
  factory AggEps.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AggEps()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AggEps',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: AggEps.$_createMessage)
    ..pPM<AggEpCard>(1, _omitFieldNames ? '' : 'aggEpCards',
        subBuilder: AggEpCard.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'placeIndex')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AggEps clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AggEps copyWith(void Function(AggEps) updates) =>
      super.copyWith((message) => updates(message as AggEps)) as AggEps;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AggEps() / AggEps.new instead')
  static AggEps create() => AggEps._();
  static $pb.GeneratedMessage $_createMessage() => AggEps._();
  @$core.override
  AggEps createEmptyInstance() => AggEps._();
  @$core.pragma('dart2js:noInline')
  static AggEps getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AggEps>(AggEps.$_createMessage);
  static AggEps? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AggEpCard> get aggEpCards => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get placeIndex => $_getIZ(1);
  @$pb.TagNumber(2)
  set placeIndex($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlaceIndex() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaceIndex() => $_clearField(2);
}

class ArcRights extends $pb.GeneratedMessage {
  factory ArcRights({
    $core.bool? isChargingPay,
  }) {
    final result = ArcRights._();
    if (isChargingPay != null) result.isChargingPay = isChargingPay;
    return result;
  }

  ArcRights._();

  factory ArcRights.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArcRights()..mergeFromBuffer(data, registry);
  factory ArcRights.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArcRights()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArcRights',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ArcRights.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'isChargingPay')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArcRights clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArcRights copyWith(void Function(ArcRights) updates) =>
      super.copyWith((message) => updates(message as ArcRights)) as ArcRights;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ArcRights() / ArcRights.new instead')
  static ArcRights create() => ArcRights._();
  static $pb.GeneratedMessage $_createMessage() => ArcRights._();
  @$core.override
  ArcRights createEmptyInstance() => ArcRights._();
  @$core.pragma('dart2js:noInline')
  static ArcRights getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ArcRights>(ArcRights.$_createMessage);
  static ArcRights? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isChargingPay => $_getBF(0);
  @$pb.TagNumber(1)
  set isChargingPay($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsChargingPay() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsChargingPay() => $_clearField(1);
}

class AttentionRecommend extends $pb.GeneratedMessage {
  factory AttentionRecommend() => AttentionRecommend._();

  AttentionRecommend._();

  factory AttentionRecommend.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AttentionRecommend()..mergeFromBuffer(data, registry);
  factory AttentionRecommend.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AttentionRecommend()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AttentionRecommend',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: AttentionRecommend.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttentionRecommend clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttentionRecommend copyWith(void Function(AttentionRecommend) updates) =>
      super.copyWith((message) => updates(message as AttentionRecommend))
          as AttentionRecommend;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AttentionRecommend() / AttentionRecommend.new instead')
  static AttentionRecommend create() => AttentionRecommend._();
  static $pb.GeneratedMessage $_createMessage() => AttentionRecommend._();
  @$core.override
  AttentionRecommend createEmptyInstance() => AttentionRecommend._();
  @$core.pragma('dart2js:noInline')
  static AttentionRecommend getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AttentionRecommend>(
          AttentionRecommend.$_createMessage);
  static AttentionRecommend? _defaultInstance;
}

class Audio extends $pb.GeneratedMessage {
  factory Audio({
    $core.Iterable<$core.MapEntry<$fixnum.Int64, AudioInfo>>? audioInfo,
  }) {
    final result = Audio._();
    if (audioInfo != null) result.audioInfo.addEntries(audioInfo);
    return result;
  }

  Audio._();

  factory Audio.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Audio()..mergeFromBuffer(data, registry);
  factory Audio.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Audio()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Audio',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Audio.$_createMessage)
    ..m<$fixnum.Int64, AudioInfo>(1, _omitFieldNames ? '' : 'audioInfo',
        entryClassName: 'Audio.AudioInfoEntry',
        keyFieldType: $pb.PbFieldType.O6,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: AudioInfo.$_createMessage,
        valueDefaultOrMaker: AudioInfo.getDefault,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Audio clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Audio copyWith(void Function(Audio) updates) =>
      super.copyWith((message) => updates(message as Audio)) as Audio;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Audio() / Audio.new instead')
  static Audio create() => Audio._();
  static $pb.GeneratedMessage $_createMessage() => Audio._();
  @$core.override
  Audio createEmptyInstance() => Audio._();
  @$core.pragma('dart2js:noInline')
  static Audio getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Audio>(Audio.$_createMessage);
  static Audio? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$fixnum.Int64, AudioInfo> get audioInfo => $_getMap(0);
}

class AudioInfo extends $pb.GeneratedMessage {
  factory AudioInfo({
    $core.String? title,
    $core.String? coverUrl,
    $fixnum.Int64? songId,
    $fixnum.Int64? playCount,
    $fixnum.Int64? replyCount,
    $fixnum.Int64? upperId,
    $core.String? entrance,
    $fixnum.Int64? songAttr,
  }) {
    final result = AudioInfo._();
    if (title != null) result.title = title;
    if (coverUrl != null) result.coverUrl = coverUrl;
    if (songId != null) result.songId = songId;
    if (playCount != null) result.playCount = playCount;
    if (replyCount != null) result.replyCount = replyCount;
    if (upperId != null) result.upperId = upperId;
    if (entrance != null) result.entrance = entrance;
    if (songAttr != null) result.songAttr = songAttr;
    return result;
  }

  AudioInfo._();

  factory AudioInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AudioInfo()..mergeFromBuffer(data, registry);
  factory AudioInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AudioInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AudioInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: AudioInfo.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'coverUrl')
    ..aInt64(3, _omitFieldNames ? '' : 'songId')
    ..aInt64(4, _omitFieldNames ? '' : 'playCount')
    ..aInt64(5, _omitFieldNames ? '' : 'replyCount')
    ..aInt64(6, _omitFieldNames ? '' : 'upperId')
    ..aOS(7, _omitFieldNames ? '' : 'entrance')
    ..aInt64(8, _omitFieldNames ? '' : 'songAttr')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AudioInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AudioInfo copyWith(void Function(AudioInfo) updates) =>
      super.copyWith((message) => updates(message as AudioInfo)) as AudioInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AudioInfo() / AudioInfo.new instead')
  static AudioInfo create() => AudioInfo._();
  static $pb.GeneratedMessage $_createMessage() => AudioInfo._();
  @$core.override
  AudioInfo createEmptyInstance() => AudioInfo._();
  @$core.pragma('dart2js:noInline')
  static AudioInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AudioInfo>(AudioInfo.$_createMessage);
  static AudioInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get coverUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set coverUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCoverUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoverUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get songId => $_getI64(2);
  @$pb.TagNumber(3)
  set songId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSongId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSongId() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get playCount => $_getI64(3);
  @$pb.TagNumber(4)
  set playCount($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPlayCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlayCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get replyCount => $_getI64(4);
  @$pb.TagNumber(5)
  set replyCount($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReplyCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearReplyCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get upperId => $_getI64(5);
  @$pb.TagNumber(6)
  set upperId($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUpperId() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpperId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get entrance => $_getSZ(6);
  @$pb.TagNumber(7)
  set entrance($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEntrance() => $_has(6);
  @$pb.TagNumber(7)
  void clearEntrance() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get songAttr => $_getI64(7);
  @$pb.TagNumber(8)
  set songAttr($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSongAttr() => $_has(7);
  @$pb.TagNumber(8)
  void clearSongAttr() => $_clearField(8);
}

class Author extends $pb.GeneratedMessage {
  factory Author({
    $fixnum.Int64? mid,
    $core.String? name,
  }) {
    final result = Author._();
    if (mid != null) result.mid = mid;
    if (name != null) result.name = name;
    return result;
  }

  Author._();

  factory Author.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Author()..mergeFromBuffer(data, registry);
  factory Author.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Author()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Author',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Author.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Author clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Author copyWith(void Function(Author) updates) =>
      super.copyWith((message) => updates(message as Author)) as Author;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Author() / Author.new instead')
  static Author create() => Author._();
  static $pb.GeneratedMessage $_createMessage() => Author._();
  @$core.override
  Author createEmptyInstance() => Author._();
  @$core.pragma('dart2js:noInline')
  static Author getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Author>(Author.$_createMessage);
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
}

class BadgeInfo extends $pb.GeneratedMessage {
  factory BadgeInfo({
    $core.String? text,
    $core.String? textColor,
    $core.String? textColorNight,
    $core.String? bgColor,
    $core.String? bgColorNight,
    $core.String? borderColor,
    $core.String? borderColorNight,
    $core.int? bgStyle,
    $core.String? img,
    $core.int? type,
  }) {
    final result = BadgeInfo._();
    if (text != null) result.text = text;
    if (textColor != null) result.textColor = textColor;
    if (textColorNight != null) result.textColorNight = textColorNight;
    if (bgColor != null) result.bgColor = bgColor;
    if (bgColorNight != null) result.bgColorNight = bgColorNight;
    if (borderColor != null) result.borderColor = borderColor;
    if (borderColorNight != null) result.borderColorNight = borderColorNight;
    if (bgStyle != null) result.bgStyle = bgStyle;
    if (img != null) result.img = img;
    if (type != null) result.type = type;
    return result;
  }

  BadgeInfo._();

  factory BadgeInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BadgeInfo()..mergeFromBuffer(data, registry);
  factory BadgeInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BadgeInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BadgeInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: BadgeInfo.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'textColor')
    ..aOS(3, _omitFieldNames ? '' : 'textColorNight')
    ..aOS(4, _omitFieldNames ? '' : 'bgColor')
    ..aOS(5, _omitFieldNames ? '' : 'bgColorNight')
    ..aOS(6, _omitFieldNames ? '' : 'borderColor')
    ..aOS(7, _omitFieldNames ? '' : 'borderColorNight')
    ..aI(8, _omitFieldNames ? '' : 'bgStyle')
    ..aOS(9, _omitFieldNames ? '' : 'img')
    ..aI(10, _omitFieldNames ? '' : 'type')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BadgeInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BadgeInfo copyWith(void Function(BadgeInfo) updates) =>
      super.copyWith((message) => updates(message as BadgeInfo)) as BadgeInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BadgeInfo() / BadgeInfo.new instead')
  static BadgeInfo create() => BadgeInfo._();
  static $pb.GeneratedMessage $_createMessage() => BadgeInfo._();
  @$core.override
  BadgeInfo createEmptyInstance() => BadgeInfo._();
  @$core.pragma('dart2js:noInline')
  static BadgeInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BadgeInfo>(BadgeInfo.$_createMessage);
  static BadgeInfo? _defaultInstance;

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

  @$pb.TagNumber(9)
  $core.String get img => $_getSZ(8);
  @$pb.TagNumber(9)
  set img($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasImg() => $_has(8);
  @$pb.TagNumber(9)
  void clearImg() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get type => $_getIZ(9);
  @$pb.TagNumber(10)
  set type($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasType() => $_has(9);
  @$pb.TagNumber(10)
  void clearType() => $_clearField(10);
}

class Banner extends $pb.GeneratedMessage {
  factory Banner({
    $core.String? title,
    $core.Iterable<RelateItem>? relateItem,
  }) {
    final result = Banner._();
    if (title != null) result.title = title;
    if (relateItem != null) result.relateItem.addAll(relateItem);
    return result;
  }

  Banner._();

  factory Banner.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Banner()..mergeFromBuffer(data, registry);
  factory Banner.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Banner()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Banner',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Banner.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..pPM<RelateItem>(2, _omitFieldNames ? '' : 'relateItem',
        subBuilder: RelateItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Banner clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Banner copyWith(void Function(Banner) updates) =>
      super.copyWith((message) => updates(message as Banner)) as Banner;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Banner() / Banner.new instead')
  static Banner create() => Banner._();
  static $pb.GeneratedMessage $_createMessage() => Banner._();
  @$core.override
  Banner createEmptyInstance() => Banner._();
  @$core.pragma('dart2js:noInline')
  static Banner getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Banner>(Banner.$_createMessage);
  static Banner? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<RelateItem> get relateItem => $_getList(1);
}

class BgInfo extends $pb.GeneratedMessage {
  factory BgInfo({
    $core.String? lightShortBg,
    $core.String? darkShortBg,
    $core.String? lightLongBg,
    $core.String? darkLongBg,
  }) {
    final result = BgInfo._();
    if (lightShortBg != null) result.lightShortBg = lightShortBg;
    if (darkShortBg != null) result.darkShortBg = darkShortBg;
    if (lightLongBg != null) result.lightLongBg = lightLongBg;
    if (darkLongBg != null) result.darkLongBg = darkLongBg;
    return result;
  }

  BgInfo._();

  factory BgInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BgInfo()..mergeFromBuffer(data, registry);
  factory BgInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BgInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BgInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: BgInfo.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'lightShortBg')
    ..aOS(2, _omitFieldNames ? '' : 'darkShortBg')
    ..aOS(3, _omitFieldNames ? '' : 'lightLongBg')
    ..aOS(4, _omitFieldNames ? '' : 'darkLongBg')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BgInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BgInfo copyWith(void Function(BgInfo) updates) =>
      super.copyWith((message) => updates(message as BgInfo)) as BgInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BgInfo() / BgInfo.new instead')
  static BgInfo create() => BgInfo._();
  static $pb.GeneratedMessage $_createMessage() => BgInfo._();
  @$core.override
  BgInfo createEmptyInstance() => BgInfo._();
  @$core.pragma('dart2js:noInline')
  static BgInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BgInfo>(BgInfo.$_createMessage);
  static BgInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lightShortBg => $_getSZ(0);
  @$pb.TagNumber(1)
  set lightShortBg($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLightShortBg() => $_has(0);
  @$pb.TagNumber(1)
  void clearLightShortBg() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get darkShortBg => $_getSZ(1);
  @$pb.TagNumber(2)
  set darkShortBg($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDarkShortBg() => $_has(1);
  @$pb.TagNumber(2)
  void clearDarkShortBg() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get lightLongBg => $_getSZ(2);
  @$pb.TagNumber(3)
  set lightLongBg($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLightLongBg() => $_has(2);
  @$pb.TagNumber(3)
  void clearLightLongBg() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get darkLongBg => $_getSZ(3);
  @$pb.TagNumber(4)
  set darkLongBg($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDarkLongBg() => $_has(3);
  @$pb.TagNumber(4)
  void clearDarkLongBg() => $_clearField(4);
}

class BizFavParam extends $pb.GeneratedMessage {
  factory BizFavParam({
    $fixnum.Int64? seasonId,
  }) {
    final result = BizFavParam._();
    if (seasonId != null) result.seasonId = seasonId;
    return result;
  }

  BizFavParam._();

  factory BizFavParam.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BizFavParam()..mergeFromBuffer(data, registry);
  factory BizFavParam.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BizFavParam()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BizFavParam',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: BizFavParam.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'seasonId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BizFavParam clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BizFavParam copyWith(void Function(BizFavParam) updates) =>
      super.copyWith((message) => updates(message as BizFavParam))
          as BizFavParam;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BizFavParam() / BizFavParam.new instead')
  static BizFavParam create() => BizFavParam._();
  static $pb.GeneratedMessage $_createMessage() => BizFavParam._();
  @$core.override
  BizFavParam createEmptyInstance() => BizFavParam._();
  @$core.pragma('dart2js:noInline')
  static BizFavParam getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BizFavParam>(
          BizFavParam.$_createMessage);
  static BizFavParam? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get seasonId => $_getI64(0);
  @$pb.TagNumber(1)
  set seasonId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeasonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeasonId() => $_clearField(1);
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
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
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

class Button extends $pb.GeneratedMessage {
  factory Button({
    $core.String? title,
    $core.String? leftStrikethroughText,
    $core.String? type,
    $core.String? link,
    BadgeInfo? badgeInfo,
    $core.String? subTitle,
  }) {
    final result = Button._();
    if (title != null) result.title = title;
    if (leftStrikethroughText != null)
      result.leftStrikethroughText = leftStrikethroughText;
    if (type != null) result.type = type;
    if (link != null) result.link = link;
    if (badgeInfo != null) result.badgeInfo = badgeInfo;
    if (subTitle != null) result.subTitle = subTitle;
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
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Button.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'leftStrikethroughText')
    ..aOS(3, _omitFieldNames ? '' : 'type')
    ..aOS(4, _omitFieldNames ? '' : 'link')
    ..aOM<BadgeInfo>(5, _omitFieldNames ? '' : 'badgeInfo',
        subBuilder: BadgeInfo.$_createMessage)
    ..aOS(6, _omitFieldNames ? '' : 'subTitle')
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
  $core.String get leftStrikethroughText => $_getSZ(1);
  @$pb.TagNumber(2)
  set leftStrikethroughText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLeftStrikethroughText() => $_has(1);
  @$pb.TagNumber(2)
  void clearLeftStrikethroughText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get type => $_getSZ(2);
  @$pb.TagNumber(3)
  set type($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get link => $_getSZ(3);
  @$pb.TagNumber(4)
  set link($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLink() => $_has(3);
  @$pb.TagNumber(4)
  void clearLink() => $_clearField(4);

  @$pb.TagNumber(5)
  BadgeInfo get badgeInfo => $_getN(4);
  @$pb.TagNumber(5)
  set badgeInfo(BadgeInfo value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasBadgeInfo() => $_has(4);
  @$pb.TagNumber(5)
  void clearBadgeInfo() => $_clearField(5);
  @$pb.TagNumber(5)
  BadgeInfo ensureBadgeInfo() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get subTitle => $_getSZ(5);
  @$pb.TagNumber(6)
  set subTitle($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSubTitle() => $_has(5);
  @$pb.TagNumber(6)
  void clearSubTitle() => $_clearField(6);
}

class ButtonWidget extends $pb.GeneratedMessage {
  factory ButtonWidget({
    $core.String? code,
    TextWidget? text,
    $core.String? bgColor,
    $core.String? action,
    $core.String? link,
  }) {
    final result = ButtonWidget._();
    if (code != null) result.code = code;
    if (text != null) result.text = text;
    if (bgColor != null) result.bgColor = bgColor;
    if (action != null) result.action = action;
    if (link != null) result.link = link;
    return result;
  }

  ButtonWidget._();

  factory ButtonWidget.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ButtonWidget()..mergeFromBuffer(data, registry);
  factory ButtonWidget.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ButtonWidget()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ButtonWidget',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ButtonWidget.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOM<TextWidget>(2, _omitFieldNames ? '' : 'text',
        subBuilder: TextWidget.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'bgColor')
    ..aOS(4, _omitFieldNames ? '' : 'action')
    ..aOS(5, _omitFieldNames ? '' : 'link')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ButtonWidget clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ButtonWidget copyWith(void Function(ButtonWidget) updates) =>
      super.copyWith((message) => updates(message as ButtonWidget))
          as ButtonWidget;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ButtonWidget() / ButtonWidget.new instead')
  static ButtonWidget create() => ButtonWidget._();
  static $pb.GeneratedMessage $_createMessage() => ButtonWidget._();
  @$core.override
  ButtonWidget createEmptyInstance() => ButtonWidget._();
  @$core.pragma('dart2js:noInline')
  static ButtonWidget getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ButtonWidget>(
          ButtonWidget.$_createMessage);
  static ButtonWidget? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  TextWidget get text => $_getN(1);
  @$pb.TagNumber(2)
  set text(TextWidget value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);
  @$pb.TagNumber(2)
  TextWidget ensureText() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get bgColor => $_getSZ(2);
  @$pb.TagNumber(3)
  set bgColor($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBgColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearBgColor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get action => $_getSZ(3);
  @$pb.TagNumber(4)
  set action($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAction() => $_has(3);
  @$pb.TagNumber(4)
  void clearAction() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get link => $_getSZ(4);
  @$pb.TagNumber(5)
  set link($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLink() => $_has(4);
  @$pb.TagNumber(5)
  void clearLink() => $_clearField(5);
}

class CardBasicInfo extends $pb.GeneratedMessage {
  factory CardBasicInfo({
    $core.String? title,
    $core.String? desc,
    $core.String? cover,
    $core.String? uri,
    $core.String? trackId,
    $core.String? uniqueId,
    $fixnum.Int64? fromSourceType,
    $core.String? fromSourceId,
    $fixnum.Int64? materialId,
    $core.String? coverGif,
    Owner? author,
    $fixnum.Int64? id,
    $core.String? from,
    $core.String? fromSpmidSuffix,
    $core.String? reportFlowData,
    $core.String? coverRightText,
    CoverDimension? dimension,
  }) {
    final result = CardBasicInfo._();
    if (title != null) result.title = title;
    if (desc != null) result.desc = desc;
    if (cover != null) result.cover = cover;
    if (uri != null) result.uri = uri;
    if (trackId != null) result.trackId = trackId;
    if (uniqueId != null) result.uniqueId = uniqueId;
    if (fromSourceType != null) result.fromSourceType = fromSourceType;
    if (fromSourceId != null) result.fromSourceId = fromSourceId;
    if (materialId != null) result.materialId = materialId;
    if (coverGif != null) result.coverGif = coverGif;
    if (author != null) result.author = author;
    if (id != null) result.id = id;
    if (from != null) result.from = from;
    if (fromSpmidSuffix != null) result.fromSpmidSuffix = fromSpmidSuffix;
    if (reportFlowData != null) result.reportFlowData = reportFlowData;
    if (coverRightText != null) result.coverRightText = coverRightText;
    if (dimension != null) result.dimension = dimension;
    return result;
  }

  CardBasicInfo._();

  factory CardBasicInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CardBasicInfo()..mergeFromBuffer(data, registry);
  factory CardBasicInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CardBasicInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CardBasicInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: CardBasicInfo.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'desc')
    ..aOS(3, _omitFieldNames ? '' : 'cover')
    ..aOS(4, _omitFieldNames ? '' : 'uri')
    ..aOS(5, _omitFieldNames ? '' : 'trackId')
    ..aOS(6, _omitFieldNames ? '' : 'uniqueId')
    ..aInt64(7, _omitFieldNames ? '' : 'fromSourceType')
    ..aOS(8, _omitFieldNames ? '' : 'fromSourceId')
    ..aInt64(9, _omitFieldNames ? '' : 'materialId')
    ..aOS(10, _omitFieldNames ? '' : 'coverGif')
    ..aOM<Owner>(11, _omitFieldNames ? '' : 'author',
        subBuilder: Owner.$_createMessage)
    ..aInt64(12, _omitFieldNames ? '' : 'id')
    ..aOS(13, _omitFieldNames ? '' : 'from')
    ..aOS(14, _omitFieldNames ? '' : 'fromSpmidSuffix')
    ..aOS(15, _omitFieldNames ? '' : 'reportFlowData')
    ..aOS(16, _omitFieldNames ? '' : 'coverRightText')
    ..aOM<CoverDimension>(17, _omitFieldNames ? '' : 'dimension',
        subBuilder: CoverDimension.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardBasicInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardBasicInfo copyWith(void Function(CardBasicInfo) updates) =>
      super.copyWith((message) => updates(message as CardBasicInfo))
          as CardBasicInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CardBasicInfo() / CardBasicInfo.new instead')
  static CardBasicInfo create() => CardBasicInfo._();
  static $pb.GeneratedMessage $_createMessage() => CardBasicInfo._();
  @$core.override
  CardBasicInfo createEmptyInstance() => CardBasicInfo._();
  @$core.pragma('dart2js:noInline')
  static CardBasicInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CardBasicInfo>(
          CardBasicInfo.$_createMessage);
  static CardBasicInfo? _defaultInstance;

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
  $core.String get cover => $_getSZ(2);
  @$pb.TagNumber(3)
  set cover($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCover() => $_has(2);
  @$pb.TagNumber(3)
  void clearCover() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get uri => $_getSZ(3);
  @$pb.TagNumber(4)
  set uri($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUri() => $_has(3);
  @$pb.TagNumber(4)
  void clearUri() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get trackId => $_getSZ(4);
  @$pb.TagNumber(5)
  set trackId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTrackId() => $_has(4);
  @$pb.TagNumber(5)
  void clearTrackId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get uniqueId => $_getSZ(5);
  @$pb.TagNumber(6)
  set uniqueId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUniqueId() => $_has(5);
  @$pb.TagNumber(6)
  void clearUniqueId() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get fromSourceType => $_getI64(6);
  @$pb.TagNumber(7)
  set fromSourceType($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFromSourceType() => $_has(6);
  @$pb.TagNumber(7)
  void clearFromSourceType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get fromSourceId => $_getSZ(7);
  @$pb.TagNumber(8)
  set fromSourceId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFromSourceId() => $_has(7);
  @$pb.TagNumber(8)
  void clearFromSourceId() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get materialId => $_getI64(8);
  @$pb.TagNumber(9)
  set materialId($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMaterialId() => $_has(8);
  @$pb.TagNumber(9)
  void clearMaterialId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get coverGif => $_getSZ(9);
  @$pb.TagNumber(10)
  set coverGif($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCoverGif() => $_has(9);
  @$pb.TagNumber(10)
  void clearCoverGif() => $_clearField(10);

  @$pb.TagNumber(11)
  Owner get author => $_getN(10);
  @$pb.TagNumber(11)
  set author(Owner value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasAuthor() => $_has(10);
  @$pb.TagNumber(11)
  void clearAuthor() => $_clearField(11);
  @$pb.TagNumber(11)
  Owner ensureAuthor() => $_ensure(10);

  @$pb.TagNumber(12)
  $fixnum.Int64 get id => $_getI64(11);
  @$pb.TagNumber(12)
  set id($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasId() => $_has(11);
  @$pb.TagNumber(12)
  void clearId() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get from => $_getSZ(12);
  @$pb.TagNumber(13)
  set from($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasFrom() => $_has(12);
  @$pb.TagNumber(13)
  void clearFrom() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get fromSpmidSuffix => $_getSZ(13);
  @$pb.TagNumber(14)
  set fromSpmidSuffix($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasFromSpmidSuffix() => $_has(13);
  @$pb.TagNumber(14)
  void clearFromSpmidSuffix() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get reportFlowData => $_getSZ(14);
  @$pb.TagNumber(15)
  set reportFlowData($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasReportFlowData() => $_has(14);
  @$pb.TagNumber(15)
  void clearReportFlowData() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get coverRightText => $_getSZ(15);
  @$pb.TagNumber(16)
  set coverRightText($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasCoverRightText() => $_has(15);
  @$pb.TagNumber(16)
  void clearCoverRightText() => $_clearField(16);

  @$pb.TagNumber(17)
  CoverDimension get dimension => $_getN(16);
  @$pb.TagNumber(17)
  set dimension(CoverDimension value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasDimension() => $_has(16);
  @$pb.TagNumber(17)
  void clearDimension() => $_clearField(17);
  @$pb.TagNumber(17)
  CoverDimension ensureDimension() => $_ensure(16);
}

class CardStyle extends $pb.GeneratedMessage {
  factory CardStyle({
    $core.int? id,
    $core.String? name,
  }) {
    final result = CardStyle._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    return result;
  }

  CardStyle._();

  factory CardStyle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CardStyle()..mergeFromBuffer(data, registry);
  factory CardStyle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CardStyle()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CardStyle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: CardStyle.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardStyle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CardStyle copyWith(void Function(CardStyle) updates) =>
      super.copyWith((message) => updates(message as CardStyle)) as CardStyle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CardStyle() / CardStyle.new instead')
  static CardStyle create() => CardStyle._();
  static $pb.GeneratedMessage $_createMessage() => CardStyle._();
  @$core.override
  CardStyle createEmptyInstance() => CardStyle._();
  @$core.pragma('dart2js:noInline')
  static CardStyle getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CardStyle>(CardStyle.$_createMessage);
  static CardStyle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
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

class CatalogTab extends $pb.GeneratedMessage {
  factory CatalogTab({
    $core.String? title,
  }) {
    final result = CatalogTab._();
    if (title != null) result.title = title;
    return result;
  }

  CatalogTab._();

  factory CatalogTab.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CatalogTab()..mergeFromBuffer(data, registry);
  factory CatalogTab.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CatalogTab()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CatalogTab',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: CatalogTab.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CatalogTab clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CatalogTab copyWith(void Function(CatalogTab) updates) =>
      super.copyWith((message) => updates(message as CatalogTab)) as CatalogTab;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CatalogTab() / CatalogTab.new instead')
  static CatalogTab create() => CatalogTab._();
  static $pb.GeneratedMessage $_createMessage() => CatalogTab._();
  @$core.override
  CatalogTab createEmptyInstance() => CatalogTab._();
  @$core.pragma('dart2js:noInline')
  static CatalogTab getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CatalogTab>(CatalogTab.$_createMessage);
  static CatalogTab? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);
}

class Celebrity extends $pb.GeneratedMessage {
  factory Celebrity({
    $core.int? id,
    $core.String? name,
    $core.String? role,
    $core.String? avatar,
    $core.String? shortDesc,
    $core.String? desc,
    $core.String? characterAvatar,
    $core.String? link,
    $fixnum.Int64? mid,
    $core.int? isFollow,
    $core.String? occupationName,
    OccupationType? occupationType,
    $core.int? relateAttr,
    $core.String? smallAvatar,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
    OfficialVerify? official,
  }) {
    final result = Celebrity._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (role != null) result.role = role;
    if (avatar != null) result.avatar = avatar;
    if (shortDesc != null) result.shortDesc = shortDesc;
    if (desc != null) result.desc = desc;
    if (characterAvatar != null) result.characterAvatar = characterAvatar;
    if (link != null) result.link = link;
    if (mid != null) result.mid = mid;
    if (isFollow != null) result.isFollow = isFollow;
    if (occupationName != null) result.occupationName = occupationName;
    if (occupationType != null) result.occupationType = occupationType;
    if (relateAttr != null) result.relateAttr = relateAttr;
    if (smallAvatar != null) result.smallAvatar = smallAvatar;
    if (report != null) result.report.addEntries(report);
    if (official != null) result.official = official;
    return result;
  }

  Celebrity._();

  factory Celebrity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Celebrity()..mergeFromBuffer(data, registry);
  factory Celebrity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Celebrity()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Celebrity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Celebrity.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'role')
    ..aOS(4, _omitFieldNames ? '' : 'avatar')
    ..aOS(5, _omitFieldNames ? '' : 'shortDesc')
    ..aOS(6, _omitFieldNames ? '' : 'desc')
    ..aOS(7, _omitFieldNames ? '' : 'characterAvatar')
    ..aOS(8, _omitFieldNames ? '' : 'link')
    ..aInt64(9, _omitFieldNames ? '' : 'mid')
    ..aI(10, _omitFieldNames ? '' : 'isFollow')
    ..aOS(11, _omitFieldNames ? '' : 'occupationName')
    ..aE<OccupationType>(12, _omitFieldNames ? '' : 'occupationType',
        enumValues: OccupationType.values)
    ..aI(13, _omitFieldNames ? '' : 'relateAttr')
    ..aOS(14, _omitFieldNames ? '' : 'smallAvatar')
    ..m<$core.String, $core.String>(15, _omitFieldNames ? '' : 'report',
        entryClassName: 'Celebrity.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..aOM<OfficialVerify>(16, _omitFieldNames ? '' : 'official',
        subBuilder: OfficialVerify.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Celebrity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Celebrity copyWith(void Function(Celebrity) updates) =>
      super.copyWith((message) => updates(message as Celebrity)) as Celebrity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Celebrity() / Celebrity.new instead')
  static Celebrity create() => Celebrity._();
  static $pb.GeneratedMessage $_createMessage() => Celebrity._();
  @$core.override
  Celebrity createEmptyInstance() => Celebrity._();
  @$core.pragma('dart2js:noInline')
  static Celebrity getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Celebrity>(Celebrity.$_createMessage);
  static Celebrity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
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
  $core.String get role => $_getSZ(2);
  @$pb.TagNumber(3)
  set role($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get avatar => $_getSZ(3);
  @$pb.TagNumber(4)
  set avatar($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAvatar() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvatar() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get shortDesc => $_getSZ(4);
  @$pb.TagNumber(5)
  set shortDesc($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasShortDesc() => $_has(4);
  @$pb.TagNumber(5)
  void clearShortDesc() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get desc => $_getSZ(5);
  @$pb.TagNumber(6)
  set desc($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDesc() => $_has(5);
  @$pb.TagNumber(6)
  void clearDesc() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get characterAvatar => $_getSZ(6);
  @$pb.TagNumber(7)
  set characterAvatar($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCharacterAvatar() => $_has(6);
  @$pb.TagNumber(7)
  void clearCharacterAvatar() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get link => $_getSZ(7);
  @$pb.TagNumber(8)
  set link($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLink() => $_has(7);
  @$pb.TagNumber(8)
  void clearLink() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get mid => $_getI64(8);
  @$pb.TagNumber(9)
  set mid($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMid() => $_has(8);
  @$pb.TagNumber(9)
  void clearMid() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get isFollow => $_getIZ(9);
  @$pb.TagNumber(10)
  set isFollow($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIsFollow() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsFollow() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get occupationName => $_getSZ(10);
  @$pb.TagNumber(11)
  set occupationName($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOccupationName() => $_has(10);
  @$pb.TagNumber(11)
  void clearOccupationName() => $_clearField(11);

  @$pb.TagNumber(12)
  OccupationType get occupationType => $_getN(11);
  @$pb.TagNumber(12)
  set occupationType(OccupationType value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasOccupationType() => $_has(11);
  @$pb.TagNumber(12)
  void clearOccupationType() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get relateAttr => $_getIZ(12);
  @$pb.TagNumber(13)
  set relateAttr($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRelateAttr() => $_has(12);
  @$pb.TagNumber(13)
  void clearRelateAttr() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get smallAvatar => $_getSZ(13);
  @$pb.TagNumber(14)
  set smallAvatar($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasSmallAvatar() => $_has(13);
  @$pb.TagNumber(14)
  void clearSmallAvatar() => $_clearField(14);

  @$pb.TagNumber(15)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(14);

  @$pb.TagNumber(16)
  OfficialVerify get official => $_getN(15);
  @$pb.TagNumber(16)
  set official(OfficialVerify value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasOfficial() => $_has(15);
  @$pb.TagNumber(16)
  void clearOfficial() => $_clearField(16);
  @$pb.TagNumber(16)
  OfficialVerify ensureOfficial() => $_ensure(15);
}

class CellFluid extends $pb.GeneratedMessage {
  factory CellFluid({
    $core.String? topBaseColor,
    $core.String? topSplitColor,
    $core.String? topTextColor,
  }) {
    final result = CellFluid._();
    if (topBaseColor != null) result.topBaseColor = topBaseColor;
    if (topSplitColor != null) result.topSplitColor = topSplitColor;
    if (topTextColor != null) result.topTextColor = topTextColor;
    return result;
  }

  CellFluid._();

  factory CellFluid.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CellFluid()..mergeFromBuffer(data, registry);
  factory CellFluid.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CellFluid()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CellFluid',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: CellFluid.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'topBaseColor')
    ..aOS(2, _omitFieldNames ? '' : 'topSplitColor')
    ..aOS(3, _omitFieldNames ? '' : 'topTextColor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CellFluid clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CellFluid copyWith(void Function(CellFluid) updates) =>
      super.copyWith((message) => updates(message as CellFluid)) as CellFluid;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CellFluid() / CellFluid.new instead')
  static CellFluid create() => CellFluid._();
  static $pb.GeneratedMessage $_createMessage() => CellFluid._();
  @$core.override
  CellFluid createEmptyInstance() => CellFluid._();
  @$core.pragma('dart2js:noInline')
  static CellFluid getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CellFluid>(CellFluid.$_createMessage);
  static CellFluid? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get topBaseColor => $_getSZ(0);
  @$pb.TagNumber(1)
  set topBaseColor($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTopBaseColor() => $_has(0);
  @$pb.TagNumber(1)
  void clearTopBaseColor() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get topSplitColor => $_getSZ(1);
  @$pb.TagNumber(2)
  set topSplitColor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTopSplitColor() => $_has(1);
  @$pb.TagNumber(2)
  void clearTopSplitColor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get topTextColor => $_getSZ(2);
  @$pb.TagNumber(3)
  set topTextColor($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTopTextColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearTopTextColor() => $_clearField(3);
}

class CharacterGroup extends $pb.GeneratedMessage {
  factory CharacterGroup({
    $core.String? title,
    $core.Iterable<Celebrity>? characters,
  }) {
    final result = CharacterGroup._();
    if (title != null) result.title = title;
    if (characters != null) result.characters.addAll(characters);
    return result;
  }

  CharacterGroup._();

  factory CharacterGroup.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterGroup()..mergeFromBuffer(data, registry);
  factory CharacterGroup.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CharacterGroup()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CharacterGroup',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: CharacterGroup.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..pPM<Celebrity>(2, _omitFieldNames ? '' : 'characters',
        subBuilder: Celebrity.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterGroup clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacterGroup copyWith(void Function(CharacterGroup) updates) =>
      super.copyWith((message) => updates(message as CharacterGroup))
          as CharacterGroup;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CharacterGroup() / CharacterGroup.new instead')
  static CharacterGroup create() => CharacterGroup._();
  static $pb.GeneratedMessage $_createMessage() => CharacterGroup._();
  @$core.override
  CharacterGroup createEmptyInstance() => CharacterGroup._();
  @$core.pragma('dart2js:noInline')
  static CharacterGroup getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CharacterGroup>(
          CharacterGroup.$_createMessage);
  static CharacterGroup? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Celebrity> get characters => $_getList(1);
}

class Characters extends $pb.GeneratedMessage {
  factory Characters({
    $core.Iterable<CharacterGroup>? groups,
  }) {
    final result = Characters._();
    if (groups != null) result.groups.addAll(groups);
    return result;
  }

  Characters._();

  factory Characters.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Characters()..mergeFromBuffer(data, registry);
  factory Characters.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Characters()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Characters',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Characters.$_createMessage)
    ..pPM<CharacterGroup>(1, _omitFieldNames ? '' : 'groups',
        subBuilder: CharacterGroup.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Characters clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Characters copyWith(void Function(Characters) updates) =>
      super.copyWith((message) => updates(message as Characters)) as Characters;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Characters() / Characters.new instead')
  static Characters create() => Characters._();
  static $pb.GeneratedMessage $_createMessage() => Characters._();
  @$core.override
  Characters createEmptyInstance() => Characters._();
  @$core.pragma('dart2js:noInline')
  static Characters getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Characters>(Characters.$_createMessage);
  static Characters? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CharacterGroup> get groups => $_getList(0);
}

class CoinExtend extends $pb.GeneratedMessage {
  factory CoinExtend({
    $core.String? coinAppZipIcon,
    $core.String? coinAppIcon1,
    $core.String? coinAppIcon2,
    $core.String? coinAppIcon3,
    $core.String? coinAppIcon4,
  }) {
    final result = CoinExtend._();
    if (coinAppZipIcon != null) result.coinAppZipIcon = coinAppZipIcon;
    if (coinAppIcon1 != null) result.coinAppIcon1 = coinAppIcon1;
    if (coinAppIcon2 != null) result.coinAppIcon2 = coinAppIcon2;
    if (coinAppIcon3 != null) result.coinAppIcon3 = coinAppIcon3;
    if (coinAppIcon4 != null) result.coinAppIcon4 = coinAppIcon4;
    return result;
  }

  CoinExtend._();

  factory CoinExtend.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CoinExtend()..mergeFromBuffer(data, registry);
  factory CoinExtend.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CoinExtend()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CoinExtend',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: CoinExtend.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'coinAppZipIcon')
    ..aOS(2, _omitFieldNames ? '' : 'coinAppIcon1')
    ..aOS(3, _omitFieldNames ? '' : 'coinAppIcon2')
    ..aOS(4, _omitFieldNames ? '' : 'coinAppIcon3')
    ..aOS(5, _omitFieldNames ? '' : 'coinAppIcon4')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CoinExtend clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CoinExtend copyWith(void Function(CoinExtend) updates) =>
      super.copyWith((message) => updates(message as CoinExtend)) as CoinExtend;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CoinExtend() / CoinExtend.new instead')
  static CoinExtend create() => CoinExtend._();
  static $pb.GeneratedMessage $_createMessage() => CoinExtend._();
  @$core.override
  CoinExtend createEmptyInstance() => CoinExtend._();
  @$core.pragma('dart2js:noInline')
  static CoinExtend getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CoinExtend>(CoinExtend.$_createMessage);
  static CoinExtend? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get coinAppZipIcon => $_getSZ(0);
  @$pb.TagNumber(1)
  set coinAppZipIcon($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCoinAppZipIcon() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoinAppZipIcon() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get coinAppIcon1 => $_getSZ(1);
  @$pb.TagNumber(2)
  set coinAppIcon1($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCoinAppIcon1() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoinAppIcon1() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get coinAppIcon2 => $_getSZ(2);
  @$pb.TagNumber(3)
  set coinAppIcon2($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCoinAppIcon2() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoinAppIcon2() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get coinAppIcon3 => $_getSZ(3);
  @$pb.TagNumber(4)
  set coinAppIcon3($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCoinAppIcon3() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoinAppIcon3() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get coinAppIcon4 => $_getSZ(4);
  @$pb.TagNumber(5)
  set coinAppIcon4($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCoinAppIcon4() => $_has(4);
  @$pb.TagNumber(5)
  void clearCoinAppIcon4() => $_clearField(5);
}

class CombinationEp extends $pb.GeneratedMessage {
  factory CombinationEp({
    $core.int? id,
    $core.int? sectionId,
    $core.String? title,
    $core.int? canOrdDesc,
    $core.String? more,
    $core.Iterable<$core.int>? episodeIds,
    $core.Iterable<ViewEpisode>? episodes,
    $core.String? splitText,
    Style? moduleStyle,
    $core.Iterable<SerialSeason>? serialSeason,
    SectionData? sectionData,
  }) {
    final result = CombinationEp._();
    if (id != null) result.id = id;
    if (sectionId != null) result.sectionId = sectionId;
    if (title != null) result.title = title;
    if (canOrdDesc != null) result.canOrdDesc = canOrdDesc;
    if (more != null) result.more = more;
    if (episodeIds != null) result.episodeIds.addAll(episodeIds);
    if (episodes != null) result.episodes.addAll(episodes);
    if (splitText != null) result.splitText = splitText;
    if (moduleStyle != null) result.moduleStyle = moduleStyle;
    if (serialSeason != null) result.serialSeason.addAll(serialSeason);
    if (sectionData != null) result.sectionData = sectionData;
    return result;
  }

  CombinationEp._();

  factory CombinationEp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CombinationEp()..mergeFromBuffer(data, registry);
  factory CombinationEp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CombinationEp()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CombinationEp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: CombinationEp.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aI(2, _omitFieldNames ? '' : 'sectionId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aI(4, _omitFieldNames ? '' : 'canOrdDesc')
    ..aOS(5, _omitFieldNames ? '' : 'more')
    ..p<$core.int>(6, _omitFieldNames ? '' : 'episodeIds', $pb.PbFieldType.K3)
    ..pPM<ViewEpisode>(7, _omitFieldNames ? '' : 'episodes',
        subBuilder: ViewEpisode.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'splitText')
    ..aOM<Style>(9, _omitFieldNames ? '' : 'moduleStyle',
        subBuilder: Style.$_createMessage)
    ..pPM<SerialSeason>(10, _omitFieldNames ? '' : 'serialSeason',
        subBuilder: SerialSeason.$_createMessage)
    ..aOM<SectionData>(11, _omitFieldNames ? '' : 'sectionData',
        subBuilder: SectionData.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CombinationEp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CombinationEp copyWith(void Function(CombinationEp) updates) =>
      super.copyWith((message) => updates(message as CombinationEp))
          as CombinationEp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CombinationEp() / CombinationEp.new instead')
  static CombinationEp create() => CombinationEp._();
  static $pb.GeneratedMessage $_createMessage() => CombinationEp._();
  @$core.override
  CombinationEp createEmptyInstance() => CombinationEp._();
  @$core.pragma('dart2js:noInline')
  static CombinationEp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CombinationEp>(
          CombinationEp.$_createMessage);
  static CombinationEp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get sectionId => $_getIZ(1);
  @$pb.TagNumber(2)
  set sectionId($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSectionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSectionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get canOrdDesc => $_getIZ(3);
  @$pb.TagNumber(4)
  set canOrdDesc($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCanOrdDesc() => $_has(3);
  @$pb.TagNumber(4)
  void clearCanOrdDesc() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get more => $_getSZ(4);
  @$pb.TagNumber(5)
  set more($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMore() => $_has(4);
  @$pb.TagNumber(5)
  void clearMore() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.int> get episodeIds => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<ViewEpisode> get episodes => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get splitText => $_getSZ(7);
  @$pb.TagNumber(8)
  set splitText($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSplitText() => $_has(7);
  @$pb.TagNumber(8)
  void clearSplitText() => $_clearField(8);

  @$pb.TagNumber(9)
  Style get moduleStyle => $_getN(8);
  @$pb.TagNumber(9)
  set moduleStyle(Style value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasModuleStyle() => $_has(8);
  @$pb.TagNumber(9)
  void clearModuleStyle() => $_clearField(9);
  @$pb.TagNumber(9)
  Style ensureModuleStyle() => $_ensure(8);

  @$pb.TagNumber(10)
  $pb.PbList<SerialSeason> get serialSeason => $_getList(9);

  @$pb.TagNumber(11)
  SectionData get sectionData => $_getN(10);
  @$pb.TagNumber(11)
  set sectionData(SectionData value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasSectionData() => $_has(10);
  @$pb.TagNumber(11)
  void clearSectionData() => $_clearField(11);
  @$pb.TagNumber(11)
  SectionData ensureSectionData() => $_ensure(10);
}

class ContractText extends $pb.GeneratedMessage {
  factory ContractText({
    $core.String? title,
    $core.String? subtitle,
  }) {
    final result = ContractText._();
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
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
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ContractText.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'subtitle')
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
}

class Covenanter extends $pb.GeneratedMessage {
  factory Covenanter({
    $core.int? isFollowDisplay,
    ContractText? text,
    $core.int? isInteractDisplay,
  }) {
    final result = Covenanter._();
    if (isFollowDisplay != null) result.isFollowDisplay = isFollowDisplay;
    if (text != null) result.text = text;
    if (isInteractDisplay != null) result.isInteractDisplay = isInteractDisplay;
    return result;
  }

  Covenanter._();

  factory Covenanter.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Covenanter()..mergeFromBuffer(data, registry);
  factory Covenanter.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Covenanter()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Covenanter',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Covenanter.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'isFollowDisplay')
    ..aOM<ContractText>(2, _omitFieldNames ? '' : 'text',
        subBuilder: ContractText.$_createMessage)
    ..aI(3, _omitFieldNames ? '' : 'isInteractDisplay')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Covenanter clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Covenanter copyWith(void Function(Covenanter) updates) =>
      super.copyWith((message) => updates(message as Covenanter)) as Covenanter;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Covenanter() / Covenanter.new instead')
  static Covenanter create() => Covenanter._();
  static $pb.GeneratedMessage $_createMessage() => Covenanter._();
  @$core.override
  Covenanter createEmptyInstance() => Covenanter._();
  @$core.pragma('dart2js:noInline')
  static Covenanter getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Covenanter>(Covenanter.$_createMessage);
  static Covenanter? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get isFollowDisplay => $_getIZ(0);
  @$pb.TagNumber(1)
  set isFollowDisplay($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsFollowDisplay() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsFollowDisplay() => $_clearField(1);

  @$pb.TagNumber(2)
  ContractText get text => $_getN(1);
  @$pb.TagNumber(2)
  set text(ContractText value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);
  @$pb.TagNumber(2)
  ContractText ensureText() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get isInteractDisplay => $_getIZ(2);
  @$pb.TagNumber(3)
  set isInteractDisplay($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsInteractDisplay() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsInteractDisplay() => $_clearField(3);
}

class CoverDimension extends $pb.GeneratedMessage {
  factory CoverDimension({
    $core.double? width,
    $core.double? height,
  }) {
    final result = CoverDimension._();
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    return result;
  }

  CoverDimension._();

  factory CoverDimension.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CoverDimension()..mergeFromBuffer(data, registry);
  factory CoverDimension.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CoverDimension()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CoverDimension',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: CoverDimension.$_createMessage)
    ..aD(1, _omitFieldNames ? '' : 'width', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'height', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CoverDimension clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CoverDimension copyWith(void Function(CoverDimension) updates) =>
      super.copyWith((message) => updates(message as CoverDimension))
          as CoverDimension;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CoverDimension() / CoverDimension.new instead')
  static CoverDimension create() => CoverDimension._();
  static $pb.GeneratedMessage $_createMessage() => CoverDimension._();
  @$core.override
  CoverDimension createEmptyInstance() => CoverDimension._();
  @$core.pragma('dart2js:noInline')
  static CoverDimension getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CoverDimension>(
          CoverDimension.$_createMessage);
  static CoverDimension? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get width => $_getN(0);
  @$pb.TagNumber(1)
  set width($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get height => $_getN(1);
  @$pb.TagNumber(2)
  set height($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => $_clearField(2);
}

enum DeliveryData_Data {
  activity,
  characters,
  theatreHotTopic,
  aggEps,
  actPageItems,
  notSet
}

class DeliveryData extends $pb.GeneratedMessage {
  factory DeliveryData({
    $core.String? title,
    Style? moduleStyle,
    $core.String? more,
    Activity? activity,
    Characters? characters,
    TheatreHotTopic? theatreHotTopic,
    AggEps? aggEps,
    $core.int? id,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
    ActPageItems? actPageItems,
  }) {
    final result = DeliveryData._();
    if (title != null) result.title = title;
    if (moduleStyle != null) result.moduleStyle = moduleStyle;
    if (more != null) result.more = more;
    if (activity != null) result.activity = activity;
    if (characters != null) result.characters = characters;
    if (theatreHotTopic != null) result.theatreHotTopic = theatreHotTopic;
    if (aggEps != null) result.aggEps = aggEps;
    if (id != null) result.id = id;
    if (report != null) result.report.addEntries(report);
    if (actPageItems != null) result.actPageItems = actPageItems;
    return result;
  }

  DeliveryData._();

  factory DeliveryData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeliveryData()..mergeFromBuffer(data, registry);
  factory DeliveryData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeliveryData()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, DeliveryData_Data> _DeliveryData_DataByTag =
      {
    4: DeliveryData_Data.activity,
    5: DeliveryData_Data.characters,
    6: DeliveryData_Data.theatreHotTopic,
    7: DeliveryData_Data.aggEps,
    10: DeliveryData_Data.actPageItems,
    0: DeliveryData_Data.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeliveryData',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: DeliveryData.$_createMessage)
    ..oo(0, [4, 5, 6, 7, 10])
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOM<Style>(2, _omitFieldNames ? '' : 'moduleStyle',
        subBuilder: Style.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'more')
    ..aOM<Activity>(4, _omitFieldNames ? '' : 'activity',
        subBuilder: Activity.$_createMessage)
    ..aOM<Characters>(5, _omitFieldNames ? '' : 'characters',
        subBuilder: Characters.$_createMessage)
    ..aOM<TheatreHotTopic>(6, _omitFieldNames ? '' : 'theatreHotTopic',
        subBuilder: TheatreHotTopic.$_createMessage)
    ..aOM<AggEps>(7, _omitFieldNames ? '' : 'aggEps',
        subBuilder: AggEps.$_createMessage)
    ..aI(8, _omitFieldNames ? '' : 'id')
    ..m<$core.String, $core.String>(9, _omitFieldNames ? '' : 'report',
        entryClassName: 'DeliveryData.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..aOM<ActPageItems>(10, _omitFieldNames ? '' : 'actPageItems',
        subBuilder: ActPageItems.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeliveryData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeliveryData copyWith(void Function(DeliveryData) updates) =>
      super.copyWith((message) => updates(message as DeliveryData))
          as DeliveryData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DeliveryData() / DeliveryData.new instead')
  static DeliveryData create() => DeliveryData._();
  static $pb.GeneratedMessage $_createMessage() => DeliveryData._();
  @$core.override
  DeliveryData createEmptyInstance() => DeliveryData._();
  @$core.pragma('dart2js:noInline')
  static DeliveryData getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeliveryData>(
          DeliveryData.$_createMessage);
  static DeliveryData? _defaultInstance;

  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(10)
  DeliveryData_Data whichData() => _DeliveryData_DataByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(10)
  void clearData() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  Style get moduleStyle => $_getN(1);
  @$pb.TagNumber(2)
  set moduleStyle(Style value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasModuleStyle() => $_has(1);
  @$pb.TagNumber(2)
  void clearModuleStyle() => $_clearField(2);
  @$pb.TagNumber(2)
  Style ensureModuleStyle() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get more => $_getSZ(2);
  @$pb.TagNumber(3)
  set more($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMore() => $_has(2);
  @$pb.TagNumber(3)
  void clearMore() => $_clearField(3);

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
  Characters get characters => $_getN(4);
  @$pb.TagNumber(5)
  set characters(Characters value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCharacters() => $_has(4);
  @$pb.TagNumber(5)
  void clearCharacters() => $_clearField(5);
  @$pb.TagNumber(5)
  Characters ensureCharacters() => $_ensure(4);

  @$pb.TagNumber(6)
  TheatreHotTopic get theatreHotTopic => $_getN(5);
  @$pb.TagNumber(6)
  set theatreHotTopic(TheatreHotTopic value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasTheatreHotTopic() => $_has(5);
  @$pb.TagNumber(6)
  void clearTheatreHotTopic() => $_clearField(6);
  @$pb.TagNumber(6)
  TheatreHotTopic ensureTheatreHotTopic() => $_ensure(5);

  @$pb.TagNumber(7)
  AggEps get aggEps => $_getN(6);
  @$pb.TagNumber(7)
  set aggEps(AggEps value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAggEps() => $_has(6);
  @$pb.TagNumber(7)
  void clearAggEps() => $_clearField(7);
  @$pb.TagNumber(7)
  AggEps ensureAggEps() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.int get id => $_getIZ(7);
  @$pb.TagNumber(8)
  set id($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasId() => $_has(7);
  @$pb.TagNumber(8)
  void clearId() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(8);

  @$pb.TagNumber(10)
  ActPageItems get actPageItems => $_getN(9);
  @$pb.TagNumber(10)
  set actPageItems(ActPageItems value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasActPageItems() => $_has(9);
  @$pb.TagNumber(10)
  void clearActPageItems() => $_clearField(10);
  @$pb.TagNumber(10)
  ActPageItems ensureActPageItems() => $_ensure(9);
}

class Desc extends $pb.GeneratedMessage {
  factory Desc({
    $core.String? info,
    $core.String? title,
  }) {
    final result = Desc._();
    if (info != null) result.info = info;
    if (title != null) result.title = title;
    return result;
  }

  Desc._();

  factory Desc.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Desc()..mergeFromBuffer(data, registry);
  factory Desc.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Desc()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Desc',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Desc.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'info')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Desc clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Desc copyWith(void Function(Desc) updates) =>
      super.copyWith((message) => updates(message as Desc)) as Desc;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Desc() / Desc.new instead')
  static Desc create() => Desc._();
  static $pb.GeneratedMessage $_createMessage() => Desc._();
  @$core.override
  Desc createEmptyInstance() => Desc._();
  @$core.pragma('dart2js:noInline')
  static Desc getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Desc>(Desc.$_createMessage);
  static Desc? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get info => $_getSZ(0);
  @$pb.TagNumber(1)
  set info($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearInfo() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);
}

class DescV2 extends $pb.GeneratedMessage {
  factory DescV2({
    $core.String? text,
    DescType? type,
    $core.String? uri,
    $fixnum.Int64? rid,
  }) {
    final result = DescV2._();
    if (text != null) result.text = text;
    if (type != null) result.type = type;
    if (uri != null) result.uri = uri;
    if (rid != null) result.rid = rid;
    return result;
  }

  DescV2._();

  factory DescV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DescV2()..mergeFromBuffer(data, registry);
  factory DescV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DescV2()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DescV2',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: DescV2.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aE<DescType>(2, _omitFieldNames ? '' : 'type',
        enumValues: DescType.values)
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..aInt64(4, _omitFieldNames ? '' : 'rid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DescV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DescV2 copyWith(void Function(DescV2) updates) =>
      super.copyWith((message) => updates(message as DescV2)) as DescV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DescV2() / DescV2.new instead')
  static DescV2 create() => DescV2._();
  static $pb.GeneratedMessage $_createMessage() => DescV2._();
  @$core.override
  DescV2 createEmptyInstance() => DescV2._();
  @$core.pragma('dart2js:noInline')
  static DescV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DescV2>(DescV2.$_createMessage);
  static DescV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  DescType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(DescType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get rid => $_getI64(3);
  @$pb.TagNumber(4)
  set rid($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRid() => $_has(3);
  @$pb.TagNumber(4)
  void clearRid() => $_clearField(4);
}

class Dimension extends $pb.GeneratedMessage {
  factory Dimension({
    $fixnum.Int64? width,
    $fixnum.Int64? height,
    $fixnum.Int64? rotate,
  }) {
    final result = Dimension._();
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (rotate != null) result.rotate = rotate;
    return result;
  }

  Dimension._();

  factory Dimension.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Dimension()..mergeFromBuffer(data, registry);
  factory Dimension.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Dimension()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Dimension',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Dimension.$_createMessage)
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
  @$core.Deprecated('Use Dimension() / Dimension.new instead')
  static Dimension create() => Dimension._();
  static $pb.GeneratedMessage $_createMessage() => Dimension._();
  @$core.override
  Dimension createEmptyInstance() => Dimension._();
  @$core.pragma('dart2js:noInline')
  static Dimension getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Dimension>(Dimension.$_createMessage);
  static Dimension? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get width => $_getI64(0);
  @$pb.TagNumber(1)
  set width($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get height => $_getI64(1);
  @$pb.TagNumber(2)
  set height($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get rotate => $_getI64(2);
  @$pb.TagNumber(3)
  set rotate($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRotate() => $_has(2);
  @$pb.TagNumber(3)
  void clearRotate() => $_clearField(3);
}

class DislikeReasons extends $pb.GeneratedMessage {
  factory DislikeReasons({
    $fixnum.Int64? id,
    $fixnum.Int64? mid,
    $core.int? rid,
    $fixnum.Int64? tagId,
    $core.String? name,
  }) {
    final result = DislikeReasons._();
    if (id != null) result.id = id;
    if (mid != null) result.mid = mid;
    if (rid != null) result.rid = rid;
    if (tagId != null) result.tagId = tagId;
    if (name != null) result.name = name;
    return result;
  }

  DislikeReasons._();

  factory DislikeReasons.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DislikeReasons()..mergeFromBuffer(data, registry);
  factory DislikeReasons.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DislikeReasons()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DislikeReasons',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: DislikeReasons.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aInt64(2, _omitFieldNames ? '' : 'mid')
    ..aI(3, _omitFieldNames ? '' : 'rid')
    ..aInt64(4, _omitFieldNames ? '' : 'tagId')
    ..aOS(5, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DislikeReasons clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DislikeReasons copyWith(void Function(DislikeReasons) updates) =>
      super.copyWith((message) => updates(message as DislikeReasons))
          as DislikeReasons;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DislikeReasons() / DislikeReasons.new instead')
  static DislikeReasons create() => DislikeReasons._();
  static $pb.GeneratedMessage $_createMessage() => DislikeReasons._();
  @$core.override
  DislikeReasons createEmptyInstance() => DislikeReasons._();
  @$core.pragma('dart2js:noInline')
  static DislikeReasons getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DislikeReasons>(
          DislikeReasons.$_createMessage);
  static DislikeReasons? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get mid => $_getI64(1);
  @$pb.TagNumber(2)
  set mid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMid() => $_has(1);
  @$pb.TagNumber(2)
  void clearMid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get rid => $_getIZ(2);
  @$pb.TagNumber(3)
  set rid($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRid() => $_has(2);
  @$pb.TagNumber(3)
  void clearRid() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get tagId => $_getI64(3);
  @$pb.TagNumber(4)
  set tagId($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTagId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTagId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(4);
  @$pb.TagNumber(5)
  set name($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(4);
  @$pb.TagNumber(5)
  void clearName() => $_clearField(5);
}

class EpBgInfo extends $pb.GeneratedMessage {
  factory EpBgInfo({
    BgInfo? floatLayer,
    BgInfo? noFloatLayer,
  }) {
    final result = EpBgInfo._();
    if (floatLayer != null) result.floatLayer = floatLayer;
    if (noFloatLayer != null) result.noFloatLayer = noFloatLayer;
    return result;
  }

  EpBgInfo._();

  factory EpBgInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EpBgInfo()..mergeFromBuffer(data, registry);
  factory EpBgInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EpBgInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EpBgInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: EpBgInfo.$_createMessage)
    ..aOM<BgInfo>(1, _omitFieldNames ? '' : 'floatLayer',
        subBuilder: BgInfo.$_createMessage)
    ..aOM<BgInfo>(2, _omitFieldNames ? '' : 'noFloatLayer',
        subBuilder: BgInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EpBgInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EpBgInfo copyWith(void Function(EpBgInfo) updates) =>
      super.copyWith((message) => updates(message as EpBgInfo)) as EpBgInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use EpBgInfo() / EpBgInfo.new instead')
  static EpBgInfo create() => EpBgInfo._();
  static $pb.GeneratedMessage $_createMessage() => EpBgInfo._();
  @$core.override
  EpBgInfo createEmptyInstance() => EpBgInfo._();
  @$core.pragma('dart2js:noInline')
  static EpBgInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EpBgInfo>(EpBgInfo.$_createMessage);
  static EpBgInfo? _defaultInstance;

  @$pb.TagNumber(1)
  BgInfo get floatLayer => $_getN(0);
  @$pb.TagNumber(1)
  set floatLayer(BgInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFloatLayer() => $_has(0);
  @$pb.TagNumber(1)
  void clearFloatLayer() => $_clearField(1);
  @$pb.TagNumber(1)
  BgInfo ensureFloatLayer() => $_ensure(0);

  @$pb.TagNumber(2)
  BgInfo get noFloatLayer => $_getN(1);
  @$pb.TagNumber(2)
  set noFloatLayer(BgInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasNoFloatLayer() => $_has(1);
  @$pb.TagNumber(2)
  void clearNoFloatLayer() => $_clearField(2);
  @$pb.TagNumber(2)
  BgInfo ensureNoFloatLayer() => $_ensure(1);
}

class ExtTab extends $pb.GeneratedMessage {
  factory ExtTab({
    ExtType? extType,
    $core.String? data,
  }) {
    final result = ExtTab._();
    if (extType != null) result.extType = extType;
    if (data != null) result.data = data;
    return result;
  }

  ExtTab._();

  factory ExtTab.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtTab()..mergeFromBuffer(data, registry);
  factory ExtTab.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExtTab()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExtTab',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ExtTab.$_createMessage)
    ..aE<ExtType>(1, _omitFieldNames ? '' : 'extType',
        enumValues: ExtType.values)
    ..aOS(2, _omitFieldNames ? '' : 'data')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtTab clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExtTab copyWith(void Function(ExtTab) updates) =>
      super.copyWith((message) => updates(message as ExtTab)) as ExtTab;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ExtTab() / ExtTab.new instead')
  static ExtTab create() => ExtTab._();
  static $pb.GeneratedMessage $_createMessage() => ExtTab._();
  @$core.override
  ExtTab createEmptyInstance() => ExtTab._();
  @$core.pragma('dart2js:noInline')
  static ExtTab getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExtTab>(ExtTab.$_createMessage);
  static ExtTab? _defaultInstance;

  @$pb.TagNumber(1)
  ExtType get extType => $_getN(0);
  @$pb.TagNumber(1)
  set extType(ExtType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasExtType() => $_has(0);
  @$pb.TagNumber(1)
  void clearExtType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get data => $_getSZ(1);
  @$pb.TagNumber(2)
  set data($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => $_clearField(2);
}

class FollowLayer extends $pb.GeneratedMessage {
  factory FollowLayer({
    Staff? staff,
    Desc? desc,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
  }) {
    final result = FollowLayer._();
    if (staff != null) result.staff = staff;
    if (desc != null) result.desc = desc;
    if (report != null) result.report.addEntries(report);
    return result;
  }

  FollowLayer._();

  factory FollowLayer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowLayer()..mergeFromBuffer(data, registry);
  factory FollowLayer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FollowLayer()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FollowLayer',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: FollowLayer.$_createMessage)
    ..aOM<Staff>(1, _omitFieldNames ? '' : 'staff',
        subBuilder: Staff.$_createMessage)
    ..aOM<Desc>(2, _omitFieldNames ? '' : 'desc',
        subBuilder: Desc.$_createMessage)
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'report',
        entryClassName: 'FollowLayer.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowLayer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FollowLayer copyWith(void Function(FollowLayer) updates) =>
      super.copyWith((message) => updates(message as FollowLayer))
          as FollowLayer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FollowLayer() / FollowLayer.new instead')
  static FollowLayer create() => FollowLayer._();
  static $pb.GeneratedMessage $_createMessage() => FollowLayer._();
  @$core.override
  FollowLayer createEmptyInstance() => FollowLayer._();
  @$core.pragma('dart2js:noInline')
  static FollowLayer getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FollowLayer>(
          FollowLayer.$_createMessage);
  static FollowLayer? _defaultInstance;

  @$pb.TagNumber(1)
  Staff get staff => $_getN(0);
  @$pb.TagNumber(1)
  set staff(Staff value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStaff() => $_has(0);
  @$pb.TagNumber(1)
  void clearStaff() => $_clearField(1);
  @$pb.TagNumber(1)
  Staff ensureStaff() => $_ensure(0);

  @$pb.TagNumber(2)
  Desc get desc => $_getN(1);
  @$pb.TagNumber(2)
  set desc(Desc value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDesc() => $_has(1);
  @$pb.TagNumber(2)
  void clearDesc() => $_clearField(2);
  @$pb.TagNumber(2)
  Desc ensureDesc() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(2);
}

class Headline extends $pb.GeneratedMessage {
  factory Headline({
    Label? label,
    $core.String? content,
  }) {
    final result = Headline._();
    if (label != null) result.label = label;
    if (content != null) result.content = content;
    return result;
  }

  Headline._();

  factory Headline.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Headline()..mergeFromBuffer(data, registry);
  factory Headline.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Headline()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Headline',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Headline.$_createMessage)
    ..aOM<Label>(1, _omitFieldNames ? '' : 'label',
        subBuilder: Label.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Headline clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Headline copyWith(void Function(Headline) updates) =>
      super.copyWith((message) => updates(message as Headline)) as Headline;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Headline() / Headline.new instead')
  static Headline create() => Headline._();
  static $pb.GeneratedMessage $_createMessage() => Headline._();
  @$core.override
  Headline createEmptyInstance() => Headline._();
  @$core.pragma('dart2js:noInline')
  static Headline getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Headline>(Headline.$_createMessage);
  static Headline? _defaultInstance;

  @$pb.TagNumber(1)
  Label get label => $_getN(0);
  @$pb.TagNumber(1)
  set label(Label value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLabel() => $_has(0);
  @$pb.TagNumber(1)
  void clearLabel() => $_clearField(1);
  @$pb.TagNumber(1)
  Label ensureLabel() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get content => $_getSZ(1);
  @$pb.TagNumber(2)
  set content($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => $_clearField(2);
}

class HistoryNode extends $pb.GeneratedMessage {
  factory HistoryNode({
    $fixnum.Int64? nodeId,
    $core.String? title,
    $fixnum.Int64? cid,
  }) {
    final result = HistoryNode._();
    if (nodeId != null) result.nodeId = nodeId;
    if (title != null) result.title = title;
    if (cid != null) result.cid = cid;
    return result;
  }

  HistoryNode._();

  factory HistoryNode.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HistoryNode()..mergeFromBuffer(data, registry);
  factory HistoryNode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HistoryNode()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HistoryNode',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: HistoryNode.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'nodeId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aInt64(3, _omitFieldNames ? '' : 'cid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HistoryNode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HistoryNode copyWith(void Function(HistoryNode) updates) =>
      super.copyWith((message) => updates(message as HistoryNode))
          as HistoryNode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use HistoryNode() / HistoryNode.new instead')
  static HistoryNode create() => HistoryNode._();
  static $pb.GeneratedMessage $_createMessage() => HistoryNode._();
  @$core.override
  HistoryNode createEmptyInstance() => HistoryNode._();
  @$core.pragma('dart2js:noInline')
  static HistoryNode getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HistoryNode>(
          HistoryNode.$_createMessage);
  static HistoryNode? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get nodeId => $_getI64(0);
  @$pb.TagNumber(1)
  set nodeId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get cid => $_getI64(2);
  @$pb.TagNumber(3)
  set cid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCid() => $_has(2);
  @$pb.TagNumber(3)
  void clearCid() => $_clearField(3);
}

enum Honor_Extend { professionExt, notSet }

class Honor extends $pb.GeneratedMessage {
  factory Honor({
    $core.String? icon,
    $core.String? iconNight,
    $core.String? text,
    $core.String? textExtra,
    $core.String? textColor,
    $core.String? textColorNight,
    $core.String? bgColor,
    $core.String? bgColorNight,
    $core.String? url,
    $core.String? urlText,
    HonorType? type,
    HonorJumpType? honorJumpType,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
    $core.String? endIcon,
    ProfessionHonorExtend? professionExt,
  }) {
    final result = Honor._();
    if (icon != null) result.icon = icon;
    if (iconNight != null) result.iconNight = iconNight;
    if (text != null) result.text = text;
    if (textExtra != null) result.textExtra = textExtra;
    if (textColor != null) result.textColor = textColor;
    if (textColorNight != null) result.textColorNight = textColorNight;
    if (bgColor != null) result.bgColor = bgColor;
    if (bgColorNight != null) result.bgColorNight = bgColorNight;
    if (url != null) result.url = url;
    if (urlText != null) result.urlText = urlText;
    if (type != null) result.type = type;
    if (honorJumpType != null) result.honorJumpType = honorJumpType;
    if (report != null) result.report.addEntries(report);
    if (endIcon != null) result.endIcon = endIcon;
    if (professionExt != null) result.professionExt = professionExt;
    return result;
  }

  Honor._();

  factory Honor.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Honor()..mergeFromBuffer(data, registry);
  factory Honor.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Honor()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Honor_Extend> _Honor_ExtendByTag = {
    15: Honor_Extend.professionExt,
    0: Honor_Extend.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Honor',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Honor.$_createMessage)
    ..oo(0, [15])
    ..aOS(1, _omitFieldNames ? '' : 'icon')
    ..aOS(2, _omitFieldNames ? '' : 'iconNight')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..aOS(4, _omitFieldNames ? '' : 'textExtra')
    ..aOS(5, _omitFieldNames ? '' : 'textColor')
    ..aOS(6, _omitFieldNames ? '' : 'textColorNight')
    ..aOS(7, _omitFieldNames ? '' : 'bgColor')
    ..aOS(8, _omitFieldNames ? '' : 'bgColorNight')
    ..aOS(9, _omitFieldNames ? '' : 'url')
    ..aOS(10, _omitFieldNames ? '' : 'urlText')
    ..aE<HonorType>(11, _omitFieldNames ? '' : 'type',
        enumValues: HonorType.values)
    ..aE<HonorJumpType>(12, _omitFieldNames ? '' : 'honorJumpType',
        enumValues: HonorJumpType.values)
    ..m<$core.String, $core.String>(13, _omitFieldNames ? '' : 'report',
        entryClassName: 'Honor.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..aOS(14, _omitFieldNames ? '' : 'endIcon')
    ..aOM<ProfessionHonorExtend>(15, _omitFieldNames ? '' : 'professionExt',
        subBuilder: ProfessionHonorExtend.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Honor clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Honor copyWith(void Function(Honor) updates) =>
      super.copyWith((message) => updates(message as Honor)) as Honor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Honor() / Honor.new instead')
  static Honor create() => Honor._();
  static $pb.GeneratedMessage $_createMessage() => Honor._();
  @$core.override
  Honor createEmptyInstance() => Honor._();
  @$core.pragma('dart2js:noInline')
  static Honor getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Honor>(Honor.$_createMessage);
  static Honor? _defaultInstance;

  @$pb.TagNumber(15)
  Honor_Extend whichExtend() => _Honor_ExtendByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(15)
  void clearExtend() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get icon => $_getSZ(0);
  @$pb.TagNumber(1)
  set icon($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIcon() => $_has(0);
  @$pb.TagNumber(1)
  void clearIcon() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get iconNight => $_getSZ(1);
  @$pb.TagNumber(2)
  set iconNight($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIconNight() => $_has(1);
  @$pb.TagNumber(2)
  void clearIconNight() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get textExtra => $_getSZ(3);
  @$pb.TagNumber(4)
  set textExtra($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTextExtra() => $_has(3);
  @$pb.TagNumber(4)
  void clearTextExtra() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get textColor => $_getSZ(4);
  @$pb.TagNumber(5)
  set textColor($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTextColor() => $_has(4);
  @$pb.TagNumber(5)
  void clearTextColor() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get textColorNight => $_getSZ(5);
  @$pb.TagNumber(6)
  set textColorNight($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTextColorNight() => $_has(5);
  @$pb.TagNumber(6)
  void clearTextColorNight() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get bgColor => $_getSZ(6);
  @$pb.TagNumber(7)
  set bgColor($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBgColor() => $_has(6);
  @$pb.TagNumber(7)
  void clearBgColor() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get bgColorNight => $_getSZ(7);
  @$pb.TagNumber(8)
  set bgColorNight($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBgColorNight() => $_has(7);
  @$pb.TagNumber(8)
  void clearBgColorNight() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get url => $_getSZ(8);
  @$pb.TagNumber(9)
  set url($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUrl() => $_has(8);
  @$pb.TagNumber(9)
  void clearUrl() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get urlText => $_getSZ(9);
  @$pb.TagNumber(10)
  set urlText($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasUrlText() => $_has(9);
  @$pb.TagNumber(10)
  void clearUrlText() => $_clearField(10);

  @$pb.TagNumber(11)
  HonorType get type => $_getN(10);
  @$pb.TagNumber(11)
  set type(HonorType value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasType() => $_has(10);
  @$pb.TagNumber(11)
  void clearType() => $_clearField(11);

  @$pb.TagNumber(12)
  HonorJumpType get honorJumpType => $_getN(11);
  @$pb.TagNumber(12)
  set honorJumpType(HonorJumpType value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasHonorJumpType() => $_has(11);
  @$pb.TagNumber(12)
  void clearHonorJumpType() => $_clearField(12);

  @$pb.TagNumber(13)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(12);

  @$pb.TagNumber(14)
  $core.String get endIcon => $_getSZ(13);
  @$pb.TagNumber(14)
  set endIcon($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasEndIcon() => $_has(13);
  @$pb.TagNumber(14)
  void clearEndIcon() => $_clearField(14);

  @$pb.TagNumber(15)
  ProfessionHonorExtend get professionExt => $_getN(14);
  @$pb.TagNumber(15)
  set professionExt(ProfessionHonorExtend value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasProfessionExt() => $_has(14);
  @$pb.TagNumber(15)
  void clearProfessionExt() => $_clearField(15);
  @$pb.TagNumber(15)
  ProfessionHonorExtend ensureProfessionExt() => $_ensure(14);
}

class IconFont extends $pb.GeneratedMessage {
  factory IconFont({
    $core.String? name,
    $core.String? text,
  }) {
    final result = IconFont._();
    if (name != null) result.name = name;
    if (text != null) result.text = text;
    return result;
  }

  IconFont._();

  factory IconFont.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IconFont()..mergeFromBuffer(data, registry);
  factory IconFont.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IconFont()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IconFont',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: IconFont.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IconFont clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IconFont copyWith(void Function(IconFont) updates) =>
      super.copyWith((message) => updates(message as IconFont)) as IconFont;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use IconFont() / IconFont.new instead')
  static IconFont create() => IconFont._();
  static $pb.GeneratedMessage $_createMessage() => IconFont._();
  @$core.override
  IconFont createEmptyInstance() => IconFont._();
  @$core.pragma('dart2js:noInline')
  static IconFont getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IconFont>(IconFont.$_createMessage);
  static IconFont? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);
}

class ImagesWidget extends $pb.GeneratedMessage {
  factory ImagesWidget({
    $core.String? code,
    $core.Iterable<$core.String>? url,
  }) {
    final result = ImagesWidget._();
    if (code != null) result.code = code;
    if (url != null) result.url.addAll(url);
    return result;
  }

  ImagesWidget._();

  factory ImagesWidget.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImagesWidget()..mergeFromBuffer(data, registry);
  factory ImagesWidget.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ImagesWidget()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ImagesWidget',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ImagesWidget.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..pPS(2, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImagesWidget clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ImagesWidget copyWith(void Function(ImagesWidget) updates) =>
      super.copyWith((message) => updates(message as ImagesWidget))
          as ImagesWidget;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ImagesWidget() / ImagesWidget.new instead')
  static ImagesWidget create() => ImagesWidget._();
  static $pb.GeneratedMessage $_createMessage() => ImagesWidget._();
  @$core.override
  ImagesWidget createEmptyInstance() => ImagesWidget._();
  @$core.pragma('dart2js:noInline')
  static ImagesWidget getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImagesWidget>(
          ImagesWidget.$_createMessage);
  static ImagesWidget? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get url => $_getList(1);
}

class Interaction extends $pb.GeneratedMessage {
  factory Interaction({
    $fixnum.Int64? epId,
    HistoryNode? historyNode,
    $fixnum.Int64? graphVersion,
    $core.String? msg,
    $core.bool? isInteraction,
  }) {
    final result = Interaction._();
    if (epId != null) result.epId = epId;
    if (historyNode != null) result.historyNode = historyNode;
    if (graphVersion != null) result.graphVersion = graphVersion;
    if (msg != null) result.msg = msg;
    if (isInteraction != null) result.isInteraction = isInteraction;
    return result;
  }

  Interaction._();

  factory Interaction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Interaction()..mergeFromBuffer(data, registry);
  factory Interaction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Interaction()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Interaction',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Interaction.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'epId')
    ..aOM<HistoryNode>(2, _omitFieldNames ? '' : 'historyNode',
        subBuilder: HistoryNode.$_createMessage)
    ..aInt64(3, _omitFieldNames ? '' : 'graphVersion')
    ..aOS(4, _omitFieldNames ? '' : 'msg')
    ..aOB(5, _omitFieldNames ? '' : 'isInteraction')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Interaction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Interaction copyWith(void Function(Interaction) updates) =>
      super.copyWith((message) => updates(message as Interaction))
          as Interaction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Interaction() / Interaction.new instead')
  static Interaction create() => Interaction._();
  static $pb.GeneratedMessage $_createMessage() => Interaction._();
  @$core.override
  Interaction createEmptyInstance() => Interaction._();
  @$core.pragma('dart2js:noInline')
  static Interaction getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Interaction>(
          Interaction.$_createMessage);
  static Interaction? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get epId => $_getI64(0);
  @$pb.TagNumber(1)
  set epId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpId() => $_clearField(1);

  @$pb.TagNumber(2)
  HistoryNode get historyNode => $_getN(1);
  @$pb.TagNumber(2)
  set historyNode(HistoryNode value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasHistoryNode() => $_has(1);
  @$pb.TagNumber(2)
  void clearHistoryNode() => $_clearField(2);
  @$pb.TagNumber(2)
  HistoryNode ensureHistoryNode() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get graphVersion => $_getI64(2);
  @$pb.TagNumber(3)
  set graphVersion($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGraphVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearGraphVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get msg => $_getSZ(3);
  @$pb.TagNumber(4)
  set msg($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMsg() => $_has(3);
  @$pb.TagNumber(4)
  void clearMsg() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isInteraction => $_getBF(4);
  @$pb.TagNumber(5)
  set isInteraction($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsInteraction() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsInteraction() => $_clearField(5);
}

class Item extends $pb.GeneratedMessage {
  factory Item({
    $core.String? link,
    $core.String? cover,
  }) {
    final result = Item._();
    if (link != null) result.link = link;
    if (cover != null) result.cover = cover;
    return result;
  }

  Item._();

  factory Item.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Item()..mergeFromBuffer(data, registry);
  factory Item.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Item()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Item',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Item.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'link')
    ..aOS(2, _omitFieldNames ? '' : 'cover')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Item clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Item copyWith(void Function(Item) updates) =>
      super.copyWith((message) => updates(message as Item)) as Item;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Item() / Item.new instead')
  static Item create() => Item._();
  static $pb.GeneratedMessage $_createMessage() => Item._();
  @$core.override
  Item createEmptyInstance() => Item._();
  @$core.pragma('dart2js:noInline')
  static Item getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Item>(Item.$_createMessage);
  static Item? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get link => $_getSZ(0);
  @$pb.TagNumber(1)
  set link($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLink() => $_has(0);
  @$pb.TagNumber(1)
  void clearLink() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cover => $_getSZ(1);
  @$pb.TagNumber(2)
  set cover($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCover() => $_has(1);
  @$pb.TagNumber(2)
  void clearCover() => $_clearField(2);
}

enum KingPos_Extend { like, coin, notSet }

class KingPos extends $pb.GeneratedMessage {
  factory KingPos({
    $core.bool? disable,
    $core.String? icon,
    KingPositionType? type,
    $core.String? disableToast,
    $core.String? checkedToast,
    LikeExtend? like,
    CoinExtend? coin,
  }) {
    final result = KingPos._();
    if (disable != null) result.disable = disable;
    if (icon != null) result.icon = icon;
    if (type != null) result.type = type;
    if (disableToast != null) result.disableToast = disableToast;
    if (checkedToast != null) result.checkedToast = checkedToast;
    if (like != null) result.like = like;
    if (coin != null) result.coin = coin;
    return result;
  }

  KingPos._();

  factory KingPos.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KingPos()..mergeFromBuffer(data, registry);
  factory KingPos.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KingPos()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, KingPos_Extend> _KingPos_ExtendByTag = {
    6: KingPos_Extend.like,
    7: KingPos_Extend.coin,
    0: KingPos_Extend.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KingPos',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: KingPos.$_createMessage)
    ..oo(0, [6, 7])
    ..aOB(1, _omitFieldNames ? '' : 'disable')
    ..aOS(2, _omitFieldNames ? '' : 'icon')
    ..aE<KingPositionType>(3, _omitFieldNames ? '' : 'type',
        enumValues: KingPositionType.values)
    ..aOS(4, _omitFieldNames ? '' : 'disableToast')
    ..aOS(5, _omitFieldNames ? '' : 'checkedToast')
    ..aOM<LikeExtend>(6, _omitFieldNames ? '' : 'like',
        subBuilder: LikeExtend.$_createMessage)
    ..aOM<CoinExtend>(7, _omitFieldNames ? '' : 'coin',
        subBuilder: CoinExtend.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KingPos clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KingPos copyWith(void Function(KingPos) updates) =>
      super.copyWith((message) => updates(message as KingPos)) as KingPos;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use KingPos() / KingPos.new instead')
  static KingPos create() => KingPos._();
  static $pb.GeneratedMessage $_createMessage() => KingPos._();
  @$core.override
  KingPos createEmptyInstance() => KingPos._();
  @$core.pragma('dart2js:noInline')
  static KingPos getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KingPos>(KingPos.$_createMessage);
  static KingPos? _defaultInstance;

  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  KingPos_Extend whichExtend() => _KingPos_ExtendByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  void clearExtend() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.bool get disable => $_getBF(0);
  @$pb.TagNumber(1)
  set disable($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDisable() => $_has(0);
  @$pb.TagNumber(1)
  void clearDisable() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get icon => $_getSZ(1);
  @$pb.TagNumber(2)
  set icon($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIcon() => $_has(1);
  @$pb.TagNumber(2)
  void clearIcon() => $_clearField(2);

  @$pb.TagNumber(3)
  KingPositionType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(KingPositionType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get disableToast => $_getSZ(3);
  @$pb.TagNumber(4)
  set disableToast($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDisableToast() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisableToast() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get checkedToast => $_getSZ(4);
  @$pb.TagNumber(5)
  set checkedToast($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCheckedToast() => $_has(4);
  @$pb.TagNumber(5)
  void clearCheckedToast() => $_clearField(5);

  @$pb.TagNumber(6)
  LikeExtend get like => $_getN(5);
  @$pb.TagNumber(6)
  set like(LikeExtend value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLike() => $_has(5);
  @$pb.TagNumber(6)
  void clearLike() => $_clearField(6);
  @$pb.TagNumber(6)
  LikeExtend ensureLike() => $_ensure(5);

  @$pb.TagNumber(7)
  CoinExtend get coin => $_getN(6);
  @$pb.TagNumber(7)
  set coin(CoinExtend value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCoin() => $_has(6);
  @$pb.TagNumber(7)
  void clearCoin() => $_clearField(7);
  @$pb.TagNumber(7)
  CoinExtend ensureCoin() => $_ensure(6);
}

class KingPosition extends $pb.GeneratedMessage {
  factory KingPosition({
    $core.Iterable<KingPos>? kingPos,
    $core.Iterable<KingPos>? extend,
  }) {
    final result = KingPosition._();
    if (kingPos != null) result.kingPos.addAll(kingPos);
    if (extend != null) result.extend.addAll(extend);
    return result;
  }

  KingPosition._();

  factory KingPosition.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KingPosition()..mergeFromBuffer(data, registry);
  factory KingPosition.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KingPosition()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KingPosition',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: KingPosition.$_createMessage)
    ..pPM<KingPos>(1, _omitFieldNames ? '' : 'kingPos',
        subBuilder: KingPos.$_createMessage)
    ..pPM<KingPos>(2, _omitFieldNames ? '' : 'extend',
        subBuilder: KingPos.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KingPosition clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KingPosition copyWith(void Function(KingPosition) updates) =>
      super.copyWith((message) => updates(message as KingPosition))
          as KingPosition;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use KingPosition() / KingPosition.new instead')
  static KingPosition create() => KingPosition._();
  static $pb.GeneratedMessage $_createMessage() => KingPosition._();
  @$core.override
  KingPosition createEmptyInstance() => KingPosition._();
  @$core.pragma('dart2js:noInline')
  static KingPosition getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<KingPosition>(
          KingPosition.$_createMessage);
  static KingPosition? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<KingPos> get kingPos => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<KingPos> get extend => $_getList(1);
}

class Label extends $pb.GeneratedMessage {
  factory Label({
    $core.int? type,
    $core.String? uri,
    $core.String? icon,
    $core.String? iconNight,
    $fixnum.Int64? iconWidth,
    $fixnum.Int64? iconHeight,
    $core.String? lottie,
    $core.String? lottieNight,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
  }) {
    final result = Label._();
    if (type != null) result.type = type;
    if (uri != null) result.uri = uri;
    if (icon != null) result.icon = icon;
    if (iconNight != null) result.iconNight = iconNight;
    if (iconWidth != null) result.iconWidth = iconWidth;
    if (iconHeight != null) result.iconHeight = iconHeight;
    if (lottie != null) result.lottie = lottie;
    if (lottieNight != null) result.lottieNight = lottieNight;
    if (report != null) result.report.addEntries(report);
    return result;
  }

  Label._();

  factory Label.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Label()..mergeFromBuffer(data, registry);
  factory Label.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Label()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Label',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Label.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'type')
    ..aOS(2, _omitFieldNames ? '' : 'uri')
    ..aOS(3, _omitFieldNames ? '' : 'icon')
    ..aOS(4, _omitFieldNames ? '' : 'iconNight')
    ..aInt64(5, _omitFieldNames ? '' : 'iconWidth')
    ..aInt64(6, _omitFieldNames ? '' : 'iconHeight')
    ..aOS(7, _omitFieldNames ? '' : 'lottie')
    ..aOS(8, _omitFieldNames ? '' : 'lottieNight')
    ..m<$core.String, $core.String>(9, _omitFieldNames ? '' : 'report',
        entryClassName: 'Label.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Label clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Label copyWith(void Function(Label) updates) =>
      super.copyWith((message) => updates(message as Label)) as Label;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Label() / Label.new instead')
  static Label create() => Label._();
  static $pb.GeneratedMessage $_createMessage() => Label._();
  @$core.override
  Label createEmptyInstance() => Label._();
  @$core.pragma('dart2js:noInline')
  static Label getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Label>(Label.$_createMessage);
  static Label? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

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
  $core.String get iconNight => $_getSZ(3);
  @$pb.TagNumber(4)
  set iconNight($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIconNight() => $_has(3);
  @$pb.TagNumber(4)
  void clearIconNight() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get iconWidth => $_getI64(4);
  @$pb.TagNumber(5)
  set iconWidth($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIconWidth() => $_has(4);
  @$pb.TagNumber(5)
  void clearIconWidth() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get iconHeight => $_getI64(5);
  @$pb.TagNumber(6)
  set iconHeight($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIconHeight() => $_has(5);
  @$pb.TagNumber(6)
  void clearIconHeight() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get lottie => $_getSZ(6);
  @$pb.TagNumber(7)
  set lottie($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLottie() => $_has(6);
  @$pb.TagNumber(7)
  void clearLottie() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get lottieNight => $_getSZ(7);
  @$pb.TagNumber(8)
  set lottieNight($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLottieNight() => $_has(7);
  @$pb.TagNumber(8)
  void clearLottieNight() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(8);
}

class LikeComment extends $pb.GeneratedMessage {
  factory LikeComment({
    $core.String? reply,
    $core.String? title,
  }) {
    final result = LikeComment._();
    if (reply != null) result.reply = reply;
    if (title != null) result.title = title;
    return result;
  }

  LikeComment._();

  factory LikeComment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LikeComment()..mergeFromBuffer(data, registry);
  factory LikeComment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LikeComment()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LikeComment',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: LikeComment.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reply')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeComment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeComment copyWith(void Function(LikeComment) updates) =>
      super.copyWith((message) => updates(message as LikeComment))
          as LikeComment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LikeComment() / LikeComment.new instead')
  static LikeComment create() => LikeComment._();
  static $pb.GeneratedMessage $_createMessage() => LikeComment._();
  @$core.override
  LikeComment createEmptyInstance() => LikeComment._();
  @$core.pragma('dart2js:noInline')
  static LikeComment getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LikeComment>(
          LikeComment.$_createMessage);
  static LikeComment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reply => $_getSZ(0);
  @$pb.TagNumber(1)
  set reply($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReply() => $_has(0);
  @$pb.TagNumber(1)
  void clearReply() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);
}

class LikeExtend extends $pb.GeneratedMessage {
  factory LikeExtend({
    UpLikeImg? tripleLike,
    $core.String? likeAnimation,
    PlayerAnimation? playerAnimation,
    ActivityResource? resource,
  }) {
    final result = LikeExtend._();
    if (tripleLike != null) result.tripleLike = tripleLike;
    if (likeAnimation != null) result.likeAnimation = likeAnimation;
    if (playerAnimation != null) result.playerAnimation = playerAnimation;
    if (resource != null) result.resource = resource;
    return result;
  }

  LikeExtend._();

  factory LikeExtend.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LikeExtend()..mergeFromBuffer(data, registry);
  factory LikeExtend.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LikeExtend()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LikeExtend',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: LikeExtend.$_createMessage)
    ..aOM<UpLikeImg>(1, _omitFieldNames ? '' : 'tripleLike',
        subBuilder: UpLikeImg.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'likeAnimation')
    ..aOM<PlayerAnimation>(3, _omitFieldNames ? '' : 'playerAnimation',
        subBuilder: PlayerAnimation.$_createMessage)
    ..aOM<ActivityResource>(4, _omitFieldNames ? '' : 'resource',
        subBuilder: ActivityResource.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeExtend clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LikeExtend copyWith(void Function(LikeExtend) updates) =>
      super.copyWith((message) => updates(message as LikeExtend)) as LikeExtend;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LikeExtend() / LikeExtend.new instead')
  static LikeExtend create() => LikeExtend._();
  static $pb.GeneratedMessage $_createMessage() => LikeExtend._();
  @$core.override
  LikeExtend createEmptyInstance() => LikeExtend._();
  @$core.pragma('dart2js:noInline')
  static LikeExtend getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LikeExtend>(LikeExtend.$_createMessage);
  static LikeExtend? _defaultInstance;

  @$pb.TagNumber(1)
  UpLikeImg get tripleLike => $_getN(0);
  @$pb.TagNumber(1)
  set tripleLike(UpLikeImg value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTripleLike() => $_has(0);
  @$pb.TagNumber(1)
  void clearTripleLike() => $_clearField(1);
  @$pb.TagNumber(1)
  UpLikeImg ensureTripleLike() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get likeAnimation => $_getSZ(1);
  @$pb.TagNumber(2)
  set likeAnimation($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLikeAnimation() => $_has(1);
  @$pb.TagNumber(2)
  void clearLikeAnimation() => $_clearField(2);

  @$pb.TagNumber(3)
  PlayerAnimation get playerAnimation => $_getN(2);
  @$pb.TagNumber(3)
  set playerAnimation(PlayerAnimation value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPlayerAnimation() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlayerAnimation() => $_clearField(3);
  @$pb.TagNumber(3)
  PlayerAnimation ensurePlayerAnimation() => $_ensure(2);

  @$pb.TagNumber(4)
  ActivityResource get resource => $_getN(3);
  @$pb.TagNumber(4)
  set resource(ActivityResource value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasResource() => $_has(3);
  @$pb.TagNumber(4)
  void clearResource() => $_clearField(4);
  @$pb.TagNumber(4)
  ActivityResource ensureResource() => $_ensure(3);
}

class Live extends $pb.GeneratedMessage {
  factory Live({
    $fixnum.Int64? mid,
    $fixnum.Int64? roomId,
    $core.String? uri,
    $core.String? endpageUri,
  }) {
    final result = Live._();
    if (mid != null) result.mid = mid;
    if (roomId != null) result.roomId = roomId;
    if (uri != null) result.uri = uri;
    if (endpageUri != null) result.endpageUri = endpageUri;
    return result;
  }

  Live._();

  factory Live.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Live()..mergeFromBuffer(data, registry);
  factory Live.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Live()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Live',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Live.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aInt64(2, _omitFieldNames ? '' : 'roomId')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..aOS(4, _omitFieldNames ? '' : 'endpageUri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Live clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Live copyWith(void Function(Live) updates) =>
      super.copyWith((message) => updates(message as Live)) as Live;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Live() / Live.new instead')
  static Live create() => Live._();
  static $pb.GeneratedMessage $_createMessage() => Live._();
  @$core.override
  Live createEmptyInstance() => Live._();
  @$core.pragma('dart2js:noInline')
  static Live getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Live>(Live.$_createMessage);
  static Live? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get mid => $_getI64(0);
  @$pb.TagNumber(1)
  set mid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearMid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get roomId => $_getI64(1);
  @$pb.TagNumber(2)
  set roomId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoomId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get endpageUri => $_getSZ(3);
  @$pb.TagNumber(4)
  set endpageUri($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEndpageUri() => $_has(3);
  @$pb.TagNumber(4)
  void clearEndpageUri() => $_clearField(4);
}

class LiveOrder extends $pb.GeneratedMessage {
  factory LiveOrder({
    $fixnum.Int64? sid,
    $core.String? text,
    $fixnum.Int64? livePlanStartTime,
    $core.bool? isFollow,
    $fixnum.Int64? followCount,
    ReserveCalendarInfo? reserveCalendarInfo,
  }) {
    final result = LiveOrder._();
    if (sid != null) result.sid = sid;
    if (text != null) result.text = text;
    if (livePlanStartTime != null) result.livePlanStartTime = livePlanStartTime;
    if (isFollow != null) result.isFollow = isFollow;
    if (followCount != null) result.followCount = followCount;
    if (reserveCalendarInfo != null)
      result.reserveCalendarInfo = reserveCalendarInfo;
    return result;
  }

  LiveOrder._();

  factory LiveOrder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveOrder()..mergeFromBuffer(data, registry);
  factory LiveOrder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveOrder()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveOrder',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: LiveOrder.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'sid')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aInt64(3, _omitFieldNames ? '' : 'livePlanStartTime')
    ..aOB(4, _omitFieldNames ? '' : 'isFollow')
    ..aInt64(5, _omitFieldNames ? '' : 'followCount')
    ..aOM<ReserveCalendarInfo>(6, _omitFieldNames ? '' : 'reserveCalendarInfo',
        subBuilder: ReserveCalendarInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveOrder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveOrder copyWith(void Function(LiveOrder) updates) =>
      super.copyWith((message) => updates(message as LiveOrder)) as LiveOrder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LiveOrder() / LiveOrder.new instead')
  static LiveOrder create() => LiveOrder._();
  static $pb.GeneratedMessage $_createMessage() => LiveOrder._();
  @$core.override
  LiveOrder createEmptyInstance() => LiveOrder._();
  @$core.pragma('dart2js:noInline')
  static LiveOrder getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LiveOrder>(LiveOrder.$_createMessage);
  static LiveOrder? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get sid => $_getI64(0);
  @$pb.TagNumber(1)
  set sid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSid() => $_has(0);
  @$pb.TagNumber(1)
  void clearSid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get livePlanStartTime => $_getI64(2);
  @$pb.TagNumber(3)
  set livePlanStartTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLivePlanStartTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearLivePlanStartTime() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isFollow => $_getBF(3);
  @$pb.TagNumber(4)
  set isFollow($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsFollow() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsFollow() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get followCount => $_getI64(4);
  @$pb.TagNumber(5)
  set followCount($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFollowCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearFollowCount() => $_clearField(5);

  @$pb.TagNumber(6)
  ReserveCalendarInfo get reserveCalendarInfo => $_getN(5);
  @$pb.TagNumber(6)
  set reserveCalendarInfo(ReserveCalendarInfo value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasReserveCalendarInfo() => $_has(5);
  @$pb.TagNumber(6)
  void clearReserveCalendarInfo() => $_clearField(6);
  @$pb.TagNumber(6)
  ReserveCalendarInfo ensureReserveCalendarInfo() => $_ensure(5);
}

class Merchandise extends $pb.GeneratedMessage {
  factory Merchandise({
    $core.String? title,
    MerchandiseButton? button,
    $core.Iterable<MerchandiseCard>? card,
  }) {
    final result = Merchandise._();
    if (title != null) result.title = title;
    if (button != null) result.button = button;
    if (card != null) result.card.addAll(card);
    return result;
  }

  Merchandise._();

  factory Merchandise.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Merchandise()..mergeFromBuffer(data, registry);
  factory Merchandise.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Merchandise()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Merchandise',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Merchandise.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOM<MerchandiseButton>(2, _omitFieldNames ? '' : 'button',
        subBuilder: MerchandiseButton.$_createMessage)
    ..pPM<MerchandiseCard>(3, _omitFieldNames ? '' : 'card',
        subBuilder: MerchandiseCard.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Merchandise clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Merchandise copyWith(void Function(Merchandise) updates) =>
      super.copyWith((message) => updates(message as Merchandise))
          as Merchandise;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Merchandise() / Merchandise.new instead')
  static Merchandise create() => Merchandise._();
  static $pb.GeneratedMessage $_createMessage() => Merchandise._();
  @$core.override
  Merchandise createEmptyInstance() => Merchandise._();
  @$core.pragma('dart2js:noInline')
  static Merchandise getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Merchandise>(
          Merchandise.$_createMessage);
  static Merchandise? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  MerchandiseButton get button => $_getN(1);
  @$pb.TagNumber(2)
  set button(MerchandiseButton value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasButton() => $_has(1);
  @$pb.TagNumber(2)
  void clearButton() => $_clearField(2);
  @$pb.TagNumber(2)
  MerchandiseButton ensureButton() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<MerchandiseCard> get card => $_getList(2);
}

class MerchandiseButton extends $pb.GeneratedMessage {
  factory MerchandiseButton({
    $core.String? butTitle,
    $core.String? butDayColor,
    $core.String? butNightColor,
  }) {
    final result = MerchandiseButton._();
    if (butTitle != null) result.butTitle = butTitle;
    if (butDayColor != null) result.butDayColor = butDayColor;
    if (butNightColor != null) result.butNightColor = butNightColor;
    return result;
  }

  MerchandiseButton._();

  factory MerchandiseButton.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MerchandiseButton()..mergeFromBuffer(data, registry);
  factory MerchandiseButton.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MerchandiseButton()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MerchandiseButton',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: MerchandiseButton.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'butTitle')
    ..aOS(2, _omitFieldNames ? '' : 'butDayColor')
    ..aOS(3, _omitFieldNames ? '' : 'butNightColor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MerchandiseButton clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MerchandiseButton copyWith(void Function(MerchandiseButton) updates) =>
      super.copyWith((message) => updates(message as MerchandiseButton))
          as MerchandiseButton;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MerchandiseButton() / MerchandiseButton.new instead')
  static MerchandiseButton create() => MerchandiseButton._();
  static $pb.GeneratedMessage $_createMessage() => MerchandiseButton._();
  @$core.override
  MerchandiseButton createEmptyInstance() => MerchandiseButton._();
  @$core.pragma('dart2js:noInline')
  static MerchandiseButton getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MerchandiseButton>(
          MerchandiseButton.$_createMessage);
  static MerchandiseButton? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get butTitle => $_getSZ(0);
  @$pb.TagNumber(1)
  set butTitle($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasButTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearButTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get butDayColor => $_getSZ(1);
  @$pb.TagNumber(2)
  set butDayColor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasButDayColor() => $_has(1);
  @$pb.TagNumber(2)
  void clearButDayColor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get butNightColor => $_getSZ(2);
  @$pb.TagNumber(3)
  set butNightColor($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasButNightColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearButNightColor() => $_clearField(3);
}

class MerchandiseCard extends $pb.GeneratedMessage {
  factory MerchandiseCard({
    $core.String? cover,
    $core.String? title,
    $core.Iterable<MerchandiseTitle>? subTitle,
    MerchandiseButton? button,
    $0.Any? sourceContent,
  }) {
    final result = MerchandiseCard._();
    if (cover != null) result.cover = cover;
    if (title != null) result.title = title;
    if (subTitle != null) result.subTitle.addAll(subTitle);
    if (button != null) result.button = button;
    if (sourceContent != null) result.sourceContent = sourceContent;
    return result;
  }

  MerchandiseCard._();

  factory MerchandiseCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MerchandiseCard()..mergeFromBuffer(data, registry);
  factory MerchandiseCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MerchandiseCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MerchandiseCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: MerchandiseCard.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'cover')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..pPM<MerchandiseTitle>(3, _omitFieldNames ? '' : 'subTitle',
        subBuilder: MerchandiseTitle.$_createMessage)
    ..aOM<MerchandiseButton>(4, _omitFieldNames ? '' : 'button',
        subBuilder: MerchandiseButton.$_createMessage)
    ..aOM<$0.Any>(5, _omitFieldNames ? '' : 'sourceContent',
        subBuilder: $0.Any.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MerchandiseCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MerchandiseCard copyWith(void Function(MerchandiseCard) updates) =>
      super.copyWith((message) => updates(message as MerchandiseCard))
          as MerchandiseCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MerchandiseCard() / MerchandiseCard.new instead')
  static MerchandiseCard create() => MerchandiseCard._();
  static $pb.GeneratedMessage $_createMessage() => MerchandiseCard._();
  @$core.override
  MerchandiseCard createEmptyInstance() => MerchandiseCard._();
  @$core.pragma('dart2js:noInline')
  static MerchandiseCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MerchandiseCard>(
          MerchandiseCard.$_createMessage);
  static MerchandiseCard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cover => $_getSZ(0);
  @$pb.TagNumber(1)
  set cover($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCover() => $_has(0);
  @$pb.TagNumber(1)
  void clearCover() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<MerchandiseTitle> get subTitle => $_getList(2);

  @$pb.TagNumber(4)
  MerchandiseButton get button => $_getN(3);
  @$pb.TagNumber(4)
  set button(MerchandiseButton value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasButton() => $_has(3);
  @$pb.TagNumber(4)
  void clearButton() => $_clearField(4);
  @$pb.TagNumber(4)
  MerchandiseButton ensureButton() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Any get sourceContent => $_getN(4);
  @$pb.TagNumber(5)
  set sourceContent($0.Any value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSourceContent() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourceContent() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Any ensureSourceContent() => $_ensure(4);
}

class MerchandiseTitle extends $pb.GeneratedMessage {
  factory MerchandiseTitle({
    $core.String? title,
    $core.String? dayColor,
    $core.String? nightColor,
    $fixnum.Int64? fontSize,
    $core.int? textDecoration,
  }) {
    final result = MerchandiseTitle._();
    if (title != null) result.title = title;
    if (dayColor != null) result.dayColor = dayColor;
    if (nightColor != null) result.nightColor = nightColor;
    if (fontSize != null) result.fontSize = fontSize;
    if (textDecoration != null) result.textDecoration = textDecoration;
    return result;
  }

  MerchandiseTitle._();

  factory MerchandiseTitle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MerchandiseTitle()..mergeFromBuffer(data, registry);
  factory MerchandiseTitle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MerchandiseTitle()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MerchandiseTitle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: MerchandiseTitle.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'dayColor')
    ..aOS(3, _omitFieldNames ? '' : 'nightColor')
    ..aInt64(4, _omitFieldNames ? '' : 'fontSize')
    ..aI(5, _omitFieldNames ? '' : 'textDecoration')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MerchandiseTitle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MerchandiseTitle copyWith(void Function(MerchandiseTitle) updates) =>
      super.copyWith((message) => updates(message as MerchandiseTitle))
          as MerchandiseTitle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MerchandiseTitle() / MerchandiseTitle.new instead')
  static MerchandiseTitle create() => MerchandiseTitle._();
  static $pb.GeneratedMessage $_createMessage() => MerchandiseTitle._();
  @$core.override
  MerchandiseTitle createEmptyInstance() => MerchandiseTitle._();
  @$core.pragma('dart2js:noInline')
  static MerchandiseTitle getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MerchandiseTitle>(
          MerchandiseTitle.$_createMessage);
  static MerchandiseTitle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get dayColor => $_getSZ(1);
  @$pb.TagNumber(2)
  set dayColor($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDayColor() => $_has(1);
  @$pb.TagNumber(2)
  void clearDayColor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get nightColor => $_getSZ(2);
  @$pb.TagNumber(3)
  set nightColor($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNightColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearNightColor() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get fontSize => $_getI64(3);
  @$pb.TagNumber(4)
  set fontSize($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFontSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearFontSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get textDecoration => $_getIZ(4);
  @$pb.TagNumber(5)
  set textDecoration($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTextDecoration() => $_has(4);
  @$pb.TagNumber(5)
  void clearTextDecoration() => $_clearField(5);
}

class Mine extends $pb.GeneratedMessage {
  factory Mine({
    $core.double? amount,
    $core.int? rank,
    $core.String? msg,
  }) {
    final result = Mine._();
    if (amount != null) result.amount = amount;
    if (rank != null) result.rank = rank;
    if (msg != null) result.msg = msg;
    return result;
  }

  Mine._();

  factory Mine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Mine()..mergeFromBuffer(data, registry);
  factory Mine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Mine()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Mine',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Mine.$_createMessage)
    ..aD(1, _omitFieldNames ? '' : 'amount')
    ..aI(2, _omitFieldNames ? '' : 'rank')
    ..aOS(3, _omitFieldNames ? '' : 'msg')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Mine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Mine copyWith(void Function(Mine) updates) =>
      super.copyWith((message) => updates(message as Mine)) as Mine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Mine() / Mine.new instead')
  static Mine create() => Mine._();
  static $pb.GeneratedMessage $_createMessage() => Mine._();
  @$core.override
  Mine createEmptyInstance() => Mine._();
  @$core.pragma('dart2js:noInline')
  static Mine getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Mine>(Mine.$_createMessage);
  static Mine? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get amount => $_getN(0);
  @$pb.TagNumber(1)
  set amount($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get rank => $_getIZ(1);
  @$pb.TagNumber(2)
  set rank($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRank() => $_has(1);
  @$pb.TagNumber(2)
  void clearRank() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get msg => $_getSZ(2);
  @$pb.TagNumber(3)
  set msg($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMsg() => $_has(2);
  @$pb.TagNumber(3)
  void clearMsg() => $_clearField(3);
}

enum Module_Data {
  ogvIntroduction,
  ugcIntroduction,
  kingPosition,
  headLine,
  ogvTitle,
  honor,
  list,
  staffs,
  activityReserve,
  liveOrder,
  sectionData,
  deliveryData,
  followLayer,
  ogvSeasons,
  ugcSeason,
  ogvLiveReserve,
  combinationEp,
  sponsor,
  activityEntranceModule,
  serialSeason,
  relates,
  banner,
  audio,
  likeComment,
  attentionRecommend,
  covenanter,
  specialTag,
  upDataModule,
  professionApproval,
  pugvShoppingNotice,
  pugvFaq,
  pugvSeasonDescription,
  pugvSeasonRecommend,
  pugvSeasonPublisher,
  pugvSeasonSelection,
  pugvSeasonPrimaryInfo,
  pugvCooperationApplication,
  upVideoTool,
  pugvZone,
  pugvSeries,
  pugvPackage,
  activityStarRail,
  activityIframe,
  playList,
  merchandise,
  activityGuidanceBar,
  notSet
}

class Module extends $pb.GeneratedMessage {
  factory Module({
    ModuleType? type,
    OgvIntroduction? ogvIntroduction,
    UgcIntroduction? ugcIntroduction,
    KingPosition? kingPosition,
    Headline? headLine,
    OgvTitle? ogvTitle,
    Honor? honor,
    UserList? list,
    Staffs? staffs,
    ActivityReserve? activityReserve,
    LiveOrder? liveOrder,
    SectionData? sectionData,
    DeliveryData? deliveryData,
    FollowLayer? followLayer,
    OgvSeasons? ogvSeasons,
    UgcSeasons? ugcSeason,
    OgvLiveReserve? ogvLiveReserve,
    CombinationEp? combinationEp,
    Sponsor? sponsor,
    ActivityEntranceModule? activityEntranceModule,
    SerialSeason? serialSeason,
    Relates? relates,
    Banner? banner,
    Audio? audio,
    LikeComment? likeComment,
    AttentionRecommend? attentionRecommend,
    Covenanter? covenanter,
    SpecialTag? specialTag,
    UpDataModule? upDataModule,
    ProfessionApproval? professionApproval,
    PugvShoppingNotice? pugvShoppingNotice,
    PugvFaq? pugvFaq,
    PugvSeasonDescription? pugvSeasonDescription,
    PugvSeasonRecommend? pugvSeasonRecommend,
    PugvSeasonPublisher? pugvSeasonPublisher,
    PugvSeasonSelection? pugvSeasonSelection,
    PugvSeasonPrimaryInfo? pugvSeasonPrimaryInfo,
    PugvCooperationApplication? pugvCooperationApplication,
    UpVideoTool? upVideoTool,
    PugvZone? pugvZone,
    PugvSeries? pugvSeries,
    PugvPackage? pugvPackage,
    ActivityStarRail? activityStarRail,
    ActivityIFrame? activityIframe,
    PlayList? playList,
    Merchandise? merchandise,
    ActivityGuidanceBar? activityGuidanceBar,
  }) {
    final result = Module._();
    if (type != null) result.type = type;
    if (ogvIntroduction != null) result.ogvIntroduction = ogvIntroduction;
    if (ugcIntroduction != null) result.ugcIntroduction = ugcIntroduction;
    if (kingPosition != null) result.kingPosition = kingPosition;
    if (headLine != null) result.headLine = headLine;
    if (ogvTitle != null) result.ogvTitle = ogvTitle;
    if (honor != null) result.honor = honor;
    if (list != null) result.list = list;
    if (staffs != null) result.staffs = staffs;
    if (activityReserve != null) result.activityReserve = activityReserve;
    if (liveOrder != null) result.liveOrder = liveOrder;
    if (sectionData != null) result.sectionData = sectionData;
    if (deliveryData != null) result.deliveryData = deliveryData;
    if (followLayer != null) result.followLayer = followLayer;
    if (ogvSeasons != null) result.ogvSeasons = ogvSeasons;
    if (ugcSeason != null) result.ugcSeason = ugcSeason;
    if (ogvLiveReserve != null) result.ogvLiveReserve = ogvLiveReserve;
    if (combinationEp != null) result.combinationEp = combinationEp;
    if (sponsor != null) result.sponsor = sponsor;
    if (activityEntranceModule != null)
      result.activityEntranceModule = activityEntranceModule;
    if (serialSeason != null) result.serialSeason = serialSeason;
    if (relates != null) result.relates = relates;
    if (banner != null) result.banner = banner;
    if (audio != null) result.audio = audio;
    if (likeComment != null) result.likeComment = likeComment;
    if (attentionRecommend != null)
      result.attentionRecommend = attentionRecommend;
    if (covenanter != null) result.covenanter = covenanter;
    if (specialTag != null) result.specialTag = specialTag;
    if (upDataModule != null) result.upDataModule = upDataModule;
    if (professionApproval != null)
      result.professionApproval = professionApproval;
    if (pugvShoppingNotice != null)
      result.pugvShoppingNotice = pugvShoppingNotice;
    if (pugvFaq != null) result.pugvFaq = pugvFaq;
    if (pugvSeasonDescription != null)
      result.pugvSeasonDescription = pugvSeasonDescription;
    if (pugvSeasonRecommend != null)
      result.pugvSeasonRecommend = pugvSeasonRecommend;
    if (pugvSeasonPublisher != null)
      result.pugvSeasonPublisher = pugvSeasonPublisher;
    if (pugvSeasonSelection != null)
      result.pugvSeasonSelection = pugvSeasonSelection;
    if (pugvSeasonPrimaryInfo != null)
      result.pugvSeasonPrimaryInfo = pugvSeasonPrimaryInfo;
    if (pugvCooperationApplication != null)
      result.pugvCooperationApplication = pugvCooperationApplication;
    if (upVideoTool != null) result.upVideoTool = upVideoTool;
    if (pugvZone != null) result.pugvZone = pugvZone;
    if (pugvSeries != null) result.pugvSeries = pugvSeries;
    if (pugvPackage != null) result.pugvPackage = pugvPackage;
    if (activityStarRail != null) result.activityStarRail = activityStarRail;
    if (activityIframe != null) result.activityIframe = activityIframe;
    if (playList != null) result.playList = playList;
    if (merchandise != null) result.merchandise = merchandise;
    if (activityGuidanceBar != null)
      result.activityGuidanceBar = activityGuidanceBar;
    return result;
  }

  Module._();

  factory Module.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Module()..mergeFromBuffer(data, registry);
  factory Module.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Module()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Module_Data> _Module_DataByTag = {
    2: Module_Data.ogvIntroduction,
    3: Module_Data.ugcIntroduction,
    4: Module_Data.kingPosition,
    5: Module_Data.headLine,
    6: Module_Data.ogvTitle,
    7: Module_Data.honor,
    8: Module_Data.list,
    9: Module_Data.staffs,
    10: Module_Data.activityReserve,
    11: Module_Data.liveOrder,
    12: Module_Data.sectionData,
    13: Module_Data.deliveryData,
    14: Module_Data.followLayer,
    15: Module_Data.ogvSeasons,
    16: Module_Data.ugcSeason,
    17: Module_Data.ogvLiveReserve,
    18: Module_Data.combinationEp,
    19: Module_Data.sponsor,
    20: Module_Data.activityEntranceModule,
    21: Module_Data.serialSeason,
    22: Module_Data.relates,
    23: Module_Data.banner,
    24: Module_Data.audio,
    25: Module_Data.likeComment,
    26: Module_Data.attentionRecommend,
    27: Module_Data.covenanter,
    28: Module_Data.specialTag,
    29: Module_Data.upDataModule,
    30: Module_Data.professionApproval,
    31: Module_Data.pugvShoppingNotice,
    32: Module_Data.pugvFaq,
    33: Module_Data.pugvSeasonDescription,
    34: Module_Data.pugvSeasonRecommend,
    35: Module_Data.pugvSeasonPublisher,
    36: Module_Data.pugvSeasonSelection,
    37: Module_Data.pugvSeasonPrimaryInfo,
    38: Module_Data.pugvCooperationApplication,
    39: Module_Data.upVideoTool,
    40: Module_Data.pugvZone,
    41: Module_Data.pugvSeries,
    42: Module_Data.pugvPackage,
    43: Module_Data.activityStarRail,
    44: Module_Data.activityIframe,
    45: Module_Data.playList,
    46: Module_Data.merchandise,
    47: Module_Data.activityGuidanceBar,
    0: Module_Data.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Module',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Module.$_createMessage)
    ..oo(0, [
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      30,
      31,
      32,
      33,
      34,
      35,
      36,
      37,
      38,
      39,
      40,
      41,
      42,
      43,
      44,
      45,
      46,
      47
    ])
    ..aE<ModuleType>(1, _omitFieldNames ? '' : 'type',
        enumValues: ModuleType.values)
    ..aOM<OgvIntroduction>(2, _omitFieldNames ? '' : 'ogvIntroduction',
        subBuilder: OgvIntroduction.$_createMessage)
    ..aOM<UgcIntroduction>(3, _omitFieldNames ? '' : 'ugcIntroduction',
        subBuilder: UgcIntroduction.$_createMessage)
    ..aOM<KingPosition>(4, _omitFieldNames ? '' : 'kingPosition',
        subBuilder: KingPosition.$_createMessage)
    ..aOM<Headline>(5, _omitFieldNames ? '' : 'headLine',
        subBuilder: Headline.$_createMessage)
    ..aOM<OgvTitle>(6, _omitFieldNames ? '' : 'ogvTitle',
        subBuilder: OgvTitle.$_createMessage)
    ..aOM<Honor>(7, _omitFieldNames ? '' : 'honor',
        subBuilder: Honor.$_createMessage)
    ..aOM<UserList>(8, _omitFieldNames ? '' : 'list',
        subBuilder: UserList.$_createMessage)
    ..aOM<Staffs>(9, _omitFieldNames ? '' : 'staffs',
        subBuilder: Staffs.$_createMessage)
    ..aOM<ActivityReserve>(10, _omitFieldNames ? '' : 'activityReserve',
        subBuilder: ActivityReserve.$_createMessage)
    ..aOM<LiveOrder>(11, _omitFieldNames ? '' : 'liveOrder',
        subBuilder: LiveOrder.$_createMessage)
    ..aOM<SectionData>(12, _omitFieldNames ? '' : 'sectionData',
        subBuilder: SectionData.$_createMessage)
    ..aOM<DeliveryData>(13, _omitFieldNames ? '' : 'deliveryData',
        subBuilder: DeliveryData.$_createMessage)
    ..aOM<FollowLayer>(14, _omitFieldNames ? '' : 'followLayer',
        subBuilder: FollowLayer.$_createMessage)
    ..aOM<OgvSeasons>(15, _omitFieldNames ? '' : 'ogvSeasons',
        subBuilder: OgvSeasons.$_createMessage)
    ..aOM<UgcSeasons>(16, _omitFieldNames ? '' : 'ugcSeason',
        subBuilder: UgcSeasons.$_createMessage)
    ..aOM<OgvLiveReserve>(17, _omitFieldNames ? '' : 'ogvLiveReserve',
        subBuilder: OgvLiveReserve.$_createMessage)
    ..aOM<CombinationEp>(18, _omitFieldNames ? '' : 'combinationEp',
        subBuilder: CombinationEp.$_createMessage)
    ..aOM<Sponsor>(19, _omitFieldNames ? '' : 'sponsor',
        subBuilder: Sponsor.$_createMessage)
    ..aOM<ActivityEntranceModule>(
        20, _omitFieldNames ? '' : 'activityEntranceModule',
        subBuilder: ActivityEntranceModule.$_createMessage)
    ..aOM<SerialSeason>(21, _omitFieldNames ? '' : 'serialSeason',
        subBuilder: SerialSeason.$_createMessage)
    ..aOM<Relates>(22, _omitFieldNames ? '' : 'relates',
        subBuilder: Relates.$_createMessage)
    ..aOM<Banner>(23, _omitFieldNames ? '' : 'banner',
        subBuilder: Banner.$_createMessage)
    ..aOM<Audio>(24, _omitFieldNames ? '' : 'audio',
        subBuilder: Audio.$_createMessage)
    ..aOM<LikeComment>(25, _omitFieldNames ? '' : 'likeComment',
        subBuilder: LikeComment.$_createMessage)
    ..aOM<AttentionRecommend>(26, _omitFieldNames ? '' : 'attentionRecommend',
        subBuilder: AttentionRecommend.$_createMessage)
    ..aOM<Covenanter>(27, _omitFieldNames ? '' : 'covenanter',
        subBuilder: Covenanter.$_createMessage)
    ..aOM<SpecialTag>(28, _omitFieldNames ? '' : 'specialTag',
        subBuilder: SpecialTag.$_createMessage)
    ..aOM<UpDataModule>(29, _omitFieldNames ? '' : 'upDataModule',
        subBuilder: UpDataModule.$_createMessage)
    ..aOM<ProfessionApproval>(30, _omitFieldNames ? '' : 'professionApproval',
        subBuilder: ProfessionApproval.$_createMessage)
    ..aOM<PugvShoppingNotice>(31, _omitFieldNames ? '' : 'pugvShoppingNotice',
        subBuilder: PugvShoppingNotice.$_createMessage)
    ..aOM<PugvFaq>(32, _omitFieldNames ? '' : 'pugvFaq',
        subBuilder: PugvFaq.$_createMessage)
    ..aOM<PugvSeasonDescription>(
        33, _omitFieldNames ? '' : 'pugvSeasonDescription',
        subBuilder: PugvSeasonDescription.$_createMessage)
    ..aOM<PugvSeasonRecommend>(34, _omitFieldNames ? '' : 'pugvSeasonRecommend',
        subBuilder: PugvSeasonRecommend.$_createMessage)
    ..aOM<PugvSeasonPublisher>(35, _omitFieldNames ? '' : 'pugvSeasonPublisher',
        subBuilder: PugvSeasonPublisher.$_createMessage)
    ..aOM<PugvSeasonSelection>(36, _omitFieldNames ? '' : 'pugvSeasonSelection',
        subBuilder: PugvSeasonSelection.$_createMessage)
    ..aOM<PugvSeasonPrimaryInfo>(
        37, _omitFieldNames ? '' : 'pugvSeasonPrimaryInfo',
        subBuilder: PugvSeasonPrimaryInfo.$_createMessage)
    ..aOM<PugvCooperationApplication>(
        38, _omitFieldNames ? '' : 'pugvCooperationApplication',
        subBuilder: PugvCooperationApplication.$_createMessage)
    ..aOM<UpVideoTool>(39, _omitFieldNames ? '' : 'upVideoTool',
        subBuilder: UpVideoTool.$_createMessage)
    ..aOM<PugvZone>(40, _omitFieldNames ? '' : 'pugvZone',
        subBuilder: PugvZone.$_createMessage)
    ..aOM<PugvSeries>(41, _omitFieldNames ? '' : 'pugvSeries',
        subBuilder: PugvSeries.$_createMessage)
    ..aOM<PugvPackage>(42, _omitFieldNames ? '' : 'pugvPackage',
        subBuilder: PugvPackage.$_createMessage)
    ..aOM<ActivityStarRail>(43, _omitFieldNames ? '' : 'activityStarRail',
        subBuilder: ActivityStarRail.$_createMessage)
    ..aOM<ActivityIFrame>(44, _omitFieldNames ? '' : 'activityIframe',
        subBuilder: ActivityIFrame.$_createMessage)
    ..aOM<PlayList>(45, _omitFieldNames ? '' : 'playList',
        subBuilder: PlayList.$_createMessage)
    ..aOM<Merchandise>(46, _omitFieldNames ? '' : 'merchandise',
        subBuilder: Merchandise.$_createMessage)
    ..aOM<ActivityGuidanceBar>(47, _omitFieldNames ? '' : 'activityGuidanceBar',
        subBuilder: ActivityGuidanceBar.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Module clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Module copyWith(void Function(Module) updates) =>
      super.copyWith((message) => updates(message as Module)) as Module;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Module() / Module.new instead')
  static Module create() => Module._();
  static $pb.GeneratedMessage $_createMessage() => Module._();
  @$core.override
  Module createEmptyInstance() => Module._();
  @$core.pragma('dart2js:noInline')
  static Module getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Module>(Module.$_createMessage);
  static Module? _defaultInstance;

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
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(26)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  @$pb.TagNumber(29)
  @$pb.TagNumber(30)
  @$pb.TagNumber(31)
  @$pb.TagNumber(32)
  @$pb.TagNumber(33)
  @$pb.TagNumber(34)
  @$pb.TagNumber(35)
  @$pb.TagNumber(36)
  @$pb.TagNumber(37)
  @$pb.TagNumber(38)
  @$pb.TagNumber(39)
  @$pb.TagNumber(40)
  @$pb.TagNumber(41)
  @$pb.TagNumber(42)
  @$pb.TagNumber(43)
  @$pb.TagNumber(44)
  @$pb.TagNumber(45)
  @$pb.TagNumber(46)
  @$pb.TagNumber(47)
  Module_Data whichData() => _Module_DataByTag[$_whichOneof(0)]!;
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
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  @$pb.TagNumber(18)
  @$pb.TagNumber(19)
  @$pb.TagNumber(20)
  @$pb.TagNumber(21)
  @$pb.TagNumber(22)
  @$pb.TagNumber(23)
  @$pb.TagNumber(24)
  @$pb.TagNumber(25)
  @$pb.TagNumber(26)
  @$pb.TagNumber(27)
  @$pb.TagNumber(28)
  @$pb.TagNumber(29)
  @$pb.TagNumber(30)
  @$pb.TagNumber(31)
  @$pb.TagNumber(32)
  @$pb.TagNumber(33)
  @$pb.TagNumber(34)
  @$pb.TagNumber(35)
  @$pb.TagNumber(36)
  @$pb.TagNumber(37)
  @$pb.TagNumber(38)
  @$pb.TagNumber(39)
  @$pb.TagNumber(40)
  @$pb.TagNumber(41)
  @$pb.TagNumber(42)
  @$pb.TagNumber(43)
  @$pb.TagNumber(44)
  @$pb.TagNumber(45)
  @$pb.TagNumber(46)
  @$pb.TagNumber(47)
  void clearData() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ModuleType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(ModuleType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  OgvIntroduction get ogvIntroduction => $_getN(1);
  @$pb.TagNumber(2)
  set ogvIntroduction(OgvIntroduction value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOgvIntroduction() => $_has(1);
  @$pb.TagNumber(2)
  void clearOgvIntroduction() => $_clearField(2);
  @$pb.TagNumber(2)
  OgvIntroduction ensureOgvIntroduction() => $_ensure(1);

  @$pb.TagNumber(3)
  UgcIntroduction get ugcIntroduction => $_getN(2);
  @$pb.TagNumber(3)
  set ugcIntroduction(UgcIntroduction value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUgcIntroduction() => $_has(2);
  @$pb.TagNumber(3)
  void clearUgcIntroduction() => $_clearField(3);
  @$pb.TagNumber(3)
  UgcIntroduction ensureUgcIntroduction() => $_ensure(2);

  @$pb.TagNumber(4)
  KingPosition get kingPosition => $_getN(3);
  @$pb.TagNumber(4)
  set kingPosition(KingPosition value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKingPosition() => $_has(3);
  @$pb.TagNumber(4)
  void clearKingPosition() => $_clearField(4);
  @$pb.TagNumber(4)
  KingPosition ensureKingPosition() => $_ensure(3);

  @$pb.TagNumber(5)
  Headline get headLine => $_getN(4);
  @$pb.TagNumber(5)
  set headLine(Headline value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasHeadLine() => $_has(4);
  @$pb.TagNumber(5)
  void clearHeadLine() => $_clearField(5);
  @$pb.TagNumber(5)
  Headline ensureHeadLine() => $_ensure(4);

  @$pb.TagNumber(6)
  OgvTitle get ogvTitle => $_getN(5);
  @$pb.TagNumber(6)
  set ogvTitle(OgvTitle value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasOgvTitle() => $_has(5);
  @$pb.TagNumber(6)
  void clearOgvTitle() => $_clearField(6);
  @$pb.TagNumber(6)
  OgvTitle ensureOgvTitle() => $_ensure(5);

  @$pb.TagNumber(7)
  Honor get honor => $_getN(6);
  @$pb.TagNumber(7)
  set honor(Honor value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasHonor() => $_has(6);
  @$pb.TagNumber(7)
  void clearHonor() => $_clearField(7);
  @$pb.TagNumber(7)
  Honor ensureHonor() => $_ensure(6);

  @$pb.TagNumber(8)
  UserList get list => $_getN(7);
  @$pb.TagNumber(8)
  set list(UserList value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasList() => $_has(7);
  @$pb.TagNumber(8)
  void clearList() => $_clearField(8);
  @$pb.TagNumber(8)
  UserList ensureList() => $_ensure(7);

  @$pb.TagNumber(9)
  Staffs get staffs => $_getN(8);
  @$pb.TagNumber(9)
  set staffs(Staffs value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasStaffs() => $_has(8);
  @$pb.TagNumber(9)
  void clearStaffs() => $_clearField(9);
  @$pb.TagNumber(9)
  Staffs ensureStaffs() => $_ensure(8);

  @$pb.TagNumber(10)
  ActivityReserve get activityReserve => $_getN(9);
  @$pb.TagNumber(10)
  set activityReserve(ActivityReserve value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasActivityReserve() => $_has(9);
  @$pb.TagNumber(10)
  void clearActivityReserve() => $_clearField(10);
  @$pb.TagNumber(10)
  ActivityReserve ensureActivityReserve() => $_ensure(9);

  @$pb.TagNumber(11)
  LiveOrder get liveOrder => $_getN(10);
  @$pb.TagNumber(11)
  set liveOrder(LiveOrder value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasLiveOrder() => $_has(10);
  @$pb.TagNumber(11)
  void clearLiveOrder() => $_clearField(11);
  @$pb.TagNumber(11)
  LiveOrder ensureLiveOrder() => $_ensure(10);

  @$pb.TagNumber(12)
  SectionData get sectionData => $_getN(11);
  @$pb.TagNumber(12)
  set sectionData(SectionData value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasSectionData() => $_has(11);
  @$pb.TagNumber(12)
  void clearSectionData() => $_clearField(12);
  @$pb.TagNumber(12)
  SectionData ensureSectionData() => $_ensure(11);

  @$pb.TagNumber(13)
  DeliveryData get deliveryData => $_getN(12);
  @$pb.TagNumber(13)
  set deliveryData(DeliveryData value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasDeliveryData() => $_has(12);
  @$pb.TagNumber(13)
  void clearDeliveryData() => $_clearField(13);
  @$pb.TagNumber(13)
  DeliveryData ensureDeliveryData() => $_ensure(12);

  @$pb.TagNumber(14)
  FollowLayer get followLayer => $_getN(13);
  @$pb.TagNumber(14)
  set followLayer(FollowLayer value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasFollowLayer() => $_has(13);
  @$pb.TagNumber(14)
  void clearFollowLayer() => $_clearField(14);
  @$pb.TagNumber(14)
  FollowLayer ensureFollowLayer() => $_ensure(13);

  @$pb.TagNumber(15)
  OgvSeasons get ogvSeasons => $_getN(14);
  @$pb.TagNumber(15)
  set ogvSeasons(OgvSeasons value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasOgvSeasons() => $_has(14);
  @$pb.TagNumber(15)
  void clearOgvSeasons() => $_clearField(15);
  @$pb.TagNumber(15)
  OgvSeasons ensureOgvSeasons() => $_ensure(14);

  @$pb.TagNumber(16)
  UgcSeasons get ugcSeason => $_getN(15);
  @$pb.TagNumber(16)
  set ugcSeason(UgcSeasons value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasUgcSeason() => $_has(15);
  @$pb.TagNumber(16)
  void clearUgcSeason() => $_clearField(16);
  @$pb.TagNumber(16)
  UgcSeasons ensureUgcSeason() => $_ensure(15);

  @$pb.TagNumber(17)
  OgvLiveReserve get ogvLiveReserve => $_getN(16);
  @$pb.TagNumber(17)
  set ogvLiveReserve(OgvLiveReserve value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasOgvLiveReserve() => $_has(16);
  @$pb.TagNumber(17)
  void clearOgvLiveReserve() => $_clearField(17);
  @$pb.TagNumber(17)
  OgvLiveReserve ensureOgvLiveReserve() => $_ensure(16);

  @$pb.TagNumber(18)
  CombinationEp get combinationEp => $_getN(17);
  @$pb.TagNumber(18)
  set combinationEp(CombinationEp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasCombinationEp() => $_has(17);
  @$pb.TagNumber(18)
  void clearCombinationEp() => $_clearField(18);
  @$pb.TagNumber(18)
  CombinationEp ensureCombinationEp() => $_ensure(17);

  @$pb.TagNumber(19)
  Sponsor get sponsor => $_getN(18);
  @$pb.TagNumber(19)
  set sponsor(Sponsor value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasSponsor() => $_has(18);
  @$pb.TagNumber(19)
  void clearSponsor() => $_clearField(19);
  @$pb.TagNumber(19)
  Sponsor ensureSponsor() => $_ensure(18);

  @$pb.TagNumber(20)
  ActivityEntranceModule get activityEntranceModule => $_getN(19);
  @$pb.TagNumber(20)
  set activityEntranceModule(ActivityEntranceModule value) =>
      $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasActivityEntranceModule() => $_has(19);
  @$pb.TagNumber(20)
  void clearActivityEntranceModule() => $_clearField(20);
  @$pb.TagNumber(20)
  ActivityEntranceModule ensureActivityEntranceModule() => $_ensure(19);

  @$pb.TagNumber(21)
  SerialSeason get serialSeason => $_getN(20);
  @$pb.TagNumber(21)
  set serialSeason(SerialSeason value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasSerialSeason() => $_has(20);
  @$pb.TagNumber(21)
  void clearSerialSeason() => $_clearField(21);
  @$pb.TagNumber(21)
  SerialSeason ensureSerialSeason() => $_ensure(20);

  @$pb.TagNumber(22)
  Relates get relates => $_getN(21);
  @$pb.TagNumber(22)
  set relates(Relates value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasRelates() => $_has(21);
  @$pb.TagNumber(22)
  void clearRelates() => $_clearField(22);
  @$pb.TagNumber(22)
  Relates ensureRelates() => $_ensure(21);

  @$pb.TagNumber(23)
  Banner get banner => $_getN(22);
  @$pb.TagNumber(23)
  set banner(Banner value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasBanner() => $_has(22);
  @$pb.TagNumber(23)
  void clearBanner() => $_clearField(23);
  @$pb.TagNumber(23)
  Banner ensureBanner() => $_ensure(22);

  @$pb.TagNumber(24)
  Audio get audio => $_getN(23);
  @$pb.TagNumber(24)
  set audio(Audio value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasAudio() => $_has(23);
  @$pb.TagNumber(24)
  void clearAudio() => $_clearField(24);
  @$pb.TagNumber(24)
  Audio ensureAudio() => $_ensure(23);

  @$pb.TagNumber(25)
  LikeComment get likeComment => $_getN(24);
  @$pb.TagNumber(25)
  set likeComment(LikeComment value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasLikeComment() => $_has(24);
  @$pb.TagNumber(25)
  void clearLikeComment() => $_clearField(25);
  @$pb.TagNumber(25)
  LikeComment ensureLikeComment() => $_ensure(24);

  @$pb.TagNumber(26)
  AttentionRecommend get attentionRecommend => $_getN(25);
  @$pb.TagNumber(26)
  set attentionRecommend(AttentionRecommend value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasAttentionRecommend() => $_has(25);
  @$pb.TagNumber(26)
  void clearAttentionRecommend() => $_clearField(26);
  @$pb.TagNumber(26)
  AttentionRecommend ensureAttentionRecommend() => $_ensure(25);

  @$pb.TagNumber(27)
  Covenanter get covenanter => $_getN(26);
  @$pb.TagNumber(27)
  set covenanter(Covenanter value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasCovenanter() => $_has(26);
  @$pb.TagNumber(27)
  void clearCovenanter() => $_clearField(27);
  @$pb.TagNumber(27)
  Covenanter ensureCovenanter() => $_ensure(26);

  @$pb.TagNumber(28)
  SpecialTag get specialTag => $_getN(27);
  @$pb.TagNumber(28)
  set specialTag(SpecialTag value) => $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasSpecialTag() => $_has(27);
  @$pb.TagNumber(28)
  void clearSpecialTag() => $_clearField(28);
  @$pb.TagNumber(28)
  SpecialTag ensureSpecialTag() => $_ensure(27);

  @$pb.TagNumber(29)
  UpDataModule get upDataModule => $_getN(28);
  @$pb.TagNumber(29)
  set upDataModule(UpDataModule value) => $_setField(29, value);
  @$pb.TagNumber(29)
  $core.bool hasUpDataModule() => $_has(28);
  @$pb.TagNumber(29)
  void clearUpDataModule() => $_clearField(29);
  @$pb.TagNumber(29)
  UpDataModule ensureUpDataModule() => $_ensure(28);

  @$pb.TagNumber(30)
  ProfessionApproval get professionApproval => $_getN(29);
  @$pb.TagNumber(30)
  set professionApproval(ProfessionApproval value) => $_setField(30, value);
  @$pb.TagNumber(30)
  $core.bool hasProfessionApproval() => $_has(29);
  @$pb.TagNumber(30)
  void clearProfessionApproval() => $_clearField(30);
  @$pb.TagNumber(30)
  ProfessionApproval ensureProfessionApproval() => $_ensure(29);

  @$pb.TagNumber(31)
  PugvShoppingNotice get pugvShoppingNotice => $_getN(30);
  @$pb.TagNumber(31)
  set pugvShoppingNotice(PugvShoppingNotice value) => $_setField(31, value);
  @$pb.TagNumber(31)
  $core.bool hasPugvShoppingNotice() => $_has(30);
  @$pb.TagNumber(31)
  void clearPugvShoppingNotice() => $_clearField(31);
  @$pb.TagNumber(31)
  PugvShoppingNotice ensurePugvShoppingNotice() => $_ensure(30);

  @$pb.TagNumber(32)
  PugvFaq get pugvFaq => $_getN(31);
  @$pb.TagNumber(32)
  set pugvFaq(PugvFaq value) => $_setField(32, value);
  @$pb.TagNumber(32)
  $core.bool hasPugvFaq() => $_has(31);
  @$pb.TagNumber(32)
  void clearPugvFaq() => $_clearField(32);
  @$pb.TagNumber(32)
  PugvFaq ensurePugvFaq() => $_ensure(31);

  @$pb.TagNumber(33)
  PugvSeasonDescription get pugvSeasonDescription => $_getN(32);
  @$pb.TagNumber(33)
  set pugvSeasonDescription(PugvSeasonDescription value) =>
      $_setField(33, value);
  @$pb.TagNumber(33)
  $core.bool hasPugvSeasonDescription() => $_has(32);
  @$pb.TagNumber(33)
  void clearPugvSeasonDescription() => $_clearField(33);
  @$pb.TagNumber(33)
  PugvSeasonDescription ensurePugvSeasonDescription() => $_ensure(32);

  @$pb.TagNumber(34)
  PugvSeasonRecommend get pugvSeasonRecommend => $_getN(33);
  @$pb.TagNumber(34)
  set pugvSeasonRecommend(PugvSeasonRecommend value) => $_setField(34, value);
  @$pb.TagNumber(34)
  $core.bool hasPugvSeasonRecommend() => $_has(33);
  @$pb.TagNumber(34)
  void clearPugvSeasonRecommend() => $_clearField(34);
  @$pb.TagNumber(34)
  PugvSeasonRecommend ensurePugvSeasonRecommend() => $_ensure(33);

  @$pb.TagNumber(35)
  PugvSeasonPublisher get pugvSeasonPublisher => $_getN(34);
  @$pb.TagNumber(35)
  set pugvSeasonPublisher(PugvSeasonPublisher value) => $_setField(35, value);
  @$pb.TagNumber(35)
  $core.bool hasPugvSeasonPublisher() => $_has(34);
  @$pb.TagNumber(35)
  void clearPugvSeasonPublisher() => $_clearField(35);
  @$pb.TagNumber(35)
  PugvSeasonPublisher ensurePugvSeasonPublisher() => $_ensure(34);

  @$pb.TagNumber(36)
  PugvSeasonSelection get pugvSeasonSelection => $_getN(35);
  @$pb.TagNumber(36)
  set pugvSeasonSelection(PugvSeasonSelection value) => $_setField(36, value);
  @$pb.TagNumber(36)
  $core.bool hasPugvSeasonSelection() => $_has(35);
  @$pb.TagNumber(36)
  void clearPugvSeasonSelection() => $_clearField(36);
  @$pb.TagNumber(36)
  PugvSeasonSelection ensurePugvSeasonSelection() => $_ensure(35);

  @$pb.TagNumber(37)
  PugvSeasonPrimaryInfo get pugvSeasonPrimaryInfo => $_getN(36);
  @$pb.TagNumber(37)
  set pugvSeasonPrimaryInfo(PugvSeasonPrimaryInfo value) =>
      $_setField(37, value);
  @$pb.TagNumber(37)
  $core.bool hasPugvSeasonPrimaryInfo() => $_has(36);
  @$pb.TagNumber(37)
  void clearPugvSeasonPrimaryInfo() => $_clearField(37);
  @$pb.TagNumber(37)
  PugvSeasonPrimaryInfo ensurePugvSeasonPrimaryInfo() => $_ensure(36);

  @$pb.TagNumber(38)
  PugvCooperationApplication get pugvCooperationApplication => $_getN(37);
  @$pb.TagNumber(38)
  set pugvCooperationApplication(PugvCooperationApplication value) =>
      $_setField(38, value);
  @$pb.TagNumber(38)
  $core.bool hasPugvCooperationApplication() => $_has(37);
  @$pb.TagNumber(38)
  void clearPugvCooperationApplication() => $_clearField(38);
  @$pb.TagNumber(38)
  PugvCooperationApplication ensurePugvCooperationApplication() => $_ensure(37);

  @$pb.TagNumber(39)
  UpVideoTool get upVideoTool => $_getN(38);
  @$pb.TagNumber(39)
  set upVideoTool(UpVideoTool value) => $_setField(39, value);
  @$pb.TagNumber(39)
  $core.bool hasUpVideoTool() => $_has(38);
  @$pb.TagNumber(39)
  void clearUpVideoTool() => $_clearField(39);
  @$pb.TagNumber(39)
  UpVideoTool ensureUpVideoTool() => $_ensure(38);

  @$pb.TagNumber(40)
  PugvZone get pugvZone => $_getN(39);
  @$pb.TagNumber(40)
  set pugvZone(PugvZone value) => $_setField(40, value);
  @$pb.TagNumber(40)
  $core.bool hasPugvZone() => $_has(39);
  @$pb.TagNumber(40)
  void clearPugvZone() => $_clearField(40);
  @$pb.TagNumber(40)
  PugvZone ensurePugvZone() => $_ensure(39);

  @$pb.TagNumber(41)
  PugvSeries get pugvSeries => $_getN(40);
  @$pb.TagNumber(41)
  set pugvSeries(PugvSeries value) => $_setField(41, value);
  @$pb.TagNumber(41)
  $core.bool hasPugvSeries() => $_has(40);
  @$pb.TagNumber(41)
  void clearPugvSeries() => $_clearField(41);
  @$pb.TagNumber(41)
  PugvSeries ensurePugvSeries() => $_ensure(40);

  @$pb.TagNumber(42)
  PugvPackage get pugvPackage => $_getN(41);
  @$pb.TagNumber(42)
  set pugvPackage(PugvPackage value) => $_setField(42, value);
  @$pb.TagNumber(42)
  $core.bool hasPugvPackage() => $_has(41);
  @$pb.TagNumber(42)
  void clearPugvPackage() => $_clearField(42);
  @$pb.TagNumber(42)
  PugvPackage ensurePugvPackage() => $_ensure(41);

  @$pb.TagNumber(43)
  ActivityStarRail get activityStarRail => $_getN(42);
  @$pb.TagNumber(43)
  set activityStarRail(ActivityStarRail value) => $_setField(43, value);
  @$pb.TagNumber(43)
  $core.bool hasActivityStarRail() => $_has(42);
  @$pb.TagNumber(43)
  void clearActivityStarRail() => $_clearField(43);
  @$pb.TagNumber(43)
  ActivityStarRail ensureActivityStarRail() => $_ensure(42);

  @$pb.TagNumber(44)
  ActivityIFrame get activityIframe => $_getN(43);
  @$pb.TagNumber(44)
  set activityIframe(ActivityIFrame value) => $_setField(44, value);
  @$pb.TagNumber(44)
  $core.bool hasActivityIframe() => $_has(43);
  @$pb.TagNumber(44)
  void clearActivityIframe() => $_clearField(44);
  @$pb.TagNumber(44)
  ActivityIFrame ensureActivityIframe() => $_ensure(43);

  @$pb.TagNumber(45)
  PlayList get playList => $_getN(44);
  @$pb.TagNumber(45)
  set playList(PlayList value) => $_setField(45, value);
  @$pb.TagNumber(45)
  $core.bool hasPlayList() => $_has(44);
  @$pb.TagNumber(45)
  void clearPlayList() => $_clearField(45);
  @$pb.TagNumber(45)
  PlayList ensurePlayList() => $_ensure(44);

  @$pb.TagNumber(46)
  Merchandise get merchandise => $_getN(45);
  @$pb.TagNumber(46)
  set merchandise(Merchandise value) => $_setField(46, value);
  @$pb.TagNumber(46)
  $core.bool hasMerchandise() => $_has(45);
  @$pb.TagNumber(46)
  void clearMerchandise() => $_clearField(46);
  @$pb.TagNumber(46)
  Merchandise ensureMerchandise() => $_ensure(45);

  @$pb.TagNumber(47)
  ActivityGuidanceBar get activityGuidanceBar => $_getN(46);
  @$pb.TagNumber(47)
  set activityGuidanceBar(ActivityGuidanceBar value) => $_setField(47, value);
  @$pb.TagNumber(47)
  $core.bool hasActivityGuidanceBar() => $_has(46);
  @$pb.TagNumber(47)
  void clearActivityGuidanceBar() => $_clearField(47);
  @$pb.TagNumber(47)
  ActivityGuidanceBar ensureActivityGuidanceBar() => $_ensure(46);
}

class MultiViewEp extends $pb.GeneratedMessage {
  factory MultiViewEp({
    $fixnum.Int64? epId,
  }) {
    final result = MultiViewEp._();
    if (epId != null) result.epId = epId;
    return result;
  }

  MultiViewEp._();

  factory MultiViewEp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MultiViewEp()..mergeFromBuffer(data, registry);
  factory MultiViewEp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MultiViewEp()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MultiViewEp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: MultiViewEp.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'epId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiViewEp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiViewEp copyWith(void Function(MultiViewEp) updates) =>
      super.copyWith((message) => updates(message as MultiViewEp))
          as MultiViewEp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MultiViewEp() / MultiViewEp.new instead')
  static MultiViewEp create() => MultiViewEp._();
  static $pb.GeneratedMessage $_createMessage() => MultiViewEp._();
  @$core.override
  MultiViewEp createEmptyInstance() => MultiViewEp._();
  @$core.pragma('dart2js:noInline')
  static MultiViewEp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MultiViewEp>(
          MultiViewEp.$_createMessage);
  static MultiViewEp? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get epId => $_getI64(0);
  @$pb.TagNumber(1)
  set epId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpId() => $_clearField(1);
}

class Neutral extends $pb.GeneratedMessage {
  factory Neutral({
    $core.String? icon,
    $core.String? title,
  }) {
    final result = Neutral._();
    if (icon != null) result.icon = icon;
    if (title != null) result.title = title;
    return result;
  }

  Neutral._();

  factory Neutral.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Neutral()..mergeFromBuffer(data, registry);
  factory Neutral.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Neutral()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Neutral',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Neutral.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'icon')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Neutral clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Neutral copyWith(void Function(Neutral) updates) =>
      super.copyWith((message) => updates(message as Neutral)) as Neutral;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Neutral() / Neutral.new instead')
  static Neutral create() => Neutral._();
  static $pb.GeneratedMessage $_createMessage() => Neutral._();
  @$core.override
  Neutral createEmptyInstance() => Neutral._();
  @$core.pragma('dart2js:noInline')
  static Neutral getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Neutral>(Neutral.$_createMessage);
  static Neutral? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get icon => $_getSZ(0);
  @$pb.TagNumber(1)
  set icon($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIcon() => $_has(0);
  @$pb.TagNumber(1)
  void clearIcon() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);
}

class NewEp extends $pb.GeneratedMessage {
  factory NewEp({
    $core.int? id,
    $core.String? title,
    $core.String? desc,
    $core.int? isNew,
    $core.String? more,
    $core.String? cover,
    $core.String? indexShow,
  }) {
    final result = NewEp._();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (desc != null) result.desc = desc;
    if (isNew != null) result.isNew = isNew;
    if (more != null) result.more = more;
    if (cover != null) result.cover = cover;
    if (indexShow != null) result.indexShow = indexShow;
    return result;
  }

  NewEp._();

  factory NewEp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NewEp()..mergeFromBuffer(data, registry);
  factory NewEp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NewEp()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NewEp',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: NewEp.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'desc')
    ..aI(4, _omitFieldNames ? '' : 'isNew')
    ..aOS(5, _omitFieldNames ? '' : 'more')
    ..aOS(6, _omitFieldNames ? '' : 'cover')
    ..aOS(7, _omitFieldNames ? '' : 'indexShow')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NewEp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NewEp copyWith(void Function(NewEp) updates) =>
      super.copyWith((message) => updates(message as NewEp)) as NewEp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use NewEp() / NewEp.new instead')
  static NewEp create() => NewEp._();
  static $pb.GeneratedMessage $_createMessage() => NewEp._();
  @$core.override
  NewEp createEmptyInstance() => NewEp._();
  @$core.pragma('dart2js:noInline')
  static NewEp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NewEp>(NewEp.$_createMessage);
  static NewEp? _defaultInstance;

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
  $core.String get desc => $_getSZ(2);
  @$pb.TagNumber(3)
  set desc($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDesc() => $_has(2);
  @$pb.TagNumber(3)
  void clearDesc() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get isNew => $_getIZ(3);
  @$pb.TagNumber(4)
  set isNew($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsNew() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsNew() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get more => $_getSZ(4);
  @$pb.TagNumber(5)
  set more($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMore() => $_has(4);
  @$pb.TagNumber(5)
  void clearMore() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get cover => $_getSZ(5);
  @$pb.TagNumber(6)
  set cover($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCover() => $_has(5);
  @$pb.TagNumber(6)
  void clearCover() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get indexShow => $_getSZ(6);
  @$pb.TagNumber(7)
  set indexShow($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIndexShow() => $_has(6);
  @$pb.TagNumber(7)
  void clearIndexShow() => $_clearField(7);
}

class OfficialVerify extends $pb.GeneratedMessage {
  factory OfficialVerify({
    $core.int? type,
    $core.String? desc,
  }) {
    final result = OfficialVerify._();
    if (type != null) result.type = type;
    if (desc != null) result.desc = desc;
    return result;
  }

  OfficialVerify._();

  factory OfficialVerify.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfficialVerify()..mergeFromBuffer(data, registry);
  factory OfficialVerify.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfficialVerify()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfficialVerify',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: OfficialVerify.$_createMessage)
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
  @$core.Deprecated('Use OfficialVerify() / OfficialVerify.new instead')
  static OfficialVerify create() => OfficialVerify._();
  static $pb.GeneratedMessage $_createMessage() => OfficialVerify._();
  @$core.override
  OfficialVerify createEmptyInstance() => OfficialVerify._();
  @$core.pragma('dart2js:noInline')
  static OfficialVerify getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OfficialVerify>(
          OfficialVerify.$_createMessage);
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

class OgvIntroduction extends $pb.GeneratedMessage {
  factory OgvIntroduction({
    $core.String? followers,
    $core.String? score,
    StatInfo? playData,
    $core.String? scoreColor,
    $core.String? scoreNightColor,
    $core.String? textColor,
    $core.String? textNightColor,
  }) {
    final result = OgvIntroduction._();
    if (followers != null) result.followers = followers;
    if (score != null) result.score = score;
    if (playData != null) result.playData = playData;
    if (scoreColor != null) result.scoreColor = scoreColor;
    if (scoreNightColor != null) result.scoreNightColor = scoreNightColor;
    if (textColor != null) result.textColor = textColor;
    if (textNightColor != null) result.textNightColor = textNightColor;
    return result;
  }

  OgvIntroduction._();

  factory OgvIntroduction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OgvIntroduction()..mergeFromBuffer(data, registry);
  factory OgvIntroduction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OgvIntroduction()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OgvIntroduction',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: OgvIntroduction.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'followers')
    ..aOS(2, _omitFieldNames ? '' : 'score')
    ..aOM<StatInfo>(3, _omitFieldNames ? '' : 'playData',
        subBuilder: StatInfo.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'scoreColor')
    ..aOS(5, _omitFieldNames ? '' : 'scoreNightColor')
    ..aOS(6, _omitFieldNames ? '' : 'textColor')
    ..aOS(7, _omitFieldNames ? '' : 'textNightColor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OgvIntroduction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OgvIntroduction copyWith(void Function(OgvIntroduction) updates) =>
      super.copyWith((message) => updates(message as OgvIntroduction))
          as OgvIntroduction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OgvIntroduction() / OgvIntroduction.new instead')
  static OgvIntroduction create() => OgvIntroduction._();
  static $pb.GeneratedMessage $_createMessage() => OgvIntroduction._();
  @$core.override
  OgvIntroduction createEmptyInstance() => OgvIntroduction._();
  @$core.pragma('dart2js:noInline')
  static OgvIntroduction getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OgvIntroduction>(
          OgvIntroduction.$_createMessage);
  static OgvIntroduction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get followers => $_getSZ(0);
  @$pb.TagNumber(1)
  set followers($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFollowers() => $_has(0);
  @$pb.TagNumber(1)
  void clearFollowers() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get score => $_getSZ(1);
  @$pb.TagNumber(2)
  set score($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScore() => $_has(1);
  @$pb.TagNumber(2)
  void clearScore() => $_clearField(2);

  @$pb.TagNumber(3)
  StatInfo get playData => $_getN(2);
  @$pb.TagNumber(3)
  set playData(StatInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPlayData() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlayData() => $_clearField(3);
  @$pb.TagNumber(3)
  StatInfo ensurePlayData() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get scoreColor => $_getSZ(3);
  @$pb.TagNumber(4)
  set scoreColor($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScoreColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearScoreColor() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get scoreNightColor => $_getSZ(4);
  @$pb.TagNumber(5)
  set scoreNightColor($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasScoreNightColor() => $_has(4);
  @$pb.TagNumber(5)
  void clearScoreNightColor() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get textColor => $_getSZ(5);
  @$pb.TagNumber(6)
  set textColor($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTextColor() => $_has(5);
  @$pb.TagNumber(6)
  void clearTextColor() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get textNightColor => $_getSZ(6);
  @$pb.TagNumber(7)
  set textNightColor($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTextNightColor() => $_has(6);
  @$pb.TagNumber(7)
  void clearTextNightColor() => $_clearField(7);
}

class OgvLiveReserve extends $pb.GeneratedMessage {
  factory OgvLiveReserve({
    $fixnum.Int64? reserveId,
    $core.String? title,
    $core.String? icon,
    $core.String? nightIcon,
    $core.String? clickButton,
    $core.String? link,
    $core.int? followVideoIsReserveLive,
    $core.String? bgColor,
    $core.String? nightBgColor,
    $core.String? textColor,
    $core.String? nightTextColor,
    $core.String? btBgColor,
    $core.String? btFrameColor,
    $core.String? nightBtBgColor,
    $core.String? nightBtFrameColor,
    $core.int? activeType,
    $core.int? reserveStatus,
    $core.String? btTextColor,
    $core.String? nightBtTextColor,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
    $core.int? liveStatus,
  }) {
    final result = OgvLiveReserve._();
    if (reserveId != null) result.reserveId = reserveId;
    if (title != null) result.title = title;
    if (icon != null) result.icon = icon;
    if (nightIcon != null) result.nightIcon = nightIcon;
    if (clickButton != null) result.clickButton = clickButton;
    if (link != null) result.link = link;
    if (followVideoIsReserveLive != null)
      result.followVideoIsReserveLive = followVideoIsReserveLive;
    if (bgColor != null) result.bgColor = bgColor;
    if (nightBgColor != null) result.nightBgColor = nightBgColor;
    if (textColor != null) result.textColor = textColor;
    if (nightTextColor != null) result.nightTextColor = nightTextColor;
    if (btBgColor != null) result.btBgColor = btBgColor;
    if (btFrameColor != null) result.btFrameColor = btFrameColor;
    if (nightBtBgColor != null) result.nightBtBgColor = nightBtBgColor;
    if (nightBtFrameColor != null) result.nightBtFrameColor = nightBtFrameColor;
    if (activeType != null) result.activeType = activeType;
    if (reserveStatus != null) result.reserveStatus = reserveStatus;
    if (btTextColor != null) result.btTextColor = btTextColor;
    if (nightBtTextColor != null) result.nightBtTextColor = nightBtTextColor;
    if (report != null) result.report.addEntries(report);
    if (liveStatus != null) result.liveStatus = liveStatus;
    return result;
  }

  OgvLiveReserve._();

  factory OgvLiveReserve.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OgvLiveReserve()..mergeFromBuffer(data, registry);
  factory OgvLiveReserve.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OgvLiveReserve()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OgvLiveReserve',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: OgvLiveReserve.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'reserveId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'icon')
    ..aOS(4, _omitFieldNames ? '' : 'nightIcon')
    ..aOS(5, _omitFieldNames ? '' : 'clickButton')
    ..aOS(6, _omitFieldNames ? '' : 'link')
    ..aI(7, _omitFieldNames ? '' : 'followVideoIsReserveLive')
    ..aOS(8, _omitFieldNames ? '' : 'bgColor')
    ..aOS(9, _omitFieldNames ? '' : 'nightBgColor')
    ..aOS(10, _omitFieldNames ? '' : 'textColor')
    ..aOS(11, _omitFieldNames ? '' : 'nightTextColor')
    ..aOS(12, _omitFieldNames ? '' : 'btBgColor')
    ..aOS(13, _omitFieldNames ? '' : 'btFrameColor')
    ..aOS(14, _omitFieldNames ? '' : 'nightBtBgColor')
    ..aOS(15, _omitFieldNames ? '' : 'nightBtFrameColor')
    ..aI(16, _omitFieldNames ? '' : 'activeType')
    ..aI(17, _omitFieldNames ? '' : 'reserveStatus')
    ..aOS(18, _omitFieldNames ? '' : 'btTextColor')
    ..aOS(19, _omitFieldNames ? '' : 'nightBtTextColor')
    ..m<$core.String, $core.String>(20, _omitFieldNames ? '' : 'report',
        entryClassName: 'OgvLiveReserve.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..aI(21, _omitFieldNames ? '' : 'liveStatus')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OgvLiveReserve clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OgvLiveReserve copyWith(void Function(OgvLiveReserve) updates) =>
      super.copyWith((message) => updates(message as OgvLiveReserve))
          as OgvLiveReserve;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OgvLiveReserve() / OgvLiveReserve.new instead')
  static OgvLiveReserve create() => OgvLiveReserve._();
  static $pb.GeneratedMessage $_createMessage() => OgvLiveReserve._();
  @$core.override
  OgvLiveReserve createEmptyInstance() => OgvLiveReserve._();
  @$core.pragma('dart2js:noInline')
  static OgvLiveReserve getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OgvLiveReserve>(
          OgvLiveReserve.$_createMessage);
  static OgvLiveReserve? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get reserveId => $_getI64(0);
  @$pb.TagNumber(1)
  set reserveId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReserveId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReserveId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get icon => $_getSZ(2);
  @$pb.TagNumber(3)
  set icon($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearIcon() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get nightIcon => $_getSZ(3);
  @$pb.TagNumber(4)
  set nightIcon($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNightIcon() => $_has(3);
  @$pb.TagNumber(4)
  void clearNightIcon() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get clickButton => $_getSZ(4);
  @$pb.TagNumber(5)
  set clickButton($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasClickButton() => $_has(4);
  @$pb.TagNumber(5)
  void clearClickButton() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get link => $_getSZ(5);
  @$pb.TagNumber(6)
  set link($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLink() => $_has(5);
  @$pb.TagNumber(6)
  void clearLink() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get followVideoIsReserveLive => $_getIZ(6);
  @$pb.TagNumber(7)
  set followVideoIsReserveLive($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFollowVideoIsReserveLive() => $_has(6);
  @$pb.TagNumber(7)
  void clearFollowVideoIsReserveLive() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get bgColor => $_getSZ(7);
  @$pb.TagNumber(8)
  set bgColor($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBgColor() => $_has(7);
  @$pb.TagNumber(8)
  void clearBgColor() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get nightBgColor => $_getSZ(8);
  @$pb.TagNumber(9)
  set nightBgColor($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasNightBgColor() => $_has(8);
  @$pb.TagNumber(9)
  void clearNightBgColor() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get textColor => $_getSZ(9);
  @$pb.TagNumber(10)
  set textColor($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTextColor() => $_has(9);
  @$pb.TagNumber(10)
  void clearTextColor() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get nightTextColor => $_getSZ(10);
  @$pb.TagNumber(11)
  set nightTextColor($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasNightTextColor() => $_has(10);
  @$pb.TagNumber(11)
  void clearNightTextColor() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get btBgColor => $_getSZ(11);
  @$pb.TagNumber(12)
  set btBgColor($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasBtBgColor() => $_has(11);
  @$pb.TagNumber(12)
  void clearBtBgColor() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get btFrameColor => $_getSZ(12);
  @$pb.TagNumber(13)
  set btFrameColor($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasBtFrameColor() => $_has(12);
  @$pb.TagNumber(13)
  void clearBtFrameColor() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get nightBtBgColor => $_getSZ(13);
  @$pb.TagNumber(14)
  set nightBtBgColor($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasNightBtBgColor() => $_has(13);
  @$pb.TagNumber(14)
  void clearNightBtBgColor() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get nightBtFrameColor => $_getSZ(14);
  @$pb.TagNumber(15)
  set nightBtFrameColor($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasNightBtFrameColor() => $_has(14);
  @$pb.TagNumber(15)
  void clearNightBtFrameColor() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.int get activeType => $_getIZ(15);
  @$pb.TagNumber(16)
  set activeType($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasActiveType() => $_has(15);
  @$pb.TagNumber(16)
  void clearActiveType() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.int get reserveStatus => $_getIZ(16);
  @$pb.TagNumber(17)
  set reserveStatus($core.int value) => $_setSignedInt32(16, value);
  @$pb.TagNumber(17)
  $core.bool hasReserveStatus() => $_has(16);
  @$pb.TagNumber(17)
  void clearReserveStatus() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get btTextColor => $_getSZ(17);
  @$pb.TagNumber(18)
  set btTextColor($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasBtTextColor() => $_has(17);
  @$pb.TagNumber(18)
  void clearBtTextColor() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get nightBtTextColor => $_getSZ(18);
  @$pb.TagNumber(19)
  set nightBtTextColor($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasNightBtTextColor() => $_has(18);
  @$pb.TagNumber(19)
  void clearNightBtTextColor() => $_clearField(19);

  @$pb.TagNumber(20)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(19);

  @$pb.TagNumber(21)
  $core.int get liveStatus => $_getIZ(20);
  @$pb.TagNumber(21)
  set liveStatus($core.int value) => $_setSignedInt32(20, value);
  @$pb.TagNumber(21)
  $core.bool hasLiveStatus() => $_has(20);
  @$pb.TagNumber(21)
  void clearLiveStatus() => $_clearField(21);
}

class OgvSeasons extends $pb.GeneratedMessage {
  factory OgvSeasons({
    $core.String? title,
    $core.Iterable<SerialSeason>? serialSeason,
    SerialSeasonCoverStyle? style,
  }) {
    final result = OgvSeasons._();
    if (title != null) result.title = title;
    if (serialSeason != null) result.serialSeason.addAll(serialSeason);
    if (style != null) result.style = style;
    return result;
  }

  OgvSeasons._();

  factory OgvSeasons.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OgvSeasons()..mergeFromBuffer(data, registry);
  factory OgvSeasons.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OgvSeasons()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OgvSeasons',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: OgvSeasons.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..pPM<SerialSeason>(2, _omitFieldNames ? '' : 'serialSeason',
        subBuilder: SerialSeason.$_createMessage)
    ..aE<SerialSeasonCoverStyle>(3, _omitFieldNames ? '' : 'style',
        enumValues: SerialSeasonCoverStyle.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OgvSeasons clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OgvSeasons copyWith(void Function(OgvSeasons) updates) =>
      super.copyWith((message) => updates(message as OgvSeasons)) as OgvSeasons;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OgvSeasons() / OgvSeasons.new instead')
  static OgvSeasons create() => OgvSeasons._();
  static $pb.GeneratedMessage $_createMessage() => OgvSeasons._();
  @$core.override
  OgvSeasons createEmptyInstance() => OgvSeasons._();
  @$core.pragma('dart2js:noInline')
  static OgvSeasons getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OgvSeasons>(OgvSeasons.$_createMessage);
  static OgvSeasons? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<SerialSeason> get serialSeason => $_getList(1);

  @$pb.TagNumber(3)
  SerialSeasonCoverStyle get style => $_getN(2);
  @$pb.TagNumber(3)
  set style(SerialSeasonCoverStyle value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStyle() => $_has(2);
  @$pb.TagNumber(3)
  void clearStyle() => $_clearField(3);
}

class OgvTitle extends $pb.GeneratedMessage {
  factory OgvTitle({
    $core.String? title,
    BadgeInfo? badgeInfo,
    $core.int? isShowBtnAnimation,
    $core.int? followVideoIsReserveLive,
    $fixnum.Int64? reserveId,
    TitleDeliveryButton? titleDeliveryButton,
    TitleDeliveryButton? channelRedirectEntryButton,
    $core.String? titleImg,
    $core.String? titleImgNight,
    $core.int? webpDynamicPicTitleCycleNum,
  }) {
    final result = OgvTitle._();
    if (title != null) result.title = title;
    if (badgeInfo != null) result.badgeInfo = badgeInfo;
    if (isShowBtnAnimation != null)
      result.isShowBtnAnimation = isShowBtnAnimation;
    if (followVideoIsReserveLive != null)
      result.followVideoIsReserveLive = followVideoIsReserveLive;
    if (reserveId != null) result.reserveId = reserveId;
    if (titleDeliveryButton != null)
      result.titleDeliveryButton = titleDeliveryButton;
    if (channelRedirectEntryButton != null)
      result.channelRedirectEntryButton = channelRedirectEntryButton;
    if (titleImg != null) result.titleImg = titleImg;
    if (titleImgNight != null) result.titleImgNight = titleImgNight;
    if (webpDynamicPicTitleCycleNum != null)
      result.webpDynamicPicTitleCycleNum = webpDynamicPicTitleCycleNum;
    return result;
  }

  OgvTitle._();

  factory OgvTitle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OgvTitle()..mergeFromBuffer(data, registry);
  factory OgvTitle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OgvTitle()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OgvTitle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: OgvTitle.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOM<BadgeInfo>(2, _omitFieldNames ? '' : 'badgeInfo',
        subBuilder: BadgeInfo.$_createMessage)
    ..aI(3, _omitFieldNames ? '' : 'isShowBtnAnimation')
    ..aI(4, _omitFieldNames ? '' : 'followVideoIsReserveLive')
    ..aInt64(5, _omitFieldNames ? '' : 'reserveId')
    ..aOM<TitleDeliveryButton>(6, _omitFieldNames ? '' : 'titleDeliveryButton',
        subBuilder: TitleDeliveryButton.$_createMessage)
    ..aOM<TitleDeliveryButton>(
        7, _omitFieldNames ? '' : 'channelRedirectEntryButton',
        subBuilder: TitleDeliveryButton.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'titleImg')
    ..aOS(9, _omitFieldNames ? '' : 'titleImgNight')
    ..aI(10, _omitFieldNames ? '' : 'webpDynamicPicTitleCycleNum')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OgvTitle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OgvTitle copyWith(void Function(OgvTitle) updates) =>
      super.copyWith((message) => updates(message as OgvTitle)) as OgvTitle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OgvTitle() / OgvTitle.new instead')
  static OgvTitle create() => OgvTitle._();
  static $pb.GeneratedMessage $_createMessage() => OgvTitle._();
  @$core.override
  OgvTitle createEmptyInstance() => OgvTitle._();
  @$core.pragma('dart2js:noInline')
  static OgvTitle getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OgvTitle>(OgvTitle.$_createMessage);
  static OgvTitle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  BadgeInfo get badgeInfo => $_getN(1);
  @$pb.TagNumber(2)
  set badgeInfo(BadgeInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasBadgeInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearBadgeInfo() => $_clearField(2);
  @$pb.TagNumber(2)
  BadgeInfo ensureBadgeInfo() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get isShowBtnAnimation => $_getIZ(2);
  @$pb.TagNumber(3)
  set isShowBtnAnimation($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsShowBtnAnimation() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsShowBtnAnimation() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get followVideoIsReserveLive => $_getIZ(3);
  @$pb.TagNumber(4)
  set followVideoIsReserveLive($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFollowVideoIsReserveLive() => $_has(3);
  @$pb.TagNumber(4)
  void clearFollowVideoIsReserveLive() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get reserveId => $_getI64(4);
  @$pb.TagNumber(5)
  set reserveId($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReserveId() => $_has(4);
  @$pb.TagNumber(5)
  void clearReserveId() => $_clearField(5);

  @$pb.TagNumber(6)
  TitleDeliveryButton get titleDeliveryButton => $_getN(5);
  @$pb.TagNumber(6)
  set titleDeliveryButton(TitleDeliveryButton value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasTitleDeliveryButton() => $_has(5);
  @$pb.TagNumber(6)
  void clearTitleDeliveryButton() => $_clearField(6);
  @$pb.TagNumber(6)
  TitleDeliveryButton ensureTitleDeliveryButton() => $_ensure(5);

  @$pb.TagNumber(7)
  TitleDeliveryButton get channelRedirectEntryButton => $_getN(6);
  @$pb.TagNumber(7)
  set channelRedirectEntryButton(TitleDeliveryButton value) =>
      $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasChannelRedirectEntryButton() => $_has(6);
  @$pb.TagNumber(7)
  void clearChannelRedirectEntryButton() => $_clearField(7);
  @$pb.TagNumber(7)
  TitleDeliveryButton ensureChannelRedirectEntryButton() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get titleImg => $_getSZ(7);
  @$pb.TagNumber(8)
  set titleImg($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTitleImg() => $_has(7);
  @$pb.TagNumber(8)
  void clearTitleImg() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get titleImgNight => $_getSZ(8);
  @$pb.TagNumber(9)
  set titleImgNight($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTitleImgNight() => $_has(8);
  @$pb.TagNumber(9)
  void clearTitleImgNight() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get webpDynamicPicTitleCycleNum => $_getIZ(9);
  @$pb.TagNumber(10)
  set webpDynamicPicTitleCycleNum($core.int value) =>
      $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasWebpDynamicPicTitleCycleNum() => $_has(9);
  @$pb.TagNumber(10)
  void clearWebpDynamicPicTitleCycleNum() => $_clearField(10);
}

class OperateAction extends $pb.GeneratedMessage {
  factory OperateAction({
    $core.String? action,
    $core.String? link,
  }) {
    final result = OperateAction._();
    if (action != null) result.action = action;
    if (link != null) result.link = link;
    return result;
  }

  OperateAction._();

  factory OperateAction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OperateAction()..mergeFromBuffer(data, registry);
  factory OperateAction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OperateAction()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OperateAction',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: OperateAction.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'action')
    ..aOS(2, _omitFieldNames ? '' : 'link')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperateAction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperateAction copyWith(void Function(OperateAction) updates) =>
      super.copyWith((message) => updates(message as OperateAction))
          as OperateAction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OperateAction() / OperateAction.new instead')
  static OperateAction create() => OperateAction._();
  static $pb.GeneratedMessage $_createMessage() => OperateAction._();
  @$core.override
  OperateAction createEmptyInstance() => OperateAction._();
  @$core.pragma('dart2js:noInline')
  static OperateAction getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OperateAction>(
          OperateAction.$_createMessage);
  static OperateAction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get action => $_getSZ(0);
  @$pb.TagNumber(1)
  set action($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAction() => $_has(0);
  @$pb.TagNumber(1)
  void clearAction() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get link => $_getSZ(1);
  @$pb.TagNumber(2)
  set link($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLink() => $_has(1);
  @$pb.TagNumber(2)
  void clearLink() => $_clearField(2);
}

class Owner extends $pb.GeneratedMessage {
  factory Owner({
    $1.AvatarItem? avatar,
    $core.String? url,
    $core.String? title,
    $core.String? fans,
    $core.String? arcCount,
    AttentionRelationStatus? attention,
    AttentionRelationStatus? attentionRelation,
    $core.String? pubLocation,
    Vip? vip,
    $core.String? titleUrl,
    $core.String? face,
    $fixnum.Int64? mid,
    OfficialVerify? officialVerify,
    Live? live,
    $fixnum.Int64? fansNum,
    $core.Iterable<$fixnum.Int64>? assists,
    $core.String? seasonCount,
    $2.NameRender? nameRender,
  }) {
    final result = Owner._();
    if (avatar != null) result.avatar = avatar;
    if (url != null) result.url = url;
    if (title != null) result.title = title;
    if (fans != null) result.fans = fans;
    if (arcCount != null) result.arcCount = arcCount;
    if (attention != null) result.attention = attention;
    if (attentionRelation != null) result.attentionRelation = attentionRelation;
    if (pubLocation != null) result.pubLocation = pubLocation;
    if (vip != null) result.vip = vip;
    if (titleUrl != null) result.titleUrl = titleUrl;
    if (face != null) result.face = face;
    if (mid != null) result.mid = mid;
    if (officialVerify != null) result.officialVerify = officialVerify;
    if (live != null) result.live = live;
    if (fansNum != null) result.fansNum = fansNum;
    if (assists != null) result.assists.addAll(assists);
    if (seasonCount != null) result.seasonCount = seasonCount;
    if (nameRender != null) result.nameRender = nameRender;
    return result;
  }

  Owner._();

  factory Owner.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Owner()..mergeFromBuffer(data, registry);
  factory Owner.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Owner()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Owner',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Owner.$_createMessage)
    ..aOM<$1.AvatarItem>(1, _omitFieldNames ? '' : 'avatar',
        subBuilder: $1.AvatarItem.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'fans')
    ..aOS(5, _omitFieldNames ? '' : 'arcCount')
    ..aE<AttentionRelationStatus>(6, _omitFieldNames ? '' : 'attention',
        enumValues: AttentionRelationStatus.values)
    ..aE<AttentionRelationStatus>(7, _omitFieldNames ? '' : 'attentionRelation',
        enumValues: AttentionRelationStatus.values)
    ..aOS(8, _omitFieldNames ? '' : 'pubLocation')
    ..aOM<Vip>(9, _omitFieldNames ? '' : 'vip', subBuilder: Vip.$_createMessage)
    ..aOS(10, _omitFieldNames ? '' : 'titleUrl')
    ..aOS(11, _omitFieldNames ? '' : 'face')
    ..aInt64(12, _omitFieldNames ? '' : 'mid')
    ..aOM<OfficialVerify>(13, _omitFieldNames ? '' : 'officialVerify',
        subBuilder: OfficialVerify.$_createMessage)
    ..aOM<Live>(14, _omitFieldNames ? '' : 'live',
        subBuilder: Live.$_createMessage)
    ..aInt64(15, _omitFieldNames ? '' : 'fansNum')
    ..p<$fixnum.Int64>(16, _omitFieldNames ? '' : 'assists', $pb.PbFieldType.K6)
    ..aOS(17, _omitFieldNames ? '' : 'seasonCount')
    ..aOM<$2.NameRender>(18, _omitFieldNames ? '' : 'nameRender',
        subBuilder: $2.NameRender.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Owner clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Owner copyWith(void Function(Owner) updates) =>
      super.copyWith((message) => updates(message as Owner)) as Owner;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Owner() / Owner.new instead')
  static Owner create() => Owner._();
  static $pb.GeneratedMessage $_createMessage() => Owner._();
  @$core.override
  Owner createEmptyInstance() => Owner._();
  @$core.pragma('dart2js:noInline')
  static Owner getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Owner>(Owner.$_createMessage);
  static Owner? _defaultInstance;

  @$pb.TagNumber(1)
  $1.AvatarItem get avatar => $_getN(0);
  @$pb.TagNumber(1)
  set avatar($1.AvatarItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAvatar() => $_has(0);
  @$pb.TagNumber(1)
  void clearAvatar() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.AvatarItem ensureAvatar() => $_ensure(0);

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
  $core.String get fans => $_getSZ(3);
  @$pb.TagNumber(4)
  set fans($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFans() => $_has(3);
  @$pb.TagNumber(4)
  void clearFans() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get arcCount => $_getSZ(4);
  @$pb.TagNumber(5)
  set arcCount($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasArcCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearArcCount() => $_clearField(5);

  @$pb.TagNumber(6)
  AttentionRelationStatus get attention => $_getN(5);
  @$pb.TagNumber(6)
  set attention(AttentionRelationStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAttention() => $_has(5);
  @$pb.TagNumber(6)
  void clearAttention() => $_clearField(6);

  @$pb.TagNumber(7)
  AttentionRelationStatus get attentionRelation => $_getN(6);
  @$pb.TagNumber(7)
  set attentionRelation(AttentionRelationStatus value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAttentionRelation() => $_has(6);
  @$pb.TagNumber(7)
  void clearAttentionRelation() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get pubLocation => $_getSZ(7);
  @$pb.TagNumber(8)
  set pubLocation($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPubLocation() => $_has(7);
  @$pb.TagNumber(8)
  void clearPubLocation() => $_clearField(8);

  @$pb.TagNumber(9)
  Vip get vip => $_getN(8);
  @$pb.TagNumber(9)
  set vip(Vip value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasVip() => $_has(8);
  @$pb.TagNumber(9)
  void clearVip() => $_clearField(9);
  @$pb.TagNumber(9)
  Vip ensureVip() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get titleUrl => $_getSZ(9);
  @$pb.TagNumber(10)
  set titleUrl($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTitleUrl() => $_has(9);
  @$pb.TagNumber(10)
  void clearTitleUrl() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get face => $_getSZ(10);
  @$pb.TagNumber(11)
  set face($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasFace() => $_has(10);
  @$pb.TagNumber(11)
  void clearFace() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get mid => $_getI64(11);
  @$pb.TagNumber(12)
  set mid($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasMid() => $_has(11);
  @$pb.TagNumber(12)
  void clearMid() => $_clearField(12);

  @$pb.TagNumber(13)
  OfficialVerify get officialVerify => $_getN(12);
  @$pb.TagNumber(13)
  set officialVerify(OfficialVerify value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasOfficialVerify() => $_has(12);
  @$pb.TagNumber(13)
  void clearOfficialVerify() => $_clearField(13);
  @$pb.TagNumber(13)
  OfficialVerify ensureOfficialVerify() => $_ensure(12);

  @$pb.TagNumber(14)
  Live get live => $_getN(13);
  @$pb.TagNumber(14)
  set live(Live value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasLive() => $_has(13);
  @$pb.TagNumber(14)
  void clearLive() => $_clearField(14);
  @$pb.TagNumber(14)
  Live ensureLive() => $_ensure(13);

  @$pb.TagNumber(15)
  $fixnum.Int64 get fansNum => $_getI64(14);
  @$pb.TagNumber(15)
  set fansNum($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(15)
  $core.bool hasFansNum() => $_has(14);
  @$pb.TagNumber(15)
  void clearFansNum() => $_clearField(15);

  @$pb.TagNumber(16)
  $pb.PbList<$fixnum.Int64> get assists => $_getList(15);

  @$pb.TagNumber(17)
  $core.String get seasonCount => $_getSZ(16);
  @$pb.TagNumber(17)
  set seasonCount($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasSeasonCount() => $_has(16);
  @$pb.TagNumber(17)
  void clearSeasonCount() => $_clearField(17);

  @$pb.TagNumber(18)
  $2.NameRender get nameRender => $_getN(17);
  @$pb.TagNumber(18)
  set nameRender($2.NameRender value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasNameRender() => $_has(17);
  @$pb.TagNumber(18)
  void clearNameRender() => $_clearField(18);
  @$pb.TagNumber(18)
  $2.NameRender ensureNameRender() => $_ensure(17);
}

class Page extends $pb.GeneratedMessage {
  factory Page({
    $fixnum.Int64? cid,
    $core.String? part,
    $fixnum.Int64? duration,
    $core.String? desc,
    Dimension? dimension,
    $core.String? dlTitle,
    $core.String? dlSubtitle,
  }) {
    final result = Page._();
    if (cid != null) result.cid = cid;
    if (part != null) result.part = part;
    if (duration != null) result.duration = duration;
    if (desc != null) result.desc = desc;
    if (dimension != null) result.dimension = dimension;
    if (dlTitle != null) result.dlTitle = dlTitle;
    if (dlSubtitle != null) result.dlSubtitle = dlSubtitle;
    return result;
  }

  Page._();

  factory Page.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Page()..mergeFromBuffer(data, registry);
  factory Page.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Page()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Page',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Page.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'cid')
    ..aOS(2, _omitFieldNames ? '' : 'part')
    ..aInt64(3, _omitFieldNames ? '' : 'duration')
    ..aOS(4, _omitFieldNames ? '' : 'desc')
    ..aOM<Dimension>(5, _omitFieldNames ? '' : 'dimension',
        subBuilder: Dimension.$_createMessage)
    ..aOS(6, _omitFieldNames ? '' : 'dlTitle')
    ..aOS(7, _omitFieldNames ? '' : 'dlSubtitle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Page clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Page copyWith(void Function(Page) updates) =>
      super.copyWith((message) => updates(message as Page)) as Page;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Page() / Page.new instead')
  static Page create() => Page._();
  static $pb.GeneratedMessage $_createMessage() => Page._();
  @$core.override
  Page createEmptyInstance() => Page._();
  @$core.pragma('dart2js:noInline')
  static Page getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Page>(Page.$_createMessage);
  static Page? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get cid => $_getI64(0);
  @$pb.TagNumber(1)
  set cid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get part => $_getSZ(1);
  @$pb.TagNumber(2)
  set part($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPart() => $_has(1);
  @$pb.TagNumber(2)
  void clearPart() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get duration => $_getI64(2);
  @$pb.TagNumber(3)
  set duration($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDuration() => $_has(2);
  @$pb.TagNumber(3)
  void clearDuration() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get desc => $_getSZ(3);
  @$pb.TagNumber(4)
  set desc($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDesc() => $_has(3);
  @$pb.TagNumber(4)
  void clearDesc() => $_clearField(4);

  @$pb.TagNumber(5)
  Dimension get dimension => $_getN(4);
  @$pb.TagNumber(5)
  set dimension(Dimension value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDimension() => $_has(4);
  @$pb.TagNumber(5)
  void clearDimension() => $_clearField(5);
  @$pb.TagNumber(5)
  Dimension ensureDimension() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get dlTitle => $_getSZ(5);
  @$pb.TagNumber(6)
  set dlTitle($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDlTitle() => $_has(5);
  @$pb.TagNumber(6)
  void clearDlTitle() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get dlSubtitle => $_getSZ(6);
  @$pb.TagNumber(7)
  set dlSubtitle($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDlSubtitle() => $_has(6);
  @$pb.TagNumber(7)
  void clearDlSubtitle() => $_clearField(7);
}

class Pendant extends $pb.GeneratedMessage {
  factory Pendant({
    $core.int? pid,
    $core.String? name,
    $core.String? image,
  }) {
    final result = Pendant._();
    if (pid != null) result.pid = pid;
    if (name != null) result.name = name;
    if (image != null) result.image = image;
    return result;
  }

  Pendant._();

  factory Pendant.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Pendant()..mergeFromBuffer(data, registry);
  factory Pendant.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Pendant()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Pendant',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Pendant.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'pid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'image')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Pendant clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Pendant copyWith(void Function(Pendant) updates) =>
      super.copyWith((message) => updates(message as Pendant)) as Pendant;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Pendant() / Pendant.new instead')
  static Pendant create() => Pendant._();
  static $pb.GeneratedMessage $_createMessage() => Pendant._();
  @$core.override
  Pendant createEmptyInstance() => Pendant._();
  @$core.pragma('dart2js:noInline')
  static Pendant getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Pendant>(Pendant.$_createMessage);
  static Pendant? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pid => $_getIZ(0);
  @$pb.TagNumber(1)
  set pid($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPid() => $_has(0);
  @$pb.TagNumber(1)
  void clearPid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get image => $_getSZ(2);
  @$pb.TagNumber(3)
  set image($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasImage() => $_has(2);
  @$pb.TagNumber(3)
  void clearImage() => $_clearField(3);
}

class PlayList extends $pb.GeneratedMessage {
  factory PlayList({
    $core.int? id,
    $core.String? title,
    Owner? upper,
    $core.String? desc,
    $core.String? moreTitle,
    $core.Iterable<PlayListSeason>? seasons,
    $core.bool? morePlaylist,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
    $core.String? morePlaylistUrl,
  }) {
    final result = PlayList._();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (upper != null) result.upper = upper;
    if (desc != null) result.desc = desc;
    if (moreTitle != null) result.moreTitle = moreTitle;
    if (seasons != null) result.seasons.addAll(seasons);
    if (morePlaylist != null) result.morePlaylist = morePlaylist;
    if (report != null) result.report.addEntries(report);
    if (morePlaylistUrl != null) result.morePlaylistUrl = morePlaylistUrl;
    return result;
  }

  PlayList._();

  factory PlayList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayList()..mergeFromBuffer(data, registry);
  factory PlayList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayList()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayList',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PlayList.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOM<Owner>(3, _omitFieldNames ? '' : 'upper',
        subBuilder: Owner.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'desc')
    ..aOS(5, _omitFieldNames ? '' : 'moreTitle')
    ..pPM<PlayListSeason>(6, _omitFieldNames ? '' : 'seasons',
        subBuilder: PlayListSeason.$_createMessage)
    ..aOB(7, _omitFieldNames ? '' : 'morePlaylist')
    ..m<$core.String, $core.String>(8, _omitFieldNames ? '' : 'report',
        entryClassName: 'PlayList.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..aOS(9, _omitFieldNames ? '' : 'morePlaylistUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayList copyWith(void Function(PlayList) updates) =>
      super.copyWith((message) => updates(message as PlayList)) as PlayList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PlayList() / PlayList.new instead')
  static PlayList create() => PlayList._();
  static $pb.GeneratedMessage $_createMessage() => PlayList._();
  @$core.override
  PlayList createEmptyInstance() => PlayList._();
  @$core.pragma('dart2js:noInline')
  static PlayList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlayList>(PlayList.$_createMessage);
  static PlayList? _defaultInstance;

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
  Owner get upper => $_getN(2);
  @$pb.TagNumber(3)
  set upper(Owner value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUpper() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpper() => $_clearField(3);
  @$pb.TagNumber(3)
  Owner ensureUpper() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get desc => $_getSZ(3);
  @$pb.TagNumber(4)
  set desc($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDesc() => $_has(3);
  @$pb.TagNumber(4)
  void clearDesc() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get moreTitle => $_getSZ(4);
  @$pb.TagNumber(5)
  set moreTitle($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMoreTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearMoreTitle() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<PlayListSeason> get seasons => $_getList(5);

  @$pb.TagNumber(7)
  $core.bool get morePlaylist => $_getBF(6);
  @$pb.TagNumber(7)
  set morePlaylist($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMorePlaylist() => $_has(6);
  @$pb.TagNumber(7)
  void clearMorePlaylist() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(7);

  @$pb.TagNumber(9)
  $core.String get morePlaylistUrl => $_getSZ(8);
  @$pb.TagNumber(9)
  set morePlaylistUrl($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMorePlaylistUrl() => $_has(8);
  @$pb.TagNumber(9)
  void clearMorePlaylistUrl() => $_clearField(9);
}

class PlayListSeason extends $pb.GeneratedMessage {
  factory PlayListSeason({
    $core.int? seasonId,
    $core.String? title,
    $core.String? subtitle,
    $core.String? cover,
    $core.String? link,
    $core.String? score,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
  }) {
    final result = PlayListSeason._();
    if (seasonId != null) result.seasonId = seasonId;
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    if (cover != null) result.cover = cover;
    if (link != null) result.link = link;
    if (score != null) result.score = score;
    if (report != null) result.report.addEntries(report);
    return result;
  }

  PlayListSeason._();

  factory PlayListSeason.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayListSeason()..mergeFromBuffer(data, registry);
  factory PlayListSeason.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayListSeason()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayListSeason',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PlayListSeason.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'seasonId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'subtitle')
    ..aOS(4, _omitFieldNames ? '' : 'cover')
    ..aOS(5, _omitFieldNames ? '' : 'link')
    ..aOS(6, _omitFieldNames ? '' : 'score')
    ..m<$core.String, $core.String>(7, _omitFieldNames ? '' : 'report',
        entryClassName: 'PlayListSeason.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayListSeason clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayListSeason copyWith(void Function(PlayListSeason) updates) =>
      super.copyWith((message) => updates(message as PlayListSeason))
          as PlayListSeason;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PlayListSeason() / PlayListSeason.new instead')
  static PlayListSeason create() => PlayListSeason._();
  static $pb.GeneratedMessage $_createMessage() => PlayListSeason._();
  @$core.override
  PlayListSeason createEmptyInstance() => PlayListSeason._();
  @$core.pragma('dart2js:noInline')
  static PlayListSeason getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayListSeason>(
          PlayListSeason.$_createMessage);
  static PlayListSeason? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seasonId => $_getIZ(0);
  @$pb.TagNumber(1)
  set seasonId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeasonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeasonId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get subtitle => $_getSZ(2);
  @$pb.TagNumber(3)
  set subtitle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubtitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubtitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get cover => $_getSZ(3);
  @$pb.TagNumber(4)
  set cover($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCover() => $_has(3);
  @$pb.TagNumber(4)
  void clearCover() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get link => $_getSZ(4);
  @$pb.TagNumber(5)
  set link($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLink() => $_has(4);
  @$pb.TagNumber(5)
  void clearLink() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get score => $_getSZ(5);
  @$pb.TagNumber(6)
  set score($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasScore() => $_has(5);
  @$pb.TagNumber(6)
  void clearScore() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(6);
}

class PlayerAnimation extends $pb.GeneratedMessage {
  factory PlayerAnimation({
    $core.String? playerIcon,
    $core.String? playerTripleIcon,
  }) {
    final result = PlayerAnimation._();
    if (playerIcon != null) result.playerIcon = playerIcon;
    if (playerTripleIcon != null) result.playerTripleIcon = playerTripleIcon;
    return result;
  }

  PlayerAnimation._();

  factory PlayerAnimation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayerAnimation()..mergeFromBuffer(data, registry);
  factory PlayerAnimation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlayerAnimation()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlayerAnimation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PlayerAnimation.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'playerIcon')
    ..aOS(2, _omitFieldNames ? '' : 'playerTripleIcon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerAnimation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlayerAnimation copyWith(void Function(PlayerAnimation) updates) =>
      super.copyWith((message) => updates(message as PlayerAnimation))
          as PlayerAnimation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PlayerAnimation() / PlayerAnimation.new instead')
  static PlayerAnimation create() => PlayerAnimation._();
  static $pb.GeneratedMessage $_createMessage() => PlayerAnimation._();
  @$core.override
  PlayerAnimation createEmptyInstance() => PlayerAnimation._();
  @$core.pragma('dart2js:noInline')
  static PlayerAnimation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayerAnimation>(
          PlayerAnimation.$_createMessage);
  static PlayerAnimation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get playerIcon => $_getSZ(0);
  @$pb.TagNumber(1)
  set playerIcon($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlayerIcon() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayerIcon() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get playerTripleIcon => $_getSZ(1);
  @$pb.TagNumber(2)
  set playerTripleIcon($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlayerTripleIcon() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayerTripleIcon() => $_clearField(2);
}

class PointActivity extends $pb.GeneratedMessage {
  factory PointActivity({
    $core.String? tip,
    $core.String? content,
    $core.String? link,
  }) {
    final result = PointActivity._();
    if (tip != null) result.tip = tip;
    if (content != null) result.content = content;
    if (link != null) result.link = link;
    return result;
  }

  PointActivity._();

  factory PointActivity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PointActivity()..mergeFromBuffer(data, registry);
  factory PointActivity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PointActivity()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PointActivity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PointActivity.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'tip')
    ..aOS(2, _omitFieldNames ? '' : 'content')
    ..aOS(3, _omitFieldNames ? '' : 'link')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PointActivity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PointActivity copyWith(void Function(PointActivity) updates) =>
      super.copyWith((message) => updates(message as PointActivity))
          as PointActivity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PointActivity() / PointActivity.new instead')
  static PointActivity create() => PointActivity._();
  static $pb.GeneratedMessage $_createMessage() => PointActivity._();
  @$core.override
  PointActivity createEmptyInstance() => PointActivity._();
  @$core.pragma('dart2js:noInline')
  static PointActivity getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PointActivity>(
          PointActivity.$_createMessage);
  static PointActivity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tip => $_getSZ(0);
  @$pb.TagNumber(1)
  set tip($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTip() => $_has(0);
  @$pb.TagNumber(1)
  void clearTip() => $_clearField(1);

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

class PowerIconStyle extends $pb.GeneratedMessage {
  factory PowerIconStyle({
    $core.String? iconUrl,
    $core.String? iconNightUrl,
    $fixnum.Int64? iconWidth,
    $fixnum.Int64? iconHeight,
  }) {
    final result = PowerIconStyle._();
    if (iconUrl != null) result.iconUrl = iconUrl;
    if (iconNightUrl != null) result.iconNightUrl = iconNightUrl;
    if (iconWidth != null) result.iconWidth = iconWidth;
    if (iconHeight != null) result.iconHeight = iconHeight;
    return result;
  }

  PowerIconStyle._();

  factory PowerIconStyle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PowerIconStyle()..mergeFromBuffer(data, registry);
  factory PowerIconStyle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PowerIconStyle()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PowerIconStyle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PowerIconStyle.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'iconUrl')
    ..aOS(2, _omitFieldNames ? '' : 'iconNightUrl')
    ..aInt64(3, _omitFieldNames ? '' : 'iconWidth')
    ..aInt64(4, _omitFieldNames ? '' : 'iconHeight')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PowerIconStyle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PowerIconStyle copyWith(void Function(PowerIconStyle) updates) =>
      super.copyWith((message) => updates(message as PowerIconStyle))
          as PowerIconStyle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PowerIconStyle() / PowerIconStyle.new instead')
  static PowerIconStyle create() => PowerIconStyle._();
  static $pb.GeneratedMessage $_createMessage() => PowerIconStyle._();
  @$core.override
  PowerIconStyle createEmptyInstance() => PowerIconStyle._();
  @$core.pragma('dart2js:noInline')
  static PowerIconStyle getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PowerIconStyle>(
          PowerIconStyle.$_createMessage);
  static PowerIconStyle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get iconUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set iconUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIconUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearIconUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get iconNightUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set iconNightUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIconNightUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearIconNightUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get iconWidth => $_getI64(2);
  @$pb.TagNumber(3)
  set iconWidth($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIconWidth() => $_has(2);
  @$pb.TagNumber(3)
  void clearIconWidth() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get iconHeight => $_getI64(3);
  @$pb.TagNumber(4)
  set iconHeight($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIconHeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearIconHeight() => $_clearField(4);
}

class ProfessionApproval extends $pb.GeneratedMessage {
  factory ProfessionApproval({
    $core.String? title,
    $core.String? subtitle,
    $core.int? type,
  }) {
    final result = ProfessionApproval._();
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    if (type != null) result.type = type;
    return result;
  }

  ProfessionApproval._();

  factory ProfessionApproval.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfessionApproval()..mergeFromBuffer(data, registry);
  factory ProfessionApproval.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfessionApproval()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfessionApproval',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ProfessionApproval.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'subtitle')
    ..aI(3, _omitFieldNames ? '' : 'type')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfessionApproval clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfessionApproval copyWith(void Function(ProfessionApproval) updates) =>
      super.copyWith((message) => updates(message as ProfessionApproval))
          as ProfessionApproval;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ProfessionApproval() / ProfessionApproval.new instead')
  static ProfessionApproval create() => ProfessionApproval._();
  static $pb.GeneratedMessage $_createMessage() => ProfessionApproval._();
  @$core.override
  ProfessionApproval createEmptyInstance() => ProfessionApproval._();
  @$core.pragma('dart2js:noInline')
  static ProfessionApproval getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProfessionApproval>(
          ProfessionApproval.$_createMessage);
  static ProfessionApproval? _defaultInstance;

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
  $core.int get type => $_getIZ(2);
  @$pb.TagNumber(3)
  set type($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);
}

class ProfessionHonorExtend extends $pb.GeneratedMessage {
  factory ProfessionHonorExtend({
    $fixnum.Int64? count,
    $core.bool? selfGrant,
    ProfessionPopup? popup,
  }) {
    final result = ProfessionHonorExtend._();
    if (count != null) result.count = count;
    if (selfGrant != null) result.selfGrant = selfGrant;
    if (popup != null) result.popup = popup;
    return result;
  }

  ProfessionHonorExtend._();

  factory ProfessionHonorExtend.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfessionHonorExtend()..mergeFromBuffer(data, registry);
  factory ProfessionHonorExtend.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfessionHonorExtend()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfessionHonorExtend',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ProfessionHonorExtend.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'count')
    ..aOB(2, _omitFieldNames ? '' : 'selfGrant')
    ..aOM<ProfessionPopup>(3, _omitFieldNames ? '' : 'popup',
        subBuilder: ProfessionPopup.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfessionHonorExtend clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfessionHonorExtend copyWith(
          void Function(ProfessionHonorExtend) updates) =>
      super.copyWith((message) => updates(message as ProfessionHonorExtend))
          as ProfessionHonorExtend;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProfessionHonorExtend() / ProfessionHonorExtend.new instead')
  static ProfessionHonorExtend create() => ProfessionHonorExtend._();
  static $pb.GeneratedMessage $_createMessage() => ProfessionHonorExtend._();
  @$core.override
  ProfessionHonorExtend createEmptyInstance() => ProfessionHonorExtend._();
  @$core.pragma('dart2js:noInline')
  static ProfessionHonorExtend getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProfessionHonorExtend>(
          ProfessionHonorExtend.$_createMessage);
  static ProfessionHonorExtend? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get count => $_getI64(0);
  @$pb.TagNumber(1)
  set count($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get selfGrant => $_getBF(1);
  @$pb.TagNumber(2)
  set selfGrant($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSelfGrant() => $_has(1);
  @$pb.TagNumber(2)
  void clearSelfGrant() => $_clearField(2);

  @$pb.TagNumber(3)
  ProfessionPopup get popup => $_getN(2);
  @$pb.TagNumber(3)
  set popup(ProfessionPopup value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPopup() => $_has(2);
  @$pb.TagNumber(3)
  void clearPopup() => $_clearField(3);
  @$pb.TagNumber(3)
  ProfessionPopup ensurePopup() => $_ensure(2);
}

class ProfessionPopup extends $pb.GeneratedMessage {
  factory ProfessionPopup({
    $core.String? title,
    $core.String? subtitle,
  }) {
    final result = ProfessionPopup._();
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    return result;
  }

  ProfessionPopup._();

  factory ProfessionPopup.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfessionPopup()..mergeFromBuffer(data, registry);
  factory ProfessionPopup.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfessionPopup()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfessionPopup',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ProfessionPopup.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'subtitle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfessionPopup clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfessionPopup copyWith(void Function(ProfessionPopup) updates) =>
      super.copyWith((message) => updates(message as ProfessionPopup))
          as ProfessionPopup;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ProfessionPopup() / ProfessionPopup.new instead')
  static ProfessionPopup create() => ProfessionPopup._();
  static $pb.GeneratedMessage $_createMessage() => ProfessionPopup._();
  @$core.override
  ProfessionPopup createEmptyInstance() => ProfessionPopup._();
  @$core.pragma('dart2js:noInline')
  static ProfessionPopup getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProfessionPopup>(
          ProfessionPopup.$_createMessage);
  static ProfessionPopup? _defaultInstance;

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
}

class PugvCooperationApplication extends $pb.GeneratedMessage {
  factory PugvCooperationApplication({
    $core.String? link,
    $core.String? title,
    $core.String? subtitle,
    $core.String? buttonText,
    $core.String? icon,
  }) {
    final result = PugvCooperationApplication._();
    if (link != null) result.link = link;
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    if (buttonText != null) result.buttonText = buttonText;
    if (icon != null) result.icon = icon;
    return result;
  }

  PugvCooperationApplication._();

  factory PugvCooperationApplication.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvCooperationApplication()..mergeFromBuffer(data, registry);
  factory PugvCooperationApplication.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvCooperationApplication()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvCooperationApplication',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvCooperationApplication.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'link')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'subtitle')
    ..aOS(4, _omitFieldNames ? '' : 'buttonText')
    ..aOS(5, _omitFieldNames ? '' : 'icon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvCooperationApplication clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvCooperationApplication copyWith(
          void Function(PugvCooperationApplication) updates) =>
      super.copyWith(
              (message) => updates(message as PugvCooperationApplication))
          as PugvCooperationApplication;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PugvCooperationApplication() / PugvCooperationApplication.new instead')
  static PugvCooperationApplication create() => PugvCooperationApplication._();
  static $pb.GeneratedMessage $_createMessage() =>
      PugvCooperationApplication._();
  @$core.override
  PugvCooperationApplication createEmptyInstance() =>
      PugvCooperationApplication._();
  @$core.pragma('dart2js:noInline')
  static PugvCooperationApplication getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvCooperationApplication>(
          PugvCooperationApplication.$_createMessage);
  static PugvCooperationApplication? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get link => $_getSZ(0);
  @$pb.TagNumber(1)
  set link($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLink() => $_has(0);
  @$pb.TagNumber(1)
  void clearLink() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get subtitle => $_getSZ(2);
  @$pb.TagNumber(3)
  set subtitle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubtitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubtitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get buttonText => $_getSZ(3);
  @$pb.TagNumber(4)
  set buttonText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasButtonText() => $_has(3);
  @$pb.TagNumber(4)
  void clearButtonText() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get icon => $_getSZ(4);
  @$pb.TagNumber(5)
  set icon($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIcon() => $_has(4);
  @$pb.TagNumber(5)
  void clearIcon() => $_clearField(5);
}

class PugvFaq extends $pb.GeneratedMessage {
  factory PugvFaq({
    PugvSeasonNav? nav,
    $core.Iterable<PugvFaqContent>? contents,
  }) {
    final result = PugvFaq._();
    if (nav != null) result.nav = nav;
    if (contents != null) result.contents.addAll(contents);
    return result;
  }

  PugvFaq._();

  factory PugvFaq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvFaq()..mergeFromBuffer(data, registry);
  factory PugvFaq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvFaq()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvFaq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvFaq.$_createMessage)
    ..aOM<PugvSeasonNav>(1, _omitFieldNames ? '' : 'nav',
        subBuilder: PugvSeasonNav.$_createMessage)
    ..pPM<PugvFaqContent>(2, _omitFieldNames ? '' : 'contents',
        subBuilder: PugvFaqContent.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvFaq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvFaq copyWith(void Function(PugvFaq) updates) =>
      super.copyWith((message) => updates(message as PugvFaq)) as PugvFaq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PugvFaq() / PugvFaq.new instead')
  static PugvFaq create() => PugvFaq._();
  static $pb.GeneratedMessage $_createMessage() => PugvFaq._();
  @$core.override
  PugvFaq createEmptyInstance() => PugvFaq._();
  @$core.pragma('dart2js:noInline')
  static PugvFaq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvFaq>(PugvFaq.$_createMessage);
  static PugvFaq? _defaultInstance;

  @$pb.TagNumber(1)
  PugvSeasonNav get nav => $_getN(0);
  @$pb.TagNumber(1)
  set nav(PugvSeasonNav value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNav() => $_has(0);
  @$pb.TagNumber(1)
  void clearNav() => $_clearField(1);
  @$pb.TagNumber(1)
  PugvSeasonNav ensureNav() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<PugvFaqContent> get contents => $_getList(1);
}

class PugvFaqContent extends $pb.GeneratedMessage {
  factory PugvFaqContent({
    $core.String? question,
    $core.String? answer,
    $core.String? link,
  }) {
    final result = PugvFaqContent._();
    if (question != null) result.question = question;
    if (answer != null) result.answer = answer;
    if (link != null) result.link = link;
    return result;
  }

  PugvFaqContent._();

  factory PugvFaqContent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvFaqContent()..mergeFromBuffer(data, registry);
  factory PugvFaqContent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvFaqContent()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvFaqContent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvFaqContent.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'question')
    ..aOS(2, _omitFieldNames ? '' : 'answer')
    ..aOS(3, _omitFieldNames ? '' : 'link')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvFaqContent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvFaqContent copyWith(void Function(PugvFaqContent) updates) =>
      super.copyWith((message) => updates(message as PugvFaqContent))
          as PugvFaqContent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PugvFaqContent() / PugvFaqContent.new instead')
  static PugvFaqContent create() => PugvFaqContent._();
  static $pb.GeneratedMessage $_createMessage() => PugvFaqContent._();
  @$core.override
  PugvFaqContent createEmptyInstance() => PugvFaqContent._();
  @$core.pragma('dart2js:noInline')
  static PugvFaqContent getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PugvFaqContent>(
          PugvFaqContent.$_createMessage);
  static PugvFaqContent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get question => $_getSZ(0);
  @$pb.TagNumber(1)
  set question($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuestion() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuestion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get answer => $_getSZ(1);
  @$pb.TagNumber(2)
  set answer($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAnswer() => $_has(1);
  @$pb.TagNumber(2)
  void clearAnswer() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get link => $_getSZ(2);
  @$pb.TagNumber(3)
  set link($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLink() => $_has(2);
  @$pb.TagNumber(3)
  void clearLink() => $_clearField(3);
}

class PugvPackage extends $pb.GeneratedMessage {
  factory PugvPackage({
    PugvSeasonNav? nav,
    $core.Iterable<PugvPackageItem>? contents,
  }) {
    final result = PugvPackage._();
    if (nav != null) result.nav = nav;
    if (contents != null) result.contents.addAll(contents);
    return result;
  }

  PugvPackage._();

  factory PugvPackage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvPackage()..mergeFromBuffer(data, registry);
  factory PugvPackage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvPackage()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvPackage',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvPackage.$_createMessage)
    ..aOM<PugvSeasonNav>(1, _omitFieldNames ? '' : 'nav',
        subBuilder: PugvSeasonNav.$_createMessage)
    ..pPM<PugvPackageItem>(2, _omitFieldNames ? '' : 'contents',
        subBuilder: PugvPackageItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvPackage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvPackage copyWith(void Function(PugvPackage) updates) =>
      super.copyWith((message) => updates(message as PugvPackage))
          as PugvPackage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PugvPackage() / PugvPackage.new instead')
  static PugvPackage create() => PugvPackage._();
  static $pb.GeneratedMessage $_createMessage() => PugvPackage._();
  @$core.override
  PugvPackage createEmptyInstance() => PugvPackage._();
  @$core.pragma('dart2js:noInline')
  static PugvPackage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PugvPackage>(
          PugvPackage.$_createMessage);
  static PugvPackage? _defaultInstance;

  @$pb.TagNumber(1)
  PugvSeasonNav get nav => $_getN(0);
  @$pb.TagNumber(1)
  set nav(PugvSeasonNav value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNav() => $_has(0);
  @$pb.TagNumber(1)
  void clearNav() => $_clearField(1);
  @$pb.TagNumber(1)
  PugvSeasonNav ensureNav() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<PugvPackageItem> get contents => $_getList(1);
}

class PugvPackageItem extends $pb.GeneratedMessage {
  factory PugvPackageItem({
    $fixnum.Int64? productId,
    $core.String? cover,
    $core.String? title,
    $core.String? discountPriceDesc,
    $core.String? originalPriceDesc,
    $core.String? desc,
    $core.String? link,
    $fixnum.Int64? seasonCount,
    PugvPackageSaleInfo? saleInfo,
  }) {
    final result = PugvPackageItem._();
    if (productId != null) result.productId = productId;
    if (cover != null) result.cover = cover;
    if (title != null) result.title = title;
    if (discountPriceDesc != null) result.discountPriceDesc = discountPriceDesc;
    if (originalPriceDesc != null) result.originalPriceDesc = originalPriceDesc;
    if (desc != null) result.desc = desc;
    if (link != null) result.link = link;
    if (seasonCount != null) result.seasonCount = seasonCount;
    if (saleInfo != null) result.saleInfo = saleInfo;
    return result;
  }

  PugvPackageItem._();

  factory PugvPackageItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvPackageItem()..mergeFromBuffer(data, registry);
  factory PugvPackageItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvPackageItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvPackageItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvPackageItem.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'productId')
    ..aOS(2, _omitFieldNames ? '' : 'cover')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'discountPriceDesc')
    ..aOS(5, _omitFieldNames ? '' : 'originalPriceDesc')
    ..aOS(6, _omitFieldNames ? '' : 'desc')
    ..aOS(7, _omitFieldNames ? '' : 'link')
    ..aInt64(8, _omitFieldNames ? '' : 'seasonCount')
    ..aOM<PugvPackageSaleInfo>(9, _omitFieldNames ? '' : 'saleInfo',
        subBuilder: PugvPackageSaleInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvPackageItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvPackageItem copyWith(void Function(PugvPackageItem) updates) =>
      super.copyWith((message) => updates(message as PugvPackageItem))
          as PugvPackageItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PugvPackageItem() / PugvPackageItem.new instead')
  static PugvPackageItem create() => PugvPackageItem._();
  static $pb.GeneratedMessage $_createMessage() => PugvPackageItem._();
  @$core.override
  PugvPackageItem createEmptyInstance() => PugvPackageItem._();
  @$core.pragma('dart2js:noInline')
  static PugvPackageItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PugvPackageItem>(
          PugvPackageItem.$_createMessage);
  static PugvPackageItem? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get productId => $_getI64(0);
  @$pb.TagNumber(1)
  set productId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProductId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cover => $_getSZ(1);
  @$pb.TagNumber(2)
  set cover($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCover() => $_has(1);
  @$pb.TagNumber(2)
  void clearCover() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get discountPriceDesc => $_getSZ(3);
  @$pb.TagNumber(4)
  set discountPriceDesc($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDiscountPriceDesc() => $_has(3);
  @$pb.TagNumber(4)
  void clearDiscountPriceDesc() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get originalPriceDesc => $_getSZ(4);
  @$pb.TagNumber(5)
  set originalPriceDesc($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOriginalPriceDesc() => $_has(4);
  @$pb.TagNumber(5)
  void clearOriginalPriceDesc() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get desc => $_getSZ(5);
  @$pb.TagNumber(6)
  set desc($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDesc() => $_has(5);
  @$pb.TagNumber(6)
  void clearDesc() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get link => $_getSZ(6);
  @$pb.TagNumber(7)
  set link($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLink() => $_has(6);
  @$pb.TagNumber(7)
  void clearLink() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get seasonCount => $_getI64(7);
  @$pb.TagNumber(8)
  set seasonCount($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSeasonCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearSeasonCount() => $_clearField(8);

  @$pb.TagNumber(9)
  PugvPackageSaleInfo get saleInfo => $_getN(8);
  @$pb.TagNumber(9)
  set saleInfo(PugvPackageSaleInfo value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSaleInfo() => $_has(8);
  @$pb.TagNumber(9)
  void clearSaleInfo() => $_clearField(9);
  @$pb.TagNumber(9)
  PugvPackageSaleInfo ensureSaleInfo() => $_ensure(8);
}

class PugvPackageSaleInfo extends $pb.GeneratedMessage {
  factory PugvPackageSaleInfo({
    $core.String? icon,
    $core.String? iconDark,
  }) {
    final result = PugvPackageSaleInfo._();
    if (icon != null) result.icon = icon;
    if (iconDark != null) result.iconDark = iconDark;
    return result;
  }

  PugvPackageSaleInfo._();

  factory PugvPackageSaleInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvPackageSaleInfo()..mergeFromBuffer(data, registry);
  factory PugvPackageSaleInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvPackageSaleInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvPackageSaleInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvPackageSaleInfo.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'icon')
    ..aOS(2, _omitFieldNames ? '' : 'iconDark')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvPackageSaleInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvPackageSaleInfo copyWith(void Function(PugvPackageSaleInfo) updates) =>
      super.copyWith((message) => updates(message as PugvPackageSaleInfo))
          as PugvPackageSaleInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use PugvPackageSaleInfo() / PugvPackageSaleInfo.new instead')
  static PugvPackageSaleInfo create() => PugvPackageSaleInfo._();
  static $pb.GeneratedMessage $_createMessage() => PugvPackageSaleInfo._();
  @$core.override
  PugvPackageSaleInfo createEmptyInstance() => PugvPackageSaleInfo._();
  @$core.pragma('dart2js:noInline')
  static PugvPackageSaleInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvPackageSaleInfo>(
          PugvPackageSaleInfo.$_createMessage);
  static PugvPackageSaleInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get icon => $_getSZ(0);
  @$pb.TagNumber(1)
  set icon($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIcon() => $_has(0);
  @$pb.TagNumber(1)
  void clearIcon() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get iconDark => $_getSZ(1);
  @$pb.TagNumber(2)
  set iconDark($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIconDark() => $_has(1);
  @$pb.TagNumber(2)
  void clearIconDark() => $_clearField(2);
}

class PugvSeasonCooperator extends $pb.GeneratedMessage {
  factory PugvSeasonCooperator({
    $fixnum.Int64? mid,
    $core.String? avatar,
    $core.String? nickname,
    $core.bool? isOwner,
    $core.String? role,
    $core.String? userLink,
    $core.bool? followed,
  }) {
    final result = PugvSeasonCooperator._();
    if (mid != null) result.mid = mid;
    if (avatar != null) result.avatar = avatar;
    if (nickname != null) result.nickname = nickname;
    if (isOwner != null) result.isOwner = isOwner;
    if (role != null) result.role = role;
    if (userLink != null) result.userLink = userLink;
    if (followed != null) result.followed = followed;
    return result;
  }

  PugvSeasonCooperator._();

  factory PugvSeasonCooperator.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonCooperator()..mergeFromBuffer(data, registry);
  factory PugvSeasonCooperator.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonCooperator()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonCooperator',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonCooperator.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'avatar')
    ..aOS(3, _omitFieldNames ? '' : 'nickname')
    ..aOB(4, _omitFieldNames ? '' : 'isOwner')
    ..aOS(5, _omitFieldNames ? '' : 'role')
    ..aOS(6, _omitFieldNames ? '' : 'userLink')
    ..aOB(7, _omitFieldNames ? '' : 'followed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonCooperator clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonCooperator copyWith(void Function(PugvSeasonCooperator) updates) =>
      super.copyWith((message) => updates(message as PugvSeasonCooperator))
          as PugvSeasonCooperator;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PugvSeasonCooperator() / PugvSeasonCooperator.new instead')
  static PugvSeasonCooperator create() => PugvSeasonCooperator._();
  static $pb.GeneratedMessage $_createMessage() => PugvSeasonCooperator._();
  @$core.override
  PugvSeasonCooperator createEmptyInstance() => PugvSeasonCooperator._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonCooperator getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeasonCooperator>(
          PugvSeasonCooperator.$_createMessage);
  static PugvSeasonCooperator? _defaultInstance;

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
  $core.String get nickname => $_getSZ(2);
  @$pb.TagNumber(3)
  set nickname($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNickname() => $_has(2);
  @$pb.TagNumber(3)
  void clearNickname() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isOwner => $_getBF(3);
  @$pb.TagNumber(4)
  set isOwner($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsOwner() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsOwner() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get role => $_getSZ(4);
  @$pb.TagNumber(5)
  set role($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRole() => $_has(4);
  @$pb.TagNumber(5)
  void clearRole() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get userLink => $_getSZ(5);
  @$pb.TagNumber(6)
  set userLink($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUserLink() => $_has(5);
  @$pb.TagNumber(6)
  void clearUserLink() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get followed => $_getBF(6);
  @$pb.TagNumber(7)
  set followed($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFollowed() => $_has(6);
  @$pb.TagNumber(7)
  void clearFollowed() => $_clearField(7);
}

enum PugvSeasonDescription_Content { text, image, notSet }

class PugvSeasonDescription extends $pb.GeneratedMessage {
  factory PugvSeasonDescription({
    PugvSeasonNav? nav,
    PugvSeasonDescriptionType? type,
    PugvSeasonDescriptionText? text,
    PugvSeasonDescriptionImage? image,
  }) {
    final result = PugvSeasonDescription._();
    if (nav != null) result.nav = nav;
    if (type != null) result.type = type;
    if (text != null) result.text = text;
    if (image != null) result.image = image;
    return result;
  }

  PugvSeasonDescription._();

  factory PugvSeasonDescription.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonDescription()..mergeFromBuffer(data, registry);
  factory PugvSeasonDescription.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonDescription()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, PugvSeasonDescription_Content>
      _PugvSeasonDescription_ContentByTag = {
    3: PugvSeasonDescription_Content.text,
    4: PugvSeasonDescription_Content.image,
    0: PugvSeasonDescription_Content.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonDescription',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonDescription.$_createMessage)
    ..oo(0, [3, 4])
    ..aOM<PugvSeasonNav>(1, _omitFieldNames ? '' : 'nav',
        subBuilder: PugvSeasonNav.$_createMessage)
    ..aE<PugvSeasonDescriptionType>(2, _omitFieldNames ? '' : 'type',
        enumValues: PugvSeasonDescriptionType.values)
    ..aOM<PugvSeasonDescriptionText>(3, _omitFieldNames ? '' : 'text',
        subBuilder: PugvSeasonDescriptionText.$_createMessage)
    ..aOM<PugvSeasonDescriptionImage>(4, _omitFieldNames ? '' : 'image',
        subBuilder: PugvSeasonDescriptionImage.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonDescription clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonDescription copyWith(
          void Function(PugvSeasonDescription) updates) =>
      super.copyWith((message) => updates(message as PugvSeasonDescription))
          as PugvSeasonDescription;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PugvSeasonDescription() / PugvSeasonDescription.new instead')
  static PugvSeasonDescription create() => PugvSeasonDescription._();
  static $pb.GeneratedMessage $_createMessage() => PugvSeasonDescription._();
  @$core.override
  PugvSeasonDescription createEmptyInstance() => PugvSeasonDescription._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonDescription getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeasonDescription>(
          PugvSeasonDescription.$_createMessage);
  static PugvSeasonDescription? _defaultInstance;

  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  PugvSeasonDescription_Content whichContent() =>
      _PugvSeasonDescription_ContentByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearContent() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  PugvSeasonNav get nav => $_getN(0);
  @$pb.TagNumber(1)
  set nav(PugvSeasonNav value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNav() => $_has(0);
  @$pb.TagNumber(1)
  void clearNav() => $_clearField(1);
  @$pb.TagNumber(1)
  PugvSeasonNav ensureNav() => $_ensure(0);

  @$pb.TagNumber(2)
  PugvSeasonDescriptionType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(PugvSeasonDescriptionType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  PugvSeasonDescriptionText get text => $_getN(2);
  @$pb.TagNumber(3)
  set text(PugvSeasonDescriptionText value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);
  @$pb.TagNumber(3)
  PugvSeasonDescriptionText ensureText() => $_ensure(2);

  @$pb.TagNumber(4)
  PugvSeasonDescriptionImage get image => $_getN(3);
  @$pb.TagNumber(4)
  set image(PugvSeasonDescriptionImage value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasImage() => $_has(3);
  @$pb.TagNumber(4)
  void clearImage() => $_clearField(4);
  @$pb.TagNumber(4)
  PugvSeasonDescriptionImage ensureImage() => $_ensure(3);
}

class PugvSeasonDescriptionImage extends $pb.GeneratedMessage {
  factory PugvSeasonDescriptionImage({
    $core.Iterable<PugvSeasonDescriptionImageItem>? images,
    $core.bool? folded,
    $core.double? foldRatio,
  }) {
    final result = PugvSeasonDescriptionImage._();
    if (images != null) result.images.addAll(images);
    if (folded != null) result.folded = folded;
    if (foldRatio != null) result.foldRatio = foldRatio;
    return result;
  }

  PugvSeasonDescriptionImage._();

  factory PugvSeasonDescriptionImage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonDescriptionImage()..mergeFromBuffer(data, registry);
  factory PugvSeasonDescriptionImage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonDescriptionImage()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonDescriptionImage',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonDescriptionImage.$_createMessage)
    ..pPM<PugvSeasonDescriptionImageItem>(1, _omitFieldNames ? '' : 'images',
        subBuilder: PugvSeasonDescriptionImageItem.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'folded')
    ..aD(3, _omitFieldNames ? '' : 'foldRatio')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonDescriptionImage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonDescriptionImage copyWith(
          void Function(PugvSeasonDescriptionImage) updates) =>
      super.copyWith(
              (message) => updates(message as PugvSeasonDescriptionImage))
          as PugvSeasonDescriptionImage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PugvSeasonDescriptionImage() / PugvSeasonDescriptionImage.new instead')
  static PugvSeasonDescriptionImage create() => PugvSeasonDescriptionImage._();
  static $pb.GeneratedMessage $_createMessage() =>
      PugvSeasonDescriptionImage._();
  @$core.override
  PugvSeasonDescriptionImage createEmptyInstance() =>
      PugvSeasonDescriptionImage._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonDescriptionImage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeasonDescriptionImage>(
          PugvSeasonDescriptionImage.$_createMessage);
  static PugvSeasonDescriptionImage? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PugvSeasonDescriptionImageItem> get images => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get folded => $_getBF(1);
  @$pb.TagNumber(2)
  set folded($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFolded() => $_has(1);
  @$pb.TagNumber(2)
  void clearFolded() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get foldRatio => $_getN(2);
  @$pb.TagNumber(3)
  set foldRatio($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFoldRatio() => $_has(2);
  @$pb.TagNumber(3)
  void clearFoldRatio() => $_clearField(3);
}

class PugvSeasonDescriptionImageItem extends $pb.GeneratedMessage {
  factory PugvSeasonDescriptionImageItem({
    $core.String? imageUrl,
    $core.double? aspectRatio,
  }) {
    final result = PugvSeasonDescriptionImageItem._();
    if (imageUrl != null) result.imageUrl = imageUrl;
    if (aspectRatio != null) result.aspectRatio = aspectRatio;
    return result;
  }

  PugvSeasonDescriptionImageItem._();

  factory PugvSeasonDescriptionImageItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonDescriptionImageItem()..mergeFromBuffer(data, registry);
  factory PugvSeasonDescriptionImageItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonDescriptionImageItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonDescriptionImageItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonDescriptionImageItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'imageUrl')
    ..aD(2, _omitFieldNames ? '' : 'aspectRatio')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonDescriptionImageItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonDescriptionImageItem copyWith(
          void Function(PugvSeasonDescriptionImageItem) updates) =>
      super.copyWith(
              (message) => updates(message as PugvSeasonDescriptionImageItem))
          as PugvSeasonDescriptionImageItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PugvSeasonDescriptionImageItem() / PugvSeasonDescriptionImageItem.new instead')
  static PugvSeasonDescriptionImageItem create() =>
      PugvSeasonDescriptionImageItem._();
  static $pb.GeneratedMessage $_createMessage() =>
      PugvSeasonDescriptionImageItem._();
  @$core.override
  PugvSeasonDescriptionImageItem createEmptyInstance() =>
      PugvSeasonDescriptionImageItem._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonDescriptionImageItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeasonDescriptionImageItem>(
          PugvSeasonDescriptionImageItem.$_createMessage);
  static PugvSeasonDescriptionImageItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get imageUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set imageUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasImageUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearImageUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get aspectRatio => $_getN(1);
  @$pb.TagNumber(2)
  set aspectRatio($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAspectRatio() => $_has(1);
  @$pb.TagNumber(2)
  void clearAspectRatio() => $_clearField(2);
}

class PugvSeasonDescriptionText extends $pb.GeneratedMessage {
  factory PugvSeasonDescriptionText({
    $core.String? text,
  }) {
    final result = PugvSeasonDescriptionText._();
    if (text != null) result.text = text;
    return result;
  }

  PugvSeasonDescriptionText._();

  factory PugvSeasonDescriptionText.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonDescriptionText()..mergeFromBuffer(data, registry);
  factory PugvSeasonDescriptionText.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonDescriptionText()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonDescriptionText',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonDescriptionText.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonDescriptionText clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonDescriptionText copyWith(
          void Function(PugvSeasonDescriptionText) updates) =>
      super.copyWith((message) => updates(message as PugvSeasonDescriptionText))
          as PugvSeasonDescriptionText;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PugvSeasonDescriptionText() / PugvSeasonDescriptionText.new instead')
  static PugvSeasonDescriptionText create() => PugvSeasonDescriptionText._();
  static $pb.GeneratedMessage $_createMessage() =>
      PugvSeasonDescriptionText._();
  @$core.override
  PugvSeasonDescriptionText createEmptyInstance() =>
      PugvSeasonDescriptionText._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonDescriptionText getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeasonDescriptionText>(
          PugvSeasonDescriptionText.$_createMessage);
  static PugvSeasonDescriptionText? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);
}

class PugvSeasonNav extends $pb.GeneratedMessage {
  factory PugvSeasonNav({
    $core.String? title,
    $core.String? moreText,
    $core.String? desc,
  }) {
    final result = PugvSeasonNav._();
    if (title != null) result.title = title;
    if (moreText != null) result.moreText = moreText;
    if (desc != null) result.desc = desc;
    return result;
  }

  PugvSeasonNav._();

  factory PugvSeasonNav.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonNav()..mergeFromBuffer(data, registry);
  factory PugvSeasonNav.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonNav()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonNav',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonNav.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'moreText')
    ..aOS(3, _omitFieldNames ? '' : 'desc')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonNav clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonNav copyWith(void Function(PugvSeasonNav) updates) =>
      super.copyWith((message) => updates(message as PugvSeasonNav))
          as PugvSeasonNav;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PugvSeasonNav() / PugvSeasonNav.new instead')
  static PugvSeasonNav create() => PugvSeasonNav._();
  static $pb.GeneratedMessage $_createMessage() => PugvSeasonNav._();
  @$core.override
  PugvSeasonNav createEmptyInstance() => PugvSeasonNav._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonNav getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PugvSeasonNav>(
          PugvSeasonNav.$_createMessage);
  static PugvSeasonNav? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get moreText => $_getSZ(1);
  @$pb.TagNumber(2)
  set moreText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMoreText() => $_has(1);
  @$pb.TagNumber(2)
  void clearMoreText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get desc => $_getSZ(2);
  @$pb.TagNumber(3)
  set desc($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDesc() => $_has(2);
  @$pb.TagNumber(3)
  void clearDesc() => $_clearField(3);
}

class PugvSeasonPrimaryBadge extends $pb.GeneratedMessage {
  factory PugvSeasonPrimaryBadge({
    $core.String? icon,
    $core.String? link,
    $core.String? nightIcon,
  }) {
    final result = PugvSeasonPrimaryBadge._();
    if (icon != null) result.icon = icon;
    if (link != null) result.link = link;
    if (nightIcon != null) result.nightIcon = nightIcon;
    return result;
  }

  PugvSeasonPrimaryBadge._();

  factory PugvSeasonPrimaryBadge.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPrimaryBadge()..mergeFromBuffer(data, registry);
  factory PugvSeasonPrimaryBadge.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPrimaryBadge()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonPrimaryBadge',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonPrimaryBadge.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'icon')
    ..aOS(2, _omitFieldNames ? '' : 'link')
    ..aOS(3, _omitFieldNames ? '' : 'nightIcon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPrimaryBadge clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPrimaryBadge copyWith(
          void Function(PugvSeasonPrimaryBadge) updates) =>
      super.copyWith((message) => updates(message as PugvSeasonPrimaryBadge))
          as PugvSeasonPrimaryBadge;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PugvSeasonPrimaryBadge() / PugvSeasonPrimaryBadge.new instead')
  static PugvSeasonPrimaryBadge create() => PugvSeasonPrimaryBadge._();
  static $pb.GeneratedMessage $_createMessage() => PugvSeasonPrimaryBadge._();
  @$core.override
  PugvSeasonPrimaryBadge createEmptyInstance() => PugvSeasonPrimaryBadge._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonPrimaryBadge getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeasonPrimaryBadge>(
          PugvSeasonPrimaryBadge.$_createMessage);
  static PugvSeasonPrimaryBadge? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get icon => $_getSZ(0);
  @$pb.TagNumber(1)
  set icon($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIcon() => $_has(0);
  @$pb.TagNumber(1)
  void clearIcon() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get link => $_getSZ(1);
  @$pb.TagNumber(2)
  set link($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLink() => $_has(1);
  @$pb.TagNumber(2)
  void clearLink() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get nightIcon => $_getSZ(2);
  @$pb.TagNumber(3)
  set nightIcon($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNightIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearNightIcon() => $_clearField(3);
}

class PugvSeasonPrimaryCustomInfo extends $pb.GeneratedMessage {
  factory PugvSeasonPrimaryCustomInfo({
    $core.String? expiryInfo,
  }) {
    final result = PugvSeasonPrimaryCustomInfo._();
    if (expiryInfo != null) result.expiryInfo = expiryInfo;
    return result;
  }

  PugvSeasonPrimaryCustomInfo._();

  factory PugvSeasonPrimaryCustomInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPrimaryCustomInfo()..mergeFromBuffer(data, registry);
  factory PugvSeasonPrimaryCustomInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPrimaryCustomInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonPrimaryCustomInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonPrimaryCustomInfo.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'expiryInfo')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPrimaryCustomInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPrimaryCustomInfo copyWith(
          void Function(PugvSeasonPrimaryCustomInfo) updates) =>
      super.copyWith(
              (message) => updates(message as PugvSeasonPrimaryCustomInfo))
          as PugvSeasonPrimaryCustomInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PugvSeasonPrimaryCustomInfo() / PugvSeasonPrimaryCustomInfo.new instead')
  static PugvSeasonPrimaryCustomInfo create() =>
      PugvSeasonPrimaryCustomInfo._();
  static $pb.GeneratedMessage $_createMessage() =>
      PugvSeasonPrimaryCustomInfo._();
  @$core.override
  PugvSeasonPrimaryCustomInfo createEmptyInstance() =>
      PugvSeasonPrimaryCustomInfo._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonPrimaryCustomInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeasonPrimaryCustomInfo>(
          PugvSeasonPrimaryCustomInfo.$_createMessage);
  static PugvSeasonPrimaryCustomInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get expiryInfo => $_getSZ(0);
  @$pb.TagNumber(1)
  set expiryInfo($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExpiryInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearExpiryInfo() => $_clearField(1);
}

class PugvSeasonPrimaryHotRank extends $pb.GeneratedMessage {
  factory PugvSeasonPrimaryHotRank({
    $core.String? text,
    $core.String? link,
  }) {
    final result = PugvSeasonPrimaryHotRank._();
    if (text != null) result.text = text;
    if (link != null) result.link = link;
    return result;
  }

  PugvSeasonPrimaryHotRank._();

  factory PugvSeasonPrimaryHotRank.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPrimaryHotRank()..mergeFromBuffer(data, registry);
  factory PugvSeasonPrimaryHotRank.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPrimaryHotRank()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonPrimaryHotRank',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonPrimaryHotRank.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aOS(2, _omitFieldNames ? '' : 'link')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPrimaryHotRank clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPrimaryHotRank copyWith(
          void Function(PugvSeasonPrimaryHotRank) updates) =>
      super.copyWith((message) => updates(message as PugvSeasonPrimaryHotRank))
          as PugvSeasonPrimaryHotRank;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PugvSeasonPrimaryHotRank() / PugvSeasonPrimaryHotRank.new instead')
  static PugvSeasonPrimaryHotRank create() => PugvSeasonPrimaryHotRank._();
  static $pb.GeneratedMessage $_createMessage() => PugvSeasonPrimaryHotRank._();
  @$core.override
  PugvSeasonPrimaryHotRank createEmptyInstance() =>
      PugvSeasonPrimaryHotRank._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonPrimaryHotRank getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeasonPrimaryHotRank>(
          PugvSeasonPrimaryHotRank.$_createMessage);
  static PugvSeasonPrimaryHotRank? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get link => $_getSZ(1);
  @$pb.TagNumber(2)
  set link($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLink() => $_has(1);
  @$pb.TagNumber(2)
  void clearLink() => $_clearField(2);
}

class PugvSeasonPrimaryInfo extends $pb.GeneratedMessage {
  factory PugvSeasonPrimaryInfo({
    $core.String? title,
    $core.String? subtitle,
    StatInfo? statInfo,
    PugvSeasonPrimaryRankInfo? rankInfo,
    PugvSeasonPrimarySellPointInfo? sellPointInfo,
    PugvSeasonPrimaryCustomInfo? customInfo,
    $core.bool? showPayment,
    PugvSeasonPrimaryBadge? badge,
  }) {
    final result = PugvSeasonPrimaryInfo._();
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    if (statInfo != null) result.statInfo = statInfo;
    if (rankInfo != null) result.rankInfo = rankInfo;
    if (sellPointInfo != null) result.sellPointInfo = sellPointInfo;
    if (customInfo != null) result.customInfo = customInfo;
    if (showPayment != null) result.showPayment = showPayment;
    if (badge != null) result.badge = badge;
    return result;
  }

  PugvSeasonPrimaryInfo._();

  factory PugvSeasonPrimaryInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPrimaryInfo()..mergeFromBuffer(data, registry);
  factory PugvSeasonPrimaryInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPrimaryInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonPrimaryInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonPrimaryInfo.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'subtitle')
    ..aOM<StatInfo>(3, _omitFieldNames ? '' : 'statInfo',
        subBuilder: StatInfo.$_createMessage)
    ..aOM<PugvSeasonPrimaryRankInfo>(4, _omitFieldNames ? '' : 'rankInfo',
        subBuilder: PugvSeasonPrimaryRankInfo.$_createMessage)
    ..aOM<PugvSeasonPrimarySellPointInfo>(
        5, _omitFieldNames ? '' : 'sellPointInfo',
        subBuilder: PugvSeasonPrimarySellPointInfo.$_createMessage)
    ..aOM<PugvSeasonPrimaryCustomInfo>(6, _omitFieldNames ? '' : 'customInfo',
        subBuilder: PugvSeasonPrimaryCustomInfo.$_createMessage)
    ..aOB(7, _omitFieldNames ? '' : 'showPayment')
    ..aOM<PugvSeasonPrimaryBadge>(8, _omitFieldNames ? '' : 'badge',
        subBuilder: PugvSeasonPrimaryBadge.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPrimaryInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPrimaryInfo copyWith(
          void Function(PugvSeasonPrimaryInfo) updates) =>
      super.copyWith((message) => updates(message as PugvSeasonPrimaryInfo))
          as PugvSeasonPrimaryInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PugvSeasonPrimaryInfo() / PugvSeasonPrimaryInfo.new instead')
  static PugvSeasonPrimaryInfo create() => PugvSeasonPrimaryInfo._();
  static $pb.GeneratedMessage $_createMessage() => PugvSeasonPrimaryInfo._();
  @$core.override
  PugvSeasonPrimaryInfo createEmptyInstance() => PugvSeasonPrimaryInfo._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonPrimaryInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeasonPrimaryInfo>(
          PugvSeasonPrimaryInfo.$_createMessage);
  static PugvSeasonPrimaryInfo? _defaultInstance;

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
  StatInfo get statInfo => $_getN(2);
  @$pb.TagNumber(3)
  set statInfo(StatInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatInfo() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatInfo() => $_clearField(3);
  @$pb.TagNumber(3)
  StatInfo ensureStatInfo() => $_ensure(2);

  @$pb.TagNumber(4)
  PugvSeasonPrimaryRankInfo get rankInfo => $_getN(3);
  @$pb.TagNumber(4)
  set rankInfo(PugvSeasonPrimaryRankInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRankInfo() => $_has(3);
  @$pb.TagNumber(4)
  void clearRankInfo() => $_clearField(4);
  @$pb.TagNumber(4)
  PugvSeasonPrimaryRankInfo ensureRankInfo() => $_ensure(3);

  @$pb.TagNumber(5)
  PugvSeasonPrimarySellPointInfo get sellPointInfo => $_getN(4);
  @$pb.TagNumber(5)
  set sellPointInfo(PugvSeasonPrimarySellPointInfo value) =>
      $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSellPointInfo() => $_has(4);
  @$pb.TagNumber(5)
  void clearSellPointInfo() => $_clearField(5);
  @$pb.TagNumber(5)
  PugvSeasonPrimarySellPointInfo ensureSellPointInfo() => $_ensure(4);

  @$pb.TagNumber(6)
  PugvSeasonPrimaryCustomInfo get customInfo => $_getN(5);
  @$pb.TagNumber(6)
  set customInfo(PugvSeasonPrimaryCustomInfo value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCustomInfo() => $_has(5);
  @$pb.TagNumber(6)
  void clearCustomInfo() => $_clearField(6);
  @$pb.TagNumber(6)
  PugvSeasonPrimaryCustomInfo ensureCustomInfo() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.bool get showPayment => $_getBF(6);
  @$pb.TagNumber(7)
  set showPayment($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasShowPayment() => $_has(6);
  @$pb.TagNumber(7)
  void clearShowPayment() => $_clearField(7);

  @$pb.TagNumber(8)
  PugvSeasonPrimaryBadge get badge => $_getN(7);
  @$pb.TagNumber(8)
  set badge(PugvSeasonPrimaryBadge value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasBadge() => $_has(7);
  @$pb.TagNumber(8)
  void clearBadge() => $_clearField(8);
  @$pb.TagNumber(8)
  PugvSeasonPrimaryBadge ensureBadge() => $_ensure(7);
}

class PugvSeasonPrimaryRankInfo extends $pb.GeneratedMessage {
  factory PugvSeasonPrimaryRankInfo({
    PugvSeasonPrimaryHotRank? hotRank,
  }) {
    final result = PugvSeasonPrimaryRankInfo._();
    if (hotRank != null) result.hotRank = hotRank;
    return result;
  }

  PugvSeasonPrimaryRankInfo._();

  factory PugvSeasonPrimaryRankInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPrimaryRankInfo()..mergeFromBuffer(data, registry);
  factory PugvSeasonPrimaryRankInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPrimaryRankInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonPrimaryRankInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonPrimaryRankInfo.$_createMessage)
    ..aOM<PugvSeasonPrimaryHotRank>(1, _omitFieldNames ? '' : 'hotRank',
        subBuilder: PugvSeasonPrimaryHotRank.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPrimaryRankInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPrimaryRankInfo copyWith(
          void Function(PugvSeasonPrimaryRankInfo) updates) =>
      super.copyWith((message) => updates(message as PugvSeasonPrimaryRankInfo))
          as PugvSeasonPrimaryRankInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PugvSeasonPrimaryRankInfo() / PugvSeasonPrimaryRankInfo.new instead')
  static PugvSeasonPrimaryRankInfo create() => PugvSeasonPrimaryRankInfo._();
  static $pb.GeneratedMessage $_createMessage() =>
      PugvSeasonPrimaryRankInfo._();
  @$core.override
  PugvSeasonPrimaryRankInfo createEmptyInstance() =>
      PugvSeasonPrimaryRankInfo._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonPrimaryRankInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeasonPrimaryRankInfo>(
          PugvSeasonPrimaryRankInfo.$_createMessage);
  static PugvSeasonPrimaryRankInfo? _defaultInstance;

  @$pb.TagNumber(1)
  PugvSeasonPrimaryHotRank get hotRank => $_getN(0);
  @$pb.TagNumber(1)
  set hotRank(PugvSeasonPrimaryHotRank value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHotRank() => $_has(0);
  @$pb.TagNumber(1)
  void clearHotRank() => $_clearField(1);
  @$pb.TagNumber(1)
  PugvSeasonPrimaryHotRank ensureHotRank() => $_ensure(0);
}

class PugvSeasonPrimarySellPoint extends $pb.GeneratedMessage {
  factory PugvSeasonPrimarySellPoint({
    $core.String? title,
    $core.String? detail,
  }) {
    final result = PugvSeasonPrimarySellPoint._();
    if (title != null) result.title = title;
    if (detail != null) result.detail = detail;
    return result;
  }

  PugvSeasonPrimarySellPoint._();

  factory PugvSeasonPrimarySellPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPrimarySellPoint()..mergeFromBuffer(data, registry);
  factory PugvSeasonPrimarySellPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPrimarySellPoint()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonPrimarySellPoint',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonPrimarySellPoint.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'detail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPrimarySellPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPrimarySellPoint copyWith(
          void Function(PugvSeasonPrimarySellPoint) updates) =>
      super.copyWith(
              (message) => updates(message as PugvSeasonPrimarySellPoint))
          as PugvSeasonPrimarySellPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PugvSeasonPrimarySellPoint() / PugvSeasonPrimarySellPoint.new instead')
  static PugvSeasonPrimarySellPoint create() => PugvSeasonPrimarySellPoint._();
  static $pb.GeneratedMessage $_createMessage() =>
      PugvSeasonPrimarySellPoint._();
  @$core.override
  PugvSeasonPrimarySellPoint createEmptyInstance() =>
      PugvSeasonPrimarySellPoint._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonPrimarySellPoint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeasonPrimarySellPoint>(
          PugvSeasonPrimarySellPoint.$_createMessage);
  static PugvSeasonPrimarySellPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get detail => $_getSZ(1);
  @$pb.TagNumber(2)
  set detail($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDetail() => $_has(1);
  @$pb.TagNumber(2)
  void clearDetail() => $_clearField(2);
}

class PugvSeasonPrimarySellPointInfo extends $pb.GeneratedMessage {
  factory PugvSeasonPrimarySellPointInfo({
    PugvSeasonPrimarySellPointType? type,
    $core.Iterable<PugvSeasonPrimarySellPoint>? sellPoints,
  }) {
    final result = PugvSeasonPrimarySellPointInfo._();
    if (type != null) result.type = type;
    if (sellPoints != null) result.sellPoints.addAll(sellPoints);
    return result;
  }

  PugvSeasonPrimarySellPointInfo._();

  factory PugvSeasonPrimarySellPointInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPrimarySellPointInfo()..mergeFromBuffer(data, registry);
  factory PugvSeasonPrimarySellPointInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPrimarySellPointInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonPrimarySellPointInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonPrimarySellPointInfo.$_createMessage)
    ..aE<PugvSeasonPrimarySellPointType>(1, _omitFieldNames ? '' : 'type',
        enumValues: PugvSeasonPrimarySellPointType.values)
    ..pPM<PugvSeasonPrimarySellPoint>(2, _omitFieldNames ? '' : 'sellPoints',
        subBuilder: PugvSeasonPrimarySellPoint.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPrimarySellPointInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPrimarySellPointInfo copyWith(
          void Function(PugvSeasonPrimarySellPointInfo) updates) =>
      super.copyWith(
              (message) => updates(message as PugvSeasonPrimarySellPointInfo))
          as PugvSeasonPrimarySellPointInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PugvSeasonPrimarySellPointInfo() / PugvSeasonPrimarySellPointInfo.new instead')
  static PugvSeasonPrimarySellPointInfo create() =>
      PugvSeasonPrimarySellPointInfo._();
  static $pb.GeneratedMessage $_createMessage() =>
      PugvSeasonPrimarySellPointInfo._();
  @$core.override
  PugvSeasonPrimarySellPointInfo createEmptyInstance() =>
      PugvSeasonPrimarySellPointInfo._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonPrimarySellPointInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeasonPrimarySellPointInfo>(
          PugvSeasonPrimarySellPointInfo.$_createMessage);
  static PugvSeasonPrimarySellPointInfo? _defaultInstance;

  @$pb.TagNumber(1)
  PugvSeasonPrimarySellPointType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(PugvSeasonPrimarySellPointType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<PugvSeasonPrimarySellPoint> get sellPoints => $_getList(1);
}

class PugvSeasonPublisher extends $pb.GeneratedMessage {
  factory PugvSeasonPublisher({
    PugvSeasonNav? nav,
    $core.String? publisherDesc,
    $core.Iterable<PugvSeasonCooperator>? cooperators,
    PugvSeasonPublisherSkuContent? skuContent,
  }) {
    final result = PugvSeasonPublisher._();
    if (nav != null) result.nav = nav;
    if (publisherDesc != null) result.publisherDesc = publisherDesc;
    if (cooperators != null) result.cooperators.addAll(cooperators);
    if (skuContent != null) result.skuContent = skuContent;
    return result;
  }

  PugvSeasonPublisher._();

  factory PugvSeasonPublisher.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPublisher()..mergeFromBuffer(data, registry);
  factory PugvSeasonPublisher.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPublisher()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonPublisher',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonPublisher.$_createMessage)
    ..aOM<PugvSeasonNav>(1, _omitFieldNames ? '' : 'nav',
        subBuilder: PugvSeasonNav.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publisherDesc')
    ..pPM<PugvSeasonCooperator>(3, _omitFieldNames ? '' : 'cooperators',
        subBuilder: PugvSeasonCooperator.$_createMessage)
    ..aOM<PugvSeasonPublisherSkuContent>(4, _omitFieldNames ? '' : 'skuContent',
        subBuilder: PugvSeasonPublisherSkuContent.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPublisher clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPublisher copyWith(void Function(PugvSeasonPublisher) updates) =>
      super.copyWith((message) => updates(message as PugvSeasonPublisher))
          as PugvSeasonPublisher;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use PugvSeasonPublisher() / PugvSeasonPublisher.new instead')
  static PugvSeasonPublisher create() => PugvSeasonPublisher._();
  static $pb.GeneratedMessage $_createMessage() => PugvSeasonPublisher._();
  @$core.override
  PugvSeasonPublisher createEmptyInstance() => PugvSeasonPublisher._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonPublisher getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeasonPublisher>(
          PugvSeasonPublisher.$_createMessage);
  static PugvSeasonPublisher? _defaultInstance;

  @$pb.TagNumber(1)
  PugvSeasonNav get nav => $_getN(0);
  @$pb.TagNumber(1)
  set nav(PugvSeasonNav value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNav() => $_has(0);
  @$pb.TagNumber(1)
  void clearNav() => $_clearField(1);
  @$pb.TagNumber(1)
  PugvSeasonNav ensureNav() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get publisherDesc => $_getSZ(1);
  @$pb.TagNumber(2)
  set publisherDesc($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublisherDesc() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublisherDesc() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<PugvSeasonCooperator> get cooperators => $_getList(2);

  @$pb.TagNumber(4)
  PugvSeasonPublisherSkuContent get skuContent => $_getN(3);
  @$pb.TagNumber(4)
  set skuContent(PugvSeasonPublisherSkuContent value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSkuContent() => $_has(3);
  @$pb.TagNumber(4)
  void clearSkuContent() => $_clearField(4);
  @$pb.TagNumber(4)
  PugvSeasonPublisherSkuContent ensureSkuContent() => $_ensure(3);
}

class PugvSeasonPublisherSkuContent extends $pb.GeneratedMessage {
  factory PugvSeasonPublisherSkuContent({
    $core.String? title,
    $core.Iterable<PugvSeasonPublisherSkuContentItem>? items,
  }) {
    final result = PugvSeasonPublisherSkuContent._();
    if (title != null) result.title = title;
    if (items != null) result.items.addAll(items);
    return result;
  }

  PugvSeasonPublisherSkuContent._();

  factory PugvSeasonPublisherSkuContent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPublisherSkuContent()..mergeFromBuffer(data, registry);
  factory PugvSeasonPublisherSkuContent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPublisherSkuContent()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonPublisherSkuContent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonPublisherSkuContent.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..pPM<PugvSeasonPublisherSkuContentItem>(2, _omitFieldNames ? '' : 'items',
        subBuilder: PugvSeasonPublisherSkuContentItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPublisherSkuContent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPublisherSkuContent copyWith(
          void Function(PugvSeasonPublisherSkuContent) updates) =>
      super.copyWith(
              (message) => updates(message as PugvSeasonPublisherSkuContent))
          as PugvSeasonPublisherSkuContent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PugvSeasonPublisherSkuContent() / PugvSeasonPublisherSkuContent.new instead')
  static PugvSeasonPublisherSkuContent create() =>
      PugvSeasonPublisherSkuContent._();
  static $pb.GeneratedMessage $_createMessage() =>
      PugvSeasonPublisherSkuContent._();
  @$core.override
  PugvSeasonPublisherSkuContent createEmptyInstance() =>
      PugvSeasonPublisherSkuContent._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonPublisherSkuContent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeasonPublisherSkuContent>(
          PugvSeasonPublisherSkuContent.$_createMessage);
  static PugvSeasonPublisherSkuContent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<PugvSeasonPublisherSkuContentItem> get items => $_getList(1);
}

class PugvSeasonPublisherSkuContentItem extends $pb.GeneratedMessage {
  factory PugvSeasonPublisherSkuContentItem({
    $core.String? title,
    $fixnum.Int64? seasonId,
    $core.bool? selected,
  }) {
    final result = PugvSeasonPublisherSkuContentItem._();
    if (title != null) result.title = title;
    if (seasonId != null) result.seasonId = seasonId;
    if (selected != null) result.selected = selected;
    return result;
  }

  PugvSeasonPublisherSkuContentItem._();

  factory PugvSeasonPublisherSkuContentItem.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPublisherSkuContentItem()..mergeFromBuffer(data, registry);
  factory PugvSeasonPublisherSkuContentItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonPublisherSkuContentItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonPublisherSkuContentItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonPublisherSkuContentItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aInt64(2, _omitFieldNames ? '' : 'seasonId')
    ..aOB(3, _omitFieldNames ? '' : 'selected')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPublisherSkuContentItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonPublisherSkuContentItem copyWith(
          void Function(PugvSeasonPublisherSkuContentItem) updates) =>
      super.copyWith((message) =>
              updates(message as PugvSeasonPublisherSkuContentItem))
          as PugvSeasonPublisherSkuContentItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PugvSeasonPublisherSkuContentItem() / PugvSeasonPublisherSkuContentItem.new instead')
  static PugvSeasonPublisherSkuContentItem create() =>
      PugvSeasonPublisherSkuContentItem._();
  static $pb.GeneratedMessage $_createMessage() =>
      PugvSeasonPublisherSkuContentItem._();
  @$core.override
  PugvSeasonPublisherSkuContentItem createEmptyInstance() =>
      PugvSeasonPublisherSkuContentItem._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonPublisherSkuContentItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeasonPublisherSkuContentItem>(
          PugvSeasonPublisherSkuContentItem.$_createMessage);
  static PugvSeasonPublisherSkuContentItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get seasonId => $_getI64(1);
  @$pb.TagNumber(2)
  set seasonId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSeasonId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeasonId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get selected => $_getBF(2);
  @$pb.TagNumber(3)
  set selected($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSelected() => $_has(2);
  @$pb.TagNumber(3)
  void clearSelected() => $_clearField(3);
}

class PugvSeasonRecommend extends $pb.GeneratedMessage {
  factory PugvSeasonRecommend({
    PugvSeasonNav? nav,
    $core.Iterable<PugvSeasonRecommendContent>? contents,
    PugvSeasonRecommendMore? moreInfo,
    PugvSeasonRecommendShowStyle? showStyle,
  }) {
    final result = PugvSeasonRecommend._();
    if (nav != null) result.nav = nav;
    if (contents != null) result.contents.addAll(contents);
    if (moreInfo != null) result.moreInfo = moreInfo;
    if (showStyle != null) result.showStyle = showStyle;
    return result;
  }

  PugvSeasonRecommend._();

  factory PugvSeasonRecommend.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonRecommend()..mergeFromBuffer(data, registry);
  factory PugvSeasonRecommend.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonRecommend()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonRecommend',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonRecommend.$_createMessage)
    ..aOM<PugvSeasonNav>(1, _omitFieldNames ? '' : 'nav',
        subBuilder: PugvSeasonNav.$_createMessage)
    ..pPM<PugvSeasonRecommendContent>(2, _omitFieldNames ? '' : 'contents',
        subBuilder: PugvSeasonRecommendContent.$_createMessage)
    ..aOM<PugvSeasonRecommendMore>(3, _omitFieldNames ? '' : 'moreInfo',
        subBuilder: PugvSeasonRecommendMore.$_createMessage)
    ..aE<PugvSeasonRecommendShowStyle>(4, _omitFieldNames ? '' : 'showStyle',
        enumValues: PugvSeasonRecommendShowStyle.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonRecommend clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonRecommend copyWith(void Function(PugvSeasonRecommend) updates) =>
      super.copyWith((message) => updates(message as PugvSeasonRecommend))
          as PugvSeasonRecommend;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use PugvSeasonRecommend() / PugvSeasonRecommend.new instead')
  static PugvSeasonRecommend create() => PugvSeasonRecommend._();
  static $pb.GeneratedMessage $_createMessage() => PugvSeasonRecommend._();
  @$core.override
  PugvSeasonRecommend createEmptyInstance() => PugvSeasonRecommend._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonRecommend getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeasonRecommend>(
          PugvSeasonRecommend.$_createMessage);
  static PugvSeasonRecommend? _defaultInstance;

  @$pb.TagNumber(1)
  PugvSeasonNav get nav => $_getN(0);
  @$pb.TagNumber(1)
  set nav(PugvSeasonNav value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNav() => $_has(0);
  @$pb.TagNumber(1)
  void clearNav() => $_clearField(1);
  @$pb.TagNumber(1)
  PugvSeasonNav ensureNav() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<PugvSeasonRecommendContent> get contents => $_getList(1);

  @$pb.TagNumber(3)
  PugvSeasonRecommendMore get moreInfo => $_getN(2);
  @$pb.TagNumber(3)
  set moreInfo(PugvSeasonRecommendMore value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMoreInfo() => $_has(2);
  @$pb.TagNumber(3)
  void clearMoreInfo() => $_clearField(3);
  @$pb.TagNumber(3)
  PugvSeasonRecommendMore ensureMoreInfo() => $_ensure(2);

  @$pb.TagNumber(4)
  PugvSeasonRecommendShowStyle get showStyle => $_getN(3);
  @$pb.TagNumber(4)
  set showStyle(PugvSeasonRecommendShowStyle value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasShowStyle() => $_has(3);
  @$pb.TagNumber(4)
  void clearShowStyle() => $_clearField(4);
}

class PugvSeasonRecommendContent extends $pb.GeneratedMessage {
  factory PugvSeasonRecommendContent({
    $core.String? coverUrl,
    $core.String? title,
    $core.String? subtitle,
    $core.String? link,
    $core.String? desc,
    $fixnum.Int64? seasonId,
    $core.String? author,
    StatInfo? view,
    BadgeInfo? rcmdReason,
  }) {
    final result = PugvSeasonRecommendContent._();
    if (coverUrl != null) result.coverUrl = coverUrl;
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    if (link != null) result.link = link;
    if (desc != null) result.desc = desc;
    if (seasonId != null) result.seasonId = seasonId;
    if (author != null) result.author = author;
    if (view != null) result.view = view;
    if (rcmdReason != null) result.rcmdReason = rcmdReason;
    return result;
  }

  PugvSeasonRecommendContent._();

  factory PugvSeasonRecommendContent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonRecommendContent()..mergeFromBuffer(data, registry);
  factory PugvSeasonRecommendContent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonRecommendContent()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonRecommendContent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonRecommendContent.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'coverUrl')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'subtitle')
    ..aOS(4, _omitFieldNames ? '' : 'link')
    ..aOS(5, _omitFieldNames ? '' : 'desc')
    ..aInt64(6, _omitFieldNames ? '' : 'seasonId')
    ..aOS(7, _omitFieldNames ? '' : 'author')
    ..aOM<StatInfo>(8, _omitFieldNames ? '' : 'view',
        subBuilder: StatInfo.$_createMessage)
    ..aOM<BadgeInfo>(9, _omitFieldNames ? '' : 'rcmdReason',
        subBuilder: BadgeInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonRecommendContent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonRecommendContent copyWith(
          void Function(PugvSeasonRecommendContent) updates) =>
      super.copyWith(
              (message) => updates(message as PugvSeasonRecommendContent))
          as PugvSeasonRecommendContent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PugvSeasonRecommendContent() / PugvSeasonRecommendContent.new instead')
  static PugvSeasonRecommendContent create() => PugvSeasonRecommendContent._();
  static $pb.GeneratedMessage $_createMessage() =>
      PugvSeasonRecommendContent._();
  @$core.override
  PugvSeasonRecommendContent createEmptyInstance() =>
      PugvSeasonRecommendContent._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonRecommendContent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeasonRecommendContent>(
          PugvSeasonRecommendContent.$_createMessage);
  static PugvSeasonRecommendContent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get coverUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set coverUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCoverUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoverUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get subtitle => $_getSZ(2);
  @$pb.TagNumber(3)
  set subtitle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubtitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubtitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get link => $_getSZ(3);
  @$pb.TagNumber(4)
  set link($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLink() => $_has(3);
  @$pb.TagNumber(4)
  void clearLink() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get desc => $_getSZ(4);
  @$pb.TagNumber(5)
  set desc($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDesc() => $_has(4);
  @$pb.TagNumber(5)
  void clearDesc() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get seasonId => $_getI64(5);
  @$pb.TagNumber(6)
  set seasonId($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSeasonId() => $_has(5);
  @$pb.TagNumber(6)
  void clearSeasonId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get author => $_getSZ(6);
  @$pb.TagNumber(7)
  set author($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAuthor() => $_has(6);
  @$pb.TagNumber(7)
  void clearAuthor() => $_clearField(7);

  @$pb.TagNumber(8)
  StatInfo get view => $_getN(7);
  @$pb.TagNumber(8)
  set view(StatInfo value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasView() => $_has(7);
  @$pb.TagNumber(8)
  void clearView() => $_clearField(8);
  @$pb.TagNumber(8)
  StatInfo ensureView() => $_ensure(7);

  @$pb.TagNumber(9)
  BadgeInfo get rcmdReason => $_getN(8);
  @$pb.TagNumber(9)
  set rcmdReason(BadgeInfo value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasRcmdReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearRcmdReason() => $_clearField(9);
  @$pb.TagNumber(9)
  BadgeInfo ensureRcmdReason() => $_ensure(8);
}

class PugvSeasonRecommendMore extends $pb.GeneratedMessage {
  factory PugvSeasonRecommendMore({
    $core.String? title,
    $core.String? link,
    $core.String? linkText,
  }) {
    final result = PugvSeasonRecommendMore._();
    if (title != null) result.title = title;
    if (link != null) result.link = link;
    if (linkText != null) result.linkText = linkText;
    return result;
  }

  PugvSeasonRecommendMore._();

  factory PugvSeasonRecommendMore.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonRecommendMore()..mergeFromBuffer(data, registry);
  factory PugvSeasonRecommendMore.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonRecommendMore()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonRecommendMore',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonRecommendMore.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'link')
    ..aOS(3, _omitFieldNames ? '' : 'linkText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonRecommendMore clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonRecommendMore copyWith(
          void Function(PugvSeasonRecommendMore) updates) =>
      super.copyWith((message) => updates(message as PugvSeasonRecommendMore))
          as PugvSeasonRecommendMore;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PugvSeasonRecommendMore() / PugvSeasonRecommendMore.new instead')
  static PugvSeasonRecommendMore create() => PugvSeasonRecommendMore._();
  static $pb.GeneratedMessage $_createMessage() => PugvSeasonRecommendMore._();
  @$core.override
  PugvSeasonRecommendMore createEmptyInstance() => PugvSeasonRecommendMore._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonRecommendMore getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeasonRecommendMore>(
          PugvSeasonRecommendMore.$_createMessage);
  static PugvSeasonRecommendMore? _defaultInstance;

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
  $core.String get linkText => $_getSZ(2);
  @$pb.TagNumber(3)
  set linkText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLinkText() => $_has(2);
  @$pb.TagNumber(3)
  void clearLinkText() => $_clearField(3);
}

class PugvSeasonSelection extends $pb.GeneratedMessage {
  factory PugvSeasonSelection({
    PugvSeasonNav? nav,
  }) {
    final result = PugvSeasonSelection._();
    if (nav != null) result.nav = nav;
    return result;
  }

  PugvSeasonSelection._();

  factory PugvSeasonSelection.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonSelection()..mergeFromBuffer(data, registry);
  factory PugvSeasonSelection.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeasonSelection()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeasonSelection',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeasonSelection.$_createMessage)
    ..aOM<PugvSeasonNav>(1, _omitFieldNames ? '' : 'nav',
        subBuilder: PugvSeasonNav.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonSelection clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeasonSelection copyWith(void Function(PugvSeasonSelection) updates) =>
      super.copyWith((message) => updates(message as PugvSeasonSelection))
          as PugvSeasonSelection;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use PugvSeasonSelection() / PugvSeasonSelection.new instead')
  static PugvSeasonSelection create() => PugvSeasonSelection._();
  static $pb.GeneratedMessage $_createMessage() => PugvSeasonSelection._();
  @$core.override
  PugvSeasonSelection createEmptyInstance() => PugvSeasonSelection._();
  @$core.pragma('dart2js:noInline')
  static PugvSeasonSelection getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeasonSelection>(
          PugvSeasonSelection.$_createMessage);
  static PugvSeasonSelection? _defaultInstance;

  @$pb.TagNumber(1)
  PugvSeasonNav get nav => $_getN(0);
  @$pb.TagNumber(1)
  set nav(PugvSeasonNav value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNav() => $_has(0);
  @$pb.TagNumber(1)
  void clearNav() => $_clearField(1);
  @$pb.TagNumber(1)
  PugvSeasonNav ensureNav() => $_ensure(0);
}

class PugvSeries extends $pb.GeneratedMessage {
  factory PugvSeries({
    PugvSeasonNav? nav,
    $core.Iterable<PugvSeriesItem>? contents,
  }) {
    final result = PugvSeries._();
    if (nav != null) result.nav = nav;
    if (contents != null) result.contents.addAll(contents);
    return result;
  }

  PugvSeries._();

  factory PugvSeries.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeries()..mergeFromBuffer(data, registry);
  factory PugvSeries.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeries()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeries',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeries.$_createMessage)
    ..aOM<PugvSeasonNav>(1, _omitFieldNames ? '' : 'nav',
        subBuilder: PugvSeasonNav.$_createMessage)
    ..pPM<PugvSeriesItem>(2, _omitFieldNames ? '' : 'contents',
        subBuilder: PugvSeriesItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeries clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeries copyWith(void Function(PugvSeries) updates) =>
      super.copyWith((message) => updates(message as PugvSeries)) as PugvSeries;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PugvSeries() / PugvSeries.new instead')
  static PugvSeries create() => PugvSeries._();
  static $pb.GeneratedMessage $_createMessage() => PugvSeries._();
  @$core.override
  PugvSeries createEmptyInstance() => PugvSeries._();
  @$core.pragma('dart2js:noInline')
  static PugvSeries getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvSeries>(PugvSeries.$_createMessage);
  static PugvSeries? _defaultInstance;

  @$pb.TagNumber(1)
  PugvSeasonNav get nav => $_getN(0);
  @$pb.TagNumber(1)
  set nav(PugvSeasonNav value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNav() => $_has(0);
  @$pb.TagNumber(1)
  void clearNav() => $_clearField(1);
  @$pb.TagNumber(1)
  PugvSeasonNav ensureNav() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<PugvSeriesItem> get contents => $_getList(1);
}

class PugvSeriesItem extends $pb.GeneratedMessage {
  factory PugvSeriesItem({
    $fixnum.Int64? seasonId,
    $core.bool? selected,
    $core.bool? gray,
    $core.String? content,
    $core.String? label,
    PugvSeriesItemState? state,
  }) {
    final result = PugvSeriesItem._();
    if (seasonId != null) result.seasonId = seasonId;
    if (selected != null) result.selected = selected;
    if (gray != null) result.gray = gray;
    if (content != null) result.content = content;
    if (label != null) result.label = label;
    if (state != null) result.state = state;
    return result;
  }

  PugvSeriesItem._();

  factory PugvSeriesItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeriesItem()..mergeFromBuffer(data, registry);
  factory PugvSeriesItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvSeriesItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvSeriesItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvSeriesItem.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'seasonId')
    ..aOB(2, _omitFieldNames ? '' : 'selected')
    ..aOB(3, _omitFieldNames ? '' : 'gray')
    ..aOS(4, _omitFieldNames ? '' : 'content')
    ..aOS(5, _omitFieldNames ? '' : 'label')
    ..aE<PugvSeriesItemState>(6, _omitFieldNames ? '' : 'state',
        enumValues: PugvSeriesItemState.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeriesItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvSeriesItem copyWith(void Function(PugvSeriesItem) updates) =>
      super.copyWith((message) => updates(message as PugvSeriesItem))
          as PugvSeriesItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PugvSeriesItem() / PugvSeriesItem.new instead')
  static PugvSeriesItem create() => PugvSeriesItem._();
  static $pb.GeneratedMessage $_createMessage() => PugvSeriesItem._();
  @$core.override
  PugvSeriesItem createEmptyInstance() => PugvSeriesItem._();
  @$core.pragma('dart2js:noInline')
  static PugvSeriesItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PugvSeriesItem>(
          PugvSeriesItem.$_createMessage);
  static PugvSeriesItem? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get seasonId => $_getI64(0);
  @$pb.TagNumber(1)
  set seasonId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeasonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeasonId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get selected => $_getBF(1);
  @$pb.TagNumber(2)
  set selected($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSelected() => $_has(1);
  @$pb.TagNumber(2)
  void clearSelected() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get gray => $_getBF(2);
  @$pb.TagNumber(3)
  set gray($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGray() => $_has(2);
  @$pb.TagNumber(3)
  void clearGray() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get content => $_getSZ(3);
  @$pb.TagNumber(4)
  set content($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContent() => $_has(3);
  @$pb.TagNumber(4)
  void clearContent() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get label => $_getSZ(4);
  @$pb.TagNumber(5)
  set label($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLabel() => $_has(4);
  @$pb.TagNumber(5)
  void clearLabel() => $_clearField(5);

  @$pb.TagNumber(6)
  PugvSeriesItemState get state => $_getN(5);
  @$pb.TagNumber(6)
  set state(PugvSeriesItemState value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasState() => $_has(5);
  @$pb.TagNumber(6)
  void clearState() => $_clearField(6);
}

class PugvShoppingNotice extends $pb.GeneratedMessage {
  factory PugvShoppingNotice({
    PugvSeasonNav? nav,
    $core.Iterable<PugvShoppingNoticeContent>? contents,
    $core.String? link,
  }) {
    final result = PugvShoppingNotice._();
    if (nav != null) result.nav = nav;
    if (contents != null) result.contents.addAll(contents);
    if (link != null) result.link = link;
    return result;
  }

  PugvShoppingNotice._();

  factory PugvShoppingNotice.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvShoppingNotice()..mergeFromBuffer(data, registry);
  factory PugvShoppingNotice.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvShoppingNotice()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvShoppingNotice',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvShoppingNotice.$_createMessage)
    ..aOM<PugvSeasonNav>(1, _omitFieldNames ? '' : 'nav',
        subBuilder: PugvSeasonNav.$_createMessage)
    ..pPM<PugvShoppingNoticeContent>(2, _omitFieldNames ? '' : 'contents',
        subBuilder: PugvShoppingNoticeContent.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'link')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvShoppingNotice clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvShoppingNotice copyWith(void Function(PugvShoppingNotice) updates) =>
      super.copyWith((message) => updates(message as PugvShoppingNotice))
          as PugvShoppingNotice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PugvShoppingNotice() / PugvShoppingNotice.new instead')
  static PugvShoppingNotice create() => PugvShoppingNotice._();
  static $pb.GeneratedMessage $_createMessage() => PugvShoppingNotice._();
  @$core.override
  PugvShoppingNotice createEmptyInstance() => PugvShoppingNotice._();
  @$core.pragma('dart2js:noInline')
  static PugvShoppingNotice getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvShoppingNotice>(
          PugvShoppingNotice.$_createMessage);
  static PugvShoppingNotice? _defaultInstance;

  @$pb.TagNumber(1)
  PugvSeasonNav get nav => $_getN(0);
  @$pb.TagNumber(1)
  set nav(PugvSeasonNav value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNav() => $_has(0);
  @$pb.TagNumber(1)
  void clearNav() => $_clearField(1);
  @$pb.TagNumber(1)
  PugvSeasonNav ensureNav() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<PugvShoppingNoticeContent> get contents => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get link => $_getSZ(2);
  @$pb.TagNumber(3)
  set link($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLink() => $_has(2);
  @$pb.TagNumber(3)
  void clearLink() => $_clearField(3);
}

class PugvShoppingNoticeContent extends $pb.GeneratedMessage {
  factory PugvShoppingNoticeContent({
    $core.String? number,
    $core.String? content,
    $core.bool? isBold,
  }) {
    final result = PugvShoppingNoticeContent._();
    if (number != null) result.number = number;
    if (content != null) result.content = content;
    if (isBold != null) result.isBold = isBold;
    return result;
  }

  PugvShoppingNoticeContent._();

  factory PugvShoppingNoticeContent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvShoppingNoticeContent()..mergeFromBuffer(data, registry);
  factory PugvShoppingNoticeContent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvShoppingNoticeContent()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvShoppingNoticeContent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvShoppingNoticeContent.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'number')
    ..aOS(2, _omitFieldNames ? '' : 'content')
    ..aOB(3, _omitFieldNames ? '' : 'isBold')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvShoppingNoticeContent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvShoppingNoticeContent copyWith(
          void Function(PugvShoppingNoticeContent) updates) =>
      super.copyWith((message) => updates(message as PugvShoppingNoticeContent))
          as PugvShoppingNoticeContent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PugvShoppingNoticeContent() / PugvShoppingNoticeContent.new instead')
  static PugvShoppingNoticeContent create() => PugvShoppingNoticeContent._();
  static $pb.GeneratedMessage $_createMessage() =>
      PugvShoppingNoticeContent._();
  @$core.override
  PugvShoppingNoticeContent createEmptyInstance() =>
      PugvShoppingNoticeContent._();
  @$core.pragma('dart2js:noInline')
  static PugvShoppingNoticeContent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvShoppingNoticeContent>(
          PugvShoppingNoticeContent.$_createMessage);
  static PugvShoppingNoticeContent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get number => $_getSZ(0);
  @$pb.TagNumber(1)
  set number($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get content => $_getSZ(1);
  @$pb.TagNumber(2)
  set content($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isBold => $_getBF(2);
  @$pb.TagNumber(3)
  set isBold($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsBold() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsBold() => $_clearField(3);
}

class PugvZone extends $pb.GeneratedMessage {
  factory PugvZone({
    $core.Iterable<PugvZoneItem>? contents,
  }) {
    final result = PugvZone._();
    if (contents != null) result.contents.addAll(contents);
    return result;
  }

  PugvZone._();

  factory PugvZone.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvZone()..mergeFromBuffer(data, registry);
  factory PugvZone.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvZone()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvZone',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvZone.$_createMessage)
    ..pPM<PugvZoneItem>(1, _omitFieldNames ? '' : 'contents',
        subBuilder: PugvZoneItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvZone clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvZone copyWith(void Function(PugvZone) updates) =>
      super.copyWith((message) => updates(message as PugvZone)) as PugvZone;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PugvZone() / PugvZone.new instead')
  static PugvZone create() => PugvZone._();
  static $pb.GeneratedMessage $_createMessage() => PugvZone._();
  @$core.override
  PugvZone createEmptyInstance() => PugvZone._();
  @$core.pragma('dart2js:noInline')
  static PugvZone getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PugvZone>(PugvZone.$_createMessage);
  static PugvZone? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PugvZoneItem> get contents => $_getList(0);
}

class PugvZoneItem extends $pb.GeneratedMessage {
  factory PugvZoneItem({
    $core.String? icon,
    $core.String? link,
    $core.String? title,
    $core.String? subtitle,
    PugvZoneItemType? type,
  }) {
    final result = PugvZoneItem._();
    if (icon != null) result.icon = icon;
    if (link != null) result.link = link;
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    if (type != null) result.type = type;
    return result;
  }

  PugvZoneItem._();

  factory PugvZoneItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvZoneItem()..mergeFromBuffer(data, registry);
  factory PugvZoneItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PugvZoneItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PugvZoneItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: PugvZoneItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'icon')
    ..aOS(2, _omitFieldNames ? '' : 'link')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'subtitle')
    ..aE<PugvZoneItemType>(5, _omitFieldNames ? '' : 'type',
        enumValues: PugvZoneItemType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvZoneItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PugvZoneItem copyWith(void Function(PugvZoneItem) updates) =>
      super.copyWith((message) => updates(message as PugvZoneItem))
          as PugvZoneItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PugvZoneItem() / PugvZoneItem.new instead')
  static PugvZoneItem create() => PugvZoneItem._();
  static $pb.GeneratedMessage $_createMessage() => PugvZoneItem._();
  @$core.override
  PugvZoneItem createEmptyInstance() => PugvZoneItem._();
  @$core.pragma('dart2js:noInline')
  static PugvZoneItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PugvZoneItem>(
          PugvZoneItem.$_createMessage);
  static PugvZoneItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get icon => $_getSZ(0);
  @$pb.TagNumber(1)
  set icon($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIcon() => $_has(0);
  @$pb.TagNumber(1)
  void clearIcon() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get link => $_getSZ(1);
  @$pb.TagNumber(2)
  set link($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLink() => $_has(1);
  @$pb.TagNumber(2)
  void clearLink() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get subtitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set subtitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubtitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubtitle() => $_clearField(4);

  @$pb.TagNumber(5)
  PugvZoneItemType get type => $_getN(4);
  @$pb.TagNumber(5)
  set type(PugvZoneItemType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasType() => $_has(4);
  @$pb.TagNumber(5)
  void clearType() => $_clearField(5);
}

class Rank extends $pb.GeneratedMessage {
  factory Rank({
    $core.String? icon,
    $core.String? iconNight,
    $core.String? text,
  }) {
    final result = Rank._();
    if (icon != null) result.icon = icon;
    if (iconNight != null) result.iconNight = iconNight;
    if (text != null) result.text = text;
    return result;
  }

  Rank._();

  factory Rank.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Rank()..mergeFromBuffer(data, registry);
  factory Rank.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Rank()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Rank',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Rank.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'icon')
    ..aOS(2, _omitFieldNames ? '' : 'iconNight')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Rank clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Rank copyWith(void Function(Rank) updates) =>
      super.copyWith((message) => updates(message as Rank)) as Rank;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Rank() / Rank.new instead')
  static Rank create() => Rank._();
  static $pb.GeneratedMessage $_createMessage() => Rank._();
  @$core.override
  Rank createEmptyInstance() => Rank._();
  @$core.pragma('dart2js:noInline')
  static Rank getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Rank>(Rank.$_createMessage);
  static Rank? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get icon => $_getSZ(0);
  @$pb.TagNumber(1)
  set icon($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIcon() => $_has(0);
  @$pb.TagNumber(1)
  void clearIcon() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get iconNight => $_getSZ(1);
  @$pb.TagNumber(2)
  set iconNight($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIconNight() => $_has(1);
  @$pb.TagNumber(2)
  void clearIconNight() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);
}

class RankInfo extends $pb.GeneratedMessage {
  factory RankInfo({
    $core.String? iconUrlNight,
    $core.String? iconUrlDay,
    $core.String? bkgNightColor,
    $core.String? bkgDayColor,
    $core.String? fontNightColor,
    $core.String? fontDayColor,
    $core.String? rankContent,
    $core.String? rankLink,
  }) {
    final result = RankInfo._();
    if (iconUrlNight != null) result.iconUrlNight = iconUrlNight;
    if (iconUrlDay != null) result.iconUrlDay = iconUrlDay;
    if (bkgNightColor != null) result.bkgNightColor = bkgNightColor;
    if (bkgDayColor != null) result.bkgDayColor = bkgDayColor;
    if (fontNightColor != null) result.fontNightColor = fontNightColor;
    if (fontDayColor != null) result.fontDayColor = fontDayColor;
    if (rankContent != null) result.rankContent = rankContent;
    if (rankLink != null) result.rankLink = rankLink;
    return result;
  }

  RankInfo._();

  factory RankInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RankInfo()..mergeFromBuffer(data, registry);
  factory RankInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RankInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RankInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RankInfo.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'iconUrlNight')
    ..aOS(2, _omitFieldNames ? '' : 'iconUrlDay')
    ..aOS(3, _omitFieldNames ? '' : 'bkgNightColor')
    ..aOS(4, _omitFieldNames ? '' : 'bkgDayColor')
    ..aOS(5, _omitFieldNames ? '' : 'fontNightColor')
    ..aOS(6, _omitFieldNames ? '' : 'fontDayColor')
    ..aOS(7, _omitFieldNames ? '' : 'rankContent')
    ..aOS(8, _omitFieldNames ? '' : 'rankLink')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RankInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RankInfo copyWith(void Function(RankInfo) updates) =>
      super.copyWith((message) => updates(message as RankInfo)) as RankInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RankInfo() / RankInfo.new instead')
  static RankInfo create() => RankInfo._();
  static $pb.GeneratedMessage $_createMessage() => RankInfo._();
  @$core.override
  RankInfo createEmptyInstance() => RankInfo._();
  @$core.pragma('dart2js:noInline')
  static RankInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RankInfo>(RankInfo.$_createMessage);
  static RankInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get iconUrlNight => $_getSZ(0);
  @$pb.TagNumber(1)
  set iconUrlNight($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIconUrlNight() => $_has(0);
  @$pb.TagNumber(1)
  void clearIconUrlNight() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get iconUrlDay => $_getSZ(1);
  @$pb.TagNumber(2)
  set iconUrlDay($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIconUrlDay() => $_has(1);
  @$pb.TagNumber(2)
  void clearIconUrlDay() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get bkgNightColor => $_getSZ(2);
  @$pb.TagNumber(3)
  set bkgNightColor($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBkgNightColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearBkgNightColor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get bkgDayColor => $_getSZ(3);
  @$pb.TagNumber(4)
  set bkgDayColor($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBkgDayColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearBkgDayColor() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get fontNightColor => $_getSZ(4);
  @$pb.TagNumber(5)
  set fontNightColor($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFontNightColor() => $_has(4);
  @$pb.TagNumber(5)
  void clearFontNightColor() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get fontDayColor => $_getSZ(5);
  @$pb.TagNumber(6)
  set fontDayColor($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFontDayColor() => $_has(5);
  @$pb.TagNumber(6)
  void clearFontDayColor() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get rankContent => $_getSZ(6);
  @$pb.TagNumber(7)
  set rankContent($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRankContent() => $_has(6);
  @$pb.TagNumber(7)
  void clearRankContent() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get rankLink => $_getSZ(7);
  @$pb.TagNumber(8)
  set rankLink($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRankLink() => $_has(7);
  @$pb.TagNumber(8)
  void clearRankLink() => $_clearField(8);
}

class Rating extends $pb.GeneratedMessage {
  factory Rating({
    $core.String? score,
    $core.int? count,
  }) {
    final result = Rating._();
    if (score != null) result.score = score;
    if (count != null) result.count = count;
    return result;
  }

  Rating._();

  factory Rating.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Rating()..mergeFromBuffer(data, registry);
  factory Rating.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Rating()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Rating',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Rating.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'score')
    ..aI(2, _omitFieldNames ? '' : 'count')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Rating clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Rating copyWith(void Function(Rating) updates) =>
      super.copyWith((message) => updates(message as Rating)) as Rating;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Rating() / Rating.new instead')
  static Rating create() => Rating._();
  static $pb.GeneratedMessage $_createMessage() => Rating._();
  @$core.override
  Rating createEmptyInstance() => Rating._();
  @$core.pragma('dart2js:noInline')
  static Rating getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Rating>(Rating.$_createMessage);
  static Rating? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get score => $_getSZ(0);
  @$pb.TagNumber(1)
  set score($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasScore() => $_has(0);
  @$pb.TagNumber(1)
  void clearScore() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get count => $_getIZ(1);
  @$pb.TagNumber(2)
  set count($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => $_clearField(2);
}

class RelateAVCard extends $pb.GeneratedMessage {
  factory RelateAVCard({
    $fixnum.Int64? duration,
    $fixnum.Int64? cid,
    Dimension? dimension,
    Stat? stat,
    $core.String? jumpUrl,
    $core.bool? showUpName,
    BadgeInfo? rcmdReason,
    $core.String? durationText,
    $core.bool? showRcmdStyle,
  }) {
    final result = RelateAVCard._();
    if (duration != null) result.duration = duration;
    if (cid != null) result.cid = cid;
    if (dimension != null) result.dimension = dimension;
    if (stat != null) result.stat = stat;
    if (jumpUrl != null) result.jumpUrl = jumpUrl;
    if (showUpName != null) result.showUpName = showUpName;
    if (rcmdReason != null) result.rcmdReason = rcmdReason;
    if (durationText != null) result.durationText = durationText;
    if (showRcmdStyle != null) result.showRcmdStyle = showRcmdStyle;
    return result;
  }

  RelateAVCard._();

  factory RelateAVCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateAVCard()..mergeFromBuffer(data, registry);
  factory RelateAVCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateAVCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelateAVCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RelateAVCard.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'duration')
    ..aInt64(2, _omitFieldNames ? '' : 'cid')
    ..aOM<Dimension>(3, _omitFieldNames ? '' : 'dimension',
        subBuilder: Dimension.$_createMessage)
    ..aOM<Stat>(4, _omitFieldNames ? '' : 'stat',
        subBuilder: Stat.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'jumpUrl')
    ..aOB(6, _omitFieldNames ? '' : 'showUpName')
    ..aOM<BadgeInfo>(7, _omitFieldNames ? '' : 'rcmdReason',
        subBuilder: BadgeInfo.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'durationText')
    ..aOB(9, _omitFieldNames ? '' : 'showRcmdStyle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateAVCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateAVCard copyWith(void Function(RelateAVCard) updates) =>
      super.copyWith((message) => updates(message as RelateAVCard))
          as RelateAVCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RelateAVCard() / RelateAVCard.new instead')
  static RelateAVCard create() => RelateAVCard._();
  static $pb.GeneratedMessage $_createMessage() => RelateAVCard._();
  @$core.override
  RelateAVCard createEmptyInstance() => RelateAVCard._();
  @$core.pragma('dart2js:noInline')
  static RelateAVCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RelateAVCard>(
          RelateAVCard.$_createMessage);
  static RelateAVCard? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get duration => $_getI64(0);
  @$pb.TagNumber(1)
  set duration($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDuration() => $_has(0);
  @$pb.TagNumber(1)
  void clearDuration() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get cid => $_getI64(1);
  @$pb.TagNumber(2)
  set cid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCid() => $_has(1);
  @$pb.TagNumber(2)
  void clearCid() => $_clearField(2);

  @$pb.TagNumber(3)
  Dimension get dimension => $_getN(2);
  @$pb.TagNumber(3)
  set dimension(Dimension value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDimension() => $_has(2);
  @$pb.TagNumber(3)
  void clearDimension() => $_clearField(3);
  @$pb.TagNumber(3)
  Dimension ensureDimension() => $_ensure(2);

  @$pb.TagNumber(4)
  Stat get stat => $_getN(3);
  @$pb.TagNumber(4)
  set stat(Stat value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStat() => $_has(3);
  @$pb.TagNumber(4)
  void clearStat() => $_clearField(4);
  @$pb.TagNumber(4)
  Stat ensureStat() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get jumpUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set jumpUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasJumpUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearJumpUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get showUpName => $_getBF(5);
  @$pb.TagNumber(6)
  set showUpName($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasShowUpName() => $_has(5);
  @$pb.TagNumber(6)
  void clearShowUpName() => $_clearField(6);

  @$pb.TagNumber(7)
  BadgeInfo get rcmdReason => $_getN(6);
  @$pb.TagNumber(7)
  set rcmdReason(BadgeInfo value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasRcmdReason() => $_has(6);
  @$pb.TagNumber(7)
  void clearRcmdReason() => $_clearField(7);
  @$pb.TagNumber(7)
  BadgeInfo ensureRcmdReason() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get durationText => $_getSZ(7);
  @$pb.TagNumber(8)
  set durationText($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDurationText() => $_has(7);
  @$pb.TagNumber(8)
  void clearDurationText() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get showRcmdStyle => $_getBF(8);
  @$pb.TagNumber(9)
  set showRcmdStyle($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasShowRcmdStyle() => $_has(8);
  @$pb.TagNumber(9)
  void clearShowRcmdStyle() => $_clearField(9);
}

class RelateBangumiAvCard extends $pb.GeneratedMessage {
  factory RelateBangumiAvCard({
    BadgeInfo? badge,
    Stat? stat,
    Rating? rating,
    $core.String? coverRightText,
    $core.bool? showRcmdStyle,
  }) {
    final result = RelateBangumiAvCard._();
    if (badge != null) result.badge = badge;
    if (stat != null) result.stat = stat;
    if (rating != null) result.rating = rating;
    if (coverRightText != null) result.coverRightText = coverRightText;
    if (showRcmdStyle != null) result.showRcmdStyle = showRcmdStyle;
    return result;
  }

  RelateBangumiAvCard._();

  factory RelateBangumiAvCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateBangumiAvCard()..mergeFromBuffer(data, registry);
  factory RelateBangumiAvCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateBangumiAvCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelateBangumiAvCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RelateBangumiAvCard.$_createMessage)
    ..aOM<BadgeInfo>(1, _omitFieldNames ? '' : 'badge',
        subBuilder: BadgeInfo.$_createMessage)
    ..aOM<Stat>(2, _omitFieldNames ? '' : 'stat',
        subBuilder: Stat.$_createMessage)
    ..aOM<Rating>(3, _omitFieldNames ? '' : 'rating',
        subBuilder: Rating.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'coverRightText')
    ..aOB(5, _omitFieldNames ? '' : 'showRcmdStyle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateBangumiAvCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateBangumiAvCard copyWith(void Function(RelateBangumiAvCard) updates) =>
      super.copyWith((message) => updates(message as RelateBangumiAvCard))
          as RelateBangumiAvCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use RelateBangumiAvCard() / RelateBangumiAvCard.new instead')
  static RelateBangumiAvCard create() => RelateBangumiAvCard._();
  static $pb.GeneratedMessage $_createMessage() => RelateBangumiAvCard._();
  @$core.override
  RelateBangumiAvCard createEmptyInstance() => RelateBangumiAvCard._();
  @$core.pragma('dart2js:noInline')
  static RelateBangumiAvCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RelateBangumiAvCard>(
          RelateBangumiAvCard.$_createMessage);
  static RelateBangumiAvCard? _defaultInstance;

  @$pb.TagNumber(1)
  BadgeInfo get badge => $_getN(0);
  @$pb.TagNumber(1)
  set badge(BadgeInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBadge() => $_has(0);
  @$pb.TagNumber(1)
  void clearBadge() => $_clearField(1);
  @$pb.TagNumber(1)
  BadgeInfo ensureBadge() => $_ensure(0);

  @$pb.TagNumber(2)
  Stat get stat => $_getN(1);
  @$pb.TagNumber(2)
  set stat(Stat value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStat() => $_has(1);
  @$pb.TagNumber(2)
  void clearStat() => $_clearField(2);
  @$pb.TagNumber(2)
  Stat ensureStat() => $_ensure(1);

  @$pb.TagNumber(3)
  Rating get rating => $_getN(2);
  @$pb.TagNumber(3)
  set rating(Rating value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRating() => $_has(2);
  @$pb.TagNumber(3)
  void clearRating() => $_clearField(3);
  @$pb.TagNumber(3)
  Rating ensureRating() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get coverRightText => $_getSZ(3);
  @$pb.TagNumber(4)
  set coverRightText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCoverRightText() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoverRightText() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get showRcmdStyle => $_getBF(4);
  @$pb.TagNumber(5)
  set showRcmdStyle($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasShowRcmdStyle() => $_has(4);
  @$pb.TagNumber(5)
  void clearShowRcmdStyle() => $_clearField(5);
}

class RelateBangumiCard extends $pb.GeneratedMessage {
  factory RelateBangumiCard({
    $core.int? seasonId,
    $core.int? seasonType,
    NewEp? newEp,
    Stat? stat,
    Rating? rating,
    $core.String? rcmdReason,
    BadgeInfo? badgeInfo,
    $core.String? gotoType,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
  }) {
    final result = RelateBangumiCard._();
    if (seasonId != null) result.seasonId = seasonId;
    if (seasonType != null) result.seasonType = seasonType;
    if (newEp != null) result.newEp = newEp;
    if (stat != null) result.stat = stat;
    if (rating != null) result.rating = rating;
    if (rcmdReason != null) result.rcmdReason = rcmdReason;
    if (badgeInfo != null) result.badgeInfo = badgeInfo;
    if (gotoType != null) result.gotoType = gotoType;
    if (report != null) result.report.addEntries(report);
    return result;
  }

  RelateBangumiCard._();

  factory RelateBangumiCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateBangumiCard()..mergeFromBuffer(data, registry);
  factory RelateBangumiCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateBangumiCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelateBangumiCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RelateBangumiCard.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'seasonId')
    ..aI(2, _omitFieldNames ? '' : 'seasonType')
    ..aOM<NewEp>(3, _omitFieldNames ? '' : 'newEp',
        subBuilder: NewEp.$_createMessage)
    ..aOM<Stat>(4, _omitFieldNames ? '' : 'stat',
        subBuilder: Stat.$_createMessage)
    ..aOM<Rating>(5, _omitFieldNames ? '' : 'rating',
        subBuilder: Rating.$_createMessage)
    ..aOS(6, _omitFieldNames ? '' : 'rcmdReason')
    ..aOM<BadgeInfo>(7, _omitFieldNames ? '' : 'badgeInfo',
        subBuilder: BadgeInfo.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'gotoType')
    ..m<$core.String, $core.String>(9, _omitFieldNames ? '' : 'report',
        entryClassName: 'RelateBangumiCard.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateBangumiCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateBangumiCard copyWith(void Function(RelateBangumiCard) updates) =>
      super.copyWith((message) => updates(message as RelateBangumiCard))
          as RelateBangumiCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RelateBangumiCard() / RelateBangumiCard.new instead')
  static RelateBangumiCard create() => RelateBangumiCard._();
  static $pb.GeneratedMessage $_createMessage() => RelateBangumiCard._();
  @$core.override
  RelateBangumiCard createEmptyInstance() => RelateBangumiCard._();
  @$core.pragma('dart2js:noInline')
  static RelateBangumiCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RelateBangumiCard>(
          RelateBangumiCard.$_createMessage);
  static RelateBangumiCard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seasonId => $_getIZ(0);
  @$pb.TagNumber(1)
  set seasonId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeasonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeasonId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get seasonType => $_getIZ(1);
  @$pb.TagNumber(2)
  set seasonType($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSeasonType() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeasonType() => $_clearField(2);

  @$pb.TagNumber(3)
  NewEp get newEp => $_getN(2);
  @$pb.TagNumber(3)
  set newEp(NewEp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNewEp() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewEp() => $_clearField(3);
  @$pb.TagNumber(3)
  NewEp ensureNewEp() => $_ensure(2);

  @$pb.TagNumber(4)
  Stat get stat => $_getN(3);
  @$pb.TagNumber(4)
  set stat(Stat value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStat() => $_has(3);
  @$pb.TagNumber(4)
  void clearStat() => $_clearField(4);
  @$pb.TagNumber(4)
  Stat ensureStat() => $_ensure(3);

  @$pb.TagNumber(5)
  Rating get rating => $_getN(4);
  @$pb.TagNumber(5)
  set rating(Rating value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRating() => $_has(4);
  @$pb.TagNumber(5)
  void clearRating() => $_clearField(5);
  @$pb.TagNumber(5)
  Rating ensureRating() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get rcmdReason => $_getSZ(5);
  @$pb.TagNumber(6)
  set rcmdReason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRcmdReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearRcmdReason() => $_clearField(6);

  @$pb.TagNumber(7)
  BadgeInfo get badgeInfo => $_getN(6);
  @$pb.TagNumber(7)
  set badgeInfo(BadgeInfo value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasBadgeInfo() => $_has(6);
  @$pb.TagNumber(7)
  void clearBadgeInfo() => $_clearField(7);
  @$pb.TagNumber(7)
  BadgeInfo ensureBadgeInfo() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get gotoType => $_getSZ(7);
  @$pb.TagNumber(8)
  set gotoType($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasGotoType() => $_has(7);
  @$pb.TagNumber(8)
  void clearGotoType() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(8);
}

class RelateBangumiResourceCard extends $pb.GeneratedMessage {
  factory RelateBangumiResourceCard({
    $core.int? type,
    $core.String? scover,
    $core.int? reType,
    $core.String? reValue,
    $core.String? corner,
    $core.int? card,
    $core.String? siz,
    $core.int? position,
    $core.String? rcmdReason,
    $core.String? label,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
    $core.String? gotoType,
  }) {
    final result = RelateBangumiResourceCard._();
    if (type != null) result.type = type;
    if (scover != null) result.scover = scover;
    if (reType != null) result.reType = reType;
    if (reValue != null) result.reValue = reValue;
    if (corner != null) result.corner = corner;
    if (card != null) result.card = card;
    if (siz != null) result.siz = siz;
    if (position != null) result.position = position;
    if (rcmdReason != null) result.rcmdReason = rcmdReason;
    if (label != null) result.label = label;
    if (report != null) result.report.addEntries(report);
    if (gotoType != null) result.gotoType = gotoType;
    return result;
  }

  RelateBangumiResourceCard._();

  factory RelateBangumiResourceCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateBangumiResourceCard()..mergeFromBuffer(data, registry);
  factory RelateBangumiResourceCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateBangumiResourceCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelateBangumiResourceCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RelateBangumiResourceCard.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'type')
    ..aOS(2, _omitFieldNames ? '' : 'scover')
    ..aI(3, _omitFieldNames ? '' : 'reType')
    ..aOS(4, _omitFieldNames ? '' : 'reValue')
    ..aOS(5, _omitFieldNames ? '' : 'corner')
    ..aI(6, _omitFieldNames ? '' : 'card')
    ..aOS(7, _omitFieldNames ? '' : 'siz')
    ..aI(8, _omitFieldNames ? '' : 'position')
    ..aOS(9, _omitFieldNames ? '' : 'rcmdReason')
    ..aOS(10, _omitFieldNames ? '' : 'label')
    ..m<$core.String, $core.String>(11, _omitFieldNames ? '' : 'report',
        entryClassName: 'RelateBangumiResourceCard.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..aOS(12, _omitFieldNames ? '' : 'gotoType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateBangumiResourceCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateBangumiResourceCard copyWith(
          void Function(RelateBangumiResourceCard) updates) =>
      super.copyWith((message) => updates(message as RelateBangumiResourceCard))
          as RelateBangumiResourceCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RelateBangumiResourceCard() / RelateBangumiResourceCard.new instead')
  static RelateBangumiResourceCard create() => RelateBangumiResourceCard._();
  static $pb.GeneratedMessage $_createMessage() =>
      RelateBangumiResourceCard._();
  @$core.override
  RelateBangumiResourceCard createEmptyInstance() =>
      RelateBangumiResourceCard._();
  @$core.pragma('dart2js:noInline')
  static RelateBangumiResourceCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RelateBangumiResourceCard>(
          RelateBangumiResourceCard.$_createMessage);
  static RelateBangumiResourceCard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scover => $_getSZ(1);
  @$pb.TagNumber(2)
  set scover($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScover() => $_has(1);
  @$pb.TagNumber(2)
  void clearScover() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get reType => $_getIZ(2);
  @$pb.TagNumber(3)
  set reType($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReType() => $_has(2);
  @$pb.TagNumber(3)
  void clearReType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reValue => $_getSZ(3);
  @$pb.TagNumber(4)
  set reValue($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearReValue() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get corner => $_getSZ(4);
  @$pb.TagNumber(5)
  set corner($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCorner() => $_has(4);
  @$pb.TagNumber(5)
  void clearCorner() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get card => $_getIZ(5);
  @$pb.TagNumber(6)
  set card($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCard() => $_has(5);
  @$pb.TagNumber(6)
  void clearCard() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get siz => $_getSZ(6);
  @$pb.TagNumber(7)
  set siz($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSiz() => $_has(6);
  @$pb.TagNumber(7)
  void clearSiz() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get position => $_getIZ(7);
  @$pb.TagNumber(8)
  set position($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPosition() => $_has(7);
  @$pb.TagNumber(8)
  void clearPosition() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get rcmdReason => $_getSZ(8);
  @$pb.TagNumber(9)
  set rcmdReason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRcmdReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearRcmdReason() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get label => $_getSZ(9);
  @$pb.TagNumber(10)
  set label($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasLabel() => $_has(9);
  @$pb.TagNumber(10)
  void clearLabel() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(10);

  @$pb.TagNumber(12)
  $core.String get gotoType => $_getSZ(11);
  @$pb.TagNumber(12)
  set gotoType($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasGotoType() => $_has(11);
  @$pb.TagNumber(12)
  void clearGotoType() => $_clearField(12);
}

class RelateBangumiUGCCard extends $pb.GeneratedMessage {
  factory RelateBangumiUGCCard({
    BadgeInfo? badge,
    Stat? stat,
    Rating? rating,
  }) {
    final result = RelateBangumiUGCCard._();
    if (badge != null) result.badge = badge;
    if (stat != null) result.stat = stat;
    if (rating != null) result.rating = rating;
    return result;
  }

  RelateBangumiUGCCard._();

  factory RelateBangumiUGCCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateBangumiUGCCard()..mergeFromBuffer(data, registry);
  factory RelateBangumiUGCCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateBangumiUGCCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelateBangumiUGCCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RelateBangumiUGCCard.$_createMessage)
    ..aOM<BadgeInfo>(1, _omitFieldNames ? '' : 'badge',
        subBuilder: BadgeInfo.$_createMessage)
    ..aOM<Stat>(2, _omitFieldNames ? '' : 'stat',
        subBuilder: Stat.$_createMessage)
    ..aOM<Rating>(3, _omitFieldNames ? '' : 'rating',
        subBuilder: Rating.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateBangumiUGCCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateBangumiUGCCard copyWith(void Function(RelateBangumiUGCCard) updates) =>
      super.copyWith((message) => updates(message as RelateBangumiUGCCard))
          as RelateBangumiUGCCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RelateBangumiUGCCard() / RelateBangumiUGCCard.new instead')
  static RelateBangumiUGCCard create() => RelateBangumiUGCCard._();
  static $pb.GeneratedMessage $_createMessage() => RelateBangumiUGCCard._();
  @$core.override
  RelateBangumiUGCCard createEmptyInstance() => RelateBangumiUGCCard._();
  @$core.pragma('dart2js:noInline')
  static RelateBangumiUGCCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RelateBangumiUGCCard>(
          RelateBangumiUGCCard.$_createMessage);
  static RelateBangumiUGCCard? _defaultInstance;

  @$pb.TagNumber(1)
  BadgeInfo get badge => $_getN(0);
  @$pb.TagNumber(1)
  set badge(BadgeInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBadge() => $_has(0);
  @$pb.TagNumber(1)
  void clearBadge() => $_clearField(1);
  @$pb.TagNumber(1)
  BadgeInfo ensureBadge() => $_ensure(0);

  @$pb.TagNumber(2)
  Stat get stat => $_getN(1);
  @$pb.TagNumber(2)
  set stat(Stat value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStat() => $_has(1);
  @$pb.TagNumber(2)
  void clearStat() => $_clearField(2);
  @$pb.TagNumber(2)
  Stat ensureStat() => $_ensure(1);

  @$pb.TagNumber(3)
  Rating get rating => $_getN(2);
  @$pb.TagNumber(3)
  set rating(Rating value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRating() => $_has(2);
  @$pb.TagNumber(3)
  void clearRating() => $_clearField(3);
  @$pb.TagNumber(3)
  Rating ensureRating() => $_ensure(2);
}

class RelateCMCard extends $pb.GeneratedMessage {
  factory RelateCMCard({
    $fixnum.Int64? aid,
    $0.Any? sourceContent,
    $fixnum.Int64? duration,
    Stat? stat,
    $core.int? natureAd,
  }) {
    final result = RelateCMCard._();
    if (aid != null) result.aid = aid;
    if (sourceContent != null) result.sourceContent = sourceContent;
    if (duration != null) result.duration = duration;
    if (stat != null) result.stat = stat;
    if (natureAd != null) result.natureAd = natureAd;
    return result;
  }

  RelateCMCard._();

  factory RelateCMCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateCMCard()..mergeFromBuffer(data, registry);
  factory RelateCMCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateCMCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelateCMCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RelateCMCard.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aOM<$0.Any>(2, _omitFieldNames ? '' : 'sourceContent',
        subBuilder: $0.Any.$_createMessage)
    ..aInt64(3, _omitFieldNames ? '' : 'duration')
    ..aOM<Stat>(4, _omitFieldNames ? '' : 'stat',
        subBuilder: Stat.$_createMessage)
    ..aI(5, _omitFieldNames ? '' : 'natureAd')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateCMCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateCMCard copyWith(void Function(RelateCMCard) updates) =>
      super.copyWith((message) => updates(message as RelateCMCard))
          as RelateCMCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RelateCMCard() / RelateCMCard.new instead')
  static RelateCMCard create() => RelateCMCard._();
  static $pb.GeneratedMessage $_createMessage() => RelateCMCard._();
  @$core.override
  RelateCMCard createEmptyInstance() => RelateCMCard._();
  @$core.pragma('dart2js:noInline')
  static RelateCMCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RelateCMCard>(
          RelateCMCard.$_createMessage);
  static RelateCMCard? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get aid => $_getI64(0);
  @$pb.TagNumber(1)
  set aid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Any get sourceContent => $_getN(1);
  @$pb.TagNumber(2)
  set sourceContent($0.Any value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSourceContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearSourceContent() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Any ensureSourceContent() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get duration => $_getI64(2);
  @$pb.TagNumber(3)
  set duration($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDuration() => $_has(2);
  @$pb.TagNumber(3)
  void clearDuration() => $_clearField(3);

  @$pb.TagNumber(4)
  Stat get stat => $_getN(3);
  @$pb.TagNumber(4)
  set stat(Stat value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStat() => $_has(3);
  @$pb.TagNumber(4)
  void clearStat() => $_clearField(4);
  @$pb.TagNumber(4)
  Stat ensureStat() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get natureAd => $_getIZ(4);
  @$pb.TagNumber(5)
  set natureAd($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNatureAd() => $_has(4);
  @$pb.TagNumber(5)
  void clearNatureAd() => $_clearField(5);
}

enum RelateCard_Card {
  av,
  bangumi,
  resource,
  game,
  cm,
  live,
  bangumiAv,
  aiCard,
  bangumiUgc,
  special,
  course,
  miniProgram,
  historyAv,
  notSet
}

class RelateCard extends $pb.GeneratedMessage {
  factory RelateCard({
    RelateCardType? relateCardType,
    RelateAVCard? av,
    RelateBangumiCard? bangumi,
    RelateBangumiResourceCard? resource,
    RelateGameCard? game,
    RelateCMCard? cm,
    RelateLiveCard? live,
    RelateBangumiAvCard? bangumiAv,
    RelatedAICard? aiCard,
    RelateThreePoint? threePoint,
    $0.Any? cmStock,
    CardBasicInfo? basicInfo,
    RelateBangumiUGCCard? bangumiUgc,
    RelateSpecial? special,
    RelateCourseCard? course,
    RelateMiniProgramCard? miniProgram,
    RelateHistoryAVCard? historyAv,
  }) {
    final result = RelateCard._();
    if (relateCardType != null) result.relateCardType = relateCardType;
    if (av != null) result.av = av;
    if (bangumi != null) result.bangumi = bangumi;
    if (resource != null) result.resource = resource;
    if (game != null) result.game = game;
    if (cm != null) result.cm = cm;
    if (live != null) result.live = live;
    if (bangumiAv != null) result.bangumiAv = bangumiAv;
    if (aiCard != null) result.aiCard = aiCard;
    if (threePoint != null) result.threePoint = threePoint;
    if (cmStock != null) result.cmStock = cmStock;
    if (basicInfo != null) result.basicInfo = basicInfo;
    if (bangumiUgc != null) result.bangumiUgc = bangumiUgc;
    if (special != null) result.special = special;
    if (course != null) result.course = course;
    if (miniProgram != null) result.miniProgram = miniProgram;
    if (historyAv != null) result.historyAv = historyAv;
    return result;
  }

  RelateCard._();

  factory RelateCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateCard()..mergeFromBuffer(data, registry);
  factory RelateCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateCard()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, RelateCard_Card> _RelateCard_CardByTag = {
    2: RelateCard_Card.av,
    3: RelateCard_Card.bangumi,
    4: RelateCard_Card.resource,
    5: RelateCard_Card.game,
    6: RelateCard_Card.cm,
    7: RelateCard_Card.live,
    8: RelateCard_Card.bangumiAv,
    9: RelateCard_Card.aiCard,
    13: RelateCard_Card.bangumiUgc,
    14: RelateCard_Card.special,
    15: RelateCard_Card.course,
    16: RelateCard_Card.miniProgram,
    17: RelateCard_Card.historyAv,
    0: RelateCard_Card.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelateCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RelateCard.$_createMessage)
    ..oo(0, [2, 3, 4, 5, 6, 7, 8, 9, 13, 14, 15, 16, 17])
    ..aE<RelateCardType>(1, _omitFieldNames ? '' : 'relateCardType',
        enumValues: RelateCardType.values)
    ..aOM<RelateAVCard>(2, _omitFieldNames ? '' : 'av',
        subBuilder: RelateAVCard.$_createMessage)
    ..aOM<RelateBangumiCard>(3, _omitFieldNames ? '' : 'bangumi',
        subBuilder: RelateBangumiCard.$_createMessage)
    ..aOM<RelateBangumiResourceCard>(4, _omitFieldNames ? '' : 'resource',
        subBuilder: RelateBangumiResourceCard.$_createMessage)
    ..aOM<RelateGameCard>(5, _omitFieldNames ? '' : 'game',
        subBuilder: RelateGameCard.$_createMessage)
    ..aOM<RelateCMCard>(6, _omitFieldNames ? '' : 'cm',
        subBuilder: RelateCMCard.$_createMessage)
    ..aOM<RelateLiveCard>(7, _omitFieldNames ? '' : 'live',
        subBuilder: RelateLiveCard.$_createMessage)
    ..aOM<RelateBangumiAvCard>(8, _omitFieldNames ? '' : 'bangumiAv',
        subBuilder: RelateBangumiAvCard.$_createMessage)
    ..aOM<RelatedAICard>(9, _omitFieldNames ? '' : 'aiCard',
        subBuilder: RelatedAICard.$_createMessage)
    ..aOM<RelateThreePoint>(10, _omitFieldNames ? '' : 'threePoint',
        subBuilder: RelateThreePoint.$_createMessage)
    ..aOM<$0.Any>(11, _omitFieldNames ? '' : 'cmStock',
        subBuilder: $0.Any.$_createMessage)
    ..aOM<CardBasicInfo>(12, _omitFieldNames ? '' : 'basicInfo',
        subBuilder: CardBasicInfo.$_createMessage)
    ..aOM<RelateBangumiUGCCard>(13, _omitFieldNames ? '' : 'bangumiUgc',
        subBuilder: RelateBangumiUGCCard.$_createMessage)
    ..aOM<RelateSpecial>(14, _omitFieldNames ? '' : 'special',
        subBuilder: RelateSpecial.$_createMessage)
    ..aOM<RelateCourseCard>(15, _omitFieldNames ? '' : 'course',
        subBuilder: RelateCourseCard.$_createMessage)
    ..aOM<RelateMiniProgramCard>(16, _omitFieldNames ? '' : 'miniProgram',
        subBuilder: RelateMiniProgramCard.$_createMessage)
    ..aOM<RelateHistoryAVCard>(17, _omitFieldNames ? '' : 'historyAv',
        subBuilder: RelateHistoryAVCard.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateCard copyWith(void Function(RelateCard) updates) =>
      super.copyWith((message) => updates(message as RelateCard)) as RelateCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RelateCard() / RelateCard.new instead')
  static RelateCard create() => RelateCard._();
  static $pb.GeneratedMessage $_createMessage() => RelateCard._();
  @$core.override
  RelateCard createEmptyInstance() => RelateCard._();
  @$core.pragma('dart2js:noInline')
  static RelateCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RelateCard>(RelateCard.$_createMessage);
  static RelateCard? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  RelateCard_Card whichCard() => _RelateCard_CardByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  @$pb.TagNumber(17)
  void clearCard() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  RelateCardType get relateCardType => $_getN(0);
  @$pb.TagNumber(1)
  set relateCardType(RelateCardType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRelateCardType() => $_has(0);
  @$pb.TagNumber(1)
  void clearRelateCardType() => $_clearField(1);

  @$pb.TagNumber(2)
  RelateAVCard get av => $_getN(1);
  @$pb.TagNumber(2)
  set av(RelateAVCard value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAv() => $_has(1);
  @$pb.TagNumber(2)
  void clearAv() => $_clearField(2);
  @$pb.TagNumber(2)
  RelateAVCard ensureAv() => $_ensure(1);

  @$pb.TagNumber(3)
  RelateBangumiCard get bangumi => $_getN(2);
  @$pb.TagNumber(3)
  set bangumi(RelateBangumiCard value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBangumi() => $_has(2);
  @$pb.TagNumber(3)
  void clearBangumi() => $_clearField(3);
  @$pb.TagNumber(3)
  RelateBangumiCard ensureBangumi() => $_ensure(2);

  @$pb.TagNumber(4)
  RelateBangumiResourceCard get resource => $_getN(3);
  @$pb.TagNumber(4)
  set resource(RelateBangumiResourceCard value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasResource() => $_has(3);
  @$pb.TagNumber(4)
  void clearResource() => $_clearField(4);
  @$pb.TagNumber(4)
  RelateBangumiResourceCard ensureResource() => $_ensure(3);

  @$pb.TagNumber(5)
  RelateGameCard get game => $_getN(4);
  @$pb.TagNumber(5)
  set game(RelateGameCard value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasGame() => $_has(4);
  @$pb.TagNumber(5)
  void clearGame() => $_clearField(5);
  @$pb.TagNumber(5)
  RelateGameCard ensureGame() => $_ensure(4);

  @$pb.TagNumber(6)
  RelateCMCard get cm => $_getN(5);
  @$pb.TagNumber(6)
  set cm(RelateCMCard value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCm() => $_has(5);
  @$pb.TagNumber(6)
  void clearCm() => $_clearField(6);
  @$pb.TagNumber(6)
  RelateCMCard ensureCm() => $_ensure(5);

  @$pb.TagNumber(7)
  RelateLiveCard get live => $_getN(6);
  @$pb.TagNumber(7)
  set live(RelateLiveCard value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasLive() => $_has(6);
  @$pb.TagNumber(7)
  void clearLive() => $_clearField(7);
  @$pb.TagNumber(7)
  RelateLiveCard ensureLive() => $_ensure(6);

  @$pb.TagNumber(8)
  RelateBangumiAvCard get bangumiAv => $_getN(7);
  @$pb.TagNumber(8)
  set bangumiAv(RelateBangumiAvCard value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasBangumiAv() => $_has(7);
  @$pb.TagNumber(8)
  void clearBangumiAv() => $_clearField(8);
  @$pb.TagNumber(8)
  RelateBangumiAvCard ensureBangumiAv() => $_ensure(7);

  @$pb.TagNumber(9)
  RelatedAICard get aiCard => $_getN(8);
  @$pb.TagNumber(9)
  set aiCard(RelatedAICard value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasAiCard() => $_has(8);
  @$pb.TagNumber(9)
  void clearAiCard() => $_clearField(9);
  @$pb.TagNumber(9)
  RelatedAICard ensureAiCard() => $_ensure(8);

  @$pb.TagNumber(10)
  RelateThreePoint get threePoint => $_getN(9);
  @$pb.TagNumber(10)
  set threePoint(RelateThreePoint value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasThreePoint() => $_has(9);
  @$pb.TagNumber(10)
  void clearThreePoint() => $_clearField(10);
  @$pb.TagNumber(10)
  RelateThreePoint ensureThreePoint() => $_ensure(9);

  @$pb.TagNumber(11)
  $0.Any get cmStock => $_getN(10);
  @$pb.TagNumber(11)
  set cmStock($0.Any value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasCmStock() => $_has(10);
  @$pb.TagNumber(11)
  void clearCmStock() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Any ensureCmStock() => $_ensure(10);

  @$pb.TagNumber(12)
  CardBasicInfo get basicInfo => $_getN(11);
  @$pb.TagNumber(12)
  set basicInfo(CardBasicInfo value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasBasicInfo() => $_has(11);
  @$pb.TagNumber(12)
  void clearBasicInfo() => $_clearField(12);
  @$pb.TagNumber(12)
  CardBasicInfo ensureBasicInfo() => $_ensure(11);

  @$pb.TagNumber(13)
  RelateBangumiUGCCard get bangumiUgc => $_getN(12);
  @$pb.TagNumber(13)
  set bangumiUgc(RelateBangumiUGCCard value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasBangumiUgc() => $_has(12);
  @$pb.TagNumber(13)
  void clearBangumiUgc() => $_clearField(13);
  @$pb.TagNumber(13)
  RelateBangumiUGCCard ensureBangumiUgc() => $_ensure(12);

  @$pb.TagNumber(14)
  RelateSpecial get special => $_getN(13);
  @$pb.TagNumber(14)
  set special(RelateSpecial value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasSpecial() => $_has(13);
  @$pb.TagNumber(14)
  void clearSpecial() => $_clearField(14);
  @$pb.TagNumber(14)
  RelateSpecial ensureSpecial() => $_ensure(13);

  @$pb.TagNumber(15)
  RelateCourseCard get course => $_getN(14);
  @$pb.TagNumber(15)
  set course(RelateCourseCard value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasCourse() => $_has(14);
  @$pb.TagNumber(15)
  void clearCourse() => $_clearField(15);
  @$pb.TagNumber(15)
  RelateCourseCard ensureCourse() => $_ensure(14);

  @$pb.TagNumber(16)
  RelateMiniProgramCard get miniProgram => $_getN(15);
  @$pb.TagNumber(16)
  set miniProgram(RelateMiniProgramCard value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasMiniProgram() => $_has(15);
  @$pb.TagNumber(16)
  void clearMiniProgram() => $_clearField(16);
  @$pb.TagNumber(16)
  RelateMiniProgramCard ensureMiniProgram() => $_ensure(15);

  @$pb.TagNumber(17)
  RelateHistoryAVCard get historyAv => $_getN(16);
  @$pb.TagNumber(17)
  set historyAv(RelateHistoryAVCard value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasHistoryAv() => $_has(16);
  @$pb.TagNumber(17)
  void clearHistoryAv() => $_clearField(17);
  @$pb.TagNumber(17)
  RelateHistoryAVCard ensureHistoryAv() => $_ensure(16);
}

class RelateConfig extends $pb.GeneratedMessage {
  factory RelateConfig({
    $fixnum.Int64? validShowM,
    $fixnum.Int64? validShowN,
    $3.Pagination? pagination,
    $core.bool? canLoadMore,
    CoverDimension? dimension,
  }) {
    final result = RelateConfig._();
    if (validShowM != null) result.validShowM = validShowM;
    if (validShowN != null) result.validShowN = validShowN;
    if (pagination != null) result.pagination = pagination;
    if (canLoadMore != null) result.canLoadMore = canLoadMore;
    if (dimension != null) result.dimension = dimension;
    return result;
  }

  RelateConfig._();

  factory RelateConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateConfig()..mergeFromBuffer(data, registry);
  factory RelateConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelateConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RelateConfig.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'validShowM')
    ..aInt64(2, _omitFieldNames ? '' : 'validShowN')
    ..aOM<$3.Pagination>(3, _omitFieldNames ? '' : 'pagination',
        subBuilder: $3.Pagination.$_createMessage)
    ..aOB(4, _omitFieldNames ? '' : 'canLoadMore')
    ..aOM<CoverDimension>(5, _omitFieldNames ? '' : 'dimension',
        subBuilder: CoverDimension.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateConfig copyWith(void Function(RelateConfig) updates) =>
      super.copyWith((message) => updates(message as RelateConfig))
          as RelateConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RelateConfig() / RelateConfig.new instead')
  static RelateConfig create() => RelateConfig._();
  static $pb.GeneratedMessage $_createMessage() => RelateConfig._();
  @$core.override
  RelateConfig createEmptyInstance() => RelateConfig._();
  @$core.pragma('dart2js:noInline')
  static RelateConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RelateConfig>(
          RelateConfig.$_createMessage);
  static RelateConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get validShowM => $_getI64(0);
  @$pb.TagNumber(1)
  set validShowM($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValidShowM() => $_has(0);
  @$pb.TagNumber(1)
  void clearValidShowM() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get validShowN => $_getI64(1);
  @$pb.TagNumber(2)
  set validShowN($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValidShowN() => $_has(1);
  @$pb.TagNumber(2)
  void clearValidShowN() => $_clearField(2);

  @$pb.TagNumber(3)
  $3.Pagination get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($3.Pagination value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => $_clearField(3);
  @$pb.TagNumber(3)
  $3.Pagination ensurePagination() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get canLoadMore => $_getBF(3);
  @$pb.TagNumber(4)
  set canLoadMore($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCanLoadMore() => $_has(3);
  @$pb.TagNumber(4)
  void clearCanLoadMore() => $_clearField(4);

  @$pb.TagNumber(5)
  CoverDimension get dimension => $_getN(4);
  @$pb.TagNumber(5)
  set dimension(CoverDimension value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDimension() => $_has(4);
  @$pb.TagNumber(5)
  void clearDimension() => $_clearField(5);
  @$pb.TagNumber(5)
  CoverDimension ensureDimension() => $_ensure(4);
}

class RelateCourseCard extends $pb.GeneratedMessage {
  factory RelateCourseCard({
    $fixnum.Int64? duration,
    Stat? stat,
    BadgeInfo? rcmdReason,
    BadgeInfo? badgeInfo,
    $core.int? style,
    $core.bool? showRcmdStyle,
  }) {
    final result = RelateCourseCard._();
    if (duration != null) result.duration = duration;
    if (stat != null) result.stat = stat;
    if (rcmdReason != null) result.rcmdReason = rcmdReason;
    if (badgeInfo != null) result.badgeInfo = badgeInfo;
    if (style != null) result.style = style;
    if (showRcmdStyle != null) result.showRcmdStyle = showRcmdStyle;
    return result;
  }

  RelateCourseCard._();

  factory RelateCourseCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateCourseCard()..mergeFromBuffer(data, registry);
  factory RelateCourseCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateCourseCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelateCourseCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RelateCourseCard.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'duration')
    ..aOM<Stat>(2, _omitFieldNames ? '' : 'stat',
        subBuilder: Stat.$_createMessage)
    ..aOM<BadgeInfo>(3, _omitFieldNames ? '' : 'rcmdReason',
        subBuilder: BadgeInfo.$_createMessage)
    ..aOM<BadgeInfo>(4, _omitFieldNames ? '' : 'badgeInfo',
        subBuilder: BadgeInfo.$_createMessage)
    ..aI(5, _omitFieldNames ? '' : 'style')
    ..aOB(6, _omitFieldNames ? '' : 'showRcmdStyle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateCourseCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateCourseCard copyWith(void Function(RelateCourseCard) updates) =>
      super.copyWith((message) => updates(message as RelateCourseCard))
          as RelateCourseCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RelateCourseCard() / RelateCourseCard.new instead')
  static RelateCourseCard create() => RelateCourseCard._();
  static $pb.GeneratedMessage $_createMessage() => RelateCourseCard._();
  @$core.override
  RelateCourseCard createEmptyInstance() => RelateCourseCard._();
  @$core.pragma('dart2js:noInline')
  static RelateCourseCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RelateCourseCard>(
          RelateCourseCard.$_createMessage);
  static RelateCourseCard? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get duration => $_getI64(0);
  @$pb.TagNumber(1)
  set duration($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDuration() => $_has(0);
  @$pb.TagNumber(1)
  void clearDuration() => $_clearField(1);

  @$pb.TagNumber(2)
  Stat get stat => $_getN(1);
  @$pb.TagNumber(2)
  set stat(Stat value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStat() => $_has(1);
  @$pb.TagNumber(2)
  void clearStat() => $_clearField(2);
  @$pb.TagNumber(2)
  Stat ensureStat() => $_ensure(1);

  @$pb.TagNumber(3)
  BadgeInfo get rcmdReason => $_getN(2);
  @$pb.TagNumber(3)
  set rcmdReason(BadgeInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRcmdReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearRcmdReason() => $_clearField(3);
  @$pb.TagNumber(3)
  BadgeInfo ensureRcmdReason() => $_ensure(2);

  @$pb.TagNumber(4)
  BadgeInfo get badgeInfo => $_getN(3);
  @$pb.TagNumber(4)
  set badgeInfo(BadgeInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBadgeInfo() => $_has(3);
  @$pb.TagNumber(4)
  void clearBadgeInfo() => $_clearField(4);
  @$pb.TagNumber(4)
  BadgeInfo ensureBadgeInfo() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get style => $_getIZ(4);
  @$pb.TagNumber(5)
  set style($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStyle() => $_has(4);
  @$pb.TagNumber(5)
  void clearStyle() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get showRcmdStyle => $_getBF(5);
  @$pb.TagNumber(6)
  set showRcmdStyle($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasShowRcmdStyle() => $_has(5);
  @$pb.TagNumber(6)
  void clearShowRcmdStyle() => $_clearField(6);
}

class RelateDislike extends $pb.GeneratedMessage {
  factory RelateDislike({
    $core.String? title,
    $core.String? subTitle,
    $core.String? closedSubTitle,
    $core.String? pasteText,
    $core.String? closedPasteText,
    $core.Iterable<DislikeReasons>? dislikeReason,
    $core.String? toast,
    $core.String? closedToast,
  }) {
    final result = RelateDislike._();
    if (title != null) result.title = title;
    if (subTitle != null) result.subTitle = subTitle;
    if (closedSubTitle != null) result.closedSubTitle = closedSubTitle;
    if (pasteText != null) result.pasteText = pasteText;
    if (closedPasteText != null) result.closedPasteText = closedPasteText;
    if (dislikeReason != null) result.dislikeReason.addAll(dislikeReason);
    if (toast != null) result.toast = toast;
    if (closedToast != null) result.closedToast = closedToast;
    return result;
  }

  RelateDislike._();

  factory RelateDislike.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateDislike()..mergeFromBuffer(data, registry);
  factory RelateDislike.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateDislike()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelateDislike',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RelateDislike.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'subTitle')
    ..aOS(3, _omitFieldNames ? '' : 'closedSubTitle')
    ..aOS(4, _omitFieldNames ? '' : 'pasteText')
    ..aOS(5, _omitFieldNames ? '' : 'closedPasteText')
    ..pPM<DislikeReasons>(6, _omitFieldNames ? '' : 'dislikeReason',
        subBuilder: DislikeReasons.$_createMessage)
    ..aOS(7, _omitFieldNames ? '' : 'toast')
    ..aOS(8, _omitFieldNames ? '' : 'closedToast')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateDislike clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateDislike copyWith(void Function(RelateDislike) updates) =>
      super.copyWith((message) => updates(message as RelateDislike))
          as RelateDislike;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RelateDislike() / RelateDislike.new instead')
  static RelateDislike create() => RelateDislike._();
  static $pb.GeneratedMessage $_createMessage() => RelateDislike._();
  @$core.override
  RelateDislike createEmptyInstance() => RelateDislike._();
  @$core.pragma('dart2js:noInline')
  static RelateDislike getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RelateDislike>(
          RelateDislike.$_createMessage);
  static RelateDislike? _defaultInstance;

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
  $core.String get closedSubTitle => $_getSZ(2);
  @$pb.TagNumber(3)
  set closedSubTitle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasClosedSubTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearClosedSubTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get pasteText => $_getSZ(3);
  @$pb.TagNumber(4)
  set pasteText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPasteText() => $_has(3);
  @$pb.TagNumber(4)
  void clearPasteText() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get closedPasteText => $_getSZ(4);
  @$pb.TagNumber(5)
  set closedPasteText($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasClosedPasteText() => $_has(4);
  @$pb.TagNumber(5)
  void clearClosedPasteText() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<DislikeReasons> get dislikeReason => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get toast => $_getSZ(6);
  @$pb.TagNumber(7)
  set toast($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasToast() => $_has(6);
  @$pb.TagNumber(7)
  void clearToast() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get closedToast => $_getSZ(7);
  @$pb.TagNumber(8)
  set closedToast($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasClosedToast() => $_has(7);
  @$pb.TagNumber(8)
  void clearClosedToast() => $_clearField(8);
}

class RelateGameCard extends $pb.GeneratedMessage {
  factory RelateGameCard({
    $fixnum.Int64? reserveStatus,
    $core.String? reserveStatusText,
    $core.String? reserve,
    $core.double? rating,
    $core.String? tagName,
    RankInfo? rankInfo,
    Button? packInfo,
    Button? notice,
    PowerIconStyle? powerIconStyle,
    $core.String? gameRcmdReason,
    WikiInfo? wikiInfo,
    BadgeInfo? badge,
  }) {
    final result = RelateGameCard._();
    if (reserveStatus != null) result.reserveStatus = reserveStatus;
    if (reserveStatusText != null) result.reserveStatusText = reserveStatusText;
    if (reserve != null) result.reserve = reserve;
    if (rating != null) result.rating = rating;
    if (tagName != null) result.tagName = tagName;
    if (rankInfo != null) result.rankInfo = rankInfo;
    if (packInfo != null) result.packInfo = packInfo;
    if (notice != null) result.notice = notice;
    if (powerIconStyle != null) result.powerIconStyle = powerIconStyle;
    if (gameRcmdReason != null) result.gameRcmdReason = gameRcmdReason;
    if (wikiInfo != null) result.wikiInfo = wikiInfo;
    if (badge != null) result.badge = badge;
    return result;
  }

  RelateGameCard._();

  factory RelateGameCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateGameCard()..mergeFromBuffer(data, registry);
  factory RelateGameCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateGameCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelateGameCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RelateGameCard.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'reserveStatus')
    ..aOS(2, _omitFieldNames ? '' : 'reserveStatusText')
    ..aOS(3, _omitFieldNames ? '' : 'reserve')
    ..aD(4, _omitFieldNames ? '' : 'rating', fieldType: $pb.PbFieldType.OF)
    ..aOS(5, _omitFieldNames ? '' : 'tagName')
    ..aOM<RankInfo>(6, _omitFieldNames ? '' : 'rankInfo',
        subBuilder: RankInfo.$_createMessage)
    ..aOM<Button>(7, _omitFieldNames ? '' : 'packInfo',
        subBuilder: Button.$_createMessage)
    ..aOM<Button>(8, _omitFieldNames ? '' : 'notice',
        subBuilder: Button.$_createMessage)
    ..aOM<PowerIconStyle>(9, _omitFieldNames ? '' : 'powerIconStyle',
        subBuilder: PowerIconStyle.$_createMessage)
    ..aOS(10, _omitFieldNames ? '' : 'gameRcmdReason')
    ..aOM<WikiInfo>(11, _omitFieldNames ? '' : 'wikiInfo',
        subBuilder: WikiInfo.$_createMessage)
    ..aOM<BadgeInfo>(12, _omitFieldNames ? '' : 'badge',
        subBuilder: BadgeInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateGameCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateGameCard copyWith(void Function(RelateGameCard) updates) =>
      super.copyWith((message) => updates(message as RelateGameCard))
          as RelateGameCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RelateGameCard() / RelateGameCard.new instead')
  static RelateGameCard create() => RelateGameCard._();
  static $pb.GeneratedMessage $_createMessage() => RelateGameCard._();
  @$core.override
  RelateGameCard createEmptyInstance() => RelateGameCard._();
  @$core.pragma('dart2js:noInline')
  static RelateGameCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RelateGameCard>(
          RelateGameCard.$_createMessage);
  static RelateGameCard? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get reserveStatus => $_getI64(0);
  @$pb.TagNumber(1)
  set reserveStatus($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReserveStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearReserveStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reserveStatusText => $_getSZ(1);
  @$pb.TagNumber(2)
  set reserveStatusText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReserveStatusText() => $_has(1);
  @$pb.TagNumber(2)
  void clearReserveStatusText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reserve => $_getSZ(2);
  @$pb.TagNumber(3)
  set reserve($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReserve() => $_has(2);
  @$pb.TagNumber(3)
  void clearReserve() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get rating => $_getN(3);
  @$pb.TagNumber(4)
  set rating($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRating() => $_has(3);
  @$pb.TagNumber(4)
  void clearRating() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get tagName => $_getSZ(4);
  @$pb.TagNumber(5)
  set tagName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTagName() => $_has(4);
  @$pb.TagNumber(5)
  void clearTagName() => $_clearField(5);

  @$pb.TagNumber(6)
  RankInfo get rankInfo => $_getN(5);
  @$pb.TagNumber(6)
  set rankInfo(RankInfo value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRankInfo() => $_has(5);
  @$pb.TagNumber(6)
  void clearRankInfo() => $_clearField(6);
  @$pb.TagNumber(6)
  RankInfo ensureRankInfo() => $_ensure(5);

  @$pb.TagNumber(7)
  Button get packInfo => $_getN(6);
  @$pb.TagNumber(7)
  set packInfo(Button value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPackInfo() => $_has(6);
  @$pb.TagNumber(7)
  void clearPackInfo() => $_clearField(7);
  @$pb.TagNumber(7)
  Button ensurePackInfo() => $_ensure(6);

  @$pb.TagNumber(8)
  Button get notice => $_getN(7);
  @$pb.TagNumber(8)
  set notice(Button value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasNotice() => $_has(7);
  @$pb.TagNumber(8)
  void clearNotice() => $_clearField(8);
  @$pb.TagNumber(8)
  Button ensureNotice() => $_ensure(7);

  @$pb.TagNumber(9)
  PowerIconStyle get powerIconStyle => $_getN(8);
  @$pb.TagNumber(9)
  set powerIconStyle(PowerIconStyle value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasPowerIconStyle() => $_has(8);
  @$pb.TagNumber(9)
  void clearPowerIconStyle() => $_clearField(9);
  @$pb.TagNumber(9)
  PowerIconStyle ensurePowerIconStyle() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get gameRcmdReason => $_getSZ(9);
  @$pb.TagNumber(10)
  set gameRcmdReason($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasGameRcmdReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearGameRcmdReason() => $_clearField(10);

  @$pb.TagNumber(11)
  WikiInfo get wikiInfo => $_getN(10);
  @$pb.TagNumber(11)
  set wikiInfo(WikiInfo value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasWikiInfo() => $_has(10);
  @$pb.TagNumber(11)
  void clearWikiInfo() => $_clearField(11);
  @$pb.TagNumber(11)
  WikiInfo ensureWikiInfo() => $_ensure(10);

  @$pb.TagNumber(12)
  BadgeInfo get badge => $_getN(11);
  @$pb.TagNumber(12)
  set badge(BadgeInfo value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasBadge() => $_has(11);
  @$pb.TagNumber(12)
  void clearBadge() => $_clearField(12);
  @$pb.TagNumber(12)
  BadgeInfo ensureBadge() => $_ensure(11);
}

class RelateHistoryAVCard extends $pb.GeneratedMessage {
  factory RelateHistoryAVCard({
    $fixnum.Int64? duration,
    $fixnum.Int64? progress,
    $fixnum.Int64? unix,
    $core.String? icon,
  }) {
    final result = RelateHistoryAVCard._();
    if (duration != null) result.duration = duration;
    if (progress != null) result.progress = progress;
    if (unix != null) result.unix = unix;
    if (icon != null) result.icon = icon;
    return result;
  }

  RelateHistoryAVCard._();

  factory RelateHistoryAVCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateHistoryAVCard()..mergeFromBuffer(data, registry);
  factory RelateHistoryAVCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateHistoryAVCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelateHistoryAVCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RelateHistoryAVCard.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'duration')
    ..aInt64(2, _omitFieldNames ? '' : 'progress')
    ..aInt64(3, _omitFieldNames ? '' : 'unix')
    ..aOS(4, _omitFieldNames ? '' : 'icon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateHistoryAVCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateHistoryAVCard copyWith(void Function(RelateHistoryAVCard) updates) =>
      super.copyWith((message) => updates(message as RelateHistoryAVCard))
          as RelateHistoryAVCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use RelateHistoryAVCard() / RelateHistoryAVCard.new instead')
  static RelateHistoryAVCard create() => RelateHistoryAVCard._();
  static $pb.GeneratedMessage $_createMessage() => RelateHistoryAVCard._();
  @$core.override
  RelateHistoryAVCard createEmptyInstance() => RelateHistoryAVCard._();
  @$core.pragma('dart2js:noInline')
  static RelateHistoryAVCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RelateHistoryAVCard>(
          RelateHistoryAVCard.$_createMessage);
  static RelateHistoryAVCard? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get duration => $_getI64(0);
  @$pb.TagNumber(1)
  set duration($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDuration() => $_has(0);
  @$pb.TagNumber(1)
  void clearDuration() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get progress => $_getI64(1);
  @$pb.TagNumber(2)
  set progress($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProgress() => $_has(1);
  @$pb.TagNumber(2)
  void clearProgress() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get unix => $_getI64(2);
  @$pb.TagNumber(3)
  set unix($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnix() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnix() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get icon => $_getSZ(3);
  @$pb.TagNumber(4)
  set icon($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIcon() => $_has(3);
  @$pb.TagNumber(4)
  void clearIcon() => $_clearField(4);
}

class RelateItem extends $pb.GeneratedMessage {
  factory RelateItem({
    $core.String? url,
    $core.String? cover,
    $core.bool? useDefaultBrowser,
  }) {
    final result = RelateItem._();
    if (url != null) result.url = url;
    if (cover != null) result.cover = cover;
    if (useDefaultBrowser != null) result.useDefaultBrowser = useDefaultBrowser;
    return result;
  }

  RelateItem._();

  factory RelateItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateItem()..mergeFromBuffer(data, registry);
  factory RelateItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelateItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RelateItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOS(2, _omitFieldNames ? '' : 'cover')
    ..aOB(3, _omitFieldNames ? '' : 'useDefaultBrowser')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateItem copyWith(void Function(RelateItem) updates) =>
      super.copyWith((message) => updates(message as RelateItem)) as RelateItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RelateItem() / RelateItem.new instead')
  static RelateItem create() => RelateItem._();
  static $pb.GeneratedMessage $_createMessage() => RelateItem._();
  @$core.override
  RelateItem createEmptyInstance() => RelateItem._();
  @$core.pragma('dart2js:noInline')
  static RelateItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RelateItem>(RelateItem.$_createMessage);
  static RelateItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cover => $_getSZ(1);
  @$pb.TagNumber(2)
  set cover($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCover() => $_has(1);
  @$pb.TagNumber(2)
  void clearCover() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get useDefaultBrowser => $_getBF(2);
  @$pb.TagNumber(3)
  set useDefaultBrowser($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUseDefaultBrowser() => $_has(2);
  @$pb.TagNumber(3)
  void clearUseDefaultBrowser() => $_clearField(3);
}

class RelateLiveCard extends $pb.GeneratedMessage {
  factory RelateLiveCard({
    $fixnum.Int64? iconType,
    $core.String? areaName,
    $fixnum.Int64? watchedShow,
    $fixnum.Int64? liveStatus,
    BadgeInfo? rcmdReason,
    $core.String? liveNewStyle,
    StatInfo? statInfo,
    $core.bool? showRcmdStyle,
  }) {
    final result = RelateLiveCard._();
    if (iconType != null) result.iconType = iconType;
    if (areaName != null) result.areaName = areaName;
    if (watchedShow != null) result.watchedShow = watchedShow;
    if (liveStatus != null) result.liveStatus = liveStatus;
    if (rcmdReason != null) result.rcmdReason = rcmdReason;
    if (liveNewStyle != null) result.liveNewStyle = liveNewStyle;
    if (statInfo != null) result.statInfo = statInfo;
    if (showRcmdStyle != null) result.showRcmdStyle = showRcmdStyle;
    return result;
  }

  RelateLiveCard._();

  factory RelateLiveCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateLiveCard()..mergeFromBuffer(data, registry);
  factory RelateLiveCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateLiveCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelateLiveCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RelateLiveCard.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'iconType')
    ..aOS(2, _omitFieldNames ? '' : 'areaName')
    ..aInt64(3, _omitFieldNames ? '' : 'watchedShow')
    ..aInt64(4, _omitFieldNames ? '' : 'liveStatus')
    ..aOM<BadgeInfo>(5, _omitFieldNames ? '' : 'rcmdReason',
        subBuilder: BadgeInfo.$_createMessage)
    ..aOS(6, _omitFieldNames ? '' : 'liveNewStyle')
    ..aOM<StatInfo>(7, _omitFieldNames ? '' : 'statInfo',
        subBuilder: StatInfo.$_createMessage)
    ..aOB(8, _omitFieldNames ? '' : 'showRcmdStyle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateLiveCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateLiveCard copyWith(void Function(RelateLiveCard) updates) =>
      super.copyWith((message) => updates(message as RelateLiveCard))
          as RelateLiveCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RelateLiveCard() / RelateLiveCard.new instead')
  static RelateLiveCard create() => RelateLiveCard._();
  static $pb.GeneratedMessage $_createMessage() => RelateLiveCard._();
  @$core.override
  RelateLiveCard createEmptyInstance() => RelateLiveCard._();
  @$core.pragma('dart2js:noInline')
  static RelateLiveCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RelateLiveCard>(
          RelateLiveCard.$_createMessage);
  static RelateLiveCard? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get iconType => $_getI64(0);
  @$pb.TagNumber(1)
  set iconType($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIconType() => $_has(0);
  @$pb.TagNumber(1)
  void clearIconType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get areaName => $_getSZ(1);
  @$pb.TagNumber(2)
  set areaName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAreaName() => $_has(1);
  @$pb.TagNumber(2)
  void clearAreaName() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get watchedShow => $_getI64(2);
  @$pb.TagNumber(3)
  set watchedShow($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWatchedShow() => $_has(2);
  @$pb.TagNumber(3)
  void clearWatchedShow() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get liveStatus => $_getI64(3);
  @$pb.TagNumber(4)
  set liveStatus($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLiveStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearLiveStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  BadgeInfo get rcmdReason => $_getN(4);
  @$pb.TagNumber(5)
  set rcmdReason(BadgeInfo value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRcmdReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearRcmdReason() => $_clearField(5);
  @$pb.TagNumber(5)
  BadgeInfo ensureRcmdReason() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get liveNewStyle => $_getSZ(5);
  @$pb.TagNumber(6)
  set liveNewStyle($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLiveNewStyle() => $_has(5);
  @$pb.TagNumber(6)
  void clearLiveNewStyle() => $_clearField(6);

  @$pb.TagNumber(7)
  StatInfo get statInfo => $_getN(6);
  @$pb.TagNumber(7)
  set statInfo(StatInfo value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStatInfo() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatInfo() => $_clearField(7);
  @$pb.TagNumber(7)
  StatInfo ensureStatInfo() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.bool get showRcmdStyle => $_getBF(7);
  @$pb.TagNumber(8)
  set showRcmdStyle($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasShowRcmdStyle() => $_has(7);
  @$pb.TagNumber(8)
  void clearShowRcmdStyle() => $_clearField(8);
}

class RelateMiniProgramCard extends $pb.GeneratedMessage {
  factory RelateMiniProgramCard({
    Stat? stat,
  }) {
    final result = RelateMiniProgramCard._();
    if (stat != null) result.stat = stat;
    return result;
  }

  RelateMiniProgramCard._();

  factory RelateMiniProgramCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateMiniProgramCard()..mergeFromBuffer(data, registry);
  factory RelateMiniProgramCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateMiniProgramCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelateMiniProgramCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RelateMiniProgramCard.$_createMessage)
    ..aOM<Stat>(1, _omitFieldNames ? '' : 'stat',
        subBuilder: Stat.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateMiniProgramCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateMiniProgramCard copyWith(
          void Function(RelateMiniProgramCard) updates) =>
      super.copyWith((message) => updates(message as RelateMiniProgramCard))
          as RelateMiniProgramCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RelateMiniProgramCard() / RelateMiniProgramCard.new instead')
  static RelateMiniProgramCard create() => RelateMiniProgramCard._();
  static $pb.GeneratedMessage $_createMessage() => RelateMiniProgramCard._();
  @$core.override
  RelateMiniProgramCard createEmptyInstance() => RelateMiniProgramCard._();
  @$core.pragma('dart2js:noInline')
  static RelateMiniProgramCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RelateMiniProgramCard>(
          RelateMiniProgramCard.$_createMessage);
  static RelateMiniProgramCard? _defaultInstance;

  @$pb.TagNumber(1)
  Stat get stat => $_getN(0);
  @$pb.TagNumber(1)
  set stat(Stat value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStat() => $_has(0);
  @$pb.TagNumber(1)
  void clearStat() => $_clearField(1);
  @$pb.TagNumber(1)
  Stat ensureStat() => $_ensure(0);
}

class RelateSpecial extends $pb.GeneratedMessage {
  factory RelateSpecial({
    BadgeInfo? badge,
    BadgeInfo? rcmdReason,
    $core.bool? showRcmdStyle,
  }) {
    final result = RelateSpecial._();
    if (badge != null) result.badge = badge;
    if (rcmdReason != null) result.rcmdReason = rcmdReason;
    if (showRcmdStyle != null) result.showRcmdStyle = showRcmdStyle;
    return result;
  }

  RelateSpecial._();

  factory RelateSpecial.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateSpecial()..mergeFromBuffer(data, registry);
  factory RelateSpecial.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateSpecial()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelateSpecial',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RelateSpecial.$_createMessage)
    ..aOM<BadgeInfo>(1, _omitFieldNames ? '' : 'badge',
        subBuilder: BadgeInfo.$_createMessage)
    ..aOM<BadgeInfo>(2, _omitFieldNames ? '' : 'rcmdReason',
        subBuilder: BadgeInfo.$_createMessage)
    ..aOB(3, _omitFieldNames ? '' : 'showRcmdStyle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateSpecial clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateSpecial copyWith(void Function(RelateSpecial) updates) =>
      super.copyWith((message) => updates(message as RelateSpecial))
          as RelateSpecial;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RelateSpecial() / RelateSpecial.new instead')
  static RelateSpecial create() => RelateSpecial._();
  static $pb.GeneratedMessage $_createMessage() => RelateSpecial._();
  @$core.override
  RelateSpecial createEmptyInstance() => RelateSpecial._();
  @$core.pragma('dart2js:noInline')
  static RelateSpecial getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RelateSpecial>(
          RelateSpecial.$_createMessage);
  static RelateSpecial? _defaultInstance;

  @$pb.TagNumber(1)
  BadgeInfo get badge => $_getN(0);
  @$pb.TagNumber(1)
  set badge(BadgeInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBadge() => $_has(0);
  @$pb.TagNumber(1)
  void clearBadge() => $_clearField(1);
  @$pb.TagNumber(1)
  BadgeInfo ensureBadge() => $_ensure(0);

  @$pb.TagNumber(2)
  BadgeInfo get rcmdReason => $_getN(1);
  @$pb.TagNumber(2)
  set rcmdReason(BadgeInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRcmdReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearRcmdReason() => $_clearField(2);
  @$pb.TagNumber(2)
  BadgeInfo ensureRcmdReason() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get showRcmdStyle => $_getBF(2);
  @$pb.TagNumber(3)
  set showRcmdStyle($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasShowRcmdStyle() => $_has(2);
  @$pb.TagNumber(3)
  void clearShowRcmdStyle() => $_clearField(3);
}

class RelateTab extends $pb.GeneratedMessage {
  factory RelateTab({
    $fixnum.Int64? tabCategory,
    $core.String? title,
  }) {
    final result = RelateTab._();
    if (tabCategory != null) result.tabCategory = tabCategory;
    if (title != null) result.title = title;
    return result;
  }

  RelateTab._();

  factory RelateTab.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateTab()..mergeFromBuffer(data, registry);
  factory RelateTab.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateTab()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelateTab',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RelateTab.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'tabCategory')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateTab clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateTab copyWith(void Function(RelateTab) updates) =>
      super.copyWith((message) => updates(message as RelateTab)) as RelateTab;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RelateTab() / RelateTab.new instead')
  static RelateTab create() => RelateTab._();
  static $pb.GeneratedMessage $_createMessage() => RelateTab._();
  @$core.override
  RelateTab createEmptyInstance() => RelateTab._();
  @$core.pragma('dart2js:noInline')
  static RelateTab getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RelateTab>(RelateTab.$_createMessage);
  static RelateTab? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get tabCategory => $_getI64(0);
  @$pb.TagNumber(1)
  set tabCategory($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTabCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearTabCategory() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);
}

class RelateThreePoint extends $pb.GeneratedMessage {
  factory RelateThreePoint({
    RelateDislike? dislike,
    RelateDislike? feedback,
    $core.bool? watchLater,
    $core.String? dislikeReportData,
  }) {
    final result = RelateThreePoint._();
    if (dislike != null) result.dislike = dislike;
    if (feedback != null) result.feedback = feedback;
    if (watchLater != null) result.watchLater = watchLater;
    if (dislikeReportData != null) result.dislikeReportData = dislikeReportData;
    return result;
  }

  RelateThreePoint._();

  factory RelateThreePoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateThreePoint()..mergeFromBuffer(data, registry);
  factory RelateThreePoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelateThreePoint()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelateThreePoint',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RelateThreePoint.$_createMessage)
    ..aOM<RelateDislike>(1, _omitFieldNames ? '' : 'dislike',
        subBuilder: RelateDislike.$_createMessage)
    ..aOM<RelateDislike>(2, _omitFieldNames ? '' : 'feedback',
        subBuilder: RelateDislike.$_createMessage)
    ..aOB(3, _omitFieldNames ? '' : 'watchLater')
    ..aOS(4, _omitFieldNames ? '' : 'dislikeReportData')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateThreePoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelateThreePoint copyWith(void Function(RelateThreePoint) updates) =>
      super.copyWith((message) => updates(message as RelateThreePoint))
          as RelateThreePoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RelateThreePoint() / RelateThreePoint.new instead')
  static RelateThreePoint create() => RelateThreePoint._();
  static $pb.GeneratedMessage $_createMessage() => RelateThreePoint._();
  @$core.override
  RelateThreePoint createEmptyInstance() => RelateThreePoint._();
  @$core.pragma('dart2js:noInline')
  static RelateThreePoint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RelateThreePoint>(
          RelateThreePoint.$_createMessage);
  static RelateThreePoint? _defaultInstance;

  @$pb.TagNumber(1)
  RelateDislike get dislike => $_getN(0);
  @$pb.TagNumber(1)
  set dislike(RelateDislike value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDislike() => $_has(0);
  @$pb.TagNumber(1)
  void clearDislike() => $_clearField(1);
  @$pb.TagNumber(1)
  RelateDislike ensureDislike() => $_ensure(0);

  @$pb.TagNumber(2)
  RelateDislike get feedback => $_getN(1);
  @$pb.TagNumber(2)
  set feedback(RelateDislike value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFeedback() => $_has(1);
  @$pb.TagNumber(2)
  void clearFeedback() => $_clearField(2);
  @$pb.TagNumber(2)
  RelateDislike ensureFeedback() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get watchLater => $_getBF(2);
  @$pb.TagNumber(3)
  set watchLater($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWatchLater() => $_has(2);
  @$pb.TagNumber(3)
  void clearWatchLater() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get dislikeReportData => $_getSZ(3);
  @$pb.TagNumber(4)
  set dislikeReportData($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDislikeReportData() => $_has(3);
  @$pb.TagNumber(4)
  void clearDislikeReportData() => $_clearField(4);
}

class RelatedAICard extends $pb.GeneratedMessage {
  factory RelatedAICard({
    $fixnum.Int64? aid,
    $fixnum.Int64? duration,
    Staff? upInfo,
    Stat? stat,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
    $core.String? gotoType,
  }) {
    final result = RelatedAICard._();
    if (aid != null) result.aid = aid;
    if (duration != null) result.duration = duration;
    if (upInfo != null) result.upInfo = upInfo;
    if (stat != null) result.stat = stat;
    if (report != null) result.report.addEntries(report);
    if (gotoType != null) result.gotoType = gotoType;
    return result;
  }

  RelatedAICard._();

  factory RelatedAICard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelatedAICard()..mergeFromBuffer(data, registry);
  factory RelatedAICard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RelatedAICard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RelatedAICard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: RelatedAICard.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'aid')
    ..aInt64(2, _omitFieldNames ? '' : 'duration')
    ..aOM<Staff>(3, _omitFieldNames ? '' : 'upInfo',
        subBuilder: Staff.$_createMessage)
    ..aOM<Stat>(4, _omitFieldNames ? '' : 'stat',
        subBuilder: Stat.$_createMessage)
    ..m<$core.String, $core.String>(5, _omitFieldNames ? '' : 'report',
        entryClassName: 'RelatedAICard.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..aOS(6, _omitFieldNames ? '' : 'gotoType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelatedAICard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RelatedAICard copyWith(void Function(RelatedAICard) updates) =>
      super.copyWith((message) => updates(message as RelatedAICard))
          as RelatedAICard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RelatedAICard() / RelatedAICard.new instead')
  static RelatedAICard create() => RelatedAICard._();
  static $pb.GeneratedMessage $_createMessage() => RelatedAICard._();
  @$core.override
  RelatedAICard createEmptyInstance() => RelatedAICard._();
  @$core.pragma('dart2js:noInline')
  static RelatedAICard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RelatedAICard>(
          RelatedAICard.$_createMessage);
  static RelatedAICard? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get aid => $_getI64(0);
  @$pb.TagNumber(1)
  set aid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get duration => $_getI64(1);
  @$pb.TagNumber(2)
  set duration($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDuration() => $_has(1);
  @$pb.TagNumber(2)
  void clearDuration() => $_clearField(2);

  @$pb.TagNumber(3)
  Staff get upInfo => $_getN(2);
  @$pb.TagNumber(3)
  set upInfo(Staff value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUpInfo() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpInfo() => $_clearField(3);
  @$pb.TagNumber(3)
  Staff ensureUpInfo() => $_ensure(2);

  @$pb.TagNumber(4)
  Stat get stat => $_getN(3);
  @$pb.TagNumber(4)
  set stat(Stat value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStat() => $_has(3);
  @$pb.TagNumber(4)
  void clearStat() => $_clearField(4);
  @$pb.TagNumber(4)
  Stat ensureStat() => $_ensure(3);

  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(4);

  @$pb.TagNumber(6)
  $core.String get gotoType => $_getSZ(5);
  @$pb.TagNumber(6)
  set gotoType($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasGotoType() => $_has(5);
  @$pb.TagNumber(6)
  void clearGotoType() => $_clearField(6);
}

class Relates extends $pb.GeneratedMessage {
  factory Relates({
    $core.Iterable<RelateCard>? cards,
    RelateConfig? config,
    $core.Iterable<RelateTab>? tab,
  }) {
    final result = Relates._();
    if (cards != null) result.cards.addAll(cards);
    if (config != null) result.config = config;
    if (tab != null) result.tab.addAll(tab);
    return result;
  }

  Relates._();

  factory Relates.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Relates()..mergeFromBuffer(data, registry);
  factory Relates.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Relates()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Relates',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Relates.$_createMessage)
    ..pPM<RelateCard>(1, _omitFieldNames ? '' : 'cards',
        subBuilder: RelateCard.$_createMessage)
    ..aOM<RelateConfig>(2, _omitFieldNames ? '' : 'config',
        subBuilder: RelateConfig.$_createMessage)
    ..pPM<RelateTab>(3, _omitFieldNames ? '' : 'tab',
        subBuilder: RelateTab.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Relates clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Relates copyWith(void Function(Relates) updates) =>
      super.copyWith((message) => updates(message as Relates)) as Relates;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Relates() / Relates.new instead')
  static Relates create() => Relates._();
  static $pb.GeneratedMessage $_createMessage() => Relates._();
  @$core.override
  Relates createEmptyInstance() => Relates._();
  @$core.pragma('dart2js:noInline')
  static Relates getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Relates>(Relates.$_createMessage);
  static Relates? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RelateCard> get cards => $_getList(0);

  @$pb.TagNumber(2)
  RelateConfig get config => $_getN(1);
  @$pb.TagNumber(2)
  set config(RelateConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasConfig() => $_has(1);
  @$pb.TagNumber(2)
  void clearConfig() => $_clearField(2);
  @$pb.TagNumber(2)
  RelateConfig ensureConfig() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<RelateTab> get tab => $_getList(2);
}

enum ReserveButton_OrderParam { reserve, fav, notSet }

class ReserveButton extends $pb.GeneratedMessage {
  factory ReserveButton({
    $core.bool? status,
    $core.String? text,
    $core.String? selectedText,
    ReserveBizType? orderType,
    BizReserveActivityParam? reserve,
    BizFavParam? fav,
  }) {
    final result = ReserveButton._();
    if (status != null) result.status = status;
    if (text != null) result.text = text;
    if (selectedText != null) result.selectedText = selectedText;
    if (orderType != null) result.orderType = orderType;
    if (reserve != null) result.reserve = reserve;
    if (fav != null) result.fav = fav;
    return result;
  }

  ReserveButton._();

  factory ReserveButton.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReserveButton()..mergeFromBuffer(data, registry);
  factory ReserveButton.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReserveButton()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ReserveButton_OrderParam>
      _ReserveButton_OrderParamByTag = {
    8: ReserveButton_OrderParam.reserve,
    9: ReserveButton_OrderParam.fav,
    0: ReserveButton_OrderParam.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReserveButton',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ReserveButton.$_createMessage)
    ..oo(0, [8, 9])
    ..aOB(1, _omitFieldNames ? '' : 'status')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..aOS(4, _omitFieldNames ? '' : 'selectedText')
    ..aE<ReserveBizType>(7, _omitFieldNames ? '' : 'orderType',
        enumValues: ReserveBizType.values)
    ..aOM<BizReserveActivityParam>(8, _omitFieldNames ? '' : 'reserve',
        subBuilder: BizReserveActivityParam.$_createMessage)
    ..aOM<BizFavParam>(9, _omitFieldNames ? '' : 'fav',
        subBuilder: BizFavParam.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReserveButton clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReserveButton copyWith(void Function(ReserveButton) updates) =>
      super.copyWith((message) => updates(message as ReserveButton))
          as ReserveButton;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReserveButton() / ReserveButton.new instead')
  static ReserveButton create() => ReserveButton._();
  static $pb.GeneratedMessage $_createMessage() => ReserveButton._();
  @$core.override
  ReserveButton createEmptyInstance() => ReserveButton._();
  @$core.pragma('dart2js:noInline')
  static ReserveButton getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReserveButton>(
          ReserveButton.$_createMessage);
  static ReserveButton? _defaultInstance;

  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  ReserveButton_OrderParam whichOrderParam() =>
      _ReserveButton_OrderParamByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  void clearOrderParam() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.bool get status => $_getBF(0);
  @$pb.TagNumber(1)
  set status($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get selectedText => $_getSZ(2);
  @$pb.TagNumber(4)
  set selectedText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(4)
  $core.bool hasSelectedText() => $_has(2);
  @$pb.TagNumber(4)
  void clearSelectedText() => $_clearField(4);

  @$pb.TagNumber(7)
  ReserveBizType get orderType => $_getN(3);
  @$pb.TagNumber(7)
  set orderType(ReserveBizType value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasOrderType() => $_has(3);
  @$pb.TagNumber(7)
  void clearOrderType() => $_clearField(7);

  @$pb.TagNumber(8)
  BizReserveActivityParam get reserve => $_getN(4);
  @$pb.TagNumber(8)
  set reserve(BizReserveActivityParam value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasReserve() => $_has(4);
  @$pb.TagNumber(8)
  void clearReserve() => $_clearField(8);
  @$pb.TagNumber(8)
  BizReserveActivityParam ensureReserve() => $_ensure(4);

  @$pb.TagNumber(9)
  BizFavParam get fav => $_getN(5);
  @$pb.TagNumber(9)
  set fav(BizFavParam value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasFav() => $_has(5);
  @$pb.TagNumber(9)
  void clearFav() => $_clearField(9);
  @$pb.TagNumber(9)
  BizFavParam ensureFav() => $_ensure(5);
}

class ReserveCalendarInfo extends $pb.GeneratedMessage {
  factory ReserveCalendarInfo({
    $core.String? title,
    $fixnum.Int64? startTs,
    $fixnum.Int64? endTs,
    $core.String? description,
    $core.String? businessId,
  }) {
    final result = ReserveCalendarInfo._();
    if (title != null) result.title = title;
    if (startTs != null) result.startTs = startTs;
    if (endTs != null) result.endTs = endTs;
    if (description != null) result.description = description;
    if (businessId != null) result.businessId = businessId;
    return result;
  }

  ReserveCalendarInfo._();

  factory ReserveCalendarInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReserveCalendarInfo()..mergeFromBuffer(data, registry);
  factory ReserveCalendarInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReserveCalendarInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReserveCalendarInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ReserveCalendarInfo.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aInt64(2, _omitFieldNames ? '' : 'startTs')
    ..aInt64(3, _omitFieldNames ? '' : 'endTs')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'businessId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReserveCalendarInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReserveCalendarInfo copyWith(void Function(ReserveCalendarInfo) updates) =>
      super.copyWith((message) => updates(message as ReserveCalendarInfo))
          as ReserveCalendarInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ReserveCalendarInfo() / ReserveCalendarInfo.new instead')
  static ReserveCalendarInfo create() => ReserveCalendarInfo._();
  static $pb.GeneratedMessage $_createMessage() => ReserveCalendarInfo._();
  @$core.override
  ReserveCalendarInfo createEmptyInstance() => ReserveCalendarInfo._();
  @$core.pragma('dart2js:noInline')
  static ReserveCalendarInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReserveCalendarInfo>(
          ReserveCalendarInfo.$_createMessage);
  static ReserveCalendarInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get startTs => $_getI64(1);
  @$pb.TagNumber(2)
  set startTs($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStartTs() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartTs() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get endTs => $_getI64(2);
  @$pb.TagNumber(3)
  set endTs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEndTs() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndTs() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get businessId => $_getSZ(4);
  @$pb.TagNumber(5)
  set businessId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBusinessId() => $_has(4);
  @$pb.TagNumber(5)
  void clearBusinessId() => $_clearField(5);
}

class Rights extends $pb.GeneratedMessage {
  factory Rights({
    $core.int? allowDownload,
    $core.int? allowReview,
    $core.int? canWatch,
    $core.String? resource,
    $core.int? allowDm,
    $core.int? allowDemand,
    $core.int? areaLimit,
  }) {
    final result = Rights._();
    if (allowDownload != null) result.allowDownload = allowDownload;
    if (allowReview != null) result.allowReview = allowReview;
    if (canWatch != null) result.canWatch = canWatch;
    if (resource != null) result.resource = resource;
    if (allowDm != null) result.allowDm = allowDm;
    if (allowDemand != null) result.allowDemand = allowDemand;
    if (areaLimit != null) result.areaLimit = areaLimit;
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
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Rights.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'allowDownload')
    ..aI(2, _omitFieldNames ? '' : 'allowReview')
    ..aI(3, _omitFieldNames ? '' : 'canWatch')
    ..aOS(4, _omitFieldNames ? '' : 'resource')
    ..aI(5, _omitFieldNames ? '' : 'allowDm')
    ..aI(6, _omitFieldNames ? '' : 'allowDemand')
    ..aI(7, _omitFieldNames ? '' : 'areaLimit')
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
  $core.String get resource => $_getSZ(3);
  @$pb.TagNumber(4)
  set resource($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasResource() => $_has(3);
  @$pb.TagNumber(4)
  void clearResource() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get allowDm => $_getIZ(4);
  @$pb.TagNumber(5)
  set allowDm($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAllowDm() => $_has(4);
  @$pb.TagNumber(5)
  void clearAllowDm() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get allowDemand => $_getIZ(5);
  @$pb.TagNumber(6)
  set allowDemand($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAllowDemand() => $_has(5);
  @$pb.TagNumber(6)
  void clearAllowDemand() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get areaLimit => $_getIZ(6);
  @$pb.TagNumber(7)
  set areaLimit($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAreaLimit() => $_has(6);
  @$pb.TagNumber(7)
  void clearAreaLimit() => $_clearField(7);
}

class SeasonHead extends $pb.GeneratedMessage {
  factory SeasonHead({
    $core.String? title,
    $core.String? intro,
    StatInfo? vt,
    StatInfo? danmaku,
  }) {
    final result = SeasonHead._();
    if (title != null) result.title = title;
    if (intro != null) result.intro = intro;
    if (vt != null) result.vt = vt;
    if (danmaku != null) result.danmaku = danmaku;
    return result;
  }

  SeasonHead._();

  factory SeasonHead.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeasonHead()..mergeFromBuffer(data, registry);
  factory SeasonHead.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeasonHead()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeasonHead',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: SeasonHead.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'intro')
    ..aOM<StatInfo>(3, _omitFieldNames ? '' : 'vt',
        subBuilder: StatInfo.$_createMessage)
    ..aOM<StatInfo>(4, _omitFieldNames ? '' : 'danmaku',
        subBuilder: StatInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeasonHead clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeasonHead copyWith(void Function(SeasonHead) updates) =>
      super.copyWith((message) => updates(message as SeasonHead)) as SeasonHead;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SeasonHead() / SeasonHead.new instead')
  static SeasonHead create() => SeasonHead._();
  static $pb.GeneratedMessage $_createMessage() => SeasonHead._();
  @$core.override
  SeasonHead createEmptyInstance() => SeasonHead._();
  @$core.pragma('dart2js:noInline')
  static SeasonHead getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeasonHead>(SeasonHead.$_createMessage);
  static SeasonHead? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get intro => $_getSZ(1);
  @$pb.TagNumber(2)
  set intro($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIntro() => $_has(1);
  @$pb.TagNumber(2)
  void clearIntro() => $_clearField(2);

  @$pb.TagNumber(3)
  StatInfo get vt => $_getN(2);
  @$pb.TagNumber(3)
  set vt(StatInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasVt() => $_has(2);
  @$pb.TagNumber(3)
  void clearVt() => $_clearField(3);
  @$pb.TagNumber(3)
  StatInfo ensureVt() => $_ensure(2);

  @$pb.TagNumber(4)
  StatInfo get danmaku => $_getN(3);
  @$pb.TagNumber(4)
  set danmaku(StatInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDanmaku() => $_has(3);
  @$pb.TagNumber(4)
  void clearDanmaku() => $_clearField(4);
  @$pb.TagNumber(4)
  StatInfo ensureDanmaku() => $_ensure(3);
}

class SeasonShow extends $pb.GeneratedMessage {
  factory SeasonShow({
    $core.String? buttonText,
    $core.String? joinText,
    $core.String? ruleText,
    $core.String? checkinText,
    $core.String? checkinPrompt,
  }) {
    final result = SeasonShow._();
    if (buttonText != null) result.buttonText = buttonText;
    if (joinText != null) result.joinText = joinText;
    if (ruleText != null) result.ruleText = ruleText;
    if (checkinText != null) result.checkinText = checkinText;
    if (checkinPrompt != null) result.checkinPrompt = checkinPrompt;
    return result;
  }

  SeasonShow._();

  factory SeasonShow.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeasonShow()..mergeFromBuffer(data, registry);
  factory SeasonShow.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SeasonShow()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeasonShow',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: SeasonShow.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'buttonText')
    ..aOS(2, _omitFieldNames ? '' : 'joinText')
    ..aOS(3, _omitFieldNames ? '' : 'ruleText')
    ..aOS(4, _omitFieldNames ? '' : 'checkinText')
    ..aOS(5, _omitFieldNames ? '' : 'checkinPrompt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeasonShow clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeasonShow copyWith(void Function(SeasonShow) updates) =>
      super.copyWith((message) => updates(message as SeasonShow)) as SeasonShow;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SeasonShow() / SeasonShow.new instead')
  static SeasonShow create() => SeasonShow._();
  static $pb.GeneratedMessage $_createMessage() => SeasonShow._();
  @$core.override
  SeasonShow createEmptyInstance() => SeasonShow._();
  @$core.pragma('dart2js:noInline')
  static SeasonShow getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeasonShow>(SeasonShow.$_createMessage);
  static SeasonShow? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get buttonText => $_getSZ(0);
  @$pb.TagNumber(1)
  set buttonText($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasButtonText() => $_has(0);
  @$pb.TagNumber(1)
  void clearButtonText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get joinText => $_getSZ(1);
  @$pb.TagNumber(2)
  set joinText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasJoinText() => $_has(1);
  @$pb.TagNumber(2)
  void clearJoinText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get ruleText => $_getSZ(2);
  @$pb.TagNumber(3)
  set ruleText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRuleText() => $_has(2);
  @$pb.TagNumber(3)
  void clearRuleText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get checkinText => $_getSZ(3);
  @$pb.TagNumber(4)
  set checkinText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCheckinText() => $_has(3);
  @$pb.TagNumber(4)
  void clearCheckinText() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get checkinPrompt => $_getSZ(4);
  @$pb.TagNumber(5)
  set checkinPrompt($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCheckinPrompt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCheckinPrompt() => $_clearField(5);
}

class SectionData extends $pb.GeneratedMessage {
  factory SectionData({
    $core.int? id,
    $core.int? sectionId,
    $core.String? title,
    $core.int? canOrdDesc,
    $core.String? more,
    $core.Iterable<$core.int>? episodeIds,
    $core.Iterable<ViewEpisode>? episodes,
    $core.String? splitText,
    Style? moduleStyle,
    $core.String? moreBottomDesc,
    $core.Iterable<SerialSeason>? seasons,
    Button? moreLeft,
    $core.int? type,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
    EpBgInfo? bgInfo,
  }) {
    final result = SectionData._();
    if (id != null) result.id = id;
    if (sectionId != null) result.sectionId = sectionId;
    if (title != null) result.title = title;
    if (canOrdDesc != null) result.canOrdDesc = canOrdDesc;
    if (more != null) result.more = more;
    if (episodeIds != null) result.episodeIds.addAll(episodeIds);
    if (episodes != null) result.episodes.addAll(episodes);
    if (splitText != null) result.splitText = splitText;
    if (moduleStyle != null) result.moduleStyle = moduleStyle;
    if (moreBottomDesc != null) result.moreBottomDesc = moreBottomDesc;
    if (seasons != null) result.seasons.addAll(seasons);
    if (moreLeft != null) result.moreLeft = moreLeft;
    if (type != null) result.type = type;
    if (report != null) result.report.addEntries(report);
    if (bgInfo != null) result.bgInfo = bgInfo;
    return result;
  }

  SectionData._();

  factory SectionData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SectionData()..mergeFromBuffer(data, registry);
  factory SectionData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SectionData()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SectionData',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: SectionData.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aI(2, _omitFieldNames ? '' : 'sectionId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aI(4, _omitFieldNames ? '' : 'canOrdDesc')
    ..aOS(5, _omitFieldNames ? '' : 'more')
    ..p<$core.int>(6, _omitFieldNames ? '' : 'episodeIds', $pb.PbFieldType.K3)
    ..pPM<ViewEpisode>(7, _omitFieldNames ? '' : 'episodes',
        subBuilder: ViewEpisode.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'splitText')
    ..aOM<Style>(9, _omitFieldNames ? '' : 'moduleStyle',
        subBuilder: Style.$_createMessage)
    ..aOS(10, _omitFieldNames ? '' : 'moreBottomDesc')
    ..pPM<SerialSeason>(11, _omitFieldNames ? '' : 'seasons',
        subBuilder: SerialSeason.$_createMessage)
    ..aOM<Button>(12, _omitFieldNames ? '' : 'moreLeft',
        subBuilder: Button.$_createMessage)
    ..aI(13, _omitFieldNames ? '' : 'type')
    ..m<$core.String, $core.String>(14, _omitFieldNames ? '' : 'report',
        entryClassName: 'SectionData.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..aOM<EpBgInfo>(15, _omitFieldNames ? '' : 'bgInfo',
        subBuilder: EpBgInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SectionData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SectionData copyWith(void Function(SectionData) updates) =>
      super.copyWith((message) => updates(message as SectionData))
          as SectionData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SectionData() / SectionData.new instead')
  static SectionData create() => SectionData._();
  static $pb.GeneratedMessage $_createMessage() => SectionData._();
  @$core.override
  SectionData createEmptyInstance() => SectionData._();
  @$core.pragma('dart2js:noInline')
  static SectionData getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SectionData>(
          SectionData.$_createMessage);
  static SectionData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get sectionId => $_getIZ(1);
  @$pb.TagNumber(2)
  set sectionId($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSectionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSectionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get canOrdDesc => $_getIZ(3);
  @$pb.TagNumber(4)
  set canOrdDesc($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCanOrdDesc() => $_has(3);
  @$pb.TagNumber(4)
  void clearCanOrdDesc() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get more => $_getSZ(4);
  @$pb.TagNumber(5)
  set more($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMore() => $_has(4);
  @$pb.TagNumber(5)
  void clearMore() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.int> get episodeIds => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<ViewEpisode> get episodes => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get splitText => $_getSZ(7);
  @$pb.TagNumber(8)
  set splitText($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSplitText() => $_has(7);
  @$pb.TagNumber(8)
  void clearSplitText() => $_clearField(8);

  @$pb.TagNumber(9)
  Style get moduleStyle => $_getN(8);
  @$pb.TagNumber(9)
  set moduleStyle(Style value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasModuleStyle() => $_has(8);
  @$pb.TagNumber(9)
  void clearModuleStyle() => $_clearField(9);
  @$pb.TagNumber(9)
  Style ensureModuleStyle() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get moreBottomDesc => $_getSZ(9);
  @$pb.TagNumber(10)
  set moreBottomDesc($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMoreBottomDesc() => $_has(9);
  @$pb.TagNumber(10)
  void clearMoreBottomDesc() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<SerialSeason> get seasons => $_getList(10);

  @$pb.TagNumber(12)
  Button get moreLeft => $_getN(11);
  @$pb.TagNumber(12)
  set moreLeft(Button value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasMoreLeft() => $_has(11);
  @$pb.TagNumber(12)
  void clearMoreLeft() => $_clearField(12);
  @$pb.TagNumber(12)
  Button ensureMoreLeft() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.int get type => $_getIZ(12);
  @$pb.TagNumber(13)
  set type($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasType() => $_has(12);
  @$pb.TagNumber(13)
  void clearType() => $_clearField(13);

  @$pb.TagNumber(14)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(13);

  @$pb.TagNumber(15)
  EpBgInfo get bgInfo => $_getN(14);
  @$pb.TagNumber(15)
  set bgInfo(EpBgInfo value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasBgInfo() => $_has(14);
  @$pb.TagNumber(15)
  void clearBgInfo() => $_clearField(15);
  @$pb.TagNumber(15)
  EpBgInfo ensureBgInfo() => $_ensure(14);
}

class SerialSeason extends $pb.GeneratedMessage {
  factory SerialSeason({
    $core.int? seasonId,
    $core.String? title,
    $core.String? seasonTitle,
    $core.int? isNew,
    $core.String? cover,
    $core.String? badge,
    $core.int? badgeType,
    BadgeInfo? badgeInfo,
    $core.String? link,
    $core.String? resource,
    NewEp? newEp,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
  }) {
    final result = SerialSeason._();
    if (seasonId != null) result.seasonId = seasonId;
    if (title != null) result.title = title;
    if (seasonTitle != null) result.seasonTitle = seasonTitle;
    if (isNew != null) result.isNew = isNew;
    if (cover != null) result.cover = cover;
    if (badge != null) result.badge = badge;
    if (badgeType != null) result.badgeType = badgeType;
    if (badgeInfo != null) result.badgeInfo = badgeInfo;
    if (link != null) result.link = link;
    if (resource != null) result.resource = resource;
    if (newEp != null) result.newEp = newEp;
    if (report != null) result.report.addEntries(report);
    return result;
  }

  SerialSeason._();

  factory SerialSeason.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SerialSeason()..mergeFromBuffer(data, registry);
  factory SerialSeason.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SerialSeason()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SerialSeason',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: SerialSeason.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'seasonId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'seasonTitle')
    ..aI(4, _omitFieldNames ? '' : 'isNew')
    ..aOS(5, _omitFieldNames ? '' : 'cover')
    ..aOS(6, _omitFieldNames ? '' : 'badge')
    ..aI(7, _omitFieldNames ? '' : 'badgeType')
    ..aOM<BadgeInfo>(8, _omitFieldNames ? '' : 'badgeInfo',
        subBuilder: BadgeInfo.$_createMessage)
    ..aOS(9, _omitFieldNames ? '' : 'link')
    ..aOS(10, _omitFieldNames ? '' : 'resource')
    ..aOM<NewEp>(11, _omitFieldNames ? '' : 'newEp',
        subBuilder: NewEp.$_createMessage)
    ..m<$core.String, $core.String>(12, _omitFieldNames ? '' : 'report',
        entryClassName: 'SerialSeason.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SerialSeason clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SerialSeason copyWith(void Function(SerialSeason) updates) =>
      super.copyWith((message) => updates(message as SerialSeason))
          as SerialSeason;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SerialSeason() / SerialSeason.new instead')
  static SerialSeason create() => SerialSeason._();
  static $pb.GeneratedMessage $_createMessage() => SerialSeason._();
  @$core.override
  SerialSeason createEmptyInstance() => SerialSeason._();
  @$core.pragma('dart2js:noInline')
  static SerialSeason getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SerialSeason>(
          SerialSeason.$_createMessage);
  static SerialSeason? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seasonId => $_getIZ(0);
  @$pb.TagNumber(1)
  set seasonId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeasonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeasonId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get seasonTitle => $_getSZ(2);
  @$pb.TagNumber(3)
  set seasonTitle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSeasonTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearSeasonTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get isNew => $_getIZ(3);
  @$pb.TagNumber(4)
  set isNew($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsNew() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsNew() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get cover => $_getSZ(4);
  @$pb.TagNumber(5)
  set cover($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCover() => $_has(4);
  @$pb.TagNumber(5)
  void clearCover() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get badge => $_getSZ(5);
  @$pb.TagNumber(6)
  set badge($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBadge() => $_has(5);
  @$pb.TagNumber(6)
  void clearBadge() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get badgeType => $_getIZ(6);
  @$pb.TagNumber(7)
  set badgeType($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBadgeType() => $_has(6);
  @$pb.TagNumber(7)
  void clearBadgeType() => $_clearField(7);

  @$pb.TagNumber(8)
  BadgeInfo get badgeInfo => $_getN(7);
  @$pb.TagNumber(8)
  set badgeInfo(BadgeInfo value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasBadgeInfo() => $_has(7);
  @$pb.TagNumber(8)
  void clearBadgeInfo() => $_clearField(8);
  @$pb.TagNumber(8)
  BadgeInfo ensureBadgeInfo() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get link => $_getSZ(8);
  @$pb.TagNumber(9)
  set link($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLink() => $_has(8);
  @$pb.TagNumber(9)
  void clearLink() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get resource => $_getSZ(9);
  @$pb.TagNumber(10)
  set resource($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasResource() => $_has(9);
  @$pb.TagNumber(10)
  void clearResource() => $_clearField(10);

  @$pb.TagNumber(11)
  NewEp get newEp => $_getN(10);
  @$pb.TagNumber(11)
  set newEp(NewEp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasNewEp() => $_has(10);
  @$pb.TagNumber(11)
  void clearNewEp() => $_clearField(11);
  @$pb.TagNumber(11)
  NewEp ensureNewEp() => $_ensure(10);

  @$pb.TagNumber(12)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(11);
}

class SkipRange extends $pb.GeneratedMessage {
  factory SkipRange({
    $core.int? start,
    $core.int? end,
  }) {
    final result = SkipRange._();
    if (start != null) result.start = start;
    if (end != null) result.end = end;
    return result;
  }

  SkipRange._();

  factory SkipRange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SkipRange()..mergeFromBuffer(data, registry);
  factory SkipRange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SkipRange()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SkipRange',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: SkipRange.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'start')
    ..aI(2, _omitFieldNames ? '' : 'end')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SkipRange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SkipRange copyWith(void Function(SkipRange) updates) =>
      super.copyWith((message) => updates(message as SkipRange)) as SkipRange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SkipRange() / SkipRange.new instead')
  static SkipRange create() => SkipRange._();
  static $pb.GeneratedMessage $_createMessage() => SkipRange._();
  @$core.override
  SkipRange createEmptyInstance() => SkipRange._();
  @$core.pragma('dart2js:noInline')
  static SkipRange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SkipRange>(SkipRange.$_createMessage);
  static SkipRange? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get start => $_getIZ(0);
  @$pb.TagNumber(1)
  set start($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get end => $_getIZ(1);
  @$pb.TagNumber(2)
  set end($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnd() => $_clearField(2);
}

class SpecialCell extends $pb.GeneratedMessage {
  factory SpecialCell({
    $core.String? icon,
    $core.String? iconNight,
    $core.String? text,
    $core.String? textColor,
    $core.String? textColorNight,
    $core.String? jumpUrl,
    $core.String? cellType,
    $core.String? cellBgcolor,
    $core.String? cellBgcolorNight,
    $core.String? param,
    $core.String? pageTitle,
    $core.String? jumpType,
    $core.String? endIcon,
    $core.String? endIconNight,
    CellFluid? cellFluid,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
  }) {
    final result = SpecialCell._();
    if (icon != null) result.icon = icon;
    if (iconNight != null) result.iconNight = iconNight;
    if (text != null) result.text = text;
    if (textColor != null) result.textColor = textColor;
    if (textColorNight != null) result.textColorNight = textColorNight;
    if (jumpUrl != null) result.jumpUrl = jumpUrl;
    if (cellType != null) result.cellType = cellType;
    if (cellBgcolor != null) result.cellBgcolor = cellBgcolor;
    if (cellBgcolorNight != null) result.cellBgcolorNight = cellBgcolorNight;
    if (param != null) result.param = param;
    if (pageTitle != null) result.pageTitle = pageTitle;
    if (jumpType != null) result.jumpType = jumpType;
    if (endIcon != null) result.endIcon = endIcon;
    if (endIconNight != null) result.endIconNight = endIconNight;
    if (cellFluid != null) result.cellFluid = cellFluid;
    if (report != null) result.report.addEntries(report);
    return result;
  }

  SpecialCell._();

  factory SpecialCell.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SpecialCell()..mergeFromBuffer(data, registry);
  factory SpecialCell.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SpecialCell()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SpecialCell',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: SpecialCell.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'icon')
    ..aOS(2, _omitFieldNames ? '' : 'iconNight')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..aOS(4, _omitFieldNames ? '' : 'textColor')
    ..aOS(5, _omitFieldNames ? '' : 'textColorNight')
    ..aOS(6, _omitFieldNames ? '' : 'jumpUrl')
    ..aOS(7, _omitFieldNames ? '' : 'cellType')
    ..aOS(8, _omitFieldNames ? '' : 'cellBgcolor')
    ..aOS(9, _omitFieldNames ? '' : 'cellBgcolorNight')
    ..aOS(10, _omitFieldNames ? '' : 'param')
    ..aOS(11, _omitFieldNames ? '' : 'pageTitle')
    ..aOS(12, _omitFieldNames ? '' : 'jumpType')
    ..aOS(13, _omitFieldNames ? '' : 'endIcon')
    ..aOS(14, _omitFieldNames ? '' : 'endIconNight')
    ..aOM<CellFluid>(15, _omitFieldNames ? '' : 'cellFluid',
        subBuilder: CellFluid.$_createMessage)
    ..m<$core.String, $core.String>(16, _omitFieldNames ? '' : 'report',
        entryClassName: 'SpecialCell.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpecialCell clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpecialCell copyWith(void Function(SpecialCell) updates) =>
      super.copyWith((message) => updates(message as SpecialCell))
          as SpecialCell;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SpecialCell() / SpecialCell.new instead')
  static SpecialCell create() => SpecialCell._();
  static $pb.GeneratedMessage $_createMessage() => SpecialCell._();
  @$core.override
  SpecialCell createEmptyInstance() => SpecialCell._();
  @$core.pragma('dart2js:noInline')
  static SpecialCell getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SpecialCell>(
          SpecialCell.$_createMessage);
  static SpecialCell? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get icon => $_getSZ(0);
  @$pb.TagNumber(1)
  set icon($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIcon() => $_has(0);
  @$pb.TagNumber(1)
  void clearIcon() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get iconNight => $_getSZ(1);
  @$pb.TagNumber(2)
  set iconNight($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIconNight() => $_has(1);
  @$pb.TagNumber(2)
  void clearIconNight() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get textColor => $_getSZ(3);
  @$pb.TagNumber(4)
  set textColor($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTextColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearTextColor() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get textColorNight => $_getSZ(4);
  @$pb.TagNumber(5)
  set textColorNight($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTextColorNight() => $_has(4);
  @$pb.TagNumber(5)
  void clearTextColorNight() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get jumpUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set jumpUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasJumpUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearJumpUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get cellType => $_getSZ(6);
  @$pb.TagNumber(7)
  set cellType($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCellType() => $_has(6);
  @$pb.TagNumber(7)
  void clearCellType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get cellBgcolor => $_getSZ(7);
  @$pb.TagNumber(8)
  set cellBgcolor($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCellBgcolor() => $_has(7);
  @$pb.TagNumber(8)
  void clearCellBgcolor() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get cellBgcolorNight => $_getSZ(8);
  @$pb.TagNumber(9)
  set cellBgcolorNight($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCellBgcolorNight() => $_has(8);
  @$pb.TagNumber(9)
  void clearCellBgcolorNight() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get param => $_getSZ(9);
  @$pb.TagNumber(10)
  set param($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasParam() => $_has(9);
  @$pb.TagNumber(10)
  void clearParam() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get pageTitle => $_getSZ(10);
  @$pb.TagNumber(11)
  set pageTitle($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasPageTitle() => $_has(10);
  @$pb.TagNumber(11)
  void clearPageTitle() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get jumpType => $_getSZ(11);
  @$pb.TagNumber(12)
  set jumpType($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasJumpType() => $_has(11);
  @$pb.TagNumber(12)
  void clearJumpType() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get endIcon => $_getSZ(12);
  @$pb.TagNumber(13)
  set endIcon($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasEndIcon() => $_has(12);
  @$pb.TagNumber(13)
  void clearEndIcon() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get endIconNight => $_getSZ(13);
  @$pb.TagNumber(14)
  set endIconNight($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasEndIconNight() => $_has(13);
  @$pb.TagNumber(14)
  void clearEndIconNight() => $_clearField(14);

  @$pb.TagNumber(15)
  CellFluid get cellFluid => $_getN(14);
  @$pb.TagNumber(15)
  set cellFluid(CellFluid value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasCellFluid() => $_has(14);
  @$pb.TagNumber(15)
  void clearCellFluid() => $_clearField(15);
  @$pb.TagNumber(15)
  CellFluid ensureCellFluid() => $_ensure(14);

  @$pb.TagNumber(16)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(15);
}

class SpecialTag extends $pb.GeneratedMessage {
  factory SpecialTag({
    $core.Iterable<SpecialCell>? specialCell,
    $core.bool? refresh,
  }) {
    final result = SpecialTag._();
    if (specialCell != null) result.specialCell.addAll(specialCell);
    if (refresh != null) result.refresh = refresh;
    return result;
  }

  SpecialTag._();

  factory SpecialTag.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SpecialTag()..mergeFromBuffer(data, registry);
  factory SpecialTag.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SpecialTag()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SpecialTag',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: SpecialTag.$_createMessage)
    ..pPM<SpecialCell>(1, _omitFieldNames ? '' : 'specialCell',
        subBuilder: SpecialCell.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'refresh')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpecialTag clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpecialTag copyWith(void Function(SpecialTag) updates) =>
      super.copyWith((message) => updates(message as SpecialTag)) as SpecialTag;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SpecialTag() / SpecialTag.new instead')
  static SpecialTag create() => SpecialTag._();
  static $pb.GeneratedMessage $_createMessage() => SpecialTag._();
  @$core.override
  SpecialTag createEmptyInstance() => SpecialTag._();
  @$core.pragma('dart2js:noInline')
  static SpecialTag getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SpecialTag>(SpecialTag.$_createMessage);
  static SpecialTag? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SpecialCell> get specialCell => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get refresh => $_getBF(1);
  @$pb.TagNumber(2)
  set refresh($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRefresh() => $_has(1);
  @$pb.TagNumber(2)
  void clearRefresh() => $_clearField(2);
}

class Sponsor extends $pb.GeneratedMessage {
  factory Sponsor({
    $fixnum.Int64? total,
    $fixnum.Int64? week,
    $core.Iterable<SponsorRank>? rankList,
    Mine? mine,
    PointActivity? pointActivity,
    $core.Iterable<Pendant>? pendants,
    $core.Iterable<Threshold>? threshold,
  }) {
    final result = Sponsor._();
    if (total != null) result.total = total;
    if (week != null) result.week = week;
    if (rankList != null) result.rankList.addAll(rankList);
    if (mine != null) result.mine = mine;
    if (pointActivity != null) result.pointActivity = pointActivity;
    if (pendants != null) result.pendants.addAll(pendants);
    if (threshold != null) result.threshold.addAll(threshold);
    return result;
  }

  Sponsor._();

  factory Sponsor.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Sponsor()..mergeFromBuffer(data, registry);
  factory Sponsor.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Sponsor()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Sponsor',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Sponsor.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'total')
    ..aInt64(2, _omitFieldNames ? '' : 'week')
    ..pPM<SponsorRank>(3, _omitFieldNames ? '' : 'rankList',
        subBuilder: SponsorRank.$_createMessage)
    ..aOM<Mine>(4, _omitFieldNames ? '' : 'mine',
        subBuilder: Mine.$_createMessage)
    ..aOM<PointActivity>(5, _omitFieldNames ? '' : 'pointActivity',
        subBuilder: PointActivity.$_createMessage)
    ..pPM<Pendant>(6, _omitFieldNames ? '' : 'pendants',
        subBuilder: Pendant.$_createMessage)
    ..pPM<Threshold>(7, _omitFieldNames ? '' : 'threshold',
        subBuilder: Threshold.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Sponsor clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Sponsor copyWith(void Function(Sponsor) updates) =>
      super.copyWith((message) => updates(message as Sponsor)) as Sponsor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Sponsor() / Sponsor.new instead')
  static Sponsor create() => Sponsor._();
  static $pb.GeneratedMessage $_createMessage() => Sponsor._();
  @$core.override
  Sponsor createEmptyInstance() => Sponsor._();
  @$core.pragma('dart2js:noInline')
  static Sponsor getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Sponsor>(Sponsor.$_createMessage);
  static Sponsor? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get total => $_getI64(0);
  @$pb.TagNumber(1)
  set total($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get week => $_getI64(1);
  @$pb.TagNumber(2)
  set week($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWeek() => $_has(1);
  @$pb.TagNumber(2)
  void clearWeek() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<SponsorRank> get rankList => $_getList(2);

  @$pb.TagNumber(4)
  Mine get mine => $_getN(3);
  @$pb.TagNumber(4)
  set mine(Mine value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMine() => $_has(3);
  @$pb.TagNumber(4)
  void clearMine() => $_clearField(4);
  @$pb.TagNumber(4)
  Mine ensureMine() => $_ensure(3);

  @$pb.TagNumber(5)
  PointActivity get pointActivity => $_getN(4);
  @$pb.TagNumber(5)
  set pointActivity(PointActivity value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPointActivity() => $_has(4);
  @$pb.TagNumber(5)
  void clearPointActivity() => $_clearField(5);
  @$pb.TagNumber(5)
  PointActivity ensurePointActivity() => $_ensure(4);

  @$pb.TagNumber(6)
  $pb.PbList<Pendant> get pendants => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<Threshold> get threshold => $_getList(6);
}

class SponsorRank extends $pb.GeneratedMessage {
  factory SponsorRank({
    $fixnum.Int64? uid,
    $core.String? msg,
    $core.String? uname,
    $core.String? face,
    Vip? vip,
  }) {
    final result = SponsorRank._();
    if (uid != null) result.uid = uid;
    if (msg != null) result.msg = msg;
    if (uname != null) result.uname = uname;
    if (face != null) result.face = face;
    if (vip != null) result.vip = vip;
    return result;
  }

  SponsorRank._();

  factory SponsorRank.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorRank()..mergeFromBuffer(data, registry);
  factory SponsorRank.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorRank()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SponsorRank',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: SponsorRank.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'uid')
    ..aOS(2, _omitFieldNames ? '' : 'msg')
    ..aOS(3, _omitFieldNames ? '' : 'uname')
    ..aOS(4, _omitFieldNames ? '' : 'face')
    ..aOM<Vip>(5, _omitFieldNames ? '' : 'vip', subBuilder: Vip.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorRank clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorRank copyWith(void Function(SponsorRank) updates) =>
      super.copyWith((message) => updates(message as SponsorRank))
          as SponsorRank;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SponsorRank() / SponsorRank.new instead')
  static SponsorRank create() => SponsorRank._();
  static $pb.GeneratedMessage $_createMessage() => SponsorRank._();
  @$core.override
  SponsorRank createEmptyInstance() => SponsorRank._();
  @$core.pragma('dart2js:noInline')
  static SponsorRank getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SponsorRank>(
          SponsorRank.$_createMessage);
  static SponsorRank? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get uid => $_getI64(0);
  @$pb.TagNumber(1)
  set uid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get msg => $_getSZ(1);
  @$pb.TagNumber(2)
  set msg($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearMsg() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get uname => $_getSZ(2);
  @$pb.TagNumber(3)
  set uname($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUname() => $_has(2);
  @$pb.TagNumber(3)
  void clearUname() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get face => $_getSZ(3);
  @$pb.TagNumber(4)
  set face($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFace() => $_has(3);
  @$pb.TagNumber(4)
  void clearFace() => $_clearField(4);

  @$pb.TagNumber(5)
  Vip get vip => $_getN(4);
  @$pb.TagNumber(5)
  set vip(Vip value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasVip() => $_has(4);
  @$pb.TagNumber(5)
  void clearVip() => $_clearField(5);
  @$pb.TagNumber(5)
  Vip ensureVip() => $_ensure(4);
}

class Staff extends $pb.GeneratedMessage {
  factory Staff({
    $fixnum.Int64? mid,
    $core.int? attention,
    $core.String? title,
    $core.String? name,
    $core.String? face,
    OfficialVerify? official,
    Vip? vip,
    $core.int? labelStyle,
    $core.String? fans,
    $2.NameRender? nameRender,
  }) {
    final result = Staff._();
    if (mid != null) result.mid = mid;
    if (attention != null) result.attention = attention;
    if (title != null) result.title = title;
    if (name != null) result.name = name;
    if (face != null) result.face = face;
    if (official != null) result.official = official;
    if (vip != null) result.vip = vip;
    if (labelStyle != null) result.labelStyle = labelStyle;
    if (fans != null) result.fans = fans;
    if (nameRender != null) result.nameRender = nameRender;
    return result;
  }

  Staff._();

  factory Staff.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Staff()..mergeFromBuffer(data, registry);
  factory Staff.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Staff()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Staff',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Staff.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aI(2, _omitFieldNames ? '' : 'attention')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOS(5, _omitFieldNames ? '' : 'face')
    ..aOM<OfficialVerify>(6, _omitFieldNames ? '' : 'official',
        subBuilder: OfficialVerify.$_createMessage)
    ..aOM<Vip>(7, _omitFieldNames ? '' : 'vip', subBuilder: Vip.$_createMessage)
    ..aI(8, _omitFieldNames ? '' : 'labelStyle')
    ..aOS(9, _omitFieldNames ? '' : 'fans')
    ..aOM<$2.NameRender>(10, _omitFieldNames ? '' : 'nameRender',
        subBuilder: $2.NameRender.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Staff clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Staff copyWith(void Function(Staff) updates) =>
      super.copyWith((message) => updates(message as Staff)) as Staff;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Staff() / Staff.new instead')
  static Staff create() => Staff._();
  static $pb.GeneratedMessage $_createMessage() => Staff._();
  @$core.override
  Staff createEmptyInstance() => Staff._();
  @$core.pragma('dart2js:noInline')
  static Staff getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Staff>(Staff.$_createMessage);
  static Staff? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get mid => $_getI64(0);
  @$pb.TagNumber(1)
  set mid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMid() => $_has(0);
  @$pb.TagNumber(1)
  void clearMid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get attention => $_getIZ(1);
  @$pb.TagNumber(2)
  set attention($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAttention() => $_has(1);
  @$pb.TagNumber(2)
  void clearAttention() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get face => $_getSZ(4);
  @$pb.TagNumber(5)
  set face($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFace() => $_has(4);
  @$pb.TagNumber(5)
  void clearFace() => $_clearField(5);

  @$pb.TagNumber(6)
  OfficialVerify get official => $_getN(5);
  @$pb.TagNumber(6)
  set official(OfficialVerify value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasOfficial() => $_has(5);
  @$pb.TagNumber(6)
  void clearOfficial() => $_clearField(6);
  @$pb.TagNumber(6)
  OfficialVerify ensureOfficial() => $_ensure(5);

  @$pb.TagNumber(7)
  Vip get vip => $_getN(6);
  @$pb.TagNumber(7)
  set vip(Vip value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasVip() => $_has(6);
  @$pb.TagNumber(7)
  void clearVip() => $_clearField(7);
  @$pb.TagNumber(7)
  Vip ensureVip() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.int get labelStyle => $_getIZ(7);
  @$pb.TagNumber(8)
  set labelStyle($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLabelStyle() => $_has(7);
  @$pb.TagNumber(8)
  void clearLabelStyle() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get fans => $_getSZ(8);
  @$pb.TagNumber(9)
  set fans($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFans() => $_has(8);
  @$pb.TagNumber(9)
  void clearFans() => $_clearField(9);

  @$pb.TagNumber(10)
  $2.NameRender get nameRender => $_getN(9);
  @$pb.TagNumber(10)
  set nameRender($2.NameRender value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasNameRender() => $_has(9);
  @$pb.TagNumber(10)
  void clearNameRender() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.NameRender ensureNameRender() => $_ensure(9);
}

class Staffs extends $pb.GeneratedMessage {
  factory Staffs({
    $core.Iterable<Staff>? staff,
    $core.String? title,
  }) {
    final result = Staffs._();
    if (staff != null) result.staff.addAll(staff);
    if (title != null) result.title = title;
    return result;
  }

  Staffs._();

  factory Staffs.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Staffs()..mergeFromBuffer(data, registry);
  factory Staffs.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Staffs()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Staffs',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Staffs.$_createMessage)
    ..pPM<Staff>(1, _omitFieldNames ? '' : 'staff',
        subBuilder: Staff.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Staffs clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Staffs copyWith(void Function(Staffs) updates) =>
      super.copyWith((message) => updates(message as Staffs)) as Staffs;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Staffs() / Staffs.new instead')
  static Staffs create() => Staffs._();
  static $pb.GeneratedMessage $_createMessage() => Staffs._();
  @$core.override
  Staffs createEmptyInstance() => Staffs._();
  @$core.pragma('dart2js:noInline')
  static Staffs getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Staffs>(Staffs.$_createMessage);
  static Staffs? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Staff> get staff => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);
}

class StarRail extends $pb.GeneratedMessage {
  factory StarRail({
    $fixnum.Int64? seasonId,
    $fixnum.Int64? aid,
    $fixnum.Int64? cid,
    $fixnum.Int64? openTime,
    $core.int? status,
    $core.String? pic1,
    $core.String? pic2,
    $core.String? pic3,
    $core.String? pic4,
    $core.String? pic5,
  }) {
    final result = StarRail._();
    if (seasonId != null) result.seasonId = seasonId;
    if (aid != null) result.aid = aid;
    if (cid != null) result.cid = cid;
    if (openTime != null) result.openTime = openTime;
    if (status != null) result.status = status;
    if (pic1 != null) result.pic1 = pic1;
    if (pic2 != null) result.pic2 = pic2;
    if (pic3 != null) result.pic3 = pic3;
    if (pic4 != null) result.pic4 = pic4;
    if (pic5 != null) result.pic5 = pic5;
    return result;
  }

  StarRail._();

  factory StarRail.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StarRail()..mergeFromBuffer(data, registry);
  factory StarRail.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StarRail()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StarRail',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: StarRail.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'seasonId')
    ..aInt64(2, _omitFieldNames ? '' : 'aid')
    ..aInt64(3, _omitFieldNames ? '' : 'cid')
    ..aInt64(4, _omitFieldNames ? '' : 'openTime')
    ..aI(5, _omitFieldNames ? '' : 'status')
    ..aOS(6, _omitFieldNames ? '' : 'pic1')
    ..aOS(7, _omitFieldNames ? '' : 'pic2')
    ..aOS(8, _omitFieldNames ? '' : 'pic3')
    ..aOS(9, _omitFieldNames ? '' : 'pic4')
    ..aOS(10, _omitFieldNames ? '' : 'pic5')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StarRail clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StarRail copyWith(void Function(StarRail) updates) =>
      super.copyWith((message) => updates(message as StarRail)) as StarRail;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StarRail() / StarRail.new instead')
  static StarRail create() => StarRail._();
  static $pb.GeneratedMessage $_createMessage() => StarRail._();
  @$core.override
  StarRail createEmptyInstance() => StarRail._();
  @$core.pragma('dart2js:noInline')
  static StarRail getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StarRail>(StarRail.$_createMessage);
  static StarRail? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get seasonId => $_getI64(0);
  @$pb.TagNumber(1)
  set seasonId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeasonId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeasonId() => $_clearField(1);

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
  $fixnum.Int64 get openTime => $_getI64(3);
  @$pb.TagNumber(4)
  set openTime($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOpenTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearOpenTime() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get status => $_getIZ(4);
  @$pb.TagNumber(5)
  set status($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get pic1 => $_getSZ(5);
  @$pb.TagNumber(6)
  set pic1($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPic1() => $_has(5);
  @$pb.TagNumber(6)
  void clearPic1() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get pic2 => $_getSZ(6);
  @$pb.TagNumber(7)
  set pic2($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPic2() => $_has(6);
  @$pb.TagNumber(7)
  void clearPic2() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get pic3 => $_getSZ(7);
  @$pb.TagNumber(8)
  set pic3($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPic3() => $_has(7);
  @$pb.TagNumber(8)
  void clearPic3() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get pic4 => $_getSZ(8);
  @$pb.TagNumber(9)
  set pic4($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPic4() => $_has(8);
  @$pb.TagNumber(9)
  void clearPic4() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get pic5 => $_getSZ(9);
  @$pb.TagNumber(10)
  set pic5($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPic5() => $_has(9);
  @$pb.TagNumber(10)
  void clearPic5() => $_clearField(10);
}

class Stat extends $pb.GeneratedMessage {
  factory Stat({
    StatInfo? vt,
    StatInfo? danmaku,
    $fixnum.Int64? reply,
    $fixnum.Int64? fav,
    $fixnum.Int64? coin,
    $fixnum.Int64? share,
    $fixnum.Int64? like,
    $fixnum.Int64? follow,
  }) {
    final result = Stat._();
    if (vt != null) result.vt = vt;
    if (danmaku != null) result.danmaku = danmaku;
    if (reply != null) result.reply = reply;
    if (fav != null) result.fav = fav;
    if (coin != null) result.coin = coin;
    if (share != null) result.share = share;
    if (like != null) result.like = like;
    if (follow != null) result.follow = follow;
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
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Stat.$_createMessage)
    ..aOM<StatInfo>(1, _omitFieldNames ? '' : 'vt',
        subBuilder: StatInfo.$_createMessage)
    ..aOM<StatInfo>(2, _omitFieldNames ? '' : 'danmaku',
        subBuilder: StatInfo.$_createMessage)
    ..aInt64(3, _omitFieldNames ? '' : 'reply')
    ..aInt64(4, _omitFieldNames ? '' : 'fav')
    ..aInt64(5, _omitFieldNames ? '' : 'coin')
    ..aInt64(6, _omitFieldNames ? '' : 'share')
    ..aInt64(7, _omitFieldNames ? '' : 'like')
    ..aInt64(8, _omitFieldNames ? '' : 'follow')
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
  StatInfo get vt => $_getN(0);
  @$pb.TagNumber(1)
  set vt(StatInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVt() => $_has(0);
  @$pb.TagNumber(1)
  void clearVt() => $_clearField(1);
  @$pb.TagNumber(1)
  StatInfo ensureVt() => $_ensure(0);

  @$pb.TagNumber(2)
  StatInfo get danmaku => $_getN(1);
  @$pb.TagNumber(2)
  set danmaku(StatInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDanmaku() => $_has(1);
  @$pb.TagNumber(2)
  void clearDanmaku() => $_clearField(2);
  @$pb.TagNumber(2)
  StatInfo ensureDanmaku() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get reply => $_getI64(2);
  @$pb.TagNumber(3)
  set reply($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReply() => $_has(2);
  @$pb.TagNumber(3)
  void clearReply() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get fav => $_getI64(3);
  @$pb.TagNumber(4)
  set fav($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFav() => $_has(3);
  @$pb.TagNumber(4)
  void clearFav() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get coin => $_getI64(4);
  @$pb.TagNumber(5)
  set coin($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCoin() => $_has(4);
  @$pb.TagNumber(5)
  void clearCoin() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get share => $_getI64(5);
  @$pb.TagNumber(6)
  set share($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasShare() => $_has(5);
  @$pb.TagNumber(6)
  void clearShare() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get like => $_getI64(6);
  @$pb.TagNumber(7)
  set like($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLike() => $_has(6);
  @$pb.TagNumber(7)
  void clearLike() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get follow => $_getI64(7);
  @$pb.TagNumber(8)
  set follow($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFollow() => $_has(7);
  @$pb.TagNumber(8)
  void clearFollow() => $_clearField(8);
}

class StatInfo extends $pb.GeneratedMessage {
  factory StatInfo({
    $fixnum.Int64? value,
    $core.String? text,
    $core.String? pureText,
    $core.String? icon,
  }) {
    final result = StatInfo._();
    if (value != null) result.value = value;
    if (text != null) result.text = text;
    if (pureText != null) result.pureText = pureText;
    if (icon != null) result.icon = icon;
    return result;
  }

  StatInfo._();

  factory StatInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StatInfo()..mergeFromBuffer(data, registry);
  factory StatInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StatInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StatInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: StatInfo.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'value')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'pureText')
    ..aOS(4, _omitFieldNames ? '' : 'icon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatInfo copyWith(void Function(StatInfo) updates) =>
      super.copyWith((message) => updates(message as StatInfo)) as StatInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StatInfo() / StatInfo.new instead')
  static StatInfo create() => StatInfo._();
  static $pb.GeneratedMessage $_createMessage() => StatInfo._();
  @$core.override
  StatInfo createEmptyInstance() => StatInfo._();
  @$core.pragma('dart2js:noInline')
  static StatInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StatInfo>(StatInfo.$_createMessage);
  static StatInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get value => $_getI64(0);
  @$pb.TagNumber(1)
  set value($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pureText => $_getSZ(2);
  @$pb.TagNumber(3)
  set pureText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPureText() => $_has(2);
  @$pb.TagNumber(3)
  void clearPureText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get icon => $_getSZ(3);
  @$pb.TagNumber(4)
  set icon($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIcon() => $_has(3);
  @$pb.TagNumber(4)
  void clearIcon() => $_clearField(4);
}

class Style extends $pb.GeneratedMessage {
  factory Style({
    $core.int? line,
    $core.int? hidden,
    $core.Iterable<$core.String>? showPages,
  }) {
    final result = Style._();
    if (line != null) result.line = line;
    if (hidden != null) result.hidden = hidden;
    if (showPages != null) result.showPages.addAll(showPages);
    return result;
  }

  Style._();

  factory Style.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Style()..mergeFromBuffer(data, registry);
  factory Style.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Style()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Style',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Style.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'line')
    ..aI(2, _omitFieldNames ? '' : 'hidden')
    ..pPS(3, _omitFieldNames ? '' : 'showPages')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Style clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Style copyWith(void Function(Style) updates) =>
      super.copyWith((message) => updates(message as Style)) as Style;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Style() / Style.new instead')
  static Style create() => Style._();
  static $pb.GeneratedMessage $_createMessage() => Style._();
  @$core.override
  Style createEmptyInstance() => Style._();
  @$core.pragma('dart2js:noInline')
  static Style getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Style>(Style.$_createMessage);
  static Style? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get line => $_getIZ(0);
  @$pb.TagNumber(1)
  set line($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLine() => $_has(0);
  @$pb.TagNumber(1)
  void clearLine() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get hidden => $_getIZ(1);
  @$pb.TagNumber(2)
  set hidden($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHidden() => $_has(1);
  @$pb.TagNumber(2)
  void clearHidden() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get showPages => $_getList(2);
}

class Tag extends $pb.GeneratedMessage {
  factory Tag({
    $fixnum.Int64? tagId,
    $core.String? name,
    $core.String? uri,
    $core.String? tagType,
  }) {
    final result = Tag._();
    if (tagId != null) result.tagId = tagId;
    if (name != null) result.name = name;
    if (uri != null) result.uri = uri;
    if (tagType != null) result.tagType = tagType;
    return result;
  }

  Tag._();

  factory Tag.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Tag()..mergeFromBuffer(data, registry);
  factory Tag.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Tag()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Tag',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Tag.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'tagId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'uri')
    ..aOS(4, _omitFieldNames ? '' : 'tagType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tag clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tag copyWith(void Function(Tag) updates) =>
      super.copyWith((message) => updates(message as Tag)) as Tag;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Tag() / Tag.new instead')
  static Tag create() => Tag._();
  static $pb.GeneratedMessage $_createMessage() => Tag._();
  @$core.override
  Tag createEmptyInstance() => Tag._();
  @$core.pragma('dart2js:noInline')
  static Tag getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Tag>(Tag.$_createMessage);
  static Tag? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get tagId => $_getI64(0);
  @$pb.TagNumber(1)
  set tagId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTagId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTagId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get uri => $_getSZ(2);
  @$pb.TagNumber(3)
  set uri($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUri() => $_has(2);
  @$pb.TagNumber(3)
  void clearUri() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get tagType => $_getSZ(3);
  @$pb.TagNumber(4)
  set tagType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTagType() => $_has(3);
  @$pb.TagNumber(4)
  void clearTagType() => $_clearField(4);
}

class TextWidget extends $pb.GeneratedMessage {
  factory TextWidget({
    $core.String? code,
    $core.String? text,
    $core.String? textColor,
    $core.String? bgColor,
  }) {
    final result = TextWidget._();
    if (code != null) result.code = code;
    if (text != null) result.text = text;
    if (textColor != null) result.textColor = textColor;
    if (bgColor != null) result.bgColor = bgColor;
    return result;
  }

  TextWidget._();

  factory TextWidget.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TextWidget()..mergeFromBuffer(data, registry);
  factory TextWidget.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TextWidget()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TextWidget',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: TextWidget.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'textColor')
    ..aOS(4, _omitFieldNames ? '' : 'bgColor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextWidget clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextWidget copyWith(void Function(TextWidget) updates) =>
      super.copyWith((message) => updates(message as TextWidget)) as TextWidget;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TextWidget() / TextWidget.new instead')
  static TextWidget create() => TextWidget._();
  static $pb.GeneratedMessage $_createMessage() => TextWidget._();
  @$core.override
  TextWidget createEmptyInstance() => TextWidget._();
  @$core.pragma('dart2js:noInline')
  static TextWidget getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TextWidget>(TextWidget.$_createMessage);
  static TextWidget? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get textColor => $_getSZ(2);
  @$pb.TagNumber(3)
  set textColor($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTextColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextColor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get bgColor => $_getSZ(3);
  @$pb.TagNumber(4)
  set bgColor($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBgColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearBgColor() => $_clearField(4);
}

class TheatreHotTopic extends $pb.GeneratedMessage {
  factory TheatreHotTopic({
    $fixnum.Int64? theatreId,
    $fixnum.Int64? theatreSetId,
    $core.String? theatreTitle,
    $core.String? backgroundImageUrl,
    $core.String? theatreUrl,
    $fixnum.Int64? hotTopicId,
    $fixnum.Int64? hotTopicSetId,
    $core.String? hotTopicTitle,
    $core.String? hotTopicUrl,
    $core.int? isSubscribe,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
  }) {
    final result = TheatreHotTopic._();
    if (theatreId != null) result.theatreId = theatreId;
    if (theatreSetId != null) result.theatreSetId = theatreSetId;
    if (theatreTitle != null) result.theatreTitle = theatreTitle;
    if (backgroundImageUrl != null)
      result.backgroundImageUrl = backgroundImageUrl;
    if (theatreUrl != null) result.theatreUrl = theatreUrl;
    if (hotTopicId != null) result.hotTopicId = hotTopicId;
    if (hotTopicSetId != null) result.hotTopicSetId = hotTopicSetId;
    if (hotTopicTitle != null) result.hotTopicTitle = hotTopicTitle;
    if (hotTopicUrl != null) result.hotTopicUrl = hotTopicUrl;
    if (isSubscribe != null) result.isSubscribe = isSubscribe;
    if (report != null) result.report.addEntries(report);
    return result;
  }

  TheatreHotTopic._();

  factory TheatreHotTopic.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TheatreHotTopic()..mergeFromBuffer(data, registry);
  factory TheatreHotTopic.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TheatreHotTopic()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TheatreHotTopic',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: TheatreHotTopic.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'theatreId')
    ..aInt64(2, _omitFieldNames ? '' : 'theatreSetId')
    ..aOS(3, _omitFieldNames ? '' : 'theatreTitle')
    ..aOS(4, _omitFieldNames ? '' : 'backgroundImageUrl')
    ..aOS(5, _omitFieldNames ? '' : 'theatreUrl')
    ..aInt64(6, _omitFieldNames ? '' : 'hotTopicId')
    ..aInt64(7, _omitFieldNames ? '' : 'hotTopicSetId')
    ..aOS(8, _omitFieldNames ? '' : 'hotTopicTitle')
    ..aOS(9, _omitFieldNames ? '' : 'hotTopicUrl')
    ..aI(10, _omitFieldNames ? '' : 'isSubscribe')
    ..m<$core.String, $core.String>(11, _omitFieldNames ? '' : 'report',
        entryClassName: 'TheatreHotTopic.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TheatreHotTopic clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TheatreHotTopic copyWith(void Function(TheatreHotTopic) updates) =>
      super.copyWith((message) => updates(message as TheatreHotTopic))
          as TheatreHotTopic;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TheatreHotTopic() / TheatreHotTopic.new instead')
  static TheatreHotTopic create() => TheatreHotTopic._();
  static $pb.GeneratedMessage $_createMessage() => TheatreHotTopic._();
  @$core.override
  TheatreHotTopic createEmptyInstance() => TheatreHotTopic._();
  @$core.pragma('dart2js:noInline')
  static TheatreHotTopic getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TheatreHotTopic>(
          TheatreHotTopic.$_createMessage);
  static TheatreHotTopic? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get theatreId => $_getI64(0);
  @$pb.TagNumber(1)
  set theatreId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTheatreId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTheatreId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get theatreSetId => $_getI64(1);
  @$pb.TagNumber(2)
  set theatreSetId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTheatreSetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTheatreSetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get theatreTitle => $_getSZ(2);
  @$pb.TagNumber(3)
  set theatreTitle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTheatreTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTheatreTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get backgroundImageUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set backgroundImageUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBackgroundImageUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearBackgroundImageUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get theatreUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set theatreUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTheatreUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearTheatreUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get hotTopicId => $_getI64(5);
  @$pb.TagNumber(6)
  set hotTopicId($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHotTopicId() => $_has(5);
  @$pb.TagNumber(6)
  void clearHotTopicId() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get hotTopicSetId => $_getI64(6);
  @$pb.TagNumber(7)
  set hotTopicSetId($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasHotTopicSetId() => $_has(6);
  @$pb.TagNumber(7)
  void clearHotTopicSetId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get hotTopicTitle => $_getSZ(7);
  @$pb.TagNumber(8)
  set hotTopicTitle($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHotTopicTitle() => $_has(7);
  @$pb.TagNumber(8)
  void clearHotTopicTitle() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get hotTopicUrl => $_getSZ(8);
  @$pb.TagNumber(9)
  set hotTopicUrl($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasHotTopicUrl() => $_has(8);
  @$pb.TagNumber(9)
  void clearHotTopicUrl() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get isSubscribe => $_getIZ(9);
  @$pb.TagNumber(10)
  set isSubscribe($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIsSubscribe() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsSubscribe() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(10);
}

class Threshold extends $pb.GeneratedMessage {
  factory Threshold({
    $core.int? bp,
    $core.int? days,
    $core.String? daysText,
  }) {
    final result = Threshold._();
    if (bp != null) result.bp = bp;
    if (days != null) result.days = days;
    if (daysText != null) result.daysText = daysText;
    return result;
  }

  Threshold._();

  factory Threshold.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Threshold()..mergeFromBuffer(data, registry);
  factory Threshold.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Threshold()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Threshold',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Threshold.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'bp')
    ..aI(2, _omitFieldNames ? '' : 'days')
    ..aOS(3, _omitFieldNames ? '' : 'daysText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Threshold clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Threshold copyWith(void Function(Threshold) updates) =>
      super.copyWith((message) => updates(message as Threshold)) as Threshold;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Threshold() / Threshold.new instead')
  static Threshold create() => Threshold._();
  static $pb.GeneratedMessage $_createMessage() => Threshold._();
  @$core.override
  Threshold createEmptyInstance() => Threshold._();
  @$core.pragma('dart2js:noInline')
  static Threshold getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Threshold>(Threshold.$_createMessage);
  static Threshold? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get bp => $_getIZ(0);
  @$pb.TagNumber(1)
  set bp($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBp() => $_has(0);
  @$pb.TagNumber(1)
  void clearBp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get days => $_getIZ(1);
  @$pb.TagNumber(2)
  set days($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDays() => $_has(1);
  @$pb.TagNumber(2)
  void clearDays() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get daysText => $_getSZ(2);
  @$pb.TagNumber(3)
  set daysText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDaysText() => $_has(2);
  @$pb.TagNumber(3)
  void clearDaysText() => $_clearField(3);
}

class TitleDeliveryButton extends $pb.GeneratedMessage {
  factory TitleDeliveryButton({
    $core.String? icon,
    $core.String? title,
    $core.String? link,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
    $core.String? bubble,
  }) {
    final result = TitleDeliveryButton._();
    if (icon != null) result.icon = icon;
    if (title != null) result.title = title;
    if (link != null) result.link = link;
    if (report != null) result.report.addEntries(report);
    if (bubble != null) result.bubble = bubble;
    return result;
  }

  TitleDeliveryButton._();

  factory TitleDeliveryButton.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TitleDeliveryButton()..mergeFromBuffer(data, registry);
  factory TitleDeliveryButton.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TitleDeliveryButton()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TitleDeliveryButton',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: TitleDeliveryButton.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'icon')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'link')
    ..m<$core.String, $core.String>(4, _omitFieldNames ? '' : 'report',
        entryClassName: 'TitleDeliveryButton.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..aOS(5, _omitFieldNames ? '' : 'bubble')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TitleDeliveryButton clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TitleDeliveryButton copyWith(void Function(TitleDeliveryButton) updates) =>
      super.copyWith((message) => updates(message as TitleDeliveryButton))
          as TitleDeliveryButton;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use TitleDeliveryButton() / TitleDeliveryButton.new instead')
  static TitleDeliveryButton create() => TitleDeliveryButton._();
  static $pb.GeneratedMessage $_createMessage() => TitleDeliveryButton._();
  @$core.override
  TitleDeliveryButton createEmptyInstance() => TitleDeliveryButton._();
  @$core.pragma('dart2js:noInline')
  static TitleDeliveryButton getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TitleDeliveryButton>(
          TitleDeliveryButton.$_createMessage);
  static TitleDeliveryButton? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get icon => $_getSZ(0);
  @$pb.TagNumber(1)
  set icon($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIcon() => $_has(0);
  @$pb.TagNumber(1)
  void clearIcon() => $_clearField(1);

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
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(3);

  @$pb.TagNumber(5)
  $core.String get bubble => $_getSZ(4);
  @$pb.TagNumber(5)
  set bubble($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBubble() => $_has(4);
  @$pb.TagNumber(5)
  void clearBubble() => $_clearField(5);
}

class UgcEpisode extends $pb.GeneratedMessage {
  factory UgcEpisode({
    $fixnum.Int64? id,
    $fixnum.Int64? aid,
    $fixnum.Int64? cid,
    $core.String? title,
    $core.String? cover,
    $core.String? coverRightText,
    Page? page,
    StatInfo? vt,
    StatInfo? danmaku,
    BadgeInfo? badge,
    $core.Iterable<Page>? pages,
    $core.double? progressPercent,
    $fixnum.Int64? duration,
    Author? author,
    $4.BizType? bizType,
  }) {
    final result = UgcEpisode._();
    if (id != null) result.id = id;
    if (aid != null) result.aid = aid;
    if (cid != null) result.cid = cid;
    if (title != null) result.title = title;
    if (cover != null) result.cover = cover;
    if (coverRightText != null) result.coverRightText = coverRightText;
    if (page != null) result.page = page;
    if (vt != null) result.vt = vt;
    if (danmaku != null) result.danmaku = danmaku;
    if (badge != null) result.badge = badge;
    if (pages != null) result.pages.addAll(pages);
    if (progressPercent != null) result.progressPercent = progressPercent;
    if (duration != null) result.duration = duration;
    if (author != null) result.author = author;
    if (bizType != null) result.bizType = bizType;
    return result;
  }

  UgcEpisode._();

  factory UgcEpisode.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UgcEpisode()..mergeFromBuffer(data, registry);
  factory UgcEpisode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UgcEpisode()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UgcEpisode',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: UgcEpisode.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aInt64(2, _omitFieldNames ? '' : 'aid')
    ..aInt64(3, _omitFieldNames ? '' : 'cid')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'cover')
    ..aOS(6, _omitFieldNames ? '' : 'coverRightText')
    ..aOM<Page>(7, _omitFieldNames ? '' : 'page',
        subBuilder: Page.$_createMessage)
    ..aOM<StatInfo>(8, _omitFieldNames ? '' : 'vt',
        subBuilder: StatInfo.$_createMessage)
    ..aOM<StatInfo>(9, _omitFieldNames ? '' : 'danmaku',
        subBuilder: StatInfo.$_createMessage)
    ..aOM<BadgeInfo>(10, _omitFieldNames ? '' : 'badge',
        subBuilder: BadgeInfo.$_createMessage)
    ..pPM<Page>(11, _omitFieldNames ? '' : 'pages',
        subBuilder: Page.$_createMessage)
    ..aD(12, _omitFieldNames ? '' : 'progressPercent')
    ..aInt64(13, _omitFieldNames ? '' : 'duration')
    ..aOM<Author>(14, _omitFieldNames ? '' : 'author',
        subBuilder: Author.$_createMessage)
    ..aE<$4.BizType>(15, _omitFieldNames ? '' : 'bizType',
        enumValues: $4.BizType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UgcEpisode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UgcEpisode copyWith(void Function(UgcEpisode) updates) =>
      super.copyWith((message) => updates(message as UgcEpisode)) as UgcEpisode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UgcEpisode() / UgcEpisode.new instead')
  static UgcEpisode create() => UgcEpisode._();
  static $pb.GeneratedMessage $_createMessage() => UgcEpisode._();
  @$core.override
  UgcEpisode createEmptyInstance() => UgcEpisode._();
  @$core.pragma('dart2js:noInline')
  static UgcEpisode getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UgcEpisode>(UgcEpisode.$_createMessage);
  static UgcEpisode? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

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
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get cover => $_getSZ(4);
  @$pb.TagNumber(5)
  set cover($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCover() => $_has(4);
  @$pb.TagNumber(5)
  void clearCover() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get coverRightText => $_getSZ(5);
  @$pb.TagNumber(6)
  set coverRightText($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCoverRightText() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoverRightText() => $_clearField(6);

  @$pb.TagNumber(7)
  Page get page => $_getN(6);
  @$pb.TagNumber(7)
  set page(Page value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPage() => $_has(6);
  @$pb.TagNumber(7)
  void clearPage() => $_clearField(7);
  @$pb.TagNumber(7)
  Page ensurePage() => $_ensure(6);

  @$pb.TagNumber(8)
  StatInfo get vt => $_getN(7);
  @$pb.TagNumber(8)
  set vt(StatInfo value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasVt() => $_has(7);
  @$pb.TagNumber(8)
  void clearVt() => $_clearField(8);
  @$pb.TagNumber(8)
  StatInfo ensureVt() => $_ensure(7);

  @$pb.TagNumber(9)
  StatInfo get danmaku => $_getN(8);
  @$pb.TagNumber(9)
  set danmaku(StatInfo value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasDanmaku() => $_has(8);
  @$pb.TagNumber(9)
  void clearDanmaku() => $_clearField(9);
  @$pb.TagNumber(9)
  StatInfo ensureDanmaku() => $_ensure(8);

  @$pb.TagNumber(10)
  BadgeInfo get badge => $_getN(9);
  @$pb.TagNumber(10)
  set badge(BadgeInfo value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasBadge() => $_has(9);
  @$pb.TagNumber(10)
  void clearBadge() => $_clearField(10);
  @$pb.TagNumber(10)
  BadgeInfo ensureBadge() => $_ensure(9);

  @$pb.TagNumber(11)
  $pb.PbList<Page> get pages => $_getList(10);

  @$pb.TagNumber(12)
  $core.double get progressPercent => $_getN(11);
  @$pb.TagNumber(12)
  set progressPercent($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasProgressPercent() => $_has(11);
  @$pb.TagNumber(12)
  void clearProgressPercent() => $_clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get duration => $_getI64(12);
  @$pb.TagNumber(13)
  set duration($fixnum.Int64 value) => $_setInt64(12, value);
  @$pb.TagNumber(13)
  $core.bool hasDuration() => $_has(12);
  @$pb.TagNumber(13)
  void clearDuration() => $_clearField(13);

  @$pb.TagNumber(14)
  Author get author => $_getN(13);
  @$pb.TagNumber(14)
  set author(Author value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasAuthor() => $_has(13);
  @$pb.TagNumber(14)
  void clearAuthor() => $_clearField(14);
  @$pb.TagNumber(14)
  Author ensureAuthor() => $_ensure(13);

  @$pb.TagNumber(15)
  $4.BizType get bizType => $_getN(14);
  @$pb.TagNumber(15)
  set bizType($4.BizType value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasBizType() => $_has(14);
  @$pb.TagNumber(15)
  void clearBizType() => $_clearField(15);
}

class UgcIntroduction extends $pb.GeneratedMessage {
  factory UgcIntroduction({
    $core.Iterable<Tag>? tags,
    Rating? rating,
    Rank? rank,
    $core.Iterable<ViewMaterial>? bgm,
    $core.Iterable<ViewMaterial>? sticker,
    $core.Iterable<ViewMaterial>? videoSource,
    $fixnum.Int64? pubdate,
    $core.Iterable<DescV2>? desc,
    Neutral? neutral,
  }) {
    final result = UgcIntroduction._();
    if (tags != null) result.tags.addAll(tags);
    if (rating != null) result.rating = rating;
    if (rank != null) result.rank = rank;
    if (bgm != null) result.bgm.addAll(bgm);
    if (sticker != null) result.sticker.addAll(sticker);
    if (videoSource != null) result.videoSource.addAll(videoSource);
    if (pubdate != null) result.pubdate = pubdate;
    if (desc != null) result.desc.addAll(desc);
    if (neutral != null) result.neutral = neutral;
    return result;
  }

  UgcIntroduction._();

  factory UgcIntroduction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UgcIntroduction()..mergeFromBuffer(data, registry);
  factory UgcIntroduction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UgcIntroduction()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UgcIntroduction',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: UgcIntroduction.$_createMessage)
    ..pPM<Tag>(1, _omitFieldNames ? '' : 'tags',
        subBuilder: Tag.$_createMessage)
    ..aOM<Rating>(2, _omitFieldNames ? '' : 'rating',
        subBuilder: Rating.$_createMessage)
    ..aOM<Rank>(3, _omitFieldNames ? '' : 'rank',
        subBuilder: Rank.$_createMessage)
    ..pPM<ViewMaterial>(4, _omitFieldNames ? '' : 'bgm',
        subBuilder: ViewMaterial.$_createMessage)
    ..pPM<ViewMaterial>(5, _omitFieldNames ? '' : 'sticker',
        subBuilder: ViewMaterial.$_createMessage)
    ..pPM<ViewMaterial>(6, _omitFieldNames ? '' : 'videoSource',
        subBuilder: ViewMaterial.$_createMessage)
    ..aInt64(7, _omitFieldNames ? '' : 'pubdate')
    ..pPM<DescV2>(8, _omitFieldNames ? '' : 'desc',
        subBuilder: DescV2.$_createMessage)
    ..aOM<Neutral>(9, _omitFieldNames ? '' : 'neutral',
        subBuilder: Neutral.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UgcIntroduction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UgcIntroduction copyWith(void Function(UgcIntroduction) updates) =>
      super.copyWith((message) => updates(message as UgcIntroduction))
          as UgcIntroduction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UgcIntroduction() / UgcIntroduction.new instead')
  static UgcIntroduction create() => UgcIntroduction._();
  static $pb.GeneratedMessage $_createMessage() => UgcIntroduction._();
  @$core.override
  UgcIntroduction createEmptyInstance() => UgcIntroduction._();
  @$core.pragma('dart2js:noInline')
  static UgcIntroduction getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UgcIntroduction>(
          UgcIntroduction.$_createMessage);
  static UgcIntroduction? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Tag> get tags => $_getList(0);

  @$pb.TagNumber(2)
  Rating get rating => $_getN(1);
  @$pb.TagNumber(2)
  set rating(Rating value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRating() => $_has(1);
  @$pb.TagNumber(2)
  void clearRating() => $_clearField(2);
  @$pb.TagNumber(2)
  Rating ensureRating() => $_ensure(1);

  @$pb.TagNumber(3)
  Rank get rank => $_getN(2);
  @$pb.TagNumber(3)
  set rank(Rank value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRank() => $_has(2);
  @$pb.TagNumber(3)
  void clearRank() => $_clearField(3);
  @$pb.TagNumber(3)
  Rank ensureRank() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<ViewMaterial> get bgm => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<ViewMaterial> get sticker => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<ViewMaterial> get videoSource => $_getList(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get pubdate => $_getI64(6);
  @$pb.TagNumber(7)
  set pubdate($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPubdate() => $_has(6);
  @$pb.TagNumber(7)
  void clearPubdate() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<DescV2> get desc => $_getList(7);

  @$pb.TagNumber(9)
  Neutral get neutral => $_getN(8);
  @$pb.TagNumber(9)
  set neutral(Neutral value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasNeutral() => $_has(8);
  @$pb.TagNumber(9)
  void clearNeutral() => $_clearField(9);
  @$pb.TagNumber(9)
  Neutral ensureNeutral() => $_ensure(8);
}

class UgcSeasonActivity extends $pb.GeneratedMessage {
  factory UgcSeasonActivity({
    $core.int? type,
    $fixnum.Int64? oid,
    $fixnum.Int64? activityId,
    $core.String? title,
    $core.String? intro,
    $core.int? dayCount,
    $core.int? userCount,
    $fixnum.Int64? joinDeadline,
    $fixnum.Int64? activityDeadline,
    $core.int? checkinViewTime,
    $core.bool? newActivity,
    UserActivity? userActivity,
    SeasonShow? seasonShow,
  }) {
    final result = UgcSeasonActivity._();
    if (type != null) result.type = type;
    if (oid != null) result.oid = oid;
    if (activityId != null) result.activityId = activityId;
    if (title != null) result.title = title;
    if (intro != null) result.intro = intro;
    if (dayCount != null) result.dayCount = dayCount;
    if (userCount != null) result.userCount = userCount;
    if (joinDeadline != null) result.joinDeadline = joinDeadline;
    if (activityDeadline != null) result.activityDeadline = activityDeadline;
    if (checkinViewTime != null) result.checkinViewTime = checkinViewTime;
    if (newActivity != null) result.newActivity = newActivity;
    if (userActivity != null) result.userActivity = userActivity;
    if (seasonShow != null) result.seasonShow = seasonShow;
    return result;
  }

  UgcSeasonActivity._();

  factory UgcSeasonActivity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UgcSeasonActivity()..mergeFromBuffer(data, registry);
  factory UgcSeasonActivity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UgcSeasonActivity()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UgcSeasonActivity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: UgcSeasonActivity.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'type')
    ..aInt64(2, _omitFieldNames ? '' : 'oid')
    ..aInt64(3, _omitFieldNames ? '' : 'activityId')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'intro')
    ..aI(6, _omitFieldNames ? '' : 'dayCount')
    ..aI(7, _omitFieldNames ? '' : 'userCount')
    ..aInt64(8, _omitFieldNames ? '' : 'joinDeadline')
    ..aInt64(9, _omitFieldNames ? '' : 'activityDeadline')
    ..aI(10, _omitFieldNames ? '' : 'checkinViewTime')
    ..aOB(11, _omitFieldNames ? '' : 'newActivity')
    ..aOM<UserActivity>(12, _omitFieldNames ? '' : 'userActivity',
        subBuilder: UserActivity.$_createMessage)
    ..aOM<SeasonShow>(13, _omitFieldNames ? '' : 'seasonShow',
        subBuilder: SeasonShow.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UgcSeasonActivity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UgcSeasonActivity copyWith(void Function(UgcSeasonActivity) updates) =>
      super.copyWith((message) => updates(message as UgcSeasonActivity))
          as UgcSeasonActivity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UgcSeasonActivity() / UgcSeasonActivity.new instead')
  static UgcSeasonActivity create() => UgcSeasonActivity._();
  static $pb.GeneratedMessage $_createMessage() => UgcSeasonActivity._();
  @$core.override
  UgcSeasonActivity createEmptyInstance() => UgcSeasonActivity._();
  @$core.pragma('dart2js:noInline')
  static UgcSeasonActivity getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UgcSeasonActivity>(
          UgcSeasonActivity.$_createMessage);
  static UgcSeasonActivity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int value) => $_setSignedInt32(0, value);
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
  $fixnum.Int64 get activityId => $_getI64(2);
  @$pb.TagNumber(3)
  set activityId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActivityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearActivityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get intro => $_getSZ(4);
  @$pb.TagNumber(5)
  set intro($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIntro() => $_has(4);
  @$pb.TagNumber(5)
  void clearIntro() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get dayCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set dayCount($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDayCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearDayCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get userCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set userCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUserCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearUserCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get joinDeadline => $_getI64(7);
  @$pb.TagNumber(8)
  set joinDeadline($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasJoinDeadline() => $_has(7);
  @$pb.TagNumber(8)
  void clearJoinDeadline() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get activityDeadline => $_getI64(8);
  @$pb.TagNumber(9)
  set activityDeadline($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasActivityDeadline() => $_has(8);
  @$pb.TagNumber(9)
  void clearActivityDeadline() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get checkinViewTime => $_getIZ(9);
  @$pb.TagNumber(10)
  set checkinViewTime($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCheckinViewTime() => $_has(9);
  @$pb.TagNumber(10)
  void clearCheckinViewTime() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get newActivity => $_getBF(10);
  @$pb.TagNumber(11)
  set newActivity($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasNewActivity() => $_has(10);
  @$pb.TagNumber(11)
  void clearNewActivity() => $_clearField(11);

  @$pb.TagNumber(12)
  UserActivity get userActivity => $_getN(11);
  @$pb.TagNumber(12)
  set userActivity(UserActivity value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasUserActivity() => $_has(11);
  @$pb.TagNumber(12)
  void clearUserActivity() => $_clearField(12);
  @$pb.TagNumber(12)
  UserActivity ensureUserActivity() => $_ensure(11);

  @$pb.TagNumber(13)
  SeasonShow get seasonShow => $_getN(12);
  @$pb.TagNumber(13)
  set seasonShow(SeasonShow value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasSeasonShow() => $_has(12);
  @$pb.TagNumber(13)
  void clearSeasonShow() => $_clearField(13);
  @$pb.TagNumber(13)
  SeasonShow ensureSeasonShow() => $_ensure(12);
}

class UgcSeasons extends $pb.GeneratedMessage {
  factory UgcSeasons({
    $fixnum.Int64? id,
    $core.String? title,
    $core.String? cover,
    $core.String? supernatantTitle,
    $core.Iterable<UgcSection>? section,
    $core.String? unionTitle,
    SeasonHead? head,
    $fixnum.Int64? epCount,
    SeasonType? seasonType,
    UgcSeasonActivity? activity,
    $core.Iterable<$core.String>? seasonAbility,
    $core.String? seasonTitle,
  }) {
    final result = UgcSeasons._();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (cover != null) result.cover = cover;
    if (supernatantTitle != null) result.supernatantTitle = supernatantTitle;
    if (section != null) result.section.addAll(section);
    if (unionTitle != null) result.unionTitle = unionTitle;
    if (head != null) result.head = head;
    if (epCount != null) result.epCount = epCount;
    if (seasonType != null) result.seasonType = seasonType;
    if (activity != null) result.activity = activity;
    if (seasonAbility != null) result.seasonAbility.addAll(seasonAbility);
    if (seasonTitle != null) result.seasonTitle = seasonTitle;
    return result;
  }

  UgcSeasons._();

  factory UgcSeasons.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UgcSeasons()..mergeFromBuffer(data, registry);
  factory UgcSeasons.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UgcSeasons()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UgcSeasons',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: UgcSeasons.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'cover')
    ..aOS(4, _omitFieldNames ? '' : 'supernatantTitle')
    ..pPM<UgcSection>(5, _omitFieldNames ? '' : 'section',
        subBuilder: UgcSection.$_createMessage)
    ..aOS(6, _omitFieldNames ? '' : 'unionTitle')
    ..aOM<SeasonHead>(7, _omitFieldNames ? '' : 'head',
        subBuilder: SeasonHead.$_createMessage)
    ..aInt64(8, _omitFieldNames ? '' : 'epCount')
    ..aE<SeasonType>(9, _omitFieldNames ? '' : 'seasonType',
        enumValues: SeasonType.values)
    ..aOM<UgcSeasonActivity>(10, _omitFieldNames ? '' : 'activity',
        subBuilder: UgcSeasonActivity.$_createMessage)
    ..pPS(11, _omitFieldNames ? '' : 'seasonAbility')
    ..aOS(12, _omitFieldNames ? '' : 'seasonTitle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UgcSeasons clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UgcSeasons copyWith(void Function(UgcSeasons) updates) =>
      super.copyWith((message) => updates(message as UgcSeasons)) as UgcSeasons;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UgcSeasons() / UgcSeasons.new instead')
  static UgcSeasons create() => UgcSeasons._();
  static $pb.GeneratedMessage $_createMessage() => UgcSeasons._();
  @$core.override
  UgcSeasons createEmptyInstance() => UgcSeasons._();
  @$core.pragma('dart2js:noInline')
  static UgcSeasons getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UgcSeasons>(UgcSeasons.$_createMessage);
  static UgcSeasons? _defaultInstance;

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
  $core.String get cover => $_getSZ(2);
  @$pb.TagNumber(3)
  set cover($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCover() => $_has(2);
  @$pb.TagNumber(3)
  void clearCover() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get supernatantTitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set supernatantTitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSupernatantTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearSupernatantTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<UgcSection> get section => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get unionTitle => $_getSZ(5);
  @$pb.TagNumber(6)
  set unionTitle($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUnionTitle() => $_has(5);
  @$pb.TagNumber(6)
  void clearUnionTitle() => $_clearField(6);

  @$pb.TagNumber(7)
  SeasonHead get head => $_getN(6);
  @$pb.TagNumber(7)
  set head(SeasonHead value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasHead() => $_has(6);
  @$pb.TagNumber(7)
  void clearHead() => $_clearField(7);
  @$pb.TagNumber(7)
  SeasonHead ensureHead() => $_ensure(6);

  @$pb.TagNumber(8)
  $fixnum.Int64 get epCount => $_getI64(7);
  @$pb.TagNumber(8)
  set epCount($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEpCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearEpCount() => $_clearField(8);

  @$pb.TagNumber(9)
  SeasonType get seasonType => $_getN(8);
  @$pb.TagNumber(9)
  set seasonType(SeasonType value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSeasonType() => $_has(8);
  @$pb.TagNumber(9)
  void clearSeasonType() => $_clearField(9);

  @$pb.TagNumber(10)
  UgcSeasonActivity get activity => $_getN(9);
  @$pb.TagNumber(10)
  set activity(UgcSeasonActivity value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasActivity() => $_has(9);
  @$pb.TagNumber(10)
  void clearActivity() => $_clearField(10);
  @$pb.TagNumber(10)
  UgcSeasonActivity ensureActivity() => $_ensure(9);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get seasonAbility => $_getList(10);

  @$pb.TagNumber(12)
  $core.String get seasonTitle => $_getSZ(11);
  @$pb.TagNumber(12)
  set seasonTitle($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSeasonTitle() => $_has(11);
  @$pb.TagNumber(12)
  void clearSeasonTitle() => $_clearField(12);
}

class UgcSection extends $pb.GeneratedMessage {
  factory UgcSection({
    $fixnum.Int64? id,
    $core.String? title,
    $fixnum.Int64? type,
    $core.Iterable<UgcEpisode>? episodes,
  }) {
    final result = UgcSection._();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (type != null) result.type = type;
    if (episodes != null) result.episodes.addAll(episodes);
    return result;
  }

  UgcSection._();

  factory UgcSection.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UgcSection()..mergeFromBuffer(data, registry);
  factory UgcSection.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UgcSection()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UgcSection',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: UgcSection.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aInt64(3, _omitFieldNames ? '' : 'type')
    ..pPM<UgcEpisode>(4, _omitFieldNames ? '' : 'episodes',
        subBuilder: UgcEpisode.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UgcSection clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UgcSection copyWith(void Function(UgcSection) updates) =>
      super.copyWith((message) => updates(message as UgcSection)) as UgcSection;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UgcSection() / UgcSection.new instead')
  static UgcSection create() => UgcSection._();
  static $pb.GeneratedMessage $_createMessage() => UgcSection._();
  @$core.override
  UgcSection createEmptyInstance() => UgcSection._();
  @$core.pragma('dart2js:noInline')
  static UgcSection getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UgcSection>(UgcSection.$_createMessage);
  static UgcSection? _defaultInstance;

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
  $fixnum.Int64 get type => $_getI64(2);
  @$pb.TagNumber(3)
  set type($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<UgcEpisode> get episodes => $_getList(3);
}

class UpDataModule extends $pb.GeneratedMessage {
  factory UpDataModule({
    $core.Iterable<ExtTab>? extTabs,
    $core.int? idx,
    $core.String? protocolUrl,
    $core.int? height,
  }) {
    final result = UpDataModule._();
    if (extTabs != null) result.extTabs.addAll(extTabs);
    if (idx != null) result.idx = idx;
    if (protocolUrl != null) result.protocolUrl = protocolUrl;
    if (height != null) result.height = height;
    return result;
  }

  UpDataModule._();

  factory UpDataModule.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpDataModule()..mergeFromBuffer(data, registry);
  factory UpDataModule.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpDataModule()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpDataModule',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: UpDataModule.$_createMessage)
    ..pPM<ExtTab>(1, _omitFieldNames ? '' : 'extTabs',
        subBuilder: ExtTab.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'idx')
    ..aOS(3, _omitFieldNames ? '' : 'protocolUrl')
    ..aI(4, _omitFieldNames ? '' : 'height')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpDataModule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpDataModule copyWith(void Function(UpDataModule) updates) =>
      super.copyWith((message) => updates(message as UpDataModule))
          as UpDataModule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UpDataModule() / UpDataModule.new instead')
  static UpDataModule create() => UpDataModule._();
  static $pb.GeneratedMessage $_createMessage() => UpDataModule._();
  @$core.override
  UpDataModule createEmptyInstance() => UpDataModule._();
  @$core.pragma('dart2js:noInline')
  static UpDataModule getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpDataModule>(
          UpDataModule.$_createMessage);
  static UpDataModule? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ExtTab> get extTabs => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get idx => $_getIZ(1);
  @$pb.TagNumber(2)
  set idx($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIdx() => $_has(1);
  @$pb.TagNumber(2)
  void clearIdx() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get protocolUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set protocolUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProtocolUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearProtocolUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get height => $_getIZ(3);
  @$pb.TagNumber(4)
  set height($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeight() => $_clearField(4);
}

class UpLikeImg extends $pb.GeneratedMessage {
  factory UpLikeImg({
    $core.String? preImg,
    $core.String? sucImg,
    $core.String? content,
    $fixnum.Int64? type,
  }) {
    final result = UpLikeImg._();
    if (preImg != null) result.preImg = preImg;
    if (sucImg != null) result.sucImg = sucImg;
    if (content != null) result.content = content;
    if (type != null) result.type = type;
    return result;
  }

  UpLikeImg._();

  factory UpLikeImg.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpLikeImg()..mergeFromBuffer(data, registry);
  factory UpLikeImg.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpLikeImg()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpLikeImg',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: UpLikeImg.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'preImg')
    ..aOS(2, _omitFieldNames ? '' : 'sucImg')
    ..aOS(3, _omitFieldNames ? '' : 'content')
    ..aInt64(4, _omitFieldNames ? '' : 'type')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpLikeImg clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpLikeImg copyWith(void Function(UpLikeImg) updates) =>
      super.copyWith((message) => updates(message as UpLikeImg)) as UpLikeImg;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UpLikeImg() / UpLikeImg.new instead')
  static UpLikeImg create() => UpLikeImg._();
  static $pb.GeneratedMessage $_createMessage() => UpLikeImg._();
  @$core.override
  UpLikeImg createEmptyInstance() => UpLikeImg._();
  @$core.pragma('dart2js:noInline')
  static UpLikeImg getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpLikeImg>(UpLikeImg.$_createMessage);
  static UpLikeImg? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get preImg => $_getSZ(0);
  @$pb.TagNumber(1)
  set preImg($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPreImg() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreImg() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sucImg => $_getSZ(1);
  @$pb.TagNumber(2)
  set sucImg($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSucImg() => $_has(1);
  @$pb.TagNumber(2)
  void clearSucImg() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get content => $_getSZ(2);
  @$pb.TagNumber(3)
  set content($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get type => $_getI64(3);
  @$pb.TagNumber(4)
  set type($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasType() => $_has(3);
  @$pb.TagNumber(4)
  void clearType() => $_clearField(4);
}

class UpTool extends $pb.GeneratedMessage {
  factory UpTool({
    ToolType? type,
    $core.String? text,
    $core.String? icon,
    $core.String? url,
    BadgeInfo? badge,
  }) {
    final result = UpTool._();
    if (type != null) result.type = type;
    if (text != null) result.text = text;
    if (icon != null) result.icon = icon;
    if (url != null) result.url = url;
    if (badge != null) result.badge = badge;
    return result;
  }

  UpTool._();

  factory UpTool.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpTool()..mergeFromBuffer(data, registry);
  factory UpTool.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpTool()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpTool',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: UpTool.$_createMessage)
    ..aE<ToolType>(1, _omitFieldNames ? '' : 'type',
        enumValues: ToolType.values)
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'icon')
    ..aOS(4, _omitFieldNames ? '' : 'url')
    ..aOM<BadgeInfo>(5, _omitFieldNames ? '' : 'badge',
        subBuilder: BadgeInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpTool clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpTool copyWith(void Function(UpTool) updates) =>
      super.copyWith((message) => updates(message as UpTool)) as UpTool;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UpTool() / UpTool.new instead')
  static UpTool create() => UpTool._();
  static $pb.GeneratedMessage $_createMessage() => UpTool._();
  @$core.override
  UpTool createEmptyInstance() => UpTool._();
  @$core.pragma('dart2js:noInline')
  static UpTool getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpTool>(UpTool.$_createMessage);
  static UpTool? _defaultInstance;

  @$pb.TagNumber(1)
  ToolType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(ToolType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get icon => $_getSZ(2);
  @$pb.TagNumber(3)
  set icon($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIcon() => $_has(2);
  @$pb.TagNumber(3)
  void clearIcon() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get url => $_getSZ(3);
  @$pb.TagNumber(4)
  set url($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  BadgeInfo get badge => $_getN(4);
  @$pb.TagNumber(5)
  set badge(BadgeInfo value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasBadge() => $_has(4);
  @$pb.TagNumber(5)
  void clearBadge() => $_clearField(5);
  @$pb.TagNumber(5)
  BadgeInfo ensureBadge() => $_ensure(4);
}

class UpVideoTool extends $pb.GeneratedMessage {
  factory UpVideoTool({
    $core.String? title,
    $core.Iterable<UpTool>? tools,
  }) {
    final result = UpVideoTool._();
    if (title != null) result.title = title;
    if (tools != null) result.tools.addAll(tools);
    return result;
  }

  UpVideoTool._();

  factory UpVideoTool.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpVideoTool()..mergeFromBuffer(data, registry);
  factory UpVideoTool.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpVideoTool()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpVideoTool',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: UpVideoTool.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..pPM<UpTool>(2, _omitFieldNames ? '' : 'tools',
        subBuilder: UpTool.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpVideoTool clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpVideoTool copyWith(void Function(UpVideoTool) updates) =>
      super.copyWith((message) => updates(message as UpVideoTool))
          as UpVideoTool;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UpVideoTool() / UpVideoTool.new instead')
  static UpVideoTool create() => UpVideoTool._();
  static $pb.GeneratedMessage $_createMessage() => UpVideoTool._();
  @$core.override
  UpVideoTool createEmptyInstance() => UpVideoTool._();
  @$core.pragma('dart2js:noInline')
  static UpVideoTool getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpVideoTool>(
          UpVideoTool.$_createMessage);
  static UpVideoTool? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<UpTool> get tools => $_getList(1);
}

class User extends $pb.GeneratedMessage {
  factory User({
    $fixnum.Int64? mid,
    $core.String? name,
    $core.String? face,
    $fixnum.Int64? follower,
  }) {
    final result = User._();
    if (mid != null) result.mid = mid;
    if (name != null) result.name = name;
    if (face != null) result.face = face;
    if (follower != null) result.follower = follower;
    return result;
  }

  User._();

  factory User.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      User()..mergeFromBuffer(data, registry);
  factory User.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      User()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'User',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: User.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'mid')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'face')
    ..aInt64(4, _omitFieldNames ? '' : 'follower')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  User clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  User copyWith(void Function(User) updates) =>
      super.copyWith((message) => updates(message as User)) as User;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use User() / User.new instead')
  static User create() => User._();
  static $pb.GeneratedMessage $_createMessage() => User._();
  @$core.override
  User createEmptyInstance() => User._();
  @$core.pragma('dart2js:noInline')
  static User getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<User>(User.$_createMessage);
  static User? _defaultInstance;

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
  $fixnum.Int64 get follower => $_getI64(3);
  @$pb.TagNumber(4)
  set follower($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFollower() => $_has(3);
  @$pb.TagNumber(4)
  void clearFollower() => $_clearField(4);
}

class UserActivity extends $pb.GeneratedMessage {
  factory UserActivity({
    $core.int? userState,
    $fixnum.Int64? lastCheckinDate,
    $core.int? checkinToday,
    $core.int? userDayCount,
    $core.int? userViewTime,
    $core.String? portrait,
  }) {
    final result = UserActivity._();
    if (userState != null) result.userState = userState;
    if (lastCheckinDate != null) result.lastCheckinDate = lastCheckinDate;
    if (checkinToday != null) result.checkinToday = checkinToday;
    if (userDayCount != null) result.userDayCount = userDayCount;
    if (userViewTime != null) result.userViewTime = userViewTime;
    if (portrait != null) result.portrait = portrait;
    return result;
  }

  UserActivity._();

  factory UserActivity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserActivity()..mergeFromBuffer(data, registry);
  factory UserActivity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserActivity()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserActivity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: UserActivity.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'userState')
    ..aInt64(2, _omitFieldNames ? '' : 'lastCheckinDate')
    ..aI(3, _omitFieldNames ? '' : 'checkinToday')
    ..aI(4, _omitFieldNames ? '' : 'userDayCount')
    ..aI(5, _omitFieldNames ? '' : 'userViewTime')
    ..aOS(6, _omitFieldNames ? '' : 'portrait')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserActivity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserActivity copyWith(void Function(UserActivity) updates) =>
      super.copyWith((message) => updates(message as UserActivity))
          as UserActivity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UserActivity() / UserActivity.new instead')
  static UserActivity create() => UserActivity._();
  static $pb.GeneratedMessage $_createMessage() => UserActivity._();
  @$core.override
  UserActivity createEmptyInstance() => UserActivity._();
  @$core.pragma('dart2js:noInline')
  static UserActivity getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserActivity>(
          UserActivity.$_createMessage);
  static UserActivity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get userState => $_getIZ(0);
  @$pb.TagNumber(1)
  set userState($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserState() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserState() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get lastCheckinDate => $_getI64(1);
  @$pb.TagNumber(2)
  set lastCheckinDate($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLastCheckinDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastCheckinDate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get checkinToday => $_getIZ(2);
  @$pb.TagNumber(3)
  set checkinToday($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCheckinToday() => $_has(2);
  @$pb.TagNumber(3)
  void clearCheckinToday() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get userDayCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set userDayCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUserDayCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserDayCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get userViewTime => $_getIZ(4);
  @$pb.TagNumber(5)
  set userViewTime($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUserViewTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearUserViewTime() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get portrait => $_getSZ(5);
  @$pb.TagNumber(6)
  set portrait($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPortrait() => $_has(5);
  @$pb.TagNumber(6)
  void clearPortrait() => $_clearField(6);
}

class UserList extends $pb.GeneratedMessage {
  factory UserList({
    $core.Iterable<User>? list,
    $core.String? title,
  }) {
    final result = UserList._();
    if (list != null) result.list.addAll(list);
    if (title != null) result.title = title;
    return result;
  }

  UserList._();

  factory UserList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserList()..mergeFromBuffer(data, registry);
  factory UserList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UserList()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserList',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: UserList.$_createMessage)
    ..pPM<User>(1, _omitFieldNames ? '' : 'list',
        subBuilder: User.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserList copyWith(void Function(UserList) updates) =>
      super.copyWith((message) => updates(message as UserList)) as UserList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UserList() / UserList.new instead')
  static UserList create() => UserList._();
  static $pb.GeneratedMessage $_createMessage() => UserList._();
  @$core.override
  UserList createEmptyInstance() => UserList._();
  @$core.pragma('dart2js:noInline')
  static UserList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserList>(UserList.$_createMessage);
  static UserList? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<User> get list => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);
}

class UserStatus extends $pb.GeneratedMessage {
  factory UserStatus({
    $core.int? show,
    $core.int? follow,
  }) {
    final result = UserStatus._();
    if (show != null) result.show = show;
    if (follow != null) result.follow = follow;
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
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: UserStatus.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'show')
    ..aI(2, _omitFieldNames ? '' : 'follow')
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
}

class ViewEpisode extends $pb.GeneratedMessage {
  factory ViewEpisode({
    $fixnum.Int64? epId,
    $core.String? badge,
    $core.int? badgeType,
    BadgeInfo? badgeInfo,
    $core.int? duration,
    $core.int? status,
    $core.String? cover,
    $fixnum.Int64? aid,
    $core.String? title,
    $core.String? movieTitle,
    $core.String? subtitle,
    $core.String? longTitle,
    $core.String? toastTitle,
    $fixnum.Int64? cid,
    $core.String? from,
    $core.String? shareUrl,
    $core.String? shareCopy,
    $core.String? shortLink,
    $core.String? vid,
    $core.String? releaseDate,
    Dimension? dimension,
    Rights? rights,
    Interaction? interaction,
    $core.String? bvid,
    $core.int? archiveAttr,
    $core.String? link,
    $core.String? linkType,
    $core.String? bmid,
    $fixnum.Int64? pubTime,
    $core.int? pv,
    $core.int? epIndex,
    $core.int? sectionIndex,
    $core.Iterable<Staff>? upInfos,
    Staff? upInfo,
    $core.String? dialogType,
    $core.String? toastType,
    $core.Iterable<MultiViewEp>? multiViewEps,
    $core.bool? isSubView,
    $core.bool? isViewHide,
    $core.String? jumpLink,
    Stat? statForUnity,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? report,
    $core.int? sectionType,
    $core.String? showTitle,
  }) {
    final result = ViewEpisode._();
    if (epId != null) result.epId = epId;
    if (badge != null) result.badge = badge;
    if (badgeType != null) result.badgeType = badgeType;
    if (badgeInfo != null) result.badgeInfo = badgeInfo;
    if (duration != null) result.duration = duration;
    if (status != null) result.status = status;
    if (cover != null) result.cover = cover;
    if (aid != null) result.aid = aid;
    if (title != null) result.title = title;
    if (movieTitle != null) result.movieTitle = movieTitle;
    if (subtitle != null) result.subtitle = subtitle;
    if (longTitle != null) result.longTitle = longTitle;
    if (toastTitle != null) result.toastTitle = toastTitle;
    if (cid != null) result.cid = cid;
    if (from != null) result.from = from;
    if (shareUrl != null) result.shareUrl = shareUrl;
    if (shareCopy != null) result.shareCopy = shareCopy;
    if (shortLink != null) result.shortLink = shortLink;
    if (vid != null) result.vid = vid;
    if (releaseDate != null) result.releaseDate = releaseDate;
    if (dimension != null) result.dimension = dimension;
    if (rights != null) result.rights = rights;
    if (interaction != null) result.interaction = interaction;
    if (bvid != null) result.bvid = bvid;
    if (archiveAttr != null) result.archiveAttr = archiveAttr;
    if (link != null) result.link = link;
    if (linkType != null) result.linkType = linkType;
    if (bmid != null) result.bmid = bmid;
    if (pubTime != null) result.pubTime = pubTime;
    if (pv != null) result.pv = pv;
    if (epIndex != null) result.epIndex = epIndex;
    if (sectionIndex != null) result.sectionIndex = sectionIndex;
    if (upInfos != null) result.upInfos.addAll(upInfos);
    if (upInfo != null) result.upInfo = upInfo;
    if (dialogType != null) result.dialogType = dialogType;
    if (toastType != null) result.toastType = toastType;
    if (multiViewEps != null) result.multiViewEps.addAll(multiViewEps);
    if (isSubView != null) result.isSubView = isSubView;
    if (isViewHide != null) result.isViewHide = isViewHide;
    if (jumpLink != null) result.jumpLink = jumpLink;
    if (statForUnity != null) result.statForUnity = statForUnity;
    if (report != null) result.report.addEntries(report);
    if (sectionType != null) result.sectionType = sectionType;
    if (showTitle != null) result.showTitle = showTitle;
    return result;
  }

  ViewEpisode._();

  factory ViewEpisode.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewEpisode()..mergeFromBuffer(data, registry);
  factory ViewEpisode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewEpisode()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ViewEpisode',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ViewEpisode.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'epId')
    ..aOS(2, _omitFieldNames ? '' : 'badge')
    ..aI(3, _omitFieldNames ? '' : 'badgeType')
    ..aOM<BadgeInfo>(4, _omitFieldNames ? '' : 'badgeInfo',
        subBuilder: BadgeInfo.$_createMessage)
    ..aI(5, _omitFieldNames ? '' : 'duration')
    ..aI(6, _omitFieldNames ? '' : 'status')
    ..aOS(7, _omitFieldNames ? '' : 'cover')
    ..aInt64(8, _omitFieldNames ? '' : 'aid')
    ..aOS(9, _omitFieldNames ? '' : 'title')
    ..aOS(10, _omitFieldNames ? '' : 'movieTitle')
    ..aOS(11, _omitFieldNames ? '' : 'subtitle')
    ..aOS(12, _omitFieldNames ? '' : 'longTitle')
    ..aOS(13, _omitFieldNames ? '' : 'toastTitle')
    ..aInt64(14, _omitFieldNames ? '' : 'cid')
    ..aOS(15, _omitFieldNames ? '' : 'from')
    ..aOS(16, _omitFieldNames ? '' : 'shareUrl')
    ..aOS(17, _omitFieldNames ? '' : 'shareCopy')
    ..aOS(18, _omitFieldNames ? '' : 'shortLink')
    ..aOS(19, _omitFieldNames ? '' : 'vid')
    ..aOS(20, _omitFieldNames ? '' : 'releaseDate')
    ..aOM<Dimension>(21, _omitFieldNames ? '' : 'dimension',
        subBuilder: Dimension.$_createMessage)
    ..aOM<Rights>(22, _omitFieldNames ? '' : 'rights',
        subBuilder: Rights.$_createMessage)
    ..aOM<Interaction>(23, _omitFieldNames ? '' : 'interaction',
        subBuilder: Interaction.$_createMessage)
    ..aOS(24, _omitFieldNames ? '' : 'bvid')
    ..aI(25, _omitFieldNames ? '' : 'archiveAttr')
    ..aOS(26, _omitFieldNames ? '' : 'link')
    ..aOS(27, _omitFieldNames ? '' : 'linkType')
    ..aOS(28, _omitFieldNames ? '' : 'bmid')
    ..aInt64(29, _omitFieldNames ? '' : 'pubTime')
    ..aI(30, _omitFieldNames ? '' : 'pv')
    ..aI(31, _omitFieldNames ? '' : 'epIndex')
    ..aI(32, _omitFieldNames ? '' : 'sectionIndex')
    ..pPM<Staff>(33, _omitFieldNames ? '' : 'upInfos',
        subBuilder: Staff.$_createMessage)
    ..aOM<Staff>(34, _omitFieldNames ? '' : 'upInfo',
        subBuilder: Staff.$_createMessage)
    ..aOS(35, _omitFieldNames ? '' : 'dialogType')
    ..aOS(36, _omitFieldNames ? '' : 'toastType')
    ..pPM<MultiViewEp>(37, _omitFieldNames ? '' : 'multiViewEps',
        subBuilder: MultiViewEp.$_createMessage)
    ..aOB(38, _omitFieldNames ? '' : 'isSubView')
    ..aOB(39, _omitFieldNames ? '' : 'isViewHide')
    ..aOS(40, _omitFieldNames ? '' : 'jumpLink')
    ..aOM<Stat>(41, _omitFieldNames ? '' : 'statForUnity',
        subBuilder: Stat.$_createMessage)
    ..m<$core.String, $core.String>(42, _omitFieldNames ? '' : 'report',
        entryClassName: 'ViewEpisode.ReportEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('bilibili.app.viewunite.common'))
    ..aI(43, _omitFieldNames ? '' : 'sectionType')
    ..aOS(44, _omitFieldNames ? '' : 'showTitle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewEpisode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewEpisode copyWith(void Function(ViewEpisode) updates) =>
      super.copyWith((message) => updates(message as ViewEpisode))
          as ViewEpisode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ViewEpisode() / ViewEpisode.new instead')
  static ViewEpisode create() => ViewEpisode._();
  static $pb.GeneratedMessage $_createMessage() => ViewEpisode._();
  @$core.override
  ViewEpisode createEmptyInstance() => ViewEpisode._();
  @$core.pragma('dart2js:noInline')
  static ViewEpisode getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ViewEpisode>(
          ViewEpisode.$_createMessage);
  static ViewEpisode? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get epId => $_getI64(0);
  @$pb.TagNumber(1)
  set epId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get badge => $_getSZ(1);
  @$pb.TagNumber(2)
  set badge($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBadge() => $_has(1);
  @$pb.TagNumber(2)
  void clearBadge() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get badgeType => $_getIZ(2);
  @$pb.TagNumber(3)
  set badgeType($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBadgeType() => $_has(2);
  @$pb.TagNumber(3)
  void clearBadgeType() => $_clearField(3);

  @$pb.TagNumber(4)
  BadgeInfo get badgeInfo => $_getN(3);
  @$pb.TagNumber(4)
  set badgeInfo(BadgeInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBadgeInfo() => $_has(3);
  @$pb.TagNumber(4)
  void clearBadgeInfo() => $_clearField(4);
  @$pb.TagNumber(4)
  BadgeInfo ensureBadgeInfo() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get duration => $_getIZ(4);
  @$pb.TagNumber(5)
  set duration($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDuration() => $_has(4);
  @$pb.TagNumber(5)
  void clearDuration() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get status => $_getIZ(5);
  @$pb.TagNumber(6)
  set status($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get cover => $_getSZ(6);
  @$pb.TagNumber(7)
  set cover($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCover() => $_has(6);
  @$pb.TagNumber(7)
  void clearCover() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get aid => $_getI64(7);
  @$pb.TagNumber(8)
  set aid($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAid() => $_has(7);
  @$pb.TagNumber(8)
  void clearAid() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get title => $_getSZ(8);
  @$pb.TagNumber(9)
  set title($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTitle() => $_has(8);
  @$pb.TagNumber(9)
  void clearTitle() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get movieTitle => $_getSZ(9);
  @$pb.TagNumber(10)
  set movieTitle($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMovieTitle() => $_has(9);
  @$pb.TagNumber(10)
  void clearMovieTitle() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get subtitle => $_getSZ(10);
  @$pb.TagNumber(11)
  set subtitle($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSubtitle() => $_has(10);
  @$pb.TagNumber(11)
  void clearSubtitle() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get longTitle => $_getSZ(11);
  @$pb.TagNumber(12)
  set longTitle($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasLongTitle() => $_has(11);
  @$pb.TagNumber(12)
  void clearLongTitle() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get toastTitle => $_getSZ(12);
  @$pb.TagNumber(13)
  set toastTitle($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasToastTitle() => $_has(12);
  @$pb.TagNumber(13)
  void clearToastTitle() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get cid => $_getI64(13);
  @$pb.TagNumber(14)
  set cid($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasCid() => $_has(13);
  @$pb.TagNumber(14)
  void clearCid() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get from => $_getSZ(14);
  @$pb.TagNumber(15)
  set from($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasFrom() => $_has(14);
  @$pb.TagNumber(15)
  void clearFrom() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get shareUrl => $_getSZ(15);
  @$pb.TagNumber(16)
  set shareUrl($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasShareUrl() => $_has(15);
  @$pb.TagNumber(16)
  void clearShareUrl() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get shareCopy => $_getSZ(16);
  @$pb.TagNumber(17)
  set shareCopy($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasShareCopy() => $_has(16);
  @$pb.TagNumber(17)
  void clearShareCopy() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get shortLink => $_getSZ(17);
  @$pb.TagNumber(18)
  set shortLink($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasShortLink() => $_has(17);
  @$pb.TagNumber(18)
  void clearShortLink() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get vid => $_getSZ(18);
  @$pb.TagNumber(19)
  set vid($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasVid() => $_has(18);
  @$pb.TagNumber(19)
  void clearVid() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.String get releaseDate => $_getSZ(19);
  @$pb.TagNumber(20)
  set releaseDate($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasReleaseDate() => $_has(19);
  @$pb.TagNumber(20)
  void clearReleaseDate() => $_clearField(20);

  @$pb.TagNumber(21)
  Dimension get dimension => $_getN(20);
  @$pb.TagNumber(21)
  set dimension(Dimension value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasDimension() => $_has(20);
  @$pb.TagNumber(21)
  void clearDimension() => $_clearField(21);
  @$pb.TagNumber(21)
  Dimension ensureDimension() => $_ensure(20);

  @$pb.TagNumber(22)
  Rights get rights => $_getN(21);
  @$pb.TagNumber(22)
  set rights(Rights value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasRights() => $_has(21);
  @$pb.TagNumber(22)
  void clearRights() => $_clearField(22);
  @$pb.TagNumber(22)
  Rights ensureRights() => $_ensure(21);

  @$pb.TagNumber(23)
  Interaction get interaction => $_getN(22);
  @$pb.TagNumber(23)
  set interaction(Interaction value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasInteraction() => $_has(22);
  @$pb.TagNumber(23)
  void clearInteraction() => $_clearField(23);
  @$pb.TagNumber(23)
  Interaction ensureInteraction() => $_ensure(22);

  @$pb.TagNumber(24)
  $core.String get bvid => $_getSZ(23);
  @$pb.TagNumber(24)
  set bvid($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasBvid() => $_has(23);
  @$pb.TagNumber(24)
  void clearBvid() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.int get archiveAttr => $_getIZ(24);
  @$pb.TagNumber(25)
  set archiveAttr($core.int value) => $_setSignedInt32(24, value);
  @$pb.TagNumber(25)
  $core.bool hasArchiveAttr() => $_has(24);
  @$pb.TagNumber(25)
  void clearArchiveAttr() => $_clearField(25);

  @$pb.TagNumber(26)
  $core.String get link => $_getSZ(25);
  @$pb.TagNumber(26)
  set link($core.String value) => $_setString(25, value);
  @$pb.TagNumber(26)
  $core.bool hasLink() => $_has(25);
  @$pb.TagNumber(26)
  void clearLink() => $_clearField(26);

  @$pb.TagNumber(27)
  $core.String get linkType => $_getSZ(26);
  @$pb.TagNumber(27)
  set linkType($core.String value) => $_setString(26, value);
  @$pb.TagNumber(27)
  $core.bool hasLinkType() => $_has(26);
  @$pb.TagNumber(27)
  void clearLinkType() => $_clearField(27);

  @$pb.TagNumber(28)
  $core.String get bmid => $_getSZ(27);
  @$pb.TagNumber(28)
  set bmid($core.String value) => $_setString(27, value);
  @$pb.TagNumber(28)
  $core.bool hasBmid() => $_has(27);
  @$pb.TagNumber(28)
  void clearBmid() => $_clearField(28);

  @$pb.TagNumber(29)
  $fixnum.Int64 get pubTime => $_getI64(28);
  @$pb.TagNumber(29)
  set pubTime($fixnum.Int64 value) => $_setInt64(28, value);
  @$pb.TagNumber(29)
  $core.bool hasPubTime() => $_has(28);
  @$pb.TagNumber(29)
  void clearPubTime() => $_clearField(29);

  @$pb.TagNumber(30)
  $core.int get pv => $_getIZ(29);
  @$pb.TagNumber(30)
  set pv($core.int value) => $_setSignedInt32(29, value);
  @$pb.TagNumber(30)
  $core.bool hasPv() => $_has(29);
  @$pb.TagNumber(30)
  void clearPv() => $_clearField(30);

  @$pb.TagNumber(31)
  $core.int get epIndex => $_getIZ(30);
  @$pb.TagNumber(31)
  set epIndex($core.int value) => $_setSignedInt32(30, value);
  @$pb.TagNumber(31)
  $core.bool hasEpIndex() => $_has(30);
  @$pb.TagNumber(31)
  void clearEpIndex() => $_clearField(31);

  @$pb.TagNumber(32)
  $core.int get sectionIndex => $_getIZ(31);
  @$pb.TagNumber(32)
  set sectionIndex($core.int value) => $_setSignedInt32(31, value);
  @$pb.TagNumber(32)
  $core.bool hasSectionIndex() => $_has(31);
  @$pb.TagNumber(32)
  void clearSectionIndex() => $_clearField(32);

  @$pb.TagNumber(33)
  $pb.PbList<Staff> get upInfos => $_getList(32);

  @$pb.TagNumber(34)
  Staff get upInfo => $_getN(33);
  @$pb.TagNumber(34)
  set upInfo(Staff value) => $_setField(34, value);
  @$pb.TagNumber(34)
  $core.bool hasUpInfo() => $_has(33);
  @$pb.TagNumber(34)
  void clearUpInfo() => $_clearField(34);
  @$pb.TagNumber(34)
  Staff ensureUpInfo() => $_ensure(33);

  @$pb.TagNumber(35)
  $core.String get dialogType => $_getSZ(34);
  @$pb.TagNumber(35)
  set dialogType($core.String value) => $_setString(34, value);
  @$pb.TagNumber(35)
  $core.bool hasDialogType() => $_has(34);
  @$pb.TagNumber(35)
  void clearDialogType() => $_clearField(35);

  @$pb.TagNumber(36)
  $core.String get toastType => $_getSZ(35);
  @$pb.TagNumber(36)
  set toastType($core.String value) => $_setString(35, value);
  @$pb.TagNumber(36)
  $core.bool hasToastType() => $_has(35);
  @$pb.TagNumber(36)
  void clearToastType() => $_clearField(36);

  @$pb.TagNumber(37)
  $pb.PbList<MultiViewEp> get multiViewEps => $_getList(36);

  @$pb.TagNumber(38)
  $core.bool get isSubView => $_getBF(37);
  @$pb.TagNumber(38)
  set isSubView($core.bool value) => $_setBool(37, value);
  @$pb.TagNumber(38)
  $core.bool hasIsSubView() => $_has(37);
  @$pb.TagNumber(38)
  void clearIsSubView() => $_clearField(38);

  @$pb.TagNumber(39)
  $core.bool get isViewHide => $_getBF(38);
  @$pb.TagNumber(39)
  set isViewHide($core.bool value) => $_setBool(38, value);
  @$pb.TagNumber(39)
  $core.bool hasIsViewHide() => $_has(38);
  @$pb.TagNumber(39)
  void clearIsViewHide() => $_clearField(39);

  @$pb.TagNumber(40)
  $core.String get jumpLink => $_getSZ(39);
  @$pb.TagNumber(40)
  set jumpLink($core.String value) => $_setString(39, value);
  @$pb.TagNumber(40)
  $core.bool hasJumpLink() => $_has(39);
  @$pb.TagNumber(40)
  void clearJumpLink() => $_clearField(40);

  @$pb.TagNumber(41)
  Stat get statForUnity => $_getN(40);
  @$pb.TagNumber(41)
  set statForUnity(Stat value) => $_setField(41, value);
  @$pb.TagNumber(41)
  $core.bool hasStatForUnity() => $_has(40);
  @$pb.TagNumber(41)
  void clearStatForUnity() => $_clearField(41);
  @$pb.TagNumber(41)
  Stat ensureStatForUnity() => $_ensure(40);

  @$pb.TagNumber(42)
  $pb.PbMap<$core.String, $core.String> get report => $_getMap(41);

  @$pb.TagNumber(43)
  $core.int get sectionType => $_getIZ(42);
  @$pb.TagNumber(43)
  set sectionType($core.int value) => $_setSignedInt32(42, value);
  @$pb.TagNumber(43)
  $core.bool hasSectionType() => $_has(42);
  @$pb.TagNumber(43)
  void clearSectionType() => $_clearField(43);

  @$pb.TagNumber(44)
  $core.String get showTitle => $_getSZ(43);
  @$pb.TagNumber(44)
  set showTitle($core.String value) => $_setString(43, value);
  @$pb.TagNumber(44)
  $core.bool hasShowTitle() => $_has(43);
  @$pb.TagNumber(44)
  void clearShowTitle() => $_clearField(44);
}

class ViewMaterial extends $pb.GeneratedMessage {
  factory ViewMaterial({
    $fixnum.Int64? oid,
    $fixnum.Int64? mid,
    $core.String? title,
    $core.String? author,
    $core.String? jumpUrl,
  }) {
    final result = ViewMaterial._();
    if (oid != null) result.oid = oid;
    if (mid != null) result.mid = mid;
    if (title != null) result.title = title;
    if (author != null) result.author = author;
    if (jumpUrl != null) result.jumpUrl = jumpUrl;
    return result;
  }

  ViewMaterial._();

  factory ViewMaterial.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewMaterial()..mergeFromBuffer(data, registry);
  factory ViewMaterial.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ViewMaterial()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ViewMaterial',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: ViewMaterial.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'oid')
    ..aInt64(2, _omitFieldNames ? '' : 'mid')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'author')
    ..aOS(5, _omitFieldNames ? '' : 'jumpUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewMaterial clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ViewMaterial copyWith(void Function(ViewMaterial) updates) =>
      super.copyWith((message) => updates(message as ViewMaterial))
          as ViewMaterial;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ViewMaterial() / ViewMaterial.new instead')
  static ViewMaterial create() => ViewMaterial._();
  static $pb.GeneratedMessage $_createMessage() => ViewMaterial._();
  @$core.override
  ViewMaterial createEmptyInstance() => ViewMaterial._();
  @$core.pragma('dart2js:noInline')
  static ViewMaterial getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ViewMaterial>(
          ViewMaterial.$_createMessage);
  static ViewMaterial? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get oid => $_getI64(0);
  @$pb.TagNumber(1)
  set oid($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOid() => $_has(0);
  @$pb.TagNumber(1)
  void clearOid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get mid => $_getI64(1);
  @$pb.TagNumber(2)
  set mid($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMid() => $_has(1);
  @$pb.TagNumber(2)
  void clearMid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get author => $_getSZ(3);
  @$pb.TagNumber(4)
  set author($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAuthor() => $_has(3);
  @$pb.TagNumber(4)
  void clearAuthor() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get jumpUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set jumpUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasJumpUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearJumpUrl() => $_clearField(5);
}

class Vip extends $pb.GeneratedMessage {
  factory Vip({
    $core.int? type,
    $core.int? vipStatus,
    $core.int? themeType,
    VipLabel? label,
    $core.int? isVip,
  }) {
    final result = Vip._();
    if (type != null) result.type = type;
    if (vipStatus != null) result.vipStatus = vipStatus;
    if (themeType != null) result.themeType = themeType;
    if (label != null) result.label = label;
    if (isVip != null) result.isVip = isVip;
    return result;
  }

  Vip._();

  factory Vip.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Vip()..mergeFromBuffer(data, registry);
  factory Vip.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Vip()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Vip',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: Vip.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'type')
    ..aI(2, _omitFieldNames ? '' : 'vipStatus')
    ..aI(3, _omitFieldNames ? '' : 'themeType')
    ..aOM<VipLabel>(4, _omitFieldNames ? '' : 'label',
        subBuilder: VipLabel.$_createMessage)
    ..aI(5, _omitFieldNames ? '' : 'isVip')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Vip clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Vip copyWith(void Function(Vip) updates) =>
      super.copyWith((message) => updates(message as Vip)) as Vip;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Vip() / Vip.new instead')
  static Vip create() => Vip._();
  static $pb.GeneratedMessage $_createMessage() => Vip._();
  @$core.override
  Vip createEmptyInstance() => Vip._();
  @$core.pragma('dart2js:noInline')
  static Vip getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Vip>(Vip.$_createMessage);
  static Vip? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get vipStatus => $_getIZ(1);
  @$pb.TagNumber(2)
  set vipStatus($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVipStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearVipStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get themeType => $_getIZ(2);
  @$pb.TagNumber(3)
  set themeType($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThemeType() => $_has(2);
  @$pb.TagNumber(3)
  void clearThemeType() => $_clearField(3);

  @$pb.TagNumber(4)
  VipLabel get label => $_getN(3);
  @$pb.TagNumber(4)
  set label(VipLabel value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLabel() => $_has(3);
  @$pb.TagNumber(4)
  void clearLabel() => $_clearField(4);
  @$pb.TagNumber(4)
  VipLabel ensureLabel() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get isVip => $_getIZ(4);
  @$pb.TagNumber(5)
  set isVip($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsVip() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsVip() => $_clearField(5);
}

class VipLabel extends $pb.GeneratedMessage {
  factory VipLabel({
    $core.String? path,
    $core.String? text,
    $core.String? labelTheme,
  }) {
    final result = VipLabel._();
    if (path != null) result.path = path;
    if (text != null) result.text = text;
    if (labelTheme != null) result.labelTheme = labelTheme;
    return result;
  }

  VipLabel._();

  factory VipLabel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VipLabel()..mergeFromBuffer(data, registry);
  factory VipLabel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VipLabel()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VipLabel',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: VipLabel.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'labelTheme')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VipLabel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VipLabel copyWith(void Function(VipLabel) updates) =>
      super.copyWith((message) => updates(message as VipLabel)) as VipLabel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use VipLabel() / VipLabel.new instead')
  static VipLabel create() => VipLabel._();
  static $pb.GeneratedMessage $_createMessage() => VipLabel._();
  @$core.override
  VipLabel createEmptyInstance() => VipLabel._();
  @$core.pragma('dart2js:noInline')
  static VipLabel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VipLabel>(VipLabel.$_createMessage);
  static VipLabel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get labelTheme => $_getSZ(2);
  @$pb.TagNumber(3)
  set labelTheme($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLabelTheme() => $_has(2);
  @$pb.TagNumber(3)
  void clearLabelTheme() => $_clearField(3);
}

class WikiInfo extends $pb.GeneratedMessage {
  factory WikiInfo({
    $core.String? wikiLabel,
    $core.String? wikiUrl,
  }) {
    final result = WikiInfo._();
    if (wikiLabel != null) result.wikiLabel = wikiLabel;
    if (wikiUrl != null) result.wikiUrl = wikiUrl;
    return result;
  }

  WikiInfo._();

  factory WikiInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WikiInfo()..mergeFromBuffer(data, registry);
  factory WikiInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WikiInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WikiInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: WikiInfo.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'wikiLabel')
    ..aOS(2, _omitFieldNames ? '' : 'wikiUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WikiInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WikiInfo copyWith(void Function(WikiInfo) updates) =>
      super.copyWith((message) => updates(message as WikiInfo)) as WikiInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use WikiInfo() / WikiInfo.new instead')
  static WikiInfo create() => WikiInfo._();
  static $pb.GeneratedMessage $_createMessage() => WikiInfo._();
  @$core.override
  WikiInfo createEmptyInstance() => WikiInfo._();
  @$core.pragma('dart2js:noInline')
  static WikiInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WikiInfo>(WikiInfo.$_createMessage);
  static WikiInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get wikiLabel => $_getSZ(0);
  @$pb.TagNumber(1)
  set wikiLabel($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWikiLabel() => $_has(0);
  @$pb.TagNumber(1)
  void clearWikiLabel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get wikiUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set wikiUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWikiUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearWikiUrl() => $_clearField(2);
}

class WinShowCondition extends $pb.GeneratedMessage {
  factory WinShowCondition({
    $core.String? type,
    $core.String? value,
  }) {
    final result = WinShowCondition._();
    if (type != null) result.type = type;
    if (value != null) result.value = value;
    return result;
  }

  WinShowCondition._();

  factory WinShowCondition.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WinShowCondition()..mergeFromBuffer(data, registry);
  factory WinShowCondition.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WinShowCondition()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WinShowCondition',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.viewunite.common'),
      createEmptyInstance: WinShowCondition.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WinShowCondition clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WinShowCondition copyWith(void Function(WinShowCondition) updates) =>
      super.copyWith((message) => updates(message as WinShowCondition))
          as WinShowCondition;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use WinShowCondition() / WinShowCondition.new instead')
  static WinShowCondition create() => WinShowCondition._();
  static $pb.GeneratedMessage $_createMessage() => WinShowCondition._();
  @$core.override
  WinShowCondition createEmptyInstance() => WinShowCondition._();
  @$core.pragma('dart2js:noInline')
  static WinShowCondition getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WinShowCondition>(
          WinShowCondition.$_createMessage);
  static WinShowCondition? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
