abstract class BaseSimpleVideoItemModel {
  late String title;
  String? bvid;
  int? cid;
  String? cover;
  int duration = -1;
  late BaseOwner owner;
  late BaseStat stat;
}

abstract class BaseVideoItemModel extends BaseSimpleVideoItemModel {
  int? aid;
  String? desc;
  int? pubdate;
  List<String>? tags;
  bool isFollowed = false;

  static List<String>? parseTags(dynamic data) {
    final tags = <String>[];

    void addTag(dynamic value) {
      if (value is String) {
        if (value.isNotEmpty) {
          tags.add(value);
        }
      } else if (value is Map) {
        addTag(value['tag_name']);
        addTag(value['tagName']);
        addTag(value['name']);
        addTag(value['title']);
      } else if (value is Iterable) {
        for (final item in value) {
          addTag(item);
        }
      }
    }

    if (data is Map) {
      addTag(data['tag']);
      addTag(data['tags']);
      addTag(data['tag_name']);
      addTag(data['tagName']);
      addTag(data['tag_info']);
      addTag(data['tag_list']);
      final args = data['args'];
      if (args is Map) {
        addTag(args['tag']);
        addTag(args['tags']);
        addTag(args['tag_name']);
      }
    } else {
      addTag(data);
    }

    return tags.isEmpty ? null : tags;
  }
}

abstract class BaseOwner {
  int? mid;
  String? name;
}

abstract class BaseStat {
  int? view;
  int? like;
  int? danmu;
}

class Stat extends BaseStat {
  Stat.fromJson(Map<String, dynamic> json) {
    view = json["view"];
    like = json["like"];
    danmu = json['danmaku'];
  }
}

class PlayStat extends BaseStat {
  PlayStat.fromJson(Map<String, dynamic> json) {
    view = json['play'];
    danmu = json['danmaku'];
  }
}
