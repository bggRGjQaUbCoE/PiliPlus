const rootRpIdKey = 'comment_root_id';
const secondRpIdKey = 'comment_secondary_id';

(int? rootRpId, int? secondRpId) parseCommentId(
  Map<String, String> queryParameters,
) {
  final root = queryParameters[rootRpIdKey];
  final secondary = queryParameters[secondRpIdKey];
  return (
    root == null ? null : int.tryParse(root),
    secondary == null ? null : int.tryParse(secondary),
  );
}
