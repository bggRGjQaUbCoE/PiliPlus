// This is a generated file - do not edit.
//
// Generated from bilibili/app/listener/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use cardModuleTypeDescriptor instead')
const CardModuleType$json = {
  '1': 'CardModuleType',
  '2': [
    {'1': 'Module_invalid', '2': 0},
    {'1': 'Module_header', '2': 1},
    {'1': 'Module_archive', '2': 2},
    {'1': 'Module_cbtn', '2': 3},
  ],
};

/// Descriptor for `CardModuleType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List cardModuleTypeDescriptor = $convert.base64Decode(
    'Cg5DYXJkTW9kdWxlVHlwZRISCg5Nb2R1bGVfaW52YWxpZBAAEhEKDU1vZHVsZV9oZWFkZXIQAR'
    'ISCg5Nb2R1bGVfYXJjaGl2ZRACEg8KC01vZHVsZV9jYnRuEAM=');

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

@$core.Deprecated('Use topCardTypeDescriptor instead')
const TopCardType$json = {
  '1': 'TopCardType',
  '2': [
    {'1': 'UNSPECIFIED_TopCardType', '2': 0},
    {'1': 'LISTEN_HISTORY', '2': 1},
    {'1': 'FAVORITE_FOLDER', '2': 2},
    {'1': 'UP_RECALL', '2': 3},
    {'1': 'PICK_TODAY', '2': 4},
  ],
};

/// Descriptor for `TopCardType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List topCardTypeDescriptor = $convert.base64Decode(
    'CgtUb3BDYXJkVHlwZRIbChdVTlNQRUNJRklFRF9Ub3BDYXJkVHlwZRAAEhIKDkxJU1RFTl9ISV'
    'NUT1JZEAESEwoPRkFWT1JJVEVfRk9MREVSEAISDQoJVVBfUkVDQUxMEAMSDgoKUElDS19UT0RB'
    'WRAE');

@$core.Deprecated('Use authorDescriptor instead')
const Author$json = {
  '1': 'Author',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'avatar', '3': 3, '4': 1, '5': 9, '10': 'avatar'},
    {
      '1': 'relation',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.FollowRelation',
      '10': 'relation'
    },
  ],
};

/// Descriptor for `Author`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authorDescriptor = $convert.base64Decode(
    'CgZBdXRob3ISEAoDbWlkGAEgASgDUgNtaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIWCgZhdmF0YX'
    'IYAyABKAlSBmF2YXRhchJECghyZWxhdGlvbhgEIAEoCzIoLmJpbGliaWxpLmFwcC5saXN0ZW5l'
    'ci52MS5Gb2xsb3dSZWxhdGlvblIIcmVsYXRpb24=');

@$core.Deprecated('Use bKArcDetailsReqDescriptor instead')
const BKArcDetailsReq$json = {
  '1': 'BKArcDetailsReq',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'items'
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

/// Descriptor for `BKArcDetailsReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bKArcDetailsReqDescriptor = $convert.base64Decode(
    'Cg9CS0FyY0RldGFpbHNSZXESOAoFaXRlbXMYASADKAsyIi5iaWxpYmlsaS5hcHAubGlzdGVuZX'
    'IudjEuUGxheUl0ZW1SBWl0ZW1zEk8KC3BsYXllcl9hcmdzGAIgASgLMi4uYmlsaWJpbGkuYXBw'
    'LmFyY2hpdmUubWlkZGxld2FyZS52MS5QbGF5ZXJBcmdzUgpwbGF5ZXJBcmdz');

@$core.Deprecated('Use bKArcDetailsRespDescriptor instead')
const BKArcDetailsResp$json = {
  '1': 'BKArcDetailsResp',
  '2': [
    {
      '1': 'list',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.DetailItem',
      '10': 'list'
    },
  ],
};

/// Descriptor for `BKArcDetailsResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bKArcDetailsRespDescriptor = $convert.base64Decode(
    'ChBCS0FyY0RldGFpbHNSZXNwEjgKBGxpc3QYASADKAsyJC5iaWxpYmlsaS5hcHAubGlzdGVuZX'
    'IudjEuRGV0YWlsSXRlbVIEbGlzdA==');

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

@$core.Deprecated('Use bKArcRightsDescriptor instead')
const BKArcRights$json = {
  '1': 'BKArcRights',
  '2': [
    {'1': 'no_reprint', '3': 1, '4': 1, '5': 5, '10': 'noReprint'},
  ],
};

/// Descriptor for `BKArcRights`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bKArcRightsDescriptor = $convert.base64Decode(
    'CgtCS0FyY1JpZ2h0cxIdCgpub19yZXByaW50GAEgASgFUglub1JlcHJpbnQ=');

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
    {'1': 'rname', '3': 7, '4': 1, '5': 9, '10': 'rname'},
    {'1': 'publish', '3': 8, '4': 1, '5': 3, '10': 'publish'},
    {'1': 'displayed_oid', '3': 9, '4': 1, '5': 9, '10': 'displayedOid'},
    {'1': 'copyright', '3': 10, '4': 1, '5': 5, '10': 'copyright'},
    {
      '1': 'rights',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.BKArcRights',
      '10': 'rights'
    },
  ],
};

/// Descriptor for `BKArchive`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bKArchiveDescriptor = $convert.base64Decode(
    'CglCS0FyY2hpdmUSEAoDb2lkGAEgASgDUgNvaWQSFAoFdGl0bGUYAiABKAlSBXRpdGxlEhQKBW'
    'NvdmVyGAMgASgJUgVjb3ZlchISCgRkZXNjGAQgASgJUgRkZXNjEhoKCGR1cmF0aW9uGAUgASgD'
    'UghkdXJhdGlvbhIQCgNyaWQYBiABKAVSA3JpZBIUCgVybmFtZRgHIAEoCVIFcm5hbWUSGAoHcH'
    'VibGlzaBgIIAEoA1IHcHVibGlzaBIjCg1kaXNwbGF5ZWRfb2lkGAkgASgJUgxkaXNwbGF5ZWRP'
    'aWQSHAoJY29weXJpZ2h0GAogASgFUgljb3B5cmlnaHQSPQoGcmlnaHRzGAsgASgLMiUuYmlsaW'
    'JpbGkuYXBwLmxpc3RlbmVyLnYxLkJLQXJjUmlnaHRzUgZyaWdodHM=');

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
    {'1': 'use_view_vt', '3': 10, '4': 1, '5': 8, '10': 'useViewVt'},
    {'1': 'view_vt_text', '3': 11, '4': 1, '5': 9, '10': 'viewVtText'},
  ],
};

/// Descriptor for `BKStat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bKStatDescriptor = $convert.base64Decode(
    'CgZCS1N0YXQSEgoEbGlrZRgBIAEoBVIEbGlrZRISCgRjb2luGAIgASgFUgRjb2luEhwKCWZhdm'
    '91cml0ZRgDIAEoBVIJZmF2b3VyaXRlEhQKBXJlcGx5GAQgASgFUgVyZXBseRIUCgVzaGFyZRgF'
    'IAEoBVIFc2hhcmUSEgoEdmlldxgGIAEoBVIEdmlldxIZCghoYXNfbGlrZRgHIAEoCFIHaGFzTG'
    'lrZRIZCghoYXNfY29pbhgIIAEoCFIHaGFzQ29pbhIXCgdoYXNfZmF2GAkgASgIUgZoYXNGYXYS'
    'HgoLdXNlX3ZpZXdfdnQYCiABKAhSCXVzZVZpZXdWdBIgCgx2aWV3X3Z0X3RleHQYCyABKAlSCn'
    'ZpZXdWdFRleHQ=');

@$core.Deprecated('Use cardModuleDescriptor instead')
const CardModule$json = {
  '1': 'CardModule',
  '2': [
    {
      '1': 'module_header',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PkcmHeader',
      '9': 0,
      '10': 'moduleHeader'
    },
    {
      '1': 'module_archive',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PkcmArchive',
      '9': 0,
      '10': 'moduleArchive'
    },
    {
      '1': 'module_cbtn',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PkcmCenterButton',
      '9': 0,
      '10': 'moduleCbtn'
    },
    {
      '1': 'module_type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.listener.v1.CardModuleType',
      '10': 'moduleType'
    },
  ],
  '8': [
    {'1': 'module'},
  ],
};

/// Descriptor for `CardModule`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cardModuleDescriptor = $convert.base64Decode(
    'CgpDYXJkTW9kdWxlEksKDW1vZHVsZV9oZWFkZXIYAiABKAsyJC5iaWxpYmlsaS5hcHAubGlzdG'
    'VuZXIudjEuUGtjbUhlYWRlckgAUgxtb2R1bGVIZWFkZXISTgoObW9kdWxlX2FyY2hpdmUYAyAB'
    'KAsyJS5iaWxpYmlsaS5hcHAubGlzdGVuZXIudjEuUGtjbUFyY2hpdmVIAFINbW9kdWxlQXJjaG'
    'l2ZRJNCgttb2R1bGVfY2J0bhgEIAEoCzIqLmJpbGliaWxpLmFwcC5saXN0ZW5lci52MS5Qa2Nt'
    'Q2VudGVyQnV0dG9uSABSCm1vZHVsZUNidG4SSQoLbW9kdWxlX3R5cGUYASABKA4yKC5iaWxpYm'
    'lsaS5hcHAubGlzdGVuZXIudjEuQ2FyZE1vZHVsZVR5cGVSCm1vZHVsZVR5cGVCCAoGbW9kdWxl');

@$core.Deprecated('Use clickReqDescriptor instead')
const ClickReq$json = {
  '1': 'ClickReq',
  '2': [
    {'1': 'sid', '3': 1, '4': 1, '5': 3, '10': 'sid'},
    {
      '1': 'action',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.listener.v1.ClickReq.ClickAction',
      '10': 'action'
    },
  ],
  '4': [ClickReq_ClickAction$json],
};

@$core.Deprecated('Use clickReqDescriptor instead')
const ClickReq_ClickAction$json = {
  '1': 'ClickAction',
  '2': [
    {'1': 'INVALID', '2': 0},
    {'1': 'SHARE', '2': 1},
  ],
};

/// Descriptor for `ClickReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clickReqDescriptor = $convert.base64Decode(
    'CghDbGlja1JlcRIQCgNzaWQYASABKANSA3NpZBJGCgZhY3Rpb24YAiABKA4yLi5iaWxpYmlsaS'
    '5hcHAubGlzdGVuZXIudjEuQ2xpY2tSZXEuQ2xpY2tBY3Rpb25SBmFjdGlvbiIlCgtDbGlja0Fj'
    'dGlvbhILCgdJTlZBTElEEAASCQoFU0hBUkUQAQ==');

@$core.Deprecated('Use clickRespDescriptor instead')
const ClickResp$json = {
  '1': 'ClickResp',
};

/// Descriptor for `ClickResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clickRespDescriptor =
    $convert.base64Decode('CglDbGlja1Jlc3A=');

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
    {'1': 'bandwidth', '3': 4, '4': 1, '5': 5, '10': 'bandwidth'},
    {'1': 'mime_type', '3': 5, '4': 1, '5': 9, '10': 'mimeType'},
    {'1': 'codecs', '3': 6, '4': 1, '5': 9, '10': 'codecs'},
    {
      '1': 'segment_base',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.DashSegmentBase',
      '10': 'segmentBase'
    },
    {'1': 'codecid', '3': 13, '4': 1, '5': 5, '10': 'codecid'},
    {'1': 'md5', '3': 14, '4': 1, '5': 9, '10': 'md5'},
    {'1': 'size', '3': 15, '4': 1, '5': 3, '10': 'size'},
  ],
};

/// Descriptor for `DashItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dashItemDescriptor = $convert.base64Decode(
    'CghEYXNoSXRlbRIOCgJpZBgBIAEoBVICaWQSGQoIYmFzZV91cmwYAiABKAlSB2Jhc2VVcmwSHQ'
    'oKYmFja3VwX3VybBgDIAMoCVIJYmFja3VwVXJsEhwKCWJhbmR3aWR0aBgEIAEoBVIJYmFuZHdp'
    'ZHRoEhsKCW1pbWVfdHlwZRgFIAEoCVIIbWltZVR5cGUSFgoGY29kZWNzGAYgASgJUgZjb2RlY3'
    'MSTAoMc2VnbWVudF9iYXNlGAwgASgLMikuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLkRhc2hT'
    'ZWdtZW50QmFzZVILc2VnbWVudEJhc2USGAoHY29kZWNpZBgNIAEoBVIHY29kZWNpZBIQCgNtZD'
    'UYDiABKAlSA21kNRISCgRzaXplGA8gASgDUgRzaXpl');

@$core.Deprecated('Use dashSegmentBaseDescriptor instead')
const DashSegmentBase$json = {
  '1': 'DashSegmentBase',
  '2': [
    {'1': 'initialization', '3': 1, '4': 1, '5': 9, '10': 'initialization'},
    {'1': 'index_range', '3': 2, '4': 1, '5': 9, '10': 'indexRange'},
  ],
};

/// Descriptor for `DashSegmentBase`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dashSegmentBaseDescriptor = $convert.base64Decode(
    'Cg9EYXNoU2VnbWVudEJhc2USJgoOaW5pdGlhbGl6YXRpb24YASABKAlSDmluaXRpYWxpemF0aW'
    '9uEh8KC2luZGV4X3JhbmdlGAIgASgJUgppbmRleFJhbmdl');

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
    {'1': 'playable', '3': 8, '4': 1, '5': 5, '10': 'playable'},
    {'1': 'message', '3': 9, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'player_info',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.DetailItem.PlayerInfoEntry',
      '10': 'playerInfo'
    },
    {
      '1': 'associated_item',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'associatedItem'
    },
    {'1': 'last_play_time', '3': 12, '4': 1, '5': 3, '10': 'lastPlayTime'},
    {'1': 'history_tag', '3': 13, '4': 1, '5': 9, '10': 'historyTag'},
    {
      '1': 'device_type',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.DeviceType',
      '10': 'deviceType'
    },
    {
      '1': 'ugc_season_info',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.FavFolder',
      '10': 'ugcSeasonInfo'
    },
  ],
  '3': [DetailItem_PlayerInfoEntry$json],
};

