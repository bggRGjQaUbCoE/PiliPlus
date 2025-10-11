// This is a generated file - do not edit.
//
// Generated from bilibili/app/playurl/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use businessDescriptor instead')
const Business$json = {
  '1': 'Business',
  '2': [
    {'1': 'UNKNOWN', '2': 0},
    {'1': 'STORY', '2': 1},
  ],
};

/// Descriptor for `Business`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List businessDescriptor =
    $convert.base64Decode('CghCdXNpbmVzcxILCgdVTktOT1dOEAASCQoFU1RPUlkQAQ==');

@$core.Deprecated('Use buttonActionDescriptor instead')
const ButtonAction$json = {
  '1': 'ButtonAction',
  '2': [
    {'1': 'BUTTON_UNKNOWN', '2': 0},
    {'1': 'CHARGINGPLUS', '2': 1},
  ],
};

/// Descriptor for `ButtonAction`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List buttonActionDescriptor = $convert.base64Decode(
    'CgxCdXR0b25BY3Rpb24SEgoOQlVUVE9OX1VOS05PV04QABIQCgxDSEFSR0lOR1BMVVMQAQ==');

@$core.Deprecated('Use codeTypeDescriptor instead')
const CodeType$json = {
  '1': 'CodeType',
  '2': [
    {'1': 'NOCODE', '2': 0},
    {'1': 'CODE264', '2': 1},
    {'1': 'CODE265', '2': 2},
    {'1': 'CODEAV1', '2': 3},
  ],
};

/// Descriptor for `CodeType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List codeTypeDescriptor = $convert.base64Decode(
    'CghDb2RlVHlwZRIKCgZOT0NPREUQABILCgdDT0RFMjY0EAESCwoHQ09ERTI2NRACEgsKB0NPRE'
    'VBVjEQAw==');

@$core.Deprecated('Use confTypeDescriptor instead')
const ConfType$json = {
  '1': 'ConfType',
  '2': [
    {'1': 'NoType', '2': 0},
    {'1': 'FLIPCONF', '2': 1},
    {'1': 'CASTCONF', '2': 2},
    {'1': 'FEEDBACK', '2': 3},
    {'1': 'SUBTITLE', '2': 4},
    {'1': 'PLAYBACKRATE', '2': 5},
    {'1': 'TIMEUP', '2': 6},
    {'1': 'PLAYBACKMODE', '2': 7},
    {'1': 'SCALEMODE', '2': 8},
    {'1': 'BACKGROUNDPLAY', '2': 9},
    {'1': 'LIKE', '2': 10},
    {'1': 'DISLIKE', '2': 11},
    {'1': 'COIN', '2': 12},
    {'1': 'ELEC', '2': 13},
    {'1': 'SHARE', '2': 14},
    {'1': 'SCREENSHOT', '2': 15},
    {'1': 'LOCKSCREEN', '2': 16},
    {'1': 'RECOMMEND', '2': 17},
    {'1': 'PLAYBACKSPEED', '2': 18},
    {'1': 'DEFINITION', '2': 19},
    {'1': 'SELECTIONS', '2': 20},
    {'1': 'NEXT', '2': 21},
    {'1': 'EDITDM', '2': 22},
    {'1': 'SMALLWINDOW', '2': 23},
    {'1': 'SHAKE', '2': 24},
    {'1': 'OUTERDM', '2': 25},
    {'1': 'INNERDM', '2': 26},
    {'1': 'PANORAMA', '2': 27},
    {'1': 'DOLBY', '2': 28},
    {'1': 'COLORFILTER', '2': 29},
    {'1': 'LOSSLESS', '2': 30},
  ],
};

/// Descriptor for `ConfType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List confTypeDescriptor = $convert.base64Decode(
    'CghDb25mVHlwZRIKCgZOb1R5cGUQABIMCghGTElQQ09ORhABEgwKCENBU1RDT05GEAISDAoIRk'
    'VFREJBQ0sQAxIMCghTVUJUSVRMRRAEEhAKDFBMQVlCQUNLUkFURRAFEgoKBlRJTUVVUBAGEhAK'
    'DFBMQVlCQUNLTU9ERRAHEg0KCVNDQUxFTU9ERRAIEhIKDkJBQ0tHUk9VTkRQTEFZEAkSCAoETE'
    'lLRRAKEgsKB0RJU0xJS0UQCxIICgRDT0lOEAwSCAoERUxFQxANEgkKBVNIQVJFEA4SDgoKU0NS'
    'RUVOU0hPVBAPEg4KCkxPQ0tTQ1JFRU4QEBINCglSRUNPTU1FTkQQERIRCg1QTEFZQkFDS1NQRU'
    'VEEBISDgoKREVGSU5JVElPThATEg4KClNFTEVDVElPTlMQFBIICgRORVhUEBUSCgoGRURJVERN'
    'EBYSDwoLU01BTExXSU5ET1cQFxIJCgVTSEFLRRAYEgsKB09VVEVSRE0QGRILCgdJTk5FUkRNEB'
    'oSDAoIUEFOT1JBTUEQGxIJCgVET0xCWRAcEg8KC0NPTE9SRklMVEVSEB0SDAoITE9TU0xFU1MQ'
    'Hg==');

@$core.Deprecated('Use groupDescriptor instead')
const Group$json = {
  '1': 'Group',
  '2': [
    {'1': 'UnknownGroup', '2': 0},
    {'1': 'A', '2': 1},
    {'1': 'B', '2': 2},
    {'1': 'C', '2': 3},
  ],
};

/// Descriptor for `Group`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List groupDescriptor = $convert.base64Decode(
    'CgVHcm91cBIQCgxVbmtub3duR3JvdXAQABIFCgFBEAESBQoBQhACEgUKAUMQAw==');

@$core.Deprecated('Use guideStyleDescriptor instead')
const GuideStyle$json = {
  '1': 'GuideStyle',
  '2': [
    {'1': 'STYLE_UNKNOWN', '2': 0},
    {'1': 'CHARGING_TEXT', '2': 1},
  ],
};

/// Descriptor for `GuideStyle`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List guideStyleDescriptor = $convert.base64Decode(
    'CgpHdWlkZVN0eWxlEhEKDVNUWUxFX1VOS05PV04QABIRCg1DSEFSR0lOR19URVhUEAE=');

@$core.Deprecated('Use playErrDescriptor instead')
const PlayErr$json = {
  '1': 'PlayErr',
  '2': [
    {'1': 'NoErr', '2': 0},
    {'1': 'WithMultiDeviceLoginErr', '2': 1},
  ],
};

/// Descriptor for `PlayErr`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List playErrDescriptor = $convert.base64Decode(
    'CgdQbGF5RXJyEgkKBU5vRXJyEAASGwoXV2l0aE11bHRpRGV2aWNlTG9naW5FcnIQAQ==');

@$core.Deprecated('Use playLimitCodeDescriptor instead')
const PlayLimitCode$json = {
  '1': 'PlayLimitCode',
  '2': [
    {'1': 'PLCUnkown', '2': 0},
    {'1': 'PLCUgcNotPayed', '2': 1},
    {'1': 'PLCChargingPlusNotPass', '2': 2},
    {'1': 'PLCChargingPlusUpgrade', '2': 3},
  ],
};

/// Descriptor for `PlayLimitCode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List playLimitCodeDescriptor = $convert.base64Decode(
    'Cg1QbGF5TGltaXRDb2RlEg0KCVBMQ1Vua293bhAAEhIKDlBMQ1VnY05vdFBheWVkEAESGgoWUE'
    'xDQ2hhcmdpbmdQbHVzTm90UGFzcxACEhoKFlBMQ0NoYXJnaW5nUGx1c1VwZ3JhZGUQAw==');

@$core.Deprecated('Use toastTypeDescriptor instead')
const ToastType$json = {
  '1': 'ToastType',
  '2': [
    {'1': 'TOAST_TYPE_UNKNOWN', '2': 0},
    {'1': 'CHARGING_TOAST', '2': 1},
  ],
};

/// Descriptor for `ToastType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List toastTypeDescriptor = $convert.base64Decode(
    'CglUb2FzdFR5cGUSFgoSVE9BU1RfVFlQRV9VTktOT1dOEAASEgoOQ0hBUkdJTkdfVE9BU1QQAQ'
    '==');

@$core.Deprecated('Use videoTypeDescriptor instead')
const VideoType$json = {
  '1': 'VideoType',
  '2': [
    {'1': 'Unknown', '2': 0},
    {'1': 'FLV', '2': 1},
    {'1': 'DASH', '2': 2},
    {'1': 'MP4', '2': 3},
  ],
};

/// Descriptor for `VideoType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List videoTypeDescriptor = $convert.base64Decode(
    'CglWaWRlb1R5cGUSCwoHVW5rbm93bhAAEgcKA0ZMVhABEggKBERBU0gQAhIHCgNNUDQQAw==');

@$core.Deprecated('Use aBDescriptor instead')
const AB$json = {
  '1': 'AB',
  '2': [
    {
      '1': 'glance',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.Glance',
      '10': 'glance'
    },
    {
      '1': 'group',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.playurl.v1.Group',
      '10': 'group'
    },
  ],
};

/// Descriptor for `AB`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List aBDescriptor = $convert.base64Decode(
    'CgJBQhI3CgZnbGFuY2UYASABKAsyHy5iaWxpYmlsaS5hcHAucGxheXVybC52MS5HbGFuY2VSBm'
    'dsYW5jZRI0CgVncm91cBgCIAEoDjIeLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLkdyb3VwUgVn'
    'cm91cA==');

@$core.Deprecated('Use arcConfDescriptor instead')
const ArcConf$json = {
  '1': 'ArcConf',
  '2': [
    {'1': 'is_support', '3': 1, '4': 1, '5': 8, '10': 'isSupport'},
    {'1': 'disabled', '3': 2, '4': 1, '5': 8, '10': 'disabled'},
    {
      '1': 'extra_content',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ExtraContent',
      '10': 'extraContent'
    },
    {'1': 'unsupport_scene', '3': 4, '4': 3, '5': 3, '10': 'unsupportScene'},
  ],
};

/// Descriptor for `ArcConf`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List arcConfDescriptor = $convert.base64Decode(
    'CgdBcmNDb25mEh0KCmlzX3N1cHBvcnQYASABKAhSCWlzU3VwcG9ydBIaCghkaXNhYmxlZBgCIA'
    'EoCFIIZGlzYWJsZWQSSgoNZXh0cmFfY29udGVudBgDIAEoCzIlLmJpbGliaWxpLmFwcC5wbGF5'
    'dXJsLnYxLkV4dHJhQ29udGVudFIMZXh0cmFDb250ZW50EicKD3Vuc3VwcG9ydF9zY2VuZRgEIA'
    'MoA1IOdW5zdXBwb3J0U2NlbmU=');

@$core.Deprecated('Use buttonInfoDescriptor instead')
const ButtonInfo$json = {
  '1': 'ButtonInfo',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'text_color', '3': 2, '4': 1, '5': 9, '10': 'textColor'},
    {'1': 'text_color_night', '3': 3, '4': 1, '5': 9, '10': 'textColorNight'},
    {'1': 'bg_color', '3': 4, '4': 1, '5': 9, '10': 'bgColor'},
    {'1': 'bg_color_night', '3': 5, '4': 1, '5': 9, '10': 'bgColorNight'},
    {'1': 'link', '3': 6, '4': 1, '5': 9, '10': 'link'},
    {
      '1': 'action_type',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.playurl.v1.ButtonAction',
      '10': 'actionType'
    },
    {
      '1': 'report',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.Report',
      '10': 'report'
    },
    {'1': 'frame_color', '3': 9, '4': 1, '5': 9, '10': 'frameColor'},
    {'1': 'icon', '3': 10, '4': 1, '5': 9, '10': 'icon'},
  ],
};

