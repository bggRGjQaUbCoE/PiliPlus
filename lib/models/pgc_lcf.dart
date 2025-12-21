class PgcLCF {
  num? coinNumber;
  int? favorite;
  int? isOriginal;
  int? like;

  PgcLCF({this.coinNumber, this.favorite, this.isOriginal, this.like});

  factory PgcLCF.fromJson(Map<String, dynamic> json) => PgcLCF(
    coinNumber: json["coin_number"],
    favorite: json["favorite"],
    isOriginal: json["is_original"],
    like: json["like"],
  );
}