@$core.Deprecated('Use detailItemDescriptor instead')
const DetailItem_PlayerInfoEntry$json = {
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

/// Descriptor for `DetailItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List detailItemDescriptor = $convert.base64Decode(
    'CgpEZXRhaWxJdGVtEjYKBGl0ZW0YASABKAsyIi5iaWxpYmlsaS5hcHAubGlzdGVuZXIudjEuUG'
    'xheUl0ZW1SBGl0ZW0SNQoDYXJjGAIgASgLMiMuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLkJL'
    'QXJjaGl2ZVIDYXJjEjkKBXBhcnRzGAMgAygLMiMuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLk'
    'JLQXJjUGFydFIFcGFydHMSNgoFb3duZXIYBCABKAsyIC5iaWxpYmlsaS5hcHAubGlzdGVuZXIu'
    'djEuQXV0aG9yUgVvd25lchI0CgRzdGF0GAUgASgLMiAuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLn'
    'YxLkJLU3RhdFIEc3RhdBIbCglsYXN0X3BhcnQYBiABKANSCGxhc3RQYXJ0EhoKCHByb2dyZXNz'
    'GAcgASgDUghwcm9ncmVzcxIaCghwbGF5YWJsZRgIIAEoBVIIcGxheWFibGUSGAoHbWVzc2FnZR'
    'gJIAEoCVIHbWVzc2FnZRJVCgtwbGF5ZXJfaW5mbxgKIAMoCzI0LmJpbGliaWxpLmFwcC5saXN0'
    'ZW5lci52MS5EZXRhaWxJdGVtLlBsYXllckluZm9FbnRyeVIKcGxheWVySW5mbxJLCg9hc3NvY2'
    'lhdGVkX2l0ZW0YCyABKAsyIi5iaWxpYmlsaS5hcHAubGlzdGVuZXIudjEuUGxheUl0ZW1SDmFz'
    'c29jaWF0ZWRJdGVtEiQKDmxhc3RfcGxheV90aW1lGAwgASgDUgxsYXN0UGxheVRpbWUSHwoLaG'
    'lzdG9yeV90YWcYDSABKAlSCmhpc3RvcnlUYWcSRwoLZGV2aWNlX3R5cGUYDiABKAsyJi5iaWxp'
    'YmlsaS5hcHAuaW50ZXJmYWNlcy52MS5EZXZpY2VUeXBlUgpkZXZpY2VUeXBlEksKD3VnY19zZW'
    'Fzb25faW5mbxgPIAEoCzIjLmJpbGliaWxpLmFwcC5saXN0ZW5lci52MS5GYXZGb2xkZXJSDXVn'
    'Y1NlYXNvbkluZm8aYQoPUGxheWVySW5mb0VudHJ5EhAKA2tleRgBIAEoA1IDa2V5EjgKBXZhbH'
    'VlGAIgASgLMiIuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLlBsYXlJbmZvUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use eventReqDescriptor instead')
const EventReq$json = {
  '1': 'EventReq',
  '2': [
    {
      '1': 'event_type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.listener.v1.EventReq.EventType',
      '10': 'eventType'
    },
    {
      '1': 'item',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'item'
    },
  ],
  '4': [EventReq_EventType$json],
};

@$core.Deprecated('Use eventReqDescriptor instead')
const EventReq_EventType$json = {
  '1': 'EventType',
  '2': [
    {'1': 'INVALID_EventType', '2': 0},
    {'1': 'GUIDE_BAR_SHOW', '2': 1},
  ],
};

/// Descriptor for `EventReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventReqDescriptor = $convert.base64Decode(
    'CghFdmVudFJlcRJLCgpldmVudF90eXBlGAEgASgOMiwuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLn'
    'YxLkV2ZW50UmVxLkV2ZW50VHlwZVIJZXZlbnRUeXBlEjYKBGl0ZW0YAiABKAsyIi5iaWxpYmls'
    'aS5hcHAubGlzdGVuZXIudjEuUGxheUl0ZW1SBGl0ZW0iNgoJRXZlbnRUeXBlEhUKEUlOVkFMSU'
    'RfRXZlbnRUeXBlEAASEgoOR1VJREVfQkFSX1NIT1cQAQ==');

@$core.Deprecated('Use eventRespDescriptor instead')
const EventResp$json = {
  '1': 'EventResp',
};

/// Descriptor for `EventResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventRespDescriptor =
    $convert.base64Decode('CglFdmVudFJlc3A=');

@$core.Deprecated('Use eventTrackingDescriptor instead')
const EventTracking$json = {
  '1': 'EventTracking',
  '2': [
    {'1': 'operator', '3': 1, '4': 1, '5': 9, '10': 'operator'},
    {'1': 'batch', '3': 2, '4': 1, '5': 9, '10': 'batch'},
    {'1': 'track_id', '3': 3, '4': 1, '5': 9, '10': 'trackId'},
    {'1': 'entity_type', '3': 4, '4': 1, '5': 9, '10': 'entityType'},
    {'1': 'entity_id', '3': 5, '4': 1, '5': 9, '10': 'entityId'},
    {'1': 'track_json', '3': 6, '4': 1, '5': 9, '10': 'trackJson'},
  ],
};

/// Descriptor for `EventTracking`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventTrackingDescriptor = $convert.base64Decode(
    'Cg1FdmVudFRyYWNraW5nEhoKCG9wZXJhdG9yGAEgASgJUghvcGVyYXRvchIUCgViYXRjaBgCIA'
    'EoCVIFYmF0Y2gSGQoIdHJhY2tfaWQYAyABKAlSB3RyYWNrSWQSHwoLZW50aXR5X3R5cGUYBCAB'
    'KAlSCmVudGl0eVR5cGUSGwoJZW50aXR5X2lkGAUgASgJUghlbnRpdHlJZBIdCgp0cmFja19qc2'
    '9uGAYgASgJUgl0cmFja0pzb24=');

@$core.Deprecated('Use favFolderDescriptor instead')
const FavFolder$json = {
  '1': 'FavFolder',
  '2': [
    {'1': 'fid', '3': 1, '4': 1, '5': 3, '10': 'fid'},
    {'1': 'folder_type', '3': 2, '4': 1, '5': 5, '10': 'folderType'},
    {
      '1': 'owner',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.FavFolderAuthor',
      '10': 'owner'
    },
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'cover', '3': 5, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'desc', '3': 6, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'count', '3': 7, '4': 1, '5': 5, '10': 'count'},
    {'1': 'attr', '3': 8, '4': 1, '5': 5, '10': 'attr'},
    {'1': 'state', '3': 9, '4': 1, '5': 5, '10': 'state'},
    {'1': 'favored', '3': 10, '4': 1, '5': 5, '10': 'favored'},
    {'1': 'ctime', '3': 11, '4': 1, '5': 3, '10': 'ctime'},
    {'1': 'mtime', '3': 12, '4': 1, '5': 3, '10': 'mtime'},
    {'1': 'stat_fav_cnt', '3': 13, '4': 1, '5': 5, '10': 'statFavCnt'},
    {'1': 'stat_share_cnt', '3': 14, '4': 1, '5': 5, '10': 'statShareCnt'},
    {'1': 'stat_like_cnt', '3': 15, '4': 1, '5': 5, '10': 'statLikeCnt'},
    {'1': 'stat_play_cnt', '3': 16, '4': 1, '5': 5, '10': 'statPlayCnt'},
    {'1': 'stat_reply_cnt', '3': 17, '4': 1, '5': 5, '10': 'statReplyCnt'},
    {'1': 'fav_state', '3': 18, '4': 1, '5': 5, '10': 'favState'},
    {'1': 'use_view_vt', '3': 19, '4': 1, '5': 8, '10': 'useViewVt'},
    {'1': 'view_vt_text', '3': 20, '4': 1, '5': 9, '10': 'viewVtText'},
  ],
};

/// Descriptor for `FavFolder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favFolderDescriptor = $convert.base64Decode(
    'CglGYXZGb2xkZXISEAoDZmlkGAEgASgDUgNmaWQSHwoLZm9sZGVyX3R5cGUYAiABKAVSCmZvbG'
    'RlclR5cGUSPwoFb3duZXIYAyABKAsyKS5iaWxpYmlsaS5hcHAubGlzdGVuZXIudjEuRmF2Rm9s'
    'ZGVyQXV0aG9yUgVvd25lchISCgRuYW1lGAQgASgJUgRuYW1lEhQKBWNvdmVyGAUgASgJUgVjb3'
    'ZlchISCgRkZXNjGAYgASgJUgRkZXNjEhQKBWNvdW50GAcgASgFUgVjb3VudBISCgRhdHRyGAgg'
    'ASgFUgRhdHRyEhQKBXN0YXRlGAkgASgFUgVzdGF0ZRIYCgdmYXZvcmVkGAogASgFUgdmYXZvcm'
    'VkEhQKBWN0aW1lGAsgASgDUgVjdGltZRIUCgVtdGltZRgMIAEoA1IFbXRpbWUSIAoMc3RhdF9m'
    'YXZfY250GA0gASgFUgpzdGF0RmF2Q250EiQKDnN0YXRfc2hhcmVfY250GA4gASgFUgxzdGF0U2'
    'hhcmVDbnQSIgoNc3RhdF9saWtlX2NudBgPIAEoBVILc3RhdExpa2VDbnQSIgoNc3RhdF9wbGF5'
    'X2NudBgQIAEoBVILc3RhdFBsYXlDbnQSJAoOc3RhdF9yZXBseV9jbnQYESABKAVSDHN0YXRSZX'
    'BseUNudBIbCglmYXZfc3RhdGUYEiABKAVSCGZhdlN0YXRlEh4KC3VzZV92aWV3X3Z0GBMgASgI'
    'Ugl1c2VWaWV3VnQSIAoMdmlld192dF90ZXh0GBQgASgJUgp2aWV3VnRUZXh0');

@$core.Deprecated('Use favFolderActionDescriptor instead')
const FavFolderAction$json = {
  '1': 'FavFolderAction',
  '2': [
    {'1': 'fid', '3': 1, '4': 1, '5': 3, '10': 'fid'},
    {'1': 'folder_type', '3': 2, '4': 1, '5': 5, '10': 'folderType'},
    {
      '1': 'action',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.listener.v1.FavFolderAction.Action',
      '10': 'action'
    },
  ],
  '4': [FavFolderAction_Action$json],
};

@$core.Deprecated('Use favFolderActionDescriptor instead')
const FavFolderAction_Action$json = {
  '1': 'Action',
  '2': [
    {'1': 'UNSPECIFIED', '2': 0},
    {'1': 'ADD', '2': 1},
    {'1': 'DEL', '2': 2},
  ],
};

/// Descriptor for `FavFolderAction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favFolderActionDescriptor = $convert.base64Decode(
    'Cg9GYXZGb2xkZXJBY3Rpb24SEAoDZmlkGAEgASgDUgNmaWQSHwoLZm9sZGVyX3R5cGUYAiABKA'
    'VSCmZvbGRlclR5cGUSSAoGYWN0aW9uGAMgASgOMjAuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYx'
    'LkZhdkZvbGRlckFjdGlvbi5BY3Rpb25SBmFjdGlvbiIrCgZBY3Rpb24SDwoLVU5TUEVDSUZJRU'
    'QQABIHCgNBREQQARIHCgNERUwQAg==');