/// Descriptor for `ButtonInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List buttonInfoDescriptor = $convert.base64Decode(
    'CgpCdXR0b25JbmZvEhIKBHRleHQYASABKAlSBHRleHQSHQoKdGV4dF9jb2xvchgCIAEoCVIJdG'
    'V4dENvbG9yEigKEHRleHRfY29sb3JfbmlnaHQYAyABKAlSDnRleHRDb2xvck5pZ2h0EhkKCGJn'
    'X2NvbG9yGAQgASgJUgdiZ0NvbG9yEiQKDmJnX2NvbG9yX25pZ2h0GAUgASgJUgxiZ0NvbG9yTm'
    'lnaHQSEgoEbGluaxgGIAEoCVIEbGluaxJGCgthY3Rpb25fdHlwZRgHIAEoDjIlLmJpbGliaWxp'
    'LmFwcC5wbGF5dXJsLnYxLkJ1dHRvbkFjdGlvblIKYWN0aW9uVHlwZRI3CgZyZXBvcnQYCCABKA'
    'syHy5iaWxpYmlsaS5hcHAucGxheXVybC52MS5SZXBvcnRSBnJlcG9ydBIfCgtmcmFtZV9jb2xv'
    'chgJIAEoCVIKZnJhbWVDb2xvchISCgRpY29uGAogASgJUgRpY29u');

@$core.Deprecated('Use buttonStyleDescriptor instead')
const ButtonStyle$json = {
  '1': 'ButtonStyle',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'text_color', '3': 2, '4': 1, '5': 9, '10': 'textColor'},
    {'1': 'bg_color', '3': 3, '4': 1, '5': 9, '10': 'bgColor'},
    {'1': 'jump_link', '3': 4, '4': 1, '5': 9, '10': 'jumpLink'},
  ],
};

/// Descriptor for `ButtonStyle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List buttonStyleDescriptor = $convert.base64Decode(
    'CgtCdXR0b25TdHlsZRISCgR0ZXh0GAEgASgJUgR0ZXh0Eh0KCnRleHRfY29sb3IYAiABKAlSCX'
    'RleHRDb2xvchIZCghiZ19jb2xvchgDIAEoCVIHYmdDb2xvchIbCglqdW1wX2xpbmsYBCABKAlS'
    'CGp1bXBMaW5r');

@$core.Deprecated('Use chronosDescriptor instead')
const Chronos$json = {
  '1': 'Chronos',
  '2': [
    {'1': 'md5', '3': 1, '4': 1, '5': 9, '10': 'md5'},
    {'1': 'file', '3': 2, '4': 1, '5': 9, '10': 'file'},
  ],
};

/// Descriptor for `Chronos`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chronosDescriptor = $convert.base64Decode(
    'CgdDaHJvbm9zEhAKA21kNRgBIAEoCVIDbWQ1EhIKBGZpbGUYAiABKAlSBGZpbGU=');

@$core.Deprecated('Use cloudConfDescriptor instead')
const CloudConf$json = {
  '1': 'CloudConf',
  '2': [
    {'1': 'show', '3': 1, '4': 1, '5': 8, '10': 'show'},
    {
      '1': 'conf_type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.playurl.v1.ConfType',
      '10': 'confType'
    },
    {
      '1': 'field_value',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.FieldValue',
      '10': 'fieldValue'
    },
    {
      '1': 'conf_value',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ConfValue',
      '10': 'confValue'
    },
  ],
};

/// Descriptor for `CloudConf`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cloudConfDescriptor = $convert.base64Decode(
    'CglDbG91ZENvbmYSEgoEc2hvdxgBIAEoCFIEc2hvdxI+Cgljb25mX3R5cGUYAiABKA4yIS5iaW'
    'xpYmlsaS5hcHAucGxheXVybC52MS5Db25mVHlwZVIIY29uZlR5cGUSRAoLZmllbGRfdmFsdWUY'
    'AyABKAsyIy5iaWxpYmlsaS5hcHAucGxheXVybC52MS5GaWVsZFZhbHVlUgpmaWVsZFZhbHVlEk'
    'EKCmNvbmZfdmFsdWUYBCABKAsyIi5iaWxpYmlsaS5hcHAucGxheXVybC52MS5Db25mVmFsdWVS'
    'CWNvbmZWYWx1ZQ==');

@$core.Deprecated('Use comprehensiveToastDescriptor instead')
const ComprehensiveToast$json = {
  '1': 'ComprehensiveToast',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.playurl.v1.ToastType',
      '10': 'type'
    },
    {
      '1': 'button',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ButtonInfo',
      '10': 'button'
    },
    {'1': 'icon', '3': 3, '4': 1, '5': 9, '10': 'icon'},
    {
      '1': 'toast_text',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.TextInfo',
      '10': 'toastText'
    },
    {
      '1': 'report',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.Report',
      '10': 'report'
    },
  ],
};

/// Descriptor for `ComprehensiveToast`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List comprehensiveToastDescriptor = $convert.base64Decode(
    'ChJDb21wcmVoZW5zaXZlVG9hc3QSNgoEdHlwZRgBIAEoDjIiLmJpbGliaWxpLmFwcC5wbGF5dX'
    'JsLnYxLlRvYXN0VHlwZVIEdHlwZRI7CgZidXR0b24YAiABKAsyIy5iaWxpYmlsaS5hcHAucGxh'
    'eXVybC52MS5CdXR0b25JbmZvUgZidXR0b24SEgoEaWNvbhgDIAEoCVIEaWNvbhJACgp0b2FzdF'
    '90ZXh0GAQgASgLMiEuYmlsaWJpbGkuYXBwLnBsYXl1cmwudjEuVGV4dEluZm9SCXRvYXN0VGV4'
    'dBI3CgZyZXBvcnQYBSABKAsyHy5iaWxpYmlsaS5hcHAucGxheXVybC52MS5SZXBvcnRSBnJlcG'
    '9ydA==');

@$core.Deprecated('Use confValueDescriptor instead')
const ConfValue$json = {
  '1': 'ConfValue',
  '2': [
    {'1': 'switch_val', '3': 1, '4': 1, '5': 8, '9': 0, '10': 'switchVal'},
    {'1': 'selected_val', '3': 2, '4': 1, '5': 3, '9': 0, '10': 'selectedVal'},
  ],
  '8': [
    {'1': 'value'},
  ],
};

/// Descriptor for `ConfValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confValueDescriptor = $convert.base64Decode(
    'CglDb25mVmFsdWUSHwoKc3dpdGNoX3ZhbBgBIAEoCEgAUglzd2l0Y2hWYWwSIwoMc2VsZWN0ZW'
    'RfdmFsGAIgASgDSABSC3NlbGVjdGVkVmFsQgcKBXZhbHVl');

@$core.Deprecated('Use dashItemDescriptor instead')
const DashItem$json = {
  '1': 'DashItem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'base_url', '3': 2, '4': 1, '5': 9, '10': 'baseUrl'},
    {'1': 'backup_url', '3': 3, '4': 3, '5': 9, '10': 'backupUrl'},
    {'1': 'bandwidth', '3': 4, '4': 1, '5': 5, '10': 'bandwidth'},
    {'1': 'codecid', '3': 5, '4': 1, '5': 5, '10': 'codecid'},
    {'1': 'md5', '3': 6, '4': 1, '5': 9, '10': 'md5'},
    {'1': 'size', '3': 7, '4': 1, '5': 3, '10': 'size'},
    {'1': 'frame_rate', '3': 8, '4': 1, '5': 9, '10': 'frameRate'},
    {'1': 'widevine_pssh', '3': 9, '4': 1, '5': 9, '10': 'widevinePssh'},
    {'1': 'bilidrm_uri', '3': 10, '4': 1, '5': 9, '10': 'bilidrmUri'},
  ],
};

/// Descriptor for `DashItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dashItemDescriptor = $convert.base64Decode(
    'CghEYXNoSXRlbRIOCgJpZBgBIAEoBVICaWQSGQoIYmFzZV91cmwYAiABKAlSB2Jhc2VVcmwSHQ'
    'oKYmFja3VwX3VybBgDIAMoCVIJYmFja3VwVXJsEhwKCWJhbmR3aWR0aBgEIAEoBVIJYmFuZHdp'
    'ZHRoEhgKB2NvZGVjaWQYBSABKAVSB2NvZGVjaWQSEAoDbWQ1GAYgASgJUgNtZDUSEgoEc2l6ZR'
    'gHIAEoA1IEc2l6ZRIdCgpmcmFtZV9yYXRlGAggASgJUglmcmFtZVJhdGUSIwoNd2lkZXZpbmVf'
    'cHNzaBgJIAEoCVIMd2lkZXZpbmVQc3NoEh8KC2JpbGlkcm1fdXJpGAogASgJUgpiaWxpZHJtVX'
    'Jp');

@$core.Deprecated('Use dashVideoDescriptor instead')
const DashVideo$json = {
  '1': 'DashVideo',
  '2': [
    {'1': 'base_url', '3': 1, '4': 1, '5': 9, '10': 'baseUrl'},
    {'1': 'backup_url', '3': 2, '4': 3, '5': 9, '10': 'backupUrl'},
    {'1': 'bandwidth', '3': 3, '4': 1, '5': 5, '10': 'bandwidth'},
    {'1': 'codecid', '3': 4, '4': 1, '5': 5, '10': 'codecid'},
    {'1': 'md5', '3': 5, '4': 1, '5': 9, '10': 'md5'},
    {'1': 'size', '3': 6, '4': 1, '5': 3, '10': 'size'},
    {'1': 'audio_id', '3': 7, '4': 1, '5': 5, '10': 'audioId'},
    {'1': 'no_rexcode', '3': 8, '4': 1, '5': 8, '10': 'noRexcode'},
    {'1': 'frame_rate', '3': 9, '4': 1, '5': 9, '10': 'frameRate'},
    {'1': 'width', '3': 10, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 11, '4': 1, '5': 5, '10': 'height'},
    {'1': 'widevine_pssh', '3': 12, '4': 1, '5': 9, '10': 'widevinePssh'},
    {'1': 'bilidrm_uri', '3': 13, '4': 1, '5': 9, '10': 'bilidrmUri'},
  ],
};

/// Descriptor for `DashVideo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dashVideoDescriptor = $convert.base64Decode(
    'CglEYXNoVmlkZW8SGQoIYmFzZV91cmwYASABKAlSB2Jhc2VVcmwSHQoKYmFja3VwX3VybBgCIA'
    'MoCVIJYmFja3VwVXJsEhwKCWJhbmR3aWR0aBgDIAEoBVIJYmFuZHdpZHRoEhgKB2NvZGVjaWQY'
    'BCABKAVSB2NvZGVjaWQSEAoDbWQ1GAUgASgJUgNtZDUSEgoEc2l6ZRgGIAEoA1IEc2l6ZRIZCg'
    'hhdWRpb19pZBgHIAEoBVIHYXVkaW9JZBIdCgpub19yZXhjb2RlGAggASgIUglub1JleGNvZGUS'
    'HQoKZnJhbWVfcmF0ZRgJIAEoCVIJZnJhbWVSYXRlEhQKBXdpZHRoGAogASgFUgV3aWR0aBIWCg'
    'ZoZWlnaHQYCyABKAVSBmhlaWdodBIjCg13aWRldmluZV9wc3NoGAwgASgJUgx3aWRldmluZVBz'
    'c2gSHwoLYmlsaWRybV91cmkYDSABKAlSCmJpbGlkcm1Vcmk=');

@$core.Deprecated('Use dialogDescriptor instead')
const Dialog$json = {
  '1': 'Dialog',
  '2': [
    {
      '1': 'style_type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.playurl.v1.GuideStyle',
      '10': 'styleType'
    },
    {
      '1': 'report',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.Report',
      '10': 'report'
    },
    {
      '1': 'title',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.TextInfo',
      '10': 'title'
    },
    {
      '1': 'subtitle',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.TextInfo',
      '10': 'subtitle'
    },
    {
      '1': 'button',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ButtonInfo',
      '10': 'button'
    },
  ],
};

