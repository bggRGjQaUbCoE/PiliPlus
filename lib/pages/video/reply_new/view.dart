import 'dart:async';
import 'dart:io';
import 'dart:math' show max;

import 'package:PiliPlus/common/widgets/button/toolbar_icon_button.dart';
import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/flutter/text_field/controller.dart'
    show RichTextType;
import 'package:PiliPlus/common/widgets/flutter/text_field/text_field.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/scroll_physics.dart'
    show platformClampingPhysics;
import 'package:PiliPlus/common/widgets/view_safe_area.dart';
import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show ReplyInfo;
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models/common/publish_panel_type.dart';
import 'package:PiliPlus/models/dynamics/result.dart' show FilePicModel;
import 'package:PiliPlus/pages/common/publish/common_rich_text_pub_page.dart';
import 'package:PiliPlus/pages/dynamics_mention/controller.dart';
import 'package:PiliPlus/pages/emote/controller.dart';
import 'package:PiliPlus/pages/emote/view.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/reply_search_item/view.dart';
import 'package:PiliPlus/utils/duration_utils.dart';
import 'package:PiliPlus/utils/extension/context_ext.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:material_ui/material_ui.dart' hide TextField;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class ReplyPage extends CommonRichTextPubPage {
  final int oid;
  final int root;
  final int parent;
  final int replyType;
  final ReplyInfo? replyItem;
  final String? hint;
  final bool canUploadPic;

  const ReplyPage({
    super.key,
    super.items,
    super.imageLengthLimit,
    super.onSave,
    required this.oid,
    required this.root,
    required this.parent,
    required this.replyType,
    this.replyItem,
    this.hint,
    this.canUploadPic = true,
  });

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends CommonRichTextPubPageState<ReplyPage> {
  final RxBool _syncToDynamic = false.obs;
  late final Rx<Account> _selectedAccount = Accounts.main.obs;
  final heroTag = Get.arguments?['heroTag'];

  @override
  void initState() {
    super.initState();
    if (Pref.enableReplyAccountSwitch &&
        Pref.rememberReplyAccount &&
        Pref.lastReplyAccountMid != null) {
      final savedAccount = Accounts.account.values.firstWhereOrNull(
        (a) => a.mid == Pref.lastReplyAccountMid,
      );
      if (savedAccount != null) {
        _selectedAccount.value = savedAccount;
      }
    }
    _loadAccountProfiles();
  }

  void _loadAccountProfiles() {
    for (final act in Accounts.account.values) {
      if (Accounts.getCachedProfile(act.mid) == null) {
        Accounts.fetchProfile(act.mid).then((_) {
          if (mounted) setState(() {});
        });
      }
    }
  }

  @override
  void dispose() {
    Get
      ..delete<EmotePanelController>()
      ..delete<DynMentionController>();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeData = darkVideoPage ? ThemeUtils.darkTheme : Theme.of(context);
  }

  late final darkVideoPage =
      Get.currentRoute == '/videoV' && Pref.darkVideoPage;
  late ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    Widget child = ViewSafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 640),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            color: themeData.colorScheme.surface,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...buildInputView(),
              buildImagePreview(),
              Flexible(
                child: buildPanelContainer(themeData, Colors.transparent),
              ),
            ],
          ),
        ),
      ),
    );
    return darkVideoPage ? Theme(data: themeData, child: child) : child;
  }

  @override
  Widget? get customPanel => EmotePanel(onChoose: onChooseEmote);

  Widget buildImagePreview() {
    return Obx(
      () {
        if (imageList.isNotEmpty) {
          return SizedBox(
            height: 85,
            child: ListView.separated(
              scrollDirection: .horizontal,
              padding: const .fromLTRB(15, 0, 15, 10),
              itemCount: imageList.length,
              itemBuilder: (_, index) => buildImage(index, 75),
              separatorBuilder: (_, _) => const SizedBox(width: 10),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  String _buildInputHintText() {
    if (Pref.enableReplyAccountSwitch &&
        _selectedAccount.value.mid != Accounts.main.mid) {
      final profile = Accounts.getCachedProfile(_selectedAccount.value.mid);
      final name = profile?.name;
      if (name != null && name.isNotEmpty) {
        return "以 $name 回复...";
      }
      return "以 UID: ${_selectedAccount.value.mid} 回复...";
    }
    return "输入回复内容";
  }

  List<Widget> buildInputView() {
    return [
      Padding(
        padding: const EdgeInsets.only(
          top: 12,
          right: 15,
          left: 15,
          bottom: 10,
        ),
        child: Listener(
          onPointerUp: (event) {
            if (readOnly.value) {
              updatePanelType(PanelType.keyboard);
            }
          },
          child: Obx(
            () => RichTextField(
              key: key,
              controller: editController,
              minLines: 4,
              maxLines: 8,
              autofocus: false,
              readOnly: readOnly.value,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: widget.hint ?? _buildInputHintText(),
                border: InputBorder.none,
                hintStyle: const TextStyle(fontSize: 14),
              ),
              style: themeData.textTheme.bodyLarge,
            ),
          ),
        ),
      ),
      Divider(
        height: 1,
        color: themeData.dividerColor.withValues(alpha: 0.1),
      ),
      Container(
        height: 52,
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Row(
          children: [
            emojiBtn,
            if (widget.root == 0) ...[
              const SizedBox(width: 8),
              ToolbarIconButton(
                tooltip: '图片',
                selected: false,
                icon: widget.canUploadPic
                    ? const Icon(Icons.image, size: 22)
                    : const Icon(Icons.image_not_supported, size: 22),
                onPressed: widget.canUploadPic
                    ? onPickImage
                    : () => SmartDialog.showToast('当前评论区不支持发送图片'),
              ),
            ],
            const SizedBox(width: 8),
            atBtn,
            const SizedBox(width: 8),
            moreBtn,
            const SizedBox(width: 8),
            Obx(
              () => ToolbarIconButton(
                tooltip: '转到动态',
                onPressed: _syncToDynamic.toggle,
                icon: const Icon(
                  CustomIcons.repeat_rounded_rotate_90,
                  size: 22,
                ),
                selected: _syncToDynamic.value,
              ),
            ),
            if (Pref.enableReplyAccountSwitch &&
                Accounts.account.length > 1) ...[
              const SizedBox(width: 8),
              Obx(_buildAccountSwitchBtn),
            ],
            const Spacer(),
            Obx(
              () => FilledButton.tonal(
                onPressed: enablePublish.value ? onPublishThrottle : null,
                style: FilledButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text('发送'),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget buildMorePanel(ThemeData theme) {
    double height = context.isTablet ? 300 : 170;
    final keyboardHeight = controller.keyboardHeight;
    if (keyboardHeight != 0) {
      height = max(height, keyboardHeight);
    }

    Widget item({
      required VoidCallback onTap,
      required Icon icon,
      required String title,
    }) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          spacing: 5,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: themeData.colorScheme.onInverseSurface,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                alignment: Alignment.center,
                child: icon,
              ),
            ),
            Text(
              title,
              maxLines: 1,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    final isRoot = widget.root == 0;
    final color = themeData.colorScheme.onSurfaceVariant;
    late final gridDelegate = SliverGridDelegateWithExtentAndRatio(
      maxCrossAxisExtent: 65,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      mainAxisExtent: 25,
    );

    return SizedBox(
      height: height,
      child: GridView(
        physics: platformClampingPhysics,
        padding: const EdgeInsets.only(left: 12, bottom: 12, right: 12),
        gridDelegate: gridDelegate,
        children: [
          item(
            onTap: () async {
              final ({String title, String url})? res = await Get.to(
                ReplySearchPage(type: widget.replyType, oid: widget.oid),
              );
              if (res != null) {
                onInsertText(
                  '${res.title} ',
                  RichTextType.common,
                  rawText: '${res.url} ',
                );
              }
            },
            icon: Icon(Icons.post_add, size: 28, color: color),
            title: '插入内容',
          ),
          if (heroTag != null) ...[
            // if (isRoot)
            //   item(
            //     onTap: () {
            //       Get.back();
            //       try {
            //         Get.find<VideoDetailController>(tag: heroTag)
            //             .showNoteList(context);
            //       } catch (e) {
            //         debugPrint(e.toString());
            //       }
            //     },
            //     icon: Icon(Icons.edit_note, size: 28, color: color),
            //     title: '笔记',
            //   ),
            item(
              onTap: () {
                try {
                  final plPlayerController = Get.find<VideoDetailController>(
                    tag: heroTag,
                  );
                  onInsertText(
                    ' ${DurationUtils.formatDuration((plPlayerController.playedTime ?? Duration.zero).inSeconds)} ',
                    RichTextType.common,
                  );
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
              icon: Icon(Icons.my_location, size: 28, color: color),
              title: '视频进度',
            ),
            if (isRoot && widget.canUploadPic)
              item(
                onTap: () async {
                  if (imageList.length >= limit) {
                    SmartDialog.showToast('最多选择$limit张图片');
                    return;
                  }
                  try {
                    final plPlayerController = Get.find<VideoDetailController>(
                      tag: heroTag,
                    );
                    final res = await plPlayerController
                        .plPlayerController
                        .videoPlayerController
                        ?.screenshot();
                    if (res != null) {
                      final png = await res.toByteData(format: .png);
                      if (png != null) {
                        final path =
                            '$tmpDirPath/${Utils.generateRandomString(8)}.png';
                        await File(path).writeAsBytes(png.buffer.asUint8List());
                        imageList.add(FilePicModel(path: path));
                      }
                      res.dispose();
                    } else {
                      debugPrint('null screenshot');
                    }
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                icon: Icon(
                  Icons.enhance_photo_translate_outlined,
                  size: 28,
                  color: color,
                ),
                title: '视频截图',
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildAccountSwitchBtn() {
    final account = _selectedAccount.value;
    final isCustom = account.mid != Accounts.main.mid;
    final isMain = account == Accounts.main;
    final profile = Accounts.getCachedProfile(account.mid);
    final face = profile?.face ?? (isMain ? Pref.userInfoCache?.face : null);
    final name = profile?.name ?? (isMain ? Pref.userInfoCache?.uname : null);

    final String tooltip;
    if (isCustom) {
      tooltip = name != null
          ? '当前发送账号: $name (UID: ${account.mid}) · 点击切换'
          : '当前发送账号: UID ${account.mid} · 点击切换';
    } else {
      tooltip = name != null
          ? '当前发送账号: $name (主号) · 点击切换'
          : '当前发送账号: 主号 · 点击切换';
    }

    final theme = Theme.of(context);
    Widget iconWidget;
    if (face != null && face.isNotEmpty) {
      iconWidget = Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isCustom
              ? Border.all(
                  color: theme.colorScheme.primary,
                  width: 2,
                )
              : Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
        ),
        child: ClipOval(
          child: NetworkImgLayer(
            src: face,
            width: 24,
            height: 24,
            type: ImageType.avatar,
          ),
        ),
      );
    } else {
      iconWidget = Icon(
        isCustom ? Icons.account_circle : Icons.account_circle_outlined,
        size: 22,
        color: isCustom ? theme.colorScheme.primary : null,
      );
    }

    return ToolbarIconButton(
      tooltip: tooltip,
      onPressed: _onSwitchAccount,
      icon: iconWidget,
      selected: isCustom,
    );
  }

  void _onSwitchAccount() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (context) {
        final theme = Theme.of(context);
        final accounts = Accounts.account.values.toList();
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '选择发表评论的账号',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      Pref.rememberReplyAccount ? '已开启记住账号' : '仅对本次回复生效',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    final account = accounts[index];
                    final isSelected =
                        account.mid == _selectedAccount.value.mid;
                    final isMain = account == Accounts.main;
                    final profile = Accounts.getCachedProfile(account.mid);
                    final face =
                        profile?.face ??
                        (isMain ? Pref.userInfoCache?.face : null);
                    final name =
                        profile?.name ??
                        (isMain ? Pref.userInfoCache?.uname : null);

                    return ListTile(
                      leading: face != null && face.isNotEmpty
                          ? ClipOval(
                              child: NetworkImgLayer(
                                src: face,
                                width: 40,
                                height: 40,
                                type: ImageType.avatar,
                              ),
                            )
                          : CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  theme.colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.person_outline,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                      title: Row(
                        children: [
                          Flexible(
                            child: Text(
                              name ?? 'UID: ${account.mid}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : null,
                              ),
                            ),
                          ),
                          if (isMain) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '当前主号',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      subtitle: name != null
                          ? Text(
                              'UID: ${account.mid}',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.outline,
                              ),
                            )
                          : null,
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: theme.colorScheme.primary,
                            )
                          : null,
                      onTap: () {
                        _selectedAccount.value = account;
                        if (Pref.enableReplyAccountSwitch &&
                            Pref.rememberReplyAccount) {
                          Pref.lastReplyAccountMid = account.mid;
                        }
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Future<void> onCustomPublish({List? pictures}) async {
    Map<String, int> atNameToMid = {};
    for (final e in editController.items) {
      if (e.type == RichTextType.at) {
        atNameToMid[e.rawText] ??= int.parse(e.id!);
      }
    }
    String message = editController.rawText;
    final res = await VideoHttp.replyAdd(
      type: widget.replyType,
      oid: widget.oid,
      root: widget.root,
      parent: widget.parent,
      message: widget.replyItem != null && widget.replyItem!.root != 0
          ? ' 回复 @${widget.replyItem!.member.name} : $message'
          : message,
      atNameToMid: atNameToMid,
      pictures: pictures,
      syncToDynamic: _syncToDynamic.value,
      account: Pref.enableReplyAccountSwitch
          ? _selectedAccount.value
          : Accounts.main,
    );
    if (res case Success(:final response)) {
      hasPub = true;
      SmartDialog.showToast('发送成功');
      Get.back(result: response);
    } else {
      res.toast();
    }
  }
}
