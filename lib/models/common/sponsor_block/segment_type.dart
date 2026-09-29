// ignore_for_file: constant_identifier_names

import 'dart:ui';

import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/models/common/sponsor_block/action_type.dart';

enum SegmentType {
  sponsor(Color(0xFF00d400), [
    ActionType.skip,
    ActionType.mute,
    ActionType.full,
  ]),
  selfpromo(Color(0xFFffff00), [
    ActionType.skip,
    ActionType.mute,
    ActionType.full,
  ]),
  exclusive_access(Color(0xFF008a5c), [ActionType.full]),
  interaction(Color(0xFFcc00ff), [ActionType.skip, ActionType.mute]),
  poi_highlight(Color(0xFFff1684), [ActionType.poi]),
  intro(Color(0xFF00ffff), [ActionType.skip, ActionType.mute]),
  outro(Color(0xFF0202ed), [ActionType.skip, ActionType.mute]),
  preview(Color(0xFF008fd6), [ActionType.skip, ActionType.mute]),
  padding(Color(0xFF222222), [ActionType.skip]),
  filler(Color(0xFF7300FF), [ActionType.skip, ActionType.mute]),
  music_offtopic(Color(0xFFff9900), [ActionType.skip]),
  ;

  String get title => switch (this) {
    sponsor => L10n.current.segmentTypeSponsorTitle,
    selfpromo => L10n.current.segmentTypeSelfpromoTitle,
    exclusive_access => L10n.current.segmentTypeExclusiveAccessTitle,
    interaction => L10n.current.segmentTypeInteractionTitle,
    poi_highlight => L10n.current.segmentTypePoiHighlightTitle,
    intro => L10n.current.segmentTypeIntroTitle,
    outro => L10n.current.segmentTypeOutroTitle,
    preview => L10n.current.segmentTypePreviewTitle,
    padding => L10n.current.segmentTypePaddingTitle,
    filler => L10n.current.segmentTypeFillerTitle,
    music_offtopic => L10n.current.segmentTypeMusicOfftopicTitle,
  };
  String get shortTitle => switch (this) {
    sponsor => L10n.current.segmentTypeSponsorShortTitle,
    selfpromo => L10n.current.segmentTypeSelfpromoShortTitle,
    exclusive_access => L10n.current.segmentTypeExclusiveAccessShortTitle,
    interaction => L10n.current.segmentTypeInteractionShortTitle,
    poi_highlight => L10n.current.actionTypePoiTitle,
    intro => L10n.current.segmentTypeIntroShortTitle,
    outro => L10n.current.segmentTypeOutroShortTitle,
    preview => L10n.current.segmentTypePreviewShortTitle,
    padding => L10n.current.segmentTypePaddingShortTitle,
    filler => L10n.current.segmentTypeFillerShortTitle,
    music_offtopic => L10n.current.segmentTypeMusicOfftopicShortTitle,
  };

  /// from https://github.com/hanydd/BilibiliSponsorBlock/blob/master/public/_locales/zh_CN/messages.json
  String get description => switch (this) {
    sponsor => L10n.current.segmentTypeSponsorDescription,
    selfpromo => L10n.current.segmentTypeSelfpromoDescription,
    exclusive_access => L10n.current.segmentTypeExclusiveAccessDescription,
    interaction => L10n.current.segmentTypeInteractionDescription,
    poi_highlight => L10n.current.segmentTypePoiHighlightDescription,
    intro => L10n.current.segmentTypeIntroDescription,
    outro => L10n.current.segmentTypeOutroDescription,
    preview => L10n.current.segmentTypePreviewDescription,
    padding => L10n.current.segmentTypePaddingDescription,
    filler => L10n.current.segmentTypeFillerDescription,
    music_offtopic => L10n.current.segmentTypeMusicOfftopicDescription,
  };
  final Color color;
  final List<ActionType> toActionType;

  const SegmentType(this.color, this.toActionType);
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
