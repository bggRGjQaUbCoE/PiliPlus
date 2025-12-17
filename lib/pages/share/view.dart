import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/self_sized_horizontal_list.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/pages/contact/view.dart';
import 'package:PiliPlus/pages/share/widgets/action_button.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LengthLimitingTextInputFormatter;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class UserModel {
  UserModel({
    required this.mid,
    required this.name,
    required this.avatar,
    this.selected = false,
  });

  final int mid;
  final String name;
  final String avatar;
  bool selected = false;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is UserModel) {
      return mid == other.mid;
    }
    return false;
  }

  @override
  int get hashCode => mid.hashCode;
}

class SharePanel extends StatefulWidget {
  const SharePanel({
    super.key,
    required this.content,
    required this.link,
    this.userList,
    this.shareText,
    this.repostPanel,
  });

  final String link;
  final String? shareText;
  final Map content;
  final List<UserModel>? userList;
  final Widget? repostPanel;

  @override
  State<SharePanel> createState() => _SharePanelState();
}

class _SharePanelState extends State<SharePanel> {
  final List<UserModel> _userList = <UserModel>[];
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  bool sending = false;
  int selectedCount = 0;

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.userList?.isNotEmpty == true) {
      _userList.addAll(widget.userList!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding:
          const EdgeInsets.all(12) +
          MediaQuery.paddingOf(context) +
          MediaQuery.viewInsetsOf(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('分享给'),
              iconButton(
                size: 32,
                iconSize: 18,
                tooltip: '关闭',
                icon: const Icon(Icons.clear),
                onPressed: Get.back,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Stack(
            alignment: AlignmentGeometry.topRight,
            children: [
              SelfSizedHorizontalList(
                gapSize: 10,
                itemCount: _userList.length,
                controller: _scrollController,
                padding: const EdgeInsets.only(
                  right: 65,
                ), //prevent conflict with more button
                childBuilder: (index) {
                  final item = _userList[index];
                  return GestureDetector(
                    onTap: () {
                      item.selected = !item.selected;
                      setState(() {
                        selectedCount += item.selected ? 1 : -1;
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: 65,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: NetworkImgLayer(
                                  width: 40,
                                  height: 40,
                                  src: item.avatar,
                                  type: ImageType.avatar,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          if (item.selected)
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.3,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 1.5,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              DecoratedBox(
                decoration: BoxDecoration(gradient: LinearGradient(
                  colors: [theme.colorScheme.surfaceContainer.withAlpha(0), theme.colorScheme.surfaceContainer],
                  stops: const [0.0,0.4]
                )),
                child: ActionButton(
                  icon: Icons.person_add_alt,
                  onPressed: () async {
                    _focusNode.unfocus();
                    final UserModel? userModel = await Navigator.of(context).push(
                      GetPageRoute(page: () => const ContactPage()),
                    );
                    if (userModel != null) {
                      _userList
                        ..remove(userModel)
                        ..insert(0, userModel);
                      _scrollController.jumpToTop();
                      setState(() {});
                    }
                  },
                  text: "更多",
                ),
                )

            ],
          ),
          const Divider(),
          if (selectedCount > 0)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    minLines: 1,
                    maxLines: 2,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: '说说你的想法吧...',
                      hintStyle: const TextStyle(fontSize: 14),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      filled: true,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      fillColor: theme.colorScheme.onInverseSurface,
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(100),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.tonal(
                  onPressed: () {
                    if (sending) return; // prevent multiple clicks
                    if (selectedCount <= 0) {
                      SmartDialog.showToast('请选择分享的用户');
                      return;
                    }
                    setState(() {
                      sending = true;
                    });
                    Future.forEach(
                      _userList.where((user) => user.selected),
                      (user) async {
                        await RequestUtils.pmShare(
                          receiverId: user.mid,
                          content: widget.content,
                          message: _controller.text,
                        );
                      },
                    ).whenComplete(() {
                      setState(() {
                        sending = false;
                        selectedCount = 0;
                      });
                    });
                  },
                  style: FilledButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: const VisualDensity(
                      horizontal: -2,
                      vertical: -1,
                    ),
                  ),
                  child: sending
                      ? const CircularProgressIndicator()
                      : const Text('发送'),
                ),
              ],
            )
          else
            Row(
              children: [
                if (widget.repostPanel != null)
                ActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return widget.repostPanel!;
                      },
                      useSafeArea: true,
                      isScrollControlled: true,
                    );
                  },
                  text: "动态",
                  icon: Icons.motion_photos_on,
                ),
                if (PlatformUtils.isMobile)
                  ActionButton(
                    onPressed: () {
                      Get.back();
                      Utils.shareText(widget.shareText ?? widget.link);
                    },
                    text: "分享链接",
                    icon: Icons.share,
                  ),
                ActionButton(
                  onPressed: () {
                    Get.back();
                    Utils.copyText(widget.link);
                  },
                  text: "复制链接",
                  icon: Icons.link,
                ),
                ActionButton(
                  onPressed: () {
                    Get.back();
                    PageUtils.launchURL(widget.link);
                  },
                  text: "打开链接",
                  icon: Icons.arrow_outward,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _onSend() async {
    final list = _userList.where((user) => user.selected);
    if (list.isEmpty) {
      SmartDialog.showToast('请选择分享的用户');
      return;
    }
    SmartDialog.showLoading();
    final res = await Future.wait(
      list.map(
        (user) => RequestUtils.pmShare(
          receiverId: user.mid,
          content: widget.content,
          message: _controller.text,
        ),
      ),
    );
    SmartDialog.dismiss();
    if (res.every((e) => e)) {
      Get.back();
      SmartDialog.showToast('分享成功');
    } else if (res.every((e) => !e)) {
      SmartDialog.showToast('分享失败');
    } else {
      SmartDialog.showToast('部分分享失败');
    }
  }
}
