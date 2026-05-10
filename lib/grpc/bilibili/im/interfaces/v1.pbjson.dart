// This is a generated file - do not edit.
//
// Generated from bilibili/im/interfaces/v1.proto.

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

@$core.Deprecated('Use emotionInfoDescriptor instead')
const EmotionInfo$json = {
  '1': 'EmotionInfo',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
    {'1': 'size', '3': 3, '4': 1, '5': 5, '10': 'size'},
    {'1': 'gif_url', '3': 4, '4': 1, '5': 9, '10': 'gifUrl'},
  ],
};

/// Descriptor for `EmotionInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emotionInfoDescriptor = $convert.base64Decode(
    'CgtFbW90aW9uSW5mbxISCgR0ZXh0GAEgASgJUgR0ZXh0EhAKA3VybBgCIAEoCVIDdXJsEhIKBH'
    'NpemUYAyABKAVSBHNpemUSFwoHZ2lmX3VybBgEIAEoCVIGZ2lmVXJs');

@$core.Deprecated('Use msgFeedUnreadRspDescriptor instead')
const MsgFeedUnreadRsp$json = {
  '1': 'MsgFeedUnreadRsp',
  '2': [
    {
      '1': 'unread',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.im.interfaces.v1.MsgFeedUnreadRsp.UnreadEntry',
      '10': 'unread'
    },
  ],
  '3': [MsgFeedUnreadRsp_UnreadEntry$json],
};

@$core.Deprecated('Use msgFeedUnreadRspDescriptor instead')
const MsgFeedUnreadRsp_UnreadEntry$json = {
  '1': 'UnreadEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 3, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `MsgFeedUnreadRsp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgFeedUnreadRspDescriptor = $convert.base64Decode(
    'ChBNc2dGZWVkVW5yZWFkUnNwEk8KBnVucmVhZBgBIAMoCzI3LmJpbGliaWxpLmltLmludGVyZm'
    'FjZXMudjEuTXNnRmVlZFVucmVhZFJzcC5VbnJlYWRFbnRyeVIGdW5yZWFkGjkKC1VucmVhZEVu'
    'dHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgDUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use reqSendMsgDescriptor instead')
const ReqSendMsg$json = {
  '1': 'ReqSendMsg',
  '2': [
    {
      '1': 'msg',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.im.type.Msg',
      '10': 'msg'
    },
    {'1': 'cookie', '3': 2, '4': 1, '5': 9, '10': 'cookie'},
    {'1': 'cookie2', '3': 3, '4': 1, '5': 9, '10': 'cookie2'},
    {'1': 'error_code', '3': 4, '4': 1, '5': 5, '10': 'errorCode'},
    {'1': 'dev_id', '3': 5, '4': 1, '5': 9, '10': 'devId'},
  ],
};

/// Descriptor for `ReqSendMsg`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reqSendMsgDescriptor = $convert.base64Decode(
    'CgpSZXFTZW5kTXNnEicKA21zZxgBIAEoCzIVLmJpbGliaWxpLmltLnR5cGUuTXNnUgNtc2cSFg'
    'oGY29va2llGAIgASgJUgZjb29raWUSGAoHY29va2llMhgDIAEoCVIHY29va2llMhIdCgplcnJv'
    'cl9jb2RlGAQgASgFUgllcnJvckNvZGUSFQoGZGV2X2lkGAUgASgJUgVkZXZJZA==');

@$core.Deprecated('Use reqSessionMsgDescriptor instead')
const ReqSessionMsg$json = {
  '1': 'ReqSessionMsg',
  '2': [
    {'1': 'talker_id', '3': 1, '4': 1, '5': 3, '10': 'talkerId'},
    {'1': 'session_type', '3': 2, '4': 1, '5': 5, '10': 'sessionType'},
    {'1': 'end_seqno', '3': 3, '4': 1, '5': 3, '10': 'endSeqno'},
    {'1': 'begin_seqno', '3': 4, '4': 1, '5': 3, '10': 'beginSeqno'},
    {'1': 'size', '3': 5, '4': 1, '5': 5, '10': 'size'},
    {'1': 'order', '3': 6, '4': 1, '5': 5, '10': 'order'},
    {'1': 'dev_id', '3': 7, '4': 1, '5': 9, '10': 'devId'},
    {'1': 'canal_token', '3': 8, '4': 1, '5': 9, '10': 'canalToken'},
  ],
};