@$core.Deprecated('Use favFolderAuthorDescriptor instead')
const FavFolderAuthor$json = {
  '1': 'FavFolderAuthor',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `FavFolderAuthor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favFolderAuthorDescriptor = $convert.base64Decode(
    'Cg9GYXZGb2xkZXJBdXRob3ISEAoDbWlkGAEgASgDUgNtaWQSEgoEbmFtZRgCIAEoCVIEbmFtZQ'
    '==');

@$core.Deprecated('Use favFolderCreateReqDescriptor instead')
const FavFolderCreateReq$json = {
  '1': 'FavFolderCreateReq',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'desc', '3': 2, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'public', '3': 3, '4': 1, '5': 5, '10': 'public'},
    {'1': 'folder_type', '3': 4, '4': 1, '5': 5, '10': 'folderType'},
  ],
};

/// Descriptor for `FavFolderCreateReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favFolderCreateReqDescriptor = $convert.base64Decode(
    'ChJGYXZGb2xkZXJDcmVhdGVSZXESEgoEbmFtZRgBIAEoCVIEbmFtZRISCgRkZXNjGAIgASgJUg'
    'RkZXNjEhYKBnB1YmxpYxgDIAEoBVIGcHVibGljEh8KC2ZvbGRlcl90eXBlGAQgASgFUgpmb2xk'
    'ZXJUeXBl');

@$core.Deprecated('Use favFolderCreateRespDescriptor instead')
const FavFolderCreateResp$json = {
  '1': 'FavFolderCreateResp',
  '2': [
    {'1': 'fid', '3': 1, '4': 1, '5': 3, '10': 'fid'},
    {'1': 'folder_type', '3': 2, '4': 1, '5': 5, '10': 'folderType'},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `FavFolderCreateResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favFolderCreateRespDescriptor = $convert.base64Decode(
    'ChNGYXZGb2xkZXJDcmVhdGVSZXNwEhAKA2ZpZBgBIAEoA1IDZmlkEh8KC2ZvbGRlcl90eXBlGA'
    'IgASgFUgpmb2xkZXJUeXBlEhgKB21lc3NhZ2UYAyABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use favFolderDeleteReqDescriptor instead')
const FavFolderDeleteReq$json = {
  '1': 'FavFolderDeleteReq',
  '2': [
    {'1': 'fid', '3': 1, '4': 1, '5': 3, '10': 'fid'},
    {'1': 'folder_type', '3': 2, '4': 1, '5': 5, '10': 'folderType'},
  ],
};

/// Descriptor for `FavFolderDeleteReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favFolderDeleteReqDescriptor = $convert.base64Decode(
    'ChJGYXZGb2xkZXJEZWxldGVSZXESEAoDZmlkGAEgASgDUgNmaWQSHwoLZm9sZGVyX3R5cGUYAi'
    'ABKAVSCmZvbGRlclR5cGU=');

@$core.Deprecated('Use favFolderDeleteRespDescriptor instead')
const FavFolderDeleteResp$json = {
  '1': 'FavFolderDeleteResp',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `FavFolderDeleteResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favFolderDeleteRespDescriptor =
    $convert.base64Decode(
        'ChNGYXZGb2xkZXJEZWxldGVSZXNwEhgKB21lc3NhZ2UYASABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use favFolderDetailReqDescriptor instead')
const FavFolderDetailReq$json = {
  '1': 'FavFolderDetailReq',
  '2': [
    {'1': 'fid', '3': 1, '4': 1, '5': 3, '10': 'fid'},
    {'1': 'folder_type', '3': 2, '4': 1, '5': 5, '10': 'folderType'},
    {'1': 'fav_mid', '3': 3, '4': 1, '5': 3, '10': 'favMid'},
    {
      '1': 'last_item',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.FavItem',
      '10': 'lastItem'
    },
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'need_folder_info', '3': 6, '4': 1, '5': 8, '10': 'needFolderInfo'},
  ],
};

/// Descriptor for `FavFolderDetailReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favFolderDetailReqDescriptor = $convert.base64Decode(
    'ChJGYXZGb2xkZXJEZXRhaWxSZXESEAoDZmlkGAEgASgDUgNmaWQSHwoLZm9sZGVyX3R5cGUYAi'
    'ABKAVSCmZvbGRlclR5cGUSFwoHZmF2X21pZBgDIAEoA1IGZmF2TWlkEj4KCWxhc3RfaXRlbRgE'
    'IAEoCzIhLmJpbGliaWxpLmFwcC5saXN0ZW5lci52MS5GYXZJdGVtUghsYXN0SXRlbRIbCglwYW'
    'dlX3NpemUYBSABKAVSCHBhZ2VTaXplEigKEG5lZWRfZm9sZGVyX2luZm8YBiABKAhSDm5lZWRG'
    'b2xkZXJJbmZv');

@$core.Deprecated('Use favFolderDetailRespDescriptor instead')
const FavFolderDetailResp$json = {
  '1': 'FavFolderDetailResp',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 5, '10': 'total'},
    {'1': 'reach_end', '3': 2, '4': 1, '5': 8, '10': 'reachEnd'},
    {
      '1': 'list',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.FavItemDetail',
      '10': 'list'
    },
    {
      '1': 'folder_info',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.FavFolder',
      '10': 'folderInfo'
    },
  ],
};

/// Descriptor for `FavFolderDetailResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favFolderDetailRespDescriptor = $convert.base64Decode(
    'ChNGYXZGb2xkZXJEZXRhaWxSZXNwEhQKBXRvdGFsGAEgASgFUgV0b3RhbBIbCglyZWFjaF9lbm'
    'QYAiABKAhSCHJlYWNoRW5kEjsKBGxpc3QYAyADKAsyJy5iaWxpYmlsaS5hcHAubGlzdGVuZXIu'
    'djEuRmF2SXRlbURldGFpbFIEbGlzdBJECgtmb2xkZXJfaW5mbxgEIAEoCzIjLmJpbGliaWxpLm'
    'FwcC5saXN0ZW5lci52MS5GYXZGb2xkZXJSCmZvbGRlckluZm8=');

@$core.Deprecated('Use favFolderListReqDescriptor instead')
const FavFolderListReq$json = {
  '1': 'FavFolderListReq',
  '2': [
    {'1': 'folder_types', '3': 1, '4': 3, '5': 5, '10': 'folderTypes'},
    {
      '1': 'item',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `FavFolderListReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favFolderListReqDescriptor = $convert.base64Decode(
    'ChBGYXZGb2xkZXJMaXN0UmVxEiEKDGZvbGRlcl90eXBlcxgBIAMoBVILZm9sZGVyVHlwZXMSNg'
    'oEaXRlbRgCIAEoCzIiLmJpbGliaWxpLmFwcC5saXN0ZW5lci52MS5QbGF5SXRlbVIEaXRlbQ==');

@$core.Deprecated('Use favFolderListRespDescriptor instead')
const FavFolderListResp$json = {
  '1': 'FavFolderListResp',
  '2': [
    {
      '1': 'list',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.FavFolder',
      '10': 'list'
    },
  ],
};

/// Descriptor for `FavFolderListResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favFolderListRespDescriptor = $convert.base64Decode(
    'ChFGYXZGb2xkZXJMaXN0UmVzcBI3CgRsaXN0GAEgAygLMiMuYmlsaWJpbGkuYXBwLmxpc3Rlbm'
    'VyLnYxLkZhdkZvbGRlclIEbGlzdA==');

@$core.Deprecated('Use favFolderMetaDescriptor instead')
const FavFolderMeta$json = {
  '1': 'FavFolderMeta',
  '2': [
    {'1': 'fid', '3': 1, '4': 1, '5': 3, '10': 'fid'},
    {'1': 'folder_type', '3': 2, '4': 1, '5': 5, '10': 'folderType'},
  ],
};

/// Descriptor for `FavFolderMeta`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favFolderMetaDescriptor = $convert.base64Decode(
    'Cg1GYXZGb2xkZXJNZXRhEhAKA2ZpZBgBIAEoA1IDZmlkEh8KC2ZvbGRlcl90eXBlGAIgASgFUg'
    'pmb2xkZXJUeXBl');

@$core.Deprecated('Use favItemDescriptor instead')
const FavItem$json = {
  '1': 'FavItem',
  '2': [
    {'1': 'item_type', '3': 1, '4': 1, '5': 5, '10': 'itemType'},
    {'1': 'oid', '3': 2, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'fid', '3': 3, '4': 1, '5': 3, '10': 'fid'},
    {'1': 'mid', '3': 4, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'mtime', '3': 5, '4': 1, '5': 3, '10': 'mtime'},
    {'1': 'ctime', '3': 6, '4': 1, '5': 3, '10': 'ctime'},
    {
      '1': 'et',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.EventTracking',
      '10': 'et'
    },
  ],
};

/// Descriptor for `FavItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favItemDescriptor = $convert.base64Decode(
    'CgdGYXZJdGVtEhsKCWl0ZW1fdHlwZRgBIAEoBVIIaXRlbVR5cGUSEAoDb2lkGAIgASgDUgNvaW'
    'QSEAoDZmlkGAMgASgDUgNmaWQSEAoDbWlkGAQgASgDUgNtaWQSFAoFbXRpbWUYBSABKANSBW10'
    'aW1lEhQKBWN0aW1lGAYgASgDUgVjdGltZRI3CgJldBgHIAEoCzInLmJpbGliaWxpLmFwcC5saX'
    'N0ZW5lci52MS5FdmVudFRyYWNraW5nUgJldA==');

@$core.Deprecated('Use favItemAddReqDescriptor instead')
const FavItemAddReq$json = {
  '1': 'FavItemAddReq',
  '2': [
    {
      '1': 'play',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '9': 0,
      '10': 'play'
    },
    {
      '1': 'fav',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.FavItem',
      '9': 0,
      '10': 'fav'
    },
    {'1': 'fid', '3': 1, '4': 1, '5': 3, '10': 'fid'},
    {'1': 'folder_type', '3': 2, '4': 1, '5': 5, '10': 'folderType'},
    {'1': 'is_fast_add_fav', '3': 5, '4': 1, '5': 8, '10': 'isFastAddFav'},
  ],
  '8': [
    {'1': 'item'},
  ],
};

/// Descriptor for `FavItemAddReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favItemAddReqDescriptor = $convert.base64Decode(
    'Cg1GYXZJdGVtQWRkUmVxEjgKBHBsYXkYAyABKAsyIi5iaWxpYmlsaS5hcHAubGlzdGVuZXIudj'
    'EuUGxheUl0ZW1IAFIEcGxheRI1CgNmYXYYBCABKAsyIS5iaWxpYmlsaS5hcHAubGlzdGVuZXIu'
    'djEuRmF2SXRlbUgAUgNmYXYSEAoDZmlkGAEgASgDUgNmaWQSHwoLZm9sZGVyX3R5cGUYAiABKA'
    'VSCmZvbGRlclR5cGUSJQoPaXNfZmFzdF9hZGRfZmF2GAUgASgIUgxpc0Zhc3RBZGRGYXZCBgoE'
    'aXRlbQ==');

@$core.Deprecated('Use favItemAddRespDescriptor instead')
const FavItemAddResp$json = {
  '1': 'FavItemAddResp',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `FavItemAddResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favItemAddRespDescriptor = $convert
    .base64Decode('Cg5GYXZJdGVtQWRkUmVzcBIYCgdtZXNzYWdlGAEgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use favItemAuthorDescriptor instead')
const FavItemAuthor$json = {
  '1': 'FavItemAuthor',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `FavItemAuthor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favItemAuthorDescriptor = $convert.base64Decode(
    'Cg1GYXZJdGVtQXV0aG9yEhAKA21pZBgBIAEoA1IDbWlkEhIKBG5hbWUYAiABKAlSBG5hbWU=');

@$core.Deprecated('Use favItemBatchReqDescriptor instead')
const FavItemBatchReq$json = {
  '1': 'FavItemBatchReq',
  '2': [
    {
      '1': 'play',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '9': 0,
      '10': 'play'
    },
    {
      '1': 'fav',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.FavItem',
      '9': 0,
      '10': 'fav'
    },
    {
      '1': 'actions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.FavFolderAction',
      '10': 'actions'
    },
  ],
  '8': [
    {'1': 'item'},
  ],
};

/// Descriptor for `FavItemBatchReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favItemBatchReqDescriptor = $convert.base64Decode(
    'Cg9GYXZJdGVtQmF0Y2hSZXESOAoEcGxheRgCIAEoCzIiLmJpbGliaWxpLmFwcC5saXN0ZW5lci'
    '52MS5QbGF5SXRlbUgAUgRwbGF5EjUKA2ZhdhgDIAEoCzIhLmJpbGliaWxpLmFwcC5saXN0ZW5l'
    'ci52MS5GYXZJdGVtSABSA2ZhdhJDCgdhY3Rpb25zGAEgAygLMikuYmlsaWJpbGkuYXBwLmxpc3'
    'RlbmVyLnYxLkZhdkZvbGRlckFjdGlvblIHYWN0aW9uc0IGCgRpdGVt');

@$core.Deprecated('Use favItemBatchRespDescriptor instead')
const FavItemBatchResp$json = {
  '1': 'FavItemBatchResp',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `FavItemBatchResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favItemBatchRespDescriptor = $convert.base64Decode(
    'ChBGYXZJdGVtQmF0Y2hSZXNwEhgKB21lc3NhZ2UYASABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use favItemDelReqDescriptor instead')
const FavItemDelReq$json = {
  '1': 'FavItemDelReq',
  '2': [
    {
      '1': 'play',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '9': 0,
      '10': 'play'
    },
    {
      '1': 'fav',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.FavItem',
      '9': 0,
      '10': 'fav'
    },
    {'1': 'fid', '3': 1, '4': 1, '5': 3, '10': 'fid'},
    {'1': 'folder_type', '3': 2, '4': 1, '5': 5, '10': 'folderType'},
    {'1': 'is_fast_del_fav', '3': 5, '4': 1, '5': 8, '10': 'isFastDelFav'},
  ],
  '8': [
    {'1': 'item'},
  ],
};

/// Descriptor for `FavItemDelReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favItemDelReqDescriptor = $convert.base64Decode(
    'Cg1GYXZJdGVtRGVsUmVxEjgKBHBsYXkYAyABKAsyIi5iaWxpYmlsaS5hcHAubGlzdGVuZXIudj'
    'EuUGxheUl0ZW1IAFIEcGxheRI1CgNmYXYYBCABKAsyIS5iaWxpYmlsaS5hcHAubGlzdGVuZXIu'
    'djEuRmF2SXRlbUgAUgNmYXYSEAoDZmlkGAEgASgDUgNmaWQSHwoLZm9sZGVyX3R5cGUYAiABKA'
    'VSCmZvbGRlclR5cGUSJQoPaXNfZmFzdF9kZWxfZmF2GAUgASgIUgxpc0Zhc3REZWxGYXZCBgoE'
    'aXRlbQ==');

@$core.Deprecated('Use favItemDelRespDescriptor instead')
const FavItemDelResp$json = {
  '1': 'FavItemDelResp',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `FavItemDelResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favItemDelRespDescriptor = $convert
    .base64Decode('Cg5GYXZJdGVtRGVsUmVzcBIYCgdtZXNzYWdlGAEgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use favItemDetailDescriptor instead')
const FavItemDetail$json = {
  '1': 'FavItemDetail',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.FavItem',
      '10': 'item'
    },
    {
      '1': 'owner',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.FavItemAuthor',
      '10': 'owner'
    },
    {
      '1': 'stat',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.FavItemStat',
      '10': 'stat'
    },
    {'1': 'cover', '3': 4, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'name', '3': 5, '4': 1, '5': 9, '10': 'name'},
    {'1': 'duration', '3': 6, '4': 1, '5': 3, '10': 'duration'},
    {'1': 'state', '3': 7, '4': 1, '5': 5, '10': 'state'},
    {'1': 'message', '3': 8, '4': 1, '5': 9, '10': 'message'},
    {'1': 'parts', '3': 9, '4': 1, '5': 5, '10': 'parts'},
  ],
};

/// Descriptor for `FavItemDetail`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favItemDetailDescriptor = $convert.base64Decode(
    'Cg1GYXZJdGVtRGV0YWlsEjUKBGl0ZW0YASABKAsyIS5iaWxpYmlsaS5hcHAubGlzdGVuZXIudj'
    'EuRmF2SXRlbVIEaXRlbRI9CgVvd25lchgCIAEoCzInLmJpbGliaWxpLmFwcC5saXN0ZW5lci52'
    'MS5GYXZJdGVtQXV0aG9yUgVvd25lchI5CgRzdGF0GAMgASgLMiUuYmlsaWJpbGkuYXBwLmxpc3'
    'RlbmVyLnYxLkZhdkl0ZW1TdGF0UgRzdGF0EhQKBWNvdmVyGAQgASgJUgVjb3ZlchISCgRuYW1l'
    'GAUgASgJUgRuYW1lEhoKCGR1cmF0aW9uGAYgASgDUghkdXJhdGlvbhIUCgVzdGF0ZRgHIAEoBV'
    'IFc3RhdGUSGAoHbWVzc2FnZRgIIAEoCVIHbWVzc2FnZRIUCgVwYXJ0cxgJIAEoBVIFcGFydHM=');

@$core.Deprecated('Use favItemStatDescriptor instead')
const FavItemStat$json = {
  '1': 'FavItemStat',
  '2': [
    {'1': 'view', '3': 1, '4': 1, '5': 5, '10': 'view'},
    {'1': 'reply', '3': 2, '4': 1, '5': 5, '10': 'reply'},
    {'1': 'use_view_vt', '3': 3, '4': 1, '5': 8, '10': 'useViewVt'},
    {'1': 'view_vt_text', '3': 4, '4': 1, '5': 9, '10': 'viewVtText'},
  ],
};

/// Descriptor for `FavItemStat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favItemStatDescriptor = $convert.base64Decode(
    'CgtGYXZJdGVtU3RhdBISCgR2aWV3GAEgASgFUgR2aWV3EhQKBXJlcGx5GAIgASgFUgVyZXBseR'
    'IeCgt1c2Vfdmlld192dBgDIAEoCFIJdXNlVmlld1Z0EiAKDHZpZXdfdnRfdGV4dBgEIAEoCVIK'
    'dmlld1Z0VGV4dA==');

@$core.Deprecated('Use favTabShowReqDescriptor instead')
const FavTabShowReq$json = {
  '1': 'FavTabShowReq',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 3, '10': 'mid'},
  ],
};

/// Descriptor for `FavTabShowReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favTabShowReqDescriptor =
    $convert.base64Decode('Cg1GYXZUYWJTaG93UmVxEhAKA21pZBgBIAEoA1IDbWlk');

@$core.Deprecated('Use favTabShowRespDescriptor instead')
const FavTabShowResp$json = {
  '1': 'FavTabShowResp',
  '2': [
    {'1': 'show_menu', '3': 1, '4': 1, '5': 8, '10': 'showMenu'},
  ],
};

/// Descriptor for `FavTabShowResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favTabShowRespDescriptor = $convert.base64Decode(
    'Cg5GYXZUYWJTaG93UmVzcBIbCglzaG93X21lbnUYASABKAhSCHNob3dNZW51');

