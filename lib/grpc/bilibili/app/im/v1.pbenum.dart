// This is a generated file - do not edit.
//
// Generated from bilibili/app/im/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class IMSettingType extends $pb.ProtobufEnum {
  static const IMSettingType SETTING_TYPE_NEED_ALL =
      IMSettingType._(0, _omitEnumNames ? '' : 'SETTING_TYPE_NEED_ALL');
  static const IMSettingType SETTING_TYPE_REPLY_ME =
      IMSettingType._(1, _omitEnumNames ? '' : 'SETTING_TYPE_REPLY_ME');
  static const IMSettingType SETTING_TYPE_NEW_FANS =
      IMSettingType._(2, _omitEnumNames ? '' : 'SETTING_TYPE_NEW_FANS');
  static const IMSettingType SETTING_TYPE_RECEIVE_LIKE =
      IMSettingType._(3, _omitEnumNames ? '' : 'SETTING_TYPE_RECEIVE_LIKE');
  static const IMSettingType SETTING_TYPE_MSG_REMIND =
      IMSettingType._(4, _omitEnumNames ? '' : 'SETTING_TYPE_MSG_REMIND');
  static const IMSettingType SETTING_TYPE_MSG_INTERCEPTION =
      IMSettingType._(5, _omitEnumNames ? '' : 'SETTING_TYPE_MSG_INTERCEPTION');
  static const IMSettingType SETTING_TYPE_FANS_GROUP_MSG =
      IMSettingType._(6, _omitEnumNames ? '' : 'SETTING_TYPE_FANS_GROUP_MSG');
  static const IMSettingType SETTING_TYPE_FANS_GROUP_MSG_RECEIVE =
      IMSettingType._(
          7, _omitEnumNames ? '' : 'SETTING_TYPE_FANS_GROUP_MSG_RECEIVE');
  static const IMSettingType SETTING_TYPE_FANS_GROUP_MSG_FOLD = IMSettingType._(
      8, _omitEnumNames ? '' : 'SETTING_TYPE_FANS_GROUP_MSG_FOLD');
  static const IMSettingType SETTING_TYPE_FANS_GROUP_MSG_JOIN_GUIDE =
      IMSettingType._(
          9, _omitEnumNames ? '' : 'SETTING_TYPE_FANS_GROUP_MSG_JOIN_GUIDE');
  static const IMSettingType SETTING_TYPE_UNFOLLOWED_MSG =
      IMSettingType._(10, _omitEnumNames ? '' : 'SETTING_TYPE_UNFOLLOWED_MSG');
  static const IMSettingType SETTING_TYPE_UNFOLLOWED_MSG_FOLD = IMSettingType._(
      11, _omitEnumNames ? '' : 'SETTING_TYPE_UNFOLLOWED_MSG_FOLD');
  static const IMSettingType SETTING_TYPE_BLACK_LIST =
      IMSettingType._(12, _omitEnumNames ? '' : 'SETTING_TYPE_BLACK_LIST');
  static const IMSettingType SETTING_TYPE_ANTI_HARASSMENT =
      IMSettingType._(13, _omitEnumNames ? '' : 'SETTING_TYPE_ANTI_HARASSMENT');
  static const IMSettingType SETTING_TYPE_ANTI_HARASSMENT_SWITCH =
      IMSettingType._(
          14, _omitEnumNames ? '' : 'SETTING_TYPE_ANTI_HARASSMENT_SWITCH');
  static const IMSettingType SETTING_TYPE_ANTI_HARASSMENT_OPEN_TIP_TEXT =
      IMSettingType._(15,
          _omitEnumNames ? '' : 'SETTING_TYPE_ANTI_HARASSMENT_OPEN_TIP_TEXT');
  static const IMSettingType SETTING_TYPE_CLOSE_FANS_GROUP = IMSettingType._(
      16, _omitEnumNames ? '' : 'SETTING_TYPE_CLOSE_FANS_GROUP');
  static const IMSettingType SETTING_TYPE_OLD_REPLY_ME =
      IMSettingType._(17, _omitEnumNames ? '' : 'SETTING_TYPE_OLD_REPLY_ME');
  static const IMSettingType SETTING_TYPE_OLD_AT_ME =
      IMSettingType._(18, _omitEnumNames ? '' : 'SETTING_TYPE_OLD_AT_ME');
  static const IMSettingType SETTING_TYPE_OLD_RECEIVE_LIKE = IMSettingType._(
      19, _omitEnumNames ? '' : 'SETTING_TYPE_OLD_RECEIVE_LIKE');
  static const IMSettingType SETTING_TYPE_ANTI_HARASSMENT_INTERACT_LIMITS =
      IMSettingType._(20,
          _omitEnumNames ? '' : 'SETTING_TYPE_ANTI_HARASSMENT_INTERACT_LIMITS');
  static const IMSettingType SETTING_TYPE_ANTI_HARASSMENT_DURATION =
      IMSettingType._(
          21, _omitEnumNames ? '' : 'SETTING_TYPE_ANTI_HARASSMENT_DURATION');
  static const IMSettingType SETTING_TYPE_ANTI_HARASSMENT_COMMENT_LIMITS =
      IMSettingType._(22,
          _omitEnumNames ? '' : 'SETTING_TYPE_ANTI_HARASSMENT_COMMENT_LIMITS');
  static const IMSettingType SETTING_TYPE_ANTI_HARASSMENT_DANMU_LIMITS =
      IMSettingType._(23,
          _omitEnumNames ? '' : 'SETTING_TYPE_ANTI_HARASSMENT_DANMU_LIMITS');
  static const IMSettingType SETTING_TYPE_UNFOLLOWED_MSG_RECEIVE =
      IMSettingType._(
          24, _omitEnumNames ? '' : 'SETTING_TYPE_UNFOLLOWED_MSG_RECEIVE');
  static const IMSettingType SETTING_TYPE_ANTI_HARASSMENT_IM_LIMITS =
      IMSettingType._(
          25, _omitEnumNames ? '' : 'SETTING_TYPE_ANTI_HARASSMENT_IM_LIMITS');
  static const IMSettingType SETTING_TYPE_KEYWORD_BLOCKING = IMSettingType._(
      26, _omitEnumNames ? '' : 'SETTING_TYPE_KEYWORD_BLOCKING');

  static const $core.List<IMSettingType> values = <IMSettingType>[
    SETTING_TYPE_NEED_ALL,
    SETTING_TYPE_REPLY_ME,
    SETTING_TYPE_NEW_FANS,
    SETTING_TYPE_RECEIVE_LIKE,
    SETTING_TYPE_MSG_REMIND,
    SETTING_TYPE_MSG_INTERCEPTION,
    SETTING_TYPE_FANS_GROUP_MSG,
    SETTING_TYPE_FANS_GROUP_MSG_RECEIVE,
    SETTING_TYPE_FANS_GROUP_MSG_FOLD,
    SETTING_TYPE_FANS_GROUP_MSG_JOIN_GUIDE,
    SETTING_TYPE_UNFOLLOWED_MSG,
    SETTING_TYPE_UNFOLLOWED_MSG_FOLD,
    SETTING_TYPE_BLACK_LIST,
    SETTING_TYPE_ANTI_HARASSMENT,
    SETTING_TYPE_ANTI_HARASSMENT_SWITCH,
    SETTING_TYPE_ANTI_HARASSMENT_OPEN_TIP_TEXT,
    SETTING_TYPE_CLOSE_FANS_GROUP,
    SETTING_TYPE_OLD_REPLY_ME,
    SETTING_TYPE_OLD_AT_ME,
    SETTING_TYPE_OLD_RECEIVE_LIKE,
    SETTING_TYPE_ANTI_HARASSMENT_INTERACT_LIMITS,
    SETTING_TYPE_ANTI_HARASSMENT_DURATION,
    SETTING_TYPE_ANTI_HARASSMENT_COMMENT_LIMITS,
    SETTING_TYPE_ANTI_HARASSMENT_DANMU_LIMITS,
    SETTING_TYPE_UNFOLLOWED_MSG_RECEIVE,
    SETTING_TYPE_ANTI_HARASSMENT_IM_LIMITS,
    SETTING_TYPE_KEYWORD_BLOCKING,
  ];

  static final $core.List<IMSettingType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 26);
  static IMSettingType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const IMSettingType._(super.value, super.name);
}