/// Descriptor for `ReqSessionMsg`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reqSessionMsgDescriptor = $convert.base64Decode(
    'Cg1SZXFTZXNzaW9uTXNnEhsKCXRhbGtlcl9pZBgBIAEoA1IIdGFsa2VySWQSIQoMc2Vzc2lvbl'
    '90eXBlGAIgASgFUgtzZXNzaW9uVHlwZRIbCgllbmRfc2Vxbm8YAyABKANSCGVuZFNlcW5vEh8K'
    'C2JlZ2luX3NlcW5vGAQgASgDUgpiZWdpblNlcW5vEhIKBHNpemUYBSABKAVSBHNpemUSFAoFb3'
    'JkZXIYBiABKAVSBW9yZGVyEhUKBmRldl9pZBgHIAEoCVIFZGV2SWQSHwoLY2FuYWxfdG9rZW4Y'
    'CCABKAlSCmNhbmFsVG9rZW4=');

@$core.Deprecated('Use reqShareListDescriptor instead')
const ReqShareList$json = {
  '1': 'ReqShareList',
  '2': [
    {'1': 'size', '3': 1, '4': 1, '5': 5, '10': 'size'},
    {'1': 'source', '3': 2, '4': 1, '5': 5, '10': 'source'},
  ],
};

/// Descriptor for `ReqShareList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reqShareListDescriptor = $convert.base64Decode(
    'CgxSZXFTaGFyZUxpc3QSEgoEc2l6ZRgBIAEoBVIEc2l6ZRIWCgZzb3VyY2UYAiABKAVSBnNvdX'
    'JjZQ==');

@$core.Deprecated('Use reqTotalUnreadDescriptor instead')
const ReqTotalUnread$json = {
  '1': 'ReqTotalUnread',
  '2': [
    {'1': 'unread_type', '3': 1, '4': 1, '5': 5, '10': 'unreadType'},
    {
      '1': 'show_unfollow_list',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'showUnfollowList'
    },
    {'1': 'uid', '3': 3, '4': 1, '5': 3, '10': 'uid'},
    {'1': 'show_dustbin', '3': 4, '4': 1, '5': 5, '10': 'showDustbin'},
    {'1': 'singleunread_on', '3': 5, '4': 1, '5': 5, '10': 'singleunreadOn'},
    {'1': 'msgfeed_on', '3': 6, '4': 1, '5': 5, '10': 'msgfeedOn'},
    {'1': 'sysup_on', '3': 7, '4': 1, '5': 5, '10': 'sysupOn'},
  ],
};

/// Descriptor for `ReqTotalUnread`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reqTotalUnreadDescriptor = $convert.base64Decode(
    'Cg5SZXFUb3RhbFVucmVhZBIfCgt1bnJlYWRfdHlwZRgBIAEoBVIKdW5yZWFkVHlwZRIsChJzaG'
    '93X3VuZm9sbG93X2xpc3QYAiABKAVSEHNob3dVbmZvbGxvd0xpc3QSEAoDdWlkGAMgASgDUgN1'
    'aWQSIQoMc2hvd19kdXN0YmluGAQgASgFUgtzaG93RHVzdGJpbhInCg9zaW5nbGV1bnJlYWRfb2'
    '4YBSABKAVSDnNpbmdsZXVucmVhZE9uEh0KCm1zZ2ZlZWRfb24YBiABKAVSCW1zZ2ZlZWRPbhIZ'
    'CghzeXN1cF9vbhgHIAEoBVIHc3lzdXBPbg==');

