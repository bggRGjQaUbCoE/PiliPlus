// This is a generated file - do not edit.
//
// Generated from bilibili/main/community/reply/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use detailListSceneDescriptor instead')
const DetailListScene$json = {
  '1': 'DetailListScene',
  '2': [
    {'1': 'REPLY', '2': 0},
    {'1': 'MSG_FEED', '2': 1},
    {'1': 'NOTIFY', '2': 2},
  ],
};

/// Descriptor for `DetailListScene`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List detailListSceneDescriptor = $convert.base64Decode(
    'Cg9EZXRhaWxMaXN0U2NlbmUSCQoFUkVQTFkQABIMCghNU0dfRkVFRBABEgoKBk5PVElGWRAC');

@$core.Deprecated('Use editorIconStateDescriptor instead')
const EditorIconState$json = {
  '1': 'EditorIconState',
  '2': [
    {'1': 'EditorIconState_DEFAULT', '2': 0},
    {'1': 'EditorIconState_ENABLE', '2': 1},
    {'1': 'EditorIconState_DISABLE', '2': 2},
    {'1': 'EditorIconState_HIDE', '2': 3},
  ],
};

/// Descriptor for `EditorIconState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List editorIconStateDescriptor = $convert.base64Decode(
    'Cg9FZGl0b3JJY29uU3RhdGUSGwoXRWRpdG9ySWNvblN0YXRlX0RFRkFVTFQQABIaChZFZGl0b3'
    'JJY29uU3RhdGVfRU5BQkxFEAESGwoXRWRpdG9ySWNvblN0YXRlX0RJU0FCTEUQAhIYChRFZGl0'
    'b3JJY29uU3RhdGVfSElERRAD');

@$core.Deprecated('Use modeDescriptor instead')
const Mode$json = {
  '1': 'Mode',
  '2': [
    {'1': 'DEFAULT_Mode', '2': 0},
    {'1': 'UNSPECIFIED', '2': 1},
    {'1': 'MAIN_LIST_TIME', '2': 2},
    {'1': 'MAIN_LIST_HOT', '2': 3},
  ],
};

/// Descriptor for `Mode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List modeDescriptor = $convert.base64Decode(
    'CgRNb2RlEhAKDERFRkFVTFRfTW9kZRAAEg8KC1VOU1BFQ0lGSUVEEAESEgoOTUFJTl9MSVNUX1'
    'RJTUUQAhIRCg1NQUlOX0xJU1RfSE9UEAM=');

@$core.Deprecated('Use replyNotificationSwitchDescriptor instead')
const ReplyNotificationSwitch$json = {
  '1': 'ReplyNotificationSwitch',
  '2': [
    {'1': 'ReplyNotificationSwitch_UNSPECIFIED', '2': 0},
    {'1': 'ReplyNotificationSwitch_OFF', '2': 1},
    {'1': 'ReplyNotificationSwitch_ON', '2': 2},
  ],
};

/// Descriptor for `ReplyNotificationSwitch`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List replyNotificationSwitchDescriptor = $convert.base64Decode(
    'ChdSZXBseU5vdGlmaWNhdGlvblN3aXRjaBInCiNSZXBseU5vdGlmaWNhdGlvblN3aXRjaF9VTl'
    'NQRUNJRklFRBAAEh8KG1JlcGx5Tm90aWZpY2F0aW9uU3dpdGNoX09GRhABEh4KGlJlcGx5Tm90'
    'aWZpY2F0aW9uU3dpdGNoX09OEAI=');

@$core.Deprecated('Use searchItemTypeDescriptor instead')
const SearchItemType$json = {
  '1': 'SearchItemType',
  '2': [
    {'1': 'DEFAULT_ITEM_TYPE', '2': 0},
    {'1': 'GOODS', '2': 1},
    {'1': 'VIDEO', '2': 2},
    {'1': 'ARTICLE', '2': 3},
  ],
};

/// Descriptor for `SearchItemType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List searchItemTypeDescriptor = $convert.base64Decode(
    'Cg5TZWFyY2hJdGVtVHlwZRIVChFERUZBVUxUX0lURU1fVFlQRRAAEgkKBUdPT0RTEAESCQoFVk'
    'lERU8QAhILCgdBUlRJQ0xFEAM=');

@$core.Deprecated('Use searchItemVideoSubTypeDescriptor instead')
const SearchItemVideoSubType$json = {
  '1': 'SearchItemVideoSubType',
  '2': [
    {'1': 'UGC', '2': 0},
    {'1': 'PGC', '2': 1},
  ],
};

/// Descriptor for `SearchItemVideoSubType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List searchItemVideoSubTypeDescriptor = $convert
    .base64Decode('ChZTZWFyY2hJdGVtVmlkZW9TdWJUeXBlEgcKA1VHQxAAEgcKA1BHQxAB');

@$core.Deprecated('Use userCallbackActionDescriptor instead')
const UserCallbackAction$json = {
  '1': 'UserCallbackAction',
  '2': [
    {'1': 'Dismiss', '2': 0},
  ],
};

/// Descriptor for `UserCallbackAction`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List userCallbackActionDescriptor =
    $convert.base64Decode('ChJVc2VyQ2FsbGJhY2tBY3Rpb24SCwoHRGlzbWlzcxAA');

@$core.Deprecated('Use userCallbackSceneDescriptor instead')
const UserCallbackScene$json = {
  '1': 'UserCallbackScene',
  '2': [
    {'1': 'Insert_UserCallbackScene', '2': 0},
    {'1': 'RecommendSuperbReply', '2': 1},
  ],
};

/// Descriptor for `UserCallbackScene`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List userCallbackSceneDescriptor = $convert.base64Decode(
    'ChFVc2VyQ2FsbGJhY2tTY2VuZRIcChhJbnNlcnRfVXNlckNhbGxiYWNrU2NlbmUQABIYChRSZW'
    'NvbW1lbmRTdXBlcmJSZXBseRAB');

@$core.Deprecated('Use translationSwitchDescriptor instead')
const TranslationSwitch$json = {
  '1': 'TranslationSwitch',
  '2': [
    {'1': 'TRANSLATION_SWITCH_UNSPECIFIED', '2': 0},
    {'1': 'TRANSLATION_SWITCH_UNSUPPORTED', '2': 1},
    {'1': 'TRANSLATION_SWITCH_SHOW_TRANSLATION', '2': 2},
    {'1': 'TRANSLATION_SWITCH_SHOW_ORIGIN', '2': 3},
  ],
};

/// Descriptor for `TranslationSwitch`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List translationSwitchDescriptor = $convert.base64Decode(
    'ChFUcmFuc2xhdGlvblN3aXRjaBIiCh5UUkFOU0xBVElPTl9TV0lUQ0hfVU5TUEVDSUZJRUQQAB'
    'IiCh5UUkFOU0xBVElPTl9TV0lUQ0hfVU5TVVBQT1JURUQQARInCiNUUkFOU0xBVElPTl9TV0lU'
    'Q0hfU0hPV19UUkFOU0xBVElPThACEiIKHlRSQU5TTEFUSU9OX1NXSVRDSF9TSE9XX09SSUdJTh'
    'AD');

@$core.Deprecated('Use activityDescriptor instead')
const Activity$json = {
  '1': 'Activity',
  '2': [
    {'1': 'activity_id', '3': 1, '4': 1, '5': 3, '10': 'activityId'},
    {'1': 'activity_state', '3': 2, '4': 1, '5': 3, '10': 'activityState'},
    {
      '1': 'activity_placeholder',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'activityPlaceholder'
    },
  ],
};

/// Descriptor for `Activity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List activityDescriptor = $convert.base64Decode(
    'CghBY3Rpdml0eRIfCgthY3Rpdml0eV9pZBgBIAEoA1IKYWN0aXZpdHlJZBIlCg5hY3Rpdml0eV'
    '9zdGF0ZRgCIAEoA1INYWN0aXZpdHlTdGF0ZRIxChRhY3Rpdml0eV9wbGFjZWhvbGRlchgDIAEo'
    'CVITYWN0aXZpdHlQbGFjZWhvbGRlcg==');

@$core.Deprecated('Use answerQuestionReqDescriptor instead')
const AnswerQuestionReq$json = {
  '1': 'AnswerQuestionReq',
  '2': [
    {'1': 'qid', '3': 1, '4': 1, '5': 3, '10': 'qid'},
    {'1': 'option_key', '3': 2, '4': 1, '5': 9, '10': 'optionKey'},
  ],
};

/// Descriptor for `AnswerQuestionReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List answerQuestionReqDescriptor = $convert.base64Decode(
    'ChFBbnN3ZXJRdWVzdGlvblJlcRIQCgNxaWQYASABKANSA3FpZBIdCgpvcHRpb25fa2V5GAIgAS'
    'gJUglvcHRpb25LZXk=');

@$core.Deprecated('Use answerQuestionRespDescriptor instead')
const AnswerQuestionResp$json = {
  '1': 'AnswerQuestionResp',
  '2': [
    {'1': 'passed', '3': 1, '4': 1, '5': 8, '10': 'passed'},
    {'1': 'member_passed', '3': 2, '4': 1, '5': 8, '10': 'memberPassed'},
    {
      '1': 'member_passed_popup',
      '3': 3,
      '4': 1,
      '5': 11,
      '6':
          '.bilibili.main.community.reply.v1.AnswerQuestionResp.MemberPassedPopup',
      '10': 'memberPassedPopup'
    },
    {'1': 'bottom_text', '3': 4, '4': 1, '5': 9, '10': 'bottomText'},
    {
      '1': 'stat',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.QuestionCardStat',
      '10': 'stat'
    },
  ],
  '3': [AnswerQuestionResp_MemberPassedPopup$json],
};

@$core.Deprecated('Use answerQuestionRespDescriptor instead')
const AnswerQuestionResp_MemberPassedPopup$json = {
  '1': 'MemberPassedPopup',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'subtitle', '3': 2, '4': 1, '5': 9, '10': 'subtitle'},
    {'1': 'h5_link', '3': 3, '4': 1, '5': 9, '10': 'h5Link'},
  ],
};

/// Descriptor for `AnswerQuestionResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List answerQuestionRespDescriptor = $convert.base64Decode(
    'ChJBbnN3ZXJRdWVzdGlvblJlc3ASFgoGcGFzc2VkGAEgASgIUgZwYXNzZWQSIwoNbWVtYmVyX3'
    'Bhc3NlZBgCIAEoCFIMbWVtYmVyUGFzc2VkEnYKE21lbWJlcl9wYXNzZWRfcG9wdXAYAyABKAsy'
    'Ri5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5BbnN3ZXJRdWVzdGlvblJlc3AuTW'
    'VtYmVyUGFzc2VkUG9wdXBSEW1lbWJlclBhc3NlZFBvcHVwEh8KC2JvdHRvbV90ZXh0GAQgASgJ'
    'Ugpib3R0b21UZXh0EkYKBHN0YXQYBSABKAsyMi5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZX'
    'BseS52MS5RdWVzdGlvbkNhcmRTdGF0UgRzdGF0Gl4KEU1lbWJlclBhc3NlZFBvcHVwEhQKBXRp'
    'dGxlGAEgASgJUgV0aXRsZRIaCghzdWJ0aXRsZRgCIAEoCVIIc3VidGl0bGUSFwoHaDVfbGluax'
    'gDIAEoCVIGaDVMaW5r');

@$core.Deprecated('Use articleSearchItemDescriptor instead')
const ArticleSearchItem$json = {
  '1': 'ArticleSearchItem',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'up_nickname', '3': 2, '4': 1, '5': 9, '10': 'upNickname'},
    {'1': 'covers', '3': 3, '4': 3, '5': 9, '10': 'covers'},
  ],
};

/// Descriptor for `ArticleSearchItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List articleSearchItemDescriptor = $convert.base64Decode(
    'ChFBcnRpY2xlU2VhcmNoSXRlbRIUCgV0aXRsZRgBIAEoCVIFdGl0bGUSHwoLdXBfbmlja25hbW'
    'UYAiABKAlSCnVwTmlja25hbWUSFgoGY292ZXJzGAMgAygJUgZjb3ZlcnM=');

@$core.Deprecated('Use atGroupDescriptor instead')
const AtGroup$json = {
  '1': 'AtGroup',
  '2': [
    {
      '1': 'group_type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.AtGroup.Type',
      '10': 'groupType'
    },
    {'1': 'group_name', '3': 2, '4': 1, '5': 9, '10': 'groupName'},
    {
      '1': 'items',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.AtItem',
      '10': 'items'
    },
  ],
  '4': [AtGroup_Type$json],
};

@$core.Deprecated('Use atGroupDescriptor instead')
const AtGroup_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'AT_GROUP_TYPE_DEFAULT', '2': 0},
    {'1': 'AT_GROUP_TYPE_RECENT', '2': 1},
    {'1': 'AT_GROUP_TYPE_FOLLOW', '2': 2},
    {'1': 'AT_GROUP_TYPE_FANS', '2': 3},
    {'1': 'AT_GROUP_TYPE_OTHERS', '2': 4},
  ],
};

/// Descriptor for `AtGroup`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List atGroupDescriptor = $convert.base64Decode(
    'CgdBdEdyb3VwEk0KCmdyb3VwX3R5cGUYASABKA4yLi5iaWxpYmlsaS5tYWluLmNvbW11bml0eS'
    '5yZXBseS52MS5BdEdyb3VwLlR5cGVSCWdyb3VwVHlwZRIdCgpncm91cF9uYW1lGAIgASgJUgln'
    'cm91cE5hbWUSPgoFaXRlbXMYAyADKAsyKC5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS'
    '52MS5BdEl0ZW1SBWl0ZW1zIocBCgRUeXBlEhkKFUFUX0dST1VQX1RZUEVfREVGQVVMVBAAEhgK'
    'FEFUX0dST1VQX1RZUEVfUkVDRU5UEAESGAoUQVRfR1JPVVBfVFlQRV9GT0xMT1cQAhIWChJBVF'
    '9HUk9VUF9UWVBFX0ZBTlMQAxIYChRBVF9HUk9VUF9UWVBFX09USEVSUxAE');

@$core.Deprecated('Use atItemDescriptor instead')
const AtItem$json = {
  '1': 'AtItem',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'face', '3': 3, '4': 1, '5': 9, '10': 'face'},
    {'1': 'fans', '3': 4, '4': 1, '5': 5, '10': 'fans'},
    {
      '1': 'official_verify_type',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'officialVerifyType'
    },
  ],
};

/// Descriptor for `AtItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List atItemDescriptor = $convert.base64Decode(
    'CgZBdEl0ZW0SEAoDbWlkGAEgASgDUgNtaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRISCgRmYWNlGA'
    'MgASgJUgRmYWNlEhIKBGZhbnMYBCABKAVSBGZhbnMSMAoUb2ZmaWNpYWxfdmVyaWZ5X3R5cGUY'
    'BSABKAVSEm9mZmljaWFsVmVyaWZ5VHlwZQ==');

@$core.Deprecated('Use atSearchReplyDescriptor instead')
const AtSearchReply$json = {
  '1': 'AtSearchReply',
  '2': [
    {
      '1': 'groups',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.AtGroup',
      '10': 'groups'
    },
  ],
};

/// Descriptor for `AtSearchReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List atSearchReplyDescriptor = $convert.base64Decode(
    'Cg1BdFNlYXJjaFJlcGx5EkEKBmdyb3VwcxgBIAMoCzIpLmJpbGliaWxpLm1haW4uY29tbXVuaX'
    'R5LnJlcGx5LnYxLkF0R3JvdXBSBmdyb3Vwcw==');

@$core.Deprecated('Use atSearchReqDescriptor instead')
const AtSearchReq$json = {
  '1': 'AtSearchReq',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'keyword', '3': 2, '4': 1, '5': 9, '10': 'keyword'},
  ],
};

/// Descriptor for `AtSearchReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List atSearchReqDescriptor = $convert.base64Decode(
    'CgtBdFNlYXJjaFJlcRIQCgNtaWQYASABKANSA21pZBIYCgdrZXl3b3JkGAIgASgJUgdrZXl3b3'
    'Jk');

@$core.Deprecated('Use cMDescriptor instead')
const CM$json = {
  '1': 'CM',
  '2': [
    {
      '1': 'source_content',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Any',
      '10': 'sourceContent'
    },
  ],
};

/// Descriptor for `CM`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cMDescriptor = $convert.base64Decode(
    'CgJDTRI7Cg5zb3VyY2VfY29udGVudBgBIAEoCzIULmdvb2dsZS5wcm90b2J1Zi5BbnlSDXNvdX'
    'JjZUNvbnRlbnQ=');

@$core.Deprecated('Use contentDescriptor instead')
const Content$json = {
  '1': 'Content',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'members',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Content.MembersEntry',
      '10': 'members'
    },
    {
      '1': 'emotes',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Content.EmotesEntry',
      '10': 'emotes'
    },
    {
      '1': 'topics',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Content.TopicsEntry',
      '10': 'topics'
    },
    {
      '1': 'urls',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Content.UrlsEntry',
      '10': 'urls'
    },
    {
      '1': 'vote',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Vote',
      '10': 'vote'
    },
    {
      '1': 'at_name_to_mid',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Content.AtNameToMidEntry',
      '10': 'atNameToMid'
    },
    {
      '1': 'rich_text',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.RichText',
      '10': 'richText'
    },
    {
      '1': 'pictures',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Picture',
      '10': 'pictures'
    },
    {'1': 'picture_scale', '3': 10, '4': 1, '5': 1, '10': 'pictureScale'},
  ],
  '3': [
    Content_MembersEntry$json,
    Content_EmotesEntry$json,
    Content_TopicsEntry$json,
    Content_UrlsEntry$json,
    Content_AtNameToMidEntry$json
  ],
};

@$core.Deprecated('Use contentDescriptor instead')
const Content_MembersEntry$json = {
  '1': 'MembersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Member',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use contentDescriptor instead')
const Content_EmotesEntry$json = {
  '1': 'EmotesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Emote',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use contentDescriptor instead')
const Content_TopicsEntry$json = {
  '1': 'TopicsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Topic',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use contentDescriptor instead')
const Content_UrlsEntry$json = {
  '1': 'UrlsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Url',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use contentDescriptor instead')
const Content_AtNameToMidEntry$json = {
  '1': 'AtNameToMidEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 3, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Content`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contentDescriptor = $convert.base64Decode(
    'CgdDb250ZW50EhgKB21lc3NhZ2UYASABKAlSB21lc3NhZ2USUAoHbWVtYmVycxgCIAMoCzI2Lm'
    'JpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLkNvbnRlbnQuTWVtYmVyc0VudHJ5Ugdt'
    'ZW1iZXJzEk0KBmVtb3RlcxgDIAMoCzI1LmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5Ln'
    'YxLkNvbnRlbnQuRW1vdGVzRW50cnlSBmVtb3RlcxJNCgZ0b3BpY3MYBCADKAsyNS5iaWxpYmls'
    'aS5tYWluLmNvbW11bml0eS5yZXBseS52MS5Db250ZW50LlRvcGljc0VudHJ5UgZ0b3BpY3MSRw'
    'oEdXJscxgFIAMoCzIzLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLkNvbnRlbnQu'
    'VXJsc0VudHJ5UgR1cmxzEjoKBHZvdGUYBiABKAsyJi5iaWxpYmlsaS5tYWluLmNvbW11bml0eS'
    '5yZXBseS52MS5Wb3RlUgR2b3RlEl8KDmF0X25hbWVfdG9fbWlkGAcgAygLMjouYmlsaWJpbGku'
    'bWFpbi5jb21tdW5pdHkucmVwbHkudjEuQ29udGVudC5BdE5hbWVUb01pZEVudHJ5UgthdE5hbW'
    'VUb01pZBJHCglyaWNoX3RleHQYCCABKAsyKi5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBs'
    'eS52MS5SaWNoVGV4dFIIcmljaFRleHQSRQoIcGljdHVyZXMYCSADKAsyKS5iaWxpYmlsaS5tYW'
    'luLmNvbW11bml0eS5yZXBseS52MS5QaWN0dXJlUghwaWN0dXJlcxIjCg1waWN0dXJlX3NjYWxl'
    'GAogASgBUgxwaWN0dXJlU2NhbGUaZAoMTWVtYmVyc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5Ej'
    '4KBXZhbHVlGAIgASgLMiguYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuTWVtYmVy'
    'UgV2YWx1ZToCOAEaYgoLRW1vdGVzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSPQoFdmFsdWUYAi'
    'ABKAsyJy5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5FbW90ZVIFdmFsdWU6AjgB'
    'GmIKC1RvcGljc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5Ej0KBXZhbHVlGAIgASgLMicuYmlsaW'
    'JpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuVG9waWNSBXZhbHVlOgI4ARpeCglVcmxzRW50'
    'cnkSEAoDa2V5GAEgASgJUgNrZXkSOwoFdmFsdWUYAiABKAsyJS5iaWxpYmlsaS5tYWluLmNvbW'
    '11bml0eS5yZXBseS52MS5VcmxSBXZhbHVlOgI4ARo+ChBBdE5hbWVUb01pZEVudHJ5EhAKA2tl'
    'eRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgDUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use cursorReplyDescriptor instead')
const CursorReply$json = {
  '1': 'CursorReply',
  '2': [
    {'1': 'next', '3': 1, '4': 1, '5': 3, '10': 'next'},
    {'1': 'prev', '3': 2, '4': 1, '5': 3, '10': 'prev'},
    {'1': 'is_begin', '3': 3, '4': 1, '5': 8, '10': 'isBegin'},
    {'1': 'is_end', '3': 4, '4': 1, '5': 8, '10': 'isEnd'},
    {
      '1': 'mode',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.Mode',
      '10': 'mode'
    },
    {'1': 'mode_text', '3': 6, '4': 1, '5': 9, '10': 'modeText'},
  ],
};

/// Descriptor for `CursorReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cursorReplyDescriptor = $convert.base64Decode(
    'CgtDdXJzb3JSZXBseRISCgRuZXh0GAEgASgDUgRuZXh0EhIKBHByZXYYAiABKANSBHByZXYSGQ'
    'oIaXNfYmVnaW4YAyABKAhSB2lzQmVnaW4SFQoGaXNfZW5kGAQgASgIUgVpc0VuZBI6CgRtb2Rl'
    'GAUgASgOMiYuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuTW9kZVIEbW9kZRIbCg'
    'ltb2RlX3RleHQYBiABKAlSCG1vZGVUZXh0');

@$core.Deprecated('Use cursorReqDescriptor instead')
const CursorReq$json = {
  '1': 'CursorReq',
  '2': [
    {'1': 'next', '3': 1, '4': 1, '5': 3, '10': 'next'},
    {'1': 'prev', '3': 2, '4': 1, '5': 3, '10': 'prev'},
    {
      '1': 'mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.Mode',
      '10': 'mode'
    },
  ],
};

/// Descriptor for `CursorReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cursorReqDescriptor = $convert.base64Decode(
    'CglDdXJzb3JSZXESEgoEbmV4dBgBIAEoA1IEbmV4dBISCgRwcmV2GAIgASgDUgRwcmV2EjoKBG'
    '1vZGUYBCABKA4yJi5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5Nb2RlUgRtb2Rl');

@$core.Deprecated('Use detailListReplyDescriptor instead')
const DetailListReply$json = {
  '1': 'DetailListReply',
  '2': [
    {
      '1': 'cursor',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.CursorReply',
      '10': 'cursor'
    },
    {
      '1': 'subject_control',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.SubjectControl',
      '10': 'subjectControl'
    },
    {
      '1': 'root',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInfo',
      '10': 'root'
    },
    {
      '1': 'activity',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Activity',
      '10': 'activity'
    },
    {
      '1': 'likes',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.LikeInfo',
      '10': 'likes'
    },
    {
      '1': 'mode',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.Mode',
      '10': 'mode'
    },
    {'1': 'mode_text', '3': 7, '4': 1, '5': 9, '10': 'modeText'},
    {
      '1': 'pagination_reply',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.pagination.FeedPaginationReply',
      '10': 'paginationReply'
    },
    {'1': 'session_id', '3': 9, '4': 1, '5': 9, '10': 'sessionId'},
    {
      '1': 'subject_title',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.DetailListReply.SubjectTitle',
      '10': 'subjectTitle'
    },
  ],
  '3': [DetailListReply_SubjectTitle$json],
};

@$core.Deprecated('Use detailListReplyDescriptor instead')
const DetailListReply_SubjectTitle$json = {
  '1': 'SubjectTitle',
  '2': [
    {'1': 'left_icon', '3': 1, '4': 1, '5': 9, '10': 'leftIcon'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'link', '3': 3, '4': 1, '5': 9, '10': 'link'},
    {'1': 'rpid_mute', '3': 4, '4': 1, '5': 3, '10': 'rpidMute'},
    {
      '1': 'push_switch',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.ReplyNotificationSwitch',
      '10': 'pushSwitch'
    },
  ],
};

/// Descriptor for `DetailListReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List detailListReplyDescriptor = $convert.base64Decode(
    'Cg9EZXRhaWxMaXN0UmVwbHkSRQoGY3Vyc29yGAEgASgLMi0uYmlsaWJpbGkubWFpbi5jb21tdW'
    '5pdHkucmVwbHkudjEuQ3Vyc29yUmVwbHlSBmN1cnNvchJZCg9zdWJqZWN0X2NvbnRyb2wYAiAB'
    'KAsyMC5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5TdWJqZWN0Q29udHJvbFIOc3'
    'ViamVjdENvbnRyb2wSPwoEcm9vdBgDIAEoCzIrLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJl'
    'cGx5LnYxLlJlcGx5SW5mb1IEcm9vdBJGCghhY3Rpdml0eRgEIAEoCzIqLmJpbGliaWxpLm1haW'
    '4uY29tbXVuaXR5LnJlcGx5LnYxLkFjdGl2aXR5UghhY3Rpdml0eRJACgVsaWtlcxgFIAEoCzIq'
    'LmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLkxpa2VJbmZvUgVsaWtlcxI6CgRtb2'
    'RlGAYgASgOMiYuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuTW9kZVIEbW9kZRIb'
    'Cgltb2RlX3RleHQYByABKAlSCG1vZGVUZXh0ElMKEHBhZ2luYXRpb25fcmVwbHkYCCABKAsyKC'
    '5iaWxpYmlsaS5wYWdpbmF0aW9uLkZlZWRQYWdpbmF0aW9uUmVwbHlSD3BhZ2luYXRpb25SZXBs'
    'eRIdCgpzZXNzaW9uX2lkGAkgASgJUglzZXNzaW9uSWQSYwoNc3ViamVjdF90aXRsZRgKIAEoCz'
    'I+LmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLkRldGFpbExpc3RSZXBseS5TdWJq'
    'ZWN0VGl0bGVSDHN1YmplY3RUaXRsZRrOAQoMU3ViamVjdFRpdGxlEhsKCWxlZnRfaWNvbhgBIA'
    'EoCVIIbGVmdEljb24SFAoFdGl0bGUYAiABKAlSBXRpdGxlEhIKBGxpbmsYAyABKAlSBGxpbmsS'
    'GwoJcnBpZF9tdXRlGAQgASgDUghycGlkTXV0ZRJaCgtwdXNoX3N3aXRjaBgFIAEoDjI5LmJpbG'
    'liaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLlJlcGx5Tm90aWZpY2F0aW9uU3dpdGNoUgpw'
    'dXNoU3dpdGNo');

@$core.Deprecated('Use detailListReqDescriptor instead')
const DetailListReq$json = {
  '1': 'DetailListReq',
  '2': [
    {'1': 'oid', '3': 1, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'type', '3': 2, '4': 1, '5': 3, '10': 'type'},
    {'1': 'root', '3': 3, '4': 1, '5': 3, '10': 'root'},
    {'1': 'rpid', '3': 4, '4': 1, '5': 3, '10': 'rpid'},
    {
      '1': 'cursor',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.CursorReq',
      '10': 'cursor'
    },
    {
      '1': 'scene',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.DetailListScene',
      '10': 'scene'
    },
    {
      '1': 'mode',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.Mode',
      '10': 'mode'
    },
    {
      '1': 'pagination',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.pagination.FeedPagination',
      '10': 'pagination'
    },
    {'1': 'extra', '3': 9, '4': 1, '5': 9, '10': 'extra'},
    {'1': 'ad_extra', '3': 10, '4': 1, '5': 9, '10': 'adExtra'},
    {
      '1': 'need_subject_title',
      '3': 11,
      '4': 1,
      '5': 8,
      '10': 'needSubjectTitle'
    },
  ],
};

/// Descriptor for `DetailListReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List detailListReqDescriptor = $convert.base64Decode(
    'Cg1EZXRhaWxMaXN0UmVxEhAKA29pZBgBIAEoA1IDb2lkEhIKBHR5cGUYAiABKANSBHR5cGUSEg'
    'oEcm9vdBgDIAEoA1IEcm9vdBISCgRycGlkGAQgASgDUgRycGlkEkMKBmN1cnNvchgFIAEoCzIr'
    'LmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLkN1cnNvclJlcVIGY3Vyc29yEkcKBX'
    'NjZW5lGAYgASgOMjEuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuRGV0YWlsTGlz'
    'dFNjZW5lUgVzY2VuZRI6CgRtb2RlGAcgASgOMiYuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucm'
    'VwbHkudjEuTW9kZVIEbW9kZRJDCgpwYWdpbmF0aW9uGAggASgLMiMuYmlsaWJpbGkucGFnaW5h'
    'dGlvbi5GZWVkUGFnaW5hdGlvblIKcGFnaW5hdGlvbhIUCgVleHRyYRgJIAEoCVIFZXh0cmESGQ'
    'oIYWRfZXh0cmEYCiABKAlSB2FkRXh0cmESLAoSbmVlZF9zdWJqZWN0X3RpdGxlGAsgASgIUhBu'
    'ZWVkU3ViamVjdFRpdGxl');

