import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models/search/search_esports.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:material_ui/material_ui.dart';

class SearchEsportsItem extends StatelessWidget {
  const SearchEsportsItem({
    super.key,
    required this.item,
  });

  final SearchEsports item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final configInfo = item.configInfo;
    final contest = item.contest.first;

    Widget buildTeamWidget(EsportsTeam team) {
      return Column(
        spacing: 6,
        mainAxisSize: .min,
        children: [
          NetworkImgLayer(
            src: team.logoFull,
            width: 50,
            height: 50,
            type: .emote,
            fit: .contain,
          ),
          Text(
            team.title,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      );
    }

    Widget btn;
    if (contest.contestStatus == 2) {
      btn = FilledButton.tonal(
        style: const ButtonStyle(
          visualDensity: .compact,
          tapTargetSize: .shrinkWrap,
          padding: WidgetStatePropertyAll(.symmetric(horizontal: 16)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: .all(.circular(6))),
          ),
        ),
        onPressed: () => PageUtils.toLiveRoom(contest.liveRoom),
        child: const Text('观看直播'),
      );
    } else {
      final style = ButtonStyle(
        visualDensity: .compact,
        tapTargetSize: .shrinkWrap,
        padding: const WidgetStatePropertyAll(.symmetric(horizontal: 16)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: const .all(.circular(6)),
            side: BorderSide(color: colorScheme.outline),
          ),
        ),
        foregroundColor: WidgetStatePropertyAll(colorScheme.onSurfaceVariant),
      );

      btn = OutlinedButton(
        style: style,
        onPressed: () => PageUtils.toLiveRoom(contest.liveRoom),
        child: const Text('直播间'),
      );

      if (contest.playback?.isNotEmpty ?? false) {
        btn = Row(
          spacing: 12,
          mainAxisSize: .min,
          mainAxisAlignment: .center,
          children: [
            OutlinedButton(
              style: style,
              onPressed: () => PiliScheme.routePushFromUrl(contest.playback!),
              child: const Text('回放'),
            ),
            btn,
          ],
        );
      }
    }

    return Padding(
      padding: const .symmetric(vertical: 5),
      child: Center(
        child: GestureDetector(
          behavior: .opaque,
          onTap: () => Get.toNamed(
            '/matchInfo',
            parameters: {'cid': contest.id.toString()},
          ),
          child: Column(
            mainAxisSize: .min,
            children: [
              Text(
                configInfo.esportTitle,
                style: const TextStyle(fontWeight: .bold, fontSize: 16),
              ),
              if (contest.gameStage?.isNotEmpty ?? false)
                Padding(
                  padding: const .only(top: 4),
                  child: Text(
                    contest.gameStage!,
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.outline,
                    ),
                  ),
                ),
              Row(
                spacing: 20,
                mainAxisSize: .min,
                mainAxisAlignment: .center,
                children: [
                  buildTeamWidget(contest.homeTeam),
                  Text(
                    '${contest.homeScore} : ${contest.awayScore}',
                    style: const TextStyle(fontSize: 25, fontWeight: .bold),
                  ),
                  buildTeamWidget(contest.awayTeam),
                ],
              ),
              const SizedBox(height: 10),
              btn,
            ],
          ),
        ),
      ),
    );
  }
}
