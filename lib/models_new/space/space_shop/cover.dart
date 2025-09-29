class Cover {
  String? url;
  String? imgWh;
  int? height;
  int? width;
  dynamic size;

  Cover({this.url, this.imgWh, this.height, this.width, this.size});

  factory Cover.fromJson(Map<String, dynamic> json) => Cover(
    url: json['url'] as String?,
    imgWh: json['imgWH'] as String?,
    height: json['height'] as int?,
    width: json['width'] as int?,
    size: json['size'] as dynamic,
  );
}
