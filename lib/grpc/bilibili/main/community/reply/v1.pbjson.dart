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

@$core.Deprecated('Use contentDescriptor instead')
const Content$json = {
  '1': 'Content',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
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
  ],
  '3': [
    Content_EmotesEntry$json,
    Content_TopicsEntry$json,
    Content_UrlsEntry$json,
    Content_AtNameToMidEntry$json
  ],
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
    'CgdDb250ZW50EhgKB21lc3NhZ2UYASABKAlSB21lc3NhZ2USTQoGZW1vdGVzGAMgAygLMjUuYm'
    'lsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuQ29udGVudC5FbW90ZXNFbnRyeVIGZW1v'
    'dGVzEk0KBnRvcGljcxgEIAMoCzI1LmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLk'
    'NvbnRlbnQuVG9waWNzRW50cnlSBnRvcGljcxJHCgR1cmxzGAUgAygLMjMuYmlsaWJpbGkubWFp'
    'bi5jb21tdW5pdHkucmVwbHkudjEuQ29udGVudC5VcmxzRW50cnlSBHVybHMSOgoEdm90ZRgGIA'
    'EoCzImLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLlZvdGVSBHZvdGUSXwoOYXRf'
    'bmFtZV90b19taWQYByADKAsyOi5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5Db2'
    '50ZW50LkF0TmFtZVRvTWlkRW50cnlSC2F0TmFtZVRvTWlkEkcKCXJpY2hfdGV4dBgIIAEoCzIq'
    'LmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLlJpY2hUZXh0UghyaWNoVGV4dBJFCg'
    'hwaWN0dXJlcxgJIAMoCzIpLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLlBpY3R1'
    'cmVSCHBpY3R1cmVzGmIKC0Vtb3Rlc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5Ej0KBXZhbHVlGA'
    'IgASgLMicuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuRW1vdGVSBXZhbHVlOgI4'
    'ARpiCgtUb3BpY3NFbnRyeRIQCgNrZXkYASABKAlSA2tleRI9CgV2YWx1ZRgCIAEoCzInLmJpbG'
    'liaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLlRvcGljUgV2YWx1ZToCOAEaXgoJVXJsc0Vu'
    'dHJ5EhAKA2tleRgBIAEoCVIDa2V5EjsKBXZhbHVlGAIgASgLMiUuYmlsaWJpbGkubWFpbi5jb2'
    '1tdW5pdHkucmVwbHkudjEuVXJsUgV2YWx1ZToCOAEaPgoQQXROYW1lVG9NaWRFbnRyeRIQCgNr'
    'ZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoA1IFdmFsdWU6AjgB');

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
  ],
};

/// Descriptor for `DetailListReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List detailListReplyDescriptor = $convert.base64Decode(
    'Cg9EZXRhaWxMaXN0UmVwbHkSRQoGY3Vyc29yGAEgASgLMi0uYmlsaWJpbGkubWFpbi5jb21tdW'
    '5pdHkucmVwbHkudjEuQ3Vyc29yUmVwbHlSBmN1cnNvchJZCg9zdWJqZWN0X2NvbnRyb2wYAiAB'
    'KAsyMC5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5TdWJqZWN0Q29udHJvbFIOc3'
    'ViamVjdENvbnRyb2wSPwoEcm9vdBgDIAEoCzIrLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJl'
    'cGx5LnYxLlJlcGx5SW5mb1IEcm9vdBI6CgRtb2RlGAYgASgOMiYuYmlsaWJpbGkubWFpbi5jb2'
    '1tdW5pdHkucmVwbHkudjEuTW9kZVIEbW9kZRIbCgltb2RlX3RleHQYByABKAlSCG1vZGVUZXh0'
    'ElMKEHBhZ2luYXRpb25fcmVwbHkYCCABKAsyKC5iaWxpYmlsaS5wYWdpbmF0aW9uLkZlZWRQYW'
    'dpbmF0aW9uUmVwbHlSD3BhZ2luYXRpb25SZXBseRIdCgpzZXNzaW9uX2lkGAkgASgJUglzZXNz'
    'aW9uSWQ=');

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
    'dGlvbi5GZWVkUGFnaW5hdGlvblIKcGFnaW5hdGlvbg==');

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
    'LnJlcGx5LnYxLlJlcGx5SW5mb1IHcmVwbGllcxJTChBwYWdpbmF0aW9uX3JlcGx5GAUgASgLMi'
    'guYmlsaWJpbGkucGFnaW5hdGlvbi5GZWVkUGFnaW5hdGlvblJlcGx5Ug9wYWdpbmF0aW9uUmVw'
    'bHkSHQoKc2Vzc2lvbl9pZBgGIAEoCVIJc2Vzc2lvbklk');

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
  ],
};

