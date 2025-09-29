class BenefitInfo {
  String? prefix;
  String? amount;
  dynamic suffix;

  BenefitInfo({this.prefix, this.amount, this.suffix});

  factory BenefitInfo.fromJson(Map<String, dynamic> json) => BenefitInfo(
    prefix: json['prefix'] as String?,
    amount: json['amount'] as String?,
    suffix: json['suffix'] as dynamic,
  );
}
