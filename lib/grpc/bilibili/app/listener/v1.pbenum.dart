// This is a generated file - do not edit.
//
// Generated from bilibili/app/listener/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class CardModuleType extends $pb.ProtobufEnum {
  static const CardModuleType Module_invalid =
      CardModuleType._(0, _omitEnumNames ? '' : 'Module_invalid');
  static const CardModuleType Module_header =
      CardModuleType._(1, _omitEnumNames ? '' : 'Module_header');
  static const CardModuleType Module_archive =
      CardModuleType._(2, _omitEnumNames ? '' : 'Module_archive');
  static const CardModuleType Module_cbtn =
      CardModuleType._(3, _omitEnumNames ? '' : 'Module_cbtn');

  static const $core.List<CardModuleType> values = <CardModuleType>[
    Module_invalid,
    Module_header,
    Module_archive,
    Module_cbtn,
  ];

  static final $core.List<CardModuleType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static CardModuleType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CardModuleType._(super.value, super.name);
}

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

class TopCardType extends $pb.ProtobufEnum {
  static const TopCardType UNSPECIFIED_TopCardType =
      TopCardType._(0, _omitEnumNames ? '' : 'UNSPECIFIED_TopCardType');
  static const TopCardType LISTEN_HISTORY =
      TopCardType._(1, _omitEnumNames ? '' : 'LISTEN_HISTORY');
  static const TopCardType FAVORITE_FOLDER =
      TopCardType._(2, _omitEnumNames ? '' : 'FAVORITE_FOLDER');
  static const TopCardType UP_RECALL =
      TopCardType._(3, _omitEnumNames ? '' : 'UP_RECALL');
  static const TopCardType PICK_TODAY =
      TopCardType._(4, _omitEnumNames ? '' : 'PICK_TODAY');

  static const $core.List<TopCardType> values = <TopCardType>[
    UNSPECIFIED_TopCardType,
    LISTEN_HISTORY,
    FAVORITE_FOLDER,
    UP_RECALL,
    PICK_TODAY,
  ];

  static final $core.List<TopCardType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static TopCardType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TopCardType._(super.value, super.name);
}

class ClickReq_ClickAction extends $pb.ProtobufEnum {
  static const ClickReq_ClickAction INVALID =
      ClickReq_ClickAction._(0, _omitEnumNames ? '' : 'INVALID');
  static const ClickReq_ClickAction SHARE =
      ClickReq_ClickAction._(1, _omitEnumNames ? '' : 'SHARE');

  static const $core.List<ClickReq_ClickAction> values = <ClickReq_ClickAction>[
    INVALID,
    SHARE,
  ];

  static final $core.List<ClickReq_ClickAction?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static ClickReq_ClickAction? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ClickReq_ClickAction._(super.value, super.name);
}

class EventReq_EventType extends $pb.ProtobufEnum {
  static const EventReq_EventType INVALID_EventType =
      EventReq_EventType._(0, _omitEnumNames ? '' : 'INVALID_EventType');
  static const EventReq_EventType GUIDE_BAR_SHOW =
      EventReq_EventType._(1, _omitEnumNames ? '' : 'GUIDE_BAR_SHOW');

  static const $core.List<EventReq_EventType> values = <EventReq_EventType>[
    INVALID_EventType,
    GUIDE_BAR_SHOW,
  ];

  static final $core.List<EventReq_EventType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static EventReq_EventType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EventReq_EventType._(super.value, super.name);
}

class FavFolderAction_Action extends $pb.ProtobufEnum {
  static const FavFolderAction_Action UNSPECIFIED =
      FavFolderAction_Action._(0, _omitEnumNames ? '' : 'UNSPECIFIED');
  static const FavFolderAction_Action ADD =
      FavFolderAction_Action._(1, _omitEnumNames ? '' : 'ADD');
  static const FavFolderAction_Action DEL =
      FavFolderAction_Action._(2, _omitEnumNames ? '' : 'DEL');

  static const $core.List<FavFolderAction_Action> values =
      <FavFolderAction_Action>[
    UNSPECIFIED,
    ADD,
    DEL,
  ];

  static final $core.List<FavFolderAction_Action?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static FavFolderAction_Action? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FavFolderAction_Action._(super.value, super.name);
}

class FollowRelation_RelationStatus extends $pb.ProtobufEnum {
  static const FollowRelation_RelationStatus UNSPECIFIED_RelationStatus =
      FollowRelation_RelationStatus._(
          0, _omitEnumNames ? '' : 'UNSPECIFIED_RelationStatus');
  static const FollowRelation_RelationStatus NO_FOLLOW =
      FollowRelation_RelationStatus._(1, _omitEnumNames ? '' : 'NO_FOLLOW');
  static const FollowRelation_RelationStatus FOLLOWING =
      FollowRelation_RelationStatus._(2, _omitEnumNames ? '' : 'FOLLOWING');
  static const FollowRelation_RelationStatus FOLLOWED =
      FollowRelation_RelationStatus._(3, _omitEnumNames ? '' : 'FOLLOWED');
  static const FollowRelation_RelationStatus MUTUAL_FOLLOWING =
      FollowRelation_RelationStatus._(
          4, _omitEnumNames ? '' : 'MUTUAL_FOLLOWING');
  static const FollowRelation_RelationStatus SPECIAL_FOLLOWING =
      FollowRelation_RelationStatus._(
          5, _omitEnumNames ? '' : 'SPECIAL_FOLLOWING');