@$core.Deprecated('Use dialogListReplyDescriptor instead')
const DialogListReply$json = {
  '1': 'DialogListReply',
  '2': [
    {
      '1': 'cursor',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.CursorReply',
      '10': 'cursor'
    },
    {
      '1': 'subject_control',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.SubjectControl',
      '10': 'subjectControl'
    },
    {
      '1': 'replies',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInfo',
      '10': 'replies'
    },
    {
      '1': 'activity',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Activity',
      '10': 'activity'
    },
    {
      '1': 'pagination_reply',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.pagination.FeedPaginationReply',
      '10': 'paginationReply'
    },
    {'1': 'session_id', '3': 6, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `DialogListReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dialogListReplyDescriptor = $convert.base64Decode(
    'Cg9EaWFsb2dMaXN0UmVwbHkSRQoGY3Vyc29yGAEgASgLMi0uYmlsaWJpbGkubWFpbi5jb21tdW'
    '5pdHkucmVwbHkudjEuQ3Vyc29yUmVwbHlSBmN1cnNvchJZCg9zdWJqZWN0X2NvbnRyb2wYAiAB'
    'KAsyMC5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5TdWJqZWN0Q29udHJvbFIOc3'
    'ViamVjdENvbnRyb2wSRQoHcmVwbGllcxgDIAMoCzIrLmJpbGliaWxpLm1haW4uY29tbXVuaXR5'
    'LnJlcGx5LnYxLlJlcGx5SW5mb1IHcmVwbGllcxJGCghhY3Rpdml0eRgEIAEoCzIqLmJpbGliaW'
    'xpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLkFjdGl2aXR5UghhY3Rpdml0eRJTChBwYWdpbmF0'
    'aW9uX3JlcGx5GAUgASgLMiguYmlsaWJpbGkucGFnaW5hdGlvbi5GZWVkUGFnaW5hdGlvblJlcG'
    'x5Ug9wYWdpbmF0aW9uUmVwbHkSHQoKc2Vzc2lvbl9pZBgGIAEoCVIJc2Vzc2lvbklk');

@$core.Deprecated('Use dialogListReqDescriptor instead')
const DialogListReq$json = {
  '1': 'DialogListReq',
  '2': [
    {'1': 'oid', '3': 1, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'type', '3': 2, '4': 1, '5': 3, '10': 'type'},
    {'1': 'root', '3': 3, '4': 1, '5': 3, '10': 'root'},
    {'1': 'dialog', '3': 4, '4': 1, '5': 3, '10': 'dialog'},
    {
      '1': 'cursor',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.CursorReq',
      '10': 'cursor'
    },
    {
      '1': 'pagination',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.pagination.FeedPagination',
      '10': 'pagination'
    },
    {'1': 'extra', '3': 7, '4': 1, '5': 9, '10': 'extra'},
    {'1': 'ad_extra', '3': 8, '4': 1, '5': 9, '10': 'adExtra'},
  ],
};

/// Descriptor for `DialogListReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dialogListReqDescriptor = $convert.base64Decode(
    'Cg1EaWFsb2dMaXN0UmVxEhAKA29pZBgBIAEoA1IDb2lkEhIKBHR5cGUYAiABKANSBHR5cGUSEg'
    'oEcm9vdBgDIAEoA1IEcm9vdBIWCgZkaWFsb2cYBCABKANSBmRpYWxvZxJDCgZjdXJzb3IYBSAB'
    'KAsyKy5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5DdXJzb3JSZXFSBmN1cnNvch'
    'JDCgpwYWdpbmF0aW9uGAYgASgLMiMuYmlsaWJpbGkucGFnaW5hdGlvbi5GZWVkUGFnaW5hdGlv'
    'blIKcGFnaW5hdGlvbhIUCgVleHRyYRgHIAEoCVIFZXh0cmESGQoIYWRfZXh0cmEYCCABKAlSB2'
    'FkRXh0cmE=');

@$core.Deprecated('Use doVoteReqDescriptor instead')
const DoVoteReq$json = {
  '1': 'DoVoteReq',
  '2': [
    {'1': 'oid', '3': 1, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'type', '3': 2, '4': 1, '5': 3, '10': 'type'},
    {'1': 'vote_id', '3': 3, '4': 1, '5': 3, '10': 'voteId'},
    {'1': 'option', '3': 4, '4': 1, '5': 3, '10': 'option'},
  ],
};

/// Descriptor for `DoVoteReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List doVoteReqDescriptor = $convert.base64Decode(
    'CglEb1ZvdGVSZXESEAoDb2lkGAEgASgDUgNvaWQSEgoEdHlwZRgCIAEoA1IEdHlwZRIXCgd2b3'
    'RlX2lkGAMgASgDUgZ2b3RlSWQSFgoGb3B0aW9uGAQgASgDUgZvcHRpb24=');

@$core.Deprecated('Use doVoteRespDescriptor instead')
const DoVoteResp$json = {
  '1': 'DoVoteResp',
};

/// Descriptor for `DoVoteResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List doVoteRespDescriptor =
    $convert.base64Decode('CgpEb1ZvdGVSZXNw');

@$core.Deprecated('Use eSportsGradeCardDescriptor instead')
const ESportsGradeCard$json = {
  '1': 'ESportsGradeCard',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'image', '3': 3, '4': 1, '5': 9, '10': 'image'},
    {'1': 'link', '3': 4, '4': 1, '5': 9, '10': 'link'},
  ],
};

/// Descriptor for `ESportsGradeCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eSportsGradeCardDescriptor = $convert.base64Decode(
    'ChBFU3BvcnRzR3JhZGVDYXJkEhQKBXRpdGxlGAEgASgJUgV0aXRsZRIgCgtkZXNjcmlwdGlvbh'
    'gCIAEoCVILZGVzY3JpcHRpb24SFAoFaW1hZ2UYAyABKAlSBWltYWdlEhIKBGxpbmsYBCABKAlS'
    'BGxpbms=');

@$core.Deprecated('Use effectsDescriptor instead')
const Effects$json = {
  '1': 'Effects',
  '2': [
    {'1': 'preloading', '3': 1, '4': 1, '5': 9, '10': 'preloading'},
  ],
};

/// Descriptor for `Effects`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List effectsDescriptor = $convert
    .base64Decode('CgdFZmZlY3RzEh4KCnByZWxvYWRpbmcYASABKAlSCnByZWxvYWRpbmc=');

@$core.Deprecated('Use emoteDescriptor instead')
const Emote$json = {
  '1': 'Emote',
  '2': [
    {'1': 'size', '3': 1, '4': 1, '5': 3, '10': 'size'},
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
    {'1': 'jump_url', '3': 3, '4': 1, '5': 9, '10': 'jumpUrl'},
    {'1': 'jump_title', '3': 4, '4': 1, '5': 9, '10': 'jumpTitle'},
    {'1': 'id', '3': 5, '4': 1, '5': 3, '10': 'id'},
    {'1': 'package_id', '3': 6, '4': 1, '5': 3, '10': 'packageId'},
    {'1': 'gif_url', '3': 7, '4': 1, '5': 9, '10': 'gifUrl'},
    {'1': 'text', '3': 8, '4': 1, '5': 9, '10': 'text'},
    {'1': 'webp_url', '3': 9, '4': 1, '5': 9, '10': 'webpUrl'},
  ],
};

/// Descriptor for `Emote`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emoteDescriptor = $convert.base64Decode(
    'CgVFbW90ZRISCgRzaXplGAEgASgDUgRzaXplEhAKA3VybBgCIAEoCVIDdXJsEhkKCGp1bXBfdX'
    'JsGAMgASgJUgdqdW1wVXJsEh0KCmp1bXBfdGl0bGUYBCABKAlSCWp1bXBUaXRsZRIOCgJpZBgF'
    'IAEoA1ICaWQSHQoKcGFja2FnZV9pZBgGIAEoA1IJcGFja2FnZUlkEhcKB2dpZl91cmwYByABKA'
    'lSBmdpZlVybBISCgR0ZXh0GAggASgJUgR0ZXh0EhkKCHdlYnBfdXJsGAkgASgJUgd3ZWJwVXJs');

@$core.Deprecated('Use emptyPageDescriptor instead')
const EmptyPage$json = {
  '1': 'EmptyPage',
  '2': [
    {'1': 'image_url', '3': 1, '4': 1, '5': 9, '10': 'imageUrl'},
    {
      '1': 'texts',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.EmptyPage.Text',
      '10': 'texts'
    },
    {
      '1': 'left_button',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.EmptyPage.Button',
      '10': 'leftButton'
    },
    {
      '1': 'right_button',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.EmptyPage.Button',
      '10': 'rightButton'
    },
  ],
  '3': [EmptyPage_Button$json, EmptyPage_Text$json],
  '4': [EmptyPage_Action$json],
};

@$core.Deprecated('Use emptyPageDescriptor instead')
const EmptyPage_Button$json = {
  '1': 'Button',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'action',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.EmptyPage.Action',
      '10': 'action'
    },
  ],
};

@$core.Deprecated('Use emptyPageDescriptor instead')
const EmptyPage_Text$json = {
  '1': 'Text',
  '2': [
    {'1': 'raw', '3': 1, '4': 1, '5': 9, '10': 'raw'},
    {
      '1': 'style',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.TextStyle',
      '10': 'style'
    },
    {
      '1': 'action',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.EmptyPage.Action',
      '10': 'action'
    },
  ],
};

@$core.Deprecated('Use emptyPageDescriptor instead')
const EmptyPage_Action$json = {
  '1': 'Action',
  '2': [
    {'1': 'UNAVAILABLE', '2': 0},
    {'1': 'SHOW_KEYBOARD', '2': 1},
    {'1': 'SEND_REPLY_WITH_BOLD_TEXT', '2': 2},
  ],
};

/// Descriptor for `EmptyPage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyPageDescriptor = $convert.base64Decode(
    'CglFbXB0eVBhZ2USGwoJaW1hZ2VfdXJsGAEgASgJUghpbWFnZVVybBJGCgV0ZXh0cxgCIAMoCz'
    'IwLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLkVtcHR5UGFnZS5UZXh0UgV0ZXh0'
    'cxJTCgtsZWZ0X2J1dHRvbhgDIAEoCzIyLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5Ln'
    'YxLkVtcHR5UGFnZS5CdXR0b25SCmxlZnRCdXR0b24SVQoMcmlnaHRfYnV0dG9uGAQgASgLMjIu'
    'YmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuRW1wdHlQYWdlLkJ1dHRvblILcmlnaH'
    'RCdXR0b24aagoGQnV0dG9uEhQKBXRpdGxlGAEgASgJUgV0aXRsZRJKCgZhY3Rpb24YAiABKA4y'
    'Mi5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5FbXB0eVBhZ2UuQWN0aW9uUgZhY3'
    'Rpb24apwEKBFRleHQSEAoDcmF3GAEgASgJUgNyYXcSQQoFc3R5bGUYAiABKAsyKy5iaWxpYmls'
    'aS5tYWluLmNvbW11bml0eS5yZXBseS52MS5UZXh0U3R5bGVSBXN0eWxlEkoKBmFjdGlvbhgDIA'
    'EoDjIyLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLkVtcHR5UGFnZS5BY3Rpb25S'
    'BmFjdGlvbiJLCgZBY3Rpb24SDwoLVU5BVkFJTEFCTEUQABIRCg1TSE9XX0tFWUJPQVJEEAESHQ'
    'oZU0VORF9SRVBMWV9XSVRIX0JPTERfVEVYVBAC');

@$core.Deprecated('Use formDescriptor instead')
const Form$json = {
  '1': 'Form',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 5, '10': 'type'},
    {
      '1': 'options',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.QoeOption',
      '10': 'options'
    },
  ],
};

/// Descriptor for `Form`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List formDescriptor = $convert.base64Decode(
    'CgRGb3JtEhIKBHR5cGUYASABKAVSBHR5cGUSRQoHb3B0aW9ucxgCIAMoCzIrLmJpbGliaWxpLm'
    '1haW4uY29tbXVuaXR5LnJlcGx5LnYxLlFvZU9wdGlvblIHb3B0aW9ucw==');

@$core.Deprecated('Use goodsSearchItemDescriptor instead')
const GoodsSearchItem$json = {
  '1': 'GoodsSearchItem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'price', '3': 3, '4': 1, '5': 9, '10': 'price'},
    {'1': 'income', '3': 4, '4': 1, '5': 9, '10': 'income'},
    {'1': 'img', '3': 5, '4': 1, '5': 9, '10': 'img'},
    {'1': 'label', '3': 6, '4': 1, '5': 9, '10': 'label'},
  ],
};

/// Descriptor for `GoodsSearchItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List goodsSearchItemDescriptor = $convert.base64Decode(
    'Cg9Hb29kc1NlYXJjaEl0ZW0SDgoCaWQYASABKANSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSFA'
    'oFcHJpY2UYAyABKAlSBXByaWNlEhYKBmluY29tZRgEIAEoCVIGaW5jb21lEhAKA2ltZxgFIAEo'
    'CVIDaW1nEhQKBWxhYmVsGAYgASgJUgVsYWJlbA==');

@$core.Deprecated('Use likeInfoDescriptor instead')
const LikeInfo$json = {
  '1': 'LikeInfo',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.LikeInfo.Item',
      '10': 'items'
    },
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
  ],
  '3': [LikeInfo_Item$json],
};

@$core.Deprecated('Use likeInfoDescriptor instead')
const LikeInfo_Item$json = {
  '1': 'Item',
  '2': [
    {
      '1': 'member',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Member',
      '10': 'member'
    },
  ],
};

/// Descriptor for `LikeInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List likeInfoDescriptor = $convert.base64Decode(
    'CghMaWtlSW5mbxJFCgVpdGVtcxgBIAMoCzIvLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcG'
    'x5LnYxLkxpa2VJbmZvLkl0ZW1SBWl0ZW1zEhQKBXRpdGxlGAIgASgJUgV0aXRsZRpICgRJdGVt'
    'EkAKBm1lbWJlchgBIAEoCzIoLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLk1lbW'
    'JlclIGbWVtYmVy');

@$core.Deprecated('Use lotteryDescriptor instead')
const Lottery$json = {
  '1': 'Lottery',
  '2': [
    {'1': 'lottery_id', '3': 1, '4': 1, '5': 3, '10': 'lotteryId'},
    {'1': 'lottery_status', '3': 2, '4': 1, '5': 3, '10': 'lotteryStatus'},
    {'1': 'lottery_mid', '3': 3, '4': 1, '5': 3, '10': 'lotteryMid'},
    {'1': 'lottery_time', '3': 4, '4': 1, '5': 3, '10': 'lotteryTime'},
    {'1': 'oid', '3': 5, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'type', '3': 6, '4': 1, '5': 3, '10': 'type'},
    {'1': 'ctime', '3': 7, '4': 1, '5': 3, '10': 'ctime'},
    {
      '1': 'content',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Content',
      '10': 'content'
    },
    {
      '1': 'member',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Member',
      '10': 'member'
    },
    {
      '1': 'reply_control',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyControl',
      '10': 'replyControl'
    },
  ],
};

/// Descriptor for `Lottery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lotteryDescriptor = $convert.base64Decode(
    'CgdMb3R0ZXJ5Eh0KCmxvdHRlcnlfaWQYASABKANSCWxvdHRlcnlJZBIlCg5sb3R0ZXJ5X3N0YX'
    'R1cxgCIAEoA1INbG90dGVyeVN0YXR1cxIfCgtsb3R0ZXJ5X21pZBgDIAEoA1IKbG90dGVyeU1p'
    'ZBIhCgxsb3R0ZXJ5X3RpbWUYBCABKANSC2xvdHRlcnlUaW1lEhAKA29pZBgFIAEoA1IDb2lkEh'
    'IKBHR5cGUYBiABKANSBHR5cGUSFAoFY3RpbWUYByABKANSBWN0aW1lEkMKB2NvbnRlbnQYCCAB'
    'KAsyKS5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5Db250ZW50Ugdjb250ZW50Ek'
    'AKBm1lbWJlchgJIAEoCzIoLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLk1lbWJl'
    'clIGbWVtYmVyElMKDXJlcGx5X2NvbnRyb2wYCiABKAsyLi5iaWxpYmlsaS5tYWluLmNvbW11bm'
    'l0eS5yZXBseS52MS5SZXBseUNvbnRyb2xSDHJlcGx5Q29udHJvbA==');

@$core.Deprecated('Use mainListReplyDescriptor instead')
const MainListReply$json = {
  '1': 'MainListReply',
  '2': [
    {
      '1': 'cursor',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.CursorReply',
      '10': 'cursor'
    },
    {
      '1': 'replies',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInfo',
      '10': 'replies'
    },
    {
      '1': 'subject_control',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.SubjectControl',
      '10': 'subjectControl'
    },
    {
      '1': 'up_top',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInfo',
      '10': 'upTop'
    },
    {
      '1': 'admin_top',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInfo',
      '10': 'adminTop'
    },
    {
      '1': 'vote_top',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInfo',
      '10': 'voteTop'
    },
    {
      '1': 'notice',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Notice',
      '10': 'notice'
    },
    {
      '1': 'lottery',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Lottery',
      '10': 'lottery'
    },
    {
      '1': 'activity',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Activity',
      '10': 'activity'
    },
    {
      '1': 'up_selection',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.UpSelection',
      '10': 'upSelection'
    },
    {
      '1': 'cm',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.CM',
      '10': 'cm'
    },
    {
      '1': 'effects',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Effects',
      '10': 'effects'
    },
    {
      '1': 'operation',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Operation',
      '10': 'operation'
    },
    {
      '1': 'top_replies',
      '3': 14,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInfo',
      '10': 'topReplies'
    },
    {
      '1': 'qoe',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.QoeInfo',
      '10': 'qoe'
    },
    {
      '1': 'callbacks',
      '3': 16,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.MainListReply.CallbacksEntry',
      '10': 'callbacks'
    },
    {
      '1': 'operation_v2',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.OperationV2',
      '10': 'operationV2'
    },
    {
      '1': 'mode',
      '3': 18,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.Mode',
      '10': 'mode'
    },
    {'1': 'mode_text', '3': 19, '4': 1, '5': 9, '10': 'modeText'},
    {
      '1': 'pagination_reply',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.bilibili.pagination.FeedPaginationReply',
      '10': 'paginationReply'
    },
    {'1': 'session_id', '3': 21, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'report_params', '3': 22, '4': 1, '5': 9, '10': 'reportParams'},
    {
      '1': 'vote_card',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.VoteCard',
      '10': 'voteCard'
    },
    {
      '1': 'esports_grade_card',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ESportsGradeCard',
      '10': 'esportsGradeCard'
    },
    {'1': 'context_feature', '3': 25, '4': 1, '5': 9, '10': 'contextFeature'},
    {
      '1': 'pagination_end_text',
      '3': 26,
      '4': 1,
      '5': 9,
      '10': 'paginationEndText'
    },
    {
      '1': 'mixed_cards',
      '3': 27,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.MixedCard',
      '10': 'mixedCards'
    },
    {
      '1': 'subject_top_cards',
      '3': 28,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.SubjectTopCards',
      '10': 'subjectTopCards'
    },
  ],
  '3': [MainListReply_CallbacksEntry$json],
};

