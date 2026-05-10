// This is a generated file - do not edit.
//
// Generated from bilibili/app/listener/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ListOrder extends $pb.ProtobufEnum {
  static const ListOrder NO_ORDER =
      ListOrder._(0, _omitEnumNames ? '' : 'NO_ORDER');
  static const ListOrder ORDER_NORMAL =
      ListOrder._(1, _omitEnumNames ? '' : 'ORDER_NORMAL');
  static const ListOrder ORDER_REVERSE =
      ListOrder._(2, _omitEnumNames ? '' : 'ORDER_REVERSE');
  static const ListOrder ORDER_RANDOM =
      ListOrder._(3, _omitEnumNames ? '' : 'ORDER_RANDOM');

  static const $core.List<ListOrder> values = <ListOrder>[
    NO_ORDER,
    ORDER_NORMAL,
    ORDER_REVERSE,
    ORDER_RANDOM,
  ];

  static final $core.List<ListOrder?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ListOrder? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ListOrder._(super.value, super.name);
}

class ListSortField extends $pb.ProtobufEnum {
  static const ListSortField NO_SORT =
      ListSortField._(0, _omitEnumNames ? '' : 'NO_SORT');
  static const ListSortField SORT_CTIME =
      ListSortField._(1, _omitEnumNames ? '' : 'SORT_CTIME');
  static const ListSortField SORT_VIEWCNT =
      ListSortField._(2, _omitEnumNames ? '' : 'SORT_VIEWCNT');
  static const ListSortField SORT_FAVCNT =
      ListSortField._(3, _omitEnumNames ? '' : 'SORT_FAVCNT');

  static const $core.List<ListSortField> values = <ListSortField>[
    NO_SORT,
    SORT_CTIME,
    SORT_VIEWCNT,
    SORT_FAVCNT,
  ];

  static final $core.List<ListSortField?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ListSortField? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ListSortField._(super.value, super.name);
}

class PlaylistSource extends $pb.ProtobufEnum {
  static const PlaylistSource DEFAULT =
      PlaylistSource._(0, _omitEnumNames ? '' : 'DEFAULT');
  static const PlaylistSource MEM_SPACE =
      PlaylistSource._(1, _omitEnumNames ? '' : 'MEM_SPACE');
  static const PlaylistSource AUDIO_COLLECTION =
      PlaylistSource._(2, _omitEnumNames ? '' : 'AUDIO_COLLECTION');
  static const PlaylistSource AUDIO_CARD =
      PlaylistSource._(3, _omitEnumNames ? '' : 'AUDIO_CARD');
  static const PlaylistSource USER_FAVOURITE =
      PlaylistSource._(4, _omitEnumNames ? '' : 'USER_FAVOURITE');
  static const PlaylistSource UP_ARCHIVE =
      PlaylistSource._(5, _omitEnumNames ? '' : 'UP_ARCHIVE');
  static const PlaylistSource AUDIO_CACHE =
      PlaylistSource._(6, _omitEnumNames ? '' : 'AUDIO_CACHE');
  static const PlaylistSource PICK_CARD =
      PlaylistSource._(7, _omitEnumNames ? '' : 'PICK_CARD');
  static const PlaylistSource MEDIA_LIST =
      PlaylistSource._(8, _omitEnumNames ? '' : 'MEDIA_LIST');

  static const $core.List<PlaylistSource> values = <PlaylistSource>[
    DEFAULT,
    MEM_SPACE,
    AUDIO_COLLECTION,
    AUDIO_CARD,
    USER_FAVOURITE,
    UP_ARCHIVE,
    AUDIO_CACHE,
    PICK_CARD,
    MEDIA_LIST,
  ];

  static final $core.List<PlaylistSource?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 8);
  static PlaylistSource? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaylistSource._(super.value, super.name);
}

class ThumbUpReq_ThumbType extends $pb.ProtobufEnum {
  static const ThumbUpReq_ThumbType LIKE =
      ThumbUpReq_ThumbType._(0, _omitEnumNames ? '' : 'LIKE');
  static const ThumbUpReq_ThumbType CANCEL_LIKE =
      ThumbUpReq_ThumbType._(1, _omitEnumNames ? '' : 'CANCEL_LIKE');
  static const ThumbUpReq_ThumbType DISLIKE =
      ThumbUpReq_ThumbType._(2, _omitEnumNames ? '' : 'DISLIKE');
  static const ThumbUpReq_ThumbType CANCEL_DISLIKE =
      ThumbUpReq_ThumbType._(3, _omitEnumNames ? '' : 'CANCEL_DISLIKE');

  static const $core.List<ThumbUpReq_ThumbType> values = <ThumbUpReq_ThumbType>[
    LIKE,
    CANCEL_LIKE,
    DISLIKE,
    CANCEL_DISLIKE,
  ];

  static final $core.List<ThumbUpReq_ThumbType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ThumbUpReq_ThumbType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ThumbUpReq_ThumbType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
