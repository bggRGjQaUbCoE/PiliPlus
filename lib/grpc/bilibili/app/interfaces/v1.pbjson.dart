// This is a generated file - do not edit.
//
// Generated from bilibili/app/interfaces/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use butTypeDescriptor instead')
const ButType$json = {
  '1': 'ButType',
  '2': [
    {'1': 'BUT_INVALID', '2': 0},
    {'1': 'BUT_REDIRECT', '2': 1},
    {'1': 'BUT_LIKE', '2': 2},
  ],
};

/// Descriptor for `ButType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List butTypeDescriptor = $convert.base64Decode(
    'CgdCdXRUeXBlEg8KC0JVVF9JTlZBTElEEAASEAoMQlVUX1JFRElSRUNUEAESDAoIQlVUX0xJS0'
    'UQAg==');

@$core.Deprecated('Use commentTypeDescriptor instead')
const CommentType$json = {
  '1': 'CommentType',
  '2': [
    {'1': 'comment_type_none', '2': 0},
    {'1': 'comment_type_redirect', '2': 1},
    {'1': 'comment_type_judge', '2': 2},
  ],
};

/// Descriptor for `CommentType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List commentTypeDescriptor = $convert.base64Decode(
    'CgtDb21tZW50VHlwZRIVChFjb21tZW50X3R5cGVfbm9uZRAAEhkKFWNvbW1lbnRfdHlwZV9yZW'
    'RpcmVjdBABEhYKEmNvbW1lbnRfdHlwZV9qdWRnZRAC');

@$core.Deprecated('Use dTDescriptor instead')
const DT$json = {
  '1': 'DT',
  '2': [
    {'1': 'Unknown', '2': 0},
    {'1': 'Phone', '2': 1},
    {'1': 'Pad', '2': 2},
    {'1': 'PC', '2': 3},
    {'1': 'TV', '2': 4},
    {'1': 'Car', '2': 5},
    {'1': 'Iot', '2': 6},
    {'1': 'AndPad', '2': 7},
  ],
};

/// Descriptor for `DT`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List dTDescriptor = $convert.base64Decode(
    'CgJEVBILCgdVbmtub3duEAASCQoFUGhvbmUQARIHCgNQYWQQAhIGCgJQQxADEgYKAlRWEAQSBw'
    'oDQ2FyEAUSBwoDSW90EAYSCgoGQW5kUGFkEAc=');

@$core.Deprecated('Use facialRecognitionVerifyFromDescriptor instead')
const FacialRecognitionVerifyFrom$json = {
  '1': 'FacialRecognitionVerifyFrom',
  '2': [
    {'1': 'VerifyUnknownFrom', '2': 0},
    {'1': 'VerifyFromGuardian', '2': 1},
    {'1': 'VerifyFromAppeal', '2': 2},
  ],
};

/// Descriptor for `FacialRecognitionVerifyFrom`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List facialRecognitionVerifyFromDescriptor =
    $convert.base64Decode(
        'ChtGYWNpYWxSZWNvZ25pdGlvblZlcmlmeUZyb20SFQoRVmVyaWZ5VW5rbm93bkZyb20QABIWCh'
        'JWZXJpZnlGcm9tR3VhcmRpYW4QARIUChBWZXJpZnlGcm9tQXBwZWFsEAI=');

@$core.Deprecated('Use fromDescriptor instead')
const From$json = {
  '1': 'From',
  '2': [
    {'1': 'ArchiveTab', '2': 0},
    {'1': 'DynamicTab', '2': 1},
  ],
};

/// Descriptor for `From`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List fromDescriptor = $convert
    .base64Decode('CgRGcm9tEg4KCkFyY2hpdmVUYWIQABIOCgpEeW5hbWljVGFiEAE=');

@$core.Deprecated('Use historySourceDescriptor instead')
const HistorySource$json = {
  '1': 'HistorySource',
  '2': [
    {'1': 'history', '2': 0},
    {'1': 'shopping', '2': 1},
  ],
};

/// Descriptor for `HistorySource`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List historySourceDescriptor = $convert
    .base64Decode('Cg1IaXN0b3J5U291cmNlEgsKB2hpc3RvcnkQABIMCghzaG9wcGluZxAB');

@$core.Deprecated('Use modelStatusDescriptor instead')
const ModelStatus$json = {
  '1': 'ModelStatus',
  '2': [
    {'1': 'CloseStatus', '2': 0},
    {'1': 'OpenStatus', '2': 1},
    {'1': 'NotSetStatus', '2': 2},
  ],
};

/// Descriptor for `ModelStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List modelStatusDescriptor = $convert.base64Decode(
    'CgtNb2RlbFN0YXR1cxIPCgtDbG9zZVN0YXR1cxAAEg4KCk9wZW5TdGF0dXMQARIQCgxOb3RTZX'
    'RTdGF0dXMQAg==');

@$core.Deprecated('Use pwdFromDescriptor instead')
const PwdFrom$json = {
  '1': 'PwdFrom',
  '2': [
    {'1': 'UnknownFrom', '2': 0},
    {'1': 'TeenagersAntiAddictionFrom', '2': 1},
    {'1': 'TeenagersCurfewFrom', '2': 2},
    {'1': 'TeenagersLoginFrom', '2': 3},
    {'1': 'TeenagersLogOutFrom', '2': 4},
    {'1': 'FamilyAntiAddictionFrom', '2': 5},
    {'1': 'FamilyCurfewFrom', '2': 6},
    {'1': 'FamilyLogOutFrom', '2': 7},
    {'1': 'FamilyTimeLockFrom', '2': 8},
    {'1': 'TeenagersQuitPwdFrom', '2': 9},
    {'1': 'TeenagersModifyPwdFrom', '2': 10},
    {'1': 'FamilyQuitFrom', '2': 11},
    {'1': 'OSTeenagersLogin', '2': 12},
    {'1': 'OSTeenagersLogout', '2': 13},
    {'1': 'TeenagersSetAge', '2': 14},
    {'1': 'OSTeenagersSetAge', '2': 15},
  ],
};

/// Descriptor for `PwdFrom`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List pwdFromDescriptor = $convert.base64Decode(
    'CgdQd2RGcm9tEg8KC1Vua25vd25Gcm9tEAASHgoaVGVlbmFnZXJzQW50aUFkZGljdGlvbkZyb2'
    '0QARIXChNUZWVuYWdlcnNDdXJmZXdGcm9tEAISFgoSVGVlbmFnZXJzTG9naW5Gcm9tEAMSFwoT'
    'VGVlbmFnZXJzTG9nT3V0RnJvbRAEEhsKF0ZhbWlseUFudGlBZGRpY3Rpb25Gcm9tEAUSFAoQRm'
    'FtaWx5Q3VyZmV3RnJvbRAGEhQKEEZhbWlseUxvZ091dEZyb20QBxIWChJGYW1pbHlUaW1lTG9j'
    'a0Zyb20QCBIYChRUZWVuYWdlcnNRdWl0UHdkRnJvbRAJEhoKFlRlZW5hZ2Vyc01vZGlmeVB3ZE'
    'Zyb20QChISCg5GYW1pbHlRdWl0RnJvbRALEhQKEE9TVGVlbmFnZXJzTG9naW4QDBIVChFPU1Rl'
    'ZW5hZ2Vyc0xvZ291dBANEhMKD1RlZW5hZ2Vyc1NldEFnZRAOEhUKEU9TVGVlbmFnZXJzU2V0QW'
    'dlEA8=');

@$core.Deprecated('Use tabTypeDescriptor instead')
const TabType$json = {
  '1': 'TabType',
  '2': [
    {'1': 'TAB_INVALID', '2': 0},
    {'1': 'TAB_OGV_DETAIL', '2': 6},
    {'1': 'TAB_OGV_REPLY', '2': 7},
    {'1': 'TAB_FEED_BID', '2': 8},
    {'1': 'TAB_FEED_SMALL', '2': 9},
  ],
};

/// Descriptor for `TabType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List tabTypeDescriptor = $convert.base64Decode(
    'CgdUYWJUeXBlEg8KC1RBQl9JTlZBTElEEAASEgoOVEFCX09HVl9ERVRBSUwQBhIRCg1UQUJfT0'
    'dWX1JFUExZEAcSEAoMVEFCX0ZFRURfQklEEAgSEgoOVEFCX0ZFRURfU01BTEwQCQ==');

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
    {'1': 'icon_type', '3': 4, '4': 1, '5': 3, '10': 'iconType'},
    {'1': 'cover_icon', '3': 5, '4': 1, '5': 9, '10': 'coverIcon'},
    {'1': 'is_fold', '3': 6, '4': 1, '5': 8, '10': 'isFold'},
    {'1': 'is_pugv', '3': 7, '4': 1, '5': 8, '10': 'isPugv'},
    {'1': 'publish_time_text', '3': 8, '4': 1, '5': 9, '10': 'publishTimeText'},
    {'1': 'badges', '3': 9, '4': 3, '5': 9, '10': 'badges'},
    {'1': 'is_oneself', '3': 10, '4': 1, '5': 8, '10': 'isOneself'},
  ],
};

/// Descriptor for `Arc`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List arcDescriptor = $convert.base64Decode(
    'CgNBcmMSNgoHYXJjaGl2ZRgBIAEoCzIcLmJpbGliaWxpLmFwcC5hcmNoaXZlLnYxLkFyY1IHYX'
    'JjaGl2ZRIQCgN1cmkYAiABKAlSA3VyaRIhCgx2aWV3X2NvbnRlbnQYAyABKAlSC3ZpZXdDb250'
    'ZW50EhsKCWljb25fdHlwZRgEIAEoA1IIaWNvblR5cGUSHQoKY292ZXJfaWNvbhgFIAEoCVIJY2'
    '92ZXJJY29uEhcKB2lzX2ZvbGQYBiABKAhSBmlzRm9sZBIXCgdpc19wdWd2GAcgASgIUgZpc1B1'
    'Z3YSKgoRcHVibGlzaF90aW1lX3RleHQYCCABKAlSD3B1Ymxpc2hUaW1lVGV4dBIWCgZiYWRnZX'
    'MYCSADKAlSBmJhZGdlcxIdCgppc19vbmVzZWxmGAogASgIUglpc09uZXNlbGY=');

@$core.Deprecated('Use badgeDescriptor instead')
const Badge$json = {
  '1': 'Badge',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'icon', '3': 2, '4': 1, '5': 9, '10': 'icon'},
  ],
};

/// Descriptor for `Badge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List badgeDescriptor = $convert.base64Decode(
    'CgVCYWRnZRISCgR0ZXh0GAEgASgJUgR0ZXh0EhIKBGljb24YAiABKAlSBGljb24=');

@$core.Deprecated('Use bigItemDescriptor instead')
const BigItem$json = {
  '1': 'BigItem',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'cover_image_uri', '3': 2, '4': 1, '5': 9, '10': 'coverImageUri'},
    {'1': 'uri', '3': 3, '4': 1, '5': 9, '10': 'uri'},
    {'1': 'cover_right_text', '3': 4, '4': 1, '5': 9, '10': 'coverRightText'},
    {'1': 'cover_left_text1', '3': 5, '4': 1, '5': 9, '10': 'coverLeftText1'},
    {'1': 'cover_left_icon1', '3': 6, '4': 1, '5': 3, '10': 'coverLeftIcon1'},
    {'1': 'cover_left_text2', '3': 7, '4': 1, '5': 9, '10': 'coverLeftText2'},
    {'1': 'cover_left_icon2', '3': 8, '4': 1, '5': 3, '10': 'coverLeftIcon2'},
    {
      '1': 'user_card',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.UserCard',
      '10': 'userCard'
    },
    {
      '1': 'like_button',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.LikeButton',
      '10': 'likeButton'
    },
    {'1': 'param', '3': 11, '4': 1, '5': 3, '10': 'param'},
    {
      '1': 'share_plane',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.SharePlane',
      '10': 'sharePlane'
    },
    {
      '1': 'three_point_meta',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.PanelMeta',
      '10': 'threePointMeta'
    },
    {
      '1': 'inline_progress_bar',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.card.v1.InlineProgressBar',
      '10': 'inlineProgressBar'
    },
    {'1': 'can_play', '3': 15, '4': 1, '5': 5, '10': 'canPlay'},
    {
      '1': 'player_args',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.archive.middleware.v1.PlayerArgs',
      '10': 'playerArgs'
    },
    {'1': 'is_fav', '3': 17, '4': 1, '5': 8, '10': 'isFav'},
  ],
};

/// Descriptor for `BigItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bigItemDescriptor = $convert.base64Decode(
    'CgdCaWdJdGVtEhQKBXRpdGxlGAEgASgJUgV0aXRsZRImCg9jb3Zlcl9pbWFnZV91cmkYAiABKA'
    'lSDWNvdmVySW1hZ2VVcmkSEAoDdXJpGAMgASgJUgN1cmkSKAoQY292ZXJfcmlnaHRfdGV4dBgE'
    'IAEoCVIOY292ZXJSaWdodFRleHQSKAoQY292ZXJfbGVmdF90ZXh0MRgFIAEoCVIOY292ZXJMZW'
    'Z0VGV4dDESKAoQY292ZXJfbGVmdF9pY29uMRgGIAEoA1IOY292ZXJMZWZ0SWNvbjESKAoQY292'
    'ZXJfbGVmdF90ZXh0MhgHIAEoCVIOY292ZXJMZWZ0VGV4dDISKAoQY292ZXJfbGVmdF9pY29uMh'
    'gIIAEoA1IOY292ZXJMZWZ0SWNvbjISQQoJdXNlcl9jYXJkGAkgASgLMiQuYmlsaWJpbGkuYXBw'
    'LmludGVyZmFjZXMudjEuVXNlckNhcmRSCHVzZXJDYXJkEkcKC2xpa2VfYnV0dG9uGAogASgLMi'
    'YuYmlsaWJpbGkuYXBwLmludGVyZmFjZXMudjEuTGlrZUJ1dHRvblIKbGlrZUJ1dHRvbhIUCgVw'
    'YXJhbRgLIAEoA1IFcGFyYW0SQQoLc2hhcmVfcGxhbmUYDCABKAsyIC5iaWxpYmlsaS5hcHAuY2'
    'FyZC52MS5TaGFyZVBsYW5lUgpzaGFyZVBsYW5lEkkKEHRocmVlX3BvaW50X21ldGEYDSABKAsy'
    'Hy5iaWxpYmlsaS5hcHAuY2FyZC52MS5QYW5lbE1ldGFSDnRocmVlUG9pbnRNZXRhElcKE2lubG'
    'luZV9wcm9ncmVzc19iYXIYDiABKAsyJy5iaWxpYmlsaS5hcHAuY2FyZC52MS5JbmxpbmVQcm9n'
    'cmVzc0JhclIRaW5saW5lUHJvZ3Jlc3NCYXISGQoIY2FuX3BsYXkYDyABKAVSB2NhblBsYXkSTw'
    'oLcGxheWVyX2FyZ3MYECABKAsyLi5iaWxpYmlsaS5hcHAuYXJjaGl2ZS5taWRkbGV3YXJlLnYx'
    'LlBsYXllckFyZ3NSCnBsYXllckFyZ3MSFQoGaXNfZmF2GBEgASgIUgVpc0Zhdg==');

