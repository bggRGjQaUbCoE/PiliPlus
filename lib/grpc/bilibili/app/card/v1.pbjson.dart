// This is a generated file - do not edit.
//
// Generated from bilibili/app/card/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use adInfoDescriptor instead')
const AdInfo$json = {
  '1': 'AdInfo',
  '2': [
    {'1': 'creative_id', '3': 1, '4': 1, '5': 3, '10': 'creativeId'},
    {'1': 'creative_type', '3': 2, '4': 1, '5': 5, '10': 'creativeType'},
    {'1': 'card_type', '3': 3, '4': 1, '5': 5, '10': 'cardType'},
    {
      '1': 'creative_content',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.CreativeContent',
      '10': 'creativeContent'
    },
    {'1': 'ad_cb', '3': 5, '4': 1, '5': 9, '10': 'adCb'},
    {'1': 'resource', '3': 6, '4': 1, '5': 3, '10': 'resource'},
    {'1': 'source', '3': 7, '4': 1, '5': 5, '10': 'source'},
    {'1': 'request_id', '3': 8, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'is_ad', '3': 9, '4': 1, '5': 8, '10': 'isAd'},
    {'1': 'cm_mark', '3': 10, '4': 1, '5': 3, '10': 'cmMark'},
    {'1': 'index', '3': 11, '4': 1, '5': 5, '10': 'index'},
    {'1': 'is_ad_loc', '3': 12, '4': 1, '5': 8, '10': 'isAdLoc'},
    {'1': 'card_index', '3': 13, '4': 1, '5': 5, '10': 'cardIndex'},
    {'1': 'client_ip', '3': 14, '4': 1, '5': 9, '10': 'clientIp'},
    {'1': 'extra', '3': 15, '4': 1, '5': 12, '10': 'extra'},
    {'1': 'creative_style', '3': 16, '4': 1, '5': 5, '10': 'creativeStyle'},
    {'1': 'nature_ad', '3': 17, '4': 1, '5': 3, '10': 'natureAd'},
    {
      '1': 'content_fast_access',
      '3': 18,
      '4': 1,
      '5': 5,
      '10': 'contentFastAccess'
    },
  ],
};

/// Descriptor for `AdInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List adInfoDescriptor = $convert.base64Decode(
    'CgZBZEluZm8SHwoLY3JlYXRpdmVfaWQYASABKANSCmNyZWF0aXZlSWQSIwoNY3JlYXRpdmVfdH'
    'lwZRgCIAEoBVIMY3JlYXRpdmVUeXBlEhsKCWNhcmRfdHlwZRgDIAEoBVIIY2FyZFR5cGUSUAoQ'
    'Y3JlYXRpdmVfY29udGVudBgEIAEoCzIlLmJpbGliaWxpLmFwcC5jYXJkLnYxLkNyZWF0aXZlQ2'
    '9udGVudFIPY3JlYXRpdmVDb250ZW50EhMKBWFkX2NiGAUgASgJUgRhZENiEhoKCHJlc291cmNl'
    'GAYgASgDUghyZXNvdXJjZRIWCgZzb3VyY2UYByABKAVSBnNvdXJjZRIdCgpyZXF1ZXN0X2lkGA'
    'ggASgJUglyZXF1ZXN0SWQSEwoFaXNfYWQYCSABKAhSBGlzQWQSFwoHY21fbWFyaxgKIAEoA1IG'
    'Y21NYXJrEhQKBWluZGV4GAsgASgFUgVpbmRleBIaCglpc19hZF9sb2MYDCABKAhSB2lzQWRMb2'
    'MSHQoKY2FyZF9pbmRleBgNIAEoBVIJY2FyZEluZGV4EhsKCWNsaWVudF9pcBgOIAEoCVIIY2xp'
    'ZW50SXASFAoFZXh0cmEYDyABKAxSBWV4dHJhEiUKDmNyZWF0aXZlX3N0eWxlGBAgASgFUg1jcm'
    'VhdGl2ZVN0eWxlEhsKCW5hdHVyZV9hZBgRIAEoA1IIbmF0dXJlQWQSLgoTY29udGVudF9mYXN0'
    'X2FjY2VzcxgSIAEoBVIRY29udGVudEZhc3RBY2Nlc3M=');

@$core.Deprecated('Use argsDescriptor instead')
const Args$json = {
  '1': 'Args',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 5, '10': 'type'},
    {'1': 'up_id', '3': 2, '4': 1, '5': 3, '10': 'upId'},
    {'1': 'up_name', '3': 3, '4': 1, '5': 9, '10': 'upName'},
    {'1': 'rid', '3': 4, '4': 1, '5': 5, '10': 'rid'},
    {'1': 'rname', '3': 5, '4': 1, '5': 9, '10': 'rname'},
    {'1': 'tid', '3': 6, '4': 1, '5': 3, '10': 'tid'},
    {'1': 'tname', '3': 7, '4': 1, '5': 9, '10': 'tname'},
    {'1': 'track_id', '3': 8, '4': 1, '5': 9, '10': 'trackId'},
    {'1': 'state', '3': 9, '4': 1, '5': 9, '10': 'state'},
    {'1': 'converge_type', '3': 10, '4': 1, '5': 5, '10': 'convergeType'},
    {'1': 'aid', '3': 11, '4': 1, '5': 3, '10': 'aid'},
  ],
};

/// Descriptor for `Args`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List argsDescriptor = $convert.base64Decode(
    'CgRBcmdzEhIKBHR5cGUYASABKAVSBHR5cGUSEwoFdXBfaWQYAiABKANSBHVwSWQSFwoHdXBfbm'
    'FtZRgDIAEoCVIGdXBOYW1lEhAKA3JpZBgEIAEoBVIDcmlkEhQKBXJuYW1lGAUgASgJUgVybmFt'
    'ZRIQCgN0aWQYBiABKANSA3RpZBIUCgV0bmFtZRgHIAEoCVIFdG5hbWUSGQoIdHJhY2tfaWQYCC'
    'ABKAlSB3RyYWNrSWQSFAoFc3RhdGUYCSABKAlSBXN0YXRlEiMKDWNvbnZlcmdlX3R5cGUYCiAB'
    'KAVSDGNvbnZlcmdlVHlwZRIQCgNhaWQYCyABKANSA2FpZA==');

@$core.Deprecated('Use avatarDescriptor instead')
const Avatar$json = {
  '1': 'Avatar',
  '2': [
    {'1': 'cover', '3': 1, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'uri', '3': 3, '4': 1, '5': 9, '10': 'uri'},
    {'1': 'type', '3': 4, '4': 1, '5': 5, '10': 'type'},
    {'1': 'event', '3': 5, '4': 1, '5': 9, '10': 'event'},
    {'1': 'event_v2', '3': 6, '4': 1, '5': 9, '10': 'eventV2'},
    {'1': 'defalut_cover', '3': 7, '4': 1, '5': 5, '10': 'defalutCover'},
  ],
};

/// Descriptor for `Avatar`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List avatarDescriptor = $convert.base64Decode(
    'CgZBdmF0YXISFAoFY292ZXIYASABKAlSBWNvdmVyEhIKBHRleHQYAiABKAlSBHRleHQSEAoDdX'
    'JpGAMgASgJUgN1cmkSEgoEdHlwZRgEIAEoBVIEdHlwZRIUCgVldmVudBgFIAEoCVIFZXZlbnQS'
    'GQoIZXZlbnRfdjIYBiABKAlSB2V2ZW50VjISIwoNZGVmYWx1dF9jb3ZlchgHIAEoBVIMZGVmYW'
    'x1dENvdmVy');

@$core.Deprecated('Use baseDescriptor instead')
const Base$json = {
  '1': 'Base',
  '2': [
    {'1': 'card_type', '3': 1, '4': 1, '5': 9, '10': 'cardType'},
    {'1': 'card_goto', '3': 2, '4': 1, '5': 9, '10': 'cardGoto'},
    {'1': 'goto', '3': 3, '4': 1, '5': 9, '10': 'goto'},
    {'1': 'param', '3': 4, '4': 1, '5': 9, '10': 'param'},
    {'1': 'cover', '3': 5, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'title', '3': 6, '4': 1, '5': 9, '10': 'title'},
    {'1': 'uri', '3': 7, '4': 1, '5': 9, '10': 'uri'},
    {
      '1': 'three_point',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ThreePoint',
      '10': 'threePoint'
    },
    {
      '1': 'args',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Args',
      '10': 'args'
    },
    {
      '1': 'player_args',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.PlayerArgs',
      '10': 'playerArgs'
    },
    {'1': 'idx', '3': 11, '4': 1, '5': 3, '10': 'idx'},
    {
      '1': 'ad_info',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.AdInfo',
      '10': 'adInfo'
    },
    {
      '1': 'mask',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Mask',
      '10': 'mask'
    },
    {'1': 'from_type', '3': 14, '4': 1, '5': 9, '10': 'fromType'},
    {
      '1': 'three_point_v2',
      '3': 15,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.card.v1.ThreePointV2',
      '10': 'threePointV2'
    },
    {
      '1': 'three_point_v3',
      '3': 16,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.card.v1.ThreePointV3',
      '10': 'threePointV3'
    },
    {
      '1': 'desc_button',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Button',
      '10': 'descButton'
    },
    {
      '1': 'three_point_v4',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ThreePointV4',
      '10': 'threePointV4'
    },
    {
      '1': 'up_args',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.UpArgs',
      '10': 'upArgs'
    },
    {'1': 'track_id', '3': 20, '4': 1, '5': 9, '10': 'trackId'},
  ],
};

/// Descriptor for `Base`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List baseDescriptor = $convert.base64Decode(
    'CgRCYXNlEhsKCWNhcmRfdHlwZRgBIAEoCVIIY2FyZFR5cGUSGwoJY2FyZF9nb3RvGAIgASgJUg'
    'hjYXJkR290bxISCgRnb3RvGAMgASgJUgRnb3RvEhQKBXBhcmFtGAQgASgJUgVwYXJhbRIUCgVj'
    'b3ZlchgFIAEoCVIFY292ZXISFAoFdGl0bGUYBiABKAlSBXRpdGxlEhAKA3VyaRgHIAEoCVIDdX'
    'JpEkEKC3RocmVlX3BvaW50GAggASgLMiAuYmlsaWJpbGkuYXBwLmNhcmQudjEuVGhyZWVQb2lu'
    'dFIKdGhyZWVQb2ludBIuCgRhcmdzGAkgASgLMhouYmlsaWJpbGkuYXBwLmNhcmQudjEuQXJnc1'
    'IEYXJncxJBCgtwbGF5ZXJfYXJncxgKIAEoCzIgLmJpbGliaWxpLmFwcC5jYXJkLnYxLlBsYXll'
    'ckFyZ3NSCnBsYXllckFyZ3MSEAoDaWR4GAsgASgDUgNpZHgSNQoHYWRfaW5mbxgMIAEoCzIcLm'
    'JpbGliaWxpLmFwcC5jYXJkLnYxLkFkSW5mb1IGYWRJbmZvEi4KBG1hc2sYDSABKAsyGi5iaWxp'
    'YmlsaS5hcHAuY2FyZC52MS5NYXNrUgRtYXNrEhsKCWZyb21fdHlwZRgOIAEoCVIIZnJvbVR5cG'
    'USSAoOdGhyZWVfcG9pbnRfdjIYDyADKAsyIi5iaWxpYmlsaS5hcHAuY2FyZC52MS5UaHJlZVBv'
    'aW50VjJSDHRocmVlUG9pbnRWMhJICg50aHJlZV9wb2ludF92MxgQIAMoCzIiLmJpbGliaWxpLm'
    'FwcC5jYXJkLnYxLlRocmVlUG9pbnRWM1IMdGhyZWVQb2ludFYzEj0KC2Rlc2NfYnV0dG9uGBEg'
    'ASgLMhwuYmlsaWJpbGkuYXBwLmNhcmQudjEuQnV0dG9uUgpkZXNjQnV0dG9uEkgKDnRocmVlX3'
    'BvaW50X3Y0GBIgASgLMiIuYmlsaWJpbGkuYXBwLmNhcmQudjEuVGhyZWVQb2ludFY0Ugx0aHJl'
    'ZVBvaW50VjQSNQoHdXBfYXJncxgTIAEoCzIcLmJpbGliaWxpLmFwcC5jYXJkLnYxLlVwQXJnc1'
    'IGdXBBcmdzEhkKCHRyYWNrX2lkGBQgASgJUgd0cmFja0lk');

@$core.Deprecated('Use bubbleDescriptor instead')
const Bubble$json = {
  '1': 'Bubble',
  '2': [
    {'1': 'bubble_content', '3': 1, '4': 1, '5': 9, '10': 'bubbleContent'},
    {'1': 'version', '3': 2, '4': 1, '5': 5, '10': 'version'},
    {'1': 'stime', '3': 3, '4': 1, '5': 3, '10': 'stime'},
  ],
};

/// Descriptor for `Bubble`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bubbleDescriptor = $convert.base64Decode(
    'CgZCdWJibGUSJQoOYnViYmxlX2NvbnRlbnQYASABKAlSDWJ1YmJsZUNvbnRlbnQSGAoHdmVyc2'
    'lvbhgCIAEoBVIHdmVyc2lvbhIUCgVzdGltZRgDIAEoA1IFc3RpbWU=');

@$core.Deprecated('Use buttonDescriptor instead')
const Button$json = {
  '1': 'Button',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'param', '3': 2, '4': 1, '5': 9, '10': 'param'},
    {'1': 'uri', '3': 3, '4': 1, '5': 9, '10': 'uri'},
    {'1': 'event', '3': 4, '4': 1, '5': 9, '10': 'event'},
    {'1': 'selected', '3': 5, '4': 1, '5': 5, '10': 'selected'},
    {'1': 'type', '3': 6, '4': 1, '5': 5, '10': 'type'},
    {'1': 'event_v2', '3': 7, '4': 1, '5': 9, '10': 'eventV2'},
    {
      '1': 'relation',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Relation',
      '10': 'relation'
    },
  ],
};

/// Descriptor for `Button`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List buttonDescriptor = $convert.base64Decode(
    'CgZCdXR0b24SEgoEdGV4dBgBIAEoCVIEdGV4dBIUCgVwYXJhbRgCIAEoCVIFcGFyYW0SEAoDdX'
    'JpGAMgASgJUgN1cmkSFAoFZXZlbnQYBCABKAlSBWV2ZW50EhoKCHNlbGVjdGVkGAUgASgFUghz'
    'ZWxlY3RlZBISCgR0eXBlGAYgASgFUgR0eXBlEhkKCGV2ZW50X3YyGAcgASgJUgdldmVudFYyEj'
    'oKCHJlbGF0aW9uGAggASgLMh4uYmlsaWJpbGkuYXBwLmNhcmQudjEuUmVsYXRpb25SCHJlbGF0'
    'aW9u');

@$core.Deprecated('Use cardDescriptor instead')
const Card$json = {
  '1': 'Card',
  '2': [
    {
      '1': 'small_cover_v5',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.SmallCoverV5',
      '9': 0,
      '10': 'smallCoverV5'
    },
    {
      '1': 'large_cover_v1',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.LargeCoverV1',
      '9': 0,
      '10': 'largeCoverV1'
    },
    {
      '1': 'three_item_all_v2',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ThreeItemAllV2',
      '9': 0,
      '10': 'threeItemAllV2'
    },
    {
      '1': 'three_item_v1',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ThreeItemV1',
      '9': 0,
      '10': 'threeItemV1'
    },
    {
      '1': 'hot_topic',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.HotTopic',
      '9': 0,
      '10': 'hotTopic'
    },
    {
      '1': 'three_item_h_v5',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.DynamicHot',
      '9': 0,
      '10': 'threeItemHV5'
    },
    {
      '1': 'middle_cover_v3',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.MiddleCoverV3',
      '9': 0,
      '10': 'middleCoverV3'
    },
    {
      '1': 'large_cover_v4',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.LargeCoverV4',
      '9': 0,
      '10': 'largeCoverV4'
    },
    {
      '1': 'popular_top_entrance',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.PopularTopEntrance',
      '9': 0,
      '10': 'popularTopEntrance'
    },
    {
      '1': 'rcmd_one_item',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.RcmdOneItem',
      '9': 0,
      '10': 'rcmdOneItem'
    },
    {
      '1': 'small_cover_v5_ad',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.SmallCoverV5Ad',
      '9': 0,
      '10': 'smallCoverV5Ad'
    },
    {
      '1': 'topic_list',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.TopicList',
      '9': 0,
      '10': 'topicList'
    },
  ],
  '8': [
    {'1': 'item'},
  ],
};