@$core.Deprecated('Use rspSendMsgDescriptor instead')
const RspSendMsg$json = {
  '1': 'RspSendMsg',
  '2': [
    {'1': 'msg_key', '3': 1, '4': 1, '5': 3, '10': 'msgKey'},
    {
      '1': 'e_infos',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.im.interfaces.v1.EmotionInfo',
      '10': 'eInfos'
    },
    {'1': 'msg_content', '3': 3, '4': 1, '5': 9, '10': 'msgContent'},
    {'1': 'seqno', '3': 6, '4': 1, '5': 3, '10': 'seqno'},
  ],
};

/// Descriptor for `RspSendMsg`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rspSendMsgDescriptor = $convert.base64Decode(
    'CgpSc3BTZW5kTXNnEhcKB21zZ19rZXkYASABKANSBm1zZ0tleRI/CgdlX2luZm9zGAIgAygLMi'
    'YuYmlsaWJpbGkuaW0uaW50ZXJmYWNlcy52MS5FbW90aW9uSW5mb1IGZUluZm9zEh8KC21zZ19j'
    'b250ZW50GAMgASgJUgptc2dDb250ZW50EhQKBXNlcW5vGAYgASgDUgVzZXFubw==');

@$core.Deprecated('Use rspSessionMsgDescriptor instead')
const RspSessionMsg$json = {
  '1': 'RspSessionMsg',
  '2': [
    {
      '1': 'messages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.im.type.Msg',
      '10': 'messages'
    },
    {'1': 'has_more', '3': 2, '4': 1, '5': 5, '10': 'hasMore'},
    {'1': 'min_seqno', '3': 3, '4': 1, '5': 3, '10': 'minSeqno'},
    {'1': 'max_seqno', '3': 4, '4': 1, '5': 3, '10': 'maxSeqno'},
    {
      '1': 'e_infos',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.bilibili.im.interfaces.v1.EmotionInfo',
      '10': 'eInfos'
    },
  ],
};

/// Descriptor for `RspSessionMsg`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rspSessionMsgDescriptor = $convert.base64Decode(
    'Cg1Sc3BTZXNzaW9uTXNnEjEKCG1lc3NhZ2VzGAEgAygLMhUuYmlsaWJpbGkuaW0udHlwZS5Nc2'
    'dSCG1lc3NhZ2VzEhkKCGhhc19tb3JlGAIgASgFUgdoYXNNb3JlEhsKCW1pbl9zZXFubxgDIAEo'
    'A1IIbWluU2Vxbm8SGwoJbWF4X3NlcW5vGAQgASgDUghtYXhTZXFubxI/CgdlX2luZm9zGAUgAy'
    'gLMiYuYmlsaWJpbGkuaW0uaW50ZXJmYWNlcy52MS5FbW90aW9uSW5mb1IGZUluZm9z');

@$core.Deprecated('Use rspShareListDescriptor instead')
const RspShareList$json = {
  '1': 'RspShareList',
  '2': [
    {
      '1': 'session_list',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.im.interfaces.v1.ShareSessionInfo',
      '10': 'sessionList'
    },
  ],
};

/// Descriptor for `RspShareList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rspShareListDescriptor = $convert.base64Decode(
    'CgxSc3BTaGFyZUxpc3QSTgoMc2Vzc2lvbl9saXN0GAEgAygLMisuYmlsaWJpbGkuaW0uaW50ZX'
    'JmYWNlcy52MS5TaGFyZVNlc3Npb25JbmZvUgtzZXNzaW9uTGlzdA==');

@$core.Deprecated('Use rspTotalUnreadDescriptor instead')
const RspTotalUnread$json = {
  '1': 'RspTotalUnread',
  '2': [
    {
      '1': 'session_single_unread',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.im.interfaces.v1.SessionSingleUnreadRsp',
      '10': 'sessionSingleUnread'
    },
    {
      '1': 'msg_feed_unread',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.im.interfaces.v1.MsgFeedUnreadRsp',
      '10': 'msgFeedUnread'
    },
    {
      '1': 'sys_msg_interface_last_msg',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.im.interfaces.v1.SysMsgInterfaceLastMsgRsp',
      '10': 'sysMsgInterfaceLastMsg'
    },
    {'1': 'total_unread', '3': 4, '4': 1, '5': 5, '10': 'totalUnread'},
    {'1': 'custom_unread', '3': 5, '4': 1, '5': 3, '10': 'customUnread'},
    {
      '1': 'new_total_unread',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.im.interfaces.v1.NewTotalUnread',
      '10': 'newTotalUnread'
    },
  ],
};

