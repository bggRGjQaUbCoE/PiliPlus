// This is a generated file - do not edit.
//
// Generated from bilibili/app/listener/v1.proto.

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

@$core.Deprecated('Use listOrderDescriptor instead')
const ListOrder$json = {
  '1': 'ListOrder',
  '2': [
    {'1': 'NO_ORDER', '2': 0},
    {'1': 'ORDER_NORMAL', '2': 1},
    {'1': 'ORDER_REVERSE', '2': 2},
    {'1': 'ORDER_RANDOM', '2': 3},
  ],
};

/// Descriptor for `ListOrder`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List listOrderDescriptor = $convert.base64Decode(
    'CglMaXN0T3JkZXISDAoITk9fT1JERVIQABIQCgxPUkRFUl9OT1JNQUwQARIRCg1PUkRFUl9SRV'
    'ZFUlNFEAISEAoMT1JERVJfUkFORE9NEAM=');

@$core.Deprecated('Use listSortFieldDescriptor instead')
const ListSortField$json = {
  '1': 'ListSortField',
  '2': [
    {'1': 'NO_SORT', '2': 0},
    {'1': 'SORT_CTIME', '2': 1},
    {'1': 'SORT_VIEWCNT', '2': 2},
    {'1': 'SORT_FAVCNT', '2': 3},
  ],
};

/// Descriptor for `ListSortField`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List listSortFieldDescriptor = $convert.base64Decode(
    'Cg1MaXN0U29ydEZpZWxkEgsKB05PX1NPUlQQABIOCgpTT1JUX0NUSU1FEAESEAoMU09SVF9WSU'
    'VXQ05UEAISDwoLU09SVF9GQVZDTlQQAw==');

@$core.Deprecated('Use playlistSourceDescriptor instead')
const PlaylistSource$json = {
  '1': 'PlaylistSource',
  '2': [
    {'1': 'DEFAULT', '2': 0},
    {'1': 'MEM_SPACE', '2': 1},
    {'1': 'AUDIO_COLLECTION', '2': 2},
    {'1': 'AUDIO_CARD', '2': 3},
    {'1': 'USER_FAVOURITE', '2': 4},
    {'1': 'UP_ARCHIVE', '2': 5},
    {'1': 'AUDIO_CACHE', '2': 6},
    {'1': 'PICK_CARD', '2': 7},
    {'1': 'MEDIA_LIST', '2': 8},
  ],
};

/// Descriptor for `PlaylistSource`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List playlistSourceDescriptor = $convert.base64Decode(
    'Cg5QbGF5bGlzdFNvdXJjZRILCgdERUZBVUxUEAASDQoJTUVNX1NQQUNFEAESFAoQQVVESU9fQ0'
    '9MTEVDVElPThACEg4KCkFVRElPX0NBUkQQAxISCg5VU0VSX0ZBVk9VUklURRAEEg4KClVQX0FS'
    'Q0hJVkUQBRIPCgtBVURJT19DQUNIRRAGEg0KCVBJQ0tfQ0FSRBAHEg4KCk1FRElBX0xJU1QQCA'
    '==');

@$core.Deprecated('Use authorDescriptor instead')
const Author$json = {
  '1': 'Author',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'avatar', '3': 3, '4': 1, '5': 9, '10': 'avatar'},
  ],
};

/// Descriptor for `Author`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authorDescriptor = $convert.base64Decode(
    'CgZBdXRob3ISEAoDbWlkGAEgASgDUgNtaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIWCgZhdmF0YX'
    'IYAyABKAlSBmF2YXRhcg==');

@$core.Deprecated('Use bKArcPartDescriptor instead')
const BKArcPart$json = {
  '1': 'BKArcPart',
  '2': [
    {'1': 'oid', '3': 1, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'sub_id', '3': 2, '4': 1, '5': 3, '10': 'subId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'duration', '3': 4, '4': 1, '5': 3, '10': 'duration'},
    {'1': 'page', '3': 5, '4': 1, '5': 5, '10': 'page'},
  ],
};

/// Descriptor for `BKArcPart`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bKArcPartDescriptor = $convert.base64Decode(
    'CglCS0FyY1BhcnQSEAoDb2lkGAEgASgDUgNvaWQSFQoGc3ViX2lkGAIgASgDUgVzdWJJZBIUCg'
    'V0aXRsZRgDIAEoCVIFdGl0bGUSGgoIZHVyYXRpb24YBCABKANSCGR1cmF0aW9uEhIKBHBhZ2UY'
    'BSABKAVSBHBhZ2U=');

