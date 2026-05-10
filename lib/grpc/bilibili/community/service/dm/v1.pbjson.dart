// This is a generated file - do not edit.
//
// Generated from bilibili/community/service/dm/v1.proto.

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

@$core.Deprecated('Use dmColorfulTypeDescriptor instead')
const DmColorfulType$json = {
  '1': 'DmColorfulType',
  '2': [
    {'1': 'NoneType', '2': 0},
    {'1': 'VipGradualColor', '2': 60001},
  ],
};

/// Descriptor for `DmColorfulType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List dmColorfulTypeDescriptor = $convert.base64Decode(
    'Cg5EbUNvbG9yZnVsVHlwZRIMCghOb25lVHlwZRAAEhUKD1ZpcEdyYWR1YWxDb2xvchDh1AM=');

@$core.Deprecated('Use danmakuElemDescriptor instead')
const DanmakuElem$json = {
  '1': 'DanmakuElem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'progress', '3': 2, '4': 1, '5': 5, '10': 'progress'},
    {'1': 'mode', '3': 3, '4': 1, '5': 5, '10': 'mode'},
    {'1': 'fontsize', '3': 4, '4': 1, '5': 5, '10': 'fontsize'},
    {'1': 'color', '3': 5, '4': 1, '5': 13, '10': 'color'},
    {'1': 'mid_hash', '3': 6, '4': 1, '5': 9, '10': 'midHash'},
    {'1': 'content', '3': 7, '4': 1, '5': 9, '10': 'content'},
    {'1': 'weight', '3': 9, '4': 1, '5': 5, '10': 'weight'},
    {'1': 'action', '3': 10, '4': 1, '5': 9, '10': 'action'},
    {'1': 'like_count', '3': 15, '4': 1, '5': 3, '10': 'likeCount'},
    {
      '1': 'colorful',
      '3': 24,
      '4': 1,
      '5': 14,
      '6': '.bilibili.community.service.dm.v1.DmColorfulType',
      '10': 'colorful'
    },
    {'1': 'count', '3': 100, '4': 1, '5': 5, '10': 'count'},
    {'1': 'is_self', '3': 101, '4': 1, '5': 8, '10': 'isSelf'},
  ],
};

/// Descriptor for `DanmakuElem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List danmakuElemDescriptor = $convert.base64Decode(
    'CgtEYW5tYWt1RWxlbRIOCgJpZBgBIAEoA1ICaWQSGgoIcHJvZ3Jlc3MYAiABKAVSCHByb2dyZX'
    'NzEhIKBG1vZGUYAyABKAVSBG1vZGUSGgoIZm9udHNpemUYBCABKAVSCGZvbnRzaXplEhQKBWNv'
    'bG9yGAUgASgNUgVjb2xvchIZCghtaWRfaGFzaBgGIAEoCVIHbWlkSGFzaBIYCgdjb250ZW50GA'
    'cgASgJUgdjb250ZW50EhYKBndlaWdodBgJIAEoBVIGd2VpZ2h0EhYKBmFjdGlvbhgKIAEoCVIG'
    'YWN0aW9uEh0KCmxpa2VfY291bnQYDyABKANSCWxpa2VDb3VudBJMCghjb2xvcmZ1bBgYIAEoDj'
    'IwLmJpbGliaWxpLmNvbW11bml0eS5zZXJ2aWNlLmRtLnYxLkRtQ29sb3JmdWxUeXBlUghjb2xv'
    'cmZ1bBIUCgVjb3VudBhkIAEoBVIFY291bnQSFwoHaXNfc2VsZhhlIAEoCFIGaXNTZWxm');

@$core.Deprecated('Use dmSegMobileReplyDescriptor instead')
const DmSegMobileReply$json = {
  '1': 'DmSegMobileReply',
  '2': [
    {
      '1': 'elems',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.community.service.dm.v1.DanmakuElem',
      '10': 'elems'
    },
    {'1': 'state', '3': 2, '4': 1, '5': 5, '10': 'state'},
  ],
};

/// Descriptor for `DmSegMobileReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dmSegMobileReplyDescriptor = $convert.base64Decode(
    'ChBEbVNlZ01vYmlsZVJlcGx5EkMKBWVsZW1zGAEgAygLMi0uYmlsaWJpbGkuY29tbXVuaXR5Ln'
    'NlcnZpY2UuZG0udjEuRGFubWFrdUVsZW1SBWVsZW1zEhQKBXN0YXRlGAIgASgFUgVzdGF0ZQ==');

@$core.Deprecated('Use dmSegMobileReqDescriptor instead')
const DmSegMobileReq$json = {
  '1': 'DmSegMobileReq',
  '2': [
    {'1': 'oid', '3': 2, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'type', '3': 3, '4': 1, '5': 5, '10': 'type'},
    {'1': 'segment_index', '3': 4, '4': 1, '5': 3, '10': 'segmentIndex'},
  ],
};

/// Descriptor for `DmSegMobileReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dmSegMobileReqDescriptor = $convert.base64Decode(
    'Cg5EbVNlZ01vYmlsZVJlcRIQCgNvaWQYAiABKANSA29pZBISCgR0eXBlGAMgASgFUgR0eXBlEi'
    'MKDXNlZ21lbnRfaW5kZXgYBCABKANSDHNlZ21lbnRJbmRleA==');
