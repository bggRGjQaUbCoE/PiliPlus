// This is a generated file - do not edit.
//
// Generated from bilibili/app/archive/v1.proto.

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
    {'1': 'aid', '3': 1, '4': 1, '5': 3, '10': 'aid'},
    {'1': 'videos', '3': 2, '4': 1, '5': 3, '10': 'videos'},
    {'1': 'pic', '3': 6, '4': 1, '5': 9, '10': 'pic'},
    {'1': 'title', '3': 7, '4': 1, '5': 9, '10': 'title'},
    {'1': 'pubdate', '3': 8, '4': 1, '5': 3, '10': 'pubdate'},
    {'1': 'ctime', '3': 9, '4': 1, '5': 3, '10': 'ctime'},
    {'1': 'duration', '3': 16, '4': 1, '5': 3, '10': 'duration'},
    {'1': 'redirect_url', '3': 19, '4': 1, '5': 9, '10': 'redirectUrl'},
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
    {'1': 'first_cid', '3': 26, '4': 1, '5': 3, '10': 'firstCid'},
    {
      '1': 'dimension',
      '3': 27,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.archive.v1.Dimension',
      '10': 'dimension'
    },
    {'1': 'season_id', '3': 29, '4': 1, '5': 3, '10': 'seasonId'},
  ],
};

/// Descriptor for `Arc`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List arcDescriptor = $convert.base64Decode(
    'CgNBcmMSEAoDYWlkGAEgASgDUgNhaWQSFgoGdmlkZW9zGAIgASgDUgZ2aWRlb3MSEAoDcGljGA'
    'YgASgJUgNwaWMSFAoFdGl0bGUYByABKAlSBXRpdGxlEhgKB3B1YmRhdGUYCCABKANSB3B1YmRh'
    'dGUSFAoFY3RpbWUYCSABKANSBWN0aW1lEhoKCGR1cmF0aW9uGBAgASgDUghkdXJhdGlvbhIhCg'
    'xyZWRpcmVjdF91cmwYEyABKAlSC3JlZGlyZWN0VXJsEjcKBmF1dGhvchgWIAEoCzIfLmJpbGli'
    'aWxpLmFwcC5hcmNoaXZlLnYxLkF1dGhvclIGYXV0aG9yEjEKBHN0YXQYFyABKAsyHS5iaWxpYm'
    'lsaS5hcHAuYXJjaGl2ZS52MS5TdGF0UgRzdGF0EhsKCWZpcnN0X2NpZBgaIAEoA1IIZmlyc3RD'
    'aWQSQAoJZGltZW5zaW9uGBsgASgLMiIuYmlsaWJpbGkuYXBwLmFyY2hpdmUudjEuRGltZW5zaW'
    '9uUglkaW1lbnNpb24SGwoJc2Vhc29uX2lkGB0gASgDUghzZWFzb25JZA==');

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

@$core.Deprecated('Use statDescriptor instead')
const Stat$json = {
  '1': 'Stat',
  '2': [
    {'1': 'view', '3': 2, '4': 1, '5': 5, '10': 'view'},
    {'1': 'danmaku', '3': 3, '4': 1, '5': 5, '10': 'danmaku'},
  ],
};

/// Descriptor for `Stat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statDescriptor = $convert.base64Decode(
    'CgRTdGF0EhIKBHZpZXcYAiABKAVSBHZpZXcSGAoHZGFubWFrdRgDIAEoBVIHZGFubWFrdQ==');