@$core.Deprecated('Use mainListReplyDescriptor instead')
const MainListReply_CallbacksEntry$json = {
  '1': 'CallbacksEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `MainListReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mainListReplyDescriptor = $convert.base64Decode(
    'Cg1NYWluTGlzdFJlcGx5EkUKBmN1cnNvchgBIAEoCzItLmJpbGliaWxpLm1haW4uY29tbXVuaX'
    'R5LnJlcGx5LnYxLkN1cnNvclJlcGx5UgZjdXJzb3ISRQoHcmVwbGllcxgCIAMoCzIrLmJpbGli'
    'aWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLlJlcGx5SW5mb1IHcmVwbGllcxJZCg9zdWJqZW'
    'N0X2NvbnRyb2wYAyABKAsyMC5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5TdWJq'
    'ZWN0Q29udHJvbFIOc3ViamVjdENvbnRyb2wSQgoGdXBfdG9wGAQgASgLMisuYmlsaWJpbGkubW'
    'Fpbi5jb21tdW5pdHkucmVwbHkudjEuUmVwbHlJbmZvUgV1cFRvcBJICglhZG1pbl90b3AYBSAB'
    'KAsyKy5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5SZXBseUluZm9SCGFkbWluVG'
    '9wEkYKCHZvdGVfdG9wGAYgASgLMisuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEu'
    'UmVwbHlJbmZvUgd2b3RlVG9wEkAKBm5vdGljZRgHIAEoCzIoLmJpbGliaWxpLm1haW4uY29tbX'
    'VuaXR5LnJlcGx5LnYxLk5vdGljZVIGbm90aWNlEkMKB2xvdHRlcnkYCCABKAsyKS5iaWxpYmls'
    'aS5tYWluLmNvbW11bml0eS5yZXBseS52MS5Mb3R0ZXJ5Ugdsb3R0ZXJ5EkYKCGFjdGl2aXR5GA'
    'kgASgLMiouYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuQWN0aXZpdHlSCGFjdGl2'
    'aXR5ElAKDHVwX3NlbGVjdGlvbhgKIAEoCzItLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcG'
    'x5LnYxLlVwU2VsZWN0aW9uUgt1cFNlbGVjdGlvbhI0CgJjbRgLIAEoCzIkLmJpbGliaWxpLm1h'
    'aW4uY29tbXVuaXR5LnJlcGx5LnYxLkNNUgJjbRJDCgdlZmZlY3RzGAwgASgLMikuYmlsaWJpbG'
    'kubWFpbi5jb21tdW5pdHkucmVwbHkudjEuRWZmZWN0c1IHZWZmZWN0cxJJCglvcGVyYXRpb24Y'
    'DSABKAsyKy5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5PcGVyYXRpb25SCW9wZX'
    'JhdGlvbhJMCgt0b3BfcmVwbGllcxgOIAMoCzIrLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJl'
    'cGx5LnYxLlJlcGx5SW5mb1IKdG9wUmVwbGllcxI7CgNxb2UYDyABKAsyKS5iaWxpYmlsaS5tYW'
    'luLmNvbW11bml0eS5yZXBseS52MS5Rb2VJbmZvUgNxb2USXAoJY2FsbGJhY2tzGBAgAygLMj4u'
    'YmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuTWFpbkxpc3RSZXBseS5DYWxsYmFja3'
    'NFbnRyeVIJY2FsbGJhY2tzElAKDG9wZXJhdGlvbl92MhgRIAEoCzItLmJpbGliaWxpLm1haW4u'
    'Y29tbXVuaXR5LnJlcGx5LnYxLk9wZXJhdGlvblYyUgtvcGVyYXRpb25WMhI6CgRtb2RlGBIgAS'
    'gOMiYuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuTW9kZVIEbW9kZRIbCgltb2Rl'
    'X3RleHQYEyABKAlSCG1vZGVUZXh0ElMKEHBhZ2luYXRpb25fcmVwbHkYFCABKAsyKC5iaWxpYm'
    'lsaS5wYWdpbmF0aW9uLkZlZWRQYWdpbmF0aW9uUmVwbHlSD3BhZ2luYXRpb25SZXBseRIdCgpz'
    'ZXNzaW9uX2lkGBUgASgJUglzZXNzaW9uSWQSIwoNcmVwb3J0X3BhcmFtcxgWIAEoCVIMcmVwb3'
    'J0UGFyYW1zEkcKCXZvdGVfY2FyZBgXIAEoCzIqLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJl'
    'cGx5LnYxLlZvdGVDYXJkUgh2b3RlQ2FyZBJgChJlc3BvcnRzX2dyYWRlX2NhcmQYGCABKAsyMi'
    '5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5FU3BvcnRzR3JhZGVDYXJkUhBlc3Bv'
    'cnRzR3JhZGVDYXJkEicKD2NvbnRleHRfZmVhdHVyZRgZIAEoCVIOY29udGV4dEZlYXR1cmUSLg'
    'oTcGFnaW5hdGlvbl9lbmRfdGV4dBgaIAEoCVIRcGFnaW5hdGlvbkVuZFRleHQSTAoLbWl4ZWRf'
    'Y2FyZHMYGyADKAsyKy5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5NaXhlZENhcm'
    'RSCm1peGVkQ2FyZHMSXQoRc3ViamVjdF90b3BfY2FyZHMYHCADKAsyMS5iaWxpYmlsaS5tYWlu'
    'LmNvbW11bml0eS5yZXBseS52MS5TdWJqZWN0VG9wQ2FyZHNSD3N1YmplY3RUb3BDYXJkcxo8Cg'
    '5DYWxsYmFja3NFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoBVIFdmFsdWU6'
    'AjgB');

@$core.Deprecated('Use mainListReqDescriptor instead')
const MainListReq$json = {
  '1': 'MainListReq',
  '2': [
    {'1': 'oid', '3': 1, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'type', '3': 2, '4': 1, '5': 3, '10': 'type'},
    {
      '1': 'cursor',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.CursorReq',
      '10': 'cursor'
    },
    {'1': 'extra', '3': 4, '4': 1, '5': 9, '10': 'extra'},
    {'1': 'ad_extra', '3': 5, '4': 1, '5': 9, '10': 'adExtra'},
    {'1': 'rpid', '3': 6, '4': 1, '5': 3, '10': 'rpid'},
    {'1': 'seek_rpid', '3': 7, '4': 1, '5': 3, '10': 'seekRpid'},
    {'1': 'filter_tag_name', '3': 8, '4': 1, '5': 9, '10': 'filterTagName'},
    {
      '1': 'mode',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.Mode',
      '10': 'mode'
    },
    {
      '1': 'pagination',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.bilibili.pagination.FeedPagination',
      '10': 'pagination'
    },
    {
      '1': 'client_recall_rpids',
      '3': 11,
      '4': 3,
      '5': 3,
      '10': 'clientRecallRpids'
    },
    {
      '1': 'word_search_param',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.WordSearchParam',
      '10': 'wordSearchParam'
    },
  ],
};

/// Descriptor for `MainListReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mainListReqDescriptor = $convert.base64Decode(
    'CgtNYWluTGlzdFJlcRIQCgNvaWQYASABKANSA29pZBISCgR0eXBlGAIgASgDUgR0eXBlEkMKBm'
    'N1cnNvchgDIAEoCzIrLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLkN1cnNvclJl'
    'cVIGY3Vyc29yEhQKBWV4dHJhGAQgASgJUgVleHRyYRIZCghhZF9leHRyYRgFIAEoCVIHYWRFeH'
    'RyYRISCgRycGlkGAYgASgDUgRycGlkEhsKCXNlZWtfcnBpZBgHIAEoA1IIc2Vla1JwaWQSJgoP'
    'ZmlsdGVyX3RhZ19uYW1lGAggASgJUg1maWx0ZXJUYWdOYW1lEjoKBG1vZGUYCSABKA4yJi5iaW'
    'xpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5Nb2RlUgRtb2RlEkMKCnBhZ2luYXRpb24Y'
    'CiABKAsyIy5iaWxpYmlsaS5wYWdpbmF0aW9uLkZlZWRQYWdpbmF0aW9uUgpwYWdpbmF0aW9uEi'
    '4KE2NsaWVudF9yZWNhbGxfcnBpZHMYCyADKANSEWNsaWVudFJlY2FsbFJwaWRzEl0KEXdvcmRf'
    'c2VhcmNoX3BhcmFtGAwgASgLMjEuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuV2'
    '9yZFNlYXJjaFBhcmFtUg93b3JkU2VhcmNoUGFyYW0=');

@$core.Deprecated('Use memberDescriptor instead')
const Member$json = {
  '1': 'Member',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'sex', '3': 3, '4': 1, '5': 9, '10': 'sex'},
    {'1': 'face', '3': 4, '4': 1, '5': 9, '10': 'face'},
    {'1': 'level', '3': 5, '4': 1, '5': 3, '10': 'level'},
    {
      '1': 'official_verify_type',
      '3': 6,
      '4': 1,
      '5': 3,
      '10': 'officialVerifyType'
    },
    {'1': 'vip_type', '3': 7, '4': 1, '5': 3, '10': 'vipType'},
    {'1': 'vip_status', '3': 8, '4': 1, '5': 3, '10': 'vipStatus'},
    {'1': 'vip_theme_type', '3': 9, '4': 1, '5': 3, '10': 'vipThemeType'},
    {'1': 'vip_label_path', '3': 10, '4': 1, '5': 9, '10': 'vipLabelPath'},
    {
      '1': 'garb_pendant_image',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'garbPendantImage'
    },
    {'1': 'garb_card_image', '3': 12, '4': 1, '5': 9, '10': 'garbCardImage'},
    {
      '1': 'garb_card_image_with_focus',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'garbCardImageWithFocus'
    },
    {
      '1': 'garb_card_jump_url',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'garbCardJumpUrl'
    },
    {'1': 'garb_card_number', '3': 15, '4': 1, '5': 9, '10': 'garbCardNumber'},
    {
      '1': 'garb_card_fan_color',
      '3': 16,
      '4': 1,
      '5': 9,
      '10': 'garbCardFanColor'
    },
    {'1': 'garb_card_is_fan', '3': 17, '4': 1, '5': 8, '10': 'garbCardIsFan'},
    {'1': 'fans_medal_name', '3': 18, '4': 1, '5': 9, '10': 'fansMedalName'},
    {'1': 'fans_medal_level', '3': 19, '4': 1, '5': 3, '10': 'fansMedalLevel'},
    {'1': 'fans_medal_color', '3': 20, '4': 1, '5': 3, '10': 'fansMedalColor'},
    {
      '1': 'vip_nickname_color',
      '3': 21,
      '4': 1,
      '5': 9,
      '10': 'vipNicknameColor'
    },
    {
      '1': 'vip_avatar_subscript',
      '3': 22,
      '4': 1,
      '5': 5,
      '10': 'vipAvatarSubscript'
    },
    {'1': 'vip_label_text', '3': 23, '4': 1, '5': 9, '10': 'vipLabelText'},
    {'1': 'vip_label_theme', '3': 24, '4': 1, '5': 9, '10': 'vipLabelTheme'},
    {
      '1': 'fans_medal_color_end',
      '3': 25,
      '4': 1,
      '5': 3,
      '10': 'fansMedalColorEnd'
    },
    {
      '1': 'fans_medal_color_border',
      '3': 26,
      '4': 1,
      '5': 3,
      '10': 'fansMedalColorBorder'
    },
    {
      '1': 'fans_medal_color_name',
      '3': 27,
      '4': 1,
      '5': 3,
      '10': 'fansMedalColorName'
    },
    {
      '1': 'fans_medal_color_level',
      '3': 28,
      '4': 1,
      '5': 3,
      '10': 'fansMedalColorLevel'
    },
    {'1': 'fans_guard_level', '3': 29, '4': 1, '5': 3, '10': 'fansGuardLevel'},
    {'1': 'face_nft', '3': 30, '4': 1, '5': 5, '10': 'faceNft'},
    {'1': 'face_nft_new', '3': 31, '4': 1, '5': 5, '10': 'faceNftNew'},
    {'1': 'is_senior_member', '3': 32, '4': 1, '5': 5, '10': 'isSeniorMember'},
    {
      '1': 'nft_interaction',
      '3': 33,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Member.NftInteraction',
      '10': 'nftInteraction'
    },
    {'1': 'fans_guard_icon', '3': 34, '4': 1, '5': 9, '10': 'fansGuardIcon'},
    {'1': 'fans_honor_icon', '3': 35, '4': 1, '5': 9, '10': 'fansHonorIcon'},
  ],
  '3': [Member_NftInteraction$json],
};

@$core.Deprecated('Use memberDescriptor instead')
const Member_NftInteraction$json = {
  '1': 'NftInteraction',
  '2': [
    {'1': 'itype', '3': 1, '4': 1, '5': 9, '10': 'itype'},
    {'1': 'metadata_url', '3': 2, '4': 1, '5': 9, '10': 'metadataUrl'},
    {'1': 'nft_id', '3': 3, '4': 1, '5': 9, '10': 'nftId'},
    {
      '1': 'region',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Member.NftInteraction.Region',
      '10': 'region'
    },
  ],
  '3': [Member_NftInteraction_Region$json],
  '4': [
    Member_NftInteraction_RegionType$json,
    Member_NftInteraction_ShowStatus$json
  ],
};

@$core.Deprecated('Use memberDescriptor instead')
const Member_NftInteraction_Region$json = {
  '1': 'Region',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.Member.NftInteraction.RegionType',
      '10': 'type'
    },
    {'1': 'icon', '3': 2, '4': 1, '5': 9, '10': 'icon'},
    {
      '1': 'show_status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.Member.NftInteraction.ShowStatus',
      '10': 'showStatus'
    },
  ],
};

@$core.Deprecated('Use memberDescriptor instead')
const Member_NftInteraction_RegionType$json = {
  '1': 'RegionType',
  '2': [
    {'1': 'DEFAULT', '2': 0},
    {'1': 'MAINLAND', '2': 1},
    {'1': 'GAT', '2': 2},
  ],
};

@$core.Deprecated('Use memberDescriptor instead')
const Member_NftInteraction_ShowStatus$json = {
  '1': 'ShowStatus',
  '2': [
    {'1': 'SHOWDEFAULT', '2': 0},
    {'1': 'ZOOMINMAINLAND', '2': 1},
    {'1': 'RAW', '2': 2},
  ],
};

/// Descriptor for `Member`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memberDescriptor = $convert.base64Decode(
    'CgZNZW1iZXISEAoDbWlkGAEgASgDUgNtaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIQCgNzZXgYAy'
    'ABKAlSA3NleBISCgRmYWNlGAQgASgJUgRmYWNlEhQKBWxldmVsGAUgASgDUgVsZXZlbBIwChRv'
    'ZmZpY2lhbF92ZXJpZnlfdHlwZRgGIAEoA1ISb2ZmaWNpYWxWZXJpZnlUeXBlEhkKCHZpcF90eX'
    'BlGAcgASgDUgd2aXBUeXBlEh0KCnZpcF9zdGF0dXMYCCABKANSCXZpcFN0YXR1cxIkCg52aXBf'
    'dGhlbWVfdHlwZRgJIAEoA1IMdmlwVGhlbWVUeXBlEiQKDnZpcF9sYWJlbF9wYXRoGAogASgJUg'
    'x2aXBMYWJlbFBhdGgSLAoSZ2FyYl9wZW5kYW50X2ltYWdlGAsgASgJUhBnYXJiUGVuZGFudElt'
    'YWdlEiYKD2dhcmJfY2FyZF9pbWFnZRgMIAEoCVINZ2FyYkNhcmRJbWFnZRI6ChpnYXJiX2Nhcm'
    'RfaW1hZ2Vfd2l0aF9mb2N1cxgNIAEoCVIWZ2FyYkNhcmRJbWFnZVdpdGhGb2N1cxIrChJnYXJi'
    'X2NhcmRfanVtcF91cmwYDiABKAlSD2dhcmJDYXJkSnVtcFVybBIoChBnYXJiX2NhcmRfbnVtYm'
    'VyGA8gASgJUg5nYXJiQ2FyZE51bWJlchItChNnYXJiX2NhcmRfZmFuX2NvbG9yGBAgASgJUhBn'
    'YXJiQ2FyZEZhbkNvbG9yEicKEGdhcmJfY2FyZF9pc19mYW4YESABKAhSDWdhcmJDYXJkSXNGYW'
    '4SJgoPZmFuc19tZWRhbF9uYW1lGBIgASgJUg1mYW5zTWVkYWxOYW1lEigKEGZhbnNfbWVkYWxf'
    'bGV2ZWwYEyABKANSDmZhbnNNZWRhbExldmVsEigKEGZhbnNfbWVkYWxfY29sb3IYFCABKANSDm'
    'ZhbnNNZWRhbENvbG9yEiwKEnZpcF9uaWNrbmFtZV9jb2xvchgVIAEoCVIQdmlwTmlja25hbWVD'
    'b2xvchIwChR2aXBfYXZhdGFyX3N1YnNjcmlwdBgWIAEoBVISdmlwQXZhdGFyU3Vic2NyaXB0Ei'
    'QKDnZpcF9sYWJlbF90ZXh0GBcgASgJUgx2aXBMYWJlbFRleHQSJgoPdmlwX2xhYmVsX3RoZW1l'
    'GBggASgJUg12aXBMYWJlbFRoZW1lEi8KFGZhbnNfbWVkYWxfY29sb3JfZW5kGBkgASgDUhFmYW'
    '5zTWVkYWxDb2xvckVuZBI1ChdmYW5zX21lZGFsX2NvbG9yX2JvcmRlchgaIAEoA1IUZmFuc01l'
    'ZGFsQ29sb3JCb3JkZXISMQoVZmFuc19tZWRhbF9jb2xvcl9uYW1lGBsgASgDUhJmYW5zTWVkYW'
    'xDb2xvck5hbWUSMwoWZmFuc19tZWRhbF9jb2xvcl9sZXZlbBgcIAEoA1ITZmFuc01lZGFsQ29s'
    'b3JMZXZlbBIoChBmYW5zX2d1YXJkX2xldmVsGB0gASgDUg5mYW5zR3VhcmRMZXZlbBIZCghmYW'
    'NlX25mdBgeIAEoBVIHZmFjZU5mdBIgCgxmYWNlX25mdF9uZXcYHyABKAVSCmZhY2VOZnROZXcS'
    'KAoQaXNfc2VuaW9yX21lbWJlchggIAEoBVIOaXNTZW5pb3JNZW1iZXISYAoPbmZ0X2ludGVyYW'
    'N0aW9uGCEgASgLMjcuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuTWVtYmVyLk5m'
    'dEludGVyYWN0aW9uUg5uZnRJbnRlcmFjdGlvbhImCg9mYW5zX2d1YXJkX2ljb24YIiABKAlSDW'
    'ZhbnNHdWFyZEljb24SJgoPZmFuc19ob25vcl9pY29uGCMgASgJUg1mYW5zSG9ub3JJY29uGoIE'
    'Cg5OZnRJbnRlcmFjdGlvbhIUCgVpdHlwZRgBIAEoCVIFaXR5cGUSIQoMbWV0YWRhdGFfdXJsGA'
    'IgASgJUgttZXRhZGF0YVVybBIVCgZuZnRfaWQYAyABKAlSBW5mdElkElYKBnJlZ2lvbhgEIAEo'
    'CzI+LmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLk1lbWJlci5OZnRJbnRlcmFjdG'
    'lvbi5SZWdpb25SBnJlZ2lvbhrZAQoGUmVnaW9uElYKBHR5cGUYASABKA4yQi5iaWxpYmlsaS5t'
    'YWluLmNvbW11bml0eS5yZXBseS52MS5NZW1iZXIuTmZ0SW50ZXJhY3Rpb24uUmVnaW9uVHlwZV'
    'IEdHlwZRISCgRpY29uGAIgASgJUgRpY29uEmMKC3Nob3dfc3RhdHVzGAMgASgOMkIuYmlsaWJp'
    'bGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuTWVtYmVyLk5mdEludGVyYWN0aW9uLlNob3dTdG'
    'F0dXNSCnNob3dTdGF0dXMiMAoKUmVnaW9uVHlwZRILCgdERUZBVUxUEAASDAoITUFJTkxBTkQQ'
    'ARIHCgNHQVQQAiI6CgpTaG93U3RhdHVzEg8KC1NIT1dERUZBVUxUEAASEgoOWk9PTUlOTUFJTk'
    'xBTkQQARIHCgNSQVcQAg==');

@$core.Deprecated('Use memberV2Descriptor instead')
const MemberV2$json = {
  '1': 'MemberV2',
  '2': [
    {
      '1': 'basic',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.MemberV2.Basic',
      '10': 'basic'
    },
    {
      '1': 'official',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.MemberV2.Official',
      '10': 'official'
    },
    {
      '1': 'vip',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.MemberV2.Vip',
      '10': 'vip'
    },
    {
      '1': 'garb',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.MemberV2.Garb',
      '10': 'garb'
    },
    {
      '1': 'medal',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.MemberV2.Medal',
      '10': 'medal'
    },
    {
      '1': 'nft',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.MemberV2.Nft',
      '10': 'nft'
    },
    {
      '1': 'senior',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.MemberV2.Senior',
      '10': 'senior'
    },
    {
      '1': 'contractor',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.MemberV2.Contractor',
      '10': 'contractor'
    },
    {
      '1': 'user_sailing',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.vas.garb.model.UserSailing',
      '10': 'userSailing'
    },
  ],
  '3': [
    MemberV2_Basic$json,
    MemberV2_Contractor$json,
    MemberV2_Garb$json,
    MemberV2_Medal$json,
    MemberV2_Nft$json,
    MemberV2_Official$json,
    MemberV2_Senior$json,
    MemberV2_Vip$json
  ],
};

@$core.Deprecated('Use memberV2Descriptor instead')
const MemberV2_Basic$json = {
  '1': 'Basic',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'sex', '3': 3, '4': 1, '5': 9, '10': 'sex'},
    {'1': 'face', '3': 4, '4': 1, '5': 9, '10': 'face'},
    {'1': 'level', '3': 5, '4': 1, '5': 3, '10': 'level'},
    {
      '1': 'avatar_item',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.dagw.component.avatar.v1.AvatarItem',
      '10': 'avatarItem'
    },
    {
      '1': 'name_render',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.account.service.v1.NameRender',
      '10': 'nameRender'
    },
  ],
};

@$core.Deprecated('Use memberV2Descriptor instead')
const MemberV2_Contractor$json = {
  '1': 'Contractor',
  '2': [
    {'1': 'is_contractor', '3': 1, '4': 1, '5': 8, '10': 'isContractor'},
    {'1': 'contract_desc', '3': 2, '4': 1, '5': 9, '10': 'contractDesc'},
  ],
};

@$core.Deprecated('Use memberV2Descriptor instead')
const MemberV2_Garb$json = {
  '1': 'Garb',
  '2': [
    {'1': 'pendant_image', '3': 1, '4': 1, '5': 9, '10': 'pendantImage'},
    {'1': 'card_image', '3': 2, '4': 1, '5': 9, '10': 'cardImage'},
    {
      '1': 'card_image_with_focus',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'cardImageWithFocus'
    },
    {'1': 'card_jump_url', '3': 4, '4': 1, '5': 9, '10': 'cardJumpUrl'},
    {'1': 'card_number', '3': 5, '4': 1, '5': 9, '10': 'cardNumber'},
    {'1': 'card_fan_color', '3': 6, '4': 1, '5': 9, '10': 'cardFanColor'},
    {'1': 'card_is_fan', '3': 7, '4': 1, '5': 8, '10': 'cardIsFan'},
    {'1': 'fan_num_prefix', '3': 8, '4': 1, '5': 9, '10': 'fanNumPrefix'},
    {
      '1': 'fan_num_color_format',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.MemberV2.Garb.FanNumColorFormat',
      '10': 'fanNumColorFormat'
    },
  ],
  '3': [MemberV2_Garb_FanNumColorFormat$json],
};

@$core.Deprecated('Use memberV2Descriptor instead')
const MemberV2_Garb_FanNumColorFormat$json = {
  '1': 'FanNumColorFormat',
  '2': [
    {'1': 'start_point', '3': 1, '4': 1, '5': 9, '10': 'startPoint'},
    {'1': 'end_point', '3': 2, '4': 1, '5': 9, '10': 'endPoint'},
    {'1': 'colors', '3': 3, '4': 3, '5': 9, '10': 'colors'},
    {'1': 'gradients', '3': 4, '4': 3, '5': 3, '10': 'gradients'},
  ],
};

@$core.Deprecated('Use memberV2Descriptor instead')
const MemberV2_Medal$json = {
  '1': 'Medal',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'level', '3': 2, '4': 1, '5': 3, '10': 'level'},
    {'1': 'color_start', '3': 3, '4': 1, '5': 3, '10': 'colorStart'},
    {'1': 'color_end', '3': 4, '4': 1, '5': 3, '10': 'colorEnd'},
    {'1': 'color_border', '3': 5, '4': 1, '5': 3, '10': 'colorBorder'},
    {'1': 'color_name', '3': 6, '4': 1, '5': 3, '10': 'colorName'},
    {'1': 'color_level', '3': 7, '4': 1, '5': 3, '10': 'colorLevel'},
    {'1': 'guard_level', '3': 8, '4': 1, '5': 3, '10': 'guardLevel'},
    {'1': 'first_icon', '3': 9, '4': 1, '5': 9, '10': 'firstIcon'},
    {'1': 'second_icon', '3': 10, '4': 1, '5': 9, '10': 'secondIcon'},
    {'1': 'level_bg_color', '3': 11, '4': 1, '5': 3, '10': 'levelBgColor'},
  ],
};

@$core.Deprecated('Use memberV2Descriptor instead')
const MemberV2_Nft$json = {
  '1': 'Nft',
  '2': [
    {'1': 'face', '3': 1, '4': 1, '5': 5, '10': 'face'},
    {
      '1': 'interaction',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.MemberV2.Nft.Interaction',
      '10': 'interaction'
    },
  ],
  '3': [MemberV2_Nft_Interaction$json],
};

@$core.Deprecated('Use memberV2Descriptor instead')
const MemberV2_Nft_Interaction$json = {
  '1': 'Interaction',
  '2': [
    {'1': 'itype', '3': 1, '4': 1, '5': 9, '10': 'itype'},
    {'1': 'metadata_url', '3': 2, '4': 1, '5': 9, '10': 'metadataUrl'},
    {'1': 'nft_id', '3': 3, '4': 1, '5': 9, '10': 'nftId'},
    {
      '1': 'region',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.MemberV2.Nft.Interaction.Region',
      '10': 'region'
    },
  ],
  '3': [MemberV2_Nft_Interaction_Region$json],
  '4': [
    MemberV2_Nft_Interaction_RegionType$json,
    MemberV2_Nft_Interaction_ShowStatus$json
  ],
};

@$core.Deprecated('Use memberV2Descriptor instead')
const MemberV2_Nft_Interaction_Region$json = {
  '1': 'Region',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6':
          '.bilibili.main.community.reply.v1.MemberV2.Nft.Interaction.RegionType',
      '10': 'type'
    },
    {'1': 'icon', '3': 2, '4': 1, '5': 9, '10': 'icon'},
    {
      '1': 'show_status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6':
          '.bilibili.main.community.reply.v1.MemberV2.Nft.Interaction.ShowStatus',
      '10': 'showStatus'
    },
  ],
};

@$core.Deprecated('Use memberV2Descriptor instead')
const MemberV2_Nft_Interaction_RegionType$json = {
  '1': 'RegionType',
  '2': [
    {'1': 'DEFAULT_RegionType', '2': 0},
    {'1': 'MAINLAND_RegionType', '2': 1},
    {'1': 'GAT_RegionType', '2': 2},
  ],
};

@$core.Deprecated('Use memberV2Descriptor instead')
const MemberV2_Nft_Interaction_ShowStatus$json = {
  '1': 'ShowStatus',
  '2': [
    {'1': 'SHOWDEFAULT_ShowStatus', '2': 0},
    {'1': 'ZOOMINMAINLAND_ShowStatus', '2': 1},
    {'1': 'RAW_ShowStatus', '2': 2},
  ],
};