  static const $core.List<FollowRelation_RelationStatus> values =
      <FollowRelation_RelationStatus>[
    UNSPECIFIED_RelationStatus,
    NO_FOLLOW,
    FOLLOWING,
    FOLLOWED,
    MUTUAL_FOLLOWING,
    SPECIAL_FOLLOWING,
  ];

  static final $core.List<FollowRelation_RelationStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static FollowRelation_RelationStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FollowRelation_RelationStatus._(super.value, super.name);
}

class MenuSubscribeReq_SubscribeAction extends $pb.ProtobufEnum {
  static const MenuSubscribeReq_SubscribeAction INVALID_SubscribeAction =
      MenuSubscribeReq_SubscribeAction._(
          0, _omitEnumNames ? '' : 'INVALID_SubscribeAction');
  static const MenuSubscribeReq_SubscribeAction ADD_SubscribeAction =
      MenuSubscribeReq_SubscribeAction._(
          1, _omitEnumNames ? '' : 'ADD_SubscribeAction');
  static const MenuSubscribeReq_SubscribeAction DEL_SubscribeAction =
      MenuSubscribeReq_SubscribeAction._(
          2, _omitEnumNames ? '' : 'DEL_SubscribeAction');

  static const $core.List<MenuSubscribeReq_SubscribeAction> values =
      <MenuSubscribeReq_SubscribeAction>[
    INVALID_SubscribeAction,
    ADD_SubscribeAction,
    DEL_SubscribeAction,
  ];

  static final $core.List<MenuSubscribeReq_SubscribeAction?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static MenuSubscribeReq_SubscribeAction? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MenuSubscribeReq_SubscribeAction._(super.value, super.name);
}

class PageOption_Direction extends $pb.ProtobufEnum {
  static const PageOption_Direction SCROLL_DOWN =
      PageOption_Direction._(0, _omitEnumNames ? '' : 'SCROLL_DOWN');
  static const PageOption_Direction SCROLL_UP =
      PageOption_Direction._(1, _omitEnumNames ? '' : 'SCROLL_UP');

  static const $core.List<PageOption_Direction> values = <PageOption_Direction>[
    SCROLL_DOWN,
    SCROLL_UP,
  ];

  static final $core.List<PageOption_Direction?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static PageOption_Direction? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PageOption_Direction._(super.value, super.name);
}

class PlaylistOffset_PlaylistScrollDirection extends $pb.ProtobufEnum {
  static const PlaylistOffset_PlaylistScrollDirection DOWN =
      PlaylistOffset_PlaylistScrollDirection._(0, _omitEnumNames ? '' : 'DOWN');
  static const PlaylistOffset_PlaylistScrollDirection UP =
      PlaylistOffset_PlaylistScrollDirection._(1, _omitEnumNames ? '' : 'UP');

  static const $core.List<PlaylistOffset_PlaylistScrollDirection> values =
      <PlaylistOffset_PlaylistScrollDirection>[
    DOWN,
    UP,
  ];

  static final $core.List<PlaylistOffset_PlaylistScrollDirection?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static PlaylistOffset_PlaylistScrollDirection? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlaylistOffset_PlaylistScrollDirection._(super.value, super.name);
}

class RcmdPlaylistReq_RcmdFrom extends $pb.ProtobufEnum {
  static const RcmdPlaylistReq_RcmdFrom UNSPECIFIED_RcmdFrom =
      RcmdPlaylistReq_RcmdFrom._(
          0, _omitEnumNames ? '' : 'UNSPECIFIED_RcmdFrom');
  static const RcmdPlaylistReq_RcmdFrom UP_ARCHIVE_RcmdFrom =
      RcmdPlaylistReq_RcmdFrom._(
          1, _omitEnumNames ? '' : 'UP_ARCHIVE_RcmdFrom');
  static const RcmdPlaylistReq_RcmdFrom INDEX_ENTRY =
      RcmdPlaylistReq_RcmdFrom._(2, _omitEnumNames ? '' : 'INDEX_ENTRY');
  static const RcmdPlaylistReq_RcmdFrom ARCHIVE_VIEW =
      RcmdPlaylistReq_RcmdFrom._(3, _omitEnumNames ? '' : 'ARCHIVE_VIEW');

  static const $core.List<RcmdPlaylistReq_RcmdFrom> values =
      <RcmdPlaylistReq_RcmdFrom>[
    UNSPECIFIED_RcmdFrom,
    UP_ARCHIVE_RcmdFrom,
    INDEX_ENTRY,
    ARCHIVE_VIEW,
  ];

  static final $core.List<RcmdPlaylistReq_RcmdFrom?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static RcmdPlaylistReq_RcmdFrom? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RcmdPlaylistReq_RcmdFrom._(super.value, super.name);
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

class TopCard_PlayStrategy extends $pb.ProtobufEnum {
  static const TopCard_PlayStrategy NO_INTERRUPT =
      TopCard_PlayStrategy._(0, _omitEnumNames ? '' : 'NO_INTERRUPT');
  static const TopCard_PlayStrategy PLAY_TARGET =
      TopCard_PlayStrategy._(1, _omitEnumNames ? '' : 'PLAY_TARGET');
  static const TopCard_PlayStrategy PLAY_FIRST =
      TopCard_PlayStrategy._(2, _omitEnumNames ? '' : 'PLAY_FIRST');

  static const $core.List<TopCard_PlayStrategy> values = <TopCard_PlayStrategy>[
    NO_INTERRUPT,
    PLAY_TARGET,
    PLAY_FIRST,
  ];

  static final $core.List<TopCard_PlayStrategy?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static TopCard_PlayStrategy? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TopCard_PlayStrategy._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
