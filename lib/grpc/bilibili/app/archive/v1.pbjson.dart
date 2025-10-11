// This is a generated file - do not edit.
//
// Generated from bilibili/app/archive/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use arcDescriptor instead')
const Arc$json = {
  '1': 'Arc',
  '2': [
    {'1': 'aid', '3': 1, '4': 1, '5': 3, '10': 'aid'},
    {'1': 'videos', '3': 2, '4': 1, '5': 3, '10': 'videos'},
    {'1': 'type_id', '3': 3, '4': 1, '5': 5, '10': 'typeId'},
    {'1': 'type_name', '3': 4, '4': 1, '5': 9, '10': 'typeName'},
    {'1': 'copyright', '3': 5, '4': 1, '5': 5, '10': 'copyright'},
    {'1': 'pic', '3': 6, '4': 1, '5': 9, '10': 'pic'},
    {'1': 'title', '3': 7, '4': 1, '5': 9, '10': 'title'},
    {'1': 'pubdate', '3': 8, '4': 1, '5': 3, '10': 'pubdate'},
    {'1': 'ctime', '3': 9, '4': 1, '5': 3, '10': 'ctime'},
    {'1': 'desc', '3': 10, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'state', '3': 11, '4': 1, '5': 5, '10': 'state'},
    {'1': 'access', '3': 12, '4': 1, '5': 5, '10': 'access'},
    {'1': 'attribute', '3': 13, '4': 1, '5': 5, '10': 'attribute'},
    {'1': 'tag', '3': 14, '4': 1, '5': 9, '10': 'tag'},
    {'1': 'tags', '3': 15, '4': 3, '5': 9, '10': 'tags'},
    {'1': 'duration', '3': 16, '4': 1, '5': 3, '10': 'duration'},
    {'1': 'mission_id', '3': 17, '4': 1, '5': 3, '10': 'missionId'},
    {'1': 'order_id', '3': 18, '4': 1, '5': 3, '10': 'orderId'},
    {'1': 'redirect_url', '3': 19, '4': 1, '5': 9, '10': 'redirectUrl'},
    {'1': 'forward', '3': 20, '4': 1, '5': 3, '10': 'forward'},
    {
      '1': 'rights',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.archive.v1.Rights',
      '10': 'rights'
    },
    {
      '1': 'author',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.archive.v1.Author',
      '10': 'author'
    },
    {
      '1': 'stat',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.archive.v1.Stat',
      '10': 'stat'
    },
    {'1': 'report_result', '3': 24, '4': 1, '5': 9, '10': 'reportResult'},
    {'1': 'dynamic', '3': 25, '4': 1, '5': 9, '10': 'dynamic'},
    {'1': 'first_cid', '3': 26, '4': 1, '5': 3, '10': 'firstCid'},
    {
      '1': 'dimension',
      '3': 27,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.archive.v1.Dimension',
      '10': 'dimension'
    },
    {
      '1': 'staff_info',
      '3': 28,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.archive.v1.StaffInfo',
      '10': 'staffInfo'
    },
    {'1': 'season_id', '3': 29, '4': 1, '5': 3, '10': 'seasonId'},
    {'1': 'attribute_v2', '3': 30, '4': 1, '5': 3, '10': 'attributeV2'},
    {
      '1': 'season_theme',
      '3': 31,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.archive.v1.SeasonTheme',
      '10': 'seasonTheme'
    },
    {'1': 'short_link_v2', '3': 40, '4': 1, '5': 9, '10': 'shortLinkV2'},
    {'1': 'up_from_v2', '3': 41, '4': 1, '5': 5, '10': 'upFromV2'},
    {'1': 'first_frame', '3': 42, '4': 1, '5': 9, '10': 'firstFrame'},
  ],
};