@$core.Deprecated('Use buttonDescriptor instead')
const Button$json = {
  '1': 'Button',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'link', '3': 2, '4': 1, '5': 9, '10': 'link'},
    {'1': 'id', '3': 3, '4': 1, '5': 9, '10': 'id'},
    {'1': 'icon', '3': 4, '4': 1, '5': 3, '10': 'icon'},
    {
      '1': 'but_type',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.interfaces.v1.ButType',
      '10': 'butType'
    },
    {'1': 'follow_state', '3': 6, '4': 1, '5': 5, '10': 'followState'},
    {'1': 'has_title', '3': 7, '4': 1, '5': 9, '10': 'hasTitle'},
  ],
};

/// Descriptor for `Button`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List buttonDescriptor = $convert.base64Decode(
    'CgZCdXR0b24SFAoFdGl0bGUYASABKAlSBXRpdGxlEhIKBGxpbmsYAiABKAlSBGxpbmsSDgoCaW'
    'QYAyABKAlSAmlkEhIKBGljb24YBCABKANSBGljb24SPgoIYnV0X3R5cGUYBSABKA4yIy5iaWxp'
    'YmlsaS5hcHAuaW50ZXJmYWNlcy52MS5CdXRUeXBlUgdidXRUeXBlEiEKDGZvbGxvd19zdGF0ZR'
    'gGIAEoBVILZm9sbG93U3RhdGUSGwoJaGFzX3RpdGxlGAcgASgJUghoYXNUaXRsZQ==');

@$core.Deprecated('Use cardArticleDescriptor instead')
const CardArticle$json = {
  '1': 'CardArticle',
  '2': [
    {'1': 'covers', '3': 1, '4': 3, '5': 9, '10': 'covers'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'mid', '3': 3, '4': 1, '5': 3, '10': 'mid'},
    {
      '1': 'display_attention',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'displayAttention'
    },
    {'1': 'badge', '3': 5, '4': 1, '5': 9, '10': 'badge'},
    {
      '1': 'relation',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.Relation',
      '10': 'relation'
    },
  ],
};

/// Descriptor for `CardArticle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cardArticleDescriptor = $convert.base64Decode(
    'CgtDYXJkQXJ0aWNsZRIWCgZjb3ZlcnMYASADKAlSBmNvdmVycxISCgRuYW1lGAIgASgJUgRuYW'
    '1lEhAKA21pZBgDIAEoA1IDbWlkEisKEWRpc3BsYXlfYXR0ZW50aW9uGAQgASgIUhBkaXNwbGF5'
    'QXR0ZW50aW9uEhQKBWJhZGdlGAUgASgJUgViYWRnZRJACghyZWxhdGlvbhgGIAEoCzIkLmJpbG'
    'liaWxpLmFwcC5pbnRlcmZhY2VzLnYxLlJlbGF0aW9uUghyZWxhdGlvbg==');

@$core.Deprecated('Use cardCheeseDescriptor instead')
const CardCheese$json = {
  '1': 'CardCheese',
  '2': [
    {'1': 'cover', '3': 1, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'progress', '3': 2, '4': 1, '5': 3, '10': 'progress'},
    {'1': 'duration', '3': 3, '4': 1, '5': 3, '10': 'duration'},
    {'1': 'subtitle', '3': 4, '4': 1, '5': 9, '10': 'subtitle'},
    {'1': 'state', '3': 5, '4': 1, '5': 3, '10': 'state'},
  ],
};

/// Descriptor for `CardCheese`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cardCheeseDescriptor = $convert.base64Decode(
    'CgpDYXJkQ2hlZXNlEhQKBWNvdmVyGAEgASgJUgVjb3ZlchIaCghwcm9ncmVzcxgCIAEoA1IIcH'
    'JvZ3Jlc3MSGgoIZHVyYXRpb24YAyABKANSCGR1cmF0aW9uEhoKCHN1YnRpdGxlGAQgASgJUghz'
    'dWJ0aXRsZRIUCgVzdGF0ZRgFIAEoA1IFc3RhdGU=');

@$core.Deprecated('Use cardLiveDescriptor instead')
const CardLive$json = {
  '1': 'CardLive',
  '2': [
    {'1': 'cover', '3': 1, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'mid', '3': 3, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'tag', '3': 4, '4': 1, '5': 9, '10': 'tag'},
    {'1': 'status', '3': 5, '4': 1, '5': 5, '10': 'status'},
    {
      '1': 'display_attention',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'displayAttention'
    },
    {
      '1': 'relation',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.Relation',
      '10': 'relation'
    },
  ],
};

/// Descriptor for `CardLive`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cardLiveDescriptor = $convert.base64Decode(
    'CghDYXJkTGl2ZRIUCgVjb3ZlchgBIAEoCVIFY292ZXISEgoEbmFtZRgCIAEoCVIEbmFtZRIQCg'
    'NtaWQYAyABKANSA21pZBIQCgN0YWcYBCABKAlSA3RhZxIWCgZzdGF0dXMYBSABKAVSBnN0YXR1'
    'cxIrChFkaXNwbGF5X2F0dGVudGlvbhgGIAEoCFIQZGlzcGxheUF0dGVudGlvbhJACghyZWxhdG'
    'lvbhgHIAEoCzIkLmJpbGliaWxpLmFwcC5pbnRlcmZhY2VzLnYxLlJlbGF0aW9uUghyZWxhdGlv'
    'bg==');

@$core.Deprecated('Use cardOGVDescriptor instead')
const CardOGV$json = {
  '1': 'CardOGV',
  '2': [
    {'1': 'cover', '3': 1, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'progress', '3': 2, '4': 1, '5': 3, '10': 'progress'},
    {'1': 'duration', '3': 3, '4': 1, '5': 3, '10': 'duration'},
    {'1': 'subtitle', '3': 4, '4': 1, '5': 9, '10': 'subtitle'},
    {'1': 'badge', '3': 5, '4': 1, '5': 9, '10': 'badge'},
    {'1': 'state', '3': 6, '4': 1, '5': 3, '10': 'state'},
  ],
};

/// Descriptor for `CardOGV`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cardOGVDescriptor = $convert.base64Decode(
    'CgdDYXJkT0dWEhQKBWNvdmVyGAEgASgJUgVjb3ZlchIaCghwcm9ncmVzcxgCIAEoA1IIcHJvZ3'
    'Jlc3MSGgoIZHVyYXRpb24YAyABKANSCGR1cmF0aW9uEhoKCHN1YnRpdGxlGAQgASgJUghzdWJ0'
    'aXRsZRIUCgViYWRnZRgFIAEoCVIFYmFkZ2USFAoFc3RhdGUYBiABKANSBXN0YXRl');

@$core.Deprecated('Use cardUGCDescriptor instead')
const CardUGC$json = {
  '1': 'CardUGC',
  '2': [
    {'1': 'cover', '3': 1, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'progress', '3': 2, '4': 1, '5': 3, '10': 'progress'},
    {'1': 'duration', '3': 3, '4': 1, '5': 3, '10': 'duration'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'mid', '3': 5, '4': 1, '5': 3, '10': 'mid'},
    {
      '1': 'display_attention',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'displayAttention'
    },
    {'1': 'cid', '3': 7, '4': 1, '5': 3, '10': 'cid'},
    {'1': 'page', '3': 8, '4': 1, '5': 5, '10': 'page'},
    {'1': 'subtitle', '3': 9, '4': 1, '5': 9, '10': 'subtitle'},
    {
      '1': 'relation',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.Relation',
      '10': 'relation'
    },
    {'1': 'bvid', '3': 11, '4': 1, '5': 9, '10': 'bvid'},
    {'1': 'videos', '3': 12, '4': 1, '5': 3, '10': 'videos'},
    {'1': 'short_link', '3': 13, '4': 1, '5': 9, '10': 'shortLink'},
    {'1': 'share_subtitle', '3': 14, '4': 1, '5': 9, '10': 'shareSubtitle'},
    {'1': 'view', '3': 15, '4': 1, '5': 3, '10': 'view'},
    {'1': 'state', '3': 16, '4': 1, '5': 3, '10': 'state'},
    {'1': 'badge', '3': 17, '4': 1, '5': 9, '10': 'badge'},
    {
      '1': 'badge_v2',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.Badge',
      '10': 'badgeV2'
    },
  ],
};

/// Descriptor for `CardUGC`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cardUGCDescriptor = $convert.base64Decode(
    'CgdDYXJkVUdDEhQKBWNvdmVyGAEgASgJUgVjb3ZlchIaCghwcm9ncmVzcxgCIAEoA1IIcHJvZ3'
    'Jlc3MSGgoIZHVyYXRpb24YAyABKANSCGR1cmF0aW9uEhIKBG5hbWUYBCABKAlSBG5hbWUSEAoD'
    'bWlkGAUgASgDUgNtaWQSKwoRZGlzcGxheV9hdHRlbnRpb24YBiABKAhSEGRpc3BsYXlBdHRlbn'
    'Rpb24SEAoDY2lkGAcgASgDUgNjaWQSEgoEcGFnZRgIIAEoBVIEcGFnZRIaCghzdWJ0aXRsZRgJ'
    'IAEoCVIIc3VidGl0bGUSQAoIcmVsYXRpb24YCiABKAsyJC5iaWxpYmlsaS5hcHAuaW50ZXJmYW'
    'Nlcy52MS5SZWxhdGlvblIIcmVsYXRpb24SEgoEYnZpZBgLIAEoCVIEYnZpZBIWCgZ2aWRlb3MY'
    'DCABKANSBnZpZGVvcxIdCgpzaG9ydF9saW5rGA0gASgJUglzaG9ydExpbmsSJQoOc2hhcmVfc3'
    'VidGl0bGUYDiABKAlSDXNoYXJlU3VidGl0bGUSEgoEdmlldxgPIAEoA1IEdmlldxIUCgVzdGF0'
    'ZRgQIAEoA1IFc3RhdGUSFAoFYmFkZ2UYESABKAlSBWJhZGdlEjwKCGJhZGdlX3YyGBIgASgLMi'
    'EuYmlsaWJpbGkuYXBwLmludGVyZmFjZXMudjEuQmFkZ2VSB2JhZGdlVjI=');

@$core.Deprecated('Use castDescriptor instead')
const Cast$json = {
  '1': 'Cast',
  '2': [
    {
      '1': 'person',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.MediaPerson',
      '10': 'person'
    },
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
  ],
};

/// Descriptor for `Cast`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List castDescriptor = $convert.base64Decode(
    'CgRDYXN0Ej8KBnBlcnNvbhgBIAMoCzInLmJpbGliaWxpLmFwcC5pbnRlcmZhY2VzLnYxLk1lZG'
    'lhUGVyc29uUgZwZXJzb24SFAoFdGl0bGUYAiABKAlSBXRpdGxl');

@$core.Deprecated('Use channelInfoDescriptor instead')
const ChannelInfo$json = {
  '1': 'ChannelInfo',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 3, '10': 'channelId'},
    {'1': 'subscribed', '3': 2, '4': 1, '5': 8, '10': 'subscribed'},
  ],
};

/// Descriptor for `ChannelInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List channelInfoDescriptor = $convert.base64Decode(
    'CgtDaGFubmVsSW5mbxIdCgpjaGFubmVsX2lkGAEgASgDUgljaGFubmVsSWQSHgoKc3Vic2NyaW'
    'JlZBgCIAEoCFIKc3Vic2NyaWJlZA==');

@$core.Deprecated('Use clearReqDescriptor instead')
const ClearReq$json = {
  '1': 'ClearReq',
  '2': [
    {'1': 'business', '3': 1, '4': 1, '5': 9, '10': 'business'},
  ],
};

/// Descriptor for `ClearReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearReqDescriptor = $convert
    .base64Decode('CghDbGVhclJlcRIaCghidXNpbmVzcxgBIAEoCVIIYnVzaW5lc3M=');

