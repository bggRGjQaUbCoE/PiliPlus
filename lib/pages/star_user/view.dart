import 'package:PiliPlus/common/skeleton/msg_feed_top.dart';
import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/refresh_indicator.dart';
import 'package:PiliPlus/models/common/image_type.dart';
import 'package:PiliPlus/models_new/fans/list.dart';
import 'package:PiliPlus/pages/share/view.dart' show UserModel;
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/models/member/info.dart';

class StarUserPage extends StatefulWidget {
  const StarUserPage({
    super.key,
    this.mid,
    this.onSelect,
  });

  final int? mid;
  final ValueChanged<UserModel>? onSelect;

  @override
  State<StarUserPage> createState() => _StarUserPageState();
}

class _StarUserPageState extends State<StarUserPage> {
  List<FansItemModel> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStarUsersFromPref();
  }

  Future<void> _loadStarUsersFromPref() async {
    setState(() {
      _isLoading = true;
      _items = [];
    });

    final Set<int> starredMids = Pref.starUsers;
    List<FansItemModel> resolvedItems = [];

    // 通过哔哩哔哩API获取用户真实信息（包括个性签名）
    for (int eachMid in starredMids) {
      try {
        final result = await MemberHttp.memberInfo(mid: eachMid);
        if (result['status'] == true) {
          final MemberInfoModel userInfo = result['data'];
          resolvedItems.add(FansItemModel(
            mid: userInfo.mid ?? eachMid,
            uname: userInfo.name ?? 'User $eachMid',
            face: userInfo.face ?? 'https://static.hdslb.com/images/member/noface.gif',
            sign: userInfo.sign ?? '这个人很懒，什么都没有写~',
          ));
        } else {
          resolvedItems.add(FansItemModel(
            mid: eachMid,
            uname: 'User $eachMid',
            face: 'https://static.hdslb.com/images/member/noface.gif',
            sign: '用户信息获取失败: ${result['msg'] ?? '未知错误'}',
          ));
        }
      } catch (e) {
        print("获取用户信息失败 mid: $eachMid, 错误: $e");
        resolvedItems.add(FansItemModel(
          mid: eachMid,
          uname: 'User $eachMid',
          face: 'https://static.hdslb.com/images/member/noface.gif',
          sign: '网络错误，无法获取用户信息',
        ));
      }
    }

    if (mounted) {
      setState(() {
        _items = resolvedItems;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeUserFromStars(int indexInList, int userMid) async {
    final Set<int> currentStars = Pref.starUsers;
    bool removed = currentStars.remove(userMid);
    if (removed) {
      Pref.starUsers = currentStars;
      if (mounted) {
        setState(() {
          _items.removeAt(indexInList);
        });
      }
      SmartDialog.showToast("已移除");
    } else {
      SmartDialog.showToast("移除失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.mid != null
          ? null
          : AppBar(title: const Text("收藏的用户")),
      body: SafeArea(
        bottom: false,
        child: refreshIndicator(
          onRefresh: _loadStarUsersFromPref,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 80,
                ),
                sliver: _buildSliverContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverContent() {
    if (_isLoading) {
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: Grid.smallCardWidth * 2,
          mainAxisExtent: 66,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return const MsgFeedTopSkeleton();
          },
          childCount: 10,
        ),
      );
    }

    if (_items.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_border,
                  size: 64,
                  color: Theme.of(context).disabledColor,
                ),
                const SizedBox(height: 16),
                Text(
                  '还没有收藏的用户',
                  style: TextStyle(fontSize: 16, color: Theme.of(context).disabledColor),
                ),
                const SizedBox(height: 8),
                Text(
                  '在用户个人页面点击收藏按钮即可添加',
                  style: TextStyle(fontSize: 14, color: Theme.of(context).disabledColor.withOpacity(0.7)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: Grid.smallCardWidth * 2,
        mainAxisExtent: 66,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final item = _items[index];
          return ListTile(
            onTap: () {
              if (widget.onSelect != null) {
                widget.onSelect!(
                  UserModel(
                    mid: item.mid!,
                    name: item.uname!,
                    avatar: item.face!,
                  ),
                );
                return;
              }
              Get.toNamed('/member?mid=${item.mid}');
            },
            onLongPress: widget.onSelect != null
                ? null
                : () => showConfirmDialog(
                      context: context,
                      title: '确定移除 ${item.uname} ？',
                      onConfirm: () => _removeUserFromStars(index, item.mid!),
                    ),
            leading: NetworkImgLayer(
              width: 45,
              height: 45,
              type: ImageType.avatar,
              src: item.face,
            ),
            title: Text(
              item.uname!,
              style: const TextStyle(fontSize: 14),
            ),
            subtitle: Text(
              item.sign ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            dense: true,
            trailing: const SizedBox(width: 6),
          );
        },
        childCount: _items.length,
      ),
    );
  }
}
