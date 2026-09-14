// This is a generated file - do not edit.
//
// Generated from bilibili/app/dynamic/common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'common.pbenum.dart';

class ItemWHRatio extends $pb.GeneratedMessage {
  factory ItemWHRatio({
    WHRatio? ratio,
    $core.int? width,
    $core.int? height,
  }) {
    final result = ItemWHRatio._();
    if (ratio != null) result.ratio = ratio;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    return result;
  }

  ItemWHRatio._();

  factory ItemWHRatio.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ItemWHRatio()..mergeFromBuffer(data, registry);
  factory ItemWHRatio.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ItemWHRatio()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ItemWHRatio',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'bilibili.app.dynamic.common'),
      createEmptyInstance: ItemWHRatio.$_createMessage)
    ..aE<WHRatio>(1, _omitFieldNames ? '' : 'ratio', enumValues: WHRatio.values)
    ..aI(2, _omitFieldNames ? '' : 'width')
    ..aI(3, _omitFieldNames ? '' : 'height')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ItemWHRatio clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ItemWHRatio copyWith(void Function(ItemWHRatio) updates) =>
      super.copyWith((message) => updates(message as ItemWHRatio))
          as ItemWHRatio;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ItemWHRatio() / ItemWHRatio.new instead')
  static ItemWHRatio create() => ItemWHRatio._();
  static $pb.GeneratedMessage $_createMessage() => ItemWHRatio._();
  @$core.override
  ItemWHRatio createEmptyInstance() => ItemWHRatio._();
  @$core.pragma('dart2js:noInline')
  static ItemWHRatio getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ItemWHRatio>(
          ItemWHRatio.$_createMessage);
  static ItemWHRatio? _defaultInstance;

  @$pb.TagNumber(1)
  WHRatio get ratio => $_getN(0);
  @$pb.TagNumber(1)
  set ratio(WHRatio value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRatio() => $_has(0);
  @$pb.TagNumber(1)
  void clearRatio() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get width => $_getIZ(1);
  @$pb.TagNumber(2)
  set width($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWidth() => $_has(1);
  @$pb.TagNumber(2)
  void clearWidth() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get height => $_getIZ(2);
  @$pb.TagNumber(3)
  set height($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearHeight() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
