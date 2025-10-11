import 'dart:math';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/dialog/report.dart';
import 'package:PiliPlus/common/widgets/image/custom_grid_view.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/common/widgets/text/text.dart' as custom_text;
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo, ReplyControl, Content, Url;
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/pages/dynamics/widgets/vote.dart';
import 'package:PiliPlus/pages/save_panel/view.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/reply/widgets/zan_grpc.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/context_ext.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/url_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide ContextExtensionss;

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
    this.onDismissed,
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
  final ValueChanged<int>? onDismissed;
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

    final isMobile = Utils.isMobile;
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

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          feedBack();
          replyReply?.call(replyItem, null);
        },
        onLongPress: () {
          feedBack();
          showMore();
        },
        onSecondaryTap: isMobile ? null : showMore,
        child: _buildContent(context, theme),
      ),
    );
  }

  Widget _buildAuthorPanel(BuildContext context, ThemeData theme) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 14, 8, 5),
    child: content(context, theme),
  );

  Widget _buildContent(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (PendantAvatar.showDynDecorate &&
            replyItem.member.hasGarbCardImage())
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 8,
                right: 12,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.centerRight,
                  children: [
                    CachedNetworkImage(
                      height: 38,
                      imageUrl: replyItem.member.garbCardImage.http2https,
                    ),
                    if (replyItem.member.hasGarbCardNumber())
                      Text(
                        'NO.\n${replyItem.member.garbCardNumber}',
                        style: replyItem.member.garbCardFanColor.startsWith('#')
                            ? TextStyle(
                                fontSize: 8,
                                fontFamily: 'digital_id_num',
                                color: Color(
                                  int.parse(
                                    replyItem.member.garbCardFanColor
                                        .replaceFirst('#', '0xFF'),
                                  ),
                                ),
                              )
                            : null,
                      ),
                  ],
                ),
              ),
              _buildAuthorPanel(context, theme),
            ],
          )
        else
          _buildAuthorPanel(context, theme),
        if (needDivider)
          Divider(
            indent: 55,
            endIndent: 15,
            height: 0.3,
            color: theme.colorScheme.outline.withValues(alpha: 0.08),
          ),
      ],
    );
  }

  Widget _buildAvatar() => PendantAvatar(
    avatar: replyItem.member.face,
    size: 34,
    badgeSize: 14,
    isVip: replyItem.member.vipStatus > 0,
    officialType: replyItem.member.officialVerifyType.toInt(),
    garbPendantImage: replyItem.member.hasGarbPendantImage()
        ? replyItem.member.garbPendantImage
        : null,
  );

  Widget content(BuildContext context, ThemeData theme) {
    final padding = EdgeInsets.only(
      left: replyLevel == 0 ? 6 : 45,
      right: 6,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            feedBack();
            Get.toNamed('/member?mid=${replyItem.mid}');
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 12,
            children: [
              _buildAvatar(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 6,
                    children: [
                      Text(
                        replyItem.member.name,
                        style: TextStyle(
                          color:
                              (replyItem.member.vipStatus > 0 &&
                                  replyItem.member.vipType == 2)
                              ? theme.colorScheme.vipColor
                              : theme.colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                      Image.asset(
                        'assets/images/lv/lv${replyItem.member.isSeniorMember == 1 ? '6_s' : replyItem.member.level}.png',
                        height: 11,
                      ),
                      if (replyItem.mid == upMid)
                        const PBadge(
                          text: 'UP',
                          size: PBadgeSize.small,
                          isStack: false,
                          fontSize: 9,
                        ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
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
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: padding,
          child: custom_text.Text.rich(
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
                buildContent(context, theme, replyItem),
              ],
            ),
          ),
        ),
        if (replyItem.content.pictures.isNotEmpty) ...[
          Padding(
            padding: padding,
            child: LayoutBuilder(
              builder: (context, constraints) => CustomGridView(
                maxWidth: constraints.maxWidth,
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
                onDismissed: onDismissed,
              ),
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
    final ButtonStyle style = TextButton.styleFrom(
      padding: EdgeInsets.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
    return Row(
      children: <Widget>[
        const SizedBox(width: 36),
        SizedBox(
          height: 32,
          child: TextButton(
            style: style,
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
                Text(
                  '回复',
                  style: TextStyle(
                    fontSize: theme.textTheme.labelMedium!.fontSize,
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 2),
        if (replyItem.replyControl.upLike) ...[
          SizedBox(
            height: 32,
            child: TextButton(
              onPressed: null,
              style: style,
              child: Text(
                'UP主觉得很赞',
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: theme.textTheme.labelMedium!.fontSize,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          const SizedBox(width: 2),
        ],
        if (replyItem.replyControl.cardLabels
            .map((item) => item.textContent)
            .contains('热评'))
          Text(
            '热评',
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontSize: theme.textTheme.labelMedium!.fontSize,
            ),
          ),
        if (replyLevel == 2 && needDivider && replyItem.id != replyItem.dialog)
          SizedBox(
            height: 32,
            child: TextButton(
              onPressed: showDialogue,
              style: style,
              child: Text(
                '查看对话',
                style: TextStyle(
                  color: theme.colorScheme.outline,
                  fontSize: theme.textTheme.labelMedium!.fontSize,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          )
        else if (replyLevel == 3 &&
            needDivider &&
            replyItem.parent != replyItem.root)
          SizedBox(
            height: 32,
            child: TextButton(
              onPressed: jumpToDialogue,
              style: style,
              child: Text(
                '跳转回复',
                style: TextStyle(
                  color: theme.colorScheme.outline,
                  fontSize: theme.textTheme.labelMedium!.fontSize,
                  fontWeight: FontWeight.normal,
                ),
              ),
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
                  onLongPress: () {
                    feedBack();
                    showMore();
                  },
                  onSecondaryTap: Utils.isMobile ? null : showMore,
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
                            recognizer: TapGestureRecognizer()
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
                          buildContent(context, theme, childReply),
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

  InlineSpan buildContent(
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
              imageUrl: ImageUtils.thumbnailUrl(url.prefixIcon),
              height: 19,
              color: theme.colorScheme.primary,
              placeholder: (context, url) {
                return const SizedBox.shrink();
              },
            ),
          ),
        TextSpan(
          text: isCv ? '[笔记] ' : url.title,
          style: TextStyle(
            color: theme.colorScheme.primary,
          ),
          recognizer: TapGestureRecognizer()
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
                src: emote.hasGifUrl() == true ? emote.gifUrl : emote.url,
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
              recognizer: TapGestureRecognizer()
                ..onTap = () =>
                    Get.toNamed('/member?mid=${content.atNameToMid[name]}'),
            ),
          );
        } else if (_voteRegExp.hasMatch(matchStr)) {
          spanChildren.add(
            TextSpan(
              text: '投票: ${content.vote.title}',
              style: TextStyle(color: theme.colorScheme.primary),
              recognizer: TapGestureRecognizer()
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
                  ? (TapGestureRecognizer()
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
                recognizer: TapGestureRecognizer()
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
                recognizer: TapGestureRecognizer()
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
        for (var patternStr in unmatchedItems) {
          addUrl(patternStr, content.urls[patternStr]!);
        }
      }
    }

    if (!hasNote &&
        (content.richText.hasNote() ||
            replyItem.replyControl.bizScene == 'note')) {
      final hasClickUrl = content.richText.note.hasClickUrl();
      spanChildren.insert(
        0,
        TextSpan(
          text: '[笔记] ',
          style: TextStyle(
            color: hasClickUrl
                ? theme.colorScheme.primary
                : theme.colorScheme.secondary,
          ),
          recognizer: hasClickUrl
              ? (TapGestureRecognizer()
                  ..onTap = () =>
                      PageUtils.handleWebview(content.richText.note.clickUrl))
              : null,
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
    final style = theme.textTheme.titleSmall;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewPaddingOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: Get.back,
            borderRadius: StyleString.bottomSheetRadius,
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
                      actions: <Widget>[
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
                var result = await VideoHttp.replyDel(
                  type: item.type.toInt(),
                  oid: item.oid.toInt(),
                  rpid: item.id.toInt(),
                );
                SmartDialog.dismiss();
                if (result['status']) {
                  SmartDialog.showToast('删除成功');
                  onDelete();
                } else {
                  SmartDialog.showToast('删除失败, ${result["msg"]}');
                }
              },
              minLeadingWidth: 0,
              leading: Icon(Icons.delete_outlined, color: errorColor, size: 19),
              title: Text('删除', style: style!.copyWith(color: errorColor)),
            ),
          if (ownerMid != Int64.ZERO)
            ListTile(
              onTap: () {
                Get.back();
                autoWrapReportDialog(
                  context,
                  ReportOptions.commentReport,
                  (reasonType, reasonDesc, banUid) async {
                    final res = await Request().post(
                      '/x/v2/reply/report',
                      data: {
                        'add_blacklist': banUid,
                        'csrf': Accounts.main.csrf,
                        'gaia_source': 'main_h5',
                        'oid': item.oid,
                        'platform': 'android',
                        'reason': reasonType,
                        'rpid': item.id,
                        'scene': 'main',
                        'type': 1,
                        if (reasonType == 0) 'content': reasonDesc!,
                      },
                      options: Options(
                        contentType: Headers.formUrlEncodedContentType,
                      ),
                    );
                    if (res.data['code'] == 0) {
                      onDelete();
                    }
                    return res.data as Map;
                  },
                );
              },
              minLeadingWidth: 0,
              leading: Icon(Icons.error_outline, color: errorColor, size: 19),
              title: Text('举报', style: style!.copyWith(color: errorColor)),
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
                builder: (context) {
                  return Dialog(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: SelectableText(message),
                    ),
                  );
                },
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
