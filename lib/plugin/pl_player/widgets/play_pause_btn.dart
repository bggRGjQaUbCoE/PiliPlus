import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:material_ui/material_ui.dart';

class PlayOrPauseButton extends StatefulWidget {
  final PlPlayerController plPlayerController;

  const PlayOrPauseButton({super.key, required this.plPlayerController});

  @override
  PlayOrPauseButtonState createState() => PlayOrPauseButtonState();
}

class PlayOrPauseButtonState extends State<PlayOrPauseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final PlPlayerController player;

  @override
  void initState() {
    super.initState();
    player = widget.plPlayerController;
    controller = AnimationController(
      vsync: this,
      value: player.isPlaying ? 1 : 0,
      duration: const Duration(milliseconds: 200),
    );
    player.addStatusLister(_onStatusChanged);
  }

  void _onStatusChanged(PlayerStatus status) {
    if (status == PlayerStatus.playing) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  void dispose() {
    player.removeStatusLister(_onStatusChanged);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 34,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.plPlayerController.onDoubleTapCenter,
        child: Center(
          child: AnimatedIcon(
            semanticLabel: player.isPlaying ? '暂停' : '播放',
            progress: controller,
            icon: AnimatedIcons.play_pause,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
