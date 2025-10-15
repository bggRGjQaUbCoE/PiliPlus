class RejectPage {
  String? title;
  String? text;
  String? img;

  RejectPage({this.title, this.text, this.img});

  factory RejectPage.fromJson(Map<String, dynamic> json) => RejectPage(
    title: json['title'] as String?,
    text: json['text'] as String?,
    img: json['img'] as String?,
  );
}
