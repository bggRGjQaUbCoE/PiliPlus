// This is a generated file - do not edit.
//
// Generated from bilibili/app/interfaces/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ButType extends $pb.ProtobufEnum {
  static const ButType BUT_INVALID =
      ButType._(0, _omitEnumNames ? '' : 'BUT_INVALID');
  static const ButType BUT_REDIRECT =
      ButType._(1, _omitEnumNames ? '' : 'BUT_REDIRECT');
  static const ButType BUT_LIKE =
      ButType._(2, _omitEnumNames ? '' : 'BUT_LIKE');

  static const $core.List<ButType> values = <ButType>[
    BUT_INVALID,
    BUT_REDIRECT,
    BUT_LIKE,
  ];

  static final $core.List<ButType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ButType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ButType._(super.value, super.name);
}

class CommentType extends $pb.ProtobufEnum {
  static const CommentType comment_type_none =
      CommentType._(0, _omitEnumNames ? '' : 'comment_type_none');
  static const CommentType comment_type_redirect =
      CommentType._(1, _omitEnumNames ? '' : 'comment_type_redirect');
  static const CommentType comment_type_judge =
      CommentType._(2, _omitEnumNames ? '' : 'comment_type_judge');

  static const $core.List<CommentType> values = <CommentType>[
    comment_type_none,
    comment_type_redirect,
    comment_type_judge,
  ];

  static final $core.List<CommentType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static CommentType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CommentType._(super.value, super.name);
}

/// 设备类型
class DT extends $pb.ProtobufEnum {
  static const DT Unknown = DT._(0, _omitEnumNames ? '' : 'Unknown');
  static const DT Phone = DT._(1, _omitEnumNames ? '' : 'Phone');
  static const DT Pad = DT._(2, _omitEnumNames ? '' : 'Pad');
  static const DT PC = DT._(3, _omitEnumNames ? '' : 'PC');
  static const DT TV = DT._(4, _omitEnumNames ? '' : 'TV');
  static const DT Car = DT._(5, _omitEnumNames ? '' : 'Car');
  static const DT Iot = DT._(6, _omitEnumNames ? '' : 'Iot');
  static const DT AndPad = DT._(7, _omitEnumNames ? '' : 'AndPad');

  static const $core.List<DT> values = <DT>[
    Unknown,
    Phone,
    Pad,
    PC,
    TV,
    Car,
    Iot,
    AndPad,
  ];

  static final $core.List<DT?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static DT? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DT._(super.value, super.name);
}

class FacialRecognitionVerifyFrom extends $pb.ProtobufEnum {
  static const FacialRecognitionVerifyFrom VerifyUnknownFrom =
      FacialRecognitionVerifyFrom._(
          0, _omitEnumNames ? '' : 'VerifyUnknownFrom');
  static const FacialRecognitionVerifyFrom VerifyFromGuardian =
      FacialRecognitionVerifyFrom._(
          1, _omitEnumNames ? '' : 'VerifyFromGuardian');
  static const FacialRecognitionVerifyFrom VerifyFromAppeal =
      FacialRecognitionVerifyFrom._(
          2, _omitEnumNames ? '' : 'VerifyFromAppeal');

  static const $core.List<FacialRecognitionVerifyFrom> values =
      <FacialRecognitionVerifyFrom>[
    VerifyUnknownFrom,
    VerifyFromGuardian,
    VerifyFromAppeal,
  ];

  static final $core.List<FacialRecognitionVerifyFrom?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static FacialRecognitionVerifyFrom? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FacialRecognitionVerifyFrom._(super.value, super.name);
}

class From extends $pb.ProtobufEnum {
  static const From ArchiveTab = From._(0, _omitEnumNames ? '' : 'ArchiveTab');
  static const From DynamicTab = From._(1, _omitEnumNames ? '' : 'DynamicTab');

  static const $core.List<From> values = <From>[
    ArchiveTab,
    DynamicTab,
  ];

  static final $core.List<From?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static From? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const From._(super.value, super.name);
}

class HistorySource extends $pb.ProtobufEnum {
  static const HistorySource history =
      HistorySource._(0, _omitEnumNames ? '' : 'history');
  static const HistorySource shopping =
      HistorySource._(1, _omitEnumNames ? '' : 'shopping');

  static const $core.List<HistorySource> values = <HistorySource>[
    history,
    shopping,
  ];

  static final $core.List<HistorySource?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static HistorySource? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const HistorySource._(super.value, super.name);
}

class ModelStatus extends $pb.ProtobufEnum {
  static const ModelStatus CloseStatus =
      ModelStatus._(0, _omitEnumNames ? '' : 'CloseStatus');
  static const ModelStatus OpenStatus =
      ModelStatus._(1, _omitEnumNames ? '' : 'OpenStatus');
  static const ModelStatus NotSetStatus =
      ModelStatus._(2, _omitEnumNames ? '' : 'NotSetStatus');

