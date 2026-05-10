// This is a generated file - do not edit.
//
// Generated from bilibili/community/service/dm/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class DmColorfulType extends $pb.ProtobufEnum {
  static const DmColorfulType NoneType =
      DmColorfulType._(0, _omitEnumNames ? '' : 'NoneType');
  static const DmColorfulType VipGradualColor =
      DmColorfulType._(60001, _omitEnumNames ? '' : 'VipGradualColor');

  static const $core.List<DmColorfulType> values = <DmColorfulType>[
    NoneType,
    VipGradualColor,
  ];

  static final $core.Map<$core.int, DmColorfulType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static DmColorfulType? valueOf($core.int value) => _byValue[value];

  const DmColorfulType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