/// Descriptor for `RspTotalUnread`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rspTotalUnreadDescriptor = $convert.base64Decode(
    'Cg5Sc3BUb3RhbFVucmVhZBJlChVzZXNzaW9uX3NpbmdsZV91bnJlYWQYASABKAsyMS5iaWxpYm'
    'lsaS5pbS5pbnRlcmZhY2VzLnYxLlNlc3Npb25TaW5nbGVVbnJlYWRSc3BSE3Nlc3Npb25TaW5n'
    'bGVVbnJlYWQSUwoPbXNnX2ZlZWRfdW5yZWFkGAIgASgLMisuYmlsaWJpbGkuaW0uaW50ZXJmYW'
    'Nlcy52MS5Nc2dGZWVkVW5yZWFkUnNwUg1tc2dGZWVkVW5yZWFkEnAKGnN5c19tc2dfaW50ZXJm'
    'YWNlX2xhc3RfbXNnGAMgASgLMjQuYmlsaWJpbGkuaW0uaW50ZXJmYWNlcy52MS5TeXNNc2dJbn'
    'RlcmZhY2VMYXN0TXNnUnNwUhZzeXNNc2dJbnRlcmZhY2VMYXN0TXNnEiEKDHRvdGFsX3VucmVh'
    'ZBgEIAEoBVILdG90YWxVbnJlYWQSIwoNY3VzdG9tX3VucmVhZBgFIAEoA1IMY3VzdG9tVW5yZW'
    'FkElMKEG5ld190b3RhbF91bnJlYWQYBiABKAsyKS5iaWxpYmlsaS5pbS5pbnRlcmZhY2VzLnYx'
    'Lk5ld1RvdGFsVW5yZWFkUg5uZXdUb3RhbFVucmVhZA==');

@$core.Deprecated('Use newTotalUnreadDescriptor instead')
const NewTotalUnread$json = {
  '1': 'NewTotalUnread',
  '2': [
    {'1': 'unread_count', '3': 1, '4': 1, '5': 5, '10': 'unreadCount'},
    {'1': 'unread_type', '3': 2, '4': 1, '5': 5, '10': 'unreadType'},
  ],
};

/// Descriptor for `NewTotalUnread`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List newTotalUnreadDescriptor = $convert.base64Decode(
    'Cg5OZXdUb3RhbFVucmVhZBIhCgx1bnJlYWRfY291bnQYASABKAVSC3VucmVhZENvdW50Eh8KC3'
    'VucmVhZF90eXBlGAIgASgFUgp1bnJlYWRUeXBl');

@$core.Deprecated('Use sessionSingleUnreadRspDescriptor instead')
const SessionSingleUnreadRsp$json = {
  '1': 'SessionSingleUnreadRsp',
  '2': [
    {'1': 'unfollow_unread', '3': 1, '4': 1, '5': 3, '10': 'unfollowUnread'},
    {'1': 'follow_unread', '3': 2, '4': 1, '5': 3, '10': 'followUnread'},
    {'1': 'unfollow_push_msg', '3': 3, '4': 1, '5': 5, '10': 'unfollowPushMsg'},
    {'1': 'dustbin_push_msg', '3': 4, '4': 1, '5': 5, '10': 'dustbinPushMsg'},
    {'1': 'dustbin_unread', '3': 5, '4': 1, '5': 3, '10': 'dustbinUnread'},
    {
      '1': 'biz_msg_unfollow_unread',
      '3': 6,
      '4': 1,
      '5': 3,
      '10': 'bizMsgUnfollowUnread'
    },
    {
      '1': 'biz_msg_follow_unread',
      '3': 7,
      '4': 1,
      '5': 3,
      '10': 'bizMsgFollowUnread'
    },
    {'1': 'huahuo_unread', '3': 8, '4': 1, '5': 3, '10': 'huahuoUnread'},
    {'1': 'custom_unread', '3': 9, '4': 1, '5': 3, '10': 'customUnread'},
  ],
};