/// Descriptor for `DialogListReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dialogListReqDescriptor = $convert.base64Decode(
    'Cg1EaWFsb2dMaXN0UmVxEhAKA29pZBgBIAEoA1IDb2lkEhIKBHR5cGUYAiABKANSBHR5cGUSEg'
    'oEcm9vdBgDIAEoA1IEcm9vdBIWCgZkaWFsb2cYBCABKANSBmRpYWxvZxJDCgZjdXJzb3IYBSAB'
    'KAsyKy5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5DdXJzb3JSZXFSBmN1cnNvch'
    'JDCgpwYWdpbmF0aW9uGAYgASgLMiMuYmlsaWJpbGkucGFnaW5hdGlvbi5GZWVkUGFnaW5hdGlv'
    'blIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use emoteDescriptor instead')
const Emote$json = {
  '1': 'Emote',
  '2': [
    {'1': 'size', '3': 1, '4': 1, '5': 3, '10': 'size'},
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
    {'1': 'webp_url', '3': 9, '4': 1, '5': 9, '10': 'webpUrl'},
  ],
};

/// Descriptor for `Emote`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emoteDescriptor = $convert.base64Decode(
    'CgVFbW90ZRISCgRzaXplGAEgASgDUgRzaXplEhAKA3VybBgCIAEoCVIDdXJsEhkKCHdlYnBfdX'
    'JsGAkgASgJUgd3ZWJwVXJs');

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
      '1': 'top_replies',
      '3': 14,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyInfo',
      '10': 'topReplies'
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
  ],
};

/// Descriptor for `MainListReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mainListReplyDescriptor = $convert.base64Decode(
    'Cg1NYWluTGlzdFJlcGx5EkUKBmN1cnNvchgBIAEoCzItLmJpbGliaWxpLm1haW4uY29tbXVuaX'
    'R5LnJlcGx5LnYxLkN1cnNvclJlcGx5UgZjdXJzb3ISRQoHcmVwbGllcxgCIAMoCzIrLmJpbGli'
    'aWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLlJlcGx5SW5mb1IHcmVwbGllcxJZCg9zdWJqZW'
    'N0X2NvbnRyb2wYAyABKAsyMC5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5TdWJq'
    'ZWN0Q29udHJvbFIOc3ViamVjdENvbnRyb2wSQgoGdXBfdG9wGAQgASgLMisuYmlsaWJpbGkubW'
    'Fpbi5jb21tdW5pdHkucmVwbHkudjEuUmVwbHlJbmZvUgV1cFRvcBJMCgt0b3BfcmVwbGllcxgO'
    'IAMoCzIrLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLlJlcGx5SW5mb1IKdG9wUm'
    'VwbGllcxI6CgRtb2RlGBIgASgOMiYuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEu'
    'TW9kZVIEbW9kZRIbCgltb2RlX3RleHQYEyABKAlSCG1vZGVUZXh0ElMKEHBhZ2luYXRpb25fcm'
    'VwbHkYFCABKAsyKC5iaWxpYmlsaS5wYWdpbmF0aW9uLkZlZWRQYWdpbmF0aW9uUmVwbHlSD3Bh'
    'Z2luYXRpb25SZXBseRIdCgpzZXNzaW9uX2lkGBUgASgJUglzZXNzaW9uSWQ=');

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
  ],
};

