import 'dart:math';

import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/dialog/report.dart';
import 'package:PiliPlus/common/widgets/emote_tooltip.dart';
import 'package:PiliPlus/common/widgets/gesture/tap_gesture_recognizer.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/image_grid/image_grid_view.dart';
import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/common/widgets/text_ellipsis/text_ellipsis.dart';
import 'package:PiliPlus/common/widgets/text_more/text_more.dart';
import 'package:PiliPlus/common/widgets/translucent_row.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo, ReplyControl, Content, Url, ReplyControl_VoteOption, Emote;
import 'package:PiliPlus/grpc/reply.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/reply.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/pages/dynamics/widgets/vote.dart';
import 'package:PiliPlus/pages/member/widget/medal_widget.dart';
import 'package:PiliPlus/pages/save_panel/view.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/reply/widgets/reply_threaded_indent_box.dart';
import 'package:PiliPlus/pages/video/reply/widgets/zan_grpc.dart';
import 'package:PiliPlus/pages/video/reply_reply/tree.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/bili_utils.dart';
import 'package:PiliPlus/utils/color_utils.dart';
import 'package:PiliPlus/utils/danmaku_utils.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension/context_ext.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/selectable_region_ext.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:PiliPlus/utils/url_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';
import 'package:protobuf/protobuf.dart';

part 'package:PiliPlus/common/widgets/context_menu/reply_menu_helper.dart';

const _replyTextButtonStyle = ButtonStyle(
  visualDensity: VisualDensity.compact,
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  padding: WidgetStatePropertyAll(EdgeInsets.zero),
);

final _colorsLight = [
  Colors.redAccent,
  Colors.orangeAccent,
  Colors.yellowAccent.shade400,
  Colors.greenAccent,
  Colors.cyanAccent,
  Colors.blueAccent,
  Colors.purpleAccent,
];

final _colorsDark = [
  Colors.red.shade900,
  Colors.orange.shade900,
  Colors.yellow.shade800,
  Colors.green.shade900,
  Colors.cyan.shade900,
  Colors.blue.shade900,
  Colors.deepPurple.shade900,
];

Widget _replyItemLayout({
  required BuildContext context,
  required Widget content,
  int depth = -1,
  bool needDivider = true,
  VoidCallback? onTap,
  VoidCallback? onLongPress,
}) {
  final colorScheme = ColorScheme.of(context);
  Widget child = Padding(
    padding: const EdgeInsets.fromLTRB(12, 14, 8, 5),
    child: content,
  );

  if (depth >= 0) {
    child = ReplyThreadedIndentBox(
      depth: depth,
      colors: colorScheme.isLight ? _colorsLight : _colorsDark,
      divColor: colorScheme.outline.withValues(alpha: 0.08),
      onTapLine: () => debugPrint('onTapLine'),
      onTapDot: (i) => debugPrint('onTapDot: $i'),
      onScrollLeft: () => debugPrint('onLeftDrag'),
      child: child,
    );
  }

  if (needDivider) {
    child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        Divider(
          indent: 55,
          endIndent: 15,
          height: 0.3,
          color: colorScheme.outline.withValues(alpha: 0.08),
        ),
      ],
    );
  }

  return Material(
    type: MaterialType.transparency,
    child: InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      onSecondaryTap: PlatformUtils.isMobile ? null : onLongPress,
      child: child,
    ),
  );
}

Widget _replyContentLayout({
  required Widget header,
  required Widget message,
  bool noPad = false,
  Widget? voteOption,
  Widget? pictures,
  Widget? actions,
  Widget? subReplies,
}) {
  final padding = EdgeInsets.only(left: noPad ? 6 : 45, right: 6);

  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      header,
      const SizedBox(height: 10),
      if (voteOption != null) Padding(padding: padding, child: voteOption),
      Padding(padding: padding, child: message),
      if (pictures != null) ...[
        Padding(padding: padding, child: pictures),
        const SizedBox(height: 4),
      ],
      if (actions != null) ...[
        const SizedBox(height: 4),
        actions,
      ],
      if (subReplies != null)
        Padding(padding: const .only(top: 5, bottom: 12), child: subReplies),
    ],
  );
}

Widget _replyHeaderLayout({
  required BuildContext context,
  required Widget avatar,
  required Widget userInfo,
  VoidCallback? onTap,
  String? cardImage,
  String? cardNumber,
  Color? cardFanColor,
}) {
  final header = GestureDetector(
    onTap: onTap,
    child: TranslucentRow(
      spacing: 12,
      extraWidth: 46,
      children: [
        avatar,
        Flexible(child: userInfo),
      ],
    ),
  );

  if (cardImage == null) return header;

  const double cardHeight = 38;

  return Stack(
    clipBehavior: Clip.none,
    children: [
      Positioned(
        top: 0,
        right: 0,
        height: cardHeight,
        child: CachedNetworkImage(
          height: cardHeight,
          memCacheHeight: cardHeight.cacheSize(context),
          imageUrl: ImageUtils.safeThumbnailUrl(cardImage),
          placeholder: (_, _) => const SizedBox.shrink(),
        ),
      ),
      if (cardNumber != null)
        Positioned(
          top: 0,
          right: 0,
          height: cardHeight,
          child: Center(
            child: Text(
              cardNumber,
              style: TextStyle(
                fontSize: 8,
                fontFamily: Assets.digitalNum,
                color: cardFanColor,
              ),
            ),
          ),
        ),
      Padding(padding: const .only(right: 80), child: header),
    ],
  );
}

