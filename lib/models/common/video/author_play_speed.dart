class AuthorPlaySpeed {
  const AuthorPlaySpeed({
    required this.mid,
    required this.name,
    required this.speed,
  });

  final int mid;
  final String name;
  final double speed;

  factory AuthorPlaySpeed.fromJson(Map json) {
    final midRaw = json['mid'];
    final mid = midRaw is int ? midRaw : int.tryParse(midRaw?.toString() ?? '');
    if (mid == null) {
      throw FormatException('invalid mid: $midRaw');
    }
    final speedRaw = json['speed'];
    final speed = speedRaw is num
        ? speedRaw.toDouble()
        : double.tryParse(speedRaw?.toString() ?? '') ?? 1.0;
    final name = (json['name'] as String?)?.trim();
    return AuthorPlaySpeed(
      mid: mid,
      name: (name == null || name.isEmpty) ? 'UID:$mid' : name,
      speed: speed,
    );
  }

  Map<String, dynamic> toJson() => {
        'mid': mid,
        'name': name,
        'speed': speed,
      };

  AuthorPlaySpeed copyWith({String? name, double? speed}) {
    return AuthorPlaySpeed(
      mid: mid,
      name: name ?? this.name,
      speed: speed ?? this.speed,
    );
  }
}

Map<int, AuthorPlaySpeed> decodeAuthorPlaySpeeds(dynamic raw) {
  final result = <int, AuthorPlaySpeed>{};
  if (raw is! List) return result;
  for (final item in raw) {
    if (item is! Map) continue;
    try {
      final entry = AuthorPlaySpeed.fromJson(item);
      result[entry.mid] = entry;
    } catch (_) {}
  }
  return result;
}

List<Map<String, dynamic>> encodeAuthorPlaySpeeds(
  Map<int, AuthorPlaySpeed> map,
) {
  return map.values.map((e) => e.toJson()).toList(growable: false);
}

double resolvePlaySpeedForAuthor({
  required int? mid,
  required Map<int, AuthorPlaySpeed> authorSpeeds,
  required double defaultSpeed,
}) {
  if (mid == null) return defaultSpeed;
  return authorSpeeds[mid]?.speed ?? defaultSpeed;
}