@$core.Deprecated('Use memberV2Descriptor instead')
const MemberV2_Official$json = {
  '1': 'Official',
  '2': [
    {'1': 'verify_type', '3': 1, '4': 1, '5': 3, '10': 'verifyType'},
  ],
};

@$core.Deprecated('Use memberV2Descriptor instead')
const MemberV2_Senior$json = {
  '1': 'Senior',
  '2': [
    {'1': 'is_senior_member', '3': 1, '4': 1, '5': 5, '10': 'isSeniorMember'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.MemberV2.Senior.Status',
      '10': 'status'
    },
  ],
  '4': [MemberV2_Senior_Status$json],
};

@$core.Deprecated('Use memberV2Descriptor instead')
const MemberV2_Senior_Status$json = {
  '1': 'Status',
  '2': [
    {'1': 'Normal', '2': 0},
    {'1': 'Pending', '2': 1},
    {'1': 'Senior', '2': 2},
    {'1': 'WillExpire', '2': 3},
    {'1': 'Expired', '2': 4},
  ],
};

@$core.Deprecated('Use memberV2Descriptor instead')
const MemberV2_Vip$json = {
  '1': 'Vip',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 3, '10': 'type'},
    {'1': 'status', '3': 2, '4': 1, '5': 3, '10': 'status'},
    {'1': 'theme_type', '3': 3, '4': 1, '5': 3, '10': 'themeType'},
    {'1': 'label_path', '3': 4, '4': 1, '5': 9, '10': 'labelPath'},
    {'1': 'nickname_color', '3': 5, '4': 1, '5': 9, '10': 'nicknameColor'},
    {'1': 'avatar_subscript', '3': 6, '4': 1, '5': 5, '10': 'avatarSubscript'},
    {'1': 'label_text', '3': 7, '4': 1, '5': 9, '10': 'labelText'},
    {'1': 'vip_label_theme', '3': 8, '4': 1, '5': 9, '10': 'vipLabelTheme'},
  ],
};

/// Descriptor for `MemberV2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memberV2Descriptor = $convert.base64Decode(
    'CghNZW1iZXJWMhJGCgViYXNpYxgBIAEoCzIwLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcG'
    'x5LnYxLk1lbWJlclYyLkJhc2ljUgViYXNpYxJPCghvZmZpY2lhbBgCIAEoCzIzLmJpbGliaWxp'
    'Lm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLk1lbWJlclYyLk9mZmljaWFsUghvZmZpY2lhbBJACg'
    'N2aXAYAyABKAsyLi5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5NZW1iZXJWMi5W'
    'aXBSA3ZpcBJDCgRnYXJiGAQgASgLMi8uYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudj'
    'EuTWVtYmVyVjIuR2FyYlIEZ2FyYhJGCgVtZWRhbBgFIAEoCzIwLmJpbGliaWxpLm1haW4uY29t'
    'bXVuaXR5LnJlcGx5LnYxLk1lbWJlclYyLk1lZGFsUgVtZWRhbBJACgNuZnQYBiABKAsyLi5iaW'
    'xpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5NZW1iZXJWMi5OZnRSA25mdBJJCgZzZW5p'
    'b3IYByABKAsyMS5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5NZW1iZXJWMi5TZW'
    '5pb3JSBnNlbmlvchJVCgpjb250cmFjdG9yGAggASgLMjUuYmlsaWJpbGkubWFpbi5jb21tdW5p'
    'dHkucmVwbHkudjEuTWVtYmVyVjIuQ29udHJhY3RvclIKY29udHJhY3RvchJHCgx1c2VyX3NhaW'
    'xpbmcYCSABKAsyJC5iaWxpYmlsaS52YXMuZ2FyYi5tb2RlbC5Vc2VyU2FpbGluZ1ILdXNlclNh'
    'aWxpbmcagwIKBUJhc2ljEhAKA21pZBgBIAEoA1IDbWlkEhIKBG5hbWUYAiABKAlSBG5hbWUSEA'
    'oDc2V4GAMgASgJUgNzZXgSEgoEZmFjZRgEIAEoCVIEZmFjZRIUCgVsZXZlbBgFIAEoA1IFbGV2'
    'ZWwSTgoLYXZhdGFyX2l0ZW0YBiABKAsyLS5iaWxpYmlsaS5kYWd3LmNvbXBvbmVudC5hdmF0YX'
    'IudjEuQXZhdGFySXRlbVIKYXZhdGFySXRlbRJICgtuYW1lX3JlbmRlchgHIAEoCzInLmJpbGli'
    'aWxpLmFjY291bnQuc2VydmljZS52MS5OYW1lUmVuZGVyUgpuYW1lUmVuZGVyGlYKCkNvbnRyYW'
    'N0b3ISIwoNaXNfY29udHJhY3RvchgBIAEoCFIMaXNDb250cmFjdG9yEiMKDWNvbnRyYWN0X2Rl'
    'c2MYAiABKAlSDGNvbnRyYWN0RGVzYxqsBAoER2FyYhIjCg1wZW5kYW50X2ltYWdlGAEgASgJUg'
    'xwZW5kYW50SW1hZ2USHQoKY2FyZF9pbWFnZRgCIAEoCVIJY2FyZEltYWdlEjEKFWNhcmRfaW1h'
    'Z2Vfd2l0aF9mb2N1cxgDIAEoCVISY2FyZEltYWdlV2l0aEZvY3VzEiIKDWNhcmRfanVtcF91cm'
    'wYBCABKAlSC2NhcmRKdW1wVXJsEh8KC2NhcmRfbnVtYmVyGAUgASgJUgpjYXJkTnVtYmVyEiQK'
    'DmNhcmRfZmFuX2NvbG9yGAYgASgJUgxjYXJkRmFuQ29sb3ISHgoLY2FyZF9pc19mYW4YByABKA'
    'hSCWNhcmRJc0ZhbhIkCg5mYW5fbnVtX3ByZWZpeBgIIAEoCVIMZmFuTnVtUHJlZml4EnIKFGZh'
    'bl9udW1fY29sb3JfZm9ybWF0GAkgASgLMkEuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbH'
    'kudjEuTWVtYmVyVjIuR2FyYi5GYW5OdW1Db2xvckZvcm1hdFIRZmFuTnVtQ29sb3JGb3JtYXQa'
    'hwEKEUZhbk51bUNvbG9yRm9ybWF0Eh8KC3N0YXJ0X3BvaW50GAEgASgJUgpzdGFydFBvaW50Eh'
    'sKCWVuZF9wb2ludBgCIAEoCVIIZW5kUG9pbnQSFgoGY29sb3JzGAMgAygJUgZjb2xvcnMSHAoJ'
    'Z3JhZGllbnRzGAQgAygDUglncmFkaWVudHMa2QIKBU1lZGFsEhIKBG5hbWUYASABKAlSBG5hbW'
    'USFAoFbGV2ZWwYAiABKANSBWxldmVsEh8KC2NvbG9yX3N0YXJ0GAMgASgDUgpjb2xvclN0YXJ0'
    'EhsKCWNvbG9yX2VuZBgEIAEoA1IIY29sb3JFbmQSIQoMY29sb3JfYm9yZGVyGAUgASgDUgtjb2'
    'xvckJvcmRlchIdCgpjb2xvcl9uYW1lGAYgASgDUgljb2xvck5hbWUSHwoLY29sb3JfbGV2ZWwY'
    'ByABKANSCmNvbG9yTGV2ZWwSHwoLZ3VhcmRfbGV2ZWwYCCABKANSCmd1YXJkTGV2ZWwSHQoKZm'
    'lyc3RfaWNvbhgJIAEoCVIJZmlyc3RJY29uEh8KC3NlY29uZF9pY29uGAogASgJUgpzZWNvbmRJ'
    'Y29uEiQKDmxldmVsX2JnX2NvbG9yGAsgASgDUgxsZXZlbEJnQ29sb3IaxAUKA05mdBISCgRmYW'
    'NlGAEgASgFUgRmYWNlElwKC2ludGVyYWN0aW9uGAIgASgLMjouYmlsaWJpbGkubWFpbi5jb21t'
    'dW5pdHkucmVwbHkudjEuTWVtYmVyVjIuTmZ0LkludGVyYWN0aW9uUgtpbnRlcmFjdGlvbhrKBA'
    'oLSW50ZXJhY3Rpb24SFAoFaXR5cGUYASABKAlSBWl0eXBlEiEKDG1ldGFkYXRhX3VybBgCIAEo'
    'CVILbWV0YWRhdGFVcmwSFQoGbmZ0X2lkGAMgASgJUgVuZnRJZBJZCgZyZWdpb24YBCABKAsyQS'
    '5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5NZW1iZXJWMi5OZnQuSW50ZXJhY3Rp'
    'b24uUmVnaW9uUgZyZWdpb24a3wEKBlJlZ2lvbhJZCgR0eXBlGAEgASgOMkUuYmlsaWJpbGkubW'
    'Fpbi5jb21tdW5pdHkucmVwbHkudjEuTWVtYmVyVjIuTmZ0LkludGVyYWN0aW9uLlJlZ2lvblR5'
    'cGVSBHR5cGUSEgoEaWNvbhgCIAEoCVIEaWNvbhJmCgtzaG93X3N0YXR1cxgDIAEoDjJFLmJpbG'
    'liaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLk1lbWJlclYyLk5mdC5JbnRlcmFjdGlvbi5T'
    'aG93U3RhdHVzUgpzaG93U3RhdHVzIlEKClJlZ2lvblR5cGUSFgoSREVGQVVMVF9SZWdpb25UeX'
    'BlEAASFwoTTUFJTkxBTkRfUmVnaW9uVHlwZRABEhIKDkdBVF9SZWdpb25UeXBlEAIiWwoKU2hv'
    'd1N0YXR1cxIaChZTSE9XREVGQVVMVF9TaG93U3RhdHVzEAASHQoZWk9PTUlOTUFJTkxBTkRfU2'
    'hvd1N0YXR1cxABEhIKDlJBV19TaG93U3RhdHVzEAIaKwoIT2ZmaWNpYWwSHwoLdmVyaWZ5X3R5'
    'cGUYASABKANSCnZlcmlmeVR5cGUa0AEKBlNlbmlvchIoChBpc19zZW5pb3JfbWVtYmVyGAEgAS'
    'gFUg5pc1Nlbmlvck1lbWJlchJQCgZzdGF0dXMYAiABKA4yOC5iaWxpYmlsaS5tYWluLmNvbW11'
    'bml0eS5yZXBseS52MS5NZW1iZXJWMi5TZW5pb3IuU3RhdHVzUgZzdGF0dXMiSgoGU3RhdHVzEg'
    'oKBk5vcm1hbBAAEgsKB1BlbmRpbmcQARIKCgZTZW5pb3IQAhIOCgpXaWxsRXhwaXJlEAMSCwoH'
    'RXhwaXJlZBAEGogCCgNWaXASEgoEdHlwZRgBIAEoA1IEdHlwZRIWCgZzdGF0dXMYAiABKANSBn'
    'N0YXR1cxIdCgp0aGVtZV90eXBlGAMgASgDUgl0aGVtZVR5cGUSHQoKbGFiZWxfcGF0aBgEIAEo'
    'CVIJbGFiZWxQYXRoEiUKDm5pY2tuYW1lX2NvbG9yGAUgASgJUg1uaWNrbmFtZUNvbG9yEikKEG'
    'F2YXRhcl9zdWJzY3JpcHQYBiABKAVSD2F2YXRhclN1YnNjcmlwdBIdCgpsYWJlbF90ZXh0GAcg'
    'ASgJUglsYWJlbFRleHQSJgoPdmlwX2xhYmVsX3RoZW1lGAggASgJUg12aXBMYWJlbFRoZW1l');

@$core.Deprecated('Use mixedCardDescriptor instead')
const MixedCard$json = {
  '1': 'MixedCard',
  '2': [
    {
      '1': 'question',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.QuestionCard',
      '9': 0,
      '10': 'question'
    },
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.MixedCard.Type',
      '10': 'type'
    },
    {'1': 'oid', '3': 2, '4': 1, '5': 9, '10': 'oid'},
    {'1': 'display_rank', '3': 3, '4': 1, '5': 3, '10': 'displayRank'},
  ],
  '4': [MixedCard_Type$json],
  '8': [
    {'1': 'item'},
  ],
};

@$core.Deprecated('Use mixedCardDescriptor instead')
const MixedCard_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'UNKNOWN', '2': 0},
    {'1': 'QUESTION', '2': 1},
  ],
};

/// Descriptor for `MixedCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mixedCardDescriptor = $convert.base64Decode(
    'CglNaXhlZENhcmQSTAoIcXVlc3Rpb24YBCABKAsyLi5iaWxpYmlsaS5tYWluLmNvbW11bml0eS'
    '5yZXBseS52MS5RdWVzdGlvbkNhcmRIAFIIcXVlc3Rpb24SRAoEdHlwZRgBIAEoDjIwLmJpbGli'
    'aWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLk1peGVkQ2FyZC5UeXBlUgR0eXBlEhAKA29pZB'
    'gCIAEoCVIDb2lkEiEKDGRpc3BsYXlfcmFuaxgDIAEoA1ILZGlzcGxheVJhbmsiIQoEVHlwZRIL'
    'CgdVTktOT1dOEAASDAoIUVVFU1RJT04QAUIGCgRpdGVt');

@$core.Deprecated('Use noticeDescriptor instead')
const Notice$json = {
  '1': 'Notice',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'content', '3': 2, '4': 1, '5': 9, '10': 'content'},
    {'1': 'link', '3': 3, '4': 1, '5': 9, '10': 'link'},
  ],
};

/// Descriptor for `Notice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List noticeDescriptor = $convert.base64Decode(
    'CgZOb3RpY2USDgoCaWQYASABKANSAmlkEhgKB2NvbnRlbnQYAiABKAlSB2NvbnRlbnQSEgoEbG'
    'luaxgDIAEoCVIEbGluaw==');

@$core.Deprecated('Use ogvGradeCardDescriptor instead')
const OgvGradeCard$json = {
  '1': 'OgvGradeCard',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'sub_title', '3': 2, '4': 1, '5': 9, '10': 'subTitle'},
    {'1': 'button_text', '3': 3, '4': 1, '5': 9, '10': 'buttonText'},
    {'1': 'goto_url', '3': 4, '4': 1, '5': 9, '10': 'gotoUrl'},
  ],
};

/// Descriptor for `OgvGradeCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ogvGradeCardDescriptor = $convert.base64Decode(
    'CgxPZ3ZHcmFkZUNhcmQSFAoFdGl0bGUYASABKAlSBXRpdGxlEhsKCXN1Yl90aXRsZRgCIAEoCV'
    'IIc3ViVGl0bGUSHwoLYnV0dG9uX3RleHQYAyABKAlSCmJ1dHRvblRleHQSGQoIZ290b191cmwY'
    'BCABKAlSB2dvdG9Vcmw=');

@$core.Deprecated('Use operationDescriptor instead')
const Operation$json = {
  '1': 'Operation',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.Operation.Type',
      '10': 'type'
    },
    {'1': 'id', '3': 2, '4': 1, '5': 3, '10': 'id'},
    {
      '1': 'title',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.OperationTitle',
      '10': 'title'
    },
    {
      '1': 'subtitle',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.OperationTitle',
      '10': 'subtitle'
    },
    {'1': 'link', '3': 5, '4': 1, '5': 9, '10': 'link'},
    {'1': 'report_extra', '3': 6, '4': 1, '5': 9, '10': 'reportExtra'},
    {'1': 'icon', '3': 7, '4': 1, '5': 9, '10': 'icon'},
  ],
  '4': [Operation_Type$json],
};

@$core.Deprecated('Use operationDescriptor instead')
const Operation_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'UNKNOWN_Type', '2': 0},
    {'1': 'NOTE', '2': 1},
    {'1': 'TOPIC', '2': 2},
    {'1': 'NOTICE', '2': 3},
  ],
};

/// Descriptor for `Operation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List operationDescriptor = $convert.base64Decode(
    'CglPcGVyYXRpb24SRAoEdHlwZRgBIAEoDjIwLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcG'
    'x5LnYxLk9wZXJhdGlvbi5UeXBlUgR0eXBlEg4KAmlkGAIgASgDUgJpZBJGCgV0aXRsZRgDIAEo'
    'CzIwLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLk9wZXJhdGlvblRpdGxlUgV0aX'
    'RsZRJMCghzdWJ0aXRsZRgEIAEoCzIwLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYx'
    'Lk9wZXJhdGlvblRpdGxlUghzdWJ0aXRsZRISCgRsaW5rGAUgASgJUgRsaW5rEiEKDHJlcG9ydF'
    '9leHRyYRgGIAEoCVILcmVwb3J0RXh0cmESEgoEaWNvbhgHIAEoCVIEaWNvbiI5CgRUeXBlEhAK'
    'DFVOS05PV05fVHlwZRAAEggKBE5PVEUQARIJCgVUT1BJQxACEgoKBk5PVElDRRAD');

@$core.Deprecated('Use operationTitleDescriptor instead')
const OperationTitle$json = {
  '1': 'OperationTitle',
  '2': [
    {'1': 'content', '3': 1, '4': 1, '5': 9, '10': 'content'},
    {'1': 'is_highlight', '3': 2, '4': 1, '5': 8, '10': 'isHighlight'},
  ],
};

/// Descriptor for `OperationTitle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List operationTitleDescriptor = $convert.base64Decode(
    'Cg5PcGVyYXRpb25UaXRsZRIYCgdjb250ZW50GAEgASgJUgdjb250ZW50EiEKDGlzX2hpZ2hsaW'
    'dodBgCIAEoCFILaXNIaWdobGlnaHQ=');

@$core.Deprecated('Use operationV2Descriptor instead')
const OperationV2$json = {
  '1': 'OperationV2',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.OperationV2.Type',
      '10': 'type'
    },
    {'1': 'prefix_text', '3': 2, '4': 1, '5': 9, '10': 'prefixText'},
    {
      '1': 'icon',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.OperationV2.Icon',
      '10': 'icon'
    },
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'link', '3': 5, '4': 1, '5': 9, '10': 'link'},
    {'1': 'report_extra', '3': 6, '4': 1, '5': 9, '10': 'reportExtra'},
  ],
  '3': [OperationV2_Icon$json],
  '4': [OperationV2_Type$json],
};

@$core.Deprecated('Use operationV2Descriptor instead')
const OperationV2_Icon$json = {
  '1': 'Icon',
  '2': [
    {
      '1': 'position',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.OperationV2.Icon.Position',
      '10': 'position'
    },
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
  ],
  '4': [OperationV2_Icon_Position$json],
};

@$core.Deprecated('Use operationV2Descriptor instead')
const OperationV2_Icon_Position$json = {
  '1': 'Position',
  '2': [
    {'1': 'PREFIX', '2': 0},
    {'1': 'SUFFIX', '2': 1},
  ],
};

@$core.Deprecated('Use operationV2Descriptor instead')
const OperationV2_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'UNKNOWN_Type', '2': 0},
    {'1': 'NOTE_Type', '2': 1},
    {'1': 'TOPIC_Type', '2': 2},
    {'1': 'SEARCH', '2': 4},
  ],
};

/// Descriptor for `OperationV2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List operationV2Descriptor = $convert.base64Decode(
    'CgtPcGVyYXRpb25WMhJGCgR0eXBlGAEgASgOMjIuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucm'
    'VwbHkudjEuT3BlcmF0aW9uVjIuVHlwZVIEdHlwZRIfCgtwcmVmaXhfdGV4dBgCIAEoCVIKcHJl'
    'Zml4VGV4dBJGCgRpY29uGAMgASgLMjIuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudj'
    'EuT3BlcmF0aW9uVjIuSWNvblIEaWNvbhIUCgV0aXRsZRgEIAEoCVIFdGl0bGUSEgoEbGluaxgF'
    'IAEoCVIEbGluaxIhCgxyZXBvcnRfZXh0cmEYBiABKAlSC3JlcG9ydEV4dHJhGpUBCgRJY29uEl'
    'cKCHBvc2l0aW9uGAEgASgOMjsuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuT3Bl'
    'cmF0aW9uVjIuSWNvbi5Qb3NpdGlvblIIcG9zaXRpb24SEAoDdXJsGAIgASgJUgN1cmwiIgoIUG'
    '9zaXRpb24SCgoGUFJFRklYEAASCgoGU1VGRklYEAEiQwoEVHlwZRIQCgxVTktOT1dOX1R5cGUQ'
    'ABINCglOT1RFX1R5cGUQARIOCgpUT1BJQ19UeXBlEAISCgoGU0VBUkNIEAQ=');

@$core.Deprecated('Use pGCVideoSearchItemDescriptor instead')
const PGCVideoSearchItem$json = {
  '1': 'PGCVideoSearchItem',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'category', '3': 2, '4': 1, '5': 9, '10': 'category'},
    {'1': 'cover', '3': 3, '4': 1, '5': 9, '10': 'cover'},
  ],
};

/// Descriptor for `PGCVideoSearchItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pGCVideoSearchItemDescriptor = $convert.base64Decode(
    'ChJQR0NWaWRlb1NlYXJjaEl0ZW0SFAoFdGl0bGUYASABKAlSBXRpdGxlEhoKCGNhdGVnb3J5GA'
    'IgASgJUghjYXRlZ29yeRIUCgVjb3ZlchgDIAEoCVIFY292ZXI=');

@$core.Deprecated('Use pictureDescriptor instead')
const Picture$json = {
  '1': 'Picture',
  '2': [
    {'1': 'img_src', '3': 1, '4': 1, '5': 9, '10': 'imgSrc'},
    {'1': 'img_width', '3': 2, '4': 1, '5': 1, '10': 'imgWidth'},
    {'1': 'img_height', '3': 3, '4': 1, '5': 1, '10': 'imgHeight'},
    {'1': 'img_size', '3': 4, '4': 1, '5': 1, '10': 'imgSize'},
    {'1': 'top_right_icon', '3': 5, '4': 1, '5': 9, '10': 'topRightIcon'},
    {
      '1': 'play_gif_thumbnail',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'playGifThumbnail'
    },
  ],
};

/// Descriptor for `Picture`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pictureDescriptor = $convert.base64Decode(
    'CgdQaWN0dXJlEhcKB2ltZ19zcmMYASABKAlSBmltZ1NyYxIbCglpbWdfd2lkdGgYAiABKAFSCG'
    'ltZ1dpZHRoEh0KCmltZ19oZWlnaHQYAyABKAFSCWltZ0hlaWdodBIZCghpbWdfc2l6ZRgEIAEo'
    'AVIHaW1nU2l6ZRIkCg50b3BfcmlnaHRfaWNvbhgFIAEoCVIMdG9wUmlnaHRJY29uEiwKEnBsYX'
    'lfZ2lmX3RodW1ibmFpbBgGIAEoCFIQcGxheUdpZlRodW1ibmFpbA==');

@$core.Deprecated('Use pictureListReqDescriptor instead')
const PictureListReq$json = {
  '1': 'PictureListReq',
  '2': [
    {'1': 'oid', '3': 1, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'type', '3': 2, '4': 1, '5': 3, '10': 'type'},
    {'1': 'extra', '3': 3, '4': 1, '5': 9, '10': 'extra'},
    {'1': 'after_rpid', '3': 4, '4': 1, '5': 3, '10': 'afterRpid'},
    {
      '1': 'mode',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.Mode',
      '10': 'mode'
    },
    {
      '1': 'pagination',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.pagination.FeedPagination',
      '10': 'pagination'
    },
    {'1': 'session_id', '3': 7, '4': 1, '5': 9, '10': 'sessionId'},
    {
      '1': 'main_list_session_id',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'mainListSessionId'
    },
  ],
};

/// Descriptor for `PictureListReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pictureListReqDescriptor = $convert.base64Decode(
    'Cg5QaWN0dXJlTGlzdFJlcRIQCgNvaWQYASABKANSA29pZBISCgR0eXBlGAIgASgDUgR0eXBlEh'
    'QKBWV4dHJhGAMgASgJUgVleHRyYRIdCgphZnRlcl9ycGlkGAQgASgDUglhZnRlclJwaWQSOgoE'
    'bW9kZRgFIAEoDjImLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLk1vZGVSBG1vZG'
    'USQwoKcGFnaW5hdGlvbhgGIAEoCzIjLmJpbGliaWxpLnBhZ2luYXRpb24uRmVlZFBhZ2luYXRp'
    'b25SCnBhZ2luYXRpb24SHQoKc2Vzc2lvbl9pZBgHIAEoCVIJc2Vzc2lvbklkEi8KFG1haW5fbG'
    'lzdF9zZXNzaW9uX2lkGAggASgJUhFtYWluTGlzdFNlc3Npb25JZA==');

@$core.Deprecated('Use pictureListRespDescriptor instead')
const PictureListResp$json = {
  '1': 'PictureListResp',
  '2': [
    {
      '1': 'replies',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInfo',
      '10': 'replies'
    },
    {
      '1': 'pagination_reply',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.pagination.FeedPaginationReply',
      '10': 'paginationReply'
    },
    {'1': 'session_id', '3': 3, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'report_params', '3': 4, '4': 1, '5': 9, '10': 'reportParams'},
    {'1': 'context_feature', '3': 5, '4': 1, '5': 9, '10': 'contextFeature'},
    {
      '1': 'pagination_end_text',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'paginationEndText'
    },
  ],
};

