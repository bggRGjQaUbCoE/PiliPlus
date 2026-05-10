// This is a generated file - do not edit.
//
// Generated from bilibili/app/interfaces/v1.proto.

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

@$core.Deprecated('Use arcDescriptor instead')
const Arc$json = {
  '1': 'Arc',
  '2': [
    {
      '1': 'archive',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.archive.v1.Arc',
      '10': 'archive'
    },
    {'1': 'uri', '3': 2, '4': 1, '5': 9, '10': 'uri'},
    {'1': 'view_content', '3': 3, '4': 1, '5': 9, '10': 'viewContent'},
    {'1': 'cover_icon', '3': 5, '4': 1, '5': 9, '10': 'coverIcon'},
    {'1': 'is_pugv', '3': 7, '4': 1, '5': 8, '10': 'isPugv'},
    {'1': 'publish_time_text', '3': 8, '4': 1, '5': 9, '10': 'publishTimeText'},
    {'1': 'badges', '3': 9, '4': 3, '5': 9, '10': 'badges'},
  ],
};

/// Descriptor for `Arc`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List arcDescriptor = $convert.base64Decode(
    'CgNBcmMSNgoHYXJjaGl2ZRgBIAEoCzIcLmJpbGliaWxpLmFwcC5hcmNoaXZlLnYxLkFyY1IHYX'
    'JjaGl2ZRIQCgN1cmkYAiABKAlSA3VyaRIhCgx2aWV3X2NvbnRlbnQYAyABKAlSC3ZpZXdDb250'
    'ZW50Eh0KCmNvdmVyX2ljb24YBSABKAlSCWNvdmVySWNvbhIXCgdpc19wdWd2GAcgASgIUgZpc1'
    'B1Z3YSKgoRcHVibGlzaF90aW1lX3RleHQYCCABKAlSD3B1Ymxpc2hUaW1lVGV4dBIWCgZiYWRn'
    'ZXMYCSADKAlSBmJhZGdlcw==');

@$core.Deprecated('Use searchArchiveReplyDescriptor instead')
const SearchArchiveReply$json = {
  '1': 'SearchArchiveReply',
  '2': [
    {
      '1': 'archives',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.Arc',
      '10': 'archives'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 3, '10': 'total'},
  ],
};

/// Descriptor for `SearchArchiveReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchArchiveReplyDescriptor = $convert.base64Decode(
    'ChJTZWFyY2hBcmNoaXZlUmVwbHkSOwoIYXJjaGl2ZXMYASADKAsyHy5iaWxpYmlsaS5hcHAuaW'
    '50ZXJmYWNlcy52MS5BcmNSCGFyY2hpdmVzEhQKBXRvdGFsGAIgASgDUgV0b3RhbA==');

@$core.Deprecated('Use searchArchiveReqDescriptor instead')
const SearchArchiveReq$json = {
  '1': 'SearchArchiveReq',
  '2': [
    {'1': 'keyword', '3': 1, '4': 1, '5': 9, '10': 'keyword'},
    {'1': 'mid', '3': 2, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'pn', '3': 3, '4': 1, '5': 3, '10': 'pn'},
    {'1': 'ps', '3': 4, '4': 1, '5': 3, '10': 'ps'},
  ],
};

/// Descriptor for `SearchArchiveReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchArchiveReqDescriptor = $convert.base64Decode(
    'ChBTZWFyY2hBcmNoaXZlUmVxEhgKB2tleXdvcmQYASABKAlSB2tleXdvcmQSEAoDbWlkGAIgAS'
    'gDUgNtaWQSDgoCcG4YAyABKANSAnBuEg4KAnBzGAQgASgDUgJwcw==');
