import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/word_select_bar.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/home/rcmd/result.dart';
import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/pages/search/widgets/search_text.dart';
import 'package:PiliPlus/pages/video/ai_conclusion/view.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/recommend_filter.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class _VideoCustomAction {
  final String title;
  final Widget icon;
  final VoidCallback onTap;
  const _VideoCustomAction(this.title, this.icon, this.onTap);
}

class VideoPopupMenu extends StatelessWidget {
  final double? iconSize;
  final double menuItemHeight;
  final BaseSimpleVideoItemModel videoItem;
  final VoidCallback? onRemove;

  const VideoPopupMenu({
    super.key,
    required this.iconSize,
    required this.videoItem,
    this.onRemove,
    this.menuItemHeight = 45,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.more_vert_outlined,
        color: Theme.of(context).colorScheme.outline,
        size: iconSize,
      ),
      position: PopupMenuPosition.under,
      itemBuilder: (context) =>
          [
                if (videoItem.bvid?.isNotEmpty == true) ...[
                  _VideoCustomAction(
                    videoItem.bvid!,
                    const Icon(CustomIcons.identifier_circle, size: 16),
                    () => Utils.copyText(videoItem.bvid!),
                  ),
                  if (Accounts.main.isLogin)
                    _VideoCustomAction(
                      '稍后再看',
                      const Icon(MdiIcons.clockTimeEightOutline, size: 16),
                      () => UserHttp.toViewLater(bvid: videoItem.bvid),
                    ),
                  if (videoItem.cid != null && Pref.enableAi)
                    _VideoCustomAction(
                      'AI总结',
                      const Icon(CustomIcons.ai_circle, size: 16),
                      () async {
                        final res = await UgcIntroController.getAiConclusion(
                          videoItem.bvid!,
                          videoItem.cid!,
                          videoItem.owner.mid,
                        );
                        if (res != null && context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: Padding(
                                padding: const .symmetric(vertical: 14),
                                child: AiConclusionPanel.buildContent(
                                  context,
                                  Theme.of(context),
                                  res,
                                  tap: false,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                ],
                if (videoItem is! SpaceArchiveItem) ...[
                  _VideoCustomAction(
                    '访问：${videoItem.owner.name}',
                    const Icon(MdiIcons.accountCircleOutline, size: 16),
                    () => Get.toNamed('/member?mid=${videoItem.owner.mid}'),
                  ),
                  _VideoCustomAction(
                    '不感兴趣',
                    const Icon(MdiIcons.thumbDownOutline, size: 16),
                    () {
                      final rcmd = Accounts.get(.recommend);
                      if (rcmd.accessKey == null || rcmd.accessKey == "") {
                        SmartDialog.showToast(
                          rcmd.isLogin ? '请退出账号后重新登录' : '账号未登录',
                        );
                        return;
                      }
                      if (videoItem case final RcmdVideoItemAppModel item) {
                        ThreePoint? tp = item.threePoint;
                        if (tp == null) {
                          SmartDialog.showToast("未能获取threePoint");
                          return;
                        }
                        if (tp.dislikeReasons == null && tp.feedbacks == null) {
                          SmartDialog.showToast(
                            "未能获取dislikeReasons或feedbacks",
                          );
                          return;
                        }
                        Widget actionButton(Reason? r, Reason? f) {
                          return SearchText(
                            text: r?.name ?? f?.name ?? '未知',
                            onTap: (_) async {
                              Get.back();
                              SmartDialog.showLoading(msg: '正在提交');
                              final res = await VideoHttp.feedDislike(
                                reasonId: r?.id,
                                feedbackId: f?.id,
                                id: item.param!,
                                goto: item.goto!,
                              );
                              SmartDialog.dismiss();
                              if (res.isSuccess) {
                                SmartDialog.showToast(
                                  r?.toast ?? f!.toast!,
                                );
                                onRemove?.call();
                              } else {
                                res.toast();
                              }
                            },
                          );
                        }

                        showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              contentPadding: const .fromLTRB(24, 16, 24, 24),
                              children: [
                                if (tp.dislikeReasons != null) ...[
                                  const Text('我不想看'),
                                  const SizedBox(height: 5),
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: tp.dislikeReasons!
                                        .map((item) => actionButton(item, null))
                                        .toList(),
                                  ),
                                ],
                                if (tp.feedbacks != null) ...[
                                  const SizedBox(height: 5),
                                  const Text('反馈'),
                                  const SizedBox(height: 5),
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: tp.feedbacks!
                                        .map((item) => actionButton(null, item))
                                        .toList(),
                                  ),
                                ],
                                const Divider(),
                                Center(
                                  child: FilledButton.tonal(
                                    onPressed: () async {
                                      SmartDialog.showLoading(
                                        msg: '正在提交',
                                      );
                                      final res =
                                          await VideoHttp.feedDislikeCancel(
                                            id: item.param!,
                                            goto: item.goto!,
                                          );
                                      SmartDialog.dismiss();
                                      SmartDialog.showToast(
                                        res.isSuccess ? "成功" : res.toString(),
                                      );
                                      Get.back();
                                    },
                                    style: FilledButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    child: const Text("撤销"),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => SimpleDialog(
                            contentPadding: const .all(24),
                            children: [
                              const Center(child: Text("web端暂不支持精细选择")),
                              const SizedBox(height: 5),
                              Wrap(
                                spacing: 5.0,
                                runSpacing: 2.0,
                                alignment: .center,
                                children: [
                                  FilledButton.tonal(
                                    onPressed: () async {
                                      Get.back();
                                      SmartDialog.showLoading(msg: '正在提交');
                                      final res = await VideoHttp.dislikeVideo(
                                        bvid: videoItem.bvid!,
                                        type: true,
                                      );
                                      SmartDialog.dismiss();
                                      if (res.isSuccess) {
                                        SmartDialog.showToast('点踩成功');
                                        onRemove?.call();
                                      } else {
                                        res.toast();
                                      }
                                    },
                                    style: FilledButton.styleFrom(
                                      visualDensity: .compact,
                                    ),
                                    child: const Text("点踩"),
                                  ),
                                  FilledButton.tonal(
                                    onPressed: () async {
                                      Get.back();
                                      SmartDialog.showLoading(msg: '正在提交');
                                      final res = await VideoHttp.dislikeVideo(
                                        bvid: videoItem.bvid!,
                                        type: false,
                                      );
                                      SmartDialog.dismiss();
                                      SmartDialog.showToast(
                                        res.isSuccess ? '取消踩' : res.toString(),
                                      );
                                    },
                                    style: FilledButton.styleFrom(
                                      visualDensity: .compact,
                                    ),
                                    child: const Text("撤销"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  _VideoCustomAction(
                    '拉黑：${videoItem.owner.name}',
                    const Icon(MdiIcons.cancel, size: 16),
                    () => _showBlockVideoDialog(
                      context: context,
                      videoItem: videoItem,
                      onRemove: onRemove,
                    ),
                  ),
                ],
                _VideoCustomAction(
                  "${MineController.anonymity.value ? '退出' : '进入'}无痕模式",
                  MineController.anonymity.value
                      ? const Icon(MdiIcons.incognitoOff, size: 16)
                      : const Icon(MdiIcons.incognito, size: 16),
                  MineController.onChangeAnonymity,
                ),
              ]
              .map(
                (e) => PopupMenuItem(
                  height: menuItemHeight,
                  onTap: e.onTap,
                  child: Row(
                    children: [
                      e.icon,
                      const SizedBox(width: 6),
                      Text(e.title, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }
}

/// 视频卡片「拉黑」确认框：保留拉黑，同时提供标题关键词过滤，
/// 滑动选择标题中的连续词加入标题过滤词库，选词后立即移除该视频。
Future<void> _showBlockVideoDialog({
  required BuildContext context,
  required BaseSimpleVideoItemModel videoItem,
  required VoidCallback? onRemove,
}) async {
  final selectedWords = <String>[];
  await showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('提示'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '确定拉黑:${videoItem.owner.name}(${videoItem.owner.mid})?'
                '\n\n注：被拉黑的Up可以在隐私设置-黑名单管理中解除',
              ),
              const SizedBox(height: 12),
              Text(
                '标题关键词过滤（在标题上滑动选词加入屏蔽）：',
                style: TextStyle(
                  fontSize: 13,
                  color: ColorScheme.of(context).outline,
                ),
              ),
              const SizedBox(height: 8),
              WordSelectBar(
                text: videoItem.title,
                onWordsChanged: (words) {
                  selectedWords
                    ..clear()
                    ..addAll(words);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              '点错了',
              style: TextStyle(color: ColorScheme.of(context).outline),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              bool removed = false;
              // 选词即入标题过滤词库，并立即移除该视频
              if (selectedWords.isNotEmpty) {
                var pattern = RecommendFilter.rcmdRegExp.pattern;
                for (final w in selectedWords) {
                  final esc = RegExp.escape(w);
                  pattern = pattern.isEmpty ? esc : '$pattern|$esc';
                }
                RecommendFilter.rcmdRegExp = RegExp(
                  pattern,
                  caseSensitive: false,
                );
                RecommendFilter.enableFilter = pattern.isNotEmpty;
                GStorage.setting.put(
                  SettingBoxKey.banWordForRecommend,
                  pattern,
                );
                onRemove?.call();
                removed = true;
              }
              // 拉黑
              final res = await VideoHttp.relationMod(
                mid: videoItem.owner.mid!,
                act: 5,
                reSrc: 11,
              );
              if (res.isSuccess) {
                if (!removed) onRemove?.call();
              } else {
                res.toast();
              }
            },
            child: const Text('确认'),
          ),
        ],
      ),
    ),
  );
}