/// Descriptor for `Card`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cardDescriptor = $convert.base64Decode(
    'CgRDYXJkEkoKDnNtYWxsX2NvdmVyX3Y1GAEgASgLMiIuYmlsaWJpbGkuYXBwLmNhcmQudjEuU2'
    '1hbGxDb3ZlclY1SABSDHNtYWxsQ292ZXJWNRJKCg5sYXJnZV9jb3Zlcl92MRgCIAEoCzIiLmJp'
    'bGliaWxpLmFwcC5jYXJkLnYxLkxhcmdlQ292ZXJWMUgAUgxsYXJnZUNvdmVyVjESUQoRdGhyZW'
    'VfaXRlbV9hbGxfdjIYAyABKAsyJC5iaWxpYmlsaS5hcHAuY2FyZC52MS5UaHJlZUl0ZW1BbGxW'
    'MkgAUg50aHJlZUl0ZW1BbGxWMhJHCg10aHJlZV9pdGVtX3YxGAQgASgLMiEuYmlsaWJpbGkuYX'
    'BwLmNhcmQudjEuVGhyZWVJdGVtVjFIAFILdGhyZWVJdGVtVjESPQoJaG90X3RvcGljGAUgASgL'
    'Mh4uYmlsaWJpbGkuYXBwLmNhcmQudjEuSG90VG9waWNIAFIIaG90VG9waWMSSQoPdGhyZWVfaX'
    'RlbV9oX3Y1GAYgASgLMiAuYmlsaWJpbGkuYXBwLmNhcmQudjEuRHluYW1pY0hvdEgAUgx0aHJl'
    'ZUl0ZW1IVjUSTQoPbWlkZGxlX2NvdmVyX3YzGAcgASgLMiMuYmlsaWJpbGkuYXBwLmNhcmQudj'
    'EuTWlkZGxlQ292ZXJWM0gAUg1taWRkbGVDb3ZlclYzEkoKDmxhcmdlX2NvdmVyX3Y0GAggASgL'
    'MiIuYmlsaWJpbGkuYXBwLmNhcmQudjEuTGFyZ2VDb3ZlclY0SABSDGxhcmdlQ292ZXJWNBJcCh'
    'Rwb3B1bGFyX3RvcF9lbnRyYW5jZRgJIAEoCzIoLmJpbGliaWxpLmFwcC5jYXJkLnYxLlBvcHVs'
    'YXJUb3BFbnRyYW5jZUgAUhJwb3B1bGFyVG9wRW50cmFuY2USRwoNcmNtZF9vbmVfaXRlbRgKIA'
    'EoCzIhLmJpbGliaWxpLmFwcC5jYXJkLnYxLlJjbWRPbmVJdGVtSABSC3JjbWRPbmVJdGVtElEK'
    'EXNtYWxsX2NvdmVyX3Y1X2FkGAsgASgLMiQuYmlsaWJpbGkuYXBwLmNhcmQudjEuU21hbGxDb3'
    'ZlclY1QWRIAFIOc21hbGxDb3ZlclY1QWQSQAoKdG9waWNfbGlzdBgMIAEoCzIfLmJpbGliaWxp'
    'LmFwcC5jYXJkLnYxLlRvcGljTGlzdEgAUgl0b3BpY0xpc3RCBgoEaXRlbQ==');

@$core.Deprecated('Use creativeContentDescriptor instead')
const CreativeContent$json = {
  '1': 'CreativeContent',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'video_id', '3': 3, '4': 1, '5': 3, '10': 'videoId'},
    {'1': 'username', '3': 4, '4': 1, '5': 9, '10': 'username'},
    {'1': 'image_url', '3': 5, '4': 1, '5': 9, '10': 'imageUrl'},
    {'1': 'image_md5', '3': 6, '4': 1, '5': 9, '10': 'imageMd5'},
    {'1': 'log_url', '3': 7, '4': 1, '5': 9, '10': 'logUrl'},
    {'1': 'log_md5', '3': 8, '4': 1, '5': 9, '10': 'logMd5'},
    {'1': 'url', '3': 9, '4': 1, '5': 9, '10': 'url'},
    {'1': 'click_url', '3': 10, '4': 1, '5': 9, '10': 'clickUrl'},
    {'1': 'show_url', '3': 11, '4': 1, '5': 9, '10': 'showUrl'},
  ],
};

/// Descriptor for `CreativeContent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List creativeContentDescriptor = $convert.base64Decode(
    'Cg9DcmVhdGl2ZUNvbnRlbnQSFAoFdGl0bGUYASABKAlSBXRpdGxlEiAKC2Rlc2NyaXB0aW9uGA'
    'IgASgJUgtkZXNjcmlwdGlvbhIZCgh2aWRlb19pZBgDIAEoA1IHdmlkZW9JZBIaCgh1c2VybmFt'
    'ZRgEIAEoCVIIdXNlcm5hbWUSGwoJaW1hZ2VfdXJsGAUgASgJUghpbWFnZVVybBIbCglpbWFnZV'
    '9tZDUYBiABKAlSCGltYWdlTWQ1EhcKB2xvZ191cmwYByABKAlSBmxvZ1VybBIXCgdsb2dfbWQ1'
    'GAggASgJUgZsb2dNZDUSEAoDdXJsGAkgASgJUgN1cmwSGwoJY2xpY2tfdXJsGAogASgJUghjbG'
    'lja1VybBIZCghzaG93X3VybBgLIAEoCVIHc2hvd1VybA==');

@$core.Deprecated('Use dislikeReasonDescriptor instead')
const DislikeReason$json = {
  '1': 'DislikeReason',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `DislikeReason`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dislikeReasonDescriptor = $convert.base64Decode(
    'Cg1EaXNsaWtlUmVhc29uEg4KAmlkGAEgASgDUgJpZBISCgRuYW1lGAIgASgJUgRuYW1l');

@$core.Deprecated('Use doubleCardsDescriptor instead')
const DoubleCards$json = {
  '1': 'DoubleCards',
  '2': [
    {
      '1': 'small_cover_v2',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.SmallCoverV2',
      '9': 0,
      '10': 'smallCoverV2'
    },
    {
      '1': 'one_pic_v2',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.OnePicV2',
      '9': 0,
      '10': 'onePicV2'
    },
    {
      '1': 'three_pic_v2',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ThreePicV2',
      '9': 0,
      '10': 'threePicV2'
    },
  ],
  '8': [
    {'1': 'card'},
  ],
};

/// Descriptor for `DoubleCards`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List doubleCardsDescriptor = $convert.base64Decode(
    'CgtEb3VibGVDYXJkcxJKCg5zbWFsbF9jb3Zlcl92MhgBIAEoCzIiLmJpbGliaWxpLmFwcC5jYX'
    'JkLnYxLlNtYWxsQ292ZXJWMkgAUgxzbWFsbENvdmVyVjISPgoKb25lX3BpY192MhgCIAEoCzIe'
    'LmJpbGliaWxpLmFwcC5jYXJkLnYxLk9uZVBpY1YySABSCG9uZVBpY1YyEkQKDHRocmVlX3BpY1'
    '92MhgDIAEoCzIgLmJpbGliaWxpLmFwcC5jYXJkLnYxLlRocmVlUGljVjJIAFIKdGhyZWVQaWNW'
    'MkIGCgRjYXJk');

@$core.Deprecated('Use dynamicHotDescriptor instead')
const DynamicHot$json = {
  '1': 'DynamicHot',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'top_left_title', '3': 2, '4': 1, '5': 9, '10': 'topLeftTitle'},
    {'1': 'desc1', '3': 3, '4': 1, '5': 9, '10': 'desc1'},
    {'1': 'desc2', '3': 4, '4': 1, '5': 9, '10': 'desc2'},
    {'1': 'more_uri', '3': 5, '4': 1, '5': 9, '10': 'moreUri'},
    {'1': 'more_text', '3': 6, '4': 1, '5': 9, '10': 'moreText'},
    {'1': 'covers', '3': 7, '4': 3, '5': 9, '10': 'covers'},
    {'1': 'cover_right_text', '3': 8, '4': 1, '5': 9, '10': 'coverRightText'},
    {
      '1': 'top_rcmd_reason_style',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'topRcmdReasonStyle'
    },
  ],
};

/// Descriptor for `DynamicHot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dynamicHotDescriptor = $convert.base64Decode(
    'CgpEeW5hbWljSG90Ei4KBGJhc2UYASABKAsyGi5iaWxpYmlsaS5hcHAuY2FyZC52MS5CYXNlUg'
    'RiYXNlEiQKDnRvcF9sZWZ0X3RpdGxlGAIgASgJUgx0b3BMZWZ0VGl0bGUSFAoFZGVzYzEYAyAB'
    'KAlSBWRlc2MxEhQKBWRlc2MyGAQgASgJUgVkZXNjMhIZCghtb3JlX3VyaRgFIAEoCVIHbW9yZV'
    'VyaRIbCgltb3JlX3RleHQYBiABKAlSCG1vcmVUZXh0EhYKBmNvdmVycxgHIAMoCVIGY292ZXJz'
    'EigKEGNvdmVyX3JpZ2h0X3RleHQYCCABKAlSDmNvdmVyUmlnaHRUZXh0ElQKFXRvcF9yY21kX3'
    'JlYXNvbl9zdHlsZRgJIAEoCzIhLmJpbGliaWxpLmFwcC5jYXJkLnYxLlJlYXNvblN0eWxlUhJ0'
    'b3BSY21kUmVhc29uU3R5bGU=');

@$core.Deprecated('Use entranceItemDescriptor instead')
const EntranceItem$json = {
  '1': 'EntranceItem',
  '2': [
    {'1': 'goto', '3': 1, '4': 1, '5': 9, '10': 'goto'},
    {'1': 'icon', '3': 2, '4': 1, '5': 9, '10': 'icon'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'module_id', '3': 4, '4': 1, '5': 9, '10': 'moduleId'},
    {'1': 'uri', '3': 5, '4': 1, '5': 9, '10': 'uri'},
    {'1': 'entrance_id', '3': 6, '4': 1, '5': 3, '10': 'entranceId'},
    {
      '1': 'bubble',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Bubble',
      '10': 'bubble'
    },
    {'1': 'entrance_type', '3': 8, '4': 1, '5': 5, '10': 'entranceType'},
  ],
};

/// Descriptor for `EntranceItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entranceItemDescriptor = $convert.base64Decode(
    'CgxFbnRyYW5jZUl0ZW0SEgoEZ290bxgBIAEoCVIEZ290bxISCgRpY29uGAIgASgJUgRpY29uEh'
    'QKBXRpdGxlGAMgASgJUgV0aXRsZRIbCgltb2R1bGVfaWQYBCABKAlSCG1vZHVsZUlkEhAKA3Vy'
    'aRgFIAEoCVIDdXJpEh8KC2VudHJhbmNlX2lkGAYgASgDUgplbnRyYW5jZUlkEjQKBmJ1YmJsZR'
    'gHIAEoCzIcLmJpbGliaWxpLmFwcC5jYXJkLnYxLkJ1YmJsZVIGYnViYmxlEiMKDWVudHJhbmNl'
    'X3R5cGUYCCABKAVSDGVudHJhbmNlVHlwZQ==');

@$core.Deprecated('Use functionalButtonDescriptor instead')
const FunctionalButton$json = {
  '1': 'FunctionalButton',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 5, '10': 'type'},
    {
      '1': 'button_metas',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.card.v1.FunctionalButtonMeta',
      '10': 'buttonMetas'
    },
  ],
};

/// Descriptor for `FunctionalButton`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List functionalButtonDescriptor = $convert.base64Decode(
    'ChBGdW5jdGlvbmFsQnV0dG9uEhIKBHR5cGUYASABKAVSBHR5cGUSTQoMYnV0dG9uX21ldGFzGA'
    'IgAygLMiouYmlsaWJpbGkuYXBwLmNhcmQudjEuRnVuY3Rpb25hbEJ1dHRvbk1ldGFSC2J1dHRv'
    'bk1ldGFz');

@$core.Deprecated('Use functionalButtonMetaDescriptor instead')
const FunctionalButtonMeta$json = {
  '1': 'FunctionalButtonMeta',
  '2': [
    {'1': 'icon', '3': 1, '4': 1, '5': 9, '10': 'icon'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'button_status', '3': 3, '4': 1, '5': 9, '10': 'buttonStatus'},
    {'1': 'toast', '3': 4, '4': 1, '5': 9, '10': 'toast'},
  ],
};

/// Descriptor for `FunctionalButtonMeta`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List functionalButtonMetaDescriptor = $convert.base64Decode(
    'ChRGdW5jdGlvbmFsQnV0dG9uTWV0YRISCgRpY29uGAEgASgJUgRpY29uEhIKBHRleHQYAiABKA'
    'lSBHRleHQSIwoNYnV0dG9uX3N0YXR1cxgDIAEoCVIMYnV0dG9uU3RhdHVzEhQKBXRvYXN0GAQg'
    'ASgJUgV0b2FzdA==');