/// Descriptor for `MainListReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mainListReqDescriptor = $convert.base64Decode(
    'CgtNYWluTGlzdFJlcRIQCgNvaWQYASABKANSA29pZBISCgR0eXBlGAIgASgDUgR0eXBlEkMKBm'
    'N1cnNvchgDIAEoCzIrLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLkN1cnNvclJl'
    'cVIGY3Vyc29yEhIKBHJwaWQYBiABKANSBHJwaWQSGwoJc2Vla19ycGlkGAcgASgDUghzZWVrUn'
    'BpZBImCg9maWx0ZXJfdGFnX25hbWUYCCABKAlSDWZpbHRlclRhZ05hbWUSOgoEbW9kZRgJIAEo'
    'DjImLmJpbGliaWxpLm1haW4uY29tbXVuaXR5LnJlcGx5LnYxLk1vZGVSBG1vZGUSQwoKcGFnaW'
    '5hdGlvbhgKIAEoCzIjLmJpbGliaWxpLnBhZ2luYXRpb24uRmVlZFBhZ2luYXRpb25SCnBhZ2lu'
    'YXRpb24=');

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
      '1': 'senior',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.MemberV2.Senior',
      '10': 'senior'
    },
  ],
  '3': [
    MemberV2_Basic$json,
    MemberV2_Garb$json,
    MemberV2_Medal$json,
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
    {'1': 'face', '3': 4, '4': 1, '5': 9, '10': 'face'},
    {'1': 'level', '3': 5, '4': 1, '5': 3, '10': 'level'},
  ],
};

@$core.Deprecated('Use memberV2Descriptor instead')
const MemberV2_Garb$json = {
  '1': 'Garb',
  '2': [
    {'1': 'pendant_image', '3': 1, '4': 1, '5': 9, '10': 'pendantImage'},
    {'1': 'card_image', '3': 2, '4': 1, '5': 9, '10': 'cardImage'},
    {'1': 'card_number', '3': 5, '4': 1, '5': 9, '10': 'cardNumber'},
    {'1': 'card_fan_color', '3': 6, '4': 1, '5': 9, '10': 'cardFanColor'},
    {'1': 'fan_num_prefix', '3': 8, '4': 1, '5': 9, '10': 'fanNumPrefix'},
  ],
};

@$core.Deprecated('Use memberV2Descriptor instead')
const MemberV2_Medal$json = {
  '1': 'Medal',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'level', '3': 2, '4': 1, '5': 3, '10': 'level'},
    {'1': 'color_start', '3': 3, '4': 1, '5': 3, '10': 'colorStart'},
    {'1': 'color_name', '3': 6, '4': 1, '5': 3, '10': 'colorName'},
    {'1': 'guard_level', '3': 8, '4': 1, '5': 3, '10': 'guardLevel'},
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
  ],
};

