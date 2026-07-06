class QuickFavItem {
  final int id;
  String title;

  QuickFavItem({required this.id, required this.title});

  factory QuickFavItem.fromJson(Map<String, dynamic> json) => QuickFavItem(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is QuickFavItem && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
