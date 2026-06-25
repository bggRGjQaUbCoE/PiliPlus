class DynReactionItem {
  String? action;
  String? face;
  String? mid;
  String? name;

  DynReactionItem({
    this.action,
    this.face,
    this.mid,
    this.name,
  });

  factory DynReactionItem.fromJson(Map<String, dynamic> json) =>
      DynReactionItem(
        action: json['action'] as String?,
        face: json['face'] as String?,
        mid: json['mid'] as String?,
        name: json['name'] as String?,
      );
}