/// Descriptor for `PictureListResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pictureListRespDescriptor = $convert.base64Decode(
    'Cg9QaWN0dXJlTGlzdFJlc3ASRQoHcmVwbGllcxgBIAMoCzIrLmJpbGliaWxpLm1haW4uY29tbX'
    'VuaXR5LnJlcGx5LnYxLlJlcGx5SW5mb1IHcmVwbGllcxJTChBwYWdpbmF0aW9uX3JlcGx5GAIg'
    'ASgLMiguYmlsaWJpbGkucGFnaW5hdGlvbi5GZWVkUGFnaW5hdGlvblJlcGx5Ug9wYWdpbmF0aW'
    '9uUmVwbHkSHQoKc2Vzc2lvbl9pZBgDIAEoCVIJc2Vzc2lvbklkEiMKDXJlcG9ydF9wYXJhbXMY'
    'BCABKAlSDHJlcG9ydFBhcmFtcxInCg9jb250ZXh0X2ZlYXR1cmUYBSABKAlSDmNvbnRleHRGZW'
    'F0dXJlEi4KE3BhZ2luYXRpb25fZW5kX3RleHQYBiABKAlSEXBhZ2luYXRpb25FbmRUZXh0');

@$core.Deprecated('Use previewListReplyDescriptor instead')
const PreviewListReply$json = {
  '1': 'PreviewListReply',
  '2': [
    {
      '1': 'cursor',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.CursorReply',
      '10': 'cursor'
    },
    {
      '1': 'replies',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInfo',
      '10': 'replies'
    },
    {
      '1': 'subject_control',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.SubjectControl',
      '10': 'subjectControl'
    },
    {
      '1': 'up_top',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInfo',
      '10': 'upTop'
    },
    {
      '1': 'admin_top',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInfo',
      '10': 'adminTop'
    },
    {
      '1': 'vote_top',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInfo',
      '10': 'voteTop'
    },
  ],
};

/// Descriptor for `PreviewListReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List previewListReplyDescriptor = $convert.base64Decode(
    'ChBQcmV2aWV3TGlzdFJlcGx5EkUKBmN1cnNvchgBIAEoCzItLmJpbGliaWxpLm1haW4uY29tbX'
    'VuaXR5LnJlcGx5LnYxLkN1cnNvclJlcGx5UgZjdXJzb3ISRQoHcmVwbGllcxgCIAMoCzIrLmJp'
    'bGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLlJlcGx5SW5mb1IHcmVwbGllcxJZCg9zdW'
    'JqZWN0X2NvbnRyb2wYAyABKAsyMC5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5T'
    'dWJqZWN0Q29udHJvbFIOc3ViamVjdENvbnRyb2wSQgoGdXBfdG9wGAQgASgLMisuYmlsaWJpbG'
    'kubWFpbi5jb21tdW5pdHkucmVwbHkudjEuUmVwbHlJbmZvUgV1cFRvcBJICglhZG1pbl90b3AY'
    'BSABKAsyKy5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5SZXBseUluZm9SCGFkbW'
    'luVG9wEkYKCHZvdGVfdG9wGAYgASgLMisuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHku'
    'djEuUmVwbHlJbmZvUgd2b3RlVG9w');

@$core.Deprecated('Use previewListReqDescriptor instead')
const PreviewListReq$json = {
  '1': 'PreviewListReq',
  '2': [
    {'1': 'oid', '3': 1, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'type', '3': 2, '4': 1, '5': 3, '10': 'type'},
    {
      '1': 'cursor',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.CursorReq',
      '10': 'cursor'
    },
  ],
};

/// Descriptor for `PreviewListReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List previewListReqDescriptor = $convert.base64Decode(
    'Cg5QcmV2aWV3TGlzdFJlcRIQCgNvaWQYASABKANSA29pZBISCgR0eXBlGAIgASgDUgR0eXBlEk'
    'MKBmN1cnNvchgDIAEoCzIrLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLkN1cnNv'
    'clJlcVIGY3Vyc29y');

@$core.Deprecated('Use qoeInfoDescriptor instead')
const QoeInfo$json = {
  '1': 'QoeInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'type', '3': 2, '4': 1, '5': 5, '10': 'type'},
    {'1': 'style', '3': 3, '4': 1, '5': 5, '10': 'style'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'feedback_title', '3': 5, '4': 1, '5': 9, '10': 'feedbackTitle'},
    {
      '1': 'score_items',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.QoeScoreItem',
      '10': 'scoreItems'
    },
    {'1': 'display_rank', '3': 7, '4': 1, '5': 3, '10': 'displayRank'},
    {
      '1': 'form',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Form',
      '10': 'form'
    },
  ],
};

/// Descriptor for `QoeInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qoeInfoDescriptor = $convert.base64Decode(
    'CgdRb2VJbmZvEg4KAmlkGAEgASgDUgJpZBISCgR0eXBlGAIgASgFUgR0eXBlEhQKBXN0eWxlGA'
    'MgASgFUgVzdHlsZRIUCgV0aXRsZRgEIAEoCVIFdGl0bGUSJQoOZmVlZGJhY2tfdGl0bGUYBSAB'
    'KAlSDWZlZWRiYWNrVGl0bGUSTwoLc2NvcmVfaXRlbXMYBiADKAsyLi5iaWxpYmlsaS5tYWluLm'
    'NvbW11bml0eS5yZXBseS52MS5Rb2VTY29yZUl0ZW1SCnNjb3JlSXRlbXMSIQoMZGlzcGxheV9y'
    'YW5rGAcgASgDUgtkaXNwbGF5UmFuaxI6CgRmb3JtGAggASgLMiYuYmlsaWJpbGkubWFpbi5jb2'
    '1tdW5pdHkucmVwbHkudjEuRm9ybVIEZm9ybQ==');

@$core.Deprecated('Use qoeOptionDescriptor instead')
const QoeOption$json = {
  '1': 'QoeOption',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'score', '3': 2, '4': 1, '5': 2, '10': 'score'},
    {'1': 'img_url', '3': 3, '4': 1, '5': 9, '10': 'imgUrl'},
    {'1': 'desc', '3': 4, '4': 3, '5': 9, '10': 'desc'},
  ],
};

/// Descriptor for `QoeOption`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qoeOptionDescriptor = $convert.base64Decode(
    'CglRb2VPcHRpb24SFAoFdGl0bGUYASABKAlSBXRpdGxlEhQKBXNjb3JlGAIgASgCUgVzY29yZR'
    'IXCgdpbWdfdXJsGAMgASgJUgZpbWdVcmwSEgoEZGVzYxgEIAMoCVIEZGVzYw==');

@$core.Deprecated('Use qoeOptionDescDescriptor instead')
const QoeOptionDesc$json = {
  '1': 'QoeOptionDesc',
  '2': [
    {'1': 'desc', '3': 1, '4': 3, '5': 9, '10': 'desc'},
  ],
};

/// Descriptor for `QoeOptionDesc`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qoeOptionDescDescriptor =
    $convert.base64Decode('Cg1Rb2VPcHRpb25EZXNjEhIKBGRlc2MYASADKAlSBGRlc2M=');

@$core.Deprecated('Use qoeScoreItemDescriptor instead')
const QoeScoreItem$json = {
  '1': 'QoeScoreItem',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
    {'1': 'score', '3': 3, '4': 1, '5': 2, '10': 'score'},
  ],
};

/// Descriptor for `QoeScoreItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List qoeScoreItemDescriptor = $convert.base64Decode(
    'CgxRb2VTY29yZUl0ZW0SFAoFdGl0bGUYASABKAlSBXRpdGxlEhAKA3VybBgCIAEoCVIDdXJsEh'
    'QKBXNjb3JlGAMgASgCUgVzY29yZQ==');

@$core.Deprecated('Use questionCardDescriptor instead')
const QuestionCard$json = {
  '1': 'QuestionCard',
  '2': [
    {
      '1': 'question',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.QuestionCard.Question',
      '10': 'question'
    },
    {
      '1': 'stat',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.QuestionCardStat',
      '10': 'stat'
    },
    {'1': 'bottom_text', '3': 3, '4': 1, '5': 9, '10': 'bottomText'},
  ],
  '3': [QuestionCard_Option$json, QuestionCard_Question$json],
};

@$core.Deprecated('Use questionCardDescriptor instead')
const QuestionCard_Option$json = {
  '1': 'Option',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
  ],
};

@$core.Deprecated('Use questionCardDescriptor instead')
const QuestionCard_Question$json = {
  '1': 'Question',
  '2': [
    {'1': 'qid', '3': 1, '4': 1, '5': 3, '10': 'qid'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'must_right', '3': 3, '4': 1, '5': 8, '10': 'mustRight'},
    {
      '1': 'options',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.QuestionCard.Option',
      '10': 'options'
    },
  ],
};

/// Descriptor for `QuestionCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List questionCardDescriptor = $convert.base64Decode(
    'CgxRdWVzdGlvbkNhcmQSUwoIcXVlc3Rpb24YASABKAsyNy5iaWxpYmlsaS5tYWluLmNvbW11bm'
    'l0eS5yZXBseS52MS5RdWVzdGlvbkNhcmQuUXVlc3Rpb25SCHF1ZXN0aW9uEkYKBHN0YXQYAiAB'
    'KAsyMi5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5RdWVzdGlvbkNhcmRTdGF0Ug'
    'RzdGF0Eh8KC2JvdHRvbV90ZXh0GAMgASgJUgpib3R0b21UZXh0GjAKBk9wdGlvbhIQCgNrZXkY'
    'ASABKAlSA2tleRIUCgV0aXRsZRgCIAEoCVIFdGl0bGUaogEKCFF1ZXN0aW9uEhAKA3FpZBgBIA'
    'EoA1IDcWlkEhQKBXRpdGxlGAIgASgJUgV0aXRsZRIdCgptdXN0X3JpZ2h0GAMgASgIUgltdXN0'
    'UmlnaHQSTwoHb3B0aW9ucxgEIAMoCzI1LmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5Ln'
    'YxLlF1ZXN0aW9uQ2FyZC5PcHRpb25SB29wdGlvbnM=');

@$core.Deprecated('Use questionCardStatDescriptor instead')
const QuestionCardStat$json = {
  '1': 'QuestionCardStat',
  '2': [
    {'1': 'right_cnt', '3': 1, '4': 1, '5': 3, '10': 'rightCnt'},
    {'1': 'right_mid_cnt', '3': 2, '4': 1, '5': 3, '10': 'rightMidCnt'},
    {'1': 'submit_mid_cnt', '3': 3, '4': 1, '5': 3, '10': 'submitMidCnt'},
  ],
};

/// Descriptor for `QuestionCardStat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List questionCardStatDescriptor = $convert.base64Decode(
    'ChBRdWVzdGlvbkNhcmRTdGF0EhsKCXJpZ2h0X2NudBgBIAEoA1IIcmlnaHRDbnQSIgoNcmlnaH'
    'RfbWlkX2NudBgCIAEoA1ILcmlnaHRNaWRDbnQSJAoOc3VibWl0X21pZF9jbnQYAyABKANSDHN1'
    'Ym1pdE1pZENudA==');

@$core.Deprecated('Use replyCardLabelDescriptor instead')
const ReplyCardLabel$json = {
  '1': 'ReplyCardLabel',
  '2': [
    {'1': 'text_content', '3': 1, '4': 1, '5': 9, '10': 'textContent'},
    {'1': 'text_color_day', '3': 2, '4': 1, '5': 9, '10': 'textColorDay'},
    {'1': 'text_color_night', '3': 3, '4': 1, '5': 9, '10': 'textColorNight'},
    {'1': 'label_color_day', '3': 4, '4': 1, '5': 9, '10': 'labelColorDay'},
    {'1': 'label_color_night', '3': 5, '4': 1, '5': 9, '10': 'labelColorNight'},
    {'1': 'image', '3': 6, '4': 1, '5': 9, '10': 'image'},
    {
      '1': 'type',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.ReplyCardLabel.Type',
      '10': 'type'
    },
    {'1': 'background', '3': 8, '4': 1, '5': 9, '10': 'background'},
    {'1': 'background_width', '3': 9, '4': 1, '5': 1, '10': 'backgroundWidth'},
    {
      '1': 'background_height',
      '3': 10,
      '4': 1,
      '5': 1,
      '10': 'backgroundHeight'
    },
    {'1': 'jump_url', '3': 11, '4': 1, '5': 9, '10': 'jumpUrl'},
    {'1': 'effect', '3': 12, '4': 1, '5': 3, '10': 'effect'},
    {
      '1': 'effect_start_time',
      '3': 13,
      '4': 1,
      '5': 3,
      '10': 'effectStartTime'
    },
  ],
  '4': [ReplyCardLabel_Type$json],
};

@$core.Deprecated('Use replyCardLabelDescriptor instead')
const ReplyCardLabel_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'UNDERLINE', '2': 0},
    {'1': 'BACKGROUND', '2': 1},
  ],
};

/// Descriptor for `ReplyCardLabel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replyCardLabelDescriptor = $convert.base64Decode(
    'Cg5SZXBseUNhcmRMYWJlbBIhCgx0ZXh0X2NvbnRlbnQYASABKAlSC3RleHRDb250ZW50EiQKDn'
    'RleHRfY29sb3JfZGF5GAIgASgJUgx0ZXh0Q29sb3JEYXkSKAoQdGV4dF9jb2xvcl9uaWdodBgD'
    'IAEoCVIOdGV4dENvbG9yTmlnaHQSJgoPbGFiZWxfY29sb3JfZGF5GAQgASgJUg1sYWJlbENvbG'
    '9yRGF5EioKEWxhYmVsX2NvbG9yX25pZ2h0GAUgASgJUg9sYWJlbENvbG9yTmlnaHQSFAoFaW1h'
    'Z2UYBiABKAlSBWltYWdlEkkKBHR5cGUYByABKA4yNS5iaWxpYmlsaS5tYWluLmNvbW11bml0eS'
    '5yZXBseS52MS5SZXBseUNhcmRMYWJlbC5UeXBlUgR0eXBlEh4KCmJhY2tncm91bmQYCCABKAlS'
    'CmJhY2tncm91bmQSKQoQYmFja2dyb3VuZF93aWR0aBgJIAEoAVIPYmFja2dyb3VuZFdpZHRoEi'
    'sKEWJhY2tncm91bmRfaGVpZ2h0GAogASgBUhBiYWNrZ3JvdW5kSGVpZ2h0EhkKCGp1bXBfdXJs'
    'GAsgASgJUgdqdW1wVXJsEhYKBmVmZmVjdBgMIAEoA1IGZWZmZWN0EioKEWVmZmVjdF9zdGFydF'
    '90aW1lGA0gASgDUg9lZmZlY3RTdGFydFRpbWUiJQoEVHlwZRINCglVTkRFUkxJTkUQABIOCgpC'
    'QUNLR1JPVU5EEAE=');

@$core.Deprecated('Use replyControlDescriptor instead')
const ReplyControl$json = {
  '1': 'ReplyControl',
  '2': [
    {'1': 'action', '3': 1, '4': 1, '5': 3, '10': 'action'},
    {'1': 'up_like', '3': 2, '4': 1, '5': 8, '10': 'upLike'},
    {'1': 'up_reply', '3': 3, '4': 1, '5': 8, '10': 'upReply'},
    {'1': 'show_follow_btn', '3': 4, '4': 1, '5': 8, '10': 'showFollowBtn'},
    {'1': 'is_assist', '3': 5, '4': 1, '5': 8, '10': 'isAssist'},
    {'1': 'label_text', '3': 6, '4': 1, '5': 9, '10': 'labelText'},
    {'1': 'following', '3': 7, '4': 1, '5': 8, '10': 'following'},
    {'1': 'followed', '3': 8, '4': 1, '5': 8, '10': 'followed'},
    {'1': 'blocked', '3': 9, '4': 1, '5': 8, '10': 'blocked'},
    {'1': 'has_folded_reply', '3': 10, '4': 1, '5': 8, '10': 'hasFoldedReply'},
    {'1': 'is_folded_reply', '3': 11, '4': 1, '5': 8, '10': 'isFoldedReply'},
    {'1': 'is_up_top', '3': 12, '4': 1, '5': 8, '10': 'isUpTop'},
    {'1': 'is_admin_top', '3': 13, '4': 1, '5': 8, '10': 'isAdminTop'},
    {'1': 'is_vote_top', '3': 14, '4': 1, '5': 8, '10': 'isVoteTop'},
    {'1': 'max_line', '3': 15, '4': 1, '5': 3, '10': 'maxLine'},
    {'1': 'invisible', '3': 16, '4': 1, '5': 8, '10': 'invisible'},
    {'1': 'is_contractor', '3': 17, '4': 1, '5': 8, '10': 'isContractor'},
    {'1': 'is_note', '3': 18, '4': 1, '5': 8, '10': 'isNote'},
    {
      '1': 'card_labels',
      '3': 19,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyCardLabel',
      '10': 'cardLabels'
    },
    {
      '1': 'sub_reply_entry_text',
      '3': 20,
      '4': 1,
      '5': 9,
      '10': 'subReplyEntryText'
    },
    {
      '1': 'sub_reply_title_text',
      '3': 21,
      '4': 1,
      '5': 9,
      '10': 'subReplyTitleText'
    },
    {'1': 'contract_desc', '3': 22, '4': 1, '5': 9, '10': 'contractDesc'},
    {'1': 'time_desc', '3': 23, '4': 1, '5': 9, '10': 'timeDesc'},
    {'1': 'biz_scene', '3': 24, '4': 1, '5': 9, '10': 'bizScene'},
    {'1': 'location', '3': 25, '4': 1, '5': 9, '10': 'location'},
    {'1': 'fold_pictures', '3': 26, '4': 1, '5': 8, '10': 'foldPictures'},
    {'1': 'is_note_v2', '3': 27, '4': 1, '5': 8, '10': 'isNoteV2'},
    {'1': 'hide_note_icon', '3': 28, '4': 1, '5': 8, '10': 'hideNoteIcon'},
    {
      '1': 'cm_recommend_component',
      '3': 29,
      '4': 1,
      '5': 9,
      '10': 'cmRecommendComponent'
    },
    {
      '1': 'vote_option',
      '3': 30,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyControl.VoteOption',
      '10': 'voteOption'
    },
    {'1': 'charged_desc', '3': 31, '4': 1, '5': 9, '10': 'chargedDesc'},
    {
      '1': 'grade_record',
      '3': 32,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyControl.GradeRecord',
      '10': 'gradeRecord'
    },
    {
      '1': 'preset_reply_text',
      '3': 33,
      '4': 1,
      '5': 9,
      '10': 'presetReplyText'
    },
    {
      '1': 'easter_egg_label',
      '3': 34,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyControl.EasterEggLabel',
      '10': 'easterEggLabel'
    },
    {'1': 'context_feature', '3': 35, '4': 1, '5': 9, '10': 'contextFeature'},
    {
      '1': 'insert_effect',
      '3': 36,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyControl.InsertEffect',
      '10': 'insertEffect'
    },
    {
      '1': 'translation_switch',
      '3': 37,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.TranslationSwitch',
      '10': 'translationSwitch'
    },
    {
      '1': 'show_translation',
      '3': 100,
      '4': 1,
      '5': 8,
      '10': 'showTranslation'
    },
  ],
  '3': [
    ReplyControl_EasterEggLabel$json,
    ReplyControl_GradeRecord$json,
    ReplyControl_InsertEffect$json,
    ReplyControl_VoteOption$json
  ],
};

@$core.Deprecated('Use replyControlDescriptor instead')
const ReplyControl_EasterEggLabel$json = {
  '1': 'EasterEggLabel',
  '2': [
    {'1': 'image', '3': 1, '4': 1, '5': 9, '10': 'image'},
    {'1': 'jump_url', '3': 2, '4': 1, '5': 9, '10': 'jumpUrl'},
  ],
};

@$core.Deprecated('Use replyControlDescriptor instead')
const ReplyControl_GradeRecord$json = {
  '1': 'GradeRecord',
  '2': [
    {'1': 'score', '3': 1, '4': 1, '5': 5, '10': 'score'},
    {
      '1': 'texts',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyControl.GradeRecord.Text',
      '10': 'texts'
    },
  ],
  '3': [ReplyControl_GradeRecord_Text$json],
};

@$core.Deprecated('Use replyControlDescriptor instead')
const ReplyControl_GradeRecord_Text$json = {
  '1': 'Text',
  '2': [
    {'1': 'raw', '3': 1, '4': 1, '5': 9, '10': 'raw'},
    {
      '1': 'style',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.TextStyle',
      '10': 'style'
    },
  ],
};

@$core.Deprecated('Use replyControlDescriptor instead')
const ReplyControl_InsertEffect$json = {
  '1': 'InsertEffect',
  '2': [
    {'1': 'content', '3': 1, '4': 1, '5': 9, '10': 'content'},
    {'1': 'icon', '3': 2, '4': 1, '5': 9, '10': 'icon'},
  ],
};

@$core.Deprecated('Use replyControlDescriptor instead')
const ReplyControl_VoteOption$json = {
  '1': 'VoteOption',
  '2': [
    {
      '1': 'label_kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6':
          '.bilibili.main.community.reply.v1.ReplyControl.VoteOption.LabelKind',
      '10': 'labelKind'
    },
    {'1': 'desc', '3': 2, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'idx', '3': 3, '4': 1, '5': 3, '10': 'idx'},
    {'1': 'vote_id', '3': 4, '4': 1, '5': 3, '10': 'voteId'},
  ],
  '4': [ReplyControl_VoteOption_LabelKind$json],
};

@$core.Deprecated('Use replyControlDescriptor instead')
const ReplyControl_VoteOption_LabelKind$json = {
  '1': 'LabelKind',
  '2': [
    {'1': 'DEFAULT_LabelKind', '2': 0},
    {'1': 'RED', '2': 1},
    {'1': 'BLUE', '2': 2},
    {'1': 'PLAIN', '2': 3},
  ],
};

/// Descriptor for `ReplyControl`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replyControlDescriptor = $convert.base64Decode(
    'CgxSZXBseUNvbnRyb2wSFgoGYWN0aW9uGAEgASgDUgZhY3Rpb24SFwoHdXBfbGlrZRgCIAEoCF'
    'IGdXBMaWtlEhkKCHVwX3JlcGx5GAMgASgIUgd1cFJlcGx5EiYKD3Nob3dfZm9sbG93X2J0bhgE'
    'IAEoCFINc2hvd0ZvbGxvd0J0bhIbCglpc19hc3Npc3QYBSABKAhSCGlzQXNzaXN0Eh0KCmxhYm'
    'VsX3RleHQYBiABKAlSCWxhYmVsVGV4dBIcCglmb2xsb3dpbmcYByABKAhSCWZvbGxvd2luZxIa'
    'Cghmb2xsb3dlZBgIIAEoCFIIZm9sbG93ZWQSGAoHYmxvY2tlZBgJIAEoCFIHYmxvY2tlZBIoCh'
    'BoYXNfZm9sZGVkX3JlcGx5GAogASgIUg5oYXNGb2xkZWRSZXBseRImCg9pc19mb2xkZWRfcmVw'
    'bHkYCyABKAhSDWlzRm9sZGVkUmVwbHkSGgoJaXNfdXBfdG9wGAwgASgIUgdpc1VwVG9wEiAKDG'
    'lzX2FkbWluX3RvcBgNIAEoCFIKaXNBZG1pblRvcBIeCgtpc192b3RlX3RvcBgOIAEoCFIJaXNW'
    'b3RlVG9wEhkKCG1heF9saW5lGA8gASgDUgdtYXhMaW5lEhwKCWludmlzaWJsZRgQIAEoCFIJaW'
    '52aXNpYmxlEiMKDWlzX2NvbnRyYWN0b3IYESABKAhSDGlzQ29udHJhY3RvchIXCgdpc19ub3Rl'
    'GBIgASgIUgZpc05vdGUSUQoLY2FyZF9sYWJlbHMYEyADKAsyMC5iaWxpYmlsaS5tYWluLmNvbW'
    '11bml0eS5yZXBseS52MS5SZXBseUNhcmRMYWJlbFIKY2FyZExhYmVscxIvChRzdWJfcmVwbHlf'
    'ZW50cnlfdGV4dBgUIAEoCVIRc3ViUmVwbHlFbnRyeVRleHQSLwoUc3ViX3JlcGx5X3RpdGxlX3'
    'RleHQYFSABKAlSEXN1YlJlcGx5VGl0bGVUZXh0EiMKDWNvbnRyYWN0X2Rlc2MYFiABKAlSDGNv'
    'bnRyYWN0RGVzYxIbCgl0aW1lX2Rlc2MYFyABKAlSCHRpbWVEZXNjEhsKCWJpel9zY2VuZRgYIA'
    'EoCVIIYml6U2NlbmUSGgoIbG9jYXRpb24YGSABKAlSCGxvY2F0aW9uEiMKDWZvbGRfcGljdHVy'
    'ZXMYGiABKAhSDGZvbGRQaWN0dXJlcxIcCgppc19ub3RlX3YyGBsgASgIUghpc05vdGVWMhIkCg'
    '5oaWRlX25vdGVfaWNvbhgcIAEoCFIMaGlkZU5vdGVJY29uEjQKFmNtX3JlY29tbWVuZF9jb21w'
    'b25lbnQYHSABKAlSFGNtUmVjb21tZW5kQ29tcG9uZW50EloKC3ZvdGVfb3B0aW9uGB4gASgLMj'
    'kuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuUmVwbHlDb250cm9sLlZvdGVPcHRp'
    'b25SCnZvdGVPcHRpb24SIQoMY2hhcmdlZF9kZXNjGB8gASgJUgtjaGFyZ2VkRGVzYxJdCgxncm'
    'FkZV9yZWNvcmQYICABKAsyOi5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5SZXBs'
    'eUNvbnRyb2wuR3JhZGVSZWNvcmRSC2dyYWRlUmVjb3JkEioKEXByZXNldF9yZXBseV90ZXh0GC'
    'EgASgJUg9wcmVzZXRSZXBseVRleHQSZwoQZWFzdGVyX2VnZ19sYWJlbBgiIAEoCzI9LmJpbGli'
    'aWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLlJlcGx5Q29udHJvbC5FYXN0ZXJFZ2dMYWJlbF'
    'IOZWFzdGVyRWdnTGFiZWwSJwoPY29udGV4dF9mZWF0dXJlGCMgASgJUg5jb250ZXh0RmVhdHVy'
    'ZRJgCg1pbnNlcnRfZWZmZWN0GCQgASgLMjsuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbH'
    'kudjEuUmVwbHlDb250cm9sLkluc2VydEVmZmVjdFIMaW5zZXJ0RWZmZWN0EmIKEnRyYW5zbGF0'
    'aW9uX3N3aXRjaBglIAEoDjIzLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLlRyYW'
    '5zbGF0aW9uU3dpdGNoUhF0cmFuc2xhdGlvblN3aXRjaBIpChBzaG93X3RyYW5zbGF0aW9uGGQg'
    'ASgIUg9zaG93VHJhbnNsYXRpb24aQQoORWFzdGVyRWdnTGFiZWwSFAoFaW1hZ2UYASABKAlSBW'
    'ltYWdlEhkKCGp1bXBfdXJsGAIgASgJUgdqdW1wVXJsGtcBCgtHcmFkZVJlY29yZBIUCgVzY29y'
    'ZRgBIAEoBVIFc2NvcmUSVQoFdGV4dHMYAiADKAsyPy5iaWxpYmlsaS5tYWluLmNvbW11bml0eS'
    '5yZXBseS52MS5SZXBseUNvbnRyb2wuR3JhZGVSZWNvcmQuVGV4dFIFdGV4dHMaWwoEVGV4dBIQ'
    'CgNyYXcYASABKAlSA3JhdxJBCgVzdHlsZRgCIAEoCzIrLmJpbGliaWxpLm1haW4uY29tbXVuaX'
    'R5LnJlcGx5LnYxLlRleHRTdHlsZVIFc3R5bGUaPAoMSW5zZXJ0RWZmZWN0EhgKB2NvbnRlbnQY'
    'ASABKAlSB2NvbnRlbnQSEgoEaWNvbhgCIAEoCVIEaWNvbhrxAQoKVm90ZU9wdGlvbhJiCgpsYW'
    'JlbF9raW5kGAEgASgOMkMuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuUmVwbHlD'
    'b250cm9sLlZvdGVPcHRpb24uTGFiZWxLaW5kUglsYWJlbEtpbmQSEgoEZGVzYxgCIAEoCVIEZG'
    'VzYxIQCgNpZHgYAyABKANSA2lkeBIXCgd2b3RlX2lkGAQgASgDUgZ2b3RlSWQiQAoJTGFiZWxL'
    'aW5kEhUKEURFRkFVTFRfTGFiZWxLaW5kEAASBwoDUkVEEAESCAoEQkxVRRACEgkKBVBMQUlOEA'
    'M=');

