final class IdentityKey<T extends Object> {
  const IdentityKey(this.value);

  final T value;

  @override
  int get hashCode => identityHashCode(value);

  @override
  bool operator ==(Object other) =>
      other is IdentityKey && identical(value, other.value);
}
