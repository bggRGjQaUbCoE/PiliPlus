import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models_new/history/list.dart';
import 'package:PiliPlus/pages/history/widgets/item.dart' show onPushHistory;
import 'package:material_ui/material_ui.dart';

class MineHistoryItem extends StatelessWidget {
  const MineHistoryItem({
    super.key,
    required this.item,
    required this.onPop,
  });

  final HistoryItemModel item;
  final VoidCallback onPop;

  @override
  Widget build(BuildContext context) {
    final hasDuration = item.hasDuration;
    return GestureDetector(
      onTap: () => onPushHistory(item).whenComplete(onPop),
      behavior: .opaque,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Stack(
            clipBehavior: .none,
            children: [
              NetworkImgLayer(
                src: item.cover,
                width: 180,
                height: 110,
              ),
              if (hasDuration)
                ...item.progressIndicator(ColorScheme.of(context)),
              ?item.label,
            ],
          ),
          const SizedBox(height: 8),
          Text(
            ' ${item.title}',
            maxLines: 2,
            overflow: .ellipsis,
            style: const TextStyle(height: 1.42, letterSpacing: 0.3),
          ),
        ],
      ),
    );
  }
}
