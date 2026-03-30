import 'dart:math';

import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/dialog/report.dart';
import 'package:PiliPlus/common/widgets/extra_hit_test_widget.dart';
import 'package:PiliPlus/common/widgets/flutter/text/text.dart' as custom_text;
import 'package:PiliPlus/common/widgets/gesture/tap_gesture_recognizer.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/image_grid/image_grid_view.dart';
import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo, ReplyControl, Content, Url;
import 'package:PiliPlus/http/reply.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/pages/dynamics/widgets/vote.dart';
import 'package:PiliPlus/pages/member/widget/medal_widget.dart';
import 'package:PiliPlus/pages/save_panel/view.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/reply/widgets/zan_grpc.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/danmaku_utils.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension/context_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/url_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:protobuf/protobuf.dart';

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
    this.showDialogue,
    this.getTag,
    this.onViewImage,
    this.onCheckReply,
    this.onToggleTop,
    this.jumpToDialogue,
  });
  final ReplyInfo replyItem;
  final int replyLevel;
  final Function(ReplyInfo replyItem, int? rpid)? replyReply;
  final bool needDivider;
  final ValueChanged<ReplyInfo>? onReply;
  final Function(ReplyInfo replyItem, int? subIndex)? onDelete;
  final Int64? upMid;
  final VoidCallback? showDialogue;
  final Function? getTag;
  final VoidCallback? onViewImage;
  final ValueChanged<ReplyInfo>? onCheckReply;
  final ValueChanged<ReplyInfo>? onToggleTop;
  final VoidCallback? jumpToDialogue;

  static final _voteRegExp = RegExp(r"^\{vote:\d+?\}$");
  static final _timeRegExp = RegExp(r'^(?:\d+[:：])?\d+[:：]\d+$');
  static bool enableWordRe = Pref.enableWordRe;
  static int? replyLengthLimit = Pref.replyLengthLimit;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    void showMore() => showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxWidth: min(640, context.mediaQueryShortestSide),
      ),
      builder: (context) {
        return morePanel(
          context: context,
          item: replyItem,
          onDelete: () => onDelete?.call(replyItem, null),
          isSubReply: false,
        );
      },
    );

    Widget child = Padding(
      padding: const .fromLTRB(12, 14, 8, 5),
      child: _buildContent(context, theme),
    );
    if (needDivider) {
      child = Column(
        mainAxisSize: .min,
        children: [
          child,
          Divider(
            indent: 55,
            endIndent: 15,
            height: 0.3,
            color: theme.colorScheme.outline.withValues(alpha: 0.08),
          ),
        ],
      );
    }
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => replyReply?.call(replyItem, null),
        onLongPress: showMore,
        onSecondaryTap: PlatformUtils.isMobile ? null : showMore,
        child: child,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    final member = replyItem.member;
    Widget header = GestureDetector(
      onTap: () {
        feedBack();
        Get.toNamed('/member?mid=${replyItem.mid}');
      },
      child: ExtraHitTestWidget(
        width: 46,
        child: Row(
          crossAxisAlignment: .center,
          spacing: 12,
          children: [
            PendantAvatar(
              member.face,
              size: 34,
              badgeSize: 14,
              vipStatus: member.vipStatus.toInt(),
              officialType: member.officialVerifyType.toInt(),
              pendantImage: member.hasGarbPendantImage()
                  ? member.garbPendantImage
                  : null,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    spacing: 6,
                    children: [
                      Flexible(
                        child: Text(
                          member.name,
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: TextStyle(
                            color: (member.vipStatus > 0 && member.vipType == 2)
                                ? theme.colorScheme.vipColor
                                : theme.colorScheme.outline,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Image.asset(
                        Utils.levelName(
                          member.level,
                          isSeniorMember: member.isSeniorMember == 1,
                        ),
                        height: 11,
                        cacheHeight: 11.cacheSize(context),
                      ),
                      if (replyItem.mid == upMid)
                        const PBadge(
                          text: 'UP',
                          size: PBadgeSize.small,
                          isStack: false,
                          fontSize: 9,
                        )
                      else if (GlobalData().showMedal &&
                          member.hasFansMedalLevel())
                        MedalWidget(
                          medalName: member.fansMedalName,
                          level: member.fansMedalLevel.toInt(),
                          backgroundColor: DmUtils.decimalToColor(
                            member.fansMedalColor.toInt(),
                          ),
                          nameColor: DmUtils.decimalToColor(
                            member.fansMedalColorName.toInt(),
                          ),
                          padding: const .symmetric(
                            horizontal: 6,
                            vertical: 1.5,
                          ),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        replyLevel == 0
                            ? DateFormatUtils.format(
                                replyItem.ctime.toInt(),
                                format: DateFormatUtils.longFormatDs,
                              )
                            : DateFormatUtils.dateFormat(
                                replyItem.ctime.toInt(),
                              ),
                        style: TextStyle(
                          fontSize: theme.textTheme.labelSmall!.fontSize,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      if (replyItem.replyControl.hasLocation())
                        Text(
                          ' • ${replyItem.replyControl.location}',
                          style: TextStyle(
                            fontSize: theme.textTheme.labelSmall!.fontSize,
                            color: theme.colorScheme.outline,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (PendantAvatar.showDecorate) {
      final garb = replyItem.memberV2.garb;
      if (garb.hasCardImage()) {
        const double height = 38.0;
        return Stack(
          clipBehavior: .none,
          children: [
            Positioned(
              top: 0,
              right: 0,
              height: height,
              child: CachedNetworkImage(
                height: height,
                memCacheHeight: height.cacheSize(context),
                imageUrl: ImageUtils.safeThumbnailUrl(garb.cardImage),
                placeholder: (_, _) => const SizedBox.shrink(),
              ),
            ),
            if (garb.hasCardNumber())
              Positioned(
                top: 0,
                right: 0,
                height: height,
                child: Center(
                  child: Text(
                    '${garb.fanNumPrefix}\n${garb.cardNumber}',
                    style: TextStyle(
                      fontSize: 8,
                      fontFamily: Assets.digitalNum,
                      color: Utils.parseColor(garb.cardFanColor),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const .only(right: 80),
              child: header,
            ),
          ],
        );
      }
    }
    return header;
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    final padding = EdgeInsets.only(left: replyLevel == 0 ? 6 : 45, right: 6);
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        _buildHeader(context, theme),
        const SizedBox(height: 10),
        Padding(
          padding: padding,
          child: custom_text.Text.rich(
            primary: theme.colorScheme.primary,
            style: TextStyle(
              height: 1.75,
              fontSize: theme.textTheme.bodyMedium!.fontSize,
            ),
            maxLines: replyLevel == 1 ? replyLengthLimit : null,
            TextSpan(
              children: [
                if (replyItem.replyControl.isUpTop) ...[
                  const WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: PBadge(
                      text: 'TOP',
                      size: PBadgeSize.small,
                      isStack: false,
                      type: PBadgeType.line_primary,
                      fontSize: 9,
                      textScaleFactor: 1,
                    ),
                  ),
                  const TextSpan(text: ' '),
                ],
                _buildMessage(context, theme, replyItem),
              ],
            ),
          ),
        ),
        if (replyItem.content.pictures.isNotEmpty) ...[
          Padding(
            padding: padding,
            child: ImageGridView(
              picArr: replyItem.content.pictures
                  .map(
                    (item) => ImageModel(
                      width: item.imgWidth,
                      height: item.imgHeight,
                      url: item.imgSrc,
                    ),
                  )
                  .toList(),
              onViewImage: onViewImage,
            ),
          ),
          const SizedBox(height: 4),
        ],
        if (replyLevel != 0) ...[
          const SizedBox(height: 4),
          buttonAction(context, theme, replyItem.replyControl),
        ],
        if (replyLevel == 1 && replyItem.count > Int64.ZERO) ...[
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 12),
            child: replyItemRow(context, theme, replyItem.replies),
          ),
        ],
      ],
    );
  }

  Widget buttonAction(
    BuildContext context,
    ThemeData theme,
    ReplyControl replyControl,
  ) {
    final textStyle = TextStyle(
      fontSize: theme.textTheme.labelMedium!.fontSize,
      color: theme.colorScheme.outline,
      fontWeight: FontWeight.normal,
    );
    final buttonStyle = TextButton.styleFrom(
      padding: EdgeInsets.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
    return Row(
      children: [
        const SizedBox(width: 36),
        SizedBox(
          height: 32,
          child: TextButton(
            style: buttonStyle,
            onPressed: () {
              feedBack();
              onReply?.call(replyItem);
            },
            child: Row(
              children: [
                Icon(
                  Icons.reply,
                  size: 18,
                  color: theme.colorScheme.outline.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 3),
                Text('回复', style: textStyle),
              ],
            ),
          ),
        ),
        const SizedBox(width: 2),
        if (replyItem.replyControl.cardLabels.isNotEmpty) ...[
          Text(
            replyItem.replyControl.cardLabels
                .map((e) => e.textContent)
                .join('  '),
            style: textStyle.copyWith(color: theme.colorScheme.secondary),
          ),
          const SizedBox(width: 2),
        ],
        if (replyLevel == 2 && needDivider && replyItem.id != replyItem.dialog)
          SizedBox(
            height: 32,
            child: TextButton(
              onPressed: showDialogue,
              style: buttonStyle,
              child: Text('查看对话', style: textStyle),
            ),
          )
        else if (replyLevel == 3 &&
            needDivider &&
            replyItem.parent != replyItem.root)
          SizedBox(
            height: 32,
            child: TextButton(
              onPressed: jumpToDialogue,
              style: buttonStyle,
              child: Text('跳转回复', style: textStyle),
            ),
          ),
        const Spacer(),
        ZanButtonGrpc(replyItem: replyItem),
        const SizedBox(width: 5),
      ],
    );
  }

  Widget replyItemRow(
    BuildContext context,
    ThemeData theme,
    List<ReplyInfo> replies,
  ) {
    final extraRow = replies.length < replyItem.count.toInt();
    late final length = replies.length + (extraRow ? 1 : 0);
    return Padding(
      padding: const EdgeInsets.only(left: 42, right: 4),
      child: Material(
        color: theme.colorScheme.onInverseSurface,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        clipBehavior: Clip.hardEdge,
        animationDuration: Duration.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (replies.isNotEmpty)
              ...List.generate(replies.length, (index) {
                final childReply = replies[index];
                EdgeInsets padding;
                if (length == 1) {
                  padding = const EdgeInsets.fromLTRB(8, 5, 8, 5);
                } else {
                  if (index == 0) {
                    padding = const EdgeInsets.fromLTRB(8, 8, 8, 4);
                  } else if (index == length - 1) {
                    padding = const EdgeInsets.fromLTRB(8, 4, 8, 8);
                  } else {
                    padding = const EdgeInsets.fromLTRB(8, 4, 8, 4);
                  }
                }
                void showMore() => showModalBottomSheet(
                  context: context,
                  useSafeArea: true,
                  isScrollControlled: true,
                  constraints: BoxConstraints(
                    maxWidth: min(640, context.mediaQueryShortestSide),
                  ),
                  builder: (context) {
                    return morePanel(
                      context: context,
                      item: childReply,
                      onDelete: () => onDelete?.call(replyItem, index),
                      isSubReply: true,
                    );
                  },
                );
                return InkWell(
                  onTap: () =>
                      replyReply?.call(replyItem, childReply.id.toInt()),
                  onLongPress: showMore,
                  onSecondaryTap: PlatformUtils.isMobile ? null : showMore,
                  child: Padding(
                    padding: padding,
                    child: Text.rich(
                      style: TextStyle(
                        fontSize: theme.textTheme.bodyMedium!.fontSize,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.85,
                        ),
                        height: 1.6,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: childReply.member.name,
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                            ),
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
                              alignment: PlaceholderAlignment.middle,
                              child: PBadge(
                                text: 'UP',
                                size: PBadgeSize.small,
                                isStack: false,
                                fontSize: 9,
                                textScaleFactor: 1,
                              ),
                            ),
                            const TextSpan(text: ' '),
                          ],
                          TextSpan(
                            text: childReply.root == childReply.parent
                                ? ': '
                                : childReply.mid == upMid
                                ? ''
                                : ' ',
                          ),
                          _buildMessage(context, theme, childReply),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            if (extraRow)
              InkWell(
                onTap: () => replyReply?.call(replyItem, null),
                child: Padding(
                  padding: length == 1
                      ? const EdgeInsets.fromLTRB(8, 6, 8, 6)
                      : const EdgeInsets.fromLTRB(8, 5, 8, 8),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: theme.textTheme.labelMedium!.fontSize,
                      ),
                      children: [
                        if (replyItem.replyControl.upReply)
                          TextSpan(
                            text: 'UP主等人 ',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.85,
                              ),
                            ),
                          ),
                        TextSpan(
                          text: '共${replyItem.count}条回复',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  InlineSpan _buildMessage(
    BuildContext context,
    ThemeData theme,
    ReplyInfo replyItem,
  ) {
    final Content content = replyItem.content;
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
              color: theme.colorScheme.primary,
              imageUrl: ImageUtils.thumbnailUrl(url.prefixIcon),
              placeholder: (_, _) => const SizedBox.shrink(),
            ),
          ),
        TextSpan(
          text: isCv ? '[笔记] ' : url.title,
          style: TextStyle(
            color: theme.colorScheme.primary,
          ),
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
        late final topic = matchStr.substring(1, matchStr.length - 1);
        if (content.emotes.containsKey(matchStr)) {
          // 处理表情
          final emote = content.emotes[matchStr]!;
          final size = emote.size.toInt() * 20.0;
          spanChildren.add(
            WidgetSpan(
              child: NetworkImgLayer(
                src: emote.hasWebpUrl()
                    ? emote.webpUrl
                    : emote.hasGifUrl()
                    ? emote.gifUrl
                    : emote.url,
                type: ImageType.emote,
                width: size,
                height: size,
              ),
            ),
          );
        } else if (matchStr.startsWith("@") &&
            content.atNameToMid.containsKey(name)) {
          // 处理@用户
          spanChildren.add(
            TextSpan(
              text: matchStr,
              style: TextStyle(color: theme.colorScheme.primary),
              recognizer: NoDeadlineTapGestureRecognizer()
                ..onTap = () =>
                    Get.toNamed('/member?mid=${content.atNameToMid[name]}'),
            ),
          );
        } else if (_voteRegExp.hasMatch(matchStr)) {
          spanChildren.add(
            TextSpan(
              text: '投票: ${content.vote.title}',
              style: TextStyle(color: theme.colorScheme.primary),
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
              style: isValid
                  ? TextStyle(color: theme.colorScheme.primary)
                  : null,
              recognizer: isValid
                  ? (NoDeadlineTapGestureRecognizer()
                      ..onTap = () {
                        // 跳转到指定位置
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
                style: TextStyle(color: theme.colorScheme.primary),
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
                style: TextStyle(color: theme.colorScheme.primary),
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

    if (urlKeys.isNotEmpty) {
      List<String> unmatchedItems = urlKeys
          .where((url) => !matchedUrls.contains(url))
          .toList();
      if (unmatchedItems.isNotEmpty) {
        for (final patternStr in unmatchedItems) {
          addUrl(patternStr, content.urls[patternStr]!);
        }
      }
    }

    if (!hasNote &&
        replyItem.replyControl.isNote &&
        replyItem.replyControl.isNoteV2) {
      final Color color;
      NoDeadlineTapGestureRecognizer? recognizer;

      final hasClickUrl = content.richText.note.hasClickUrl();
      if (hasClickUrl || content.richText.opus.hasOpusId()) {
        color = theme.colorScheme.primary;
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
        color = theme.colorScheme.secondary;
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

  Widget morePanel({
    required BuildContext context,
    required ReplyInfo item,
    required VoidCallback onDelete,
    required bool isSubReply,
  }) {
    late String message = item.content.message;
    final ownerMid = Int64(Accounts.main.mid);
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;
    final style = theme.textTheme.titleSmall!;

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
                child: Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline,
                    borderRadius: const BorderRadius.all(Radius.circular(3)),
                  ),
                ),
              ),
            ),
          ),
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
                style: style.copyWith(color: theme.colorScheme.primary),
              ),
            ),
            ListTile(
              onTap: () {
                Get.back();
                onDelete();
                GStorage.reply!.delete(item.id.toString());
              },
              title: Text(
                'remove from local',
                style: style.copyWith(color: theme.colorScheme.primary),
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
                style: style.copyWith(color: theme.colorScheme.primary),
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
                    final theme = Theme.of(context);
                    return AlertDialog(
                      title: const Text('删除评论'),
                      content: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(text: '确定删除这条评论吗？\n\n'),
                            if (ownerMid != item.member.mid.toInt()) ...[
                              TextSpan(
                                text: '@${item.member.name}',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                ),
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
                            style: TextStyle(
                              color: theme.colorScheme.outline,
                            ),
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
                  onDelete();
                } else {
                  SmartDialog.showToast('删除失败, $res');
                }
              },
              minLeadingWidth: 0,
              leading: Icon(Icons.delete_outlined, color: errorColor, size: 19),
              title: Text('删除', style: style.copyWith(color: errorColor)),
            ),
          if (ownerMid != Int64.ZERO)
            ListTile(
              onTap: () {
                Get.back();
                autoWrapReportDialog(
                  context,
                  ReportOptions.commentReport,
                  (reasonType, reasonDesc, banUid) async {
                    final res = await ReplyHttp.report(
                      rpid: item.id,
                      oid: item.oid,
                      reasonType: reasonType,
                      reasonDesc: reasonDesc,
                      banUid: banUid,
                    );
                    if (res.isSuccess) {
                      onDelete();
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
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Padding(
                    padding: const .symmetric(horizontal: 20, vertical: 16),
                    child: SelectableText(
                      message,
                      style: const TextStyle(fontSize: 15, height: 1.7),
                    ),
                  ),
                ),
              );
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
          if (kDebugMode || item.mid == ownerMid)
            ListTile(
              onTap: () {
                Get.back();
                onCheckReply?.call(item);
              },
              minLeadingWidth: 0,
              leading: const Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Icon(Icons.shield_outlined, size: 19),
                  Icon(Icons.reply, size: 12),
                ],
              ),
              title: Text('检查评论', style: style),
            ),
        ],
      ),
    );
  }
}