@$core.Deprecated('Use bKArchiveDescriptor instead')
const BKArchive$json = {
  '1': 'BKArchive',
  '2': [
    {'1': 'oid', '3': 1, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'cover', '3': 3, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'desc', '3': 4, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'duration', '3': 5, '4': 1, '5': 3, '10': 'duration'},
    {'1': 'rid', '3': 6, '4': 1, '5': 5, '10': 'rid'},
    {'1': 'publish', '3': 8, '4': 1, '5': 3, '10': 'publish'},
    {'1': 'displayed_oid', '3': 9, '4': 1, '5': 9, '10': 'displayedOid'},
    {'1': 'copyright', '3': 10, '4': 1, '5': 5, '10': 'copyright'},
  ],
};

/// Descriptor for `BKArchive`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bKArchiveDescriptor = $convert.base64Decode(
    'CglCS0FyY2hpdmUSEAoDb2lkGAEgASgDUgNvaWQSFAoFdGl0bGUYAiABKAlSBXRpdGxlEhQKBW'
    'NvdmVyGAMgASgJUgVjb3ZlchISCgRkZXNjGAQgASgJUgRkZXNjEhoKCGR1cmF0aW9uGAUgASgD'
    'UghkdXJhdGlvbhIQCgNyaWQYBiABKAVSA3JpZBIYCgdwdWJsaXNoGAggASgDUgdwdWJsaXNoEi'
    'MKDWRpc3BsYXllZF9vaWQYCSABKAlSDGRpc3BsYXllZE9pZBIcCgljb3B5cmlnaHQYCiABKAVS'
    'CWNvcHlyaWdodA==');

@$core.Deprecated('Use bKStatDescriptor instead')
const BKStat$json = {
  '1': 'BKStat',
  '2': [
    {'1': 'like', '3': 1, '4': 1, '5': 5, '10': 'like'},
    {'1': 'coin', '3': 2, '4': 1, '5': 5, '10': 'coin'},
    {'1': 'favourite', '3': 3, '4': 1, '5': 5, '10': 'favourite'},
    {'1': 'reply', '3': 4, '4': 1, '5': 5, '10': 'reply'},
    {'1': 'share', '3': 5, '4': 1, '5': 5, '10': 'share'},
    {'1': 'view', '3': 6, '4': 1, '5': 5, '10': 'view'},
    {'1': 'has_like', '3': 7, '4': 1, '5': 8, '10': 'hasLike'},
    {'1': 'has_coin', '3': 8, '4': 1, '5': 8, '10': 'hasCoin'},
    {'1': 'has_fav', '3': 9, '4': 1, '5': 8, '10': 'hasFav'},
  ],
};

/// Descriptor for `BKStat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bKStatDescriptor = $convert.base64Decode(
    'CgZCS1N0YXQSEgoEbGlrZRgBIAEoBVIEbGlrZRISCgRjb2luGAIgASgFUgRjb2luEhwKCWZhdm'
    '91cml0ZRgDIAEoBVIJZmF2b3VyaXRlEhQKBXJlcGx5GAQgASgFUgVyZXBseRIUCgVzaGFyZRgF'
    'IAEoBVIFc2hhcmUSEgoEdmlldxgGIAEoBVIEdmlldxIZCghoYXNfbGlrZRgHIAEoCFIHaGFzTG'
    'lrZRIZCghoYXNfY29pbhgIIAEoCFIHaGFzQ29pbhIXCgdoYXNfZmF2GAkgASgIUgZoYXNGYXY=');

@$core.Deprecated('Use coinAddReqDescriptor instead')
const CoinAddReq$json = {
  '1': 'CoinAddReq',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'item'
    },
    {'1': 'num', '3': 2, '4': 1, '5': 5, '10': 'num'},
    {'1': 'thumb_up', '3': 3, '4': 1, '5': 8, '10': 'thumbUp'},
  ],
};

/// Descriptor for `CoinAddReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List coinAddReqDescriptor = $convert.base64Decode(
    'CgpDb2luQWRkUmVxEjYKBGl0ZW0YASABKAsyIi5iaWxpYmlsaS5hcHAubGlzdGVuZXIudjEuUG'
    'xheUl0ZW1SBGl0ZW0SEAoDbnVtGAIgASgFUgNudW0SGQoIdGh1bWJfdXAYAyABKAhSB3RodW1i'
    'VXA=');

