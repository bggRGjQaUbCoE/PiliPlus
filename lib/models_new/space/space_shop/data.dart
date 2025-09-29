import 'package:PiliPlus/models_new/space/space_shop/item.dart';

class SpaceShopData {
  List<SpaceShopItem>? data;
  bool? showMoreTab;
  String? clickUrl;
  String? showMoreDesc;
  bool? haveNextPage;
  int? nextSearchAfter;

  SpaceShopData({
    this.data,
    this.showMoreTab,
    this.clickUrl,
    this.showMoreDesc,
    this.haveNextPage,
    this.nextSearchAfter,
  });

  factory SpaceShopData.fromJson(Map<String, dynamic> json) => SpaceShopData(
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => SpaceShopItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    showMoreTab: json['showMoreTab'] as bool?,
    clickUrl: json['clickUrl'] as String?,
    showMoreDesc: json['showMoreDesc'] as String?,
    haveNextPage: json['haveNextPage'] as bool?,
    nextSearchAfter: json['nextSearchAfter'] as int?,
  );
}
