import 'dart:convert';

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/grpc/bilibili/im/interfaces/v1.pb.dart'
    show EmotionInfo;
import 'package:PiliPlus/grpc/bilibili/im/type.pb.dart' show Msg, MsgType;
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class ChatItem extends StatelessWidget {
  static MsgType msgTypeFromValue(int value) {
    return MsgType.valueOf(value) ?? MsgType.EN_INVALID_MSG_TYPE;
  }

  const ChatItem({
    super.key,
    required this.item,
    this.eInfos,
    this.onLongPress,
  }) : isOwner = onLongPress != null;

  final Msg item;
  final List<EmotionInfo>? eInfos;
  final VoidCallback? onLongPress;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    bool isPic = item.msgType == MsgType.EN_MSG_TYPE_PIC.value; // 图片
    bool isRevoke = item.msgType == MsgType.EN_MSG_TYPE_DRAW_BACK.value; // 撤回消息
    bool isSystem = item.msgType == MsgType.EN_MSG_TYPE_TIP_MESSAGE.value ||
        item.msgType == MsgType.EN_MSG_TYPE_NOTIFY_MSG.value ||
        item.msgType == MsgType.EN_MSG_TYPE_PICTURE_CARD.value ||
        item.msgType == MsgType.EN_MSG_TYPE_SYS_GROUP_AUTO_CREATED.value;

    late final ThemeData theme = Theme.of(context);
    late final Color textColor = isOwner
        ? theme.colorScheme.onSecondaryContainer
        : theme.colorScheme.onSurfaceVariant;
    late final dynamic content = jsonDecode(item.content);

    return isRevoke
        ? const SizedBox.shrink()
        : isSystem
            ? messageContent(
                context: context,
                theme: theme,
                content: content,
                textColor: textColor,
              )
            : GestureDetector(
                onLongPress: () {
                  Feedback.forLongPress(context);
                  onLongPress?.call();
                },
                child: Row(
                  mainAxisAlignment:
                      isOwner ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 300.0),
                      decoration: BoxDecoration(
                        color: isOwner
                            ? theme.colorScheme.secondaryContainer
                            : theme.colorScheme.onInverseSurface,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isOwner ? 16 : 6),
                          bottomRight: Radius.circular(isOwner ? 6 : 16),
                        ),
                      ),
                      padding: EdgeInsets.only(
                        top: 8,
                        bottom: 6,
                        left: isPic ? 8 : 12,
                        right: isPic ? 8 : 12,
                      ),
                      child: Column(
                        crossAxisAlignment: isOwner
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          messageContent(
                            context: context,
                            theme: theme,
                            content: content,
                            textColor: textColor,
                          ),
                          SizedBox(height: isPic ? 7 : 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                Utils.dateFormat(item.timestamp.toInt()),
                                style: theme.textTheme.labelSmall!.copyWith(
                                    color: isOwner
                                        ? theme.colorScheme.onSecondaryContainer
                                            .withOpacity(0.8)
                                        : theme.colorScheme.onSurfaceVariant
                                            .withOpacity(0.8)),
                              ),
                              if (item.msgStatus == 1)
                                Text(
                                  '  已撤回',
                                  style: theme.textTheme.labelSmall!.copyWith(
                                    color: theme.colorScheme.onErrorContainer,
                                  ),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
  }

  Widget messageContent({
    required BuildContext context,
    required ThemeData theme,
    required content,
    required Color textColor,
  }) {
    try {
      switch (msgTypeFromValue(item.msgType)) {
        case MsgType.EN_MSG_TYPE_NOTIFY_MSG:
          return msgTypeNotifyMsg_10(theme, content);
        case MsgType.EN_MSG_TYPE_PICTURE_CARD:
          return msgTypePictureCard_13(content);
        case MsgType.EN_MSG_TYPE_TIP_MESSAGE:
          return msgTypeTipMessage_18(theme, content);
        case MsgType.EN_MSG_TYPE_TEXT:
          return msgTypeText_1(content: content, textColor: textColor);
        case MsgType.EN_MSG_TYPE_PIC:
          return msgTypePic_2(context, content);
        case MsgType.EN_MSG_TYPE_SHARE_V2:
          return msgTypeShareV2_7(content, textColor);
        case MsgType.EN_MSG_TYPE_VIDEO_CARD:
          return msgTypeVideoCard_11(content, textColor);
        case MsgType.EN_MSG_TYPE_SYS_GROUP_AUTO_CREATED:
          return msgTypeSysGroupAutoCreated_208(theme, content, textColor);
        case MsgType.EN_MSG_TYPE_ARTICLE_CARD:
          return msgTypeArticleCard_12(content, textColor);
        case MsgType.EN_MSG_TYPE_COMMON_SHARE_CARD:
          return msgTypeCommonShareCard_14(content, textColor);
        default:
          return def(textColor);
      }
    } catch (err) {
      return def(textColor, err: err);
    }
  }

  Widget msgTypeCommonShareCard_14(content, Color textColor) {
    if (content['source'] == '直播') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed('/liveRoom?roomid=${content['sourceID']}');
            },
            child: NetworkImgLayer(
              width: 220,
              height: 220 * 9 / 16,
              src: content['cover'],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content['title'] ?? "",
            style: TextStyle(
              letterSpacing: 0.6,
              height: 1.5,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            '${content['author']} · 直播',
            style: TextStyle(
              letterSpacing: 0.6,
              height: 1.5,
              color: textColor.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      );
    } else {
      return def(textColor);
    }
  }

  Widget msgTypeArticleCard_12(content, Color textColor) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          '/articlePage',
          parameters: {
            'id': '${content['rid']}',
            'type': "read",
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i in content['image_urls'])
                NetworkImgLayer(
                  width: 130,
                  height: 130 * 9 / 16,
                  src: i,
                ),
            ],
          ),
          const SizedBox(height: 6),
          SelectableText(
            content['title'] ?? "",
            style: TextStyle(
              letterSpacing: 0.6,
              height: 1.5,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 1),
          SelectableText(
            content['summary'] ?? "",
            style: TextStyle(
              letterSpacing: 0.6,
              height: 1.5,
              color: textColor.withOpacity(0.6),
              fontSize: 12,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget msgTypeSysGroupAutoCreated_208(
      ThemeData theme, content, Color textColor) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: theme.colorScheme.onInverseSurface,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content['main_title'],
              style: TextStyle(
                letterSpacing: 0.6,
                height: 1.5,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            for (var i in content['sub_cards']) ...[
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () async {
                  RegExp bvRegex =
                      RegExp(r'BV[0-9A-Za-z]{10}', caseSensitive: false);
                  Iterable<Match> matches = bvRegex.allMatches(i['jump_url']);
                  if (matches.isNotEmpty) {
                    Match match = matches.first;
                    String bvid = match.group(0)!;
                    try {
                      SmartDialog.showLoading();
                      final int cid = await SearchHttp.ab2c(bvid: bvid);
                      SmartDialog.dismiss<dynamic>().then(
                        (e) => PageUtils.toVideoPage('bvid=$bvid&cid=$cid',
                            arguments: <String, String?>{
                              'pic': i['cover_url'],
                              'heroTag': Utils.makeHeroTag(bvid),
                            }),
                      );
                    } catch (err) {
                      SmartDialog.dismiss();
                      SmartDialog.showToast(err.toString());
                    }
                  } else {
                    SmartDialog.showToast('未匹配到 BV 号');
                    PageUtils.handleWebview(i['jump_url']);
                  }
                },
                child: Row(
                  children: [
                    NetworkImgLayer(
                      width: 130,
                      height: 130 * 9 / 16,
                      src: i['cover_url'],
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            i['field1'],
                            maxLines: 2,
                            style: TextStyle(
                              letterSpacing: 0.6,
                              height: 1.5,
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            i['field2'],
                            style: TextStyle(
                              letterSpacing: 0.6,
                              height: 1.5,
                              color: textColor.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            i['field3'],
                            style: TextStyle(
                              letterSpacing: 0.6,
                              height: 1.5,
                              color: textColor.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget msgTypeVideoCard_11(content, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            try {
              SmartDialog.showLoading();
              var bvid = content["bvid"];
              final int cid = await SearchHttp.ab2c(bvid: bvid);
              SmartDialog.dismiss().then(
                (_) => PageUtils.toVideoPage(
                  'bvid=$bvid&cid=$cid',
                  arguments: {
                    'pic': content['thumb'],
                    'heroTag': Utils.makeHeroTag(bvid),
                  },
                ),
              );
            } catch (err) {
              SmartDialog.dismiss();
              SmartDialog.showToast(err.toString());
            }
          },
          child: NetworkImgLayer(
            width: 220,
            height: 220 * 9 / 16,
            src: content['cover'],
          ),
        ),
        const SizedBox(height: 6),
        SelectableText(
          content['title'],
          style: TextStyle(
            letterSpacing: 0.6,
            height: 1.5,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          Utils.timeFormat(content['times']),
          style: TextStyle(
            letterSpacing: 0.6,
            height: 1.5,
            color: textColor.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget msgTypeShareV2_7(content, Color textColor) {
    String? type;
    GestureTapCallback onTap;
    switch (content['source']) {
      // album
      case 2:
        type = '相簿';
        onTap = () {
          PageUtils.pushDynFromId(rid: content['id']);
        };
        break;

      // video
      case 5:
        type = '视频';
        onTap = () async {
          dynamic aid = content['id'];
          if (aid is String) {
            aid = int.tryParse(aid);
          }
          dynamic bvid = content["bvid"];
          if (aid == null && bvid == null) {
            SmartDialog.showToast('null');
          }
          bvid ??= IdUtils.av2bv(aid);
          SmartDialog.showLoading();
          final int cid = await SearchHttp.ab2c(bvid: bvid);
          SmartDialog.dismiss<dynamic>().then(
            (e) => PageUtils.toVideoPage(
              'bvid=$bvid&cid=$cid',
              arguments: <String, String?>{
                'pic': content['thumb'],
                'heroTag': Utils.makeHeroTag(bvid),
              },
            ),
          );
        };
        break;

      // article
      case 6:
        type = '专栏';
        onTap = () {
          Get.toNamed(
            '/articlePage',
            parameters: {
              'id': '${content['id']}',
              'type': 'read',
            },
          );
        };
        break;

      // dynamic
      case 11:
        type = '动态';
        onTap = () {
          PageUtils.pushDynFromId(id: content['id']);
        };
        break;

      // pgc
      case 16:
        onTap = () {
          PageUtils.viewBangumi(epId: content['id']);
        };
        break;

      default:
        onTap = () {
          SmartDialog.showToast(
              'unsupported source type: ${content['source']}');
        };
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: NetworkImgLayer(
            width: 220,
            height: 220 * 9 / 16,
            src: content['thumb'],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          content['title'] ?? "",
          style: TextStyle(
            letterSpacing: 0.6,
            height: 1.5,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (content['source'] == 6 &&
            (content['headline'] as String?)?.isNotEmpty == true) ...[
          const SizedBox(height: 1),
          Text(
            content['headline'],
            style: TextStyle(
              letterSpacing: 0.6,
              height: 1.5,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
        if (content['author'] != null) ...[
          const SizedBox(height: 1),
          Text(
            '${content['author']}${type != null ? ' · $type' : ''}',
            style: TextStyle(
              letterSpacing: 0.6,
              height: 1.5,
              color: textColor.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget msgTypePic_2(BuildContext context, content) {
    return GestureDetector(
      onTap: () {
        context.imageView(imgList: [SourceModel(url: content['url'])]);
      },
      child: Hero(
        tag: content['url'],
        child: NetworkImgLayer(
          width: 220,
          height: 220 * content['height'] / content['width'],
          src: content['url'],
        ),
      ),
    );
  }

  Widget msgTypeTipMessage_18(ThemeData theme, content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        jsonDecode(content['content']).map((e) => e['text']).join("\n"),
        textAlign: TextAlign.center,
        style: TextStyle(
          height: 1.5,
          letterSpacing: 0.6,
          color: theme.colorScheme.outline.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget msgTypeText_1({
    required content,
    required Color textColor,
  }) {
    late final style = TextStyle(
      color: textColor,
      letterSpacing: 0.6,
      height: 1.5,
    );
    if (eInfos != null) {
      final List<InlineSpan> children = [];
      Map<String, Map> emojiMap = {};
      for (var e in eInfos!) {
        emojiMap[e.text] = {
          'url': e.hasGifUrl() ? e.gifUrl : e.url,
          'size': e.size * 24.0,
        };
      }
      content['content'].splitMapJoin(
        RegExp(r"\[[^\[\]]+\]"),
        onMatch: (Match match) {
          final String emojiKey = match[0]!;
          if (emojiMap.containsKey(emojiKey)) {
            children.add(
              WidgetSpan(
                child: NetworkImgLayer(
                  width: emojiMap[emojiKey]!['size'],
                  height: emojiMap[emojiKey]!['size'],
                  src: emojiMap[emojiKey]!['url'],
                  type: ImageType.emote,
                ),
              ),
            );
          } else {
            children.add(TextSpan(text: emojiKey, style: style));
          }
          return '';
        },
        onNonMatch: (String text) {
          children.add(TextSpan(text: text, style: style));
          return '';
        },
      );
      return SelectableText.rich(TextSpan(children: children));
    }
    return SelectableText(content['content'], style: style);
  }

  Widget msgTypeNotifyMsg_10(ThemeData theme, content) {
    List? modules = content['modules'] as List?;
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: theme.colorScheme.onInverseSurface,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              content['title'],
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              Utils.dateFormat(item.timestamp.toInt()),
              style: theme.textTheme.labelSmall!
                  .copyWith(color: theme.colorScheme.outline),
            ),
            Divider(color: theme.colorScheme.primary.withOpacity(0.05)),
            SelectableText(content['text']),
            if (modules?.isNotEmpty == true) ...[
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  children: modules!.indexed
                      .map((e) => TextSpan(children: [
                            TextSpan(
                                text: e.$2['title'],
                                style: TextStyle(
                                    color: theme.colorScheme.outline)),
                            TextSpan(text: '    ${e.$2['detail']}'),
                            if (e.$1 != modules.length - 1)
                              const TextSpan(text: '\n'),
                          ]))
                      .toList(),
                ),
              ),
            ],
            if ((content['jump_text'] as String?)?.isNotEmpty == true &&
                (content['jump_uri'] as String?)?.isNotEmpty == true) ...[
              Divider(color: theme.colorScheme.primary.withOpacity(0.05)),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  PiliScheme.routePushFromUrl(content['jump_uri']);
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Text(content['jump_text']),
                ),
              ),
            ],
            if ((content['jump_text_2'] as String?)?.isNotEmpty == true &&
                (content['jump_uri_2'] as String?)?.isNotEmpty == true) ...[
              Divider(color: theme.colorScheme.primary.withOpacity(0.05)),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  PiliScheme.routePushFromUrl(content['jump_uri_2']);
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Text(content['jump_text_2']),
                ),
              ),
            ],
            if ((content['jump_text_3'] as String?)?.isNotEmpty == true &&
                (content['jump_uri_3'] as String?)?.isNotEmpty == true) ...[
              Divider(color: theme.colorScheme.primary.withOpacity(0.05)),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  PiliScheme.routePushFromUrl(content['jump_uri_3']);
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Text(content['jump_text_3']),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget msgTypePictureCard_13(content) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400.0),
        child: ClipRRect(
          borderRadius: StyleString.mdRadius,
          child: GestureDetector(
            onTap: content['jump_url'] == null
                ? null
                : () {
                    PiliScheme.routePushFromUrl(content['jump_url']);
                  },
            child: CachedNetworkImage(
              imageUrl: Utils.thumbnailImgUrl(content['pic_url']),
            ),
          ),
        ),
      ),
    );
  }

  Widget def(Color textColor, {err}) {
    return Text(
      '${item.content}${err != null ? '\n\ntype: ${msgTypeFromValue(item.msgType)}\nerr: $err' : ''}',
      style: TextStyle(
        letterSpacing: 0.6,
        height: 1.5,
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