/// Descriptor for `Dialog`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dialogDescriptor = $convert.base64Decode(
    'CgZEaWFsb2cSQgoKc3R5bGVfdHlwZRgBIAEoDjIjLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLk'
    'd1aWRlU3R5bGVSCXN0eWxlVHlwZRI3CgZyZXBvcnQYAiABKAsyHy5iaWxpYmlsaS5hcHAucGxh'
    'eXVybC52MS5SZXBvcnRSBnJlcG9ydBI3CgV0aXRsZRgDIAEoCzIhLmJpbGliaWxpLmFwcC5wbG'
    'F5dXJsLnYxLlRleHRJbmZvUgV0aXRsZRI9CghzdWJ0aXRsZRgEIAEoCzIhLmJpbGliaWxpLmFw'
    'cC5wbGF5dXJsLnYxLlRleHRJbmZvUghzdWJ0aXRsZRI7CgZidXR0b24YBSADKAsyIy5iaWxpYm'
    'lsaS5hcHAucGxheXVybC52MS5CdXR0b25JbmZvUgZidXR0b24=');

@$core.Deprecated('Use dolbyItemDescriptor instead')
const DolbyItem$json = {
  '1': 'DolbyItem',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.playurl.v1.DolbyItem.Type',
      '10': 'type'
    },
    {
      '1': 'audio',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.DashItem',
      '10': 'audio'
    },
  ],
  '4': [DolbyItem_Type$json],
};

@$core.Deprecated('Use dolbyItemDescriptor instead')
const DolbyItem_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'NONE', '2': 0},
    {'1': 'COMMON', '2': 1},
    {'1': 'ATMOS', '2': 2},
  ],
};

/// Descriptor for `DolbyItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dolbyItemDescriptor = $convert.base64Decode(
    'CglEb2xieUl0ZW0SOwoEdHlwZRgBIAEoDjInLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLkRvbG'
    'J5SXRlbS5UeXBlUgR0eXBlEjcKBWF1ZGlvGAIgAygLMiEuYmlsaWJpbGkuYXBwLnBsYXl1cmwu'
    'djEuRGFzaEl0ZW1SBWF1ZGlvIicKBFR5cGUSCAoETk9ORRAAEgoKBkNPTU1PThABEgkKBUFUTU'
    '9TEAI=');

@$core.Deprecated('Use eventDescriptor instead')
const Event$json = {
  '1': 'Event',
  '2': [
    {
      '1': 'shake',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.Shake',
      '10': 'shake'
    },
  ],
};

/// Descriptor for `Event`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventDescriptor = $convert.base64Decode(
    'CgVFdmVudBI0CgVzaGFrZRgBIAEoCzIeLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLlNoYWtlUg'
    'VzaGFrZQ==');

@$core.Deprecated('Use extraContentDescriptor instead')
const ExtraContent$json = {
  '1': 'ExtraContent',
  '2': [
    {'1': 'disabled_reason', '3': 1, '4': 1, '5': 9, '10': 'disabledReason'},
    {'1': 'disabled_code', '3': 2, '4': 1, '5': 3, '10': 'disabledCode'},
  ],
};

/// Descriptor for `ExtraContent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List extraContentDescriptor = $convert.base64Decode(
    'CgxFeHRyYUNvbnRlbnQSJwoPZGlzYWJsZWRfcmVhc29uGAEgASgJUg5kaXNhYmxlZFJlYXNvbh'
    'IjCg1kaXNhYmxlZF9jb2RlGAIgASgDUgxkaXNhYmxlZENvZGU=');

@$core.Deprecated('Use fieldValueDescriptor instead')
const FieldValue$json = {
  '1': 'FieldValue',
  '2': [
    {'1': 'switch', '3': 1, '4': 1, '5': 8, '9': 0, '10': 'switch'},
  ],
  '8': [
    {'1': 'value'},
  ],
};

/// Descriptor for `FieldValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fieldValueDescriptor = $convert.base64Decode(
    'CgpGaWVsZFZhbHVlEhgKBnN3aXRjaBgBIAEoCEgAUgZzd2l0Y2hCBwoFdmFsdWU=');

@$core.Deprecated('Use formatDescriptionDescriptor instead')
const FormatDescription$json = {
  '1': 'FormatDescription',
  '2': [
    {'1': 'quality', '3': 1, '4': 1, '5': 5, '10': 'quality'},
    {'1': 'format', '3': 2, '4': 1, '5': 9, '10': 'format'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'new_description', '3': 4, '4': 1, '5': 9, '10': 'newDescription'},
    {'1': 'display_desc', '3': 5, '4': 1, '5': 9, '10': 'displayDesc'},
    {'1': 'superscript', '3': 6, '4': 1, '5': 9, '10': 'superscript'},
  ],
};

/// Descriptor for `FormatDescription`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List formatDescriptionDescriptor = $convert.base64Decode(
    'ChFGb3JtYXREZXNjcmlwdGlvbhIYCgdxdWFsaXR5GAEgASgFUgdxdWFsaXR5EhYKBmZvcm1hdB'
    'gCIAEoCVIGZm9ybWF0EiAKC2Rlc2NyaXB0aW9uGAMgASgJUgtkZXNjcmlwdGlvbhInCg9uZXdf'
    'ZGVzY3JpcHRpb24YBCABKAlSDm5ld0Rlc2NyaXB0aW9uEiEKDGRpc3BsYXlfZGVzYxgFIAEoCV'
    'ILZGlzcGxheURlc2MSIAoLc3VwZXJzY3JpcHQYBiABKAlSC3N1cGVyc2NyaXB0');

@$core.Deprecated('Use glanceDescriptor instead')
const Glance$json = {
  '1': 'Glance',
  '2': [
    {'1': 'can_watch', '3': 1, '4': 1, '5': 8, '10': 'canWatch'},
    {'1': 'times', '3': 2, '4': 1, '5': 3, '10': 'times'},
    {'1': 'duration', '3': 3, '4': 1, '5': 3, '10': 'duration'},
  ],
};

/// Descriptor for `Glance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List glanceDescriptor = $convert.base64Decode(
    'CgZHbGFuY2USGwoJY2FuX3dhdGNoGAEgASgIUghjYW5XYXRjaBIUCgV0aW1lcxgCIAEoA1IFdG'
    'ltZXMSGgoIZHVyYXRpb24YAyABKANSCGR1cmF0aW9u');

@$core.Deprecated('Use lossLessItemDescriptor instead')
const LossLessItem$json = {
  '1': 'LossLessItem',
  '2': [
    {'1': 'is_lossless_audio', '3': 1, '4': 1, '5': 8, '10': 'isLosslessAudio'},
    {
      '1': 'audio',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.DashItem',
      '10': 'audio'
    },
    {'1': 'need_vip', '3': 3, '4': 1, '5': 8, '10': 'needVip'},
  ],
};

/// Descriptor for `LossLessItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lossLessItemDescriptor = $convert.base64Decode(
    'CgxMb3NzTGVzc0l0ZW0SKgoRaXNfbG9zc2xlc3NfYXVkaW8YASABKAhSD2lzTG9zc2xlc3NBdW'
    'RpbxI3CgVhdWRpbxgCIAEoCzIhLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLkRhc2hJdGVtUgVh'
    'dWRpbxIZCghuZWVkX3ZpcBgDIAEoCFIHbmVlZFZpcA==');

@$core.Deprecated('Use multiDashVideoDescriptor instead')
const MultiDashVideo$json = {
  '1': 'MultiDashVideo',
  '2': [
    {
      '1': 'dash_videos',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.DashVideo',
      '10': 'dashVideos'
    },
  ],
};

/// Descriptor for `MultiDashVideo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List multiDashVideoDescriptor = $convert.base64Decode(
    'Cg5NdWx0aURhc2hWaWRlbxJDCgtkYXNoX3ZpZGVvcxgBIAMoCzIiLmJpbGliaWxpLmFwcC5wbG'
    'F5dXJsLnYxLkRhc2hWaWRlb1IKZGFzaFZpZGVvcw==');

@$core.Deprecated('Use playAbilityConfDescriptor instead')
const PlayAbilityConf$json = {
  '1': 'PlayAbilityConf',
  '2': [
    {
      '1': 'background_play_conf',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'backgroundPlayConf'
    },
    {
      '1': 'flip_conf',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'flipConf'
    },
    {
      '1': 'cast_conf',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'castConf'
    },
    {
      '1': 'feedback_conf',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'feedbackConf'
    },
    {
      '1': 'subtitle_conf',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'subtitleConf'
    },
    {
      '1': 'playback_rate_conf',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'playbackRateConf'
    },
    {
      '1': 'time_up_conf',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'timeUpConf'
    },
    {
      '1': 'playback_mode_conf',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'playbackModeConf'
    },
    {
      '1': 'scale_mode_conf',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'scaleModeConf'
    },
    {
      '1': 'like_conf',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'likeConf'
    },
    {
      '1': 'dislike_conf',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'dislikeConf'
    },
    {
      '1': 'coin_conf',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'coinConf'
    },
    {
      '1': 'elec_conf',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'elecConf'
    },
    {
      '1': 'share_conf',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'shareConf'
    },
    {
      '1': 'screen_shot_conf',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'screenShotConf'
    },
    {
      '1': 'lock_screen_conf',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'lockScreenConf'
    },
    {
      '1': 'recommend_conf',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'recommendConf'
    },
    {
      '1': 'playback_speed_conf',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'playbackSpeedConf'
    },
    {
      '1': 'definition_conf',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'definitionConf'
    },
    {
      '1': 'selections_conf',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'selectionsConf'
    },
    {
      '1': 'next_conf',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'nextConf'
    },
    {
      '1': 'edit_dm_conf',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'editDmConf'
    },
    {
      '1': 'small_window_conf',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'smallWindowConf'
    },
    {
      '1': 'shake_conf',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'shakeConf'
    },
    {
      '1': 'outer_dm_conf',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'outerDmConf'
    },
    {
      '1': 'inner_dm_conf',
      '3': 26,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'innerDmConf'
    },
    {
      '1': 'panorama_conf',
      '3': 27,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'panoramaConf'
    },
    {
      '1': 'dolby_conf',
      '3': 28,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'dolbyConf'
    },
    {
      '1': 'color_filter_conf',
      '3': 29,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'colorFilterConf'
    },
    {
      '1': 'loss_less_conf',
      '3': 30,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.CloudConf',
      '10': 'lossLessConf'
    },
  ],
};

