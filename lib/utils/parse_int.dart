int? safeToInt(dynamic value) => switch (value) {
  int _ => value,
  String _ => int.tryParse(value),
  num _ => value.toInt(),
  _ => null,
};
