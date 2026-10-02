import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart'
    show MultiSelectData;

class DownloadFolder with MultiSelectData {
  final String id;
  String title;
  final int createdAt;
  final String? sourceKey;
  bool isCustomTitle;
  final List<int> videoCids;

  DownloadFolder({
    required this.id,
    required this.title,
    required this.createdAt,
    this.sourceKey,
    this.isCustomTitle = false,
    required this.videoCids,
  });

  factory DownloadFolder.fromJson(Map<String, dynamic> json) => DownloadFolder(
    id: json['id'] as String,
    title: json['title'] as String? ?? '',
    createdAt: json['createdAt'] as int? ?? 0,
    sourceKey: json['sourceKey'] as String?,
    isCustomTitle: json['isCustomTitle'] as bool? ?? false,
    videoCids: (json['videoCids'] as List? ?? const <dynamic>[])
        .whereType<int>()
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'createdAt': createdAt,
    'sourceKey': sourceKey,
    'isCustomTitle': isCustomTitle,
    'videoCids': videoCids,
  };
}

enum DownloadPlaylistScope {
  all,
  folder,
}

class DownloadVideoPlayContext {
  final DownloadPlaylistScope scope;
  final String? folderId;

  const DownloadVideoPlayContext._({
    required this.scope,
    this.folderId,
  });

  const DownloadVideoPlayContext.all()
    : this._(scope: DownloadPlaylistScope.all);

  const DownloadVideoPlayContext.folder(String folderId)
    : this._(
        scope: DownloadPlaylistScope.folder,
        folderId: folderId,
      );

  Map<String, dynamic> toArguments() => {
    'downloadPlaylistScope': scope.name,
    if (folderId != null) 'downloadFolderId': folderId,
  };

  static DownloadVideoPlayContext? fromArguments(Map args) {
    final scopeName = args['downloadPlaylistScope'];
    if (scopeName is! String) {
      return null;
    }
    try {
      final scope = DownloadPlaylistScope.values.byName(scopeName);
      return switch (scope) {
        DownloadPlaylistScope.all => const DownloadVideoPlayContext.all(),
        DownloadPlaylistScope.folder =>
          args['downloadFolderId'] is String
              ? DownloadVideoPlayContext.folder(
                  args['downloadFolderId'] as String,
                )
              : null,
      };
    } catch (_) {
      return null;
    }
  }
}

typedef DownloadEntryMap = Map<int, BiliDownloadEntryInfo>;

class DownloadContinueRecord {
  final int cid;
  final int updatedAt;
  final DownloadPlaylistScope scope;
  final String? folderId;

  const DownloadContinueRecord({
    required this.cid,
    required this.updatedAt,
    required this.scope,
    this.folderId,
  });

  static DownloadContinueRecord? fromJson(Object? raw) {
    if (raw is! Map) {
      return null;
    }
    final json = raw.cast<dynamic, dynamic>();
    final cid = switch (json['cid']) {
      final int value => value,
      final String value => int.tryParse(value),
      _ => null,
    };
    final updatedAt = json['updatedAt'];
    final scopeName = json['scope'];
    if (cid == null || updatedAt is! int || scopeName is! String) {
      return null;
    }
    final DownloadPlaylistScope scope;
    try {
      scope = DownloadPlaylistScope.values.byName(scopeName);
    } catch (_) {
      return null;
    }
    final rawFolderId = json['folderId'];
    final folderId = rawFolderId is String ? rawFolderId : null;
    if (scope == DownloadPlaylistScope.folder &&
        (folderId == null || folderId.isEmpty)) {
      return null;
    }
    return DownloadContinueRecord(
      cid: cid,
      updatedAt: updatedAt,
      scope: scope,
      folderId: folderId,
    );
  }

  Map<String, dynamic> toJson() => {
    'cid': cid,
    'updatedAt': updatedAt,
    'scope': scope.name,
    'folderId': ?folderId,
  };
}

class DownloadContinueTarget {
  final BiliDownloadEntryInfo entry;
  final DownloadVideoPlayContext playContext;
  final int progressMs;
  final int durationMs;

  const DownloadContinueTarget({
    required this.entry,
    required this.playContext,
    required this.progressMs,
    required this.durationMs,
  });
}