@$core.Deprecated('Use coinAddRespDescriptor instead')
const CoinAddResp$json = {
  '1': 'CoinAddResp',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `CoinAddResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List coinAddRespDescriptor = $convert
    .base64Decode('CgtDb2luQWRkUmVzcBIYCgdtZXNzYWdlGAEgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use dashItemDescriptor instead')
const DashItem$json = {
  '1': 'DashItem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'base_url', '3': 2, '4': 1, '5': 9, '10': 'baseUrl'},
    {'1': 'backup_url', '3': 3, '4': 3, '5': 9, '10': 'backupUrl'},
  ],
};

/// Descriptor for `DashItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dashItemDescriptor = $convert.base64Decode(
    'CghEYXNoSXRlbRIOCgJpZBgBIAEoBVICaWQSGQoIYmFzZV91cmwYAiABKAlSB2Jhc2VVcmwSHQ'
    'oKYmFja3VwX3VybBgDIAMoCVIJYmFja3VwVXJs');

@$core.Deprecated('Use detailItemDescriptor instead')
const DetailItem$json = {
  '1': 'DetailItem',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'item'
    },
    {
      '1': 'arc',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.BKArchive',
      '10': 'arc'
    },
    {
      '1': 'parts',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.BKArcPart',
      '10': 'parts'
    },
    {
      '1': 'owner',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.Author',
      '10': 'owner'
    },
    {
      '1': 'stat',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.BKStat',
      '10': 'stat'
    },
    {'1': 'last_part', '3': 6, '4': 1, '5': 3, '10': 'lastPart'},
    {'1': 'progress', '3': 7, '4': 1, '5': 3, '10': 'progress'},
    {'1': 'last_play_time', '3': 12, '4': 1, '5': 3, '10': 'lastPlayTime'},
    {
      '1': 'associated_item',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'associatedItem'
    },
  ],
};

/// Descriptor for `DetailItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List detailItemDescriptor = $convert.base64Decode(
    'CgpEZXRhaWxJdGVtEjYKBGl0ZW0YASABKAsyIi5iaWxpYmlsaS5hcHAubGlzdGVuZXIudjEuUG'
    'xheUl0ZW1SBGl0ZW0SNQoDYXJjGAIgASgLMiMuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLkJL'
    'QXJjaGl2ZVIDYXJjEjkKBXBhcnRzGAMgAygLMiMuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLk'
    'JLQXJjUGFydFIFcGFydHMSNgoFb3duZXIYBCABKAsyIC5iaWxpYmlsaS5hcHAubGlzdGVuZXIu'
    'djEuQXV0aG9yUgVvd25lchI0CgRzdGF0GAUgASgLMiAuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLn'
    'YxLkJLU3RhdFIEc3RhdBIbCglsYXN0X3BhcnQYBiABKANSCGxhc3RQYXJ0EhoKCHByb2dyZXNz'
    'GAcgASgDUghwcm9ncmVzcxIkCg5sYXN0X3BsYXlfdGltZRgMIAEoA1IMbGFzdFBsYXlUaW1lEk'
    'sKD2Fzc29jaWF0ZWRfaXRlbRgLIAEoCzIiLmJpbGliaWxpLmFwcC5saXN0ZW5lci52MS5QbGF5'
    'SXRlbVIOYXNzb2NpYXRlZEl0ZW0=');

@$core.Deprecated('Use playDASHDescriptor instead')
const PlayDASH$json = {
  '1': 'PlayDASH',
  '2': [
    {
      '1': 'audio',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.DashItem',
      '10': 'audio'
    },
  ],
};

/// Descriptor for `PlayDASH`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playDASHDescriptor = $convert.base64Decode(
    'CghQbGF5REFTSBI4CgVhdWRpbxgDIAMoCzIiLmJpbGliaWxpLmFwcC5saXN0ZW5lci52MS5EYX'
    'NoSXRlbVIFYXVkaW8=');

@$core.Deprecated('Use playInfoDescriptor instead')
const PlayInfo$json = {
  '1': 'PlayInfo',
  '2': [
    {
      '1': 'play_url',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayURL',
      '9': 0,
      '10': 'playUrl'
    },
    {
      '1': 'play_dash',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayDASH',
      '9': 0,
      '10': 'playDash'
    },
  ],
  '8': [
    {'1': 'info'},
  ],
};

