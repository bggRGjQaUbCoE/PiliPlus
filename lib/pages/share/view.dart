import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/self_sized_horizontal_list.dart';
import 'package:PiliPlus/common/widgets/view_insets_safe_area.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/pages/contact/view.dart';
import 'package:PiliPlus/pages/dlna/dlna_service.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:flutter/services.dart' show LengthLimitingTextInputFormatter;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';
import 'package:dlna_dart/dlna.dart';

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
  bool selected;

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
    this.userList,
  });

  final Map content;
  final List<UserModel>? userList;

  @override
  State<SharePanel> createState() => _SharePanelState();
}

class _SharePanelState extends State<SharePanel> {
  final List<UserModel> _userList = <UserModel>[];
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final List<DLNADevice> _dlnaDevices = [];

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
    _dlnaDevices.addAll(dlnaDeviceCache.values);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(12) + MediaQuery.paddingOf(context),
      child: ViewInsetsSafeArea(
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
            Row(
              children: [
                Expanded(
                  child: SelfSizedHorizontalList(
                    padding: .zero,
                    itemCount: _userList.length,
                    controller: _scrollController,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final item = _userList[index];
                      return Builder(
                        builder: (context) {
                          return GestureDetector(
                            onTap: () {
                              item.selected = !item.selected;
                              (context as Element).markNeedsBuild();
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
                                        color: theme.colorScheme.primary
                                            .withValues(
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
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    _focusNode.unfocus();
                    final UserModel? userModel = await Navigator.of(context)
                        .push(
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
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 65,
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.onInverseSurface,
                            ),
                            child: Icon(
                              Icons.person_add_alt,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text('更多', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
                      visualDensity: .standard,
                      hintStyle: const TextStyle(fontSize: 14),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      filled: true,
                      isDense: true,
                      contentPadding: const .symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      fillColor: theme.colorScheme.onInverseSurface,
                    ),
                    inputFormatters: [LengthLimitingTextInputFormatter(100)],
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.tonal(
                  onPressed: _onSend,
                  style: FilledButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: const VisualDensity(
                      horizontal: -2,
                      vertical: -1,
                    ),
                  ),
                  child: const Text('发送'),
                ),
              ],
            ),
            if (_dlnaDevices.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                '投屏到设备',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 74,
                child: SelfSizedHorizontalList(
                  padding: .zero,
                  itemCount: _dlnaDevices.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return _buildDlnaDevice(context, _dlnaDevices[index]);
                  },
                ),
              ),
            ],
          ],
        ),
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

  Widget _buildDlnaDevice(BuildContext context, DLNADevice device) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _castToDlna(device),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.onInverseSurface,
              ),
              child: const Icon(Icons.cast, size: 26),
            ),
            const SizedBox(height: 4),
            Text(
              device.info.friendlyName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _castToDlna(DLNADevice device) async {
    final url = await resolveCastUrl(widget.content);
    if (url == null || url.isEmpty) {
      SmartDialog.showToast('该分享暂不支持投屏到设备');
      return;
    }
    SmartDialog.showLoading();
    try {
      await castDlnaDevice(
        device,
        url: url,
        title: widget.content['title']?.toString(),
      );
      SmartDialog.dismiss();
      SmartDialog.showToast('已投屏到 ${device.info.friendlyName}');
    } catch (_) {
      SmartDialog.dismiss();
      SmartDialog.showToast('投屏失败，请重试');
    }
  }
}
