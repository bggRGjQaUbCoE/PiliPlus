import 'package:PiliPlus/models/video/play/url.dart';

class CastDashPlan {
  final VideoItem? video;
  final AudioItem? audio;
  final bool isAvailable;

  CastDashPlan({
    this.video,
    this.audio,
    required this.isAvailable,
  });
}

class CastDashTrackSelector {
  static int _codecFamilyPriority(String? codecs) {
    if (codecs == null) return 3;
    final lower = codecs.toLowerCase();
    if (lower.startsWith('avc1')) return 0;
    if (lower.startsWith('hev1') || lower.startsWith('hvc1')) return 1;
    if (lower.startsWith('av01')) return 2;
    return 3;
  }

  static VideoItem? selectVideo(
    List<VideoItem> videos, {
    required int targetQn,
  }) {
    final valid = videos
        .where((v) => v.playUrls.any((u) => u.isNotEmpty))
        .toList();
    if (valid.isEmpty) return null;

    // Pick the best codec family that has at least one track.
    final grouped = <int, List<VideoItem>>{};
    for (final v in valid) {
      final priority = _codecFamilyPriority(v.codecs);
      grouped.putIfAbsent(priority, () => []).add(v);
    }
    final bestFamily = grouped.keys.reduce((a, b) => a < b ? a : b);
    final candidates = grouped[bestFamily]!;

    // Within the family: exact target qn first, else highest qn lower than
    // target, else lowest qn higher than target.
    List<VideoItem> tier;
    bool ascending;
    final exact = candidates.where((v) => (v.id ?? 0) == targetQn).toList();
    if (exact.isNotEmpty) {
      tier = exact;
      ascending = true; // all same qn, direction irrelevant
    } else {
      final below = candidates.where((v) => (v.id ?? 0) < targetQn).toList();
      if (below.isNotEmpty) {
        tier = below;
        ascending = false; // descending: pick highest below
      } else {
        tier = candidates;
        ascending = true; // ascending: pick lowest above
      }
    }

    // Sort by quality, then tie-break by bandwidth: lower non-null first,
    // null last.
    tier.sort((a, b) {
      final aQn = a.id ?? 0;
      final bQn = b.id ?? 0;
      final qnCmp = ascending ? aQn.compareTo(bQn) : bQn.compareTo(aQn);
      if (qnCmp != 0) return qnCmp;
      // Same quality — lower non-null bandwidth first; null sorts after.
      final aBw = a.bandWidth;
      final bBw = b.bandWidth;
      if (aBw == null && bBw == null) return 0;
      if (aBw == null) return 1;
      if (bBw == null) return -1;
      return aBw.compareTo(bBw);
    });

    return tier.first;
  }

  static AudioItem? selectAacAudio(List<AudioItem> audios) {
    final aac = audios.where((a) {
      if (a.codecs == null) return false;
      if (!a.codecs!.toLowerCase().startsWith('mp4a')) return false;
      return a.playUrls.any((u) => u.isNotEmpty);
    }).toList();
    if (aac.isEmpty) return null;

    aac.sort((a, b) {
      final aBw = a.bandWidth ?? 0;
      final bBw = b.bandWidth ?? 0;
      return bBw.compareTo(aBw);
    });
    return aac.first;
  }

  static CastDashPlan plan(
    Dash dash, {
    required int targetVideoQn,
  }) {
    final video = selectVideo(dash.video ?? [], targetQn: targetVideoQn);
    final audio = selectAacAudio(dash.audio ?? []);
    return CastDashPlan(
      video: video,
      audio: audio,
      isAvailable: video != null && audio != null,
    );
  }
}
