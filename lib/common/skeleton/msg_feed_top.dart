import 'package:PiliPlus/common/skeleton/skeleton.dart';
import 'package:material_ui/material_ui.dart';

class MsgFeedTopSkeleton extends StatelessWidget {
  const MsgFeedTopSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = ColorScheme.of(context).onInverseSurface;
    return Skeleton(
      child: ListTile(
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        title: UnconstrainedBox(
          alignment: .centerLeft,
          child: Container(width: 100, height: 11, color: color),
        ),
        subtitle: Container(width: 125, height: 11, color: color),
      ),
    );
  }
}
