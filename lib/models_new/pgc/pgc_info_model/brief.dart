class Brief {
  List<Img>? img;

  Brief({this.img});

  factory Brief.fromJson(Map<String, dynamic> json) =>
      Brief(img: (json['img'] as List?)?.map((e) => Img.fromJson(e)).toList());
}

class Img {
  num aspectRatio;
  String? url;

  Img({required this.aspectRatio, this.url});

  factory Img.fromJson(Map<String, dynamic> json) =>
      Img(aspectRatio: json['aspect_ratio'] ?? 1, url: json['url'] as String?);
}
