typedef PlayerListener<T> = void Function(T value);

class PlayerListenerRegistry<T> {
  final Set<PlayerListener<T>> _listeners = {};

  void add(PlayerListener<T> listener) => _listeners.add(listener);

  void remove(PlayerListener<T> listener) => _listeners.remove(listener);

  void clear() => _listeners.clear();

  void notify(T value) {
    for (final listener in List<PlayerListener<T>>.of(_listeners)) {
      listener(value);
    }
  }
}