@$core.Deprecated('Use favoredInAnyFoldersReqDescriptor instead')
const FavoredInAnyFoldersReq$json = {
  '1': 'FavoredInAnyFoldersReq',
  '2': [
    {'1': 'folder_types', '3': 1, '4': 3, '5': 5, '10': 'folderTypes'},
    {
      '1': 'item',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `FavoredInAnyFoldersReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favoredInAnyFoldersReqDescriptor = $convert.base64Decode(
    'ChZGYXZvcmVkSW5BbnlGb2xkZXJzUmVxEiEKDGZvbGRlcl90eXBlcxgBIAMoBVILZm9sZGVyVH'
    'lwZXMSNgoEaXRlbRgCIAEoCzIiLmJpbGliaWxpLmFwcC5saXN0ZW5lci52MS5QbGF5SXRlbVIE'
    'aXRlbQ==');

@$core.Deprecated('Use favoredInAnyFoldersRespDescriptor instead')
const FavoredInAnyFoldersResp$json = {
  '1': 'FavoredInAnyFoldersResp',
  '2': [
    {
      '1': 'folders',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.FavFolderMeta',
      '10': 'folders'
    },
    {
      '1': 'item',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `FavoredInAnyFoldersResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favoredInAnyFoldersRespDescriptor = $convert.base64Decode(
    'ChdGYXZvcmVkSW5BbnlGb2xkZXJzUmVzcBJBCgdmb2xkZXJzGAEgAygLMicuYmlsaWJpbGkuYX'
    'BwLmxpc3RlbmVyLnYxLkZhdkZvbGRlck1ldGFSB2ZvbGRlcnMSNgoEaXRlbRgCIAEoCzIiLmJp'
    'bGliaWxpLmFwcC5saXN0ZW5lci52MS5QbGF5SXRlbVIEaXRlbQ==');

@$core.Deprecated('Use followRelationDescriptor instead')
const FollowRelation$json = {
  '1': 'FollowRelation',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.listener.v1.FollowRelation.RelationStatus',
      '10': 'status'
    },
  ],
  '4': [FollowRelation_RelationStatus$json],
};

@$core.Deprecated('Use followRelationDescriptor instead')
const FollowRelation_RelationStatus$json = {
  '1': 'RelationStatus',
  '2': [
    {'1': 'UNSPECIFIED_RelationStatus', '2': 0},
    {'1': 'NO_FOLLOW', '2': 1},
    {'1': 'FOLLOWING', '2': 2},
    {'1': 'FOLLOWED', '2': 3},
    {'1': 'MUTUAL_FOLLOWING', '2': 4},
    {'1': 'SPECIAL_FOLLOWING', '2': 5},
  ],
};

/// Descriptor for `FollowRelation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List followRelationDescriptor = $convert.base64Decode(
    'Cg5Gb2xsb3dSZWxhdGlvbhJPCgZzdGF0dXMYASABKA4yNy5iaWxpYmlsaS5hcHAubGlzdGVuZX'
    'IudjEuRm9sbG93UmVsYXRpb24uUmVsYXRpb25TdGF0dXNSBnN0YXR1cyKJAQoOUmVsYXRpb25T'
    'dGF0dXMSHgoaVU5TUEVDSUZJRURfUmVsYXRpb25TdGF0dXMQABINCglOT19GT0xMT1cQARINCg'
    'lGT0xMT1dJTkcQAhIMCghGT0xMT1dFRBADEhQKEE1VVFVBTF9GT0xMT1dJTkcQBBIVChFTUEVD'
    'SUFMX0ZPTExPV0lORxAF');

@$core.Deprecated('Use formatDescriptionDescriptor instead')
const FormatDescription$json = {
  '1': 'FormatDescription',
  '2': [
    {'1': 'quality', '3': 1, '4': 1, '5': 5, '10': 'quality'},
    {'1': 'format', '3': 2, '4': 1, '5': 9, '10': 'format'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'display_desc', '3': 4, '4': 1, '5': 9, '10': 'displayDesc'},
    {'1': 'superscript', '3': 5, '4': 1, '5': 9, '10': 'superscript'},
  ],
};

/// Descriptor for `FormatDescription`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List formatDescriptionDescriptor = $convert.base64Decode(
    'ChFGb3JtYXREZXNjcmlwdGlvbhIYCgdxdWFsaXR5GAEgASgFUgdxdWFsaXR5EhYKBmZvcm1hdB'
    'gCIAEoCVIGZm9ybWF0EiAKC2Rlc2NyaXB0aW9uGAMgASgJUgtkZXNjcmlwdGlvbhIhCgxkaXNw'
    'bGF5X2Rlc2MYBCABKAlSC2Rpc3BsYXlEZXNjEiAKC3N1cGVyc2NyaXB0GAUgASgJUgtzdXBlcn'
    'NjcmlwdA==');

@$core.Deprecated('Use mainFavMusicMenuListReqDescriptor instead')
const MainFavMusicMenuListReq$json = {
  '1': 'MainFavMusicMenuListReq',
  '2': [
    {'1': 'tab_type', '3': 1, '4': 1, '5': 5, '10': 'tabType'},
    {'1': 'offset', '3': 2, '4': 1, '5': 9, '10': 'offset'},
  ],
};

/// Descriptor for `MainFavMusicMenuListReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mainFavMusicMenuListReqDescriptor =
    $convert.base64Decode(
        'ChdNYWluRmF2TXVzaWNNZW51TGlzdFJlcRIZCgh0YWJfdHlwZRgBIAEoBVIHdGFiVHlwZRIWCg'
        'ZvZmZzZXQYAiABKAlSBm9mZnNldA==');

@$core.Deprecated('Use mainFavMusicMenuListRespDescriptor instead')
const MainFavMusicMenuListResp$json = {
  '1': 'MainFavMusicMenuListResp',
  '2': [
    {'1': 'tab_type', '3': 1, '4': 1, '5': 5, '10': 'tabType'},
    {
      '1': 'menu_list',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.MusicMenu',
      '10': 'menuList'
    },
    {'1': 'has_more', '3': 3, '4': 1, '5': 8, '10': 'hasMore'},
    {'1': 'offset', '3': 4, '4': 1, '5': 9, '10': 'offset'},
  ],
};

/// Descriptor for `MainFavMusicMenuListResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mainFavMusicMenuListRespDescriptor = $convert.base64Decode(
    'ChhNYWluRmF2TXVzaWNNZW51TGlzdFJlc3ASGQoIdGFiX3R5cGUYASABKAVSB3RhYlR5cGUSQA'
    'oJbWVudV9saXN0GAIgAygLMiMuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLk11c2ljTWVudVII'
    'bWVudUxpc3QSGQoIaGFzX21vcmUYAyABKAhSB2hhc01vcmUSFgoGb2Zmc2V0GAQgASgJUgZvZm'
    'ZzZXQ=');

@$core.Deprecated('Use mainFavMusicSubTabListReqDescriptor instead')
const MainFavMusicSubTabListReq$json = {
  '1': 'MainFavMusicSubTabListReq',
};

/// Descriptor for `MainFavMusicSubTabListReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mainFavMusicSubTabListReqDescriptor =
    $convert.base64Decode('ChlNYWluRmF2TXVzaWNTdWJUYWJMaXN0UmVx');

@$core.Deprecated('Use mainFavMusicSubTabListRespDescriptor instead')
const MainFavMusicSubTabListResp$json = {
  '1': 'MainFavMusicSubTabListResp',
  '2': [
    {
      '1': 'tabs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.MusicSubTab',
      '10': 'tabs'
    },
    {
      '1': 'default_tab_res',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.MainFavMusicMenuListResp',
      '10': 'defaultTabRes'
    },
    {
      '1': 'first_page_res',
      '3': 3,
      '4': 3,
      '5': 11,
      '6':
          '.bilibili.app.listener.v1.MainFavMusicSubTabListResp.FirstPageResEntry',
      '10': 'firstPageRes'
    },
  ],
  '3': [MainFavMusicSubTabListResp_FirstPageResEntry$json],
};

@$core.Deprecated('Use mainFavMusicSubTabListRespDescriptor instead')
const MainFavMusicSubTabListResp_FirstPageResEntry$json = {
  '1': 'FirstPageResEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 5, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.MainFavMusicMenuListResp',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `MainFavMusicSubTabListResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mainFavMusicSubTabListRespDescriptor = $convert.base64Decode(
    'ChpNYWluRmF2TXVzaWNTdWJUYWJMaXN0UmVzcBI5CgR0YWJzGAEgAygLMiUuYmlsaWJpbGkuYX'
    'BwLmxpc3RlbmVyLnYxLk11c2ljU3ViVGFiUgR0YWJzEloKD2RlZmF1bHRfdGFiX3JlcxgCIAEo'
    'CzIyLmJpbGliaWxpLmFwcC5saXN0ZW5lci52MS5NYWluRmF2TXVzaWNNZW51TGlzdFJlc3BSDW'
    'RlZmF1bHRUYWJSZXMSbAoOZmlyc3RfcGFnZV9yZXMYAyADKAsyRi5iaWxpYmlsaS5hcHAubGlz'
    'dGVuZXIudjEuTWFpbkZhdk11c2ljU3ViVGFiTGlzdFJlc3AuRmlyc3RQYWdlUmVzRW50cnlSDG'
    'ZpcnN0UGFnZVJlcxpzChFGaXJzdFBhZ2VSZXNFbnRyeRIQCgNrZXkYASABKAVSA2tleRJICgV2'
    'YWx1ZRgCIAEoCzIyLmJpbGliaWxpLmFwcC5saXN0ZW5lci52MS5NYWluRmF2TXVzaWNNZW51TG'
    'lzdFJlc3BSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use medialistItemDescriptor instead')
const MedialistItem$json = {
  '1': 'MedialistItem',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'item'
    },
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'cover', '3': 3, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'duration', '3': 4, '4': 1, '5': 3, '10': 'duration'},
    {'1': 'parts', '3': 5, '4': 1, '5': 5, '10': 'parts'},
    {'1': 'up_mid', '3': 6, '4': 1, '5': 3, '10': 'upMid'},
    {'1': 'up_name', '3': 7, '4': 1, '5': 9, '10': 'upName'},
    {'1': 'state', '3': 8, '4': 1, '5': 5, '10': 'state'},
    {'1': 'message', '3': 9, '4': 1, '5': 9, '10': 'message'},
    {'1': 'stat_view', '3': 10, '4': 1, '5': 3, '10': 'statView'},
    {'1': 'stat_reply', '3': 11, '4': 1, '5': 3, '10': 'statReply'},
    {'1': 'use_stat_view_vt', '3': 12, '4': 1, '5': 8, '10': 'useStatViewVt'},
    {'1': 'stat_view_vt_text', '3': 13, '4': 1, '5': 9, '10': 'statViewVtText'},
  ],
};

/// Descriptor for `MedialistItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List medialistItemDescriptor = $convert.base64Decode(
    'Cg1NZWRpYWxpc3RJdGVtEjYKBGl0ZW0YASABKAsyIi5iaWxpYmlsaS5hcHAubGlzdGVuZXIudj'
    'EuUGxheUl0ZW1SBGl0ZW0SFAoFdGl0bGUYAiABKAlSBXRpdGxlEhQKBWNvdmVyGAMgASgJUgVj'
    'b3ZlchIaCghkdXJhdGlvbhgEIAEoA1IIZHVyYXRpb24SFAoFcGFydHMYBSABKAVSBXBhcnRzEh'
    'UKBnVwX21pZBgGIAEoA1IFdXBNaWQSFwoHdXBfbmFtZRgHIAEoCVIGdXBOYW1lEhQKBXN0YXRl'
    'GAggASgFUgVzdGF0ZRIYCgdtZXNzYWdlGAkgASgJUgdtZXNzYWdlEhsKCXN0YXRfdmlldxgKIA'
    'EoA1IIc3RhdFZpZXcSHQoKc3RhdF9yZXBseRgLIAEoA1IJc3RhdFJlcGx5EicKEHVzZV9zdGF0'
    'X3ZpZXdfdnQYDCABKAhSDXVzZVN0YXRWaWV3VnQSKQoRc3RhdF92aWV3X3Z0X3RleHQYDSABKA'
    'lSDnN0YXRWaWV3VnRUZXh0');

@$core.Deprecated('Use medialistReqDescriptor instead')
const MedialistReq$json = {
  '1': 'MedialistReq',
  '2': [
    {'1': 'list_type', '3': 1, '4': 1, '5': 3, '10': 'listType'},
    {'1': 'biz_id', '3': 2, '4': 1, '5': 3, '10': 'bizId'},
    {'1': 'offset', '3': 3, '4': 1, '5': 9, '10': 'offset'},
  ],
};

/// Descriptor for `MedialistReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List medialistReqDescriptor = $convert.base64Decode(
    'CgxNZWRpYWxpc3RSZXESGwoJbGlzdF90eXBlGAEgASgDUghsaXN0VHlwZRIVCgZiaXpfaWQYAi'
    'ABKANSBWJpeklkEhYKBm9mZnNldBgDIAEoCVIGb2Zmc2V0');

