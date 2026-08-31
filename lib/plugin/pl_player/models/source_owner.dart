import 'dart:collection';

typedef PlayerSourceOperation = Future<void> Function(
  bool Function() isCurrent,
);

final class PlayerSourceCoordinator {
  final Set<Object> _owners = HashSet<Object>.identity();
  Object? _activeOwner;
  int _revision = 0;
  Future<void> _tail = Future<void>.value();

  bool get hasOwners => _owners.isNotEmpty;
  int get ownerCount => _owners.length;

  void register(Object owner) => _owners.add(owner);

  bool isActive(Object owner) => identical(_activeOwner, owner);

  bool release(Object owner) {
    final removed = _owners.remove(owner);
    if (removed && identical(_activeOwner, owner)) {
      _activeOwner = null;
      _revision += 1;
    }
    return removed;
  }

  void clear() {
    _owners.clear();
    _activeOwner = null;
    _revision += 1;
  }

  Future<void> run(Object owner, PlayerSourceOperation operation) {
    if (!_owners.contains(owner)) {
      return Future<void>.value();
    }

    _activeOwner = owner;
    final revision = ++_revision;
    bool isCurrent() =>
        _owners.contains(owner) &&
        identical(_activeOwner, owner) &&
        revision == _revision;

    final result = _tail.then((_) async {
      if (isCurrent()) {
        await operation(isCurrent);
      }
    });
    _tail = result.then<void>((_) {}, onError: (_, _) {});
    return result;
  }
}
