import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/flutter/popup_menu.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/home/rcmd/result.dart';
import 'package:PiliPlus/models/model_hot_video_item.dart';
import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/pages/video/ai_conclusion/view.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/recommend_filter.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/user_whitelist.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_ui/material_ui.dart';

class _VideoCustomAction {
  final String title;
  final Widget icon;
  final VoidCallback onTap;
  const _VideoCustomAction(this.title, this.icon, this.onTap);
}

class _DialogChipAction {
  final String label;
  final VoidCallback onPressed;
  const _DialogChipAction({required this.label, required this.onPressed});
}

class _DialogSection {
  final String? title;
  final List<_DialogChipAction> actions;
  const _DialogSection({this.title, required this.actions});
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

  void _addBlockedUser() {
    final mid = videoItem.owner.mid;
    if (mid == null) {
      SmartDialog.showToast('无法获取用户ID');
      return;
    }
    final blockedMids = Pref.recommendBlockedMids;
    final name = videoItem.owner.name ?? 'UID:$mid';
    blockedMids[mid] = name;
    Pref.recommendBlockedMids = blockedMids;
    GlobalData().recommendBlockedMids = blockedMids;
    RecommendFilter.recommendBlockedMids = blockedMids;
    SmartDialog.showToast('已屏蔽$name($mid)，可在推荐流设置中管理');
    onRemove?.call();
  }

  void _addWhitelistedUser() {
    final mid = videoItem.owner.mid;
    if (mid == null) {
      SmartDialog.showToast('无法获取用户ID');
      return;
    }
    final name = videoItem.owner.name ?? 'UID:$mid';
    UserWhitelist.add(mid: mid, name: name);
    SmartDialog.showToast('已将$name($mid)加入白名单');
  }

  void _appendKeyword({
    required String key,
    required String value,
    required void Function(RegExp) applyRegex,
    required String successMsg,
  }) {
    final keyword = value.trim();
    if (keyword.isEmpty) {
      SmartDialog.showToast('关键词为空');
      return;
    }
    final escapedKeyword = RegExp.escape(keyword);
    final stored = GStorage.setting.get(key, defaultValue: '') as String;
    final items = stored
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (!items.contains(escapedKeyword)) {
      items.add(escapedKeyword);
      final joined = items.join('\n');
      GStorage.setting.put(key, joined);
      applyRegex(
        RegExp(Pref.parseBanWordToRegex(joined), caseSensitive: false),
      );
      SmartDialog.showToast(successMsg);
      onRemove?.call();
      return;
    }
    SmartDialog.showToast('已存在该屏蔽关键词');
    onRemove?.call();
  }

  String? _getZoneName() {
    if (videoItem case HotVideoItemModel(:final tname)) {
      return tname;
    }
    if (videoItem case RcmdVideoItemAppModel(:final tname)) {
      return tname;
    }
    return null;
  }

  Widget _buildDialogChip(BuildContext context, _DialogChipAction action) {
    final colorScheme = Theme.of(context).colorScheme;
    const radius = BorderRadius.all(Radius.circular(6));
    return Material(
      color: colorScheme.onInverseSurface,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: action.onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
          child: Text(
            action.label,
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
      ),
    );
  }

  void _showReasonDialog({
    required BuildContext context,
    required String title,
    required List<_DialogSection> sections,
    required List<Widget> actions,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < sections.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
                  if (sections[i].title != null) ...[
                    Text(
                      sections[i].title!,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: sections[i].actions
                        .map((action) => _buildDialogChip(context, action))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          actions: actions,
        );
      },
    );
  }

  void _showLocalBlockDialog(BuildContext context) {
    final ownerName = videoItem.owner.name ?? '未知UP';
    final title = videoItem.title.trim();
    final zoneName = _getZoneName()?.trim();
    _showReasonDialog(
      context: context,
      title: '本地屏蔽',
      sections: [
        _DialogSection(
          title: '屏蔽原因',
          actions: [
            _DialogChipAction(
              label: 'UP主:$ownerName',
              onPressed: () {
                Get.back();
                _addBlockedUser();
              },
            ),
            if (title.isNotEmpty)
              _DialogChipAction(
                label: '标题:$title',
                onPressed: () {
                  Get.back();
                  _appendKeyword(
                    key: SettingBoxKey.banWordForRecommend,
                    value: title,
                    applyRegex: (value) {
                      RecommendFilter.rcmdRegExp = value;
                      RecommendFilter.enableFilter = value.pattern.isNotEmpty;
                    },
                    successMsg: '已加入标题关键词屏蔽',
                  );
                },
              ),
            _DialogChipAction(
              label: zoneName?.isNotEmpty == true ? '频道:$zoneName' : '频道:无法获取',
              onPressed: () {
                if (zoneName?.isNotEmpty != true) {
                  SmartDialog.showToast('当前视频无法获取频道信息');
                  return;
                }
                Get.back();
                _appendKeyword(
                  key: SettingBoxKey.banWordForZone,
                  value: zoneName!,
                  applyRegex: (value) {
                    VideoHttp.zoneRegExp = value;
                    VideoHttp.enableFilter = value.pattern.isNotEmpty;
                  },
                  successMsg: '已加入频道关键词屏蔽',
                );
              },
            ),
          ],
        ),
      ],
      actions: [
        TextButton(
          onPressed: Get.back,
          child: const Text('取消'),
        ),
      ],
    );
  }

