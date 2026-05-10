// This is a generated file - do not edit.
//
// Generated from bilibili/im/type.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class MsgType extends $pb.ProtobufEnum {
  static const MsgType EN_INVALID_MSG_TYPE =
      MsgType._(0, _omitEnumNames ? '' : 'EN_INVALID_MSG_TYPE');
  static const MsgType EN_MSG_TYPE_TEXT =
      MsgType._(1, _omitEnumNames ? '' : 'EN_MSG_TYPE_TEXT');
  static const MsgType EN_MSG_TYPE_PIC =
      MsgType._(2, _omitEnumNames ? '' : 'EN_MSG_TYPE_PIC');
  static const MsgType EN_MSG_TYPE_AUDIO =
      MsgType._(3, _omitEnumNames ? '' : 'EN_MSG_TYPE_AUDIO');
  static const MsgType EN_MSG_TYPE_SHARE =
      MsgType._(4, _omitEnumNames ? '' : 'EN_MSG_TYPE_SHARE');
  static const MsgType EN_MSG_TYPE_DRAW_BACK =
      MsgType._(5, _omitEnumNames ? '' : 'EN_MSG_TYPE_DRAW_BACK');
  static const MsgType EN_MSG_TYPE_CUSTOM_FACE =
      MsgType._(6, _omitEnumNames ? '' : 'EN_MSG_TYPE_CUSTOM_FACE');
  static const MsgType EN_MSG_TYPE_SHARE_V2 =
      MsgType._(7, _omitEnumNames ? '' : 'EN_MSG_TYPE_SHARE_V2');
  static const MsgType EN_MSG_TYPE_SYS_CANCEL =
      MsgType._(8, _omitEnumNames ? '' : 'EN_MSG_TYPE_SYS_CANCEL');
  static const MsgType EN_MSG_TYPE_MINI_PROGRAM =
      MsgType._(9, _omitEnumNames ? '' : 'EN_MSG_TYPE_MINI_PROGRAM');
  static const MsgType EN_MSG_TYPE_NOTIFY_MSG =
      MsgType._(10, _omitEnumNames ? '' : 'EN_MSG_TYPE_NOTIFY_MSG');
  static const MsgType EN_MSG_TYPE_VIDEO_CARD =
      MsgType._(11, _omitEnumNames ? '' : 'EN_MSG_TYPE_VIDEO_CARD');
  static const MsgType EN_MSG_TYPE_ARTICLE_CARD =
      MsgType._(12, _omitEnumNames ? '' : 'EN_MSG_TYPE_ARTICLE_CARD');
  static const MsgType EN_MSG_TYPE_PICTURE_CARD =
      MsgType._(13, _omitEnumNames ? '' : 'EN_MSG_TYPE_PICTURE_CARD');
  static const MsgType EN_MSG_TYPE_COMMON_SHARE_CARD =
      MsgType._(14, _omitEnumNames ? '' : 'EN_MSG_TYPE_COMMON_SHARE_CARD');
  static const MsgType EN_MSG_TYPE_TEXT_SHARE =
      MsgType._(15, _omitEnumNames ? '' : 'EN_MSG_TYPE_TEXT_SHARE');
  static const MsgType EN_MSG_TYPE_TIP_MESSAGE =
      MsgType._(18, _omitEnumNames ? '' : 'EN_MSG_TYPE_TIP_MESSAGE');
  static const MsgType EN_MSG_TYPE_GPT_MESSAGE =
      MsgType._(19, _omitEnumNames ? '' : 'EN_MSG_TYPE_GPT_MESSAGE');
  static const MsgType EN_MSG_TYPE_BIZ_MSG_TYPE =
      MsgType._(50, _omitEnumNames ? '' : 'EN_MSG_TYPE_BIZ_MSG_TYPE');
  static const MsgType EN_MSG_TYPE_MODIFY_MSG_TYPE =
      MsgType._(51, _omitEnumNames ? '' : 'EN_MSG_TYPE_MODIFY_MSG_TYPE');
  static const MsgType EN_MSG_TYPE_GROUP_MEMBER_CHANGED =
      MsgType._(101, _omitEnumNames ? '' : 'EN_MSG_TYPE_GROUP_MEMBER_CHANGED');
  static const MsgType EN_MSG_TYPE_GROUP_STATUS_CHANGED =
      MsgType._(102, _omitEnumNames ? '' : 'EN_MSG_TYPE_GROUP_STATUS_CHANGED');
  static const MsgType EN_MSG_TYPE_GROUP_DYNAMIC_CHANGED =
      MsgType._(103, _omitEnumNames ? '' : 'EN_MSG_TYPE_GROUP_DYNAMIC_CHANGED');
  static const MsgType EN_MSG_TYPE_GROUP_LIST_CHANGED =
      MsgType._(104, _omitEnumNames ? '' : 'EN_MSG_TYPE_GROUP_LIST_CHANGED');
  static const MsgType EM_MSG_TYPE_FRIEND_LIST_CHANGED =
      MsgType._(105, _omitEnumNames ? '' : 'EM_MSG_TYPE_FRIEND_LIST_CHANGED');
  static const MsgType EN_MSG_TYPE_GROUP_DETAIL_CHANGED =
      MsgType._(106, _omitEnumNames ? '' : 'EN_MSG_TYPE_GROUP_DETAIL_CHANGED');
  static const MsgType EN_MSG_TYPE_GROUP_MEMBER_ROLE_CHANGED = MsgType._(
      107, _omitEnumNames ? '' : 'EN_MSG_TYPE_GROUP_MEMBER_ROLE_CHANGED');
  static const MsgType EN_MSG_TYPE_NOTICE_WATCH_LIST =
      MsgType._(108, _omitEnumNames ? '' : 'EN_MSG_TYPE_NOTICE_WATCH_LIST');
  static const MsgType EN_MSG_TYPE_NOTIFY_NEW_REPLY_RECIEVED = MsgType._(
      109, _omitEnumNames ? '' : 'EN_MSG_TYPE_NOTIFY_NEW_REPLY_RECIEVED');
  static const MsgType EN_MSG_TYPE_NOTIFY_NEW_AT_RECIEVED = MsgType._(
      110, _omitEnumNames ? '' : 'EN_MSG_TYPE_NOTIFY_NEW_AT_RECIEVED');
  static const MsgType EN_MSG_TYPE_NOTIFY_NEW_PRAISE_RECIEVED = MsgType._(
      111, _omitEnumNames ? '' : 'EN_MSG_TYPE_NOTIFY_NEW_PRAISE_RECIEVED');
  static const MsgType EN_MSG_TYPE_NOTIFY_NEW_UP_RECIEVED = MsgType._(
      112, _omitEnumNames ? '' : 'EN_MSG_TYPE_NOTIFY_NEW_UP_RECIEVED');
  static const MsgType EN_MSG_TYPE_NOTIFY_NEW_REPLY_RECIEVED_V2 = MsgType._(
      113, _omitEnumNames ? '' : 'EN_MSG_TYPE_NOTIFY_NEW_REPLY_RECIEVED_V2');
  static const MsgType EN_MSG_TYPE_NOTIFY_NEW_AT_RECIEVED_V2 = MsgType._(
      114, _omitEnumNames ? '' : 'EN_MSG_TYPE_NOTIFY_NEW_AT_RECIEVED_V2');
  static const MsgType EN_MSG_TYPE_NOTIFY_NEW_PRAISE_RECIEVED_V2 = MsgType._(
      115, _omitEnumNames ? '' : 'EN_MSG_TYPE_NOTIFY_NEW_PRAISE_RECIEVED_V2');
  static const MsgType EN_MSG_TYPE_GROUP_DETAIL_CHANGED_MULTI = MsgType._(
      116, _omitEnumNames ? '' : 'EN_MSG_TYPE_GROUP_DETAIL_CHANGED_MULTI');
  static const MsgType EN_MSG_TYPE_GROUP_MEMBER_ROLE_CHANGED_MULTI = MsgType._(
      117, _omitEnumNames ? '' : 'EN_MSG_TYPE_GROUP_MEMBER_ROLE_CHANGED_MULTI');
  static const MsgType EN_MSG_TYPE_NOTIFY_ANTI_DISTURB =
      MsgType._(118, _omitEnumNames ? '' : 'EN_MSG_TYPE_NOTIFY_ANTI_DISTURB');
  static const MsgType EN_MSG_TYPE_SYS_GROUP_DISSOLVED =
      MsgType._(201, _omitEnumNames ? '' : 'EN_MSG_TYPE_SYS_GROUP_DISSOLVED');
  static const MsgType EN_MSG_TYPE_SYS_GROUP_JOINED =
      MsgType._(202, _omitEnumNames ? '' : 'EN_MSG_TYPE_SYS_GROUP_JOINED');
  static const MsgType EN_MSG_TYPE_SYS_GROUP_MEMBER_EXITED = MsgType._(
      203, _omitEnumNames ? '' : 'EN_MSG_TYPE_SYS_GROUP_MEMBER_EXITED');
  static const MsgType EN_MSG_TYPE_SYS_GROUP_ADMIN_FIRED =
      MsgType._(204, _omitEnumNames ? '' : 'EN_MSG_TYPE_SYS_GROUP_ADMIN_FIRED');
  static const MsgType EN_MSG_TYPE_SYS_GROUP_MEMBER_KICKED = MsgType._(
      205, _omitEnumNames ? '' : 'EN_MSG_TYPE_SYS_GROUP_MEMBER_KICKED');
  static const MsgType EN_MSG_TYPE_SYS_GROUP_ADMIN_KICK_OFF = MsgType._(
      206, _omitEnumNames ? '' : 'EN_MSG_TYPE_SYS_GROUP_ADMIN_KICK_OFF');
  static const MsgType EN_MSG_TYPE_SYS_GROUP_ADMIN_DUTY =
      MsgType._(207, _omitEnumNames ? '' : 'EN_MSG_TYPE_SYS_GROUP_ADMIN_DUTY');
  static const MsgType EN_MSG_TYPE_SYS_GROUP_AUTO_CREATED = MsgType._(
      208, _omitEnumNames ? '' : 'EN_MSG_TYPE_SYS_GROUP_AUTO_CREATED');
  static const MsgType EN_MSG_TYPE_SYS_FRIEND_APPLY =
      MsgType._(210, _omitEnumNames ? '' : 'EN_MSG_TYPE_SYS_FRIEND_APPLY');
  static const MsgType EN_MSG_TYPE_SYS_FRIEND_APPLY_ACK =
      MsgType._(211, _omitEnumNames ? '' : 'EN_MSG_TYPE_SYS_FRIEND_APPLY_ACK');
  static const MsgType EN_MSG_TYPE_SYS_GROUP_APPLY_FOR_JOINING = MsgType._(
      212, _omitEnumNames ? '' : 'EN_MSG_TYPE_SYS_GROUP_APPLY_FOR_JOINING');
  static const MsgType EN_MSG_TYPE_SYS_GROUP_ADMIN_ACCEPTED_USER_APPLY =
      MsgType._(
          213,
          _omitEnumNames
              ? ''
              : 'EN_MSG_TYPE_SYS_GROUP_ADMIN_ACCEPTED_USER_APPLY');
  static const MsgType EN_MSG_TYPE_CHAT_MEMBER_JOINED =
      MsgType._(301, _omitEnumNames ? '' : 'EN_MSG_TYPE_CHAT_MEMBER_JOINED');
  static const MsgType EN_MSG_TYPE_CHAT_MEMBER_EXITED =
      MsgType._(302, _omitEnumNames ? '' : 'EN_MSG_TYPE_CHAT_MEMBER_EXITED');
  static const MsgType EN_MSG_TYPE_CHAT_GROUP_FREEZED =
      MsgType._(303, _omitEnumNames ? '' : 'EN_MSG_TYPE_CHAT_GROUP_FREEZED');
  static const MsgType EN_MSG_TYPE_CHAT_GROUP_DISSOLVED =
      MsgType._(304, _omitEnumNames ? '' : 'EN_MSG_TYPE_CHAT_GROUP_DISSOLVED');
  static const MsgType EN_MSG_TYPE_CHAT_GROUP_CREATED =
      MsgType._(305, _omitEnumNames ? '' : 'EN_MSG_TYPE_CHAT_GROUP_CREATED');
  static const MsgType EN_MSG_TYPE_CHAT_POPUP_SESSION =
      MsgType._(306, _omitEnumNames ? '' : 'EN_MSG_TYPE_CHAT_POPUP_SESSION');
  static const MsgType EN_MSG_TYPE_CUSTOM_RANK_UPDATE =
      MsgType._(400, _omitEnumNames ? '' : 'EN_MSG_TYPE_CUSTOM_RANK_UPDATE');
  static const MsgType EN_MSG_TYPE_CUSTOM_MSG_NOTICE =
      MsgType._(401, _omitEnumNames ? '' : 'EN_MSG_TYPE_CUSTOM_MSG_NOTICE');

  static const $core.List<MsgType> values = <MsgType>[
    EN_INVALID_MSG_TYPE,
    EN_MSG_TYPE_TEXT,
    EN_MSG_TYPE_PIC,
    EN_MSG_TYPE_AUDIO,
    EN_MSG_TYPE_SHARE,
    EN_MSG_TYPE_DRAW_BACK,
    EN_MSG_TYPE_CUSTOM_FACE,
    EN_MSG_TYPE_SHARE_V2,
    EN_MSG_TYPE_SYS_CANCEL,
    EN_MSG_TYPE_MINI_PROGRAM,
    EN_MSG_TYPE_NOTIFY_MSG,
    EN_MSG_TYPE_VIDEO_CARD,
    EN_MSG_TYPE_ARTICLE_CARD,
    EN_MSG_TYPE_PICTURE_CARD,
    EN_MSG_TYPE_COMMON_SHARE_CARD,
    EN_MSG_TYPE_TEXT_SHARE,
    EN_MSG_TYPE_TIP_MESSAGE,
    EN_MSG_TYPE_GPT_MESSAGE,
    EN_MSG_TYPE_BIZ_MSG_TYPE,
    EN_MSG_TYPE_MODIFY_MSG_TYPE,
    EN_MSG_TYPE_GROUP_MEMBER_CHANGED,
    EN_MSG_TYPE_GROUP_STATUS_CHANGED,
    EN_MSG_TYPE_GROUP_DYNAMIC_CHANGED,
    EN_MSG_TYPE_GROUP_LIST_CHANGED,
    EM_MSG_TYPE_FRIEND_LIST_CHANGED,
    EN_MSG_TYPE_GROUP_DETAIL_CHANGED,
    EN_MSG_TYPE_GROUP_MEMBER_ROLE_CHANGED,
    EN_MSG_TYPE_NOTICE_WATCH_LIST,
    EN_MSG_TYPE_NOTIFY_NEW_REPLY_RECIEVED,
    EN_MSG_TYPE_NOTIFY_NEW_AT_RECIEVED,
    EN_MSG_TYPE_NOTIFY_NEW_PRAISE_RECIEVED,
    EN_MSG_TYPE_NOTIFY_NEW_UP_RECIEVED,
    EN_MSG_TYPE_NOTIFY_NEW_REPLY_RECIEVED_V2,
    EN_MSG_TYPE_NOTIFY_NEW_AT_RECIEVED_V2,
    EN_MSG_TYPE_NOTIFY_NEW_PRAISE_RECIEVED_V2,
    EN_MSG_TYPE_GROUP_DETAIL_CHANGED_MULTI,
    EN_MSG_TYPE_GROUP_MEMBER_ROLE_CHANGED_MULTI,
    EN_MSG_TYPE_NOTIFY_ANTI_DISTURB,
    EN_MSG_TYPE_SYS_GROUP_DISSOLVED,
    EN_MSG_TYPE_SYS_GROUP_JOINED,
    EN_MSG_TYPE_SYS_GROUP_MEMBER_EXITED,
    EN_MSG_TYPE_SYS_GROUP_ADMIN_FIRED,
    EN_MSG_TYPE_SYS_GROUP_MEMBER_KICKED,
    EN_MSG_TYPE_SYS_GROUP_ADMIN_KICK_OFF,
    EN_MSG_TYPE_SYS_GROUP_ADMIN_DUTY,
    EN_MSG_TYPE_SYS_GROUP_AUTO_CREATED,
    EN_MSG_TYPE_SYS_FRIEND_APPLY,
    EN_MSG_TYPE_SYS_FRIEND_APPLY_ACK,
    EN_MSG_TYPE_SYS_GROUP_APPLY_FOR_JOINING,
    EN_MSG_TYPE_SYS_GROUP_ADMIN_ACCEPTED_USER_APPLY,
    EN_MSG_TYPE_CHAT_MEMBER_JOINED,
    EN_MSG_TYPE_CHAT_MEMBER_EXITED,
    EN_MSG_TYPE_CHAT_GROUP_FREEZED,
    EN_MSG_TYPE_CHAT_GROUP_DISSOLVED,
    EN_MSG_TYPE_CHAT_GROUP_CREATED,
    EN_MSG_TYPE_CHAT_POPUP_SESSION,
    EN_MSG_TYPE_CUSTOM_RANK_UPDATE,
    EN_MSG_TYPE_CUSTOM_MSG_NOTICE,
  ];

  static final $core.Map<$core.int, MsgType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static MsgType? valueOf($core.int value) => _byValue[value];

  const MsgType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
