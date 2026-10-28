import 'dart:math';

import 'package:PiliPlus/models_new/pgc/pgc_info_model/season.dart';
import 'package:PiliPlus/pages/video/introduction/pgc/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/page.dart'
    show scrollOffset;
import 'package:material_ui/material_ui.dart';

const double _itemExtent = 150;

class SeasonPanel extends StatelessWidget {
  const SeasonPanel({
    super.key,
    required this.seasons,
    required this.pgcController,
    required this.onSeasonChanged,
  });

  final List<Season> seasons;
  final PgcIntroController pgcController;
  final VoidCallback onSeasonChanged;

  @override
  Widget build(BuildContext context) {
    final currIndex = max(
      0,
      seasons.indexWhere((e) => e.seasonId == pgcController.seasonId),
    );
    final controller = pgcController.seasonController ??= ScrollController(
      initialScrollOffset: scrollOffset(currIndex, _itemExtent),
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
        key: const PageStorageKey(SeasonPanel),
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = seasons[index];
          final isCurr = index == currIndex;
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
                  pgcController.changeSeason(item.seasonId!).then((res) {
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