@$core.Deprecated('Use medialistRespDescriptor instead')
const MedialistResp$json = {
  '1': 'MedialistResp',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 3, '10': 'total'},
    {'1': 'has_more', '3': 2, '4': 1, '5': 8, '10': 'hasMore'},
    {'1': 'offset', '3': 3, '4': 1, '5': 9, '10': 'offset'},
    {
      '1': 'items',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.MedialistItem',
      '10': 'items'
    },
    {
      '1': 'up_info',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.MedialistUpInfo',
      '10': 'upInfo'
    },
  ],
};

/// Descriptor for `MedialistResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List medialistRespDescriptor = $convert.base64Decode(
    'Cg1NZWRpYWxpc3RSZXNwEhQKBXRvdGFsGAEgASgDUgV0b3RhbBIZCghoYXNfbW9yZRgCIAEoCF'
    'IHaGFzTW9yZRIWCgZvZmZzZXQYAyABKAlSBm9mZnNldBI9CgVpdGVtcxgEIAMoCzInLmJpbGli'
    'aWxpLmFwcC5saXN0ZW5lci52MS5NZWRpYWxpc3RJdGVtUgVpdGVtcxJCCgd1cF9pbmZvGAUgAS'
    'gLMikuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLk1lZGlhbGlzdFVwSW5mb1IGdXBJbmZv');

@$core.Deprecated('Use medialistUpInfoDescriptor instead')
const MedialistUpInfo$json = {
  '1': 'MedialistUpInfo',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'avatar', '3': 2, '4': 1, '5': 9, '10': 'avatar'},
    {'1': 'fans', '3': 3, '4': 1, '5': 3, '10': 'fans'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `MedialistUpInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List medialistUpInfoDescriptor = $convert.base64Decode(
    'Cg9NZWRpYWxpc3RVcEluZm8SEAoDbWlkGAEgASgDUgNtaWQSFgoGYXZhdGFyGAIgASgJUgZhdm'
    'F0YXISEgoEZmFucxgDIAEoA1IEZmFucxISCgRuYW1lGAQgASgJUgRuYW1l');

@$core.Deprecated('Use menuDeleteReqDescriptor instead')
const MenuDeleteReq$json = {
  '1': 'MenuDeleteReq',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
  ],
};

/// Descriptor for `MenuDeleteReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List menuDeleteReqDescriptor =
    $convert.base64Decode('Cg1NZW51RGVsZXRlUmVxEg4KAmlkGAEgASgDUgJpZA==');

@$core.Deprecated('Use menuDeleteRespDescriptor instead')
const MenuDeleteResp$json = {
  '1': 'MenuDeleteResp',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `MenuDeleteResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List menuDeleteRespDescriptor = $convert
    .base64Decode('Cg5NZW51RGVsZXRlUmVzcBIYCgdtZXNzYWdlGAEgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use menuEditReqDescriptor instead')
const MenuEditReq$json = {
  '1': 'MenuEditReq',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'desc', '3': 3, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'is_public', '3': 4, '4': 1, '5': 5, '10': 'isPublic'},
  ],
};

/// Descriptor for `MenuEditReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List menuEditReqDescriptor = $convert.base64Decode(
    'CgtNZW51RWRpdFJlcRIOCgJpZBgBIAEoA1ICaWQSFAoFdGl0bGUYAiABKAlSBXRpdGxlEhIKBG'
    'Rlc2MYAyABKAlSBGRlc2MSGwoJaXNfcHVibGljGAQgASgFUghpc1B1YmxpYw==');

@$core.Deprecated('Use menuEditRespDescriptor instead')
const MenuEditResp$json = {
  '1': 'MenuEditResp',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `MenuEditResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List menuEditRespDescriptor = $convert
    .base64Decode('CgxNZW51RWRpdFJlc3ASGAoHbWVzc2FnZRgBIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use menuSubscribeReqDescriptor instead')
const MenuSubscribeReq$json = {
  '1': 'MenuSubscribeReq',
  '2': [
    {
      '1': 'action',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.listener.v1.MenuSubscribeReq.SubscribeAction',
      '10': 'action'
    },
    {'1': 'target_id', '3': 2, '4': 1, '5': 3, '10': 'targetId'},
  ],
  '4': [MenuSubscribeReq_SubscribeAction$json],
};

@$core.Deprecated('Use menuSubscribeReqDescriptor instead')
const MenuSubscribeReq_SubscribeAction$json = {
  '1': 'SubscribeAction',
  '2': [
    {'1': 'INVALID_SubscribeAction', '2': 0},
    {'1': 'ADD_SubscribeAction', '2': 1},
    {'1': 'DEL_SubscribeAction', '2': 2},
  ],
};

/// Descriptor for `MenuSubscribeReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List menuSubscribeReqDescriptor = $convert.base64Decode(
    'ChBNZW51U3Vic2NyaWJlUmVxElIKBmFjdGlvbhgBIAEoDjI6LmJpbGliaWxpLmFwcC5saXN0ZW'
    '5lci52MS5NZW51U3Vic2NyaWJlUmVxLlN1YnNjcmliZUFjdGlvblIGYWN0aW9uEhsKCXRhcmdl'
    'dF9pZBgCIAEoA1IIdGFyZ2V0SWQiYAoPU3Vic2NyaWJlQWN0aW9uEhsKF0lOVkFMSURfU3Vic2'
    'NyaWJlQWN0aW9uEAASFwoTQUREX1N1YnNjcmliZUFjdGlvbhABEhcKE0RFTF9TdWJzY3JpYmVB'
    'Y3Rpb24QAg==');

@$core.Deprecated('Use menuSubscribeRespDescriptor instead')
const MenuSubscribeResp$json = {
  '1': 'MenuSubscribeResp',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `MenuSubscribeResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List menuSubscribeRespDescriptor = $convert.base64Decode(
    'ChFNZW51U3Vic2NyaWJlUmVzcBIYCgdtZXNzYWdlGAEgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use musicMenuDescriptor instead')
const MusicMenu$json = {
  '1': 'MusicMenu',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'menu_type', '3': 2, '4': 1, '5': 5, '10': 'menuType'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'desc', '3': 4, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'cover', '3': 5, '4': 1, '5': 9, '10': 'cover'},
    {
      '1': 'owner',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.MusicMenuAuthor',
      '10': 'owner'
    },
    {'1': 'state', '3': 7, '4': 1, '5': 5, '10': 'state'},
    {'1': 'attr', '3': 8, '4': 1, '5': 3, '10': 'attr'},
    {
      '1': 'stat',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.MusicMenuStat',
      '10': 'stat'
    },
    {'1': 'total', '3': 10, '4': 1, '5': 3, '10': 'total'},
    {'1': 'ctime', '3': 11, '4': 1, '5': 3, '10': 'ctime'},
    {'1': 'uri', '3': 12, '4': 1, '5': 9, '10': 'uri'},
  ],
};

/// Descriptor for `MusicMenu`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List musicMenuDescriptor = $convert.base64Decode(
    'CglNdXNpY01lbnUSDgoCaWQYASABKANSAmlkEhsKCW1lbnVfdHlwZRgCIAEoBVIIbWVudVR5cG'
    'USFAoFdGl0bGUYAyABKAlSBXRpdGxlEhIKBGRlc2MYBCABKAlSBGRlc2MSFAoFY292ZXIYBSAB'
    'KAlSBWNvdmVyEj8KBW93bmVyGAYgASgLMikuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLk11c2'
    'ljTWVudUF1dGhvclIFb3duZXISFAoFc3RhdGUYByABKAVSBXN0YXRlEhIKBGF0dHIYCCABKANS'
    'BGF0dHISOwoEc3RhdBgJIAEoCzInLmJpbGliaWxpLmFwcC5saXN0ZW5lci52MS5NdXNpY01lbn'
    'VTdGF0UgRzdGF0EhQKBXRvdGFsGAogASgDUgV0b3RhbBIUCgVjdGltZRgLIAEoA1IFY3RpbWUS'
    'EAoDdXJpGAwgASgJUgN1cmk=');

@$core.Deprecated('Use musicMenuAuthorDescriptor instead')
const MusicMenuAuthor$json = {
  '1': 'MusicMenuAuthor',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'avatar', '3': 3, '4': 1, '5': 9, '10': 'avatar'},
  ],
};

/// Descriptor for `MusicMenuAuthor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List musicMenuAuthorDescriptor = $convert.base64Decode(
    'Cg9NdXNpY01lbnVBdXRob3ISEAoDbWlkGAEgASgDUgNtaWQSEgoEbmFtZRgCIAEoCVIEbmFtZR'
    'IWCgZhdmF0YXIYAyABKAlSBmF2YXRhcg==');

@$core.Deprecated('Use musicMenuStatDescriptor instead')
const MusicMenuStat$json = {
  '1': 'MusicMenuStat',
  '2': [
    {'1': 'play', '3': 1, '4': 1, '5': 3, '10': 'play'},
    {'1': 'reply', '3': 2, '4': 1, '5': 3, '10': 'reply'},
  ],
};

/// Descriptor for `MusicMenuStat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List musicMenuStatDescriptor = $convert.base64Decode(
    'Cg1NdXNpY01lbnVTdGF0EhIKBHBsYXkYASABKANSBHBsYXkSFAoFcmVwbHkYAiABKANSBXJlcG'
    'x5');

@$core.Deprecated('Use musicSubTabDescriptor instead')
const MusicSubTab$json = {
  '1': 'MusicSubTab',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'tab_type', '3': 2, '4': 1, '5': 5, '10': 'tabType'},
    {'1': 'total', '3': 3, '4': 1, '5': 3, '10': 'total'},
  ],
};

/// Descriptor for `MusicSubTab`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List musicSubTabDescriptor = $convert.base64Decode(
    'CgtNdXNpY1N1YlRhYhISCgRuYW1lGAEgASgJUgRuYW1lEhkKCHRhYl90eXBlGAIgASgFUgd0YW'
    'JUeXBlEhQKBXRvdGFsGAMgASgDUgV0b3RhbA==');

@$core.Deprecated('Use pageOptionDescriptor instead')
const PageOption$json = {
  '1': 'PageOption',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
    {
      '1': 'direction',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.listener.v1.PageOption.Direction',
      '10': 'direction'
    },
    {
      '1': 'last_item',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'lastItem'
    },
  ],
  '4': [PageOption_Direction$json],
};

@$core.Deprecated('Use pageOptionDescriptor instead')
const PageOption_Direction$json = {
  '1': 'Direction',
  '2': [
    {'1': 'SCROLL_DOWN', '2': 0},
    {'1': 'SCROLL_UP', '2': 1},
  ],
};

/// Descriptor for `PageOption`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pageOptionDescriptor = $convert.base64Decode(
    'CgpQYWdlT3B0aW9uEhsKCXBhZ2Vfc2l6ZRgBIAEoBVIIcGFnZVNpemUSTAoJZGlyZWN0aW9uGA'
    'IgASgOMi4uYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLlBhZ2VPcHRpb24uRGlyZWN0aW9uUglk'
    'aXJlY3Rpb24SPwoJbGFzdF9pdGVtGAMgASgLMiIuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLl'
    'BsYXlJdGVtUghsYXN0SXRlbSIrCglEaXJlY3Rpb24SDwoLU0NST0xMX0RPV04QABINCglTQ1JP'
    'TExfVVAQAQ==');

@$core.Deprecated('Use pickArchiveDescriptor instead')
const PickArchive$json = {
  '1': 'PickArchive',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'item'
    },
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'owner',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PickArchiveAuthor',
      '10': 'owner'
    },
    {'1': 'cover', '3': 4, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'duration', '3': 5, '4': 1, '5': 3, '10': 'duration'},
    {'1': 'parts', '3': 6, '4': 1, '5': 5, '10': 'parts'},
    {'1': 'stat_view', '3': 7, '4': 1, '5': 5, '10': 'statView'},
    {'1': 'stat_reply', '3': 8, '4': 1, '5': 5, '10': 'statReply'},
    {'1': 'state', '3': 9, '4': 1, '5': 5, '10': 'state'},
    {'1': 'message', '3': 10, '4': 1, '5': 9, '10': 'message'},
    {'1': 'use_stat_view_vt', '3': 11, '4': 1, '5': 8, '10': 'useStatViewVt'},
    {'1': 'stat_view_vt_text', '3': 12, '4': 1, '5': 9, '10': 'statViewVtText'},
  ],
};

