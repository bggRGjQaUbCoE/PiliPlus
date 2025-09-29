import 'package:PiliPlus/models_new/space/space_shop/below_label.dart';
import 'package:PiliPlus/models_new/space/space_shop/benefit_info.dart';
import 'package:PiliPlus/models_new/space/space_shop/cover.dart';
import 'package:PiliPlus/models_new/space/space_shop/net_price.dart';
import 'package:PiliPlus/models_new/space/space_shop/report_params.dart';
import 'package:PiliPlus/models_new/space/space_shop/source_desc.dart';
import 'package:PiliPlus/models_new/space/space_shop/source_front_tag.dart';
import 'package:PiliPlus/utils/extension.dart';

class SpaceShopItem {
  String? contentId;
  int? contentType;
  dynamic contentSubType;
  dynamic trackId;
  Cover? cover;
  String? title;
  dynamic subTitle;
  String? cardUrl;
  List<BelowLabel>? belowLabels;
  dynamic topRightLabels;
  dynamic bottomRightLabels;
  dynamic topLeftLabels;
  dynamic bottomLeftLabels;
  List<dynamic>? titleFrontLabels;
  dynamic priceBehindLabels;
  NetPrice? netPrice;
  dynamic userInteractInfos;
  List<BenefitInfo>? benefitInfos;
  ReportParams? reportParams;
  dynamic ichibanItem;
  bool? isMarketItem;
  dynamic remainBoxStr;
  dynamic surpriseTips;
  String? outSchemaUrl;
  int? itemCode;
  dynamic merchantId;
  int? itemSource;
  String? itemSourceName;
  SourceDesc? sourceDesc;
  SourceFrontTag? sourceFrontTag;
  List<String>? openWhiteList;
  bool? sellOut;
  int? status;
  bool? preSaleEnd;
  bool? preSaleNotStart;
  int? jumpType;
  dynamic lrpriceStr;

  SpaceShopItem({
    this.contentId,
    this.contentType,
    this.contentSubType,
    this.trackId,
    this.cover,
    this.title,
    this.subTitle,
    this.cardUrl,
    this.belowLabels,
    this.topRightLabels,
    this.bottomRightLabels,
    this.topLeftLabels,
    this.bottomLeftLabels,
    this.titleFrontLabels,
    this.priceBehindLabels,
    this.netPrice,
    this.userInteractInfos,
    this.benefitInfos,
    this.reportParams,
    this.ichibanItem,
    this.isMarketItem,
    this.remainBoxStr,
    this.surpriseTips,
    this.outSchemaUrl,
    this.itemCode,
    this.merchantId,
    this.itemSource,
    this.itemSourceName,
    this.sourceDesc,
    this.sourceFrontTag,
    this.openWhiteList,
    this.sellOut,
    this.status,
    this.preSaleEnd,
    this.preSaleNotStart,
    this.jumpType,
    this.lrpriceStr,
  });

  factory SpaceShopItem.fromJson(Map<String, dynamic> json) => SpaceShopItem(
    contentId: json['contentId'] as String?,
    contentType: json['contentType'] as int?,
    contentSubType: json['contentSubType'] as dynamic,
    trackId: json['trackId'] as dynamic,
    cover: json['cover'] == null
        ? null
        : Cover.fromJson(json['cover'] as Map<String, dynamic>),
    title: json['title'] as String?,
    subTitle: json['subTitle'] as dynamic,
    cardUrl: json['cardUrl'] as String?,
    belowLabels: (json['belowLabels'] as List<dynamic>?)
        ?.map((e) => BelowLabel.fromJson(e as Map<String, dynamic>))
        .toList(),
    topRightLabels: json['topRightLabels'] as dynamic,
    bottomRightLabels: json['bottomRightLabels'] as dynamic,
    topLeftLabels: json['topLeftLabels'] as dynamic,
    bottomLeftLabels: json['bottomLeftLabels'] as dynamic,
    titleFrontLabels: json['titleFrontLabels'] as List<dynamic>?,
    priceBehindLabels: json['priceBehindLabels'] as dynamic,
    netPrice: json['netPrice'] == null
        ? null
        : NetPrice.fromJson(json['netPrice'] as Map<String, dynamic>),
    userInteractInfos: json['userInteractInfos'] as dynamic,
    benefitInfos: (json['benefitInfos'] as List<dynamic>?)
        ?.map((e) => BenefitInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
    reportParams: json['reportParams'] == null
        ? null
        : ReportParams.fromJson(json['reportParams'] as Map<String, dynamic>),
    ichibanItem: json['ichibanItem'] as dynamic,
    isMarketItem: json['isMarketItem'] as bool?,
    remainBoxStr: json['remainBoxStr'] as dynamic,
    surpriseTips: json['surpriseTips'] as dynamic,
    outSchemaUrl: json['outSchemaUrl'] as String?,
    itemCode: json['itemCode'] as int?,
    merchantId: json['merchantId'] as dynamic,
    itemSource: json['itemSource'] as int?,
    itemSourceName: json['itemSourceName'] as String?,
    sourceDesc: json['sourceDesc'] == null
        ? null
        : SourceDesc.fromJson(json['sourceDesc'] as Map<String, dynamic>),
    sourceFrontTag: json['sourceFrontTag'] == null
        ? null
        : SourceFrontTag.fromJson(
            json['sourceFrontTag'] as Map<String, dynamic>,
          ),
    openWhiteList: (json['openWhiteList'] as List?)?.fromCast(),
    sellOut: json['sellOut'] as bool?,
    status: json['status'] as int?,
    preSaleEnd: json['preSaleEnd'] as bool?,
    preSaleNotStart: json['preSaleNotStart'] as bool?,
    jumpType: json['jumpType'] as int?,
    lrpriceStr: json['lrpriceStr'] as dynamic,
  );
}