/// Descriptor for `PlayAbilityConf`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playAbilityConfDescriptor = $convert.base64Decode(
    'Cg9QbGF5QWJpbGl0eUNvbmYSVAoUYmFja2dyb3VuZF9wbGF5X2NvbmYYASABKAsyIi5iaWxpYm'
    'lsaS5hcHAucGxheXVybC52MS5DbG91ZENvbmZSEmJhY2tncm91bmRQbGF5Q29uZhI/CglmbGlw'
    'X2NvbmYYAiABKAsyIi5iaWxpYmlsaS5hcHAucGxheXVybC52MS5DbG91ZENvbmZSCGZsaXBDb2'
    '5mEj8KCWNhc3RfY29uZhgDIAEoCzIiLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLkNsb3VkQ29u'
    'ZlIIY2FzdENvbmYSRwoNZmVlZGJhY2tfY29uZhgEIAEoCzIiLmJpbGliaWxpLmFwcC5wbGF5dX'
    'JsLnYxLkNsb3VkQ29uZlIMZmVlZGJhY2tDb25mEkcKDXN1YnRpdGxlX2NvbmYYBSABKAsyIi5i'
    'aWxpYmlsaS5hcHAucGxheXVybC52MS5DbG91ZENvbmZSDHN1YnRpdGxlQ29uZhJQChJwbGF5Ym'
    'Fja19yYXRlX2NvbmYYBiABKAsyIi5iaWxpYmlsaS5hcHAucGxheXVybC52MS5DbG91ZENvbmZS'
    'EHBsYXliYWNrUmF0ZUNvbmYSRAoMdGltZV91cF9jb25mGAcgASgLMiIuYmlsaWJpbGkuYXBwLn'
    'BsYXl1cmwudjEuQ2xvdWRDb25mUgp0aW1lVXBDb25mElAKEnBsYXliYWNrX21vZGVfY29uZhgI'
    'IAEoCzIiLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLkNsb3VkQ29uZlIQcGxheWJhY2tNb2RlQ2'
    '9uZhJKCg9zY2FsZV9tb2RlX2NvbmYYCSABKAsyIi5iaWxpYmlsaS5hcHAucGxheXVybC52MS5D'
    'bG91ZENvbmZSDXNjYWxlTW9kZUNvbmYSPwoJbGlrZV9jb25mGAogASgLMiIuYmlsaWJpbGkuYX'
    'BwLnBsYXl1cmwudjEuQ2xvdWRDb25mUghsaWtlQ29uZhJFCgxkaXNsaWtlX2NvbmYYCyABKAsy'
    'Ii5iaWxpYmlsaS5hcHAucGxheXVybC52MS5DbG91ZENvbmZSC2Rpc2xpa2VDb25mEj8KCWNvaW'
    '5fY29uZhgMIAEoCzIiLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLkNsb3VkQ29uZlIIY29pbkNv'
    'bmYSPwoJZWxlY19jb25mGA0gASgLMiIuYmlsaWJpbGkuYXBwLnBsYXl1cmwudjEuQ2xvdWRDb2'
    '5mUghlbGVjQ29uZhJBCgpzaGFyZV9jb25mGA4gASgLMiIuYmlsaWJpbGkuYXBwLnBsYXl1cmwu'
    'djEuQ2xvdWRDb25mUglzaGFyZUNvbmYSTAoQc2NyZWVuX3Nob3RfY29uZhgPIAEoCzIiLmJpbG'
    'liaWxpLmFwcC5wbGF5dXJsLnYxLkNsb3VkQ29uZlIOc2NyZWVuU2hvdENvbmYSTAoQbG9ja19z'
    'Y3JlZW5fY29uZhgQIAEoCzIiLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLkNsb3VkQ29uZlIObG'
    '9ja1NjcmVlbkNvbmYSSQoOcmVjb21tZW5kX2NvbmYYESABKAsyIi5iaWxpYmlsaS5hcHAucGxh'
    'eXVybC52MS5DbG91ZENvbmZSDXJlY29tbWVuZENvbmYSUgoTcGxheWJhY2tfc3BlZWRfY29uZh'
    'gSIAEoCzIiLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLkNsb3VkQ29uZlIRcGxheWJhY2tTcGVl'
    'ZENvbmYSSwoPZGVmaW5pdGlvbl9jb25mGBMgASgLMiIuYmlsaWJpbGkuYXBwLnBsYXl1cmwudj'
    'EuQ2xvdWRDb25mUg5kZWZpbml0aW9uQ29uZhJLCg9zZWxlY3Rpb25zX2NvbmYYFCABKAsyIi5i'
    'aWxpYmlsaS5hcHAucGxheXVybC52MS5DbG91ZENvbmZSDnNlbGVjdGlvbnNDb25mEj8KCW5leH'
    'RfY29uZhgVIAEoCzIiLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLkNsb3VkQ29uZlIIbmV4dENv'
    'bmYSRAoMZWRpdF9kbV9jb25mGBYgASgLMiIuYmlsaWJpbGkuYXBwLnBsYXl1cmwudjEuQ2xvdW'
    'RDb25mUgplZGl0RG1Db25mEk4KEXNtYWxsX3dpbmRvd19jb25mGBcgASgLMiIuYmlsaWJpbGku'
    'YXBwLnBsYXl1cmwudjEuQ2xvdWRDb25mUg9zbWFsbFdpbmRvd0NvbmYSQQoKc2hha2VfY29uZh'
    'gYIAEoCzIiLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLkNsb3VkQ29uZlIJc2hha2VDb25mEkYK'
    'DW91dGVyX2RtX2NvbmYYGSABKAsyIi5iaWxpYmlsaS5hcHAucGxheXVybC52MS5DbG91ZENvbm'
    'ZSC291dGVyRG1Db25mEkYKDWlubmVyX2RtX2NvbmYYGiABKAsyIi5iaWxpYmlsaS5hcHAucGxh'
    'eXVybC52MS5DbG91ZENvbmZSC2lubmVyRG1Db25mEkcKDXBhbm9yYW1hX2NvbmYYGyABKAsyIi'
    '5iaWxpYmlsaS5hcHAucGxheXVybC52MS5DbG91ZENvbmZSDHBhbm9yYW1hQ29uZhJBCgpkb2xi'
    'eV9jb25mGBwgASgLMiIuYmlsaWJpbGkuYXBwLnBsYXl1cmwudjEuQ2xvdWRDb25mUglkb2xieU'
    'NvbmYSTgoRY29sb3JfZmlsdGVyX2NvbmYYHSABKAsyIi5iaWxpYmlsaS5hcHAucGxheXVybC52'
    'MS5DbG91ZENvbmZSD2NvbG9yRmlsdGVyQ29uZhJICg5sb3NzX2xlc3NfY29uZhgeIAEoCzIiLm'
    'JpbGliaWxpLmFwcC5wbGF5dXJsLnYxLkNsb3VkQ29uZlIMbG9zc0xlc3NDb25m');

@$core.Deprecated('Use playArcDescriptor instead')
const PlayArc$json = {
  '1': 'PlayArc',
  '2': [
    {'1': 'is_preview', '3': 1, '4': 1, '5': 8, '10': 'isPreview'},
  ],
};

/// Descriptor for `PlayArc`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playArcDescriptor = $convert
    .base64Decode('CgdQbGF5QXJjEh0KCmlzX3ByZXZpZXcYASABKAhSCWlzUHJldmlldw==');

@$core.Deprecated('Use playArcConfDescriptor instead')
const PlayArcConf$json = {
  '1': 'PlayArcConf',
  '2': [
    {
      '1': 'background_play_conf',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'backgroundPlayConf'
    },
    {
      '1': 'flip_conf',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'flipConf'
    },
    {
      '1': 'cast_conf',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'castConf'
    },
    {
      '1': 'feedback_conf',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'feedbackConf'
    },
    {
      '1': 'subtitle_conf',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'subtitleConf'
    },
    {
      '1': 'playback_rate_conf',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'playbackRateConf'
    },
    {
      '1': 'time_up_conf',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'timeUpConf'
    },
    {
      '1': 'playback_mode_conf',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'playbackModeConf'
    },
    {
      '1': 'scale_mode_conf',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'scaleModeConf'
    },
    {
      '1': 'like_conf',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'likeConf'
    },
    {
      '1': 'dislike_conf',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'dislikeConf'
    },
    {
      '1': 'coin_conf',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'coinConf'
    },
    {
      '1': 'elec_conf',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'elecConf'
    },
    {
      '1': 'share_conf',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'shareConf'
    },
    {
      '1': 'screen_shot_conf',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'screenShotConf'
    },
    {
      '1': 'lock_screen_conf',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'lockScreenConf'
    },
    {
      '1': 'recommend_conf',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'recommendConf'
    },
    {
      '1': 'playback_speed_conf',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'playbackSpeedConf'
    },
    {
      '1': 'definition_conf',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'definitionConf'
    },
    {
      '1': 'selections_conf',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'selectionsConf'
    },
    {
      '1': 'next_conf',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'nextConf'
    },
    {
      '1': 'edit_dm_conf',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'editDmConf'
    },
    {
      '1': 'small_window_conf',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'smallWindowConf'
    },
    {
      '1': 'shake_conf',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'shakeConf'
    },
    {
      '1': 'outer_dm_conf',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'outerDmConf'
    },
    {
      '1': 'inner_dm_conf',
      '3': 26,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'innerDmConf'
    },
    {
      '1': 'panorama_conf',
      '3': 27,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'panoramaConf'
    },
    {
      '1': 'dolby_conf',
      '3': 28,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'dolbyConf'
    },
    {
      '1': 'screen_recording_conf',
      '3': 29,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'screenRecordingConf'
    },
    {
      '1': 'color_filter_conf',
      '3': 30,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'colorFilterConf'
    },
    {
      '1': 'loss_less_conf',
      '3': 31,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'lossLessConf'
    },
    {
      '1': 'system_record_conf',
      '3': 32,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ArcConf',
      '10': 'systemRecordConf'
    },
  ],
};

