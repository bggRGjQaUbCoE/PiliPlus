class UpAction {
  bool? like;
  bool? reply;

  UpAction({this.like, this.reply});

  factory UpAction.fromJson(Map<String, dynamic> json) =>
      UpAction(like: json['like'] as bool?, reply: json['reply'] as bool?);
}
