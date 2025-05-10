//
//  Generated code. Do not modify.
//  source: status.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Code extends $pb.ProtobufEnum {
  static const Code OK = Code._(0, _omitEnumNames ? '' : 'OK');
  static const Code CANCELLED = Code._(1, _omitEnumNames ? '' : 'CANCELLED');
  static const Code UNKNOWN = Code._(2, _omitEnumNames ? '' : 'UNKNOWN');
  static const Code INVALID_ARGUMENT = Code._(3, _omitEnumNames ? '' : 'INVALID_ARGUMENT');
  static const Code DEADLINE_EXCEEDED = Code._(4, _omitEnumNames ? '' : 'DEADLINE_EXCEEDED');
  static const Code NOT_FOUND = Code._(5, _omitEnumNames ? '' : 'NOT_FOUND');
  static const Code ALREADY_EXISTS = Code._(6, _omitEnumNames ? '' : 'ALREADY_EXISTS');
  static const Code PERMISSION_DENIED = Code._(7, _omitEnumNames ? '' : 'PERMISSION_DENIED');
  static const Code UNAUTHENTICATED = Code._(16, _omitEnumNames ? '' : 'UNAUTHENTICATED');
  static const Code RESOURCE_EXHAUSTED = Code._(8, _omitEnumNames ? '' : 'RESOURCE_EXHAUSTED');
  static const Code FAILED_PRECONDITION = Code._(9, _omitEnumNames ? '' : 'FAILED_PRECONDITION');
  static const Code ABORTED = Code._(10, _omitEnumNames ? '' : 'ABORTED');
  static const Code OUT_OF_RANGE = Code._(11, _omitEnumNames ? '' : 'OUT_OF_RANGE');
  static const Code UNIMPLEMENTED = Code._(12, _omitEnumNames ? '' : 'UNIMPLEMENTED');
  static const Code INTERNAL = Code._(13, _omitEnumNames ? '' : 'INTERNAL');
  static const Code UNAVAILABLE = Code._(14, _omitEnumNames ? '' : 'UNAVAILABLE');
  static const Code DATA_LOSS = Code._(15, _omitEnumNames ? '' : 'DATA_LOSS');

  static const $core.List<Code> values = <Code> [
    OK,
    CANCELLED,
    UNKNOWN,
    INVALID_ARGUMENT,
    DEADLINE_EXCEEDED,
    NOT_FOUND,
    ALREADY_EXISTS,
    PERMISSION_DENIED,
    UNAUTHENTICATED,
    RESOURCE_EXHAUSTED,
    FAILED_PRECONDITION,
    ABORTED,
    OUT_OF_RANGE,
    UNIMPLEMENTED,
    INTERNAL,
    UNAVAILABLE,
    DATA_LOSS,
  ];

  static final $core.Map<$core.int, Code> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Code? valueOf($core.int value) => _byValue[value];

  const Code._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
