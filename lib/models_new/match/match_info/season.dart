class MatchSeason {
  String? title;
  String? logo;

  MatchSeason({
    this.title,
    this.logo,
  });

  factory MatchSeason.fromJson(Map<String, dynamic> json) => MatchSeason(
    title: json['title'] as String?,
    logo: json['logo'] as String?,
  );
}
