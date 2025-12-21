class MsgLikeDetailPage {
  bool? isEnd;

  MsgLikeDetailPage({this.isEnd});

  factory MsgLikeDetailPage.fromJson(Map<String, dynamic> json) =>
      MsgLikeDetailPage(isEnd: json['is_end'] as bool?);
}
