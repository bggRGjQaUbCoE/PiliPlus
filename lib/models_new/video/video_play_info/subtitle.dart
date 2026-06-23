class Subtitle implements Comparable<Subtitle> {
  late String lan;
  String? lanDoc;
  String? subtitleUrl;
  String? subtitleUrlV2;
  bool isAi = false;

  Subtitle({
    required this.lan,
    this.lanDoc,
    this.subtitleUrl,
    this.isAi = false,
  });

  Subtitle.fromJson(Map<String, dynamic> json) {
    lan = json["lan"];
    isAi = json["type"] == 1;
    lanDoc = '${json["lan_doc"]}${isAi ? '（AI）' : ''}';
    subtitleUrl = json["subtitle_url"];
    subtitleUrlV2 = json["subtitle_url_v2"];
  }

  @override
  int compareTo(Subtitle other) {
    final thisHasZh = lan.contains('zh');
    final otherHasZh = other.lan.contains('zh');
    if (thisHasZh != otherHasZh) return thisHasZh ? -1 : 1;
    if (isAi != other.isAi) return isAi ? 1 : -1;
    return 0;
  }
}