@$core.Deprecated('Use memberV2Descriptor instead')
const MemberV2_Vip$json = {
  '1': 'Vip',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 3, '10': 'type'},
    {'1': 'status', '3': 2, '4': 1, '5': 3, '10': 'status'},
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
    'bXVuaXR5LnJlcGx5LnYxLk1lbWJlclYyLk1lZGFsUgVtZWRhbBJJCgZzZW5pb3IYByABKAsyMS'
    '5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5NZW1iZXJWMi5TZW5pb3JSBnNlbmlv'
    'chpXCgVCYXNpYxIQCgNtaWQYASABKANSA21pZBISCgRuYW1lGAIgASgJUgRuYW1lEhIKBGZhY2'
    'UYBCABKAlSBGZhY2USFAoFbGV2ZWwYBSABKANSBWxldmVsGrcBCgRHYXJiEiMKDXBlbmRhbnRf'
    'aW1hZ2UYASABKAlSDHBlbmRhbnRJbWFnZRIdCgpjYXJkX2ltYWdlGAIgASgJUgljYXJkSW1hZ2'
    'USHwoLY2FyZF9udW1iZXIYBSABKAlSCmNhcmROdW1iZXISJAoOY2FyZF9mYW5fY29sb3IYBiAB'
    'KAlSDGNhcmRGYW5Db2xvchIkCg5mYW5fbnVtX3ByZWZpeBgIIAEoCVIMZmFuTnVtUHJlZml4Gp'
    'IBCgVNZWRhbBISCgRuYW1lGAEgASgJUgRuYW1lEhQKBWxldmVsGAIgASgDUgVsZXZlbBIfCgtj'
    'b2xvcl9zdGFydBgDIAEoA1IKY29sb3JTdGFydBIdCgpjb2xvcl9uYW1lGAYgASgDUgljb2xvck'
    '5hbWUSHwoLZ3VhcmRfbGV2ZWwYCCABKANSCmd1YXJkTGV2ZWwaKwoIT2ZmaWNpYWwSHwoLdmVy'
    'aWZ5X3R5cGUYASABKANSCnZlcmlmeVR5cGUaMgoGU2VuaW9yEigKEGlzX3Nlbmlvcl9tZW1iZX'
    'IYASABKAVSDmlzU2VuaW9yTWVtYmVyGjEKA1ZpcBISCgR0eXBlGAEgASgDUgR0eXBlEhYKBnN0'
    'YXR1cxgCIAEoA1IGc3RhdHVz');

@$core.Deprecated('Use opusItemDescriptor instead')
const OpusItem$json = {
  '1': 'OpusItem',
  '2': [
    {'1': 'opus_id', '3': 1, '4': 1, '5': 3, '10': 'opusId'},
  ],
};

/// Descriptor for `OpusItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opusItemDescriptor =
    $convert.base64Decode('CghPcHVzSXRlbRIXCgdvcHVzX2lkGAEgASgDUgZvcHVzSWQ=');

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
  ],
};

/// Descriptor for `Picture`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pictureDescriptor = $convert.base64Decode(
    'CgdQaWN0dXJlEhcKB2ltZ19zcmMYASABKAlSBmltZ1NyYxIbCglpbWdfd2lkdGgYAiABKAFSCG'
    'ltZ1dpZHRoEh0KCmltZ19oZWlnaHQYAyABKAFSCWltZ0hlaWdodBIZCghpbWdfc2l6ZRgEIAEo'
    'AVIHaW1nU2l6ZQ==');

@$core.Deprecated('Use replyCardLabelDescriptor instead')
const ReplyCardLabel$json = {
  '1': 'ReplyCardLabel',
  '2': [
    {'1': 'text_content', '3': 1, '4': 1, '5': 9, '10': 'textContent'},
  ],
};

/// Descriptor for `ReplyCardLabel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replyCardLabelDescriptor = $convert.base64Decode(
    'Cg5SZXBseUNhcmRMYWJlbBIhCgx0ZXh0X2NvbnRlbnQYASABKAlSC3RleHRDb250ZW50');

@$core.Deprecated('Use replyControlDescriptor instead')
const ReplyControl$json = {
  '1': 'ReplyControl',
  '2': [
    {'1': 'action', '3': 1, '4': 1, '5': 3, '10': 'action'},
    {'1': 'up_like', '3': 2, '4': 1, '5': 8, '10': 'upLike'},
    {'1': 'up_reply', '3': 3, '4': 1, '5': 8, '10': 'upReply'},
    {'1': 'is_up_top', '3': 12, '4': 1, '5': 8, '10': 'isUpTop'},
    {'1': 'is_note', '3': 18, '4': 1, '5': 8, '10': 'isNote'},
    {
      '1': 'card_labels',
      '3': 19,
      '4': 3,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.ReplyCardLabel',
      '10': 'cardLabels'
    },
    {'1': 'location', '3': 25, '4': 1, '5': 9, '10': 'location'},
    {'1': 'is_note_v2', '3': 27, '4': 1, '5': 8, '10': 'isNoteV2'},
  ],
};