/// Descriptor for `PlayArcConf`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playArcConfDescriptor = $convert.base64Decode(
    'CgtQbGF5QXJjQ29uZhJSChRiYWNrZ3JvdW5kX3BsYXlfY29uZhgBIAEoCzIgLmJpbGliaWxpLm'
    'FwcC5wbGF5dXJsLnYxLkFyY0NvbmZSEmJhY2tncm91bmRQbGF5Q29uZhI9CglmbGlwX2NvbmYY'
    'AiABKAsyIC5iaWxpYmlsaS5hcHAucGxheXVybC52MS5BcmNDb25mUghmbGlwQ29uZhI9CgljYX'
    'N0X2NvbmYYAyABKAsyIC5iaWxpYmlsaS5hcHAucGxheXVybC52MS5BcmNDb25mUghjYXN0Q29u'
    'ZhJFCg1mZWVkYmFja19jb25mGAQgASgLMiAuYmlsaWJpbGkuYXBwLnBsYXl1cmwudjEuQXJjQ2'
    '9uZlIMZmVlZGJhY2tDb25mEkUKDXN1YnRpdGxlX2NvbmYYBSABKAsyIC5iaWxpYmlsaS5hcHAu'
    'cGxheXVybC52MS5BcmNDb25mUgxzdWJ0aXRsZUNvbmYSTgoScGxheWJhY2tfcmF0ZV9jb25mGA'
    'YgASgLMiAuYmlsaWJpbGkuYXBwLnBsYXl1cmwudjEuQXJjQ29uZlIQcGxheWJhY2tSYXRlQ29u'
    'ZhJCCgx0aW1lX3VwX2NvbmYYByABKAsyIC5iaWxpYmlsaS5hcHAucGxheXVybC52MS5BcmNDb2'
    '5mUgp0aW1lVXBDb25mEk4KEnBsYXliYWNrX21vZGVfY29uZhgIIAEoCzIgLmJpbGliaWxpLmFw'
    'cC5wbGF5dXJsLnYxLkFyY0NvbmZSEHBsYXliYWNrTW9kZUNvbmYSSAoPc2NhbGVfbW9kZV9jb2'
    '5mGAkgASgLMiAuYmlsaWJpbGkuYXBwLnBsYXl1cmwudjEuQXJjQ29uZlINc2NhbGVNb2RlQ29u'
    'ZhI9CglsaWtlX2NvbmYYCiABKAsyIC5iaWxpYmlsaS5hcHAucGxheXVybC52MS5BcmNDb25mUg'
    'hsaWtlQ29uZhJDCgxkaXNsaWtlX2NvbmYYCyABKAsyIC5iaWxpYmlsaS5hcHAucGxheXVybC52'
    'MS5BcmNDb25mUgtkaXNsaWtlQ29uZhI9Cgljb2luX2NvbmYYDCABKAsyIC5iaWxpYmlsaS5hcH'
    'AucGxheXVybC52MS5BcmNDb25mUghjb2luQ29uZhI9CgllbGVjX2NvbmYYDSABKAsyIC5iaWxp'
    'YmlsaS5hcHAucGxheXVybC52MS5BcmNDb25mUghlbGVjQ29uZhI/CgpzaGFyZV9jb25mGA4gAS'
    'gLMiAuYmlsaWJpbGkuYXBwLnBsYXl1cmwudjEuQXJjQ29uZlIJc2hhcmVDb25mEkoKEHNjcmVl'
    'bl9zaG90X2NvbmYYDyABKAsyIC5iaWxpYmlsaS5hcHAucGxheXVybC52MS5BcmNDb25mUg5zY3'
    'JlZW5TaG90Q29uZhJKChBsb2NrX3NjcmVlbl9jb25mGBAgASgLMiAuYmlsaWJpbGkuYXBwLnBs'
    'YXl1cmwudjEuQXJjQ29uZlIObG9ja1NjcmVlbkNvbmYSRwoOcmVjb21tZW5kX2NvbmYYESABKA'
    'syIC5iaWxpYmlsaS5hcHAucGxheXVybC52MS5BcmNDb25mUg1yZWNvbW1lbmRDb25mElAKE3Bs'
    'YXliYWNrX3NwZWVkX2NvbmYYEiABKAsyIC5iaWxpYmlsaS5hcHAucGxheXVybC52MS5BcmNDb2'
    '5mUhFwbGF5YmFja1NwZWVkQ29uZhJJCg9kZWZpbml0aW9uX2NvbmYYEyABKAsyIC5iaWxpYmls'
    'aS5hcHAucGxheXVybC52MS5BcmNDb25mUg5kZWZpbml0aW9uQ29uZhJJCg9zZWxlY3Rpb25zX2'
    'NvbmYYFCABKAsyIC5iaWxpYmlsaS5hcHAucGxheXVybC52MS5BcmNDb25mUg5zZWxlY3Rpb25z'
    'Q29uZhI9CgluZXh0X2NvbmYYFSABKAsyIC5iaWxpYmlsaS5hcHAucGxheXVybC52MS5BcmNDb2'
    '5mUghuZXh0Q29uZhJCCgxlZGl0X2RtX2NvbmYYFiABKAsyIC5iaWxpYmlsaS5hcHAucGxheXVy'
    'bC52MS5BcmNDb25mUgplZGl0RG1Db25mEkwKEXNtYWxsX3dpbmRvd19jb25mGBcgASgLMiAuYm'
    'lsaWJpbGkuYXBwLnBsYXl1cmwudjEuQXJjQ29uZlIPc21hbGxXaW5kb3dDb25mEj8KCnNoYWtl'
    'X2NvbmYYGCABKAsyIC5iaWxpYmlsaS5hcHAucGxheXVybC52MS5BcmNDb25mUglzaGFrZUNvbm'
    'YSRAoNb3V0ZXJfZG1fY29uZhgZIAEoCzIgLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLkFyY0Nv'
    'bmZSC291dGVyRG1Db25mEkQKDWlubmVyX2RtX2NvbmYYGiABKAsyIC5iaWxpYmlsaS5hcHAucG'
    'xheXVybC52MS5BcmNDb25mUgtpbm5lckRtQ29uZhJFCg1wYW5vcmFtYV9jb25mGBsgASgLMiAu'
    'YmlsaWJpbGkuYXBwLnBsYXl1cmwudjEuQXJjQ29uZlIMcGFub3JhbWFDb25mEj8KCmRvbGJ5X2'
    'NvbmYYHCABKAsyIC5iaWxpYmlsaS5hcHAucGxheXVybC52MS5BcmNDb25mUglkb2xieUNvbmYS'
    'VAoVc2NyZWVuX3JlY29yZGluZ19jb25mGB0gASgLMiAuYmlsaWJpbGkuYXBwLnBsYXl1cmwudj'
    'EuQXJjQ29uZlITc2NyZWVuUmVjb3JkaW5nQ29uZhJMChFjb2xvcl9maWx0ZXJfY29uZhgeIAEo'
    'CzIgLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLkFyY0NvbmZSD2NvbG9yRmlsdGVyQ29uZhJGCg'
    '5sb3NzX2xlc3NfY29uZhgfIAEoCzIgLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLkFyY0NvbmZS'
    'DGxvc3NMZXNzQ29uZhJOChJzeXN0ZW1fcmVjb3JkX2NvbmYYICABKAsyIC5iaWxpYmlsaS5hcH'
    'AucGxheXVybC52MS5BcmNDb25mUhBzeXN0ZW1SZWNvcmRDb25m');

@$core.Deprecated('Use playConfEditReplyDescriptor instead')
const PlayConfEditReply$json = {
  '1': 'PlayConfEditReply',
};

/// Descriptor for `PlayConfEditReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playConfEditReplyDescriptor =
    $convert.base64Decode('ChFQbGF5Q29uZkVkaXRSZXBseQ==');

@$core.Deprecated('Use playConfEditReqDescriptor instead')
const PlayConfEditReq$json = {
  '1': 'PlayConfEditReq',
  '2': [
    {
      '1': 'play_conf',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.PlayConfState',
      '10': 'playConf'
    },
  ],
};

/// Descriptor for `PlayConfEditReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playConfEditReqDescriptor = $convert.base64Decode(
    'Cg9QbGF5Q29uZkVkaXRSZXESQwoJcGxheV9jb25mGAEgAygLMiYuYmlsaWJpbGkuYXBwLnBsYX'
    'l1cmwudjEuUGxheUNvbmZTdGF0ZVIIcGxheUNvbmY=');

@$core.Deprecated('Use playConfReplyDescriptor instead')
const PlayConfReply$json = {
  '1': 'PlayConfReply',
  '2': [
    {
      '1': 'play_conf',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.PlayAbilityConf',
      '10': 'playConf'
    },
  ],
};

/// Descriptor for `PlayConfReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playConfReplyDescriptor = $convert.base64Decode(
    'Cg1QbGF5Q29uZlJlcGx5EkUKCXBsYXlfY29uZhgBIAEoCzIoLmJpbGliaWxpLmFwcC5wbGF5dX'
    'JsLnYxLlBsYXlBYmlsaXR5Q29uZlIIcGxheUNvbmY=');

@$core.Deprecated('Use playConfReqDescriptor instead')
const PlayConfReq$json = {
  '1': 'PlayConfReq',
};

/// Descriptor for `PlayConfReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playConfReqDescriptor =
    $convert.base64Decode('CgtQbGF5Q29uZlJlcQ==');

@$core.Deprecated('Use playConfStateDescriptor instead')
const PlayConfState$json = {
  '1': 'PlayConfState',
  '2': [
    {
      '1': 'conf_type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.playurl.v1.ConfType',
      '10': 'confType'
    },
    {'1': 'show', '3': 2, '4': 1, '5': 8, '10': 'show'},
    {
      '1': 'field_value',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.FieldValue',
      '10': 'fieldValue'
    },
    {
      '1': 'conf_value',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ConfValue',
      '10': 'confValue'
    },
  ],
};

/// Descriptor for `PlayConfState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playConfStateDescriptor = $convert.base64Decode(
    'Cg1QbGF5Q29uZlN0YXRlEj4KCWNvbmZfdHlwZRgBIAEoDjIhLmJpbGliaWxpLmFwcC5wbGF5dX'
    'JsLnYxLkNvbmZUeXBlUghjb25mVHlwZRISCgRzaG93GAIgASgIUgRzaG93EkQKC2ZpZWxkX3Zh'
    'bHVlGAMgASgLMiMuYmlsaWJpbGkuYXBwLnBsYXl1cmwudjEuRmllbGRWYWx1ZVIKZmllbGRWYW'
    'x1ZRJBCgpjb25mX3ZhbHVlGAQgASgLMiIuYmlsaWJpbGkuYXBwLnBsYXl1cmwudjEuQ29uZlZh'
    'bHVlUgljb25mVmFsdWU=');

@$core.Deprecated('Use playLimitDescriptor instead')
const PlayLimit$json = {
  '1': 'PlayLimit',
  '2': [
    {
      '1': 'code',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.playurl.v1.PlayLimitCode',
      '10': 'code'
    },
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'sub_message', '3': 3, '4': 1, '5': 9, '10': 'subMessage'},
    {
      '1': 'button',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ButtonStyle',
      '10': 'button'
    },
  ],
};

/// Descriptor for `PlayLimit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playLimitDescriptor = $convert.base64Decode(
    'CglQbGF5TGltaXQSOgoEY29kZRgBIAEoDjImLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLlBsYX'
    'lMaW1pdENvZGVSBGNvZGUSGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZRIfCgtzdWJfbWVzc2Fn'
    'ZRgDIAEoCVIKc3ViTWVzc2FnZRI8CgZidXR0b24YBCABKAsyJC5iaWxpYmlsaS5hcHAucGxheX'
    'VybC52MS5CdXR0b25TdHlsZVIGYnV0dG9u');

@$core.Deprecated('Use playURLReplyDescriptor instead')
const PlayURLReply$json = {
  '1': 'PlayURLReply',
  '2': [
    {'1': 'quality', '3': 1, '4': 1, '5': 5, '10': 'quality'},
    {'1': 'format', '3': 2, '4': 1, '5': 9, '10': 'format'},
    {'1': 'timelength', '3': 3, '4': 1, '5': 3, '10': 'timelength'},
    {'1': 'video_codecid', '3': 4, '4': 1, '5': 5, '10': 'videoCodecid'},
    {'1': 'fnver', '3': 5, '4': 1, '5': 5, '10': 'fnver'},
    {'1': 'fnval', '3': 6, '4': 1, '5': 5, '10': 'fnval'},
    {'1': 'video_project', '3': 7, '4': 1, '5': 8, '10': 'videoProject'},
    {
      '1': 'durl',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ResponseUrl',
      '10': 'durl'
    },
    {
      '1': 'dash',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ResponseDash',
      '10': 'dash'
    },
    {'1': 'no_rexcode', '3': 10, '4': 1, '5': 5, '10': 'noRexcode'},
    {
      '1': 'upgrade_limit',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.UpgradeLimit',
      '10': 'upgradeLimit'
    },
    {
      '1': 'support_formats',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.FormatDescription',
      '10': 'supportFormats'
    },
    {
      '1': 'type',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.playurl.v1.VideoType',
      '10': 'type'
    },
    {
      '1': 'vip_risk',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.VipRisk',
      '10': 'vipRisk'
    },
  ],
};

/// Descriptor for `PlayURLReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playURLReplyDescriptor = $convert.base64Decode(
    'CgxQbGF5VVJMUmVwbHkSGAoHcXVhbGl0eRgBIAEoBVIHcXVhbGl0eRIWCgZmb3JtYXQYAiABKA'
    'lSBmZvcm1hdBIeCgp0aW1lbGVuZ3RoGAMgASgDUgp0aW1lbGVuZ3RoEiMKDXZpZGVvX2NvZGVj'
    'aWQYBCABKAVSDHZpZGVvQ29kZWNpZBIUCgVmbnZlchgFIAEoBVIFZm52ZXISFAoFZm52YWwYBi'
    'ABKAVSBWZudmFsEiMKDXZpZGVvX3Byb2plY3QYByABKAhSDHZpZGVvUHJvamVjdBI4CgRkdXJs'
    'GAggAygLMiQuYmlsaWJpbGkuYXBwLnBsYXl1cmwudjEuUmVzcG9uc2VVcmxSBGR1cmwSOQoEZG'
    'FzaBgJIAEoCzIlLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLlJlc3BvbnNlRGFzaFIEZGFzaBId'
    'Cgpub19yZXhjb2RlGAogASgFUglub1JleGNvZGUSSgoNdXBncmFkZV9saW1pdBgLIAEoCzIlLm'
    'JpbGliaWxpLmFwcC5wbGF5dXJsLnYxLlVwZ3JhZGVMaW1pdFIMdXBncmFkZUxpbWl0ElMKD3N1'
    'cHBvcnRfZm9ybWF0cxgMIAMoCzIqLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLkZvcm1hdERlc2'
    'NyaXB0aW9uUg5zdXBwb3J0Rm9ybWF0cxI2CgR0eXBlGA0gASgOMiIuYmlsaWJpbGkuYXBwLnBs'
    'YXl1cmwudjEuVmlkZW9UeXBlUgR0eXBlEjsKCHZpcF9yaXNrGA4gASgLMiAuYmlsaWJpbGkuYX'
    'BwLnBsYXl1cmwudjEuVmlwUmlza1IHdmlwUmlzaw==');

