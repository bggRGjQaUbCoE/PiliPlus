import 'dart:math';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/avatar.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/image/image_view.dart';
import 'package:PiliPlus/common/widgets/dialog/report.dart';
import 'package:PiliPlus/grpc/app/main/community/reply/v1/reply.pb.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/pages/dynamics/widgets/vote.dart';
import 'package:PiliPlus/pages/save_panel/view.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/reply/widgets/zan_grpc.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/url_utils.dart';
import 'package:PiliPlus/utils/utils.dart';

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
    this.callback,
    this.onCheckReply,
    this.onToggleTop,
  });
  final ReplyInfo replyItem;
  final String replyLevel;
  final Function(ReplyInfo replyItem, int? rpid)? replyReply;
  final bool needDivider;
  final VoidCallback? onReply;
  final ValueChanged<int?>? onDelete;
  final dynamic upMid;
  final VoidCallback? showDialogue;
  final Function? getTag;
  final VoidCallback? onViewImage;
  final ValueChanged<int>? onDismissed;
  final Function(List<String>, int)? callback;
  final ValueChanged<ReplyInfo>? onCheckReply;
  final Function(bool isUpTop, int rpid)? onToggleTop;

  static final _voteRegExp = RegExp(r"\{vote:\d+?\}");
  static final _timeRegExp = RegExp(r'^\b(?:\d+[:：])?\d+[:：]\d+\b$');

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          feedBack();
          replyReply?.call(replyItem, null);
        },
        onLongPress: () {
          feedBack();
          showModalBottomSheet(
            context: context,
            useSafeArea: true,
            isScrollControlled: true,
            constraints: BoxConstraints(
              maxWidth: min(640, min(Get.width, Get.height)),
            ),
            builder: (context) {
              return morePanel(
                context: context,
                item: replyItem,
                onDelete: () {
                  onDelete?.call(null);
                },
                isSubReply: false,
              );
            },
          );
        },
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
      children: [
        if (Avatar.showDynDecorate && replyItem.member.hasGarbCardImage())
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
              SizedBox(
                width: double.infinity,
                child: _buildAuthorPanel(context, theme),
              ),
            ],
          )
        else
          _buildAuthorPanel(context, theme),
        if (needDivider)
          Divider(
            indent: 55,
            endIndent: 15,
            height: 0.3,
            color: theme.colorScheme.outline.withOpacity(0.08),
          )
      ],
    );
  }

  Widget lfAvtar() => Avatar(
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
            children: [
              lfAvtar(),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        replyItem.member.name,
                        style: TextStyle(
                          color: (replyItem.member.vipStatus > 0 &&
                                  replyItem.member.vipType == 2)
                              ? context.vipColor
                              : theme.colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Image.asset(
                        'assets/images/lv/lv${replyItem.member.isSeniorMember == 1 ? '6_s' : replyItem.member.level}.png',
                        height: 11,
                        semanticLabel: "等级：${replyItem.member.level}",
                      ),
                      const SizedBox(width: 6),
                      if (replyItem.mid == upMid)
                        const PBadge(
                          text: 'UP',
                          size: 'small',
                          stack: 'normal',
                          fs: 9,
                        ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        replyLevel == ''
                            ? DateTime.fromMillisecondsSinceEpoch(
                                    replyItem.ctime.toInt() * 1000)
                                .toString()
                                .substring(0, 19)
                            : Utils.dateFormat(replyItem.ctime.toInt()),
                        style: TextStyle(
                          fontSize: theme.textTheme.labelSmall!.fontSize,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      if (replyItem.replyControl.location.isNotEmpty)
                        Text(
                          ' • ${replyItem.replyControl.location}',
                          style: TextStyle(
                              fontSize: theme.textTheme.labelSmall!.fontSize,
                              color: theme.colorScheme.outline),
                        ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        // title
        Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: replyLevel == '' ? 6 : 45,
            right: 6,
            bottom: 4,
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              String text = replyItem.content.message;
              TextStyle style = TextStyle(
                height: 1.75,
                fontSize: theme.textTheme.bodyMedium!.fontSize,
              );
              TextPainter? textPainter;
              bool? didExceedMaxLines;
              if (replyLevel == '1' && GlobalData().replyLengthLimit != 0) {
                textPainter = TextPainter(
                  text: TextSpan(text: text, style: style),
                  maxLines: GlobalData().replyLengthLimit,
                  textDirection: Directionality.of(context),
                )..layout(maxWidth: constraints.maxWidth);
                didExceedMaxLines = textPainter.didExceedMaxLines;
              }
              return Semantics(
                label: text,
                child: Text.rich(
                  style: style,
                  TextSpan(
                    children: [
                      if (replyItem.replyControl.isUpTop) ...[
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.top,
                          child: PBadge(
                            text: 'TOP',
                            size: 'small',
                            stack: 'normal',
                            type: 'line',
                            fs: 9,
                            semanticsLabel: '置顶',
                            textScaleFactor: 1,
                          ),
                        ),
                        const TextSpan(text: ' '),
                      ],
                      buildContent(
                        context,
                        theme,
                        replyItem,
                        null,
                        textPainter,
                        didExceedMaxLines,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // 操作区域
        if (replyLevel != '')
          buttonAction(context, theme, replyItem.replyControl),
        // 一楼的评论
        if (replyLevel == '1' &&
            (replyItem.replies.isNotEmpty ||
                replyItem.replyControl.subReplyEntryText.isNotEmpty)) ...[
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 12),
            child: replyItemRow(context, theme),
          ),
        ],
      ],
    );
  }

  get _style => TextButton.styleFrom(
        padding: const EdgeInsets.all(0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity(horizontal: -2, vertical: -2),
      );

  // 感谢、回复、复制
  Widget buttonAction(
      BuildContext context, ThemeData theme, ReplyControl replyControl) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 36),
        SizedBox(
          height: 32,
          child: TextButton(
            style: _style,
            onPressed: () {
              feedBack();
              onReply?.call();
            },
            child: Row(children: [
              Icon(
                Icons.reply,
                size: 18,
                color: theme.colorScheme.outline.withOpacity(0.8),
              ),
              const SizedBox(width: 3),
              Text(
                '回复',
                style: TextStyle(
                  fontSize: theme.textTheme.labelMedium!.fontSize,
                  color: theme.colorScheme.outline,
                ),
              ),
            ]),
          ),
        ),
        const SizedBox(width: 2),
        if (replyItem.replyControl.upLike) ...[
          SizedBox(
            height: 32,
            child: TextButton(
              onPressed: null,
              style: _style,
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
            .toList()
            .contains('热评'))
          Text(
            '热评',
            style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: theme.textTheme.labelMedium!.fontSize),
          ),
        if (replyLevel == '2' &&
            needDivider &&
            replyItem.id != replyItem.dialog)
          SizedBox(
            height: 32,
            child: TextButton(
              onPressed: showDialogue,
              style: _style,
              child: Text(
                '查看对话',
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
        const SizedBox(width: 5)
      ],
    );
  }

  Widget replyItemRow(BuildContext context, ThemeData theme) {
    final bool extraRow = replyItem.replies.length < replyItem.count.toInt();
    return Container(
      margin: const EdgeInsets.only(left: 42, right: 4, top: 0),
      child: Material(
        color: theme.colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(6),
        clipBehavior: Clip.hardEdge,
        animationDuration: Duration.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (replyItem.replies.isNotEmpty)
              for (int i = 0; i < replyItem.replies.length; i++) ...[
                InkWell(
                  // 一楼点击评论展开评论详情
                  onTap: () => replyReply?.call(
                      replyItem, replyItem.replies[i].id.toInt()),
                  onLongPress: () {
                    feedBack();
                    showModalBottomSheet(
                      context: context,
                      useSafeArea: true,
                      isScrollControlled: true,
                      constraints: BoxConstraints(
                        maxWidth: min(640, min(Get.width, Get.height)),
                      ),
                      builder: (context) {
                        return morePanel(
                          context: context,
                          item: replyItem.replies[i],
                          onDelete: () {
                            onDelete?.call(i);
                          },
                          isSubReply: true,
                        );
                      },
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical:
                          i == 0 && (extraRow || replyItem.replies.length > 1)
                              ? 8
                              : 4,
                    ),
                    child: Semantics(
                      label:
                          '${replyItem.replies[i].member.name} ${replyItem.replies[i].content.message}',
                      excludeSemantics: true,
                      child: Text.rich(
                        style: TextStyle(
                            fontSize: theme.textTheme.bodyMedium!.fontSize,
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.85),
                            height: 1.6),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        TextSpan(
                          children: [
                            TextSpan(
                              text: replyItem.replies[i].member.name,
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  feedBack();
                                  Get.toNamed(
                                    '/member?mid=${replyItem.replies[i].member.mid}',
                                  );
                                },
                            ),
                            if (replyItem.replies[i].mid == upMid) ...[
                              const TextSpan(text: ' '),
                              const WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: PBadge(
                                  text: 'UP',
                                  size: 'small',
                                  stack: 'normal',
                                  fs: 9,
                                  textScaleFactor: 1,
                                ),
                              ),
                              const TextSpan(text: ' '),
                            ],
                            TextSpan(
                              text: replyItem.replies[i].root ==
                                      replyItem.replies[i].parent
                                  ? ': '
                                  : replyItem.replies[i].mid == upMid
                                      ? ''
                                      : ' ',
                            ),
                            buildContent(
                              context,
                              theme,
                              replyItem.replies[i],
                              replyItem,
                              null,
                              null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            if (extraRow)
              InkWell(
                // 一楼点击【共xx条回复】展开评论详情
                onTap: () => replyReply?.call(replyItem, null),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(8, 5, 8, 8),
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
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.85),
                            ),
                          ),
                        TextSpan(
                          text: replyItem.replyControl.subReplyEntryText,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  InlineSpan buildContent(
    BuildContext context,
    ThemeData theme,
    ReplyInfo replyItem,
    ReplyInfo? fReplyItem,
    TextPainter? textPainter,
    bool? didExceedMaxLines,
  ) {
    final String routePath = Get.currentRoute;
    bool isVideoPage = routePath.startsWith('/video');

    // replyItem 当前回复内容
    // replyReply 查看二楼回复（回复详情）回调
    // fReplyItem 父级回复内容，用作二楼回复（回复详情）展示
    final Content content = replyItem.content;
    String message = content.message;
    final List<InlineSpan> spanChildren = <InlineSpan>[];

    if (didExceedMaxLines == true) {
      final textSize = textPainter!.size;
      final double maxHeight = textPainter.preferredLineHeight * 6;
      var position = textPainter.getPositionForOffset(
        Offset(textSize.width, maxHeight),
      );
      message = message.substring(0, position.offset);
    }

    // 投票
    if (content.hasVote()) {
      message = message.replaceAllMapped(_voteRegExp, (Match match) {
        spanChildren.add(
          TextSpan(
            text: '投票: ${content.vote.title}',
            style: TextStyle(
              color: theme.colorScheme.primary,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => showVoteDialog(context, content.vote.id.toInt()),
          ),
        );
        return '';
      });
    }
    // 构建正则表达式
    final List<String> specialTokens = [
      ...content.emote.keys,
      ...content.topic.keys.map((e) => '#$e#'),
      ...content.atNameToMid.keys.map((e) => '@$e'),
    ];
    List<String> jumpUrlKeysList = content.url.keys.map<String>((String e) {
      return e;
    }).toList();
    specialTokens.sort((a, b) => b.length.compareTo(a.length));
    String patternStr = specialTokens.map(RegExp.escape).join('|');
    if (patternStr.isNotEmpty) {
      patternStr += "|";
    }
    patternStr += r'(\b(?:\d+[:：])?\d+[:：]\d+\b)';
    if (jumpUrlKeysList.isNotEmpty) {
      patternStr += '|${jumpUrlKeysList.map(RegExp.escape).join('|')}';
    }
    patternStr += '|${Constants.urlPattern}';
    final RegExp pattern = RegExp(patternStr);
    List<String> matchedStrs = [];
    void addPlainTextSpan(str) {
      spanChildren.add(TextSpan(
        text: str,
      ));
    }

    late final bool enableWordRe =
        GStorage.setting.get(SettingBoxKey.enableWordRe, defaultValue: false);

    // 分割文本并处理每个部分
    message.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        String matchStr = match[0]!;
        if (content.emote.containsKey(matchStr)) {
          // 处理表情
          final int size = content.emote[matchStr]!.size.toInt();
          spanChildren.add(WidgetSpan(
            child: ExcludeSemantics(
                child: NetworkImgLayer(
              src: content.emote[matchStr]?.hasGifUrl() == true
                  ? content.emote[matchStr]?.gifUrl
                  : content.emote[matchStr]?.url,
              type: 'emote',
              width: size * 20,
              height: size * 20,
              semanticsLabel: matchStr,
            )),
          ));
        } else if (matchStr.startsWith("@") &&
            content.atNameToMid.containsKey(matchStr.substring(1))) {
          // 处理@用户
          final String userName = matchStr.substring(1);
          final int userId = content.atNameToMid[userName]!.toInt();
          spanChildren.add(
            TextSpan(
              text: matchStr,
              style: TextStyle(
                color: theme.colorScheme.primary,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.toNamed('/member?mid=$userId');
                },
            ),
          );
        } else if (_timeRegExp.hasMatch(matchStr)) {
          matchStr = matchStr.replaceAll('：', ':');
          bool isValid = false;
          try {
            List<int> split = matchStr
                .split(':')
                .map((item) => int.parse(item))
                .toList()
                .reversed
                .toList();
            int seek = 0;
            for (int i = 0; i < split.length; i++) {
              seek += split[i] * pow(60, i).toInt();
            }
            int duration = Get.find<VideoDetailController>(
                  tag: getTag?.call() ?? Get.arguments['heroTag'],
                ).data.timeLength ??
                0;
            isValid = seek * 1000 <= duration;
          } catch (e) {
            debugPrint('failed to validate: $e');
          }
          spanChildren.add(
            TextSpan(
              text: isValid ? ' $matchStr ' : matchStr,
              style: isValid && isVideoPage
                  ? TextStyle(
                      color: theme.colorScheme.primary,
                    )
                  : null,
              recognizer: isValid
                  ? (TapGestureRecognizer()
                    ..onTap = () {
                      // 跳转到指定位置
                      if (isVideoPage) {
                        try {
                          SmartDialog.showToast('跳转至：$matchStr');
                          Get.find<VideoDetailController>(
                                  tag: Get.arguments['heroTag'])
                              .plPlayerController
                              .seekTo(
                                  Duration(seconds: Utils.duration(matchStr)),
                                  type: 'slider');
                        } catch (e) {
                          SmartDialog.showToast('跳转失败: $e');
                        }
                      }
                    })
                  : null,
            ),
          );
        } else {
          String appUrlSchema = '';
          if (content.url[matchStr] != null &&
              !matchedStrs.contains(matchStr)) {
            appUrlSchema = content.url[matchStr]!.appUrlSchema;
            if (appUrlSchema.startsWith('bilibili://search') && !enableWordRe) {
              addPlainTextSpan(matchStr);
              return "";
            }
            spanChildren.addAll(
              [
                if (content.url[matchStr]?.hasPrefixIcon() == true) ...[
                  WidgetSpan(
                    child: CachedNetworkImage(
                      imageUrl: Utils.thumbnailImgUrl(
                          content.url[matchStr]!.prefixIcon),
                      height: 19,
                      color: theme.colorScheme.primary,
                      placeholder: (context, url) {
                        return const SizedBox.shrink();
                      },
                    ),
                  )
                ],
                TextSpan(
                  text: content.url[matchStr]!.title,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      late final String title = content.url[matchStr]!.title;
                      if (appUrlSchema == '') {
                        if (RegExp(r'^(av|bv)', caseSensitive: false)
                            .hasMatch(matchStr)) {
                          UrlUtils.matchUrlPush(matchStr, '');
                        } else {
                          RegExpMatch? firstMatch = RegExp(
                            r'^cv(\d+)$|/read/cv(\d+)|note-app/view\?cvid=(\d+)',
                            caseSensitive: false,
                          ).firstMatch(matchStr);
                          String? cvid = firstMatch?.group(1) ??
                              firstMatch?.group(2) ??
                              firstMatch?.group(3);
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
                        if (appUrlSchema.startsWith('bilibili://search')) {
                          Get.toNamed(
                            '/searchResult',
                            parameters: {'keyword': title},
                          );
                        } else {
                          PageUtils.handleWebview(matchStr);
                        }
                      }
                    },
                )
              ],
            );
            // 只显示一次
            matchedStrs.add(matchStr);
          } else if (matchStr.length > 1 &&
              content.topic[matchStr.substring(1, matchStr.length - 1)] !=
                  null) {
            spanChildren.add(
              TextSpan(
                text: matchStr,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    final String topic =
                        matchStr.substring(1, matchStr.length - 1);
                    Get.toNamed(
                      '/searchResult',
                      parameters: {'keyword': topic},
                    );
                  },
              ),
            );
          } else if (RegExp(Constants.urlPattern).hasMatch(matchStr)) {
            spanChildren.add(
              TextSpan(
                text: matchStr,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    PageUtils.handleWebview(matchStr);
                  },
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

    if (content.url.keys.isNotEmpty) {
      List<String> unmatchedItems = content.url.keys
          .toList()
          .where((item) => !content.message.contains(item))
          .toList();
      if (unmatchedItems.isNotEmpty) {
        for (int i = 0; i < unmatchedItems.length; i++) {
          String patternStr = unmatchedItems[i];
          if (content.url[patternStr]?.extra.isWordSearch == true &&
              enableWordRe.not) {
            continue;
          }
          spanChildren.addAll(
            [
              if (content.url[patternStr]?.hasPrefixIcon() == true) ...[
                WidgetSpan(
                  child: CachedNetworkImage(
                    imageUrl: Utils.thumbnailImgUrl(
                        content.url[patternStr]!.prefixIcon),
                    height: 19,
                    color: theme.colorScheme.primary,
                    placeholder: (context, url) {
                      return const SizedBox.shrink();
                    },
                  ),
                )
              ],
              TextSpan(
                text: content.url[patternStr]!.title,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    String? cvid = RegExp(r'note-app/view\?cvid=(\d+)')
                        .firstMatch(patternStr)
                        ?.group(1);
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

                    PageUtils.handleWebview(patternStr);
                  },
              )
            ],
          );
        }
      }
    }

    if (didExceedMaxLines == true) {
      spanChildren.add(
        TextSpan(
          text: '\n查看更多',
          style: TextStyle(
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    // 图片渲染
    if (content.pictures.isNotEmpty) {
      spanChildren.add(const TextSpan(text: '\n'));
      spanChildren.add(
        WidgetSpan(
          child: LayoutBuilder(
            builder: (context, constraints) => imageView(
              constraints.maxWidth,
              content.pictures
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
              callback: callback,
            ),
          ),
        ),
      );
    }

    // 笔记链接
    if (content.hasRichText()) {
      spanChildren.add(
        TextSpan(
          text: ' 笔记',
          style: TextStyle(
            color: theme.colorScheme.primary,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap =
                () => PageUtils.handleWebview(content.richText.note.clickUrl),
        ),
      );
    }
    return TextSpan(children: spanChildren);
  }

  Widget morePanel({
    required BuildContext context,
    required ReplyInfo item,
    required onDelete,
    required bool isSubReply,
  }) {
    int ownerMid = Accounts.main.mid;
    Future<dynamic> menuActionHandler(String type) async {
      late String message = item.content.message;
      switch (type) {
        case 'report':
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
                  if (reasonType == 0) 'content': reasonDesc!
                },
                options:
                    Options(contentType: Headers.formUrlEncodedContentType),
              );
              if (res.data['code'] == 0) {
                onDelete?.call();
              }
              return res.data as Map;
            },
          );
          break;
        case 'copyAll':
          Get.back();
          Utils.copyText(message);
          break;
        case 'copyFreedom':
          Get.back();
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: SelectableText(message),
                ),
              );
            },
          );
          break;
        case 'delete':
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
                      TextSpan(text: '确定删除这条评论吗？\n\n'),
                      if (ownerMid != item.member.mid.toInt()) ...[
                        TextSpan(
                          text: '@${item.member.name}',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        TextSpan(text: ':\n'),
                      ],
                      TextSpan(text: message),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.back(result: false);
                    },
                    child: Text(
                      '取消',
                      style: TextStyle(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back(result: true);
                    },
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
            onDelete?.call();
          } else {
            SmartDialog.showToast('删除失败, ${result["msg"]}');
          }
          break;
        case 'checkReply':
          Get.back();
          onCheckReply?.call(item);
          break;
        case 'top':
          Get.back();
          onToggleTop?.call(item.replyControl.isUpTop, item.id.toInt());
          break;
        case 'saveReply':
          Get.back();
          SavePanel.toSavePanel(upMid: upMid, item: item);
          break;
        default:
      }
    }

    final theme = Theme.of(context);
    Color errorColor = theme.colorScheme.error;
    final style = theme.textTheme.titleSmall;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: Get.back,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            child: Container(
              height: 35,
              padding: const EdgeInsets.only(bottom: 2),
              child: Center(
                child: Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                      color: theme.colorScheme.outline,
                      borderRadius: const BorderRadius.all(Radius.circular(3))),
                ),
              ),
            ),
          ),
          if (ownerMid == upMid.toInt() || ownerMid == item.member.mid.toInt())
            ListTile(
              onTap: () => menuActionHandler('delete'),
              minLeadingWidth: 0,
              leading: Icon(Icons.delete_outlined, color: errorColor, size: 19),
              title: Text('删除', style: style!.copyWith(color: errorColor)),
            ),
          if (ownerMid != 0)
            ListTile(
              onTap: () => menuActionHandler('report'),
              minLeadingWidth: 0,
              leading: Icon(Icons.error_outline, color: errorColor, size: 19),
              title: Text('举报', style: style!.copyWith(color: errorColor)),
            ),
          if (replyLevel == '1' && isSubReply.not && ownerMid == upMid.toInt())
            ListTile(
              onTap: () => menuActionHandler('top'),
              minLeadingWidth: 0,
              leading: Icon(Icons.vertical_align_top, size: 19),
              title: Text(
                '${replyItem.replyControl.isUpTop ? '取消' : ''}置顶',
                style: style,
              ),
            ),
          ListTile(
            onTap: () => menuActionHandler('copyAll'),
            minLeadingWidth: 0,
            leading: const Icon(Icons.copy_all_outlined, size: 19),
            title: Text('复制全部', style: style),
          ),
          ListTile(
            onTap: () => menuActionHandler('copyFreedom'),
            minLeadingWidth: 0,
            leading: const Icon(Icons.copy_outlined, size: 19),
            title: Text('自由复制', style: style),
          ),
          ListTile(
            onTap: () => menuActionHandler('saveReply'),
            minLeadingWidth: 0,
            leading: const Icon(Icons.save_alt, size: 19),
            title: Text('保存评论', style: style),
          ),
          if (item.mid.toInt() == ownerMid)
            ListTile(
              onTap: () => menuActionHandler('checkReply'),
              minLeadingWidth: 0,
              leading: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.shield_outlined, size: 19),
                  const Icon(Icons.reply, size: 12),
                ],
              ),
              title: Text('检查评论', style: style),
            ),
        ],
      ),
    );
  }
}