/// Descriptor for `PlayInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playInfoDescriptor = $convert.base64Decode(
    'CghQbGF5SW5mbxI+CghwbGF5X3VybBgEIAEoCzIhLmJpbGliaWxpLmFwcC5saXN0ZW5lci52MS'
    '5QbGF5VVJMSABSB3BsYXlVcmwSQQoJcGxheV9kYXNoGAUgASgLMiIuYmlsaWJpbGkuYXBwLmxp'
    'c3RlbmVyLnYxLlBsYXlEQVNISABSCHBsYXlEYXNoQgYKBGluZm8=');

@$core.Deprecated('Use playItemDescriptor instead')
const PlayItem$json = {
  '1': 'PlayItem',
  '2': [
    {'1': 'item_type', '3': 1, '4': 1, '5': 5, '10': 'itemType'},
    {'1': 'oid', '3': 3, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'sub_id', '3': 4, '4': 3, '5': 3, '10': 'subId'},
    {'1': 'pos', '3': 6, '4': 1, '5': 3, '10': 'pos'},
  ],
};

/// Descriptor for `PlayItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playItemDescriptor = $convert.base64Decode(
    'CghQbGF5SXRlbRIbCglpdGVtX3R5cGUYASABKAVSCGl0ZW1UeXBlEhAKA29pZBgDIAEoA1IDb2'
    'lkEhUKBnN1Yl9pZBgEIAMoA1IFc3ViSWQSEAoDcG9zGAYgASgDUgNwb3M=');

@$core.Deprecated('Use playURLDescriptor instead')
const PlayURL$json = {
  '1': 'PlayURL',
  '2': [
    {
      '1': 'durl',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.ResponseUrl',
      '10': 'durl'
    },
  ],
};

/// Descriptor for `PlayURL`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playURLDescriptor = $convert.base64Decode(
    'CgdQbGF5VVJMEjkKBGR1cmwYASADKAsyJS5iaWxpYmlsaS5hcHAubGlzdGVuZXIudjEuUmVzcG'
    '9uc2VVcmxSBGR1cmw=');

@$core.Deprecated('Use playURLReqDescriptor instead')
const PlayURLReq$json = {
  '1': 'PlayURLReq',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'item'
    },
    {
      '1': 'player_args',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.archive.middleware.v1.PlayerArgs',
      '10': 'playerArgs'
    },
  ],
};

/// Descriptor for `PlayURLReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playURLReqDescriptor = $convert.base64Decode(
    'CgpQbGF5VVJMUmVxEjYKBGl0ZW0YASABKAsyIi5iaWxpYmlsaS5hcHAubGlzdGVuZXIudjEuUG'
    'xheUl0ZW1SBGl0ZW0STwoLcGxheWVyX2FyZ3MYAiABKAsyLi5iaWxpYmlsaS5hcHAuYXJjaGl2'
    'ZS5taWRkbGV3YXJlLnYxLlBsYXllckFyZ3NSCnBsYXllckFyZ3M=');

@$core.Deprecated('Use playURLRespDescriptor instead')
const PlayURLResp$json = {
  '1': 'PlayURLResp',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'item'
    },
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'player_info',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayURLResp.PlayerInfoEntry',
      '10': 'playerInfo'
    },
  ],
  '3': [PlayURLResp_PlayerInfoEntry$json],
};