@$core.Deprecated('Use hotTopicDescriptor instead')
const HotTopic$json = {
  '1': 'HotTopic',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'desc', '3': 2, '4': 1, '5': 9, '10': 'desc'},
    {
      '1': 'items',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.card.v1.HotTopicItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `HotTopic`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hotTopicDescriptor = $convert.base64Decode(
    'CghIb3RUb3BpYxIuCgRiYXNlGAEgASgLMhouYmlsaWJpbGkuYXBwLmNhcmQudjEuQmFzZVIEYm'
    'FzZRISCgRkZXNjGAIgASgJUgRkZXNjEjgKBWl0ZW1zGAMgAygLMiIuYmlsaWJpbGkuYXBwLmNh'
    'cmQudjEuSG90VG9waWNJdGVtUgVpdGVtcw==');

@$core.Deprecated('Use hotTopicItemDescriptor instead')
const HotTopicItem$json = {
  '1': 'HotTopicItem',
  '2': [
    {'1': 'cover', '3': 1, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'uri', '3': 2, '4': 1, '5': 9, '10': 'uri'},
    {'1': 'param', '3': 3, '4': 1, '5': 9, '10': 'param'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `HotTopicItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hotTopicItemDescriptor = $convert.base64Decode(
    'CgxIb3RUb3BpY0l0ZW0SFAoFY292ZXIYASABKAlSBWNvdmVyEhAKA3VyaRgCIAEoCVIDdXJpEh'
    'QKBXBhcmFtGAMgASgJUgVwYXJhbRISCgRuYW1lGAQgASgJUgRuYW1l');

@$core.Deprecated('Use hotwordEntranceDescriptor instead')
const HotwordEntrance$json = {
  '1': 'HotwordEntrance',
  '2': [
    {'1': 'hotword_id', '3': 1, '4': 1, '5': 3, '10': 'hotwordId'},
    {'1': 'hot_text', '3': 2, '4': 1, '5': 9, '10': 'hotText'},
    {'1': 'h5_url', '3': 3, '4': 1, '5': 9, '10': 'h5Url'},
    {'1': 'icon', '3': 4, '4': 1, '5': 9, '10': 'icon'},
  ],
};

/// Descriptor for `HotwordEntrance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hotwordEntranceDescriptor = $convert.base64Decode(
    'Cg9Ib3R3b3JkRW50cmFuY2USHQoKaG90d29yZF9pZBgBIAEoA1IJaG90d29yZElkEhkKCGhvdF'
    '90ZXh0GAIgASgJUgdob3RUZXh0EhUKBmg1X3VybBgDIAEoCVIFaDVVcmwSEgoEaWNvbhgEIAEo'
    'CVIEaWNvbg==');

@$core.Deprecated('Use inlineProgressBarDescriptor instead')
const InlineProgressBar$json = {
  '1': 'InlineProgressBar',
  '2': [
    {'1': 'icon_drag', '3': 1, '4': 1, '5': 9, '10': 'iconDrag'},
    {'1': 'icon_drag_hash', '3': 2, '4': 1, '5': 9, '10': 'iconDragHash'},
    {'1': 'icon_stop', '3': 3, '4': 1, '5': 9, '10': 'iconStop'},
    {'1': 'icon_stop_hash', '3': 4, '4': 1, '5': 9, '10': 'iconStopHash'},
  ],
};

/// Descriptor for `InlineProgressBar`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inlineProgressBarDescriptor = $convert.base64Decode(
    'ChFJbmxpbmVQcm9ncmVzc0JhchIbCglpY29uX2RyYWcYASABKAlSCGljb25EcmFnEiQKDmljb2'
    '5fZHJhZ19oYXNoGAIgASgJUgxpY29uRHJhZ0hhc2gSGwoJaWNvbl9zdG9wGAMgASgJUghpY29u'
    'U3RvcBIkCg5pY29uX3N0b3BfaGFzaBgEIAEoCVIMaWNvblN0b3BIYXNo');

@$core.Deprecated('Use largeCoverV1Descriptor instead')
const LargeCoverV1$json = {
  '1': 'LargeCoverV1',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'cover_gif', '3': 2, '4': 1, '5': 9, '10': 'coverGif'},
    {
      '1': 'avatar',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Avatar',
      '10': 'avatar'
    },
    {'1': 'cover_left_text1', '3': 4, '4': 1, '5': 9, '10': 'coverLeftText1'},
    {'1': 'cover_left_text2', '3': 5, '4': 1, '5': 9, '10': 'coverLeftText2'},
    {'1': 'cover_left_text3', '3': 6, '4': 1, '5': 9, '10': 'coverLeftText3'},
    {'1': 'cover_badge', '3': 7, '4': 1, '5': 9, '10': 'coverBadge'},
    {'1': 'top_rcmd_reason', '3': 8, '4': 1, '5': 9, '10': 'topRcmdReason'},
    {
      '1': 'bottom_rcmd_reason',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'bottomRcmdReason'
    },
    {'1': 'desc', '3': 10, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'official_icon', '3': 11, '4': 1, '5': 5, '10': 'officialIcon'},
    {'1': 'can_play', '3': 12, '4': 1, '5': 5, '10': 'canPlay'},
    {
      '1': 'top_rcmd_reason_style',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'topRcmdReasonStyle'
    },
    {
      '1': 'bottom_rcmd_reason_style',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'bottomRcmdReasonStyle'
    },
    {
      '1': 'rcmd_reason_style_v2',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'rcmdReasonStyleV2'
    },
    {
      '1': 'left_cover_badge_style',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'leftCoverBadgeStyle'
    },
    {
      '1': 'right_cover_badge_style',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'rightCoverBadgeStyle'
    },
    {'1': 'cover_badge2', '3': 18, '4': 1, '5': 9, '10': 'coverBadge2'},
    {
      '1': 'like_button',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.LikeButton',
      '10': 'likeButton'
    },
    {
      '1': 'title_single_line',
      '3': 20,
      '4': 1,
      '5': 5,
      '10': 'titleSingleLine'
    },
    {'1': 'cover_right_text', '3': 21, '4': 1, '5': 9, '10': 'coverRightText'},
  ],
};

/// Descriptor for `LargeCoverV1`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List largeCoverV1Descriptor = $convert.base64Decode(
    'CgxMYXJnZUNvdmVyVjESLgoEYmFzZRgBIAEoCzIaLmJpbGliaWxpLmFwcC5jYXJkLnYxLkJhc2'
    'VSBGJhc2USGwoJY292ZXJfZ2lmGAIgASgJUghjb3ZlckdpZhI0CgZhdmF0YXIYAyABKAsyHC5i'
    'aWxpYmlsaS5hcHAuY2FyZC52MS5BdmF0YXJSBmF2YXRhchIoChBjb3Zlcl9sZWZ0X3RleHQxGA'
    'QgASgJUg5jb3ZlckxlZnRUZXh0MRIoChBjb3Zlcl9sZWZ0X3RleHQyGAUgASgJUg5jb3Zlckxl'
    'ZnRUZXh0MhIoChBjb3Zlcl9sZWZ0X3RleHQzGAYgASgJUg5jb3ZlckxlZnRUZXh0MxIfCgtjb3'
    'Zlcl9iYWRnZRgHIAEoCVIKY292ZXJCYWRnZRImCg90b3BfcmNtZF9yZWFzb24YCCABKAlSDXRv'
    'cFJjbWRSZWFzb24SLAoSYm90dG9tX3JjbWRfcmVhc29uGAkgASgJUhBib3R0b21SY21kUmVhc2'
    '9uEhIKBGRlc2MYCiABKAlSBGRlc2MSIwoNb2ZmaWNpYWxfaWNvbhgLIAEoBVIMb2ZmaWNpYWxJ'
    'Y29uEhkKCGNhbl9wbGF5GAwgASgFUgdjYW5QbGF5ElQKFXRvcF9yY21kX3JlYXNvbl9zdHlsZR'
    'gNIAEoCzIhLmJpbGliaWxpLmFwcC5jYXJkLnYxLlJlYXNvblN0eWxlUhJ0b3BSY21kUmVhc29u'
    'U3R5bGUSWgoYYm90dG9tX3JjbWRfcmVhc29uX3N0eWxlGA4gASgLMiEuYmlsaWJpbGkuYXBwLm'
    'NhcmQudjEuUmVhc29uU3R5bGVSFWJvdHRvbVJjbWRSZWFzb25TdHlsZRJSChRyY21kX3JlYXNv'
    'bl9zdHlsZV92MhgPIAEoCzIhLmJpbGliaWxpLmFwcC5jYXJkLnYxLlJlYXNvblN0eWxlUhFyY2'
    '1kUmVhc29uU3R5bGVWMhJWChZsZWZ0X2NvdmVyX2JhZGdlX3N0eWxlGBAgASgLMiEuYmlsaWJp'
    'bGkuYXBwLmNhcmQudjEuUmVhc29uU3R5bGVSE2xlZnRDb3ZlckJhZGdlU3R5bGUSWAoXcmlnaH'
    'RfY292ZXJfYmFkZ2Vfc3R5bGUYESABKAsyIS5iaWxpYmlsaS5hcHAuY2FyZC52MS5SZWFzb25T'
    'dHlsZVIUcmlnaHRDb3ZlckJhZGdlU3R5bGUSIQoMY292ZXJfYmFkZ2UyGBIgASgJUgtjb3Zlck'
    'JhZGdlMhJBCgtsaWtlX2J1dHRvbhgTIAEoCzIgLmJpbGliaWxpLmFwcC5jYXJkLnYxLkxpa2VC'
    'dXR0b25SCmxpa2VCdXR0b24SKgoRdGl0bGVfc2luZ2xlX2xpbmUYFCABKAVSD3RpdGxlU2luZ2'
    'xlTGluZRIoChBjb3Zlcl9yaWdodF90ZXh0GBUgASgJUg5jb3ZlclJpZ2h0VGV4dA==');

@$core.Deprecated('Use largeCoverV2Descriptor instead')
const LargeCoverV2$json = {
  '1': 'LargeCoverV2',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {
      '1': 'avatar',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Avatar',
      '10': 'avatar'
    },
    {'1': 'badge', '3': 3, '4': 1, '5': 9, '10': 'badge'},
    {
      '1': 'cover_right_button',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Button',
      '10': 'coverRightButton'
    },
    {'1': 'cover_left_text1', '3': 5, '4': 1, '5': 9, '10': 'coverLeftText1'},
    {'1': 'cover_left_icon1', '3': 6, '4': 1, '5': 5, '10': 'coverLeftIcon1'},
    {'1': 'cover_left_text2', '3': 7, '4': 1, '5': 9, '10': 'coverLeftText2'},
    {'1': 'cover_left_icon2', '3': 8, '4': 1, '5': 5, '10': 'coverLeftIcon2'},
    {'1': 'rcmd_reason', '3': 9, '4': 1, '5': 9, '10': 'rcmdReason'},
    {'1': 'official_icon', '3': 10, '4': 1, '5': 5, '10': 'officialIcon'},
    {'1': 'can_play', '3': 11, '4': 1, '5': 5, '10': 'canPlay'},
    {
      '1': 'rcmd_reason_style',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'rcmdReasonStyle'
    },
    {'1': 'show_top', '3': 13, '4': 1, '5': 5, '10': 'showTop'},
    {'1': 'show_bottom', '3': 14, '4': 1, '5': 5, '10': 'showBottom'},
  ],
};

/// Descriptor for `LargeCoverV2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List largeCoverV2Descriptor = $convert.base64Decode(
    'CgxMYXJnZUNvdmVyVjISLgoEYmFzZRgBIAEoCzIaLmJpbGliaWxpLmFwcC5jYXJkLnYxLkJhc2'
    'VSBGJhc2USNAoGYXZhdGFyGAIgASgLMhwuYmlsaWJpbGkuYXBwLmNhcmQudjEuQXZhdGFyUgZh'
    'dmF0YXISFAoFYmFkZ2UYAyABKAlSBWJhZGdlEkoKEmNvdmVyX3JpZ2h0X2J1dHRvbhgEIAEoCz'
    'IcLmJpbGliaWxpLmFwcC5jYXJkLnYxLkJ1dHRvblIQY292ZXJSaWdodEJ1dHRvbhIoChBjb3Zl'
    'cl9sZWZ0X3RleHQxGAUgASgJUg5jb3ZlckxlZnRUZXh0MRIoChBjb3Zlcl9sZWZ0X2ljb24xGA'
    'YgASgFUg5jb3ZlckxlZnRJY29uMRIoChBjb3Zlcl9sZWZ0X3RleHQyGAcgASgJUg5jb3Zlckxl'
    'ZnRUZXh0MhIoChBjb3Zlcl9sZWZ0X2ljb24yGAggASgFUg5jb3ZlckxlZnRJY29uMhIfCgtyY2'
    '1kX3JlYXNvbhgJIAEoCVIKcmNtZFJlYXNvbhIjCg1vZmZpY2lhbF9pY29uGAogASgFUgxvZmZp'
    'Y2lhbEljb24SGQoIY2FuX3BsYXkYCyABKAVSB2NhblBsYXkSTQoRcmNtZF9yZWFzb25fc3R5bG'
    'UYDCABKAsyIS5iaWxpYmlsaS5hcHAuY2FyZC52MS5SZWFzb25TdHlsZVIPcmNtZFJlYXNvblN0'
    'eWxlEhkKCHNob3dfdG9wGA0gASgFUgdzaG93VG9wEh8KC3Nob3dfYm90dG9tGA4gASgFUgpzaG'
    '93Qm90dG9t');

@$core.Deprecated('Use largeCoverV3Descriptor instead')
const LargeCoverV3$json = {
  '1': 'LargeCoverV3',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'cover_gif', '3': 2, '4': 1, '5': 9, '10': 'coverGif'},
    {
      '1': 'avatar',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Avatar',
      '10': 'avatar'
    },
    {
      '1': 'top_rcmd_reason_style',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'topRcmdReasonStyle'
    },
    {
      '1': 'bottom_rcmd_reason_style',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'bottomRcmdReasonStyle'
    },
    {'1': 'cover_left_text1', '3': 6, '4': 1, '5': 9, '10': 'coverLeftText1'},
    {'1': 'cover_left_icon1', '3': 7, '4': 1, '5': 5, '10': 'coverLeftIcon1'},
    {'1': 'cover_left_text2', '3': 8, '4': 1, '5': 9, '10': 'coverLeftText2'},
    {'1': 'cover_left_icon2', '3': 9, '4': 1, '5': 5, '10': 'coverLeftIcon2'},
    {'1': 'cover_right_text', '3': 10, '4': 1, '5': 9, '10': 'coverRightText'},
    {'1': 'desc', '3': 11, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'official_icon', '3': 12, '4': 1, '5': 5, '10': 'officialIcon'},
  ],
};

/// Descriptor for `LargeCoverV3`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List largeCoverV3Descriptor = $convert.base64Decode(
    'CgxMYXJnZUNvdmVyVjMSLgoEYmFzZRgBIAEoCzIaLmJpbGliaWxpLmFwcC5jYXJkLnYxLkJhc2'
    'VSBGJhc2USGwoJY292ZXJfZ2lmGAIgASgJUghjb3ZlckdpZhI0CgZhdmF0YXIYAyABKAsyHC5i'
    'aWxpYmlsaS5hcHAuY2FyZC52MS5BdmF0YXJSBmF2YXRhchJUChV0b3BfcmNtZF9yZWFzb25fc3'
    'R5bGUYBCABKAsyIS5iaWxpYmlsaS5hcHAuY2FyZC52MS5SZWFzb25TdHlsZVISdG9wUmNtZFJl'
    'YXNvblN0eWxlEloKGGJvdHRvbV9yY21kX3JlYXNvbl9zdHlsZRgFIAEoCzIhLmJpbGliaWxpLm'
    'FwcC5jYXJkLnYxLlJlYXNvblN0eWxlUhVib3R0b21SY21kUmVhc29uU3R5bGUSKAoQY292ZXJf'
    'bGVmdF90ZXh0MRgGIAEoCVIOY292ZXJMZWZ0VGV4dDESKAoQY292ZXJfbGVmdF9pY29uMRgHIA'
    'EoBVIOY292ZXJMZWZ0SWNvbjESKAoQY292ZXJfbGVmdF90ZXh0MhgIIAEoCVIOY292ZXJMZWZ0'
    'VGV4dDISKAoQY292ZXJfbGVmdF9pY29uMhgJIAEoBVIOY292ZXJMZWZ0SWNvbjISKAoQY292ZX'
    'JfcmlnaHRfdGV4dBgKIAEoCVIOY292ZXJSaWdodFRleHQSEgoEZGVzYxgLIAEoCVIEZGVzYxIj'
    'Cg1vZmZpY2lhbF9pY29uGAwgASgFUgxvZmZpY2lhbEljb24=');

@$core.Deprecated('Use largeCoverV4Descriptor instead')
const LargeCoverV4$json = {
  '1': 'LargeCoverV4',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'cover_left_text1', '3': 2, '4': 1, '5': 9, '10': 'coverLeftText1'},
    {'1': 'cover_left_text2', '3': 3, '4': 1, '5': 9, '10': 'coverLeftText2'},
    {'1': 'cover_left_text3', '3': 4, '4': 1, '5': 9, '10': 'coverLeftText3'},
    {'1': 'cover_badge', '3': 5, '4': 1, '5': 9, '10': 'coverBadge'},
    {'1': 'can_play', '3': 6, '4': 1, '5': 5, '10': 'canPlay'},
    {
      '1': 'up',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Up',
      '10': 'up'
    },
    {'1': 'short_link', '3': 8, '4': 1, '5': 9, '10': 'shortLink'},
    {'1': 'share_subtitle', '3': 9, '4': 1, '5': 9, '10': 'shareSubtitle'},
    {'1': 'play_number', '3': 10, '4': 1, '5': 9, '10': 'playNumber'},
    {'1': 'bvid', '3': 11, '4': 1, '5': 9, '10': 'bvid'},
    {'1': 'sub_param', '3': 12, '4': 1, '5': 9, '10': 'subParam'},
  ],
};

/// Descriptor for `LargeCoverV4`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List largeCoverV4Descriptor = $convert.base64Decode(
    'CgxMYXJnZUNvdmVyVjQSLgoEYmFzZRgBIAEoCzIaLmJpbGliaWxpLmFwcC5jYXJkLnYxLkJhc2'
    'VSBGJhc2USKAoQY292ZXJfbGVmdF90ZXh0MRgCIAEoCVIOY292ZXJMZWZ0VGV4dDESKAoQY292'
    'ZXJfbGVmdF90ZXh0MhgDIAEoCVIOY292ZXJMZWZ0VGV4dDISKAoQY292ZXJfbGVmdF90ZXh0Mx'
    'gEIAEoCVIOY292ZXJMZWZ0VGV4dDMSHwoLY292ZXJfYmFkZ2UYBSABKAlSCmNvdmVyQmFkZ2US'
    'GQoIY2FuX3BsYXkYBiABKAVSB2NhblBsYXkSKAoCdXAYByABKAsyGC5iaWxpYmlsaS5hcHAuY2'
    'FyZC52MS5VcFICdXASHQoKc2hvcnRfbGluaxgIIAEoCVIJc2hvcnRMaW5rEiUKDnNoYXJlX3N1'
    'YnRpdGxlGAkgASgJUg1zaGFyZVN1YnRpdGxlEh8KC3BsYXlfbnVtYmVyGAogASgJUgpwbGF5Tn'
    'VtYmVyEhIKBGJ2aWQYCyABKAlSBGJ2aWQSGwoJc3ViX3BhcmFtGAwgASgJUghzdWJQYXJhbQ==');

