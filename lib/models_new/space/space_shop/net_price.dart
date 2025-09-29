class NetPrice {
  String? netPrice;
  String? priceSymbol;
  String? pricePrefix;

  NetPrice({this.netPrice, this.priceSymbol, this.pricePrefix});

  factory NetPrice.fromJson(Map<String, dynamic> json) => NetPrice(
    netPrice: json['netPrice'] as String?,
    priceSymbol: json['priceSymbol'] as String?,
    pricePrefix: json['pricePrefix'] as String?,
  );
}
