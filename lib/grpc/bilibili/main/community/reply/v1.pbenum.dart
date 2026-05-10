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

import 'package:protobuf/protobuf.dart' as $pb;

class DetailListScene extends $pb.ProtobufEnum {
  static const DetailListScene REPLY =
      DetailListScene._(0, _omitEnumNames ? '' : 'REPLY');
  static const DetailListScene MSG_FEED =
      DetailListScene._(1, _omitEnumNames ? '' : 'MSG_FEED');
  static const DetailListScene NOTIFY =
      DetailListScene._(2, _omitEnumNames ? '' : 'NOTIFY');

  static const $core.List<DetailListScene> values = <DetailListScene>[
    REPLY,
    MSG_FEED,
    NOTIFY,
  ];

  static final $core.List<DetailListScene?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static DetailListScene? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DetailListScene._(super.value, super.name);
}

class Mode extends $pb.ProtobufEnum {
  static const Mode DEFAULT_Mode =
      Mode._(0, _omitEnumNames ? '' : 'DEFAULT_Mode');

  /// @Deprecated
  static const Mode UNSPECIFIED =
      Mode._(1, _omitEnumNames ? '' : 'UNSPECIFIED');
  static const Mode MAIN_LIST_TIME =
      Mode._(2, _omitEnumNames ? '' : 'MAIN_LIST_TIME');
  static const Mode MAIN_LIST_HOT =
      Mode._(3, _omitEnumNames ? '' : 'MAIN_LIST_HOT');

  static const $core.List<Mode> values = <Mode>[
    DEFAULT_Mode,
    UNSPECIFIED,
    MAIN_LIST_TIME,
    MAIN_LIST_HOT,
  ];

  static final $core.List<Mode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Mode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Mode._(super.value, super.name);
}

class SearchItemType extends $pb.ProtobufEnum {
  static const SearchItemType DEFAULT_ITEM_TYPE =
      SearchItemType._(0, _omitEnumNames ? '' : 'DEFAULT_ITEM_TYPE');
  static const SearchItemType GOODS =
      SearchItemType._(1, _omitEnumNames ? '' : 'GOODS');
  static const SearchItemType VIDEO =
      SearchItemType._(2, _omitEnumNames ? '' : 'VIDEO');
  static const SearchItemType ARTICLE =
      SearchItemType._(3, _omitEnumNames ? '' : 'ARTICLE');

  static const $core.List<SearchItemType> values = <SearchItemType>[
    DEFAULT_ITEM_TYPE,
    GOODS,
    VIDEO,
    ARTICLE,
  ];

  static final $core.List<SearchItemType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static SearchItemType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SearchItemType._(super.value, super.name);
}

class SearchItemVideoSubType extends $pb.ProtobufEnum {
  static const SearchItemVideoSubType UGC =
      SearchItemVideoSubType._(0, _omitEnumNames ? '' : 'UGC');
  static const SearchItemVideoSubType PGC =
      SearchItemVideoSubType._(1, _omitEnumNames ? '' : 'PGC');

  static const $core.List<SearchItemVideoSubType> values =
      <SearchItemVideoSubType>[
    UGC,
    PGC,
  ];

  static final $core.List<SearchItemVideoSubType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static SearchItemVideoSubType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SearchItemVideoSubType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