@$core.Deprecated('Use likeButtonDescriptor instead')
const LikeButton$json = {
  '1': 'LikeButton',
  '2': [
    {'1': 'aid', '3': 1, '4': 1, '5': 3, '10': 'aid'},
    {'1': 'count', '3': 2, '4': 1, '5': 5, '10': 'count'},
    {'1': 'show_count', '3': 3, '4': 1, '5': 8, '10': 'showCount'},
    {'1': 'event', '3': 4, '4': 1, '5': 9, '10': 'event'},
    {'1': 'selected', '3': 5, '4': 1, '5': 5, '10': 'selected'},
    {'1': 'event_v2', '3': 6, '4': 1, '5': 9, '10': 'eventV2'},
  ],
};

/// Descriptor for `LikeButton`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List likeButtonDescriptor = $convert.base64Decode(
    'CgpMaWtlQnV0dG9uEhAKA2FpZBgBIAEoA1IDYWlkEhQKBWNvdW50GAIgASgFUgVjb3VudBIdCg'
    'pzaG93X2NvdW50GAMgASgIUglzaG93Q291bnQSFAoFZXZlbnQYBCABKAlSBWV2ZW50EhoKCHNl'
    'bGVjdGVkGAUgASgFUghzZWxlY3RlZBIZCghldmVudF92MhgGIAEoCVIHZXZlbnRWMg==');

@$core.Deprecated('Use maskDescriptor instead')
const Mask$json = {
  '1': 'Mask',
  '2': [
    {
      '1': 'avatar',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Avatar',
      '10': 'avatar'
    },
    {
      '1': 'button',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Button',
      '10': 'button'
    },
  ],
};

/// Descriptor for `Mask`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List maskDescriptor = $convert.base64Decode(
    'CgRNYXNrEjQKBmF2YXRhchgBIAEoCzIcLmJpbGliaWxpLmFwcC5jYXJkLnYxLkF2YXRhclIGYX'
    'ZhdGFyEjQKBmJ1dHRvbhgCIAEoCzIcLmJpbGliaWxpLmFwcC5jYXJkLnYxLkJ1dHRvblIGYnV0'
    'dG9u');

@$core.Deprecated('Use middleCoverV2Descriptor instead')
const MiddleCoverV2$json = {
  '1': 'MiddleCoverV2',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'ratio', '3': 2, '4': 1, '5': 5, '10': 'ratio'},
    {'1': 'desc', '3': 3, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'badge', '3': 4, '4': 1, '5': 9, '10': 'badge'},
  ],
};

/// Descriptor for `MiddleCoverV2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List middleCoverV2Descriptor = $convert.base64Decode(
    'Cg1NaWRkbGVDb3ZlclYyEi4KBGJhc2UYASABKAsyGi5iaWxpYmlsaS5hcHAuY2FyZC52MS5CYX'
    'NlUgRiYXNlEhQKBXJhdGlvGAIgASgFUgVyYXRpbxISCgRkZXNjGAMgASgJUgRkZXNjEhQKBWJh'
    'ZGdlGAQgASgJUgViYWRnZQ==');

@$core.Deprecated('Use middleCoverV3Descriptor instead')
const MiddleCoverV3$json = {
  '1': 'MiddleCoverV3',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'desc1', '3': 2, '4': 1, '5': 9, '10': 'desc1'},
    {'1': 'desc2', '3': 3, '4': 1, '5': 9, '10': 'desc2'},
    {
      '1': 'cover_badge_style',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'coverBadgeStyle'
    },
  ],
};

/// Descriptor for `MiddleCoverV3`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List middleCoverV3Descriptor = $convert.base64Decode(
    'Cg1NaWRkbGVDb3ZlclYzEi4KBGJhc2UYASABKAsyGi5iaWxpYmlsaS5hcHAuY2FyZC52MS5CYX'
    'NlUgRiYXNlEhQKBWRlc2MxGAIgASgJUgVkZXNjMRIUCgVkZXNjMhgDIAEoCVIFZGVzYzISTQoR'
    'Y292ZXJfYmFkZ2Vfc3R5bGUYBCABKAsyIS5iaWxpYmlsaS5hcHAuY2FyZC52MS5SZWFzb25TdH'
    'lsZVIPY292ZXJCYWRnZVN0eWxl');

@$core.Deprecated('Use multiItemDescriptor instead')
const MultiItem$json = {
  '1': 'MultiItem',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'more_uri', '3': 2, '4': 1, '5': 9, '10': 'moreUri'},
    {'1': 'more_text', '3': 3, '4': 1, '5': 9, '10': 'moreText'},
    {
      '1': 'items',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.card.v1.DoubleCards',
      '10': 'items'
    },
  ],
};

/// Descriptor for `MultiItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List multiItemDescriptor = $convert.base64Decode(
    'CglNdWx0aUl0ZW0SLgoEYmFzZRgBIAEoCzIaLmJpbGliaWxpLmFwcC5jYXJkLnYxLkJhc2VSBG'
    'Jhc2USGQoIbW9yZV91cmkYAiABKAlSB21vcmVVcmkSGwoJbW9yZV90ZXh0GAMgASgJUghtb3Jl'
    'VGV4dBI3CgVpdGVtcxgEIAMoCzIhLmJpbGliaWxpLmFwcC5jYXJkLnYxLkRvdWJsZUNhcmRzUg'
    'VpdGVtcw==');

@$core.Deprecated('Use onePicV2Descriptor instead')
const OnePicV2$json = {
  '1': 'OnePicV2',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'cover_left_icon1', '3': 2, '4': 1, '5': 5, '10': 'coverLeftIcon1'},
    {'1': 'cover_left_text2', '3': 3, '4': 1, '5': 9, '10': 'coverLeftText2'},
    {'1': 'cover_right_text', '3': 4, '4': 1, '5': 9, '10': 'coverRightText'},
    {'1': 'cover_right_icon', '3': 5, '4': 1, '5': 5, '10': 'coverRightIcon'},
    {
      '1': 'cover_right_background_color',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'coverRightBackgroundColor'
    },
    {'1': 'badge', '3': 7, '4': 1, '5': 9, '10': 'badge'},
    {'1': 'rcmd_reason', '3': 8, '4': 1, '5': 9, '10': 'rcmdReason'},
    {
      '1': 'avatar',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Avatar',
      '10': 'avatar'
    },
    {
      '1': 'rcmd_reason_style',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'rcmdReasonStyle'
    },
  ],
};

/// Descriptor for `OnePicV2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List onePicV2Descriptor = $convert.base64Decode(
    'CghPbmVQaWNWMhIuCgRiYXNlGAEgASgLMhouYmlsaWJpbGkuYXBwLmNhcmQudjEuQmFzZVIEYm'
    'FzZRIoChBjb3Zlcl9sZWZ0X2ljb24xGAIgASgFUg5jb3ZlckxlZnRJY29uMRIoChBjb3Zlcl9s'
    'ZWZ0X3RleHQyGAMgASgJUg5jb3ZlckxlZnRUZXh0MhIoChBjb3Zlcl9yaWdodF90ZXh0GAQgAS'
    'gJUg5jb3ZlclJpZ2h0VGV4dBIoChBjb3Zlcl9yaWdodF9pY29uGAUgASgFUg5jb3ZlclJpZ2h0'
    'SWNvbhI/Chxjb3Zlcl9yaWdodF9iYWNrZ3JvdW5kX2NvbG9yGAYgASgJUhljb3ZlclJpZ2h0Qm'
    'Fja2dyb3VuZENvbG9yEhQKBWJhZGdlGAcgASgJUgViYWRnZRIfCgtyY21kX3JlYXNvbhgIIAEo'
    'CVIKcmNtZFJlYXNvbhI0CgZhdmF0YXIYCSABKAsyHC5iaWxpYmlsaS5hcHAuY2FyZC52MS5Bdm'
    'F0YXJSBmF2YXRhchJNChFyY21kX3JlYXNvbl9zdHlsZRgKIAEoCzIhLmJpbGliaWxpLmFwcC5j'
    'YXJkLnYxLlJlYXNvblN0eWxlUg9yY21kUmVhc29uU3R5bGU=');

@$core.Deprecated('Use onePicV3Descriptor instead')
const OnePicV3$json = {
  '1': 'OnePicV3',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'cover_left_text1', '3': 2, '4': 1, '5': 9, '10': 'coverLeftText1'},
    {'1': 'cover_left_icon1', '3': 3, '4': 1, '5': 5, '10': 'coverLeftIcon1'},
    {'1': 'cover_right_text', '3': 4, '4': 1, '5': 9, '10': 'coverRightText'},
    {'1': 'cover_right_icon', '3': 5, '4': 1, '5': 5, '10': 'coverRightIcon'},
    {
      '1': 'cover_right_background_color',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'coverRightBackgroundColor'
    },
    {'1': 'badge', '3': 7, '4': 1, '5': 9, '10': 'badge'},
    {
      '1': 'rcmd_reason_style',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'rcmdReasonStyle'
    },
  ],
};

/// Descriptor for `OnePicV3`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List onePicV3Descriptor = $convert.base64Decode(
    'CghPbmVQaWNWMxIuCgRiYXNlGAEgASgLMhouYmlsaWJpbGkuYXBwLmNhcmQudjEuQmFzZVIEYm'
    'FzZRIoChBjb3Zlcl9sZWZ0X3RleHQxGAIgASgJUg5jb3ZlckxlZnRUZXh0MRIoChBjb3Zlcl9s'
    'ZWZ0X2ljb24xGAMgASgFUg5jb3ZlckxlZnRJY29uMRIoChBjb3Zlcl9yaWdodF90ZXh0GAQgAS'
    'gJUg5jb3ZlclJpZ2h0VGV4dBIoChBjb3Zlcl9yaWdodF9pY29uGAUgASgFUg5jb3ZlclJpZ2h0'
    'SWNvbhI/Chxjb3Zlcl9yaWdodF9iYWNrZ3JvdW5kX2NvbG9yGAYgASgJUhljb3ZlclJpZ2h0Qm'
    'Fja2dyb3VuZENvbG9yEhQKBWJhZGdlGAcgASgJUgViYWRnZRJNChFyY21kX3JlYXNvbl9zdHls'
    'ZRgIIAEoCzIhLmJpbGliaWxpLmFwcC5jYXJkLnYxLlJlYXNvblN0eWxlUg9yY21kUmVhc29uU3'
    'R5bGU=');

@$core.Deprecated('Use panelMetaDescriptor instead')
const PanelMeta$json = {
  '1': 'PanelMeta',
  '2': [
    {'1': 'panel_type', '3': 1, '4': 1, '5': 5, '10': 'panelType'},
    {'1': 'share_origin', '3': 2, '4': 1, '5': 9, '10': 'shareOrigin'},
    {'1': 'share_id', '3': 3, '4': 1, '5': 9, '10': 'shareId'},
    {
      '1': 'functional_buttons',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.card.v1.FunctionalButton',
      '10': 'functionalButtons'
    },
  ],
};

/// Descriptor for `PanelMeta`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List panelMetaDescriptor = $convert.base64Decode(
    'CglQYW5lbE1ldGESHQoKcGFuZWxfdHlwZRgBIAEoBVIJcGFuZWxUeXBlEiEKDHNoYXJlX29yaW'
    'dpbhgCIAEoCVILc2hhcmVPcmlnaW4SGQoIc2hhcmVfaWQYAyABKAlSB3NoYXJlSWQSVQoSZnVu'
    'Y3Rpb25hbF9idXR0b25zGAQgAygLMiYuYmlsaWJpbGkuYXBwLmNhcmQudjEuRnVuY3Rpb25hbE'
    'J1dHRvblIRZnVuY3Rpb25hbEJ1dHRvbnM=');

@$core.Deprecated('Use playerArgsDescriptor instead')
const PlayerArgs$json = {
  '1': 'PlayerArgs',
  '2': [
    {'1': 'is_live', '3': 1, '4': 1, '5': 5, '10': 'isLive'},
    {'1': 'aid', '3': 2, '4': 1, '5': 3, '10': 'aid'},
    {'1': 'cid', '3': 3, '4': 1, '5': 3, '10': 'cid'},
    {'1': 'sub_type', '3': 4, '4': 1, '5': 5, '10': 'subType'},
    {'1': 'room_id', '3': 5, '4': 1, '5': 3, '10': 'roomId'},
    {'1': 'ep_id', '3': 7, '4': 1, '5': 3, '10': 'epId'},
    {'1': 'is_preview', '3': 8, '4': 1, '5': 5, '10': 'isPreview'},
    {'1': 'type', '3': 9, '4': 1, '5': 9, '10': 'type'},
    {'1': 'duration', '3': 10, '4': 1, '5': 3, '10': 'duration'},
    {'1': 'season_id', '3': 11, '4': 1, '5': 3, '10': 'seasonId'},
  ],
};

/// Descriptor for `PlayerArgs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerArgsDescriptor = $convert.base64Decode(
    'CgpQbGF5ZXJBcmdzEhcKB2lzX2xpdmUYASABKAVSBmlzTGl2ZRIQCgNhaWQYAiABKANSA2FpZB'
    'IQCgNjaWQYAyABKANSA2NpZBIZCghzdWJfdHlwZRgEIAEoBVIHc3ViVHlwZRIXCgdyb29tX2lk'
    'GAUgASgDUgZyb29tSWQSEwoFZXBfaWQYByABKANSBGVwSWQSHQoKaXNfcHJldmlldxgIIAEoBV'
    'IJaXNQcmV2aWV3EhIKBHR5cGUYCSABKAlSBHR5cGUSGgoIZHVyYXRpb24YCiABKANSCGR1cmF0'
    'aW9uEhsKCXNlYXNvbl9pZBgLIAEoA1IIc2Vhc29uSWQ=');

@$core.Deprecated('Use popularTopEntranceDescriptor instead')
const PopularTopEntrance$json = {
  '1': 'PopularTopEntrance',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {
      '1': 'items',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.card.v1.EntranceItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `PopularTopEntrance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List popularTopEntranceDescriptor = $convert.base64Decode(
    'ChJQb3B1bGFyVG9wRW50cmFuY2USLgoEYmFzZRgBIAEoCzIaLmJpbGliaWxpLmFwcC5jYXJkLn'
    'YxLkJhc2VSBGJhc2USOAoFaXRlbXMYAiADKAsyIi5iaWxpYmlsaS5hcHAuY2FyZC52MS5FbnRy'
    'YW5jZUl0ZW1SBWl0ZW1z');

@$core.Deprecated('Use rcmdOneItemDescriptor instead')
const RcmdOneItem$json = {
  '1': 'RcmdOneItem',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {
      '1': 'top_rcmd_reason_style',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'topRcmdReasonStyle'
    },
    {
      '1': 'item',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.SmallCoverRcmdItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `RcmdOneItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rcmdOneItemDescriptor = $convert.base64Decode(
    'CgtSY21kT25lSXRlbRIuCgRiYXNlGAEgASgLMhouYmlsaWJpbGkuYXBwLmNhcmQudjEuQmFzZV'
    'IEYmFzZRJUChV0b3BfcmNtZF9yZWFzb25fc3R5bGUYAiABKAsyIS5iaWxpYmlsaS5hcHAuY2Fy'
    'ZC52MS5SZWFzb25TdHlsZVISdG9wUmNtZFJlYXNvblN0eWxlEjwKBGl0ZW0YAyABKAsyKC5iaW'
    'xpYmlsaS5hcHAuY2FyZC52MS5TbWFsbENvdmVyUmNtZEl0ZW1SBGl0ZW0=');

@$core.Deprecated('Use reasonStyleDescriptor instead')
const ReasonStyle$json = {
  '1': 'ReasonStyle',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'text_color', '3': 2, '4': 1, '5': 9, '10': 'textColor'},
    {'1': 'bg_color', '3': 3, '4': 1, '5': 9, '10': 'bgColor'},
    {'1': 'border_color', '3': 4, '4': 1, '5': 9, '10': 'borderColor'},
    {'1': 'icon_url', '3': 5, '4': 1, '5': 9, '10': 'iconUrl'},
    {'1': 'text_color_night', '3': 6, '4': 1, '5': 9, '10': 'textColorNight'},
    {'1': 'bg_color_night', '3': 7, '4': 1, '5': 9, '10': 'bgColorNight'},
    {
      '1': 'border_color_night',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'borderColorNight'
    },
    {'1': 'icon_night_url', '3': 9, '4': 1, '5': 9, '10': 'iconNightUrl'},
    {'1': 'bg_style', '3': 10, '4': 1, '5': 5, '10': 'bgStyle'},
    {'1': 'uri', '3': 11, '4': 1, '5': 9, '10': 'uri'},
    {'1': 'icon_bg_url', '3': 12, '4': 1, '5': 9, '10': 'iconBgUrl'},
    {'1': 'event', '3': 13, '4': 1, '5': 9, '10': 'event'},
    {'1': 'event_v2', '3': 14, '4': 1, '5': 9, '10': 'eventV2'},
    {'1': 'right_icon_type', '3': 15, '4': 1, '5': 5, '10': 'rightIconType'},
    {'1': 'left_icon_type', '3': 16, '4': 1, '5': 9, '10': 'leftIconType'},
  ],
};