@$core.Deprecated('Use commentItemDescriptor instead')
const CommentItem$json = {
  '1': 'CommentItem',
  '2': [
    {'1': 'icon', '3': 1, '4': 1, '5': 9, '10': 'icon'},
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.interfaces.v1.CommentType',
      '10': 'type'
    },
    {'1': 'action_type', '3': 5, '4': 1, '5': 9, '10': 'actionType'},
    {'1': 'id', '3': 6, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `CommentItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commentItemDescriptor = $convert.base64Decode(
    'CgtDb21tZW50SXRlbRISCgRpY29uGAEgASgJUgRpY29uEhAKA3VybBgCIAEoCVIDdXJsEhQKBX'
    'RpdGxlGAMgASgJUgV0aXRsZRI7CgR0eXBlGAQgASgOMicuYmlsaWJpbGkuYXBwLmludGVyZmFj'
    'ZXMudjEuQ29tbWVudFR5cGVSBHR5cGUSHwoLYWN0aW9uX3R5cGUYBSABKAlSCmFjdGlvblR5cG'
    'USDgoCaWQYBiABKAlSAmlk');

@$core.Deprecated('Use cursorDescriptor instead')
const Cursor$json = {
  '1': 'Cursor',
  '2': [
    {'1': 'max', '3': 1, '4': 1, '5': 3, '10': 'max'},
    {'1': 'max_tp', '3': 2, '4': 1, '5': 5, '10': 'maxTp'},
  ],
};

/// Descriptor for `Cursor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cursorDescriptor = $convert.base64Decode(
    'CgZDdXJzb3ISEAoDbWF4GAEgASgDUgNtYXgSFQoGbWF4X3RwGAIgASgFUgVtYXhUcA==');

@$core.Deprecated('Use cursorItemDescriptor instead')
const CursorItem$json = {
  '1': 'CursorItem',
  '2': [
    {
      '1': 'card_ugc',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.CardUGC',
      '9': 0,
      '10': 'cardUgc'
    },
    {
      '1': 'card_ogv',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.CardOGV',
      '9': 0,
      '10': 'cardOgv'
    },
    {
      '1': 'card_article',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.CardArticle',
      '9': 0,
      '10': 'cardArticle'
    },
    {
      '1': 'card_live',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.CardLive',
      '9': 0,
      '10': 'cardLive'
    },
    {
      '1': 'card_cheese',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.CardCheese',
      '9': 0,
      '10': 'cardCheese'
    },
    {'1': 'title', '3': 6, '4': 1, '5': 9, '10': 'title'},
    {'1': 'uri', '3': 7, '4': 1, '5': 9, '10': 'uri'},
    {'1': 'view_at', '3': 8, '4': 1, '5': 3, '10': 'viewAt'},
    {'1': 'kid', '3': 9, '4': 1, '5': 3, '10': 'kid'},
    {'1': 'oid', '3': 10, '4': 1, '5': 3, '10': 'oid'},
    {'1': 'business', '3': 11, '4': 1, '5': 9, '10': 'business'},
    {'1': 'tp', '3': 12, '4': 1, '5': 5, '10': 'tp'},
    {
      '1': 'dt',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.DeviceType',
      '10': 'dt'
    },
    {'1': 'has_share', '3': 14, '4': 1, '5': 8, '10': 'hasShare'},
    {'1': 'report', '3': 15, '4': 1, '5': 9, '10': 'report'},
  ],
  '8': [
    {'1': 'card_item'},
  ],
};

/// Descriptor for `CursorItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cursorItemDescriptor = $convert.base64Decode(
    'CgpDdXJzb3JJdGVtEkAKCGNhcmRfdWdjGAEgASgLMiMuYmlsaWJpbGkuYXBwLmludGVyZmFjZX'
    'MudjEuQ2FyZFVHQ0gAUgdjYXJkVWdjEkAKCGNhcmRfb2d2GAIgASgLMiMuYmlsaWJpbGkuYXBw'
    'LmludGVyZmFjZXMudjEuQ2FyZE9HVkgAUgdjYXJkT2d2EkwKDGNhcmRfYXJ0aWNsZRgDIAEoCz'
    'InLmJpbGliaWxpLmFwcC5pbnRlcmZhY2VzLnYxLkNhcmRBcnRpY2xlSABSC2NhcmRBcnRpY2xl'
    'EkMKCWNhcmRfbGl2ZRgEIAEoCzIkLmJpbGliaWxpLmFwcC5pbnRlcmZhY2VzLnYxLkNhcmRMaX'
    'ZlSABSCGNhcmRMaXZlEkkKC2NhcmRfY2hlZXNlGAUgASgLMiYuYmlsaWJpbGkuYXBwLmludGVy'
    'ZmFjZXMudjEuQ2FyZENoZWVzZUgAUgpjYXJkQ2hlZXNlEhQKBXRpdGxlGAYgASgJUgV0aXRsZR'
    'IQCgN1cmkYByABKAlSA3VyaRIXCgd2aWV3X2F0GAggASgDUgZ2aWV3QXQSEAoDa2lkGAkgASgD'
    'UgNraWQSEAoDb2lkGAogASgDUgNvaWQSGgoIYnVzaW5lc3MYCyABKAlSCGJ1c2luZXNzEg4KAn'
    'RwGAwgASgFUgJ0cBI2CgJkdBgNIAEoCzImLmJpbGliaWxpLmFwcC5pbnRlcmZhY2VzLnYxLkRl'
    'dmljZVR5cGVSAmR0EhsKCWhhc19zaGFyZRgOIAEoCFIIaGFzU2hhcmUSFgoGcmVwb3J0GA8gAS'
    'gJUgZyZXBvcnRCCwoJY2FyZF9pdGVt');

@$core.Deprecated('Use cursorReplyDescriptor instead')
const CursorReply$json = {
  '1': 'CursorReply',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.CursorItem',
      '10': 'items'
    },
    {
      '1': 'tab',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.CursorTab',
      '10': 'tab'
    },
    {
      '1': 'cursor',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.Cursor',
      '10': 'cursor'
    },
    {'1': 'has_more', '3': 4, '4': 1, '5': 8, '10': 'hasMore'},
  ],
};

/// Descriptor for `CursorReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cursorReplyDescriptor = $convert.base64Decode(
    'CgtDdXJzb3JSZXBseRI8CgVpdGVtcxgBIAMoCzImLmJpbGliaWxpLmFwcC5pbnRlcmZhY2VzLn'
    'YxLkN1cnNvckl0ZW1SBWl0ZW1zEjcKA3RhYhgCIAMoCzIlLmJpbGliaWxpLmFwcC5pbnRlcmZh'
    'Y2VzLnYxLkN1cnNvclRhYlIDdGFiEjoKBmN1cnNvchgDIAEoCzIiLmJpbGliaWxpLmFwcC5pbn'
    'RlcmZhY2VzLnYxLkN1cnNvclIGY3Vyc29yEhkKCGhhc19tb3JlGAQgASgIUgdoYXNNb3Jl');

@$core.Deprecated('Use cursorReqDescriptor instead')
const CursorReq$json = {
  '1': 'CursorReq',
  '2': [
    {
      '1': 'cursor',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.Cursor',
      '10': 'cursor'
    },
    {'1': 'business', '3': 2, '4': 1, '5': 9, '10': 'business'},
    {
      '1': 'player_preload',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.PlayerPreloadParams',
      '10': 'playerPreload'
    },
    {
      '1': 'player_args',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.archive.middleware.v1.PlayerArgs',
      '10': 'playerArgs'
    },
  ],
};

/// Descriptor for `CursorReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cursorReqDescriptor = $convert.base64Decode(
    'CglDdXJzb3JSZXESOgoGY3Vyc29yGAEgASgLMiIuYmlsaWJpbGkuYXBwLmludGVyZmFjZXMudj'
    'EuQ3Vyc29yUgZjdXJzb3ISGgoIYnVzaW5lc3MYAiABKAlSCGJ1c2luZXNzElYKDnBsYXllcl9w'
    'cmVsb2FkGAMgASgLMi8uYmlsaWJpbGkuYXBwLmludGVyZmFjZXMudjEuUGxheWVyUHJlbG9hZF'
    'BhcmFtc1INcGxheWVyUHJlbG9hZBJPCgtwbGF5ZXJfYXJncxgEIAEoCzIuLmJpbGliaWxpLmFw'
    'cC5hcmNoaXZlLm1pZGRsZXdhcmUudjEuUGxheWVyQXJnc1IKcGxheWVyQXJncw==');

@$core.Deprecated('Use cursorTabDescriptor instead')
const CursorTab$json = {
  '1': 'CursorTab',
  '2': [
    {'1': 'business', '3': 1, '4': 1, '5': 9, '10': 'business'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'router', '3': 3, '4': 1, '5': 9, '10': 'router'},
    {'1': 'focus', '3': 4, '4': 1, '5': 8, '10': 'focus'},
  ],
};

/// Descriptor for `CursorTab`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cursorTabDescriptor = $convert.base64Decode(
    'CglDdXJzb3JUYWISGgoIYnVzaW5lc3MYASABKAlSCGJ1c2luZXNzEhIKBG5hbWUYAiABKAlSBG'
    '5hbWUSFgoGcm91dGVyGAMgASgJUgZyb3V0ZXISFAoFZm9jdXMYBCABKAhSBWZvY3Vz');

@$core.Deprecated('Use cursorV2ReplyDescriptor instead')
const CursorV2Reply$json = {
  '1': 'CursorV2Reply',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.CursorItem',
      '10': 'items'
    },
    {
      '1': 'cursor',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.Cursor',
      '10': 'cursor'
    },
    {'1': 'has_more', '3': 3, '4': 1, '5': 8, '10': 'hasMore'},
    {'1': 'empty_link', '3': 4, '4': 1, '5': 9, '10': 'emptyLink'},
  ],
};

/// Descriptor for `CursorV2Reply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cursorV2ReplyDescriptor = $convert.base64Decode(
    'Cg1DdXJzb3JWMlJlcGx5EjwKBWl0ZW1zGAEgAygLMiYuYmlsaWJpbGkuYXBwLmludGVyZmFjZX'
    'MudjEuQ3Vyc29ySXRlbVIFaXRlbXMSOgoGY3Vyc29yGAIgASgLMiIuYmlsaWJpbGkuYXBwLmlu'
    'dGVyZmFjZXMudjEuQ3Vyc29yUgZjdXJzb3ISGQoIaGFzX21vcmUYAyABKAhSB2hhc01vcmUSHQ'
    'oKZW1wdHlfbGluaxgEIAEoCVIJZW1wdHlMaW5r');

@$core.Deprecated('Use cursorV2ReqDescriptor instead')
const CursorV2Req$json = {
  '1': 'CursorV2Req',
  '2': [
    {
      '1': 'cursor',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.Cursor',
      '10': 'cursor'
    },
    {'1': 'business', '3': 2, '4': 1, '5': 9, '10': 'business'},
    {
      '1': 'player_preload',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.PlayerPreloadParams',
      '10': 'playerPreload'
    },
    {
      '1': 'player_args',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.archive.middleware.v1.PlayerArgs',
      '10': 'playerArgs'
    },
    {'1': 'is_local', '3': 5, '4': 1, '5': 8, '10': 'isLocal'},
  ],
};

/// Descriptor for `CursorV2Req`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cursorV2ReqDescriptor = $convert.base64Decode(
    'CgtDdXJzb3JWMlJlcRI6CgZjdXJzb3IYASABKAsyIi5iaWxpYmlsaS5hcHAuaW50ZXJmYWNlcy'
    '52MS5DdXJzb3JSBmN1cnNvchIaCghidXNpbmVzcxgCIAEoCVIIYnVzaW5lc3MSVgoOcGxheWVy'
    'X3ByZWxvYWQYAyABKAsyLy5iaWxpYmlsaS5hcHAuaW50ZXJmYWNlcy52MS5QbGF5ZXJQcmVsb2'
    'FkUGFyYW1zUg1wbGF5ZXJQcmVsb2FkEk8KC3BsYXllcl9hcmdzGAQgASgLMi4uYmlsaWJpbGku'
    'YXBwLmFyY2hpdmUubWlkZGxld2FyZS52MS5QbGF5ZXJBcmdzUgpwbGF5ZXJBcmdzEhkKCGlzX2'
    'xvY2FsGAUgASgIUgdpc0xvY2Fs');

@$core.Deprecated('Use defaultWordsReplyDescriptor instead')
const DefaultWordsReply$json = {
  '1': 'DefaultWordsReply',
  '2': [
    {'1': 'trackid', '3': 1, '4': 1, '5': 9, '10': 'trackid'},
    {'1': 'param', '3': 2, '4': 1, '5': 9, '10': 'param'},
    {'1': 'show', '3': 3, '4': 1, '5': 9, '10': 'show'},
    {'1': 'word', '3': 4, '4': 1, '5': 9, '10': 'word'},
    {'1': 'show_front', '3': 5, '4': 1, '5': 3, '10': 'showFront'},
    {'1': 'exp_str', '3': 6, '4': 1, '5': 9, '10': 'expStr'},
    {'1': 'goto', '3': 7, '4': 1, '5': 9, '10': 'goto'},
    {'1': 'value', '3': 8, '4': 1, '5': 9, '10': 'value'},
    {'1': 'uri', '3': 9, '4': 1, '5': 9, '10': 'uri'},
    {'1': 'enable_refresh', '3': 10, '4': 1, '5': 3, '10': 'enableRefresh'},
    {
      '1': 'refresh_interval_milli',
      '3': 11,
      '4': 1,
      '5': 3,
      '10': 'refreshIntervalMilli'
    },
    {'1': 'enable_animation', '3': 12, '4': 1, '5': 3, '10': 'enableAnimation'},
    {
      '1': 'animation_time_milli',
      '3': 13,
      '4': 1,
      '5': 3,
      '10': 'animationTimeMilli'
    },
  ],
};

/// Descriptor for `DefaultWordsReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defaultWordsReplyDescriptor = $convert.base64Decode(
    'ChFEZWZhdWx0V29yZHNSZXBseRIYCgd0cmFja2lkGAEgASgJUgd0cmFja2lkEhQKBXBhcmFtGA'
    'IgASgJUgVwYXJhbRISCgRzaG93GAMgASgJUgRzaG93EhIKBHdvcmQYBCABKAlSBHdvcmQSHQoK'
    'c2hvd19mcm9udBgFIAEoA1IJc2hvd0Zyb250EhcKB2V4cF9zdHIYBiABKAlSBmV4cFN0chISCg'
    'Rnb3RvGAcgASgJUgRnb3RvEhQKBXZhbHVlGAggASgJUgV2YWx1ZRIQCgN1cmkYCSABKAlSA3Vy'
    'aRIlCg5lbmFibGVfcmVmcmVzaBgKIAEoA1INZW5hYmxlUmVmcmVzaBI0ChZyZWZyZXNoX2ludG'
    'VydmFsX21pbGxpGAsgASgDUhRyZWZyZXNoSW50ZXJ2YWxNaWxsaRIpChBlbmFibGVfYW5pbWF0'
    'aW9uGAwgASgDUg9lbmFibGVBbmltYXRpb24SMAoUYW5pbWF0aW9uX3RpbWVfbWlsbGkYDSABKA'
    'NSEmFuaW1hdGlvblRpbWVNaWxsaQ==');

