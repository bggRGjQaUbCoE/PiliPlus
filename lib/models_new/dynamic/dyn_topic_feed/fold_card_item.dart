class FoldCardItem {
  int? foldCount;
  String? foldDesc;

  FoldCardItem({this.foldCount, this.foldDesc});

  factory FoldCardItem.fromJson(Map<String, dynamic> json) => FoldCardItem(
    foldCount: json['fold_count'] as int?,
    foldDesc: json['fold_desc'] as String?,
  );
}