/// Descriptor for `ReasonStyle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reasonStyleDescriptor = $convert.base64Decode(
    'CgtSZWFzb25TdHlsZRISCgR0ZXh0GAEgASgJUgR0ZXh0Eh0KCnRleHRfY29sb3IYAiABKAlSCX'
    'RleHRDb2xvchIZCghiZ19jb2xvchgDIAEoCVIHYmdDb2xvchIhCgxib3JkZXJfY29sb3IYBCAB'
    'KAlSC2JvcmRlckNvbG9yEhkKCGljb25fdXJsGAUgASgJUgdpY29uVXJsEigKEHRleHRfY29sb3'
    'JfbmlnaHQYBiABKAlSDnRleHRDb2xvck5pZ2h0EiQKDmJnX2NvbG9yX25pZ2h0GAcgASgJUgxi'
    'Z0NvbG9yTmlnaHQSLAoSYm9yZGVyX2NvbG9yX25pZ2h0GAggASgJUhBib3JkZXJDb2xvck5pZ2'
    'h0EiQKDmljb25fbmlnaHRfdXJsGAkgASgJUgxpY29uTmlnaHRVcmwSGQoIYmdfc3R5bGUYCiAB'
    'KAVSB2JnU3R5bGUSEAoDdXJpGAsgASgJUgN1cmkSHgoLaWNvbl9iZ191cmwYDCABKAlSCWljb2'
    '5CZ1VybBIUCgVldmVudBgNIAEoCVIFZXZlbnQSGQoIZXZlbnRfdjIYDiABKAlSB2V2ZW50VjIS'
    'JgoPcmlnaHRfaWNvbl90eXBlGA8gASgFUg1yaWdodEljb25UeXBlEiQKDmxlZnRfaWNvbl90eX'
    'BlGBAgASgJUgxsZWZ0SWNvblR5cGU=');

@$core.Deprecated('Use relationDescriptor instead')
const Relation$json = {
  '1': 'Relation',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 5, '10': 'status'},
    {'1': 'is_follow', '3': 2, '4': 1, '5': 5, '10': 'isFollow'},
    {'1': 'is_followed', '3': 3, '4': 1, '5': 5, '10': 'isFollowed'},
  ],
};

/// Descriptor for `Relation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List relationDescriptor = $convert.base64Decode(
    'CghSZWxhdGlvbhIWCgZzdGF0dXMYASABKAVSBnN0YXR1cxIbCglpc19mb2xsb3cYAiABKAVSCG'
    'lzRm9sbG93Eh8KC2lzX2ZvbGxvd2VkGAMgASgFUgppc0ZvbGxvd2Vk');

@$core.Deprecated('Use sharePlaneDescriptor instead')
const SharePlane$json = {
  '1': 'SharePlane',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'share_subtitle', '3': 2, '4': 1, '5': 9, '10': 'shareSubtitle'},
    {'1': 'desc', '3': 3, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'cover', '3': 4, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'aid', '3': 5, '4': 1, '5': 3, '10': 'aid'},
    {'1': 'bvid', '3': 6, '4': 1, '5': 9, '10': 'bvid'},
    {
      '1': 'share_to',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.card.v1.SharePlane.ShareToEntry',
      '10': 'shareTo'
    },
    {'1': 'author', '3': 8, '4': 1, '5': 9, '10': 'author'},
    {'1': 'author_id', '3': 9, '4': 1, '5': 3, '10': 'authorId'},
    {'1': 'short_link', '3': 10, '4': 1, '5': 9, '10': 'shortLink'},
    {'1': 'play_number', '3': 11, '4': 1, '5': 9, '10': 'playNumber'},
    {'1': 'first_cid', '3': 12, '4': 1, '5': 3, '10': 'firstCid'},
  ],
  '3': [SharePlane_ShareToEntry$json],
};

@$core.Deprecated('Use sharePlaneDescriptor instead')
const SharePlane_ShareToEntry$json = {
  '1': 'ShareToEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 8, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `SharePlane`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sharePlaneDescriptor = $convert.base64Decode(
    'CgpTaGFyZVBsYW5lEhQKBXRpdGxlGAEgASgJUgV0aXRsZRIlCg5zaGFyZV9zdWJ0aXRsZRgCIA'
    'EoCVINc2hhcmVTdWJ0aXRsZRISCgRkZXNjGAMgASgJUgRkZXNjEhQKBWNvdmVyGAQgASgJUgVj'
    'b3ZlchIQCgNhaWQYBSABKANSA2FpZBISCgRidmlkGAYgASgJUgRidmlkEkgKCHNoYXJlX3RvGA'
    'cgAygLMi0uYmlsaWJpbGkuYXBwLmNhcmQudjEuU2hhcmVQbGFuZS5TaGFyZVRvRW50cnlSB3No'
    'YXJlVG8SFgoGYXV0aG9yGAggASgJUgZhdXRob3ISGwoJYXV0aG9yX2lkGAkgASgDUghhdXRob3'
    'JJZBIdCgpzaG9ydF9saW5rGAogASgJUglzaG9ydExpbmsSHwoLcGxheV9udW1iZXIYCyABKAlS'
    'CnBsYXlOdW1iZXISGwoJZmlyc3RfY2lkGAwgASgDUghmaXJzdENpZBo6CgxTaGFyZVRvRW50cn'
    'kSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAhSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use smallChannelSpecialDescriptor instead')
const SmallChannelSpecial$json = {
  '1': 'SmallChannelSpecial',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'bg_cover', '3': 2, '4': 1, '5': 9, '10': 'bgCover'},
    {'1': 'desc1', '3': 3, '4': 1, '5': 9, '10': 'desc1'},
    {'1': 'desc2', '3': 4, '4': 1, '5': 9, '10': 'desc2'},
    {'1': 'badge', '3': 5, '4': 1, '5': 9, '10': 'badge'},
    {
      '1': 'rcmd_reason_style2',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'rcmdReasonStyle2'
    },
  ],
};

/// Descriptor for `SmallChannelSpecial`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List smallChannelSpecialDescriptor = $convert.base64Decode(
    'ChNTbWFsbENoYW5uZWxTcGVjaWFsEi4KBGJhc2UYASABKAsyGi5iaWxpYmlsaS5hcHAuY2FyZC'
    '52MS5CYXNlUgRiYXNlEhkKCGJnX2NvdmVyGAIgASgJUgdiZ0NvdmVyEhQKBWRlc2MxGAMgASgJ'
    'UgVkZXNjMRIUCgVkZXNjMhgEIAEoCVIFZGVzYzISFAoFYmFkZ2UYBSABKAlSBWJhZGdlEk8KEn'
    'JjbWRfcmVhc29uX3N0eWxlMhgGIAEoCzIhLmJpbGliaWxpLmFwcC5jYXJkLnYxLlJlYXNvblN0'
    'eWxlUhByY21kUmVhc29uU3R5bGUy');

@$core.Deprecated('Use smallCoverConvergeV2Descriptor instead')
const SmallCoverConvergeV2$json = {
  '1': 'SmallCoverConvergeV2',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'cover_left_text1', '3': 2, '4': 1, '5': 9, '10': 'coverLeftText1'},
    {'1': 'cover_left_icon1', '3': 3, '4': 1, '5': 5, '10': 'coverLeftIcon1'},
    {'1': 'cover_left_text2', '3': 4, '4': 1, '5': 9, '10': 'coverLeftText2'},
    {'1': 'cover_left_icon2', '3': 5, '4': 1, '5': 5, '10': 'coverLeftIcon2'},
    {'1': 'cover_right_text', '3': 6, '4': 1, '5': 9, '10': 'coverRightText'},
    {
      '1': 'cover_right_top_text',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'coverRightTopText'
    },
    {
      '1': 'rcmd_reason_style',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'rcmdReasonStyle'
    },
    {
      '1': 'rcmd_reason_style_v2',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'rcmdReasonStyleV2'
    },
  ],
};

/// Descriptor for `SmallCoverConvergeV2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List smallCoverConvergeV2Descriptor = $convert.base64Decode(
    'ChRTbWFsbENvdmVyQ29udmVyZ2VWMhIuCgRiYXNlGAEgASgLMhouYmlsaWJpbGkuYXBwLmNhcm'
    'QudjEuQmFzZVIEYmFzZRIoChBjb3Zlcl9sZWZ0X3RleHQxGAIgASgJUg5jb3ZlckxlZnRUZXh0'
    'MRIoChBjb3Zlcl9sZWZ0X2ljb24xGAMgASgFUg5jb3ZlckxlZnRJY29uMRIoChBjb3Zlcl9sZW'
    'Z0X3RleHQyGAQgASgJUg5jb3ZlckxlZnRUZXh0MhIoChBjb3Zlcl9sZWZ0X2ljb24yGAUgASgF'
    'Ug5jb3ZlckxlZnRJY29uMhIoChBjb3Zlcl9yaWdodF90ZXh0GAYgASgJUg5jb3ZlclJpZ2h0VG'
    'V4dBIvChRjb3Zlcl9yaWdodF90b3BfdGV4dBgHIAEoCVIRY292ZXJSaWdodFRvcFRleHQSTQoR'
    'cmNtZF9yZWFzb25fc3R5bGUYCCABKAsyIS5iaWxpYmlsaS5hcHAuY2FyZC52MS5SZWFzb25TdH'
    'lsZVIPcmNtZFJlYXNvblN0eWxlElIKFHJjbWRfcmVhc29uX3N0eWxlX3YyGAkgASgLMiEuYmls'
    'aWJpbGkuYXBwLmNhcmQudjEuUmVhc29uU3R5bGVSEXJjbWRSZWFzb25TdHlsZVYy');

@$core.Deprecated('Use smallCoverRcmdItemDescriptor instead')
const SmallCoverRcmdItem$json = {
  '1': 'SmallCoverRcmdItem',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'cover', '3': 2, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'uri', '3': 3, '4': 1, '5': 9, '10': 'uri'},
    {'1': 'param', '3': 4, '4': 1, '5': 9, '10': 'param'},
    {'1': 'goto', '3': 5, '4': 1, '5': 9, '10': 'goto'},
    {'1': 'cover_right_text1', '3': 6, '4': 1, '5': 9, '10': 'coverRightText1'},
    {'1': 'right_desc1', '3': 7, '4': 1, '5': 9, '10': 'rightDesc1'},
    {'1': 'right_desc2', '3': 8, '4': 1, '5': 9, '10': 'rightDesc2'},
    {'1': 'cover_gif', '3': 9, '4': 1, '5': 9, '10': 'coverGif'},
    {'1': 'right_icon1', '3': 10, '4': 1, '5': 5, '10': 'rightIcon1'},
    {'1': 'right_icon2', '3': 11, '4': 1, '5': 5, '10': 'rightIcon2'},
    {
      '1': 'cover_right_text_content_description',
      '3': 12,
      '4': 1,
      '5': 9,
      '10': 'coverRightTextContentDescription'
    },
    {
      '1': 'right_desc1_content_description',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'rightDesc1ContentDescription'
    },
  ],
};

/// Descriptor for `SmallCoverRcmdItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List smallCoverRcmdItemDescriptor = $convert.base64Decode(
    'ChJTbWFsbENvdmVyUmNtZEl0ZW0SFAoFdGl0bGUYASABKAlSBXRpdGxlEhQKBWNvdmVyGAIgAS'
    'gJUgVjb3ZlchIQCgN1cmkYAyABKAlSA3VyaRIUCgVwYXJhbRgEIAEoCVIFcGFyYW0SEgoEZ290'
    'bxgFIAEoCVIEZ290bxIqChFjb3Zlcl9yaWdodF90ZXh0MRgGIAEoCVIPY292ZXJSaWdodFRleH'
    'QxEh8KC3JpZ2h0X2Rlc2MxGAcgASgJUgpyaWdodERlc2MxEh8KC3JpZ2h0X2Rlc2MyGAggASgJ'
    'UgpyaWdodERlc2MyEhsKCWNvdmVyX2dpZhgJIAEoCVIIY292ZXJHaWYSHwoLcmlnaHRfaWNvbj'
    'EYCiABKAVSCnJpZ2h0SWNvbjESHwoLcmlnaHRfaWNvbjIYCyABKAVSCnJpZ2h0SWNvbjISTgok'
    'Y292ZXJfcmlnaHRfdGV4dF9jb250ZW50X2Rlc2NyaXB0aW9uGAwgASgJUiBjb3ZlclJpZ2h0VG'
    'V4dENvbnRlbnREZXNjcmlwdGlvbhJFCh9yaWdodF9kZXNjMV9jb250ZW50X2Rlc2NyaXB0aW9u'
    'GA0gASgJUhxyaWdodERlc2MxQ29udGVudERlc2NyaXB0aW9u');

@$core.Deprecated('Use smallCoverV2Descriptor instead')
const SmallCoverV2$json = {
  '1': 'SmallCoverV2',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'cover_gif', '3': 2, '4': 1, '5': 9, '10': 'coverGif'},
    {'1': 'cover_blur', '3': 3, '4': 1, '5': 5, '10': 'coverBlur'},
    {'1': 'cover_left_text1', '3': 4, '4': 1, '5': 9, '10': 'coverLeftText1'},
    {'1': 'cover_left_icon1', '3': 5, '4': 1, '5': 5, '10': 'coverLeftIcon1'},
    {'1': 'cover_left_text2', '3': 6, '4': 1, '5': 9, '10': 'coverLeftText2'},
    {'1': 'cover_left_icon2', '3': 7, '4': 1, '5': 5, '10': 'coverLeftIcon2'},
    {'1': 'cover_right_text', '3': 8, '4': 1, '5': 9, '10': 'coverRightText'},
    {'1': 'cover_right_icon', '3': 9, '4': 1, '5': 5, '10': 'coverRightIcon'},
    {
      '1': 'cover_right_background_color',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'coverRightBackgroundColor'
    },
    {'1': 'subtitle', '3': 11, '4': 1, '5': 9, '10': 'subtitle'},
    {'1': 'badge', '3': 12, '4': 1, '5': 9, '10': 'badge'},
    {'1': 'rcmd_reason', '3': 13, '4': 1, '5': 9, '10': 'rcmdReason'},
    {'1': 'desc', '3': 14, '4': 1, '5': 9, '10': 'desc'},
    {
      '1': 'avatar',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Avatar',
      '10': 'avatar'
    },
    {'1': 'official_icon', '3': 16, '4': 1, '5': 5, '10': 'officialIcon'},
    {'1': 'can_play', '3': 17, '4': 1, '5': 5, '10': 'canPlay'},
    {
      '1': 'rcmd_reason_style',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'rcmdReasonStyle'
    },
    {
      '1': 'rcmd_reason_style_v2',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'rcmdReasonStyleV2'
    },
    {
      '1': 'like_button',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.LikeButton',
      '10': 'likeButton'
    },
  ],
};