@$core.Deprecated('Use defaultWordsReqDescriptor instead')
const DefaultWordsReq$json = {
  '1': 'DefaultWordsReq',
  '2': [
    {'1': 'from', '3': 1, '4': 1, '5': 3, '10': 'from'},
    {'1': 'login_event', '3': 2, '4': 1, '5': 3, '10': 'loginEvent'},
    {'1': 'teenagers_mode', '3': 3, '4': 1, '5': 5, '10': 'teenagersMode'},
    {'1': 'lessons_mode', '3': 4, '4': 1, '5': 5, '10': 'lessonsMode'},
    {'1': 'tab', '3': 5, '4': 1, '5': 9, '10': 'tab'},
    {'1': 'event_id', '3': 6, '4': 1, '5': 9, '10': 'eventId'},
    {'1': 'avid', '3': 7, '4': 1, '5': 9, '10': 'avid'},
    {'1': 'query', '3': 8, '4': 1, '5': 9, '10': 'query'},
    {'1': 'an', '3': 9, '4': 1, '5': 3, '10': 'an'},
    {'1': 'is_fresh', '3': 10, '4': 1, '5': 3, '10': 'isFresh'},
    {'1': 'splash_guide', '3': 11, '4': 1, '5': 9, '10': 'splashGuide'},
    {'1': 'splash_id', '3': 12, '4': 1, '5': 3, '10': 'splashId'},
    {'1': 'refresh_type', '3': 13, '4': 1, '5': 3, '10': 'refreshType'},
    {'1': 'user_act', '3': 14, '4': 1, '5': 9, '10': 'userAct'},
    {
      '1': 'search_page_return',
      '3': 15,
      '4': 1,
      '5': 5,
      '10': 'searchPageReturn'
    },
  ],
};

/// Descriptor for `DefaultWordsReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defaultWordsReqDescriptor = $convert.base64Decode(
    'Cg9EZWZhdWx0V29yZHNSZXESEgoEZnJvbRgBIAEoA1IEZnJvbRIfCgtsb2dpbl9ldmVudBgCIA'
    'EoA1IKbG9naW5FdmVudBIlCg50ZWVuYWdlcnNfbW9kZRgDIAEoBVINdGVlbmFnZXJzTW9kZRIh'
    'CgxsZXNzb25zX21vZGUYBCABKAVSC2xlc3NvbnNNb2RlEhAKA3RhYhgFIAEoCVIDdGFiEhkKCG'
    'V2ZW50X2lkGAYgASgJUgdldmVudElkEhIKBGF2aWQYByABKAlSBGF2aWQSFAoFcXVlcnkYCCAB'
    'KAlSBXF1ZXJ5Eg4KAmFuGAkgASgDUgJhbhIZCghpc19mcmVzaBgKIAEoA1IHaXNGcmVzaBIhCg'
    'xzcGxhc2hfZ3VpZGUYCyABKAlSC3NwbGFzaEd1aWRlEhsKCXNwbGFzaF9pZBgMIAEoA1IIc3Bs'
    'YXNoSWQSIQoMcmVmcmVzaF90eXBlGA0gASgDUgtyZWZyZXNoVHlwZRIZCgh1c2VyX2FjdBgOIA'
    'EoCVIHdXNlckFjdBIsChJzZWFyY2hfcGFnZV9yZXR1cm4YDyABKAVSEHNlYXJjaFBhZ2VSZXR1'
    'cm4=');

@$core.Deprecated('Use deleteReqDescriptor instead')
const DeleteReq$json = {
  '1': 'DeleteReq',
  '2': [
    {
      '1': 'his_info',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.HisInfo',
      '10': 'hisInfo'
    },
    {'1': 'tab', '3': 2, '4': 1, '5': 9, '10': 'tab'},
  ],
};

/// Descriptor for `DeleteReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteReqDescriptor = $convert.base64Decode(
    'CglEZWxldGVSZXESPgoIaGlzX2luZm8YASADKAsyIy5iaWxpYmlsaS5hcHAuaW50ZXJmYWNlcy'
    '52MS5IaXNJbmZvUgdoaXNJbmZvEhAKA3RhYhgCIAEoCVIDdGFi');

@$core.Deprecated('Use deviceTypeDescriptor instead')
const DeviceType$json = {
  '1': 'DeviceType',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.interfaces.v1.DT',
      '10': 'type'
    },
    {'1': 'icon', '3': 2, '4': 1, '5': 9, '10': 'icon'},
  ],
};

/// Descriptor for `DeviceType`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceTypeDescriptor = $convert.base64Decode(
    'CgpEZXZpY2VUeXBlEjIKBHR5cGUYASABKA4yHi5iaWxpYmlsaS5hcHAuaW50ZXJmYWNlcy52MS'
    '5EVFIEdHlwZRISCgRpY29uGAIgASgJUgRpY29u');

@$core.Deprecated('Use dynamicDescriptor instead')
const Dynamic$json = {
  '1': 'Dynamic',
  '2': [
    {
      '1': 'dynamic',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.dynamic.v2.DynamicItem',
      '10': 'dynamic'
    },
  ],
};

/// Descriptor for `Dynamic`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dynamicDescriptor = $convert.base64Decode(
    'CgdEeW5hbWljEj4KB2R5bmFtaWMYASABKAsyJC5iaWxpYmlsaS5hcHAuZHluYW1pYy52Mi5EeW'
    '5hbWljSXRlbVIHZHluYW1pYw==');

@$core.Deprecated('Use facialRecognitionVerifyReplyDescriptor instead')
const FacialRecognitionVerifyReply$json = {
  '1': 'FacialRecognitionVerifyReply',
};

/// Descriptor for `FacialRecognitionVerifyReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List facialRecognitionVerifyReplyDescriptor =
    $convert.base64Decode('ChxGYWNpYWxSZWNvZ25pdGlvblZlcmlmeVJlcGx5');

@$core.Deprecated('Use facialRecognitionVerifyReqDescriptor instead')
const FacialRecognitionVerifyReq$json = {
  '1': 'FacialRecognitionVerifyReq',
  '2': [
    {
      '1': 'from',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.interfaces.v1.FacialRecognitionVerifyFrom',
      '10': 'from'
    },
    {'1': 'device_token', '3': 2, '4': 1, '5': 9, '10': 'deviceToken'},
  ],
};

/// Descriptor for `FacialRecognitionVerifyReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List facialRecognitionVerifyReqDescriptor =
    $convert.base64Decode(
        'ChpGYWNpYWxSZWNvZ25pdGlvblZlcmlmeVJlcRJLCgRmcm9tGAEgASgOMjcuYmlsaWJpbGkuYX'
        'BwLmludGVyZmFjZXMudjEuRmFjaWFsUmVjb2duaXRpb25WZXJpZnlGcm9tUgRmcm9tEiEKDGRl'
        'dmljZV90b2tlbhgCIAEoCVILZGV2aWNlVG9rZW4=');

@$core.Deprecated('Use hisInfoDescriptor instead')
const HisInfo$json = {
  '1': 'HisInfo',
  '2': [
    {'1': 'business', '3': 1, '4': 1, '5': 9, '10': 'business'},
    {'1': 'kid', '3': 2, '4': 1, '5': 3, '10': 'kid'},
  ],
};

/// Descriptor for `HisInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hisInfoDescriptor = $convert.base64Decode(
    'CgdIaXNJbmZvEhoKCGJ1c2luZXNzGAEgASgJUghidXNpbmVzcxIQCgNraWQYAiABKANSA2tpZA'
    '==');

@$core.Deprecated('Use historyTabReplyDescriptor instead')
const HistoryTabReply$json = {
  '1': 'HistoryTabReply',
  '2': [
    {
      '1': 'tab',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.CursorTab',
      '10': 'tab'
    },
  ],
};

/// Descriptor for `HistoryTabReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List historyTabReplyDescriptor = $convert.base64Decode(
    'Cg9IaXN0b3J5VGFiUmVwbHkSNwoDdGFiGAEgAygLMiUuYmlsaWJpbGkuYXBwLmludGVyZmFjZX'
    'MudjEuQ3Vyc29yVGFiUgN0YWI=');

@$core.Deprecated('Use historyTabReqDescriptor instead')
const HistoryTabReq$json = {
  '1': 'HistoryTabReq',
  '2': [
    {'1': 'business', '3': 1, '4': 1, '5': 9, '10': 'business'},
    {
      '1': 'source',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.interfaces.v1.HistorySource',
      '10': 'source'
    },
    {'1': 'keyword', '3': 3, '4': 1, '5': 9, '10': 'keyword'},
  ],
};

/// Descriptor for `HistoryTabReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List historyTabReqDescriptor = $convert.base64Decode(
    'Cg1IaXN0b3J5VGFiUmVxEhoKCGJ1c2luZXNzGAEgASgJUghidXNpbmVzcxJBCgZzb3VyY2UYAi'
    'ABKA4yKS5iaWxpYmlsaS5hcHAuaW50ZXJmYWNlcy52MS5IaXN0b3J5U291cmNlUgZzb3VyY2US'
    'GAoHa2V5d29yZBgDIAEoCVIHa2V5d29yZA==');

@$core.Deprecated('Use latestHistoryReplyDescriptor instead')
const LatestHistoryReply$json = {
  '1': 'LatestHistoryReply',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.CursorItem',
      '10': 'items'
    },
    {'1': 'scene', '3': 2, '4': 1, '5': 9, '10': 'scene'},
    {'1': 'rtime', '3': 3, '4': 1, '5': 3, '10': 'rtime'},
    {'1': 'flag', '3': 4, '4': 1, '5': 9, '10': 'flag'},
  ],
};

/// Descriptor for `LatestHistoryReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List latestHistoryReplyDescriptor = $convert.base64Decode(
    'ChJMYXRlc3RIaXN0b3J5UmVwbHkSPAoFaXRlbXMYASABKAsyJi5iaWxpYmlsaS5hcHAuaW50ZX'
    'JmYWNlcy52MS5DdXJzb3JJdGVtUgVpdGVtcxIUCgVzY2VuZRgCIAEoCVIFc2NlbmUSFAoFcnRp'
    'bWUYAyABKANSBXJ0aW1lEhIKBGZsYWcYBCABKAlSBGZsYWc=');

@$core.Deprecated('Use latestHistoryReqDescriptor instead')
const LatestHistoryReq$json = {
  '1': 'LatestHistoryReq',
  '2': [
    {'1': 'business', '3': 1, '4': 1, '5': 9, '10': 'business'},
    {
      '1': 'player_preload',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.PlayerPreloadParams',
      '10': 'playerPreload'
    },
  ],
};

/// Descriptor for `LatestHistoryReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List latestHistoryReqDescriptor = $convert.base64Decode(
    'ChBMYXRlc3RIaXN0b3J5UmVxEhoKCGJ1c2luZXNzGAEgASgJUghidXNpbmVzcxJWCg5wbGF5ZX'
    'JfcHJlbG9hZBgCIAEoCzIvLmJpbGliaWxpLmFwcC5pbnRlcmZhY2VzLnYxLlBsYXllclByZWxv'
    'YWRQYXJhbXNSDXBsYXllclByZWxvYWQ=');

@$core.Deprecated('Use likeButtonDescriptor instead')
const LikeButton$json = {
  '1': 'LikeButton',
  '2': [
    {'1': 'aid', '3': 1, '4': 1, '5': 3, '10': 'aid'},
    {'1': 'count', '3': 2, '4': 1, '5': 5, '10': 'count'},
    {'1': 'show_count', '3': 3, '4': 1, '5': 8, '10': 'showCount'},
    {'1': 'event', '3': 4, '4': 1, '5': 9, '10': 'event'},
    {'1': 'selected', '3': 5, '4': 1, '5': 5, '10': 'selected'},
    {'1': 'event_v2', '3': 6, '4': 1, '5': 9, '10': 'eventV2'},
    {
      '1': 'like_resource',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.LikeButtonResource',
      '10': 'likeResource'
    },
    {
      '1': 'dis_like_resource',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.LikeButtonResource',
      '10': 'disLikeResource'
    },
    {
      '1': 'like_night_resource',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.LikeButtonResource',
      '10': 'likeNightResource'
    },
    {
      '1': 'dis_like_night_resource',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.LikeButtonResource',
      '10': 'disLikeNightResource'
    },
  ],
};

/// Descriptor for `LikeButton`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List likeButtonDescriptor = $convert.base64Decode(
    'CgpMaWtlQnV0dG9uEhAKA2FpZBgBIAEoA1IDYWlkEhQKBWNvdW50GAIgASgFUgVjb3VudBIdCg'
    'pzaG93X2NvdW50GAMgASgIUglzaG93Q291bnQSFAoFZXZlbnQYBCABKAlSBWV2ZW50EhoKCHNl'
    'bGVjdGVkGAUgASgFUghzZWxlY3RlZBIZCghldmVudF92MhgGIAEoCVIHZXZlbnRWMhJTCg1saW'
    'tlX3Jlc291cmNlGAcgASgLMi4uYmlsaWJpbGkuYXBwLmludGVyZmFjZXMudjEuTGlrZUJ1dHRv'
    'blJlc291cmNlUgxsaWtlUmVzb3VyY2USWgoRZGlzX2xpa2VfcmVzb3VyY2UYCCABKAsyLi5iaW'
    'xpYmlsaS5hcHAuaW50ZXJmYWNlcy52MS5MaWtlQnV0dG9uUmVzb3VyY2VSD2Rpc0xpa2VSZXNv'
    'dXJjZRJeChNsaWtlX25pZ2h0X3Jlc291cmNlGAkgASgLMi4uYmlsaWJpbGkuYXBwLmludGVyZm'
    'FjZXMudjEuTGlrZUJ1dHRvblJlc291cmNlUhFsaWtlTmlnaHRSZXNvdXJjZRJlChdkaXNfbGlr'
    'ZV9uaWdodF9yZXNvdXJjZRgKIAEoCzIuLmJpbGliaWxpLmFwcC5pbnRlcmZhY2VzLnYxLkxpa2'
    'VCdXR0b25SZXNvdXJjZVIUZGlzTGlrZU5pZ2h0UmVzb3VyY2U=');