@$core.Deprecated('Use playURLReqDescriptor instead')
const PlayURLReq$json = {
  '1': 'PlayURLReq',
  '2': [
    {'1': 'aid', '3': 1, '4': 1, '5': 3, '10': 'aid'},
    {'1': 'cid', '3': 2, '4': 1, '5': 3, '10': 'cid'},
    {'1': 'qn', '3': 3, '4': 1, '5': 3, '10': 'qn'},
    {'1': 'fnver', '3': 4, '4': 1, '5': 5, '10': 'fnver'},
    {'1': 'fnval', '3': 5, '4': 1, '5': 5, '10': 'fnval'},
    {'1': 'download', '3': 6, '4': 1, '5': 5, '10': 'download'},
    {'1': 'force_host', '3': 7, '4': 1, '5': 5, '10': 'forceHost'},
    {'1': 'fourk', '3': 8, '4': 1, '5': 8, '10': 'fourk'},
    {'1': 'spmid', '3': 9, '4': 1, '5': 9, '10': 'spmid'},
    {'1': 'from_spmid', '3': 10, '4': 1, '5': 9, '10': 'fromSpmid'},
  ],
};

/// Descriptor for `PlayURLReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playURLReqDescriptor = $convert.base64Decode(
    'CgpQbGF5VVJMUmVxEhAKA2FpZBgBIAEoA1IDYWlkEhAKA2NpZBgCIAEoA1IDY2lkEg4KAnFuGA'
    'MgASgDUgJxbhIUCgVmbnZlchgEIAEoBVIFZm52ZXISFAoFZm52YWwYBSABKAVSBWZudmFsEhoK'
    'CGRvd25sb2FkGAYgASgFUghkb3dubG9hZBIdCgpmb3JjZV9ob3N0GAcgASgFUglmb3JjZUhvc3'
    'QSFAoFZm91cmsYCCABKAhSBWZvdXJrEhQKBXNwbWlkGAkgASgJUgVzcG1pZBIdCgpmcm9tX3Nw'
    'bWlkGAogASgJUglmcm9tU3BtaWQ=');

@$core.Deprecated('Use playViewReplyDescriptor instead')
const PlayViewReply$json = {
  '1': 'PlayViewReply',
  '2': [
    {
      '1': 'video_info',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.VideoInfo',
      '10': 'videoInfo'
    },
    {
      '1': 'play_conf',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.PlayAbilityConf',
      '10': 'playConf'
    },
    {
      '1': 'upgrade_limit',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.UpgradeLimit',
      '10': 'upgradeLimit'
    },
    {
      '1': 'chronos',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.Chronos',
      '10': 'chronos'
    },
    {
      '1': 'play_arc',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.PlayArcConf',
      '10': 'playArc'
    },
    {
      '1': 'event',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.Event',
      '10': 'event'
    },
    {
      '1': 'ab',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.AB',
      '10': 'ab'
    },
    {
      '1': 'play_limit',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.PlayLimit',
      '10': 'playLimit'
    },
    {
      '1': 'view_info',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ViewInfo',
      '10': 'viewInfo'
    },
    {
      '1': 'arc',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.PlayArc',
      '10': 'arc'
    },
  ],
};

/// Descriptor for `PlayViewReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playViewReplyDescriptor = $convert.base64Decode(
    'Cg1QbGF5Vmlld1JlcGx5EkEKCnZpZGVvX2luZm8YASABKAsyIi5iaWxpYmlsaS5hcHAucGxheX'
    'VybC52MS5WaWRlb0luZm9SCXZpZGVvSW5mbxJFCglwbGF5X2NvbmYYAiABKAsyKC5iaWxpYmls'
    'aS5hcHAucGxheXVybC52MS5QbGF5QWJpbGl0eUNvbmZSCHBsYXlDb25mEkoKDXVwZ3JhZGVfbG'
    'ltaXQYAyABKAsyJS5iaWxpYmlsaS5hcHAucGxheXVybC52MS5VcGdyYWRlTGltaXRSDHVwZ3Jh'
    'ZGVMaW1pdBI6CgdjaHJvbm9zGAQgASgLMiAuYmlsaWJpbGkuYXBwLnBsYXl1cmwudjEuQ2hyb2'
    '5vc1IHY2hyb25vcxI/CghwbGF5X2FyYxgFIAEoCzIkLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYx'
    'LlBsYXlBcmNDb25mUgdwbGF5QXJjEjQKBWV2ZW50GAYgASgLMh4uYmlsaWJpbGkuYXBwLnBsYX'
    'l1cmwudjEuRXZlbnRSBWV2ZW50EisKAmFiGAcgASgLMhsuYmlsaWJpbGkuYXBwLnBsYXl1cmwu'
    'djEuQUJSAmFiEkEKCnBsYXlfbGltaXQYCCABKAsyIi5iaWxpYmlsaS5hcHAucGxheXVybC52MS'
    '5QbGF5TGltaXRSCXBsYXlMaW1pdBI+Cgl2aWV3X2luZm8YCSABKAsyIS5iaWxpYmlsaS5hcHAu'
    'cGxheXVybC52MS5WaWV3SW5mb1IIdmlld0luZm8SMgoDYXJjGAogASgLMiAuYmlsaWJpbGkuYX'
    'BwLnBsYXl1cmwudjEuUGxheUFyY1IDYXJj');

@$core.Deprecated('Use playViewReqDescriptor instead')
const PlayViewReq$json = {
  '1': 'PlayViewReq',
  '2': [
    {'1': 'aid', '3': 1, '4': 1, '5': 3, '10': 'aid'},
    {'1': 'cid', '3': 2, '4': 1, '5': 3, '10': 'cid'},
    {'1': 'qn', '3': 3, '4': 1, '5': 3, '10': 'qn'},
    {'1': 'fnver', '3': 4, '4': 1, '5': 5, '10': 'fnver'},
    {'1': 'fnval', '3': 5, '4': 1, '5': 5, '10': 'fnval'},
    {'1': 'download', '3': 6, '4': 1, '5': 5, '10': 'download'},
    {'1': 'force_host', '3': 7, '4': 1, '5': 5, '10': 'forceHost'},
    {'1': 'fourk', '3': 8, '4': 1, '5': 8, '10': 'fourk'},
    {'1': 'spmid', '3': 9, '4': 1, '5': 9, '10': 'spmid'},
    {'1': 'from_spmid', '3': 10, '4': 1, '5': 9, '10': 'fromSpmid'},
    {'1': 'teenagers_mode', '3': 11, '4': 1, '5': 5, '10': 'teenagersMode'},
    {
      '1': 'prefer_codec_type',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.playurl.v1.CodeType',
      '10': 'preferCodecType'
    },
    {
      '1': 'business',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.playurl.v1.Business',
      '10': 'business'
    },
    {'1': 'voice_balance', '3': 14, '4': 1, '5': 3, '10': 'voiceBalance'},
  ],
};

/// Descriptor for `PlayViewReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playViewReqDescriptor = $convert.base64Decode(
    'CgtQbGF5Vmlld1JlcRIQCgNhaWQYASABKANSA2FpZBIQCgNjaWQYAiABKANSA2NpZBIOCgJxbh'
    'gDIAEoA1ICcW4SFAoFZm52ZXIYBCABKAVSBWZudmVyEhQKBWZudmFsGAUgASgFUgVmbnZhbBIa'
    'Cghkb3dubG9hZBgGIAEoBVIIZG93bmxvYWQSHQoKZm9yY2VfaG9zdBgHIAEoBVIJZm9yY2VIb3'
    'N0EhQKBWZvdXJrGAggASgIUgVmb3VyaxIUCgVzcG1pZBgJIAEoCVIFc3BtaWQSHQoKZnJvbV9z'
    'cG1pZBgKIAEoCVIJZnJvbVNwbWlkEiUKDnRlZW5hZ2Vyc19tb2RlGAsgASgFUg10ZWVuYWdlcn'
    'NNb2RlEk0KEXByZWZlcl9jb2RlY190eXBlGAwgASgOMiEuYmlsaWJpbGkuYXBwLnBsYXl1cmwu'
    'djEuQ29kZVR5cGVSD3ByZWZlckNvZGVjVHlwZRI9CghidXNpbmVzcxgNIAEoDjIhLmJpbGliaW'
    'xpLmFwcC5wbGF5dXJsLnYxLkJ1c2luZXNzUghidXNpbmVzcxIjCg12b2ljZV9iYWxhbmNlGA4g'
    'ASgDUgx2b2ljZUJhbGFuY2U=');

@$core.Deprecated('Use projectReplyDescriptor instead')
const ProjectReply$json = {
  '1': 'ProjectReply',
  '2': [
    {
      '1': 'project',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.PlayURLReply',
      '10': 'project'
    },
  ],
};

/// Descriptor for `ProjectReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List projectReplyDescriptor = $convert.base64Decode(
    'CgxQcm9qZWN0UmVwbHkSPwoHcHJvamVjdBgBIAEoCzIlLmJpbGliaWxpLmFwcC5wbGF5dXJsLn'
    'YxLlBsYXlVUkxSZXBseVIHcHJvamVjdA==');

@$core.Deprecated('Use projectReqDescriptor instead')
const ProjectReq$json = {
  '1': 'ProjectReq',
  '2': [
    {'1': 'aid', '3': 1, '4': 1, '5': 3, '10': 'aid'},
    {'1': 'cid', '3': 2, '4': 1, '5': 3, '10': 'cid'},
    {'1': 'qn', '3': 3, '4': 1, '5': 3, '10': 'qn'},
    {'1': 'fnver', '3': 4, '4': 1, '5': 5, '10': 'fnver'},
    {'1': 'fnval', '3': 5, '4': 1, '5': 5, '10': 'fnval'},
    {'1': 'download', '3': 6, '4': 1, '5': 5, '10': 'download'},
    {'1': 'force_host', '3': 7, '4': 1, '5': 5, '10': 'forceHost'},
    {'1': 'fourk', '3': 8, '4': 1, '5': 8, '10': 'fourk'},
    {'1': 'spmid', '3': 9, '4': 1, '5': 9, '10': 'spmid'},
    {'1': 'from_spmid', '3': 10, '4': 1, '5': 9, '10': 'fromSpmid'},
    {'1': 'protocol', '3': 11, '4': 1, '5': 5, '10': 'protocol'},
    {'1': 'device_type', '3': 12, '4': 1, '5': 5, '10': 'deviceType'},
  ],
};

/// Descriptor for `ProjectReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List projectReqDescriptor = $convert.base64Decode(
    'CgpQcm9qZWN0UmVxEhAKA2FpZBgBIAEoA1IDYWlkEhAKA2NpZBgCIAEoA1IDY2lkEg4KAnFuGA'
    'MgASgDUgJxbhIUCgVmbnZlchgEIAEoBVIFZm52ZXISFAoFZm52YWwYBSABKAVSBWZudmFsEhoK'
    'CGRvd25sb2FkGAYgASgFUghkb3dubG9hZBIdCgpmb3JjZV9ob3N0GAcgASgFUglmb3JjZUhvc3'
    'QSFAoFZm91cmsYCCABKAhSBWZvdXJrEhQKBXNwbWlkGAkgASgJUgVzcG1pZBIdCgpmcm9tX3Nw'
    'bWlkGAogASgJUglmcm9tU3BtaWQSGgoIcHJvdG9jb2wYCyABKAVSCHByb3RvY29sEh8KC2Rldm'
    'ljZV90eXBlGAwgASgFUgpkZXZpY2VUeXBl');

@$core.Deprecated('Use promptBarDescriptor instead')
const PromptBar$json = {
  '1': 'PromptBar',
  '2': [
    {
      '1': 'title',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.TextInfo',
      '10': 'title'
    },
    {
      '1': 'sub_title',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.TextInfo',
      '10': 'subTitle'
    },
    {'1': 'sub_title_icon', '3': 3, '4': 1, '5': 9, '10': 'subTitleIcon'},
    {'1': 'bg_image', '3': 4, '4': 1, '5': 9, '10': 'bgImage'},
    {
      '1': 'button',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ButtonInfo',
      '10': 'button'
    },
    {
      '1': 'report',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.Report',
      '10': 'report'
    },
  ],
};

