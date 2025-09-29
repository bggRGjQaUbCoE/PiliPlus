// ignore_for_file: constant_identifier_names

import 'dart:ui';

import 'package:PiliPlus/models/common/sponsor_block/action_type.dart';

enum SegmentType {
  sponsor(
    '赞助广告',
    '赞助广告',
    '付费推广、付费推荐和直接广告。不是自我推广或免费提及他们喜欢的商品/创作者/网站/产品。',
    Color(0xFF00d400),
    [
      ActionType.skip,
      ActionType.mute,
      ActionType.full,
    ],
  ),
  selfpromo(
    '无偿/自我推广',
    '推广',
    '类似于 “赞助广告” ，但无报酬或是自我推广。包括有关商品、捐赠的部分或合作者的信息。',
    Color(0xFFffff00),
    [
      ActionType.skip,
      ActionType.mute,
      ActionType.full,
    ],
  ),
  interaction(
    '三连/订阅提醒',
    '订阅提醒',
    '视频中间简短提醒观众来一键三连或关注。 如果片段较长，或是有具体内容，则应分类为自我推广。',
    Color(0xFFcc00ff),
    [
      ActionType.skip,
      ActionType.mute,
    ],
  ),
  intro(
    '过场/开场动画',
    '开场',
    '没有实际内容的间隔片段。可以是暂停、静态帧或重复动画。不适用于包含内容的过场。',
    Color(0xFF00ffff),
    [
      ActionType.skip,
      ActionType.mute,
    ],
  ),
  outro(
    '鸣谢/结束画面',
    '片尾',
    '致谢画面或片尾画面。不包含内容的结尾。',
    Color(0xFF0202ed),
    [
      ActionType.skip,
      ActionType.mute,
    ],
  ),
  preview(
    '回顾/概要',
    '预览',
    '展示此视频或同系列视频将出现的画面集锦，片段中所有内容都将在之后的正片中再次出现。',
    Color(0xFF008fd6),
    [
      ActionType.skip,
      ActionType.mute,
    ],
  ),
  music_offtopic(
    '音乐:非音乐部分',
    '非音乐',
    '仅用于音乐视频。此分类只能用于音乐视频中未包括于其他分类的部分。',
    Color(0xFFff9900),
    [ActionType.skip],
  ),
  poi_highlight(
    '精彩时刻/重点',
    '精彩时刻',
    '大部分人都在寻找的空降时间。类似于“封面在12:34”的评论。',
    Color(0xFFff1684),
    [ActionType.poi],
  ),
  filler(
    '离题闲聊/玩笑',
    '闲聊',
    "仅作为填充内容或增添趣味而添加的离题片段，这些内容对理解视频的主要内容并非必需。这不包括提供背景信息或上下文的片段。这是一个非常激进的分类，适用于当你不想看'娱乐性'内容的时候。",
    Color(0xFF7300FF),
    [
      ActionType.skip,
      ActionType.mute,
    ],
  ),
  exclusive_access(
    '柔性推广/品牌合作',
    '品牌合作',
    '仅用于对整个视频进行标记。适用于展示UP主免费或获得补贴后使用的产品、服务或场地的视频。',
    Color(0xFF008a5c),
    [ActionType.full],
  );

  /// from https://github.com/hanydd/BilibiliSponsorBlock/blob/master/public/_locales/zh_CN/messages.json
  final String title;
  final String shortTitle;
  final String description;
  final Color color;
  final List<ActionType> toActionType;

  const SegmentType(
    this.title,
    this.shortTitle,
    this.description,
    this.color,
    this.toActionType,
  );
}

// List<SegmentType> _actionType2SegmentType(ActionType actionType) {
//   return switch (actionType) {
//     ActionType.skip => [
//         SegmentType.sponsor,
//         SegmentType.selfpromo,
//         SegmentType.interaction,
//         SegmentType.intro,
//         SegmentType.outro,
//         SegmentType.preview,
//         SegmentType.filler,
//       ],
//     ActionType.mute => [
//         SegmentType.sponsor,
//         SegmentType.selfpromo,
//         SegmentType.interaction,
//         SegmentType.intro,
//         SegmentType.outro,
//         SegmentType.preview,
//         SegmentType.music_offtopic,
//         SegmentType.filler,
//       ],
//     ActionType.full => [
//         SegmentType.sponsor,
//         SegmentType.selfpromo,
//         SegmentType.exclusive_access,
//       ],
//     ActionType.poi => [
//         SegmentType.poi_highlight,
//       ],
//   };
// }
