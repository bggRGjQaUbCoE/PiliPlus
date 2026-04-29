int? safeToInt(dynamic value) => switch (value) {
  int() => value,
  String() => int.tryParse(value),
  num() => value.toInt(),
  _ => null,
};
