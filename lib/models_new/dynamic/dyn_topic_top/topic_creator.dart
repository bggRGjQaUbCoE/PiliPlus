class TopicCreator {
  int? uid;
  String? face;
  String? name;

  TopicCreator({this.uid, this.face, this.name});

  factory TopicCreator.fromJson(Map<String, dynamic> json) => TopicCreator(
    uid: json['uid'] as int?,
    face: json['face'] as String?,
    name: json['name'] as String?,
  );
}
