class Subtitle {
  String? lan;
  String? lanDoc;
  String? subtitleUrl;
  String? subtitleUrlV2;

  Subtitle({
    this.lan,
    this.lanDoc,
    this.subtitleUrl,
    this.subtitleUrlV2,
  });

  Subtitle.fromJson(Map<String, dynamic> json) {
    lan = json["lan"];
    lanDoc = '${json["lan_doc"]}${lan!.startsWith('ai') ? '（AI）' : ''}';
    subtitleUrl = json["subtitle_url"];
    subtitleUrlV2 = json["subtitle_url_v2"];
  }
}