/// Descriptor for `ReplyControl`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List replyControlDescriptor = $convert.base64Decode(
    'CgxSZXBseUNvbnRyb2wSFgoGYWN0aW9uGAEgASgDUgZhY3Rpb24SFwoHdXBfbGlrZRgCIAEoCF'
    'IGdXBMaWtlEhkKCHVwX3JlcGx5GAMgASgIUgd1cFJlcGx5EhoKCWlzX3VwX3RvcBgMIAEoCFIH'
    'aXNVcFRvcBIXCgdpc19ub3RlGBIgASgIUgZpc05vdGUSUQoLY2FyZF9sYWJlbHMYEyADKAsyMC'
    '5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5SZXBseUNhcmRMYWJlbFIKY2FyZExh'
    'YmVscxIaCghsb2NhdGlvbhgZIAEoCVIIbG9jYXRpb24SHAoKaXNfbm90ZV92MhgbIAEoCFIIaX'
    'NOb3RlVjI=');

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
    'bHkudjEuQ29udGVudFIHY29udGVudBJTCg1yZXBseV9jb250cm9sGA4gASgLMi4uYmlsaWJpbG'
    'kubWFpbi5jb21tdW5pdHkucmVwbHkudjEuUmVwbHlDb250cm9sUgxyZXBseUNvbnRyb2wSRwoJ'
    'bWVtYmVyX3YyGA8gASgLMiouYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucmVwbHkudjEuTWVtYm'
    'VyVjJSCG1lbWJlclYy');

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
      '6': '.bilibili.main.community.reply.v1.OpusItem',
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
    'kudjEuUmljaFRleHROb3RlSABSBG5vdGUSQAoEb3B1cxgCIAEoCzIqLmJpbGliaWxpLm1haW4u'
    'Y29tbXVuaXR5LnJlcGx5LnYxLk9wdXNJdGVtSABSBG9wdXNCBgoEaXRlbQ==');

@$core.Deprecated('Use richTextNoteDescriptor instead')
const RichTextNote$json = {
  '1': 'RichTextNote',
  '2': [
    {'1': 'click_url', '3': 3, '4': 1, '5': 9, '10': 'clickUrl'},
  ],
};

/// Descriptor for `RichTextNote`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List richTextNoteDescriptor = $convert.base64Decode(
    'CgxSaWNoVGV4dE5vdGUSGwoJY2xpY2tfdXJsGAMgASgJUghjbGlja1VybA==');

@$core.Deprecated('Use searchItemDescriptor instead')
const SearchItem$json = {
  '1': 'SearchItem',
  '2': [
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
    'CgpTZWFyY2hJdGVtEkkKBXZpZGVvGAMgASgLMjEuYmlsaWJpbGkubWFpbi5jb21tdW5pdHkucm'
    'VwbHkudjEuVmlkZW9TZWFyY2hJdGVtSABSBXZpZGVvEk8KB2FydGljbGUYBCABKAsyMy5iaWxp'
    'YmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5BcnRpY2xlU2VhcmNoSXRlbUgAUgdhcnRpY2'
    'xlEhAKA3VybBgBIAEoCVIDdXJsQgYKBGl0ZW0=');

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
  ],
};

/// Descriptor for `SearchItemReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchItemReplyDescriptor = $convert.base64Decode(
    'Cg9TZWFyY2hJdGVtUmVwbHkSTwoGY3Vyc29yGAEgASgLMjcuYmlsaWJpbGkubWFpbi5jb21tdW'
    '5pdHkucmVwbHkudjEuU2VhcmNoSXRlbUN1cnNvclJlcGx5UgZjdXJzb3ISQgoFaXRlbXMYAiAD'
    'KAsyLC5iaWxpYmlsaS5tYWluLmNvbW11bml0eS5yZXBseS52MS5TZWFyY2hJdGVtUgVpdGVtcw'
    '==');

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