/// Descriptor for `SessionSingleUnreadRsp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionSingleUnreadRspDescriptor = $convert.base64Decode(
    'ChZTZXNzaW9uU2luZ2xlVW5yZWFkUnNwEicKD3VuZm9sbG93X3VucmVhZBgBIAEoA1IOdW5mb2'
    'xsb3dVbnJlYWQSIwoNZm9sbG93X3VucmVhZBgCIAEoA1IMZm9sbG93VW5yZWFkEioKEXVuZm9s'
    'bG93X3B1c2hfbXNnGAMgASgFUg91bmZvbGxvd1B1c2hNc2cSKAoQZHVzdGJpbl9wdXNoX21zZx'
    'gEIAEoBVIOZHVzdGJpblB1c2hNc2cSJQoOZHVzdGJpbl91bnJlYWQYBSABKANSDWR1c3RiaW5V'
    'bnJlYWQSNQoXYml6X21zZ191bmZvbGxvd191bnJlYWQYBiABKANSFGJpek1zZ1VuZm9sbG93VW'
    '5yZWFkEjEKFWJpel9tc2dfZm9sbG93X3VucmVhZBgHIAEoA1ISYml6TXNnRm9sbG93VW5yZWFk'
    'EiMKDWh1YWh1b191bnJlYWQYCCABKANSDGh1YWh1b1VucmVhZBIjCg1jdXN0b21fdW5yZWFkGA'
    'kgASgDUgxjdXN0b21VbnJlYWQ=');

@$core.Deprecated('Use shareSessionInfoDescriptor instead')
const ShareSessionInfo$json = {
  '1': 'ShareSessionInfo',
  '2': [
    {'1': 'talker_id', '3': 1, '4': 1, '5': 3, '10': 'talkerId'},
    {'1': 'talker_uname', '3': 2, '4': 1, '5': 9, '10': 'talkerUname'},
    {'1': 'talker_icon', '3': 3, '4': 1, '5': 9, '10': 'talkerIcon'},
    {'1': 'official_type', '3': 4, '4': 1, '5': 5, '10': 'officialType'},
  ],
};

/// Descriptor for `ShareSessionInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shareSessionInfoDescriptor = $convert.base64Decode(
    'ChBTaGFyZVNlc3Npb25JbmZvEhsKCXRhbGtlcl9pZBgBIAEoA1IIdGFsa2VySWQSIQoMdGFsa2'
    'VyX3VuYW1lGAIgASgJUgt0YWxrZXJVbmFtZRIfCgt0YWxrZXJfaWNvbhgDIAEoCVIKdGFsa2Vy'
    'SWNvbhIjCg1vZmZpY2lhbF90eXBlGAQgASgFUgxvZmZpY2lhbFR5cGU=');

@$core.Deprecated('Use sysMsgInterfaceLastMsgRspDescriptor instead')
const SysMsgInterfaceLastMsgRsp$json = {
  '1': 'SysMsgInterfaceLastMsgRsp',
  '2': [
    {'1': 'unread', '3': 1, '4': 1, '5': 5, '10': 'unread'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'time', '3': 3, '4': 1, '5': 9, '10': 'time'},
    {'1': 'id', '3': 4, '4': 1, '5': 3, '10': 'id'},
  ],
};

/// Descriptor for `SysMsgInterfaceLastMsgRsp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sysMsgInterfaceLastMsgRspDescriptor = $convert.base64Decode(
    'ChlTeXNNc2dJbnRlcmZhY2VMYXN0TXNnUnNwEhYKBnVucmVhZBgBIAEoBVIGdW5yZWFkEhQKBX'
    'RpdGxlGAIgASgJUgV0aXRsZRISCgR0aW1lGAMgASgJUgR0aW1lEg4KAmlkGAQgASgDUgJpZA==');