  static const $core.List<ModelStatus> values = <ModelStatus>[
    CloseStatus,
    OpenStatus,
    NotSetStatus,
  ];

  static final $core.List<ModelStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ModelStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ModelStatus._(super.value, super.name);
}

class PwdFrom extends $pb.ProtobufEnum {
  static const PwdFrom UnknownFrom =
      PwdFrom._(0, _omitEnumNames ? '' : 'UnknownFrom');
  static const PwdFrom TeenagersAntiAddictionFrom =
      PwdFrom._(1, _omitEnumNames ? '' : 'TeenagersAntiAddictionFrom');
  static const PwdFrom TeenagersCurfewFrom =
      PwdFrom._(2, _omitEnumNames ? '' : 'TeenagersCurfewFrom');
  static const PwdFrom TeenagersLoginFrom =
      PwdFrom._(3, _omitEnumNames ? '' : 'TeenagersLoginFrom');
  static const PwdFrom TeenagersLogOutFrom =
      PwdFrom._(4, _omitEnumNames ? '' : 'TeenagersLogOutFrom');
  static const PwdFrom FamilyAntiAddictionFrom =
      PwdFrom._(5, _omitEnumNames ? '' : 'FamilyAntiAddictionFrom');
  static const PwdFrom FamilyCurfewFrom =
      PwdFrom._(6, _omitEnumNames ? '' : 'FamilyCurfewFrom');
  static const PwdFrom FamilyLogOutFrom =
      PwdFrom._(7, _omitEnumNames ? '' : 'FamilyLogOutFrom');
  static const PwdFrom FamilyTimeLockFrom =
      PwdFrom._(8, _omitEnumNames ? '' : 'FamilyTimeLockFrom');
  static const PwdFrom TeenagersQuitPwdFrom =
      PwdFrom._(9, _omitEnumNames ? '' : 'TeenagersQuitPwdFrom');
  static const PwdFrom TeenagersModifyPwdFrom =
      PwdFrom._(10, _omitEnumNames ? '' : 'TeenagersModifyPwdFrom');
  static const PwdFrom FamilyQuitFrom =
      PwdFrom._(11, _omitEnumNames ? '' : 'FamilyQuitFrom');
  static const PwdFrom OSTeenagersLogin =
      PwdFrom._(12, _omitEnumNames ? '' : 'OSTeenagersLogin');
  static const PwdFrom OSTeenagersLogout =
      PwdFrom._(13, _omitEnumNames ? '' : 'OSTeenagersLogout');
  static const PwdFrom TeenagersSetAge =
      PwdFrom._(14, _omitEnumNames ? '' : 'TeenagersSetAge');
  static const PwdFrom OSTeenagersSetAge =
      PwdFrom._(15, _omitEnumNames ? '' : 'OSTeenagersSetAge');

  static const $core.List<PwdFrom> values = <PwdFrom>[
    UnknownFrom,
    TeenagersAntiAddictionFrom,
    TeenagersCurfewFrom,
    TeenagersLoginFrom,
    TeenagersLogOutFrom,
    FamilyAntiAddictionFrom,
    FamilyCurfewFrom,
    FamilyLogOutFrom,
    FamilyTimeLockFrom,
    TeenagersQuitPwdFrom,
    TeenagersModifyPwdFrom,
    FamilyQuitFrom,
    OSTeenagersLogin,
    OSTeenagersLogout,
    TeenagersSetAge,
    OSTeenagersSetAge,
  ];

  static final $core.List<PwdFrom?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 15);
  static PwdFrom? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PwdFrom._(super.value, super.name);
}

class TabType extends $pb.ProtobufEnum {
  static const TabType TAB_INVALID =
      TabType._(0, _omitEnumNames ? '' : 'TAB_INVALID');
  static const TabType TAB_OGV_DETAIL =
      TabType._(6, _omitEnumNames ? '' : 'TAB_OGV_DETAIL');
  static const TabType TAB_OGV_REPLY =
      TabType._(7, _omitEnumNames ? '' : 'TAB_OGV_REPLY');
  static const TabType TAB_FEED_BID =
      TabType._(8, _omitEnumNames ? '' : 'TAB_FEED_BID');
  static const TabType TAB_FEED_SMALL =
      TabType._(9, _omitEnumNames ? '' : 'TAB_FEED_SMALL');

  static const $core.List<TabType> values = <TabType>[
    TAB_INVALID,
    TAB_OGV_DETAIL,
    TAB_OGV_REPLY,
    TAB_FEED_BID,
    TAB_FEED_SMALL,
  ];

  static final $core.Map<$core.int, TabType> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static TabType? valueOf($core.int value) => _byValue[value];

  const TabType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