class LabelType extends $pb.ProtobufEnum {
  static const LabelType LABEL_TYPE_DEFAULT =
      LabelType._(0, _omitEnumNames ? '' : 'LABEL_TYPE_DEFAULT');
  static const LabelType LABEL_TYPE_HUA_HUO =
      LabelType._(1, _omitEnumNames ? '' : 'LABEL_TYPE_HUA_HUO');
  static const LabelType LABEL_TYPE_ORIGINAL_FANS =
      LabelType._(2, _omitEnumNames ? '' : 'LABEL_TYPE_ORIGINAL_FANS');
  static const LabelType LABEL_TYPE_SPECIAL_ATTENTION =
      LabelType._(3, _omitEnumNames ? '' : 'LABEL_TYPE_SPECIAL_ATTENTION');
  static const LabelType LABEL_TYPE_CONTRACT_UP =
      LabelType._(4, _omitEnumNames ? '' : 'LABEL_TYPE_CONTRACT_UP');
  static const LabelType LABEL_TYPE_OLD_FANS =
      LabelType._(5, _omitEnumNames ? '' : 'LABEL_TYPE_OLD_FANS');
  static const LabelType LABEL_TYPE_SPECIAL_ATTENTION_2 =
      LabelType._(6, _omitEnumNames ? '' : 'LABEL_TYPE_SPECIAL_ATTENTION_2');
  static const LabelType LABEL_TYPE_FANS_MEDAL =
      LabelType._(7, _omitEnumNames ? '' : 'LABEL_TYPE_FANS_MEDAL');
  static const LabelType LABEL_TYPE_GUARD_MEDAL =
      LabelType._(8, _omitEnumNames ? '' : 'LABEL_TYPE_GUARD_MEDAL');

