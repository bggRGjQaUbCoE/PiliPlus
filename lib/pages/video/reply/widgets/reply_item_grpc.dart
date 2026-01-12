import 'dart:math';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/ai_summary_progress.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/dialog/report.dart';
import 'package:PiliPlus/common/widgets/flutter/text/text.dart' as custom_text;
import 'package:PiliPlus/common/widgets/image/custom_grid_view.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo, ReplyControl, Content, Url;
import 'package:PiliPlus/http/reply.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/pages/dynamics/widgets/vote.dart';
import 'package:PiliPlus/pages/save_panel/view.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/reply/widgets/zan_grpc.dart';
import 'package:PiliPlus/services/ai_summary_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension/context_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/url_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart' show kDebugMode, ChangeNotifier;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

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
  
  // Global state for AI summaries
  static final Map<String, AiSummaryState> _summaryStates = {};

  static AiSummaryState _getOrCreateState(String key) {
    return _summaryStates.putIfAbsent(
      key,
      () => AiSummaryState(),
    );
  }

  static void _removeSummaryState(String key) {
    _summaryStates.remove(key);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final isMobile = PlatformUtils.isMobile;
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
        onTap: () => replyReply?.call(replyItem, null),
        onLongPress: showMore,
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
                      memCacheHeight: 38.cacheSize(context),
                      imageUrl: ImageUtils.safeThumbnailUrl(
                        replyItem.member.garbCardImage,
                      ),
                      placeholder: (_, _) => const SizedBox.shrink(),
                    ),
                    if (replyItem.member.hasGarbCardNumber())
                      Text(
                        'NO.\n${replyItem.member.garbCardNumber}',
                        style: TextStyle(
                          fontSize: 8,
                          fontFamily: 'digital_id_num',
                          color:
                              replyItem.member.garbCardFanColor.startsWith('#')
                              ? Utils.parseColor(
                                  replyItem.member.garbCardFanColor,
                                )
                              : null,
                        ),
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
    
    // Get AI summary state for this reply (only for level 1 replies)
    final stateKey = '${replyItem.id}';
    final summaryState = replyLevel == 1 ? ReplyItemGrpc._getOrCreateState(stateKey) : null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar column with optional progress indicator
            Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    feedBack();
                    Get.toNamed('/member?mid=${replyItem.mid}');
                  },
                  child: _buildAvatar(),
                ),
                // AI summary progress indicator (only for level 1 replies)
                if (summaryState != null && (summaryState.isProcessing || summaryState.isComplete))
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: AnimatedBuilder(
                      animation: summaryState,
                      builder: (context, _) {
                        return AiSummaryProgressIndicator(
                          progress: summaryState.progress,
                          isComplete: summaryState.isComplete,
                          onTap: summaryState.isComplete
                              ? () => _showSummaryResult(context, summaryState.summary ?? '')
                              : null,
                          onCancel: summaryState.isProcessing
                              ? () => _onCancelSummary(context, summaryState, stateKey)
                              : null,
                        );
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Content column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      feedBack();
                      Get.toNamed('/member?mid=${replyItem.mid}');
                    },
                    child: Column(
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
                              Utils.levelName(
                                replyItem.member.level,
                                isSeniorMember: replyItem.member.isSeniorMember == 1,
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
                  ),
                  const SizedBox(height: 10),
                  custom_text.Text.rich(
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
                        buildContent(context, theme, replyItem),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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
      children: <Widget>[
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
        for (final patternStr in unmatchedItems) {
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
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: SelectableText(
                        message,
                        style: const TextStyle(fontSize: 15, height: 1.7),
                      ),
                    ),
                  );
                },
              );
            },
            minLeadingWidth: 0,
            leading: const Icon(Icons.copy_outlined, size: 19),
            title: Text('自由复制', style: style),
          ),
          if (replyLevel == 1 && !isSubReply)
            ListTile(
              onTap: () {
                Get.back();
                _onAiSummaryTap(context, item);
              },
              minLeadingWidth: 0,
              leading: const Icon(Icons.psychology_outlined, size: 19),
              title: Text('AI总结', style: style),
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

  void _onAiSummaryTap(BuildContext context, ReplyInfo item) {
    // Check if AI is configured
    final baseUrl = GStorage.setting.get(
      SettingBoxKey.aiSummaryBaseUrl,
      defaultValue: '',
    );
    final apiKey = GStorage.setting.get(
      SettingBoxKey.aiSummaryApiKey,
      defaultValue: '',
    );

    if (baseUrl.isEmpty || apiKey.isEmpty) {
      SmartDialog.showToast('请先在设置中配置AI API');
      return;
    }

    // Get or create state for this reply
    final stateKey = '${item.id}';
    final state = ReplyItemGrpc._getOrCreateState(stateKey);
    
    // If already summarizing or complete, handle accordingly
    if (state.isComplete) {
      _showSummaryResult(context, state.summary ?? '');
      return;
    }

    if (state.isProcessing) {
      SmartDialog.showToast('正在总结中...');
      return;
    }

    // Start summarizing
    state.startProcessing();
    _startAiSummary(context, item, state);
  }

  void _onCancelSummary(
    BuildContext context,
    AiSummaryState state,
    String stateKey,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: const Text('取消总结'),
          content: const Text('正在总结中，是否结束？'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                '继续',
                style: TextStyle(color: theme.colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                state.reset();
                ReplyItemGrpc._removeSummaryState(stateKey);
                SmartDialog.showToast('已取消');
              },
              child: const Text('结束'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _startAiSummary(
    BuildContext context,
    ReplyInfo item,
    AiSummaryState state,
  ) async {
    try {
      final (success, result) = await AiSummaryService.summarizeReply(
        type: item.type.toInt(),
        oid: item.oid,
        rootRpid: item.id,
        onProgress: (progress) {
          state.updateProgress(progress);
        },
      );

      if (success) {
        state.complete(result);
        SmartDialog.showToast('总结完成');
        if (context.mounted) {
          _showSummaryResult(context, result);
        }
      } else {
        state.reset();
        SmartDialog.showToast('总结失败: $result');
      }
    } catch (e) {
      state.reset();
      SmartDialog.showToast('总结失败: $e');
    }
  }

  void _showSummaryResult(BuildContext context, String summary) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.psychology_outlined),
              const SizedBox(width: 8),
              const Text('AI总结'),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => Utils.copyText(summary),
                tooltip: '复制',
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: SelectableText(
              summary,
              style: const TextStyle(fontSize: 15, height: 1.7),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('关闭'),
            ),
          ],
        );
      },
    );
  }
}

class AiSummaryState extends ChangeNotifier {
  double _progress = 0.0;
  bool _isProcessing = false;
  bool _isComplete = false;
  String? _summary;

  double get progress => _progress;
  bool get isProcessing => _isProcessing;
  bool get isComplete => _isComplete;
  String? get summary => _summary;

  void startProcessing() {
    _isProcessing = true;
    _progress = 0.0;
    _isComplete = false;
    _summary = null;
    notifyListeners();
  }

  void updateProgress(double progress) {
    _progress = progress;
    notifyListeners();
  }

  void complete(String summary) {
    _isProcessing = false;
    _isComplete = true;
    _summary = summary;
    _progress = 1.0;
    notifyListeners();
  }

  void reset() {
    _isProcessing = false;
    _isComplete = false;
    _progress = 0.0;
    _summary = null;
    notifyListeners();
  }
}
