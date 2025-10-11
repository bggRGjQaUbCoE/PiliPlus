// This is a generated file - do not edit.
//
// Generated from bilibili/app/playurl/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Business extends $pb.ProtobufEnum {
  static const Business UNKNOWN =
      Business._(0, _omitEnumNames ? '' : 'UNKNOWN');
  static const Business STORY = Business._(1, _omitEnumNames ? '' : 'STORY');

  static const $core.List<Business> values = <Business>[
    UNKNOWN,
    STORY,
  ];

  static final $core.List<Business?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static Business? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Business._(super.value, super.name);
}

class ButtonAction extends $pb.ProtobufEnum {
  static const ButtonAction BUTTON_UNKNOWN =
      ButtonAction._(0, _omitEnumNames ? '' : 'BUTTON_UNKNOWN');
  static const ButtonAction CHARGINGPLUS =
      ButtonAction._(1, _omitEnumNames ? '' : 'CHARGINGPLUS');

  static const $core.List<ButtonAction> values = <ButtonAction>[
    BUTTON_UNKNOWN,
    CHARGINGPLUS,
  ];

  static final $core.List<ButtonAction?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static ButtonAction? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ButtonAction._(super.value, super.name);
}

class CodeType extends $pb.ProtobufEnum {
  static const CodeType NOCODE = CodeType._(0, _omitEnumNames ? '' : 'NOCODE');
  static const CodeType CODE264 =
      CodeType._(1, _omitEnumNames ? '' : 'CODE264');
  static const CodeType CODE265 =
      CodeType._(2, _omitEnumNames ? '' : 'CODE265');
  static const CodeType CODEAV1 =
      CodeType._(3, _omitEnumNames ? '' : 'CODEAV1');

  static const $core.List<CodeType> values = <CodeType>[
    NOCODE,
    CODE264,
    CODE265,
    CODEAV1,
  ];

  static final $core.List<CodeType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static CodeType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CodeType._(super.value, super.name);
}

class ConfType extends $pb.ProtobufEnum {
  static const ConfType NoType = ConfType._(0, _omitEnumNames ? '' : 'NoType');
  static const ConfType FLIPCONF =
      ConfType._(1, _omitEnumNames ? '' : 'FLIPCONF');
  static const ConfType CASTCONF =
      ConfType._(2, _omitEnumNames ? '' : 'CASTCONF');
  static const ConfType FEEDBACK =
      ConfType._(3, _omitEnumNames ? '' : 'FEEDBACK');
  static const ConfType SUBTITLE =
      ConfType._(4, _omitEnumNames ? '' : 'SUBTITLE');
  static const ConfType PLAYBACKRATE =
      ConfType._(5, _omitEnumNames ? '' : 'PLAYBACKRATE');
  static const ConfType TIMEUP = ConfType._(6, _omitEnumNames ? '' : 'TIMEUP');
  static const ConfType PLAYBACKMODE =
      ConfType._(7, _omitEnumNames ? '' : 'PLAYBACKMODE');
  static const ConfType SCALEMODE =
      ConfType._(8, _omitEnumNames ? '' : 'SCALEMODE');
  static const ConfType BACKGROUNDPLAY =
      ConfType._(9, _omitEnumNames ? '' : 'BACKGROUNDPLAY');
  static const ConfType LIKE = ConfType._(10, _omitEnumNames ? '' : 'LIKE');
  static const ConfType DISLIKE =
      ConfType._(11, _omitEnumNames ? '' : 'DISLIKE');
  static const ConfType COIN = ConfType._(12, _omitEnumNames ? '' : 'COIN');
  static const ConfType ELEC = ConfType._(13, _omitEnumNames ? '' : 'ELEC');
  static const ConfType SHARE = ConfType._(14, _omitEnumNames ? '' : 'SHARE');
  static const ConfType SCREENSHOT =
      ConfType._(15, _omitEnumNames ? '' : 'SCREENSHOT');
  static const ConfType LOCKSCREEN =
      ConfType._(16, _omitEnumNames ? '' : 'LOCKSCREEN');
  static const ConfType RECOMMEND =
      ConfType._(17, _omitEnumNames ? '' : 'RECOMMEND');
  static const ConfType PLAYBACKSPEED =
      ConfType._(18, _omitEnumNames ? '' : 'PLAYBACKSPEED');
  static const ConfType DEFINITION =
      ConfType._(19, _omitEnumNames ? '' : 'DEFINITION');
  static const ConfType SELECTIONS =
      ConfType._(20, _omitEnumNames ? '' : 'SELECTIONS');
  static const ConfType NEXT = ConfType._(21, _omitEnumNames ? '' : 'NEXT');
  static const ConfType EDITDM = ConfType._(22, _omitEnumNames ? '' : 'EDITDM');
  static const ConfType SMALLWINDOW =
      ConfType._(23, _omitEnumNames ? '' : 'SMALLWINDOW');
  static const ConfType SHAKE = ConfType._(24, _omitEnumNames ? '' : 'SHAKE');
  static const ConfType OUTERDM =
      ConfType._(25, _omitEnumNames ? '' : 'OUTERDM');
  static const ConfType INNERDM =
      ConfType._(26, _omitEnumNames ? '' : 'INNERDM');
  static const ConfType PANORAMA =
      ConfType._(27, _omitEnumNames ? '' : 'PANORAMA');
  static const ConfType DOLBY = ConfType._(28, _omitEnumNames ? '' : 'DOLBY');
  static const ConfType COLORFILTER =
      ConfType._(29, _omitEnumNames ? '' : 'COLORFILTER');
  static const ConfType LOSSLESS =
      ConfType._(30, _omitEnumNames ? '' : 'LOSSLESS');