/// Descriptor for `SmallCoverV2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List smallCoverV2Descriptor = $convert.base64Decode(
    'CgxTbWFsbENvdmVyVjISLgoEYmFzZRgBIAEoCzIaLmJpbGliaWxpLmFwcC5jYXJkLnYxLkJhc2'
    'VSBGJhc2USGwoJY292ZXJfZ2lmGAIgASgJUghjb3ZlckdpZhIdCgpjb3Zlcl9ibHVyGAMgASgF'
    'Ugljb3ZlckJsdXISKAoQY292ZXJfbGVmdF90ZXh0MRgEIAEoCVIOY292ZXJMZWZ0VGV4dDESKA'
    'oQY292ZXJfbGVmdF9pY29uMRgFIAEoBVIOY292ZXJMZWZ0SWNvbjESKAoQY292ZXJfbGVmdF90'
    'ZXh0MhgGIAEoCVIOY292ZXJMZWZ0VGV4dDISKAoQY292ZXJfbGVmdF9pY29uMhgHIAEoBVIOY2'
    '92ZXJMZWZ0SWNvbjISKAoQY292ZXJfcmlnaHRfdGV4dBgIIAEoCVIOY292ZXJSaWdodFRleHQS'
    'KAoQY292ZXJfcmlnaHRfaWNvbhgJIAEoBVIOY292ZXJSaWdodEljb24SPwocY292ZXJfcmlnaH'
    'RfYmFja2dyb3VuZF9jb2xvchgKIAEoCVIZY292ZXJSaWdodEJhY2tncm91bmRDb2xvchIaCghz'
    'dWJ0aXRsZRgLIAEoCVIIc3VidGl0bGUSFAoFYmFkZ2UYDCABKAlSBWJhZGdlEh8KC3JjbWRfcm'
    'Vhc29uGA0gASgJUgpyY21kUmVhc29uEhIKBGRlc2MYDiABKAlSBGRlc2MSNAoGYXZhdGFyGA8g'
    'ASgLMhwuYmlsaWJpbGkuYXBwLmNhcmQudjEuQXZhdGFyUgZhdmF0YXISIwoNb2ZmaWNpYWxfaW'
    'NvbhgQIAEoBVIMb2ZmaWNpYWxJY29uEhkKCGNhbl9wbGF5GBEgASgFUgdjYW5QbGF5Ek0KEXJj'
    'bWRfcmVhc29uX3N0eWxlGBIgASgLMiEuYmlsaWJpbGkuYXBwLmNhcmQudjEuUmVhc29uU3R5bG'
    'VSD3JjbWRSZWFzb25TdHlsZRJSChRyY21kX3JlYXNvbl9zdHlsZV92MhgTIAEoCzIhLmJpbGli'
    'aWxpLmFwcC5jYXJkLnYxLlJlYXNvblN0eWxlUhFyY21kUmVhc29uU3R5bGVWMhJBCgtsaWtlX2'
    'J1dHRvbhgUIAEoCzIgLmJpbGliaWxpLmFwcC5jYXJkLnYxLkxpa2VCdXR0b25SCmxpa2VCdXR0'
    'b24=');

@$core.Deprecated('Use smallCoverV3Descriptor instead')
const SmallCoverV3$json = {
  '1': 'SmallCoverV3',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {
      '1': 'avatar',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Avatar',
      '10': 'avatar'
    },
    {'1': 'cover_left_text', '3': 3, '4': 1, '5': 9, '10': 'coverLeftText'},
    {
      '1': 'cover_right_button',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Button',
      '10': 'coverRightButton'
    },
    {'1': 'rcmd_reason', '3': 5, '4': 1, '5': 9, '10': 'rcmdReason'},
    {'1': 'desc', '3': 6, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'official_icon', '3': 7, '4': 1, '5': 5, '10': 'officialIcon'},
    {'1': 'can_play', '3': 8, '4': 1, '5': 5, '10': 'canPlay'},
    {
      '1': 'rcmd_reason_style',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'rcmdReasonStyle'
    },
  ],
};

/// Descriptor for `SmallCoverV3`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List smallCoverV3Descriptor = $convert.base64Decode(
    'CgxTbWFsbENvdmVyVjMSLgoEYmFzZRgBIAEoCzIaLmJpbGliaWxpLmFwcC5jYXJkLnYxLkJhc2'
    'VSBGJhc2USNAoGYXZhdGFyGAIgASgLMhwuYmlsaWJpbGkuYXBwLmNhcmQudjEuQXZhdGFyUgZh'
    'dmF0YXISJgoPY292ZXJfbGVmdF90ZXh0GAMgASgJUg1jb3ZlckxlZnRUZXh0EkoKEmNvdmVyX3'
    'JpZ2h0X2J1dHRvbhgEIAEoCzIcLmJpbGliaWxpLmFwcC5jYXJkLnYxLkJ1dHRvblIQY292ZXJS'
    'aWdodEJ1dHRvbhIfCgtyY21kX3JlYXNvbhgFIAEoCVIKcmNtZFJlYXNvbhISCgRkZXNjGAYgAS'
    'gJUgRkZXNjEiMKDW9mZmljaWFsX2ljb24YByABKAVSDG9mZmljaWFsSWNvbhIZCghjYW5fcGxh'
    'eRgIIAEoBVIHY2FuUGxheRJNChFyY21kX3JlYXNvbl9zdHlsZRgJIAEoCzIhLmJpbGliaWxpLm'
    'FwcC5jYXJkLnYxLlJlYXNvblN0eWxlUg9yY21kUmVhc29uU3R5bGU=');

@$core.Deprecated('Use smallCoverV4Descriptor instead')
const SmallCoverV4$json = {
  '1': 'SmallCoverV4',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'cover_badge', '3': 2, '4': 1, '5': 9, '10': 'coverBadge'},
    {'1': 'desc', '3': 3, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'title_right_text', '3': 4, '4': 1, '5': 9, '10': 'titleRightText'},
    {'1': 'title_right_pic', '3': 5, '4': 1, '5': 5, '10': 'titleRightPic'},
  ],
};

/// Descriptor for `SmallCoverV4`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List smallCoverV4Descriptor = $convert.base64Decode(
    'CgxTbWFsbENvdmVyVjQSLgoEYmFzZRgBIAEoCzIaLmJpbGliaWxpLmFwcC5jYXJkLnYxLkJhc2'
    'VSBGJhc2USHwoLY292ZXJfYmFkZ2UYAiABKAlSCmNvdmVyQmFkZ2USEgoEZGVzYxgDIAEoCVIE'
    'ZGVzYxIoChB0aXRsZV9yaWdodF90ZXh0GAQgASgJUg50aXRsZVJpZ2h0VGV4dBImCg90aXRsZV'
    '9yaWdodF9waWMYBSABKAVSDXRpdGxlUmlnaHRQaWM=');

@$core.Deprecated('Use smallCoverV5Descriptor instead')
const SmallCoverV5$json = {
  '1': 'SmallCoverV5',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'cover_gif', '3': 2, '4': 1, '5': 9, '10': 'coverGif'},
    {
      '1': 'up',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Up',
      '10': 'up'
    },
    {'1': 'cover_right_text1', '3': 4, '4': 1, '5': 9, '10': 'coverRightText1'},
    {'1': 'right_desc1', '3': 5, '4': 1, '5': 9, '10': 'rightDesc1'},
    {'1': 'right_desc2', '3': 6, '4': 1, '5': 9, '10': 'rightDesc2'},
    {
      '1': 'rcmd_reason_style',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'rcmdReasonStyle'
    },
    {
      '1': 'hotword_entrance',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.HotwordEntrance',
      '10': 'hotwordEntrance'
    },
    {
      '1': 'corner_mark_style',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'cornerMarkStyle'
    },
    {'1': 'right_icon1', '3': 10, '4': 1, '5': 5, '10': 'rightIcon1'},
    {'1': 'right_icon2', '3': 11, '4': 1, '5': 5, '10': 'rightIcon2'},
    {
      '1': 'left_corner_mark_style',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'leftCornerMarkStyle'
    },
    {
      '1': 'cover_right_text_content_description',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'coverRightTextContentDescription'
    },
    {
      '1': 'right_desc1_content_description',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'rightDesc1ContentDescription'
    },
  ],
};

/// Descriptor for `SmallCoverV5`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List smallCoverV5Descriptor = $convert.base64Decode(
    'CgxTbWFsbENvdmVyVjUSLgoEYmFzZRgBIAEoCzIaLmJpbGliaWxpLmFwcC5jYXJkLnYxLkJhc2'
    'VSBGJhc2USGwoJY292ZXJfZ2lmGAIgASgJUghjb3ZlckdpZhIoCgJ1cBgDIAEoCzIYLmJpbGli'
    'aWxpLmFwcC5jYXJkLnYxLlVwUgJ1cBIqChFjb3Zlcl9yaWdodF90ZXh0MRgEIAEoCVIPY292ZX'
    'JSaWdodFRleHQxEh8KC3JpZ2h0X2Rlc2MxGAUgASgJUgpyaWdodERlc2MxEh8KC3JpZ2h0X2Rl'
    'c2MyGAYgASgJUgpyaWdodERlc2MyEk0KEXJjbWRfcmVhc29uX3N0eWxlGAcgASgLMiEuYmlsaW'
    'JpbGkuYXBwLmNhcmQudjEuUmVhc29uU3R5bGVSD3JjbWRSZWFzb25TdHlsZRJQChBob3R3b3Jk'
    'X2VudHJhbmNlGAggASgLMiUuYmlsaWJpbGkuYXBwLmNhcmQudjEuSG90d29yZEVudHJhbmNlUg'
    '9ob3R3b3JkRW50cmFuY2USTQoRY29ybmVyX21hcmtfc3R5bGUYCSABKAsyIS5iaWxpYmlsaS5h'
    'cHAuY2FyZC52MS5SZWFzb25TdHlsZVIPY29ybmVyTWFya1N0eWxlEh8KC3JpZ2h0X2ljb24xGA'
    'ogASgFUgpyaWdodEljb24xEh8KC3JpZ2h0X2ljb24yGAsgASgFUgpyaWdodEljb24yElYKFmxl'
    'ZnRfY29ybmVyX21hcmtfc3R5bGUYDCABKAsyIS5iaWxpYmlsaS5hcHAuY2FyZC52MS5SZWFzb2'
    '5TdHlsZVITbGVmdENvcm5lck1hcmtTdHlsZRJOCiRjb3Zlcl9yaWdodF90ZXh0X2NvbnRlbnRf'
    'ZGVzY3JpcHRpb24YDSABKAlSIGNvdmVyUmlnaHRUZXh0Q29udGVudERlc2NyaXB0aW9uEkUKH3'
    'JpZ2h0X2Rlc2MxX2NvbnRlbnRfZGVzY3JpcHRpb24YDiABKAlSHHJpZ2h0RGVzYzFDb250ZW50'
    'RGVzY3JpcHRpb24=');

@$core.Deprecated('Use smallCoverV5AdDescriptor instead')
const SmallCoverV5Ad$json = {
  '1': 'SmallCoverV5Ad',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'cover_gif', '3': 2, '4': 1, '5': 9, '10': 'coverGif'},
    {
      '1': 'up',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Up',
      '10': 'up'
    },
    {'1': 'cover_right_text1', '3': 4, '4': 1, '5': 9, '10': 'coverRightText1'},
    {'1': 'right_desc1', '3': 5, '4': 1, '5': 9, '10': 'rightDesc1'},
    {'1': 'right_desc2', '3': 6, '4': 1, '5': 9, '10': 'rightDesc2'},
    {
      '1': 'rcmd_reason_style',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'rcmdReasonStyle'
    },
    {
      '1': 'hotword_entrance',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.HotwordEntrance',
      '10': 'hotwordEntrance'
    },
    {
      '1': 'corner_mark_style',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'cornerMarkStyle'
    },
    {'1': 'right_icon1', '3': 10, '4': 1, '5': 5, '10': 'rightIcon1'},
    {'1': 'right_icon2', '3': 11, '4': 1, '5': 5, '10': 'rightIcon2'},
    {
      '1': 'left_corner_mark_style',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'leftCornerMarkStyle'
    },
    {
      '1': 'cover_right_text_content_description',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'coverRightTextContentDescription'
    },
    {
      '1': 'right_desc1_content_description',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'rightDesc1ContentDescription'
    },
  ],
};

/// Descriptor for `SmallCoverV5Ad`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List smallCoverV5AdDescriptor = $convert.base64Decode(
    'Cg5TbWFsbENvdmVyVjVBZBIuCgRiYXNlGAEgASgLMhouYmlsaWJpbGkuYXBwLmNhcmQudjEuQm'
    'FzZVIEYmFzZRIbCgljb3Zlcl9naWYYAiABKAlSCGNvdmVyR2lmEigKAnVwGAMgASgLMhguYmls'
    'aWJpbGkuYXBwLmNhcmQudjEuVXBSAnVwEioKEWNvdmVyX3JpZ2h0X3RleHQxGAQgASgJUg9jb3'
    'ZlclJpZ2h0VGV4dDESHwoLcmlnaHRfZGVzYzEYBSABKAlSCnJpZ2h0RGVzYzESHwoLcmlnaHRf'
    'ZGVzYzIYBiABKAlSCnJpZ2h0RGVzYzISTQoRcmNtZF9yZWFzb25fc3R5bGUYByABKAsyIS5iaW'
    'xpYmlsaS5hcHAuY2FyZC52MS5SZWFzb25TdHlsZVIPcmNtZFJlYXNvblN0eWxlElAKEGhvdHdv'
    'cmRfZW50cmFuY2UYCCABKAsyJS5iaWxpYmlsaS5hcHAuY2FyZC52MS5Ib3R3b3JkRW50cmFuY2'
    'VSD2hvdHdvcmRFbnRyYW5jZRJNChFjb3JuZXJfbWFya19zdHlsZRgJIAEoCzIhLmJpbGliaWxp'
    'LmFwcC5jYXJkLnYxLlJlYXNvblN0eWxlUg9jb3JuZXJNYXJrU3R5bGUSHwoLcmlnaHRfaWNvbj'
    'EYCiABKAVSCnJpZ2h0SWNvbjESHwoLcmlnaHRfaWNvbjIYCyABKAVSCnJpZ2h0SWNvbjISVgoW'
    'bGVmdF9jb3JuZXJfbWFya19zdHlsZRgMIAEoCzIhLmJpbGliaWxpLmFwcC5jYXJkLnYxLlJlYX'
    'NvblN0eWxlUhNsZWZ0Q29ybmVyTWFya1N0eWxlEk4KJGNvdmVyX3JpZ2h0X3RleHRfY29udGVu'
    'dF9kZXNjcmlwdGlvbhgNIAEoCVIgY292ZXJSaWdodFRleHRDb250ZW50RGVzY3JpcHRpb24SRQ'
    'ofcmlnaHRfZGVzYzFfY29udGVudF9kZXNjcmlwdGlvbhgOIAEoCVIccmlnaHREZXNjMUNvbnRl'
    'bnREZXNjcmlwdGlvbg==');

@$core.Deprecated('Use smallCoverV7Descriptor instead')
const SmallCoverV7$json = {
  '1': 'SmallCoverV7',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'desc', '3': 2, '4': 1, '5': 9, '10': 'desc'},
  ],
};

/// Descriptor for `SmallCoverV7`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List smallCoverV7Descriptor = $convert.base64Decode(
    'CgxTbWFsbENvdmVyVjcSLgoEYmFzZRgBIAEoCzIaLmJpbGliaWxpLmFwcC5jYXJkLnYxLkJhc2'
    'VSBGJhc2USEgoEZGVzYxgCIAEoCVIEZGVzYw==');

@$core.Deprecated('Use smallCoverV9Descriptor instead')
const SmallCoverV9$json = {
  '1': 'SmallCoverV9',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'cover_left_text1', '3': 2, '4': 1, '5': 9, '10': 'coverLeftText1'},
    {'1': 'cover_left_icon1', '3': 3, '4': 1, '5': 5, '10': 'coverLeftIcon1'},
    {'1': 'cover_left_text2', '3': 4, '4': 1, '5': 9, '10': 'coverLeftText2'},
    {'1': 'cover_left_icon2', '3': 5, '4': 1, '5': 5, '10': 'coverLeftIcon2'},
    {'1': 'cover_right_text', '3': 6, '4': 1, '5': 9, '10': 'coverRightText'},
    {'1': 'cover_right_icon', '3': 7, '4': 1, '5': 5, '10': 'coverRightIcon'},
    {'1': 'can_play', '3': 8, '4': 1, '5': 5, '10': 'canPlay'},
    {
      '1': 'rcmd_reason_style',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'rcmdReasonStyle'
    },
    {
      '1': 'up',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Up',
      '10': 'up'
    },
    {
      '1': 'left_cover_badge_style',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'leftCoverBadgeStyle'
    },
    {
      '1': 'left_bottom_rcmd_reason_style',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'leftBottomRcmdReasonStyle'
    },
  ],
};

