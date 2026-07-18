int? reconcileWishCount({
  required int? count,
  required bool currentStatus,
  required bool desiredStatus,
}) {
  if (count == null || currentStatus == desiredStatus) {
    return count;
  }
  return desiredStatus ? count + 1 : (count > 0 ? count - 1 : 0);
}