Widget _replyUserInfoLayout({
  required Widget nameRow,
  required Widget timeLine,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [nameRow, timeLine],
  );
}

Widget _replyUserNameRow({
  required Widget name,
  Widget? level,
  Widget? trailing,
}) {
  return Row(
    spacing: 6,
    mainAxisSize: .min,
    children: [
      Flexible(child: name),
      ?level,
      ?trailing,
    ],
  );
}

Widget _replyTextButton({
  required String label,
  required TextStyle textStyle,
  required VoidCallback? onPressed,
  Widget? icon,
}) {
  return SizedBox(
    height: 32,
    child: TextButton(
      style: _replyTextButtonStyle,
      onPressed: onPressed,
      child: icon == null
          ? Text(label, style: textStyle)
          : Row(
              spacing: 3,
              mainAxisSize: .min,
              children: [
                icon,
                Text(label, style: textStyle),
              ],
            ),
    ),
  );
}

Widget _replyTranslateButton({
  required String label,
  required Color color,
  required TextStyle textStyle,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    height: 32,
    child: TextButton(
      style: _replyTextButtonStyle,
      onPressed: onPressed,
      child: Row(
        spacing: 3,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.translate, size: 16, color: color),
          Text(label, style: textStyle.copyWith(color: color)),
        ],
      ),
    ),
  );
}

Widget _replyActionBarLayout({
  required List<Widget> leftButtons,
  Widget? rightButton,
}) {
  return Row(
    spacing: 2,
    children: [
      const SizedBox(width: 36),
      ...leftButtons,
      if (rightButton != null) ...[
        const Spacer(),
        rightButton,
      ],
      const SizedBox(width: 5),
    ],
  );
}

Widget _replySubReplyListLayout({
  required BuildContext context,
  required List<Widget> items,
}) {
  final colorScheme = ColorScheme.of(context);
  return Padding(
    padding: const EdgeInsets.only(left: 42, right: 4),
    child: Material(
      animationDuration: Duration.zero,
      color: colorScheme.onInverseSurface,
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items,
      ),
    ),
  );
}

(EdgeInsets, BorderRadius?) _subReplyDecoration(int index, int length) {
  if (length == 1) {
    return const (.fromLTRB(8, 5, 8, 5), .all(.circular(6)));
  }
  if (index == 0) {
    return const (.fromLTRB(8, 8, 8, 4), .vertical(top: .circular(6)));
  }
  if (index == length - 1) {
    return const (.fromLTRB(8, 4, 8, 8), .vertical(bottom: .circular(6)));
  }
  return const (.fromLTRB(8, 4, 8, 4), null);
}

Widget _morePanelLayout({
  required BuildContext context,
  required List<Widget> items,
}) {
  final colorScheme = ColorScheme.of(context);
  return Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.viewPaddingOf(context).bottom + 20,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: Get.back,
          borderRadius: Style.bottomSheetRadius,
          child: SizedBox(
            height: 35,
            child: Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.outline,
                  borderRadius: const .all(.circular(3)),
                ),
                child: const SizedBox(width: 32, height: 3),
              ),
            ),
          ),
        ),
        ...items,
      ],
    ),
  );
}

// TODO: refa
class ReplyItemGrpc extends StatelessWidget {
  const ReplyItemGrpc({
    super.key,
    required this.replyItem,
    required this.replyLevel,
    this.replyReply,
    this.needDivider = true,
    this.onReply,
    this.onDelete,
    this.upMid,
    this.dialogueCallback,
    this.getReplyChain,
    this.getTag,
    this.onViewImage,
    this.onCheckReply,
    this.onToggleTop,
    this.depth = -1,
    this.reason,
  });
  final ReplyInfo replyItem;
  final int replyLevel;
  final void Function(ReplyInfo replyItem, int? rpid)? replyReply;
  final bool needDivider;
  final ValueChanged<ReplyInfo>? onReply;
  final void Function(ReplyInfo replyItem, int? subIndex)? onDelete;
  final Int64? upMid;
  final VoidCallback? dialogueCallback;
  final ValueGetter<Iterable<ReplyInfo>>? getReplyChain;
  final ValueGetter<String>? getTag;
  final VoidCallback? onViewImage;
  final ValueChanged<ReplyInfo>? onCheckReply;
  final ValueChanged<ReplyInfo>? onToggleTop;
  final int depth;
  final ReasonType? reason;