  static const $core.List<ConfType> values = <ConfType>[
    NoType,
    FLIPCONF,
    CASTCONF,
    FEEDBACK,
    SUBTITLE,
    PLAYBACKRATE,
    TIMEUP,
    PLAYBACKMODE,
    SCALEMODE,
    BACKGROUNDPLAY,
    LIKE,
    DISLIKE,
    COIN,
    ELEC,
    SHARE,
    SCREENSHOT,
    LOCKSCREEN,
    RECOMMEND,
    PLAYBACKSPEED,
    DEFINITION,
    SELECTIONS,
    NEXT,
    EDITDM,
    SMALLWINDOW,
    SHAKE,
    OUTERDM,
    INNERDM,
    PANORAMA,
    DOLBY,
    COLORFILTER,
    LOSSLESS,
  ];

  static final $core.List<ConfType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 30);
  static ConfType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ConfType._(super.value, super.name);
}

class Group extends $pb.ProtobufEnum {
  static const Group UnknownGroup =
      Group._(0, _omitEnumNames ? '' : 'UnknownGroup');
  static const Group A = Group._(1, _omitEnumNames ? '' : 'A');
  static const Group B = Group._(2, _omitEnumNames ? '' : 'B');
  static const Group C = Group._(3, _omitEnumNames ? '' : 'C');

  static const $core.List<Group> values = <Group>[
    UnknownGroup,
    A,
    B,
    C,
  ];

  static final $core.List<Group?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Group? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Group._(super.value, super.name);
}

class GuideStyle extends $pb.ProtobufEnum {
  static const GuideStyle STYLE_UNKNOWN =
      GuideStyle._(0, _omitEnumNames ? '' : 'STYLE_UNKNOWN');
  static const GuideStyle CHARGING_TEXT =
      GuideStyle._(1, _omitEnumNames ? '' : 'CHARGING_TEXT');

  static const $core.List<GuideStyle> values = <GuideStyle>[
    STYLE_UNKNOWN,
    CHARGING_TEXT,
  ];

  static final $core.List<GuideStyle?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static GuideStyle? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const GuideStyle._(super.value, super.name);
}

class PlayErr extends $pb.ProtobufEnum {
  static const PlayErr NoErr = PlayErr._(0, _omitEnumNames ? '' : 'NoErr');
  static const PlayErr WithMultiDeviceLoginErr =
      PlayErr._(1, _omitEnumNames ? '' : 'WithMultiDeviceLoginErr');

