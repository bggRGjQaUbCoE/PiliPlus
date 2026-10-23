int? safeToInt(dynamic value) => switch (value) {
  int _ => value,
  String _ => int.tryParse(value),
  num _ => value.toInt(),
  _ => null,
};

double? parseDimension(dynamic value) {
  if (value is num && value > 0) {
    return value.toDouble();
  }
  return null;
}
