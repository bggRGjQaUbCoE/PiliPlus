import 'package:PiliPlus/common/assets.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart';
import 'package:PiliPlus/models_new/video/video_detail/ugc_season.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/controller.dart';
import 'package:PiliPlus/utils/extension/num_ext.dart';
import 'package:material_ui/material_ui.dart';

class SeasonPanel extends StatefulWidget {
  const SeasonPanel({
    super.key,
    this.canTap = true,
    required this.showEpisodes,
    required this.ugcIntroController,
  });

  final bool canTap;
  final ShowEpisodes showEpisodes;
  final UgcIntroController ugcIntroController;

  @override
  State<SeasonPanel> createState() => _SeasonPanelState();
}

class _SeasonPanelState extends State<SeasonPanel> {
  late UgcSeason _ugcSeason;
  int get _sectionIndex => _ugcController.sectionIndex;
  int get _seasonIndex => _ugcController.seasonIndex;

  late ColorScheme colorScheme;
  late final _ugcController = widget.ugcIntroController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorScheme = ColorScheme.of(context);
  }

  @override
  void dispose() {
    _ugcController.indexNotifier.removeListener(_listener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initIfNeeded();
    _ugcController.indexNotifier.addListener(_listener);
  }

  bool _initIfNeeded() {
    final ugcSeason = _ugcController.videoDetail.rawValue.ugcSeason;
    if (ugcSeason == null) return true;
    _ugcSeason = ugcSeason;
    return false;
  }

  void _listener() {
    final dispose = _initIfNeeded();
    if (dispose || !mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(top: 8, left: 2, right: 2),
      child: Material(
        color: colorScheme.onInverseSurface,
        borderRadius: const .all(.circular(6)),
        child: InkWell(
          borderRadius: const .all(.circular(6)),
          onTap: widget.canTap
              ? () => widget.showEpisodes(type: .season)
              : null,
          child: Padding(
            padding: const .fromLTRB(8, 12, 8, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '合集：${_ugcSeason.title}',
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                ),
                const SizedBox(width: 15),
                Image.asset(
                  Assets.livingStatic,
                  color: colorScheme.primary,
                  height: 12,
                  cacheHeight: 12.cacheSize(context),
                  semanticLabel: "正在播放：",
                ),
                const SizedBox(width: 10),
                Text(
                  '${_seasonIndex + 1}/${_ugcSeason.sections![_sectionIndex].episodes!.length}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 13,
                  semanticLabel: '查看',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