@$core.Deprecated('Use replyExtraDescriptor instead')
const ReplyExtra$json = {
  '1': 'ReplyExtra',
  '2': [
    {'1': 'season_id', '3': 1, '4': 1, '5': 3, '10': 'seasonId'},
    {'1': 'season_type', '3': 2, '4': 1, '5': 3, '10': 'seasonType'},
    {'1': 'ep_id', '3': 3, '4': 1, '5': 3, '10': 'epId'},
    {'1': 'is_story', '3': 4, '4': 1, '5': 8, '10': 'isStory'},
    {'1': 'spmid', '3': 5, '4': 1, '5': 9, '10': 'spmid'},
    {'1': 'from_spmid', '3': 6, '4': 1, '5': 9, '10': 'fromSpmid'},
    {
      '1': 'disable_underline',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'disableUnderline'
    },
    {'1': 'disable_we_search', '3': 8, '4': 1, '5': 8, '10': 'disableWeSearch'},
    {
      '1': 'disable_filter_tag',
      '3': 9,
      '4': 1,
      '5': 8,
      '10': 'disableFilterTag'
    },
    {'1': 'is_activity_mode', '3': 10, '4': 1, '5': 8, '10': 'isActivityMode'},
    {'1': 'track_id', '3': 11, '4': 1, '5': 9, '10': 'trackId'},
  ],
};

/// Descriptor for `ReplyExtra`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replyExtraDescriptor = $convert.base64Decode(
    'CgpSZXBseUV4dHJhEhsKCXNlYXNvbl9pZBgBIAEoA1IIc2Vhc29uSWQSHwoLc2Vhc29uX3R5cG'
    'UYAiABKANSCnNlYXNvblR5cGUSEwoFZXBfaWQYAyABKANSBGVwSWQSGQoIaXNfc3RvcnkYBCAB'
    'KAhSB2lzU3RvcnkSFAoFc3BtaWQYBSABKAlSBXNwbWlkEh0KCmZyb21fc3BtaWQYBiABKAlSCW'
    'Zyb21TcG1pZBIrChFkaXNhYmxlX3VuZGVybGluZRgHIAEoCFIQZGlzYWJsZVVuZGVybGluZRIq'
    'ChFkaXNhYmxlX3dlX3NlYXJjaBgIIAEoCFIPZGlzYWJsZVdlU2VhcmNoEiwKEmRpc2FibGVfZm'
    'lsdGVyX3RhZxgJIAEoCFIQZGlzYWJsZUZpbHRlclRhZxIoChBpc19hY3Rpdml0eV9tb2RlGAog'
    'ASgIUg5pc0FjdGl2aXR5TW9kZRIZCgh0cmFja19pZBgLIAEoCVIHdHJhY2tJZA==');

@$core.Deprecated('Use replyInAppPushPayloadDescriptor instead')
const ReplyInAppPushPayload$json = {
  '1': 'ReplyInAppPushPayload',
  '2': [
    {
      '1': 'reply',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInAppPushPayload.Reply',
      '10': 'reply'
    },
    {
      '1': 'parent_reply',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInAppPushPayload.Reply',
      '10': 'parentReply'
    },
    {
      '1': 'subject',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInAppPushPayload.Subject',
      '10': 'subject'
    },
    {
      '1': 'subject_material',
      '3': 4,
      '4': 1,
      '5': 11,
      '6':
          '.bilibili.main.community.reply.v1.ReplyInAppPushPayload.SubjectMaterial',
      '10': 'subjectMaterial'
    },
  ],
  '3': [
    ReplyInAppPushPayload_Content$json,
    ReplyInAppPushPayload_Member$json,
    ReplyInAppPushPayload_Reply$json,
    ReplyInAppPushPayload_Subject$json,
    ReplyInAppPushPayload_SubjectMaterial$json
  ],
};

@$core.Deprecated('Use replyInAppPushPayloadDescriptor instead')
const ReplyInAppPushPayload_Content$json = {
  '1': 'Content',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'emotes',
      '3': 2,
      '4': 3,
      '5': 11,
      '6':
          '.bilibili.main.community.reply.v1.ReplyInAppPushPayload.Content.EmotesEntry',
      '10': 'emotes'
    },
    {
      '1': 'at_name_to_mid',
      '3': 3,
      '4': 3,
      '5': 11,
      '6':
          '.bilibili.main.community.reply.v1.ReplyInAppPushPayload.Content.AtNameToMidEntry',
      '10': 'atNameToMid'
    },
    {
      '1': 'pictures',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Picture',
      '10': 'pictures'
    },
  ],
  '3': [
    ReplyInAppPushPayload_Content_EmotesEntry$json,
    ReplyInAppPushPayload_Content_AtNameToMidEntry$json
  ],
};

@$core.Deprecated('Use replyInAppPushPayloadDescriptor instead')
const ReplyInAppPushPayload_Content_EmotesEntry$json = {
  '1': 'EmotesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Emote',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use replyInAppPushPayloadDescriptor instead')
const ReplyInAppPushPayload_Content_AtNameToMidEntry$json = {
  '1': 'AtNameToMidEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 3, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use replyInAppPushPayloadDescriptor instead')
const ReplyInAppPushPayload_Member$json = {
  '1': 'Member',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'face', '3': 3, '4': 1, '5': 9, '10': 'face'},
  ],
};

@$core.Deprecated('Use replyInAppPushPayloadDescriptor instead')
const ReplyInAppPushPayload_Reply$json = {
  '1': 'Reply',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'type', '3': 2, '4': 1, '5': 3, '10': 'type'},
    {'1': 'oid', '3': 3, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'mid', '3': 4, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'root', '3': 5, '4': 1, '5': 3, '10': 'root'},
    {'1': 'parent', '3': 6, '4': 1, '5': 3, '10': 'parent'},
    {'1': 'dialog', '3': 7, '4': 1, '5': 3, '10': 'dialog'},
    {'1': 'ctime', '3': 8, '4': 1, '5': 3, '10': 'ctime'},
    {
      '1': 'content',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInAppPushPayload.Content',
      '10': 'content'
    },
    {
      '1': 'member',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInAppPushPayload.Member',
      '10': 'member'
    },
  ],
};

@$core.Deprecated('Use replyInAppPushPayloadDescriptor instead')
const ReplyInAppPushPayload_Subject$json = {
  '1': 'Subject',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 3, '10': 'type'},
    {'1': 'oid', '3': 2, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'up_mid', '3': 3, '4': 1, '5': 3, '10': 'upMid'},
  ],
};

@$core.Deprecated('Use replyInAppPushPayloadDescriptor instead')
const ReplyInAppPushPayload_SubjectMaterial$json = {
  '1': 'SubjectMaterial',
  '2': [
    {
      '1': 'arc',
      '3': 1,
      '4': 1,
      '5': 11,
      '6':
          '.bilibili.main.community.reply.v1.ReplyInAppPushPayload.SubjectMaterial.Archive',
      '9': 0,
      '10': 'arc'
    },
  ],
  '3': [ReplyInAppPushPayload_SubjectMaterial_Archive$json],
  '8': [
    {'1': 'item'},
  ],
};

@$core.Deprecated('Use replyInAppPushPayloadDescriptor instead')
const ReplyInAppPushPayload_SubjectMaterial_Archive$json = {
  '1': 'Archive',
  '2': [
    {'1': 'aid', '3': 1, '4': 1, '5': 3, '10': 'aid'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'cover', '3': 3, '4': 1, '5': 9, '10': 'cover'},
  ],
};

/// Descriptor for `ReplyInAppPushPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replyInAppPushPayloadDescriptor = $convert.base64Decode(
    'ChVSZXBseUluQXBwUHVzaFBheWxvYWQSUwoFcmVwbHkYASABKAsyPS5iaWxpYmlsaS5tYWluLm'
    'NvbW11bml0eS5yZXBseS52MS5SZXBseUluQXBwUHVzaFBheWxvYWQuUmVwbHlSBXJlcGx5EmAK'
    'DHBhcmVudF9yZXBseRgCIAEoCzI9LmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLl'
    'JlcGx5SW5BcHBQdXNoUGF5bG9hZC5SZXBseVILcGFyZW50UmVwbHkSWQoHc3ViamVjdBgDIAEo'
    'CzI/LmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLlJlcGx5SW5BcHBQdXNoUGF5bG'
    '9hZC5TdWJqZWN0UgdzdWJqZWN0EnIKEHN1YmplY3RfbWF0ZXJpYWwYBCABKAsyRy5iaWxpYmls'
    'aS5tYWluLmNvbW11bml0eS5yZXBseS52MS5SZXBseUluQXBwUHVzaFBheWxvYWQuU3ViamVjdE'
    '1hdGVyaWFsUg9zdWJqZWN0TWF0ZXJpYWwa6gMKB0NvbnRlbnQSGAoHbWVzc2FnZRgBIAEoCVIH'
    'bWVzc2FnZRJjCgZlbW90ZXMYAiADKAsySy5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS'
    '52MS5SZXBseUluQXBwUHVzaFBheWxvYWQuQ29udGVudC5FbW90ZXNFbnRyeVIGZW1vdGVzEnUK'
    'DmF0X25hbWVfdG9fbWlkGAMgAygLMlAuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudj'
    'EuUmVwbHlJbkFwcFB1c2hQYXlsb2FkLkNvbnRlbnQuQXROYW1lVG9NaWRFbnRyeVILYXROYW1l'
    'VG9NaWQSRQoIcGljdHVyZXMYBCADKAsyKS5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS'
    '52MS5QaWN0dXJlUghwaWN0dXJlcxpiCgtFbW90ZXNFbnRyeRIQCgNrZXkYASABKAlSA2tleRI9'
    'CgV2YWx1ZRgCIAEoCzInLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLkVtb3RlUg'
    'V2YWx1ZToCOAEaPgoQQXROYW1lVG9NaWRFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1'
    'ZRgCIAEoA1IFdmFsdWU6AjgBGkIKBk1lbWJlchIQCgNtaWQYASABKANSA21pZBISCgRuYW1lGA'
    'IgASgJUgRuYW1lEhIKBGZhY2UYAyABKAlSBGZhY2Ua3AIKBVJlcGx5Eg4KAmlkGAEgASgDUgJp'
    'ZBISCgR0eXBlGAIgASgDUgR0eXBlEhAKA29pZBgDIAEoA1IDb2lkEhAKA21pZBgEIAEoA1IDbW'
    'lkEhIKBHJvb3QYBSABKANSBHJvb3QSFgoGcGFyZW50GAYgASgDUgZwYXJlbnQSFgoGZGlhbG9n'
    'GAcgASgDUgZkaWFsb2cSFAoFY3RpbWUYCCABKANSBWN0aW1lElkKB2NvbnRlbnQYCSABKAsyPy'
    '5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5SZXBseUluQXBwUHVzaFBheWxvYWQu'
    'Q29udGVudFIHY29udGVudBJWCgZtZW1iZXIYCiABKAsyPi5iaWxpYmlsaS5tYWluLmNvbW11bm'
    'l0eS5yZXBseS52MS5SZXBseUluQXBwUHVzaFBheWxvYWQuTWVtYmVyUgZtZW1iZXIaRgoHU3Vi'
    'amVjdBISCgR0eXBlGAEgASgDUgR0eXBlEhAKA29pZBgCIAEoA1IDb2lkEhUKBnVwX21pZBgDIA'
    'EoA1IFdXBNaWQaxwEKD1N1YmplY3RNYXRlcmlhbBJjCgNhcmMYASABKAsyTy5iaWxpYmlsaS5t'
    'YWluLmNvbW11bml0eS5yZXBseS52MS5SZXBseUluQXBwUHVzaFBheWxvYWQuU3ViamVjdE1hdG'
    'VyaWFsLkFyY2hpdmVIAFIDYXJjGkcKB0FyY2hpdmUSEAoDYWlkGAEgASgDUgNhaWQSFAoFdGl0'
    'bGUYAiABKAlSBXRpdGxlEhQKBWNvdmVyGAMgASgJUgVjb3ZlckIGCgRpdGVt');

@$core.Deprecated('Use replyInfoDescriptor instead')
const ReplyInfo$json = {
  '1': 'ReplyInfo',
  '2': [
    {
      '1': 'replies',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInfo',
      '10': 'replies'
    },
    {'1': 'id', '3': 2, '4': 1, '5': 3, '10': 'id'},
    {'1': 'oid', '3': 3, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'type', '3': 4, '4': 1, '5': 3, '10': 'type'},
    {'1': 'mid', '3': 5, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'root', '3': 6, '4': 1, '5': 3, '10': 'root'},
    {'1': 'parent', '3': 7, '4': 1, '5': 3, '10': 'parent'},
    {'1': 'dialog', '3': 8, '4': 1, '5': 3, '10': 'dialog'},
    {'1': 'like', '3': 9, '4': 1, '5': 3, '10': 'like'},
    {'1': 'ctime', '3': 10, '4': 1, '5': 3, '10': 'ctime'},
    {'1': 'count', '3': 11, '4': 1, '5': 3, '10': 'count'},
    {
      '1': 'content',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Content',
      '10': 'content'
    },
    {
      '1': 'member',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Member',
      '10': 'member'
    },
    {
      '1': 'reply_control',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyControl',
      '10': 'replyControl'
    },
    {
      '1': 'member_v2',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.MemberV2',
      '10': 'memberV2'
    },
    {'1': 'track_info', '3': 16, '4': 1, '5': 9, '10': 'trackInfo'},
    {
      '1': 'translated_content',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Content',
      '10': 'translatedContent'
    },
  ],
};

/// Descriptor for `ReplyInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replyInfoDescriptor = $convert.base64Decode(
    'CglSZXBseUluZm8SRQoHcmVwbGllcxgBIAMoCzIrLmJpbGliaWxpLm1haW4uY29tbXVuaXR5Ln'
    'JlcGx5LnYxLlJlcGx5SW5mb1IHcmVwbGllcxIOCgJpZBgCIAEoA1ICaWQSEAoDb2lkGAMgASgD'
    'UgNvaWQSEgoEdHlwZRgEIAEoA1IEdHlwZRIQCgNtaWQYBSABKANSA21pZBISCgRyb290GAYgAS'
    'gDUgRyb290EhYKBnBhcmVudBgHIAEoA1IGcGFyZW50EhYKBmRpYWxvZxgIIAEoA1IGZGlhbG9n'
    'EhIKBGxpa2UYCSABKANSBGxpa2USFAoFY3RpbWUYCiABKANSBWN0aW1lEhQKBWNvdW50GAsgAS'
    'gDUgVjb3VudBJDCgdjb250ZW50GAwgASgLMikuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVw'
    'bHkudjEuQ29udGVudFIHY29udGVudBJACgZtZW1iZXIYDSABKAsyKC5iaWxpYmlsaS5tYWluLm'
    'NvbW11bml0eS5yZXBseS52MS5NZW1iZXJSBm1lbWJlchJTCg1yZXBseV9jb250cm9sGA4gASgL'
    'Mi4uYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuUmVwbHlDb250cm9sUgxyZXBseU'
    'NvbnRyb2wSRwoJbWVtYmVyX3YyGA8gASgLMiouYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVw'
    'bHkudjEuTWVtYmVyVjJSCG1lbWJlclYyEh0KCnRyYWNrX2luZm8YECABKAlSCXRyYWNrSW5mbx'
    'JYChJ0cmFuc2xhdGVkX2NvbnRlbnQYESABKAsyKS5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5y'
    'ZXBseS52MS5Db250ZW50UhF0cmFuc2xhdGVkQ29udGVudA==');

@$core.Deprecated('Use replyInfoReplyDescriptor instead')
const ReplyInfoReply$json = {
  '1': 'ReplyInfoReply',
  '2': [
    {
      '1': 'reply',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInfo',
      '10': 'reply'
    },
  ],
};

/// Descriptor for `ReplyInfoReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replyInfoReplyDescriptor = $convert.base64Decode(
    'Cg5SZXBseUluZm9SZXBseRJBCgVyZXBseRgBIAEoCzIrLmJpbGliaWxpLm1haW4uY29tbXVuaX'
    'R5LnJlcGx5LnYxLlJlcGx5SW5mb1IFcmVwbHk=');

@$core.Deprecated('Use replyInfoReqDescriptor instead')
const ReplyInfoReq$json = {
  '1': 'ReplyInfoReq',
  '2': [
    {'1': 'rpid', '3': 1, '4': 1, '5': 3, '10': 'rpid'},
    {
      '1': 'scene',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.ReplyInfoReq.ReplyInfoScene',
      '10': 'scene'
    },
  ],
  '4': [ReplyInfoReq_ReplyInfoScene$json],
};

@$core.Deprecated('Use replyInfoReqDescriptor instead')
const ReplyInfoReq_ReplyInfoScene$json = {
  '1': 'ReplyInfoScene',
  '2': [
    {'1': 'Insert', '2': 0},
  ],
};

/// Descriptor for `ReplyInfoReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replyInfoReqDescriptor = $convert.base64Decode(
    'CgxSZXBseUluZm9SZXESEgoEcnBpZBgBIAEoA1IEcnBpZBJTCgVzY2VuZRgCIAEoDjI9LmJpbG'
    'liaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLlJlcGx5SW5mb1JlcS5SZXBseUluZm9TY2Vu'
    'ZVIFc2NlbmUiHAoOUmVwbHlJbmZvU2NlbmUSCgoGSW5zZXJ0EAA=');

@$core.Deprecated('Use replyTrackInfoDescriptor instead')
const ReplyTrackInfo$json = {
  '1': 'ReplyTrackInfo',
  '2': [
    {'1': 'track_id', '3': 1, '4': 1, '5': 9, '10': 'trackId'},
  ],
};

/// Descriptor for `ReplyTrackInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replyTrackInfoDescriptor = $convert.base64Decode(
    'Cg5SZXBseVRyYWNrSW5mbxIZCgh0cmFja19pZBgBIAEoCVIHdHJhY2tJZA==');

@$core.Deprecated('Use richTextDescriptor instead')
const RichText$json = {
  '1': 'RichText',
  '2': [
    {
      '1': 'note',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.RichTextNote',
      '9': 0,
      '10': 'note'
    },
    {
      '1': 'opus',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.dynamic.v2.OpusItem',
      '9': 0,
      '10': 'opus'
    },
  ],
  '8': [
    {'1': 'item'},
  ],
};

/// Descriptor for `RichText`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List richTextDescriptor = $convert.base64Decode(
    'CghSaWNoVGV4dBJECgRub3RlGAEgASgLMi4uYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbH'
    'kudjEuUmljaFRleHROb3RlSABSBG5vdGUSNwoEb3B1cxgCIAEoCzIhLmJpbGliaWxpLmFwcC5k'
    'eW5hbWljLnYyLk9wdXNJdGVtSABSBG9wdXNCBgoEaXRlbQ==');

@$core.Deprecated('Use richTextNoteDescriptor instead')
const RichTextNote$json = {
  '1': 'RichTextNote',
  '2': [
    {'1': 'summary', '3': 1, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'images', '3': 2, '4': 3, '5': 9, '10': 'images'},
    {'1': 'click_url', '3': 3, '4': 1, '5': 9, '10': 'clickUrl'},
    {'1': 'last_mtime_text', '3': 4, '4': 1, '5': 9, '10': 'lastMtimeText'},
  ],
};

/// Descriptor for `RichTextNote`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List richTextNoteDescriptor = $convert.base64Decode(
    'CgxSaWNoVGV4dE5vdGUSGAoHc3VtbWFyeRgBIAEoCVIHc3VtbWFyeRIWCgZpbWFnZXMYAiADKA'
    'lSBmltYWdlcxIbCgljbGlja191cmwYAyABKAlSCGNsaWNrVXJsEiYKD2xhc3RfbXRpbWVfdGV4'
    'dBgEIAEoCVINbGFzdE10aW1lVGV4dA==');

@$core.Deprecated('Use searchItemDescriptor instead')
const SearchItem$json = {
  '1': 'SearchItem',
  '2': [
    {
      '1': 'goods',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.GoodsSearchItem',
      '9': 0,
      '10': 'goods'
    },
    {
      '1': 'video',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.VideoSearchItem',
      '9': 0,
      '10': 'video'
    },
    {
      '1': 'article',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ArticleSearchItem',
      '9': 0,
      '10': 'article'
    },
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
  ],
  '8': [
    {'1': 'item'},
  ],
};

/// Descriptor for `SearchItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchItemDescriptor = $convert.base64Decode(
    'CgpTZWFyY2hJdGVtEkkKBWdvb2RzGAIgASgLMjEuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucm'
    'VwbHkudjEuR29vZHNTZWFyY2hJdGVtSABSBWdvb2RzEkkKBXZpZGVvGAMgASgLMjEuYmlsaWJp'
    'bGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuVmlkZW9TZWFyY2hJdGVtSABSBXZpZGVvEk8KB2'
    'FydGljbGUYBCABKAsyMy5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5BcnRpY2xl'
    'U2VhcmNoSXRlbUgAUgdhcnRpY2xlEhAKA3VybBgBIAEoCVIDdXJsQgYKBGl0ZW0=');

@$core.Deprecated('Use searchItemCursorReplyDescriptor instead')
const SearchItemCursorReply$json = {
  '1': 'SearchItemCursorReply',
  '2': [
    {'1': 'has_next', '3': 1, '4': 1, '5': 8, '10': 'hasNext'},
    {'1': 'next', '3': 2, '4': 1, '5': 3, '10': 'next'},
  ],
};

/// Descriptor for `SearchItemCursorReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchItemCursorReplyDescriptor = $convert.base64Decode(
    'ChVTZWFyY2hJdGVtQ3Vyc29yUmVwbHkSGQoIaGFzX25leHQYASABKAhSB2hhc05leHQSEgoEbm'
    'V4dBgCIAEoA1IEbmV4dA==');

@$core.Deprecated('Use searchItemCursorReqDescriptor instead')
const SearchItemCursorReq$json = {
  '1': 'SearchItemCursorReq',
  '2': [
    {'1': 'next', '3': 1, '4': 1, '5': 3, '10': 'next'},
    {
      '1': 'item_type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.SearchItemType',
      '10': 'itemType'
    },
  ],
};

/// Descriptor for `SearchItemCursorReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchItemCursorReqDescriptor = $convert.base64Decode(
    'ChNTZWFyY2hJdGVtQ3Vyc29yUmVxEhIKBG5leHQYASABKANSBG5leHQSTQoJaXRlbV90eXBlGA'
    'IgASgOMjAuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuU2VhcmNoSXRlbVR5cGVS'
    'CGl0ZW1UeXBl');

@$core.Deprecated('Use searchItemPreHookReplyDescriptor instead')
const SearchItemPreHookReply$json = {
  '1': 'SearchItemPreHookReply',
  '2': [
    {'1': 'placeholder_text', '3': 1, '4': 1, '5': 9, '10': 'placeholderText'},
    {'1': 'background_text', '3': 2, '4': 1, '5': 9, '10': 'backgroundText'},
    {'1': 'ordered_type', '3': 3, '4': 3, '5': 5, '10': 'orderedType'},
  ],
};

