// This is a generated file - do not edit.
//
// Generated from bilibili/app/dynamic/v1.proto.

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

@$core.Deprecated('Use dynRedReplyDescriptor instead')
const DynRedReply$json = {
  '1': 'DynRedReply',
  '2': [
    {
      '1': 'dyn_red_item',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.dynamic.v1.DynRedItem',
      '10': 'dynRedItem'
    },
  ],
};

/// Descriptor for `DynRedReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dynRedReplyDescriptor = $convert.base64Decode(
    'CgtEeW5SZWRSZXBseRJFCgxkeW5fcmVkX2l0ZW0YAiABKAsyIy5iaWxpYmlsaS5hcHAuZHluYW'
    '1pYy52MS5EeW5SZWRJdGVtUgpkeW5SZWRJdGVt');

@$core.Deprecated('Use dynRedReqDescriptor instead')
const DynRedReq$json = {
  '1': 'DynRedReq',
  '2': [
    {
      '1': 'tab_offset',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.dynamic.v1.TabOffset',
      '10': 'tabOffset'
    },
  ],
};

/// Descriptor for `DynRedReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dynRedReqDescriptor = $convert.base64Decode(
    'CglEeW5SZWRSZXESQQoKdGFiX29mZnNldBgBIAMoCzIiLmJpbGliaWxpLmFwcC5keW5hbWljLn'
    'YxLlRhYk9mZnNldFIJdGFiT2Zmc2V0');

@$core.Deprecated('Use dynRedItemDescriptor instead')
const DynRedItem$json = {
  '1': 'DynRedItem',
  '2': [
    {'1': 'count', '3': 1, '4': 1, '5': 3, '10': 'count'},
  ],
};

/// Descriptor for `DynRedItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dynRedItemDescriptor =
    $convert.base64Decode('CgpEeW5SZWRJdGVtEhQKBWNvdW50GAEgASgDUgVjb3VudA==');

@$core.Deprecated('Use tabOffsetDescriptor instead')
const TabOffset$json = {
  '1': 'TabOffset',
  '2': [
    {'1': 'tab', '3': 1, '4': 1, '5': 5, '10': 'tab'},
    {'1': 'offset', '3': 2, '4': 1, '5': 9, '10': 'offset'},
  ],
};

/// Descriptor for `TabOffset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tabOffsetDescriptor = $convert.base64Decode(
    'CglUYWJPZmZzZXQSEAoDdGFiGAEgASgFUgN0YWISFgoGb2Zmc2V0GAIgASgJUgZvZmZzZXQ=');
