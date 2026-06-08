import 'package:PiliPlus/models/model_owner.dart';

class MusicDetail {
  MusicDetail({
    required this.musicTitle,
    required this.originArtist,
    required this.originArtistList,
    required this.mvAid,
    required this.mvCid,
    required this.mvBvid,
    required this.mvCover,
    required this.wishListen,
    required this.wishCount,
    required this.musicSource,
    required this.album,
    required this.artistsList,
    required this.listenPv,
    required this.achievement,
    required this.hotSongHeat,
    required this.musicComment,
    required this.musicRelation,
    required this.musicPublish,
  });

  final String? musicTitle;
  final String? originArtist;
  final String? originArtistList;
  final int? mvAid;
  final int mvCid;
  final String? mvBvid;
  final String? mvCover;
  bool? wishListen;
  int? wishCount;
  final String? musicSource;
  final String? album;
  final List<Artist>? artistsList;
  final int? listenPv;
  final List<String> achievement;
  final HotSongHeat? hotSongHeat;
  final MusicComment? musicComment;
  final int? musicRelation;
  final String? musicPublish;

  factory MusicDetail.fromJson(Map<String, dynamic> json) {
    return MusicDetail(
      musicTitle: json["music_title"],
      originArtist: json["origin_artist"],
      originArtistList: json["origin_artist_list"],
      mvAid: json["mv_aid"],
      mvCid: json["mv_cid"] ?? 0,
      mvBvid: json["mv_bvid"],
      mvCover: json["mv_cover"],
      wishListen: json["wish_listen"],
      wishCount: json["wish_count"],
      musicSource: json["music_source"],
      album: json["album"],
      artistsList: (json["artists_list"] as List?)
          ?.map((x) => Artist.fromJson(x))
          .toList(),
      listenPv: json["listen_pv"],
      achievement: [
        ...?json["achievement"],
        ?json["music_rank"],
        ?json["recreation_rank"],
      ],
      hotSongHeat: json["hot_song_heat"] == null
          ? null
          : HotSongHeat.fromJson(json["hot_song_heat"]),
      musicComment: json["music_comment"] == null
          ? null
          : MusicComment.fromJson(json["music_comment"]),
      musicRelation: json["music_relation"],
      musicPublish: json["music_publish"],
    );
  }
}

class Artist extends Owner {
  String? identity;

  Artist.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    identity = json["identity"];
  }
}

class HotSongHeat {
  HotSongHeat({
    required this.lastHeat,
    required this.songHeat,
  });

  final int? lastHeat;
  final List<SongHeat>? songHeat;

  factory HotSongHeat.fromJson(Map<String, dynamic> json) {
    return HotSongHeat(
      lastHeat: json["last_heat"],
      songHeat: (json["song_heat"] as List?)?.reversed
          .map((x) => SongHeat.fromJson(x))
          .toList(),
    );
  }
}

class SongHeat {
  SongHeat({
    required this.date,
    required this.heat,
  });

  final int date;
  final int heat;

  factory SongHeat.fromJson(Map<String, dynamic> json) {
    return SongHeat(
      date: json["date"],
      heat: json["heat"],
    );
  }
}

class MusicComment {
  MusicComment({
    required this.nums,
    required this.oid,
    required this.pageType,
  });

  final int? nums;
  final int? oid;
  final int? pageType;

  factory MusicComment.fromJson(Map<String, dynamic> json) {
    return MusicComment(
      nums: json["nums"],
      oid: json["oid"],
      pageType: json["page_type"],
    );
  }
}
