import 'package:PiliPlus/plugin/pl_player/backends/mpv/mpv_convert_webp.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/exo_player/exo_convert_webp.dart';
import 'package:PiliPlus/plugin/pl_player/models/animated_webp_converter.dart';
import 'package:PiliPlus/plugin/pl_player/models/webp_preset.dart';
import 'package:get/get_rx/get_rx.dart';

AnimatedWebpConverter createAnimatedWebpConverter({
  required PlPlayerController controller,
  required String url,
  required String outFile,
  required double start,
  required double end,
  RxDouble? progress,
  WebpPreset preset = WebpPreset.def,
}) {
  if (controller.useExoPlayer) {
    final player = controller.exoPlayerController;
    if (player == null) {
      throw StateError('Media3 player is not ready for animated WebP capture');
    }
    return ExoConvertWebp(
      player,
      url,
      outFile,
      start,
      end,
      progress: progress,
      preset: preset,
    );
  }
  return MpvConvertWebp(
    url,
    outFile,
    start,
    end,
    progress: progress,
    preset: preset,
  );
}