/// Descriptor for `PromptBar`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List promptBarDescriptor = $convert.base64Decode(
    'CglQcm9tcHRCYXISNwoFdGl0bGUYASABKAsyIS5iaWxpYmlsaS5hcHAucGxheXVybC52MS5UZX'
    'h0SW5mb1IFdGl0bGUSPgoJc3ViX3RpdGxlGAIgASgLMiEuYmlsaWJpbGkuYXBwLnBsYXl1cmwu'
    'djEuVGV4dEluZm9SCHN1YlRpdGxlEiQKDnN1Yl90aXRsZV9pY29uGAMgASgJUgxzdWJUaXRsZU'
    'ljb24SGQoIYmdfaW1hZ2UYBCABKAlSB2JnSW1hZ2USOwoGYnV0dG9uGAUgAygLMiMuYmlsaWJp'
    'bGkuYXBwLnBsYXl1cmwudjEuQnV0dG9uSW5mb1IGYnV0dG9uEjcKBnJlcG9ydBgGIAEoCzIfLm'
    'JpbGliaWxpLmFwcC5wbGF5dXJsLnYxLlJlcG9ydFIGcmVwb3J0');

@$core.Deprecated('Use reportDescriptor instead')
const Report$json = {
  '1': 'Report',
  '2': [
    {'1': 'show_event_id', '3': 1, '4': 1, '5': 9, '10': 'showEventId'},
    {'1': 'click_event_id', '3': 2, '4': 1, '5': 9, '10': 'clickEventId'},
    {'1': 'extends', '3': 3, '4': 1, '5': 9, '10': 'extends'},
  ],
};

/// Descriptor for `Report`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportDescriptor = $convert.base64Decode(
    'CgZSZXBvcnQSIgoNc2hvd19ldmVudF9pZBgBIAEoCVILc2hvd0V2ZW50SWQSJAoOY2xpY2tfZX'
    'ZlbnRfaWQYAiABKAlSDGNsaWNrRXZlbnRJZBIYCgdleHRlbmRzGAMgASgJUgdleHRlbmRz');

@$core.Deprecated('Use responseDashDescriptor instead')
const ResponseDash$json = {
  '1': 'ResponseDash',
  '2': [
    {
      '1': 'video',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.DashItem',
      '10': 'video'
    },
    {
      '1': 'audio',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.DashItem',
      '10': 'audio'
    },
  ],
};

/// Descriptor for `ResponseDash`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseDashDescriptor = $convert.base64Decode(
    'CgxSZXNwb25zZURhc2gSNwoFdmlkZW8YASADKAsyIS5iaWxpYmlsaS5hcHAucGxheXVybC52MS'
    '5EYXNoSXRlbVIFdmlkZW8SNwoFYXVkaW8YAiADKAsyIS5iaWxpYmlsaS5hcHAucGxheXVybC52'
    'MS5EYXNoSXRlbVIFYXVkaW8=');

@$core.Deprecated('Use responseUrlDescriptor instead')
const ResponseUrl$json = {
  '1': 'ResponseUrl',
  '2': [
    {'1': 'order', '3': 1, '4': 1, '5': 5, '10': 'order'},
    {'1': 'length', '3': 2, '4': 1, '5': 3, '10': 'length'},
    {'1': 'size', '3': 3, '4': 1, '5': 3, '10': 'size'},
    {'1': 'url', '3': 4, '4': 1, '5': 9, '10': 'url'},
    {'1': 'backup_url', '3': 5, '4': 3, '5': 9, '10': 'backupUrl'},
    {'1': 'md5', '3': 6, '4': 1, '5': 9, '10': 'md5'},
    {'1': 'quality', '3': 7, '4': 1, '5': 5, '10': 'quality'},
  ],
};

/// Descriptor for `ResponseUrl`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseUrlDescriptor = $convert.base64Decode(
    'CgtSZXNwb25zZVVybBIUCgVvcmRlchgBIAEoBVIFb3JkZXISFgoGbGVuZ3RoGAIgASgDUgZsZW'
    '5ndGgSEgoEc2l6ZRgDIAEoA1IEc2l6ZRIQCgN1cmwYBCABKAlSA3VybBIdCgpiYWNrdXBfdXJs'
    'GAUgAygJUgliYWNrdXBVcmwSEAoDbWQ1GAYgASgJUgNtZDUSGAoHcXVhbGl0eRgHIAEoBVIHcX'
    'VhbGl0eQ==');

@$core.Deprecated('Use schemeDescriptor instead')
const Scheme$json = {
  '1': 'Scheme',
  '2': [
    {
      '1': 'action_type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.playurl.v1.Scheme.ActionType',
      '10': 'actionType'
    },
    {'1': 'toast', '3': 2, '4': 1, '5': 9, '10': 'toast'},
  ],
  '4': [Scheme_ActionType$json],
};

@$core.Deprecated('Use schemeDescriptor instead')
const Scheme_ActionType$json = {
  '1': 'ActionType',
  '2': [
    {'1': 'UNKNOWN_ActionType', '2': 0},
    {'1': 'SHOW_TOAST', '2': 1},
  ],
};

/// Descriptor for `Scheme`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List schemeDescriptor = $convert.base64Decode(
    'CgZTY2hlbWUSSwoLYWN0aW9uX3R5cGUYASABKA4yKi5iaWxpYmlsaS5hcHAucGxheXVybC52MS'
    '5TY2hlbWUuQWN0aW9uVHlwZVIKYWN0aW9uVHlwZRIUCgV0b2FzdBgCIAEoCVIFdG9hc3QiNAoK'
    'QWN0aW9uVHlwZRIWChJVTktOT1dOX0FjdGlvblR5cGUQABIOCgpTSE9XX1RPQVNUEAE=');

@$core.Deprecated('Use segmentVideoDescriptor instead')
const SegmentVideo$json = {
  '1': 'SegmentVideo',
  '2': [
    {
      '1': 'segment',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ResponseUrl',
      '10': 'segment'
    },
  ],
};

/// Descriptor for `SegmentVideo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List segmentVideoDescriptor = $convert.base64Decode(
    'CgxTZWdtZW50VmlkZW8SPgoHc2VnbWVudBgBIAMoCzIkLmJpbGliaWxpLmFwcC5wbGF5dXJsLn'
    'YxLlJlc3BvbnNlVXJsUgdzZWdtZW50');

@$core.Deprecated('Use shakeDescriptor instead')
const Shake$json = {
  '1': 'Shake',
  '2': [
    {'1': 'file', '3': 1, '4': 1, '5': 9, '10': 'file'},
  ],
};

/// Descriptor for `Shake`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shakeDescriptor =
    $convert.base64Decode('CgVTaGFrZRISCgRmaWxlGAEgASgJUgRmaWxl');

@$core.Deprecated('Use streamDescriptor instead')
const Stream$json = {
  '1': 'Stream',
  '2': [
    {
      '1': 'dash_video',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.DashVideo',
      '9': 0,
      '10': 'dashVideo'
    },
    {
      '1': 'segment_video',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.SegmentVideo',
      '9': 0,
      '10': 'segmentVideo'
    },
    {
      '1': 'multi_dash_video',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.MultiDashVideo',
      '9': 0,
      '10': 'multiDashVideo'
    },
    {
      '1': 'stream_info',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.StreamInfo',
      '10': 'streamInfo'
    },
  ],
  '8': [
    {'1': 'content'},
  ],
};

/// Descriptor for `Stream`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamDescriptor = $convert.base64Decode(
    'CgZTdHJlYW0SQwoKZGFzaF92aWRlbxgCIAEoCzIiLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLk'
    'Rhc2hWaWRlb0gAUglkYXNoVmlkZW8STAoNc2VnbWVudF92aWRlbxgDIAEoCzIlLmJpbGliaWxp'
    'LmFwcC5wbGF5dXJsLnYxLlNlZ21lbnRWaWRlb0gAUgxzZWdtZW50VmlkZW8SUwoQbXVsdGlfZG'
    'FzaF92aWRlbxgEIAEoCzInLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLk11bHRpRGFzaFZpZGVv'
    'SABSDm11bHRpRGFzaFZpZGVvEkQKC3N0cmVhbV9pbmZvGAEgASgLMiMuYmlsaWJpbGkuYXBwLn'
    'BsYXl1cmwudjEuU3RyZWFtSW5mb1IKc3RyZWFtSW5mb0IJCgdjb250ZW50');

@$core.Deprecated('Use streamInfoDescriptor instead')
const StreamInfo$json = {
  '1': 'StreamInfo',
  '2': [
    {'1': 'quality', '3': 1, '4': 1, '5': 5, '10': 'quality'},
    {'1': 'format', '3': 2, '4': 1, '5': 9, '10': 'format'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'err_code',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.playurl.v1.PlayErr',
      '10': 'errCode'
    },
    {
      '1': 'limit',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.StreamLimit',
      '10': 'limit'
    },
    {'1': 'need_vip', '3': 6, '4': 1, '5': 8, '10': 'needVip'},
    {'1': 'need_login', '3': 7, '4': 1, '5': 8, '10': 'needLogin'},
    {'1': 'intact', '3': 8, '4': 1, '5': 8, '10': 'intact'},
    {'1': 'no_rexcode', '3': 9, '4': 1, '5': 8, '10': 'noRexcode'},
    {'1': 'attribute', '3': 10, '4': 1, '5': 3, '10': 'attribute'},
    {'1': 'new_description', '3': 11, '4': 1, '5': 9, '10': 'newDescription'},
    {'1': 'display_desc', '3': 12, '4': 1, '5': 9, '10': 'displayDesc'},
    {'1': 'superscript', '3': 13, '4': 1, '5': 9, '10': 'superscript'},
    {'1': 'vip_free', '3': 14, '4': 1, '5': 8, '10': 'vipFree'},
    {'1': 'subtitle', '3': 15, '4': 1, '5': 9, '10': 'subtitle'},
    {
      '1': 'scheme',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.Scheme',
      '10': 'scheme'
    },
    {'1': 'support_drm', '3': 17, '4': 1, '5': 8, '10': 'supportDrm'},
    {'1': 'has_preview', '3': 18, '4': 1, '5': 8, '10': 'hasPreview'},
  ],
};

/// Descriptor for `StreamInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamInfoDescriptor = $convert.base64Decode(
    'CgpTdHJlYW1JbmZvEhgKB3F1YWxpdHkYASABKAVSB3F1YWxpdHkSFgoGZm9ybWF0GAIgASgJUg'
    'Zmb3JtYXQSIAoLZGVzY3JpcHRpb24YAyABKAlSC2Rlc2NyaXB0aW9uEjsKCGVycl9jb2RlGAQg'
    'ASgOMiAuYmlsaWJpbGkuYXBwLnBsYXl1cmwudjEuUGxheUVyclIHZXJyQ29kZRI6CgVsaW1pdB'
    'gFIAEoCzIkLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLlN0cmVhbUxpbWl0UgVsaW1pdBIZCghu'
    'ZWVkX3ZpcBgGIAEoCFIHbmVlZFZpcBIdCgpuZWVkX2xvZ2luGAcgASgIUgluZWVkTG9naW4SFg'
    'oGaW50YWN0GAggASgIUgZpbnRhY3QSHQoKbm9fcmV4Y29kZRgJIAEoCFIJbm9SZXhjb2RlEhwK'
    'CWF0dHJpYnV0ZRgKIAEoA1IJYXR0cmlidXRlEicKD25ld19kZXNjcmlwdGlvbhgLIAEoCVIObm'
    'V3RGVzY3JpcHRpb24SIQoMZGlzcGxheV9kZXNjGAwgASgJUgtkaXNwbGF5RGVzYxIgCgtzdXBl'
    'cnNjcmlwdBgNIAEoCVILc3VwZXJzY3JpcHQSGQoIdmlwX2ZyZWUYDiABKAhSB3ZpcEZyZWUSGg'
    'oIc3VidGl0bGUYDyABKAlSCHN1YnRpdGxlEjcKBnNjaGVtZRgQIAEoCzIfLmJpbGliaWxpLmFw'
    'cC5wbGF5dXJsLnYxLlNjaGVtZVIGc2NoZW1lEh8KC3N1cHBvcnRfZHJtGBEgASgIUgpzdXBwb3'
    'J0RHJtEh8KC2hhc19wcmV2aWV3GBIgASgIUgpoYXNQcmV2aWV3');