@$core.Deprecated('Use playURLRespDescriptor instead')
const PlayURLResp_PlayerInfoEntry$json = {
  '1': 'PlayerInfoEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 3, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayInfo',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `PlayURLResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playURLRespDescriptor = $convert.base64Decode(
    'CgtQbGF5VVJMUmVzcBI2CgRpdGVtGAEgASgLMiIuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLl'
    'BsYXlJdGVtUgRpdGVtEhgKB21lc3NhZ2UYAyABKAlSB21lc3NhZ2USVgoLcGxheWVyX2luZm8Y'
    'BCADKAsyNS5iaWxpYmlsaS5hcHAubGlzdGVuZXIudjEuUGxheVVSTFJlc3AuUGxheWVySW5mb0'
    'VudHJ5UgpwbGF5ZXJJbmZvGmEKD1BsYXllckluZm9FbnRyeRIQCgNrZXkYASABKANSA2tleRI4'
    'CgV2YWx1ZRgCIAEoCzIiLmJpbGliaWxpLmFwcC5saXN0ZW5lci52MS5QbGF5SW5mb1IFdmFsdW'
    'U6AjgB');

@$core.Deprecated('Use playlistReqDescriptor instead')
const PlaylistReq$json = {
  '1': 'PlaylistReq',
  '2': [
    {
      '1': 'from',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.listener.v1.PlaylistSource',
      '10': 'from'
    },
    {'1': 'id', '3': 2, '4': 1, '5': 3, '10': 'id'},
    {
      '1': 'anchor',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'anchor'
    },
    {
      '1': 'player_args',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.archive.middleware.v1.PlayerArgs',
      '10': 'playerArgs'
    },
    {'1': 'extra_id', '3': 6, '4': 1, '5': 3, '10': 'extraId'},
    {
      '1': 'sort_opt',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.SortOption',
      '10': 'sortOpt'
    },
    {
      '1': 'pagination',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.pagination.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `PlaylistReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistReqDescriptor = $convert.base64Decode(
    'CgtQbGF5bGlzdFJlcRI8CgRmcm9tGAEgASgOMiguYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLl'
    'BsYXlsaXN0U291cmNlUgRmcm9tEg4KAmlkGAIgASgDUgJpZBI6CgZhbmNob3IYAyABKAsyIi5i'
    'aWxpYmlsaS5hcHAubGlzdGVuZXIudjEuUGxheUl0ZW1SBmFuY2hvchJPCgtwbGF5ZXJfYXJncx'
    'gFIAEoCzIuLmJpbGliaWxpLmFwcC5hcmNoaXZlLm1pZGRsZXdhcmUudjEuUGxheWVyQXJnc1IK'
    'cGxheWVyQXJncxIZCghleHRyYV9pZBgGIAEoA1IHZXh0cmFJZBI/Cghzb3J0X29wdBgHIAEoCz'
    'IkLmJpbGliaWxpLmFwcC5saXN0ZW5lci52MS5Tb3J0T3B0aW9uUgdzb3J0T3B0Ej8KCnBhZ2lu'
    'YXRpb24YCCABKAsyHy5iaWxpYmlsaS5wYWdpbmF0aW9uLlBhZ2luYXRpb25SCnBhZ2luYXRpb2'
    '4=');

@$core.Deprecated('Use playlistRespDescriptor instead')
const PlaylistResp$json = {
  '1': 'PlaylistResp',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 5, '10': 'total'},
    {'1': 'reach_start', '3': 2, '4': 1, '5': 8, '10': 'reachStart'},
    {'1': 'reach_end', '3': 3, '4': 1, '5': 8, '10': 'reachEnd'},
    {
      '1': 'list',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.DetailItem',
      '10': 'list'
    },
    {
      '1': 'last_play',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'lastPlay'
    },
    {'1': 'last_progress', '3': 6, '4': 1, '5': 3, '10': 'lastProgress'},
    {
      '1': 'pagination_reply',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.pagination.PaginationReply',
      '10': 'paginationReply'
    },
  ],
};

/// Descriptor for `PlaylistResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistRespDescriptor = $convert.base64Decode(
    'CgxQbGF5bGlzdFJlc3ASFAoFdG90YWwYASABKAVSBXRvdGFsEh8KC3JlYWNoX3N0YXJ0GAIgAS'
    'gIUgpyZWFjaFN0YXJ0EhsKCXJlYWNoX2VuZBgDIAEoCFIIcmVhY2hFbmQSOAoEbGlzdBgEIAMo'
    'CzIkLmJpbGliaWxpLmFwcC5saXN0ZW5lci52MS5EZXRhaWxJdGVtUgRsaXN0Ej8KCWxhc3RfcG'
    'xheRgFIAEoCzIiLmJpbGliaWxpLmFwcC5saXN0ZW5lci52MS5QbGF5SXRlbVIIbGFzdFBsYXkS'
    'IwoNbGFzdF9wcm9ncmVzcxgGIAEoA1IMbGFzdFByb2dyZXNzEk8KEHBhZ2luYXRpb25fcmVwbH'
    'kYByABKAsyJC5iaWxpYmlsaS5wYWdpbmF0aW9uLlBhZ2luYXRpb25SZXBseVIPcGFnaW5hdGlv'
    'blJlcGx5');

@$core.Deprecated('Use responseUrlDescriptor instead')
const ResponseUrl$json = {
  '1': 'ResponseUrl',
  '2': [
    {'1': 'url', '3': 6, '4': 1, '5': 9, '10': 'url'},
    {'1': 'backup_url', '3': 7, '4': 3, '5': 9, '10': 'backupUrl'},
  ],
};