  List<_VideoCustomAction> _buildActions(BuildContext context) {
    return [
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
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
          '本地屏蔽',
          const Icon(MdiIcons.accountOff, size: 16),
          () => _showLocalBlockDialog(context),
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
              VoidCallback onReasonTap({Reason? r, Reason? f}) => () async {
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
                  SmartDialog.showToast(r?.toast ?? f!.toast!);
                  onRemove?.call();
                } else {
                  res.toast();
                }
              };

              _showReasonDialog(
                context: context,
                title: '我不想看',
                sections: [
                  if (tp.dislikeReasons != null)
                    _DialogSection(
                      actions: tp.dislikeReasons!
                          .map(
                            (reason) => _DialogChipAction(
                              label: reason.name ?? '未知',
                              onPressed: onReasonTap(r: reason),
                            ),
                          )
                          .toList(),
                    ),
                  if (tp.feedbacks != null)
                    _DialogSection(
                      title: '反馈',
                      actions: tp.feedbacks!
                          .map(
                            (feedback) => _DialogChipAction(
                              label: feedback.name ?? '未知',
                              onPressed: onReasonTap(f: feedback),
                            ),
                          )
                          .toList(),
                    ),
                ],
                actions: [
                  TextButton(
                    onPressed: () async {
                      SmartDialog.showLoading(
                        msg: '正在提交',
                      );
                      final res = await VideoHttp.feedDislikeCancel(
                        id: item.param!,
                        goto: item.goto!,
                      );
                      SmartDialog.dismiss();
                      SmartDialog.showToast(
                        res.isSuccess ? "成功" : res.toString(),
                      );
                      Get.back();
                    },
                    child: const Text("撤销"),
                  ),
                ],
              );
            } else {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  contentPadding: const EdgeInsets.all(24),
                  children: [
                    const Center(child: Text("web端暂不支持精细选择")),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 5.0,
                      runSpacing: 2.0,
                      alignment: WrapAlignment.center,
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
                            visualDensity: VisualDensity.compact,
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
                            visualDensity: VisualDensity.compact,
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
          '加白：${videoItem.owner.name}',
          const Icon(Icons.person_add_alt_1_outlined, size: 16),
          _addWhitelistedUser,
        ),
        _VideoCustomAction(
          '拉黑：${videoItem.owner.name}',
          const Icon(MdiIcons.cancel, size: 16),
          () => showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('提示'),
                content: Text(
                  '确定拉黑:${videoItem.owner.name}(${videoItem.owner.mid})?'
                  '\n\n注：被拉黑的Up可以在隐私设置-黑名单管理中解除',
                ),
                actions: [
                  TextButton(
                    onPressed: Get.back,
                    child: Text(
                      '点错了',
                      style: TextStyle(
                        color: ColorScheme.of(context).outline,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Get.back();
                      final res = await VideoHttp.relationMod(
                        mid: videoItem.owner.mid!,
                        act: 5,
                        reSrc: 11,
                      );
                      if (res.isSuccess) {
                        onRemove?.call();
                      } else {
                        res.toast();
                      }
                    },
                    child: const Text('确认'),
                  ),
                ],
              );
            },
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
    ];
  }

  void _showPopupMenu(BuildContext context) {
    final actions = _buildActions(context);
    showStaticPositionMenu<int>(
      context: context,
      items: [
        for (int i = 0; i < actions.length; i++)
          CustomPopupMenuItem<int>(
            value: i,
            height: menuItemHeight,
            child: Row(
              children: [
                actions[i].icon,
                const SizedBox(width: 8),
                Text(actions[i].title, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
      ],
    ).then((index) {
      if (index != null && context.mounted) {
        actions[index].onTap();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => IconButton(
        padding: EdgeInsets.zero,
        onPressed: () => _showPopupMenu(context),
        icon: Icon(
          Icons.more_vert_outlined,
          color: Theme.of(context).colorScheme.outline,
          size: iconSize,
        ),
      ),
    );
  }
}