/// Descriptor for `SmallCoverV9`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List smallCoverV9Descriptor = $convert.base64Decode(
    'CgxTbWFsbENvdmVyVjkSLgoEYmFzZRgBIAEoCzIaLmJpbGliaWxpLmFwcC5jYXJkLnYxLkJhc2'
    'VSBGJhc2USKAoQY292ZXJfbGVmdF90ZXh0MRgCIAEoCVIOY292ZXJMZWZ0VGV4dDESKAoQY292'
    'ZXJfbGVmdF9pY29uMRgDIAEoBVIOY292ZXJMZWZ0SWNvbjESKAoQY292ZXJfbGVmdF90ZXh0Mh'
    'gEIAEoCVIOY292ZXJMZWZ0VGV4dDISKAoQY292ZXJfbGVmdF9pY29uMhgFIAEoBVIOY292ZXJM'
    'ZWZ0SWNvbjISKAoQY292ZXJfcmlnaHRfdGV4dBgGIAEoCVIOY292ZXJSaWdodFRleHQSKAoQY2'
    '92ZXJfcmlnaHRfaWNvbhgHIAEoBVIOY292ZXJSaWdodEljb24SGQoIY2FuX3BsYXkYCCABKAVS'
    'B2NhblBsYXkSTQoRcmNtZF9yZWFzb25fc3R5bGUYCSABKAsyIS5iaWxpYmlsaS5hcHAuY2FyZC'
    '52MS5SZWFzb25TdHlsZVIPcmNtZFJlYXNvblN0eWxlEigKAnVwGAogASgLMhguYmlsaWJpbGku'
    'YXBwLmNhcmQudjEuVXBSAnVwElYKFmxlZnRfY292ZXJfYmFkZ2Vfc3R5bGUYCyABKAsyIS5iaW'
    'xpYmlsaS5hcHAuY2FyZC52MS5SZWFzb25TdHlsZVITbGVmdENvdmVyQmFkZ2VTdHlsZRJjCh1s'
    'ZWZ0X2JvdHRvbV9yY21kX3JlYXNvbl9zdHlsZRgMIAEoCzIhLmJpbGliaWxpLmFwcC5jYXJkLn'
    'YxLlJlYXNvblN0eWxlUhlsZWZ0Qm90dG9tUmNtZFJlYXNvblN0eWxl');

@$core.Deprecated('Use threeItemAllV2Descriptor instead')
const ThreeItemAllV2$json = {
  '1': 'ThreeItemAllV2',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {
      '1': 'top_rcmd_reason_style',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'topRcmdReasonStyle'
    },
    {
      '1': 'item',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.card.v1.TwoItemHV1Item',
      '10': 'item'
    },
  ],
};

/// Descriptor for `ThreeItemAllV2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threeItemAllV2Descriptor = $convert.base64Decode(
    'Cg5UaHJlZUl0ZW1BbGxWMhIuCgRiYXNlGAEgASgLMhouYmlsaWJpbGkuYXBwLmNhcmQudjEuQm'
    'FzZVIEYmFzZRJUChV0b3BfcmNtZF9yZWFzb25fc3R5bGUYAiABKAsyIS5iaWxpYmlsaS5hcHAu'
    'Y2FyZC52MS5SZWFzb25TdHlsZVISdG9wUmNtZFJlYXNvblN0eWxlEjgKBGl0ZW0YAyADKAsyJC'
    '5iaWxpYmlsaS5hcHAuY2FyZC52MS5Ud29JdGVtSFYxSXRlbVIEaXRlbQ==');

@$core.Deprecated('Use threeItemV1Descriptor instead')
const ThreeItemV1$json = {
  '1': 'ThreeItemV1',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'title_icon', '3': 2, '4': 1, '5': 5, '10': 'titleIcon'},
    {'1': 'more_uri', '3': 3, '4': 1, '5': 9, '10': 'moreUri'},
    {'1': 'more_text', '3': 4, '4': 1, '5': 9, '10': 'moreText'},
    {
      '1': 'items',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.card.v1.ThreeItemV1Item',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ThreeItemV1`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threeItemV1Descriptor = $convert.base64Decode(
    'CgtUaHJlZUl0ZW1WMRIuCgRiYXNlGAEgASgLMhouYmlsaWJpbGkuYXBwLmNhcmQudjEuQmFzZV'
    'IEYmFzZRIdCgp0aXRsZV9pY29uGAIgASgFUgl0aXRsZUljb24SGQoIbW9yZV91cmkYAyABKAlS'
    'B21vcmVVcmkSGwoJbW9yZV90ZXh0GAQgASgJUghtb3JlVGV4dBI7CgVpdGVtcxgFIAMoCzIlLm'
    'JpbGliaWxpLmFwcC5jYXJkLnYxLlRocmVlSXRlbVYxSXRlbVIFaXRlbXM=');

@$core.Deprecated('Use threeItemV1ItemDescriptor instead')
const ThreeItemV1Item$json = {
  '1': 'ThreeItemV1Item',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'cover_left_text', '3': 2, '4': 1, '5': 9, '10': 'coverLeftText'},
    {'1': 'cover_left_icon', '3': 3, '4': 1, '5': 5, '10': 'coverLeftIcon'},
    {'1': 'desc1', '3': 4, '4': 1, '5': 9, '10': 'desc1'},
    {'1': 'desc2', '3': 5, '4': 1, '5': 9, '10': 'desc2'},
    {'1': 'badge', '3': 6, '4': 1, '5': 9, '10': 'badge'},
  ],
};

/// Descriptor for `ThreeItemV1Item`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threeItemV1ItemDescriptor = $convert.base64Decode(
    'Cg9UaHJlZUl0ZW1WMUl0ZW0SLgoEYmFzZRgBIAEoCzIaLmJpbGliaWxpLmFwcC5jYXJkLnYxLk'
    'Jhc2VSBGJhc2USJgoPY292ZXJfbGVmdF90ZXh0GAIgASgJUg1jb3ZlckxlZnRUZXh0EiYKD2Nv'
    'dmVyX2xlZnRfaWNvbhgDIAEoBVINY292ZXJMZWZ0SWNvbhIUCgVkZXNjMRgEIAEoCVIFZGVzYz'
    'ESFAoFZGVzYzIYBSABKAlSBWRlc2MyEhQKBWJhZGdlGAYgASgJUgViYWRnZQ==');

@$core.Deprecated('Use threeItemV2Descriptor instead')
const ThreeItemV2$json = {
  '1': 'ThreeItemV2',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'title_icon', '3': 2, '4': 1, '5': 5, '10': 'titleIcon'},
    {'1': 'more_uri', '3': 3, '4': 1, '5': 9, '10': 'moreUri'},
    {'1': 'more_text', '3': 4, '4': 1, '5': 9, '10': 'moreText'},
    {
      '1': 'items',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.card.v1.ThreeItemV2Item',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ThreeItemV2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threeItemV2Descriptor = $convert.base64Decode(
    'CgtUaHJlZUl0ZW1WMhIuCgRiYXNlGAEgASgLMhouYmlsaWJpbGkuYXBwLmNhcmQudjEuQmFzZV'
    'IEYmFzZRIdCgp0aXRsZV9pY29uGAIgASgFUgl0aXRsZUljb24SGQoIbW9yZV91cmkYAyABKAlS'
    'B21vcmVVcmkSGwoJbW9yZV90ZXh0GAQgASgJUghtb3JlVGV4dBI7CgVpdGVtcxgFIAMoCzIlLm'
    'JpbGliaWxpLmFwcC5jYXJkLnYxLlRocmVlSXRlbVYySXRlbVIFaXRlbXM=');

@$core.Deprecated('Use threeItemV2ItemDescriptor instead')
const ThreeItemV2Item$json = {
  '1': 'ThreeItemV2Item',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'cover_left_icon', '3': 2, '4': 1, '5': 5, '10': 'coverLeftIcon'},
    {'1': 'desc_text1', '3': 3, '4': 1, '5': 9, '10': 'descText1'},
    {'1': 'desc_icon1', '3': 4, '4': 1, '5': 5, '10': 'descIcon1'},
    {'1': 'desc_text2', '3': 5, '4': 1, '5': 9, '10': 'descText2'},
    {'1': 'desc_icon2', '3': 6, '4': 1, '5': 5, '10': 'descIcon2'},
    {'1': 'badge', '3': 7, '4': 1, '5': 9, '10': 'badge'},
  ],
};

/// Descriptor for `ThreeItemV2Item`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threeItemV2ItemDescriptor = $convert.base64Decode(
    'Cg9UaHJlZUl0ZW1WMkl0ZW0SLgoEYmFzZRgBIAEoCzIaLmJpbGliaWxpLmFwcC5jYXJkLnYxLk'
    'Jhc2VSBGJhc2USJgoPY292ZXJfbGVmdF9pY29uGAIgASgFUg1jb3ZlckxlZnRJY29uEh0KCmRl'
    'c2NfdGV4dDEYAyABKAlSCWRlc2NUZXh0MRIdCgpkZXNjX2ljb24xGAQgASgFUglkZXNjSWNvbj'
    'ESHQoKZGVzY190ZXh0MhgFIAEoCVIJZGVzY1RleHQyEh0KCmRlc2NfaWNvbjIYBiABKAVSCWRl'
    'c2NJY29uMhIUCgViYWRnZRgHIAEoCVIFYmFkZ2U=');

@$core.Deprecated('Use threePicV2Descriptor instead')
const ThreePicV2$json = {
  '1': 'ThreePicV2',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'left_cover', '3': 2, '4': 1, '5': 9, '10': 'leftCover'},
    {'1': 'right_cover1', '3': 3, '4': 1, '5': 9, '10': 'rightCover1'},
    {'1': 'right_cover2', '3': 4, '4': 1, '5': 9, '10': 'rightCover2'},
    {'1': 'cover_left_text1', '3': 5, '4': 1, '5': 9, '10': 'coverLeftText1'},
    {'1': 'cover_left_icon1', '3': 6, '4': 1, '5': 5, '10': 'coverLeftIcon1'},
    {'1': 'cover_left_text2', '3': 7, '4': 1, '5': 9, '10': 'coverLeftText2'},
    {'1': 'cover_left_icon2', '3': 8, '4': 1, '5': 5, '10': 'coverLeftIcon2'},
    {'1': 'cover_right_text', '3': 9, '4': 1, '5': 9, '10': 'coverRightText'},
    {'1': 'cover_right_icon', '3': 10, '4': 1, '5': 5, '10': 'coverRightIcon'},
    {
      '1': 'cover_right_background_color',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'coverRightBackgroundColor'
    },
    {'1': 'badge', '3': 12, '4': 1, '5': 9, '10': 'badge'},
    {'1': 'rcmd_reason', '3': 13, '4': 1, '5': 9, '10': 'rcmdReason'},
    {'1': 'desc', '3': 14, '4': 1, '5': 9, '10': 'desc'},
    {
      '1': 'avatar',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Avatar',
      '10': 'avatar'
    },
    {
      '1': 'rcmd_reason_style',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'rcmdReasonStyle'
    },
  ],
};

/// Descriptor for `ThreePicV2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threePicV2Descriptor = $convert.base64Decode(
    'CgpUaHJlZVBpY1YyEi4KBGJhc2UYASABKAsyGi5iaWxpYmlsaS5hcHAuY2FyZC52MS5CYXNlUg'
    'RiYXNlEh0KCmxlZnRfY292ZXIYAiABKAlSCWxlZnRDb3ZlchIhCgxyaWdodF9jb3ZlcjEYAyAB'
    'KAlSC3JpZ2h0Q292ZXIxEiEKDHJpZ2h0X2NvdmVyMhgEIAEoCVILcmlnaHRDb3ZlcjISKAoQY2'
    '92ZXJfbGVmdF90ZXh0MRgFIAEoCVIOY292ZXJMZWZ0VGV4dDESKAoQY292ZXJfbGVmdF9pY29u'
    'MRgGIAEoBVIOY292ZXJMZWZ0SWNvbjESKAoQY292ZXJfbGVmdF90ZXh0MhgHIAEoCVIOY292ZX'
    'JMZWZ0VGV4dDISKAoQY292ZXJfbGVmdF9pY29uMhgIIAEoBVIOY292ZXJMZWZ0SWNvbjISKAoQ'
    'Y292ZXJfcmlnaHRfdGV4dBgJIAEoCVIOY292ZXJSaWdodFRleHQSKAoQY292ZXJfcmlnaHRfaW'
    'NvbhgKIAEoBVIOY292ZXJSaWdodEljb24SPwocY292ZXJfcmlnaHRfYmFja2dyb3VuZF9jb2xv'
    'chgLIAEoCVIZY292ZXJSaWdodEJhY2tncm91bmRDb2xvchIUCgViYWRnZRgMIAEoCVIFYmFkZ2'
    'USHwoLcmNtZF9yZWFzb24YDSABKAlSCnJjbWRSZWFzb24SEgoEZGVzYxgOIAEoCVIEZGVzYxI0'
    'CgZhdmF0YXIYDyABKAsyHC5iaWxpYmlsaS5hcHAuY2FyZC52MS5BdmF0YXJSBmF2YXRhchJNCh'
    'FyY21kX3JlYXNvbl9zdHlsZRgQIAEoCzIhLmJpbGliaWxpLmFwcC5jYXJkLnYxLlJlYXNvblN0'
    'eWxlUg9yY21kUmVhc29uU3R5bGU=');

@$core.Deprecated('Use threePicV3Descriptor instead')
const ThreePicV3$json = {
  '1': 'ThreePicV3',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'left_cover', '3': 2, '4': 1, '5': 9, '10': 'leftCover'},
    {'1': 'right_cover1', '3': 3, '4': 1, '5': 9, '10': 'rightCover1'},
    {'1': 'right_cover2', '3': 4, '4': 1, '5': 9, '10': 'rightCover2'},
    {'1': 'cover_left_text1', '3': 5, '4': 1, '5': 9, '10': 'coverLeftText1'},
    {'1': 'cover_left_icon1', '3': 6, '4': 1, '5': 5, '10': 'coverLeftIcon1'},
    {'1': 'cover_left_text2', '3': 7, '4': 1, '5': 9, '10': 'coverLeftText2'},
    {'1': 'cover_left_icon2', '3': 8, '4': 1, '5': 5, '10': 'coverLeftIcon2'},
    {'1': 'cover_right_text', '3': 9, '4': 1, '5': 9, '10': 'coverRightText'},
    {'1': 'cover_right_icon', '3': 10, '4': 1, '5': 5, '10': 'coverRightIcon'},
    {
      '1': 'cover_right_background_color',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'coverRightBackgroundColor'
    },
    {'1': 'badge', '3': 12, '4': 1, '5': 9, '10': 'badge'},
    {
      '1': 'rcmd_reason_style',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.ReasonStyle',
      '10': 'rcmdReasonStyle'
    },
  ],
};

/// Descriptor for `ThreePicV3`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threePicV3Descriptor = $convert.base64Decode(
    'CgpUaHJlZVBpY1YzEi4KBGJhc2UYASABKAsyGi5iaWxpYmlsaS5hcHAuY2FyZC52MS5CYXNlUg'
    'RiYXNlEh0KCmxlZnRfY292ZXIYAiABKAlSCWxlZnRDb3ZlchIhCgxyaWdodF9jb3ZlcjEYAyAB'
    'KAlSC3JpZ2h0Q292ZXIxEiEKDHJpZ2h0X2NvdmVyMhgEIAEoCVILcmlnaHRDb3ZlcjISKAoQY2'
    '92ZXJfbGVmdF90ZXh0MRgFIAEoCVIOY292ZXJMZWZ0VGV4dDESKAoQY292ZXJfbGVmdF9pY29u'
    'MRgGIAEoBVIOY292ZXJMZWZ0SWNvbjESKAoQY292ZXJfbGVmdF90ZXh0MhgHIAEoCVIOY292ZX'
    'JMZWZ0VGV4dDISKAoQY292ZXJfbGVmdF9pY29uMhgIIAEoBVIOY292ZXJMZWZ0SWNvbjISKAoQ'
    'Y292ZXJfcmlnaHRfdGV4dBgJIAEoCVIOY292ZXJSaWdodFRleHQSKAoQY292ZXJfcmlnaHRfaW'
    'NvbhgKIAEoBVIOY292ZXJSaWdodEljb24SPwocY292ZXJfcmlnaHRfYmFja2dyb3VuZF9jb2xv'
    'chgLIAEoCVIZY292ZXJSaWdodEJhY2tncm91bmRDb2xvchIUCgViYWRnZRgMIAEoCVIFYmFkZ2'
    'USTQoRcmNtZF9yZWFzb25fc3R5bGUYDSABKAsyIS5iaWxpYmlsaS5hcHAuY2FyZC52MS5SZWFz'
    'b25TdHlsZVIPcmNtZFJlYXNvblN0eWxl');

