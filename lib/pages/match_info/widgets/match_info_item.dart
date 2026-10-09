import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/models_new/match/match_info/contest.dart';
import 'package:PiliPlus/models_new/match/match_info/team.dart';
import 'package:PiliPlus/pages/match_info/widgets/team_info_layout.dart';
import 'package:PiliPlus/utils/app_scheme.dart';
import 'package:PiliPlus/utils/date_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class MatchInfoItem extends StatelessWidget {
  const MatchInfoItem({super.key, required this.contest});

  final MatchContest contest;

  static Widget teamInfo(MatchTeam team) {
    return Column(
      spacing: 6,
      mainAxisSize: .min,
      children: [
        NetworkImgLayer(
          width: 50,
          height: 50,
          src: team.logoFull ?? 'https://i1.hdslb.com${team.logo}',
          type: .emote,
          fit: .contain,
        ),
        if (team.title != null)
          Text(
            team.title!,
            style: const TextStyle(fontSize: 13),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return buildContestItem(colorScheme, contest);
  }
}

Widget buildTeamInfo(MatchTeam team) {
  return Column(
    spacing: 6,
    mainAxisSize: .min,
    children: [
      NetworkImgLayer(
        src: team.logoFull ?? 'https://i1.hdslb.com${team.logo}',
        width: 50,
        height: 50,
        type: .emote,
        fit: .contain,
      ),
      if (team.title != null)
        Text(
          team.title!,
          style: const TextStyle(fontSize: 13),
        ),
    ],
  );
}

Widget? buildMatchBtn(ColorScheme colorScheme, MatchContest contest) {
  Widget? btn;
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
    late final outlinedStyle = ButtonStyle(
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

    if (contest.liveRoom != null) {
      btn = OutlinedButton(
        style: outlinedStyle,
        onPressed: () => PageUtils.toLiveRoom(contest.liveRoom),
        child: const Text('直播间'),
      );
    }

    if (contest.playback?.isNotEmpty ?? false) {
      final playbackBtn = OutlinedButton(
        style: outlinedStyle,
        onPressed: () => PiliScheme.routePushFromUrl(contest.playback!),
        child: const Text('回放'),
      );
      if (btn != null) {
        btn = Row(
          spacing: 12,
          mainAxisSize: .min,
          mainAxisAlignment: .center,
          children: [playbackBtn, btn],
        );
      } else {
        btn = playbackBtn;
      }
    }
  }
  return btn;
}

Widget buildContestItem(ColorScheme colorScheme, MatchContest contest) {
  return Column(
    mainAxisSize: .min,
    children: [
      if (contest.season?.title != null)
        Text(
          contest.season!.title!,
          style: const TextStyle(fontWeight: .bold, fontSize: 16),
        ),
      Padding(
        padding: const .only(top: 4),
        child: Text.rich(
          TextSpan(
            children: [
              if (contest.gameStage != null) TextSpan(text: contest.gameStage),
              if (contest.contestStatus == 3)
                TextSpan(
                  text: '    ${DateFormatUtils.dateFormat(contest.stime)} 已结束',
                )
              else if (contest.contestStatus == 1 && contest.stime != null)
                TextSpan(
                  text:
                      '    ${DateFormatUtils.format(
                        contest.stime,
                        format: DateFormat('yy-MM-dd HH:mm'),
                      )}',
                ),
            ],
          ),
          style: TextStyle(fontSize: 13, color: colorScheme.outline),
        ),
      ),
      const SizedBox(height: 5),
      TeamInfoLayout(
        homeTeam: buildTeamInfo(contest.homeTeam!),
        status: Text(
          contest.contestStatus == 1
              ? 'VS'
              : '${contest.homeScore ?? 0} : ${contest.awayScore ?? 0}',
          style: const TextStyle(
            fontSize: 25,
            fontWeight: .bold,
            letterSpacing: 1.5,
          ),
        ),
        awayTeam: buildTeamInfo(contest.awayTeam!),
      ),
      const SizedBox(height: 10),
      ?buildMatchBtn(colorScheme, contest),
    ],
  );
}