/// Descriptor for `PickArchive`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pickArchiveDescriptor = $convert.base64Decode(
    'CgtQaWNrQXJjaGl2ZRI2CgRpdGVtGAEgASgLMiIuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLl'
    'BsYXlJdGVtUgRpdGVtEhQKBXRpdGxlGAIgASgJUgV0aXRsZRJBCgVvd25lchgDIAEoCzIrLmJp'
    'bGliaWxpLmFwcC5saXN0ZW5lci52MS5QaWNrQXJjaGl2ZUF1dGhvclIFb3duZXISFAoFY292ZX'
    'IYBCABKAlSBWNvdmVyEhoKCGR1cmF0aW9uGAUgASgDUghkdXJhdGlvbhIUCgVwYXJ0cxgGIAEo'
    'BVIFcGFydHMSGwoJc3RhdF92aWV3GAcgASgFUghzdGF0VmlldxIdCgpzdGF0X3JlcGx5GAggAS'
    'gFUglzdGF0UmVwbHkSFAoFc3RhdGUYCSABKAVSBXN0YXRlEhgKB21lc3NhZ2UYCiABKAlSB21l'
    'c3NhZ2USJwoQdXNlX3N0YXRfdmlld192dBgLIAEoCFINdXNlU3RhdFZpZXdWdBIpChFzdGF0X3'
    'ZpZXdfdnRfdGV4dBgMIAEoCVIOc3RhdFZpZXdWdFRleHQ=');

@$core.Deprecated('Use pickArchiveAuthorDescriptor instead')
const PickArchiveAuthor$json = {
  '1': 'PickArchiveAuthor',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `PickArchiveAuthor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pickArchiveAuthorDescriptor = $convert.base64Decode(
    'ChFQaWNrQXJjaGl2ZUF1dGhvchIQCgNtaWQYASABKANSA21pZBISCgRuYW1lGAIgASgJUgRuYW'
    '1l');

@$core.Deprecated('Use pickCardDescriptor instead')
const PickCard$json = {
  '1': 'PickCard',
  '2': [
    {'1': 'pick_id', '3': 1, '4': 1, '5': 3, '10': 'pickId'},
    {'1': 'card_id', '3': 2, '4': 1, '5': 3, '10': 'cardId'},
    {'1': 'card_name', '3': 3, '4': 1, '5': 9, '10': 'cardName'},
    {
      '1': 'modules',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.CardModule',
      '10': 'modules'
    },
  ],
};

/// Descriptor for `PickCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pickCardDescriptor = $convert.base64Decode(
    'CghQaWNrQ2FyZBIXCgdwaWNrX2lkGAEgASgDUgZwaWNrSWQSFwoHY2FyZF9pZBgCIAEoA1IGY2'
    'FyZElkEhsKCWNhcmRfbmFtZRgDIAEoCVIIY2FyZE5hbWUSPgoHbW9kdWxlcxgEIAMoCzIkLmJp'
    'bGliaWxpLmFwcC5saXN0ZW5lci52MS5DYXJkTW9kdWxlUgdtb2R1bGVz');

@$core.Deprecated('Use pickCardDetailReqDescriptor instead')
const PickCardDetailReq$json = {
  '1': 'PickCardDetailReq',
  '2': [
    {'1': 'card_id', '3': 1, '4': 1, '5': 3, '10': 'cardId'},
    {'1': 'pick_id', '3': 2, '4': 1, '5': 3, '10': 'pickId'},
  ],
};

/// Descriptor for `PickCardDetailReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pickCardDetailReqDescriptor = $convert.base64Decode(
    'ChFQaWNrQ2FyZERldGFpbFJlcRIXCgdjYXJkX2lkGAEgASgDUgZjYXJkSWQSFwoHcGlja19pZB'
    'gCIAEoA1IGcGlja0lk');

@$core.Deprecated('Use pickCardDetailRespDescriptor instead')
const PickCardDetailResp$json = {
  '1': 'PickCardDetailResp',
  '2': [
    {'1': 'card_id', '3': 1, '4': 1, '5': 3, '10': 'cardId'},
    {'1': 'pick_id', '3': 2, '4': 1, '5': 3, '10': 'pickId'},
    {
      '1': 'modules',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.CardModule',
      '10': 'modules'
    },
  ],
};

/// Descriptor for `PickCardDetailResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pickCardDetailRespDescriptor = $convert.base64Decode(
    'ChJQaWNrQ2FyZERldGFpbFJlc3ASFwoHY2FyZF9pZBgBIAEoA1IGY2FyZElkEhcKB3BpY2tfaW'
    'QYAiABKANSBnBpY2tJZBI+Cgdtb2R1bGVzGAMgAygLMiQuYmlsaWJpbGkuYXBwLmxpc3RlbmVy'
    'LnYxLkNhcmRNb2R1bGVSB21vZHVsZXM=');

@$core.Deprecated('Use pickFeedReqDescriptor instead')
const PickFeedReq$json = {
  '1': 'PickFeedReq',
  '2': [
    {'1': 'offset', '3': 1, '4': 1, '5': 3, '10': 'offset'},
  ],
};

/// Descriptor for `PickFeedReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pickFeedReqDescriptor = $convert
    .base64Decode('CgtQaWNrRmVlZFJlcRIWCgZvZmZzZXQYASABKANSBm9mZnNldA==');

@$core.Deprecated('Use pickFeedRespDescriptor instead')
const PickFeedResp$json = {
  '1': 'PickFeedResp',
  '2': [
    {'1': 'offset', '3': 1, '4': 1, '5': 3, '10': 'offset'},
    {
      '1': 'cards',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PickCard',
      '10': 'cards'
    },
  ],
};

/// Descriptor for `PickFeedResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pickFeedRespDescriptor = $convert.base64Decode(
    'CgxQaWNrRmVlZFJlc3ASFgoGb2Zmc2V0GAEgASgDUgZvZmZzZXQSOAoFY2FyZHMYAiADKAsyIi'
    '5iaWxpYmlsaS5hcHAubGlzdGVuZXIudjEuUGlja0NhcmRSBWNhcmRz');

@$core.Deprecated('Use pkcmArchiveDescriptor instead')
const PkcmArchive$json = {
  '1': 'PkcmArchive',
  '2': [
    {
      '1': 'arc',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PickArchive',
      '10': 'arc'
    },
    {'1': 'pick_reason', '3': 2, '4': 1, '5': 9, '10': 'pickReason'},
  ],
};

/// Descriptor for `PkcmArchive`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pkcmArchiveDescriptor = $convert.base64Decode(
    'CgtQa2NtQXJjaGl2ZRI3CgNhcmMYASABKAsyJS5iaWxpYmlsaS5hcHAubGlzdGVuZXIudjEuUG'
    'lja0FyY2hpdmVSA2FyYxIfCgtwaWNrX3JlYXNvbhgCIAEoCVIKcGlja1JlYXNvbg==');

@$core.Deprecated('Use pkcmCenterButtonDescriptor instead')
const PkcmCenterButton$json = {
  '1': 'PkcmCenterButton',
  '2': [
    {'1': 'icon_head', '3': 1, '4': 1, '5': 9, '10': 'iconHead'},
    {'1': 'icon_tail', '3': 2, '4': 1, '5': 9, '10': 'iconTail'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'uri', '3': 4, '4': 1, '5': 9, '10': 'uri'},
  ],
};

/// Descriptor for `PkcmCenterButton`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pkcmCenterButtonDescriptor = $convert.base64Decode(
    'ChBQa2NtQ2VudGVyQnV0dG9uEhsKCWljb25faGVhZBgBIAEoCVIIaWNvbkhlYWQSGwoJaWNvbl'
    '90YWlsGAIgASgJUghpY29uVGFpbBIUCgV0aXRsZRgDIAEoCVIFdGl0bGUSEAoDdXJpGAQgASgJ'
    'UgN1cmk=');

@$core.Deprecated('Use pkcmHeaderDescriptor instead')
const PkcmHeader$json = {
  '1': 'PkcmHeader',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'desc', '3': 2, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'btn_icon', '3': 3, '4': 1, '5': 9, '10': 'btnIcon'},
    {'1': 'btn_text', '3': 4, '4': 1, '5': 9, '10': 'btnText'},
    {'1': 'btn_uri', '3': 5, '4': 1, '5': 9, '10': 'btnUri'},
  ],
};

/// Descriptor for `PkcmHeader`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pkcmHeaderDescriptor = $convert.base64Decode(
    'CgpQa2NtSGVhZGVyEhQKBXRpdGxlGAEgASgJUgV0aXRsZRISCgRkZXNjGAIgASgJUgRkZXNjEh'
    'kKCGJ0bl9pY29uGAMgASgJUgdidG5JY29uEhkKCGJ0bl90ZXh0GAQgASgJUgdidG5UZXh0EhcK'
    'B2J0bl91cmkYBSABKAlSBmJ0blVyaQ==');

@$core.Deprecated('Use playActionReportReqDescriptor instead')
const PlayActionReportReq$json = {
  '1': 'PlayActionReportReq',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'item'
    },
    {'1': 'from_spmid', '3': 2, '4': 1, '5': 9, '10': 'fromSpmid'},
  ],
};

/// Descriptor for `PlayActionReportReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playActionReportReqDescriptor = $convert.base64Decode(
    'ChNQbGF5QWN0aW9uUmVwb3J0UmVxEjYKBGl0ZW0YASABKAsyIi5iaWxpYmlsaS5hcHAubGlzdG'
    'VuZXIudjEuUGxheUl0ZW1SBGl0ZW0SHQoKZnJvbV9zcG1pZBgCIAEoCVIJZnJvbVNwbWlk');

@$core.Deprecated('Use playDASHDescriptor instead')
const PlayDASH$json = {
  '1': 'PlayDASH',
  '2': [
    {'1': 'duration', '3': 1, '4': 1, '5': 5, '10': 'duration'},
    {'1': 'min_buffer_time', '3': 2, '4': 1, '5': 2, '10': 'minBufferTime'},
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
    'CghQbGF5REFTSBIaCghkdXJhdGlvbhgBIAEoBVIIZHVyYXRpb24SJgoPbWluX2J1ZmZlcl90aW'
    '1lGAIgASgCUg1taW5CdWZmZXJUaW1lEjgKBWF1ZGlvGAMgAygLMiIuYmlsaWJpbGkuYXBwLmxp'
    'c3RlbmVyLnYxLkRhc2hJdGVtUgVhdWRpbw==');

@$core.Deprecated('Use playHistoryAddReqDescriptor instead')
const PlayHistoryAddReq$json = {
  '1': 'PlayHistoryAddReq',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'item'
    },
    {'1': 'progress', '3': 2, '4': 1, '5': 3, '10': 'progress'},
    {'1': 'duration', '3': 3, '4': 1, '5': 3, '10': 'duration'},
    {'1': 'play_style', '3': 4, '4': 1, '5': 5, '10': 'playStyle'},
  ],
};

/// Descriptor for `PlayHistoryAddReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playHistoryAddReqDescriptor = $convert.base64Decode(
    'ChFQbGF5SGlzdG9yeUFkZFJlcRI2CgRpdGVtGAEgASgLMiIuYmlsaWJpbGkuYXBwLmxpc3Rlbm'
    'VyLnYxLlBsYXlJdGVtUgRpdGVtEhoKCHByb2dyZXNzGAIgASgDUghwcm9ncmVzcxIaCghkdXJh'
    'dGlvbhgDIAEoA1IIZHVyYXRpb24SHQoKcGxheV9zdHlsZRgEIAEoBVIJcGxheVN0eWxl');

@$core.Deprecated('Use playHistoryDelReqDescriptor instead')
const PlayHistoryDelReq$json = {
  '1': 'PlayHistoryDelReq',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'items'
    },
    {'1': 'truncate', '3': 2, '4': 1, '5': 8, '10': 'truncate'},
  ],
};

/// Descriptor for `PlayHistoryDelReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playHistoryDelReqDescriptor = $convert.base64Decode(
    'ChFQbGF5SGlzdG9yeURlbFJlcRI4CgVpdGVtcxgBIAMoCzIiLmJpbGliaWxpLmFwcC5saXN0ZW'
    '5lci52MS5QbGF5SXRlbVIFaXRlbXMSGgoIdHJ1bmNhdGUYAiABKAhSCHRydW5jYXRl');