/// Descriptor for `Arc`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List arcDescriptor = $convert.base64Decode(
    'CgNBcmMSEAoDYWlkGAEgASgDUgNhaWQSFgoGdmlkZW9zGAIgASgDUgZ2aWRlb3MSFwoHdHlwZV'
    '9pZBgDIAEoBVIGdHlwZUlkEhsKCXR5cGVfbmFtZRgEIAEoCVIIdHlwZU5hbWUSHAoJY29weXJp'
    'Z2h0GAUgASgFUgljb3B5cmlnaHQSEAoDcGljGAYgASgJUgNwaWMSFAoFdGl0bGUYByABKAlSBX'
    'RpdGxlEhgKB3B1YmRhdGUYCCABKANSB3B1YmRhdGUSFAoFY3RpbWUYCSABKANSBWN0aW1lEhIK'
    'BGRlc2MYCiABKAlSBGRlc2MSFAoFc3RhdGUYCyABKAVSBXN0YXRlEhYKBmFjY2VzcxgMIAEoBV'
    'IGYWNjZXNzEhwKCWF0dHJpYnV0ZRgNIAEoBVIJYXR0cmlidXRlEhAKA3RhZxgOIAEoCVIDdGFn'
    'EhIKBHRhZ3MYDyADKAlSBHRhZ3MSGgoIZHVyYXRpb24YECABKANSCGR1cmF0aW9uEh0KCm1pc3'
    'Npb25faWQYESABKANSCW1pc3Npb25JZBIZCghvcmRlcl9pZBgSIAEoA1IHb3JkZXJJZBIhCgxy'
    'ZWRpcmVjdF91cmwYEyABKAlSC3JlZGlyZWN0VXJsEhgKB2ZvcndhcmQYFCABKANSB2Zvcndhcm'
    'QSNwoGcmlnaHRzGBUgASgLMh8uYmlsaWJpbGkuYXBwLmFyY2hpdmUudjEuUmlnaHRzUgZyaWdo'
    'dHMSNwoGYXV0aG9yGBYgASgLMh8uYmlsaWJpbGkuYXBwLmFyY2hpdmUudjEuQXV0aG9yUgZhdX'
    'Rob3ISMQoEc3RhdBgXIAEoCzIdLmJpbGliaWxpLmFwcC5hcmNoaXZlLnYxLlN0YXRSBHN0YXQS'
    'IwoNcmVwb3J0X3Jlc3VsdBgYIAEoCVIMcmVwb3J0UmVzdWx0EhgKB2R5bmFtaWMYGSABKAlSB2'
    'R5bmFtaWMSGwoJZmlyc3RfY2lkGBogASgDUghmaXJzdENpZBJACglkaW1lbnNpb24YGyABKAsy'
    'Ii5iaWxpYmlsaS5hcHAuYXJjaGl2ZS52MS5EaW1lbnNpb25SCWRpbWVuc2lvbhJBCgpzdGFmZl'
    '9pbmZvGBwgAygLMiIuYmlsaWJpbGkuYXBwLmFyY2hpdmUudjEuU3RhZmZJbmZvUglzdGFmZklu'
    'Zm8SGwoJc2Vhc29uX2lkGB0gASgDUghzZWFzb25JZBIhCgxhdHRyaWJ1dGVfdjIYHiABKANSC2'
    'F0dHJpYnV0ZVYyEkcKDHNlYXNvbl90aGVtZRgfIAEoCzIkLmJpbGliaWxpLmFwcC5hcmNoaXZl'
    'LnYxLlNlYXNvblRoZW1lUgtzZWFzb25UaGVtZRIiCg1zaG9ydF9saW5rX3YyGCggASgJUgtzaG'
    '9ydExpbmtWMhIcCgp1cF9mcm9tX3YyGCkgASgFUgh1cEZyb21WMhIfCgtmaXJzdF9mcmFtZRgq'
    'IAEoCVIKZmlyc3RGcmFtZQ==');

@$core.Deprecated('Use authorDescriptor instead')
const Author$json = {
  '1': 'Author',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'face', '3': 3, '4': 1, '5': 9, '10': 'face'},
  ],
};

/// Descriptor for `Author`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authorDescriptor = $convert.base64Decode(
    'CgZBdXRob3ISEAoDbWlkGAEgASgDUgNtaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRISCgRmYWNlGA'
    'MgASgJUgRmYWNl');

@$core.Deprecated('Use dimensionDescriptor instead')
const Dimension$json = {
  '1': 'Dimension',
  '2': [
    {'1': 'width', '3': 1, '4': 1, '5': 3, '10': 'width'},
    {'1': 'height', '3': 2, '4': 1, '5': 3, '10': 'height'},
    {'1': 'rotate', '3': 3, '4': 1, '5': 3, '10': 'rotate'},
  ],
};

/// Descriptor for `Dimension`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dimensionDescriptor = $convert.base64Decode(
    'CglEaW1lbnNpb24SFAoFd2lkdGgYASABKANSBXdpZHRoEhYKBmhlaWdodBgCIAEoA1IGaGVpZ2'
    'h0EhYKBnJvdGF0ZRgDIAEoA1IGcm90YXRl');

