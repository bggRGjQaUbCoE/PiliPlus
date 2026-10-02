import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_mention/item.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:material_ui/material_ui.dart';

class DynMentionItem extends StatelessWidget {
  const DynMentionItem({
    super.key,
    required this.item,
    required this.onTap,
    this.onCheck,
  });

  final MentionItem item;
  final VoidCallback onTap;
  final ValueChanged<bool?>? onCheck;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        dense: true,
        onTap: onTap,
        visualDensity: .standard,
        leading: NetworkImgLayer(
          src: item.face,
          width: 42,
          height: 42,
          type: .avatar,
        ),
        title: Text(
          item.name!,
          style: const TextStyle(fontSize: 14),
        ),
        subtitle: item.fans == null
            ? null
            : Text(
                '${NumUtils.numFormat(item.fans)}粉丝',
                style: TextStyle(color: ColorScheme.of(context).outline),
              ),
        trailing: onCheck == null
            ? null
            : Checkbox(
                tristate: false,
                value: item.checked,
                onChanged: (value) {
                  item.checked = value!;
                  (context as Element).markNeedsBuild();
                  onCheck!(value);
                },
              ),
      ),
    );
  }
}
