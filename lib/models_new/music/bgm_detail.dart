import 'package:PiliPlus/models/model_owner.dart';
import 'package:PiliPlus/utils/extension.dart';

class MusicDetail {
  MusicDetail({
    required this.musicTitle,
    required this.originArtist,
    required this.originArtistList,
    required this.mvAid,
    required this.mvCid,
    required this.mvBvid,
    required this.mvIndexOrder,
    required this.mvFav,
    required this.mvLikes,
    required this.mvShares,
    required this.mvCover,
    required this.bgColor,
    required this.mvLyric,
    required this.supportListen,
    required this.wishListen,
    required this.wishCount,
    required this.musicShares,
    required this.musicSource,
    required this.album,
    required this.artists,
    required this.artistsList,
    required this.listenPv,
    required this.achievement,
    required this.musicRank,
    required this.maxListId,
    required this.showChosen,
    required this.hotSongHeat,
    required this.hotSongRank,
    required this.creationRank,
    required this.musicOutUrl,
    // required this.abTest,
    required this.musicComment,
    // required this.musicMaterial,
    required this.isNextgenActivity,
    required this.isOriginal,
    required this.musicHot,
    required this.musicRelation,
    required this.musicPublish,
    // required this.musicAchievementTimeline,
    required this.flowAttr,
  });

  final String? musicTitle;
  final String? originArtist;
  final String? originArtistList;
  final int? mvAid;
  final int? mvCid;
  final String? mvBvid;
  final int? mvIndexOrder;
  final int? mvFav;
  final int? mvLikes;
  final int? mvShares;
  final String? mvCover;
  final String? bgColor;
  final String? mvLyric;
  final bool? supportListen;
  bool? wishListen;
  int? wishCount;
  final int? musicShares;
  final String? musicSource;
  final String? album;
  final List<Artist>? artists;
  final List<Artist>? artistsList;
  final int? listenPv;
  final List<String>? achievement;
  final String? musicRank;
  final int? maxListId;
  final bool? showChosen;
  final HotSongHeat? hotSongHeat;
  final Rank? hotSongRank;
  final Rank? creationRank;
  final String? musicOutUrl;
  //   final dynamic abTest;
  final MusicComment? musicComment;
  //   final dynamic musicMaterial;
  final int? isNextgenActivity;
  final int? isOriginal;
  final int? musicHot;
  final int? musicRelation;
  final String? musicPublish;
  //   final List<dynamic>? musicAchievementTimeline;
  final FlowAttr? flowAttr;

  factory MusicDetail.fromJson(Map<String, dynamic> json) {
    return MusicDetail(
      musicTitle: json["music_title"],
      originArtist: json["origin_artist"],
      originArtistList: json["origin_artist_list"],
      mvAid: json["mv_aid"],
      mvCid: json["mv_cid"],
      mvBvid: json["mv_bvid"],
      mvIndexOrder: json["mv_index_order"],
      mvFav: json["mv_fav"],
      mvLikes: json["mv_likes"],
      mvShares: json["mv_shares"],
      mvCover: json["mv_cover"],
      bgColor: json["bg_color"],
      mvLyric: json["mv_lyric"],
      supportListen: json["support_listen"],
      wishListen: json["wish_listen"],
      wishCount: json["wish_count"],
      musicShares: json["music_shares"],
      musicSource: json["music_source"],
      album: json["album"],
      artists: (json["artists"] as List?)
          ?.map((x) => Artist.fromJson(x))
          .toList(),
      artistsList: (json["artists_list"] as List?)
          ?.map((x) => Artist.fromJson(x))
          .toList(),
      listenPv: json["listen_pv"],
      achievement: (json["achievement"] as List?)?.fromCast(),
      musicRank: json["music_rank"],
      maxListId: json["max_list_id"],
      showChosen: json["show_chosen"],
      hotSongHeat: json["hot_song_heat"] == null
          ? null
          : HotSongHeat.fromJson(json["hot_song_heat"]),
      hotSongRank: json["hot_song_rank"] == null
          ? null
          : Rank.fromJson(json["hot_song_rank"]),
      creationRank: json["creation_rank"] == null
          ? null
          : Rank.fromJson(json["creation_rank"]),
      musicOutUrl: json["music_out_url"],
      musicComment: json["music_comment"] == null
          ? null
          : MusicComment.fromJson(json["music_comment"]),
      isNextgenActivity: json["is_nextgen_activity"],
      isOriginal: json["is_original"],
      musicHot: json["music_hot"],
      musicRelation: json["music_relation"],
      musicPublish: json["music_publish"],
      flowAttr: json["flow_attr"] == null
          ? null
          : FlowAttr.fromJson(json["flow_attr"]),
    );
  }
}

class Artist extends Owner {
  String? identity;
  int? identifyType;

  Artist.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    identity = json["identity"];
    identifyType = json["identify_type"];
  }
}

class Rank {
  Rank({
    required this.lastUpdate,
    required this.highestRank,
    required this.onListTimes,
    required this.listDetail,
  });

  final int? lastUpdate;
  final int? highestRank;
  final int? onListTimes;
  final List<ListDetail>? listDetail;

  factory Rank.fromJson(Map<String, dynamic> json) {
    return Rank(
      lastUpdate: json["last_update"],
      highestRank: json["highest_rank"],
      onListTimes: json["on_list_times"],
      listDetail: (json["list_detail"] as List?)
          ?.map((x) => ListDetail.fromJson(x))
          .toList(),
    );
  }
}

class ListDetail {
  ListDetail({
    required this.date,
    required this.rank,
  });

  final int? date;
  final int? rank;

  factory ListDetail.fromJson(Map<String, dynamic> json) {
    return ListDetail(
      date: json["date"],
      rank: json["rank"],
    );
  }
}

class FlowAttr {
  FlowAttr({
    required this.noShare,
    required this.noComment,
  });

  final bool? noShare;
  final bool? noComment;

  factory FlowAttr.fromJson(Map<String, dynamic> json) {
    return FlowAttr(
      noShare: json["no_share"],
      noComment: json["no_comment"],
    );
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
    required this.state,
    required this.nums,
    required this.oid,
    required this.pageType,
  });

  final int? state;
  final int? nums;
  final int? oid;
  final int? pageType;

  factory MusicComment.fromJson(Map<String, dynamic> json) {
    return MusicComment(
      state: json["state"],
      nums: json["nums"],
      oid: json["oid"],
      pageType: json["page_type"],
    );
  }
}
