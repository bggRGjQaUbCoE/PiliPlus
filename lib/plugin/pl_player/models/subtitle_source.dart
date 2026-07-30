enum PlayerSubtitleFormat {
  webVtt('text/vtt'),
  subRip('application/x-subrip'),
  subStationAlpha('text/x-ssa');

  const PlayerSubtitleFormat(this.mimeType);

  final String mimeType;

  static PlayerSubtitleFormat? fromFileName(String fileName) {
    final normalized = fileName.toLowerCase().split(RegExp(r'[?#]')).first;
    if (normalized.endsWith('.vtt')) {
      return webVtt;
    }
    if (normalized.endsWith('.srt')) {
      return subRip;
    }
    if (normalized.endsWith('.ass') || normalized.endsWith('.ssa')) {
      return subStationAlpha;
    }
    return null;
  }
}

class PlayerSubtitleSource {
  const PlayerSubtitleSource({
    required this.isData,
    required this.id,
    required this.format,
  });

  const PlayerSubtitleSource.webVttData(String data)
    : this(isData: true, id: data, format: PlayerSubtitleFormat.webVtt);

  final bool isData;
  final String id;
  final PlayerSubtitleFormat format;
}
