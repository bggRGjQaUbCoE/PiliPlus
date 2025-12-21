class HistoryTab {
  String? type;
  String? name;

  HistoryTab({this.type, this.name});

  factory HistoryTab.fromJson(Map<String, dynamic> json) =>
      HistoryTab(type: json['type'] as String?, name: json['name'] as String?);
}