@$core.Deprecated('Use pageDescriptor instead')
const Page$json = {
  '1': 'Page',
  '2': [
    {'1': 'cid', '3': 1, '4': 1, '5': 3, '10': 'cid'},
    {'1': 'page', '3': 2, '4': 1, '5': 5, '10': 'page'},
    {'1': 'from', '3': 3, '4': 1, '5': 9, '10': 'from'},
    {'1': 'part', '3': 4, '4': 1, '5': 9, '10': 'part'},
    {'1': 'duration', '3': 5, '4': 1, '5': 3, '10': 'duration'},
    {'1': 'vid', '3': 6, '4': 1, '5': 9, '10': 'vid'},
    {'1': 'desc', '3': 7, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'web_link', '3': 8, '4': 1, '5': 9, '10': 'webLink'},
    {
      '1': 'dimension',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.archive.v1.Dimension',
      '10': 'dimension'
    },
    {'1': 'first_frame', '3': 10, '4': 1, '5': 9, '10': 'firstFrame'},
  ],
};

/// Descriptor for `Page`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pageDescriptor = $convert.base64Decode(
    'CgRQYWdlEhAKA2NpZBgBIAEoA1IDY2lkEhIKBHBhZ2UYAiABKAVSBHBhZ2USEgoEZnJvbRgDIA'
    'EoCVIEZnJvbRISCgRwYXJ0GAQgASgJUgRwYXJ0EhoKCGR1cmF0aW9uGAUgASgDUghkdXJhdGlv'
    'bhIQCgN2aWQYBiABKAlSA3ZpZBISCgRkZXNjGAcgASgJUgRkZXNjEhkKCHdlYl9saW5rGAggAS'
    'gJUgd3ZWJMaW5rEkAKCWRpbWVuc2lvbhgJIAEoCzIiLmJpbGliaWxpLmFwcC5hcmNoaXZlLnYx'
    'LkRpbWVuc2lvblIJZGltZW5zaW9uEh8KC2ZpcnN0X2ZyYW1lGAogASgJUgpmaXJzdEZyYW1l');

@$core.Deprecated('Use rightsDescriptor instead')
const Rights$json = {
  '1': 'Rights',
  '2': [
    {'1': 'bp', '3': 1, '4': 1, '5': 5, '10': 'bp'},
    {'1': 'elec', '3': 2, '4': 1, '5': 5, '10': 'elec'},
    {'1': 'download', '3': 3, '4': 1, '5': 5, '10': 'download'},
    {'1': 'movie', '3': 4, '4': 1, '5': 5, '10': 'movie'},
    {'1': 'pay', '3': 5, '4': 1, '5': 5, '10': 'pay'},
    {'1': 'hd5', '3': 6, '4': 1, '5': 5, '10': 'hd5'},
    {'1': 'no_reprint', '3': 7, '4': 1, '5': 5, '10': 'noReprint'},
    {'1': 'autoplay', '3': 8, '4': 1, '5': 5, '10': 'autoplay'},
    {'1': 'ugc_pay', '3': 9, '4': 1, '5': 5, '10': 'ugcPay'},
    {'1': 'is_cooperation', '3': 10, '4': 1, '5': 5, '10': 'isCooperation'},
    {'1': 'ugc_pay_preview', '3': 11, '4': 1, '5': 5, '10': 'ugcPayPreview'},
    {'1': 'no_background', '3': 12, '4': 1, '5': 5, '10': 'noBackground'},
    {'1': 'arc_pay', '3': 13, '4': 1, '5': 5, '10': 'arcPay'},
    {'1': 'pay_free_watch', '3': 14, '4': 1, '5': 5, '10': 'payFreeWatch'},
  ],
};

/// Descriptor for `Rights`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rightsDescriptor = $convert.base64Decode(
    'CgZSaWdodHMSDgoCYnAYASABKAVSAmJwEhIKBGVsZWMYAiABKAVSBGVsZWMSGgoIZG93bmxvYW'
    'QYAyABKAVSCGRvd25sb2FkEhQKBW1vdmllGAQgASgFUgVtb3ZpZRIQCgNwYXkYBSABKAVSA3Bh'
    'eRIQCgNoZDUYBiABKAVSA2hkNRIdCgpub19yZXByaW50GAcgASgFUglub1JlcHJpbnQSGgoIYX'
    'V0b3BsYXkYCCABKAVSCGF1dG9wbGF5EhcKB3VnY19wYXkYCSABKAVSBnVnY1BheRIlCg5pc19j'
    'b29wZXJhdGlvbhgKIAEoBVINaXNDb29wZXJhdGlvbhImCg91Z2NfcGF5X3ByZXZpZXcYCyABKA'
    'VSDXVnY1BheVByZXZpZXcSIwoNbm9fYmFja2dyb3VuZBgMIAEoBVIMbm9CYWNrZ3JvdW5kEhcK'
    'B2FyY19wYXkYDSABKAVSBmFyY1BheRIkCg5wYXlfZnJlZV93YXRjaBgOIAEoBVIMcGF5RnJlZV'
    'dhdGNo');