@$core.Deprecated('Use playHistoryReqDescriptor instead')
const PlayHistoryReq$json = {
  '1': 'PlayHistoryReq',
  '2': [
    {
      '1': 'page_opt',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PageOption',
      '10': 'pageOpt'
    },
    {'1': 'local_today_zero', '3': 2, '4': 1, '5': 3, '10': 'localTodayZero'},
    {
      '1': 'pagination',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.pagination.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `PlayHistoryReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playHistoryReqDescriptor = $convert.base64Decode(
    'Cg5QbGF5SGlzdG9yeVJlcRI/CghwYWdlX29wdBgBIAEoCzIkLmJpbGliaWxpLmFwcC5saXN0ZW'
    '5lci52MS5QYWdlT3B0aW9uUgdwYWdlT3B0EigKEGxvY2FsX3RvZGF5X3plcm8YAiABKANSDmxv'
    'Y2FsVG9kYXlaZXJvEj8KCnBhZ2luYXRpb24YAyABKAsyHy5iaWxpYmlsaS5wYWdpbmF0aW9uLl'
    'BhZ2luYXRpb25SCnBhZ2luYXRpb24=');

@$core.Deprecated('Use playHistoryRespDescriptor instead')
const PlayHistoryResp$json = {
  '1': 'PlayHistoryResp',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 5, '10': 'total'},
    {'1': 'reach_end', '3': 2, '4': 1, '5': 8, '10': 'reachEnd'},
    {
      '1': 'list',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.DetailItem',
      '10': 'list'
    },
    {
      '1': 'pagination_reply',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.pagination.PaginationReply',
      '10': 'paginationReply'
    },
  ],
};

/// Descriptor for `PlayHistoryResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playHistoryRespDescriptor = $convert.base64Decode(
    'Cg9QbGF5SGlzdG9yeVJlc3ASFAoFdG90YWwYASABKAVSBXRvdGFsEhsKCXJlYWNoX2VuZBgCIA'
    'EoCFIIcmVhY2hFbmQSOAoEbGlzdBgDIAMoCzIkLmJpbGliaWxpLmFwcC5saXN0ZW5lci52MS5E'
    'ZXRhaWxJdGVtUgRsaXN0Ek8KEHBhZ2luYXRpb25fcmVwbHkYBCABKAsyJC5iaWxpYmlsaS5wYW'
    'dpbmF0aW9uLlBhZ2luYXRpb25SZXBseVIPcGFnaW5hdGlvblJlcGx5');

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
    {'1': 'qn', '3': 1, '4': 1, '5': 5, '10': 'qn'},
    {'1': 'format', '3': 2, '4': 1, '5': 9, '10': 'format'},
    {'1': 'qn_type', '3': 3, '4': 1, '5': 5, '10': 'qnType'},
    {'1': 'fnver', '3': 6, '4': 1, '5': 5, '10': 'fnver'},
    {'1': 'fnval', '3': 7, '4': 1, '5': 5, '10': 'fnval'},
    {
      '1': 'formats',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.FormatDescription',
      '10': 'formats'
    },
    {'1': 'video_codecid', '3': 9, '4': 1, '5': 5, '10': 'videoCodecid'},
    {'1': 'length', '3': 10, '4': 1, '5': 3, '10': 'length'},
    {'1': 'code', '3': 11, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 12, '4': 1, '5': 9, '10': 'message'},
    {'1': 'expire_time', '3': 13, '4': 1, '5': 3, '10': 'expireTime'},
    {
      '1': 'volume',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.VolumeInfo',
      '10': 'volume'
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
    'c3RlbmVyLnYxLlBsYXlEQVNISABSCHBsYXlEYXNoEg4KAnFuGAEgASgFUgJxbhIWCgZmb3JtYX'
    'QYAiABKAlSBmZvcm1hdBIXCgdxbl90eXBlGAMgASgFUgZxblR5cGUSFAoFZm52ZXIYBiABKAVS'
    'BWZudmVyEhQKBWZudmFsGAcgASgFUgVmbnZhbBJFCgdmb3JtYXRzGAggAygLMisuYmlsaWJpbG'
    'kuYXBwLmxpc3RlbmVyLnYxLkZvcm1hdERlc2NyaXB0aW9uUgdmb3JtYXRzEiMKDXZpZGVvX2Nv'
    'ZGVjaWQYCSABKAVSDHZpZGVvQ29kZWNpZBIWCgZsZW5ndGgYCiABKANSBmxlbmd0aBISCgRjb2'
    'RlGAsgASgFUgRjb2RlEhgKB21lc3NhZ2UYDCABKAlSB21lc3NhZ2USHwoLZXhwaXJlX3RpbWUY'
    'DSABKANSCmV4cGlyZVRpbWUSOwoGdm9sdW1lGA4gASgLMiMuYmlsaWJpbGkuYXBwLnBsYXl1cm'
    'wudjEuVm9sdW1lSW5mb1IGdm9sdW1lQgYKBGluZm8=');

@$core.Deprecated('Use playItemDescriptor instead')
const PlayItem$json = {
  '1': 'PlayItem',
  '2': [
    {'1': 'item_type', '3': 1, '4': 1, '5': 5, '10': 'itemType'},
    {'1': 'oid', '3': 3, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'sub_id', '3': 4, '4': 3, '5': 3, '10': 'subId'},
    {
      '1': 'et',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.EventTracking',
      '10': 'et'
    },
    {'1': 'pos', '3': 6, '4': 1, '5': 3, '10': 'pos'},
  ],
};

/// Descriptor for `PlayItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playItemDescriptor = $convert.base64Decode(
    'CghQbGF5SXRlbRIbCglpdGVtX3R5cGUYASABKAVSCGl0ZW1UeXBlEhAKA29pZBgDIAEoA1IDb2'
    'lkEhUKBnN1Yl9pZBgEIAMoA1IFc3ViSWQSNwoCZXQYBSABKAsyJy5iaWxpYmlsaS5hcHAubGlz'
    'dGVuZXIudjEuRXZlbnRUcmFja2luZ1ICZXQSEAoDcG9zGAYgASgDUgNwb3M=');

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
    {'1': 'playable', '3': 2, '4': 1, '5': 5, '10': 'playable'},
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
    'BsYXlJdGVtUgRpdGVtEhoKCHBsYXlhYmxlGAIgASgFUghwbGF5YWJsZRIYCgdtZXNzYWdlGAMg'
    'ASgJUgdtZXNzYWdlElYKC3BsYXllcl9pbmZvGAQgAygLMjUuYmlsaWJpbGkuYXBwLmxpc3Rlbm'
    'VyLnYxLlBsYXlVUkxSZXNwLlBsYXllckluZm9FbnRyeVIKcGxheWVySW5mbxphCg9QbGF5ZXJJ'
    'bmZvRW50cnkSEAoDa2V5GAEgASgDUgNrZXkSOAoFdmFsdWUYAiABKAsyIi5iaWxpYmlsaS5hcH'
    'AubGlzdGVuZXIudjEuUGxheUluZm9SBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use playlistAddReqDescriptor instead')
const PlaylistAddReq$json = {
  '1': 'PlaylistAddReq',
  '2': [
    {
      '1': 'after',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '9': 0,
      '10': 'after'
    },
    {'1': 'head', '3': 3, '4': 1, '5': 8, '9': 0, '10': 'head'},
    {'1': 'tail', '3': 4, '4': 1, '5': 8, '9': 0, '10': 'tail'},
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'items'
    },
  ],
  '8': [
    {'1': 'pos'},
  ],
};

/// Descriptor for `PlaylistAddReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistAddReqDescriptor = $convert.base64Decode(
    'Cg5QbGF5bGlzdEFkZFJlcRI6CgVhZnRlchgCIAEoCzIiLmJpbGliaWxpLmFwcC5saXN0ZW5lci'
    '52MS5QbGF5SXRlbUgAUgVhZnRlchIUCgRoZWFkGAMgASgISABSBGhlYWQSFAoEdGFpbBgEIAEo'
    'CEgAUgR0YWlsEjgKBWl0ZW1zGAEgAygLMiIuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLlBsYX'
    'lJdGVtUgVpdGVtc0IFCgNwb3M=');

@$core.Deprecated('Use playlistDelReqDescriptor instead')
const PlaylistDelReq$json = {
  '1': 'PlaylistDelReq',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'items'
    },
    {'1': 'truncate', '3': 2, '4': 1, '5': 8, '10': 'truncate'},
  ],
};

/// Descriptor for `PlaylistDelReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistDelReqDescriptor = $convert.base64Decode(
    'Cg5QbGF5bGlzdERlbFJlcRI4CgVpdGVtcxgBIAMoCzIiLmJpbGliaWxpLmFwcC5saXN0ZW5lci'
    '52MS5QbGF5SXRlbVIFaXRlbXMSGgoIdHJ1bmNhdGUYAiABKAhSCHRydW5jYXRl');

@$core.Deprecated('Use playlistOffsetDescriptor instead')
const PlaylistOffset$json = {
  '1': 'PlaylistOffset',
  '2': [
    {
      '1': 'direction',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.listener.v1.PlaylistOffset.PlaylistScrollDirection',
      '10': 'direction'
    },
    {
      '1': 'last_item',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PlayItem',
      '10': 'lastItem'
    },
    {
      '1': 'random_state',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.RandomOrderStatus',
      '10': 'randomState'
    },
    {
      '1': 'sort_opt',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.SortOption',
      '10': 'sortOpt'
    },
  ],
  '4': [PlaylistOffset_PlaylistScrollDirection$json],
};

@$core.Deprecated('Use playlistOffsetDescriptor instead')
const PlaylistOffset_PlaylistScrollDirection$json = {
  '1': 'PlaylistScrollDirection',
  '2': [
    {'1': 'DOWN', '2': 0},
    {'1': 'UP', '2': 1},
  ],
};

/// Descriptor for `PlaylistOffset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playlistOffsetDescriptor = $convert.base64Decode(
    'Cg5QbGF5bGlzdE9mZnNldBJeCglkaXJlY3Rpb24YASABKA4yQC5iaWxpYmlsaS5hcHAubGlzdG'
    'VuZXIudjEuUGxheWxpc3RPZmZzZXQuUGxheWxpc3RTY3JvbGxEaXJlY3Rpb25SCWRpcmVjdGlv'
    'bhI/CglsYXN0X2l0ZW0YAiABKAsyIi5iaWxpYmlsaS5hcHAubGlzdGVuZXIudjEuUGxheUl0ZW'
    '1SCGxhc3RJdGVtEk4KDHJhbmRvbV9zdGF0ZRgDIAEoCzIrLmJpbGliaWxpLmFwcC5saXN0ZW5l'
    'ci52MS5SYW5kb21PcmRlclN0YXR1c1ILcmFuZG9tU3RhdGUSPwoIc29ydF9vcHQYBCABKAsyJC'
    '5iaWxpYmlsaS5hcHAubGlzdGVuZXIudjEuU29ydE9wdGlvblIHc29ydE9wdCIrChdQbGF5bGlz'
    'dFNjcm9sbERpcmVjdGlvbhIICgRET1dOEAASBgoCVVAQAQ==');

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
      '1': 'page_opt',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.PageOption',
      '10': 'pageOpt'
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
    'aWxpYmlsaS5hcHAubGlzdGVuZXIudjEuUGxheUl0ZW1SBmFuY2hvchI/CghwYWdlX29wdBgEIA'
    'EoCzIkLmJpbGliaWxpLmFwcC5saXN0ZW5lci52MS5QYWdlT3B0aW9uUgdwYWdlT3B0Ek8KC3Bs'
    'YXllcl9hcmdzGAUgASgLMi4uYmlsaWJpbGkuYXBwLmFyY2hpdmUubWlkZGxld2FyZS52MS5QbG'
    'F5ZXJBcmdzUgpwbGF5ZXJBcmdzEhkKCGV4dHJhX2lkGAYgASgDUgdleHRyYUlkEj8KCHNvcnRf'
    'b3B0GAcgASgLMiQuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLlNvcnRPcHRpb25SB3NvcnRPcH'
    'QSPwoKcGFnaW5hdGlvbhgIIAEoCzIfLmJpbGliaWxpLnBhZ2luYXRpb24uUGFnaW5hdGlvblIK'
    'cGFnaW5hdGlvbg==');

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

@$core.Deprecated('Use randomOrderStatusDescriptor instead')
const RandomOrderStatus$json = {
  '1': 'RandomOrderStatus',
  '2': [
    {'1': 'exposed_pos', '3': 1, '4': 3, '5': 3, '10': 'exposedPos'},
  ],
};

/// Descriptor for `RandomOrderStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List randomOrderStatusDescriptor = $convert.base64Decode(
    'ChFSYW5kb21PcmRlclN0YXR1cxIfCgtleHBvc2VkX3BvcxgBIAMoA1IKZXhwb3NlZFBvcw==');

@$core.Deprecated('Use rcmdOffsetDescriptor instead')
const RcmdOffset$json = {
  '1': 'RcmdOffset',
  '2': [
    {'1': 'rcmd_from', '3': 1, '4': 1, '5': 3, '10': 'rcmdFrom'},
    {'1': 'id', '3': 2, '4': 1, '5': 3, '10': 'id'},
    {'1': 'page', '3': 3, '4': 1, '5': 5, '10': 'page'},
    {'1': 'session_id', '3': 4, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'from_trackid', '3': 5, '4': 1, '5': 9, '10': 'fromTrackid'},
  ],
};

/// Descriptor for `RcmdOffset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rcmdOffsetDescriptor = $convert.base64Decode(
    'CgpSY21kT2Zmc2V0EhsKCXJjbWRfZnJvbRgBIAEoA1IIcmNtZEZyb20SDgoCaWQYAiABKANSAm'
    'lkEhIKBHBhZ2UYAyABKAVSBHBhZ2USHQoKc2Vzc2lvbl9pZBgEIAEoCVIJc2Vzc2lvbklkEiEK'
    'DGZyb21fdHJhY2tpZBgFIAEoCVILZnJvbVRyYWNraWQ=');

@$core.Deprecated('Use rcmdPlaylistReqDescriptor instead')
const RcmdPlaylistReq$json = {
  '1': 'RcmdPlaylistReq',
  '2': [
    {
      '1': 'from',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.listener.v1.RcmdPlaylistReq.RcmdFrom',
      '10': 'from'
    },
    {'1': 'id', '3': 2, '4': 1, '5': 3, '10': 'id'},
    {'1': 'need_history', '3': 3, '4': 1, '5': 8, '10': 'needHistory'},
    {'1': 'need_top_cards', '3': 4, '4': 1, '5': 8, '10': 'needTopCards'},
    {
      '1': 'player_args',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.archive.middleware.v1.PlayerArgs',
      '10': 'playerArgs'
    },
    {
      '1': 'page',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.pagination.Pagination',
      '10': 'page'
    },
    {
      '1': 'annotations',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.RcmdPlaylistReq.AnnotationsEntry',
      '10': 'annotations'
    },
  ],
  '3': [RcmdPlaylistReq_AnnotationsEntry$json],
  '4': [RcmdPlaylistReq_RcmdFrom$json],
};

@$core.Deprecated('Use rcmdPlaylistReqDescriptor instead')
const RcmdPlaylistReq_AnnotationsEntry$json = {
  '1': 'AnnotationsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use rcmdPlaylistReqDescriptor instead')
const RcmdPlaylistReq_RcmdFrom$json = {
  '1': 'RcmdFrom',
  '2': [
    {'1': 'UNSPECIFIED_RcmdFrom', '2': 0},
    {'1': 'UP_ARCHIVE_RcmdFrom', '2': 1},
    {'1': 'INDEX_ENTRY', '2': 2},
    {'1': 'ARCHIVE_VIEW', '2': 3},
  ],
};

