import 'package:PiliPlus/pages/music/wish_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('wish count changes once when status changes', () {
    expect(
      reconcileWishCount(
        count: 3,
        currentStatus: false,
        desiredStatus: true,
      ),
      4,
    );
    expect(
      reconcileWishCount(
        count: 4,
        currentStatus: true,
        desiredStatus: false,
      ),
      3,
    );
  });

  test('wish count is unchanged when refreshed state already matches', () {
    expect(
      reconcileWishCount(
        count: 4,
        currentStatus: true,
        desiredStatus: true,
      ),
      4,
    );
  });

  test('wish count remains nullable and never underflows', () {
    expect(
      reconcileWishCount(
        count: null,
        currentStatus: false,
        desiredStatus: true,
      ),
      isNull,
    );
    expect(
      reconcileWishCount(
        count: 0,
        currentStatus: true,
        desiredStatus: false,
      ),
      0,
    );
  });
}
