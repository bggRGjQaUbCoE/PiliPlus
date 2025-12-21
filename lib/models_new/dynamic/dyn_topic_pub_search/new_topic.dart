class NewTopic {
  String? name;

  NewTopic({this.name});

  factory NewTopic.fromJson(Map<String, dynamic> json) =>
      NewTopic(name: json['name'] as String?);
}
