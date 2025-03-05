import 'dart:math';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/imageview.dart';
import 'package:PiliPlus/common/widgets/report.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/common/widgets/badge.dart';
import 'package:PiliPlus/common/widgets/network_img_layer.dart';
import 'package:PiliPlus/models/common/reply_type.dart';
import 'package:PiliPlus/models/video/reply/item.dart';
import 'package:PiliPlus/pages/video/detail/index.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/url_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'zan.dart';
import 'package:html/parser.dart' show parse;

class ReplyItem extends StatelessWidget {
  const ReplyItem({
    super.key,
    required this.replyItem,
    this.replyLevel,
    this.showReplyRow = true,
    this.replyReply,
    this.replyType,
    this.needDivider = true,
    this.onReply,
    this.onDelete,
    this.onViewImage,
    this.onDismissed,
    this.getTag,
    this.callback,
  });
  final ReplyItemModel replyItem;
  final String? replyLevel;
  final bool? showReplyRow;
  final Function? replyReply;
  final ReplyType? replyType;
  final bool needDivider;
  final Function()? onReply;
  final Function(dynamic rpid, dynamic frpid)? onDelete;
  final VoidCallback? onViewImage;
  final ValueChanged<int>? onDismissed;
  final Function? getTag;
  final Function(List<String>, int)? callback;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        // 点击整个评论区 评论详情/回复
        onTap: () {
          feedBack();
          replyReply?.call(replyItem, null, null);
        },
        onLongPress: () {
          feedBack();
          showModalBottomSheet(
            context: context,
            useRootNavigator: true,
            isScrollControlled: true,
            builder: (context) {
              return MorePanel(
                item: replyItem,
                onDelete: (rpid) {
                  onDelete?.call(rpid, null);
                },
              );
            },
          );
        },
        child: Column(
          children: [
            if (ModuleAuthorModel.showDynDecorate &&
                (replyItem.member?.userSailing?.cardbg?['image'] as String?)
                        ?.isNotEmpty ==
                    true)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 8,
                    right: 12,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        CachedNetworkImage(
                          height: 38,
                          imageUrl:
                              replyItem.member?.userSailing?.cardbg?['image'],
                        ),
                        if ((replyItem.member?.userSailing?.cardbg?['fan']
                                    ?['num_desc'] as String?)
                                ?.isNotEmpty ==
                            true)
                          Text(
                            'NO.\n${replyItem.member?.userSailing?.cardbg?['fan']?['num_desc']}',
                            style:
                                (replyItem.member?.userSailing?.cardbg?['fan']
                                                ?['color'] as String?)
                                            ?.startsWith('#') ==
                                        true
                                    ? TextStyle(
                                        fontSize: 8,
                                        fontFamily: 'digital_id_num',
                                        color: Color(
                                          int.parse(
                                            replyItem.member?.userSailing
                                                ?.cardbg?['fan']?['color']
                                                .replaceFirst('#', '0xFF'),
                                          ),
                                        ),
                                      )
                                    : null,
                          ),
                      ],
                    ),
                  ),
                  _buildAuthorPanel(context),
                ],
              )
            else
              _buildAuthorPanel(context),
            if (needDivider)
              Divider(
                indent: 55,
                endIndent: 15,
                height: 0.3,
                color: Theme.of(context).colorScheme.outline.withOpacity(0.08),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorPanel(context) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 14, 8, 5),
        child: content(context),
      );

  Widget lfAvtar(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (ModuleAuthorModel.showDynDecorate &&
            replyItem.member?.pendant?.image?.isNotEmpty == true) ...[
          Padding(
            padding: const EdgeInsets.all(2),
            child: NetworkImgLayer(
              src: replyItem.member?.avatar,
              width: 30,
              height: 30,
              type: 'avatar',
            ),
          ),
          Positioned(
            left: -9,
            top: -9,
            child: IgnorePointer(
              child: CachedNetworkImage(
                width: 52,
                height: 52,
                imageUrl: replyItem.member!.pendant!.image!,
              ),
            ),
          ),
        ] else
          NetworkImgLayer(
            src: replyItem.member?.avatar,
            width: 34,
            height: 34,
            type: 'avatar',
          ),
        if ((replyItem.member?.vip?['vipStatus'] ?? -1) > 0)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                //borderRadius: BorderRadius.circular(7),
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Image.asset(
                'assets/images/big-vip.png',
                height: 14,
                semanticLabel: "大会员",
              ),
            ),
          ),
        //https://www.bilibili.com/blackboard/activity-whPrHsYJ2.html
        if (replyItem.member?.officialVerify?['type'] == 0)
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(8),
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surface,
              ),
              child: const Icon(
                Icons.offline_bolt,
                color: Colors.yellow,
                size: 14,
                semanticLabel: "认证个人",
              ),
            ),
          ),
        if (replyItem.member?.officialVerify?['type'] == 1)
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(8),
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surface,
              ),
              child: const Icon(
                Icons.offline_bolt,
                color: Colors.lightBlueAccent,
                size: 14,
                semanticLabel: "认证机构",
              ),
            ),
          ),
      ],
    );
  }

  Widget content(BuildContext context) {
    if (replyItem.member == null) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        /// fix Stack内GestureDetector  onTap无效
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            feedBack();
            Get.toNamed('/member?mid=${replyItem.mid}');
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              lfAvtar(context),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${replyItem.member?.uname}',
                        style: TextStyle(
                          color:
                              (replyItem.member?.vip?['vipStatus'] ?? 0) > 0 &&
                                      replyItem.member?.vip?['vipType'] == 2
                                  ? context.vipColor
                                  : Theme.of(context).colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Image.asset(
                        'assets/images/lv/lv${replyItem.member?.level}.png',
                        height: 11,
                      ),
                      const SizedBox(width: 6),
                      if (replyItem.isUp == true)
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
                        Utils.dateFormat(replyItem.ctime),
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelSmall!.fontSize,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      if (replyItem.replyControl?.location?.isNotEmpty == true)
                        Text(
                          ' • ${replyItem.replyControl!.location!}',
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .fontSize,
                              color: Theme.of(context).colorScheme.outline),
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
          padding:
              const EdgeInsets.only(top: 10, left: 45, right: 6, bottom: 4),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              String text = replyItem.content?.message ?? '';
              TextStyle style = TextStyle(
                height: 1.75,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
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
                      if (replyItem.isTop == true) ...[
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
                        replyItem,
                        replyReply,
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
        buttonAction(context, replyItem.replyControl),
        // 一楼的评论
        if (showReplyRow == true &&
            (replyItem.replyControl?.isShow == true ||
                replyItem.replies?.isNotEmpty == true ||
                replyItem.replyControl?.entryText?.isNotEmpty == true))
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 12),
            child: replyItemRow(
              context: context,
              replies: replyItem.replies,
              replyControl: replyItem.replyControl,
              // f_rpid: replyItem.rpid,
              replyItem: replyItem,
              replyReply: replyReply,
              onDelete: (rpid) {
                onDelete?.call(rpid, replyItem.rpid);
              },
            ),
          ),
      ],
    );
  }

  // 感谢、回复、复制
  Widget buttonAction(BuildContext context, replyControl) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 32),
        SizedBox(
          height: 32,
          child: TextButton(
            onPressed: () {
              feedBack();
              onReply?.call();
            },
            child: Row(children: [
              Icon(
                Icons.reply,
                size: 18,
                color: Theme.of(context).colorScheme.outline.withOpacity(0.8),
              ),
              const SizedBox(width: 3),
              Text(
                '回复',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ]),
          ),
        ),
        const SizedBox(width: 2),
        if (replyItem.upAction?.like == true) ...[
          SizedBox(
            height: 32,
            child: TextButton(
              onPressed: null,
              child: Text(
                'UP主觉得很赞',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          const SizedBox(width: 2),
        ],
        if (replyItem.cardLabel?.contains('热评') == true)
          Text(
            '热评',
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.labelMedium!.fontSize),
          ),
        const Spacer(),
        ZanButton(replyItem: replyItem, replyType: replyType),
        const SizedBox(width: 5)
      ],
    );
  }

  Widget replyItemRow({
    context,
    List<ReplyItemModel>? replies,
    ReplyControl? replyControl,
    required ReplyItemModel replyItem,
    replyReply,
    onDelete,
  }) {
    final bool hasExtraRow = replyControl?.isShow == true ||
        (replyControl?.entryText?.isNotEmpty == true &&
            replies?.isEmpty == true);
    return Container(
      margin: const EdgeInsets.only(left: 42, right: 4, top: 0),
      child: Material(
        color: Theme.of(context).colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(6),
        clipBehavior: Clip.hardEdge,
        animationDuration: Duration.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (replies?.isNotEmpty == true)
              for (int i = 0; i < replies!.length; i++) ...[
                InkWell(
                  // 一楼点击评论展开评论详情
                  onTap: () => replyReply?.call(replyItem, null, null),
                  onLongPress: () {
                    feedBack();
                    showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      isScrollControlled: true,
                      builder: (context) {
                        return MorePanel(
                          item: replies[i],
                          onDelete: onDelete,
                        );
                      },
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                      8,
                      i == 0 && (hasExtraRow || replies.length > 1) ? 8 : 4,
                      8,
                      i == 0 && (hasExtraRow || replies.length > 1) ? 4 : 6,
                    ),
                    child: Semantics(
                      label:
                          '${replies[i].member?.uname} ${replies[i].content?.message}',
                      excludeSemantics: true,
                      child: Text.rich(
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .fontSize,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.85),
                            height: 1.6),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${replies[i].member?.uname}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  feedBack();
                                  Get.toNamed(
                                      '/member?mid=${replies[i].member?.mid}');
                                },
                            ),
                            if (replies[i].isUp == true) ...[
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
                                text: replies[i].root == replies[i].parent
                                    ? ': '
                                    : replies[i].isUp == true
                                        ? ''
                                        : ' '),
                            buildContent(
                              context,
                              replies[i],
                              replyReply,
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
            if (hasExtraRow)
              InkWell(
                // 一楼点击【共xx条回复】展开评论详情
                onTap: () => replyReply?.call(replyItem, null, null),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(8, 5, 8, 8),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelMedium!.fontSize,
                      ),
                      children: [
                        if (replyControl?.upReply == true)
                          TextSpan(
                              text: 'UP主等人 ',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.85),
                              )),
                        TextSpan(
                          text: replyControl?.entryText,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
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
    replyItem,
    replyReply,
    fReplyItem,
    textPainter,
    didExceedMaxLines,
  ) {
    final String routePath = Get.currentRoute;
    bool isVideoPage = routePath.startsWith('/video');

    // replyItem 当前回复内容
    // replyReply 查看二楼回复（回复详情）回调
    // fReplyItem 父级回复内容，用作二楼回复（回复详情）展示
    final content = replyItem.content;
    String message = content.message ?? '';
    final List<InlineSpan> spanChildren = <InlineSpan>[];

    if (didExceedMaxLines == true) {
      final textSize = textPainter.size;
      var position = textPainter.getPositionForOffset(
        Offset(
          textSize.width,
          textSize.height,
        ),
      );
      final endOffset = textPainter.getOffsetBefore(position.offset);
      message = message.substring(0, endOffset);
    }

    // 投票
    if (content.vote.isNotEmpty) {
      message.splitMapJoin(RegExp(r"\{vote:\d+?\}"), onMatch: (Match match) {
        // String matchStr = match[0]!;
        spanChildren.add(
          TextSpan(
            text: '投票: ${content.vote['title']}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.toNamed(
                    '/webview',
                    parameters: {
                      'url': content.vote['url'],
                      'type': 'vote',
                      'pageTitle': content.vote['title'],
                    },
                  ),
          ),
        );
        return '';
      }, onNonMatch: (String str) {
        return str;
      });
      message = message.replaceAll(RegExp(r"\{vote:\d+?\}"), "");
    }
    message = parse(message).body?.text ?? message;
    // .replaceAll('&amp;', '&')
    // .replaceAll('&lt;', '<')
    // .replaceAll('&gt;', '>')
    // .replaceAll('&quot;', '"')
    // .replaceAll('&apos;', "'")
    // .replaceAll('&nbsp;', ' ');
    // 构建正则表达式
    final List<String> specialTokens = [
      ...content.emote.keys,
      ...content.topicsMeta?.keys?.map((e) => '#$e#') ?? [],
      ...content.atNameToMid.keys.map((e) => '@$e'),
    ];
    List<String> jumpUrlKeysList = content.jumpUrl.keys.map<String>((String e) {
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
      // TextSpan(
      //
      //     text: str,
      //     recognizer: TapGestureRecognizer()
      //       ..onTap = () => replyReply
      //           ?.call(replyItem.root == 0 ? replyItem : fReplyItem)))));
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
          final int size = content.emote[matchStr]['meta']['size'];
          String imgUrl = content.emote[matchStr]['webp_url'] ??
              content.emote[matchStr]['gif_url'] ??
              content.emote[matchStr]['url'];
          spanChildren.add(WidgetSpan(
            child: ExcludeSemantics(
                child: NetworkImgLayer(
              src: imgUrl,
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
          final int userId = content.atNameToMid[userName];
          spanChildren.add(
            TextSpan(
              text: matchStr,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.toNamed('/member?mid=$userId');
                },
            ),
          );
        } else if (RegExp(r'^\b(?:\d+[:：])?\d+[:：]\d+\b$').hasMatch(matchStr)) {
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
                      color: Theme.of(context).colorScheme.primary,
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
          if (content.jumpUrl[matchStr] != null &&
              !matchedStrs.contains(matchStr)) {
            appUrlSchema = content.jumpUrl[matchStr]['app_url_schema'];
            if (appUrlSchema.startsWith('bilibili://search') && !enableWordRe) {
              addPlainTextSpan(matchStr);
              return "";
            }
            spanChildren.addAll(
              [
                if (content.jumpUrl[matchStr]?['prefix_icon'] != null) ...[
                  WidgetSpan(
                    child: Image.network(
                      (content.jumpUrl[matchStr]['prefix_icon'] as String)
                          .http2https,
                      height: 19,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ],
                TextSpan(
                  text: content.jumpUrl[matchStr]['title'],
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      late final String title =
                          content.jumpUrl[matchStr]['title'];
                      if (appUrlSchema == '') {
                        if (RegExp(r'^(av|bv)', caseSensitive: false)
                            .hasMatch(matchStr)) {
                          UrlUtils.matchUrlPush(matchStr, '');
                        } else {
                          RegExpMatch? firstMatch = RegExp(
                                  r'^cv(\d+)$|/read/cv(\d+)|note-app/view\?cvid=(\d+)',
                                  caseSensitive: false)
                              .firstMatch(matchStr);
                          String? cvid = firstMatch?.group(1) ??
                              firstMatch?.group(2) ??
                              firstMatch?.group(3);
                          if (cvid != null) {
                            Get.toNamed('/htmlRender', parameters: {
                              'url': 'https://www.bilibili.com/read/cv$cvid',
                              'title': title,
                              'id': 'cv$cvid',
                              'dynamicType': 'read'
                            });
                            return;
                          }
                          Utils.handleWebview(matchStr);
                        }
                      } else {
                        if (appUrlSchema.startsWith('bilibili://search')) {
                          Get.toNamed('/searchResult',
                              parameters: {'keyword': title});
                        } else {
                          Utils.handleWebview(matchStr);
                        }
                      }
                    },
                )
              ],
            );
            // 只显示一次
            matchedStrs.add(matchStr);
          } else if (matchStr.length > 1 &&
              content.topicsMeta[matchStr.substring(1, matchStr.length - 1)] !=
                  null) {
            spanChildren.add(
              TextSpan(
                text: matchStr,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    final String topic =
                        matchStr.substring(1, matchStr.length - 1);
                    Get.toNamed('/searchResult',
                        parameters: {'keyword': topic});
                  },
              ),
            );
          } else if (RegExp(Constants.urlPattern).hasMatch(matchStr)) {
            spanChildren.add(
              TextSpan(
                text: matchStr,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Utils.handleWebview(matchStr);
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

    if (content.jumpUrl.keys.isNotEmpty) {
      List<String> unmatchedItems = content.jumpUrl.keys
          .toList()
          .where((item) => !content.message.contains(item))
          .toList();
      if (unmatchedItems.isNotEmpty) {
        for (int i = 0; i < unmatchedItems.length; i++) {
          String patternStr = unmatchedItems[i];
          if (content.jumpUrl?[patternStr]?['extra']?['is_word_search'] ==
                  true &&
              enableWordRe.not) {
            continue;
          }
          spanChildren.addAll(
            [
              if (content.jumpUrl[patternStr]?['prefix_icon'] != null) ...[
                WidgetSpan(
                  child: Image.network(
                    (content.jumpUrl[patternStr]['prefix_icon'] as String)
                        .http2https,
                    height: 19,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
              TextSpan(
                text: content.jumpUrl[patternStr]['title'],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    String? cvid = RegExp(r'note-app/view\?cvid=(\d+)')
                        .firstMatch(patternStr)
                        ?.group(1);
                    if (cvid != null) {
                      Get.toNamed('/htmlRender', parameters: {
                        'url': 'https://www.bilibili.com/read/cv$cvid',
                        'title': '',
                        'id': 'cv$cvid',
                        'dynamicType': 'read'
                      });
                      return;
                    }

                    Utils.handleWebview(patternStr);
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
            color: Theme.of(context).colorScheme.primary,
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
            builder: (context, constraints) => imageview(
              constraints.maxWidth,
              (content.pictures as List)
                  .map(
                    (item) => ImageModel(
                      width: item['img_width'],
                      height: item['img_height'],
                      url: item['img_src'],
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
    if (content.richText.isNotEmpty) {
      spanChildren.add(
        TextSpan(
          text: ' 笔记',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () =>
                Utils.handleWebview(content.richText['note']['click_url']),
        ),
      );
    }
    // spanChildren.add(TextSpan(text: matchMember));
    return TextSpan(children: spanChildren);
  }
}

class MorePanel extends StatelessWidget {
  final ReplyItemModel item;
  final Function(dynamic rpid)? onDelete;

  const MorePanel({super.key, required this.item, this.onDelete});

  Future<dynamic> menuActionHandler(String type) async {
    String message = item.content?.message ?? '';
    switch (type) {
      case 'report':
        Get.back();
        autoWrapReportDialog(Get.context!, ReportOptions.commentReport,
            (reasonType, reasonDesc, banUid) async {
          final res = await Request().post('/x/v2/reply/report',
              data: {
                'add_blacklist': banUid.toString(),
                'csrf': await Request.getCsrf(),
                'gaia_source': 'main_h5',
                'oid': item.oid.toString(),
                'platform': 'android',
                'reason': reasonType.toString(),
                'rpid': item.rpid.toString(),
                'scene': 'main',
                'type': '1',
                if (reasonType == 0) 'content': reasonDesc!
              },
              options: Options(contentType: Headers.formUrlEncodedContentType));
          return res.data as Map;
        });
        break;
      case 'copyAll':
        Get.back();
        Utils.copyText(message);
        break;
      case 'copyFreedom':
        Get.back();
        showDialog(
          context: Get.context!,
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
      // case 'block':
      //   SmartDialog.showToast('加入黑名单');
      //   break;
      // case 'report':
      //   SmartDialog.showToast('举报');
      //   break;
      case 'delete':
        //弹出确认提示：
        Get.back();
        bool? isDelete = await showDialog<bool>(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              title: const Text('删除评论（测试）'),
              content:
                  Text('确定尝试删除这条评论吗？\n\n$message\n\n注：只能删除自己的评论，或自己管理的评论区下的评论'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.back(result: false);
                  },
                  child: const Text('取消'),
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
            type: item.type!, oid: item.oid!, rpid: item.rpid!);
        SmartDialog.dismiss();
        if (result['status']) {
          SmartDialog.showToast('删除成功');
          onDelete?.call(item.rpid!);
        } else {
          SmartDialog.showToast('删除失败, ${result["msg"]}');
        }
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    Color errorColor = Theme.of(context).colorScheme.error;
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQueryData.fromView(
                      WidgetsBinding.instance.platformDispatcher.views.single)
                  .padding
                  .bottom +
              20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => Get.back(),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            child: Container(
              height: 35,
              padding: const EdgeInsets.only(bottom: 2),
              child: Center(
                child: Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outline,
                      borderRadius: const BorderRadius.all(Radius.circular(3))),
                ),
              ),
            ),
          ),
          // 已登录用户才显示删除
          if (GStorage.userInfo.get('userInfoCache') != null) ...[
            ListTile(
              onTap: () async => await menuActionHandler('delete'),
              minLeadingWidth: 0,
              leading: Icon(Icons.delete_outlined, color: errorColor, size: 19),
              title: Text('删除',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: errorColor)),
            ),
            ListTile(
              onTap: () async => await menuActionHandler('report'),
              minLeadingWidth: 0,
              leading: Icon(Icons.error_outline, color: errorColor, size: 19),
              title: Text('举报',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: errorColor)),
            ),
          ],
          ListTile(
            onTap: () async => await menuActionHandler('copyAll'),
            minLeadingWidth: 0,
            leading: const Icon(Icons.copy_all_outlined, size: 19),
            title: Text('复制全部', style: Theme.of(context).textTheme.titleSmall),
          ),
          ListTile(
            onTap: () async => await menuActionHandler('copyFreedom'),
            minLeadingWidth: 0,
            leading: const Icon(Icons.copy_outlined, size: 19),
            title: Text('自由复制', style: Theme.of(context).textTheme.titleSmall),
          ),

          // ListTile(
          //   onTap: () async => await menuActionHandler('block'),
          //   minLeadingWidth: 0,
          //   leading: Icon(Icons.block_outlined, color: errorColor),
          //   title: Text('加入黑名单', style: TextStyle(color: errorColor)),
          // ),
          // ListTile(
          //   onTap: () async => await menuActionHandler('report'),
          //   minLeadingWidth: 0,
          //   leading: Icon(Icons.report_outlined, color: errorColor),
          //   title: Text('举报', style: TextStyle(color: errorColor)),
          // ),
        ],
      ),
    );
  }
}
