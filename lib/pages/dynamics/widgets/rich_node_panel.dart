import 'dart:io' show Platform;

import 'package:PiliPlus/common/widgets/gesture/tap_gesture_recognizer.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/image_grid/image_grid_view.dart';
import 'package:PiliPlus/http/dynamics.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart'
    show SourceModel;
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/dynamics/widgets/vote.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

const _linkFoldedText = '网页链接';

// 富文本
TextSpan? richNode(
  BuildContext context, {
  required ThemeData theme,
  required DynamicItemModel item,
}) {
  try {
    late final style = TextStyle(color: theme.colorScheme.primary);
    List<InlineSpan> spanChildren = [];

    final moduleDynamic = item.modules.moduleDynamic;
    List<RichTextNodeItem>? richTextNodes;
    if (moduleDynamic?.desc case final desc?) {
      richTextNodes = desc.richTextNodes;
      if (richTextNodes == null || richTextNodes.isEmpty) {
        return TextSpan(text: desc.text);
      }
    } else if (moduleDynamic?.major?.opus case DynamicOpusModel(
      :final title,
      :final summary,
    )) {
      // 动态页面 richTextNodes 层级可能与主页动态层级不同
      richTextNodes = summary?.richTextNodes;
      if (title != null && title.isNotEmpty) {
        if (richTextNodes == null || richTextNodes.isEmpty) {
          return TextSpan(
            text: title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        } else {
          spanChildren.add(
            TextSpan(
              text: '$title\n',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }
      }
    }

    if (richTextNodes == null || richTextNodes.isEmpty) {
      return null;
    } else {
      for (final i in richTextNodes) {
        switch (i.type) {
          case 'RICH_TEXT_NODE_TYPE_TEXT':
            if (i.origText == _linkFoldedText) {
              item.linkFolded = true;
            }
            spanChildren.add(
              TextSpan(
                text: i.origText,
                style: const TextStyle(height: 1.65),
              ),
            );
            break;
          // @用户
          case 'RICH_TEXT_NODE_TYPE_AT':
            spanChildren.add(
              TextSpan(
                text: ' ${i.text}',
                style: style,
                recognizer: NoDeadlineTapGestureRecognizer()
                  ..onTap = () => Get.toNamed('/member?mid=${i.rid}'),
              ),
            );
            break;
          // 话题
          case 'RICH_TEXT_NODE_TYPE_TOPIC':
            spanChildren.add(
              TextSpan(
                text: i.origText,
                style: style,
                recognizer: NoDeadlineTapGestureRecognizer()
                  ..onTap = () => Get.toNamed(
                    '/searchResult',
                    parameters: {
                      'keyword': i.origText!.substring(
                        1,
                        i.origText!.length - 1,
                      ),
                    },
                  ),
              ),
            );
            break;
          // 网页链接
          case 'RICH_TEXT_NODE_TYPE_WEB':
            final hasLink = i.jumpUrl?.isNotEmpty ?? false;
            if (!hasLink) {
              item.linkFolded = true;
            }
            spanChildren
              ..add(
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.link,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                ),
              )
              ..add(
                TextSpan(
                  text: i.text,
                  style: style,
                  recognizer: hasLink
                      ? (NoDeadlineTapGestureRecognizer()
                          ..onTap = () => PageUtils.handleWebview(i.jumpUrl!))
                      : null,
                ),
              );
            break;
          // 投票
          case 'RICH_TEXT_NODE_TYPE_VOTE':
            spanChildren
              ..add(
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    size: 20,
                    Icons.bar_chart_rounded,
                    color: theme.colorScheme.primary,
                  ),
                ),
              )
              ..add(
                TextSpan(
                  text: '投票：${i.text}',
                  style: style,
                  recognizer: NoDeadlineTapGestureRecognizer()
                    ..onTap = () {
                      final dynIdStr = item.basic?.commentIdStr;
                      final dynId = dynIdStr != null
                          ? int.tryParse(dynIdStr)
                          : null;
                      showVoteDialog(context, int.parse(i.rid!), dynId);
                    },
                ),
              );
            break;
          // 表情
          case 'RICH_TEXT_NODE_TYPE_EMOJI' when (i.emoji != null):
            final size = i.emoji!.size * 20.0;
            spanChildren.add(
              WidgetSpan(
                child: NetworkImgLayer(
                  src: i.emoji!.url,
                  type: ImageType.emote,
                  width: size,
                  height: size,
                ),
              ),
            );
            break;
          // 抽奖
          case 'RICH_TEXT_NODE_TYPE_LOTTERY':
            spanChildren
              ..add(
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.redeem_rounded,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
              )
              ..add(
                TextSpan(
                  text: '${i.origText} ',
                  style: style,
                  recognizer: NoDeadlineTapGestureRecognizer()
                    ..onTap = () => Get.toNamed(
                      '/webview',
                      parameters: {
                        'url':
                            'https://www.bilibili.com/h5/lottery/result?business_id=${item.idStr}',
                      },
                    ),
                ),
              );
            break;

          case 'RICH_TEXT_NODE_TYPE_GOODS':
            spanChildren
              ..add(
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
              )
              ..add(
                TextSpan(
                  text: '${i.text} ',
                  style: style,
                  recognizer: i.jumpUrl == null
                      ? null
                      : (NoDeadlineTapGestureRecognizer()
                          ..onTap = () => PageUtils.handleWebview(i.jumpUrl!)),
                ),
              );
            break;
          // 投稿
          case 'RICH_TEXT_NODE_TYPE_BV':
            spanChildren
              ..add(
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.play_circle_outline_outlined,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
              )
              ..add(
                TextSpan(
                  text: '${i.text} ',
                  style: style,
                  recognizer: NoDeadlineTapGestureRecognizer()
                    ..onTap = () async {
                      try {
                        final res = await SearchHttp.ab2cWithDimension(
                          bvid: i.rid,
                        );
                        final cid = res?.cid;
                        if (cid != null) {
                          PageUtils.toVideoPage(
                            bvid: i.rid,
                            cid: cid,
                            dimension: res!.dimension,
                          );
                        }
                      } catch (err) {
                        SmartDialog.showToast(err.toString());
                      }
                    },
                ),
              );
            break;
          case 'RICH_TEXT_NODE_TYPE_VIEW_PICTURE':
            if (i.pics?.isNotEmpty == true) {
              spanChildren
                ..add(const TextSpan(text: '\n'))
                ..add(
                  WidgetSpan(
                    child: ImageGridView(
                      fullScreen: true,
                      picArr: i.pics!
                          .map(
                            (item) => ImageModel(
                              url: item.src ?? '',
                              width: item.width,
                              height: item.height,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
            } else {
              spanChildren.add(
                TextSpan(
                  text: i.text,
                  style: style,
                  recognizer: NoDeadlineTapGestureRecognizer()
                    ..onTap = () {
                      void onView(List<OpusPicModel> list) {
                        PageUtils.imageView(
                          imgList: list
                              .map((e) => SourceModel(url: e.src!))
                              .toList(),
                        );
                      }

                      if (i.pics?.isNotEmpty == true) {
                        onView(i.pics!);
                        return;
                      }
                      if (i.dynPic?.isNotEmpty == true) {
                        onView(i.dynPic!);
                        return;
                      }

                      DynamicsHttp.dynPic(i.rid).then((res) {
                        if (res case Success(:final response)) {
                          if (Platform.isAndroid) {
                            i.pics = response;
                          } else {
                            i.dynPic = response;
                          }
                          if (response != null && response.isNotEmpty) {
                            onView(response);
                          }
                        } else {
                          res.toast();
                        }
                      });
                    },
                ),
              );
            }
            break;
          case 'RICH_TEXT_NODE_TYPE_OGV_SEASON':
            spanChildren
              ..add(
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.play_circle_outline_outlined,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
              )
              ..add(
                TextSpan(
                  text: i.text,
                  style: style,
                  recognizer: i.jumpUrl == null
                      ? null
                      : (NoDeadlineTapGestureRecognizer()
                          ..onTap = () => PageUtils.handleWebview(i.jumpUrl!)),
                ),
              );
            break;
          default:
            spanChildren.add(
              TextSpan(
                text: i.text,
                style: style,
                recognizer: i.jumpUrl == null
                    ? null
                    : (NoDeadlineTapGestureRecognizer()
                        ..onTap = () => PageUtils.handleWebview(i.jumpUrl!)),
              ),
            );
            break;
        }
      }
      return TextSpan(children: spanChildren);
    }
  } catch (err) {
    if (kDebugMode) debugPrint('❌rich_node_panel err: $err');
    return null;
  }
}
