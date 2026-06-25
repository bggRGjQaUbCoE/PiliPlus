import 'dart:math';

import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/dialog/report.dart';
import 'package:PiliPlus/common/widgets/extra_hit_test_widget.dart';
import 'package:PiliPlus/common/widgets/pendant_avatar.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/reply.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/dynamics/controller.dart';
import 'package:PiliPlus/pages/save_panel/view.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/color_utils.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/extension/context_ext.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:PiliPlus/utils/feed_back.dart';
import 'package:PiliPlus/utils/image_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/share_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class AuthorPanel extends StatelessWidget {
  final DynamicItemModel item;
  final bool isSave;
  final bool isDetail;
  final ValueChanged<Object>? onRemove;
  final void Function(bool isTop, Object dynId)? onSetTop;
  final VoidCallback? onBlock;
  final Future<LoadingState> Function(bool isPrivate, Object dynId)?
  onSetPubSetting;
  final VoidCallback? onEdit;
  final ValueChanged<int>? onSetReplySubject;
  final ValueChanged<List<String>>? onAddBanWord;

  const AuthorPanel({
    super.key,
    required this.item,
    this.isDetail = false,
    this.onRemove,
    this.isSave = false,
    this.onSetTop,
    this.onBlock,
    this.onSetPubSetting,
    this.onEdit,
    this.onSetReplySubject,
    this.onAddBanWord,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final moduleAuthor = item.modules.moduleAuthor!;
    final pubTime = moduleAuthor.pubTs != null
        ? isSave
              ? DateFormatUtils.format(
                  moduleAuthor.pubTs,
                  format: DateFormatUtils.longFormatDs,
                )
              : DateFormatUtils.dateFormat(moduleAuthor.pubTs)
        : moduleAuthor.pubTime;
    Widget? pubTs;
    if (pubTime != null) {
      pubTs = Text(
        '$pubTime${moduleAuthor.pubAction != null ? ' ${moduleAuthor.pubAction}' : ''}',
        style: TextStyle(
          color: theme.colorScheme.outline,
          fontSize: theme.textTheme.labelSmall!.fontSize,
        ),
      );
      if (moduleAuthor.badgeText case final badgeText?) {
        pubTs = Row(
          mainAxisSize: .min,
          spacing: 5,
          children: [
            pubTs,
            Text(
              badgeText,
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: theme.textTheme.labelSmall!.fontSize,
              ),
            ),
          ],
        );
      }
    }
    Widget header = GestureDetector(
      onTap: moduleAuthor.type == 'AUTHOR_TYPE_NORMAL'
          ? () {
              feedBack();
              Get.toNamed('/member?mid=${moduleAuthor.mid}');
            }
          : null,
      child: ExtraHitTestWidget(
        width: 50,
        child: Row(
          spacing: 10,
          children: [
            PendantAvatar(
              size: 40,
              moduleAuthor.face,
              pendantImage: moduleAuthor.pendant?.image,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    moduleAuthor.name!,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: TextStyle(
                      color:
                          moduleAuthor.vip != null &&
                              moduleAuthor.vip!.status > 0 &&
                              moduleAuthor.vip!.type == 2
                          ? theme.colorScheme.vipColor
                          : theme.colorScheme.onSurface,
                      fontSize: theme.textTheme.titleSmall!.fontSize,
                    ),
                  ),
                  ?pubTs,
                ],
              ),
            ),
          ],
        ),
      ),
    );
    Widget? moreBtn = isSave
        ? null
        : SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
              tooltip: '更多',
              style: const ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.zero),
              ),
              onPressed: () => morePanel(context),
              icon: const Icon(Icons.more_vert_outlined, size: 18),
            ),
          );
    final moduleTagText = !isDetail ? item.modules.moduleTag?.text : null;
    if (moduleTagText != null) {
      header = Row(
        children: [
          Expanded(child: header),
          Container(
            padding: const .symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: const .all(.circular(4)),
              border: .all(width: 1.25, color: theme.colorScheme.primary),
            ),
            child: Text(
              moduleTagText,
              style: TextStyle(
                height: 1,
                fontSize: 12,
                color: theme.colorScheme.primary,
              ),
              strutStyle: const StrutStyle(height: 1, leading: 0, fontSize: 12),
            ),
          ),
          ?moreBtn,
        ],
      );
    } else if (moduleAuthor.decorate != null) {
      const height = 32.0;
      header = Stack(
        clipBehavior: .none,
        children: [
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: CachedNetworkImage(
                height: height,
                memCacheHeight: height.cacheSize(context),
                imageUrl: ImageUtils.safeThumbnailUrl(
                  moduleAuthor.decorate!.cardUrl,
                ),
                placeholder: (_, _) => const SizedBox.shrink(),
              ),
            ),
          ),
          if (moduleAuthor.decorate!.fan?.numStr?.isNotEmpty == true)
            Positioned(
              top: 0,
              bottom: 0,
              right: height,
              child: Center(
                child: Text(
                  moduleAuthor.decorate!.fan!.numStr!.toString(),
                  style: TextStyle(
                    height: 1,
                    fontSize: 11,
                    fontFamily: Assets.digitalNum,
                    color: ColourUtils.parseColor(
                      moduleAuthor.decorate!.fan!.color!,
                    ),
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
      if (moreBtn != null) {
        header = Row(
          children: [
            Expanded(child: header),
            moreBtn,
          ],
        );
      }
    } else if (moreBtn != null) {
      header = Row(
        children: [
          Expanded(child: header),
          moreBtn,
        ],
      );
    }
    return header;
  }

  void morePanel(BuildContext context) {
    String? bvid;
    try {
      String? getBvid(String? type, DynamicMajorModel? major) => switch (type) {
        'DYNAMIC_TYPE_AV' => major?.archive?.bvid,
        'DYNAMIC_TYPE_UGC_SEASON' => major?.ugcSeason?.bvid,
        _ => null,
      };
      bvid = getBvid(item.type, item.modules.moduleDynamic?.major);
      if (bvid == null && item.orig != null) {
        bvid = getBvid(
          item.orig!.type,
          item.orig!.modules.moduleDynamic?.major,
        );
      }
    } catch (_) {}

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxWidth: min(640, context.mediaQueryShortestSide),
      ),
      builder: (context1) {
        final theme = Theme.of(context);
        final moduleAuthor = item.modules.moduleAuthor!;
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewPaddingOf(context1).bottom,
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
                        borderRadius: const .all(.circular(1.5)),
                      ),
                    ),
                  ),
                ),
              ),
              if (bvid != null)
                ListTile(
                  onTap: () {
                    Get.back();
                    UserHttp.toViewLater(bvid: bvid);
                  },
                  minLeadingWidth: 0,
                  leading: const Icon(Icons.watch_later_outlined, size: 19),
                  title: Text(
                    '稍后再看',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
              ListTile(
                onTap: () {
                  Get.back();
                  SavePanel.toSavePanel(item: item);
                },
                minLeadingWidth: 0,
                leading: const Icon(Icons.save_alt, size: 19),
                title: Text('保存动态', style: theme.textTheme.titleSmall!),
              ),
              ListTile(
                title: Text(
                  '分享动态',
                  style: theme.textTheme.titleSmall,
                ),
                leading: const Icon(Icons.share_outlined, size: 19),
                onTap: () {
                  Get.back();
                  ShareUtils.shareText(
                    '${HttpString.dynamicShareBaseUrl}/${item.idStr}',
                  );
                },
                minLeadingWidth: 0,
              ),
              if ((item.basic!.commentType == 17 ||
                      item.basic!.commentType == 11) &&
                  item.modules.moduleDynamic?.major?.blocked == null)
                ListTile(
                  title: Text(
                    '分享至消息',
                    style: theme.textTheme.titleSmall,
                  ),
                  leading: const Icon(Icons.forward_to_inbox, size: 19),
                  onTap: () {
                    Get.back();
                    try {
                      bool isDyn = item.basic!.commentType == 17;
                      String id = isDyn ? item.idStr : item.basic!.ridStr!;
                      int source = isDyn ? 11 : 2;
                      final moduleDynamic = item.modules.moduleDynamic!;
                      final title =
                          moduleDynamic.desc?.text ??
                          moduleDynamic.major!.opus!.summary!.text!;
                      String? thumb = isDyn
                          ? moduleAuthor.face
                          : moduleDynamic.major?.opus?.pics?.firstOrNull?.url;
                      PageUtils.pmShare(
                        context,
                        content: {
                          "id": id,
                          "title": title,
                          "headline": "",
                          "source": source,
                          if (thumb?.isNotEmpty == true) "thumb": thumb,
                          "author": moduleAuthor.name,
                          "author_id": moduleAuthor.mid.toString(),
                        },
                      );
                    } catch (e) {
                      SmartDialog.showToast(e.toString());
                    }
                  },
                  minLeadingWidth: 0,
                ),
              ListTile(
                title: Text(
                  '临时屏蔽：${moduleAuthor.name}',
                  style: theme.textTheme.titleSmall,
                ),
                leading: const Icon(Icons.visibility_off_outlined, size: 19),
                onTap: () {
                  Get.back();
                  onBlock?.call();
                  try {
                    Get.find<DynamicsController>().tempBannedList.add(
                      moduleAuthor.mid!,
                    );
                    SmartDialog.showToast(
                      '已临时屏蔽${moduleAuthor.name}(${moduleAuthor.mid!})，重启恢复',
                    );
                  } catch (_) {}
                },
                minLeadingWidth: 0,
              ),
              if (onAddBanWord != null)
                ListTile(
                  onTap: () {
                    Get.back();
                    showKeywordBlockPanel(context);
                  },
                  minLeadingWidth: 0,
                  leading: const Icon(Icons.playlist_add, size: 19),
                  title: Text(
                    '屏蔽关键词…',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
              if (kDebugMode || moduleAuthor.mid == Accounts.main.mid) ...[
                ListTile(
                  onTap: () {
                    Get.back();
                    RequestUtils.checkCreatedDyn(
                      id: item.idStr,
                      isManual: true,
                    );
                  },
                  minLeadingWidth: 0,
                  leading: const Icon(CustomIcons.shield_published, size: 19),
                  title: Text('检查动态', style: theme.textTheme.titleSmall!),
                ),
                if (onSetTop != null)
                  ListTile(
                    onTap: () {
                      Get.back();
                      onSetTop!(moduleAuthor.isTop ?? false, item.idStr);
                    },
                    minLeadingWidth: 0,
                    leading: const Icon(Icons.vertical_align_top, size: 19),
                    title: Text(
                      '${moduleAuthor.isTop == true ? '取消' : ''}置顶',
                      style: theme.textTheme.titleSmall!,
                    ),
                  ),
                if (onSetReplySubject != null)
                  ListTile(
                    onTap: () async {
                      Get.back();
                      final res = await ReplyHttp.replyInteraction(
                        oid: item.basic!.commentIdStr!,
                        type: item.basic!.commentType!,
                      );
                      if (res case Success(:final response)) {
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final selection = response.upReplySelection;
                              final enableSelection = selection.status == 1;

                              final reply = response.upReply;
                              final enableReply = reply.status == 1;

                              return AlertDialog(
                                clipBehavior: .hardEdge,
                                contentPadding: const .symmetric(vertical: 12),
                                content: Column(
                                  mainAxisSize: .min,
                                  crossAxisAlignment: .start,
                                  children: [
                                    ListTile(
                                      dense: true,
                                      enabled: selection.canModify,
                                      title: Text(
                                        '${enableSelection ? '停止' : '开启'}评论精选',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      onTap: () {
                                        Get.back();
                                        onSetReplySubject!(
                                          enableSelection ? 2 : 1,
                                        );
                                      },
                                    ),
                                    ListTile(
                                      dense: true,
                                      enabled: reply.canModify,
                                      title: Text(
                                        '${enableReply ? '关闭' : '恢复'}评论',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      onTap: () {
                                        Get.back();
                                        onSetReplySubject!(enableReply ? 3 : 4);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      } else {
                        res.toast();
                      }
                    },
                    minLeadingWidth: 0,
                    leading: const Icon(
                      Icons.mark_unread_chat_alt_outlined,
                      size: 19,
                    ),
                    title: Text(
                      '互动设置',
                      style: theme.textTheme.titleSmall!,
                    ),
                  ),
                if (onSetPubSetting != null)
                  ListTile(
                    onTap: () {
                      Get.back();

                      final isPrivate = moduleAuthor.badgeText != null;
                      Future<void> onTap() async {
                        Get.back();
                        if ((await onSetPubSetting!(
                          isPrivate,
                          item.idStr,
                        )).isSuccess) {
                          if (context.mounted) {
                            (context as Element).markNeedsBuild();
                          }
                        }
                      }

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          clipBehavior: Clip.hardEdge,
                          contentPadding: const .symmetric(vertical: 12),
                          content: Column(
                            mainAxisSize: .min,
                            children: [
                              ListTile(
                                dense: true,
                                enabled: isPrivate,
                                title: const Text(
                                  '所有用户可见',
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: onTap,
                              ),
                              ListTile(
                                dense: true,
                                enabled: !isPrivate,
                                title: const Text(
                                  '仅自己可见',
                                  style: TextStyle(fontSize: 14),
                                ),
                                onTap: onTap,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    minLeadingWidth: 0,
                    leading: const Icon(Icons.visibility, size: 19),
                    title: Text('可见范围', style: theme.textTheme.titleSmall!),
                  ),
                if (onEdit != null)
                  ListTile(
                    onTap: () {
                      Get.back();
                      onEdit!();
                    },
                    minLeadingWidth: 0,
                    leading: const Icon(Icons.edit_note, size: 19),
                    title: Text('编辑动态', style: theme.textTheme.titleSmall!),
                  ),
                if (onRemove != null)
                  ListTile(
                    onTap: () {
                      Get.back();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('确定删除该动态?'),
                          actions: [
                            TextButton(
                              onPressed: Get.back,
                              child: Text(
                                '取消',
                                style: TextStyle(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                                onRemove!(item.idStr);
                              },
                              child: const Text('确定'),
                            ),
                          ],
                        ),
                      );
                    },
                    minLeadingWidth: 0,
                    leading: Icon(
                      Icons.delete_outline,
                      color: theme.colorScheme.error,
                      size: 19,
                    ),
                    title: Text(
                      '删除',
                      style: theme.textTheme.titleSmall!.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
              ],
              if (Accounts.main.isLogin)
                ListTile(
                  title: Text(
                    '举报',
                    style: theme.textTheme.titleSmall!.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  leading: Icon(
                    Icons.error_outline_outlined,
                    size: 19,
                    color: theme.colorScheme.error,
                  ),
                  onTap: () {
                    Get.back();
                    autoWrapReportDialog(
                      context,
                      ReportOptions.dynamicReport,
                      (reasonType, reasonDesc, banUid) {
                        if (banUid) {
                          VideoHttp.relationMod(
                            mid: moduleAuthor.mid!,
                            act: 5,
                            reSrc: 11,
                          );
                        }
                        return UserHttp.dynamicReport(
                          mid: moduleAuthor.mid!,
                          dynId: item.idStr,
                          reasonType: reasonType,
                          reasonDesc: reasonType == 0 ? reasonDesc : null,
                        );
                      },
                    );
                  },
                  minLeadingWidth: 0,
                ),
              const Divider(thickness: 0.1, height: 1),
              ListTile(
                onTap: Get.back,
                minLeadingWidth: 0,
                dense: true,
                title: Text(
                  '取消',
                  style: TextStyle(color: theme.colorScheme.outline),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 提取动态文本中的候选关键词
  static List<String> _extractKeywords(DynamicItemModel item) {
    final moduleDynamic = item.modules.moduleDynamic;
    final opus = moduleDynamic?.major?.opus;
    final texts = <String>[
      ?opus?.title,
      ?opus?.summary?.text,
      ?moduleDynamic?.desc?.text,
      ...switch (moduleDynamic?.major?.type) {
        'MAJOR_TYPE_ARCHIVE' => [moduleDynamic?.major?.archive?.title ?? ''],
        'MAJOR_TYPE_UGC_SEASON' => [
          moduleDynamic?.major?.ugcSeason?.title ?? '',
        ],
        'MAJOR_TYPE_PGC' => [moduleDynamic?.major?.pgc?.title ?? ''],
        'MAJOR_TYPE_COURSES' => [moduleDynamic?.major?.courses?.title ?? ''],
        _ => <String>[],
      },
    ];

    // 同时提取转发来源（orig）中的文本
    if (item.orig case final orig?) {
      final origDynamic = orig.modules.moduleDynamic;
      final origOpus = origDynamic?.major?.opus;
      texts.addAll([
        ?origOpus?.title,
        ?origOpus?.summary?.text,
        ?origDynamic?.desc?.text,
        ...switch (origDynamic?.major?.type) {
          'MAJOR_TYPE_ARCHIVE' => [origDynamic?.major?.archive?.title ?? ''],
          'MAJOR_TYPE_UGC_SEASON' => [
            origDynamic?.major?.ugcSeason?.title ?? '',
          ],
          'MAJOR_TYPE_PGC' => [origDynamic?.major?.pgc?.title ?? ''],
          'MAJOR_TYPE_COURSES' => [origDynamic?.major?.courses?.title ?? ''],
          _ => <String>[],
        },
      ]);
    }

    final candidates = <String>{};
    for (final text in texts) {
      // 按标点符号拆分
      for (final segment in text.split(RegExp(r'[，。！？,\.!?\、；;：:\|\s\n\r]+'))) {
        final trimmed = segment.trim();
        if (trimmed.length >= 2 && trimmed.length <= 30) {
          candidates.add(trimmed);
        }
      }
    }
    final result = candidates.toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    return result.take(15).toList();
  }

  void showKeywordBlockPanel(BuildContext context) {
    final keywords = _extractKeywords(item);
    if (keywords.isEmpty) {
      SmartDialog.showToast('未提取到可屏蔽的关键词');
      return;
    }

    // 获取已存在的屏蔽词列表
    final existingBanWords =
        (GStorage.setting.get(SettingBoxKey.banWordForDyn, defaultValue: '')
                as String)
            .split('|')
            .where((w) => w.isNotEmpty)
            .map((w) => w.toLowerCase())
            .toSet();

    final customInputController = TextEditingController();
    final customInputFocusNode = FocusNode();
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxWidth: min(640, context.mediaQueryShortestSide),
      ),
      builder: (context1) {
        final theme = Theme.of(context);
        // 暂存用户选中的关键词（不立即保存）
        final pendingAdds = <String>{};
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewPaddingOf(context1).bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题栏
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 12, 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '选择要屏蔽的关键词',
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        IconButton(
                          onPressed: Get.back,
                          icon: Icon(
                            Icons.close,
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '点击切换选中，长按可填入输入框编辑',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ),
                  const Divider(height: 16),
                  // 关键词列表
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: keywords.length,
                      itemBuilder: (context, index) {
                        final keyword = keywords[index];
                        final isExisting = existingBanWords.contains(
                          keyword.toLowerCase(),
                        );
                        final isPending = pendingAdds.contains(keyword);

                        IconData leadingIcon;
                        Color iconColor;
                        Color? textColor;
                        TextDecoration? textDecoration;
                        bool canTap;

                        if (isExisting) {
                          leadingIcon = Icons.check_circle;
                          iconColor = Colors.green;
                          textColor = theme.colorScheme.outline;
                          textDecoration = TextDecoration.lineThrough;
                          canTap = false;
                        } else if (isPending) {
                          leadingIcon = Icons.remove_circle_outline;
                          iconColor = theme.colorScheme.error;
                          canTap = true;
                        } else {
                          leadingIcon = Icons.add_circle_outline;
                          iconColor = theme.colorScheme.primary;
                          canTap = true;
                        }

                        return Tooltip(
                          message: canTap ? '长按填入输入框编辑' : '已屏蔽',
                          child: ListTile(
                            dense: true,
                            enabled: canTap || isExisting,
                            leading: Icon(
                              leadingIcon,
                              size: 22,
                              color: iconColor,
                            ),
                            title: Text(
                              keyword,
                              style: TextStyle(
                                fontSize: 14,
                                decoration: textDecoration,
                                color: textColor,
                              ),
                            ),
                            subtitle: isExisting
                                ? const Text(
                                    '已屏蔽',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.green,
                                    ),
                                  )
                                : null,
                            onTap: canTap
                                ? () {
                                    setDialogState(() {
                                      if (isPending) {
                                        pendingAdds.remove(keyword);
                                      } else {
                                        pendingAdds.add(keyword);
                                      }
                                    });
                                  }
                                : null,
                            onLongPress: () {
                              customInputController
                                ..text = keyword
                                ..selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: keyword.length,
                                );
                              customInputFocusNode.requestFocus();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  // 自定义输入关键词
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 36,
                            child: TextField(
                              controller: customInputController,
                              focusNode: customInputFocusNode,
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                hintText: '输入自定义关键词',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: theme.colorScheme.outline,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.outlineVariant,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.outlineVariant,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              onSubmitted: (value) {
                                final trimmed = value.trim();
                                if (trimmed.contains('|')) {
                                  SmartDialog.showToast('关键词不能包含 | 字符');
                                  return;
                                }
                                if (trimmed.length < 2) {
                                  SmartDialog.showToast('关键词至少需要 2 个字符');
                                  return;
                                }
                                setDialogState(() {
                                  pendingAdds.add(trimmed);
                                  customInputController.clear();
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          color: theme.colorScheme.primary,
                          onPressed: () {
                            final trimmed = customInputController.text.trim();
                            if (trimmed.contains('|')) {
                              SmartDialog.showToast('关键词不能包含 | 字符');
                              return;
                            }
                            if (trimmed.length < 2) {
                              SmartDialog.showToast('关键词至少需要 2 个字符');
                              return;
                            }
                            setDialogState(() {
                              pendingAdds.add(trimmed);
                              customInputController.clear();
                            });
                            customInputFocusNode.unfocus();
                          },
                          tooltip: '添加自定义关键词',
                        ),
                      ],
                    ),
                  ),
                  // 自定义关键词标签（可反悔）
                  Builder(
                    builder: (context) {
                      final customPending = pendingAdds
                          .where((k) => !keywords.contains(k))
                          .toList();
                      if (customPending.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: customPending.map((k) {
                            return Chip(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              label: Text(
                                k,
                                style: const TextStyle(fontSize: 12),
                              ),
                              deleteIcon: const Icon(Icons.close, size: 14),
                              onDeleted: () {
                                setDialogState(() => pendingAdds.remove(k));
                              },
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 8),
                  // 底部操作栏
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: Get.back,
                              child: Text(
                                '取消',
                                style: TextStyle(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: FilledButton(
                              onPressed: pendingAdds.isNotEmpty
                                  ? () {
                                      Get.back();
                                      onAddBanWord?.call(
                                        pendingAdds.toList(),
                                      );
                                    }
                                  : null,
                              child: Text(
                                pendingAdds.isNotEmpty
                                    ? '确认添加（${pendingAdds.length}）'
                                    : '确认添加',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      customInputController.dispose();
      customInputFocusNode.dispose();
    });
  }
}