/// Descriptor for `SearchItemPreHookReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchItemPreHookReplyDescriptor = $convert.base64Decode(
    'ChZTZWFyY2hJdGVtUHJlSG9va1JlcGx5EikKEHBsYWNlaG9sZGVyX3RleHQYASABKAlSD3BsYW'
    'NlaG9sZGVyVGV4dBInCg9iYWNrZ3JvdW5kX3RleHQYAiABKAlSDmJhY2tncm91bmRUZXh0EiEK'
    'DG9yZGVyZWRfdHlwZRgDIAMoBVILb3JkZXJlZFR5cGU=');

@$core.Deprecated('Use searchItemPreHookReqDescriptor instead')
const SearchItemPreHookReq$json = {
  '1': 'SearchItemPreHookReq',
  '2': [
    {'1': 'oid', '3': 1, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'type', '3': 2, '4': 1, '5': 3, '10': 'type'},
  ],
};

/// Descriptor for `SearchItemPreHookReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchItemPreHookReqDescriptor = $convert.base64Decode(
    'ChRTZWFyY2hJdGVtUHJlSG9va1JlcRIQCgNvaWQYASABKANSA29pZBISCgR0eXBlGAIgASgDUg'
    'R0eXBl');

@$core.Deprecated('Use searchItemReplyDescriptor instead')
const SearchItemReply$json = {
  '1': 'SearchItemReply',
  '2': [
    {
      '1': 'cursor',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.SearchItemCursorReply',
      '10': 'cursor'
    },
    {
      '1': 'items',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.SearchItem',
      '10': 'items'
    },
    {
      '1': 'extra',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.SearchItemReplyExtraInfo',
      '10': 'extra'
    },
  ],
};

/// Descriptor for `SearchItemReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchItemReplyDescriptor = $convert.base64Decode(
    'Cg9TZWFyY2hJdGVtUmVwbHkSTwoGY3Vyc29yGAEgASgLMjcuYmlsaWJpbGkubWFpbi5jb21tdW'
    '5pdHkucmVwbHkudjEuU2VhcmNoSXRlbUN1cnNvclJlcGx5UgZjdXJzb3ISQgoFaXRlbXMYAiAD'
    'KAsyLC5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5TZWFyY2hJdGVtUgVpdGVtcx'
    'JQCgVleHRyYRgDIAEoCzI6LmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLlNlYXJj'
    'aEl0ZW1SZXBseUV4dHJhSW5mb1IFZXh0cmE=');

@$core.Deprecated('Use searchItemReplyExtraInfoDescriptor instead')
const SearchItemReplyExtraInfo$json = {
  '1': 'SearchItemReplyExtraInfo',
  '2': [
    {'1': 'event_id', '3': 1, '4': 1, '5': 9, '10': 'eventId'},
  ],
};

/// Descriptor for `SearchItemReplyExtraInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchItemReplyExtraInfoDescriptor =
    $convert.base64Decode(
        'ChhTZWFyY2hJdGVtUmVwbHlFeHRyYUluZm8SGQoIZXZlbnRfaWQYASABKAlSB2V2ZW50SWQ=');

@$core.Deprecated('Use searchItemReqDescriptor instead')
const SearchItemReq$json = {
  '1': 'SearchItemReq',
  '2': [
    {
      '1': 'cursor',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.SearchItemCursorReq',
      '10': 'cursor'
    },
    {'1': 'oid', '3': 2, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'type', '3': 3, '4': 1, '5': 3, '10': 'type'},
    {'1': 'keyword', '3': 4, '4': 1, '5': 9, '10': 'keyword'},
  ],
};

/// Descriptor for `SearchItemReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchItemReqDescriptor = $convert.base64Decode(
    'Cg1TZWFyY2hJdGVtUmVxEk0KBmN1cnNvchgBIAEoCzI1LmJpbGliaWxpLm1haW4uY29tbXVuaX'
    'R5LnJlcGx5LnYxLlNlYXJjaEl0ZW1DdXJzb3JSZXFSBmN1cnNvchIQCgNvaWQYAiABKANSA29p'
    'ZBISCgR0eXBlGAMgASgDUgR0eXBlEhgKB2tleXdvcmQYBCABKAlSB2tleXdvcmQ=');

@$core.Deprecated('Use shareRepliesInfoReqDescriptor instead')
const ShareRepliesInfoReq$json = {
  '1': 'ShareRepliesInfoReq',
  '2': [
    {'1': 'rpids', '3': 1, '4': 3, '5': 3, '10': 'rpids'},
    {'1': 'oid', '3': 2, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'type', '3': 3, '4': 1, '5': 3, '10': 'type'},
  ],
};

/// Descriptor for `ShareRepliesInfoReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shareRepliesInfoReqDescriptor = $convert.base64Decode(
    'ChNTaGFyZVJlcGxpZXNJbmZvUmVxEhQKBXJwaWRzGAEgAygDUgVycGlkcxIQCgNvaWQYAiABKA'
    'NSA29pZBISCgR0eXBlGAMgASgDUgR0eXBl');

@$core.Deprecated('Use shareRepliesInfoRespDescriptor instead')
const ShareRepliesInfoResp$json = {
  '1': 'ShareRepliesInfoResp',
  '2': [
    {
      '1': 'infos',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ShareReplyInfo',
      '10': 'infos'
    },
    {'1': 'from_title', '3': 2, '4': 1, '5': 9, '10': 'fromTitle'},
    {'1': 'from_up', '3': 3, '4': 1, '5': 9, '10': 'fromUp'},
    {'1': 'from_pic', '3': 4, '4': 1, '5': 9, '10': 'fromPic'},
    {'1': 'url', '3': 5, '4': 1, '5': 9, '10': 'url'},
    {'1': 'slogan_pic', '3': 6, '4': 1, '5': 9, '10': 'sloganPic'},
    {'1': 'slogan_text', '3': 7, '4': 1, '5': 9, '10': 'sloganText'},
    {
      '1': 'topic',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ShareReplyTopic',
      '10': 'topic'
    },
    {
      '1': 'extra',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ShareRepliesInfoResp.ShareExtra',
      '10': 'extra'
    },
  ],
  '3': [ShareRepliesInfoResp_ShareExtra$json],
};

@$core.Deprecated('Use shareRepliesInfoRespDescriptor instead')
const ShareRepliesInfoResp_ShareExtra$json = {
  '1': 'ShareExtra',
  '2': [
    {'1': 'is_pgc', '3': 1, '4': 1, '5': 8, '10': 'isPgc'},
  ],
};

/// Descriptor for `ShareRepliesInfoResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shareRepliesInfoRespDescriptor = $convert.base64Decode(
    'ChRTaGFyZVJlcGxpZXNJbmZvUmVzcBJGCgVpbmZvcxgBIAMoCzIwLmJpbGliaWxpLm1haW4uY2'
    '9tbXVuaXR5LnJlcGx5LnYxLlNoYXJlUmVwbHlJbmZvUgVpbmZvcxIdCgpmcm9tX3RpdGxlGAIg'
    'ASgJUglmcm9tVGl0bGUSFwoHZnJvbV91cBgDIAEoCVIGZnJvbVVwEhkKCGZyb21fcGljGAQgAS'
    'gJUgdmcm9tUGljEhAKA3VybBgFIAEoCVIDdXJsEh0KCnNsb2dhbl9waWMYBiABKAlSCXNsb2dh'
    'blBpYxIfCgtzbG9nYW5fdGV4dBgHIAEoCVIKc2xvZ2FuVGV4dBJHCgV0b3BpYxgIIAEoCzIxLm'
    'JpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLlNoYXJlUmVwbHlUb3BpY1IFdG9waWMS'
    'VwoFZXh0cmEYCSABKAsyQS5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5TaGFyZV'
    'JlcGxpZXNJbmZvUmVzcC5TaGFyZUV4dHJhUgVleHRyYRojCgpTaGFyZUV4dHJhEhUKBmlzX3Bn'
    'YxgBIAEoCFIFaXNQZ2M=');

@$core.Deprecated('Use shareReplyInfoDescriptor instead')
const ShareReplyInfo$json = {
  '1': 'ShareReplyInfo',
  '2': [
    {
      '1': 'member',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Member',
      '10': 'member'
    },
    {
      '1': 'content',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Content',
      '10': 'content'
    },
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'sub_title', '3': 4, '4': 1, '5': 9, '10': 'subTitle'},
    {'1': 'achievement_text', '3': 5, '4': 1, '5': 9, '10': 'achievementText'},
    {'1': 'label_url', '3': 6, '4': 1, '5': 9, '10': 'labelUrl'},
  ],
};

/// Descriptor for `ShareReplyInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shareReplyInfoDescriptor = $convert.base64Decode(
    'Cg5TaGFyZVJlcGx5SW5mbxJACgZtZW1iZXIYASABKAsyKC5iaWxpYmlsaS5tYWluLmNvbW11bm'
    'l0eS5yZXBseS52MS5NZW1iZXJSBm1lbWJlchJDCgdjb250ZW50GAIgASgLMikuYmlsaWJpbGku'
    'bWFpbi5jb21tdW5pdHkucmVwbHkudjEuQ29udGVudFIHY29udGVudBIUCgV0aXRsZRgDIAEoCV'
    'IFdGl0bGUSGwoJc3ViX3RpdGxlGAQgASgJUghzdWJUaXRsZRIpChBhY2hpZXZlbWVudF90ZXh0'
    'GAUgASgJUg9hY2hpZXZlbWVudFRleHQSGwoJbGFiZWxfdXJsGAYgASgJUghsYWJlbFVybA==');

@$core.Deprecated('Use shareReplyMaterialReqDescriptor instead')
const ShareReplyMaterialReq$json = {
  '1': 'ShareReplyMaterialReq',
  '2': [
    {'1': 'oid', '3': 1, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'type', '3': 2, '4': 1, '5': 3, '10': 'type'},
    {'1': 'rpid', '3': 3, '4': 1, '5': 3, '10': 'rpid'},
  ],
};

/// Descriptor for `ShareReplyMaterialReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shareReplyMaterialReqDescriptor = $convert.base64Decode(
    'ChVTaGFyZVJlcGx5TWF0ZXJpYWxSZXESEAoDb2lkGAEgASgDUgNvaWQSEgoEdHlwZRgCIAEoA1'
    'IEdHlwZRISCgRycGlkGAMgASgDUgRycGlk');

@$core.Deprecated('Use shareReplyMaterialRespDescriptor instead')
const ShareReplyMaterialResp$json = {
  '1': 'ShareReplyMaterialResp',
  '2': [
    {
      '1': 'subject_material',
      '3': 1,
      '4': 1,
      '5': 11,
      '6':
          '.bilibili.main.community.reply.v1.ShareReplyMaterialResp.SubjectMaterial',
      '10': 'subjectMaterial'
    },
    {'1': 'qrcode_url', '3': 2, '4': 1, '5': 9, '10': 'qrcodeUrl'},
    {'1': 'save_pic_text', '3': 3, '4': 1, '5': 9, '10': 'savePicText'},
    {'1': 'open_app_text', '3': 4, '4': 1, '5': 9, '10': 'openAppText'},
    {'1': 'share_time_text', '3': 5, '4': 1, '5': 9, '10': 'shareTimeText'},
    {'1': 'bili_logo_icon', '3': 6, '4': 1, '5': 9, '10': 'biliLogoIcon'},
    {
      '1': 'extra',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ShareReplyMaterialResp.ExtraData',
      '10': 'extra'
    },
  ],
  '3': [
    ShareReplyMaterialResp_ArchiveMaterial$json,
    ShareReplyMaterialResp_ArticleMaterial$json,
    ShareReplyMaterialResp_DynamicMaterial$json,
    ShareReplyMaterialResp_ExtraData$json,
    ShareReplyMaterialResp_SubjectMaterial$json
  ],
};

@$core.Deprecated('Use shareReplyMaterialRespDescriptor instead')
const ShareReplyMaterialResp_ArchiveMaterial$json = {
  '1': 'ArchiveMaterial',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'cover', '3': 2, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'up_name', '3': 3, '4': 1, '5': 9, '10': 'upName'},
    {'1': 'up_icon', '3': 4, '4': 1, '5': 9, '10': 'upIcon'},
  ],
};

@$core.Deprecated('Use shareReplyMaterialRespDescriptor instead')
const ShareReplyMaterialResp_ArticleMaterial$json = {
  '1': 'ArticleMaterial',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

@$core.Deprecated('Use shareReplyMaterialRespDescriptor instead')
const ShareReplyMaterialResp_DynamicMaterial$json = {
  '1': 'DynamicMaterial',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

@$core.Deprecated('Use shareReplyMaterialRespDescriptor instead')
const ShareReplyMaterialResp_ExtraData$json = {
  '1': 'ExtraData',
  '2': [
    {'1': 'is_pgc', '3': 1, '4': 1, '5': 8, '10': 'isPgc'},
    {'1': 'origin_text', '3': 2, '4': 1, '5': 9, '10': 'originText'},
    {'1': 'topic_id', '3': 3, '4': 1, '5': 3, '10': 'topicId'},
  ],
};

@$core.Deprecated('Use shareReplyMaterialRespDescriptor instead')
const ShareReplyMaterialResp_SubjectMaterial$json = {
  '1': 'SubjectMaterial',
  '2': [
    {
      '1': 'archive_material',
      '3': 1,
      '4': 1,
      '5': 11,
      '6':
          '.bilibili.main.community.reply.v1.ShareReplyMaterialResp.ArchiveMaterial',
      '9': 0,
      '10': 'archiveMaterial'
    },
    {
      '1': 'dynamic_material',
      '3': 2,
      '4': 1,
      '5': 11,
      '6':
          '.bilibili.main.community.reply.v1.ShareReplyMaterialResp.DynamicMaterial',
      '9': 0,
      '10': 'dynamicMaterial'
    },
    {
      '1': 'article_material',
      '3': 3,
      '4': 1,
      '5': 11,
      '6':
          '.bilibili.main.community.reply.v1.ShareReplyMaterialResp.ArticleMaterial',
      '9': 0,
      '10': 'articleMaterial'
    },
  ],
  '8': [
    {'1': 'item'},
  ],
};

/// Descriptor for `ShareReplyMaterialResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shareReplyMaterialRespDescriptor = $convert.base64Decode(
    'ChZTaGFyZVJlcGx5TWF0ZXJpYWxSZXNwEnMKEHN1YmplY3RfbWF0ZXJpYWwYASABKAsySC5iaW'
    'xpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5TaGFyZVJlcGx5TWF0ZXJpYWxSZXNwLlN1'
    'YmplY3RNYXRlcmlhbFIPc3ViamVjdE1hdGVyaWFsEh0KCnFyY29kZV91cmwYAiABKAlSCXFyY2'
    '9kZVVybBIiCg1zYXZlX3BpY190ZXh0GAMgASgJUgtzYXZlUGljVGV4dBIiCg1vcGVuX2FwcF90'
    'ZXh0GAQgASgJUgtvcGVuQXBwVGV4dBImCg9zaGFyZV90aW1lX3RleHQYBSABKAlSDXNoYXJlVG'
    'ltZVRleHQSJAoOYmlsaV9sb2dvX2ljb24YBiABKAlSDGJpbGlMb2dvSWNvbhJYCgVleHRyYRgH'
    'IAEoCzJCLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLlNoYXJlUmVwbHlNYXRlcm'
    'lhbFJlc3AuRXh0cmFEYXRhUgVleHRyYRpvCg9BcmNoaXZlTWF0ZXJpYWwSFAoFdGl0bGUYASAB'
    'KAlSBXRpdGxlEhQKBWNvdmVyGAIgASgJUgVjb3ZlchIXCgd1cF9uYW1lGAMgASgJUgZ1cE5hbW'
    'USFwoHdXBfaWNvbhgEIAEoCVIGdXBJY29uGkEKD0FydGljbGVNYXRlcmlhbBIUCgV0aXRsZRgB'
    'IAEoCVIFdGl0bGUSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZRpBCg9EeW5hbWljTWF0ZXJpYW'
    'wSFAoFdGl0bGUYASABKAlSBXRpdGxlEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2UaXgoJRXh0'
    'cmFEYXRhEhUKBmlzX3BnYxgBIAEoCFIFaXNQZ2MSHwoLb3JpZ2luX3RleHQYAiABKAlSCm9yaW'
    'dpblRleHQSGQoIdG9waWNfaWQYAyABKANSB3RvcGljSWQa/gIKD1N1YmplY3RNYXRlcmlhbBJ1'
    'ChBhcmNoaXZlX21hdGVyaWFsGAEgASgLMkguYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbH'
    'kudjEuU2hhcmVSZXBseU1hdGVyaWFsUmVzcC5BcmNoaXZlTWF0ZXJpYWxIAFIPYXJjaGl2ZU1h'
    'dGVyaWFsEnUKEGR5bmFtaWNfbWF0ZXJpYWwYAiABKAsySC5iaWxpYmlsaS5tYWluLmNvbW11bm'
    'l0eS5yZXBseS52MS5TaGFyZVJlcGx5TWF0ZXJpYWxSZXNwLkR5bmFtaWNNYXRlcmlhbEgAUg9k'
    'eW5hbWljTWF0ZXJpYWwSdQoQYXJ0aWNsZV9tYXRlcmlhbBgDIAEoCzJILmJpbGliaWxpLm1haW'
    '4uY29tbXVuaXR5LnJlcGx5LnYxLlNoYXJlUmVwbHlNYXRlcmlhbFJlc3AuQXJ0aWNsZU1hdGVy'
    'aWFsSABSD2FydGljbGVNYXRlcmlhbEIGCgRpdGVt');

@$core.Deprecated('Use shareReplyTopicDescriptor instead')
const ShareReplyTopic$json = {
  '1': 'ShareReplyTopic',
  '2': [
    {
      '1': 'topic',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Topic',
      '10': 'topic'
    },
    {'1': 'origin_text', '3': 2, '4': 1, '5': 9, '10': 'originText'},
  ],
};

/// Descriptor for `ShareReplyTopic`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shareReplyTopicDescriptor = $convert.base64Decode(
    'Cg9TaGFyZVJlcGx5VG9waWMSPQoFdG9waWMYASABKAsyJy5iaWxpYmlsaS5tYWluLmNvbW11bm'
    'l0eS5yZXBseS52MS5Ub3BpY1IFdG9waWMSHwoLb3JpZ2luX3RleHQYAiABKAlSCm9yaWdpblRl'
    'eHQ=');

@$core.Deprecated('Use subjectControlDescriptor instead')
const SubjectControl$json = {
  '1': 'SubjectControl',
  '2': [
    {'1': 'up_mid', '3': 1, '4': 1, '5': 3, '10': 'upMid'},
    {'1': 'is_assist', '3': 2, '4': 1, '5': 8, '10': 'isAssist'},
    {'1': 'read_only', '3': 3, '4': 1, '5': 8, '10': 'readOnly'},
    {'1': 'has_vote_access', '3': 4, '4': 1, '5': 8, '10': 'hasVoteAccess'},
    {
      '1': 'has_lottery_access',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'hasLotteryAccess'
    },
    {'1': 'has_folded_reply', '3': 6, '4': 1, '5': 8, '10': 'hasFoldedReply'},
    {'1': 'bg_text', '3': 7, '4': 1, '5': 9, '10': 'bgText'},
    {'1': 'up_blocked', '3': 8, '4': 1, '5': 8, '10': 'upBlocked'},
    {
      '1': 'has_activity_access',
      '3': 9,
      '4': 1,
      '5': 8,
      '10': 'hasActivityAccess'
    },
    {'1': 'show_title', '3': 10, '4': 1, '5': 8, '10': 'showTitle'},
    {'1': 'show_up_action', '3': 11, '4': 1, '5': 8, '10': 'showUpAction'},
    {'1': 'switcher_type', '3': 12, '4': 1, '5': 3, '10': 'switcherType'},
    {'1': 'input_disable', '3': 13, '4': 1, '5': 8, '10': 'inputDisable'},
    {'1': 'root_text', '3': 14, '4': 1, '5': 9, '10': 'rootText'},
    {'1': 'child_text', '3': 15, '4': 1, '5': 9, '10': 'childText'},
    {'1': 'count', '3': 16, '4': 1, '5': 3, '10': 'count'},
    {'1': 'title', '3': 17, '4': 1, '5': 9, '10': 'title'},
    {'1': 'giveup_text', '3': 18, '4': 1, '5': 9, '10': 'giveupText'},
    {'1': 'has_note_access', '3': 19, '4': 1, '5': 8, '10': 'hasNoteAccess'},
    {
      '1': 'disable_jump_emote',
      '3': 20,
      '4': 1,
      '5': 8,
      '10': 'disableJumpEmote'
    },
    {
      '1': 'empty_background_text_plain',
      '3': 21,
      '4': 1,
      '5': 9,
      '10': 'emptyBackgroundTextPlain'
    },
    {
      '1': 'empty_background_text_highlight',
      '3': 22,
      '4': 1,
      '5': 9,
      '10': 'emptyBackgroundTextHighlight'
    },
    {
      '1': 'empty_background_uri',
      '3': 23,
      '4': 1,
      '5': 9,
      '10': 'emptyBackgroundUri'
    },
    {
      '1': 'support_filter_tags',
      '3': 24,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.SubjectControl.FilterTag',
      '10': 'supportFilterTags'
    },
    {
      '1': 'screenshot_icon_state',
      '3': 25,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.EditorIconState',
      '10': 'screenshotIconState'
    },
    {
      '1': 'upload_picture_icon_state',
      '3': 26,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.EditorIconState',
      '10': 'uploadPictureIconState'
    },
    {
      '1': 'empty_page',
      '3': 27,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.EmptyPage',
      '10': 'emptyPage'
    },
    {
      '1': 'cm_top_reply_protection',
      '3': 28,
      '4': 1,
      '5': 11,
      '6':
          '.bilibili.main.community.reply.v1.SubjectControl.CmTopReplyProtection',
      '10': 'cmTopReplyProtection'
    },
    {'1': 'enable_charged', '3': 29, '4': 1, '5': 8, '10': 'enableCharged'},
  ],
  '3': [
    SubjectControl_CmTopReplyProtection$json,
    SubjectControl_FilterTag$json
  ],
};

@$core.Deprecated('Use subjectControlDescriptor instead')
const SubjectControl_CmTopReplyProtection$json = {
  '1': 'CmTopReplyProtection',
  '2': [
    {
      '1': 'protected_top_rpid',
      '3': 1,
      '4': 1,
      '5': 3,
      '10': 'protectedTopRpid'
    },
    {'1': 'popup_message', '3': 2, '4': 1, '5': 9, '10': 'popupMessage'},
    {'1': 'appeal_url', '3': 3, '4': 1, '5': 9, '10': 'appealUrl'},
  ],
};

@$core.Deprecated('Use subjectControlDescriptor instead')
const SubjectControl_FilterTag$json = {
  '1': 'FilterTag',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'event_id', '3': 2, '4': 1, '5': 9, '10': 'eventId'},
  ],
};

/// Descriptor for `SubjectControl`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subjectControlDescriptor = $convert.base64Decode(
    'Cg5TdWJqZWN0Q29udHJvbBIVCgZ1cF9taWQYASABKANSBXVwTWlkEhsKCWlzX2Fzc2lzdBgCIA'
    'EoCFIIaXNBc3Npc3QSGwoJcmVhZF9vbmx5GAMgASgIUghyZWFkT25seRImCg9oYXNfdm90ZV9h'
    'Y2Nlc3MYBCABKAhSDWhhc1ZvdGVBY2Nlc3MSLAoSaGFzX2xvdHRlcnlfYWNjZXNzGAUgASgIUh'
    'BoYXNMb3R0ZXJ5QWNjZXNzEigKEGhhc19mb2xkZWRfcmVwbHkYBiABKAhSDmhhc0ZvbGRlZFJl'
    'cGx5EhcKB2JnX3RleHQYByABKAlSBmJnVGV4dBIdCgp1cF9ibG9ja2VkGAggASgIUgl1cEJsb2'
    'NrZWQSLgoTaGFzX2FjdGl2aXR5X2FjY2VzcxgJIAEoCFIRaGFzQWN0aXZpdHlBY2Nlc3MSHQoK'
    'c2hvd190aXRsZRgKIAEoCFIJc2hvd1RpdGxlEiQKDnNob3dfdXBfYWN0aW9uGAsgASgIUgxzaG'
    '93VXBBY3Rpb24SIwoNc3dpdGNoZXJfdHlwZRgMIAEoA1IMc3dpdGNoZXJUeXBlEiMKDWlucHV0'
    'X2Rpc2FibGUYDSABKAhSDGlucHV0RGlzYWJsZRIbCglyb290X3RleHQYDiABKAlSCHJvb3RUZX'
    'h0Eh0KCmNoaWxkX3RleHQYDyABKAlSCWNoaWxkVGV4dBIUCgVjb3VudBgQIAEoA1IFY291bnQS'
    'FAoFdGl0bGUYESABKAlSBXRpdGxlEh8KC2dpdmV1cF90ZXh0GBIgASgJUgpnaXZldXBUZXh0Ei'
    'YKD2hhc19ub3RlX2FjY2VzcxgTIAEoCFINaGFzTm90ZUFjY2VzcxIsChJkaXNhYmxlX2p1bXBf'
    'ZW1vdGUYFCABKAhSEGRpc2FibGVKdW1wRW1vdGUSPQobZW1wdHlfYmFja2dyb3VuZF90ZXh0X3'
    'BsYWluGBUgASgJUhhlbXB0eUJhY2tncm91bmRUZXh0UGxhaW4SRQofZW1wdHlfYmFja2dyb3Vu'
    'ZF90ZXh0X2hpZ2hsaWdodBgWIAEoCVIcZW1wdHlCYWNrZ3JvdW5kVGV4dEhpZ2hsaWdodBIwCh'
    'RlbXB0eV9iYWNrZ3JvdW5kX3VyaRgXIAEoCVISZW1wdHlCYWNrZ3JvdW5kVXJpEmoKE3N1cHBv'
    'cnRfZmlsdGVyX3RhZ3MYGCADKAsyOi5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS'
    '5TdWJqZWN0Q29udHJvbC5GaWx0ZXJUYWdSEXN1cHBvcnRGaWx0ZXJUYWdzEmUKFXNjcmVlbnNo'
    'b3RfaWNvbl9zdGF0ZRgZIAEoDjIxLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLk'
    'VkaXRvckljb25TdGF0ZVITc2NyZWVuc2hvdEljb25TdGF0ZRJsChl1cGxvYWRfcGljdHVyZV9p'
    'Y29uX3N0YXRlGBogASgOMjEuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuRWRpdG'
    '9ySWNvblN0YXRlUhZ1cGxvYWRQaWN0dXJlSWNvblN0YXRlEkoKCmVtcHR5X3BhZ2UYGyABKAsy'
    'Ky5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5FbXB0eVBhZ2VSCWVtcHR5UGFnZR'
    'J8ChdjbV90b3BfcmVwbHlfcHJvdGVjdGlvbhgcIAEoCzJFLmJpbGliaWxpLm1haW4uY29tbXVu'
    'aXR5LnJlcGx5LnYxLlN1YmplY3RDb250cm9sLkNtVG9wUmVwbHlQcm90ZWN0aW9uUhRjbVRvcF'
    'JlcGx5UHJvdGVjdGlvbhIlCg5lbmFibGVfY2hhcmdlZBgdIAEoCFINZW5hYmxlQ2hhcmdlZBqI'
    'AQoUQ21Ub3BSZXBseVByb3RlY3Rpb24SLAoScHJvdGVjdGVkX3RvcF9ycGlkGAEgASgDUhBwcm'
    '90ZWN0ZWRUb3BScGlkEiMKDXBvcHVwX21lc3NhZ2UYAiABKAlSDHBvcHVwTWVzc2FnZRIdCgph'
    'cHBlYWxfdXJsGAMgASgJUglhcHBlYWxVcmwaOgoJRmlsdGVyVGFnEhIKBG5hbWUYASABKAlSBG'
    '5hbWUSGQoIZXZlbnRfaWQYAiABKAlSB2V2ZW50SWQ=');

