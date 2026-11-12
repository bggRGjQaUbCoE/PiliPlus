class UinfoMedal {
  String? name;
  int? level;
  int? id;
  int? ruid;
  String? v2MedalColorStart;
  String? v2MedalColorText;

  UinfoMedal({
    this.name,
    this.level,
    this.id,
    this.ruid,
    this.v2MedalColorStart,
    this.v2MedalColorText,
  });

  factory UinfoMedal.fromJson(Map<String, dynamic> json) => UinfoMedal(
    name: json['name'] as String?,
    level: json['level'] as int?,
    id: json['id'] as int?,
    ruid: json['ruid'] as int?,
    v2MedalColorStart: json['v2_medal_color_start'] as String?,
    v2MedalColorText: json['v2_medal_color_text'] as String?,
  );

  static UinfoMedal? lightMedal(Map<String, dynamic>? json) {
    if (json == null || json['is_light'] != 1) return null;
    return .fromJson(json);
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'level': level,
    'id': id,
    'ruid': ruid,
    'v2_medal_color_start': v2MedalColorStart,
    'v2_medal_color_text': v2MedalColorText,
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is UinfoMedal) {
      return id == other.id &&
          level == other.level &&
          name == other.name &&
          ruid == other.ruid &&
          v2MedalColorStart == other.v2MedalColorStart &&
          v2MedalColorText == other.v2MedalColorText;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(
    id,
    level,
    name,
    ruid,
    v2MedalColorStart,
    v2MedalColorText,
  );
}
