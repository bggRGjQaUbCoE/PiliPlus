import 'package:PiliPlus/common/widgets/button/icon_button.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/self_sized_horizontal_list.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/pages/contact/view.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/request_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LengthLimitingTextInputFormatter;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class UserModel {
  const UserModel({
    required this.mid,
    required this.name,
    required this.avatar,
  });

  final int mid;
  final String name;
  final String avatar;

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
    this.selectedIndex,
  });

  final Map content;
  final int? selectedIndex;
  final List<UserModel>? userList;

  @override
  State<SharePanel> createState() => _SharePanelState();
}

class _SharePanelState extends State<SharePanel> {
  int _selectedIndex = -1;
  final List<UserModel> _userList = <UserModel>[];
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

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
      if (widget.selectedIndex != null) {
        _selectedIndex = widget.selectedIndex!;
      }
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
          Row(
            children: [
              Expanded(
                child: SelfSizedHorizontalList(
                  gapSize: 10,
                  itemCount: _userList.length,
                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  childBuilder: (index) {
                    final item = _userList[index];
                    return GestureDetector(
                      onTap: () {
                        _selectedIndex = index;
                        setState(() {});
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
                            if (index == _selectedIndex)
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
              ),
              GestureDetector(
                onTap: () async {
                  _focusNode.unfocus();
                  UserModel? userModel = await Navigator.of(context).push(
                    GetPageRoute(page: () => const ContactPage()),
                  );
                  if (userModel != null) {
                    _userList
                      ..remove(userModel)
                      ..insert(0, userModel);
                    _selectedIndex = 0;
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
                            color: theme.colorScheme.secondaryContainer,
                          ),
                          child: Icon(
                            Icons.person_add_alt,
                            color: theme.colorScheme.onSecondaryContainer,
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
                  inputFormatters: [LengthLimitingTextInputFormatter(100)],
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.tonal(
                onPressed: () {
                  if (_selectedIndex == -1) {
                    SmartDialog.showToast('请选择分享的用户');
                    return;
                  }
                  RequestUtils.pmShare(
                    receiverId: _userList[_selectedIndex].mid,
                    content: widget.content,
                    message: _controller.text,
                  );
                },
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
        ],
      ),
    );
  }
}