  static const $core.List<LabelType> values = <LabelType>[
    LABEL_TYPE_DEFAULT,
    LABEL_TYPE_HUA_HUO,
    LABEL_TYPE_ORIGINAL_FANS,
    LABEL_TYPE_SPECIAL_ATTENTION,
    LABEL_TYPE_CONTRACT_UP,
    LABEL_TYPE_OLD_FANS,
    LABEL_TYPE_SPECIAL_ATTENTION_2,
    LABEL_TYPE_FANS_MEDAL,
    LABEL_TYPE_GUARD_MEDAL,
  ];

  static final $core.List<LabelType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 8);
  static LabelType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LabelType._(super.value, super.name);
}

class MsgSummaryPrefixType extends $pb.ProtobufEnum {
  static const MsgSummaryPrefixType MSG_SUMMARY_PREFIX_TYPE_NONE =
      MsgSummaryPrefixType._(
          0, _omitEnumNames ? '' : 'MSG_SUMMARY_PREFIX_TYPE_NONE');
  static const MsgSummaryPrefixType MSG_SUMMARY_PREFIX_TYPE_NOTIFICATION =
      MsgSummaryPrefixType._(
          1, _omitEnumNames ? '' : 'MSG_SUMMARY_PREFIX_TYPE_NOTIFICATION');
  static const MsgSummaryPrefixType MSG_SUMMARY_PREFIX_TYPE_GROUP_BLOCKED =
      MsgSummaryPrefixType._(
          2, _omitEnumNames ? '' : 'MSG_SUMMARY_PREFIX_TYPE_GROUP_BLOCKED');
  static const MsgSummaryPrefixType MSG_SUMMARY_PREFIX_TYPE_MENTIONED =
      MsgSummaryPrefixType._(
          3, _omitEnumNames ? '' : 'MSG_SUMMARY_PREFIX_TYPE_MENTIONED');
  static const MsgSummaryPrefixType MSG_SUMMARY_PREFIX_TYPE_UNREAD =
      MsgSummaryPrefixType._(
          4, _omitEnumNames ? '' : 'MSG_SUMMARY_PREFIX_TYPE_UNREAD');

