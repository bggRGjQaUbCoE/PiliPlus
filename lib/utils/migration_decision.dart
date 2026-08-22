enum MigrationAction { none, migrate, keepAsExtraScan }

class MigrationDecision {
  final MigrationAction action;
  final String oldPath;
  final String newPath;

  const MigrationDecision({
    required this.action,
    required this.oldPath,
    required this.newPath,
  });

  static MigrationDecision decide({
    required String oldPath,
    required String newPath,
    required bool hasExistingDownloads,
    required bool userWantsMigrate,
  }) {
    if (oldPath == newPath || !hasExistingDownloads) {
      return MigrationDecision(action: MigrationAction.none, oldPath: oldPath, newPath: newPath);
    }
    return MigrationDecision(
      action: userWantsMigrate ? MigrationAction.migrate : MigrationAction.keepAsExtraScan,
      oldPath: oldPath,
      newPath: newPath,
    );
  }
}
