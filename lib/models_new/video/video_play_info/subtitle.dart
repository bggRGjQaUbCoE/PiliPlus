import 'package:PiliPlus/utils/path_utils.dart';
import 'package:path/path.dart' as path;

class Subtitle implements Comparable<Subtitle> {
  int? id;
  late String lan;
  String? lanDoc;
  String? subtitleUrl;
  int? type;
  bool isAi = false;

  String toPath(String entryDirPath) => path.join(
    entryDirPath,
    PathUtils.subtitleDir,
    '$id${PathUtils.subtitleExt}',
  );

  LocalSubtitle toLocal(String entryDirPath) => LocalSubtitle(
    id: id,
    lan: lan,
    lanDoc: lanDoc,
    type: type,
    isAi: isAi,
    entryDirPath: entryDirPath,
  );

  Subtitle({
    required this.id,
    required this.lan,
    this.lanDoc,
    this.subtitleUrl,
    this.type,
    this.isAi = false,
  });

  Subtitle.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    lan = json["lan"];
    type = json["type"];
    isAi = type == 1;
    lanDoc = '${json["lan_doc"]}${isAi ? '（AI）' : ''}';
    subtitleUrl = json["subtitle_url"];
  }

  @override
  int compareTo(Subtitle other) {
    final thisHasZh = lan.contains('zh');
    final otherHasZh = other.lan.contains('zh');
    if (thisHasZh != otherHasZh) return thisHasZh ? -1 : 1;
    if (isAi != other.isAi) return isAi ? 1 : -1;
    return 0;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lan': lan,
    'type': ?type,
    'lan_doc': ?lanDoc,
  };
}

class LocalSubtitle extends Subtitle {
  late final String path;

  LocalSubtitle({
    required super.id,
    required super.lan,
    required super.lanDoc,
    required super.type,
    required super.isAi,
    required String entryDirPath,
  }) {
    path = toPath(entryDirPath);
  }

  LocalSubtitle._fromLocal(Map<String, dynamic> json, String entryDirPath)
    : super(id: json["id"], lan: json["lan"]) {
    type = json["type"];
    isAi = type == 1;
    lanDoc = json["lan_doc"];
    path = toPath(entryDirPath);
  }

  static List<LocalSubtitle>? fromCache(
    dynamic subtitles,
    String entryDirPath,
  ) {
    if (subtitles == null) return null;
    try {
      return (subtitles as List?)
          ?.map((e) => LocalSubtitle._fromLocal(e, entryDirPath))
          .toList()
        ?..sort();
    } catch (_) {}
    return null;
  }
}