  static const $core.List<MsgSummaryPrefixType> values = <MsgSummaryPrefixType>[
    MSG_SUMMARY_PREFIX_TYPE_NONE,
    MSG_SUMMARY_PREFIX_TYPE_NOTIFICATION,
    MSG_SUMMARY_PREFIX_TYPE_GROUP_BLOCKED,
    MSG_SUMMARY_PREFIX_TYPE_MENTIONED,
    MSG_SUMMARY_PREFIX_TYPE_UNREAD,
  ];

  static final $core.List<MsgSummaryPrefixType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static MsgSummaryPrefixType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MsgSummaryPrefixType._(super.value, super.name);
}

class SessionFilterType extends $pb.ProtobufEnum {
  static const SessionFilterType FILTER_DEFAULT =
      SessionFilterType._(0, _omitEnumNames ? '' : 'FILTER_DEFAULT');
  static const SessionFilterType FILTER_FOLLOW =
      SessionFilterType._(1, _omitEnumNames ? '' : 'FILTER_FOLLOW');

  static const $core.List<SessionFilterType> values = <SessionFilterType>[
    FILTER_DEFAULT,
    FILTER_FOLLOW,
  ];

  static final $core.List<SessionFilterType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static SessionFilterType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SessionFilterType._(super.value, super.name);
}

class SessionPageType extends $pb.ProtobufEnum {
  static const SessionPageType SESSION_PAGE_TYPE_UNKNOWN =
      SessionPageType._(0, _omitEnumNames ? '' : 'SESSION_PAGE_TYPE_UNKNOWN');
  static const SessionPageType SESSION_PAGE_TYPE_HOME =
      SessionPageType._(1, _omitEnumNames ? '' : 'SESSION_PAGE_TYPE_HOME');
  static const SessionPageType SESSION_PAGE_TYPE_UNFOLLOWED = SessionPageType._(
      2, _omitEnumNames ? '' : 'SESSION_PAGE_TYPE_UNFOLLOWED');
  static const SessionPageType SESSION_PAGE_TYPE_STRANGER =
      SessionPageType._(3, _omitEnumNames ? '' : 'SESSION_PAGE_TYPE_STRANGER');
  static const SessionPageType SESSION_PAGE_TYPE_DUSTBIN =
      SessionPageType._(4, _omitEnumNames ? '' : 'SESSION_PAGE_TYPE_DUSTBIN');
  static const SessionPageType SESSION_PAGE_TYPE_GROUP =
      SessionPageType._(5, _omitEnumNames ? '' : 'SESSION_PAGE_TYPE_GROUP');
  static const SessionPageType SESSION_PAGE_TYPE_HUA_HUO =
      SessionPageType._(6, _omitEnumNames ? '' : 'SESSION_PAGE_TYPE_HUA_HUO');
  static const SessionPageType SESSION_PAGE_TYPE_AI =
      SessionPageType._(7, _omitEnumNames ? '' : 'SESSION_PAGE_TYPE_AI');
  static const SessionPageType SESSION_PAGE_TYPE_CUSTOMER =
      SessionPageType._(8, _omitEnumNames ? '' : 'SESSION_PAGE_TYPE_CUSTOMER');