@$core.Deprecated('Use likeButtonResourceDescriptor instead')
const LikeButtonResource$json = {
  '1': 'LikeButtonResource',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {'1': 'hash', '3': 2, '4': 1, '5': 9, '10': 'hash'},
  ],
};

/// Descriptor for `LikeButtonResource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List likeButtonResourceDescriptor = $convert.base64Decode(
    'ChJMaWtlQnV0dG9uUmVzb3VyY2USEAoDdXJsGAEgASgJUgN1cmwSEgoEaGFzaBgCIAEoCVIEaG'
    'FzaA==');

@$core.Deprecated('Use likeCardDescriptor instead')
const LikeCard$json = {
  '1': 'LikeCard',
  '2': [
    {'1': 'like', '3': 1, '4': 1, '5': 3, '10': 'like'},
    {'1': 'is_follow', '3': 2, '4': 1, '5': 8, '10': 'isFollow'},
  ],
};

/// Descriptor for `LikeCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List likeCardDescriptor = $convert.base64Decode(
    'CghMaWtlQ2FyZBISCgRsaWtlGAEgASgDUgRsaWtlEhsKCWlzX2ZvbGxvdxgCIAEoCFIIaXNGb2'
    'xsb3c=');

@$core.Deprecated('Use mediaCardDescriptor instead')
const MediaCard$json = {
  '1': 'MediaCard',
  '2': [
    {'1': 'cover', '3': 1, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'cur_title', '3': 2, '4': 1, '5': 9, '10': 'curTitle'},
    {'1': 'style', '3': 3, '4': 1, '5': 9, '10': 'style'},
    {'1': 'label', '3': 4, '4': 1, '5': 9, '10': 'label'},
    {
      '1': 'but_first',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.Button',
      '10': 'butFirst'
    },
    {
      '1': 'but_second',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.Supernatant',
      '10': 'butSecond'
    },
    {
      '1': 'scores',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.Scores',
      '10': 'scores'
    },
  ],
};

/// Descriptor for `MediaCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaCardDescriptor = $convert.base64Decode(
    'CglNZWRpYUNhcmQSFAoFY292ZXIYASABKAlSBWNvdmVyEhsKCWN1cl90aXRsZRgCIAEoCVIIY3'
    'VyVGl0bGUSFAoFc3R5bGUYAyABKAlSBXN0eWxlEhQKBWxhYmVsGAQgASgJUgVsYWJlbBI/Cgli'
    'dXRfZmlyc3QYBSABKAsyIi5iaWxpYmlsaS5hcHAuaW50ZXJmYWNlcy52MS5CdXR0b25SCGJ1dE'
    'ZpcnN0EkYKCmJ1dF9zZWNvbmQYBiABKAsyJy5iaWxpYmlsaS5hcHAuaW50ZXJmYWNlcy52MS5T'
    'dXBlcm5hdGFudFIJYnV0U2Vjb25kEjoKBnNjb3JlcxgHIAEoCzIiLmJpbGliaWxpLmFwcC5pbn'
    'RlcmZhY2VzLnYxLlNjb3Jlc1IGc2NvcmVz');

@$core.Deprecated('Use mediaCommentReplyDescriptor instead')
const MediaCommentReply$json = {
  '1': 'MediaCommentReply',
  '2': [
    {'1': 'err_msg', '3': 1, '4': 1, '5': 9, '10': 'errMsg'},
  ],
};

/// Descriptor for `MediaCommentReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaCommentReplyDescriptor = $convert.base64Decode(
    'ChFNZWRpYUNvbW1lbnRSZXBseRIXCgdlcnJfbXNnGAEgASgJUgZlcnJNc2c=');

@$core.Deprecated('Use mediaCommentReqDescriptor instead')
const MediaCommentReq$json = {
  '1': 'MediaCommentReq',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `MediaCommentReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaCommentReqDescriptor =
    $convert.base64Decode('Cg9NZWRpYUNvbW1lbnRSZXESDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use mediaDetailReplyDescriptor instead')
const MediaDetailReply$json = {
  '1': 'MediaDetailReply',
  '2': [
    {
      '1': 'cast',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.Cast',
      '10': 'cast'
    },
    {
      '1': 'staff',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.Staff',
      '10': 'staff'
    },
    {
      '1': 'overview',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.Overview',
      '10': 'overview'
    },
  ],
};

/// Descriptor for `MediaDetailReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaDetailReplyDescriptor = $convert.base64Decode(
    'ChBNZWRpYURldGFpbFJlcGx5EjQKBGNhc3QYASABKAsyIC5iaWxpYmlsaS5hcHAuaW50ZXJmYW'
    'Nlcy52MS5DYXN0UgRjYXN0EjcKBXN0YWZmGAIgASgLMiEuYmlsaWJpbGkuYXBwLmludGVyZmFj'
    'ZXMudjEuU3RhZmZSBXN0YWZmEkAKCG92ZXJ2aWV3GAMgASgLMiQuYmlsaWJpbGkuYXBwLmludG'
    'VyZmFjZXMudjEuT3ZlcnZpZXdSCG92ZXJ2aWV3');

@$core.Deprecated('Use mediaDetailReqDescriptor instead')
const MediaDetailReq$json = {
  '1': 'MediaDetailReq',
  '2': [
    {'1': 'biz_id', '3': 1, '4': 1, '5': 3, '10': 'bizId'},
    {'1': 'biz_type', '3': 2, '4': 1, '5': 3, '10': 'bizType'},
  ],
};

/// Descriptor for `MediaDetailReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaDetailReqDescriptor = $convert.base64Decode(
    'Cg5NZWRpYURldGFpbFJlcRIVCgZiaXpfaWQYASABKANSBWJpeklkEhkKCGJpel90eXBlGAIgAS'
    'gDUgdiaXpUeXBl');

@$core.Deprecated('Use mediaFollowReplyDescriptor instead')
const MediaFollowReply$json = {
  '1': 'MediaFollowReply',
};

/// Descriptor for `MediaFollowReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaFollowReplyDescriptor =
    $convert.base64Decode('ChBNZWRpYUZvbGxvd1JlcGx5');

@$core.Deprecated('Use mediaFollowReqDescriptor instead')
const MediaFollowReq$json = {
  '1': 'MediaFollowReq',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.interfaces.v1.ButType',
      '10': 'type'
    },
  ],
};

/// Descriptor for `MediaFollowReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaFollowReqDescriptor = $convert.base64Decode(
    'Cg5NZWRpYUZvbGxvd1JlcRIOCgJpZBgBIAEoCVICaWQSNwoEdHlwZRgCIAEoDjIjLmJpbGliaW'
    'xpLmFwcC5pbnRlcmZhY2VzLnYxLkJ1dFR5cGVSBHR5cGU=');

@$core.Deprecated('Use mediaPersonDescriptor instead')
const MediaPerson$json = {
  '1': 'MediaPerson',
  '2': [
    {'1': 'real_name', '3': 1, '4': 1, '5': 9, '10': 'realName'},
    {'1': 'square_url', '3': 2, '4': 1, '5': 9, '10': 'squareUrl'},
    {'1': 'character', '3': 3, '4': 1, '5': 9, '10': 'character'},
    {'1': 'person_id', '3': 4, '4': 1, '5': 3, '10': 'personId'},
    {'1': 'type', '3': 5, '4': 1, '5': 9, '10': 'type'},
  ],
};

/// Descriptor for `MediaPerson`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaPersonDescriptor = $convert.base64Decode(
    'CgtNZWRpYVBlcnNvbhIbCglyZWFsX25hbWUYASABKAlSCHJlYWxOYW1lEh0KCnNxdWFyZV91cm'
    'wYAiABKAlSCXNxdWFyZVVybBIcCgljaGFyYWN0ZXIYAyABKAlSCWNoYXJhY3RlchIbCglwZXJz'
    'b25faWQYBCABKANSCHBlcnNvbklkEhIKBHR5cGUYBSABKAlSBHR5cGU=');

@$core.Deprecated('Use mediaRelationReplyDescriptor instead')
const MediaRelationReply$json = {
  '1': 'MediaRelationReply',
  '2': [
    {'1': 'offset', '3': 1, '4': 1, '5': 9, '10': 'offset'},
    {'1': 'has_more', '3': 2, '4': 1, '5': 8, '10': 'hasMore'},
    {
      '1': 'list',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.SmallItem',
      '10': 'list'
    },
  ],
};

/// Descriptor for `MediaRelationReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaRelationReplyDescriptor = $convert.base64Decode(
    'ChJNZWRpYVJlbGF0aW9uUmVwbHkSFgoGb2Zmc2V0GAEgASgJUgZvZmZzZXQSGQoIaGFzX21vcm'
    'UYAiABKAhSB2hhc01vcmUSOQoEbGlzdBgDIAMoCzIlLmJpbGliaWxpLmFwcC5pbnRlcmZhY2Vz'
    'LnYxLlNtYWxsSXRlbVIEbGlzdA==');

@$core.Deprecated('Use mediaRelationReqDescriptor instead')
const MediaRelationReq$json = {
  '1': 'MediaRelationReq',
  '2': [
    {'1': 'biz_id', '3': 1, '4': 1, '5': 3, '10': 'bizId'},
    {'1': 'biz_type', '3': 2, '4': 1, '5': 3, '10': 'bizType'},
    {'1': 'feed_id', '3': 3, '4': 1, '5': 3, '10': 'feedId'},
    {'1': 'offset', '3': 5, '4': 1, '5': 9, '10': 'offset'},
    {'1': 'ps', '3': 6, '4': 1, '5': 5, '10': 'ps'},
  ],
};

/// Descriptor for `MediaRelationReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaRelationReqDescriptor = $convert.base64Decode(
    'ChBNZWRpYVJlbGF0aW9uUmVxEhUKBmJpel9pZBgBIAEoA1IFYml6SWQSGQoIYml6X3R5cGUYAi'
    'ABKANSB2JpelR5cGUSFwoHZmVlZF9pZBgDIAEoA1IGZmVlZElkEhYKBm9mZnNldBgFIAEoCVIG'
    'b2Zmc2V0Eg4KAnBzGAYgASgFUgJwcw==');

@$core.Deprecated('Use mediaTabReplyDescriptor instead')
const MediaTabReply$json = {
  '1': 'MediaTabReply',
  '2': [
    {
      '1': 'media_card',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.MediaCard',
      '10': 'mediaCard'
    },
    {
      '1': 'tab',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.ShowTab',
      '10': 'tab'
    },
    {'1': 'default_tab_index', '3': 3, '4': 1, '5': 3, '10': 'defaultTabIndex'},
    {
      '1': 'channel_info',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.ChannelInfo',
      '10': 'channelInfo'
    },
  ],
};

/// Descriptor for `MediaTabReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaTabReplyDescriptor = $convert.base64Decode(
    'Cg1NZWRpYVRhYlJlcGx5EkQKCm1lZGlhX2NhcmQYASABKAsyJS5iaWxpYmlsaS5hcHAuaW50ZX'
    'JmYWNlcy52MS5NZWRpYUNhcmRSCW1lZGlhQ2FyZBI1CgN0YWIYAiADKAsyIy5iaWxpYmlsaS5h'
    'cHAuaW50ZXJmYWNlcy52MS5TaG93VGFiUgN0YWISKgoRZGVmYXVsdF90YWJfaW5kZXgYAyABKA'
    'NSD2RlZmF1bHRUYWJJbmRleBJKCgxjaGFubmVsX2luZm8YBCABKAsyJy5iaWxpYmlsaS5hcHAu'
    'aW50ZXJmYWNlcy52MS5DaGFubmVsSW5mb1ILY2hhbm5lbEluZm8=');

@$core.Deprecated('Use mediaTabReqDescriptor instead')
const MediaTabReq$json = {
  '1': 'MediaTabReq',
  '2': [
    {'1': 'biz_id', '3': 1, '4': 1, '5': 3, '10': 'bizId'},
    {'1': 'biz_type', '3': 2, '4': 1, '5': 3, '10': 'bizType'},
    {'1': 'source', '3': 3, '4': 1, '5': 9, '10': 'source'},
    {'1': 'spmid', '3': 4, '4': 1, '5': 9, '10': 'spmid'},
    {
      '1': 'args',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.MediaTabReq.ArgsEntry',
      '10': 'args'
    },
  ],
  '3': [MediaTabReq_ArgsEntry$json],
};

@$core.Deprecated('Use mediaTabReqDescriptor instead')
const MediaTabReq_ArgsEntry$json = {
  '1': 'ArgsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `MediaTabReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaTabReqDescriptor = $convert.base64Decode(
    'CgtNZWRpYVRhYlJlcRIVCgZiaXpfaWQYASABKANSBWJpeklkEhkKCGJpel90eXBlGAIgASgDUg'
    'diaXpUeXBlEhYKBnNvdXJjZRgDIAEoCVIGc291cmNlEhQKBXNwbWlkGAQgASgJUgVzcG1pZBJF'
    'CgRhcmdzGAUgAygLMjEuYmlsaWJpbGkuYXBwLmludGVyZmFjZXMudjEuTWVkaWFUYWJSZXEuQX'
    'Jnc0VudHJ5UgRhcmdzGjcKCUFyZ3NFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgC'
    'IAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use mediaVideoReplyDescriptor instead')
const MediaVideoReply$json = {
  '1': 'MediaVideoReply',
  '2': [
    {'1': 'offset', '3': 1, '4': 1, '5': 9, '10': 'offset'},
    {'1': 'has_more', '3': 2, '4': 1, '5': 8, '10': 'hasMore'},
    {
      '1': 'list',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.BigItem',
      '10': 'list'
    },
  ],
};

