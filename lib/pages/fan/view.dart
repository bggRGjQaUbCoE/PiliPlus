import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/models_new/follow/list.dart';
import 'package:PiliPlus/pages/fan/controller.dart';
import 'package:PiliPlus/pages/follow_type/view.dart';
import 'package:PiliPlus/pages/follow_type/widgets/item.dart';
import 'package:PiliPlus/pages/share/view.dart' show UserModel;
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FansPage extends StatefulWidget {
  const FansPage({
    super.key,
    this.showName = true,
    this.onSelect,
  });

  final bool showName;
  final ValueChanged<UserModel>? onSelect;

  @override
  State<FansPage> createState() => _FansPageState();
}

class _FansPageState extends FollowTypePageState<FansPage> {
  @override
  late final FansController controller = Get.put(
    FansController(widget.showName),
    tag: Get.parameters['mid'],
  );
  late final flag = widget.onSelect == null && controller.isOwner;

  @override
  PreferredSizeWidget? get appBar => widget.showName
      ? AppBar(
          title: controller.isOwner
              ? const Text('我的粉丝')
              : Obx(() {
                  final name = controller.name.value;
                  if (name != null) return Text('$name的粉丝');
                  return const SizedBox.shrink();
                }),
        )
      : null;

  @override
  Widget buildItem(int index, FollowItemModel item) {
    void onRemove() => showConfirmDialog(
      context: context,
      title: '确定移除 ${item.uname} ？',
      onConfirm: () => controller.onRemoveFan(index, item.mid),
    );

    return FollowTypeItem(
      item: item,
      onTap: () {
        if (widget.onSelect != null) {
          widget.onSelect!(
            UserModel(
              mid: item.mid,
              name: item.uname!,
              avatar: item.face!,
            ),
          );
          return;
        }
        Get.toNamed('/member?mid=${item.mid}');
      },
      onLongPress: flag ? onRemove : null,
      onSecondaryTap: flag && !Utils.isMobile ? onRemove : null,
    );
  }
}