  static final _voteRegExp = RegExp(r"^\{vote:\d+?\}$");
  static final _timeRegExp = RegExp(r'^(?:\d+[:：])?\d+[:：]\d+$');
  static bool enableWordRe = Pref.enableWordRe;
  static int? replyLengthLimit = Pref.replyLengthLimit;

  void _showMore(BuildContext context) => showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxWidth: min(640, context.mediaQueryShortestSide),
    ),
    builder: (context) => _morePanel(
      context: context,
      item: replyItem,
      onDelete: onDelete == null ? null : () => onDelete!(replyItem, null),
      isSubReply: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return reason != null
        ? _buildPlaceholder(context, colorScheme)
        : _buildCommon(context, colorScheme);
  }

  Widget _buildPlaceholder(BuildContext context, ColorScheme colorScheme) {
    return _replyItemLayout(
      context: context,
      depth: depth,
      needDivider: needDivider,
      onTap: () {}, // 使InkWell能点着玩
      content: _replyContentLayout(
        noPad: replyLevel == 0,
        header: _buildHeader(context, colorScheme),
        message: TextMore(
          reason!.desc,
          primary: colorScheme.primary,
          style: TextStyle(
            height: 1.75,
            fontSize: 14,
            color: colorScheme.error,
          ),
        ),
      ),
    );
  }

  Widget _buildCommon(BuildContext context, ColorScheme colorScheme) {
    final replyControl = replyItem.replyControl;
    return _replyItemLayout(
      context: context,
      depth: depth,
      needDivider: needDivider,
      onTap: replyReply == null ? null : () => replyReply!(replyItem, null),
      onLongPress: replyLevel == 0 ? null : () => _showMore(context),
      content: _replyContentLayout(
        noPad: replyLevel == 0,
        header: _buildHeader(context, colorScheme),
        voteOption: replyControl.hasVoteOption()
            ? _buildVoteOption(colorScheme, replyControl.voteOption)
            : null,
        message: _buildMessageWidget(context, colorScheme, replyControl),
        pictures: _buildPictures(),
        actions: replyLevel == 0
            ? null
            : _buttonAction(context, colorScheme, replyControl),
        subReplies: replyLevel == 1 && replyItem.count > Int64.ZERO
            ? _replyItemRow(context, colorScheme, replyItem.replies)
            : null,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    final member = replyItem.member;
    final hasCard =
        PendantAvatar.showDecorate &&
        replyItem.hasMemberV2() &&
        replyItem.memberV2.garb.hasCardImage();
    final hasCardNumber = hasCard && replyItem.memberV2.garb.hasCardNumber();

    return _replyHeaderLayout(
      context: context,
      onTap: replyItem.mid.isZero
          ? null
          : () {
              feedBack();
              Get.toNamed('/member?mid=${replyItem.mid}');
            },
      avatar: PendantAvatar(
        member.face,
        size: 34,
        badgeSize: 14,
        vipStatus: member.vipStatus.toInt(),
        officialType: member.hasOfficialVerifyType()
            ? member.officialVerifyType.toInt()
            : null,
        pendantImage: member.hasGarbPendantImage()
            ? member.garbPendantImage
            : null,
      ),
      userInfo: _buildUserInfo(colorScheme),
      cardImage: hasCard ? replyItem.memberV2.garb.cardImage : null,
      cardNumber: hasCardNumber
          ? '${replyItem.memberV2.garb.fanNumPrefix}\n${replyItem.memberV2.garb.cardNumber}'
          : null,
      cardFanColor: hasCardNumber
          ? ColourUtils.parseColor(replyItem.memberV2.garb.cardFanColor)
          : null,
    );
  }

  Widget _buildUserInfo(ColorScheme colorScheme) {
    final member = replyItem.member;
    final isVip = member.vipStatus > 0 && member.vipType == 2;

    Widget? trailing;
    if (replyItem.hasMid() && upMid == replyItem.mid) {
      trailing = const PBadge(
        text: 'UP',
        size: .small,
        isStack: false,
        fontSize: 9,
      );
    } else if (GlobalData().showMedal && member.hasFansMedalLevel()) {
      trailing = MedalWidget(
        medalName: member.fansMedalName,
        level: member.fansMedalLevel.toInt(),
        backgroundColor: DmUtils.decimalToColor(member.fansMedalColor.toInt()),
        nameColor: DmUtils.decimalToColor(member.fansMedalColorName.toInt()),
        padding: const .symmetric(horizontal: 6, vertical: 1.5),
      );
    }

    return _replyUserInfoLayout(
      nameRow: _replyUserNameRow(
        name: Text(
          member.name,
          maxLines: 1,
          overflow: .ellipsis,
          style: TextStyle(
            color: isVip ? colorScheme.vipColor : colorScheme.outline,
            fontSize: 13,
          ),
        ),
        level: BiliUtils.levelPicture(
          member.level.toInt(),
          isSeniorMember: member.isSeniorMember == 1,
          height: 11,
        ),
        trailing: trailing,
      ),
      timeLine: Text.rich(
        maxLines: 1,
        overflow: .ellipsis,
        style: TextStyle(fontSize: 11, color: colorScheme.outline),
        TextSpan(
          text: replyLevel == 0
              ? DateFormatUtils.format(
                  replyItem.ctime.toInt(),
                  format: DateFormatUtils.longFormatDs,
                )
              : DateFormatUtils.dateFormat(replyItem.ctime.toInt()),
          children: replyItem.replyControl.hasLocation()
              ? [
                  TextSpan(
                    text: ' • ${replyItem.replyControl.location}',
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  Widget _buildVoteOption(
    ColorScheme colorScheme,
    ReplyControl_VoteOption voteOption,
  ) {
    return Text.rich(
      TextSpan(
        children: [
          switch (voteOption.labelKind) {
            .RED => TextSpan(
              text: '红方  ',
              style: TextStyle(color: colorScheme.vipColor),
            ),
            .BLUE => TextSpan(
              text: '蓝方  ',
              style: TextStyle(color: colorScheme.blue),
            ),
            _ => TextSpan(
              text: '投票  ',
              style: TextStyle(color: colorScheme.outline),
            ),
          },
          TextSpan(text: voteOption.desc),
        ],
      ),
      style: TextStyle(
        height: 1.75,
        fontSize: 12,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildMessageWidget(
    BuildContext context,
    ColorScheme colorScheme,
    ReplyControl replyControl,
  ) {
    return TextMore.rich(
      primary: colorScheme.primary,
      style: const TextStyle(height: 1.75, fontSize: 14),
      maxLines: replyLevel == 1 ? replyLengthLimit : null,
      TextSpan(
        children: [
          if (replyControl.isUpTop) ...[
            const WidgetSpan(
              alignment: .middle,
              child: PBadge(
                text: 'TOP',
                size: .small,
                isStack: false,
                type: .line_primary,
                fontSize: 9,
                textScaleFactor: 1,
              ),
            ),
            const TextSpan(text: ' '),
          ],
          _buildMessage(
            context,
            colorScheme,
            replyControl.showTranslation
                ? replyItem.translatedContent
                : replyItem.content,
            replyControl,
          ),
        ],
      ),
    );
  }

  Widget? _buildPictures() {
    final pictures = replyItem.content.pictures;
    if (pictures.isEmpty) return null;
    return ImageGridView(
      picArr: pictures
          .map(
            (item) => ImageModel(
              width: item.imgWidth,
              height: item.imgHeight,
              url: item.imgSrc,
            ),
          )
          .toList(),
      onViewImage: onViewImage,
    );
  }

  Widget _buildTranslateBtn(
    BuildContext context,
    ColorScheme colorScheme,
    ReplyControl replyControl,
    TextStyle textStyle,
  ) {
    late bool isProcessing = false;
    final color = replyControl.showTranslation
        ? colorScheme.primary
        : colorScheme.outline.withValues(alpha: 0.8);
    return _replyTranslateButton(
      label: replyControl.showTranslation ? '原文' : '翻译',
      color: color,
      textStyle: textStyle,
      onPressed: () async {
        if (replyControl.showTranslation) {
          replyControl.showTranslation = false;
          (context as Element).markNeedsBuild();
        } else {
          if (isProcessing) return;
          if (replyItem.hasTranslatedContent()) {
            replyControl.showTranslation = true;
            (context as Element).markNeedsBuild();
            return;
          }
          isProcessing = true;
          final res = await ReplyGrpc.translateReply(
            type: replyItem.type,
            oid: replyItem.oid,
            rpid: replyItem.id,
          );
          if (res case Success(:final response)) {
            final item = response.translatedReplies[replyItem.id];
            if (item != null && item.hasTranslatedContent()) {
              replyControl.showTranslation = true;
              replyItem.translatedContent = item.translatedContent;
              if (context.mounted) {
                (context as Element).markNeedsBuild();
              }
            } else {
              SmartDialog.showToast('翻译结果为空');
            }
          } else if (res case Error(:final errMsg)) {
            SmartDialog.showToast('翻译失败: $errMsg');
          }
          isProcessing = false;
        }
      },
    );
  }

  Widget _buttonAction(
    BuildContext context,
    ColorScheme colorScheme,
    ReplyControl replyControl,
  ) {
    final textStyle = TextStyle(
      height: 1,
      fontSize: 12,
      fontWeight: .normal,
      color: colorScheme.outline,
    );

    Widget? dialogBtn;
    if (replyLevel == 2 && needDivider && replyItem.id != replyItem.dialog) {
      dialogBtn = _replyTextButton(
        label: '查看对话',
        textStyle: textStyle,
        onPressed: dialogueCallback,
      );
    } else if (replyLevel == 3 && replyItem.parent != replyItem.root) {
      dialogBtn = _replyTextButton(
        label: '跳转回复',
        textStyle: textStyle,
        onPressed: dialogueCallback,
      );
    }

    return _replyActionBarLayout(
      leftButtons: [
        if (onReply != null)
          _replyTextButton(
            label: '回复',
            textStyle: textStyle,
            icon: Icon(
              Icons.reply,
              size: 18,
              color: colorScheme.outline.withValues(alpha: 0.8),
            ),
            onPressed: () {
              feedBack();
              onReply!(replyItem);
            },
          ),
        if (replyControl.translationSwitch ==
            .TRANSLATION_SWITCH_SHOW_TRANSLATION)
          _buildTranslateBtn(
            context,
            colorScheme,
            replyControl,
            textStyle,
          )
        else if (replyControl.cardLabels.isNotEmpty)
          Text(
            dialogBtn != null
                ? replyControl.cardLabels.first.textContent
                : replyControl.cardLabels.map((e) => e.textContent).join('  '),
            style: textStyle.copyWith(color: colorScheme.secondary),
          ),
        ?dialogBtn,
      ],
      rightButton: ZanButtonGrpc(replyItem: replyItem),
    );
  }

  Widget _replyItemRow(
    BuildContext context,
    ColorScheme colorScheme,
    List<ReplyInfo> replies,
  ) {
    final extraRow = replies.length < replyItem.count.toInt();
    final length = replies.length + (extraRow ? 1 : 0);

    return _replySubReplyListLayout(
      context: context,
      items: [
        for (var i = 0; i < replies.length; i++)
          _buildSubReplyItem(
            context: context,
            colorScheme: colorScheme,
            childReply: replies[i],
            index: i,
            length: length,
          ),
        if (extraRow)
          _buildMoreRepliesRow(colorScheme: colorScheme, length: length),
      ],
    );
  }

  Widget _buildSubReplyItem({
    required BuildContext context,
    required ColorScheme colorScheme,
    required ReplyInfo childReply,
    required int index,
    required int length,
  }) {
    final (padding, borderRadius) = _subReplyDecoration(index, length);

    void showMore() => showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxWidth: min(640, context.mediaQueryShortestSide),
      ),
      builder: (context) => _morePanel(
        context: context,
        item: childReply,
        onDelete: onDelete == null ? null : () => onDelete!(replyItem, index),
        isSubReply: true,
      ),
    );

    return InkWell(
      borderRadius: borderRadius,
      onTap: () => replyReply?.call(replyItem, childReply.id.toInt()),
      onLongPress: showMore,
      onSecondaryTap: PlatformUtils.isMobile ? null : showMore,
      child: Padding(
        padding: padding,
        child: TextEllipsis.rich(
          style: TextStyle(
            height: 1.6,
            fontSize: 14,
            color: colorScheme.onSurface.withValues(alpha: 0.85),
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          TextSpan(
            children: [
              TextSpan(
                text: childReply.member.name,
                style: TextStyle(color: colorScheme.primary),
                recognizer: NoDeadlineTapGestureRecognizer()
                  ..onTap = () {
                    feedBack();
                    Get.toNamed(
                      '/member?mid=${childReply.member.mid}',
                    );
                  },
              ),
              if (childReply.mid == upMid) ...[
                const TextSpan(text: ' '),
                const WidgetSpan(
                  alignment: .middle,
                  child: PBadge(
                    text: 'UP',
                    size: .small,
                    isStack: false,
                    fontSize: 9,
                    textScaleFactor: 1,
                  ),
                ),
                const TextSpan(text: ' '),
              ],
              if (childReply.root == childReply.parent)
                const TextSpan(text: ': ')
              else if (childReply.mid != upMid)
                const TextSpan(text: ' '),
              _buildMessage(
                context,
                colorScheme,
                childReply.content,
                childReply.replyControl,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoreRepliesRow({
    required ColorScheme colorScheme,
    required int length,
  }) {
    final isSingle = length == 1;
    return InkWell(
      onTap: () => replyReply?.call(replyItem, null),
      borderRadius: isSingle
          ? const .all(.circular(6))
          : const .vertical(bottom: .circular(6)),
      child: Padding(
        padding: isSingle
            ? const .fromLTRB(8, 6, 8, 6)
            : const .fromLTRB(8, 5, 8, 8),
        child: Text.rich(
          TextSpan(
            style: const TextStyle(fontSize: 12),
            children: [
              if (replyItem.replyControl.upReply)
                TextSpan(
                  text: 'UP主等人 ',
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.85),
                  ),
                ),
              TextSpan(
                text: '共${replyItem.count}条回复',
                style: TextStyle(color: colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InlineSpan _buildMessage(
    BuildContext context,
    ColorScheme colorScheme,
    Content content,
    ReplyControl replyControl,
  ) {
    final List<InlineSpan> spanChildren = <InlineSpan>[];
    bool hasNote = false;

    final urlKeys = content.urls.keys;
    // 构建正则表达式
    final List<String> specialTokens = [
      ...content.emotes.keys,
      ...content.topics.keys.map((e) => '#$e#'),
      ...content.atNameToMid.keys.map((e) => '@$e'),
      ...urlKeys,
    ];
    String patternStr = [
      ...specialTokens.map(RegExp.escape),
      r'(?:\d+[:：])?\d+[:：]\d+',
      r'\{vote:\d+?\}',
      Constants.urlRegex.pattern,
    ].join('|');
    final RegExp pattern = RegExp(patternStr);

    late List<String> matchedUrls = [];

    void addPlainTextSpan(str) {
      spanChildren.add(TextSpan(text: str));
    }

    void addUrl(String matchStr, Url url, {bool addPlainText = false}) {
      if (url.extra.isWordSearch && !enableWordRe) {
        if (addPlainText) {
          addPlainTextSpan(matchStr);
        }
        return;
      }
      final isCv = url.clickReport.startsWith('{"cvid');
      if (isCv) {
        hasNote = true;
      }
      final children = [
        if (!isCv && url.hasPrefixIcon())
          WidgetSpan(
            child: CachedNetworkImage(
              height: 19,
              memCacheHeight: 19.cacheSize(context),
              color: colorScheme.primary,
              imageUrl: ImageUtils.thumbnailUrl(url.prefixIcon),
              placeholder: (_, _) => const SizedBox.shrink(),
            ),
          ),
        TextSpan(
          text: isCv ? '[笔记] ' : url.title,
          style: TextStyle(color: colorScheme.primary),
          recognizer: NoDeadlineTapGestureRecognizer()
            ..onTap = () {
              if (url.appUrlSchema.isEmpty) {
                if (RegExp(
                  r'^(av|bv)',
                  caseSensitive: false,
                ).hasMatch(matchStr)) {
                  UrlUtils.matchUrlPush(matchStr, '');
                } else {
                  RegExpMatch? match = RegExp(
                    r'^cv(\d+)$|/read/cv(\d+)|note-app/view\?cvid=(\d+)',
                    caseSensitive: false,
                  ).firstMatch(matchStr);
                  String? cvid =
                      match?.group(1) ?? match?.group(2) ?? match?.group(3);
                  if (cvid != null) {
                    Get.toNamed(
                      '/articlePage',
                      parameters: {
                        'id': cvid,
                        'type': 'read',
                      },
                    );
                    return;
                  }
                  PageUtils.handleWebview(matchStr);
                }
              } else {
                if (url.extra.isWordSearch) {
                  Get.toNamed(
                    '/searchResult',
                    parameters: {'keyword': url.title},
                  );
                } else {
                  PageUtils.handleWebview(matchStr);
                }
              }
            },
        ),
      ];
      if (isCv) {
        spanChildren.insertAll(0, children);
      } else {
        spanChildren.addAll(children);
      }
    }

    // 分割文本并处理每个部分
    content.message.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        String matchStr = match[0]!;
        late final name = matchStr.substring(1);
        late final topic = matchStr.substring1;
        if (content.emotes.containsKey(matchStr)) {
          // 处理表情
          final emote = content.emotes[matchStr]!;
          final size = emote.size.toInt() * 20.0;
          final url = emote.hasWebpUrl()
              ? emote.webpUrl
              : emote.hasGifUrl()
              ? emote.gifUrl
              : emote.url;
          spanChildren.add(
            WidgetSpan(
              child: emoteTooltipBuilder(
                url: url,
                emote: matchStr,
                triggerMode: .tap,
                jumpUrl: emote.hasJumpUrl() ? emote.jumpUrl : null,
                colorScheme: colorScheme,
                child: NetworkImgLayer(
                  src: url,
                  type: .emote,
                  width: size,
                  height: size,
                ),
              ),
            ),
          );
        } else if (matchStr.startsWith("@") &&
            content.atNameToMid.containsKey(name)) {
          // 处理@用户
          spanChildren.add(
            TextSpan(
              text: matchStr,
              style: TextStyle(color: colorScheme.primary),
              recognizer: NoDeadlineTapGestureRecognizer()
                ..onTap = () =>
                    Get.toNamed('/member?mid=${content.atNameToMid[name]}'),
            ),
          );
        } else if (_voteRegExp.hasMatch(matchStr)) {
          spanChildren.add(
            TextSpan(
              text: '投票: ${content.vote.title}',
              style: TextStyle(color: colorScheme.primary),
              recognizer: NoDeadlineTapGestureRecognizer()
                ..onTap = () =>
                    showVoteDialog(context, content.vote.id.toInt()),
            ),
          );
        } else if (_timeRegExp.hasMatch(matchStr)) {
          matchStr = matchStr.replaceAll('：', ':');
          bool isValid = false;
          try {
            final ctr = Get.find<VideoDetailController>(
              tag: getTag?.call() ?? Get.arguments['heroTag'],
            );
            isValid =
                DurationUtils.parseDuration(matchStr) * 1000 <=
                ctr.data.timeLength!;
          } catch (e) {
            if (kDebugMode) debugPrint('failed to validate: $e');
          }
          spanChildren.add(
            TextSpan(
              text: isValid ? ' $matchStr ' : matchStr,
              style: isValid ? TextStyle(color: colorScheme.primary) : null,
              recognizer: isValid
                  ? (NoDeadlineTapGestureRecognizer()
                      ..onTap = () {
                        try {
                          SmartDialog.showToast('跳转至：$matchStr');
                          Get.find<VideoDetailController>(
                            tag: Get.arguments['heroTag'],
                          ).plPlayerController.seekTo(
                            Duration(
                              seconds: DurationUtils.parseDuration(matchStr),
                            ),
                            isSeek: false,
                          );
                        } catch (e) {
                          SmartDialog.showToast('跳转失败: $e');
                        }
                      })
                  : null,
            ),
          );
        } else {
          final url = content.urls[matchStr];
          if (url != null && !matchedUrls.contains(matchStr)) {
            addUrl(matchStr, url, addPlainText: true);
            // 只显示一次
            matchedUrls.add(matchStr);
          } else if (matchStr.length > 1 && content.topics[topic] != null) {
            spanChildren.add(
              TextSpan(
                text: matchStr,
                style: TextStyle(color: colorScheme.primary),
                recognizer: NoDeadlineTapGestureRecognizer()
                  ..onTap = () {
                    Get.toNamed(
                      '/searchResult',
                      parameters: {'keyword': topic},
                    );
                  },
              ),
            );
          } else if (Constants.urlRegex.hasMatch(matchStr)) {
            spanChildren.add(
              TextSpan(
                text: matchStr,
                style: TextStyle(color: colorScheme.primary),
                recognizer: NoDeadlineTapGestureRecognizer()
                  ..onTap = () => PageUtils.handleWebview(matchStr),
              ),
            );
          } else {
            addPlainTextSpan(matchStr);
          }
        }
        return '';
      },
      onNonMatch: (String nonMatchStr) {
        addPlainTextSpan(nonMatchStr);
        return nonMatchStr;
      },
    );

    // if (urlKeys.isNotEmpty) {
    //   List<String> unmatchedItems = urlKeys
    //       .where((url) => !matchedUrls.contains(url))
    //       .toList();
    //   if (unmatchedItems.isNotEmpty) {
    //     for (final patternStr in unmatchedItems) {
    //       addUrl(patternStr, content.urls[patternStr]!);
    //     }
    //   }
    // }

    if (!hasNote && replyControl.isNote && replyControl.isNoteV2) {
      final Color color;
      NoDeadlineTapGestureRecognizer? recognizer;

      final hasClickUrl = content.richText.note.hasClickUrl();
      if (hasClickUrl || content.richText.opus.hasOpusId()) {
        color = colorScheme.primary;
        recognizer = NoDeadlineTapGestureRecognizer()
          ..onTap = () => hasClickUrl
              ? PiliScheme.routePushFromUrl(content.richText.note.clickUrl)
              : Get.toNamed(
                  '/articlePage',
                  parameters: {
                    'id': content.richText.opus.opusId.toString(),
                    'type': 'opus',
                  },
                );
      } else {
        color = colorScheme.secondary;
      }
      spanChildren.insert(
        0,
        TextSpan(
          text: '[笔记] ',
          style: TextStyle(color: color),
          recognizer: recognizer,
        ),
      );
    }

    return TextSpan(children: spanChildren);
  }

  Widget _morePanel({
    required BuildContext context,
    required ReplyInfo item,
    required VoidCallback? onDelete,
    required bool isSubReply,
  }) {
    late final message = item.content.message;
    final ownerMid = Int64(Accounts.main.mid);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final errorColor = colorScheme.error;
    final style = theme.textTheme.titleSmall!;

    return _morePanelLayout(
      context: context,
      items: [
        if (kDebugMode && GStorage.reply != null) ...[
          ListTile(
            onTap: () {
              Get.back();
              GStorage.reply!.put(
                item.id.toString(),
                (item.deepCopy()
                      ..unknownFields.clear()
                      ..replies.clear()
                      ..clearTrackInfo())
                    .writeToBuffer(),
              );
            },
            title: Text(
              'save to local',
              style: style.copyWith(color: colorScheme.primary),
            ),
          ),
          ListTile(
            onTap: () {
              Get.back();
              onDelete?.call();
              GStorage.reply!.delete(item.id.toString());
            },
            title: Text(
              'remove from local',
              style: style.copyWith(color: colorScheme.primary),
            ),
          ),
          ListTile(
            onTap: () {
              Get.back();
              final oid = item.oid.toInt();
              final data =
                  (item.deepCopy()
                        ..unknownFields.clear()
                        ..replies.clear()
                        ..clearTrackInfo())
                      .writeToBuffer();
              GStorage.reply!.putAll({
                for (var i = oid; i < oid + 1000; i++) i.toString(): data,
              });
            },
            title: Text(
              'save to local (x1000)',
              style: style.copyWith(color: colorScheme.primary),
            ),
          ),
        ],
        if (ownerMid == upMid || ownerMid == item.member.mid)
          ListTile(
            onTap: () async {
              Get.back();
              bool? isDelete = await showDialog<bool>(
                context: context,
                builder: (context) {
                  final colorScheme = ColorScheme.of(context);
                  return AlertDialog(
                    title: const Text('删除评论'),
                    content: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: '确定删除这条评论吗？\n\n'),
                          if (ownerMid != item.member.mid) ...[
                            TextSpan(
                              text: '@${item.member.name}',
                              style: TextStyle(color: colorScheme.primary),
                            ),
                            const TextSpan(text: ':\n'),
                          ],
                          TextSpan(text: message),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: false),
                        child: Text(
                          '取消',
                          style: TextStyle(color: colorScheme.outline),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.back(result: true),
                        child: const Text('确定'),
                      ),
                    ],
                  );
                },
              );
              if (isDelete == null || !isDelete) {
                return;
              }
              SmartDialog.showLoading(msg: '删除中...');
              final res = await VideoHttp.replyDel(
                type: item.type.toInt(),
                oid: item.oid.toInt(),
                rpid: item.id.toInt(),
              );
              SmartDialog.dismiss();
              if (res.isSuccess) {
                SmartDialog.showToast('删除成功');
                onDelete?.call();
              } else {
                SmartDialog.showToast('删除失败, $res');
              }
            },
            minLeadingWidth: 0,
            leading: Icon(Icons.delete_outlined, color: errorColor, size: 19),
            title: Text('删除', style: style.copyWith(color: errorColor)),
          ),
        if (ownerMid.isZero)
          ListTile(
            onTap: () {
              Get.back();
              Pref.setBlackMid(item.mid.toInt());
              onDelete?.call();
              SmartDialog.showToast('屏蔽成功');
              return;
            },
            minLeadingWidth: 0,
            leading: Icon(Icons.error_outline, color: errorColor, size: 19),
            title: Text(
              '屏蔽',
              style: TextStyle(fontSize: 14, color: errorColor),
            ),
          )
        else
          ListTile(
            onTap: () {
              Get.back();

              final oid = item.oid;
              final rpid = item.id;

              autoWrapReportDialog(
                context,
                onRemove: onDelete,
                mid: () => item.mid.toInt(),
                ReportOptions.commentReport,
                withContent: ReportOptions.withContentReply,
                contentRequired: ReportOptions.contentRequiredReply,
                reportUrl:
                    'https://www.bilibili.com/h5/comment/report?oid=$oid&pageType=${item.type}&rpid=$rpid&platform=android&build=8430300&${ThemeUtils.themeUrl(colorScheme.isDark)}',
                (reasonType, reasonDesc, banUid) async {
                  final res = await ReplyHttp.report(
                    rpid: rpid,
                    oid: oid,
                    reasonType: reasonType,
                    reasonDesc: reasonDesc,
                    banUid: banUid,
                  );
                  if (res.isSuccess) {
                    onDelete?.call();
                  }
                  return res;
                },
              );
            },
            minLeadingWidth: 0,
            leading: Icon(Icons.error_outline, color: errorColor, size: 19),
            title: Text('举报', style: style.copyWith(color: errorColor)),
          ),
        if (replyLevel == 1 && !isSubReply && ownerMid == upMid)
          ListTile(
            onTap: () {
              Get.back();
              onToggleTop?.call(item);
            },
            minLeadingWidth: 0,
            leading: const Icon(Icons.vertical_align_top, size: 19),
            title: Text(
              '${replyItem.replyControl.isUpTop ? '取消' : ''}置顶',
              style: style,
            ),
          ),
        ListTile(
          onTap: () {
            Get.back();
            Utils.copyText(message);
          },
          minLeadingWidth: 0,
          leading: const Icon(Icons.copy_all_outlined, size: 19),
          title: Text('复制全部', style: style),
        ),
        ListTile(
          onTap: () {
            Get.back();
            showReplyCopyDialog(context, message, item.content.emotes);
          },
          minLeadingWidth: 0,
          leading: const Icon(Icons.copy_outlined, size: 19),
          title: Text('自由复制', style: style),
        ),
        ListTile(
          onTap: () {
            Get.back();
            SavePanel.toSavePanel(upMid: upMid, item: item);
          },
          minLeadingWidth: 0,
          leading: const Icon(Icons.save_alt, size: 19),
          title: Text('保存评论', style: style),
        ),
        if (getReplyChain != null && item.id != item.root)
          ListTile(
            onTap: () {
              Get.back();
              SavePanel.toSavePanel(upMid: upMid, item: getReplyChain!());
            },
            minLeadingWidth: 0,
            leading: const Icon(Icons.save_alt, size: 19),
            title: Text('保存评论链', style: style),
          ),
        if (kDebugMode || item.mid == ownerMid)
          ListTile(
            onTap: () {
              Get.back();
              onCheckReply?.call(item);
            },
            minLeadingWidth: 0,
            leading: const Icon(CustomIcons.shield_reply, size: 19),
            title: Text('检查评论', style: style),
          ),
      ],
    );
  }
}