@$core.Deprecated('Use subjectTopCardsDescriptor instead')
const SubjectTopCards$json = {
  '1': 'SubjectTopCards',
  '2': [
    {
      '1': 'ogv_grade',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.OgvGradeCard',
      '9': 0,
      '10': 'ogvGrade'
    },
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.SubjectTopCards.Type',
      '10': 'type'
    },
    {'1': 'oid', '3': 2, '4': 1, '5': 9, '10': 'oid'},
  ],
  '4': [SubjectTopCards_Type$json],
  '8': [
    {'1': 'item'},
  ],
};

@$core.Deprecated('Use subjectTopCardsDescriptor instead')
const SubjectTopCards_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'UNKNOWN_Type', '2': 0},
    {'1': 'OGV_GRADE', '2': 1},
  ],
};

/// Descriptor for `SubjectTopCards`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subjectTopCardsDescriptor = $convert.base64Decode(
    'Cg9TdWJqZWN0VG9wQ2FyZHMSTQoJb2d2X2dyYWRlGAMgASgLMi4uYmlsaWJpbGkubWFpbi5jb2'
    '1tdW5pdHkucmVwbHkudjEuT2d2R3JhZGVDYXJkSABSCG9ndkdyYWRlEkoKBHR5cGUYASABKA4y'
    'Ni5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5TdWJqZWN0VG9wQ2FyZHMuVHlwZV'
    'IEdHlwZRIQCgNvaWQYAiABKAlSA29pZCInCgRUeXBlEhAKDFVOS05PV05fVHlwZRAAEg0KCU9H'
    'Vl9HUkFERRABQgYKBGl0ZW0=');

@$core.Deprecated('Use suggestEmotesReqDescriptor instead')
const SuggestEmotesReq$json = {
  '1': 'SuggestEmotesReq',
  '2': [
    {'1': 'oid', '3': 1, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'type', '3': 2, '4': 1, '5': 3, '10': 'type'},
  ],
};

/// Descriptor for `SuggestEmotesReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List suggestEmotesReqDescriptor = $convert.base64Decode(
    'ChBTdWdnZXN0RW1vdGVzUmVxEhAKA29pZBgBIAEoA1IDb2lkEhIKBHR5cGUYAiABKANSBHR5cG'
    'U=');

@$core.Deprecated('Use suggestEmotesRespDescriptor instead')
const SuggestEmotesResp$json = {
  '1': 'SuggestEmotesResp',
  '2': [
    {
      '1': 'emotes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Emote',
      '10': 'emotes'
    },
  ],
};

/// Descriptor for `SuggestEmotesResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List suggestEmotesRespDescriptor = $convert.base64Decode(
    'ChFTdWdnZXN0RW1vdGVzUmVzcBI/CgZlbW90ZXMYASADKAsyJy5iaWxpYmlsaS5tYWluLmNvbW'
    '11bml0eS5yZXBseS52MS5FbW90ZVIGZW1vdGVz');

@$core.Deprecated('Use textStyleDescriptor instead')
const TextStyle$json = {
  '1': 'TextStyle',
  '2': [
    {'1': 'font_size', '3': 1, '4': 1, '5': 5, '10': 'fontSize'},
    {
      '1': 'font_style',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.TextStyle.FontStyle',
      '10': 'fontStyle'
    },
    {'1': 'text_day_color', '3': 3, '4': 1, '5': 9, '10': 'textDayColor'},
    {'1': 'text_night_color', '3': 4, '4': 1, '5': 9, '10': 'textNightColor'},
  ],
  '4': [TextStyle_FontStyle$json],
};

@$core.Deprecated('Use textStyleDescriptor instead')
const TextStyle_FontStyle$json = {
  '1': 'FontStyle',
  '2': [
    {'1': 'NORMAL', '2': 0},
    {'1': 'BOLD', '2': 1},
  ],
};

/// Descriptor for `TextStyle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textStyleDescriptor = $convert.base64Decode(
    'CglUZXh0U3R5bGUSGwoJZm9udF9zaXplGAEgASgFUghmb250U2l6ZRJUCgpmb250X3N0eWxlGA'
    'IgASgOMjUuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuVGV4dFN0eWxlLkZvbnRT'
    'dHlsZVIJZm9udFN0eWxlEiQKDnRleHRfZGF5X2NvbG9yGAMgASgJUgx0ZXh0RGF5Q29sb3ISKA'
    'oQdGV4dF9uaWdodF9jb2xvchgEIAEoCVIOdGV4dE5pZ2h0Q29sb3IiIQoJRm9udFN0eWxlEgoK'
    'Bk5PUk1BTBAAEggKBEJPTEQQAQ==');

@$core.Deprecated('Use topicDescriptor instead')
const Topic$json = {
  '1': 'Topic',
  '2': [
    {'1': 'link', '3': 1, '4': 1, '5': 9, '10': 'link'},
    {'1': 'id', '3': 2, '4': 1, '5': 3, '10': 'id'},
  ],
};

/// Descriptor for `Topic`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List topicDescriptor = $convert.base64Decode(
    'CgVUb3BpYxISCgRsaW5rGAEgASgJUgRsaW5rEg4KAmlkGAIgASgDUgJpZA==');

@$core.Deprecated('Use uGCVideoSearchItemDescriptor instead')
const UGCVideoSearchItem$json = {
  '1': 'UGCVideoSearchItem',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'up_nickname', '3': 2, '4': 1, '5': 9, '10': 'upNickname'},
    {'1': 'duration', '3': 3, '4': 1, '5': 3, '10': 'duration'},
    {'1': 'cover', '3': 4, '4': 1, '5': 9, '10': 'cover'},
  ],
};

/// Descriptor for `UGCVideoSearchItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uGCVideoSearchItemDescriptor = $convert.base64Decode(
    'ChJVR0NWaWRlb1NlYXJjaEl0ZW0SFAoFdGl0bGUYASABKAlSBXRpdGxlEh8KC3VwX25pY2tuYW'
    '1lGAIgASgJUgp1cE5pY2tuYW1lEhoKCGR1cmF0aW9uGAMgASgDUghkdXJhdGlvbhIUCgVjb3Zl'
    'chgEIAEoCVIFY292ZXI=');

@$core.Deprecated('Use upSelectionDescriptor instead')
const UpSelection$json = {
  '1': 'UpSelection',
  '2': [
    {'1': 'pending_count', '3': 1, '4': 1, '5': 3, '10': 'pendingCount'},
    {'1': 'ignore_count', '3': 2, '4': 1, '5': 3, '10': 'ignoreCount'},
  ],
};

/// Descriptor for `UpSelection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upSelectionDescriptor = $convert.base64Decode(
    'CgtVcFNlbGVjdGlvbhIjCg1wZW5kaW5nX2NvdW50GAEgASgDUgxwZW5kaW5nQ291bnQSIQoMaW'
    'dub3JlX2NvdW50GAIgASgDUgtpZ25vcmVDb3VudA==');

@$core
    .Deprecated('Use updateSingleReplyNotificationConfigReqDescriptor instead')
const UpdateSingleReplyNotificationConfigReq$json = {
  '1': 'UpdateSingleReplyNotificationConfigReq',
  '2': [
    {'1': 'rpid', '3': 1, '4': 1, '5': 3, '10': 'rpid'},
    {'1': 'type', '3': 2, '4': 1, '5': 3, '10': 'type'},
    {'1': 'oid', '3': 3, '4': 1, '5': 3, '10': 'oid'},
    {
      '1': 'push_switch',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.ReplyNotificationSwitch',
      '10': 'pushSwitch'
    },
  ],
};

/// Descriptor for `UpdateSingleReplyNotificationConfigReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSingleReplyNotificationConfigReqDescriptor =
    $convert.base64Decode(
        'CiZVcGRhdGVTaW5nbGVSZXBseU5vdGlmaWNhdGlvbkNvbmZpZ1JlcRISCgRycGlkGAEgASgDUg'
        'RycGlkEhIKBHR5cGUYAiABKANSBHR5cGUSEAoDb2lkGAMgASgDUgNvaWQSWgoLcHVzaF9zd2l0'
        'Y2gYBCABKA4yOS5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5SZXBseU5vdGlmaW'
        'NhdGlvblN3aXRjaFIKcHVzaFN3aXRjaA==');

@$core
    .Deprecated('Use updateSingleReplyNotificationConfigRespDescriptor instead')
const UpdateSingleReplyNotificationConfigResp$json = {
  '1': 'UpdateSingleReplyNotificationConfigResp',
};

/// Descriptor for `UpdateSingleReplyNotificationConfigResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSingleReplyNotificationConfigRespDescriptor =
    $convert.base64Decode(
        'CidVcGRhdGVTaW5nbGVSZXBseU5vdGlmaWNhdGlvbkNvbmZpZ1Jlc3A=');

@$core.Deprecated('Use urlDescriptor instead')
const Url$json = {
  '1': 'Url',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'state', '3': 2, '4': 1, '5': 3, '10': 'state'},
    {'1': 'prefix_icon', '3': 3, '4': 1, '5': 9, '10': 'prefixIcon'},
    {'1': 'app_url_schema', '3': 4, '4': 1, '5': 9, '10': 'appUrlSchema'},
    {'1': 'app_name', '3': 5, '4': 1, '5': 9, '10': 'appName'},
    {'1': 'app_package_name', '3': 6, '4': 1, '5': 9, '10': 'appPackageName'},
    {'1': 'click_report', '3': 7, '4': 1, '5': 9, '10': 'clickReport'},
    {'1': 'is_half_screen', '3': 8, '4': 1, '5': 8, '10': 'isHalfScreen'},
    {'1': 'exposure_report', '3': 9, '4': 1, '5': 9, '10': 'exposureReport'},
    {
      '1': 'extra',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Url.Extra',
      '10': 'extra'
    },
    {'1': 'underline', '3': 11, '4': 1, '5': 8, '10': 'underline'},
    {'1': 'match_once', '3': 12, '4': 1, '5': 8, '10': 'matchOnce'},
    {'1': 'pc_url', '3': 13, '4': 1, '5': 9, '10': 'pcUrl'},
    {
      '1': 'icon_position',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.Url.IconPosition',
      '10': 'iconPosition'
    },
  ],
  '3': [Url_Extra$json],
  '4': [Url_IconPosition$json],
};

@$core.Deprecated('Use urlDescriptor instead')
const Url_Extra$json = {
  '1': 'Extra',
  '2': [
    {'1': 'goods_item_id', '3': 1, '4': 1, '5': 3, '10': 'goodsItemId'},
    {
      '1': 'goods_prefetched_cache',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'goodsPrefetchedCache'
    },
    {
      '1': 'goods_show_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.Url.Extra.GoodsShowType',
      '10': 'goodsShowType'
    },
    {'1': 'is_word_search', '3': 4, '4': 1, '5': 8, '10': 'isWordSearch'},
    {'1': 'goods_cm_control', '3': 5, '4': 1, '5': 3, '10': 'goodsCmControl'},
    {
      '1': 'goods_click_report',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'goodsClickReport'
    },
    {
      '1': 'goods_exposure_report',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'goodsExposureReport'
    },
    {
      '1': 'goods_show_pop_window',
      '3': 8,
      '4': 1,
      '5': 3,
      '10': 'goodsShowPopWindow'
    },
  ],
  '4': [Url_Extra_GoodsShowType$json],
};

@$core.Deprecated('Use urlDescriptor instead')
const Url_Extra_GoodsShowType$json = {
  '1': 'GoodsShowType',
  '2': [
    {'1': 'Popup', '2': 0},
    {'1': 'FullScreen', '2': 1},
    {'1': 'HalfScreen', '2': 2},
  ],
};

@$core.Deprecated('Use urlDescriptor instead')
const Url_IconPosition$json = {
  '1': 'IconPosition',
  '2': [
    {'1': 'Prefix', '2': 0},
    {'1': 'Suffix', '2': 1},
  ],
};

/// Descriptor for `Url`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List urlDescriptor = $convert.base64Decode(
    'CgNVcmwSFAoFdGl0bGUYASABKAlSBXRpdGxlEhQKBXN0YXRlGAIgASgDUgVzdGF0ZRIfCgtwcm'
    'VmaXhfaWNvbhgDIAEoCVIKcHJlZml4SWNvbhIkCg5hcHBfdXJsX3NjaGVtYRgEIAEoCVIMYXBw'
    'VXJsU2NoZW1hEhkKCGFwcF9uYW1lGAUgASgJUgdhcHBOYW1lEigKEGFwcF9wYWNrYWdlX25hbW'
    'UYBiABKAlSDmFwcFBhY2thZ2VOYW1lEiEKDGNsaWNrX3JlcG9ydBgHIAEoCVILY2xpY2tSZXBv'
    'cnQSJAoOaXNfaGFsZl9zY3JlZW4YCCABKAhSDGlzSGFsZlNjcmVlbhInCg9leHBvc3VyZV9yZX'
    'BvcnQYCSABKAlSDmV4cG9zdXJlUmVwb3J0EkEKBWV4dHJhGAogASgLMisuYmlsaWJpbGkubWFp'
    'bi5jb21tdW5pdHkucmVwbHkudjEuVXJsLkV4dHJhUgVleHRyYRIcCgl1bmRlcmxpbmUYCyABKA'
    'hSCXVuZGVybGluZRIdCgptYXRjaF9vbmNlGAwgASgIUgltYXRjaE9uY2USFQoGcGNfdXJsGA0g'
    'ASgJUgVwY1VybBJXCg1pY29uX3Bvc2l0aW9uGA4gASgOMjIuYmlsaWJpbGkubWFpbi5jb21tdW'
    '5pdHkucmVwbHkudjEuVXJsLkljb25Qb3NpdGlvblIMaWNvblBvc2l0aW9uGuUDCgVFeHRyYRIi'
    'Cg1nb29kc19pdGVtX2lkGAEgASgDUgtnb29kc0l0ZW1JZBI0ChZnb29kc19wcmVmZXRjaGVkX2'
    'NhY2hlGAIgASgJUhRnb29kc1ByZWZldGNoZWRDYWNoZRJhCg9nb29kc19zaG93X3R5cGUYAyAB'
    'KA4yOS5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5VcmwuRXh0cmEuR29vZHNTaG'
    '93VHlwZVINZ29vZHNTaG93VHlwZRIkCg5pc193b3JkX3NlYXJjaBgEIAEoCFIMaXNXb3JkU2Vh'
    'cmNoEigKEGdvb2RzX2NtX2NvbnRyb2wYBSABKANSDmdvb2RzQ21Db250cm9sEiwKEmdvb2RzX2'
    'NsaWNrX3JlcG9ydBgGIAEoCVIQZ29vZHNDbGlja1JlcG9ydBIyChVnb29kc19leHBvc3VyZV9y'
    'ZXBvcnQYByABKAlSE2dvb2RzRXhwb3N1cmVSZXBvcnQSMQoVZ29vZHNfc2hvd19wb3Bfd2luZG'
    '93GAggASgDUhJnb29kc1Nob3dQb3BXaW5kb3ciOgoNR29vZHNTaG93VHlwZRIJCgVQb3B1cBAA'
    'Eg4KCkZ1bGxTY3JlZW4QARIOCgpIYWxmU2NyZWVuEAIiJgoMSWNvblBvc2l0aW9uEgoKBlByZW'
    'ZpeBAAEgoKBlN1ZmZpeBAB');

@$core.Deprecated('Use userCallbackReplyDescriptor instead')
const UserCallbackReply$json = {
  '1': 'UserCallbackReply',
};

/// Descriptor for `UserCallbackReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userCallbackReplyDescriptor =
    $convert.base64Decode('ChFVc2VyQ2FsbGJhY2tSZXBseQ==');

@$core.Deprecated('Use userCallbackReqDescriptor instead')
const UserCallbackReq$json = {
  '1': 'UserCallbackReq',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 3, '10': 'mid'},
    {
      '1': 'scene',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.UserCallbackScene',
      '10': 'scene'
    },
    {
      '1': 'action',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.UserCallbackAction',
      '10': 'action'
    },
    {'1': 'oid', '3': 4, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'type', '3': 5, '4': 1, '5': 3, '10': 'type'},
    {'1': 'rpids', '3': 6, '4': 3, '5': 3, '10': 'rpids'},
  ],
};

/// Descriptor for `UserCallbackReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userCallbackReqDescriptor = $convert.base64Decode(
    'Cg9Vc2VyQ2FsbGJhY2tSZXESEAoDbWlkGAEgASgDUgNtaWQSSQoFc2NlbmUYAiABKA4yMy5iaW'
    'xpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5Vc2VyQ2FsbGJhY2tTY2VuZVIFc2NlbmUS'
    'TAoGYWN0aW9uGAMgASgOMjQuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuVXNlck'
    'NhbGxiYWNrQWN0aW9uUgZhY3Rpb24SEAoDb2lkGAQgASgDUgNvaWQSEgoEdHlwZRgFIAEoA1IE'
    'dHlwZRIUCgVycGlkcxgGIAMoA1IFcnBpZHM=');

@$core.Deprecated('Use videoSearchItemDescriptor instead')
const VideoSearchItem$json = {
  '1': 'VideoSearchItem',
  '2': [
    {
      '1': 'ugc',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.UGCVideoSearchItem',
      '9': 0,
      '10': 'ugc'
    },
    {
      '1': 'pgc',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.PGCVideoSearchItem',
      '9': 0,
      '10': 'pgc'
    },
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.main.community.reply.v1.SearchItemVideoSubType',
      '10': 'type'
    },
  ],
  '8': [
    {'1': 'video_item'},
  ],
};

/// Descriptor for `VideoSearchItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoSearchItemDescriptor = $convert.base64Decode(
    'Cg9WaWRlb1NlYXJjaEl0ZW0SSAoDdWdjGAIgASgLMjQuYmlsaWJpbGkubWFpbi5jb21tdW5pdH'
    'kucmVwbHkudjEuVUdDVmlkZW9TZWFyY2hJdGVtSABSA3VnYxJICgNwZ2MYAyABKAsyNC5iaWxp'
    'YmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5QR0NWaWRlb1NlYXJjaEl0ZW1IAFIDcGdjEk'
    'wKBHR5cGUYASABKA4yOC5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5TZWFyY2hJ'
    'dGVtVmlkZW9TdWJUeXBlUgR0eXBlQgwKCnZpZGVvX2l0ZW0=');

@$core.Deprecated('Use voteDescriptor instead')
const Vote$json = {
  '1': 'Vote',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'count', '3': 3, '4': 1, '5': 3, '10': 'count'},
  ],
};

/// Descriptor for `Vote`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voteDescriptor = $convert.base64Decode(
    'CgRWb3RlEg4KAmlkGAEgASgDUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSFAoFY291bnQYAy'
    'ABKANSBWNvdW50');

@$core.Deprecated('Use voteCardDescriptor instead')
const VoteCard$json = {
  '1': 'VoteCard',
  '2': [
    {'1': 'vote_id', '3': 1, '4': 1, '5': 3, '10': 'voteId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'count', '3': 3, '4': 1, '5': 3, '10': 'count'},
    {
      '1': 'options',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.VoteCard.Option',
      '10': 'options'
    },
    {'1': 'my_vote_option', '3': 5, '4': 1, '5': 3, '10': 'myVoteOption'},
  ],
  '3': [VoteCard_Option$json],
};

@$core.Deprecated('Use voteCardDescriptor instead')
const VoteCard_Option$json = {
  '1': 'Option',
  '2': [
    {'1': 'idx', '3': 1, '4': 1, '5': 3, '10': 'idx'},
    {'1': 'desc', '3': 2, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'count', '3': 3, '4': 1, '5': 3, '10': 'count'},
  ],
};

/// Descriptor for `VoteCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voteCardDescriptor = $convert.base64Decode(
    'CghWb3RlQ2FyZBIXCgd2b3RlX2lkGAEgASgDUgZ2b3RlSWQSFAoFdGl0bGUYAiABKAlSBXRpdG'
    'xlEhQKBWNvdW50GAMgASgDUgVjb3VudBJLCgdvcHRpb25zGAQgAygLMjEuYmlsaWJpbGkubWFp'
    'bi5jb21tdW5pdHkucmVwbHkudjEuVm90ZUNhcmQuT3B0aW9uUgdvcHRpb25zEiQKDm15X3ZvdG'
    'Vfb3B0aW9uGAUgASgDUgxteVZvdGVPcHRpb24aRAoGT3B0aW9uEhAKA2lkeBgBIAEoA1IDaWR4'
    'EhIKBGRlc2MYAiABKAlSBGRlc2MSFAoFY291bnQYAyABKANSBWNvdW50');

@$core.Deprecated('Use wordSearchParamDescriptor instead')
const WordSearchParam$json = {
  '1': 'WordSearchParam',
  '2': [
    {'1': 'shown_count', '3': 1, '4': 1, '5': 3, '10': 'shownCount'},
  ],
};

/// Descriptor for `WordSearchParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wordSearchParamDescriptor = $convert.base64Decode(
    'Cg9Xb3JkU2VhcmNoUGFyYW0SHwoLc2hvd25fY291bnQYASABKANSCnNob3duQ291bnQ=');

@$core.Deprecated('Use translateReplyReqDescriptor instead')
const TranslateReplyReq$json = {
  '1': 'TranslateReplyReq',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 3, '10': 'type'},
    {'1': 'oid', '3': 2, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'rpids', '3': 3, '4': 3, '5': 3, '10': 'rpids'},
  ],
};

/// Descriptor for `TranslateReplyReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List translateReplyReqDescriptor = $convert.base64Decode(
    'ChFUcmFuc2xhdGVSZXBseVJlcRISCgR0eXBlGAEgASgDUgR0eXBlEhAKA29pZBgCIAEoA1IDb2'
    'lkEhQKBXJwaWRzGAMgAygDUgVycGlkcw==');

@$core.Deprecated('Use translateReplyRespDescriptor instead')
const TranslateReplyResp$json = {
  '1': 'TranslateReplyResp',
  '2': [
    {
      '1': 'translated_replies',
      '3': 1,
      '4': 3,
      '5': 11,
      '6':
          '.bilibili.main.community.reply.v1.TranslateReplyResp.TranslatedRepliesEntry',
      '10': 'translatedReplies'
    },
  ],
  '3': [TranslateReplyResp_TranslatedRepliesEntry$json],
};

@$core.Deprecated('Use translateReplyRespDescriptor instead')
const TranslateReplyResp_TranslatedRepliesEntry$json = {
  '1': 'TranslatedRepliesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 3, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInfo',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `TranslateReplyResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List translateReplyRespDescriptor = $convert.base64Decode(
    'ChJUcmFuc2xhdGVSZXBseVJlc3ASegoSdHJhbnNsYXRlZF9yZXBsaWVzGAEgAygLMksuYmlsaW'
    'JpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuVHJhbnNsYXRlUmVwbHlSZXNwLlRyYW5zbGF0'
    'ZWRSZXBsaWVzRW50cnlSEXRyYW5zbGF0ZWRSZXBsaWVzGnEKFlRyYW5zbGF0ZWRSZXBsaWVzRW'
    '50cnkSEAoDa2V5GAEgASgDUgNrZXkSQQoFdmFsdWUYAiABKAsyKy5iaWxpYmlsaS5tYWluLmNv'
    'bW11bml0eS5yZXBseS52MS5SZXBseUluZm9SBXZhbHVlOgI4AQ==');
