class BgmRecommend {
  BgmRecommend({
    required this.aid,
    required this.bvid,
    required this.indexOrder,
    required this.cid,
    required this.cover,
    required this.title,
    required this.mid,
    required this.upNickName,
    required this.play,
    required this.vt,
    required this.isVt,
    required this.danmu,
    required this.duration,
    required this.label,
    required this.labelList,
    required this.isTop,
    required this.showType,
    required this.clickType,
    required this.jumpUrl,
    required this.vtDisplay,
    required this.aidSource,
    required this.tid,
    required this.subTid,
    required this.subTagName,
    required this.coverMark,
    // required this.districtLabel,
  });

  final int? aid;
  final String? bvid;
  final int? indexOrder;
  final int? cid;
  final String? cover;
  final String? title;
  final int? mid;
  final String? upNickName;
  final int? play;
  final int? vt;
  final int? isVt;
  final int? danmu;
  final int? duration;
  final String? label;
  final List<LabelList>? labelList;
  final bool? isTop;
  final int? showType;
  final int? clickType;
  final String? jumpUrl;
  final String? vtDisplay;
  final int? aidSource;
  final int? tid;
  final int? subTid;
  final String? subTagName;
  final CoverMark? coverMark;
  // final dynamic districtLabel;

  factory BgmRecommend.fromJson(Map<String, dynamic> json) {
    return BgmRecommend(
      aid: json["aid"],
      bvid: json["bvid"],
      indexOrder: json["index_order"],
      cid: json["cid"],
      cover: json["cover"],
      title: json["title"],
      mid: json["mid"],
      upNickName: json["up_nick_name"],
      play: json["play"],
      vt: json["vt"],
      isVt: json["is_vt"],
      danmu: json["danmu"],
      duration: json["duration"],
      label: json["label"],
      labelList: (json["label_list"] as List?)
          ?.map((x) => LabelList.fromJson(x))
          .toList(),
      isTop: json["is_top"],
      showType: json["show_type"],
      clickType: json["click_type"],
      jumpUrl: json["jump_url"],
      vtDisplay: json["vt_display"],
      aidSource: json["aid_source"],
      tid: json["tid"],
      subTid: json["sub_tid"],
      subTagName: json["sub_tag_name"],
      coverMark: json["cover_mark"] == null
          ? null
          : CoverMark.fromJson(json["cover_mark"]),
      // districtLabel: json["district_label"],
    );
  }
}

class CoverMark {
  CoverMark({
    required this.name,
    required this.value,
  });

  final String? name;
  final String? value;

  factory CoverMark.fromJson(Map<String, dynamic> json) {
    return CoverMark(
      name: json["name"],
      value: json["value"],
    );
  }
}

class LabelList {
  LabelList({
    required this.name,
    required this.value,
  });

  final String? name;
  final int? value;

  factory LabelList.fromJson(Map<String, dynamic> json) {
    return LabelList(
      name: json["name"],
      value: json["value"],
    );
  }
}
