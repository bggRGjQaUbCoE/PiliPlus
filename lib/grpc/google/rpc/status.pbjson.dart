//
//  Generated code. Do not modify.
//  source: status.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use codeDescriptor instead')
const Code$json = {
  '1': 'Code',
  '2': [
    {'1': 'OK', '2': 0},
    {'1': 'CANCELLED', '2': 1},
    {'1': 'UNKNOWN', '2': 2},
    {'1': 'INVALID_ARGUMENT', '2': 3},
    {'1': 'DEADLINE_EXCEEDED', '2': 4},
    {'1': 'NOT_FOUND', '2': 5},
    {'1': 'ALREADY_EXISTS', '2': 6},
    {'1': 'PERMISSION_DENIED', '2': 7},
    {'1': 'UNAUTHENTICATED', '2': 16},
    {'1': 'RESOURCE_EXHAUSTED', '2': 8},
    {'1': 'FAILED_PRECONDITION', '2': 9},
    {'1': 'ABORTED', '2': 10},
    {'1': 'OUT_OF_RANGE', '2': 11},
    {'1': 'UNIMPLEMENTED', '2': 12},
    {'1': 'INTERNAL', '2': 13},
    {'1': 'UNAVAILABLE', '2': 14},
    {'1': 'DATA_LOSS', '2': 15},
  ],
};

/// Descriptor for `Code`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List codeDescriptor = $convert.base64Decode(
    'CgRDb2RlEgYKAk9LEAASDQoJQ0FOQ0VMTEVEEAESCwoHVU5LTk9XThACEhQKEElOVkFMSURfQV'
    'JHVU1FTlQQAxIVChFERUFETElORV9FWENFRURFRBAEEg0KCU5PVF9GT1VORBAFEhIKDkFMUkVB'
    'RFlfRVhJU1RTEAYSFQoRUEVSTUlTU0lPTl9ERU5JRUQQBxITCg9VTkFVVEhFTlRJQ0FURUQQEB'
    'IWChJSRVNPVVJDRV9FWEhBVVNURUQQCBIXChNGQUlMRURfUFJFQ09ORElUSU9OEAkSCwoHQUJP'
    'UlRFRBAKEhAKDE9VVF9PRl9SQU5HRRALEhEKDVVOSU1QTEVNRU5URUQQDBIMCghJTlRFUk5BTB'
    'ANEg8KC1VOQVZBSUxBQkxFEA4SDQoJREFUQV9MT1NTEA8=');

@$core.Deprecated('Use biliStatusDescriptor instead')
const BiliStatus$json = {
  '1': 'BiliStatus',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `BiliStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List biliStatusDescriptor = $convert.base64Decode(
    'CgpCaWxpU3RhdHVzEhIKBGNvZGUYASABKAVSBGNvZGUSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2'
    'FnZQ==');

@$core.Deprecated('Use grpcDetailDescriptor instead')
const GrpcDetail$json = {
  '1': 'GrpcDetail',
  '2': [
    {'1': 'grpc_type', '3': 1, '4': 1, '5': 9, '10': 'grpcType'},
    {'1': 'status', '3': 2, '4': 1, '5': 11, '6': '.google.rpc.BiliStatus', '10': 'status'},
  ],
};

/// Descriptor for `GrpcDetail`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List grpcDetailDescriptor = $convert.base64Decode(
    'CgpHcnBjRGV0YWlsEhsKCWdycGNfdHlwZRgBIAEoCVIIZ3JwY1R5cGUSLgoGc3RhdHVzGAIgAS'
    'gLMhYuZ29vZ2xlLnJwYy5CaWxpU3RhdHVzUgZzdGF0dXM=');

@$core.Deprecated('Use statusDescriptor instead')
const Status$json = {
  '1': 'Status',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 14, '6': '.google.rpc.Code', '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'details', '3': 3, '4': 3, '5': 11, '6': '.google.rpc.GrpcDetail', '10': 'details'},
  ],
};

/// Descriptor for `Status`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statusDescriptor = $convert.base64Decode(
    'CgZTdGF0dXMSJAoEY29kZRgBIAEoDjIQLmdvb2dsZS5ycGMuQ29kZVIEY29kZRIYCgdtZXNzYW'
    'dlGAIgASgJUgdtZXNzYWdlEjAKB2RldGFpbHMYAyADKAsyFi5nb29nbGUucnBjLkdycGNEZXRh'
    'aWxSB2RldGFpbHM=');

