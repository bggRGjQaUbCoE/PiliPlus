/// Preserve the original EDL directives & per-Media extras; rewrite only exact
/// length-prefixed network resource tokens, never incidental query substrings.
String rewriteMediaSource(
  String media,
  String oldVideo,
  String? oldAudio,
  String video,
  String? audio,
) {
  if (media == oldVideo) return video;
  if (oldAudio != null && media == oldAudio) return audio ?? oldAudio;
  if (!media.startsWith('edl://')) throw StateError('unsupported-media');
  var result = media;
  for (final pair in [(oldVideo, video), (oldAudio, audio)]) {
    final (old, replacement) = pair;
    if (old == null ||
        old.isEmpty ||
        replacement == null ||
        old == replacement) {
      continue;
    }
    final token = '%${old.length}%$old';
    if (!result.contains(token)) throw StateError('missing-edl-resource');
    result = result.replaceAll(token, '%${replacement.length}%$replacement');
  }
  return result;
}