@$core.Deprecated('Use seasonThemeDescriptor instead')
const SeasonTheme$json = {
  '1': 'SeasonTheme',
  '2': [
    {'1': 'bg_color', '3': 1, '4': 1, '5': 9, '10': 'bgColor'},
    {'1': 'selected_bg_color', '3': 2, '4': 1, '5': 9, '10': 'selectedBgColor'},
    {'1': 'text_color', '3': 3, '4': 1, '5': 9, '10': 'textColor'},
  ],
};

/// Descriptor for `SeasonTheme`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seasonThemeDescriptor = $convert.base64Decode(
    'CgtTZWFzb25UaGVtZRIZCghiZ19jb2xvchgBIAEoCVIHYmdDb2xvchIqChFzZWxlY3RlZF9iZ1'
    '9jb2xvchgCIAEoCVIPc2VsZWN0ZWRCZ0NvbG9yEh0KCnRleHRfY29sb3IYAyABKAlSCXRleHRD'
    'b2xvcg==');

@$core.Deprecated('Use staffInfoDescriptor instead')
const StaffInfo$json = {
  '1': 'StaffInfo',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'attribute', '3': 3, '4': 1, '5': 3, '10': 'attribute'},
  ],
};

/// Descriptor for `StaffInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List staffInfoDescriptor = $convert.base64Decode(
    'CglTdGFmZkluZm8SEAoDbWlkGAEgASgDUgNtaWQSFAoFdGl0bGUYAiABKAlSBXRpdGxlEhwKCW'
    'F0dHJpYnV0ZRgDIAEoA1IJYXR0cmlidXRl');

@$core.Deprecated('Use statDescriptor instead')
const Stat$json = {
  '1': 'Stat',
  '2': [
    {'1': 'aid', '3': 1, '4': 1, '5': 3, '10': 'aid'},
    {'1': 'view', '3': 2, '4': 1, '5': 5, '10': 'view'},
    {'1': 'danmaku', '3': 3, '4': 1, '5': 5, '10': 'danmaku'},
    {'1': 'reply', '3': 4, '4': 1, '5': 5, '10': 'reply'},
    {'1': 'fav', '3': 5, '4': 1, '5': 5, '10': 'fav'},
    {'1': 'coin', '3': 6, '4': 1, '5': 5, '10': 'coin'},
    {'1': 'share', '3': 7, '4': 1, '5': 5, '10': 'share'},
    {'1': 'now_rank', '3': 8, '4': 1, '5': 5, '10': 'nowRank'},
    {'1': 'his_rank', '3': 9, '4': 1, '5': 5, '10': 'hisRank'},
    {'1': 'like', '3': 10, '4': 1, '5': 5, '10': 'like'},
    {'1': 'dislike', '3': 11, '4': 1, '5': 5, '10': 'dislike'},
  ],
};

/// Descriptor for `Stat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statDescriptor = $convert.base64Decode(
    'CgRTdGF0EhAKA2FpZBgBIAEoA1IDYWlkEhIKBHZpZXcYAiABKAVSBHZpZXcSGAoHZGFubWFrdR'
    'gDIAEoBVIHZGFubWFrdRIUCgVyZXBseRgEIAEoBVIFcmVwbHkSEAoDZmF2GAUgASgFUgNmYXYS'
    'EgoEY29pbhgGIAEoBVIEY29pbhIUCgVzaGFyZRgHIAEoBVIFc2hhcmUSGQoIbm93X3JhbmsYCC'
    'ABKAVSB25vd1JhbmsSGQoIaGlzX3JhbmsYCSABKAVSB2hpc1JhbmsSEgoEbGlrZRgKIAEoBVIE'
    'bGlrZRIYCgdkaXNsaWtlGAsgASgFUgdkaXNsaWtl');
