extension MapExt<K, V> on Map<K, V> {
  Map<RK, RV> fromCast<RK, RV>() {
    return Map<RK, RV>.from(this);
  }
}