@$core.Deprecated('Use threePointDescriptor instead')
const ThreePoint$json = {
  '1': 'ThreePoint',
  '2': [
    {
      '1': 'dislike_reasons',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.card.v1.DislikeReason',
      '10': 'dislikeReasons'
    },
    {
      '1': 'feedbacks',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.card.v1.DislikeReason',
      '10': 'feedbacks'
    },
    {'1': 'watch_later', '3': 3, '4': 1, '5': 5, '10': 'watchLater'},
  ],
};

/// Descriptor for `ThreePoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threePointDescriptor = $convert.base64Decode(
    'CgpUaHJlZVBvaW50EkwKD2Rpc2xpa2VfcmVhc29ucxgBIAMoCzIjLmJpbGliaWxpLmFwcC5jYX'
    'JkLnYxLkRpc2xpa2VSZWFzb25SDmRpc2xpa2VSZWFzb25zEkEKCWZlZWRiYWNrcxgCIAMoCzIj'
    'LmJpbGliaWxpLmFwcC5jYXJkLnYxLkRpc2xpa2VSZWFzb25SCWZlZWRiYWNrcxIfCgt3YXRjaF'
    '9sYXRlchgDIAEoBVIKd2F0Y2hMYXRlcg==');

@$core.Deprecated('Use threePointV2Descriptor instead')
const ThreePointV2$json = {
  '1': 'ThreePointV2',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'subtitle', '3': 2, '4': 1, '5': 9, '10': 'subtitle'},
    {
      '1': 'reasons',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.card.v1.DislikeReason',
      '10': 'reasons'
    },
    {'1': 'type', '3': 4, '4': 1, '5': 9, '10': 'type'},
    {'1': 'id', '3': 5, '4': 1, '5': 3, '10': 'id'},
  ],
};

/// Descriptor for `ThreePointV2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threePointV2Descriptor = $convert.base64Decode(
    'CgxUaHJlZVBvaW50VjISFAoFdGl0bGUYASABKAlSBXRpdGxlEhoKCHN1YnRpdGxlGAIgASgJUg'
    'hzdWJ0aXRsZRI9CgdyZWFzb25zGAMgAygLMiMuYmlsaWJpbGkuYXBwLmNhcmQudjEuRGlzbGlr'
    'ZVJlYXNvblIHcmVhc29ucxISCgR0eXBlGAQgASgJUgR0eXBlEg4KAmlkGAUgASgDUgJpZA==');

@$core.Deprecated('Use threePointV3Descriptor instead')
const ThreePointV3$json = {
  '1': 'ThreePointV3',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'selected_title', '3': 2, '4': 1, '5': 9, '10': 'selectedTitle'},
    {'1': 'subtitle', '3': 3, '4': 1, '5': 9, '10': 'subtitle'},
    {
      '1': 'reasons',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.card.v1.DislikeReason',
      '10': 'reasons'
    },
    {'1': 'type', '3': 5, '4': 1, '5': 9, '10': 'type'},
    {'1': 'id', '3': 6, '4': 1, '5': 3, '10': 'id'},
    {'1': 'selected', '3': 7, '4': 1, '5': 5, '10': 'selected'},
    {'1': 'icon', '3': 8, '4': 1, '5': 9, '10': 'icon'},
    {'1': 'selected_icon', '3': 9, '4': 1, '5': 9, '10': 'selectedIcon'},
    {'1': 'url', '3': 10, '4': 1, '5': 9, '10': 'url'},
    {'1': 'default_id', '3': 11, '4': 1, '5': 5, '10': 'defaultId'},
  ],
};

/// Descriptor for `ThreePointV3`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threePointV3Descriptor = $convert.base64Decode(
    'CgxUaHJlZVBvaW50VjMSFAoFdGl0bGUYASABKAlSBXRpdGxlEiUKDnNlbGVjdGVkX3RpdGxlGA'
    'IgASgJUg1zZWxlY3RlZFRpdGxlEhoKCHN1YnRpdGxlGAMgASgJUghzdWJ0aXRsZRI9CgdyZWFz'
    'b25zGAQgAygLMiMuYmlsaWJpbGkuYXBwLmNhcmQudjEuRGlzbGlrZVJlYXNvblIHcmVhc29ucx'
    'ISCgR0eXBlGAUgASgJUgR0eXBlEg4KAmlkGAYgASgDUgJpZBIaCghzZWxlY3RlZBgHIAEoBVII'
    'c2VsZWN0ZWQSEgoEaWNvbhgIIAEoCVIEaWNvbhIjCg1zZWxlY3RlZF9pY29uGAkgASgJUgxzZW'
    'xlY3RlZEljb24SEAoDdXJsGAogASgJUgN1cmwSHQoKZGVmYXVsdF9pZBgLIAEoBVIJZGVmYXVs'
    'dElk');

@$core.Deprecated('Use threePointV4Descriptor instead')
const ThreePointV4$json = {
  '1': 'ThreePointV4',
  '2': [
    {
      '1': 'share_plane',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.SharePlane',
      '10': 'sharePlane'
    },
    {
      '1': 'watch_later',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.WatchLater',
      '10': 'watchLater'
    },
  ],
};

/// Descriptor for `ThreePointV4`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List threePointV4Descriptor = $convert.base64Decode(
    'CgxUaHJlZVBvaW50VjQSQQoLc2hhcmVfcGxhbmUYASABKAsyIC5iaWxpYmlsaS5hcHAuY2FyZC'
    '52MS5TaGFyZVBsYW5lUgpzaGFyZVBsYW5lEkEKC3dhdGNoX2xhdGVyGAIgASgLMiAuYmlsaWJp'
    'bGkuYXBwLmNhcmQudjEuV2F0Y2hMYXRlclIKd2F0Y2hMYXRlcg==');

@$core.Deprecated('Use topicButtonDescriptor instead')
const TopicButton$json = {
  '1': 'TopicButton',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'jump_uri', '3': 2, '4': 1, '5': 9, '10': 'jumpUri'},
    {'1': 'red_dot', '3': 3, '4': 1, '5': 8, '10': 'redDot'},
  ],
};

/// Descriptor for `TopicButton`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List topicButtonDescriptor = $convert.base64Decode(
    'CgtUb3BpY0J1dHRvbhIUCgV0aXRsZRgBIAEoCVIFdGl0bGUSGQoIanVtcF91cmkYAiABKAlSB2'
    'p1bXBVcmkSFwoHcmVkX2RvdBgDIAEoCFIGcmVkRG90');

@$core.Deprecated('Use topicListDescriptor instead')
const TopicList$json = {
  '1': 'TopicList',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'title_icon', '3': 3, '4': 1, '5': 9, '10': 'titleIcon'},
    {
      '1': 'more_button',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.TopicButton',
      '10': 'moreButton'
    },
    {
      '1': 'topic_list_item',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.card.v1.TopicListItem',
      '10': 'topicListItem'
    },
  ],
};

/// Descriptor for `TopicList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List topicListDescriptor = $convert.base64Decode(
    'CglUb3BpY0xpc3QSLgoEYmFzZRgBIAEoCzIaLmJpbGliaWxpLmFwcC5jYXJkLnYxLkJhc2VSBG'
    'Jhc2USFAoFdGl0bGUYAiABKAlSBXRpdGxlEh0KCnRpdGxlX2ljb24YAyABKAlSCXRpdGxlSWNv'
    'bhJCCgttb3JlX2J1dHRvbhgEIAEoCzIhLmJpbGliaWxpLmFwcC5jYXJkLnYxLlRvcGljQnV0dG'
    '9uUgptb3JlQnV0dG9uEksKD3RvcGljX2xpc3RfaXRlbRgFIAMoCzIjLmJpbGliaWxpLmFwcC5j'
    'YXJkLnYxLlRvcGljTGlzdEl0ZW1SDXRvcGljTGlzdEl0ZW0=');

@$core.Deprecated('Use topicListItemDescriptor instead')
const TopicListItem$json = {
  '1': 'TopicListItem',
  '2': [
    {'1': 'icon', '3': 1, '4': 1, '5': 9, '10': 'icon'},
    {'1': 'icon_title', '3': 2, '4': 1, '5': 9, '10': 'iconTitle'},
    {'1': 'topic_id', '3': 3, '4': 1, '5': 3, '10': 'topicId'},
    {'1': 'topic_name', '3': 4, '4': 1, '5': 9, '10': 'topicName'},
    {'1': 'url', '3': 5, '4': 1, '5': 9, '10': 'url'},
    {'1': 'up_mid', '3': 6, '4': 1, '5': 3, '10': 'upMid'},
    {'1': 'position', '3': 7, '4': 1, '5': 3, '10': 'position'},
  ],
};

/// Descriptor for `TopicListItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List topicListItemDescriptor = $convert.base64Decode(
    'Cg1Ub3BpY0xpc3RJdGVtEhIKBGljb24YASABKAlSBGljb24SHQoKaWNvbl90aXRsZRgCIAEoCV'
    'IJaWNvblRpdGxlEhkKCHRvcGljX2lkGAMgASgDUgd0b3BpY0lkEh0KCnRvcGljX25hbWUYBCAB'
    'KAlSCXRvcGljTmFtZRIQCgN1cmwYBSABKAlSA3VybBIVCgZ1cF9taWQYBiABKANSBXVwTWlkEh'
    'oKCHBvc2l0aW9uGAcgASgDUghwb3NpdGlvbg==');

@$core.Deprecated('Use twoItemHV1ItemDescriptor instead')
const TwoItemHV1Item$json = {
  '1': 'TwoItemHV1Item',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'cover', '3': 2, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'uri', '3': 3, '4': 1, '5': 9, '10': 'uri'},
    {'1': 'param', '3': 4, '4': 1, '5': 9, '10': 'param'},
    {
      '1': 'args',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Args',
      '10': 'args'
    },
    {'1': 'goto', '3': 6, '4': 1, '5': 9, '10': 'goto'},
    {'1': 'cover_left_text1', '3': 7, '4': 1, '5': 9, '10': 'coverLeftText1'},
    {'1': 'cover_left_icon1', '3': 8, '4': 1, '5': 5, '10': 'coverLeftIcon1'},
    {'1': 'cover_right_text', '3': 9, '4': 1, '5': 9, '10': 'coverRightText'},
  ],
};

/// Descriptor for `TwoItemHV1Item`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List twoItemHV1ItemDescriptor = $convert.base64Decode(
    'Cg5Ud29JdGVtSFYxSXRlbRIUCgV0aXRsZRgBIAEoCVIFdGl0bGUSFAoFY292ZXIYAiABKAlSBW'
    'NvdmVyEhAKA3VyaRgDIAEoCVIDdXJpEhQKBXBhcmFtGAQgASgJUgVwYXJhbRIuCgRhcmdzGAUg'
    'ASgLMhouYmlsaWJpbGkuYXBwLmNhcmQudjEuQXJnc1IEYXJncxISCgRnb3RvGAYgASgJUgRnb3'
    'RvEigKEGNvdmVyX2xlZnRfdGV4dDEYByABKAlSDmNvdmVyTGVmdFRleHQxEigKEGNvdmVyX2xl'
    'ZnRfaWNvbjEYCCABKAVSDmNvdmVyTGVmdEljb24xEigKEGNvdmVyX3JpZ2h0X3RleHQYCSABKA'
    'lSDmNvdmVyUmlnaHRUZXh0');

@$core.Deprecated('Use twoItemV2Descriptor instead')
const TwoItemV2$json = {
  '1': 'TwoItemV2',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {
      '1': 'items',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.card.v1.TwoItemV2Item',
      '10': 'items'
    },
  ],
};

/// Descriptor for `TwoItemV2`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List twoItemV2Descriptor = $convert.base64Decode(
    'CglUd29JdGVtVjISLgoEYmFzZRgBIAEoCzIaLmJpbGliaWxpLmFwcC5jYXJkLnYxLkJhc2VSBG'
    'Jhc2USOQoFaXRlbXMYAiADKAsyIy5iaWxpYmlsaS5hcHAuY2FyZC52MS5Ud29JdGVtVjJJdGVt'
    'UgVpdGVtcw==');

@$core.Deprecated('Use twoItemV2ItemDescriptor instead')
const TwoItemV2Item$json = {
  '1': 'TwoItemV2Item',
  '2': [
    {
      '1': 'base',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Base',
      '10': 'base'
    },
    {'1': 'badge', '3': 2, '4': 1, '5': 9, '10': 'badge'},
    {'1': 'cover_left_text1', '3': 3, '4': 1, '5': 9, '10': 'coverLeftText1'},
    {'1': 'cover_left_icon1', '3': 4, '4': 1, '5': 5, '10': 'coverLeftIcon1'},
  ],
};

/// Descriptor for `TwoItemV2Item`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List twoItemV2ItemDescriptor = $convert.base64Decode(
    'Cg1Ud29JdGVtVjJJdGVtEi4KBGJhc2UYASABKAsyGi5iaWxpYmlsaS5hcHAuY2FyZC52MS5CYX'
    'NlUgRiYXNlEhQKBWJhZGdlGAIgASgJUgViYWRnZRIoChBjb3Zlcl9sZWZ0X3RleHQxGAMgASgJ'
    'Ug5jb3ZlckxlZnRUZXh0MRIoChBjb3Zlcl9sZWZ0X2ljb24xGAQgASgFUg5jb3ZlckxlZnRJY2'
    '9uMQ==');

@$core.Deprecated('Use upDescriptor instead')
const Up$json = {
  '1': 'Up',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'desc', '3': 3, '4': 1, '5': 9, '10': 'desc'},
    {
      '1': 'avatar',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Avatar',
      '10': 'avatar'
    },
    {'1': 'official_icon', '3': 5, '4': 1, '5': 5, '10': 'officialIcon'},
    {
      '1': 'desc_button',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.Button',
      '10': 'descButton'
    },
    {'1': 'cooperation', '3': 7, '4': 1, '5': 9, '10': 'cooperation'},
  ],
};

/// Descriptor for `Up`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upDescriptor = $convert.base64Decode(
    'CgJVcBIOCgJpZBgBIAEoA1ICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRISCgRkZXNjGAMgASgJUg'
    'RkZXNjEjQKBmF2YXRhchgEIAEoCzIcLmJpbGliaWxpLmFwcC5jYXJkLnYxLkF2YXRhclIGYXZh'
    'dGFyEiMKDW9mZmljaWFsX2ljb24YBSABKAVSDG9mZmljaWFsSWNvbhI9CgtkZXNjX2J1dHRvbh'
    'gGIAEoCzIcLmJpbGliaWxpLmFwcC5jYXJkLnYxLkJ1dHRvblIKZGVzY0J1dHRvbhIgCgtjb29w'
    'ZXJhdGlvbhgHIAEoCVILY29vcGVyYXRpb24=');

@$core.Deprecated('Use upArgsDescriptor instead')
const UpArgs$json = {
  '1': 'UpArgs',
  '2': [
    {'1': 'up_id', '3': 1, '4': 1, '5': 3, '10': 'upId'},
    {'1': 'up_name', '3': 2, '4': 1, '5': 9, '10': 'upName'},
    {'1': 'up_face', '3': 3, '4': 1, '5': 9, '10': 'upFace'},
    {'1': 'selected', '3': 4, '4': 1, '5': 3, '10': 'selected'},
  ],
};

/// Descriptor for `UpArgs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upArgsDescriptor = $convert.base64Decode(
    'CgZVcEFyZ3MSEwoFdXBfaWQYASABKANSBHVwSWQSFwoHdXBfbmFtZRgCIAEoCVIGdXBOYW1lEh'
    'cKB3VwX2ZhY2UYAyABKAlSBnVwRmFjZRIaCghzZWxlY3RlZBgEIAEoA1IIc2VsZWN0ZWQ=');

@$core.Deprecated('Use watchLaterDescriptor instead')
const WatchLater$json = {
  '1': 'WatchLater',
  '2': [
    {'1': 'aid', '3': 1, '4': 1, '5': 3, '10': 'aid'},
    {'1': 'bvid', '3': 2, '4': 1, '5': 9, '10': 'bvid'},
  ],
};

/// Descriptor for `WatchLater`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchLaterDescriptor = $convert.base64Decode(
    'CgpXYXRjaExhdGVyEhAKA2FpZBgBIAEoA1IDYWlkEhIKBGJ2aWQYAiABKAlSBGJ2aWQ=');