/// Descriptor for `MediaVideoReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaVideoReplyDescriptor = $convert.base64Decode(
    'Cg9NZWRpYVZpZGVvUmVwbHkSFgoGb2Zmc2V0GAEgASgJUgZvZmZzZXQSGQoIaGFzX21vcmUYAi'
    'ABKAhSB2hhc01vcmUSNwoEbGlzdBgDIAMoCzIjLmJpbGliaWxpLmFwcC5pbnRlcmZhY2VzLnYx'
    'LkJpZ0l0ZW1SBGxpc3Q=');

@$core.Deprecated('Use mediaVideoReqDescriptor instead')
const MediaVideoReq$json = {
  '1': 'MediaVideoReq',
  '2': [
    {'1': 'biz_id', '3': 1, '4': 1, '5': 3, '10': 'bizId'},
    {'1': 'biz_type', '3': 2, '4': 1, '5': 3, '10': 'bizType'},
    {'1': 'feed_id', '3': 3, '4': 1, '5': 3, '10': 'feedId'},
    {'1': 'offset', '3': 5, '4': 1, '5': 9, '10': 'offset'},
    {'1': 'ps', '3': 6, '4': 1, '5': 5, '10': 'ps'},
    {
      '1': 'player_args',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.archive.middleware.v1.PlayerArgs',
      '10': 'playerArgs'
    },
  ],
};

/// Descriptor for `MediaVideoReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaVideoReqDescriptor = $convert.base64Decode(
    'Cg1NZWRpYVZpZGVvUmVxEhUKBmJpel9pZBgBIAEoA1IFYml6SWQSGQoIYml6X3R5cGUYAiABKA'
    'NSB2JpelR5cGUSFwoHZmVlZF9pZBgDIAEoA1IGZmVlZElkEhYKBm9mZnNldBgFIAEoCVIGb2Zm'
    'c2V0Eg4KAnBzGAYgASgFUgJwcxJPCgtwbGF5ZXJfYXJncxgHIAEoCzIuLmJpbGliaWxpLmFwcC'
    '5hcmNoaXZlLm1pZGRsZXdhcmUudjEuUGxheWVyQXJnc1IKcGxheWVyQXJncw==');

@$core.Deprecated('Use modeStatusReplyDescriptor instead')
const ModeStatusReply$json = {
  '1': 'ModeStatusReply',
  '2': [
    {
      '1': 'user_models',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.UserModel',
      '10': 'userModels'
    },
  ],
};

/// Descriptor for `ModeStatusReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List modeStatusReplyDescriptor = $convert.base64Decode(
    'Cg9Nb2RlU3RhdHVzUmVwbHkSRgoLdXNlcl9tb2RlbHMYASADKAsyJS5iaWxpYmlsaS5hcHAuaW'
    '50ZXJmYWNlcy52MS5Vc2VyTW9kZWxSCnVzZXJNb2RlbHM=');

@$core.Deprecated('Use modeStatusReqDescriptor instead')
const ModeStatusReq$json = {
  '1': 'ModeStatusReq',
  '2': [
    {'1': 'device_token', '3': 1, '4': 1, '5': 9, '10': 'deviceToken'},
  ],
};

/// Descriptor for `ModeStatusReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List modeStatusReqDescriptor = $convert.base64Decode(
    'Cg1Nb2RlU3RhdHVzUmVxEiEKDGRldmljZV90b2tlbhgBIAEoCVILZGV2aWNlVG9rZW4=');

@$core.Deprecated('Use modifyPwdReplyDescriptor instead')
const ModifyPwdReply$json = {
  '1': 'ModifyPwdReply',
};

/// Descriptor for `ModifyPwdReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List modifyPwdReplyDescriptor =
    $convert.base64Decode('Cg5Nb2RpZnlQd2RSZXBseQ==');

@$core.Deprecated('Use modifyPwdReqDescriptor instead')
const ModifyPwdReq$json = {
  '1': 'ModifyPwdReq',
  '2': [
    {'1': 'old_pwd', '3': 1, '4': 1, '5': 9, '10': 'oldPwd'},
    {'1': 'new_pwd', '3': 2, '4': 1, '5': 9, '10': 'newPwd'},
    {'1': 'device_token', '3': 3, '4': 1, '5': 9, '10': 'deviceToken'},
  ],
};

/// Descriptor for `ModifyPwdReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List modifyPwdReqDescriptor = $convert.base64Decode(
    'CgxNb2RpZnlQd2RSZXESFwoHb2xkX3B3ZBgBIAEoCVIGb2xkUHdkEhcKB25ld19wd2QYAiABKA'
    'lSBm5ld1B3ZBIhCgxkZXZpY2VfdG9rZW4YAyABKAlSC2RldmljZVRva2Vu');

@$core.Deprecated('Use nftFaceIconDescriptor instead')
const NftFaceIcon$json = {
  '1': 'NftFaceIcon',
  '2': [
    {'1': 'region_type', '3': 1, '4': 1, '5': 5, '10': 'regionType'},
    {'1': 'icon', '3': 2, '4': 1, '5': 9, '10': 'icon'},
    {'1': 'show_status', '3': 3, '4': 1, '5': 5, '10': 'showStatus'},
  ],
};

/// Descriptor for `NftFaceIcon`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nftFaceIconDescriptor = $convert.base64Decode(
    'CgtOZnRGYWNlSWNvbhIfCgtyZWdpb25fdHlwZRgBIAEoBVIKcmVnaW9uVHlwZRISCgRpY29uGA'
    'IgASgJUgRpY29uEh8KC3Nob3dfc3RhdHVzGAMgASgFUgpzaG93U3RhdHVz');

@$core.Deprecated('Use noReplyDescriptor instead')
const NoReply$json = {
  '1': 'NoReply',
};

/// Descriptor for `NoReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List noReplyDescriptor =
    $convert.base64Decode('CgdOb1JlcGx5');

@$core.Deprecated('Use officialVerifyDescriptor instead')
const OfficialVerify$json = {
  '1': 'OfficialVerify',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 5, '10': 'type'},
    {'1': 'desc', '3': 2, '4': 1, '5': 9, '10': 'desc'},
  ],
};

/// Descriptor for `OfficialVerify`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List officialVerifyDescriptor = $convert.base64Decode(
    'Cg5PZmZpY2lhbFZlcmlmeRISCgR0eXBlGAEgASgFUgR0eXBlEhIKBGRlc2MYAiABKAlSBGRlc2'
    'M=');

@$core.Deprecated('Use overviewDescriptor instead')
const Overview$json = {
  '1': 'Overview',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
  ],
};

/// Descriptor for `Overview`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List overviewDescriptor = $convert.base64Decode(
    'CghPdmVydmlldxIUCgV0aXRsZRgBIAEoCVIFdGl0bGUSEgoEdGV4dBgCIAEoCVIEdGV4dA==');

@$core.Deprecated('Use pageDescriptor instead')
const Page$json = {
  '1': 'Page',
  '2': [
    {'1': 'pn', '3': 1, '4': 1, '5': 3, '10': 'pn'},
    {'1': 'total', '3': 2, '4': 1, '5': 3, '10': 'total'},
  ],
};

/// Descriptor for `Page`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pageDescriptor = $convert.base64Decode(
    'CgRQYWdlEg4KAnBuGAEgASgDUgJwbhIUCgV0b3RhbBgCIAEoA1IFdG90YWw=');

@$core.Deprecated('Use playerPreloadParamsDescriptor instead')
const PlayerPreloadParams$json = {
  '1': 'PlayerPreloadParams',
  '2': [
    {'1': 'qn', '3': 1, '4': 1, '5': 3, '10': 'qn'},
    {'1': 'fnver', '3': 2, '4': 1, '5': 3, '10': 'fnver'},
    {'1': 'fnval', '3': 3, '4': 1, '5': 3, '10': 'fnval'},
    {'1': 'force_host', '3': 4, '4': 1, '5': 3, '10': 'forceHost'},
    {'1': 'fourk', '3': 5, '4': 1, '5': 3, '10': 'fourk'},
  ],
};

/// Descriptor for `PlayerPreloadParams`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playerPreloadParamsDescriptor = $convert.base64Decode(
    'ChNQbGF5ZXJQcmVsb2FkUGFyYW1zEg4KAnFuGAEgASgDUgJxbhIUCgVmbnZlchgCIAEoA1IFZm'
    '52ZXISFAoFZm52YWwYAyABKANSBWZudmFsEh0KCmZvcmNlX2hvc3QYBCABKANSCWZvcmNlSG9z'
    'dBIUCgVmb3VyaxgFIAEoA1IFZm91cms=');

@$core.Deprecated('Use policyDescriptor instead')
const Policy$json = {
  '1': 'Policy',
  '2': [
    {'1': 'interval', '3': 1, '4': 1, '5': 3, '10': 'interval'},
    {'1': 'use_local_time', '3': 2, '4': 1, '5': 8, '10': 'useLocalTime'},
  ],
};

/// Descriptor for `Policy`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List policyDescriptor = $convert.base64Decode(
    'CgZQb2xpY3kSGgoIaW50ZXJ2YWwYASABKANSCGludGVydmFsEiQKDnVzZV9sb2NhbF90aW1lGA'
    'IgASgIUgx1c2VMb2NhbFRpbWU=');

@$core.Deprecated('Use reasonStyleDescriptor instead')
const ReasonStyle$json = {
  '1': 'ReasonStyle',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'text_color', '3': 2, '4': 1, '5': 9, '10': 'textColor'},
    {'1': 'text_color_night', '3': 3, '4': 1, '5': 9, '10': 'textColorNight'},
    {'1': 'bg_color', '3': 4, '4': 1, '5': 9, '10': 'bgColor'},
    {'1': 'bg_color_night', '3': 5, '4': 1, '5': 9, '10': 'bgColorNight'},
    {'1': 'border_color', '3': 6, '4': 1, '5': 9, '10': 'borderColor'},
    {
      '1': 'border_color_night',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'borderColorNight'
    },
    {'1': 'bg_style', '3': 8, '4': 1, '5': 5, '10': 'bgStyle'},
  ],
};

/// Descriptor for `ReasonStyle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reasonStyleDescriptor = $convert.base64Decode(
    'CgtSZWFzb25TdHlsZRISCgR0ZXh0GAEgASgJUgR0ZXh0Eh0KCnRleHRfY29sb3IYAiABKAlSCX'
    'RleHRDb2xvchIoChB0ZXh0X2NvbG9yX25pZ2h0GAMgASgJUg50ZXh0Q29sb3JOaWdodBIZCghi'
    'Z19jb2xvchgEIAEoCVIHYmdDb2xvchIkCg5iZ19jb2xvcl9uaWdodBgFIAEoCVIMYmdDb2xvck'
    '5pZ2h0EiEKDGJvcmRlcl9jb2xvchgGIAEoCVILYm9yZGVyQ29sb3ISLAoSYm9yZGVyX2NvbG9y'
    'X25pZ2h0GAcgASgJUhBib3JkZXJDb2xvck5pZ2h0EhkKCGJnX3N0eWxlGAggASgFUgdiZ1N0eW'
    'xl');

@$core.Deprecated('Use relationDescriptor instead')
const Relation$json = {
  '1': 'Relation',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 5, '10': 'status'},
    {'1': 'is_follow', '3': 2, '4': 1, '5': 5, '10': 'isFollow'},
    {'1': 'is_followed', '3': 3, '4': 1, '5': 5, '10': 'isFollowed'},
  ],
};

/// Descriptor for `Relation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List relationDescriptor = $convert.base64Decode(
    'CghSZWxhdGlvbhIWCgZzdGF0dXMYASABKAVSBnN0YXR1cxIbCglpc19mb2xsb3cYAiABKAVSCG'
    'lzRm9sbG93Eh8KC2lzX2ZvbGxvd2VkGAMgASgFUgppc0ZvbGxvd2Vk');

@$core.Deprecated('Use resultItemDescriptor instead')
const ResultItem$json = {
  '1': 'ResultItem',
  '2': [
    {'1': 'from', '3': 1, '4': 1, '5': 9, '10': 'from'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'keyword', '3': 3, '4': 1, '5': 9, '10': 'keyword'},
    {'1': 'position', '3': 4, '4': 1, '5': 5, '10': 'position'},
    {'1': 'cover', '3': 5, '4': 1, '5': 9, '10': 'cover'},
    {'1': 'cover_size', '3': 6, '4': 1, '5': 1, '10': 'coverSize'},
    {'1': 'sug_type', '3': 7, '4': 1, '5': 9, '10': 'sugType'},
    {'1': 'term_type', '3': 8, '4': 1, '5': 5, '10': 'termType'},
    {'1': 'goto', '3': 9, '4': 1, '5': 9, '10': 'goto'},
    {'1': 'uri', '3': 10, '4': 1, '5': 9, '10': 'uri'},
    {
      '1': 'official_verify',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.OfficialVerify',
      '10': 'officialVerify'
    },
    {'1': 'param', '3': 12, '4': 1, '5': 9, '10': 'param'},
    {'1': 'mid', '3': 13, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'fans', '3': 14, '4': 1, '5': 5, '10': 'fans'},
    {'1': 'level', '3': 15, '4': 1, '5': 5, '10': 'level'},
    {'1': 'archives', '3': 16, '4': 1, '5': 5, '10': 'archives'},
    {'1': 'ptime', '3': 17, '4': 1, '5': 3, '10': 'ptime'},
    {'1': 'season_type_name', '3': 18, '4': 1, '5': 9, '10': 'seasonTypeName'},
    {'1': 'area', '3': 19, '4': 1, '5': 9, '10': 'area'},
    {'1': 'style', '3': 20, '4': 1, '5': 9, '10': 'style'},
    {'1': 'label', '3': 21, '4': 1, '5': 9, '10': 'label'},
    {'1': 'rating', '3': 22, '4': 1, '5': 1, '10': 'rating'},
    {'1': 'vote', '3': 23, '4': 1, '5': 5, '10': 'vote'},
    {
      '1': 'badges',
      '3': 24,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.ReasonStyle',
      '10': 'badges'
    },
    {'1': 'styles', '3': 25, '4': 1, '5': 9, '10': 'styles'},
    {'1': 'module_id', '3': 26, '4': 1, '5': 3, '10': 'moduleId'},
    {'1': 'live_link', '3': 27, '4': 1, '5': 9, '10': 'liveLink'},
    {'1': 'face_nft_new', '3': 28, '4': 1, '5': 5, '10': 'faceNftNew'},
    {
      '1': 'nft_face_icon',
      '3': 29,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.NftFaceIcon',
      '10': 'nftFaceIcon'
    },
    {'1': 'is_senior_member', '3': 30, '4': 1, '5': 5, '10': 'isSeniorMember'},
    {'1': 'is_sug_style_exp', '3': 31, '4': 1, '5': 5, '10': 'isSugStyleExp'},
  ],
};