  static const $core.List<SessionPageType> values = <SessionPageType>[
    SESSION_PAGE_TYPE_UNKNOWN,
    SESSION_PAGE_TYPE_HOME,
    SESSION_PAGE_TYPE_UNFOLLOWED,
    SESSION_PAGE_TYPE_STRANGER,
    SESSION_PAGE_TYPE_DUSTBIN,
    SESSION_PAGE_TYPE_GROUP,
    SESSION_PAGE_TYPE_HUA_HUO,
    SESSION_PAGE_TYPE_AI,
    SESSION_PAGE_TYPE_CUSTOMER,
  ];

  static final $core.List<SessionPageType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 8);
  static SessionPageType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SessionPageType._(super.value, super.name);
}

class SessionType extends $pb.ProtobufEnum {
  static const SessionType SESSION_TYPE_UNKNOWN =
      SessionType._(0, _omitEnumNames ? '' : 'SESSION_TYPE_UNKNOWN');
  static const SessionType SESSION_TYPE_PRIVATE =
      SessionType._(1, _omitEnumNames ? '' : 'SESSION_TYPE_PRIVATE');
  static const SessionType SESSION_TYPE_GROUP =
      SessionType._(2, _omitEnumNames ? '' : 'SESSION_TYPE_GROUP');
  static const SessionType SESSION_TYPE_GROUP_FOLD =
      SessionType._(3, _omitEnumNames ? '' : 'SESSION_TYPE_GROUP_FOLD');
  static const SessionType SESSION_TYPE_UNFOLLOWED =
      SessionType._(4, _omitEnumNames ? '' : 'SESSION_TYPE_UNFOLLOWED');
  static const SessionType SESSION_TYPE_STRANGER =
      SessionType._(5, _omitEnumNames ? '' : 'SESSION_TYPE_STRANGER');
  static const SessionType SESSION_TYPE_DUSTBIN =
      SessionType._(6, _omitEnumNames ? '' : 'SESSION_TYPE_DUSTBIN');
  static const SessionType SESSION_TYPE_CUSTOMER_FOLD =
      SessionType._(7, _omitEnumNames ? '' : 'SESSION_TYPE_CUSTOMER_FOLD');
  static const SessionType SESSION_TYPE_SYSTEM =
      SessionType._(8, _omitEnumNames ? '' : 'SESSION_TYPE_SYSTEM');
  static const SessionType SESSION_TYPE_AI_FOLD =
      SessionType._(9, _omitEnumNames ? '' : 'SESSION_TYPE_AI_FOLD');
  static const SessionType SESSION_TYPE_CUSTOMER_ACCOUNT =
      SessionType._(10, _omitEnumNames ? '' : 'SESSION_TYPE_CUSTOMER_ACCOUNT');

  static const $core.List<SessionType> values = <SessionType>[
    SESSION_TYPE_UNKNOWN,
    SESSION_TYPE_PRIVATE,
    SESSION_TYPE_GROUP,
    SESSION_TYPE_GROUP_FOLD,
    SESSION_TYPE_UNFOLLOWED,
    SESSION_TYPE_STRANGER,
    SESSION_TYPE_DUSTBIN,
    SESSION_TYPE_CUSTOMER_FOLD,
    SESSION_TYPE_SYSTEM,
    SESSION_TYPE_AI_FOLD,
    SESSION_TYPE_CUSTOMER_ACCOUNT,
  ];

  static final $core.List<SessionType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 10);
  static SessionType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SessionType._(super.value, super.name);
}