/// Descriptor for `RcmdPlaylistReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rcmdPlaylistReqDescriptor = $convert.base64Decode(
    'Cg9SY21kUGxheWxpc3RSZXESRgoEZnJvbRgBIAEoDjIyLmJpbGliaWxpLmFwcC5saXN0ZW5lci'
    '52MS5SY21kUGxheWxpc3RSZXEuUmNtZEZyb21SBGZyb20SDgoCaWQYAiABKANSAmlkEiEKDG5l'
    'ZWRfaGlzdG9yeRgDIAEoCFILbmVlZEhpc3RvcnkSJAoObmVlZF90b3BfY2FyZHMYBCABKAhSDG'
    '5lZWRUb3BDYXJkcxJPCgtwbGF5ZXJfYXJncxgFIAEoCzIuLmJpbGliaWxpLmFwcC5hcmNoaXZl'
    'Lm1pZGRsZXdhcmUudjEuUGxheWVyQXJnc1IKcGxheWVyQXJncxIzCgRwYWdlGAYgASgLMh8uYm'
    'lsaWJpbGkucGFnaW5hdGlvbi5QYWdpbmF0aW9uUgRwYWdlElwKC2Fubm90YXRpb25zGAcgAygL'
    'MjouYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLlJjbWRQbGF5bGlzdFJlcS5Bbm5vdGF0aW9uc0'
    'VudHJ5Ugthbm5vdGF0aW9ucxo+ChBBbm5vdGF0aW9uc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5'
    'EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAEiYAoIUmNtZEZyb20SGAoUVU5TUEVDSUZJRURfUm'
    'NtZEZyb20QABIXChNVUF9BUkNISVZFX1JjbWRGcm9tEAESDwoLSU5ERVhfRU5UUlkQAhIQCgxB'
    'UkNISVZFX1ZJRVcQAw==');

@$core.Deprecated('Use rcmdPlaylistRespDescriptor instead')
const RcmdPlaylistResp$json = {
  '1': 'RcmdPlaylistResp',
  '2': [
    {
      '1': 'list',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.DetailItem',
      '10': 'list'
    },
    {'1': 'history_len', '3': 2, '4': 1, '5': 3, '10': 'historyLen'},
    {
      '1': 'top_cards',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.listener.v1.TopCard',
      '10': 'topCards'
    },
    {
      '1': 'next_page',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.pagination.PaginationReply',
      '10': 'nextPage'
    },
  ],
};

/// Descriptor for `RcmdPlaylistResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rcmdPlaylistRespDescriptor = $convert.base64Decode(
    'ChBSY21kUGxheWxpc3RSZXNwEjgKBGxpc3QYASADKAsyJC5iaWxpYmlsaS5hcHAubGlzdGVuZX'
    'IudjEuRGV0YWlsSXRlbVIEbGlzdBIfCgtoaXN0b3J5X2xlbhgCIAEoA1IKaGlzdG9yeUxlbhI+'
    'Cgl0b3BfY2FyZHMYAyADKAsyIS5iaWxpYmlsaS5hcHAubGlzdGVuZXIudjEuVG9wQ2FyZFIIdG'
    '9wQ2FyZHMSQQoJbmV4dF9wYWdlGAQgASgLMiQuYmlsaWJpbGkucGFnaW5hdGlvbi5QYWdpbmF0'
    'aW9uUmVwbHlSCG5leHRQYWdl');

@$core.Deprecated('Use responseUrlDescriptor instead')
const ResponseUrl$json = {
  '1': 'ResponseUrl',
  '2': [
    {'1': 'order', '3': 1, '4': 1, '5': 5, '10': 'order'},
    {'1': 'length', '3': 2, '4': 1, '5': 3, '10': 'length'},
    {'1': 'size', '3': 3, '4': 1, '5': 3, '10': 'size'},
    {'1': 'ahead', '3': 4, '4': 1, '5': 9, '10': 'ahead'},
    {'1': 'vhead', '3': 5, '4': 1, '5': 9, '10': 'vhead'},
    {'1': 'url', '3': 6, '4': 1, '5': 9, '10': 'url'},
    {'1': 'backup_url', '3': 7, '4': 3, '5': 9, '10': 'backupUrl'},
    {'1': 'md5', '3': 8, '4': 1, '5': 9, '10': 'md5'},
  ],
};

/// Descriptor for `ResponseUrl`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseUrlDescriptor = $convert.base64Decode(
    'CgtSZXNwb25zZVVybBIUCgVvcmRlchgBIAEoBVIFb3JkZXISFgoGbGVuZ3RoGAIgASgDUgZsZW'
    '5ndGgSEgoEc2l6ZRgDIAEoA1IEc2l6ZRIUCgVhaGVhZBgEIAEoCVIFYWhlYWQSFAoFdmhlYWQY'
    'BSABKAlSBXZoZWFkEhAKA3VybBgGIAEoCVIDdXJsEh0KCmJhY2t1cF91cmwYByADKAlSCWJhY2'
    't1cFVybBIQCgNtZDUYCCABKAlSA21kNQ==');

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
    {'1': 'is_switching', '3': 3, '4': 1, '5': 8, '10': 'isSwitching'},
  ],
};

/// Descriptor for `SortOption`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sortOptionDescriptor = $convert.base64Decode(
    'CgpTb3J0T3B0aW9uEjkKBW9yZGVyGAEgASgOMiMuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLk'
    'xpc3RPcmRlclIFb3JkZXISRgoKc29ydF9maWVsZBgCIAEoDjInLmJpbGliaWxpLmFwcC5saXN0'
    'ZW5lci52MS5MaXN0U29ydEZpZWxkUglzb3J0RmllbGQSIQoMaXNfc3dpdGNoaW5nGAMgASgIUg'
    'tpc1N3aXRjaGluZw==');

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

@$core.Deprecated('Use topCardDescriptor instead')
const TopCard$json = {
  '1': 'TopCard',
  '2': [
    {
      '1': 'listen_history',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.TpcdHistory',
      '9': 0,
      '10': 'listenHistory'
    },
    {
      '1': 'fav_folder',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.TpcdFavFolder',
      '9': 0,
      '10': 'favFolder'
    },
    {
      '1': 'up_recall',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.TpcdUpRecall',
      '9': 0,
      '10': 'upRecall'
    },
    {
      '1': 'pick_today',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.TpcdPickToday',
      '9': 0,
      '10': 'pickToday'
    },
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'play_style',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.listener.v1.TopCard.PlayStrategy',
      '10': 'playStyle'
    },
    {
      '1': 'card_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.listener.v1.TopCardType',
      '10': 'cardType'
    },
    {'1': 'pos', '3': 8, '4': 1, '5': 3, '10': 'pos'},
    {'1': 'title_icon', '3': 9, '4': 1, '5': 9, '10': 'titleIcon'},
  ],
  '4': [TopCard_PlayStrategy$json],
  '8': [
    {'1': 'card'},
  ],
};

@$core.Deprecated('Use topCardDescriptor instead')
const TopCard_PlayStrategy$json = {
  '1': 'PlayStrategy',
  '2': [
    {'1': 'NO_INTERRUPT', '2': 0},
    {'1': 'PLAY_TARGET', '2': 1},
    {'1': 'PLAY_FIRST', '2': 2},
  ],
};

/// Descriptor for `TopCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List topCardDescriptor = $convert.base64Decode(
    'CgdUb3BDYXJkEk4KDmxpc3Rlbl9oaXN0b3J5GAQgASgLMiUuYmlsaWJpbGkuYXBwLmxpc3Rlbm'
    'VyLnYxLlRwY2RIaXN0b3J5SABSDWxpc3Rlbkhpc3RvcnkSSAoKZmF2X2ZvbGRlchgFIAEoCzIn'
    'LmJpbGliaWxpLmFwcC5saXN0ZW5lci52MS5UcGNkRmF2Rm9sZGVySABSCWZhdkZvbGRlchJFCg'
    'l1cF9yZWNhbGwYBiABKAsyJi5iaWxpYmlsaS5hcHAubGlzdGVuZXIudjEuVHBjZFVwUmVjYWxs'
    'SABSCHVwUmVjYWxsEkgKCnBpY2tfdG9kYXkYByABKAsyJy5iaWxpYmlsaS5hcHAubGlzdGVuZX'
    'IudjEuVHBjZFBpY2tUb2RheUgAUglwaWNrVG9kYXkSFAoFdGl0bGUYASABKAlSBXRpdGxlEk0K'
    'CnBsYXlfc3R5bGUYAiABKA4yLi5iaWxpYmlsaS5hcHAubGlzdGVuZXIudjEuVG9wQ2FyZC5QbG'
    'F5U3RyYXRlZ3lSCXBsYXlTdHlsZRJCCgljYXJkX3R5cGUYAyABKA4yJS5iaWxpYmlsaS5hcHAu'
    'bGlzdGVuZXIudjEuVG9wQ2FyZFR5cGVSCGNhcmRUeXBlEhAKA3BvcxgIIAEoA1IDcG9zEh0KCn'
    'RpdGxlX2ljb24YCSABKAlSCXRpdGxlSWNvbiJBCgxQbGF5U3RyYXRlZ3kSEAoMTk9fSU5URVJS'
    'VVBUEAASDwoLUExBWV9UQVJHRVQQARIOCgpQTEFZX0ZJUlNUEAJCBgoEY2FyZA==');

@$core.Deprecated('Use tpcdFavFolderDescriptor instead')
const TpcdFavFolder$json = {
  '1': 'TpcdFavFolder',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.DetailItem',
      '10': 'item'
    },
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'pic', '3': 3, '4': 1, '5': 9, '10': 'pic'},
    {'1': 'fid', '3': 4, '4': 1, '5': 3, '10': 'fid'},
    {'1': 'folder_type', '3': 5, '4': 1, '5': 5, '10': 'folderType'},
  ],
};

/// Descriptor for `TpcdFavFolder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tpcdFavFolderDescriptor = $convert.base64Decode(
    'Cg1UcGNkRmF2Rm9sZGVyEjgKBGl0ZW0YASABKAsyJC5iaWxpYmlsaS5hcHAubGlzdGVuZXIudj'
    'EuRGV0YWlsSXRlbVIEaXRlbRISCgR0ZXh0GAIgASgJUgR0ZXh0EhAKA3BpYxgDIAEoCVIDcGlj'
    'EhAKA2ZpZBgEIAEoA1IDZmlkEh8KC2ZvbGRlcl90eXBlGAUgASgFUgpmb2xkZXJUeXBl');

@$core.Deprecated('Use tpcdHistoryDescriptor instead')
const TpcdHistory$json = {
  '1': 'TpcdHistory',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.DetailItem',
      '10': 'item'
    },
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'pic', '3': 3, '4': 1, '5': 9, '10': 'pic'},
  ],
};

/// Descriptor for `TpcdHistory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tpcdHistoryDescriptor = $convert.base64Decode(
    'CgtUcGNkSGlzdG9yeRI4CgRpdGVtGAEgASgLMiQuYmlsaWJpbGkuYXBwLmxpc3RlbmVyLnYxLk'
    'RldGFpbEl0ZW1SBGl0ZW0SEgoEdGV4dBgCIAEoCVIEdGV4dBIQCgNwaWMYAyABKAlSA3BpYw==');

@$core.Deprecated('Use tpcdPickTodayDescriptor instead')
const TpcdPickToday$json = {
  '1': 'TpcdPickToday',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.DetailItem',
      '10': 'item'
    },
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'pic', '3': 3, '4': 1, '5': 9, '10': 'pic'},
    {'1': 'pick_id', '3': 4, '4': 1, '5': 3, '10': 'pickId'},
    {'1': 'pick_card_id', '3': 5, '4': 1, '5': 3, '10': 'pickCardId'},
  ],
};

/// Descriptor for `TpcdPickToday`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tpcdPickTodayDescriptor = $convert.base64Decode(
    'Cg1UcGNkUGlja1RvZGF5EjgKBGl0ZW0YASABKAsyJC5iaWxpYmlsaS5hcHAubGlzdGVuZXIudj'
    'EuRGV0YWlsSXRlbVIEaXRlbRISCgR0ZXh0GAIgASgJUgR0ZXh0EhAKA3BpYxgDIAEoCVIDcGlj'
    'EhcKB3BpY2tfaWQYBCABKANSBnBpY2tJZBIgCgxwaWNrX2NhcmRfaWQYBSABKANSCnBpY2tDYX'
    'JkSWQ=');

@$core.Deprecated('Use tpcdUpRecallDescriptor instead')
const TpcdUpRecall$json = {
  '1': 'TpcdUpRecall',
  '2': [
    {'1': 'up_mid', '3': 1, '4': 1, '5': 3, '10': 'upMid'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'avatar', '3': 3, '4': 1, '5': 9, '10': 'avatar'},
    {'1': 'medialist_type', '3': 4, '4': 1, '5': 3, '10': 'medialistType'},
    {'1': 'medialist_biz_id', '3': 5, '4': 1, '5': 3, '10': 'medialistBizId'},
    {
      '1': 'item',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.listener.v1.DetailItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `TpcdUpRecall`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tpcdUpRecallDescriptor = $convert.base64Decode(
    'CgxUcGNkVXBSZWNhbGwSFQoGdXBfbWlkGAEgASgDUgV1cE1pZBISCgR0ZXh0GAIgASgJUgR0ZX'
    'h0EhYKBmF2YXRhchgDIAEoCVIGYXZhdGFyEiUKDm1lZGlhbGlzdF90eXBlGAQgASgDUg1tZWRp'
    'YWxpc3RUeXBlEigKEG1lZGlhbGlzdF9iaXpfaWQYBSABKANSDm1lZGlhbGlzdEJpeklkEjgKBG'
    'l0ZW0YBiABKAsyJC5iaWxpYmlsaS5hcHAubGlzdGVuZXIudjEuRGV0YWlsSXRlbVIEaXRlbQ==');

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
