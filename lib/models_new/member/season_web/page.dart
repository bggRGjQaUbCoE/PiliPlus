class Page {
  int? pageNum;
  int? pageSize;
  int? total;

  Page({this.pageNum, this.pageSize, this.total});

  factory Page.fromJson(Map<String, dynamic> json) => Page(
    pageNum: json['page_num'] ?? json['num'],
    pageSize: json['page_size'] ?? json['size'],
    total: json['total'] as int?,
  );
}
