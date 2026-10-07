class MatchTeam {
  String? title;
  String? logo;
  String? logoFull;

  MatchTeam({
    this.title,
    this.logo,
    this.logoFull,
  });

  factory MatchTeam.fromJson(Map<String, dynamic> json) => MatchTeam(
    title: json['title'] as String?,
    logo: json['logo'] as String?,
    logoFull: json['logoFull'] as String?,
  );
}
