import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/video/play/url.dart' show VideoItem;
import 'package:media_kit_video/media_kit_video.dart'
    show HdrDynamicMetadata, HdrSourceDescriptor;

/// Derives an [HdrSourceDescriptor] hint from playurl API metadata so a
/// first open can take the final route directly and skip the
/// container-probe route discovery.
///
/// Only confident derivations are made: bilibili Dolby Vision DASH streams
/// are consistently HEVC profile 8.4 (HLG base layer, compatibility id 4),
/// and AVC streams are always SDR. Anything else returns null and keeps the
/// ordinary probe path; a wrong guess costs one review correction rebuild,
/// never a wrong route.
abstract final class HdrDescriptorDerivation {
  static HdrSourceDescriptor? fromPlayUrlItem(VideoItem item) {
    // AVC streams on bilibili are always SDR; this covers the default
    // quality of most videos with the same probe-skip benefit. Contradictory
    // metadata (a DV-labeled quality) stays without a hint.
    if (item.codecid == 7 && item.quality != VideoQuality.dolbyVision) {
      return const HdrSourceDescriptor(codec: 'h264');
    }
    if (item.quality == VideoQuality.dolbyVision && item.codecid == 12) {
      return const HdrSourceDescriptor(
        codec: 'hevc',
        transfer: 'hlg',
        primaries: 'bt.2020',
        dynamicMetadata: HdrDynamicMetadata.dolbyVision,
        dvProfile: 8,
        dvCompatibilityId: 4,
        // Bilibili DV DASH is single-layer; an unknown EL would make the
        // native-DV strategy conservatively unsupported.
        enhancementLayer: false,
      );
    }
    return null;
  }
}