/// Descriptor for `ResultItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resultItemDescriptor = $convert.base64Decode(
    'CgpSZXN1bHRJdGVtEhIKBGZyb20YASABKAlSBGZyb20SFAoFdGl0bGUYAiABKAlSBXRpdGxlEh'
    'gKB2tleXdvcmQYAyABKAlSB2tleXdvcmQSGgoIcG9zaXRpb24YBCABKAVSCHBvc2l0aW9uEhQK'
    'BWNvdmVyGAUgASgJUgVjb3ZlchIdCgpjb3Zlcl9zaXplGAYgASgBUgljb3ZlclNpemUSGQoIc3'
    'VnX3R5cGUYByABKAlSB3N1Z1R5cGUSGwoJdGVybV90eXBlGAggASgFUgh0ZXJtVHlwZRISCgRn'
    'b3RvGAkgASgJUgRnb3RvEhAKA3VyaRgKIAEoCVIDdXJpElMKD29mZmljaWFsX3ZlcmlmeRgLIA'
    'EoCzIqLmJpbGliaWxpLmFwcC5pbnRlcmZhY2VzLnYxLk9mZmljaWFsVmVyaWZ5Ug5vZmZpY2lh'
    'bFZlcmlmeRIUCgVwYXJhbRgMIAEoCVIFcGFyYW0SEAoDbWlkGA0gASgDUgNtaWQSEgoEZmFucx'
    'gOIAEoBVIEZmFucxIUCgVsZXZlbBgPIAEoBVIFbGV2ZWwSGgoIYXJjaGl2ZXMYECABKAVSCGFy'
    'Y2hpdmVzEhQKBXB0aW1lGBEgASgDUgVwdGltZRIoChBzZWFzb25fdHlwZV9uYW1lGBIgASgJUg'
    '5zZWFzb25UeXBlTmFtZRISCgRhcmVhGBMgASgJUgRhcmVhEhQKBXN0eWxlGBQgASgJUgVzdHls'
    'ZRIUCgVsYWJlbBgVIAEoCVIFbGFiZWwSFgoGcmF0aW5nGBYgASgBUgZyYXRpbmcSEgoEdm90ZR'
    'gXIAEoBVIEdm90ZRI/CgZiYWRnZXMYGCADKAsyJy5iaWxpYmlsaS5hcHAuaW50ZXJmYWNlcy52'
    'MS5SZWFzb25TdHlsZVIGYmFkZ2VzEhYKBnN0eWxlcxgZIAEoCVIGc3R5bGVzEhsKCW1vZHVsZV'
    '9pZBgaIAEoA1IIbW9kdWxlSWQSGwoJbGl2ZV9saW5rGBsgASgJUghsaXZlTGluaxIgCgxmYWNl'
    'X25mdF9uZXcYHCABKAVSCmZhY2VOZnROZXcSSwoNbmZ0X2ZhY2VfaWNvbhgdIAEoCzInLmJpbG'
    'liaWxpLmFwcC5pbnRlcmZhY2VzLnYxLk5mdEZhY2VJY29uUgtuZnRGYWNlSWNvbhIoChBpc19z'
    'ZW5pb3JfbWVtYmVyGB4gASgFUg5pc1Nlbmlvck1lbWJlchInChBpc19zdWdfc3R5bGVfZXhwGB'
    '8gASgFUg1pc1N1Z1N0eWxlRXhw');

@$core.Deprecated('Use scoresDescriptor instead')
const Scores$json = {
  '1': 'Scores',
  '2': [
    {'1': 'score', '3': 1, '4': 1, '5': 2, '10': 'score'},
  ],
};

/// Descriptor for `Scores`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scoresDescriptor =
    $convert.base64Decode('CgZTY29yZXMSFAoFc2NvcmUYASABKAJSBXNjb3Jl');

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
    {
      '1': 'player_args',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.archive.middleware.v1.PlayerArgs',
      '10': 'playerArgs'
    },
  ],
};

/// Descriptor for `SearchArchiveReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchArchiveReqDescriptor = $convert.base64Decode(
    'ChBTZWFyY2hBcmNoaXZlUmVxEhgKB2tleXdvcmQYASABKAlSB2tleXdvcmQSEAoDbWlkGAIgAS'
    'gDUgNtaWQSDgoCcG4YAyABKANSAnBuEg4KAnBzGAQgASgDUgJwcxJPCgtwbGF5ZXJfYXJncxgF'
    'IAEoCzIuLmJpbGliaWxpLmFwcC5hcmNoaXZlLm1pZGRsZXdhcmUudjEuUGxheWVyQXJnc1IKcG'
    'xheWVyQXJncw==');

@$core.Deprecated('Use searchDynamicReplyDescriptor instead')
const SearchDynamicReply$json = {
  '1': 'SearchDynamicReply',
  '2': [
    {
      '1': 'dynamics',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.Dynamic',
      '10': 'dynamics'
    },
    {'1': 'total', '3': 2, '4': 1, '5': 3, '10': 'total'},
  ],
};

/// Descriptor for `SearchDynamicReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchDynamicReplyDescriptor = $convert.base64Decode(
    'ChJTZWFyY2hEeW5hbWljUmVwbHkSPwoIZHluYW1pY3MYASADKAsyIy5iaWxpYmlsaS5hcHAuaW'
    '50ZXJmYWNlcy52MS5EeW5hbWljUghkeW5hbWljcxIUCgV0b3RhbBgCIAEoA1IFdG90YWw=');

@$core.Deprecated('Use searchDynamicReqDescriptor instead')
const SearchDynamicReq$json = {
  '1': 'SearchDynamicReq',
  '2': [
    {'1': 'keyword', '3': 1, '4': 1, '5': 9, '10': 'keyword'},
    {'1': 'mid', '3': 2, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'pn', '3': 3, '4': 1, '5': 3, '10': 'pn'},
    {'1': 'ps', '3': 4, '4': 1, '5': 3, '10': 'ps'},
    {
      '1': 'player_args',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.archive.middleware.v1.PlayerArgs',
      '10': 'playerArgs'
    },
  ],
};

/// Descriptor for `SearchDynamicReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchDynamicReqDescriptor = $convert.base64Decode(
    'ChBTZWFyY2hEeW5hbWljUmVxEhgKB2tleXdvcmQYASABKAlSB2tleXdvcmQSEAoDbWlkGAIgAS'
    'gDUgNtaWQSDgoCcG4YAyABKANSAnBuEg4KAnBzGAQgASgDUgJwcxJPCgtwbGF5ZXJfYXJncxgF'
    'IAEoCzIuLmJpbGliaWxpLmFwcC5hcmNoaXZlLm1pZGRsZXdhcmUudjEuUGxheWVyQXJnc1IKcG'
    'xheWVyQXJncw==');

@$core.Deprecated('Use searchReplyDescriptor instead')
const SearchReply$json = {
  '1': 'SearchReply',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.CursorItem',
      '10': 'items'
    },
    {'1': 'has_more', '3': 2, '4': 1, '5': 8, '10': 'hasMore'},
    {
      '1': 'page',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.Page',
      '10': 'page'
    },
  ],
};

/// Descriptor for `SearchReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchReplyDescriptor = $convert.base64Decode(
    'CgtTZWFyY2hSZXBseRI8CgVpdGVtcxgBIAMoCzImLmJpbGliaWxpLmFwcC5pbnRlcmZhY2VzLn'
    'YxLkN1cnNvckl0ZW1SBWl0ZW1zEhkKCGhhc19tb3JlGAIgASgIUgdoYXNNb3JlEjQKBHBhZ2UY'
    'AyABKAsyIC5iaWxpYmlsaS5hcHAuaW50ZXJmYWNlcy52MS5QYWdlUgRwYWdl');

@$core.Deprecated('Use searchReqDescriptor instead')
const SearchReq$json = {
  '1': 'SearchReq',
  '2': [
    {'1': 'keyword', '3': 1, '4': 1, '5': 9, '10': 'keyword'},
    {'1': 'pn', '3': 2, '4': 1, '5': 3, '10': 'pn'},
    {'1': 'business', '3': 3, '4': 1, '5': 9, '10': 'business'},
  ],
};

/// Descriptor for `SearchReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchReqDescriptor = $convert.base64Decode(
    'CglTZWFyY2hSZXESGAoHa2V5d29yZBgBIAEoCVIHa2V5d29yZBIOCgJwbhgCIAEoA1ICcG4SGg'
    'oIYnVzaW5lc3MYAyABKAlSCGJ1c2luZXNz');

@$core.Deprecated('Use searchTabReplyDescriptor instead')
const SearchTabReply$json = {
  '1': 'SearchTabReply',
  '2': [
    {'1': 'focus', '3': 1, '4': 1, '5': 3, '10': 'focus'},
    {
      '1': 'tabs',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.Tab',
      '10': 'tabs'
    },
  ],
};

/// Descriptor for `SearchTabReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchTabReplyDescriptor = $convert.base64Decode(
    'Cg5TZWFyY2hUYWJSZXBseRIUCgVmb2N1cxgBIAEoA1IFZm9jdXMSMwoEdGFicxgCIAMoCzIfLm'
    'JpbGliaWxpLmFwcC5pbnRlcmZhY2VzLnYxLlRhYlIEdGFicw==');

@$core.Deprecated('Use searchTabReqDescriptor instead')
const SearchTabReq$json = {
  '1': 'SearchTabReq',
  '2': [
    {'1': 'keyword', '3': 1, '4': 1, '5': 9, '10': 'keyword'},
    {'1': 'mid', '3': 2, '4': 1, '5': 3, '10': 'mid'},
    {
      '1': 'from',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.interfaces.v1.From',
      '10': 'from'
    },
  ],
};

/// Descriptor for `SearchTabReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchTabReqDescriptor = $convert.base64Decode(
    'CgxTZWFyY2hUYWJSZXESGAoHa2V5d29yZBgBIAEoCVIHa2V5d29yZBIQCgNtaWQYAiABKANSA2'
    '1pZBI0CgRmcm9tGAMgASgOMiAuYmlsaWJpbGkuYXBwLmludGVyZmFjZXMudjEuRnJvbVIEZnJv'
    'bQ==');

@$core.Deprecated('Use setTeenagersModelAgeReplyDescriptor instead')
const SetTeenagersModelAgeReply$json = {
  '1': 'SetTeenagersModelAgeReply',
};

/// Descriptor for `SetTeenagersModelAgeReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setTeenagersModelAgeReplyDescriptor =
    $convert.base64Decode('ChlTZXRUZWVuYWdlcnNNb2RlbEFnZVJlcGx5');

@$core.Deprecated('Use setTeenagersModelAgeReqDescriptor instead')
const SetTeenagersModelAgeReq$json = {
  '1': 'SetTeenagersModelAgeReq',
  '2': [
    {'1': 'pwd', '3': 1, '4': 1, '5': 9, '10': 'pwd'},
    {
      '1': 'pwd_from',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.interfaces.v1.PwdFrom',
      '10': 'pwdFrom'
    },
    {'1': 'device_token', '3': 3, '4': 1, '5': 9, '10': 'deviceToken'},
    {'1': 'age', '3': 4, '4': 1, '5': 5, '10': 'age'},
    {'1': 'is_dynamic', '3': 5, '4': 1, '5': 8, '10': 'isDynamic'},
  ],
};

/// Descriptor for `SetTeenagersModelAgeReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setTeenagersModelAgeReqDescriptor = $convert.base64Decode(
    'ChdTZXRUZWVuYWdlcnNNb2RlbEFnZVJlcRIQCgNwd2QYASABKAlSA3B3ZBI+Cghwd2RfZnJvbR'
    'gCIAEoDjIjLmJpbGliaWxpLmFwcC5pbnRlcmZhY2VzLnYxLlB3ZEZyb21SB3B3ZEZyb20SIQoM'
    'ZGV2aWNlX3Rva2VuGAMgASgJUgtkZXZpY2VUb2tlbhIQCgNhZ2UYBCABKAVSA2FnZRIdCgppc1'
    '9keW5hbWljGAUgASgIUglpc0R5bmFtaWM=');

@$core.Deprecated('Use showTabDescriptor instead')
const ShowTab$json = {
  '1': 'ShowTab',
  '2': [
    {
      '1': 'tab_type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.interfaces.v1.TabType',
      '10': 'tabType'
    },
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'url', '3': 3, '4': 1, '5': 9, '10': 'url'},
  ],
};

/// Descriptor for `ShowTab`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List showTabDescriptor = $convert.base64Decode(
    'CgdTaG93VGFiEj4KCHRhYl90eXBlGAEgASgOMiMuYmlsaWJpbGkuYXBwLmludGVyZmFjZXMudj'
    'EuVGFiVHlwZVIHdGFiVHlwZRIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSEAoDdXJsGAMgASgJUgN1'
    'cmw=');

