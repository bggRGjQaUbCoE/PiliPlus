class BelowLabel {
  int? tagType;
  String? title;
  String? titleDayColor1;
  String? titleDayColor2;
  String? titleNightColor1;
  String? titleNightColor2;
  int? cornerRadius;
  int? useBoard;
  String? backDayColor1;
  String? backDayColor2;
  String? backNightColor1;
  String? backNightColor2;

  BelowLabel({
    this.tagType,
    this.title,
    this.titleDayColor1,
    this.titleDayColor2,
    this.titleNightColor1,
    this.titleNightColor2,
    this.cornerRadius,
    this.useBoard,
    this.backDayColor1,
    this.backDayColor2,
    this.backNightColor1,
    this.backNightColor2,
  });

  factory BelowLabel.fromJson(Map<String, dynamic> json) => BelowLabel(
    tagType: json['tagType'] as int?,
    title: json['title'] as String?,
    titleDayColor1: json['titleDayColor1'] as String?,
    titleDayColor2: json['titleDayColor2'] as String?,
    titleNightColor1: json['titleNightColor1'] as String?,
    titleNightColor2: json['titleNightColor2'] as String?,
    cornerRadius: json['cornerRadius'] as int?,
    useBoard: json['useBoard'] as int?,
    backDayColor1: json['backDayColor1'] as String?,
    backDayColor2: json['backDayColor2'] as String?,
    backNightColor1: json['backNightColor1'] as String?,
    backNightColor2: json['backNightColor2'] as String?,
  );
}