class ThreeDotItemType extends $pb.ProtobufEnum {
  static const ThreeDotItemType THREE_DOT_ITEM_TYPE_UNKNOWN =
      ThreeDotItemType._(
          0, _omitEnumNames ? '' : 'THREE_DOT_ITEM_TYPE_UNKNOWN');
  static const ThreeDotItemType THREE_DOT_ITEM_TYPE_READ_ALL =
      ThreeDotItemType._(
          1, _omitEnumNames ? '' : 'THREE_DOT_ITEM_TYPE_READ_ALL');
  static const ThreeDotItemType THREE_DOT_ITEM_TYPE_MSG_SETTING =
      ThreeDotItemType._(
          2, _omitEnumNames ? '' : 'THREE_DOT_ITEM_TYPE_MSG_SETTING');
  static const ThreeDotItemType THREE_DOT_ITEM_TYPE_AUTO_REPLY =
      ThreeDotItemType._(
          3, _omitEnumNames ? '' : 'THREE_DOT_ITEM_TYPE_AUTO_REPLY');
  static const ThreeDotItemType THREE_DOT_ITEM_TYPE_UP_HELPER =
      ThreeDotItemType._(
          4, _omitEnumNames ? '' : 'THREE_DOT_ITEM_TYPE_UP_HELPER');
  static const ThreeDotItemType THREE_DOT_ITEM_TYPE_LIVE_HELPER =
      ThreeDotItemType._(
          5, _omitEnumNames ? '' : 'THREE_DOT_ITEM_TYPE_LIVE_HELPER');
  static const ThreeDotItemType THREE_DOT_ITEM_TYPE_FANS_GROUP_HELPER =
      ThreeDotItemType._(
          6, _omitEnumNames ? '' : 'THREE_DOT_ITEM_TYPE_FANS_GROUP_HELPER');
  static const ThreeDotItemType THREE_DOT_ITEM_TYPE_CONTRIBUTION_PUSH =
      ThreeDotItemType._(
          7, _omitEnumNames ? '' : 'THREE_DOT_ITEM_TYPE_CONTRIBUTION_PUSH');
  static const ThreeDotItemType THREE_DOT_ITEM_TYPE_CONTACTS =
      ThreeDotItemType._(
          8, _omitEnumNames ? '' : 'THREE_DOT_ITEM_TYPE_CONTACTS');
  static const ThreeDotItemType THREE_DOT_ITEM_TYPE_CLEAR_LIST =
      ThreeDotItemType._(
          9, _omitEnumNames ? '' : 'THREE_DOT_ITEM_TYPE_CLEAR_LIST');

  static const $core.List<ThreeDotItemType> values = <ThreeDotItemType>[
    THREE_DOT_ITEM_TYPE_UNKNOWN,
    THREE_DOT_ITEM_TYPE_READ_ALL,
    THREE_DOT_ITEM_TYPE_MSG_SETTING,
    THREE_DOT_ITEM_TYPE_AUTO_REPLY,
    THREE_DOT_ITEM_TYPE_UP_HELPER,
    THREE_DOT_ITEM_TYPE_LIVE_HELPER,
    THREE_DOT_ITEM_TYPE_FANS_GROUP_HELPER,
    THREE_DOT_ITEM_TYPE_CONTRIBUTION_PUSH,
    THREE_DOT_ITEM_TYPE_CONTACTS,
    THREE_DOT_ITEM_TYPE_CLEAR_LIST,
  ];

  static final $core.List<ThreeDotItemType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 9);
  static ThreeDotItemType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ThreeDotItemType._(super.value, super.name);
}

class UnreadStyle extends $pb.ProtobufEnum {
  static const UnreadStyle UNREAD_STYLE_NONE =
      UnreadStyle._(0, _omitEnumNames ? '' : 'UNREAD_STYLE_NONE');
  static const UnreadStyle UNREAD_STYLE_DOT =
      UnreadStyle._(1, _omitEnumNames ? '' : 'UNREAD_STYLE_DOT');
  static const UnreadStyle UNREAD_STYLE_NUMBER =
      UnreadStyle._(2, _omitEnumNames ? '' : 'UNREAD_STYLE_NUMBER');

  static const $core.List<UnreadStyle> values = <UnreadStyle>[
    UNREAD_STYLE_NONE,
    UNREAD_STYLE_DOT,
    UNREAD_STYLE_NUMBER,
  ];

  static final $core.List<UnreadStyle?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static UnreadStyle? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const UnreadStyle._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
