import 'package:PiliPlus/models_new/fav/fav_detail/media.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';

class FavDetailData {
  FavFolderInfo? info;
  List<FavDetailItemModel>? medias;
  bool? hasMore;

  FavDetailData({this.info, this.medias, this.hasMore});

  factory FavDetailData.fromJson(
    Map<String, dynamic> json, {
    bool pageDesc = false,
  }) => FavDetailData(
    info: json['info'] == null
        ? null
        : FavFolderInfo.fromJson(json['info'] as Map<String, dynamic>),
    medias:
        (pageDesc
                ? (json['medias'] as List<dynamic>?)?.reversed
                : (json['medias'] as List<dynamic>?))
            ?.map((e) => FavDetailItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
    hasMore: json['has_more'] as bool?,
  );
}