/// Descriptor for `ResponseUrl`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseUrlDescriptor = $convert.base64Decode(
    'CgtSZXNwb25zZVVybBIQCgN1cmwYBiABKAlSA3VybBIdCgpiYWNrdXBfdXJsGAcgAygJUgliYW'
    'NrdXBVcmw=');

@$core.Deprecated('Use sortOptionDescriptor instead')
const SortOption$json = {
  '1': 'SortOption',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.listener.v1.ListOrder',
      '10': 'order'
    },
    {
      '1': 'sort_field',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.listener.v1.ListSortField',
      '10': 'sortField'
    },
  ],
};

/// Descriptor for `SortOption`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sortOptionDescriptor = $convert.base64Decode(
    'CgpTb3J0T3B0aW9uEjkKBW9yZGVyGAEgASgOMiMuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLk'
    'xpc3RPcmRlclIFb3JkZXISRgoKc29ydF9maWVsZBgCIAEoDjInLmJpbGliaWxpLmFwcC5saXN0'
    'ZW5lci52MS5MaXN0U29ydEZpZWxkUglzb3J0RmllbGQ=');

@$core.Deprecated('Use thumbUpReqDescriptor instead')
const ThumbUpReq$json = {
  '1': 'ThumbUpReq',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'item'
    },
    {
      '1': 'action',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.listener.v1.ThumbUpReq.ThumbType',
      '10': 'action'
    },
  ],
  '4': [ThumbUpReq_ThumbType$json],
};

@$core.Deprecated('Use thumbUpReqDescriptor instead')
const ThumbUpReq_ThumbType$json = {
  '1': 'ThumbType',
  '2': [
    {'1': 'LIKE', '2': 0},
    {'1': 'CANCEL_LIKE', '2': 1},
    {'1': 'DISLIKE', '2': 2},
    {'1': 'CANCEL_DISLIKE', '2': 3},
  ],
};

/// Descriptor for `ThumbUpReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List thumbUpReqDescriptor = $convert.base64Decode(
    'CgpUaHVtYlVwUmVxEjYKBGl0ZW0YASABKAsyIi5iaWxpYmlsaS5hcHAubGlzdGVuZXIudjEuUG'
    'xheUl0ZW1SBGl0ZW0SRgoGYWN0aW9uGAIgASgOMi4uYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYx'
    'LlRodW1iVXBSZXEuVGh1bWJUeXBlUgZhY3Rpb24iRwoJVGh1bWJUeXBlEggKBExJS0UQABIPCg'
    'tDQU5DRUxfTElLRRABEgsKB0RJU0xJS0UQAhISCg5DQU5DRUxfRElTTElLRRAD');

@$core.Deprecated('Use thumbUpRespDescriptor instead')
const ThumbUpResp$json = {
  '1': 'ThumbUpResp',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ThumbUpResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List thumbUpRespDescriptor = $convert
    .base64Decode('CgtUaHVtYlVwUmVzcBIYCgdtZXNzYWdlGAEgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use tripleLikeReqDescriptor instead')
const TripleLikeReq$json = {
  '1': 'TripleLikeReq',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `TripleLikeReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tripleLikeReqDescriptor = $convert.base64Decode(
    'Cg1UcmlwbGVMaWtlUmVxEjYKBGl0ZW0YASABKAsyIi5iaWxpYmlsaS5hcHAubGlzdGVuZXIudj'
    'EuUGxheUl0ZW1SBGl0ZW0=');

@$core.Deprecated('Use tripleLikeRespDescriptor instead')
const TripleLikeResp$json = {
  '1': 'TripleLikeResp',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
    {'1': 'thumb_ok', '3': 2, '4': 1, '5': 8, '10': 'thumbOk'},
    {'1': 'coin_ok', '3': 3, '4': 1, '5': 8, '10': 'coinOk'},
    {'1': 'fav_ok', '3': 4, '4': 1, '5': 8, '10': 'favOk'},
  ],
};

/// Descriptor for `TripleLikeResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tripleLikeRespDescriptor = $convert.base64Decode(
    'Cg5UcmlwbGVMaWtlUmVzcBIYCgdtZXNzYWdlGAEgASgJUgdtZXNzYWdlEhkKCHRodW1iX29rGA'
    'IgASgIUgd0aHVtYk9rEhcKB2NvaW5fb2sYAyABKAhSBmNvaW5PaxIVCgZmYXZfb2sYBCABKAhS'
    'BWZhdk9r');
