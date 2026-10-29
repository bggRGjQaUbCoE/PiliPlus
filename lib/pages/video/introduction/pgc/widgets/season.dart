import 'package:PiliPlus/pages/video/introduction/pgc/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/page.dart'
    show scrollOffset;
import 'package:material_ui/material_ui.dart';

const double _itemExtent = 150;

class SeasonPanel extends StatelessWidget {
  const SeasonPanel({
    super.key,
    required this.pgcController,
    required this.onSeasonChanged,
  });

  final VoidCallback onSeasonChanged;
  final PgcIntroController pgcController;

  @override
  Widget build(BuildContext context) {
    final seasons = pgcController.pgcItem.seasons!;
    final controller = pgcController.seasonController ??= ScrollController(
      keepScrollOffset: false,
      initialScrollOffset: scrollOffset(pgcController.seasonIndex, _itemExtent),
    );
    final colorScheme = ColorScheme.of(context);
    return SizedBox(
      height: 35,
      child: ListView.builder(
        padding: .zero,
        itemExtent: _itemExtent,
        controller: controller,
        itemCount: seasons.length,
        scrollDirection: .horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = seasons[index];
          final isCurr = index == pgcController.seasonIndex;
          return Container(
            width: _itemExtent,
            margin: index != seasons.length - 1 ? const .only(right: 10) : null,
            child: Material(
              color: colorScheme.onInverseSurface,
              borderRadius: const .all(.circular(6)),
              child: InkWell(
                borderRadius: const .all(.circular(6)),
                onTap: () {
                  if (isCurr || pgcController.changingSeason) return;
                  pgcController.changeSeason(item.seasonId!, index).then((res) {
                    if (context.mounted && res) {
                      onSeasonChanged();
                      controller.animateTo(
                        scrollOffset(index, _itemExtent),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  });
                },
                child: Padding(
                  padding: const .symmetric(horizontal: 8),
                  child: Align(
                    alignment: .centerLeft,
                    child: Text(
                      item.seasonTitle!,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: TextStyle(
                        height: 1,
                        fontSize: 13,
                        color: isCurr
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                      strutStyle: const .new(height: 1, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