  static const $core.List<PlayErr> values = <PlayErr>[
    NoErr,
    WithMultiDeviceLoginErr,
  ];

  static final $core.List<PlayErr?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static PlayErr? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlayErr._(super.value, super.name);
}

class PlayLimitCode extends $pb.ProtobufEnum {
  static const PlayLimitCode PLCUnkown =
      PlayLimitCode._(0, _omitEnumNames ? '' : 'PLCUnkown');
  static const PlayLimitCode PLCUgcNotPayed =
      PlayLimitCode._(1, _omitEnumNames ? '' : 'PLCUgcNotPayed');
  static const PlayLimitCode PLCChargingPlusNotPass =
      PlayLimitCode._(2, _omitEnumNames ? '' : 'PLCChargingPlusNotPass');
  static const PlayLimitCode PLCChargingPlusUpgrade =
      PlayLimitCode._(3, _omitEnumNames ? '' : 'PLCChargingPlusUpgrade');

  static const $core.List<PlayLimitCode> values = <PlayLimitCode>[
    PLCUnkown,
    PLCUgcNotPayed,
    PLCChargingPlusNotPass,
    PLCChargingPlusUpgrade,
  ];

  static final $core.List<PlayLimitCode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static PlayLimitCode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlayLimitCode._(super.value, super.name);
}

class ToastType extends $pb.ProtobufEnum {
  static const ToastType TOAST_TYPE_UNKNOWN =
      ToastType._(0, _omitEnumNames ? '' : 'TOAST_TYPE_UNKNOWN');
  static const ToastType CHARGING_TOAST =
      ToastType._(1, _omitEnumNames ? '' : 'CHARGING_TOAST');

  static const $core.List<ToastType> values = <ToastType>[
    TOAST_TYPE_UNKNOWN,
    CHARGING_TOAST,
  ];

  static final $core.List<ToastType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static ToastType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ToastType._(super.value, super.name);
}

class VideoType extends $pb.ProtobufEnum {
  static const VideoType Unknown =
      VideoType._(0, _omitEnumNames ? '' : 'Unknown');
  static const VideoType FLV = VideoType._(1, _omitEnumNames ? '' : 'FLV');
  static const VideoType DASH = VideoType._(2, _omitEnumNames ? '' : 'DASH');
  static const VideoType MP4 = VideoType._(3, _omitEnumNames ? '' : 'MP4');

  static const $core.List<VideoType> values = <VideoType>[
    Unknown,
    FLV,
    DASH,
    MP4,
  ];

  static final $core.List<VideoType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static VideoType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const VideoType._(super.value, super.name);
}

class DolbyItem_Type extends $pb.ProtobufEnum {
  static const DolbyItem_Type NONE =
      DolbyItem_Type._(0, _omitEnumNames ? '' : 'NONE');
  static const DolbyItem_Type COMMON =
      DolbyItem_Type._(1, _omitEnumNames ? '' : 'COMMON');
  static const DolbyItem_Type ATMOS =
      DolbyItem_Type._(2, _omitEnumNames ? '' : 'ATMOS');

  static const $core.List<DolbyItem_Type> values = <DolbyItem_Type>[
    NONE,
    COMMON,
    ATMOS,
  ];

  static final $core.List<DolbyItem_Type?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static DolbyItem_Type? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DolbyItem_Type._(super.value, super.name);
}

class Scheme_ActionType extends $pb.ProtobufEnum {
  static const Scheme_ActionType UNKNOWN_ActionType =
      Scheme_ActionType._(0, _omitEnumNames ? '' : 'UNKNOWN_ActionType');
  static const Scheme_ActionType SHOW_TOAST =
      Scheme_ActionType._(1, _omitEnumNames ? '' : 'SHOW_TOAST');

  static const $core.List<Scheme_ActionType> values = <Scheme_ActionType>[
    UNKNOWN_ActionType,
    SHOW_TOAST,
  ];

  static final $core.List<Scheme_ActionType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static Scheme_ActionType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Scheme_ActionType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