@$core.Deprecated('Use smallItemDescriptor instead')
const SmallItem$json = {
  '1': 'SmallItem',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'cover_image_uri', '3': 2, '4': 1, '5': 9, '10': 'coverImageUri'},
    {'1': 'uri', '3': 3, '4': 1, '5': 9, '10': 'uri'},
    {'1': 'cover_right_text', '3': 4, '4': 1, '5': 9, '10': 'coverRightText'},
    {'1': 'cover_left_text1', '3': 5, '4': 1, '5': 9, '10': 'coverLeftText1'},
    {'1': 'cover_left_icon1', '3': 6, '4': 1, '5': 3, '10': 'coverLeftIcon1'},
    {'1': 'cover_left_text2', '3': 7, '4': 1, '5': 9, '10': 'coverLeftText2'},
    {'1': 'cover_left_icon2', '3': 8, '4': 1, '5': 3, '10': 'coverLeftIcon2'},
    {'1': 'param', '3': 9, '4': 1, '5': 3, '10': 'param'},
    {'1': 'mid', '3': 10, '4': 1, '5': 3, '10': 'mid'},
  ],
};

/// Descriptor for `SmallItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List smallItemDescriptor = $convert.base64Decode(
    'CglTbWFsbEl0ZW0SFAoFdGl0bGUYASABKAlSBXRpdGxlEiYKD2NvdmVyX2ltYWdlX3VyaRgCIA'
    'EoCVINY292ZXJJbWFnZVVyaRIQCgN1cmkYAyABKAlSA3VyaRIoChBjb3Zlcl9yaWdodF90ZXh0'
    'GAQgASgJUg5jb3ZlclJpZ2h0VGV4dBIoChBjb3Zlcl9sZWZ0X3RleHQxGAUgASgJUg5jb3Zlck'
    'xlZnRUZXh0MRIoChBjb3Zlcl9sZWZ0X2ljb24xGAYgASgDUg5jb3ZlckxlZnRJY29uMRIoChBj'
    'b3Zlcl9sZWZ0X3RleHQyGAcgASgJUg5jb3ZlckxlZnRUZXh0MhIoChBjb3Zlcl9sZWZ0X2ljb2'
    '4yGAggASgDUg5jb3ZlckxlZnRJY29uMhIUCgVwYXJhbRgJIAEoA1IFcGFyYW0SEAoDbWlkGAog'
    'ASgDUgNtaWQ=');

@$core.Deprecated('Use staffDescriptor instead')
const Staff$json = {
  '1': 'Staff',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
  ],
};

/// Descriptor for `Staff`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List staffDescriptor = $convert.base64Decode(
    'CgVTdGFmZhIUCgV0aXRsZRgBIAEoCVIFdGl0bGUSEgoEdGV4dBgCIAEoCVIEdGV4dA==');

@$core.Deprecated('Use suggestionResult3ReplyDescriptor instead')
const SuggestionResult3Reply$json = {
  '1': 'SuggestionResult3Reply',
  '2': [
    {'1': 'trackid', '3': 1, '4': 1, '5': 9, '10': 'trackid'},
    {
      '1': 'list',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.ResultItem',
      '10': 'list'
    },
    {'1': 'exp_str', '3': 3, '4': 1, '5': 9, '10': 'expStr'},
  ],
};

/// Descriptor for `SuggestionResult3Reply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List suggestionResult3ReplyDescriptor = $convert.base64Decode(
    'ChZTdWdnZXN0aW9uUmVzdWx0M1JlcGx5EhgKB3RyYWNraWQYASABKAlSB3RyYWNraWQSOgoEbG'
    'lzdBgCIAMoCzImLmJpbGliaWxpLmFwcC5pbnRlcmZhY2VzLnYxLlJlc3VsdEl0ZW1SBGxpc3QS'
    'FwoHZXhwX3N0chgDIAEoCVIGZXhwU3Ry');

@$core.Deprecated('Use suggestionResult3ReqDescriptor instead')
const SuggestionResult3Req$json = {
  '1': 'SuggestionResult3Req',
  '2': [
    {'1': 'keyword', '3': 1, '4': 1, '5': 9, '10': 'keyword'},
    {'1': 'highlight', '3': 2, '4': 1, '5': 5, '10': 'highlight'},
    {'1': 'teenagers_mode', '3': 3, '4': 1, '5': 5, '10': 'teenagersMode'},
    {'1': 'user_act', '3': 4, '4': 1, '5': 9, '10': 'userAct'},
  ],
};

/// Descriptor for `SuggestionResult3Req`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List suggestionResult3ReqDescriptor = $convert.base64Decode(
    'ChRTdWdnZXN0aW9uUmVzdWx0M1JlcRIYCgdrZXl3b3JkGAEgASgJUgdrZXl3b3JkEhwKCWhpZ2'
    'hsaWdodBgCIAEoBVIJaGlnaGxpZ2h0EiUKDnRlZW5hZ2Vyc19tb2RlGAMgASgFUg10ZWVuYWdl'
    'cnNNb2RlEhkKCHVzZXJfYWN0GAQgASgJUgd1c2VyQWN0');

@$core.Deprecated('Use supernatantDescriptor instead')
const Supernatant$json = {
  '1': 'Supernatant',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'item',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.CommentItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `Supernatant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List supernatantDescriptor = $convert.base64Decode(
    'CgtTdXBlcm5hdGFudBIUCgV0aXRsZRgBIAEoCVIFdGl0bGUSOwoEaXRlbRgCIAMoCzInLmJpbG'
    'liaWxpLmFwcC5pbnRlcmZhY2VzLnYxLkNvbW1lbnRJdGVtUgRpdGVt');

@$core.Deprecated('Use tabDescriptor instead')
const Tab$json = {
  '1': 'Tab',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'uri', '3': 2, '4': 1, '5': 9, '10': 'uri'},
  ],
};

/// Descriptor for `Tab`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tabDescriptor = $convert.base64Decode(
    'CgNUYWISFAoFdGl0bGUYASABKAlSBXRpdGxlEhAKA3VyaRgCIAEoCVIDdXJp');

@$core.Deprecated('Use updateReserveStartTimeReplyDescriptor instead')
const UpdateReserveStartTimeReply$json = {
  '1': 'UpdateReserveStartTimeReply',
  '2': [
    {'1': 'desc_text', '3': 1, '4': 1, '5': 9, '10': 'descText'},
  ],
};

/// Descriptor for `UpdateReserveStartTimeReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateReserveStartTimeReplyDescriptor =
    $convert.base64Decode(
        'ChtVcGRhdGVSZXNlcnZlU3RhcnRUaW1lUmVwbHkSGwoJZGVzY190ZXh0GAEgASgJUghkZXNjVG'
        'V4dA==');

@$core.Deprecated('Use updateReserveStartTimeReqDescriptor instead')
const UpdateReserveStartTimeReq$json = {
  '1': 'UpdateReserveStartTimeReq',
  '2': [
    {'1': 'sid', '3': 1, '4': 1, '5': 3, '10': 'sid'},
    {
      '1': 'new_live_plan_start_time',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'newLivePlanStartTime'
    },
  ],
};

/// Descriptor for `UpdateReserveStartTimeReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateReserveStartTimeReqDescriptor =
    $convert.base64Decode(
        'ChlVcGRhdGVSZXNlcnZlU3RhcnRUaW1lUmVxEhAKA3NpZBgBIAEoA1IDc2lkEjYKGG5ld19saX'
        'ZlX3BsYW5fc3RhcnRfdGltZRgCIAEoA1IUbmV3TGl2ZVBsYW5TdGFydFRpbWU=');

@$core.Deprecated('Use updateStatusReplyDescriptor instead')
const UpdateStatusReply$json = {
  '1': 'UpdateStatusReply',
};

/// Descriptor for `UpdateStatusReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateStatusReplyDescriptor =
    $convert.base64Decode('ChFVcGRhdGVTdGF0dXNSZXBseQ==');

@$core.Deprecated('Use updateStatusReqDescriptor instead')
const UpdateStatusReq$json = {
  '1': 'UpdateStatusReq',
  '2': [
    {'1': 'pwd', '3': 1, '4': 1, '5': 9, '10': 'pwd'},
    {'1': 'switch', '3': 2, '4': 1, '5': 8, '10': 'switch'},
    {
      '1': 'pwd_from',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.interfaces.v1.PwdFrom',
      '10': 'pwdFrom'
    },
    {'1': 'device_token', '3': 4, '4': 1, '5': 9, '10': 'deviceToken'},
  ],
};

/// Descriptor for `UpdateStatusReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateStatusReqDescriptor = $convert.base64Decode(
    'Cg9VcGRhdGVTdGF0dXNSZXESEAoDcHdkGAEgASgJUgNwd2QSFgoGc3dpdGNoGAIgASgIUgZzd2'
    'l0Y2gSPgoIcHdkX2Zyb20YAyABKA4yIy5iaWxpYmlsaS5hcHAuaW50ZXJmYWNlcy52MS5Qd2RG'
    'cm9tUgdwd2RGcm9tEiEKDGRldmljZV90b2tlbhgEIAEoCVILZGV2aWNlVG9rZW4=');

@$core.Deprecated('Use userCardDescriptor instead')
const UserCard$json = {
  '1': 'UserCard',
  '2': [
    {'1': 'user_name', '3': 1, '4': 1, '5': 9, '10': 'userName'},
    {'1': 'user_face', '3': 2, '4': 1, '5': 9, '10': 'userFace'},
    {'1': 'user_url', '3': 3, '4': 1, '5': 9, '10': 'userUrl'},
    {'1': 'mid', '3': 4, '4': 1, '5': 3, '10': 'mid'},
  ],
};

/// Descriptor for `UserCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userCardDescriptor = $convert.base64Decode(
    'CghVc2VyQ2FyZBIbCgl1c2VyX25hbWUYASABKAlSCHVzZXJOYW1lEhsKCXVzZXJfZmFjZRgCIA'
    'EoCVIIdXNlckZhY2USGQoIdXNlcl91cmwYAyABKAlSB3VzZXJVcmwSEAoDbWlkGAQgASgDUgNt'
    'aWQ=');

@$core.Deprecated('Use userModelDescriptor instead')
const UserModel$json = {
  '1': 'UserModel',
  '2': [
    {'1': 'mid', '3': 1, '4': 1, '5': 3, '10': 'mid'},
    {'1': 'mode', '3': 2, '4': 1, '5': 9, '10': 'mode'},
    {'1': 'wsxcde', '3': 3, '4': 1, '5': 9, '10': 'wsxcde'},
    {
      '1': 'status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.interfaces.v1.ModelStatus',
      '10': 'status'
    },
    {
      '1': 'policy',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bilibili.app.interfaces.v1.Policy',
      '10': 'policy'
    },
    {'1': 'is_forced', '3': 6, '4': 1, '5': 8, '10': 'isForced'},
    {'1': 'must_teen', '3': 7, '4': 1, '5': 8, '10': 'mustTeen'},
    {'1': 'must_real_name', '3': 8, '4': 1, '5': 8, '10': 'mustRealName'},
    {'1': 'is_parent_control', '3': 9, '4': 1, '5': 8, '10': 'isParentControl'},
    {'1': 'age', '3': 10, '4': 1, '5': 5, '10': 'age'},
  ],
};

/// Descriptor for `UserModel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userModelDescriptor = $convert.base64Decode(
    'CglVc2VyTW9kZWwSEAoDbWlkGAEgASgDUgNtaWQSEgoEbW9kZRgCIAEoCVIEbW9kZRIWCgZ3c3'
    'hjZGUYAyABKAlSBndzeGNkZRI/CgZzdGF0dXMYBCABKA4yJy5iaWxpYmlsaS5hcHAuaW50ZXJm'
    'YWNlcy52MS5Nb2RlbFN0YXR1c1IGc3RhdHVzEjoKBnBvbGljeRgFIAEoCzIiLmJpbGliaWxpLm'
    'FwcC5pbnRlcmZhY2VzLnYxLlBvbGljeVIGcG9saWN5EhsKCWlzX2ZvcmNlZBgGIAEoCFIIaXNG'
    'b3JjZWQSGwoJbXVzdF90ZWVuGAcgASgIUghtdXN0VGVlbhIkCg5tdXN0X3JlYWxfbmFtZRgIIA'
    'EoCFIMbXVzdFJlYWxOYW1lEioKEWlzX3BhcmVudF9jb250cm9sGAkgASgIUg9pc1BhcmVudENv'
    'bnRyb2wSEAoDYWdlGAogASgFUgNhZ2U=');

@$core.Deprecated('Use verifyPwdReplyDescriptor instead')
const VerifyPwdReply$json = {
  '1': 'VerifyPwdReply',
};

/// Descriptor for `VerifyPwdReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyPwdReplyDescriptor =
    $convert.base64Decode('Cg5WZXJpZnlQd2RSZXBseQ==');

@$core.Deprecated('Use verifyPwdReqDescriptor instead')
const VerifyPwdReq$json = {
  '1': 'VerifyPwdReq',
  '2': [
    {'1': 'pwd', '3': 1, '4': 1, '5': 9, '10': 'pwd'},
    {
      '1': 'pwd_from',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.bilibili.app.interfaces.v1.PwdFrom',
      '10': 'pwdFrom'
    },
    {'1': 'is_dynamic', '3': 3, '4': 1, '5': 8, '10': 'isDynamic'},
    {'1': 'close_device', '3': 4, '4': 1, '5': 8, '10': 'closeDevice'},
    {'1': 'device_token', '3': 5, '4': 1, '5': 9, '10': 'deviceToken'},
  ],
};

/// Descriptor for `VerifyPwdReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyPwdReqDescriptor = $convert.base64Decode(
    'CgxWZXJpZnlQd2RSZXESEAoDcHdkGAEgASgJUgNwd2QSPgoIcHdkX2Zyb20YAiABKA4yIy5iaW'
    'xpYmlsaS5hcHAuaW50ZXJmYWNlcy52MS5Qd2RGcm9tUgdwd2RGcm9tEh0KCmlzX2R5bmFtaWMY'
    'AyABKAhSCWlzRHluYW1pYxIhCgxjbG9zZV9kZXZpY2UYBCABKAhSC2Nsb3NlRGV2aWNlEiEKDG'
    'RldmljZV90b2tlbhgFIAEoCVILZGV2aWNlVG9rZW4=');
