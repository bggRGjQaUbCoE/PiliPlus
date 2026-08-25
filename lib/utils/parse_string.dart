@pragma('vm:prefer-inline')
String? nonNullOrEmptyString(String? value) {
  if (value == null || value.isEmpty) return null;
  return value;
}

@pragma('vm:prefer-inline')
int? parseIntOrNull(String? value) {
  if (value == null) return null;
  return int.tryParse(value);
}