@$core.Deprecated('Use subjectControlDescriptor instead')
const SubjectControl$json = {
  '1': 'SubjectControl',
  '2': [
    {'1': 'up_mid', '3': 1, '4': 1, '5': 3, '10': 'upMid'},
    {'1': 'input_disable', '3': 13, '4': 1, '5': 8, '10': 'inputDisable'},
    {'1': 'root_text', '3': 14, '4': 1, '5': 9, '10': 'rootText'},
    {'1': 'count', '3': 16, '4': 1, '5': 3, '10': 'count'},
    {'1': 'title', '3': 17, '4': 1, '5': 9, '10': 'title'},
  ],
};

/// Descriptor for `SubjectControl`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subjectControlDescriptor = $convert.base64Decode(
    'Cg5TdWJqZWN0Q29udHJvbBIVCgZ1cF9taWQYASABKANSBXVwTWlkEiMKDWlucHV0X2Rpc2FibG'
    'UYDSABKAhSDGlucHV0RGlzYWJsZRIbCglyb290X3RleHQYDiABKAlSCHJvb3RUZXh0EhQKBWNv'
    'dW50GBAgASgDUgVjb3VudBIUCgV0aXRsZRgRIAEoCVIFdGl0bGU=');

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

@$core.Deprecated('Use urlDescriptor instead')
const Url$json = {
  '1': 'Url',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'prefix_icon', '3': 3, '4': 1, '5': 9, '10': 'prefixIcon'},
    {'1': 'app_url_schema', '3': 4, '4': 1, '5': 9, '10': 'appUrlSchema'},
    {'1': 'click_report', '3': 7, '4': 1, '5': 9, '10': 'clickReport'},
    {
      '1': 'extra',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.bilibili.main.community.reply.v1.Url.Extra',
      '10': 'extra'
    },
  ],
  '3': [Url_Extra$json],
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
    {'1': 'is_word_search', '3': 4, '4': 1, '5': 8, '10': 'isWordSearch'},
    {'1': 'goods_cm_control', '3': 5, '4': 1, '5': 3, '10': 'goodsCmControl'},
  ],
};

/// Descriptor for `Url`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List urlDescriptor = $convert.base64Decode(
    'CgNVcmwSFAoFdGl0bGUYASABKAlSBXRpdGxlEh8KC3ByZWZpeF9pY29uGAMgASgJUgpwcmVmaX'
    'hJY29uEiQKDmFwcF91cmxfc2NoZW1hGAQgASgJUgxhcHBVcmxTY2hlbWESIQoMY2xpY2tfcmVw'
    'b3J0GAcgASgJUgtjbGlja1JlcG9ydBJBCgVleHRyYRgKIAEoCzIrLmJpbGliaWxpLm1haW4uY2'
    '9tbXVuaXR5LnJlcGx5LnYxLlVybC5FeHRyYVIFZXh0cmEasQEKBUV4dHJhEiIKDWdvb2RzX2l0'
    'ZW1faWQYASABKANSC2dvb2RzSXRlbUlkEjQKFmdvb2RzX3ByZWZldGNoZWRfY2FjaGUYAiABKA'
    'lSFGdvb2RzUHJlZmV0Y2hlZENhY2hlEiQKDmlzX3dvcmRfc2VhcmNoGAQgASgIUgxpc1dvcmRT'
    'ZWFyY2gSKAoQZ29vZHNfY21fY29udHJvbBgFIAEoA1IOZ29vZHNDbUNvbnRyb2w=');

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
  ],
};

/// Descriptor for `Vote`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voteDescriptor = $convert.base64Decode(
    'CgRWb3RlEg4KAmlkGAEgASgDUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGU=');