@$core.Deprecated('Use streamLimitDescriptor instead')
const StreamLimit$json = {
  '1': 'StreamLimit',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'uri', '3': 2, '4': 1, '5': 9, '10': 'uri'},
    {'1': 'msg', '3': 3, '4': 1, '5': 9, '10': 'msg'},
  ],
};

/// Descriptor for `StreamLimit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamLimitDescriptor = $convert.base64Decode(
    'CgtTdHJlYW1MaW1pdBIUCgV0aXRsZRgBIAEoCVIFdGl0bGUSEAoDdXJpGAIgASgJUgN1cmkSEA'
    'oDbXNnGAMgASgJUgNtc2c=');

@$core.Deprecated('Use textInfoDescriptor instead')
const TextInfo$json = {
  '1': 'TextInfo',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'text_color', '3': 2, '4': 1, '5': 9, '10': 'textColor'},
    {'1': 'text_color_night', '3': 3, '4': 1, '5': 9, '10': 'textColorNight'},
  ],
};

/// Descriptor for `TextInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textInfoDescriptor = $convert.base64Decode(
    'CghUZXh0SW5mbxISCgR0ZXh0GAEgASgJUgR0ZXh0Eh0KCnRleHRfY29sb3IYAiABKAlSCXRleH'
    'RDb2xvchIoChB0ZXh0X2NvbG9yX25pZ2h0GAMgASgJUg50ZXh0Q29sb3JOaWdodA==');

@$core.Deprecated('Use upgradeButtonDescriptor instead')
const UpgradeButton$json = {
  '1': 'UpgradeButton',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'link', '3': 2, '4': 1, '5': 9, '10': 'link'},
  ],
};

/// Descriptor for `UpgradeButton`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upgradeButtonDescriptor = $convert.base64Decode(
    'Cg1VcGdyYWRlQnV0dG9uEhQKBXRpdGxlGAEgASgJUgV0aXRsZRISCgRsaW5rGAIgASgJUgRsaW'
    '5r');

@$core.Deprecated('Use upgradeLimitDescriptor instead')
const UpgradeLimit$json = {
  '1': 'UpgradeLimit',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'image', '3': 3, '4': 1, '5': 9, '10': 'image'},
    {
      '1': 'button',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.UpgradeButton',
      '10': 'button'
    },
  ],
};

/// Descriptor for `UpgradeLimit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List upgradeLimitDescriptor = $convert.base64Decode(
    'CgxVcGdyYWRlTGltaXQSEgoEY29kZRgBIAEoBVIEY29kZRIYCgdtZXNzYWdlGAIgASgJUgdtZX'
    'NzYWdlEhQKBWltYWdlGAMgASgJUgVpbWFnZRI+CgZidXR0b24YBCABKAsyJi5iaWxpYmlsaS5h'
    'cHAucGxheXVybC52MS5VcGdyYWRlQnV0dG9uUgZidXR0b24=');

@$core.Deprecated('Use videoInfoDescriptor instead')
const VideoInfo$json = {
  '1': 'VideoInfo',
  '2': [
    {'1': 'quality', '3': 1, '4': 1, '5': 5, '10': 'quality'},
    {'1': 'format', '3': 2, '4': 1, '5': 9, '10': 'format'},
    {'1': 'timelength', '3': 3, '4': 1, '5': 3, '10': 'timelength'},
    {'1': 'video_codecid', '3': 4, '4': 1, '5': 5, '10': 'videoCodecid'},
    {
      '1': 'stream_list',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.Stream',
      '10': 'streamList'
    },
    {
      '1': 'dash_audio',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.DashItem',
      '10': 'dashAudio'
    },
    {
      '1': 'dolby',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.DolbyItem',
      '10': 'dolby'
    },
    {
      '1': 'volume',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.VolumeInfo',
      '10': 'volume'
    },
    {
      '1': 'loss_less_item',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.LossLessItem',
      '10': 'lossLessItem'
    },
    {'1': 'main_timelength', '3': 10, '4': 1, '5': 3, '10': 'mainTimelength'},
  ],
};

/// Descriptor for `VideoInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoInfoDescriptor = $convert.base64Decode(
    'CglWaWRlb0luZm8SGAoHcXVhbGl0eRgBIAEoBVIHcXVhbGl0eRIWCgZmb3JtYXQYAiABKAlSBm'
    'Zvcm1hdBIeCgp0aW1lbGVuZ3RoGAMgASgDUgp0aW1lbGVuZ3RoEiMKDXZpZGVvX2NvZGVjaWQY'
    'BCABKAVSDHZpZGVvQ29kZWNpZBJACgtzdHJlYW1fbGlzdBgFIAMoCzIfLmJpbGliaWxpLmFwcC'
    '5wbGF5dXJsLnYxLlN0cmVhbVIKc3RyZWFtTGlzdBJACgpkYXNoX2F1ZGlvGAYgAygLMiEuYmls'
    'aWJpbGkuYXBwLnBsYXl1cmwudjEuRGFzaEl0ZW1SCWRhc2hBdWRpbxI4CgVkb2xieRgHIAEoCz'
    'IiLmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLkRvbGJ5SXRlbVIFZG9sYnkSOwoGdm9sdW1lGAgg'
    'ASgLMiMuYmlsaWJpbGkuYXBwLnBsYXl1cmwudjEuVm9sdW1lSW5mb1IGdm9sdW1lEksKDmxvc3'
    'NfbGVzc19pdGVtGAkgASgLMiUuYmlsaWJpbGkuYXBwLnBsYXl1cmwudjEuTG9zc0xlc3NJdGVt'
    'Ugxsb3NzTGVzc0l0ZW0SJwoPbWFpbl90aW1lbGVuZ3RoGAogASgDUg5tYWluVGltZWxlbmd0aA'
    '==');

@$core.Deprecated('Use viewInfoDescriptor instead')
const ViewInfo$json = {
  '1': 'ViewInfo',
  '2': [
    {
      '1': 'dialog_map',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ViewInfo.DialogMapEntry',
      '10': 'dialogMap'
    },
    {
      '1': 'prompt_bar',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.PromptBar',
      '10': 'promptBar'
    },
    {
      '1': 'toasts',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.ComprehensiveToast',
      '10': 'toasts'
    },
  ],
  '3': [ViewInfo_DialogMapEntry$json],
};

@$core.Deprecated('Use viewInfoDescriptor instead')
const ViewInfo_DialogMapEntry$json = {
  '1': 'DialogMapEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.Dialog',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `ViewInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List viewInfoDescriptor = $convert.base64Decode(
    'CghWaWV3SW5mbxJPCgpkaWFsb2dfbWFwGAEgAygLMjAuYmlsaWJpbGkuYXBwLnBsYXl1cmwudj'
    'EuVmlld0luZm8uRGlhbG9nTWFwRW50cnlSCWRpYWxvZ01hcBJBCgpwcm9tcHRfYmFyGAIgASgL'
    'MiIuYmlsaWJpbGkuYXBwLnBsYXl1cmwudjEuUHJvbXB0QmFyUglwcm9tcHRCYXISQwoGdG9hc3'
    'RzGAMgAygLMisuYmlsaWJpbGkuYXBwLnBsYXl1cmwudjEuQ29tcHJlaGVuc2l2ZVRvYXN0UgZ0'
    'b2FzdHMaXQoORGlhbG9nTWFwRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSNQoFdmFsdWUYAiABKA'
    'syHy5iaWxpYmlsaS5hcHAucGxheXVybC52MS5EaWFsb2dSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use vipRiskDescriptor instead')
const VipRisk$json = {
  '1': 'VipRisk',
  '2': [
    {'1': 'allow', '3': 1, '4': 1, '5': 8, '10': 'allow'},
    {'1': 'type', '3': 2, '4': 1, '5': 3, '10': 'type'},
    {'1': 'reason', '3': 3, '4': 1, '5': 3, '10': 'reason'},
    {'1': 'device_status', '3': 4, '4': 1, '5': 3, '10': 'deviceStatus'},
  ],
};

/// Descriptor for `VipRisk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vipRiskDescriptor = $convert.base64Decode(
    'CgdWaXBSaXNrEhQKBWFsbG93GAEgASgIUgVhbGxvdxISCgR0eXBlGAIgASgDUgR0eXBlEhYKBn'
    'JlYXNvbhgDIAEoA1IGcmVhc29uEiMKDWRldmljZV9zdGF0dXMYBCABKANSDGRldmljZVN0YXR1'
    'cw==');

@$core.Deprecated('Use volumeInfoDescriptor instead')
const VolumeInfo$json = {
  '1': 'VolumeInfo',
  '2': [
    {'1': 'measured_i', '3': 1, '4': 1, '5': 1, '10': 'measuredI'},
    {'1': 'measured_lra', '3': 2, '4': 1, '5': 1, '10': 'measuredLra'},
    {'1': 'measured_tp', '3': 3, '4': 1, '5': 1, '10': 'measuredTp'},
    {
      '1': 'measured_threshold',
      '3': 4,
      '4': 1,
      '5': 1,
      '10': 'measuredThreshold'
    },
    {'1': 'target_offset', '3': 5, '4': 1, '5': 1, '10': 'targetOffset'},
    {'1': 'target_i', '3': 6, '4': 1, '5': 1, '10': 'targetI'},
    {'1': 'target_tp', '3': 7, '4': 1, '5': 1, '10': 'targetTp'},
    {
      '1': 'multi_scene_args',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.playurl.v1.VolumeInfo.MultiSceneArgsEntry',
      '10': 'multiSceneArgs'
    },
  ],
  '3': [VolumeInfo_MultiSceneArgsEntry$json],
};

@$core.Deprecated('Use volumeInfoDescriptor instead')
const VolumeInfo_MultiSceneArgsEntry$json = {
  '1': 'MultiSceneArgsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `VolumeInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List volumeInfoDescriptor = $convert.base64Decode(
    'CgpWb2x1bWVJbmZvEh0KCm1lYXN1cmVkX2kYASABKAFSCW1lYXN1cmVkSRIhCgxtZWFzdXJlZF'
    '9scmEYAiABKAFSC21lYXN1cmVkTHJhEh8KC21lYXN1cmVkX3RwGAMgASgBUgptZWFzdXJlZFRw'
    'Ei0KEm1lYXN1cmVkX3RocmVzaG9sZBgEIAEoAVIRbWVhc3VyZWRUaHJlc2hvbGQSIwoNdGFyZ2'
    'V0X29mZnNldBgFIAEoAVIMdGFyZ2V0T2Zmc2V0EhkKCHRhcmdldF9pGAYgASgBUgd0YXJnZXRJ'
    'EhsKCXRhcmdldF90cBgHIAEoAVIIdGFyZ2V0VHASYQoQbXVsdGlfc2NlbmVfYXJncxgIIAMoCz'
    'I3LmJpbGliaWxpLmFwcC5wbGF5dXJsLnYxLlZvbHVtZUluZm8uTXVsdGlTY2VuZUFyZ3NFbnRy'
    'eVIObXVsdGlTY2VuZUFyZ3MaQQoTTXVsdGlTY2VuZUFyZ3NFbnRyeRIQCgNrZXkYASABKAlSA2'
    'tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');
